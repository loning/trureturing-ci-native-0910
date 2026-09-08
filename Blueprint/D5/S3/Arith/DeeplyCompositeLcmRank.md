# The Square-Root-Rank LCM Law for Deeply Composite Numbers

## Abstract

Deeply composite numbers contain the lcm prefix forced by their square-root rank.

**Definition 1.1 (Rank counts deeply composite numbers through n).**

$$\forall n \in \mathbb{N},\; rank\left(n\right) = card\left(filter\left(Icc\left(1, n\right), DC\right)\right)$$

*Formalization.* `D5/S3/Factorization/DeeplyCompositeLcmRank.rank` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The rank of n is the cardinality of the filter by DC of the closed natural interval from one through n. In displayed formulas, filter(S,P) denotes the elements of the finite set S satisfying P. This is the repository rank encoding.

**Theorem 1.2 (Rank equals the source's literal count through n).**

$$\forall n \in \mathbb{N},\; rank\left(n\right) = card\left(\{m \in \mathbb{N} \mid (m \le n \land DC\left(m\right))\}\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeLcmRank.rank_eq_card_filter_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This theorem is the definition-fidelity bridge to the source formula r(n) = #{m <= n : DC(m)}. Positivity is already part of DC, so the repository interval starting at one counts exactly the same terms as the literal bounded set displayed here.

**Definition 1.3 (The zero-indexed enumeration of deeply composite numbers).**

$$\forall r \in \mathbb{N},\; a\left(r\right) = Nat.nth\left(DC, r\right)$$

*Formalization.* `D5/S3/Factorization/DeeplyCompositeLcmRank.a` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The repository sequence a(r) is Nat.nth applied to DC, so r starts at zero. It supplies the sequence-level representation corresponding to OEIS A095848 (Switkay, comments 2023 and 2025).

**Definition 1.4 (The least common multiple prefix).**

$$\forall k \in \mathbb{N},\; L\left(k\right) = Nat.lcmUpto\left(k\right)$$

*Formalization.* `D5/S3/Factorization/DeeplyCompositeLcmRank.L` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

L(k) is Nat.lcmUpto(k), the least common multiple of the positive integers through k, corresponding to OEIS A003418. This is the repository abbreviation used in the proof.

**Definition 1.5 (Deeply composite records below an lcm prefix).**

$$\forall k \in \mathbb{N},\; recordsBelowL\left(k\right) = filter\left(Ico\left(1, L\left(k\right)\right), DC\right)$$

*Formalization.* `D5/S3/Factorization/DeeplyCompositeLcmRank.recordsBelowL` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

recordsBelowL(k) filters the half-open interval from one to L(k) by the repository predicate DC.

**Definition 1.6 (Deeply composite records in one lcm band).**

$$\forall k \in \mathbb{N},\; recordBand\left(k\right) = filter\left(Ico\left(L\left(k\right), L\left(k + 1\right)\right), DC\right)$$

*Formalization.* `D5/S3/Factorization/DeeplyCompositeLcmRank.recordBand` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

recordBand(k) filters the half-open interval from L(k) to L(k+1) by DC.

**Theorem 1.7 (The next lcm prefix is bounded by endpoint multiplication).**

$$\forall k \in \mathbb{N},\; L\left(k + 1\right) \le L\left(k\right) \cdot \left(k + 1\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeLcmRank.L_succ_le_mul` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The repository proof expands the next lcm prefix and uses that a least common multiple divides the corresponding product.

**Theorem 1.8 (Every reached lcm prefix divides a deeply composite number).**

$$\forall n \in \mathbb{N}, j \in \mathbb{N},\; DC\left(n\right) \Rightarrow \left(L\left(j\right) \le n \Rightarrow L\left(j\right) \mid n\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeLcmRank.prefix_locking` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For repository-encoded DC(n), if L(j) <= n then L(j) divides n. Otherwise the first divisor through j missing from n makes the smaller number L(j) precede n, contradicting the record condition.

**Theorem 1.9 (Few deeply composite records lie below an lcm prefix).**

$$\forall k \in \mathbb{N},\; card\left(filter\left(Ico\left(1, L\left(k\right)\right), DC\right)\right) \le NatDiv\left(k \cdot (k - 1), 2\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeLcmRank.counting_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Below L(k), at most NatDiv(k*(k-1),2) deeply composite numbers occur. Here NatDiv is natural-number Euclidean division, not rational division. The proof partitions records into successive lcm bands and injects the k-th band into the positive integers below k+1. This is a repository counting theorem.

**Theorem 1.10 (A deeply composite number has positive rank).**

$$\forall n \in \mathbb{N},\; DC\left(n\right) \Rightarrow 0 < rank\left(n\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeLcmRank.rank_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A deeply composite n belongs to its own filtered closed interval, so the cardinality defining the repository rank(n) is positive.

**Theorem 1.11 (The square-root-rank lcm divides every deeply composite number).**

$$\forall n \in \mathbb{N},\; DC\left(n\right) \Rightarrow L\left(Nat.sqrt\left(2 \cdot rank\left(n\right)\right)\right) \mid n$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeLcmRank.deeply_composite_lcm_sqrt_rank` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every deeply composite n, L(Nat.sqrt(2*rank(n))) divides n, where Nat.sqrt is the natural-number square root, hence floor(sqrt(-)). Prefix locking and the counting bound force this divisibility: failure would place n below the lcm prefix while making twice its rank simultaneously no larger and strictly larger than the same square. This proves the repository DC/rank specialization of Switkay's A095848 comment of 2025-09-07.

**Theorem 1.12 (Every enumerated term is deeply composite).**

$$\forall r \in \mathbb{N},\; DC\left(a\left(r\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeLcmRank.dc_nth` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Infinitude of the repository predicate DC and Nat.nth membership show that every zero-indexed term a(r) satisfies DC.

**Theorem 1.13 (Enumeration index and deeply composite rank agree).**

$$\forall r \in \mathbb{N},\; rank\left(a\left(r\right)\right) = r + 1$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeLcmRank.rank_nth` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The repository rank counts through its endpoint, while Nat.nth is zero-indexed, so rank(a(r)) equals r+1.

**Theorem 1.14 (The square-root-rank lcm law for the enumerated sequence).**

$$\forall r \in \mathbb{N},\; L\left(Nat.sqrt\left(2 \cdot \left(r + 1\right)\right)\right) \mid a\left(r\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Factorization/DeeplyCompositeLcmRank.oeis_a095848_lcm_sqrt_rank` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Substituting the public DC and rank bridges into the repository theorem gives the zero-indexed sequence form of Switkay's OEIS A095848 conjecture from the comment of 2025-09-07.

## References

- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.L`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.L_succ_le_mul`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.a`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.counting_bound`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.dc_nth`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.deeply_composite_lcm_sqrt_rank`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.oeis_a095848_lcm_sqrt_rank`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.prefix_locking`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.rank`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.rank_eq_card_filter_le`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.rank_nth`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.rank_pos`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.recordBand`
- Truth anchor: `D5/S3/Factorization/DeeplyCompositeLcmRank.recordsBelowL`
- Dependency: [D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord](DeeplyCompositeNotPrimeExponentRecord.md)
