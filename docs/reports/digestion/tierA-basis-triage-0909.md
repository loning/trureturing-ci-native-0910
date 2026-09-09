# Tier A admission-basis and fidelity triage, 2026-09-09

LANE: #6160. Repository: https://github.com/the-omega-institute/trureturing.
Worktree: `/Users/auricstudio/trureturing-robin7smooth-0909`.
Branch: `lane/math/tierA-basis-triage-0909`.
Pinned starting commit: `eb28454e6a3832d6301ade1a43ff6c5ae9dca069`.
Local Mathlib revision: `db584cd6d46c92f209a44c0f1c829460d327499d`.

Provenance: no locally invoked skill; one Codex worker performs this judgment.
The enclosing runner supplied a thinking-stage brief; no independent reviewer or
multi-model consensus is claimed by this report. User-supplied `tierA.json` is
an untracked input, read without modification. The tracked probe brief was read
first, followed by the complete `CLAUDE.md` and `agents/CONTEXT.md`.

## Preregistration (before atom judgments)

The orchestrator predicts that only a minority of the seven candidates qualify
as (b), and most are normalization-only statements with no admission basis.
This is a prediction, not a finding. It may be overturned only by individually
citing a locally checked upstream declaration and explaining thinness.

Inherited scope restriction, taken as a premise:

> Temporary probes only test the statements explicitly printed in their files;
> a passed subclaim cannot certify a larger source assertion.

Fidelity and admission are separate axes. Read each complete CAS atom with
`make show-atom ATOM_ID=<full-id>`. Compare every boxed clause and assertion
against the original probe, including quantifier direction, strictness,
parameter domains, extra hypotheses, and excluded degeneracies. Clause statuses
are `verbatim`, `equivalent`, or `not-covered`. A proper subset is `partial`.

The admission set is closed (`CLAUDE.md` 3.2): `escape-witness`,
`rule-11-upstream-wrapper`, `atom-required-bridge`. All seven supplied probes
are `bind-only`, so `escape-witness` is unavailable. An upstream elementary
rewrite that supplies an ingredient does not thereby carry the whole conclusion.
The bridge exception requires an explicit atom clause, a previously absent typed
edge between independent concepts, and a preregistered named downstream consumer.
`refutes` satisfies a utility conjunct only (3.3), never a fourth admission basis.

Reporting precedence: a missing source clause gives `partial-fidelity` even if
the tested subset has a wrapper basis; admission for that subset is recorded
separately. `wrap-and-cover-eligible` requires full fidelity plus an established
basis. `no-admission-basis` can coexist with explicitly reported fidelity gaps.
Unreadable/non-assertional text is recorded as `not-an-assertion` and explained.

Scope: judgment only. No production modules, cover, deposit, or PR. Each completed
atom judgment is committed and pushed before advancing to the next one.

## Progress

`screened: 0 / 7`. No atom judgment has yet been made.

## Nonclaims

- No atom has been covered; no production theorem has been deposited or frozen.
- No `D5/` module has been created; no PR has been opened.
- `make cover` is not claimed to judge fidelity.
- No admission basis outside the closed three is claimed; `refutes` is not one.
- No larger source assertion is certified by an inherited successful subclaim.
- No new proof of these source assertions, proof of their future provability,
  exhaustive library search, or implication to RH is claimed.

The final structured `conclusion` and push receipts will be appended as the
seven judgments are completed. The runner envelope is a separate worker-owned
artifact, published atomically only after completion.
