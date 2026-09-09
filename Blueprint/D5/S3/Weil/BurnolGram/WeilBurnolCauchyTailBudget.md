# WeilBurnolCauchyTailBudget

## Abstract

Quantitative bounds for actual multi-orbit Weil tests, with explicit finite geometry and scalar spectral-tail premises.

**Theorem 1.1 (Cauchy-Schwarz for both actual channels).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.synthesized_product_le_squared_decay`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.synthesized_product_le_squared_decay` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Bound each squared norm by finite Cauchy-Schwarz, then use the nonnegative square of the difference of the norms. Every coefficient cross term is covered.

**Theorem 1.2 (Exact exceptional-head cancellation).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.burnolRemainder_eq_exceptional_tail`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.burnolRemainder_eq_exceptional_tail` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The actual killer interpolation makes all non-target exceptional summands zero. Split the absolutely convergent full sum and cancel the exact selected-orbit contribution.

**Theorem 1.3 (Direct quadratic tail coefficient).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.burnol_uniform_cauchy_tail_bound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.burnol_uniform_cauchy_tail_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the exact head cancellation, common peak tail, Cauchy-Schwarz and summable comparison. This coefficient bounds the quadratic remainder directly. It is not identified with the old entrywise mixed-majorant total. The BPT positive-ordinate half-endpoint convention requires separate reconciliation with this two-sided full-multiplicity tail.

**Theorem 1.4 (Discharge transform-decay premises).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.burnol_cauchy_tail_bound_of_two_jets`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.burnol_cauchy_tail_bound_of_two_jets` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Reuse zero_transform_pair_le_three_jets for both conjugate evaluations. The jet bounds are finite analytic data, while the scalar spectral tail remains the independent number-theoretic premise.

**Theorem 1.5 (Apply the existing exact depth selector).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.cauchy_budget_full_gram_margin`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.cauchy_budget_full_gram_margin` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The existing integer selector bounds the geometric error. Positive analytic multiplicities give target margin four. The bound is for the actual full Gram, with all infinite-tail cross terms retained.

**Definition 1.6 (Executable rational direct coefficient).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.rationalCauchyTailBudget`

*Formalization.* `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.rationalCauchyTailBudget` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

There is no finite-head term because the actual head was proved to cancel. The definition evaluates rational arithmetic only; it does not certify zeta zeros or a published analytic estimate.

**Theorem 1.7 (Exact real semantics).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.rationalCauchyTailBudget_cast`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.rationalCauchyTailBudget_cast` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Finite sums, products and powers commute with the rational-to-real cast.

## References

- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.burnolRemainder_eq_exceptional_tail`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.burnol_cauchy_tail_bound_of_two_jets`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.burnol_uniform_cauchy_tail_bound`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.cauchy_budget_full_gram_margin`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.rationalCauchyTailBudget`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.rationalCauchyTailBudget_cast`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilBurnolCauchyTailBudget.synthesized_product_le_squared_decay`
- Dependency: [D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget](WeilMixedHeadTailBudget.md)
