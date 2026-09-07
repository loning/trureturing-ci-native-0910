# Eulerian Matrix Square, Row 31

## Abstract

The ordinary Eulerian matrix square has only real nonpositive roots in row 31.

Mao and Wang, The Narayana transformation, arXiv:2607.01572v1, Conjecture 4.1 on PDF page 11 asks whether the row generating polynomials of the matrix squares A squared and D squared have only real nonpositive roots. Page 10 reports a computation of the first 30 rows of A squared. This result treats only row 31 of A squared. It does not claim the entire conjecture, worldwide priority, or that the authors did not compute row 31.

**Lemma 1.1 (Triangle Recurrence).**

Lean statement: `D5/S3/Zeros/Convolution/EulerianSquareRow31.A_recurrence`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/EulerianSquareRow31.A_recurrence` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The list representation starts at [1], has zero constant entry in each positive row, and is zero beyond column n. The recurrence is A(n,k) = (n-k+1) A(n-1,k-1) + k A(n-1,k). The product coefficients sum A(31,j) A(j,k) for k <= j <= 31; this is ordinary matrix multiplication.

**Theorem 1.2 (Real Splitting and Root Signs).**

Lean statement: `D5/S3/Zeros/Convolution/EulerianSquareRow31.certified_row31`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/EulerianSquareRow31.certified_row31` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Lean checks integer equalities for all triangle entries through row 31 and all product coefficients. After extracting the root at zero, homogeneous integer Horner evaluation certifies alternating signs at 31 strictly increasing negative rational endpoints. The intermediate value theorem supplies 30 distinct negative roots. The polynomial degree bounds the root count and completes real splitting and the sign claim.

## References

- Truth anchor: `D5/S3/Zeros/Convolution/EulerianSquareRow31.A_recurrence`
- Truth anchor: `D5/S3/Zeros/Convolution/EulerianSquareRow31.certified_row31`
