"""Temporary integration-only observer, copied outside the candidate before checkout.

Run under strace in the manual workflow. Timing is not performance evidence.
The runner retains its existing cancellation and job deadline ownership.
"""
import os
import re
import shutil
import signal
import subprocess
import sys


def main():
    if len(sys.argv) != 2 or not re.fullmatch(r"[0-9a-f]{40}", sys.argv[1]):
        print("DELTA_PROBE_INPUT_FAILED expected immutable base SHA", flush=True)
        return 2
    for tool in ("make", "stdbuf", "vmstat"):
        if shutil.which(tool) is None:
            print(f"DELTA_PROBE_INPUT_FAILED missing={tool}", flush=True)
            return 2
    sampler = command = None
    received = 0

    def stop_sampler():
        if sampler is not None:
            # Only our disposable diagnostic child: immediate kill + reap, no
            # grace timer, process-group selection, or detached cleanup helper.
            sampler.kill()
            sampler.wait()

    def cancelled(number, _frame):
        nonlocal received
        received = number
        print(f"DELTA_PROBE_SIGNAL signal={signal.Signals(number).name} pid={os.getpid()}", flush=True)
        signal.signal(number, signal.SIG_DFL)  # A repeated signal remains fatal.
        stop_sampler()
        if command is None:
            raise SystemExit(128 + number)
        # Forward to the one handle we started; strace distinguishes this
        # wrapper-sent signal from the original sender. Host owns the full tree.
        command.send_signal(number)

    for number in (signal.SIGHUP, signal.SIGINT, signal.SIGTERM):
        signal.signal(number, cancelled)
    try:
        sampler = subprocess.Popen(["stdbuf", "-oL", "vmstat", "-w", "-t", "1"])
        command = subprocess.Popen(["make", "delta", "BASE=" + sys.argv[1]])
        print(f"DELTA_PROBE_BEGIN pid={os.getpid()} ppid={os.getppid()} command_pid={command.pid} sampler_pid={sampler.pid}", flush=True)
        status = command.wait()
        if sampler.poll() is not None and not received:
            print(f"DELTA_PROBE_SAMPLE_UNAVAILABLE exit={sampler.returncode}", flush=True)
    finally:
        stop_sampler()
    status = 128 + received if received else (128 - status if status < 0 else status)
    print(f"DELTA_PROBE_RESULT exit={status} signal={received} sampler_exit={sampler.returncode}", flush=True)
    return status


if __name__ == "__main__":
    raise SystemExit(main())
