"""Trial selection and checkpoint-first completion, independent of tensor runtime."""

import copy
import dataclasses
import math
import os
from pathlib import Path
import uuid

from search_config import (ALGORITHM, SCHEMA, Config, descriptor, identity,
                           scientific_without_runtime)
from state_store import file_hash, sync_file
from trial_history import empty_summary


class Campaign:
    def __init__(self, directory, config, registry, runtime, checkpoint=None,
                 fresh_start=False, lineage=None, provenance=None, session_id=None):
        self.directory = Path(directory).resolve()
        self.config, self.registry, self.runtime = config, registry, runtime
        self.provenance = provenance or {}
        self.session_id = session_id or uuid.uuid4().hex
        self.checkpoint = checkpoint
        self.trial = None
        self.run_index = self.iteration = self.total_steps = 0
        self.skipped_trials = self.traversal_start_steps = 0
        self.pending_terminal = False
        self.receipt = None
        self.resumed_from = None
        self.lineage = lineage or (checkpoint.get("legacy_lineage") if checkpoint else None)
        if checkpoint and lineage and checkpoint.get("legacy_lineage") not in (None, lineage):
            raise ValueError("checkpoint legacy lineage mismatch")
        self.registry.require_lineage(self.lineage)
        if checkpoint:
            self._validate_checkpoint(checkpoint)
            self._reconcile(checkpoint)
            progress = checkpoint["progress"]
            self.resumed_from = {key: progress[key] for key in ("run_index", "iteration", "total_steps")}
            self.total_steps = progress["total_steps"]
            if fresh_start:
                if not checkpoint["trial"]["terminal"]:
                    raise ValueError("unfinished checkpoint retained; use --resume to finish it before --fresh-start")
                self.traversal_start_steps = self.total_steps
                self.checkpoint = None
            else:
                old_config = checkpoint["config"]
                if (list(config.dimensions), config.base_seed, config.seed_steps) != (
                        list(old_config["dimensions"]), old_config["base_seed"], old_config["seed_steps"]):
                    raise ValueError("scientific schedule mismatch; finish with saved config then --fresh-start")
                for key in ("run_index", "iteration", "skipped_trials", "traversal_start_steps"):
                    setattr(self, key, progress[key])
                self.trial = copy.deepcopy(checkpoint["trial"])
                current = descriptor(config, self.dimension, self.seed, runtime)
                old = self.trial["descriptor"]
                if old.get("legacy_lineage"):
                    matches = scientific_without_runtime(current) == scientific_without_runtime(old)
                    # The retained current checkpoint can constrain fields absent in prefix history.
                    from search_config import numerical_runtime
                    saved_runtime = numerical_runtime(checkpoint.get("runtime", {}))
                    for key, value in saved_runtime.items():
                        if key != "environment" and value is not None and current["runtime"].get(key) != value:
                            matches = False
                    for key, value in saved_runtime["environment"].items():
                        if value is not None and current["runtime"]["environment"].get(key) != value:
                            matches = False
                else:
                    matches = current == old
                if not matches:
                    raise ValueError("scientific configuration or numerical runtime mismatch; resume in the saved environment")
        self.session_start_steps = self.total_steps

    @property
    def dimension(self):
        return self.config.dimensions[self.run_index % len(self.config.dimensions)]

    @property
    def seed(self):
        return (self.config.base_seed + self.run_index) % (2 ** 63)

    def _validate_checkpoint(self, saved):
        if saved.get("schema") != SCHEMA or saved.get("algorithm") != ALGORITHM:
            raise ValueError("unsupported checkpoint schema/algorithm; use legacy_conversion.py for schema 1")
        if saved.get("kind") != "latest":
            raise ValueError("expected a latest checkpoint")
        progress, trial = saved["progress"], saved["trial"]
        for key in ("run_index", "iteration", "total_steps", "skipped_trials", "traversal_start_steps"):
            if type(progress[key]) is not int or progress[key] < 0:
                raise ValueError("invalid checkpoint progress")
        budget = saved["config"]["seed_steps"]
        if not (progress["skipped_trials"] <= progress["run_index"] and progress["iteration"] <= budget
                and progress["total_steps"] - progress["traversal_start_steps"] ==
                (progress["run_index"] - progress["skipped_trials"]) * budget + progress["iteration"]):
            raise ValueError("inconsistent checkpoint update accounting")
        if (trial["identity"] != identity(trial["descriptor"])
                or type(trial["terminal"]) is not bool
                or trial["terminal"] != (progress["iteration"] == budget)
                or trial["descriptor"]["budget"] != budget):
            raise ValueError("invalid terminal checkpoint identity/budget")
        old = saved["config"]
        saved_config = Config(**old)
        saved_config.validate()
        dimension = old["dimensions"][progress["run_index"] % len(old["dimensions"])]
        seed = (old["base_seed"] + progress["run_index"]) % (2 ** 63)
        if trial["descriptor"]["dimension"] != dimension or trial["descriptor"]["seed"] != seed:
            raise ValueError("checkpoint trial does not match schedule")
        expected = descriptor(saved_config, dimension, seed, saved.get("runtime", {}))
        if trial["descriptor"].get("legacy_lineage"):
            matches = (scientific_without_runtime(expected) == scientific_without_runtime(trial["descriptor"])
                       and trial["descriptor"]["legacy_lineage"] == saved.get("legacy_lineage"))
        else:
            matches = expected == trial["descriptor"]
        if not matches:
            raise ValueError("checkpoint scientific descriptor/configuration mismatch")
        final = trial["summary"].get("final")
        if trial["terminal"] and (not isinstance(final, dict) or final.get("iteration") != budget
                                   or not math.isfinite(final.get("fidelity", float("nan")))):
            raise ValueError("terminal checkpoint lacks final scalar metrics")

    def _reconcile(self, saved):
        trial, iteration = saved["trial"], saved["progress"]["iteration"]
        row = self.registry.get(trial["identity"])
        if not row:
            self.registry.claim(trial["descriptor"], self.directory, saved.get("provenance", {}))
        elif row["status"] != "completed" and row["state_directory"] != str(self.directory):
            raise ValueError("unfinished checkpoint owned by " + row["state_directory"] + "; use --resume there")
        if trial["terminal"]:
            sync_file(self.directory / "latest.pt")
            self.registry.complete(trial["identity"], iteration, trial["summary"], trial.get("candidate_sha256"))
            if trial["descriptor"].get("legacy_lineage"):
                self.registry.exclude(trial["descriptor"]["legacy_lineage"], trial["descriptor"], trial["identity"])
        else:
            if row and row["status"] == "completed":
                raise ValueError("unfinished checkpoint conflicts with committed completion")
            self.registry.mark(trial["identity"], "interrupted", iteration, trial["summary"])

    def select(self, stopped=lambda: False):
        if self.pending_terminal:
            raise RuntimeError("terminal completion is pending; restart to reconcile latest.pt")
        if stopped():
            return False
        if self.trial and not self.trial["terminal"]:
            self.registry.claim(self.trial["descriptor"], self.directory, self.provenance)
            return True
        if self.trial:
            self.run_index += 1
            self.iteration = 0
            self.trial = None
            self.checkpoint = None
        while not stopped():
            desc = descriptor(self.config, self.dimension, self.seed, self.runtime)
            if self.registry.completed(desc) or self.registry.excluded(self.lineage, desc):
                self.run_index += 1
                self.skipped_trials += 1
                continue
            key = self.registry.claim(desc, self.directory, self.provenance)
            self.trial = {"identity": key, "descriptor": desc, "summary": empty_summary(),
                          "terminal": False, "candidate_sha256": None}
            return True
        return False

    def updated(self):
        if not self.trial or self.iteration >= self.config.seed_steps or self.pending_terminal:
            raise RuntimeError("no claimed unfinished trial for optimizer update")
        self.iteration += 1
        self.total_steps += 1

    def observe(self, metrics):
        if not math.isfinite(metrics["fidelity"]) or metrics["iteration"] != self.iteration:
            raise ValueError("invalid trial-local metrics")
        summary = self.trial["summary"]
        if self.iteration == 0 and summary["initial"] is None:
            summary["initial"] = dict(metrics)
        summary["final"] = dict(metrics)
        if summary["best"] is None or metrics["fidelity"] > summary["best"]["fidelity"]:
            summary["best"] = dict(metrics)

    def progress(self):
        return {key: getattr(self, key) for key in (
            "run_index", "iteration", "total_steps", "skipped_trials", "traversal_start_steps")}

    def publish(self, checkpoint, writer, stopped=False):
        if self.pending_terminal:
            raise RuntimeError("terminal completion pending; cannot overwrite recovery checkpoint")
        terminal = self.iteration == self.config.seed_steps
        if terminal and (self.trial["summary"]["final"] is None or
                         self.trial["summary"]["final"]["iteration"] != self.iteration):
            raise ValueError("terminal checkpoint requires final trial-local metrics")
        self.trial["terminal"] = terminal
        self.trial["candidate_sha256"] = checkpoint.get("candidate_sha256")
        checkpoint.update(schema=SCHEMA, algorithm=ALGORITHM, kind="latest",
                          config=dataclasses.asdict(self.config), trial=copy.deepcopy(self.trial),
                          legacy_lineage=self.lineage, provenance=self.provenance,
                          history_db=str(self.registry.path),
                          progress={**checkpoint.get("progress", {}), **self.progress()},
                          runtime=self.runtime,
                          invocation={"session_id": self.session_id, "pid": os.getpid()})
        path = self.directory / "latest.pt"
        # Set the guard before publication: even an exception after rename must
        # never let the final error handler destroy terminal recovery evidence.
        self.pending_terminal = terminal
        writer(path, checkpoint)
        self.receipt = {"sha256": file_hash(path), "session_id": self.session_id,
                        "pid": os.getpid(), "progress": self.progress()}
        if terminal:
            self.registry.complete(self.trial["identity"], self.iteration,
                                   self.trial["summary"], self.trial["candidate_sha256"])
            if self.trial["descriptor"].get("legacy_lineage"):
                self.registry.exclude(self.lineage, self.trial["descriptor"], self.trial["identity"])
            self.pending_terminal = False
        else:
            self.registry.mark(self.trial["identity"], "interrupted" if stopped else "running",
                               self.iteration, self.trial["summary"])
        return checkpoint

    def fail(self, details):
        if self.trial and not self.pending_terminal:
            # Never save tensors here: an optimizer may have failed mid-update.
            self.registry.mark(self.trial["identity"], "failed", error=details)
