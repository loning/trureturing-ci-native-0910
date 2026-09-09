# Finite Free Commutators in Degree Six

## Abstract

The finite free commutator of any two monic real-rooted sextics has six real roots.

This is the degree-six case of Conjecture 5.3 in Campbell, Morales, and Perales, Even Hypergeometric Polynomials and Finite Free Commutators, arXiv:2502.00254v2, SIGMA 21 (2025), 108, DOI 10.3842/SIGMA.2025.108. The operation is Sym(p) boxtimes_6 Sym(q) boxtimes_6 z(6). Both inputs range over all products of six real linear factors. No simplicity or nonzero-root hypothesis is imposed.

**Lemma 1.1 (Coefficients in the squared variable).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.centered_expansion`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.centered_expansion` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Write p=X^6+uX^4+vX^3+wX^2+tX+s and Cp=2s+2uw/15-v^2/20, with capital letters for q. Then Sym(p)=X^6+2uX^4+(2w+2u^2/5)X^2+Cp and z(6)=X^6-(270/7)X^4+(375/14)X^2-4/7. The commutator is X^6-aX^4+bX^2-c, where a=24uU/35, b=2(u^2+5w)(U^2+5W)/105, and c=4CpCq/7.

**Lemma 1.2 (Three nonnegative cubic roots).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.cubic_nonnegative_factorization`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.cubic_nonnegative_factorization` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Suppose a,b,c and a^2b^2-4b^3-4a^3c-27c^2+18abc are nonnegative. The intermediate value theorem gives a nonnegative root x of Y^3-aY^2+bY-c. Put d=a^2+2ax-3x^2-4b and R=3x^2-2ax+b. The cubic discriminant equals dR^2. When R is nonzero this yields d>=0; when R=0 one has d=(a-3x)^2. The other roots are (a-x+sqrt(d))/2 and (a-x-sqrt(d))/2. Every negative argument makes the cubic strictly negative, so all three roots are nonnegative.

**Lemma 1.3 (Signs and discriminant).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.centered_data`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.centered_data` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For each centered input, the sextic envelope gives A=-u>=0, B=u^2+5w>=0, and Z=-Cp>=0. Thus a=24AA'/35, b=2BB'/105, and c=4ZZ'/7 are nonnegative. The sextic discriminant bound supplies the remaining cubic hypothesis. Each sign follows from the input envelope independently of the discriminant.

**Theorem 1.4 (Six real factors).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.centered_real_rooted`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.centered_real_rooted` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Substituting X^2 into the cubic factorization gives (X^2-x)(X^2-y)(X^2-z). Taking the real square roots gives sqrt(x),-sqrt(x),sqrt(y),-sqrt(y),sqrt(z),-sqrt(z), indexed by Fin(6). Coincident values and zero values retain their multiplicities.

**Lemma 1.5 (Translation invariance).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.symmetrize_translation`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.symmetrize_translation` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every real h, Sym(p(X+h))=Sym(p). Writing p=X^6+aX^5+uX^4+vX^3+wX^2+tX+s gives the three even coefficients 2u-5a^2/6, 2w-av+2u^2/5, and 2s-at/3+2uw/15-v^2/20. Substitution of the translated coefficients leaves all three unchanged.

**Theorem 1.6 (Arbitrary monic sextics).**

Lean statement: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.real_rooted`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.real_rooted` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Translation by -a/6 removes the coefficient of X^5 and translates every real input root by a/6. Apply the centered result to both translated inputs. Their symmetrizations are unchanged, so their commutator equals the original commutator. The conclusion holds for all pairs of monic real-rooted sextics, including repeated roots and zero roots.

## References

- Truth anchor: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.centered_data`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.centered_expansion`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.centered_real_rooted`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.cubic_nonnegative_factorization`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.real_rooted`
- Truth anchor: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.symmetrize_translation`
- Dependency: [D5/S3/Zeros/CoefficientBounds/SexticDiscriminant](../CoefficientBounds/SexticDiscriminant.md)
- Dependency: [D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour](FiniteFreeCommutatorDegreeFour.md)
