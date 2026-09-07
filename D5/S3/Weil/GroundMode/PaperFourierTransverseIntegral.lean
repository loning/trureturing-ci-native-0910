/- GID: D5/S3/Weil/GroundMode/PaperFourierTransverseIntegral
   generality: G
   mirror-B: none(waiver:formal-unit-only)
   mirror-E: none(waiver:analytic-proof-source)
   anchors: []
   digest: Identify the existing paper Fourier transform of supported even real L1 functions with its actual transverse integral, including the real axis. -/

import D5.S3.Weil.ZetaCore.PaperFT
import D5.S3.Weil.GroundMode.PaperFourierTransverseKernel
import Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap

/-!
# Actual paper Fourier evaluation, without a supplied kernel identity

The transform in every statement is the pre-existing Zeta23.paperFT, with
sign +i and no 2*pi. Evenness is used to identify it with a cosine integral.
The functions need only be integrable and supported in a finite interval;
no smoothness or vanishing endpoint trace is required.

The main identity has no division by the ordinate. In particular its y=0
case and the continuous kernel there belong to the same statement. This
removes the abstract hidentity input in the earlier transverse transport.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
namespace D5.S3.Weil.GroundMode.PaperFourierTransverseIntegral

open MeasureTheory Complex
open D5.S3.Weil.GroundMode.PaperFourierTransverseKernel

private theorem paper_twist_integrable {f : ℝ → ℂ} {a : ℝ}
    (hf : Integrable f) (hs : ∀ t, f t ≠ 0 → |t| ≤ a) (z : ℂ) :
    Integrable (fun t : ℝ => f t * Complex.exp (Complex.I * z * t)) := by
  refine (hf.norm.const_mul (Real.exp (|z.im| * a))).mono' ?_ ?_
  · exact hf.aestronglyMeasurable.mul (by fun_prop)
  · filter_upwards with t
    rw [norm_mul]
    by_cases ht : f t = 0
    · simp [ht]
    · calc
        _ ≤ ‖f t‖ * Real.exp (|z.im| * a) :=
          mul_le_mul_of_nonneg_left (Zeta23.norm_cexp_I_mul_le (hs t ht))
            (norm_nonneg _)
        _ = _ := mul_comm _ _

private theorem weighted_cosine_formula (f : ℝ → ℂ) (z : ℂ) (t : ℝ) :
    f t * Complex.cos (z * t) = (2 : ℂ)⁻¹ *
      (f t * Complex.exp (Complex.I * z * t) +
        f t * Complex.exp (Complex.I * (-z) * t)) := by
  rw [Complex.cos]
  rw [show (z * (t : ℂ)) * Complex.I = Complex.I * z * t by ring,
    show -(z * (t : ℂ)) * Complex.I = Complex.I * (-z) * t by ring]
  ring

private theorem cosine_integrable {f : ℝ → ℂ} {a : ℝ}
    (hf : Integrable f) (hs : ∀ t, f t ≠ 0 → |t| ≤ a) (z : ℂ) :
    Integrable (fun t : ℝ => f t * Complex.cos (z * t)) := by
  refine (((paper_twist_integrable hf hs z).add
    (paper_twist_integrable hf hs (-z))).const_mul ((2 : ℂ)⁻¹)).congr ?_
  filter_upwards with t
  exact (weighted_cosine_formula f z t).symm

/-- Evenness preserves the actual paper transform under frequency reflection.
The proof uses the measure-preserving real reflection, without smoothness. -/
theorem paperFT_neg_of_even (f : ℝ → ℂ) (heven : Function.Even f) (z : ℂ) :
    Zeta23.paperFT f (-z) = Zeta23.paperFT f z := by
  unfold Zeta23.paperFT
  calc
    _ = ∫ t : ℝ, f (-t) * Complex.exp (Complex.I * z * (-t)) := by
      apply integral_congr_ae
      filter_upwards with t
      rw [heven t]
      congr 2
      push_cast
      ring
    _ = _ := integral_neg_eq_self _

/-- The cosine integral is proved equal to the existing transform. It is
not installed as a parallel Fourier definition or taken as an input. -/
theorem paperFT_eq_cosine_integral {f : ℝ → ℂ} {a : ℝ}
    (hf : Integrable f) (hs : ∀ t, f t ≠ 0 → |t| ≤ a)
    (heven : Function.Even f) (z : ℂ) :
    Zeta23.paperFT f z = ∫ t : ℝ, f t * Complex.cos (z * t) := by
  symm
  calc
    _ = ∫ t : ℝ, (2 : ℂ)⁻¹ *
        (f t * Complex.exp (Complex.I * z * t) +
          f t * Complex.exp (Complex.I * (-z) * t)) := by
      apply integral_congr_ae
      filter_upwards with t
      exact weighted_cosine_formula f z t
    _ = (2 : ℂ)⁻¹ * (Zeta23.paperFT f z + Zeta23.paperFT f (-z)) := by
      rw [Zeta23.integral_const_mul_C,
        integral_add (paper_twist_integrable hf hs z) (paper_twist_integrable hf hs (-z))]
      rfl
    _ = _ := by rw [paperFT_neg_of_even f heven z]; ring

private theorem im_cos_mul_real (x y t : ℝ) :
    (Complex.cos (Complex.mk x y * t)).im =
      -Real.sin (x * t) * Real.sinh (y * t) := by
  simp [Complex.cos, div_eq_mul_inv, Complex.mul_im, Complex.mul_re,
    Complex.exp_im, Real.sinh_eq]
  <;> ring

private theorem complex_lift_integrable {f : ℝ → ℝ} (hf : Integrable f) :
    Integrable (fun t : ℝ => (f t : ℂ)) := by
  exact Complex.ofRealLI.toContinuousLinearMap.integrable_comp hf

private theorem complex_lift_support {f : ℝ → ℝ} {a : ℝ}
    (hs : ∀ t, f t ≠ 0 → |t| ≤ a) :
    ∀ t, (f t : ℂ) ≠ 0 → |t| ≤ a := by
  intro t ht
  exact hs t (by exact_mod_cast ht)

/-- The actual transverse integral exists for every supported L1 function.
This includes nonsmooth functions and nonzero endpoint traces. -/
theorem integrable_mul_transverseKernel {f : ℝ → ℝ} {a : ℝ}
    (hf : Integrable f) (ha : 0 ≤ a) (hs : ∀ t, f t ≠ 0 → |t| ≤ a)
    (x y : ℝ) : Integrable (fun t => f t * transverseKernel x y t) := by
  have hcont : Continuous (transverseKernel x y) :=
    continuous_transverseKernel.comp
      (continuous_const.prodMk (continuous_const.prodMk continuous_id))
  refine (hf.norm.const_mul (a * Real.cosh (a * |y|))).mono' ?_ ?_
  · exact hf.aestronglyMeasurable.mul hcont.aestronglyMeasurable
  · filter_upwards with t
    rw [norm_mul, Real.norm_eq_abs (transverseKernel x y t)]
    by_cases ht : f t = 0
    · simp [ht]
    · have hK := abs_transverseKernel_le x y t a |y| ha (abs_nonneg y) (hs t ht) le_rfl
      have hK' := hK.trans
        (mul_le_mul_of_nonneg_right (hs t ht) (Real.cosh_pos _).le)
      calc
        _ ≤ ‖f t‖ * (a * Real.cosh (a * |y|)) :=
          mul_le_mul_of_nonneg_left hK' (norm_nonneg _)
        _ = _ := mul_comm _ _

/-- The imaginary part of the EXISTING Fourier transform is exactly the
ordinate times the explicit desingularized kernel integral. The statement
includes y=0 and uses the same pointwise support and evenness as the input. -/
theorem paperFT_im_eq_ordinate_mul_integral {f : ℝ → ℝ} {a : ℝ}
    (hf : Integrable f) (hs : ∀ t, f t ≠ 0 → |t| ≤ a)
    (heven : Function.Even f) (x y : ℝ) :
    (Zeta23.paperFT (fun t => (f t : ℂ)) (Complex.mk x y)).im =
      y * ∫ t : ℝ, f t * transverseKernel x y t := by
  have hfC := complex_lift_integrable hf
  have hsC := complex_lift_support hs
  have hEvenC : Function.Even (fun t => (f t : ℂ)) := fun t => by rw [heven t]
  rw [paperFT_eq_cosine_integral hfC hsC hEvenC]
  have him : (∫ t : ℝ, (f t : ℂ) * Complex.cos (Complex.mk x y * t)).im =
      ∫ t : ℝ, ((f t : ℂ) * Complex.cos (Complex.mk x y * t)).im := by
    simpa only [Complex.imCLM_apply] using
      (Complex.imCLM.integral_comp_comm (cosine_integrable hfC hsC (Complex.mk x y))).symm
  rw [him]
  calc
    _ = ∫ t : ℝ, y * (f t * transverseKernel x y t) := by
      apply integral_congr_ae
      filter_upwards with t
      change ((f t : ℂ) * Complex.cos (Complex.mk x y * t)).im = _
      rw [Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im, zero_mul, add_zero,
        im_cos_mul_real]
      rw [← ordinate_mul_transverseKernel]
      ring
    _ = _ := integral_const_mul _ _

/-- Away from the axis, division agrees with the same integral. The quotient
is not used to define the kernel, so its limiting value was never discarded. -/
theorem paperFT_divided_im_eq_integral {f : ℝ → ℝ} {a : ℝ}
    (hf : Integrable f) (hs : ∀ t, f t ≠ 0 → |t| ≤ a)
    (heven : Function.Even f) (x y : ℝ) (hy : y ≠ 0) :
    (Zeta23.paperFT (fun t => (f t : ℂ)) (Complex.mk x y)).im / y =
      ∫ t : ℝ, f t * transverseKernel x y t := by
  rw [paperFT_im_eq_ordinate_mul_integral hf hs heven]
  exact mul_div_cancel_left₀ _ hy

#print axioms paperFT_eq_cosine_integral
#print axioms integrable_mul_transverseKernel
#print axioms paperFT_im_eq_ordinate_mul_integral
#print axioms paperFT_divided_im_eq_integral

end D5.S3.Weil.GroundMode.PaperFourierTransverseIntegral
end
