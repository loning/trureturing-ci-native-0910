/- GID: D5/S3/Analytic/SeriesInequalities/Profile32Concavity
   generality: G
   mirror-B: D5/B/S3/Analytic/SeriesInequalities/Profile32Concavity
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: An algebraic sign estimate for the cubic profile curvature. -/

import Mathlib.Analysis.Convex.Deriv
import Mathlib.Analysis.Convex.SpecificFunctions.Pow
import Mathlib.Analysis.SpecialFunctions.Pow.Deriv
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Tactic

/- Development of the requested concavity theorem; not yet deposited.
   All current declarations concern universal real polynomial or radical inequalities.
   They are not bounded enumeration, a checker, a numeric reduction with undischarged
   numeric premises, or a certified finite instance. -/

set_option autoImplicit false

noncomputable section

namespace D5.S3.Analytic.SeriesInequalities.Profile32Concavity

def evenPoly (z : ℝ) : ℝ := 7*z^8 + 42*z^6 + 168*z^4 + 54*z^2 + 81
def oddPoly (z : ℝ) : ℝ := 12*z^7 + 96*z^5 + 684*z^3 + 648*z
def hPoly (z : ℝ) : ℝ := -17*z^8 + 132*z^6 + 762*z^4 + 3780*z^2 + 2511
def rPoly (z : ℝ) : ℝ :=
  3*z^6 + 12*z^5 + 25*z^4 + 64*z^3 + 13*z^2 + 84*z - 9

theorem polynomial_margin (z : ℝ) (hz : 0 ≤ z) (hz1 : z ≤ 1) :
    243 ≤ hPoly z - 3*(3-z)*(3-z^2)*(rPoly z+9) := by
  have h1 : 0 ≤ 1-z := sub_nonneg.mpr hz1
  have h6 : 0 ≤ 1-z^6 := sub_nonneg.mpr (pow_le_one₀ hz hz1)
  have h7 : 0 ≤ 1-z^7 := sub_nonneg.mpr (pow_le_one₀ hz hz1)
  have hid : hPoly z - 3*(3-z)*(3-z^2)*(rPoly z+9) =
      243 + 2268*(1-z) + 3295*z^2 + 855*z^2*(1-z) +
      26*z^2*(1-z^6) + 9*z^2*(1-z^7) + 528*z^4 +
      438*z^5 + 192*z^6 + 60*z^7 := by
    unfold hPoly rPoly
    ring
  rw [hid]
  have : 0 ≤ 2268*(1-z) + 3295*z^2 + 855*z^2*(1-z) +
      26*z^2*(1-z^6) + 9*z^2*(1-z^7) + 528*z^4 +
      438*z^5 + 192*z^6 + 60*z^7 := by positivity
  linarith only [this]

theorem radical_margin (z A C : ℝ) (hz : 0 ≤ z) (hz1 : z ≤ 1)
    (hA : 0 ≤ A) (hC : 0 ≤ C)
    (hAsq : A^2 = 3-2*z-z^2) (hCsq : C^2 = 3+2*z-z^2) :
    243 ≤ hPoly z - 3*(3-z)*A*C*rPoly z := by
  have hAC : A*C ≤ 3-z^2 := by nlinarith only [sq_nonneg (A-C), hAsq, hCsq]
  have hac0 : 0 ≤ A*C := mul_nonneg hA hC
  have h3 : 0 ≤ 3-z := by linarith only [hz1]
  have hr : 0 ≤ rPoly z+9 := by unfold rPoly; ring_nf; positivity
  have hmul : A*C*rPoly z ≤ (3-z^2)*(rPoly z+9) := calc
    A*C*rPoly z ≤ A*C*(rPoly z+9) :=
      mul_le_mul_of_nonneg_left (by linarith) hac0
    _ ≤ (3-z^2)*(rPoly z+9) := mul_le_mul_of_nonneg_right hAC hr
  have hscaled := mul_le_mul_of_nonneg_left hmul (mul_nonneg (by norm_num : (0:ℝ) ≤ 3) h3)
  have hmargin := polynomial_margin z hz hz1
  nlinarith only [hscaled, hmargin]

def signKernel (z A B C : ℝ) : ℝ :=
  A*C*((1+z)*B*((A+C)*evenPoly z+(C-A)*oddPoly z) +
    z*((1+z)*hPoly z-3*(3-z)*A*C*rPoly z))

theorem sign_kernel_pos (z A B C : ℝ) (hz : 0 < z) (hz1 : z < 1)
    (hA : 0 < A) (hB : 0 ≤ B) (hC : 0 < C)
    (hAsq : A^2 = 3-2*z-z^2) (hCsq : C^2 = 3+2*z-z^2) :
    0 < signKernel z A B C := by
  have horder : A ≤ C := by nlinarith only [hAsq, hCsq, hA, hC, hz]
  have he : 0 ≤ evenPoly z := by unfold evenPoly; positivity
  have ho : 0 ≤ oddPoly z := by unfold oddPoly; positivity
  have hfirst : 0 ≤ (1+z)*B*((A+C)*evenPoly z+(C-A)*oddPoly z) := by
    apply mul_nonneg (mul_nonneg (by positivity) hB)
    exact add_nonneg (mul_nonneg (by positivity) he)
      (mul_nonneg (sub_nonneg.mpr horder) ho)
  have hmargin := radical_margin z A C hz.le hz1.le hA.le hC.le hAsq hCsq
  have hz8 : z^8 ≤ 1 := pow_le_one₀ hz.le hz1.le
  have hh : 0 ≤ hPoly z := by
    unfold hPoly
    nlinarith only [hz8, pow_nonneg hz.le 6, pow_nonneg hz.le 4, sq_nonneg z]
  have hzh := mul_nonneg hz.le hh
  have hsecond : 0 < z*((1+z)*hPoly z-3*(3-z)*A*C*rPoly z) :=
    mul_pos hz (by nlinarith only [hmargin, hzh])
  unfold signKernel
  exact mul_pos (mul_pos hA hC) (add_pos_of_nonneg_of_pos hfirst hsecond)

#print axioms polynomial_margin
#print axioms radical_margin
#print axioms sign_kernel_pos

def weight (z : ℝ) : ℝ := 36 * (1 - z^2)^2 / (3 + z^2)
def weightFirst (z : ℝ) : ℝ :=
  72 * z * (z - 1) * (z + 1) * (z^2 + 7) / (z^2 + 3)^2
def weightSecond (z : ℝ) : ℝ :=
  72 * (z^6 + 9*z^4 + 75*z^2 - 21) / (z^2 + 3)^3
def chartLogSecond (z : ℝ) : ℝ :=
  -z * (3*z^2 - 11) / ((z^2 - 1) * (z^2 + 3))
def sumValue (z A B C : ℝ) : ℝ :=
  (3 - 2*z - z^2)*A + 4*z*B + (3 + 2*z - z^2)*C
def sumFirst (z A B C : ℝ) : ℝ :=
  3 / 2 * ((-2 - 2*z)*A + 4*B + (2 - 2*z)*C)
def sumSecond (z A B C : ℝ) : ℝ :=
  3 * (-A - C + (1+z)^2*A/(3 - 2*z - z^2) +
    4*B/(4*z) + (1-z)^2*C/(3 + 2*z - z^2))
def curvatureNumerator (z A B C : ℝ) : ℝ :=
  9 * (weightSecond z - chartLogSecond z * weightFirst z) * (sumValue z A B C)^2 +
  (-24*weightFirst z + 12*chartLogSecond z*weight z) *
    sumValue z A B C * sumFirst z A B C -
  12 * weight z * sumValue z A B C * sumSecond z A B C +
  28 * weight z * (sumFirst z A B C)^2

set_option maxRecDepth 4096 in
theorem curvature_numerator_eq (z A B C : ℝ) (hz : 0 < z) (hz1 : z < 1)
    (hAsq : A^2 = 3 - 2*z - z^2) (hBsq : B^2 = 4*z)
    (hCsq : C^2 = 3 + 2*z - z^2) :
    curvatureNumerator z A B C =
      -1296 * (1-z) * signKernel z A B C / (z * (9-z^2) * (z^2+3)^3) := by
  have hz2 : z^2 < 1 := by nlinarith [mul_pos hz (sub_pos.mpr hz1)]
  have ha : 0 < 3 - 2*z - z^2 := by nlinarith only [hz1, hz2]
  have hc : 0 < 3 + 2*z - z^2 := by nlinarith only [hz, hz2]
  have hd : 0 < z^2 + 3 := by positivity
  have he : 0 < 9-z^2 := by linarith only [hz2]
  have hna : 3 - z*2 - z^2 ≠ 0 := by nlinarith only [ha]
  have hnc : 3 + z*2 - z^2 ≠ 0 := by nlinarith only [hc]
  unfold curvatureNumerator weight weightFirst weightSecond chartLogSecond
    sumValue sumFirst sumSecond signKernel evenPoly oddPoly hPoly rPoly
  field_simp [ne_of_gt hz, ne_of_gt ha, ne_of_gt hc, ne_of_gt hd,
    ne_of_gt he, ne_of_lt (sub_neg.mpr hz2)]
  ring_nf
  simp only [hAsq, hBsq, hCsq]
  field_simp [hna, hnc]
  ring

theorem curvature_numerator_neg (z A B C : ℝ) (hz : 0 < z) (hz1 : z < 1)
    (hA : 0 < A) (hB : 0 ≤ B) (hC : 0 < C)
    (hAsq : A^2 = 3 - 2*z - z^2) (hBsq : B^2 = 4*z)
    (hCsq : C^2 = 3 + 2*z - z^2) :
    curvatureNumerator z A B C < 0 := by
  rw [curvature_numerator_eq z A B C hz hz1 hAsq hBsq hCsq]
  have hk := sign_kernel_pos z A B C hz hz1 hA hB hC hAsq hCsq
  have hz2 : z^2 < 1 := by nlinarith [mul_pos hz (sub_pos.mpr hz1)]
  apply div_neg_of_neg_of_pos
  · exact mul_neg_of_neg_of_pos (mul_neg_of_neg_of_pos (by norm_num)
      (sub_pos.mpr hz1)) hk
  · exact mul_pos (mul_pos hz (by linarith only [hz2])) (by positivity)

#print axioms curvature_numerator_eq
#print axioms curvature_numerator_neg

end D5.S3.Analytic.SeriesInequalities.Profile32Concavity
