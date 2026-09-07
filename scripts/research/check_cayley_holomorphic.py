#!/usr/bin/env python3
"""Exact finite diagnostics for the holomorphic Cayley MUB proof sources.

SymPy checks scalar rational identities. Gaussian-rational dual numbers
independently differentiate the complete paired residual. These checks do
not execute Lean, prove the external covering algorithm sound, or certify
a new MUB exclusion region.
"""
from __future__ import annotations
from dataclasses import dataclass
from fractions import Fraction as Q
from pathlib import Path
import json
import random
import sympy as sy

@dataclass(frozen=True)
class G:
    re: Q = Q(0)
    im: Q = Q(0)
    def __add__(self, b): return G(self.re+b.re, self.im+b.im)
    def __neg__(self): return G(-self.re, -self.im)
    def __sub__(self, b): return self+(-b)
    def __mul__(self, b):
        return G(self.re*b.re-self.im*b.im, self.re*b.im+self.im*b.re)
    def conj(self): return G(self.re, -self.im)
    def ns(self): return self.re*self.re+self.im*self.im
    def inv(self):
        if self.ns()==0: raise ZeroDivisionError('zero Gaussian denominator')
        return G(self.re/self.ns(), -self.im/self.ns())
    def __truediv__(self, b): return self*b.inv()
    def __pow__(self, n):
        if n<0: return self.inv()**(-n)
        out=ONE
        for _ in range(n): out=out*self
        return out
ZERO=G(); ONE=G(Q(1)); TWO=G(Q(2)); I=G(Q(0), Q(1))
def total(xs): return sum(xs, ZERO)
def phase(s,z): return s*(ONE+I*z)/(ONE-I*z)
def dp(s,z): return TWO*I*s/(ONE-I*z)**2
def domain(z): return 10*abs(z.im)<3*(1+z.ns())
def amplitudes(H,s,z):
    n=len(z)
    return ([total(H[k][a].conj()*phase(s[k],z[k]) for k in range(n)) for a in range(n)],
            [total(H[k][a]*phase(s[k].conj(),-z[k]) for k in range(n)) for a in range(n)])
def residual(H,s,z):
    A,B=amplitudes(H,s,z)
    return [a*b-G(Q(len(z))) for a,b in zip(A,B)]
def jacobian(H,s,z):
    A,B=amplitudes(H,s,z); n=len(z)
    return [[H[k][a].conj()*dp(s[k],z[k])*B[a]-H[k][a]*dp(s[k].conj(),-z[k])*A[a]
             for k in range(n)] for a in range(n)]

@dataclass(frozen=True)
class Dual:
    value: G
    deriv: G=ZERO
    def __add__(self,b): return Dual(self.value+b.value,self.deriv+b.deriv)
    def __neg__(self): return Dual(-self.value,-self.deriv)
    def __sub__(self,b): return self+(-b)
    def __mul__(self,b):
        return Dual(self.value*b.value,self.deriv*b.value+self.value*b.deriv)
    def inv(self):
        v=self.value.inv()
        return Dual(v,-v*self.deriv*v)
    def __truediv__(self,b): return self*b.inv()
def autodiff(H,s,z,v):
    # Evaluate the original rational program in an independent dual algebra.
    one,ii=Dual(ONE),Dual(I); Z=[Dual(x,y) for x,y in zip(z,v)]
    U=[Dual(a)*(one+ii*x)/(one-ii*x) for a,x in zip(s,Z)]
    V=[Dual(a.conj())*(one-ii*x)/(one+ii*x) for a,x in zip(s,Z)]
    n=len(z); result=[]
    for a in range(n):
        A=sum((Dual(H[k][a].conj())*U[k] for k in range(n)),Dual(ZERO))
        B=sum((Dual(H[k][a])*V[k] for k in range(n)),Dual(ZERO))
        result.append((A*B-Dual(G(Q(n)))).deriv)
    return result

def require(ok,message):
    if not ok: raise AssertionError(message)
def main():
    rng=random.Random(614320260907)
    z,s=sy.symbols('z s'); cp=s*(1+sy.I*z)/(1-sy.I*z); cm=s*(1-sy.I*z)/(1+sy.I*z)
    symbolic={
        'plus_derivative':sy.cancel(sy.diff(cp,z)-2*sy.I*s/(1-sy.I*z)**2)==0,
        'minus_derivative':sy.cancel(sy.diff(cm,z)+2*sy.I*s/(1+sy.I*z)**2)==0,
        'reciprocal_transition':sy.cancel(cp.subs(z,-1/z)+cp)==0,
        'paired_phase_product':sy.cancel(cp*cm-s**2)==0}
    require(all(symbolic.values()),'symbolic scalar identity')
    C=[[0,1,1,1,1,1],[1,0,1,-1,-1,1],[1,1,0,1,-1,-1],
       [1,-1,1,0,1,-1],[1,-1,-1,1,0,1],[1,1,-1,-1,1,0]]
    H=[[G(Q(i==j),Q(C[i][j])) for j in range(6)] for i in range(6)]
    for i in range(6):
        for j in range(6):
            require(H[i][j].ns()==1,'unit entries')
            require(total(H[i][k]*H[j][k].conj() for k in range(6))==G(Q(6 if i==j else 0)),
                    'exact scaled Gram')
    def rnd(): return G(Q(rng.randint(-8,8),4),Q(rng.randint(-1,1),8))
    signs=[ONE,-ONE,I,-I]
    for _ in range(360):
        w=rnd(); ss=rng.choice(signs)
        require(domain(w) and domain(-w) and domain(w.conj()),'domain/reflection')
        if w!=ZERO:
            require(domain(-w.inv()),'reciprocal domain')
            require(phase(ss,-w.inv())==phase(-ss,w),'chart transition')
        require((ONE-I*w).ns()>Q(2,5) and (ONE+I*w).ns()>Q(2,5),'pole margins')
        require(Q(1,4)<phase(ss,w).ns()<4,'phase annulus')
        require(dp(ss,w).ns()<=25,'phase derivative')
        require(phase(ss,w)*phase(ss.conj(),-w)==ONE,'paired inverse')
    counter=None
    for _ in range(36):
        zz=[ZERO]+[rnd() for _ in range(5)]; ss=[ONE]+[rng.choice(signs) for _ in range(5)]
        vv=[ZERO]+[rnd() for _ in range(5)]
        F=residual(H,ss,zz); J=jacobian(H,ss,zz)
        require(autodiff(H,ss,zz,vv)==[total(J[a][k]*vv[k] for k in range(6)) for a in range(6)],
                'full directional derivative')
        for k in range(1,6):
            basis=[ZERO]*6; basis[k]=ONE; col=autodiff(H,ss,zz,basis)
            require(all(col[a]==J[a][k] for a in range(5)),'dephased Jacobian entry')
        require(total(F)==ZERO,'complex residual conservation')
        require(all(total(J[a][k] for a in range(6))==ZERO for k in range(6)), 'Jacobian conservation')
        require(all(J[a][k].ns()<=120**2 for a in range(6) for k in range(6)),'uniform Jacobian bound')
        real=[G(w.re) for w in zz]; R=residual(H,ss,real); A,_=amplitudes(H,ss,real)
        require(all(R[a]==G(A[a].ns()-6) for a in range(6)),'real-slice equality')
        require(F[5]==-total(F[:5]),'deleted outcome relation')
        if any(v.im for v in F): counter=(ss,zz,J)
    require(counter is not None,'complexification negative control')
    ss,zz,J=counter; A,B=amplitudes(H,ss,zz)
    wrong=[[H[k][a].conj()*dp(ss[k],zz[k])*B[a] for k in range(6)] for a in range(6)]
    require(wrong!=J,'missing reciprocal derivative detected')
    require(not domain(I) and not domain(-I),'poles rejected')
    try: ZERO.inv()
    except ZeroDivisionError: pass
    else: raise AssertionError('unguarded zero inverse')
    require(domain(G(Q(0),Q(1,4))) and not domain(I),'unconditional Newton invariance refuted')
    b,q,r,kappa,gamma=Q(1,10),Q(1,2),Q(1),Q(2),Q(1,2)
    require(b+q*r<=r and b+q*r+kappa*gamma>r,'forcing budget indispensable')
    report={'status':'EXACT_SYMBOLIC_AND_GAUSSIAN_RATIONAL_DIAGNOSTICS',
        'symbolic_identities':symbolic,'scalar_domain_cases':360,
        'coordinate_cases_on_one_exact_order_six_seed':36,'dephased_Jacobian_entry_checks':900,
        'negative_controls_rejected':['pointwise_normSq_complexification','missing_dual_derivative',
            'Cayley_poles','zero_chart_inverse','unconditional_Newton_invariance','omitted_residual_forcing'],
        'domain':'10*abs(Im z)<3*(1+normSq z)','denominator_normSq_lower':'2/5',
        'unit_phase_normSq_range':['1/4','4'],'Jacobian_entry_bound_d6_unit_H':120,
        'lean_elaboration_executed':False,'complete_cover_kernel_verified':False,
        'full_cover_replayed_this_round':False,'new_parameter_region_excluded':False}
    path=Path(__file__).resolve().parents[2]/'docs/develop/certificates/cayley_holomorphic/verification.json'
    path.parent.mkdir(parents=True,exist_ok=True); path.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
if __name__=='__main__': main()
