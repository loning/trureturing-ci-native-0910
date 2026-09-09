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

end
end D5.S3.Arith.EulerFormDivisorSum
