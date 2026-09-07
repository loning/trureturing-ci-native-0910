# Sparse Even Interpolation and Quantitative Jets

## Abstract

Actual smooth sparse interpolation with explicit finite jet budgets and repeated exceptional nodes.

**Definition 1.1 (Indexed exceptional annihilator).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial`

*Formalization.* `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The indexing type is finite. The node map may repeat values; no injectivity assumption is present.

**Definition 1.2 (Target-only normalized solve).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial`

*Formalization.* `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The denominator is evaluated only at targets. Exceptional-to-exceptional distances never occur.

**Definition 1.3 (Finite coefficient budget).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseCoefficientBudget`

*Formalization.* `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseCoefficientBudget` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

R bounds targets, Y bounds exceptions, sigma separates distinct squared targets, and tau separates each squared target from each squared exception.

**Definition 1.4 (Explicit derivative budget).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseJetBudget`

*Formalization.* `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseJetBudget` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The derivative order includes the annihilator degree. Removing unnecessary gap assumptions does not remove the cost of enforcing exceptional zeros.

**Theorem 1.5 (Repeated exceptions are annihilated).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial_zero`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial_zero` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

One factor in the finite product vanishes. Repeated exception values are permitted.

**Theorem 1.6 (Target denominator lower bound).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial_lower`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial_lower` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Multiply the certified nonnegative factor lower bounds. No separation between two exceptions is needed.

**Theorem 1.7 (Annihilator disk bound).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial_unit_disk`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial_unit_disk` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Apply the triangle inequality to each factor and multiply. This is an estimate for the actual exception polynomial.

**Theorem 1.8 (Exact target interpolation).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_target_value`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_target_value` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The existing Mathlib Lagrange theorem returns the normalized target value; cancellation restores the prescribed value.

**Theorem 1.9 (Exact exceptional zeros).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_exception_value`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_exception_value` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The annihilator remains a factor of the final polynomial.

**Theorem 1.10 (Gautschi-type sparse coefficient control).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_coeff_bound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_coeff_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the existing Lagrange disk product bound, the exception denominator lower bound and the unit-disk coefficient theorem. Gautschi (1962), Section 2 (2.1), and Section 3, Theorem 1 (3.1), supply the classical product mechanism.

**Theorem 1.11 (Count the exceptional derivative cost).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_natDegree_le`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_natDegree_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The product degree is bounded by the sum of the exception count and the target interpolation degree. Zero target data and empty types are included.

**Theorem 1.12 (Actual smooth sparse interpolation).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.exists_sparse_even_interpolant_with_explicit_jets`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.exists_sparse_even_interpolant_with_explicit_jets` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Construct the actual finite-box seed using q=2(d+e)+2 averages and apply the existing polynomial differential realization. The finiteBoxSeed budget proves all needed derivative estimates without any unknown bump seminorm. Vergne (2011), Section 1, records the classical box-spline derivative/finite-difference identity used by that owner. The result imposes no mutual exceptional separation. It assumes certified target and target-exception geometry and does not assert any off-line zeta zero exists.

**Definition 1.13 (Rational execution).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.rationalSparseJetBudget`

*Formalization.* `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.rationalSparseJetBudget` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The arithmetic is total. Its use as a bound requires the signs and actual geometric inequalities in the semantic theorem.

**Theorem 1.14 (Exact real semantics of rational arithmetic).**

Lean statement: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.rationalSparseJetBudget_cast`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.rationalSparseJetBudget_cast` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The proof uses only rational cast homomorphisms. No floating-point rounding or external numerical oracle enters.

## References

- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.exists_sparse_even_interpolant_with_explicit_jets`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.rationalSparseJetBudget`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.rationalSparseJetBudget_cast`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseCoefficientBudget`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_coeff_bound`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_exception_value`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_natDegree_le`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseEvenPolynomial_target_value`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.sparseJetBudget`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial_lower`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial_unit_disk`
- Truth anchor: `D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.squaredExceptionPolynomial_zero`
- Dependency: [D5/S3/Weil/TestFunctions/QuantitativeEvenInterpolationJets](QuantitativeEvenInterpolationJets.md)
