/- GID: D5/S3/Zeros/CoefficientBounds/SepticDiscriminant
   generality: G
   mirror-B: D5/B/S3/Zeros/CoefficientBounds/SepticDiscriminant
   mirror-E: none(waiver:symbolic-polynomial-inequalities)
   anchors: []
   utility: none
   digest: A nonnegative cubic discriminant from two centered real septics. -/

import D5.S3.Zeros.CoefficientBounds.SepticEnvelope
import Mathlib.Tactic

/-!
escape_witness: upper_endpoint and lower_endpoint
admission_basis: escape-witness
proof_shape: content

The two endpoint inequalities are proved on their full real domains using
positive Bernstein expansions. The normalized product is split at 5/6, and
concavity covers the interval between endpoints. The public statement retains
the root maps: a vanishing A forces all seven roots to vanish before any
normalization by A.

Utility is none declaration by declaration. `core` defines a real polynomial.
`upper_endpoint` and `lower_endpoint` prove universal interval inequalities.
`between_endpoints` is a universal concavity implication.
`normalized_discriminant` proves an inequality for all admissible real inputs.
`normalize_data` is a universal change of variables with a positive denominator.
`homogeneous_identity` is a polynomial identity for arbitrary real variables.
`coefficient_second_moment` is an identity for every real root map.
`zero_invariant` is a uniform implication from centering and a vanishing moment.
`centered_real_septic_discriminant` quantifies over all centered real root pairs.
None enumerates bounded inputs, implements a checker, leaves a numerical bound
as an unfulfilled premise, or certifies a finite numerical instance.
-/

noncomputable section

namespace D5.S3.Zeros.CoefficientBounds.SepticDiscriminant

open Polynomial

set_option Elab.async false

private def core (t s : ℝ) : ℝ :=
  1215*t^2 - 1458*t^3 + (1890*t-1400)*s - 245*s^2

private theorem upper_endpoint (x y : ℝ) (hx : 0 ≤ x) (hx1 : x ≤ 1)
    (hy : 0 ≤ y) (hy1 : y ≤ 1) :
    0 ≤ core (x*y) (9*x^2*y^2/((4-x)*(4-y))) := by
  have hxp : 0 ≤ 1-x := sub_nonneg.mpr hx1
  have hyp : 0 ≤ 1-y := sub_nonneg.mpr hy1
  have hxd : 0 < 4-x := by linarith only [hx1]
  have hyd : 0 < 4-y := by linarith only [hy1]
  let Q := -1458*x^3*y^3 + 11664*x^3*y^2 - 23328*x^3*y +
    11664*x^2*y^3 - 94932*x^2*y^2 + 108864*x^2*y + 19440*x^2 -
    23328*x*y^3 + 108864*x*y^2 - 35928*x*y - 105120*x +
    19440*y^2 - 105120*y + 109440
  have hQ : 0 ≤ Q := by
    have hid : Q =
        109440*(1-x)^3*(1-y)^3 +
        223200*(x*(1-x)^2*(1-y)^3 + y*(1-y)^2*(1-x)^3) +
        137520*(x^2*(1-x)*(1-y)^3 + y^2*(1-y)*(1-x)^3) +
        23760*(x^3*(1-y)^3 + y^3*(1-x)^3) +
        318312*x*(1-x)^2*y*(1-y)^2 +
        134208*(x*(1-x)^2*y^2*(1-y) + y*(1-y)^2*x^2*(1-x)) +
        15768*(x*(1-x)^2*y^3 + y*(1-y)^2*x^3) +
        36972*x^2*(1-x)*y^2*(1-y) +
        5292*(x^2*(1-x)*y^3 + y^2*(1-y)*x^3) + 162*x^3*y^3 := by
      dsimp [Q]
      ring
    rw [hid]
    positivity
  have hid : ((4-x)*(4-y))^2 * core (x*y) (9*x^2*y^2/((4-x)*(4-y))) =
      x^2*y^2*Q := by
    dsimp [core, Q]
    field_simp
    ring
  have hn : 0 ≤ ((4-x)*(4-y))^2 * core (x*y) (9*x^2*y^2/((4-x)*(4-y))) := by
    rw [hid]
    positivity
  exact nonneg_of_mul_nonneg_right hn (by positivity)

private theorem lower_endpoint (x y : ℝ) (hx : 5/6 ≤ x) (hx1 : x ≤ 1)
    (hy : 5/6 ≤ y) (hy1 : y ≤ 1) :
    0 ≤ core (x*y) ((6*x-5)*(6*y-5)) := by
  let u := 6*x-5
  let v := 6*y-5
  have hu : 0 ≤ u := by dsimp [u]; linarith only [hx]
  have hv : 0 ≤ v := by dsimp [v]; linarith only [hy]
  have hu1 : 0 ≤ 1-u := by dsimp [u]; linarith only [hx1]
  have hv1 : 0 ≤ 1-v := by dsimp [v]; linarith only [hy1]
  have hid : 32 * core (x*y) ((6*x-5)*(6*y-5)) =
      3125*(1-u)^3*(1-v)^3 +
      7500*(u*(1-u)^2*(1-v)^3 + v*(1-v)^2*(1-u)^3) +
      4500*(u^2*(1-u)*(1-v)^3 + v^2*(1-v)*(1-u)^3) +
      11450*u*(1-u)^2*v*(1-v)^2 +
      4600*(u*(1-u)^2*v^2*(1-v) + v*(1-v)^2*u^2*(1-u)) +
      200*(u*(1-u)^2*v^3 + v*(1-v)^2*u^3) +
      1120*u^2*(1-u)*v^2*(1-v) +
      480*(u^2*(1-u)*v^3 + v^2*(1-v)*u^3) + 64*u^3*v^3 := by
    dsimp [core, u, v]
    ring
  have hn : 0 ≤ 32 * core (x*y) ((6*x-5)*(6*y-5)) := by
    rw [hid]
    positivity
  exact nonneg_of_mul_nonneg_right hn (by norm_num)

private theorem between_endpoints (t l s u : ℝ) (hls : l ≤ s) (hsu : s ≤ u)
    (hl : 0 ≤ core t l) (hu : 0 ≤ core t u) : 0 ≤ core t s := by
  by_cases he : l = u
  · have hs : s = l := by linarith only [hls, hsu, he]
    simpa only [hs] using hl
  have hlu : 0 < u-l := sub_pos.mpr (lt_of_le_of_ne (le_trans hls hsu) he)
  have hsl : 0 ≤ s-l := sub_nonneg.mpr hls
  have hus : 0 ≤ u-s := sub_nonneg.mpr hsu
  have hid : (u-l)*core t s =
      (u-s)*core t l + (s-l)*core t u + 245*(u-l)*(s-l)*(u-s) := by
    dsimp [core]
    ring
  have hn : 0 ≤ (u-l)*core t s := by
    rw [hid]
    positivity
  exact nonneg_of_mul_nonneg_right hn hlu

private theorem normalized_discriminant (x y z w : ℝ)
    (hx : 0 ≤ x) (hx1 : x ≤ 1) (hy : 0 ≤ y) (hy1 : y ≤ 1)
    (hz : 0 ≤ z) (hw : 0 ≤ w)
    (hzl : 6*x-5 ≤ z) (hwl : 6*y-5 ≤ w)
    (hzu : z*(4-x) ≤ 3*x^2) (hwu : w*(4-y) ≤ 3*y^2) :
    0 ≤ core (x*y) (z*w) := by
  fail_if_success
    solve
    | dsimp only [core]
      linarith only [hx, hx1, hy, hy1, hz, hw, hzl, hwl, hzu, hwu,
        sq_nonneg x, sq_nonneg y, sq_nonneg z, sq_nonneg w, sq_nonneg (x*y)]
  have hxd : 0 < 4-x := by linarith only [hx1]
  have hyd : 0 < 4-y := by linarith only [hy1]
  have hz' : z ≤ 3*x^2/(4-x) := (le_div_iff₀ hxd).mpr hzu
  have hw' : w ≤ 3*y^2/(4-y) := (le_div_iff₀ hyd).mpr hwu
  have hup : z*w ≤ 9*x^2*y^2/((4-x)*(4-y)) := by
    calc
      z*w ≤ (3*x^2/(4-x))*(3*y^2/(4-y)) :=
        mul_le_mul hz' hw' hw (by positivity)
      _ = 9*x^2*y^2/((4-x)*(4-y)) := by field_simp; ring
  have hupper := upper_endpoint x y hx hx1 hy hy1
  by_cases hxy : x*y ≤ 5/6
  · have hc : 0 ≤ 1215-1458*(x*y) := by linarith only [hxy]
    have hlower : 0 ≤ core (x*y) 0 := by
      have he : core (x*y) 0 = (x*y)^2*(1215-1458*(x*y)) := by dsimp [core]; ring
      rw [he]
      positivity
    exact between_endpoints (x*y) 0 (z*w) _ (mul_nonneg hz hw) hup hlower hupper
  have hpx : x*y ≤ x := by nlinarith only [mul_nonneg hx (sub_nonneg.mpr hy1)]
  have hpy : x*y ≤ y := by nlinarith only [mul_nonneg hy (sub_nonneg.mpr hx1)]
  have hxl : 5/6 ≤ x := by linarith only [hxy, hpx]
  have hyl : 5/6 ≤ y := by linarith only [hxy, hpy]
  have hlo : (6*x-5)*(6*y-5) ≤ z*w :=
    mul_le_mul hzl hwl (by linarith only [hyl]) hz
  exact between_endpoints (x*y) _ (z*w) _ hlo hup
    (lower_endpoint x y hxl hx1 hyl hy1) hupper

private theorem normalize_data (A B Z : ℝ) (hA : 0 < A) (hB : 0 ≤ B)
    (hBu : B ≤ 49*A^2/20) (hZ : 0 ≤ Z)
    (hZl : 120*A*B-245*A^3 ≤ 270*Z)
    (hZu : 9*Z*(49*A^2-5*B) ≤ 10*A*B^2) :
    let x := 20*B/(49*A^2)
    let z := 270*Z/(49*A^3)
    0 ≤ x ∧ x ≤ 1 ∧ 0 ≤ z ∧ 6*x-5 ≤ z ∧ z*(4-x) ≤ 3*x^2 := by
  let x := 20*B/(49*A^2)
  let z := 270*Z/(49*A^3)
  change 0 ≤ x ∧ x ≤ 1 ∧ 0 ≤ z ∧ 6*x-5 ≤ z ∧ z*(4-x) ≤ 3*x^2
  have hBn : B = 49*A^2*x/20 := by dsimp [x]; field_simp
  have hZn : Z = 49*A^3*z/270 := by dsimp [z]; field_simp
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · dsimp [x]
    positivity
  · dsimp [x]
    apply (div_le_iff₀ (show 0 < 49*A^2 by positivity)).mpr
    linarith only [hBu]
  · dsimp [z]
    positivity
  · rw [hBn, hZn] at hZl
    have hn : 0 ≤ A^3*(z-6*x+5) := by nlinarith only [hZl]
    have hp := nonneg_of_mul_nonneg_right hn (pow_pos hA 3)
    linarith only [hp]
  · rw [hBn, hZn] at hZu
    have hn : 0 ≤ A^5*(3*x^2-z*(4-x)) := by nlinarith only [hZu]
    have hp := nonneg_of_mul_nonneg_right hn (pow_pos hA 5)
    linarith only [hp]

private theorem homogeneous_identity (A A' x y z w : ℝ) :
    let a := 7*A*A'/12
    let b := 5*(49*A^2*x/20)*(49*A'^2*y/20)/294
    let c := 5*(49*A^3*z/270)*(49*A'^3*w/270)/32
    a^2*b^2 - 4*b^3 - 4*a^3*c - 27*c^2 + 18*a*b*c =
      (117649/40310784000)*(A*A')^6*core (x*y) (z*w) := by
  dsimp [core]
  ring

private theorem coefficient_second_moment (r : Fin 7 → ℝ) :
    2 * (∏ i, (X - C (r i)) : ℝ[X]).coeff 5 =
      (∑ i, r i)^2 - ∑ i, (r i)^2 := by
  simp only [Fin.prod_univ_succ, Fin.sum_univ_succ, Fin.prod_univ_zero,
    Fin.sum_univ_zero, mul_one, add_zero]
  norm_num only [coeff_X_sub_C_mul, mul_coeff_zero, coeff_sub, coeff_X,
    coeff_C, ite_true, ite_false, zero_mul, mul_zero, one_mul, mul_one,
    zero_add, add_zero, sub_zero, zero_sub]
  ring

private theorem zero_invariant (r : Fin 7 → ℝ) (hr : ∑ i, r i = 0)
    (hA : -(∏ i, (X - C (r i)) : ℝ[X]).coeff 5 = 0) :
    let p : ℝ[X] := ∏ i, (X - C (r i));
    -(2*p.coeff 1 + 2*p.coeff 5*p.coeff 3/7 - 4*(p.coeff 4)^2/35) = 0 := by
  have hs := coefficient_second_moment r
  rw [hr] at hs
  have hsq : ∑ i, (r i)^2 = 0 := by linarith only [hs, hA]
  have heach := (Finset.sum_eq_zero_iff_of_nonneg (fun i _ => sq_nonneg (r i))).mp hsq
  have hz : ∀ i, r i = 0 := fun i => sq_eq_zero_iff.mp (heach i (Finset.mem_univ i))
  norm_num [hz]

/-- The cubic coefficient discriminant is nonnegative for any two centered
products of seven real linear factors, with arbitrary multiplicities. -/
theorem centered_real_septic_discriminant (r r' : Fin 7 → ℝ)
    (hr : ∑ i, r i = 0) (hr' : ∑ i, r' i = 0) :
    let p : ℝ[X] := ∏ i, (X - C (r i))
    let q : ℝ[X] := ∏ i, (X - C (r' i))
    let A := -p.coeff 5
    let B := (p.coeff 5)^2 + 21*p.coeff 3/5
    let Z := -(2*p.coeff 1 + 2*p.coeff 5*p.coeff 3/7 - 4*(p.coeff 4)^2/35)
    let A' := -q.coeff 5
    let B' := (q.coeff 5)^2 + 21*q.coeff 3/5
    let Z' := -(2*q.coeff 1 + 2*q.coeff 5*q.coeff 3/7 - 4*(q.coeff 4)^2/35)
    let a := 7*A*A'/12
    let b := 5*B*B'/294
    let c := 5*Z*Z'/32
    0 ≤ a^2*b^2 - 4*b^3 - 4*a^3*c - 27*c^2 + 18*a*b*c := by
  intro p q A B Z A' B' Z' a b c
  change 0 ≤ (7*A*A'/12)^2*(5*B*B'/294)^2 - 4*(5*B*B'/294)^3 -
    4*(7*A*A'/12)^3*(5*Z*Z'/32) - 27*(5*Z*Z'/32)^2 +
    18*(7*A*A'/12)*(5*B*B'/294)*(5*Z*Z'/32)
  obtain ⟨hA, hB, hBu, hZ, hZl, hZu⟩ :
      0 ≤ A ∧ 0 ≤ B ∧ B ≤ 49*A^2/20 ∧ 0 ≤ Z ∧
        120*A*B-245*A^3 ≤ 270*Z ∧ 9*Z*(49*A^2-5*B) ≤ 10*A*B^2 :=
    SepticEnvelope.centered_real_septic_envelope r hr
  obtain ⟨hA', hB', hBu', hZ', hZl', hZu'⟩ :
      0 ≤ A' ∧ 0 ≤ B' ∧ B' ≤ 49*A'^2/20 ∧ 0 ≤ Z' ∧
        120*A'*B'-245*A'^3 ≤ 270*Z' ∧ 9*Z'*(49*A'^2-5*B') ≤ 10*A'*B'^2 :=
    SepticEnvelope.centered_real_septic_envelope r' hr'
  fail_if_success
    linarith only [hA, hB, hBu, hZ, hZl, hZu, hA', hB', hBu', hZ', hZl', hZu',
      sq_nonneg A, sq_nonneg B, sq_nonneg Z, sq_nonneg A', sq_nonneg B', sq_nonneg Z']
  by_cases haz : A = 0
  · have hbz : B = 0 := by nlinarith only [hB, hBu, haz]
    have hzz : Z = 0 := zero_invariant r hr haz
    simp [haz, hbz, hzz]
  by_cases haz' : A' = 0
  · have hbz : B' = 0 := by nlinarith only [hB', hBu', haz']
    have hzz : Z' = 0 := zero_invariant r' hr' haz'
    simp [haz', hbz, hzz]
  have hap : 0 < A := lt_of_le_of_ne hA (Ne.symm haz)
  have hap' : 0 < A' := lt_of_le_of_ne hA' (Ne.symm haz')
  let x := 20*B/(49*A^2)
  let y := 20*B'/(49*A'^2)
  let z := 270*Z/(49*A^3)
  let w := 270*Z'/(49*A'^3)
  obtain ⟨hx, hx1, hz, hzl, hzu⟩ :
      0 ≤ x ∧ x ≤ 1 ∧ 0 ≤ z ∧ 6*x-5 ≤ z ∧ z*(4-x) ≤ 3*x^2 :=
    normalize_data A B Z hap hB hBu hZ hZl hZu
  obtain ⟨hy, hy1, hw, hwl, hwu⟩ :
      0 ≤ y ∧ y ≤ 1 ∧ 0 ≤ w ∧ 6*y-5 ≤ w ∧ w*(4-y) ≤ 3*y^2 :=
    normalize_data A' B' Z' hap' hB' hBu' hZ' hZl' hZu'
  have hn := normalized_discriminant x y z w hx hx1 hy hy1 hz hw hzl hwl hzu hwu
  have hBn : B = 49*A^2*x/20 := by dsimp [x]; field_simp
  have hBn' : B' = 49*A'^2*y/20 := by dsimp [y]; field_simp
  have hZn : Z = 49*A^3*z/270 := by dsimp [z]; field_simp
  have hZn' : Z' = 49*A'^3*w/270 := by dsimp [w]; field_simp
  rw [hBn, hBn', hZn, hZn', homogeneous_identity]
  exact mul_nonneg (mul_nonneg (by norm_num : (0 : ℝ) ≤ 117649/40310784000)
    (pow_nonneg (mul_nonneg hA hA') 6)) hn

#print axioms upper_endpoint
#print axioms lower_endpoint
#print axioms homogeneous_identity
#print axioms zero_invariant
#print axioms centered_real_septic_discriminant

end D5.S3.Zeros.CoefficientBounds.SepticDiscriminant
