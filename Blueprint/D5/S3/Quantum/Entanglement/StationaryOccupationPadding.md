# Stationary Occupation Padding

## Abstract

Finite padding isometries and the physical stationary occupation gate.

For a finite index type I and a capacity function c:I to Nat, TailBox(c) contains bounded tail coordinates. PositiveTail(c) removes the all-zero tail, and PaddingMemory(H,c)=Option(PositiveTail(c) x Fin(H+1)) is the finite memory used by the padding construction.

**Theorem 1.1 (The padding memory has exact cardinality).**

$$\forall I \in Type,\; Fintype\left(I\right) \Rightarrow \left(\forall H \in \mathbb{N},\; \forall c \in Function\left(I, \mathbb{N}\right),\; card\left(PaddingMemory\left(H, c\right)\right) = \left(H + 1\right) \cdot \prod_{i:I}{c\left(i\right) + 1} - H\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.padding_memory_card` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The None state removes the all-zero tail from the bounded product, leaving the displayed product-minus-H count.

**Theorem 1.2 (Padding transition probabilities sum to one).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall H \in \mathbb{N},\; \forall c \in Function\left(I, \mathbb{N}\right),\; \forall s \in PaddingMemory\left(H, c\right),\; \sum_{i:Option\left(I\right)}{paddingProbability\left(H, c, s, i\right)} = 1\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.padding_probability_sum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The sink, head predecessor and positive tail predecessors partition the legal emissions, including the one-tail boundary.

**Theorem 1.3 (The padding matrix has orthonormal columns).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall H \in \mathbb{N},\; \forall c \in Function\left(I, \mathbb{N}\right),\; conjTranspose\left(paddingMatrix\left(H, c\right)\right) \cdot paddingMatrix\left(H, c\right) = identity\left(PaddingMemory\left(H, c\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.padding_matrix_gram` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Distinct predecessor states have disjoint legal emissions in the (letter, memory) output space, and the probability identity gives unit column norm.

**Theorem 1.4 (The padding matrix is realized by one unitary).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall H \in \mathbb{N},\; \forall c \in Function\left(I, \mathbb{N}\right),\; \exists U \in Unitary\left(Prod\left(Option\left(I\right), PaddingMemory\left(H, c\right)\right)\right),\; \forall j \in PaddingMemory\left(H, c\right),\; \forall i \in Option\left(I\right),\; \forall k \in PaddingMemory\left(H, c\right),\; coefficient\left(U, pair\left(basis\left(pair\left(none\left(\right), j\right)\right), pair\left(i, k\right)\right)\right) = paddingMatrix\left(H, c, i, k, j\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.padding_unitary_exists` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The finite isometry extends to a unitary while preserving every displayed matrix coefficient.

**Theorem 1.5 (The physical matrix is an isometry).**

$$\forall A \in Type,\; \left(Fintype\left(A\right) \land \left(DecidableEq\left(A\right) \land Nonempty\left(A\right)\right)\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; conjTranspose\left(physicalMatrix\left(a\right)\right) \cdot physicalMatrix\left(a\right) = identity\left(Fin\left(proposedDimension\left(a\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.physical_matrix_gram` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Finite-index relabeling transports the padding Gram identity to physical memory coordinates.

**Theorem 1.6 (The physical sink vector is normalized).**

$$\forall A \in Type,\; \left(Fintype\left(A\right) \land \left(DecidableEq\left(A\right) \land Nonempty\left(A\right)\right)\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; norm\left(physicalFinal\left(a\right)\right) = 1\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.physical_final_norm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The final vector is the basis vector at the transported sink state.

**Theorem 1.7 (Physical gate coefficients equal matrix entries).**

$$\forall A \in Type,\; \left(Fintype\left(A\right) \land \left(DecidableEq\left(A\right) \land Nonempty\left(A\right)\right)\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall j \in Fin\left(proposedDimension\left(a\right)\right),\; \forall i \in A,\; \forall k \in Fin\left(proposedDimension\left(a\right)\right),\; coefficient\left(physicalGate\left(a\right), pair\left(basis\left(pair\left(maximalHead\left(a\right), j\right)\right), pair\left(i, k\right)\right)\right) = physicalMatrix\left(a, pair\left(i, k\right), j\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.physical_gate_coefficients` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The relabeled unitary exposes the exact weighted transition coefficient used by the residual circuit.

## References

- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.padding_matrix_gram`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.padding_memory_card`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.padding_probability_sum`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.padding_unitary_exists`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.physical_final_norm`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.physical_gate_coefficients`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationPadding.physical_matrix_gram`
- Dependency: [D5/S3/Quantum/Entanglement/OccupancyWordSectors](OccupancyWordSectors.md)
- Dependency: [D5/S3/Quantum/Entanglement/SequentialRegisterCircuit](SequentialRegisterCircuit.md)
