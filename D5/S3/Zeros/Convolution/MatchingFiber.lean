/- GID: D5/S3/Zeros/Convolution/MatchingFiber
   generality: G
   mirror-B: D5/B/S3/Zeros/Convolution/MatchingFiber
   mirror-E: none(waiver:symbolic-matching-identity)
   anchors: []
   utility: none
   digest: All-degree matching sums and symmetrization coefficient normalization. -/

import D5.S3.Zeros.Convolution.FiniteConvolutionCoefficients
import Mathlib.Data.Sym.Sym2
import Mathlib.Data.Fintype.Powerset
import Mathlib.Algebra.Polynomial.Eval.Degree

/-!
`Matching` and its finite instance describe arbitrary finite index matchings.
`edgeSquare`, `matchingSum`, and `rootPolynomial` are symbolic algebraic definitions.
`MatchingIdentity` records the unproved all-degree target as a proposition.
`coeff_reflection` and `symmetrize_coefficient` normalize the existing definitions.
None is a bounded enumeration, checker, numerical reduction, or certified instance.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Zeros.Convolution.MatchingFiber

open Polynomial
open scoped BigOperators
open D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
open D5.S3.Zeros.Convolution.FiniteConvolutionCoefficients

/-- Unordered, loop-free, vertex-disjoint edges on root indices. -/
def Matching (n k : ℕ) :=
  { M : Finset (Sym2 (Fin n)) // M.card = k ∧
    (∀ e ∈ M, ¬ e.IsDiag) ∧
    (M : Set (Sym2 (Fin n))).Pairwise (fun e f => Disjoint e.toFinset f.toFinset) }

noncomputable instance (n k : ℕ) : Fintype (Matching n k) := by
  classical
  unfold Matching
  exact Fintype.ofFinite _

/-- Symmetry makes this a well-defined square on unordered pairs. -/
def edgeSquare {n : ℕ} {R : Type*} [CommRing R] (r : Fin n → R) : Sym2 (Fin n) → R :=
  Sym2.lift ⟨fun i j => (r i - r j) ^ 2, by intro i j; ring⟩

def matchingSum {n : ℕ} {R : Type*} [CommRing R] (r : Fin n → R) (k : ℕ) : R :=
  ∑ M : Matching n k, ∏ e ∈ M.val, edgeSquare r e

def rootPolynomial {n : ℕ} (r : Fin n → ℝ) : ℝ[X] :=
  ∏ i, (X - C (r i))

/-- The full target, recorded as a proposition and not asserted as a theorem. -/
def MatchingIdentity : Prop := ∀ (n k : ℕ), 2 * k ≤ n → ∀ (r : Fin n → ℝ),
  (-1 : ℝ) ^ k * (symmetrize n (rootPolynomial r)).coeff (n - 2 * k) =
    matchingSum r k / (n.descFactorial k : ℝ)

/-- Reflection multiplies the descending coefficient by its alternating sign. -/
theorem coeff_reflection (n j : ℕ) (hj : j ≤ n) (p : ℝ[X]) :
    (dilate n (-1) p).coeff (n - j) = (-1 : ℝ) ^ j * p.coeff (n - j) := by
  simp only [dilate, coeff_C_mul, comp_C_mul_X_coeff, inv_neg, inv_one]
  have hn : (-1 : ℝ) ^ n = (-1) ^ j * (-1) ^ (n - j) := by
    rw [← pow_add, Nat.add_sub_of_le hj]
  have hs : (-1 : ℝ) ^ (n - j) * (-1) ^ (n - j) = 1 := by rw [← mul_pow]; norm_num
  rw [hn]
  calc
    _ = (-1 : ℝ) ^ j * p.coeff (n - j) * ((-1) ^ (n - j) * (-1) ^ (n - j)) := by ring
    _ = _ := by rw [hs, mul_one]

/-- Corrected step (1), derived from the frozen definition at arbitrary degree. -/
theorem symmetrize_coefficient (n k : ℕ) (hk : 2 * k ≤ n) (p : ℝ[X]) :
    (-1 : ℝ) ^ k * (symmetrize n p).coeff (n - 2 * k) =
      (-1 : ℝ) ^ k * (n.descFactorial (2 * k) : ℝ) *
        ∑ i ∈ Finset.range (2 * k + 1),
          (-1 : ℝ) ^ i * elementaryCoeff n p i * elementaryCoeff n p (2 * k - i) /
            ((n.descFactorial i : ℝ) * (n.descFactorial (2 * k - i) : ℝ)) := by
  rw [symmetrize, coeff_additiveConvolution n p _ (2 * k) hk, mul_assoc]
  congr 1
  congr 1
  apply Finset.sum_congr rfl
  intro i hi
  rw [coeff_reflection n (2 * k - i) (by omega)]
  unfold elementaryCoeff
  have hs : (-1 : ℝ) ^ i * (-1) ^ i = 1 := by rw [← mul_pow]; norm_num
  congr 1
  calc
    _ = ((-1 : ℝ) ^ i * (-1) ^ i) *
        (p.coeff (n - i) * ((-1) ^ (2 * k - i) * p.coeff (n - (2 * k - i)))) := by
          rw [hs, one_mul]
    _ = _ := by ring

#print axioms coeff_reflection
#print axioms symmetrize_coefficient

end D5.S3.Zeros.Convolution.MatchingFiber
