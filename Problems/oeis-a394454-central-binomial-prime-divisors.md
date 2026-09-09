---
slug: oeis-a394454-central-binomial-prime-divisors
bibkey: oeis2026a394454
doi: null
url: https://oeis.org/A394454
triage: window
motivation_gids: []
---

# Prime divisors of central binomial coefficients

## Problem

OEIS A394454, "Sum of distinct prime divisors of C(2*n, n)", records:
"Conjecture: for every prime p, the set {n >= 1 : p divides C(2*n, n)} is infinite."
The target is exactly `{n : Nat | 0 < n and p divides Nat.choose (2*n) n}.Infinite`
under the sole hypothesis that `p` is prime.

## Motivation

The implementation brief of September 9, 2026 nominates this as a first-tier
OEIS comment conjecture. Its mathematical novelty is not claimed: the proposed
argument is a direct corollary of Kummer's carry criterion.

## Gap

The first required test is bind-only reconstruction from pinned Mathlib and
frozen projections. A successful reconstruction ends this lane without a new
Lean module or freeze. This test is pending at this checkpoint.

## Route

The proposed family is `n = (p-1)*p^k`. The preregistered candidate escape
witness is its remainder at `p^(k+1)` together with the non-strict carry bound.
This is a proposal, not an accepted classification. Existing central-binomial
divisibility results and the Catalan identity will be checked first.

## Falsifier

A prime for which the displayed set is finite would refute the target.
The requested sanity checks are `C(4,2)=6` divisible by three and `C(2,1)=2`
not divisible by three. Their independent kernel checks are pending.

## Evidence

Source baseline: `d527e3081957dbd440ca634d821e98b868abf534`, verified by
`git rev-parse HEAD`. The worktree was initially clean. `CLAUDE.md`, both
agent brief notes, and `agents/CONTEXT.md` were read. The three named nearby
Lean templates and PR 6575's complete file list and body were read.

Initial repository search:
`rg -n -i 'central.?binom|A394454|factorization_choose|emultiplicity_choose'
D5 Meta/Digestion Library Problems --glob '*.lean' --glob '*.md' --glob '*.yaml'`
returned two lines, both in `ShankarQStieltjesRefutation.lean`; these use
Catalan identities and do not state prime-divisor infinitude. Broader `lucas`
searches mostly matched Fibonacci-Lucas material and do not establish coverage.
The existing `Factorization` domain was confirmed with
`git ls-tree origin/dev --name-only D5/S3/`.

Environment discrepancy: the brief says cache ensure was done, but the worker
observed no `.lake` directory. `make lean-cache-ensure` was started before any
Lean command. The toolchain is Lean 4.33.0; Mathlib is pinned to
`db584cd6d46c92f209a44c0f1c829460d327499d`.

## Triage

Investigation in progress. No theorem is claimed proved at this checkpoint.
No direct frozen dependency has been selected. No atom ID was supplied, so
`show-atom` and atom coverage are not applicable to this explicit OEIS target.

Provenance: Codex implementation worker in the runner's `consensus-rnd:sshx`
implementation stage, using the `lean4` skill. One worker performs the reads,
proof checking, and report writing; no independent review or model diversity
is claimed. The orchestrator's numerical readings are supplied evidence and
are not reported as this worker's measurements.

## ASSUMED-UNVERIFIED

The OEIS page and targeted literature search have not yet been independently
opened. First-publication priority, exhaustive absence of a published proof,
and novelty are not claimed. Neither the consequent about the sequence's
limsup nor any relationship to a larger open problem is currently formalized.
