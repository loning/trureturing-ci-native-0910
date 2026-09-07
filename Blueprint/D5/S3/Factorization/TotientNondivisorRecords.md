# Totient Nondivisors and Consecutive-Totient Lcm Records

## Abstract

Totient nondivisor values are exactly consecutive-totient lcm jumps, and 1275120 refutes the proposed exception set for equality with the power-sum sequence.

OEIS A378640 (Xausa, 2024-12-05) asks whether its values agree with A095366 outside numbers sixty times an odd number, and whether its distinct values are A076245 after the initial one. The first question is refuted here at N = 1275120; the second is answered affirmatively by a general range characterization derived in this repository.

The counterexample and range theorem share the functions a and L, so they are placed in one module. Natural subtraction is truncated. A sum over 0 <= j < k is the Finset.range k sum, and the lcm over an empty range is one.

**Definition 1.1 (Failure of totient divisibility).**

$$\forall N \in \mathbb{N}, m \in \mathbb{N},\; \operatorname{BadTotient}\left(N, m\right) \Leftrightarrow \left(2 \le m \land \left(\neg \varphi\left(m\right) \mid N\right)\right)$$

*Formalization.* `D5/S3/Factorization/TotientNondivisorRecords.BadTotient` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

BadTotient(N,m) is exactly the conjunction that m is at least two and Euler's totient phi(m) does not divide N.

**Definition 1.2 (Least totient nondivisor).**

$$\forall N \in \mathbb{N},\; \operatorname{a}\left(N\right) = \operatorname{if} 0 < N \operatorname{then} \operatorname{min}\left(\{m: \mathbb{N} \mid \operatorname{BadTotient}\left(N, m\right)\}\right) \operatorname{else} 0$$

*Formalization.* `D5/S3/Factorization/TotientNondivisorRecords.a` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For positive N, a(N) is Nat.find applied to the existence of a BadTotient, hence the minimum displayed. The totalized value at N = 0 is zero; the OEIS A378640 sequence is used only on positive inputs.

**Definition 1.3 (Finite power sum).**

$$\forall N \in \mathbb{N}, k \in \mathbb{N},\; \operatorname{powerSum}\left(N, k\right) = \sum_{{0 \le j < k}} j^{N}$$

*Formalization.* `D5/S3/Factorization/TotientNondivisorRecords.powerSum` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The range contains precisely 0 through k-1. At the positive exponent used below, the added zeroth term vanishes, leaving the OEIS sum from 1 to k-1.

**Definition 1.4 (Power-sum divisor predicate).**

$$\forall N \in \mathbb{N}, k \in \mathbb{N},\; \operatorname{PowerSumDivisor}\left(N, k\right) \Leftrightarrow \left(2 \le k \land k \mid \operatorname{powerSum}\left(N, k\right)\right)$$

*Formalization.* `D5/S3/Factorization/TotientNondivisorRecords.PowerSumDivisor` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A power-sum divisor is at least two and divides the corresponding finite sum.

**Definition 1.5 (Least power-sum divisor).**

$$\forall N \in \mathbb{N},\; \operatorname{A095366}\left(N\right) = \operatorname{sInf}\left(\{k: \mathbb{N} \mid \operatorname{PowerSumDivisor}\left(N, k\right)\}\right)$$

*Formalization.* `D5/S3/Factorization/TotientNondivisorRecords.A095366` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This is Nat.sInf of exactly the natural numbers satisfying PowerSumDivisor. It formalizes the A095366 definition cited by OEIS A378640 (Xausa, 2024); for exponent 1275120 the proof supplies 53 as an inhabitant.

**Definition 1.6 (Consecutive-totient lcm).**

$$\forall t \in \mathbb{N},\; \operatorname{L}\left(t\right) = \operatorname{lcm}_{{0 \le i < t}} \varphi\left(i + 1\right)$$

*Formalization.* `D5/S3/Factorization/TotientNondivisorRecords.L` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The finite range 0 <= i < t is shifted by one, so this is exactly the lcm of phi(1) through phi(t), the A076245 construction cited by OEIS A378640 (Xausa, 2024). The t = 0 range is empty.

**Theorem 1.7 (The empty lcm).**

$$\operatorname{L}\left(0\right) = 1$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.L_zero` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Finset.lcm over the empty range is one.

**Theorem 1.8 (Divisibility by the consecutive-totient lcm).**

$$\forall t \in \mathbb{N}, N \in \mathbb{N},\; \operatorname{L}\left(t\right) \mid N \Leftrightarrow \left(\forall j \in \mathbb{N},\; 1 \le j \Rightarrow \left(j \le t \Rightarrow \varphi\left(j\right) \mid N\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.L_dvd_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Finset.lcm_dvd_iff turns divisibility by L(t) into simultaneous divisibility by every phi(j) with 1 <= j <= t.

**Theorem 1.9 (Strict lcm jumps detect a new totient).**

$$\forall m \in \mathbb{N},\; 2 \le m \Rightarrow \left(\operatorname{L}\left(m - 1\right) < \operatorname{L}\left(m\right) \Leftrightarrow \left(\neg \varphi\left(m\right) \mid \operatorname{L}\left(m - 1\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.L_jump_iff_not_dvd` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Monotonicity gives L(m-1) dividing L(m). Equality holds exactly when the new factor phi(m) already divides L(m-1), yielding the stated strict-jump criterion.

**Theorem 1.10 (The value set is the strict-jump set).**

$$\forall m \in \mathbb{N},\; 2 \le m \Rightarrow \left(\left(\exists N \in \mathbb{N},\; 1 \le N \land \operatorname{a}\left(N\right) = m\right) \Leftrightarrow \operatorname{L}\left(m - 1\right) < \operatorname{L}\left(m\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.range_iff_lcm_jump` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Forward, minimality of a(N) makes every earlier totient divide N, so L(m-1) divides N while phi(m) does not. Reverse, the explicit positive witness N = L(m-1) has all earlier totients as divisors and excludes phi(m). Thus the value set for m >= 2 is A076245 without its initial one.

**Theorem 1.11 (The lower totients divide the witness).**

$$\forall i \in \operatorname{Fin}\left(51\right),\; 1 \le \operatorname{val}\left(i\right) \Rightarrow \varphi\left(\operatorname{val}\left(i\right)\right) \mid 1275120$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.totients_lt_51_dvd_1275120` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Kernel decide checks every finite index i below 51 and proves that phi(i.val) divides 1275120 whenever i.val is positive.

**Theorem 1.12 (The totient at 51).**

$$\varphi\left(51\right) = 32$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.totient_51_eq_32` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Kernel decide computes phi(51) exactly as 32.

**Theorem 1.13 (The witness modulo 32).**

$$1275120 \bmod 32 = 16$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.mod_1275120_32` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Exact natural-number normalization computes the remainder as 16.

**Theorem 1.14 (The witness modulo 120).**

$$1275120 \bmod 120 = 0$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.mod_1275120_120` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Exact natural-number normalization computes the remainder as zero.

**Theorem 1.15 (The least totient nondivisor at 1275120).**

$$\operatorname{a}\left(1275120\right) = 51$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.a_1275120` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Kernel decide certifies phi(j) dividing 1275120 for every 1 <= j <= 50. It also certifies phi(51) = 32, while 1275120 has remainder 16 modulo 32.

**Theorem 1.16 (The power sum modulo 51).**

$$\operatorname{powerSum}\left(1275120, 51\right) \equiv 31 (\operatorname{mod} 51)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.powerSum_1275120_mod_51` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Kernel-producing modular reduction computes the power sum as congruent to 31 modulo 51.

**Theorem 1.17 (The power sum modulo 53).**

$$\operatorname{powerSum}\left(1275120, 53\right) \equiv 0 (\operatorname{mod} 53)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.powerSum_1275120_mod_53` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Kernel-producing modular reduction computes the power sum as congruent to zero modulo 53.

**Theorem 1.18 (The power-sum value is not 51).**

$$\operatorname{A095366}\left(1275120\right) \ne 51$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.A095366_1275120_ne_51` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Kernel-producing modular reduction gives powerSum(1275120,51) congruent to 31 modulo 51, while the corresponding sum at 53 is congruent to zero. Hence 53 inhabits the defining set but 51 does not.

**Theorem 1.19 (The witness lies outside the proposed exception family).**

$$\neg \left(\exists k \in \mathbb{N},\; 1275120 = 60 \cdot \left(2 \cdot k + 1\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.not_exception_form` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Natural-number arithmetic proves that 1275120 is not sixty times an odd number; equivalently, it is zero rather than sixty modulo 120.

**Theorem 1.20 (Counterexample to the proposed exception set).**

$$(\operatorname{a}\left(1275120\right) = 51) \land \left((\operatorname{A095366}\left(1275120\right) \ne 51) \land (\neg \left(\exists k \in \mathbb{N},\; 1275120 = 60 \cdot \left(2 \cdot k + 1\right)\right))\right).$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/TotientNondivisorRecords.exception_set_claim_false` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

All three certified clauses are stated together: a(1275120) is 51, the A095366 value is not 51, and 1275120 is outside the claimed exception form. Therefore the proposed equality-exception description is false.

## References

- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.A095366`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.A095366_1275120_ne_51`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.BadTotient`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.L`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.L_dvd_iff`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.L_jump_iff_not_dvd`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.L_zero`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.PowerSumDivisor`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.a`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.a_1275120`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.exception_set_claim_false`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.mod_1275120_120`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.mod_1275120_32`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.not_exception_form`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.powerSum`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.powerSum_1275120_mod_51`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.powerSum_1275120_mod_53`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.range_iff_lcm_jump`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.totient_51_eq_32`
- Truth anchor: `D5/S3/Factorization/TotientNondivisorRecords.totients_lt_51_dvd_1275120`
