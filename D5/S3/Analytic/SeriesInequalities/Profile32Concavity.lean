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
import Mathlib.Analysis.InnerProductSpace.NormPow
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Tactic

/- The declarations concern universal real inequalities, cubic coordinates, and derivatives.
   They are not bounded enumeration, a checker, a numeric reduction with undischarged
   numeric premises, or a certified finite instance. -/

set_option autoImplicit false

noncomputable section

namespace D5.S3.Analytic.SeriesInequalities.Profile32Concavity

def evenPoly (z : ℝ) : ℝ := 7*z^8 + 42*z^6 + 168*z^4 + 54*z ^ 2 + 81
def oddPoly (z : ℝ) : ℝ := 12*z^7 + 96*z^5 + 684*z^3 + 648*z
def hPoly (z : ℝ) : ℝ := -17*z^8 + 132*z^6 + 762*z^4 + 3780*z ^ 2 + 2511
def rPoly (z : ℝ) : ℝ :=
  3*z^6 + 12*z^5 + 25*z^4 + 64*z^3 + 13*z ^ 2 + 84*z - 9

theorem polynomial_margin (z : ℝ) (hz : 0 ≤ z) (hz1 : z ≤ 1) :
    243 ≤ hPoly z - 3*(3-z)*(3-z ^ 2)*(rPoly z+9) := by
  have h1 : 0 ≤ 1-z := sub_nonneg.mpr hz1
  have h6 : 0 ≤ 1-z^6 := sub_nonneg.mpr (pow_le_one₀ hz hz1)
  have h7 : 0 ≤ 1-z^7 := sub_nonneg.mpr (pow_le_one₀ hz hz1)
  have hid : hPoly z - 3*(3-z)*(3-z ^ 2)*(rPoly z+9) =
      243 + 2268*(1-z) + 3295*z ^ 2 + 855*z ^ 2*(1-z) +
      26*z ^ 2*(1-z^6) + 9*z ^ 2*(1-z^7) + 528*z^4 +
      438*z^5 + 192*z^6 + 60*z^7 := by
    unfold hPoly rPoly
    ring
  rw [hid]
  have : 0 ≤ 2268*(1-z) + 3295*z ^ 2 + 855*z ^ 2*(1-z) +
      26*z ^ 2*(1-z^6) + 9*z ^ 2*(1-z^7) + 528*z^4 +
      438*z^5 + 192*z^6 + 60*z^7 := by positivity
  linarith only [this]

theorem radical_margin (z A C : ℝ) (hz : 0 ≤ z) (hz1 : z ≤ 1)
    (hA : 0 ≤ A) (hC : 0 ≤ C)
    (hAsq : A ^ 2 = 3 - 2 * z - z ^ 2) (hCsq : C ^ 2 = 3 + 2 * z - z ^ 2) :
    243 ≤ hPoly z - 3*(3-z)*A*C*rPoly z := by
  have hAC : A*C ≤ 3-z ^ 2 := by nlinarith only [sq_nonneg (A-C), hAsq, hCsq]
  have hac0 : 0 ≤ A*C := mul_nonneg hA hC
  have h3 : 0 ≤ 3-z := by linarith only [hz1]
  have hr : 0 ≤ rPoly z+9 := by unfold rPoly; ring_nf; positivity
  have hmul : A*C*rPoly z ≤ (3-z ^ 2)*(rPoly z+9) := calc
    A*C*rPoly z ≤ A*C*(rPoly z+9) :=
      mul_le_mul_of_nonneg_left (by linarith) hac0
    _ ≤ (3-z ^ 2)*(rPoly z+9) := mul_le_mul_of_nonneg_right hAC hr
  have hscaled := mul_le_mul_of_nonneg_left hmul (mul_nonneg (by norm_num : (0:ℝ) ≤ 3) h3)
  have hmargin := polynomial_margin z hz hz1
  nlinarith only [hscaled, hmargin]

def signKernel (z A B C : ℝ) : ℝ :=
  A*C*((1+z)*B*((A+C)*evenPoly z+(C-A)*oddPoly z) +
    z*((1+z)*hPoly z-3*(3-z)*A*C*rPoly z))

theorem sign_kernel_pos (z A B C : ℝ) (hz : 0 < z) (hz1 : z < 1)
    (hA : 0 < A) (hB : 0 ≤ B) (hC : 0 < C)
    (hAsq : A ^ 2 = 3 - 2 * z - z ^ 2) (hCsq : C ^ 2 = 3 + 2 * z - z ^ 2) :
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

def weight (z : ℝ) : ℝ := 36 * (1 - z ^ 2)^2 / (3 + z ^ 2)
def weightFirst (z : ℝ) : ℝ :=
  72 * z * (z - 1) * (z + 1) * (z ^ 2 + 7) / (z ^ 2 + 3)^2
def weightSecond (z : ℝ) : ℝ :=
  72 * (z^6 + 9*z^4 + 75*z ^ 2 - 21) / (z ^ 2 + 3)^3
def chartLogSecond (z : ℝ) : ℝ :=
  -z * (3*z ^ 2 - 11) / ((z ^ 2 - 1) * (z ^ 2 + 3))
def sumValue (z A B C : ℝ) : ℝ :=
  (3 - 2 * z - z ^ 2)*A + 4 * z*B + (3 + 2 * z - z ^ 2)*C
def sumFirst (z A B C : ℝ) : ℝ :=
  3 / 2 * ((-2 - 2 * z)*A + 4*B + (2 - 2 * z)*C)
def sumSecond (z A B C : ℝ) : ℝ :=
  3 * (-A - C + (1+z)^2*A/(3 - 2 * z - z ^ 2) +
    4*B/(4 * z) + (1-z)^2*C/(3 + 2 * z - z ^ 2))
def curvatureNumerator (z A B C : ℝ) : ℝ :=
  9 * (weightSecond z - chartLogSecond z * weightFirst z) * (sumValue z A B C)^2 +
  (-24*weightFirst z + 12*chartLogSecond z*weight z) *
    sumValue z A B C * sumFirst z A B C -
  12 * weight z * sumValue z A B C * sumSecond z A B C +
  28 * weight z * (sumFirst z A B C)^2

set_option maxRecDepth 4096 in
theorem curvature_numerator_eq (z A B C : ℝ) (hz : 0 < z) (hz1 : z < 1)
    (hAsq : A ^ 2 = 3 - 2 * z - z ^ 2) (hBsq : B ^ 2 = 4 * z)
    (hCsq : C ^ 2 = 3 + 2 * z - z ^ 2) :
    curvatureNumerator z A B C =
      -1296 * (1-z) * signKernel z A B C / (z * (9-z ^ 2) * (z ^ 2+3)^3) := by
  have hz2 : z ^ 2 < 1 := by nlinarith [mul_pos hz (sub_pos.mpr hz1)]
  have ha : 0 < 3 - 2 * z - z ^ 2 := by nlinarith only [hz1, hz2]
  have hc : 0 < 3 + 2 * z - z ^ 2 := by nlinarith only [hz, hz2]
  have hd : 0 < z ^ 2 + 3 := by positivity
  have he : 0 < 9-z ^ 2 := by linarith only [hz2]
  have hna : 3 - z*2 - z ^ 2 ≠ 0 := by nlinarith only [ha]
  have hnc : 3 + z*2 - z ^ 2 ≠ 0 := by nlinarith only [hc]
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
    (hAsq : A ^ 2 = 3 - 2 * z - z ^ 2) (hBsq : B ^ 2 = 4 * z)
    (hCsq : C ^ 2 = 3 + 2 * z - z ^ 2) :
    curvatureNumerator z A B C < 0 := by
  rw [curvature_numerator_eq z A B C hz hz1 hAsq hBsq hCsq]
  have hk := sign_kernel_pos z A B C hz hz1 hA hB hC hAsq hCsq
  have hz2 : z ^ 2 < 1 := by nlinarith [mul_pos hz (sub_pos.mpr hz1)]
  apply div_neg_of_neg_of_pos
  · exact mul_neg_of_neg_of_pos (mul_neg_of_neg_of_pos (by norm_num)
      (sub_pos.mpr hz1)) hk
  · exact mul_pos (mul_pos hz (by linarith only [hz2])) (by positivity)

#print axioms curvature_numerator_eq
#print axioms curvature_numerator_neg

open Polynomial
open scoped BigOperators

noncomputable def cubic (a b : ℝ) : ℝ[X] := X^3 + C a * X + C b

noncomputable def phi32 (f : ℝ[X]) : ℝ :=
  ∑ x ∈ f.roots.toFinset,
    Real.rpow |∑ y ∈ (f.roots.toFinset.erase x), (x - y)⁻¹| (3 / 2 : ℝ)

noncomputable def profile32 (t : ℝ) : ℝ :=
  Real.rpow (phi32 (cubic (-3) (2*t))) (-(4 / 3 : ℝ))

def chart (z : ℝ) : ℝ := z * (9 - z ^ 2) / (Real.sqrt (3 + z ^ 2))^3
def leftRoot (z : ℝ) : ℝ := (-z - 3) / Real.sqrt (3 + z ^ 2)
def middleRoot (z : ℝ) : ℝ := 2 * z / Real.sqrt (3 + z ^ 2)
def rightRoot (z : ℝ) : ℝ := (3-z) / Real.sqrt (3 + z ^ 2)

theorem cubic_chart_factor (z : ℝ) :
    cubic (-3) (2*chart z) =
      (X - C (leftRoot z)) * (X - C (middleRoot z)) * (X - C (rightRoot z)) := by
  have hd : 0 < Real.sqrt (3 + z ^ 2) := Real.sqrt_pos.mpr (by positivity)
  have hs : (Real.sqrt (3 + z ^ 2))^2 = 3 + z ^ 2 := Real.sq_sqrt (by positivity)
  apply Polynomial.funext
  intro x
  simp only [cubic, chart, leftRoot, middleRoot, rightRoot,
    Polynomial.eval_add, Polynomial.eval_mul, Polynomial.eval_pow,
    Polynomial.eval_X, Polynomial.eval_C, Polynomial.eval_sub]
  field_simp [hd.ne']
  linear_combination -3*x*Real.sqrt (3 + z ^ 2) * hs

theorem chart_root_order (z : ℝ) (hz : z ∈ Set.Ioo (-1) 1) :
    leftRoot z < middleRoot z ∧ middleRoot z < rightRoot z := by
  have hd : 0 < Real.sqrt (3 + z ^ 2) := Real.sqrt_pos.mpr (by positivity)
  constructor
  · unfold leftRoot middleRoot
    exact (div_lt_div_iff_of_pos_right hd).mpr (by linarith only [hz.1])
  · unfold middleRoot rightRoot
    exact (div_lt_div_iff_of_pos_right hd).mpr (by linarith only [hz.2])

theorem roots_product (u v w : ℝ) :
    (((X - C u) * (X - C v) * (X - C w)).roots.toFinset : Finset ℝ) = {u,v,w} := by
  simp [Polynomial.roots_mul, Polynomial.X_sub_C_ne_zero]

theorem phi32_product (u v w : ℝ) (huv : u ≠ v) (huw : u ≠ w) (hvw : v ≠ w) :
    phi32 ((X - C u) * (X - C v) * (X - C w)) =
      Real.rpow |(u-v)⁻¹ + (u-w)⁻¹| (3/2 : ℝ) +
      Real.rpow |(v-u)⁻¹ + (v-w)⁻¹| (3/2 : ℝ) +
      Real.rpow |(w-u)⁻¹ + (w-v)⁻¹| (3/2 : ℝ) := by
  unfold phi32
  rw [roots_product]
  simp [huv, huw, hvw, Ne.symm huv, Ne.symm huw, Ne.symm hvw, add_assoc]

theorem middle_term_contDiff :
    ContDiff ℝ 1 (fun z : ℝ => Real.rpow |4 * z| (3/2 : ℝ)) := by
  have h : ContDiff ℝ 1 (fun z : ℝ => 4 * z) := contDiff_const.mul contDiff_id
  simpa only [Real.norm_eq_abs, Real.rpow_eq_pow] using
    h.norm_rpow (by norm_num : (1:ℝ) < 3/2)

theorem middle_term_hasDerivAt_zero :
    HasDerivAt (fun z : ℝ => Real.rpow |4 * z| (3/2 : ℝ)) 0 0 := by
  have h := (hasDerivAt_abs_rpow (4*(0:ℝ)) (by norm_num : (1:ℝ) < 3/2)).comp 0
    ((hasDerivAt_id (0:ℝ)).const_mul 4)
  simpa [Function.comp_def, Real.rpow_eq_pow] using h

#print axioms cubic_chart_factor
#print axioms chart_root_order
#print axioms roots_product
#print axioms phi32_product
#print axioms middle_term_contDiff
#print axioms middle_term_hasDerivAt_zero

def commonScale (z : ℝ) : ℝ := Real.sqrt (3 + z ^ 2) / (6 * (1-z ^ 2))
def profileSum (z : ℝ) : ℝ :=
  Real.rpow (3 - 2 * z - z ^ 2) (3/2 : ℝ) +
    Real.rpow |4 * z| (3/2 : ℝ) + Real.rpow (3 + 2 * z - z ^ 2) (3/2 : ℝ)

theorem chart_scores (z : ℝ) (hz : z ∈ Set.Ioo (-1) 1) :
    ((leftRoot z-middleRoot z)⁻¹ + (leftRoot z-rightRoot z)⁻¹ =
      -commonScale z*(3 - 2 * z - z ^ 2)) ∧
    ((middleRoot z-leftRoot z)⁻¹ + (middleRoot z-rightRoot z)⁻¹ =
      -commonScale z*(4 * z)) ∧
    ((rightRoot z-leftRoot z)⁻¹ + (rightRoot z-middleRoot z)⁻¹ =
      commonScale z*(3 + 2 * z - z ^ 2)) := by
  have hp : 0 < 1+z := by linarith only [hz.1]
  have hm : 0 < 1-z := sub_pos.mpr hz.2
  have hz2 : z ^ 2 < 1 := by nlinarith [mul_pos hp hm]
  have hd : 0 < Real.sqrt (3 + z ^ 2) := Real.sqrt_pos.mpr (by positivity)
  have h1 : leftRoot z-middleRoot z = -3*(1+z)/Real.sqrt (3+z ^ 2) := by
    unfold leftRoot middleRoot; ring
  have h2 : leftRoot z-rightRoot z = -6/Real.sqrt (3+z ^ 2) := by
    unfold leftRoot rightRoot; ring
  have h3 : middleRoot z-leftRoot z = 3*(1+z)/Real.sqrt (3+z ^ 2) := by
    unfold leftRoot middleRoot; ring
  have h4 : middleRoot z-rightRoot z = -3*(1-z)/Real.sqrt (3+z ^ 2) := by
    unfold middleRoot rightRoot; ring
  have h5 : rightRoot z-leftRoot z = 6/Real.sqrt (3+z ^ 2) := by
    unfold leftRoot rightRoot; ring
  have h6 : rightRoot z-middleRoot z = 3*(1-z)/Real.sqrt (3+z ^ 2) := by
    unfold middleRoot rightRoot; ring
  rw [h1, h2, h3, h4, h5, h6]
  unfold commonScale
  refine ⟨?_, ?_, ?_⟩ <;>
    field_simp [hp.ne', hm.ne', hd.ne', (sub_pos.mpr hz2).ne'] <;> ring

theorem profile32_chart (z : ℝ) (hz : z ∈ Set.Ioo (-1) 1) :
    profile32 (chart z) = weight z * Real.rpow (profileSum z) (-(4/3 : ℝ)) := by
  have hp : 0 < 1+z := by linarith only [hz.1]
  have hm : 0 < 1-z := sub_pos.mpr hz.2
  have hz2 : z ^ 2 < 1 := by nlinarith [mul_pos hp hm]
  have ha : 0 < 3 - 2 * z - z ^ 2 := by nlinarith only [hz.2, hz2]
  have hc : 0 < 3 + 2 * z - z ^ 2 := by nlinarith only [hz.1, hz2]
  have hk : 0 < commonScale z := by
    unfold commonScale
    exact div_pos (Real.sqrt_pos.mpr (by positivity))
      (mul_pos (by norm_num) (sub_pos.mpr hz2))
  have hs : 0 ≤ profileSum z := by
    unfold profileSum
    simp only [Real.rpow_eq_pow]
    positivity
  have hord := chart_root_order z hz
  have hsc := chart_scores z hz
  rw [profile32, cubic_chart_factor, phi32_product _ _ _ hord.1.ne
    (hord.1.trans hord.2).ne hord.2.ne, hsc.1, hsc.2.1, hsc.2.2]
  simp only [Real.rpow_eq_pow, abs_mul, abs_neg, abs_of_pos hk, abs_of_pos ha, abs_of_pos hc]
  rw [← abs_mul (4:ℝ) z]
  rw [Real.mul_rpow hk.le ha.le, Real.mul_rpow hk.le (abs_nonneg (4 * z)),
    Real.mul_rpow hk.le hc.le, ← mul_add, ← mul_add]
  change (commonScale z ^ (3/2 : ℝ) * profileSum z) ^ (-(4/3 : ℝ)) =
    weight z * profileSum z ^ (-(4/3 : ℝ))
  rw [Real.mul_rpow (Real.rpow_nonneg hk.le _) hs, ← Real.rpow_mul hk.le]
  have hexp : (3/2 : ℝ) * (-(4/3 : ℝ)) = -(2:ℝ) := by norm_num
  rw [hexp]
  congr 1
  rw [Real.rpow_neg hk.le, Real.rpow_two]
  unfold commonScale weight
  have hd : (Real.sqrt (3+z ^ 2))^2 = 3+z ^ 2 := Real.sq_sqrt (by positivity)
  field_simp
  nlinarith only [hd]

#print axioms chart_scores
#print axioms profile32_chart

end D5.S3.Analytic.SeriesInequalities.Profile32Concavity
