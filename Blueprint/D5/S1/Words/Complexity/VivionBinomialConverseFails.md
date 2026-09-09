# A Counterexample Inside Vivion's Restricted Class

## Abstract

An explicit binary word answers Vivion's restricted converse question negatively: its second binomial complexity equals factor complexity at every length, its 1-binomial complexity is smaller at length two, and it is not 1-balanced.

Section 7, Question 3 of Leo Vivion, New examples of words for which binomial complexities and subword complexity coincide, arXiv:2509.11172v2, asks whether a word with b_2 = p outside the class covered by Proposition 6 must still be balanced. Proposition 6 says that a binary 1-balanced word has b_2 = p; Question 3 asks about the converse restricted to words with b_1 < p. Here b_k(n) denotes binomialComplexity(word,k,n), and p(n) is the cardinality of the existing wordFactorSet(word,n).

Immediately after Proposition 6, the paper itself notes that the plain converse is false, using the eventually constant words 1^m 2^omega. The witness here is also eventually constant; that is not the distinction. For those earlier words, factors are determined by their letter counts, so b_1 = p. In particular, their length-two factors 11, 12, 22, when present, have pairwise distinct letter counts. Question 3 excludes them. Our witness has b_1(2) = 2 < 3 = p(2) and therefore lies inside the restricted class. The failure of the plain converse is the paper's own observation, not a new claim here.

The general definitions use a finite alphabet A with decidable equality. wordFactor, wordFactorSet, and mem_wordFactorSet are the existing upstream notions from D5/S1/Words/Complexity/MorseHedlund; none is redefined here. Factors have natural starting indices and are functions from Fin n to A.

**Definition 1.1 (Scattered-subword counts).**

$$scatteredCount: \operatorname{List}(A) \to \left(\operatorname{List}(A) \to Nat\right)$$

*Formalization.* `D5/S1/Words/Complexity/VivionBinomialConverseFails.scatteredCount` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

scatteredCount(pattern,source) counts strictly increasing selections of positions in the source spelling the pattern. Positions need not be consecutive: this is the scattered-subword, or binomial, coefficient. The empty pattern has count one; a nonempty pattern in an empty source has count zero. For two nonempty lists, discard the leading source position, and also count selections using it exactly when the two leading letters agree.

**Definition 1.2 (All pattern counts through length k).**

$$\operatorname{binomialProfile}(k, factor, length, pattern) = \operatorname{scatteredCount}(\operatorname{ofFn}(pattern), \operatorname{ofFn}(factor))$$

*Formalization.* `D5/S1/Words/Complexity/VivionBinomialConverseFails.binomialProfile` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For an implicit natural n and factor : Fin n -> A, binomialProfile k factor has dependent type (length : Fin (k+1)) -> (Fin length.val -> A) -> Nat. The displayed equation holds for every such length and pattern. It includes every pattern length from zero through k, including the empty pattern. ofFn denotes List.ofFn.

**Definition 1.3 (k-binomial equivalence is equality of profiles).**

$$\operatorname{BinomialEquivalent}(k, left, right) \iff (\operatorname{binomialProfile}(k, left) = \operatorname{binomialProfile}(k, right))$$

*Formalization.* `D5/S1/Words/Complexity/VivionBinomialConverseFails.BinomialEquivalent` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For k : Nat and left,right : Fin n -> A with the same implicit length n, BinomialEquivalent is the proposition that the two dependent count profiles are equal. Thus all scattered-subword counts through k agree.

**Definition 1.4 (Count the distinct profiles of occurring factors).**

$$\operatorname{binomialComplexity}(word, k, n) = ((wordFactorSet word n).image (binomialProfile k)).card$$

*Formalization.* `D5/S1/Words/Complexity/VivionBinomialConverseFails.binomialComplexity` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This noncomputable natural-valued definition takes word : Nat -> A and k,n : Nat. It forms the image of the upstream finite factor set under binomialProfile k and takes its cardinality: the number of k-binomial equivalence classes of length-n factors.

**Definition 1.5 (Balance compares equally long factors).**

$$\operatorname{Balanced}(word, c) \iff (\forall n,i,j,letter, \operatorname{scatteredCount}([letter], \operatorname{ofFn}(\operatorname{wordFactor}(word, n, i))) \leq \operatorname{scatteredCount}([letter], \operatorname{ofFn}(\operatorname{wordFactor}(word, n, j))) + c)$$

*Formalization.* `D5/S1/Words/Complexity/VivionBinomialConverseFails.Balanced` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For word : Nat -> A and c : Nat, quantify over all n,i,j : Nat and letter : A. Both factors have the same length n. Since both orders of i and j occur, their letter counts differ by at most c. The additive bound avoids truncated natural subtraction. Balanced word 1 is 1-balance.

**Definition 1.6 (The binary word 010111...).**

$$witness: Nat \to Bool$$

*Formalization.* `D5/S1/Words/Complexity/VivionBinomialConverseFails.witness` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Exactly, witness(index) is false if index = 0 or index = 2, and true otherwise. With false written 0 and true written 1, this is 010111...: precisely two zero positions and an all-one tail starting at index 3.

**Theorem 1.7 (The restricted converse fails).**

$$(\forall n : Nat, binomialComplexity witness 2 n = (wordFactorSet witness n).card) \land binomialComplexity witness 1 2 < (wordFactorSet witness 2).card \land \neg Balanced witness 1$$

*Proof.* Machine-checked in Lean as `D5/S1/Words/Complexity/VivionBinomialConverseFails.restricted_converse_fails` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

There are no hypotheses. The universally quantified conjunct holds at every natural length, including zero, not just finitely many checked lengths. Every factor has a representative at one of starts 0, 1, 2, 3. For lengths at least three, the counts of patterns 0 and 10 separate these representatives and remain unchanged on appending ones. The shorter lengths are checked directly.

At length two the factors are 01, 10, 11, with only two 1-binomial profiles, proving b_1(2) = 2 < 3 = p(2). The equally long factors 010 and 111 at starts 0 and 3 have zero counts two and zero, contradicting 1-balance.

Proposition 6 itself is neither formalized nor assumed. All three properties are proved directly from scattered-subword counts and the existing factor set. Only a witness inside Question 3's restricted class is established: no classification of such words is claimed, and nothing is claimed about larger k or non-binary alphabets. The private proof lemmas are not separate public nodes.

## References

- Truth anchor: `D5/S1/Words/Complexity/VivionBinomialConverseFails.Balanced`
- Truth anchor: `D5/S1/Words/Complexity/VivionBinomialConverseFails.BinomialEquivalent`
- Truth anchor: `D5/S1/Words/Complexity/VivionBinomialConverseFails.binomialComplexity`
- Truth anchor: `D5/S1/Words/Complexity/VivionBinomialConverseFails.binomialProfile`
- Truth anchor: `D5/S1/Words/Complexity/VivionBinomialConverseFails.restricted_converse_fails`
- Truth anchor: `D5/S1/Words/Complexity/VivionBinomialConverseFails.scatteredCount`
- Truth anchor: `D5/S1/Words/Complexity/VivionBinomialConverseFails.witness`
- Dependency: [D5/S1/Words/Complexity/MorseHedlund](MorseHedlund.md)
