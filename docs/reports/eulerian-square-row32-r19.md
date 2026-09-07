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
Its `make lean` result is pending at this pre-registration commit.
