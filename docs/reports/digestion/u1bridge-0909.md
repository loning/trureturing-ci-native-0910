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
