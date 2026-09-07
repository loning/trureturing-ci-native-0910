/- GID: D5/S3/Weil/GroundMode/PaperFourierTransverseKernel
   generality: G
   mirror-B: none(waiver:formal-unit-only)
   mirror-E: none(waiver:analytic-proof-source)
   anchors: []
   digest: Construct the actual desingularized cosine Fourier kernel and prove its all-ordinate identity, continuity and explicit support-dependent bound. -/

import Mathlib.Analysis.Calculus.DSlope
import Mathlib.Analysis.SpecialFunctions.Trigonometric.DerivHyp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

/-!
# The actual transverse Fourier kernel

For a real even integrable function, the paper Fourier transform is its
cosine transform. Its imaginary part is y times the integral against the
kernel below. We use Mathlib's existing derivative-completed slope, rather
than inventing a separate quotient convention for sinh(v)/v.

At y=0 the kernel is -t*sin(x*t). The uniform bound does not divide by y,
so it remains valid at the real axis. These analytic facts discharge two
paper inputs of the earlier RealTransverseReadout certificate. They do not
supply the arithmetic Weil domain or any spectral enclosure.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
namespace D5.S3.Weil.GroundMode.PaperFourierTransverseKernel

open Set
open scoped Topology

private theorem continuous_sinh_dslope : Continuous (dslope Real.sinh 0) := by
  rw [continuous_iff_continuousAt]
  intro v
  by_cases hv : v = 0
  · subst v
    exact continuousAt_dslope_same.mpr Real.differentiableAt_sinh
  · exact (continuousAt_dslope_of_ne hv).mpr Real.continuous_sinh.continuousAt

private theorem abs_sinh_le_cosh_mul_abs (v : ℝ) :
    |Real.sinh v| ≤ Real.cosh v * |v| := by
  have hm := norm_image_sub_le_of_norm_deriv_le_segment'
    (f := Real.sinh) (f' := Real.cosh) (a := (0 : ℝ)) (b := |v|)
    (C := Real.cosh v)
    (fun u _ => (Real.hasDerivAt_sinh u).hasDerivWithinAt)
    (fun u hu => by
      rw [Real.norm_eq_abs, abs_of_pos (Real.cosh_pos u)]
      exact Real.cosh_le_cosh.mpr (by rw [abs_of_nonneg hu.1]; exact hu.2.le))
    |v| (right_mem_Icc.mpr (abs_nonneg v))
  simpa only [Real.sinh_zero, sub_zero, Real.norm_eq_abs,
    Real.abs_sinh, abs_abs] using hm

private theorem abs_sinh_dslope_le (v : ℝ) :
    |dslope Real.sinh 0 v| ≤ Real.cosh v := by
  by_cases hv : v = 0
  · subst v
    simp [Real.deriv_sinh]
  · rw [dslope_of_ne Real.sinh hv, slope_def_field, Real.sinh_zero,
      sub_zero, sub_zero, abs_div]
    exact (div_le_iff₀ (abs_pos.mpr hv)).mpr (abs_sinh_le_cosh_mul_abs v)

private theorem sinh_dslope_neg (v : ℝ) :
    dslope Real.sinh 0 (-v) = dslope Real.sinh 0 v := by
  by_cases hv : v = 0
  · simp [hv]
  · rw [dslope_of_ne Real.sinh (neg_ne_zero.mpr hv), dslope_of_ne Real.sinh hv,
      slope_def_field, slope_def_field]
    simp [Real.sinh_neg]

/-- The continuous transverse cosine-transform kernel. The factor at the
origin uses the derivative of sinh, exactly as specified by Mathlib dslope. -/
def transverseKernel (x y t : ℝ) : ℝ :=
  -(t * Real.sin (x * t)) * dslope Real.sinh 0 (y * t)

/-- The actual kernel has a finite value on the real axis. -/
theorem transverseKernel_zero_ordinate (x t : ℝ) :
    transverseKernel x 0 t = -t * Real.sin (x * t) := by
  simp [transverseKernel, Real.deriv_sinh, neg_mul]

/-- Multiplication by the ordinate recovers the imaginary cosine kernel.
This identity includes y=0; no hidden nonzero-ordinate assumption is used. -/
theorem ordinate_mul_transverseKernel (x y t : ℝ) :
    y * transverseKernel x y t = -Real.sin (x * t) * Real.sinh (y * t) := by
  have hs : (y * t) * dslope Real.sinh 0 (y * t) = Real.sinh (y * t) := by
    simpa only [sub_zero, smul_eq_mul, Real.sinh_zero] using
      (sub_smul_dslope Real.sinh (0 : ℝ) (y * t))
  dsimp [transverseKernel]
  calc
    _ = -Real.sin (x * t) * ((y * t) * dslope Real.sinh 0 (y * t)) := by ring
    _ = _ := by rw [hs]

/-- Agreement with the ordinary quotient at every nonzero ordinate. -/
theorem transverseKernel_eq_div (x y t : ℝ) (hy : y ≠ 0) :
    transverseKernel x y t = -Real.sin (x * t) * Real.sinh (y * t) / y := by
  exact (eq_div_iff hy).mpr (by
    simpa only [mul_comm] using ordinate_mul_transverseKernel x y t)

/-- Joint continuity also covers the previously singular y=0 slice. -/
theorem continuous_transverseKernel :
    Continuous (fun p : ℝ × ℝ × ℝ => transverseKernel p.1 p.2.1 p.2.2) := by
  unfold transverseKernel
  exact ((continuous_snd.snd.mul
    (Real.continuous_sin.comp (continuous_fst.mul continuous_snd.snd))).neg).mul
      (continuous_sinh_dslope.comp (continuous_snd.fst.mul continuous_snd.snd))

/-- Reflecting the imaginary coordinate preserves the desingularized kernel. -/
theorem transverseKernel_neg_ordinate (x y t : ℝ) :
    transverseKernel x (-y) t = transverseKernel x y t := by
  unfold transverseKernel
  rw [neg_mul, sinh_dslope_neg]

/-- A uniform pointwise bound valid on the entire support and ordinate band.
The right side retains |t|, allowing integration of the exact second moment. -/
theorem abs_transverseKernel_le (x y t a b : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (ht : |t| ≤ a) (hy : |y| ≤ b) :
    |transverseKernel x y t| ≤ |t| * Real.cosh (a * b) := by
  have hyt : |y * t| ≤ |a * b| := by
    rw [abs_mul, abs_of_nonneg (mul_nonneg ha hb)]
    calc
      _ ≤ b * a := mul_le_mul hy ht (abs_nonneg t) hb
      _ = a * b := mul_comm _ _
  have hd : |dslope Real.sinh 0 (y * t)| ≤ Real.cosh (a * b) :=
    (abs_sinh_dslope_le (y * t)).trans (Real.cosh_le_cosh.mpr hyt)
  unfold transverseKernel
  rw [abs_mul, abs_neg, abs_mul]
  calc
    _ ≤ (|t| * 1) * Real.cosh (a * b) :=
      mul_le_mul
        (mul_le_mul_of_nonneg_left (Real.abs_sin_le_one (x * t)) (abs_nonneg t))
        hd (abs_nonneg _) (by positivity)
    _ = _ := by ring

#print axioms transverseKernel_zero_ordinate
#print axioms ordinate_mul_transverseKernel
#print axioms continuous_transverseKernel
#print axioms abs_transverseKernel_le

end D5.S3.Weil.GroundMode.PaperFourierTransverseKernel
end
