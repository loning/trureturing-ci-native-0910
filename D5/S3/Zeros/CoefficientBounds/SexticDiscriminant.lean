/- GID: D5/S3/Zeros/CoefficientBounds/SexticDiscriminant
   generality: G
   mirror-B: D5/B/S3/Zeros/CoefficientBounds/SexticDiscriminant
   mirror-E: none(waiver:symbolic-polynomial-inequalities)
   anchors: []
   utility: none
   digest: A nonnegative cubic discriminant from two centered real sextics. -/

import D5.S3.Zeros.CoefficientBounds.SexticEnvelope
import Mathlib.Tactic

/-!
The endpoint estimates are universal real inequalities certified by explicit
positive Bernstein expansions. The concavity identity covers every intermediate
value. The root hypotheses are retained in the public theorem, including when
the second coefficient vanishes.

Utility is none for every declaration: core and rootPoly define polynomials;
upper_endpoint, lower_endpoint, between_endpoints, normalized_discriminant and
normalize_data are universal algebraic inequalities; zero_invariant is a uniform
root implication; centered_real_sextic_discriminant quantifies over all pairs of
centered real root maps. None enumerates inputs, implements a checker, assumes a
numerical analytic bound, or certifies only a numerical instance.
-/

noncomputable section

namespace D5.S3.Zeros.CoefficientBounds.SexticDiscriminant

open Polynomial

private def core (t s : ℝ) : ℝ :=
  1215*t^2 - 1400*t^3 + (1890*t-1458)*s - 245*s^2

-- Both endpoint estimates use positive Bernstein coefficients of bidegree (3,3).
private theorem upper_endpoint (x y : ℝ) (hx : 0 ≤ x) (hx1 : x ≤ 1)
    (hy : 0 ≤ y) (hy1 : y ≤ 1) :
    0 ≤ core (x*y) (4*x^2*y^2/((3-x)*(3-y))) := by
  have hxp : 0 ≤ 1-x := sub_nonneg.mpr hx1
  have hyp : 0 ≤ 1-y := sub_nonneg.mpr hy1
  have hxd : 0 < 3-x := by linarith only [hx1]
  have hyd : 0 < 3-y := by linarith only [hy1]
  let Q := -(1400*x^3*y^3 - 8400*x^3*y^2 + 12600*x^3*y - 8400*x^2*y^3 +
    45545*x^2*y^2 - 45630*x^2*y - 10935*x^2 + 12600*x*y^3 - 45630*x*y^2 +
    7452*x*y + 48114*x - 10935*y^2 + 48114*y - 45927)
  have hQ : 0 ≤ Q := by
    have hid : Q =
        45927*(1-x)^3*(1-y)^3 +
        89667*(x*(1-x)^2*(1-y)^3 + y*(1-y)^2*(1-x)^3) +
        52488*(x^2*(1-x)*(1-y)^3 + y^2*(1-y)*(1-x)^3) +
        8748*(x^3*(1-y)^3 + y^3*(1-x)^3) +
        117207*x*(1-x)^2*y*(1-y)^2 +
        43848*(x*(1-x)^2*y^2*(1-y) + y*(1-y)^2*x^2*(1-x)) +
        3708*(x*(1-x)^2*y^3 + y*(1-y)^2*x^3) +
        8752*x^2*(1-x)*y^2*(1-y) +
        592*(x^2*(1-x)*y^3 + y^2*(1-y)*x^3) + 32*x^3*y^3 := by
      dsimp [Q]
      ring
    rw [hid]
    positivity
  have hid : ((3-x)*(3-y))^2 * core (x*y) (4*x^2*y^2/((3-x)*(3-y))) =
      x^2*y^2*Q := by
    dsimp [core, Q]
    field_simp
    ring
  have hn : 0 ≤ ((3-x)*(3-y))^2 * core (x*y) (4*x^2*y^2/((3-x)*(3-y))) := by
    rw [hid]
    positivity
  exact nonneg_of_mul_nonneg_right hn (by positivity)

private theorem lower_endpoint (x y : ℝ) (hx : 27 / 32 ≤ x) (hx1 : x ≤ 1)
    (hy : 27 / 32 ≤ y) (hy1 : y ≤ 1) :
    0 ≤ core (x*y) ((32*x-27)*(32*y-27)/25) := by
  let u := (32*x-27)/5
  let v := (32*y-27)/5
  have hu : 0 ≤ u := by dsimp [u]; linarith only [hx]
  have hv : 0 ≤ v := by dsimp [v]; linarith only [hy]
  have hu1 : 0 ≤ 1-u := by dsimp [u]; linarith only [hx1]
  have hv1 : 0 ≤ 1-v := by dsimp [v]; linarith only [hy1]
  have hid : 134217728 * core (x*y) ((32*x-27)*(32*y-27)/25) =
      14851118745*(1-u)^3*(1-v)^3 +
      37498476960*(u*(1-u)^2*(1-v)^3 + v*(1-v)^2*(1-u)^3) +
      26302786560*(u^2*(1-u)*(1-v)^3 + v^2*(1-v)*(1-u)^3) +
      3224862720*(u^3*(1-v)^3 + v^3*(1-u)^3) +
      66645576576*u*(1-u)^2*v*(1-v)^2 +
      38990979072*(u*(1-u)^2*v^2*(1-v) + v*(1-v)^2*u^2*(1-u)) +
      8312979456*(u*(1-u)^2*v^3 + v*(1-v)^2*u^3) +
      20575944704*u^2*(1-u)*v^2*(1-v) +
      6073352192*(u^2*(1-u)*v^3 + v^2*(1-v)*u^3) + 268435456*u^3*v^3 := by
    dsimp [core, u, v]
    ring
  have hn : 0 ≤ 134217728 * core (x*y) ((32*x-27)*(32*y-27)/25) := by
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
    (hzl : 32 * x - 27 ≤ 5 * z) (hwl : 32 * y - 27 ≤ 5 * w)
    (hzu : z * (3 - x) ≤ 2 * x^2) (hwu : w * (3 - y) ≤ 2 * y^2) :
    0 ≤ core (x*y) (z*w) := by
  have hxd : 0 < 3-x := by linarith only [hx1]
  have hyd : 0 < 3-y := by linarith only [hy1]
  have hz' : z ≤ 2*x^2/(3-x) := (le_div_iff₀ hxd).mpr hzu
  have hw' : w ≤ 2*y^2/(3-y) := (le_div_iff₀ hyd).mpr hwu
  have hup : z*w ≤ 4*x^2*y^2/((3-x)*(3-y)) := by
    calc
      z*w ≤ (2*x^2/(3-x))*(2*y^2/(3-y)) :=
        mul_le_mul hz' hw' hw (by positivity)
      _ = 4*x^2*y^2/((3-x)*(3-y)) := by field_simp; ring
  have hupper := upper_endpoint x y hx hx1 hy hy1
  by_cases hxy : x*y ≤ 243/280
  · have hc : 0 ≤ 1215-1400*(x*y) := by linarith only [hxy]
    have hlower : 0 ≤ core (x*y) 0 := by
      have he : core (x*y) 0 = (x*y)^2*(1215-1400*(x*y)) := by dsimp [core]; ring
      rw [he]
      positivity
    exact between_endpoints (x*y) 0 (z*w) _ (mul_nonneg hz hw) hup hlower hupper
  have hpx : x*y ≤ x := by nlinarith only [mul_nonneg hx (sub_nonneg.mpr hy1)]
  have hpy : x*y ≤ y := by nlinarith only [mul_nonneg hy (sub_nonneg.mpr hx1)]
  have hxl : 27 / 32 ≤ x := by linarith only [hxy, hpx]
  have hyl : 27 / 32 ≤ y := by linarith only [hxy, hpy]
  have hzl' : (32*x-27)/5 ≤ z := by linarith only [hzl]
  have hwl' : (32*y-27)/5 ≤ w := by linarith only [hwl]
  have hlo : (32*x-27)*(32*y-27)/25 ≤ z*w := by
    calc
      (32*x-27)*(32*y-27)/25 = ((32*x-27)/5)*((32*y-27)/5) := by ring
      _ ≤ z*w := mul_le_mul hzl' hwl' (by linarith only [hyl]) hz
  exact between_endpoints (x*y) _ (z*w) _ hlo hup (lower_endpoint x y hxl hx1 hyl hy1)
    hupper

private theorem normalize_data (A B Z : ℝ) (hA : 0 < A) (hB : 0 ≤ B)
    (hBu : B ≤ 8 * A^2 / 3) (hZ : 0 ≤ Z)
    (hZl : 64 * A * B - 144 * A^3 ≤ 225 * Z)
    (hZu : 45 * Z * (8 * A^2 - B) ≤ 4 * A * B^2) :
    let x := 3*B/(8*A^2)
    let z := 135*Z/(16*A^3)
    0 ≤ x ∧ x ≤ 1 ∧ 0 ≤ z ∧ 32*x-27 ≤ 5*z ∧ z*(3-x) ≤ 2*x^2 := by
  let x := 3*B/(8*A^2)
  let z := 135*Z/(16*A^3)
  change 0 ≤ x ∧ x ≤ 1 ∧ 0 ≤ z ∧ 32*x-27 ≤ 5*z ∧ z*(3-x) ≤ 2*x^2
  have hBn : B = 8*A^2*x/3 := by dsimp [x]; field_simp
  have hZn : Z = 16*A^3*z/135 := by dsimp [z]; field_simp
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · dsimp [x]
    positivity
  · dsimp [x]
    apply (div_le_iff₀ (show 0 < 8*A^2 by positivity)).mpr
    nlinarith only [hBu]
  · dsimp [z]
    positivity
  · rw [hBn, hZn] at hZl
    have hn : 0 ≤ A^3*(5*z-32*x+27) := by nlinarith only [hZl]
    have hp := nonneg_of_mul_nonneg_right hn (pow_pos hA 3)
    linarith only [hp]
  · rw [hBn, hZn] at hZu
    have hn : 0 ≤ A^5*(2*x^2-z*(3-x)) := by nlinarith only [hZu]
    have hp := nonneg_of_mul_nonneg_right hn (pow_pos hA 5)
    nlinarith only [hp]

private def rootPoly (r : Fin 6 → ℝ) : ℝ[X] := ∏ i, (X - C (r i))

set_option maxRecDepth 4096 in
set_option maxHeartbeats 2000000 in
-- Expand the coefficient of degree four to recover the sum of root squares.
private theorem zero_invariant (r : Fin 6 → ℝ) (hr : ∑ i, r i = 0)
    (hA : -(rootPoly r).coeff 4 = 0) :
    -(2*(rootPoly r).coeff 0 + 2*(rootPoly r).coeff 4*(rootPoly r).coeff 2/15 -
      ((rootPoly r).coeff 3)^2/20) = 0 := by
  have hs : 2*(rootPoly r).coeff 4 = (∑ i, r i)^2 - ∑ i, (r i)^2 := by
    norm_num [rootPoly, Fin.prod_univ_succ, Fin.sum_univ_succ, coeff_mul,
      Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk, Finset.sum_range_succ,
      Finset.sum_range_zero, coeff_sub, coeff_X, coeff_C, coeff_one]
    ring
  have hsq : ∑ i, (r i)^2 = 0 := by rw [hr] at hs; nlinarith only [hs, hA]
  have hz : r = fun _ => 0 := by
    funext i
    have hi := (Finset.sum_eq_zero_iff_of_nonneg (fun j _ => sq_nonneg (r j))).mp hsq
      i (Finset.mem_univ i)
    nlinarith only [hi]
  rw [hz]
  norm_num [rootPoly]

set_option maxHeartbeats 1000000 in
-- The homogeneous identity expands coefficients of two products of six factors.
/-- The specified cubic discriminant is nonnegative for two centered sextics
whose six roots are real, with arbitrary multiplicities. -/
theorem centered_real_sextic_discriminant (r r' : Fin 6 → ℝ)
    (hr : ∑ i, r i = 0) (hr' : ∑ i, r' i = 0) :
    let p : ℝ[X] := ∏ i, (X - C (r i))
    let q : ℝ[X] := ∏ i, (X - C (r' i))
    let A := -p.coeff 4
    let B := (p.coeff 4)^2 + 5*p.coeff 2
    let Z := -(2*p.coeff 0 + 2*p.coeff 4*p.coeff 2/15 - (p.coeff 3)^2/20)
    let A' := -q.coeff 4
    let B' := (q.coeff 4)^2 + 5*q.coeff 2
    let Z' := -(2*q.coeff 0 + 2*q.coeff 4*q.coeff 2/15 - (q.coeff 3)^2/20)
    let a := 24*A*A'/35
    let b := 2*B*B'/105
    let c := 4*Z*Z'/7
    0 ≤ a^2*b^2 - 4*b^3 - 4*a^3*c - 27*c^2 + 18*a*b*c := by
  intro p q A B Z A' B' Z' a b c
  change 0 ≤ (24*A*A'/35)^2*(2*B*B'/105)^2 - 4*(2*B*B'/105)^3 -
    4*(24*A*A'/35)^3*(4*Z*Z'/7) - 27*(4*Z*Z'/7)^2 +
    18*(24*A*A'/35)*(2*B*B'/105)*(4*Z*Z'/7)
  obtain ⟨hA, hB, hBu, hZ, hZl, hZu⟩ :
      0 ≤ A ∧ 0 ≤ B ∧ B ≤ 8*A^2/3 ∧ 0 ≤ Z ∧
        64*A*B-144*A^3 ≤ 225*Z ∧ 45*Z*(8*A^2-B) ≤ 4*A*B^2 :=
    SexticEnvelope.centered_real_sextic_envelope r hr
  obtain ⟨hA', hB', hBu', hZ', hZl', hZu'⟩ :
      0 ≤ A' ∧ 0 ≤ B' ∧ B' ≤ 8*A'^2/3 ∧ 0 ≤ Z' ∧
        64*A'*B'-144*A'^3 ≤ 225*Z' ∧ 45*Z'*(8*A'^2-B') ≤ 4*A'*B'^2 :=
    SexticEnvelope.centered_real_sextic_envelope r' hr'
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
  let x := 3*B/(8*A^2)
  let y := 3*B'/(8*A'^2)
  let z := 135*Z/(16*A^3)
  let w := 135*Z'/(16*A'^3)
  obtain ⟨hx, hx1, hz, hzl, hzu⟩ :
      0 ≤ x ∧ x ≤ 1 ∧ 0 ≤ z ∧ 32*x-27 ≤ 5*z ∧ z*(3-x) ≤ 2*x^2 :=
    normalize_data A B Z hap hB hBu hZ hZl hZu
  obtain ⟨hy, hy1, hw, hwl, hwu⟩ :
      0 ≤ y ∧ y ≤ 1 ∧ 0 ≤ w ∧ 32*y-27 ≤ 5*w ∧ w*(3-y) ≤ 2*y^2 :=
    normalize_data A' B' Z' hap' hB' hBu' hZ' hZl' hZu'
  have hn := normalized_discriminant x y z w hx hx1 hy hy1 hz hw hzl hwl hzu hwu
  have he : (24*A*A'/35)^2*(2*B*B'/105)^2 - 4*(2*B*B'/105)^3 -
      4*(24*A*A'/35)^3*(4*Z*Z'/7) - 27*(4*Z*Z'/7)^2 +
      18*(24*A*A'/35)*(2*B*B'/105)*(4*Z*Z'/7) =
      (1048576/147684009375)*(A*A')^6*core (x*y) (z*w) := by
    dsimp only [core, x, y, z, w]
    field_simp
    ring
  rw [he]
  exact mul_nonneg (mul_nonneg (by norm_num : (0 : ℝ) ≤ 1048576/147684009375)
    (pow_nonneg (mul_nonneg hA hA') 6)) hn

#print axioms upper_endpoint
#print axioms lower_endpoint
#print axioms centered_real_sextic_discriminant

end D5.S3.Zeros.CoefficientBounds.SexticDiscriminant
