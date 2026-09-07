# Finite Disk Blaschke Multipliers

## Abstract

Zeros in the disk and a unit phase construct the actual bounded isometric Blaschke multiplier on the full Hardy coefficient space.

H2 is the full complex lp2 coefficient space constructed in HardyCoefficientRealization. Operator multiplication means composition. Complex inner products are conjugate-linear in their first argument.

**Definition 1.1 (The unilateral coefficient shift).**

$$Q: H^{2}\to H^{2}, \forall f\in H^{2}, n\in \mathbb{N}, \operatorname{coeff}(\operatorname{apply}(Q, f), 0)=0, \operatorname{coeff}(\operatorname{apply}(Q, f), n+1)=\operatorname{coeff}(f, n)$$

*Formalization.* `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.shift` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Q is a complex-linear isometry. The zero and successor coefficient equations are also exposed as shift_zero and shift_succ.

**Theorem 1.2 (The shift multiplies evaluation by z).**

$$\forall f\in H^{2}, z\in \mathbb{C}, |z|<1\Rightarrow \operatorname{evaluate}(\operatorname{apply}(Q, f), z)=z \operatorname{evaluate}(f, z)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.shift_evaluate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is equality of the actual convergent coefficient-series evaluations.

**Definition 1.3 (The Neumann denominator is a unit).**

$$\forall a\in \mathbb{C}, |a|<1\Rightarrow \operatorname{denominatorUnit}(a)=I-\overline{a} Q$$

*Formalization.* `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.denominatorUnit` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The value is I-conjugate(a)Q in the bounded-operator algebra. Mathlib's Units.oneSub constructs its inverse from the norm-convergent geometric series. No inverse is assumed for an arbitrary bounded operator.

**Definition 1.4 (The concrete single-factor multiplier).**

$$\forall a\in \mathbb{C}, |a|<1\Rightarrow \operatorname{factor}(a)=(Q-a I) (I-\overline{a} Q)^{-1}$$

*Formalization.* `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.factor` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The inverse is the already constructed unit inverse.

**Theorem 1.5 (Single-factor analytic multiplication).**

$$\forall a\in \mathbb{C}, |a|<1\Rightarrow \forall f\in H^{2}, z\in \mathbb{C}, |z|<1\Rightarrow \operatorname{evaluate}(\operatorname{apply}(\operatorname{factor}(a), f), z)=\frac{z-a}{1-\overline{a} z} \operatorname{evaluate}(f, z)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.factor_evaluate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The operator evaluates as multiplication by (z-a)/(1-conjugate(a)z).

**Theorem 1.6 (Every disk factor is isometric).**

$$\forall a\in \mathbb{C}, |a|<1\Rightarrow \operatorname{Isometry}(\operatorname{factor}(a))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.factor_isometry` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The proof expands ||Qy-ay|| squared and ||y-conjugate(a)Qy|| squared, then applies the constructed inverse denominator.

**Definition 1.7 (Only zeros and phase are data).**

$$a:\operatorname{Fin}(m)\to \operatorname{UnitDisc}, c\in \operatorname{Circle}$$

*Formalization.* `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.FiniteBlaschkeData` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The zeros may repeat. The fields contain no isometry, model dimension, kernel normalization, orthonormality or invariance assumption.

**Definition 1.8 (The finite Blaschke product).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \operatorname{value}(B, z)=\operatorname{phase}(B) \prod_{j\in \operatorname{Fin}(m)} \frac{z-\operatorname{zero}(B, j)}{1-\overline{\operatorname{zero}(B, j)} z}$$

*Formalization.* `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.value` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Lean evaluates the product using List.ofFn in canonical Fin order.

**Definition 1.9 (The bounded finite-product operator).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \operatorname{mul}(B)=\operatorname{phase}(B) \prod_{j\in \operatorname{Fin}(m)} \operatorname{factor}(\operatorname{zero}(B, j))$$

*Formalization.* `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.mul` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This is the ordered operator product from List.ofFn, scaled by the unit phase.

**Theorem 1.10 (The actual multiplication law).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall f\in H^{2}, z\in \mathbb{C}, |z|<1\Rightarrow \operatorname{evaluate}(\operatorname{apply}(\operatorname{mul}(B), f), z)=\operatorname{value}(B, z) \operatorname{evaluate}(f, z)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.mul_eval` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The constructed continuous linear map is actual analytic multiplication by B.

**Theorem 1.11 (The finite multiplier is isometric).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \operatorname{Isometry}(\operatorname{mul}(B))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.mul_isometry` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Composition of the proved factor isometries and a unit scalar preserves the full H2 norm.

**Theorem 1.12 (Positive degree maps the disk strictly into itself).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), 0<m\Rightarrow \forall z\in \mathbb{C}, |z|<1\Rightarrow |\operatorname{value}(B, z)|<1$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.maps_unitDisc` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The strict factor bound follows from the positive defect (1-|a| squared)(1-|z| squared). Positive degree makes the product nonempty.

**Definition 1.13 (The zero polynomial product).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \operatorname{numerator}(B)=\prod_{j\in \operatorname{Fin}(m)} (T-\operatorname{C}(\operatorname{zero}(B, j)))$$

*Formalization.* `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.numerator` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

T is the polynomial indeterminate and C embeds a complex constant.

**Definition 1.14 (The denominator polynomial).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \operatorname{denominator}(B)=\prod_{j\in \operatorname{Fin}(m)} (1-\operatorname{C}(\overline{\operatorname{zero}(B, j)}) T)$$

*Formalization.* `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.denominator` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This polynomial is distinct from the coefficient-shift operator Q above.

**Definition 1.15 (The actual phase polynomial).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall alpha\in \operatorname{Circle}, \operatorname{fibrePolynomial}(B, alpha)=\operatorname{C}(\operatorname{phase}(B)) \operatorname{numerator}(B)-\operatorname{C}(alpha) \operatorname{denominator}(B)$$

*Formalization.* `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.fibrePolynomial` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Every alpha on the circle is permitted.

**Definition 1.16 (The boundary Poisson weight).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall zeta\in \operatorname{Circle}, \operatorname{poissonWeight}(B, zeta)=\sum_{j\in \operatorname{Fin}(m)} \frac{1-|\operatorname{zero}(B, j)|^{2}}{|zeta-\operatorname{zero}(B, j)|^{2}}$$

*Formalization.* `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.poissonWeight` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The weight is real and uses the actual disk zeros, including multiplicities.

**Theorem 1.17 (No factor pole on the closed disk).**

$$\forall a\in \operatorname{UnitDisc}, z\in \mathbb{C}, |z|\le1\Rightarrow 1-\overline{a} z\neq0$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.factor_denominator_ne_zero_closed` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The strict zero-parameter norm and closed-disk bound imply nonvanishing.

**Theorem 1.18 (The full denominator has no closed-disk zero).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall z\in \mathbb{C}, |z|\le1\Rightarrow \operatorname{eval}(\operatorname{denominator}(B), z)\neq0$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.denominator_ne_zero_closed` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This supplies the analytic extension domain used by the actual model space.

**Theorem 1.19 (The finite product is the polynomial quotient).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall z\in \mathbb{C}, \operatorname{value}(B, z)=\frac{\operatorname{phase}(B) \operatorname{eval}(\operatorname{numerator}(B), z)}{\operatorname{eval}(\operatorname{denominator}(B), z)}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.value_eq_polynomial_div` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The equality holds for every complex z under Lean's total division convention.

**Theorem 1.20 (Origin normalization forces a zero parameter).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \operatorname{value}(B, 0)=0\Rightarrow \exists j\in \operatorname{Fin}(m), \operatorname{zero}(B, j)=0$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.zero_parameter` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The zero parameter is derived from B(0)=0, not added as an assumption.

**Theorem 1.21 (The numerator has degree m).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \operatorname{natDegree}(\operatorname{numerator}(B))=m$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.numerator_natDegree` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Pinned Mathlib's monic product theorem supplies the exact degree.

**Theorem 1.22 (The normalized denominator has smaller degree).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \operatorname{value}(B, 0)=0\Rightarrow \operatorname{natDegree}(\operatorname{denominator}(B))<m$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.denominator_natDegree_lt` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The derived zero parameter removes one linear denominator factor.

**Theorem 1.23 (Every phase polynomial has degree m).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall alpha\in \operatorname{Circle}, \operatorname{value}(B, 0)=0\Rightarrow \operatorname{natDegree}(\operatorname{fibrePolynomial}(B, alpha))=m$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.fibrePolynomial_natDegree` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The unit numerator coefficient cannot cancel against a denominator of smaller degree.

**Theorem 1.24 (Every phase-polynomial root is an actual circle preimage).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall alpha\in \operatorname{Circle}, \forall z\in \mathbb{C}, 0<m\land \operatorname{value}(B, 0)=0\land \operatorname{eval}(\operatorname{fibrePolynomial}(B, alpha), z)=0\Rightarrow |z|=1\land \operatorname{value}(B, z)=alpha$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.fibre_root` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Poles are excluded first. Strict factor modulus estimates exclude exterior roots; the proved disk mapping excludes interior roots.

**Theorem 1.25 (The Poisson weight is positive).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall zeta\in \operatorname{Circle}, 0<m\Rightarrow 0<\operatorname{poissonWeight}(B, zeta)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.poissonWeight_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Positive degree supplies a nonempty sum of strictly positive terms.

**Theorem 1.26 (The exact analytic boundary derivative).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall zeta\in \operatorname{Circle}, \operatorname{HasDerivAt}(\operatorname{value}(B), \frac{\operatorname{value}(B, zeta)}{zeta} \operatorname{poissonWeight}(B, zeta), zeta)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.value_hasDerivAt_circle` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is a complex derivative in a neighborhood of the circle point. The real Poisson weight is coerced to the complex field.

**Theorem 1.27 (The phase-polynomial derivative at a fibre point).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall alpha\in \operatorname{Circle}, \forall zeta\in \operatorname{Circle}, \operatorname{value}(B, zeta)=alpha\Rightarrow \operatorname{eval}(\operatorname{derivative}(\operatorname{fibrePolynomial}(B, alpha)), zeta)=\operatorname{eval}(\operatorname{denominator}(B), zeta) \frac{alpha}{zeta} \operatorname{poissonWeight}(B, zeta)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.fibre_derivative` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is R'(zeta)=Q(zeta)B'(zeta), with the exact positive Poisson expression substituted.

**Theorem 1.28 (Every phase has exactly m distinct simple circle preimages).**

$$\forall m\in \mathbb{N}, B\in \operatorname{FiniteBlaschkeData}(m), \forall alpha\in \operatorname{Circle}, 0<m\land \operatorname{value}(B, 0)=0\Rightarrow \exists zeta:\operatorname{Fin}(m)\to\operatorname{Circle}, \operatorname{Injective}(zeta)\land (\forall z\in \mathbb{C}, (\operatorname{value}(B, z)=alpha\land |z|=1)\iff(\exists j\in \operatorname{Fin}(m), z=\operatorname{apply}(zeta, j)))\land (\forall j\in \operatorname{Fin}(m), \operatorname{eval}(\operatorname{derivative}(\operatorname{fibrePolynomial}(B, alpha)), \operatorname{apply}(zeta, j))\neq0)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.phase_fibre` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The finite family exhausts the fibre, is injective, and every root is simple. Complex polynomial splitting and separability supply the exact cardinality.

The source normalization B(0)=0 remains explicit. ClarkKernelRealization uses these actual all-phase fibres and positive derivatives for its analytic boundary kernels and normalization.

## References

- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.FiniteBlaschkeData`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.denominator`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.denominatorUnit`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.denominator_natDegree_lt`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.denominator_ne_zero_closed`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.factor`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.factor_denominator_ne_zero_closed`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.factor_evaluate`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.factor_isometry`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.fibrePolynomial`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.fibrePolynomial_natDegree`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.fibre_derivative`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.fibre_root`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.maps_unitDisc`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.mul`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.mul_eval`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.mul_isometry`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.numerator`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.numerator_natDegree`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.phase_fibre`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.poissonWeight`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.poissonWeight_pos`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.shift`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.shift_evaluate`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.value`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.value_eq_polynomial_div`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.value_hasDerivAt_circle`
- Truth anchor: `D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.zero_parameter`
- Dependency: [D5/S3/Analytic/Hardy/HardyCoefficientRealization](HardyCoefficientRealization.md)
