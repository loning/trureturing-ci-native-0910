/- GID: D5/S3/Weil/GronwallUpperEnvelope
   generality: G
   mirror-B: none(waiver:formal-unit-only)
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Assemble the eventual Gronwall upper envelope from Mertens III. -/

import D5.S3.Weil.Mertens.Third
import Mathlib.NumberTheory.ArithmeticFunction.Misc
import Mathlib.Algebra.Order.BigOperators.GroupWithZero.Finset
import Mathlib.Algebra.Field.GeomSum

/-!
The upper half of Gronwall's theorem, using the frozen Mertens III port.
Proof shape: bind-only. Admission basis: rule-11-upstream-wrapper.
The API obligation is the first named Gronwall consumer promised by the
Mertens III port in #6171. No lower-limsup construction or limsup equality
is asserted here. The finite estimates reuse the proofs recorded in
gronwall-step1-0907/attempt-1 and gronwall-step2-0907/attempt-1.

Companion edges (consumer -> prerequisite):
sigma_split -> small_prime_product_le;
large_prime_product_le -> large_prime_count_le;
sigma_split -> large_prime_product_le;
gronwall_upper_envelope -> sigma_split.
-/

set_option autoImplicit false

namespace D5.S3.Weil.GronwallUpperEnvelope

open Finset Filter Real Asymptotics
open scoped BigOperators Topology

/-- Padding the small prime divisors by all primes up to the cutoff. -/
theorem small_prime_product_le (n : ℕ) (y : ℝ) :
    (∏ p ∈ n.primeFactors.filter (fun p : ℕ => (p : ℝ) ≤ y),
      (1 - 1 / (p : ℝ))⁻¹) ≤
      ∏ p ∈ Ioc (0 : ℕ) ⌊y⌋₊ with p.Prime, (1 - 1 / (p : ℝ))⁻¹ := by
  have hfactor (p : ℕ) (hp : p.Prime) : (1 : ℝ) ≤ (1 - 1 / (p : ℝ))⁻¹ := by
    have hp1 : (1 : ℝ) < p := by
      simpa only [Nat.cast_one] using (Nat.cast_lt (α := ℝ)).2 hp.one_lt
    have hrecip : 1 / (p : ℝ) < 1 := by
      simpa only [one_div] using inv_lt_one_of_one_lt₀ hp1
    exact (one_le_inv₀ (sub_pos.mpr hrecip)).2
      (sub_le_self 1 (div_nonneg zero_le_one (Nat.cast_nonneg p)))
  exact Finset.prod_le_prod_of_subset_of_one_le
    (fun p hp =>
      Finset.mem_filter.mpr
        ⟨Finset.mem_Ioc.mpr
          ⟨(Nat.prime_of_mem_primeFactors (Finset.mem_filter.mp hp).1).pos,
            Nat.le_floor (Finset.mem_filter.mp hp).2⟩,
          Nat.prime_of_mem_primeFactors (Finset.mem_filter.mp hp).1⟩)
    (fun p hp => le_trans zero_le_one
      (hfactor p (Nat.prime_of_mem_primeFactors (Finset.mem_filter.mp hp).1)))
    (fun p hp _ => hfactor p (Finset.mem_filter.mp hp).2)

/-- The distinct prime divisors above a real cutoff. -/
noncomputable def largePrimes (n : ℕ) (y : ℝ) : Finset ℕ :=
  n.primeFactors.filter (fun p => y < (p : ℝ))

/-- The logarithmic budget for the large prime divisors. -/
theorem large_prime_count_le {n : ℕ} (hn : 0 < n) {y : ℝ} (hy : 2 ≤ y) :
    ((largePrimes n y).card : ℝ) ≤ Real.log n / Real.log y := by
  have hy0 : 0 < y := by linarith only [hy]
  have hy1 : 1 < y := by linarith only [hy]
  have hsub : largePrimes n y ⊆ n.primeFactors := Finset.filter_subset _ _
  have hp0 : ∀ p ∈ largePrimes n y, (0 : ℝ) < p := fun p hp =>
    Nat.cast_pos.mpr (Nat.prime_of_mem_primeFactors (hsub hp)).pos
  have hprod : (∏ p ∈ largePrimes n y, p) ≤ n :=
    Nat.le_of_dvd hn ((Finset.prod_dvd_prod_of_subset _ _ id hsub).trans
      (Nat.prod_primeFactors_dvd n))
  have hprodR : (∏ p ∈ largePrimes n y, (p : ℝ)) ≤ n := by
    simpa only [Nat.cast_prod] using (Nat.cast_le (α := ℝ)).mpr hprod
  have hlog := Real.log_le_log (Finset.prod_pos hp0) hprodR
  rw [Real.log_prod (fun p hp => (hp0 p hp).ne')] at hlog
  have hsum : ((largePrimes n y).card : ℝ) * Real.log y ≤
      ∑ p ∈ largePrimes n y, Real.log p := by
    have h := Finset.sum_le_sum (s := largePrimes n y)
      (f := fun _ : ℕ => Real.log y) (g := fun p : ℕ => Real.log (p : ℝ))
      (fun p hp => Real.log_le_log hy0 (Finset.mem_filter.mp hp).2.le)
    simpa only [Finset.sum_const, nsmul_eq_mul] using h
  exact (le_div_iff₀ (Real.log_pos hy1)).mpr (hsum.trans hlog)

/-- The large-prime Euler factors contribute a vanishing exponential error. -/
theorem large_prime_product_le {n : ℕ} (hn : 0 < n) {y : ℝ} (hy : 2 ≤ y) :
    (∏ p ∈ largePrimes n y, (1 - 1 / (p : ℝ))⁻¹) ≤
      Real.exp (2 * Real.log n / (y * Real.log y)) := by
  have hy0 : 0 < y := by linarith only [hy]
  have hp1 : ∀ p ∈ largePrimes n y, (1 : ℝ) < p := by
    intro p hp
    have h := (Finset.mem_filter.mp hp).2
    linarith only [h, hy]
  have hfac : ∀ p ∈ largePrimes n y, (0 : ℝ) < (1 - 1 / (p : ℝ))⁻¹ := by
    intro p hp
    exact inv_pos.mpr (sub_pos.mpr (by
      simpa only [one_div] using inv_lt_one_of_one_lt₀ (hp1 p hp)))
  have hpoint : ∀ p ∈ largePrimes n y,
      Real.log ((1 - 1 / (p : ℝ))⁻¹) ≤ 2 / y := by
    intro p hp
    have hyp := (Finset.mem_filter.mp hp).2
    have hp0 : (0 : ℝ) < p := lt_trans hy0 hyp
    have hpm : (0 : ℝ) < (p : ℝ) - 1 := sub_pos.mpr (hp1 p hp)
    have hp2 : (2 : ℝ) ≤ p := hy.trans hyp.le
    rw [one_sub_div hp0.ne', inv_div]
    calc
      Real.log ((p : ℝ) / (p - 1)) ≤ (p : ℝ) / (p - 1) - 1 :=
        Real.log_le_sub_one_of_pos (div_pos hp0 hpm)
      _ = 1 / ((p : ℝ) - 1) := by rw [div_sub_one hpm.ne', sub_sub_cancel]
      _ ≤ 2 / (p : ℝ) := (div_le_div_iff₀ hpm hp0).mpr (by linarith only [hp2])
      _ ≤ 2 / y := div_le_div_of_nonneg_left (by norm_num) hy0 hyp.le
  apply (Real.log_le_iff_le_exp (Finset.prod_pos hfac)).mp
  rw [Real.log_prod (fun p hp => (hfac p hp).ne')]
  calc
    (∑ p ∈ largePrimes n y, Real.log ((1 - 1 / (p : ℝ))⁻¹)) ≤
        ((largePrimes n y).card : ℝ) * (2 / y) := by
      simpa only [Finset.sum_const, nsmul_eq_mul] using Finset.sum_le_sum hpoint
    _ ≤ (Real.log n / Real.log y) * (2 / y) :=
      mul_le_mul_of_nonneg_right (large_prime_count_le hn hy)
        (div_nonneg (by norm_num) hy0.le)
    _ = 2 * Real.log n / (y * Real.log y) := by
      simp only [div_eq_mul_inv, mul_inv_rev]
      ring

/-- Split the divisor-sum ratio into a small-prime product and a large-prime error. -/
theorem sigma_split {n : ℕ} (hn : 0 < n) {y : ℝ} (hy : 2 ≤ y) :
    (ArithmeticFunction.sigma 1 n : ℝ) / n ≤
      (∏ p ∈ Ioc (0 : ℕ) ⌊y⌋₊ with p.Prime, (1 - 1 / (p : ℝ))⁻¹) *
        Real.exp (2 * Real.log n / (y * Real.log y)) := by
  have hfactor (p : ℕ) (hp : p.Prime) :
      (1 : ℝ) ≤ (1 - 1 / (p : ℝ))⁻¹ := by
    have hp1 : (1 : ℝ) < p := by
      simpa only [Nat.cast_one] using (Nat.cast_lt (α := ℝ)).mpr hp.one_lt
    have hrecip : 1 / (p : ℝ) < 1 := by
      simpa only [one_div] using inv_lt_one_of_one_lt₀ hp1
    exact (one_le_inv₀ (sub_pos.mpr hrecip)).mpr
      (sub_le_self 1 (div_nonneg zero_le_one (Nat.cast_nonneg p)))
  have hgeom (p : ℕ) (hp : p.Prime) (a : ℕ) :
      (∑ i ∈ Finset.range (a + 1), (p : ℝ) ^ i) / (p : ℝ) ^ a ≤
        (1 - 1 / (p : ℝ))⁻¹ := by
    have hp1 : (1 : ℝ) < p := by
      simpa only [Nat.cast_one] using (Nat.cast_lt (α := ℝ)).mpr hp.one_lt
    have hp0 : (0 : ℝ) < p := Nat.cast_pos.mpr hp.pos
    have hpm : (0 : ℝ) < (p : ℝ) - 1 := sub_pos.mpr hp1
    have hpow : (0 : ℝ) < (p : ℝ) ^ a := pow_pos hp0 a
    rw [geom_sum_eq hp1.ne']
    calc
      ((p : ℝ) ^ (a + 1) - 1) / (p - 1) / p ^ a ≤
          (p : ℝ) ^ (a + 1) / (p - 1) / p ^ a :=
        div_le_div_of_nonneg_right
          (div_le_div_of_nonneg_right (sub_le_self _ zero_le_one) hpm.le) hpow.le
      _ = (1 - 1 / (p : ℝ))⁻¹ := by
        rw [pow_succ, div_right_comm, mul_div_cancel_left₀ _ hpow.ne',
          one_sub_div hp0.ne', inv_div]
  have hsigma : (ArithmeticFunction.sigma 1 n : ℝ) / n ≤
      ∏ p ∈ n.primeFactors, (1 - 1 / (p : ℝ))⁻¹ := by
    have hnprod : (n : ℝ) = ∏ p ∈ n.primeFactors, (p : ℝ) ^ n.factorization p := by
      simpa only [Nat.cast_prod, Nat.cast_pow] using
        congrArg (fun k : ℕ => (k : ℝ)) (Nat.prod_primeFactors_pow_factorization hn.ne')
    have hsigmaprod : (ArithmeticFunction.sigma 1 n : ℝ) =
        ∏ p ∈ n.primeFactors, ∑ i ∈ Finset.range (n.factorization p + 1), (p : ℝ) ^ i := by
      simpa only [Nat.cast_prod, Nat.cast_sum, Nat.cast_pow, mul_one] using
        congrArg (fun k : ℕ => (k : ℝ))
          (ArithmeticFunction.sigma_eq_prod_primeFactors_sum_range_factorization_pow_mul
            (k := 1) hn.ne')
    rw [hsigmaprod, hnprod, ← Finset.prod_div_distrib]
    exact Finset.prod_le_prod
      (fun p _ => div_nonneg
        (Finset.sum_nonneg (fun i _ => pow_nonneg (Nat.cast_nonneg p) i))
        (pow_nonneg (Nat.cast_nonneg p) _))
      (fun p hp => hgeom p (Nat.prime_of_mem_primeFactors hp) _)
  have hsplit :
      (∏ p ∈ n.primeFactors, (1 - 1 / (p : ℝ))⁻¹) =
      (∏ p ∈ n.primeFactors.filter (fun p : ℕ => (p : ℝ) ≤ y),
        (1 - 1 / (p : ℝ))⁻¹) *
      (∏ p ∈ largePrimes n y, (1 - 1 / (p : ℝ))⁻¹) := by
    simpa only [not_le, largePrimes] using
      (Finset.prod_filter_mul_prod_filter_not n.primeFactors
        (fun p : ℕ => (p : ℝ) ≤ y) (fun p => (1 - 1 / (p : ℝ))⁻¹)).symm
  exact hsigma.trans (hsplit.trans_le
    (mul_le_mul (small_prime_product_le n y) (large_prime_product_le hn hy)
      (Finset.prod_nonneg (fun p hp => zero_le_one.trans
        (hfactor p (Nat.prime_of_mem_primeFactors (Finset.mem_filter.mp hp).1))))
      (Finset.prod_nonneg (fun p hp => zero_le_one.trans
        (hfactor p (Finset.mem_filter.mp hp).2)))))

end D5.S3.Weil.GronwallUpperEnvelope
