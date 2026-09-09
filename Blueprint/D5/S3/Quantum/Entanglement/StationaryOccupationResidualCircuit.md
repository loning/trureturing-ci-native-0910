# Stationary Occupation Residual Circuits

## Abstract

Last-tail residual vectors determine every coefficient of a stationary occupation circuit.

A and K are finite types with decidable equality. Space(K) is the complex Euclidean space, and Unitary(A x K) is its physical register unitary group. Word(A,n) consists of functions Fin(n) to A. The multiset occ(w) records the occupation of w. C(U,n,t,z,w,k) denotes the coefficient (w,k) of the actual circuit with the constant schedule U, n slots and starting time t. J(blank,n,x) initializes all slots with blank and the memory with x. B(blank,x) inserts the memory into one fresh blank slot.

**Definition 1.1 (Last-tail multiplicity).**

Lean statement: `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.lastTailMass`

*Formalization.* `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.lastTailMass` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For a chosen head letter q, R(q,b) is the sum of the counts of all letters other than q. The last-tail mass is R(q,b) M(card(b),b)/card(b), where M counts actual occupation words. Division is real division. The head slice S(q,b,h) replaces the head count by h and preserves every tail count.

**Theorem 1.2 (Removing one head letter).**

$$\forall A \in Type,\; \left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \Rightarrow \left(\forall q \in A,\; \forall b \in Multiset\left(A\right),\; \forall h \in \mathbb{N},\; \left(0 < h \land 0 < R\left(q, b\right)\right) \Rightarrow sqrtC\left(headProbability\left(h, R\left(q, b\right)\right)\right) \cdot sqrtC\left(lastTailMass\left(q, S\left(q, b, h\right)\right)\right) = sqrtC\left(lastTailMass\left(q, S\left(q, b, h - 1\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.head_slice_head_amplitude` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

sqrtC is the nonnegative real square root included in the complex numbers. The multiplicity erase identity proves this equality, including the case R(q,b)=1. Subtraction in the head index is natural subtraction.

**Definition 1.3 (Residual memory vectors).**

Lean statement: `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.paddingResidual`

*Formalization.* `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.paddingResidual` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

If b is a submultiset of a and R(q,b)>0, paddingResidual(q,a,b) sums sqrtC(lastTailMass(q,S(q,b,h))) times the basis vector indexed by the tail occupation of b and h, for 0<=h<=count(b,q). When the tail is empty it is the sink basis vector. It is zero when b is not a submultiset of a. physicalResidual transports this vector through the exact finite memory equivalence.

Step(a,blank,U,r) means that for every nonzero b<=a and every i:A and k:K, the (i,k) coefficient of U(B(blank,r(b))) equals r(erase(b,i))(k) if i belongs to b, and equals zero otherwise. Here r maps multisets to Space(K). IndicatorEq(c,b,v) means v if c=b and zero otherwise.

**Theorem 1.4 (Local residual equations determine the output).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(\left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \land \left(Fintype\left(K\right) \land DecidableEq\left(K\right)\right)\right) \Rightarrow \left(\forall blank \in A,\; \forall U \in Unitary\left(Prod\left(A, K\right)\right),\; \forall a \in Multiset\left(A\right),\; \forall r \in Function\left(Multiset\left(A\right), Space\left(K\right)\right),\; \forall f \in Space\left(K\right),\; \left(r\left(0\right) = f \land Step\left(a, blank, U, r\right)\right) \Rightarrow \left(\forall n \in \mathbb{N},\; \forall t \in \mathbb{N},\; \forall b \in Multiset\left(A\right),\; \left(card\left(b\right) = n \land b \le a\right) \Rightarrow \left(\forall w \in Word\left(A, n\right),\; \forall k \in K,\; C\left(U, n, t, J\left(blank, n, r\left(b\right)\right), w, k\right) = IndicatorEq\left(occ\left(w\right), b, f\left(k\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.circuit_output_of_residuals` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Induction on the number of slots uses the actual circuit recursion. A legal first letter erases one occurrence from the remaining multiset; an absent first letter makes the coefficient zero. The empty word uses r(0)=f. This includes all legal and illegal words.

**Theorem 1.5 (Normalized equal-phase occupation output).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(\left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \land \left(Fintype\left(K\right) \land DecidableEq\left(K\right)\right)\right) \Rightarrow \left(\forall blank \in A,\; \forall U \in Unitary\left(Prod\left(A, K\right)\right),\; \forall a \in Multiset\left(A\right),\; \forall r \in Function\left(Multiset\left(A\right), Space\left(K\right)\right),\; \forall f \in Space\left(K\right),\; \left(r\left(0\right) = f \land Step\left(a, blank, U, r\right)\right) \Rightarrow \left(\forall w \in Word\left(A, card\left(a\right)\right),\; \forall k \in K,\; C\left(U, card\left(a\right), 0, J\left(blank, card\left(a\right), scale\left(InvRoot\left(a\right), r\left(a\right)\right)\right), w, k\right) = sector\left(card\left(a\right), a, w\right) \cdot f\left(k\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.normalized_output_of_residuals` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

InvRoot(a) is the complex inverse of the square root of M(card(a),a). The sector coefficient is this same positive real amplitude on words of occupation a and zero on every other word. Linearity transfers the unnormalized coefficient identity to the scaled input.

**Theorem 1.6 (The exact output fixes the initial norm).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(\left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \land \left(Fintype\left(K\right) \land DecidableEq\left(K\right)\right)\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall blank \in A,\; \forall U \in Unitary\left(Prod\left(A, K\right)\right),\; \forall x \in Space\left(K\right),\; \forall sink \in K,\; \left(\forall w \in Word\left(A, card\left(a\right)\right),\; \forall k \in K,\; C\left(U, card\left(a\right), 0, J\left(blank, card\left(a\right), x\right), w, k\right) = sector\left(card\left(a\right), a, w\right) \cdot basis\left(sink, k\right)\right) \Rightarrow norm\left(x\right) = 1\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.initial_norm_of_sector_output` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The occupation sector has norm one. Embedding it into the sink memory preserves that norm, while the actual unitary circuit and initialization preserve the norm of x. No initial normalization hypothesis is used.

**Theorem 1.7 (Concrete transitions suffice for attainment).**

$$\forall A \in Type,\; \left(\left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \land Nonempty\left(A\right)\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; ResidualStep\left(a\right) \Rightarrow Target\left(a\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.target_of_residual_step` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

ResidualStep is Step for the maximal-capacity head as blank, the fixed padding unitary, and physicalResidual(a,-). Target(a) asserts existence of one blank, one unitary on A x Fin(d), and unit initial and final memories, with every coefficient equal to sector(card(a),a,w) times the final memory; d is product(count(a,i)+1) minus the maximum count. The initial memory is InvRoot(a) times physicalResidual(a,a), and the terminal memory is the sink. The argument also includes the zero multiset.

## References

- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.circuit_output_of_residuals`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.head_slice_head_amplitude`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.initial_norm_of_sector_output`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.lastTailMass`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.normalized_output_of_residuals`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.paddingResidual`
- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.target_of_residual_step`
- Dependency: [D5/S3/Quantum/Entanglement/StationaryOccupationPadding](StationaryOccupationPadding.md)
