/- GID: D5/S3/Weil/Probability/CanonicalLiDiskEquivalence
   generality: I
   mirror-B: D5/B/S3/Weil/Probability/CanonicalLiDiskEquivalence
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: The actual canonical Li series converges absolutely on the unit disk exactly when the standard Riemann hypothesis holds. -/

import D5.S3.Weil.Probability.CanonicalLiGrowthZeroFree
import Mathlib.Analysis.Normed.Module.FiniteDimension

/-!
The canonical coefficients and their Taylor identification are reused from
CanonicalLiLocalExpansion. RH supplies nonvanishing only in the forward
implication. The reverse implication is the already constructed analytic-order
argument and does not receive RH, a Li positivity criterion, or a zero measure.
This is a classical analytic criterion, not a proof of its arithmetic premise.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Weil.Probability.CanonicalLiDiskEquivalence

open Filter Set
open D5.S3.Zeros.CompletedZeta
open D5.S3.Zeros.Endpoints.CanonicalLiLocalExpansion
open D5.S3.Analytic.ShiftedXiPoisson.ShiftedPoissonSemigroup
open D5.S3.Weil.Probability.CanonicalLiGrowthZeroFree
open scoped Topology BigOperators NNReal

/-- The actual Mobius image of every disk point lies strictly to the right of
one half. The strict inequality is derived from the original complex norm. -/
theorem disk_mobius_re_half (z : ℂ) (hz : z ∈ Metric.ball (0 : ℂ) 1) :
    (1 : ℝ) / 2 < ((1 - z)⁻¹).re := by
  have hn : ‖z‖ < 1 := by simpa only [Metric.mem_ball, dist_zero_right] using hz
  have hne : 1 - z ≠ 0 := by
    intro h
    have heq : z = 1 := (sub_eq_zero.mp h).symm
    simpa [heq] using hn
  have hden : 0 < Complex.normSq (1 - z) := Complex.normSq_pos.mpr hne
  have hsmall : Complex.normSq z < 1 := by
    rw [Complex.normSq_eq_norm_sq]
    nlinarith [norm_nonneg z]
  rw [Complex.inv_re]
  apply (lt_div_iff₀ hden).mpr
  simp only [Complex.normSq_apply, Complex.sub_re, Complex.sub_im,
    Complex.one_re, Complex.one_im] at hsmall ⊢
  nlinarith

/-- RH excludes zeros of the actual transformed xi function on the full disk. -/
theorem rh_xi_disk_ne_zero (hRH : RiemannHypothesis)
    (z : ℂ) (hz : z ∈ Metric.ball (0 : ℂ) 1) : canonicalXiDisk z ≠ 0 := by
  intro zero
  let s : ℂ := (1 - z)⁻¹
  have hhalf : (1 : ℝ) / 2 < s.re := disk_mobius_re_half z hz
  have hzero : Zeta23.IsNontrivialZero s :=
    (xiReading_eq_zero_iff_nontrivial s).mp zero
  have notTrivial : ¬ (∃ n : ℕ, s = -2 * (n + 1)) := by
    rintro ⟨n, heq⟩
    have hn : (0 : ℝ) ≤ n := Nat.cast_nonneg n
    rw [heq] at hhalf
    norm_num at hhalf <;> linarith
  have notOne : s ≠ 1 := by
    intro heq
    have hlt := hzero.2.2
    simpa only [heq, Complex.one_re, lt_self_iff_false] using hlt
  have line := hRH s hzero.1 notTrivial notOne
  linarith

/-- Under RH the existing logarithmic generator, not a replacement function,
is analytic throughout the disk. -/
theorem rh_li_generator_analytic (hRH : RiemannHypothesis) :
    AnalyticOnNhd ℂ liGenerator (Metric.ball (0 : ℂ) 1) := by
  intro z hz
  have hne : 1 - z ≠ 0 := by
    intro h
    have heq : z = 1 := (sub_eq_zero.mp h).symm
    simpa [heq, Metric.mem_ball] using hz
  have hp : AnalyticAt ℂ (fun w : ℂ => (1 - w)⁻¹) z :=
    (analyticAt_const.sub analyticAt_id).inv hne
  have hxi := xi_reading_differentiable.analyticAt ((1 - z)⁻¹)
  have hlog : AnalyticAt ℂ (logDeriv xiReading) ((1 - z)⁻¹) :=
    hxi.deriv.div hxi (rh_xi_disk_ne_zero hRH z hz)
  unfold liGenerator
  exact (hp.pow 2).mul (hlog.comp (f := fun w : ℂ => (1 - w)⁻¹) hp)

/-- The previously local canonical expansion becomes a full-disk expansion
under RH, retaining the proved all-order Taylor coefficient identity. -/
theorem rh_canonical_li_global_expansion (hRH : RiemannHypothesis)
    (z : ℂ) (hz : z ∈ Metric.ball (0 : ℂ) 1) :
    HasSum (fun n : ℕ => (canonicalLiCoefficient (n + 1) : ℂ) * z ^ n)
      (liGenerator z) := by
  have hs := Complex.hasSum_taylorSeries_on_ball
    (rh_li_generator_analytic hRH).differentiableOn hz
  apply hs.congr_fun
  intro n
  rw [← generator_taylor_coefficient]
  simp only [sub_zero, smul_eq_mul, div_eq_mul_inv]
  ring

/-- The canonical expansion is absolutely summable at every smaller real
radius. Finite-dimensional absolute summability is reused from Mathlib. -/
theorem rh_canonical_li_disk_summable (hRH : RiemannHypothesis)
    (r : ℝ≥0) (hr : r < 1) :
    Summable (fun n : ℕ => |canonicalLiCoefficient (n + 1)| * (r : ℝ) ^ n) := by
  have hin : ((r : ℝ) : ℂ) ∈ Metric.ball (0 : ℂ) 1 := by
    simpa only [Metric.mem_ball, dist_zero_right, Complex.norm_real,
      Real.norm_eq_abs, abs_of_nonneg r.property] using (show (r : ℝ) < 1 from hr)
  have hs := (rh_canonical_li_global_expansion hRH ((r : ℝ) : ℂ) hin).summable.norm
  simpa only [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg r.property] using hs

/-- An actual canonical equivalence, with no external Li criterion and no
coefficient-sign premise. The original arithmetic condition remains unproved. -/
theorem rh_iff_canonical_li_disk_summable :
    RiemannHypothesis ↔ ∀ r : ℝ≥0, r < 1 →
      Summable (fun n : ℕ => |canonicalLiCoefficient (n + 1)| * (r : ℝ) ^ n) :=
  ⟨rh_canonical_li_disk_summable, canonical_li_disk_summability_implies_rh⟩

/-- The actual full-disk generator expansion is another equivalent condition;
it is not inferred from finitely many Taylor coefficients. -/
theorem rh_iff_canonical_li_global_expansion :
    RiemannHypothesis ↔ ∀ z ∈ Metric.ball (0 : ℂ) 1,
      HasSum (fun n : ℕ => (canonicalLiCoefficient (n + 1) : ℂ) * z ^ n)
        (liGenerator z) := by
  refine ⟨rh_canonical_li_global_expansion, ?_⟩
  intro expansion
  apply canonical_li_disk_summability_implies_rh
  intro r hr
  have hin : ((r : ℝ) : ℂ) ∈ Metric.ball (0 : ℂ) 1 := by
    simpa only [Metric.mem_ball, dist_zero_right, Complex.norm_real,
      Real.norm_eq_abs, abs_of_nonneg r.property] using (show (r : ℝ) < 1 from hr)
  have hs := (expansion ((r : ℝ) : ℂ) hin).summable.norm
  simpa only [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg r.property] using hs

#print axioms rh_canonical_li_global_expansion
#print axioms rh_iff_canonical_li_disk_summable
#print axioms rh_iff_canonical_li_global_expansion

end D5.S3.Weil.Probability.CanonicalLiDiskEquivalence
