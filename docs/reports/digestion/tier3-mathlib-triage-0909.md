# Tier 3 Mathlib triage, 2026-09-09

## Provenance and scope

LANE #6160. One Codex worker, no skill invoked, no delegated or independent
review seats. Sequential mathematical reading and local kernel probes; this is
not a multi-model consensus. The runner contract was supplied by the user.
The tracked `tools/scripts/agent/probe-brief-note.txt`, complete `CLAUDE.md`,
and `agents/CONTEXT.md` were read before edits.

Worktree: `/Users/auricstudio/trureturing-u1bridge-0909`.
Branch: `lane/math/tier3-mathlib-triage-0909`.
Baseline: `f8ecf5a3d846482c5445fb5180a628d1caa0de29`.
Input: user-supplied untracked `candidates.json`, a JSON array of 150 records.
The input is not a new coverage ledger and its previous `needs-lean` labels
only report bounded searches of frozen repository material.

## Preregistered criteria

The unit is one complete atom, read with `make show-atom ATOM_ID=<full id>`;
source context is read where symbols or hypotheses are supplied outside it.
Titles do not establish that a body contains an assertion. Multiple claims in
one body must all match before the atom can enter A.

| Tier | Criterion |
| --- | --- |
| A `mathlib-bind-only` | Complete assertion follows by instantiation, projection, and normalization, including `sq_nonneg` / `linarith only`. Every upstream declaration must be opened in the local pinned Mathlib tree and cited with file and line. At least five distinct A atoms must receive real temporary Lean probes. A failed full-claim probe downgrades the candidate. |
| B `mathlib-partial` | A specific, relevant mathematical part is available upstream; state that part and the remaining obligation. Generic algebra infrastructure alone does not earn B. |
| C `genuinely-new` | No full binding was found in the stated Mathlib and frozen-repository search scope; name the missing mathematical statement. This is a triage label for a concrete formalization gap, not a proof of global absence or research novelty. |
| D `not-an-assertion` | Body is only narrative, a definition, or a computation report without a separately asserted mathematical proposition; explain from the body. |
| E `unreadable` | Body or essential context cannot be recovered or its claim cannot be determined; state the reason. |

Use `rg` or `git grep -P`; never use `git grep -E` with word boundaries.
Record search commands, line-match counts, exits, and positive/negative controls
using the same regex features. A textual hit only locates source to inspect.
No exhaustion claim follows from a finite keyword search.

Start: `2026-09-09 04:42:04 UTC`. The brief gives no total duration. A 120-minute
working limit was proposed through the clarification channel; pending a user
override, the assumed halfway checkpoint is `2026-09-09 05:42:04 UTC` and the
limit is `2026-09-09 06:42:04 UTC`. At halfway, fewer than 75 screened atoms
requires stopping with the explicit remaining IDs. All 150 screened permits
normal closure. Crossing into production Lean, cover, or deposit requires stop.
Completed batches (normally 25 atoms) and each probe result are committed and
pushed immediately, including failures. Report-only delivery: no PR.

## Mathlib pin

- `lean-toolchain`: `leanprover/lean4:v4.33.0`.
- `lake-manifest.json`: mathlib input revision `v4.33.0`, resolved revision
  `db584cd6d46c92f209a44c0f1c829460d327499d`.
- `git -C .lake/packages/mathlib rev-parse HEAD` returned that exact revision.
- `git -C .lake/packages/mathlib status --short` returned no changed paths.

## Progress

Preregistration checkpoint: `screened_count=0`, all five tier counts zero.
The entire input is currently unscreened. Structured per-atom decisions,
search receipts, probe runs, and pushed commit identities will be appended
as each batch closes. No tier A outcome has yet been asserted.

## Nonclaims

- No production Lean module has been created or edited.
- No `make cover`, `make deposit`, digestion mutation, freeze, or PR is performed.
- No exhaustive repository, Mathlib, third-party, or literature search is claimed.
- A search miss is not proof that Mathlib contains no equivalent statement.
- No proof, provability, research novelty, or new implication to RH is claimed
  for unprobed atoms or for B/C candidates.
- Temporary probes only test the statements explicitly printed in their files;
  a passed subclaim cannot certify a larger source assertion.
