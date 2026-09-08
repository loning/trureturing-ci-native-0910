# Septic Joint Upper Bound

## Abstract

Positive coefficient certificates establish the septic joint upper bound.

**Theorem 1.1 (Quadratic Coefficient).**

Lean statement: `D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperHigh.upper_coeff2_nonneg`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperHigh.upper_coeff2_nonneg` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

In twelve times the septic joint upper remainder, the coefficients of powers two through six of the first gap have positive expansions with 489, 329, 210, 117 and 60 monomials. Each coefficient is nonnegative for every nonnegative real five-tuple of the remaining gaps. The seven coefficient signs together yield the joint upper bound.

**Theorem 1.2 (Joint Upper Bound).**

Lean statement: `D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperHigh.gap_z_upper`

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperHigh.gap_z_upper` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For six nonnegative real gaps, 9Z(49A^2-5B)<=10AB^2. Twelve times the remainder is a degree-ten polynomial with 2829 positive-coefficient monomials and smallest coefficient 4842432840. As a polynomial in the first gap, its seven coefficients have respectively 937, 687, 489, 329, 210, 117 and 60 monomials. Their exact positive expansions are checked separately. A univariate identity combines these coefficients into the full remainder. Their nonnegativity proves the bound, including vanishing gaps.

## References

- Truth anchor: `D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperHigh.gap_z_upper`
- Truth anchor: `D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperHigh.upper_coeff2_nonneg`
- Dependency: [D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperLow](SepticEnvelopeUpperLow.md)
