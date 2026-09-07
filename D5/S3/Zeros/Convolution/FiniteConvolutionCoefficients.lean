/- GID: D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients
   generality: I
   mirror-B: D5/B/S3/Zeros/Convolution/FiniteConvolutionCoefficients
   mirror-E: none(waiver:symbolic-coefficient-identities)
   anchors: []
   utility: none
   digest: Coefficient reconstruction for the existing finite additive convolution. -/

import D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour

/-!
Companion API for the arbitrary-degree definitions in #6065, used by
`FiniteAdditiveSymbol.operator_eq_additiveConvolution` and
`RectangularHalfConvolution.evenization_convolution` on their live paths.
The signed coefficient and additive convolution definitions are reused unchanged.
Reconstruction is restricted to indices at most the declared degree, avoiding
truncated natural subtraction beyond that degree. All results are symbolic;
there is no bounded computation or certified numerical instance.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Zeros.Convolution.FiniteConvolutionCoefficients

open Polynomial
open scoped BigOperators
open D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour

/-- Coefficients of a sum in descending degree order. -/
theorem coeff_reverse_sum {R : Type*} [CommRing R] (n : ℕ) (a : ℕ → R)
    (k : ℕ) (hk : k ≤ n) :
    (∑ i ∈ Finset.range (n+1), C (a i) * X^(n-i)).coeff (n-k) = a k := by
  classical
  simp only [finsetSum_coeff, coeff_C_mul_X_pow]
  rw [Finset.sum_eq_single k]
  · simp
  · intro i hi hik
    rw [if_neg]
    have hi' := Finset.mem_range.mp hi
    omega
  · intro h
    exact (h (Finset.mem_range.mpr (by omega))).elim

/-- Reconstruction has no coefficients above its degree bound. -/
theorem coeff_reverse_sum_above {R : Type*} [CommRing R] (n : ℕ) (a : ℕ → R)
    (k : ℕ) (hk : n < k) :
    (∑ i ∈ Finset.range (n+1), C (a i) * X^(n-i)).coeff k = 0 := by
  classical
  rw [finsetSum_coeff]
  apply Finset.sum_eq_zero
  intro i hi
  simp only [coeff_C_mul_X_pow, if_neg (show n-i ≠ k by omega)]

/-- The two signed input coefficients cancel the output's reconstruction sign. -/
theorem signed_coefficient_product (k i : ℕ) (hi : i ≤ k) (a b : ℝ) :
    (-1)^k * (((-1)^i * a) * ((-1)^(k-i) * b)) = a*b := by
  have hs : (-1 : ℝ)^i * (-1)^(k-i) = (-1)^k := by
    rw [← pow_add, Nat.add_sub_of_le hi]
  calc
    _ = ((-1 : ℝ)^k * ((-1)^i * (-1)^(k-i))) * (a*b) := by ring
    _ = a*b := by rw [hs, ← mul_pow]; norm_num

/-- Unsigned form of the existing additive convolution coefficient formula. -/
theorem coeff_additiveConvolution (n : ℕ) (p q : ℝ[X]) (k : ℕ) (hk : k ≤ n) :
    (additiveConvolution n p q).coeff (n-k) = (n.descFactorial k : ℝ) *
      ∑ i ∈ Finset.range (k+1), p.coeff (n-i) * q.coeff (n-(k-i)) /
        ((n.descFactorial i : ℝ) * (n.descFactorial (k-i) : ℝ)) := by
  change (∑ j ∈ Finset.range (n+1), C ((-1)^j *
    ((descPochhammer ℝ j).eval (n : ℝ) *
      ∑ i ∈ Finset.range (j+1), elementaryCoeff n p i * elementaryCoeff n q (j-i) /
        ((descPochhammer ℝ i).eval (n : ℝ) *
          (descPochhammer ℝ (j-i)).eval (n : ℝ)))) * X^(n-j)).coeff (n-k) = _
  rw [coeff_reverse_sum n _ k hk]
  simp only [descPochhammer_eval_eq_descFactorial, elementaryCoeff]
  rw [mul_left_comm]
  congr 1
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  rw [← mul_div_assoc, signed_coefficient_product k i (by simpa using hi)]

/-- The reused additive definition has degree at most its degree parameter. -/
theorem additive_natDegree_le (n : ℕ) (p q : ℝ[X]) :
    (additiveConvolution n p q).natDegree ≤ n := by
  apply natDegree_le_iff_coeff_eq_zero.mpr
  intro k hk
  apply coeff_reverse_sum_above n _ k hk

/-- Monic inputs of exact degree give a monic output of that same degree. -/
theorem additive_monic_natDegree (n : ℕ) (p q : ℝ[X])
    (hp : p.Monic) (hq : q.Monic) (hpd : p.natDegree = n) (hqd : q.natDegree = n) :
    (additiveConvolution n p q).Monic ∧ (additiveConvolution n p q).natDegree = n := by
  have hpn : p.coeff n = 1 := hpd ▸ hp.coeff_natDegree
  have hqn : q.coeff n = 1 := hqd ▸ hq.coeff_natDegree
  have hc : (additiveConvolution n p q).coeff n = 1 := by
    simpa [hpn, hqn] using coeff_additiveConvolution n p q 0 (by omega)
  exact ⟨monic_of_natDegree_le_of_coeff_eq_one n (additive_natDegree_le n p q) hc,
    natDegree_eq_of_le_of_coeff_ne_zero (additive_natDegree_le n p q) (hc ▸ one_ne_zero)⟩

#print axioms coeff_reverse_sum
#print axioms coeff_reverse_sum_above
#print axioms signed_coefficient_product
#print axioms coeff_additiveConvolution
#print axioms additive_natDegree_le
#print axioms additive_monic_natDegree

end D5.S3.Zeros.Convolution.FiniteConvolutionCoefficients
