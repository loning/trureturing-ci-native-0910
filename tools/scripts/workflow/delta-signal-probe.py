"""Temporary integration-only observer, copied outside the candidate before checkout.

Python is the foreground step entry and owns all three direct children.
An attached strace observes original siginfo and our forwarding separately.
Timing is not performance evidence.
The runner retains its existing cancellation and job deadline ownership.
"""
import ctypes
import os
from pathlib import Path
import re
import shutil
import signal
import subprocess
import sys


def start_tracer():
    if sys.platform != "linux" or shutil.which("strace") is None:
        raise RuntimeError("Linux and strace required")
    # Yama normally disallows a child attaching to its parent. Grant ptrace
    # access on this observer only (no host sysctl/sudo), before spawning it.
    # PR_SET_PTRACER_ANY also covers the short Popen startup interval.
    libc = ctypes.CDLL(None, use_errno=True)
    if libc.prctl(0x59616d61, ctypes.c_ulong(-1), 0, 0, 0) != 0:
        raise OSError(ctypes.get_errno(), "PR_SET_PTRACER")
    return subprocess.Popen(["strace", "-I", "2", "-f", "-ttt", "-s", "160",
        "-e", "trace=%process,kill,tkill,tgkill,rt_sigqueueinfo,rt_tgsigqueueinfo",
        "-e", "signal=SIGHUP,SIGINT,SIGTERM,SIGKILL", "-p", str(os.getpid())])


def main():
    if len(sys.argv) != 2 or not re.fullmatch(r"[0-9a-f]{40}", sys.argv[1]):
        print("DELTA_PROBE_INPUT_FAILED expected immutable base SHA", flush=True)
        return 2
    for tool in ("make", "stdbuf", "vmstat"):
        if shutil.which(tool) is None:
            print(f"DELTA_PROBE_INPUT_FAILED missing={tool}", flush=True)
            return 2
    sampler = command = tracer = None
    received = 0
    forwarded = False

    def stop_sampler():
        if sampler is not None:
            # Only our disposable diagnostic child: immediate kill + reap, no
            # grace timer, process-group selection, or detached cleanup helper.
            sampler.kill()
            sampler.wait()

    def cancelled(number, _frame):
        nonlocal received, forwarded
        received = number
        print(f"DELTA_PROBE_SIGNAL signal={signal.Signals(number).name} pid={os.getpid()}", flush=True)
        signal.signal(number, signal.SIG_DFL)  # A repeated signal remains fatal.
        stop_sampler()
        if command is not None:
            # The make handle is our direct child, never the tracer. strace
            # records our PID as sender, distinct from incoming siginfo.
            print(f"DELTA_PROBE_FORWARD signal={number} sender_pid={os.getpid()} command_pid={command.pid}", flush=True)
            forwarded = True
            command.send_signal(number)

    for number in (signal.SIGHUP, signal.SIGINT, signal.SIGTERM):
        signal.signal(number, cancelled)
    try:
        tracer = start_tracer()
        if tracer is not None:
            # Wait for actual attachment before forking anything to observe.
            # The existing runner deadline owns a stuck attach, no new timer.
            while f"TracerPid:\t{tracer.pid}\n" not in Path("/proc/self/status").read_text():
                if received:
                    return 128 + received
                if tracer.poll() is not None:
                    raise RuntimeError(f"strace attach failed: {tracer.returncode}")
                os.sched_yield()
            print(f"DELTA_PROBE_TRACE_READY pid={os.getpid()} tracer_pid={tracer.pid}", flush=True)
        if received:
            return 128 + received
        sampler = subprocess.Popen(["stdbuf", "-oL", "vmstat", "-w", "-t", "1"])
        if received:
            return 128 + received
        command = subprocess.Popen(["make", "delta", "BASE=" + sys.argv[1]])
        if received and not forwarded:
            command.send_signal(received)  # Signal arrived during Popen.
        print(f"DELTA_PROBE_BEGIN pid={os.getpid()} ppid={os.getppid()} command_pid={command.pid} sampler_pid={sampler.pid}", flush=True)
        status = command.wait()
        if sampler.poll() is not None and not received:
            print(f"DELTA_PROBE_SAMPLE_UNAVAILABLE exit={sampler.returncode}", flush=True)
    finally:
        stop_sampler()
        if tracer is not None:
            # In -p mode strace has no launched child to signal: -I 2 cleanup
            # detaches tracees. Stop it only after command/sampler are reaped.
            # A group signal can already have ended tracing; report that fact.
            prior = tracer.poll()
            tracer.terminate()
            tracer.wait()
            print(f"DELTA_PROBE_TRACE_END prior_exit={prior} exit={tracer.returncode}", flush=True)
    status = 128 + received if received else (128 - status if status < 0 else status)
    print(f"DELTA_PROBE_RESULT exit={status} signal={received} sampler_exit={sampler.returncode}", flush=True)
    return status


if __name__ == "__main__":
    raise SystemExit(main())
