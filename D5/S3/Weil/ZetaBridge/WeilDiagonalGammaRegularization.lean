/- GID: D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization
   mirror-E: none(waiver:regularized-diagonal-integral-before-operator-domain)
   anchors: []
   utility: none
   digest: Regularize the actual diagonal window correlation and bound its positive Gamma increment and every omitted endpoint strip. -/

import D5.S3.Weil.ZetaBridge.WeilWindowFourierConvolution
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds

/-!
The existing convolution, including its independent diagonal branch, is the
source. The subtraction below is its ACTUAL value at zero. Finite-window
integrability is proved before subtracting any integrals. The common exterior
subtraction and the constant part of CCM (4.4) cancel when comparing modes.
Thus the sign below concerns the increment of minus W_R relative to mode zero,
not positivity of the whole Weil form or diagonal dominance of its matrix.

Library comparisons: DiagonalSignNegativeIndex concerns inertia AFTER a
congruence; MultiscaleLoewnerConstraint differentiates a continuous resolvent
curve; EscapeCount uses a fixed-point-free self-application twist. None supplies
this endpoint estimate. The old Fourier convolution and pinned real exponential,
trigonometric and integration theorems are reused. There is no new operator,
no claimed Loewner derivative on the integer Fourier lattice, and no RH premise.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
noncomputable section

namespace D5.S3.Weil.ZetaBridge.WeilDiagonalGammaRegularization

open MeasureTheory Set
open D5.S3.Weil.ZetaBridge.WeilWindowFourierConvolution

/-- The regularized integrand uses the original diagonal convolution and
subtracts its own value at the origin, before dividing by the singular kernel.
The totalized value at t=0 is not asserted to be its limiting value. -/
def diagonalGammaIntegrand (L : ℝ) (n : ℤ) (t : ℝ) : ℝ :=
  (Real.exp (t / 2) *
      (windowCorrelation L n n t + windowCorrelation L n n (-t)).re -
    (windowCorrelation L n n 0 + windowCorrelation L n n (-0)).re) /
    (Real.exp t - Real.exp (-t))

private def den (t : ℝ) : ℝ := Real.exp t - Real.exp (-t)
private def raw (L w t : ℝ) : ℝ :=
  (2 * Real.exp (t / 2) * (1 - t / L) * Real.cos (w * t) - 2) / den t
private def energy (L w t : ℝ) : ℝ :=
  2 * (Real.exp (t / 2) / den t) * (1 - t / L) * (1 - Real.cos (w * t))
private def cap (L w : ℝ) : ℝ :=
  Real.exp (L / 2) * (1 + 2 / L + w ^ 2 * L)

private theorem denominator_bound {t : ℝ} (ht : 0 < t) :
    t ≤ den t ∧ 0 < den t := by
  have h1 := Real.add_one_le_exp t
  have h2 : Real.exp (-t) ≤ 1 := Real.exp_le_one_iff.mpr (by linarith)
  have h : t ≤ den t := by dsimp [den]; linarith
  exact ⟨h, ht.trans_le h⟩

private theorem exp_remainder {L t : ℝ} (ht : 0 ≤ t) (htL : t ≤ L) :
    |Real.exp (t / 2) - 1| ≤ t / 2 * Real.exp (L / 2) := by
  have hpos := (Real.exp_pos (t / 2)).le
  have hprod : Real.exp (t / 2) * Real.exp (-(t / 2)) = 1 := by
    rw [← Real.exp_add]; simp
  have h := mul_le_mul_of_nonneg_left (Real.add_one_le_exp (-(t / 2))) hpos
  have hone : 1 ≤ Real.exp (t / 2) := Real.one_le_exp_iff.mpr (by linarith)
  rw [abs_of_nonneg (sub_nonneg.mpr hone)]
  calc
    _ ≤ t / 2 * Real.exp (t / 2) := by nlinarith
    _ ≤ _ := mul_le_mul_of_nonneg_left
      (Real.exp_le_exp.mpr (by linarith)) (by positivity)

private theorem baseline_bound {L t : ℝ} (hL : 0 < L)
    (ht : 0 < t) (htL : t ≤ L) :
    |raw L 0 t| ≤ Real.exp (L / 2) * (1 + 2 / L) := by
  obtain ⟨hden, hd⟩ := denominator_bound ht
  have hexp := exp_remainder ht.le htL
  have he : Real.exp (t / 2) ≤ Real.exp (L / 2) :=
    Real.exp_le_exp.mpr (by linarith)
  have hnum : |2 * Real.exp (t / 2) * (1 - t / L) - 2| ≤
      Real.exp (L / 2) * (1 + 2 / L) * t := by
    calc
      _ = |2 * (Real.exp (t / 2) - 1) - 2 * Real.exp (t / 2) * (t / L)| := by congr 1; ring
      _ ≤ |2 * (Real.exp (t / 2) - 1)| + |2 * Real.exp (t / 2) * (t / L)| := abs_sub _ _
      _ = 2 * |Real.exp (t / 2) - 1| + 2 * Real.exp (t / 2) * (t / L) := by
        rw [abs_mul, abs_of_nonneg (by norm_num : (0 : ℝ) ≤ 2),
          abs_of_nonneg (by positivity : 0 ≤ 2 * Real.exp (t / 2) * (t / L))]
      _ ≤ 2 * (t / 2 * Real.exp (L / 2)) + 2 * Real.exp (L / 2) * (t / L) := by gcongr
      _ = _ := by ring
  have hcap : 0 ≤ Real.exp (L / 2) * (1 + 2 / L) := by positivity
  simpa only [raw, zero_mul, Real.cos_zero, mul_one, abs_div, abs_of_pos hd] using
    (div_le_iff₀ hd).mpr
      (hnum.trans (mul_le_mul_of_nonneg_left hden hcap))

private theorem energy_bound {L t : ℝ} (hL : 0 < L)
    (ht : 0 < t) (htL : t ≤ L) (w : ℝ) :
    0 ≤ energy L w t ∧
      energy L w t ≤ Real.exp (L / 2) * w ^ 2 * t * (1 - t / L) := by
  obtain ⟨hden, hd⟩ := denominator_bound ht
  have hwindow : 0 ≤ 1 - t / L := sub_nonneg.mpr ((div_le_one hL).mpr htL)
  have hc : 0 ≤ 1 - Real.cos (w * t) := sub_nonneg.mpr (Real.cos_le_one _)
  have hcos : 1 - Real.cos (w * t) ≤ (w * t) ^ 2 / 2 := by
    linarith [Real.one_sub_sq_div_two_le_cos (x := w * t)]
  have he : Real.exp (t / 2) ≤ Real.exp (L / 2) := Real.exp_le_exp.mpr (by linarith)
  refine ⟨by unfold energy; positivity, ?_⟩
  have hid : energy L w t =
      (2 * Real.exp (t / 2) * (1 - t / L) * (1 - Real.cos (w * t))) / den t := by
    unfold energy; ring
  rw [hid]
  apply (div_le_iff₀ hd).mpr
  calc
    _ ≤ 2 * Real.exp (L / 2) * (1 - t / L) * ((w * t) ^ 2 / 2) := by gcongr
    _ = (Real.exp (L / 2) * w ^ 2 * t * (1 - t / L)) * t := by ring
    _ ≤ _ := mul_le_mul_of_nonneg_left hden (by positivity)

private theorem raw_sub (L w t : ℝ) : raw L 0 t - raw L w t = energy L w t := by
  simp only [raw, energy, zero_mul, Real.cos_zero, mul_one, div_eq_mul_inv]
  ring

private theorem raw_bound {L t : ℝ} (hL : 0 < L)
    (ht : 0 < t) (htL : t ≤ L) (w : ℝ) : |raw L w t| ≤ cap L w := by
  have hb := baseline_bound hL ht htL
  obtain ⟨hg0, hg⟩ := energy_bound hL ht htL w
  have hw1 : 1 - t / L ≤ 1 := by have : 0 ≤ t / L := by positivity; linarith
  have hg' : energy L w t ≤ Real.exp (L / 2) * w ^ 2 * L := by
    calc
      _ ≤ Real.exp (L / 2) * w ^ 2 * t * (1 - t / L) := hg
      _ ≤ Real.exp (L / 2) * w ^ 2 * L * 1 := by gcongr
      _ = _ := mul_one _
  have hraw : raw L w t = raw L 0 t - energy L w t := by linarith [raw_sub L w t]
  rw [hraw]
  calc
    _ ≤ |raw L 0 t| + |energy L w t| := abs_sub _ _
    _ ≤ Real.exp (L / 2) * (1 + 2 / L) + Real.exp (L / 2) * w ^ 2 * L := by
      rw [abs_of_nonneg hg0]; exact add_le_add hb hg'
    _ = cap L w := by unfold cap; ring

private theorem raw_integrable {L : ℝ} (hL : 0 < L) (w : ℝ) :
    IntegrableOn (raw L w) (Ioc 0 L) := by
  have hm : Measurable (raw L w) := by unfold raw den; fun_prop
  have hc : Integrable (fun _ : ℝ => cap L w) (volume.restrict (Ioc 0 L)) := integrable_const _
  apply hc.mono' hm.aestronglyMeasurable
  filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
  simpa only [Real.norm_eq_abs] using raw_bound hL ht.1 ht.2 w

/-- The actual diagonal trace at zero is two. The regularized expression
reduces to the triangular cosine formula; this is a companion of the existing
convolution theorem and fixes the subtraction before any singular integration. -/
theorem diagonal_gamma_origin_subtraction {L : ℝ} (hL : 0 < L) (n : ℤ) :
    (windowCorrelation L n n 0 + windowCorrelation L n n (-0)).re = 2 ∧
    ∀ t ∈ Icc (0 : ℝ) L, diagonalGammaIntegrand L n t =
      (2 * Real.exp (t / 2) * (1 - t / L) *
        Real.cos ((2 * Real.pi * (n : ℝ) / L) * t) - 2) /
        (Real.exp t - Real.exp (-t)) := by
  have hzero : (windowCorrelation L n n 0 + windowCorrelation L n n (-0)).re = 2 := by
    rw [window_even_correlation_formula hL n n (le_refl 0) hL.le, if_pos rfl]
    simp
  refine ⟨hzero, ?_⟩
  intro t ht
  unfold diagonalGammaIntegrand
  rw [hzero, window_even_correlation_formula hL n n ht.1 ht.2, if_pos rfl,
    Complex.ofReal_re]
  have harg : 2 * Real.pi * (n : ℝ) * t / L = (2 * Real.pi * (n : ℝ) / L) * t := by ring
  rw [harg]
  ring

/-- Every actual diagonal has an integrable origin-subtracted kernel on the
entire finite window and an explicit bound, with no deleted endpoint interval. -/
theorem diagonal_gamma_integrable {L : ℝ} (hL : 0 < L) (n : ℤ) :
    IntegrableOn (diagonalGammaIntegrand L n) (Ioc 0 L) ∧
    ∀ t ∈ Ioc (0 : ℝ) L, |diagonalGammaIntegrand L n t| ≤
      Real.exp (L / 2) * (1 + 2 / L + (2 * Real.pi * (n : ℝ) / L) ^ 2 * L) := by
  have heq := (diagonal_gamma_origin_subtraction hL n).2
  refine ⟨?_, ?_⟩
  · apply (raw_integrable hL (2 * Real.pi * (n : ℝ) / L)).congr
    filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
    exact (heq t ⟨ht.1.le, ht.2⟩).symm
  · intro t ht
    rw [heq t ⟨ht.1.le, ht.2⟩]
    exact raw_bound hL ht.1 ht.2 _

private theorem energy_integral_bound {L : ℝ} (hL : 0 < L) (w : ℝ) :
    0 ≤ (∫ t : ℝ in Ioc 0 L, energy L w t) ∧
    (∫ t : ℝ in Ioc 0 L, energy L w t) ≤ Real.exp (L / 2) * w ^ 2 * L ^ 2 / 6 := by
  have hg : IntegrableOn (energy L w) (Ioc 0 L) := by
    apply ((raw_integrable hL 0).sub (raw_integrable hL w)).congr
    exact Filter.Eventually.of_forall (raw_sub L w)
  have hp : IntegrableOn (fun t : ℝ => Real.exp (L / 2) * w ^ 2 * t * (1 - t / L))
      (Ioc 0 L) := ((by fun_prop : Continuous _).intervalIntegrable 0 L).1
  refine ⟨integral_nonneg_of_ae ?_, ?_⟩
  · filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
    exact (energy_bound hL ht.1 ht.2 w).1
  · have hle := integral_mono_ae hg hp (by
      filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
      exact (energy_bound hL ht.1 ht.2 w).2)
    have hpoly : (∫ t : ℝ in Ioc 0 L,
        Real.exp (L / 2) * w ^ 2 * t * (1 - t / L)) =
        Real.exp (L / 2) * w ^ 2 * L ^ 2 / 6 := by
      rw [← intervalIntegral.integral_of_le hL.le]
      have hfun : (fun t : ℝ => Real.exp (L / 2) * w ^ 2 * t * (1 - t / L)) =
          (fun t => Real.exp (L / 2) * w ^ 2 * (t - t ^ 2 / L)) := by funext t; ring
      rw [hfun, intervalIntegral.integral_const_mul,
        intervalIntegral.integral_sub
          ((by fun_prop : Continuous (fun t : ℝ => t)).intervalIntegrable 0 L)
          ((by fun_prop : Continuous (fun t : ℝ => t ^ 2 / L)).intervalIntegrable 0 L),
        intervalIntegral.integral_div]
      simp only [integral_id, integral_pow, zero_pow (by norm_num : (2 : ℕ) ≠ 0),
        zero_pow (by norm_num : (3 : ℕ) ≠ 0), sub_zero]
      norm_num
      field_simp [hL.ne']
      <;> ring
    exact hle.trans_eq hpoly

/-- After legitimate regularization of each actual diagonal, subtracting the
zero-mode value cancels the common subtraction. The resulting increment of
minus W_R is a nonnegative finite energy with an explicit quadratic envelope.
This is not positivity of the full Weil form, a spectral gap, or an ordering
between two arbitrary nonzero frequencies. -/
theorem diagonal_gamma_relative_energy {L : ℝ} (hL : 0 < L) (n : ℤ) :
    let d := (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L 0 t) -
      (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L n t)
    d = ∫ t : ℝ in Ioc 0 L,
      2 * (Real.exp (t / 2) / (Real.exp t - Real.exp (-t))) * (1 - t / L) *
        (1 - Real.cos ((2 * Real.pi * (n : ℝ) / L) * t)) ∧
      0 ≤ d ∧ d ≤ Real.exp (L / 2) * (2 * Real.pi * (n : ℝ) / L) ^ 2 * L ^ 2 / 6 := by
  dsimp only
  have heq : (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L 0 t) -
      (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L n t) =
      ∫ t : ℝ in Ioc 0 L, energy L (2 * Real.pi * (n : ℝ) / L) t := by
    rw [← integral_sub (diagonal_gamma_integrable hL 0).1 (diagonal_gamma_integrable hL n).1]
    apply integral_congr_ae
    filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
    rw [(diagonal_gamma_origin_subtraction hL 0).2 t ⟨ht.1.le, ht.2⟩,
      (diagonal_gamma_origin_subtraction hL n).2 t ⟨ht.1.le, ht.2⟩]
    simpa only [Int.cast_zero, mul_zero, zero_div] using
      raw_sub L (2 * Real.pi * (n : ℝ) / L) t
  rw [heq]
  exact ⟨rfl, energy_integral_bound hL _⟩

/-- The endpoint may be treated by a certified strip budget rather than
silently removed. delta=0 is allowed; no work-precision label supplies a bound.
The cap is intentionally conservative and retains its dependence on L and n. -/
theorem diagonal_gamma_endpoint_error {L : ℝ} (hL : 0 < L) (n : ℤ)
    {delta : ℝ} (hd0 : 0 ≤ delta) (hdL : delta ≤ L) :
    |∫ t : ℝ in Ioc 0 delta, diagonalGammaIntegrand L n t| ≤
      delta * (Real.exp (L / 2) * (1 + 2 / L + (2 * Real.pi * (n : ℝ) / L) ^ 2 * L)) := by
  let C := Real.exp (L / 2) * (1 + 2 / L + (2 * Real.pi * (n : ℝ) / L) ^ 2 * L)
  have hi := (diagonal_gamma_integrable hL n).1.mono_set (Ioc_subset_Ioc le_rfl hdL)
  have hb : ∀ᵐ t ∂volume.restrict (Ioc 0 delta), |diagonalGammaIntegrand L n t| ≤ C := by
    filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
    exact (diagonal_gamma_integrable hL n).2 t ⟨ht.1, ht.2.trans hdL⟩
  have hu := integral_mono_ae hi (integrable_const C) (hb.mono fun _ h => (abs_le.mp h).2)
  have hl := integral_mono_ae (integrable_const (-C)) hi (hb.mono fun _ h => (abs_le.mp h).1)
  have hc (r : ℝ) : (∫ _t : ℝ in Ioc 0 delta, r) = delta * r := by
    rw [← intervalIntegral.integral_of_le hd0]
    simp
  rw [hc C] at hu
  rw [hc (-C)] at hl
  exact abs_le.mpr ⟨by linarith, hu⟩

#print axioms diagonal_gamma_integrable
#print axioms diagonal_gamma_relative_energy
#print axioms diagonal_gamma_endpoint_error

end D5.S3.Weil.ZetaBridge.WeilDiagonalGammaRegularization
