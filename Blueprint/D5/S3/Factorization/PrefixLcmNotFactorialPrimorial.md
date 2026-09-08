# A Prefix Lcm Outside the Factorial-Primorial Products

## Abstract

The prefix least common multiple at 5^69 refutes the proposed decomposition into a factorial product and a product of distinct primorials.

**Definition 1.1 (Products of factorials).**

$$\forall J \in \mathbb{N}, \operatorname{IsFactorialProduct}\left(J\right) \iff \exists ell: \operatorname{Multiset}\left(\mathbb{N}\right), J = \prod_{k \in ell} {k}!.$$

*Formalization.* `D5/S3/Factorization/PrefixLcmNotFactorialPrimorial.IsFactorialProduct` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A natural number J is a factorial product when some finite multiset of natural indices has J as the product of their factorials. Because the indices form a multiset, the same factorial may occur repeatedly, as required by the Jordan-Polya sequence A001013.

**Definition 1.2 (Products of distinct primorials).**

$$\forall P \in \mathbb{N}, \operatorname{IsDistinctPrimorialProduct}\left(P\right) \iff \exists S: \operatorname{Finset}\left(\mathbb{N}\right), {\forall q \in S, \operatorname{Prime}\left(q\right)} \land P = \prod_{q \in S} \operatorname{primorial}\left(q\right).$$

*Formalization.* `D5/S3/Factorization/PrefixLcmNotFactorialPrimorial.IsDistinctPrimorialProduct` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A natural number P is represented by a finite set S of prime indices, with one primorial factor for each q in S. Primorial values are constant between consecutive primes, for example primorial(3)=primorial(4)=6. Requiring every q in S to be prime therefore makes membership correspond exactly to a distinct primorial value, matching A129912.

**Theorem 1.3 (The prefix lcm at 5^69 is a counterexample).**

$$\neg \exists J, P \in \mathbb{N}, {\operatorname{IsFactorialProduct}\left(J\right) \land \operatorname{IsDistinctPrimorialProduct}\left(P\right) \land \operatorname{lcmUpto}\left(5^{69}\right) = J \cdot P}.$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/PrefixLcmNotFactorialPrimorial.prefixLcm_5_pow_69_not_factorial_mul_distinctPrimorial` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Let L be the least common multiple of the naturals through 5^69. Its valuations at 2,3,5,7,11,13,17,19,23,29,31,37 are respectively 160,101,69,57,46,43,39,37,35,32,32,30. The weighted sum of successive valuation differences with weights 3,1,-6,-7,-8,-5,-12,-12,-7,0,-6 is -65.

Legendre's factorial valuation formula and a finite check through index 163 show that every permitted factorial contributes a nonnegative weighted score. The valuation at 2 of 164! is 161, so no larger factorial can divide L. Each distinct primorial contributes at most one to each successive valuation gap, giving total score at least -63. Additivity would force -65 to be at least -63, a contradiction.

**Theorem 1.4 (The universal prime-power decomposition is false).**

$$\neg \forall X \in \mathbb{N}, \operatorname{IsPrimePow}\left(X\right) \Rightarrow \exists J, P \in \mathbb{N}, {\operatorname{IsFactorialProduct}\left(J\right) \land \operatorname{IsDistinctPrimorialProduct}\left(P\right) \land \operatorname{lcmUpto}\left(X\right) = J \cdot P}.$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/PrefixLcmNotFactorialPrimorial.not_forall_prime_pow_lcmUpto_factorial_mul_distinctPrimorial` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The number 5^69 is a positive power of the prime 5. The certified counterexample above therefore disproves the assertion that every prime power has the proposed factorial-primorial decomposition.

## References

- Truth anchor: `D5/S3/Factorization/PrefixLcmNotFactorialPrimorial.IsDistinctPrimorialProduct`
- Truth anchor: `D5/S3/Factorization/PrefixLcmNotFactorialPrimorial.IsFactorialProduct`
- Truth anchor: `D5/S3/Factorization/PrefixLcmNotFactorialPrimorial.not_forall_prime_pow_lcmUpto_factorial_mul_distinctPrimorial`
- Truth anchor: `D5/S3/Factorization/PrefixLcmNotFactorialPrimorial.prefixLcm_5_pow_69_not_factorial_mul_distinctPrimorial`
