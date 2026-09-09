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
  split_ifs with h
  · subst j; rfl
  · rfl

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
  simp only [Matrix.sub_apply, Matrix.mul_apply, of_apply, diagonal_apply, mul_ite, mul_zero,
    Finset.sum_ite_eq', Finset.mem_univ, if_true]
  congr 1
  apply Finset.sum_congr rfl
  intro i _
  have hs := Real.sq_sqrt (heta i)
  dsimp [v]
  rw [div_eq_mul_inv]
  nlinarith only [hs]

theorem nodal_derivative (n : ℕ) (q : ℝ[X]) (t : Fin (n+1) → ℝ)
    (ht : Function.Injective t) (hq : q.natDegree ≤ n+2) (hmonic : q.coeff (n+2) = 1)
    (hcrit : ∀ i, q.derivative.eval (t i) = 0) :
    q.derivative = C ((n+2 : ℕ) : ℝ) * Lagrange.nodal Finset.univ t := by
  have hdeg : q.natDegree = n+2 :=
    natDegree_eq_of_le_of_coeff_ne_zero hq (by rw [hmonic]; exact one_ne_zero)
  have hqmonic : q.Monic := by simpa only [Monic, leadingCoeff, hdeg] using hmonic
  have hd : ((n+2 : ℕ) : ℝ) ≠ 0 := by exact_mod_cast (show n+2 ≠ 0 by omega)
  have hder : q.derivative.degree = (n+1 : ℕ) := by
    rw [degree_eq_natDegree (derivative_ne_zero.mpr (by omega)), natDegree_derivative, hdeg]
    simp
  apply Polynomial.eq_of_degree_le_of_eval_index_eq Finset.univ ht.injOn
  · simpa using hder.le
  · rw [hder, degree_C_mul hd, Lagrange.degree_nodal]
    simp
  · rw [leadingCoeff_derivative, hqmonic, hdeg,
      Lagrange.nodal_monic.leadingCoeff_C_mul]
    simp
  · intro i _
    simp [hcrit, Lagrange.eval_nodal_at_node (Finset.mem_univ i)]


theorem q_ratio_formula (n : ℕ) (q : ℝ[X]) (a : ℝ)
    (t : Fin (n+1) → ℝ) (ht : Function.Injective t)
    (hdeg : q.natDegree ≤ n+2) (hmonic : q.coeff (n+2) = 1)
    (hlinear : q.coeff (n+1) = -a)
    (hcrit : ∀ i, q.derivative.eval (t i) = 0)
    (x : ℝ) (hx : ∀ i, x ≠ t i) :
    (∏ i, (x-t i)) * (x-a/((n+2 : ℕ) : ℝ) -
      ∑ i, (-((n+2 : ℕ) : ℝ)*q.eval (t i)/q.derivative.derivative.eval (t i))/(x-t i)) =
      q.eval x := by
  let d : ℝ := ((n+2 : ℕ) : ℝ)
  have hd : d ≠ 0 := by dsimp [d]; exact_mod_cast (show n+2 ≠ 0 by omega)
  have hdc : (n : ℝ) + 2 ≠ 0 := by exact_mod_cast (show n+2 ≠ 0 by omega)
  let R := q - C d⁻¹ * X * q.derivative + C (a / d^2) * q.derivative
  have hc (k : ℕ) : R.coeff k = q.coeff k - d⁻¹ * (q.coeff k * (k : ℝ)) +
      (a/d^2) * (q.coeff (k+1) * ((k+1 : ℕ) : ℝ)) := by
    have hh : (X*q.derivative).coeff k = q.coeff k * (k : ℝ) := by
      cases k <;> simp [coeff_X_mul, coeff_derivative]
    simp only [R, coeff_add, coeff_sub, mul_assoc, coeff_C_mul, hh, coeff_derivative]
    push_cast
    rfl
  have hRdeg : R.degree < (n+1 : ℕ) := by
    apply (degree_lt_iff_coeff_zero R (n+1)).mpr
    intro k hk
    rw [hc]
    by_cases hk₁ : k = n+1
    · subst k
      rw [hlinear, hmonic]
      dsimp [d]
      push_cast
      field_simp [hdc]
      ring
    · by_cases hk₂ : k = n+2
      · subst k
        rw [hmonic, coeff_eq_zero_of_natDegree_lt (by omega : q.natDegree < n+2+1)]
        dsimp [d]
        push_cast
        field_simp [hdc]
        ring
      · rw [coeff_eq_zero_of_natDegree_lt (by omega : q.natDegree < k),
          coeff_eq_zero_of_natDegree_lt (by omega : q.natDegree < k+1)]
        ring
  have hRe (i : Fin (n+1)) : R.eval (t i) = q.eval (t i) := by
    simp [R, hcrit]
  have hnodal := nodal_derivative n q t ht hdeg hmonic hcrit
  have hdd (i : Fin (n+1)) : q.derivative.derivative.eval (t i) =
      d * ∏ j ∈ Finset.univ.erase i, (t i-t j) := by
    rw [hnodal, derivative_C_mul, eval_mul, eval_C,
      Lagrange.eval_nodal_derivative_eval_node_eq (Finset.mem_univ i), Lagrange.eval_nodal]
  have hinterp := Lagrange.eq_interpolate (s := Finset.univ) (v := t) (f := R)
    ht.injOn (by simpa using hRdeg)
  have hv := congrArg (fun f : ℝ[X] => f.eval x) hinterp
  rw [Lagrange.eval_interpolate_not_at_node _ (fun i _ => hx i)] at hv
  simp only [hRe] at hv
  have hs : (∑ i, Lagrange.nodalWeight Finset.univ t i * (x-t i)⁻¹ * q.eval (t i)) =
      -(∑ i, (-d*q.eval (t i)/q.derivative.derivative.eval (t i))/(x-t i)) := by
    rw [← Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro i _
    rw [Lagrange.nodalWeight_eq_eval_nodal_erase_inv, Lagrange.eval_nodal, hdd]
    simp [div_eq_mul_inv, mul_inv, hd, mul_assoc, mul_left_comm, mul_comm]
  have hder : q.derivative.eval x = d * (∏ i, (x-t i)) := by
    rw [hnodal, eval_mul, eval_C, Lagrange.eval_nodal]
  rw [hs, Lagrange.eval_nodal] at hv
  simp only [R, eval_add, eval_sub, eval_mul, eval_C, eval_X, hder] at hv
  change (∏ i, (x-t i)) * (x-a/d -
    ∑ i, (-d*q.eval (t i)/q.derivative.derivative.eval (t i))/(x-t i)) = q.eval x
  field_simp [hd] at hv ⊢
  linear_combination -hv


def LaguerreAt (p : ℝ[X]) (x : ℝ) : Prop :=
  0 ≤ p.derivative.eval x ^ 2 - p.eval x * p.derivative.derivative.eval x

theorem laguerre_mul (p q : ℝ[X]) (x : ℝ)
    (hp : LaguerreAt p x) (hq : LaguerreAt q x) : LaguerreAt (p*q) x := by
  have h := add_nonneg (mul_nonneg (sq_nonneg (q.eval x)) hp)
    (mul_nonneg (sq_nonneg (p.eval x)) hq)
  dsimp only [LaguerreAt] at hp hq ⊢
  convert h using 1 <;>
    simp only [derivative_mul, derivative_add, eval_add, eval_mul] <;> ring

theorem laguerre_splits (p : ℝ[X]) (hp : p.Splits) (x : ℝ) : LaguerreAt p x := by
  have hprod (s : Multiset ℝ) : LaguerreAt (s.map (fun z => X-C z)).prod x := by
    induction s using Multiset.induction_on with
    | empty => simp [LaguerreAt]
    | @cons z s ih =>
      rw [Multiset.map_cons, Multiset.prod_cons]
      exact laguerre_mul _ _ x (by simp [LaguerreAt]) ih
  rw [hp.eq_prod_roots]
  exact laguerre_mul _ _ x (by simp [LaguerreAt]) (hprod _)

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
  change (arrow n a t _).charpoly.eval x = q.eval x
  rw [arrow_schur n a t _ heta x hxt]
  exact q_ratio_formula n q a t ht hdeg hmonic hlinear hcrit x hxt

theorem b3_residue_sign_target (n : ℕ) (q : ℝ[X]) (x : ℝ)
    (hsplit : q.Splits) (hcrit : q.derivative.eval x = 0)
    (hsecond : q.derivative.derivative.eval x ≠ 0) :
    0 ≤ -((n+2 : ℕ) : ℝ)*q.eval x/q.derivative.derivative.eval x := by
  have hL := laguerre_splits q hsplit x
  have hm : 0 ≤ -q.eval x * q.derivative.derivative.eval x := by
    simpa [LaguerreAt, hcrit] using hL
  calc
    _ = ((n+2 : ℕ) : ℝ) * (-q.eval x * q.derivative.derivative.eval x) /
      q.derivative.derivative.eval x ^ 2 := by field_simp; ring
    _ ≥ 0 := div_nonneg (mul_nonneg (by positivity) hm) (sq_nonneg _)

#print axioms laguerre_splits

def PositiveSplit (q : ℝ[X]) : Prop := q.Splits ∧ ∀ x, q.eval x = 0 → 0 < x

theorem b3_full (n : ℕ) (q : ℝ[X]) (a : ℝ)
    (t : Fin (n+1) → ℝ) (ht : Function.Injective t)
    (hdeg : q.natDegree ≤ n+2) (hmonic : q.coeff (n+2) = 1)
    (hlinear : q.coeff (n+1) = -a)
    (hcrit : ∀ i, q.derivative.eval (t i) = 0)
    (hno : ∀ x, x ≤ 0 → q.eval x ≠ 0) :
    let eta := fun i => -((n+2 : ℕ) : ℝ)*q.eval (t i)/q.derivative.derivative.eval (t i)
    (PositiveSplit q ↔ ∀ i, 0 ≤ eta i) ∧
      ((∀ i, 0 ≤ eta i) → (arrow n a t eta).PosDef ∧ (arrow n a t eta).charpoly = q) := by
  dsimp only
  let eta := fun i => -((n+2 : ℕ) : ℝ)*q.eval (t i)/q.derivative.derivative.eval (t i)
  have hnonzero (i : Fin (n+1)) : q.derivative.derivative.eval (t i) ≠ 0 := by
    have hnodal := nodal_derivative n q t ht hdeg hmonic hcrit
    rw [hnodal, derivative_C_mul, eval_mul, eval_C,
      Lagrange.eval_nodal_derivative_eval_node_eq (Finset.mem_univ i), Lagrange.eval_nodal]
    apply mul_ne_zero (by positivity)
    apply Finset.prod_ne_zero_iff.mpr
    intro j hj
    apply sub_ne_zero.mpr
    exact fun h => (Finset.mem_erase.mp hj).1 (ht h).symm
  have hrootpos : ∀ x, q.eval x = 0 → 0 < x := by
    intro x hx
    exact lt_of_not_ge (fun h => hno x h hx)
  have hc (he : ∀ i, 0 ≤ eta i) : (arrow n a t eta).charpoly = q :=
    b3_charpoly_target n q a t ht hdeg hmonic hlinear hcrit he
  have hh := arrow_hermitian n a t eta
  have hpd (he : ∀ i, 0 ≤ eta i) : (arrow n a t eta).PosDef := by
    apply hh.posDef_iff_eigenvalues_pos.mpr
    intro i
    apply hrootpos
    rw [← hc he, hh.charpoly_eq, eval_prod]
    apply Finset.prod_eq_zero (Finset.mem_univ i)
    simp
  refine ⟨⟨?_, ?_⟩, fun he => ⟨hpd he, hc he⟩⟩
  · intro hp i
    exact b3_residue_sign_target n q (t i) hp.1 (hcrit i) (hnonzero i)
  · intro he
    refine ⟨?_, hrootpos⟩
    rw [← hc he, hh.charpoly_eq]
    exact Splits.prod (fun i _ => Splits.X_sub_C _)

#print axioms b3_full

#print axioms arrow_hermitian
#print axioms arrow_schur
#print axioms b3_charpoly_target
#print axioms b3_residue_sign_target
end QdB3Probe
