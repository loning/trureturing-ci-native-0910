# Gronwall Envelopes

## Abstract

Powers of primorials attain the sharp lower Gronwall envelope, and the logarithmic Robin margin has lower limit zero.

**Theorem 1.1 (Arbitrarily Large Near-Maximal Divisor Sums).**

Lean statement: `D5/S3/Weil/GronwallLowerEnvelope.gronwall_lower_envelope`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/GronwallLowerEnvelope.gronwall_lower_envelope` (`✓ std3`). ∎

*Citation.* T. H. Gronwall (1913). *Some asymptotic expressions in the theory of numbers*. DOI: [10.1090/s0002-9947-1913-1500940-6](https://doi.org/10.1090/s0002-9947-1913-1500940-6).

*Commentary.*

For every positive epsilon and every natural threshold, a power of a primorial reaches the normalized level one minus epsilon above that threshold. A geometric factor controls the reciprocal prime-power error uniformly. The denominator uses the Chebyshev upper bound, and the leading constant comes from Mertens' third theorem.

**Theorem 1.2 (The Two Sharp Envelopes).**

Lean statement: `D5/S3/Weil/GronwallLowerEnvelope.gronwall_envelopes`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/GronwallLowerEnvelope.gronwall_envelopes` (`✓ std3`). ∎

*Citation.* T. H. Gronwall (1913). *Some asymptotic expressions in the theory of numbers*. DOI: [10.1090/s0002-9947-1913-1500940-6](https://doi.org/10.1090/s0002-9947-1913-1500940-6).

*Commentary.*

The existing eventual upper envelope and the arbitrarily large lower witnesses are packaged with the same positive epsilon. These are the two epsilon conditions for the normalized Gronwall limsup to equal one.

**Theorem 1.3 (The Logarithmic Robin Margin Has Lower Limit Zero).**

Lean statement: `D5/S3/Weil/GronwallLowerEnvelope.robin_log_margin_liminf`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/GronwallLowerEnvelope.robin_log_margin_liminf` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The margin is gamma plus log log log n minus log(sigma(n)/n). For n at least 5041 it equals the negative logarithm of the normalized Robin ratio. The eventual upper Gronwall envelope gives lower limit at least zero; the arbitrarily late lower witnesses give lower limit at most zero. This companion corollary is unconditional and asserts no Robin criterion equivalent to the Riemann hypothesis.

## References

- Truth anchor: `D5/S3/Weil/GronwallLowerEnvelope.gronwall_envelopes`
- Truth anchor: `D5/S3/Weil/GronwallLowerEnvelope.gronwall_lower_envelope`
- Truth anchor: `D5/S3/Weil/GronwallLowerEnvelope.robin_log_margin_liminf`
- Dependency: [D5/S3/Arith/Robin/PaddingRatio](../Arith/Robin/PaddingRatio.md)
