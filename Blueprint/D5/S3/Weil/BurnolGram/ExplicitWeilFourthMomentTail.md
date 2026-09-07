# Explicit Fourth-Moment Tail of Actual Zeta Zeros

## Abstract

An unconditional rational scalar tail for actual zeta zeros, with derived summability, analytic multiplicities and explicit endpoint conventions.

**Definition 1.1 (Integer logarithm enclosure).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.fourthTailLogCeiling`

*Formalization.* `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.fourthTailLogCeiling` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This is a total natural arithmetic function. Its real-logarithm upper-bound theorem is proved below.

**Definition 1.2 (Rational two-sided spectral tail).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.rationalFourthMomentTail`

*Formalization.* `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.rationalFourthMomentTail` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This computes a rational upper bound for the actual two-sided fourth moment when T>=5 and the excluded set contains the complex spectral ball T+1. It supplies no individual zero-location claim.

**Definition 1.3 (Real finite-window budget).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.fourthTailBudget`

*Formalization.* `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.fourthTailBudget` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

L encloses log(T+4), and A bounds actual local counts. The specialization uses the proved numerical coefficient 128.

**Theorem 1.4 (Identify the actual ordinate).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_gamma_re`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_gamma_re` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Unfold the existing spectral parameter. No critical-line hypothesis is needed.

**Theorem 1.5 (Transfer the numerical count without losing multiplicities).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_large_window_count`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_large_window_count` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Map indices injectively to actual zeta zeros, identify analytic multiplicities through ClassicExplicitFormula, and apply ExplicitLargeHeightZeroCount. Reindexing does not replicate zeros.

**Theorem 1.6 (Local counts control every finite fourth-power tail).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.finite_inverse_fourth_tail_le`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.finite_inverse_fourth_tail_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use ceil(gamma)-1 on the positive side and floor(-gamma) on the negative side. Empty unit windows need no count hypothesis. Reuse the existing finite cubic telescoping bound, then use 1/|gamma|<=1/T. Each endpoint receives ordinary full weight exactly once.

**Theorem 1.7 (Reconcile the complex and real cutoffs).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.ordinate_large_outside_spectral_ball`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.ordinate_large_outside_spectral_ball` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the genuine critical strip bound |Im(gamma_n)|<=1/2 and the complex norm triangle bound. No real-zero assumption is introduced.

**Theorem 1.8 (Derive both summability and the actual tail bound).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_fourth_moment_tail`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_fourth_moment_tail` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

All finite subsums are bounded by the proved numerical local count. Nonnegativity then gives summability and the same total bound. The theorem does not assume either of those conclusions.

**Theorem 1.9 (Certify the integer enclosure).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.fourthTailLogCeiling_sound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.fourthTailLogCeiling_sound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Nat.log bounds T+4 by the next power of two. Apply log monotonicity and log(2)<=1. There is no floating-point logarithm.

**Theorem 1.10 (Exact rational-to-real semantics).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.rationalFourthMomentTail_cast`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.rationalFourthMomentTail_cast` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Rational casts commute with finite field arithmetic; the numerical factors agree exactly.

**Theorem 1.11 (Close the scalar analytic tail premise).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_fourth_moment_tail_rational`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_fourth_moment_tail_rational` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Combine the actual count-to-tail theorem with the integer logarithm enclosure. This is a conservative proof from Jensen and finite telescoping, independent of externally asserted Lehman or BPT numerical bounds. Candidate source review is distinct from Lean kernel verification.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.finite_inverse_fourth_tail_le`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.fourthTailBudget`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.fourthTailLogCeiling`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.fourthTailLogCeiling_sound`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.ordinate_large_outside_spectral_ball`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.rationalFourthMomentTail`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.rationalFourthMomentTail_cast`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_fourth_moment_tail`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_fourth_moment_tail_rational`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_gamma_re`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.zeroData_large_window_count`
- Dependency: [D5/S3/Weil/ZetaBridge/ExplicitLargeHeightZeroCount](ExplicitLargeHeightZeroCount.md)
- Dependency: [D5/S3/Weil/ZetaBridge/WeilMixedHeadTailBudget](WeilMixedHeadTailBudget.md)
