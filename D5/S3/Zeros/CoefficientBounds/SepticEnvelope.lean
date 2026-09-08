/- GID: D5/S3/Zeros/CoefficientBounds/SepticEnvelope
   generality: G
   mirror-B: D5/B/S3/Zeros/CoefficientBounds/SepticEnvelope
   mirror-E: none(waiver:symbolic-polynomial-inequalities)
   anchors: []
   utility: none
   digest: Coefficient inequalities for arbitrary centered real-rooted septics. -/

import Mathlib.Tactic
import Mathlib.Algebra.Polynomial.BigOperators

/-!
All declarations quantify over arbitrary real root maps or real gap variables.
They are algebraic identities and inequalities, with no bounded enumeration,
checker, numerical premise, or certified finite instance. Thus utility is none.
-/

noncomputable section

namespace D5.S3.Zeros.CoefficientBounds.SepticEnvelope

open Polynomial

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
private theorem coefficient_second_moment (r : Fin 7 → ℝ) :
    2 * (∏ i, (X - C (r i)) : ℝ[X]).coeff 5 =
      (∑ i, r i)^2 - ∑ i, (r i)^2 := by
  simp only [Fin.prod_univ_succ, Fin.sum_univ_succ, Fin.prod_univ_zero,
    Fin.sum_univ_zero, mul_one, add_zero]
  norm_num only [coeff_X_sub_C_mul, mul_coeff_zero, coeff_sub, coeff_X,
    coeff_C, ite_true, ite_false, zero_mul, mul_zero, one_mul, mul_one,
    zero_add, add_zero, sub_zero, zero_sub]
  ring

/-- The first coefficient bound for seven centered real roots. -/
theorem centered_real_septic_envelope (r : Fin 7 → ℝ) (hcenter : ∑ i, r i = 0) :
    let p : ℝ[X] := ∏ i, (X - C (r i))
    let u := p.coeff 5
    let v := p.coeff 4
    let w := p.coeff 3
    let s := p.coeff 1
    let A := -u
    let B := u^2 + 21*w/5
    let Z := -(2*s + 2*u*w/7 - 4*v^2/35)
    0 ≤ A := by
  dsimp only
  have hid := coefficient_second_moment r
  rw [hcenter] at hid
  have hs : 0 ≤ ∑ i, (r i)^2 := Finset.sum_nonneg (fun i _ => sq_nonneg (r i))
  linarith only [hid, hs]

#print axioms centered_real_septic_envelope

end D5.S3.Zeros.CoefficientBounds.SepticEnvelope
