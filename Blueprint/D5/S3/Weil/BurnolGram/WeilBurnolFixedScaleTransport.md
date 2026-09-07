# Support-Controlled Negativity and Fixed-Scale Transport

## Abstract

A constructed finite negative family fits in one common support window, and its uniform margin transfers to the existing completed Fourier multiplier with the exact pole correction.

**Theorem 1.1 (Isolate the completed multiplier).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolFixedScaleTransport.fixedScale_multiplier_re_eq_full_minus_pole`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolFixedScaleTransport.fixedScale_multiplier_re_eq_full_minus_pole` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Take real parts of fixed_scale_weil_quadratic_form. The multiplier is exactly fixedScaleMultiplier from that owner. The nonnegative rank-one pole term is subtracted, with no new form or independent positivity assumption introduced.

**Theorem 1.2 (One support window for the entire negative family).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolFixedScaleTransport.exists_support_controlled_full_negative_family`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolFixedScaleTransport.exists_support_controlled_full_negative_family` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Construct the common Burnol packet, derive its support constants, and choose a common depth from the coefficient-uniform margin. Compact support is uniform over all coefficients at this chosen depth. Existence of an off-line frame is not asserted.

**Theorem 1.3 (Transport the negative margin with its support cost).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolFixedScaleTransport.eventually_burnol_fixedScale_multiplier_margin`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolFixedScaleTransport.eventually_burnol_fixedScale_multiplier_margin` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The exact pole-subtraction identity transports the actual full-Gram bound. Both the support radius and the chosen threshold are uniform in coefficients. The ArchimedeanConvergent witness required by this branch's fixed-scale API remains explicit. This is an arithmetic negative certificate conditional on the given off-line frame, and supplies no proof of RH or prime-side positivity.

## References

- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolFixedScaleTransport.eventually_burnol_fixedScale_multiplier_margin`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolFixedScaleTransport.exists_support_controlled_full_negative_family`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolFixedScaleTransport.fixedScale_multiplier_re_eq_full_minus_pole`
- Dependency: [D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget](WeilBurnolSupportBudget.md)
- Dependency: [D5/S3/Weil/BurnolGram/WeilFullGramUniformRemainder](WeilFullGramUniformRemainder.md)
- Dependency: [D5/S3/Weil/ZetaBridge/FixedScaleWeilQuadraticForm](../ZetaBridge/FixedScaleWeilQuadraticForm.md)
