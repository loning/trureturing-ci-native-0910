# Quantitative Multi-Orbit Weil Negative Certificate

## Abstract

A uniform quadratic remainder below the least multiplicity-weighted odd margin preserves a whole finite-dimensional family of strict negative full Weil squares.

**Theorem 1.1 (A strict diagonal margin dominates a uniform quadratic remainder).**

Lean statement: `D5/S3/Weil/ZetaBridge/QuantitativeMultiOrbitWeilNegativeCertificate.strictNegative_of_uniformQuadraticRemainder`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/QuantitativeMultiOrbitWeilNegativeCertificate.strictNegative_of_uniformQuadraticRemainder` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The theorem is a reusable finite-dimensional perturbation result. The negative target is bounded above by minus the margin times coefficient energy, while the absolute remainder is bounded by epsilon times the same energy. Strict epsilon-margin separation preserves negative definiteness on the entire space, including all cross terms represented by the remainder.

**Theorem 1.2 (A certified reduced frame yields an injective family of negative full Weil tests).**

Lean statement: `D5/S3/Weil/ZetaBridge/QuantitativeMultiOrbitWeilNegativeCertificate.quantitative_multiOrbit_weil_negative_certificate`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/QuantitativeMultiOrbitWeilNegativeCertificate.quantitative_multiOrbit_weil_negative_certificate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The exact selected-orbit target is minus four times the multiplicity-weighted odd energy. Everything else in the unconditional symmetric zero sum is defined as the remainder. A certificate consists only of a positive multiplicity floor and an independently proved uniform remainder bound below the resulting strict margin.

The theorem does not assume a bound on each basis vector separately. It requires a single quadratic estimate valid for every coefficient vector, which is the correct condition for preserving an entire negative subspace.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/QuantitativeMultiOrbitWeilNegativeCertificate.quantitative_multiOrbit_weil_negative_certificate`
- Truth anchor: `D5/S3/Weil/ZetaBridge/QuantitativeMultiOrbitWeilNegativeCertificate.strictNegative_of_uniformQuadraticRemainder`
- Dependency: [D5/S3/Weil/ZetaBridge/FiniteEvenWeilOddInterpolation](FiniteEvenWeilOddInterpolation.md)
- Dependency: [D5/S3/Weil/ZetaBridge/SymmetricConvergentOfZetaSummable](SymmetricConvergentOfZetaSummable.md)
