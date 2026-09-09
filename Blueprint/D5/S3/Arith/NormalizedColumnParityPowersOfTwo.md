# A144637 Normalized Column Parity

## Abstract

The normalized A144637 equation has integral coefficients whose odd support is exactly the set of positive powers of two.

**Theorem 1.1 (An integral normalized solution exists).**

$$\exists z \in \operatorname{PowerSeries}\left(\mathbb{Z}\right),\; \operatorname{constantCoeff}\left(z\right) = 0 \land \operatorname{C}\left(36\right) \cdot z^{3} + \operatorname{C}\left(3\right) \cdot z^{2} + \left(1 + \operatorname{C}\left(6\right) \cdot X\right) \cdot z = X^{2}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/NormalizedColumnParityPowersOfTwo.normalized_solution_exists` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Choose the coefficient of z in degree n recursively as the degree-n coefficient of x^2-36z^3-3z^2-6xz formed from the strict prefix. The zero constant coefficient makes every nonlinear contribution in degree n depend only on lower coefficients. The resulting integer series satisfies the normalized cubic equation.

**Theorem 1.2 (A rational normalized solution exists).**

$$\exists y \in \operatorname{PowerSeries}\left(\mathbb{Q}\right),\; \operatorname{constantCoeff}\left(y\right) = 0 \land \operatorname{C}\left(36\right) \cdot y^{3} + \operatorname{C}\left(3\right) \cdot y^{2} + \left(1 + \operatorname{C}\left(6\right) \cdot X\right) \cdot y = X^{2}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/NormalizedColumnParityPowersOfTwo.rational_solution_exists` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Mapping the recursively constructed integer series coefficientwise into the rationals preserves its zero constant coefficient, products, powers, and the indeterminate. It therefore supplies a rational solution of the same normalized equation.

**Theorem 1.3 (Integrality and reduction to the quadratic equation).**

$$\forall y \in \operatorname{PowerSeries}\left(\mathbb{Q}\right),\; \left(\operatorname{constantCoeff}\left(y\right) = 0 \land \operatorname{C}\left(36\right) \cdot y^{3} + \operatorname{C}\left(3\right) \cdot y^{2} + \left(1 + \operatorname{C}\left(6\right) \cdot X\right) \cdot y = X^{2}\right) \Rightarrow \left(\exists z \in \operatorname{PowerSeries}\left(\mathbb{Z}\right),\; \operatorname{map}\left(\operatorname{intCast}\left(\mathbb{Q}\right), z\right) = y \land \left(\operatorname{constantCoeff}\left(z\right) = 0 \land \operatorname{map}\left(\operatorname{intCast}\left(\operatorname{ZMod}\left(2\right)\right), z\right)^{2} + \operatorname{map}\left(\operatorname{intCast}\left(\operatorname{ZMod}\left(2\right)\right), z\right) = X^{2}\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/NormalizedColumnParityPowersOfTwo.integral_reduction` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Two zero-constant rational solutions agree coefficient by coefficient. In degree n, the coefficient of y occurs with multiplier one, while all other occurrences involve lower degrees. Hence every rational solution is the rational image of the recursively constructed integer series. Reducing that same cubic equation modulo two removes the terms with coefficients 36 and 6 and replaces 3 by 1, giving z^2+z=x^2.

**Theorem 1.4 (Support of the zero-constant quadratic root).**

$$\forall F \in \operatorname{PowerSeries}\left(\operatorname{ZMod}\left(2\right)\right),\; \left(\operatorname{constantCoeff}\left(F\right) = 0 \land F^{2} + F = X^{2}\right) \Rightarrow \left(\forall n \in \mathbb{N},\; \operatorname{coeff}\left(n, F\right) = 1 \Leftrightarrow \left(\exists k \in \mathbb{N},\; 0 < k \land n = 2^{k}\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/NormalizedColumnParityPowersOfTwo.zero_constant_quadratic_support` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Let S be the constant-one Artin series. Its equation S^2+S=x gives T=S^2+1=x+S+1, whose coefficients are one exactly in degrees 2,4,8,.... Squaring the equation for S shows T^2+T=x^2. The equal-constant root uniqueness theorem identifies every zero-constant root of this quadratic with T.

**Theorem 1.5 (Odd coefficients occur exactly at positive powers of two).**

$$\forall y \in \operatorname{PowerSeries}\left(\mathbb{Q}\right),\; \left(\operatorname{constantCoeff}\left(y\right) = 0 \land \operatorname{C}\left(36\right) \cdot y^{3} + \operatorname{C}\left(3\right) \cdot y^{2} + \left(1 + \operatorname{C}\left(6\right) \cdot X\right) \cdot y = X^{2}\right) \Rightarrow \left(\exists z \in \operatorname{PowerSeries}\left(\mathbb{Z}\right),\; \operatorname{map}\left(\operatorname{intCast}\left(\mathbb{Q}\right), z\right) = y \land \left(\forall n \in \mathbb{N},\; \operatorname{Odd}\left(\operatorname{coeff}\left(n, z\right)\right) \Leftrightarrow \left(\exists k \in \mathbb{N},\; 0 < k \land n = 2^{k}\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/NormalizedColumnParityPowersOfTwo.a144637_parity` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Apply the integral reduction to a normalized rational solution. An integer coefficient is odd exactly when its image in ZMod(2) is one, and the quadratic support theorem identifies those indices precisely as 2^k with k positive.

## References

- Truth anchor: `D5/S3/Arith/NormalizedColumnParityPowersOfTwo.a144637_parity`
- Truth anchor: `D5/S3/Arith/NormalizedColumnParityPowersOfTwo.integral_reduction`
- Truth anchor: `D5/S3/Arith/NormalizedColumnParityPowersOfTwo.normalized_solution_exists`
- Truth anchor: `D5/S3/Arith/NormalizedColumnParityPowersOfTwo.rational_solution_exists`
- Truth anchor: `D5/S3/Arith/NormalizedColumnParityPowersOfTwo.zero_constant_quadratic_support`
- Dependency: [D5/S3/Arith/ArtinSchreierQuadraticRootUniqueness](ArtinSchreierQuadraticRootUniqueness.md)
- Dependency: [D5/S3/Arith/ArtinSchreierTracePowersOfTwo](ArtinSchreierTracePowersOfTwo.md)
