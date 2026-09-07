/- GID: D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour
   generality: I
   mirror-B: D5/B/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: kind=certified-instance; basis=terminal=gid:D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_real_rooted
   digest: The source-defined finite free commutator of centered real-rooted quartics is real-rooted. -/

import Mathlib.Algebra.QuadraticDiscriminant
import Mathlib.Algebra.Polynomial.BigOperators
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
  simp [dilate, centeredQuartic]
  ring

private theorem symmetrize_centered (u v w : ℝ) :
    symmetrize 4 (centeredQuartic u v w) = centeredQuartic (2*u) 0 (2*w+u^2/6) := by
  rw [symmetrize, dilate_centered]
  ext j
  norm_num only [additiveConvolution, fromElementary, Finset.sum_range_succ,
    Finset.sum_range_zero, Nat.reduceAdd, Nat.reduceSub, Nat.reduceMul,
    elementaryCoeff, centeredQuartic, coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X,
    coeff_X, coeff_X_pow, coeff_C, coeff_sum,
    descPochhammer_succ_eval, descPochhammer_zero, eval_one, Nat.choose,
    map_zero, map_one, zero_add, add_zero, one_mul, mul_one, mul_zero, zero_mul,
    pow_zero, pow_one, ite_true, ite_false]
  split_ifs <;> first | contradiction | omega | ring

private theorem multiplicative_even (u w U W : ℝ) :
    multiplicativeConvolution 4 (centeredQuartic u 0 w) (centeredQuartic U 0 W) =
      centeredQuartic (u*U/6) 0 (w*W) := by
  ext j
  norm_num [multiplicativeConvolution, fromElementary, Finset.sum_range_succ,
    elementaryCoeff, centeredQuartic, coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X,
    coeff_X, coeff_X_pow, coeff_C, coeff_sum, Nat.choose]

private theorem commutatorKernel_four :
    commutatorKernel 4 = centeredQuartic (-(48/5)) 0 (3/5) := by
  ext j
  norm_num only [commutatorKernel, Finset.sum_range_succ, Finset.sum_range_zero,
    Nat.reduceAdd, Nat.reduceSub, Nat.reduceMul, Nat.reduceDiv, centeredQuartic,
    descPochhammer_succ_eval, descPochhammer_zero, eval_one, Nat.choose,
    coeff_sum, coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X, coeff_X_pow,
    coeff_C, coeff_neg, map_zero, zero_add, add_zero, one_mul, mul_one,
    mul_zero, zero_mul, pow_zero, pow_one, coeff_zero]

/-- Normalization companion used by `centered_factorization` on its live path. -/
theorem centered_expansion (u v w U V W : ℝ) :
    square4 (centeredQuartic u v w) (centeredQuartic U V W) =
      X^4 - C (16*u*U/15) * X^2 + C ((u^2+12*w)*(U^2+12*W)/60) := by
  rw [square4, symmetrize_centered, symmetrize_centered, commutatorKernel_four,
    multiplicative_even, multiplicative_even]
  ext j
  norm_num only [centeredQuartic, coeff_add, coeff_sub, coeff_C_mul_X_pow,
    coeff_C_mul_X, coeff_X_pow, coeff_C, map_zero, zero_mul, add_zero, coeff_zero]
  split_ifs <;> first | omega | ring

-- Definition path: specialize Sym, the first product, and z4 separately.
example : square4 (centeredQuartic (-5) 0 4) (centeredQuartic (-5) 0 4) =
    X^4 - C (80/3 : ℝ) * X^2 + C (5329/60 : ℝ) := by
  have hs : symmetrize 4 (centeredQuartic (-5) 0 4) =
      centeredQuartic (-10) 0 (73/6) := by
    rw [symmetrize_centered]
    norm_num
  have hm : multiplicativeConvolution 4
      (centeredQuartic (-10) 0 (73/6)) (centeredQuartic (-10) 0 (73/6)) =
      centeredQuartic (50/3) 0 (5329/36) := by
    rw [multiplicative_even]
    norm_num
  rw [square4, hs, hm, commutatorKernel_four, multiplicative_even]
  norm_num [centeredQuartic]
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

/-- The preregistered escape witness: coefficient bounds from four real roots.
All three squared-sum identities contribute to the later discriminant proof. -/
theorem centered_quartic_invariant_bounds (u v w : ℝ)
    (hp : RealRooted4 (centeredQuartic u v w)) :
    u ≤ 0 ∧ 0 ≤ u^2+12*w ∧ u^2+12*w ≤ 4*u^2 := by
  obtain ⟨r, hr⟩ := hp
  have hc := prod_X_sub_C_coeff_card_pred (Finset.univ : Finset (Fin 4)) r (by decide)
  norm_num only [Finset.card_univ, Fintype.card_fin, Nat.reduceSub] at hc
  rw [← hr] at hc
  norm_num [centeredQuartic, coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X,
    coeff_X_pow, coeff_X, coeff_C, Fin.sum_univ_succ] at hc
  have hcenter : r 0 + r 1 + r 2 + r 3 = 0 := by linarith
  have hu0 := congrArg (fun p : ℝ[X] => p.coeff 2) hr
  have hw0 := congrArg (fun p : ℝ[X] => p.coeff 0) hr
  norm_num [centeredQuartic, Fin.prod_univ_succ, coeff_mul,
    Finset.sum_antidiagonal_eq_sum_range_succ, Finset.sum_range_succ,
    coeff_add, coeff_sub, coeff_X_pow, coeff_X, coeff_C] at hu0 hw0
  have hu : u = r 0*r 1 + r 0*r 2 + r 0*r 3 + r 1*r 2 + r 1*r 3 + r 2*r 3 := by
    nlinarith [hu0]
  have hw : w = r 0*r 1*r 2*r 3 := by nlinarith [hw0]
  have hs := centered_sum_squares (r 0) (r 1) (r 2) (r 3) hcenter
  have hi := centered_invariant_sos (r 0) (r 1) (r 2) (r 3) hcenter
  have hb := centered_product_sos (r 0) (r 1) (r 2) (r 3) hcenter
  rw [← hu] at hs
  rw [← hu, ← hw] at hi hb
  refine ⟨?_, ?_, ?_⟩
  · nlinarith [sq_nonneg (r 0), sq_nonneg (r 1), sq_nonneg (r 2), sq_nonneg (r 3)]
  · rw [hi]
    positivity
  · have hbound : 0 ≤ u^2-4*w := by rw [hb]; positivity
    linarith

#print axioms centered_sum_squares
#print axioms centered_invariant_sos
#print axioms centered_product_sos
#print axioms centered_expansion
#print axioms centered_quartic_invariant_bounds

end D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
