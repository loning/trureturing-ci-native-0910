# A392096 Divisor-Pair Sigma Bounds

## Abstract

Hoft's consecutive divisor-pair condition forces a strict abundancy interval.

**Definition 1.1 (Consecutive gap-separated divisor pairs).**

$$\forall D \in \mathbb{N}, q \in \mathbb{N},\; DivisorPairs\left(D, q\right) = \{D_{pos}: 0 < D\;count: \mathbb{N}\;count_{ge_{two}}: 2 \le count\;lower: \mathbb{N} \to \mathbb{N}\;upper: \mathbb{N} \to \mathbb{N}\;lower_{zero}: lower\left(0\right) = 1\;upper_{last}: upper\left(count - 1\right) = q\;divisors_{eq}: divisors\left(q\right) = union\left(image\left(lower, range\left(count\right)\right), image\left(upper, range\left(count\right)\right)\right)\;within: \forall i \in \mathbb{N},\; (i < count) \Rightarrow ((lower\left(i\right) < upper\left(i\right)) \land (upper\left(i\right) < D \cdot lower\left(i\right)))\;gap_{succ}: \forall i \in \mathbb{N},\; (i + 1 < count) \Rightarrow (D \cdot upper\left(i\right) < lower\left(i + 1\right))\}$$

*Formalization.* `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.DivisorPairs` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For natural D and q, DivisorPairs is a structure with fields D_pos, count, count_ge_two, lower, upper, lower_zero, upper_last, divisors_eq, within, and gap_succ. The first three fields make D positive and provide at least two pairs. The next four give the two natural-valued enumerating maps, start lower at one, and end upper at q.

The divisors_eq field says that Nat.divisors(q) is exactly the union of the images of lower and upper over range(count). The within field says lower(i)<upper(i)<D*lower(i). The gap_succ field says D*upper(i)<lower(i+1) between successive pairs. The expression count-1 uses truncated natural subtraction.

This is the divisor characterization stated by the OEIS A392096 entry. The positivity field is automatic at the Member scale D=2^(m+1), but is explicit so the general structure records every order argument used below.

**Definition 1.2 (Membership in the divisor-form version of A392096).**

$$\forall n \in \mathbb{N},\; (Member\left(n\right)) \Leftrightarrow (\exists m \in \mathbb{N}, q \in \mathbb{N},\; (1 \le m) \land \left((Odd\left(q\right)) \land \left((n = 2^{m} \cdot q) \land (Nonempty\left(DivisorPairs\left(2^{m + 1}, q\right)\right))\right)\right))$$

*Formalization.* `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.Member` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A natural n is a Member exactly when natural m and q exist with m at least one, q odd, n=2^m*q, and nonempty divisor-pair data at D=2^(m+1). The conjunction is right-associated exactly as in the Lean definition.

OEIS A392096 attributes this divisor characterization to Hartmut F. W. Hoft. The entry asserts that it is equivalent to the symmetric-representation width pattern 1,2,1,0,...,0,1,2,1. This module formalizes only the displayed divisor predicate. The asserted equivalence is ASSUMED-UNVERIFIED and is not formalized here.

**Theorem 1.3 (Least-prime bound and square exclusion).**

$$\forall D \in \mathbb{N}, q \in \mathbb{N}, P \in DivisorPairs\left(D, q\right),\; (Odd\left(q\right)) \Rightarrow ((minFac\left(q\right) < D) \land (\neg minFac\left(q\right) \cdot minFac\left(q\right) \mid q))$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.divisor_pairs_minFac_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For odd q with DivisorPairs data at scale D, the least prime factor minFac(q) is strictly below D and its square does not divide q. The least prime occupies the first upper position, while its square would have to occur after it and would violate the next separation gap.

**Theorem 1.4 (Every divisor pair has least-prime ratio).**

$$\forall D \in \mathbb{N}, q \in \mathbb{N}, P \in DivisorPairs\left(D, q\right),\; (Odd\left(q\right)) \Rightarrow (\forall i \in \mathbb{N},\; (i < count\left(P\right)) \Rightarrow (upper\left(P, i\right) = minFac\left(q\right) \cdot lower\left(P, i\right)))$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.divisor_pairs_upper_pair_shape` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every index below count, the upper divisor is minFac(q) times the paired lower divisor. The proof uses divisor location, least-prime coprimality, and the separation gaps; it is a public prerequisite of the telescoping estimate and the final theorem.

**Theorem 1.5 (The divisor gaps telescope strictly).**

$$\forall D \in \mathbb{N}, q \in \mathbb{N}, P \in DivisorPairs\left(D, q\right),\; (Odd\left(q\right)) \Rightarrow (\left(D \cdot minFac\left(q\right) - 1\right) \cdot \sum_{i \in range\left(count\left(P\right)\right)} lower\left(P, i\right) < D \cdot minFac\left(q\right) \cdot lower\left(P, count\left(P\right) - 1\right))$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.divisor_pairs_gap_telescoping` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For odd q with DivisorPairs data, summing the successive gaps gives (D*minFac(q)-1)*S < D*minFac(q)*r, where S is the sum of the lower entries over range(count) and r is the last lower entry. This repository-derived estimate is used directly by the final upper sigma bound.

**Theorem 1.6 (Lower coefficient comparison).**

$$\forall D \in \mathbb{N}, p \in \mathbb{N},\; (p < D) \Rightarrow (D \cdot p \le \left(D - 1\right) \cdot \left(p + 1\right))$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.lower_coefficient_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For natural D and p with p<D, the product D*p is at most (D-1)*(p+1). This named coefficient estimate is a direct public prerequisite of the final strict lower sigma bound.

**Theorem 1.7 (Upper coefficient comparison).**

$$\forall D \in \mathbb{N}, p \in \mathbb{N},\; (4 \le D) \Rightarrow ((3 \le p) \Rightarrow (3 \cdot \left(D - 1\right) \cdot \left(p + 1\right) \le 4 \cdot \left(D \cdot p - 1\right)))$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.upper_coefficient_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For natural D and p with D at least four and p at least three, three times (D-1)*(p+1) is at most four times (D*p-1). This named coefficient estimate is a direct public prerequisite of the final strict upper sigma bound.

**Theorem 1.8 (Division-free natural sigma bounds).**

$$\forall n \in \mathbb{N},\; (Member\left(n\right)) \Rightarrow ((2 \cdot n < \left(\sigma_{1}\right)\left(n\right)) \land (3 \cdot \left(\sigma_{1}\right)\left(n\right) < 8 \cdot n))$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.a392096_sigma_bounds_nat` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every natural n satisfying Member, twice n is strictly below ArithmeticFunction.sigma(1,n), and three times that divisor sum is strictly below eight times n. This is the division-free natural-number companion to the source-form rational bound.

The proof lets p be minFac(q). Divisor location and the gap conditions force p<D, exclude p^2 dividing q, and identify every upper(i) as p*lower(i). Summing the successive gaps gives (D*p-1)*S<D*p*r, where S is the sum of all lower entries and r is the last one. This estimate and S>r yield the two strict bounds after sigma multiplicativity.

**Theorem 1.9 (Strict sigma bounds for every divisor-form member).**

$$\forall n \in \mathbb{N},\; (Member\left(n\right)) \Rightarrow ((2 \cdot n < \left(\sigma_{1}\right)\left(n\right)) \land (\left(\sigma_{1}\right)\left(n\right) < \frac{8 \cdot n}{3}))$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.a392096_sigma_bounds` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every natural n satisfying Member, the conclusion over the rationals is written in the source's own form: 2*n<sigma(n)<8*n/3. It follows from the division-free natural theorem by casting both inequalities and dividing the upper inequality by three.

This is a repository-derived conditional theorem. Its hypothesis is the divisor-form Member criterion transcribed from the OEIS A392096 comment by Hartmut F. W. Hoft dated 2025-12-30; the comment's symmetric-representation width-pattern equivalence is only scope-matched context, is ASSUMED-UNVERIFIED, and is not formalized. No claim is made for a number unless the divisor-form Member predicate has been supplied.

## References

- Truth anchor: `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.DivisorPairs`
- Truth anchor: `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.Member`
- Truth anchor: `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.a392096_sigma_bounds`
- Truth anchor: `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.a392096_sigma_bounds_nat`
- Truth anchor: `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.divisor_pairs_gap_telescoping`
- Truth anchor: `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.divisor_pairs_minFac_bound`
- Truth anchor: `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.divisor_pairs_upper_pair_shape`
- Truth anchor: `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.lower_coefficient_bound`
- Truth anchor: `D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.upper_coefficient_bound`
