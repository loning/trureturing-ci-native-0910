/- GID: D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord
   generality: I
   mirror-B: D5/B/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: kind=certified-instance; basis=terminal=atom:d106e27218c2ce1eb164bf497db51656ed379cdae65921afa7ff6d0e0605a907; result=D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.deeply_composite_25200_not_in_Binfty
   digest: The deeply composite number 25200 is never a strict prime-exponent-score record. -/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum.Prime

open scoped BigOperators NNReal

namespace D5.S3.Factorization.DeeplyCompositeNotPrimeExponentRecord

/-- The prime-exponent score from OEIS A384669. -/
noncomputable def fx (n : ℕ) (x : ℝ) : ℝ :=
  ∑ p ∈ n.primeFactors, ((n.factorization p : ℕ) : ℝ) ^ x

/-- `Div⁺(n)` lexicographically precedes `Div⁺(m)`, expressed by the
least positive integer on which their divisibility predicates differ. -/
def DivPlusPrecedes (n m : ℕ) : Prop :=
  ∃ d : ℕ, 1 ≤ d ∧ d ∣ n ∧ ¬ d ∣ m ∧
    ∀ e : ℕ, 1 ≤ e → e < d → (e ∣ n ↔ e ∣ m)

/-- Record-low divisor list formulation of a deeply composite number. -/
def DC (n : ℕ) : Prop :=
  1 ≤ n ∧ ∀ m : ℕ, 1 ≤ m → m < n → DivPlusPrecedes n m

/-- Strict record for the prime-exponent score. -/
def StrictRecord (x : ℝ) (n : ℕ) : Prop :=
  ∀ m : ℕ, m < n → 1 ≤ m → fx m x < fx n x

/-- The real-parameter form of Switkay's union `B_∞` from the A385722 attachment.
StrictRecord x 0 holds vacuously, so 0 ∈ Binfty under this definition; the source sequence is over
positive integers and every covered clause concerns 25200, unaffected by the convention. -/
def Binfty : Set ℕ :=
  {n | ∃ x : ℝ, 0 < x ∧ x < 1 ∧ StrictRecord x n}

theorem literal_factorizations :
    25200 = 2 ^ 4 * 3 ^ 2 * 5 ^ 2 * 7 ∧
      18480 = 2 ^ 4 * 3 * 5 * 7 * 11 ∧
      20160 = 2 ^ 6 * 3 ^ 2 * 5 * 7 := by
  norm_num

private lemma factorization_25200 : (25200).factorization =
    Finsupp.single 2 4 + Finsupp.single 3 2 +
      Finsupp.single 5 2 + Finsupp.single 7 1 := by
  rw [literal_factorizations.1]
  rw [Nat.factorization_mul (by norm_num) (by norm_num),
    Nat.factorization_mul (by norm_num) (by norm_num),
    Nat.factorization_mul (by norm_num) (by norm_num)]
  change (2 ^ 4).factorization + (3 ^ 2).factorization +
    (5 ^ 2).factorization + (7 ^ 1).factorization = _
  rw [(by norm_num : Nat.Prime 2).factorization_pow,
    (by norm_num : Nat.Prime 3).factorization_pow,
    (by norm_num : Nat.Prime 5).factorization_pow,
    (by norm_num : Nat.Prime 7).factorization_pow]

private lemma primeFactors_25200 : (25200).primeFactors = {2, 3, 5, 7} := by
  rw [← Nat.support_factorization, factorization_25200]
  ext p
  simp only [Finsupp.mem_support_iff]
  by_cases hp2 : p = 2 <;> by_cases hp3 : p = 3 <;>
    by_cases hp5 : p = 5 <;> by_cases hp7 : p = 7 <;>
    simp [hp2, hp3, hp5, hp7]

private lemma factorization_18480 : (18480).factorization =
    Finsupp.single 2 4 + Finsupp.single 3 1 + Finsupp.single 5 1 +
      Finsupp.single 7 1 + Finsupp.single 11 1 := by
  rw [literal_factorizations.2.1]
  rw [Nat.factorization_mul (by norm_num) (by norm_num),
    Nat.factorization_mul (by norm_num) (by norm_num),
    Nat.factorization_mul (by norm_num) (by norm_num),
    Nat.factorization_mul (by norm_num) (by norm_num)]
  rw [(by norm_num : Nat.Prime 2).factorization_pow,
    (by norm_num : Nat.Prime 3).factorization,
    (by norm_num : Nat.Prime 5).factorization,
    (by norm_num : Nat.Prime 7).factorization,
    (by norm_num : Nat.Prime 11).factorization]

private lemma primeFactors_18480 : (18480).primeFactors = {2, 3, 5, 7, 11} := by
  rw [← Nat.support_factorization, factorization_18480]
  ext p
  simp only [Finsupp.mem_support_iff]
  by_cases hp2 : p = 2 <;> by_cases hp3 : p = 3 <;>
    by_cases hp5 : p = 5 <;> by_cases hp7 : p = 7 <;>
    by_cases hp11 : p = 11 <;> simp [hp2, hp3, hp5, hp7, hp11]

private lemma factorization_20160 : (20160).factorization =
    Finsupp.single 2 6 + Finsupp.single 3 2 +
      Finsupp.single 5 1 + Finsupp.single 7 1 := by
  rw [literal_factorizations.2.2]
  rw [Nat.factorization_mul (by norm_num) (by norm_num),
    Nat.factorization_mul (by norm_num) (by norm_num),
    Nat.factorization_mul (by norm_num) (by norm_num)]
  rw [(by norm_num : Nat.Prime 2).factorization_pow,
    (by norm_num : Nat.Prime 3).factorization_pow,
    (by norm_num : Nat.Prime 5).factorization,
    (by norm_num : Nat.Prime 7).factorization]

private lemma primeFactors_20160 : (20160).primeFactors = {2, 3, 5, 7} := by
  rw [← Nat.support_factorization, factorization_20160]
  ext p
  simp only [Finsupp.mem_support_iff]
  by_cases hp2 : p = 2 <;> by_cases hp3 : p = 3 <;>
    by_cases hp5 : p = 5 <;> by_cases hp7 : p = 7 <;>
    simp [hp2, hp3, hp5, hp7]

lemma fx_25200 (x : ℝ) :
    fx 25200 x = (2 : ℝ) ^ (2 * x) + 2 * (2 : ℝ) ^ x + 1 := by
  rw [fx, primeFactors_25200]
  simp [factorization_25200]
  have h4 : (4 : ℝ) ^ x = (2 : ℝ) ^ (2 * x) := by
    convert (Real.rpow_natCast_mul (x := (2 : ℝ)) (by norm_num) 2 x).symm using 1 <;>
      norm_num
  rw [h4]
  ring

lemma fx_18480 (x : ℝ) :
    fx 18480 x = (2 : ℝ) ^ (2 * x) + 4 := by
  rw [fx, primeFactors_18480]
  simp [factorization_18480]
  have h4 : (4 : ℝ) ^ x = (2 : ℝ) ^ (2 * x) := by
    convert (Real.rpow_natCast_mul (x := (2 : ℝ)) (by norm_num) 2 x).symm using 1 <;>
      norm_num
  rw [h4]
  ring

lemma fx_20160 (x : ℝ) :
    fx 20160 x = (2 : ℝ) ^ x * (3 : ℝ) ^ x + (2 : ℝ) ^ x + 2 := by
  rw [fx, primeFactors_20160]
  simp [factorization_20160]
  rw [show (6 : ℝ) = 2 * 3 by norm_num, Real.mul_rpow (by norm_num) (by norm_num)]
  ring

private lemma dvd_2520_of_prefix (m : ℕ) (h8 : 8 ∣ m) (h9 : 9 ∣ m)
    (h5 : 5 ∣ m) (h7 : 7 ∣ m) : 2520 ∣ m := by
  have h72 : 8 * 9 ∣ m :=
    (by decide : Nat.Coprime 8 9).mul_dvd_of_dvd_of_dvd h8 h9
  have h35 : 5 * 7 ∣ m :=
    (by decide : Nat.Coprime 5 7).mul_dvd_of_dvd_of_dvd h5 h7
  have hprod : (8 * 9) * (5 * 7) ∣ m :=
    (by decide : Nat.Coprime (8 * 9) (5 * 7)).mul_dvd_of_dvd_of_dvd h72 h35
  norm_num at hprod ⊢
  exact hprod

theorem score_gap_identity (t z : ℝ) (hz : z = t - 3 / 2) :
    32 * (t ^ 5 - (t ^ 2 + t - 1) ^ 2) =
      32 * z ^ 5 + 208 * z ^ 4 + 464 * z ^ 3 +
        392 * z ^ 2 + 106 * z + 1 := by
  rw [hz]
  ring

theorem dc_25200 : DC 25200 := by
  refine ⟨by norm_num, ?_⟩
  intro m hmpos hmlt
  by_cases h2520 : 2520 ∣ m
  · rcases h2520 with ⟨j, rfl⟩
    have hjpos : 1 ≤ j := by omega
    have hjlt : j < 10 := by omega
    have hjcases : j = 1 ∨ j = 2 ∨ j = 3 ∨ j = 4 ∨ j = 5 ∨
        j = 6 ∨ j = 7 ∨ j = 8 ∨ j = 9 := by omega
    rcases hjcases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
    · refine ⟨16, by norm_num, by norm_num, by norm_num, ?_⟩
      intro e he hel
      interval_cases e <;> norm_num
    · refine ⟨25, by norm_num, by norm_num, by norm_num, ?_⟩
      intro e he hel
      interval_cases e <;> norm_num
    · refine ⟨16, by norm_num, by norm_num, by norm_num, ?_⟩
      intro e he hel
      interval_cases e <;> norm_num
    · refine ⟨25, by norm_num, by norm_num, by norm_num, ?_⟩
      intro e he hel
      interval_cases e <;> norm_num
    · refine ⟨16, by norm_num, by norm_num, by norm_num, ?_⟩
      intro e he hel
      interval_cases e <;> norm_num
    · refine ⟨25, by norm_num, by norm_num, by norm_num, ?_⟩
      intro e he hel
      interval_cases e <;> norm_num
    · refine ⟨16, by norm_num, by norm_num, by norm_num, ?_⟩
      intro e he hel
      interval_cases e <;> norm_num
    · refine ⟨25, by norm_num, by norm_num, by norm_num, ?_⟩
      intro e he hel
      interval_cases e <;> norm_num
    · refine ⟨16, by norm_num, by norm_num, by norm_num, ?_⟩
      intro e he hel
      interval_cases e <;> norm_num
  · by_cases h2 : 2 ∣ m
    · by_cases h3 : 3 ∣ m
      · by_cases h4 : 4 ∣ m
        · by_cases h5 : 5 ∣ m
          · by_cases h6 : 6 ∣ m
            · by_cases h7 : 7 ∣ m
              · by_cases h8 : 8 ∣ m
                · by_cases h9 : 9 ∣ m
                  · by_cases h10 : 10 ∣ m
                    · exact (h2520 (dvd_2520_of_prefix m h8 h9 h5 h7)).elim
                    · refine ⟨10, by norm_num, by norm_num, h10, ?_⟩
                      intro e he hel
                      interval_cases e <;> norm_num <;> assumption
                  · refine ⟨9, by norm_num, by norm_num, h9, ?_⟩
                    intro e he hel
                    interval_cases e <;> norm_num <;> assumption
                · refine ⟨8, by norm_num, by norm_num, h8, ?_⟩
                  intro e he hel
                  interval_cases e <;> norm_num <;> assumption
              · refine ⟨7, by norm_num, by norm_num, h7, ?_⟩
                intro e he hel
                interval_cases e <;> norm_num <;> assumption
            · refine ⟨6, by norm_num, by norm_num, h6, ?_⟩
              intro e he hel
              interval_cases e <;> norm_num <;> assumption
          · refine ⟨5, by norm_num, by norm_num, h5, ?_⟩
            intro e he hel
            interval_cases e <;> norm_num <;> assumption
        · refine ⟨4, by norm_num, by norm_num, h4, ?_⟩
          intro e he hel
          interval_cases e <;> norm_num <;> assumption
      · refine ⟨3, by norm_num, by norm_num, h3, ?_⟩
        intro e he hel
        interval_cases e <;> norm_num <;> assumption
    · refine ⟨2, by norm_num, by norm_num, h2, ?_⟩
      intro e he hel
      interval_cases e <;> norm_num

theorem score_25200_le_competitors (x : ℝ) :
    fx 25200 x ≤ max (fx 18480 x) (fx 20160 x) := by
  rw [fx_25200, fx_18480, fx_20160]
  let t : ℝ := (2 : ℝ) ^ x
  let u : ℝ := (3 : ℝ) ^ x
  have htpos : 0 < t := Real.rpow_pos_of_pos (by norm_num) x
  have hupos : 0 < u := Real.rpow_pos_of_pos (by norm_num) x
  have ht_sq : (2 : ℝ) ^ (2 * x) = t ^ 2 := by
    dsimp [t]
    rw [mul_comm]
    exact Real.rpow_mul_natCast (by norm_num) x 2
  rw [ht_sq]
  by_cases ht : t ≤ 3 / 2
  · apply le_max_of_le_left
    nlinarith
  · apply le_max_of_le_right
    have ht32 : 3 / 2 < t := lt_of_not_ge ht
    have hxpos : 0 < x := by
      rw [← (Real.rpow_lt_rpow_left_iff (by norm_num : (1 : ℝ) < 2))]
      simpa [t] using (show (1 : ℝ) < t by linarith)
    have hu_sq : u ^ 2 = (9 : ℝ) ^ x := by
      calc
        u ^ 2 = (3 : ℝ) ^ (x * (2 : ℕ)) := by
          exact (Real.rpow_mul_natCast (by norm_num) x 2).symm
        _ = (3 : ℝ) ^ ((2 : ℕ) * x) := by congr 1 <;> ring
        _ = ((3 : ℝ) ^ (2 : ℕ)) ^ x := Real.rpow_natCast_mul (by norm_num) 2 x
        _ = (9 : ℝ) ^ x := by norm_num
    have ht_cube : t ^ 3 = (8 : ℝ) ^ x := by
      calc
        t ^ 3 = (2 : ℝ) ^ (x * (3 : ℕ)) := by
          exact (Real.rpow_mul_natCast (by norm_num) x 3).symm
        _ = (2 : ℝ) ^ ((3 : ℕ) * x) := by congr 1 <;> ring
        _ = ((2 : ℝ) ^ (3 : ℕ)) ^ x := Real.rpow_natCast_mul (by norm_num) 3 x
        _ = (8 : ℝ) ^ x := by norm_num
    have hu2_ge_t3 : t ^ 3 ≤ u ^ 2 := by
      rw [hu_sq, ht_cube]
      exact Real.rpow_le_rpow (by norm_num) (by norm_num) hxpos.le
    let z : ℝ := t - 3 / 2
    have hz : 0 ≤ z := by dsimp [z]; linarith
    have hidentity := score_gap_identity t z (by rfl)
    have hdiff : 0 < t ^ 5 - (t ^ 2 + t - 1) ^ 2 := by
      have hz2 : 0 ≤ z ^ 2 := sq_nonneg z
      have hz3 : 0 ≤ z ^ 3 := by positivity
      have hz4 : 0 ≤ z ^ 4 := by positivity
      have hz5 : 0 ≤ z ^ 5 := by positivity
      nlinarith [hidentity]
    have hsqmul : t ^ 5 ≤ (t * u) ^ 2 := by
      have hmul := mul_le_mul_of_nonneg_left hu2_ge_t3 (sq_nonneg t)
      nlinarith
    have hbasepos : 0 < t ^ 2 + t - 1 := by nlinarith [sq_nonneg t]
    have htupos : 0 < t * u := mul_pos htpos hupos
    have hmain : t ^ 2 + t - 1 < t * u := by
      nlinarith [sq_nonneg (t * u - (t ^ 2 + t - 1)), hdiff, hsqmul]
    nlinarith

theorem not_strictRecord_25200 (x : ℝ) : ¬ StrictRecord x 25200 := by
  intro hrecord
  have h18480 := hrecord 18480 (by norm_num) (by norm_num)
  have h20160 := hrecord 20160 (by norm_num) (by norm_num)
  exact (not_lt_of_ge (score_25200_le_competitors x)) (max_lt h18480 h20160)

/-- The whole candidate theorem: 25200 is deeply composite but never a strict
prime-exponent-score record, for any real parameter. -/
theorem deeply_composite_25200_not_in_Binfty :
    DC 25200 ∧ ∀ x : ℝ, ¬ StrictRecord x 25200 :=
  ⟨dc_25200, not_strictRecord_25200⟩

/-- Consequently, 25200 is not in Switkay's union `B_∞`. -/
theorem not_mem_Binfty_25200 : 25200 ∉ Binfty := by
  rintro ⟨x, _hxpos, _hxlt, hrecord⟩
  exact not_strictRecord_25200 x hrecord

example : DC 12 := by
  refine ⟨by norm_num, ?_⟩
  intro m hm hlt
  interval_cases m
  · refine ⟨2, by norm_num, by norm_num, by norm_num, ?_⟩
    intro e he hel
    interval_cases e <;> norm_num
  · refine ⟨3, by norm_num, by norm_num, by norm_num, ?_⟩
    intro e he hel
    interval_cases e <;> norm_num
  · refine ⟨2, by norm_num, by norm_num, by norm_num, ?_⟩
    intro e he hel
    interval_cases e <;> norm_num
  · refine ⟨3, by norm_num, by norm_num, by norm_num, ?_⟩
    intro e he hel
    interval_cases e <;> norm_num
  · refine ⟨2, by norm_num, by norm_num, by norm_num, ?_⟩
    intro e he hel
    interval_cases e <;> norm_num
  · refine ⟨4, by norm_num, by norm_num, by norm_num, ?_⟩
    intro e he hel
    interval_cases e <;> norm_num
  · refine ⟨2, by norm_num, by norm_num, by norm_num, ?_⟩
    intro e he hel
    interval_cases e <;> norm_num
  · refine ⟨3, by norm_num, by norm_num, by norm_num, ?_⟩
    intro e he hel
    interval_cases e <;> norm_num
  · refine ⟨2, by norm_num, by norm_num, by norm_num, ?_⟩
    intro e he hel
    interval_cases e <;> norm_num
  · refine ⟨3, by norm_num, by norm_num, by norm_num, ?_⟩
    intro e he hel
    interval_cases e <;> norm_num
  · refine ⟨2, by norm_num, by norm_num, by norm_num, ?_⟩
    intro e he hel
    interval_cases e <;> norm_num

example : ¬ DC 8 := by
  intro h
  rcases h.2 6 (by norm_num) (by norm_num) with ⟨d, hdpos, hd8, hnd6, hprefix⟩
  have hdgt : 3 < d := by
    by_contra hsmall
    have hcases : d = 1 ∨ d = 2 ∨ d = 3 := by omega
    rcases hcases with h1 | h2 | h3
    · subst d
      norm_num at hnd6
    · subst d
      norm_num at hnd6
    · subst d
      norm_num at hd8
  have h3 := hprefix 3 (by norm_num) hdgt
  norm_num at h3

-- The parameter interval and all quantified domains are inhabited.
example : ∃ x : ℝ, 0 < x ∧ x < 1 := ⟨1 / 2, by norm_num, by norm_num⟩
example : ℕ := 1
example : ℝ := 0

end D5.S3.Factorization.DeeplyCompositeNotPrimeExponentRecord
