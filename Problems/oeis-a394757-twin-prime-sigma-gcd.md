---
slug: oeis-a394757-twin-prime-sigma-gcd
bibkey: oeis2026a394757
doi: null
url: https://oeis.org/A394757
triage: theorem
motivation_gids:
  - D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility
---

# Divisibility of the A394757 terms

## Problem

OEIS A394757 lists the centers `k` of twin-prime pairs for which the greatest
common divisor of `k` and the sum-of-divisors function `sigma(k)` is prime. The
entry states that every such term is divisible by 18.

## Motivation

This is the first-tier recent OEIS conjecture selected in the implementation
brief. The target module proves the assertion for every natural-number center.

## Gap

The supplied source search reports no independent published proof. The missing
argument is the obstruction when exactly one factor of 3 divides an even k.

## Route

The Lean theorem proves the universal statement. The neighboring primes force
`2 | k`; after the explicit small case `k = 4`, they force `3 | k`. Assuming
`9` does not divide `k`, multiplicativity of sigma gives either `4 | gcd(k,
sigma(k))` when `4 | k`, or `6 | gcd(k, sigma(k))` when `4` does not divide `k`.
Either case contradicts primality of that gcd.

## Falsifier

A natural k greater than 1 with prime k-1, k+1 and gcd(k, sigma(k)), but
with 18 not dividing k, would contradict the assertion.

## Evidence

- Lean module: `D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.lean`.
- Public theorem: `sigma_gcd_divisibility`.
- The finite computations in the request are supporting checks only; the
  theorem is quantified over all natural numbers.

## Triage

`theorem`. The formal proof closes the universal assertion recorded by OEIS.

## ASSUMED-UNVERIFIED

The definition and quoted assertion are supplied by the orchestrator's OEIS
reading. The search of public indexes found no independent proof, but did not
cover private MathSciNet or zbMATH indexes exhaustively. First-publication
priority and the source-to-Lean identification are not kernel-checked facts.
