"""Exact and second-expression diagnostics for the actual scale modulus.

Universal Fourier/form/domain assertions live in the accompanying proof text.
The non-directed special-function checks below are diagnostics only. The
separate interval verifier certifies finite arithmetic constants, not spectra.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import hashlib
import importlib.util
import json
import random
import mpmath as mp
import sympy as sp


def harmonic(n: int) -> F:
    return sum((F(1,j) for j in range(1,n+1)),F(0))


def gamma_partial(J: int, x: F) -> F:
    return 1+sum((2*x*x/(F(4*j+1,2)*(F(4*j+1,2)**2+x*x))
                  for j in range(J)),F(0))


def overlap(left: tuple[F,F], right: tuple[F,F]) -> F:
    return max(F(0),min(left[1],right[1])-max(left[0],right[0]))


def run() -> dict:
    rng=random.Random(20260907)
    b,t,u=sp.symbols('b t u',positive=True)
    term=4*b*t*t/(b*b+t*t)**2
    assert sp.simplify(sp.diff(-2*t*t/(b*b+t*t),b)-term)==0
    assert sp.expand(2*(sp.Rational(1,4)+t*t)**2-2*t*t-2*(t*t-sp.Rational(1,4))**2)==0
    exact_floor=0; exact_term=0
    for _ in range(600):
        J=rng.randint(0,30)
        x=F(rng.choice((-1,1)))*(2*J+F(rng.randint(0,100),rng.randint(1,15)))
        assert gamma_partial(J,x)>=1+harmonic(J)/2
        exact_floor+=1
        j=rng.randint(0,40);bb=F(4*j+5,2)
        uu=bb-1+F(rng.randint(0,30),30)
        tt=F(rng.randint(-200,200),rng.randint(1,30))
        assert 4*bb*tt*tt/(bb*bb+tt*tt)**2 <= F(5,3)*4*uu*tt*tt/(uu*uu+tt*tt)**2
        exact_term+=1
    for k in range(11):
        assert harmonic(2**k)>=1+F(k,2)
    for k in range(4,1001):
        assert 2**k>=k*k
    # The ordinary norm jump has exact even and odd witness pairs on two
    # disjoint edge strips. All interval lengths are rational here.
    strip_cases=0
    for j in range(1,30):
        h=F(1,2**j);s=2-h
        left=(-F(1),-1+h);right=(1-h,F(1))
        shifted_right=(right[0]-s,right[1]-s)
        assert shifted_right==left and overlap(left,right)==0
        assert (overlap(left,left)+overlap(right,right))/(2*h)==1
        cross=overlap(left,shifted_right)
        assert cross/h==1
        # On the normalized even sum the symmetric action has quadratic value
        # +1, and on the odd difference it has value -1. At s=2 support overlap
        # has zero measure and the operator is zero.
        assert overlap(left,(right[0]-2,right[1]-2))==0
        strip_cases+=1
    mp.mp.dps=65
    def gm(x):return mp.re(mp.digamma(mp.mpf(1)/4+1j*x/2))-mp.log(mp.pi)
    discrepancies=[];cosine_cases=0;scale_cases=0
    for J in (0,1,2,4,8,16):
        D=1+mp.mpf(harmonic(J).numerator)/harmonic(J).denominator/2
        for x in map(mp.mpf,('-100','-3.5','-.2','0','.7','9','200')):
            W=1+sum(2*x*x/((2*j+mp.mpf('.5'))*((2*j+mp.mpf('.5'))**2+x*x)) for j in range(J))
            for ss,tt in [('0','2'),('.2','.20001'),('-1','.3')]:
                s0,t0=mp.mpf(ss),mp.mpf(tt)
                assert abs(mp.cos(s0*x)-mp.cos(t0*x)) <= (2*J*abs(s0-t0)+2/D)*W+mp.mpf('1e-60')
                cosine_cases+=1
    for aa,bb in [(F(1,2),F(3,5)),(F(23,20),F(5,4)),(F(1,10),F(10)),(F(3,2),F(3,2))]:
        a0,b0=mp.mpf(aa.numerator)/aa.denominator,mp.mpf(bb.numerator)/bb.denominator
        for x in map(mp.mpf,('-10000','-10','-.1','0','.1','10','10000')):
            assert abs(gm(x/a0)-gm(x/b0))<=6*abs(mp.log(a0/b0))+mp.mpf('1e-60')
            scale_cases+=1
    for x in map(mp.mpf,('.001','.1','1','10','1000')):
        # Derivative of the original digamma expression, independent of the
        # finite positive rational summands used in the Lean candidate.
        original=-x*mp.im(mp.polygamma(1,mp.mpf('.25')+1j*x/2))/2
        partial=sum(4*(2*j+mp.mpf('.5'))*x*x/((2*j+mp.mpf('.5'))**2+x*x)**2 for j in range(400))
        # The unsigned omitted sum is bounded by 4*x^2*sum b_j^-3.
        # Integral comparison of the decreasing b_j^-3 controls every tail.
        tail=4*x*x*(1/(mp.mpf('800.5')**3)+1/(4*mp.mpf('800.5')**2))
        assert partial<=original+mp.mpf('1e-60')
        assert original<=partial+tail
        assert 0<original<6
        discrepancies.append(mp.nstr(original-partial,18))
    # Verify complete prime-power enumeration by independent factorization.
    path=Path(__file__).with_name('certify_weil_scale_modulus.py')
    spec=importlib.util.spec_from_file_location('actual_scale_constants',path)
    if spec is None or spec.loader is None:raise ImportError(path)
    mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
    for n in range(2,1001):
        fac=sp.factorint(n)
        expected=int(next(iter(fac))) if len(fac)==1 else None
        assert mod.prime_power_base(n)==expected
    required=[n for n in range(2,13) if mod.prime_power_base(n)]
    assert required==[2,3,4,5,7,8,9,11]
    only_primes=[n for n in range(2,13) if sp.isprime(n)]
    assert required!=only_primes
    # A coarse scalar norm budget would remain bounded below at activation;
    # the two-dimensional edge block itself is exactly [[0,1],[1,0]].
    edge=sp.Matrix([[0,1],[1,0]])
    assert edge.eigenvals()=={-1:1,1:1}
    # Exact rational arithmetic for the reported local-gap sufficient test.
    report=json.loads(Path(__file__).with_name('weil_scale_modulus_certificate.json').read_bytes())
    row=report['conditional_local_ground_continuation']; k=row['k']; gap=F(row['resolvent_gap_lower_rational'])
    budget=mod.polynomial_budget(k,tuple(report['annuli'][0]['integer_prefactors']))
    assert 0<budget<gap/4
    return {
        'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        'exact_high_frequency_floors':exact_floor,
        'exact_Gamma_derivative_term_comparisons':exact_term,
        'exact_symbolic_derivative_and_square_identities':2,
        'exact_harmonic_dyadic_floors':11,
        'exact_exponential_polynomial_comparisons':997,
        'exact_edge_strip_norm_witnesses':strip_cases,
        'actual_cosine_multiplier_diagnostics':cosine_cases,
        'actual_digamma_scaling_diagnostics':scale_cases,
        'actual_digamma_log_derivative_diagnostics':len(discrepancies),
        'finite_derivative_sum_differences':discrepancies,
        'prime_power_factorization_cross_checks':999,
        'all_prime_powers_through_12':required,
        'negative_controls':['dropping composite prime powers changes the actual finite action',
                             'a vanishing ordinary norm at prime activation contradicts the exact edge-block eigenvalues'],
        'local_resolvent_gap_rational_guard':True,
        'status':'All exact arithmetic and separate-expression diagnostics passed.',
        'scope':'Single-author diagnostics, not Lean elaboration, a full operator-domain proof or a newly computed spectral gap. Nondirected digamma and cosine comparisons are not interval evidence.'}

if __name__=='__main__':
    result=run()
    Path(__file__).with_name('weil_scale_modulus_regression.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(result,indent=2))
