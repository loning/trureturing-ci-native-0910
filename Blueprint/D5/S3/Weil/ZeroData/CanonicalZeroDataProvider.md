# Canonical ZeroData Provider

## Abstract

Package an actual exhaustive zeta-zero enumeration and prove canonicality for permutation-invariant zero sums.

**Theorem 1.1 (Canonicality at the observable level).**

Lean statement: `D5/S3/Weil/ZeroData/CanonicalZeroDataProvider.canonical_zeroSum_eq`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZeroData/CanonicalZeroDataProvider.canonical_zeroSum_eq` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The provider is selected by classical choice from a proof that the actual nontrivial zeta-zero set is infinite. It is exhaustive, duplicate-free, multiplicity-aware, reflection faithful, conjugation faithful, and locally finite.

The ordering is not asserted to be intrinsic. Existing enumeration-invariance theorems show that finite symmetric sums, convergence, and zero-sum values agree with every other valid ZeroData enumeration.

## References

- Truth anchor: `D5/S3/Weil/ZeroData/CanonicalZeroDataProvider.canonical_zeroSum_eq`
- Dependency: [D5/S3/Weil/ZeroData/CanonicalZeroDataFromRiemannVonMangoldt](CanonicalZeroDataFromRiemannVonMangoldt.md)
- Dependency: [D5/S3/Weil/ZetaBridge/ZeroSumEnumerationInvariance](../ZetaBridge/ZeroSumEnumerationInvariance.md)
