# Artin-Schreier Quadratic Root Uniqueness

## Abstract

An equal constant coefficient selects at most one root of an Artin-Schreier quadratic.

**Theorem 1.1 (Equal-constant roots coincide).**

$$\forall f, F, G: \operatorname{PowerSeries}\left(\operatorname{ZMod}\left(2\right)\right),\ \left(F^{2}+F=f \land G^{2}+G=f \land \operatorname{constantCoeff}\left(F\right)=\operatorname{constantCoeff}\left(G\right)\right) \Rightarrow F=G$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/ArtinSchreierQuadraticRootUniqueness.quadratic_root_unique` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Let D=F-G. Subtracting the two quadratic equations factors as D(F+G+1)=0. Equality of the constant coefficients makes D constant-free, so F+G+1 has constant coefficient one and is a unit. Cancelling that factor gives D=0 and hence F=G.

## References

- Truth anchor: `D5/S3/Arith/ArtinSchreierQuadraticRootUniqueness.quadratic_root_unique`
