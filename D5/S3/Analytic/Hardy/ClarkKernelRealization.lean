/- GID: D5/S3/Analytic/Hardy/ClarkKernelRealization
   generality: G
   mirror-B: D5/B/S3/Analytic/Hardy/ClarkKernelRealization
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: [mathlib/module/Mathlib.Analysis.InnerProductSpace.l2Space]
   utility: none
   digest: Actual disk model vectors extend analytically across the circle; normalized boundary kernels construct every phase Clark basis. -/

/- The frozen orthogonal-complement carrier has the actual native disk multiplier.
   Its dimension and rational representation follow from the rank-one recurrence and
   explicit defect decomposition. Analytic extension defines boundary evaluation only
   on this model space. Riesz kernels have the proved positive Poisson norm; every
   circle fibre yields a Clark basis, with arbitrary ordering and individual unit phases. -/

import D5.S3.Analytic.Hardy.FiniteBlaschkeMultiplier
import D5.S3.Zeros.ShiftOperators.InverseBlaschkeHistoryDeletion
import Mathlib.Analysis.Analytic.Polynomial
import D5.S3.Analytic.Hardy.PhaseFibreClarkBasis
import Mathlib.Analysis.Calculus.TangentCone.Real
import Mathlib.Analysis.InnerProductSpace.Dual
noncomputable section
open D5.S3.Analytic.Hardy.HardyCoefficientRealization
open D5.S3.Analytic.Hardy.FiniteBlaschkeMultiplier
open scoped InnerProductSpace ComplexConjugate
namespace D5.S3.Analytic.Hardy.ClarkKernelRealization

def hardyKernel (w : Complex.UnitDisc) : H2 :=
  ⟨fun n => star (w : Complex)^n, memℓp_gen (by
    have hs := summable_geometric_of_lt_one (sq_nonneg ‖(w : Complex)‖) w.sq_norm_lt_one
    simpa [norm_pow, norm_star, ← pow_mul, Nat.mul_comm] using hs)⟩

theorem hardyKernel_reproduces (w : Complex.UnitDisc) (f : H2) :
    ⟪hardyKernel w, f⟫_Complex = evaluate f (w : Complex) := by
  apply (lp.hasSum_inner (hardyKernel w) f).unique
  simpa [hardyKernel, RCLike.inner_apply, RCLike.star_def, mul_comm] using
    evaluate_hasSum f w.norm_lt_one

theorem hardyKernel_evaluate (w : Complex.UnitDisc) {z : Complex} (hz : ‖z‖ < 1) :
    evaluate (hardyKernel w) z = 1/(1-z*star (w : Complex)) := by
  have hp : ‖z*star (w : Complex)‖ < 1 := by
    rw [norm_mul, norm_star]
    exact lt_of_le_of_lt
      (mul_le_mul_of_nonneg_right hz.le (norm_nonneg _)) (by simpa using w.norm_lt_one)
  apply (evaluate_hasSum (hardyKernel w) hz).unique
  simpa [hardyKernel, mul_pow, mul_comm, one_div] using hasSum_geometric_of_norm_lt_one hp

abbrev modelSpace {m : Nat} (B : FiniteBlaschkeData m) : Submodule Complex H2 :=
  D5.S3.Zeros.ShiftOperators.InverseBlaschkeHistoryDeletion.modelSpace (mul B)

def model_kernel {m : Nat} (B : FiniteBlaschkeData m) (w : Complex.UnitDisc) : H2 :=
  hardyKernel w - star (value B (w : Complex)) • mul B (hardyKernel w)

theorem model_kernel_mem {m : Nat} (B : FiniteBlaschkeData m) (w : Complex.UnitDisc) :
    model_kernel B w ∈ modelSpace B := by
  apply ((mul B).range.mem_orthogonal' _).mpr
  rintro _ ⟨f, rfl⟩
  change ⟪model_kernel B w, mul B f⟫_Complex = 0
  have hi := (LinearMap.norm_map_iff_inner_map_map (𝕜 := Complex) (mul B)).mp
    ((mul_isometry B).norm_map_of_map_zero (map_zero (mul B)))
  simp only [model_kernel, inner_sub_left, inner_smul_left, RCLike.star_def,
    starRingEnd_self_apply, hi, hardyKernel_reproduces, mul_eval B f w.norm_lt_one]
  ring

theorem model_kernel_evaluate {m : Nat} (B : FiniteBlaschkeData m) (w : Complex.UnitDisc)
    {z : Complex} (hz : ‖z‖ < 1) :
    evaluate (model_kernel B w) z =
      (1-value B z*star (value B (w : Complex)))/(1-z*star (w : Complex)) := by
  have he := (eval z hz).map_sub (hardyKernel w)
    (star (value B (w : Complex)) • mul B (hardyKernel w))
  change evaluate (model_kernel B w) z = _ at he
  rw [he, map_smul, eval_apply, eval_apply, mul_eval B _ hz, hardyKernel_evaluate w hz]
  simp only [smul_eq_mul]
  ring

theorem model_kernel_reproduces {m : Nat} (B : FiniteBlaschkeData m) (w : Complex.UnitDisc)
    (g : modelSpace B) :
    ⟪model_kernel B w, (g : H2)⟫_Complex = evaluate (g : H2) (w : Complex) := by
  have hg : ⟪mul B (hardyKernel w), (g : H2)⟫_Complex = 0 :=
    ((mul B).range.mem_orthogonal (g : H2)).mp g.property _ ⟨hardyKernel w, rfl⟩
  simp only [model_kernel, inner_sub_left, inner_smul_left, hg, mul_zero, sub_zero,
    hardyKernel_reproduces]

#print axioms model_kernel_mem
#print axioms model_kernel_evaluate
#print axioms model_kernel_reproduces
theorem factor_range (a : Complex) (ha : ‖a‖ < 1) :
    (factor a ha).range = (shift.toContinuousLinearMap - a • (1 : H2 →L[Complex] H2)).range := by
  ext v
  constructor
  · rintro ⟨f, rfl⟩
    exact ⟨(↑((denominatorUnit a ha)⁻¹) : H2 →L[Complex] H2) f, rfl⟩
  · rintro ⟨f, rfl⟩
    refine ⟨(denominatorUnit a ha : H2 →L[Complex] H2) f, ?_⟩
    have h := congrArg (fun T : H2 →L[Complex] H2 => T f) (Units.inv_val (denominatorUnit a ha))
    change (↑((denominatorUnit a ha)⁻¹) : H2 →L[Complex] H2)
      ((denominatorUnit a ha : H2 →L[Complex] H2) f) = f at h
    change (shift.toContinuousLinearMap - a • (1 : H2 →L[Complex] H2))
      ((↑((denominatorUnit a ha)⁻¹) : H2 →L[Complex] H2)
        ((denominatorUnit a ha : H2 →L[Complex] H2) f)) = _
    rw [h]
    rfl

private theorem shift_single (n : Nat) :
    shift (lp.single 2 n (1 : Complex)) = lp.single 2 (n+1) (1 : Complex) := by
  apply lp.ext
  funext k
  cases k with
  | zero => simp [shift_zero, lp.single_apply]
  | succ k => simp [shift_succ, lp.single_apply, Pi.single_apply]

theorem factor_model_recurrence (a : Complex) (ha : ‖a‖ < 1)
    (g : (factor a ha).rangeᗮ) (n : Nat) :
    (g : H2) (n+1) = star a * (g : H2) n := by
  let R := shift.toContinuousLinearMap - a • (1 : H2 →L[Complex] H2)
  have hg : (g : H2) ∈ R.rangeᗮ := by
    change (g : H2) ∈ (shift.toContinuousLinearMap - a • (1 : H2 →L[Complex] H2)).rangeᗮ
    rw [← factor_range a ha]
    exact g.property
  have h := (R.range.mem_orthogonal (g : H2)).mp hg _
    ⟨lp.single 2 n (1 : Complex), rfl⟩
  change ⟪shift (lp.single 2 n (1 : Complex)) - a • lp.single 2 n (1 : Complex), (g : H2)⟫_Complex = 0 at h
  simp only [shift_single, inner_sub_left, inner_smul_left, lp.inner_single_left,
    RCLike.inner_apply, map_one] at h
  simpa [RCLike.star_def] using sub_eq_zero.mp h

theorem factor_model_finite (a : Complex) (ha : ‖a‖ < 1) :
    FiniteDimensional Complex (factor a ha).rangeᗮ := by
  let L : (factor a ha).rangeᗮ →ₗ[Complex] Complex :=
    (lp.evalₗ (fun _ : Nat => Complex) 2 0).comp ((factor a ha).rangeᗮ.subtype)
  apply FiniteDimensional.of_injective L
  intro f g h
  apply Subtype.ext
  apply lp.ext
  funext n
  induction n with
  | zero => exact h
  | succ n ih =>
    rw [factor_model_recurrence a ha f n, factor_model_recurrence a ha g n, ih]

def defectProductEquiv (V W : H2 →L[Complex] H2) (hV : Isometry V) :
    (V * W).rangeᗮ ≃ₗ[Complex] (V.rangeᗮ × W.rangeᗮ) := by
  have hVV (x : H2) : V.adjoint (V x) = x := by
    have h := congrArg (fun T : H2 →L[Complex] H2 => T x)
      (V.isometry_iff_adjoint_comp_self.mp hV)
    exact h
  have hmem (x : H2) : x ∈ (V * W).rangeᗮ ↔ W.adjoint (V.adjoint x) = 0 := by
    rw [ContinuousLinearMap.orthogonal_range]
    change (V * W).adjoint x = 0 ↔ _
    rw [show V * W = V.comp W from rfl, ContinuousLinearMap.adjoint_comp]
    rfl
  let L : (V * W).rangeᗮ →ₗ[Complex] (V.rangeᗮ × W.rangeᗮ) :=
    { toFun := fun x =>
        (⟨(x : H2) - V (V.adjoint x), by
          rw [ContinuousLinearMap.orthogonal_range]
          change V.adjoint ((x : H2) - V (V.adjoint x)) = 0
          simp [hVV]⟩,
         ⟨V.adjoint x, by
          rw [ContinuousLinearMap.orthogonal_range]
          exact (hmem x).mp x.property⟩)
      map_add' := by
        intro x y
        apply Prod.ext <;> apply Subtype.ext
        · change (↑x + ↑y) - V (V.adjoint (↑x + ↑y)) =
            (↑x - V (V.adjoint ↑x)) + (↑y - V (V.adjoint ↑y))
          simp only [map_add]
          abel
        · change V.adjoint (↑x + ↑y) = V.adjoint ↑x + V.adjoint ↑y
          exact map_add _ _ _
      map_smul' := by
        intro c x
        apply Prod.ext <;> apply Subtype.ext
        · change c • ↑x - V (V.adjoint (c • ↑x)) = c • (↑x - V (V.adjoint ↑x))
          simp [smul_sub]
        · change V.adjoint (c • ↑x) = c • V.adjoint ↑x
          exact map_smul _ _ _ }
  apply LinearEquiv.ofBijective L
  constructor
  · intro x y h
    have h1 := congrArg (fun p : V.rangeᗮ × W.rangeᗮ => (p.1 : H2)) h
    have h2 := congrArg (fun p : V.rangeᗮ × W.rangeᗮ => (p.2 : H2)) h
    change V.adjoint (x : H2) = V.adjoint (y : H2) at h2
    change (x : H2) - V (V.adjoint x) = (y : H2) - V (V.adjoint y) at h1
    rw [h2] at h1
    exact Subtype.ext (sub_left_injective h1)
  · rintro ⟨u, v⟩
    have hu : V.adjoint (u : H2) = 0 := by
      simpa only [ContinuousLinearMap.orthogonal_range, LinearMap.mem_ker,
        ContinuousLinearMap.coe_coe] using u.property
    have hv : W.adjoint (v : H2) = 0 := by
      simpa only [ContinuousLinearMap.orthogonal_range, LinearMap.mem_ker,
        ContinuousLinearMap.coe_coe] using v.property
    refine ⟨⟨(u : H2) + V v, (hmem _).mpr (by simp [hu, hv, hVV])⟩, ?_⟩
    apply Prod.ext <;> apply Subtype.ext
    · change (↑u + V ↑v) - V (V.adjoint (↑u + V ↑v)) = ↑u
      simp [hu, hVV]
    · change V.adjoint (↑u + V ↑v) = ↑v
      simp [hu, hVV]

theorem factor_model_finrank (a : Complex) (ha : ‖a‖ < 1) :
    Module.finrank Complex (factor a ha).rangeᗮ = 1 := by
  let L : (factor a ha).rangeᗮ →ₗ[Complex] Complex :=
    (lp.evalₗ (fun _ : Nat => Complex) 2 0).comp ((factor a ha).rangeᗮ.subtype)
  have hinj : Function.Injective L := by
    intro f g h
    apply Subtype.ext
    apply lp.ext
    funext n
    induction n with
    | zero => exact h
    | succ n ih =>
      rw [factor_model_recurrence a ha f n, factor_model_recurrence a ha g n, ih]
  let w : Complex.UnitDisc := ⟨a, by simpa using ha⟩
  have hmem : hardyKernel w ∈ (factor a ha).rangeᗮ := by
    apply ((factor a ha).range.mem_orthogonal' _).mpr
    rintro _ ⟨f, rfl⟩
    rw [hardyKernel_reproduces]
    change evaluate (factor a ha f) a = 0
    rw [factor_evaluate _ _ _ ha]
    simp
  have hsurj : Function.Surjective L := by
    intro c
    refine ⟨⟨c • hardyKernel w, Submodule.smul_mem _ c hmem⟩, ?_⟩
    simp [L, hardyKernel]
  have := (LinearEquiv.ofBijective L ⟨hinj, hsurj⟩).finrank_eq
  simpa using this

private theorem list_model_dimension (as : List Complex.UnitDisc) :
    FiniteDimensional Complex ((as.map (fun a : Complex.UnitDisc => factor (a : Complex) a.norm_lt_one)).prod).rangeᗮ ∧
    Module.finrank Complex ((as.map (fun a : Complex.UnitDisc => factor (a : Complex) a.norm_lt_one)).prod).rangeᗮ = as.length := by
  induction as with
  | nil =>
    change FiniteDimensional Complex (1 : H2 →L[Complex] H2).rangeᗮ ∧
      Module.finrank Complex (1 : H2 →L[Complex] H2).rangeᗮ = 0
    have he : (1 : H2 →L[Complex] H2).rangeᗮ = ⊥ := by
      change (LinearMap.id : H2 →ₗ[Complex] H2).rangeᗮ = ⊥
      simp
    rw [he]
    exact ⟨inferInstance, by simp⟩
  | cons a as ih =>
    simp only [List.length_cons]
    let W := (as.map (fun a : Complex.UnitDisc => factor (a : Complex) a.norm_lt_one)).prod
    let e := defectProductEquiv (factor (a : Complex) a.norm_lt_one) W
      (factor_isometry (a : Complex) a.norm_lt_one)
    let := ih.1
    let := factor_model_finite (a : Complex) a.norm_lt_one
    refine ⟨FiniteDimensional.of_injective e.toLinearMap e.injective, ?_⟩
    change Module.finrank Complex (factor (a : Complex) a.norm_lt_one * W).rangeᗮ = as.length + 1
    rw [e.finrank_eq, Module.finrank_prod, factor_model_finrank]
    rw [ih.2, Nat.add_comm]

theorem modelSpace_finite {m : Nat} (B : FiniteBlaschkeData m) :
    FiniteDimensional Complex (modelSpace B) := by
  unfold modelSpace D5.S3.Zeros.ShiftOperators.InverseBlaschkeHistoryDeletion.modelSpace mul
  rw [ContinuousLinearMap.toLinearMap_smul, LinearMap.range_smul _ _ B.phase.coe_ne_zero]
  exact (list_model_dimension (List.ofFn B.zeros)).1

theorem modelSpace_finrank {m : Nat} (B : FiniteBlaschkeData m) :
    Module.finrank Complex (modelSpace B) = m := by
  unfold modelSpace D5.S3.Zeros.ShiftOperators.InverseBlaschkeHistoryDeletion.modelSpace mul
  rw [ContinuousLinearMap.toLinearMap_smul, LinearMap.range_smul _ _ B.phase.coe_ne_zero]
  simpa using (list_model_dimension (List.ofFn B.zeros)).2

#print axioms factor_model_finite
#print axioms defectProductEquiv
#print axioms factor_model_finrank
#print axioms list_model_dimension
#print axioms modelSpace_finite
#print axioms modelSpace_finrank
open Polynomial

theorem factor_model_evaluate (a : Complex) (ha : ‖a‖ < 1) (f : (factor a ha).rangeᗮ)
    (z : Complex) (hz : ‖z‖ < 1) : evaluate (f : H2) z = (f : H2) 0 / (1-star a*z) := by
  have hc (n : Nat) : (f : H2) n = (f : H2) 0 * (star a)^n := by
    induction n with
    | zero => simp
    | succ n ih => rw [factor_model_recurrence a ha f n, ih, pow_succ]; ring
  have hn : ‖star a*z‖ < 1 := by
    rw [norm_mul, norm_star]
    exact lt_of_le_of_lt (mul_le_of_le_one_right (norm_nonneg _) hz.le) ha
  have hs := (hasSum_geometric_of_norm_lt_one hn).mul_left ((f : H2) 0)
  apply (evaluate_hasSum (f : H2) hz).unique
  convert! hs using 1
  funext n
  rw [hc n, mul_pow, mul_assoc]

private theorem list_model_rational (as : List Complex.UnitDisc)
    (f : ((as.map (fun a : Complex.UnitDisc => factor (a : Complex) a.norm_lt_one)).prod).rangeᗮ) :
    ∃ p : Polynomial Complex, ∀ z : Complex, ‖z‖ < 1 → evaluate (f : H2) z = p.eval z /
      ((as.map (fun a : Complex.UnitDisc => 1-C (star (a : Complex))*X)).prod).eval z := by
  induction as with
  | nil =>
    have hf : (f : H2) = 0 := by
      have hf := f.property
      change (f : H2) ∈ (1 : H2 →L[Complex] H2).rangeᗮ at hf
      rw [ContinuousLinearMap.orthogonal_range] at hf
      simpa only [ContinuousLinearMap.adjoint_one, LinearMap.mem_ker,
        ContinuousLinearMap.coe_coe, one_apply_eq_self] using hf
    refine ⟨0, ?_⟩
    intro z hz
    simp [hf, evaluate]
  | cons a as ih =>
    let V := factor (a : Complex) a.norm_lt_one
    let W := (as.map (fun a : Complex.UnitDisc => factor (a : Complex) a.norm_lt_one)).prod
    let e := defectProductEquiv V W (factor_isometry (a : Complex) a.norm_lt_one)
    let u := (e f).1
    let v := (e f).2
    obtain ⟨p, hp⟩ := ih v
    let Q := (as.map (fun a : Complex.UnitDisc => 1-C (star (a : Complex))*X)).prod
    refine ⟨C ((u : H2) 0) * Q + (X-C (a : Complex))*p, ?_⟩
    intro z hz
    have hsplit : (f : H2) = (u : H2) + V (v : H2) := by
      change (f : H2) = ((f : H2) - V (V.adjoint (f : H2))) + V (V.adjoint (f : H2))
      abel
    have he := (D5.S3.Analytic.Hardy.HardyCoefficientRealization.eval z hz).map_add
      (u : H2) (V (v : H2))
    change evaluate ((u : H2) + V (v : H2)) z = evaluate (u : H2) z + evaluate (V (v : H2)) z at he
    rw [hsplit, he, factor_evaluate _ _ _ hz, factor_model_evaluate _ _ _ z hz, hp z hz]
    have hd : 1-star (a : Complex)*z ≠ 0 := factor_denominator_ne_zero_closed a z hz.le
    have hQ : Q.eval z ≠ 0 := by
      simp only [Q, eval_list_prod, List.map_map, Function.comp_def, eval_sub,
        eval_one, eval_mul, eval_C, eval_X]
      apply List.prod_ne_zero
      intro hb
      obtain ⟨a, ha, haz⟩ := List.mem_map.mp hb
      exact factor_denominator_ne_zero_closed a z hz.le haz
    simp only [List.map_cons, List.prod_cons, eval_mul, eval_sub, eval_one, eval_C,
      eval_X, eval_add]
    change (u : H2) 0 / (1-star (a : Complex)*z) +
      ((z-(a : Complex))/(1-star (a : Complex)*z))*(p.eval z/Q.eval z) =
      (((u : H2) 0)*Q.eval z+(z-(a : Complex))*p.eval z)/
      ((1-star (a : Complex)*z)*Q.eval z)
    field_simp

theorem modelSpace_rational {m : Nat} (B : FiniteBlaschkeData m) (f : modelSpace B) :
    ∃ p : Polynomial Complex, ∀ z : Complex, ‖z‖ < 1 →
      evaluate (f : H2) z = p.eval z / (denominator B).eval z := by
  have he : modelSpace B = ((List.ofFn B.zeros).map
      (fun a : Complex.UnitDisc => factor (a : Complex) a.norm_lt_one)).prod.rangeᗮ := by
    unfold modelSpace D5.S3.Zeros.ShiftOperators.InverseBlaschkeHistoryDeletion.modelSpace mul
    rw [ContinuousLinearMap.toLinearMap_smul, LinearMap.range_smul _ _ B.phase.coe_ne_zero]
  have hf := Eq.mp (congrArg (fun S : Submodule Complex H2 => (f : H2) ∈ S) he) f.property
  obtain ⟨p, hp⟩ := list_model_rational (List.ofFn B.zeros) ⟨f, hf⟩
  refine ⟨p, ?_⟩
  intro z hz
  simpa only [denominator, List.map_ofFn, List.prod_ofFn, Function.comp_def] using hp z hz

theorem modelSpace_analytic_extension {m : Nat} (B : FiniteBlaschkeData m) (f : modelSpace B) :
    ∃ g : Complex → Complex, AnalyticOnNhd Complex g (Metric.closedBall 0 1) ∧
      ∀ z : Complex, ‖z‖ < 1 → g z = evaluate (f : H2) z := by
  obtain ⟨p, hp⟩ := modelSpace_rational B f
  refine ⟨fun z => p.eval z / (denominator B).eval z, ?_, fun z hz => (hp z hz).symm⟩
  intro z hz
  exact (AnalyticOnNhd.eval_polynomial p z (Set.mem_univ z)).div
    (AnalyticOnNhd.eval_polynomial (denominator B) z (Set.mem_univ z))
    (denominator_ne_zero_closed B z (by simpa using hz))


#print axioms modelSpace_analytic_extension
def boundaryValue {m : Nat} (B : FiniteBlaschkeData m) (f : modelSpace B) : Complex → Complex :=
  (modelSpace_analytic_extension B f).choose

theorem boundaryValue_interior {m} (B : FiniteBlaschkeData m) (f : modelSpace B)
    (z : Complex) (hz : ‖z‖ < 1) : boundaryValue B f z = evaluate (f : H2) z :=
  (modelSpace_analytic_extension B f).choose_spec.2 z hz

theorem boundaryValue_analytic {m} (B : FiniteBlaschkeData m) (f : modelSpace B) :
    AnalyticOnNhd Complex (boundaryValue B f) (Metric.closedBall 0 1) :=
  (modelSpace_analytic_extension B f).choose_spec.1

theorem boundaryValue_unique {m} (B : FiniteBlaschkeData m) (f : modelSpace B)
    (g : Complex → Complex) (hg : ContinuousOn g (Metric.closedBall 0 1))
    (hi : ∀ z : Complex, ‖z‖ < 1 → g z = evaluate (f : H2) z)
    (z : Complex) (hz : ‖z‖ ≤ 1) : boundaryValue B f z = g z := by
  have he : Set.EqOn (boundaryValue B f) g (Metric.ball 0 1) := by
    intro w hw
    have hw' : ‖w‖ < 1 := by simpa using hw
    rw [boundaryValue_interior B f w hw', hi w hw']
  exact he.of_subset_closure (boundaryValue_analytic B f).continuousOn hg
    Metric.ball_subset_closedBall (by rw [closure_ball (0 : Complex) (by norm_num : (1 : Real) ≠ 0)])
    (by simpa using hz)

def boundaryEval {m} (B : FiniteBlaschkeData m) (zeta : Circle) : modelSpace B →L[Complex] Complex := by
  letI := modelSpace_finite B
  let L : modelSpace B →ₗ[Complex] Complex :=
    { toFun := fun f => boundaryValue B f zeta
      map_add' := by
        intro f g
        apply boundaryValue_unique B (f+g) (fun z => boundaryValue B f z + boundaryValue B g z)
        · exact (boundaryValue_analytic B f).continuousOn.add (boundaryValue_analytic B g).continuousOn
        · intro z hz
          rw [boundaryValue_interior B f z hz, boundaryValue_interior B g z hz]
          exact ((D5.S3.Analytic.Hardy.HardyCoefficientRealization.eval z hz).map_add (f : H2) (g : H2)).symm
        · exact le_of_eq (Circle.norm_coe zeta)
      map_smul' := by
        intro c f
        change boundaryValue B (c • f) zeta = c * boundaryValue B f zeta
        apply boundaryValue_unique B (c • f) (fun z => c * boundaryValue B f z)
        · exact continuousOn_const.mul (boundaryValue_analytic B f).continuousOn
        · intro z hz
          rw [boundaryValue_interior B f z hz]
          exact ((D5.S3.Analytic.Hardy.HardyCoefficientRealization.eval z hz).map_smul c (f : H2)).symm
        · exact le_of_eq (Circle.norm_coe zeta) }
  exact ⟨L, L.continuous_of_finiteDimensional⟩

theorem boundaryEval_apply {m} (B : FiniteBlaschkeData m) (zeta : Circle) (f : modelSpace B) :
    boundaryEval B zeta f = boundaryValue B f zeta := rfl

def boundaryKernel {m} (B : FiniteBlaschkeData m) (zeta : Circle) : modelSpace B := by
  letI := modelSpace_finite B
  exact (InnerProductSpace.toDual Complex (modelSpace B)).symm (boundaryEval B zeta)

theorem boundaryKernel_reproduces {m} (B : FiniteBlaschkeData m) (zeta : Circle) (f : modelSpace B) :
    ⟪boundaryKernel B zeta, f⟫_Complex = boundaryValue B f zeta := by
  let _ := modelSpace_finite B
  exact InnerProductSpace.toDual_symm_apply

theorem boundaryKernel_evaluate {m} (B : FiniteBlaschkeData m) (zeta : Circle)
    (z : Complex) (hz : ‖z‖ < 1) : evaluate (boundaryKernel B zeta : H2) z =
      (1-value B z*star (value B zeta))/(1-z*star (zeta : Complex)) := by
  let w : Complex.UnitDisc := ⟨z, by simpa using hz⟩
  let k : modelSpace B := ⟨model_kernel B w, model_kernel_mem B w⟩
  have hvcont : ContinuousOn (value B) (Metric.closedBall 0 1) := by
    have he : value B = fun x => (B.phase : Complex) * (numerator B).eval x / (denominator B).eval x :=
      funext (value_eq_polynomial_div B)
    rw [he]
    exact (continuousOn_const.mul (numerator B).continuous.continuousOn).div
      (denominator B).continuous.continuousOn (fun x hx => denominator_ne_zero_closed B x (by simpa using hx))
  have hk := boundaryValue_unique B k
    (fun x => (1-value B x*star (value B z))/(1-x*star z))
    ((continuousOn_const.sub (hvcont.mul continuousOn_const)).div
      (continuousOn_const.sub (continuousOn_id.mul continuousOn_const)) (fun x hx => by
        have hd := factor_denominator_ne_zero_closed w x (by simpa using hx)
        change 1-star z*x ≠ 0 at hd
        simpa only [mul_comm] using hd))
    (fun x hx => (model_kernel_evaluate B w hx).symm) (zeta : Complex)
    (le_of_eq (Circle.norm_coe zeta))
  have h := boundaryKernel_reproduces B zeta k
  rw [hk] at h
  have hh := congrArg star h
  simp only [RCLike.star_def, inner_conj_symm] at hh
  change ⟪model_kernel B w, (boundaryKernel B zeta : H2)⟫_Complex = _ at hh
  rw [model_kernel_reproduces] at hh
  convert! hh using 1
  simp only [map_div₀, map_sub, map_one, map_mul, starRingEnd_self_apply, RCLike.star_def]
  ring

theorem boundaryKernel_identity {m} (B : FiniteBlaschkeData m) (zeta : Circle)
    (z : Complex) (hz : ‖z‖ ≤ 1) : boundaryValue B (boundaryKernel B zeta) z *
      (1-z*star (zeta : Complex)) = 1-value B z*star (value B zeta) := by
  have hvcont : ContinuousOn (value B) (Metric.closedBall 0 1) := by
    have he : value B = fun x => (B.phase : Complex) * (numerator B).eval x / (denominator B).eval x :=
      funext (value_eq_polynomial_div B)
    rw [he]
    exact (continuousOn_const.mul (numerator B).continuous.continuousOn).div
      (denominator B).continuous.continuousOn (fun x hx => denominator_ne_zero_closed B x (by simpa using hx))
  have he : Set.EqOn (fun x => boundaryValue B (boundaryKernel B zeta) x *
      (1-x*star (zeta : Complex))) (fun x => 1-value B x*star (value B zeta)) (Metric.ball 0 1) := by
    intro x hx
    dsimp only
    have hx' : ‖x‖ < 1 := by simpa using hx
    rw [boundaryValue_interior B _ x hx', boundaryKernel_evaluate B zeta x hx']
    apply div_mul_cancel₀
    apply sub_ne_zero.mpr
    intro hh
    have hn : ‖x*star (zeta : Complex)‖ < 1 := by
      simpa only [norm_mul, norm_star, Circle.norm_coe, mul_one] using hx'
    rw [← hh, norm_one] at hn
    exact (lt_irrefl _ hn)
  exact he.of_subset_closure
    ((boundaryValue_analytic B _).continuousOn.mul
      (continuousOn_const.sub (continuousOn_id.mul continuousOn_const)))
    (continuousOn_const.sub (hvcont.mul continuousOn_const)) Metric.ball_subset_closedBall
    (by rw [closure_ball (0 : Complex) (by norm_num : (1 : Real) ≠ 0)]) (by simpa using hz)

theorem boundaryKernel_normSq {m} (B : FiniteBlaschkeData m) (alpha zeta : Circle)
    (hv : value B zeta = (alpha : Complex)) :
    ⟪boundaryKernel B zeta, boundaryKernel B zeta⟫_Complex = (poissonWeight B zeta : Complex) := by
  let k := boundaryKernel B zeta
  let z : Complex := zeta
  have hz : z ∈ Metric.closedBall (0 : Complex) 1 := by
    simpa only [Metric.mem_closedBall, dist_zero_right, z, Circle.norm_coe] using le_rfl (a := (1 : Real))
  have hud : UniqueDiffWithinAt Complex (Metric.closedBall (0 : Complex) 1) z := by
    apply UniqueDiffWithinAt.mono_field (𝕜 := Real)
    exact uniqueDiffOn_convex (convex_closedBall (0 : Complex) 1)
      (by rw [interior_closedBall (0 : Complex) (by norm_num : (1 : Real) ≠ 0)];
          exact Metric.nonempty_ball.mpr (by norm_num)) z hz
  have hg := ((boundaryValue_analytic B k) z hz).differentiableAt.hasDerivAt
  have hl := hg.mul ((hasDerivAt_const z (1 : Complex)).sub
    ((hasDerivAt_id z).mul_const (star z)))
  have hr := (hasDerivAt_const z (1 : Complex)).sub
    ((value_hasDerivAt_circle B zeta).mul_const (star (value B z)))
  have he (x : Complex) (hx : x ∈ Metric.closedBall (0 : Complex) 1) :
      1-value B x*star (value B z) = boundaryValue B k x * (1-x*star z) :=
    (boundaryKernel_identity B zeta x (by simpa using hx)).symm
  have hd := (hl.hasDerivWithinAt.congr he (he z hz)).derivWithin hud
  have hder : derivWithin (fun x => 1-value B x*star (value B z)) (Metric.closedBall 0 1) z =
      0 - value B z / z * (poissonWeight B zeta : Complex) * star (value B z) := by
    convert! hr.hasDerivWithinAt.derivWithin hud using 1
  rw [hder] at hd
  have hzstar : z * star z = 1 := by
    rw [Complex.star_def, Complex.mul_conj, Complex.normSq_eq_norm_sq]
    change ((‖(zeta : Complex)‖^2 : Real) : Complex) = 1
    rw [Circle.norm_coe]
    norm_num
  have hastar : (alpha : Complex) * star (alpha : Complex) = 1 := by
    rw [Complex.star_def, Complex.mul_conj, Complex.normSq_eq_norm_sq, Circle.norm_coe]
    norm_num
  change value B z = (alpha : Complex) at hv
  simp only [id_eq, Pi.sub_apply, hzstar, sub_self, mul_zero, zero_sub,
    zero_add, hv] at hd
  rw [boundaryKernel_reproduces]
  change boundaryValue B k z = (poissonWeight B zeta : Complex)
  have hh := congrArg (fun t : Complex => t*z) hd
  have hz0 : z ≠ 0 := zeta.coe_ne_zero
  field_simp [hz0] at hh
  linear_combination hh - boundaryValue B k z * hzstar + (poissonWeight B zeta : Complex) * hastar

def phasePoints {m : Nat} (B : FiniteBlaschkeData m) (hm : 0 < m) (h0 : value B 0 = 0)
    (alpha : Circle) : Fin m → Circle := (phase_fibre B alpha hm h0).choose

def normalizedClarkFamily {m} (B : FiniteBlaschkeData m) (hm : 0 < m)
    (h0 : value B 0 = 0) (alpha : Circle) (order : Fin m ≃ Fin m)
    (theta : Fin m → Circle) (j : Fin m) : modelSpace B :=
  ((theta j : Complex)/(Real.sqrt (poissonWeight B (phasePoints B hm h0 alpha (order j))) : Complex)) •
    boundaryKernel B (phasePoints B hm h0 alpha (order j))

theorem normalizedClarkFamily_apply {m} (B : FiniteBlaschkeData m) (hm : 0 < m)
    (h0 : value B 0 = 0) (alpha : Circle) (order : Fin m ≃ Fin m)
    (theta : Fin m → Circle) (j : Fin m) :
    normalizedClarkFamily B hm h0 alpha order theta j =
      ((theta j : Complex)/(Real.sqrt (poissonWeight B (phasePoints B hm h0 alpha (order j))) : Complex)) •
        boundaryKernel B (phasePoints B hm h0 alpha (order j)) := rfl

theorem normalizedClarkFamily_orthonormal {m} (B : FiniteBlaschkeData m) (hm : 0 < m)
    (h0 : value B 0 = 0) (alpha : Circle) (order : Fin m ≃ Fin m) (theta : Fin m → Circle) :
    Orthonormal Complex (normalizedClarkFamily B hm h0 alpha order theta) := by
  classical
  let zeta := phasePoints B hm h0 alpha
  have hpts := (phase_fibre B alpha hm h0).choose_spec
  have hv (j : Fin m) : value B (zeta j) = (alpha : Complex) :=
    ((hpts.2.1 (zeta j : Complex)).mpr ⟨j, rfl⟩).1
  have hinj : Function.Injective zeta := hpts.1
  apply orthonormal_iff_ite.mpr
  intro i j
  simp only [normalizedClarkFamily, inner_smul_left, inner_smul_right]
  by_cases hij : i = j
  · subst j
    rw [boundaryKernel_normSq B alpha _ (hv (order i)), if_pos rfl]
    let p := poissonWeight B (zeta (order i))
    have hp : 0 < p := poissonWeight_pos B (zeta (order i)) hm
    have hs0 : (Real.sqrt p : Complex) ≠ 0 := by
      exact_mod_cast (Real.sqrt_pos.mpr hp).ne'
    have hs : (Real.sqrt p : Complex)^2 = (p : Complex) := by
      exact_mod_cast Real.sq_sqrt hp.le
    have ht : star (theta i : Complex) * (theta i : Complex) = 1 := by
      rw [mul_comm, Complex.star_def, Complex.mul_conj, Complex.normSq_eq_norm_sq, Circle.norm_coe]
      norm_num
    change ((theta i : Complex)/(Real.sqrt p : Complex)) *
      (star ((theta i : Complex)/(Real.sqrt p : Complex))*(p : Complex)) = 1
    rw [star_div₀, Complex.star_def, Complex.conj_ofReal]
    field_simp [hs0]
    simp only [Complex.star_def] at ht
    linear_combination (p : Complex) * ht - hs
  · have hden : 1-(zeta (order i) : Complex)*star (zeta (order j) : Complex) ≠ 0 := by
      intro h
      have hjstar : star (zeta (order j) : Complex)*(zeta (order j) : Complex) = 1 := by
        rw [mul_comm, Complex.star_def, Complex.mul_conj, Complex.normSq_eq_norm_sq, Circle.norm_coe]
        norm_num
      have hh := congrArg (fun t : Complex => t*(zeta (order j) : Complex)) (sub_eq_zero.mp h).symm
      rw [mul_assoc, hjstar, mul_one, one_mul] at hh
      exact hij (order.injective (hinj (Subtype.ext hh)))
    have hk := boundaryKernel_identity B (zeta (order j)) (zeta (order i) : Complex)
      (le_of_eq (Circle.norm_coe _))
    rw [hv (order i), hv (order j)] at hk
    have ha : (alpha : Complex)*star (alpha : Complex) = 1 := by
      rw [Complex.star_def, Complex.mul_conj, Complex.normSq_eq_norm_sq, Circle.norm_coe]
      norm_num
    rw [ha, sub_self] at hk
    have hi : ⟪boundaryKernel B (zeta (order i)), boundaryKernel B (zeta (order j))⟫_Complex = 0 := by
      rw [boundaryKernel_reproduces]
      exact (mul_eq_zero.mp hk).resolve_right hden
    change _ * (_ * ⟪boundaryKernel B (zeta (order i)), boundaryKernel B (zeta (order j))⟫_Complex) = _
    rw [hi, mul_zero, mul_zero, if_neg hij]

def clarkBasis {m} (B : FiniteBlaschkeData m) (hm : 0 < m)
    (h0 : value B 0 = 0) (alpha : Circle) (order : Fin m ≃ Fin m) (theta : Fin m → Circle) :
    OrthonormalBasis (Fin m) Complex (modelSpace B) := by
  letI := modelSpace_finite B
  exact (D5.S3.Analytic.Hardy.PhaseFibreClarkBasis.phase_fibre_is_orthonormal_basis m
    (normalizedClarkFamily B hm h0 alpha order theta)
    (normalizedClarkFamily_orthonormal B hm h0 alpha order theta) (modelSpace_finrank B)).choose

theorem clarkBasis_apply {m} (B : FiniteBlaschkeData m) (hm : 0 < m)
    (h0 : value B 0 = 0) (alpha : Circle) (order : Fin m ≃ Fin m)
    (theta : Fin m → Circle) (j : Fin m) :
    clarkBasis B hm h0 alpha order theta j = normalizedClarkFamily B hm h0 alpha order theta j := by
  let _ := modelSpace_finite B
  exact congrFun (D5.S3.Analytic.Hardy.PhaseFibreClarkBasis.phase_fibre_is_orthonormal_basis m
    (normalizedClarkFamily B hm h0 alpha order theta)
    (normalizedClarkFamily_orthonormal B hm h0 alpha order theta) (modelSpace_finrank B)).choose_spec j


#print axioms boundaryKernel_normSq
#print axioms clarkBasis
end D5.S3.Analytic.Hardy.ClarkKernelRealization
