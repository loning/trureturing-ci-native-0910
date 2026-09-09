"""Exercise the production worker loop with a synthetic CPU tensor fixture.

The fixture does no numerical optimization and never initializes Apple MPS.
"""

import contextlib
import io
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import torch

import gpu_worker as worker
from search_config import Config, descriptor
from trial_history import Registry
from test_trial_history import RUNTIME


class FixtureModel(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.value = torch.nn.Parameter(torch.tensor([0.2]))

    def forward(self):
        return torch.ones(4, 1, 1) / 2, self.value


class FixtureOptimizer:
    def __init__(self):
        self.state = {"step": 0, "moment": torch.tensor([0.0])}

    def state_dict(self):
        return self.state

    def load_state_dict(self, state):
        self.state = state


class SyntheticWorker(worker.Worker):
    def new_model(self):
        assert self.registry.get(self.campaign.trial["identity"])["status"] == "running"
        self.initializations.append((self.dimension, self.seed))
        self.model, self.optimizer = FixtureModel(), FixtureOptimizer()

    def initialize(self):
        self.initializations = []
        self.dp = lambda matrices, initial: initial
        self.new_model()
        saved = self.campaign.checkpoint
        if saved:
            self.model.load_state_dict(saved["model"])
            self.optimizer.load_state_dict(saved["optimizer"])
        self.campaign.checkpoint = None

    def train_step(self):
        with torch.no_grad():
            self.model.value.add_(0.1)
        self.optimizer.state["step"] += 1
        self.optimizer.state["moment"].add_(0.2)
        self.campaign.updated()


class WorkerTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="gpu5040-worker-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name).resolve()
        self.state = self.root / "state"
        self.state.mkdir()
        self.registry = Registry(self.root / "history.sqlite3")
        self.addCleanup(self.registry.close)
        self.config = Config(dimensions=(13,), seed_steps=2, batch_steps=1)
        for target, kwargs in (("runtime_info", {"return_value": RUNTIME}),
                               ("torch.mps.get_rng_state", {"return_value": torch.tensor([7], dtype=torch.uint8)})):
            context = patch("gpu_worker." + target, **kwargs)
            context.start()
            self.addCleanup(context.stop)

    def create(self, steps=2, fresh=False, state=None):
        state = state or self.state
        args = worker.parser().parse_args(["--max-steps", str(steps)] + (["--fresh-start"] if fresh else []))
        saved = worker.load_checkpoint(state / "latest.pt", state) if (state / "latest.pt").exists() else None
        return SyntheticWorker(state, self.config, saved, worker.StopRequest(), args, self.registry)

    def run_worker(self, instance):
        with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
            return instance.run()

    def test_worker_restart_fresh_and_new_state_skip_before_model_initialization(self):
        first = self.create()
        self.assertEqual(0, self.run_worker(first))
        self.assertEqual([(13, 5040)], first.initializations)
        second = self.create(fresh=True)
        self.assertEqual(0, self.run_worker(second))
        self.assertEqual([(13, 5041)], second.initializations)
        self.assertEqual(1, second.campaign.skipped_trials)
        third_state = self.root / "third"
        third_state.mkdir()
        third = self.create(steps=3, state=third_state)
        self.assertEqual(0, self.run_worker(third))
        self.assertEqual([(13, 5042), (13, 5043)], third.initializations)
        self.assertEqual(3, third.total_steps)
        self.assertEqual(2, third.campaign.skipped_trials)

    def test_worker_final_exception_retains_terminal_recovery_evidence(self):
        first = self.create()
        with patch.object(self.registry, "complete", side_effect=OSError("injected commit failure")):
            self.assertEqual(1, self.run_worker(first))
        saved = worker.load_checkpoint(self.state / "latest.pt", self.state)
        self.assertTrue(saved["trial"]["terminal"])
        self.assertEqual(2, saved["progress"]["iteration"])
        key = saved["trial"]["identity"]
        self.assertNotEqual("completed", self.registry.get(key)["status"])
        after = self.create(steps=1)
        self.assertEqual("completed", self.registry.get(key)["status"])
        self.assertEqual(0, self.run_worker(after))
        self.assertEqual([(13, 5041)], after.initializations)
        self.assertEqual("completed", self.registry.get(key)["status"])

    def test_interrupted_checkpoint_resumes_optimizer_and_fresh_start_refuses(self):
        first = self.create(steps=1)
        self.assertEqual(0, self.run_worker(first))
        before = (self.state / "latest.pt").read_bytes()
        with self.assertRaisesRegex(ValueError, "--resume"):
            self.create(fresh=True)
        self.assertEqual(before, (self.state / "latest.pt").read_bytes())
        second = self.create(steps=1)
        self.assertEqual(0, self.run_worker(second))
        self.assertEqual(2, second.optimizer.state["step"])
        self.assertAlmostEqual(0.4, float(second.optimizer.state["moment"]), places=6)
        self.assertAlmostEqual(0.4, float(second.model.value.detach()), places=6)

    def test_failed_update_does_not_overwrite_last_finite_checkpoint(self):
        first = self.create()
        with patch.object(first, "train_step", side_effect=FloatingPointError("synthetic failure")):
            self.assertEqual(1, self.run_worker(first))
        saved = worker.load_checkpoint(self.state / "latest.pt", self.state)
        self.assertEqual(0, saved["progress"]["iteration"])
        self.assertEqual("failed", self.registry.get(saved["trial"]["identity"])["status"])

    def test_stop_before_start_does_not_initialize_trial(self):
        first = self.create()
        first.stop.reason = "SIGTERM"
        self.assertEqual(0, self.run_worker(first))
        self.assertEqual([], self.registry.rows())
        self.assertFalse((self.state / "latest.pt").exists())

    def test_existing_stop_reports_zero_session_updates_and_keeps_optimizer(self):
        first = self.create(steps=2)
        self.assertEqual(0, self.run_worker(first))
        stopped = self.create()
        stopped.stop.reason = "STOP"
        self.assertEqual(0, self.run_worker(stopped))
        status = json.loads((self.state / "status.json").read_text())
        self.assertEqual("STOP", status["stop_reason"])
        self.assertEqual(0, status["session"]["completed_steps"])
        saved = worker.load_checkpoint(self.state / "latest.pt", self.state)
        self.assertEqual(2, saved["optimizer"]["step"])
        self.assertEqual(status["session"]["id"], saved["invocation"]["session_id"])


if __name__ == "__main__":
    unittest.main()
