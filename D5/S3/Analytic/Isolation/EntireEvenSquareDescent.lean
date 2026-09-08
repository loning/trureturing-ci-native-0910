/- GID: D5/S3/Analytic/Isolation/EntireEvenSquareDescent
   generality: I
   mirror-B: D5/B/S3/Analytic/Isolation/EntireEvenSquareDescent
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Entire even functions descend uniquely through squaring, including the xi reading. -/

import D5.S3.Zeros.Endpoints.XiEndpointValues
import Mathlib.Analysis.Complex.SqrtDeriv
import Mathlib.Analysis.Complex.RemovableSingularity
import Mathlib.Analysis.Calculus.InverseFunctionTheorem.Deriv

/-!
# Entire even square descent

Library-search audit trail (2026-09-07):
1. D5: searched entire/even, square descent and factorization, xiReading,
   CompletedZeta, endpoint values, Mellin reconstruction, positive determinant
   coefficient compactness, and Jensen obstruction. No exact descent result found.
2. Mathlib v4.33.0, db584cd6d46c92f209a44c0f1c829460d327499d: searched
   Analysis/Analytic/{OfScalars,Composition,Constructions} and Analysis/Complex.
   Forward composition does not supply descent. Exact supporting primitives used:
   HasStrictDerivAt.localInverse, eventually_right_inverse, to_localInverse,
   Complex.continuousAt_sqrt, Complex.cpow_nat_inv_pow, and
   Complex.analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt.
3. Third-party: Reservoir package catalog and the downloaded main source of
   AlexKontorovich/PrimeNumberTheoremAnd, searched for even/entire, square descent,
   and analytic factorization. No exact result in that scope. Google and
   DuckDuckGo returned verification pages and supplied no search evidence.

The construction uses local inverses away from zero and removal of the continuous
singularity at zero. This is the analytic-continuation alternative in the original
FOLD preregistration. No positivity of the central value or normalization is claimed.
-/

namespace D5.S3.Analytic.Isolation.EntireEvenSquareDescent

open Filter
open scoped Topology

private theorem sqrt_sq (z : ℂ) : (Complex.sqrt z) ^ 2 = z := by
  exact Complex.cpow_nat_inv_pow z (by norm_num : (2 : ℕ) ≠ 0)

private theorem even_sqrt_sq {f : ℂ → ℂ} (he : Function.Even f) (b : ℂ) :
    f (Complex.sqrt (b ^ 2)) = f b := by
  rcases (sq_eq_sq_iff_eq_or_eq_neg).mp (sqrt_sq (b ^ 2)) with h | h
  · rw [h]
  · rw [h, he]

private theorem square_descent_differentiable_off_zero {f : ℂ → ℂ}
    (hf : Differentiable ℂ f) (he : Function.Even f) {z : ℂ} (hz : z ≠ 0) :
    DifferentiableAt ℂ (fun w => f (Complex.sqrt w)) z := by
  let b := Complex.sqrt z
  have hb : b ^ 2 = z := sqrt_sq z
  have hb0 : b ≠ 0 := by
    intro h
    apply hz
    rw [← hb, h, zero_pow (by norm_num)]
  have hd : HasStrictDerivAt (fun w : ℂ => w ^ 2) (2 * b) b := by
    simpa using hasStrictDerivAt_pow 2 b
  have hn : (2 : ℂ) * b ≠ 0 := mul_ne_zero (by norm_num) hb0
  let g := hd.localInverse (fun w : ℂ => w ^ 2) (2 * b) b hn
  have hg : DifferentiableAt ℂ g (b ^ 2) := (hd.to_localInverse hn).hasDerivAt.differentiableAt
  have hi : ∀ᶠ w in 𝓝 (b ^ 2), (g w) ^ 2 = w := hd.eventually_right_inverse hn
  have heq : (fun w => f (Complex.sqrt w)) =ᶠ[𝓝 (b ^ 2)] (fun w => f (g w)) := by
    filter_upwards [hi] with w hw
    simpa only [hw] using even_sqrt_sq he (g w)
  rw [← hb]
  exact ((hf (g (b ^ 2))).comp (b ^ 2) hg).congr_of_eventuallyEq heq

private theorem square_descent_entire {f : ℂ → ℂ}
    (hf : Differentiable ℂ f) (he : Function.Even f) :
    Differentiable ℂ (fun z => f (Complex.sqrt z)) := by
  intro z
  by_cases hz : z = 0
  · subst z
    apply (Complex.analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt
      (f := fun z => f (Complex.sqrt z)) ?_ ?_).differentiableAt
    · filter_upwards [self_mem_nhdsWithin] with w hw
      exact square_descent_differentiable_off_zero hf he hw
    · exact (hf.continuous.continuousAt).comp (Complex.continuousAt_sqrt (Or.inl le_rfl))
  · exact square_descent_differentiable_off_zero hf he hz

/-- Every entire even complex function has a unique entire factor through squaring. -/
theorem entire_even_square_descent {f : ℂ → ℂ}
    (hf : Differentiable ℂ f) (he : Function.Even f) :
    ∃! F : ℂ → ℂ, Differentiable ℂ F ∧ ∀ b : ℂ, F (b ^ 2) = f b := by
  refine ⟨fun z => f (Complex.sqrt z), ⟨square_descent_entire hf he, even_sqrt_sq he⟩, ?_⟩
  intro F hF
  funext z
  simpa only [sqrt_sq] using hF.2 (Complex.sqrt z)

open D5.S3.Zeros.CompletedZeta
open D5.S3.Zeros.Endpoints.XiEndpointValues

/-- The centered xi reading descends uniquely to an entire function, with both specified values. -/
theorem xi_reading_square_descent :
    ∃! F : ℂ → ℂ, Differentiable ℂ F ∧
      (∀ b : ℂ, F (b ^ 2) = xiReading (1 / 2 + b)) ∧
      F 0 = xiReading (1 / 2) ∧ F (1 / 4) = (1 / 2 : ℂ) := by
  have hf : Differentiable ℂ (fun b : ℂ => xiReading (1 / 2 + b)) :=
    xi_reading_differentiable.comp ((differentiable_const (1 / 2 : ℂ)).add differentiable_id)
  have he : Function.Even (fun b : ℂ => xiReading (1 / 2 + b)) := by
    intro b
    change xiReading (1 / 2 + -b) = xiReading (1 / 2 + b)
    rw [show (1 / 2 : ℂ) + -b = 1 - (1 / 2 + b) by ring]
    exact xi_reading_reflection (1 / 2 + b)
  obtain ⟨F, hF, hu⟩ := entire_even_square_descent hf he
  refine ⟨F, ⟨hF.1, hF.2, ?_, ?_⟩, ?_⟩
  · simpa using hF.2 0
  · have h := hF.2 (1 / 2)
    norm_num at h
    exact h.trans xi_reading_endpoint_values.2
  · intro G hG
    exact hu G ⟨hG.1, hG.2.1⟩

#print axioms entire_even_square_descent
#print axioms xi_reading_square_descent

end D5.S3.Analytic.Isolation.EntireEvenSquareDescent
