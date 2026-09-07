# Multiplicative-Exclusion Residue Class

## Abstract

The candidate-inclusive multiplicative-exclusion sequence is uniquely defined and equals 1, 3, then the arithmetic progression 3n-5.

OEIS A026488, contributed by Clark Kimberling and corrected on 2019-10-12, states this formula as a conjecture. Sean A. Irvine reported verification through n=1300. The repository proof below is symbolic and unbounded.

The source writes a(i)a(j)-a(k) as an integer expression. We formalize its forbidden equality without natural-number truncation: x equals a'(i)a'(j)-a'(k) means x+a'(k)=a'(i)a'(j). At prospective index n, a'(r) is x when r=n and is the prior sequence value a(r) otherwise. Thus k=n, including the self-witness 2+2=2*2, is retained literally.

**Definition 1.1 (Literal candidate-inclusive least-value rule).**

$$\begin{aligned}\forall a: \mathbb{N} \to \mathbb{N}, n, x, r \in \mathbb{N},\\\left(a^{[n:=x]}\right)_{r} = \operatorname{if}(r = n , x , a_{r}),\\\operatorname{SatisfiesLiteralRule}(a) \iff (a_{0} = 0 \land a_{1} = 1 \land \forall n \in \mathbb{N}, (2 \leq n) \Rightarrow \operatorname{IsLeast}(\left\{0 < x \land a_{n - 1} < x \land \forall i , j , k \in \mathbb{N}, (1 \leq i \land i \leq j \land j \leq k \land k \leq n) \Rightarrow x + \left(a^{[n:=x]}\right)_{k} \neq \left(a^{[n:=x]}\right)_{i} \cdot \left(a^{[n:=x]}\right)_{j} \mid x \in \mathbb{N}\right\} , a_{n})).\end{aligned}$$

*Formalization.* `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.SatisfiesLiteralRule` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The sequence is totalized by a(0)=0 and starts at a(1)=1. For every n at least two, a(n) is the least positive x above a(n-1) for which every ordered index triple 1<=i<=j<=k<=n passes the displayed inequality.

**Theorem 1.2 (The protected residue class cannot be excluded).**

$$\begin{aligned}\forall x, u, v, w \in \mathbb{N},\\(4 \leq x \land (x = 3 \lor x \bmod 3 = 1) \land (u = 3 \lor u \bmod 3 = 1) \land (v = 3 \lor v \bmod 3 = 1) \land (w = 3 \lor w \bmod 3 = 1) \land u \leq v \land v \leq w) \Rightarrow\\x + w \neq u \cdot v.\end{aligned}$$

*Proof.* Machine-checked in Lean as `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.residue_protection` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Let S={3} union {z in N | z mod 3=1}. If x>=4 and x,u,v,w lie in S with u<=v<=w, then x+w differs from uv. The exceptional element 3 is discharged by the order bound; all remaining cases are protected modulo three.

**Theorem 1.3 (Five ordered witness families cover the complement).**

$$\begin{aligned}\forall y \in \mathbb{N},\\(7 \leq y) \Rightarrow\\(\neg (y = 3 \lor y \bmod 3 = 1)) \Rightarrow\\\exists u , v , w \in \mathbb{N}, ((u = 3 \lor u \bmod 3 = 1) \land (v = 3 \lor v \bmod 3 = 1) \land (w = 3 \lor w \bmod 3 = 1) \land u \leq v \land v \leq w \land w < y \land y + w = u \cdot v).\end{aligned}$$

*Proof.* Machine-checked in Lean as `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.witness_of_not_memS` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Every y>=7 outside S has ordered u<=v<=w in S, with w<y and y+w=uv.

For t>=1 the proof uses exactly the preregistered families: 9t+3t+4=4(3t+1), (9t+3)+(3t+1)=4(3t+1), (9t+6)+(3t+10)=4(3t+4), (6t+2)+(3t+1)=3(3t+1), and (6t+5)+(3t+7)=3(3t+4).

**Definition 1.4 (Well-founded Nat.find realization).**

$$\begin{aligned}sequence : \mathbb{N} \to \mathbb{N},\\sequence_{0} = 0, sequence_{1} = 1,\\\forall n \in \mathbb{N},\\h_{n} : \mathbb{N} \to \mathbb{N} := (r \mapsto \operatorname{if}(r < n + 2 , sequence_{r} , 0)),\\sequence_{n + 2} = \operatorname{if}(hex : \exists x \in \mathbb{N}, 0 < x \land \left(h_{n}\right)_{n + 2 - 1} < x \land \forall i , j , k \in \mathbb{N}, (1 \leq i \land i \leq j \land j \leq k \land k \leq n + 2) \Rightarrow x + \left(\left(h_{n}\right)^{[n + 2:=x]}\right)_{k} \neq \left(\left(h_{n}\right)^{[n + 2:=x]}\right)_{i} \cdot \left(\left(h_{n}\right)^{[n + 2:=x]}\right)_{j} , \operatorname{Nat.find}(hex) , 0).\end{aligned}$$

*Formalization.* `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

At n+2, h_n is the recursively available prefix, zero outside that prefix. The definition applies Nat.find to the set of literal admissible values when it is inhabited and otherwise returns zero. Strong induction proves the fallback unreachable; the recursive call is on r<n+2.

**Theorem 1.5 (The recursive sequence satisfies the literal rule).**

$$\operatorname{SatisfiesLiteralRule}(sequence).$$

*Proof.* Machine-checked in Lean as `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence_satisfies_literal_rule` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Residue protection makes every target term admissible. The prefix witnesses 2+2=2*2, 5+4=3*3, and 6+3=3*3, followed by the five general families, exclude every intervening value and prove leastness.

**Theorem 1.6 (The initial term is one).**

$$sequence_{1} = 1.$$

*Proof.* Machine-checked in Lean as `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence_one` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is the initial value required by the OEIS name line.

**Theorem 1.7 (The second term is three).**

$$sequence_{2} = 3.$$

*Proof.* Machine-checked in Lean as `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence_two` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The value two is excluded by the prospective self-witness at i=j=k=n=2, while three is admissible.

**Theorem 1.8 (Every later term is the least literal admissible value).**

$$\begin{aligned}\forall n \in \mathbb{N},\\(2 \leq n) \Rightarrow\\\operatorname{IsLeast}(\left\{0 < x \land sequence_{n - 1} < x \land \forall i , j , k \in \mathbb{N}, (1 \leq i \land i \leq j \land j \leq k \land k \leq n) \Rightarrow x + \left(sequence^{[n:=x]}\right)_{k} \neq \left(sequence^{[n:=x]}\right)_{i} \cdot \left(sequence^{[n:=x]}\right)_{j} \mid x \in \mathbb{N}\right\} , sequence_{n}).\end{aligned}$$

*Proof.* Machine-checked in Lean as `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence_recurrence` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This exposes the recurrence clause of SatisfiesLiteralRule directly for the constructed sequence, including the prospective substitution at n.

**Theorem 1.9 (The literal-rule sequence exists uniquely).**

$$\exists! a: \mathbb{N} \to \mathbb{N}, \operatorname{SatisfiesLiteralRule}(a).$$

*Proof.* Machine-checked in Lean as `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.literal_rule_unique` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Agreement on all earlier positive indices preserves the exclusion predicate. Strong induction then identifies the least values at every index.

**Theorem 1.10 (OEIS A026488 has the exact formula 1, 3, then 3n-5).**

$$\begin{aligned}(sequence_{2} = 3)\\\land (\forall n \in \mathbb{N}, (3 \leq n) \Rightarrow sequence_{n} = 3 \cdot n - 5).\end{aligned}$$

*Proof.* Machine-checked in Lean as `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence_formula` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This single theorem carries both numerical clauses of candidate theorem 4.115: a(2)=3 and a(n)=3n-5 for every one-based n>=3. The guarded natural subtraction in 3n-5 is therefore nontruncating.

## References

- Truth anchor: `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.SatisfiesLiteralRule`
- Truth anchor: `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.literal_rule_unique`
- Truth anchor: `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.residue_protection`
- Truth anchor: `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence`
- Truth anchor: `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence_formula`
- Truth anchor: `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence_one`
- Truth anchor: `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence_recurrence`
- Truth anchor: `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence_satisfies_literal_rule`
- Truth anchor: `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.sequence_two`
- Truth anchor: `D5/S1/Recurrence/MultiplicativeExclusionResidueClass.witness_of_not_memS`
