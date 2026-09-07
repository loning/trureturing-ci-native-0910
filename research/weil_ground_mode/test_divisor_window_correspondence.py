"""Exact finite diagnostics for the divisor-to-Mellin and Euler-action dictionary.

These checks use rational multiplicative coordinates and prime-log coefficient
vectors. They do not prove the universal Lean statements or the L2 operator
realization. The two series implementations are independent finite algebra.
"""
from __future__ import annotations
from fractions import Fraction as Q
from functools import lru_cache
from pathlib import Path
import hashlib
import json
import math
import random

@lru_cache(None)
def factors(n: int) -> dict[int,int]:
    if n < 1: raise ValueError('positive integer required')
    out={}; p=2
    while p*p<=n:
        while n%p==0: out[p]=out.get(p,0)+1; n//=p
        p+=1
    if n>1:out[n]=out.get(n,0)+1
    return out

@lru_cache(None)
def divisors(n: int) -> tuple[int,...]:
    ds=[1]
    for p,e in factors(n).items():ds=[d*p**j for d in ds for j in range(e+1)]
    return tuple(sorted(ds))

def addlog(target, source, weight):
    for p,a in source.items():target[p]=target.get(p,Q(0))+a*weight

def clean(d):return {p:x for p,x in d.items() if x}

def wave_checks():
    count=0
    for N in (1,6,12,60,2520,5040,10080,60480):
        for lam in (Q(3,2),Q(2),Q(5,2),Q(3)):
            M=math.ceil(lam**2)+2
            points={1/lam,lam,Q(1),(lam+1)/2,lam/2,2/lam,lam**2,1/lam**2}
            for u in points:
                for degree in (0,2,4):
                    # Real rational seeds suffice for this diagnostic. The Lean
                    # source allows arbitrary complex seeds; no positivity used.
                    def h(t):return 1-t+t**degree if t<=lam else Q(0)
                    def inside(t):return 1/lam<=t<=lam
                    def raw(ds,t):return sum((h(d*t) for d in ds),Q(0)) if inside(t) else Q(0)
                    whole=tuple(range(1,M+1));missing=tuple(d for d in whole if N%d)
                    def B(ds):
                        out={}
                        if inside(u):
                            for n in whole:
                                nf=factors(n)
                                if len(nf)==1:
                                    p=next(iter(nf)); addlog(out,{p:1},raw(ds,n*u))
                        return clean(out)
                    def logrow(ds):
                        out={}
                        if inside(u):
                            for d in ds:addlog(out,factors(d),h(d*u))
                        return clean(out)
                    assert raw(divisors(N),u)==raw(whole,u)-raw(missing,u)
                    rhs=logrow(divisors(N));addlog(rhs,logrow(missing),Q(1));addlog(rhs,B(missing),Q(-1))
                    assert B(divisors(N))==clean(rhs)
                    count+=1
    return count

def dirichlet_checks():
    total=0
    def arithmetic_logderivative(N, cutoff):
        a={d:1 for d in divisors(N) if d<=cutoff}
        inv={1:1}
        for n in range(2,cutoff+1):
            inv[n]=-sum(a.get(d,0)*inv[n//d] for d in divisors(n) if d>1)
        rows={}
        for n in range(1,cutoff+1):
            out={}
            for d in divisors(n):addlog(out,factors(d),Q(a.get(d,0)*inv[n//d]))
            rows[n]=clean(out)
        return rows
    def local_formula(N,n):
        nf=factors(n);ef=factors(N)
        if len(nf)!=1:return {}
        p,k=next(iter(nf.items()))
        if p not in ef:return {}
        return clean({p:Q(1-(ef[p]+1)*int(k%(ef[p]+1)==0))})
    for N in (1,2,6,12,60,2520,5040,10080,15120,20160,30240,60480):
        rows=arithmetic_logderivative(N,80)
        for n in range(1,81):assert rows[n]==local_formula(N,n);total+=1
    rows=arithmetic_logderivative(5040,40)
    assert rows[11]=={} and rows[25]=={5:Q(-1)}
    # Original von Mangoldt coefficients have +log(11) and +log(5).
    assert rows[11]!={11:Q(1)} and rows[25]!={5:Q(1)}
    return total

def quotient_checks():
    # Symbolic complex algebra and exact rational cases: cancel nonzero scale,
    # and retain the denominator perturbation term of the quotient identity.
    import sympy as s
    Fz,F0,Kz,K0,alpha=s.symbols('Fz F0 Kz K0 alpha',nonzero=True)
    assert s.cancel((Fz/alpha)/(F0/alpha)-Fz/F0)==0
    assert s.cancel(Fz/F0-Kz/K0-(Fz-Kz-(Kz/K0)*(F0-K0))/F0)==0
    rng=random.Random(20260907)
    for _ in range(120):
        a=Q(rng.randint(1,12),rng.randint(1,12));b=Q(rng.randint(1,12),rng.randint(1,12))
        x=Q(rng.randint(-10,10),rng.randint(1,12));y=Q(rng.randint(-10,10),rng.randint(1,12))
        assert (x/a)/(y/a)==x/y if y else True
        assert x/b-y/a==(x-y-(y/a)*(b-a))/b
    return 122

def run():
    wave=wave_checks();algebra=dirichlet_checks();quot=quotient_checks()
    cell=(5040,10080,15120,20160,30240,60480)
    entries={}
    for N in (2520,)+cell:
        q=next(n for n in range(2,N+2) if N%n)
        assert q==11
        entries[str(N)]={'factorization':factors(N),'divisor_count':len(divisors(N)),
          'first_missing_divisor':q,'reciprocal_divisor_sum':str(sum((Q(1,d) for d in divisors(N)),Q(0)))}
    assert entries['2520']['reciprocal_divisor_sum']=='26/7'
    assert entries['5040']['reciprocal_divisor_sum']=='403/105'
    pair_first=min(set(divisors(2520))^set(divisors(5040)))
    assert pair_first==16
    for N in range(1,301):
        q=next(n for n in range(2,N+2) if N%n)
        assert len(factors(q))==1
    return {'exact_supported_wave_cases':wave,'two_function_identities_per_case':2,
      'exact_Dirichlet_log_derivative_coefficients':algebra,
      'quotient_identity_checks':quot,'first_missing_prime_power_fixtures':300,
      'divisor_carriers':entries,'first_2520_5040_divisor_difference':pair_first,
      'negative_controls':['5040 omits the prime-11 action once visible',
        '5040 finite Euler log derivative has -log(5), not +log(5), at 25',
        '2520 and 5040 scalar reciprocal-divisor sums differ despite identical prefix through 10'],
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'status':'All exact finite arithmetic, wave and normalization checks passed.',
      'scope':'Finite diagnostics; universal dictionary and L2 operator proof are paper/Lean-candidate work. No Robin, spectral-gap or Xi-limit conclusion.'}

if __name__=='__main__':
    result=run()
    Path(__file__).with_name('divisor_window_correspondence_checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
