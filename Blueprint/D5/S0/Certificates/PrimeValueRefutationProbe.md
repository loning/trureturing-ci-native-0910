# Prime Value Refutation Probe

## Abstract

Synthetic refutation admission fixture; no research novelty is claimed.

**Remark 1.1 (A composite value refutes the universal claim).**

Lean statement: `D5/S0/Certificates/PrimeValueRefutationProbe.not_all_values_prime`

*Formalization.* `D5/S0/Certificates/PrimeValueRefutationProbe.not_all_values_prime` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The closed definition all_values_prime states that n + 2 is prime for every natural n. The local theorem refutes exactly that claim: at n = 2 the value is 4, which is composite. Its expanded negation is definitionally equal to Not all_values_prime even though the definition is marked irreducible. No unrelated ordinary result is included.

## References

- Truth anchor: `D5/S0/Certificates/PrimeValueRefutationProbe.not_all_values_prime`
