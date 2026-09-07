#!/usr/bin/env python3
"""Exact diagnostics for the projective complex-domain and residual identities.

No floating-point decisions, root search, full coverage, or Lean execution.
Dual arithmetic recomputes derivatives independently of the displayed formula.
"""
from __future__ import annotations
from dataclasses import dataclass
from fractions import Fraction as F
import argparse
import json
from pathlib import Path
import random

@dataclass(frozen=True)
class Q:
    re: F = F(0)
    im: F = F(0)
    def __add__(self, other: Q) -> Q:
        return Q(self.re + other.re, self.im + other.im)
    def __neg__(self) -> Q:
        return Q(-self.re, -self.im)
    def __sub__(self, other: Q) -> Q:
        return self + (-other)
    def __mul__(self, other: Q) -> Q:
        return Q(self.re*other.re-self.im*other.im,
                 self.re*other.im+self.im*other.re)
    def sq(self) -> F:
        return self.re*self.re + self.im*self.im
    def conj(self) -> Q:
        return Q(self.re, -self.im)
    def inv(self) -> Q:
        n = self.sq()
        if n == 0:
            raise ValueError('zero denominator')
        return Q(self.re/n, -self.im/n)
    def __truediv__(self, other: Q) -> Q:
        return self * other.inv()

ZERO, ONE, I = Q(), Q(F(1)), Q(F(0), F(1))
SIX = Q(F(6))

def total(xs):
    result = ZERO
    for x in xs:
        result = result + x
    return result

def domain(w, R=F(2)):
    # The tested R is positive; squaring preserves strict norm comparisons.
    return R > 0 and all(x.sq() < R*R*y.sq() for x in w for y in w)

def residual(H, w):
    return [total(H[i][a].conj()*w[i] for i in range(6)) *
            total(H[i][a]/w[i] for i in range(6)) - SIX for a in range(6)]

def jacobian(H, w):
    A = [total(H[i][a].conj()*w[i] for i in range(6)) for a in range(6)]
    B = [total(H[i][a]/w[i] for i in range(6)) for a in range(6)]
    return [[H[k][a].conj()*B[a] - H[k][a]*A[a]/(w[k]*w[k])
             for k in range(6)] for a in range(6)]

@dataclass(frozen=True)
class D:
    val: Q
    der: Q = ZERO
    def __add__(self, other: D) -> D:
        return D(self.val+other.val, self.der+other.der)
    def __neg__(self) -> D:
        return D(-self.val, -self.der)
    def __sub__(self, other: D) -> D:
        return self + (-other)
    def __mul__(self, other: D) -> D:
        return D(self.val*other.val, self.der*other.val+self.val*other.der)
    def inv(self) -> D:
        inv = self.val.inv()
        return D(inv, -(inv*self.der*inv))

def dsum(xs):
    result = D(ZERO)
    for x in xs:
        result = result + x
    return result

def dual_derivative(H, w, k):
    points = [D(x, ONE if i == k else ZERO) for i,x in enumerate(w)]
    return [(dsum(D(H[i][a].conj())*points[i] for i in range(6)) *
             dsum(D(H[i][a])*points[i].inv() for i in range(6)) - D(SIX)).der
            for a in range(6)]

def phase(s, z):
    return s*(ONE+I*z)/(ONE-I*z)

def paired(H, s, z):
    u = [phase(s[i],z[i]) for i in range(6)]
    v = [phase(s[i].conj(),-z[i]) for i in range(6)]
    return [total(H[i][a].conj()*u[i] for i in range(6))*
            total(H[i][a]*v[i] for i in range(6))-SIX for a in range(6)]

def unit(t):
    return Q((1-t*t)/(1+t*t), 2*t/(1+t*t))

def require(condition, message):
    if not condition:
        raise AssertionError(message)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    rng = random.Random(614320260907)
    count, anchors, derivatives, bounds, bindings, gauge_checks = 0,0,0,0,0,0
    max_scaled_sq = F(0)
    # An exact six-order seed on a seam is sufficient for a universal theorem
    # requiring only an entry bound; no new strict-X point is asserted.
    b,e = I,-ONE
    Hseed = [[(b if i==j else ONE) if i<3 and j<3 else
              (e if i+3==j else ONE) if i<3 else
              (e.conj() if i==j+3 else ONE) if j<3 else
              (-b.conj() if i==j else -ONE)
              for j in range(6)] for i in range(6)]
    for case in range(64):
        H = Hseed if case % 2 == 0 else [
            [unit(F(rng.randint(-8,8),8)) for _ in range(6)] for _ in range(6)]
        w = [unit(F(rng.randint(-8,8),8))*
             Q(F(1)+F(rng.randint(-3,3),64),F(rng.randint(-3,3),64))
             for _ in range(6)]
        require(domain(w), 'input outside invariant domain')
        f = residual(H,w)
        J = jacobian(H,w)
        for a in range(6):
            v = [x/w[a] for x in w]
            require(domain(v) and v[a] == ONE, 'reanchoring domain failure')
            require(all(F(1,4) < x.sq() < 4 for x in v), 'anchored annulus failure')
            require(residual(H,v) == f, 'actual residual changed under reanchoring')
            # Coordinate-scaled Jacobian, not the ordinary Jacobian, is gauge invariant.
            Jv = jacobian(H,v)
            require(all(v[k]*Jv[j][k] == w[k]*J[j][k]
                        for j in range(6) for k in range(6)), 'Euler derivative changed')
            anchors += 1
        for k in range(6):
            dj = dual_derivative(H,w,k)
            for a in range(6):
                require(dj[a] == J[a][k], 'actual complex derivative mismatch')
                derivatives += 1
                n = (w[k]*J[a][k]).sq()
                max_scaled_sq = max(max_scaled_sq,n)
                require(n <= 400, '20-per-entry envelope failed')
                bounds += 1
        for a in range(6):
            require(total(w[k]*J[a][k] for k in range(6)) == ZERO,
                    'projective gauge null direction did not cancel')
        p = list(range(6)); rng.shuffle(p)
        s = [unit(F(rng.randint(-8,8),8)) for _ in range(6)]
        c = Q(F(3,7),F(4,9))
        require(domain([c*s[i]*w[p[i]] for i in range(6)]) == domain(w),
                'monomial domain covariance failed')
        require(domain([x.conj() for x in w]) == domain(w), 'conjugate domain failed')
        gauge_checks += 2
        z = [Q(F(rng.randint(-6,6),16),F(rng.randint(-2,2),64)) for _ in range(6)]
        require(paired(H,s,z) == residual(H,[phase(s[i],z[i]) for i in range(6)]),
                'paired owner and Laurent readout disagree')
        bindings += 1
        count += 1
    # Negative controls distinguish the old product annulus and preserve
    # the fixed-matrix gauge boundary and the sign of the reciprocal derivative.
    old = [Q(F(3,2)),Q(F(2,3)),ONE,ONE,ONE,ONE]
    require(all(F(1,4) < x.sq() < 4 for x in old), 'bad annulus witness')
    require(not domain(old), 'independent annulus confused with pairwise ratios')
    require((old[0]/old[1]).sq() > 4, 'old annulus did not widen under reanchoring')
    require(not domain([ZERO,ONE,ONE,ONE,ONE,ONE]), 'zero phase admitted')
    try:
        ZERO.inv()
    except ValueError:
        pass
    else:
        raise AssertionError('inverse at zero was accepted')
    w=[ONE]*6
    A=total(Hseed[i][0].conj()*w[i] for i in range(6))
    B=total(Hseed[i][0]/w[i] for i in range(6))
    wrong=Hseed[0][0].conj()*B+Hseed[0][0]*A/(w[0]*w[0])
    require(wrong != dual_derivative(Hseed,w,0)[0], 'wrong inverse derivative sign passed')
    phase_changed=w.copy(); phase_changed[0]=I
    require(residual(Hseed,phase_changed) != residual(Hseed,w),
            'fixed-H independent phase invariance falsely inferred')
    report={
        'status':'EXACT_FINITE_DIAGNOSTICS_ONLY',
        'families':count,'reanchoring_checks':anchors,
        'complex_jacobian_entries_by_dual_arithmetic':derivatives,
        'scaled_derivative_bounds':bounds,'paired_owner_bindings':bindings,
        'monomial_and_conjugate_domain_checks':gauge_checks,
        'bound_squared':400,'maximum_observed_scaled_squared':str(max_scaled_sq),
        'negative_controls':['independent_annulus_reanchoring_loss','zero_phase_domain',
            'zero_inverse','wrong_reciprocal_derivative_sign','fixed_H_independent_phase_invariance'],
        'lean_elaboration_executed':False,'scribe_rendered':False,
        'complete_cover_replayed':False,'new_Hadamard_region_excluded':False,
        'scope':'Exact rational samples diagnose errors; universal claims depend on the Lean proof, not this report.'}
    if args.output:
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
if __name__ == '__main__':
    main()
