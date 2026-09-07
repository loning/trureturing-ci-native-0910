# Eventual Uniform Negativity of the Actual Gram

## Abstract

The actual full Gram has a coefficient-uniform remainder and retains a fixed negative margin and exact inertia at every sufficiently large common depth.

**Theorem 1.1 (The full matrix inherits the derived remainder).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilFullGramUniformRemainder.burnol_actual_gram_uniform_remainder`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilFullGramUniformRemainder.burnol_actual_gram_uniform_remainder` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the existing exact full-Gram quadratic identity and the common Burnol remainder. C is the absolutely summed mixed majorant of the fixed killer family; every cross term is retained.

**Theorem 1.2 (One threshold for every coefficient and all later depths).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilFullGramUniformRemainder.eventually_burnolGram_uniform_negative_margin`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilFullGramUniformRemainder.eventually_burnolGram_uniform_negative_margin` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Geometric error convergence supplies the common threshold. Positivity of each analytic multiplicity supplies the weight floor one. The quantifiers are uniform over all coefficient vectors and all depths beyond the threshold.

**Theorem 1.3 (Exact spectral inertia throughout the tail).**

Lean statement: `D5/S3/Weil/ZetaBridge/WeilFullGramUniformRemainder.eventually_burnolGram_exact_negative_inertia`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/WeilFullGramUniformRemainder.eventually_burnolGram_exact_negative_inertia` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Positive coefficient energy turns the uniform margin into strict negativity. The existing full-Gram inertia theorem supplies the spectral index. A valid finite off-line frame remains an input; its existence and a computable conditioning bound are not asserted.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilFullGramUniformRemainder.burnol_actual_gram_uniform_remainder`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilFullGramUniformRemainder.eventually_burnolGram_exact_negative_inertia`
- Truth anchor: `D5/S3/Weil/ZetaBridge/WeilFullGramUniformRemainder.eventually_burnolGram_uniform_negative_margin`
- Dependency: [D5/S3/Weil/ZetaBridge/WeilFullGramInertia](WeilFullGramInertia.md)
