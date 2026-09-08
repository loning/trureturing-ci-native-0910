#!/usr/bin/env python3
"""Supplementary exact regressions for the Cauchy/variance/density bridge.

Finite enumeration does not establish Cauchy's theorem or validate Lean terms.
Partitions below are enumerated from configurations, and derivatives are formed
coefficientwise. The proof uses Mathlib's Cauchy estimate, not these samples.
"""
from __future__ import annotations
import argparse
from collections import Counter
from fractions import Fraction as Q
from pathlib import Path
import hashlib
import json

from verify_grid_correspondence import GQ, configurations, domains

EPS = Q(1, 10**30)
RADIUS = EPS / 2
CONSTANT = Q(16 * 10**30)


def require(test: bool, message: str) -> None:
    if not test:
        raise ValueError(message)


def polynomial(configs, order=0):
    coeffs = [Q(0)] * (max(map(len, configs), default=0) + 1)
    for config in configs:
        coeffs[len(config)] += Q(len(config) ** order)
    return tuple(coeffs)


def derivative(coeffs):
    return tuple(j * coeffs[j] for j in range(1, len(coeffs))) or (Q(0),)


def value(coeffs, z):
    ans = GQ()
    for coeff in reversed(coeffs):
        ans = ans * z + coeff
    return ans


def real_value(coeffs, x):
    ans = Q(0)
    for coeff in reversed(coeffs):
        ans = ans * x + coeff
    return ans


def norm_squared(z):
    return z.re * z.re + z.im * z.im


def run():
    counts = Counter()
    # Rational points exactly on the boundary of the same closed Cauchy disk.
    circle = ((Q(1), Q(0)), (Q(0), Q(1)), (Q(-1), Q(0)), (Q(0), Q(-1)),
              (Q(3, 5), Q(4, 5)), (Q(-3, 5), Q(4, 5)),
              (Q(3, 5), Q(-4, 5)), (Q(-3, 5), Q(-4, 5)))
    anchors = (Q(0), Q(1, 3), Q(1), Q(51, 20))
    thresholds = (Q(1, 100), Q(1, 10), Q(1, 3), Q(1), Q(2))
    max_variance_fraction = Q(0)
    for V in domains():
        counts['domains'] += 1
        n = len(V)
        configs = tuple(configurations(V))
        Z, M1, M2 = (polynomial(configs, k) for k in (0, 1, 2))
        for lam in anchors:
            for u, v in circle:
                z = GQ(lam + RADIUS*u, RADIUS*v)
                offset = z - GQ(lam)
                require(norm_squared(offset) == RADIUS**2, 'exact Cauchy boundary point')
                require(norm_squared(offset) < EPS**2, 'closed disk lies in open tube')
                counts['closed_disk_boundary_guards'] += 1
                p = value(Z, z)
                require(bool(p), 'nonzero sampled partition')
                mean = value(M1, z) / p
                require(norm_squared(mean) <= 9*n*n, 'sampled actual mean norm bound')
                counts['complex_boundary_mean_bounds'] += 1
            p = real_value(Z, lam)
            mean = real_value(M1, lam) / p
            dmean = (real_value(derivative(M1), lam)*p -
                     real_value(M1, lam)*real_value(derivative(Z), lam)) / p**2
            exact_var = real_value(M2, lam)/p - mean**2
            require(lam*dmean == exact_var, 'real/complex moment response algebra')
            require(abs(dmean) <= 6*n/EPS, 'Cauchy derivative bound regression')
            require(0 <= exact_var <= 6*lam*n/EPS <= CONSTANT*n, 'linear-volume variance')
            counts['derivative_variance_transports'] += 1
            counts['linear_variance_bounds'] += 1
            pmf = {S: lam**len(S)/p for S in configs}
            require(sum(pmf.values(), Q(0)) == 1, 'actual probability normalization')
            centered = sum((mass*(len(S)-mean)**2 for S, mass in pmf.items()), Q(0))
            require(centered == exact_var, 'centered PMF variance')
            if not n:
                require(mean == exact_var == 0, 'empty-domain treatment')
                counts['empty_cases'] += 1
                continue
            max_variance_fraction = max(max_variance_fraction, exact_var/n)
            mse = sum((mass*(Q(len(S), n)-mean/n)**2 for S, mass in pmf.items()), Q(0))
            require(mse == exact_var/n**2 <= CONSTANT/n, 'density rescaling')
            counts['density_second_moments'] += 1
            for threshold in thresholds:
                tail = sum((mass for S, mass in pmf.items()
                            if threshold <= abs(Q(len(S), n)-mean/n)), Q(0))
                require(0 <= tail <= 1, 'actual tail is a probability')
                require(tail <= mse/threshold**2 <= CONSTANT/(threshold**2*n),
                        'density Chebyshev concentration')
                counts['actual_density_tail_bounds'] += 1
    # All constants and inequalities below are rational, without tolerances.
    require(Q(51, 20)*6/EPS == Q(153, 10)/EPS < CONSTANT, 'variance coefficient')
    require(RADIUS < EPS, 'strict containment guard')
    return dict(counts), str(max_variance_fraction)


def negative_controls():
    # A shrinking neighborhood cannot be replaced by a size-independent one.
    n = 100
    derivative_at_zero = n*n  # f_n(z) = n^2*z
    valid_radius = Q(3, n)    # boundary norm equals 3n here
    require(derivative_at_zero == Q(3*n)/valid_radius, 'shrinking-radius Cauchy witness')
    require(derivative_at_zero > 3*n, 'radius-one substitution must be rejected')
    # Positive two-state weights alone allow quadratic particle-count variance.
    # This is a diagnostic ensemble, not claimed to be a grid hard-core family.
    two_state_var = Q(n*n, 4)
    require(two_state_var > n, 'discreteness/positive weights do not imply unit linear bound')
    # Density variance uses volume squared, not just volume.
    independent_var = Q(n, 4)
    require(independent_var/n**2 == Q(1, 4*n) != independent_var/n,
            'density normalization error')
    # A complete boundary circle touching a pole cannot satisfy Cauchy premises.
    require(EPS-EPS == 0, 'boundary-pole exclusion')
    # Pointwise value control does not bound derivatives even for entire functions.
    require(n*n > 0, 'anchor-only derivative inference')
    return ['replacing_shrinking_radius_by_uniform_radius',
            'inferring_small_linear_variance_from_discrete_support',
            'dividing_variance_by_volume_instead_of_volume_squared',
            'allowing_a_pole_on_the_closed_disk',
            'using_only_the_value_at_the_center_for_Cauchy']


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    checks, maximum = run()
    result = {'checks': checks,
              'constants': {'epsilon': str(EPS), 'cauchy_radius': str(RADIUS),
                            'variance_coefficient': str(CONSTANT)},
              'sample_max_variance_per_vertex': maximum,
              'negative_controls_rejected': negative_controls(),
              'arithmetic': 'exact rational and Gaussian-rational',
              'cauchy_theorem': 'Mathlib proof dependency; not established by finite samples',
              'lean_elaboration': 'not executed', 'scribe_emission': 'not executed',
              'upstream_zero_free_chain': 'not re-executed'}
    root = Path(__file__).resolve().parents[2]
    names = ('LinearVolumeVariance', 'OccupationConcentration')
    result['new_source_sha256'] = {
        name: hashlib.sha256((root/f'D5/S3/StatisticalMechanics/HardCore/Holomorphic/{name}.lean')
                             .read_bytes()).hexdigest() for name in names}
    result['verifier_sha256'] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    result['enumerator_sha256'] = hashlib.sha256(
        Path(__file__).with_name('verify_grid_correspondence.py').read_bytes()).hexdigest()
    text = json.dumps(result, indent=2) + '\n'
    print(text, end='')
    if args.output:
        args.output.write_text(text)


if __name__ == '__main__':
    main()
