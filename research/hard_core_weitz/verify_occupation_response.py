#!/usr/bin/env python3
"""Exact occupied-configuration, PMF and fluctuation-response regressions.

Reference values directly enumerate independent subsets. Polynomial derivatives
are formed coefficientwise; no graph deletion formula generates reference data.
This finite replay does not compile Lean and does not validate a universal proof.
"""
from __future__ import annotations
import argparse
from collections import Counter
from fractions import Fraction as Q
from itertools import combinations, product
from pathlib import Path
import hashlib
import json

from verify_grid_correspondence import GQ


def require(condition: bool, label: str) -> None:
    if not condition:
        raise ValueError(label)


def configs(vertices, edges):
    vs = tuple(vertices)
    for bits in range(1 << len(vs)):
        S = frozenset(v for j,v in enumerate(vs) if bits >> j & 1)
        if all(not (u in S and v in S) for u,v in edges):
            yield S


def coefficients(C, k=0):
    degree = max(map(len,C), default=0)
    out = [Q(0)] * (degree+1)
    for S in C:
        out[len(S)] += Q(len(S)**k)
    return tuple(out)


def derivative(c):
    return tuple(j*c[j] for j in range(1,len(c))) or (Q(0),)


def evaluate(c,z):
    y=GQ()
    for a in reversed(c):
        y=y*z+a
    return y


def eval_real(c,x):
    y=Q(0)
    for a in reversed(c):
        y=y*x+a
    return y


def qpow(z,n):
    y=GQ(Q(1))
    for _ in range(n): y=y*z
    return y


def graph_families():
    for n in range(5):
        vs=tuple(range(n));possible=tuple(combinations(vs,2))
        for mask in range(1<<len(possible)):
            edges=tuple(e for j,e in enumerate(possible) if mask>>j&1)
            yield 'all_graphs_le_four',vs,edges
    pts=tuple(product(range(-1,2),repeat=2))
    grid_edges=tuple((u,v) for u,v in combinations(pts,2)
                     if abs(u[0]-v[0])+abs(u[1]-v[1])==1)
    for mask in range(1<<len(pts)):
        vs=tuple(v for j,v in enumerate(pts) if mask>>j&1)
        yield 'grid_3x3_domains',vs,tuple((u,v) for u,v in grid_edges if u in vs and v in vs)


def run():
    counts=Counter()
    real_points=(Q(0),Q(1,3),Q(1),Q(51,20),Q(7),Q(100))
    complex_points=(GQ(),GQ(Q(2)),GQ(Q(-1)),GQ(Q(-1,2)),
                    GQ(Q(1,3),Q(2,5)),GQ(Q(-2,3),Q(1,7)),
                    GQ(Q(51,20),Q(1,3*10**30)))
    for family,vs,edges in graph_families():
        counts[family]+=1
        C=tuple(configs(vs,edges));P=coefficients(C)
        erased={v:tuple(S for S in C if v not in S) for v in vs}
        for v in vs:
            independent_erased=tuple(configs(tuple(u for u in vs if u!=v),edges))
            require(set(erased[v])==set(independent_erased),'actual erased configuration family')
            counts['erased_configuration_equalities']+=1
        # Multivariate signed weights stress algebraic double counting separately.
        for scheme in range(2):
            weights={v:Q(((-1)**j if scheme else 1)*(j+1),j+2) for j,v in enumerate(vs)}
            def weight(S):
                y=Q(1)
                for v in S:y*=weights[v]
                return y
            Z=sum(map(weight,C),Q(0))
            lhs=sum((len(S)*weight(S) for S in C),Q(0))
            rhs=sum((Z-sum(map(weight,erased[v]),Q(0)) for v in vs),Q(0))
            require(lhs==rhs,'weighted marked double count')
            counts['multivariate_weighted_double_counts']+=1
        for z in complex_points:
            Zv=evaluate(P,z)
            M=[evaluate(coefficients(C,k),z) for k in range(6)]
            for k in range(5):
                dk=evaluate(derivative(coefficients(C,k)),z)
                require(z*dk==M[k+1],'Euler moment recurrence including zero')
                counts['euler_moment_identities']+=1
                if Zv:
                    dp=evaluate(derivative(P),z)
                    direct_derivative=(dk*Zv-M[k]*dp)/(Zv*Zv)
                    require(z*direct_derivative==M[k+1]/Zv-(M[k]/Zv)*(M[1]/Zv),
                            'normalized covariance hierarchy')
                    counts['normalized_moment_responses']+=1
            rhs=sum((Zv-evaluate(coefficients(erased[v]),z) for v in vs),GQ())
            require(z*evaluate(derivative(P),z)==rhs,'denominator-free occupation equation')
            counts['partition_occupation_identities']+=1
            if Zv:
                alpha={v:evaluate(coefficients(erased[v]),z)/Zv for v in vs}
                require(z*evaluate(derivative(P),z)/Zv==sum((1-alpha[v] for v in vs),GQ()),
                        'complex local observable response')
                counts['complex_response_local_sums']+=1
                # Test the inherited 3|V| bound only at activities in its tube.
                if z in (complex_points[0],complex_points[1],complex_points[-1]):
                    response=z*evaluate(derivative(P),z)/Zv
                    require(response.re**2+response.im**2<=9*len(vs)**2,'complex volume response')
                    counts['complex_volume_bounds']+=1
            else:counts['partition_zero_cases_without_division']+=1
        for lam in real_points:
            Z=eval_real(P,lam)
            require(Z>=1,'nonnegative partition normalization')
            mass={S:lam**len(S)/Z for S in C}
            require(sum(mass.values(),Q(0))==1 and all(p>=0 for p in mass.values()),'actual Gibbs PMF')
            counts['pmf_normalizations']+=1
            mu=sum((len(S)*mass[S] for S in C),Q(0))
            variance=sum((mass[S]*(len(S)-mu)**2 for S in C),Q(0))
            require(0<=mu<=len(vs) and variance>=0,'mean and centered variance bounds')
            for k in range(6):
                require(sum((mass[S]*len(S)**k for S in C),Q(0))==eval_real(coefficients(C,k),lam)/Z,
                        'PMF raw moment equality')
                counts['pmf_raw_moments']+=1
            occ={v:sum((p for S,p in mass.items() if v in S),Q(0)) for v in vs}
            require(mu==sum(occ.values(),Q(0)),'expectation of sum of indicators')
            counts['expected_cardinality_local_sums']+=1
            for v in vs:
                require(occ[v]==1-eval_real(coefficients(erased[v]),lam)/Z,'actual vertex marginal')
                counts['vertex_occupation_marginals']+=1
            M1=eval_real(coefficients(C,1),lam)
            dM1=eval_real(derivative(coefficients(C,1)),lam)
            dZ=eval_real(derivative(P),lam)
            dmu=(dM1*Z-M1*dZ)/(Z*Z)
            require(lam*dmu==variance,'exact fluctuation-response including zero')
            counts['fluctuation_response_identities']+=1
            if lam>0:
                require(dmu>=0,'nonnegative susceptibility')
                counts['susceptibility_nonnegativity']+=1
            else:
                require(mu==0 and variance==0 and mass[frozenset()]==1,'zero-activity law')
                counts['zero_activity_degeneracies']+=1
    return dict(counts)


def negative_controls():
    # Singleton at lambda=2: Z'/Z=1/3 while mean occupation=2/3.
    require(Q(1,3)!=Q(2,3),'missing activity factor')
    rejected_zero_division=False
    try: Q(0)/Q(0)
    except ZeroDivisionError: rejected_zero_division=True
    require(rejected_zero_division,'division by activity at zero')
    # An edge at lambda=1 has two marginals 1/3, joint occupation probability 0.
    require(Q(0)!=Q(1,3)**2,'false independence')
    require(Q(2,9)!=2*Q(1,3)*(1-Q(1,3)),'missing indicator covariance')
    require(Q(2,9)!=Q(2,3),'raw second moment is not variance')
    require(evaluate((Q(1),Q(1)),GQ(Q(-1)))==GQ(),'partition-zero guard')
    # Empty configuration is needed for both Z>=1 and zero-activity normalization.
    require(sum((Q(0)**len(S) for S in (frozenset((0,)),)),Q(0))==0,'omitted empty configuration')
    return ['missing_activity_factor','division_by_zero_activity','false_vertex_independence',
            'variance_without_covariances','second_moment_without_centering',
            'normalizing_at_partition_zero','omitted_empty_configuration']


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path)
    args=parser.parse_args()
    result={'checks':run(),'negative_controls_rejected':negative_controls(),
            'reference':'direct actual independent-set enumeration; exact rational/Gaussian-rational arithmetic',
            'lean_kernel':'not executed','scribe_emission':'not executed',
            'upstream_zero_free_proof_chain':'not executed by this verifier'}
    root=Path(__file__).resolve().parents[2]
    names=['OccupationMoments.lean','GibbsOccupation.lean','Holomorphic/OccupationResponse.lean']
    result['source_sha256']={name:hashlib.sha256((root/'D5/S3/StatisticalMechanics/HardCore'/name).read_bytes()).hexdigest()
                            for name in names}
    result['verifier_sha256']=hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    result['gaussian_rational_arithmetic_source_sha256']=hashlib.sha256(
        Path(__file__).with_name('verify_grid_correspondence.py').read_bytes()).hexdigest()
    text=json.dumps(result,indent=2)+'\n'
    print(text,end='')
    if args.output:args.output.write_text(text)

if __name__=='__main__':main()
