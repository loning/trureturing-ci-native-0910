#!/usr/bin/env python3
"""Independent algebra and high-precision regression for the holomorphic tube.

The candidate universal analytic proof is in Lean source and the theory appendix. These
finite regressions do not prove it. The existing 881-row rational contraction
certificate is not rerun here. Optional --coefficient-source checks the numerical
range of every literal pair in the existing, unchanged Lean payload.
"""
from __future__ import annotations
import argparse
from fractions import Fraction as Q
import hashlib
import itertools
import json
from pathlib import Path
import random
import re
import sympy as sp
import mpmath as mp

DELTA=Q(1,10**20)
EPSILON=Q(1,10**30)
GAMMA=Q(999,1000)
GAMMA_EXT=Q(1999,2000)


def require(condition: bool, label: str) -> None:
    if not condition: raise ValueError(label)


def rational_budgets() -> dict:
    require(0<EPSILON<=DELTA,'positive nested widths')
    require(6*DELTA<=Q(1,2),'normalized inverse denominator')
    require(100*DELTA<=1,'inverse image norm')
    require(16*EPSILON+19200*DELTA<=20000*DELTA,'activity-product difference')
    require(60000*DELTA<=Q(1,200),'log branch and norm floor')
    per_entry=200*180900+20000*9*60000
    require(per_entry<=10**11,'Jacobian-entry perturbation budget')
    require(4*10**11*DELTA<=10**12*DELTA,'whole-row perturbation budget')
    require(GAMMA+10**12*DELTA<GAMMA_EXT,'strict complex contraction')
    require(GAMMA_EXT*DELTA+10000*EPSILON<DELTA,'strict tube invariance')
    require(20000*DELTA<Q(1,2),'four-child root denominator')
    return {'message_radius':str(DELTA),'activity_radius':str(EPSILON),
            'per_entry_integer_budget':per_entry,
            'invariance_slack':str(DELTA-GAMMA_EXT*DELTA-10000*EPSILON),
            'complex_row_margin':str(GAMMA_EXT-GAMMA-10**12*DELTA)}


def symbolic_algebra() -> int:
    a,b,x,m,t,k,l,E,F,z=sp.symbols('a b x m t k l E F z',nonzero=True)
    I=b*sp.exp(b*m)/(1+a*sp.exp(b*m))
    identities=[sp.diff(I,m)-I*(b-a*I),
                I/(b-a*I)-sp.exp(b*m),
                sp.diff(-sp.log(b/x-a)/b,x)-1/(x*(b-a*x)),
                (k*(E-1)*F+l*(F-1))-(l*(F-1)*E+k*(E-1))-(k-l)*(E-1)*(F-1)]
    flow=lambda c,q,u:q*u/(1+c*(q-1)*u)
    identities.append(flow(k,E,flow(k,F,x))-flow(k,E*F,x))
    # Normalize the log/exp inverse with exp(-Log H)=1/H on H!=0.
    H,P=sp.symbols('H P',nonzero=True)
    identities.append((b/H)/(1+a/H)-1/(1+z*P))
    identities[-1]=identities[-1].subs(H,b-a+b*z*P)
    aa=sp.symbols('a0:3');bb=sp.symbols('b0:3');mm=sp.symbols('m0:3')
    xx=[bb[j]*sp.exp(bb[j]*mm[j])/(1+aa[j]*sp.exp(bb[j]*mm[j])) for j in range(3)]
    pp=sp.prod(xx);hh=b-a+b*z*pp;gg=-sp.log(hh)/b
    for j in range(3):
        identities.append(sp.diff(gg,mm[j])+z*pp*(bb[j]-aa[j]*xx[j])/hh)
    identities.append(sp.diff(gg,z)+pp/hh)
    for index,identity in enumerate(identities):
        require(sp.cancel(sp.together(identity))==0,f'symbolic identity {index}')
    return len(identities)


def as_mp(q: Q): return mp.mpf(q.numerator)/q.denominator

def inverse(a,b,m):
    e=mp.exp(b*m);return b*e/(1+a*e)

def center(a,b,r):return -mp.log(b/r-a)/b


def evaluate(parent,children,lam,roots,mask,dm,dz):
    a0,b0=map(as_mp,parent)
    a=[as_mp(c[0]) for c in children];b=[as_mp(c[1]) for c in children]
    r=[as_mp(v) for v in roots];lam_mp=as_mp(lam)
    c=[center(a[j],b[j],r[j]) for j in range(len(children))]
    m=[c[j]+dm[j] for j in range(len(children))];z=lam_mp+dz
    x=[inverse(a[j],b[j],m[j]) for j in range(len(children))]
    P=mp.fprod(x[j] for j in mask);P0=mp.fprod(r[j] for j in mask)
    H=b0-a0+b0*z*P;H0=b0-a0+b0*lam_mp*P0
    D=1+z*P
    J=[-z*P*(b[j]-a[j]*x[j])/H for j in mask]
    J0=[-lam_mp*P0*(b[j]-a[j]*r[j])/H0 for j in mask]
    g=-mp.log(H)/b0;g0=-mp.log(H0)/b0
    for j in range(len(children)):
        require(abs(x[j]-r[j])<=100*as_mp(DELTA),'inverse closeness')
        require(abs(x[j])<=2,'inverse norm')
        require(abs((-mp.log(b[j]/x[j]-a[j])/b[j])-m[j])<mp.mpf('1e-85'),
                'principal chart two-sided inverse')
    require(mp.re(H)>=mp.mpf(1)/200,'log branch floor')
    require(mp.re(D)>=mp.mpf(1)/2,'vacancy/root denominator floor')
    require(abs(P/H)<=10000,'activity derivative bound')
    for u,v in zip(J,J0):require(abs(u-v)<=10**11*as_mp(DELTA),'Jacobian perturbation')
    require(abs(inverse(a0,b0,g)-1/D)<mp.mpf('1e-85'),'recursion recovery')
    # Exact rational real-row criterion, independently from complex arithmetic.
    p0=Q(1)
    for j in mask:p0*=roots[j]
    h0=parent[1]-parent[0]+parent[1]*lam*p0
    exact_row=lam*p0*sum((children[j][1]-children[j][0]*roots[j] for j in mask),Q(0))/h0
    accepted=exact_row<=GAMMA
    if accepted:
        require(sum(abs(v) for v in J)<as_mp(GAMMA_EXT),'uniform complex Jacobian')
        require(abs(g-g0)<as_mp(DELTA),'message invariant tube')
    # Differentiate along one simultaneous perturbation, including activity.
    dzdir=mp.mpc(mp.mpf('0.3'),mp.mpf('-0.2'))
    mdir=[mp.mpc(as_mp(Q(j+1,10)),mp.mpf('0.1'))
          for j in range(len(children))]
    def curve(t):
        pt=mp.fprod(inverse(a[j],b[j],m[j]+t*mdir[j]) for j in mask)
        return -mp.log(b0-a0+b0*(z+t*dzdir)*pt)/b0
    direct=mp.diff(curve,0)
    formula=-P/H*dzdir+sum((J[k]*mdir[j] for k,j in enumerate(mask)),mp.mpc(0))
    error=abs(direct-formula)
    require(error<mp.mpf('1e-80'),'simultaneous full differential')
    return accepted,error


def numerical_regressions() -> dict:
    mp.mp.dps=110
    rng=random.Random(20260907)
    count=eligible=root=0;maxerror=mp.mpf(0)
    for case in range(48):
        def pair():
            b=Q(rng.randint(20,3000),1000)
            a=Q(rng.randint(0,int((b-Q(1,100))*1000000)),1000000)
            return a,b
        parent=pair();children=[pair() for _ in range(4)]
        if case%8==0:children[0]=(Q(0),Q(1,100))
        if case%8==1:parent=(Q(299,100),Q(3))
        lam=[Q(0),Q(51,20),Q(rng.randint(0,255),100)][case%3]
        roots=[Q(20,71)+(1-Q(20,71))*Q(rng.randint(0,100),100) for _ in range(4)]
        dm=[as_mp(DELTA)*mp.mpc(rng.randint(-3,3),rng.randint(-3,3))/10 for _ in range(4)]
        dz=as_mp(EPSILON)*mp.mpc(rng.randint(-3,3),rng.randint(-3,3))/10
        for flags in itertools.product((0,1),repeat=3):
            mask=tuple(j for j in range(3) if flags[j])
            ok,error=evaluate(parent,children[:3],lam,roots[:3],mask,dm[:3],dz)
            count+=1;eligible+=int(ok);maxerror=max(maxerror,error)
        _,error=evaluate(parent,children,lam,roots,tuple(range(4)),dm,dz)
        root+=1;maxerror=max(maxerror,error)
    return {'three_child_pruning_cases':count,'four_child_root_cases':root,
            'exact_real_row_eligible_cases':eligible,'maximum_differential_error':mp.nstr(maxerror,12),
            'precision_decimal_digits':mp.mp.dps,'seed':20260907}


def negative_controls() -> dict:
    a,b,x=map(mp.mpf,('0.4','1.3','0.7'))
    true=1/(x*(b-a*x));wrong=1/(b-a*x)
    require(abs(true-wrong)>mp.mpf('0.1'),'missing vacancy factor detected')
    m=center(a,b,x)+2j*mp.pi/b
    require(abs(-mp.log(b/inverse(a,b,m)-a)/b-m)>1,'phase wrapping detected')
    require(GAMMA_EXT*DELTA+10000*Q(1,10**20)>=DELTA,'overwide activity tube rejected')
    k=Q(2544246,2780973);l=Q(782543,1650757)
    require(k!=l,'actual first two coefficient ratios differ')
    def action(c,E,x):return E*x/(1+c*(E-1)*x)
    defect=action(k,Q(2),action(l,Q(2),Q(1,2)))-action(l,Q(2),action(k,Q(2),Q(1,2)))
    require(defect!=0,'erased type/order information detected')
    return {'wrong_chart_derivative':True,'principal_branch_wrapping':True,
            'overwide_activity_tube':True,'commuted_distinct_type_flows':True,
            'first_two_type_ratio_difference':str(k-l),'first_two_flow_order_difference':str(defect)}


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output',type=Path)
    p.add_argument('--coefficient-source',type=Path)
    args=p.parse_args()
    result={'budgets':rational_budgets(),'symbolic_identities':symbolic_algebra(),
            'regressions':numerical_regressions(),'negative_controls':negative_controls(),
            'upstream_full_box_certificate':'not rerun; source theorem dependency',
            'lean_kernel':'not executed','scribe_emission':'not executed'}
    if args.coefficient_source:
        raw=args.coefficient_source.read_text()
        text=raw.split('private def coefficients',1)[1].split(']',1)[0]
        pairs=[tuple(map(int,v)) for v in re.findall(r'\((\d+),\s*(\d+)\)',text)]
        require(len(pairs)==332,'all coefficient pairs read')
        require(all(a>=0 and b-a>=10000 and b<=3000000 for a,b in pairs),'actual coefficient ranges')
        result['coefficient_ranges']={'pairs':len(pairs),'max_intercept':max(b for a,b in pairs),
                                     'min_difference':min(b-a for a,b in pairs),
                                     'source_sha256':hashlib.sha256(args.coefficient_source.read_bytes()).hexdigest()}
    root=Path(__file__).resolve().parents[2]
    folder=root/'D5/S3/StatisticalMechanics/HardCore/Holomorphic'
    result['new_source_sha256']={f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted(folder.glob('*.lean'))}
    result['verifier_sha256']=hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    data=json.dumps(result,indent=2)+'\n'
    print(data,end='')
    if args.output:args.output.write_text(data)

if __name__=='__main__':main()
