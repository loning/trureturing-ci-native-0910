/- GID: D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity
   generality: G
   mirror-B: D5/B/S3/Quantum/Entanglement/StationaryOccupationRankNullity
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: A finite Gram matrix turns an explicit kernel-dimension bound into a rank lower bound. -/

import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Rank
import D5.S3.Quantum.Entanglement.BoundedProfileCardinality

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

open scoped BigOperators

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

end D5.S3.Quantum.Entanglement.StationaryOccupationRankNullity
