/- GID: D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpper
   generality: G
   mirror-B: D5/B/S3/Zeros/CoefficientBounds/SepticEnvelopeUpper
   mirror-E: none(waiver:symbolic-polynomial-inequalities)
   anchors: []
   utility: none
   digest: Universal degree-ten upper certificate for centered septic root gaps. -/

import D5.S3.Zeros.CoefficientBounds.SepticEnvelopeUpperLow
import D5.S3.Zeros.CoefficientBounds.SepticEnvelopeUpperHigh

/-!
The upper slack has 2829 positive monomials. `upper_identity` expresses it as
a polynomial in the first gap, with seven coefficients whose signs have been
proved separately. `gap_z_upper` combines these universal identities and sign
inequalities. Neither declaration enumerates a bounded family, implements a
checker, assumes numerical premises, or certifies a finite instance; utility
is none.
-/

noncomputable section

namespace D5.S3.Zeros.CoefficientBounds.SepticEnvelopeUpper

open SepticEnvelopeGaps SepticEnvelopeUpperLow SepticEnvelopeUpperHigh

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
private theorem upper_identity (a b c d e f : ℝ) :
    12*(10*gapA a b c d e f*(gapB a b c d e f)^2 -
      9*gapZ a b c d e f*(49*(gapA a b c d e f)^2 - 5*gapB a b c d e f)) =
      upperCoeff0 b c d e f + a * (upperCoeff1 b c d e f + a * (upperCoeff2 b c d e f + a *
      (upperCoeff3 b c d e f + a * (upperCoeff4 b c d e f + a * (upperCoeff5 b c d e f + a *
      (upperCoeff6 b c d e f)))))) := by
  rw [gap_a_first_gap, gap_b_first_gap, gap_z_first_gap]
  unfold upperCoeff0 upperCoeff1 upperCoeff2 upperCoeff3 upperCoeff4 upperCoeff5 upperCoeff6
  generalize aCoeff0 b c d e f = v0
  generalize aCoeff1 b c d e f = v1
  generalize bCoeff0 b c d e f = v2
  generalize bCoeff1 b c d e f = v3
  generalize bCoeff2 b c d e f = v4
  generalize zCoeff0 b c d e f = v5
  generalize zCoeff1 b c d e f = v6
  generalize zCoeff2 b c d e f = v7
  ring

theorem gap_z_upper (a b c d e f : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c)
    (hd : 0 ≤ d) (he : 0 ≤ e) (hf : 0 ≤ f) :
    9*gapZ a b c d e f*(49*(gapA a b c d e f)^2 - 5*gapB a b c d e f)
      ≤ 10*gapA a b c d e f*(gapB a b c d e f)^2 := by
  have hid := upper_identity a b c d e f
  have h0 := upper_coeff0_nonneg b c d e f hb hc hd he hf
  have h1 := upper_coeff1_nonneg b c d e f hb hc hd he hf
  have h2 := upper_coeff2_nonneg b c d e f hb hc hd he hf
  have h3 := upper_coeff3_nonneg b c d e f hb hc hd he hf
  have h4 := upper_coeff4_nonneg b c d e f hb hc hd he hf
  have h5 := upper_coeff5_nonneg b c d e f hb hc hd he hf
  have h6 := upper_coeff6_nonneg b c d e f hb hc hd he hf
  have h : 0 ≤
      upperCoeff0 b c d e f + a * (upperCoeff1 b c d e f + a * (upperCoeff2 b c d e f + a *
      (upperCoeff3 b c d e f + a * (upperCoeff4 b c d e f + a * (upperCoeff5 b c d e f + a *
      (upperCoeff6 b c d e f)))))) := by positivity
  linarith only [hid, h]

#print axioms gap_z_upper

end D5.S3.Zeros.CoefficientBounds.SepticEnvelopeUpper
