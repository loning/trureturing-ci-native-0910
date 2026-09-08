# Frozen Gribinski degree-two coverage audit

## Provenance and scope

- Skill context: no skill invoked by this worker; direct Codex implementation
  in the runner's `gribinski-m2-cover-0909/attempt-1` implementation seat.
- Carrier and division: this Codex worker reads the atom bytes, audits fidelity,
  invokes the coverage writer, and performs the local checks. No independent
  review seat or other model family is claimed.
- Mixing: sequential worker audit and implementation, zero review votes. The
  user supplied the frozen-module observation and candidate declaration names;
  the observations below were checked locally, not inferred from that input.
- Form: `cover`. Source: `quantum-rh`. No Lean edits, deposit, freeze, atom
  rewrite, or Scribe edits are authorized by this task. No auto-merge.
- Audit baseline: `b9ad72010f6473b22e7616958a7e78db6fe0d2e2` (HEAD and origin/dev
  at the initial read). Candidate declarations were read with
  `git show origin/dev:D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean`, including
  every binder and conclusion through `:= by`.
- Frozen membership exists at
  `Golden/Frozen/state/D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean.json`;
  its recorded module statement ID is
  `sha256:184c298cb6b3a6b32640e84511f41eede52d8d0d29ae2b24a68f14ef5722487e`.

All declaration names below have prefix
`D5/S3/Zeros/Convolution/GribinskiDegreeTwo.`.

## Fidelity criterion and shared notation

Every mathematical clause in each selected atom must be supplied by the listed
frozen declarations, with the same quantifier direction, inequalities and
parameter domain. `verbatim` means the same mathematical formula after variable
and notation transcription; `equivalent` requires the stated definitional or
algebraic identification. Any `not-covered` clause forbids a whole-atom claim.
The coverage command does not judge these identifications or source fidelity.
Its `partial-closed` state must not be used as a fidelity verdict.

The three full atom IDs resolve uniquely to the `quantum-rh` ledger. Initial
entries are `residual-open`, have `coverage_gids: []` and
`receipts.unresolved_subitems: []`, and have no `chain_atoms` field. Thus there
are no child atoms to cover and no reason to introduce a container theorem.
The raw text printed by `make show-atom` is the authority for each obligation.

The surrounding source supplies notation, without adding obligations to the
three atom bodies: `QUANTUM-RH.md:60814` defines
`kappa(alpha)=(alpha+1)/(2*(alpha+2))`; `:60821` explicitly defines
`P_2(R_{>=0})` as the monic real quadratics `(X-a)(X-b)` with `a,b>=0`.
Consequently membership is exactly `exists r s : Real, 0 <= r /\ 0 <= s /\
p = rootPair r s`. It requires neither distinct nor strictly positive roots,
and does not allow a nonunit leading scalar. Lean `rootPair` at line 81 uses
`(X-C a)*(X-C b)`, where `C` embeds the real constants in `Real[X]`.

The old surrounding transcription of Definition 3.10 used a ratio prefactor.
The appended erratum at `QUANTUM-RH.md:61194` explicitly corrects it to the
product of falling factorials and explicitly states that G1-G4's conclusions
are unchanged. Lean `weight`, `normalizedCoeff`, `convolutionCoeff`, `boxplus`
(lines 65-79) use that product definition before root specialization;
`normalized_coefficient_convolution` (line 103) states its normalized coefficient
identity for all `k<=2` on the nonsingular domain. This audit uses that recorded
correction to identify the shared operator. It does not cover or validate the
obsolete ratio formula. The external paper was not independently re-fetched
in this coverage-only task.

## G1

Atom: `7901adf784a2db15b73b33751c521fc703f8bbe431efb0304c449cfa3b049907`.
Edge target: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g1_explicit_coefficients`.

| Atom clause | Lean binder or conclusion | Match |
| --- | --- | --- |
| `alpha in R \\ {-1,-2}` | `(alpha : Real) (h1 : alpha != -1) (h2 : alpha != -2)`, lines 136-137 | verbatim |
| `a,b,c,d in R` universally | `(a b c d : Real)`; no sign, order, integrality or distinctness assumption | verbatim |
| `p=(X-a)(X-b), q=(X-c)(X-d)` | Inputs `rootPair a b`, `rootPair c d`; expand line 81 | equivalent |
| `p boxplus_2^alpha q` | `boxplus alpha (rootPair a b) (rootPair c d)` with the product definition identified above | equivalent |
| `X^2-(a+b+c+d)X+[ab+cd+kappa(alpha)(a+b)(c+d)]` | Entire conclusion at lines 138-140; `C` embeds the coefficient sum and constant term | verbatim |

Fidelity verdict: **passed**. No missing clause. The parameter domain is exactly
the nonsingular domain, not the stronger `alpha>-1` condition.

Coverage execution: `make cover` exited 0. Transition:
`residual-open -> absorbed-closed`, `deletable=true`, no gaps, as printed by the
writer's `ENTRY quantum-rh/7901...` line (`g1-cover.log`). The resulting edge
binds target statement
`sha256:f0c48dabfe28b97557cf918888a05d1312ee879f080238ed386cd9726773f78a`.
`make show-atom` after the write exited 0 and printed the original body and
this single coverage GID (`g1-after.log`). Scribe emitted zero changed
blueprints. The complete G1 unit is committed and pushed before G3 starts.

## G3 and G4

Raw bodies and candidate declarations have been read. Their clause tables and
coverage results will be recorded before their respective commits.

## Command evidence

Attempt logs are under
`/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/gribinski-m2-cover-0909/attempt-1`.

- Initial `make show-atom` for each of the three atoms: exit 2; the fresh tree
  had no built `tools/StrataLint.Cli/bin/Release/net10.0/StrataLint` executable.
- `make -C tools dotnet`: exit 0, zero warnings and errors (`dotnet-build.log`).
- Repeated `make show-atom` with each full ID: exit 0; complete raw bodies and
  empty coverage printed (`g1-before.log`, `g3-before.log`, `g4-before.log`).
  In this repository revision `show-atom` does not print a derived migration
  verdict, even after the report exists. Migration evidence therefore comes
  from the writer's `ENTRY` verdict and the actual ledger directory names;
  `show-atom` independently confirms the body and coverage targets.
- `git -C /Users/auricstudio/trureturing pull --ff-only origin dev`: exit 0,
  already up to date; the task continues in the supplied isolated worktree.

The worker stdout log retains the tool calls and their actual exit codes.
An initial lowercase source-path glob failed in zsh; reading `source.toml`
resolved the canonical uppercase path `docs/develop/theory/QUANTUM-RH.md`.
The first `make cover` used the canonical warm donor (`method=clonefile`, both
olean states warm), produced a delta report (`changed=0 added=13 recheck=13`),
then wrote the edge. The full command log contains the writer's whole-ledger
diagnostic output; only the target's `ENTRY` line is used for this transition.
