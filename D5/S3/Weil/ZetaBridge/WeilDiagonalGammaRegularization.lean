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

/-! ## Finite evaluation of the relative diagonal and a uniform window correction -/

open scoped BigOperators

private def seriesRate (j : ℕ) : ℝ := 2 * (j : ℝ) + 1 / 2
private def seriesFrequency (L : ℝ) (n : ℤ) : ℝ := 2 * Real.pi * (n : ℝ) / L
private def resolventTerm (w a : ℝ) : ℝ := 2 * w ^ 2 / (a * (a ^ 2 + w ^ 2))
private def windowCorrection (L w a : ℝ) : ℝ :=
  (2 * w ^ 2 * (3 * a ^ 2 + w ^ 2) / (a ^ 2 + w ^ 2) ^ 2) *
    ((1 - Real.exp (-a * L)) / (L * a ^ 2))

/-- One explicitly evaluable term of the actual relative diagonal. The
positive full-line Gamma resolvent contribution and its finite-window
correction are both retained. No special-function evaluation or infinite
integral is hidden in this finite term. -/
def diagonalGammaSeriesTerm (L : ℝ) (n : ℤ) (j : ℕ) : ℝ :=
  resolventTerm (seriesFrequency L n) (seriesRate j) -
    windowCorrection L (seriesFrequency L n) (seriesRate j)

private theorem triangular_laplace_cosine {L a w : ℝ} (hL : 0 < L) (ha : 0 < a)
    (hs : Real.sin (w * L) = 0) (hc : Real.cos (w * L) = 1) :
    (∫ t : ℝ in Ioc 0 L, Real.exp (-a * t) * (1 - t / L) * Real.cos (w * t)) =
      a / (a ^ 2 + w ^ 2) -
        (a ^ 2 - w ^ 2) * (1 - Real.exp (-a * L)) / (L * (a ^ 2 + w ^ 2) ^ 2) := by
  let D := a ^ 2 + w ^ 2
  have hD : D ≠ 0 := (by dsimp [D]; positivity : 0 < D).ne'
  let F : ℝ → ℝ := fun t =>
    Real.exp (-a * t) * ((1 - t / L) * (-a * Real.cos (w * t) + w * Real.sin (w * t))) / D +
      Real.exp (-a * t) * ((a ^ 2 - w ^ 2) * Real.cos (w * t) -
        2 * a * w * Real.sin (w * t)) / (L * D ^ 2)
  have hF (t : ℝ) : HasDerivAt F
      (Real.exp (-a * t) * (1 - t / L) * Real.cos (w * t)) t := by
    have he := ((hasDerivAt_id t).const_mul (-a)).exp
    have hcos := ((hasDerivAt_id t).const_mul w).cos
    have hsin := ((hasDerivAt_id t).const_mul w).sin
    have hlin := (hasDerivAt_const t (1 : ℝ)).sub ((hasDerivAt_id t).div_const L)
    have hfirst := (he.mul (hlin.mul ((hcos.const_mul (-a)).add (hsin.const_mul w)))).div_const D
    have hsecond := (he.mul ((hcos.const_mul (a ^ 2 - w ^ 2)).sub
      (hsin.const_mul (2 * a * w)))).div_const (L * D ^ 2)
    convert hfirst.add hsecond using 1 <;>
      dsimp [F, D] at * <;> field_simp [hL.ne', hD] <;> ring
  have hi : IntervalIntegrable
      (fun t : ℝ => Real.exp (-a * t) * (1 - t / L) * Real.cos (w * t)) volume 0 L :=
    (by fun_prop : Continuous _).intervalIntegrable 0 L
  rw [← intervalIntegral.integral_of_le hL.le,
    intervalIntegral.integral_eq_sub_of_hasDerivAt (fun t _ => hF t) hi]
  simp only [F, hs, hc, Real.exp_zero, Real.sin_zero, Real.cos_zero,
    mul_zero, sub_zero, zero_div, mul_one, one_mul, div_self hL.ne', sub_self, zero_mul]
  dsimp [D]
  ring

private theorem term_integral {L : ℝ} (hL : 0 < L) (n : ℤ) (j : ℕ) :
    diagonalGammaSeriesTerm L n j =
      ∫ t : ℝ in Ioc 0 L, 2 * Real.exp (-seriesRate j * t) *
        (1 - t / L) * (1 - Real.cos (seriesFrequency L n * t)) := by
  have ha : 0 < seriesRate j := by unfold seriesRate; positivity
  have hend : seriesFrequency L n * L = (n : ℝ) * (2 * Real.pi) := by
    unfold seriesFrequency; field_simp [hL.ne'] <;> ring
  have hc : Real.cos (seriesFrequency L n * L) = 1 := by
    rw [hend]; exact Real.cos_int_mul_two_pi n
  have hs : Real.sin (seriesFrequency L n * L) = 0 :=
    Real.sin_eq_zero_iff_cos_eq.mpr (Or.inl hc)
  have hi (w : ℝ) : IntegrableOn
      (fun t : ℝ => Real.exp (-seriesRate j * t) * (1 - t / L) * Real.cos (w * t))
      (Ioc 0 L) := ((by fun_prop : Continuous _).intervalIntegrable 0 L).1
  have hid (t : ℝ) : 2 * Real.exp (-seriesRate j * t) * (1 - t / L) *
      (1 - Real.cos (seriesFrequency L n * t)) =
      2 * (Real.exp (-seriesRate j * t) * (1 - t / L) * Real.cos (0 * t) -
        Real.exp (-seriesRate j * t) * (1 - t / L) * Real.cos (seriesFrequency L n * t)) := by
    simp only [zero_mul, Real.cos_zero, mul_one]; ring
  simp_rw [hid]
  rw [integral_const_mul, integral_sub (hi 0) (hi _),
    triangular_laplace_cosine hL ha (by simp) (by simp), triangular_laplace_cosine hL ha hs hc]
  unfold diagonalGammaSeriesTerm resolventTerm windowCorrection
  have hd : seriesRate j ^ 2 + seriesFrequency L n ^ 2 ≠ 0 := by positivity
  field_simp [hL.ne', ha.ne', hd]
  <;> ring

private theorem correction_bounds {L a : ℝ} (hL : 0 < L) (ha : 0 < a) (w : ℝ) :
    0 ≤ windowCorrection L w a ∧ windowCorrection L w a ≤ 9 / (4 * L * a ^ 2) := by
  have he : Real.exp (-a * L) ≤ 1 := Real.exp_le_one_iff.mpr (by nlinarith)
  have he0 : 0 ≤ 1 - Real.exp (-a * L) := sub_nonneg.mpr he
  have he1 : 1 - Real.exp (-a * L) ≤ 1 := by linarith [Real.exp_pos (-a * L)]
  have hrat : 2 * w ^ 2 * (3 * a ^ 2 + w ^ 2) / (a ^ 2 + w ^ 2) ^ 2 ≤ 9 / 4 := by
    apply (div_le_iff₀ (by positivity : 0 < (a ^ 2 + w ^ 2) ^ 2)).mpr
    nlinarith [sq_nonneg (w ^ 2 - 3 * a ^ 2)]
  refine ⟨by unfold windowCorrection; positivity, ?_⟩
  unfold windowCorrection
  calc
    _ ≤ (9 / 4) * (1 / (L * a ^ 2)) := by gcongr
    _ = _ := by ring

private theorem term_bounds {L : ℝ} (hL : 0 < L) (n : ℤ) (j : ℕ) :
    0 ≤ diagonalGammaSeriesTerm L n j ∧
      diagonalGammaSeriesTerm L n j ≤ 2 * seriesFrequency L n ^ 2 / seriesRate j ^ 3 := by
  have ha : 0 < seriesRate j := by unfold seriesRate; positivity
  refine ⟨?_, ?_⟩
  · rw [term_integral hL]
    apply integral_nonneg_of_ae
    filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
    have htL : 0 ≤ 1 - t / L := sub_nonneg.mpr ((div_le_one hL).mpr ht.2)
    have hc : 0 ≤ 1 - Real.cos (seriesFrequency L n * t) := sub_nonneg.mpr (Real.cos_le_one _)
    positivity
  · unfold diagonalGammaSeriesTerm
    apply (sub_le_self _ (correction_bounds hL ha _).1).trans
    unfold resolventTerm
    apply div_le_div_of_nonneg_left (by positivity) (by positivity)
    have hmul := mul_nonneg ha.le (sq_nonneg (seriesFrequency L n))
    nlinarith

private theorem inverse_cube_step {a : ℝ} (ha : 1 < a) :
    2 / a ^ 3 ≤ 1 / (2 * (a - 1) ^ 2) - 1 / (2 * (a + 1) ^ 2) := by
  have ha0 : 0 < a := by linarith
  have hm : 0 < a - 1 := by linarith
  have hp : 0 < a + 1 := by linarith
  have hid : (1 / (2 * (a - 1) ^ 2) - 1 / (2 * (a + 1) ^ 2)) - 2 / a ^ 3 =
      2 * (2 * a ^ 2 - 1) / (a ^ 3 * (a - 1) ^ 2 * (a + 1) ^ 2) := by
    field_simp [ha0.ne', hm.ne', hp.ne'] <;> ring
  apply sub_nonneg.mp
  rw [hid]
  have hn : 0 ≤ 2 * a ^ 2 - 1 := by nlinarith [sq_nonneg (a - 1)]
  positivity

private theorem term_tail_step {L : ℝ} (hL : 0 < L) (n : ℤ) (j : ℕ) :
    diagonalGammaSeriesTerm L n (j + 1) ≤
      2 * seriesFrequency L n ^ 2 / (4 * (j : ℝ) + 3) ^ 2 -
        2 * seriesFrequency L n ^ 2 / (4 * ((j + 1 : ℕ) : ℝ) + 3) ^ 2 := by
  have ha : 1 < seriesRate (j + 1) := by
    have hj : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
    unfold seriesRate; push_cast; linarith
  have h := mul_le_mul_of_nonneg_left (inverse_cube_step ha) (sq_nonneg (seriesFrequency L n))
  apply (term_bounds hL n (j + 1)).2.trans
  convert h using 1 <;> unfold seriesRate <;> push_cast <;> field_simp <;> ring

private theorem term_tail_partial {L : ℝ} (hL : 0 < L) (n : ℤ) (K T : ℕ) :
    (∑ j ∈ Finset.range T, diagonalGammaSeriesTerm L n (j + (K + 1))) ≤
      2 * seriesFrequency L n ^ 2 / (4 * (K : ℝ) + 3) ^ 2 -
        2 * seriesFrequency L n ^ 2 / (4 * ((T + K : ℕ) : ℝ) + 3) ^ 2 := by
  induction T with
  | zero => simp
  | succ T ih =>
    rw [Finset.sum_range_succ]
    have h := term_tail_step hL n (T + K)
    have hi : T + (K + 1) = T + K + 1 := by omega
    have hn : T + 1 + K = T + K + 1 := by omega
    rw [hi, hn]
    linarith

private theorem term_tail_summable {L : ℝ} (hL : 0 < L) (n : ℤ) (K : ℕ) :
    Summable (fun j : ℕ => diagonalGammaSeriesTerm L n (j + (K + 1))) ∧
      (∑' j : ℕ, diagonalGammaSeriesTerm L n (j + (K + 1))) ≤
        2 * seriesFrequency L n ^ 2 / (4 * (K : ℝ) + 3) ^ 2 := by
  have hpart (T : ℕ) : (∑ j ∈ Finset.range T, diagonalGammaSeriesTerm L n (j + (K + 1))) ≤
      2 * seriesFrequency L n ^ 2 / (4 * (K : ℝ) + 3) ^ 2 :=
    (term_tail_partial hL n K T).trans (sub_le_self _ (by positivity))
  exact ⟨summable_of_sum_range_le (fun j => (term_bounds hL n _).1) hpart,
    Real.tsum_le_of_sum_range_le (fun j => (term_bounds hL n _).1) hpart⟩

/-- The finite elementary terms form the complete original relative Gamma
diagonal. Each term is nonnegative. Existence of the series, integrability,
term integration and exchange of limit with integral are all derived. -/
theorem diagonal_gamma_hasSum {L : ℝ} (hL : 0 < L) (n : ℤ) :
    (∀ j, 0 ≤ diagonalGammaSeriesTerm L n j) ∧
    HasSum (diagonalGammaSeriesTerm L n)
      ((∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L 0 t) -
        (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L n t)) := by
  let w := seriesFrequency L n
  let f : ℕ → ℝ → ℝ := fun j t =>
    2 * Real.exp (-seriesRate j * t) * (1 - t / L) * (1 - Real.cos (w * t))
  let F : ℕ → ℝ → ℝ := fun N t => ∑ j ∈ Finset.range N, f j t
  have hseries : Summable (diagonalGammaSeriesTerm L n) :=
    (summable_nat_add_iff 1).mp (term_tail_summable hL n 0).1
  have hmeas (N : ℕ) : AEStronglyMeasurable (F N) (volume.restrict (Ioc 0 L)) :=
    (by unfold F f; fun_prop : Continuous _).aestronglyMeasurable
  have henergy : IntegrableOn (energy L w) (Ioc 0 L) := by
    apply ((raw_integrable hL 0).sub (raw_integrable hL w)).congr
    exact Filter.Eventually.of_forall (raw_sub L w)
  have hdom (N : ℕ) : ∀ᵐ t ∂volume.restrict (Ioc 0 L), ‖F N t‖ ≤ energy L w t := by
    filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
    have hg := D5.S3.Weil.ZetaBridge.WeilBoundaryKernelIntegral.gamma_exponential_kernel_hasSum ht.1
    have hsum : (∑ j ∈ Finset.range N, Real.exp (-seriesRate j * t)) ≤
        Real.exp (t / 2) / den t := by
      rw [← hg.tsum_eq]
      exact hg.summable.sum_le_tsum _ (fun _ _ => (Real.exp_pos _).le)
    have hfactor : 0 ≤ 2 * (1 - t / L) * (1 - Real.cos (w * t)) := by
      have hwindow : 0 ≤ 1 - t / L := sub_nonneg.mpr ((div_le_one hL).mpr ht.2)
      have hcos : 0 ≤ 1 - Real.cos (w * t) := sub_nonneg.mpr (Real.cos_le_one _)
      positivity
    have hid : F N t = (∑ j ∈ Finset.range N, Real.exp (-seriesRate j * t)) *
        (2 * (1 - t / L) * (1 - Real.cos (w * t))) := by
      simp only [F, f, Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro j _; ring
    rw [hid, Real.norm_eq_abs, abs_of_nonneg (by positivity)]
    convert mul_le_mul_of_nonneg_right hsum hfactor using 1 <;> unfold energy <;> ring
  have hlim : ∀ᵐ t ∂volume.restrict (Ioc 0 L),
      Filter.Tendsto (fun N => F N t) Filter.atTop (nhds (energy L w t)) := by
    filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
    have hg := (D5.S3.Weil.ZetaBridge.WeilBoundaryKernelIntegral.gamma_exponential_kernel_hasSum ht.1).mul_right
      (2 * (1 - t / L) * (1 - Real.cos (w * t)))
    have hfun : (fun N => F N t) = (fun N => ∑ j ∈ Finset.range N,
        Real.exp (-(2 * (j : ℝ) + 1 / 2) * t) *
          (2 * (1 - t / L) * (1 - Real.cos (w * t)))) := by
      funext N
      apply Finset.sum_congr rfl
      intro j _
      dsimp [f, seriesRate]
      ring
    have hval : energy L w t =
        (Real.exp (t / 2) / (Real.exp t - Real.exp (-t))) *
          (2 * (1 - t / L) * (1 - Real.cos (w * t))) := by
      unfold energy den
      ring
    rw [hfun, hval]
    exact hg.tendsto_sum_nat
  have hconv := MeasureTheory.tendsto_integral_of_dominated_convergence
    (μ := volume.restrict (Ioc 0 L)) (energy L w) hmeas henergy hdom hlim
  have heval (N : ℕ) : (∫ t : ℝ in Ioc 0 L, F N t) =
      ∑ j ∈ Finset.range N, diagonalGammaSeriesTerm L n j := by
    rw [show F N = (fun t => ∑ j ∈ Finset.range N, f j t) from rfl,
      integral_finsetSum _ (fun j _ => ((by unfold f; fun_prop : Continuous _).intervalIntegrable 0 L).1)]
    apply Finset.sum_congr rfl
    intro j _
    exact (term_integral hL n j).symm
  simp_rw [heval] at hconv
  have hvalue := tendsto_nhds_unique hseries.hasSum.tendsto_sum_nat hconv
  have he := (diagonal_gamma_relative_energy hL n).1
  have hsum : (∑' j, diagonalGammaSeriesTerm L n j) =
      (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L 0 t) -
        (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L n t) := hvalue.trans he.symm
  exact ⟨fun j => (term_bounds hL n j).1, hsum ▸ hseries.hasSum⟩

/-- Keeping j=0,...,K gives a certified one-sided interval for the ACTUAL
relative diagonal; all omitted terms are bounded by an inverse-square radius.
K=0, zero/negative frequencies and every positive physical window are included. -/
theorem diagonal_gamma_series_error {L : ℝ} (hL : 0 < L) (n : ℤ) (K : ℕ) :
    let E := (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L 0 t) -
      (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L n t)
    let S := ∑ j ∈ Finset.range (K + 1), diagonalGammaSeriesTerm L n j
    0 ≤ E - S ∧ E - S ≤
      2 * (2 * Real.pi * (n : ℝ) / L) ^ 2 / (4 * (K : ℝ) + 3) ^ 2 := by
  dsimp only
  have hs := (diagonal_gamma_hasSum hL n).2
  have hsplit := hs.summable.sum_add_tsum_nat_add (K + 1)
  rw [hs.tsum_eq] at hsplit
  have htail : (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L 0 t) -
      (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L n t) -
      (∑ j ∈ Finset.range (K + 1), diagonalGammaSeriesTerm L n j) =
      ∑' j : ℕ, diagonalGammaSeriesTerm L n (j + (K + 1)) := by linarith
  rw [htail]
  exact ⟨tsum_nonneg (fun j => (term_bounds hL n _).1), (term_tail_summable hL n K).2⟩

private theorem inverse_square_prefix (K : ℕ) :
    (∑ j ∈ Finset.range (K + 1), 1 / seriesRate j ^ 2) ≤ 13 / 3 := by
  have hstrong (N : ℕ) : (∑ j ∈ Finset.range (N + 1), 1 / seriesRate j ^ 2) ≤
      13 / 3 - 1 / (4 * (N : ℝ) + 3) := by
    induction N with
    | zero => norm_num [seriesRate]
    | succ N ih =>
      rw [Finset.sum_range_succ]
      have ha : 1 < seriesRate (N + 1) := by
        have hN : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
        unfold seriesRate; push_cast; linarith
      have hstep : 1 / seriesRate (N + 1) ^ 2 ≤
          1 / (4 * (N : ℝ) + 3) - 1 / (4 * ((N + 1 : ℕ) : ℝ) + 3) := by
        have hden : 0 < seriesRate (N + 1) ^ 2 - 1 := by nlinarith
        calc
          _ ≤ 1 / (seriesRate (N + 1) ^ 2 - 1) :=
            one_div_le_one_div_of_le hden (by linarith)
          _ = _ := by unfold seriesRate; push_cast; field_simp <;> ring
      exact (add_le_add ih hstep).trans_eq (by ring)
  exact (hstrong K).trans (sub_le_self _ (by positivity))

/-- Bridge to the finite positive resolvent sums used by the existing Gamma
scale-modulus work. The finite-window correction is bounded uniformly in the
integer frequency by 39/(4L). No full-matrix or operator coercivity follows
from this scalar diagonal comparison alone. -/
theorem diagonal_gamma_resolvent_window_bounds {L : ℝ} (hL : 0 < L) (n : ℤ) (K : ℕ) :
    let w := 2 * Real.pi * (n : ℝ) / L
    let G := ∑ j ∈ Finset.range (K + 1),
      2 * w ^ 2 / ((2 * (j : ℝ) + 1 / 2) * ((2 * (j : ℝ) + 1 / 2) ^ 2 + w ^ 2))
    let E := (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L 0 t) -
      (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L n t)
    G - 39 / (4 * L) ≤ E ∧ E ≤ G + 2 * w ^ 2 / (4 * (K : ℝ) + 3) ^ 2 := by
  dsimp only
  have hcorr : (∑ j ∈ Finset.range (K + 1),
      windowCorrection L (seriesFrequency L n) (seriesRate j)) ≤ 39 / (4 * L) := by
    calc
      _ ≤ ∑ j ∈ Finset.range (K + 1), 9 / (4 * L * seriesRate j ^ 2) :=
        Finset.sum_le_sum (fun j _ => (correction_bounds hL (by unfold seriesRate; positivity) _).2)
      _ = (9 / (4 * L)) * ∑ j ∈ Finset.range (K + 1), 1 / seriesRate j ^ 2 := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro j _; ring
      _ ≤ (9 / (4 * L)) * (13 / 3) :=
        mul_le_mul_of_nonneg_left (inverse_square_prefix K) (by positivity)
      _ = _ := by ring
  have hcorr0 : 0 ≤ ∑ j ∈ Finset.range (K + 1),
      windowCorrection L (seriesFrequency L n) (seriesRate j) :=
    Finset.sum_nonneg (fun j _ => (correction_bounds hL (by unfold seriesRate; positivity) _).1)
  have hE := diagonal_gamma_series_error hL n K
  dsimp only at hE
  simp only [diagonalGammaSeriesTerm, Finset.sum_sub_distrib, resolventTerm,
    seriesFrequency, seriesRate] at hE hcorr hcorr0
  constructor <;> linarith

/-- A finite table of justified term balls gives a certified enclosure of the
original integral. This small consumer retains all term-rounding errors and
the entire proved series tail; the finite center is not declared exact. -/
theorem diagonal_gamma_finite_enclosure {L : ℝ} (hL : 0 < L) (n : ℤ) (K : ℕ)
    (center radius : ℕ → ℚ) (F : ℚ)
    (hF : |2 * Real.pi * (n : ℝ) / L| ≤ (F : ℝ))
    (hball : ∀ j ∈ Finset.range (K + 1),
      |diagonalGammaSeriesTerm L n j - (center j : ℝ)| ≤ (radius j : ℝ)) :
    let E := (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L 0 t) -
      (∫ t : ℝ in Ioc 0 L, diagonalGammaIntegrand L n t)
    ((∑ j ∈ Finset.range (K + 1), center j - radius j : ℚ) : ℝ) ≤ E ∧
      E ≤ (((∑ j ∈ Finset.range (K + 1), center j + radius j) +
        2 * F ^ 2 / (4 * (K : ℚ) + 3) ^ 2 : ℚ) : ℝ) := by
  dsimp only
  have hl := Finset.sum_le_sum (s := Finset.range (K + 1)) (fun j hj =>
    sub_le_iff_le_add.mpr (show (center j : ℝ) ≤ diagonalGammaSeriesTerm L n j + (radius j : ℝ) by
      have h := (abs_le.mp (hball j hj)).1; linarith))
  have hu := Finset.sum_le_sum (s := Finset.range (K + 1)) (fun j hj =>
    show diagonalGammaSeriesTerm L n j ≤ (center j : ℝ) + (radius j : ℝ) from by
      have h := (abs_le.mp (hball j hj)).2
      linarith)
  have h := diagonal_gamma_series_error hL n K
  dsimp only at h
  have hF0 : (0 : ℝ) ≤ (F : ℝ) := (abs_nonneg _).trans hF
  have hsquare := (sq_le_sq₀ (abs_nonneg _) hF0).mpr hF
  rw [sq_abs] at hsquare
  have hrad : 2 * (2 * Real.pi * (n : ℝ) / L) ^ 2 / (4 * (K : ℝ) + 3) ^ 2 ≤
      2 * (F : ℝ) ^ 2 / (4 * (K : ℝ) + 3) ^ 2 :=
    div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hsquare (by norm_num)) (sq_nonneg _)
  push_cast
  constructor <;> linarith

#print axioms diagonal_gamma_hasSum
#print axioms diagonal_gamma_series_error
#print axioms diagonal_gamma_resolvent_window_bounds
#print axioms diagonal_gamma_finite_enclosure

#print axioms diagonal_gamma_integrable
#print axioms diagonal_gamma_relative_energy
#print axioms diagonal_gamma_endpoint_error

end D5.S3.Weil.ZetaBridge.WeilDiagonalGammaRegularization
