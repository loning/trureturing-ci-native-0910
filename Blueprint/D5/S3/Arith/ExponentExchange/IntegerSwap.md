# Integer Prime Exponent Exchange

## Abstract

Prime exponent exchange lowers the integer and raises normalized sigma.

**Theorem 1.1 (A smaller integer with a larger normalized divisor sum).**

$$\begin{aligned}\forall m, p, q \in \mathbb{N},\\1 \le m, Prime\left(p\right), Prime\left(q\right), p < q,\\a = v\left(m, p\right), b = v\left(m, q\right), a < b,\\t = div\left(m, p^{a} \cdot q^{b}\right), z = t \cdot p^{b} \cdot q^{a} \Rightarrow\\1 \le t \land gcd\left(t, p \cdot q\right) = 1\\\land m = t \cdot p^{a} \cdot q^{b}\\\land 0 < z < m\\\land \frac{sigma1\left(m\right)}{m} < \frac{sigma1\left(z\right)}{z}.\end{aligned}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/ExponentExchange/IntegerSwap.prime_exponent_swap` (`✓ std3`). ∎

*Citation.* Leonidas Alaoglu and Paul Erdos (1944). *On highly composite and similar numbers*. DOI: [10.2307/1990319](https://doi.org/10.2307/1990319).

*Commentary.*

For every positive natural number m and primes p < q, let a and b be Nat.factorization m evaluated at p and q. Assume a < b, with no positivity assumption on a. In the display, div denotes natural number division, v denotes Nat.factorization, and z is the integer obtained by swapping the two exponents.

The conclusion contains five assertions: the quotient t is at least one; its gcd with pq is one; the original integer has the stated factorization; z is positive and smaller than m; and the normalized divisor sum strictly increases. The symbol sigma1 means ArithmeticFunction.sigma 1, with the final two ratios cast to the real numbers before division.

The construction uses divisibility of both full prime powers and coprimality of distinct primes. Subtracting their factorizations leaves valuation zero at each selected prime, proving the cofactor coprimality needed by sigma multiplicativity. Factoring out the shared powers reduces integer size to p^(b-a) < q^(b-a). The normalized sigma factors are reciprocal geometric sums; the imported strict real exchange inequality is multiplied by the positive common factor sigma1(t)/t.

This is the integer construction underlying the classical prime exponent ordering argument. It establishes neither a record-point theorem nor a hypothesis concerning zeros of the zeta function. Repository and pinned Mathlib searches found the scalar comparison and the arithmetic primitives used here. External Lean ecosystem searches found no matching full exchange declaration in the searched results; no global novelty claim is made.

## References

- Truth anchor: `D5/S3/Arith/ExponentExchange/IntegerSwap.prime_exponent_swap`
- Dependency: [D5/S3/Arith/RobinExponentSwap](../RobinExponentSwap.md)
