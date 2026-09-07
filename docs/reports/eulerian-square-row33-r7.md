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

Further source readings and numerical/proof results will be added when
available. Unpublished and unindexed work is not excluded. No worldwide
priority claim is made, and no Library note is created.
