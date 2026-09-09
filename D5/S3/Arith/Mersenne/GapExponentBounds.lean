/- GID: D5/S3/Arith/Mersenne/GapExponentBounds
   generality: I
   mirror-B: D5/B/S3/Arith/Mersenne/GapExponentBounds
   mirror-E: none(waiver:general-symbolic-proof)
   anchors: []
   utility: none
   digest: Non-power-of-two square gaps of Mersenne form satisfy both binary exponent bounds. -/

import Mathlib.Data.Nat.Log
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith

namespace D5.S3.Arith.Mersenne.GapExponentBounds

private theorem gap_at_least_three (k r m : ℕ)
    (hnp : ∀ t, k ≠ 2 ^ t) (hr : r < k)
    (he : k ^ 2 + 1 = r ^ 2 + 2 ^ m) : r + 3 ≤ k := by
  cases m with
  | zero =>
      simp only [pow_zero] at he
      nlinarith
  | succ n =>
      have hgap_one : k ≠ r + 1 := by
        intro h
        apply hnp n
        rw [pow_succ (2 : ℕ) n] at he
        nlinarith
      have hgap_two : k ≠ r + 2 := by
        intro h
        have hmod := congrArg (fun x : ℕ => x % 2) he
        simp [h, Nat.add_mod, Nat.mul_mod, pow_succ] at hmod
        omega
      omega

private theorem six_mul_le_pow_add_eight (k r m : ℕ)
    (hnp : ∀ t, k ≠ 2 ^ t) (hr : r < k)
    (he : k ^ 2 + 1 = r ^ 2 + 2 ^ m) : 6 * k ≤ 2 ^ m + 8 := by
  have hgap := gap_at_least_three k r m hnp hr he
  have hsub : k - 3 + 3 = k := by omega
  have hs : r ≤ k - 3 := by omega
  have hsquare := Nat.pow_le_pow_left hs 2
  nlinarith

end D5.S3.Arith.Mersenne.GapExponentBounds
