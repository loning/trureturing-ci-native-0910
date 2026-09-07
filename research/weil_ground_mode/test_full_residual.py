"""Exact algebraic checks and directed-interval replays for the full residual.

Finite diagnostics are not a Lean proof. The original whole-space spectral
verifier is not executed. A changed trial is allowed in principle; only a
successful complete certificate makes it usable.
"""
from __future__ import annotations
import argparse
from fractions import Fraction as F
import importlib.util
import json
from pathlib import Path
import random
import tempfile


def require(value, message):
    if not value: raise ArithmeticError(message)


def Z(r=0,i=0): return (F(r),F(i))
def add(a,b): return (a[0]+b[0],a[1]+b[1])
def neg(a): return (-a[0],-a[1])
def sub(a,b): return add(a,neg(b))
def mul(a,b): return (a[0]*b[0]-a[1]*b[1],a[0]*b[1]+a[1]*b[0])
def cj(a): return (a[0],-a[1])
def ns(a): return a[0]*a[0]+a[1]*a[1]
def div(a,b):
    d=ns(b)
    if not d: raise ZeroDivisionError('exact zero')
    return mul(a,(b[0]/d,-b[1]/d))
def sm(s,a): return (s*a[0],s*a[1])
def zs(values):
    a=Z()
    for b in values: a=add(a,b)
    return a


def exact_checks():
    rng=random.Random(20260907)
    report={'gaussian_moment_cases':0,'paired_jet_identities':0,
            'two_sided_coefficient_checks':0,'finite_tail_checks':0,
            'cauchy_inverse_checks':0,'reciprocal_steps':0,
            'retained_only_residual_counterexample':False}
    for case in range(120):
        N=1+case%5; M=3*N+2; P=F(3); B=F(1)
        v={n:Z(F(rng.randint(-5,5),11),F(rng.randint(-5,5),13)) for n in range(-N,N+1)}
        if case%17==0: v={n:Z() for n in v}
        def s(n): return F(n,1+abs(n))
        A0=zs(v.values()); B0=zs(sm(s(n),a) for n,a in v.items())
        A1=zs(sm(F(n),a) for n,a in v.items())
        B1=zs(sm(F(n)*s(n),a) for n,a in v.items())
        l1=sum((abs(a[0])+abs(a[1]) for a in v.values()),F(0))
        Q=2*B*N*N*M/(P*(M-N))*l1
        X=B*B*ns(A0)+ns(B0);Y=B*B*ns(A1)+ns(B1)
        T=8*X/(P*P*M)+8*Y/(P*P*M**3)+4*Q*Q/M**5
        partial=F(0)
        for m in range(M+1,M+17):
            def col(t): return zs(sm((s(n)-s(t))/(P*(t-n)),a) for n,a in v.items())
            def jet(t): return add(sm(1/(P*t),sub(B0,sm(s(t),A0))),sm(1/(P*t*t),sub(B1,sm(s(t),A1))))
            Jp,Jn=jet(m),jet(-m)
            U=add(sm(-s(m),A0),sm(F(1,m),B1))
            V=sub(B0,sm(s(m)/m,A1))
            require(ns(Jp)+ns(Jn)==2/(P*P*m*m)*(ns(U)+ns(V)),'Exact paired jet')
            report['paired_jet_identities']+=1
            for t in (m,-m):
                exact=zs(sm((s(n)-s(t))*n*n/(P*t*t*(t-n)),a) for n,a in v.items())
                require(sub(col(t),jet(t))==exact,'Exact second remainder')
                require(ns(exact)<=Q*Q/F(m**6),'Remainder coefficient budget')
                report['two_sided_coefficient_checks']+=1
            pair=ns(col(m))+ns(col(-m));partial+=pair
            require(pair<=8*X/(P*P*m*m)+8*Y/(P*P*m**4)+4*Q*Q/m**6,'Column pair bound')
            pref=Z(F(3,7),F(-2,5));w=Z(F(M,5),F(M,7))
            g=div(pref,sub(Z(m*m),mul(w,w)))
            require(ns(g)<=F(16,9)*ns(pref)/m**4,'Cauchy inverse square')
            report['cauchy_inverse_checks']+=1
        require(partial<=T,'Positive finite partial sum under full bound')
        report['finite_tail_checks']+=1;report['gaussian_moment_cases']+=1
    for x in (F(n,d) for n in range(1,50) for d in (1,2,7)):
        require(1/(x+1)**2<=1/x-1/(x+1),'Telescoping reciprocal step')
        report['reciprocal_steps']+=1
    # The existing #5882 warning, replayed as a negative control.
    # M=[[2,1],[1,2]], kappa=1, g=(1,0), v=(1/2,0).
    # Full residual=(0,-1/2), omitted by a one-coordinate retained check.
    Cbad=F(1,2); Cfull=F(3,4); f0,f1=F(2,3),F(-1,3)
    q=2*f0*f0+2*f0*f1+2*f1*f1
    require(f0*f0>Cbad*q and f0*f0<=Cfull*q,'Retained-only counterexample')
    report['retained_only_residual_counterexample']=True
    return report


def run(arithmetic, trial, checker):
    spec=importlib.util.spec_from_file_location('full_residual_checker',checker)
    require(spec is not None and spec.loader is not None,'Missing checker')
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    algebra=exact_checks(); replays=[]
    for digits in (50,90):
        result=module.certify(arithmetic,trial,8192,digits)
        require(F(result['full_dual_budget_upper']['upper'])<103,'Replayed coefficient')
        require(result['claimed_rational_bounds']['actual_mode_modulus_lower']=='1/1000','Replayed margin')
        replays.append({'digits':digits,'dual_budget':result['full_dual_budget_upper']})
    box_rejections=[]
    for radius in (F(1,1000),F(1,10000)):
        try: module.certify(arithmetic,trial,8192,60,radius)
        except ArithmeticError as exc: box_rejections.append({'radius':str(radius),'guard':str(exc)})
        else: raise ArithmeticError('Historical fixed-budget box control changed; inspect before updating this regression')
    accumulator_cases=0
    for values in ([1.,2.**-53,-1.],[2.**100,-2.**100,3.],[0.,-0.,2.**-1074],[-2.**-1074,2.**-1074]):
        exact=sum((F.from_float(x) for x in values),F(0)); got=module.exact_binary_sum(values)
        require(module.endpoint_fraction(got,False)<=exact<=module.endpoint_fraction(got,True),'Dyadic accumulation')
        accumulator_cases+=1
    failures=[]
    with tempfile.TemporaryDirectory() as td:
        td=Path(td); changed=td/'changed.py'
        changed.write_text(arithmetic.read_text().replace('return gamma+pole+prime','return gamma+pole-prime'))
        broken=td/'broken.json';data=json.loads(trial.read_text());data['positive_coefficients'].pop();broken.write_text(json.dumps(data))
        huge=td/'huge.json';data=json.loads(trial.read_text());data['z']=['1000000','1/4'];huge.write_text(json.dumps(data))
        for name,src,tr,M,ds in [('arithmetic-sign',changed,trial,8192,60),('missing-trial-coordinate',arithmetic,broken,8192,60),
                               ('insufficient-cutoff',arithmetic,trial,64,60),('insufficient-precision',arithmetic,trial,8192,20),
                               ('unsafe-Fourier-band',arithmetic,huge,8192,60)]:
            try: module.certify(src,tr,M,ds)
            except ArithmeticError: failures.append(name)
            else: raise ArithmeticError('Invalid certificate was accepted: '+name)
    return {'exact_algebra':algebra,'interval_replays':replays,'dyadic_accumulator_cases':accumulator_cases,
            'larger_boxes_failing_this_fixed_budget':box_rejections,
            'negative_inputs_rejected':failures,'lean_executed':False,'upstream_spectral_verifier_executed':False,
            'scope':'single-author finite diagnostics and full-residual interval transport; no independent proof reviewer'}


def main():
    root=Path(__file__).resolve().parent
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--arithmetic-source',type=Path,default=root/'certify_prime3_refined.py')
    p.add_argument('--trial',type=Path,default=root/'prime3_full_residual_trial.json')
    p.add_argument('--output',type=Path,default=root/'full_residual_validation.json')
    a=p.parse_args();r=run(a.arithmetic_source,a.trial,root/'certify_prime3_full_residual.py')
    a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r,indent=2))
if __name__=='__main__':main()
