/- GID: D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity
   generality: G
   mirror-B: D5/B/S3/Quantum/Entanglement/StationaryOccupationRankNullity
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: A finite Gram matrix turns an explicit kernel-dimension bound into a rank lower bound. -/

import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.LinearAlgebra.Matrix.PosDef
import D5.S3.Quantum.Entanglement.BoundedProfileCardinality

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

open scoped BigOperators
open scoped ComplexOrder

namespace D5.S3.Quantum.Entanglement.StationaryOccupationRankNullity

open D5.S3.Quantum.Entanglement.BoundedProfileCardinality

/- `Matrix.rank` is definitionally the finrank of the range of `mulVecLin`.
   This spelling keeps the source-facing rank/nullity bridge independent of
   any choice of bases or a positive-semidefinite realization. -/
theorem gram_rank_add_nullity {ι κ : Type*} [Fintype ι] [Fintype κ]
    (G : Matrix ι κ ℂ) :
    G.rank + Module.finrank ℂ (LinearMap.ker G.mulVecLin) = Fintype.card κ := by
  have h := LinearMap.finrank_range_add_finrank_ker G.mulVecLin
  simpa only [Matrix.rank, Module.finrank_fintype_fun_eq_card] using h

theorem gram_rank_ge_card_sub_nullity {ι κ : Type*} [Fintype ι] [Fintype κ]
    (G : Matrix ι κ ℂ) (q : Nat)
    (hker : Module.finrank ℂ (LinearMap.ker G.mulVecLin) ≤ q) :
    Fintype.card κ - q ≤ G.rank := by
  have h := gram_rank_add_nullity G
  omega

/- This is the reusable lower-bound interface for the stationary occupation
   argument.  Its only model-specific input is the kernel estimate; the
   cardinality and rank/nullity bookkeeping are kernel-checked here. -/
theorem bounded_profile_rank_ge
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (a : ι → Nat)
    (G : Matrix (D5.S3.Quantum.Entanglement.BoundedProfileCardinality.Profile a)
      (D5.S3.Quantum.Entanglement.BoundedProfileCardinality.Profile a) ℂ)
    (q : Nat)
    (hker : Module.finrank ℂ (LinearMap.ker G.mulVecLin) ≤ q) :
    (∏ i : ι, (a i + 1)) - q ≤ G.rank := by
  rw [← card_bounded_profiles a]
  exact gram_rank_ge_card_sub_nullity G q hker

/- A Gram factor through a finite memory coordinate carrier cannot have rank
   larger than that carrier. The factor form stays independent of positivity
   and leaves the model-specific kernel estimate explicit. -/
theorem gram_factor_rank_le_memory_card {ι κ : Type*} [Fintype ι] [Fintype κ]
    (C : Matrix κ ι ℂ) :
    (C.conjTranspose * C).rank ≤ Fintype.card κ := by
  exact (Matrix.rank_mul_le_left C.conjTranspose C).trans
    (Matrix.rank_le_card_width C.conjTranspose)

/- Complex Gram matrices are Hermitian. Positivity is intentionally left to a
   future repository-specific real quadratic-form interface. -/
theorem gram_factor_is_hermitian {ι κ : Type*} [Fintype ι] [Fintype κ]
    (C : Matrix κ ι ℂ) :
    (C.conjTranspose * C).IsHermitian := by
  exact Matrix.isHermitian_conjTranspose_mul_self C

/- With Mathlib's ComplexOrder scope, the standard matrix predicate records
   the nonnegative Hermitian quadratic form of a finite Gram factor. -/
theorem gram_factor_pos_semidef {ι κ : Type*} [Fintype ι] [Fintype κ]
    (C : Matrix κ ι ℂ) :
    (C.conjTranspose * C).PosSemidef := by
  exact Matrix.posSemidef_conjTranspose_mul_self C

/- Kernel estimates may be proved on the factor itself and transported to its
   Gram matrix without changing the nullspace. -/
theorem gram_factor_kernel_eq {ι κ : Type*} [Fintype ι] [Fintype κ]
    (C : Matrix κ ι ℂ) :
    (C.conjTranspose * C).mulVecLin.ker = C.mulVecLin.ker := by
  exact Matrix.ker_mulVecLin_conjTranspose_mul_self C

theorem bounded_profile_memory_ge
    {ι κ : Type*} [Fintype ι] [DecidableEq ι] [Fintype κ]
    (a : ι → Nat) (C : Matrix κ (Profile a) ℂ) (q : Nat)
    (hker : Module.finrank ℂ
      (LinearMap.ker (C.conjTranspose * C).mulVecLin) ≤ q) :
    (∏ i : ι, (a i + 1)) - q ≤ Fintype.card κ := by
  exact (bounded_profile_rank_ge a (C.conjTranspose * C) q hker).trans
    (gram_factor_rank_le_memory_card C)

end D5.S3.Quantum.Entanglement.StationaryOccupationRankNullity
