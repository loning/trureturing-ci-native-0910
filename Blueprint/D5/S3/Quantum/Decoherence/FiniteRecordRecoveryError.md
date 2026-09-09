# Finite Record Recovery Error

## Abstract

Every CPTP recovery has the finite-record worst-case trace-distance lower bound.

**Theorem 1.1 (Signed coefficient conjugation).**

$$\forall c \in \mathbb{Z} \to \mathbb{C}, ell \in \mathbb{Z},\; \sum_{k \in \mathbb{Z}} {c\left(k - ell\right) \cdot \operatorname{conj}\left(c\left(k\right)\right)} = \operatorname{conj}\left(\sum_{k \in \mathbb{Z}} {c\left(k + ell\right) \cdot \operatorname{conj}\left(c\left(k\right)\right)}\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError.coefficient_gamma_neg` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Reindex the integer sum by translation and commute the scalar factors after conjugation.

**Theorem 1.2 (The exact complex two-coordinate square root).**

$$\forall n \in FiniteType, i \in n, j \in n, z \in \mathbb{C},\; i \ne j \Rightarrow \operatorname{sqrt}\left(\left(\operatorname{single}\left(i, j, z\right) + \operatorname{single}\left(j, i, \operatorname{conj}\left(z\right)\right)\right)^{*} \cdot \left(\operatorname{single}\left(i, j, z\right) + \operatorname{single}\left(j, i, \operatorname{conj}\left(z\right)\right)\right)\right) = \operatorname{single}\left(i, i, \operatorname{norm}\left(z\right)\right) + \operatorname{single}\left(j, j, \operatorname{norm}\left(z\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError.pair_matrix_sqrt` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The two diagonal norm entries form a positive semidefinite matrix whose square is the Gram matrix; uniqueness identifies the positive square root.

**Theorem 1.3 (The exact complex two-coordinate trace norm).**

$$\forall n \in FiniteType, i \in n, j \in n, z \in \mathbb{C},\; i \ne j \Rightarrow \operatorname{traceNorm}\left(\operatorname{single}\left(i, j, z\right) + \operatorname{single}\left(j, i, \operatorname{conj}\left(z\right)\right)\right) = 2 \cdot \operatorname{norm}\left(z\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError.pair_matrix_traceNorm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Take the real trace of the explicit two-coordinate square root.

**Theorem 1.4 (Actual plus and minus density states).**

$$\forall n \in FiniteType, N \in Nat, c \in \mathbb{Z} \to \mathbb{C}, q \in n \to \mathbb{Z}, i \in n, j \in n,\; \left(\left(\left(\forall k \in \mathbb{Z},\; \left(k < 0 \lor N < k\right) \Rightarrow c\left(k\right) = 0\right) \land \sum_{k \in \mathbb{Z}} {\operatorname{norm}\left(c\left(k\right)\right)^{2}} = 1\right) \land i \ne j\right) \Rightarrow \operatorname{let} \forall ell \in \mathbb{Z},\; \gamma\left(ell\right) = \sum_{k \in \mathbb{Z}} {c\left(k + ell\right) \cdot \operatorname{conj}\left(c\left(k\right)\right)}; \operatorname{let} \forall k \in n,\; vp\left(k\right) = \frac{\operatorname{ite}\left(k = i, 1, 0\right) + \operatorname{ite}\left(k = j, 1, 0\right)}{\operatorname{sqrt}\left(2\right)}; \operatorname{let} \forall k \in n,\; vm\left(k\right) = \frac{\operatorname{ite}\left(k = i, 1, 0\right) - \operatorname{ite}\left(k = j, 1, 0\right)}{\operatorname{sqrt}\left(2\right)}; \exists C \in \operatorname{QuantumChannel}\left(n, n\right),\; \left(\forall A \in \operatorname{Matrix}\left(n, n, \mathbb{C}\right), k \in n, l \in n,\; \operatorname{entry}\left(\operatorname{act}\left(C, A\right), k, l\right) = \gamma\left(q\left(k\right) - q\left(l\right)\right) \cdot \operatorname{entry}\left(A, k, l\right)\right) \land \left(\exists rho \in \operatorname{DensityState}\left(n\right), sigma \in \operatorname{DensityState}\left(n\right),\; \left(\left(\operatorname{raw}\left(rho\right) = \operatorname{vecMulVec}\left(vp, \operatorname{conj}\left(vp\right)\right) \land \operatorname{raw}\left(sigma\right) = \operatorname{vecMulVec}\left(vm, \operatorname{conj}\left(vm\right)\right)\right) \land \operatorname{traceDistance}\left(rho, sigma\right) = 1\right) \land \operatorname{traceDistance}\left(\operatorname{mapState}\left(C, rho\right), \operatorname{mapState}\left(C, sigma\right)\right) = \operatorname{norm}\left(\gamma\left(q\left(i\right) - q\left(j\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError.finite_record_pair_witnesses` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Finite support converts the integer normalization to the frozen channel theorem's finite sum. The displayed projectors have trace one, and the exact pair norm computes both distances.

**Theorem 1.5 (Uniform recovery lower bound).**

$$\forall n \in FiniteType, N \in Nat, c \in \mathbb{Z} \to \mathbb{C}, q \in n \to \mathbb{Z}, i \in n, j \in n,\; \left(\left(\left(\forall k \in \mathbb{Z},\; \left(k < 0 \lor N < k\right) \Rightarrow c\left(k\right) = 0\right) \land \sum_{k \in \mathbb{Z}} {\operatorname{norm}\left(c\left(k\right)\right)^{2}} = 1\right) \land q\left(i\right) - q\left(j\right) \ne 0\right) \Rightarrow \left(\forall R \in \operatorname{QuantumChannel}\left(n, n\right),\; \operatorname{let} \forall ell \in \mathbb{Z},\; \gamma\left(ell\right) = \sum_{k \in \mathbb{Z}} {c\left(k + ell\right) \cdot \operatorname{conj}\left(c\left(k\right)\right)}; \operatorname{let} \forall A \in \operatorname{Matrix}\left(n, n, \mathbb{C}\right), k \in n, l \in n,\; \operatorname{entry}\left(\Lambda\left(A\right), k, l\right) = \gamma\left(q\left(k\right) - q\left(l\right)\right) \cdot \operatorname{entry}\left(A, k, l\right); \operatorname{let} \forall rho \in \operatorname{DensityState}\left(n\right),\; error\left(rho\right) = \frac{\operatorname{traceNorm}\left(\operatorname{act}\left(R, \Lambda\left(\operatorname{raw}\left(rho\right)\right)\right) - \operatorname{raw}\left(rho\right)\right)}{2}; \operatorname{let} errors = \operatorname{range}\left(error\right); \left(\left(\left(\forall rho \in \operatorname{DensityState}\left(n\right), sigma \in \operatorname{DensityState}\left(n\right),\; 0 \le \operatorname{traceDistance}\left(rho, sigma\right) \land \operatorname{traceDistance}\left(rho, sigma\right) \le 1\right) \land \operatorname{Nonempty}\left(errors\right)\right) \land \operatorname{BddAbove}\left(errors\right)\right) \land \frac{1 - \operatorname{norm}\left(\gamma\left(q\left(i\right) - q\left(j\right)\right)\right)}{2} \le \operatorname{sSup}\left(errors\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError.finite_record_recovery_error_lower_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Deliver the all-density distance interval from nonnegative trace norm and the unit-trace upper bound. Identify the coefficient error range with the actual composed-channel range and bound it by the interval's upper endpoint. Both witness errors are below its supremum, and two triangle inequalities with CPTP contraction give the bound.

N is any natural number, including zero; c is an arbitrary complex sequence with exactly the stated support and integer-tsum normalization. The finite coordinate type has decidable equality, and other labels may repeat. The nonzero gap can have either sign. All unbounded sums denote Lean tsum.

DensityState and QuantumChannel are the actual canonical FiniteStateChannel carriers. raw applies CStarMatrix.ofMatrix.symm to a state's value. act applies the channel's completely positive map in matrix coordinates, and traceDistance is one half of the actual trace norm from FiniteTraceDistance. The channel C is obtained from the frozen shifted-record recording and partial-trace theorem; its multiplier identity holds for every complex matrix.

The displayed vectors define the pure-state projectors via vecMulVec with pointwise conjugation. Positive semidefiniteness, trace one, original distance one, and channel-image distance equal to the norm of gamma are proved. The pair square-root identity includes zero and arbitrary complex phase.

Every pair of density states has trace distance between zero and one. Trace-norm nonnegativity supplies the lower endpoint, and the triangle inequality with unit trace supplies the upper endpoint. The theorem delivers this entire interval and uses its upper endpoint to bound every recovery error. The error range is over all density states. Its equality with the canonical composed-channel error range, nonemptiness, and upper bound one are proved. Both witness errors lie below its real supremum. Canonical CPTP contraction and the triangle inequality give the lower bound. No compactness, attainment, cosine bound, sharpness, Hamiltonian implementation, recovery algorithm, or physical cost conclusion is asserted.

## References

- Truth anchor: `D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError.coefficient_gamma_neg`
- Truth anchor: `D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError.finite_record_pair_witnesses`
- Truth anchor: `D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError.finite_record_recovery_error_lower_bound`
- Truth anchor: `D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError.pair_matrix_sqrt`
- Truth anchor: `D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError.pair_matrix_traceNorm`
- Dependency: [D5/S3/Quantum/Decoherence/FiniteShiftedRecordChannel](FiniteShiftedRecordChannel.md)
- Dependency: [D5/S3/Quantum/Foundation/FiniteTraceDistance](../Foundation/FiniteTraceDistance.md)
