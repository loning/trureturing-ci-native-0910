# CanonicalLiGrowthZeroFree

## Abstract

Use the merged derivative-defined canonical Li sequence to prove actual xi zero-freeness from an all-index growth condition.

**Definition 1.1 (The actual canonical coefficient sum).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonicalLiSeries`

*Formalization.* `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonicalLiSeries` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The coefficients are imported from CanonicalLiLocalExpansion. Their definition and indexing are unchanged.

**Definition 1.2 (The actual xi function in disk coordinates).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonicalXiDisk`

*Formalization.* `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonicalXiDisk` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This is precisely xiReading composed with the standard inverse Mobius coordinate.

**Theorem 1.3 (Disk analyticity without a zero-location premise).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_xi_disk_analytic`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_xi_disk_analytic` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The entire original xiReading and the nonvanishing coordinate denominator prove analyticity on the entire unit disk.

**Theorem 1.4 (Consume the existing canonical local expansion).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_xi_disk_local_equation`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_xi_disk_local_equation` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The actual derivative chain rule and the merged all-order local series give F'=GF near zero, using only xi(1)=1/2 to justify local cancellation.

**Theorem 1.5 (Global disk equation and no zeros).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_summable_disk_zero_free`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_summable_disk_zero_free` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Absolute convergence at every smaller radius makes the same scalar sum analytic. The local equation extends and analytic orders exclude every disk zero.

**Theorem 1.6 (Actual open right-half-plane nonvanishing).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_summable_right_half_plane`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_summable_right_half_plane` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The inverse Mobius point lies in the unit disk precisely in the direction needed. Its round trip recovers the original complex argument.

**Theorem 1.7 (The standard RiemannHypothesis conclusion).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_disk_summability_implies_rh`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_disk_summability_implies_rh` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Existing actual xi-zero identification and right-half-strip reduction connect the no-zero result to Mathlib RiemannHypothesis. No supplied Li criterion is used.

**Theorem 1.8 (An explicit all-index growth condition suffices).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_quadratic_growth_implies_rh`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_quadratic_growth_implies_rh` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

An absolute quadratic bound on every actual canonical coefficient supplies the required disk convergence. The arithmetic bound itself is not proved here.

**Theorem 1.9 (Consumer for the prior probability envelope).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_probability_envelope_implies_rh`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_probability_envelope_implies_rh` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The input is the earlier probability route's exact output shape with its sequence identified as canonicalLiCoefficient. No candidate probability modules are copied into this branch.

**Theorem 1.10 (Every quadratic bound must fail under a failed RH).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.not_rh_forces_quadratic_escape`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.not_rh_forces_quadratic_escape` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The contrapositive produces an index exceeding any proposed absolute quadratic bound. It gives no finite cutoff for finding such an index.

## References

- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonicalLiSeries`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonicalXiDisk`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_disk_summability_implies_rh`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_probability_envelope_implies_rh`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_quadratic_growth_implies_rh`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_summable_disk_zero_free`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_li_summable_right_half_plane`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_xi_disk_analytic`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.canonical_xi_disk_local_equation`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.not_rh_forces_quadratic_escape`
- Dependency: [D5/S3/Analytic/ShiftedXiPoisson/ShiftedPoissonSemigroup](../../Analytic/ShiftedXiPoisson/ShiftedPoissonSemigroup.md)
- Dependency: [D5/S3/Weil/Probability/AnalyticLogarithmicContinuation](AnalyticLogarithmicContinuation.md)
- Dependency: [D5/S3/Weil/ZetaBridge/RightHalfStripRiemannReduction](../ZetaBridge/RightHalfStripRiemannReduction.md)
- Dependency: [D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion](../../Zeros/Endpoints/CanonicalLiLocalExpansion.md)
