/- GID: D5/S3/Analytic/Hardy/ClarkWeightedComposition
   generality: G
   mirror-B: D5/B/S3/Analytic/Hardy/ClarkWeightedComposition
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: [mathlib/module/Mathlib.Analysis.InnerProductSpace.l2Space, mathlib/module/Mathlib.Analysis.InnerProductSpace.PiL2]
   utility: none
   digest: Orthogonal synthesis constructs actual Hardy weighted-composition branches whose full bounded-operator map is invariant under orthonormal model-basis changes. -/

/- The full coefficient Hardy carrier and concrete Blaschke multiplier supply the powers
   used in the norm-convergent synthesis. Pinned OrthogonalFamily.linearIsometry supplies
   the Hilbert-sum map after orthogonality has been proved here. The finite algebraic
   calculation follows the matrix-only UnitaryKrausMixingInvariance owner, whose theorem
   cannot instantiate the infinite-dimensional bounded-operator carrier used here.
   The final specialization uses the constructed normalized boundary Clark kernels for
   every circle phase, sheet ordering and individual unit phase. The resulting Lambda_B
   is a basis-independent bounded-operator map. The source's statement that Lambda_B is
   not Tao remains an interpretive boundary, not a metaphysical Lean proposition. -/

import D5.S3.Analytic.Hardy.ClarkKernelRealization
noncomputable section
open D5.S3.Analytic.Hardy.HardyCoefficientRealization
open D5.S3.Analytic.Hardy.FiniteBlaschkeMultiplier
open D5.S3.Analytic.Hardy.ClarkKernelRealization
open scoped InnerProductSpace
namespace D5.S3.Analytic.Hardy.ClarkWeightedComposition

def powerEmbedding {m : Nat} (B : FiniteBlaschkeData m) (n : Nat) :
    modelSpace B →ₗᵢ[Complex] H2 where
  toLinearMap := (mul B ^ n).toLinearMap.comp (modelSpace B).subtype
  norm_map' x := by
    change ‖(mul B ^ n) (x : H2)‖ = ‖x‖
    induction n with
    | zero => rfl
    | succ n ih =>
      rw [pow_succ', mul_apply_eq_comp,
        (mul_isometry B).norm_map_of_map_zero (map_zero (mul B)), ih]

theorem powers_orthogonal {m : Nat} (B : FiniteBlaschkeData m) :
    OrthogonalFamily Complex (fun _ : Nat => modelSpace B) (powerEmbedding B) := by
  intro i j hij x y
  change ⟪(mul B ^ i) (x : H2), (mul B ^ j) (y : H2)⟫_Complex = 0
  have hi := (LinearMap.norm_map_iff_inner_map_map (𝕜 := Complex) (mul B)).mp
    ((mul_isometry B).norm_map_of_map_zero (map_zero (mul B)))
  induction i generalizing j with
  | zero =>
    cases j with
    | zero => exact (hij rfl).elim
    | succ j =>
      change ⟪(x : H2), (mul B ^ (j+1)) (y : H2)⟫_Complex = 0
      rw [pow_succ', mul_apply_eq_comp]
      exact ((mul B).range.mem_orthogonal' (x : H2)).mp x.property _ ⟨_, rfl⟩
  | succ i ih =>
    cases j with
    | zero =>
      change ⟪(mul B ^ (i+1)) (x : H2), (y : H2)⟫_Complex = 0
      rw [pow_succ', mul_apply_eq_comp]
      exact ((mul B).range.mem_orthogonal (y : H2)).mp y.property _ ⟨_, rfl⟩
    | succ j =>
      rw [pow_succ', pow_succ', mul_apply_eq_comp, mul_apply_eq_comp, hi]
      exact ih (by omega)

def coefficientTensor {m : Nat} (B : FiniteBlaschkeData m) (e : modelSpace B) :
    H2 →L[Complex] lp (fun _ : Nat => modelSpace B) 2 := by
  let T (f : H2) : lp (fun _ : Nat => modelSpace B) 2 :=
    ⟨fun n => f n • e, memℓp_gen (by
      simpa [norm_smul, mul_pow] using
        ((lp.hasSum_norm (by norm_num : 0 < (2 : ENNReal).toReal) f).summable.mul_right (‖e‖^2)))⟩
  let L : H2 →ₗ[Complex] lp (fun _ : Nat => modelSpace B) 2 :=
    { toFun := T
      map_add' := by
        intro f g
        apply lp.ext
        funext n
        change (f n + g n) • e = f n • e + g n • e
        exact add_smul _ _ _
      map_smul' := by
        intro c f
        apply lp.ext
        funext n
        change (c * f n) • e = c • f n • e
        exact mul_smul _ _ _ }
  apply L.mkContinuous ‖e‖
  intro f
  have hnorm : ‖T f‖ = ‖e‖ * ‖f‖ := by
    apply (sq_eq_sq₀ (norm_nonneg _) (mul_nonneg (norm_nonneg _) (norm_nonneg _))).mp
    have hs := (lp.hasSum_norm (by norm_num : 0 < (2 : ENNReal).toReal) f).mul_right (‖e‖^2)
    have ht := lp.hasSum_norm (by norm_num : 0 < (2 : ENNReal).toReal) (T f)
    norm_num only [ENNReal.toReal_ofNat, Real.rpow_two] at ht hs
    have he : ‖T f‖^2 = ‖f‖^2 * ‖e‖^2 := by
      apply ht.unique
      simpa [T, norm_smul, mul_pow] using hs
    nlinarith [he]
  exact hnorm.le

theorem coefficientTensor_norm {m : Nat} (B : FiniteBlaschkeData m)
    (e : modelSpace B) (f : H2) : ‖coefficientTensor B e f‖ = ‖e‖ * ‖f‖ := by
  apply (sq_eq_sq₀ (norm_nonneg _) (mul_nonneg (norm_nonneg _) (norm_nonneg _))).mp
  have ht := lp.hasSum_norm (by norm_num : 0 < (2 : ENNReal).toReal) (coefficientTensor B e f)
  have hs := (lp.hasSum_norm (by norm_num : 0 < (2 : ENNReal).toReal) f).mul_right (‖e‖^2)
  norm_num only [ENNReal.toReal_ofNat, Real.rpow_two] at ht hs
  have he : ‖coefficientTensor B e f‖^2 = ‖f‖^2 * ‖e‖^2 := by
    apply ht.unique
    simpa [coefficientTensor, norm_smul, mul_pow] using hs
  nlinarith [he]

def branchOp {m : Nat} (B : FiniteBlaschkeData m) (e : modelSpace B) :
    H2 →L[Complex] H2 :=
  (powers_orthogonal B).linearIsometry.toContinuousLinearMap.comp (coefficientTensor B e)

theorem branch_hasSum {m : Nat} (B : FiniteBlaschkeData m) (e : modelSpace B) (f : H2) :
    HasSum (fun n => f n • (mul B ^ n) (e : H2)) (branchOp B e f) := by
  have h := (powers_orthogonal B).hasSum_linearIsometry (coefficientTensor B e f)
  change HasSum (fun n => (mul B ^ n) (f n • (e : H2))) (branchOp B e f) at h
  simpa only [map_smul] using h

theorem branch_norm {m : Nat} (B : FiniteBlaschkeData m) (e : modelSpace B) (f : H2) :
    ‖branchOp B e f‖ = ‖e‖ * ‖f‖ := by
  change ‖(powers_orthogonal B).linearIsometry (coefficientTensor B e f)‖ = _
  rw [LinearIsometry.norm_map, coefficientTensor_norm]

#print axioms powers_orthogonal
theorem branch_eval {m : Nat} (B : FiniteBlaschkeData m) (hm : 0 < m)
    (e : modelSpace B) (f : H2) {z : Complex} (hz : ‖z‖ < 1) :
    evaluate (branchOp B e f) z = evaluate (e : H2) z * evaluate f (value B z) := by
  have hp (n : Nat) : evaluate ((mul B ^ n) (e : H2)) z =
      value B z ^ n * evaluate (e : H2) z := by
    induction n with
    | zero => simp
    | succ n ih =>
      rw [pow_succ', mul_apply_eq_comp, mul_eval B _ hz, ih, pow_succ']
      ring
  have hs := (eval z hz).hasSum (branch_hasSum B e f)
  change HasSum (fun n => (eval z hz) (f n • (mul B ^ n) (e : H2)))
    (evaluate (branchOp B e f) z) at hs
  simp only [map_smul, eval_apply, hp, smul_eq_mul] at hs
  apply hs.unique
  simpa only [mul_comm, mul_left_comm, mul_assoc] using
    (evaluate_hasSum f (maps_unitDisc B hm hz)).mul_left (evaluate (e : H2) z)

def branchLinear {m : Nat} (B : FiniteBlaschkeData m) :
    modelSpace B →ₗ[Complex] (H2 →L[Complex] H2) where
  toFun := branchOp B
  map_add' e g := by
    apply ContinuousLinearMap.ext
    intro f
    change branchOp B (e+g) f = branchOp B e f + branchOp B g f
    apply (branch_hasSum B (e+g) f).unique
    simpa only [Submodule.coe_add, map_add, smul_add] using
      (branch_hasSum B e f).add (branch_hasSum B g f)
  map_smul' c e := by
    apply ContinuousLinearMap.ext
    intro f
    change branchOp B (c • e) f = c • branchOp B e f
    apply (branch_hasSum B (c • e) f).unique
    convert (branch_hasSum B e f).const_smul c using 1
    funext n
    change f n • (mul B ^ n) (c • (e : H2)) = c • (f n • (mul B ^ n) (e : H2))
    rw [map_smul, smul_comm]

#print axioms branch_hasSum
#print axioms branch_norm
#print axioms branch_eval
#print axioms branchLinear
variable {m : Nat} (B : FiniteBlaschkeData m)
  (E F : OrthonormalBasis (Fin m) Complex (modelSpace B))

def coordinateTransition : Matrix (Fin m) (Fin m) Complex :=
  fun k j => ⟪F k, E j⟫_Complex

def branchTransition : Matrix (Fin m) (Fin m) Complex :=
  fun k j => ⟪E j, F k⟫_Complex

theorem branch_transition_eq_conj_coordinates (k j : Fin m) :
    branchTransition B E F k j = star (coordinateTransition B E F k j) := by
  change ⟪E j, F k⟫_Complex = star ⟪F k, E j⟫_Complex
  exact (inner_conj_symm (𝕜 := Complex) (E j) (F k)).symm

theorem branch_basis_mix (k : Fin m) :
    branchOp B (F k) = ∑ j, branchTransition B E F k j • branchOp B (E j) := by
  have h := congrArg (branchLinear B) (E.sum_repr' (F k)).symm
  simpa only [map_sum, map_smul, branchLinear, LinearMap.coe_mk, AddHom.coe_mk,
    branchTransition] using h

theorem branch_transition_columns (i j : Fin m) :
    ∑ k, branchTransition B E F k i * star (branchTransition B E F k j) =
      if i = j then 1 else 0 := by
  unfold branchTransition
  simp only [RCLike.star_def, inner_conj_symm]
  rw [F.sum_inner_mul_inner, orthonormal_iff_ite.mp E.orthonormal]

theorem branch_transition_unitary :
    (branchTransition B E F).conjTranspose * branchTransition B E F = 1 := by
  ext i j
  have h := branch_transition_columns B E F j i
  simpa only [Matrix.mul_apply, Matrix.conjTranspose_apply, Matrix.one_apply,
    mul_comm, eq_comm] using h

theorem branch_map_basis_invariant (X : H2 →L[Complex] H2) :
    ∑ k, branchOp B (F k) * X * star (branchOp B (F k)) =
      ∑ j, branchOp B (E j) * X * star (branchOp B (E j)) := by
  classical
  simp_rw [branch_basis_mix B E F]
  let U := branchTransition B E F
  let S := fun j => branchOp B (E j)
  have hU (i j : Fin m) : ∑ k, U k i * star (U k j) = if i = j then 1 else 0 :=
    branch_transition_columns B E F i j
  change ∑ k, (∑ j, U k j • S j) * X * star (∑ j, U k j • S j) = _
  calc
    ∑ k, (∑ j, U k j • S j) * X * star (∑ j, U k j • S j) =
        ∑ k, ∑ i, ∑ j,
          (U k i * star (U k j)) • (S i * X * star (S j)) := by
      apply Finset.sum_congr rfl
      intro k _
      simp only [star_sum, star_smul, Finset.sum_mul, Finset.mul_sum]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro i _
      apply Finset.sum_congr rfl
      intro j _
      simp only [smul_mul_assoc, mul_smul_comm, smul_smul]
      rw [mul_comm (star (U k j)) (U k i)]
    _ = ∑ i, ∑ j, (∑ k, U k i * star (U k j)) •
        (S i * X * star (S j)) := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro i _
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro j _
      rw [Finset.sum_smul]
    _ = ∑ i, ∑ j, (if i = j then (1 : Complex) else 0) • (S i * X * star (S j)) := by
      simp_rw [hU]
    _ = ∑ j, S j * X * star (S j) := by simp

#print axioms branch_basis_mix
#print axioms branch_transition_unitary
#print axioms branch_map_basis_invariant
theorem clark_branch_map_invariant {m : Nat} (B : FiniteBlaschkeData m) (hm : 0 < m)
    (h0 : value B 0 = 0) (alpha beta : Circle) (oa ob : Fin m ≃ Fin m)
    (ta tb : Fin m → Circle) (X : H2 →L[Complex] H2) :
    ∑ k, branchOp B (clarkBasis B hm h0 beta ob tb k) * X *
      star (branchOp B (clarkBasis B hm h0 beta ob tb k)) =
    ∑ j, branchOp B (clarkBasis B hm h0 alpha oa ta j) * X *
      star (branchOp B (clarkBasis B hm h0 alpha oa ta j)) :=
  branch_map_basis_invariant B (clarkBasis B hm h0 alpha oa ta)
    (clarkBasis B hm h0 beta ob tb) X

#print axioms clark_branch_map_invariant
end D5.S3.Analytic.Hardy.ClarkWeightedComposition
