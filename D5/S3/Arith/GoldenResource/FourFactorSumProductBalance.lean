/- GID: D5/S3/Arith/GoldenResource/FourFactorSumProductBalance
   generality: G
   mirror-B: D5/B/S3/Arith/GoldenResource/FourFactorSumProductBalance
   mirror-E: none(waiver:unbounded-diophantine-classification)
   anchors: []
   utility: none
   digest: Positive integer quadruples have equal sum and product exactly when they permute 4, 2, 1, 1; the common value is eight. -/

import Mathlib.Data.List.Sort
import Mathlib.Algebra.BigOperators.Group.List.Basic
import Mathlib.Tactic

namespace D5.S3.Arith.GoldenResource.FourFactorSumProductBalance

/-- In a decreasing positive solution, the two smallest coordinates are one. -/
theorem sorted_positive_sum_product_lower_pair_eq_one (a b c d : ℕ)
    (hd : 0 < d) (hdc : d ≤ c) (hcb : c ≤ b) (hba : b ≤ a)
    (h : a + b + c + d = a * b * c * d) : c = 1 ∧ d = 1 := by
  have hd1 : d = 1 := by
    by_contra hne
    have hd2 : 2 ≤ d := by omega
    have hc2 : 2 ≤ c := le_trans hd2 hdc
    have hb2 : 2 ≤ b := le_trans hc2 hcb
    have hab := Nat.mul_le_mul_left a hb2
    have habc := Nat.mul_le_mul_left (a * b) hc2
    have habcd := Nat.mul_le_mul_left (a * b * c) hd2
    nlinarith
  subst d
  simp only [mul_one] at h
  have hc1 : c = 1 := by
    by_contra hne
    have hc2 : 2 ≤ c := by omega
    have hb2 : 2 ≤ b := le_trans hc2 hcb
    have ha2 : 2 ≤ a := le_trans hb2 hba
    have habc := Nat.mul_le_mul_left (a * b) hc2
    have hab := Nat.mul_le_mul_left a hb2
    nlinarith
  exact ⟨hc1, rfl⟩

/-- Removing the two unit coordinates gives the two-factor equation and its factorization. -/
theorem sorted_positive_sum_product_reduction (a b c d : ℕ)
    (hd : 0 < d) (hdc : d ≤ c) (hcb : c ≤ b) (hba : b ≤ a)
    (h : a + b + c + d = a * b * c * d) :
    a + b + 2 = a * b ∧ (a - 1) * (b - 1) = 3 := by
  obtain ⟨rfl, rfl⟩ :=
    sorted_positive_sum_product_lower_pair_eq_one a b c d hd hdc hcb hba h
  simp only [mul_one] at h
  have ha : a - 1 + 1 = a := Nat.sub_add_cancel (le_trans hcb hba)
  have hb : b - 1 + 1 = b := Nat.sub_add_cancel hcb
  constructor <;> nlinarith

/-- The decreasing positive solution is exactly (4, 2, 1, 1). -/
theorem sorted_positive_sum_product_classification (a b c d : ℕ)
    (hd : 0 < d) (hdc : d ≤ c) (hcb : c ≤ b) (hba : b ≤ a)
    (h : a + b + c + d = a * b * c * d) :
    a = 4 ∧ b = 2 ∧ c = 1 ∧ d = 1 := by
  have hab := (sorted_positive_sum_product_reduction a b c d hd hdc hcb hba h).1
  obtain ⟨hc, hd1⟩ :=
    sorted_positive_sum_product_lower_pair_eq_one a b c d hd hdc hcb hba h
  have hb2 : 2 ≤ b := by
    by_contra hne
    have hb1 : b = 1 := by omega
    simp [hb1] at hab
    omega
  have hb : b = 2 := by
    by_contra hne
    have hb3 : 3 ≤ b := by omega
    have hab3 := Nat.mul_le_mul_left a hb3
    nlinarith
  subst b
  exact ⟨by omega, rfl, hc, hd1⟩

#print axioms sorted_positive_sum_product_lower_pair_eq_one
#print axioms sorted_positive_sum_product_reduction
#print axioms sorted_positive_sum_product_classification

end D5.S3.Arith.GoldenResource.FourFactorSumProductBalance
