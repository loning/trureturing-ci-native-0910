# Prime Padding Ratio

## Abstract

Raising a bounded prime exponent gives an eventual strict relative sigma gain.

**Theorem 1.1 (Local divisor sum comparison).**

Lean statement: `D5/S3/Arith/Robin/PaddingRatio.padding_abundancy`

*Proof.* Machine-checked in Lean as `D5/S3/Arith/Robin/PaddingRatio.padding_abundancy` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For a prime p and natural bound A, padding multiplies n by p to the power A + 1 - factorization(n,p). On the exponent window factorization(n,p) <= A, the result is p^(A+1) times the prime-free complementary factor. Sigma multiplicativity cancels that common factor. The remaining local ratio is at most rho, the reciprocal geometric sum through A divided by the sum through A+1.

**Theorem 1.2 (Eventual strict relative gain).**

Lean statement: `D5/S3/Arith/Robin/PaddingRatio.padding_ratio`

*Proof.* Machine-checked in Lean as `D5/S3/Arith/Robin/PaddingRatio.padding_ratio` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Here robinRatio(n) is sigma_1(n) divided by exp(EulerMascheroniConstant) times n times log(log(n)), and paddingQ(p,A) is (1+rho)/2. The threshold depends on p and A. The theorem quantifies over every natural n above that threshold whose p-adic exponent is at most A.

Mathlib's logarithmic perturbation limit controls the distortion of log(log(n)) under the bounded multiplicative padding. The Euler constant cancels from the relative comparison. This proof uses neither an absolute Robin bound nor a Gronwall envelope. The tail-mass estimate consumes this relative comparison.

## References

- Truth anchor: `D5/S3/Arith/Robin/PaddingRatio.padding_abundancy`
- Truth anchor: `D5/S3/Arith/Robin/PaddingRatio.padding_ratio`
- Dependency: [D5/S3/Arith/RobinExponentSwap](../RobinExponentSwap.md)
