# Actual Even Interpolation with Arithmetic Jet Budgets

## Abstract

Finite node radius, positive squared-node gap and target amplitude give actual compact even interpolants with explicit L1 derivative bounds. The construction combines the existing Lagrange realization with a finite-box seed.

**Definition 1.1 (The coefficient budget).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.interpolationCoefficientBudget`

*Formalization.* `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.interpolationCoefficientBudget` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The count d is the number of distinct squared interpolation nodes. Positive sigma bounds their pairwise distance. The natural exponent d-1 is truncated at zero for the empty case.

**Definition 1.2 (Finite-box derivative scale).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.interpolationJetScale`

*Formalization.* `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.interpolationJetScale` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Use q=2d+2 boxes and radius h=1/(4(R+1)). The finite-box scale 2(q+1)/h is exactly A.

**Definition 1.3 (An arithmetic seminorm budget).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.interpolationJetBudget`

*Formalization.* `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.interpolationJetBudget` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This is a deliberately coarse bound. The construction below proves it for s=0,1,2. The finite coefficient count and the highest derivative order are both retained.

**Theorem 1.4 (Coefficients from a disk bound).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.polynomial_coeff_norm_le_of_unit_disk`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.polynomial_coeff_norm_le_of_unit_disk` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Reuse Mathlib Polynomial.fourierCoeff_toAddCircle_natCast. The Haar measure is normalized to one, and the Fourier character has unit norm. No new polynomial Cauchy or Fourier theory is introduced.

**Theorem 1.5 (Actual Lagrange coefficients are controlled).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.lagrange_coeff_le_explicit_budget`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.lagrange_coeff_le_explicit_budget` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The existing GautschiEvenInterpolationBounds owner controls the interpolant on a disk. Use a square root only in the proof of disk coverage, then apply the library coefficient identity. The numerical bound itself uses finite arithmetic only. Literature anchor: Walter Gautschi, On inverses of Vandermonde and confluent Vandermonde matrices, Numerische Mathematik 4 (1962), 117-123, Section 2 (2.1) and Theorem 1 (3.1). Squared-node gaps include both direct and reflected separations.

**Theorem 1.6 (Exact derivatives of the existing realization).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.evenPolynomialDifferential_iterate_deriv`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.evenPolynomialDifferential_iterate_deriv` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Induct on s and use HasDerivAt.fun_sum. This is the existing interpolation constructor exposed for reuse; no second differential realization is defined.

**Theorem 1.7 (Every derivative term is included in the L1 budget).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.evenPolynomialDifferential_L1_le`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.evenPolynomialDifferential_L1_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

All derivatives are compactly supported and integrable. Apply the finite-sum triangle inequality and commute the finite sum with the integral. The powers of minus i have norm one.

**Theorem 1.8 (An actual test with no assumed jet certificate).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.exists_even_interpolant_with_explicit_jets`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.exists_even_interpolant_with_explicit_jets` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Construct finiteBoxSeed(h,q), q=2d+2. Its transform denominator is at least one half and all required derivatives are bounded by A^k. Apply the existing Lagrange polynomial differential realization. The polynomial degree bound limits the required derivatives; the coefficient estimate supplies M. The initial smooth bump's high derivatives never appear as inputs.

The finite-box identity is the one-dimensional scaled version of the derivative/difference relation in Michele Vergne, A remark on the convolution with the box spline, Annals of Mathematics 174 (2011), 607-618, Section 1, immediately before Section 2; DOI 10.4007/annals.2011.174.1.19. This integration is repo-derived and is not claimed as a new interpolation theorem. Source remains Candidate pending actual Lean compilation.

**Definition 1.9 (Executable rational constants).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.rationalInterpolationJetBudget`

*Formalization.* `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.rationalInterpolationJetBudget` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The rational function computes a budget, not the transcendental interpolating function itself. Validity requires nonnegative R,V and positive sigma with certified nodal bounds. Division by a zero uncertified gap is not an admissible application.

**Theorem 1.10 (Exact rational-to-real semantics).**

Lean statement: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.rationalInterpolationJetBudget_cast`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.rationalInterpolationJetBudget_cast` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The equality is proved by the field-cast identities. Thus rational arithmetic can supply the finite J0,J2 inputs of RationalWeilJetBudget without numerical differentiation or uncomputed derivative seminorms.

## References

- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.evenPolynomialDifferential_L1_le`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.evenPolynomialDifferential_iterate_deriv`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.exists_even_interpolant_with_explicit_jets`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.interpolationCoefficientBudget`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.interpolationJetBudget`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.interpolationJetScale`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.lagrange_coeff_le_explicit_budget`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.polynomial_coeff_norm_le_of_unit_disk`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.rationalInterpolationJetBudget`
- Truth anchor: `D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets.rationalInterpolationJetBudget_cast`
- Dependency: [D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation](EvenTestFunctionFiniteInterpolation.md)
- Dependency: [D5/S3/Weil/TestFunctions/FiniteBoxWeilMollifier](FiniteBoxWeilMollifier.md)
- Dependency: [D5/S3/Weil/TestFunctions/GautschiEvenInterpolationBounds](GautschiEvenInterpolationBounds.md)
