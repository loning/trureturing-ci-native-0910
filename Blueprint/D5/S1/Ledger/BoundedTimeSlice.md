# Bounded Time Slices

## Abstract

An actual bounded fixed-sum slice attains the full tail-box size exactly between total tail capacity and head capacity. The 5040 slice has unique maximum 12 at time 4.

Throughout the general statements, I is an arbitrary finite type, including the empty type, with decidable equality. Capacities a map I to the natural numbers, and A and t are natural numbers. B(a) is the dependent tail box of coordinates b(i) in Fin(a(i)+1). Write s(b) for the sum of their natural values, R(a) for the sum of a(i), and P(a) for the product of a(i)+1. S(A,a,t) consists of pairs (h,b) with h in Fin(A+1), b in B(a), and val(h)+s(b)=t. Its actual cardinality is r(A,a,t). The map d(A,a,t) deletes the head; head(x) denotes its natural value. Subtraction is natural subtraction. No comparison of A and R(a) is assumed unless displayed. The empty tail type is a formal extension: its box has one element, and saturation reduces to 0<=t<=A. For the specialization c=(2,1,1), I=Fin(3). In the generating-function identity, X is the indeterminate of the polynomial semiring over the natural numbers, and [X^t] denotes coefficient extraction.

**Theorem 1.1 (The head is forced by the tails).**

$$\forall A \in \mathbb{N}, a \in \mathbb{N}^{I}, t \in \mathbb{N},\; \forall x \in S\left(A, a, t\right),\; head\left(x\right) = t - s\left(d\left(A, a, t\right)\left(x\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_head_eq` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The slice equation determines the head by cancellation. Its existence also ensures that the tail sum does not exceed the time.

**Theorem 1.2 (Head deletion is injective).**

$$\forall A \in \mathbb{N}, a \in \mathbb{N}^{I}, t \in \mathbb{N},\; Injective\left(d\left(A, a, t\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.forget_head_injective` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Two states with the same tails have the same recovered head and therefore are equal as bounded vectors.

**Theorem 1.3 (All tails extend exactly on the plateau).**

$$\forall A \in \mathbb{N}, a \in \mathbb{N}^{I}, t \in \mathbb{N},\; Surjective\left(d\left(A, a, t\right)\right) \Leftrightarrow \left(R\left(a\right) \le t \land t \le A\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.forget_head_surjective_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Surjectivity applied to the maximal tail forces R(a) at most t; applied to the zero tail it forces t at most A. Conversely s(b) is at most R(a), and the head t-s(b) is proved to lie in Fin(A+1) and to satisfy the fixed-sum equation.

**Theorem 1.4 (The tail box bounds every slice).**

$$\forall A \in \mathbb{N}, a \in \mathbb{N}^{I}, t \in \mathbb{N},\; r\left(A, a, t\right) \le P\left(a\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_count_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The injection into the tail box and the cardinality of a finite dependent product give this bound on the actual slice subtype.

**Theorem 1.5 (Polynomial coefficients count bounded slices).**

$$\forall A \in \mathbb{N}, a \in \mathbb{N}^{I}, t \in \mathbb{N},\; r\left(A, a, t\right) = [X^{t}]((\sum_{h = 0}^{A} X^{h}) \cdot \prod_{i \in I} (\sum_{k = 0}^{a\left(i\right)} X^{k}))$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_count_eq_coeff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The product of finite geometric sums expands over the bounded tail coordinates. Multiplication by a head monomial adds the head to the tail sum, and extraction of coefficient t selects exactly the fixed-sum subtype. The proof composes Mathlib's dependent product-of-sums, polynomial coefficient, and finite cardinality identities. It applies to every natural capacity vector and time.

**Theorem 1.6 (Exact saturation criterion).**

$$\forall A \in \mathbb{N}, a \in \mathbb{N}^{I}, t \in \mathbb{N},\; r\left(A, a, t\right) = P\left(a\right) \Leftrightarrow \left(R\left(a\right) \le t \land t \le A\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_plateau_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

An injection between finite types has equal cardinalities precisely when it is surjective. The criterion holds even when A is smaller than R(a).

**Theorem 1.7 (Saturation under the source capacity condition).**

$$\forall A \in \mathbb{N}, a \in \mathbb{N}^{I}, t \in \mathbb{N},\; R\left(a\right) \le A \Rightarrow \left(r\left(A, a, t\right) = P\left(a\right) \Leftrightarrow \left(R\left(a\right) \le t \land t \le A\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_plateau_iff_of_tail_le_head` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The source introduces its plateau criterion under R(a)<=A. This named specialization retains that applicability condition and follows directly from the general saturation criterion.

**Theorem 1.8 (The bound is strict outside the plateau).**

$$\forall A \in \mathbb{N}, a \in \mathbb{N}^{I}, t \in \mathbb{N},\; r\left(A, a, t\right) < P\left(a\right) \Leftrightarrow \left(t < R\left(a\right) \lor A < t\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_strict_lt_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Outside the interval at least one tail cannot extend. The slice cardinality is consequently strictly below the full tail count.

**Theorem 1.9 (Three capacity regimes).**

$$\forall A \in \mathbb{N}, a \in \mathbb{N}^{I},\; \left(R\left(a\right) < A \Rightarrow \left(R\left(a\right) \neq A \land \left(r\left(A, a, R\left(a\right)\right) = P\left(a\right) \land r\left(A, a, A\right) = P\left(a\right)\right)\right)\right) \land \left(\left(A = R\left(a\right) \Rightarrow \left(\forall t \in \mathbb{N},\; r\left(A, a, t\right) \le P\left(a\right) \land \left(r\left(A, a, t\right) = P\left(a\right) \Leftrightarrow t = R\left(a\right)\right)\right)\right) \land \left(A < R\left(a\right) \Rightarrow \left(\forall t \in \mathbb{N},\; r\left(A, a, t\right) < P\left(a\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_plateau_trichotomy` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

If R(a)<A, the distinct times R(a) and A both attain P(a), and the exact criterion identifies all the intervening maximizing times. If A=R(a), the unique maximizing time is R(a). If A<R(a), every slice is strictly smaller than P(a). The first two are global maxima by the universal bound.

**Theorem 1.10 (Three regimes with a longest head chain).**

$$\forall A \in \mathbb{N}, a \in \mathbb{N}^{I},\; \left(\forall i \in I,\; a\left(i\right) \le A\right) \Rightarrow \left(\left(R\left(a\right) < A \Rightarrow \left(R\left(a\right) \neq A \land \left(r\left(A, a, R\left(a\right)\right) = P\left(a\right) \land r\left(A, a, A\right) = P\left(a\right)\right)\right)\right) \land \left(\left(A = R\left(a\right) \Rightarrow \left(\forall t \in \mathbb{N},\; r\left(A, a, t\right) \le P\left(a\right) \land \left(r\left(A, a, t\right) = P\left(a\right) \Leftrightarrow t = R\left(a\right)\right)\right)\right) \land \left(A < R\left(a\right) \Rightarrow \left(\forall t \in \mathbb{N},\; r\left(A, a, t\right) < P\left(a\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_plateau_trichotomy_of_head_maximal` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The source names the distinguished head as a longest chain. This specialization retains every tail capacity at most A, including in the regime A<R(a), and follows from the general trichotomy.

**Theorem 1.11 (Slices vanish after total capacity).**

$$\forall A \in \mathbb{N}, a \in \mathbb{N}^{I}, t \in \mathbb{N},\; A + R\left(a\right) < t \Rightarrow r\left(A, a, t\right) = 0$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_count_eq_zero_of_total_lt` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Every head is at most A and every tail sum is at most R(a), so the subtype is empty when its requested sum exceeds A+R(a).

**Theorem 1.12 (The 5040 capacity data).**

$$5040 = 2^{4} \cdot 3^{2} \cdot 5 \cdot 7 \land \left(R\left(c\right) = 4 \land P\left(c\right) = 12\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_5040_capacities` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The head capacity is 4, for prime 2. The tail capacities are 2, 1, 1, for primes 3, 5, 7. They total 4 and have 12 bounded combinations.

**Theorem 1.13 (All nine slice counts).**

$$(r\left(4, c, 0\right),r\left(4, c, 1\right),r\left(4, c, 2\right),r\left(4, c, 3\right),r\left(4, c, 4\right),r\left(4, c, 5\right),r\left(4, c, 6\right),r\left(4, c, 7\right),r\left(4, c, 8\right)) = (1,4,8,11,12,11,8,4,1)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_5040_sequence` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The general coefficient identity rewrites each actual slice count. The proof then expands the independent polynomial (1+X+X^2+X^3+X^4)(1+X+X^2)(1+X)^2 and extracts its nine coefficients. The cardinality definition is unchanged. The universal maximum theorem below is derived from the general plateau criterion.

**Theorem 1.14 (There are no later nonzero slices).**

$$\forall t \in \mathbb{N},\; 8 < t \Rightarrow r\left(4, c, t\right) = 0$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_5040_zero_after_eight` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Total capacity is 8, so the nine displayed counts exhaust every possibly nonzero slice.

**Theorem 1.15 (The unique global maximum is 12 at time 4).**

$$\forall t \in \mathbb{N},\; r\left(4, c, t\right) \le 12 \land \left(r\left(4, c, t\right) = 12 \Leftrightarrow t = 4\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_5040_unique_maximum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Head capacity and total tail capacity both equal 4, so the plateau is a singleton. This declaration is intended for the later history_5040_max_schmidt_rank theorem in the coherent-history layer; that later theorem is not established here.

**Theorem 1.16 (Each of the twelve tails has one legal head at time four).**

$$\forall b \in B\left(c\right),\; \exists! h \in Fin\left(5\right), (val\left(h\right) + s\left(b\right) = 4 \land val\left(h\right) = 4 - s\left(b\right))$$

*Proof.* Machine-checked in Lean as `D5/S1/Ledger/BoundedTimeSlice.time_slice_5040_tail_extension` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every b with b(0)<=2, b(1)<=1 and b(2)<=1, the sum s(b) is at most 4. The unique head is 4-s(b). Thus the distinguished time follows from the capacity equality and simultaneous legal extension of all tails.

## References

- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.forget_head_injective`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.forget_head_surjective_iff`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_5040_capacities`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_5040_sequence`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_5040_tail_extension`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_5040_unique_maximum`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_5040_zero_after_eight`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_count_eq_coeff`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_count_eq_zero_of_total_lt`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_count_le`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_head_eq`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_plateau_iff`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_plateau_iff_of_tail_le_head`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_plateau_trichotomy`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_plateau_trichotomy_of_head_maximal`
- Truth anchor: `D5/S1/Ledger/BoundedTimeSlice.time_slice_strict_lt_iff`
