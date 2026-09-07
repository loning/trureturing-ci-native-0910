# Finite Free Commutators in Degree Four

## Abstract

The finite free commutator of any two centered monic real-rooted quartics has four real roots.

The operation is defined by Definition 2.9 and Notations 2.2, 3.7 and 5.1 of Campbell, Morales and Perales, arXiv:2502.00254v2. Sym is additive convolution with dilation by minus one. The commutator then uses two multiplicative convolutions, the second with the source finite sum z(4). The coefficient formula below is proved from those definitions. Conjecture 5.3 is treated here only for centered monic quartics. No premise from Theorem 5.6 is assumed.

**Lemma 1.1 (Coefficient identity).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_expansion`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_expansion` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This normalization companion holds for arbitrary real coefficients. Its consumer is centered_factorization. For p=X^4+uX^2+vX+w and q=X^4+UX^2+VX+W, the output is X^4-(16uU/15)X^2 +(u^2+12w)(U^2+12W)/60. For the input with coefficients u=-5, v=0, w=4, both definition and formula paths yield constant 5329/60 and quadratic coefficient -80/3.

**Lemma 1.2 (Invariant bounds from real roots).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_quartic_invariant_bounds`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_quartic_invariant_bounds` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Writing the four real roots as a,b,c,d, their sum is zero. Three squared-sum identities imply u is nonpositive and the invariant u squared plus 12w lies between zero and four times u squared. Each identity is used: the first controls the root sum in the squared variable, the second its product, and the third its discriminant.

**Theorem 1.3 (Two nonnegative squared roots).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_factorization`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_factorization` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The two input factorizations are the only hypotheses. The invariant bounds give a nonnegative discriminant, including all zero cases. Mathlib's quadratic formula and Vieta theorem yield nonnegative s and t and the factorization into X squared minus s and X squared minus t. The named coefficient identity is used here.

**Theorem 1.4 (Real-rootedness).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_real_rooted`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_real_rooted` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The four exhibited roots are sqrt(s), -sqrt(s), sqrt(t), -sqrt(t). RealRooted4 is an equality to a product indexed by Fin(4), so repeated and zero roots are retained. Translation invariance for arbitrary monic quartics and the all-degree conjecture are outside this module. The proof is a repository derivation; the bounded literature search does not certify worldwide priority.

## References

- Truth anchor: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_expansion`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_factorization`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_quartic_invariant_bounds`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_real_rooted`
