/- GID: D5/S1/Phase/IntervalSampling
   generality: G
   mirror-B: D5/B/S1/Phase/IntervalSampling
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Irrational rotations sample half-open intervals with their lengths as frequencies. -/

import D5.S1.Phase.ContinuousAverage
import Mathlib.MeasureTheory.Measure.Portmanteau

/- Issue 6057, step 3. proof_shape: bind-only; admission_basis: atom-required-bridge.
   (1) The common uniform-sampling obligation of the pzg-v170 atoms
       21b616460d1cbeb9eb537fc7690b238fac8686bf16105e677278cc0928d58d15 and
       6b3a506b859ed4693724adaecee87fdcface331a251b9b9e1fd300a50fc2250b
       explicitly requires this prerequisite, as recorded in issue 6057.
   (2) The new typed edge joins continuous rotation averages (steps 1 and 2)
       to integer sampling counts (Finset.filter.card).
   (3) Those two atoms are the preregistered named downstream consumers:
       atom sampling goals -> irrational_rotation_interval_sampling -> ContinuousAverage.
   All private steps below instantiate Mathlib measure, topology, and finite-sum APIs.
   No escape witness or mathematical novelty is claimed. -/

noncomputable section

namespace D5.S1.Phase.IntervalSampling

open Filter MeasureTheory Set
open scoped Topology ENNReal NNReal BoundedContinuousFunction

private abbrev Circle := AddCircle (1 : ℝ)

private def arc (a b : ℝ) : Set Circle :=
  {x | (AddCircle.equivIco (1 : ℝ) 0 x : ℝ) ∈ Ico a b}

private theorem mem_arc (a b x : ℝ) :
    (x : Circle) ∈ arc a b ↔ a ≤ Int.fract x ∧ Int.fract x < b := by
  simp [arc, AddCircle.coe_equivIco_mk_apply]

private theorem measurableSet_arc (a b : ℝ) : MeasurableSet (arc a b) :=
  measurableSet_Ico.preimage
    (measurable_subtype_coe.comp (AddCircle.measurableEquivIco (1 : ℝ) 0).measurable)

private theorem arc_eq_image {a b : ℝ} (ha : 0 ≤ a) (hb : b ≤ 1) :
    arc a b = (fun x : ℝ => (x : Circle)) '' Ico a b := by
  ext x
  constructor
  · intro hx
    exact ⟨AddCircle.equivIco (1 : ℝ) 0 x, hx,
      (AddCircle.equivIco (1 : ℝ) 0).symm_apply_apply x⟩
  · rintro ⟨y, hy, rfl⟩
    change (AddCircle.equivIco (1 : ℝ) 0 (y : Circle) : ℝ) ∈ Ico a b
    rw [AddCircle.equivIco_coe_of_mem (by
      exact ⟨ha.trans hy.1, by simpa using hy.2.trans_le hb⟩)]
    exact hy

private theorem volume_eq_haar :
    (volume : Measure Circle) = AddCircle.haarAddCircle := by
  simpa using (AddCircle.volume_eq_smul_haarAddCircle (T := (1 : ℝ)))

private theorem haar_arc {a b : ℝ} (ha : 0 ≤ a) (hb : b ≤ 1) :
    AddCircle.haarAddCircle (arc a b) = ENNReal.ofReal (b - a) := by
  have hmp := AddCircle.measurePreserving_mk (1 : ℝ) 0
  have hrestrict : volume.restrict (Ioc (0 : ℝ) (0 + 1)) =
      volume.restrict (Ico (0 : ℝ) 1) := by
    simpa using Measure.restrict_congr_set (Ico_ae_eq_Ioc (μ := volume)).symm
  rw [hrestrict, volume_eq_haar] at hmp
  rw [← hmp.measure_preimage (measurableSet_arc a b).nullMeasurableSet,
    Measure.restrict_apply (AddCircle.measurable_mk' (measurableSet_arc a b))]
  have hset : (fun x : ℝ => (x : Circle)) ⁻¹' arc a b ∩ Ico 0 1 = Ico a b := by
    ext x
    constructor
    · rintro ⟨hx, hx01⟩
      simpa [mem_arc, Int.fract_eq_self.mpr hx01] using hx
    · intro hx
      have hx01 : x ∈ Ico (0 : ℝ) 1 := ⟨ha.trans hx.1, hx.2.trans_le hb⟩
      exact ⟨(mem_arc a b x).mpr (by simpa [Int.fract_eq_self.mpr hx01] using hx), hx01⟩
  rw [hset, Real.volume_Ico]

private theorem haar_frontier_arc {a b : ℝ} (ha : 0 ≤ a) (hb : b ≤ 1) :
    AddCircle.haarAddCircle (frontier (arc a b)) = 0 := by
  have hpoint (x : Circle) : AddCircle.haarAddCircle {x} = 0 := by
    rw [← volume_eq_haar]
    simpa only [mul_zero, min_eq_right zero_le_one, ENNReal.ofReal_zero,
      Metric.closedBall_zero] using (AddCircle.volume_closedBall (T := (1 : ℝ)) (x := x) 0)
  have hsub : frontier (arc a b) ⊆ {(a : Circle), (b : Circle)} := by
    rw [arc_eq_image ha hb]
    have hclosure : closure ((fun x : ℝ => (x : Circle)) '' Ico a b) ⊆
        (fun x : ℝ => (x : Circle)) '' Icc a b :=
      closure_minimal (image_mono Ico_subset_Icc_self)
        (isCompact_Icc.image (AddCircle.continuous_mk' (1 : ℝ))).isClosed
    have hopen : (fun x : ℝ => (x : Circle)) '' Ioo a b ⊆
        interior ((fun x : ℝ => (x : Circle)) '' Ico a b) :=
      interior_maximal (image_mono Ioo_subset_Ico_self)
        (QuotientAddGroup.isOpenMap_coe _ isOpen_Ioo)
    rintro x ⟨hx, hxi⟩
    obtain ⟨y, hy, rfl⟩ := hclosure hx
    by_cases hya : y = a
    · simp [hya]
    by_cases hyb : y = b
    · simp [hyb]
    exact (hxi (hopen ⟨y, ⟨lt_of_le_of_ne hy.1 (Ne.symm hya),
      lt_of_le_of_ne hy.2 hyb⟩, rfl⟩)).elim
  apply measure_mono_null hsub
  exact measure_union_null (hpoint a) (hpoint b)

private def samples (α ρ : ℝ) (N : ℕ) : ProbabilityMeasure Circle :=
  ⟨((N + 1 : ℕ) : ℝ≥0∞)⁻¹ • ∑ i ∈ Finset.range (N + 1),
      Measure.dirac (((ρ + (i : ℝ) * α) : ℝ) : Circle), by
    apply isProbabilityMeasure_iff.mpr
    simp [Measure.smul_apply, Measure.finsetSum_apply, ENNReal.inv_mul_cancel]⟩

private theorem integral_samples (α ρ : ℝ) (N : ℕ) (f : Circle →ᵇ ℂ) :
    (∫ x, f x ∂(samples α ρ N : Measure Circle)) =
      (∑ i ∈ Finset.range (N + 1), f ((ρ + (i : ℝ) * α : ℝ) : Circle)) /
        ((N + 1 : ℕ) : ℂ) := by
  change (∫ x, f x ∂(((N + 1 : ℕ) : ℝ≥0∞)⁻¹ •
    ∑ i ∈ Finset.range (N + 1), Measure.dirac ((ρ + (i : ℝ) * α : ℝ) : Circle))) = _
  rw [integral_smul_measure, integral_finsetSum_measure (fun i _ => f.integrable _)]
  rw [ENNReal.toReal_inv, ENNReal.toReal_natCast]
  simp [integral_dirac, div_eq_mul_inv, mul_comm]

open Classical in
private theorem samples_arc (α ρ : ℝ) (N : ℕ) (a b : ℝ) :
    ((samples α ρ N : Measure Circle) (arc a b)).toReal =
      (((Finset.range (N + 1)).filter fun i : ℕ =>
        a ≤ Int.fract (ρ + (i : ℝ) * α) ∧ Int.fract (ρ + (i : ℝ) * α) < b).card : ℝ) /
        ((N + 1 : ℕ) : ℝ) := by
  change ((((N + 1 : ℕ) : ℝ≥0∞)⁻¹ •
    ∑ i ∈ Finset.range (N + 1), Measure.dirac ((ρ + (i : ℝ) * α : ℝ) : Circle))
      (arc a b)).toReal = _
  simp only [Measure.smul_apply, smul_eq_mul,
    Measure.finsetSum_apply, Measure.dirac_apply,
    indicator_apply, Pi.one_apply, mem_arc]
  rw [← Finset.sum_filter]
  rw [ENNReal.toReal_mul, ENNReal.toReal_inv, ENNReal.toReal_natCast]
  simp [div_eq_mul_inv, mul_comm]

open Classical in
/-- Every irrational rotation, from every real phase, samples `[a,b)` with frequency `b-a`. -/
theorem irrational_rotation_interval_sampling
    {α : ℝ} (hα : Irrational α) (ρ : ℝ) {a b : ℝ}
    (ha : 0 ≤ a) (hab : a ≤ b) (hb : b ≤ 1) :
    Tendsto (fun N : ℕ =>
        (((Finset.range N).filter fun i : ℕ =>
            a ≤ Int.fract (ρ + (i : ℝ) * α) ∧ Int.fract (ρ + (i : ℝ) * α) < b).card : ℝ) /
          (N : ℝ)) atTop (𝓝 (b - a)) := by
  let μ : ProbabilityMeasure Circle := ⟨AddCircle.haarAddCircle, inferInstance⟩
  have hweak : Tendsto (samples α ρ) atTop (𝓝 μ) := by
    apply (ProbabilityMeasure.tendsto_iff_forall_integral_rclike_tendsto ℂ).mpr
    intro f
    simp only [integral_samples]
    exact (ContinuousAverage.continuous_average_tendsto_haar α hα ρ f f.continuous).comp
      (tendsto_add_atTop_nat 1)
  have hmass := ProbabilityMeasure.tendsto_measure_of_null_frontier_of_tendsto'
    hweak (haar_frontier_arc ha hb)
  have hreal := (ENNReal.tendsto_toReal (measure_ne_top (μ : Measure Circle) (arc a b))).comp hmass
  change Tendsto (fun N => ((samples α ρ N : Measure Circle) (arc a b)).toReal) atTop
    (𝓝 (AddCircle.haarAddCircle (arc a b)).toReal) at hreal
  apply (tendsto_add_atTop_iff_nat 1).mp
  simpa only [samples_arc, haar_arc ha hb, ENNReal.toReal_ofReal (sub_nonneg.mpr hab)]
    using hreal

#print axioms irrational_rotation_interval_sampling

end D5.S1.Phase.IntervalSampling
