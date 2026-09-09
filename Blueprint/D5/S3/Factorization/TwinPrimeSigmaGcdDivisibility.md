# Twin-Prime Sigma-Gcd Divisibility

## Abstract

Every twin-prime center with prime gcd(k, sigma(k)) is divisible by 18.

Here sigma(k) is the sum of the positive divisors of k, represented by ArithmeticFunction.sigma 1 k. Subtraction is natural-number subtraction; the hypotheses ensure k is greater than one.

**Theorem 1.1 (Twin-prime centers are even).**

$$\forall k \in \mathbb{N}, 1 < k \implies \operatorname{Prime}(k-1) \implies \operatorname{Prime}(k+1) \implies 2 \mid k$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.even_center` (`✓ std3`). ∎

*Source.* Repository-derived.

*Acknowledgement.* OEIS Foundation Inc. (2026). *OEIS A394757*. URL: <https://oeis.org/A394757>.

*Commentary.*

If k were odd, both neighboring primes would be even, so both would equal 2. Their difference is 2, a contradiction.

**Theorem 1.2 (Divisibility by three).**

$$\forall k \in \mathbb{N}, 1 < k \implies \operatorname{Prime}(k-1) \implies \operatorname{Prime}(k+1) \implies \operatorname{Prime}(\operatorname{gcd}(k,\operatorname{sigma}(k))) \implies 2 \mid k \implies 3 \mid k$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.three_center` (`✓ std3`). ∎

*Source.* Repository-derived.

*Acknowledgement.* OEIS Foundation Inc. (2026). *OEIS A394757*. URL: <https://oeis.org/A394757>.

*Commentary.*

The proof treats k below 6 explicitly. At k=4, sigma(4)=7 and the gcd is 1, contradicting its primality. Above this range both neighboring primes exceed 3. Neither can be divisible by 3, so k must be.

**Theorem 1.3 (A composite divisor of the sigma-gcd).**

$$\forall k \in \mathbb{N}, 2 \mid k \implies 3 \mid k \implies \neg (9 \mid k) \implies (4 \mid \operatorname{gcd}(k,\operatorname{sigma}(k)) \lor 6 \mid \operatorname{gcd}(k,\operatorname{sigma}(k)))$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.four_or_six_dvd_gcd` (`✓ std3`). ∎

*Source.* Repository-derived.

*Acknowledgement.* OEIS Foundation Inc. (2026). *OEIS A394757*. URL: <https://oeis.org/A394757>.

*Commentary.*

Write k=3m. Since 9 does not divide k, 3 does not divide m, and multiplicativity gives sigma(k)=4 sigma(m). If 4 divides k, it divides the gcd. Otherwise write k=2r with r odd. Multiplicativity now gives sigma(k)=3 sigma(r). Thus both 2 and 3 divide the gcd, so 6 divides it. This argument applies to every k satisfying the three divisibility hypotheses, independently of the neighboring integers.

**Theorem 1.4 (Every A394757 term is divisible by 18).**

$$\forall k \in \mathbb{N}, 1 < k \implies \operatorname{Prime}(k-1) \implies \operatorname{Prime}(k+1) \implies \operatorname{Prime}(\operatorname{gcd}(k,\operatorname{sigma}(k))) \implies 18 \mid k$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.sigma_gcd_divisibility` (`✓ std3`). ∎

*Resolves.* `Problems/oeis-a394757-twin-prime-sigma-gcd` (proved) by `D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.sigma_gcd_divisibility`.

<!-- scribe-open-problem-resolution-v1 {"problem_slug":"oeis-a394757-twin-prime-sigma-gcd","declaration_gid":"D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.sigma_gcd_divisibility","resolution_kind":"proved"} -->

*Source.* Repository-derived.

*Acknowledgement.* OEIS Foundation Inc. (2026). *OEIS A394757*. URL: <https://oeis.org/A394757>.

*Commentary.*

The first two results give 2 and 3 dividing k. If 9 did not divide k, the preceding result would give a composite divisor of a prime gcd. Hence 9 divides k, and coprimality of 2 and 9 gives 18 dividing k. The result holds for all natural k; no finite search bound is used.

## References

- Truth anchor: `D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.even_center`
- Truth anchor: `D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.four_or_six_dvd_gcd`
- Truth anchor: `D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.sigma_gcd_divisibility`
- Truth anchor: `D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.three_center`
