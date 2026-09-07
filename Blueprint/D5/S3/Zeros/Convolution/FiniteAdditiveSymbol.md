# Conditional Finite Additive Preservation

## Abstract

The BB finite-symbol criterion, as an explicit hypothesis, implies additive preservation.

Borcea-Branden is an explicit hypothesis. Upstream RealRooted at https://github.com/PerAlexandersson/RealRooted, commit acd0ec31118a155b083c8dd45af2015492ce0c10, proves RealRooted.BorceaBranden.finiteSymbolTheorem and RealRooted.BorceaBranden.finiteSymbol_preservesRealRootedUpTo without a BB hypothesis parameter. The cited probe r13-probe-0907/attempt-1/upstream-axioms.log reports the axiom closure [propext, Classical.choice, Quot.sound] for each. Its compatibility build failed at this repository's pin. The implementation seat read the upstream signatures; this work does not import or transplant that proof.

**Definition 1.1 (The Explicit BB Hypothesis).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.FiniteSymbolCriterion`

*Formalization.* `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.FiniteSymbolCriterion` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For every natural n and real linear polynomial map T, assume that nonvanishing of its finite algebraic symbol at all complex z,w with positive imaginary parts implies the following: for every real-split p of natural degree at most n, T(p) is zero or real-split. The symbol is the sum of choose(n,k) T(X^k)(z) w^(n-k), for k=0,...,n, expressed in R[x][y]. This hypothesis is universal over operators; it does not assume that the target convolution output is stable or real-split.

**Theorem 1.2 (The Symbol Is Q(x+y)).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.finiteSymbol_eq_translation`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.finiteSymbol_eq_translation` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

If q has natural degree at most n, the symbol of convolutionOperator n q equals Mathlib's Taylor translation of q, namely q(x+y). The operator sends X^k to HasseDeriv(n-k,q)/choose(n,k) for k<=n. The identity follows from the Taylor coefficient theorem and bounded coefficient reconstruction, without BB.

**Theorem 1.3 (Agreement with the Existing Convolution).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.operator_eq_additiveConvolution`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.operator_eq_additiveConvolution` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every real p and q with q of natural degree at most n, the constructed linear operator applied to p equals the existing additiveConvolution n p q. A coefficient calculation using binomial and descending-factorial identities proves this equality.

**Theorem 1.4 (Conditional Preservation in Every Degree).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.additive_splits`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.additive_splits` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Assuming FiniteSymbolCriterion, if p and q are monic real polynomials of exact degree n and both split over the reals, their additive convolution splits over the reals. Splitting of the nonzero q makes q(z+w) nonzero when z and w have positive imaginary parts. BB applies, and output monicity excludes zero. No output-stability hypothesis is supplied.

## References

- Truth anchor: `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.FiniteSymbolCriterion`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.additive_splits`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.finiteSymbol_eq_translation`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.operator_eq_additiveConvolution`
- Dependency: [D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients](FiniteConvolutionCoefficients.md)
