/- GID: D5/S1/Phase/CharacterAverage
   generality: G
   mirror-B: D5/B/S1/Phase/CharacterAverage
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Nonzero character averages of irrational rotations vanish at every initial phase. -/

import Mathlib.Algebra.Field.GeomSum
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.SpecialFunctions.Complex.Log
import Mathlib.NumberTheory.Real.Irrational

/- Search: Mathlib v4.33.0 supplies geom_sum_eq, exp_eq_one_iff, and Irrational.intCast_mul,
   but no exact character-average theorem was found in the searched modules. The external
   Weyl.mean_exponential_vanishes candidate has an unfinished proof (2026-09-07 inspection).
   This is step 1 of issue 6057: finite geometric sums only, with arbitrary initial phase. -/

namespace D5.S1.Phase.CharacterAverage

open Filter
open scoped Topology

private theorem rotation_step_ne_one (α : ℝ) (hα : Irrational α) (m : ℤ) (hm : m ≠ 0) :
    Complex.exp (2 * Real.pi * Complex.I * m * α) ≠ 1 := by
  intro h
  obtain ⟨k, hk⟩ := Complex.exp_eq_one_iff.mp h
  have hperiod : (2 * (Real.pi : ℂ) * Complex.I) ≠ 0 := Complex.two_pi_I_ne_zero
  have heq : (m : ℂ) * α = k := by
    apply mul_left_cancel₀ hperiod
    calc
      _ = 2 * Real.pi * Complex.I * m * α := by ring
      _ = (k : ℂ) * (2 * Real.pi * Complex.I) := hk
      _ = _ := by ring
  exact (hα.intCast_mul hm).ne_int k (by exact_mod_cast heq)

private theorem character_term_factor (α ρ : ℝ) (m : ℤ) (i : ℕ) :
    Complex.exp (2 * Real.pi * Complex.I * m * (ρ + (i : ℝ) * α)) =
      Complex.exp (2 * Real.pi * Complex.I * m * ρ) *
        Complex.exp (2 * Real.pi * Complex.I * m * α) ^ i := by
  rw [← Complex.exp_nat_mul, ← Complex.exp_add]
  congr 1
  push_cast
  ring

/-- The geometric-sum bound is independent of the initial phase and the sample size. -/
theorem norm_character_sum_le (α : ℝ) (hα : Irrational α) (ρ : ℝ)
    (m : ℤ) (hm : m ≠ 0) (N : ℕ) :
    ‖∑ i ∈ Finset.range N,
      Complex.exp (2 * Real.pi * Complex.I * m * (ρ + (i : ℝ) * α))‖ ≤
      2 / ‖Complex.exp (2 * Real.pi * Complex.I * m * α) - 1‖ := by
  have hsum : (∑ i ∈ Finset.range N,
      Complex.exp (2 * Real.pi * Complex.I * m * (ρ + (i : ℝ) * α))) =
      Complex.exp (2 * Real.pi * Complex.I * m * ρ) *
        ∑ i ∈ Finset.range N, Complex.exp (2 * Real.pi * Complex.I * m * α) ^ i := by
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl (fun i _ => character_term_factor α ρ m i)
  have hphase : ‖Complex.exp (2 * Real.pi * Complex.I * m * ρ)‖ = 1 := by
    simp [Complex.norm_exp]
  have hstep : ‖Complex.exp (2 * Real.pi * Complex.I * m * α)‖ = 1 := by
    simp [Complex.norm_exp]
  rw [hsum, norm_mul, hphase, one_mul,
    geom_sum_eq (rotation_step_ne_one α hα m hm), norm_div]
  apply div_le_div_of_nonneg_right _ (norm_nonneg _)
  calc
    _ ≤ ‖Complex.exp (2 * Real.pi * Complex.I * m * α) ^ N‖ + ‖(1 : ℂ)‖ :=
      norm_sub_le _ _
    _ = 2 := by norm_num [norm_pow, hstep]

/-- Every specified initial phase has vanishing nonzero character average. -/
theorem character_average_tendsto_zero (α : ℝ) (hα : Irrational α) (ρ : ℝ)
    (m : ℤ) (hm : m ≠ 0) :
    Tendsto (fun N : ℕ => (∑ i ∈ Finset.range N,
      Complex.exp (2 * Real.pi * Complex.I * m * (ρ + (i : ℝ) * α))) / (N : ℂ))
      atTop (𝓝 0) := by
  apply squeeze_zero_norm (fun N => ?_)
    (tendsto_const_div_atTop_nhds_zero_nat
      (2 / ‖Complex.exp (2 * Real.pi * Complex.I * m * α) - 1‖))
  rw [norm_div, Complex.norm_natCast]
  exact div_le_div_of_nonneg_right (norm_character_sum_le α hα ρ m hm N)
    (Nat.cast_nonneg N)

#print axioms norm_character_sum_le
#print axioms character_average_tendsto_zero

end D5.S1.Phase.CharacterAverage
