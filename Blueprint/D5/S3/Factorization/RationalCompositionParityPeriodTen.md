# A396093 Parity Period Ten

## Abstract

A characteristic-two reduction of the rational recurrence for OEIS A396093 proves both published parity conjectures.

**Theorem 1.1 (Denominator expansion).**

$$\forall x \in \mathbb{Z},\; \left(1 - 7 \cdot x + 13 \cdot x^{2} - 7 \cdot x^{3} + x^{4}\right)^{2} = 1 - 14 \cdot x + 75 \cdot x^{2} - 196 \cdot x^{3} + 269 \cdot x^{4} - 196 \cdot x^{5} + 75 \cdot x^{6} - 14 \cdot x^{7} + x^{8}$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.denominator_expansion` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every integer x, direct polynomial normalization identifies the squared quartic denominator with all nine displayed coefficients.

**Theorem 1.2 (Numerator expansion).**

$$\forall x \in \mathbb{Z},\; x \cdot \left(1 - x\right)^{2} \cdot \left(1 - 3 \cdot x + x^{2}\right)^{2} = x - 8 \cdot x^{2} + 24 \cdot x^{3} - 34 \cdot x^{4} + 24 \cdot x^{5} - 8 \cdot x^{6} + x^{7}$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.numerator_expansion` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every integer x, direct polynomial normalization identifies the factored numerator with all eight displayed coefficients.

**Definition 1.3 (Linear recurrence specification).**

$$recurrence: LinearRecurrence\left(\mathbb{Z}\right), (order\left(recurrence\right) = 8 \land coeffs\left(recurrence\right) = (-1, 14, -75, 196, -269, 196, -75, 14)).$$

*Formalization.* `D5/S3/Factorization/RationalCompositionParityPeriodTen.recurrence` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The LinearRecurrence object has order eight and exactly the displayed inline recurrence coefficients.

**Definition 1.4 (The A396093 integer sequence).**

$$a: \mathbb{N} \to \mathbb{Z}, (a\left(0\right) = 0 \land \left(a\left(1\right) = 1 \land \left(a\left(2\right) = 6 \land \left(a\left(3\right) = 33 \land \left(a\left(4\right) = 174 \land \left(a\left(5\right) = 892 \land \left(a\left(6\right) = 4480 \land \left(a\left(7\right) = 22149 \land \left(\forall n \in \mathbb{N},\; a\left(n + 8\right) = 14 \cdot a\left(n + 7\right) - 75 \cdot a\left(n + 6\right) + 196 \cdot a\left(n + 5\right) - 269 \cdot a\left(n + 4\right) + 196 \cdot a\left(n + 3\right) - 75 \cdot a\left(n + 2\right) + 14 \cdot a\left(n + 1\right) - a\left(n\right)\right)\right)\right)\right)\right)\right)\right)\right)).$$

*Formalization.* `D5/S3/Factorization/RationalCompositionParityPeriodTen.a` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The sequence is defined directly by the eight displayed initial values and the displayed order-eight integer recurrence. This fixes every term, rather than defining parity directly or naming a finite value table.

**Theorem 1.5 (The sequence satisfies the denominator recurrence).**

$$IsSolution\left(recurrence, a\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.a_is_solution` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This exposes the LinearRecurrence solution property used to obtain the coefficient equations of the rational generating function.

**Theorem 1.6 (Homogeneous coefficient equations).**

$$\forall n \in \mathbb{N},\; a\left(n + 8\right) - 14 \cdot a\left(n + 7\right) + 75 \cdot a\left(n + 6\right) - 196 \cdot a\left(n + 5\right) + 269 \cdot a\left(n + 4\right) - 196 \cdot a\left(n + 3\right) + 75 \cdot a\left(n + 2\right) - 14 \cdot a\left(n + 1\right) + a\left(n\right) = 0$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.rational_tail_equation` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every natural n, this is the coefficient equation in degree n+8 for denominator times A equals numerator. The numerator has degree seven, so every such coefficient is zero.

**Theorem 1.7 (Inhomogeneous coefficient equations).**

$$a\left(0\right) = 0 \land \left(a\left(1\right) - 14 \cdot a\left(0\right) = 1 \land \left(a\left(2\right) - 14 \cdot a\left(1\right) + 75 \cdot a\left(0\right) = -8 \land \left(a\left(3\right) - 14 \cdot a\left(2\right) + 75 \cdot a\left(1\right) - 196 \cdot a\left(0\right) = 24 \land \left(a\left(4\right) - 14 \cdot a\left(3\right) + 75 \cdot a\left(2\right) - 196 \cdot a\left(1\right) + 269 \cdot a\left(0\right) = -34 \land \left(a\left(5\right) - 14 \cdot a\left(4\right) + 75 \cdot a\left(3\right) - 196 \cdot a\left(2\right) + 269 \cdot a\left(1\right) - 196 \cdot a\left(0\right) = 24 \land \left(a\left(6\right) - 14 \cdot a\left(5\right) + 75 \cdot a\left(4\right) - 196 \cdot a\left(3\right) + 269 \cdot a\left(2\right) - 196 \cdot a\left(1\right) + 75 \cdot a\left(0\right) = -8 \land a\left(7\right) - 14 \cdot a\left(6\right) + 75 \cdot a\left(5\right) - 196 \cdot a\left(4\right) + 269 \cdot a\left(3\right) - 196 \cdot a\left(2\right) + 75 \cdot a\left(1\right) - 14 \cdot a\left(0\right) = 1\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.initial_coefficient_equations` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

These eight clauses are the coefficients in degrees zero through seven of denominator times A equals numerator. Together with the tail equation they identify a coefficientwise with formula (2).

**Theorem 1.8 (Characteristic-two recurrence).**

$$\forall n \in \mathbb{N},\; cast\left(a\left(n + 8\right), ZMod\left(2\right)\right) = cast\left(a\left(n\right), ZMod\left(2\right)\right) + cast\left(a\left(n + 2\right), ZMod\left(2\right)\right) + cast\left(a\left(n + 4\right), ZMod\left(2\right)\right) + cast\left(a\left(n + 6\right), ZMod\left(2\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.reduced_recurrence` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Casting the integer recurrence into ZMod(2) removes the even coefficients and turns subtraction into addition. Four even-indexed lags remain.

**Theorem 1.9 (Period ten modulo two).**

$$\forall n \in \mathbb{N},\; cast\left(a\left(n + 10\right), ZMod\left(2\right)\right) = cast\left(a\left(n\right), ZMod\left(2\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.parity_period_ten` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The displayed universal equality is Function.Periodic for the cast sequence with period ten. Applying the reduced recurrence at n and n+2 makes the three repeated middle terms cancel in characteristic two.

**Theorem 1.10 (Odd values exactly in four residue classes).**

$$\forall n \in \mathbb{N},\; Odd\left(a\left(n\right)\right) \Leftrightarrow n \bmod 10 \in \left\{1, 3, 7, 9\right\}$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.odd_iff_mod_ten` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every natural n, a(n) is odd exactly when the natural-number remainder n mod 10 belongs to {1,3,7,9}. Period ten reduces the assertion to the first ten residues 0,1,0,1,0,0,0,1,0,1.

**Theorem 1.11 (Even values at positive even indices).**

$$\forall n \in \mathbb{N},\; 1 \le n \Rightarrow Even\left(a\left(2 \cdot n\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_even_index` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is the first OEIS A396093 conjecture verbatim in mathematical content: a(2*n) is even for every n at least one. It is a directed companion from this theorem to odd_iff_mod_ten.

**Theorem 1.12 (Even values at odd indices).**

$$\forall n \in \mathbb{N},\; 1 \le n \Rightarrow \left(Even\left(a\left(2 \cdot n - 1\right)\right) \Leftrightarrow \left(\exists k \in \mathbb{N},\; 1 \le k \land n = 5 \cdot k - 2\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_odd_index_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is the second OEIS A396093 conjecture verbatim in mathematical content. For n at least one, a(2*n-1) is even exactly when some natural k at least one satisfies n=5*k-2. Both subtractions are natural subtraction, truncated at zero. The theorem points to odd_iff_mod_ten.

**Definition 1.13 (Basic rational map).**

$$\forall x \in \mathbb{Q},\; B\left(x\right) = \frac{x}{\left(1 - x\right)^{2}}$$

*Formalization.* `D5/S3/Factorization/RationalCompositionParityPeriodTen.B` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This transcribes the OEIS definition B(x)=x/(1-x)^2 over the rational numbers. Rational division is total in Lean.

**Definition 1.14 (Rational generating-function formula).**

$$\forall x \in \mathbb{Q},\; rationalA\left(x\right) = \frac{x \cdot \left(1 - x\right)^{2} \cdot \left(1 - 3 \cdot x + x^{2}\right)^{2}}{\left(1 - 7 \cdot x + 13 \cdot x^{2} - 7 \cdot x^{3} + x^{4}\right)^{2}}$$

*Formalization.* `D5/S3/Factorization/RationalCompositionParityPeriodTen.rationalA` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This transcribes formula (2) of OEIS A396093 over the rational numbers. The coefficient equations above separately connect this expression to the integer sequence.

**Theorem 1.15 (Formula (2) equals the third iterate of B).**

$$\forall x \in \mathbb{Q},\; \left(1 - x \ne 0 \land 1 - 3 \cdot x + x^{2} \ne 0\right) \Rightarrow rationalA\left(x\right) = B\left(B\left(B\left(x\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.rationalA_eq_triple_B` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every rational x, under exactly the two displayed non-pole assumptions, formula (2) equals B(B(B(x))). The assumptions name the denominators introduced by the first and second compositions; no additional pole hypothesis is required.

## References

- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.B`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.a`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.a_is_solution`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.denominator_expansion`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_even_index`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_odd_index_iff`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.initial_coefficient_equations`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.numerator_expansion`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.odd_iff_mod_ten`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.parity_period_ten`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.rationalA`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.rationalA_eq_triple_B`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.rational_tail_equation`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.recurrence`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.reduced_recurrence`
