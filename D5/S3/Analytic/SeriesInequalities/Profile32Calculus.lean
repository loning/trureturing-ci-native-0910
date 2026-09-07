/- GID: D5/S3/Analytic/SeriesInequalities/Profile32Calculus
   generality: G
   mirror-B: D5/B/S3/Analytic/SeriesInequalities/Profile32Calculus
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Differential interpretation of the cubic profile curvature. -/

import D5.S3.Analytic.SeriesInequalities.Profile32Concavity
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Analysis.Calculus.Deriv.Shift

set_option autoImplicit false
noncomputable section
open Set Filter
open scoped Topology

namespace D5.S3.Analytic.SeriesInequalities.Profile32Concavity

def chartFirst (z : ℝ) : ℝ := 27 * (1 - z^2) / (Real.sqrt (3 + z^2))^5
def chartProfile (z : ℝ) : ℝ := weight z * (profileSum z) ^ (-(4/3 : ℝ))
def positiveFirst (z : ℝ) : ℝ :=
  sumFirst z (Real.sqrt (3 - 2*z - z^2)) (Real.sqrt (4*z))
    (Real.sqrt (3 + 2*z - z^2))
def positiveSecond (z : ℝ) : ℝ :=
  sumSecond z (Real.sqrt (3 - 2*z - z^2)) (Real.sqrt (4*z))
    (Real.sqrt (3 + 2*z - z^2))
def profileSlope (z : ℝ) : ℝ := deriv chartProfile z / chartFirst z

theorem chart_bounds (z : ℝ) (hz : z ∈ Ioo (-1) 1) :
    z^2 < 1 ∧ 0 < 3 - 2*z - z^2 ∧ 0 < 3 + 2*z - z^2 := by
  have h : z^2 < 1 := by
    nlinarith [mul_pos (sub_pos.mpr hz.2) (by linarith only [hz.1] : 0 < 1+z)]
  exact ⟨h, by nlinarith only [hz.2, h], by nlinarith only [hz.1, h]⟩

theorem weight_hasDerivAt (z : ℝ) : HasDerivAt weight (weightFirst z) z := by
  have hd : 3 + z^2 ≠ 0 := ne_of_gt (by positivity)
  convert! ((((hasDerivAt_id z).pow 2).const_sub 1).pow 2 |>.const_mul 36).div
    (((hasDerivAt_id z).pow 2).const_add 3) hd using 1 <;>
    first | rfl | (dsimp [weight, weightFirst]; field_simp; ring)

theorem weightFirst_hasDerivAt (z : ℝ) : HasDerivAt weightFirst (weightSecond z) z := by
  have hd : (z^2 + 3)^2 ≠ 0 := ne_of_gt (by positivity)
  convert! (((((hasDerivAt_id z).const_mul 72).mul ((hasDerivAt_id z).sub_const 1)).mul
    ((hasDerivAt_id z).add_const 1)).mul (((hasDerivAt_id z).pow 2).add_const 7)).div
    ((((hasDerivAt_id z).pow 2).add_const 3).pow 2) hd using 1 <;>
    first | rfl | (dsimp [weightFirst, weightSecond]; field_simp; ring)

theorem chart_hasDerivAt (z : ℝ) : HasDerivAt chart (chartFirst z) z := by
  have hd : 0 < Real.sqrt (3 + z^2) := Real.sqrt_pos.mpr (by positivity)
  have hs := Real.sq_sqrt (show 0 ≤ 3 + z^2 by positivity)
  have hroot := (((hasDerivAt_id z).pow 2).const_add 3).sqrt (by dsimp; positivity)
  convert! ((hasDerivAt_id z).mul (((hasDerivAt_id z).pow 2).const_sub 9)).div
    (hroot.pow 3) (pow_ne_zero 3 hd.ne') using 1 <;> try rfl
  dsimp [chartFirst]
  field_simp
  ring_nf
  simp only [hs]
  ring

theorem chartFirst_hasDerivAt (z : ℝ) (hz : z ∈ Ioo (-1) 1) :
    HasDerivAt chartFirst (chartLogSecond z * chartFirst z) z := by
  have hd : 0 < Real.sqrt (3 + z^2) := Real.sqrt_pos.mpr (by positivity)
  have hs := Real.sq_sqrt (show 0 ≤ 3 + z^2 by positivity)
  have hz2 := (chart_bounds z hz).1
  have hroot := (((hasDerivAt_id z).pow 2).const_add 3).sqrt (by dsimp; positivity)
  convert! ((((hasDerivAt_id z).pow 2).const_sub 1).const_mul 27).div
    (hroot.pow 5) (pow_ne_zero 5 hd.ne') using 1 <;> try rfl
  dsimp [chartFirst, chartLogSecond]
  field_simp [ne_of_lt (sub_neg.mpr hz2)]
  ring_nf
  simp only [hs]
  ring

theorem chartFirst_pos (z : ℝ) (hz : z ∈ Ioo (-1) 1) : 0 < chartFirst z :=
  div_pos (mul_pos (by norm_num) (sub_pos.mpr (chart_bounds z hz).1))
    (pow_pos (Real.sqrt_pos.mpr (by positivity)) _)

private theorem rpow_three_halves (x : ℝ) (hx : 0 < x) :
    x ^ (3/2 : ℝ) = x * Real.sqrt x := by
  rw [Real.sqrt_eq_rpow, show (3/2 : ℝ) = 1/2 + 1 by norm_num,
    Real.rpow_add_one hx.ne']
  ring

theorem profileSum_pos (z : ℝ) (hz : z ∈ Ioo (-1) 1) : 0 < profileSum z := by
  have h := chart_bounds z hz
  exact add_pos_of_pos_of_nonneg
    (add_pos_of_pos_of_nonneg (Real.rpow_pos_of_pos h.2.1 _)
      (Real.rpow_nonneg (abs_nonneg _) _)) (Real.rpow_nonneg h.2.2.le _)

theorem profileSum_eq (z : ℝ) (hz : z ∈ Ioo 0 1) :
    profileSum z = sumValue z (Real.sqrt (3 - 2*z - z^2)) (Real.sqrt (4*z))
      (Real.sqrt (3 + 2*z - z^2)) := by
  have h := chart_bounds z ⟨by linarith [hz.1], hz.2⟩
  have hb : 0 < 4*z := mul_pos (by norm_num) hz.1
  simp only [profileSum, sumValue, Real.rpow_eq_pow, abs_of_pos hb,
    rpow_three_halves _ h.2.1, rpow_three_halves _ h.2.2,
    rpow_three_halves _ hb]

theorem profileSum_hasDerivAt (z : ℝ) (hz : z ∈ Ioo 0 1) :
    HasDerivAt profileSum (positiveFirst z) z := by
  have h := chart_bounds z ⟨by linarith [hz.1], hz.2⟩
  have ha := (((hasDerivAt_id z).const_mul 2).const_sub 3).sub ((hasDerivAt_id z).pow 2)
  have hb := (hasDerivAt_id z).const_mul 4
  have hc := (((hasDerivAt_id z).const_mul 2).const_add 3).sub ((hasDerivAt_id z).pow 2)
  have hd := ((ha.rpow_const (p := (3/2 : ℝ)) (Or.inl h.2.1.ne')).add
    (hb.rpow_const (p := (3/2 : ℝ)) (Or.inl (by dsimp; exact (mul_pos (by norm_num) hz.1).ne')))).add
    (hc.rpow_const (p := (3/2 : ℝ)) (Or.inl h.2.2.ne'))
  have he : (3/2 : ℝ) - 1 = 1/2 := by norm_num
  simp only [he, ← Real.sqrt_eq_rpow] at hd
  have heq : profileSum =ᶠ[𝓝 z] (fun y : ℝ =>
      (3 - 2*y - y^2) ^ (3/2 : ℝ) + (4*y) ^ (3/2 : ℝ) +
        (3 + 2*y - y^2) ^ (3/2 : ℝ)) := by
    filter_upwards [Ioi_mem_nhds hz.1] with y hy
    have hb : 0 < 4*y := mul_pos (by norm_num) hy
    simp [profileSum, Real.rpow_eq_pow, abs_of_pos hb]
  exact (hd.congr_of_eventuallyEq heq).congr_deriv (by dsimp [positiveFirst, sumFirst]; ring)

theorem positiveFirst_hasDerivAt (z : ℝ) (hz : z ∈ Ioo 0 1) :
    HasDerivAt positiveFirst (positiveSecond z) z := by
  have h := chart_bounds z ⟨by linarith [hz.1], hz.2⟩
  have ha := ((((hasDerivAt_id z).const_mul 2).const_sub 3).sub
    ((hasDerivAt_id z).pow 2)).sqrt h.2.1.ne'
  have hbpos : 0 < 4*z := mul_pos (by norm_num) hz.1
  have hb := ((hasDerivAt_id z).const_mul 4).sqrt hbpos.ne'
  have hc := ((((hasDerivAt_id z).const_mul 2).const_add 3).sub
    ((hasDerivAt_id z).pow 2)).sqrt h.2.2.ne'
  have hA := Real.sq_sqrt h.2.1.le
  have hB := Real.sq_sqrt hbpos.le
  have hC := Real.sq_sqrt h.2.2.le
  ring_nf at hA hB hC
  convert! ((((((hasDerivAt_id z).const_mul 2).const_sub (-2)).mul ha).add
    (hb.const_mul 4)).add ((((hasDerivAt_id z).const_mul 2).const_sub 2).mul hc)).const_mul
    (3/2 : ℝ) using 1 <;> try rfl
  dsimp [positiveSecond, sumSecond]
  field_simp [h.2.1.ne', h.2.2.ne', hbpos.ne',
    (Real.sqrt_pos.mpr h.2.1).ne', (Real.sqrt_pos.mpr h.2.2).ne',
    (Real.sqrt_pos.mpr hbpos).ne']
  ring_nf
  simp only [hA, hC]
  have hbn : Real.sqrt (z*4) ≠ 0 := (Real.sqrt_pos.mpr (mul_pos hz.1 (by norm_num))).ne'
  field_simp [hz.1.ne', hbn]
  ring_nf
  simp only [hB]
  ring

theorem chartProfile_hasDerivAt (z : ℝ) (hz : z ∈ Ioo 0 1) :
    HasDerivAt chartProfile
      ((weightFirst z * profileSum z - 4/3 * weight z * positiveFirst z) *
        (profileSum z) ^ (-(7/3 : ℝ))) z := by
  have hs := profileSum_pos z ⟨by linarith [hz.1], hz.2⟩
  have hpow : (profileSum z) ^ (-(4/3 : ℝ)) =
      (profileSum z) ^ (-(7/3 : ℝ)) * profileSum z := by
    convert Real.rpow_add_one hs.ne' (-(7/3 : ℝ)) using 1 <;> norm_num
  have hd := (weight_hasDerivAt z).mul
    ((profileSum_hasDerivAt z hz).rpow_const (p := -(4/3 : ℝ)) (Or.inl hs.ne'))
  exact hd.congr_deriv (by norm_num only at *; rw [hpow]; ring)

theorem profileSlope_hasDerivAt (z : ℝ) (hz : z ∈ Ioo 0 1) :
    HasDerivAt profileSlope
      (curvatureNumerator z (Real.sqrt (3 - 2*z - z^2)) (Real.sqrt (4*z))
        (Real.sqrt (3 + 2*z - z^2)) * (profileSum z) ^ (-(10/3 : ℝ)) /
          (9 * chartFirst z)) z := by
  have hi : z ∈ Ioo (-1) 1 := ⟨by linarith [hz.1], hz.2⟩
  have hs := profileSum_pos z hi
  have ht := chartFirst_pos z hi
  let d (y : ℝ) := (weightFirst y * profileSum y - 4/3 * weight y * positiveFirst y) *
    (profileSum y) ^ (-(7/3 : ℝ)) / chartFirst y
  have heq : profileSlope =ᶠ[𝓝 z] d := by
    filter_upwards [isOpen_Ioo.mem_nhds hz] with y hy
    simp only [profileSlope, (chartProfile_hasDerivAt y hy).deriv, d]
  have hP := weight_hasDerivAt z
  have hS := profileSum_hasDerivAt z hz
  have hd := (((weightFirst_hasDerivAt z).mul hS).sub
    ((hP.const_mul (4/3)).mul (positiveFirst_hasDerivAt z hz))).mul
      (hS.rpow_const (p := -(7/3 : ℝ)) (Or.inl hs.ne')) |>.div
        (chartFirst_hasDerivAt z hi) ht.ne'
  have hpow : (profileSum z) ^ (-(7/3 : ℝ)) =
      (profileSum z) ^ (-(10/3 : ℝ)) * profileSum z := by
    convert Real.rpow_add_one hs.ne' (-(10/3 : ℝ)) using 1 <;> norm_num
  apply (hd.congr_of_eventuallyEq heq).congr_deriv
  dsimp only [Pi.mul_apply, Pi.sub_apply]
  norm_num only
  rw [hpow]
  unfold curvatureNumerator
  rw [← profileSum_eq z hz]
  change _ = (9 * (weightSecond z - chartLogSecond z * weightFirst z) *
      (profileSum z)^2 + (-24*weightFirst z + 12*chartLogSecond z*weight z) *
      profileSum z * positiveFirst z - 12*weight z*profileSum z*positiveSecond z +
      28*weight z*(positiveFirst z)^2) * (profileSum z) ^ (-(10/3 : ℝ)) /
      (9 * chartFirst z)
  field_simp [ht.ne']
  ring

theorem profileSlope_deriv_neg (z : ℝ) (hz : z ∈ Ioo 0 1) :
    deriv profileSlope z < 0 := by
  have hi : z ∈ Ioo (-1) 1 := ⟨by linarith [hz.1], hz.2⟩
  have h := chart_bounds z hi
  rw [(profileSlope_hasDerivAt z hz).deriv]
  exact div_neg_of_neg_of_pos (mul_neg_of_neg_of_pos
    (curvature_numerator_neg z _ _ _ hz.1 hz.2
      (Real.sqrt_pos.mpr h.2.1) (Real.sqrt_nonneg _) (Real.sqrt_pos.mpr h.2.2)
      (Real.sq_sqrt h.2.1.le) (Real.sq_sqrt (by linarith [hz.1]))
      (Real.sq_sqrt h.2.2.le))
    (Real.rpow_pos_of_pos (profileSum_pos z hi) _))
    (mul_pos (by norm_num) (chartFirst_pos z hi))

theorem chartProfile_contDiffOn : ContDiffOn ℝ 1 chartProfile (Ioo (-1) 1) := by
  intro z hz
  have h := chart_bounds z hz
  have ha : ContDiffAt ℝ 1 (fun y : ℝ => 3 - 2*y - y^2) z := by fun_prop
  have hc : ContDiffAt ℝ 1 (fun y : ℝ => 3 + 2*y - y^2) z := by fun_prop
  have hs : ContDiffAt ℝ 1 profileSum z :=
    ((ha.rpow_const_of_ne h.2.1.ne').add middle_term_contDiff.contDiffAt).add
      (hc.rpow_const_of_ne h.2.2.ne')
  have hp : ContDiffAt ℝ 1 weight z := by
    unfold weight
    fun_prop (disch := positivity)
  exact (hp.mul (hs.rpow_const_of_ne (profileSum_pos z hz).ne')).contDiffWithinAt

theorem profileSlope_continuousOn : ContinuousOn profileSlope (Ioo (-1) 1) :=
  (chartProfile_contDiffOn.continuousOn_deriv_of_isOpen isOpen_Ioo (by norm_num)).div
    (fun z hz => (chartFirst_hasDerivAt z hz).continuousAt.continuousWithinAt)
    (fun z hz => (chartFirst_pos z hz).ne')

theorem chartProfile_even (z : ℝ) : chartProfile (-z) = chartProfile z := by
  have ha : 3 - 2*(-z) - (-z)^2 = 3 + 2*z - z^2 := by ring
  have hc : 3 + 2*(-z) - (-z)^2 = 3 - 2*z - z^2 := by ring
  unfold chartProfile weight profileSum
  rw [ha, hc]
  simp only [neg_sq, mul_neg, abs_neg]
  congr 2
  ring

theorem profileSlope_odd (z : ℝ) : profileSlope (-z) = -profileSlope z := by
  have he : (fun y => chartProfile (-y)) = chartProfile := funext chartProfile_even
  have hd := deriv_comp_neg chartProfile z
  rw [he] at hd
  unfold profileSlope chartFirst
  simp only [neg_sq]
  rw [hd]
  ring

theorem profileSlope_antitoneOn : AntitoneOn profileSlope (Ioo (-1) 1) := by
  have hp : AntitoneOn profileSlope (Ico 0 1) := by
    apply antitoneOn_of_deriv_nonpos (convex_Ico 0 1)
    · exact profileSlope_continuousOn.mono (by
        intro z hz; exact ⟨by linarith only [hz.1], hz.2⟩)
    · rw [interior_Ico]
      exact fun z hz => (profileSlope_hasDerivAt z hz).differentiableAt.differentiableWithinAt
    · rw [interior_Ico]
      exact fun z hz => (profileSlope_deriv_neg z hz).le
  have h0 : profileSlope 0 = 0 := by
    have h := profileSlope_odd 0
    simp only [neg_zero] at h
    linarith only [h]
  intro x hx y hy hxy
  by_cases hx0 : 0 ≤ x
  · exact hp ⟨hx0, hx.2⟩ ⟨hx0.trans hxy, hy.2⟩ hxy
  by_cases hy0 : y ≤ 0
  · have h := hp (a := -y) ⟨by linarith, by linarith only [hy.1]⟩
      (b := -x) ⟨by linarith, by linarith only [hx.1]⟩ (neg_le_neg hxy)
    simpa only [profileSlope_odd, neg_le_neg_iff] using h
  · have ha := hp (a := 0) ⟨le_refl 0, by norm_num⟩
      (b := -x) ⟨by linarith, by linarith only [hx.1]⟩ (by linarith)
    have hb := hp (a := 0) ⟨le_refl 0, by norm_num⟩
      (b := y) ⟨by linarith, hy.2⟩ (by linarith)
    rw [profileSlope_odd, h0] at ha
    rw [h0] at hb
    linarith only [ha, hb]

theorem chart_strictMonoOn : StrictMonoOn chart (Icc (-1) 1) := by
  apply strictMonoOn_of_deriv_pos (convex_Icc (-1) 1)
    (fun z _ => (chart_hasDerivAt z).continuousAt.continuousWithinAt)
  simp only [interior_Icc]
  intro z hz
  rw [(chart_hasDerivAt z).deriv]
  exact chartFirst_pos z hz

theorem chart_image : chart '' Ioo (-1) 1 = Ioo (-1) 1 := by
  have h := ContinuousOn.image_Ioo_of_strictMonoOn (by norm_num : (-1:ℝ) ≤ 1)
    (fun z _ => (chart_hasDerivAt z).continuousAt.continuousWithinAt) chart_strictMonoOn
  norm_num [chart] at h ⊢
  exact h

theorem chart_secant (x y : ℝ) (hx : x ∈ Ioo (-1) 1) (hy : y ∈ Ioo (-1) 1)
    (hxy : x < y) : ∃ c ∈ Ioo x y,
      (chartProfile y - chartProfile x) / (chart y - chart x) = profileSlope c := by
  have hsub : Icc x y ⊆ Ioo (-1) 1 := fun z hz =>
    ⟨hx.1.trans_le hz.1, hz.2.trans_lt hy.2⟩
  have hdiff := chartProfile_contDiffOn.differentiableOn (by norm_num)
  obtain ⟨c, hc, he⟩ := exists_ratio_hasDerivAt_eq_ratio_slope chartProfile
    (deriv chartProfile) hxy (chartProfile_contDiffOn.continuousOn.mono hsub)
    (fun z hz => (hdiff.differentiableAt
      (isOpen_Ioo.mem_nhds (hsub ⟨hz.1.le, hz.2.le⟩))).hasDerivAt)
    chart chartFirst (fun z _ => (chart_hasDerivAt z).continuousAt.continuousWithinAt)
    (fun z _ => chart_hasDerivAt z)
  refine ⟨c, hc, ?_⟩
  have hθ := chart_strictMonoOn ⟨hx.1.le, hx.2.le⟩ ⟨hy.1.le, hy.2.le⟩ hxy
  have ht := chartFirst_pos c (hsub ⟨hc.1.le, hc.2.le⟩)
  apply (div_eq_div_iff (sub_pos.mpr hθ).ne' ht.ne').mpr
  linarith only [he]

theorem profile32_concave : ConcaveOn ℝ (Ioo (-1) 1) profile32 := by
  apply concaveOn_of_slope_anti_adjacent (convex_Ioo (-1) 1)
  intro t u v ht hv htu huv
  have hu : u ∈ Ioo (-1) 1 := ⟨ht.1.trans htu, huv.trans hv.2⟩
  obtain ⟨x, hx, rfl⟩ := show t ∈ chart '' Ioo (-1) 1 from by rw [chart_image]; exact ht
  obtain ⟨y, hy, rfl⟩ := show u ∈ chart '' Ioo (-1) 1 from by rw [chart_image]; exact hu
  obtain ⟨z, hz, rfl⟩ := show v ∈ chart '' Ioo (-1) 1 from by rw [chart_image]; exact hv
  have hm : StrictMonoOn chart (Ioo (-1) 1) := chart_strictMonoOn.mono Ioo_subset_Icc_self
  have hxy := (hm.lt_iff_lt hx hy).mp htu
  have hyz := (hm.lt_iff_lt hy hz).mp huv
  obtain ⟨a, ha, hea⟩ := chart_secant x y hx hy hxy
  obtain ⟨b, hb, heb⟩ := chart_secant y z hy hz hyz
  rw [profile32_chart x hx, profile32_chart y hy, profile32_chart z hz]
  change (chartProfile z - chartProfile y) / (chart z - chart y) ≤
    (chartProfile y - chartProfile x) / (chart y - chart x)
  rw [hea, heb]
  exact profileSlope_antitoneOn ⟨hx.1.trans ha.1, ha.2.trans hy.2⟩
    ⟨hy.1.trans hb.1, hb.2.trans hz.2⟩ (ha.2.trans hb.1).le

#print axioms weight_hasDerivAt
#print axioms weightFirst_hasDerivAt
#print axioms chart_hasDerivAt
#print axioms chartFirst_hasDerivAt
#print axioms profileSum_hasDerivAt
#print axioms positiveFirst_hasDerivAt
#print axioms chartProfile_hasDerivAt
#print axioms profileSlope_hasDerivAt
#print axioms profileSlope_deriv_neg
#print axioms chartProfile_contDiffOn
#print axioms profileSlope_continuousOn
#print axioms chartProfile_even
#print axioms profileSlope_odd
#print axioms profileSlope_antitoneOn
#print axioms chart_strictMonoOn
#print axioms chart_image
#print axioms chart_secant
#print axioms profile32_concave

end D5.S3.Analytic.SeriesInequalities.Profile32Concavity
