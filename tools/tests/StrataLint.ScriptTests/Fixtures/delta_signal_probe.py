"""Disposable real processes; these do not test Linux ptrace or vmstat itself."""
import contextlib
import os
import pathlib
import shutil
import signal
import subprocess
import sys
import tempfile
import unittest

REPO = pathlib.Path(__file__).resolve().parents[4]
PROBE = REPO / "tools/scripts/workflow/delta-signal-probe.py"
BASE = "a" * 40


class ProbeTests(unittest.TestCase):
    @contextlib.contextmanager
    def fixture(self, mode):
        with tempfile.TemporaryDirectory(prefix="delta-signal-probe-") as directory:
            root = pathlib.Path(directory)
            binaries = root / "bin"
            binaries.mkdir()
            os.mkfifo(root / "sample-ready")
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
                path = binaries / name
                path.write_text("#!" + sys.executable + "\n" + program)
                path.chmod(0o755)
            copied = root / "probe.py"
            shutil.copyfile(PROBE, copied)
            process = subprocess.Popen([sys.executable, "-u", str(copied), BASE], cwd=root,
                env=dict(os.environ, PATH=str(binaries) + os.pathsep + os.environ["PATH"], FIXTURE_MODE=mode),
                stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
                preexec_fn=os.setpgrp)  # Isolate only this disposable fixture.
            try:
                yield root, process
            finally:
                # Failure cleanup is restricted to this fixture's process group.
                if process.poll() is None:
                    os.killpg(process.pid, signal.SIGKILL)
                for name in ("sampler.pid", "command.pid"):
                    if (root / name).exists():
                        with contextlib.suppress(ProcessLookupError):
                            os.kill(int((root / name).read_text()), signal.SIGKILL)
                process.communicate()

    def assert_reaped(self, root):
        for name in ("sampler.pid", "command.pid"):
            with self.assertRaises(ProcessLookupError, msg=name):
                os.kill(int((root / name).read_text()), 0)

    def test_exit_and_sampler_cleanup(self):
        for code in (0, 17):
            with self.subTest(exit=code), self.fixture(str(code)) as (root, process):
                stdout, stderr = process.communicate()
                self.assertEqual(code, process.returncode, stdout + stderr)
                self.assertIn("FIXTURE_SAMPLE", stdout)
                self.assertIn("FIXTURE_STDERR", stderr)
                self.assertIn(f"DELTA_PROBE_RESULT exit={code}", stdout)
                self.assert_reaped(root)

    def test_signals_cleanup_sampler_and_reach_command(self):
        for number in (signal.SIGHUP, signal.SIGINT, signal.SIGTERM):
            for group in (False, True):
                with self.subTest(signal=number, group=group), self.fixture("signal") as (root, process):
                    prefix = ""
                    while "FIXTURE_COMMAND_READY\n" not in prefix:
                        line = process.stdout.readline()
                        if not line:
                            self.fail(prefix + process.stderr.read())
                        prefix += line
                    (os.killpg if group else os.kill)(process.pid, number)
                    stdout, stderr = process.communicate()
                    self.assertEqual(128 + number, process.returncode, prefix + stdout + stderr)
                    self.assertEqual(str(int(number)), (root / "command.signal").read_text())
                    self.assertIn("DELTA_PROBE_SIGNAL", prefix + stdout)
                    self.assert_reaped(root)


if __name__ == "__main__":
    unittest.main()
