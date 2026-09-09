/- GID: D5/S3/Factorization/A373561
   generality: G
   mirror-B: D5/B/S3/Factorization/A373561
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Granvik's gcd buckets sum to the square-sum polynomial of OEIS A373561. -/

import Mathlib.Data.Nat.GCD.Basic
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic.Ring

open scoped BigOperators
open Finset

namespace D5.S3.Factorization.A373561

/-- The signed quadratic expression in Granvik's conjecture. -/
def f (x y z : ℕ) : ℤ := (x : ℤ) ^ 2 + (y : ℤ) ^ 2 - (z : ℤ) ^ 2

private lemma gcd_mem_bucket (m : ℤ) {n : ℕ} (hn : 0 < n) :
    Nat.gcd m.natAbs n ∈ Icc 1 n :=
  mem_Icc.mpr ⟨Nat.gcd_pos_of_pos_right _ hn, Nat.gcd_le_right _ hn⟩

/-- Summing every gcd bucket recovers the unclassified sum, including signed and zero terms. -/
theorem gcd_buckets_eq_sum (n : ℕ) :
    (∑ k ∈ Icc 1 n, ∑ z ∈ Icc 1 n, ∑ y ∈ Icc 1 n, ∑ x ∈ Icc 1 n,
      if Nat.gcd (f x y z).natAbs n = k then f x y z else 0) =
      ∑ z ∈ Icc 1 n, ∑ y ∈ Icc 1 n, ∑ x ∈ Icc 1 n, f x y z := by
  classical
  by_cases hn : n = 0
  · subst n
    simp
  · have hmaps : ∀ p ∈ (Icc 1 n) ×ˢ ((Icc 1 n) ×ˢ (Icc 1 n)),
        Nat.gcd (f p.2.2 p.2.1 p.1).natAbs n ∈ Icc 1 n :=
      fun p _ => gcd_mem_bucket _ (Nat.pos_of_ne_zero hn)
    simpa only [sum_filter, sum_product] using
      (sum_fiberwise_of_maps_to hmaps (fun p => f p.2.2 p.2.1 p.1))

/-- The two positive square contributions and one negative contribution leave one square sum. -/
theorem triple_sum_eq (n : ℕ) :
    (∑ z ∈ Icc 1 n, ∑ y ∈ Icc 1 n, ∑ x ∈ Icc 1 n, f x y z) =
      (n : ℤ) ^ 2 * ∑ x ∈ Icc 1 n, (x : ℤ) ^ 2 := by
  simp only [f, sum_sub_distrib, sum_add_distrib, sum_const, nsmul_eq_mul,
    Nat.card_Icc, Nat.add_sub_cancel, ← mul_sum, ← sum_mul]
  ring

/-- The conjectured sum reduces to a square sum before any division is introduced. -/
theorem a373561_core (n : ℕ) :
    (∑ k ∈ Icc 1 n, ∑ z ∈ Icc 1 n, ∑ y ∈ Icc 1 n, ∑ x ∈ Icc 1 n,
      if Nat.gcd (f x y z).natAbs n = k then f x y z else 0) =
      (n : ℤ) ^ 2 * ∑ x ∈ Icc 1 n, (x : ℤ) ^ 2 := by
  rw [gcd_buckets_eq_sum, triple_sum_eq]

#print axioms gcd_buckets_eq_sum
#print axioms triple_sum_eq
#print axioms a373561_core

end D5.S3.Factorization.A373561
