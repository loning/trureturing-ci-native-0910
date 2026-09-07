# Finite Mirror-Reduced Weil Factorization

## Abstract

Finite convolution-square zero sums factor through the reflection-reduced observable space with analytic multiplicity retained as a positive weight.

**Theorem 1.1 (The actual finite convolution-square zero sum is a reduced mirror form).**

Lean statement: `D5/S3/Weil/ZetaBridge/FiniteMirrorReducedWeilFactorization.truncatedZeroSum_convolutionSquare_eq_reducedMirrorForm`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/FiniteMirrorReducedWeilFactorization.truncatedZeroSum_convolutionSquare_eq_reducedMirrorForm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

One scalar coordinate is retained per distinct zero. Functional-equation reflection-evenness is stored as a subtype condition, while analytic multiplicity remains in the quadratic weight and is not counted a second time through duplicated coordinates.

The proof uses the frozen complex convolution-square factorization and the stored same-height mirror relation on spectral parameters, then rewrites the finite symmetric cutoff as a subtype sum.

**Theorem 1.2 (Finite orbit blocks split into positive even energy minus positive odd energy).**

Lean statement: `D5/S3/Weil/ZetaBridge/FiniteMirrorReducedWeilFactorization.finite_offLine_orbit_block_factorization`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/FiniteMirrorReducedWeilFactorization.finite_offLine_orbit_block_factorization` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The theorem sums the established one-orbit parity decomposition over an arbitrary finite family. Both aggregate channel energies remain nonnegative. Orbit disjointness is required only when identifying the block sum with a union of zero indices, not for the algebraic decomposition.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/FiniteMirrorReducedWeilFactorization.finite_offLine_orbit_block_factorization`
- Truth anchor: `D5/S3/Weil/ZetaBridge/FiniteMirrorReducedWeilFactorization.truncatedZeroSum_convolutionSquare_eq_reducedMirrorForm`
- Dependency: [D5/S3/Weil/HolonomyBridge/OffLineOrbitParityDecomposition](../HolonomyBridge/OffLineOrbitParityDecomposition.md)
- Dependency: [D5/S3/Weil/ZetaBridge/WeilEvaluationObservableSubspace](WeilEvaluationObservableSubspace.md)
