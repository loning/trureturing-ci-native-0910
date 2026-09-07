#!/usr/bin/env python3
"""Independent exact replay of actual grid-partition correspondence.

Reference values enumerate independent subsets, never deletion recursion.
The existing 881-row affine certificate is a source dependency and is not
rechecked by this program. This program does not compile Lean or Scribe.
"""
from __future__ import annotations
from dataclasses import dataclass
from fractions import Fraction as Q
from functools import lru_cache
from itertools import combinations, permutations, product
from pathlib import Path
from decimal import Decimal, localcontext
import argparse
import hashlib
import json
import re

Point = tuple[int, int]
Domain = frozenset[Point]
DIRS = ((1, 0), (0, -1), (0, 1))
ROOT_DIRS = DIRS + ((-1, 0),)
ORDERS = tuple(permutations(range(3)))
ORIGIN, PARENT = (0, 0), (-1, 0)

@dataclass(frozen=True)
class GQ:
    re: Q = Q(0)
    im: Q = Q(0)
    @staticmethod
    def coerce(x: GQ | int | Q) -> GQ:
        return x if isinstance(x, GQ) else GQ(Q(x))
    def __add__(self, other):
        b=self.coerce(other); return GQ(self.re+b.re,self.im+b.im)
    __radd__=__add__
    def __neg__(self): return GQ(-self.re,-self.im)
    def __sub__(self,other): return self+-self.coerce(other)
    def __rsub__(self,other): return self.coerce(other)+-self
    def __mul__(self,other):
        b=self.coerce(other)
        return GQ(self.re*b.re-self.im*b.im,self.re*b.im+self.im*b.re)
    __rmul__=__mul__
    def __truediv__(self,other):
        b=self.coerce(other); q=b.re*b.re+b.im*b.im
        if not q: raise ZeroDivisionError('nonzero denominator obligation failed')
        return self*GQ(b.re/q,-b.im/q)
    def __rtruediv__(self,other): return self.coerce(other)/self
    def __bool__(self): return bool(self.re or self.im)


def ensure(value: bool, label: str) -> None:
    if not value: raise ValueError(label)


def adjacent(p: Point,q: Point) -> bool:
    return abs(p[0]-q[0])+abs(p[1]-q[1]) == 1


def frame(p: Point,d: int) -> Point:
    x,y=p
    return ((x-1,y),(-y-1,x),(y-1,-x),(-x-1,-y))[d]


def inverse(p: Point,d: int) -> Point:
    x,y=p
    return ((x+1,y),(y,-x-1),(-y,x+1),(-x-1,-y))[d]


def deleted(a: int,d: int) -> Domain:
    order=ORDERS[a]
    return frozenset((ORIGIN,)+tuple(DIRS[j] for j in order[:order.index(d)]))


def advance(V: Domain,a: int,d: int) -> Domain:
    return frozenset(frame(p,d) for p in V-deleted(a,d))


def root_domain(V: Domain,e: int) -> Domain:
    return frozenset(frame(p,e) for p in V-frozenset((ORIGIN,)+ROOT_DIRS[:e]))


def memory(F: Domain,a: int,d: int,radius: int=4) -> Domain:
    moved=(frame(p,d) for p in F|deleted(a,d))
    return frozenset(p for p in moved if abs(p[0])+abs(p[1])<=radius)


@lru_cache(None)
def configurations(V: Domain) -> tuple[Domain,...]:
    vertices=tuple(sorted(V)); out=[]
    for bits in range(1<<len(vertices)):
        subset=tuple(v for j,v in enumerate(vertices) if bits>>j&1)
        if all(not adjacent(p,q) for p,q in combinations(subset,2)):
            out.append(frozenset(subset))
    return tuple(out)


@lru_cache(None)
def polynomial(V: Domain) -> tuple[int,...]:
    values=[0]*(len(V)+1)
    for S in configurations(V): values[len(S)]+=1
    while len(values)>1 and values[-1]==0: values.pop()
    return tuple(values)


@lru_cache(None)
def Z(V: Domain,z: GQ) -> GQ:
    value=GQ()
    for c in reversed(polynomial(V)): value=value*z+c
    return value


def vacancy(V: Domain,v: Point,z: GQ) -> GQ:
    return Z(V-frozenset((v,)),z)/Z(V,z)


def weighted(V: Domain,weights: dict[Point,GQ]) -> GQ:
    ans=GQ()
    for S in configurations(V):
        term=GQ(Q(1))
        for v in S: term=term*weights[v]
        ans=ans+term
    return ans


def domains() -> list[Domain]:
    points=tuple(product(range(-1,2),repeat=2))
    return [frozenset(p for j,p in enumerate(points) if bits>>j&1)
            for bits in range(1<<len(points))]


def run() -> dict:
    counts={k:0 for k in ('frame_inverses','adjacency_equivalences','configuration_bijections',
                         'weighted_partition_equalities','marked_ratio_equalities',
                         'ordered_child_matches','denominator_cleared_recursions',
                         'proper_denominator_recursions','zero_factor_cases',
                         'real_message_boxes','absent_child_values','child_context_checks')}
    pts=tuple(product(range(-2,3),repeat=2))
    for d in range(4):
        for p in pts:
            ensure(inverse(frame(p,d),d)==p and frame(inverse(p,d),d)==p,'frame inverse')
            counts['frame_inverses']+=1
        for p in pts:
            for q in pts:
                ensure(adjacent(p,q)==adjacent(frame(p,d),frame(q,d)),'grid adjacency')
                counts['adjacency_equivalences']+=1
    activities=(GQ(),GQ(Q(1)),GQ(Q(51,20)),GQ(Q(-1)),GQ(Q(-1,2),Q(1,3)))
    real_activities=activities[:3]
    D=domains()
    for V in D:
        C=set(configurations(V))
        weights={p:GQ(Q(k+1,k+2),Q((-1)**k,k+3)) for k,p in enumerate(sorted(V))}
        for d in range(4):
            U=frozenset(frame(p,d) for p in V)
            mapped={frozenset(frame(p,d) for p in S) for S in C}
            ensure(mapped==set(configurations(U)),'complete configuration image')
            ensure(polynomial(U)==polynomial(V),'independence polynomial')
            counts['configuration_bijections']+=1
            target={frame(p,d):w for p,w in weights.items()}
            ensure(weighted(U,target)==weighted(V,weights),'weighted relabeling')
            counts['weighted_partition_equalities']+=1
            for z in activities:
                for v in sorted(V)[:2]:
                    if Z(V,z):
                        ensure(vacancy(U,frame(v,d),z)==vacancy(V,v,z),'marked ratio')
                        counts['marked_ratio_equalities']+=1
        if ORIGIN not in V: continue
        W0=V-frozenset((ORIGIN,))
        # Full four-neighbor root, including missing vertices.
        cases=[(ROOT_DIRS,lambda e:root_domain(V,e))]
        if PARENT not in V:
            cases += [(tuple(DIRS[d] for d in order),
                       lambda slot,a=a,order=order:advance(V,a,order[slot]))
                      for a,order in enumerate(ORDERS)]
        for ordered,child_fn in cases:
            W=W0; records=[]
            for slot,v in enumerate(ordered):
                Wnext=W-frozenset((v,)); child=child_fn(slot)
                ensure(polynomial(child)==polynomial(W),'actual child denominator')
                ensure(polynomial(child-frozenset((ORIGIN,)))==polynomial(Wnext),
                       'actual child numerator')
                counts['ordered_child_matches']+=1
                ensure(len(child)<len(V),'strictly smaller child')
                if v in V: ensure(ORIGIN in child,'present child root')
                if len(ordered)==4:
                    ensure(PARENT not in child,'first-child type-zero compatibility')
                records.append((W,Wnext,child,v)); W=Wnext
            closed=frozenset(p for p in W0 if not adjacent(ORIGIN,p))
            ensure(W==closed,'all actual neighbors removed')
            for z in activities:
                N=GQ(Q(1)); denominator=GQ(Q(1))
                for before,after,child,v in records:
                    N=N*Z(after,z); denominator=denominator*Z(before,z)
                ensure(Z(V,z)*denominator==Z(W0,z)*(denominator+z*N),'zero-safe recurrence')
                counts['denominator_cleared_recursions']+=1
                if denominator:
                    factor=GQ(Q(1))
                    for before,after,child,v in records: factor=factor*vacancy(child,ORIGIN,z)
                    ensure(Z(V,z)==Z(W0,z)*(1+z*factor),'proper-domain field recursion')
                    counts['proper_denominator_recursions']+=1
                else: counts['zero_factor_cases']+=1
                if z in real_activities:
                    values=[vacancy(V,ORIGIN,z)]+[vacancy(c,ORIGIN,z) for _,_,c,_ in records]
                    for value in values:
                        ensure(value.im==0 and Q(20,71)<=value.re<=1,'actual real box')
                        counts['real_message_boxes']+=1
                    for _,_,c,v in records:
                        if v not in V:
                            ensure(vacancy(c,ORIGIN,z)==GQ(Q(1)),'absent child equals one')
                            counts['absent_child_values']+=1
    # Arbitrary compatible blockers, not just one selected finite presentation.
    masks={frozenset((PARENT,))}; frontier=set(masks)
    for _ in range(3):
        new={memory(F,a,d) for F in frontier for a in range(6) for d in range(3) if DIRS[d] not in F}
        frontier=new-masks; masks|=new
    for F in sorted(masks,key=lambda f:tuple(sorted(f))):
        for raw in D[::37]:
            V=frozenset(raw-F)|frozenset((ORIGIN,))
            ensure(not(V&F),'parent context')
            for a in range(6):
                for d in range(3):
                    if DIRS[d] in V:
                        child=advance(V,a,d); Fnext=memory(F,a,d)
                        ensure(not(child&Fnext) and ORIGIN in child and len(child)<len(V),
                               'compatible actual child')
                        counts['child_context_checks']+=1
    def negative(label,condition): ensure(condition,'negative control not detected: '+label)
    negative('non-adjacency-preserving-bijection',
             polynomial(frozenset(((0,0),(0,1)))) != polynomial(frozenset(((0,0),(1,1)))))
    negative('noninjective-relabeling',
             polynomial(frozenset(((0,0),(0,2)))) != polynomial(frozenset(((0,0),))))
    singleton=frozenset(((0,0),)); moved=frozenset(((1,0),))
    negative('untransported-weight',weighted(singleton,{(0,0):GQ(Q(1))}) !=
             weighted(moved,{(1,0):GQ(Q(2))}))
    path=frozenset(((0,0),(1,0),(2,0))); centered=frozenset(frame(p,0) for p in path)
    negative('untransported-mark',vacancy(path,(1,0),GQ(Q(1))) !=
             vacancy(centered,(1,0),GQ(Q(1))))
    cycle=frozenset(((0,0),(1,0),(0,1),(1,1)))
    negative('delete-all-neighbors-before-each-factor',vacancy(cycle,ORIGIN,GQ(Q(1))) != GQ(Q(1,2)))
    edge=frozenset((ORIGIN,PARENT))
    negative('omit-fourth-root-child',Z(edge,GQ(Q(1))) != Z(edge-frozenset((ORIGIN,)),GQ(Q(1)))*2)
    negative('infer-target-nonzero-from-proper-domains',bool(Z(frozenset(),GQ(Q(-1)))) and
             not Z(singleton,GQ(Q(-1))))
    sigma=lambda n:sum(d for d in range(1,n+1) if n%d==0)
    ensure(Q(sigma(5040),5040)==Q(403,105),'5040 reciprocal divisor sum')
    ensure(Q(sigma(180180),180180)==Q(224,55)>Q(403,105),'eight-factor distinction')
    with localcontext() as ctx:
        ctx.prec=40
        lo=(Decimal(12)/11).ln()/Decimal(11).ln()
        hi=(Decimal(31)/30).ln()/Decimal(2).ln()
        ensure(lo<Decimal(1)/25<hi,'price chamber')
    return {'source_head':'ceb6e285c889669fd4090da55ae26e38f28a60ef',
            'domains':len(D),'compatible_masks_explored':len(masks),**counts,
            'negative_controls_rejected':7,
            'price_interval_decimal':[str(lo),str(hi)],
            'lean_compilation':'not executed','scribe_emission':'not executed',
            'upstream_881_affine_certificate':'reused in Lean source; not rerun here'}


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path)
    args=parser.parse_args()
    result=run()
    root=Path(__file__).resolve().parents[2]
    source_dir=root/'D5/S3/StatisticalMechanics/HardCore'
    names=('PartitionRelabeling','SquareGridCoordinates','SquareGridMessages','SquareGridRootMessages')
    result['new_source_sha256']={name:hashlib.sha256((source_dir/(name+'.lean')).read_bytes()).hexdigest()
                                 for name in names}
    result['verifier_sha256']=hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    text=json.dumps(result,indent=2)+'\n'
    print(text,end='')
    if args.output: args.output.write_text(text)

if __name__=='__main__': main()
