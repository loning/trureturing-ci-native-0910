---
slug: thue-morse-reduced-abelian-odd
bibkey: campbell2025reduced
doi: 10.48550/arXiv.2509.16034
triage: theorem
motivation_gids:
  - D5/S1/Words/Complexity/ThueMorseReducedAbelianOdd
---

# Odd-index reduced abelian complexity of the Thue-Morse word

## Problem

This dossier deliberately anchors only the equality
`rho^{ab,red}_t(2n+1) = rho^{ab,red}_t(n+1)` for every nonnegative integer
`n`, proposed in Section 3 (Conclusion), page 15 of arXiv:2509.16034v1.
The caller-supplied reading, 2026-09-07, quotes its source sentence:

> Although it appears that rho^{ab,red}_t(2n+1) = rho^{ab,red}_t(n+1) for
> nonnegative integers n, the problem of determining a full recursion for
> rho^{ab,red}_t(n) seems to be challenging.

`red(w)` collapses every maximal constant run; reduced abelian complexity
counts all length-`n` factors up to rearrangement of their reduced words
with equal reduced length. The full recursion and the four further open
items in the paragraph, namely the nonzero sign of `rho(4n+2)-rho(4n)`, a
recursion for `rho(4n)`, equation (11), and non-k-automaticity of sequence
(10), are deliberately out of scope.

## Motivation

The frozen motivation module defines factors at every natural start and
counts their reduced Parikh vectors. It provides the exact odd recurrence
needed for this external proposition, making the all-start interpretation
explicit rather than depending on a finite sampled prefix.

## Gap

The caller reports that the paper does not prove this odd equality. Its
formal counterpart is already frozen; the missing item addressed here is
the literature-backed pool entry. No assertion about a full recursion or
any of the other four open items follows from this dossier.

## Route

Use `reducedAbelianComplexity_odd (n : Nat)`. The formal `thueMorse` is
zero-indexed binary digit parity; `factor length start` ranges over every
natural `start`, `runCompress` uses `List.destutter`, and `R length` counts
the resulting reduced Parikh classes. Equal Parikh vectors force equal
reduced length and identical character multiplicities, matching the paper's
equivalence relation according to the caller's reading.

The frozen proof transfers a bijection on reduced class codes back to these
all-start Parikh classes. No prefix-only count is substituted. The
`R (2^k+1) = 3` corollary is supporting evidence only; the sole problem
anchor remains the odd recurrence. Claim binding is a later Scribe layer.

## Falsifier

A nonnegative `n` for which the two exact all-start reduced complexity
counts differ would refute the proposition. A discrepancy in a finite
sample of starting positions is insufficient without a proof that the
sample exhausts every reduced class at both lengths. No fresh numerical
search or exhaustive factor computation was performed here.

## Evidence

- Frozen module: `D5/S1/Words/Complexity/ThueMorseReducedAbelianOdd.lean`.
- Public theorem: `reducedAbelianComplexity_odd`, stating
  `R (2*n+1) = R (n+1)` for every natural `n`.
- Companion public theorem: `reducedAbelianComplexity_two_pow_add_one`,
  stating `R (2^k+1) = 3`; it is not another anchored open problem.
- Machine-checkable frozen-state receipt:
  `Golden/Frozen/state/D5/S1/Words/Complexity/ThueMorseReducedAbelianOdd.lean.json`.
  The worker's `test -f` exited 0 on 2026-09-07.
- Literature reading and locators: `Library/Words/campbell2025reduced.md`.
  Theory candidates 6.223 and 6.224 supply provenance context only.

## Triage

`theorem`. The exact odd recurrence for the all-start definition has a frozen
kernel-verified proof, subject to the source correspondence limitation below.
This classification neither covers the paper's other open items nor binds a
resolution claim.

## ASSUMED-UNVERIFIED

- No repository machine verifies that the Lean statement is equivalent to the
  paper's natural-language proposition. The caller-supplied comparison of
  the all-start definitions, 2026-09-07, is a human reading, not a proof of
  equivalence between the source text and Lean.
- The theory volume's printed venue string, *INTEGERS* 26 (2026), A34, was
  not independently verified by the caller or this worker. The Library
  note binds the verified arXiv DOI and metadata.
- The API, DOI redirect, PDF, and report that the equality is unproved in
  the paper are caller-supplied. This worker did not fetch those sources
  again or rebuild Lean; frozen-state existence was checked locally.
- No literature search for a later resolution of the conjecture was performed;
  the open status recorded in the problem candidate is the status stated in
  this arXiv version, not an assessment of the subsequent literature.
