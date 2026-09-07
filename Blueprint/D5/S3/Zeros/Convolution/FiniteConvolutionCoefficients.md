# Finite Convolution Coefficients

## Abstract

Coefficient and degree companions for the existing arbitrary-degree additive convolution.

The elementaryCoeff and additiveConvolution definitions are reused from FiniteFreeCommutatorDegreeFour, whose definitions accept arbitrary n. The results here supply the finite-symbol operator identity and the rectangular evenization identity. They do not use the degree-four preservation endpoint.

**Theorem 1.1 (Bounded Coefficient Reconstruction).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.coeff_reverse_sum`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.coeff_reverse_sum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Over any commutative ring, the coefficient of X^(n-k) in the sum of a(i) X^(n-i), for i from zero through n, is a(k) when k<=n. The bound prevents ambiguity from truncated natural subtraction.

**Theorem 1.2 (Coefficients Above the Bound Vanish).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.coeff_reverse_sum_above`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.coeff_reverse_sum_above` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Over any commutative ring, every coefficient above n in this descending reconstruction is zero. This supplies both degree bounds.

**Theorem 1.3 (Cancellation of the Three Signs).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.signed_coefficient_product`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.signed_coefficient_product` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For i<=k and real a,b, multiplying the signed input product ((-1)^i a)((-1)^(k-i) b) by (-1)^k gives ab.

**Theorem 1.4 (Unsigned Additive Coefficient Formula).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.coeff_additiveConvolution`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.coeff_additiveConvolution` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For any real p,q and k<=n, coefficient n-k of their additive convolution equals (n)_k times the sum over i=0,...,k of p[n-i] q[n-(k-i)] divided by (n)_i (n)_(k-i). Here (n)_j is the descending factorial. No monicity assumption is needed.

**Theorem 1.5 (Additive Degree Bound).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.additive_natDegree_le`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.additive_natDegree_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The reconstructed additive convolution of any two real polynomials has natural degree at most its parameter n.

**Theorem 1.6 (Monicity and Exact Additive Degree).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.additive_monic_natDegree`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.additive_monic_natDegree` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

If p and q are monic real polynomials of exact degree n, their additive convolution is monic and has exact degree n. Its nonzeroness eliminates the zero-output alternative in BB.

## References

- Truth anchor: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.additive_monic_natDegree`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.additive_natDegree_le`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.coeff_additiveConvolution`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.coeff_reverse_sum`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.coeff_reverse_sum_above`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.signed_coefficient_product`
- Dependency: [D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour](FiniteFreeCommutatorDegreeFour.md)
