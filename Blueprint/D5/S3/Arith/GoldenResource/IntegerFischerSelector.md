# Integer Fischer Selector

## Abstract

Fischer's determinant inequality gives a positive logarithmic loss independent of matrix dimension.

All index types are finite. Positive definiteness includes symmetry. For an integer matrix T, let R(T) denote its entrywise inclusion into the real matrices, let card(n) denote the number of indices, and let tr denote the trace. The selected integer k is at least two and the price p lies strictly between log((k+1)/k) and log(k/(k-1)). Write delta(k, p) for the minimum of the two endpoint margins log(k/(k-1))-p and p-log((k+1)/k) together with the two-coordinate loss log(k squared)-log(k squared minus one). Empty products equal one.

**Theorem 1.1 (A two-coordinate principal block).**

$$\begin{gathered}\forall n: Type, [Fintype\left(n\right)] [DecidableEq\left(n\right)],\\\forall T: Matrix\left(n, n, \mathbb{R}\right),\\\forall i \in n, j \in n,\; \left(PosDef\left(T\right) \land i \ne j\right) \Rightarrow det\left(T\right) \le (T\left(i, i\right) \cdot T\left(j, j\right) - T\left(i, j\right) \cdot T\left(j, i\right)) \cdot \prod_{l \in n \setminus \{i,j\}} T\left(l, l\right)\end{gathered}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/IntegerFischerSelector.fischer_two_block` (`✓ std3`). ∎

*Citation.* Roger A. Horn and Charles R. Johnson (2012). *Matrix Analysis*. DOI: [10.1017/CBO9781139020411](https://doi.org/10.1017/CBO9781139020411).

*Commentary.*

For distinct indices i and j, retain their two by two principal determinant and multiply by the other diagonal entries. This bounds the full determinant from above. An elementary shear has determinant one and changes only one diagonal entry under congruence. Hadamard's inequality applied after this shear gives the stated bound.

**Theorem 1.2 (A nonzero integer entry forces a loss).**

$$\begin{gathered}\forall n: Type, [Fintype\left(n\right)] [DecidableEq\left(n\right)],\\\forall T: Matrix\left(n, n, \mathbb{Z}\right),\\\forall i \in n, j \in n,\; \left(PosDef\left(R\left(T\right)\right) \land \left(i \ne j \land T\left(i, j\right) \ne 0\right)\right) \Rightarrow det\left(T\right) \cdot (T\left(i, i\right) \cdot T\left(j, j\right)) \le (T\left(i, i\right) \cdot T\left(j, j\right) - 1) \cdot \prod_{l:n} T\left(l, l\right)\end{gathered}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/IntegerFischerSelector.integer_fischer_gap` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The square of a nonzero integer is at least one. Symmetry therefore lowers the two-coordinate determinant by at least one relative to its diagonal product. Multiplication by the positive diagonal entries yields the integer form of the bound.

**Theorem 1.3 (A positive margin depending on k and p).**

$$\forall k \in \mathbb{N}, p \in \mathbb{R},\; \left(2 \le k \land \left(log\left(\frac{k + 1}{k}\right) < p \land p < log\left(\frac{k}{k - 1}\right)\right)\right) \Rightarrow 0 < min\left(min\left(log\left(\frac{k}{k - 1}\right) - p, p - log\left(\frac{k + 1}{k}\right)\right), log\left(k^2\right) - log\left(k^2 - 1\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/IntegerFischerSelector.selectorGap_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Each of the three terms is positive on the strict price interval: the first two because the interval endpoints are strict, the third because the logarithm is strictly increasing and k squared exceeds k squared minus one. The margin contains no matrix dimension.

**Theorem 1.4 (The scalar matrix is uniformly isolated).**

$$\begin{gathered}\forall n: Type, [Fintype\left(n\right)] [DecidableEq\left(n\right)],\\\forall T: Matrix\left(n, n, \mathbb{Z}\right),\\\forall k \in \mathbb{N}, p \in \mathbb{R},\; \left(\left(2 \le k \land \left(log\left(\frac{k + 1}{k}\right) < p \land p < log\left(\frac{k}{k - 1}\right)\right)\right) \land PosDef\left(R\left(T\right)\right)\right) \Rightarrow \left(0 < \delta(k, p) \land \left(log\left(det\left(T\right)\right) - p \cdot tr\left(T\right) \le (card\left(n\right)) \cdot (log\left(k\right) - p \cdot k) \land \left(T \ne k \cdot I\left(n\right) \Rightarrow log\left(det\left(T\right)\right) - p \cdot tr\left(T\right) \le (card\left(n\right)) \cdot (log\left(k\right) - p \cdot k) - \delta(k, p)\right)\right)\right)\end{gathered}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/IntegerFischerSelector.integer_log_unique_maximum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The objective log(det(T))-p tr(T) is bounded above by the number of indices times log(k)-p k. Every matrix distinct from k times the identity loses at least the margin. If a diagonal entry differs from k, sum the scalar selector inequalities and retain that entry's loss. If every diagonal entry equals k, a nonzero off-diagonal entry gives the two-coordinate loss. Taking logarithms cancels the remaining diagonal product, so this loss is independent of dimension.

## References

- Truth anchor: `D5/S3/Arith/GoldenResource/IntegerFischerSelector.fischer_two_block`
- Truth anchor: `D5/S3/Arith/GoldenResource/IntegerFischerSelector.integer_fischer_gap`
- Truth anchor: `D5/S3/Arith/GoldenResource/IntegerFischerSelector.integer_log_unique_maximum`
- Truth anchor: `D5/S3/Arith/GoldenResource/IntegerFischerSelector.selectorGap_pos`
- Dependency: [D5/S3/Arith/GoldenResource/DiscreteLogSelector](DiscreteLogSelector.md)
- Dependency: [D5/S3/Arith/GoldenResource/IntegerHadamard](IntegerHadamard.md)
