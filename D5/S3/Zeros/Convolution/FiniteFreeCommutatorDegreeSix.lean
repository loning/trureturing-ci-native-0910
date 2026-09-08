/- GID: D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix
   generality: I
   mirror-B: D5/B/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix
   mirror-E: none(waiver:symbolic-polynomial-factorization)
   anchors: []
   utility: none
   digest: The finite free commutator of two real sextics has six real roots. -/

import D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
import D5.S3.Zeros.CoefficientBounds.SexticDiscriminant
import Mathlib.Algebra.CubicDiscriminant
import Mathlib.Analysis.Polynomial.Basic
import Mathlib.Topology.Order.IntermediateValue

/-!
The degree-six case of Conjecture 5.3 in Campbell, Morales, and Perales,
"Even Hypergeometric Polynomials and Finite Free Commutators",
arXiv:2502.00254v2, SIGMA 21 (2025), 108, DOI 10.3842/SIGMA.2025.108.

After translation and an exact convolution expansion, the frozen sextic
envelope and discriminant bound give an alternating cubic in the squared
variable. A nonnegative root from the intermediate value theorem leaves a
quadratic with nonnegative discriminant, also when the first root is repeated.
Its three nonnegative roots give six real linear factors by taking square roots.
-/

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

private theorem cubic_root_nonneg (a b c x : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c)
    (hx : x^3-a*x^2+b*x-c = 0) : 0 ≤ x := by
  by_contra! hneg
  have hcube : x^3 < 0 := by
    simpa [pow_succ] using mul_neg_of_pos_of_neg (sq_pos_of_neg hneg) hneg
  have hax := mul_nonneg ha (sq_nonneg x)
  have hbx := mul_nonpos_of_nonneg_of_nonpos hb hneg.le
  linarith only [hx, hc, hcube, hax, hbx]

/-- A cubic with alternating nonnegative coefficients and nonnegative
discriminant factors over three nonnegative real roots, including multiplicities. -/
theorem cubic_nonnegative_factorization (a b c : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c)
    (hd : 0 ≤ a^2*b^2-4*b^3-4*a^3*c-27*c^2+18*a*b*c) :
    ∃ x y z : ℝ, 0 ≤ x ∧ 0 ≤ y ∧ 0 ≤ z ∧
      (X^3-C a*X^2+C b*X-C c : ℝ[X]) = (X-C x)*(X-C y)*(X-C z) := by
  let f := (⟨1, -a, b, -c⟩ : Cubic ℝ).toPoly
  have hdeg : 0 < f.degree := by
    dsimp only [f]
    rw [Cubic.degree_of_a_ne_zero' (by norm_num)]
    norm_num
  have hlc : 0 ≤ f.leadingCoeff := by simp [f]
  obtain ⟨x, hx0, hx⟩ := intermediate_value_Ici f.continuous.continuousOn
    (f.tendsto_atTop_of_leadingCoeff_nonneg hdeg hlc)
    (show 0 ∈ Set.Ici (f.eval 0) by simpa [f, Cubic.toPoly] using neg_nonpos.mpr hc)
  have hxroot : x^3-a*x^2+b*x-c = 0 := by
    simpa [f, Cubic.toPoly, sub_eq_add_neg] using hx
  have hcval : c = x^3-a*x^2+b*x := by linarith only [hxroot]
  let d := a^2+2*a*x-3*x^2-4*b
  let R := 3*x^2-2*a*x+b
  -- The squared resultant can vanish; that case gives a repeated linear factor.
  have hid : a^2*b^2-4*b^3-4*a^3*c-27*c^2+18*a*b*c = d*R^2 := by
    rw [hcval]
    dsimp [d, R]
    ring
  have hd0 : 0 ≤ d := by
    by_cases hR : R = 0
    · have he : d = (a-3*x)^2 := by
        dsimp [d, R] at *
        nlinarith only [hR]
      rw [he]
      exact sq_nonneg _
    · rw [hid] at hd
      exact nonneg_of_mul_nonneg_left hd (sq_pos_of_ne_zero hR)
  let y := (a-x+Real.sqrt d)/2
  let z := (a-x-Real.sqrt d)/2
  have hsum : y+z = a-x := by dsimp [y, z]; ring
  have hprod : y*z = x^2-a*x+b := by
    have hs := Real.sq_sqrt hd0
    dsimp [y, z, d] at *
    nlinarith only [hs]
  have hfactor : (X^3-C a*X^2+C b*X-C c : ℝ[X]) =
      (X-C x)*(X-C y)*(X-C z) := by
    calc
      _ = (X-C x)*(X^2-C (a-x)*X+C (x^2-a*x+b)) := by
        rw [hcval]
        simp only [map_add, map_sub, map_mul, map_pow]
        ring
      _ = _ := by
        rw [← hsum, ← hprod]
        simp only [map_add, map_mul]
        ring
  have hy : y^3-a*y^2+b*y-c = 0 := by
    simpa using congrArg (fun p : ℝ[X] => p.eval y) hfactor
  have hz : z^3-a*z^2+b*z-c = 0 := by
    simpa using congrArg (fun p : ℝ[X] => p.eval z) hfactor
  exact ⟨x, y, z, hx0, cubic_root_nonneg a b c y ha hb hc hy,
    cubic_root_nonneg a b c z ha hb hc hz, hfactor⟩

private theorem root_sum_zero (p : ℝ[X]) (r : Fin 6 → ℝ)
    (hp : p = ∏ i, (X-C (r i))) (hcoeff : p.coeff 5 = 0) : ∑ i, r i = 0 := by
  have h := prod_X_sub_C_coeff_card_pred (Finset.univ : Finset (Fin 6)) r (by decide)
  norm_num only [Finset.card_univ, Fintype.card_fin, Nat.reduceSub] at h
  rw [← hp, hcoeff] at h
  exact neg_eq_zero.mp h.symm

/-- The frozen envelope supplies all three signs independently of the frozen
discriminant bound. The two pairs of negative invariant signs cancel. -/
theorem centered_data (u v w t s U V W T S : ℝ)
    (hp : RealRooted6 (centeredSextic u v w t s))
    (hq : RealRooted6 (centeredSextic U V W T S)) :
    let a := 24*u*U/35
    let b := 2*(u^2+5*w)*(U^2+5*W)/105
    let c := 4*(2*s+2*u*w/15-v^2/20)*(2*S+2*U*W/15-V^2/20)/7
    0 ≤ a ∧ 0 ≤ b ∧ 0 ≤ c ∧
      0 ≤ a^2*b^2-4*b^3-4*a^3*c-27*c^2+18*a*b*c := by
  obtain ⟨r, hr⟩ := hp
  obtain ⟨r', hr'⟩ := hq
  have hc := root_sum_zero _ r hr (by simp [centeredSextic])
  have hc' := root_sum_zero _ r' hr' (by simp [centeredSextic])
  have he := D5.S3.Zeros.CoefficientBounds.SexticEnvelope.centered_real_sextic_envelope r hc
  have he' := D5.S3.Zeros.CoefficientBounds.SexticEnvelope.centered_real_sextic_envelope r' hc'
  have hd := D5.S3.Zeros.CoefficientBounds.SexticDiscriminant.centered_real_sextic_discriminant
    r r' hc hc'
  dsimp only at he he' hd
  rw [← hr] at he
  rw [← hr'] at he'
  rw [← hr, ← hr'] at hd
  have hA : 0 ≤ -u := by simpa [centeredSextic] using he.1
  have hA' : 0 ≤ -U := by simpa [centeredSextic] using he'.1
  have hB : 0 ≤ u^2+5*w := by simpa [centeredSextic] using he.2.1
  have hB' : 0 ≤ U^2+5*W := by simpa [centeredSextic] using he'.2.1
  have hZ : 0 ≤ -(2*s+2*u*w/15-v^2/20) := by
    simpa [centeredSextic] using he.2.2.2.1
  have hZ' : 0 ≤ -(2*S+2*U*W/15-V^2/20) := by
    simpa [centeredSextic] using he'.2.2.2.1
  dsimp only
  refine ⟨?_, ?_, ?_, ?_⟩
  · nlinarith only [mul_nonneg hA hA']
  · exact div_nonneg (mul_nonneg (mul_nonneg (by norm_num) hB) hB') (by norm_num)
  · nlinarith only [mul_nonneg hZ hZ']
  · norm_num [centeredSextic] at hd
    nlinarith only [hd]

/-- Three nonnegative squared roots produce six real roots with multiplicity. -/
theorem centered_real_rooted (u v w t s U V W T S : ℝ)
    (hp : RealRooted6 (centeredSextic u v w t s))
    (hq : RealRooted6 (centeredSextic U V W T S)) :
    RealRooted6 (square6 (centeredSextic u v w t s) (centeredSextic U V W T S)) := by
  obtain ⟨ha, hb, hc, hd⟩ := centered_data u v w t s U V W T S hp hq
  obtain ⟨x, y, z, hx, hy, hz, hf⟩ := cubic_nonnegative_factorization _ _ _ ha hb hc hd
  have heven := congrArg (fun p : ℝ[X] => p.comp (X^2)) hf
  simp only [sub_comp, add_comp, mul_comp, pow_comp, X_comp, C_comp,
    ← pow_mul, Nat.reduceMul] at heven
  refine ⟨![Real.sqrt x, -Real.sqrt x, Real.sqrt y, -Real.sqrt y,
    Real.sqrt z, -Real.sqrt z], ?_⟩
  rw [centered_expansion, heven]
  have hxC : (C (Real.sqrt x) : ℝ[X])^2 = C x := by rw [← map_pow, Real.sq_sqrt hx]
  have hyC : (C (Real.sqrt y) : ℝ[X])^2 = C y := by rw [← map_pow, Real.sq_sqrt hy]
  have hzC : (C (Real.sqrt z) : ℝ[X])^2 = C z := by rw [← map_pow, Real.sq_sqrt hz]
  calc
    _ = (X^2-(C (Real.sqrt x))^2)*(X^2-(C (Real.sqrt y))^2)*
        (X^2-(C (Real.sqrt z))^2) := by rw [hxC, hyC, hzC]
    _ = _ := by simp [Fin.prod_univ_succ]; ring

private theorem exists_sextic (p : ℝ[X]) (hp : RealRooted6 p) :
    ∃ a u v w t s : ℝ, p = sextic a u v w t s := by
  obtain ⟨r, hr⟩ := hp
  have hm : p.Monic := hr ▸ monic_prod_X_sub_C r Finset.univ
  have hn : p.natDegree = 6 := by
    rw [hr, natDegree_prod_of_monic _ _ (fun i _ => monic_X_sub_C (r i))]
    simp
  have hc : p.coeff 6 = 1 := by rw [← hn]; exact hm.coeff_natDegree
  refine ⟨p.coeff 5, p.coeff 4, p.coeff 3, p.coeff 2, p.coeff 1, p.coeff 0, ?_⟩
  calc
    p = ∑ i ∈ Finset.range (6+1), C (p.coeff i)*X^i :=
      p.as_sum_range_C_mul_X_pow' (by omega)
    _ = _ := by norm_num [Finset.sum_range_succ, hc, sextic]; ring

private theorem sextic_translate (a u v w t s h : ℝ) :
    (sextic a u v w t s).comp (X+C h) =
      sextic (a+6*h) (u+5*a*h+15*h^2) (v+4*u*h+10*a*h^2+20*h^3)
        (w+3*v*h+6*u*h^2+10*a*h^3+15*h^4)
        (t+2*w*h+3*v*h^2+4*u*h^3+5*a*h^4+6*h^5)
        (s+t*h+w*h^2+v*h^3+u*h^4+a*h^5+h^6) := by
  simp [sextic, map_add, map_mul, map_pow, map_ofNat]
  ring

private theorem real_rooted_translate (p : ℝ[X]) (hp : RealRooted6 p) (h : ℝ) :
    RealRooted6 (p.comp (X+C h)) := by
  obtain ⟨r, hr⟩ := hp
  refine ⟨fun i => r i-h, ?_⟩
  rw [hr, Polynomial.prod_comp]
  apply Finset.prod_congr rfl
  intro i _
  simp [map_sub]
  ring

/-- Sym in degree six is unchanged by any real translation of its input. -/
theorem symmetrize_translation (p : ℝ[X]) (hp : RealRooted6 p) (h : ℝ) :
    symmetrize 6 (p.comp (X+C h)) = symmetrize 6 p := by
  obtain ⟨a, u, v, w, t, s, rfl⟩ := exists_sextic p hp
  rw [sextic_translate, symmetrize_sextic, symmetrize_sextic]
  congr 1 <;> ring

private theorem centered_representative (p : ℝ[X]) (hp : RealRooted6 p) :
    ∃ u v w t s : ℝ, RealRooted6 (centeredSextic u v w t s) ∧
      symmetrize 6 (centeredSextic u v w t s) = symmetrize 6 p := by
  obtain ⟨a, u, v, w, t, s, rfl⟩ := exists_sextic p hp
  have hr := real_rooted_translate _ hp (-a/6)
  have hs := symmetrize_translation _ hp (-a/6)
  rw [sextic_translate] at hr hs
  have ha : a+6*(-a/6) = 0 := by ring
  rw [ha] at hr hs
  simp only [sextic, C_0, zero_mul, add_zero] at hr hs
  exact ⟨_, _, _, _, _, hr, hs⟩

/-- Campbell--Morales--Perales Conjecture 5.3 at degree six, for all products
of six real linear factors, with repeated and zero roots permitted. -/
theorem real_rooted (p q : ℝ[X]) (hp : RealRooted6 p) (hq : RealRooted6 q) :
    RealRooted6 (square6 p q) := by
  obtain ⟨u, v, w, t, s, hp', hsp⟩ := centered_representative p hp
  obtain ⟨U, V, W, T, S, hq', hsq⟩ := centered_representative q hq
  have h := centered_real_rooted u v w t s U V W T S hp' hq'
  simpa only [square6, hsp, hsq] using h

#print axioms centered_expansion
#print axioms cubic_nonnegative_factorization
#print axioms centered_data
#print axioms centered_real_rooted
#print axioms symmetrize_translation
#print axioms real_rooted

end D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeSix
