"""Exact arithmetic for the moving-scale full-residual cutoff.

The finite mass and gain must bound the actual arithmetic expressions in
WeilMovingScaleResidual.lean. This module does not certify those premises,
Weil eigenvalues, a prolate error rate, or the Riemann hypothesis. Its tests
are exact finite regressions, not a Lean kernel replay.
"""
from __future__ import annotations

import argparse
from fractions import Fraction
import json
from pathlib import Path
import random
from typing import Union

Rational = Union[int, str, Fraction]


def rational(value: Rational) -> Fraction:
    if type(value) is float or type(value) is bool:
        raise TypeError("Use exact integers, rational strings or Fraction, not binary floats")
    return Fraction(value)


def natural_ceiling(value: Fraction) -> int:
    return max(0, -((-value.numerator) // value.denominator))


def residual_cutoff(bandwidth: int, frequency_cap: int, mass: Rational,
                    gain: Rational, tolerance: Rational) -> int:
    """A sufficient cutoff. Deliberately not asserted optimal or inexpensive."""
    if type(bandwidth) is not int or type(frequency_cap) is not int:
        raise TypeError("Bandwidth and frequency cap must be natural integers")
    if bandwidth < 0 or frequency_cap < 0:
        raise ValueError("Bandwidth and frequency cap must be nonnegative")
    h, g, t = map(rational, (mass, gain, tolerance))
    if h < 0 or g < 0 or t <= 0:
        raise ValueError("Require mass,gain>=0 and tolerance>0")
    m = max(2 * bandwidth + 1, 2 * frequency_cap + 1,
            natural_ceiling(g * h / t) + 1)
    if not (m > bandwidth and m > 2 * frequency_cap and g * h < t * m):
        raise ArithmeticError("Internal exact cutoff guard failed")
    return m


def polynomial_mass_cap(prime_cutoff: int, bandwidth: int,
                        coefficient_l1: Rational, prefactor_norm: Rational) -> Fraction:
    """The proved all-c cap, given certified finite coefficient/norm bounds."""
    if type(prime_cutoff) is not int or prime_cutoff < 2:
        raise ValueError("Require integer prime cutoff >=2")
    if type(bandwidth) is not int or bandwidth < 0:
        raise ValueError("Require natural bandwidth")
    l1, pref = map(rational, (coefficient_l1, prefactor_norm))
    if l1 < 0 or pref < 0:
        raise ValueError("Norm upper bounds must be nonnegative")
    b = prime_cutoff**2 + 2 * prime_cutoff
    return 32 * b**2 * l1**2 * (1 + bandwidth**2 + 4*bandwidth**4) + 64*pref**2


def scale_cutoff(index: int, bandwidth: int, frequency_cap: int,
                 mass: Rational, gain: Rational) -> int:
    if type(index) is not int or index < 0:
        raise ValueError("Scale index must be a natural integer")
    return residual_cutoff(bandwidth, frequency_cap, mass, gain,
                           Fraction(1, 4 ** (index + 1)))


def run_tests() -> dict:
    """Includes rapid budget growth and a degenerating spectral gap.

    All scale-family examples here are synthetic algebraic stress cases.
    They are never reported as new certificates for actual Weil windows.
    """
    rng = random.Random(2026090709)
    cases = 0
    for _ in range(1600):
        n, r = rng.randrange(500), rng.randrange(500)
        h = Fraction(rng.randrange(10**8), rng.randrange(1, 10**5))
        g = Fraction(rng.randrange(10**7), rng.randrange(1, 10**4))
        t = Fraction(rng.randrange(1, 1000), rng.randrange(1, 10**7))
        m = residual_cutoff(n, r, h, g, t)
        assert g * h / m < t and m >= 2 * n + 1 and m >= 2 * r + 1
        cases += 1

    boundary_cases = 0
    for k in range(1, 80):
        for gain in (Fraction(0), Fraction(1), Fraction(4**k)):
            m = residual_cutoff(0, 0, k, gain, 1)
            assert m == natural_ceiling(gain * k) + 1
            assert gain * k < m
            boundary_cases += 1

    # Check the algebraic reduction of the actual sharp-tail expression to
    # mass/M. 'p' is an arbitrary positive scalar in this finite regression,
    # not a numerical approximation to pi and not new arithmetic symbol data.
    mass_reductions = 0
    for _ in range(1000):
        n = Fraction(rng.randrange(30), rng.randrange(1, 6))
        m = max(1, 2 * natural_ceiling(n) + 1) + rng.randrange(20)
        b, l1, x, y, pref_sq = [Fraction(rng.randrange(500), rng.randrange(1, 30))
                                for _ in range(5)]
        p = Fraction(rng.randrange(1, 50), rng.randrange(1, 10))
        q_m = 2 * b * n**2 * m / (p * (m - n)) * l1
        q_cap = 4 * b * n**2 / p * l1
        sharp = (16 * x / (p**2 * m) + 16 * y / (p**2 * m**3)
                 + 8 * q_m**2 / m**5 + 64 * pref_sq / (9 * m**3))
        mass = 16 * x / p**2 + 16 * y / p**2 + 8 * q_cap**2 + 64 * pref_sq / 9
        assert q_m <= q_cap and sharp <= mass / m
        mass_reductions += 1

    polynomial_checks = 0
    for _ in range(800):
        c, n = rng.randrange(2, 100), rng.randrange(50)
        l1, pref = Fraction(rng.randrange(100), 13), Fraction(rng.randrange(100), 17)
        b = Fraction(c*c+2*c) * Fraction(rng.randrange(101), 100)
        p = 1 + Fraction(rng.randrange(100), 19)
        x, y = 2*b*b*l1*l1, 2*b*b*n*n*l1*l1
        q_cap = 4*b*n*n*l1/p
        mass = 16*x/p**2 + 16*y/p**2 + 8*q_cap**2 + 64*pref**2/9
        assert mass <= polynomial_mass_cap(c, n, l1, pref)
        polynomial_checks += 1

    scales = []
    for j in range(1, 25):
        # No bound on growth is needed. In particular kappa has no positive
        # common lower bound. The gain pays inverse kappa exactly.
        kappa = Fraction(1, 2 ** (j * j))
        energy_width = Fraction(1, 2**j)
        normalization_sq = Fraction(2 ** (3*j))
        gain = normalization_sq * energy_width / kappa
        mass = Fraction(2 ** (j**3))
        m = scale_cutoff(j, 2**j, j, mass, gain)
        tol = Fraction(1, 4 ** (j + 1))
        assert gain * mass / m < tol
        scales.append({"index": j, "cutoff_bits": m.bit_length(),
                       "tolerance": str(tol)})

    # Fixed-scale convergence is not diagonal convergence: e_(j,M)=j/M
    # tends to zero in M for each j, yet e_(j,j)=1 forever.
    for j in range(1, 100):
        assert Fraction(j, j) == 1
        m = scale_cutoff(j, 0, 0, j, 1)
        assert Fraction(j, m) < Fraction(1, 4 ** (j + 1))

    rejected = []
    for name, args in [
        ("zero-tolerance", (1, 1, 1, 1, 0)),
        ("negative-gain", (1, 1, 1, -1, 1)),
        ("negative-mass", (1, 1, -1, 1, 1)),
        ("negative-bandwidth", (-1, 1, 1, 1, 1)),
        ("binary-float", (1, 1, 1.0, 1, 1)),
    ]:
        try:
            residual_cutoff(*args)
        except (ValueError, TypeError):
            rejected.append(name)
        else:
            raise AssertionError("Invalid input accepted: " + name)

    return {"exact_random_cutoff_cases": cases,
            "strict_integer_and_zero_gain_cases": boundary_cases,
            "sharp_to_mass_reductions": mass_reductions,
            "finite_data_polynomial_caps": polynomial_checks,
            "synthetic_degenerating_gap_scales": scales,
            "fixed_scale_vs_diagonal_control": "j/M has diagonal value 1 at M=j; scheduled tails meet their budgets",
            "invalid_inputs_rejected": rejected,
            "scope": "Exact arithmetic and finite algebraic regressions only. Synthetic scale families, no additional actual Weil-window certificates.",
            "lean_kernel_executed": False}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path,
                        default=Path(__file__).with_name("residual_scale_schedule_validation.json"))
    args = parser.parse_args()
    data = run_tests()
    args.output.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({k: data[k] for k in ("exact_random_cutoff_cases",
        "strict_integer_and_zero_gain_cases", "sharp_to_mass_reductions", "invalid_inputs_rejected")}, indent=2))


if __name__ == "__main__":
    main()
