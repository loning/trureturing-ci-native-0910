# Greedy Floor-Square-Root Run Blocks

## Abstract

The greedy floor-square-root sequence has exactly the conjectured decreasing runs.

OEIS A399084, submitted by Vasilios Mavroudis on 2026-08-18, gives the history-dependent sequence and records the run-length pattern as a conjecture. The definitions and proofs here were first derived in this repository; no external proof is claimed.

Every displayed variable ranges over the natural numbers unless another domain is shown. Arithmetic is natural-number arithmetic: natSub is truncated subtraction, floorSqrt is the natural square root, and groupOf(n) abbreviates natDiv(floorSqrt(4n+5)-1,2). Thus natural division is integer division, never rational division.

**Definition 1.1 (Literal history-dependent sequence).**

$$(\operatorname{seq}\left(0\right) = 0) \land \left((\operatorname{seq}\left(1\right) = 1) \land (\forall n \in \mathbb{N},\; \operatorname{seq}\left(n + 2\right) = \operatorname{if}\left(\operatorname{natSub}\left(\operatorname{seq}\left(n + 1\right), 1\right) \in \operatorname{image}\left(\mathit{seq}, \operatorname{range}\left(n + 2\right)\right), \operatorname{seq}\left(n + 1\right) + \operatorname{floorSqrt}\left(\operatorname{seq}\left(n + 1\right)\right), \operatorname{natSub}\left(\operatorname{seq}\left(n + 1\right), 1\right)\right))\right)$$

*Formalization.* `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The public sequence is the value field of a private prefix state. State zero is (0,{0}), state one is (1,{0,1}), and each later state tests value-1 against the accumulated finite set before either adding floorSqrt(value) or accepting that predecessor. The next value is inserted into the same history, so the definition implements the literal OEIS rule rather than a recurrence that assumes a closed form.

**Theorem 1.2 (Sequence value at zero).**

$$\operatorname{seq}\left(0\right) = 0$$

*Proof.* Machine-checked in Lean as `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq_zero` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The initial prefix state has value zero.

**Theorem 1.3 (Sequence value at one).**

$$\operatorname{seq}\left(1\right) = 1$$

*Proof.* Machine-checked in Lean as `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq_one` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The second prefix state has value one.

**Theorem 1.4 (Literal unused-predecessor rule).**

$$\forall n \in \mathbb{N},\; \operatorname{seq}\left(n + 2\right) = \operatorname{if}\left(\operatorname{natSub}\left(\operatorname{seq}\left(n + 1\right), 1\right) \in \operatorname{image}\left(\mathit{seq}, \operatorname{range}\left(n + 1 + 1\right)\right), \operatorname{seq}\left(n + 1\right) + \operatorname{floorSqrt}\left(\operatorname{seq}\left(n + 1\right)\right), \operatorname{natSub}\left(\operatorname{seq}\left(n + 1\right), 1\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq_succ_succ` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

At index n+2 the candidate is seq(n+1)-1. Membership is tested in the image of seq on range((n+1)+1), exactly the indices already present. A seen candidate triggers the floor-square-root jump; an unseen one becomes the next value.

**Definition 1.5 (Four-block group start).**

$$\forall m \in \mathbb{N},\; \operatorname{groupStart}\left(m\right) = \operatorname{natSub}\left(m \cdot m + m, 1\right)$$

*Formalization.* `D5/S1/Digit/GreedyFloorSqrtRunBlocks.groupStart` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For parameter m, the four consecutive blocks begin at s=m^2+m-1.

**Definition 1.6 (Explicit four-block closed form).**

$$\forall n \in \mathbb{N},\; \operatorname{closedForm}\left(n\right) = \operatorname{if}\left(n < 5, n, \operatorname{if}\left(\operatorname{natSub}\left(n, \operatorname{groupStart}\left(\operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right)\right)\right) < \operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right), \operatorname{natSub}\left(\operatorname{natSub}\left(\operatorname{groupStart}\left(\operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right)\right) + \operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right), 1\right), \operatorname{natSub}\left(n, \operatorname{groupStart}\left(\operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right)\right)\right)\right), \operatorname{if}\left(\operatorname{natSub}\left(n, \operatorname{groupStart}\left(\operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right)\right)\right) = \operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right), \operatorname{groupStart}\left(\operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right)\right) + \operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right), \operatorname{if}\left(\operatorname{natSub}\left(n, \operatorname{groupStart}\left(\operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right)\right)\right) \le 2 \cdot \operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right), \operatorname{natSub}\left(\operatorname{groupStart}\left(\operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right)\right) + 3 \cdot \operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right) + 1, \operatorname{natSub}\left(n, \operatorname{groupStart}\left(\operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right)\right)\right)\right), \operatorname{groupStart}\left(\operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right)\right) + 2 \cdot \operatorname{natDiv}\left(\operatorname{natSub}\left(\operatorname{floorSqrt}\left(4 \cdot n + 5\right), 1\right), 2\right) + 1\right)\right)\right)\right)$$

*Formalization.* `D5/S1/Digit/GreedyFloorSqrtRunBlocks.closedForm` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For n below five the value is n. Otherwise m=groupOf(n), s=groupStart(m), and r=n-s. The four branches are respectively s+m-1-r, s+m, s+3m+1-r, and s+2m+1, with tests r<m, r=m, and r<=2m. This is the preregistered candidate without an equivalent replacement.

**Theorem 1.7 (Square interval invariant).**

$$\forall m \in \mathbb{N},\; 2 \le m \Rightarrow \left((m^{2} \le \operatorname{natSub}\left(\operatorname{groupStart}\left(m\right), 1\right)) \land \left((m^{2} \le \operatorname{groupStart}\left(m\right)) \land \left((m^{2} \le \operatorname{groupStart}\left(m\right) + m) \land \left((m^{2} \le \operatorname{groupStart}\left(m\right) + m + 1) \land \left((\operatorname{natSub}\left(\operatorname{groupStart}\left(m\right), 1\right) < \left(m + 1\right)^{2}) \land \left((\operatorname{groupStart}\left(m\right) < \left(m + 1\right)^{2}) \land \left((\operatorname{groupStart}\left(m\right) + m < \left(m + 1\right)^{2}) \land \left((\operatorname{groupStart}\left(m\right) + m + 1 < \left(m + 1\right)^{2}) \land \left((\left(m + 1\right)^{2} \le \operatorname{groupStart}\left(m\right) + 2 \cdot m + 1) \land (\operatorname{groupStart}\left(m\right) + 2 \cdot m + 1 < \left(m + 2\right)^{2})\right)\right)\right)\right)\right)\right)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Digit/GreedyFloorSqrtRunBlocks.interval_invariant` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Writing s=groupStart(m), the ten displayed inequalities place s-1, s, s+m, and s+m+1 between m^2 and (m+1)^2, while s+2m+1 lies between (m+1)^2 and (m+2)^2. These bounds fix all five natural square roots used at the jump boundaries.

**Theorem 1.8 (Closed form obeys the literal rule).**

$$\forall N \in \mathbb{N},\; 2 \le N \Rightarrow \operatorname{closedForm}\left(N\right) = \operatorname{if}\left(\operatorname{natSub}\left(\operatorname{closedForm}\left(\operatorname{natSub}\left(N, 1\right)\right), 1\right) \in \operatorname{image}\left(\mathit{closedForm}, \operatorname{range}\left(N\right)\right), \operatorname{closedForm}\left(\operatorname{natSub}\left(N, 1\right)\right) + \operatorname{floorSqrt}\left(\operatorname{closedForm}\left(\operatorname{natSub}\left(N, 1\right)\right)\right), \operatorname{natSub}\left(\operatorname{closedForm}\left(\operatorname{natSub}\left(N, 1\right)\right), 1\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Digit/GreedyFloorSqrtRunBlocks.closedForm_follows_rule` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Involutivity makes membership in the closed-form history equivalent to closedForm(x)<N. The square bounds then determine each jump, and an exhaustive split across the four offsets proves the exact recursive equation.

**Theorem 1.9 (Recursive sequence equals the closed form).**

$$\forall n \in \mathbb{N},\; \operatorname{seq}\left(n\right) = \operatorname{closedForm}\left(n\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq_eq_closedForm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Strong induction transports the literal history image from seq to the closed form and applies the preceding rule theorem at each index.

**Theorem 1.10 (Sequence values in four blocks).**

$$\forall m \in \mathbb{N},\; 2 \le m \Rightarrow \left((\forall i \in \mathbb{N},\; i < m \Rightarrow \operatorname{seq}\left(\operatorname{groupStart}\left(m\right) + i\right) = \operatorname{natSub}\left(\operatorname{natSub}\left(\operatorname{groupStart}\left(m\right) + m, 1\right), i\right)) \land \left((\operatorname{seq}\left(\operatorname{groupStart}\left(m\right) + m\right) = \operatorname{groupStart}\left(m\right) + m) \land \left((\forall i \in \mathbb{N},\; i < m \Rightarrow \operatorname{seq}\left(\operatorname{groupStart}\left(m\right) + m + 1 + i\right) = \operatorname{natSub}\left(\operatorname{groupStart}\left(m\right) + 2 \cdot m, i\right)) \land (\operatorname{seq}\left(\operatorname{groupStart}\left(m\right) + 2 \cdot m + 1\right) = \operatorname{groupStart}\left(m\right) + 2 \cdot m + 1)\right)\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq_four_blocks` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every m at least two and s=groupStart(m), the first m values descend from s+m-1 to s, the next value is fixed, the following m values descend from s+2m to s+m+1, and the final value is fixed.

**Definition 1.11 (Maximal decreasing run predicate).**

$$\forall a \in \mathbb{N} \to \mathbb{N},\; \forall start \in \mathbb{N},\; \forall len \in \mathbb{N},\; \operatorname{IsMaximalDecreasingRun}\left(a, \mathit{start}, \mathit{len}\right) \Leftrightarrow \left((0 < \mathit{len}) \land \left((\forall j \in \mathbb{N},\; j + 1 < \mathit{len} \Rightarrow a\left(\mathit{start} + j + 1\right) < a\left(\mathit{start} + j\right)) \land \left(((\mathit{start} = 0) \lor (\neg (a\left(\mathit{start}\right) < a\left(\operatorname{natSub}\left(\mathit{start}, 1\right)\right)))) \land (\neg (a\left(\mathit{start} + \mathit{len}\right) < a\left(\operatorname{natSub}\left(\mathit{start} + \mathit{len}, 1\right)\right)))\right)\right)\right)$$

*Formalization.* `D5/S1/Digit/GreedyFloorSqrtRunBlocks.IsMaximalDecreasingRun` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

A run has positive length, decreases at every internal adjacent pair, cannot be extended to the left unless it starts at zero, and cannot be extended to the right. The last condition compares indices start+len-1 and start+len.

**Theorem 1.12 (Complete maximal-run classification).**

$$\forall start \in \mathbb{N},\; \forall len \in \mathbb{N},\; \operatorname{IsMaximalDecreasingRun}\left(\mathit{seq}, \mathit{start}, \mathit{len}\right) \Leftrightarrow \left(((\mathit{start} < 5) \land (\mathit{len} = 1)) \lor (\exists m \in \mathbb{N},\; (2 \le m) \land (((\mathit{start} = \operatorname{groupStart}\left(m\right)) \land (\mathit{len} = m)) \lor \left(((\mathit{start} = \operatorname{groupStart}\left(m\right) + m) \land (\mathit{len} = 1)) \lor \left(((\mathit{start} = \operatorname{groupStart}\left(m\right) + m + 1) \land (\mathit{len} = m)) \lor ((\mathit{start} = \operatorname{groupStart}\left(m\right) + 2 \cdot m + 1) \land (\mathit{len} = 1))\right)\right)))\right)$$

*Proof.* Machine-checked in Lean as `D5/S1/Digit/GreedyFloorSqrtRunBlocks.maximal_decreasing_run_lengths` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The maximal runs are exactly the five initial singleton runs and, for each m at least two, runs (s,m), (s+m,1), (s+m+1,m), and (s+2m+1,1), where s=groupStart(m). Consequently their lengths are 1,1,1,1,1 followed by m,1,m,1 for m=2,3,4,... . Coverage of every index by one listed run and uniqueness of overlapping maximal runs make the classification exhaustive.

## References

- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.IsMaximalDecreasingRun`
- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.closedForm`
- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.closedForm_follows_rule`
- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.groupStart`
- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.interval_invariant`
- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.maximal_decreasing_run_lengths`
- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq`
- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq_eq_closedForm`
- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq_four_blocks`
- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq_one`
- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq_succ_succ`
- Truth anchor: `D5/S1/Digit/GreedyFloorSqrtRunBlocks.seq_zero`
