/- GID: D5/S3/Arith/GoldenResource/WeightedDiscreteLogNoGo
   generality: I
   mirror-B: D5/B/S3/Arith/GoldenResource/WeightedDiscreteLogNoGo
   mirror-E: none(waiver:exact-real-inequalities)
   anchors: []
   utility: kind=certified-instance; basis=refutes=gid:D5/S3/Arith/GoldenResource/WeightedDiscreteLogNoGo.uniformSelection
   digest: Unequal coordinate prices uniquely select the nonscalar integral matrix diag(2,3). -/

import D5.S3.Arith.GoldenResource.DiscreteLogSelector
import Mathlib.Algebra.Order.Star.Real
import Mathlib.Analysis.Matrix.PosDef
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Tactic.FinCases

namespace D5.S3.Arith.GoldenResource.WeightedDiscreteLogNoGo

noncomputable section

/-- The real matrix associated to an integral two by two matrix. -/
def realMatrix (T : Matrix (Fin 2) (Fin 2) ℤ) : Matrix (Fin 2) (Fin 2) ℝ :=
  T.map (Int.castRingHom ℝ)

/-- The open window for the two effective prices. -/
def priceWindow (p : ℝ) : Prop :=
  (Real.log (3 / 2 : ℝ) < 3 * p ∧ 3 * p < Real.log 2) ∧
  (Real.log (4 / 3 : ℝ) < 2 * p ∧ 2 * p < Real.log (3 / 2 : ℝ))

/-- The weighted logarithmic objective on integral matrices. -/
def objective (p : ℝ) (T : Matrix (Fin 2) (Fin 2) ℤ) : ℝ :=
  Real.log (realMatrix T).det - p * (3 * (T 0 0 : ℝ) + 2 * (T 1 1 : ℝ))

/-- The selected matrix has distinct diagonal entries. -/
def selectedMatrix : Matrix (Fin 2) (Fin 2) ℤ := !![2, 0; 0, 3]

/-- The assertion that uniqueness throughout such a price window forces equal diagonals. -/
def uniformSelection : Prop :=
  ∀ p : ℝ, priceWindow p → ∀ T : Matrix (Fin 2) (Fin 2) ℤ,
    (realMatrix T).PosDef →
    (∀ U : Matrix (Fin 2) (Fin 2) ℤ, (realMatrix U).PosDef →
      U ≠ T → objective p U < objective p T) → T 0 0 = T 1 1

/-- All four strict inequalities hold at the rational price one sixth. -/
theorem one_sixth_mem_priceWindow : priceWindow (1 / 6) := by
  have h32 := Real.log_lt_sub_one_of_pos (by norm_num : (0 : ℝ) < 3 / 2)
    (by norm_num : (3 / 2 : ℝ) ≠ 1)
  have h43 := Real.log_lt_sub_one_of_pos (by norm_num : (0 : ℝ) < 4 / 3)
    (by norm_num : (4 / 3 : ℝ) ≠ 1)
  have h12 := Real.log_lt_sub_one_of_pos (by norm_num : (0 : ℝ) < 2⁻¹)
    (by norm_num : (2⁻¹ : ℝ) ≠ 1)
  have h23 := Real.log_lt_sub_one_of_pos (by norm_num : (0 : ℝ) < (3 / 2)⁻¹)
    (by norm_num : ((3 / 2)⁻¹ : ℝ) ≠ 1)
  rw [Real.log_inv] at h12 h23
  norm_num at h32 h43 h12 h23
  unfold priceWindow
  constructor <;> constructor <;> norm_num <;> linarith

/-- The specified price window is nonempty. -/
theorem priceWindow_nonempty : ∃ p : ℝ, priceWindow p :=
  ⟨1 / 6, one_sixth_mem_priceWindow⟩

/-- The proposed optimizer is positive definite over the reals. -/
theorem selectedMatrix_posDef : (realMatrix selectedMatrix).PosDef := by
  have heq : realMatrix selectedMatrix = Matrix.diagonal ![2, 3] := by
    ext i j
    fin_cases i <;> fin_cases j <;> norm_num [realMatrix, selectedMatrix, Matrix.diagonal]
  rw [heq]
  apply Matrix.PosDef.diagonal
  intro i
  fin_cases i <;> norm_num

#print axioms one_sixth_mem_priceWindow
#print axioms priceWindow_nonempty
#print axioms selectedMatrix_posDef

end
end D5.S3.Arith.GoldenResource.WeightedDiscreteLogNoGo
