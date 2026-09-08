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
import Mathlib.RingTheory.MvPolynomial.Symmetric.Defs

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

/-- The exponent vector of a squarefree monomial on a set of indices. -/
def squarefreeExponent {n : ℕ} (A : Finset (Fin n)) : Fin n →₀ ℕ :=
  ∑ x ∈ A, Finsupp.single x 1

/-- Indices in S occur twice; indices in T occur once. -/
def fiberExponent {n : ℕ} (S T : Finset (Fin n)) : Fin n →₀ ℕ :=
  squarefreeExponent S + squarefreeExponent S + squarefreeExponent T

private theorem squarefreeExponent_apply {n : ℕ} (A : Finset (Fin n)) (x : Fin n) :
    squarefreeExponent A x = if x ∈ A then 1 else 0 := by
  classical
  simp [squarefreeExponent, Finsupp.finsetSum_apply, Finsupp.single_apply]

private theorem fiber_pair_decomposition {n : ℕ} (S T A B : Finset (Fin n))
    (hST : Disjoint S T)
    (h : squarefreeExponent A + squarefreeExponent B = fiberExponent S T) :
    A = S ∪ (A ∩ T) ∧ B = S ∪ (T \ (A ∩ T)) := by
  have hx (x : Fin n) := congrArg (fun d : Fin n →₀ ℕ => d x) h
  simp only [fiberExponent, Finsupp.add_apply, squarefreeExponent_apply] at hx
  constructor <;> ext x
  all_goals
    have hp := hx x
    have hd : ¬ (x ∈ S ∧ x ∈ T) := fun h => Finset.disjoint_left.mp hST h.1 h.2
    by_cases ha : x ∈ A <;> by_cases hb : x ∈ B <;>
      by_cases hs : x ∈ S <;> by_cases ht : x ∈ T <;> simp_all

private theorem split_pair_exponent {n : ℕ} (S T U : Finset (Fin n))
    (hST : Disjoint S T) (hUT : U ⊆ T) :
    squarefreeExponent (S ∪ U) + squarefreeExponent (S ∪ (T \ U)) =
      fiberExponent S T := by
  ext x
  have hd : ¬ (x ∈ S ∧ x ∈ T) := fun h => Finset.disjoint_left.mp hST h.1 h.2
  have hu : x ∈ U → x ∈ T := fun h => hUT h
  simp only [fiberExponent, Finsupp.add_apply, squarefreeExponent_apply]
  by_cases hs : x ∈ S <;> by_cases ht : x ∈ T <;> by_cases hx : x ∈ U <;> simp_all

private theorem split_pair_inter {n : ℕ} (S T U : Finset (Fin n))
    (hST : Disjoint S T) (hUT : U ⊆ T) : (S ∪ U) ∩ T = U := by
  ext x
  have hd : x ∈ S → x ∉ T := fun h => Finset.disjoint_left.mp hST h
  have hu : x ∈ U → x ∈ T := fun h => hUT h
  simp only [Finset.mem_inter, Finset.mem_union]
  tauto

private theorem fiber_pair_cards {n : ℕ} (S T A B : Finset (Fin n))
    (hST : Disjoint S T)
    (h : squarefreeExponent A + squarefreeExponent B = fiberExponent S T) :
    A.card = S.card + (A ∩ T).card ∧
      B.card = S.card + (T.card - (A ∩ T).card) := by
  obtain ⟨hA, hB⟩ := fiber_pair_decomposition S T A B hST h
  constructor
  · conv_lhs => rw [hA]
    exact Finset.card_union_of_disjoint (hST.mono_right Finset.inter_subset_right)
  · rw [hB, Finset.card_union_of_disjoint (hST.mono_right Finset.sdiff_subset),
      Finset.card_sdiff_of_subset Finset.inter_subset_right]

/-- Ordered subset pairs contributing to a prescribed exponent vector. -/
def elementaryFiber (n i j : ℕ) (d : Fin n →₀ ℕ) :
    Finset (Finset (Fin n) × Finset (Fin n)) :=
  (Finset.univ.powersetCard i ×ˢ Finset.univ.powersetCard j).filter
    (fun p => squarefreeExponent p.1 + squarefreeExponent p.2 = d)

private theorem mem_elementaryFiber {n i j : ℕ} {d : Fin n →₀ ℕ}
    {p : Finset (Fin n) × Finset (Fin n)} :
    p ∈ elementaryFiber n i j d ↔
      (p.1.card = i ∧ p.2.card = j) ∧
        squarefreeExponent p.1 + squarefreeExponent p.2 = d := by
  simp [elementaryFiber, Finset.mem_powersetCard]

/-- The squarefree monomial formula identifies coefficients with subset-pair fibers. -/
theorem coeff_esymm_mul_eq_card (n i j : ℕ) (d : Fin n →₀ ℕ) :
    MvPolynomial.coeff d
      (MvPolynomial.esymm (Fin n) ℚ i * MvPolynomial.esymm (Fin n) ℚ j) =
        ((elementaryFiber n i j d).card : ℚ) := by
  classical
  rw [MvPolynomial.esymm_eq_sum_monomial, MvPolynomial.esymm_eq_sum_monomial,
    Finset.sum_mul_sum, ← Finset.sum_product']
  simp only [MvPolynomial.coeff_sum, MvPolynomial.monomial_mul, one_mul,
    MvPolynomial.coeff_monomial]
  exact Finset.sum_boole _ _

/-- A fiber is freely chosen by the subset of singly occurring indices in A. -/
theorem card_elementaryFiber (n : ℕ) (S T : Finset (Fin n)) (hST : Disjoint S T)
    (ell : ℕ) (hell : ell ≤ T.card) :
    (elementaryFiber n (S.card + ell) (S.card + (T.card - ell))
      (fiberExponent S T)).card = T.card.choose ell := by
  classical
  rw [← Finset.card_powersetCard]
  symm
  apply Finset.card_bij (fun U _ => (S ∪ U, S ∪ (T \ U)))
  · intro U hU
    obtain ⟨hUT, hcard⟩ := Finset.mem_powersetCard.mp hU
    apply mem_elementaryFiber.mpr
    refine ⟨⟨?_, ?_⟩, split_pair_exponent S T U hST hUT⟩
    · rw [Finset.card_union_of_disjoint (hST.mono_right hUT), hcard]
    · rw [Finset.card_union_of_disjoint (hST.mono_right Finset.sdiff_subset),
        Finset.card_sdiff_of_subset hUT, hcard]
  · intro U hU V hV heq
    have h := congrArg (fun p : Finset (Fin n) × Finset (Fin n) => p.1 ∩ T) heq
    simpa only [split_pair_inter S T U hST (Finset.mem_powersetCard.mp hU).1,
      split_pair_inter S T V hST (Finset.mem_powersetCard.mp hV).1] using h
  · intro p hp
    obtain ⟨⟨hA, hB⟩, heq⟩ := mem_elementaryFiber.mp hp
    have hcards := fiber_pair_cards S T p.1 p.2 hST heq
    obtain ⟨hleft, hright⟩ := fiber_pair_decomposition S T p.1 p.2 hST heq
    refine ⟨p.1 ∩ T, Finset.mem_powersetCard.mpr ⟨Finset.inter_subset_right, ?_⟩,
      Prod.ext hleft.symm hright.symm⟩
    omega

/-- Complete coefficient formula, including impossible degree and index cases. -/
theorem coeff_esymm_mul_fiber (n i j : ℕ) (S T : Finset (Fin n))
    (hST : Disjoint S T) :
    MvPolynomial.coeff (fiberExponent S T)
      (MvPolynomial.esymm (Fin n) ℚ i * MvPolynomial.esymm (Fin n) ℚ j) =
      if S.card ≤ i ∧ S.card ≤ j ∧ i + j = 2 * S.card + T.card
      then (T.card.choose (i - S.card) : ℚ) else 0 := by
  classical
  rw [coeff_esymm_mul_eq_card]
  split_ifs with h
  · have he : i - S.card ≤ T.card := by omega
    have hi : i = S.card + (i - S.card) := by omega
    have hj : j = S.card + (T.card - (i - S.card)) := by omega
    conv_lhs => rw [hi, hj]
    rw [card_elementaryFiber n S T hST _ he]
  · have hempty : elementaryFiber n i j (fiberExponent S T) = ∅ := by
      apply Finset.eq_empty_iff_forall_notMem.mpr
      intro p hp
      obtain ⟨⟨hA, hB⟩, heq⟩ := mem_elementaryFiber.mp hp
      have hcards := fiber_pair_cards S T p.1 p.2 hST heq
      have hle := Finset.card_le_card (Finset.inter_subset_right (s₁ := p.1) (s₂ := T))
      exact h (by omega)
    rw [hempty, Finset.card_empty, Nat.cast_zero]

#print axioms coeff_esymm_mul_eq_card
#print axioms card_elementaryFiber
#print axioms coeff_esymm_mul_fiber

end D5.S3.Zeros.Convolution.MatchingFiber
