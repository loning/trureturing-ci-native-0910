#!/usr/bin/env python3
"""Foreground, bounded-storage, resumable Apple MPS research worker."""

import argparse
import dataclasses
import hashlib
import json
import logging
from logging.handlers import RotatingFileHandler
import math
import os
from pathlib import Path
import platform
import resource
import signal
import sqlite3
import subprocess
import sys
import time
import traceback

os.environ.setdefault("PYTORCH_ENABLE_MPS_FALLBACK", "0")
os.environ.setdefault("VECLIB_MAXIMUM_THREADS", "1")
os.environ.setdefault("OPENBLAS_NUM_THREADS", "1")
os.environ.setdefault("OMP_NUM_THREADS", "1")
os.environ.setdefault("MKL_NUM_THREADS", "1")

import numpy as np
import torch

from tensor_core import (DIMENSIONS, OBJECTIVE, OCCUPATION, RESTRICTIONS,
                         OccupationDP, RealIsometry, gram_error, verify_full_output)
from search_config import ALGORITHM, SCHEMA, Config
from search_session import Campaign
from state_store import (StateLocks, atomic_json, atomic_write, default_history, default_state,
                         external_path, file_hash, hash_json, tensor_digest, utc_now)
from trial_history import Registry


ROOT = Path(__file__).resolve().parent
DEVICE = torch.device("mps:0")


def source_hash():
    digest = hashlib.sha256()
    for name in ("gpu_worker.py", "tensor_core.py", "search_config.py", "state_store.py",
                 "search_session.py", "trial_history.py"):
        digest.update(name.encode("ascii") + b"\0" + (ROOT / name).read_bytes())
    return digest.hexdigest()


def atomic_checkpoint(path, value):
    atomic_write(path, lambda stream: torch.save(value, stream))


def runtime_info():
    hardware = platform.processor()
    if sys.platform == "darwin":
        hardware = subprocess.check_output(
            ["/usr/sbin/sysctl", "-n", "machdep.cpu.brand_string"], text=True).strip()
    return {"python": platform.python_version(), "python_executable": sys.executable,
            "torch": str(torch.__version__), "numpy": np.__version__,
            "torch_git": torch.version.git_version, "torch_build": torch.__config__.show(),
            "platform": platform.platform(), "machine": platform.machine(),
            "hardware": hardware, "actual_device": "mps:0",
            "training_precision": "torch.float32", "cpu_fallback": False,
            "torch_cpu_threads": 1,
            "deterministic_algorithms": torch.are_deterministic_algorithms_enabled(),
            "environment": {key: os.environ.get(key) for key in (
                "PYTORCH_ENABLE_MPS_FALLBACK", "PYTORCH_MPS_FAST_MATH",
                "PYTORCH_MPS_PREFER_METAL", "VECLIB_MAXIMUM_THREADS",
                "OPENBLAS_NUM_THREADS", "OMP_NUM_THREADS", "MKL_NUM_THREADS")}}


def to_cpu(value):
    if isinstance(value, torch.Tensor):
        return value.detach().cpu().clone()
    if isinstance(value, dict):
        return {key: to_cpu(item) for key, item in value.items()}
    if isinstance(value, list):
        return [to_cpu(item) for item in value]
    if isinstance(value, tuple):
        return tuple(to_cpu(item) for item in value)
    return value




def load_checkpoint(path, directory):
    path = Path(path)
    allowed = {"latest.pt"} | {"best-%d.pt" % d for d in DIMENSIONS}
    if path.resolve().parent != directory.resolve() or path.name not in allowed:
        raise ValueError("checkpoint loading is restricted to trusted local state files")
    try:
        result = torch.load(path, map_location="cpu", weights_only=True)
    except Exception as error:
        raise ValueError("cannot load trusted checkpoint: " + str(error)) from error
    if (not isinstance(result, dict) or result.get("schema") != SCHEMA
            or result.get("algorithm") != ALGORITHM):
        raise ValueError("unsupported checkpoint schema/algorithm; convert schema 1 with legacy_conversion.py")
    if result.get("occupation") != list(OCCUPATION) or result.get("objective") != OBJECTIVE:
        raise ValueError("checkpoint physical objective mismatch")
    return result




class StopRequest:
    def __init__(self):
        self.reason = None
        self.previous = {}

    def __enter__(self):
        for number in (signal.SIGTERM, signal.SIGINT):
            self.previous[number] = signal.signal(number, self.receive)
        return self

    def receive(self, number, frame):
        self.reason = signal.Signals(number).name

    def __exit__(self, *args):
        for number, handler in self.previous.items():
            signal.signal(number, handler)




class Events:
    def __init__(self, directory, config):
        self.limit = config.log_max_bytes
        self.handler = RotatingFileHandler(directory / "events.jsonl", mode="a",
                                          maxBytes=self.limit, backupCount=config.log_backups,
                                          encoding="utf-8")
        self.handler.setFormatter(logging.Formatter("%(message)s"))

    def emit(self, event, **fields):
        record = {"utc": utc_now(), "event": event, **fields}
        message = json.dumps(record, sort_keys=True, allow_nan=False)
        if len(message.encode("utf-8")) + 1 > self.limit:
            message = json.dumps({"utc": record["utc"], "event": event,
                                  "details_truncated": True,
                                  "details_prefix": message[:self.limit // 4]})
        self.handler.emit(logging.LogRecord("gpu5040", logging.INFO, "", 0, message, (), None))
        self.handler.flush()

    def close(self):
        self.handler.close()


def gpu_memory():
    return {"current_allocated_bytes": torch.mps.current_allocated_memory(),
            "driver_allocated_bytes": torch.mps.driver_allocated_memory(),
            "recommended_max_bytes": torch.mps.recommended_max_memory()}


def verify_record(record, chunk_size):
    before = tensor_digest(record["matrices"], record["initial"])
    result = verify_full_output(record["matrices"].numpy(), record["initial"].numpy(),
                                chunk_size=chunk_size)
    if tensor_digest(record["matrices"], record["initial"]) != before:
        raise RuntimeError("verification changed the candidate")
    result.update({"utc": utc_now(), "candidate_sha256": before,
                   "verification_runtime": {"python": platform.python_version(), "numpy": np.__version__,
                                            "platform": platform.platform(), "machine": platform.machine()},
                   "training_fidelity": record["metrics"]["fidelity"],
                   "cpu_minus_training_fidelity": result["target_fidelity"]
                   - record["metrics"]["fidelity"]})
    return result


class Worker:
    def __init__(self, directory, config, checkpoint, stop, args, registry):
        self.directory, self.config, self.stop, self.args = directory, config, stop, args
        self.registry = registry
        self.last_checkpoint = checkpoint
        self.started = time.monotonic()
        self.source_sha256 = source_hash()
        self.config_sha256 = hash_json(dataclasses.asdict(config))
        self.runtime = runtime_info()
        self.gpu_initialized = False
        self.campaign = Campaign(directory, config, registry, self.runtime, checkpoint,
                                 fresh_start=args.fresh_start, lineage=args.legacy_lineage,
                                 provenance={"source_sha256": self.source_sha256,
                                             "config_sha256": self.config_sha256},
                                 session_id=args.session_id)
        self.events = Events(directory, config)
        self.current = None
        self.best, self.last_verification = {}, {}
        self.dirty_best = set()
        saved = self.campaign.checkpoint
        progress = saved["progress"] if saved else {}
        self.wall_seconds_before = progress.get("wall_seconds", 0.0)
        self.seed_initial_fidelity = progress.get("seed_initial_fidelity")
        self.created_utc = progress.get("created_utc", utc_now())
        self.last_verification = {int(k): v for k, v in progress.get("last_verification", {}).items()}
        self.step_times = {"count": 0, "sum_seconds": 0.0, "min_seconds": None,
                           "max_seconds": None, "last_seconds": None}
        self.gradient_stats = {"count": 0, "min_l2": None, "max_l2": None, "last_l2": None,
                               "all_finite": True}
        self.device_evidence, self.dimension_stats = {}, {}
        self.session_start_steps = self.campaign.session_start_steps
        self.resumed_from = self.campaign.resumed_from
        self.last_batch_seconds = None
        for dimension in DIMENSIONS:
            path = directory / ("best-%d.pt" % dimension)
            if path.exists():
                record = load_checkpoint(path, directory)
                if record.get("kind") != "best" or record.get("dimension") != dimension:
                    raise ValueError("invalid best-candidate checkpoint: " + path.name)
                if not math.isfinite(record["metrics"]["fidelity"]):
                    raise ValueError("nonfinite saved best fidelity")
                self.best[dimension] = record

    @property
    def run_index(self):
        return self.campaign.run_index

    @property
    def iteration(self):
        return self.campaign.iteration

    @property
    def total_steps(self):
        return self.campaign.total_steps

    @property
    def dimension(self):
        return self.campaign.dimension

    @property
    def seed(self):
        return self.campaign.seed

    def initialize(self):
        if os.environ.get("PYTORCH_ENABLE_MPS_FALLBACK") != "0":
            raise ValueError("PYTORCH_ENABLE_MPS_FALLBACK must be 0; CPU fallback is forbidden")
        if not torch.backends.mps.is_available():
            raise RuntimeError("actual Apple MPS is unavailable; no CPU training path exists")
        torch.set_num_threads(1)
        torch.mps.set_per_process_memory_fraction(self.config.mps_memory_fraction)
        probe = torch.ones(2, device=DEVICE, dtype=torch.float32)
        if str(probe.device) != "mps:0":
            raise RuntimeError("device probe is not on mps:0")
        torch.mps.synchronize()
        self.gpu_initialized = True
        self.dp = OccupationDP(device=DEVICE)
        self.new_model()
        if self.campaign.checkpoint and not self.campaign.checkpoint["trial"]["terminal"]:
            saved = self.campaign.checkpoint
            self.model.load_state_dict(saved["model"])
            self.optimizer.load_state_dict(saved["optimizer"])
            torch.set_rng_state(saved["rng"]["torch_cpu"])
            torch.mps.set_rng_state(saved["rng"]["torch_mps"])
            self.assert_optimizer_devices()
        self.campaign.checkpoint = None
        startup = {**self.common(), "config": dataclasses.asdict(self.config),
                   "runtime": self.runtime, "argv": sys.argv,
                   "resumed_from": self.resumed_from, "fresh_start": self.args.fresh_start,
                   "retained_best_dimensions": sorted(self.best),
                   "free_disk_bytes": os.statvfs(self.directory).f_bavail
                   * os.statvfs(self.directory).f_frsize}
        atomic_json(self.directory / "startup.json", startup)
        self.events.emit("startup", config_sha256=self.config_sha256,
                         source_sha256=self.source_sha256, resumed_from=self.resumed_from,
                         fresh_start=self.args.fresh_start, retained_best_dimensions=sorted(self.best))

    def new_model(self):
        torch.manual_seed(self.seed)
        torch.mps.manual_seed(self.seed)
        self.model = RealIsometry(self.dimension, DEVICE)
        self.optimizer = torch.optim.Adam(self.model.parameters(), lr=self.config.learning_rate,
                                          betas=(0.9, 0.999), eps=1e-8, weight_decay=0,
                                          foreach=False, fused=False)

    def assert_optimizer_devices(self):
        for state in self.optimizer.state.values():
            for name in ("exp_avg", "exp_avg_sq"):
                if name in state and str(state[name].device) != "mps:0":
                    raise RuntimeError("Adam moment tensor left MPS")

    def common(self):
        return {"schema": SCHEMA, "algorithm": ALGORITHM, "utc": utc_now(), "objective": OBJECTIVE,
                "occupation": list(OCCUPATION), "alphabet": [0, 1, 2, 3],
                "legal_words": 840, "restrictions": RESTRICTIONS,
                "source_sha256": self.source_sha256, "config_sha256": self.config_sha256}

    def metrics(self, matrices, initial, fidelity):
        values = torch.stack((fidelity.detach(), gram_error(matrices.detach()),
                              initial.detach().square().sum())).cpu().tolist()
        if not all(math.isfinite(value) for value in values):
            raise FloatingPointError("nonfinite objective, Gram error, or initial norm")
        return {"fidelity": values[0], "gram_max_abs_error": values[1],
                "initial_norm_squared": values[2], "dimension": self.dimension,
                "seed": self.seed, "run_index": self.run_index,
                "iteration": self.iteration, "total_steps": self.total_steps}

    def observe(self, matrices, initial, metrics):
        self.campaign.observe(metrics)
        old = self.best.get(self.dimension)
        if old is None or metrics["fidelity"] > old["metrics"]["fidelity"]:
            self.best[self.dimension] = {
                **self.common(), "kind": "best", "dimension": self.dimension,
                "trial_identity": self.campaign.trial["identity"],
                "metrics": metrics, "precision": "torch.float32", "device": "mps:0",
                "model": {key: tensor.detach().clone()
                          for key, tensor in self.model.state_dict().items()},
                "matrices": matrices.detach().clone(), "initial": initial.detach().clone(),
                "verification": None,
            }
            self.dirty_best.add(self.dimension)

    def train_step(self):
        torch.mps.synchronize()
        started = time.perf_counter()
        self.optimizer.zero_grad(set_to_none=True)
        matrices, initial = self.model()
        target = self.dp(matrices, initial)
        fidelity = target.square().sum()
        (1 - fidelity).backward()
        parameters = list(self.model.parameters())
        gradients = [parameter.grad for parameter in parameters]
        representatives = parameters + gradients + [matrices, initial, target, fidelity]
        if any(tensor is None or str(tensor.device) != "mps:0" for tensor in representatives):
            raise RuntimeError("a trainable tensor, contraction, or gradient left MPS")
        if any(str(incidence.device) != "mps:0" for incidence in self.dp.layers):
            raise RuntimeError("DP incidence tensors left MPS")
        gradient_l2 = torch.stack([gradient.square().sum() for gradient in gradients]).sum().sqrt()
        finite = torch.stack([torch.isfinite(gradient).all() for gradient in gradients]).all()
        values = torch.stack((fidelity.detach(), gradient_l2, finite.float())).detach().cpu().tolist()
        if not all(math.isfinite(value) for value in values) or values[2] != 1:
            raise FloatingPointError("nonfinite loss or gradient; latest safe checkpoint retained")
        metrics = self.metrics(matrices, initial, fidelity)
        self.observe(matrices, initial, metrics)
        self.optimizer.param_groups[0]["lr"] = self.config.learning_rate_at(self.iteration)
        self.optimizer.step()
        self.assert_optimizer_devices()
        self.campaign.updated()
        torch.mps.synchronize()
        elapsed = time.perf_counter() - started
        times = self.step_times
        times["count"] += 1
        times["sum_seconds"] += elapsed
        times["last_seconds"] = elapsed
        times["min_seconds"] = min(times["min_seconds"] or elapsed, elapsed)
        times["max_seconds"] = max(times["max_seconds"] or elapsed, elapsed)
        stats = self.gradient_stats
        stats["count"] += 1
        stats["last_l2"] = values[1]
        stats["min_l2"] = values[1] if stats["min_l2"] is None else min(stats["min_l2"], values[1])
        stats["max_l2"] = values[1] if stats["max_l2"] is None else max(stats["max_l2"], values[1])
        per_dimension = self.dimension_stats.setdefault(str(self.dimension), {
            "steps": 0, "sum_step_seconds": 0.0, "first_step_seconds": elapsed,
            "last_step_seconds": elapsed, "min_gradient_l2": values[1]})
        per_dimension["steps"] += 1
        per_dimension["sum_step_seconds"] += elapsed
        per_dimension["last_step_seconds"] = elapsed
        per_dimension["min_gradient_l2"] = min(per_dimension["min_gradient_l2"], values[1])
        self.device_evidence = {"parameters": sorted({str(p.device) for p in parameters}),
                                "gradients": sorted({str(g.device) for g in gradients}),
                                "frame": str(matrices.device), "initial": str(initial.device),
                                "target_vector": str(target.device), "loss": str(fidelity.device),
                                "dp_incidence": str(self.dp.layers[0].device),
                                "adam_moments": "mps:0", "adam_step_counter": "cpu (nontrainable)"}

    def stop_reason(self):
        if self.stop.reason:
            return self.stop.reason
        if (self.directory / "STOP").exists():
            return "STOP"
        if self.args.max_steps and self.total_steps - self.session_start_steps >= self.args.max_steps:
            return "max_steps"
        if self.args.max_seconds and time.monotonic() - self.started >= self.args.max_seconds:
            return "max_seconds"
        return None

    def save_best(self, allow_verification):
        for dimension in sorted(self.dirty_best):
            record = to_cpu(self.best[dimension])
            record["candidate_sha256"] = tensor_digest(record["matrices"], record["initial"])
            # Publish the discovered float32 tensors before independent evaluation.
            atomic_checkpoint(self.directory / ("best-%d.pt" % dimension), record)
            self.best[dimension] = record
            self.registry.champion(dimension, record["candidate_sha256"], record["metrics"],
                                   str(self.directory / ("best-%d.pt" % dimension)))
            self.events.emit("best_saved", dimension=dimension, metrics=record["metrics"],
                             candidate_sha256=record["candidate_sha256"])
        self.dirty_best.clear()
        record = self.best[self.dimension]
        previous = self.last_verification.get(self.dimension)
        due = previous is None or self.total_steps - previous >= self.config.verification_interval_steps
        if (allow_verification and record["verification"] is None and due
                and 1 - record["metrics"]["fidelity"] < self.config.verification_gap):
            digest = record["candidate_sha256"]
            self.registry.verification(digest, "running")
            try:
                record["verification"] = verify_record(record, self.config.verification_chunk_size)
            except Exception as error:
                self.registry.verification(digest, "failed", {"error": str(error)})
                self.events.emit("verification_failed", candidate_sha256=digest, error=str(error))
                return
            self.registry.verification(digest, "verified", record["verification"])
            self.last_verification[self.dimension] = self.total_steps
            atomic_checkpoint(self.directory / ("best-%d.pt" % self.dimension), record)
            self.events.emit("numerical_candidate_verified", dimension=self.dimension,
                             candidate_sha256=record["candidate_sha256"],
                             training_fidelity=record["metrics"]["fidelity"],
                             cpu_fidelity=record["verification"]["target_fidelity"],
                             seconds=record["verification"]["seconds"], closure=False)

    def progress(self):
        return {**self.campaign.progress(), "run_index": self.run_index, "iteration": self.iteration,
                "total_steps": self.total_steps, "dimension": self.dimension, "seed": self.seed,
                "round": self.run_index // len(self.config.dimensions),
                "last_verification": self.last_verification,
                "seed_initial_fidelity": self.seed_initial_fidelity,
                "created_utc": self.created_utc,
                "wall_seconds": self.wall_seconds_before + time.monotonic() - self.started}

    def status(self, phase, reason, checkpoint_saved=True, error=None):
        memory = gpu_memory() if self.gpu_initialized else None
        times = dict(self.step_times)
        times["mean_seconds"] = times["sum_seconds"] / times["count"] if times["count"] else None
        usage = resource.getrusage(resource.RUSAGE_SELF)
        best = {str(d): {"metrics": record["metrics"],
                         "candidate_sha256": record.get("candidate_sha256"),
                         "verification": record["verification"]}
                for d, record in self.best.items()}
        return {**self.common(), "phase": phase, "stop_reason": reason, "error": error,
                "pid": os.getpid(), "state_directory": str(self.directory),
                "history_db": str(self.registry.path), "legacy_lineage": self.campaign.lineage,
                "config": dataclasses.asdict(self.config), "runtime": self.runtime,
                "progress": self.progress(), "current": self.current, "best": best,
                "trial": self.campaign.trial,
                "session": {"id": self.campaign.session_id, "start_total_steps": self.session_start_steps,
                            "completed_steps": self.total_steps - self.session_start_steps,
                            "resumed_from": self.resumed_from,
                            "wall_seconds": time.monotonic() - self.started,
                            "step_durations": times, "gradients": self.gradient_stats,
                            "per_dimension": self.dimension_stats,
                            "last_batch_seconds": self.last_batch_seconds},
                "device_evidence": self.device_evidence, "gpu_memory": memory,
                "process_peak_rss_bytes": usage.ru_maxrss * (1 if sys.platform == "darwin" else 1024),
                "storage_bytes": sum(path.stat().st_size for path in self.directory.iterdir()
                                     if path.is_file()),
                "checkpoint_saved": checkpoint_saved,
                "checkpoint_receipt": self.campaign.receipt,
                "latest_checkpoint": str(self.directory / "latest.pt"),
                "next_learning_rate": self.config.learning_rate_at(min(
                    self.iteration, self.config.seed_steps - 1)),
                "numerical_success_claimed": False}

    def boundary(self):
        with torch.no_grad():
            matrices, initial = self.model()
            target = self.dp(matrices, initial)
            self.current = self.metrics(matrices, initial, target.square().sum())
            if self.seed_initial_fidelity is None:
                self.seed_initial_fidelity = self.current["fidelity"]
            self.observe(matrices, initial, self.current)
        reason = self.stop_reason()
        self.save_best(allow_verification=False)
        reason = self.stop.reason or reason
        checkpoint = {**self.common(), "kind": "latest", "config": dataclasses.asdict(self.config),
                      "runtime": self.runtime, "progress": self.progress(),
                      "model": to_cpu(self.model.state_dict()),
                      "optimizer": to_cpu(self.optimizer.state_dict()),
                      "rng": {"torch_cpu": torch.get_rng_state(),
                              "torch_mps": torch.mps.get_rng_state()},
                      "matrices": to_cpu(matrices), "initial": to_cpu(initial),
                      "metrics": self.current,
                      "candidate_sha256": tensor_digest(matrices, initial)}
        self.last_checkpoint = self.campaign.publish(checkpoint, atomic_checkpoint, stopped=reason is not None)
        self.save_best(allow_verification=reason is None)
        reason = self.stop_reason()
        if reason and not self.campaign.trial["terminal"]:
            self.registry.mark(self.campaign.trial["identity"], "interrupted")
        phase = "stopped" if reason else "running"
        status = self.status(phase, reason)
        atomic_json(self.directory / "status.json", status)
        self.events.emit(phase, reason=reason, progress=self.progress(),
                         current=self.current, gpu_memory=status["gpu_memory"],
                         mean_step_seconds=status["session"]["step_durations"]["mean_seconds"])
        return reason, status

    def stopped_without_initialization(self):
        reason = self.stop_reason()
        status = self.status("stopped", reason, checkpoint_saved=self.last_checkpoint is not None)
        if self.last_checkpoint:
            # Reconciliation has committed any terminal checkpoint. Republish its
            # unchanged tensors with this invocation's receipt, without using MPS.
            saved = dict(self.last_checkpoint)
            saved["invocation"] = {"session_id": self.campaign.session_id, "pid": os.getpid()}
            atomic_checkpoint(self.directory / "latest.pt", saved)
            progress = saved["progress"]
            status.update(progress=progress, current=saved["metrics"], trial=saved["trial"], config=saved["config"],
                          config_sha256=hash_json(saved["config"]),
                          checkpoint_receipt={**saved["invocation"],
                              "sha256": file_hash(self.directory / "latest.pt"),
                              "progress": {key: progress[key] for key in self.campaign.progress()}})
            status["session"]["completed_steps"] = progress["total_steps"] - self.session_start_steps
        atomic_json(self.directory / "status.json", status)
        self.events.emit("stopped", reason=reason, progress=status["progress"])
        print(json.dumps({"phase": "stopped", "stop_reason": reason,
                          "completed_steps": status["session"]["completed_steps"]}))
        return 0

    def run(self):
        try:
            if not self.campaign.select(self.stop_reason):
                return self.stopped_without_initialization()
            self.initialize()
            reason, status = self.boundary()
            while reason is None:
                if self.iteration == self.config.seed_steps:
                    if not self.campaign.select(self.stop_reason):
                        return self.stopped_without_initialization()
                    self.seed_initial_fidelity = None
                    self.new_model()
                    reason, status = self.boundary()
                    if reason:
                        break
                count = min(self.config.batch_steps, self.config.seed_steps - self.iteration)
                if self.args.max_steps:
                    count = min(count, self.args.max_steps - (self.total_steps - self.session_start_steps))
                started = time.perf_counter()
                for _ in range(count):
                    self.train_step()
                self.last_batch_seconds = time.perf_counter() - started
                reason, status = self.boundary()
            print(json.dumps({"phase": status["phase"], "stop_reason": reason,
                              "progress": status["progress"], "current": status["current"],
                              "status_path": str(self.directory / "status.json")}, allow_nan=False))
            return 0
        except Exception as error:
            details = "%s: %s" % (type(error).__name__, error)
            try:
                self.campaign.fail(details)
                # A failed update must not overwrite the last finite resumable state.
                atomic_json(self.directory / "status.json", self.status(
                    "error", self.stop.reason or "exception", checkpoint_saved=False, error=details))
                self.events.emit("error", error=details, traceback=traceback.format_exc()[-2048:])
            except Exception as publishing_error:
                print("could not publish final status: " + str(publishing_error), file=sys.stderr)
            print(details, file=sys.stderr)
            return 1
        finally:
            self.events.close()


def parser():
    result = argparse.ArgumentParser(description=__doc__)
    result.add_argument("--state-dir", default=str(default_state()))
    result.add_argument("--history-db", help="shared external SQLite registry")
    result.add_argument("--legacy-lineage", help="explicit converted lineage exclusion scope")
    result.add_argument("--session-id", help=argparse.SUPPRESS)
    result.add_argument("--forever", action="store_true", help="explicit infinite round-robin mode")
    result.add_argument("--max-steps", type=int, help="maximum additional Adam updates this invocation")
    result.add_argument("--max-seconds", type=float, help="soft wall budget, checked once per batch")
    result.add_argument("--status", action="store_true")
    result.add_argument("--verify", type=int, metavar="DIMENSION", help="verify a saved best on CPU")
    start = result.add_mutually_exclusive_group()
    start.add_argument("--resume", action="store_true", help="require latest.pt (otherwise auto-resume)")
    start.add_argument("--fresh-start", action="store_true", help="new traversal; requires a finished trial; retains history and bests")
    result.add_argument("--dimensions", type=lambda text: tuple(int(x) for x in text.split(",")))
    for name in ("seed_steps", "base_seed", "batch_steps", "log_max_bytes", "log_backups",
                 "verification_interval_steps", "verification_chunk_size"):
        result.add_argument("--" + name.replace("_", "-"), type=int)
    for name in ("learning_rate", "minimum_learning_rate", "verification_gap", "mps_memory_fraction"):
        result.add_argument("--" + name.replace("_", "-"), type=float)
    return result


def main(argv=None):
    argument_parser = parser()
    args = argument_parser.parse_args(argv)
    try:
        directory = external_path(args.state_dir)
        training_options = {field.name: getattr(args, field.name) for field in dataclasses.fields(Config)
                            if getattr(args, field.name) is not None}
        if args.status or args.verify is not None:
            if (args.status and args.verify is not None) or any((args.forever, args.max_steps is not None,
                    args.max_seconds is not None, args.resume, args.fresh_start, bool(training_options),
                    args.legacy_lineage, args.session_id)):
                raise ValueError("--status/--verify accept only --state-dir and their own argument")
            if args.status:
                path = directory / "status.json"
                value = json.loads(path.read_text()) if path.exists() else {
                    "phase": "absent", "state_directory": str(directory)}
                print(json.dumps(value, indent=2, allow_nan=False))
                return 0
            if args.verify not in DIMENSIONS:
                raise ValueError("verify dimension is outside the registered search dimensions")
            with StateLocks(directory):
                path = directory / ("best-%d.pt" % args.verify)
                record = load_checkpoint(path, directory)
                latest = directory / "latest.pt"
                saved = load_checkpoint(latest, directory) if latest.exists() else {}
                history = external_path(args.history_db or saved.get("history_db") or default_history())
                with Registry(history) as registry:
                    digest = tensor_digest(record["matrices"], record["initial"])
                    registry.verification(digest, "running")
                    try:
                        record["verification"] = verify_record(record, 256)
                    except Exception as error:
                        registry.verification(digest, "failed", {"error": str(error)})
                        raise
                    registry.verification(digest, "verified", record["verification"])
                    atomic_checkpoint(path, record)
                    print(json.dumps(record["verification"], indent=2, allow_nan=False))
            return 0
        if args.forever and (args.max_steps is not None or args.max_seconds is not None):
            raise ValueError("choose --forever or bounded --max-steps/--max-seconds")
        if not args.forever and args.max_steps is None and args.max_seconds is None:
            raise ValueError("explicit --forever or a bounded --max-steps/--max-seconds is required")
        if args.max_steps is not None and args.max_steps <= 0:
            raise ValueError("max steps must be positive")
        if args.max_seconds is not None and (not math.isfinite(args.max_seconds) or args.max_seconds <= 0):
            raise ValueError("max seconds must be finite and positive")
        if args.session_id is not None and not args.session_id:
            raise ValueError("session id must be nonempty")
        with StateLocks(directory), StopRequest() as stop:
            checkpoint_path = directory / "latest.pt"
            if args.resume and not checkpoint_path.exists():
                raise ValueError("--resume requires a local latest.pt")
            checkpoint = load_checkpoint(checkpoint_path, directory) if checkpoint_path.exists() else None
            config = Config(**checkpoint["config"]) if checkpoint else Config()
            config.dimensions = tuple(config.dimensions)
            for key, value in training_options.items():
                setattr(config, key, value)
            config.validate()
            history = external_path(args.history_db or (checkpoint or {}).get("history_db") or default_history())
            if checkpoint and checkpoint.get("history_db") != str(history):
                raise ValueError("checkpoint registry mismatch; use its recorded --history-db")
            with Registry(history) as registry:
                worker = Worker(directory, config, checkpoint, stop, args, registry)
                return worker.run()
    except (ValueError, OSError, KeyError, TypeError, sqlite3.Error) as error:
        print("configuration/checkpoint error: " + str(error), file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
