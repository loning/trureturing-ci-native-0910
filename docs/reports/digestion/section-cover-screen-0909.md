# Section cover screen, 2026-09-09

Lane: #6160. Digestion accounting: #5952. Stage: thinking, screening only.

Provenance: no skill invoked; one Codex worker, no independent review seats.
The orchestrator's Gribinski precedent and population counts are supplied inputs,
not new measurements by this worker. This report is a candidate assessment,
not a coverage edge or a proof of fidelity.

## Preregistration

Registered before candidate body inspection and mathematical searches at
2026-09-09T00:37:45Z. Repository baseline:
`b9994986f3ccd57821b99c2dfc8990333bb0b452`.
Branch: `lane/math/section-cover-screen-0909`.
`candidates.json` contains 164 entries and is a supplied, untracked input.

Stopping rules:

1. All 164 entries assigned exactly one tier: normal completion.
2. An explicit time budget exceeded while fewer than 82 entries are screened:
   stop and publish the completed subset plus every unscreened atom ID.
   The supplied task and tracked probe brief specify no numerical time budget;
   `budget_seconds = null`. No arbitrary budget is invented to shorten the task.
3. Any Lean edit, `make cover`, or `make deposit`: scope breach; stop immediately.

Tier criteria and ordering:

1. `frozen-covered`: every boxed assertion matches an actually read frozen
   declaration verbatim or by an explicit equivalence; no strengthened domain
   restrictions, added assumptions, lost quantifiers, or weakened conclusion.
2. `frozen-partial`: a read frozen declaration covers a named proper subset;
   explicitly list the remaining clauses or domain/quantifier mismatch.
3. `needs-lean`: an assertion with no matching frozen statement found in the
   recorded title and mathematical-content searches. This is bounded search
   evidence, not proof that no equivalent statement exists anywhere.
4. `not-an-assertion`: the actual atom body contains only narration, definitions,
   or a calculation report, with no truth-valued assertion. A theorem-like title
   or a boxed delimiter alone does not establish an assertion.
5. `unreadable`: missing/truncated body or insufficient context prevents judgment;
   state the precise reason. This does not mean mathematically unformalizable.

Within each tier, sort by atom ID; prioritize full matches for review, then partial
matches. Read atom bytes and, when necessary, source adjacency; title searches
are only discovery. Use `rg` or `git grep -P`, including positive and negative
controls with the same regex features, and record commands and matching-line
counts. Frozen membership requires the actual `Golden/Frozen/state/` JSON pin;
record GID, pin `statement_id`, and binder/domain restrictions, otherwise `none`.
For tier 1, record every boxed clause against Lean binders, assumptions, and
conclusions with `verbatim | equivalent | not-covered` labels; any not-covered
clause excludes tier 1. For covered projections record `proof_shape: bind-only`,
`escape_witness: null`, direct frozen dependencies, and screening-only admission
basis. No source recompilation or independent theorem is required for screening.

## Progress

Screened: 0 / 164. Bodies 1-30 read; all contain truth-valued assertions.
No tier is assigned until the corresponding mathematical-content search and
frozen-state check are complete.

Discovery checkpoint: read the full GribinskiDegreeTwo,
NormalizedJensenDegreeLowering, GoldenResourcePriceInterval, and
NewtonHankelRealRootCriterion Lean sources. The latter three are related
interfaces, not yet accepted matches. Read GribinskiDegreeTwo's actual state pin:
`sha256:184c298cb6b3a6b32640e84511f41eede52d8d0d29ae2b24a68f14ef5722487e`.

## Search Receipts

Counts are matching lines, including comments, in baseline D5 Lean sources.
Title and content searches only discover candidates; no-match is bounded evidence.
C+ initially failed: the theorem names start with g1/g2, not gribinski.
C+2 validates the same word-boundary, alternation, and whitespace features;
C+3 / C-2 validate case-insensitive word boundaries.
The first full-output S24 read was truncated and its count was discarded.
S24-count counts the untruncated stream, then returns filenames and sample lines.

| ID | Command | Matching lines |
| --- | --- | ---: |
| C+ | `rg -n --glob '*.lean' '\b(theorem\|lemma)\s+gribinski' D5` | 0 |
| C- | `rg -n --glob '*.lean' '\b(theorem\|lemma)\s+section_screen_absent_0909' D5` | 0 |
| S01 | `rg -n --glob '*.lean' '(?i)polygon\|winding\|argument.?principle\|rouch' D5` | 293 |
| S02 | `rg -n --glob '*.lean' '(?i)wigner\|hudson\|conditional.*theta\|theta.*negative' D5` | 91 |
| S03 | `rg -n --glob '*.lean' '(?i)causal.?cone\|bandwidth\|interaction.?degree\|finite.?propagation' D5` | 0 |
| S04 | `rg -n --glob '*.lean' '(?i)clock\|history.?state\|partial.?trace' D5` | 393 |
| S05 | `rg -n --glob '*.lean' '(?i)hermite\|real.?root.*trace\|trace.*real.?root\|companion.*square' D5` | 33 |
| S06 | `rg -n --glob '*.lean' '(?i)pyramid\|four.?pyramid\|fibonacci.?polytope\|independen.*polytope' D5` | 0 |
| S07 | `rg -n --glob '*.lean' '(?i)successor.*local\|local.*successor\|add.?one.*depth\|depth.*local' D5` | 10 |
| S08 | `rg -n --glob '*.lean' '(?i)jensen\|scaled.?derivative\|derivative.*scal' D5` | 208 |
| S09 | `rg -n --glob '*.lean' '(?i)5040\|colossal\|common.?price' D5` | 403 |
| S10 | `rg -n --glob '*.lean' '(?i)schmidt\|occupation.*phase' D5` | 308 |
| S11 | `rg -n --glob '*.lean' '(?i)gaussian.*volume\|history.*volume\|volume.*real.?root\|completely.?monoton' D5` | 1 |
| S12 | `rg -n --glob '*.lean' '(?i)spectral.?defect\|imaginary.*square\|coeff.*growth\|coefficient.*rate' D5` | 11 |
| S13 | `rg -n --glob '*.lean' '(?i)filter.*energy\|energy.*filter\|screen.*energy' D5` | 4 |
| S14 | `rg -n --glob '*.lean' '(?i)double.?factorial\|gaussian.*moment\|moment.*gaussian\|turan' D5` | 22 |
| S15 | `rg -n --glob '*.lean' '(?i)dirichlet.*nonzero\|nonzero.*dirichlet\|history.*dirichlet\|cycle.*dirichlet' D5` | 0 |
| S16 | `rg -n --glob '*.lean' '(?i)fidelity\|effective.?dimension\|clock.*overlap\|phase.*separation' D5` | 126 |
| S17 | `rg -n --glob '*.lean' '(?i)schatten\|negative.?part\|negative.*trace\|scale.*inertia' D5` | 156 |
| S18 | `rg -n --glob '*.lean' '(?i)schur\|positive.*threshold\|positivity.*radius' D5` | 159 |
| S19 | `rg -n --glob '*.lean' '(?i)toeplitz\|szego' D5` | 369 |
| S20 | `rg -n --glob '*.lean' '(?i)winding.*coefficient\|monodromy\|periodic.*winding' D5` | 100 |
| S21 | `rg -n --glob '*.lean' '(?i)pick.*mismatch\|spectral.*mismatch\|sampling.*negative\|negative.*sampl' D5` | 13 |
| S22 | `rg -n --glob '*.lean' '(?i)bessel' D5` | 1 |
| S23 | `rg -n --glob '*.lean' '(?i)multinomial\|qbinomial\|q.?binomial\|parity.*histor' D5` | 37 |
| C+2 | `rg -n --glob '*.lean' '\b(theorem\|lemma)\s+g1_explicit_coefficients' D5` | 1 |
| C+3 | `rg -n --glob '*.lean' '(?i)\bGRIBINSKIDEGREETWO\b' D5` | 4 |
| C-2 | `rg -n --glob '*.lean' '(?i)\bsection_screen_absent_0909\b' D5` | 0 |
| S24-count | `rg -n --glob '*.lean' '(?i)hankel\|quadrature\|stieltjes' D5` | 812 |

## Nonclaims

- No cover, deposit, Lean edit, digestion-ledger edit, or PR.
- No claim that `make cover` checked fidelity.
- No claim that this screening or repository search is exhaustive.
- No new proof, provability claim, or implication to RH or a larger conjecture.
- No independent-review or multi-model consensus claim.
