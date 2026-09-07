# A396093 Parity Period Ten

## Abstract

Formula (2) for OEIS A396093 determines an integer sequence whose parity has period ten.

**Definition 1.1 (Factored numerator of formula (2)).**

$$N: \mathbb{Q}[[x]], (N = x \cdot (1 - x)^{2} \cdot (1 - 3 \cdot x + x^{2})^{2}).$$

*Formalization.* `D5/S3/Factorization/RationalCompositionParityPeriodTen.N` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

N is formula (2)'s literal factored numerator in Q[[x]]. Directed edge: N -> generating_function_identity.

**Definition 1.2 (Squared denominator of formula (2)).**

$$D: \mathbb{Q}[[x]], (D = (1 - 7 \cdot x + 13 \cdot x^{2} - 7 \cdot x^{3} + x^{4})^{2}).$$

*Formalization.* `D5/S3/Factorization/RationalCompositionParityPeriodTen.D` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

D is formula (2)'s literal squared quartic denominator in Q[[x]]. Directed edge: D -> generating_function_identity.

**Theorem 1.3 (Denominator expansion).**

$$D = 1 - 14 \cdot x + 75 \cdot x^{2} - 196 \cdot x^{3} + 269 \cdot x^{4} - 196 \cdot x^{5} + 75 \cdot x^{6} - 14 \cdot x^{7} + x^{8}$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.denominator_expansion` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Polynomial normalization gives the nine denominator coefficients used by the coefficient kernel. Directed edge: denominator_expansion -> generating_function_identity.

**Theorem 1.4 (Numerator expansion).**

$$N = x - 8 \cdot x^{2} + 24 \cdot x^{3} - 34 \cdot x^{4} + 24 \cdot x^{5} - 8 \cdot x^{6} + x^{7}$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.numerator_expansion` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Polynomial normalization gives the eight initial numerator coefficients. Directed edge: numerator_expansion -> generating_function_identity.

**Definition 1.5 (The recurrence-defined integer sequence).**

$$a: \mathbb{N} \to \mathbb{Z}, (a\left(0\right) = 0 \land \left(a\left(1\right) = 1 \land \left(a\left(2\right) = 6 \land \left(a\left(3\right) = 33 \land \left(a\left(4\right) = 174 \land \left(a\left(5\right) = 892 \land \left(a\left(6\right) = 4480 \land \left(a\left(7\right) = 22149 \land \left(\forall n \in \mathbb{N},\; a\left(n + 8\right) = 14 \cdot a\left(n + 7\right) - 75 \cdot a\left(n + 6\right) + 196 \cdot a\left(n + 5\right) - 269 \cdot a\left(n + 4\right) + 196 \cdot a\left(n + 3\right) - 75 \cdot a\left(n + 2\right) + 14 \cdot a\left(n + 1\right) - a\left(n\right)\right)\right)\right)\right)\right)\right)\right)\right)).$$

*Formalization.* `D5/S3/Factorization/RationalCompositionParityPeriodTen.a` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The sequence a is defined by the order-eight recurrence with its eight initial values; it is not stipulated by parity or by a finite table.

**Theorem 1.6 (Homogeneous coefficient equations).**

$$\forall n \in \mathbb{N},\; a\left(n + 8\right) - 14 \cdot a\left(n + 7\right) + 75 \cdot a\left(n + 6\right) - 196 \cdot a\left(n + 5\right) + 269 \cdot a\left(n + 4\right) - 196 \cdot a\left(n + 3\right) + 75 \cdot a\left(n + 2\right) - 14 \cdot a\left(n + 1\right) + a\left(n\right) = 0$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.rational_tail_equation` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

These are the coefficient equations above degree seven. Directed edge: rational_tail_equation -> generating_function_identity.

**Theorem 1.7 (Inhomogeneous coefficient equations).**

$$a\left(0\right) = 0 \land \left(a\left(1\right) - 14 \cdot a\left(0\right) = 1 \land \left(a\left(2\right) - 14 \cdot a\left(1\right) + 75 \cdot a\left(0\right) = -8 \land \left(a\left(3\right) - 14 \cdot a\left(2\right) + 75 \cdot a\left(1\right) - 196 \cdot a\left(0\right) = 24 \land \left(a\left(4\right) - 14 \cdot a\left(3\right) + 75 \cdot a\left(2\right) - 196 \cdot a\left(1\right) + 269 \cdot a\left(0\right) = -34 \land \left(a\left(5\right) - 14 \cdot a\left(4\right) + 75 \cdot a\left(3\right) - 196 \cdot a\left(2\right) + 269 \cdot a\left(1\right) - 196 \cdot a\left(0\right) = 24 \land \left(a\left(6\right) - 14 \cdot a\left(5\right) + 75 \cdot a\left(4\right) - 196 \cdot a\left(3\right) + 269 \cdot a\left(2\right) - 196 \cdot a\left(1\right) + 75 \cdot a\left(0\right) = -8 \land a\left(7\right) - 14 \cdot a\left(6\right) + 75 \cdot a\left(5\right) - 196 \cdot a\left(4\right) + 269 \cdot a\left(3\right) - 196 \cdot a\left(2\right) + 75 \cdot a\left(1\right) - 14 \cdot a\left(0\right) = 1\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.initial_coefficient_equations` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The eight clauses are the coefficients in degrees zero through seven. Directed edge: initial_coefficient_equations -> generating_function_identity.

**Theorem 1.8 (Generating-function product identity).**

$$mk\left((n \mapsto cast\left(a\left(n\right), \mathbb{Q}\right))\right) \cdot (1 - 7 \cdot x + 13 \cdot x^{2} - 7 \cdot x^{3} + x^{4})^{2} = x \cdot (1 - x)^{2} \cdot (1 - 3 \cdot x + x^{2})^{2}$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.generating_function_identity` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Coefficient extensionality combines the initial and tail equations with the literal numerator and denominator expansions. Directed edge: generating_function_identity -> coefficients_unique.

**Theorem 1.9 (Generating function in division form).**

$$mk\left((n \mapsto cast\left(a\left(n\right), \mathbb{Q}\right))\right) = x \cdot (1 - x)^{2} \cdot (1 - 3 \cdot x + x^{2})^{2} \cdot ((1 - 7 \cdot x + 13 \cdot x^{2} - 7 \cdot x^{3} + x^{4})^{2})^{-1}$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.generating_function` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The denominator has constant coefficient one, so its power-series inverse turns the product identity into formula (2). Directed edge: generating_function -> generating_function_identity.

**Theorem 1.10 (Formula (2) uniquely determines its integer coefficients).**

$$\forall b \in \mathbb{N} \to \mathbb{Z},\; (mk\left((n \mapsto cast\left(b\left(n\right), \mathbb{Q}\right))\right) \cdot (1 - 7 \cdot x + 13 \cdot x^{2} - 7 \cdot x^{3} + x^{4})^{2} = x \cdot (1 - x)^{2} \cdot (1 - 3 \cdot x + x^{2})^{2}) \Rightarrow \left(\forall n \in \mathbb{N},\; b\left(n\right) = a\left(n\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.coefficients_unique` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Taking every coefficient of b(x)D(x)=N(x) yields the same triangular initial equations and order-eight recurrence as a. Strong induction therefore gives b(n)=a(n) for all n. Directed edge: coefficients_unique -> odd_iff_mod_ten_of_generating_function.

**Theorem 1.11 (Characteristic-two recurrence).**

$$\forall n \in \mathbb{N},\; cast\left(a\left(n + 8\right), ZMod\left(2\right)\right) = cast\left(a\left(n\right), ZMod\left(2\right)\right) + cast\left(a\left(n + 2\right), ZMod\left(2\right)\right) + cast\left(a\left(n + 4\right), ZMod\left(2\right)\right) + cast\left(a\left(n + 6\right), ZMod\left(2\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.reduced_recurrence` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Reduction modulo two removes the even coefficients. Directed edge: reduced_recurrence -> parity_period_ten.

**Theorem 1.12 (Period ten modulo two).**

$$\forall n \in \mathbb{N},\; cast\left(a\left(n + 10\right), ZMod\left(2\right)\right) = cast\left(a\left(n\right), ZMod\left(2\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.parity_period_ten` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Two shifted reduced recurrences cancel in characteristic two. Directed edge: parity_period_ten -> odd_iff_mod_ten.

**Theorem 1.13 (Odd values exactly in four residue classes).**

$$\forall n \in \mathbb{N},\; Odd\left(a\left(n\right)\right) \Leftrightarrow n \bmod 10 \in \left\{1, 3, 7, 9\right\}$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.odd_iff_mod_ten` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every n, a(n) is odd exactly in residues 1, 3, 7, and 9 modulo ten. Directed edges: even_at_even_index -> odd_iff_mod_ten and even_at_odd_index_iff -> odd_iff_mod_ten.

**Theorem 1.14 (Parity for the formula (2) coefficient sequence).**

$$\forall b \in \mathbb{N} \to \mathbb{Z},\; (mk\left((n \mapsto cast\left(b\left(n\right), \mathbb{Q}\right))\right) \cdot (1 - 7 \cdot x + 13 \cdot x^{2} - 7 \cdot x^{3} + x^{4})^{2} = x \cdot (1 - x)^{2} \cdot (1 - 3 \cdot x + x^{2})^{2}) \Rightarrow \left(\forall n \in \mathbb{N},\; Odd\left(b\left(n\right)\right) \Leftrightarrow n \bmod 10 \in \left\{1, 3, 7, 9\right\}\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.odd_iff_mod_ten_of_generating_function` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is the coverage anchor for the OEIS-defined object: normalization by coefficients_unique transfers the period-ten theorem to every integer coefficient sequence satisfying formula (2). Directed edge: odd_iff_mod_ten_of_generating_function -> odd_iff_mod_ten.

**Theorem 1.15 (Even values at positive even indices).**

$$\forall n \in \mathbb{N},\; 1 \le n \Rightarrow Even\left(a\left(2 \cdot n\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_even_index` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is the first OEIS conjecture for a. Directed edge: even_at_even_index -> odd_iff_mod_ten.

**Theorem 1.16 (Even values at odd indices).**

$$\forall n \in \mathbb{N},\; 1 \le n \Rightarrow \left(Even\left(a\left(2 \cdot n - 1\right)\right) \Leftrightarrow \left(\exists k \in \mathbb{N},\; 1 \le k \land n = 5 \cdot k - 2\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_odd_index_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is the second OEIS conjecture for a; natural subtraction is truncated at zero. Directed edge: even_at_odd_index_iff -> odd_iff_mod_ten.

**Theorem 1.17 (First conjecture for formula (2) coefficients).**

$$\forall b \in \mathbb{N} \to \mathbb{Z},\; (mk\left((n \mapsto cast\left(b\left(n\right), \mathbb{Q}\right))\right) \cdot (1 - 7 \cdot x + 13 \cdot x^{2} - 7 \cdot x^{3} + x^{4})^{2} = x \cdot (1 - x)^{2} \cdot (1 - 3 \cdot x + x^{2})^{2}) \Rightarrow \left(\forall n \in \mathbb{N},\; 1 \le n \Rightarrow Even\left(b\left(2 \cdot n\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_even_index_of_generating_function` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The first conjecture holds for every integer sequence satisfying formula (2). Directed edge: even_at_even_index_of_generating_function -> odd_iff_mod_ten_of_generating_function.

**Theorem 1.18 (Second conjecture for formula (2) coefficients).**

$$\forall b \in \mathbb{N} \to \mathbb{Z},\; (mk\left((n \mapsto cast\left(b\left(n\right), \mathbb{Q}\right))\right) \cdot (1 - 7 \cdot x + 13 \cdot x^{2} - 7 \cdot x^{3} + x^{4})^{2} = x \cdot (1 - x)^{2} \cdot (1 - 3 \cdot x + x^{2})^{2}) \Rightarrow \left(\forall n \in \mathbb{N},\; 1 \le n \Rightarrow \left(Even\left(b\left(2 \cdot n - 1\right)\right) \Leftrightarrow \left(\exists k \in \mathbb{N},\; 1 \le k \land n = 5 \cdot k - 2\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_odd_index_iff_of_generating_function` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The second conjecture holds for every integer sequence satisfying formula (2). Directed edge: even_at_odd_index_iff_of_generating_function -> odd_iff_mod_ten_of_generating_function.

**Definition 1.19 (Basic rational-function map).**

$$\forall y \in \mathbb{Q}(x),\; Bf\left(y\right) = \frac{y}{(1 - y)^{2}}$$

*Formalization.* `D5/S3/Factorization/RationalCompositionParityPeriodTen.Bf` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

OEIS A396093 states B(x)=x/(1-x)^2. Here Bf is that total field operation on Q(x). Directed edge: Bf -> triple_B_eq_formula_two.

**Theorem 1.20 (Formula (2) is the third iterate of B).**

$$Bf\left(Bf\left(Bf\left(x\right)\right)\right) = \frac{x \cdot (1 - x)^{2} \cdot (1 - 3 \cdot x + x^{2})^{2}}{(1 - 7 \cdot x + 13 \cdot x^{2} - 7 \cdot x^{3} + x^{4})^{2}}$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/RationalCompositionParityPeriodTen.triple_B_eq_formula_two` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This unconditional identity is in the field Q(x), so no pointwise non-pole hypotheses occur. The denominator polynomials are nonzero because each has constant coefficient one. OEIS A396093 is thereby transcribed as A(x)=B(B(B(x))).

The sequence a is defined by the order-eight recurrence with its eight initial values; Theorem generating_function identifies it with the coefficient sequence of formula (2), Theorem coefficients_unique shows formula (2) determines it, and Theorem triple_B_eq_formula_two identifies formula (2) with B(B(B(x))) in Q(x). The three together tie a to the OEIS definition.

## References

- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.Bf`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.D`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.N`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.a`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.coefficients_unique`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.denominator_expansion`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_even_index`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_even_index_of_generating_function`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_odd_index_iff`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.even_at_odd_index_iff_of_generating_function`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.generating_function`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.generating_function_identity`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.initial_coefficient_equations`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.numerator_expansion`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.odd_iff_mod_ten`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.odd_iff_mod_ten_of_generating_function`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.parity_period_ten`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.rational_tail_equation`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.reduced_recurrence`
- Truth anchor: `D5/S3/Factorization/RationalCompositionParityPeriodTen.triple_B_eq_formula_two`
