/- GID: D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity
   generality: G
   mirror-B: D5/B/S3/Quantum/Entanglement/StationaryOccupationRankNullity
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: A finite Gram matrix turns an explicit kernel-dimension bound into a rank lower bound.
   -/

import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Rank

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

open scoped BigOperators

namespace D5.S3.Quantum.Entanglement.StationaryOccupationRankNullity

/- A bounded occupation profile is a choice of one coordinate in each finite
   interval.  The same type is used for the finite index set of the source's
   Gram matrix; no numerical rank is hidden in this definition. -/
def BoundedProfile (ι : Type*) [Fintype ι] [DecidableEq ι] (a : ι → Nat) :=
  ∀ i, Fin (a i + 1)

instance boundedProfileFintype {ι : Type*} [Fintype ι] [DecidableEq ι]
    (a : ι → Nat) : Fintype (BoundedProfile ι a) := by
  dsimp [BoundedProfile]
  infer_instance

instance boundedProfileDecidableEq {ι : Type*} [Fintype ι] [DecidableEq ι]
    (a : ι → Nat) : DecidableEq (BoundedProfile ι a) := by
  dsimp [BoundedProfile]
  infer_instance

theorem bounded_profile_card {ι : Type*} [Fintype ι] [DecidableEq ι]
    (a : ι → Nat) :
    Fintype.card (BoundedProfile ι a) = ∏ i : ι, (a i + 1) := by
  change Fintype.card ((i : ι) → Fin (a i + 1)) = _
  rw [Fintype.card_pi]
  simp only [Fintype.card_fin]

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
    (G : Matrix (BoundedProfile ι a) (BoundedProfile ι a) ℂ)
    (q : Nat)
    (hker : Module.finrank ℂ (LinearMap.ker G.mulVecLin) ≤ q) :
    (∏ i : ι, (a i + 1)) - q ≤ G.rank := by
  rw [← bounded_profile_card a]
  exact gram_rank_ge_card_sub_nullity G q hker

end D5.S3.Quantum.Entanglement.StationaryOccupationRankNullity
