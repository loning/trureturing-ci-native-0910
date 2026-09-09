import Mathlib.LinearAlgebra.Lagrange
import Mathlib.LinearAlgebra.Matrix.SchurComplement
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.Matrix.PosDef
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.Tactic

noncomputable section
open Polynomial Matrix
namespace QdB3Probe

def arrow (n : ℕ) (a : ℝ) (t eta : Fin (n+1) → ℝ) :
    Matrix (Fin 1 ⊕ Fin (n+1)) (Fin 1 ⊕ Fin (n+1)) ℝ :=
  fromBlocks (of fun _ _ => a / ((n+2 : ℕ) : ℝ))
    (of fun _ i => Real.sqrt (eta i)) (of fun i _ => Real.sqrt (eta i)) (diagonal t)

theorem arrow_hermitian (n : ℕ) (a : ℝ) (t eta : Fin (n+1) → ℝ) :
    (arrow n a t eta).IsHermitian := by
  ext (i | i) (j | j) <;> simp [arrow, Matrix.fromBlocks, conjTranspose_apply, diagonal, eq_comm]

theorem arrow_schur (n : ℕ) (a : ℝ) (t eta : Fin (n+1) → ℝ)
    (heta : ∀ i, 0 ≤ eta i) (x : ℝ) (hx : ∀ i, x ≠ t i) :
    (arrow n a t eta).charpoly.eval x =
      (∏ i, (x-t i)) * (x-a/((n+2 : ℕ) : ℝ) - ∑ i, eta i/(x-t i)) := by
  let v : Fin (n+1) → ℝ := fun i => x-t i
  letI : Invertible v := {
    invOf := fun i => (x-t i)⁻¹
    invOf_mul_self := by funext i; exact inv_mul_cancel₀ (sub_ne_zero.mpr (hx i))
    mul_invOf_self := by funext i; exact mul_inv_cancel₀ (sub_ne_zero.mpr (hx i)) }
  letI : Invertible (diagonal v) := diagonalInvertible v
  have hinv : ⅟(diagonal v) = diagonal (fun i => (x-t i)⁻¹) := by
    rw [invOf_diagonal_eq]
    rfl
  rw [eval_charpoly]
  have hm : scalar (Fin 1 ⊕ Fin (n+1)) x - arrow n a t eta =
      fromBlocks (of fun _ _ : Fin 1 => x-a/((n+2 : ℕ) : ℝ))
        (of fun (_ : Fin 1) i => -Real.sqrt (eta i))
        (of fun i (_ : Fin 1) => -Real.sqrt (eta i)) (diagonal v) := by
    ext (i | i) (j | j)
    · simp [arrow, Matrix.fromBlocks, scalar, diagonal, v, Subsingleton.elim i j]
    · simp [arrow, Matrix.fromBlocks, scalar, diagonal, v]
    · simp [arrow, Matrix.fromBlocks, scalar, diagonal, v]
    · by_cases hij : i = j <;> simp [arrow, Matrix.fromBlocks, scalar, diagonal, v, hij]
  rw [hm, det_fromBlocks₂₂, det_diagonal, det_fin_one, hinv]
  congr 1
  simp only [sub_apply, mul_apply, diagonal_apply, mul_ite, mul_zero,
    Finset.sum_ite_eq', Finset.mem_univ, if_true]
  congr 1
  apply Finset.sum_congr rfl
  intro i _
  have hs := Real.sq_sqrt (heta i)
  dsimp [v]
  rw [div_eq_mul_inv]
  nlinarith only [hs]

-- These are the exact missing mathematical interfaces of this attempted assembly.
-- The first is tested against Schur plus interpolation, with no charpoly assumption.
theorem b3_charpoly_target (n : ℕ) (q : ℝ[X]) (a : ℝ)
    (t : Fin (n+1) → ℝ) (ht : Function.Injective t)
    (hdeg : q.natDegree ≤ n+2) (hmonic : q.coeff (n+2) = 1)
    (hlinear : q.coeff (n+1) = -a)
    (hcrit : ∀ i, q.derivative.eval (t i) = 0)
    (heta : ∀ i, 0 ≤ -((n+2 : ℕ) : ℝ)*q.eval (t i)/q.derivative.derivative.eval (t i)) :
    (arrow n a t (fun i => -((n+2 : ℕ) : ℝ)*q.eval (t i)/
      q.derivative.derivative.eval (t i))).charpoly = q := by
  apply Polynomial.eq_of_infinite_eval_eq
  apply (Set.infinite_univ.sdiff (Set.finite_range t)).mono
  intro x hx
  have hxt : ∀ i, x ≠ t i := by
    intro i hi
    exact hx.2 ⟨i, hi.symm⟩
  rw [arrow_schur n a t _ heta x hxt]
  -- Schur has reduced the exact determinant target to this rational identity.
  simp only [Set.mem_setOf_eq]

theorem b3_residue_sign_target (n : ℕ) (q : ℝ[X]) (x : ℝ)
    (hsplit : q.Splits) (hcrit : q.derivative.eval x = 0)
    (hsecond : q.derivative.derivative.eval x ≠ 0) :
    0 ≤ -((n+2 : ℕ) : ℝ)*q.eval x/q.derivative.derivative.eval x := by
  by_cases hx : q.eval x = 0
  · simp [hx]
  have hlog := hsplit.eval_derivative_div_eval_of_ne_zero hx
  rw [hcrit, zero_div] at hlog
  -- The value of the logarithmic derivative alone supplies no second derivative sign.
  trace_state
  done

#print axioms arrow_hermitian
#print axioms arrow_schur
#print axioms b3_charpoly_target
#print axioms b3_residue_sign_target
end QdB3Probe
