/- GID: D5/S3/Weil/ZetaBridge/WeilMovingScaleResidual
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilMovingScaleResidual
   mirror-E: none(waiver:actual-coefficient-tail-and-rational-cutoff)
   anchors: []
   digest: Construct rational cutoffs paying the complete arithmetic residual tail at every varying scale, even with degenerating coercivity. -/

import D5.S3.Weil.ZetaBridge.WeilArithmeticFullResidualTail
import Mathlib.Algebra.Order.Floor.Ring
import Mathlib.Topology.UniformSpace.UniformConvergence
import Mathlib.Topology.MetricSpace.Pseudo.Basic
import Mathlib.Analysis.SpecificLimits.Basic

/-!
# Moving-scale full residual truncation

A fixed-scale M -> infinity statement cannot silently be used when the
prime cutoff, trial vector, Fourier window and coercivity all change.
The present theorem constructs one finite cutoff at each scale. It proves
uniform disappearance of the WEIGHTED omitted residual over a supplied
frequency set, without assuming a uniform spectral gap or bounded growth
of the finite coefficient budgets.

Only the numerical exterior is eliminated. The retained variational
objective, retained residual, actual full-domain coercivity and correctly
normalized candidate limit remain independent mathematical obligations.
The all-scale Fourier limit transport already belongs to EnergyDualPaperFT
in PR #5882 and is not redefined here.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Weil.ZetaBridge.WeilMovingScaleResidual

open scoped BigOperators Topology
open Filter
open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open D5.S3.Weil.ZetaBridge.WeilArithmeticFullResidualTail

/-- A finite, cutoff-independent mass, evaluated from the actual four
boundary moments and the physical Cauchy prefactor. No moment is discarded. -/
noncomputable def residualScaleMass (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ)
    (N : ℝ) (pref : ℂ) : ℝ :=
  16 * (arithmeticBoundaryBudget c ^ 2 * ‖∑ n ∈ S, v n‖ ^ 2 +
    ‖∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n‖ ^ 2) / Real.pi ^ 2 +
  16 * (arithmeticBoundaryBudget c ^ 2 * ‖∑ n ∈ S, (n : ℂ) * v n‖ ^ 2 +
    ‖∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * ((n : ℂ) * v n)‖ ^ 2) /
      Real.pi ^ 2 +
  8 * ((4 * arithmeticBoundaryBudget c * N ^ 2 / Real.pi) *
    ∑ n ∈ S, ‖v n‖) ^ 2 + 64 * ‖pref‖ ^ 2 / 9

/-- A coarse rational envelope for every finite prime cutoff. The proof uses
only the actual finite von Mangoldt weights and the elementary hyperbolic
bound; no prime number theorem or unproved all-scale positivity is used. -/
theorem arithmetic_budget_le_quadratic {c : ℕ} (hc : 2 ≤ c) :
    arithmeticBoundaryBudget c ≤ (c : ℝ) ^ 2 + 2 * (c : ℝ) := by
  have hc1 : (1 : ℝ) ≤ c := by exact_mod_cast (by omega : 1 ≤ c)
  have hcp : (0 : ℝ) < c := by linarith
  have hl : 0 ≤ Real.log (c : ℝ) := Real.log_nonneg hc1
  have hcos : Real.cosh (Real.log (c : ℝ) / 2) ≤ Real.cosh (Real.log (c : ℝ)) := by
    apply Real.cosh_le_cosh.mpr
    rw [abs_of_nonneg (by positivity), abs_of_nonneg hl]
    linarith
  have hi : (c : ℝ)⁻¹ ≤ 1 := by
    simpa only [one_div, inv_one] using
      (one_div_le_one_div_of_le (by norm_num : (0 : ℝ) < 1) hc1)
  have hpole : 2 * Real.cosh (Real.log (c : ℝ) / 2) ≤ 2 * (c : ℝ) := by
    rw [Real.cosh_log hcp] at hcos
    linarith
  have hw (j : ℕ) (hj : j ∈ Finset.range c) :
      |ArithmeticFunction.vonMangoldt j / Real.sqrt (j : ℝ)| ≤ (c : ℝ) := by
    by_cases hj0 : j = 0
    · simp [hj0, hcp.le]
    have hj1 : (1 : ℝ) ≤ j := by exact_mod_cast (Nat.one_le_iff_ne_zero.mpr hj0)
    have hjp : (0 : ℝ) < j := by linarith
    have hs : 1 ≤ Real.sqrt (j : ℝ) := by
      nlinarith [Real.sq_sqrt (Nat.cast_nonneg j), Real.sqrt_nonneg (j : ℝ)]
    have hv : 0 ≤ ArithmeticFunction.vonMangoldt j := ArithmeticFunction.vonMangoldt_nonneg
    rw [abs_of_nonneg (div_nonneg hv (Real.sqrt_nonneg _))]
    calc
      _ ≤ ArithmeticFunction.vonMangoldt j := by
        simpa only [div_one] using
          (div_le_div_of_nonneg_left hv (by norm_num : (0 : ℝ) < 1) hs)
      _ ≤ Real.log (j : ℝ) := ArithmeticFunction.vonMangoldt_le_log
      _ ≤ (j : ℝ) := by linarith [Real.log_le_sub_one_of_pos hjp]
      _ ≤ (c : ℝ) := by exact_mod_cast (Finset.mem_range.mp hj).le
  have hsum : (∑ j ∈ Finset.range c,
      |ArithmeticFunction.vonMangoldt j / Real.sqrt (j : ℝ)|) ≤ (c : ℝ) ^ 2 := by
    calc
      _ ≤ ∑ _j ∈ Finset.range c, (c : ℝ) := Finset.sum_le_sum hw
      _ = _ := by simp [pow_two]
  change 2 * Real.cosh (Real.log (c : ℝ) / 2) +
    (∑ j ∈ Finset.range c, |ArithmeticFunction.vonMangoldt j / Real.sqrt (j : ℝ)|) ≤ _
  linarith

private theorem weighted_finite_moment_le (S : Finset ℤ) (a v : ℤ → ℂ)
    (b L : ℝ) (hb : 0 ≤ b) (ha : ∀ n ∈ S, ‖a n‖ ≤ b)
    (hv : (∑ n ∈ S, ‖v n‖) ≤ L) :
    ‖∑ n ∈ S, a n * v n‖ ≤ b * L := by
  calc
    _ ≤ ∑ n ∈ S, ‖a n * v n‖ := norm_sum_le _ _
    _ ≤ ∑ n ∈ S, b * ‖v n‖ := by
      apply Finset.sum_le_sum
      intro n hn
      rw [norm_mul]
      exact mul_le_mul_of_nonneg_right (ha n hn) (norm_nonneg _)
    _ = b * ∑ n ∈ S, ‖v n‖ := (Finset.mul_sum ..).symm
    _ ≤ b * L := mul_le_mul_of_nonneg_left hv hb

/-- An explicit polynomial mass cap from finite coefficient data. Thus the
moving-scale algorithm's mass certificate need not be an unexplained supremum.
The bound is deliberately coarse and makes no complexity or optimality claim. -/
theorem residual_scale_mass_polynomial {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) {N L P : ℝ}
    (hN : 0 ≤ N) (hL : 0 ≤ L) (hP : 0 ≤ P)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N)
    (hv : (∑ n ∈ S, ‖v n‖) ≤ L) (pref : ℂ) (hp : ‖pref‖ ≤ P) :
    residualScaleMass c S v N pref ≤
      32 * ((c : ℝ) ^ 2 + 2 * (c : ℝ)) ^ 2 * L ^ 2 * (1 + N ^ 2 + 4 * N ^ 4) +
        64 * P ^ 2 := by
  let b : ℝ := (c : ℝ) ^ 2 + 2 * (c : ℝ)
  let B := arithmeticBoundaryBudget c
  let l := ∑ n ∈ S, ‖v n‖
  have hb : 0 ≤ b := by dsimp [b]; positivity
  have hB0 : 0 ≤ B := (abs_nonneg _).trans (arithmetic_boundary_symbol_bound hc 0).2
  have hB : B ≤ b := arithmetic_budget_le_quadratic hc
  have hl : 0 ≤ l := Finset.sum_nonneg (fun _ _ => norm_nonneg _)
  have hm0 : ‖∑ n ∈ S, v n‖ ≤ L := (norm_sum_le _ _).trans hv
  have hsym (n : ℤ) : ‖(arithmeticBoundarySymbol c n : ℂ)‖ ≤ b := by
    simpa only [Complex.norm_real, Real.norm_eq_abs] using
      ((arithmetic_boundary_symbol_bound hc n).2.trans hB)
  have hmS := weighted_finite_moment_le S
    (fun n => (arithmeticBoundarySymbol c n : ℂ)) v b L hb (fun n _ => hsym n) hv
  have hm1 := weighted_finite_moment_le S (fun n => (n : ℂ)) v N L hN
    (fun n hn => by simpa using hS n hn) hv
  have hms1 : ‖∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * ((n : ℂ) * v n)‖ ≤
      (b * N) * L := by
    have hh := weighted_finite_moment_le S
      (fun n => (arithmeticBoundarySymbol c n : ℂ) * (n : ℂ)) v (b * N) L
      (mul_nonneg hb hN) (fun n hn => by
        rw [norm_mul]
        exact mul_le_mul (hsym n) (by simpa using hS n hn) (norm_nonneg _) hb) hv
    simpa only [mul_assoc] using hh
  have hB2 := pow_le_pow_left₀ hB0 hB 2
  have hm02 := pow_le_pow_left₀ (norm_nonneg _) hm0 2
  have hmS2 := pow_le_pow_left₀ (norm_nonneg _) hmS 2
  have hm12 := pow_le_pow_left₀ (norm_nonneg _) hm1 2
  have hms12 := pow_le_pow_left₀ (norm_nonneg _) hms1 2
  have hX : B ^ 2 * ‖∑ n ∈ S, v n‖ ^ 2 +
      ‖∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n‖ ^ 2 ≤ 2 * b ^ 2 * L ^ 2 := by
    have hh := mul_le_mul hB2 hm02 (sq_nonneg _) (sq_nonneg b)
    nlinarith
  have hY : B ^ 2 * ‖∑ n ∈ S, (n : ℂ) * v n‖ ^ 2 +
      ‖∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * ((n : ℂ) * v n)‖ ^ 2 ≤
      2 * b ^ 2 * N ^ 2 * L ^ 2 := by
    have hh := mul_le_mul hB2 hm12 (sq_nonneg _) (sq_nonneg b)
    nlinarith
  have hBL : B * l ≤ b * L := mul_le_mul hB hv hl hb
  have hq : (4 * B * N ^ 2 / Real.pi) * l ≤ 4 * b * N ^ 2 * L / Real.pi := by
    calc
      _ = (4 * N ^ 2 / Real.pi) * (B * l) := by ring
      _ ≤ (4 * N ^ 2 / Real.pi) * (b * L) :=
        mul_le_mul_of_nonneg_left hBL (by positivity)
      _ = _ := by ring
  have hq2 := pow_le_pow_left₀ (by positivity : 0 ≤ (4 * B * N ^ 2 / Real.pi) * l) hq 2
  have hp2 := pow_le_pow_left₀ (norm_nonneg pref) hp 2
  have hpi : 1 ≤ Real.pi ^ 2 := by nlinarith [Real.two_le_pi]
  let Z := 32 * b ^ 2 * L ^ 2 * (1 + N ^ 2 + 4 * N ^ 4)
  have hZ : 0 ≤ Z := by dsimp [Z]; positivity
  have hZdiv : Z / Real.pi ^ 2 ≤ Z := by
    simpa only [div_one] using (div_le_div_of_nonneg_left hZ (by norm_num : (0 : ℝ) < 1) hpi)
  have hPdiv : 64 * P ^ 2 / 9 ≤ 64 * P ^ 2 := by
    have hh := div_le_div_of_nonneg_left (by positivity : 0 ≤ 64 * P ^ 2)
      (by norm_num : (0 : ℝ) < 1) (by norm_num : (1 : ℝ) ≤ 9)
    simpa only [div_one] using hh
  have hfirst := div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hX (by norm_num : (0 : ℝ) ≤ 16))
    (sq_nonneg Real.pi)
  have hsecond := div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hY (by norm_num : (0 : ℝ) ≤ 16))
    (sq_nonneg Real.pi)
  have hthird := mul_le_mul_of_nonneg_left hq2 (by norm_num : (0 : ℝ) ≤ 8)
  have hfourth := div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hp2 (by norm_num : (0 : ℝ) ≤ 64))
    (by norm_num : (0 : ℝ) ≤ 9)
  calc
    _ ≤ 16 * (2 * b ^ 2 * L ^ 2) / Real.pi ^ 2 +
        16 * (2 * b ^ 2 * N ^ 2 * L ^ 2) / Real.pi ^ 2 +
        8 * (4 * b * N ^ 2 * L / Real.pi) ^ 2 + 64 * P ^ 2 / 9 :=
      add_le_add (add_le_add (add_le_add hfirst hsecond) hthird) hfourth
    _ = Z / Real.pi ^ 2 + 64 * P ^ 2 / 9 := by dsimp [Z]; field_simp [Real.pi_ne_zero] <;> ring
    _ ≤ Z + 64 * P ^ 2 := add_le_add hZdiv hPdiv
    _ = _ := by rfl

/-- A complete exterior residual at arbitrary prime cutoff c, trial and
frequency is at most mass/M once M dominates both finite bandwidths.
This derives a scale-independent-in-M majorant from the actual tail owner. -/
theorem full_residual_le_mass_div {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) {N : ℝ} (hN : 0 ≤ N)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N) (M : ℕ)
    (hM : 1 ≤ (M : ℝ)) (hNM : N < (M : ℝ)) (hdouble : 2 * N ≤ (M : ℝ))
    (pref frequency : ℂ) (hf : ‖frequency‖ ≤ (M : ℝ) / 2) :
    let f := fun j : ℕ =>
      ‖arithmeticReadoutResidual c S v pref frequency ((M + j + 1 : ℕ) : ℤ)‖ ^ 2 +
      ‖arithmeticReadoutResidual c S v pref frequency (-((M + j + 1 : ℕ) : ℤ))‖ ^ 2
    Summable f ∧ (∑' j : ℕ, f j) ≤ residualScaleMass c S v N pref / (M : ℝ) := by
  dsimp only
  obtain ⟨hs, ht⟩ := arithmetic_full_residual_tail hc S v hN hS M hNM pref frequency hf
  have hMp : 0 < (M : ℝ) := by linarith
  have hgap : 0 < (M : ℝ) - N := sub_pos.mpr hNM
  let B := arithmeticBoundaryBudget c
  let L := ∑ n ∈ S, ‖v n‖
  let X := B ^ 2 * ‖∑ n ∈ S, v n‖ ^ 2 +
    ‖∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n‖ ^ 2
  let Y := B ^ 2 * ‖∑ n ∈ S, (n : ℂ) * v n‖ ^ 2 +
    ‖∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * ((n : ℂ) * v n)‖ ^ 2
  let R := (2 * B * N ^ 2 * (M : ℝ) / (Real.pi * ((M : ℝ) - N))) * L
  let Q := (4 * B * N ^ 2 / Real.pi) * L
  have hB : 0 ≤ B := (abs_nonneg _).trans (arithmetic_boundary_symbol_bound hc 0).2
  have hL : 0 ≤ L := Finset.sum_nonneg (fun _ _ => norm_nonneg _)
  have hX : 0 ≤ X := by dsimp [X]; positivity
  have hY : 0 ≤ Y := by dsimp [Y]; positivity
  have hR : 0 ≤ R := by dsimp [R]; positivity
  have hratio : (M : ℝ) / ((M : ℝ) - N) ≤ 2 := by
    apply (div_le_iff₀ hgap).mpr
    linarith
  have hRQ : R ≤ Q := by
    calc
      R = (2 * B * N ^ 2 / Real.pi * L) *
          ((M : ℝ) / ((M : ℝ) - N)) := by
        dsimp [R]
        field_simp [Real.pi_ne_zero, hgap.ne']
        <;> ring
      _ ≤ (2 * B * N ^ 2 / Real.pi * L) * 2 :=
        mul_le_mul_of_nonneg_left hratio (by positivity)
      _ = Q := by dsimp [Q]; ring
  have hRQ2 := pow_le_pow_left₀ hR hRQ 2
  have hpow2 : 1 ≤ (M : ℝ) ^ 2 := by
    nlinarith [sq_nonneg ((M : ℝ) - 1)]
  have hpow4 : 1 ≤ (M : ℝ) ^ 4 := by
    nlinarith [sq_nonneg ((M : ℝ) ^ 2 - 1)]
  have hdiv (a : ℝ) (ha : 0 ≤ a) (k : ℕ) (hk : 1 ≤ (M : ℝ) ^ k) :
      a / (M : ℝ) ^ k ≤ a := by
    simpa only [div_one] using
      (div_le_div_of_nonneg_left ha (by norm_num : (0 : ℝ) < 1) hk)
  have hYdiv := hdiv (16 * Y / Real.pi ^ 2) (by positivity) 2 hpow2
  have hPdiv := hdiv (64 * ‖pref‖ ^ 2 / 9) (by positivity) 2 hpow2
  have hRdiv := hdiv (8 * R ^ 2) (by positivity) 4 hpow4
  have hbudget : (M : ℝ) * (2 * arithmeticColumnTailBudget c S v N M +
      64 * ‖pref‖ ^ 2 / (9 * (M : ℝ) ^ 3)) ≤ residualScaleMass c S v N pref := by
    change (M : ℝ) * (2 * (8 * X / (Real.pi ^ 2 * (M : ℝ)) +
      8 * Y / (Real.pi ^ 2 * (M : ℝ) ^ 3) + 4 * R ^ 2 / (M : ℝ) ^ 5) +
      64 * ‖pref‖ ^ 2 / (9 * (M : ℝ) ^ 3)) ≤
        16 * X / Real.pi ^ 2 + 16 * Y / Real.pi ^ 2 + 8 * Q ^ 2 + 64 * ‖pref‖ ^ 2 / 9
    calc
      _ = 16 * X / Real.pi ^ 2 + (16 * Y / Real.pi ^ 2) / (M : ℝ) ^ 2 +
          (8 * R ^ 2) / (M : ℝ) ^ 4 + (64 * ‖pref‖ ^ 2 / 9) / (M : ℝ) ^ 2 := by
        field_simp [Real.pi_ne_zero, hMp.ne']
        <;> ring
      _ ≤ _ := by nlinarith
  refine ⟨hs, ?_⟩
  apply (le_div_iff₀ hMp).mpr
  have hh := (mul_le_mul_of_nonneg_left ht hMp.le).trans hbudget
  simpa only [mul_comm] using hh

/-- Executable safe cutoff. mass, gain and tolerance are exact rational
certificates; the real arithmetic model must independently meet those caps.
The strict +1 also handles exact-integer thresholds and gain=0. -/
def rationalResidualCutoff (N R : ℕ) (mass gain tolerance : ℚ) : ℕ :=
  max (2 * N + 1) (max (2 * R + 1) (Nat.ceil (gain * mass / tolerance) + 1))

/-- The rational cutoff dominates the finite band, the Fourier frequency cap
and the weighted reciprocal-tail budget. No floating logarithm or search
termination assumption is used. -/
theorem rationalResidualCutoff_sound (N R : ℕ) (mass gain tolerance : ℚ)
    (ht : 0 < tolerance) :
    2 * N + 1 ≤ rationalResidualCutoff N R mass gain tolerance ∧
    2 * R + 1 ≤ rationalResidualCutoff N R mass gain tolerance ∧
    gain * mass < tolerance * (rationalResidualCutoff N R mass gain tolerance : ℚ) := by
  let M := rationalResidualCutoff N R mass gain tolerance
  have hN : 2 * N + 1 ≤ M := le_max_left _ _
  have hR : 2 * R + 1 ≤ M := (le_max_left _ _).trans (le_max_right _ _)
  have hceil : Nat.ceil (gain * mass / tolerance) + 1 ≤ M :=
    (le_max_right _ _).trans (le_max_right _ _)
  have hceil' : (Nat.ceil (gain * mass / tolerance) : ℚ) + 1 ≤ (M : ℚ) := by
    exact_mod_cast hceil
  have hx : gain * mass / tolerance < (M : ℚ) := by
    have hc := Nat.le_ceil (gain * mass / tolerance)
    linarith
  refine ⟨hN, hR, ?_⟩
  have hh := (div_lt_iff₀ ht).mp hx
  simpa only [mul_comm] using hh


/-- Apply the executable cutoff to the actual residual. The gain can include
normalization, ground-energy width and reciprocal coercivity; no positive
uniform lower bound on coercivity is needed by this tail theorem. -/
theorem weighted_residual_cutoff {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) (N R : ℕ)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ (N : ℝ)) (pref frequency : ℂ)
    (hf : ‖frequency‖ ≤ (R : ℝ)) (mass gain tolerance : ℚ)
    (hg : 0 ≤ gain) (ht : 0 < tolerance)
    (hcap : residualScaleMass c S v N pref ≤ (mass : ℝ)) :
    let M := rationalResidualCutoff N R mass gain tolerance
    let f := fun j : ℕ =>
      ‖arithmeticReadoutResidual c S v pref frequency ((M + j + 1 : ℕ) : ℤ)‖ ^ 2 +
      ‖arithmeticReadoutResidual c S v pref frequency (-((M + j + 1 : ℕ) : ℤ))‖ ^ 2
    Summable f ∧ (gain : ℝ) * (∑' j : ℕ, f j) < (tolerance : ℝ) := by
  dsimp only
  let M := rationalResidualCutoff N R mass gain tolerance
  obtain ⟨hn, hr, hgm⟩ := rationalResidualCutoff_sound N R mass gain tolerance ht
  have hn' : 2 * (N : ℝ) + 1 ≤ (M : ℝ) := by exact_mod_cast hn
  have hr' : 2 * (R : ℝ) + 1 ≤ (M : ℝ) := by exact_mod_cast hr
  have hM : 1 ≤ (M : ℝ) := by linarith [Nat.cast_nonneg N]
  have hMp : 0 < (M : ℝ) := by linarith
  have hgr : (0 : ℝ) ≤ gain := by exact_mod_cast hg
  have hgm' : (gain : ℝ) * (mass : ℝ) < (tolerance : ℝ) * (M : ℝ) := by
    exact_mod_cast hgm
  obtain ⟨hs, hb⟩ := full_residual_le_mass_div hc S v (Nat.cast_nonneg N) hS M
    hM (by linarith) (by linarith) pref frequency (by linarith)
  refine ⟨hs, ?_⟩
  calc
    _ ≤ (gain : ℝ) * (residualScaleMass c S v N pref / (M : ℝ)) :=
      mul_le_mul_of_nonneg_left hb hgr
    _ ≤ (gain : ℝ) * ((mass : ℝ) / (M : ℝ)) :=
      mul_le_mul_of_nonneg_left (div_le_div_of_nonneg_right hcap hMp.le) hgr
    _ = ((gain : ℝ) * (mass : ℝ)) / (M : ℝ) := by ring
    _ < (tolerance : ℝ) := (div_lt_iff₀ hMp).mpr hgm'

/-- Every moving-scale family of certified finite masses and gains admits
an explicit schedule with uniform geometric decay of its omitted residual.
The conclusion is independent of how fast those masses and gains grow.
It makes no assertion about the retained variational objective. -/
theorem moving_scale_exterior_tendstoUniformlyOn
    {Z : Type*} (K : Set Z) (c N R : ℕ → ℕ) (S : ℕ → Finset ℤ)
    (v : ℕ → Z → ℤ → ℂ) (pref frequency : ℕ → Z → ℂ)
    (mass gain : ℕ → ℚ)
    (hc : ∀ j, 2 ≤ c j) (hg : ∀ j, 0 ≤ gain j)
    (hS : ∀ j z, z ∈ K → ∀ n ∈ S j, |(n : ℝ)| ≤ (N j : ℝ))
    (hf : ∀ j z, z ∈ K → ‖frequency j z‖ ≤ (R j : ℝ))
    (hcap : ∀ j z, z ∈ K →
      residualScaleMass (c j) (S j) (v j z) (N j) (pref j z) ≤ (mass j : ℝ)) :
    let M := fun j => rationalResidualCutoff (N j) (R j) (mass j) (gain j)
      ((1 / 4 : ℚ) ^ (j + 1))
    TendstoUniformlyOn (fun j z => (gain j : ℝ) * ∑' n : ℕ,
      (‖arithmeticReadoutResidual (c j) (S j) (v j z) (pref j z) (frequency j z)
        ((M j + n + 1 : ℕ) : ℤ)‖ ^ 2 +
       ‖arithmeticReadoutResidual (c j) (S j) (v j z) (pref j z) (frequency j z)
        (-((M j + n + 1 : ℕ) : ℤ))‖ ^ 2)) (fun _ => 0) atTop K := by
  dsimp only
  apply Metric.tendstoUniformlyOn_iff.mpr
  intro eps heps
  have hp : Tendsto (fun j : ℕ => (1 / 4 : ℝ) ^ (j + 1)) atTop (𝓝 0) := by
    simpa only [pow_succ, zero_mul] using
      (tendsto_pow_atTop_nhds_zero_of_lt_one (by norm_num : (0 : ℝ) ≤ 1 / 4)
        (by norm_num : (1 / 4 : ℝ) < 1)).mul_const (1 / 4 : ℝ)
  filter_upwards [(tendsto_order.mp hp).2 eps heps] with j hj z hz
  obtain ⟨_, hb⟩ := weighted_residual_cutoff (hc j) (S j) (v j z) (N j) (R j)
    (hS j z hz) (pref j z) (frequency j z) (hf j z hz) (mass j) (gain j)
    ((1 / 4 : ℚ) ^ (j + 1)) (hg j) (by positivity) (hcap j z hz)
  have htcast : (((1 / 4 : ℚ) ^ (j + 1)) : ℝ) = (1 / 4 : ℝ) ^ (j + 1) := by
    push_cast <;> rfl
  rw [htcast] at hb
  rw [dist_zero_left, Real.norm_eq_abs, abs_of_nonneg]
  · exact hb.trans hj
  · exact mul_nonneg (by exact_mod_cast hg j)
      (tsum_nonneg fun _ => add_nonneg (sq_nonneg _) (sq_nonneg _))

#print axioms arithmetic_budget_le_quadratic
#print axioms residual_scale_mass_polynomial
#print axioms full_residual_le_mass_div
#print axioms rationalResidualCutoff_sound
#print axioms weighted_residual_cutoff
#print axioms moving_scale_exterior_tendstoUniformlyOn

end D5.S3.Weil.ZetaBridge.WeilMovingScaleResidual
