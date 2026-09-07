"""Actual centered Fourier disk transport using an independently checked even sector.

The complete centered residual is recomputed from the existing arithmetic
owner and the same prolate model, reusing the preceding centered consumer's
formulas. The sector Schur producer must be replayed separately. No original
full-spectrum or true-prolate spectral theorem is regenerated here.

The even coefficient is lifted using opposite-sector shifted nonnegativity.
The old GLOBAL model-recentering factor and origin margin stay unchanged.
We do not substitute the even gap into a full-space coercivity hypothesis.
"""
from pathlib import Path
from fractions import Fraction as F
import importlib.util, json, hashlib
import numpy as np
from mpmath import iv
def load(path,name):
    s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
def require(h,msg):
    if not bool(h):raise ArithmeticError(msg)
def Q(x):
    x=F(x);return iv.mpf(x.numerator)/x.denominator
def cj(z):return iv.mpc(z.real,-z.imag)
def sq(z):return z.real**2+z.imag**2
def box_swell(z,eta):
    return iv.mpc(iv.mpf([z.real.a-eta.b,z.real.b+eta.b]),iv.mpf([z.imag.a-eta.b,z.imag.b+eta.b]))
def interval(r):return iv.mpf([Q(r['lower']).a,Q(r['upper']).b])
def centered_result(prior_checker, genuine_checker, arithmetic_source, trial, model_dir, digits):
    require(__debug__,'Do not disable upstream assertions');require(digits>=100,'Insufficient model precision')
    old=load(prior_checker,'old_full_residual');gen=load(genuine_checker,'genuine_transport');inherited=gen.load_upstream(model_dir)
    previous=old.certify(arithmetic_source,trial,8192,digits,F(1,100000))
    b=old.load_arithmetic(arithmetic_source);iv.dps=digits
    FT,model_norm,L=gen.polynomial_model(model_dir/'prime3_prolate_proposal.json')
    a=L/2;op=FT(iv.mpc(0));oe=iv.sqrt(L)*Q(F(1,10**23))
    require(op.imag.a<=0<=op.imag.b,'Imaginary real-model origin')
    origin=iv.mpf([op.real.a-oe.b,op.real.b+oe.b])
    zc=iv.mpc(20,Q(F(1,4)));h=Q(F(1,100000))
    z=iv.mpc(iv.mpf([20-h.b,20+h.b]),iv.mpf([Q(F(1,4)).a-h.b,Q(F(1,4)).b+h.b]))
    gn=iv.sqrt(L)*iv.exp(a*Q(F(25001,100000)));deriv=a*gn
    # Entire closed box: distance to center <= sqrt(2)h <3h/2.
    evalue=box_swell(FT(zc),gn*Q(F(1,10**23))+deriv*Q(F(3,2))*h);ratio=evalue/origin
    p=b.CANDIDATE;vf=old.trial_coefficients(json.loads((trial).read_text()),p)
    v=[iv.mpc(Q(x),Q(y)) for x,y in vf];k=[iv.mpf(x)/iv.sqrt(sum(t*t for t in p)) for x in p]
    ns=np.arange(-64,65,dtype=np.int64);sig=b.symbol_array(np.arange(1,65,dtype=np.int64))
    lo=np.r_[-sig.hi[::-1],0,sig.lo];hi=np.r_[-sig.lo[::-1],0,sig.hi]
    symbols=[iv.mpf([float(x),float(y)]) for x,y in zip(lo,hi)]
    ell=F(2252813807,40960000000000000);kap=F(3,250000)-ell
    delta=F(560909,10**13)-ell;nu=F(929549,15625000000000)-ell;eps=F(113,100000);rho=2*iv.pi/L
    raw=[]
    for i,n in enumerate(ns):
        Mv=(b.diagonal_iv(int(n))-Q(ell))*v[i]
        Mv+=sum(((symbols[i]-symbols[j])/(iv.pi*int(ns[j]-n))*v[j] for j in range(129) if i!=j),iv.mpc(0))
        gz=cj(2*z*iv.sin(L*z/2)/(iv.sqrt(L)*(z*z-rho*rho*int(n)**2)))
        raw.append(gz-Mv)
    alpha=sum((k[i]*raw[i] for i in range(129)),iv.mpc(0));R0=raw[64]-alpha*k[64]
    # h=gz-conj(ratio)g0; P_k g0=sqrt(L)*(e_0-k_0*k).
    qq=cj(ratio)*iv.sqrt(L)
    correction=sq(qq)*(1-k[64]**2)-2*(qq*cj(R0)).real
    covariance_head=interval(previous['projected_residual_head_sq'])+correction
    direct_head=sum((sq(raw[i]-alpha*k[i]-qq*((1 if i==64 else 0)-k[64]*k[i])) for i in range(129)),iv.mpf(0))
    require(not bool(covariance_head.a>direct_head.b) and not bool(direct_head.a>covariance_head.b),'Head/covariance disagreement')
    tails=interval(previous['observed_two_sided_residual_sq'])+interval(previous['uncomputed_two_sided_residual_sq_upper'])
    objective=interval(previous['objective'])-2*(ratio*iv.sqrt(L)*v[64]).real
    C=objective+(direct_head+tails)/Q(kap);Ccov=objective+(covariance_head+tails)/Q(kap)
    require(C>0 and C<108,'Centered coefficient needs a larger cap')
    ss=F(1,100000);ke=kap*(1-eps**2)/(1+ss)-delta*eps**2/ss
    tt=F(1,50000);factor=(1+tt)+(1+1/tt)*(eps/(1-eps))**2*(nu/ke)
    require(ke>nu>0,'Spectral placement')
    anchor=F(39,50)
    require(abs(origin)>Q(F(805,1000)),'Model-origin bound')
    require(L*Q(nu)<Q(ke)*(Q(F(805,1000))-Q(anchor))**2,'Aligned-mode anchor')
    error2=Q(factor)*C*Q(nu)/Q(anchor)**2
    require(factor*108*nu/anchor**2<F(9,10000)**2,'Exact rounded-budget transport')
    require(error2<Q(F(9,10000))**2,'Normalized error bound')
    return {'status':'all centered full-residual interval guards passed','digits':digits,
      'query_box':previous['query_box'],'entire_box':True,
      'model_ratio_real':old.enclosure(ratio.real),'model_ratio_imag':old.enclosure(ratio.imag),
      'model_origin':old.enclosure(origin),'head_covariance_correction':old.enclosure(correction),
      'centered_head_covariance':old.enclosure(covariance_head),'centered_head_direct':old.enclosure(direct_head),
      'complete_unchanged_exterior':old.enclosure(tails),'centered_signed_objective':old.enclosure(objective),
      'centered_dual_budget':old.enclosure(C),'centered_dual_budget_covariance':old.enclosure(Ccov),
      'centered_budget_cap':'108','multiplicative_factor':str(factor),'factor_interval':old.enclosure(Q(factor)),
      'derived_p_e_anchor_lower':str(anchor),'normalized_error_sq':old.enclosure(error2),'normalized_error_cap':'9/10000',
      'old_full_residual_verifier_replayed':True,'upstream_spectral_and_model_verifiers_replayed':False,
      'inherited_model_inputs':inherited,'arithmetic_primitive_AST_sha256':previous['arithmetic_primitive_AST_sha256'],
      'centered_computation': 'The preceding archived centered consumer is reused here with explicit input paths.',
      'scope':'Actual archived c=3 coefficients and trial. Inherited spectral, model, domain, Fourier and derivative identities remain premises. New centered coefficient is recomputed. This does not improve the larger disk origin certificate on #5602, or establish an unbounded actual scale rate, or claim Lean checking.'}

PRIOR_SHA='35c4376cf0638a9aa1dff5b69d042f0191e103d6c9fb941efc5d83f2a1302eea'
GENUINE_SHA='69d1e5f8bc872618c3de8ea80921affd561df3b06bab22ba49f16490a4faf352'
def run(prior_checker, genuine_checker, arithmetic_source, trial, model_dir, sector_source, sector_certificate, digits=100):
    require(__debug__,'Do not disable inherited arithmetic assertions')
    require(digits>=100,'Require at least 100 digits for the inherited prolate model')
    require(hashlib.sha256(prior_checker.read_bytes()).hexdigest()==PRIOR_SHA,'Changed full-residual owner')
    require(hashlib.sha256(genuine_checker.read_bytes()).hexdigest()==GENUINE_SHA,'Changed genuine-model owner')
    sector=json.loads(sector_certificate.read_text())
    require(sector['checker_sha256']==hashlib.sha256(sector_source.read_bytes()).hexdigest(),'Sector source/result mismatch')
    require(sector['even_candidate_complement_threshold']=='1/1000','Unexpected sector threshold')
    require(F(sector['even_congruence']['margin'])>0,'No exact sector positivity certificate')
    previous=centered_result(prior_checker,genuine_checker,arithmetic_source,trial,model_dir,digits)
    ell=F(2252813807,40960000000000000)
    nu=F(previous['inherited_model_inputs']['selected_fields']['rayleigh'][1])-ell
    require(0<nu<F(1,10**8),'Actual shifted model energy range')
    ke=F(1,1000)-ell
    J=F(previous['centered_signed_objective']['upper'])
    R2=F(previous['centered_head_direct']['upper'])+F(previous['complete_unchanged_exterior']['upper'])
    C=J+R2/ke
    require(C<F(49,20),'Even centered coefficient exceeds 49/20')
    require(ke>F(999,10**6),'Shifted sector guard')
    factor=F(previous['multiplicative_factor'])
    require(factor<F(20001,20000),'Global model-recentering factor changed')
    # Even Fourier Riesz variation is bounded by the full supported kernel.
    L=iv.ln(3);a=L/2
    derivative=a*iv.sqrt(L)*iv.exp(a*Q(F(251,1000)))
    centered_lipschitz=derivative*(1+iv.sqrt(L)/Q(F(805,1000)))
    require(centered_lipschitz<Q(F(8,5)),'Full-disk centered variation cap failed')
    require(abs(interval(previous['model_origin']))>Q(F(805,1000)),'Origin model floor')
    radius=F(1,1000);variation=F(8,5)*radius;young=F(1,30)
    diskC=(1+young)*F(49,20)+(1+1/young)*variation**2/F(999,10**6)
    require(diskC<F(21,8),'Disk sector coefficient exceeds 21/8')
    b=F(39,50)
    error_sq=factor*F(21,8)*nu/b**2
    require(error_sq<F(7,50000)**2,'Normalized disk error guard failed')
    oldcap=F(51,100000)
    require(oldcap/F(7,50000)>F(18,5),'Comparison with historical bound')
    return {
      'status':'Replayed complete centered residual and all new even-sector disk guards passed',
      'digits':digits,'arithmetic_window':'a=log(3)/2',
      'disk_center':['20','1/4'],'closed_disk_radius':'1/1000',
      'sector_certificate_sha256':hashlib.sha256(sector_certificate.read_bytes()).hexdigest(),
      'sector_producer_sha256':sector['checker_sha256'],
       'checker_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'prior_checker_sha256':PRIOR_SHA,'genuine_checker_sha256':GENUINE_SHA,
      'model_input_projection':previous['inherited_model_inputs'],
      'arithmetic_primitive_AST_sha256':previous['arithmetic_primitive_AST_sha256'],
      'complete_centered_residual_replayed':True,
      'sector_spectrum_replayed_inside_this_program':False,
      'shifted_even_complement_threshold':str(ke),
      'complete_centered_residual_sq_upper':str(R2),
      'signed_objective_upper':str(J),
      'new_centered_coefficient_bound':str(C),'new_centered_coefficient_cap':'49/20',
      'previous_centered_coefficient':previous['centered_dual_budget'],
      'centered_kernel_lipschitz_interval':str(centered_lipschitz),
      'centered_kernel_lipschitz_cap':'8/5',
      'disk_coefficient_bound':str(diskC),'disk_coefficient_cap':'21/8',
      'global_model_recentering_factor':str(factor),'actual_projective_origin_lower':'39/50',
      'normalized_error_squared_bound':str(error_sq),'normalized_error_upper':'7/50000',
      'normalization':'FT(u)(z)/FT(u)(0) compared with the same aligned genuine prolate FT(e)(z)/FT(e)(0)',
      'analytic_scope':[
        'The new even-sector Schur certificate supplies its stronger threshold only on even k-perp',
        'Opposite-sector shifted positivity and the original global spectral lower bound remain inherited at a=log(3)/2',
        'Existing actual mode evenness, Fourier/core/Parseval identification and genuine model bounds retain their original analytic scope',
        'The full-support exponential derivative bound and centered Riesz variation give the entire closed frequency disk'],
      'not_claimed':['New full-space gap of 1/1000','Global shifted positivity on the neighboring scale interval',
        'Reexecution of upstream prolate/global-spectrum verifiers','Lean kernel verification',
        'Unbounded-scale decay of the genuine Weil/prolate normalized error']}


if __name__=='__main__':
    import argparse
    root=Path(__file__).resolve().parent
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--prior-checker',type=Path,default=root/'certify_prime3_full_residual.py')
    parser.add_argument('--genuine-checker',type=Path,default=root/'certify_prime3_genuine_model_dual.py')
    parser.add_argument('--arithmetic-source',type=Path,default=root/'certify_prime3_refined.py')
    parser.add_argument('--trial',type=Path,default=root/'prime3_full_residual_trial.json')
    parser.add_argument('--model-dir',type=Path,required=True)
    parser.add_argument('--sector-source',type=Path,default=root/'certify_prime3_even_sector.py')
    parser.add_argument('--sector-certificate',type=Path,default=root/'prime3_even_sector_certificate.json')
    parser.add_argument('--digits',type=int,default=100)
    parser.add_argument('--output',type=Path,default=root/'prime3_even_sector_readout_certificate.json')
    a=parser.parse_args()
    out=run(a.prior_checker,a.genuine_checker,a.arithmetic_source,a.trial,a.model_dir,a.sector_source,a.sector_certificate,a.digits)
    a.output.write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps(out,indent=2))
