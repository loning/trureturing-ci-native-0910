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

Screened: 0 / 164. Candidate inspection has not begun.

## Nonclaims

- No cover, deposit, Lean edit, digestion-ledger edit, or PR.
- No claim that `make cover` checked fidelity.
- No claim that this screening or repository search is exhaustive.
- No new proof, provability claim, or implication to RH or a larger conjecture.
- No independent-review or multi-model consensus claim.
