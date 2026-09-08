# Occupancy Word Sectors

## Abstract

Actual occupation words have multinomial cardinalities and orthonormal uniform vectors.

A is an arbitrary finite alphabet with decidable equality. Word(A,n) is Fin n to A. The occupation of a word is the multiset of its List.ofFn entries, so the count of each symbol is its occupation number. Multiset order compares these counts. M(n,a) denotes multiplicity, the cardinality of the finite set of words with occupation a. V(n,a) denotes sectorVector: its coordinate is the complex inverse of sqrt(M(n,a)) on that finite set and zero elsewhere. Real square roots are nonnegative and are included canonically in the complex numbers.

**Theorem 1.1 (Occupation has the word length).**

$$\forall A \in Type,\; \forall n \in \mathbb{N},\; \forall w \in Word\left(A, n\right),\; card\left(occupation\left(w\right)\right) = n$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.occupation_card` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

There is one entry for each finite position.

**Theorem 1.2 (Concatenation adds occupations).**

$$\forall A \in Type,\; \forall t \in \mathbb{N},\; \forall s \in \mathbb{N},\; \forall u \in Word\left(A, t\right),\; \forall v \in Word\left(A, s\right),\; occupation\left(FinAppend\left(u, v\right)\right) = occupation\left(u\right) + occupation\left(v\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.occupation_append` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

FinAppend is Fin.append, with prefix length t and suffix length s.

**Theorem 1.3 (Every prescribed occupation is realized).**

$$\forall A \in Type,\; \forall a \in Multiset\left(A\right),\; \forall n \in \mathbb{N},\; \forall h \in card\left(a\right) = n,\; occupation\left(representative\left(a, h\right)\right) = a$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.occupation_representative` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The representative lists the multiset entries and indexes that list by Fin n.

**Theorem 1.4 (Realized word fibers are nonempty).**

$$\forall A \in Type,\; \left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall n \in \mathbb{N},\; card\left(a\right) = n \Rightarrow 0 < M\left(n, a\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.multiplicity_pos` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The representative belongs to the finite word fiber, so its cardinality is positive.

**Theorem 1.5 (Actual word cardinality is multinomial).**

$$\forall A \in Type,\; \left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall n \in \mathbb{N},\; card\left(a\right) = n \Rightarrow card\left(sectorWords\left(n, a\right)\right) = NatMultinomial\left(univ\left(A\right), z \mapsto count\left(a, z\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.sector_words_card_multinomial` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

NatMultinomial is Mathlib's factorial multinomial. The left side counts actual functions Fin n to A whose occupation is a. The head/tail recurrence is adapted from the immutable QuAIR source identified in the literature note. All finite alphabets, including the empty alphabet, and zero occupation coordinates are allowed.

**Theorem 1.6 (Factorial formula for actual multiplicity).**

$$\forall A \in Type,\; \left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall n \in \mathbb{N},\; card\left(a\right) = n \Rightarrow M\left(n, a\right) = \frac{factorial\left(n\right)}{\prod_{z:A}{factorial\left(count\left(a, z\right)\right)}}\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.multiplicity_eq_factorial` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The quotient is natural-number division and is exact. Zero coordinates contribute 0!=1; n=0 gives the unique empty word. This follows from the actual carrier count and the definition of Mathlib's multinomial, without enumeration of words.

**Theorem 1.7 (One-symbol erasure relates actual multiplicities).**

$$\forall A \in Type,\; \left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall n \in \mathbb{N},\; \forall i \in A,\; \left(card\left(a\right) = n + 1 \land i \in a\right) \Rightarrow \left(n + 1\right) \cdot M\left(n, erase\left(a, i\right)\right) = count\left(a, i\right) \cdot M\left(n + 1, a\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.multiplicity_erase_mul` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The equality is in natural numbers. It exposes the already adapted multinomial erasure recurrence on actual word counts. The sequential occupation transition uses it to telescope conditional amplitudes.

**Theorem 1.8 (Uniform occupation vectors are orthonormal).**

$$\forall A \in Type,\; \left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \Rightarrow \left(\forall n \in \mathbb{N},\; \forall a \in Multiset\left(A\right),\; \forall b \in Multiset\left(A\right),\; card\left(a\right) = n \Rightarrow \sum_{w:Word\left(A, n\right)}{star\left(V\left(n, a, w\right)\right) \cdot V\left(n, b, w\right)} = ite\left(a = b, 1, 0\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.sector_gram` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

For b=a this is squared Hilbert norm one. Distinct occupations have disjoint word supports. Only a needs a length hypothesis; when b differs, its vector has zero inner product regardless of whether b is realized.

**Theorem 1.9 (Feasible boundary occupations).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall t \in \mathbb{N},\; \forall b \in Boundary\left(a, t\right),\; val\left(b\right) \le a \land card\left(val\left(b\right)\right) = t\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.boundary_spec` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Boundary(a,t) is the subtype of distinct members of a.powersetCard(t). Equivalently, its multiset value is at most a and has cardinality t; no word-existence premise is included in this definition.

**Theorem 1.10 (Suffix occupation has the remaining length).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall t \in \mathbb{N},\; \forall s \in \mathbb{N},\; card\left(a\right) = t + s \Rightarrow \left(\forall b \in Boundary\left(a, t\right),\; card\left(a - val\left(b\right)\right) = s\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.complement_card` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Subtraction removes the prefix occupation from the total multiset.

**Theorem 1.11 (Distinct boundaries have distinct suffixes).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall t \in \mathbb{N},\; \forall b \in Boundary\left(a, t\right),\; \forall c \in Boundary\left(a, t\right),\; a - val\left(b\right) = a - val\left(c\right) \Rightarrow b = c\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.complement_injective` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Adding back a feasible prefix recovers the total occupation, so equal complements force equal boundaries.

For the coordinate bridge, I is any finite type with decidable equality, A is a natural head capacity, and a maps I to natural tail capacities. K(A,a) denotes capacityOccupation on Option(I): none is the head and some(i) is tail i. TimeSlice(A,a,t) is the landed subtype of h in Fin(A+1) and coordinates x(i) in Fin(a(i)+1) satisfying val(h)+sum(i,val(x(i)))=t. E(A,a,t) denotes boundaryTimeSliceEquiv. head and tail below return natural coordinate values. No positivity or head-dominance assumption is required.

**Definition 1.12 (Occupation from head and tail capacities).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall A \in \mathbb{N},\; \forall a \in Function\left(I, \mathbb{N}\right),\; K\left(A, a\right) = \sum_{i:Option\left(I\right)}{nsmul\left(OptionElim\left(i, A, a\right), singleton\left(i\right)\right)}\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/OccupancyWordSectors.capacityOccupation` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

OptionElim(i,A,a) is A for none and a(j) for some(j). The definition takes Mathlib's inverse Sym.equivNatSumOfFintype at total A+sum(i,a(i)); its existing inverse-coordinate law identifies the resulting multiset with this finite sum.

**Theorem 1.13 (Total capacity is the actual occupation length).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall A \in \mathbb{N},\; \forall a \in Function\left(I, \mathbb{N}\right),\; card\left(K\left(A, a\right)\right) = A + \sum_{i:I}{a\left(i\right)}\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.capacity_occupation_card` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The cardinality comes from the fixed-cardinality Sym carrier of the inverse equivalence.

**Theorem 1.14 (Every occupation coordinate is its capacity).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall A \in \mathbb{N},\; \forall a \in Function\left(I, \mathbb{N}\right),\; \forall i \in Option\left(I\right),\; count\left(K\left(A, a\right), i\right) = OptionElim\left(i, A, a\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.capacity_occupation_count` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

This uses the existing forward coordinate law and inverse cancellation.

**Definition 1.15 (Actual boundaries are actual bounded coordinates).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall A \in \mathbb{N},\; \forall a \in Function\left(I, \mathbb{N}\right),\; \forall t \in \mathbb{N},\; E\left(A, a, t\right):Equiv\left(Boundary\left(K\left(A, a\right), t\right), TimeSlice\left(A, a, t\right)\right)\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/OccupancyWordSectors.boundaryTimeSliceEquiv` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Multiset.le_iff_count restricts Mathlib's existing equivalence to the coordinate bounds; separating none from some coordinates gives the landed TimeSlice. The inverse reconstructs the actual multiset, with both inverse laws proved.

**Theorem 1.16 (The equivalence preserves each actual count).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall A \in \mathbb{N},\; \forall a \in Function\left(I, \mathbb{N}\right),\; \forall t \in \mathbb{N},\; \forall b \in Boundary\left(K\left(A, a\right), t\right),\; head\left(E\left(A, a, t, b\right)\right) = count\left(val\left(b\right), none\right) \land \left(\forall i \in I,\; tail\left(E\left(A, a, t, b\right), i\right) = count\left(val\left(b\right), some\left(i\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.boundary_time_slice_coordinates` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The head and every tail are the original submultiset counts.

**Theorem 1.17 (The two actual counts agree).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall A \in \mathbb{N},\; \forall a \in Function\left(I, \mathbb{N}\right),\; \forall t \in \mathbb{N},\; card\left(boundaries\left(K\left(A, a\right), t\right)\right) = sliceCount\left(A, a, t\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupancyWordSectors.boundary_count_eq_sliceCount` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Fintype.card_congr applies to the bounded equivalence. This is the generic bridge consumed by the concrete history rank; no separate count table is used.

## References

- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.boundaryTimeSliceEquiv`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.boundary_count_eq_sliceCount`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.boundary_spec`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.boundary_time_slice_coordinates`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.capacityOccupation`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.capacity_occupation_card`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.capacity_occupation_count`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.complement_card`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.complement_injective`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.multiplicity_eq_factorial`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.multiplicity_erase_mul`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.multiplicity_pos`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.occupation_append`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.occupation_card`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.occupation_representative`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.sector_gram`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupancyWordSectors.sector_words_card_multinomial`
- Dependency: [D5/S1/Ledger/BoundedTimeSlice](../../../S1/Ledger/BoundedTimeSlice.md)
