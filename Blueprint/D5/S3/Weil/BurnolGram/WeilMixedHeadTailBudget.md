# Finite Head and Fourth-Moment Tail Budget

## Abstract

Finite transform enclosures and a scalar fourth-moment tail control the actual full mixed-majorant constant without assuming a bound on that operator-family constant.

**Theorem 1.1 (Rational two-jet decay coefficient).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.closedStripJetBudget_le_three_jets`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.closedStripJetBudget_le_three_jets` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The weighted integrals are bounded using support and exp(1/2)<3. Both L1 bounds refer to the actual test and its actual second derivative.

**Theorem 1.2 (Two conjugate readings from finite jets).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.zero_transform_pair_le_three_jets`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.zero_transform_pair_le_three_jets` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The critical strip bound is unconditional. Apply the named closed-strip budget at gamma_n and its conjugate; both have the same real ordinate.

**Theorem 1.3 (No assumed transform-decay constant remains).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorantTotal_le_unit_support_jets`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorantTotal_le_unit_support_jets` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Combine the derived two-sided transform estimate with the full mixed head-tail theorem. The scalar zero-tail bound remains the explicitly identified number-theoretic input; the published BPT estimate has not been kernel-ported here.

**Definition 1.4 (Ordinate decay envelope).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.inverseQuadraticEnvelope`

*Formalization.* `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.inverseQuadraticEnvelope` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The real part of gamma is the actual zero ordinate. The strip displacement is not used as the ordinate.

**Definition 1.5 (Multiplicity-weighted scalar tail).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.fourthMomentSummand`

*Formalization.* `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.fourthMomentSummand` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Exactly one analytic multiplicity factor is present per zero index.

**Definition 1.6 (A finite enclosure expression).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedHeadBound`

*Formalization.* `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedHeadBound` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The data bound both conjugate evaluations of each actual test. The expression includes every off-diagonal mixed term.

**Theorem 1.7 (Finite mixed head enclosure).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorant_head_le`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorant_head_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Expand the actual mixed summand, multiply nonnegative norm bounds, and factor the two finite coefficient sums.

**Theorem 1.8 (All tail cross terms at once).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorant_pointwise_decay`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorant_pointwise_decay` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the existing exact polarized Fourier-Laplace factorization. Multiplicity is counted once and no cross terms are dropped.

**Theorem 1.9 (Derived complete majorant bound).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorantTotal_le_head_tail`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorantTotal_le_head_tail` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Split the actual absolutely convergent mixed sum into E and its complement, compare the latter to the positive scalar tail, and sum. A bound on C_actual is a conclusion, not a field of a certificate. Brent-Platt-Trudgian (2021), Theorem 1, equations (1)-(3), is the literature entry for the remaining scalar tail; its numerical zeta-count estimates are not automatically imported by this theorem.

**Theorem 1.10 (Interface to the published inverse-power sum).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.fourthMomentSummand_le_inverse_fourth`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.fourthMomentSummand_le_inverse_fourth` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This supplies the envelope comparison for an inverse-fourth tail. Positive-height versus two-sided sums and endpoint half weights must still be reconciled in an application.

## References

- Truth anchor: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.closedStripJetBudget_le_three_jets`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedHeadBound`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorantTotal_le_head_tail`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorantTotal_le_unit_support_jets`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorant_head_le`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.finiteMixedMajorant_pointwise_decay`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.fourthMomentSummand`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.fourthMomentSummand_le_inverse_fourth`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.inverseQuadraticEnvelope`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilMixedHeadTailBudget.zero_transform_pair_le_three_jets`
- Dependency: [D5/S3/Weil/BurnolGram/BurnolRationalDepthBudget](BurnolRationalDepthBudget.md)
- Dependency: [D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay](../TestFunctions/FourierLaplaceClosedStripDecay.md)
