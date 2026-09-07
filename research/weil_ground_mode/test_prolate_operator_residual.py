"""Second-implementation diagnostics for the complete residual integrator.

The numerical point comparisons use high-precision arithmetic, not certified
quadrature. The separate interval verifier alone supplies the numerical
residual enclosure. These tests neither compile Lean nor certify all scales.
"""
from fractions import Fraction as F
from pathlib import Path
import hashlib
import importlib.util
import json
import mpmath as mp
import sympy as sp

ROOT=Path(__file__).resolve().parent

def run():
    target=ROOT/'certify_prime3_prolate_operator_residual.py'
    spec=importlib.util.spec_from_file_location('full_residual_diagnostic',target)
    if spec is None or spec.loader is None: raise ImportError(target)
    mod=importlib.util.module_from_spec(spec); spec.loader.exec_module(mod)
    x,A,B=sp.symbols('x A B',real=True)
    primitive=-sp.exp(-x)*((A+B*x)**2+2*B*(A+B*x)+2*B**2)
    assert sp.simplify(sp.diff(primitive,x)-sp.exp(-x)*(A+B*x)**2)==0
    # The same primitive in physical endpoint distance.
    t=sp.symbols('t',positive=True)
    physical=t*((A-B*sp.log(t))**2+2*B*(A-B*sp.log(t))+2*B**2)
    assert sp.simplify(sp.diff(physical,t)-(A-B*sp.log(t))**2)==0
    # Every dyadic cell and both singular strips cover exactly the whole interval.
    for depth in (4,16,48,64):
        intervals=[(F(0),F(1,2**depth)),(1-F(1,2**depth),F(1))]
        for j in range(1,depth):
            near,far=F(1,2**(j+1)),F(1,2**j)
            intervals.extend([(near,far),(1-far,1-near)])
        intervals.sort()
        assert intervals[0][0]==0 and intervals[-1][1]==1
        assert all(a[1]==b[0] for a,b in zip(intervals,intervals[1:]))
        assert sum((r-l for l,r in intervals),F(0))==1
    mp.mp.dps=90
    m=mod.make_model(mp.mp)
    a=m['a']; log2=mp.log(2); b=a-log2; lam=mp.sqrt(3)
    def e(y):
        if y < -a or y > a: return mp.mpf(0)
        def p(z):
            return 4*mp.exp(z/2)*sum(
              sum(m['A'][r]*(j*mp.exp(z))**(2*r) for r in range(32))
              for j in (1,2) if z<=a-mp.log(j))
        return (p(y)+p(-y))/2
    def gamma_atom(y,r,up):
        alpha=2*r+mp.mpf('.5')
        if y<up:
            dp,dm=up-y,y+a
            factor=(-mp.euler-mp.log(2*mp.pi)-dp-mp.log(-mp.expm1(-2*dp))/2
              +mp.atanh(mp.exp(-dm))
              -sum(mp.expm1(2*j*dp)/(2*j) for j in range(1,r+1))
              +sum(-mp.expm1(-(2*j-1)*dm)/(2*j-1) for j in range(1,r+1)))
            return mp.exp(alpha*y)*factor
        P=lambda z:mp.atanh(z)-sum(z**(2*j-1)/(2*j-1) for j in range(1,r+1))
        return -mp.exp(alpha*y)*(P(mp.exp(up-y))-P(mp.exp(-a-y)))
    def original(y):
        gp=lambda z:sum(4*m['A'][r]*j**(2*r)*gamma_atom(z,r,a-mp.log(j))
                      for j in (1,2) for r in range(32))
        return (gp(y)+gp(-y))/2+2*mp.cosh(y/2)*m['poleint']\
          -log2/mp.sqrt(2)*(e(y+log2)+e(y-log2))-m['mu']*e(y)
    point_errors=[]; symmetry_errors=[]; exterior_witness=mp.mpf(0)
    for i,((l,r),piece) in enumerate(zip(m['bounds'],m['pieces'])):
        for num in (1,3,7,9):
            y=l+(r-l)*num/10
            direct=original(y); combined=mod.value(piece,y,mp.mp)
            point_errors.append(abs(direct-combined)/(1+abs(direct)))
            symmetry_errors.append(abs(direct-original(-y))/(1+abs(direct)))
        if i==2:
            y=(l+r)/2
            exterior_witness=abs(sum(4*m['A'][rr]*2**(2*rr)*gamma_atom(y,rr,b)
                                    for rr in range(32)))
    assert max(point_errors)<mp.mpf('1e-65')
    assert max(symmetry_errors)<mp.mpf('1e-65')
    assert exterior_witness>mp.mpf('1e-6')
    # Exact geometric-series tail in a simple analytic disc validates the
    # constants in the squared-error transport. This is not an actual-model proof.
    cover_tests=0
    for n in (2,4,8,16):
        for s in (F(-1),F(-1,2),F(0),F(1,2),F(1)):
            exact=1/(1-s/2)
            polynomial=sum((s/2)**j for j in range(n+1))
            eps=F(1,2**n)
            assert abs(exact-polynomial)<=eps
            assert abs(exact**2-polynomial**2)<=2*abs(polynomial)*eps+eps*eps
            cover_tests+=1
    # The actual log kernel, including larger distances, obeys its envelope.
    kernel_cases=0
    for tt in (mp.mpf('1e-30'),mp.mpf('1e-12'),mp.mpf('.01'),mp.mpf('.5'),mp.mpf(1)):
        for mul in (1,2,10,100):
            d=mul*tt
            assert abs(mp.log(-mp.expm1(-d)))<=1-mp.log(tt)
            kernel_cases+=1
    ell=F(2252813807,40960000000000000)
    ground_upper=F(560909,10**13)
    mu_lo,mu_hi=F(594911359,10**16),F(594911360,10**16)
    r2_lo,r2_hi=F(8402690,10**15),F(8402692,10**15)
    Emin,Emax=mu_lo-ground_upper,mu_hi-ell
    assert Emin>0 and Emax>0
    weighted_lower=r2_lo/Emax
    weighted_upper=r2_hi/Emin+Emax
    assert weighted_lower>F(187,100) and weighted_upper<F(248,100)
    return {
      'exact_antiderivative_checks':2,'exact_dyadic_partitions':4,
      'full_residual_atom_vs_combined_point_checks':len(point_errors),
      'full_residual_reflection_checks':len(symmetry_errors),
      'point_precision_decimal_digits':90,
      'maximum_relative_point_discrepancy':mp.nstr(max(point_errors),20),
      'maximum_relative_reflection_discrepancy':mp.nstr(max(symmetry_errors),20),
      'nonzero_exterior_Gamma_image_witness':mp.nstr(exterior_witness,20),
      'exact_analytic_toy_Cauchy_checks':cover_tests,
      'log_kernel_envelope_diagnostics':kernel_cases,
      'inherited_ground_enclosure_energy_weighted_excitation_bracket':['187/100','62/25'],
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'status':'All exact identities, full atom-action comparisons and diagnostic bounds passed.',
      'scope':'Second implementation by the same assistant. Nondirected point evaluations are diagnostics. The excitation bracket inherits the earlier paper/full-Weil ground certificate; that old LDL certificate was not rerun. No Lean/Scribe execution is asserted.'}

if __name__=='__main__':
    result=run()
    ROOT.joinpath('prolate_operator_residual_regression.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
