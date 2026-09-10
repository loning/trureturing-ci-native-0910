"""Disposable commands only. --linux-selftest requires real strace; no delta runs.

The two local ScriptTests cases bypass only tracer attachment on macOS. The
manual Linux path uses the deployed entry argv and never substitutes strace.
"""
import contextlib
import ctypes
import hashlib
import json
import os
import pathlib
import re
import shutil
import signal
import subprocess
import sys
import tempfile
import unittest

REPO = pathlib.Path(__file__).resolve().parents[4]
PROBE = REPO / "tools/scripts/workflow/delta-signal-probe.py"
BASE = "a" * 40
OLD_PROBE = pathlib.Path(__file__).with_name("delta_signal_probe_old.py")
OLD_SHA256 = "d888c2cf70bbb342968c5433a008cd222ad06015b1fd2a3baa2faf198055a5cd"


class ProbeTests(unittest.TestCase):
    traced = False

    @contextlib.contextmanager
    def fixture(self, mode, old=False):
        with tempfile.TemporaryDirectory(prefix="delta-signal-probe-") as directory:
            root = pathlib.Path(directory)
            binaries = root / "bin"
            binaries.mkdir()
            os.mkfifo(root / "sample-ready")
            os.mkfifo(root / "command-control")
            # The sampler resists graceful signals so cleanup must reap it even
            # when a group cancellation did not terminate the sampler itself.
            programs = {
                "vmstat": '''import os, pathlib, signal
for number in (signal.SIGHUP, signal.SIGINT, signal.SIGTERM):
    signal.signal(number, signal.SIG_IGN)
pathlib.Path("sampler.pid").write_text(str(os.getpid()))
with open("sample-ready", "w") as ready:
    ready.write("sample\\n")
print("FIXTURE_SAMPLE", flush=True)
while True:
    signal.pause()
''',
                "make": '''import os, pathlib, signal, sys
assert sys.argv[1:] == ["delta", "BASE=" + "a" * 40], sys.argv
pathlib.Path("command.pid").write_text(str(os.getpid()))
def cancelled(number, frame):
    pathlib.Path("command.signal").write_text(str(number))
    sys.exit(128 + number)
for number in (signal.SIGHUP, signal.SIGINT, signal.SIGTERM):
    signal.signal(number, cancelled)
with open("sample-ready") as ready:
    assert ready.read() == "sample\\n"
print("FIXTURE_COMMAND_READY", flush=True)
print("FIXTURE_STDERR", file=sys.stderr, flush=True)
if os.environ["FIXTURE_MODE"] != "signal":
    sys.exit(int(os.environ["FIXTURE_MODE"]))
with open("command-control") as control:
    assert control.read() == "still-alive\\n"
print("FIXTURE_COMMAND_ALIVE", flush=True)
while True:
    signal.pause()
''',
                # Darwin has no GNU stdbuf guarantee. Only its argument
                # forwarding is substituted; both children are real processes.
                "stdbuf": '''import os, sys
assert sys.argv[1] == "-oL"
os.execvp(sys.argv[2], sys.argv[2:])
''',
            }
            for name, program in programs.items():
                if self.traced and name == "stdbuf":
                    continue  # The Linux composition uses GNU stdbuf too.
                path = binaries / name
                path.write_text("#!" + sys.executable + "\n" + program)
                path.chmod(0o755)
            copied = root / "probe.py"
            shutil.copyfile(OLD_PROBE if old else PROBE, copied)
            argv = [sys.executable, "-u", str(copied), BASE]
            if old:
                self.assertEqual(OLD_SHA256, hashlib.sha256(copied.read_bytes()).hexdigest())
                # Exact sealed workflow entry composition, disposable commands.
                argv = ["strace", "-I", "1", "-f", "-ttt", "-s", "160",
                    "-e", "trace=%process,kill,tkill,tgkill,rt_sigqueueinfo,rt_tgsigqueueinfo",
                    "-e", "signal=SIGHUP,SIGINT,SIGTERM,SIGKILL", *argv]
            elif not self.traced:
                # No Linux runtime on Darwin: exercise the same main/handlers
                # with only start_tracer replaced. This is NOT ptrace evidence.
                argv = [sys.executable, "-u", "-c", '''import importlib.util, sys
spec = importlib.util.spec_from_file_location("probe", sys.argv[1])
probe = importlib.util.module_from_spec(spec)
spec.loader.exec_module(probe)
probe.start_tracer = lambda: None
sys.argv = sys.argv[1:]
raise SystemExit(probe.main())
''', str(copied), BASE]
            # A file prevents a full strace stderr pipe from deadlocking the
            # readiness handshake. Evidence is emitted before fixture cleanup.
            trace_log = (root / "stderr.log").open("w+")
            process = subprocess.Popen(argv, cwd=root,
                env=dict(os.environ, PATH=str(binaries) + os.pathsep + os.environ["PATH"], FIXTURE_MODE=mode),
                stdout=subprocess.PIPE, stderr=trace_log, text=True,
                preexec_fn=os.setpgrp)  # Isolate only this disposable fixture.
            try:
                yield root, process
            finally:
                # Failure cleanup is restricted to this fixture's process group.
                with contextlib.suppress(ProcessLookupError):
                    os.killpg(process.pid, signal.SIGKILL)
                if not process.stdout.closed:
                    process.communicate()
                process.wait()
                if self.traced:
                    # Linux subreaper is fixture-only: reap the deliberately
                    # orphaned old observer and its disposable children.
                    while True:
                        try:
                            os.waitpid(-process.pid, 0)
                        except ChildProcessError:
                            break
                trace_log.close()

    def ready(self, root, process):
        prefix = ""
        while not all(word in prefix for word in
            ("FIXTURE_COMMAND_READY\n", "FIXTURE_SAMPLE\n", "DELTA_PROBE_BEGIN ")):
            line = process.stdout.readline()
            if not line:
                self.fail(prefix + (root / "stderr.log").read_text())
            prefix += line
        return prefix

    def evidence(self, root, process, label, stdout, **details):
        stderr = (root / "stderr.log").read_text()
        receipt = dict(case=label, traced=self.traced, entry_pid=process.pid,
            exit=process.returncode, before_emergency_cleanup=True, **details)
        print(stdout, end="", flush=True)
        print(stderr, end="", file=sys.stderr, flush=True)
        print("DELTA_PROBE_SELFTEST " + json.dumps(receipt), flush=True)
        if directory := os.environ.get("DELTA_PROBE_EVIDENCE_DIR"):
            dest = pathlib.Path(directory)
            dest.mkdir(parents=True, exist_ok=True)
            (dest / (label + ".stdout.log")).write_text(stdout)
            (dest / (label + ".stderr.log")).write_text(stderr)
            (dest / (label + ".json")).write_text(json.dumps(receipt) + "\n")
        return stderr

    def assert_reaped(self, root):
        for name in ("sampler.pid", "command.pid"):
            with self.assertRaises(ProcessLookupError, msg=name):
                os.kill(int((root / name).read_text()), 0)

    def assert_entry(self, process, stdout):
        self.assertIn(f"DELTA_PROBE_BEGIN pid={process.pid} ", stdout)
        if self.traced:
            match = re.search(r"DELTA_PROBE_TRACE_READY pid=(\d+) tracer_pid=(\d+)", stdout)
            self.assertIsNotNone(match, stdout)
            self.assertEqual(process.pid, int(match[1]))
            with self.assertRaises(ProcessLookupError):
                os.kill(int(match[2]), 0)

    def assert_trace_completed(self, stdout):
        if self.traced:
            self.assertIn("DELTA_PROBE_TRACE_END prior_exit=None ", stdout)

    def test_exit_and_sampler_cleanup(self):
        for code in (0, 17):
            with self.subTest(exit=code), self.fixture(str(code)) as (root, process):
                stdout, _ = process.communicate()
                stderr = self.evidence(root, process, f"exit-{code}", stdout)
                self.assertEqual(code, process.returncode, stdout + stderr)
                self.assertIn("FIXTURE_SAMPLE", stdout)
                self.assertIn("FIXTURE_STDERR", stderr)
                self.assertIn(f"DELTA_PROBE_RESULT exit={code}", stdout)
                self.assert_entry(process, stdout)
                self.assert_trace_completed(stdout)
                self.assert_reaped(root)

    def test_signals_cleanup_sampler_and_reach_command(self):
        for number in (signal.SIGHUP, signal.SIGINT, signal.SIGTERM):
            for group in (False, True):
                with self.subTest(signal=number, group=group), self.fixture("signal") as (root, process):
                    prefix = self.ready(root, process)
                    (os.killpg if group else os.kill)(process.pid, number)
                    stdout, _ = process.communicate()
                    stdout = prefix + stdout
                    stderr = self.evidence(root, process, f"{number.name}-{'group' if group else 'entry'}", stdout)
                    self.assertEqual(128 + number, process.returncode, prefix + stdout + stderr)
                    self.assertEqual(str(int(number)), (root / "command.signal").read_text())
                    self.assertIn("DELTA_PROBE_SIGNAL", prefix + stdout)
                    self.assert_entry(process, stdout)
                    self.assert_reaped(root)
                    if self.traced and not group:
                        # The live trace must distinguish the original sender
                        # from the observer's kill to its direct command child.
                        self.assertIn(f"si_pid={os.getpid()}", stderr)
                        self.assertRegex(stderr, rf"--- {number.name} .*si_pid={process.pid}\b")
                        command = (root / "command.pid").read_text()
                        self.assertIn(f"kill({command}, {number.name})", stderr)
                        self.assert_trace_completed(stdout)


class LinuxProbeTests(ProbeTests):
    traced = True

    @classmethod
    def setUpClass(cls):
        if sys.platform != "linux" or shutil.which("strace") is None:
            raise RuntimeError("Linux selftest requires Linux and real strace; never skip")
        # Adopt only orphans from our own disposable groups for failure cleanup.
        if ctypes.CDLL(None).prctl(36, 1, 0, 0, 0) != 0:  # PR_SET_CHILD_SUBREAPER
            raise RuntimeError("cannot own counterfactual orphans")

    @classmethod
    def tearDownClass(cls):
        if ctypes.CDLL(None).prctl(36, 0, 0, 0, 0) != 0:
            raise RuntimeError("cannot reset fixture subreaper")

    def test_old_entry_loses_pid_cancellation(self):
        for number in (signal.SIGINT, signal.SIGTERM):
            with self.subTest(signal=number), self.fixture("signal", old=True) as (root, process):
                stdout = self.ready(root, process)
                observer = int(re.search(r"DELTA_PROBE_BEGIN pid=(\d+)", stdout)[1])
                self.assertNotEqual(process.pid, observer)
                os.kill(process.pid, number)
                self.assertEqual(-number, process.wait())
                # A post-exit round trip proves command liveness without a
                # sleep/no-signal timing assumption or fixture cleanup help.
                with (root / "command-control").open("w") as control:
                    control.write("still-alive\n")
                line = process.stdout.readline()
                stdout += line
                self.assertEqual("FIXTURE_COMMAND_ALIVE\n", line)
                self.assertFalse((root / "command.signal").exists())
                for pid in (observer, int((root / "sampler.pid").read_text())):
                    self.assertNotIn("State:\tZ", pathlib.Path(f"/proc/{pid}/status").read_text())
                self.evidence(root, process, f"old-{number.name}-entry", stdout,
                    expected_rejection=["command_signal_missing", "command_alive", "sampler_alive", "observer_alive"])


if __name__ == "__main__":
    if len(sys.argv) == 3 and sys.argv[1] == "--linux-selftest":
        PROBE = pathlib.Path(sys.argv[2]).resolve()
        # Counterfactual first, then the identical acceptance cases on repair.
        unittest.main(argv=[sys.argv[0], "LinuxProbeTests.test_old_entry_loses_pid_cancellation",
            "LinuxProbeTests.test_exit_and_sampler_cleanup",
            "LinuxProbeTests.test_signals_cleanup_sampler_and_reach_command"], verbosity=2)
    else:
        unittest.main()
