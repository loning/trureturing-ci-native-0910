# Occupation Physical Preparation

## Abstract

Occupation histories admit actual sequential pure-state circuits on one common memory, and their maximum cut rank is the attained least memory dimension.

A is a finite alphabet with decidable equality unless a weaker context is explicitly displayed. a is a multiset, L=card(a), and Word(A,n)=Fin(n) to A. B(a,t)=Boundary(a,t) consists of multisets val(b)<=a with card(val(b))=t. R(a)=boundaryMaximum(a) is the maximum of card(B(a,t)) over 0<=t<=L. M(n,r)=multiplicity(n,r) counts actual length-n words of occupation r. V(n,r,w)=sectorVector(n,r,w) is the complex inverse square root of M(n,r) on those words, and zero otherwise. All square roots below are nonnegative real roots included in the complex numbers where multiplied by V.

Space(I), Unitary(I), e(j)=basis(j), C(U,n,t), P(U,n,m,t), Bstate(blank,n,j), and delta are the actual Hilbert spaces, unitaries, basis vectors, full and partial circuits, blank basis state, and coordinate delta of SequentialRegisterCircuit. They act on all n physical slots and one common memory. J(slots,x)=slotInitialized(slots,x) inserts x at the physical word slots, including the empty word. It is a coordinate linear isometry.

**Definition 1.1 (Every cut carrier embeds into the same maximum memory).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall t \in \mathbb{N},\; t \le card\left(a\right) \Rightarrow E\left(a, t\right) \in Embedding\left(B\left(a, t\right), Fin\left(R\left(a\right)\right)\right)\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.boundaryEmbedding` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

E(a,t)=boundaryEmbedding(a,t,ht) is chosen from the actual cardinality bound, where ht:t<=card(a). R(a)>0, since the time-zero boundary is a singleton. Neither a blank symbol nor finiteness of A is needed for this embedding.

**Theorem 1.2 (Every feasible cut size is bounded by the maximum).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall t \in \mathbb{N},\; t \le card\left(a\right) \Rightarrow card\left(B\left(a, t\right)\right) \le R\left(a\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.boundary_card_le_maximum` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The proof instantiates the finite supremum bound; this companion is used both for the embeddings and the physical cut bound.

S(a,t)=nextStep(a,t) has rows (i,c) in A x B(a,t+1) and columns b in B(a,t). Its coefficient is sqrt(count(a-val(b),i)/(L-t)) if val(c)=val(b)+{i}, and zero otherwise. The denominator L-t is natural subtraction before real division. The existing next_step_gram proves S dagger S=1 when t<L. Jcoord(e) is the coordinate isometry; Binj(blank,e)(b)=(blank,e(b)), and Oinj(f)(i,c)=(i,f(c)).

**Theorem 1.3 (The actual Gram isometry extends to the common register).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall K \in Type,\; \left(Fintype\left(K\right) \land DecidableEq\left(K\right)\right) \Rightarrow \left(\forall blank \in A,\; \forall t \in \mathbb{N},\; t < card\left(a\right) \Rightarrow \left(\forall e \in Embedding\left(B\left(a, t\right), K\right),\; \forall f \in Embedding\left(B\left(a, t + 1\right), K\right),\; \exists U \in Unitary\left(Prod\left(A, K\right)\right),\; \left(\forall x \in Space\left(B\left(a, t\right)\right),\; U\left(Jcoord\left(Binj\left(blank, e\right), x\right)\right) = Jcoord\left(Oinj\left(f\right), toEuclideanLin\left(S\left(a, t\right), x\right)\right)\right) \land \left(\left(\forall b \in B\left(a, t\right),\; \forall i \in A,\; \forall c \in B\left(a, t + 1\right),\; U\left(basis\left(pair\left(blank, e\left(b\right)\right)\right), pair\left(i, f\left(c\right)\right)\right) = entry\left(S\left(a, t\right), pair\left(i, c\right), b\right)\right) \land \left(\forall b \in B\left(a, t\right),\; \forall i \in A,\; \forall k \in K,\; OutsideRange\left(k, f\right) \Rightarrow U\left(basis\left(pair\left(blank, e\left(b\right)\right)\right), pair\left(i, k\right)\right) = 0\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.fixed_register_next_step_coefficients` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The first conjunct is agreement for every input vector, the second gives each matrix entry, and the third proves zero outside the next boundary image. The current S.next_step_gram is consumed by this unitary extension.

occupationUnitary(blank,a,t) chooses the preceding unitary using E(a,t) and E(a,t+1) for each t:Fin(L). G(blank,a,t)=occupationGates is this unitary at t<L and the identity at later times. terminalBoundary(a) is the total occupation a; terminalMemory(a)=E(a,L)(terminalBoundary(a)). Denote it by kend(a). The initial boundary bzero(a) is the empty occupation. F(a,n,t,w,b)=contraction from the current SequentialOccupationHistory: F(a,0,t,w,b)=delta(val(b),a), and its successor sums S(a,t)((w(0),c),b) F(a,n,t+1,tail(w),c) over c:B(a,t+1).

**Definition 1.4 (Time-dependent occupation gates use one fixed Hilbert space).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall blank \in A,\; \forall t \in \mathbb{N},\; \left(t < card\left(a\right) \Rightarrow G\left(blank, a, t\right) = occupationUnitary\left(blank, a, t\right)\right) \land \left(card\left(a\right) \le t \Rightarrow G\left(blank, a, t\right) = identity\left(Space\left(Prod\left(A, Fin\left(R\left(a\right)\right)\right)\right)\right)\right)\right)\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.occupationGates` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The active branch carries the proof t<L needed for its Fin(L) index. This definition specifies unitaries independently of the full output amplitudes.

**Theorem 1.5 (The actual occupation circuit has a decoupled terminal memory).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall blank \in A,\; \forall n \in \mathbb{N},\; \forall t \in \mathbb{N},\; card\left(a\right) = t + n \Rightarrow \left(\forall b \in B\left(a, t\right),\; \forall w \in Word\left(A, n\right),\; \forall k \in Fin\left(R\left(a\right)\right),\; C\left(G\left(blank, a\right), n, t, Bstate\left(blank, n, E\left(a, t, b\right)\right), pair\left(w, k\right)\right) = F\left(a, n, t, w, b\right) \cdot delta\left(k, kend\left(a\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.occupation_circuit_coefficients` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Induction on remaining slots uses occupation_gate_sum to restrict the real memory sum to the next embedded boundary. The zero case uses uniqueness of the terminal boundary. This is the live operator proof of attainment.

**Theorem 1.6 (Partial circuits remain in the reached boundary image).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall blank \in A,\; \forall n \in \mathbb{N},\; \forall m \in \mathbb{N},\; \forall t \in \mathbb{N},\; \left(m \le n \land t + m \le card\left(a\right)\right) \Rightarrow \left(\forall b \in B\left(a, t\right),\; \forall w \in Word\left(A, n\right),\; \forall k \in Fin\left(R\left(a\right)\right),\; OutsideRange\left(k, E\left(a, t + m\right)\right) \Rightarrow P\left(G\left(blank, a\right), n, m, t, Bstate\left(blank, n, E\left(a, t, b\right)\right), pair\left(w, k\right)\right) = 0\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.occupation_reachable_memory` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

This is an exact zero coefficient outside the actual reached subspace. Unvisited physical slots remain blank by the general circuit theorem.

**Theorem 1.7 (A homogeneous blank prepares the normalized whole history).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall blank \in A,\; norm\left(Bstate\left(blank, card\left(a\right), E\left(a, 0, bzero\left(a\right)\right)\right)\right) = 1 \land \left(norm\left(C\left(G\left(blank, a\right), card\left(a\right), 0, Bstate\left(blank, card\left(a\right), E\left(a, 0, bzero\left(a\right)\right)\right)\right)\right) = 1 \land \left(\forall w \in Word\left(A, card\left(a\right)\right),\; \forall k \in Fin\left(R\left(a\right)\right),\; eval\left(C\left(G\left(blank, a\right), card\left(a\right), 0, Bstate\left(blank, card\left(a\right), E\left(a, 0, bzero\left(a\right)\right)\right)\right), pair\left(w, k\right)\right) = V\left(card\left(a\right), a, w\right) \cdot delta\left(k, kend\left(a\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.fixed_register_sufficiency` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Initial=Bstate(blank,L,E(a,0)(bzero(a))) and Output=C(G(blank,a),L,0)(Initial). All slots are retained and the terminal memory is a fixed pure basis state.

**Theorem 1.8 (The actual circuit exists also for an empty alphabet).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \exists slots \in Word\left(A, card\left(a\right)\right),\; \exists kzero \in Fin\left(R\left(a\right)\right),\; \exists kend \in Fin\left(R\left(a\right)\right),\; \exists U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, Fin\left(R\left(a\right)\right)\right)\right)\right),\; \left(\forall i \in Fin\left(card\left(a\right)\right),\; \forall j \in Fin\left(card\left(a\right)\right),\; slots\left(i\right) = slots\left(j\right)\right) \land \left(norm\left(e\left(pair\left(slots, kzero\right)\right)\right) = 1 \land \left(norm\left(C\left(U, card\left(a\right), 0, e\left(pair\left(slots, kzero\right)\right)\right)\right) = 1 \land \left(\forall w \in Word\left(A, card\left(a\right)\right),\; \forall k \in Fin\left(R\left(a\right)\right),\; C\left(U, card\left(a\right), 0, e\left(pair\left(slots, kzero\right)\right), pair\left(w, k\right)\right) = V\left(card\left(a\right), a, w\right) \cdot delta\left(k, kend\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.fixed_register_sufficiency_all` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

When a=0 the physical word is Fin.elim0 and all gates are identity. This branch requests no element of A. Otherwise a symbol in a supplies the homogeneous blank and the proved occupation circuit supplies output.

**Theorem 1.9 (Eight physical slots suffice with twelve memory states).**

$$\exists kzero \in Fin\left(12\right),\; \exists kend \in Fin\left(12\right),\; \exists U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(Option\left(Fin\left(3\right)\right), Fin\left(12\right)\right)\right)\right),\; norm\left(Bstate\left(none, 8, kzero\right)\right) = 1 \land \left(norm\left(C\left(U, 8, 0, Bstate\left(none, 8, kzero\right)\right)\right) = 1 \land \left(\forall w \in Word\left(Option\left(Fin\left(3\right)\right), 8\right),\; \forall k \in Fin\left(12\right),\; C\left(U, 8, 0, Bstate\left(none, 8, kzero\right), pair\left(w, k\right)\right) = V\left(8, ast, w\right) \cdot delta\left(k, kend\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.fixed_register_5040_sufficiency` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

ast is the existing occupation5040 on Option(Fin(3)), with counts (4;2,1,1). ConcreteInitial=Bstate(none,8,kzero). Values 8 and 12 are transported from occupation_5040_card and occupation_5040_boundary_maximum.

**Definition 1.10 (Preparation means actual normalized separated output).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall K \in Type,\; Fintype\left(K\right) \Rightarrow \left(\forall slots \in Word\left(A, card\left(a\right)\right),\; \forall x \in Space\left(K\right),\; \forall y \in Space\left(K\right),\; \forall U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, K\right)\right)\right),\; tuple\left(slots, x, y, U\right) \in PreparationData\left(a, K\right) \Leftrightarrow \left(\left(\forall i \in Fin\left(card\left(a\right)\right),\; \forall j \in Fin\left(card\left(a\right)\right),\; slots\left(i\right) = slots\left(j\right)\right) \land \left(norm\left(x\right) = 1 \land \left(norm\left(y\right) = 1 \land \left(\forall w \in Word\left(A, card\left(a\right)\right),\; \forall k \in K,\; C\left(U, card\left(a\right), 0, J\left(slots, x\right), pair\left(w, k\right)\right) = V\left(card\left(a\right), a, w\right) \cdot y\left(k\right)\right)\right)\right)\right)\right)\right)\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.Preparation` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Preparation(a,K) is the Lean structure carrying exactly this data and its four proof fields. PreparationData forgets the proof fields. The initial and terminal memory vectors are arbitrary unit vectors. No rank inequality, factorization or claimed minimum is included in membership.

**Theorem 1.11 (Separated physical output yields an actual constant-memory chain).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall n \in \mathbb{N},\; \forall slots \in Word\left(A, n\right),\; \forall U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, K\right)\right)\right),\; \forall x \in Space\left(K\right),\; \forall y \in Space\left(K\right),\; \forall psi \in Function\left(Word\left(A, n\right), \mathbb{C}\right),\; \left(\left(\forall i \in Fin\left(n\right),\; \forall j \in Fin\left(n\right),\; slots\left(i\right) = slots\left(j\right)\right) \land \left(norm\left(y\right) = 1 \land \left(\forall w \in Word\left(A, n\right),\; \forall k \in K,\; C\left(U, n, 0, J\left(slots, x\right), pair\left(w, k\right)\right) = psi\left(w\right) \cdot y\left(k\right)\right)\right)\right) \Rightarrow \left(\exists c \in FiniteChain\left(A, K\right),\; \exists initial \in Function\left(K, \mathbb{C}\right),\; length\left(c\right) = n \land \left(\left(\forall r \in \mathbb{N},\; r \le n \Rightarrow card\left(cutBond\left(c, r\right)\right) = card\left(K\right)\right) \land \left(\left(\forall w \in Word\left(A, n\right),\; amp\left(c, initial, w\right) = apply\left(psi, w\right)\right) \land maximumBond\left(c\right) = card\left(K\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.circuit_to_chain` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Only y is normalized in this bridge; x may be arbitrary. A nonzero coordinate y(k) supplies the algebraic terminal cap and initial(j)=x(j)/y(k). For n>0 the proven circuit_initialized_coefficients derives the chain amplitude. For n=0 a terminal chain works without selecting a blank symbol.

**Theorem 1.12 (Every preparation yields the chain needed for necessity).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall K \in Type,\; Fintype\left(K\right) \Rightarrow \left(\forall p \in Preparation\left(a, K\right),\; \exists c \in FiniteChain\left(A, K\right),\; \exists initial \in Function\left(K, \mathbb{C}\right),\; length\left(c\right) = card\left(a\right) \land \left(\left(\forall r \in \mathbb{N},\; r \le card\left(a\right) \Rightarrow card\left(cutBond\left(c, r\right)\right) = card\left(K\right)\right) \land \left(\left(\forall w \in Word\left(A, card\left(a\right)\right),\; amp\left(c, initial, w\right) = apply\left(w \mapsto V\left(card\left(a\right), a, w\right), w\right)\right) \land maximumBond\left(c\right) = card\left(K\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.preparation_to_chain` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The output equality of p supplies the target amplitude. Every actual cut carrier has card(K), including both endpoints, and so does its maximum.

**Theorem 1.13 (Every exact sequential pure preparation needs the maximum cut rank).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall K \in Type,\; Fintype\left(K\right) \Rightarrow \left(\forall p \in Preparation\left(a, K\right),\; R\left(a\right) \le card\left(K\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.physical_memory_necessity` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The derived physical-to-chain bridge supplies the hypotheses of the existing maximum_bond_necessity theorem. Necessity is derived from actual output.

**Theorem 1.14 (Every cut retains its actual coefficient rank and memory bound).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall K \in Type,\; Fintype\left(K\right) \Rightarrow \left(\forall p \in Preparation\left(a, K\right),\; \forall t \in \mathbb{N},\; t \le card\left(a\right) \Rightarrow \left(rank\left(coefficient\left(a, t, card\left(a\right) - t\right)\right) = card\left(B\left(a, t\right)\right) \land card\left(B\left(a, t\right)\right) \le card\left(K\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.physical_cut_necessity` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The coefficient matrix is the actual complex word coefficient matrix. Natural subtraction L-t is used only under t<=L.

**Definition 1.15 (Achievable dimensions quantify actual preparations).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall d \in \mathbb{N},\; d \in achievablePhysicalMemories\left(a\right) \Leftrightarrow \left(\exists p \in Preparation\left(a, Fin\left(d\right)\right),\; True\left(\right)\right)\right)\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.achievablePhysicalMemories` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

This is exactly {d : Nat | Nonempty(Preparation(a,Fin(d)))}. It includes normalized initial and terminal memory, homogeneous slots, actual unitaries and separated exact output through the preceding structure definition.

**Theorem 1.16 (The maximum dimension is physically attained).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; R\left(a\right) \in achievablePhysicalMemories\left(a\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.physical_attainment` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The all-alphabets circuit supplies basis initial and terminal memory. preparation_of_basis packages those actual unit vectors and its output proof.

**Theorem 1.17 (Necessity and attainment give the least physical memory).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; R\left(a\right) \in achievablePhysicalMemories\left(a\right) \land \left(\forall d \in \mathbb{N},\; d \in achievablePhysicalMemories\left(a\right) \Rightarrow R\left(a\right) \le d\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.physical_memory_minimum` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

This is IsLeast(achievablePhysicalMemories(a),R(a)), with both membership and a lower bound for every member. It asserts neither attainability of every larger dimension nor computable numerical matrices for the gates.

**Theorem 1.18 (The least physical memory for 5040 is twelve).**

$$12 \in achievablePhysicalMemories\left(ast\right) \land \left(\forall d \in \mathbb{N},\; d \in achievablePhysicalMemories\left(ast\right) \Rightarrow 12 \le d\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.physical_5040_memory_minimum` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Membership consumes physical_5040_attainment from the actual eight-slot circuit. The lower bound transports the general physical minimum.

For L=t+s, p(a,t,s,b) is the real product over z:A of binomial(count(a,z), count(val(b),z)), divided by binomial(t+s,t). In the following display, factorial divisions for M are natural divisions, while the ratio of three multiplicities and p are real divisions. coefficient(a,t,s) has entry V(t+s,a,append(u,v)); rank is its actual complex linear algebra rank. sigma(a,t,s,b) denotes the existing schmidtCoefficient. Its square is the multiplicity ratio, and sigma=sqrt(p). star denotes complex conjugation. FinsetSup(range(L+1),f) includes all cuts 0 through L.

**Theorem 1.19 (All general coherent-history clauses occur in one terminal consumer).**

$$\forall A \in Type,\; DecidableEq\left(A\right) \Rightarrow \left(Fintype\left(A\right) \Rightarrow \left(\forall a \in Multiset\left(A\right),\; \forall t \in \mathbb{N},\; \forall s \in \mathbb{N},\; card\left(a\right) = t + s \Rightarrow \left(\left(\forall u \in Word\left(A, t\right),\; \forall v \in Word\left(A, s\right),\; V\left(t + s, a, append\left(u, v\right)\right) = \sum_{b:B\left(a, t\right)}{\sqrt{\frac{\prod_{z:A}{binomial\left(count\left(a, z\right), count\left(val\left(b\right), z\right)\right)}}{binomial\left(t + s, t\right)}} \cdot V\left(t, val\left(b\right), u\right) \cdot V\left(s, a - val\left(b\right), v\right)}\right) \land \left(M\left(t + s, a\right) = \frac{factorial\left(t + s\right)}{\prod_{z:A}{factorial\left(count\left(a, z\right)\right)}} \land \left(\sum_{w:Word\left(A, t + s\right)}{star\left(V\left(t + s, a, w\right)\right) \cdot V\left(t + s, a, w\right)} = 1 \land \left(\left(\forall b \in B\left(a, t\right),\; M\left(t, val\left(b\right)\right) = \frac{factorial\left(t\right)}{\prod_{z:A}{factorial\left(count\left(val\left(b\right), z\right)\right)}}\right) \land \left(\left(\forall b \in B\left(a, t\right),\; M\left(s, a - val\left(b\right)\right) = \frac{factorial\left(s\right)}{\prod_{z:A}{factorial\left(count\left(a - val\left(b\right), z\right)\right)}}\right) \land \left(\left(\forall b \in B\left(a, t\right),\; \frac{M\left(t, val\left(b\right)\right) \cdot M\left(s, a - val\left(b\right)\right)}{M\left(t + s, a\right)} = \frac{\prod_{z:A}{binomial\left(count\left(a, z\right), count\left(val\left(b\right), z\right)\right)}}{binomial\left(t + s, t\right)}\right) \land \left(\left(\forall b \in B\left(a, t\right),\; 0 < sigma\left(a, t, s, b\right)\right) \land \left(\left(\forall b \in B\left(a, t\right),\; 0 < \frac{\prod_{z:A}{binomial\left(count\left(a, z\right), count\left(val\left(b\right), z\right)\right)}}{binomial\left(t + s, t\right)}\right) \land \left(\left(\forall b \in B\left(a, t\right),\; \forall c \in B\left(a, t\right),\; \sum_{u:Word\left(A, t\right)}{star\left(V\left(t, val\left(b\right), u\right)\right) \cdot V\left(t, val\left(c\right), u\right)} = delta\left(b, c\right) \land \sum_{v:Word\left(A, s\right)}{star\left(V\left(s, a - val\left(b\right), v\right)\right) \cdot V\left(s, a - val\left(c\right), v\right)} = delta\left(b, c\right)\right) \land \left(rank\left(coefficient\left(a, t, s\right)\right) = card\left(B\left(a, t\right)\right) \land \left(FinsetSup\left(range\left(card\left(a\right) + 1\right), t \mapsto rank\left(coefficient\left(a, t, card\left(a\right) - t\right)\right)\right) = R\left(a\right) \land \left(\left(R\left(a\right) \in achievableMaximumBonds\left(a\right) \land \left(\forall d \in \mathbb{N},\; d \in achievableMaximumBonds\left(a\right) \Rightarrow R\left(a\right) \le d\right)\right) \land \left(R\left(a\right) \in achievablePhysicalMemories\left(a\right) \land \left(\forall d \in \mathbb{N},\; d \in achievablePhysicalMemories\left(a\right) \Rightarrow R\left(a\right) \le d\right)\right)\right)\right)\right)\right)\right)\right)\right)\right)\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.coherent_history_clause_assembly` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The thirteen conjuncts are equation (7); total factorial count; whole-state normalization; past and future factorial counts; equation (8); positive Schmidt coefficients and positive weights; both Gram equations; actual coefficient rank; its maximum; and both the algebraic and physical attained minima. The existing C/S and word-sector results supply the earlier clauses.

**Theorem 1.20 (The concrete ranks and both attained minima are transported together).**

$$ListMap\left(t \mapsto rank\left(coefficient\left(ast, t, 8 - t\right)\right), range\left(9\right)\right) = list\left(1, 4, 8, 11, 12, 11, 8, 4, 1\right) \land \left(FinsetSup\left(range\left(9\right), t \mapsto rank\left(coefficient\left(ast, t, 8 - t\right)\right)\right) = 12 \land \left(rank\left(coefficient\left(ast, 4, 4\right)\right) = 12 \land \left(\left(12 \in achievableMaximumBonds\left(ast\right) \land \left(\forall d \in \mathbb{N},\; d \in achievableMaximumBonds\left(ast\right) \Rightarrow 12 \le d\right)\right) \land \left(12 \in achievablePhysicalMemories\left(ast\right) \land \left(\forall d \in \mathbb{N},\; d \in achievablePhysicalMemories\left(ast\right) \Rightarrow 12 \le d\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.coherent_history_5040_clause_assembly` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

These five conjuncts use the existing rank sequence, maximum and middle rank, the existing algebraic minimum, and the physical minimum proved here. There is no new enumeration or certified numerical instance.

The physical model uses time-dependent gates, one common complex memory, and actual retained homogeneous physical slots. It is distinct from a stationary realization and from the prediction problem with dimension 16. These are known occupation/Dicke-state constructions, without a novelty claim. This terminal companion supplies formal clauses; it does not itself record independent review, canonical atom coverage or completion of the broader research objective.

## References

- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.Preparation`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.achievablePhysicalMemories`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.boundaryEmbedding`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.boundary_card_le_maximum`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.circuit_to_chain`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.coherent_history_5040_clause_assembly`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.coherent_history_clause_assembly`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.fixed_register_5040_sufficiency`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.fixed_register_next_step_coefficients`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.fixed_register_sufficiency`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.fixed_register_sufficiency_all`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.occupationGates`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.occupation_circuit_coefficients`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.occupation_reachable_memory`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.physical_5040_memory_minimum`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.physical_attainment`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.physical_cut_necessity`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.physical_memory_minimum`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.physical_memory_necessity`
- Truth anchor: `D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation.preparation_to_chain`
- Dependency: [D5/S3/Quantum/Entanglement/SequentialRegisterCircuit](SequentialRegisterCircuit.md)
