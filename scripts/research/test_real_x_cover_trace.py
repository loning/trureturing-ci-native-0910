#!/usr/bin/env python3
"""Exact derivative and adversarial trace diagnostics, not a Lean-kernel test.

Reads the existing evaluator through a C++ include. A separate Fraction dual-
number implementation checks point enclosures for the actual residual/Jacobian.
Trace mutations are tested against an already exported complete chart.
"""
from __future__ import annotations
import argparse
from dataclasses import dataclass
from fractions import Fraction as Q
import hashlib
import json
from pathlib import Path
import random
import subprocess
import tempfile

@dataclass(frozen=True)
class Dual:
    val: Q
    der: Q = Q(0)
    @staticmethod
    def make(x):
        return x if isinstance(x, Dual) else Dual(Q(x))
    def __add__(self, other):
        y=self.make(other); return Dual(self.val+y.val,self.der+y.der)
    __radd__=__add__
    def __neg__(self): return Dual(-self.val,-self.der)
    def __sub__(self,other):return self+-self.make(other)
    def __rsub__(self,other):return self.make(other)+-self
    def __mul__(self,other):
        y=self.make(other);return Dual(self.val*y.val,self.der*y.val+self.val*y.der)
    __rmul__=__mul__
    def __truediv__(self,other):
        y=self.make(other)
        if y.val==0:raise ZeroDivisionError('dual division by zero')
        return Dual(self.val/y.val,(self.der*y.val-self.val*y.der)/(y.val*y.val))

DRIVER=r'''
#define main reference_main
#include "check_real_x_global_cover.cpp"
#undef main
int main(){try{int n; if(!(cin>>n)||n<0)return 1;
for(int k=0;k<n;k++){int mask;cin>>mask;Box X;for(auto&x:X){ll t;cin>>t;x=I::point(t*(ONE/8));}
for(int i=0;i<6;i++)for(int j=0;j<6;j++){ll re,im;cin>>re>>im;H[i][j]=C(I::point(re*(ONE/16)),I::point(im*(ONE/16)));}
if(!cin)throw runtime_error("bad diagnostic input");I f[5],J[5][5];eval(X,mask,f,J);
for(int a=0;a<5;a++)cout<<f[a].l<<' '<<f[a].h<<' ';
for(int a=0;a<5;a++)for(int j=0;j<5;j++)cout<<J[a][j].l<<' '<<J[a][j].h<<' ';cout<<'\n';}
return 0;}catch(exception const&e){cerr<<e.what();return 1;}}
'''

def expected(t,mat,mask,j):
    phases=[(Dual(Q(1)),Dual(Q(0)))]
    for k,x in enumerate(t):
        z=Dual(Q(x,8),Q(k==j));sgn=1-2*((mask>>k)&1)
        den=1+z*z
        phases.append((sgn*(1-z*z)/den,2*sgn*z/den))
    out=[]
    for a in range(5):
        re=Dual(Q(0));im=Dual(Q(0))
        for i,(r,s) in enumerate(phases):
            hr,hi=mat[i][a]
            re += Q(hr,16)*r+Q(hi,16)*s
            im += Q(hr,16)*s-Q(hi,16)*r
        out.append(re*re+im*im-6)
    return out

def test_derivatives(scriptdir,out):
    rnd=random.Random(502820260907)
    cases=[]
    for _ in range(128):
        mask=rnd.randrange(32);t=[rnd.randrange(-24,25) for _ in range(5)]
        H=[[(rnd.randrange(-32,33),rnd.randrange(-32,33)) for _ in range(6)] for _ in range(6)]
        cases.append((mask,t,H))
    cpp=out/'point_driver.cpp';cpp.write_text(DRIVER)
    exe=out/'point_driver'
    subprocess.run(['g++','-O2','-std=c++17','-I',str(scriptdir),str(cpp),'-o',str(exe)],check=True)
    lines=[str(len(cases))]
    for mask,t,H in cases:
        lines.append(' '.join(map(str,[mask,*t,*[x for row in H for z in row for x in z]])))
    proc=subprocess.run([str(exe)],input='\n'.join(lines)+'\n',capture_output=True,text=True,check=True)
    records=proc.stdout.splitlines()
    if len(records)!=len(cases):raise ValueError('missing diagnostic row')
    residual_checks=jacobian_checks=0
    derivative_factor_negative=0
    for (mask,t,H),line in zip(cases,records):
        ints=list(map(int,line.split()))
        if len(ints)!=60:raise ValueError('wrong diagnostic row size')
        for j in range(5):
            e=expected(t,H,mask,j)
            for a,z in enumerate(e):
                if j==0:
                    lo,hi=Q(ints[2*a],1<<40),Q(ints[2*a+1],1<<40)
                    if not lo<=z.val<=hi:raise ValueError(('residual enclosure',mask,t,a))
                    residual_checks+=1
                p=10+2*(5*a+j);lo,hi=Q(ints[p],1<<40),Q(ints[p+1],1<<40)
                if not lo<=z.der<=hi:raise ValueError(('Jacobian enclosure',mask,t,a,j))
                jacobian_checks+=1
                derivative_factor_negative += int(not lo<=z.der/2<=hi)
    if derivative_factor_negative==0:raise ValueError('wrong derivative variant was not detected')
    # A symbolic quotient-rule numerator identity, with exact rational evaluation.
    for _ in range(300):
        s=Q(rnd.randrange(-10,11),7);x=Q(rnd.randrange(-20,21),9);v=Q(rnd.randrange(-7,8),5)
        den=1+x*x
        real=(-2*s*x*v*den-s*(1-x*x)*2*x*v)/(den*den)
        imag=(2*s*v*den-2*s*x*2*x*v)/(den*den)
        if real != -4*s*x*v/(den*den) or imag != 2*s*(1-x*x)*v/(den*den):
            raise ValueError('closed quotient derivative identity')
    return {'cases':128,'residual_enclosures':residual_checks,'Jacobian_enclosures':jacobian_checks,
            'quotient_identity_cases':300,'half_derivative_detected_cases':derivative_factor_negative,
            'exact_arithmetic':'fractions.Fraction',
            'scope':'Finite point regressions; not universal interval soundness or Lean elaboration.'}

def test_trace(exe,centers,trace,out):
    lines=trace.read_text().splitlines()
    head=lines[0].split();chart=int(head[1]);eb=int(head[2]);tb=int(head[3])
    base=[str(exe),'replay',str(centers),str(chart),str(eb),str(tb),'1200000']
    subprocess.run(base+[str(trace)],capture_output=True,text=True,check=True)
    variants={}
    variants['missing_end']=lines[:-1]
    variants['missing_branch']=lines[:min(500,len(lines)-1)]+['END']
    variants['extra_instruction']=lines[:-1]+['G 0','END']
    q=lines.copy();h=q[0].split();h[2]=str(eb+1);q[0]=' '.join(h);variants['wrong_residual_band']=q
    q=lines.copy();idx=next(i for i,x in enumerate(q) if x.startswith('S '));q[idx]='S 0 -1099511627776';variants['boundary_cut']=q
    q=lines.copy();idx=next(i for i,x in enumerate(q) if x=='R');q[idx]='G 0';variants['false_guard']=q
    q=lines.copy();idx=next(i for i,x in enumerate(q) if x.startswith('E '));q[idx]='E '+' '.join(['0']*25);variants['false_empty_image']=q
    q=lines.copy();idx=next(i for i,x in enumerate(q) if x.startswith('C '));q[idx]='R';variants['false_residual_exclusion']=q
    results=[]
    for name,data in variants.items():
        p=out/(name+'.trace');p.write_text('\n'.join(data)+'\n')
        r=subprocess.run(base+[str(p)],capture_output=True,text=True)
        if r.returncode==0:raise ValueError('bad trace accepted: '+name)
        results.append({'mutation':name,'exit':r.returncode,'diagnostic':r.stderr.strip()})
        p.unlink()
    return results

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--reference-scripts',type=Path,required=True)
    p.add_argument('--trace-checker',type=Path,required=True)
    p.add_argument('--centers',type=Path,required=True)
    p.add_argument('--trace',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
    result={'status':'DIAGNOSTICS_PASSED','derivative':test_derivatives(a.reference_scripts,a.output),
            'rejected_traces':test_trace(a.trace_checker,a.centers,a.trace,a.output),
            'lean_kernel_verified':False}
    (a.output/'verification.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
if __name__=='__main__':main()
