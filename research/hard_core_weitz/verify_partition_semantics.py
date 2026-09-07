#!/usr/bin/env python3
"""Exact finite regressions for actual independent-set partition semantics.

All reference values are computed by independent subset enumeration. This does
not execute Lean or certify universal proof terms. No optimizer or saved verdict
is used. Arithmetic is Fraction or Gaussian rational arithmetic from stdlib.
"""
from __future__ import annotations
from dataclasses import dataclass
from fractions import Fraction as Q
from itertools import combinations, permutations
from pathlib import Path
import argparse
import hashlib
import json

@dataclass(frozen=True)
class Gaussian:
    re: Q = Q(0)
    im: Q = Q(0)
    @staticmethod
    def cast(x):
        return x if isinstance(x, Gaussian) else Gaussian(Q(x))
    def __add__(self, other):
        b = self.cast(other)
        return Gaussian(self.re+b.re, self.im+b.im)
    __radd__ = __add__
    def __neg__(self):
        return Gaussian(-self.re, -self.im)
    def __sub__(self, other):
        return self + -self.cast(other)
    def __rsub__(self, other):
        return self.cast(other) + -self
    def __mul__(self, other):
        b = self.cast(other)
        return Gaussian(self.re*b.re-self.im*b.im, self.re*b.im+self.im*b.re)
    __rmul__ = __mul__
    def __truediv__(self, other):
        b = self.cast(other)
        d = b.re*b.re+b.im*b.im
        if d == 0:
            raise ZeroDivisionError('zero Gaussian denominator')
        return Gaussian((self.re*b.re+self.im*b.im)/d, (self.im*b.re-self.re*b.im)/d)
    def __rtruediv__(self, other):
        return self.cast(other)/self
    def is_zero(self):
        return self.re == 0 and self.im == 0


def require(p, message):
    if not p:
        raise ValueError(message)


def subsets(mask):
    s = mask
    while True:
        yield s
        if s == 0:
            break
        s = (s-1) & mask


def vertices(mask):
    while mask:
        b = mask & -mask
        yield b.bit_length()-1
        mask ^= b


def graph(n, code):
    adj = [0]*n
    for k, (u, v) in enumerate(combinations(range(n), 2)):
        if code >> k & 1:
            adj[u] |= 1 << v
            adj[v] |= 1 << u
    return adj


def configurations(adj, V):
    return [s for s in subsets(V) if all(not (adj[v] & s) for v in vertices(s))]


def reference_partitions(adj, weights):
    """Enumerate every independent subset; never invoke deletion recursion."""
    n = len(adj)
    zero = weights[0]*0 if n else Q(0)
    result = {}
    for V in range(1 << n):
        total = zero
        for s in configurations(adj, V):
            weight = zero+1
            for v in vertices(s):
                weight *= weights[v]
            total += weight
        result[V] = total
    return result


def nonzero(x):
    return not x.is_zero() if isinstance(x, Gaussian) else x != 0


def factors(Z, V, order):
    one = Z[0]
    N, D, ratios = one, one, one
    safe = True
    for u in order:
        nxt = V & ~(1 << u)
        N *= Z[nxt]
        D *= Z[V]
        if nonzero(Z[V]):
            ratios *= Z[nxt]/Z[V]
        else:
            safe = False
        V = nxt
    return V, N, D, ratios, safe


def audit(max_n=5):
    counts = dict(graphs=0, weighted_domains=0, configuration_splits=0,
                  deletion_identities=0, ordered_cross_identities=0,
                  proper_domain_recursions=0, repeated_neighbor_orders=0,
                  zero_intermediate_products=0, zero_parent_partitions=0,
                  real_box_checks=0, absent_root_checks=0)
    for n in range(max_n+1):
        for code in range(1 << (n*(n-1)//2)):
            adj = graph(n, code)
            counts['graphs'] += 1
            families = [
                [Q(0)]*n,
                [Q(51,20)]*n,
                [Q((j+code)%6, 3) for j in range(n)],
                [Gaussian(Q(-1))]*n,
                [Gaussian(Q((j%3)-1), Q((j+code)%2)) for j in range(n)],
            ]
            V = (1 << n)-1
            for v in range(n):
                V0 = V & ~(1 << v)
                C = V0 & ~adj[v]
                left = set(configurations(adj,V))
                vacant = set(configurations(adj,V0))
                occupied = {s | (1 << v) for s in configurations(adj,C)}
                require(not (vacant & occupied) and left == vacant | occupied, 'configuration split')
                counts['configuration_splits'] += 1
            for family_index, w in enumerate(families):
                Z = reference_partitions(adj, w)
                counts['weighted_domains'] += len(Z)
                for U in range(1 << n):
                    for v in vertices(U):
                        U0 = U & ~(1 << v)
                        C = U0 & ~adj[v]
                        require(Z[U] == Z[U0]+w[v]*Z[C], 'weighted deletion')
                        counts['deletion_identities'] += 1
                        if family_index < 3:
                            x = Z[U0]/Z[U]
                            require(Q(20,71) <= x <= 1, 'real message box')
                            counts['real_box_checks'] += 1
                    if family_index < 3:
                        require(Z[U]/Z[U] == 1, 'absent-root message')
                        counts['absent_root_checks'] += 1
                for v in range(n):
                    U0 = V & ~(1 << v)
                    C = U0 & ~adj[v]
                    neighbors = tuple(vertices(adj[v]))
                    orders = list(permutations(neighbors))
                    if neighbors:
                        orders.append(neighbors+(neighbors[0],))
                        counts['repeated_neighbor_orders'] += 1
                    proper = all(nonzero(Z[U]) for U in subsets(U0))
                    for order in orders:
                        last, N, D, p, safe = factors(Z, U0, order)
                        require(last == C, 'neighbor deletion domain')
                        require(Z[U0]*N == Z[C]*D, 'telescoping cross')
                        require(Z[V]*D == Z[U0]*(D+w[v]*N), 'ordered cross')
                        counts['ordered_cross_identities'] += 1
                        if not nonzero(D):
                            counts['zero_intermediate_products'] += 1
                        if not nonzero(Z[V]):
                            counts['zero_parent_partitions'] += 1
                        if proper:
                            require(safe and nonzero(D), 'proper denominators')
                            require(Z[V] == Z[U0]*(1+w[v]*p), 'actual ordered recursion')
                            if nonzero(1+w[v]*p):
                                require(nonzero(Z[V]), 'local nonvanishing propagation')
                            counts['proper_domain_recursions'] += 1
    Z = reference_partitions(graph(2,1), [Q(1),Q(1)])
    _, N, D, _, _ = factors(Z,2,())
    require(Z[3]*D != Z[2]*(D+N), 'missing-neighbor corruption survived')
    require(Z[3] != Z[2]+Z[2], 'open/closed-neighborhood corruption survived')
    Z0 = reference_partitions(graph(1,0), [Q(-1)])
    require(Z0[0] == 1 and Z0[1] == 0, 'noncircular root-zero regression')
    counts['negative_controls'] = {
        'omit_a_neighbor':'rejected',
        'use_root_erasure_instead_of_closed_neighborhood':'rejected',
        'infer_root_nonzero_from_proper_domains_alone':'rejected',
    }
    return counts


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--max-n', type=int, default=5, choices=range(1,6))
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    result = audit(args.max_n)
    root = Path(__file__).resolve().parents[2]
    bucket = root/'D5/S3/StatisticalMechanics/HardCore'
    result['source_sha256'] = {name:hashlib.sha256((bucket/name).read_bytes()).hexdigest()
        for name in ('IndependentPartitionDeletion.lean','OrderedPartitionRecursion.lean','RealPartitionMessages.lean')}
    result['arithmetic'] = 'stdlib Fraction and Gaussian rational pairs; exact'
    result['verification_scope'] = 'finite independent implementation; no Lean execution'
    text = json.dumps(result, indent=2, sort_keys=True)+'\n'
    print(text, end='')
    if args.output:
        args.output.write_text(text)

if __name__ == '__main__':
    main()
