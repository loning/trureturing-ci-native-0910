# Golden Divisor Languages

## Abstract

Prime exponents identify full-window divisors with golden names and distinguish the 5040 observation fiber.

Let S be a finite set of natural primes and L a natural-valued function on S. A divisor is a positive natural number whose value divides the specified integer. Length zero and the empty prime set are allowed.

**Definition 1.1 (Positive divisors).**

$$\forall m \in \mathbb{N},\; \operatorname{Div}\left(m\right) = \{d:\operatorname{PNat}\left(\right)|\operatorname{val}\left(d\right) \mid m\}$$

*Formalization.* `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Div` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The carrier includes the divisor's positivity and divisibility proofs.

**Definition 1.2 (The full Fibonacci window).**

$$\forall S \in \operatorname{Finset}\left(\mathbb{N}\right), L \in S\to \mathbb{N},\; \operatorname{fullWindow}\left(S, L\right) = \prod_{p \in S} p^{\operatorname{fib}\left(\operatorname{L}\left(p\right) + 2\right) - 1}$$

*Formalization.* `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.fullWindow` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The exponent at p is fib(L(p)+2)-1.

**Theorem 1.3 (Divisors in prime coordinates).**

$$\forall S \in \operatorname{Finset}\left(\mathbb{N}\right), L \in S\to \mathbb{N},\; \left(\forall p \in S,\; \operatorname{Prime}\left(p\right)\right) \Rightarrow \left(\exists e \in \operatorname{Equiv}\left(\operatorname{Div}\left(\operatorname{fullWindow}\left(S, L\right)\right), \prod_{p \in S} \operatorname{Fin}\left(\operatorname{fib}\left(\operatorname{L}\left(p\right) + 2\right)\right)\right),\; \forall d \in \operatorname{Div}\left(\operatorname{fullWindow}\left(S, L\right)\right), p \in S,\; \operatorname{val}\left(\operatorname{e}\left(d, p\right)\right) = \operatorname{factorization}\left(\operatorname{val}\left(\operatorname{val}\left(d\right)\right), p\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.full_window_divisor_exponent_equiv` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The forward map reads each prime multiplicity. The inverse multiplies the corresponding prime powers. Factorization uniqueness proves both inverse identities, including vanishing outside S.

**Theorem 1.4 (The number of divisors).**

$$\forall S \in \operatorname{Finset}\left(\mathbb{N}\right), L \in S\to \mathbb{N},\; \left(\forall p \in S,\; \operatorname{Prime}\left(p\right)\right) \Rightarrow \operatorname{card}\left(\operatorname{Div}\left(\operatorname{fullWindow}\left(S, L\right)\right)\right) = \prod_{p \in S} \operatorname{fib}\left(\operatorname{L}\left(p\right) + 2\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.full_window_divisor_card` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Each prime contributes fib(L(p)+2) independent choices.

**Theorem 1.5 (The golden-name language).**

$$\forall S \in \operatorname{Finset}\left(\mathbb{N}\right), L \in S\to \mathbb{N},\; \left(\forall p \in S,\; \operatorname{Prime}\left(p\right)\right) \Rightarrow \operatorname{Nonempty}\left(\operatorname{Equiv}\left(\operatorname{Div}\left(\operatorname{fullWindow}\left(S, L\right)\right), \prod_{p \in S} \operatorname{GoldenName}\left(\operatorname{L}\left(p\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.full_window_divisor_golden_equiv` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The finite Zeckendorf interval bijection is applied independently to every exponent coordinate.

For the concrete window, primes5040 is the set {2,3,5,7}. The function lengths5040 has values 3 at 2, 2 at 3, and 1 at both 5 and 7.

**Definition 1.6 (The active primes).**

$$\operatorname{primes5040}\left(\right) = \{2,3,5,7\}$$

*Formalization.* `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.primes5040` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

All four members are prime.

**Definition 1.7 (The four window lengths).**

$$\forall p \in \operatorname{primes5040}\left(\right),\; \operatorname{lengths5040}\left(p\right) = \operatorname{ite}\left(\operatorname{val}\left(p\right) = 2, 3, \operatorname{ite}\left(\operatorname{val}\left(p\right) = 3, 2, 1\right)\right)$$

*Formalization.* `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.lengths5040` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The conditional expression fixes the lengths without an ordering choice.

**Theorem 1.8 (The window integer).**

$$\operatorname{fullWindow}\left(\operatorname{primes5040}\left(\right), \operatorname{lengths5040}\left(\right)\right) = 5040$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.full_window_5040` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The Fibonacci exponents are 4, 2, 1, and 1, respectively.

**Theorem 1.9 (Four golden-name factors).**

$$\operatorname{Nonempty}\left(\operatorname{Equiv}\left(\operatorname{Div}\left(5040\right), \operatorname{GoldenName}\left(3\right)\times \operatorname{GoldenName}\left(2\right)\times \operatorname{GoldenName}\left(1\right)\times \operatorname{GoldenName}\left(1\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.divisor_5040_golden_equiv` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Evaluation at the ordered primes 2, 3, 5, and 7 splits the dependent product into the four displayed factors.

**Theorem 1.10 (Sixty divisor states).**

$$\operatorname{card}\left(\operatorname{Div}\left(5040\right)\right) = 60$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.divisor_5040_card` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The four factor sizes are 5, 3, 2, and 2.

**Definition 1.11 (Rounded exponents).**

$$\forall a \in \mathbb{N},\; \operatorname{b}\left(a\right) = \operatorname{fib}\left(\operatorname{greatestFib}\left(a + 1\right)\right) - 1$$

*Formalization.* `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.b` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The largest Fibonacci number not exceeding a+1 determines the rounded exponent.

**Theorem 1.12 (The zero exponent).**

$$\operatorname{b}\left(0\right) = 0$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.b_zero` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

An absent prime remains absent.

**Theorem 1.13 (Exponent contraction).**

$$\forall a \in \mathbb{N},\; \operatorname{b}\left(a\right) \le a$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.b_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Rounding down cannot increase a prime multiplicity.

**Theorem 1.14 (Monotone rounding).**

$$\operatorname{Monotone}\left(b\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.b_monotone` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Increasing an exponent cannot decrease its rounded value.

**Theorem 1.15 (Stable window endpoints).**

$$\forall a \in \mathbb{N},\; \operatorname{b}\left(\operatorname{b}\left(a\right)\right) = \operatorname{b}\left(a\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.b_idempotent` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A second rounding leaves each endpoint unchanged.

**Definition 1.16 (Integer observation).**

$$\forall n \in \operatorname{PNat}\left(\right),\; \operatorname{Gobs}\left(n\right) = \prod_{p \in \operatorname{support}\left(\operatorname{factorization}\left(\operatorname{val}\left(n\right)\right)\right)} p^{\operatorname{b}\left(\operatorname{factorization}\left(\operatorname{val}\left(n\right), p\right)\right)}$$

*Formalization.* `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Observation multiplies the prime powers with rounded multiplicities.

**Theorem 1.17 (Positive observation).**

$$\forall n \in \operatorname{PNat}\left(\right),\; 0 < \operatorname{Gobs}\left(n\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Every factor is a positive prime power.

**Theorem 1.18 (Observed prime multiplicities).**

$$\forall n \in \operatorname{PNat}\left(\right), p \in \mathbb{N},\; \operatorname{factorization}\left(\operatorname{Gobs}\left(n\right), p\right) = \operatorname{b}\left(\operatorname{factorization}\left(\operatorname{val}\left(n\right), p\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs_factorization` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Prime factorization reconstructs exactly the rounded exponent family.

**Theorem 1.19 (Observation is a divisor).**

$$\forall n \in \operatorname{PNat}\left(\right),\; \operatorname{Gobs}\left(n\right) \mid \operatorname{val}\left(n\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs_dvd` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The coordinatewise exponent inequalities are precisely divisibility.

**Theorem 1.20 (Stable integer observations).**

$$\forall n \in \operatorname{PNat}\left(\right),\; \operatorname{Gobs}\left(\operatorname{Gobs}\left(n\right)\right) = \operatorname{Gobs}\left(n\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs_idempotent` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The inner observation is regarded as a positive natural using Gobs_pos. Idempotence holds at every prime coordinate.

**Theorem 1.21 (Two free exponent coordinates).**

$$\operatorname{image}\left(r\mapsto5040\times 2^{\operatorname{val}\left(\operatorname{fst}\left(r\right)\right)}\times 3^{\operatorname{val}\left(\operatorname{snd}\left(r\right)\right)}, \operatorname{univ}\left(\operatorname{Fin}\left(3\right)\times\operatorname{Fin}\left(2\right)\right)\right) = \{5040,10080,15120,20160,30240,60480\}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.golden_fiber_5040_decode_image` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For r in Fin(3) times Fin(2), decode(r) is 5040 times 2 raised to the first coordinate times 3 raised to the second coordinate. The image is the displayed six-element set.

**Theorem 1.22 (A stable target value).**

$$\operatorname{Gobs}\left(5040\right) = 5040$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs_5040_fixed` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The target occurs as an observation, so observation idempotence fixes it.

**Theorem 1.23 (The full observation fiber).**

$$\forall n \in \operatorname{PNat}\left(\right),\; \operatorname{Gobs}\left(n\right) = 5040 \Leftrightarrow \operatorname{val}\left(n\right) \in \{5040,10080,15120,20160,30240,60480\}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.golden_fiber_5040` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The exponents at 2 range from 4 through 6, those at 3 from 2 through 3, and the exponents at 5 and 7 equal 1. Every other exponent is zero. Monotonicity gives the upper bounds, and factorization uniqueness reconstructs the six integers. These six observation states are distinct from the sixty positive divisor states.

## References

- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Div`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs_5040_fixed`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs_dvd`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs_factorization`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs_idempotent`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.Gobs_pos`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.b`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.b_idempotent`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.b_le`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.b_monotone`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.b_zero`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.divisor_5040_card`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.divisor_5040_golden_equiv`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.fullWindow`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.full_window_5040`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.full_window_divisor_card`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.full_window_divisor_exponent_equiv`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.full_window_divisor_golden_equiv`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.golden_fiber_5040`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.golden_fiber_5040_decode_image`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.lengths5040`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.primes5040`
- Dependency: [D5/S3/Observer/GoldenCoding/FiniteZeckendorfEulerIdentity](../../Observer/GoldenCoding/FiniteZeckendorfEulerIdentity.md)
