"""An actual arithmetic energy-dual Fourier certificate, with the complete tail.

The finite Gaussian-rational trial is untrusted input. Two pivot coordinates
are reconstructed exactly, so its endpoint trace and candidate pairing vanish.
The actual prime/pole/Gamma matrix, full projected residual through M, and the
entire remaining tail are independently enclosed. The variational argument is
owned by PR #5882; no exact inverse or numerical optimizer verdict is trusted.

The historical full-space ground/coercivity certificate is an inherited paper
and interval premise, NOT replayed here. Fourier/domain identification and the
universal analytic estimates are documented in RH_RESEARCH_LANE_THEORY.md.
The prolate model verifier IS replayed for the final same-model comparison.
This is not a Lean kernel replay or independent-author review.
"""
from __future__ import annotations
import hashlib, importlib.util, json, math, platform
from pathlib import Path
from fractions import Fraction as F
import numpy as np
from mpmath import iv

if not __debug__:
    raise RuntimeError('Assertions are part of this verifier; do not use -O.')
ROOT=Path(__file__).resolve().parent
PINS={
 'certify_prime3_refined.py':'8bb067fc5499b0f2e1e48836e7a82237a15504109f82a856c72478d1096d69d0',
 'certify_prime3_prolate_model.py':'42dceb5c81f9aabdc12b51a99d29f0929d81e712f815b49b13bbf9bb5ec56039',
 'prime3_prolate_proposal.json':'242c9897bbd247ef0485039e6dcde819a351c5900ceac52fecc420934c1896db',
 'prime3_energy_dual_trial.json':'60dafe7f77bdf6dec4da8c3f525c090c5a42efe8b4a4459a047768df4b405d78',
}

def load(name, filename):
    spec=importlib.util.spec_from_file_location(name, ROOT/filename)
    if spec is None or spec.loader is None: raise ImportError(filename)
    module=importlib.util.module_from_spec(spec); spec.loader.exec_module(module)
    return module

def rat(x):
    x=F(x); return iv.mpf(x.numerator)/x.denominator

def conj(z):return iv.mpc(z.real,-z.imag)

def gaussian(pair):return iv.mpc(rat(pair[0]),rat(pair[1]))
def cadd(x,y):return (x[0]+y[0],x[1]+y[1])
def cscale(q,x):return (q*x[0],q*x[1])
def csub(x,y):return (x[0]-y[0],x[1]-y[1])
def cmul(x,y):return (x[0]*y[0]-x[1]*y[1],x[0]*y[1]+x[1]*y[0])
def gadd(x,y):return (x[0]+y[0],x[1]+y[1])
def gscale(a,x):return (a*x[0],a*x[1])

def decode_trial(base, data):
    assert (data['scale_c'],data['N'],data['dyadic_bits'])==(3,64,44)
    assert data['frequency']==['20','1/4'] and data['free_indices']==[2,64]
    rows=data['free_gaussian_numerators'];assert len(rows)==63
    assert all(len(row)==2 and all(type(x) is int for x in row) for row in rows)
    t=[(F(0),F(0)),(F(0),F(0))]+[(F(x,2**44),F(y,2**44)) for x,y in rows]
    s=list(base.CANDIDATE); assert len(s)==129 and s==s[::-1]
    # Full raw Fourier coefficients are t_0,t_1,...,t_64 mirrored evenly.
    # Endpoint trace: t_0+2 sum_(n>=1)t_n=0.
    # Candidate pairing: s_0*t_0+2 sum_(n>=1)s_n*t_n=0.
    free=(F(0),F(0)); weighted=(F(0),F(0))
    for n in range(2,65):
        free=gadd(free,t[n]);weighted=gadd(weighted,gscale(F(s[64+n]),t[n]))
    denominator=s[65]-s[64];assert denominator!=0
    t[1]=gscale(F(1,denominator),gadd(gscale(F(s[64]),free),gscale(F(-1),weighted)))
    t[0]=gscale(F(-2),gadd(free,t[1]))
    full=[t[abs(n)] for n in range(-64,65)]
    assert sum((p[0] for p in full),F(0))==sum((p[1] for p in full),F(0))==0
    pairing=tuple(sum((F(s[i])*full[i][j] for i in range(129)),F(0)) for j in (0,1))
    assert pairing==(0,0) and full==full[::-1]
    assert any(x or y for x,y in full)
    return full,t,s

def exact_float_sum(xs):
    assert np.all(np.isfinite(xs))
    return sum((F.from_float(float(x)) for x in np.asarray(xs).ravel()),F(0))

def run(digits=110, M=32768):
    if digits<100 or M<1024 or M>131072:raise ValueError('Unreviewed precision/cutoff.')
    for filename,pin in PINS.items():
        if hashlib.sha256((ROOT/filename).read_bytes()).hexdigest()!=pin:
            raise ValueError('Unreviewed input: '+filename)
    base=load('arithmetic_dual_base','certify_prime3_refined.py')
    prolate=load('arithmetic_dual_prolate','certify_prime3_prolate_model.py')
    model_record=prolate.run(digits)
    assert model_record['true_normalized_prolate_model_to_fixed_weil_candidate_bound']=='113/100000'
    iv.dps=digits
    data=json.loads((ROOT/'prime3_energy_dual_trial.json').read_bytes())
    full,t,s=decode_trial(base,data); v=[gaussian(p) for p in full]
    exact_norm2=sum((x*x+y*y for x,y in full),F(0));vn=iv.sqrt(rat(exact_norm2))
    snorm2=sum(x*x for x in s);kn=iv.sqrt(snorm2)
    k=[iv.mpf(x)/kn for x in s]
    N=64; ns=np.arange(-N,N+1,dtype=np.int64)
    L=iv.ln(3);a=L/2;z=iv.mpc(20,rat(F(1,4)))
    ell=F(2252813807,40960000000000000);U=F(560909,10**13);T=F(3,250000)
    kappa=T-ell;energy_width=U-ell;assert 0<ell<U<T
    # Bound the existing canonical arithmetic envelope at c=3, not a fitted symbol.
    assert bool((iv.sqrt(3)+1/iv.sqrt(3))+iv.ln(2)/iv.sqrt(2)<3)
    sig=base.symbol_array(np.arange(1,M+1,dtype=np.int64))
    slo=np.r_[-sig.hi[:N][::-1],0,sig.lo[:N]]
    shi=np.r_[-sig.lo[:N][::-1],0,sig.hi[:N]]
    ss=[iv.mpf([float(slo[i]),float(shi[i])]) for i in range(129)]
    A=[[iv.mpf(0) for _ in ns] for _ in ns]
    for i,n in enumerate(ns):
        A[i][i]=base.diagonal_iv(int(n))-rat(ell)
        for j in range(i):
            A[i][j]=(ss[i]-ss[j])/(iv.pi*int(ns[j]-n));A[j][i]=A[i][j]
    candidate_rayleigh=sum((k[i]*A[i][j]*k[j] for i in range(129) for j in range(129)),iv.mpf(0))+rat(ell)
    assert bool(candidate_rayleigh<rat(U))
    # The real-even representer is conjugate(cos(z*x)); it observes the same
    # paperFT on every even error. Matrix coefficients use the original phases.
    def gn(n):
        w=2*iv.pi*n/L
        return conj(2*z*iv.sin(a*z)/(iv.sqrt(L)*(z*z-w*w)))
    g=[gn(int(n)) for n in ns]
    Av=[sum((A[i][j]*v[j] for j in range(129)),iv.mpc(0)) for i in range(129)]
    gv=sum((conj(g[i])*v[i] for i in range(129)),iv.mpc(0))
    qv=sum((conj(v[i])*Av[i] for i in range(129)),iv.mpc(0)).real
    obj=2*gv.real-qv
    d=[g[i]-Av[i] for i in range(129)]
    alpha=sum((iv.mpf(s[i])*d[i] for i in range(129)),iv.mpc(0))/snorm2
    rlow=[d[i]-s[i]*alpha for i in range(129)]
    low2=sum((abs(x)**2 for x in rlow),iv.mpf(0))
    assert bool(low2>=0)
    # All modes 65..M. Every operation in base.I is outward-rounded; final
    # summation is performed on exact binary-rational endpoints, not np.sum.
    I=base.I; ms=np.arange(N+1,M+1,dtype=np.int64)
    C=(I(slo[None,:],shi[None,:])-I(sig.lo[N:,None],sig.hi[N:,None]))/(base.PI*I(ms[:,None]-ns[None,:]))
    rp=(I(np.zeros(len(ms))),I(np.zeros(len(ms))))
    for j in range(129):
        coeff=(base.outer_iv(v[j].real),base.outer_iv(v[j].imag))
        rp=cadd(rp,cscale(I(C.lo[:,j],C.hi[:,j]),coeff))
    om=2*base.PI*I(ms)/base.LOG3
    numer=2*z*iv.sin(a*z)/iv.sqrt(L)
    cn=(base.outer_iv(numer.real),base.outer_iv(numer.imag))
    zsq=z*z; dr=base.outer_iv(zsq.real)-om*om;di=base.outer_iv(zsq.imag)
    den=dr*dr+di*di
    gh=cmul(cn,(dr/den,-di/den));gh=(gh[0],-gh[1])
    rh=csub(gh,rp)
    high2=rat(2*exact_float_sum((rh[0]*rh[0]+rh[1]*rh[1]).hi))
    # Exact trace and evenness annihilate the first jet. The direct paired
    # stencil bound is 4B*sum n|t_n|/(pi*m^2), sharper than a generic N||v||_1.
    moment=sum((n*abs(gaussian(t[n])) for n in range(1,N+1)),iv.mpf(0))
    eta=-(L**2/(4*iv.pi**2))*conj(numer)
    freq=L*abs(z)/(2*iv.pi)
    assert M>=2*N and bool(M>=2*freq)
    Q=4*abs(eta)/3+12*moment/iv.pi
    tail2=2*Q**2/(3*M**3)
    residual2=low2+high2+tail2
    Ccenter=obj+residual2/rat(kappa)
    K0=sum((conj(g[i])*k[i] for i in range(129)),iv.mpc(0))
    knorm_g=(iv.exp(a/2)-iv.exp(-a/2))/2/(2*rat(F(1,4)))+iv.sin(40*a)/40
    centered_g=knorm_g-abs(K0)**2
    Czero=centered_g/rat(kappa)
    assert bool(Ccenter>0) and bool(Ccenter<103)
    assert bool(Czero>46600) and bool(Czero>450*Ccenter)
    assert bool(rat(energy_width)*Ccenter<abs(K0)**2)
    # One fixed exact trial controls a genuine compact complex disk.
    radius=F(1,1000)
    H=a*iv.sqrt(L)*iv.exp(a*(rat(F(1,4))+rat(radius)))
    dg=H*rat(radius)
    Cdisk=Ccenter+2*dg*vn+(2*iv.sqrt(residual2)*dg+dg**2)/rat(kappa)
    ferr=iv.sqrt(rat(energy_width)*Cdisk)
    margin=abs(K0)-dg-ferr
    assert bool(Cdisk<107)
    assert bool(ferr<rat(F(342,10**6)))
    assert bool(margin>rat(F(3,10000)))
    # Evaluate the SAME genuine prolate model at the central complex frequency.
    # Its finite polynomial Fourier integral is the existing endpoint formula.
    pdata=json.loads((ROOT/'prime3_prolate_proposal.json').read_bytes())
    vectors=[]
    for prop in pdata['proposals']:
        nums=list(map(int,prop['vector_numerators']))
        norm=iv.sqrt(rat(sum((F(n*n,2**500) for n in nums),F(0))))
        vectors.append([rat(F(n,2**250))/norm for n in nums])
    ratio=vectors[1][0]/vectors[0][0]
    hh=[vectors[1][j]-ratio*vectors[0][j] for j in range(32)];hh[0]=iv.mpf(0)
    polynomial=[iv.mpf(0) for _ in range(32)]
    for j in range(1,32):
        poly=prolate.legendre_coefficients(2*j);fac=hh[j]*iv.sqrt(rat(F(4*j+1,2)))
        for r in range(j+1):polynomial[r]+=fac*rat(poly[2*r])/3**r
    def pft(zz):
        result=iv.mpc(0)
        for r,ar in enumerate(polynomial):
            rate=2*r+rat(F(1,2))+iv.j*zz
            for m in (1,2):
                result+=4*ar*m**(2*r)*(iv.exp(rate*(a-iv.ln(m)))-iv.exp(-rate*a))/rate
        return result
    modelnorm=iv.mpf(model_record['unnormalized_mellin_model_norm_interval'])
    modelvalue=-(pft(z)+pft(-z))/(2*modelnorm)
    model_l2_error=iv.mpf(model_record['normalized_true_vs_polynomial_model_error'])
    model_point_error=iv.sqrt(L)*iv.exp(a/4)*model_l2_error
    center_difference=abs(K0-modelvalue)+model_point_error
    assert bool(center_difference<rat(F(43,10**6)))
    # The replay gives an aligned *real sign*, fixed by the strictly negative
    # overlap. No unrelated phase is chosen separately at each frequency.
    assert bool(iv.mpf(model_record['polynomial_model_candidate_overlap'])<0)
    model_disk_error=ferr+center_difference+dg*rat(F(113,100000))
    assert bool(model_disk_error<rat(F(387,10**6)))
    report={
      'scale':'lambda=sqrt(3), a=log(3)/2',
      'point':['20','1/4'],'closed_disk_radius':str(radius),
      'N':64,'M':M,'interval_decimal_digits':digits,
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'dependency_sha256':PINS,
      'exact_trial_endpoint_and_candidate_constraints':True,
      'trial_norm_squared_exact':str(exact_norm2),
      'candidate_rayleigh_rechecked':str(candidate_rayleigh),'trial_pairing':str(gv),'trial_shifted_energy':str(qv),
      'dual_objective':str(obj),
      'retained_projected_residual_squared':str(low2),
      'exterior_through_M_squared_upper':str(high2),
      'entire_beyond_M_squared_upper':str(tail2),
      'center_dual_budget_upper_enclosure':str(Ccenter),
      'center_zero_trial_budget_interval':str(Czero),
      'candidate_Fourier_point':str(K0),
      'uniform_disk_dual_budget_upper':str(Cdisk),
      'uniform_disk_ground_candidate_Fourier_error':str(ferr),
      'uniform_disk_ground_Fourier_floor':str(margin),
      'aligned_prolate_polynomial_Fourier_point':str(modelvalue),
      'true_prolate_candidate_point_difference_upper':str(center_difference),
      'uniform_disk_ground_true_prolate_Fourier_error':str(model_disk_error),
      'rational_claims':{'center_C_upper':'103','disk_C_upper':'107',
        'squared_budget_improvement_factor_lower':'450',
        'disk_ground_candidate_error_upper':'342/1000000',
        'disk_ground_nonzero_floor_lower':'3/10000',
        'disk_ground_true_prolate_error_upper':'387/1000000'},
      'ground_normalization':'FT(u)/<k,u>; k is the fixed real unit 129-coordinate candidate. The prolate comparator is -FT(p_h^+)/||p_h^+||, same globally aligned sign.',
      'inherited_hypotheses':{'ground_lower':str(ell),'candidate_upper':str(U),
        'full_candidate_complement_threshold':str(T),
        'ground_certificate_source':'prime3_neumann_weighted_certificate.json at c94c6abb6fcd9ad2d85c50666fa6abcfdbd8c2f5'},
      'replayed':'The independent true-prolate model verifier, plus all new trial, matrix, full-residual and Fourier guards.',
      'not_replayed':'The historical full-space Weil Schur/LDL verifier; Lean, Scribe and transitive axiom checks.',
      'scope':'An actual finite-scale energy-dual improvement and compact-disk genuine-ground/prolate Fourier comparison. Analytic operator/domain, historical coercivity and variational premises retain their paper/computer-assisted scope. No Xi zero, unbounded-scale rate or RH proof.',
      'status':'All exact rational constraints and directed full-tail/readout guards passed.',
      'python':platform.python_version(),
    }
    return report

if __name__=='__main__':
    import sys
    digits=int(sys.argv[1]) if len(sys.argv)>1 else 110
    r=run(digits)
    suffix='' if digits==110 else '_'+str(digits)
    target=ROOT/('prime3_energy_dual_certificate'+suffix+'.json')
    target.write_text(json.dumps(r,indent=2)+'\n')
    print(json.dumps(r,indent=2),flush=True)
