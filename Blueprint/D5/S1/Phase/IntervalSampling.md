# Interval Sampling of Irrational Rotations

## Abstract

Every irrational rotation samples each half-open unit interval with its length as frequency.

**Theorem 1.1 (Sampling frequency for every initial phase).**

$$\lim_{N\to\infty} \frac{\operatorname{card}\{i\in\mathbb{N}\mid i<N, a\leq\operatorname{fract}(\rho+i\alpha)<b\}}{N}=b-a$$

*Proof.* Machine-checked in Lean as `D5/S1/Phase/IntervalSampling.irrational_rotation_interval_sampling` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Let alpha be any irrational real number, rho any real initial phase, and 0 <= a <= b <= 1. Count the natural indices i < N for which a <= Int.fract(rho + i alpha) < b. The count divided by N tends to b - a. This includes a = b, a = 0, and b = 1.

The proof imports continuous_average_tendsto_haar from ContinuousAverage. Normalized finite sums of Dirac measures at the orbit points are probability measures for positive sample sizes. Mathlib's integral criterion turns the imported continuous averages into weak convergence.

The representatives in [0,1) identify the half-open interval with a measurable subset of the circle. Its Haar measure is b - a, and its frontier is contained in the two endpoint classes, each of measure zero. Mathlib's Portmanteau implication gives convergence of interval masses. Evaluating the finite Dirac sum produces exactly Finset.filter.card / N. Using N + 1 during the measure construction avoids a zero normalization; the natural-index shift lemma restores the stated sequence.

proof_shape: bind-only. admission_basis: atom-required-bridge. The common uniform-sampling target of the two preregistered pzg-v170 atoms requires this prerequisite in issue 6057. The added typed edge connects rotation averages from steps 1 and 2 to integer sampling counts. The named consumers are atoms 21b616460d1cbeb9eb537fc7690b238fac8686bf16105e677278cc0928d58d15 and 6b3a506b859ed4693724adaecee87fdcface331a251b9b9e1fd300a50fc2250b; the dependency direction is atom sampling goals -> this theorem -> ContinuousAverage.

This is a classical consequence of weak convergence and Portmanteau, implemented by binding existing Mathlib results to the imported average theorem. No escape witness or mathematical novelty is claimed. This proves the interval-sampling prerequisite of issue 6057; it does not prove the two-dimensional deficit distribution or its three golden-ratio frequencies, and does not assert atom absorption or freezing.

## References

- Truth anchor: `D5/S1/Phase/IntervalSampling.irrational_rotation_interval_sampling`
- Dependency: [D5/S1/Phase/ContinuousAverage](ContinuousAverage.md)
