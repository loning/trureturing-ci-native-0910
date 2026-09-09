# CanonicalLiRadiusObstruction

## Abstract

An actual xi disk zero obstructs every eventual canonical coefficient envelope beyond its radius.

**Theorem 1.1 (An eventual bound controls the analytic radius).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.scalar_series_analytic_of_eventual_bound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.scalar_series_analytic_of_eventual_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The pinned formal-series radius theorem uses the actual coefficients and permits an arbitrary finite initial segment.

**Theorem 1.2 (A tail envelope excludes actual disk zeros).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.canonical_weighted_tail_bound_zero_free`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.canonical_weighted_tail_bound_zero_free` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

At a positive radius at most one, the local actual-xi differential identity and the constructed analytic coefficient sum exclude every zero strictly inside that radius.

**Theorem 1.3 (Every tail exceeds every larger-radius envelope).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.disk_zero_forces_weighted_tail_escape`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.disk_zero_forces_weighted_tail_escape` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A supplied actual disk zero forces unbounded weighted canonical coefficients in every tail. The radius is strictly larger than the zero modulus; no detection index bound is asserted.

**Theorem 1.4 (Retain the full actual xi zero coordinate).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.xi_zero_forces_weighted_tail_escape`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.xi_zero_forces_weighted_tail_escape` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The same conclusion is stated directly for xiReading and its exact Mobius image. The zero is never replaced by only its imaginary part.

**Theorem 1.5 (An interior zero gives a strict exponential rate).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.disk_zero_forces_exponential_escape`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.disk_zero_forces_exponential_escape` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Choose a radius strictly between the zero modulus and one. At that radius every constant envelope is exceeded arbitrarily far out. Existence of an actual interior zero is not asserted.

**Theorem 1.6 (RH supplies a bound at each smaller radius).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.rh_canonical_weighted_envelopes`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.rh_canonical_weighted_envelopes` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The complete absolute canonical coefficient sum provides a nonnegative bound on every weighted coefficient. The constant may depend on the radius.

**Theorem 1.7 (A larger-radius bound gives smaller-radius summability).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.canonical_smaller_radius_summable`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.canonical_smaller_radius_summable` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The proof retains the exact geometric factor (r/R) to compare the original absolute coefficient series with a convergent majorant.

**Theorem 1.8 (All-radius envelopes are equivalent to RH).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.rh_iff_canonical_weighted_envelopes`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.rh_iff_canonical_weighted_envelopes` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every radius below one there must be a bound for all indices. No radius-independent constant, finite cutoff or unconditional arithmetic bound is supplied.

## References

- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.canonical_smaller_radius_summable`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.canonical_weighted_tail_bound_zero_free`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.disk_zero_forces_exponential_escape`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.disk_zero_forces_weighted_tail_escape`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.rh_canonical_weighted_envelopes`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.rh_iff_canonical_weighted_envelopes`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.scalar_series_analytic_of_eventual_bound`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.xi_zero_forces_weighted_tail_escape`
- Dependency: [D5/S3/Weil/Probability/CanonicalLiDiskEquivalence](CanonicalLiDiskEquivalence.md)
