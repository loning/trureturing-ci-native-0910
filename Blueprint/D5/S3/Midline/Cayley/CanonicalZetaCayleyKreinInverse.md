# Canonical zeta Cayley Krein inverse

## Abstract

Mirror symmetry constructs the bounded two-sided inverse of the zero Cayley operator and identifies it with J U-star J.

**Theorem 1.1 (The zero Cayley operator is unconditionally invertible).**

Lean statement: `D5/S3/Midline/Cayley/CanonicalZetaCayleyKreinInverse.zeroCayleyOperator_isUnit_unconditional`

*Proof.* Machine-checked in Lean as `D5/S3/Midline/Cayley/CanonicalZetaCayleyKreinInverse.zeroCayleyOperator_isUnit_unconditional` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The reciprocal multiplier is bounded by transporting the original bounded coefficients through mirror permutation and conjugation.

**Theorem 1.2 (The explicit inverse equals J U-star J).**

Lean statement: `D5/S3/Midline/Cayley/CanonicalZetaCayleyKreinInverse.zeroCayleyKreinInverse_eq_explicit`

*Proof.* Machine-checked in Lean as `D5/S3/Midline/Cayley/CanonicalZetaCayleyKreinInverse.zeroCayleyKreinInverse_eq_explicit` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The same proof yields the companion conservation identity U J U-star = J without ordinary unitarity.

## References

- Truth anchor: `D5/S3/Midline/Cayley/CanonicalZetaCayleyKreinInverse.zeroCayleyKreinInverse_eq_explicit`
- Truth anchor: `D5/S3/Midline/Cayley/CanonicalZetaCayleyKreinInverse.zeroCayleyOperator_isUnit_unconditional`
- Dependency: [D5/S3/Midline/Cayley/CanonicalZetaCayleyJUnitary](CanonicalZetaCayleyJUnitary.md)
- Dependency: [D5/S3/Midline/Cayley/CanonicalZetaMirrorEvenOddDecomposition](CanonicalZetaMirrorEvenOddDecomposition.md)
