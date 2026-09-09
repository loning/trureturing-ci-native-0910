/- GID: D5/S1/Recurrence/Residue/ParametricExponentialSquareCongruence
   generality: G
   mirror-B: D5/B/S1/Recurrence/Residue/ParametricExponentialSquareCongruence
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Parameter congruence transports binary support; endpoint separation gives residues modulo eight. -/

import D5.S1.Recurrence.Residue.ExponentialSquareWeightCatalanParity
import Mathlib.Algebra.BigOperators.Intervals

open PowerSeries Finset

namespace D5.S1.Recurrence.Residue.ParametricExponentialSquareCongruence

/-- Integer normalization for the exponential square-weight family; the zero slot is unused. -/
noncomputable def b (q : ℤ) (n : ℕ) : ℤ :=
  if hn : 2 ≤ n then
    q * (n - 1 : ℕ) * b q (n - 1) + ∑ j ∈ range n,
      if _hj : 2 ≤ j ∧ j < n then
        (q * (j : ℤ) ^ 2 - 1) * (n - j : ℕ) * b q j * b q (n - j) else 0
  else if n = 1 then 1 else 0
termination_by n
decreasing_by all_goals omega

/-- The coefficient at zero is one, and positive coefficients are n times the normalization. -/
noncomputable def a (q : ℤ) (n : ℕ) : ℤ := if n = 0 then 1 else (n : ℤ) * b q n

private theorem b_zero (q : ℤ) : b q 0 = 0 := by rw [b]; norm_num
private theorem b_one (q : ℤ) : b q 1 = 1 := by rw [b]; norm_num
private theorem a_zero (q : ℤ) : a q 0 = 1 := by simp [a]
private theorem a_one (q : ℤ) : a q 1 = 1 := by simp [a, b_one]

/-- The convolution is over precisely 2 <= j < n, with ring subtraction in its weight. -/
theorem b_recurrence (q : ℤ) (n : ℕ) (hn : 2 ≤ n) :
    b q n = q * (n - 1 : ℕ) * b q (n - 1) +
      ∑ j ∈ Ico 2 n, (q * (j : ℤ) ^ 2 - 1) * (n - j : ℕ) * b q j * b q (n - j) := by
  rw [b, dif_pos hn]
  congr 1
  simp only [dite_eq_ite]
  rw [← sum_filter]
  congr 1
  ext j
  simp only [mem_filter, mem_range, mem_Ico]
  omega

/-- Odd parameters give the same normalized coefficients modulo two as the frozen q=1 series. -/
theorem normalized_mod_two (q : ℤ) (hq : Odd q) (n : ℕ) :
    (b q n : ZMod 2) = (ExponentialSquareWeightCatalanParity.d n : ZMod 2) := by
  have hq2 : (q : ZMod 2) = 1 := ZMod.intCast_eq_one_iff_odd.mpr hq
  induction n using Nat.strong_induction_on with
  | h n ih =>
    by_cases hn : 2 ≤ n
    · rw [b_recurrence q n hn, ExponentialSquareWeightCatalanParity.d_recurrence n hn]
      push_cast
      rw [hq2, one_mul, ih (n - 1) (by omega)]
      congr 1
      apply sum_congr rfl
      intro j hj
      obtain ⟨hj2, hjn⟩ := mem_Ico.mp hj
      rw [one_mul, ih j hjn, ih (n - j) (by omega)]
    · interval_cases n <;> rw [b, ExponentialSquareWeightCatalanParity.d] <;> norm_num

/-- All odd integer parameters have the source's power-of-two parity support, including n=0. -/
theorem odd_parameter_parity (q : ℤ) (hq : Odd q) (n : ℕ) :
    Odd (a q n) ↔ ∃ k : ℕ, n + 1 = 2 ^ k := by
  have he : (a q n : ZMod 2) = (ExponentialSquareWeightCatalanParity.a n : ZMod 2) := by
    by_cases hn : n = 0
    · subst n
      simp [a, ExponentialSquareWeightCatalanParity.a]
    · simp only [a, ExponentialSquareWeightCatalanParity.a, if_neg hn, Int.cast_mul,
        Int.cast_natCast, normalized_mod_two q hq n]
  rw [← ZMod.intCast_eq_one_iff_odd, he, ZMod.intCast_eq_one_iff_odd]
  exact ExponentialSquareWeightCatalanParity.hanna_conjecture n

#print axioms normalized_mod_two
#print axioms odd_parameter_parity

end D5.S1.Recurrence.Residue.ParametricExponentialSquareCongruence
