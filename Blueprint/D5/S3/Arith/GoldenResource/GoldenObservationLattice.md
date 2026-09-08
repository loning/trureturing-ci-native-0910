# The Lattice Boundary of Golden Observation

## Abstract

Golden observation preserves the gcd and lcm lattice operations, but it preserves neither multiplication nor associativity of observed products on its fixed points.

**Theorem 1.1 (Observation preserves greatest common divisors).**

$$\forall m \in \mathbb{N}_{>0}, n \in \mathbb{N}_{>0},\; G\left(gcd\left(m, n\right)\right) = gcd\left(G\left(m\right), G\left(n\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_gcd` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

At every prime, the exponent of a greatest common divisor is the minimum of the two input exponents. The exponent-layering map is monotone, so it commutes with this minimum. Reassembling the prime exponents gives the stated identity.

**Theorem 1.2 (Observation preserves least common multiples).**

$$\forall m \in \mathbb{N}_{>0}, n \in \mathbb{N}_{>0},\; G\left(lcm\left(m, n\right)\right) = lcm\left(G\left(m\right), G\left(n\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_lcm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

At every prime, the exponent of a least common multiple is the maximum of the two input exponents. Monotonicity of exponent layering makes it commute with this maximum, and prime factorization then gives the identity.

**Definition 1.3 (The false multiplicative-or-associative alternative).**

$$(\forall m \in \mathbb{N}_{>0}, n \in \mathbb{N}_{>0},\; G\left(m \cdot n\right) = G\left(m\right) \cdot G\left(n\right)) \lor (G\left(G\left(2 \cdot 2\right) \cdot 4\right) = G\left(2 \cdot G\left(2 \cdot 4\right)\right))$$

*Formalization.* `D5/S3/Arith/GoldenResource/GoldenObservationLattice.goldenObservationMultiplicativeOrAssociativeAtWitness` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This proposition is the disjunction of global multiplicativity and equality of the two products obtained by associating the fixed-point inputs 2, 2, and 4 in opposite ways.

**Theorem 1.4 (Observation is not multiplicative).**

$$\neg (\forall m \in \mathbb{N}_{>0}, n \in \mathbb{N}_{>0},\; G\left(m \cdot n\right) = G\left(m\right) \cdot G\left(n\right))$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_not_multiplicative` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The values G(2)=2, G(4)=4, and G(8)=4 give a direct counterexample: G(2 times 4) is 4, whereas G(2) times G(4) is 8.

**Theorem 1.5 (Observed multiplication is not associative on fixed points).**

$$Golden\left(2\right) \land \left(Golden\left(4\right) \land \left(Golden\left(16\right) \land \left(G\left(G\left(2 \cdot 2\right) \cdot 4\right) = 16 \land \left(G\left(2 \cdot G\left(2 \cdot 4\right)\right) = 4 \land G\left(G\left(2 \cdot 2\right) \cdot 4\right) \ne G\left(2 \cdot G\left(2 \cdot 4\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_product_not_associative_on_fixed_points` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The positive integers 2, 4, and 16 are fixed by golden observation. For the product x star y = G(x times y), the left-associated value at 2, 2, and 4 is G(16)=16, while the right-associated value is G(8)=4. The two values are unequal.

**Theorem 1.6 (The full multiplicative boundary at the fixed-point witness).**

$$\left(\neg (\forall m \in \mathbb{N}_{>0}, n \in \mathbb{N}_{>0},\; G\left(m \cdot n\right) = G\left(m\right) \cdot G\left(n\right))\right) \land \left(Golden\left(2\right) \land \left(Golden\left(4\right) \land \left(Golden\left(16\right) \land \left(G\left(G\left(2 \cdot 2\right) \cdot 4\right) = 16 \land \left(G\left(2 \cdot G\left(2 \cdot 4\right)\right) = 4 \land G\left(G\left(2 \cdot 2\right) \cdot 4\right) \ne G\left(2 \cdot G\left(2 \cdot 4\right)\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_not_multiplicative_and_not_associative_on_fixed_points` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Golden observation is not multiplicative. The golden integers 2, 4, and 16 simultaneously give the explicit failure of associativity for x star y = G(x times y): the left-associated value is 16, the right-associated value is 4, and they are unequal.

**Theorem 1.7 (The observed product is not associative on golden integers).**

$$\neg (\forall x \in \{g: \mathbb{N}_{>0} \mid Golden\left(g\right)\}, y \in \{g: \mathbb{N}_{>0} \mid Golden\left(g\right)\}, z \in \{g: \mathbb{N}_{>0} \mid Golden\left(g\right)\},\; G\left(G\left(x \cdot y\right) \cdot z\right) = G\left(x \cdot G\left(y \cdot z\right)\right))$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_product_not_associative_on_golden_subtype` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The operation x star y = G(x times y) is closed on golden integers because every observed value is golden. On this subtype, the triple 2, 2, and 4 violates associativity, so this operation cannot be the multiplication of a monoid.

**Theorem 1.8 (Observation equivalence is not compatible with multiplication).**

$$G\left(4\right) = G\left(8\right) \land G\left(2 \cdot 4\right) \ne G\left(2 \cdot 8\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_equivalence_not_compatible_with_multiplication` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Define two positive integers to be equivalent when their golden observations agree. Although 4 and 8 are equivalent, multiplying both by 2 separates them: the resulting observations are 4 and 16. Thus the equivalence preserved by gcd and lcm is not a multiplication congruence.

**Theorem 1.9 (The multiplicative extension is refuted).**

$$\neg ((\forall m \in \mathbb{N}_{>0}, n \in \mathbb{N}_{>0},\; G\left(m \cdot n\right) = G\left(m\right) \cdot G\left(n\right)) \lor (G\left(G\left(2 \cdot 2\right) \cdot 4\right) = G\left(2 \cdot G\left(2 \cdot 4\right)\right)))$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_lattice_boundary_refutation` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Neither alternative in the displayed disjunction holds: the first is contradicted by 2 and 4, and the second by the two unequal associations of 2, 2, and 4.

## References

- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_equivalence_not_compatible_with_multiplication`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_gcd`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_lattice_boundary_refutation`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_lcm`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_not_multiplicative`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_not_multiplicative_and_not_associative_on_fixed_points`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_product_not_associative_on_fixed_points`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_product_not_associative_on_golden_subtype`
- Truth anchor: `D5/S3/Arith/GoldenResource/GoldenObservationLattice.goldenObservationMultiplicativeOrAssociativeAtWitness`
- Dependency: [D5/S3/Arith/GoldenResource/GoldenDivisorLanguage](GoldenDivisorLanguage.md)
- Dependency: [D5/S3/Arith/GoldenResource/GoldenFixedPoint](GoldenFixedPoint.md)
