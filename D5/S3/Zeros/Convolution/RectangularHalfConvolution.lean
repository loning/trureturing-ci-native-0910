/- GID: D5/S3/Zeros/Convolution/RectangularHalfConvolution
   generality: I
   mirror-B: D5/B/S3/Zeros/Convolution/RectangularHalfConvolution
   mirror-E: none(waiver:symbolic-conditional-preservation)
   anchors: []
   utility: none
   digest: At alpha=-1/2 rectangular convolution preserves nonnegative roots assuming BB. -/

import D5.S3.Zeros.Convolution.FiniteAdditiveSymbol
import D5.S3.Zeros.Convolution.EvenPolynomialRoots

/-!
Conditional arXiv:2502.00254v2 Corollary 3.14, for every m >= 1.
The only external hypothesis is `FiniteAdditiveSymbol.FiniteSymbolCriterion`,
the BB finite-symbol criterion itself, universally quantified over operators.
No stability of the target output is assumed. The upstream citation and probe
axiom readings are recorded in FiniteAdditiveSymbol's module documentation.
There is no upstream source transplant and no new axiom.

Definition 3.10 uses the PRODUCT prefactor, as corrected by atom
32d6fbf2c0f014c88eb8ac4e685fa33d24760bc21513f4f60b2f792c444dc628.
The signed elementaryCoeff and additiveConvolution are reused from #6065;
the degree-two definitions of #6044 are not used. Coefficient statements have
the explicit bound k <= m. The new pairing identity and even-index sum prove
Proposition 3.12's application identity, then the two root-geometry directions
transport additive preservation to the required nonnegative-root conclusion.

Admission basis: rule-11-upstream-wrapper. Proof shape of the application is
content: the variable-degree pairing and even-index convolution calculation
are on the live path of `preserves_nonnegative_roots`. Other public theorems
are its coefficient/degree companions or the final coefficient-specified form.
All results are symbolic; utility is none, not a finite numerical reduction.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Zeros.Convolution.RectangularHalfConvolution

open Polynomial
open scoped BigOperators
open D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
open D5.S3.Zeros.Convolution.FiniteConvolutionCoefficients
open D5.S3.Zeros.Convolution.FiniteAdditiveSymbol
open D5.S3.Zeros.Convolution.EvenPolynomialRoots

/-- The product F_m(k), including the empty product F_m(0)=1. -/
def weight (m k : ℕ) : ℝ :=
  ∏ j ∈ Finset.range k, ((m : ℝ)-j) * ((m : ℝ)-1/2-j)

/-- Definition 3.10 at alpha=-1/2, reconstructed only through degree m. -/
def rectangularBoxplus (m : ℕ) (p q : ℝ[X]) : ℝ[X] :=
  ∑ k ∈ Finset.range (m+1), C ((-1)^k * (weight m k *
    ∑ i ∈ Finset.range (k+1), elementaryCoeff m p i * elementaryCoeff m q (k-i) /
      (weight m i * weight m (k-i)))) * X^(m-k)

/-- Every denominator occurring in the degree-bounded formula is positive. -/
theorem weight_pos (m k : ℕ) (hk : k ≤ m) : 0 < weight m k := by
  apply Finset.prod_pos
  intro j hj
  have hj' : j+1 ≤ m := by have := Finset.mem_range.mp hj; omega
  have hreal : (j : ℝ)+1 ≤ m := by exact_mod_cast hj'
  exact mul_pos (by linarith) (by linarith)

private theorem weight_succ (m k : ℕ) :
    weight m (k+1) = weight m k * (((m : ℝ)-k) * ((m : ℝ)-1/2-k)) := by
  simp [weight, Finset.prod_range_succ]

/-- Pairing consecutive factors is Proposition 3.12's half-parameter identity. -/
theorem doubled_falling (m k : ℕ) :
    ((2*m).descFactorial (2*k) : ℝ) = 4^k * weight m k := by
  rw [← descPochhammer_eval_eq_descFactorial ℝ]
  induction k with
  | zero => simp [weight]
  | succ k ih =>
      rw [show 2*(k+1) = (2*k+1)+1 by omega,
        descPochhammer_succ_eval, descPochhammer_succ_eval, ih,
        pow_succ, weight_succ]
      push_cast
      ring

/-- Exact signed coefficient characterization, including the leading coefficient. -/
theorem definition_consistency (m : ℕ) (p q : ℝ[X]) (k : ℕ) (hk : k ≤ m) :
    elementaryCoeff m (rectangularBoxplus m p q) k = weight m k *
      ∑ i ∈ Finset.range (k+1), elementaryCoeff m p i * elementaryCoeff m q (k-i) /
        (weight m i * weight m (k-i)) := by
  rw [elementaryCoeff, rectangularBoxplus, coeff_reverse_sum m _ k hk,
    ← mul_assoc, ← mul_pow]
  norm_num

private theorem rectangular_coeff (m : ℕ) (p q : ℝ[X]) (k : ℕ) (hk : k ≤ m) :
    (rectangularBoxplus m p q).coeff (m-k) = weight m k *
      ∑ i ∈ Finset.range (k+1), p.coeff (m-i) * q.coeff (m-(k-i)) /
        (weight m i * weight m (k-i)) := by
  rw [rectangularBoxplus, coeff_reverse_sum m _ k hk]
  simp only [elementaryCoeff]
  rw [mul_left_comm]
  congr 1
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  rw [← mul_div_assoc, signed_coefficient_product k i (by simpa using hi)]

private theorem rectangular_degree_le (m : ℕ) (p q : ℝ[X]) :
    (rectangularBoxplus m p q).natDegree ≤ m := by
  apply natDegree_le_iff_coeff_eq_zero.mpr
  intro k hk
  exact coeff_reverse_sum_above m _ k hk

/-- Monicity and exact degree are retained; in particular the output is not zero. -/
theorem monic_natDegree (m : ℕ) (p q : ℝ[X])
    (hp : p.Monic) (hq : q.Monic) (hpd : p.natDegree = m) (hqd : q.natDegree = m) :
    (rectangularBoxplus m p q).Monic ∧ (rectangularBoxplus m p q).natDegree = m := by
  have hpn : p.coeff m = 1 := hpd ▸ hp.coeff_natDegree
  have hqn : q.coeff m = 1 := hqd ▸ hq.coeff_natDegree
  have hc : (rectangularBoxplus m p q).coeff m = 1 := by
    simpa [weight, hpn, hqn] using rectangular_coeff m p q 0 (by omega)
  exact ⟨monic_of_natDegree_le_of_coeff_eq_one m (rectangular_degree_le m p q) hc,
    natDegree_eq_of_le_of_coeff_ne_zero (rectangular_degree_le m p q) (hc ▸ one_ne_zero)⟩

private theorem even_coeff (m k : ℕ) (p : ℝ[X]) :
    (expand ℝ 2 p).coeff (2*m-2*k) = p.coeff (m-k) := by
  rw [← Nat.mul_sub_left_distrib, coeff_expand_mul' (by norm_num)]

private theorem odd_coeff (m k : ℕ) (p : ℝ[X]) (hk : 2 * k + 1 ≤ 2 * m) :
    (expand ℝ 2 p).coeff (2*m-(2*k+1)) = 0 := by
  rw [coeff_expand (by norm_num), if_neg (by omega)]

private theorem sum_even (f : ℕ → ℝ) : ∀ k : ℕ,
    (∀ i < k, f (2*i+1) = 0) →
    ∑ i ∈ Finset.range (2*k+1), f i = ∑ i ∈ Finset.range (k+1), f (2*i) := by
  intro k
  induction k with
  | zero => intro _; simp
  | succ k ih =>
      intro ho
      rw [show 2*(k+1)+1 = (2*k+1)+1+1 by omega,
        Finset.sum_range_succ, Finset.sum_range_succ,
        ih (fun i hi => ho i (by omega)), ho k (by omega), add_zero,
        Finset.sum_range_succ]
      simp only [Finset.sum_range_succ, show 2*k+1+1 = 2*(k+1) by omega]

private theorem even_additive_coeff (m k : ℕ) (p q : ℝ[X]) (hk : k ≤ m) :
    (additiveConvolution (2*m) (expand ℝ 2 p) (expand ℝ 2 q)).coeff (2*m-2*k) =
      (rectangularBoxplus m p q).coeff (m-k) := by
  rw [coeff_additiveConvolution (2*m) _ _ (2*k) (by omega), rectangular_coeff m p q k hk]
  rw [sum_even _ k (by
    intro i hi
    rw [odd_coeff m i p (by omega), zero_mul, zero_div])]
  rw [Finset.mul_sum, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  have hi' : i ≤ k := by simpa using hi
  have hik : 2*k-2*i = 2*(k-i) := by omega
  rw [hik, even_coeff, even_coeff, doubled_falling, doubled_falling, doubled_falling]
  have hpow : (4 : ℝ)^k = 4^i * 4^(k-i) := by rw [← pow_add, Nat.add_sub_of_le hi']
  rw [hpow]
  have hwi := (weight_pos m i (hi'.trans hk)).ne'
  have hwj := (weight_pos m (k-i) (by omega)).ne'
  field_simp

private theorem odd_additive_coeff (m k : ℕ) (p q : ℝ[X]) (hk : 2 * k + 1 ≤ 2 * m) :
    (additiveConvolution (2*m) (expand ℝ 2 p) (expand ℝ 2 q)).coeff (2*m-(2*k+1)) = 0 := by
  rw [coeff_additiveConvolution (2*m) _ _ (2*k+1) hk]
  suffices hs : (∑ i ∈ Finset.range (2*k+1+1),
      (expand ℝ 2 p).coeff (2*m-i) * (expand ℝ 2 q).coeff (2*m-(2*k+1-i)) /
        (((2*m).descFactorial i : ℝ) * ((2*m).descFactorial (2*k+1-i) : ℝ))) = 0 by
    rw [hs, mul_zero]
  apply Finset.sum_eq_zero
  intro i hi
  have hi' : i ≤ 2*k+1 := by simpa using hi
  by_cases he : 2 ∣ i
  · rw [coeff_expand (by norm_num) q,
      if_neg (show ¬2 ∣ 2*m-(2*k+1-i) by omega), mul_zero, zero_div]
  · rw [coeff_expand (by norm_num) p,
      if_neg (show ¬2 ∣ 2*m-i by omega), zero_mul, zero_div]

/-- Proposition 3.12 at alpha=-1/2, as equality of actual reconstructed polynomials. -/
theorem evenization_convolution (m : ℕ) (p q : ℝ[X]) :
    expand ℝ 2 (rectangularBoxplus m p q) =
      additiveConvolution (2*m) (expand ℝ 2 p) (expand ℝ 2 q) := by
  ext t
  by_cases ht : t ≤ 2*m
  · let l := 2*m-t
    have hl : l ≤ 2*m := by dsimp [l]; omega
    have htl : t = 2*m-l := by dsimp [l]; omega
    by_cases he : 2 ∣ l
    · obtain ⟨k, hk⟩ := he
      rw [htl, hk, even_coeff, even_additive_coeff m k p q (by omega)]
    · have hlodd : l = 2*(l/2)+1 := by omega
      rw [htl, hlodd, odd_coeff m (l/2) _ (by omega),
        odd_additive_coeff m (l/2) p q (by omega)]
  · have hleft : (expand ℝ 2 (rectangularBoxplus m p q)).natDegree ≤ 2*m := by
      rw [natDegree_expand]
      have := rectangular_degree_le m p q
      omega
    rw [coeff_eq_zero_of_natDegree_lt (by omega),
      coeff_eq_zero_of_natDegree_lt (lt_of_le_of_lt (additive_natDegree_le _ _ _) (by omega))]

/-- Conditional Corollary 3.14 for every positive degree, including all multiplicities. -/
theorem preserves_nonnegative_roots (hBB : FiniteSymbolCriterion) (m : ℕ) (_hm : 1 ≤ m)
    (p q : ℝ[X]) (hp : p.Monic) (hq : q.Monic)
    (hpd : p.natDegree = m) (hqd : q.natDegree = m)
    (hps : p.Splits) (hqs : q.Splits)
    (hpn : ∀ x : ℝ, p.IsRoot x → 0 ≤ x) (hqn : ∀ x : ℝ, q.IsRoot x → 0 ≤ x) :
    (rectangularBoxplus m p q).Monic ∧ (rectangularBoxplus m p q).natDegree = m ∧
      (rectangularBoxplus m p q).Splits ∧
        ∀ x : ℝ, (rectangularBoxplus m p q).IsRoot x → 0 ≤ x := by
  have hr := monic_natDegree m p q hp hq hpd hqd
  have hes : (expand ℝ 2 (rectangularBoxplus m p q)).Splits := by
    rw [evenization_convolution]
    apply additive_splits hBB (2*m) _ _ (hp.expand (by norm_num)) (hq.expand (by norm_num))
      (by rw [natDegree_expand, hpd]; omega) (by rw [natDegree_expand, hqd]; omega)
      (splits_expand_two hps hpn) (splits_expand_two hqs hqn)
  exact ⟨hr.1, hr.2, nonnegative_roots_of_splits_expand_two hr.1.ne_zero hes⟩

/-- The coefficient specification uniquely identifies the reconstructed polynomial. -/
theorem eq_of_coefficients (m : ℕ) (p q r : ℝ[X]) (hr : r.natDegree ≤ m)
    (hc : ∀ k ≤ m, elementaryCoeff m r k = weight m k *
      ∑ i ∈ Finset.range (k + 1), elementaryCoeff m p i * elementaryCoeff m q (k - i) /
        (weight m i * weight m (k - i))) : r = rectangularBoxplus m p q := by
  ext t
  by_cases ht : t ≤ m
  · have h := (hc (m-t) (by omega)).trans (definition_consistency m p q (m-t) (by omega)).symm
    simp only [elementaryCoeff, Nat.sub_sub_self ht] at h
    exact mul_left_cancel₀ (pow_ne_zero _ (by norm_num : (-1 : ℝ) ≠ 0)) h
  · rw [coeff_eq_zero_of_natDegree_lt (by omega),
      coeff_eq_zero_of_natDegree_lt (lt_of_le_of_lt (rectangular_degree_le m p q) (by omega))]

/-- The requested statement for any monic degree-m output satisfying the coefficient formula. -/
theorem preserves_of_coefficients (hBB : FiniteSymbolCriterion) (m : ℕ) (hm : 1 ≤ m)
    (p q r : ℝ[X]) (hp : p.Monic) (hq : q.Monic) (_hr : r.Monic)
    (hpd : p.natDegree = m) (hqd : q.natDegree = m) (hrd : r.natDegree = m)
    (hps : p.Splits) (hqs : q.Splits)
    (hpn : ∀ x : ℝ, p.IsRoot x → 0 ≤ x) (hqn : ∀ x : ℝ, q.IsRoot x → 0 ≤ x)
    (hc : ∀ k ≤ m, elementaryCoeff m r k = weight m k *
      ∑ i ∈ Finset.range (k+1), elementaryCoeff m p i * elementaryCoeff m q (k-i) /
        (weight m i * weight m (k-i))) : r.Splits ∧ ∀ x : ℝ, r.IsRoot x → 0 ≤ x := by
  rw [eq_of_coefficients m p q r hrd.le hc]
  exact (preserves_nonnegative_roots hBB m hm p q hp hq hpd hqd hps hqs hpn hqn).2.2

#print axioms weight_pos
#print axioms doubled_falling
#print axioms definition_consistency
#print axioms monic_natDegree
#print axioms evenization_convolution
#print axioms preserves_nonnegative_roots
#print axioms eq_of_coefficients
#print axioms preserves_of_coefficients

end D5.S3.Zeros.Convolution.RectangularHalfConvolution
