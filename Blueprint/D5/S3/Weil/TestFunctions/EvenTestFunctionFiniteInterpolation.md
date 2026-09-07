# Finite Even Weil Interpolation

## Abstract

Sign-separated finite data admit actual even smooth compact interpolation, with a specified support radius from a bound on the nodes.

**Theorem 1.1 (Exact finite interpolation).**

Lean statement: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.even_weilTestFunction_finite_interpolation`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.even_weilTestFunction_finite_interpolation` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Square the sign-separated nodes, use Mathlib Lagrange interpolation and apply the resulting polynomial differential operator to an even seed. The original proof and public statement are preserved.

**Theorem 1.2 (A specified interpolation radius).**

Lean statement: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.even_weilTestFunction_finite_interpolation_with_radius`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.even_weilTestFunction_finite_interpolation_with_radius` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the explicit normalized seed whose transform norm is at least one half at every node. The existing polynomial differential constructor is reused. Every derivative has topological support within the seed support, so the complete interpolant has the specified radius.

**Theorem 1.3 (Fixed support for every finite node family).**

Lean statement: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.even_weilTestFunction_finite_interpolation_unit_support`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.even_weilTestFunction_finite_interpolation_unit_support` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Bound the finite node norms by their sum and apply the explicit-radius construction. The radius is at most one. This does not give a norm or derivative bound uniform over colliding nodes and does not assert negativity of the full Weil form in this small window.

**Definition 1.4 (The existing polynomial differential realization).**

Lean statement: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.evenPolynomialDifferential`

*Formalization.* `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.evenPolynomialDifferential` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The previously private constructor is exposed without changing its body, so quantitative consumers use this exact realization instead of rebuilding interpolation.

**Theorem 1.5 (Exact transform multiplication).**

Lean statement: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.fourierLaplace_evenPolynomialDifferential`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.fourierLaplace_evenPolynomialDifferential` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Repeated integration by parts and the finite polynomial expansion prove the identity. Its original proof body is unchanged.

**Theorem 1.6 (Differentiation does not enlarge support).**

Lean statement: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.evenPolynomialDifferential_tsupport`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.evenPolynomialDifferential_tsupport` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

All iterated derivatives vanish off the seed support; the finite sum does as well. The original proof is reused.

## References

- Truth anchor: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.evenPolynomialDifferential`
- Truth anchor: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.evenPolynomialDifferential_tsupport`
- Truth anchor: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.even_weilTestFunction_finite_interpolation`
- Truth anchor: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.even_weilTestFunction_finite_interpolation_unit_support`
- Truth anchor: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.even_weilTestFunction_finite_interpolation_with_radius`
- Truth anchor: `D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation.fourierLaplace_evenPolynomialDifferential`
- Dependency: [D5/S3/Weil/TestFunctions/FinitePaleyWienerInterpolation](FinitePaleyWienerInterpolation.md)
- Dependency: [D5/S3/Weil/TestFunctions/QuantitativeEvenSeed](QuantitativeEvenSeed.md)
