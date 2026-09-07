# Weil Evaluation Observable Subspace

## Abstract

Scalar even Weil evaluation is constant on analytic-multiplicity fibers and invariant under functional-equation reflection, producing explicit finite rank obstructions.

**Theorem 1.1 (Finite scalar Weil evaluations obey both observable-range constraints).**

Lean statement: `D5/S3/Weil/WeilObservables/WeilEvaluationObservableSubspace.finite_weil_evaluation_observable_subspace_spec`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/WeilObservables/WeilEvaluationObservableSubspace.finite_weil_evaluation_observable_subspace_spec` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The finite coordinate evaluation repeats one Fourier-Laplace value over every analytic-multiplicity copy. The finite index evaluation is unchanged by functional-equation reflection because bundled Weil tests are even.

The module constructs explicit target vectors proving non-surjectivity whenever a multiplicity fiber has at least two copies or the window contains a moved reflection pair. These are genuine observer-rank obstructions, not dimension-counting assumptions.

**Theorem 1.2 (Multiplicity copies obstruct ambient surjectivity).**

Lean statement: `D5/S3/Weil/WeilObservables/WeilEvaluationObservableSubspace.finiteWeilCoordinateEvaluation_not_surjective_of_two_copies`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/WeilObservables/WeilEvaluationObservableSubspace.finiteWeilCoordinateEvaluation_not_surjective_of_two_copies` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A scalar test cannot assign different values to two copies of the same analytic zero. The proof supplies an explicit ambient target vector separating the two copies and derives a contradiction from fiber constancy.

## References

- Truth anchor: `D5/S3/Weil/WeilObservables/WeilEvaluationObservableSubspace.finiteWeilCoordinateEvaluation_not_surjective_of_two_copies`
- Truth anchor: `D5/S3/Weil/WeilObservables/WeilEvaluationObservableSubspace.finite_weil_evaluation_observable_subspace_spec`
- Dependency: [D5/S3/Midline/Cayley/CanonicalZetaMirrorFundamentalSymmetry](../../Midline/Cayley/CanonicalZetaMirrorFundamentalSymmetry.md)
- Dependency: [D5/S3/Weil/ZetaBridge/ConvolutionSquareOrbitBounds](../ZetaBridge/ConvolutionSquareOrbitBounds.md)
