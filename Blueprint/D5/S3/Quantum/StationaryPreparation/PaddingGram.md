# The Gram Entries of Padding Residuals

## Abstract

Padding Gram entries are minimum-head multiplicities within each tail block.

Let A be a finite type with decidable equality and let h be a letter of A. For a multiset b, tail(h,b) is the full multiset obtained by filtering out h; count(h,b) is the number of occurrences of h, and tailCount(h,b) is the number of all other letters, counted with multiplicity. The existing headSlice(h,b,j) is replicate(j,h) + tail(h,b). multiplicity(card(q),q) counts words with occupation q. castR and castC are the natural-number inclusions into the real and complex scalars. The subtraction j-1 in a head index is natural subtraction.

**Theorem 1.1 (Consecutive multiplicity increments).**

$$\forall A \in Type,\; \left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \Rightarrow \left(\forall h \in A,\; \forall b \in Multiset\left(A\right),\; 0 < tailCount\left(h, b\right) \Rightarrow \left(\forall j \in \mathbb{N},\; lastTailMass\left(h, headSlice\left(h, b, j\right)\right) = if\left(j = 0, castR\left(multiplicity\left(card\left(headSlice\left(h, b, 0\right)\right), headSlice\left(h, b, 0\right)\right)\right), castR\left(multiplicity\left(card\left(headSlice\left(h, b, j\right)\right), headSlice\left(h, b, j\right)\right)\right) - castR\left(multiplicity\left(card\left(headSlice\left(h, b, j - 1\right)\right), headSlice\left(h, b, j - 1\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/StationaryPreparation/PaddingGram.last_tail_mass_head_slice` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every natural j, the last-tail mass of the j-th head slice is its multiplicity increment. At j=0 it is the initial multiplicity. The sole positivity assumption is tailCount(h,b)>0; no ambient capacity or positive head count is required. lastTailMass(h,q) is tailCount(h,q) times multiplicity(card(q),q), divided by card(q), in the reals. The head-removal multiplicity recurrence gives the difference formula.

For b<=a in multiset order, paddingResidual(h,a,b) is the existing vector in Space(OccupationMemory(a,h)). A zero tail gives the sink basis vector. A positive tail gives the sum, for 0<=j<=count(h,b), of the basis vector at its actual tail and head index j, weighted by the complex inclusion of sqrt(lastTailMass(h,headSlice(h,b,j))). InnerC is the complex inner product, conjugate linear in the first argument and linear in the second.

**Theorem 1.2 (Whole-tail blocks and minimum head count).**

$$\forall A \in Type,\; \left(Fintype\left(A\right) \land DecidableEq\left(A\right)\right) \Rightarrow \left(\forall h \in A,\; \forall a \in Multiset\left(A\right),\; \forall b \in Multiset\left(A\right),\; \forall c \in Multiset\left(A\right),\; \left(b \le a \land c \le a\right) \Rightarrow InnerC\left(paddingResidual\left(h, a, b\right), paddingResidual\left(h, a, c\right)\right) = if\left(tail\left(h, b\right) = tail\left(h, c\right), castC\left(multiplicity\left(card\left(headSlice\left(h, b, min\left(count\left(h, b\right), count\left(h, c\right)\right)\right)\right), headSlice\left(h, b, min\left(count\left(h, b\right), count\left(h, c\right)\right)\right)\right)\right), 0\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/StationaryPreparation/PaddingGram.padding_residual_inner` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Different entire tails give inner product zero, even when their cardinalities agree. Equal positive tails share precisely the head indices up to the smaller head count. Orthonormality multiplies their real square-root weights, and the finite sum of multiplicity increments gives the displayed entry. If both tails are zero, both vectors are the sink and the pure-head multiplicity is one. A sink and a positive-tail vector are orthogonal. This includes empty occupations and zero head capacity. No maximal-head or positive-head assumption is present.

## References

- Truth anchor: `D5/S3/Quantum/StationaryPreparation/PaddingGram.last_tail_mass_head_slice`
- Truth anchor: `D5/S3/Quantum/StationaryPreparation/PaddingGram.padding_residual_inner`
- Dependency: [D5/S3/Quantum/StationaryPreparation/StationaryOccupationResidualCircuit](StationaryOccupationResidualCircuit.md)
