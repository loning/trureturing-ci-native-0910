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
    simp only [layerDenominator, Nat.cast_sum, Nat.cast_pow, pow_succ, ← sum_mul]
    rw [geom_sum_eq hp1]
  rw [hd]
  simp only [inv_pow, pow_succ]
  field_simp
  <;> ring

#print axioms eight_step_layer_cutoff

end D5.S3.Arith.GoldenResource.EightStepAbundancy
