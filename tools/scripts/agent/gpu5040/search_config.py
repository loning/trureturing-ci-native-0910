"""Scientific identities are independent of source provenance and I/O cadence."""

import dataclasses
import hashlib
import json
import math


OCCUPATION = (4, 2, 1, 1)
ALPHABET = (0, 1, 2, 3)
DIMENSIONS = (13, 16, 24, 32, 40, 48, 55)
WORD_COUNT = 840
OBJECTIVE = "||sum_legal A[w7] ... A[w0] v0 / sqrt(840)||^2"
RESTRICTIONS = {
    "field": "real",
    "isometry": "one fixed V: R^D -> R^4 tensor R^D, used eight times",
    "initial_memory": "one normalized trainable pure vector",
    "final_memory": "traced, no selected final vector",
    "postselection": False,
    "time_varying_controls": False,
    "entrywise_positivity": False,
    "interpretation": "numerical candidates only; search failure is not a lower bound",
}
ALGORITHM = "householder-occupation-dp-adam-v1"
SCHEMA = 2


@dataclasses.dataclass
class Config:
    dimensions: tuple = DIMENSIONS
    seed_steps: int = 5000
    base_seed: int = 5040
    learning_rate: float = 0.01
    minimum_learning_rate: float = 0.001
    batch_steps: int = 25
    log_max_bytes: int = 1048576
    log_backups: int = 3
    verification_gap: float = 1e-6
    verification_interval_steps: int = 1000
    verification_chunk_size: int = 256
    mps_memory_fraction: float = 0.25

    def validate(self):
        if not self.dimensions or len(set(self.dimensions)) != len(self.dimensions):
            raise ValueError("dimensions must be a nonempty list without duplicates")
        if any(type(d) is not int or d not in DIMENSIONS for d in self.dimensions):
            raise ValueError("search dimensions must be drawn from " + str(DIMENSIONS))
        integer_ranges = {
            "seed_steps": (1, 10000000), "base_seed": (0, 2 ** 63 - 1),
            "batch_steps": (1, 1000), "log_max_bytes": (4096, 67108864),
            "log_backups": (1, 10), "verification_interval_steps": (1, 10000000),
            "verification_chunk_size": (1, 4096),
        }
        for field, (low, high) in integer_ranges.items():
            value = getattr(self, field)
            if type(value) is not int or not low <= value <= high:
                raise ValueError("%s must be an integer in [%d, %d]" % (field, low, high))
        for field in ("learning_rate", "minimum_learning_rate", "verification_gap",
                      "mps_memory_fraction"):
            value = getattr(self, field)
            if not math.isfinite(value) or value <= 0:
                raise ValueError(field + " must be finite and positive")
        if self.minimum_learning_rate > self.learning_rate:
            raise ValueError("minimum learning rate must not exceed learning rate")
        if self.learning_rate > 1 or self.verification_gap > 1:
            raise ValueError("learning rate and verification gap must not exceed 1")
        if self.mps_memory_fraction > 1:
            raise ValueError("MPS memory fraction must be in (0, 1]")

    def learning_rate_at(self, iteration):
        fraction = iteration / max(1, self.seed_steps - 1)
        return self.minimum_learning_rate + 0.5 * (
            self.learning_rate - self.minimum_learning_rate) * (1 + math.cos(math.pi * fraction))


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":"), allow_nan=False)


def identity(value):
    return hashlib.sha256(canonical(value).encode("utf-8")).hexdigest()


def numerical_runtime(runtime):
    keys = ("python", "torch", "torch_git", "torch_build", "platform", "machine", "hardware", "actual_device",
            "training_precision", "cpu_fallback", "torch_cpu_threads", "deterministic_algorithms")
    result = {key: runtime.get(key) for key in keys}
    result["environment"] = {key: runtime.get("environment", {}).get(key) for key in (
        "PYTORCH_ENABLE_MPS_FALLBACK", "PYTORCH_MPS_FAST_MATH", "PYTORCH_MPS_PREFER_METAL",
        "VECLIB_MAXIMUM_THREADS", "OPENBLAS_NUM_THREADS", "OMP_NUM_THREADS", "MKL_NUM_THREADS")}
    return result


def descriptor(config, dimension, seed, runtime):
    return {
        "identity_schema": 1, "algorithm": ALGORITHM,
        "physical_model": {"field": "real", "occupation": list(OCCUPATION),
                           "alphabet": list(ALPHABET), "word_count": WORD_COUNT,
                           "objective": OBJECTIVE, "stationary_isometry": True,
                           "trainable_pure_initial": True, "final_memory": "traced",
                           "postselection": False, "time_varying_controls": False,
                           "entrywise_positivity": False},
        "dimension": dimension, "seed": seed, "budget": config.seed_steps,
        "dtype": "torch.float32",
        "initialization": {"reflectors": "D normalized randn(D,4D) rows on MPS",
                           "initial": "normalized randn(D) on MPS, drawn after reflectors",
                           "frame": "H[D-1] ... H[0] eye(4D,D)",
                           "rng": "torch.manual_seed and torch.mps.manual_seed; independent trial"},
        "optimizer": {"name": "torch.optim.Adam", "betas": [0.9, 0.999], "eps": 1e-8,
                      "weight_decay": 0, "amsgrad": False, "foreach": False, "fused": False,
                      "maximize": False, "capturable": False, "differentiable": False,
                      "decoupled_weight_decay": False, "gradient_clipping": None,
                      "loss": "1 - fidelity", "zero_grad_set_to_none": True,
                      "learning_rate": float(config.learning_rate),
                      "minimum_learning_rate": float(config.minimum_learning_rate),
                      "schedule": "min + (lr-min)/2*(1+cos(pi*i/max(1,budget-1))); before update"},
        "runtime": numerical_runtime(runtime) if runtime is not None else None,
    }


def scientific_without_runtime(value):
    return {key: item for key, item in value.items() if key not in ("runtime", "legacy_lineage")}


def legacy_descriptor(config, dimension, seed, lineage):
    return dict(descriptor(config, dimension, seed, None), legacy_lineage=lineage)
