/- GID: D5/S3/Factorization/TauSigmaPowerBounds
   generality: G
   mirror-B: D5/B/S3/Factorization/TauSigmaPowerBounds
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Uniform fourth-power bounds for the divisor count and divisor sum. -/

import Mathlib.NumberTheory.ArithmeticFunction.Misc
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.IntervalCases

set_option autoImplicit false
set_option relaxedAutoImplicit false

open Finset

namespace D5.S3.Factorization.TauSigmaPowerBounds

/-!
Uniform estimates used to bound solutions of Ivan N. Ianakiev's equality conjecture in
OEIS A336687 (2020-08-06). These estimates do not prove that conjecture: the finite
exhaustion remains unproved. The divisor functions are mathlib's ArithmeticFunction.sigma.
-/

private lemma ratio_tail (p k a : ℕ) (hka : k ≤ a)
    (hk : (k + 2) ^ 4 ≤ p * (k + 1) ^ 4) :
    (a + 2) ^ 4 ≤ p * (a + 1) ^ 4 := by
  have hcross : (a + 2) * (k + 1) ≤ (k + 2) * (a + 1) := by nlinarith
  have hpow := Nat.pow_le_pow_left hcross 4
  rw [mul_pow, mul_pow] at hpow
  have hm := Nat.mul_le_mul_right ((a + 1) ^ 4) hk
  have h : (a + 2) ^ 4 * (k + 1) ^ 4 ≤
      (p * (a + 1) ^ 4) * (k + 1) ^ 4 := by
    simpa only [mul_assoc, mul_comm, mul_left_comm] using hpow.trans hm
  exact Nat.le_of_mul_le_mul_right h (by positivity)

private lemma tau_power_bound (p k : ℕ) (c : ℚ)
    (hbase : ∀ a ≤ k, (a + 1 : ℚ) ^ 4 ≤ c * (p : ℚ) ^ a)
    (hstep : (k + 2) ^ 4 ≤ p * (k + 1) ^ 4) (a : ℕ) :
    (a + 1 : ℚ) ^ 4 ≤ c * (p : ℚ) ^ a := by
  induction a with
  | zero => exact hbase 0 (Nat.zero_le _)
  | succ a ih =>
    by_cases ha : a < k
    · exact hbase (a + 1) ha
    · have ht : (a + 2 : ℚ) ^ 4 ≤ (p : ℚ) * (a + 1 : ℚ) ^ 4 := by
        exact_mod_cast ratio_tail p k a (by omega) hstep
      calc
        (↑(a + 1) + 1 : ℚ) ^ 4 = (a + 2 : ℚ) ^ 4 := by push_cast; ring
        _ ≤ (p : ℚ) * (a + 1 : ℚ) ^ 4 := ht
        _ ≤ (p : ℚ) * (c * (p : ℚ) ^ a) :=
          mul_le_mul_of_nonneg_left ih (by positivity)
        _ = c * (p : ℚ) ^ (a + 1) := by ring

private def tauCost (p : ℕ) : ℚ :=
  if p = 2 then 81 / 2 else if p = 3 then 256 / 27 else
  if p = 5 then 81 / 25 else if p = 7 then 16 / 7 else
  if p = 11 then 16 / 11 else if p = 13 then 16 / 13 else 1

private lemma tauCost_ge_one (p : ℕ) : 1 ≤ tauCost p := by
  unfold tauCost
  split_ifs <;> norm_num

private lemma tau_prime_bound (p a : ℕ) (hp : p.Prime) :
    (a + 1 : ℚ) ^ 4 ≤ tauCost p * (p : ℚ) ^ a := by
  by_cases h2 : p = 2
  · subst p
    apply tau_power_bound 2 5 (81 / 2) ?_ (by norm_num) a
    intro b hb
    interval_cases b <;> norm_num
  by_cases h3 : p = 3
  · subst p
    apply tau_power_bound 3 3 (256 / 27) ?_ (by norm_num) a
    intro b hb
    interval_cases b <;> norm_num
  by_cases h5 : p = 5
  · subst p
    apply tau_power_bound 5 2 (81 / 25) ?_ (by norm_num) a
    intro b hb
    interval_cases b <;> norm_num
  by_cases h7 : p = 7
  · subst p
    apply tau_power_bound 7 1 (16 / 7) ?_ (by norm_num) a
    intro b hb
    interval_cases b <;> norm_num
  by_cases h11 : p = 11
  · subst p
    apply tau_power_bound 11 1 (16 / 11) ?_ (by norm_num) a
    intro b hb
    interval_cases b <;> norm_num
  by_cases h13 : p = 13
  · subst p
    apply tau_power_bound 13 1 (16 / 13) ?_ (by norm_num) a
    intro b hb
    interval_cases b <;> norm_num
  have hp17 : 17 ≤ p := by
    by_contra h
    interval_cases p <;> norm_num at * <;> exact absurd hp (by decide)
  simp only [tauCost, if_neg h2, if_neg h3, if_neg h5, if_neg h7,
    if_neg h11, if_neg h13]
  apply tau_power_bound p 0 1 ?_ (by norm_num <;> omega) a
  intro b hb
  have : b = 0 := by omega
  subst b
  norm_num

private lemma cost_prod_le (c : ℕ → ℚ) (T S : Finset ℕ)
    (h1 : ∀ p, 1 ≤ c p) (hout : ∀ p, p ∉ T → c p = 1) :
    (∏ p ∈ S, c p) ≤ ∏ p ∈ T, c p := by
  have heq : (∏ p ∈ T, c p) = ∏ p ∈ S ∪ T, c p :=
    prod_subset subset_union_right (fun p _ hp => hout p hp)
  rw [heq]
  exact prod_le_prod_of_subset_of_one_le subset_union_left
    (fun p _ => (h1 p).trans' (by norm_num)) (fun p _ _ => h1 p)

/-- The divisor count satisfies a uniform fourth-power bound. -/
theorem tau_pow_four_le (n : ℕ) : ArithmeticFunction.sigma 0 n ^ 4 ≤ 9 ^ 4 * n := by
  by_cases hn : n = 0
  · simp [hn]
  have ht : (ArithmeticFunction.sigma 0 n : ℚ) =
      ∏ p ∈ n.primeFactors, (n.factorization p + 1 : ℚ) := by
    exact_mod_cast (ArithmeticFunction.sigma_zero_apply n).trans (Nat.card_divisors hn)
  have hnq : (n : ℚ) = ∏ p ∈ n.primeFactors, (p : ℚ) ^ n.factorization p := by
    exact_mod_cast Nat.prod_primeFactors_pow_factorization hn
  have hc : (∏ p ∈ n.primeFactors, tauCost p) ≤ (9 : ℚ) ^ 4 := by
    calc
      _ ≤ ∏ p ∈ ({2, 3, 5, 7, 11, 13} : Finset ℕ), tauCost p := by
        apply cost_prod_le tauCost _ _ tauCost_ge_one
        intro p hp
        simp only [mem_insert, mem_singleton, not_or] at hp
        simp [tauCost, hp]
      _ ≤ (9 : ℚ) ^ 4 := by norm_num [tauCost]
  have h : (ArithmeticFunction.sigma 0 n : ℚ) ^ 4 ≤ (9 : ℚ) ^ 4 * n := by
    calc
      _ = ∏ p ∈ n.primeFactors, (n.factorization p + 1 : ℚ) ^ 4 := by
        rw [ht, prod_pow]
      _ ≤ ∏ p ∈ n.primeFactors, tauCost p * (p : ℚ) ^ n.factorization p :=
        prod_le_prod (fun _ _ => by positivity)
          (fun p hp => tau_prime_bound p _ (Nat.prime_of_mem_primeFactors hp))
      _ = (∏ p ∈ n.primeFactors, tauCost p) * n := by rw [prod_mul_distrib, ← hnq]
      _ ≤ (9 : ℚ) ^ 4 * n := mul_le_mul_of_nonneg_right hc (by positivity)
  exact_mod_cast h

#print axioms tau_pow_four_le

end D5.S3.Factorization.TauSigmaPowerBounds
