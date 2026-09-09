# Fixed Prime Valuation Gap

## Abstract

Bounded valuations at a fixed prime leave a positive asymptotic Robin margin.

**Theorem 1.1 (Exact prime layer gain).**

Lean statement: `D5/S3/Weil/PrimeValuationGap.prime_power_abundancy_ratio`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/PrimeValuationGap.prime_power_abundancy_ratio` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For a prime p, a nonzero natural n, and a natural b, let a be the p-adic valuation of n. The ratio of the abundancy of p^b n to that of n is (1-p^(-(a+b+1)))/(1-p^(-(a+1))). Multiplicativity cancels the common factor coprime to p.

**Theorem 1.2 (Uniform gain on an exponent window).**

Lean statement: `D5/S3/Weil/PrimeValuationGap.prime_power_abundancy_gain`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/PrimeValuationGap.prime_power_abundancy_gain` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

When a is at most A, the gain is bounded below by (1-p^(-(A+b+1)))/(1-p^(-(A+1))). The comparison follows from the nonnegativity of (p^(-(a+1))-p^(-(A+1)))(1-p^(-b)).

**Theorem 1.3 (Positive logarithmic defect).**

Lean statement: `D5/S3/Weil/PrimeValuationGap.prime_valuation_gap_pos`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/PrimeValuationGap.prime_valuation_gap_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every fixed prime p and natural A, the number -log(1-p^(-(A+1))) is strictly positive. The number depends on p and A.

**Theorem 1.4 (Sharp asymptotic ratio bound).**

Lean statement: `D5/S3/Weil/PrimeValuationGap.bounded_prime_valuation_robin_ratio`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/PrimeValuationGap.bounded_prime_valuation_robin_ratio` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every positive epsilon there is a threshold N at least 5041 such that every n at least N with valuation at most A has Robin ratio at most 1-p^(-(A+1))+epsilon. A fixed layer count b is selected using geometric decay; the threshold is then obtained for that b from the Gronwall upper envelope and the logarithmic scale limit.

**Theorem 1.5 (Asymptotic Robin margin).**

Lean statement: `D5/S3/Weil/PrimeValuationGap.bounded_prime_valuation_robin_margin_gap`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/PrimeValuationGap.bounded_prime_valuation_robin_margin_gap` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every positive epsilon, all sufficiently large integers with p-adic valuation at most A have logarithmic Robin margin at least -log(1-p^(-(A+1)))-epsilon. The threshold includes the Robin domain n at least 5041. The conclusion is unconditional and does not specify a numerical threshold.

## References

- Truth anchor: `D5/S3/Weil/PrimeValuationGap.bounded_prime_valuation_robin_margin_gap`
- Truth anchor: `D5/S3/Weil/PrimeValuationGap.bounded_prime_valuation_robin_ratio`
- Truth anchor: `D5/S3/Weil/PrimeValuationGap.prime_power_abundancy_gain`
- Truth anchor: `D5/S3/Weil/PrimeValuationGap.prime_power_abundancy_ratio`
- Truth anchor: `D5/S3/Weil/PrimeValuationGap.prime_valuation_gap_pos`
- Dependency: [D5/S3/Weil/GronwallLowerEnvelope](GronwallLowerEnvelope.md)
