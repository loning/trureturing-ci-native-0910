import Mathlib.LinearAlgebra.Lagrange
import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Tactic
noncomputable section
open Polynomial
namespace QdB4Probe

-- Only generic degree/coefficient data and the actual simple critical points.
theorem nodal_derivative (n : ℕ) (q : ℂ[X]) (t : Fin (n+1) → ℂ)
    (ht : Function.Injective t) (hq : q.natDegree ≤ n+2) (hmonic : q.coeff (n+2) = 1)
    (hcrit : ∀ i, q.derivative.eval (t i) = 0) :
    q.derivative = C ((n+2 : ℕ) : ℂ) * Lagrange.nodal Finset.univ t := by
  have hdeg : q.natDegree = n+2 :=
    natDegree_eq_of_le_of_coeff_ne_zero hq (by rw [hmonic]; exact one_ne_zero)
  have hqmonic : q.Monic := by simpa only [Monic, leadingCoeff, hdeg] using hmonic
  have hd : ((n+2 : ℕ) : ℂ) ≠ 0 := by exact_mod_cast (show n+2 ≠ 0 by omega)
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

theorem b4_residue_sum (n : ℕ) (q : ℂ[X]) (t : Fin (n+1) → ℂ) (a₁ a₂ : ℂ)
    (ht : Function.Injective t) (hq : q.natDegree ≤ n+2)
    (h₀ : q.coeff (n+2) = 1) (h₁ : q.coeff (n+1) = -a₁)
    (h₂ : q.coeff n = ((n+1 : ℕ) : ℂ) / ((n+2 : ℕ) : ℂ) * a₂)
    (hcrit : ∀ i, q.derivative.eval (t i) = 0) :
    (∑ i, -((n+2 : ℕ) : ℂ) * q.eval (t i) / q.derivative.derivative.eval (t i)) =
      ((n+1 : ℕ) : ℂ) / ((n+2 : ℕ) : ℂ)^2 * (a₁^2 - 2*a₂) := by
  let d : ℂ := ((n+2 : ℕ) : ℂ)
  have hd : d ≠ 0 := by dsimp [d]; exact_mod_cast (show n+2 ≠ 0 by omega)
  let R := q - C d⁻¹ * X * q.derivative + C (a₁ / d^2) * q.derivative
  have hc (k : ℕ) : R.coeff k = q.coeff k - d⁻¹ * (q.coeff k * (k : ℂ)) +
      (a₁/d^2) * (q.coeff (k+1) * ((k+1 : ℕ) : ℂ)) := by
    have hh : (X*q.derivative).coeff k = q.coeff k * (k : ℂ) := by
      cases k <;> simp [coeff_X_mul, coeff_derivative]
    simp only [R, coeff_add, coeff_sub, mul_assoc, coeff_C_mul, hh, coeff_derivative]
    push_cast
    rfl
  have hRdeg : R.degree < (n+1 : ℕ) := by
    apply (degree_lt_iff_coeff_zero).mpr
    intro k hk
    rw [hc]
    by_cases hk₁ : k = n+1
    · subst k
      rw [h₁, h₀]
      dsimp [d]
      push_cast
      field_simp
      ring
    · by_cases hk₂ : k = n+2
      · subst k
        rw [h₀, coeff_eq_zero_of_natDegree_lt (by omega : q.natDegree < n+2+1)]
        dsimp [d]
        push_cast
        field_simp
        ring
      · rw [coeff_eq_zero_of_natDegree_lt (by omega : q.natDegree < k),
          coeff_eq_zero_of_natDegree_lt (by omega : q.natDegree < k+1)]
        ring
  have hRc : R.coeff n = -(((n+1 : ℕ) : ℂ)/d^2 * (a₁^2-2*a₂)) := by
    rw [hc, h₂, h₁]
    dsimp [d]
    push_cast
    field_simp
    ring
  have hRe (i : Fin (n+1)) : R.eval (t i) = q.eval (t i) := by
    simp [R, hcrit]
  have hnodal := nodal_derivative n q t ht hq h₀ hcrit
  have hdd (i : Fin (n+1)) : q.derivative.derivative.eval (t i) =
      d * ∏ j ∈ Finset.univ.erase i, (t i-t j) := by
    rw [hnodal, derivative_C_mul, eval_mul, eval_C,
      Lagrange.eval_nodal_derivative_eval_node_eq (Finset.mem_univ i), Lagrange.eval_nodal]
  have hLag := Lagrange.coeff_eq_sum (s := Finset.univ) ht.injOn (P := R) (by simpa using hRdeg)
  simp only [Finset.card_univ, Fintype.card_fin, Nat.add_sub_cancel, hRe] at hLag
  calc
    _ = -(∑ i, q.eval (t i) / ∏ j ∈ Finset.univ.erase i, (t i-t j)) := by
      rw [Finset.sum_neg_distrib]
      apply Finset.sum_congr rfl
      intro i _
      rw [hdd]
      change -d * _ / (d * _) = _
      rw [neg_mul, neg_div, mul_div_mul_left _ _ hd]
    _ = -(R.coeff n) := by rw [hLag]
    _ = _ := by rw [hRc]; ring

-- The literal fourth cumulant conversion needs no analytic cumulant theorem.
theorem b4_cumulant (d a₁ a₂ m₂ m₄ χ₄ : ℂ)
    (h₁ : a₁ = m₂/2) (h₂ : a₂ = m₄/24) (hχ : χ₄ = m₄-3*m₂^2) :
    (d-1)/d^2 * (a₁^2-2*a₂) = -(d-1)/(12*d^2)*χ₄ := by
  rw [h₁, h₂, hχ]
  ring

#print axioms nodal_derivative
#print axioms b4_residue_sum
#print axioms b4_cumulant
end QdB4Probe
