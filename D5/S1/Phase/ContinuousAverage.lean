/- GID: D5/S1/Phase/ContinuousAverage
   generality: G
   mirror-B: D5/B/S1/Phase/ContinuousAverage
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Continuous irrational-rotation averages tend to Haar at every phase. -/

import D5.S1.Phase.CharacterAverage
import Mathlib.Analysis.Fourier.AddCircle
import Mathlib.Topology.MetricSpace.UniformConvergence

/- Step 2 of issue 6057. The character limit is imported, not reproved.
   Search: pinned Mathlib v4.33.0 has Fourier density and equicontinuous limit closure,
   but no exact irrational-rotation averaging theorem was found. The external
   WeylEquidistribution.lean candidate has unfinished proofs (2026-09-07 inspection).
   The preregistered construction extends character convergence through a closed
   subspace of observables, using the uniform norm bound on the averaging operators. -/

noncomputable section

namespace D5.S1.Phase.ContinuousAverage

open Filter MeasureTheory
open scoped Topology

private abbrev Observable := C(AddCircle (1 : ℝ), ℂ)

private def average (α ρ : ℝ) (N : ℕ) : Observable →ₗ[ℂ] ℂ where
  toFun f := (∑ i ∈ Finset.range N,
    f ((ρ + (i : ℝ) * α : ℝ) : AddCircle (1 : ℝ))) / (N : ℂ)
  map_add' f g := by simp [Finset.sum_add_distrib, add_div]
  map_smul' c f := by
    simp only [ContinuousMap.smul_apply, smul_eq_mul, RingHom.id_apply,
      ← Finset.mul_sum, mul_div_assoc]

private theorem norm_average_le (α ρ : ℝ) (N : ℕ) (f : Observable) :
    ‖average α ρ N f‖ ≤ ‖f‖ := by
  by_cases hN : N = 0
  · simp [average, hN]
  have hN' : (0 : ℝ) < N := Nat.cast_pos.mpr (Nat.pos_of_ne_zero hN)
  change ‖(∑ i ∈ Finset.range N,
    f ((ρ + (i : ℝ) * α : ℝ) : AddCircle (1 : ℝ))) / (N : ℂ)‖ ≤ ‖f‖
  rw [norm_div, Complex.norm_natCast, div_le_iff₀ hN']
  calc
    _ ≤ ∑ i ∈ Finset.range N, ‖f ((ρ + (i : ℝ) * α : ℝ) : AddCircle (1 : ℝ))‖ :=
      norm_sum_le _ _
    _ ≤ ∑ _i ∈ Finset.range N, ‖f‖ :=
      Finset.sum_le_sum (fun _ _ => f.norm_coe_le_norm _)
    _ = ‖f‖ * (N : ℝ) := by simp [mul_comm]

private theorem integrable_observable (f : Observable) : Integrable f AddCircle.haarAddCircle :=
  f.continuous.integrable_of_hasCompactSupport (HasCompactSupport.of_compactSpace f)

private theorem integral_lipschitz :
    LipschitzWith 1 (fun f : Observable => ∫ x, f x ∂AddCircle.haarAddCircle) := by
  apply LipschitzWith.of_dist_le_mul
  intro f g
  rw [NNReal.coe_one, one_mul, dist_eq_norm,
    ← integral_sub (integrable_observable f) (integrable_observable g)]
  simpa only [probReal_univ, mul_one, dist_eq_norm] using
    (norm_integral_le_of_norm_le_const (μ := AddCircle.haarAddCircle)
      (f := fun x => f x - g x) (C := ‖f - g‖)
      (Eventually.of_forall (fun x => (f - g).norm_coe_le_norm x)))

private theorem average_equicontinuous (α ρ : ℝ) :
    Equicontinuous (fun N : ℕ => (average α ρ N : Observable → ℂ)) := by
  apply (LipschitzWith.uniformEquicontinuous _ 1 _).equicontinuous
  intro N
  apply LipschitzWith.of_dist_le_mul
  intro f g
  simpa only [NNReal.coe_one, one_mul, dist_eq_norm, ← map_sub] using
    norm_average_le α ρ N (f - g)

private theorem fourier_average_tendsto (α : ℝ) (hα : Irrational α) (ρ : ℝ) (m : ℤ) :
    Tendsto (fun N => average α ρ N (fourier m)) atTop
      (𝓝 (∫ x, fourier m x ∂(AddCircle.haarAddCircle : Measure (AddCircle (1 : ℝ))))) := by
  by_cases hm : m = 0
  · subst m
    simp only [fourier_zero, integral_const, probReal_univ, one_smul]
    refine (tendsto_const_nhds : Tendsto (fun _ : ℕ => (1 : ℂ)) atTop (𝓝 1)).congr' ?_
    filter_upwards [eventually_ne_atTop 0] with N hN
    simp [average, hN]
  · have hint : (∫ x, fourier m x
        ∂(AddCircle.haarAddCircle : Measure (AddCircle (1 : ℝ)))) = 0 := by
      have h := congrFun (fourierCoeff_fourier (T := (1 : ℝ)) m) 0
      simpa [fourierCoeff, fourier_zero, hm, Ne.symm hm] using h
    rw [hint]
    simpa only [average, LinearMap.coe_mk, AddHom.coe_mk, fourier_coe_apply,
      Complex.ofReal_one, div_one, Complex.ofReal_add, Complex.ofReal_mul] using
      CharacterAverage.character_average_tendsto_zero α hα ρ m hm

/-- Every continuous complex observable has Haar average along every specified initial phase. -/
theorem continuous_average_tendsto_haar (α : ℝ) (hα : Irrational α) (ρ : ℝ)
    (f : AddCircle (1 : ℝ) → ℂ) (hf : Continuous f) :
    Tendsto (fun N : ℕ => (∑ i ∈ Finset.range N,
      f ((ρ + (i : ℝ) * α : ℝ) : AddCircle (1 : ℝ))) / (N : ℂ)) atTop
      (𝓝 (∫ x, f x ∂AddCircle.haarAddCircle)) := by
  let S : Submodule ℂ Observable :=
    { carrier := {g | Tendsto (fun N => average α ρ N g) atTop
          (𝓝 (∫ x, g x ∂AddCircle.haarAddCircle))}
      zero_mem' := by simp
      add_mem' := by
        intro g h hg hh
        simpa only [Set.mem_ofPred_eq, map_add, ContinuousMap.add_apply,
          integral_add (integrable_observable g) (integrable_observable h)] using hg.add hh
      smul_mem' := by
        intro c g hg
        simpa only [Set.mem_ofPred_eq, map_smul, ContinuousMap.smul_apply, integral_smul] using
          hg.const_smul c }
  have hclosed : IsClosed (S : Set Observable) :=
    (average_equicontinuous α ρ).isClosed_setOfPred_tendsto integral_lipschitz.continuous
  have hspan : Submodule.span ℂ (Set.range (fourier (T := (1 : ℝ)))) ≤ S := by
    apply Submodule.span_le.mpr
    rintro _ ⟨m, rfl⟩
    exact fourier_average_tendsto α hα ρ m
  have htop : (⊤ : Submodule ℂ Observable) ≤ S := by
    rw [← span_fourier_closure_eq_top (T := (1 : ℝ))]
    exact Submodule.topologicalClosure_minimal _ hspan hclosed
  exact htop (Submodule.mem_top : (⟨f, hf⟩ : Observable) ∈ ⊤)

#print axioms continuous_average_tendsto_haar

end D5.S1.Phase.ContinuousAverage
