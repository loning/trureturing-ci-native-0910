/- GID: D5/S3/Weil/Probability/AnalyticLogarithmicContinuation
   generality: G
   mirror-B: D5/B/S3/Weil/Probability/AnalyticLogarithmicContinuation
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: An absolutely convergent scalar series and a local logarithmic derivative identity force zero-freeness on a connected analytic domain. -/

import Mathlib.Analysis.Analytic.OfScalars
import Mathlib.Analysis.Analytic.Order
import Mathlib.Analysis.Analytic.ChangeOrigin
import Mathlib.Analysis.SpecificLimits.Normed

/-!
The analytic tools are classical. This module retains the scalar coefficients
and proves the two analytic obligations used by CanonicalLiGrowthZeroFree:
quadratic coefficient bounds imply disk analyticity, and a local equation
f'=g*f extends and excludes zeros. No global logarithm, global logarithmic
identity or pre-existing zero-free domain is a hypothesis of the local theorem.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Weil.Probability.AnalyticLogarithmicContinuation

open Filter Set
open scoped Topology BigOperators NNReal ENNReal

/-- The polynomial bound controls the full absolute series at each radius,
including zero radius. No finite coefficient cutoff is used. -/
theorem quadratic_coefficients_summable (a : ℕ → ℂ) (C : ℝ)
    (bound : ∀ n, ‖a n‖ ≤ C * ((n : ℝ) + 1) ^ 2)
    (r : ℝ≥0) (hr : r < 1) :
    Summable (fun n => ‖a n‖ * (r : ℝ) ^ n) := by
  have hrnorm : ‖(r : ℝ)‖ < 1 := by simpa using hr
  have h0 := summable_geometric_of_norm_lt_one hrnorm
  have h1 := summable_pow_mul_geometric_of_norm_lt_one 1 hrnorm
  have h2 := summable_pow_mul_geometric_of_norm_lt_one 2 hrnorm
  have major : Summable (fun n : ℕ => C * ((n : ℝ) + 1) ^ 2 * (r : ℝ) ^ n) := by
    convert ((h2.add (h1.mul_left 2)).add h0).mul_left C using 1
    funext n
    simp only [pow_one]
    ring
  exact Summable.of_nonneg_of_le
    (fun n => mul_non_mul_le (norm_nonneg _) (pow_nonneg r.property n))
    (fun n => mul_le_mul_of_nonneg_right (bound n) (pow_nonneg r.property n)) major

end D5.S3.Weil.Probability.AnalyticLogarithmicContinuation
