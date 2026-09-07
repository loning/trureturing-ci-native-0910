/- GID: D5/S3/Arith/GoldenResource/EightStepAbundancy
   generality: I
   mirror-B: D5/B/S3/Arith/GoldenResource/EightStepAbundancy
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: kind=certified-instance; basis=terminal=atom:4fe323b6326388b3aebf9da0f2910f0388dd51193f4933d1324e9bcb52f37844
   digest: Among positive integers with eight prime factors counted with multiplicity, 180180 uniquely maximizes sigma(n)/n at 224/55. -/

import D5.S3.Arith.GoldenResourceObjectiveFactorization

/- Search audit (2026-09-07, base 6634808834be9ae3d669f1f7075a92ae7771eeee):
   Repository searches with positive controls and Lean LSP found only adjacent results:
   finite non-strict prefix greedy optimality, the logarithmic-size-priced 5040 optimum,
   local threshold sufficiency, and objective factorization. The latter two are reused.
   Pinned Mathlib supplies sigma prime-power evaluation, multiplicative factorization,
   cardFactors_eq_sum_factorization, factorization_mul, and logarithm identities.
   GitHub Lean searches for 180180 and abundancy found no existing eight-step optimum.
   This is a known arithmetic result: OEIS A137825(8), with Wu (2019), arXiv:1906.05796.
   The new formal content is the unbounded prime-layer cutoff and strict uniqueness. -/

namespace D5.S3.Arith.GoldenResource.EightStepAbundancy

open Finset
open D5.S3.Arith.GoldenResourceOptimalInteger
open D5.S3.Arith.GoldenLocalThreshold
open D5.S3.Arith.GoldenResourceObjectiveFactorization

/-- The denominator of the gain from the positive prime layer `k`. -/
def layerDenominator (p k : ℕ) : ℕ := ∑ i ∈ range k, p ^ (i + 1)

private theorem denominator_mono (p : ℕ) {a b : ℕ} (h : a ≤ b) :
    layerDenominator p a ≤ layerDenominator p b :=
  sum_le_sum_of_subset (range_mono h)

/-- Exactly these eight prime layers have gain denominator below fourteen. -/
theorem eight_step_layer_cutoff {p k : ℕ} (hp : p.Prime) (hk : 1 ≤ k) :
    layerDenominator p k < 14 ↔
      (p, k) ∈ ({(2, 1), (3, 1), (5, 1), (2, 2),
        (7, 1), (11, 1), (3, 2), (13, 1)} : Finset (ℕ × ℕ)) := by
  constructor
  · intro hd
    have hk2 : k ≤ 2 := by
      by_contra h
      have h3 := denominator_mono p (show 3 ≤ k by omega)
      have h2 : 14 ≤ layerDenominator p 3 := by
        calc
          14 = layerDenominator 2 3 := by decide
          _ ≤ layerDenominator p 3 :=
            sum_le_sum fun i _ => Nat.pow_le_pow_left hp.two_le (i + 1)
      omega
    rcases (show k = 1 ∨ k = 2 by omega) with rfl | rfl
    · have hp14 : p < 14 := by simpa [layerDenominator, sum_range_succ] using hd
      interval_cases p <;> norm_num at *
    · have hp3 : p ≤ 3 := by
        norm_num [layerDenominator, sum_range_succ] at hd
        nlinarith [hp.two_le]
      interval_cases p <;> norm_num at *
  · intro h
    simp only [mem_insert, mem_singleton, Prod.mk.injEq] at h
    rcases h with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ |
      ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    all_goals norm_num [layerDenominator, sum_range_succ]

private def optimalExponent (p : ℕ) : ℕ :=
  if p = 2 ∨ p = 3 then 2 else if p = 5 ∨ p = 7 ∨ p = 11 ∨ p = 13 then 1 else 0

private theorem cutoff_exponent {p k : ℕ} (hp : p.Prime) (hk : 1 ≤ k) :
    layerDenominator p k < 14 ↔ k ≤ optimalExponent p := by
  rw [eight_step_layer_cutoff hp hk]
  simp only [mem_insert, mem_singleton, Prod.mk.injEq]
  unfold optimalExponent
  split_ifs <;> omega

private theorem denominator_pos {p k : ℕ} (hp : p.Prime) (hk : 1 ≤ k) :
    0 < layerDenominator p k := by
  have h := denominator_mono p hk
  have h1 : layerDenominator p 1 = p := by simp [layerDenominator]
  rw [h1] at h
  exact hp.pos.trans_le h

private theorem layer_ratio_identity {p k : ℕ} (hp : p.Prime) (hk : 1 ≤ k) :
    (1 - (p : ℝ)⁻¹ ^ (k + 1)) / (1 - (p : ℝ)⁻¹ ^ k) =
      1 + 1 / (layerDenominator p k : ℝ) := by
  have hp0 : (p : ℝ) ≠ 0 := by exact_mod_cast hp.ne_zero
  have hp1 : (p : ℝ) ≠ 1 := by exact_mod_cast hp.ne_one
  have hpk : (p : ℝ) ^ k ≠ 1 :=
    ne_of_gt (one_lt_pow₀ (by exact_mod_cast hp.one_lt) (by omega))
  have hd : (layerDenominator p k : ℝ) =
      ((p : ℝ) ^ k - 1) / ((p : ℝ) - 1) * p := by
    unfold layerDenominator
    push_cast
    simp only [pow_succ, ← sum_mul]
    rw [geom_sum_eq hp1]
  rw [hd]
  simp only [inv_pow, pow_succ]
  field_simp
  <;> ring

private noncomputable def lowerPrice : ℝ := Real.log (15 / 14)
private noncomputable def upperPrice : ℝ := Real.log (14 / 13)
private noncomputable def middlePrice : ℝ := (lowerPrice + upperPrice) / 2

private theorem price_gap : lowerPrice < upperPrice :=
  Real.log_lt_log (by norm_num) (by norm_num)

private theorem exponent_thresholds {p : ℕ} (hp : p.Prime) :
    (0 < optimalExponent p →
      upperPrice / Real.log p ≤ goldenLayerMarginal p (optimalExponent p)) ∧
    goldenLayerMarginal p (optimalExponent p + 1) ≤ lowerPrice / Real.log p := by
  have hl : 0 < Real.log (p : ℝ) := Real.log_pos (by exact_mod_cast hp.one_lt)
  constructor
  · intro ha
    have hd : (layerDenominator p (optimalExponent p) : ℝ) ≤ 13 := by
      exact_mod_cast (show layerDenominator p (optimalExponent p) ≤ 13 from
        Nat.le_of_lt_succ ((cutoff_exponent hp ha).mpr le_rfl))
    have hd0 : (0 : ℝ) < layerDenominator p (optimalExponent p) := by
      exact_mod_cast denominator_pos hp ha
    unfold goldenLayerMarginal
    rw [layer_ratio_identity hp ha]
    apply (div_le_div_iff_of_pos_right hl).mpr
    apply Real.log_le_log (by norm_num : (0 : ℝ) < 14 / 13)
    have hi := one_div_le_one_div_of_le hd0 hd
    norm_num at hi
    linarith
  · have hd : (14 : ℝ) ≤ layerDenominator p (optimalExponent p + 1) := by
      exact_mod_cast (show 14 ≤ layerDenominator p (optimalExponent p + 1) from
        Nat.le_of_not_gt (fun h => by
          have := (cutoff_exponent hp (by omega)).mp h
          omega))
    unfold goldenLayerMarginal
    rw [layer_ratio_identity hp (by omega)]
    apply (div_le_div_iff_of_pos_right hl).mpr
    apply Real.log_le_log (by positivity)
    have hi := one_div_le_one_div_of_le (by norm_num : (0 : ℝ) < 14) hd
    norm_num at hi
    linarith

private noncomputable def countLocal (c : ℝ) (p a : ℕ) : ℝ :=
  goldenPrimeLocalObjective 0 p a - c * a

private theorem count_local_eq (c : ℝ) {p : ℕ} (hp : p.Prime) (a : ℕ) :
    countLocal c p a = goldenPrimeLocalObjective (c / Real.log p) p a := by
  have hl : Real.log (p : ℝ) ≠ 0 := (Real.log_pos (by exact_mod_cast hp.one_lt)).ne'
  unfold countLocal goldenPrimeLocalObjective
  field_simp
  <;> ring

private theorem count_local_maximal {p : ℕ} (hp : p.Prime) {c : ℝ}
    (hcL : lowerPrice ≤ c) (hcU : c ≤ upperPrice) (b : ℕ) :
    countLocal c p b ≤ countLocal c p (optimalExponent p) := by
  have hl : 0 < Real.log (p : ℝ) := Real.log_pos (by exact_mod_cast hp.one_lt)
  obtain ⟨hup, hdown⟩ := exponent_thresholds hp
  rw [count_local_eq c hp b, count_local_eq c hp (optimalExponent p)]
  apply golden_prime_local_objective_maximal_of_threshold hp (c / Real.log p)
  · exact hdown.trans ((div_le_div_iff_of_pos_right hl).mpr hcL)
  · by_cases ha : optimalExponent p = 0
    · exact Or.inl ha
    · exact Or.inr (((div_le_div_iff_of_pos_right hl).mpr hcU).trans (hup (by omega)))

private theorem count_local_unique {p : ℕ} (hp : p.Prime) (b : ℕ) :
    countLocal middlePrice p b ≤ countLocal middlePrice p (optimalExponent p) ∧
    (countLocal middlePrice p b = countLocal middlePrice p (optimalExponent p) ↔
      b = optimalExponent p) := by
  have hgap := price_gap
  have hmidL : lowerPrice < middlePrice := by unfold middlePrice; linarith
  have hmidU : middlePrice < upperPrice := by unfold middlePrice; linarith
  refine ⟨count_local_maximal hp hmidL.le hmidU.le b, ⟨?_, fun h => by rw [h]⟩⟩
  intro heq
  have hL := count_local_maximal hp le_rfl hgap.le b
  have hU := count_local_maximal hp hgap.le le_rfl b
  rcases lt_trichotomy b (optimalExponent p) with h | h | h
  · have hb : (b : ℝ) < optimalExponent p := by exact_mod_cast h
    have hpos := mul_pos (sub_pos.mpr hmidU) (sub_pos.mpr hb)
    unfold countLocal at hU heq
    nlinarith
  · exact h
  · have hb : (optimalExponent p : ℝ) < b := by exact_mod_cast h
    have hpos := mul_pos (sub_pos.mpr hmidL) (sub_pos.mpr hb)
    unfold countLocal at hL heq
    nlinarith

#print axioms eight_step_layer_cutoff

end D5.S3.Arith.GoldenResource.EightStepAbundancy
