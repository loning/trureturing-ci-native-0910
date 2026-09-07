# Conditioning of Even Lagrange Interpolation

## Abstract

Gautschi-type finite products bound the actual Mathlib Lagrange basis on squared nodes, keeping direct and reflected separation explicit.

**Definition 1.1 (Finite conditioning product).**

Lean statement: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squaredNodeBudget`

*Formalization.* `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squaredNodeBudget` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The radius and gap data can be rational. Positive gap hypotheses appear on every soundness theorem; totalized division at zero supplies no certificate.

**Theorem 1.2 (Actual Lagrange basis on a disk).**

Lean statement: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.lagrange_squared_basis_norm_le`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.lagrange_squared_basis_norm_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Expand Mathlib Lagrange.basis into basisDivisor factors. Apply the triangle inequality to each numerator and the certified lower bound to each denominator. This is the product mechanism in Gautschi (1962), Sections 2-3, specialized to squared nodes.

**Theorem 1.3 (Explicit polynomial growth).**

Lean statement: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squaredNodeBudget_le_growth`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squaredNodeBudget_le_growth` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Each numerator R^2+A_j^2 is at most R^2*(1+A_j^2). Multiply the finite nonnegative inequalities. No inverse-matrix condition number is left unspecified.

**Theorem 1.4 (Seed-normalized interpolation bound).**

Lean statement: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.lagrange_squared_interpolate_norm_le`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.lagrange_squared_interpolate_norm_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the actual existing interpolate linear map and the basis estimate. The source integrates classical interpolation estimates; it makes no independent novelty claim for Gautschi bounds.

**Theorem 1.5 (Both types of collision matter).**

Lean statement: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squared_gap_factorization`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squared_gap_factorization` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The polynomial difference-of-squares factorization and multiplicativity of the complex norm give the equality. Separating only direct neighbors cannot certify even interpolation.

**Theorem 1.6 (Transport certified node separations).**

Lean statement: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squared_gap_lower_bound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squared_gap_lower_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is the arithmetic interface for rigorous node enclosures. The lower bounds must be certified against the actual complex nodes.

## References

- Truth anchor: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.lagrange_squared_basis_norm_le`
- Truth anchor: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.lagrange_squared_interpolate_norm_le`
- Truth anchor: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squaredNodeBudget`
- Truth anchor: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squaredNodeBudget_le_growth`
- Truth anchor: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squared_gap_factorization`
- Truth anchor: `D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds.squared_gap_lower_bound`
