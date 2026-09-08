# Matching Fibers: CMP Equation (2)

skill: consensus-rnd:sshx
producer: one codex-cli implementation worker
independent_review: ASSUMED-UNVERIFIED (zero review seats)

Repository: https://github.com/the-omega-institute/trureturing
Worktree: /Users/auricstudio/trureturing-matching-delete-0908
Branch: lane/math/matching-delete-0908
Base: 45e7b20dd95dd8b2d7b8784392c1814193b80515
Lane: #6160; deep reasoning lane: #6377.
Lean: v4.33.0.
Mathlib: db584cd6d46c92f209a44c0f1c829460d327499d.

## Scope

This is an incremental implementation of the user-supplied monomial-fiber route.
The target is the exact unbounded `MatchingIdentity` from
[matching-sos-0908.md](matching-sos-0908.md). No numerical experiment is a Lean premise.
The orchestrator's verification covers only the numerical readings (star), (A),
(B), (C), and (D) in the brief. All Lean readings here are worker-run.
No independent Lean review is claimed.

Proposed escape witnesses, preregistered by the brief: the subset-fiber
bijection (B), the square-edge/partner and cross-edge/perfect-matching
decomposition (C), and their live use in the full matching identity.

No positivity of H_0(R), complete parity identity, or all-order omission of H_1
is asserted.

## First Requirement: Bind-only Probe

The probe copied the archived definitions and both coefficient theorems before
attempting the exact `MatchingIdentity`. The proof attempt was:

```lean
example : MatchingIdentity := by
  intro n k hk r
  rw [symmetrize_coefficient n k hk]
  simp only [matchingSum]
  linarith only [sq_nonneg
    (∑ M : Matching n k, ∏ e ∈ M.val, edgeSquare r e)]
```

`make lean` exited 2. The coefficient theorems elaborate, each with precisely
`[propext, Classical.choice, Quot.sound]`. At probe line 101 Lean reports
`linarith failed to find a contradiction`. The remaining branch assumes the
signed elementary-coefficient convolution is strictly less than
`(sum M, prod e in M.val, edgeSquare r e) / n.descFactorial k` and asks for
`False`. The supplied square-nonnegativity fact gives no relation identifying
the two sums. No matching/coefficient bridge was found among the searched
frozen or pinned-Mathlib candidates. This is a concrete failure of this
restricted attempt, not a proof of semantic nonexistence under every encoding.

Full byte-for-byte probe: `bind-only-attempt.lean` in the artifact directory.
Log: `bind-only-make-lean.log`.
Build command: `/usr/bin/time -l make lean`.
Readings: EXIT 2; 12585 jobs; 110.73 seconds; maximum resident set size
4400988160 bytes. The temporary probe was removed before the delivered build.

## Progress

Step 1 is verified: the `Matching`, finite instance, `edgeSquare`,
`matchingSum`, `rootPolynomial`, `MatchingIdentity`, `coeff_reflection`,
and `symmetrize_coefficient` declaration bodies are copied byte-for-byte from
the archived Lean fence. Only the outer module name and header digest change.
No deposit, state pin, or coverage edge has been created.

Step 1: `/usr/bin/time -l make lean`, EXIT 0; 12585 jobs; 15.59 seconds;
maximum resident set size 2987180032 bytes. Log: `step-1-make-lean.log`.
Both public theorem `#print axioms` outputs are exactly
`[propext, Classical.choice, Quot.sound]`.

## Declaration Accounting

For the two currently proved public theorems:

| Declaration | proof_shape | Direct Frozen Theorem Dependencies | escape_witness | admission_basis |
| --- | --- | --- | --- | --- |
| coeff_reflection | bind-only | none; unfolds frozen dilate | none | none for independent deposit; companion prerequisite of symmetrize_coefficient |
| symmetrize_coefficient | bind-only | FiniteConvolutionCoefficients.coeff_additiveConvolution | none | none for independent deposit; intended prerequisite of MatchingIdentity |

The frozen theorem's GID is
`D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.coeff_additiveConvolution`.
Its recorded declaration statement_id is
`sha256:22e74279dd95309d79b0e8a1737f0f3cc47b35cea04bebdf984da4f26e3926f7`;
module pin:
`sha256:58abac734b6a8969c6215223633e21fea7d3901df1967f9531622190c058d12c`.
These identities are read from the merged predecessor report, not recomputed.

`utility: none`, assessed separately for every declaration:

| Declaration | Reason It Misses All Four Computational Classes |
| --- | --- |
| Matching | An index-type family for arbitrary n,k; no bounded instance, enumeration of parameters, checker, or numerical reduction. |
| instFintypeMatching | Finite-subtype infrastructure for every n,k; no certified instance or parameter enumeration, checker, or numerical reduction. |
| edgeSquare | A symbolic definition over every commutative ring; none of the four computational classes. |
| matchingSum | A symbolic sum for arbitrary n,k and roots; not bounded parameter enumeration, a checker, a numerical reduction, or a certified instance. |
| rootPolynomial | An arbitrary root-family product; none of the four computational classes. |
| MatchingIdentity | The unbounded target Prop, without a proof assertion; none of the four computational classes. |
| coeff_reflection | Arbitrary-degree coefficient normalization; no finite certified instance, bounded enumeration, checker, or numerical reduction. |
| symmetrize_coefficient | Arbitrary-degree symbolic identity; no finite certified instance, bounded enumeration, checker, or numerical reduction. |

Other utility fields are `not-applicable(kind=none)`.

## Search Receipt

Before candidate declarations were created, the following commands used the
same regex word-boundary feature, `\\b`, for negative and positive controls:

```sh
rg -n '\b(MatchingIdentity|matchingSum|symmetrize_matching_sos|matching_fiber)\b' D5
rg -n '\b(coeff_additiveConvolution|symmetrize)\b' D5/S3/Zeros/Convolution
rg -n '\b(matchingPolynomial|matching_polynomial|matchingSum|symmetrize_matching_sos|card_perfectMatching|card_perfect_matching)\b' .lake/packages/mathlib/Mathlib
rg -n '\b(IsMatching|doubleFactorial|coeff_prod_X_sub_C|esymm)\b' .lake/packages/mathlib/Mathlib/Combinatorics/SimpleGraph/Matching.lean .lake/packages/mathlib/Mathlib/Data/Nat/Factorial/DoubleFactorial.lean .lake/packages/mathlib/Mathlib/Algebra/Polynomial .lake/packages/mathlib/Mathlib/Algebra/MvPolynomial
```

Line-hit counts, respectively: 0, 23, 0, 53. A commentary initially said 22
for the repository positive control; the captured count is 23.

Additional reads: Mathlib `SimpleGraph.Subgraph.IsMatching`,
`IsPerfectMatching.even_card`, `Finset.sym2`, `Finset.card_sym2`,
`Sym2.card_toFinset_of_not_isDiag`, the double-factorial API,
`MvPolynomial.esymm_eq_sum_monomial`, and Vieta. The matching predicates
and edge-count APIs do not count all perfect matchings. The existing symmetric
polynomial and factorial APIs will be reused.

Network search is operational: `gh search code '"invOneSubPow" language:Lean'`
returned three requested positive-control results; `"matching_polynomial"`
returned zero. The query `"doubleFactorial" "Matching" language:Lean` found
TauCeti's `card_perfectMatching`, a candidate for (C). Its source at immutable
revision `f6f910c48c3b832f64090230c1d623c1a98a9b58` is Apache-2.0, uses only
three Mathlib imports, and pins Lean v4.34.0-rc2 / Mathlib
`e21ec05048292b3de86d4cf1987e2208171a5642`. Those differ from this tree:
direct package dependency is unavailable; any later reuse must be a licensed
port under A17.2, with its own local Lean check. No such port is yet claimed.

`dominating_theorem_search: not-found-in-searched-scope` for the full target.
Absolute nonexistence outside these searched names/candidates is
`ASSUMED-UNVERIFIED`.

## Artifact Directory

`/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/matching-fiber-0908/attempt-1`

The cache was prepared by `make lean-cache-ensure`: seeded by clonefile from
`/Users/auricstudio/trureturing`, clonefile_attempts=1, both Mathlib and project
olean states warm. Every subsequent Lean build uses the canonical make entry.
No bare lake invocation, resource-limit increase, or constant change is used.
