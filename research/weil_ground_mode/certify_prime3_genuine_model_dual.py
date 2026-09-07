"""Transport a complete finite-trial certificate to the genuine prolate model.

The existing full-residual verifier is replayed. The genuine prolate model's
spectral identification, unit-model approximation, complete Rayleigh interval
and full operator residual are separately supplied upstream certificates.
They are NOT reproved by accepting their JSON fields. The new mathematics
uses their exact stated bounds and retains the infinite-support model action
introduced by changing the candidate-orthogonal hyperplane.

All new analytic finite sums and acceptance comparisons use directed intervals
or Fraction. No quadrature or eigensolver is used. The final bound is for
p_e=u/<e,u>, not the differently normalized p_k. This is one fixed scale;
there is no claim of an unbounded-scale approximation rate or Lean execution.
"""
from __future__ import annotations
import argparse
from fractions import Fraction as F
import hashlib
import importlib.util
import json
from math import factorial
from pathlib import Path
import numpy as np
from mpmath import iv

PRIOR_SHA='35c4376cf0638a9aa1dff5b69d042f0191e103d6c9fb941efc5d83f2a1302eea'
PROPOSAL_SHA='242c9897bbd247ef0485039e6dcde819a351c5900ceac52fecc420934c1896db'
EPS=F(113,100000); MODEL_ERROR=F(1,10**23)
RHO=F(458331,5000000000)
ELL=F(2252813807,40960000000000000); OLD_T=F(3,250000)
MU_LO=F(594911359,10**16); MU_HI=F(929549,15625000000000)
NEW_T=F(1179,10**8)


def require(h,why):
    if not bool(h): raise ArithmeticError(why)


def Q(x):
    x=F(x);return iv.mpf(x.numerator)/x.denominator


def cj(z):return iv.mpc(z.real,-z.imag)


def projection_hash(value):
    return hashlib.sha256(json.dumps(value,sort_keys=True,separators=(',',':')).encode()).hexdigest()


def decimal_interval(s):
    if not isinstance(s,str) or not s.startswith('[') or not s.endswith(']'):
        raise ValueError('Expected serialized upstream decimal interval')
    x,y=map(F,s[1:-1].split(','));require(x<=y,'Reversed upstream interval');return x,y


def load_upstream(directory):
    model=json.loads((directory/'prime3_prolate_model_certificate.json').read_text())
    energy=json.loads((directory/'prime3_prolate_weil_energy_certificate.json').read_text())
    residual=json.loads((directory/'prime3_prolate_operator_residual_certificate.json').read_text())
    data={'proposal_sha256':model['proposal_sha256'],
      'model_distance':str(F(model['true_normalized_prolate_model_to_fixed_weil_candidate_bound'])),
      'true_polynomial_error':model['normalized_true_vs_polynomial_model_error'],
      'polynomial_overlap':model['polynomial_model_candidate_overlap'],
      'rayleigh':list(map(str,map(F,energy['true_model_rayleigh_interval_rational']))),
      'full_residual':list(map(str,map(F,residual['true_normalized_Rayleigh_residual_rational_interval'])))}
    require(data['proposal_sha256']==PROPOSAL_SHA,'Wrong prolate proposal')
    require(F(data['model_distance'])==EPS,'Changed certified model distance')
    require(0<=decimal_interval(data['true_polynomial_error'])[0] and
            decimal_interval(data['true_polynomial_error'])[1]<MODEL_ERROR,'Model approximation budget failed')
    require(decimal_interval(data['polynomial_overlap'])[1]<0,'Aligned model sign must be negative')
    require(tuple(map(F,data['rayleigh']))==(MU_LO,MU_HI),'Changed true Rayleigh input')
    lo,hi=map(F,data['full_residual']);require(0<lo<=hi==RHO,'Changed full operator residual')
    return {'selected_fields':data,'semantic_projection_sha256':projection_hash(data),
      'scope':'Selected mathematical fields from the immutable #5602 model, energy and full residual records. These analytic premises are not reverified here; no full input-file attestation is claimed.'}


def polynomial_model(proposal):
    """Full evenized Mellin model, including mixed piece norms and both signs."""
    raw=proposal.read_bytes();require(hashlib.sha256(raw).hexdigest()==PROPOSAL_SHA,'Changed proposal bytes')
    data=json.loads(raw);require((data['scale_c'],data['dimension'],data['dyadic_bits'])==(3,32,250),'Wrong model')
    vectors=[]
    for entry in data['proposals']:
        ns=list(map(int,entry['vector_numerators']));require(len(ns)==32,'Incomplete mode')
        norm=iv.sqrt(Q(sum(F(n*n,2**500) for n in ns)))
        vectors.append([Q(F(n,2**250))/norm for n in ns])
    ratio=vectors[1][0]/vectors[0][0]
    H=[vectors[1][j]-ratio*vectors[0][j] for j in range(32)];H[0]=Q(0)
    A=[Q(0) for _ in range(32)]
    for j in range(1,32):
        factor=H[j]*iv.sqrt(Q(F(4*j+1,2)));n=2*j
        for k in range(j+1):
            degree=n-2*k
            coef=F((-1)**k*factorial(2*n-2*k),2**n*factorial(k)*factorial(n-k)*factorial(n-2*k))
            A[degree//2]+=factor*Q(coef)/3**(degree//2)
    L=iv.ln(3);a=L/2;b=a-iv.ln(2);normsq=Q(0)
    for left,right,pos,neg in [(-a,b,(1,2),(1,)),(b,-b,(1,),(1,)),(-b,a,(1,),(1,2))]:
        terms={}
        for j in range(32):
            t=F(4*j+1,2);terms[t]=2*A[j]*sum(m**(2*j) for m in pos);terms[-t]=2*A[j]*sum(m**(2*j) for m in neg)
        square={}
        for t,c in terms.items():
            for s,d in terms.items():square[t+s]=square.get(t+s,Q(0))+c*d
        normsq+=sum((v*(right-left if t==0 else (iv.exp(Q(t)*right)-iv.exp(Q(t)*left))/Q(t))
                    for t,v in square.items()),Q(0))
    require(normsq>0,'Model normalization not certified')
    norm=iv.sqrt(normsq)
    def rawFT(z):
        result=iv.mpc(0)
        for j in range(32):
            t=Q(F(4*j+1,2))+iv.j*z
            require(abs(t)>0,'Unresolved Mellin pole')
            for m in (1,2):result+=4*A[j]*m**(2*j)*(iv.exp(t*(a-iv.ln(m)))-iv.exp(-t*a))/t
        return result
    def evenFT(z):return -(rawFT(z)+rawFT(-z))/(2*norm)
    return evenFT,norm,L


def raw_candidate_component(old,arithmetic,trial,z,digits):
    """Compute <k,g-Mv> on its complete support. No omitted coefficients enter k."""
    b=old.load_arithmetic(arithmetic);iv.dps=digits
    p=b.CANDIDATE;data=json.loads(trial.read_text());vf=old.trial_coefficients(data,p)
    v=[iv.mpc(Q(x),Q(y)) for x,y in vf];k=[iv.mpf(x)/iv.sqrt(sum(t*t for t in p)) for x in p]
    ns=np.arange(-64,65,dtype=np.int64);sig=b.symbol_array(np.arange(1,65,dtype=np.int64))
    lo=np.r_[-sig.hi[::-1],0,sig.lo];hi=np.r_[-sig.lo[::-1],0,sig.hi]
    s=[iv.mpf([float(x),float(y)]) for x,y in zip(lo,hi)]
    L=iv.ln(3);omega=2*iv.pi/L;alpha=iv.mpc(0)
    for i,n in enumerate(ns):
        Mv=(b.diagonal_iv(int(n))-Q(ELL))*v[i]
        Mv+=sum(((s[i]-s[j])/(iv.pi*int(ns[j]-n))*v[j] for j in range(129) if j!=i),iv.mpc(0))
        g=cj(2*z*iv.sin(L*z/2)/(iv.sqrt(L)*(z*z-omega*omega*int(n)**2)))
        alpha+=k[i]*(g-Mv)
    return abs(alpha)


def certify(prior_checker,arithmetic,trial,model_dir,digits=110):
    require(__debug__,'Python -O would disable upstream checks')
    require(digits>=100,'At least 100 interval digits for the monomial model')
    require(hashlib.sha256(prior_checker.read_bytes()).hexdigest()==PRIOR_SHA,'Changed full-residual verifier')
    spec=importlib.util.spec_from_file_location('owned_full_residual',prior_checker)
    old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)
    upstream=load_upstream(model_dir)
    previous=old.certify(arithmetic,trial,8192,digits,F(1,100000))
    box=previous['query_box'];X=iv.mpf([Q(box['real'][0]).a,Q(box['real'][1]).b]);Y=iv.mpf([Q(box['imag'][0]).a,Q(box['imag'][1]).b]);z=iv.mpc(X,Y)
    alpha=raw_candidate_component(old,arithmetic,trial,z,digits)
    FT,norm,L=polynomial_model(model_dir/'prime3_prolate_proposal.json')
    center=iv.mpc(20,Q(F(1,4)));fc=FT(center);a=L/2
    # L2-unit compact support: the whole segment derivative has this bound.
    readout_norm=iv.sqrt(L)*iv.exp(a*Q(F(25001,100000)))
    derivative_norm=a*readout_norm
    require(derivative_norm<Q(F(2,3)),'Fourier variation bound failed')
    radius=Q(F(3,2))*Q(F(1,100000)) # sqrt(2)*h < 3h/2
    model_error=readout_norm*Q(MODEL_ERROR)
    floor=abs(fc)-model_error-derivative_norm*radius
    ceiling=abs(fc)+model_error+derivative_norm*radius
    require(floor>Q(F(13,10000)) and ceiling<Q(F(1,500)),'Genuine-model Fourier box bounds failed')
    gap=Tstar=OLD_T-2*RHO*EPS/(1-EPS)
    require(Tstar>NEW_T>MU_HI>ELL,'Transferred spectral margin failed')
    require(MU_HI-ELL<F(1,10**8),'Shifted true Rayleigh cap')
    V=F(7);R=F(87,2500);Acap=F(1,100);J=F(6,5);G=F(1,500)
    require(F(previous['trial_norm_sq']['upper'])<V*V,'Trial norm cap')
    require(F(previous['full_projected_residual_sq_upper']['upper'])<R*R,'Full projected residual cap')
    require(F(previous['objective']['upper'])<J,'Signed objective cap')
    require(alpha<Q(Acap),'Raw candidate residual component cap')
    correction=2*EPS*V*G+F(1,10**8)*(EPS*V)**2+2*EPS*V**2*RHO
    residual=R+EPS*Acap+EPS*V*RHO
    C=J+correction+residual**2/(NEW_T-ELL)
    require(C<F(105),'Recentered genuine-model dual coefficient not below 105')
    require((MU_HI-ELL)*105<F(7,10000)**2,'True-model Fourier error budget')
    require(F(13,10000)-F(7,10000)==F(3,5000),'Final nonvanishing margin')
    return {'status':'all recentering, full-residual and genuine-model box checks passed',
      'digits':digits,'scale':'a=log(3)/2; same aligned unit genuine evenized prolate model',
      'query_box':box,'full_box_not_samples':True,
      'model_input_projection':upstream,'proposal_sha256':PROPOSAL_SHA,
      'old_full_residual_verifier_replayed':True,'old_full_residual_coefficient':previous['full_dual_budget_upper'],
      'old_input_scope':previous['arithmetic_input_scope'],'arithmetic_input_sha256':previous['arithmetic_input_sha256'],
      'trial_sha256':previous['trial_sha256'],'checker_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'polynomial_model_norm':old.enclosure(norm),'aligned_polynomial_Fourier_real':old.enclosure(fc.real),
      'aligned_polynomial_Fourier_imag':old.enclosure(fc.imag),'model_Fourier_modulus_floor':old.enclosure(floor),
      'model_Fourier_modulus_upper':old.enclosure(ceiling),'Fourier_derivative_norm_upper':old.enclosure(derivative_norm),
      'raw_candidate_residual_component':old.enclosure(alpha),
      'genuine_model_complement_threshold':str(Tstar),'used_rational_threshold':str(NEW_T),
      'coefficient_bound':str(C),'coefficient_upper':'105','model_to_ground_Fourier_error_upper':'7/10000',
      'genuine_model_Fourier_modulus_lower':'13/10000','actual_aligned_mode_modulus_lower':'3/5000',
      'normalization':'p_e=u/<e,u>, where e is the aligned UNIT genuine prolate model, not p_k',
      'proof_chain':['Actual model-complement coercivity from its full residual and distance to k',
        'Repair v_e=v-<e,v>e inside the actual linear operator domain',
        'Full infinite-support correction beta*(A-mu)e retained in projected residual',
        'Existing energy-dual/projective theorem applied about e with the new positive threshold'],
      'analytic_premises':['Inherited full spectral and actual form/operator-domain certificates at c=3, not recomputed',
        'Inherited true prolate spectral identification, aligned distance, full Rayleigh interval and graph residual, not rerun',
        'Fourier/basis/Parseval identification from prior certificate and compact-support derivative estimate',
        'The original genuine model and trial belong to the same actual operator domain'],
      'not_claimed':['Lean kernel verification','a new eigenvalue enclosure','larger support window',
        'zero count or Xi zero theorem','unbounded-scale decay of the genuine-model directional budget']}


def main():
    root=Path(__file__).resolve().parent;p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--prior-checker',type=Path,default=root/'certify_prime3_full_residual.py')
    p.add_argument('--arithmetic-source',type=Path,default=root/'certify_prime3_refined.py')
    p.add_argument('--trial',type=Path,default=root/'prime3_full_residual_trial.json')
    p.add_argument('--model-dir',type=Path,required=True,help='Directory containing the pinned #5602 prolate proposal and three model certificates')
    p.add_argument('--digits',type=int,default=110)
    p.add_argument('--output',type=Path,default=root/'prime3_genuine_model_dual_certificate.json')
    a=p.parse_args();r=certify(a.prior_checker,a.arithmetic_source,a.trial,a.model_dir,a.digits)
    a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:r[k] for k in ['status','coefficient_upper','model_to_ground_Fourier_error_upper','actual_aligned_mode_modulus_lower']},indent=2))

if __name__=='__main__':main()
