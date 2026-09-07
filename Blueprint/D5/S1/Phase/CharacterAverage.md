# Character Averages of Irrational Rotations

## Abstract

Every nonzero character of an irrational rotation has average zero at each initial phase.

**Lemma 1.1 (A bound independent of phase and sample size).**

$$\forall \alpha\in\mathbb{R}\setminus\mathbb{Q}, \rho\in\mathbb{R}, m\in\mathbb{Z}\setminus\{0\}, \forall N\in\mathbb{N}, \left\lVert \sum_{0\leq j<N} \exp(2\pi I m (\rho+j\alpha)) \right\rVert\leq\frac{2}{\left\lVert \exp(2\pi I m \alpha)-1 \right\rVert}$$

*Proof.* Machine-checked in Lean as `D5/S1/Phase/CharacterAverage.norm_character_sum_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Let alpha be irrational, rho any real initial phase, m a nonzero integer, and N a natural number. The character sum has norm at most 2 / |exp(2 pi i m alpha) - 1|, including when N is zero.

If the rotation step were one, periodicity of the complex exponential would make m alpha an integer, contradicting irrationality. Each term factors into the initial phase, of norm one, and a power of this step. The finite geometric-sum identity and the triangle inequality give the stated bound.

**Theorem 1.2 (Vanishing average at every specified initial phase).**

$$\forall \alpha\in\mathbb{R}\setminus\mathbb{Q}, \rho\in\mathbb{R}, m\in\mathbb{Z}\setminus\{0\}, \lim_{N\to\infty} \frac{\sum_{0\leq j<N} \exp(2\pi I m (\rho+j\alpha))}{N}=0$$

*Proof.* Machine-checked in Lean as `D5/S1/Phase/CharacterAverage.character_average_tendsto_zero` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Divide the preceding bound by N. The resulting upper bound tends to zero, so the complex average tends to zero by the norm squeeze theorem. Lean's total division assigns value zero to the average at N = 0; this value does not affect the limit.

This is the elementary character-average step of issue 6057. The formal derivation uses finite geometric sums and irrationality. The result is classical; repository provenance describes the formal derivation and makes no claim of mathematical novelty.

Interval sampling limits, approximation of observables, and equidistribution are outside this statement. The zero character is excluded by the hypothesis on m.

## References

- Truth anchor: `D5/S1/Phase/CharacterAverage.character_average_tendsto_zero`
- Truth anchor: `D5/S1/Phase/CharacterAverage.norm_character_sum_le`
