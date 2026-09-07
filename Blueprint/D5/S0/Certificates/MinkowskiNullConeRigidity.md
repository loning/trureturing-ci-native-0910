# Minkowski Null Cone Rigidity

## Abstract

Vanishing on the Minkowski null cone determines a real quadratic form up to a scalar.

Let d be any natural number, let V be the product of the real line and Euclidean d-space, and let S be any real quadratic form on V.

$V_{d} = \mathbb{R} \times \mathbb{R}^{d}, g_{d}(t, w) = t^{2} - \Vert w\Vert^{2}, e = (1, 0), p_{S}(x, y) = S(x+y) - S(x) - S(y)$

**Lemma 1.1 (Spatial restriction and mixed term).**

$$\forall d \in \mathbb{N}, \forall S: \operatorname{QuadraticForm}(\mathbb{R}, V_{d}), (\forall v \in V_{d}, g_{d}(v) = 0 \Rightarrow S(v) = 0) \Rightarrow \forall w \in \mathbb{R}^{d}, S((0, w)) = -S(e)\Vert w\Vert^{2} \land p_{S}(e, (0, w)) = 0$$

*Proof.* Machine-checked in Lean as `D5/S0/Certificates/MinkowskiNullConeRigidity.null_cone_spatial_rigidity` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Evaluate at the two null vectors with spatial coordinate w and time coordinates equal to plus and minus the norm of w. Adding the resulting equations fixes the spatial restriction. Subtracting them kills the mixed term when w is nonzero; the zero case follows from bilinearity.

**Theorem 1.2 (The time-axis value determines the scalar).**

$$\forall d \in \mathbb{N}, \forall S: \operatorname{QuadraticForm}(\mathbb{R}, V_{d}), (\forall v \in V_{d}, g_{d}(v) = 0 \Rightarrow S(v) = 0) \Rightarrow S = S(e) \cdot g_{d}$$

*Proof.* Machine-checked in Lean as `D5/S0/Certificates/MinkowskiNullConeRigidity.eq_smul_minkowski_of_null` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Expand at a time-axis vector plus a spatial vector and substitute both spatial identities. The equality holds as an equality of quadratic forms.

**Theorem 1.3 (Proportionality on every dimension).**

$$\forall d \in \mathbb{N}, \forall S: \operatorname{QuadraticForm}(\mathbb{R}, V_{d}), (\forall v \in V_{d}, g_{d}(v) = 0 \Rightarrow S(v) = 0) \Rightarrow \exists f \in \mathbb{R}, S = f \cdot g_{d}$$

*Proof.* Machine-checked in Lean as `D5/S0/Certificates/MinkowskiNullConeRigidity.exists_smul_minkowski_of_null` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The scalar is allowed to vanish. No lower bound on d is required.

**Theorem 1.4 (One spatial dimension is already rigid).**

$$\neg \exists S: \operatorname{QuadraticForm}(\mathbb{R}, V_{1}), ((\forall v \in V_{1}, g_{1}(v) = 0 \Rightarrow S(v) = 0) \land (\forall f \in \mathbb{R}, S \neq f \cdot g_{1}))$$

*Proof.* Machine-checked in Lean as `D5/S0/Certificates/MinkowskiNullConeRigidity.no_one_space_dimension_counterexample` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The two null lines suffice in dimension two. A binary quadratic form vanishing on both has zero mixed coefficient and opposite diagonal coefficients. Thus no nonproportional example exists in one spatial dimension.

## References

- Truth anchor: `D5/S0/Certificates/MinkowskiNullConeRigidity.eq_smul_minkowski_of_null`
- Truth anchor: `D5/S0/Certificates/MinkowskiNullConeRigidity.exists_smul_minkowski_of_null`
- Truth anchor: `D5/S0/Certificates/MinkowskiNullConeRigidity.no_one_space_dimension_counterexample`
- Truth anchor: `D5/S0/Certificates/MinkowskiNullConeRigidity.null_cone_spatial_rigidity`
