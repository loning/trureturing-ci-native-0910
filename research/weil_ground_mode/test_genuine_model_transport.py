"""Exact finite diagnostics of the domain-level recentering algebra.

These are development tests, not Lean checking or actual Weil spectral runs.
The numeric interval consumer is a separate program with explicit input scope.
"""
from fractions import Fraction as F
from pathlib import Path
import json
import random


def z(a=0,b=0): return F(a),F(b)
def add(a,b): return a[0]+b[0],a[1]+b[1]
def neg(a): return -a[0],-a[1]
def sub(a,b): return add(a,neg(b))
def mul(a,b): return a[0]*b[0]-a[1]*b[1],a[0]*b[1]+a[1]*b[0]
def cj(a): return a[0],-a[1]
def ns(a): return a[0]*a[0]+a[1]*a[1]
def inv(a):
    if ns(a)==0: raise ZeroDivisionError
    return a[0]/ns(a),-a[1]/ns(a)
def div(a,b): return mul(a,inv(b))
def sm(a,v): return tuple(mul(a,x) for x in v)
def va(v,w): return tuple(add(x,y) for x,y in zip(v,w))
def vs(v,w): return tuple(sub(x,y) for x,y in zip(v,w))
def sumz(xs):
    r=z()
    for x in xs:r=add(r,x)
    return r

def inner(v,w):return sumz(mul(cj(x),y) for x,y in zip(v,w))
def norm2(v):return sum(ns(x) for x in v)
def cnormcap(x):return abs(x[0])+abs(x[1])
def vnormcap(v):return sum(cnormcap(x) for x in v)
def off(e,x):return vs(x,sm(inner(e,x),e))
def act(A,v):return tuple(sumz(mul(x,y) for x,y in zip(row,v)) for row in A)
def energy(A,v):
    q=inner(v,act(A,v))
    if q[1]!=0:raise AssertionError('Nonreal quadratic form')
    return q[0]
def require(h,msg):
    if not h:raise AssertionError(msg)


def exact_tests():
    rng=random.Random(2026090717)
    counts={'complex_domain_cases':0,'coercivity_transfers':0,'full_residual_identities':0,
            'signed_objective_identities':0,'transported_budget_bounds':0,
            'wrong_conjugation_detected':0,'omitted_model_action_controls':0}
    for j in range(800):
        n=3+j%4;k=(z(1),)+tuple(z() for _ in range(n-1))
        t=F(1+(j%7),100);c=(1-t*t)/(1+t*t);s=2*t/(1+t*t)
        u=F(1+j%13,17);phase=z((1-u*u)/(1+u*u),2*u/(1+u*u))
        e=(z(c),mul(z(s),phase))+tuple(z() for _ in range(n-2))
        require(norm2(e)==1,'Unit genuine model')
        T=F(2+j%3);mu0=F(j%5,100)
        A=[[z() for _ in range(n)] for _ in range(n)]
        A[0][0]=z(mu0)
        for i in range(1,n):A[i][i]=z(T+F(i-1,3))
        for i in range(1,n):
            b=z(F(rng.randrange(-3,4),100),F(rng.randrange(-3,4),110))
            A[0][i]=b;A[i][0]=cj(b)
        mu=energy(A,e);r=vs(act(A,e),sm(z(mu),e))
        eps=vnormcap(vs(e,k));rho=vnormcap(r)
        require(eps<1 and mu<=T,'Transfer assumptions')
        qvec=(z(-s),mul(z(c),phase))+tuple(z() for _ in range(n-2))
        f=sm(z(F(rng.randrange(-6,7),11),F(rng.randrange(-6,7),13)),qvec)
        f=tuple(x if i<2 else z(F(rng.randrange(-5,6),7),F(rng.randrange(-5,6),9)) for i,x in enumerate(f))
        require(inner(e,f)==z(),'New complement')
        tau=eps/(1-eps);newT=T-2*rho*tau
        require(newT*norm2(f)<=energy(A,f),'New coercivity')
        beta=div(inner(k,f),inner(k,e));h=vs(f,sm(beta,e))
        require(inner(k,h)==z(),'Hyperplane elimination')
        require(norm2(h)==norm2(f)+ns(beta),'Norm identity')
        require(energy(A,h)==energy(A,f)+mu*ns(beta)-2*mul(beta,inner(f,r))[0],'Energy identity')
        counts['coercivity_transfers']+=1
        v=(z(),)+tuple(z(F(rng.randrange(-10,11),11),F(rng.randrange(-10,11),13)) for _ in range(n-1))
        g=tuple(z(F(rng.randrange(-10,11),7),F(rng.randrange(-10,11),17)) for _ in range(n))
        beta=inner(e,v);ve=vs(v,sm(beta,e));raw=vs(g,act(A,v));rk=off(k,raw)
        true=off(e,vs(g,act(A,ve)))
        corrected=off(e,va(raw,sm(beta,r)))
        require(inner(e,ve)==z() and true==corrected,'Full residual identity')
        if off(e,va(raw,sm(cj(beta),r)))!=true:counts['wrong_conjugation_detected']+=1
        V=vnormcap(v);G=cnormcap(inner(g,e));Acap=cnormcap(inner(k,raw));Rcap=vnormcap(rk)
        require(norm2(true)<=(Rcap+eps*Acap+eps*V*rho)**2,'Full residual transport')
        J=2*inner(g,v)[0]-energy(A,v);Je=2*inner(g,ve)[0]-energy(A,ve)
        expected=J-2*mul(beta,inner(g,e))[0]+mu*ns(beta)+2*mul(beta,inner(v,r))[0]
        require(Je==expected,'Signed variational identity')
        objcap=J+2*eps*V*G+abs(mu)*(eps*V)**2+2*eps*V**2*rho
        require(Je<=objcap,'Objective bound')
        den=F(1,7)
        require(Je+norm2(true)/den<=objcap+(Rcap+eps*Acap+eps*V*rho)**2/den,'Complete coefficient')
        counts['full_residual_identities']+=1;counts['signed_objective_identities']+=1
        counts['transported_budget_bounds']+=1;counts['complex_domain_cases']+=1
    for H in (1,10,100,10000):
        A=[[z(),z()],[z(),z(H)]];e=(z(F(12,13)),z(F(5,13)));v=(z(),z(1));g=act(A,v)
        raw=vs(g,act(A,v));ve=off(e,v)
        require(norm2(raw)==0 and norm2(off(e,vs(g,act(A,ve))))>0,'Missing infinite-model action is unsafe')
        counts['omitted_model_action_controls']+=1
    require(counts['wrong_conjugation_detected']>700,'Complex phase mutation was not exercised')
    return {'exact_checks':counts,'lean_executed':False,'actual_Weil_spectrum_recomputed':False,
            'scope':'Exact Gaussian-rational finite model diagnostics only; universal proofs are separate Candidate Lean sources.'}


def run_full(prior_checker, arithmetic, trial, model_dir, checker):
    import importlib.util
    import shutil
    import tempfile
    spec=importlib.util.spec_from_file_location('genuine_transport_checker',checker)
    mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
    result=exact_tests();replays=[]
    for digits in (100,120):
        out=mod.certify(prior_checker,arithmetic,trial,model_dir,digits)
        require(F(out['coefficient_bound'])<105,'Replayed coefficient')
        require(F(out['model_Fourier_modulus_floor']['lower'])>F(13,10000),'Replayed true-model floor')
        replays.append({'digits':digits,'coefficient':out['coefficient_bound'],
            'model_modulus_floor':out['model_Fourier_modulus_floor']})
    rejected=[]
    with tempfile.TemporaryDirectory() as directory:
        tmp=Path(directory)
        files=['prime3_prolate_proposal.json','prime3_prolate_model_certificate.json',
               'prime3_prolate_weil_energy_certificate.json','prime3_prolate_operator_residual_certificate.json']
        for name in files:shutil.copyfile(model_dir/name,tmp/name)
        mutations=[('model-distance','prime3_prolate_model_certificate.json',
                     'true_normalized_prolate_model_to_fixed_weil_candidate_bound','0'),
                   ('wrong-alignment','prime3_prolate_model_certificate.json',
                     'polynomial_model_candidate_overlap','[0.999, 1]'),
                   ('missing-model-action','prime3_prolate_operator_residual_certificate.json',
                     'true_normalized_Rayleigh_residual_rational_interval',['0','0'])]
        for label,filename,key,value in mutations:
            original=(tmp/filename).read_bytes();data=json.loads(original);data[key]=value
            (tmp/filename).write_text(json.dumps(data))
            try:mod.certify(prior_checker,arithmetic,trial,tmp,110)
            except ArithmeticError:rejected.append(label)
            else:raise AssertionError('Mutation accepted '+label)
            (tmp/filename).write_bytes(original)
        original=(tmp/files[0]).read_bytes();(tmp/files[0]).write_bytes(original+b'\n')
        try:mod.polynomial_model(tmp/files[0])
        except ArithmeticError:rejected.append('changed-proposal')
        else:raise AssertionError('Changed proposal accepted')
        bad=tmp/'bad_checker.py';bad.write_bytes(prior_checker.read_bytes()+b'\n')
        for label,pc,digits in [('changed-owned-verifier',bad,110),('precision',prior_checker,90)]:
            try:mod.certify(pc,arithmetic,trial,model_dir,digits)
            except ArithmeticError:rejected.append(label)
            else:raise AssertionError('Unsafe input accepted '+label)
    result['interval_replays']=replays;result['rejected_inputs']=rejected
    result['upstream_prolate_and_spectral_verifiers_replayed']=False
    result['prior_full_residual_transport_verifier_replayed']=True
    return result


if __name__=='__main__':
    import argparse
    root=Path(__file__).resolve().parent
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--prior-checker',type=Path,default=root/'certify_prime3_full_residual.py')
    p.add_argument('--arithmetic-source',type=Path,default=root/'certify_prime3_refined.py')
    p.add_argument('--trial',type=Path,default=root/'prime3_full_residual_trial.json')
    p.add_argument('--model-dir',type=Path)
    p.add_argument('--output',type=Path,default=root/'genuine_model_transport_validation.json')
    a=p.parse_args()
    result=exact_tests() if a.model_dir is None else run_full(a.prior_checker,a.arithmetic_source,a.trial,
        a.model_dir,root/'certify_prime3_genuine_model_dual.py')
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
