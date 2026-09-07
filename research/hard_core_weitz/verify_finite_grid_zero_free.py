#!/usr/bin/env python3
"""Exact finite regressions for the actual-grid strong-induction endpoint.

The independent-set enumerator is reused from verify_grid_correspondence.py.
Reference partitions enumerate configurations and never use the graph recursion
under test. These bounded tests do not prove a universal zero-free region and
do not compile Lean. No cached verdict or numerical eigenvalue is consumed.
"""
from __future__ import annotations
import argparse
from fractions import Fraction as Q
from pathlib import Path
import hashlib
import json

from verify_grid_correspondence import (
    GQ, Z, advance, domains, frame, memory, polynomial,
    root_domain, vacancy, DIRS, ROOT_DIRS,
    ORIGIN, PARENT, ensure,
)

EPSILON = Q(1, 10**30)


def norm_sq(z: GQ) -> Q:
    return z.re * z.re + z.im * z.im


def activities() -> tuple[GQ, ...]:
    offsets = (GQ(), GQ(EPSILON/2), GQ(-EPSILON/2),
               GQ(Q(0), EPSILON/2), GQ(Q(0), -EPSILON/2),
               GQ(EPSILON/3, EPSILON/3), GQ(-EPSILON/3, EPSILON/3))
    for offset in offsets:
        ensure(norm_sq(offset) < EPSILON**2, 'activity tube membership')
    return tuple(GQ(lam) + offset for lam in (Q(0), Q(1), Q(51, 20)) for offset in offsets)


def main_checks() -> dict:
    D = domains()
    points = activities()
    counts = dict(partition_lower_bounds=0, marked_vacancy_bounds=0,
                  root_increment_halfplanes=0, four_child_reconstructions=0,
                  proper_domain_measures=0, present_first_child_contexts=0,
                  missing_first_child_units=0, internal_child_contexts=0,
                  internal_reconstructions=0, typed_absence_units=0)
    # Every finite 3x3 domain and every marked vertex, with exact complex offsets.
    for V in D:
        for z in points:
            value = Z(V, z)
            ensure(bool(value), 'actual partition nonzero')
            ensure(norm_sq(value) >= Q(1, 4)**len(V), 'volume lower modulus')
            counts['partition_lower_bounds'] += 1
            for v in tuple(V) + ((7, -4),):
                alpha = vacancy(V, v, z)
                ensure(norm_sq(alpha) <= 4, 'actual marked vacancy modulus')
                counts['marked_vacancy_bounds'] += 1
                if v not in V:
                    ensure(alpha == GQ(Q(1)), 'absent marked vertex unit')
                    continue
                W = frozenset((p[0]-v[0], p[1]-v[1]) for p in V)
                ensure(len(W) == len(V) and polynomial(W) == polynomial(V), 'centered actual domain')
                lower = W - frozenset((ORIGIN,))
                ensure(len(lower) < len(W), 'strict root erasure')
                counts['proper_domain_measures'] += 1
                increment = Z(W, z) / Z(lower, z)
                ensure(increment.re >= Q(1, 2), 'right-half-plane insertion factor')
                counts['root_increment_halfplanes'] += 1
                product = GQ(Q(1))
                for e, direction in enumerate(ROOT_DIRS):
                    child = root_domain(W, e)
                    ensure(len(child) < len(W), 'smaller first-child domain')
                    ensure(PARENT not in child, 'type-zero parent blocker')
                    factor = vacancy(child, ORIGIN, z)
                    if direction in W:
                        ensure(ORIGIN in child, 'present first-child root')
                        counts['present_first_child_contexts'] += 1
                    else:
                        ensure(factor == GQ(Q(1)), 'complex missing first child')
                        counts['missing_first_child_units'] += 1
                    product = product * factor
                ensure(increment == 1+z*product, 'four-child exact reconstruction')
                counts['four_child_reconstructions'] += 1
    # All six orders. This tests only the geometric/ratio step, not the affine
    # certificate for an arbitrary policy. The actual theorem uses its fixed
    # certified type controller via existing Lean dependencies.
    for V in D:
        if ORIGIN not in V or PARENT in V:
            continue
        for a in range(6):
            factors = []
            for d, direction in enumerate(DIRS):
                child = advance(V, a, d)
                F = memory(frozenset((PARENT,)), a, d)
                ensure(not (child & F), 'preserved blocker compatibility')
                ensure(len(child) < len(V), 'strict internal child decrease')
                if direction in V:
                    ensure(ORIGIN in child, 'present internal root')
                counts['internal_child_contexts'] += 1
                factors.append(child)
            for z in points[::3]:
                product = GQ(Q(1))
                for d, child in enumerate(factors):
                    alpha = vacancy(child, ORIGIN, z)
                    if DIRS[d] not in V:
                        ensure(alpha == GQ(Q(1)), 'complex internal missing child')
                        counts['typed_absence_units'] += 1
                    product = product * alpha
                ensure(Z(V, z) == Z(V-frozenset((ORIGIN,)), z)*(1+z*product),
                       'exact internal product recurrence')
                counts['internal_reconstructions'] += 1
    # Exhaustion reaches the empty actual domain; the volume estimate is
    # checked factorwise rather than assuming the desired target partition.
    product_tests = 0
    for V in D:
        for z in points[::7]:
            current = V
            total = GQ(Q(1))
            for v in sorted(V):
                nxt = current - frozenset((v,))
                factor = Z(current, z)/Z(nxt, z)
                ensure(factor.re >= Q(1, 2), 'ordered increment')
                total = total * factor
                current = nxt
            ensure(not current and total == Z(V, z), 'complete telescoping endpoint')
            ensure(norm_sq(total) >= Q(1, 4)**len(V), 'composed volume modulus')
            product_tests += 1
    counts['complete_vertex_eliminations'] = product_tests
    return {'domains': len(D), 'complex_activities': len(points), **counts}


def negative_controls() -> dict:
    singleton = frozenset((ORIGIN,))
    edge = frozenset((ORIGIN, PARENT))
    z = GQ(Q(1))
    # Omitting the west root neighbor produces a wrong graph value.
    wrong = Z(edge-frozenset((ORIGIN,)), z) * 2
    ensure(wrong != Z(edge, z), 'omitted-fourth-direction negative control')
    # All proper domains can be nonzero while the target vanishes outside U.
    ensure(bool(Z(frozenset(), GQ(Q(-1)))) and not Z(singleton, GQ(Q(-1))),
           'noncircular-target guard')
    # At a zero denominator, an absent vertex is not automatically a unit.
    division_rejected = False
    try:
        vacancy(singleton, (9, 9), GQ(Q(-1)))
    except ZeroDivisionError:
        division_rejected = True
    ensure(division_rejected, 'absent-child denominator guard')
    # Removing the root from the deletion list breaks the strict-cardinality measure.
    wrong_child = frozenset(frame(p, 0) for p in edge)
    ensure(len(wrong_child) >= len(edge), 'missing-root deletion measure')
    # Reusing the same undeleted sibling context gives the wrong product on C4.
    cycle = frozenset(((0,0), (1,0), (1,1), (0,1)))
    V0 = cycle-frozenset((ORIGIN,))
    naive = GQ(Q(1))
    for d in ((1,0), (0,1)):
        naive = naive * vacancy(V0, d, z)
    ensure(Z(V0, z)*(1+z*naive) != Z(cycle, z), 'forgotten sibling-order context')
    return dict(omitted_fourth_root_direction=True, assumed_target_nonvanishing=True,
                absent_child_without_nonzero_denominator=True,
                omitted_root_erasure=True, discarded_ordered_sibling_context=True)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    result = main_checks()
    result['negative_controls'] = negative_controls()
    result['arithmetic'] = 'exact rational and Gaussian-rational configuration enumeration'
    result['upstream_holomorphic_and_affine_proof_terms'] = 'not executed by this verifier'
    result['lean_kernel'] = 'not executed'
    result['scribe_emission'] = 'not executed'
    root = Path(__file__).resolve().parents[2]
    names = ('ActualGraphLift', 'FiniteGridZeroFree')
    result['source_sha256'] = {
        name: hashlib.sha256((root/f'D5/S3/StatisticalMechanics/HardCore/Holomorphic/{name}.lean').read_bytes()).hexdigest()
        for name in names
    }
    result['enumerator_sha256'] = hashlib.sha256((Path(__file__).parent/'verify_grid_correspondence.py').read_bytes()).hexdigest()
    result['verifier_sha256'] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    text = json.dumps(result, indent=2)+'\n'
    print(text, end='')
    if args.output:
        args.output.write_text(text)

if __name__ == '__main__':
    main()
