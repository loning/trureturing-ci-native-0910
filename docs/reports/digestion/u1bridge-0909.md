# U1 complex-to-real bridge probe (LANE #6160)

Provenance: no skill; Codex worker, single-agent investigation and self-check.
No independent review is claimed. User brief: `u1bridge-0909`, attempt 1.

## Final Stage A decision

**Verdict: `bind-only`; stopped_by: 1; stage_reached: A.**
The U13 statement was proved in a run-local Lean probe using only pinned
Mathlib and normalization. Final external-Make `lean` exit: **0**; all three
probe theorems have exactly `[propext, Classical.choice, Quot.sound]` as their
axioms. No production module was created and Stage B was not entered.
The successful proof does not use either frozen conjunct. The full
matrix-to-real-energy bridge below is a checked *statement*, not a proved
theorem; it was unnecessary for this successful direct proof of U13.

This is a probe result, not coverage: the atom remains `residual-open` with
empty coverage. No PR, cover, deposit or freeze was performed. The following
checkpoints preserve the chronology of the measured failures and their fixes;
the final proof and admission analysis are at the end.

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

## Initial Checkpoint Nonclaims

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

### Probe preregistration

The first probe is `ATTEMPT/U1BindProbe.lean`, with no production file or
root build configuration change. It states the matrix/real-energy bridge as
a `Prop` definition (a type-checked specification, not an assumed theorem).
The tested U13 proof uses `Matrix.PosDef.fromBlocks₁₁`, the diagonal PSD
criterion on `Unit`, positivity-implies-invertibility, and the upstream
Hermitian quadratic-form imaginary-part identity. All parameters remain
universal; no `d >= 0` premise or real-coordinate restriction is introduced.
The auxiliary scalar characterization uses `sq_nonneg` and `linarith only`.
Expected stop: if U13 elaborates without extra axioms, stop by rule 1.

The accepted event
`Golden/Frozen/accepted/77b273ad639b961bd812b1d3c943cb54a326530b9931638d6d628e07cf1af5aa.json`
was read (not recomputed). It supplies the declaration-specific identity of
`exact_sticky_reduction`:
`sha256:2aa18f7c41e8824177fc3ff8c12414a78a0add89e6a1af4ad1cf671999db7a51`.
The distinct module pin above must not be substituted for this selector ID.

Corrected regex: `\b(theorem|lemma)\s+(fromBlocks[^ ]*|real_inner_eq_re_inner)\s`
on Mathlib PosDef/Basic returned 3 lines (exit 0). The same-feature control
`\b(theorem|lemma)\s+(exact_sticky_reduction|real_inner_comm)\s` on the frozen
file/Basic returned 1 line (exit 0): `real_inner_comm`; the frozen declaration
has a newline after its name. The earlier trailing-boundary control returned
2 as already recorded. No negative conclusion is drawn from either syntax.

Two exploratory searches exited 2 because guessed obsolete paths
`Mathlib/Data/Complex/Order.lean` and `Mathlib/LinearAlgebra/Basic.lean` do not
exist. The actual APIs were opened in `Mathlib/Analysis/RCLike/Basic.lean`
(`RCLike.nonneg_iff`) and `Mathlib/LinearAlgebra/Span/Basic.lean`
(`LinearMap.toSpanSingleton`); these errors are not absence evidence.

### First kernel reading

- Root `make lean`: exit 0, `Build completed successfully (12734 jobs)`.
  The tool output was truncated due to existing replay messages; no claim is
  made to have read all replayed warnings. This is a baseline build reading.
- First external-Make probe: exit 2. `blockBridgeStatement : Prop` elaborated.
  `realification_bind_only` and `scalar_residual_bind_only` each reported
  exactly `[propext, Classical.choice, Quot.sound]`.
- `u13_bind_only` did not yet pass: the matrix expression needed explicit
  `Matrix.sub_apply`; the broad scalar `simp` reached recursion depth.
  The failed declaration's error-recovery `sorryAx` is not a proof and is
  not accepted as evidence. Failed source retained as
  `ATTEMPT/U1BindProbe-01-failed.lean`.
- Next revision only adds the matrix subtraction rewrite and replaces broad
  scalar simplification with `RCLike.nonneg_iff`, explicit real/imaginary
  projections and the upstream zero-imaginary-part theorem. No budget or
  premise change.

### Second kernel reading

The second external-Make probe exited 2 (`ATTEMPT/bind-only-02.log`). The
explicit real/imaginary-part reduction passed. The matrix equality remained;
both `Matrix.sub_apply` and `Matrix.mul_apply` were unused simp arguments.
Thus the previous proposed `sub_apply` fix was not sufficient; no claim of
success is retained. The actual goal compares two presentations of the same
finite sums after `Matrix.mul_assoc`. The next test is definitional reduction
(`rfl` after the two Unit cases), avoiding simplifier matching on unfolded
matrix abbreviations. Failed second source is
`ATTEMPT/U1BindProbe-02-failed.lean`. No content witness or missing mathematical
prerequisite has been established by these elaboration failures.

## Final kernel reading and proof shape

The third external-Make probe exited **0**; its root build ended with
`Build completed successfully (12734 jobs)`. Actual log:
`ATTEMPT/bind-only-03.log`, where `ATTEMPT` is
`/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/u1bridge-0909/attempt-1`.
The log contains the probe's complete `#check` output and three axiom checks,
followed by the root build's existing replay output. No linter or budget was
disabled. The only probe warning is the upstream style suggestion to use
`let` instead of `letI`; it does not affect the proof.

| Run-local declaration | proof_shape | Direct frozen theorem dependencies | escape_witness |
| --- | --- | --- | --- |
| `U1Probe.u13_bind_only` | `bind-only` | none | `null` |
| `U1Probe.realification_bind_only` | `bind-only` | none | `null` |
| `U1Probe.scalar_residual_bind_only` | `bind-only` | none | `null` |

The local `hdiag` is not an escape witness: after the upstream matrix
associativity rewrite and singleton-index normalization it is proved by
`rfl`. The imaginary-part fact is a direct upstream theorem instance. The
residual characterization uses `z=1` in one direction and the upstream
`mul_nonneg`/`sq_nonneg` in the other. There is no new analytic, combinatorial
or computational fact on the live proof path.

### What the proposed bridge would say

The missing edge on the *frozen-route* is matrix PSD versus universal
nonnegativity of the concrete real `blockEnergy`, after choosing the maps
and swapping `(x,z)` to `(z,x)`. It is more specific than installing a real
inner-product instance. The following exact Lean proposition was elaborated
as `blockBridgeStatement : Prop`; no proof or assumption of it was used:

```lean
def blockBridgeStatement : Prop :=
  ∀ (N : ℕ) (G : Matrix (Fin N) (Fin N) ℂ) (b : Fin N → ℂ) (d : ℝ),
    G.IsHermitian →
    letI : InnerProductSpace ℝ (EuclideanSpace ℂ (Fin N)) :=
      InnerProductSpace.rclikeToReal ℂ (EuclideanSpace ℂ (Fin N))
    let APP := (LinearMap.toSpanSingleton ℂ ℂ (d : ℂ)).restrictScalars ℝ
    let AQP := (LinearMap.toSpanSingleton ℂ (EuclideanSpace ℂ (Fin N))
      (WithLp.toLp 2 b)).restrictScalars ℝ
    let AQQ := (Matrix.toEuclideanLin G).restrictScalars ℝ
    (Matrix.fromBlocks G (fun i (_ : Unit) => b i)
      (fun (_ : Unit) i => star (b i)) (fun (_ _ : Unit) => (d : ℂ))).PosSemidef ↔
      ∀ p : ℂ × EuclideanSpace ℂ (Fin N),
        0 ≤ D5.S3.Weil.ZetaLinear.ExactStickyReduction.blockEnergy APP AQP AQQ p
```

This uses `HP = Complex` and `HQ = EuclideanSpace Complex (Fin N)`, not a
bare function space with its default sup norm. The chosen real inner
product is the real part of the complex one. `APP z = z*d`, equal to `d*z`;
`AQP z = z • b`; `AQQ x = G*x`. `HP` is one complex dimension and two real
dimensions. All complex coordinates are retained. Hermitian symmetry is
essential for interpreting a real quadratic-form inequality as complex PSD.

The bridge's referenced frozen **definition**, rather than theorem, is
`D5/S3/Weil/ZetaLinear/ExactStickyReduction.blockEnergy`, declaration ID
`sha256:616b6db642efdbb290d1968aaa58c1cfae6d387780ed4981b94794fd6c7bc572`.
For the rest of the hypothetical frozen route one would additionally set
`AQQInv = (Matrix.toEuclideanLin G⁻¹).restrictScalars Real`, discharge the
three frozen hypotheses from `G.PosDef`, and identify `schurEnergy z` with
`(d - Re(b*G⁻¹b))*norm(z)^2`. Those full transports were **not** proved here:
the mandatory first stop had already been reached by the direct U13 proof.

Consequently the isolated realification step is demonstrably one-step
`bind-only`; the full matrix-energy edge is not asserted to be the very same
one-step instance. No content witness for it was established, so there is no
basis to classify it as content under section 3.2. Its implementation and
separate proof-shape audit were stopped by rule 1. This distinction avoids
calling an unproved full transport a kernel-verified bridge.

### Exact successful probe

The following is the final run-local source (the statement definition above
is omitted here to avoid a second copy). The frozen import provides the
checked interface for the statement and `#check`; U13's proof uses no frozen
theorem or private helper.

```lean
import Mathlib.Analysis.Matrix.Hermitian
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Tactic.Linarith
import D5.S3.Weil.ZetaLinear.ExactStickyReduction

open Matrix
open scoped ComplexOrder

noncomputable section
namespace U1Probe

theorem u13_bind_only (N : ℕ) (G : Matrix (Fin N) (Fin N) ℂ)
    (b : Fin N → ℂ) (d : ℝ) (hG : G.PosDef) :
    (Matrix.fromBlocks G (fun i (_ : Unit) => b i)
      (fun (_ : Unit) i => star (b i)) (fun (_ _ : Unit) => (d : ℂ))).PosSemidef ↔
      0 ≤ d - (star b ⬝ᵥ (G⁻¹ *ᵥ b)).re := by
  let B : Matrix (Fin N) Unit ℂ := fun i _ => b i
  let D : Matrix Unit Unit ℂ := fun _ _ => (d : ℂ)
  letI : Invertible G := hG.isUnit.invertible
  change (Matrix.fromBlocks G B Bᴴ D).PosSemidef ↔ _
  rw [Matrix.PosDef.fromBlocks₁₁ B D hG]
  have hdiag : D - Bᴴ * G⁻¹ * B =
      Matrix.diagonal (fun _ : Unit => (d : ℂ) - star b ⬝ᵥ (G⁻¹ *ᵥ b)) := by
    rw [Matrix.mul_assoc]
    ext i j
    cases i
    cases j
    rfl
  have him : (star b ⬝ᵥ (G⁻¹ *ᵥ b)).im = 0 :=
    hG.inv.isHermitian.im_star_dotProduct_mulVec_self b
  rw [hdiag, Matrix.posSemidef_diagonal_iff]
  simp only [forall_const]
  rw [RCLike.nonneg_iff]
  change (0 ≤ d - (star b ⬝ᵥ (G⁻¹ *ᵥ b)).re ∧
    0 - (star b ⬝ᵥ (G⁻¹ *ᵥ b)).im = 0) ↔ _
  rw [him]
  simp only [sub_zero, and_true]

theorem realification_bind_only (N : ℕ)
    (x y : EuclideanSpace ℂ (Fin N)) :
    letI : InnerProductSpace ℝ (EuclideanSpace ℂ (Fin N)) :=
      InnerProductSpace.rclikeToReal ℂ (EuclideanSpace ℂ (Fin N))
    inner ℝ x y = (inner ℂ x y).re :=
  real_inner_eq_re_inner ℂ x y

theorem scalar_residual_bind_only (delta : ℝ) :
    (∀ z : ℂ, 0 ≤ delta * ‖z‖ ^ 2) ↔ 0 ≤ delta := by
  constructor
  · intro h
    have h1 := h 1
    simp only [norm_one, one_pow, mul_one] at h1
    linarith only [h1]
  · intro h z
    exact mul_nonneg h (sq_nonneg ‖z‖)

#print axioms u13_bind_only
#print axioms realification_bind_only
#print axioms scalar_residual_bind_only
end U1Probe
```

The real-part scalar is faithful to U13 because `him` proves that
`b*G⁻¹b` is real; it is not an extra hypothesis. `N` is arbitrary (including
zero), the original block is positive definite, `b` is unrestricted complex,
`d` unrestricted real, and both inequalities are non-strict. The `Unit`
index is exactly the single added coordinate, not a finite numerical sample.

### Admission basis and downstream consumer

**Selected `admission_basis: none`; named downstream consumer: `none`.**
There is no proposed production module after the mandatory bind-only stop.

- `escape-witness`: unavailable; each actually proved probe is bind-only.
- `rule-11-upstream-wrapper`: the identifiable *hypothetical* basis for a
  minimal U13 wrapper would be `Matrix.PosDef.fromBlocks₁₁` plus the explicit
  U13 atom clause. General section 3.2 permits such an exception, but the
  user's stricter stop rule 1 expressly forbids creating that module here.
  This possible wrapper basis does not establish a need for the proposed
  separate matrix/energy bridge.
- `atom-required-bridge`: not established. The explicit U13 clause and
  proposed typed edge are given above, but the user brief, preceding tracked
  dossier and selected #6160 comment name no preregistered downstream Lean
  consumer. Neither this lane's probe nor an unspecified later coverage seat
  is invented as that consumer. This is a statement about the read sources,
  not an exhaustive claim about all registrations.

### Exit codes and delivery boundary

| Operation | Exit |
| --- | ---: |
| Initial `make show-atom` before CLI build | 2 |
| `make lean-cache-ensure` | 0 |
| `make show-atom` after ensure | 0 |
| Root `make lean` | 0 |
| First external-Make Lean probe | 2 |
| Second external-Make Lean probe | 2 |
| Final external-Make Lean probe, including root `make lean` | 0 |

All completed checkpoints were committed and pushed to
`lane/math/u1bridge-0909`; the worker result envelope records the final full
commit list. The report is the only tracked task change. Lean sources and
Make extension live in ATTEMPT, and the successful source is also preserved
verbatim above for durable review. The runner envelope and sentinel are
published by temporary-file then atomic-rename, as requested.

`make lean-report`, admission/preflight and PR CI were not run: no production
Lean or coverage artifact is being submitted, and Stage A explicitly forbids
a PR. Local kernel success is not reported as those checks passing.

### Final nonclaims and ASSUMED-UNVERIFIED

- No production proof, cover, deposit, freeze, PR, or merged result is claimed.
  The proved claim is precisely the run-local U13 theorem printed above.
- No proof of the full `blockBridgeStatement`, inverse-map transport, or
  `schurEnergy` identity is claimed. Its `Prop` elaboration proves only that
  the specification is well-typed.
- No use of the frozen inertia conjunct is claimed. Real negative dimensions
  must not be equated with complex eigenvalue multiplicities without a
  separate dimension conversion.
- No claim of proving RH, of any implication to RH, or of global novelty or
  exhaustive repository/Mathlib/third-party/issue search is made.
- Undisplayed comments from the initial truncated #6160 read, linked pages
  not actually opened, and independent review remain `ASSUMED-UNVERIFIED`.
  Third-party searching was not needed after the exact pinned Mathlib hit.
- The complete frozen-route bridge's provability is not certified by this
  probe. U13 itself *was* kernel-checked; repeating the initial checkpoint's
  "target not proved" as the final verdict would be false.
