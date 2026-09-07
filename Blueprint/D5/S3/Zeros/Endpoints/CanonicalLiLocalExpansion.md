# Canonical Li Local Expansion

## Abstract

Canonical Li derivatives give the local xi logarithmic derivative series.

The zeroth coefficient is zero. For n >= 0, lambda_(n+1) is the real part of D^(n+1)[s^n log(xiReading(s))] at s=1, divided by n!. The principal complex logarithm is analytic near that point because xiReading(1)=1/2. This is the source Li derivative definition, not a definition by the Taylor coefficients of the transformed generator.

**Definition 1.1 (Canonical coefficient sequence).**

Lean statement: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonicalLiCoefficient`

*Formalization.* `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonicalLiCoefficient` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Successor indexing expresses the factorial normalization without a truncated subtraction at zero.

**Definition 1.2 (Transformed logarithmic derivative).**

Lean statement: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.liGenerator`

*Formalization.* `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.liGenerator` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

G(z)=(1-z)^(-2) logDeriv xiReading(1/(1-z)). The inverse-square presentation is algebraically the same as the integer power appearing in the final series theorem.

**Theorem 1.3 (Every Taylor coefficient is the canonical Li coefficient).**

Lean statement: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.generator_taylor_coefficient`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.generator_taylor_coefficient` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The all-order Mobius derivative identity follows by induction from the higher product rule for multiplication by the coordinate. Conjugation of the entire xi reading makes the generator's derivatives at zero real, so each Taylor coefficient of the generator is the canonical Li coefficient of the next index.

**Theorem 1.4 (Local generating series).**

Lean statement: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_local_expansion`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_local_expansion` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Mathlib's complex Taylor convergence theorem applies on an analytic ball around zero. Replacing its coefficients by the preceding identity gives the canonical series without a Keiper-Li expansion hypothesis. The classical identity is not claimed as novel mathematics.

**Theorem 1.5 (Zeroth coefficient).**

Lean statement: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_zero`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_zero` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The conventional initial value is zero.

**Theorem 1.6 (Connection to the preceding first-coefficient layer).**

Lean statement: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_one`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_one` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The derivative definition gives exactly 1+gamma/2-log(2 sqrt(pi)), using first_li_coefficient_eq_log_deriv_re from FirstLiCoefficientPositivity. The preceding estimates are reused.

**Theorem 1.7 (Positive first coefficient).**

Lean statement: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_one_pos`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_one_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The strict positivity of the first canonical Li coefficient transfers along the identity for its closed form. Together with the vanishing zeroth coefficient it supplies the initial values that the Li-Caratheodory identity takes as inputs.

## References

- Truth anchor: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonicalLiCoefficient`
- Truth anchor: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_local_expansion`
- Truth anchor: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_one`
- Truth anchor: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_one_pos`
- Truth anchor: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_zero`
- Truth anchor: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.generator_taylor_coefficient`
- Truth anchor: `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.liGenerator`
- Dependency: [D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity](FirstLiCoefficientPositivity.md)
- Dependency: [D5/S3/Zeros/Endpoints/XiEndpointValues](XiEndpointValues.md)
- Dependency: [D5/S3/Zeros/Symmetry/ZetaConjugationCovariance](../Symmetry/ZetaConjugationCovariance.md)
