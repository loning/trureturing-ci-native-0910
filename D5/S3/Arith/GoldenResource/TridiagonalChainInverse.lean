/- GID: D5/S3/Arith/GoldenResource/TridiagonalChainInverse
   generality: G
   mirror-B: D5/B/S3/Arith/GoldenResource/TridiagonalChainInverse
   mirror-E: none(waiver:general-matrix-family)
   anchors: []
   utility: none
   digest: The 4,-1 chain has an explicit inverse column and exponentially small endpoints. -/

import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic

namespace D5.S3.Arith.GoldenResource.TridiagonalChainInverse

open Matrix
open scoped BigOperators

noncomputable section

/-- The integral recurrence associated with the diagonal-four chain. -/
def chainDet : ℕ → ℤ
  | 0 => 1
  | 1 => 4
  | n + 2 => 4 * chainDet (n + 1) - chainDet n

private theorem chainDet_growth (n : ℕ) :
    0 < chainDet n ∧ 3 * chainDet n ≤ chainDet (n + 1) := by
  induction n with
  | zero => norm_num [chainDet]
  | succ n ih =>
    have hp : 0 < chainDet (n + 1) := by omega
    constructor
    · exact hp
    · change 3 * chainDet (n + 1) ≤ 4 * chainDet (n + 1) - chainDet n
      omega

/-- Every term of the chain recurrence is positive. -/
theorem chainDet_pos (n : ℕ) : 0 < chainDet n := (chainDet_growth n).1

/-- The recurrence grows at least geometrically with ratio three. -/
theorem chainDet_ge_three_pow (n : ℕ) : (3 : ℤ) ^ n ≤ chainDet n := by
  induction n with
  | zero => norm_num [chainDet]
  | succ n ih =>
    have h := (chainDet_growth n).2
    rw [pow_succ]
    nlinarith

/-- Squared denominators grow at least geometrically with ratio nine. -/
theorem chainDet_sq_ge_nine_pow (n : ℕ) : (9 : ℤ) ^ n ≤ chainDet n ^ 2 := by
  have h := chainDet_ge_three_pow n
  have hp : 0 ≤ (3 : ℤ) ^ n := by positivity
  have he : (9 : ℤ) ^ n = ((3 : ℤ) ^ n) ^ 2 := by
    rw [← pow_mul, mul_comm n 2, pow_mul]
    norm_num
  rw [he]
  nlinarith

private def upper (m : ℕ) : Matrix (Fin m) (Fin m) ℝ :=
  fun i j => if i.val + 1 = j.val then 1 else 0

/-- The real tridiagonal matrix with diagonal four and adjacent entries minus one. -/
def H (m : ℕ) : Matrix (Fin m) (Fin m) ℝ :=
  (4 : ℝ) • (1 : Matrix (Fin m) (Fin m) ℝ) - upper m - (upper m)ᵀ

/-- Entrywise description of the chain, including its boundary rows. -/
theorem chain_apply (m : ℕ) (i j : Fin m) :
    H m i j = if i = j then 4 else
      if i.val + 1 = j.val ∨ j.val + 1 = i.val then -1 else 0 := by
  simp only [H, Matrix.sub_apply, Matrix.smul_apply, Matrix.one_apply,
    smul_eq_mul, Matrix.transpose_apply, upper]
  by_cases he : i = j
  · subst j
    simp
  · have hne : i.val ≠ j.val := fun h => he (Fin.ext h)
    split_ifs <;> simp_all <;> omega

private theorem upper_mulVec {m : ℕ} (x : Fin m → ℝ) (i : Fin m) :
    (upper m *ᵥ x) i = if h : i.val + 1 < m then x ⟨i.val + 1, h⟩ else 0 := by
  classical
  simp only [mulVec, dotProduct, upper, ite_mul, one_mul, zero_mul]
  split_ifs with h
  · have he (j : Fin m) : i.val + 1 = j.val ↔ j = ⟨i.val + 1, h⟩ := by
      simp only [Fin.ext_iff]
      omega
    simp only [he]
    simp
  · apply Finset.sum_eq_zero
    intro j _
    rw [if_neg (by have := j.isLt; omega)]

private theorem lower_mulVec {m : ℕ} (x : Fin m → ℝ) (i : Fin m) :
    ((upper m)ᵀ *ᵥ x) i =
      if h : 0 < i.val then x ⟨i.val - 1, by omega⟩ else 0 := by
  classical
  simp only [mulVec, dotProduct, Matrix.transpose_apply, upper, ite_mul, one_mul, zero_mul]
  split_ifs with h
  · have he (j : Fin m) : j.val + 1 = i.val ↔ j = ⟨i.val - 1, by omega⟩ := by
      simp only [Fin.ext_iff]
      omega
    simp only [he]
    simp
  · apply Finset.sum_eq_zero
    intro j _
    rw [if_neg (by omega)]

private theorem chain_mulVec {m : ℕ} (x : Fin m → ℝ) (i : Fin m) :
    (H m *ᵥ x) i = 4 * x i -
      (if h : i.val + 1 < m then x ⟨i.val + 1, h⟩ else 0) -
      (if h : 0 < i.val then x ⟨i.val - 1, by omega⟩ else 0) := by
  simp [H, sub_mulVec, smul_mulVec, upper_mulVec, lower_mulVec]

private theorem upper_quadratic (n : ℕ) (x : Fin (n + 1) → ℝ) :
    x ⬝ᵥ (upper (n + 1) *ᵥ x) = ∑ i : Fin n, x i.castSucc * x i.succ := by
  rw [dotProduct, Fin.sum_univ_castSucc]
  have hlast : (upper (n + 1) *ᵥ x) (Fin.last n) = 0 := by simp [upper_mulVec]
  rw [hlast, mul_zero, add_zero]
  apply Finset.sum_congr rfl
  intro i _
  congr 1
  simp only [upper_mulVec, Fin.val_castSucc]
  split_ifs with h
  · congr 1
  · omega

private theorem chain_quadratic (n : ℕ) (x : Fin (n + 1) → ℝ) :
    x ⬝ᵥ (H (n + 1) *ᵥ x) =
      4 * ∑ i, x i ^ 2 - 2 * ∑ i : Fin n, x i.castSucc * x i.succ := by
  rw [H, sub_mulVec, sub_mulVec, smul_mulVec, one_mulVec,
    dotProduct_sub, dotProduct_sub, dotProduct_smul, dotProduct_transpose_mulVec,
    upper_quadratic]
  simp only [smul_eq_mul, dotProduct, ← pow_two]
  ring

/-- The energy is a sum of vertex squares, boundary squares, and edge differences. -/
theorem chain_energy (n : ℕ) (x : Fin (n + 1) → ℝ) :
    x ⬝ᵥ (H (n + 1) *ᵥ x) =
      2 * ∑ i, x i ^ 2 + x 0 ^ 2 + x (Fin.last n) ^ 2 +
        ∑ i : Fin n, (x i.castSucc - x i.succ) ^ 2 := by
  rw [chain_quadratic]
  have hfirst := Fin.sum_univ_succ (fun i : Fin (n + 1) => x i ^ 2)
  have hlast := Fin.sum_univ_castSucc (fun i : Fin (n + 1) => x i ^ 2)
  simp_rw [sub_sq, Finset.sum_add_distrib, Finset.sum_sub_distrib,
    mul_assoc, ← Finset.mul_sum]
  linarith

/-- The chain has the dimension-independent lower quadratic bound two. -/
theorem chain_coercive (n : ℕ) (x : Fin (n + 1) → ℝ) :
    2 * ∑ i, x i ^ 2 ≤ x ⬝ᵥ (H (n + 1) *ᵥ x) := by
  rw [chain_energy]
  have he : 0 ≤ ∑ i : Fin n, (x i.castSucc - x i.succ) ^ 2 :=
    Finset.sum_nonneg fun i _ => sq_nonneg _
  nlinarith [sq_nonneg (x 0), sq_nonneg (x (Fin.last n))]

/-- Every chain matrix is positive definite, including the empty matrix. -/
theorem chain_posDef (m : ℕ) : (H m).PosDef := by
  apply Matrix.PosDef.of_dotProduct_mulVec_pos
  · apply Matrix.IsHermitian.ext
    intro i j
    simp [chain_apply, eq_comm, or_comm]
  · intro x hx
    cases m with
    | zero => exact (hx (Subsingleton.elim _ _)).elim
    | succ n =>
      have hsum : 0 < ∑ i, x i ^ 2 := by
        apply Finset.sum_pos'
        · intro i _
          exact sq_nonneg _
        · obtain ⟨i, hi⟩ := Function.ne_iff.mp hx
          exact ⟨i, Finset.mem_univ _, sq_pos_of_ne_zero hi⟩
      have h := chain_coercive n x
      simpa only [star_trivial] using (show 0 < x ⬝ᵥ (H (n + 1) *ᵥ x) by linarith)

#print axioms chainDet_pos
#print axioms chainDet_ge_three_pow
#print axioms chainDet_sq_ge_nine_pow
#print axioms chain_apply
#print axioms chain_energy
#print axioms chain_coercive
#print axioms chain_posDef

end

end D5.S3.Arith.GoldenResource.TridiagonalChainInverse
