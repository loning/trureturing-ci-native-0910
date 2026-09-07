# Concavity of the Cubic Three-Halves Profile

## Abstract

The unnormalized cubic three-halves profile is concave on the full open unit interval.

**Theorem 1.1 (The cubic profile is concave).**

Lean statement: `D5/S3/Analytic/SeriesInequalities/Profile32Calculus.profile32_concave`

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/SeriesInequalities/Profile32Calculus.profile32_concave` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For the cubic x^3 - 3x + 2t, sum the three-halves powers of the absolute inverse-gap scores over its distinct real roots, and raise this sum to negative four thirds. This function of t is concave for every -1 < t < 1.

An increasing explicit chart maps the whole open unit interval onto itself. On its positive half, the exact radical certificate makes the derivative of the profile slope strictly negative.

The chart profile is continuously differentiable at zero. Continuity extends the slope comparison to zero, and evenness of the profile makes its slope odd, giving antitonicity across both halves. Cauchy's mean value theorem then compares adjacent secant slopes, which implies concavity.

The proof assumes no second derivative at the zero score and imposes no minimum root gap. It concerns only this explicit one-parameter cubic family.

**Theorem 1.2 (The profile is even on its domain).**

Lean statement: `D5/S3/Analytic/SeriesInequalities/Profile32Calculus.profile32_even`

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/SeriesInequalities/Profile32Calculus.profile32_even` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The chart is odd and the transformed profile is even, so reflection preserves the original profile throughout the open unit interval.

## References

- Truth anchor: `D5/S3/Analytic/SeriesInequalities/Profile32Calculus.profile32_concave`
- Truth anchor: `D5/S3/Analytic/SeriesInequalities/Profile32Calculus.profile32_even`
- Dependency: [D5/S3/Analytic/SeriesInequalities/Profile32Concavity](Profile32Concavity.md)
