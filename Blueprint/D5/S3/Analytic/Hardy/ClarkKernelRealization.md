# Disk Model Kernels and Clark Bases

## Abstract

Actual finite Blaschke model vectors extend analytically across the circle, and their normalized boundary kernels construct all phase Clark bases.

H2 is the full complex coefficient Hardy space. The bounded multiplier M_B is constructed from the disk zeros and unit phase in FiniteBlaschkeMultiplier. Inner products are conjugate-linear in the first argument.

**Definition 1.1 (The native Hardy evaluation kernel).**

$$\forall w\in \operatorname{UnitDisc}, n\in \mathbb{N}, \operatorname{coeff}(\operatorname{hardyKernel}(w), n)=\overline{w}^{n}$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkKernelRealization.hardyKernel` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The full geometric coefficient sequence is square-summable because |w| < 1.

**Theorem 1.2 (The Hardy kernel reproduces evaluation).**

$$\forall w\in \operatorname{UnitDisc}, f\in H^{2}, \langle \operatorname{hardyKernel}(w), f \rangle=\operatorname{evaluate}(f, w)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.hardyKernel_reproduces` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The identity uses the convergent coefficient series, with the kernel in the first argument.

**Theorem 1.3 (The Hardy kernel formula).**

$$\forall w\in \operatorname{UnitDisc}, z\in \operatorname{UnitDisc}, \operatorname{evaluate}(\operatorname{hardyKernel}(w), z)=\frac{1}{1-z \overline{w}}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.hardyKernel_evaluate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The Lean signature permits a complex z together with |z| < 1.

**Definition 1.4 (The actual orthogonal model space).**

$$\operatorname{modelSpace}(B)=\operatorname{range}(\operatorname{mul}(B))^{\perp}$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkKernelRealization.modelSpace` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This is the existing frozen modelSpace definition supplied with the actual bounded Blaschke multiplier. No finite-dimensional substitute is introduced.

**Definition 1.5 (The explicit interior model kernel).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), w\in \operatorname{UnitDisc}, \operatorname{modelKernel}(B, w)=\operatorname{hardyKernel}(w)-\overline{\operatorname{value}(B, w)} \operatorname{apply}(\operatorname{mul}(B), \operatorname{hardyKernel}(w))$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkKernelRealization.model_kernel` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The kernel is constructed in H2; membership in the orthogonal model space is proved next.

**Theorem 1.6 (The kernel belongs to the actual model space).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), w\in \operatorname{UnitDisc}, \operatorname{modelKernel}(B, w)\in \operatorname{modelSpace}(B)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.model_kernel_mem` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The proved multiplier isometry and its evaluation law show orthogonality to every vector in its range.

**Theorem 1.7 (The native disk model-kernel formula).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), w\in \operatorname{UnitDisc}, \forall z\in \operatorname{UnitDisc}, \operatorname{evaluate}(\operatorname{modelKernel}(B, w), z)=\frac{1-\operatorname{value}(B, z) \overline{\operatorname{value}(B, w)}}{1-z \overline{w}}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.model_kernel_evaluate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Both evaluation points are interior disk points. The numerator and denominator retain the native disk convention.

**Theorem 1.8 (Reproduction on the orthogonal model space).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), w\in \operatorname{UnitDisc}, \forall g\in \operatorname{modelSpace}(B), \langle \operatorname{modelKernel}(B, w), g \rangle=\operatorname{evaluate}(g, w)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.model_kernel_reproduces` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The inner product is computed after including g in the full H2 carrier.

**Theorem 1.9 (The resolvent preserves the factor range).**

$$\operatorname{range}(\operatorname{factor}(a))=\operatorname{range}(Q-a I)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.factor_range` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every complex a with |a| < 1, the invertible denominator gives range(factor a) = range(Q-aI). Q is the actual unilateral coefficient shift.

**Theorem 1.10 (The one-factor defect recurrence).**

$$g_{n+1}=\overline{a} g_{n}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.factor_model_recurrence` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For |a| < 1, every g in range(factor a) orthogonal complement and every natural n satisfy this recurrence, obtained by pairing against coefficient singletons.

**Theorem 1.11 (The one-factor defect is finite dimensional).**

$$\operatorname{FiniteDimensional}(\mathbb{C}, \operatorname{range}(\operatorname{factor}(a))^{\perp})$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.factor_model_finite` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For |a| < 1, coefficient-zero evaluation is injective on the defect.

**Definition 1.12 (The product defect decomposition).**

$$\operatorname{LinearEquiv}(\mathbb{C}, \operatorname{range}(V W)^{\perp}, \operatorname{range}(V)^{\perp}\times\operatorname{range}(W)^{\perp})$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkKernelRealization.defectProductEquiv` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For bounded complex-linear V and W on H2 with V isometric, the complex-linear equivalence sends x to (x-V(V* x), V* x). Its inverse sends (u,v) to u+Vv. W needs no additional isometry assumption for this decomposition.

**Theorem 1.13 (The one-factor defect has rank one).**

$$\operatorname{finrank}(\mathbb{C}, \operatorname{range}(\operatorname{factor}(a))^{\perp})=1$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.factor_model_finrank` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For |a| < 1, the geometric Hardy kernel at a proves that coefficient-zero evaluation is also surjective.

**Theorem 1.14 (The actual finite Blaschke model space is finite dimensional).**

$$\operatorname{FiniteDimensional}(\mathbb{C}, \operatorname{modelSpace}(B))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.modelSpace_finite` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every natural m and every FiniteBlaschkeData m, induction uses the product defect equivalence. The unit phase does not change the multiplier range.

**Theorem 1.15 (The model-space dimension equals the degree).**

$$\operatorname{finrank}(\mathbb{C}, \operatorname{modelSpace}(B))=m$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.modelSpace_finrank` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every natural m and every FiniteBlaschkeData m, the exact rank is m, including repeated zeros. The source endpoints will additionally retain m > 0 and B(0)=0.

**Theorem 1.16 (Every one-factor model vector is geometric).**

$$\forall a\in \operatorname{UnitDisc}, g\in \operatorname{range}(\operatorname{factor}(a))^{\perp}, z\in \operatorname{ball}(0, 1), \operatorname{evaluate}(g, z)=\frac{\operatorname{coeff}(g, 0)}{1-\overline{a} z}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.factor_model_evaluate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Lean quantifies over complex a and z with their strict norm bounds. The actual defect recurrence determines every coefficient.

**Theorem 1.17 (Every actual model vector has a rational representation).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall g\in \operatorname{modelSpace}(B), \exists p\in \operatorname{Polynomial}(\mathbb{C}), \forall z\in \operatorname{ball}(0, 1), \operatorname{evaluate}(g, z)=\frac{\operatorname{eval}(p, z)}{\operatorname{eval}(\operatorname{denominator}(B), z)}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.modelSpace_rational` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The numerator is constructed through the actual defect decomposition. No polynomial numerator or boundary behavior is assumed.

**Theorem 1.18 (Every model vector extends across the closed disk).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall g\in \operatorname{modelSpace}(B), \exists f:\mathbb{C}\to\mathbb{C}, \operatorname{AnalyticOnNhd}(\mathbb{C}, f, \operatorname{closedBall}(0, 1))\land \operatorname{EqOn}(f, \operatorname{evaluate}(g), \operatorname{ball}(0, 1))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.modelSpace_analytic_extension` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

AnalyticOnNhd means analytic in a neighborhood of each closed-disk point. Evaluation of arbitrary H2 vectors on the circle is not asserted.

**Definition 1.19 (The chosen analytic extension of a model vector).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall g\in \operatorname{modelSpace}(B), \operatorname{boundaryValue}(B, g):\mathbb{C}\to\mathbb{C}$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryValue` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This chooses the function supplied by modelSpace_analytic_extension. It is uniquely determined on the closed disk.

**Theorem 1.20 (The extension agrees with actual Hardy evaluation).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall g\in \operatorname{modelSpace}(B), \forall z\in \operatorname{ball}(0, 1), \operatorname{boundaryValue}(B, g, z)=\operatorname{evaluate}(g, z)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryValue_interior` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The equality is with the convergent coefficient series on the open disk.

**Theorem 1.21 (The selected extension is analytic near the closed disk).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall g\in \operatorname{modelSpace}(B), \operatorname{AnalyticOnNhd}(\mathbb{C}, \operatorname{boundaryValue}(B, g), \operatorname{closedBall}(0, 1))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryValue_analytic` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The closed-disk denominator nonvanishing supplies the analytic neighborhoods.

**Theorem 1.22 (Continuous extensions are unique on the closed disk).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall g\in \operatorname{modelSpace}(B), \forall f:\mathbb{C}\to\mathbb{C}, \operatorname{ContinuousOn}(f, \operatorname{closedBall}(0, 1))\land \operatorname{EqOn}(f, \operatorname{evaluate}(g), \operatorname{ball}(0, 1))\Rightarrow \operatorname{EqOn}(\operatorname{boundaryValue}(B, g), f, \operatorname{closedBall}(0, 1))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryValue_unique` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Density of the open disk in its closure makes the choice immaterial at every circle point.

**Definition 1.23 (Boundary evaluation is a bounded complex-linear functional).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall zeta\in \operatorname{Circle}, \operatorname{boundaryEval}(B, zeta):\operatorname{modelSpace}(B)\to\mathbb{C}$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryEval` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The continuous linear map is constructed from the actual model extension. Linearity follows from uniqueness, and boundedness from the proved finite dimension.

**Theorem 1.24 (The bounded functional evaluates the analytic extension).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall zeta\in \operatorname{Circle}, \forall g\in \operatorname{modelSpace}(B), \operatorname{apply}(\operatorname{boundaryEval}(B, zeta), g)=\operatorname{boundaryValue}(B, g, zeta)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryEval_apply` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is the exact application law of the constructed bounded functional.

**Definition 1.25 (The boundary reproducing kernel belongs to actual K_B).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall zeta\in \operatorname{Circle}, \operatorname{boundaryKernel}(B, zeta)=\operatorname{RieszInverse}(\operatorname{boundaryEval}(B, zeta))$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryKernel` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Pinned Hilbert-space Riesz representation supplies a vector in the actual model-space subtype, whose completeness follows from the proved finite dimension.

**Theorem 1.26 (The boundary kernel reproduces the extension).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall zeta\in \operatorname{Circle}, \forall g\in \operatorname{modelSpace}(B), \langle \operatorname{boundaryKernel}(B, zeta), g \rangle=\operatorname{boundaryValue}(B, g, zeta)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryKernel_reproduces` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The kernel is in the conjugate-linear first argument, matching the source convention.

**Theorem 1.27 (The exact boundary kernel formula in the disk).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall zeta\in \operatorname{Circle}, \forall z\in \operatorname{ball}(0, 1), \operatorname{evaluate}(\operatorname{boundaryKernel}(B, zeta), z)=\frac{1-\operatorname{value}(B, z) \overline{\operatorname{value}(B, zeta)}}{1-z \overline{zeta}}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryKernel_evaluate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Conjugating the pairing with the existing interior kernel identifies the actual boundary Riesz vector with the source formula.

**Theorem 1.28 (The multiplied kernel identity holds on the closed disk).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall zeta\in \operatorname{Circle}, \forall z\in \operatorname{closedBall}(0, 1), \operatorname{boundaryValue}(B, \operatorname{boundaryKernel}(B, zeta), z) (1-z \overline{zeta})=1-\operatorname{value}(B, z) \overline{\operatorname{value}(B, zeta)}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryKernel_identity` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The identity includes the boundary kernel's own point, without dividing by a zero denominator there.

**Theorem 1.29 (The exact squared kernel norm is the Poisson weight).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall zeta\in \operatorname{Circle}, \forall alpha\in \operatorname{Circle}, \operatorname{value}(B, zeta)=alpha\Rightarrow \langle \operatorname{boundaryKernel}(B, zeta), \operatorname{boundaryKernel}(B, zeta) \rangle=\operatorname{poissonWeight}(B, zeta)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryKernel_normSq` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The right side is the real Poisson weight coerced to Complex. Differentiating the multiplied identity within the closed disk proves this norm, using the actual boundary derivative.

In the source-facing declarations below, m>0 and B(0)=0. Alpha is any circle phase, order is any permutation of Fin m, and theta gives any independent circle-valued phase for each kernel. Proof arguments hm and h0 are suppressed in displayed applications.

**Definition 1.30 (A certified enumeration of the full phase fibre).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), 0<m\land \operatorname{value}(B, 0)=0\Rightarrow \forall alpha\in \operatorname{Circle}, \operatorname{phasePoints}(B, alpha):\operatorname{Fin}(m)\to\operatorname{Circle}$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkKernelRealization.phasePoints` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The enumeration is chosen from phase_fibre, retaining injectivity, exact exhaustiveness, and simple roots.

**Definition 1.31 (The normalized Clark kernel family).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), 0<m\land \operatorname{value}(B, 0)=0\Rightarrow \forall alpha\in \operatorname{Circle}, order\in \operatorname{Equiv}(\operatorname{Fin}(m), \operatorname{Fin}(m)), theta:\operatorname{Fin}(m)\to\operatorname{Circle}, \forall j\in \operatorname{Fin}(m), \operatorname{apply}(\operatorname{normalizedClarkFamily}(B, alpha, order, theta), j)=\frac{\operatorname{apply}(theta, j)}{\operatorname{sqrt}(\operatorname{poissonWeight}(B, \operatorname{apply}(\operatorname{phasePoints}(B, alpha), \operatorname{apply}(order, j))))} \operatorname{boundaryKernel}(B, \operatorname{apply}(\operatorname{phasePoints}(B, alpha), \operatorname{apply}(order, j)))$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkKernelRealization.normalizedClarkFamily` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The square root is the positive real square root of the strictly positive Poisson norm; theta supplies the optional individual unit phase.

**Theorem 1.32 (The exact normalized family application law).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), 0<m\land \operatorname{value}(B, 0)=0\Rightarrow \forall alpha\in \operatorname{Circle}, order\in \operatorname{Equiv}(\operatorname{Fin}(m), \operatorname{Fin}(m)), theta:\operatorname{Fin}(m)\to\operatorname{Circle}, \forall j\in \operatorname{Fin}(m), \operatorname{apply}(\operatorname{normalizedClarkFamily}(B, alpha, order, theta), j)=\frac{\operatorname{apply}(theta, j)}{\operatorname{sqrt}(\operatorname{poissonWeight}(B, \operatorname{apply}(\operatorname{phasePoints}(B, alpha), \operatorname{apply}(order, j))))} \operatorname{boundaryKernel}(B, \operatorname{apply}(\operatorname{phasePoints}(B, alpha), \operatorname{apply}(order, j)))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.normalizedClarkFamily_apply` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This records the full scalar, ordering and source boundary-kernel convention.

**Theorem 1.33 (The normalized source family is orthonormal).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), 0<m\land \operatorname{value}(B, 0)=0\Rightarrow \forall alpha\in \operatorname{Circle}, order\in \operatorname{Equiv}(\operatorname{Fin}(m), \operatorname{Fin}(m)), theta:\operatorname{Fin}(m)\to\operatorname{Circle}, \operatorname{Orthonormal}(\mathbb{C}, \operatorname{normalizedClarkFamily}(B, alpha, order, theta))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.normalizedClarkFamily_orthonormal` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Distinct points in the same fibre give zero cross inner products. The exact Poisson norm gives unit diagonal entries, including arbitrary order and individual unit phases.

**Definition 1.34 (Every phase yields the actual Clark orthonormal basis).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), 0<m\land \operatorname{value}(B, 0)=0\Rightarrow \forall alpha\in \operatorname{Circle}, order\in \operatorname{Equiv}(\operatorname{Fin}(m), \operatorname{Fin}(m)), theta:\operatorname{Fin}(m)\to\operatorname{Circle}, \operatorname{clarkBasis}(B, alpha, order, theta)\in \operatorname{OrthonormalBasis}(\operatorname{Fin}(m), \mathbb{C}, \operatorname{modelSpace}(B))$$

*Formalization.* `D5/S3/Analytic/Hardy/ClarkKernelRealization.clarkBasis` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The frozen phase_fibre_is_orthonormal_basis theorem packages the newly proved family and actual finrank m. No orthonormality or dimension hypothesis is added.

**Theorem 1.35 (The basis vectors are exactly the normalized boundary kernels).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), 0<m\land \operatorname{value}(B, 0)=0\Rightarrow \forall alpha\in \operatorname{Circle}, order\in \operatorname{Equiv}(\operatorname{Fin}(m), \operatorname{Fin}(m)), theta:\operatorname{Fin}(m)\to\operatorname{Circle}, \forall j\in \operatorname{Fin}(m), \operatorname{apply}(\operatorname{clarkBasis}(B, alpha, order, theta), j)=\operatorname{apply}(\operatorname{normalizedClarkFamily}(B, alpha, order, theta), j)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/ClarkKernelRealization.clarkBasis_apply` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The constructed basis is identified pointwise with the normalized source family, not merely named Clark.

ClarkWeightedComposition specializes the actual Hardy branches to these bases. No metaphysical proposition is encoded by these analytic constructions.

## References

- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryEval`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryEval_apply`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryKernel`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryKernel_evaluate`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryKernel_identity`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryKernel_normSq`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryKernel_reproduces`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryValue`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryValue_analytic`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryValue_interior`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.boundaryValue_unique`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.clarkBasis`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.clarkBasis_apply`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.defectProductEquiv`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.factor_model_evaluate`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.factor_model_finite`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.factor_model_finrank`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.factor_model_recurrence`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.factor_range`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.hardyKernel`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.hardyKernel_evaluate`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.hardyKernel_reproduces`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.modelSpace`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.modelSpace_analytic_extension`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.modelSpace_finite`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.modelSpace_finrank`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.modelSpace_rational`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.model_kernel`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.model_kernel_evaluate`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.model_kernel_mem`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.model_kernel_reproduces`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.normalizedClarkFamily`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.normalizedClarkFamily_apply`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.normalizedClarkFamily_orthonormal`
- Truth anchor: `D5/S3/Analytic/Hardy/ClarkKernelRealization.phasePoints`
- Dependency: [D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier](FiniteBlaschkeMultiplier.md)
- Dependency: [D5/S3/Analytic/Hardy/PhaseFibreClarkBasis](PhaseFibreClarkBasis.md)
- Dependency: [D5/S3/Zeros/ShiftOperators/InverseBlaschkeHistoryDeletion](../../Zeros/ShiftOperators/InverseBlaschkeHistoryDeletion.md)
