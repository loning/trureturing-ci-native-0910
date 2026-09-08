# Recursive Modular Zeros and Powers of Two

## Abstract

A coprime modular accumulator reaches zero exactly when its modulus is a power of two.

**Definition 1.1 (The modular accumulator).**

$$\forall i \in \mathbb{N}, j \in \mathbb{N}, t \in \mathbb{N},\; S\left(i, j, 0\right) = i \land S\left(i, j, t + 1\right) = S\left(i, j, t\right) + (S\left(i, j, t\right) \bmod j).$$

*Formalization.* `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.S` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For natural numbers i and j, define S(i,j,0) = i and S(i,j,t+1) = S(i,j,t) + (S(i,j,t) mod j).

**Definition 1.2 (The modular sequence).**

$$\forall i \in \mathbb{N}, j \in \mathbb{N}, t \in \mathbb{N},\; b\left(i, j, t\right) = S\left(i, j, t\right) \bmod j.$$

*Formalization.* `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.b` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Set b(i,j,t) = S(i,j,t) mod j. The index is zero-based: t = 0 is the source value b(i,j,1), so t corresponds to the source time minus one.

**Theorem 1.3 (The doubling identity).**

$$\forall i \in \mathbb{N}, j \in \mathbb{N}, t \in \mathbb{N},\; S\left(i, j, t\right) \bmod j = (2^{t} \cdot i) \bmod j.$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.doubling_identity` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every t, the accumulator satisfies S(i,j,t) mod j = (2^t i) mod j. This follows by induction: the recurrence replaces the residue by twice the preceding residue modulo j.

**Theorem 1.4 (A power-of-two modulus gives a zero).**

$$\forall i \in \mathbb{N}, j \in \mathbb{N}, m \in \mathbb{N},\; j = 2^{m} \Rightarrow \left(\exists t \in \mathbb{N},\; b\left(i, j, t\right) = 0\right).$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.exists_zero_of_eq_pow_two` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

If j = 2^m, choose the zero-based time t = m. The doubling identity then gives b(i,j,m) = (2^m i) mod 2^m = 0.

**Theorem 1.5 (A zero forces a power-of-two modulus).**

$$\forall i \in \mathbb{N}, j \in \mathbb{N},\; \left(0 < i \land \left(1 \le j \land \left(j \le i \land \left(Coprime\left(i, j\right) \land \left(\exists t \in \mathbb{N},\; b\left(i, j, t\right) = 0\right)\right)\right)\right)\right) \Rightarrow \left(\exists m \in \mathbb{N},\; j = 2^{m}\right).$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.eq_pow_two_of_exists_zero` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For a positive i and a coprime pair (i,j), if some b(i,j,t) is zero, the doubling identity gives j dividing 2^t i. Coprimality cancels i, so j divides 2^t; the prime-power divisor characterization yields j = 2^m for some m.

**Theorem 1.6 (Zeros and powers of two are equivalent).**

$$\forall i \in \mathbb{N}, j \in \mathbb{N},\; \left(0 < i \land \left(1 \le j \land \left(j \le i \land Coprime\left(i, j\right)\right)\right)\right) \Rightarrow \left(\left(\exists t \in \mathbb{N},\; b\left(i, j, t\right) = 0\right) \Leftrightarrow \left(\exists m \in \mathbb{N},\; j = 2^{m}\right)\right).$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.zero_iff_power_of_two` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For i >= 1, 1 <= j <= i, and gcd(i,j) = 1, the existence of a zero in the zero-based sequence is equivalent to j being a power of two. Translating t back by one gives the stated one-based source quantifier.

## References

- Truth anchor: `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.S`
- Truth anchor: `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.b`
- Truth anchor: `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.doubling_identity`
- Truth anchor: `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.eq_pow_two_of_exists_zero`
- Truth anchor: `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.exists_zero_of_eq_pow_two`
- Truth anchor: `D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.zero_iff_power_of_two`
