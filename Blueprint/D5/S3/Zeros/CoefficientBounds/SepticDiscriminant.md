# Centered Septic Discriminant

## Abstract

The cubic coefficient expression associated with two centered real septics has nonnegative discriminant.

**Theorem 1.1 (Centered Real Septic Discriminant).**

Lean statement: `D5/S3/Zeros/CoefficientBounds/SepticDiscriminant.centered_real_septic_discriminant`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/CoefficientBounds/SepticDiscriminant.centered_real_septic_discriminant` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Both inputs are products of seven real linear factors, and each root list has zero sum. Write u, v, w and s for their coefficients of degrees five, four, three and one. Set A=-u, B=u^2+21w/5 and Z=-(2s+2uw/7-4v^2/35), with primed invariants for the second input. For a=7AA'/12, b=5BB'/294 and c=5ZZ'/32, the expression a^2b^2-4b^3-4a^3c-27c^2+18abc is nonnegative. The proof uses the frozen septic coefficient envelope, two Bernstein endpoint expansions, a product threshold of 5/6 and a concavity identity. A vanishing A forces the sum of root squares, and hence every root, to vanish before normalization. Repeated and zero roots are included.

## References

- Truth anchor: `D5/S3/Zeros/CoefficientBounds/SepticDiscriminant.centered_real_septic_discriminant`
- Dependency: [D5/S3/Zeros/CoefficientBounds/SepticEnvelope](SepticEnvelope.md)
