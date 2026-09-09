/- GID: D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge
   generality: I
   mirror-B: D5/B/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge
   mirror-E: none(waiver:structural-closure-properties-only)
   anchors: []
   utility: none
   digest: Real parts of smooth compact autocorrelations extend the even convolution-square API. -/

import D5.S3.Weil.TestFunctions

namespace D5.S3.Weil.TestFunctionBridge.EvenAutocorrelationBridge

open MeasureTheory D5.S3.Weil.TestFunctions
open scoped ComplexConjugate ContDiff

/-- The complex autocorrelation, with no parity condition on its input. -/
noncomputable def autocorrelation (f : ℝ → ℂ) (x : ℝ) : ℂ :=
  ∫ t : ℝ, f t * conj (f (t - x))

/-- Reversing the lag conjugates the autocorrelation. -/
theorem autocorrelation_conj_symm (f : ℝ → ℂ) (x : ℝ) :
    autocorrelation f (-x) = conj (autocorrelation f x) := by
  calc
    autocorrelation f (-x) = ∫ t : ℝ, f (t - x) * conj (f t) := by
      simpa only [autocorrelation, sub_neg_eq_add, sub_add_cancel] using
        (integral_sub_right_eq_self (fun t : ℝ => f t * conj (f (t + x))) x).symm
    _ = conj (autocorrelation f x) := by
      rw [autocorrelation, ← integral_conj]
      apply integral_congr_ae
      filter_upwards with t
      simp only [map_mul, Complex.conj_conj, mul_comm]

private theorem autocorrelation_eq_convolution (f : ℝ → ℂ) :
    autocorrelation f =
      MeasureTheory.convolution f (fun x => conj (f (-x))) complexMul volume := by
  funext x
  change (∫ t : ℝ, f t * conj (f (t - x))) =
    ∫ t : ℝ, f t * conj (f (-(x - t)))
  simp only [neg_sub]

private theorem autocorrelation_regular (f : ℝ → ℂ) (hf : ContDiff ℝ ∞ f)
    (hfc : HasCompactSupport f) :
    ContDiff ℝ ∞ (autocorrelation f) ∧ HasCompactSupport (autocorrelation f) := by
  have hc : HasCompactSupport (fun x => conj (f (-x))) := by
    simpa [Function.comp_def, Homeomorph.neg] using
      (hfc.comp_homeomorph (Homeomorph.neg ℝ)).comp_left
        (by simp : conj (0 : ℂ) = 0)
  have hd : ContDiff ℝ ∞ (fun x => conj (f (-x))) :=
    Complex.conjCLE.contDiff.comp (hf.comp contDiff_neg)
  rw [autocorrelation_eq_convolution]
  exact ⟨hc.contDiff_convolution_right (n := (⊤ : ℕ∞)) complexMul
    hf.continuous.locallyIntegrable hd, hfc.convolution complexMul hc⟩

/-- The real part of the autocorrelation, embedded in the even Weil test bundle. -/
noncomputable def evenAutocorrelation (f : ℝ → ℂ) (hf : ContDiff ℝ ∞ f)
    (hfc : HasCompactSupport f) : WeilTestFunction where
  toFun x := ((autocorrelation f x).re : ℂ)
  contDiff' := Complex.ofRealCLM.contDiff.comp
    (Complex.reCLM.contDiff.comp (autocorrelation_regular f hf hfc).1)
  hasCompactSupport' := by
    exact ((autocorrelation_regular f hf hfc).2.comp_left
      (by simp : (0 : ℂ).re = 0)).comp_left (by simp : ((0 : ℝ) : ℂ) = 0)
  even' x := by rw [autocorrelation_conj_symm, Complex.conj_re]

/-- The bridge evaluates to the real part of the original complex integral. -/
@[simp]
theorem evenAutocorrelation_apply (f : ℝ → ℂ) (hf : ContDiff ℝ ∞ f)
    (hfc : HasCompactSupport f) (x : ℝ) :
    evenAutocorrelation f hf hfc x = ((∫ t : ℝ, f t * conj (f (t - x))).re : ℂ) :=
  rfl

/-- On an even Weil test, the bridge agrees with the existing convolution square. -/
theorem evenAutocorrelation_eq_convolutionSquare (g : WeilTestFunction) :
    evenAutocorrelation g g.contDiff g.hasCompactSupport = convolutionSquare g := by
  apply WeilTestFunction.ext
  intro x
  change ((autocorrelation g x).re : ℂ) = convolutionSquare g x
  have hreal : conj (autocorrelation g x) = autocorrelation g x := by
    rw [← autocorrelation_conj_symm]
    simpa only [autocorrelation, ← convolutionSquare_apply] using convolutionSquare_even g x
  rw [Complex.conj_eq_iff_re.mp hreal]
  exact (convolutionSquare_apply g x).symm

#print axioms autocorrelation_conj_symm
#print axioms evenAutocorrelation
#print axioms evenAutocorrelation_apply
#print axioms evenAutocorrelation_eq_convolutionSquare

end D5.S3.Weil.TestFunctionBridge.EvenAutocorrelationBridge
