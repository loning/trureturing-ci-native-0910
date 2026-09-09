# Section cover batch, 2026-09-09

## Provenance and scope

- Skill context: no skill invoked; the assigned implementation worker reads the
  tracked probe brief directly. The surrounding runner is supplied by the user.
- Carrier and roles: one Codex implementation worker performs the clause audit,
  writes this report, and invokes the canonical cover and PR commands. There are
  zero independent review seats in this worker's delivery.
- Mixing: sequential audit and self-check. The earlier screening report is an
  input, not an independent approval of these new coverage edges. The user's
  five PIN_MATCH readings are supplied evidence, not worker measurements.

Baseline HEAD and the initially resolved origin/dev are both
`1bb54f920527c303ebaec4e5388d48fcbee0df04`.
Branch: `lane/math/section-cover-batch-0909`.
The complete tracked probe brief, CLAUDE.md, agents/CONTEXT.md, and the screening
report have been read before content changes. The screening report is read from
commit `d43088b76be65982a2fc8270da3c2137ebbea94f`, path
`docs/reports/digestion/section-cover-screen-0909.md` (659 lines).
Its history was inspected with
`git log --oneline origin/dev..origin/lane/math/section-cover-screen-0909`.
The existing untracked `candidates.json` is a supplied input, outside this diff.

## Preregistered decision rule

Read each full atom with `make show-atom ATOM_ID=<64-character basename>`.
Read the nominated frozen declaration through its `:= by`, including definitions
and source context needed to fix the meaning of its symbols. Each boxed clause
and adjacent assertion receives `verbatim`, `equivalent`, or `not-covered`, with
explicit binders, hypotheses, conclusions, endpoint and quantifier checks.
Any unmatched A-group assertion means `verdict: partial` and no cover for that
atom. Only a full match permits a canonical `make cover` call. A successful
writer exit is not evidence of mathematical fidelity.

A group: audit and, only when all clauses match, cover G2, the 5040 open price
interval, and the ordered positive quadruple classification. B group: write
transport dossiers for U1 and dynamics descent; no cover call for either B atom,
regardless of the eventual recommendation. No Lean edits, deposits, or freezes.
Commit and push this report progressively, including after every atom. Open a
PR using `make pr-open`, without `AUTO_MERGE`; this delivery does not claim merge.

## Initial atom inventory

All five paths were located with the user-specified full-basename `find` query.
All have source_id `quantum-rh` and initial directory `residual-open`.

| Group | Atom ID | Initial state | Result |
| --- | --- | --- | --- |
| A1 | `66fd622e5d54c25826af9d416db18df1d8eecf9c71288d80ff0460237e3e95d2` | residual-open | pending audit |
| A2 | `088d882f6a10249e981da5d77bc3bb5e53e75a5ee02313bdd7c879cb21e22413` | residual-open | pending audit |
| A3 | `5f5912050d91b5f8998e6799d12c40e766fa4d65798ff890b506a56c3bc0ed3c` | residual-open | pending audit |
| B1 | `c352d304105e02cbbcb0607e31a1e217adb85d4b344ba0d75c23ba4420dbf0e1` | residual-open | dossier pending; cover prohibited |
| B2 | `7b2657006891568aa395dfd9fa14bde9d9d23d2ade0c449b00f7cdf5c616baec` | residual-open | dossier pending; cover prohibited |

## Nonclaims

- No claim that `make cover` judges fidelity.
- B-group atoms are not covered by this worker.
- No new theorem, proof, deposit, freeze, or implication to RH is claimed.
- No exhaustive repository or literature search is claimed.
- No independent review or multi-model consensus is claimed.
- Not yet measured at this checkpoint: writer outcomes and PR checks.
