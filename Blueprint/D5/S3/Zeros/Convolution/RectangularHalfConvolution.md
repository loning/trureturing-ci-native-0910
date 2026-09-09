# Rectangular Convolution at Alpha Minus One Half

## Abstract

Assuming BB, rectangular convolution at alpha=-1/2 preserves nonnegative roots in every positive degree.

This is the conditional formalization of arXiv:2502.00254v2 Corollary 3.14, using the evenization identity in Proposition 3.12. BB is the explicit universal FiniteSymbolCriterion from FiniteAdditiveSymbol; that module records the upstream source and probe axiom readings. This does not prove BB at the current pin. The parameter is fixed at -1/2, while the degree is arbitrary. The weight is the PRODUCT prefactor from corrected Definition 3.10, not the erroneous ratio. The degree-two coefficient definitions are not used.

**Definition 1.1 (General Rectangular Coefficient Reconstruction).**

Lean statement: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.rectangularBoxplus`

*Formalization.* `D5/S3/Zeros/Convolution/RectangularHalfConvolution.rectangularBoxplus` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Write F_m(k) for the product, over j=0,...,k-1, of (m-j)(m-1/2-j), with F_m(0)=1. The polynomial is reconstructed through degree m from signed elementary coefficients e_k. Its e_k is F_m(k) times the sum of e_i(p)e_(k-i)(q) divided by F_m(i)F_m(k-i), for i=0,...,k and 0<=k<=m.

**Theorem 1.2 (Positive Weights on the Definition Range).**

Lean statement: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.weight_pos`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/RectangularHalfConvolution.weight_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For natural m,k with k<=m, F_m(k)>0. Thus every denominator used in the bounded convolution formula is nonzero.

**Theorem 1.3 (Pairing Descending Factors).**

Lean statement: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.doubled_falling`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/RectangularHalfConvolution.doubled_falling` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For all natural m,k, the descending factorial (2m)_(2k) equals 4^k F_m(k). Induction pairs two successive factors at each step. The equality includes the zero products when k exceeds m.

**Theorem 1.4 (Exact Elementary Coefficients).**

Lean statement: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.definition_consistency`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/RectangularHalfConvolution.definition_consistency` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For arbitrary real p,q and k<=m, the reconstructed polynomial's signed coefficient e_k satisfies exactly the stated product-weight convolution formula. The leading coefficient is included at k=0.

**Theorem 1.5 (Monicity and Exact Degree).**

Lean statement: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.monic_natDegree`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/RectangularHalfConvolution.monic_natDegree` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For monic real p,q of exact degree m, rectangularBoxplus m p q is monic and has exact degree m. This is independent of BB and of any root assumptions.

**Theorem 1.6 (Evenization Commutes with Convolution).**

Lean statement: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.evenization_convolution`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/RectangularHalfConvolution.evenization_convolution` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every natural m and all real p,q, expanding rectangularBoxplus m p q by two equals additiveConvolution (2m) of the two expanded inputs. Mathlib supplies the expansion coefficients. The odd terms vanish; paired descending factors and powers of four identify the even terms. This polynomial equality assumes no BB.

**Theorem 1.7 (Conditional Preservation for Every Positive Degree).**

Lean statement: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.preserves_nonnegative_roots`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/RectangularHalfConvolution.preserves_nonnegative_roots` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Assume the universal BB finite-symbol criterion and m>=1. Let p,q be monic real polynomials of exact degree m, each splitting over the reals and having every real root nonnegative. Then rectangularBoxplus m p q is monic, has exact degree m, splits over the reals, and has every real root nonnegative. The proof splits the expanded inputs, applies conditional additive preservation through the proved evenization identity, then descends using the geometry of real squares. All root multiplicities, including zero roots, are allowed.

**Theorem 1.8 (Uniqueness from the Bounded Formula).**

Lean statement: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.eq_of_coefficients`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/RectangularHalfConvolution.eq_of_coefficients` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Any real polynomial r of natural degree at most m satisfying the elementary-coefficient formula for all k<=m equals the constructed rectangularBoxplus. No monicity or splitting assumptions are needed.

**Theorem 1.9 (The Coefficient-Specified Corollary).**

Lean statement: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.preserves_of_coefficients`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/RectangularHalfConvolution.preserves_of_coefficients` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Assume the universal BB criterion, m>=1, and monic real p,q,r of exact degree m. Assume that p,q split over the reals with every real root nonnegative, and that r satisfies the specified coefficient formula for every k<=m. Then r splits over the reals and every real root of r is nonnegative. This is the requested form for any output specified by its coefficients.

## References

- Truth anchor: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.definition_consistency`
- Truth anchor: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.doubled_falling`
- Truth anchor: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.eq_of_coefficients`
- Truth anchor: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.evenization_convolution`
- Truth anchor: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.monic_natDegree`
- Truth anchor: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.preserves_nonnegative_roots`
- Truth anchor: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.preserves_of_coefficients`
- Truth anchor: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.rectangularBoxplus`
- Truth anchor: `D5/S3/Zeros/Convolution/RectangularHalfConvolution.weight_pos`
- Dependency: [D5/S3/Zeros/Convolution/EvenPolynomialRoots](EvenPolynomialRoots.md)
- Dependency: [D5/S3/Zeros/Convolution/FiniteAdditiveSymbol](FiniteAdditiveSymbol.md)
