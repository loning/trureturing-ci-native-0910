#!/usr/bin/env python3
"""Reconstruct geometry and certify full-box affine contraction using exact rationals.

Inputs are the two Lean-owned literal payloads. No optimizer, sampled verdict,
precomputed edge list, coefficient-class quotient or prior JSON is trusted.
"""
from __future__ import annotations
import argparse
import hashlib
import itertools
import json
import math
import random
import re
from collections import Counter
from fractions import Fraction as Q
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BUCKET = ROOT / 'D5/S3/StatisticalMechanics/HardCore'
GEOMETRY = BUCKET / 'AdaptiveRadiusFourData.lean'
MESSAGES = BUCKET / 'AdaptiveAffineMessageData.lean'
L, CAP, GAMMA, MARGIN = Q(20, 71), Q(51, 20), Q(999, 1000), Q(3, 1000)
POINTS = [(x, y) for x in range(-4, 5) for y in range(-4, 5) if abs(x)+abs(y) <= 4]
DIRS = [(1, 0), (0, -1), (0, 1)]
ORDERS = list(itertools.permutations(range(3)))


def check(ok: bool, why: str) -> None:
    if not ok:
        raise ValueError(why)


def literal(text: str, name: str) -> str:
    return text.split('private def '+name, 1)[1].split(':= [', 1)[1].split(']', 1)[0]


def load() -> tuple[list[tuple[int, int, int]], list[tuple[Q, Q]], list[int]]:
    g, m = GEOMETRY.read_text(), MESSAGES.read_text()
    weights = list(map(int, re.findall(r'\d+', literal(g, 'weights'))))
    codes = list(map(int, re.findall(r'\d+', literal(g, 'increments'))))
    rows, previous = [], 0
    for c in codes:
        previous += c // 1116
        wi, action = (c % 1116) // 6, c % 6
        check(wi < len(weights), 'weight index')
        rows.append((previous, weights[wi], action))
    coefficients = [(Q(int(a), 10**6), Q(int(b), 10**6)) for a, b in
                    re.findall(r'\((\d+),\s*(\d+)\)', literal(m, 'coefficients'))]
    assignments = list(map(int, re.findall(r'\d+', literal(m, 'assignments'))))
    check(len(assignments) == len(rows), 'assignment length')
    check(all(c//28 < len(coefficients) for c in assignments), 'coefficient index')
    return rows, [coefficients[c//28] for c in assignments], [c%28 for c in assignments]


def move(p: tuple[int, int], d: int) -> tuple[int, int]:
    x, y = p
    return ((x-1, y), (-y-1, x), (y-1, -x))[d]


def geometry(rows: list[tuple[int, int, int]], omit_origin: bool = False) -> list[list[int | None]]:
    check(len(rows) == 881, 'state count')
    codes = [r[0] for r in rows]
    check(codes == sorted(set(codes)) and codes[0] == 4096, 'distinct sorted masks/root')
    check(all(0 <= c < 2**41 for c in codes), 'mask range')
    masks = [frozenset(p for k, p in enumerate(POINTS) if c >> k & 1) for c in codes]
    check(all((-1, 0) in f and (0, 0) not in f for f in masks), 'parent/origin')
    lookup = {f:i for i, f in enumerate(masks)}
    edges = []
    for i, (f, (_, w, action)) in enumerate(zip(masks, rows)):
        check(0 <= action < 6 and 1 <= w <= 100000, f'range {i}')
        children = []
        for d, destination in enumerate(DIRS):
            if destination in f:
                children.append(None)
                continue
            kill = {DIRS[e] for e in ORDERS[action][:ORDERS[action].index(d)]}
            if not omit_origin:
                kill.add((0, 0))
            nxt = frozenset(q for q in (move(p, d) for p in f | kill)
                            if abs(q[0])+abs(q[1]) <= 4)
            check(nxt in lookup, f'geometric successor {i},{d}')
            children.append(lookup[nxt])
        edges.append(children)
    check(rows[0][1] == 100000, 'initial potential')
    for i, children in enumerate(edges):
        check(2500*sum(rows[j][1] for j in children if j is not None) <= 6202*rows[i][1],
              f'growth row {i}')
    reached, todo = {0}, [0]
    while todo:
        i = todo.pop()
        for j in edges[i]:
            if j is not None and j not in reached:
                reached.add(j)
                todo.append(j)
    check(len(reached) == len(rows), 'unreachable stored state')
    return edges


def child_coefficients(coefficients: list[tuple[Q, Q]], children: list[int | None]) -> tuple[list[Q], list[Q]]:
    pairs = [coefficients[j] if j is not None else (Q(0), Q(0)) for j in children]
    return [p[0] for p in pairs], [p[1] for p in pairs]


def certify(coefficients: list[tuple[Q, Q]], patterns: list[int], edges: list[list[int | None]],
            cap: Q = CAP) -> tuple[Q, Counter]:
    check(len(coefficients) == len(patterns) == len(edges), 'message shape')
    gaps, modes = [], Counter()
    for i, ((ap, bp), pattern, children) in enumerate(zip(coefficients, patterns, edges)):
        check(ap >= 0 and bp-ap >= Q(10577, 10**6), f'message positivity {i}')
        a, b = child_coefficients(coefficients, children)
        C, s = sum(b)-GAMMA*bp, GAMMA*(bp-ap)
        check(all(q >= 0 for q in a), f'child slopes {i}')
        if pattern == 27:
            check(C <= L*sum(a), f'nonnegative case {i}')
            gap = s
            modes['nonnegative'] += 1
        else:
            check(0 <= pattern < 27, f'pattern range {i}')
            digit = [(pattern//3**d)%3 for d in range(3)]
            fixed_sum = sum(a[d]*(L if digit[d] == 0 else 1) for d in range(3) if digit[d] != 2)
            t = (C-fixed_sum)/(1+digit.count(2))
            check(t > 0, f'positive level {i}')
            check(all(a[d] != 0 for d in range(3) if digit[d] == 2), f'interior divisor {i}')
            r = [L if k == 0 else Q(1) if k == 1 else t/a[d] for d, k in enumerate(digit)]
            check(all(L <= q <= 1 for q in r), f'clamped box {i}')
            check(C == t+sum(ai*ri for ai, ri in zip(a, r)), f'balance {i}')
            for d, k in enumerate(digit):
                check((k == 0 and t <= a[d]*r[d]) or
                      (k == 1 and a[d]*r[d] <= t) or
                      (k == 2 and a[d]*r[d] == t), f'clamped derivative {i},{d}')
            gap = s-cap*t*math.prod(r)
            modes['clamped'] += 1
        check(gap >= MARGIN, f'global margin {i}: {gap}')
        gaps.append(gap)
    return min(gaps), modes


def regression(coefficients: list[tuple[Q, Q]], edges: list[list[int | None]]) -> int:
    rng = random.Random(20260907)
    tests = 0
    for i, (ap, bp) in enumerate(coefficients):
        a, b = child_coefficients(coefficients, edges[i])
        for kept in range(8):
            # Include zero, intermediate, maximal activity and all pruning patterns.
            for lam in (Q(0), CAP/2, CAP):
                xs = [L+(1-L)*Q(rng.randrange(17),16) if kept >> d & 1 else Q(1) for d in range(3)]
                y = 1/(1+lam*math.prod(xs))
                full = sum(b[d]-a[d]*xs[d] for d in range(3))
                pruned = sum(b[d]-a[d]*xs[d] for d in range(3) if kept >> d & 1)
                psi = bp-ap*y
                F = GAMMA*(bp-ap)+lam*math.prod(xs)*(GAMMA*bp-sum(b)+sum(ai*x for ai,x in zip(a,xs)))
                check(L <= y <= 1 and psi > 0, f'recursion domain {i}')
                check((GAMMA*psi-(1-y)*full)*(1+lam*math.prod(xs)) == F, f'gap identity {i}')
                check(F >= MARGIN and pruned <= full and (1-y)*pruned < GAMMA*psi,
                      f'pruned contraction {i},{kept}')
                tests += 1
    return tests


def negatives(rows, coefficients, patterns, edges) -> dict[str, str]:
    altered = coefficients.copy()
    altered[0] = (altered[0][1], altered[0][1])
    bad_pattern = patterns.copy()
    bad_pattern[0] = 27
    shifted = coefficients[1:]+coefficients[:1]
    tests = {
        'missing-geometric-state': lambda: geometry(rows[:-1]),
        'omit-origin-deletion': lambda: geometry(rows, True),
        'destroy-message-positivity': lambda: certify(altered, patterns, edges),
        'wrong-clamp-pattern': lambda: certify(coefficients, bad_pattern, edges),
        'misalign-geometric-message-types': lambda: certify(shifted, patterns, edges),
        'raise-activity-without-new-certificate': lambda: certify(coefficients, patterns, edges, Q(3)),
    }
    result = {}
    for name, run in tests.items():
        try:
            run()
        except (ValueError, ZeroDivisionError, IndexError) as error:
            result[name] = str(error)
        else:
            raise ValueError('corruption accepted: '+name)
    return result


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    rows, coefficients, patterns = load()
    edges = geometry(rows)
    margin, modes = certify(coefficients, patterns, edges)
    result = {
        'states':len(rows), 'geometric_transitions':3*len(rows), 'growth_rows':len(rows),
        'rational_full_box_rows':len(rows), 'case_counts':dict(modes),
        'activity_interval':['0',str(CAP)], 'probability_interval':[str(L),'1'],
        'contraction_constant':str(GAMMA), 'certified_polynomial_margin':str(MARGIN),
        'minimum_actual_margin':str(margin), 'minimum_actual_margin_decimal':float(margin),
        'minimum_message':str(min(b-a for a,b in coefficients)),
        'rational_pruning_regressions':regression(coefficients, edges),
        'negative_controls':negatives(rows, coefficients, patterns, edges),
        'source_sha256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in (GEOMETRY,MESSAGES)},
        'lean_compilation':'not executed',
        'scope':'Exact full-box row certificates; complex extension and graph transfer are separate paper arguments.'
    }
    text = json.dumps(result,indent=2)+'\n'
    print(text,end='')
    if args.output:
        args.output.write_text(text)

if __name__ == '__main__':
    main()
