# A Deeply Composite Number Outside B-Infinity

## Abstract

The deeply composite number 25200 is never a strict prime-exponent-score record.

The OEIS A385722 attachment asks whether all deeply composite numbers from A095848 occur in B-infinity, the union of the strict record sequences from A384669 over real parameters strictly between zero and one. A384669 states the score on positive integer factorizations and its strict record sequences; A095848 states the extended-divisor-list order; A385722 states the union over 0 < x < 1 and the all-or-infinitely-many question. The Lean declarations quantify n and m over all naturals with explicit positivity guards and x over all reals. DivPlusPrecedes and DC are the repository's least-differing-divisor encoding of the A095848 order, and the 25200 certificates and counterexample are proved in the repository.

**Definition 1.1 (Prime-exponent score).**

$$\forall n \in \mathbb{N}, \forall x \in \mathbb{R}, \operatorname{fx}\left(n, x\right) = \sum_{p \in \operatorname{primeFactors}\left(n\right)} (\operatorname{toReal}\left(\operatorname{factorization}\left(n, p\right)\right))^{x}$$

*Formalization.* `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.fx` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A384669 states f_x(k) for a positive integer factorization k as the sum of the x-th powers of its exponents. The repository extends the formula to every natural n and real x using Nat.primeFactors and coerces each natural factorization value to the reals via the displayed toReal operation.

**Definition 1.2 (First differing divisor order).**

$$\forall n, m \in \mathbb{N}, \operatorname{DivPlusPrecedes}\left(n, m\right) \iff \exists d \in \mathbb{N}, (1 \leq d \land d \mid n \land \neg (d \mid m) \land \forall e \in \mathbb{N}, 1 \leq e \Rightarrow e < d \Rightarrow (e \mid n \iff e \mid m))$$

*Formalization.* `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.DivPlusPrecedes` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A095848 states its order through the infinite extended divisor lists Div+(n). DivPlusPrecedes is the repository encoding: for natural n and m, a positive d divides n but not m while the divisibility predicates agree at every positive natural e below d, so the first difference favors n.

**Definition 1.3 (Deeply composite record predicate).**

$$\forall n \in \mathbb{N}, \operatorname{DC}\left(n\right) \iff (1 \leq n \land (\forall m \in \mathbb{N}, 1 \leq m \Rightarrow m < n \Rightarrow \operatorname{DivPlusPrecedes}\left(n, m\right)))$$

*Formalization.* `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.DC` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A095848 gives the deeply composite sequence through successive records of its extended divisor-list order. The repository predicate DC(n) quantifies over all natural m with 1 <= m < n and uses DivPlusPrecedes as the equivalent least-differing-divisor record formulation required by the source atom.

**Definition 1.4 (Strict score record).**

$$\forall x \in \mathbb{R}, \forall n \in \mathbb{N}, \operatorname{StrictRecord}\left(x, n\right) \iff (\forall m \in \mathbb{N}, m < n \Rightarrow 1 \leq m \Rightarrow \operatorname{fx}\left(m, x\right) < \operatorname{fx}\left(n, x\right))$$

*Formalization.* `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.StrictRecord` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A384669 defines A_x by strict score records among positive integers. The repository predicate quantifies x over all reals and m over all naturals, with the explicit guards m < n and 1 <= m, and preserves the strict inequality fx(m,x) < fx(n,x).

**Definition 1.5 (The union B-infinity).**

$$Binfty = \{n \in \mathbb{N} \mid \exists x \in \mathbb{R}, (0 < x \land x < 1 \land \operatorname{StrictRecord}\left(x, n\right))\}$$

*Formalization.* `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.Binfty` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A385722 defines B-infinity as the union of the A_x values for 0 < x < 1 and asks whether infinitely many, or all, A095848 terms occur. The repository set uses an existential real x in that open interval together with the strict record predicate; A385722 notes the equivalent rational-parameter form by continuity.

**Theorem 1.6 (Normalized score of 25200).**

$$\forall x \in \mathbb{R}, \operatorname{fx}\left(25200, x\right) = 2^{(2 \cdot x)} + 2 \cdot 2^{x} + 1$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.fx_25200` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The repository normalizes the score from the certified factorization 25200 = 2^4*3^2*5^2*7.

**Theorem 1.7 (Normalized score of 18480).**

$$\forall x \in \mathbb{R}, \operatorname{fx}\left(18480, x\right) = 2^{(2 \cdot x)} + 4$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.fx_18480` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The repository normalizes the first competitor's score from the certified factorization 18480 = 2^4*3*5*7*11.

**Theorem 1.8 (Normalized score of 20160).**

$$\forall x \in \mathbb{R}, \operatorname{fx}\left(20160, x\right) = 2^{x} \cdot 3^{x} + 2^{x} + 2$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.fx_20160` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The repository normalizes the second competitor's score from the certified factorization 20160 = 2^6*3^2*5*7.

**Theorem 1.9 (Literal factorizations used by the certificate).**

$$(25200 = 2^{4} \cdot 3^{2} \cdot 5^{2} \cdot 7) \land \left((18480 = 2^{4} \cdot 3 \cdot 5 \cdot 7 \cdot 11) \land (20160 = 2^{6} \cdot 3^{2} \cdot 5 \cdot 7)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.literal_factorizations` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The repository verifies all three literal prime factorizations used to evaluate the scores and construct the finite deeply-composite certificate.

**Theorem 1.10 (Positive score-gap identity).**

$$\forall t, z \in \mathbb{R}, (z = t - \frac{3}{2}) \Rightarrow (32 \cdot (t^{5} - (t^{2} + t - 1)^{2}) = 32 \cdot z^{5} + 208 \cdot z^{4} + 464 \cdot z^{3} + 392 \cdot z^{2} + 106 \cdot z + 1)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.score_gap_identity` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

After substituting z = t - 3/2, the repository proves this polynomial identity by ring normalization; nonnegativity of its right side supplies the strict gap used above the threshold.

**Theorem 1.11 (25200 is deeply composite).**

$$\operatorname{DC}\left(25200\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.dc_25200` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The finite certificate first treats a challenger divisible by 2520 as 2520*j for 1 <= j <= 9; the first difference is 16 for odd j and 25 for even j. Otherwise the first missing divisor among 2 through 10 favors 25200. This proves the universal record condition.

**Theorem 1.12 (Two smaller competitors dominate every parameter).**

$$\forall x \in \mathbb{R}, \operatorname{fx}\left(25200, x\right) \leq \operatorname{max}\left(\operatorname{fx}\left(18480, x\right), \operatorname{fx}\left(20160, x\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.score_25200_le_competitors` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every real x, the score of 25200 is bounded by the larger score of 18480 and 20160. With t=2^x and u=3^x, the three scores normalize to t^2+2t+1, t^2+4, and tu+t+2. The first competitor handles t <= 3/2; above that threshold, monotonicity of real powers and the positive polynomial identity in z=t-3/2 make the second competitor win.

**Theorem 1.13 (25200 is never a strict score record).**

$$\forall x \in \mathbb{R}, \neg (\operatorname{StrictRecord}\left(x, 25200\right))$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.not_strictRecord_25200` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Both competitors are positive naturals smaller than 25200. If 25200 were a strict record, both scores would be strictly below its score, contradicting score_25200_le_competitors. Dependency direction: not_strictRecord_25200 -> score_25200_le_competitors.

**Theorem 1.14 (The complete 25200 counterexample).**

$$\operatorname{DC}\left(25200\right) \land (\forall x \in \mathbb{R}, \neg (\operatorname{StrictRecord}\left(x, 25200\right)))$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.deeply_composite_25200_not_in_Binfty` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The whole candidate theorem combines the certified deeply-composite fact with exclusion from strict records for every real parameter. Dependency directions: deeply_composite_25200_not_in_Binfty -> dc_25200 and deeply_composite_25200_not_in_Binfty -> not_strictRecord_25200.

**Theorem 1.15 (25200 is outside B-infinity).**

$$\neg (25200 \in Binfty)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.not_mem_Binfty_25200` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Unfolding membership in Binfty would supply a real parameter and a strict record witness, which not_strictRecord_25200 excludes. Dependency direction: not_mem_Binfty_25200 -> not_strictRecord_25200. This answers the all-deeply-composite branch negatively; the infinitely-many branch is not asserted or resolved here.

## References

- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.Binfty`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.DC`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.DivPlusPrecedes`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.StrictRecord`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.dc_25200`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.deeply_composite_25200_not_in_Binfty`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.fx`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.fx_18480`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.fx_20160`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.fx_25200`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.literal_factorizations`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.not_mem_Binfty_25200`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.not_strictRecord_25200`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.score_25200_le_competitors`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.score_gap_identity`
