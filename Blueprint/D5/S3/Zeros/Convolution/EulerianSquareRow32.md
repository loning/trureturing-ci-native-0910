# Eulerian Matrix Square, Row 32

## Abstract

The ordinary Eulerian matrix square has only real nonpositive roots in row 32.

Mao and Wang, The Narayana transformation, arXiv:2607.01572v1, Conjecture 4.1 on PDF page 11 concerns the row generating polynomials of the matrix squares A squared and D squared. Page 10 reports the first 30 rows of A squared. This certificate treats only row 32 of A squared, using the arbitrary-row definitions from EulerianSquareRow31. The literature recheck in docs/reports/eulerian-square-row32-r19.md found no prior public computation or certificate of this same row in the retrieved scope; unpublished and unindexed work remains unexcluded. No worldwide-priority claim is made.

**Lemma 1.1 (Exact Matrix Product).**

Lean statement: `D5/S3/Zeros/Convolution/EulerianSquareRow32.factor_row32`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/EulerianSquareRow32.factor_row32` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Integer equalities for the imported row definition and all 33 product coefficients connect the certificate to B(32) = X times H. No new Eulerian triangle is defined.

**Lemma 1.2 (Degree Exhaustion).**

Lean statement: `D5/S3/Zeros/Convolution/EulerianSquareRow32.row32_monic_degree`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/EulerianSquareRow32.row32_monic_degree` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The imported monic Horner representation gives degree 31 for H and degree 32 for B(32). Thus the 31 distinct negative roots and the extracted zero exhaust the degree.

**Theorem 1.3 (Real Splitting and Root Signs).**

Lean statement: `D5/S3/Zeros/Convolution/EulerianSquareRow32.certified_row32`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/EulerianSquareRow32.certified_row32` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Homogeneous integer Horner evaluations certify alternating signs at 32 strictly increasing negative rational endpoints. Numerators need at most 35 bits and denominators at most 24 bits. The intermediate value theorem supplies one root in each of the 31 disjoint open intervals. The imported root-count argument proves splitting and strict negativity for H; multiplication by X adds only the zero root.

## References

- Truth anchor: `D5/S3/Zeros/Convolution/EulerianSquareRow32.certified_row32`
- Truth anchor: `D5/S3/Zeros/Convolution/EulerianSquareRow32.factor_row32`
- Truth anchor: `D5/S3/Zeros/Convolution/EulerianSquareRow32.row32_monic_degree`
- Dependency: [D5/S3/Zeros/Convolution/EulerianSquareRow31](EulerianSquareRow31.md)
