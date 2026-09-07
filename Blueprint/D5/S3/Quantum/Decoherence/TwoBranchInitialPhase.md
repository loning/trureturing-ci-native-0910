# Two-Branch Initial Phase

## Abstract

The equal two-branch process has a local phase with initial slope -3 kappa / 2.

**Theorem 1.1 (Initial value, derivative, and a common nonzero polar neighborhood).**

$$\forall kappa \in \mathbb{R},\; \operatorname{let} chi: \mathbb{R}\to\mathbb{C}, \operatorname{chi}\left(t\right) = \frac{\operatorname{exp}\left(-I \cdot kappa \cdot t\right) + \operatorname{exp}\left(-I \cdot 2 \cdot kappa \cdot t\right)}{2}; theta: \mathbb{R}\to\mathbb{R}, \operatorname{theta}\left(t\right) = \operatorname{im}\left(\operatorname{log}\left(\operatorname{chi}\left(t\right)\right)\right); \operatorname{theta}\left(0\right) = 0 \land \left(\operatorname{HasDerivAt}\left(theta, -\frac{3}{2} \cdot kappa, 0\right) \land \left(\exists epsilon \in \mathbb{R},\; epsilon > 0 \land \left(\forall t \in \mathbb{R},\; \left|t\right| < epsilon \Rightarrow \left(\operatorname{chi}\left(t\right) \ne 0 \land \operatorname{chi}\left(t\right) = \operatorname{ofReal}\left(\Vert\operatorname{chi}\left(t\right)\Vert\right) \cdot \operatorname{exp}\left(I \cdot \operatorname{theta}\left(t\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Quantum/Decoherence/TwoBranchInitialPhase.two_branch_initial_local_phase` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every real kappa, chi is the equal average of the complex exponentials at frequencies kappa and twice kappa. The phase theta is the imaginary part of the principal complex logarithm of chi.

The proof differentiates both explicit exponentials, divides their sum by two, applies the real-domain complex logarithm chain rule at chi(0) = 1, and takes the imaginary part. Continuity supplies a positive radius on which chi is nonzero. The polar identity uses the same radius.

The radius may depend on kappa. This result concerns the initial local phase only; it makes no global nonvanishing, global phase, record-channel identification, or whole-atom coverage claim.

## References

- Truth anchor: `D5/S3/Quantum/Decoherence/TwoBranchInitialPhase.two_branch_initial_local_phase`
