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

theorem a_eq (q : ℤ) (n : ℕ) (hn : 1 ≤ n) : a q n = (n : ℤ) * b q n := by
  simp [a, show n ≠ 0 by omega]

/-- The integral series q X L', where L is the exponent in the OEIS equation. -/
noncomputable def M (q : ℤ) : PowerSeries ℤ :=
  mk (fun n => if n = 0 then 0 else if n = 1 then q else (q * (n : ℤ) ^ 2 - 1) * b q n)

private theorem coeff_M (q : ℤ) (n : ℕ) (hn : 2 ≤ n) :
    coeff n (M q) = (q * (n : ℤ) ^ 2 - 1) * b q n := by
  simp [M, show n ≠ 0 by omega, show n ≠ 1 by omega]

private theorem convolution (q : ℤ) (n : ℕ) (hn : 2 ≤ n) :
    coeff n (M q * mk (a q)) = (q * (n : ℤ) ^ 2 - 1) * b q n +
      q * (n - 1 : ℕ) * b q (n - 1) +
      ∑ j ∈ Ico 2 n, (q * (j : ℤ) ^ 2 - 1) * (n - j : ℕ) * b q j * b q (n - j) := by
  rw [coeff_mul, Finset.Nat.sum_antidiagonal_eq_sum_range_succ
    (fun i j => coeff i (M q) * coeff j (mk (a q))) n, sum_range_succ]
  simp only [coeff_mk, Nat.sub_self, a_zero, mul_one]
  rw [← sum_range_add_sum_Ico _ hn]
  simp only [sum_range_succ, sum_range_zero, zero_add, Nat.sub_zero]
  have hz : coeff 0 (M q) = 0 := by simp [M]
  have ho : coeff 1 (M q) = q := by simp [M]
  rw [hz, ho, zero_mul, zero_add, a_eq q (n - 1) (by omega), coeff_M q n hn]
  rw [add_comm _ ((q * (n : ℤ) ^ 2 - 1) * b q n), add_assoc, ← mul_assoc]
  congr 1
  congr 1
  apply sum_congr rfl
  intro j hj
  obtain ⟨hj2, hjn⟩ := mem_Ico.mp hj
  rw [coeff_M q j hj2, a_eq q (n - j) (by omega)]
  ring

/-- Formal exponential reading: A(0)=1 and q X A' = (q X L') A. -/
theorem log_derivative_identity (q : ℤ) :
    coeff 0 (mk (a q)) = 1 ∧ C q * (X * derivative ℤ (mk (a q))) = M q * mk (a q) := by
  refine ⟨by simp [a_zero], ?_⟩
  ext n
  rcases n with _ | n
  · simp [M]
  by_cases hn : n + 1 = 1
  · have : n = 0 := by omega
    subst n
    rw [coeff_C_mul, coeff_succ_X_mul, coeff_derivative, coeff_mul,
      Finset.Nat.sum_antidiagonal_eq_sum_range_succ
        (fun i j => coeff i (M q) * coeff j (mk (a q))) 1]
    simp [sum_range_succ, M, a_zero, a_one]
  · rw [convolution q (n + 1) (by omega), coeff_C_mul, coeff_succ_X_mul, coeff_derivative,
      coeff_mk, a_eq q (n + 1) (by omega), add_assoc,
      ← b_recurrence q (n + 1) (by omega)]
    push_cast
    ring

theorem coeff_M_rat (q : ℤ) (n : ℕ) (hn : 2 ≤ n) :
    coeff n ((M q).map (Int.castRingHom ℚ)) =
      ((q : ℚ) * (n : ℚ) ^ 2 - 1) * (a q n : ℚ) / n := by
  rw [coeff_map, coeff_M q n hn, a_eq q n (by omega)]
  have hnq : (n : ℚ) ≠ 0 := by exact_mod_cast (show n ≠ 0 by omega)
  change (((q * (n : ℤ) ^ 2 - 1) * b q n : ℤ) : ℚ) = _
  push_cast
  field_simp

private theorem rational_identity (q : ℤ) :
    C (q : ℚ) * (X * derivative ℚ (mk (fun n => (a q n : ℚ)))) =
      (M q).map (Int.castRingHom ℚ) * mk (fun n => (a q n : ℚ)) := by
  have ha : (mk (a q)).map (Int.castRingHom ℚ) = mk (fun n => (a q n : ℚ)) := by
    ext n
    simp
  have hd : (derivative ℤ (mk (a q))).map (Int.castRingHom ℚ) =
      derivative ℚ ((mk (a q)).map (Int.castRingHom ℚ)) := by
    ext n
    simp [coeff_derivative]
  have he := congrArg (PowerSeries.map (Int.castRingHom ℚ)) (log_derivative_identity q).2
  simpa only [map_mul, map_C, map_X, hd, ha, Int.coe_castRingHom] using he

private theorem convolution_split (b : ℕ → ℚ) (m : PowerSeries ℚ)
    (hb : b 0 = 1) (hm : coeff 0 m = 0) (n : ℕ) (hn : 1 ≤ n) :
    coeff n (m * mk b) = coeff n m +
      ∑ j ∈ Ico 1 n, coeff j m * b (n - j) := by
  rw [coeff_mul, Finset.Nat.sum_antidiagonal_eq_sum_range_succ
    (fun i j => coeff i m * coeff j (mk b)) n, sum_range_succ]
  simp only [coeff_mk, Nat.sub_self, hb, mul_one]
  rw [← sum_range_add_sum_Ico _ hn]
  simp [hm, add_comm]

/-- The exact rational coefficient shape determines a unique solution. -/
theorem generating_unique (q : ℤ) (hq : q ≠ 0) (b : ℕ → ℚ) (m : PowerSeries ℚ)
    (hb0 : b 0 = 1) (hm0 : coeff 0 m = 0) (hm1 : coeff 1 m = (q : ℚ))
    (hshape : ∀ n : ℕ, 2 ≤ n → coeff n m = ((q : ℚ) * (n : ℚ) ^ 2 - 1) * b n / n)
    (heq : C (q : ℚ) * (X * derivative ℚ (mk b)) = m * mk b) :
    ∀ n : ℕ, b n = (a q n : ℚ) := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n ih =>
    by_cases hn0 : n = 0
    · subst n
      simp [hb0, a_zero]
    have hn : 1 ≤ n := by omega
    have hprev : ∀ j < n, coeff j m = coeff j ((M q).map (Int.castRingHom ℚ)) := by
      intro j hj
      by_cases hj0 : j = 0
      · subst j
        simp [hm0, M]
      by_cases hj1 : j = 1
      · subst j
        simp [hm1, M]
      rw [hshape j (by omega), coeff_M_rat q j (by omega), ih j hj]
    have hs : (∑ j ∈ Ico 1 n, coeff j m * b (n - j)) =
        ∑ j ∈ Ico 1 n, coeff j ((M q).map (Int.castRingHom ℚ)) * (a q (n - j) : ℚ) := by
      apply sum_congr rfl
      intro j hj
      obtain ⟨hj1, hjn⟩ := mem_Ico.mp hj
      rw [hprev j hjn, ih (n - j) (by omega)]
    have hx (f : PowerSeries ℚ) : coeff n (X * derivative ℚ f) =
        coeff n f * (n : ℚ) := by
      obtain ⟨r, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hn0
      simp [coeff_succ_X_mul, coeff_derivative]
    have hleft := congrArg (coeff n) heq
    have hright := congrArg (coeff n) (rational_identity q)
    rw [convolution_split b m hb0 hm0 n hn, coeff_C_mul, hx, coeff_mk, hs] at hleft
    rw [convolution_split (fun n => (a q n : ℚ)) _
      (by simp [a_zero]) (by simp [M]) n hn, coeff_C_mul, hx, coeff_mk] at hright
    by_cases hn1 : n = 1
    · subst n
      have hqq : (q : ℚ) ≠ 0 := by exact_mod_cast hq
      simpa [a_one] using (mul_left_cancel₀ hqq (by simpa [hm1] using hleft) : b 1 = 1)
    rw [hshape n (by omega)] at hleft
    rw [coeff_M_rat q n (by omega)] at hright
    have hdiff : (q : ℚ) * ((b n - (a q n : ℚ)) * n) =
        ((q : ℚ) * (n : ℚ) ^ 2 - 1) * (b n - (a q n : ℚ)) / n := by
      linear_combination hleft - hright
    have hnq : (n : ℚ) ≠ 0 := by exact_mod_cast hn0
    field_simp at hdiff
    nlinarith


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
