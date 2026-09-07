# Jordan-Cototient Records Near Zero

## Abstract

Small-parameter Jordan-cototient records are 1, 2, 4, and non-prime-powers.

**Lemma 1.1 (The derivative for at least two distinct prime factors).**

$$\forall n \in \mathbb{N},\; 1 \le n \Rightarrow \left(2 \le \operatorname{card}\left(\operatorname{primeFactors}\left(n\right)\right) \Rightarrow \operatorname{HasDerivAt}\left((k: \mathbb{R} \mapsto \operatorname{CoJ}\left(k, n\right)), \operatorname{log}\left(\operatorname{val}\left(n\right)\right), 0\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/JordanCototientRecordLimitZero.hasDerivAt_CoJ_of_two_le_card` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every positive natural n with at least two distinct prime factors, the real function k mapping to CoJ(k,n) has derivative log(val(n)) at zero. Here val is the coercion from naturals to reals. The proof uses two zero factors in the finite prime-factor product, forcing the derivative of the Jordan-totient term to vanish.

**Lemma 1.2 (The derivative for a singleton prime-factor set).**

$$\forall n \in \mathbb{N}, p \in \mathbb{N},\; 1 \le n \Rightarrow \left(\operatorname{primeFactors}\left(n\right) = \left\{p\right\} \Rightarrow \operatorname{HasDerivAt}\left((k: \mathbb{R} \mapsto \operatorname{CoJ}\left(k, n\right)), \operatorname{log}\left(\operatorname{val}\left(n\right)\right) - \operatorname{log}\left(\operatorname{val}\left(p\right)\right), 0\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/JordanCototientRecordLimitZero.hasDerivAt_CoJ_of_primeFactors_eq_singleton` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

If the prime-factor set of a positive natural n is the singleton p, then k mapping to CoJ(k,n) has derivative log(val(n))-log(val(p)) at zero. This is the prime-power derivative log(n/p) written without introducing field division into the Lean statement.

**Theorem 1.3 (Inputs with two prime factors are eventual records).**

$$\forall n \in \mathbb{N},\; 1 \le n \Rightarrow \left(2 \le \operatorname{card}\left(\operatorname{primeFactors}\left(n\right)\right) \Rightarrow \left(\exists epsilon \in \mathbb{R},\; 0 < epsilon \land \left(\forall k \in \mathbb{R},\; 0 < k \Rightarrow \left(k < epsilon \Rightarrow \operatorname{StrictRecord}\left(k, n\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/JordanCototientRecordLimitZero.eventual_record_of_two_le_primeFactors_card` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For each positive natural n having at least two distinct prime factors, there is a positive real epsilon such that n is a strict record for every real k with 0<k<epsilon. Every predecessor gives a strict derivative gap at zero; finite intersection over the predecessor interval supplies one epsilon for this fixed n.

**Lemma 1.4 (One is an eventual record).**

$$\exists epsilon \in \mathbb{R},\; 0 < epsilon \land \left(\forall k \in \mathbb{R},\; 0 < k \Rightarrow \left(k < epsilon \Rightarrow \operatorname{StrictRecord}\left(k, 1\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/JordanCototientRecordLimitZero.eventual_record_one` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

One is a strict record for every parameter because it has no positive predecessor. The stated positive epsilon is therefore immediate. This bind-only companion feeds the exceptional-value branch of the final characterization.

**Lemma 1.5 (Two is an eventual record).**

$$\exists epsilon \in \mathbb{R},\; 0 < epsilon \land \left(\forall k \in \mathbb{R},\; 0 < k \Rightarrow \left(k < epsilon \Rightarrow \operatorname{StrictRecord}\left(k, 2\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/JordanCototientRecordLimitZero.eventual_record_two` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Two is a strict record because the sibling module gives CoJ(k,1)=0 and CoJ(k,2)=1 for every real k. This bind-only companion supplies the second exceptional-value branch of the final characterization.

**Lemma 1.6 (Four is an eventual record).**

$$\exists epsilon \in \mathbb{R},\; 0 < epsilon \land \left(\forall k \in \mathbb{R},\; 0 < k \Rightarrow \left(k < epsilon \Rightarrow \operatorname{StrictRecord}\left(k, 4\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/JordanCototientRecordLimitZero.eventual_record_four` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For positive k, CoJ(k,4)=2^k is strictly larger than the value one at the prime predecessors two and three, and larger than the value zero at one. This companion supplies the third exceptional-value branch.

**Theorem 1.7 (Odd prime powers are excluded).**

$$\forall p \in \mathbb{N}, a \in \mathbb{N},\; \operatorname{Prime}\left(p\right) \Rightarrow \left(\operatorname{Odd}\left(p\right) \Rightarrow \left(0 < a \Rightarrow \left(\neg \left(\exists epsilon \in \mathbb{R},\; 0 < epsilon \land \left(\forall k \in \mathbb{R},\; 0 < k \Rightarrow \left(k < epsilon \Rightarrow \operatorname{StrictRecord}\left(k, p^{a}\right)\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/JordanCototientRecordLimitZero.not_eventual_record_odd_prime_pow` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

No positive power p^a of an odd prime is an eventual strict record near zero. When a=1, p ties the preceding prime two. When a>=2, the explicit predecessor 2*p^(Nat.sub(a,1)) has the larger derivative at zero and therefore beats p^a throughout a right neighborhood.

**Theorem 1.8 (Large powers of two are excluded).**

$$\forall a \in \mathbb{N},\; 3 \le a \Rightarrow \left(\neg \left(\exists epsilon \in \mathbb{R},\; 0 < epsilon \land \left(\forall k \in \mathbb{R},\; 0 < k \Rightarrow \left(k < epsilon \Rightarrow \operatorname{StrictRecord}\left(k, 2^{a}\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/JordanCototientRecordLimitZero.not_eventual_record_two_pow` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every natural a>=3, the power 2^a is not an eventual strict record near zero. The explicit smaller predecessor 3*2^(Nat.sub(a,2)) has a strictly larger cototient derivative at zero, so it beats 2^a for all sufficiently small positive k.

**Theorem 1.9 (The eventual record classification near zero).**

$$\forall n \in \mathbb{N},\; 1 \le n \Rightarrow \left((\exists epsilon \in \mathbb{R},\; 0 < epsilon \land \left(\forall k \in \mathbb{R},\; 0 < k \Rightarrow \left(k < epsilon \Rightarrow \operatorname{StrictRecord}\left(k, n\right)\right)\right)) \Leftrightarrow (n = 1 \lor \left(n = 2 \lor \left(n = 4 \lor 2 \le \operatorname{card}\left(\operatorname{primeFactors}\left(n\right)\right)\right)\right))\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/JordanCototientRecordLimitZero.a387335_eventual_record_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every natural n>=1, there is a positive real epsilon such that n is a strict Jordan-cototient record for every real 0<k<epsilon exactly when n is 1, 2, 4, or has at least two distinct prime factors. The same n occurs in the outer binder, record predicate, exceptional equalities, and prime-factor-cardinality clause.

The OEIS A387335 comment presents this classification as an apparent pattern. The proof here is pointwise in n: epsilon may depend on n. Computations at fixed k=0.1, 0.01, and 0.001 through n=500 do not stabilize to the predicted finite prefix, so no uniform-epsilon claim is made.

The forward direction classifies a remaining input as a prime power, then invokes the explicit odd-prime-power or power-of-two defeater. The reverse direction uses the three exact exceptional cases and the derivative-gap finite-intersection theorem.

## References

- Truth anchor: `D5/S3/Factorization/JordanCototientRecordLimitZero.a387335_eventual_record_iff`
- Truth anchor: `D5/S3/Factorization/JordanCototientRecordLimitZero.eventual_record_four`
- Truth anchor: `D5/S3/Factorization/JordanCototientRecordLimitZero.eventual_record_of_two_le_primeFactors_card`
- Truth anchor: `D5/S3/Factorization/JordanCototientRecordLimitZero.eventual_record_one`
- Truth anchor: `D5/S3/Factorization/JordanCototientRecordLimitZero.eventual_record_two`
- Truth anchor: `D5/S3/Factorization/JordanCototientRecordLimitZero.hasDerivAt_CoJ_of_primeFactors_eq_singleton`
- Truth anchor: `D5/S3/Factorization/JordanCototientRecordLimitZero.hasDerivAt_CoJ_of_two_le_card`
- Truth anchor: `D5/S3/Factorization/JordanCototientRecordLimitZero.not_eventual_record_odd_prime_pow`
- Truth anchor: `D5/S3/Factorization/JordanCototientRecordLimitZero.not_eventual_record_two_pow`
- Dependency: [D5/S3/Factorization/JordanCototientRecordLimitInfinity](JordanCototientRecordLimitInfinity.md)
