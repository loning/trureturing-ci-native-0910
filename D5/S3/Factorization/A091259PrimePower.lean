/- GID: D5/S3/Factorization/A091259PrimePower
   generality: I
   mirror-B: D5/B/S3/Factorization/A091259PrimePower
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: The sigma-three over sigma-one prime-power ratio has a controlled numerator residue. -/

import D5.S3.Factorization.A091259Cyclotomic
import Mathlib.NumberTheory.ArithmeticFunction.Misc
import Mathlib.Tactic.LinearCombination

namespace D5.S3.Factorization.A091259PrimePower

open D5.S3.Factorization.A091259Cyclotomic
open Finset

def localNumerator (p e : ℕ) : ℕ :=
  cyclotomicThree (p ^ (e + 1)) / (if p % 3 = 1 then 3 else 1)

theorem sigma_prime_power_cross {p : ℕ} (hp : p.Prime) (e : ℕ) :
    ArithmeticFunction.sigma 3 (p ^ e) * cyclotomicThree p =
      ArithmeticFunction.sigma 1 (p ^ e) * cyclotomicThree (p ^ (e + 1)) := by
  rw [ArithmeticFunction.sigma_apply_prime_pow hp,
    ArithmeticFunction.sigma_one_apply_prime_pow hp]
  unfold cyclotomicThree
  zify
  have h1 := geom_sum_mul (p : ℤ) (e + 1)
  have h3 : (∑ j ∈ range (e + 1), (p : ℤ) ^ (j * 3)) * ((p : ℤ) ^ 3 - 1) =
      ((p : ℤ) ^ (e + 1)) ^ 3 - 1 := by
    have h := geom_sum_mul ((p : ℤ) ^ 3) (e + 1)
    simp_rw [pow_right_comm (p : ℤ) 3] at h
    simpa only [pow_mul] using h
  apply mul_right_cancel₀ (show (p : ℤ) - 1 ≠ 0 by have := hp.two_le; omega)
  linear_combination h3 - (((p : ℤ) ^ (e + 1)) ^ 2 + (p : ℤ) ^ (e + 1) + 1) * h1

theorem localNumerator_cross {p : ℕ} (hp : p.Prime) (e : ℕ) :
    ArithmeticFunction.sigma 3 (p ^ e) * strippedThree p =
      ArithmeticFunction.sigma 1 (p ^ e) * localNumerator p e := by
  have h := sigma_prime_power_cross hp e
  unfold strippedThree localNumerator
  by_cases hp1 : p % 3 = 1
  · simp only [hp1, if_true]
    have hpk : p ^ (e + 1) % 3 = 1 := by simp [Nat.pow_mod, hp1]
    have hd := (cyclotomicThree_div_three p hp1).1
    have hn := (cyclotomicThree_div_three (p ^ (e + 1)) hpk).1
    rw [← Nat.mul_div_assoc _ hd, ← Nat.mul_div_assoc _ hn, h]
  · simpa [hp1] using h

theorem localNumerator_mod (p e : ℕ) :
    localNumerator p e % 3 = if p % 3 = 2 → Even e then 1 else 0 := by
  by_cases hp1 : p % 3 = 1
  · have hpk : p ^ (e + 1) % 3 = 1 := by simp [Nat.pow_mod, hp1]
    simpa [localNumerator, hp1] using
      (cyclotomicThree_div_three (p ^ (e + 1)) hpk).2
  · simp only [localNumerator, hp1, if_false, Nat.div_one, cyclotomicThree_mod]
    have hr : p % 3 = 0 ∨ p % 3 = 2 := by omega
    rcases hr with hp0 | hp2
    · simp [Nat.pow_mod, hp0]
    · have hpow : p ^ (e + 1) % 3 = if Even e then 2 else 1 := by
        have he : e = 2 * (e / 2) + e % 2 := by omega
        rw [he, Nat.pow_mod, hp2]
        have hh : e % 2 = 0 ∨ e % 2 = 1 := by omega
        rcases hh with hh | hh <;>
          simp [hh, pow_add, pow_mul, Nat.mul_mod, Nat.pow_mod]
      rw [hpow]
      by_cases he : Even e <;> simp [hp2, he]

#print axioms sigma_prime_power_cross
#print axioms localNumerator_cross
#print axioms localNumerator_mod

end D5.S3.Factorization.A091259PrimePower
