import Mathlib

open Matrix
open scoped ComplexOrder

namespace Triage89

noncomputable def qform {n : Type*} [Fintype n]
    (M : Matrix n n Complex) (v : n -> Complex) : Complex :=
  dotProduct (Matrix.vecMul (star v) M) v

theorem schur_minimum {m n : Type*} [Fintype m] [Fintype n] [DecidableEq n]
    (A : Matrix m m Complex) (B : Matrix m n Complex) (C : Matrix n n Complex)
    (hC : C.PosDef) (x : m -> Complex) :
    IsLeast (Set.range (fun y : n -> Complex =>
      qform (Matrix.fromBlocks A B (Matrix.conjTranspose B) C) (Sum.elim x y)))
      (qform (A - B * Inv.inv C * Matrix.conjTranspose B) x) := by
  letI := hC.isUnit.invertible
  constructor
  · refine ⟨-(Matrix.mulVec (Inv.inv C * Matrix.conjTranspose B) x), ?_⟩
    dsimp [qform]
    rw [Matrix.schur_complement_eq₂₂ A B x _ hC.isHermitian]
    simp
  · rintro _ ⟨y, rfl⟩
    dsimp [qform]
    rw [Matrix.schur_complement_eq₂₂ A B x y hC.isHermitian]
    have h := hC.posSemidef.dotProduct_mulVec_nonneg
      (Matrix.mulVec (Inv.inv C * Matrix.conjTranspose B) x + y)
    rw [Matrix.dotProduct_mulVec] at h
    exact le_add_of_nonneg_left h

#print axioms schur_minimum

end Triage89
