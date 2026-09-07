/- GID: D5/S3/Zeros/Convolution/FiniteAdditiveSymbol
   generality: I
   mirror-B: D5/B/S3/Zeros/Convolution/FiniteAdditiveSymbol
   mirror-E: none(waiver:explicit-finite-symbol-hypothesis)
   anchors: []
   utility: none
   digest: A finite-symbol hypothesis implies general additive convolution preservation. -/

import D5.S3.Zeros.Convolution.FiniteConvolutionCoefficients
import Mathlib.Algebra.Polynomial.Taylor
import Mathlib.Algebra.Polynomial.Splits
import Mathlib.Analysis.Complex.Polynomial.Basic

/-!
Borcea-Branden is an EXPLICIT HYPOTHESIS, not an axiom declaration.
`FiniteSymbolCriterion` is positive finite-symbol sufficiency for every real
linear polynomial map and every degree bound, allowing zero output.
It does not assume stability or splitting of a convolution output.

Upstream source: https://github.com/PerAlexandersson/RealRooted at
acd0ec31118a155b083c8dd45af2015492ce0c10 (acd0ec3), declarations
`RealRooted.BorceaBranden.finiteSymbolTheorem` and
`RealRooted.BorceaBranden.finiteSymbol_preservesRealRootedUpTo`.
Probe r13-probe-0907/attempt-1/upstream-axioms.log records both axiom closures
as [propext, Classical.choice, Quot.sound], with no BB hypothesis parameter.
The source signatures were read back by the implementation seat.
The same probe records a failed compatibility build at this repository's pin;
the original proof is not imported or transplanted. The present theorem is
therefore conditional, despite that verified upstream witness.

The finite symbol uses the standard iterated-polynomial coordinates R[x][y];
evaluation is exactly sum_k choose(n,k) T(X^k)(z) w^(n-k), the expanded
upstream MvPolynomial symbol in variables 0 and 1. The operator is built with
Mathlib Hasse derivatives, whose Taylor identity proves its symbol is Q(x+y).
Its equality with the arbitrary-degree #6065 additiveConvolution is proved
coefficientwise, so no second convolution definition is introduced.

Admission basis: rule-11-upstream-wrapper. The concrete consumer is
`RectangularHalfConvolution.preserves_nonnegative_roots`, implementing
arXiv:2502.00254v2 Corollary 3.14 via Proposition 3.12. The coefficient need
is Definition 3.10's corrected PRODUCT-prefactor clause, atom
32d6fbf2c0f014c88eb8ac4e685fa33d24760bc21513f4f60b2f792c444dc628.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Zeros.Convolution.FiniteAdditiveSymbol

open Polynomial
open scoped BigOperators
open D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
open D5.S3.Zeros.Convolution.FiniteConvolutionCoefficients

/-- `T((x+y)^n)`, with x in the coefficient ring and y the outer variable. -/
def finiteSymbol (n : ℕ) (T : ℝ[X] →ₗ[ℝ] ℝ[X]) : Polynomial ℝ[X] :=
  ∑ k ∈ Finset.range (n+1), C ((n.choose k : ℝ) • T (X^k)) * X^(n-k)

/-- Positive finite-symbol sufficiency, in explicit evaluation coordinates. -/
def FiniteSymbolCriterion : Prop :=
  ∀ (n : ℕ) (T : ℝ[X] →ₗ[ℝ] ℝ[X]),
    (∀ z w : ℂ, 0 < z.im → 0 < w.im →
      (finiteSymbol n T).eval₂ (eval₂RingHom Complex.ofRealHom z) w ≠ 0) →
    ∀ p : ℝ[X], p.natDegree ≤ n → p.Splits → T p = 0 ∨ (T p).Splits

/-- The linear map with monomial images `HasseDeriv (n-k) q / choose n k`. -/
def convolutionOperator (n : ℕ) (q : ℝ[X]) : ℝ[X] →ₗ[ℝ] ℝ[X] :=
  ∑ k ∈ Finset.range (n+1), (n.choose k : ℝ)⁻¹ •
    (lcoeff ℝ k).smulRight (hasseDeriv (n-k) q)

private theorem operator_X_pow (n k : ℕ) (q : ℝ[X]) (hk : k ≤ n) :
    convolutionOperator n q (X^k) = (n.choose k : ℝ)⁻¹ • hasseDeriv (n-k) q := by
  simp [convolutionOperator, LinearMap.sum_apply, LinearMap.smul_apply,
    LinearMap.smulRight_apply, coeff_X_pow, hk, Finset.mem_range]

private theorem choose_ne_zero (n k : ℕ) (hk : k ≤ n) : (n.choose k : ℝ) ≠ 0 := by
  exact_mod_cast (Nat.choose_pos hk).ne'

private theorem taylor_map_coeff (q : ℝ[X]) (k : ℕ) :
    (taylor (X : ℝ[X]) (q.map C)).coeff k = hasseDeriv k q := by
  rw [taylor_coeff]
  have hmap : hasseDeriv k (q.map C) = (hasseDeriv k q).map C := by
    ext j
    simp [hasseDeriv_coeff]
  rw [hmap, eval_map, eval₂_C_X]

/-- The finite algebraic symbol is exactly the translated second input. -/
theorem finiteSymbol_eq_translation (n : ℕ) (q : ℝ[X]) (hq : q.natDegree ≤ n) :
    finiteSymbol n (convolutionOperator n q) = taylor (X : ℝ[X]) (q.map C) := by
  have hterm (k : ℕ) (hk : k ∈ Finset.range (n+1)) :
      (n.choose k : ℝ) • convolutionOperator n q (X^k) = hasseDeriv (n-k) q := by
    have hk' : k ≤ n := by simpa using hk
    rw [operator_X_pow n k q hk', smul_smul, mul_inv_cancel₀ (choose_ne_zero n k hk'),
      one_smul]
  simp only [finiteSymbol]
  simp_rw [Finset.sum_congr rfl (fun k hk => congrArg (fun p : ℝ[X] =>
    C p * (X : Polynomial ℝ[X])^(n-k)) (hterm k hk))]
  have ht : (taylor (X : ℝ[X]) (q.map C)).natDegree < n+1 := by
    rw [natDegree_taylor]
    exact lt_of_le_of_lt (natDegree_map_le.trans hq) (Nat.lt_succ_self n)
  rw [(taylor (X : ℝ[X]) (q.map C)).as_sum_range_C_mul_X_pow' ht]
  simp_rw [taylor_map_coeff]
  simpa using Finset.sum_range_reflect
    (fun k => C (hasseDeriv k q) * (X : Polynomial ℝ[X])^k) (n+1)

private theorem hasse_ratio (n k i : ℕ) (hk : k ≤ n) (hi : i ≤ k) :
    ((n-(k-i)).choose i : ℝ) / (n.choose i : ℝ) =
      (n.descFactorial k : ℝ) /
        ((n.descFactorial i : ℝ) * (n.descFactorial (k-i) : ℝ)) := by
  have hm : (n-(k-i)).descFactorial i * n.descFactorial (k-i) = n.descFactorial k := by
    simpa [Nat.sub_sub_self hi] using
      (Nat.descFactorial_mul_descFactorial (n := n) (m := k) (Nat.sub_le k i))
  rw [← hm, Nat.cast_mul, Nat.descFactorial_eq_factorial_mul_choose n i,
    Nat.descFactorial_eq_factorial_mul_choose (n-(k-i)) i]
  have hf : (i.factorial : ℝ) ≠ 0 := by exact_mod_cast i.factorial_ne_zero
  have hc := choose_ne_zero n i (hi.trans hk)
  have hd : (n.descFactorial (k-i) : ℝ) ≠ 0 := by
    exact_mod_cast (Nat.descFactorial_pos.mpr (by omega : k-i ≤ n)).ne'
  push_cast
  field_simp

private theorem operator_coeff (n : ℕ) (p q : ℝ[X]) (t : ℕ) :
    (convolutionOperator n q p).coeff t =
      ∑ i ∈ Finset.range (n+1), (n.choose i : ℝ)⁻¹ *
        (p.coeff i * ((t+(n-i)).choose (n-i) : ℝ) * q.coeff (t+(n-i))) := by
  simp [convolutionOperator, LinearMap.sum_apply, LinearMap.smul_apply,
    LinearMap.smulRight_apply, hasseDeriv_coeff, mul_assoc]

/-- The Hasse-derivative operator computes the existing additive convolution. -/
theorem operator_eq_additiveConvolution (n : ℕ) (p q : ℝ[X]) (hq : q.natDegree ≤ n) :
    convolutionOperator n q p = additiveConvolution n p q := by
  ext t
  rw [operator_coeff]
  by_cases ht : t ≤ n
  · let k := n-t
    have hk : k ≤ n := Nat.sub_le _ _
    have ht' : t = n-k := by dsimp [k]; omega
    rw [ht', coeff_additiveConvolution n p q k hk]
    rw [← Finset.sum_range_reflect (fun i => (n.choose i : ℝ)⁻¹ *
      (p.coeff i * ((n-k+(n-i)).choose (n-i) : ℝ) * q.coeff (n-k+(n-i)))) (n+1)]
    simp only [Nat.add_sub_cancel]
    have hsum : (∑ i ∈ Finset.range (n+1), (n.choose (n-i) : ℝ)⁻¹ *
        (p.coeff (n-i) * ((n-k+i).choose i : ℝ) * q.coeff (n-k+i))) =
        ∑ i ∈ Finset.range (k+1), (n.choose (n-i) : ℝ)⁻¹ *
          (p.coeff (n-i) * ((n-k+i).choose i : ℝ) * q.coeff (n-k+i)) := by
      symm
      apply Finset.sum_subset (Finset.range_mono (by omega))
      intro i hi hin
      have hi' := Finset.mem_range.mp hi
      have hin' : k < i := by simpa using hin
      rw [coeff_eq_zero_of_natDegree_lt (lt_of_le_of_lt hq (by omega)), mul_zero, mul_zero]
    have hreflect : (∑ i ∈ Finset.range (n+1), (n.choose (n-i) : ℝ)⁻¹ *
        (p.coeff (n-i) * ((n-k+(n-(n-i))).choose (n-(n-i)) : ℝ) *
          q.coeff (n-k+(n-(n-i))))) =
        ∑ i ∈ Finset.range (n+1), (n.choose (n-i) : ℝ)⁻¹ *
          (p.coeff (n-i) * ((n-k+i).choose i : ℝ) * q.coeff (n-k+i)) := by
      apply Finset.sum_congr rfl
      intro i hi
      have hni : n-(n-i) = i := Nat.sub_sub_self (by simpa using hi)
      simp only [hni]
    rw [hreflect, hsum, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i hi
    have hi' : i ≤ k := by simpa using hi
    have hiN := hi'.trans hk
    have hind : n-k+i = n-(k-i) := by omega
    rw [Nat.choose_symm hiN, hind]
    have hr := hasse_ratio n k i hk hi'
    calc
      _ = p.coeff (n-i) * q.coeff (n-(k-i)) *
          (((n-(k-i)).choose i : ℝ) / (n.choose i : ℝ)) := by ring
      _ = _ := by rw [hr]; ring
  · have htn : n < t := by omega
    rw [coeff_eq_zero_of_natDegree_lt ((additive_natDegree_le n p q).trans_lt htn)]
    apply Finset.sum_eq_zero
    intro i hi
    rw [coeff_eq_zero_of_natDegree_lt (lt_of_le_of_lt hq (by omega)), mul_zero, mul_zero]

private theorem translation_eval (q : ℝ[X]) (z w : ℂ) :
    (taylor (X : ℝ[X]) (q.map C)).eval₂ (eval₂RingHom Complex.ofRealHom z) w =
      q.eval₂ Complex.ofRealHom (w+z) := by
  simp [taylor_apply, eval₂_comp, eval₂_map, eval₂_add, RingHom.comp_assoc]

private theorem stable_translation {q : ℝ[X]} (hq : q.Splits) (hq0 : q ≠ 0)
    (z w : ℂ) (hz : 0 < z.im) (hw : 0 < w.im) :
    q.eval₂ Complex.ofRealHom (w+z) ≠ 0 := by
  intro hzero
  have hroot : (q.map Complex.ofRealHom).IsRoot (w+z) := by
    simpa only [IsRoot.def, eval_map] using hzero
  obtain ⟨a, ha⟩ := hq.mem_range_of_isRoot hq0 hroot
  have him := congrArg Complex.im ha
  change (a : ℂ).im = (w+z).im at him
  simp only [Complex.ofReal_im, Complex.add_im] at him
  linarith

/-- Conditional arbitrary-degree additive preservation; BB is the only external premise. -/
theorem additive_splits (hBB : FiniteSymbolCriterion) (n : ℕ) (p q : ℝ[X])
    (hp : p.Monic) (hq : q.Monic) (hpd : p.natDegree = n) (hqd : q.natDegree = n)
    (hps : p.Splits) (hqs : q.Splits) : (additiveConvolution n p q).Splits := by
  have hs : ∀ z w : ℂ, 0 < z.im → 0 < w.im →
      (finiteSymbol n (convolutionOperator n q)).eval₂
        (eval₂RingHom Complex.ofRealHom z) w ≠ 0 := by
    intro z w hz hw
    rw [finiteSymbol_eq_translation n q hqd.le, translation_eval]
    exact stable_translation hqs hq.ne_zero z w hz hw
  have hout := hBB n (convolutionOperator n q) hs p hpd.le hps
  rw [operator_eq_additiveConvolution n p q hqd.le] at hout
  exact hout.resolve_left (additive_monic_natDegree n p q hp hq hpd hqd).1.ne_zero

#print axioms finiteSymbol_eq_translation
#print axioms operator_eq_additiveConvolution
#print axioms additive_splits

end D5.S3.Zeros.Convolution.FiniteAdditiveSymbol
