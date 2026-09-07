/- GID: D5/S3/Quantum/Decoherence/TwoBranchInitialPhase
   generality: G
   mirror-B: D5/B/S3/Quantum/Decoherence/TwoBranchInitialPhase
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: The equal two-branch exponential average has initial phase slope -3kappa/2. -/

import Mathlib.Analysis.SpecialFunctions.Complex.LogDeriv

/- Library search and admission:
   D5 record/environment formulas, finite damping iterates, and fixed-state results do not
   supply a real-time phase derivative. No D5 module is a direct dependency.
   Mathlib v4.33.0 supplies HasDerivAt.cexp, HasDerivAt.clog_real, Complex.log_im,
   Complex.one_mem_slitPlane, and Complex.norm_mul_exp_arg_mul_I; all are applied below.
   proof_shape: content; admission_basis: escape-witness (second form).
   The preregistered witness is the complete public conclusion, constructed on the live path
   by branchDerivative -> overlapDerivative -> logDerivative -> phaseDerivative and by
   overlapDerivative -> localNonzero -> radius -> the joint local conclusion.
   The preregistration is unchanged. This is an analytic construction for every real kappa,
   not finite enumeration, a checker, a numerical reduction, or a certified finite instance;
   hence computational_content.kind=none. No whole-atom coverage is asserted.
   Bounded search receipts and the complete direct-import declaration audit accompany delivery.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

open scoped Topology

namespace D5.S3.Quantum.Decoherence.TwoBranchInitialPhase

/-- The principal logarithmic phase of the equal two-branch process starts at zero,
has slope `-(3/2)*kappa`, and gives a nonzero polar representation on one neighborhood. -/
theorem two_branch_initial_local_phase (kappa : ℝ) :
    let chi : ℝ → ℂ := fun t =>
      (Complex.exp (-Complex.I * kappa * t) +
        Complex.exp (-Complex.I * 2 * kappa * t)) / 2
    let theta : ℝ → ℝ := fun t => (Complex.log (chi t)).im
    theta 0 = 0 ∧ HasDerivAt theta (-(3 / 2 : ℝ) * kappa) 0 ∧
      ∃ epsilon > 0, ∀ t : ℝ, |t| < epsilon →
        chi t ≠ 0 ∧ chi t = (‖chi t‖ : ℂ) * Complex.exp (Complex.I * theta t) := by
  dsimp only
  let chi : ℝ → ℂ := fun t =>
    (Complex.exp (-Complex.I * kappa * t) +
      Complex.exp (-Complex.I * 2 * kappa * t)) / 2
  let theta : ℝ → ℝ := fun t => (Complex.log (chi t)).im
  change theta 0 = 0 ∧ HasDerivAt theta (-(3 / 2 : ℝ) * kappa) 0 ∧ _
  have initialOverlap : chi 0 = 1 := by norm_num [chi]
  have initialPhase : theta 0 = 0 := by simp [theta, initialOverlap]
  have branchDerivative (c : ℂ) :
      HasDerivAt (fun t : ℝ => Complex.exp (c * t)) c 0 := by
    simpa using (((hasDerivAt_id (0 : ℝ)).ofReal_comp).const_mul c).cexp
  let slope : ℂ := (-Complex.I * kappa + -Complex.I * 2 * kappa) / 2
  have overlapDerivative : HasDerivAt chi slope 0 :=
    ((branchDerivative (-Complex.I * kappa)).add
      (branchDerivative (-Complex.I * 2 * kappa))).div_const 2
  have logDerivative : HasDerivAt (fun t => Complex.log (chi t)) slope 0 := by
    simpa only [initialOverlap, div_one] using
      overlapDerivative.clog_real (initialOverlap ▸ Complex.one_mem_slitPlane)
  have phaseDerivative : HasDerivAt theta (-(3 / 2 : ℝ) * kappa) 0 := by
    have imaginaryDerivative := Complex.imCLM.hasFDerivAt.comp_hasDerivAt 0 logDerivative
    have slopeImaginary : slope.im = -(3 / 2 : ℝ) * kappa := by
      simp [slope, Complex.mul_re, Complex.mul_im]
      <;> ring
    simpa only [Function.comp_def, Complex.imCLM_apply, slopeImaginary] using! imaginaryDerivative
  have localNonzero : ∀ᶠ t in 𝓝 (0 : ℝ), chi t ≠ 0 :=
    overlapDerivative.continuousAt.eventually_ne (by simp [initialOverlap])
  obtain ⟨epsilon, positiveRadius, radius⟩ := Metric.eventually_nhds_iff.mp localNonzero
  refine ⟨initialPhase, phaseDerivative, epsilon, positiveRadius, ?_⟩
  intro t ht
  refine ⟨radius (by simpa [Real.dist_eq] using ht), ?_⟩
  simpa only [theta, Complex.log_im, mul_comm Complex.I] using
    (Complex.norm_mul_exp_arg_mul_I (chi t)).symm

#print axioms two_branch_initial_local_phase

end D5.S3.Quantum.Decoherence.TwoBranchInitialPhase
