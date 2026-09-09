# Sextic Envelope in Gap Coordinates

## Abstract

The centered sextic envelope has exact positive-coefficient certificates in five nonnegative root gaps.

**Theorem 1.1 (Sextic Envelope in Gap Coordinates).**

Lean statement: `D5/S3/Zeros/CoefficientBounds/SexticEnvelopeGaps.gap_envelope`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/CoefficientBounds/SexticEnvelopeGaps.gap_envelope` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The five variables are one sixth of the successive gaps of sorted centered roots. The scalar formulas gapA, gapB and gapZ represent the three coefficient invariants. All six bounds hold for arbitrary nonnegative real gaps. The last two proof identities express four times the lower and upper residuals as 77760 and 10077696 times polynomials with positive integer coefficients. Their expanded supports contain 185 and 922 monomials. Horner form keeps the exact certificates compact; ring checks the identities and positivity proves their signs. The consumer is SexticEnvelope.centered_real_sextic_envelope.

## References

- Truth anchor: `D5/S3/Zeros/CoefficientBounds/SexticEnvelopeGaps.gap_envelope`
