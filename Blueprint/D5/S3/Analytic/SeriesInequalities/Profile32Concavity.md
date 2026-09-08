# Cubic Profile Coordinates and Curvature Certificate

## Abstract

An exact radical sign certificate and root coordinates for the cubic profile.

**Theorem 1.1 (The cleared curvature numerator is negative).**

Lean statement: `D5/S3/Analytic/SeriesInequalities/Profile32Concavity.curvature_numerator_neg`

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/SeriesInequalities/Profile32Concavity.curvature_numerator_neg` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The proof factors the numerator into a negative rational factor and a strictly positive radical expression throughout the positive open unit interval. Its sign follows from a polynomial decomposition with nonnegative terms and a uniform remainder of 243. Profile32Calculus supplies the differential interpretation.

**Theorem 1.2 (Explicit coordinates preserve the original root-set profile).**

Lean statement: `D5/S3/Analytic/SeriesInequalities/Profile32Concavity.profile32_chart`

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/SeriesInequalities/Profile32Concavity.profile32_chart` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The three distinct roots are constructed explicitly, their inverse-gap scores are evaluated, and their common positive scale is extracted. The weight comes from this change of coordinates; the original profile has exponent three halves inside the sum and negative four thirds outside, with no additional normalization.

## References

- Truth anchor: `D5/S3/Analytic/SeriesInequalities/Profile32Concavity.curvature_numerator_neg`
- Truth anchor: `D5/S3/Analytic/SeriesInequalities/Profile32Concavity.profile32_chart`
