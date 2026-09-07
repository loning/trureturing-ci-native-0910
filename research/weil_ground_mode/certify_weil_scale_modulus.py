"""Directed coefficients for an all-scale Weil form-continuity estimate.

This verifies the *finite constants* in the paper theorem, not new Weil
spectral gaps. The Fourier cutoff, harmonic lower bound and common-domain
argument are parameterized proofs in RH_RESEARCH_LANE_THEORY.md; the pointwise
Gamma/cosine inequalities have an accompanying Lean proof script.

No old spectral JSON is silently treated as a fresh computation. The optional
local-ground continuation row explicitly inherits the older complete c=3
coercivity certificate and has a very conservative dyadic step size.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import hashlib
import json
import math
import platform
import sys
from mpmath import iv

if not __debug__:
    raise RuntimeError('Do not run this verifier with Python -O.')


def rat(x: F | int):
    x = F(x)
    return iv.mpf(x.numerator) / x.denominator


def prime_power_base(n: int) -> int | None:
    if n < 2:
        return None
    p = 2
    while p * p <= n and n % p:
        p += 1
    if n % p:
        p = n
    m = n
    while m % p == 0:
        m //= p
    return p if m == 1 else None


def integer_upper(x) -> int:
    # The binary float is an untrusted proposal. The final interval guard
    # checks the exact integer against the directed real enclosure.
    proposed = math.floor(float(x.b)) + 1
    if not bool(x < proposed):
        raise ArithmeticError('Could not certify the proposed integer upper bound.')
    return proposed


def polynomial_budget(k: int, constants: tuple[int, int, int]) -> F:
    if k < 4:
        raise ValueError('The elementary inequality 2^k >= k^2 requires k>=4.')
    c0, c1, c2 = constants
    return F(c0, k**4) + F(c1, k**2) + F(c2, k + 6)


def run(digits: int = 90) -> dict:
    if not 70 <= digits <= 300:
        raise ValueError('Use 70 through 300 decimal interval digits.')
    iv.dps = digits
    gamma0 = -iv.euler - iv.pi/2 - 3*iv.ln(2) - iv.ln(iv.pi)
    assert bool(-6 < gamma0) and bool(gamma0 < 0)
    # Universal kernel majorants used in the step-packet sharpness proof.
    assert bool(iv.exp(rat(F(3, 2)))/2 < 3)
    assert bool(1/(1-iv.exp(-2)) < 2)
    results = []
    for lo, hi in [(F(1, 2), F(3, 5)), (F(23, 20), F(5, 4))]:
        m, A = rat(lo), rat(hi)
        exp_cap = iv.exp(2*A)
        P = math.floor(float(exp_cap.b))
        assert bool(P <= exp_cap) and bool(exp_cap < P+1)
        rows = []
        wsum, weighted_logs = rat(0), rat(0)
        for n in range(2, P+1):
            p = prime_power_base(n)
            if p is None:
                continue
            weight = iv.ln(p)/iv.sqrt(n)
            wsum += weight
            weighted_logs += weight*iv.ln(n)
            rows.append({'n': n, 'prime_base': p, 'weight': str(weight)})
        sinhA = (iv.exp(A)-iv.exp(-A))/2
        coshA = (iv.exp(A)+iv.exp(-A))/2
        prefactors = (6/m + 4*(coshA+A*sinhA),
                      4*weighted_logs/(m*m), 16*wsum)
        constants = tuple(integer_upper(x) for x in prefactors)
        log_max = max(abs(iv.ln(m)).b, abs(iv.ln(A)).b)
        shift_exact = 1-gamma0+6*log_max+2*wsum+4*A*coshA
        shift = integer_upper(shift_exact)
        tables = []
        for k in (16, 64, 256, 1024, 4096, 65536):
            bound = polynomial_budget(k, constants)
            # Exact upper bracket with a short denominator for readability.
            denom = 10**9
            upper = F((bound.numerator*denom)//bound.denominator+1, denom)
            assert bound < upper
            tables.append({'k': k, 'half_width_step': f'2^(-{2*k})',
                           'form_and_shifted_resolvent_norm_upper': str(upper)})
        results.append({'half_width_interval': [str(lo), str(hi)],
                        'common_arithmetic_cutoff': P,
                        'complete_prime_power_rows': rows,
                        'exact_prefactor_intervals': list(map(str, prefactors)),
                        'integer_prefactors': constants,
                        'common_positive_resolvent_shift': shift,
                        'shift_formula_upper_enclosure': str(shift_exact),
                        'all_k_formula': 'C0*4^(-k)+C1*2^(-k)+C2/(k+6), k>=1',
                        'readable_all_k_upper': 'C0/k^4+C1/k^2+C2/(k+6), k>=4',
                        'examples': tables})
    # c=3 lies strictly inside the first certified parameter interval.
    a0 = iv.ln(3)/2
    assert bool(rat(F(1, 2))+rat(F(1, 100)) < a0)
    assert bool(a0 < rat(F(3, 5))-rat(F(1, 100)))
    U, T = F(560909, 10**13), F(3, 250000)
    C = results[0]['common_positive_resolvent_shift']
    gap = 1/(U+C)-1/(T+C)
    assert gap > 0
    budget_sum = sum(results[0]['integer_prefactors'])
    k = (4*budget_sum*gap.denominator)//gap.numerator+1
    k = max(k, 4)
    e = polynomial_budget(k, tuple(results[0]['integer_prefactors']))
    assert e < gap/4
    continuation = {
        'base_half_width': 'log(3)/2', 'common_shift': C,
        'resolvent_gap_lower_rational': str(gap), 'k': k,
        'half_width_step_condition': f'|a-log(3)/2| <= 2^(-{2*k})',
        'checked': 'The exact sufficient form/resolvent budget is below one quarter of the inherited resolvent gap.',
        'scope': 'Inherits the prior actual c=3 simple-even/full-space gap certificate. That certificate was NOT rerun. The step is exceptionally conservative and is not a practical scale sweep.'}
    # Actual first missing prime at 5040: threshold inside the second annulus.
    a11 = iv.ln(11)/2
    assert bool(rat(F(23, 20)) < a11) and bool(a11 < rat(F(5, 4)))
    w11 = iv.ln(11)/iv.sqrt(11)
    activation = []
    for ell in (8, 16, 32):
        eps = rat(F(1, 2**ell))
        a = a11 + eps
        h = 2-iv.ln(11)/a
        assert bool(0 < h) and bool(h < 1)
        assert bool(a < iv.ln(13)/2)
        lower = w11/(30+12*iv.ln(1/h))
        assert bool(lower > 0)
        activation.append({'scale_increment': f'2^(-{ell})',
                           'edge_overlap_length': str(h),
                           'relative_prime_defect_lower': str(lower)})
    return {'source_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'interval_decimal_digits': digits,
            'gamma_zero_enclosure': str(gamma0),
            'annuli': results, 'conditional_local_ground_continuation': continuation,
            'prime11_symmetric_ordinary_norm_jump': str(w11),
            'prime11_logarithmic_sharpness_rows': activation,
            'status': 'All directed arithmetic-prefactor, exact dyadic-budget and activation guards passed.',
            'scope': 'Finite constants for a parameterized paper form/resolvent theorem. No new numerical ground value, no all-scale simple-even result, no Xi convergence, and no Lean or Scribe execution.',
            'python': platform.python_version()}


if __name__ == '__main__':
    d = int(sys.argv[1]) if len(sys.argv) > 1 else 90
    result = run(d)
    suffix = '' if d == 90 else f'_{d}'
    out = Path(__file__).with_name('weil_scale_modulus_certificate'+suffix+'.json')
    out.write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(result, indent=2))
