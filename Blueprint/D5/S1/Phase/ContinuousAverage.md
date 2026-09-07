# Continuous Averages of Irrational Rotations

## Abstract

Continuous observables of an irrational rotation have normalized Haar average at every phase.

**Theorem 1.1 (Convergence for every continuous observable and every initial phase).**

$$\lim_{N\to\infty} \frac{\sum_{0\leq i<N} f([\rho+i\alpha])}{N}=\int f d\mu_{Haar}$$

*Proof.* Machine-checked in Lean as `D5/S1/Phase/ContinuousAverage.continuous_average_tendsto_haar` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Let alpha be irrational, rho any real initial phase, and f any continuous complex-valued function on the additive circle R/Z. Its averages along rho + i alpha converge to its integral against AddCircle.haarAddCircle, the Haar measure normalized to have total mass one.

The averaging maps are complex linear and their norms are at most one, uniformly in the sample size and initial phase. The integral functional is also Lipschitz with constant one. Consequently the observables with the asserted limit form a closed complex subspace.

The zero Fourier character has average one for positive sample size. For every nonzero character the imported CharacterAverage theorem gives limit zero, which equals its Haar integral. Thus the closed subspace contains the Fourier span. Mathlib's span_fourier_closure_eq_top then puts every continuous observable in that subspace.

This is step 2 of issue 6057. No restriction is imposed on rho. Total division gives average zero at sample size zero, which does not affect the limit. The theorem is stated as convergence of continuous-observable averages; it does not construct a ProbabilityMeasure sequence or prove interval-indicator sampling limits or the remaining prerequisites of issue 6057.

This is a classical consequence of character cancellation and Fourier density. Repository provenance records this formal derivation, not a claim of mathematical novelty. Searches of pinned Mathlib v4.33.0 and the Lean ecosystem found no usable exact theorem; the retrieved external WeylEquidistribution.lean candidate has unfinished proofs.

## References

- Truth anchor: `D5/S1/Phase/ContinuousAverage.continuous_average_tendsto_haar`
- Dependency: [D5/S1/Phase/CharacterAverage](CharacterAverage.md)
