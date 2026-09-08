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

Step 1 was pushed as `01f3ada6a9`.

Step 2 is verified: `AlternatingFactorialSum.lean` is byte-for-byte identical
to the archived source fence. `/usr/bin/time -l make lean`: EXIT 0; 12586 jobs;
20.70 seconds; maximum resident set size 3015442432 bytes.
Log: `step-2-make-lean.log`. The three `#print axioms` outputs are each exactly
`[propext, Classical.choice, Quot.sound]`.

Step 2 was pushed as `8e62755894`.

Step 3 (B) is verified for arbitrary n,i,j and disjoint S,T over Q.
`coeff_esymm_mul_eq_card` identifies the coefficient with the subset-pair
fiber; `card_elementaryFiber` constructs the bijection
`U -> (S union U, S union (T \\ U))` from `T.powersetCard ell`, with inverse
`(A,B) -> A inter T`; `coeff_esymm_mul_fiber` includes all zero boundary cases.
The condition `S.card <= i` is essential when interpreting `i - S.card` in N.
Build: `/usr/bin/time -l make lean`, EXIT 0; 12586 jobs; 28.86 seconds;
maximum resident set size 3026927616 bytes. Log: `step-3b-make-lean.log`.
All three public theorem axiom prints are exactly
`[propext, Classical.choice, Quot.sound]`. The only warning is an unused
upper-bound hypothesis in `card_elementaryFiber`.

The preceding `step-3a-make-lean.log` records EXIT 2, 12586 jobs,
21.46 seconds, RSS 2978086912 bytes: two calls used `card_sdiff` where the
pinned API requires `card_sdiff_of_subset`, and the curried double sum
requires `sum_product'`. These API errors were corrected. The failed
elaboration's `sorryAx` prints are not verification evidence.

Step 3 was pushed as `b8932a62c2`.

Step 4 is partially verified. The local three-term edge expansion and the
exact decorated-matching sum now compile. Pairwise edge disjointness makes
each incident vertex exponent local. An explicit bijection between the
square choices and S proves there are exactly `S.card` square choices, so
every term in this fiber has weight `(-2 : Q) ^ (k - S.card)`. Consequently:

```lean
coeff (fiberExponent S T) (matchingSum (X : Fin n -> MvPolynomial (Fin n) Q) k)
  = (-2 : Q) ^ (k - S.card) * Fintype.card (MatchingMonomialFiber k S T)
```

The displayed formula uses ASCII abbreviations; the elaborated source is
`coeff_matchingSum_eq_card_fiber`. It is not the full factorial formula (C):
the cardinality on the right remains to be counted.
Build: `/usr/bin/time -l make lean`, EXIT 0; 12586 jobs; 22.28 seconds;
maximum resident set size 3047145472 bytes. Log: `step-4e-make-lean.log`.
All nine new public theorem axiom prints are the standard three axioms.
No resource limits were changed. The product distributivity step calls
Mathlib `Fintype.prod_sum`, whose proof inducts over the edge finset; the
only `ring` invocation added here concerns a single edge and three terms.

Failed step-4 builds, each at 12586 jobs:

| Log | EXIT | Seconds | Maximum RSS Bytes | Diagnosis |
| --- | --- | --- | --- | --- |
| step-4a-make-lean.log | 2 | 29.93 | 2998583296 | Subtype-sum rewrite failed; unsplit dependent product normalization reached the default 200000 heartbeats. |
| step-4b-make-lean.log | 2 | 20.26 | 2977087488 | Product split resolved the timeout; subtype-sum rewrite still required an explicit function argument. |
| step-4c-make-lean.log | 2 | 21.98 | 2986115072 | Constant polynomial cast required explicit map_neg/map_ofNat rewrites. |
| step-4d-make-lean.log | 2 | 20.89 | 2992832512 | Destructing a choice under dependent Option.get was ill-typed; moved the local exponent argument to a separately quantified option. |

## Declaration Accounting

For the currently proved public theorems:

| Declaration | proof_shape | Direct Frozen Theorem Dependencies | escape_witness | admission_basis |
| --- | --- | --- | --- | --- |
| coeff_reflection | bind-only | none; unfolds frozen dilate | none | none for independent deposit; companion prerequisite of symmetrize_coefficient |
| symmetrize_coefficient | bind-only | FiniteConvolutionCoefficients.coeff_additiveConvolution | none | none for independent deposit; intended prerequisite of MatchingIdentity |
| opposite_inv_series_mul | bind-only | none (Mathlib only) | none | none for independent deposit; prerequisite of alternating_choose_convolution |
| alternating_choose_convolution | bind-only | none (Mathlib only) | none | none for independent deposit; prerequisite of alternating_factorial_sum |
| alternating_factorial_sum | bind-only | none (Mathlib only) | none | none for independent deposit; preregistered consumer is the full matching identity |
| coeff_esymm_mul_eq_card | bind-only | none (Mathlib only) | none | companion reduction for the fiber bijection; not independently deposited |
| card_elementaryFiber | content | none | explicit inverse subset-pair bijection, with injectivity and surjectivity proofs | constructive fiber counting; independent review unverified; not deposited |
| coeff_esymm_mul_fiber | content | none | subset-pair bijection plus impossibility of fibers outside the degree/cardinality guard | arbitrary-degree coefficient formula (B); independent review unverified; not deposited |
| edgeSquare_eq_choice_sum | bind-only | none | none | companion: matching_product_eq_decoration_sum -> edgeSquare_eq_choice_sum |
| matching_product_eq_decoration_sum | bind-only | none | none | companion: coeff_matchingSum_eq_decoration_fiber -> matching_product_eq_decoration_sum |
| coeff_matchingSum_eq_decoration_fiber | bind-only | none | none | companion: coeff_matchingSum_eq_card_fiber -> coeff_matchingSum_eq_decoration_fiber |
| decorationExponent_apply_of_mem | bind-only | none | none | companion: card_squareChoices_of_fiber -> decorationExponent_apply_of_mem |
| chosenSquareVertex_injective | bind-only | none | none | companion: card_squareChoices_of_fiber -> chosenSquareVertex_injective |
| card_squareChoices_of_fiber | content | none | explicit square-choice/vertex bijection; surjectivity uses nonzero exponent and the unique incident edge | escape-witness; not deposited; independent review unverified |
| decorationWeight_eq_pow | bind-only | none | none | companion: decorationWeight_of_fiber -> decorationWeight_eq_pow |
| decorationWeight_of_fiber | content | none | card_squareChoices_of_fiber is used to replace the number of square choices in the exponent | escape-witness through live square-choice bijection; not deposited |
| coeff_matchingSum_eq_card_fiber | content | none | square-choice bijection makes the weight constant on the actual coefficient fiber | escape-witness; partial (C), not full factorial count; not deposited |

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
| opposite_inv_series_mul | An arbitrary-power identity over every commutative ring; no parameter enumeration, checker, numerical reduction, or certified instance. |
| alternating_choose_convolution | A symbolic coefficient identity for arbitrary d,h; none of the four computational classes. |
| alternating_factorial_sum | A symbolic identity for every d,h with exact rational casts; none of the four computational classes. |
| squarefreeExponent | An exponent vector for an arbitrary finite subset; no certified instance, bounded enumeration, checker, or numerical reduction. |
| fiberExponent | A symbolic exponent vector for arbitrary S,T; none of the four computational classes. |
| squarefreeExponent_apply (private) | A general pointwise formula; none of the four computational classes. |
| fiber_pair_decomposition (private) | A general set reconstruction under an exponent equality; none of the four computational classes. |
| split_pair_exponent (private) | A symbolic exponent equality for arbitrary subsets; none of the four computational classes. |
| split_pair_inter (private) | A general set identity proving the inverse map; none of the four computational classes. |
| fiber_pair_cards (private) | Symbolic cardinalities for arbitrary finite sets; no enumeration of bounded parameters, certified instance, checker, or numerical reduction. |
| elementaryFiber | A parameterized finite fiber, not an enumeration over bounded theorem parameters; no certified instance, checker, or numerical reduction. |
| mem_elementaryFiber (private) | Symbolic fiber membership for arbitrary n,i,j; none of the four computational classes. |
| coeff_esymm_mul_eq_card | A universally quantified coefficient identity; no certified instance, bounded parameter enumeration, checker, or numerical reduction. |
| card_elementaryFiber | A universally quantified fiber cardinality theorem; none of the four computational classes. |
| coeff_esymm_mul_fiber | A universally quantified coefficient formula, including impossible cases; none of the four computational classes. |
| EdgeChoice | Symbolic local monomial indexing for arbitrary n,e; no bounded parameter enumeration, certified instance, checker, or numerical reduction. |
| edgeChoiceExponent | A symbolic exponent definition; none of the four computational classes. |
| edgeChoiceWeight | A symbolic weight definition; none of the four computational classes. |
| edgeSquare_eq_choice_sum | A generic polynomial expansion at every edge; none of the four computational classes. |
| MatchingDecoration | Symbolic indexing at every matching size; no bounded enumeration of theorem parameters, certified instance, checker, or numerical reduction. |
| decorationExponent | A symbolic exponent sum; none of the four computational classes. |
| decorationWeight | A symbolic rational weight product; none of the four computational classes. |
| matching_product_eq_decoration_sum | General finite-product identity; none of the four computational classes. |
| coeff_matchingSum_eq_decoration_fiber | Arbitrary-degree coefficient identity; none of the four computational classes. |
| edgeChoiceExponent_zero_of_not_mem (private) | General support fact; none of the four computational classes. |
| decorationExponent_apply_of_mem | General locality theorem for disjoint supports; none of the four computational classes. |
| exists_edge_of_decorationExponent_ne_zero (private) | General incidence existence from a nonzero exponent; none of the four computational classes. |
| fiberExponent_eq_two_iff (private) | General exponent membership characterization; none of the four computational classes. |
| SquareChoices | Parameterized subset of choices, not bounded enumeration of theorem parameters; no certified instance, checker, or numerical reduction. |
| chosenSquareVertex | A symbolic map to an index; none of the four computational classes. |
| chosenSquareVertex_mem (private) | General membership projection; none of the four computational classes. |
| chosenSquareVertex_exponent (private) | General local exponent identity; none of the four computational classes. |
| chosenSquareVertex_injective | General injectivity proof; none of the four computational classes. |
| card_squareChoices_of_fiber | General symbolic cardinality from a bijection; none of the four computational classes. |
| decorationWeight_eq_pow | General symbolic weight formula; none of the four computational classes. |
| decorationWeight_of_fiber | General fiber-weight identity; none of the four computational classes. |
| MatchingMonomialFiber | A finite type parameterized by arbitrary n,k,S,T; not bounded parameter enumeration, certified instance, checker, or numerical reduction. |
| coeff_matchingSum_eq_card_fiber | General symbolic coefficient identity; none of the four computational classes. |

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
