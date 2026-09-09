# Stationary Occupation Rank Nullity

## Abstract

Finite Gram matrices convert kernel bounds into rank lower bounds.

For finite row and column types, rank-nullity turns a bound on the kernel dimension into a lower bound on rank. The profile-specific form uses the finite carrier Profile(a).

**Theorem 1.1 (gram_rank_add_nullity).**

$$\forall I \in Type,\; \forall K \in Type,\; \left(Fintype\left(I\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall G \in Matrix\left(I, K, \mathbb{C}\right),\; rank\left(G\right) + finrank\left(\mathbb{C}, ker\left(mulVecLin\left(G\right)\right)\right) = FintypeCard\left(K\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.gram_rank_add_nullity` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This finite-dimensional identity uses no Gram positivity or realization.

**Theorem 1.2 (gram_rank_ge_card_sub_nullity).**

$$\forall I \in Type,\; \forall K \in Type,\; \left(Fintype\left(I\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall G \in Matrix\left(I, K, \mathbb{C}\right),\; \forall q \in \mathbb{N},\; finrank\left(\mathbb{C}, ker\left(mulVecLin\left(G\right)\right)\right) \le q \Rightarrow FintypeCard\left(K\right) - q \le rank\left(G\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.gram_rank_ge_card_sub_nullity` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The model-specific input is an explicit upper bound on kernel finrank.

**Theorem 1.3 (bounded_profile_rank_ge).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall a \in Function\left(I, \mathbb{N}\right),\; \forall G \in Matrix\left(Profile\left(a\right), Profile\left(a\right), \mathbb{C}\right),\; \forall q \in \mathbb{N},\; finrank\left(\mathbb{C}, ker\left(mulVecLin\left(G\right)\right)\right) \le q \Rightarrow \prod_{i:I}{a\left(i\right) + 1} - q \le rank\left(G\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.bounded_profile_rank_ge` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The profile cardinality theorem supplies the product term; no stationary-minimum claim is included.

**Theorem 1.4 (gram_factor_rank_le_memory_card).**

$$\forall I \in Type,\; \forall K \in Type,\; \left(Fintype\left(I\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall C \in Matrix\left(K, I, \mathbb{C}\right),\; rank\left(mul\left(conjTranspose\left(C\right), C\right)\right) \le FintypeCard\left(K\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.gram_factor_rank_le_memory_card` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A Gram factor through a finite memory carrier has rank at most that carrier's cardinality.

**Theorem 1.5 (gram_factor_is_hermitian).**

$$\forall I \in Type,\; \forall K \in Type,\; \left(Fintype\left(I\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall C \in Matrix\left(K, I, \mathbb{C}\right),\; IsHermitian\left(mul\left(conjTranspose\left(C\right), C\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.gram_factor_is_hermitian` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A complex Gram factor is Hermitian; positivity remains an explicit real quadratic-form obligation.

**Theorem 1.6 (gram_factor_pos_semidef).**

$$\forall I \in Type,\; \forall K \in Type,\; \left(Fintype\left(I\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall C \in Matrix\left(K, I, \mathbb{C}\right),\; PosSemidef\left(mul\left(conjTranspose\left(C\right), C\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.gram_factor_pos_semidef` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

With the ComplexOrder scope, a finite complex Gram factor is positive semidefinite.

**Theorem 1.7 (bounded_profile_memory_ge).**

$$\forall I \in Type,\; \forall K \in Type,\; \left(Fintype\left(I\right) \land \left(DecidableEq\left(I\right) \land Fintype\left(K\right)\right)\right) \Rightarrow \left(\forall a \in Function\left(I, \mathbb{N}\right),\; \forall C \in Matrix\left(K, Profile\left(a\right), \mathbb{C}\right),\; \forall q \in \mathbb{N},\; finrank\left(\mathbb{C}, ker\left(mulVecLin\left(mul\left(conjTranspose\left(C\right), C\right)\right)\right)\right) \le q \Rightarrow \prod_{i:I}{a\left(i\right) + 1} - q \le FintypeCard\left(K\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.bounded_profile_memory_ge` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Combining the profile lower bound with the factor upper bound yields a conditional memory lower bound.

## References

- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.bounded_profile_memory_ge`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.bounded_profile_rank_ge`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.gram_factor_is_hermitian`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.gram_factor_pos_semidef`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.gram_factor_rank_le_memory_card`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.gram_rank_add_nullity`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity.gram_rank_ge_card_sub_nullity`
- Dependency: [D5/S3/Quantum/Entanglement/BoundedProfileCardinality](BoundedProfileCardinality.md)
