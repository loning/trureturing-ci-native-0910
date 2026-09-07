# Explicit Nonvanishing Seed Radius

## Abstract

A normalized positive bump with radius h=1/(4(R+1)) has Fourier-Laplace norm at least one half at every node of norm at most R.

**Definition 1.1 (Specified support radius).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.radiusBump`

*Formalization.* `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.radiusBump` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The support radius is specified explicitly rather than selected from continuity of a transform.

**Definition 1.2 (An actual admissible even seed).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed`

*Formalization.* `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Reuse the Mathlib normalized bump and the existing WeilTestFunction bundle. Smoothness, compactness and evenness are proved fields. Numerical evaluation still needs certified real-function computation.

**Theorem 1.3 (Unit complex mass).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed_integral`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed_integral` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Transport the existing normed-bump integral theorem through the real-to-complex map.

**Theorem 1.4 (Unit absolute mass).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed_norm_integral`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed_norm_integral` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The underlying bump is nonnegative, so its absolute integral equals its mass.

**Theorem 1.5 (Topological support is controlled).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed_tsupport`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed_tsupport` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the exact bump support and take closure in the closed interval. Boundary points are included.

**Theorem 1.6 (A quantitative nonvanishing neighborhood).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.fourierLaplace_sub_one_norm_le`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.fourierLaplace_sub_one_norm_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Integrate the pointwise bound |exp(w)-1|<=2|w| for |w|<=1. The support certificate supplies |x|<=h. No unknown continuity radius is chosen.

**Definition 1.7 (An explicit arithmetic radius).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.quantitativeSeedRadius`

*Formalization.* `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.quantitativeSeedRadius` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A rational bound R produces a rational radius.

**Theorem 1.8 (Radius positivity).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.quantitativeSeedRadius_pos`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.quantitativeSeedRadius_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

All denominator signs are proved.

**Theorem 1.9 (Uniform normalization denominator).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.quantitativeEvenSeed_transform_lower`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.quantitativeEvenSeed_transform_lower` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The transform differs from one by at most one half, and the reverse triangle inequality gives the denominator lower bound. Higher derivative seminorms are separate quantitative inputs.

## References

- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.fourierLaplace_sub_one_norm_le`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed_integral`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed_norm_integral`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.normalizedEvenSeed_tsupport`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.quantitativeEvenSeed_transform_lower`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.quantitativeSeedRadius`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.quantitativeSeedRadius_pos`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.radiusBump`
- Dependency: [D5/S3/Weil/TestFunctions/FinitePaleyWienerInterpolation](FinitePaleyWienerInterpolation.md)
