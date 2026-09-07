# Two-adic Depth Forces Prime Support

## Abstract

Two-adic depth in a colossally abundant integer forces prime divisibility under an explicit logarithmic inequality.

**Theorem 1.1 (A sufficient condition for prime divisibility).**

$$\forall N \in \mathbb{N}, p \in \mathbb{N}, k \in \mathbb{N},\; \left(1 \le N \land \left(IsColossallyAbundant\left(N\right) \land \left(Prime\left(p\right) \land \left(k \le factorization\left(N, 2\right) \land (p + 1) log\left(p\right) \le (2^{k + 1} - 2) log\left(2\right)\right)\right)\right)\right) \Rightarrow Dvd\left(p, N\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDepthForcesPrimeSupport.prime_dvd_of_two_adic_depth` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The integer N is positive and globally optimal at some positive resource price. The displayed inequality already forces k to be at least one, because its right side is zero at k equal to zero. The adopted layer at two bounds the price above. Strict reciprocal logarithm estimates place that price below the first-layer marginal at p, even when the displayed inequality is an equality. The frozen threshold criterion therefore excludes p from being an unadopted prime.

## References

- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDepthForcesPrimeSupport.prime_dvd_of_two_adic_depth`
- Dependency: [D5/S3/Arith/GoldenResource/GoldenResourcePriceInterval](GoldenResourcePriceInterval.md)
