"""Full Weil energy of the genuine c=3 prolate model, with Gamma form control.

All Gamma, pole and prime integrals of the finite polynomial model are evaluated
by finite endpoint formulas. No quadrature or finite frequency cutoff enters the
certificate. Rational-argument dilogarithms have explicit positive-series tails.
The actual infinite prolate spectrum is first re-certified by the pinned earlier
verifier. A geometric Legendre-tail comparison upgrades that L2 approximation to
piecewise C1 and jump bounds before it is used in the unbounded Gamma form.

The classical Green/Fourier realization, endpoint integration, positive-form
Cauchy-Schwarz, and infinite Jacobi comparison have paper proofs in the existing
RH theory volume. This executable certificate is not a Lean kernel replay.
"""
from __future__ import annotations
from pathlib import Path
from fractions import Fraction as F
from functools import lru_cache
import hashlib
import importlib.util
import json
import platform
import sys
from mpmath import iv

if not __debug__:
    raise RuntimeError('Assertions are part of this verifier; do not use -O.')
ROOT=Path(__file__).resolve().parent
PINS={
 'certify_prime3_prolate_model.py':'42dceb5c81f9aabdc12b51a99d29f0929d81e712f815b49b13bbf9bb5ec56039',
 'prime3_prolate_proposal.json':'242c9897bbd247ef0485039e6dcde819a351c5900ceac52fecc420934c1896db',
 'certify_prime3_refined.py':'8bb067fc5499b0f2e1e48836e7a82237a15504109f82a856c72478d1096d69d0',
}

def load_reviewed():
    for filename, expected in PINS.items():
        if hashlib.sha256((ROOT/filename).read_bytes()).hexdigest()!=expected:
            raise ValueError('Unreviewed dependency: '+filename)
    spec=importlib.util.spec_from_file_location('reviewed_prolate_energy',ROOT/'certify_prime3_prolate_model.py')
    if spec is None or spec.loader is None:
        raise ImportError('Cannot load pinned prolate source.')
    module=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

def run(digits: int=110) -> dict:
    if digits<100:
        raise ValueError('At least 100 interval digits are required.')
    base=load_reviewed()
    previous=base.run(digits)  # Rerun the complete spectral checks, not its stored JSON.
    iv.dps=digits
    data=json.loads((ROOT/'prime3_prolate_proposal.json').read_bytes())
    K,bits=data['dimension'],data['dyadic_bits']
    assert (data['scale_c'],K,bits)==(3,32,250)
    v=[]
    centers=[]
    for proposal in data['proposals']:
        integers=list(map(int,proposal['vector_numerators']))
        norm_sq=sum((F(n*n,2**(2*bits)) for n in integers),F(0))
        assert norm_sq>0
        norm=iv.sqrt(iv.mpf(norm_sq.numerator)/norm_sq.denominator)
        v.append([iv.mpf(n)/2**bits/norm for n in integers])
        centers.append(iv.mpf(int(proposal['center_numerator']))/2**bits)
    ratio=v[1][0]/v[0][0]
    H=[v[1][j]-ratio*v[0][j] for j in range(K)]
    H[0]=iv.mpf(0)  # Exact by the definition of ratio.
    A=[iv.mpf(0)]*K
    for j in range(1,K):
        poly=base.legendre_coefficients(2*j)
        factor=H[j]*iv.sqrt(iv.mpf(4*j+1)/2)
        for r in range(j+1):
            A[r]+=factor*iv.mpf(poly[2*r].numerator)/poly[2*r].denominator/3**r
    lam=iv.sqrt(3)
    a=iv.ln(3)/2
    L=2*a
    c0=-iv.euler-iv.ln(2*iv.pi)
    segs=[(F(1,3),F(1,2),(1,2),(1,)),
          (F(1,2),F(2,3),(1,),(1,)),
          (F(2,3),F(1),(1,),(1,2))]
    def rat(x):x=F(x);return iv.mpf(x.numerator)/x.denominator
    def add(dic,key,value):dic[key]=dic.get(key,iv.mpf(0))+value
    @lru_cache(maxsize=None)
    def pos(q,k):return (lam*rat(q))**rat(k)
    @lru_cache(maxsize=None)
    def xval(q):return a+iv.ln(rat(q))
    @lru_cache(maxsize=None)
    def integral_power(k,l,r,linear=False):
        k=F(k)
        if not k:return (xval(r)**2-xval(l)**2)/2 if linear else xval(r)-xval(l)
        kr=rat(k)
        if linear:return (pos(r,k)*(kr*xval(r)-1)-pos(l,k)*(kr*xval(l)-1))/kr**2
        return (pos(r,k)-pos(l,k))/kr
    @lru_cache(maxsize=None)
    def li2_positive(y):
        if y==0:return rat(0)
        if y==1:return iv.pi**2/6
        if y>F(1,2):return iv.pi**2/6-iv.ln(rat(y))*iv.ln(rat(1-y))-li2_positive(1-y)
        out=rat(0);power=rat(1);q=rat(y);T=420
        for j in range(1,T+1):
            power*=q;out+=power/(j*j)
        tail=y**(T+1)/(F((T+1)**2)*(1-y))
        return out+rat(tail)*iv.mpf([0,1])
    @lru_cache(maxsize=None)
    def li2_signed(s,y):
        return li2_positive(y) if s==1 else li2_positive(y*y)/2-li2_positive(y)
    @lru_cache(maxsize=None)
    def I(n,s,y):
        assert y>0 and y<=1
        yy=rat(y)
        if n==0:return -li2_signed(s,y)
        term=iv.mpf(0) if y==1 and s==1 else (yy**n-(1 if s == 1 or n % 2 == 0 else -1))/n*iv.ln(1-s*yy)
        if n>0:return term - rat(F((1 if s == 1 or n % 2 == 0 else -1),n))*sum((s*yy)**j/j for j in range(1,n+1))
        m=-n
        return term-rat(F(s**m,m))*iv.ln(yy)+sum(s**(m-j)*yy**(-j)/j for j in range(1,m))/m
    @lru_cache(maxsize=None)
    def integral_log(k,anchor,sgn,s,l,r):
        assert F(k).denominator==1
        n=int(k)*sgn
        yl=(l/anchor)**sgn;yr=(r/anchor)**sgn
        return pos(anchor,k)*(I(n,s,yr)-I(n,s,yl))*sgn

    def conv(A,B):
        out={}
        for k,v in A.items():
            for n,w in B.items():add(out,k+n,v*w)
        return out

    def even_terms(plus,minus):
        out={}
        for r,ar in enumerate(A):
            alpha=F(4*r+1,2)
            out[alpha]=2*ar*sum(m**(2*r) for m in plus)
            out[-alpha]=2*ar*sum(m**(2*r) for m in minus)
        return out

    def gamma_terms(active):
        sm={};lin={};logs={}
        def addlog(anchor,sgn,s,alpha,vv):
            key=(anchor,sgn,s)
            if key not in logs:logs[key]={}
            add(logs[key],alpha,vv)
        low=F(1,3)
        for m in (1,2):
            upper=F(1,m)
            for r,ar in enumerate(A):
                alpha=F(4*r+1,2);C=4*ar*m**(2*r)
                for s,fac in ((-1,F(1,2)),(1,F(-1,2))):addlog(low,-1,s,alpha,C*rat(fac))
                for j in range(1,r+1):
                    add(sm,alpha-(2*j-1),-C*pos(low,2*j-1)/(2*j-1))
                if m in active:
                    HH=sum(rat(F(1,2*j)) for j in range(1,r+1));OO=sum(rat(F(1,2*j-1)) for j in range(1,r+1))
                    add(sm,alpha,C*(c0-xval(upper)+HH+OO));add(lin,alpha,C)
                    for j in range(1,r+1):add(sm,alpha-2*j,-C*pos(upper,2*j)/(2*j))
                    for s in (-1,1):addlog(upper,1,s,alpha,-C/2)
                else:
                    for j in range(1,r+1):add(sm,alpha-(2*j-1),C*pos(upper,2*j-1)/(2*j-1))
                    for s,fac in ((-1,F(-1,2)),(1,F(1,2))):addlog(upper,-1,s,alpha,C*rat(fac))
        return sm,lin,logs


    def calc():
        qg=iv.mpf(0);nn=iv.mpf(0);poleint=iv.mpf(0)
        for l,r,ps,ms in segs:
            ee=even_terms(ps,ms);sm,lin,logs=gamma_terms(ps)
            nn+=sum(vv*integral_power(k,l,r) for k,vv in conv(ee,ee).items())
            poleint+=sum(vv*(integral_power(k+F(1,2),l,r)+integral_power(k-F(1,2),l,r))/2 for k,vv in ee.items())
            qq=sum(vv*integral_power(k,l,r) for k,vv in conv(ee,sm).items())
            qq+=sum(vv*integral_power(k,l,r,True) for k,vv in conv(ee,lin).items())
            for (anchor,sgn,s),cc in logs.items():
                qq+=sum(vv*integral_log(k,anchor,sgn,s,l,r) for k,vv in conv(ee,cc).items())
            qg+=qq

        aa=even_terms((1,2),(1,));bb={k:v*2**rat(k) for k,v in even_terms((1,),(1,2)).items()}
        qp=-2*iv.ln(2)/iv.sqrt(2)*sum(v*integral_power(k,F(1,3),F(1,2)) for k,v in conv(aa,bb).items())
        pole=2*poleint**2


        return nn, qg, pole, qp

    norm_sq,qgamma,qpole,qprime=calc()
    assert bool(norm_sq>0)
    norm=iv.sqrt(norm_sq)
    total=qgamma+qpole+qprime
    rayleigh=total/norm_sq

    # Infinite Jacobi-tail comparison. The previous Sturm-Schur checks isolate
    # the real target eigenvalues within one of these dyadic centers.
    eps=rat(F(1,10**25))
    assert all(bool(center+1<160) for center in centers)
    assert bool((6*iv.pi)**2<356)
    assert all(bool(abs(vector[-1])<eps) for vector in v)
    high_floor=2*K*(2*K+1)
    rho=F(1,4)
    assert high_floor==4160
    assert F(high_floor-160)-356*(1/rho+rho)>0
    # Thus |psi_(K+j)| <= 2*eps*rho^(j+1), for every j>=0.
    sum_linear=rho*(K+1)/(1-rho)+rho**2/(1-rho)**2
    sum_cube=rho*(1+4*rho+rho**2)/(1-rho)**4
    value_bound=K*(K+1)+4*sum_linear
    derivative_bound=K**2*(K+1)**2+8*(K+1)**3*sum_cube
    assert value_bound<1200 and derivative_bound<2000000
    assert bool(v[0][0]>eps)
    ratio_error=eps*(1+abs(ratio))/(v[0][0]-eps)
    # Same bounds also dominate the finite unit v0 and its derivative.
    H0=1200*eps*(1+abs(ratio)+ratio_error)+1200*ratio_error
    H1=2000000*eps*(1+abs(ratio)+ratio_error)+2000000*ratio_error
    D0=4*iv.sqrt(lam)*3*H0
    D1=4*iv.sqrt(lam)*3*(H0/2+H1)
    delta=iv.sqrt(L)*D0
    assert bool(norm>delta)

    # A piecewise C1 error has four possible jumps, including both outer endpoints.
    # Translation-modulus proof: G(f)<=3 L D1^2+(12 J+16 L)D0^2.
    # gamma(0)=-Euler-pi/2-3log2-logpi lies in (-7,0).
    gamma0=-iv.euler-iv.pi/2-3*iv.ln(2)-iv.ln(iv.pi)
    assert bool(gamma0>-7) and bool(gamma0<0)
    assert bool(iv.exp(rat(F(3,2)))/2<3)
    assert bool(1/(1-iv.exp(-2))<2)
    J=4
    gamma_error_energy=3*L*D1**2+(12*J+23*L)*D0**2
    positive_model_energy=qgamma+7*norm_sq
    assert bool(positive_model_energy>0)
    bounded_norm=2*iv.ln(2)/iv.sqrt(2)+2*((iv.exp(a)-iv.exp(-a))/2+a)
    norm_sq_error=(2*norm+delta)*delta
    total_error=(2*iv.sqrt(positive_model_energy*gamma_error_energy)+gamma_error_energy
                 +(7+bounded_norm)*norm_sq_error)
    quotient_error=total_error/(norm-delta)**2+abs(total)*norm_sq_error/(norm_sq*(norm-delta)**2)
    lower,upper=F(594911359,10**16),F(594911360,10**16)
    assert bool(rayleigh-quotient_error>rat(lower))
    assert bool(rayleigh+quotient_error<rat(upper))
    # Previously k was only close in L2; its energy is not used to certify this one.
    old_candidate_U=F(560909,10**13)
    assert lower>old_candidate_U
    return {
      'scale':'lambda=sqrt(3), a=log(3)/2; genuine zero-integral, evenized prolate model',
      'interval_decimal_digits':digits,
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'dependency_sha256':PINS,
      'prolate_replay':previous['new_checks'],
      'polynomial_norm_squared':str(norm_sq),
      'polynomial_gamma_energy':str(qgamma),
      'polynomial_pole_energy':str(qpole),
      'polynomial_prime_energy':str(qprime),
      'polynomial_normalized_components':[str(q/norm_sq) for q in (qgamma,qpole,qprime)],
      'polynomial_rayleigh':str(rayleigh),
      'legendre_tail_ratio':'1/4',
      'target_eigenvalue_upper':160,
      'tail_diagonal_floor':high_floor,
      'jacobi_off_diagonal_upper':356,
      'unit_mode_L2_error_upper':'1/10000000000000000000000000',
      'unit_mode_uniform_error_multiplier':1200,
      'unit_mode_derivative_error_multiplier':2000000,
      'true_model_piecewise_value_error':str(D0),
      'true_model_piecewise_derivative_error':str(D1),
      'true_model_gamma_shifted_error_energy':str(gamma_error_energy),
      'true_model_rayleigh_transport_error':str(quotient_error),
      'true_model_rayleigh_interval_rational':[str(lower),str(upper)],
      'dilogarithm_series_terms':420,
      'status':'Pinned infinite-prolate replay and all directed interval/positive-tail guards passed.',
      'scope':'Actual prolate full Weil Rayleigh value. Gamma form transport uses the proved-on-paper C1/jump bounds; no L2-only continuity is assumed. No new ground eigenvalue enclosure, new gap, all-scale rate, RH or Lean kernel acceptance is asserted.',
      'python':platform.python_version(),
    }

if __name__=='__main__':
    digits=int(sys.argv[1]) if len(sys.argv)>1 else 110
    result=run(digits)
    suffix='' if digits==110 else f'_{digits}'
    output=ROOT/f'prime3_prolate_weil_energy_certificate{suffix}.json'
    output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2),flush=True)
