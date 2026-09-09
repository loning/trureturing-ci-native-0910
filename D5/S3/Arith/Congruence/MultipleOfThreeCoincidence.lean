/- GID: D5/S3/Arith/Congruence/MultipleOfThreeCoincidence
   generality: G
   mirror-B: D5/B/S3/Arith/Congruence/MultipleOfThreeCoincidence
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: A multiple-of-three residue coincidence characterizes composites with four exceptions. -/

import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Finset.Insert
import Mathlib.Tactic

namespace D5.S3.Arith.Congruence.MultipleOfThreeCoincidence

/-- Equality of the fractions at 3 and a larger multiple of 3, with positive denominators. -/
def Coincides (k : ℕ) : Prop :=
  ∃ m : ℕ, 6 ≤ m ∧ m ≤ k ∧ 3 ∣ m ∧ 3 * ((2 * k) % m) = m * ((2 * k) % 3)

private theorem residue_factor_iff (x t : ℕ) (ht : 0 < t) :
    x % (3 * t) = t * (x % 3) ↔ t ∣ x ∧ (x / t) % 3 = x % 3 := by
  constructor
  · intro h
    have hd : t ∣ x := by
      refine ⟨x % 3 + 3 * (x / (3 * t)), ?_⟩
      have hm := Nat.mod_add_div x (3 * t)
      rw [h] at hm
      nlinarith
    refine ⟨hd, ?_⟩
    have hm : x % (3 * t) = t * ((x / t) % 3) := by
      conv_lhs => rw [← Nat.mul_div_cancel' hd]
      rw [Nat.mul_comm 3 t, Nat.mul_mod_mul_left]
    nlinarith
  · rintro ⟨hd, hq⟩
    calc
      x % (3 * t) = (t * (x / t)) % (t * 3) := by
        rw [Nat.mul_div_cancel' hd, Nat.mul_comm t 3]
      _ = t * ((x / t) % 3) := Nat.mul_mod_mul_left _ _ _
      _ = t * (x % 3) := by rw [hq]

private theorem coincides_iff_divisor (k : ℕ) :
    Coincides k ↔ ∃ t : ℕ, 2 ≤ t ∧ 3 * t ≤ k ∧ t ∣ 2 * k ∧
      ((2 * k) / t) % 3 = (2 * k) % 3 := by
  constructor
  · rintro ⟨m, hm, hmk, ⟨t, rfl⟩, he⟩
    have ht : 2 ≤ t := by omega
    refine ⟨t, ht, hmk, (residue_factor_iff _ _ (by omega)).mp ?_⟩
    nlinarith
  · rintro ⟨t, ht, htk, hd, hq⟩
    refine ⟨3 * t, by omega, htk, dvd_mul_right _ _, ?_⟩
    have he := (residue_factor_iff _ _ (by omega : 0 < t)).mpr ⟨hd, hq⟩
    nlinarith

private theorem coincides_of_divisor_mod_one (k t : ℕ) (ht : 2 ≤ t)
    (htk : 3 * t ≤ k) (hd : t ∣ 2 * k) (hr : t % 3 = 1) : Coincides k := by
  apply (coincides_iff_divisor k).mpr
  refine ⟨t, ht, htk, hd, ?_⟩
  have hm := Nat.mul_mod t ((2 * k) / t) 3
  rw [Nat.mul_div_cancel' hd, hr, one_mul, Nat.mod_mod] at hm
  exact hm.symm

end D5.S3.Arith.Congruence.MultipleOfThreeCoincidence
