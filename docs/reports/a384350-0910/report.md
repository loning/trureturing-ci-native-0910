# A384350 / A384318 implementation

Provenance: `lean4` skill; one Codex implementation worker, no delegated or
independent review seats. The user supplied the triage decision and independent
finite checks. Worker measurements below are distinguished from those inputs.

## Preregistration

- Tier: first tier, as assigned. Base:
  `5d6a244a852db7cf66e3d9a78f4ec885b9f0a55c`; branch `lane/math/a384350`.
- Question: for every finite set S of positive natural numbers, is a nontrivial
  family of pairwise disjoint strict partitions of the members of S equivalent
  to some member being a sum of distinct positive numbers outside S?
- Semantic contract: a function assigns exactly one finite set T_s to each
  s in S; every part is positive, its sum is s, distinct indexed blocks are
  disjoint, and at least one block differs from the singleton {s}. The index
  names its required sum; no independent product of block counts is used.
- Proposed escape witness (before proof): in any nontrivial family, the block
  of the least changed member is disjoint from S. Every part in that block is
  strictly smaller than its sum; a part in S would therefore have its own
  unchanged singleton block, contradicting pairwise disjointness.
- Reverse construction: replace the selected singleton by the outside block,
  retaining the singleton for every other member.
- Empty S is included; nontriviality supplies a member when needed.
- Stop for a published proof of this uniqueness criterion or a counterexample
  to the least-changed argument. Success for this implementation assignment:
  kernel proof, requested local gates, and an open PR. No merge is claimed.
- No new theory volume, ingestion, atom, or coverage edge. Use the existing
  no-atom freeze entry point (`make deposit-uncovered`, backed by ledger-align).

## Search receipts

Initial repository search at the base above:
`rg -n 'A384350|A384318|A384322|A384317|DisjointRefinement|disjoint.{0,40}partition|partition.{0,40}disjoint|严格分拆|不交.*分拆' D5 Blueprint Library docs/reports`.
No target theorem was found. The triage note
`Library/Words/oeis2026triage0910.md` contains the assigned statement and route.
Other hits are unrelated finite partitions/cosets; their public APIs and broader
sum/refinement candidates remain to be inspected before local proof work.

Triage decision (verbatim from the task, not a new literature claim):

> A384322 的 NAME 与 A384317 的 formula **复述了同一对应但未给证明**——
> **不能因为「有人写过」就降级**(本仓判例 A392698:因此错误降级,重派后落地 #6596)。
> 它另取得 arXiv:2111.11084、2112.15096、2301.06347、2107.04666、2602.01281 完整 PDF 定位检索,
> 未找到本族唯一性证明;**但明写「未逐页审完,open 只限此检索范围」**。

## Verification log

Pending. No Lean proof or gate success claimed at this checkpoint.

## Unclaimed

- No exhaustive literature review or global novelty claim. Papers not opened
  by this worker are `ASSUMED-UNVERIFIED`; the triage PDF work is attributed above.
- The user's 2036-subset enumeration is a supplied observation, not worker
  verification. Finite examples will be private semantic checks only.
- No counting formula, sequence coefficient computation, or labeled set
  partition count is claimed.
- Independent review and remote CI success are not yet claimed.

### Worker library and online pass

- Repository broadening: searched D5 for `strict.partition`, `unrefinable`,
  `disjoint.*refinement`, `distinct.part.*sum`, and `sum id`; reviewed the
  public theorem signatures in CommonPriorPosteriorAgreement,
  IcosahedralAxisDecomposition, FiniteCosetPartitionMaximalIndexMultiplicity,
  ImmutableExtension, LayeredCapture, ObservationEscapeTopology,
  ResidualPermutationSign, PaddingRatio, TauSigmaPowerBounds, and
  SamePrimeScaleRedundancy. General APIs concern probability averages, prefix
  codes, observation kernels, permutation sums, or prime-factor bounds; none
  supplies the needed positive distinct-sum/least-changed-block lemma.
- Mathlib commit `db584cd6d46c92f209a44c0f1c829460d327499d` verified from
  `.lake/packages/mathlib`. Text searches for unrefinable/strict partition/
  disjoint refinement found no target declaration. Reusable primitives read:
  `Finset.min'_mem`, `Finset.min'_le`, `Finset.single_le_sum`,
  `Finset.sum_erase_add`, `Finset.sum_lt_sum_of_subset`.
- Online HTTP capability measured: all seven requests returned HTTP 200.
  All fields of A384350, A384318, A384322, A384317 were read at their `/internal`
  URLs. The first two still explicitly label the family characterization
  Conjecture; the latter two state the correspondence without a proof.
  Their retrieved revision dates are respectively 2025-10-20, 2025-06-11,
  2025-07-27, 2025-05-28. No bibliography/proof field occurs in these responses.
- GitHub repository API search `unrefinable lean`: total_count 0,
  incomplete_results false. This is a scoped repository search, not a complete
  code search. Loogle bare `unrefinable` was rejected as an unknown identifier;
  that is a query error, not an absence result. A quoted query follows.
- arXiv API `all:unrefinable`, max_results=15: read returned abstracts.
  Seven partition papers include the five triage papers plus 2206.04261 and
  2601.10227. Abstracts discuss classification, generation, normalizer chains,
  numerical semigroups and Young diagrams; none states this family criterion.
  Full text follow-up of the additional relevant papers remains pending.
- Raw responses and `web-receipts.json` are in the runner attempt directory.

Cache receipt: `status=seeded`, `method=clonefile`, donor
`/Users/chronoai/trureturing`, `clonefile_attempts=1`,
`project_olean_state=warm`, `mathlib_olean_state=warm`,
`mathlib_missing_olean_files=0`; `make lean-cache-ensure` EXIT 0.

### Follow-up before local proof

Quoted Loogle query `"unrefinable"` returned count 0; positive control
`"Finset.min'_mem"` returned count 1 with the expected type. This repairs the
bare-query error above. The online API is therefore available and responsive.

Retrieved 2601.10227 (15 pages) and 2206.04261 (28 pages), extracted every page
with pypdf, and searched `disjoint`, `unique`, `family`, `families`, `decompos`,
`least`, and `refinement`, reading the returned contexts. No disjoint-family
uniqueness result occurred in those contexts. A relevant distinction:
2601.10227, p.3, Proposition 1 proves that the smallest *refinable part* has a
refinement into two missing parts; 2206.04261, p.2, attributes that reduction
to ACCL23 Proposition 4. These start with an outside-sum refinement, not an
arbitrary simultaneously chosen disjoint block family. They do not establish
the forward implication sought here. We do not reproach or reprove that
binary-refinement reduction. Full page-by-page reading is not claimed.

`dominating_theorem_search: not-found-in-searched-scope`. The stopping condition
has not been triggered by these searches. Proceed with the preregistered proof.

Routing measurements: Arith direct Lean files 33, Arith Blueprint direct files
56, Library/Arith total files 48. Use the already registered ArithSums domain
(S3; finite sums over integer indices) for this new actual module. Its Lean
and Blueprint directories do not yet exist (initial files 0). No Library note
is required for the repository-derived proof; the report retains the OEIS
statement locators and bounded literature assessment. First route invocation
with an absolute manifest path was rejected (`manifest path must be
repository-relative`); the manifest is moved to a relative run-local path.

### First kernel-checked proof unit

The private lemma `part_lt_of_nontrivial` is accepted by Lean (hot-cache
`lake env lean /tmp/a384350-part.lean`, EXIT 0). For any positive finite
partition whose sum is s and which differs from {s}, every part is < s.
It reuses `single_le_sum`, `sum_erase_add`, and
`eq_singleton_iff_unique_mem`. This is an unbounded structural lemma, not a
finite certificate. The final equivalence is not yet claimed.

Failure history: the initial `simpa [hsum]` did not rewrite an eta-expanded
sum; the second version still left `hsum : T.sum id = s` opaque to omega's
atom comparison. An actual goal trace isolated the mismatch with
`sum (fun x => x)`; `change (∑ x ∈ T, x) = s at hsum` fixed it. No assumption
or mathematical statement was weakened. The supplied scratch proof is now
incorporated into the canonically routed D5 module with its semantic definitions.

Routing succeeded for D5/S3/ArithSums/DisjointStrictRefinement, generality G.
The route parser also required string-valued empty fields and artifact=lean;
those manifest-input errors were fixed before creating the module.
