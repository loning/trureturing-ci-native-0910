# Scaled Complex Quadratic Row Bounds

## Abstract

Positive scaled row certificates retain individual energy weights and explicit perturbation margins.

**Theorem 1.1 (A positive scaling controls every mixed coefficient).**

Lean statement: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.norm_complex_quadratic_le_scaled_rows`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.norm_complex_quadratic_le_scaled_rows` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Let p be positive and let the complex matrix have symmetric entry norms. A row bound after multiplying column j by p(j) controls the full complex quadratic by the original weighted energy. The proof applies the existing real row theorem to coefficient norms divided by p and to the matrix with entries p(i)p(j) times the original entry norm. No cross term is discarded.

**Theorem 1.2 (Absolutely convergent matrix coefficients).**

Lean statement: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.norm_series_quadratic_le_scaled_rows`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.norm_series_quadratic_le_scaled_rows` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Each coefficient series is absolutely summable. Its norm is bounded by the sum of norms before applying the scaled row certificate. The symmetry hypothesis concerns the summed matrix, not each individual term in the series.

**Theorem 1.3 (A fixed envelope gives geometric coefficient-uniform decay).**

Lean statement: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.geometric_matrix_envelope_bound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.geometric_matrix_envelope_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A fixed real envelope and a positive scaled row witness give a geometric error coefficient for all depths and all coefficient vectors. The entrywise envelope inequality remains a hypothesis. No actual zeta estimate or effective interpolation constant is supplied by this generic result.

**Theorem 1.4 (Retain the remaining coercive margin).**

Lean statement: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.scaled_rows_robust_coercive_bound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.scaled_rows_robust_coercive_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The matrix error consumes eta units of weighted energy. An independently bounded complex error consumes tau more. The conclusion retains margin minus eta minus tau as a quantitative coefficient for every vector, including the zero vector.

**Theorem 1.5 (Strict negativity with independent perturbations).**

Lean statement: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.scaled_rows_robust_strict_negativity`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.scaled_rows_robust_strict_negativity` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Positive energy weights and a nonzero coefficient vector make the weighted energy strictly positive. The already-owned positivity theorem is reused. A strict positive remaining margin therefore certifies negativity on the entire nonzero coefficient space.

**Theorem 1.6 (The exact two-channel threshold).**

Lean statement: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.two_channel_scaling_iff`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.two_channel_scaling_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For positive coupling r and positive second diagonal budget d1, a positive ratio t satisfying both strict scaled inequalities exists exactly when r squared is less than d0 times d1. The reverse implication chooses the midpoint of the nonempty interval between r divided by d1 and d0 divided by r. No positivity hypothesis on d0 is needed separately.

**Theorem 1.7 (An exact case where scaling enlarges the certificate domain).**

Lean statement: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.two_channel_scaled_regression`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.two_channel_scaled_regression` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The energy weights are one and nine, and the off-diagonal complex entries are both two. Scaling by three and one yields eta equal to two thirds and certifies all nonzero complex vectors. The same matrix has no unscaled row budget below one. This exact algebraic regression is not a model of zeta zeros or an information-escape test arena.

These are classical Schur-test techniques adapted to the repository's mixed-form certificates. A later application must construct and check the actual matrix envelope and scaling witness. Lean compilation, axiom closure and Scribe reconciliation are separate verification steps; this source does not assert their completion.

## References

- Truth anchor: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.geometric_matrix_envelope_bound`
- Truth anchor: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.norm_complex_quadratic_le_scaled_rows`
- Truth anchor: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.norm_series_quadratic_le_scaled_rows`
- Truth anchor: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.scaled_rows_robust_coercive_bound`
- Truth anchor: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.scaled_rows_robust_strict_negativity`
- Truth anchor: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.two_channel_scaled_regression`
- Truth anchor: `D5/S3/Weil/ZetaLinear/ScaledComplexQuadraticRowBound.two_channel_scaling_iff`
- Dependency: [D5/S3/Weil/ZetaLinear/ComplexQuadraticRowBound](ComplexQuadraticRowBound.md)
