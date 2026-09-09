/- GID: D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity
   generality: G
   mirror-B: D5/B/S3/Quantum/Entanglement/StationaryOccupationRankNullity
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Stationary occupation residual Grams force the product-minus-maximum memory lower bound. -/
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.LinearAlgebra.Matrix.PosDef
import D5.S3.Quantum.Entanglement.BoundedProfileCardinality
import D5.S3.Quantum.Algebra.ConditionalPolynomialRigidity
import D5.S1.Ledger.BoundedTimeSlice
import D5.S3.Quantum.Entanglement.SequentialRegisterCircuit
import Mathlib.Analysis.InnerProductSpace.GramMatrix
import Mathlib.Analysis.Matrix.Order
import Mathlib.Data.Finsupp.Multiset
import Mathlib.LinearAlgebra.Basis.SMul
import Mathlib.Algebra.MvPolynomial.Coeff
import Mathlib.RingTheory.Polynomial.DegreeLT
set_option autoImplicit false
set_option relaxedAutoImplicit false
noncomputable section
open scoped BigOperators ComplexOrder
namespace D5.S3.Quantum.Entanglement.StationaryOccupationRankNullity
open D5.S3.Quantum.Entanglement.BoundedProfileCardinality
theorem gram_rank_add_nullity {ι κ : Type*} [Fintype ι] [Fintype κ]
    (G : Matrix ι κ ℂ) :
    G.rank + Module.finrank ℂ (LinearMap.ker G.mulVecLin) = Fintype.card κ := by
  have h := LinearMap.finrank_range_add_finrank_ker G.mulVecLin
  simpa only [Matrix.rank, Module.finrank_fintype_fun_eq_card] using h
theorem gram_rank_ge_card_sub_nullity {ι κ : Type*} [Fintype ι] [Fintype κ]
    (G : Matrix ι κ ℂ) (q : Nat)
    (hker : Module.finrank ℂ (LinearMap.ker G.mulVecLin) ≤ q) :
    Fintype.card κ - q ≤ G.rank := by
  have h := gram_rank_add_nullity G
  omega
theorem bounded_profile_rank_ge
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (a : ι → Nat)
    (G : Matrix (D5.S3.Quantum.Entanglement.BoundedProfileCardinality.Profile a)
      (D5.S3.Quantum.Entanglement.BoundedProfileCardinality.Profile a) ℂ)
    (q : Nat)
    (hker : Module.finrank ℂ (LinearMap.ker G.mulVecLin) ≤ q) :
    (∏ i : ι, (a i + 1)) - q ≤ G.rank := by
  rw [← card_bounded_profiles a]
  exact gram_rank_ge_card_sub_nullity G q hker
theorem gram_factor_rank_le_memory_card {ι κ : Type*} [Fintype ι] [Fintype κ]
    (C : Matrix κ ι ℂ) :
    (C.conjTranspose * C).rank ≤ Fintype.card κ := by
  exact (Matrix.rank_mul_le_left C.conjTranspose C).trans
    (Matrix.rank_le_card_width C.conjTranspose)
theorem gram_factor_is_hermitian {ι κ : Type*} [Fintype ι] [Fintype κ]
    (C : Matrix κ ι ℂ) :
    (C.conjTranspose * C).IsHermitian := by
  exact Matrix.isHermitian_conjTranspose_mul_self C
theorem gram_factor_pos_semidef {ι κ : Type*} [Fintype ι] [Fintype κ]
    (C : Matrix κ ι ℂ) :
    (C.conjTranspose * C).PosSemidef := by
  exact Matrix.posSemidef_conjTranspose_mul_self C
theorem gram_factor_kernel_eq {ι κ : Type*} [Fintype ι] [Fintype κ]
    (C : Matrix κ ι ℂ) :
    (C.conjTranspose * C).mulVecLin.ker = C.mulVecLin.ker := by
  exact Matrix.ker_mulVecLin_conjTranspose_mul_self C
theorem bounded_profile_memory_ge
    {ι κ : Type*} [Fintype ι] [DecidableEq ι] [Fintype κ]
    (a : ι → Nat) (C : Matrix κ (Profile a) ℂ) (q : Nat)
    (hker : Module.finrank ℂ
      (LinearMap.ker (C.conjTranspose * C).mulVecLin) ≤ q) :
    (∏ i : ι, (a i + 1)) - q ≤ Fintype.card κ := by
  exact (bounded_profile_rank_ge a (C.conjTranspose * C) q hker).trans
    (gram_factor_rank_le_memory_card C)
end D5.S3.Quantum.Entanglement.StationaryOccupationRankNullity
namespace Stationary56RectangularBound
open MvPolynomial
variable {K sigma : Type*} [Field K] [Fintype sigma]
theorem coeff_single_linearForm_pow (c : sigma → K) (i : sigma) (n k : ℕ) :
    coeff (Finsupp.single i n) ((∑ j, c j • (X j : MvPolynomial sigma K)) ^ k) =
      if n = k then (c i) ^ n else 0 := by
  classical
  rw [coeff_linearCombination_X_pow_of_fintype]
  have hprod : (Finsupp.single i n).prod (fun _ m => m.factorial) = n.factorial :=
    Finsupp.prod_single_index (by simp)
  have hquot : n.factorial / n.factorial = 1 := Nat.div_self (Nat.factorial_pos n)
  simp [Finsupp.multinomial, hprod, hquot]
theorem coeff_single_aeval_linearForm (c : sigma → K) (i : sigma)
    (F : Polynomial K) (n : ℕ) :
    coeff (Finsupp.single i n)
      (Polynomial.aeval (∑ j, c j • (X j : MvPolynomial sigma K)) F) =
      F.coeff n * (c i) ^ n := by
  classical
  rw [Polynomial.aeval_eq_sum_range, coeff_sum]
  simp_rw [coeff_smul, coeff_single_linearForm_pow, smul_eq_mul, mul_ite, mul_zero]
  by_cases hn : n ∈ Finset.range (F.natDegree + 1)
  · simp [hn]
  · have hFn : F.coeff n = 0 := Polynomial.coeff_eq_zero_of_natDegree_lt (by
      have : F.natDegree + 1 ≤ n := by
        simpa only [Finset.mem_range, not_lt] using hn
      omega)
    simp [hn, hFn]
theorem aeval_linearForm_injective (c : sigma → K) (i : sigma) (hi : c i ≠ 0) :
    Function.Injective (Polynomial.aeval (R := K)
      (∑ j, c j • (X j : MvPolynomial sigma K))) := by
  intro F G hFG
  ext n
  have h := congrArg (coeff (Finsupp.single i n)) hFG
  rw [coeff_single_aeval_linearForm, coeff_single_aeval_linearForm] at h
  exact mul_right_cancel₀ (pow_ne_zero n hi) h
theorem natDegree_le_of_rectangular_support
    (a : sigma → ℕ) (c : sigma → K) (i : sigma) (hi : c i ≠ 0)
    (F : Polynomial K)
    (hbox : ∀ d ∈ (Polynomial.aeval
      (∑ j, c j • (X j : MvPolynomial sigma K)) F).support, ∀ j, d j ≤ a j) :
    F.natDegree ≤ a i := by
  classical
  by_cases hF : F = 0
  · simp [hF]
  · have hc : coeff (Finsupp.single i F.natDegree)
        (Polynomial.aeval (∑ j, c j • (X j : MvPolynomial sigma K)) F) ≠ 0 := by
      rw [coeff_single_aeval_linearForm, Polynomial.coeff_natDegree]
      exact mul_ne_zero (Polynomial.leadingCoeff_ne_zero.mpr hF) (pow_ne_zero _ hi)
    simpa using hbox _ (mem_support_iff.mpr hc) i
theorem finrank_le_pivot_capacity
    (a : sigma → ℕ) (L : Submodule K (MvPolynomial sigma K))
    (hconst : ∀ b : K, C b ∈ L → b = 0)
    (hbox : ∀ p ∈ L, ∀ d ∈ p.support, ∀ j, d j ≤ a j)
    (c : sigma → K) (i : sigma) (hi : c i ≠ 0)
    (hrep : ∀ p ∈ L, ∃ F : Polynomial K,
      p = Polynomial.aeval (∑ j, c j • (X j : MvPolynomial sigma K)) F) :
    Module.finrank K L ≤ a i := by
  classical
  let e := Polynomial.aeval (R := K) (∑ j, c j • (X j : MvPolynomial sigma K))
  let S : Submodule K (Polynomial K) := L.comap e.toLinearMap
  have hle : S ≤ Polynomial.degreeLT K (a i + 1) := by
    intro F hF
    rw [Polynomial.degreeLT_succ_eq_degreeLE, Polynomial.mem_degreeLE]
    exact Polynomial.natDegree_le_iff_degree_le.mp
      (natDegree_le_of_rectangular_support a c i hi F (hbox _ hF))
  have hproper : ¬ Polynomial.degreeLT K (a i + 1) ≤ S := by
    intro h
    have hone : (1 : Polynomial K) ∈ Polynomial.degreeLT K (a i + 1) := by
      rw [Polynomial.degreeLT_succ_eq_degreeLE, Polynomial.mem_degreeLE]
      simp
    have hmem : (C 1 : MvPolynomial sigma K) ∈ L := by
      have hh := h hone
      change e 1 ∈ L at hh
      simpa [e] using hh
    exact one_ne_zero (hconst 1 hmem)
  have hlt := Submodule.finrank_lt_finrank_of_lt (lt_of_le_not_ge hle hproper)
  have hdim : Module.finrank K (Polynomial.degreeLT K (a i + 1)) = a i + 1 := by
    simpa using Module.finrank_eq_card_basis (Polynomial.degreeLT.basis K (a i + 1))
  let f : S →ₗ[K] L := e.toLinearMap.restrict (fun _ h => h)
  have hf : Function.Bijective f := by
    constructor
    · intro F G hFG
      apply Subtype.ext
      exact aeval_linearForm_injective c i hi (congrArg Subtype.val hFG)
    · intro p
      obtain ⟨F, hF⟩ := hrep p p.property
      have hFS : F ∈ S := by
        change e F ∈ L
        rw [← hF]
        exact p.property
      exact ⟨⟨F, hFS⟩, Subtype.ext hF.symm⟩
  have heq := (LinearEquiv.ofBijective f hf).finrank_eq
  rw [hdim, heq] at hlt
  omega
omit [Fintype sigma] in
theorem submodule_eq_bot_of_zero_box
    (a : sigma → ℕ) (L : Submodule K (MvPolynomial sigma K))
    (hconst : ∀ b : K, C b ∈ L → b = 0)
    (hbox : ∀ p ∈ L, ∀ d ∈ p.support, ∀ i, d i ≤ a i)
    (ha : ∀ i, a i = 0) : L = ⊥ := by
  apply le_antisymm ?_ bot_le
  intro p hp
  change p = 0
  have he : p = C (coeff 0 p) := by
    apply eq_monomial_of_support_subset_singleton
    intro d hd
    ext i
    exact Nat.eq_zero_of_le_zero (by simpa [ha i] using hbox p hp d hd i)
  have hz : coeff 0 p = 0 := hconst _ (he ▸ hp)
  simpa [hz] using he
theorem stationary_rectangular_nullity_bound [CharZero K]
    (a : sigma → ℕ) (L : Submodule K (MvPolynomial sigma K))
    [FiniteDimensional K L]
    (hconst : ∀ b : K, C b ∈ L → b = 0)
    (hclosed : ∀ p ∈ L, constantCoeff p = 0 → ∀ i, pderiv i p ∈ L)
    (hbox : ∀ p ∈ L, ∀ d ∈ p.support, ∀ i, d i ≤ a i) :
    Module.finrank K L ≤ Finset.univ.sup a := by
  classical
  by_cases ha : Finset.univ.sup a = 0
  · have haz : ∀ i, a i = 0 := by
      intro i
      exact Nat.eq_zero_of_le_zero (ha ▸ Finset.le_sup (Finset.mem_univ i))
    rw [submodule_eq_bot_of_zero_box a L hconst hbox haz]
    simp
  · by_cases hdim : 2 ≤ Module.finrank K L
    · obtain ⟨c, hc, hrep⟩ :=
        D5.S3.Quantum.Algebra.ConditionalPolynomialRigidity.conditional_derivative_closed_subspace_rigidity
          L hconst hclosed hdim
      obtain ⟨i, hi⟩ : ∃ i, c i ≠ 0 := by
        by_contra hn
        apply hc
        funext i
        simpa using not_exists.mp hn i
      exact (finrank_le_pivot_capacity a L hconst hbox c i hi hrep).trans
        (Finset.le_sup (Finset.mem_univ i))
    · omega
end Stationary56RectangularBound
namespace Stationary56GramRank
open D5.S1.Ledger.BoundedTimeSlice Matrix
open scoped BigOperators ComplexOrder Classical
variable {sigma : Type*} [Fintype sigma]
def lower (a : sigma → ℕ) (i : sigma) (r : TailBox a) : TailBox a := by
  classical
  exact fun j => ⟨(r j).val - if j = i then 1 else 0,
    lt_of_le_of_lt (Nat.sub_le _ _) (r j).isLt⟩
omit [Fintype sigma] in
@[simp] theorem lower_val (a : sigma → ℕ) (i : sigma) (r : TailBox a) (j : sigma) :
    (lower a i r j).val = (r j).val - if j = i then 1 else 0 := by
  classical
  rfl
def loweringMatrix (a : sigma → ℕ) (i : sigma) :
    Matrix (TailBox a) (TailBox a) ℂ := by
  classical
  exact fun s r => if 0 < (r i).val then
    (Pi.single (lower a i r) 1 : TailBox a → ℂ) s else 0
def lowering (a : sigma → ℕ) (i : sigma) :
    (TailBox a → ℂ) →ₗ[ℂ] (TailBox a → ℂ) :=
  (loweringMatrix a i).mulVecLin
theorem lowering_single (a : sigma → ℕ) (i : sigma) (r : TailBox a) (c : ℂ) :
    lowering a i (Pi.single r c) =
      if 0 < (r i).val then Pi.single (lower a i r) c else 0 := by
  classical
  ext s
  simp [lowering, loweringMatrix, Matrix.mulVec_single, Pi.single_apply]
  split_ifs <;> simp_all
theorem lowered_gram_entry (a : sigma → ℕ) (i : sigma)
    (B : Matrix (TailBox a) (TailBox a) ℂ) (r s : TailBox a) :
    ((loweringMatrix a i).conjTranspose * B * loweringMatrix a i) r s =
      if 0 < (r i).val ∧ 0 < (s i).val
      then B (lower a i r) (lower a i s) else 0 := by
  classical
  by_cases hr : 0 < (r i).val <;> by_cases hs : 0 < (s i).val <;>
    simp [Matrix.mul_apply, Matrix.conjTranspose_apply, loweringMatrix, hr, hs,
      Pi.single_apply]
theorem recurrence_quadratic_identity (a : sigma → ℕ)
    (B : Matrix (TailBox a) (TailBox a) ℂ)
    (hrec : ∀ r s : TailBox a, r ≠ 0 → s ≠ 0 →
      B r s = ∑ i, if 0 < (r i).val ∧ 0 < (s i).val
        then B (lower a i r) (lower a i s) else 0)
    (u : TailBox a → ℂ) (hu : u 0 = 0) :
    star u ⬝ᵥ (B *ᵥ u) =
      ∑ i, star (lowering a i u) ⬝ᵥ (B *ᵥ lowering a i u) := by
  classical
  let Q : Matrix (TailBox a) (TailBox a) ℂ :=
    ∑ i, (loweringMatrix a i).conjTranspose * B * loweringMatrix a i
  have hQ : ∀ r s : TailBox a, r ≠ 0 → s ≠ 0 → B r s = Q r s := by
    intro r s hr hs
    simpa only [Q, Matrix.sum_apply, lowered_gram_entry] using hrec r s hr hs
  have heq : star u ⬝ᵥ (B *ᵥ u) = star u ⬝ᵥ (Q *ᵥ u) := by
    simp only [dotProduct, Matrix.mulVec, Finset.mul_sum, Pi.star_apply]
    apply Finset.sum_congr rfl
    intro r _
    apply Finset.sum_congr rfl
    intro s _
    by_cases hr : r = 0
    · simp [hr, hu]
    · by_cases hs : s = 0
      · simp [hs, hu]
      · rw [hQ r s hr hs]
  rw [heq]
  simp only [Q, Matrix.sum_mulVec, dotProduct_sum]
  apply Finset.sum_congr rfl
  intro i _
  simp only [lowering, Matrix.mulVecLin_apply, star_mulVec, dotProduct_mulVec,
    vecMul_vecMul]
theorem lowering_mem_kernel (a : sigma → ℕ)
    (B : Matrix (TailBox a) (TailBox a) ℂ) (hB : B.PosSemidef)
    (hrec : ∀ r s : TailBox a, r ≠ 0 → s ≠ 0 →
      B r s = ∑ i, if 0 < (r i).val ∧ 0 < (s i).val
        then B (lower a i r) (lower a i s) else 0)
    (u : TailBox a → ℂ) (hker : u ∈ LinearMap.ker B.mulVecLin)
    (hu : u 0 = 0) (i : sigma) :
    lowering a i u ∈ LinearMap.ker B.mulVecLin := by
  classical
  have hz : star u ⬝ᵥ (B *ᵥ u) = 0 :=
    (hB.dotProduct_mulVec_zero_iff u).mpr hker
  rw [recurrence_quadratic_identity a B hrec u hu] at hz
  have hi := (Finset.sum_eq_zero_iff_of_nonneg
    (fun j (_ : j ∈ Finset.univ) => hB.dotProduct_mulVec_nonneg (lowering a j u))).mp hz
  exact (hB.dotProduct_mulVec_zero_iff _).mp (hi i (Finset.mem_univ i))
end Stationary56GramRank
namespace Stationary56GramRank
open D5.S1.Ledger.BoundedTimeSlice MvPolynomial
open scoped BigOperators Classical
variable {sigma : Type*} [Fintype sigma]
def boxEquiv (a : sigma → ℕ) : TailBox a ≃ {d : sigma →₀ ℕ | ∀ i, d i ≤ a i} where
  toFun r := ⟨Finsupp.equivFunOnFinite.symm (fun i => (r i).val), by
    intro i
    exact Nat.le_of_lt_succ (r i).isLt⟩
  invFun d := fun i => ⟨d.val i, Nat.lt_succ_of_le (d.property i)⟩
  left_inv r := by rfl
  right_inv d := by apply Subtype.ext; ext i; rfl
def exponent (a : sigma → ℕ) (r : TailBox a) : sigma →₀ ℕ :=
  (boxEquiv a r).val
@[simp] theorem exponent_apply (a : sigma → ℕ) (r : TailBox a) (i : sigma) :
    exponent a r i = (r i).val := rfl
@[simp] theorem exponent_zero (a : sigma → ℕ) : exponent a 0 = 0 := by
  ext i
  rfl
theorem exponent_injective (a : sigma → ℕ) : Function.Injective (exponent a) := by
  intro r s h
  apply (boxEquiv a).injective
  exact Subtype.ext h
theorem exponent_lower (a : sigma → ℕ) (i : sigma) (r : TailBox a) :
    exponent a (lower a i r) = exponent a r - Finsupp.single i 1 := by
  ext j
  simp [Finsupp.single_apply, eq_comm]
def rectangle (a : sigma → ℕ) : Submodule ℂ (MvPolynomial sigma ℂ) :=
  restrictSupport ℂ {d | ∀ i, d i ≤ a i}
def boxBasis (a : sigma → ℕ) : Module.Basis (TailBox a) ℂ (rectangle a) :=
  (basisRestrictSupport ℂ {d | ∀ i, d i ≤ a i}).reindex (boxEquiv a).symm
theorem boxBasis_val (a : sigma → ℕ) (r : TailBox a) :
    (boxBasis a r).val = monomial (exponent a r) 1 := by
  refine (congrArg Subtype.val
    ((basisRestrictSupport ℂ {d : sigma →₀ ℕ | ∀ i, d i ≤ a i}).reindex_apply
      (boxEquiv a).symm r)).trans ?_
  exact congrArg AddMonoidAlgebra.ofCoeff
    (Finsupp.supportedEquivFinsupp_symm_single (R := ℂ)
      {d : sigma →₀ ℕ | ∀ i, d i ≤ a i} (boxEquiv a r) (1 : ℂ))
def factorialProduct (a : sigma → ℕ) (r : TailBox a) : ℂ :=
  ∏ i, (Nat.factorial (r i).val : ℂ)
theorem factorialProduct_ne_zero (a : sigma → ℕ) (r : TailBox a) :
    factorialProduct a r ≠ 0 := by
  apply Finset.prod_ne_zero_iff.mpr
  intro i _
  exact_mod_cast Nat.factorial_ne_zero (r i).val
@[simp] theorem factorialProduct_zero (a : sigma → ℕ) : factorialProduct a 0 = 1 := by
  simp [factorialProduct]
def scaledBasis (a : sigma → ℕ) : Module.Basis (TailBox a) ℂ (rectangle a) :=
  (boxBasis a).unitsSMul
    (fun r => (Units.mk0 (factorialProduct a r) (factorialProduct_ne_zero a r))⁻¹)
theorem scaledBasis_val (a : sigma → ℕ) (r : TailBox a) :
    (scaledBasis a r).val = monomial (exponent a r) (factorialProduct a r)⁻¹ := by
  simp [scaledBasis, Module.Basis.unitsSMul_apply, Units.smul_def, boxBasis_val,
    smul_monomial]
def coordinateEquiv (a : sigma → ℕ) : (TailBox a → ℂ) ≃ₗ[ℂ] rectangle a :=
  (scaledBasis a).equivFun.symm
def polynomialMap (a : sigma → ℕ) : (TailBox a → ℂ) →ₗ[ℂ] MvPolynomial sigma ℂ :=
  (rectangle a).subtype.comp (coordinateEquiv a).toLinearMap
theorem polynomialMap_injective (a : sigma → ℕ) : Function.Injective (polynomialMap a) :=
  Subtype.val_injective.comp (coordinateEquiv a).injective
theorem polynomialMap_single (a : sigma → ℕ) (r : TailBox a) (c : ℂ) :
    polynomialMap a (Pi.single r c) =
      monomial (exponent a r) (c * (factorialProduct a r)⁻¹) := by
  simp [polynomialMap, coordinateEquiv, Module.Basis.equivFun_symm_apply,
    scaledBasis_val, smul_monomial]
theorem polynomialMap_mem_rectangle (a : sigma → ℕ) (u : TailBox a → ℂ) :
    polynomialMap a u ∈ rectangle a :=
  (coordinateEquiv a u).property
theorem factorialProduct_lower (a : sigma → ℕ) (i : sigma) (r : TailBox a)
    (hr : 0 < (r i).val) :
    factorialProduct a r = (r i).val * factorialProduct a (lower a i r) := by
  have hcoord : ∀ j, (Nat.factorial (r j).val : ℂ) =
      (if j = i then ((r i).val : ℂ) else 1) *
        (Nat.factorial (lower a i r j).val : ℂ) := by
    intro j
    by_cases hji : j = i
    · subst j
      simp only [lower_val]
      exact_mod_cast (Nat.mul_factorial_pred (Nat.ne_of_gt hr)).symm
    · simp [lower_val, hji]
  unfold factorialProduct
  simp_rw [hcoord, Finset.prod_mul_distrib]
  simp
theorem pderiv_polynomialMap_single (a : sigma → ℕ) (i : sigma)
    (r : TailBox a) (c : ℂ) :
    pderiv i (polynomialMap a (Pi.single r c)) =
      polynomialMap a (lowering a i (Pi.single r c)) := by
  rw [polynomialMap_single, pderiv_monomial, ← exponent_lower, exponent_apply,
    lowering_single]
  by_cases hr : 0 < (r i).val
  · rw [if_pos hr, polynomialMap_single, factorialProduct_lower a i r hr]
    congr 1
    have hn : ((r i).val : ℂ) ≠ 0 := by exact_mod_cast Nat.ne_of_gt hr
    field_simp
  · have hz : (r i).val = 0 := Nat.eq_zero_of_not_pos hr
    simp [hz]
theorem pderiv_polynomialMap (a : sigma → ℕ) (i : sigma) (u : TailBox a → ℂ) :
    pderiv i (polynomialMap a u) = polynomialMap a (lowering a i u) := by
  have h : (pderiv i).toLinearMap.comp (polynomialMap a) =
      (polynomialMap a).comp (lowering a i) := by
    apply LinearMap.pi_ext
    intro r c
    exact pderiv_polynomialMap_single a i r c
  exact LinearMap.congr_fun h u
theorem constantCoeff_polynomialMap (a : sigma → ℕ) (u : TailBox a → ℂ) :
    constantCoeff (polynomialMap a u) = u 0 := by
  have h : (lcoeff ℂ 0).comp (polynomialMap a) = LinearMap.proj 0 := by
    apply LinearMap.pi_ext
    intro r c
    simp only [LinearMap.comp_apply, polynomialMap_single, lcoeff_apply,
      coeff_monomial, LinearMap.proj_apply]
    have he : exponent a r = 0 ↔ r = 0 := by
      rw [← exponent_zero a]
      exact (exponent_injective a).eq_iff
    by_cases hr : r = 0
    · subst r
      simp
    · simp [he, hr, eq_comm]
  exact LinearMap.congr_fun h u
end Stationary56GramRank
namespace Stationary56GramRank
open D5.S1.Ledger.BoundedTimeSlice MvPolynomial Matrix
open scoped BigOperators ComplexOrder Classical
variable {sigma : Type*} [Fintype sigma]
theorem stationary_gram_rank_lower_bound (a : sigma → ℕ)
    (B : Matrix (TailBox a) (TailBox a) ℂ) (hB : B.PosSemidef)
    (h00 : B 0 0 = 1)
    (hrec : ∀ r s : TailBox a, r ≠ 0 → s ≠ 0 →
      B r s = ∑ i, if 0 < (r i).val ∧ 0 < (s i).val
        then B (lower a i r) (lower a i s) else 0) :
    (∏ i, (a i + 1)) - Finset.univ.sup a ≤ B.rank := by
  let N := LinearMap.ker B.mulVecLin
  let L := N.map (polynomialMap a)
  have hconst : ∀ c : ℂ, C c ∈ L → c = 0 := by
    intro c hc
    obtain ⟨u, hu, he⟩ := hc
    have hj : polynomialMap a (Pi.single 0 c) = C c := by
      simp [polynomialMap_single]
    have hu_eq : u = Pi.single 0 c :=
      polynomialMap_injective a (he.trans hj.symm)
    have hb : B *ᵥ u = 0 := hu
    have hz := congrFun hb 0
    simpa [hu_eq, Matrix.mulVec_single, h00] using hz
  have hclosed : ∀ p ∈ L, constantCoeff p = 0 → ∀ i, pderiv i p ∈ L := by
    intro p hp hp0 i
    obtain ⟨u, hu, rfl⟩ := hp
    have hu0 : u 0 = 0 := (constantCoeff_polynomialMap a u).symm.trans hp0
    exact ⟨lowering a i u, lowering_mem_kernel a B hB hrec u hu hu0 i,
      (pderiv_polynomialMap a i u).symm⟩
  have hbox : ∀ p ∈ L, ∀ d ∈ p.support, ∀ i, d i ≤ a i := by
    intro p hp
    obtain ⟨u, _, rfl⟩ := hp
    intro d hd i
    exact (mem_restrictSupport_iff ℂ).mp (polynomialMap_mem_rectangle a u) hd i
  have hbound := Stationary56RectangularBound.stationary_rectangular_nullity_bound
    a L hconst hclosed hbox
  have hdim : Module.finrank ℂ N = Module.finrank ℂ L :=
    (Submodule.equivMapOfInjective (polynomialMap a) (polynomialMap_injective a) N).finrank_eq
  have hrank := LinearMap.finrank_range_add_finrank_ker B.mulVecLin
  have hcard : Module.finrank ℂ (TailBox a → ℂ) = ∏ i, (a i + 1) := by
    simp [TailBox, Fintype.card_pi]
  change B.rank + Module.finrank ℂ N = Module.finrank ℂ (TailBox a → ℂ) at hrank
  rw [hcard] at hrank
  omega
end Stationary56GramRank
namespace Stationary56PhysicalNecessity
open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit D5.S3.Quantum.Entanglement.OccupancyWordSectors
open scoped BigOperators ComplexOrder
variable {A K : Type*} [Fintype A] [Fintype K]
open Classical in
def emission (blank : A) (U : Unitary (A × K)) :
    Space K →ₗᵢ[ℂ] Space (A × K) :=
  U.toLinearIsometry.comp
    (coordinateEmbedding (blankInjection blank (Function.Embedding.refl K)))
def letter (blank : A) (U : Unitary (A × K)) (i : A) : Space K →ₗ[ℂ] Space K where
  toFun x := WithLp.toLp 2 (fun k => emission blank U x (i, k))
  map_add' x y := by ext k; simp
  map_smul' c x := by ext k; simp
@[simp] theorem letter_apply (blank : A) (U : Unitary (A × K)) (i : A)
    (x : Space K) (k : K) : letter blank U i x k = emission blank U x (i, k) := rfl
theorem emission_basis (blank : A) (U : Unitary (A × K)) (j : K) :
    emission blank U (basis j) = U (basis (blank, j)) := by
  classical
  change U (coordinateEmbedding (blankInjection blank (Function.Embedding.refl K))
    (basis j)) = U (basis (blank, j))
  rw [show coordinateEmbedding (blankInjection blank (Function.Embedding.refl K))
    (basis j) = basis (blank, j) from coordinate_embedding_basis _ j]
theorem letter_expansion (blank : A) (U : Unitary (A × K)) (i : A)
    (x : Space K) (k : K) :
    letter blank U i x k = ∑ j, x j * U (basis (blank, j)) (i, k) := by
  conv_lhs => rw [basis_expansion x]
  simp [map_sum, emission_basis]
def prefixMemory (blank : A) (U : Unitary (A × K)) : List A → Space K →ₗ[ℂ] Space K
  | [] => LinearMap.id
  | i :: w => (prefixMemory blank U w).comp (letter blank U i)
@[simp] theorem prefix_nil (blank : A) (U : Unitary (A × K)) (x : Space K) :
    prefixMemory blank U [] x = x := rfl
@[simp] theorem prefix_cons (blank : A) (U : Unitary (A × K)) (i : A)
    (w : List A) (x : Space K) :
    prefixMemory blank U (i :: w) x = prefixMemory blank U w (letter blank U i x) := rfl
theorem prefix_append (blank : A) (U : Unitary (A × K))
    (u v : List A) (x : Space K) :
    prefixMemory blank U (u ++ v) x = prefixMemory blank U v (prefixMemory blank U u x) := by
  induction u generalizing x with
  | nil => rfl
  | cons i u ih => simpa only [List.cons_append, prefix_cons] using ih (letter blank U i x)
theorem initialized_zero (blank : A) (x : Space K) (w : Fin 0 → A) (k : K) :
    initialized blank 0 x (w, k) = x k := by
  classical
  have hw : w = (fun _ => blank) := Subsingleton.elim _ _
  subst w
  exact coordinate_embedding_apply _ x k
theorem circuit_fixed_coefficients (blank : A) (U : Unitary (A × K))
    (n t : ℕ) (x : Space K) (w : Fin n → A) (k : K) :
    circuit (fun _ => U) n t (initialized blank n x) (w, k) =
      prefixMemory blank U (List.ofFn w) x k := by
  classical
  induction n generalizing t x with
  | zero => simpa [circuit] using initialized_zero blank x w k
  | succ n ih =>
    have hw : List.ofFn w = w 0 :: List.ofFn (Fin.tail w) := by
      conv_lhs => rw [← Fin.cons_self_tail w]
      exact List.ofFn_cons _ _
    rw [hw, prefix_cons, ← ih (t + 1)]
    conv_lhs => rw [basis_expansion x]
    simp only [map_sum, map_smul, initialize_basis]
    simp only [WithLp.ofLp_sum, Finset.sum_apply, PiLp.smul_apply, smul_eq_mul,
      circuit_blank_succ]
    conv_rhs => rw [basis_expansion (letter blank U (w 0) x)]
    simp only [map_sum, map_smul, initialize_basis, WithLp.ofLp_sum, Finset.sum_apply, PiLp.smul_apply,
      smul_eq_mul, letter_expansion]
    simp_rw [Finset.mul_sum, Finset.sum_mul]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro j _
    apply Finset.sum_congr rfl
    intro l _
    ring
theorem suffix_injective (blank : A) (U : Unitary (A × K)) (n : ℕ)
    (x y : Space K)
    (h : ∀ (w : Fin n → A), prefixMemory blank U (List.ofFn w) x =
      prefixMemory blank U (List.ofFn w) y) : x = y := by
  apply (initialized blank n).injective
  apply (circuit (fun _ => U) n 0).injective
  ext p
  rcases p with ⟨w, k⟩
  simp only [circuit_fixed_coefficients]
  exact congrArg (fun z : Space K => z k) (h w)
theorem letter_inner_sum (blank : A) (U : Unitary (A × K)) (x y : Space K) :
    inner ℂ x y = ∑ i, inner ℂ (letter blank U i x) (letter blank U i y) := by
  rw [← (emission blank U).inner_map_map x y]
  simp only [PiLp.inner_apply, Fintype.sum_prod_type, letter_apply]
end Stationary56PhysicalNecessity
namespace Stationary56PhysicalNecessity
open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit D5.S3.Quantum.Entanglement.OccupancyWordSectors
open scoped BigOperators ComplexOrder
variable {A K : Type*} [Fintype A] [Fintype K] [DecidableEq A]
def scaledInitial (a : Multiset A) (x : Space K) : Space K :=
  (Real.sqrt (multiplicity a.card a : ℝ) : ℂ) • x
def residualMemory (a : Multiset A) (blank : A) (U : Unitary (A × K))
    (x : Space K) (r : Multiset A) : Space K :=
  prefixMemory blank U (List.ofFn (representative (a - r) rfl)) (scaledInitial a x)
variable (a : Multiset A) (blank : A) (U : Unitary (A × K)) (x f : Space K)
variable (hout : ∀ (w : Fin a.card → A) (k : K),
  circuit (fun _ => U) a.card 0 (initialized blank a.card x) (w, k) =
    sectorVector a.card a w * f k)
include hout in
theorem scaled_full_word (w : Fin a.card → A) :
    prefixMemory blank U (List.ofFn w) (scaledInitial a x) =
      if occupation w = a then f else 0 := by
  have hs : (Real.sqrt (multiplicity a.card a : ℝ) : ℂ) ≠ 0 := by
    exact Complex.ofReal_ne_zero.mpr (Real.sqrt_pos.mpr
      (by exact_mod_cast multiplicity_pos a rfl)).ne'
  ext k
  simp only [scaledInitial, map_smul, PiLp.smul_apply, smul_eq_mul]
  rw [← circuit_fixed_coefficients blank U a.card 0 x w k, hout]
  by_cases h : occupation w = a <;>
    simp [sectorVector, sectorWords, h, hs]
include hout in
theorem scaled_full_list (w : List A) (hw : w.length = a.card) :
    prefixMemory blank U w (scaledInitial a x) =
      if (w : Multiset A) = a then f else 0 := by
  have h : ∀ n, n = a.card → ∀ v : Fin n → A,
      prefixMemory blank U (List.ofFn v) (scaledInitial a x) =
        if occupation v = a then f else 0 := by
    intro n hn v
    subst n
    exact scaled_full_word a blank U x f hout v
  simpa [occupation] using h w.length hw w.get
include hout in
theorem prefix_residual_output (r : Multiset A) (hr : r ≤ a)
    (u : List A) (hu : (u : Multiset A) = a - r)
    (v : List A) (hv : v.length = r.card) :
    prefixMemory blank U v (prefixMemory blank U u (scaledInitial a x)) =
      if (v : Multiset A) = r then f else 0 := by
  have hlen : (u ++ v).length = a.card := by
    have huc := congrArg Multiset.card hu
    simp only [Multiset.coe_card] at huc
    rw [List.length_append, huc, hv, Multiset.card_sub hr]
    exact Nat.sub_add_cancel (Multiset.card_le_card hr)
  rw [← prefix_append, scaled_full_list a blank U x f hout (u ++ v) hlen]
  have he : ((u ++ v : List A) : Multiset A) = a ↔ (v : Multiset A) = r := by
    rw [← Multiset.coe_add, hu]
    constructor
    · intro h
      exact add_left_cancel (h.trans (Multiset.sub_add_cancel hr).symm)
    · intro h
      rw [h]
      exact Multiset.sub_add_cancel hr
  simp only [he]
include hout in
theorem residual_output (r : Multiset A) (hr : r ≤ a)
    (v : List A) (hv : v.length = r.card) :
    prefixMemory blank U v (residualMemory a blank U x r) =
      if (v : Multiset A) = r then f else 0 := by
  apply prefix_residual_output a blank U x f hout r hr _ _ v hv
  exact occupation_representative (a - r) rfl
include hout in
theorem residual_representative_independent (r : Multiset A) (hr : r ≤ a)
    (u : List A) (hu : (u : Multiset A) = a - r) :
    prefixMemory blank U u (scaledInitial a x) = residualMemory a blank U x r := by
  apply suffix_injective blank U r.card
  intro v
  rw [prefix_residual_output a blank U x f hout r hr u hu _ List.length_ofFn,
    residual_output a blank U x f hout r hr _ List.length_ofFn]
include hout in
theorem residual_zero : residualMemory a blank U x 0 = f := by
  have h := residual_output a blank U x f hout 0 zero_le [] rfl
  simpa using h
include hout in
theorem residual_letter_of_mem (r : Multiset A) (hr : r ≤ a)
    (i : A) (hi : i ∈ r) :
    letter blank U i (residualMemory a blank U x r) =
      residualMemory a blank U x (r.erase i) := by
  apply suffix_injective blank U (r.erase i).card
  intro v
  have hlen : (i :: List.ofFn v).length = r.card := by
    simpa using Multiset.card_erase_add_one hi
  rw [← prefix_cons,
    residual_output a blank U x f hout r hr _ hlen,
    residual_output a blank U x f hout (r.erase i) ((Multiset.erase_le i r).trans hr)
      _ List.length_ofFn]
  have he : ((i :: List.ofFn v : List A) : Multiset A) = r ↔
      (List.ofFn v : Multiset A) = r.erase i := by
    change i ::ₘ (List.ofFn v : Multiset A) = r ↔ _
    constructor
    · intro h
      exact (Multiset.cons_inj_right i).mp (h.trans (Multiset.cons_erase hi).symm)
    · intro h
      rw [h, Multiset.cons_erase hi]
  simp only [he]
include hout in
theorem residual_letter_of_not_mem (r : Multiset A) (hr : r ≤ a)
    (hr0 : r ≠ 0) (i : A) (hi : i ∉ r) :
    letter blank U i (residualMemory a blank U x r) = 0 := by
  apply suffix_injective blank U (r.card - 1)
  intro v
  have hpos : 0 < r.card := Multiset.card_pos.mpr hr0
  have hlen : (i :: List.ofFn v).length = r.card := by
    simp only [List.length_cons, List.length_ofFn]
    omega
  rw [← prefix_cons, residual_output a blank U x f hout r hr _ hlen, map_zero]
  have he : ((i :: List.ofFn v : List A) : Multiset A) ≠ r := by
    intro h
    apply hi
    rw [← h]
    simp
  simp [he]
end Stationary56PhysicalNecessity
namespace Stationary56PhysicalNecessity
open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit D5.S3.Quantum.Entanglement.OccupancyWordSectors D5.S1.Ledger.BoundedTimeSlice
open scoped BigOperators ComplexOrder
variable {A K : Type*} [Fintype A] [Fintype K] [DecidableEq A]
def boxOccupation (a : Multiset A) (r : TailBox a.count) : Multiset A :=
  Finsupp.toMultiset (Finsupp.equivFunOnFinite.symm (fun i => (r i).val))
@[simp] theorem box_occupation_count (a : Multiset A) (r : TailBox a.count) (i : A) :
    (boxOccupation a r).count i = (r i).val := by
  simp [boxOccupation]
@[simp] theorem box_occupation_zero (a : Multiset A) : boxOccupation a 0 = 0 := by
  apply Multiset.ext.mpr
  intro i
  simp
theorem box_occupation_le (a : Multiset A) (r : TailBox a.count) :
    boxOccupation a r ≤ a := by
  apply Multiset.le_iff_count.mpr
  intro i
  rw [box_occupation_count]
  exact Nat.le_of_lt_succ (r i).isLt
theorem box_occupation_ne_zero (a : Multiset A) (r : TailBox a.count) (hr : r ≠ 0) :
    boxOccupation a r ≠ 0 := by
  intro h
  apply hr
  funext i
  apply Fin.ext
  have hc := congrArg (Multiset.count i) h
  simpa using hc
theorem box_occupation_mem (a : Multiset A) (r : TailBox a.count) (i : A) :
    i ∈ boxOccupation a r ↔ 0 < (r i).val := by
  rw [← Multiset.count_pos, box_occupation_count]
theorem box_occupation_lower (a : Multiset A) (r : TailBox a.count) (i : A) :
    boxOccupation a (Stationary56GramRank.lower a.count i r) = (boxOccupation a r).erase i := by
  apply Multiset.ext.mpr
  intro j
  rw [box_occupation_count, Stationary56GramRank.lower_val]
  by_cases h : j = i
  · subst j
    simp
  · simp [h, Multiset.count_erase_of_ne h]
def occupationGram (a : Multiset A) (blank : A) (U : Unitary (A × K))
    (x : Space K) : Matrix (TailBox a.count) (TailBox a.count) ℂ :=
  Matrix.gram ℂ (fun r => residualMemory a blank U x (boxOccupation a r))
theorem occupation_gram_psd (a : Multiset A) (blank : A) (U : Unitary (A × K))
    (x : Space K) : (occupationGram a blank U x).PosSemidef :=
  Matrix.posSemidef_gram ℂ _
theorem occupation_gram_rank_le (a : Multiset A) (blank : A) (U : Unitary (A × K))
    (x : Space K) : (occupationGram a blank U x).rank ≤ Fintype.card K := by
  classical
  rw [occupationGram, Matrix.gram_eq_conjTranspose_mul (EuclideanSpace.basisFun K ℂ)]
  exact (Matrix.rank_mul_le_right _ _).trans (Matrix.rank_le_card_height _)
variable (a : Multiset A) (blank : A) (U : Unitary (A × K)) (x f : Space K)
variable (hout : ∀ (w : Fin a.card → A) (k : K),
  circuit (fun _ => U) a.card 0 (initialized blank a.card x) (w, k) =
    sectorVector a.card a w * f k)
include hout in
theorem occupation_gram_zero (hf : ‖f‖ = 1) : occupationGram a blank U x 0 0 = 1 := by
  simp only [occupationGram, Matrix.gram_apply, box_occupation_zero,
    residual_zero a blank U x f hout]
  rw [inner_self_eq_norm_sq_to_K, hf]
  norm_num
include hout in
theorem occupation_gram_recurrence (r s : TailBox a.count) (hr : r ≠ 0) (hs : s ≠ 0) :
    occupationGram a blank U x r s = ∑ i,
      if 0 < (r i).val ∧ 0 < (s i).val then
        occupationGram a blank U x (Stationary56GramRank.lower a.count i r)
          (Stationary56GramRank.lower a.count i s) else 0 := by
  classical
  change inner ℂ (residualMemory a blank U x (boxOccupation a r))
    (residualMemory a blank U x (boxOccupation a s)) = _
  rw [letter_inner_sum blank U]
  apply Finset.sum_congr rfl
  intro i _
  by_cases hri : 0 < (r i).val
  · rw [residual_letter_of_mem a blank U x f hout (boxOccupation a r)
      (box_occupation_le a r) i ((box_occupation_mem a r i).mpr hri)]
    by_cases hsi : 0 < (s i).val
    · rw [residual_letter_of_mem a blank U x f hout (boxOccupation a s)
        (box_occupation_le a s) i ((box_occupation_mem a s i).mpr hsi)]
      simp [hri, hsi, occupationGram, box_occupation_lower]
    · rw [residual_letter_of_not_mem a blank U x f hout (boxOccupation a s)
        (box_occupation_le a s) (box_occupation_ne_zero a s hs) i
        (fun h => hsi ((box_occupation_mem a s i).mp h))]
      simp [hsi]
  · rw [residual_letter_of_not_mem a blank U x f hout (boxOccupation a r)
      (box_occupation_le a r) (box_occupation_ne_zero a r hr) i
      (fun h => hri ((box_occupation_mem a r i).mp h))]
    simp [hri]
theorem unit_memory_card_pos (y : Space K) (hy : ‖y‖ = 1) : 0 < Fintype.card K := by
  classical
  by_contra h
  have : IsEmpty K := Fintype.card_eq_zero_iff.mp (Nat.eq_zero_of_not_pos h)
  have hz : y = 0 := by ext k; exact isEmptyElim k
  simp [hz] at hy
set_option maxHeartbeats 800000 in
theorem physical_stationary_memory_dimension_lower_bound
    (a : Multiset A) (blank : A) (U : Unitary (A × K))
    (x f : Space K) (hx : ‖x‖ = 1) (hf : ‖f‖ = 1)
    (hout : ∀ (w : Fin a.card → A) (k : K),
      circuit (fun _ => U) a.card 0 (initialized blank a.card x) (w, k) =
        sectorVector a.card a w * f k) :
    (∏ i, (a.count i + 1)) - Finset.univ.sup a.count ≤ Fintype.card K := by
  classical
  by_cases ha : a = 0
  · subst a
    simp only [Multiset.count_zero, zero_add, Finset.prod_const_one]
    exact (Nat.sub_le _ _).trans (Nat.succ_le_of_lt (unit_memory_card_pos x hx))
  · have hlow := Stationary56GramRank.stationary_gram_rank_lower_bound a.count
      (occupationGram a blank U x) (occupation_gram_psd a blank U x)
      (occupation_gram_zero a blank U x f hout hf)
      (occupation_gram_recurrence a blank U x f hout)
    let q0 : Fintype (TailBox a.count) := inferInstance
    have hu0 := occupation_gram_rank_le a blank U x
    have hupp : ∀ q : Fintype (TailBox a.count),
        @Matrix.rank (TailBox a.count) (TailBox a.count) ℂ q _
          (occupationGram a blank U x) ≤ Fintype.card K := by
      intro q
      have hq : q = q0 := Subsingleton.elim _ _
      subst q
      exact hu0
    exact hlow.trans (hupp _)
end Stationary56PhysicalNecessity

namespace D5.S3.Quantum.Entanglement.StationaryOccupationRankNullity
theorem stationary_memory_dimension_lower_bound
    {A K : Type*} [Fintype A] [DecidableEq A] [Fintype K]
    (a : Multiset A) (blank : A)
    (U : D5.S3.Quantum.Entanglement.SequentialRegisterCircuit.Unitary (A × K))
    (x f : D5.S3.Quantum.Entanglement.SequentialRegisterCircuit.Space K)
    (hx : ‖x‖ = 1) (hf : ‖f‖ = 1)
    (hout : ∀ (w : Fin a.card → A) (k : K),
      D5.S3.Quantum.Entanglement.SequentialRegisterCircuit.circuit (fun _ => U) a.card 0
        (D5.S3.Quantum.Entanglement.SequentialRegisterCircuit.initialized blank a.card x) (w, k) =
        D5.S3.Quantum.Entanglement.OccupancyWordSectors.sectorVector a.card a w * f k) :
    (∏ i, (a.count i + 1)) - Finset.univ.sup a.count ≤ Fintype.card K := by
  exact Stationary56PhysicalNecessity.physical_stationary_memory_dimension_lower_bound
    a blank U x f hx hf hout
end D5.S3.Quantum.Entanglement.StationaryOccupationRankNullity
