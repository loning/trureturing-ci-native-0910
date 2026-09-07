/- GID: D5/S3/Weil/GroundMode/PaperFourierTransverseBound
   generality: G
   mirror-B: none(waiver:formal-unit-only)
   mirror-E: none(waiver:analytic-proof-source)
   anchors: []
   digest: Prove the full L2 transverse Fourier error estimate from the actual kernel and its exact support moment, and apply it to real nonvanishing certificates. -/

import D5.S3.Weil.GroundMode.PaperFourierTransverseIntegral
import Mathlib.MeasureTheory.Function.L2Space
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.Complex.ExponentialBounds

/-!
# Full-space transverse Fourier control

The support moment is integrated exactly. Cauchy-Schwarz is applied to
actual Mathlib L2 elements; no finite Fourier-coordinate truncation occurs.
The final theorem refers to Zeta23.paperFT, and derives the kernel identity
and norm budget instead of accepting them as separate hypotheses.

Only the candidate's scalar transverse floor, the actual error's L2 budget,
and support/evenness remain inputs. Neither a numerical JSON nor this theorem
asserts the underlying Weil spectral certificate or an unbounded-scale limit.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
namespace D5.S3.Weil.GroundMode.PaperFourierTransverseBound

open MeasureTheory Set
open scoped InnerProductSpace
open D5.S3.Weil.GroundMode.PaperFourierTransverseKernel
open D5.S3.Weil.GroundMode.PaperFourierTransverseIntegral

private theorem continuous_kernel (x y : ℝ) : Continuous (transverseKernel x y) :=
  continuous_transverseKernel.comp
    (continuous_const.prodMk (continuous_const.prodMk continuous_id))

private theorem continuous_indicator_memLp_two (g : ℝ → ℝ) (hg : Continuous g) (a : ℝ) :
    MemLp ((Icc (-a) a).indicator g) 2 volume := by
  classical
  have hm : AEStronglyMeasurable ((Icc (-a) a).indicator g) volume :=
    hg.aestronglyMeasurable.indicator measurableSet_Icc
  apply (memLp_two_iff_integrable_sq hm).mpr
  have hi : Integrable ((Icc (-a) a).indicator (fun t => (g t) ^ 2)) :=
    (integrable_indicator_iff measurableSet_Icc).mpr
      ((hg.pow 2).continuousOn.integrableOn_compact isCompact_Icc)
  convert hi using 1
  ext t
  by_cases ht : t ∈ Icc (-a) a <;> simp [ht]

private theorem l2_inner_integral {f g : ℝ → ℝ}
    (hf : MemLp f 2 volume) (hg : MemLp g 2 volume) :
    ⟪hf.toLp f, hg.toLp g⟫_ℝ = ∫ t, f t * g t := by
  rw [MeasureTheory.L2.inner_def]
  apply integral_congr_ae
  filter_upwards [hf.coeFn_toLp, hg.coeFn_toLp] with t hft hgt
  simp [hft, hgt, RCLike.inner_apply, mul_comm]

private theorem l2_norm_square_integral {f : ℝ → ℝ} (hf : MemLp f 2 volume) :
    ‖hf.toLp f‖ ^ 2 = ∫ t, (f t) ^ 2 := by
  rw [← real_inner_self_eq_norm_sq, l2_inner_integral]
  simp only [pow_two]

private theorem cauchy_square_integral {f g : ℝ → ℝ}
    (hf : MemLp f 2 volume) (hg : MemLp g 2 volume) :
    |∫ t, f t * g t| ^ 2 ≤ (∫ t, (f t) ^ 2) * ∫ t, (g t) ^ 2 := by
  have h := pow_le_pow_left₀ (abs_nonneg _)
    (abs_real_inner_le_norm (hf.toLp f) (hg.toLp g)) 2
  simpa only [l2_inner_integral hf hg, mul_pow,
    l2_norm_square_integral hf, l2_norm_square_integral hg] using h

private theorem supported_memLp_integrable {f : ℝ → ℝ}
    (hf : MemLp f 2 volume) (a : ℝ) (hs : ∀ t, f t ≠ 0 → |t| ≤ a) :
    Integrable f := by
  classical
  let g : ℝ → ℝ := (Icc (-a) a).indicator (fun _ => (1 : ℝ))
  have hg : MemLp g 2 volume := continuous_indicator_memLp_two _ continuous_const a
  refine (MeasureTheory.L2.integrable_inner (𝕜 := ℝ) (hg.toLp g) (hf.toLp f)).congr ?_
  filter_upwards [hg.coeFn_toLp, hf.coeFn_toLp] with t hgt hft
  by_cases ht : t ∈ Icc (-a) a
  · simp [hgt, hft, g, ht, RCLike.inner_apply]
  · have hz : f t = 0 := by
      by_contra hn
      exact ht (abs_le.mp (hs t hn))
    simp [hgt, hft, hz, RCLike.inner_apply]

/-- Integrate the support moment exactly; retaining |t| in the pointwise
bound gives 2*a^3/3 instead of a supremum-times-length replacement. -/
theorem transverseKernel_square_integral_le (x y a b : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hy : |y| ≤ b) :
    (∫ t in Icc (-a) a, (transverseKernel x y t) ^ 2) ≤
      Real.cosh (a * b) ^ 2 * (2 * a ^ 3 / 3) := by
  have hleft : IntegrableOn (fun t => (transverseKernel x y t) ^ 2) (Icc (-a) a) :=
    ((continuous_kernel x y).pow 2).continuousOn.integrableOn_compact isCompact_Icc
  have hright : IntegrableOn (fun t : ℝ => Real.cosh (a * b) ^ 2 * t ^ 2)
      (Icc (-a) a) :=
    (continuous_const.mul (continuous_id.pow 2)).continuousOn.integrableOn_compact isCompact_Icc
  have hmoment : (∫ t in Icc (-a) a, t ^ 2) = 2 * a ^ 3 / 3 := by
    rw [integral_Icc_eq_integral_Ioc,
      ← intervalIntegral.integral_of_le (by linarith : -a ≤ a), intervalIntegral.integral_pow]
    norm_num
    <;> ring
  calc
    _ ≤ ∫ t in Icc (-a) a, Real.cosh (a * b) ^ 2 * t ^ 2 := by
      apply integral_mono_ae hleft hright
      filter_upwards [ae_restrict_mem measurableSet_Icc] with t ht
      have h := pow_le_pow_left₀ (abs_nonneg _)
        (abs_transverseKernel_le x y t a b ha hb (abs_le.mpr ht) hy) 2
      simpa only [sq_abs, mul_pow, mul_comm] using h
    _ = Real.cosh (a * b) ^ 2 * ∫ t in Icc (-a) a, t ^ 2 := integral_const_mul _ _
    _ = _ := by rw [hmoment]

/-- The actual supported L2 error has a uniform transverse integral bound.
The error is an arbitrary square-integrable function on the full real line,
not a vector in the finite candidate-coordinate space. -/
theorem transverse_integral_square_le {f : ℝ → ℝ} (hf : MemLp f 2 volume)
    (x y a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (hy : |y| ≤ b)
    (hs : ∀ t, f t ≠ 0 → |t| ≤ a) :
    |∫ t, f t * transverseKernel x y t| ^ 2 ≤
      (∫ t, (f t) ^ 2) * (Real.cosh (a * b) ^ 2 * (2 * a ^ 3 / 3)) := by
  classical
  let g : ℝ → ℝ := (Icc (-a) a).indicator (transverseKernel x y)
  have hg : MemLp g 2 volume := continuous_indicator_memLp_two _ (continuous_kernel x y) a
  have hfg : (∫ t, f t * g t) = ∫ t, f t * transverseKernel x y t := by
    apply integral_congr_ae
    filter_upwards with t
    by_cases ht : t ∈ Icc (-a) a
    · simp [g, ht]
    · have hz : f t = 0 := by
        by_contra hn
        exact ht (abs_le.mp (hs t hn))
      simp [hz]
  have hg2 : (∫ t, (g t) ^ 2) = ∫ t in Icc (-a) a, (transverseKernel x y t) ^ 2 := by
    rw [← integral_indicator measurableSet_Icc]
    apply integral_congr_ae
    filter_upwards with t
    by_cases ht : t ∈ Icc (-a) a <;> simp [g, ht]
  have hc := cauchy_square_integral hf hg
  rw [hfg, hg2] at hc
  exact hc.trans (mul_le_mul_of_nonneg_left
    (transverseKernel_square_integral_le x y a b ha hb hy)
    (integral_nonneg fun t => sq_nonneg (f t)))

/-- A scalar error radius yields the sharp support-moment norm constant.
All square roots are justified by the proved nonnegative support moment. -/
theorem abs_transverse_integral_le {f : ℝ → ℝ} (hf : MemLp f 2 volume)
    (x y a b radius : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (hy : |y| ≤ b)
    (hr : 0 ≤ radius) (herr : (∫ t, (f t) ^ 2) ≤ radius ^ 2)
    (hs : ∀ t, f t ≠ 0 → |t| ≤ a) :
    |∫ t, f t * transverseKernel x y t| ≤
      radius * (Real.cosh (a * b) * Real.sqrt (2 * a ^ 3 / 3)) := by
  have hmoment : 0 ≤ 2 * a ^ 3 / 3 := by positivity
  have hsq := Real.sq_sqrt hmoment
  have h := (transverse_integral_square_le hf x y a b ha hb hy hs).trans
    (mul_le_mul_of_nonneg_right herr (by positivity))
  have hpos : 0 ≤ radius * (Real.cosh (a * b) * Real.sqrt (2 * a ^ 3 / 3)) := by positivity
  have heq : radius ^ 2 * (Real.cosh (a * b) ^ 2 * (2 * a ^ 3 / 3)) =
      (radius * (Real.cosh (a * b) * Real.sqrt (2 * a ^ 3 / 3))) ^ 2 := by
    rw [mul_pow, mul_pow, hsq]
  have hfinal := h.trans_eq heq
  exact (sq_le_sq₀ (abs_nonneg _) hpos).mp hfinal

/-- Actual paper-transform nonvanishing from a candidate transverse floor.
The Fourier/kernel identity and full-space norm are derived in this chain.
There is no supplied hidentity or hkernel oracle in the theorem. -/
theorem paperFT_ne_zero_of_transverse_margin
    {k w : ℝ → ℝ} (hk : Integrable k) (hw2 : MemLp w 2 volume) (x y a b radius floor : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hyb : |y| ≤ b) (hy : y ≠ 0)
    (hr : 0 ≤ radius) (herr : (∫ t, (w t) ^ 2) ≤ radius ^ 2)
    (hks : ∀ t, k t ≠ 0 → |t| ≤ a) (hws : ∀ t, w t ≠ 0 → |t| ≤ a)
    (hke : Function.Even k) (hwe : Function.Even w)
    (hfloor : floor ≤ ∫ t, k t * transverseKernel x y t)
    (hmargin : radius * (Real.cosh (a * b) * Real.sqrt (2 * a ^ 3 / 3)) < floor) :
    |y| * (floor - radius * (Real.cosh (a * b) * Real.sqrt (2 * a ^ 3 / 3))) ≤
        |(Zeta23.paperFT (fun t => ((k t + w t : ℝ) : ℂ)) (Complex.mk x y)).im| ∧
      Zeta23.paperFT (fun t => ((k t + w t : ℝ) : ℂ)) (Complex.mk x y) ≠ 0 := by
  have hw : Integrable w := supported_memLp_integrable hw2 a hws
  have hsumint : Integrable (fun t => k t + w t) := hk.add hw
  have hsumSupp : ∀ t, k t + w t ≠ 0 → |t| ≤ a := by
    intro t ht
    by_cases hkt : k t = 0
    · apply hws t
      simpa [hkt] using ht
    · exact hks t hkt
  have hsumEven : Function.Even (fun t => k t + w t) := by
    intro t
    rw [hke t, hwe t]
  have hid := paperFT_im_eq_ordinate_mul_integral hsumint hsumSupp hsumEven x y
  have hsplit : (∫ t, (k t + w t) * transverseKernel x y t) =
      (∫ t, k t * transverseKernel x y t) + ∫ t, w t * transverseKernel x y t := by
    simp_rw [add_mul]
    exact integral_add (integrable_mul_transverseKernel hk ha hks x y)
      (integrable_mul_transverseKernel hw ha hws x y)
  have hbnd := abs_transverse_integral_le hw2 x y a b radius ha hb hyb hr herr hws
  have hlo := (abs_le.mp hbnd).1
  have hpositive : 0 < ∫ t, (k t + w t) * transverseKernel x y t := by
    rw [hsplit]
    linarith
  have hlower : floor - radius * (Real.cosh (a * b) * Real.sqrt (2 * a ^ 3 / 3)) ≤
      ∫ t, (k t + w t) * transverseKernel x y t := by
    rw [hsplit]
    linarith
  constructor
  · rw [hid, abs_mul, abs_of_pos hpositive]
    exact mul_le_mul_of_nonneg_left hlower (abs_nonneg y)
  · intro hz
    have him := congrArg Complex.im hz
    rw [hid] at him
    exact (mul_ne_zero hy (ne_of_gt hpositive)) him

/-- The actual prime-three support constant used by the earlier interval
certificate follows from Mathlib's proved logarithm bound and exact exponential
algebra. No external decimal, interval JSON or spectral hypothesis is used. -/
theorem prime_three_transverse_norm_lt :
    Real.cosh (Real.log 3 / 4) *
      Real.sqrt (2 * (Real.log 3 / 2) ^ 3 / 3) < (173 : ℝ) / 500 := by
  let r : ℝ := Real.exp (Real.log 3 / 4)
  have hr : 0 < r := Real.exp_pos _
  have hr2 : r ^ 2 = Real.exp (Real.log 3 / 2) := by
    dsimp [r]
    rw [pow_two, ← Real.exp_add]
    congr 1
    ring
  have hr4 : r ^ 4 = 3 := by
    calc
      _ = (r ^ 2) ^ 2 := by ring
      _ = Real.exp (Real.log 3 / 2) ^ 2 := by rw [hr2]
      _ = Real.exp (Real.log 3) := by
        rw [pow_two, ← Real.exp_add]
        congr 1
        ring
      _ = 3 := Real.exp_log (by norm_num)
  have hrLower : (173 : ℝ) / 100 < r ^ 2 := by
    by_contra h
    have hs := pow_le_pow_left₀ (sq_nonneg r) (not_lt.mp h) 2
    have hid : (r ^ 2) ^ 2 = 3 := by calc
      _ = r ^ 4 := by ring
      _ = 3 := hr4
    rw [hid] at hs
    norm_num at hs
  have hc : Real.cosh (Real.log 3 / 4) ^ 2 = (1 : ℝ) / 2 + 1 / r ^ 2 := by
    rw [Real.cosh_eq, Real.exp_neg]
    change ((r + r⁻¹) / 2) ^ 2 = _
    field_simp [hr.ne']
    nlinarith [hr4]
  have hcBound : Real.cosh (Real.log 3 / 4) ^ 2 ≤ (1 : ℝ) / 2 + 100 / 173 := by
    rw [hc]
    have hi := div_le_div_of_nonneg_left (by norm_num : (0 : ℝ) ≤ 1)
      (by norm_num : (0 : ℝ) < 173 / 100) hrLower.le
    norm_num at hi
    linarith
  have ha : 0 ≤ Real.log 3 / 2 :=
    div_nonneg (Real.log_nonneg (by norm_num)) (by norm_num)
  have haBound : Real.log 3 / 2 ≤ (11 : ℝ) / 20 := by
    have hl := Real.log_three_lt_d9
    linarith
  have ha3 := pow_le_pow_left₀ ha haBound 3
  have hM : 0 ≤ 2 * (Real.log 3 / 2) ^ 3 / 3 := by positivity
  have hMBound : 2 * (Real.log 3 / 2) ^ 3 / 3 ≤ 2 * ((11 : ℝ) / 20) ^ 3 / 3 := by
    nlinarith
  have hK : (Real.cosh (Real.log 3 / 4) *
      Real.sqrt (2 * (Real.log 3 / 2) ^ 3 / 3)) ^ 2 ≤
      ((1 : ℝ) / 2 + 100 / 173) * (2 * ((11 : ℝ) / 20) ^ 3 / 3) := by
    rw [mul_pow, Real.sq_sqrt hM]
    exact mul_le_mul hcBound hMBound hM (by norm_num)
  have hstrict : ((1 : ℝ) / 2 + 100 / 173) * (2 * ((11 : ℝ) / 20) ^ 3 / 3) <
      ((173 : ℝ) / 500) ^ 2 := by norm_num
  exact (sq_lt_sq₀ (by positivity) (by norm_num)).mp (hK.trans_lt hstrict)

#print axioms transverseKernel_square_integral_le
#print axioms transverse_integral_square_le
#print axioms abs_transverse_integral_le
#print axioms paperFT_ne_zero_of_transverse_margin
#print axioms prime_three_transverse_norm_lt

end D5.S3.Weil.GroundMode.PaperFourierTransverseBound
end
