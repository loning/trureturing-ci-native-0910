/- GID: D5/S3/Analytic/Hardy/HardyCoefficientRealization
   generality: G
   mirror-B: D5/B/S3/Analytic/Hardy/HardyCoefficientRealization
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: [mathlib/module/Mathlib.Analysis.InnerProductSpace.l2Space, mathlib/module/Mathlib.Analysis.Analytic.OfScalars, mathlib/module/Mathlib.Analysis.Analytic.Uniqueness]
   utility: none
   digest: Full Hardy coefficients have injective analytic evaluation and the exact normalized radial norm. -/

import Mathlib.Analysis.InnerProductSpace.l2Space
import Mathlib.Analysis.Analytic.OfScalars
import Mathlib.Analysis.Analytic.Uniqueness
import Mathlib.Analysis.Analytic.ChangeOrigin
import Mathlib.Analysis.Fourier.AddCircle
import Mathlib.Analysis.Normed.Group.Tannery

/-!
The coefficient carrier is the full complex Hilbert space, without a finite-support restriction.
The power series is proved convergent in the open disk. Boundary evaluation on a finite Blaschke
model space is a separate construction; this module does not evaluate arbitrary Hardy vectors on
the unit circle. Normalized radial integrals recover the full coefficient Hilbert norm.

Ordered search found abstract model-space and matrix results in D5, and the lp and analytic-series
components used below in pinned Mathlib. The inspected upstream model-dimension candidate only
assumes the dimension equality and does not supply a Hardy realization.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
open scoped Topology

namespace D5.S3.Analytic.Hardy.HardyCoefficientRealization

/-- Full square-summable complex coefficients of the disk Hardy space. -/
abbrev H2 := lp (fun _ : Nat => Complex) 2

/-- Coefficient-series evaluation. Convergence is asserted only in the open disk. -/
def evaluate (f : H2) (z : Complex) : Complex := ∑' n, f n * z ^ n

/-- Every Hardy coefficient series converges at every point of the open disk. -/
theorem summable_evaluate (f : H2) {z : Complex} (hz : ‖z‖ < 1) :
    Summable (fun n : Nat => f n * z ^ n) := by
  apply Summable.of_norm_bounded
    ((summable_geometric_of_lt_one (norm_nonneg z) hz).mul_left ‖f‖)
  intro n
  rw [norm_mul, norm_pow]
  exact mul_le_mul_of_nonneg_right (lp.norm_apply_le_norm (by norm_num) f n)
    (pow_nonneg (norm_nonneg z) n)

/-- The convergent coefficient series has the specified analytic evaluation as its sum. -/
theorem evaluate_hasSum (f : H2) {z : Complex} (hz : ‖z‖ < 1) :
    HasSum (fun n : Nat => f n * z ^ n) (evaluate f z) :=
  (summable_evaluate f hz).hasSum

/-- A geometric majorant bounds evaluation on the complete coefficient carrier. -/
theorem norm_evaluate_le (f : H2) {z : Complex} (hz : ‖z‖ < 1) :
    ‖evaluate f z‖ ≤ ‖f‖ / (1 - ‖z‖) := by
  have hsum := (hasSum_geometric_of_lt_one (norm_nonneg z) hz).mul_left ‖f‖
  simpa [evaluate, div_eq_mul_inv] using
    (tsum_of_norm_bounded hsum fun n => by
      rw [norm_mul, norm_pow]
      exact mul_le_mul_of_nonneg_right (lp.norm_apply_le_norm (by norm_num) f n)
        (pow_nonneg (norm_nonneg z) n))

/-- Evaluation is a bounded complex-linear functional at each interior disk point. -/
def eval (z : Complex) (hz : ‖z‖ < 1) : H2 →L[Complex] Complex :=
  LinearMap.mkContinuous
    { toFun := fun f => evaluate f z
      map_add' := fun f g => by
        simp only [evaluate, lp.coeFn_add, Pi.add_apply, add_mul]
        exact (summable_evaluate f hz).tsum_add (summable_evaluate g hz)
      map_smul' := fun c f => by
        simp only [evaluate, lp.coeFn_smul, Pi.smul_apply, smul_eq_mul,
          RingHom.id_apply, mul_assoc]
        exact tsum_mul_left }
    (1 / (1 - ‖z‖))
    (fun f => by simpa [div_eq_mul_inv, mul_comm] using norm_evaluate_le f hz)

theorem eval_apply (z : Complex) (hz : ‖z‖ < 1) (f : H2) :
    eval z hz f = evaluate f z := rfl

/-- The coefficient bound gives a convergence radius of at least one. -/
theorem series_radius (f : H2) :
    (1 : ENNReal) ≤ (FormalMultilinearSeries.ofScalars Complex (fun n => f n)).radius := by
  simpa using
    (FormalMultilinearSeries.ofScalars Complex (fun n => f n)).le_radius_of_bound
      (r := 1) ‖f‖ (fun n => by
        simpa [FormalMultilinearSeries.ofScalars_norm] using
          lp.norm_apply_le_norm (by norm_num : (2 : ENNReal) ≠ 0) f n)

/-- The evaluated coefficient series is analytic throughout the open disk. -/
theorem analytic_evaluate (f : H2) :
    AnalyticOnNhd Complex (evaluate f) (Metric.ball 0 1) := by
  have heq : evaluate f = (FormalMultilinearSeries.ofScalars Complex (fun n => f n)).sum := by
    funext z
    exact (FormalMultilinearSeries.ofScalars_sum_eq (fun n => f n) z).symm
  rw [heq]
  apply FormalMultilinearSeries.analyticOnNhd.mono
  intro z hz
  apply lt_of_lt_of_le _ (series_radius f)
  rw [edist_dist, dist_zero_right]
  exact ENNReal.ofReal_lt_one.mpr (by simpa using hz)

/-- Agreement of evaluations in the open disk determines every coefficient. -/
theorem evaluate_injective {f g : H2}
    (h : ∀ z : Complex, ‖z‖ < 1 → evaluate f z = evaluate g z) : f = g := by
  have hf := (FormalMultilinearSeries.ofScalars Complex (fun n => f n)).hasFPowerSeriesOnBall
    (lt_of_lt_of_le zero_lt_one (series_radius f))
  have hg := (FormalMultilinearSeries.ofScalars Complex (fun n => g n)).hasFPowerSeriesOnBall
    (lt_of_lt_of_le zero_lt_one (series_radius g))
  have heq := hf.hasFPowerSeriesAt.eq_formalMultilinearSeries_of_eventually
    hg.hasFPowerSeriesAt (show ∀ᶠ z in 𝓝 (0 : Complex),
      (FormalMultilinearSeries.ofScalars Complex (fun n => f n)).sum z =
      (FormalMultilinearSeries.ofScalars Complex (fun n => g n)).sum z from
      Filter.mem_of_superset (Metric.ball_mem_nhds (0 : Complex) zero_lt_one) fun z hz => by
        change FormalMultilinearSeries.ofScalarsSum (fun n => f n) z =
          FormalMultilinearSeries.ofScalarsSum (fun n => g n) z
        simpa [FormalMultilinearSeries.ofScalars_sum_eq, smul_eq_mul, evaluate] using
          h z (by simpa using hz))
  have hc := FormalMultilinearSeries.ofScalars_series_injective Complex Complex heq
  exact lp.ext hc

/-- The full coefficient sum is exactly the squared Hilbert norm. -/
theorem coefficient_norm_sq (f : H2) : ∑' n : Nat, ‖f n‖ ^ 2 = ‖f‖ ^ 2 := by
  simpa using (lp.hasSum_norm (by norm_num : 0 < (2 : ENNReal).toReal) f).tsum_eq

/-- Finite coefficient truncations converge in the Hardy Hilbert norm. -/
theorem coefficient_truncations (f : H2) : HasSum (fun n : Nat => lp.single 2 n (f n)) f :=
  lp.hasSum_single (by norm_num) f

#print axioms summable_evaluate
#print axioms norm_evaluate_le
#print axioms analytic_evaluate
#print axioms evaluate_injective
#print axioms coefficient_norm_sq
#print axioms coefficient_truncations

open MeasureTheory Filter
open scoped InnerProductSpace

local instance : Fact (0 < 2 * Real.pi) := ⟨by positivity⟩

def radialSeries (f : H2) (r : Real) : C(AddCircle (2 * Real.pi), Complex) :=
  ∑' n : Nat, (f n * (r : Complex)^n) • fourier (n : Int)

theorem radialSeries_hasSum (f : H2) {r : Real} (hr : 0 ≤ r) (hr1 : r < 1) :
    HasSum (fun n : Nat => (f n * (r : Complex)^n) • fourier (n : Int)) (radialSeries f r) := by
  apply Summable.hasSum
  apply Summable.of_norm_bounded ((summable_geometric_of_lt_one hr hr1).mul_left ‖f‖)
  intro n
  simp only [norm_smul, norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg hr, fourier_norm, mul_one]
  exact mul_le_mul_of_nonneg_right (lp.norm_apply_le_norm (by norm_num) f n)
    (pow_nonneg hr n)

theorem radialSeries_norm_sq (f : H2) {r : Real} (hr : 0 ≤ r) (hr1 : r < 1) :
    ‖ContinuousMap.toLp 2 AddCircle.haarAddCircle Complex (radialSeries f r)‖ ^ 2 =
      ∑' n : Nat, ‖f n‖^2 * r^(2*n) := by
  let L : C(AddCircle (2 * Real.pi), Complex) →L[Complex]
      Lp Complex 2 AddCircle.haarAddCircle :=
    ContinuousMap.toLp 2 AddCircle.haarAddCircle Complex
  have h := L.hasSum (radialSeries_hasSum f hr hr1)
  have ho : Orthonormal Complex (fun n : Nat => (fourierLp 2 (n : Int) :
      Lp Complex 2 (AddCircle.haarAddCircle (T := 2 * Real.pi)))) :=
    orthonormal_fourier.comp (fun n : Nat => (n : Int)) Nat.cast_injective
  have hnorm (s : Finset Nat) :
      ‖∑ n ∈ s, L ((f n * (r : Complex)^n) • fourier (n : Int))‖^2 =
        ∑ n ∈ s, ‖f n‖^2 * r^(2*n) := by
    have hin := ho.inner_sum
      (fun n => f n * (r : Complex)^n) (fun n => f n * (r : Complex)^n) s
    rw [inner_self_eq_norm_sq_to_K] at hin
    simp only [RCLike.conj_mul] at hin
    have hn : ‖∑ n ∈ s, (f n * (r : Complex)^n) •
        fourierLp (T := 2 * Real.pi) 2 (n : Int)‖^2 =
        ∑ n ∈ s, ‖f n * (r : Complex)^n‖^2 := by
      simpa only [← RCLike.ofReal_pow, map_sum, RCLike.ofReal_re] using
        congrArg (@RCLike.re Complex _) hin
    simpa [L, map_smul, norm_mul, norm_pow, abs_of_nonneg hr, mul_pow,
      ← pow_mul, Nat.mul_comm] using hn
  have hs : HasSum (fun n : Nat => ‖f n‖^2 * r^(2*n))
      (‖L (radialSeries f r)‖^2) := by
    change Tendsto (fun s : Finset Nat => ∑ n ∈ s, ‖f n‖^2 * r^(2*n)) atTop _
    have hh := h.norm.pow 2
    change Tendsto (fun s : Finset Nat =>
      ‖∑ n ∈ s, L ((f n * (r : Complex)^n) • fourier (n : Int))‖^2) atTop _ at hh
    simpa only [hnorm] using hh
  exact hs.tsum_eq.symm

theorem radialSeries_evaluate (f : H2) {r : Real} (hr : 0 ≤ r) (hr1 : r < 1) (t : Real) :
    radialSeries f r (t : AddCircle (2 * Real.pi)) =
      evaluate f ((r : Complex) * Complex.exp (Complex.I * t)) := by
  have h := (ContinuousMap.evalCLM Complex (t : AddCircle (2 * Real.pi))).hasSum
    (radialSeries_hasSum f hr hr1)
  have hz : ‖(r : Complex) * Complex.exp (Complex.I * t)‖ < 1 := by
    simpa [norm_mul, Complex.norm_exp, Complex.mul_re, abs_of_nonneg hr] using hr1
  apply h.unique
  convert evaluate_hasSum f hz using 1
  funext n
  simp only [ContinuousMap.evalCLM_apply,
    ContinuousMap.smul_apply, smul_eq_mul, fourier_coe_apply, mul_pow]
  rw [← mul_assoc]
  congr 1
  rw [← Complex.exp_nat_mul]
  congr 1
  push_cast
  field_simp

theorem radial_mean_square (f : H2) {r : Real} (hr : 0 ≤ r) (hr1 : r < 1) :
    (2 * Real.pi)⁻¹ * (∫ t in (0 : Real)..(2 * Real.pi),
      ‖evaluate f ((r : Complex) * Complex.exp (Complex.I * t))‖^2) =
      ∑' n : Nat, ‖f n‖^2 * r^(2*n) := by
  let F := radialSeries f r
  let L := ContinuousMap.toLp 2 AddCircle.haarAddCircle Complex F
  have hint : ‖L‖^2 = ∫ t : AddCircle (2 * Real.pi), ‖F t‖^2 ∂AddCircle.haarAddCircle := by
    have h := congrArg (@RCLike.re Complex _) (@L2.inner_def _ Complex Complex _ _ _ _ _ L L)
    rw [← integral_re] at h
    · simp only [← norm_sq_eq_re_inner] at h
      rw [h]
      apply integral_congr_ae
      filter_upwards [ContinuousMap.coeFn_toLp (𝕜 := Complex) (p := 2)
        (μ := AddCircle.haarAddCircle) F] with t ht
      rw [ht]
    · exact L2.integrable_inner L L
  rw [← radialSeries_norm_sq f hr hr1, hint, AddCircle.integral_haarAddCircle]
  rw [← AddCircle.intervalIntegral_preimage (2 * Real.pi) 0]
  simp only [zero_add, smul_eq_mul]
  congr 1
  apply intervalIntegral.integral_congr
  intro t ht
  change ‖evaluate f ((r : Complex) * Complex.exp (Complex.I * t))‖^2 =
    ‖F (t : AddCircle (2 * Real.pi))‖^2
  rw [show F (t : AddCircle (2 * Real.pi)) =
    evaluate f ((r : Complex) * Complex.exp (Complex.I * t)) from radialSeries_evaluate f hr hr1 t]

def radialMean (f : H2) (r : Real) : Real :=
  (2 * Real.pi)⁻¹ * (∫ t in (0 : Real)..(2 * Real.pi),
    ‖evaluate f ((r : Complex) * Complex.exp (Complex.I * t))‖^2)

theorem radialMean_le (f : H2) {r : Real} (hr : 0 ≤ r) (hr1 : r < 1) :
    radialMean f r ≤ ‖f‖^2 := by
  rw [radialMean, radial_mean_square f hr hr1, ← coefficient_norm_sq f]
  have hs : Summable (fun n : Nat => ‖f n‖^2) := by
    simpa using (lp.hasSum_norm (by norm_num : 0 < (2 : ENNReal).toReal) f).summable
  have hb (n : Nat) : ‖f n‖^2 * r^(2*n) ≤ ‖f n‖^2 :=
    mul_le_of_le_one_right (sq_nonneg _) (pow_le_one₀ hr hr1.le)
  exact (hs.of_nonneg_of_le (fun n => mul_nonneg (sq_nonneg _) (pow_nonneg hr _)) hb).tsum_le_tsum hb hs

theorem radialMean_tendsto (f : H2) : Tendsto (radialMean f) (𝓝[Set.Iio 1] (1 : Real))
    (𝓝 (‖f‖^2)) := by
  have hs : Summable (fun n : Nat => ‖f n‖^2) := by
    simpa using (lp.hasSum_norm (by norm_num : 0 < (2 : ENNReal).toReal) f).summable
  have h := tendsto_tsum_of_dominated_convergence (𝓕 := 𝓝[Set.Iio 1] (1 : Real))
    (f := fun r n => ‖f n‖^2 * r^(2*n)) hs
    (fun n => by simpa using tendsto_const_nhds.mul (tendsto_nhdsWithin_of_tendsto_nhds
      (continuousAt_id.pow (2*n)).tendsto))
    (show ∀ᶠ r in 𝓝[Set.Iio 1] (1 : Real), ∀ n : Nat, ‖‖f n‖^2 * r^(2*n)‖ ≤ ‖f n‖^2 from
      Filter.mem_of_superset (Ico_mem_nhdsLT (show (0 : Real) < 1 by norm_num)) fun r hr n => by
        rw [Real.norm_of_nonneg (mul_nonneg (sq_nonneg _) (pow_nonneg hr.1 _))]
        exact mul_le_of_le_one_right (sq_nonneg _) (pow_le_one₀ hr.1 hr.2.le))
  simp only [one_pow, mul_one, coefficient_norm_sq] at h
  apply h.congr'
  filter_upwards [Ico_mem_nhdsLT (show (0 : Real) < 1 by norm_num)] with r hr
  exact (radial_mean_square f hr.1 hr.2).symm

theorem hardy_norm (f : H2) : sSup (radialMean f '' Set.Ico (0 : Real) 1) = ‖f‖^2 := by
  apply IsLUB.csSup_eq
  · constructor
    · rintro _ ⟨r, hr, rfl⟩
      exact radialMean_le f hr.1 hr.2
    · intro c hc
      apply le_of_tendsto (radialMean_tendsto f)
      filter_upwards [Ico_mem_nhdsLT (show (0 : Real) < 1 by norm_num)] with r hr
      exact hc ⟨r, hr, rfl⟩
  · exact ⟨radialMean f 0, 0, ⟨le_rfl, by norm_num⟩, rfl⟩

#print axioms radial_mean_square
#print axioms hardy_norm

end D5.S3.Analytic.Hardy.HardyCoefficientRealization
