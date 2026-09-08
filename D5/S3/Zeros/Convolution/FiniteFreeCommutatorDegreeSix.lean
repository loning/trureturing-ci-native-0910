/- GID: D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix
   generality: G
   mirror-B: D5/B/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix
   mirror-E: none(waiver:symbolic-polynomial-factorization)
   anchors: []
   utility: none
   digest: The finite free commutator of two real sextics has six real roots. -/

import D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
import D5.S3.Zeros.CoefficientBounds.SexticDiscriminant
import Mathlib.Algebra.CubicDiscriminant

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeSix

open Polynomial FiniteFreeCommutatorDegreeFour
open scoped BigOperators

def RealRooted6 (p : ℝ[X]) : Prop :=
  ∃ r : Fin 6 → ℝ, p = ∏ i, (X - C (r i))

def square6 (p q : ℝ[X]) : ℝ[X] :=
  multiplicativeConvolution 6
    (multiplicativeConvolution 6 (symmetrize 6 p) (symmetrize 6 q))
    (commutatorKernel 6)

def centeredSextic (u v w t s : ℝ) : ℝ[X] :=
  X^6 + C u * X^4 + C v * X^3 + C w * X^2 + C t * X + C s

private def sextic (a u v w t s : ℝ) : ℝ[X] :=
  X^6 + C a * X^5 + C u * X^4 + C v * X^3 + C w * X^2 + C t * X + C s

private theorem dilate_sextic (a u v w t s : ℝ) :
    dilate 6 (-1) (sextic a u v w t s) = sextic (-a) u (-v) w (-t) s := by
  simp [dilate, sextic]
  ring

private theorem symmetrize_sextic (a u v w t s : ℝ) :
    symmetrize 6 (sextic a u v w t s) =
      centeredSextic (2*u-5*a^2/6) 0 (2*w-a*v+2*u^2/5) 0
        (2*s-a*t/3+2*u*w/15-v^2/20) := by
  rw [symmetrize, dilate_sextic]
  change (∑ k ∈ Finset.range (6+1),
    C ((-1)^k * ((descPochhammer ℝ k).eval 6 *
      ∑ i ∈ Finset.range (k+1),
        elementaryCoeff 6 (sextic a u v w t s) i *
          elementaryCoeff 6 (sextic (-a) u (-v) w (-t) s) (k-i) /
          ((descPochhammer ℝ i).eval 6 * (descPochhammer ℝ (k-i)).eval 6))) *
      X^(6-k)) = _
  ext j
  norm_num only [Finset.sum_range_succ, Finset.sum_range_zero,
    Nat.reduceAdd, Nat.reduceSub, Nat.reduceMul, elementaryCoeff, sextic,
    centeredSextic, coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X,
    coeff_X, coeff_X_pow, coeff_C, coeff_sum,
    descPochhammer_succ_eval, descPochhammer_zero, eval_one,
    map_zero, map_one, zero_add, add_zero, one_mul, mul_one, mul_zero, zero_mul,
    pow_zero, pow_one, ite_true, ite_false]
  split_ifs <;> first | contradiction | omega | ring

private theorem symmetrize_centered (u v w t s : ℝ) :
    symmetrize 6 (centeredSextic u v w t s) =
      centeredSextic (2*u) 0 (2*w+2*u^2/5) 0 (2*s+2*u*w/15-v^2/20) := by
  simpa [sextic, centeredSextic] using symmetrize_sextic 0 u v w t s

private theorem multiplicative_even (u w s U W S : ℝ) :
    multiplicativeConvolution 6 (centeredSextic u 0 w 0 s)
      (centeredSextic U 0 W 0 S) = centeredSextic (u*U/15) 0 (w*W/15) 0 (s*S) := by
  change (∑ k ∈ Finset.range (6+1), C ((-1)^k *
    (elementaryCoeff 6 (centeredSextic u 0 w 0 s) k *
      elementaryCoeff 6 (centeredSextic U 0 W 0 S) k / (Nat.choose 6 k : ℝ))) *
    X^(6-k)) = _
  ext j
  norm_num [Finset.sum_range_succ, elementaryCoeff, centeredSextic,
    coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X, coeff_X, coeff_X_pow,
    coeff_C, coeff_sum, Nat.choose]

private theorem commutatorKernel_six :
    commutatorKernel 6 = centeredSextic (-(270/7)) 0 (375/14) 0 (-(4/7)) := by
  ext j
  norm_num only [commutatorKernel, Finset.sum_range_succ, Finset.sum_range_zero,
    Nat.reduceAdd, Nat.reduceSub, Nat.reduceMul, Nat.reduceDiv, centeredSextic,
    descPochhammer_succ_eval, descPochhammer_zero, eval_one, Nat.choose,
    coeff_sum, coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X, coeff_X_pow,
    coeff_C, coeff_neg, map_zero, zero_add, add_zero, one_mul, mul_one,
    mul_zero, zero_mul, pow_zero, pow_one, coeff_zero]

/-- Expand Sym, both multiplicative convolutions, and the source kernel z(6). -/
theorem centered_expansion (u v w t s U V W T S : ℝ) :
    square6 (centeredSextic u v w t s) (centeredSextic U V W T S) =
      X^6 - C (24*u*U/35) * X^4 + C (2*(u^2+5*w)*(U^2+5*W)/105) * X^2 -
        C (4*(2*s+2*u*w/15-v^2/20)*(2*S+2*U*W/15-V^2/20)/7) := by
  rw [square6, symmetrize_centered, symmetrize_centered, commutatorKernel_six,
    multiplicative_even, multiplicative_even]
  ext j
  norm_num only [centeredSextic, coeff_add, coeff_sub, coeff_C_mul_X_pow,
    coeff_C_mul_X, coeff_X_pow, coeff_C, map_zero, zero_mul, add_zero, coeff_zero]
  split_ifs <;> first | omega | ring

#print axioms centered_expansion

end D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeSix
