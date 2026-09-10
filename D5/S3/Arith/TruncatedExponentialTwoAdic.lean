/- GID: D5/S3/Arith/TruncatedExponentialTwoAdic
   generality: I
   mirror-B: D5/B/S3/Arith/TruncatedExponentialTwoAdic
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Six-step truncation and odd-power periodicity control binary cancellation. -/

import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic
open scoped BigOperators
namespace D5.S3.Arith.TruncatedExponentialTwoAdic

private def H (n : ℕ) : ℕ → ℕ
  | 0 => 1
  | m + 1 => n ^ (m + 1) + (m + 1) * H n m

def S (n k : ℕ) : ℕ :=
  ∑ j ∈ Finset.range (n - k + 1), (n - k).factorial / j.factorial * n ^ j

private lemma h_sum (n m : ℕ) :
    H n m = ∑ j ∈ Finset.range (m + 1), m.factorial / j.factorial * n ^ j := by
  induction m with
  | zero => simp [H]
  | succ m ih =>
    rw [H, Finset.sum_range_succ, ih, Finset.mul_sum]
    simp only [Nat.div_self (Nat.factorial_pos _), one_mul]
    rw [add_comm]
    congr 1
    apply Finset.sum_congr rfl
    intro j hj
    have hd := Nat.factorial_dvd_factorial (show j ≤ m by simpa using hj)
    rw [Nat.factorial_succ, Nat.mul_div_assoc _ hd, mul_assoc]

private lemma six_zero (x : ZMod 16) :
    (x+1)*(x+2)*(x+3)*(x+4)*(x+5)*(x+6) = 0 := by
  fin_cases x <;> decide

private lemma six (n m : ℕ) : (H n (m+6) : ZMod 16) =
    (n : ZMod 16)^m * ((n : ZMod 16)^6 + (m+6) *
      ((n : ZMod 16)^5 + (m+5) * ((n : ZMod 16)^4 + (m+4) *
      ((n : ZMod 16)^3 + (m+3) * ((n : ZMod 16)^2 + (m+2) * (n : ZMod 16)))))) := by
  simp only [H, Nat.cast_add, Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat]
  simp only [pow_add]
  have hz := six_zero (m : ZMod 16)
  linear_combination (H n m : ZMod 16) * hz

private lemma val_mod {a : ℕ} (ha : a % 16 ≠ 0) :
    padicValNat 2 a = padicValNat 2 (a % 16) := by
  have ha0 : a ≠ 0 := by intro h; simp [h] at ha
  have hv (b : ℕ) (hb : b ≠ 0) (h16 : ¬16 ∣ b) : padicValNat 2 b < 4 := by
    have := (padicValNat_dvd_iff_le (p := 2) (n := 4) hb).not.mp h16
    omega
  have hva := hv a ha0 (by simpa [Nat.dvd_iff_mod_eq_zero] using ha)
  have hvr := hv (a % 16) ha (by simpa [Nat.dvd_iff_mod_eq_zero] using ha)
  have he (t : ℕ) (ht : t ≤ 4) : 2 ^ t ∣ a % 16 ↔ 2 ^ t ∣ a :=
    Nat.dvd_mod_iff (show 2 ^ t ∣ 16 from pow_dvd_pow 2 ht)
  apply Nat.le_antisymm
  · exact (padicValNat_dvd_iff_le ha).mp ((he _ hva.le).mpr pow_padicValNat_dvd)
  · exact (padicValNat_dvd_iff_le ha0).mp ((he _ hvr.le).mp pow_padicValNat_dvd)

private lemma odd_four (x : ZMod 16) (hx : x.val % 2 = 1) : x ^ 4 = 1 := by
  fin_cases x <;> revert hx <;> decide

private lemma odd_pow (n m : ℕ) (hn : n % 2 = 1) :
    (n : ZMod 16)^m = (n : ZMod 16)^(m % 4) := by
  have hf : (n : ZMod 16)^4 = 1 := odd_four _ (by simpa [ZMod.val_natCast] using hn)
  exact pow_eq_pow_mod m hf


private def P (x y : ZMod 16) : ZMod 16 :=
  x^6 + (y+6)*(x^5+(y+5)*(x^4+(y+4)*(x^3+(y+3)*(x^2+(y+2)*x))))

private lemma large_table (x y : ZMod 16) (hx : x.val % 2 = 1)
    (hk : (x-y-4).val ≠ 0) :
    (x^(y.val % 4) * P x y).val ≠ 0 ∧
    padicValNat 2 (x^(y.val % 4) * P x y).val = padicValNat 2 (x-y-4).val := by
  revert hx hk
  fin_cases x <;> fin_cases y <;> decide +kernel

end D5.S3.Arith.TruncatedExponentialTwoAdic
