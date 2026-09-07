# Cofinal Divisibility Ladder

## Abstract

One explicit cutoff bounds both prime indices and valuations in the Fibonacci prime-power divisibility ladder.

All indices and products are natural-valued. Write p(j) for Nat.nth Nat.Prime j, S(n) for n.factorization.support, c(p) for Nat.count Nat.Prime p, and v(n,p) for n.factorization p. The finite maximum over an empty support is zero. The following M and K are local notation, not new global definitions.

$\operatorname{M}\left(k\right) = \prod_{j < k} \operatorname{p}\left(j\right)^{\operatorname{fib}\left(k + 2\right) - 1}$

$\operatorname{K}\left(n\right) = \operatorname{max}\left(3, 1 + \max_{p \in \operatorname{S}\left(n\right)} \operatorname{max}\left(\operatorname{c}\left(p\right), \operatorname{v}\left(n, p\right)\right)\right)$

**Theorem 1.1 (Joint cutoff and successive divisibility).**

$$\forall n \in \mathbb{N},\; 1 \le n \Rightarrow \left(\left(\forall k \in \mathbb{N},\; \operatorname{K}\left(n\right) \le k \Rightarrow n \mid \operatorname{M}\left(k\right)\right) \land \left(\forall k \in \mathbb{N},\; \operatorname{M}\left(k\right) \mid \operatorname{M}\left(k + 1\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/DivisorGibbs/CofinalDivisibility.cofinal_divisibility_ladder` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The named cutoff_dvd construction uses the support supremum twice: c(p) is strictly below k, and v(n,p) is at most fib(k+2)-1. The latter uses k at least three and the library bound k+2 at most fib(k+2). Nat.nth_count locates p in the product; its single summand bounds the product valuation from below. Nat.factorization_le_iff_dvd turns these comparisons into divisibility.

The step_dvd construction uses Fibonacci monotonicity on the old prime factors, then appends the next prime factor. It covers every natural k, including zero. The cutoff clause also covers n=1, whose support is empty. No infinite-sum convergence theorem is asserted here.

## References

- Truth anchor: `D5/S3/Arith/DivisorGibbs/CofinalDivisibility.cofinal_divisibility_ladder`
