# Exact Weil Observable Range

## Abstract

The actual finite scalar even Weil observer reaches exactly the reflection-even, multiplicity-constant vectors; multiplicity replication preserves its readout kernel.

**Theorem 1.1 (Reflection-evenness is sufficient and necessary).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.finiteWeilIndexEvaluation_range_iff`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.finiteWeilIndexEvaluation_range_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Extend the finite window assignment by zero. Reflection closure preserves compatibility. The existing finite even interpolation theorem then supplies an actual compact smooth test.

**Theorem 1.2 (Exact image in multiplicity-expanded coordinates).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.finiteWeilCoordinateEvaluation_range_iff`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.finiteWeilCoordinateEvaluation_range_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Actual positive analytic multiplicities provide one copy for collapse. Expansion and collapse are inverse on the fiber-constant subspace.

**Theorem 1.3 (Redundant copies create no semantic information gain).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.no_intrinsic_kernel_escape_from_multiplicity_replication`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.no_intrinsic_kernel_escape_from_multiplicity_replication` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The state arena remains all WeilTestFunction values. These are kernel-equality statements on an infinite arena. No finite collision probability, artificial truth-conditioned state subtype, or primitive-law admission is claimed.

**Theorem 1.4 (Mixed Weil form factors through the exact range).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.truncatedZeroSum_mixed_eq_reducedMirrorForm`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.truncatedZeroSum_mixed_eq_reducedMirrorForm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The off-diagonal identity uses the existing mirror and convolution owners. Analytic multiplicity appears once as a weight. Kernel checking and admission remain separate verification obligations.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.finiteWeilCoordinateEvaluation_range_iff`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.finiteWeilIndexEvaluation_range_iff`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.no_intrinsic_kernel_escape_from_multiplicity_replication`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange.truncatedZeroSum_mixed_eq_reducedMirrorForm`
- Dependency: [D5/S3/Fourier/ConvolutionPowerAmplification](../../Fourier/ConvolutionPowerAmplification.md)
- Dependency: [D5/S3/Weil/ZetaBridge/FiniteMirrorReducedWeilFactorization](FiniteMirrorReducedWeilFactorization.md)
- Dependency: [D5/S3/Weil/ZetaBridge/FiniteReflectionCompatibleWeilInterpolation](FiniteReflectionCompatibleWeilInterpolation.md)
