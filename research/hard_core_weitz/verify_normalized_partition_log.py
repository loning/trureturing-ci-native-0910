#!/usr/bin/env python3
"""Exact rational products and high-precision principal-log regressions.

Reference partitions enumerate independent subsets in the existing verifier.
Finite cases and high-precision logarithms do not certify universal Lean proofs.
The upstream zero-free and analytic source dependencies are not compiled here.
"""
from __future__ import annotations
import argparse
from fractions import Fraction as Q
import hashlib
import itertools
import json
from pathlib import Path
import random
import mpmath as mp
from verify_grid_correspondence import GQ, Z, polynomial, domains, ensure

EPSILON = Q(1, 10**30)

def M(z: GQ):
    return mp.mpc(mp.mpf(z.re.numerator)/z.re.denominator,
                  mp.mpf(z.im.numerator)/z.im.denominator)

def factor(V, v, z):
    return Z(V,z)/Z(V-frozenset((v,)),z)

def response(V,z):
    c=polynomial(V)
    d=GQ()
    for k in range(len(c)-1,0,-1):
        d=d*z+k*c[k]
    return d/Z(V,z)

def ordered(V,l,z):
    W=V; total=mp.mpc(0); product=GQ(Q(1)); tangent=GQ()
    for v in l:
        nxt=W-frozenset((v,)); f=factor(W,v,z)
        ensure(f.re>=Q(1,2),'actual increment half-plane')
        total+=mp.log(M(f)); product=product*f
        tangent=tangent+response(W,z)-response(nxt,z)
        W=nxt
    return W,total,product,tangent

def run():
    mp.mp.dps=100
    tol=mp.mpf('1e-85')
    rng=random.Random(20260907)
    activities=(GQ(),GQ(Q(1)),GQ(Q(51,20)),
                GQ(Q(0),EPSILON/3),GQ(Q(1),-EPSILON/3),
                GQ(Q(51,20)+EPSILON/3,EPSILON/3))
    counts=dict(domains=0,activities=len(activities),deletion_squares=0,
                partial_list_products=0,complete_orders=0,order_independence=0,
                derivative_telescopes=0,volume_bounds=0,normalizations=0)
    max_square=max_order=max_exp=mp.mpf(0)
    for V in domains():
        counts['domains']+=1
        vertices=sorted(V)
        # Every pairwise ordering in domains of at most four vertices;
        # multiple deterministically shuffled full orders for larger domains.
        if len(vertices)<=4:
            orders=list(itertools.permutations(vertices))
        else:
            orders=[tuple(vertices),tuple(reversed(vertices))]
            for _ in range(2):
                perm=vertices.copy();rng.shuffle(perm);orders.append(tuple(perm))
        for z in activities:
            base=None
            if len(vertices)>=2:
                u,v=vertices[0],vertices[-1]
                Vu=V-frozenset((u,));Vv=V-frozenset((v,))
                a,b,c,d=factor(V,u,z),factor(Vu,v,z),factor(V,v,z),factor(Vv,u,z)
                ensure(a*b==c*d,'exact deletion square product')
                ensure(all(q.re>=Q(1,2) for q in (a,b,c,d)),'four local half-planes')
                error=abs(mp.log(M(a))+mp.log(M(b))-mp.log(M(c))-mp.log(M(d)))
                ensure(error<tol,'branch-correct additive square')
                max_square=max_square if max_square>error else error;counts['deletion_squares']+=1
            partial=vertices[:2]+vertices[:1]+[(17,-11)]
            W,F,P,D=ordered(V,partial,z)
            ensure(P==Z(V,z)/Z(W,z),'partial/repeated/absent telescoping')
            ensure(D==response(V,z)-response(W,z),'partial derivative telescope')
            counts['partial_list_products']+=1
            for l in orders:
                W,F,P,D=ordered(V,l,z)
                ensure(not W and P==Z(V,z),'actual complete product')
                ensure(D==response(V,z),'actual logarithmic derivative')
                exp_error=abs(mp.exp(F)-M(Z(V,z)))
                ensure(exp_error<tol,'exponential recovers actual partition')
                max_exp=max(max_exp,exp_error)
                counts['complete_orders']+=1;counts['derivative_telescopes']+=1
                if base is None:base=F
                else:
                    err=abs(F-base);max_order=max(max_order,err)
                    ensure(err<tol,'complete order equality');counts['order_independence']+=1
                n=len(V)
                ensure(mp.re(F)>=-n*mp.log(2)-tol,'lower real pressure')
                ensure(mp.re(F)<=n*mp.log(4)+tol,'upper real pressure')
                ensure(abs(mp.im(F))<=n*mp.pi/2+tol,'imaginary volume control')
                counts['volume_bounds']+=1
                if not z:
                    ensure(F==0,'zero normalization');counts['normalizations']+=1
    # Large finite isolated-vertex formula shows why Log Z cannot replace
    # the lifted branch, even at an activity inside the tiny common tube.
    n=10**32
    z=mp.j*mp.mpf(1)/(3*10**30)
    lifted=n*mp.log(1+z)
    principal=mp.log(mp.exp(lifted))
    ensure(abs(lifted-principal)>2*mp.pi,'principal-log wrapping negative control')
    # Equal exponentials alone have a 2*pi*i ambiguity.
    ensure(abs(mp.exp(2*mp.pi*mp.j)-1)<tol and abs(2*mp.pi*mp.j)>1,
           'exponential equality is not logarithm equality')
    # Replace successive domains by the same starting domain on an edge.
    edge=frozenset(((0,0),(1,0)))
    zq=GQ(Q(1));naive=factor(edge,(0,0),zq)*factor(edge,(1,0),zq)
    ensure(naive!=Z(edge,zq),'forgotten successive domain negative control')
    return {**counts,'max_square_log_error':mp.nstr(max_square,12),
            'max_order_log_error':mp.nstr(max_order,12),'max_exponential_error':mp.nstr(max_exp,12),
            'precision_digits':mp.mp.dps,'negative_controls_rejected':3,
            'isolated_graph_cardinality':str(n),'isolated_graph_winding_multiple':int(mp.nint(mp.im(lifted-principal)/(2*mp.pi))),
            'reference_arithmetic':'exact rational/Gaussian-rational direct configuration sums',
            'logarithm_checks':'100-digit supplementary numerical regression',
            'lean_kernel':'not executed','scribe_emission':'not executed'}

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path)
    args=parser.parse_args()
    result=run()
    root=Path(__file__).resolve().parents[2]
    directory=root/'D5/S3/StatisticalMechanics/HardCore/Holomorphic'
    result['source_sha256']={p.stem:hashlib.sha256(p.read_bytes()).hexdigest()
        for p in sorted(directory.glob('*.lean')) if p.stem in ('PartitionLogCocycle','NormalizedPartitionLog')}
    result['enumerator_sha256']=hashlib.sha256((Path(__file__).parent/'verify_grid_correspondence.py').read_bytes()).hexdigest()
    result['verifier_sha256']=hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    text=json.dumps(result,indent=2)+'\n';print(text,end='')
    if args.output:args.output.write_text(text)

if __name__=='__main__':main()
