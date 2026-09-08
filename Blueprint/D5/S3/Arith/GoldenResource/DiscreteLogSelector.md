# Discrete Logarithmic Selector

## Abstract

A strict logarithmic price interval selects one positive integer layer and gives a uniform loss away from it.

For a positive integer n, write g_p(n) for log(n) minus p times n.

**Theorem 1.1 (Unique integer maximizer with an explicit gap).**

$$\forall k \in \mathbb{N}, p \in \mathbb{R},\; \left(2 \le k \land \left(log\left(\frac{k+1}{k}\right) < p \land p < log\left(\frac{k}{k-1}\right)\right)\right) \Rightarrow \left(\forall n \in \mathbb{N},\; 0 < n \Rightarrow \left(g\left(p, n\right) \le g\left(p, k\right) \land \left(n \ne k \Rightarrow min\left(log\left(\frac{k}{k-1}\right) - p, p - log\left(\frac{k+1}{k}\right)\right) \le g\left(p, k\right) - g\left(p, n\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/DiscreteLogSelector.discrete_log_unique_maximum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The adjacent difference is log((n+1)/n) minus p. These margins decrease with n; induction in both directions telescopes the adjacent inequalities over the entire positive integer ray. The endpoint inequalities are strict, so the stated minimum of the two endpoint margins is positive.

## References

- Truth anchor: `D5/S3/Arith/GoldenResource/DiscreteLogSelector.discrete_log_unique_maximum`
