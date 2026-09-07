# Finite Box Smoothing and Quantitative Weil Seeds

## Abstract

Finite box convolution constructs actual even smooth compact seeds with unit mass and explicit finite-order L1 derivative bounds, eliminating dependence on unknown initial bump derivatives.

**Definition 1.1 (The normalized box density).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxDensity`

*Formalization.* `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxDensity` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The density is an integrable raw function, not itself a smooth Weil test. Unit mass and unit L1 norm require a>0.

**Definition 1.2 (Actual smooth box averaging).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean`

*Formalization.* `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Mathlib convolution regularity gives smoothness from the compact smooth right input. Symmetry of the interval preserves evenness.

**Theorem 1.3 (The integral is preserved).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_integral`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_integral` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Apply the actual convolution integral identity and the computed unit box mass.

**Theorem 1.4 (L1 contraction).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_norm_integral_le`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_norm_integral_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The integral triangle inequality and the integral of the scalar convolution give Young's L1 inequality with unit constant.

**Theorem 1.5 (Additive support cost).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_tsupport`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_tsupport` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the existing convolution-support containment and closedness of the enclosing interval.

**Theorem 1.6 (One derivative consumes one box).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_iterate_deriv_succ`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_iterate_deriv_succ` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Convolution differentiation moves derivatives to the smooth input. The ordinary fundamental theorem of calculus evaluates the final box integral. Literature anchor: Michele Vergne, A remark on the convolution with the box spline, Annals of Mathematics 174 (2011), 607-618, Section 1, the derivative/difference identity immediately preceding Section 2; DOI 10.4007/annals.2011.174.1.19. The present result is the centered one-dimensional scaled specialization.

**Definition 1.7 (Finite iteration).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate`

*Formalization.* `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The zero iteration retains the existing smooth seed. No distributional identity is installed as a Weil test.

**Theorem 1.8 (Unit mass at every finite depth).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate_integral`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate_integral` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Induct on q using mass preservation of one box average.

**Theorem 1.9 (Finite jets without initial jet assumptions).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate_derivative_L1_budget`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate_derivative_L1_budget` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Induction charges each derivative to a different box. Translation invariance bounds the centered difference by a^(-1) times the previous L1 norm. No derivative seminorm of g is used.

**Theorem 1.10 (Finite support accumulation).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate_tsupport`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate_tsupport` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Induct on the existing support containment.

**Definition 1.11 (Explicit box width).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxWidth`

*Formalization.* `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxWidth` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The denominator is positive for h>0, including q=0.

**Definition 1.12 (The actual derivative-controlled seed).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxSeed`

*Formalization.* `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxSeed` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The canonical smooth bump contributes unit mass. Its uncomputed high derivatives never enter the budget.

**Theorem 1.13 (Constructed simultaneous quantitative budget).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxSeed_budget`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxSeed_budget` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The support is bounded by h/2+qh/(2(q+1))<=h. L1 contraction and the unit integral force L1=1. The derivative inequality is the finite-box estimate specialized to this explicit width.

**Theorem 1.14 (A common explicit transform denominator floor).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxSeed_transform_lower`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxSeed_transform_lower` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Reuse the proved compact-support transform perturbation bound and unit mass/L1. This combines support, a finite derivative budget and nonvanishing for actual functions. Source is Candidate; no pinned Lean compilation is claimed.

## References

- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxDensity`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate_derivative_L1_budget`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate_integral`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxIterate_tsupport`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_integral`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_iterate_deriv_succ`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_norm_integral_le`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.boxMean_tsupport`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxSeed`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxSeed_budget`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxSeed_transform_lower`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteBoxWeilMollifier.finiteBoxWidth`
- Dependency: [D5/S3/Weil/InterpolationJets/QuantitativeEvenSeed](../InterpolationJets/QuantitativeEvenSeed.md)
