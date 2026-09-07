/- GID: D5/S3/Zeros/CoefficientBounds/SexticEnvelope
   generality: G
   mirror-B: D5/B/S3/Zeros/CoefficientBounds/SexticEnvelope
   mirror-E: none(waiver:symbolic-polynomial-inequalities)
   anchors: []
   utility: none
   digest: Six sharp joint coefficient inequalities for centered real sextics. -/

import D5.S3.Zeros.CoefficientBounds.SexticEnvelopeGaps
import Mathlib.Data.Fin.Tuple.Sort
import Mathlib.Algebra.Polynomial.BigOperators

/-!
An arbitrary enumeration of six real roots with sum zero satisfies the coefficient
envelope. Sorting preserves both their sum and their product of linear factors.
The positive-coefficient gap certificates are the sole new inequality input.
Every declaration is a universal algebraic identity or inequality, so utility is
none: there is no bounded enumeration, checker, numerical reduction, or certified
numerical instance. The equality check also quantifies over every real h.
-/

noncomputable section

namespace D5.S3.Zeros.CoefficientBounds.SexticEnvelope

open Polynomial SexticEnvelopeGaps

private def gapPolynomial (a b c d e : ℝ) : ℝ[X] :=
  (X - C (-5*a - 4*b - 3*c - 2*d - e)) *
  (X - C (a - 4*b - 3*c - 2*d - e)) *
  (X - C (a + 2*b - 3*c - 2*d - e)) *
  (X - C (a + 2*b + 3*c - 2*d - e)) *
  (X - C (a + 2*b + 3*c + 4*d - e)) *
  (X - C (a + 2*b + 3*c + 4*d + 5*e))

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
-- Expand the six linear factors and normalize their degree-six invariants.
private theorem gap_coefficients (a b c d e : ℝ) :
    let p := gapPolynomial a b c d e;
    -p.coeff 4 = gapA a b c d e ∧
    (p.coeff 4)^2 + 5*p.coeff 2 = gapB a b c d e ∧
    -(2*p.coeff 0 + 2*p.coeff 4*p.coeff 2/15 - (p.coeff 3)^2/20) =
      gapZ a b c d e := by
  dsimp only
  refine ⟨?_, ?_, ?_⟩ <;>
    norm_num only [gapPolynomial, gapA, gapB, gapZ, coeff_mul,
      Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk, Finset.sum_range_succ,
      Finset.sum_range_zero,
      coeff_sub, coeff_X, coeff_C, ite_true, ite_false,
      zero_mul, mul_zero, one_mul, mul_one, zero_add, add_zero, sub_zero, zero_sub] <;> ring

/-- The coefficient envelope of any centered sextic with six real roots,
including repeated roots. -/
theorem centered_real_sextic_envelope (r : Fin 6 → ℝ) (hcenter : ∑ i, r i = 0) :
    let p : ℝ[X] := ∏ i, (X - C (r i))
    let u := p.coeff 4
    let v := p.coeff 3
    let w := p.coeff 2
    let s := p.coeff 0
    let A := -u
    let B := u^2 + 5*w
    let Z := -(2*s + 2*u*w/15 - v^2/20)
    0 ≤ A ∧ 0 ≤ B ∧ B ≤ 8*A^2/3 ∧ 0 ≤ Z ∧
      64*A*B - 144*A^3 ≤ 225*Z ∧ 45*Z*(8*A^2 - B) ≤ 4*A*B^2 := by
  classical
  dsimp only
  let q := r ∘ Tuple.sort r
  have hq : Monotone q := Tuple.monotone_sort r
  have hsum : ∑ i, q i = 0 := by
    change (∑ i, r ((Tuple.sort r) i)) = 0
    rw [Equiv.sum_comp]
    exact hcenter
  have hsum' : q 0 + q 1 + q 2 + q 3 + q 4 + q 5 = 0 := by
    simpa [Fin.sum_univ_succ, add_assoc] using hsum
  let a := (q 1 - q 0)/6
  let b := (q 2 - q 1)/6
  let c := (q 3 - q 2)/6
  let d := (q 4 - q 3)/6
  let e := (q 5 - q 4)/6
  have ha : 0 ≤ a := div_nonneg (sub_nonneg.mpr (hq (by decide))) (by norm_num)
  have hb : 0 ≤ b := div_nonneg (sub_nonneg.mpr (hq (by decide))) (by norm_num)
  have hc : 0 ≤ c := div_nonneg (sub_nonneg.mpr (hq (by decide))) (by norm_num)
  have hd : 0 ≤ d := div_nonneg (sub_nonneg.mpr (hq (by decide))) (by norm_num)
  have he : 0 ≤ e := div_nonneg (sub_nonneg.mpr (hq (by decide))) (by norm_num)
  have h0 : q 0 = -5*a - 4*b - 3*c - 2*d - e := by
    dsimp only [a, b, c, d, e]
    linarith only [hsum']
  have h1 : q 1 = a - 4*b - 3*c - 2*d - e := by
    dsimp only [a, b, c, d, e]
    linarith only [hsum']
  have h2 : q 2 = a + 2*b - 3*c - 2*d - e := by
    dsimp only [a, b, c, d, e]
    linarith only [hsum']
  have h3 : q 3 = a + 2*b + 3*c - 2*d - e := by
    dsimp only [a, b, c, d, e]
    linarith only [hsum']
  have h4 : q 4 = a + 2*b + 3*c + 4*d - e := by
    dsimp only [a, b, c, d, e]
    linarith only [hsum']
  have h5 : q 5 = a + 2*b + 3*c + 4*d + 5*e := by
    dsimp only [a, b, c, d, e]
    linarith only [hsum']
  have hp : (∏ i : Fin 6, (X - C (r i))) = gapPolynomial a b c d e := by
    rw [← Equiv.prod_comp (Tuple.sort r) (fun i => (X - C (r i) : ℝ[X]))]
    change (∏ i : Fin 6, (X - C (q i))) = gapPolynomial a b c d e
    simp [Fin.prod_univ_succ, gapPolynomial,
      h0, h1, h2, h3, h4, h5, mul_assoc]
  rw [hp]
  obtain ⟨hA, hB, hZ⟩ := gap_coefficients a b c d e
  rw [hA, hB, hZ]
  exact gap_envelope a b c d e ha hb hc hd he

set_option maxRecDepth 4096 in
-- Normalize the coefficient expressions before checking both symbolic equalities.
private theorem balanced_equalities (h : ℝ) :
    let p : ℝ[X] := (X^2 - C (h^2))^3
    let A := -p.coeff 4
    let B := (p.coeff 4)^2 + 5*p.coeff 2
    let Z := -(2*p.coeff 0 + 2*p.coeff 4*p.coeff 2/15 - (p.coeff 3)^2/20)
    225*Z - (64*A*B - 144*A^3) = 0 ∧
      4*A*B^2 - 45*Z*(8*A^2 - B) = 0 := by
  have hp : (X^2 - C (h^2) : ℝ[X])^3 =
      X^6 - C (3*h^2)*X^4 + C (3*h^4)*X^2 - C (h^6) := by
    simp only [map_mul, map_ofNat, map_pow]
    ring
  dsimp only
  rw [hp]
  simp only [coeff_add, coeff_sub, coeff_C_mul_X_pow, coeff_X_pow, coeff_C]
  norm_num
  constructor <;> ring

#print axioms centered_real_sextic_envelope
#print axioms balanced_equalities

end D5.S3.Zeros.CoefficientBounds.SexticEnvelope
