# Von Mangoldt Recurrence Obstruction

## Abstract

Arbitrarily late von Mangoldt zero windows rule out eventual linear recurrences with real or complex constant coefficients.

**Theorem 1.1 (Arbitrarily late windows with two distinct prime factors).**

$$\forall r, B \in \mathbb{N}, \exists N \ge B, \exists a, b : \operatorname{Fin}\left(r\right) \to \mathbb{N},\\{}(\forall j \in \operatorname{Fin}\left(r\right), \operatorname{Prime}\left(\operatorname{a}\left(j\right)\right) \land \operatorname{Prime}\left(\operatorname{b}\left(j\right)\right)) \land \operatorname{Injective}\left(x \in \operatorname{Fin}\left(r\right) \times \operatorname{Bool}\left(\right) \mapsto \operatorname{ite}\left(x_2, \operatorname{b}\left(x_1\right), \operatorname{a}\left(x_1\right)\right)\right) \land (\forall j \in \operatorname{Fin}\left(r\right), \operatorname{a}\left(j\right) \cdot \operatorname{b}\left(j\right) \neq 0)\\{} \land (\forall i, j \in \operatorname{Fin}\left(r\right), i \neq j \Rightarrow \operatorname{Coprime}\left(\operatorname{a}\left(i\right) \cdot \operatorname{b}\left(i\right), \operatorname{a}\left(j\right) \cdot \operatorname{b}\left(j\right)\right))\\{} \land (\forall j \in \operatorname{Fin}\left(r\right), \operatorname{a}\left(j\right) \cdot \operatorname{b}\left(j\right) \mid N + j) \land (\forall j \in \operatorname{Fin}\left(r\right), \neg \operatorname{IsPrimePow}\left(N + j\right))$$

*Proof.* Machine-checked in Lean as `D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.arbitrarily_late_two_prime_factor_window` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The indices i and j range over Fin r, coerced to natural numbers in sums. The Boolean selector takes b at true and a at false. Increasing enumeration of the infinite prime set supplies disjoint pairs. For the product modulus at j, choose the residue minus j. The finite CRT realizes these residues; adding B times the positive product of all moduli makes the representative at least B. Two distinct prime divisors exclude a prime power. All statements include r equal to zero, with empty families and product one.

**Theorem 1.2 (Arbitrarily late zero windows).**

$$\forall r, B \in \mathbb{N}, \exists N \ge B, \forall j < r, \Lambda(N + j) = 0$$

*Proof.* Machine-checked in Lean as `D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.arbitrarily_late_vonMangoldt_zero_window` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Lambda denotes the real-valued singleAddressReading, definitionally ArithmeticFunction.vonMangoldt. Apply the non-prime-power conjunct of single_address_reading_spec to every position of the constructed window.

**Theorem 1.3 (Explicit positive prime readings above every bound).**

$$\forall B \in \mathbb{N}, \exists p \ge B, \operatorname{Prime}\left(p\right) \land \Lambda(p) = \log(p) \land 0 < \log(p)$$

*Proof.* Machine-checked in Lean as `D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.arbitrarily_late_prime_reading_positive` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Prime infinitude supplies p above B. The prime-power reading law at exponent one gives log p; vonMangoldt_pos_iff proves its strict positivity. The logarithm and Lambda in this statement are real-valued.

**Theorem 1.4 (No eventual complex linear recurrence).**

$$\neg \exists r \in \mathbb{N}, c : \operatorname{Fin}\left(r\right) \to \mathbb{C}, N_0 \in \mathbb{N}, \forall n \ge N_0,\\{}(\Lambda(n + r) : \mathbb{C}) = \sum_{j \in \operatorname{Fin}\left(r\right)} \operatorname{c}\left(j\right) \cdot (\Lambda(n + j) : \mathbb{C})$$

*Proof.* Machine-checked in Lean as `D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.vonMangoldt_no_eventual_complex_linear_recurrence` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Choose a zero window starting at N at least N0. The shifted complex sequence is a solution of LinearRecurrence with order r and coefficients c. Its initial r values agree with zero, so eq_iff_eqOn_range_order makes the whole shifted sequence zero. A prime at least N plus one contradicts the nonzero prime-address theorem at exponent one. For r equal to zero the range and sum are empty, and the same uniqueness theorem applies.

**Theorem 1.5 (No eventual real linear recurrence).**

$$\neg \exists r \in \mathbb{N}, c : \operatorname{Fin}\left(r\right) \to \mathbb{R}, N_0 \in \mathbb{N}, \forall n \ge N_0,\\{}\Lambda(n + r) = \sum_{j \in \operatorname{Fin}\left(r\right)} \operatorname{c}\left(j\right) \cdot \Lambda(n + j)$$

*Proof.* Machine-checked in Lean as `D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.vonMangoldt_no_eventual_real_linear_recurrence` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Apply the canonical embedding of the reals into the complex numbers to each coefficient and each value. It preserves the finite sum and products, so a real recurrence would contradict the complex obstruction.

## References

- Truth anchor: `D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.arbitrarily_late_prime_reading_positive`
- Truth anchor: `D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.arbitrarily_late_two_prime_factor_window`
- Truth anchor: `D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.arbitrarily_late_vonMangoldt_zero_window`
- Truth anchor: `D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.vonMangoldt_no_eventual_complex_linear_recurrence`
- Truth anchor: `D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.vonMangoldt_no_eventual_real_linear_recurrence`
- Dependency: [D5/S3/ArithUnits/FiniteWindowResidues](../../ArithUnits/FiniteWindowResidues.md)
- Dependency: [D5/S3/Weil/PrimeAddress/PrimeAddress](PrimeAddress.md)
