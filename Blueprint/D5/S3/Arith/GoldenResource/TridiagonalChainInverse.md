# Tridiagonal Chain Inverse

## Abstract

The diagonal-four chain is uniformly positive with exponentially small endpoint transfer.

Let d(0)=1, d(1)=4, and d(n+2)=4d(n+1)-d(n). The index n ranges over all natural numbers. H(m) is the real m by m matrix with diagonal four, adjacent entries minus one, and all other entries zero. In matrix entries, i and j range from zero through m-1. Write E(n,x) for x transpose H(n+1)x, V(n,x) for the sum of all coordinate squares, and A(n,x) for the sum of squared differences of adjacent coordinates. The coordinates of x are indexed from zero through n. Let v(n) have coordinate i equal to d(n-i), let e(0) be the first unit vector, and let w(n) be H(n+1) inverse times e(0). Write w(n,i) for coordinate i, where zero is less than or equal to i and i is less than or equal to n. Square brackets around a proposition denote one when true and zero otherwise.

**Theorem 1.1 (The tridiagonal entries).**

$$H\left(m, i, j\right) = 4\cdot [i = j]-[i+1 = j]-[j+1 = i]$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_apply` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The diagonal has value four. Exactly one adjacent indicator is one for neighbours, and both are zero otherwise.

**Theorem 1.2 (Positive denominators).**

$$0 < d\left(n\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chainDet_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Simultaneous induction proves positivity and d(n+1) greater than or equal to three times d(n).

**Theorem 1.3 (Geometric growth).**

$$3^{n} \le d\left(n\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chainDet_ge_three_pow` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Iterate the factor-three bound from d(0)=1.

**Theorem 1.4 (Squared denominators).**

$$9^{n} \le d\left(n\right)^{2}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chainDet_sq_ge_nine_pow` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Both sides of the factor-three estimate are nonnegative. Squaring gives the factor-nine estimate.

**Theorem 1.5 (The energy identity).**

$$E\left(n, x\right) = 2\cdot V\left(n, x\right)+x\left(0\right)^{2}+x\left(n\right)^{2}+A\left(n, x\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_energy` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Expand each adjacent difference and sum. Each interior coordinate occurs twice among the edges, and each endpoint once. For n=0, the endpoint terms coincide and the edge sum is empty.

**Theorem 1.6 (A uniform lower bound).**

$$2\cdot V\left(n, x\right) \le E\left(n, x\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_coercive` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

All boundary and edge squares are nonnegative.

**Theorem 1.7 (Positive definiteness).**

$$PosDef\left(H\left(m\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_posDef` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The matrix is symmetric. For a nonzero vector, the sum of coordinate squares is strictly positive, so the uniform lower bound proves positive definiteness. The empty matrix also satisfies the definition.

**Theorem 1.8 (Multiplication by the reversed recurrence).**

$$H\left(n+1\right)\cdot v\left(n\right) = d\left(n+1\right)\cdot e\left(0\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_inv_column` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The first row gives d(n+1). Each interior row vanishes by the recurrence. The last row vanishes since four times d(0) equals d(1). For a single coordinate the product is simply four.

**Theorem 1.9 (The first inverse column).**

$$w\left(n, i\right) = \frac{d\left(n-i\right)}{d\left(n+1\right)}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_inverse_column` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Positive definiteness makes H invertible. Divide the identity by the positive denominator and apply the inverse.

**Theorem 1.10 (Endpoint transfer).**

$$w\left(n, n\right) = \frac{1}{d\left(n+1\right)}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_endpoint_transfer` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The last coordinate has numerator d(0)=1.

**Theorem 1.11 (Exponential decay).**

$$w\left(n, n\right)^{2} \le \frac{1}{9^{n+1}}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_endpoint_sq_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Taking reciprocals of the positive squared-denominator estimate gives the endpoint bound.

## References

- Truth anchor: `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chainDet_ge_three_pow`
- Truth anchor: `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chainDet_pos`
- Truth anchor: `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chainDet_sq_ge_nine_pow`
- Truth anchor: `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_apply`
- Truth anchor: `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_coercive`
- Truth anchor: `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_endpoint_sq_le`
- Truth anchor: `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_endpoint_transfer`
- Truth anchor: `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_energy`
- Truth anchor: `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_inv_column`
- Truth anchor: `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_inverse_column`
- Truth anchor: `D5/S3/Arith/GoldenResource/TridiagonalChainInverse.chain_posDef`
