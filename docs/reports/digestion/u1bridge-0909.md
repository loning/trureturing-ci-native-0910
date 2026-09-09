# U1 complex-to-real bridge probe (LANE #6160)

Provenance: no skill; Codex worker, single-agent investigation and self-check.
No independent review is claimed. User brief: `u1bridge-0909`, attempt 1.

## Scope and preregistered order

- Worktree: `/Users/auricstudio/trureturing-u1bridge-0909`.
- Branch: `lane/math/u1bridge-0909`.
- Starting HEAD and observed `origin/dev`:
  `a8809894ea0f1dac06913ed56e09db6223d7ddfa`.
- Atom: `c352d304105e02cbbcb0607e31a1e217adb85d4b344ba0d75c23ba4420dbf0e1`
  (`quantum-rh`, U1 / U13).
- Read `tools/scripts/agent/probe-brief-note.txt`, all of `CLAUDE.md`
  (the first truncated output was supplemented with bounded reads), and
  `agents/CONTEXT.md` before editing the repository.
- First attempt: pinned Mathlib instances/theorems, frozen projections and
  normalization only, including `sq_nonneg` and `linarith only` where relevant.
  A successful bind-only proof stops the task without a production module.
- Finish and report Stage A before any Stage B implementation. Stop also for
  missing prerequisites or no admissible basis. Never invent a consumer.
- No cover, deposit, freezing, budget change, new domain, or auto-merge.
  Stage A only means no PR. This report is committed and pushed incrementally.

## Source and frozen interface: first readings

`sed -n '29555,29660p' docs/develop/theory/QUANTUM-RH.md` confirms the source
assumes the old Gram matrix is positive definite, introduces the Hermitian
block matrix in `(x,z)` order, and states U13 with a non-strict Schur bound.
The adjacent proof is completion of the square; U14 interprets the residual
as the squared norm of the new orthogonal component. The following paragraph
separately addresses singular positive semidefinite old blocks.

`git show origin/dev:D5/S3/Weil/ZetaLinear/ExactStickyReduction.lean` was read
in full, including the public statement through `:= by` and its proof.
Direct frozen interface (candidate dependency, not yet used by a probe):

- GID: `D5/S3/Weil/ZetaLinear/ExactStickyReduction.exact_sticky_reduction`.
- Module state pin, read from
  `Golden/Frozen/state/D5/S3/Weil/ZetaLinear/ExactStickyReduction.lean.json`:
  `sha256:311ed2863e85f005429c5613aacc27d7980b6ceba46355745055ba29b96d7984`.
  This is the stored module statement identity, not a recomputed selector hash.
- Implicit carriers `HP HQ : Type*`, each with `NormedAddCommGroup` and
  `InnerProductSpace Real` instances; no finite-dimensionality assumption.
- Explicit real-linear maps `APP : HP -> HP`, `AQP : HP -> HQ`,
  `AQQ AQQInv : HQ -> HQ`.
- `hQQNonneg`: `forall q, 0 <= inner Real (AQQ q) q`.
- `hQQSymm`: `forall x y, inner Real (AQQ x) y = inner Real x (AQQ y)`.
- `hQQInv`: `AQQ.comp AQQInv = LinearMap.id` (right inverse only).
- First conjunct: universal nonnegativity of `blockEnergy APP AQP AQQ`
  iff universal nonnegativity of `schurEnergy APP AQP AQQ AQQInv`.
- Second conjunct: equality of their `negativeIndex : WithTop Nat`, defined
  using finite-dimensional negative subspaces, including infinite index.
- U13 would use only `.1`. The theorem requires neither positivity nor
  symmetry of `APP`, and its actual `hQQNonneg` is non-strict despite the
  docstring saying "strictly positive". No complex matrix identification is
  present in that statement.

## Tool readings and unresolved work

- Lean pin: `leanprover/lean4:v4.33.0`.
- Mathlib pin: `db584cd6d46c92f209a44c0f1c829460d327499d` (`v4.33.0`).
- `.lake` was absent at entry (`ls` exit 1); no bare Lake command was run.
- First `make show-atom ATOM_ID=...`: exit 2, because the `--no-build` CLI
  executable was absent. This is a tooling prerequisite, not an atom verdict.
- `gh issue view 6160 ... --json ...` exited 0, but its full comments output
  was truncated. Only displayed material is read; undisplayed comments are
  `ASSUMED-UNVERIFIED`. Relevant comments will be selected structurally.
- Bridge statement, completed bind-only attempt, Mathlib hits, proof shape,
  escape witness and admission basis: pending Stage A investigation.
- Preregistered named downstream consumer: not yet established; `none` until
  an actual registration is read. A future cover seat is not automatically a
  named Lean theorem consumer.

## Nonclaims

This checkpoint proves neither the target nor its provability, claims no
exhaustive search, and claims no implication concerning RH or a larger
conjecture. It changes no atom status and creates no production Lean module.

## Stage A checkpoint: exact upstream candidate

`make lean-cache-ensure` exited 0: `status=seeded`, `method=clonefile`, donor
`/Users/auricstudio/trureturing`, one clonefile attempt, project and Mathlib
olean states both `warm`. The command also built the missing CLI through its
canonical entry. The subsequent `make show-atom ATOM_ID=...` exited 0 and
returned the complete U13 raw/normalized body with `coverage_gids=[]`.
The claimed source locator was checked with bounded numbered output:
`29588` begins the section, `29595` states `G_N>0`, `29605-29608` defines the
block matrix, and `29611-29620` is U1/U13. Its proof continues after `29625`.

Repository coarse search (not a semantic completeness claim):

```sh
rg -n -i '\b(schur|posSemidef|rclikeToReal|re_inner_eq)\b' D5/S3/Weil D5/S3/Observer/Hilbert D5/S3/Constants --glob '*.lean'
```

This returned nearby matrix positivity and abstract Schur APIs; no exact U13
statement was established by that textual search. Then pinned Mathlib was
searched and the following bodies/signatures were actually opened:

- `Mathlib/LinearAlgebra/Matrix/PosDef.lean:564`,
  `Matrix.PosDef.fromBlocks₁₁`: for positive-definite invertible `A`,
  `PosSemidef (fromBlocks A B Bᴴ D)` iff
  `PosSemidef (D - Bᴴ * A⁻¹ * B)`.
  This is the direct bind-only candidate, with the second index type `Unit`.
- Same file `:581`, `Matrix.PosDef.fromBlocks₂₂`: the opposite block order is
  already supported upstream via `Equiv.sumComm`.
- `Mathlib/Analysis/InnerProductSpace/Basic.lean:932,944,959,972,975`:
  `Inner.rclikeToReal`, `InnerProductSpace.rclikeToReal`,
  `real_inner_eq_re_inner`, `InnerProductSpace.complexToReal`, and the real
  inner-product instance on `Complex`. These are available conversions,
  not missing analytic prerequisites. The generic conversion is deliberately
  not a global instance because of scalar and PiLp instance diamonds.

Search/control receipt (readings are line counts, not semantic theorem counts):
`rg -n '\b(theorem|lemma)\s+(exact_sticky_reduction|real_inner_comm)\b'`
on the frozen file and Mathlib Basic returned 2 lines, exit 0. A candidate
pattern with a trailing `\b` after the Unicode subscript in `fromBlocks₁₁`
returned 0, exit 1, although the declaration is present. That zero is invalid
absence evidence; the follow-up uses whitespace after the identifier.

The structurally selected #6160 comment mentioning U1 was read completely:
<https://github.com/the-omega-institute/trureturing/issues/6160#issuecomment-5594751714>.
It registers a need for a bridge but names no downstream Lean theorem.
The preceding dossier `section-cover-batch-0909.md:240-322` was also read:
it describes the entire transport but supplies no checked Lean edge.
These two sources do not establish a preregistered named consumer (`none`).

Next measurement: a run-local Lean probe of the direct upstream criterion,
specialized to a single complex added coordinate, before considering any
production bridge. The external Make extension pattern is already documented
in `docs/reports/robin/zhao-assumption1-map-0909.md:180-191`; it preserves the
root `make lean` recipe and invokes the canonical cache wrapper for the probe.
