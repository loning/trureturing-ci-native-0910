# Completed exclusion of recurrent/signature capacity (8,7)

On the exact original power inputs with indices 0 through 249, no total
first-return skeleton with eight recurrent states, at most seven distinct
(output, return-target) signatures, an initial zero self-loop and initial
output zero can fit every label. The same excludes smaller recurrent carriers
that can be padded to this capacity without increasing signature count.

This is a new completed finite exclusion, not a total-state lower bound 16.
Together with the previous s >= 5 obstruction and canonical s <= r, only
(9,6) and (10,5) remain in the total-budget-15 cover. No result about either
remaining case is asserted by this directory's initial deposit.

## Exhaustive mathematical cover

Write A for the zero transition and J for the one-zero return transition.
Renumber the start as zero. Every A has A(0)=0, giving exactly 8^7=2,097,152
labelled possibilities. The coverage program visits every one, constructs an
explicit permutation fixing zero, checks A-conjugacy entry by entry, and checks
membership of the conjugate in the 929 retained representatives. It does not
need an assumed canonical-labeling theorem. Self-loops and unreachable states
are included, and the conclusion does not assume all states are reachable.

For each A, assign J entries only when a required sample path first needs them.
Every target 0,...,7 is tried. A table fitting the samples must follow one of
these branches. Propagated output assignments come exclusively from observed
endpoints and the initial zero anchor. Different required labels at the same
state and channel are contradictory.

The other pruning rule is the existing partial-signature lower bound. Let P
be the distinct pairs for rows with both G and J known. Let O contain the
remaining known G values not covered by P, and T the remaining known J values
not covered by P. Every completion needs at least |P|+max(|O|,|T|) signatures.
Only a value above seven is rejected. No equal-output-state merging, reference
profile, BFS numbering restriction, or assumed output range is used.

The first implementation uses the full return-block prefix trie. The separate
checker validates every exponent, Fibonacci word and integer-square-root digit
and uses a zero-run trie with edges A^k(J(q)). It independently enumerates every
J branch rather than trusting the first program's answer or branching choices.
Both authorship and execution are by the same assistant; there was no independent
author review. These are complete exact external computations, not Lean execution.

## Recorded execution

All 929 zero-map cases completed in both implementations. The uncompressed runs
visited 104,969,273 search nodes. The compressed checks visited 97,115,601 nodes,
including 84,976,267 rejected leaves. The separate coverage audit checked all
2,097,152 relabeling witnesses. On 6,912 small test instances the checker agrees
with enumeration of all full J tables and exact optimal output completion;
these controls include 2,293 satisfiable and 4,619 unsatisfiable instances.
Detailed ranges, source hashes and measured timings are in the JSON record.

Run from this directory:

```sh
python reproduce_eight_seven.py /tmp/phi4-zero-map-eight-seven
```

The program regenerates all data. Hashes identify bytes; mathematical validity
comes from exhaustive coverage, necessary pruning and the exact second check.
A timeout or incomplete interval causes the wrapper to fail, never to report
a lower bound. Existing typed-to-skeleton extraction, totalization and padding
supply the reduction from the original candidate class. Their Lean kernel
status is unchanged by this external calculation. No new axiom is introduced.
