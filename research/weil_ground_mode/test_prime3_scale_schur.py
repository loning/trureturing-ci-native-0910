"""Exact edge identities and second-expression tests for scale revalidation.

The quadratures and special functions below are nondirected diagnostics, not
part of the uniform interval proof. The finite integer congruence checker is
also tested with positive midpoints containing an indefinite member and with
an intentionally singular proposed coordinate change. No compiler is invoked.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import contextlib, hashlib, importlib.util, io, json, random
import numpy as np
import mpmath as mp
from mpmath import iv
import sympy as sp
ROOT=Path(__file__).resolve().parent

def run():
    x,h,u,v=sp.symbols('x h u v',real=True)
    assert sp.expand(sp.integrate(x*x*(h-x)**2,(x,0,h))-h**5/30)==0
    assert sp.expand(sp.integrate(((u*x)**2+(v*(h-x))**2)/2,(x,0,h))-(u*u+v*v)*h**3/6)==0
    assert sp.expand(sp.integrate(x**4,(x,0,h))-h**5/5)==0
    mp.mp.dps=65
    edge_count=0;stencil_count=0
    for hu in ('0','.0001','.01','.2'):
        hh=mp.mpf(hu)
        for uu in (0,mp.pi,-3*mp.pi):
            for vv in (0,2*mp.pi,-4*mp.pi):
                integ=mp.quad(lambda t:mp.cos(uu*t)*mp.cos(vv*(hh-t)),[0,hh])
                assert abs(integ-hh)<=(uu*uu+vv*vv)*hh**3/6+mp.mpf('1e-60')
                edge_count+=1
    for coeff in ((1,mp.j/3,-mp.mpf(2)/5),(1,-1,0),(mp.j,1+mp.j,-1)):
        K=sum(abs(z)*(mp.pi*n)**2 for n,z in enumerate(coeff,1))
        def edge(t):return sum(z*(mp.cos(mp.pi*n*t)-1) for n,z in enumerate(coeff,1))
        for text in ('.0001','.01','.1','.3'):
            hh=mp.mpf(text)
            mass=mp.quad(lambda t:abs(edge(t))**2,[0,hh])
            cross=mp.quad(lambda t:mp.conj(edge(t))*edge(hh-t),[0,hh])
            assert mass<=K*K*hh**5/20+mp.mpf('1e-60')
            assert abs(cross)<=K*K*hh**5/120+mp.mpf('1e-60')
            stencil_count+=1
    # Compare the diagonal digamma expression against the original full Gamma
    # kernel, plus the original pole integral, at BOTH sides and the threshold.
    diagonal_errors=[];symbol_errors=[];prime_errors=[]
    gamma0=mp.digamma(mp.mpf(1)/4)-mp.log(mp.pi)
    kernel=lambda t:mp.exp(-t/2)/(-mp.expm1(-2*t))
    for displacement in (-mp.mpf('2e-8'),mp.mpf(0),mp.mpf('2e-8')):
        L=mp.log(3)+displacement
        for n in (0,1,-2,5):
            w=2*mp.pi*n/L;z=mp.mpf(1)/4+1j*w/2
            corr=sum(mp.exp(-(2*j+mp.mpf('.5'))*L)*mp.re(1/(2*j+mp.mpf('.5')-1j*w)**2) for j in range(128))
            formula=mp.re(mp.digamma(z))-mp.log(mp.pi)+mp.re(mp.polygamma(1,z))/(2*L)-2*corr/L
            original=gamma0+2*mp.quad(lambda t:kernel(t)*(2*mp.sin(w*t/2)**2+(t/L)*mp.cos(w*t)),[0,L])+2*mp.quad(kernel,[L,mp.inf])
            diagonal_errors.append(abs(formula-original)/(1+abs(original)))
            pole_formula=4*(mp.cosh(L/2)-1)/L*mp.re(1/(mp.mpf('.5')+1j*w)**2)
            pole_original=4/L*mp.quad(lambda t:(L-t)*mp.cosh(t/2)*mp.cos(w*t),[0,L])
            diagonal_errors.append(abs(pole_formula-pole_original)/(1+abs(pole_original)))
            prime=sum(mp.log(p)/mp.sqrt(p)*mp.sin(w*mp.log(p)) for p in (2,3) if mp.log(p)<L)
            correction=sum(w*mp.exp(-(2*j+mp.mpf('.5'))*L)/((2*j+mp.mpf('.5'))**2+w*w) for j in range(128))
            s_formula=-2*w*(mp.cosh(L/2)-1)/(w*w+mp.mpf('.25'))-mp.im(mp.digamma(z))/2+correction-prime
            s_integral=mp.quad(lambda t:(2*mp.cosh(t/2)-kernel(t))*mp.sin(w*t),[0,L])-prime
            symbol_errors.append(abs(s_formula-s_integral)/(1+abs(s_integral)))
        # The new prime's raw compressed-translation matrix, independently
        # integrated before comparing to the arithmetic divided difference.
        delta=mp.log(3);wgt=delta/mp.sqrt(3)
        for m,n in ((0,1),(-2,4),(1,1)):
            om,on=2*mp.pi*m/L,2*mp.pi*n/L
            if L<=delta:
                original=mp.mpc(0);formula=mp.mpf(0)
            else:
                original=-wgt*((-1)**(m+n))/L*(mp.exp(1j*on*delta)*mp.quad(lambda t:mp.exp(1j*(on-om)*t),[-L/2,L/2-delta])+mp.exp(-1j*on*delta)*mp.quad(lambda t:mp.exp(1j*(on-om)*t),[-L/2+delta,L/2]))
                if m==n:formula=-2*wgt*(1-delta/L)*mp.cos(on*delta)
                else:formula=(-wgt*mp.sin(on*delta)+wgt*mp.sin(om*delta))/(mp.pi*(m-n))
            prime_errors.append(abs(original-formula))
    assert max(diagonal_errors+symbol_errors+prime_errors)<mp.mpf('1e-55')
    # Exact real-matrix Young/Frobenius majorants on complex rational vectors.
    rng=random.Random(20260907);young_cases=0
    def pair_scale(a,z):return (a*z[0],a*z[1])
    def pair_sum(zs):
        values=list(zs)
        return (sum((z[0] for z in values),F(0)),sum((z[1] for z in values),F(0)))
    assert pair_sum(z for z in [(F(1),F(2)),(F(3),F(4))])==(F(4),F(6))
    def norm2(zs):return sum((x*x+y*y for x,y in zs),F(0))
    def apply(A,z):return [pair_sum(pair_scale(a,w) for a,w in zip(row,z)) for row in A]
    for _ in range(160):
        D=[[F(rng.randint(-9,9),7) for _ in range(3)] for _ in range(4)]
        E=[[F(rng.randint(-2,2),101) for _ in range(3)] for _ in range(4)]
        z=[(F(rng.randint(-6,6),5),F(rng.randint(-6,6),5)) for _ in range(3)]
        C=[[d+e for d,e in zip(dr,er)] for dr,er in zip(D,E)]
        theta=F(1,20);e2=sum((e*e for row in E for e in row),F(0))
        assert norm2(apply(C,z)) <= (1+theta)*norm2(apply(D,z))+(1+1/theta)*e2*norm2(z)
        young_cases+=1
    # Exercise the actual exact-integer decision routine, not a reimplementation.
    spec=importlib.util.spec_from_file_location('scale_schur_checked',ROOT/'certify_prime3_scale_schur.py')
    if spec is None or spec.loader is None:raise ImportError('scale verifier')
    mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
    iv.dps=90
    good=[[iv.mpf(2),iv.mpf('.1')],[iv.mpf('.1'),iv.mpf(1)]]
    with contextlib.redirect_stdout(io.StringIO()):positive=mod.verified_congruence(good,'positive fixture')
    assert F(positive['rational_Gershgorin_lower'])>0
    wide=[[iv.mpf(['-.01','2']),iv.mpf(0)],[iv.mpf(0),iv.mpf(1)]]
    try:
        with contextlib.redirect_stdout(io.StringIO()):mod.verified_congruence(wide,'indefinite interval')
    except ArithmeticError:pass
    else:raise AssertionError('Positive midpoint hid an indefinite interval member.')
    original_eigh=np.linalg.eigh
    np.linalg.eigh=lambda A:(np.ones(len(A)),np.zeros_like(A))
    try:
        try:
            with contextlib.redirect_stdout(io.StringIO()):mod.verified_congruence(good,'singular proposal')
        except ArithmeticError:pass
        else:raise AssertionError('Singular proposed congruence was accepted.')
    finally:np.linalg.eigh=original_eigh
    for kw in ({'digits':20},{'radius':F(1,10**6)},{'N':64},{'M':128}):
        try:mod.run(**kw)
        except ValueError:pass
        else:raise AssertionError('Unreviewed inputs accepted.')
    r90=json.loads((ROOT/'prime3_scale_schur_certificate.json').read_bytes())
    r120=json.loads((ROOT/'prime3_scale_schur_certificate_120.json').read_bytes())
    for report in (r90,r120):
        for key in ('even_congruence','odd_congruence'):assert F(report[key]['rational_Gershgorin_lower'])>0
        assert F(report['complement_threshold'])-F(report['candidate_upper'])==F(1,250000)
        assert report['radius_a']=='1/100000000'
        assert report['base_sha256']==mod.BASE_SHA
    return {'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'exact_polynomial_integrals':3,'cosine_edge_overlap_diagnostics':edge_count,
      'complex_stencil_mass_and_pairing_cases':stencil_count,
      'full_Gamma_and_pole_diagonal_comparisons':len(diagonal_errors),
      'full_boundary_symbol_integral_comparisons':len(symbol_errors),
      'prime3_original_translation_comparisons':len(prime_errors),
      'nondirected_working_precision':65,
      'maximum_relative_matrix_formula_discrepancy':mp.nstr(max(diagonal_errors+symbol_errors+prime_errors),20),
      'exact_complex_vector_Young_Gram_cases':young_cases,
      'actual_congruence_positive_control':True,
      'negative_controls':['positive midpoint with an indefinite interval member rejected',
        'singular eigensolver-proposed coordinates rejected by exact integer test',
        'insufficient precision and three unreviewed scale/dimension choices rejected'],
      'both_precision_uniform_gap_guards':True,
      'status':'Exact algebra, original-kernel diagnostics and actual decision negative controls passed.',
      'scope':'Single-author second-expression diagnostics. Nondirected quadratures and special functions are not certificate premises. This does not compile Lean or establish the infinite operator-domain bridge.'}

if __name__=='__main__':
    report=run()
    (ROOT/'prime3_scale_schur_regression.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
