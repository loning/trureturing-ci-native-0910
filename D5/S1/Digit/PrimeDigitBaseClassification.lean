/- GID: D5/S1/Digit/PrimeDigitBaseClassification
   generality: G
   mirror-B: D5/B/S1/Digit/PrimeDigitBaseClassification
   mirror-E: none(waiver:algebraically-proved)
   anchors: [mathlib/module/Mathlib.Data.Nat.Digits.Defs]
   utility: none
   digest: Prime-digit bases exist exactly outside zero, one, four, six, and nine. -/

import Mathlib.Data.Nat.Digits.Defs
import Mathlib.Data.Nat.Prime.Defs

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S1.Digit.PrimeDigitBaseClassification

/-- Zero is excluded explicitly because `Nat.digits b 0` is the empty list. -/
def HasPrimeDigitBase (n : ℕ) : Prop :=
  n ≠ 0 ∧ ∃ b : ℕ, 1 < b ∧ ∀ d ∈ Nat.digits b n, Nat.Prime d

/-- The two uniform certificates, with digits in little-endian order. -/
theorem prime_digit_base_certificate (n : ℕ) (hn : 10 ≤ n) :
    (1 < (n - 2) / 2 ∧ Nat.digits ((n - 2) / 2) n = [2, 2]) ∨
      (1 < (n - 3) / 2 ∧ Nat.digits ((n - 3) / 2) n = [3, 2]) := by
  by_cases heven : n % 2 = 0
  · have hb : 2 < (n - 2) / 2 := by omega
    have hnrep : n = 2 + (n - 2) / 2 * 2 := by omega
    refine Or.inl ⟨by omega, ?_⟩
    conv_lhs => arg 2; rw [hnrep]
    rw [Nat.digits_add _ (by omega) 2 2 hb (Or.inl (by decide)),
      Nat.digits_of_lt _ 2 (by decide) hb]
  · have hb : 3 < (n - 3) / 2 := by omega
    have hnrep : n = 3 + (n - 3) / 2 * 2 := by omega
    refine Or.inr ⟨by omega, ?_⟩
    conv_lhs => arg 2; rw [hnrep]
    rw [Nat.digits_add _ (by omega) 3 2 hb (Or.inl (by decide)),
      Nat.digits_of_lt _ 2 (by decide) (by omega)]

#print axioms prime_digit_base_certificate

end D5.S1.Digit.PrimeDigitBaseClassification
