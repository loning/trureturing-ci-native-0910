/- GID: D5/S3/Weil/PrimeValuationGap
   generality: G
   mirror-B: D5/B/S3/Weil/PrimeValuationGap
   mirror-E: none(waiver:qualitative-asymptotic-estimate)
   anchors: []
   utility: none
   digest: Bounded valuations at a fixed prime leave a positive asymptotic Robin margin. -/

import D5.S3.Weil.GronwallLowerEnvelope
import Mathlib.Tactic.FieldSimp

/-!
The local Euler factor is retained exactly when a fixed number of prime layers
is added. The number of added layers is chosen before the integer threshold.
All statements concern arbitrary primes and unbounded natural or real parameters.
They are arithmetic identities or analytic estimates, not finite enumeration,
checkers, numerical reductions, or certified finite instances.
-/

set_option autoImplicit false

namespace D5.S3.Weil.PrimeValuationGap

open Filter
open scoped Topology
open D5.S3.Arith.Robin.PaddingRatio
open D5.S3.Weil.GronwallLowerEnvelope

local notation "Z" => (fun n : ℕ => (ArithmeticFunction.sigma 1 n : ℝ) / n)

private theorem reciprocal_prime_bounds {p : ℕ} (hp : p.Prime) :
    0 < (p : ℝ)⁻¹ ∧ (p : ℝ)⁻¹ < 1 := by
  exact ⟨inv_pos.mpr (Nat.cast_pos.mpr hp.pos),
    inv_lt_one_of_one_lt₀ (by exact_mod_cast hp.one_lt)⟩

private theorem retention_pos {p : ℕ} (hp : p.Prime) (a : ℕ) :
    0 < 1 - (p : ℝ)⁻¹ ^ (a + 1) :=
  sub_pos.mpr (pow_lt_one₀ (reciprocal_prime_bounds hp).1.le
    (reciprocal_prime_bounds hp).2 (by omega))

private theorem abundancy_pos {n : ℕ} (hn : n ≠ 0) : 0 < Z n :=
  div_pos (Nat.cast_pos.mpr (ArithmeticFunction.sigma_pos 1 n hn))
    (Nat.cast_pos.mpr (Nat.pos_of_ne_zero hn))

private theorem normalized_sigma_prime_pow {p : ℕ} (hp : p.Prime) (a : ℕ) :
    Z (p ^ a) = (1 - (p : ℝ)⁻¹ ^ (a + 1)) / (1 - (p : ℝ)⁻¹) := by
  have hp0 : (p : ℝ) ≠ 0 := by exact_mod_cast hp.ne_zero
  have hp1 : (p : ℝ) ≠ 1 := by exact_mod_cast hp.ne_one
  dsimp only
  rw [ArithmeticFunction.sigma_one_apply_prime_pow hp]
  push_cast
  rw [geom_sum_eq hp1]
  simp only [inv_pow, pow_succ]
  field_simp

private theorem normalized_sigma_pow_mul {p m : ℕ} (hp : p.Prime)
    (hm : p.Coprime m) (a : ℕ) :
    Z (p ^ a * m) =
      (1 - (p : ℝ)⁻¹ ^ (a + 1)) / (1 - (p : ℝ)⁻¹) * Z m := by
  have h := (ArithmeticFunction.isMultiplicative_sigma (k := 1)).map_mul_of_coprime
    (hm.pow_left a)
  change (ArithmeticFunction.sigma 1 (p ^ a * m) : ℝ) / (p ^ a * m : ℕ) = _
  rw [h, Nat.cast_mul, Nat.cast_mul, mul_div_mul_comm]
  exact congrArg (fun x : ℝ => x * Z m) (normalized_sigma_prime_pow hp a)

/-- Exact abundancy gain from adding `b` layers at a prime, including `b = 0`. -/
theorem prime_power_abundancy_ratio {p n : ℕ} (hp : p.Prime) (hn : n ≠ 0) (b : ℕ) :
    Z (p ^ b * n) / Z n =
      (1 - (p : ℝ)⁻¹ ^ (n.factorization p + b + 1)) /
        (1 - (p : ℝ)⁻¹ ^ (n.factorization p + 1)) := by
  have hcop := Nat.coprime_ordCompl hp hn
  have hn' : n = p ^ n.factorization p * (ordCompl[p] n) :=
    (Nat.ordProj_mul_ordCompl_eq_self n p).symm
  have hm' : p ^ b * n = p ^ (n.factorization p + b) * (ordCompl[p] n) := by
    conv_lhs => arg 2; rw [hn']
    rw [← mul_assoc, ← pow_add, Nat.add_comm b]
  have hZn : Z n =
      (1 - (p : ℝ)⁻¹ ^ (n.factorization p + 1)) / (1 - (p : ℝ)⁻¹) *
        Z (ordCompl[p] n) := by
    calc
      Z n = Z (p ^ n.factorization p * (ordCompl[p] n)) := congrArg Z hn'
      _ = _ := normalized_sigma_pow_mul hp hcop _
  have hZm : Z (p ^ b * n) =
      (1 - (p : ℝ)⁻¹ ^ (n.factorization p + b + 1)) / (1 - (p : ℝ)⁻¹) *
        Z (ordCompl[p] n) := by
    calc
      Z (p ^ b * n) = Z (p ^ (n.factorization p + b) * (ordCompl[p] n)) :=
        congrArg Z hm'
      _ = _ := normalized_sigma_pow_mul hp hcop _
  rw [hZn, hZm, mul_div_mul_right _ _ (abundancy_pos (Nat.ordCompl_pos p hn).ne').ne']
  exact div_div_div_cancel_right₀ (sub_pos.mpr (reciprocal_prime_bounds hp).2).ne' _ _

/-- The smallest gain on an exponent window occurs at its largest exponent. -/
theorem prime_power_abundancy_gain {p n A : ℕ} (hp : p.Prime) (hn : n ≠ 0)
    (ha : n.factorization p ≤ A) (b : ℕ) :
    (1 - (p : ℝ)⁻¹ ^ (A + b + 1)) / (1 - (p : ℝ)⁻¹ ^ (A + 1)) ≤
      Z (p ^ b * n) / Z n := by
  rw [prime_power_abundancy_ratio hp hn b]
  apply (div_le_div_iff₀ (retention_pos hp A) (retention_pos hp _)).mpr
  have hr := reciprocal_prime_bounds hp
  have hpow := pow_le_pow_of_le_one hr.1.le hr.2.le (Nat.add_le_add_right ha 1)
  have hb := pow_le_one₀ hr.1.le hr.2.le (n := b)
  have hproduct := mul_nonneg (sub_nonneg.mpr hpow) (sub_nonneg.mpr hb)
  rw [show A + b + 1 = (A + 1) + b by omega,
    show n.factorization p + b + 1 = (n.factorization p + 1) + b by omega,
    pow_add _ (A + 1) b, pow_add _ (n.factorization p + 1) b]
  nlinarith only [hproduct]

/-- The sharp logarithmic local defect is positive for each fixed prime and exponent bound. -/
theorem prime_valuation_gap_pos {p : ℕ} (hp : p.Prime) (A : ℕ) :
    0 < -Real.log (1 - (p : ℝ)⁻¹ ^ (A + 1)) := by
  apply neg_pos.mpr
  apply Real.log_neg (retention_pos hp A)
  exact sub_lt_self 1 (pow_pos (reciprocal_prime_bounds hp).1 _)

#print axioms prime_power_abundancy_ratio
#print axioms prime_power_abundancy_gain
#print axioms prime_valuation_gap_pos

end D5.S3.Weil.PrimeValuationGap
