# Four Positive Integers with Equal Sum and Product

## Abstract

Positive integer quadruples have equal sum and product exactly when they permute 4, 2, 1, 1; the common value is eight.

All four coordinates are natural numbers. Positivity excludes zero. Perm denotes the usual permutation relation on lists, including repeated entries. Subtraction is natural-number subtraction.

**Theorem 1.1 (The two smallest coordinates).**

$$\forall a \in \mathbb{N}, b \in \mathbb{N}, c \in \mathbb{N}, d \in \mathbb{N},\; \left(0 < d \land \left(d \le c \land \left(c \le b \land \left(b \le a \land a + b + c + d = a \cdot b \cdot c \cdot d\right)\right)\right)\right) \Rightarrow \left(c = 1 \land d = 1\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.sorted_positive_sum_product_lower_pair_eq_one` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Suppose the coordinates are decreasing. If the smallest is at least two, the product is at least eight times the largest coordinate, whereas the sum is at most four times it. Thus the smallest is one. If the next smallest were at least two, the product would be at least four times the largest coordinate, whereas the sum would be at most three times it plus one. The largest is then at least two, so this is again impossible.

**Theorem 1.2 (The remaining two factors).**

$$\forall a \in \mathbb{N}, b \in \mathbb{N}, c \in \mathbb{N}, d \in \mathbb{N},\; \left(0 < d \land \left(d \le c \land \left(c \le b \land \left(b \le a \land a + b + c + d = a \cdot b \cdot c \cdot d\right)\right)\right)\right) \Rightarrow \left(a + b + 2 = a \cdot b \land \left(a - 1\right) \cdot \left(b - 1\right) = 3\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.sorted_positive_sum_product_reduction` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Substituting the two unit coordinates gives the first equation. Both remaining coordinates are at least one, so expansion after subtracting one from each gives the second equation.

**Theorem 1.3 (The decreasing solution).**

$$\forall a \in \mathbb{N}, b \in \mathbb{N}, c \in \mathbb{N}, d \in \mathbb{N},\; \left(0 < d \land \left(d \le c \land \left(c \le b \land \left(b \le a \land a + b + c + d = a \cdot b \cdot c \cdot d\right)\right)\right)\right) \Rightarrow \left(a = 4 \land \left(b = 2 \land \left(c = 1 \land d = 1\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.sorted_positive_sum_product_classification` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The second coordinate cannot be one. If it were at least three, the remaining two-factor product would be at least three times the largest coordinate, exceeding the sum of those coordinates plus two. Hence the second coordinate is two and the largest is four.

**Theorem 1.4 (All positive solutions).**

$$\forall a \in \mathbb{N}, b \in \mathbb{N}, c \in \mathbb{N}, d \in \mathbb{N},\; \left(0 < a \land \left(0 < b \land \left(0 < c \land 0 < d\right)\right)\right) \Rightarrow \left(a + b + c + d = a \cdot b \cdot c \cdot d \Leftrightarrow Perm\left([a, b, c, d], [4, 2, 1, 1]\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.positive_sum_product_iff_perm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Sort the four coordinates in decreasing order. Sorting preserves the list length, positivity, sum, and product, so the decreasing classification applies. Conversely, a permutation of the stated list has the same sum and product.

**Theorem 1.5 (The common value).**

$$\forall a \in \mathbb{N}, b \in \mathbb{N}, c \in \mathbb{N}, d \in \mathbb{N},\; \left(\left(0 < a \land \left(0 < b \land \left(0 < c \land 0 < d\right)\right)\right) \land a + b + c + d = a \cdot b \cdot c \cdot d\right) \Rightarrow \left(a + b + c + d = 8 \land a \cdot b \cdot c \cdot d = 8\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.positive_sum_product_common_value` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Permutation invariance makes both quantities equal to eight for every positive solution.

At the decreasing solution this specializes to $4+2+1+1=8=4\cdot2\cdot1\cdot1$.

## References

- Truth anchor: `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.positive_sum_product_common_value`
- Truth anchor: `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.positive_sum_product_iff_perm`
- Truth anchor: `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.sorted_positive_sum_product_classification`
- Truth anchor: `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.sorted_positive_sum_product_lower_pair_eq_one`
- Truth anchor: `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.sorted_positive_sum_product_reduction`
