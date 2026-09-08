# Sequential Register Circuit

## Abstract

Actual time-dependent unitaries on retained physical slots have the coefficients of a finite chain on one common complex memory.

Space(I) is the complex Euclidean Hilbert space on a finite type I; Unitary(I) is its linear isometry equivalence group. e(j) is the coordinate basis vector. delta(i,j) is 1 if i=j and 0 otherwise. Word(A,n)=Fin(n) to A, and Register(A,K,n)=Word(A,n) x K. The same finite complex memory K is used at every time. A and K may inhabit independent universes. U(t) is a unitary on Space(A x K), and t,n,m are natural numbers. No stationarity is assumed.

**Theorem 1.1 (Two embedded isometric copies are related by a unitary).**

$$\forall E \in Type,\; \forall H \in Type,\; ComplexInnerProductSpaces\left(E, H\right) \Rightarrow \left(FiniteDimensional\left(\mathbb{C}, H\right) \Rightarrow \left(\forall source \in LinearIsometry\left(\mathbb{C}, E, H\right),\; \forall target \in LinearIsometry\left(\mathbb{C}, E, H\right),\; \exists U \in LinearIsometryEquiv\left(\mathbb{C}, H, H\right),\; \forall x \in E,\; U\left(source\left(x\right)\right) = target\left(x\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.exists_unitary_agree` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Both spaces are normed additive groups with complex inner products; only H is assumed finite dimensional. The pinned LinearIsometry.extend gives agreement on the range, and injectivity in finite dimension gives surjectivity.

**Definition 1.2 (Coordinate embeddings are actual linear isometries).**

$$\forall E \in Type,\; \forall F \in Type,\; \left(Fintype\left(E\right) \land \left(Fintype\left(F\right) \land \left(DecidableEq\left(E\right) \land DecidableEq\left(F\right)\right)\right)\right) \Rightarrow \left(\forall e \in Embedding\left(E, F\right),\; \forall x \in Space\left(E\right),\; \forall q \in F,\; J\left(e, x, q\right) = \sum_{j:E}{delta\left(e\left(j\right), q\right) \cdot x\left(j\right)}\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.coordinateEmbedding` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

E and F are finite with decidable equality, and e:E embeds into F. J(e) is the isometry obtained from the matrix delta(e(j),q), whose Gram matrix is the identity. It inserts zero in coordinates outside the range.

**Theorem 1.3 (Rectangular isometries extend with exact coordinate support).**

$$\forall A \in Type,\; \forall E \in Type,\; \forall F \in Type,\; \forall K \in Type,\; \left(\left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \land \left(\left(Fintype\left(E\right) \land DecidableEq\left(E\right)\right) \land \left(\left(Fintype\left(F\right) \land DecidableEq\left(F\right)\right) \land \left(Fintype\left(K\right) \land DecidableEq\left(K\right)\right)\right)\right)\right) \Rightarrow \left(\forall blank \in A,\; \forall e \in Embedding\left(E, K\right),\; \forall f \in Embedding\left(F, K\right),\; \forall V \in LinearIsometry\left(\mathbb{C}, Space\left(E\right), Space\left(Prod\left(A, F\right)\right)\right),\; \exists U \in Unitary\left(Prod\left(A, K\right)\right),\; \left(\forall x \in Space\left(E\right),\; U\left(J\left(blankInjection\left(blank, e\right), x\right)\right) = J\left(outputInjection\left(f\right), V\left(x\right)\right)\right) \land \left(\left(\forall x \in Space\left(E\right),\; \forall i \in A,\; \forall j \in F,\; U\left(J\left(blankInjection\left(blank, e\right), x\right), pair\left(i, f\left(j\right)\right)\right) = V\left(x, pair\left(i, j\right)\right)\right) \land \left(\forall x \in Space\left(E\right),\; \forall i \in A,\; \forall k \in K,\; OutsideRange\left(k, f\right) \Rightarrow U\left(J\left(blankInjection\left(blank, e\right), x\right), pair\left(i, k\right)\right) = 0\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.rectangular_unitary_coefficients` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

All four coordinate types are finite with decidable equality. V maps Space(E) isometrically into Space(A x F). blankInjection(j)=(blank,e(j)); outputInjection(i,j)=(i,f(j)). The three conjuncts retain vector agreement, every coefficient in the output range, and zero outside that range.

curry identifies Space(B x C) with the Hilbert direct sum over B of Space(C). block(U) applies U separately in every B slice. lift(e,U) conjugates this block operator by a coordinate equivalence e:R equiv B x C. headRest separates the first physical symbol from (tail word,memory); restHead separates the tail word from (first symbol,memory). First(n,U)=lift(restHead(n),U), while Tail(n,V)=lift(headRest(n),V). compose(f,g) means apply g, then f.

**Theorem 1.4 (Lifted operators act in their specified coordinate slice).**

$$\forall R \in Type,\; \forall B \in Type,\; \forall C \in Type,\; \left(Fintype\left(R\right) \land \left(Fintype\left(B\right) \land Fintype\left(C\right)\right)\right) \Rightarrow \left(\forall e \in Equiv\left(R, Prod\left(B, C\right)\right),\; \forall U \in Unitary\left(C\right),\; \forall x \in Space\left(R\right),\; \forall r \in R,\; lift\left(e, U, x, r\right) = U\left(j \mapsto x\left(inverse\left(e, pair\left(fst\left(e\left(r\right)\right), j\right)\right)\right), snd\left(e\left(r\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.lift_apply` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The lambda is included by WithLp.toLp(2). This is an equality for arbitrary input vectors and coordinate equivalences, not a premise about a target state.

**Definition 1.5 (The full circuit is independent unitary operator composition).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, K\right)\right)\right),\; \forall n \in \mathbb{N},\; \forall t \in \mathbb{N},\; C\left(U, 0, t\right) = identity\left(Register\left(A, K, 0\right)\right) \land C\left(U, n + 1, t\right) = compose\left(Tail\left(n, C\left(U, n, t + 1\right)\right), First\left(n, U\left(t\right)\right)\right)\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.circuit` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Every physical slot remains part of the full Hilbert space. This recursive definition uses only actual unitary operators, without a desired coefficient formula or a chain contraction in its definition.

**Definition 1.6 (Partial circuits retain the full register).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, K\right)\right)\right),\; \forall n \in \mathbb{N},\; \forall m \in \mathbb{N},\; \forall t \in \mathbb{N},\; P\left(U, 0, m, t\right) = identity\left(Register\left(A, K, 0\right)\right) \land \left(P\left(U, n + 1, 0, t\right) = identity\left(Register\left(A, K, n + 1\right)\right) \land P\left(U, n + 1, m + 1, t\right) = compose\left(Tail\left(n, P\left(U, n, m, t + 1\right)\right), First\left(n, U\left(t\right)\right)\right)\right)\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.partialCircuit` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

P(U,n,m,t) denotes partialCircuit. It applies the next m gates, stopping if no slots remain. It always acts on Space(Register(A,K,n)).

**Definition 1.7 (One gate acts on one slot and the common memory).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall U \in Unitary\left(Prod\left(A, K\right)\right),\; \forall n \in \mathbb{N},\; Slot\left(U, n + 1, 0\right) = First\left(n, U\right) \land \left(\forall q \in Fin\left(n\right),\; Slot\left(U, n + 1, succ\left(q\right)\right) = Tail\left(n, Slot\left(U, n, q\right)\right)\right)\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.slotGate` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

At length zero there is no slot index (Fin(0)), so that branch is empty. Slot denotes slotGate and is independent of the input or desired output state.

**Theorem 1.8 (All other physical coordinates stay fixed).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall U \in Unitary\left(Prod\left(A, K\right)\right),\; \forall n \in \mathbb{N},\; \forall r \in Fin\left(n\right),\; \forall x \in Space\left(Register\left(A, K, n\right)\right),\; \forall w \in Word\left(A, n\right),\; \forall k \in K,\; Slot\left(U, n, r, x, pair\left(w, k\right)\right) = U\left(p \mapsto x\left(pair\left(update\left(w, r, fst\left(p\right)\right), snd\left(p\right)\right)\right), pair\left(w\left(r\right), k\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.slot_gate_apply` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The vector lambda p is included with WithLp.toLp(2). Only the selected symbol and memory coordinate vary inside the slice supplied to U.

**Theorem 1.9 (A successor applies the next gate on the same full space).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, K\right)\right)\right),\; \forall n \in \mathbb{N},\; \forall m \in \mathbb{N},\; \forall t \in \mathbb{N},\; m < n \Rightarrow P\left(U, n, m + 1, t\right) = compose\left(Slot\left(U\left(t + m\right), n, m\right), P\left(U, n, m, t\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.partial_circuit_succ_gate` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

m<n supplies the Fin(n) slot index. The time of this local gate is t+m.

**Theorem 1.10 (Applying every slot equals the full circuit).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, K\right)\right)\right),\; \forall n \in \mathbb{N},\; \forall t \in \mathbb{N},\; P\left(U, n, n, t\right) = C\left(U, n, t\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.partial_circuit_all` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

This equality identifies the independently defined recursive full circuit with the successive same-register slot applications.

blankState(blank,n,j)=e((constant(blank),j)). initialized(blank,n) embeds Space(K) at this constant physical word. B(blank,n,j) and I(blank,n,x) denote these states. The blank symbol is an explicit parameter in the following statements; the occupation companion handles zero slots without asking for one.

**Definition 1.11 (Initialization embeds any memory vector).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall blank \in A,\; \forall n \in \mathbb{N},\; \forall x \in Space\left(K\right),\; I\left(blank, n, x\right) = J\left(blankInjection\left(constant\left(blank, n\right), identityEmbedding\left(K\right)\right), x\right)\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.initialized` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

This is an actual coordinate linear isometry. No normalization of x is needed to define it or to establish the coefficient identity.

**Definition 1.12 (The chain reads local operator matrix coefficients).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, K\right)\right)\right),\; \forall blank \in A,\; \forall k \in K,\; \forall n \in \mathbb{N},\; \forall t \in \mathbb{N},\; Q\left(U, blank, k, 0, t\right) = terminal\left(j \mapsto delta\left(j, k\right)\right) \land Q\left(U, blank, k, n + 1, t\right) = step\left(i \mapsto j \mapsto l \mapsto U\left(t, e\left(pair\left(blank, j\right)\right), pair\left(i, l\right)\right), Q\left(U, blank, k, n, t + 1\right)\right)\right)$$

*Formalization.* `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.unitaryChain` (`✓ std3`).

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Q(U,blank,k,n,t) is unitaryChain, a FiniteChain(A,K) whose next carrier is again K at every step. Its terminal covector selects k. contract takes a list of symbols; amp(Q,x,w) sums x(j) times contract(Q,ofFn(w),j).

**Theorem 1.13 (Actual circuit coefficients equal chain contractions).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, K\right)\right)\right),\; \forall blank \in A,\; \forall n \in \mathbb{N},\; \forall t \in \mathbb{N},\; \forall j \in K,\; \forall k \in K,\; \forall w \in Word\left(A, n\right),\; C\left(U, n, t, B\left(blank, n, j\right), pair\left(w, k\right)\right) = contract\left(Q\left(U, blank, k, n, t\right), ofFn\left(w\right), j\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.circuit_basis_coefficients` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

The live induction on the remaining slots uses first_tail_blank to sum over the actual common memory. The zero case is the actual register identity. This derived identity connects independent operator and chain definitions.

**Theorem 1.14 (Every initial pure memory has the derived chain amplitude).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, K\right)\right)\right),\; \forall blank \in A,\; \forall n \in \mathbb{N},\; \forall t \in \mathbb{N},\; \forall x \in Space\left(K\right),\; \forall w \in Word\left(A, n\right),\; \forall k \in K,\; C\left(U, n, t, I\left(blank, n, x\right), pair\left(w, k\right)\right) = amp\left(Q\left(U, blank, k, n, t\right), x, w\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.circuit_initialized_coefficients` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Basis expansion and linearity extend the proved basis coefficients to arbitrary x, including non-normalized vectors. The physical necessity companion uses this identity for normalized initial and terminal memory.

**Theorem 1.15 (Unvisited slots still contain the homogeneous blank).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, K\right)\right)\right),\; \forall blank \in A,\; \forall n \in \mathbb{N},\; \forall m \in \mathbb{N},\; \forall t \in \mathbb{N},\; \forall j \in K,\; \forall k \in K,\; \forall w \in Word\left(A, n\right),\; \forall r \in Fin\left(n\right),\; \left(m \le val\left(r\right) \land Ne\left(w\left(r\right), blank\right)\right) \Rightarrow P\left(U, n, m, t, B\left(blank, n, j\right), pair\left(w, k\right)\right) = 0\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.unused_slots_zero` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

No m<=n premise is needed: the existence of r with m<=val(r)<n already bounds m. The statement is an exact vanishing coefficient.

**Theorem 1.16 (Unit normalization survives initialization and the circuit).**

$$\forall A \in Type,\; \forall K \in Type,\; \left(Fintype\left(A\right) \land Fintype\left(K\right)\right) \Rightarrow \left(\forall U \in Function\left(\mathbb{N}, Unitary\left(Prod\left(A, K\right)\right)\right),\; \forall blank \in A,\; \forall n \in \mathbb{N},\; \forall t \in \mathbb{N},\; \forall x \in Space\left(K\right),\; norm\left(x\right) = 1 \Rightarrow \left(norm\left(I\left(blank, n, x\right)\right) = 1 \land norm\left(C\left(U, n, t, I\left(blank, n, x\right)\right)\right) = 1\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.initialized_norm` (`✓ std3`). ∎

*Citation.* David Raveh and Rafael I. Nepomechie (2024). *Dicke states as matrix product states*. DOI: [10.1103/PhysRevA.110.052438](https://doi.org/10.1103/PhysRevA.110.052438).

*Commentary.*

Both conjuncts follow from actual isometry norm preservation. No desired output equation, rank bound, or occupation constraint is a premise.

## References

- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.circuit`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.circuit_basis_coefficients`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.circuit_initialized_coefficients`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.coordinateEmbedding`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.exists_unitary_agree`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.initialized`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.initialized_norm`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.lift_apply`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.partialCircuit`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.partial_circuit_all`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.partial_circuit_succ_gate`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.rectangular_unitary_coefficients`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.slotGate`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.slot_gate_apply`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.unitaryChain`
- Truth anchor: `D5/S3/Quantum/Entanglement/SequentialRegisterCircuit.unused_slots_zero`
- Dependency: [D5/S3/Quantum/Entanglement/SequentialOccupationHistory](SequentialOccupationHistory.md)
