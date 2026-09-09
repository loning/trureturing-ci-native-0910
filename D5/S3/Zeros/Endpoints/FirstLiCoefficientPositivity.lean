/- GID: D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity
   generality: I
   mirror-B: D5/B/S3/Zeros/Endpoints/FirstLiCoefficientPositivity
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: kind=certified-instance; basis=terminal=gid:D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.first_li_coefficient_pos
   digest: Public rational bounds certify strict positivity of the canonical first Li coefficient. -/

import D5.S3.Zeros.Endpoints.FirstLiCoefficientNormalization
import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.NumberTheory.Harmonic.EulerMascheroni

/-!
The numerical estimates below already occur as local facts in the frozen
`FirstLiCoefficientNormalization` proof. SL-008 prevents exposing them there,
so this module proves them again as reusable public theorems. This is an API
contribution, not a new analytical result. Its terminal use is precisely the
strict positivity of the first Li coefficient, not the whole Li criterion.

The preregistered bounds are unchanged: 11/20 < gamma and log(4*pi) < 51/20.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

open D5.S3.Zeros.CompletedZeta
open D5.S3.Zeros.Endpoints.FirstLiCoefficientNormalization
open scoped BigOperators

namespace D5.S3.Zeros.Endpoints.FirstLiCoefficientPositivity

/-- A rational lower bound for the Euler-Mascheroni constant. -/
theorem eleven_twentieths_lt_eulerMascheroniConstant :
    (11 / 20 : ℝ) < Real.eulerMascheroniConstant := by
  have hGammaApprox := Real.eulerMascheroniSeq_lt_eulerMascheroniConstant 20
  have hLogTwentyOne : Real.log 21 < (3047 / 1000 : ℝ) := by
    rw [Real.log_lt_iff_lt_exp (by norm_num)]
    have hSummable :=
      (NormedSpace.expSeries_div_hasSum_exp (3047 / 1000 : ℝ)).summable
    have hPartialBound :=
      hSummable.sum_le_tsum (Finset.range 14) (fun i hi => by positivity)
    rw [(NormedSpace.expSeries_div_hasSum_exp
      (3047 / 1000 : ℝ)).tsum_eq] at hPartialBound
    rw [← Real.exp_eq_exp_ℝ] at hPartialBound
    have hPartial :
        (21 : ℝ) <
          ∑ i ∈ Finset.range 14, (3047 / 1000 : ℝ) ^ i / i.factorial := by
      norm_num
    exact hPartial.trans_le hPartialBound
  norm_num [Real.eulerMascheroniSeq, harmonic] at hGammaApprox
  linarith

/-- A rational upper bound for the logarithm appearing in the first coefficient. -/
theorem log_four_pi_lt_fifty_one_twentieths :
    Real.log (4 * Real.pi) < (51 / 20 : ℝ) := by
  rw [Real.log_lt_iff_lt_exp (by positivity)]
  have hSummable :=
    (NormedSpace.expSeries_div_hasSum_exp (51 / 20 : ℝ)).summable
  have hPartialBound :=
    hSummable.sum_le_tsum (Finset.range 10) (fun i hi => by positivity)
  rw [(NormedSpace.expSeries_div_hasSum_exp
    (51 / 20 : ℝ)).tsum_eq] at hPartialBound
  rw [← Real.exp_eq_exp_ℝ] at hPartialBound
  have hPi := Real.pi_lt_d4
  norm_num at hPartialBound hPi ⊢
  calc
    4 * Real.pi < 4 * (3927 / 1250 : ℝ) :=
      mul_lt_mul_of_pos_left hPi (by norm_num)
    _ < 29366922070115351 / 2293760000000000 := by norm_num
    _ ≤ Real.exp (51 / 20) := hPartialBound

/-- Strict positivity of the canonical closed form for the first Li coefficient. -/
theorem first_li_coefficient_pos :
    0 < 1 + Real.eulerMascheroniConstant / 2 -
      Real.log (2 * Real.sqrt Real.pi) := by
  have hLogFourPi :
      Real.log (4 * Real.pi) / 2 = Real.log (2 * Real.sqrt Real.pi) := by
    calc
      Real.log (4 * Real.pi) / 2 =
          (Real.log 4 + Real.log Real.pi) / 2 := by
            rw [Real.log_mul (by norm_num) (ne_of_gt Real.pi_pos)]
      _ = (2 * Real.log 2 + Real.log Real.pi) / 2 := by
            rw [show (4 : ℝ) = 2 * 2 by norm_num,
              Real.log_mul (by norm_num) (by norm_num)]
            ring
      _ = Real.log 2 + Real.log Real.pi / 2 := by ring
      _ = Real.log 2 + Real.log (Real.sqrt Real.pi) := by
            rw [Real.log_sqrt Real.pi_pos.le]
      _ = Real.log (2 * Real.sqrt Real.pi) := by
            rw [Real.log_mul (by norm_num)
              (ne_of_gt (Real.sqrt_pos.2 Real.pi_pos))]
  rw [← hLogFourPi]
  linarith [eleven_twentieths_lt_eulerMascheroniConstant,
    log_four_pi_lt_fifty_one_twentieths]

/-- The first conjunct of the frozen normalization identifies the real coefficient. -/
theorem first_li_coefficient_eq_log_deriv_re :
    1 + Real.eulerMascheroniConstant / 2 - Real.log (2 * Real.sqrt Real.pi) =
      (deriv xiReading 1 / xiReading 1).re := by
  simpa only [Complex.ofReal_re] using
    (congrArg Complex.re first_li_coefficient_normalization.1).symm

/-- The canonical xi logarithmic derivative has strictly positive real part at one. -/
theorem xi_log_deriv_one_re_pos :
    0 < (deriv xiReading 1 / xiReading 1).re := by
  rw [← first_li_coefficient_eq_log_deriv_re]
  exact first_li_coefficient_pos

#print axioms eleven_twentieths_lt_eulerMascheroniConstant
#print axioms log_four_pi_lt_fifty_one_twentieths
#print axioms first_li_coefficient_pos
#print axioms first_li_coefficient_eq_log_deriv_re
#print axioms xi_log_deriv_one_re_pos

end D5.S3.Zeros.Endpoints.FirstLiCoefficientPositivity
