# Eulerian square row 33, R7-A2-33

Provenance: Codex implementation seat under the supplied r33-interlace-0908
runner contract. No locally invoked skill or independent review seat.
All checks below are this seat's readings, not the scouting seat's reports.

Base: `edc52b0f71fc5b3a55b446965ce50870e98898e7` (HEAD and dev at entry).
The supplied worktree was already on `lane/math/r33-interlace-0908`, clean.
Scope: tier 2; only the existing `EulerianSquareRow31.B 33` for ordinary A^2.

## Obligation and prospective witnesses

The exact target is `(B 33).Splits` and every real zero is nonpositive.
The proposed escape witness is an exact positivity certificate for the
Wronskian of H_32 and H_33, or exact interval enclosures certifying H_33's
alternating signs at all H_32 roots. The latter is a possible alternative
to the proposed LDL route, registered before conducting that search.
Both routes must use the existing definitions and connect every numerical
certificate to them. No common-zero interlacing of B_32 and B_33 is claimed.

Success requires the whole target, kernel verification and actual axiom
output. Bind-only success stops the attempt without a new module. A prior
public computation of this row, a failed certificate or an unresolved
proof/build step is reported explicitly, never as a weaker successful target.

## Bind-only result

Pinned Lean is v4.33.0; Mathlib commit is
`db584cd6d46c92f209a44c0f1c829460d327499d`.
The complete no-build Lean LSP probe `BindOnly.lean` ended with two errors:
root-cardinality equality for B_33 remained unproved, and the nonpositivity
branch could not contradict `0 < x` from `(B 33).eval x = 0`.
It tried normalization, decide and arithmetic using sq_nonneg; the row-32
projection was a successful positive control. Transport EXIT=0 does not
mean that the candidate proofs succeeded.

The first LSP client used hover for synchronization, which could return
before all diagnostics. The authoritative run uses
`textDocument/waitForDiagnostics` and `dependencyBuildMode=never`.
Earlier server startup replayed existing import-build messages; no result
from that startup is counted as the final probe. All explicit build
commands in this attempt use the repository make entry points.

Repository search with `rg` and word boundaries found zero certified_row33
hits, with certified_row32 as a same-pattern control (3 lines, 3686 Lean
files searched). The corresponding full pinned-Mathlib search found the
Wronskian's definition and algebraic degree lemmas, but no direct Eulerian
square instance or polynomial-interlacing theorem under the searched names.
The polynomial positive control found 4 lines for splits_iff_card_roots,
splits_X_mul and roots_eq_of_natDegree_le_card_of_ne_zero.

## Literature recheck, 2026-09-08

Downloaded the original arXiv abstract, v1 PDF and v1 HTML successfully.
The PDF's page 10 reports only the first 30 RGFs of A^2; page 11 states
Conjecture 4.1. PDF numbering governs, not the HTML renderer's 4.15.
The arXiv API queries for "Eulerian transformation" and "Narayana
transformation" returned 5 and 2 entries. They include the source v1,
Branden--Jochemko and Athanasiadis, with no row-33 certification in the
retrieved records. GitHub code search for EulerianSquareRow33 returned no
paths; EulerianSquareRow31 returned 7 paths as a positive control.

Further readings covered [Athanasiadis v5](https://arxiv.org/pdf/2302.00754v5),
Theorem 1.1 and its nonnegative input cone. For a monic element of that cone,
the coefficient of degree n-1 is at most n; the present input has
`2^33 - 34 > 33`. Thus this theorem does not directly apply.
The separately retrieved `paulklemstine/Lean` Eulerian-square file at
`0e413df02db7e093c5660980b47fe6099ef7805a` has only n <= 7 instances and uses
k-descents indexing. The RealRooted repository at
`bb0ca36d73dbbd57b6ab613fd84b478480dd8b83` has relevant ordinary Eulerian
and Narayana transformation results, but the scoped searches did not find
this square-row instance. These are source readings, not builds of those
external repositories.

Conclusion: 在检索到的范围内未见第 33 行的公开计算或认证。
Unpublished and unindexed work is not excluded. No worldwide priority claim
is made, and no Library note is created.

## Certificate and proof

The completed proof uses the preregistered interval alternative.
The untrusted exact Python search independently found 32 positive
fraction-free Bezout pivots, the last with 2701 decimal digits. That
calculation is **not** a Lean proof of global Wronskian positivity.
No Wronskian theorem, LDL theorem or determinant expansion is claimed.

The kernel certificate instead consists of 31 triples `(a, b, d)`,
with positive d, strictly ordered disjoint intervals `(a/d, b/d)`,
opposite signs of H32 at the two endpoints, and a homogeneous integer
Horner enclosure for H33 on each whole interval. These enclosures are
strictly negative at even indices and strictly positive at odd indices.
The search needed at most 17 bisections; interval integers need at most
34 bits and H33 coefficients at most 187 bits. The largest stored
Horner enclosure intermediate is 1065 bits; the largest endpoint sign
product is 2040 bits. The two outer H33 evaluations use 1216 and 1403 bits.
These sizes describe the certificate arithmetic, not proof-term byte sizes.

The two outer endpoints are `-274877906944` and `-1/1099511627776`;
both are negative and both H33 evaluations are strictly positive.
All numbers are checked with `norm_num` or `decide +kernel`.
The search program is outside the trusted proof path.

The root argument is explicit:

1. `factor_row32` reuses the existing equality, identifying the quotient
   with H32. `H32_anchor` consumes both halves of `certified_row32`.
   Its splitting half feeds the product-of-roots argument in
   `root_between_split`; its nonpositivity half, together with H32(0) != 0,
   supplies strict negativity of the predecessor roots.
2. `predecessor_roots` chooses one H32 root in each interval using that
   splitting anchor. It obtains H33 signs from `signs_in_boxes`.
3. Those 31 roots plus the two outer endpoints give 32 disjoint negative
   gaps. The imported `split_from_endpoints` proves H33 splitting.
4. The degree identities and finite root-cardinality argument make both
   root lists complete. `quotient_interlacing` proves
   `s i.castSucc < r i < s i.succ` for every i, with all s roots negative.
5. `certified_row33` uses `factor_row33` to add the zero root and proves
   exactly `(B 33).Splits ∧ ∀ x : Real, (B 33).eval x = 0 → x ≤ 0`.

The interlacing objects are H32 and H33, not B32 and B33.

## Proof shape and reuse

`question_answered`: the row-33 instance of PDF Conjecture 4.1;
preregistration is the obligation above, committed as `c1e384de1d`.
`dominating_theorem_search`: not-found-in-searched-scope; scopes and
positive controls are recorded above and in the runner readings.

| Public theorem in Row33 | proof_shape | Directed companion or witness edge |
| --- | --- | --- |
| `factor_row32` | bind-only | `H32_anchor -> factor_row32 -> Row32.factor_row32`. |
| `factor_row33` | content | `certified_row33 -> factor_row33 -> bc_values`. |
| `quotient_interlacing` | content | `quotient_interlacing -> predecessor_roots -> signs_in_boxes -> numeric_signs`. |
| `certified_row33` | content | `certified_row33 -> quotient_interlacing` and `factor_row33`. |

`admission_basis`: escape-witness, with the terminal certified-instance use
declared in the Lean header. The new whole-interval sign enclosures are
neither the terminal theorem nor an alias of it; they provide the root
endpoint signs on the live derivation of splitting and nonpositivity.
The coefficient equalities in `bc_values` independently bind the target to
the shared arbitrary-row B definition. The terminal statement has no
additional hypotheses.

Direct frozen dependencies: none. Row31 and Row32 are not frozen at the
recorded base; the imported Mathlib facts are pinned above and are not
repository frozen nodes. No frozen state file is added or changed.
This is an implementation PR under the runner obligation, not a deposit
or coverage action; no atom is marked absorbed and no freeze is claimed.

Only the following Row32 declarations lose `private`, with zero line
increase and no mathematical edits. Each supplies the indicated
matrix-product term under the existing A definition:

| Exposed declaration | Required consumer and reason |
| --- | --- |
| `row_1` | `bc_values -> A 33 1 * A 1 k`. |
| `row_2` | `bc_values -> A 33 2 * A 2 k`. |
| `row_3` | `bc_values -> A 33 3 * A 3 k`. |
| `row_4` | `bc_values -> A 33 4 * A 4 k`. |
| `row_5` | `bc_values -> A 33 5 * A 5 k`. |
| `row_6` | `bc_values -> A 33 6 * A 6 k`. |
| `row_7` | `bc_values -> A 33 7 * A 7 k`. |
| `row_8` | `bc_values -> A 33 8 * A 8 k`. |
| `row_9` | `bc_values -> A 33 9 * A 9 k`. |
| `row_10` | `bc_values -> A 33 10 * A 10 k`. |
| `row_11` | `bc_values -> A 33 11 * A 11 k`. |
| `row_12` | `bc_values -> A 33 12 * A 12 k`. |
| `row_13` | `bc_values -> A 33 13 * A 13 k`. |
| `row_14` | `bc_values -> A 33 14 * A 14 k`. |
| `row_15` | `bc_values -> A 33 15 * A 15 k`. |
| `row_16` | `bc_values -> A 33 16 * A 16 k`. |
| `row_17` | `bc_values -> A 33 17 * A 17 k`. |
| `row_18` | `bc_values -> A 33 18 * A 18 k`. |
| `row_19` | `bc_values -> A 33 19 * A 19 k`. |
| `row_20` | `bc_values -> A 33 20 * A 20 k`. |
| `row_21` | `bc_values -> A 33 21 * A 21 k`. |
| `row_22` | `bc_values -> A 33 22 * A 22 k`. |
| `row_23` | `bc_values -> A 33 23 * A 23 k`. |
| `row_24` | `bc_values -> A 33 24 * A 24 k`. |
| `row_25` | `bc_values -> A 33 25 * A 25 k`. |
| `row_26` | `bc_values -> A 33 26 * A 26 k`. |
| `row_27` | `bc_values -> A 33 27 * A 27 k`. |
| `row_28` | `bc_values -> A 33 28 * A 28 k`. |
| `row_29` | `bc_values -> A 33 29 * A 29 k`. |
| `row_30` | `bc_values -> A 33 30 * A 30 k`. |
| `row_31` | `bc_values -> A 33 31 * A 31 k`. |
| `row_32` | `bc_values -> A 33 32 * A 32 k`; also `row_33 -> row_32` for the recurrence. |

`row_0` remains private: the j=0 product term vanishes and its public
exposure was removed after successful verification. The factorization
and `certified_row32` were already public. The Row32 quotient, endpoints,
sign lemmas and `H_certificate` remain private.

## Verification and delivery

`make lean` succeeded for the coefficient, interval and terminal units.
The terminal build reported 12520 completed jobs and 59 seconds for the
Row33 module on the warm local cache. The LSP probes use
`dependencyBuildMode=never` and are editor checks, not substitutes for
the make build.

`make lean-report` and `make emit` both succeeded. The emitted Blueprint
marks all four public theorems `std3`. `DependencyProbe.lean` traverses
elaborated proof-value constants inside Row33 and records outgoing Row32
references. It confirms the displayed witness chain, the predecessor
anchor, and direct `bc_values` references to every exposed row equality.
This is a constant-dependency reading; the live use follows the explicit
root/sign derivation above, not a claim of a general dead-term analyzer.
The pre-PR PCRE word-boundary search outside the new module found zero
`certified_row33` matches, with three `certified_row32` positive controls.

Actual terminal build outputs:

```text
'D5.S3.Zeros.Convolution.EulerianSquareRow33.factor_row32' depends on axioms: [propext, Classical.choice, Quot.sound]
'D5.S3.Zeros.Convolution.EulerianSquareRow33.factor_row33' depends on axioms: [propext, Classical.choice, Quot.sound]
'D5.S3.Zeros.Convolution.EulerianSquareRow33.quotient_interlacing' depends on axioms: [propext, Classical.choice, Quot.sound]
'D5.S3.Zeros.Convolution.EulerianSquareRow33.certified_row33' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No `sorry`, `native_decide`, new axiom or weakened terminal target is used.
Row31 remains 651 lines, Row32 588, Row33 543 and the new Scribe source 70.
The generated Blueprint is 63 lines. The per-file 800-line bound is respected.
Runner result.json contains the
final emitted-document/report counts, commands with EXIT codes, axiom
readings, commit/PR references and any remaining verification limitations.

Proof commits were pushed separately: `ea4a4acf6f` (coefficients),
`c5f83b0375` (intervals), `c2baa8a9d4` (strict interlacing and terminal).
No auto-merge is requested.
