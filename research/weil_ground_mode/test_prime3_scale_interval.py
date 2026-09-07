"""Exact and separate-expression diagnostics for the uniform threshold proof.

Original digamma and physical sine integrals are evaluated independently of
its interval matrix assembly. These nondirected diagnostics are not proof
certificates. The separate verifier supplies the full parameter-interval
certificate, including all omitted modes. No Lean execution is performed.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import hashlib
import importlib.util
import json
import random
import mpmath as mp
from mpmath import iv
import sympy as sp

ROOT=Path(__file__).resolve().parent

def run():
    path=ROOT/'certify_prime3_scale_interval.py'
    spec=importlib.util.spec_from_file_location('threshold_certificate_diagnostic',path)
    if spec is None or spec.loader is None:raise ImportError(path)
    mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
    iv.dps=90;mp.mp.dps=80
    report=json.loads((ROOT/'prime3_scale_interval_certificate.json').read_bytes())
    assert report['source_sha256']==hashlib.sha256(path.read_bytes()).hexdigest()
    assert report['inherited_numerical_gap'] is False
    assert F(report['candidate_orthogonal_threshold'])-F(report['candidate_upper'])==F(3,625000)
    n,m,sn,sm=sp.symbols('n m sn sm')
    even=(sn-sm)/(m-n)+(-sn-sm)/(m+n)
    odd=(sn-sm)/(m-n)-(-sn-sm)/(m+n)
    assert sp.factor(even-2*(n*sn-m*sm)/(m*m-n*n))==0
    assert sp.factor(odd-2*(m*sn-n*sm)/(m*m-n*n))==0
    x,h,C=sp.symbols('x h C',real=True)
    assert sp.integrate(2*C*C*x*(h-x),(x,0,h))==C*C*h**3/3
    rng=random.Random(20260907)
    paired=0
    for _ in range(400):
        n=rng.randint(1,64);m=rng.choice((-1,1))*rng.randint(65,400)
        sn,sm=F(rng.randint(-30,30),7),F(rng.randint(-30,30),11)
        pp=(sn-sm)/(m-n);pn=(-sn-sm)/(m+n)
        assert pp+pn==2*(n*sn-m*sm)/(m*m-n*n)
        assert pp-pn==2*(m*sn-n*sm)/(m*m-n*n)
        paired+=2
    gram_cases=0
    for _ in range(120):
        X=[[F(rng.randint(-10,10),8) for _ in range(2)] for _ in range(5)]
        E=[[F(rng.randint(-2,2),512) for _ in range(2)] for _ in range(5)]
        theta=F(1,200)
        error=sum((z*z for row in E for z in row),F(0));eta=(1+1/theta)*error
        D=[[sum(((1+theta)*X[k][i]*X[k][j]-(X[k][i]+E[k][i])*(X[k][j]+E[k][j])
                 for k in range(5)),F(0))+(eta if i==j else 0) for j in range(2)] for i in range(2)]
        assert D[0][0]>0 and D[1][1]>0 and D[0][0]*D[1][1]-D[0][1]**2>0
        gram_cases+=1
    def direct_symbol(n,L):
        w=2*mp.pi*n/L
        correction=sum(w*mp.exp(-(2*j+mp.mpf('.5'))*L)/((2*j+mp.mpf('.5'))**2+w*w) for j in range(256))
        gamma=mp.im(mp.digamma(mp.mpf('.25')+1j*w/2))/2-correction
        pole=-2*w*(mp.cosh(L/2)-1)/(w*w+mp.mpf('.25'))
        prime=-sum(mp.log(p)/mp.sqrt(p)*mp.sin(w*mp.log(p)) for p in (2,3) if mp.log(p)<L)
        return pole-gamma+prime
    def direct_diagonal(n,L):
        w=2*mp.pi*n/L;z=mp.mpf('.25')+1j*w/2
        correction=sum(mp.exp(-(2*j+mp.mpf('.5'))*L)*mp.re(1/(2*j+mp.mpf('.5')-1j*w)**2) for j in range(256))
        gamma=mp.re(mp.digamma(z))-mp.log(mp.pi)+mp.re(mp.polygamma(1,z))/(2*L)-2*correction/L
        pole=4*(mp.cosh(L/2)-1)/L*mp.re(1/(mp.mpf('.5')+1j*w)**2)
        prime=-sum(2*mp.log(p)/mp.sqrt(p)*(1-mp.log(p)/L)*mp.cos(w*mp.log(p))
                   for p in (2,3) if mp.log(p)<L)
        return gamma+pole+prime
    def contains(enclosure,value):
        interval=iv.mpf(enclosure)
        return bool(interval.a<iv.mpf(mp.nstr(value,78))) and bool(iv.mpf(mp.nstr(value,78))<interval.b)
    L0=mp.log(3);step=mp.mpf(1)/(5*10**7);symbols=diagonals=phases=0
    max_reference_tail=mp.mpf(0)
    for q in (-1,-.75,-.5,-.125,0,.125,.5,.75,1):
        L=L0+2*mp.mpf(q)*step
        tail=mp.exp(-mp.mpf('512.5')*L)/(1025*(1-mp.exp(-2*L)))
        max_reference_tail=max(max_reference_tail,tail)
        for text,enclosure in report['symbol_reference_intervals'].items():
            n=int(text);assert contains(enclosure,direct_symbol(n,L));symbols+=1
            omega=2*mp.pi*n/L
            for p in (2,3):
                overlap=max(mp.mpf(0),2-2*mp.log(p)/L)
                original=-mp.log(p)/mp.sqrt(p)*mp.sin(omega*mp.log(p)) if mp.log(p)<L else mp.mpf(0)
                rewritten=mp.log(p)/mp.sqrt(p)*mp.sin(mp.pi*n*overlap)
                assert abs(original-rewritten)<mp.mpf('1e-72');phases+=1
        for text,enclosure in report['diagonal_reference_intervals'].items():
            assert contains(enclosure,direct_diagonal(int(text),L));diagonals+=1
    assert max_reference_tail<mp.mpf('1e-245')
    odd_cases=0;max_discrepancy=mp.mpf(0)
    for _ in range(5):
        coeff=[mp.mpc(mp.mpf(rng.randint(-8,8))/7,mp.mpf(rng.randint(-8,8))/11) for _ in range(4)]
        profile=lambda t:sum(coeff[j]*mp.sin(mp.pi*(j+1)*t) for j in range(4))
        physical=lambda y:sum(coeff[j]*(-1)**(j+1)*mp.sin(mp.pi*(j+1)*y) for j in range(4))
        for hh in (mp.mpf(1)/1024,mp.mpf(1)/32,mp.mpf('.5'),mp.mpf(1)):
            w=mp.log(3)/mp.sqrt(3);shift=2-hh
            edge=w*mp.quad(lambda t:mp.conj(profile(t))*profile(hh-t)+mp.conj(profile(hh-t))*profile(t),[0,hh])
            original=-w*mp.quad(lambda y:mp.conj(physical(y))*physical(y+shift)+mp.conj(physical(y+shift))*physical(y),[-1,-1+hh])
            error=abs(edge-original)/(1+abs(original));max_discrepancy=max(max_discrepancy,error)
            assert error<mp.mpf('1e-65')
            bound=w*mp.pi**2*hh**3/3*sum((j+1)**2 for j in range(4))*sum(abs(c)**2 for c in coeff)
            assert abs(edge)<=bound;odd_cases+=1
    overlap3=iv.mpf(report['active_overlap_3'])
    odd_budget=iv.ln(3)/iv.sqrt(3)*iv.pi**2*overlap3**3/3*sum(n*n for n in range(1,65))
    assert bool(odd_budget<iv.mpf(1)/10**16)
    assert max(mp.mpf(0),2-2*mp.log(3)/(L0-2*step))==0
    assert max(mp.mpf(0),2-2*mp.log(3)/(L0+2*step))>0
    assert sp.factor(even-odd)!=0
    rejected=0
    for bad in ([[1,2],[2,1]],[[1,0],[0,0]]):
        try:mod.ldl([[iv.mpf(x) for x in row] for row in bad])
        except ArithmeticError:rejected+=1
        else:raise AssertionError('Indefinite/singular LDL negative control passed.')
    try:mod.ldl([[iv.mpf([.9,1.1]),iv.mpf([1.9,2.1])],[iv.mpf([1.9,2.1]),iv.mpf([.9,1.1])]])
    except ArithmeticError:rejected+=1
    else:raise AssertionError('Interval indefinite control passed.')
    return {'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'verifier_sha256':report['source_sha256'],
      'exact_symbolic_identities':3,'exact_signed_parity_column_equalities':paired,
      'exact_quantized_Gram_radius_fixtures':gram_cases,
      'actual_symbol_interval_sample_checks':symbols,'actual_diagonal_interval_sample_checks':diagonals,
      'actual_prime_phase_checks':phases,'reference_Gamma_correction_tail_upper':mp.nstr(max_reference_tail,20),
      'physical_odd_prime_edge_checks':odd_cases,'maximum_relative_edge_discrepancy':mp.nstr(max_discrepancy,20),
      'uniform_low_odd_prime3_energy_budget_interval':str(odd_budget),
      'uniform_low_odd_prime3_energy_budget_upper':'1/10000000000000000',
      'indefinite_or_singular_LDL_rejections':rejected,
      'negative_controls':['prime3 is exactly inactive below and active above threshold',
        'interchanging parity columns changes the exact arithmetic expression',
        'indefinite and singular congruence targets cannot pass strict directed LDL'],
      'status':'All exact checks and separately assembled analytic diagnostics passed.',
      'scope':'Single-author development diagnostics. Sampling and nondirected quadrature are not the uniform proof; the separate interval verifier is. No Lean/Scribe compilation or independent review.'}

if __name__=='__main__':
    result=run()
    (ROOT/'prime3_scale_interval_regression.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
