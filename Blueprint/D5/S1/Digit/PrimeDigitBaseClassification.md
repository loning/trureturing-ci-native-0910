# Prime-Digit Bases: OEIS A390088

## Abstract

Prime-digit bases exist exactly outside zero, one, four, six, and nine.

**Definition 1.1 (Existence of a prime-digit base).**

Lean statement: `D5/S1/Digit/PrimeDigitBaseClassification.HasPrimeDigitBase`

*Formalization.* `D5/S1/Digit/PrimeDigitBaseClassification.HasPrimeDigitBase` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A nonzero natural number has a prime-digit base when some integer base greater than one gives only prime digits. Zero is explicitly excluded because its Lean digit list is empty.

**Theorem 1.2 (Two uniform certificates).**

Lean statement: `D5/S1/Digit/PrimeDigitBaseClassification.prime_digit_base_certificate`

*Proof.* Machine-checked in Lean as `D5/S1/Digit/PrimeDigitBaseClassification.prime_digit_base_certificate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every n at least ten, parity gives an explicit base: (n - 2) / 2 for even n and (n - 3) / 2 for odd n. The corresponding little-endian digit lists are [2, 2] and [3, 2]. The proof establishes the base and digit bounds for arbitrary n.

**Theorem 1.3 (The five exceptions).**

Lean statement: `D5/S1/Digit/PrimeDigitBaseClassification.a390088`

*Proof.* Machine-checked in Lean as `D5/S1/Digit/PrimeDigitBaseClassification.a390088` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This proves the existence form of Felix Huber's October 29, 2025 conjecture in OEIS A390088: exactly 0, 1, 4, 6, and 9 have no such base. The uniform certificates cover every n at least ten. Below ten, 2, 3, 5, and 7 use one prime digit, while 8 uses base 3. For the nonzero exceptions, bases above n give the nonprime singleton [n], and the remaining bases are checked finitely. No least-base assertion is made.

## References

- Truth anchor: `D5/S1/Digit/PrimeDigitBaseClassification.HasPrimeDigitBase`
- Truth anchor: `D5/S1/Digit/PrimeDigitBaseClassification.a390088`
- Truth anchor: `D5/S1/Digit/PrimeDigitBaseClassification.prime_digit_base_certificate`
