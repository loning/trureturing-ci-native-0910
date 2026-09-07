# Canonical equivalence of ZeroData presentations

## Abstract

Exhaustive ZeroData presentations admit a unique zero-preserving symmetry-equivariant reindexing.

**Theorem 1.1 (Zero-preserving reindexing is unique).**

Lean statement: `D5/S3/Weil/ZetaBridge/ZeroDataPresentationEquiv.zeroDataPresentationEquiv_unique`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ZeroDataPresentationEquiv.zeroDataPresentationEquiv_unique` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The construction reuses the existing equivalence from each ZeroData presentation to the canonical nontrivial-zero subtype.

**Theorem 1.2 (Presentation transport intertwines the mirror).**

Lean statement: `D5/S3/Weil/ZetaBridge/ZeroDataPresentationEquiv.zeroDataPresentationEquiv_mirror`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ZeroDataPresentationEquiv.zeroDataPresentationEquiv_mirror` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Reflection, conjugation, multiplicity, and the same-height mirror are transported by the unique reindexing.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/ZeroDataPresentationEquiv.zeroDataPresentationEquiv_mirror`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ZeroDataPresentationEquiv.zeroDataPresentationEquiv_unique`
- Dependency: [D5/S3/Weil/ZetaBridge/ZeroSumEnumerationInvariance](ZeroSumEnumerationInvariance.md)
- Dependency: [D5/S3/Zeros/Symmetry/ZeroSymmetryAction](../../Zeros/Symmetry/ZeroSymmetryAction.md)
