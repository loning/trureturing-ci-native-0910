# Sharp Finite Shift Autocorrelation

## Abstract

Finite integer-supported complex coefficients have an exact sharp cosine autocorrelation bound.

QUANTUM-REALITY theorem75.1 concerns the original coefficient autocorrelation from definition74.1. The sums below range over all integers, with coefficients zero outside the interval from zero to N. N may be zero, and the positive integer shift may exceed N. Complex coefficients may have arbitrary phases.

**Theorem 1.1 (Universal upper bound).**

$$\forall N \in \mathbb{N}, l \in \mathbb{Z}, c \in \mathbb{Z} \to \mathbb{C},\; \left(\left(l \ge 1 \land \left(\forall n \in \mathbb{Z},\; \left(n < 0 \lor N < n\right) \Rightarrow c\left(n\right) = 0\right)\right) \land \sum_{n \in \mathbb{Z}} {\lvert{c\left(n\right)}\rvert^{2}} = 1\right) \Rightarrow \lvert{\sum_{n \in \mathbb{Z}} {c\left(n + l\right) \cdot \overline{c\left(n\right)}}}\rvert \le \operatorname{cos}(\frac{\pi}{\lfloor\frac{N}{l}\rfloor+2})$$

*Proof.* Machine-checked in Lean as `D5/S3/QuantumBounds/ReferenceFrame/FiniteShiftAutocorrelation.finite_support_autocorrelation_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Set L to the positive shift and q to the natural quotient N/L. Euclidean division transports the squared mass and the actual complex forward products to L residue paths, each padded to q+1 nodes. Support makes the top forward product vanish. Triangle inequality reduces each path to coefficient absolute values. The frozen path-averaging squared bound and finite Cauchy-Schwarz give the homogeneous adjacent-product bound; summing the masses gives the displayed constant.

**Theorem 1.2 (Attainment for every support length and positive shift).**

$$\forall N \in \mathbb{N}, l \in \mathbb{Z},\; l \ge 1 \Rightarrow \left(\exists c \in \mathbb{Z} \to \mathbb{C},\; \left(\left(\forall n \in \mathbb{Z},\; \left(n < 0 \lor N < n\right) \Rightarrow c\left(n\right) = 0\right) \land \sum_{n \in \mathbb{Z}} {\lvert{c\left(n\right)}\rvert^{2}} = 1\right) \land \lvert{\sum_{n \in \mathbb{Z}} {c\left(n + l\right) \cdot \overline{c\left(n\right)}}}\rvert = \operatorname{cos}(\frac{\pi}{\lfloor\frac{N}{l}\rfloor+2})\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/QuantumBounds/ReferenceFrame/FiniteShiftAutocorrelation.finite_support_autocorrelation_attained` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The witness takes the public low sine mode on q+1 nodes, divides by the square root of its positive squared mass, and places the entries at integer indices jL for j from zero to q. All other coefficients are zero. The signed path eigenvector recurrence proves that the actual complex autocorrelation equals the nonnegative real cosine. Taking its norm then gives equality. For q=0 the witness is delta at zero.

This scalar extremum adds no Hamiltonian, recovery-channel, or other resource-model claim. It does not cover theorem75.2 or corollary75.1.

**Theorem 1.3 (Exact source floor and natural quotient).**

$$\forall N \in \mathbb{N}, l \in \mathbb{Z},\; l \ge 1 \Rightarrow \lfloor\frac{N}{l}\rfloor = \operatorname{NatDiv}\left(N, \operatorname{toNat}\left(l\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/QuantumBounds/ReferenceFrame/FiniteShiftAutocorrelation.floor_shift_quotient` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The floor is the integer floor of the real quotient. The right side is natural-number division by the positive integer shift converted to Nat, then cast to Int. Thus the source denominator floor(N/ell)+2 equals the Lean endpoint denominator exactly, including N=0 and ell>N.

## References

- Truth anchor: `D5/S3/QuantumBounds/ReferenceFrame/FiniteShiftAutocorrelation.finite_support_autocorrelation_attained`
- Truth anchor: `D5/S3/QuantumBounds/ReferenceFrame/FiniteShiftAutocorrelation.finite_support_autocorrelation_bound`
- Truth anchor: `D5/S3/QuantumBounds/ReferenceFrame/FiniteShiftAutocorrelation.floor_shift_quotient`
- Dependency: [D5/S3/QuantumBounds/ReferenceFrame/TopEigenspace](TopEigenspace.md)
