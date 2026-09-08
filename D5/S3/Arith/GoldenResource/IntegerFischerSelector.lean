/- GID: D5/S3/Arith/GoldenResource/IntegerFischerSelector
   generality: G
   mirror-B: D5/B/S3/Arith/GoldenResource/IntegerFischerSelector
   mirror-E: none(waiver:general-matrix-inequality)
   anchors: []
   utility: none
   digest: Fischer bounds give a dimension-independent gap for the integer log selector. -/

import D5.S3.Arith.GoldenResource.IntegerHadamard
import D5.S3.Arith.GoldenResource.DiscreteLogSelector
import Mathlib.LinearAlgebra.Matrix.Transvection

namespace D5.S3.Arith.GoldenResource.IntegerFischerSelector

open Matrix
open scoped ComplexOrder MatrixOrder

noncomputable section

variable {n : Type*} [Fintype n] [DecidableEq n]

-- Reuse the existing private proofs without modifying their frozen source module.
local macro "inheritedComplexPosDef" : term =>
  pure (Lean.mkIdent (Lean.mkPrivateNameCore
    `D5.S3.Arith.GoldenResource.IntegerHadamard
    `D5.S3.Arith.GoldenResource.IntegerHadamard.complex_posDef))

local macro "inheritedComplexHadamard" : term =>
  pure (Lean.mkIdent (Lean.mkPrivateNameCore
    `D5.S3.Arith.GoldenResource.IntegerHadamard
    `D5.S3.Arith.GoldenResource.IntegerHadamard.complex_hadamard))

private theorem real_hadamard {A : Matrix n n ℝ} (hA : A.PosDef) :
    A.det ≤ ∏ i, A i i := by
  have hc := inheritedComplexPosDef hA
  have h := (inheritedComplexHadamard hc).1
  have hd : (A.map Complex.ofReal).det = (A.det : ℂ) := by
    simpa [Complex.ofRealHom] using (Complex.ofRealHom.map_det A).symm
  simpa [hd] using h

private theorem prod_pair_complement (d : n → ℝ) {i j : n} (hij : i ≠ j) :
    ∏ l, d l = (d i * d j) * ∏ l ∈ Finset.univ \ {i, j}, d l := by
  have h := Finset.prod_sdiff (f := d) (Finset.subset_univ ({i, j} : Finset n))
  rw [Finset.prod_pair hij] at h
  simpa [mul_comm] using h.symm

/-- Fischer's determinant bound retaining a specified two-coordinate principal block. -/
theorem fischer_two_block (T : Matrix n n ℝ) (hT : T.PosDef) {i j : n} (hij : i ≠ j) :
    T.det ≤ (T i i * T j j - T i j * T j i) * ∏ l ∈ Finset.univ \ {i, j}, T l l := by
  let c := -T i j / T i i
  let Q := transvection i j c
  let S := Qᴴ * T * Q
  have hQ : Q.det = 1 := det_transvection_of_ne i j hij c
  have hS : S.PosDef := hT.conjTranspose_mul_mul_same
    (mulVec_injective_of_det_ne_zero (by rw [hQ]; exact one_ne_zero))
  have hQt : Qᴴ = transvection j i c := by
    simp [Q, transvection]
  have hd : S.det = T.det := by simp [S, det_mul, hQ]
  have hother (l : n) (hl : l ≠ j) : S l l = T l l := by
    simp only [S, hQt, Q, mul_transvection_apply_of_ne _ _ _ _ hl,
      transvection_mul_apply_of_ne _ _ _ _ hl]
  have hjj : S j j = T j j - T j i * T i j / T i i := by
    simp only [S, hQt, Q, mul_transvection_apply_same, transvection_mul_apply_same]
    dsimp [c]
    field_simp [ne_of_gt (hT.diag_pos (i := i))]
    ring
  have hp : ∏ l, S l l =
      (T i i * T j j - T i j * T j i) * ∏ l ∈ Finset.univ \ {i, j}, T l l := by
    rw [prod_pair_complement (fun l => S l l) hij, hother i hij, hjj]
    have hr : ∏ l ∈ Finset.univ \ {i, j}, S l l =
        ∏ l ∈ Finset.univ \ {i, j}, T l l := by
      apply Finset.prod_congr rfl
      intro l hl
      apply hother
      have hm : l ≠ i ∧ l ≠ j := by simpa using hl
      exact hm.2
    rw [hr]
    congr 1
    field_simp [ne_of_gt (hT.diag_pos (i := i))]
  simpa [hd, hp] using real_hadamard hS

/-- A nonzero off-diagonal integer entry gives a multiplicative determinant loss. -/
theorem integer_fischer_gap (T : Matrix n n ℤ)
    (hT : (T.map fun z => (z : ℝ)).PosDef) {i j : n}
    (hij : i ≠ j) (hoff : T i j ≠ 0) :
    T.det * (T i i * T j j) ≤ (T i i * T j j - 1) * ∏ l, T l l := by
  have hf := fischer_two_block (T.map fun z => (z : ℝ)) hT hij
  rw [← Int.cast_det] at hf
  simp only [Matrix.map_apply] at hf
  have hfi : T.det ≤ (T i i * T j j - T i j * T j i) *
      ∏ l ∈ Finset.univ \ {i, j}, T l l := by exact_mod_cast hf
  have hsym : T j i = T i j := by
    have h := hT.isHermitian.apply i j
    simpa using h
  have hsquare : 1 ≤ T i j * T j i := by
    rw [hsym]
    have h := sq_pos_of_ne_zero hoff
    nlinarith
  have hdiag := (IntegerHadamard.integer_posDef_hadamard T hT).1
  have hr : 0 ≤ ∏ l ∈ Finset.univ \ {i, j}, T l l :=
    Finset.prod_nonneg fun l _ => le_of_lt (hdiag l)
  have hbound : T.det ≤ (T i i * T j j - 1) *
      ∏ l ∈ Finset.univ \ {i, j}, T l l :=
    hfi.trans (mul_le_mul_of_nonneg_right (by linarith) hr)
  have hp := Finset.prod_sdiff (f := fun l => T l l)
    (Finset.subset_univ ({i, j} : Finset n))
  rw [Finset.prod_pair hij] at hp
  calc
    T.det * (T i i * T j j) ≤
        ((T i i * T j j - 1) * ∏ l ∈ Finset.univ \ {i, j}, T l l) *
          (T i i * T j j) :=
      mul_le_mul_of_nonneg_right hbound (le_of_lt (mul_pos (hdiag i) (hdiag j)))
    _ = (T i i * T j j - 1) * ∏ l, T l l := by rw [mul_assoc, hp]

/-- The smaller scalar endpoint margin and the two-coordinate determinant loss. -/
def selectorGap (k : ℕ) (p : ℝ) : ℝ :=
  min (min (Real.log ((k : ℝ) / (k - 1 : ℕ)) - p)
    (p - Real.log (((k + 1 : ℕ) : ℝ) / k)))
    (Real.log ((k : ℝ) ^ 2) - Real.log ((k : ℝ) ^ 2 - 1))

/-- The selector gap is positive throughout the strict price window. -/
theorem selectorGap_pos {k : ℕ} (hk : 2 ≤ k) {p : ℝ}
    (hlo : Real.log (((k + 1 : ℕ) : ℝ) / k) < p)
    (hhi : p < Real.log ((k : ℝ) / (k - 1 : ℕ))) :
    0 < selectorGap k p := by
  have hkR : (2 : ℝ) ≤ k := by exact_mod_cast hk
  have hs : 0 < (k : ℝ) ^ 2 - 1 := by nlinarith
  exact lt_min (lt_min (sub_pos.mpr hhi) (sub_pos.mpr hlo))
    (sub_pos.mpr (Real.strictMonoOn_log hs
      (show 0 < (k : ℝ) ^ 2 by nlinarith) (by linarith)))

#print axioms fischer_two_block
#print axioms integer_fischer_gap
#print axioms selectorGap_pos

end
end D5.S3.Arith.GoldenResource.IntegerFischerSelector
