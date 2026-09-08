# Fourier-Laplace Closed-Strip Decay

## Abstract

The Fourier-Laplace closed-strip bound has a specific two-jet constant, bounded by finite unweighted L1 enclosures and the support radius.

**Definition 1.1 (Explicit weighted two-jet constant).**

Lean statement: `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.closedStripJetBudget`

*Formalization.* `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.closedStripJetBudget` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This is the precise constant produced by the existing two integrations by parts. No convergence-neighborhood choice occurs.

**Theorem 1.2 (The named constant satisfies the original bound).**

Lean statement: `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.closedStripJetBudget_spec`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.closedStripJetBudget_spec` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The existing integration-by-parts proof is retained and exposes its actual weighted zeroth and second derivative integrals.

**Theorem 1.3 (Uniform quadratic decay on every closed strip).**

Lean statement: `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.fourierLaplace_decay_closedStrip`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.fourierLaplace_decay_closedStrip` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The original public existential statement is preserved as an application of the named constant theorem.

**Theorem 1.4 (Support and finite seminorm enclosures).**

Lean statement: `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.closedStripJetBudget_le_support_jets`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.closedStripJetBudget_le_support_jets` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Derivative topological supports lie in the original support. Bound each exponential weight on that closed interval, compare the integrals and add.

## References

- Truth anchor: `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.closedStripJetBudget`
- Truth anchor: `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.closedStripJetBudget_le_support_jets`
- Truth anchor: `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.closedStripJetBudget_spec`
- Truth anchor: `D5/S3/Weil/TestFunctions/FourierLaplaceClosedStripDecay.fourierLaplace_decay_closedStrip`
