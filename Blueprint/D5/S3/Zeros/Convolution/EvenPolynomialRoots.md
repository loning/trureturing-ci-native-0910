# Roots Under Expansion by Two

## Abstract

Expansion by two connects real splitting with nonnegative real roots.

Mathlib's expand with parameter two is substitution of X^2. These two root-geometry implications are used by the conditional arbitrary-degree rectangular convolution theorem. They include repeated and zero roots.

**Theorem 1.1 (From Nonnegative Roots to Real Splitting).**

Lean statement: `D5/S3/Zeros/Convolution/EvenPolynomialRoots.splits_expand_two`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/EvenPolynomialRoots.splits_expand_two` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For a real polynomial p that splits over the reals, if every real root of p is nonnegative, then p(X^2) splits over the reals. Each factor X^2-a is split using the real square root of a. The zero polynomial is handled separately; monicity and a degree bound are not required.

**Theorem 1.2 (Descent to Nonnegative Real Roots).**

Lean statement: `D5/S3/Zeros/Convolution/EvenPolynomialRoots.nonnegative_roots_of_splits_expand_two`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Convolution/EvenPolynomialRoots.nonnegative_roots_of_splits_expand_two` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For a nonzero real polynomial p, real splitting of p(X^2) implies both real splitting of p and nonnegativity of every real root of p. A complex root of p is lifted to a complex square root. Splitting of p(X^2) forces that lift to be real, so the original root is a real square. The nonzero hypothesis excludes the zero polynomial.

## References

- Truth anchor: `D5/S3/Zeros/Convolution/EvenPolynomialRoots.nonnegative_roots_of_splits_expand_two`
- Truth anchor: `D5/S3/Zeros/Convolution/EvenPolynomialRoots.splits_expand_two`
