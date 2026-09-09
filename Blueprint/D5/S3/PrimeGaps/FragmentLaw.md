# Weighted Poisson Fragment Law

## Abstract

A provenance-preserving port constructs the actual weighted Poisson fragment law and proves its first moment and small-fragment tail.

The Lean source is adapted from openai/PrimeGaps186, commit 61340d0b74163003b32756bb16e91d9209a5e330, under its Apache-2.0 provenance. The first-moment construction is an upstream proof port. It does not certify any of the original numerical integral cells.

**Definition 1.1 (Location-weighted empirical measure).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.weightedEmpirical`

*Formalization.* `D5/S3/PrimeGaps/FragmentLaw.weightedEmpirical` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Each sampled location contributes its nonnegative part as the weight of a Dirac atom.

**Definition 1.2 (Poisson counts and sampled locations).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.finitePoissonLaw`

*Formalization.* `D5/S3/PrimeGaps/FragmentLaw.finitePoissonLaw` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A Poisson count and independent normalized locations are pushed forward to a finite weighted measure.

**Definition 1.3 (Finite dyadic intensity).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.cappedDyadicIntensity`

*Formalization.* `D5/S3/PrimeGaps/FragmentLaw.cappedDyadicIntensity` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Restrict the reciprocal-location density to one dyadic interval and to the positive cutoff interval. Each band has finite intensity.

**Definition 1.4 (Finite realization of the band sum).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.finiteFragments`

*Formalization.* `D5/S3/PrimeGaps/FragmentLaw.finiteFragments` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The total measure is used when finite; the definition has a zero fallback. A subsequent theorem proves that fallback is almost surely unused.

**Definition 1.5 (Law of the complete fragment measure).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.fragmentLaw`

*Formalization.* `D5/S3/PrimeGaps/FragmentLaw.fragmentLaw` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Push forward the independent band laws through the finite-fragment map.

**Theorem 1.6 (Underlying measure of the empirical sum).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.coe_weightedEmpirical`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.coe_weightedEmpirical` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The finite-measure construction agrees exactly with the corresponding weighted Dirac sum.

**Theorem 1.7 (Measurability at fixed sample size).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.measurable_weightedEmpirical`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.measurable_weightedEmpirical` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Measurability is proved by evaluating the underlying measure on measurable sets.

**Theorem 1.8 (Measurability with random sample size).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.measurable_weightedEmpirical_sample`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.measurable_weightedEmpirical_sample` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The variable-size sample map is measurable on the countable count coordinate and infinite location sequence.

**Theorem 1.9 (Recover a measure from its normalization).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.coe_eq_mass_smul_normalize`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.coe_eq_mass_smul_normalize` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The existing finite-measure normalization identity is transported to the underlying measure.

**Theorem 1.10 (Integrate over count and locations).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.lintegral_finitePoissonLaw_normalized`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.lintegral_finitePoissonLaw_normalized` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A measurable nonnegative observable of the Poisson measure is integrated by first conditioning on the count and then using its finite product law.

**Theorem 1.11 (Fixed-count first moment).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.lintegral_weightedEmpirical_pi`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.lintegral_weightedEmpirical_pi` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Linearity and identical coordinate marginals give the count times the one-location weighted integral.

**Theorem 1.12 (Poisson mass recurrence).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.poisson_singleton_succ`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.poisson_singleton_succ` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The successor factorial identity supplies the exact recurrence used to sum the Poisson expectation.

**Theorem 1.13 (Expected Poisson count).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.lintegral_poisson_id`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.lintegral_poisson_id` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The nonnegative integral of the count equals its intensity parameter.

**Theorem 1.14 (First moment of a finite Poisson band).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.lintegral_weighted_finitePoissonLaw`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.lintegral_weighted_finitePoissonLaw` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Combining normalized sampling with the Poisson expectation recovers the location-weighted intensity integral.

**Theorem 1.15 (Each band law is a probability measure).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.finitePoissonLaw_isProbabilityMeasure`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.finitePoissonLaw_isProbabilityMeasure` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The measurable pushforward of the product probability law has total mass one.

**Theorem 1.16 (Measurability of the countable measure sum).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.measurable_fragment_sum`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.measurable_fragment_sum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Evaluating the sum on a measurable set is a measurable countable sum.

**Theorem 1.17 (Measurability of the finite realization).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.measurable_finiteFragments`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.measurable_finiteFragments` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The finite-measure branch and zero fallback combine over a measurable finiteness predicate.

**Theorem 1.18 (Dyadic bands are pairwise disjoint).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.dyadic_bands_disjoint`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.dyadic_bands_disjoint` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The half-open convention assigns each positive boundary to exactly one band.

**Theorem 1.19 (Dyadic bands cover the positive line).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.iUnion_dyadic_bands`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.iUnion_dyadic_bands` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Every strictly positive location lies in a dyadic band indexed by an integer.

**Theorem 1.20 (Reassemble the original intensity).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.sum_cappedDyadicIntensity`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.sum_cappedDyadicIntensity` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The disjoint restrictions sum to the reciprocal-location intensity on the cutoff interval.

**Theorem 1.21 (First moment before imposing finiteness).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.lintegral_fragment_sum`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.lintegral_fragment_sum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Nonnegative integration exchanges the band sum and expectation. Multiplication by the location cancels the reciprocal-location density.

**Theorem 1.22 (The total fragment mass is almost surely finite).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.ae_isFiniteMeasure_fragment_sum`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.ae_isFiniteMeasure_fragment_sum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The first moment of total mass is finite, so the countable measure sum is finite almost surely. The conclusion is proved before using the finite-measure fallback.

**Theorem 1.23 (The fragment law is a probability measure).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.fragmentLaw_isProbabilityMeasure`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.fragmentLaw_isProbabilityMeasure` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The completed measurable pushforward is a probability measure for every real cutoff.

**Theorem 1.24 (First moment on the actual fragment law).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.lintegral_fragmentLaw`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.lintegral_fragmentLaw` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every measurable nonnegative test, the expected fragment integral equals its Lebesgue integral over the cutoff interval.

**Theorem 1.25 (Tail probability of deleted small-fragment mass).**

Lean statement: `D5/S3/PrimeGaps/FragmentLaw.fragmentLaw_small_seed_tail`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentLaw.fragmentLaw_small_seed_tail` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For a positive cutoff and threshold and a nonnegative deletion scale, Markov's inequality bounds the deletion event by the minimum of the two cutoffs divided by the threshold. This leaves discontinuous mesh-boundary effects for the next module.

## References

- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.ae_isFiniteMeasure_fragment_sum`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.cappedDyadicIntensity`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.coe_eq_mass_smul_normalize`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.coe_weightedEmpirical`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.dyadic_bands_disjoint`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.finiteFragments`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.finitePoissonLaw`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.finitePoissonLaw_isProbabilityMeasure`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.fragmentLaw`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.fragmentLaw_isProbabilityMeasure`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.fragmentLaw_small_seed_tail`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.iUnion_dyadic_bands`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.lintegral_finitePoissonLaw_normalized`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.lintegral_fragmentLaw`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.lintegral_fragment_sum`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.lintegral_poisson_id`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.lintegral_weightedEmpirical_pi`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.lintegral_weighted_finitePoissonLaw`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.measurable_finiteFragments`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.measurable_fragment_sum`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.measurable_weightedEmpirical`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.measurable_weightedEmpirical_sample`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.poisson_singleton_succ`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.sum_cappedDyadicIntensity`
- Truth anchor: `D5/S3/PrimeGaps/FragmentLaw.weightedEmpirical`
