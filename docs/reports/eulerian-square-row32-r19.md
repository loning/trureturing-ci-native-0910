# Eulerian matrix square, row 32: implementation record

Provenance: r19 implementation seat, Codex; no locally invoked skill or
independent review seat. The orchestrator supplied the target and repository
capacity/freeze observations. Literature readings below were obtained by this seat.

Base: `67d5945fdcaaf3cea6312063acf59a44c7dd0c42`.
Branch: `lane/math/r19-row32-0908`. Scope: tier 2, only `A^2` at row 32.

## Pre-registered obligation

Prove `(B 32).Splits` and every real zero of `B 32` is nonpositive, using
`B`, `bc`, `A` and `row` from `EulerianSquareRow31`. The proposed escape
witness consists of new exact matrix-product coefficient equalities and
alternating signs of the degree-31 quotient at 32 ordered negative rational
endpoints. These supply 31 distinct negative roots; the extracted zero root
makes 32 roots in total. Thus "32 negative intervals plus zero" would be an
incorrect count for this indexing. Degree exhaustion must also be kernel checked.

Success: the exact target compiles with only the standard axiom closure and
the certificate is connected to the existing API. Stop if bind-only succeeds
or a prior public computation/certificate of this same row is found. A failed
proof or build is recorded as such; it is not replaced by a floating root table.

## Literature recheck (2026-09-08)

- Downloaded [arXiv abstract](https://arxiv.org/abs/2607.01572), v1 HTML and PDF;
  HTTP 200. PDF text extracted with `pypdf` 6.17.0. PDF page 10 says
  "we computed the first 30 RGFs of A2"; page 11 states Conjecture 4.1.
  The HTML renderer numbers the same conjecture 4.15, so PDF numbering governs.
- arXiv API queries `all:"Narayana transformation"` and
  `all:"Eulerian transformation"` returned 2 and 5 entries respectively.
  The former includes the source v1 and a 2008 log-convexity paper. The latter
  includes Branden--Jochemko and Athanasiadis; the latter's abstract concerns
  transforms of a class including inputs rooted in `[-1,0]`, not this row-32
  matrix-square certificate. No retrieved entry reports this row.
- GitHub code searches `2607.01572`, `EulerianSquareRow32`, and
  `Eulerian square` found the source formalization, this repository's row 31,
  and a separate small-row study. `EulerianSquareRow32` returned `[]`;
  the same search for `EulerianSquareRow31` returned 3 paths.
- Read `PerAlexandersson/RealRooted` at
  `8319b1d3f3c5bf4fdaa2452c8022ec655de8a3b5` (downloaded source archive).
  Its Narayana transformation theorem does not provide this Eulerian-square
  certificate. The scoped Eulerian/row-32 query had no hits; the same scope's
  Narayana-name positive control had 73 matching lines.
- Read [the separate study](https://github.com/paulklemstine/Lean/blob/6bfa8ca0434e7be3eb76f4e8614924a03effc2a5/Papers/research_real_rootedness_of_the_square_of_the_eulerian_tria.md),
  `Catalog/Novelty/EulerianSquareRealRooted.lean`, and its Python demo at that
  same commit. Its Eulerian entries count `k` descents, while our source counts
  `k-1`; its theorem assumes `n <= 7` and demo reaches `n = 8`. It is not the
  target object or the target row.
- Google returned a redirect/interstitial; DuckDuckGo returned a bot challenge;
  Bing returned unrelated results despite the query in the page title.
  These are not negative search evidence. Semantic Scholar returned HTTP 429.
  OpenAlex's broad search returned mostly fluid-mechanics results; its first
  20 records did not resolve the question and are not an exhaustive review.

Conclusion: no prior public computation or certification of the same `A^2`
row 32 was seen in the retrieved scope. `ASSUMED-UNVERIFIED`: unpublished or
unindexed work, inaccessible search results, and sources outside that scope
remain unexcluded. No worldwide-priority claim is made. No Library note is created.

## Bind-only probe

The repository search `git grep -n -P '\b(EulerianSquare|certified_row32|B 32)\b'
-- D5` returned EXIT=1 (0 matches). The positive control
`git grep -n -P '\bcertified_row31\b' -- D5` returned EXIT=0 (3 matching lines).
Pinned Mathlib v4.33.0 contains `splits_iff_card_roots` and
`roots_eq_of_natDegree_le_card_of_ne_zero`, whose root-count hypotheses need
new witnesses here. The temporary probe uses those normalizations and
`norm_num`, `decide`, `linarith only`, `nlinarith`, and `sq_nonneg`.
The Lean LSP probe produced two proof errors: the root-cardinality branch
could not refute `(B 32).roots.card < (B 32).natDegree`, and the sign branch
could not refute `0 < x` from `(B 32).eval x = 0`. Transport EXIT=0 does not
mean the proof succeeded. An initial LSP client confused a server request
with a response; only the corrected client's completed diagnostics count.
The probe and diagnostics are retained in the attempt artifacts. The initial
`make lean` was deliberately stopped with EXIT=143 after the measured
process elapsed time 43:17; it was still compiling existing Weil modules
and had enumerated sources before Row32 existed. This is not a proof-failure
exit: the completed LSP diagnostics carry that evidence. An overlapping
`make lean-report` attempt returned EXIT=2 with `LEAN_CACHE status=busy`.
After stopping the original build, the report build was restarted in order
to include the new source. Process and command receipts are in the attempt
log; no claim that mathematical difficulty caused the wait is made.

## Certificate and API reuse

The new module is `D5/S3/Zeros/Convolution/EulerianSquareRow32.lean`.
Its `row_0` through `row_32` are equality certificates for the imported
`row`; they do not define another triangle. `bc_values` checks the 33
coefficients of the imported matrix product. `factor_row32` then connects
the integer Horner quotient to the exact imported `B 32`.

The directly reused existing definitions are `row`, `A`, `bc`, and `B`.
The existing `row_length`, `A_recurrence`, boundary and initial-condition
API remains available; no replacement recurrence or length theorem is
introduced. Those two declarations are not claimed as proof dependencies
of the finite coefficient calculation.

Exactly seven formerly private Row31 declarations become public:

- `hp`: gives the quotient its existing monic integer Horner representation.
- `hv`: exposes the integer expression reduced by the exact sign checks.
- `hp_degree`: supplies the quotient degree and nonzeroness.
- `hp_monic`: supplies the monicity companion result for `B 32`.
- `eval_pos`: transfers a positive integer Horner value to real evaluation.
- `eval_neg`: transfers a negative integer Horner value to real evaluation.
- `split_from_endpoints`: consumes ordered endpoints, strict sign changes,
  and degree to exhaust the roots and prove splitting and negativity.

Each is used by the new module. `hv_spec` and `root_between` remain private;
their existing proofs are used through the exported sign and splitting
theorems. The Row31 change only removes those seven `private` keywords.

The untrusted search used JavaScript BigInt homogeneous Horner arithmetic
on a dyadic grid. It found 32 ordered negative rational endpoints, with
alternating signs starting negative. Numerators need at most 35 bits,
denominators at most 24 bits, and coefficients at most 179 bits. Lean
independently checks the row equalities, matrix-product coefficients,
endpoint signs, order, and negativity using `decide`, `decide +kernel`,
and `norm_num`. There is no floating-point root table in the proof.

Adjacent endpoints define 31 disjoint open intervals. The intermediate
value theorem supplies distinct negative roots of the degree-31 quotient.
`roots_eq_of_natDegree_le_card_of_ne_zero` in the reused splitting helper
identifies its entire root multiset with these witnesses, and
`splits_iff_card_roots` yields real splitting. Multiplication by `X` adds
the exact zero root, giving degree 32 and 32 roots in total.

The computational content is `certified-instance`, answering the
pre-registered row-32 obligation above. Its terminal use is
`EulerianSquareRow32.certified_row32`; the Lean header records this GID.
The proposed escape witness is realized by the new coefficient identities
and the strict integer sign facts consumed by that terminal proof.
The companion obligations are exact object identity (`factor_row32`),
degree exhaustion (`row32_monic_degree`), and the zero root (`row32_zero`).
Their consumer-to-premise directions are `certified_row32 -> factor_row32`,
`row32_monic_degree -> factor_row32`, and `row32_zero -> factor_row32`.
The degree and zero statements discharge the named certificate obligations;
they are not separate instance claims.

## Verification

The build phase of canonical `make lean-report` returned EXIT=0 and
`Build completed successfully (12508 jobs)`. Its log reports 150 seconds
for Row31 and 519 seconds for Row32 in this working tree, with the emitted
cache receipt reporting both project and Mathlib oleans warm. These are
module build timings under the observed machine load, not isolated benchmarks.
The proof source was committed as `ee5fc6c777` after that build.

Actual `#print axioms` output for `factor_row32`, `row32_monic_degree`,
`row32_zero`, and `certified_row32` contains exactly
`[propext, Classical.choice, Quot.sound]` for each theorem. The verbatim
lines are retained in the attempt's `row32-axioms.log` and result envelope.
No `sorry`, added axiom, or `native_decide` supplies the certificate.

`proof_shape: content`; `admission_basis: escape-witness`. The live path is
`certified_row32 -> H_certificate -> sign_0, ..., sign_31` for the new
strict sign facts, and `certified_row32 -> factor_row32 -> bc_values` for
the object identity. The terminal claim has no direct frozen repository
dependency: its imported Row31 module is unfrozen, while the other direct
import is pinned Mathlib. This is an implementation and PR delivery, with
no freeze or merge asserted by this seat.

A Lean LSP `run_cmd` probe read the compiled constant closure with
`ConstantInfo.getUsedConstantsAsSet`, including opaque theorem values and
restricting traversal to the two Eulerian namespaces. It completed with
EXIT=0 and zero errors: `bc_values` and all 32 `sign_i` constants occur,
while `ROW31_CERTIFICATE_USED=false`. The probe and structured output are
retained as `Row32DependencyProbe.lean` and `row32-dependencies.json` in
the attempt artifacts. This checks the elaborated dependency closure;
the live-use argument is the explicit sign input to the splitting helper
and the coefficient equality used by `factor_row32`.

The complete `make lean-report` command subsequently returned EXIT=0.
Its report SHA-256 is
`0f88f06f6685a3c63a928a54859d80d5be229aaec592df6c679c2f5c02f5aaa9`.

`make emit` returned EXIT=0 and generated only the new Row32 Blueprint
mirror among the tracked document paths. The PR changes five files;
the two Lean artifacts remain 651 and 588 lines, both below 800.
