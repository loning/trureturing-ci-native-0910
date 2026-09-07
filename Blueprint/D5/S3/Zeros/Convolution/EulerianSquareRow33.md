# Eulerian Matrix Square, Row 33

## Abstract

Row 33 of the ordinary Eulerian matrix square has only real nonpositive roots.

Mao and Wang, The Narayana transformation, arXiv:2607.01572v1, Conjecture 4.1 on PDF page 11 asks for real nonpositive roots of the row generating polynomials of A squared and D squared. The paper reports the first 30 rows of A squared. This module certifies only row 33 of A squared. The literature recheck in docs/reports/eulerian-square-row33-r7.md found no earlier public computation or certification of this row in the retrieved scope. Unpublished and unindexed work is not excluded.

**Lemma 1.1 (Predecessor Quotient).**

Lean statement: `D5/S3/Zeros/Convolution/EulerianSquareRow33.factor_row32`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/EulerianSquareRow33.factor_row32` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The imported factorization identifies B(32) with X times H32. Both splitting and nonpositivity from certified_row32 anchor the proof; the nonzero constant 32 factorial excludes zero from the roots of H32.

**Lemma 1.2 (Exact Matrix Product).**

Lean statement: `D5/S3/Zeros/Convolution/EulerianSquareRow33.factor_row33`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/EulerianSquareRow33.factor_row33` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Exact integer row and coefficient equalities prove B(33) = X times H33 using the existing arbitrary-row definitions. H32 and H33 are monic of degrees 31 and 32.

**Theorem 1.3 (Strict Quotient Interlacing).**

Lean statement: `D5/S3/Zeros/Convolution/EulerianSquareRow33.quotient_interlacing`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/EulerianSquareRow33.quotient_interlacing` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Thirty-one disjoint rational intervals contain the predecessor roots. Integer interval Horner bounds fix the alternating signs of H33 throughout those intervals. The existing splitting certificate supplies the H32 roots; two outer positive evaluations then give 32 negative roots of H33. The theorem exhibits complete increasing root lists with s(i) < r(i) < s(i+1). No determinant expansion or global Wronskian positivity theorem is used.

**Theorem 1.4 (Real Splitting and Root Signs).**

Lean statement: `D5/S3/Zeros/Convolution/EulerianSquareRow33.certified_row33`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/EulerianSquareRow33.certified_row33` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Multiplication by X adds the zero root to the 32 distinct negative roots of H33. This proves both real splitting and nonpositivity of every real root of B(33). Interlacing concerns the quotients H32 and H33; the original row polynomials share the zero root.

## References

- Truth anchor: `D5/S3/Zeros/Convolution/EulerianSquareRow33.certified_row33`
- Truth anchor: `D5/S3/Zeros/Convolution/EulerianSquareRow33.factor_row32`
- Truth anchor: `D5/S3/Zeros/Convolution/EulerianSquareRow33.factor_row33`
- Truth anchor: `D5/S3/Zeros/Convolution/EulerianSquareRow33.quotient_interlacing`
- Dependency: [D5/S3/Zeros/Convolution/EulerianSquareRow32](EulerianSquareRow32.md)
