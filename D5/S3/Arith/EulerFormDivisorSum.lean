/- GID: D5/S3/Arith/EulerFormDivisorSum
   generality: G
   mirror-B: D5/B/S3/Arith/EulerFormDivisorSum
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Euler-form odd numbers satisfy the strict unitary-plus-squarefree divisor-sum bound. -/

import Mathlib.NumberTheory.ArithmeticFunction.Misc
import Mathlib.Algebra.Order.BigOperators.GroupWithZero.Finset
import Mathlib.Data.Finset.Max
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-! # The Euler-form inclusion question of OEIS A388986

The two functions below are the actual filtered divisor sums. All analytic
bounds use rationals and explicitly positive denominators.
-/

namespace D5.S3.Arith.EulerFormDivisorSum

open Finset

noncomputable section

/-- Sum of the unitary divisors, including 1 and the number itself. -/
def unitarySum (N : ℕ) : ℕ :=
  ∑ d ∈ N.divisors.filter (fun d => Nat.Coprime d (N / d)), d

/-- Sum of the squarefree divisors. -/
def squarefreeSum (N : ℕ) : ℕ := ∑ d ∈ N.divisors.filter Squarefree, d

private theorem reciprocal_square_product_le (F : Finset ℕ) (b : ℕ) (hb : 1 < b)
    (hF : ∀ q ∈ F, b ≤ q) :
    (∏ q ∈ F, (1 + 1 / (q : ℚ)^2)) ≤ (b : ℚ) / ((b : ℚ) - 1) := by
  induction F using Finset.induction_on_min generalizing b with
  | empty =>
      simp only [prod_empty]
      have hb' : (1 : ℚ) < b := by exact_mod_cast hb
      apply (le_div_iff₀ (by linarith : (0 : ℚ) < b - 1)).2
      linarith
  | insert q F hq ih =>
      have hbq : b ≤ q := hF q (mem_insert_self _ _)
      have hq1 : 1 < q := lt_of_lt_of_le hb hbq
      have hq' : (1 : ℚ) < q := by exact_mod_cast hq1
      have hq0 : (q : ℚ) ≠ 0 := by positivity
      have hnot : q ∉ F := fun h => (hq q h).false
      rw [prod_insert hnot]
      have ht := ih (q+1) (by omega) (fun x hx => hq x hx)
      push_cast at ht
      have hb' : (1 : ℚ) < b := by exact_mod_cast hb
      have hbq' : (b : ℚ) ≤ q := by exact_mod_cast hbq
      calc
        _ ≤ (1 + 1 / (q : ℚ)^2) * (((q : ℚ)+1)/(q : ℚ)) := by
          apply mul_le_mul_of_nonneg_left
          · simpa using ht
          · positivity
        _ ≤ (q : ℚ) / ((q : ℚ)-1) := by
          apply (le_div_iff₀ (by linarith : (0 : ℚ) < q - 1)).2
          field_simp
          nlinarith
        _ ≤ (b : ℚ) / ((b : ℚ)-1) := by
          apply (div_le_div_iff₀ (by linarith) (by linarith)).2
          nlinarith

private theorem unitary_divisor_product {N d : ℕ} (hn : N ≠ 0) (hd : d ∣ N)
    (hc : d.Coprime (N / d)) :
    d = ∏ q ∈ d.primeFactors, q ^ N.factorization q := by
  have hd0 : d ≠ 0 := ne_zero_of_dvd_ne_zero hn hd
  nth_rw 1 [Nat.prod_primeFactors_pow_factorization hd0]
  apply prod_congr rfl
  intro q hq
  congr 1
  have hf := Nat.factorization_eq_of_coprime_left hc (List.mem_toFinset.mp hq)
  simpa [Nat.mul_div_cancel' hd] using hf.symm

private theorem unitarySum_le_product (N : ℕ) (hn : N ≠ 0) :
    unitarySum N ≤ ∏ q ∈ N.primeFactors, (q ^ N.factorization q + 1) := by
  let D := N.divisors.filter (fun d => Nat.Coprime d (N / d))
  let g := fun F : Finset ℕ => ∏ q ∈ F, q ^ N.factorization q
  have hv : ∀ d ∈ D, d = g d.primeFactors := by
    intro d hd
    exact unitary_divisor_product hn (Nat.dvd_of_mem_divisors (mem_filter.mp hd).1)
      (mem_filter.mp hd).2
  have hi : Set.InjOn Nat.primeFactors D := by
    intro d hd e he h
    rw [hv d hd, hv e he, h]
  calc
    unitarySum N = ∑ d ∈ D, g d.primeFactors := sum_congr rfl hv
    _ = ∑ F ∈ D.image Nat.primeFactors, g F := (sum_image hi).symm
    _ ≤ ∑ F ∈ N.primeFactors.powerset, g F := by
      apply sum_le_sum_of_subset_of_nonneg
      · intro F hF
        obtain ⟨d, hd, rfl⟩ := mem_image.mp hF
        exact mem_powerset.mpr
          (Nat.primeFactors_mono (Nat.dvd_of_mem_divisors (mem_filter.mp hd).1) hn)
      · intros; exact Nat.zero_le _
    _ = _ := (prod_add_one _).symm

private theorem squarefreeSum_eq_product (N : ℕ) (hn : N ≠ 0) :
    squarefreeSum N = ∏ q ∈ N.primeFactors, (q + 1) := by
  rw [squarefreeSum, Nat.sum_divisors_filter_squarefree hn, Nat.factors_eq]
  simpa only [List.toFinset_coe, Nat.toFinset_factors, Finset.prod_val, id_eq] using
    (prod_add_one (f := fun q : ℕ => q) N.primeFactors).symm

end
end D5.S3.Arith.EulerFormDivisorSum
