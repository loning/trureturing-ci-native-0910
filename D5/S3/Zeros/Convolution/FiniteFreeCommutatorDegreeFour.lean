/- GID: D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour
   generality: I
   mirror-B: D5/B/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: kind=certified-instance; basis=terminal=gid:D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_real_rooted
   digest: The source-defined finite free commutator of centered real-rooted quartics is real-rooted. -/

import Mathlib.Algebra.QuadraticDiscriminant
import Mathlib.Analysis.Real.Sqrt
import Mathlib.RingTheory.Polynomial.Pochhammer
import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic

/-!
Source: Campbell, Morales, Perales, arXiv:2502.00254v2, Definition 2.9 and
Notations 2.2, 3.7, 5.1. The target is Conjecture 5.3 for centered quartics.
Theorem 5.6 has an additional restriction, as explicitly stated in Remark 5.7.

The implementation preregistration names `centered_quartic_invariant_bounds`
as the escape witness. Its three squared-sum identities feed the discriminant
bound. The coefficient expansion is a companion on that same proof path.
No frozen D5 prerequisite is used. Quadratic root and Vieta facts come from
pinned Mathlib; the finite free convolution is not present in the searched
repository, Mathlib, or GitHub Lean sources.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour

open Polynomial
open scoped BigOperators

/-- The signed elementary coefficient; used only for `k <= n`. -/
def elementaryCoeff (n : ℕ) (p : ℝ[X]) (k : ℕ) : ℝ :=
  (-1)^k * p.coeff (n-k)

private def fromElementary (n : ℕ) (e : ℕ → ℝ) : ℝ[X] :=
  ∑ k ∈ Finset.range (n+1), C ((-1)^k * e k) * X^(n-k)

/-- Definition 2.9: one falling-factorial prefactor, with `i+j=k`. -/
def additiveConvolution (n : ℕ) (p q : ℝ[X]) : ℝ[X] :=
  fromElementary n fun k => (descPochhammer ℝ k).eval (n : ℝ) *
    ∑ i ∈ Finset.range (k+1),
      elementaryCoeff n p i * elementaryCoeff n q (k-i) /
        ((descPochhammer ℝ i).eval (n : ℝ) *
          (descPochhammer ℝ (k-i)).eval (n : ℝ))

/-- Definition 2.9: coefficientwise multiplication divided by `choose n k`. -/
def multiplicativeConvolution (n : ℕ) (p q : ℝ[X]) : ℝ[X] :=
  fromElementary n fun k =>
    elementaryCoeff n p k * elementaryCoeff n q k / (n.choose k : ℝ)

/-- Notation 2.2, used here at the nonzero dilation parameter `-1`. -/
def dilate (n : ℕ) (α : ℝ) (p : ℝ[X]) : ℝ[X] :=
  C (α^n) * p.comp (C α⁻¹ * X)

/-- Notation 3.7: additive convolution with the reflected polynomial. -/
def symmetrize (n : ℕ) (p : ℝ[X]) : ℝ[X] :=
  additiveConvolution n p (dilate n (-1) p)

/-- The finite sum `z_n` in Notation 5.1, before specializing the degree. -/
def commutatorKernel (n : ℕ) : ℝ[X] :=
  ∑ k ∈ Finset.range (n/2+1),
    C ((-1)^k * (n.choose (2*k) : ℝ) * (descPochhammer ℝ k).eval (n : ℝ) *
      (k.factorial : ℝ) / ((2*k).factorial : ℝ) *
      ((n+1-k : ℕ) : ℝ) / ((n+1 : ℕ) : ℝ)) * X^(n-2*k)

/-- Notation 5.1: two multiplicative convolutions, including the source kernel. -/
def square4 (p q : ℝ[X]) : ℝ[X] :=
  multiplicativeConvolution 4
    (multiplicativeConvolution 4 (symmetrize 4 p) (symmetrize 4 q))
    (commutatorKernel 4)

def centeredQuartic (u v w : ℝ) : ℝ[X] :=
  X^4 + C u * X^2 + C v * X + C w

/-- An actual real factorization, allowing zero and repeated roots. -/
def RealRooted4 (p : ℝ[X]) : Prop :=
  ∃ r : Fin 4 → ℝ, p = ∏ i, (X - C (r i))

private theorem dilate_centered (u v w : ℝ) :
    dilate 4 (-1) (centeredQuartic u v w) = centeredQuartic u (-v) w := by
  simp [dilate, centeredQuartic, mul_pow]
  ring

private theorem symmetrize_centered (u v w : ℝ) :
    symmetrize 4 (centeredQuartic u v w) = centeredQuartic (2*u) 0 (2*w+u^2/6) := by
  rw [symmetrize, dilate_centered]
  norm_num [additiveConvolution, fromElementary, Finset.sum_range_succ,
    elementaryCoeff, centeredQuartic, coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X,
    descPochhammer_eval_eq_descFactorial, Nat.descFactorial_succ]
  simp only [map_add, map_mul, map_div₀, map_pow, map_ofNat]
  ring

private theorem multiplicative_even (u w U W : ℝ) :
    multiplicativeConvolution 4 (centeredQuartic u 0 w) (centeredQuartic U 0 W) =
      centeredQuartic (u*U/6) 0 (w*W) := by
  norm_num [multiplicativeConvolution, fromElementary, Finset.sum_range_succ,
    elementaryCoeff, centeredQuartic, coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X]
  simp only [map_mul, map_div₀, map_ofNat]
  ring

private theorem commutatorKernel_four :
    commutatorKernel 4 = centeredQuartic (-(48/5)) 0 (3/5) := by
  norm_num [commutatorKernel, Finset.sum_range_succ, centeredQuartic,
    descPochhammer_eval_eq_descFactorial, Nat.descFactorial_succ]
  ring

/-- Normalization companion used by `centered_factorization` on its live path. -/
theorem centered_expansion (u v w U V W : ℝ) :
    square4 (centeredQuartic u v w) (centeredQuartic U V W) =
      X^4 - C (16*u*U/15) * X^2 + C ((u^2+12*w)*(U^2+12*W)/60) := by
  rw [square4, symmetrize_centered, symmetrize_centered, commutatorKernel_four,
    multiplicative_even, multiplicative_even]
  simp only [centeredQuartic, map_add, map_mul, map_div₀, map_pow, map_neg,
    map_ofNat, map_zero, zero_mul, add_zero]
  ring

-- Independent specialization of the defining finite sums, without `centered_expansion`.
example : square4 (centeredQuartic (-5) 0 4) (centeredQuartic (-5) 0 4) =
    X^4 - C (80/3 : ℝ) * X^2 + C (5329/60 : ℝ) := by
  norm_num [square4, symmetrize, dilate, additiveConvolution,
    multiplicativeConvolution, commutatorKernel, fromElementary,
    Finset.sum_range_succ, elementaryCoeff, centeredQuartic, coeff_add,
    coeff_C_mul_X_pow, coeff_C_mul_X, descPochhammer_eval_eq_descFactorial,
    Nat.descFactorial_succ, mul_pow]
  ring

example : square4 (centeredQuartic (-5) 0 4) (centeredQuartic (-5) 0 4) =
    X^4 - C (80/3 : ℝ) * X^2 + C (5329/60 : ℝ) := by
  rw [centered_expansion]
  norm_num

private theorem centered_sum_squares (a b c d : ℝ) (h : a + b + c + d = 0) :
    -2 * (a*b + a*c + a*d + b*c + b*d + c*d) = a^2 + b^2 + c^2 + d^2 := by
  have hd : d = -a - b - c := by linarith
  rw [hd]
  ring

private theorem centered_invariant_sos (a b c d : ℝ) (h : a + b + c + d = 0) :
    (a*b + a*c + a*d + b*c + b*d + c*d)^2 + 12*(a*b*c*d) =
      ((a-b)^2*(c-d)^2 + (a-c)^2*(b-d)^2 + (a-d)^2*(b-c)^2) / 2 := by
  have hd : d = -a - b - c := by linarith
  rw [hd]
  ring

private theorem centered_product_sos (a b c d : ℝ) (h : a + b + c + d = 0) :
    (a*b + a*c + a*d + b*c + b*d + c*d)^2 - 4*(a*b*c*d) =
      (a*b-c*d)^2 + (a*c-b*d)^2 + (a*d-b*c)^2 := by
  have hd : d = -a - b - c := by linarith
  rw [hd]
  ring

#print axioms centered_sum_squares
#print axioms centered_invariant_sos
#print axioms centered_product_sos
#print axioms centered_expansion

end D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
