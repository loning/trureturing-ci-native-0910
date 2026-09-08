/- GID: D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError
   generality: G
   mirror-B: D5/B/S3/Quantum/Decoherence/FiniteRecordRecoveryError
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Every canonical CPTP recovery has the finite-record trace-distance supremum lower bound. -/

import D5.S3.Quantum.Foundation.FiniteTraceDistance
import D5.S3.Quantum.Decoherence.FiniteShiftedRecordChannel

noncomputable section
open scoped BigOperators ComplexOrder MatrixOrder CStarAlgebra
open D5.S3.Quantum.Foundation.FiniteStateChannel
open D5.S3.Quantum.Foundation.FiniteTraceDistance

namespace D5.S3.Quantum.Decoherence.FiniteRecordRecoveryError

private theorem coefficient_finite_normalization (N : ℕ) (c : ℤ → ℂ)
    (hsupport : ∀ k : ℤ, k < 0 ∨ (N : ℤ) < k → c k = 0)
    (hnorm : (∑' k : ℤ, ‖c k‖ ^ 2) = (1 : ℝ)) :
    (∑ k ∈ Finset.Icc (0 : ℤ) (N : ℤ), ‖c k‖ ^ 2) = (1 : ℝ) := by
  have ht : (∑' k : ℤ, ‖c k‖ ^ 2) = ∑ k ∈ Finset.Icc (0 : ℤ) (N : ℤ), ‖c k‖ ^ 2 := by
    apply tsum_eq_sum
    intro k hk
    have hc := hsupport k (by simpa only [Finset.mem_Icc, not_and_or, not_le] using hk)
    simp [hc]
  exact ht.symm.trans hnorm

theorem coefficient_gamma_neg (c : ℤ → ℂ) (ell : ℤ) :
    (∑' k : ℤ, c (k - ell) * star (c k)) = star (∑' k : ℤ, c (k + ell) * star (c k)) := by
  rw [tsum_star]
  calc
    _ = ∑' k : ℤ, c k * star (c (k + ell)) := by
      simpa using ((Equiv.addRight ell).tsum_eq
        (fun k : ℤ => c (k - ell) * star (c k))).symm
    _ = _ := tsum_congr fun k => by simp [mul_comm]

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

theorem pair_matrix_sqrt (i j : ι) (hij : i ≠ j) (z : ℂ) :
    let H : Matrix ι ι ℂ := Matrix.single i j z + Matrix.single j i (star z)
    CFC.sqrt (H.conjTranspose * H) =
      Matrix.single i i (‖z‖ : ℂ) + Matrix.single j j (‖z‖ : ℂ) := by
  intro H
  have hd (a : ι) : (Matrix.single a a (‖z‖ : ℂ)).PosSemidef := by
    rw [← Matrix.diagonal_single, Matrix.posSemidef_diagonal_iff]
    intro k
    simp only [Pi.single_apply]
    split_ifs <;> positivity
  apply (CFC.sqrt_eq_iff _ _ (Matrix.posSemidef_conjTranspose_mul_self H).nonneg
    ((hd i).add (hd j)).nonneg).mpr
  dsimp [H]
  simp [Matrix.add_mul, Matrix.mul_add, hij, hij.symm, Complex.mul_conj,
    ← Complex.normSq_eq_conj_mul_self, Complex.normSq_eq_norm_sq,
    ← Complex.ofReal_mul, pow_two, add_comm]

theorem pair_matrix_traceNorm (i j : ι) (hij : i ≠ j) (z : ℂ) :
    traceNorm (Matrix.single i j z + Matrix.single j i (star z)) = 2 * ‖z‖ := by
  unfold traceNorm
  rw [pair_matrix_sqrt i j hij z]
  simp
  ring


theorem finite_record_pair_witnesses (N : ℕ) (c : ℤ → ℂ) (q : ι → ℤ)
    (hsupport : ∀ k : ℤ, k < 0 ∨ (N : ℤ) < k → c k = 0)
    (hnorm : (∑' k : ℤ, ‖c k‖ ^ 2) = (1 : ℝ)) (i j : ι) (hij : i ≠ j) :
    let gamma : ℤ → ℂ := fun ell => ∑' k : ℤ, c (k + ell) * star (c k)
    let vp : ι → ℂ := fun k => ((if k = i then 1 else 0) + (if k = j then 1 else 0)) /
      (Real.sqrt 2 : ℂ)
    let vm : ι → ℂ := fun k => ((if k = i then 1 else 0) - (if k = j then 1 else 0)) /
      (Real.sqrt 2 : ℂ)
    ∃ C : QuantumChannel ι ι,
      (∀ A : Matrix ι ι ℂ, act C A = fun k l => gamma (q k - q l) * A k l) ∧
      ∃ rho sigma : DensityState ι,
        CStarMatrix.ofMatrix.symm rho.val = Matrix.vecMulVec vp (star vp) ∧
        CStarMatrix.ofMatrix.symm sigma.val = Matrix.vecMulVec vm (star vm) ∧
        traceDistance rho sigma = 1 ∧
        traceDistance (C.mapState rho) (C.mapState sigma) = ‖gamma (q i - q j)‖ := by
  intro gamma vp vm
  have hreal := FiniteShiftedRecordChannel.finite_shifted_record_channel N c q hsupport
    (coefficient_finite_normalization N c hsupport hnorm)
  dsimp only at hreal
  obtain ⟨C, hC⟩ := hreal.2.2.2.1
  have haction (A : Matrix ι ι ℂ) : act C A = fun k l => gamma (q k - q l) * A k l := by
    unfold act
    rw [hC A]
    ext k l
    rw [hreal.2.2.2.2.1 A k l, hreal.2.1]
  have hroot : (Real.sqrt 2 : ℂ) * (Real.sqrt 2 : ℂ) = 2 := by
    exact_mod_cast Real.mul_self_sqrt (show (0 : ℝ) ≤ 2 by norm_num)
  have hrootinv : (Real.sqrt 2 : ℂ)⁻¹ * (Real.sqrt 2 : ℂ)⁻¹ = 1 / 2 := by
    rw [← mul_inv_rev, hroot]
    norm_num
  have htrace (v : ι → ℂ) (hv : ∀ k, k ≠ i → k ≠ j → v k = 0) :
      Matrix.trace (Matrix.vecMulVec v (star v)) = v i * star (v i) + v j * star (v j) := by
    apply Fintype.sum_eq_add i j hij
    intro k hk
    simp [Matrix.vecMulVec, hv k hk.1 hk.2]
  have htp : Matrix.trace (Matrix.vecMulVec vp (star vp)) = 1 := by
    rw [htrace vp (by intro k hki hkj; simp [vp, hki, hkj])]
    norm_num [vp, hij, hij.symm, div_mul_div_comm, hroot, hrootinv]
  have htm : Matrix.trace (Matrix.vecMulVec vm (star vm)) = 1 := by
    rw [htrace vm (by intro k hki hkj; simp [vm, hki, hkj])]
    norm_num [vm, hij, hij.symm, div_mul_div_comm, hroot, hrootinv]
  let rp : Matrix ι ι ℂ := Matrix.vecMulVec vp (star vp)
  let rm : Matrix ι ι ℂ := Matrix.vecMulVec vm (star vm)
  let rho : DensityState ι := ⟨CStarMatrix.ofMatrix rp,
    map_nonneg CStarMatrix.ofMatrixStarAlgEquiv (Matrix.posSemidef_vecMulVec_self_star vp).nonneg, htp⟩
  let sigma : DensityState ι := ⟨CStarMatrix.ofMatrix rm,
    map_nonneg CStarMatrix.ofMatrixStarAlgEquiv (Matrix.posSemidef_vecMulVec_self_star vm).nonneg, htm⟩
  have hdiff : rp - rm = Matrix.single i j 1 + Matrix.single j i 1 := by
    clear hreal hC haction
    ext k l
    by_cases hki : k = i <;> by_cases hkj : k = j <;>
      by_cases hli : l = i <;> by_cases hlj : l = j
    all_goals subst_vars
    all_goals simp_all [rp, rm, vp, vm, Matrix.vecMulVec, Matrix.single, div_mul_div_comm, eq_comm]
    all_goals rw [← mul_inv_rev, ← hroot]
    all_goals norm_num
  have hconj : gamma (q j - q i) = star (gamma (q i - q j)) := by
    simpa [gamma, sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using
      coefficient_gamma_neg c (q i - q j)
  have hcdiff : CStarMatrix.ofMatrix.symm (C.mapState rho).val -
      CStarMatrix.ofMatrix.symm (C.mapState sigma).val =
        Matrix.single i j (gamma (q i - q j)) + Matrix.single j i (star (gamma (q i - q j))) := by
    change act C rp - act C rm = _
    rw [haction rp, haction rm]
    ext k l
    change gamma (q k - q l) * rp k l - gamma (q k - q l) * rm k l = _
    have hentry := congrFun (congrFun hdiff k) l
    change rp k l - rm k l = _ at hentry
    rw [← mul_sub, hentry]
    by_cases ha : i = k ∧ j = l
    · rcases ha with ⟨rfl, rfl⟩
      simp [Matrix.single, hij, hij.symm]
    · by_cases hb : j = k ∧ i = l
      · rcases hb with ⟨rfl, rfl⟩
        simpa [Matrix.single, hij, hij.symm] using hconj
      · simp [Matrix.single, ha, hb]
  refine ⟨C, haction, rho, sigma, rfl, rfl, ?_, ?_⟩
  · change traceNorm (rp - rm) / 2 = 1
    rw [hdiff]
    have h := pair_matrix_traceNorm i j hij (1 : ℂ)
    norm_num at h
    rw [h]
    norm_num
  · unfold traceDistance
    rw [hcdiff, pair_matrix_traceNorm i j hij]
    ring


theorem finite_record_recovery_error_lower_bound (N : ℕ) (c : ℤ → ℂ) (q : ι → ℤ)
    (hsupport : ∀ k : ℤ, k < 0 ∨ (N : ℤ) < k → c k = 0)
    (hnorm : (∑' k : ℤ, ‖c k‖ ^ 2) = (1 : ℝ))
    (i j : ι) (hgap : q i - q j ≠ 0) (R : QuantumChannel ι ι) :
    let gamma : ℤ → ℂ := fun ell => ∑' k : ℤ, c (k + ell) * star (c k)
    let Lambda : Matrix ι ι ℂ → Matrix ι ι ℂ := fun A k l => gamma (q k - q l) * A k l
    let errors := Set.range (fun rho : DensityState ι =>
      traceNorm (act R (Lambda (CStarMatrix.ofMatrix.symm rho.val)) -
        CStarMatrix.ofMatrix.symm rho.val) / 2)
    (∀ rho sigma : DensityState ι,
      0 ≤ traceDistance rho sigma ∧ traceDistance rho sigma ≤ 1) ∧
    errors.Nonempty ∧ BddAbove errors ∧ (1 - ‖gamma (q i - q j)‖) / 2 ≤ sSup errors := by
  intro gamma Lambda errors
  have hinterval (rho sigma : DensityState ι) :
      0 ≤ traceDistance rho sigma ∧ traceDistance rho sigma ≤ 1 :=
    ⟨traceDistance_nonneg rho sigma, traceDistance_le_one rho sigma⟩
  have hij : i ≠ j := by
    intro heq
    subst j
    exact hgap (sub_self _)
  obtain ⟨C, hC, rho, sigma, _, _, hD, hCD⟩ :=
    finite_record_pair_witnesses N c q hsupport hnorm i j hij
  have herr (tau : DensityState ι) :
      traceNorm (act R (Lambda (CStarMatrix.ofMatrix.symm tau.val)) -
        CStarMatrix.ofMatrix.symm tau.val) / 2 =
      traceDistance (R.mapState (C.mapState tau)) tau := by
    have hmatrix : CStarMatrix.ofMatrix (Lambda (CStarMatrix.ofMatrix.symm tau.val)) =
        (C.mapState tau).val := by
      apply CStarMatrix.ofMatrix.symm.injective
      exact (hC (CStarMatrix.ofMatrix.symm tau.val)).symm
    unfold traceDistance act
    rw [hmatrix]
    rfl
  have hrange : errors = Set.range (fun tau : DensityState ι =>
      traceDistance (R.mapState (C.mapState tau)) tau) := by
    exact congrArg Set.range (funext herr)
  have hnonempty : errors.Nonempty := by
    rw [hrange]
    exact ⟨_, ⟨rho, rfl⟩⟩
  have hbounded : BddAbove errors := by
    refine ⟨1, ?_⟩
    intro x hx
    rw [hrange] at hx
    obtain ⟨tau, rfl⟩ := hx
    exact (hinterval _ _).2
  have hsup (tau : DensityState ι) :
      traceDistance (R.mapState (C.mapState tau)) tau ≤ sSup errors := by
    apply le_csSup hbounded
    rw [hrange]
    exact ⟨tau, rfl⟩
  refine ⟨hinterval, hnonempty, hbounded, ?_⟩
  have hc := traceDistance_contract R (C.mapState rho) (C.mapState sigma)
  rw [hCD] at hc
  have ht := traceDistance_triangle rho (R.mapState (C.mapState rho)) sigma
  have hu := traceDistance_triangle (R.mapState (C.mapState rho))
    (R.mapState (C.mapState sigma)) sigma
  rw [hD, traceDistance_symm rho (R.mapState (C.mapState rho))] at ht
  have hp := hsup rho
  have hm := hsup sigma
  change (1 - ‖(∑' k : ℤ, c (k + (q i - q j)) * star (c k))‖) / 2 ≤ sSup errors
  linarith

end D5.S3.Quantum.Decoherence.FiniteRecordRecoveryError
