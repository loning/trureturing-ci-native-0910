/- GID: D5/S3/Zeros/CoefficientBounds/SepticEnvelope
   generality: G
   mirror-B: D5/B/S3/Zeros/CoefficientBounds/SepticEnvelope
   mirror-E: none(waiver:symbolic-polynomial-inequalities)
   anchors: []
   utility: none
   digest: Coefficient inequalities for arbitrary centered real-rooted septics. -/

import D5.S3.Zeros.CoefficientBounds.SepticEnvelopeUpper
import Mathlib.Algebra.Polynomial.BigOperators
import Mathlib.Data.Fin.Tuple.Sort

/-!
`coefficient_second_moment` is an identity for every real root map, and
`roots_zero_of_invariant_zero` is its universal zero-case consequence.
`gapPolynomial` is a symbolic product of seven real linear factors, and
`gap_coefficients` identifies its coefficients for arbitrary real gaps.
`centered_real_septic_envelope` bounds the coefficients of every centered real
root map. None enumerates a bounded family, implements a checker, assumes a
numerical premise, or certifies a finite instance. Thus utility is none.
-/

noncomputable section

namespace D5.S3.Zeros.CoefficientBounds.SepticEnvelope

open Polynomial SepticEnvelopeGaps SepticEnvelopeUpper

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

private theorem roots_zero_of_invariant_zero (r : Fin 7 → ℝ)
    (hcenter : ∑ i, r i = 0)
    (hzero : -(∏ i, (X - C (r i)) : ℝ[X]).coeff 5 = 0) :
    ∀ i, r i = 0 := by
  have hid := coefficient_second_moment r
  rw [hcenter] at hid
  have hs : ∑ i, (r i)^2 = 0 := by linarith only [hid, hzero]
  have heach := (Finset.sum_eq_zero_iff_of_nonneg (fun i _ => sq_nonneg (r i))).mp hs
  intro i
  exact sq_eq_zero_iff.mp (heach i (Finset.mem_univ i))

private def gapPolynomial (a b c d e f : ℝ) : ℝ[X] :=
  (X - C (-6*a - 5*b - 4*c - 3*d - 2*e - f)) *
    ((X - C (a - 5*b - 4*c - 3*d - 2*e - f)) *
      ((X - C (a + 2*b - 4*c - 3*d - 2*e - f)) *
        ((X - C (a + 2*b + 3*c - 3*d - 2*e - f)) *
          ((X - C (a + 2*b + 3*c + 4*d - 2*e - f)) *
            ((X - C (a + 2*b + 3*c + 4*d + 5*e - f)) *
              (X - C (a + 2*b + 3*c + 4*d + 5*e + 6*f)))))))

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
private theorem gap_coefficients (a b c d e f : ℝ) :
    let p := gapPolynomial a b c d e f;
    -p.coeff 5 = gapA a b c d e f ∧
    (p.coeff 5)^2 + 21*p.coeff 3/5 = gapB a b c d e f ∧
    -(2*p.coeff 1 + 2*p.coeff 5*p.coeff 3/7 - 4*(p.coeff 4)^2/35) =
      gapZ a b c d e f := by
  dsimp only
  refine ⟨?_, ?_, ?_⟩ <;>
    norm_num only [gapPolynomial, gapA, gapB, gapZ, coeff_X_sub_C_mul,
      mul_coeff_zero, coeff_sub, coeff_X, coeff_C, ite_true, ite_false,
      zero_mul, mul_zero, one_mul, mul_one, zero_add, add_zero, sub_zero, zero_sub] <;> ring

/-- Coefficient bounds for seven centered real roots, including repeated and zero roots. -/
theorem centered_real_septic_envelope (r : Fin 7 → ℝ) (hcenter : ∑ i, r i = 0) :
    let p : ℝ[X] := ∏ i, (X - C (r i))
    let u := p.coeff 5
    let v := p.coeff 4
    let w := p.coeff 3
    let s := p.coeff 1
    let A := -u
    let B := u^2 + 21*w/5
    let Z := -(2*s + 2*u*w/7 - 4*v^2/35)
    0 ≤ A ∧ 0 ≤ B ∧ B ≤ 49*A^2/20 ∧ 0 ≤ Z ∧
      120*A*B - 245*A^3 ≤ 270*Z ∧ 9*Z*(49*A^2 - 5*B) ≤ 10*A*B^2 := by
  classical
  dsimp only
  by_cases hzero : -(∏ i, (X - C (r i)) : ℝ[X]).coeff 5 = 0
  · have hrzero := roots_zero_of_invariant_zero r hcenter hzero
    norm_num [hrzero]
  let q := r ∘ Tuple.sort r
  have hq : Monotone q := Tuple.monotone_sort r
  have hsum : ∑ i, q i = 0 := by
    change (∑ i, r ((Tuple.sort r) i)) = 0
    rw [Equiv.sum_comp]
    exact hcenter
  have hsum' : q 0 + q 1 + q 2 + q 3 + q 4 + q 5 + q 6 = 0 := by
    simpa [Fin.sum_univ_succ, add_assoc] using hsum
  let a := (q 1 - q 0)/7
  let b := (q 2 - q 1)/7
  let c := (q 3 - q 2)/7
  let d := (q 4 - q 3)/7
  let e := (q 5 - q 4)/7
  let f := (q 6 - q 5)/7
  have ha : 0 ≤ a := div_nonneg (sub_nonneg.mpr (hq (by decide))) (by norm_num)
  have hb : 0 ≤ b := div_nonneg (sub_nonneg.mpr (hq (by decide))) (by norm_num)
  have hc : 0 ≤ c := div_nonneg (sub_nonneg.mpr (hq (by decide))) (by norm_num)
  have hd : 0 ≤ d := div_nonneg (sub_nonneg.mpr (hq (by decide))) (by norm_num)
  have he : 0 ≤ e := div_nonneg (sub_nonneg.mpr (hq (by decide))) (by norm_num)
  have hf : 0 ≤ f := div_nonneg (sub_nonneg.mpr (hq (by decide))) (by norm_num)
  have h0 : q 0 = -6*a - 5*b - 4*c - 3*d - 2*e - f := by
    dsimp only [a, b, c, d, e, f]
    linarith only [hsum']
  have h1 : q 1 = a - 5*b - 4*c - 3*d - 2*e - f := by
    dsimp only [a, b, c, d, e, f]
    linarith only [hsum']
  have h2 : q 2 = a + 2*b - 4*c - 3*d - 2*e - f := by
    dsimp only [a, b, c, d, e, f]
    linarith only [hsum']
  have h3 : q 3 = a + 2*b + 3*c - 3*d - 2*e - f := by
    dsimp only [a, b, c, d, e, f]
    linarith only [hsum']
  have h4 : q 4 = a + 2*b + 3*c + 4*d - 2*e - f := by
    dsimp only [a, b, c, d, e, f]
    linarith only [hsum']
  have h5 : q 5 = a + 2*b + 3*c + 4*d + 5*e - f := by
    dsimp only [a, b, c, d, e, f]
    linarith only [hsum']
  have h6 : q 6 = a + 2*b + 3*c + 4*d + 5*e + 6*f := by
    dsimp only [a, b, c, d, e, f]
    linarith only [hsum']
  have hp : (∏ i : Fin 7, (X - C (r i))) = gapPolynomial a b c d e f := by
    rw [← Equiv.prod_comp (Tuple.sort r) (fun i => (X - C (r i) : ℝ[X]))]
    change (∏ i : Fin 7, (X - C (q i))) = gapPolynomial a b c d e f
    simp [Fin.prod_univ_succ, gapPolynomial, h0, h1, h2, h3, h4, h5, h6, mul_assoc]
  rw [hp]
  obtain ⟨hA, hB, hZ⟩ := gap_coefficients a b c d e f
  rw [hA, hB, hZ]
  exact ⟨gap_a_nonneg a b c d e f ha hb hc hd he hf,
    gap_b_nonneg a b c d e f ha hb hc hd he hf,
    gap_b_upper a b c d e f ha hb hc hd he hf,
    gap_z_nonneg a b c d e f ha hb hc hd he hf,
    gap_z_lower a b c d e f ha hb hc hd he hf,
    gap_z_upper a b c d e f ha hb hc hd he hf⟩

#print axioms centered_real_septic_envelope

end D5.S3.Zeros.CoefficientBounds.SepticEnvelope
