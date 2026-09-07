# 2-Boolean Persistence Refutation

## Abstract

The longest signed permutation in B2 is 2-boolean but globally contains 4321.

Levens, Lewis, and Tenner, arXiv:2504.13108v1, Section 6.1 ask whether 2-booleanity is persistent in the sense of their Definition 4.1. Their Definition 2.4 permits both negative and positive indices in global pattern containment. The paper poses the question but does not state the counterexample proved here, so the counterexample declarations have repository provenance.

The mirror carrier Fin(2n) is ordered as -n through -1, then 1 through n. Its involution rev represents sign change. For B2, positions 0, 1, 2, 3 therefore represent -2, -1, 1, 2.

**Definition 1.1 (Concrete signed permutations).**

$$\forall n: \mathbb{N}, \operatorname{SignedPerm}(n) = \{sigma: \operatorname{Equiv}(\operatorname{Fin}(2 \times n), \operatorname{Fin}(2 \times n)) \mid (\forall i: \operatorname{Fin}(2 \times n), \operatorname{sigma}(\operatorname{rev}(i)) = \operatorname{rev}(\operatorname{sigma}(i)))\}.$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.SignedPerm` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This record consists of a permutation of Fin(2n) and the displayed commuting law with rev. Thus it is exactly a permutation w satisfying w(-i)=-w(i).

**Definition 1.2 (The B2 generators).**

$$Generator = \{s_{0}, s_{1}\}.$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.Generator` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The concrete generator type has exactly the constructors s0 and s1.

**Definition 1.3 (The sign-change generator).**

$$\operatorname{toEquiv}(simple0) = \operatorname{swap}(1, 2).$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.simple0` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The equivalence swaps mirror positions 1 and 2 and fixes 0 and 3. Its record proof certifies commutation with rev.

**Definition 1.4 (The adjacent-swap generator).**

$$\operatorname{toEquiv}(simple1) = \operatorname{trans}(\operatorname{swap}(0, 1), \operatorname{swap}(2, 3)).$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.simple1` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The equivalence first swaps positions 0 and 1 and then positions 2 and 3. Its record proof certifies commutation with rev.

**Definition 1.5 (Evaluation of B2 words).**

$$\begin{aligned}\operatorname{toEquiv}(\operatorname{evalWord}([])) = \operatorname{id}(\operatorname{Fin}(4)),\\\operatorname{toEquiv}(\operatorname{evalWord}(\operatorname{cons}(s_{0}, u))) = \operatorname{trans}(\operatorname{toEquiv}(simple0), \operatorname{toEquiv}(\operatorname{evalWord}(u))),\\\operatorname{toEquiv}(\operatorname{evalWord}(\operatorname{cons}(s_{1}, u))) = \operatorname{trans}(\operatorname{toEquiv}(simple1), \operatorname{toEquiv}(\operatorname{evalWord}(u))).\end{aligned}$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.evalWord` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The empty word is the identity. The two successor equations inline the private generator dispatch and composition used by Lean.

**Definition 1.6 (Reduced decompositions).**

$$\forall word: \operatorname{List}(Generator), \forall w: \operatorname{SignedPerm}(2), \operatorname{IsReducedWord}(word, w) \iff (\forall i: \operatorname{Fin}(4), \operatorname{toEquiv}(\operatorname{evalWord}(word), i) = \operatorname{toEquiv}(w, i)) \land (\forall other: \operatorname{List}(Generator), (\forall i: \operatorname{Fin}(4), \operatorname{toEquiv}(\operatorname{evalWord}(other), i) = \operatorname{toEquiv}(w, i)) \Rightarrow \operatorname{length}(word) \leq \operatorname{length}(other)).$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.IsReducedWord` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Equality of signed permutations is tested pointwise on the whole mirror carrier. Minimality quantifies over every generator word, not over the finite certificate table.

**Definition 1.7 (2-boolean signed permutations).**

$$\forall w: \operatorname{SignedPerm}(2), \operatorname{TwoBoolean}(w) \iff (\forall word: \operatorname{List}(Generator), \operatorname{IsReducedWord}(word, w) \Rightarrow \forall g: Generator, \operatorname{count}(word, g) \leq 2).$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.TwoBoolean` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Every reduced word must use each of the two generators at most twice.

**Definition 1.8 (The longest B2 element).**

$$\operatorname{toEquiv}(longest) = revPerm.$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.longest` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The equivalence rev sends the window (1,2) to (-1,-2).

**Definition 1.9 (Signed value of a mirror position).**

$$\forall n: \mathbb{N}, \forall i: \operatorname{Fin}(2 \times n), \operatorname{mirrorValue}(i) = \operatorname{if}(\operatorname{val}(i) < n, \operatorname{int}(\operatorname{val}(i)) - \operatorname{int}(n), \operatorname{int}((\operatorname{val}(i) - n + 1))).$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.mirrorValue` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

In the first branch both subtractions are in the integers. In the second branch i.val-n+1 is computed in the naturals and only then coerced to the integers; this matches the Lean definition exactly.

**Definition 1.10 (Evaluation at a signed index).**

$$\forall n: \mathbb{N}, \forall w: \operatorname{SignedPerm}(n), \forall i: \operatorname{Fin}(2 \times n), \operatorname{valueAt}(w, i) = \operatorname{mirrorValue}(\operatorname{toEquiv}(w, i)).$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.valueAt` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Apply the underlying equivalence, then translate the resulting mirror position to its signed integer value.

**Definition 1.11 (Relative-order isomorphism).**

$$\forall k: \mathbb{N}, \forall a, b: \operatorname{Fin}(k) \to \mathbb{Z}, \operatorname{OrderIsomorphic}(a, b) \iff (\forall i, j: \operatorname{Fin}(k), \operatorname{a}(i) < \operatorname{a}(j) \iff \operatorname{b}(i) < \operatorname{b}(j)).$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.OrderIsomorphic` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Every pair of coordinates has the same strict-order comparison in both strings.

**Definition 1.12 (Global unsigned-pattern containment).**

$$\forall n, k: \mathbb{N}, \forall w: \operatorname{SignedPerm}(n), \forall p: \operatorname{Fin}(k) \to \mathbb{Z}, \operatorname{GloballyContains}(w, p) \iff (\exists indices: \operatorname{Fin}(k) \to \operatorname{Fin}(2 \times n), (\forall i, j: \operatorname{Fin}(k), i < j \Rightarrow \operatorname{indices}(i) < \operatorname{indices}(j)) \land \operatorname{OrderIsomorphic}((i \mapsto \operatorname{valueAt}(w, \operatorname{indices}(i))), p)).$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.GloballyContains` (`✓ std3`).

*Citation.* Owen John Levens and Joel Brewster Lewis and Bridget Eileen Tenner (2025). *Global patterns in signed permutations*. DOI: [10.48550/arXiv.2504.13108](https://doi.org/10.48550/arXiv.2504.13108).

*Commentary.*

The selected indices are strictly increasing in the full signed order. Their values under w must have the same relative order as p, exactly as in Levens-Lewis-Tenner Definition 2.4.

**Definition 1.13 (The pattern 3421).**

$$pattern3421 = [3, 4, 2, 1].$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.pattern3421` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The displayed vector gives this Fin(4)-indexed integer function in index order.

**Definition 1.14 (The pattern 4312).**

$$pattern4312 = [4, 3, 1, 2].$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.pattern4312` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The displayed vector gives this Fin(4)-indexed integer function in index order.

**Definition 1.15 (The pattern 4321).**

$$\forall i: \operatorname{Fin}(4), \operatorname{pattern4321}(i) = \operatorname{int}(4) - \operatorname{int}(\operatorname{val}(i)).$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.pattern4321` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For i in Fin(4), the value is the integer 4 minus the natural coordinate i.val coerced to the integers.

**Definition 1.16 (The pattern 456123).**

$$pattern456123 = [4, 5, 6, 1, 2, 3].$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.pattern456123` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The displayed vector gives this Fin(6)-indexed integer function in index order.

**Definition 1.17 (Global avoidance of the four type-A patterns).**

$$\forall w: \operatorname{SignedPerm}(2), \operatorname{AvoidsTwoBooleanPatterns}(w) \iff (\neg (\operatorname{GloballyContains}(w, pattern3421)) \land \neg (\operatorname{GloballyContains}(w, pattern4312)) \land \neg (\operatorname{GloballyContains}(w, pattern4321)) \land \neg (\operatorname{GloballyContains}(w, pattern456123))).$$

*Formalization.* `D5/S1/Permutations/TwoBooleanPersistenceRefutation.AvoidsTwoBooleanPatterns` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This conjunction is global avoidance of 3421, 4312, 4321, and 456123.

**Theorem 1.18 (All reduced words of the longest element).**

$$\forall word: \operatorname{List}(Generator), \operatorname{IsReducedWord}(word, longest) \iff (word = [s_{0}, s_{1}, s_{0}, s_{1}] \lor word = [s_{1}, s_{0}, s_{1}, s_{0}]).$$

*Proof.* Machine-checked in Lean as `D5/S1/Permutations/TwoBooleanPersistenceRefutation.reduced_words_longest_iff` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A private bounded enumeration checks all 31 words of length at most four: none of the 15 shorter words reaches longest, and exactly the two displayed length-four words do. Minimality still ranges over all words.

**Theorem 1.19 (The longest element is 2-boolean).**

$$\operatorname{TwoBoolean}(longest).$$

*Proof.* Machine-checked in Lean as `D5/S1/Permutations/TwoBooleanPersistenceRefutation.longest_twoBoolean` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The reduced-word classification shows that each displayed word contains s0 twice and s1 twice.

**Theorem 1.20 (The longest element globally contains 4321).**

$$\operatorname{GloballyContains}(longest, pattern4321).$$

*Proof.* Machine-checked in Lean as `D5/S1/Permutations/TwoBooleanPersistenceRefutation.longest_globallyContains_4321` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The identity index embedding selects -2<-1<1<2. The corresponding values are 2,1,-1,-2, whose relative order is 4321; Lean's kernel decides the finite comparison table.

**Theorem 1.21 (A 2-boolean global-pattern counterexample).**

$$\exists w: \operatorname{SignedPerm}(2), (\operatorname{TwoBoolean}(w)) \land (\operatorname{GloballyContains}(w, pattern4321)).$$

*Proof.* Machine-checked in Lean as `D5/S1/Permutations/TwoBooleanPersistenceRefutation.twoBoolean_persistence_refutation` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The witness is longest=(-1,-2). The preceding two theorems are both on the live proof path: it is 2-boolean and globally contains the forbidden pattern 4321.

**Theorem 1.22 (2-booleanity is not global avoidance).**

$$\neg (\forall w: \operatorname{SignedPerm}(2), \operatorname{TwoBoolean}(w) \iff \operatorname{AvoidsTwoBooleanPatterns}(w)).$$

*Proof.* Machine-checked in Lean as `D5/S1/Permutations/TwoBooleanPersistenceRefutation.twoBoolean_set_differs_from_global_avoiders` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

At longest, 2-booleanity holds while the 4321 conjunct of global avoidance fails. Therefore the two predicates are not equal on SignedPerm(2), answering the Section 6.1 persistence question in the negative.

## References

- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.AvoidsTwoBooleanPatterns`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.Generator`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.GloballyContains`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.IsReducedWord`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.OrderIsomorphic`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.SignedPerm`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.TwoBoolean`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.evalWord`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.longest`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.longest_globallyContains_4321`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.longest_twoBoolean`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.mirrorValue`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.pattern3421`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.pattern4312`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.pattern4321`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.pattern456123`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.reduced_words_longest_iff`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.simple0`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.simple1`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.twoBoolean_persistence_refutation`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.twoBoolean_set_differs_from_global_avoiders`
- Truth anchor: `D5/S1/Permutations/TwoBooleanPersistenceRefutation.valueAt`
