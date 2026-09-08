/- GID: D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpper
   generality: G
   mirror-B: D5/B/S3/Zeros/CoefficientBounds/SepticEnvelopeUpper
   mirror-E: none(waiver:symbolic-polynomial-inequalities)
   anchors: []
   utility: none
   digest: Universal degree-ten upper certificate for centered septic root gaps. -/

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

open SepticEnvelopeGaps SepticEnvelopeUpperHigh

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
-- Recombine seven coefficients with the invariant coefficients kept abstract.
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
  obtain ⟨h0, h1, h2, h3, h4, h5, h6⟩ :=
    upper_coefficients_nonneg b c d e f hb hc hd he hf
  have h : 0 ≤
      upperCoeff0 b c d e f + a * (upperCoeff1 b c d e f + a * (upperCoeff2 b c d e f + a *
      (upperCoeff3 b c d e f + a * (upperCoeff4 b c d e f + a * (upperCoeff5 b c d e f + a *
      (upperCoeff6 b c d e f)))))) := by positivity
  linarith only [hid, h]

#print axioms gap_z_upper

end D5.S3.Zeros.CoefficientBounds.SepticEnvelopeUpper
