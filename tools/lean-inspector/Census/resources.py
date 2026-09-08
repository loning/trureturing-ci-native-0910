"""Bound census subprocesses and preserve measurements even on rejection."""

from __future__ import annotations

import argparse
import json
import os
import pathlib
import re
import signal
import subprocess
import sys
import time


class ResourceRejected(RuntimeError):
    pass


def check_budget(free_percent, rss_bytes, budget_bytes):
    if free_percent < 30:
        raise ResourceRejected(f"free_memory={free_percent}% below 30%")
    if rss_bytes > budget_bytes:
        raise ResourceRejected(f"rss={rss_bytes} exceeds budget={budget_bytes}")


def free_memory():
    if sys.platform == "darwin":
        reading = subprocess.check_output(["memory_pressure"], text=True)
        match = re.search(r"System-wide memory free percentage: (\d+)%", reading)
        if not match:
            raise ResourceRejected("memory_pressure reading unavailable")
        return int(match[1])
    values = dict(line.split(":", 1) for line in pathlib.Path("/proc/meminfo").read_text().splitlines())
    return 100 * int(values["MemAvailable"].split()[0]) // int(values["MemTotal"].split()[0])


def process_rss(pid):
    table = subprocess.check_output(["ps", "-axo", "pid=,ppid=,rss="], text=True)
    processes = [tuple(map(int, line.split())) for line in table.splitlines() if line.strip()]
    descendants = {pid}
    while True:
        expanded = descendants | {child for child, parent, _ in processes if parent in descendants}
        if expanded == descendants:
            break
        descendants = expanded
    return max((rss * 1024 for child, _, rss in processes if child in descendants), default=0)


def run(command, directory, label, *, cwd=None, env=None, budget_gb=8):
    """The owner-requested safety limit is 8 GiB, with exactly one active child job.

    RSS sampling bounds individual descendants; time also records the OS high-water
    mark. A rejected process is killed and waited for before another job can start.
    """
    directory = pathlib.Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    started = time.monotonic()
    measurement = {"label": label, "command": command, "rss_budget_gib": budget_gb,
                   "peak_rss_bytes": 0, "memory_readings": [], "status": "rejected"}
    proc = None
    timing_path = directory / f"{label}.time.log"
    try:
        free = free_memory()
        measurement["memory_readings"].append({"seconds": 0, "free_percent": free})
        check_budget(free, 0, budget_gb * 1024 ** 3)
        flag = "-l" if sys.platform == "darwin" else "-v"
        with (directory / f"{label}.log").open("w") as output:
            proc = subprocess.Popen(["/usr/bin/time", flag, "-o", str(timing_path), *command],
                                    cwd=cwd, env=env, stdout=output, stderr=subprocess.STDOUT,
                                    start_new_session=True)
            next_memory_check = started
            while True:
                rss = process_rss(proc.pid)
                measurement["peak_rss_bytes"] = max(measurement["peak_rss_bytes"], rss)
                now = time.monotonic()
                if now >= next_memory_check:
                    free = free_memory()
                    measurement["memory_readings"].append(
                        {"seconds": round(now - started, 3), "free_percent": free})
                    next_memory_check = now + 5
                check_budget(free, rss, budget_gb * 1024 ** 3)
                try:
                    result = proc.wait(timeout=0.2)
                    break
                except subprocess.TimeoutExpired:
                    continue
        measurement["exit_code"] = result
        timing = timing_path.read_text()
        pattern = (r"(\d+)\s+maximum resident set size" if sys.platform == "darwin"
                   else r"Maximum resident set size \(kbytes\):\s*(\d+)")
        match = re.search(pattern, timing)
        if match:
            peak = int(match[1]) * (1 if sys.platform == "darwin" else 1024)
            measurement["peak_rss_bytes"] = max(measurement["peak_rss_bytes"], peak)
        check_budget(free, measurement["peak_rss_bytes"], budget_gb * 1024 ** 3)
        if result:
            raise RuntimeError(f"{label}: command exited {result}; see {directory / (label + '.log')}")
        measurement["status"] = "completed"
        return measurement
    except BaseException as error:
        measurement["error"] = str(error)
        if proc is not None and proc.poll() is None:
            os.killpg(proc.pid, signal.SIGKILL)
            proc.wait()
        raise
    finally:
        measurement["wall_seconds"] = round(time.monotonic() - started, 3)
        (directory / f"{label}.resources.json").write_text(json.dumps(measurement, indent=2) + "\n")
        print(json.dumps({"step": label, "status": measurement["status"],
                          "seconds": measurement["wall_seconds"],
                          "peak_rss_gib": round(measurement["peak_rss_bytes"] / 1024 ** 3, 3)}), flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", required=True)
    parser.add_argument("--label", required=True)
    parser.add_argument("command", nargs=argparse.REMAINDER)
    options = parser.parse_args()
    command = options.command[1:] if options.command[:1] == ["--"] else options.command
    run(command, options.directory, options.label)
