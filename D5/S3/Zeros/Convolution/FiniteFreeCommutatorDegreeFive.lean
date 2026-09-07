/- GID: D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFive
   generality: I
   mirror-B: D5/B/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFive
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: kind=certified-instance; basis=terminal=gid:D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFive.real_rooted
   digest: The source-defined finite free commutator preserves real roots in degree five. -/

import D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
import Mathlib.Analysis.Calculus.LocalExtr.Polynomial
import Mathlib.Data.Fin.Tuple.Sort

/-!
Conjecture 5.3, degree five, of Campbell, Morales and Perales,
arXiv:2502.00254v2. Notation 5.1 uses two multiplicative convolutions and z_n.
Preregistration: docs/reports/r18-quintic-preregistration.md.
The escape witness is exactly w <= 4*u^2/15 for centered real-rooted quintics.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFive

open Polynomial
open scoped BigOperators
open FiniteFreeCommutatorDegreeFour

def centeredQuintic (u v w t : ℝ) : ℝ[X] :=
  X ^ 5 + C u * X ^ 3 + C v * X ^ 2 + C w * X + C t

/-- Five real linear factors, with zero and repeated roots permitted. -/
def RealRooted5 (p : ℝ[X]) : Prop :=
  ∃ r : Fin 5 → ℝ, p = ∏ i, (X - C (r i))

/-- The degree-five instance of the source's Notation 5.1. -/
def square5 (p q : ℝ[X]) : ℝ[X] :=
  multiplicativeConvolution 5
    (multiplicativeConvolution 5 (symmetrize 5 p) (symmetrize 5 q))
    (commutatorKernel 5)

private theorem ordered_moment_bound (a b c d e : ℝ)
    (h : a + b + c + d + e = 0)
    (hab : a ≤ b) (hbc : b ≤ c) (hcd : c ≤ d) (hde : d ≤ e) :
    7 * (a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2 + e ^ 2) ^ 2 ≤
      30 * (a ^ 4 + b ^ 4 + c ^ 4 + d ^ 4 + e ^ 4) := by
  let A := b - a
  let B := c - b
  let C := d - c
  let D := e - d
  have hA : 0 ≤ A := sub_nonneg.mpr hab
  have hB : 0 ≤ B := sub_nonneg.mpr hbc
  have hC : 0 ≤ C := sub_nonneg.mpr hcd
  have hD : 0 ≤ D := sub_nonneg.mpr hde
  have he : e = -a - b - c - d := by linarith only [h]
  -- On the ordered-root cone the sharp quartic has nonnegative gap coefficients.
  have hid :
      30 * (a ^ 4 + b ^ 4 + c ^ 4 + d ^ 4 + e ^ 4) -
        7 * (a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2 + e ^ 2) ^ 2 =
      8 * (A ^ 4 + 3 * A ^ 3 * B + 2 * A ^ 3 * C + A ^ 3 * D +
        3 * A ^ 2 * B ^ 2 + 4 * A ^ 2 * B * C + 2 * A ^ 2 * B * D +
        A ^ 2 * C ^ 2 + A ^ 2 * C * D + A * B * C ^ 2 + A * B * C * D +
        A * B * D ^ 2 + 2 * A * C * D ^ 2 + A * D ^ 3 + B ^ 2 * C ^ 2 +
        B ^ 2 * C * D + B ^ 2 * D ^ 2 + 4 * B * C * D ^ 2 +
        2 * B * D ^ 3 + 3 * C ^ 2 * D ^ 2 + 3 * C * D ^ 3 + D ^ 4) := by
    dsimp [A, B, C, D]
    rw [he]
    ring
  apply sub_nonneg.mp
  rw [hid]
  positivity

/-- The preregistered sharp coefficient estimate. Equality occurs at roots
`(2,2,2,-3,-3)`, so its constant cannot be decreased. -/
theorem centered_quintic_coefficient_bound (u v w t : ℝ)
    (hp : RealRooted5 (centeredQuintic u v w t)) : w ≤ (4 / 15) * u ^ 2 := by
  obtain ⟨r, hr⟩ := hp
  let s := r ∘ Tuple.sort r
  have hs : Monotone s := Tuple.monotone_sort r
  have hprod : centeredQuintic u v w t = ∏ i, (X - C (s i)) := by
    rw [hr]
    exact (Equiv.prod_comp (Tuple.sort r) (fun i => X - C (r i))).symm
  have hc := congrArg (fun p : ℝ[X] => p.coeff 4) hprod
  have hu := congrArg (fun p : ℝ[X] => p.coeff 3) hprod
  have hw := congrArg (fun p : ℝ[X] => p.coeff 1) hprod
  norm_num [centeredQuintic, Fin.prod_univ_succ, coeff_mul,
    Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk, Finset.sum_range_succ,
    coeff_add, coeff_sub, coeff_X_pow, coeff_X, coeff_C, Fin.succ] at hc hu hw
  change 0 = -s 0 + (-s 1 + (-s 2 + (-s 3 + -s 4))) at hc
  change u = -(s 0 * (-s 1 + (-s 2 + (-s 3 + -s 4)))) +
    (-(s 1 * (-s 2 + (-s 3 + -s 4))) + (-(s 2 * (-s 3 + -s 4)) + s 3 * s 4)) at hu
  change w = -(s 0 * (-(s 1 * (-(s 2 * (-s 3 + -s 4)) + s 3 * s 4)) +
    -(s 2 * (s 3 * s 4)))) + s 1 * (s 2 * (s 3 * s 4)) at hw
  have hcenter : s 0 + s 1 + s 2 + s 3 + s 4 = 0 := by linarith only [hc]
  have he : s 4 = -s 0 - s 1 - s 2 - s 3 := by linarith only [hcenter]
  have h2 : s 0 ^ 2 + s 1 ^ 2 + s 2 ^ 2 + s 3 ^ 2 + s 4 ^ 2 = -2 * u := by
    rw [hu, he]
    ring
  have h4 : s 0 ^ 4 + s 1 ^ 4 + s 2 ^ 4 + s 3 ^ 4 + s 4 ^ 4 =
      2 * u ^ 2 - 4 * w := by
    rw [hu, hw, he]
    ring
  have hb := ordered_moment_bound (s 0) (s 1) (s 2) (s 3) (s 4) hcenter
    (hs (by decide)) (hs (by decide)) (hs (by decide)) (hs (by decide))
  rw [h2, h4] at hb
  nlinarith only [hb]

example : RealRooted5 (centeredQuintic (-15) 10 60 (-72)) := by
  refine ⟨![2, 2, 2, -3, -3], ?_⟩
  norm_num [centeredQuintic, Fin.prod_univ_succ, map_ofNat]
  ring

example : (60 : ℝ) = (4 / 15) * (-15) ^ 2 := by norm_num

#print axioms centered_quintic_coefficient_bound

end D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFive
