# Support Budget of Multi-Orbit Localization

## Abstract

Actual Burnol tests have a linear support-radius budget common to every coefficient vector. Positive peak and killer radii are derived from compactness.

**Theorem 1.1 (Convolution adds support radii).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.convolve_tsupport_subset_Icc`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.convolve_tsupport_subset_Icc` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use Mathlib support_convolution_subset and closedness of the sum of two compact supports. Add the two endpoint inequalities. This extends the radius-one power argument already used in ConvolutionPowerAmplification.

**Theorem 1.2 (The successor power budget).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.convolutionSuccPower_tsupport_subset_Icc`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.convolutionSuccPower_tsupport_subset_Icc` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Induct using the existing successor-power constructor. The zero index means one actual convolution factor, so no compactly supported convolution identity is invented.

**Theorem 1.3 (All coefficients share the basis window).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.finiteWeilLinearCombination_tsupport_subset_Icc`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.finiteWeilLinearCombination_tsupport_subset_Icc` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Outside the interval every summand vanishes. Closedness passes this support containment to the topological support.

**Theorem 1.4 (A positive common radius exists).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.finiteWeilFamily_common_support_radius`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.finiteWeilFamily_common_support_radius` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Compact supports are bounded. Choose positive individual radii and use one plus their finite sum. The construction also handles the empty family.

**Theorem 1.5 (Linear support cost of localization).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.burnolSynthesis_tsupport_subset`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.burnolSynthesis_tsupport_subset` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Apply the power bound to the common peak, add the killer radius, and then apply the finite synthesis bound. The radius does not depend on a.

**Theorem 1.6 (The budget constants come from the actual packet).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.exists_burnol_linear_support_budget`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.exists_burnol_linear_support_budget` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Apply finite-family compactness to the singleton peak family and the actual killer family. The resulting constants depend on the packet. No common radius over all depths or all frames is asserted.

## References

- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.burnolSynthesis_tsupport_subset`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.convolutionSuccPower_tsupport_subset_Icc`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.convolve_tsupport_subset_Icc`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.exists_burnol_linear_support_budget`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.finiteWeilFamily_common_support_radius`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget.finiteWeilLinearCombination_tsupport_subset_Icc`
- Dependency: [D5/S3/Weil/BurnolGram/MultiOrbitBurnolUniformRemainder](MultiOrbitBurnolUniformRemainder.md)
