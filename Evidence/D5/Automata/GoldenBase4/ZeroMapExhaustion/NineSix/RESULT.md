# Complete external exclusion of capacity (9,6)

## Exact statement

No total first-return skeleton on nine previous-zero states, with at most six
distinct `(terminal-one output, one-zero return target)` pairs, an initial zero
self-loop and initial output zero, fits the exact original power inputs
`Z(4^n)` for every `0 <= n <= 249`.

Unreachable states and ordinary self-loops are included in this exclusion.
There is no reference-machine profile premise or presumed range restriction
on unobserved outputs. All observed labels use exact integer arithmetic.

This completes one previously unresolved member of the total-budget-15 cover.
Combined with the previously deposited (8,7) exclusion and four-transient-state
obstruction, the only remaining member of that cover is (10,5). This document
does not claim that the latter is excluded or that the total lower bound is 16.

## Cover of every zero map

Write A for the zero transition and J for the one-zero transition. Number the
start state 0. There are exactly `9^8 = 43,046,721` functions A with A(0)=0.
The separate coverage audit visits all of them. For each it obtains a proposed
permutation fixing 0, verifies its bijectivity and every equation
`A_rep(pi(q)) = pi(A(q))`, and checks membership in the supplied list of 2,598
representatives. Canonical-label correctness is not trusted as an unchecked
premise: the actual permutation and its conjugacy equations are verified.

Renaming the same states in J,F,G preserves all runs, the initial anchors and
the number of distinct (G,J) pairs. Therefore solving every representative is
a complete cover, even if a canonicalizer were to return redundant forms.
The map list hash also equals the deterministic leaf-extension generation.

## Search completeness and conflict support

The fixed-A algorithm processes the exact samples in increasing exponent order.
A compressed block `10 0^k` updates q to `A^k(J(q))`. If a J entry is first needed,
every target 0 through 8 is considered. Only labels forced by actual endpoints
are assigned to F and G, with F(0)=0 as the separate initial anchor.

For partial G,J data, let P be the distinct fully specified pairs, O the known
output-only requirements not covered by P, and T the known return-only
requirements not covered by P. Every completion needs at least
`|P| + max(|O|, |T|)` pairs. A branch is rejected if this number exceeds six,
or if a common state and channel is forced to have different outputs.

Each computed endpoint additionally records the J coordinates used on its
path. An output conflict is supported by the union of the two path-coordinate
sets. A signature-budget contradiction uses all currently assigned J
coordinates, a safe overapproximation including the supports of all known G
labels. Thus each returned failure is an explanation of the form: no fitted
full table can agree with these particular fixed J entries.

At a branch on J(q), all nine values are covered. If a child's explanation
omits q, it already excludes the parent without that choice. Otherwise the
union of child explanations with q removed excludes the parent after every
value fails. Induction proves preservation of the explanation invariant.
Each completed root failure is required to have an empty support. This is
conflict-directed backjumping, not deletion of a structurally allowed table.

No target orbit reduction or full-reachability hypothesis is used by this
nine-state run. The ordinary chronological and event-driven implementations
are used as small-instance controls, not asserted to have rerun all 2,598 cases.

## Completed execution

All 52 disjoint process ranges finished with exit code zero. Every ID from
0 through 2,597 occurs exactly once. All are UNSAT; no SAT or UNKNOWN remains.

- Search calls: 14,301,737,678.
- Rejected branches: 16,215,693,111. This count includes budget rejections made
  before a recursive call, so it may exceed the search-call count.
- Backjumps: 793,760,752.
- Explicit zero-map conjugacy witnesses checked: 43,046,721.

The three algorithms match brute enumeration of every complete J table on
6,912 small instances, comprising 2,737 SAT and 4,175 UNSAT controls. A separate
partial-assignment check covers 2,250 instances through five states. For each
returned contradiction it enumerates all completions of the returned support,
not merely all completions of the larger original partial assignment. All
1,262 contradictory cases pass, including 282 strictly reduced explanations.

Per-case records are coverage/execution records, not DRAT/LRAT or Lean proof
objects. Rechecking numerical validity recomputes the exhaustive search.
Source identity and coverage hashes do not by themselves prove UNSAT.
No external SAT solver, floating-point oracle or reference DFAO is used.
The implementations and checks were authored by one assistant, not independent
authors. Lean elaboration, kernel acceptance and a formal numeric certificate
are not claimed. The existing typed-to-skeleton and padding arguments retain
their previously stated verification status.

## Reproduction

Requires Python 3, a C++17 compiler and Boost multiprecision headers. From this
directory run:

```sh
python reproduce_nine_six.py /tmp/phi4-nine-six --workers 4
```

The wrapper regenerates samples and map representatives, exhaustively verifies
zero-map coverage, reruns controls and all numerical cases, and rejects any
incomplete process or missing case. A finite timeout never establishes a bound.
The resulting `audited/cases.jsonl` and per-process logs are generated outputs.
The original 7 September case-record hash is retained in `summary.json`;
timings in a fresh execution will differ. The original full records also remain
in the conversation artifact `phi4_nine_six_complete_20260907.zip`.

## Relation to literature

The target is Barnoff, Bright and Shallit, *Computing the base-b representation
of quadratic irrationals using automata*, TCS 1071 (2026), 115843,
DOI 10.1016/j.tcs.2026.115843. Conflict-directed backjumping is the established
method of Prosser, *Hybrid Algorithms for the Constraint Satisfaction Problem*
(1993), DOI 10.1111/j.1467-8640.1993.tb00310.x. Functional-digraph generation is
studied by Defrain, Porreca and Timofeeva (2024), DOI 10.1016/j.dam.2024.05.030.
The present generator uses an explicit leaf/permutation cover and checked
relabelings; it does not claim to implement that paper's polynomial-delay
algorithm. The contribution here is the completed exact capacity exclusion
for the specified original power-digit instance. No first-priority claim is made.

## Synchronization audit, 8 September 2026

The recovered archive's source hashes and all 2,598 original case records were
checked before synchronization. All records specify (9,6), contain exactly IDs
0 through 2,597, and have status UNSAT; their counters reproduce `summary.json`.
Both small-instance control programs were recompiled and rerun with unchanged
results. The 43-million-map cover and large nine-state search were not rerun
in this synchronization. Only the explicit completed source, evidence summaries
and reproducible computation are claimed here; no old progress estimate for the
separate ten-state search is accepted without its corresponding case records.
