# Hardy Weighted Composition and Basis Changes

## Abstract

Constructed Hardy weighted-composition branches preserve their complete bounded-operator map under model-basis changes.

Throughout, m is a natural number, B is FiniteBlaschkeData m, K_B is the actual orthogonal complement of the multiplier range, e belongs to K_B, and f belongs to the full complex lp2 Hardy space H2. No finite-dimensional restriction is placed on H2. Products of bounded operators mean composition.

**Definition 1.1 (Isometric multiplier powers on the model space).**

$$\operatorname{powerEmbedding}(B, n, e)=\operatorname{apply}(\operatorname{mul}(B)^{n}, e)$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkWeightedComposition.powerEmbedding` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For every natural n this is a complex-linear isometry from K_B to H2, proved using the actual multiplier isometry.

**Theorem 1.2 (Distinct powers of the defect are orthogonal).**

$$\operatorname{OrthogonalFamily}(\mathbb{C}, \operatorname{powerEmbedding}(B))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkWeightedComposition.powers_orthogonal` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For all distinct natural i and j and all x,y in K_B, the inner product of M_B^i x and M_B^j y is zero. No completeness of their span is needed.

**Definition 1.3 (Coefficient synthesis input).**

$$\operatorname{coeff}(\operatorname{coefficientTensor}(B, e, f), n)=\operatorname{coeff}(f, n) e$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkWeightedComposition.coefficientTensor` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This is a bounded complex-linear map from H2 to lp2 of copies of the actual model space. Square summability is proved from the coefficient norm identity.

**Theorem 1.4 (The coefficient input has the exact product norm).**

$$\Vert \operatorname{coefficientTensor}(B, e, f) \Vert=\Vert e \Vert \Vert f \Vert$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkWeightedComposition.coefficientTensor_norm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The norm identity holds for every e and f, including zero.

**Definition 1.5 (The actual bounded Hardy branch operator).**

$$\operatorname{apply}(\operatorname{branchOp}(B, e), f)=\operatorname{tsum}(n, \operatorname{coeff}(f, n) \operatorname{apply}(\operatorname{mul}(B)^{n}, e))$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branchOp` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The operator is the composition of the coefficient input map and the pinned orthogonal-family Hilbert-sum isometry.

**Theorem 1.6 (The defining branch series converges in H2).**

$$\operatorname{HasSum}(\operatorname{sequence}(n, \operatorname{coeff}(f, n) \operatorname{apply}(\operatorname{mul}(B)^{n}, e)), \operatorname{apply}(\operatorname{branchOp}(B, e), f))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_hasSum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is unconditional norm convergence of the full series, not a formal coefficient identity.

**Theorem 1.7 (The branch has the exact norm identity).**

$$\Vert \operatorname{apply}(\operatorname{branchOp}(B, e), f) \Vert=\Vert e \Vert \Vert f \Vert$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_norm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Consequently its squared norm is ||e|| squared times ||f|| squared, and the required boundedness estimate follows.

**Theorem 1.8 (The branch is weighted composition by B).**

$$\operatorname{evaluate}(\operatorname{apply}(\operatorname{branchOp}(B, e), f), z)=\operatorname{evaluate}(e, z) \operatorname{evaluate}(f, \operatorname{value}(B, z))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_eval` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every positive m and every complex z with |z| < 1, continuity of disk evaluation identifies the norm-convergent synthesis with e(z)f(B(z)).

**Definition 1.9 (The operator depends complex-linearly on its weight).**

$$\operatorname{branchLinear}(B): \operatorname{modelSpace}(B)\to\operatorname{BoundedComplexLinear}(H^{2}, H^{2})$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branchLinear` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The linear map sends e to branchOp B e. Additivity and complex homogeneity are proved from uniqueness of the convergent series.

For the remaining statements, E and F are arbitrary orthonormal bases indexed by Fin m of the actual K_B. Every choice of ordering and every individual unit phase is included whenever represented by such a basis. Inner products are conjugate-linear in the first argument.

**Definition 1.10 (The coordinate transition).**

$$\operatorname{C}(k, j)=\langle \operatorname{F}(k), \operatorname{E}(j) \rangle$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkWeightedComposition.coordinateTransition` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This matrix has entries of the F coordinates of E(j).

**Definition 1.11 (The basis expansion transition).**

$$\operatorname{U}(k, j)=\langle \operatorname{E}(j), \operatorname{F}(k) \rangle$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branchTransition` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This is the row expansion coefficient of F(k) in E. It has the opposite inner-product order from the coordinate matrix.

**Theorem 1.12 (The two transitions are conjugate).**

$$\operatorname{U}(k, j)=\overline{\operatorname{C}(k, j)}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_transition_eq_conj_coordinates` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The equality holds for every pair of Fin m indices.

**Theorem 1.13 (The actual branches obey the basis expansion law).**

$$\operatorname{branchOp}(B, \operatorname{F}(k))=\sum_{j} \operatorname{U}(k, j) \operatorname{branchOp}(B, \operatorname{E}(j))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_basis_mix` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This follows by applying the proved weight-to-operator linear map to the full basis expansion.

**Theorem 1.14 (The exact scalar cancellation identity).**

$$\sum_{k} \operatorname{U}(k, i) \overline{\operatorname{U}(k, j)}=\operatorname{delta}(i, j)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_transition_columns` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Delta is one for equal indices and zero otherwise. The identity follows from orthonormal-basis inner-product reconstruction.

**Theorem 1.15 (The branch transition is unitary).**

$$(U)^{*} U=I$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_transition_unitary` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Here star is conjugate transpose of the finite coefficient matrix.

**Theorem 1.16 (The complete branch map is basis independent).**

$$\forall X\in \operatorname{BoundedComplexLinear}(H^{2}, H^{2}), \sum_{k} \operatorname{branchOp}(B, \operatorname{F}(k)) X (\operatorname{branchOp}(B, \operatorname{F}(k)))^{*}=\sum_{j} \operatorname{branchOp}(B, \operatorname{E}(j)) X (\operatorname{branchOp}(B, \operatorname{E}(j)))^{*}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_map_basis_invariant` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This equality is in the bounded-operator algebra on full H2. It imposes no positivity, trace, finite-rank, state or finite-dimensional ambient hypothesis.

**Theorem 1.17 (The complete source Clark branch map is choice independent).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), 0<m\land \operatorname{value}(B, 0)=0\Rightarrow \forall alpha,beta\in \operatorname{Circle}(), oa,ob\in \operatorname{Equiv}(\operatorname{Fin}(m), \operatorname{Fin}(m)), ta,tb:\operatorname{Fin}(m)\to\operatorname{Circle}(), X\in \operatorname{BoundedComplexLinear}(H^{2}, H^{2}), \sum_{k} \operatorname{branchOp}(B, \operatorname{Clark}(beta, ob, tb, k)) X (\operatorname{branchOp}(B, \operatorname{Clark}(beta, ob, tb, k)))^{*}=\sum_{j} \operatorname{branchOp}(B, \operatorname{Clark}(alpha, oa, ta, j)) X (\operatorname{branchOp}(B, \operatorname{Clark}(alpha, oa, ta, j)))^{*}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkWeightedComposition.clark_branch_map_invariant` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Clark(alpha,order,theta,j) is exactly clarkBasis B hm h0 alpha order theta j, the normalized boundary kernel constructed in ClarkKernelRealization. The equality holds for every bounded X on full H2. The retained branch_eval gives its source law e_j(z)f(B(z)), and branch_basis_mix uses U[k,j]=inner(e_alpha[j],e_beta[k]).

The statement that Lambda_B is not Tao remains an interpretive boundary only. The source-facing equality concerns the complete bounded-operator map and all the specified basis, phase and sheet choices; no metaphysical Lean proposition is asserted.

## References

- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branchLinear`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branchOp`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branchTransition`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_basis_mix`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_eval`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_hasSum`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_map_basis_invariant`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_norm`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_transition_columns`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_transition_eq_conj_coordinates`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.branch_transition_unitary`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.clark_branch_map_invariant`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.coefficientTensor`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.coefficientTensor_norm`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.coordinateTransition`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.powerEmbedding`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkWeightedComposition.powers_orthogonal`
- Dependency: [D5/S3/Analytic/Hardy/ClarkKernelRealization](ClarkKernelRealization.md)
