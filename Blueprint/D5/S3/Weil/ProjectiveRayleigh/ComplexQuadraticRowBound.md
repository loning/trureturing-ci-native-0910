# Complex Mixed-Term Row Bounds

## Abstract

The existing real row estimate controls complete complex mixed forms, absolutely convergent coefficient series and weighted sign margins.

**Theorem 1.1 (Control every complex cross term).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.norm_complex_quadratic_le_rows`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.norm_complex_quadratic_le_rows` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The triangle inequality reduces the complex form to coefficient norms and entry norms. The existing real row theorem then supplies the bound, requiring only symmetry of entry norms.

**Theorem 1.2 (Retain a prescribed weighted energy).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.norm_complex_quadratic_le_weighted_energy`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.norm_complex_quadratic_le_weighted_energy` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A row budget proportional to each energy weight controls the full form by eta times that weighted energy.

**Theorem 1.3 (Matrix coefficients given by infinite series).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.norm_series_quadratic_le_weighted_energy`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.norm_series_quadratic_le_weighted_energy` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Absolute summability justifies bounding each summed entry by its sum of norms. The summed matrix has symmetric entry norms, and its row budget remains an explicit hypothesis.

**Theorem 1.4 (Positive weights detect nonzero vectors).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.weighted_energy_pos`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.weighted_energy_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A nonzero coefficient vector has a nonzero coordinate. Its positive weighted squared norm gives a strictly positive term in the finite energy sum. The scaled-row module reuses this theorem.

**Theorem 1.5 (Preserve a negative diagonal margin).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.negative_margin_of_complex_rows`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.negative_margin_of_complex_rows` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A row error budget strictly below the negative diagonal margin yields negativity for every nonzero vector. The conclusion includes all mixed terms.

**Theorem 1.6 (Preserve a positive diagonal margin).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.positive_margin_of_complex_rows`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.positive_margin_of_complex_rows` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The lower bound on the real part of the complex error preserves positivity when the same row budget is below the positive diagonal margin.

The only real row-inequality owner is LongGapsBetweenPrimes.abs_quadratic_form_le_rows. Actual zeta matrix bounds and any sieve normalization must be supplied by their own analytic proofs. These generic results do not certify those inputs.

## References

- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.negative_margin_of_complex_rows`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.norm_complex_quadratic_le_rows`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.norm_complex_quadratic_le_weighted_energy`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.norm_series_quadratic_le_weighted_energy`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.positive_margin_of_complex_rows`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/ComplexQuadraticRowBound.weighted_energy_pos`
