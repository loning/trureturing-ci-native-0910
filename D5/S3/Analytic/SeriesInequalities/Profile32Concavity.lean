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

end D5.S3.Analytic.SeriesInequalities.Profile32Concavity
/- GID: D5/S3/Analytic/SeriesInequalities/Profile32Concavity
   generality: G
   mirror-B: D5/B/S3/Analytic/SeriesInequalities/Profile32Concavity
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: An algebraic sign estimate for the cubic profile curvature. -/
