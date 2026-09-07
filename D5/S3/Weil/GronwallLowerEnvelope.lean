/- GID: D5/S3/Weil/GronwallLowerEnvelope
   generality: G
   mirror-B: none(waiver:formal-unit-only)
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Construct the lower Gronwall envelope from powers of primorials. -/

import D5.S3.Weil.GronwallUpperEnvelope
import Mathlib.NumberTheory.Primorial

/-!
Powers of primorials give the lower half of Gronwall's theorem.
The uniform prime-power error is bounded by a geometric factor times the
summable series of reciprocal squares. The logarithmic denominator uses
only the Chebyshev upper bound `primorial_le_four_pow`.
-/

set_option autoImplicit false

namespace D5.S3.Weil.GronwallLowerEnvelope

open Finset Filter Real Asymptotics
open scoped BigOperators Topology

private theorem one_sub_sum_le_product (s : Finset ℕ) (f : ℕ → ℝ)
    (hf : ∀ p ∈ s, 0 ≤ f p ∧ f p ≤ 1) :
    1 - ∑ p ∈ s, f p ≤ ∏ p ∈ s, (1 - f p) := by
  induction s using Finset.induction_on with
  | empty => simp
  | @insert p s hp ih =>
    have hfp := hf p (Finset.mem_insert_self p s)
    have hfs : ∀ q ∈ s, 0 ≤ f q ∧ f q ≤ 1 :=
      fun q hq => hf q (Finset.mem_insert_of_mem hq)
    have hsum : 0 ≤ ∑ q ∈ s, f q := Finset.sum_nonneg fun q hq => (hfs q hq).1
    rw [Finset.sum_insert hp, Finset.prod_insert hp]
    calc
      1 - (f p + ∑ q ∈ s, f q) ≤ (1 - f p) * (1 - ∑ q ∈ s, f q) := by
        nlinarith only [mul_nonneg hfp.1 hsum]
      _ ≤ (1 - f p) * ∏ q ∈ s, (1 - f q) :=
        mul_le_mul_of_nonneg_left (ih hfs) (sub_nonneg.mpr hfp.2)

private theorem prime_power_error (a y : ℕ) :
    1 - (1 / 2 : ℝ) ^ a * (∑' m : ℕ, 1 / (m : ℝ) ^ 2) ≤
      ∏ p ∈ Nat.primesLE y, (1 - 1 / (p : ℝ) ^ (a + 2)) := by
  have hpoint (p : ℕ) (hp : p ∈ Nat.primesLE y) :
      1 / (p : ℝ) ^ (a + 2) ≤ (1 / 2 : ℝ) ^ a * (1 / (p : ℝ) ^ 2) := by
    have hp2 : (2 : ℝ) ≤ p := by exact_mod_cast Nat.two_le_of_mem_primesLE hp
    calc
      1 / (p : ℝ) ^ (a + 2) = (1 / (p : ℝ)) ^ a * (1 / (p : ℝ) ^ 2) := by
        simp only [pow_add, one_div, mul_inv, inv_pow]
      _ ≤ (1 / 2 : ℝ) ^ a * (1 / (p : ℝ) ^ 2) :=
        mul_le_mul_of_nonneg_right
          (pow_le_pow_left₀ (by positivity)
            (one_div_le_one_div_of_le (by norm_num) hp2) a) (by positivity)
  have hsum : (∑ p ∈ Nat.primesLE y, 1 / (p : ℝ) ^ (a + 2)) ≤
      (1 / 2 : ℝ) ^ a * (∑' m : ℕ, 1 / (m : ℝ) ^ 2) := by
    calc
      _ ≤ ∑ p ∈ Nat.primesLE y, (1 / 2 : ℝ) ^ a * (1 / (p : ℝ) ^ 2) :=
        Finset.sum_le_sum hpoint
      _ = (1 / 2 : ℝ) ^ a * ∑ p ∈ Nat.primesLE y, 1 / (p : ℝ) ^ 2 :=
        (Finset.mul_sum ..).symm
      _ ≤ _ := mul_le_mul_of_nonneg_left
        ((summable_one_div_nat_pow.mpr (by omega : 1 < 2)).sum_le_tsum
          (Nat.primesLE y) (fun _ _ => by positivity)) (by positivity)
  refine (sub_le_sub_left hsum 1).trans (one_sub_sum_le_product _ _ ?_)
  intro p hp
  have hp1 : (1 : ℝ) ≤ p := by exact_mod_cast (Nat.prime_of_mem_primesLE hp).one_le
  exact ⟨by positivity, (div_le_one (by positivity)).mpr (one_le_pow₀ hp1)⟩

private theorem sigma_primorial_power (y a : ℕ) :
    (ArithmeticFunction.sigma 1 (primorial y ^ (a + 1)) : ℝ) /
        (primorial y ^ (a + 1) : ℕ) =
      (∏ p ∈ Nat.primesLE y, (1 - 1 / (p : ℝ) ^ (a + 2))) *
        ∏ p ∈ Nat.primesLE y, (1 - 1 / (p : ℝ))⁻¹ := by
  let n := primorial y ^ (a + 1)
  have hn : n ≠ 0 := pow_ne_zero _ (primorial_ne_zero y)
  have hpf : n.primeFactors = Nat.primesLE y := by
    rw [Nat.primeFactors_pow_succ, primeFactors_primorial]
  have hfac (p : ℕ) (hp : p ∈ Nat.primesLE y) : n.factorization p = a + 1 := by
    have hp' := Nat.prime_of_mem_primesLE hp
    have hpdiv : p ∣ primorial y := hp'.dvd_primorial_iff.mpr (Nat.le_of_mem_primesLE hp)
    simp only [n, Nat.factorization_pow, Finsupp.smul_apply, smul_eq_mul,
      Nat.factorization_eq_one_of_squarefree (squarefree_primorial y) hp' hpdiv, mul_one]
  have hnprod : (n : ℝ) = ∏ p ∈ n.primeFactors, (p : ℝ) ^ n.factorization p := by
    simpa only [Nat.cast_prod, Nat.cast_pow] using
      congrArg (fun k : ℕ => (k : ℝ)) (Nat.prod_primeFactors_pow_factorization hn)
  have hsigma : (ArithmeticFunction.sigma 1 n : ℝ) =
      ∏ p ∈ n.primeFactors, ∑ i ∈ Finset.range (n.factorization p + 1), (p : ℝ) ^ i := by
    simpa only [Nat.cast_prod, Nat.cast_sum, Nat.cast_pow, mul_one] using
      congrArg (fun k : ℕ => (k : ℝ))
        (ArithmeticFunction.sigma_eq_prod_primeFactors_sum_range_factorization_pow_mul
          (k := 1) hn)
  change (ArithmeticFunction.sigma 1 n : ℝ) / n = _
  rw [hsigma, hnprod, ← Finset.prod_div_distrib, hpf, ← Finset.prod_mul_distrib]
  apply Finset.prod_congr rfl
  intro p hp
  rw [hfac p hp]
  have hp1 : (1 : ℝ) < p := by exact_mod_cast (Nat.prime_of_mem_primesLE hp).one_lt
  have hp0 : (p : ℝ) ≠ 0 := ne_of_gt (lt_trans zero_lt_one hp1)
  rw [geom_sum_eq hp1.ne']
  simp only [show a + 2 = (a + 1) + 1 by omega, pow_succ]
  field_simp

end D5.S3.Weil.GronwallLowerEnvelope
