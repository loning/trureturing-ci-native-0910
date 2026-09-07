# Rational Two-Jet Budget Verifier

## Abstract

A finite rational expression bounds the actual mixed majorant and certifies the common depth and support radius, with analytic input premises explicit.

**Definition 1.1 (Finite spectral-head calculator).**

Lean statement: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalSpectralHead`

*Formalization.* `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalSpectralHead` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

M bounds the analytic multiplicity and lower is a nonnegative lower enclosure of the absolute ordinate. The finite set E still refers to actual zero indices.

**Theorem 1.2 (One certified rational head bound).**

Lean statement: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.fourthMomentSummand_le_rational_enclosure`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.fourthMomentSummand_le_rational_enclosure` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Compare positive denominators after squaring the nonnegative height bound, then use the multiplicity upper bound. The term carries full multiplicity.

**Theorem 1.3 (Finite head soundness).**

Lean statement: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalSpectralHead_sound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalSpectralHead_sound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Sum the pointwise inequalities and transport the rational arithmetic through the real embedding. No BPT half-endpoint convention is silently applied.

**Definition 1.4 (Executable rational majorant).**

Lean statement: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalJetMajorant`

*Formalization.* `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalJetMajorant` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

All operations are finite rational sums, products and powers. The data acquire analytic meaning only through the soundness hypotheses.

**Theorem 1.5 (Actual infinite family bound).**

Lean statement: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalJetMajorant_sound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalJetMajorant_sound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Derive both transform bounds by integration by parts. Apply the all-cross-term head-tail theorem and transfer the finite rational calculation to the reals. C_actual is a conclusion, not an input.

**Theorem 1.6 (Computed depth on the actual full Gram).**

Lean statement: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rational_unit_packet_support_and_margin`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rational_unit_packet_support_and_margin` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The scalar spectral-tail estimate remains the independent number-theoretic obligation. No axiom for a published numerical estimate is added. Strict negativity additionally requires p/q<4 and a nonzero coefficient vector. The arithmetic examples are regression cases, not actual off-line zeta data.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.fourthMomentSummand_le_rational_enclosure`
- Truth anchor: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalJetMajorant`
- Truth anchor: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalJetMajorant_sound`
- Truth anchor: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalSpectralHead`
- Truth anchor: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rationalSpectralHead_sound`
- Truth anchor: `D5/S3/Weil/ZetaBridge/RationalWeilJetBudget.rational_unit_packet_support_and_margin`
- Dependency: [D5/S3/Weil/ZetaBridge/UnitSupportBurnolPacket](UnitSupportBurnolPacket.md)
