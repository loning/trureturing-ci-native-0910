# Centered Real Septic Envelope

## Abstract

Every centered monic septic with seven real roots satisfies six coefficient inequalities.

**Theorem 1.1 (Centered Real Septic Envelope).**

Lean statement: `D5/S3/Zeros/CoefficientBounds/SepticEnvelope.centered_real_septic_envelope`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/CoefficientBounds/SepticEnvelope.centered_real_septic_envelope` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For the product of X minus each of seven real roots with zero sum, let u, v, w and s be the coefficients of degrees five, four, three and one. Set A=-u, B=u^2+21w/5 and Z=-(2s+2uw/7-4v^2/35). Then A>=0, B>=0, B<=49A^2/20, Z>=0, 120AB-245A^3<=270Z, and 9Z(49A^2-5B)<=10AB^2. The root enumeration is arbitrary, including repeated and zero roots. The identity 2u=(sum r)^2-sum r^2 shows that A=0 forces every root to vanish, which is handled separately. Sorting preserves the root sum and product; exact coefficient identities transfer the inequalities from six nonnegative root gaps.

## References

- Truth anchor: `D5/S3/Zeros/CoefficientBounds/SepticEnvelope.centered_real_septic_envelope`
- Dependency: [D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperHigh](SepticEnvelopeUpperHigh.md)
