---
slug: oeis-a385590-alternating-binomial
bibkey: schulte2025a385590
doi: null
url: https://oeis.org/A385590
triage: theorem
motivation_gids:
  - D5/S1/Recurrence/FibAlternatingSum
---

## Problem

The single statement considered here is the formula-field conjecture in
Werner Schulte's OEIS A385590, dated 2025-07-03. For every integer n >= 1,
let i > 1 be the unique index with F(i) <= n < F(i+1), with F(0)=0 and F(1)=1.
Put T(n,k) = F(i-1)^2 + 1 - ((i-1) mod 2) + (n-F(i))*F(i-2)
+ (k-1)*F(i-1). Is the sum from k=1 to n of
(-1)^k * binomial(n-1,k-1) * T(n,k) equal to (-1)^n when n<3,
and zero otherwise? All triangle values and the sum are integers.
The entry's separate permutation conjecture is outside this question.

## Motivation

D5/S1/Recurrence/FibAlternatingSum establishes a parity-descending Fibonacci
sum. This question concerns a different alternating operation on a triangle
whose rows are selected by Fibonacci intervals.

## Gap

The parity-descending sum does not give the binomial transform of this triangle.
The OEIS formula field still labels this identity Conjecture on 2026-09-08.

## Route

Fix the row, write T(n,k)=A+(k-1)B, and cancel the constant and linear
moments of the alternating binomial coefficients for n>=3. Evaluate the
two boundary rows separately. The Fibonacci inverse must agree with the
source's unique interval index.

## Falsifier

A positive n with a different exact integer sum would contradict this
statement. A counterexample to the permutation conjecture would not.

## Evidence

The caller evaluated n=1 through 12 and obtained -1, 1, and then zeros.
These finite observations motivate the question and do not prove it.
The worker retrieved https://oeis.org/A385590/internal on 2026-09-08
and checked the formula, author, date, and triangle definition directly.

## Triage

Theorem: the required statement quantifies over every positive row, and
the affine binomial transform offers a symbolic proof route.

## ASSUMED-UNVERIFIED

The source-to-formal-statement correspondence is checked by reading.
Public-index searches have not established the absence of every earlier
proof; the search limitations are recorded in the linked Library note.
No DOI is supplied by the OEIS entry; its stable entry URL is used.
