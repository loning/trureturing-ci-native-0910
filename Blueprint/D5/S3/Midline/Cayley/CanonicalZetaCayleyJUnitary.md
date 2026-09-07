# Canonical zeta Cayley J-unitarity

## Abstract

The diagonal zero Cayley operator preserves the indefinite inner product induced by same-height reflection.

**Theorem 1.1 (Mirror Cayley coefficients are inverse conjugates).**

Lean statement: `D5/S3/Midline/Cayley/CanonicalZetaCayleyJUnitary.cayleyCoefficient_mirrorIndex`

*Proof.* Machine-checked in Lean as `D5/S3/Midline/Cayley/CanonicalZetaCayleyJUnitary.cayleyCoefficient_mirrorIndex` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is the coefficient-level consequence of the existing Cayley mirror-coordinate theorem.

**Theorem 1.2 (The zero Cayley operator is J-unitary).**

Lean statement: `D5/S3/Midline/Cayley/CanonicalZetaCayleyJUnitary.zeroCayleyOperator_j_unitary`

*Proof.* Machine-checked in Lean as `D5/S3/Midline/Cayley/CanonicalZetaCayleyJUnitary.zeroCayleyOperator_j_unitary` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Coordinatewise inverse-conjugate coefficients preserve the mirror Krein form, and summation yields the operator identity.

## References

- Truth anchor: `D5/S3/Midline/Cayley/CanonicalZetaCayleyJUnitary.cayleyCoefficient_mirrorIndex`
- Truth anchor: `D5/S3/Midline/Cayley/CanonicalZetaCayleyJUnitary.zeroCayleyOperator_j_unitary`
- Dependency: [D5/S3/Midline/Cayley/CanonicalZetaMirrorFundamentalSymmetry](CanonicalZetaMirrorFundamentalSymmetry.md)
- Dependency: [D5/S3/Midline/Cayley/CayleyMirrorCoordinates](CayleyMirrorCoordinates.md)
