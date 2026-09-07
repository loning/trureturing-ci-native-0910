# Rational Burnol Depth Budget

## Abstract

Exact integer depth selection and rational support budgets for the existing full multi-orbit Weil family.

**Definition 1.1 (Exact integer depth).**

Lean statement: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth`

*Formalization.* `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This total function uses only natural arithmetic. Soundness requires d,p,q>0; no claim is made for zero denominators.

**Definition 1.2 (Rational support ledger).**

Lean statement: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalBurnolRadius`

*Formalization.* `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalBurnolRadius` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This computes the existing additive convolution support budget without selecting a new radius by compactness.

**Theorem 1.3 (Strict integer certificate).**

Lean statement: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth_integer_sound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth_integer_sound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the strict next-power bound for the floor logarithm, and natural division with remainder. The strict inequality handles exact powers of four correctly.

**Theorem 1.4 (Certified geometric decay).**

Lean statement: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth_real_sound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth_real_sound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Cross multiplication is performed only after denominator positivity. This replaces a classical eventual-smallness threshold with an executable integer formula.

**Theorem 1.5 (The actual full Gram at the computed depth).**

Lean statement: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth_full_gram_margin`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth_full_gram_margin` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Apply the existing coefficient-uniform remainder, retaining all cross terms, and the analytic multiplicity floor one. A strictly negative conclusion additionally needs p/q<4 and a nonzero coefficient vector.

**Theorem 1.6 (One computable support and error budget).**

Lean statement: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalBurnol_support_and_margin`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalBurnol_support_and_margin` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The support certificates refer to the actual peak and killer functions. The analytic majorant upper bound remains explicit here and must be derived by the analytic budget owner; it is never replaced by an unverified numerical estimate.

## References

- Truth anchor: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalBurnolRadius`
- Truth anchor: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalBurnol_support_and_margin`
- Truth anchor: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth`
- Truth anchor: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth_full_gram_margin`
- Truth anchor: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth_integer_sound`
- Truth anchor: `D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget.rationalQuarterDepth_real_sound`
- Dependency: [D5/S3/Weil/BurnolGram/WeilBurnolSupportBudget](WeilBurnolSupportBudget.md)
- Dependency: [D5/S3/Weil/BurnolGram/WeilFullGramUniformRemainder](WeilFullGramUniformRemainder.md)
