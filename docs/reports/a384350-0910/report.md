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
