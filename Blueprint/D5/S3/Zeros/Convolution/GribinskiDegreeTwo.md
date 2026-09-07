# Gribinski Convolution in Degree Two

## Abstract

The degree-two generalized rectangular convolution preserves nonnegative real roots exactly for alpha greater than minus one on its definition domain.

The target is Conjecture 3.13 of Even Hypergeometric Polynomials and Finite Free Commutators, arXiv:2502.00254v2, at m=2. Definition 3.10 has the product of the two falling factorials as prefactor. The source paper also proves the special parameter alpha=-1/2. The present formalization covers every real alpha>-1 at degree two; no claim about larger degrees or worldwide priority is made.

**Definition 1.1 (Definition from General Coefficients).**

Lean statement: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.boxplus`

*Formalization.* `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.boxplus` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The signed degree-two coefficients are divided by the product of Mathlib's two descending Pochhammer values. Their finite convolution is multiplied by the same weight, and the three coefficients are reconstructed into a polynomial. This definition precedes the specialization to real input roots.

**Theorem 1.2 (Agreement with Definition 3.10).**

Lean statement: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.normalized_coefficient_convolution`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.normalized_coefficient_convolution` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For alpha different from -1 and -2, each normalized output coefficient at k=0,1,2 is the sum of products of normalized input coefficients over i+j=k. Both prefactors are nonzero on precisely this domain.

**Theorem 1.3 (G1: Explicit Coefficients).**

Lean statement: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g1_explicit_coefficients`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g1_explicit_coefficients` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For input roots a,b and c,d, the output is X^2-(a+b+c+d)X +ab+cd+kappa*(a+b)*(c+d), where kappa=(alpha+1)/(2*(alpha+2)). The identity holds for arbitrary real input roots.

**Theorem 1.4 (G2: Discriminant Bound and Equality).**

Lean statement: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g2_discriminant_bound`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g2_discriminant_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Writing P=a+b and Q=c+d, the discriminant is at least 2*P*Q*(1-2*kappa). The difference is (a-b)^2+(c-d)^2. Equality holds when a=b and c=d. This algebraic bound even holds without assuming nonnegative input roots.

**Theorem 1.5 (G3: Preservation for Every Real Alpha Greater Than -1).**

Lean statement: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g3_nonnegative_roots`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g3_nonnegative_roots` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For nonnegative input roots and alpha>-1, kappa lies strictly between zero and one half. The sum, product and discriminant have the required signs. Mathlib's quadratic root existence theorem gives a real root; its complementary root and Vieta's identities give the required factorization with both roots nonnegative.

**Theorem 1.6 (G4: The Interval Between -2 and -1).**

Lean statement: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g4_negative_product`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g4_negative_product` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The explicit inputs (a,b,c,d)=(1,0,1,0) have output constant coefficient kappa<0. Hence no two nonnegative roots can factor it.

**Theorem 1.7 (G4: Alpha Below -2).**

Lean statement: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g4_negative_discriminant`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g4_negative_discriminant` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The explicit inputs (a,b,c,d)=(1,1,1,1) have discriminant 8*(1-2*kappa)=8/(alpha+2)<0. Mathlib's nonsquare-discriminant theorem proves that the polynomial has no real root at all.

**Theorem 1.8 (The Exact Parameter Range).**

Lean statement: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.preservation_iff`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.preservation_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

On the domain alpha different from -1 and -2, preservation for every nonnegative input-root quadruple is equivalent to alpha>-1. The two explicit counterexample families cover the whole remaining domain.

## References

- Truth anchor: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.boxplus`
- Truth anchor: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g1_explicit_coefficients`
- Truth anchor: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g2_discriminant_bound`
- Truth anchor: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g3_nonnegative_roots`
- Truth anchor: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g4_negative_discriminant`
- Truth anchor: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g4_negative_product`
- Truth anchor: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.normalized_coefficient_convolution`
- Truth anchor: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.preservation_iff`
