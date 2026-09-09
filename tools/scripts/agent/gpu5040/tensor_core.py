"""Real stationary isometries and the pure occupation-target contraction."""

import itertools
import math
import time

import numpy as np
import torch
from torch import nn


from search_config import ALPHABET, DIMENSIONS, OBJECTIVE, OCCUPATION, RESTRICTIONS, WORD_COUNT


def normalize(x, dim):
    # A zero vector deliberately produces nonfinite values, caught by the worker.
    return x / x.square().sum(dim=dim, keepdim=True).sqrt()


def householder_frame(reflectors, basis=None):
    """H[D-1] ... H[0] E, with D rank-one updates to a (4D)-by-D frame."""
    dimension, ambient = reflectors.shape
    if basis is None:
        basis = torch.eye(ambient, dimension, dtype=reflectors.dtype,
                          device=reflectors.device)
    frame = basis
    for h in normalize(reflectors, dim=1).unbind(0):
        frame = frame - 2 * h[:, None] * (h @ frame)[None, :]
    return frame


class RealIsometry(nn.Module):
    def __init__(self, dimension, device, dtype=torch.float32):
        super().__init__()
        self.dimension = dimension
        self.reflectors = nn.Parameter(normalize(
            torch.randn(dimension, 4 * dimension, device=device, dtype=dtype), 1))
        self.initial = nn.Parameter(normalize(
            torch.randn(dimension, device=device, dtype=dtype), 0))
        self.register_buffer("basis", torch.eye(4 * dimension, dimension,
                                                device=device, dtype=dtype), persistent=False)

    def forward(self):
        frame = householder_frame(self.reflectors, self.basis)
        return frame.reshape(4, self.dimension, self.dimension), normalize(self.initial, 0)


class OccupationDP:
    """Alphabet index i is the first axis of A[i, next_memory, memory]."""

    def __init__(self, occupation=OCCUPATION, device="cpu"):
        self.occupation = tuple(occupation)
        if not self.occupation or any(type(n) is not int or n < 0 for n in occupation):
            raise ValueError("occupation must contain nonnegative integers")
        self.word_count = math.factorial(sum(occupation)) // math.prod(
            math.factorial(n) for n in occupation)
        box = list(itertools.product(*(range(n + 1) for n in occupation)))
        self.layers = []
        self.widths = [1]
        previous = {tuple(0 for _ in occupation): 0}
        for length in range(1, sum(occupation) + 1):
            current = [b for b in box if sum(b) == length]
            indices = []
            for i in range(len(occupation)):
                indices.append([
                    previous[tuple(n - int(j == i) for j, n in enumerate(b))]
                    if b[i] else len(previous) for b in current
                ])
            # Constant one-hot incidence avoids repeated-index scatter in MPS backward.
            incidence = torch.nn.functional.one_hot(torch.tensor(indices), len(previous) + 1)
            self.layers.append(incidence[..., :-1].to(device=device, dtype=torch.float32))
            self.widths.append(len(current))
            previous = {b: j for j, b in enumerate(current)}

    def __call__(self, matrices, initial):
        states = initial[None, :]
        alphabet, dimension, _ = matrices.shape
        for incidence in self.layers:
            predecessors = torch.matmul(incidence.to(dtype=states.dtype), states)
            states = torch.bmm(matrices, predecessors.transpose(1, 2)).sum(0).T
        return states[0] / math.sqrt(self.word_count)


def gram_error(matrices):
    dimension = matrices.shape[-1]
    frame = matrices.reshape(-1, dimension)
    return (frame.T @ frame - torch.eye(dimension, device=frame.device,
                                        dtype=frame.dtype)).abs().max()


def enumerated_chunks(matrices, initial, occupation, chunk_size):
    """Independent CPU float64 full-word evolution; no occupation DP or pruning."""
    alphabet = len(occupation)
    length = sum(occupation)
    for start in range(0, alphabet ** length, chunk_size):
        stop = min(start + chunk_size, alphabet ** length)
        words = np.stack(np.unravel_index(np.arange(start, stop),
                                         (alphabet,) * length), axis=1)
        states = np.broadcast_to(initial, (stop - start, initial.size)).copy()
        for position in range(length):
            following = np.empty_like(states)
            for label in range(alphabet):
                mask = words[:, position] == label
                following[mask] = states[mask] @ matrices[label].T
            states = following
        counts = np.stack([(words == label).sum(axis=1)
                           for label in range(alphabet)], axis=1)
        legal = (counts == np.asarray(occupation)).all(axis=1)
        yield states, legal


def verify_full_output(matrices, initial, occupation=OCCUPATION, chunk_size=256):
    """Verify the supplied tensors unchanged; do not renormalize or refit them.

    The target residual is computed directly in a second pass to avoid subtracting
    two numbers near one. The generic rank-one residual also tests memory purity.
    """
    started = time.perf_counter()
    if not 1 <= chunk_size <= 4096:
        raise ValueError("verification chunk size must be in [1, 4096]")
    a = np.asarray(matrices, dtype=np.float64)
    v = np.asarray(initial, dtype=np.float64)
    if a.shape != (len(occupation), v.size, v.size) or v.ndim != 1:
        raise ValueError("invalid candidate tensor shapes")
    if not np.isfinite(a).all() or not np.isfinite(v).all():
        raise ValueError("candidate contains nonfinite values")
    count = math.factorial(sum(occupation)) // math.prod(math.factorial(n) for n in occupation)
    target = np.zeros_like(v)
    memory_density = np.zeros((v.size, v.size), dtype=np.float64)
    norm_squared = forbidden = 0.0
    legal_count = 0
    for states, legal in enumerated_chunks(a, v, occupation, chunk_size):
        target += states[legal].sum(axis=0)
        memory_density += states.T @ states
        norm_squared += float(np.square(states).sum())
        forbidden += float(np.square(states[~legal]).sum())
        legal_count += int(legal.sum())
    if legal_count != count:
        raise RuntimeError("full enumeration legal-word count mismatch")
    target /= math.sqrt(count)
    fidelity = float(target @ target)
    residual_squared = 0.0
    for states, legal in enumerated_chunks(a, v, occupation, chunk_size):
        states[legal] -= target / math.sqrt(count)
        residual_squared += float(np.square(states).sum())
    largest = float(np.linalg.eigvalsh(memory_density)[-1])
    frame = a.reshape(-1, v.size)
    return {
        "method": "independent numpy CPU float64 full enumeration, two chunked passes",
        "candidate_modified": False,
        "dimension": int(v.size),
        "occupation": list(occupation),
        "full_words": len(occupation) ** sum(occupation),
        "legal_words": legal_count,
        "chunk_size": chunk_size,
        "norm": math.sqrt(norm_squared),
        "norm_squared": norm_squared,
        "initial_norm": float(np.linalg.norm(v)),
        "gram_max_abs_error": float(np.max(np.abs(frame.T @ frame - np.eye(v.size)))),
        "target_fidelity": fidelity,
        "forbidden_leakage_squared": forbidden,
        "target_separated_memory_residual_l2": math.sqrt(residual_squared),
        "target_separated_memory_residual_squared": residual_squared,
        "best_product_memory_residual_l2": math.sqrt(max(0.0, norm_squared - largest)),
        "largest_memory_density_eigenvalue": largest,
        "target_overlap_vector": target.tolist(),
        "seconds": time.perf_counter() - started,
        "interpretation": "finite precision evidence, not success, closure, or a lower bound",
    }
