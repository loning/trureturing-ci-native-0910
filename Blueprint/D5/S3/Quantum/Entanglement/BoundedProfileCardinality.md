# Bounded Profile Cardinality

## Abstract

Finite bounded occupation profiles have a product cardinality.

Let I be a finite index type and let a assign a natural capacity to each index. A bounded profile chooses, at every index i, a value in Fin(a(i)+1), so its coordinates range from zero through a(i).

**Theorem 1.1 (The number of bounded profiles is the product of the coordinate cardinalities.).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall a \in Function\left(I, \mathbb{N}\right),\; FintypeCard\left(Profile\left(a\right)\right) = \prod_{i:I}{a\left(i\right) + 1}\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/BoundedProfileCardinality.card_bounded_profiles` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The dependent finite product cardinality is the product of the cardinalities of the coordinate types. Each coordinate type Fin(a(i)+1) has cardinality a(i)+1.

## References

- Truth anchor: `D5/S3/Quantum/Entanglement/BoundedProfileCardinality.card_bounded_profiles`
- Dependency: [D5/S1/Ledger/BoundedTimeSlice](../../../S1/Ledger/BoundedTimeSlice.md)
