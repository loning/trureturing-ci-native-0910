# Stationary Profile Realization

## Abstract

Every bounded tail profile with a legal head is realized by an occupation boundary.

For finite I, capacities a, a head h in Fin(A+1), and a tail profile x in TailBox(a), the bounded occupation construction supplies a boundary at time h.val + tailSum(x). Its none and some coordinates recover h and x.

**Theorem 1.1 (A bounded profile is realized by a boundary).**

$$\forall I \in Type,\; \left(Fintype\left(I\right) \land DecidableEq\left(I\right)\right) \Rightarrow \left(\forall A \in \mathbb{N},\; \forall a \in Function\left(I, \mathbb{N}\right),\; \forall h \in Fin\left(A + 1\right),\; \forall x \in TailBox\left(a\right),\; \exists b \in Boundary\left(capacityOccupation\left(A, a\right), val\left(h\right) + tailSum\left(x\right)\right),\; count\left(val\left(b\right), none\left(\right)\right) = val\left(h\right) \land \left(\forall i \in I,\; count\left(val\left(b\right), some\left(i\right)\right) = val\left(apply\left(x, i\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Entanglement/StationaryProfileRealization.boundary_profile_realization` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The proof transports the explicit profile (h,x) through the existing boundaryTimeSliceEquiv and reads back its coordinates. This is a typed realization interface for later support and block arguments; it does not assert a Gram rank or a stationary minimum.

## References

- Truth anchor: `D5/S3/Quantum/Entanglement/StationaryProfileRealization.boundary_profile_realization`
- Dependency: [D5/S3/Quantum/Entanglement/OccupancyWordSectors](OccupancyWordSectors.md)
