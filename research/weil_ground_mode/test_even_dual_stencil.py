"""Exact algebra and separately assembled diagnostics for the even dual trial.

These tests supplement the directed certificate. Bounded-symbol fixtures use
pi=3 and do not certify the real arithmetic symbol. The actual c=3 symbol is
separately checked against its digamma expression at selected signed modes.
No Lean compilation or independent-author review is asserted.
"""
from fractions import Fraction as F
from pathlib import Path
import hashlib, importlib.util, json, random
import mpmath as mp
import sympy as sp
import numpy as np
ROOT=Path(__file__).resolve().parent

def run():
    spec=importlib.util.spec_from_file_location('dual_source',ROOT/'certify_prime3_energy_dual.py')
    mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
    base=mod.load('base_check','certify_prime3_refined.py')
    data=json.loads((ROOT/'prime3_energy_dual_trial.json').read_bytes())
    full,t,s=mod.decode_trial(base,data)
    n,m,sn,sm,p=sp.symbols('n m sn sm p')
    original=(sn-sm)/(p*(m-n))+(-sn-sm)/(p*(m+n))+2*sm/(p*m)
    exact=2*n*(m*sn-n*sm)/(p*m*(m*m-n*n))
    assert sp.factor(original-exact)==0
    rng=random.Random(20260907)
    cases=0
    for _ in range(500):
        n=rng.randint(1,100);mm=rng.randint(2*n,200*n)
        sn,sm=F(rng.randint(-300,300),100),F(rng.randint(-300,300),100)
        for m in (mm,-mm):
            lhs=(sn-sm)/(3*(m-n))+(-sn-sm)/(3*(m+n))+2*sm/(3*m)
            rhs=F(2*n,3*m*(m*m-n*n))*(m*sn-n*sm)
            assert lhs==rhs and abs(lhs)<=F(4*n,m*m)
            cases+=1
    # Exact Gaussian-rational synthesis agrees with original 129 coordinates.
    reconstructed=[(F(0),F(0)) for _ in range(129)]
    for n in range(1,65):
        for j,a in ((64+n,1),(64-n,1),(64,-2)):
            reconstructed[j]=mod.gadd(reconstructed[j],mod.gscale(F(a),t[n]))
    assert reconstructed==full
    # Rounding a pivot AFTER elimination violates the exact condition.
    bad=list(full);old=bad[64];bad[64]=(F(round(old[0]*2**44),2**44),old[1])
    assert sum((x for x,y in bad),F(0))!=0
    assert sum((F(s[i])*bad[i][0] for i in range(129)),F(0))!=0
    mp.mp.dps=75
    L=mp.log(3);sign_modes=[1,2,3,8,17,64,65,1000,32768]
    intervals=base.symbol_array(np.array(sign_modes,dtype=np.int64))
    def symbol(n):
        w=2*mp.pi*n/L
        decay=sum(w*mp.power(3,-(2*j+mp.mpf('.5')))/((2*j+mp.mpf('.5'))**2+w*w) for j in range(100))
        gam=mp.im(mp.digamma(mp.mpf('.25')+1j*w/2))/2-decay
        return -2*w*(mp.cosh(L/2)-1)/(w*w+mp.mpf('.25'))-gam-mp.log(2)/mp.sqrt(2)*mp.sin(w*mp.log(2))
    for i,n in enumerate(sign_modes):
        value=symbol(n)
        assert mp.mpf(float(intervals.lo[i]))<value<mp.mpf(float(intervals.hi[i]))
        assert abs(symbol(-n)+value)<mp.mpf('1e-65')
    # Direct signed readout/stencil values, separate from interval construction.
    a=L/2;z=mp.mpc(20,mp.mpf(1)/4)
    tv=[mp.mpc(mp.mpf(x.numerator)/x.denominator,mp.mpf(y.numerator)/y.denominator) for x,y in t]
    checks=0;max_error=mp.mpf(0)
    for m in (65,128,1024,32769,-65,-32769):
        sm=symbol(m)
        direct=-sm/(mp.pi*m)*tv[0]
        paired=mp.mpc(0)
        for n in range(1,65):
            sn=symbol(n)
            direct+=tv[n]*((sn-sm)/(mp.pi*(m-n))+(-sn-sm)/(mp.pi*(m+n)))
            paired+=tv[n]*2*n*(m*sn-n*sm)/(mp.pi*m*(m*m-n*n))
        max_error=max(max_error,abs(direct-paired));checks+=1
    assert max_error<mp.mpf('1e-65')
    # Check that the retained exterior upper budget was not silently dropped.
    # An upper bound alone does not prove a positive actual exterior mass.
    report=json.loads((ROOT/'prime3_energy_dual_certificate.json').read_bytes())
    from mpmath import iv
    assert bool(iv.mpf(report['exterior_through_M_squared_upper'])>mod.rat(F(5,100000)))
    assert report['exact_trial_endpoint_and_candidate_constraints']
    return {
      'symbolic_original_column_identity':True,
      'exact_bounded_symbol_stencil_cases':cases,
      'actual_arithmetic_symbol_signed_modes':2*len(sign_modes),
      'actual_complex_trial_direct_column_checks':checks,
      'maximum_direct_column_discrepancy':mp.nstr(max_error,20),
      'exact_trial_reconstruction':True,
      'post_elimination_rounding_rejected':True,
      'recorded_exterior_upper_budget_exceeds_5e_minus5':True,
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'status':'Exact identities and separately assembled arithmetic diagnostics passed.',
      'scope':'Finite diagnostics by the same assistant; high-precision digamma point comparisons are not independent interval or kernel proofs. Bounded-symbol rational fixtures use denominator constant 3.'}

if __name__=='__main__':
    r=run(); (ROOT/'even_dual_stencil_regression.json').write_text(json.dumps(r,indent=2)+'\n')
    print(json.dumps(r,indent=2))
