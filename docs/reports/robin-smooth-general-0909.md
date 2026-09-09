# Finite-prime smooth Robin attempt (2026-09-09)

Provenance: no skill invoked; Codex implementation worker, one source of
judgment, no independent review or consensus claimed. The caller supplied the
consensus-rnd/sshx implementation artifact contract. LANE #6160. User scope:
bind-only first, stop on success, no deposit/cover/freeze, PR without auto-merge.

## Preregistered Scope

Baseline: `1faf06c8bf58b7221f4cd8b35210705064761e4e`, equal to the local
`origin/dev` at the first reading. Working branch:
`lane/math/robin-smooth-general-0909`. The initial tree was clean.
Read both tracked brief notes and all 764 lines of `CLAUDE.md`, then
`agents/CONTEXT.md`. There is no ATOM_ID in this task; the note's show-atom
instruction therefore has no supplied atom to resolve. The user statement is
the mathematical target, not the topic of the worktree's older name.

Target: for every finite set P of natural primes, every positive n whose prime
divisors belong to P, and C(P) = product over P of p/(p-1), prove
C(P)/exp(gamma) < log(log(n)) implies sigma_1(n)/n < exp(gamma)*log(log(n)).
No restriction on the number of primes or their exponents is permitted.

First attempt: only pinned Mathlib instantiation, frozen public projections,
and normalization, including `sq_nonneg` and `linarith only` if needed.
Success triggers user stop rule 1: report bind-only and retain no D5 module.
Other preregistered stops: enumeration proved necessary, an actual
above-threshold Robin counterexample, or weakening P to force compilation.

If direct binding fails, the proposed candidate escape is the strict
prime-support product estimate obtained from sigma multiplicativity and the
geometric remainder. It is not presumed to be content: Mathlib product-order
and geometric-sum facts must first be tested as a complete binding proof.

## First Search Receipt

Pinned Lean and Mathlib: v4.33.0; Mathlib commit
`db584cd6d46c92f209a44c0f1c829460d327499d` (lake-manifest.json).
`git ls-tree origin/dev --name-only D5/S3/` confirms the existing Arith domain.
Read all three existing Robin modules: SevenSmooth, PaddingRatio, PaddingTailMass.
Also read GronwallUpperEnvelope and inspected the objective-factorization,
GronwallLowerEnvelope, RobinExponentSwap, and RobinRationalBasis candidates.

Repository searches (literal candidates, not semantic absence proofs):

- `rg -l 'ArithmeticFunction\.sigma|robin_|reciprocalGeomSum' D5 -g '*.lean'`
  returned 14 files, including Gronwall upper/lower envelopes and SevenSmooth.
- `rg -n '\b(sigma|robin|Robin)\b' D5/S3/Arith/Robin/SevenSmooth.lean --stats`
  returned 17 matches on 17 lines. This positive control exercises the same
  word-boundary and alternation features as the broader search.
- Searching sigma/prod/lt/le combinations in pinned Mathlib NumberTheory hit
  its multiplicative factorization and the crude sigma_le_pow_succ bound;
  no exact finite-prime Robin theorem was found in that searched scope.
- Online Loogle query `ArithmeticFunction.sigma` succeeded and returned 31
  declarations. Search capability is available. This online index is not a
  substitute for checking the pinned source and elaborating against it.

Pinned Mathlib hits, to reuse rather than reprove:

- `ArithmeticFunction.isMultiplicative_sigma` and
  `ArithmeticFunction.sigma_eq_prod_primeFactors_sum_range_factorization_pow_mul`
  (ArithmeticFunction/Misc.lean:202,206).
- `ArithmeticFunction.sigma_one_apply_prime_pow` (same file:171).
- `Nat.prod_primeFactors_pow_factorization` (Factorization/Basic.lean:483).
- `Nat.mem_primeFactors`, `Nat.nonempty_primeFactors` (PrimeFin.lean:41,90).
- `geom_sum_eq` (Algebra/Field/GeomSum.lean:43).
- `Finset.prod_le_prod`, `Finset.prod_lt_prod_of_nonempty`, and
  `Finset.prod_le_prod_of_subset_of_one_le` (ordered big operators).
- `geom_sum_lt` was found but is in the canonically ordered semifield section:
  it does not directly instantiate at Real. The field formula plus order
  normalization remains an available binding route.

Frozen interface actually read:
`D5/S3/Arith/Robin/SevenSmooth.robin_seven_smooth`, module statement_id
`sha256:fbe79d554d7a04b6283b456ed63a4042bc51a9414cad8429ee3b7803189b1a52`.
Scope: products of powers of 2,3,5,7 above 5040. Its auxiliary product bound
and logarithmic certificates are private, so they are not frozen public
projections available to the general theorem. GronwallUpperEnvelope.sigma_split
has an additional exponential error and an initial-prime-segment product;
its public statement is not the requested arbitrary-P estimate.

## Degenerate Points: Initial Check

- At n=1 and P empty, sigma_1(n)/n = 1 = C(P). Thus the brief's auxiliary
  strict bound, read without a nondegeneracy condition, is false. This is not
  a counterexample to the main implication: C(P)/exp(gamma)>0 while Lean's
  log(log(1))=log(0)=0, so its threshold premise fails.
- For n>1 the prime-factor set is nonempty. Each prime-power ratio is strictly
  below p/(p-1); multiplying over the nonempty support preserves strictness.
- A prime in P outside the support contributes p/(p-1)>1, so enlarging the
  support product to P raises the bound, not lowers it.
- For positive natural n at most e, n is 1 or 2. At n=1 the totalized loglog
  is zero; at n=2 it is negative. The positive threshold excludes both.
  The probe will formally derive n>e from the original hypotheses instead of
  silently adding it as a stronger assumption.
- P empty and n positive and smooth forces n=1, again excluded by the threshold.

## Status

No target Lean proof has yet been checked. No production declaration, new
module, admission basis, or escape witness is claimed. Numerical witnesses,
the seven-smooth tail instantiation, and axiom checks are pending. No exhaustive
search, mathematical novelty, or implication concerning RH is claimed.
Independent review and pages not actually opened are unverified.

Incidental command accounting: querying the nonexistent optional
Evidence/D5/S3/Arith/Robin directory exited 1; searching for nested AGENTS.md or
CLAUDE.md in D5/Blueprint/Evidence/tools returned 0 matches (rg exit 1).
Neither is treated as evidence that a theorem is absent.
