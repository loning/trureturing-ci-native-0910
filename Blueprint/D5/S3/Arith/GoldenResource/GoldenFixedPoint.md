# Golden Fixed Points

## Abstract

Golden integers are the fixed points of integer observation, and the observation of an integer is its greatest golden divisor.

Write F_L for the Fibonacci number of index L, b for the layering map on exponents, a_p(n) for the exponent of the prime p in n, and G(n) for the observation of a positive integer n, whose exponent at each prime p is b(a_p(n)). A positive integer g is called golden when every exponent a_p(g) is one less than a Fibonacci number of index at least two.

**Theorem 1.1 (Fixed exponents are Fibonacci endpoints).**

$$\forall a \in \mathbb{N},\; b\left(a\right) = a \Leftrightarrow \left(\exists L \in \mathbb{N},\; 2 \le L \land a + 1 = F_L\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenFixedPoint.b_fixed_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The layering map sends a to the largest Fibonacci number not exceeding a plus one, minus one. It therefore fixes a exactly when a plus one is itself a Fibonacci number, and the index bound records that the smallest admissible window endpoint is one.

**Theorem 1.2 (Golden integers are the fixed points of observation).**

$$\forall g \in \mathbb{N}_{>0},\; Golden\left(g\right) \Leftrightarrow G\left(g\right) = g$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenFixedPoint.isGolden_iff_Gobs_fixed` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Two positive integers agree exactly when their prime exponents agree. The exponent of the observation at p is the layering of the exponent at p, so the observation fixes g exactly when the layering fixes every exponent, which is the golden condition.

**Theorem 1.3 (Every observation is golden).**

$$\forall n \in \mathbb{N}_{>0},\; Golden\left(G\left(n\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenFixedPoint.Gobs_isGolden` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Observation is idempotent, so its value is a fixed point and hence golden.

**Theorem 1.4 (Observation preserves divisibility).**

$$\forall n \in \mathbb{N}_{>0}, m \in \mathbb{N}_{>0},\; n \mid m \Rightarrow G\left(n\right) \mid G\left(m\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenFixedPoint.Gobs_dvd_of_dvd` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Divisibility of positive integers is the pointwise order on prime exponents, and the layering map is monotone, so the observed exponents stay in the same order.

**Theorem 1.5 (The observation is the greatest golden divisor).**

$$\forall n \in \mathbb{N}_{>0},\; G\left(n\right) \mid n \land \left(Golden\left(G\left(n\right)\right) \land \left(\forall g \in \mathbb{N}_{>0},\; \left(Golden\left(g\right) \land g \mid n\right) \Rightarrow g \mid G\left(n\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenFixedPoint.Gobs_greatest_golden_divisor` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The observation divides its argument and is golden. If a golden g divides n then observation of g divides observation of n, and observation fixes g, so g itself divides the observation of n. This identifies an exponentwise construction with an order-theoretic maximum in the divisibility order.

## References

- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenFixedPoint.Gobs_dvd_of_dvd`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenFixedPoint.Gobs_greatest_golden_divisor`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenFixedPoint.Gobs_isGolden`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenFixedPoint.b_fixed_iff`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenFixedPoint.isGolden_iff_Gobs_fixed`
- Dependency: [D5/S3/Arith/GoldenResource/GoldenDivisorLanguage](GoldenDivisorLanguage.md)
