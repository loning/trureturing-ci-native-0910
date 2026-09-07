# Affine Endpoint Paths

## Abstract

Finite complex paths with fixed endpoints correspond bijectively to compatible differences.

**Theorem 1.1 (Endpoint-constrained difference equivalence).**

$$\begin{gathered}\exists e: \operatorname{Equiv}(P,V),\\\forall x\in P,\quad\forall 0\leq j\leq a,\quad e(x)(j)=x(j+1)-rx(j),\\\forall v\in V,\quad\forall 0\leq i\leq a+1,\quad e^{-1}(v)(i)=r^{i}\mathrm{xi}+\sum_{0\leq j<i}r^{i-1-j}v(j)\end{gathered}$$

*Proof.* Machine-checked in Lean as `D5/S3/QuantumBounds/AffineEndpointPath.affine_endpoint_path_equivalence` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Write P for EndpointPath and V for CompatibleDifference. EndpointPath consists of complex-valued functions on Fin (a + 2), with value xi at zero and eta at the last vertex. CompatibleDifference consists of functions v on Fin (a + 1) whose sum of r^(a-j) v(j) is eta - r^(a+1) xi.

The displayed equivalence has a specified map in each direction. Its two inverse identities recover the entire path and the entire difference vector. In particular, equal difference vectors determine equal endpoint-constrained paths.

The construction is valid for every complex r. A real r strictly between zero and one is covered by its usual complex coercion. No positivity, division, norm estimate, or optimization argument is needed; the case a = 0 is included.

**Theorem 1.2 (Forward coordinate law).**

$$\forall x\in P,\quad\forall 0\leq j\leq a,\quad e(x)(j)=x(j+1)-rx(j)$$

*Proof.* Machine-checked in Lean as `D5/S3/QuantumBounds/AffineEndpointPath.affine_endpoint_path_equiv_apply` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Here e is affineEndpointPathEquiv. For each edge j, Fin.succ selects vertex j + 1 and Fin.castSucc selects vertex j. Thus the map is exactly x(j+1) - r x(j).

**Theorem 1.3 (Explicit inverse coordinate law).**

$$\forall v\in V,\quad\forall 0\leq i\leq a+1,\quad e^{-1}(v)(i)=r^{i}\mathrm{xi}+\sum_{0\leq j<i}r^{i-1-j}v(j)$$

*Proof.* Machine-checked in Lean as `D5/S3/QuantumBounds/AffineEndpointPath.affine_endpoint_path_equiv_symm_apply` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

At vertex i the inverse is r^i xi plus the sum of r^(i-1-j) v(j) over exactly those edges with j < i. At zero this sum is empty; at a + 1 the compatibility equation gives the prescribed terminal value.

The prefix sum satisfies the forced one-step recurrence. Induction over the finite vertices proves reconstruction after differentiation is the identity; substituting that one-step recurrence proves the other composite identity. This supplies reconstruction and uniqueness for later path arguments, without claiming any action bound or equality-case optimization result here.

## References

- Truth anchor: `D5/S3/QuantumBounds/AffineEndpointPath.affine_endpoint_path_equiv_apply`
- Truth anchor: `D5/S3/QuantumBounds/AffineEndpointPath.affine_endpoint_path_equiv_symm_apply`
- Truth anchor: `D5/S3/QuantumBounds/AffineEndpointPath.affine_endpoint_path_equivalence`
