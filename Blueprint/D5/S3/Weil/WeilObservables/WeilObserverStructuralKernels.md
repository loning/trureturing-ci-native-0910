# Structural Kernels of Weil Observations

## Abstract

Selected odd channels give faithful inclusion-reversing equality kernels on actual Weil tests. Localization preserves those readouts, including comparisons across different depths.

**Definition 1.1 (The equality relation of selected channels).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel`

*Formalization.* `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The state space is the original infinite WeilTestFunction type. Only a finite set of readouts is selected.

**Theorem 1.2 (Equivalence relation).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_equivalence`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_equivalence` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Each property follows pointwise from equality of the selected readouts.

**Theorem 1.3 (Exact pullback under interpolation).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_synthesis_iff`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_synthesis_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Apply the existing interpolation right-inverse theorem at each channel.

**Theorem 1.4 (Exclusive test pair for each channel).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserver_leave_one_out_witness`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserver_leave_one_out_witness` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Synthesize the Kronecker coefficient vector and the zero coefficient vector. These are actual admissible tests.

**Theorem 1.5 (Exact reversal of channel inclusion).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_refines_iff`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_refines_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The forward implication uses the exclusive pair of any purported missing channel. The reverse implication restricts the observations.

**Theorem 1.6 (Faithfulness of channel subsets).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_eq_iff`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_eq_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Apply the inclusion theorem in both directions and finite-set antisymmetry.

**Theorem 1.7 (Joint observations).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_union`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_union` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Membership in the union separates the universal readout constraint into its two components.

**Theorem 1.8 (Strict enlargement after channel removal).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_strict_leave_one_out`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_strict_leave_one_out` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The exclusive test pair witnesses strictness. This assertion concerns the specified channel family and does not assert positive gain for every theorem occurrence in a maximal catalog.

**Theorem 1.9 (Localized pullback).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_burnol_iff`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_burnol_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The actual Burnol readout remains a right inverse at every depth.

**Theorem 1.10 (Comparisons across distinct localization depths).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_burnol_depth_invariant`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_burnol_depth_invariant` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The two tests may have different support radii and different analytic errors. Their selected readouts depend only on the original coefficients.

**Theorem 1.11 (Localization preserves the interpolation kernel).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_burnol_eq_interpolation`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_burnol_eq_interpolation` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Both kernels are exactly coordinate equality on S. No equality of observations outside the frame is asserted.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_burnol_depth_invariant`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_burnol_eq_interpolation`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_burnol_iff`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_eq_iff`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_equivalence`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_refines_iff`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_strict_leave_one_out`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_synthesis_iff`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserverKernel_union`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilObserverStructuralKernels.frameObserver_leave_one_out_witness`
- Dependency: [D5/S3/Weil/ZetaBridge/MultiOrbitBurnolUniformRemainder](MultiOrbitBurnolUniformRemainder.md)
