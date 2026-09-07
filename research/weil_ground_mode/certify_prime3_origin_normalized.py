"""Origin-normalized genuine ground/prolate Fourier comparison.

Replay the actual full-tail energy-dual certificate. Replace the projective
normalization by FT(u)(z)/FT(u)(0), with the denominator independently bounded
away from zero. The same real sign and the same genuine prolate family are
used. There is no frequency-dependent fitted scale or zeta-value input.
The historical full-space coercivity remains inherited; Lean is not replayed.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import hashlib
import importlib.util
import json
import re
import sys
from mpmath import iv

if not __debug__:
    raise RuntimeError('Verification requires assertions; do not use -O.')
ROOT = Path(__file__).resolve().parent
DUAL_SHA = '55de99a16e2b4b3259cfc9a21667ece08821bbaf4507f805e5466ae339b538ff'

def rat(x):
    x = F(x)
    return iv.mpf(x.numerator) / x.denominator

def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

def complex_interval(text):
    parts = re.findall(r'\[[^\[\]]+\]', text)
    if len(parts) != 2:
        raise ValueError('Unexpected interval format.')
    return iv.mpc(iv.mpf(parts[0]), iv.mpf(parts[1]))

def run(digits: int = 110):
    if digits < 100:
        raise ValueError('Require at least 100 interval digits.')
    path = ROOT / 'certify_prime3_energy_dual.py'
    if hashlib.sha256(path.read_bytes()).hexdigest() != DUAL_SHA:
        raise ValueError('Unreviewed energy-dual dependency.')
    dual = load('origin_dual', path)
    prior = dual.run(digits)
    assert prior['status'] == 'All exact rational constraints and directed full-tail/readout guards passed.'
    base = load('origin_candidate', ROOT / 'certify_prime3_refined.py')
    prolate = load('origin_prolate', ROOT / 'certify_prime3_prolate_model.py')
    model = prolate.run(digits)
    iv.dps = digits
    L, a = iv.ln(3), iv.ln(3)/2
    z = iv.mpc(20, rat(F(1,4)))
    rho = rat(F(1,1000))
    integers = list(base.CANDIDATE)
    assert len(integers) == 129 and integers == integers[::-1]
    candidate_norm = iv.sqrt(sum(n*n for n in integers))
    K0 = iv.sqrt(L) * integers[64] / candidate_norm
    assert bool(abs(K0) > 0)
    k0mod=abs(K0)
    Delta = rat(F(560909,10**13) - F(2252813807,40960000000000000))
    kappa = rat(F(3,250000) - F(2252813807,40960000000000000))
    # Zero trial for the actual centered origin representer 1 on [-a,a].
    C0 = (L-K0*K0)/kappa
    assert bool(C0 > 0)
    delta0 = iv.sqrt(Delta*C0)
    origin_floor = k0mod-delta0
    assert bool(origin_floor > 0)
    H = a*iv.sqrt(L)*iv.exp(a*(rat(F(1,4))+rho))
    dg = H*rho
    Kz = complex_interval(prior['candidate_Fourier_point'])
    epsz = iv.mpf(prior['uniform_disk_ground_candidate_Fourier_error'])
    ground_candidate = (epsz+(abs(Kz)+dg)*delta0/k0mod)/origin_floor

    # Build the same certified zero-integral Legendre polynomial seed.
    pdata = json.loads((ROOT/'prime3_prolate_proposal.json').read_bytes())
    vectors=[]
    for prop in pdata['proposals']:
        nums=list(map(int,prop['vector_numerators']))
        norm=iv.sqrt(rat(sum((F(n*n,2**500) for n in nums),F(0))))
        vectors.append([rat(F(n,2**250))/norm for n in nums])
    ratio=vectors[1][0]/vectors[0][0]
    hh=[vectors[1][j]-ratio*vectors[0][j] for j in range(32)]
    hh[0]=rat(0)
    coefficients=[rat(0) for _ in range(32)]
    for j in range(1,32):
        poly=prolate.legendre_coefficients(2*j)
        fac=hh[j]*iv.sqrt(rat(F(4*j+1,2)))
        for r in range(j+1):
            coefficients[r]+=fac*rat(poly[2*r])/3**r
    def pft(zz):
        result=iv.mpc(0)
        for r,ar in enumerate(coefficients):
            rate=2*r+rat(F(1,2))+iv.j*zz
            for m in (1,2):
                result+=4*ar*m**(2*r)*(iv.exp(rate*(a-iv.ln(m)))-iv.exp(-a*rate))/rate
        return result
    pn=iv.mpf(model['unnormalized_mellin_model_norm_interval'])
    epsp=iv.mpf(model['normalized_true_vs_polynomial_model_error'])
    P0poly=(-pft(iv.mpc(0))/pn).real
    error0=iv.sqrt(L)*epsp
    P0=P0poly+iv.mpf([-error0.b,error0.b])
    assert bool(abs(P0poly)>error0)
    p0mod=abs(P0)
    Pzpoly=-(pft(z)+pft(-z))/(2*pn)
    errorz=iv.sqrt(L)*iv.exp(a/4)*epsp
    # Central quotient difference, with true-model denominator variation included.
    center_difference=abs(Kz/K0-Pzpoly/P0poly)
    center_difference+=(errorz+abs(Pzpoly/P0poly)*error0)/p0mod
    fixed_sign=iv.mpf(model['polynomial_model_candidate_overlap'])
    assert bool(fixed_sign<0)
    l2_difference=rat(F(113,100000))
    normalized_l2_difference=l2_difference/k0mod+abs(K0-P0)/(k0mod*p0mod)
    candidate_prolate=center_difference+dg*normalized_l2_difference
    total=ground_candidate+candidate_prolate
    normalized_floor=iv.mpf(prior['uniform_disk_ground_Fourier_floor'])/(k0mod+delta0)
    assert bool(origin_floor > rat(F(797,1000)))
    assert bool(p0mod > rat(F(805,1000)))
    assert bool(ground_candidate < rat(F(447,10**6)))
    assert bool(candidate_prolate < rat(F(57,10**6)))
    assert bool(total < rat(F(51,100000)))
    assert bool(normalized_floor > rat(F(43,100000)))
    return {
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'replayed_dependency_sha256':DUAL_SHA,
      'interval_decimal_digits':digits,
      'point':['20','1/4'], 'closed_disk_radius':'1/1000',
      'candidate_origin':str(K0), 'origin_dual_coefficient':str(C0),
      'projective_ground_origin_error':str(delta0),
      'projective_ground_origin_modulus_lower':str(origin_floor),
      'genuine_unit_prolate_origin':str(P0),
      'origin_normalized_ground_candidate_disk_error':str(ground_candidate),
      'origin_normalized_candidate_prolate_center_error':str(center_difference),
      'origin_normalized_candidate_prolate_disk_error':str(candidate_prolate),
      'origin_normalized_ground_prolate_disk_error':str(total),
      'origin_normalized_ground_disk_modulus_lower':str(normalized_floor),
      'rational_claims': {'origin_ground_modulus_lower':'797/1000', 'origin_unit_prolate_modulus_lower':'805/1000', 'normalized_ground_prolate_disk_error_upper':'51/100000', 'normalized_ground_disk_modulus_lower':'43/100000'},
      'normalization':'FT(u)(z)/FT(u)(0) versus FT(p_h^+)(z)/FT(p_h^+)(0). All global phases, L2 norms and <k,u> cancel algebraically.',
      'status':'All pinned full-tail replays and both origin-denominator checks passed.',
      'scope':'Fixed arithmetic window, genuine models; inherited full-space coercivity and paper operator/domain bridge. No all-scale rate, Xi limit, or Lean/Scribe execution.'
    }

if __name__=='__main__':
    digits=int(sys.argv[1]) if len(sys.argv)>1 else 110
    result=run(digits)
    suffix='' if digits==110 else '_'+str(digits)
    (ROOT/('prime3_origin_normalized_certificate'+suffix+'.json')).write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
