"""Full-residual dual Fourier certificate on the unchanged prime-three candidate.

Reads and executes only AST-pinned arithmetic primitives and constants from
the existing owner; never runs its spectral verifier or other top-level code.
Any proposed finite trial is made exactly candidate-orthogonal by rational
elimination. The numerical proposal is not trusted as an inverse or a solution.
Every omitted positive AND negative mode is paid for by a proved coefficient
majorant. See WeilArithmeticFullResidualTail.lean and the existing theory appendix.

The canonical Weil/form-domain and Fourier-basis identities, plus the existing
full-space spectral inequalities, remain analytic premises. This program is
an interval consumer, not a Lean kernel proof or a zero-count certificate.
The default evaluates the ENTIRE closed frequency box of half-width 1/100000
around 20+i/4, using one fixed trial for all frequencies in that box.
"""
from __future__ import annotations
import argparse, ast, hashlib, json, math, types
from fractions import Fraction as F
from pathlib import Path
import numpy as np
from mpmath import iv
from sympy import bernoulli

PRIMITIVE_AST_HASH='e1e24029a943c47a946cab463e5af5462a00f7b0dbfbb30761dc985f84debfa5'
PRIMITIVE_CONSTANTS=['PI', 'LOG2', 'LOG3', 'SQRT2', 'SQRT3', 'B20']
PRIMITIVE_NAMES=['down', 'up', 'I', 'outer_iv', 'atan_positive', 'sin_interval', 'cmul', 'cinv', 'psi_im_array', 'symbol_array', 'psi_iv', 'diagonal_iv']

CANDIDATE_HASH='0a56b05b79c741e7a5548a23dd2eb980b619e260dc10db23bdcfa44c38a467b1'
ELL=F(2252813807,40960000000000000)
UPPER=F(560909,10**13)
THRESHOLD=F(3,250000)


def require(condition, message):
    if not bool(condition): raise ArithmeticError(message)


def rat(x):
    x=F(x);return iv.mpf(x.numerator)/x.denominator


def conj(x): return iv.mpc(x.real,-x.imag)
def abs2(x): return x.real**2+x.imag**2


def exact_binary_sum(values):
    """Exact dyadic sum, including subnormals, rounded only into iv at the end."""
    x=np.ascontiguousarray(values,dtype=np.float64).ravel()
    require(np.all(np.isfinite(x)),'Nonfinite interval endpoint')
    u=x.view(np.uint64);ef=((u>>np.uint64(52))&np.uint64(2047)).astype(np.int64)
    man=(u&np.uint64((1<<52)-1)).astype(np.int64)
    man+=np.where(ef!=0,1<<52,0).astype(np.int64)
    man=np.where((u>>np.uint64(63))!=0,-man,man)
    ex=np.where(ef!=0,ef-1075,-1074);keep=man!=0
    if not np.any(keep): return iv.mpf(0)
    man,ex=man[keep],ex[keep];em=int(np.min(ex))
    acc=sum(int(m)<<(int(e)-em) for m,e in zip(man,ex))
    return iv.mpf(acc)*iv.mpf(2)**em


def interval_sum(x):
    lo,hi=exact_binary_sum(x.lo),exact_binary_sum(x.hi)
    return iv.mpf([lo.a,hi.b])


def endpoint_fraction(x, upper):
    sign,man,ex,bits=x._mpi_[1 if upper else 0]
    require(bits>=0,'Nonfinite output')
    a=F(-man if sign else man)
    return a*2**ex if ex>=0 else a/F(2**(-ex))


def enclosure(x):
    scale=10**18
    lo=endpoint_fraction(x,False)*scale;hi=endpoint_fraction(x,True)*scale
    low=lo.numerator//lo.denominator;high=-((-hi.numerator)//hi.denominator)
    return {'lower':str(F(low,scale)),'upper':str(F(high,scale))}


def load_arithmetic(path):
    if not __debug__:
        raise ArithmeticError('Do not disable the arithmetic assertions with -O')
    tree=ast.parse(path.read_text(encoding='utf-8'))
    selected=[]; code=[]; candidates=[]
    for node in tree.body:
        tag=None
        if isinstance(node,(ast.FunctionDef,ast.ClassDef)) and node.name in PRIMITIVE_NAMES:
            tag=node.name
        elif isinstance(node,ast.Assign):
            targets=[x.id for x in node.targets if isinstance(x,ast.Name)]
            if 'CANDIDATE' in targets: candidates.append(ast.literal_eval(node.value))
            chosen=[x for x in targets if x in PRIMITIVE_CONSTANTS]
            if chosen: tag=','.join(chosen)
        if tag is not None:
            selected.append((tag,ast.dump(node,include_attributes=False)));code.append(node)
    require(len(selected)==len(PRIMITIVE_NAMES)+len(PRIMITIVE_CONSTANTS),'Incomplete arithmetic primitive projection')
    digest=hashlib.sha256(json.dumps(sorted(selected),separators=(',',':')).encode()).hexdigest()
    require(digest==PRIMITIVE_AST_HASH,'Inspected arithmetic primitive definitions or constants changed')
    require(len(candidates)==1,'Expected one literal candidate')
    p=tuple(candidates[0])
    require(len(p)==129 and all(type(x) is int for x in p) and p==p[::-1],'Wrong even candidate')
    canon=json.dumps(p,sort_keys=True,separators=(',',':')).encode()
    require(hashlib.sha256(canon).hexdigest()==CANDIDATE_HASH,'Candidate changed')
    # Execute ONLY the pinned definitions/constants, not arbitrary upstream
    # imports, top-level actions, solvers or the upstream run() entry point.
    iv.dps=45
    env={'np':np,'iv':iv,'math':math,'Fraction':F,'bernoulli':bernoulli,
         '__name__':'inspected_weil_arithmetic','CANDIDATE':p}
    exec(compile(ast.Module(body=code,type_ignores=[]),str(path),'exec'),env)
    return types.SimpleNamespace(**env)


def trial_coefficients(data,p):
    require(data['N']==64 and data['scale']=='c=3','Wrong trial scale or band')
    bits=data['bits'];require(type(bits) is int and 0<bits<=100,'Bad trial precision')
    pairs=data['positive_coefficients'];require(len(pairs)==64,'Missing trial coordinates')
    require(all(len(x)==2 and all(type(a) is int for a in x) for x in pairs),'Noninteger trial')
    pos=[(F(a,2**bits),F(b,2**bits)) for a,b in pairs]
    zero=tuple(-2*sum((F(p[65+j])*pos[j][k] for j in range(64)),F(0))/p[64] for k in (0,1))
    full=pos[::-1]+[zero]+pos
    for k in (0,1):require(sum((F(p[j])*full[j][k] for j in range(129)),F(0))==0,'Exact orthogonality')
    return full


def certify(arithmetic,trial_path,M=8192,digits=60,box_radius=F(1,100000)):
    box_radius=F(box_radius)
    require(0<=box_radius<=F(1,100),'Invalid requested frequency box')
    require(type(M) is int and 128<=M<=1000000,'Require 128<=M<=1000000 for this executable consumer')
    require(digits>=40,'Insufficient interval precision')
    b=load_arithmetic(arithmetic);iv.dps=digits
    data=json.loads(trial_path.read_text());p=b.CANDIDATE
    vf=trial_coefficients(data,p);v=[iv.mpc(rat(x),rat(y)) for x,y in vf]
    norm=sum(t*t for t in p);k=[iv.mpf(t)/iv.sqrt(norm) for t in p]
    cx,cy=(F(t) for t in data['z'])
    xr=iv.mpf([rat(cx-box_radius).a,rat(cx+box_radius).b])
    yi=iv.mpf([rat(cy-box_radius).a,rat(cy+box_radius).b])
    z=iv.mpc(xr,yi);L=iv.ln(3);rho=2*iv.pi/L
    require(abs(z/rho)<=iv.mpf(M)/2,'Fourier inverse outside safe band')
    kappa=rat(THRESHOLD-ELL);width=rat(UPPER-ELL)
    require(kappa>0 and width>0,'Invalid spectral premises')
    require(2*((iv.sqrt(3)+1/iv.sqrt(3))/2)+iv.ln(2)/iv.sqrt(2)<3,'Arithmetic envelope B=3 failed')
    ns=np.arange(-64,65,dtype=np.int64);ms=np.arange(65,M+1,dtype=np.int64)
    sig=b.symbol_array(np.arange(1,M+1,dtype=np.int64))
    slo=np.r_[-sig.hi[:64][::-1],0,sig.lo[:64]];shi=np.r_[-sig.lo[:64][::-1],0,sig.hi[:64]]
    s=[iv.mpf([float(x),float(y)]) for x,y in zip(slo,shi)]
    A=[[iv.mpf(0) for _ in range(129)] for _ in range(129)]
    for i,n in enumerate(ns):
        A[i][i]=b.diagonal_iv(int(n))-rat(ELL)
        for j in range(i): A[i][j]=A[j][i]=(s[i]-s[j])/(iv.pi*int(ns[j]-n))
    def g(n):
        return conj(2*z*iv.sin(L*z/2)/(iv.sqrt(L)*(z*z-rho*rho*n*n)))
    gh=[g(int(n)) for n in ns]
    Av=[sum((A[i][j]*v[j] for j in range(129)),iv.mpc(0)) for i in range(129)]
    raw=[gh[i]-Av[i] for i in range(129)]
    alpha=sum((k[i]*raw[i] for i in range(129)),iv.mpc(0))
    head=sum((abs2(raw[i]-alpha*k[i]) for i in range(129)),iv.mpf(0))
    pairing=sum((conj(gh[i])*v[i] for i in range(129)),iv.mpc(0)).real
    energy=sum((conj(v[i])*Av[i] for i in range(129)),iv.mpc(0)).real
    objective=2*pairing-energy
    # Evaluate BOTH signs directly. No finite-tail parity shortcut is needed.
    vr=[b.outer_iv(t.real) for t in v];vi=[b.outer_iv(t.imag) for t in v]
    colr=b.I(np.zeros(len(ms)));coli=b.I(np.zeros(len(ms)))
    negr=b.I(np.zeros(len(ms)));negi=b.I(np.zeros(len(ms)))
    for j,n in enumerate(ns):
        coeff=(b.I(slo[j],shi[j])-b.I(sig.lo[64:],sig.hi[64:]))/(b.PI*b.I(ms-n))
        colr=colr+coeff*vr[j];coli=coli+coeff*vi[j]
        negcoeff=(b.I(slo[j],shi[j])+b.I(sig.lo[64:],sig.hi[64:]))/(b.PI*b.I(-ms-n))
        negr=negr+negcoeff*vr[j];negi=negi+negcoeff*vi[j]
    pref=conj(-2*z*iv.sin(L*z/2)/(iv.sqrt(L)*rho**2));omega=conj(z/rho)
    prefI=(b.outer_iv(pref.real),b.outer_iv(pref.imag));w2=omega**2
    denr=b.I(ms*ms)-b.outer_iv(w2.real);deni=-b.outer_iv(w2.imag)
    gi=b.cmul(prefI,b.cinv(denr,deni))
    rr,ri=gi[0]-colr,gi[1]-coli
    rn,inn=gi[0]-negr,gi[1]-negi
    observed=interval_sum(rr*rr+ri*ri+rn*rn+inn*inn)
    # Compute all four moments, even where symmetry could set one to zero.
    A0=sum(v,iv.mpc(0))
    B0=sum((s[j]*v[j] for j in range(129)),iv.mpc(0))
    A1=sum((iv.mpf(int(ns[j]))*v[j] for j in range(129)),iv.mpc(0))
    B1=sum((iv.mpf(int(ns[j]))*s[j]*v[j] for j in range(129)),iv.mpc(0))
    l1=sum((abs(t) for t in v),iv.mpf(0))
    # Sum_{m>M} m^{-p} <= M^{-(p-1)} for p=2,4,6.
    # This is deliberately the conservative bound proved in the Lean source.
    moment_tail=8/iv.pi**2*((9*abs2(A0)+abs2(B0))/M+(9*abs2(A1)+abs2(B1))/M**3)
    jet_tail=16*9*64**4*l1**2/(iv.pi**2*(1-iv.mpf(64)/M)**2*M**5)
    coupling_tail=moment_tail+jet_tail
    fourier_tail=32*abs2(pref)/(9*M**3)
    residual_tail=2*coupling_tail+2*fourier_tail
    full_residual=head+observed+residual_tail
    budget=objective+full_residual/kappa
    candidate=sum((conj(gh[i])*k[i] for i in range(129)),iv.mpc(0))
    error_sq=width*budget
    # Certificate guards refer to the actual finite trial, full omitted tail,
    # and exact rational external spectral inequalities, separately recorded.
    require(budget>0 and budget<103,'Directional coefficient not below 103')
    require(error_sq<rat(F(7,20000))**2,'Readout error not below 7/20000')
    require(abs(candidate)>rat(F(27,20000)),'Candidate floor not above 27/20000')
    require(F(27,20000)-F(7,20000)==F(1,1000),'Rational nonzero margin')
    return {
      'status':'all new full-residual interval comparisons passed','digits':digits,'N':64,'M':M,
      'query_center':data['z'],
      'query_box':{'real':[str(cx-box_radius),str(cx+box_radius)],'imag':[str(cy-box_radius),str(cy+box_radius)]},
      'covers_entire_query_box':True,'candidate_integer_energy':str(norm),
      'candidate_literal_sha256':CANDIDATE_HASH,
      'arithmetic_input_sha256':hashlib.sha256(arithmetic.read_bytes()).hexdigest(),
      'arithmetic_primitive_AST_sha256':PRIMITIVE_AST_HASH,
      'arithmetic_input_scope':'Only the pinned primitive definitions and constants are executed, under explicitly supplied standard-library globals. The input SHA identifies the complete local source bytes read, which are not asserted equal to the complete upstream file.',
      'trial_sha256':hashlib.sha256(trial_path.read_bytes()).hexdigest(),
      'checker_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'spectral_premises':{'ell':str(ELL),'upper':str(UPPER),'threshold':str(THRESHOLD)},
      'candidate_orthogonality':'exact Gaussian-rational elimination; no tolerance',
      'trial_norm_sq':enclosure(sum((abs2(t) for t in v),iv.mpf(0))),
      'trial_pairing':enclosure(pairing),'trial_shifted_energy':enclosure(energy),
      'objective':enclosure(objective),'projected_residual_head_sq':enclosure(head),
      'observed_two_sided_residual_sq':enclosure(observed),
      'uncomputed_two_sided_residual_sq_upper':enclosure(residual_tail),
      'full_projected_residual_sq_upper':enclosure(full_residual),
      'full_dual_budget_upper':enclosure(budget),'candidate_modulus':enclosure(abs(candidate)),
      'claimed_rational_bounds':{'dual_budget':'103','Fourier_error':'7/20000','candidate_modulus_lower':'27/20000','actual_mode_modulus_lower':'1/1000'},
      'tail_scope':'Both signs are evaluated independently in the finite exterior. All four boundary moments are interval-evaluated. Upper-expression intervals are not lower bounds on the actual omitted norm.',
      'method':'arbitrary finite trial, actual shifted arithmetic action, complete projected residual, existing coercive dual variational theorem',
      'analytic_obligations':['Existing complete Weil spectral inequalities; original LDL verifier not rerun','Arithmetic Fourier-basis identification and actual operator-domain inclusion of the finite trial','Continuous Fourier/Riesz identification, Parseval, and correct physical prefactor','Actual lowest-mode evenness under the compatible full-space reflection symmetry; the Riesz vector used here is the even Fourier projection'],
      'not_claimed':['full upstream-file attestation','kernel checking','a new eigenvalue enclosure','a zero count','unbounded-scale Weil/prolate convergence','RH']}


def main():
    root=Path(__file__).resolve().parent
    a=argparse.ArgumentParser(description=__doc__)
    a.add_argument('--arithmetic-source',type=Path,default=root/'certify_prime3_refined.py')
    a.add_argument('--trial',type=Path,default=root/'prime3_full_residual_trial.json')
    a.add_argument('--output',type=Path,default=root/'prime3_full_residual_certificate.json')
    a.add_argument('--box-radius',type=F,default=F(1,100000));
    a.add_argument('--M',type=int,default=8192);a.add_argument('--digits',type=int,default=60)
    args=a.parse_args();r=certify(args.arithmetic_source,args.trial,args.M,args.digits,args.box_radius)
    args.output.write_text(json.dumps(r,indent=2)+'\n')
    print(json.dumps({k:r[k] for k in ('status','full_dual_budget_upper','claimed_rational_bounds')},indent=2))
if __name__=='__main__': main()
