## 87. Authored source status

The increment adds two Lean sources and their two source-owned Scribes, with 27 public declaration handles and full formulas. Mathematical and source review, lexical delimiter checks and exact rational diagnostics were performed. There is no Lean, Lake or dotnet executable in the runtime. No Lean elaboration, kernel acceptance, Scribe compilation, transitive axiom report or extracted-code equivalence is claimed. The new sources introduce no sorry, admit, native_decide or axiom declaration; those source checks do not establish kernel acceptance.

The computational evidence uses NetworkX 3.6.1, NumPy 2.3.5, SciPy 1.17.0 and SymPy 1.14.0. Numerical tolerances select candidate solver solutions and proposed tight rows only. Every admitted flow and primal/dual witness passes exact rational equalities and inequalities. The final script SHA-256 is recorded in `pricing_validation.json` with the executed counts. The repository changes are confined to mathematical sources, corresponding Scribes, reproducible research evidence and this existing theory append.

## 88. Continuation from the merged causal sources and new prior art, 2026-09-07

PR #5029 is now merged. This continuation starts from dev `18731fc5215f6af206aaca8fd578e350fd6cd220`, after the merge repairs and relocation of pricing/moment modules into `D5/S3/ConceptDynamics/CausalMoments`. The original `MarkovianResponseLawFactorization` owner remains in `PartialIdentification`. The new sources import these current owners rather than restoring earlier uncompiled copies. The v4.3 single-compilation specification was reread at blob `bba1875f68c733b925582ffc81f1344cfce96931`; no information-score, catalog-sealing or admission claim is inferred from the new finite tests.

The fresh cross-author scan included loning's #5968/#5990 and AlyciaBHZ's #6029/#5897/#5065. The relevant methodological distinction is coverage of the actual problem: a successful local construction or finite comparison must not replace the original universally quantified object. In the present theorem every original response column is mapped to its actual separator assignment. No mathematical conclusion from the unrelated spectral or hard-core models is imported. Existing engineering and freeze files are unchanged.

The external causal target remains the multiple-intervention and graph-decomposition direction in Arroyo et al., *Multilinear and Linear Programs for Partially Identifiable Queries in Quasi-Markovian Structural Causal Models*, arXiv:2509.03548v1, Section 6, and the tractable mediator-representation question in Xie and Li, arXiv:2602.14503v1, Section 6. These are broader than the fixed-coupling problem proved here.

A directly relevant current algorithmic owner is Jaffke, Morelle, Sau and Thilikos, *Dynamic programming on bipartite tree decompositions*, Journal of Computer and System Sciences 156 (March 2026), 103722, DOI 10.1016/j.jcss.2025.103722, following IPEC 2023. It establishes parameterized algorithms including Maximum Weighted Cut for the broader bipartite-treewidth framework, which generalizes odd-cycle-transversal size. Kolmogorov and Zabih, TPAMI 26(2):147-159 (2004), remains the binary graph-representability owner. Neither separator branching nor graph-cut minimization is claimed as new. The addition here is exact causal coefficient restriction, complete branch certification, original response reconstruction and transport to the original marginal-constrained master problem.

## 89. Restrict actual response coordinates without renormalizing the model

Fix the original normalized mediator law pi on M times M and the original deterministic outcome-column score

```text
P_pi,lambda(y) = sum_(i,j) pi(i,j)*1[y_i=0 and y_j=1] - sum_i lambda_i*y_i.
```

Let K be a supplied finite set of mediator-indexed outcome coordinates. A branch b is an entire function K -> Bool. `pinTable` extends b by false, and `clampTable` replaces precisely those coordinates in an arbitrary full table. `clampTable_restrict` proves that restricting any original table to K and then clamping it reconstructs that same table. Branching fixes deterministic response coordinates; it is not probabilistic conditioning on observed mediator values.

`MediatorPricingRestriction.lean` defines a computational residual law rho by pushing pi through a deterministic map. Pairs with both endpoints outside K are retained; every other pair (i,j) is redirected to (i,i). This preserves total mass and nonnegativity in the existing FiniteResponseLaw API on the unchanged carrier. For i != j, `residualCoupling_offDiagonal` proves

```text
rho(i,j) = pi(i,j) if i,j are outside K, and 0 otherwise.
```

The changed diagonal weights have zero outcome-benefit contribution. They are bookkeeping for normalized computation, not newly asserted mediator data. No division by the surviving edge mass occurs. The original pi continues to define the causal objective and master constraints.

For a free coordinate i, the corrected multiplier is

```text
theta_b(i) = lambda_i
  + sum_(j in K,b_j=1) pi(i,j)
  - sum_(j in K,b_j=0) pi(j,i).
```

On K, theta_b is zero. The branch constant is kappa_b=P_pi,lambda(pinTable(K,b)). The new `pricing_restriction_identity` proves, before imposing any graph condition,

```text
P_pi,lambda(clampTable(K,b,z)) = kappa_b + P_rho,theta_b(z)
```

for every original complete table z. The proof separates fixed/fixed, fixed/free, free/fixed and free/free edge contributions and uses the existing pushforward expectation theorem. Both oriented boundary terms and the full branch constant are retained. Dropping the constant can change the winning branch; renormalizing a surviving half-mass free edge can double its contribution. The exact diagnostic checks both failure modes.

## 90. A checked global oracle beyond bipartite supports

`residualCoupling_bipartite_iff` identifies the precise sufficient graph condition: the original off-diagonal nonzero support induced outside K admits the supplied two-coloring. In graph terminology K is an odd-cycle transversal of that support, though it need not be a minimum one. Self-loops are harmless. The statement concerns this coupling-support graph, not the causal DAG.

`SeparatorMediatorPricing.lean` stores one existing STCutCertificate for every branch b:K->Bool and a proposed winning branch. The field is a total function on the full branch carrier. A producer cannot select an incomplete branch list. The executable checker runs the existing bipartite pricing test on rho and theta_b for every b, recomputes kappa_b plus the certified residual price, and verifies that the winner dominates all branch values.

`checkSeparatorPricing_sound` returns an actual maximizing original outcome table: undo the residual color flip and then restore the winner's K coordinates. To bound an arbitrary competitor, restrict that actual competitor to K, apply its branch identity and checked branch bound, then compare with the winner. This proves an attained global maximum over the entire original response-table carrier, including graphs with odd cycles.

There are 2^card(K) branches; the empty set has its unique empty branch. Each residual flow instance retains the original vertex carrier and can use the merged exact flow-cut certificate. All selected vertices may be fixed, leaving only harmless diagonal mass and zero free multipliers. No minimal-separator search, general certificate-existence theorem or kernel-verified max-flow producer is supplied. Classical max-flow algorithms can propose the checked branch data. The source does not assert a rational bit-complexity bound or a polynomial bound on the total number of master iterations.

## 91. Full original-law bounds and sharp master stopping

`checked_separator_stopping_iff` proves that every original column has score at most tau if and only if the accepted winning value V is at most tau. `checked_separator_causal_bound` reuses the merged expectation identity to prove, for every full outcome law nu with the original prescribed success means r_i,

```text
J(pi,nu) <= V + sum_i lambda_i*r_i.
```

This remains a valid upper bound before a restricted master has converged. `checked_separator_master_isGreatest` adds an actual feasible candidate law, all original mean equalities, V<=tau, and exact candidate objective tau+sum lambda_i*r_i. It then proves the candidate is an attaining sharp upper endpoint of the full canonical outcome-law problem.

The causal evaluator always receives the original pi and the original complete outcome table. The residual rho is used solely to compute and certify branch prices. Independence between the fixed mediator mechanism and outcome mechanism is retained by the existing product semantics. Neither new observational identification of pi nor optimization over unknown pi is inferred.

## 92. Executed non-bipartite tests and a nonfair odd-cycle endpoint

The local Fraction replay uses seed 20260907 and the prior supplied bipartite producer/checker as a proposal backend. It passed 7,746 exact branch-restriction identities, 2,040 comparisons against all original response columns, 32 pricing instances, 1,238 exact branch flow certificates, 20 complete master runs and 17 comparisons with separately enumerated full canonical LPs. Four negative tests rejected omitted branch data, broken flow conservation, a genuinely inferior proposed winner, and an invalid residual coloring. Empty/full K, diagonal mass, asymmetric directed weights and nonfair outcome means were included.

A directed triangle pi(0,1)=pi(1,2)=pi(2,0)=1/3 with outcome means (1/5,3/5,7/10) has sharp upper endpoint 1/3. Taking K={0} gives two certified flow branches. An explicit attaining law assigns masses 1/5,1/10,1/2,1/5 to tables 001,010,011,100 respectively. All three means are exact. Every nonconstant triangle table has one favourable directed edge, so this law has benefit 1/3. The incompatible cellwise relaxation gives 2/5. This concrete value is an executed rational instance of the general certificate construction, not an additional named Lean triangle theorem in this increment.

Three larger generated cases have genuinely non-bipartite original supports and do not enumerate their full canonical column families:

```text
states | |K| | canonical columns | final restricted columns | pricing calls | branch flows | exact upper
12     | 1   | 4096              | 47                       | 29            | 58           | 52/205
16     | 2   | 65536             | 97                       | 69            | 276          | 1171/3760
24     | 2   | 16777216          | 166                      | 126           | 504          | 7167/23780
```

Final restricted-column counts include inactive columns. Fourteen of the twenty master cases strictly improve the incompatible pairwise upper relaxation, including these three larger cases. These counts describe this seeded synthetic suite, not prevalence in scientific data or a runtime superiority result. No published causal benchmark was executed.

Every numerical LP solution is a proposal. Rational reconstruction is accepted only after exact nonnegativity, normalization, all original mean rows, restricted dual inequalities and primal/dual equality; global stopping additionally requires every branch's exact capacity/conservation/contact checks. The replay is a second implementation by the same assistant, not independent-author review or Lean-extracted code. Its source SHA-256 is `1cb7db6fd68bd5ad8c15e314f4ee54783ba509fbab7df524f3e4058caa34cd3e`; the prior backend SHA-256 is `4564f9e4563e242da74d8a597abe46e7f3c88fd86e8f2ccc6a6e5dfa5d4908e8`. Complete local scripts, inputs, rational witnesses and results accompany the downloadable review package rather than new repository research payloads.

## 93. Scientific scope and remaining global optimization

The new modules contain 384 Lean lines and 18 named public declarations, with two corresponding Scribe sources. Source/logic review, declaration-handle matching, lexical delimiter checks and exact rational diagnostics were performed. Lean/Lake and dotnet are unavailable in this runtime, so no new elaboration, kernel acceptance, executed axiom closure or Scribe emission is claimed. The earlier #5029 merge record reports its own successful builds and repairs; those are not new verification receipts for this continuation. No new axiom, sorry, admit or native_decide command is present.

This increment closes the paper-only separator conditioning and coverage obligation in Section 86 at the proof-source level. It does not solve the general multiple-unknown-mechanism open algorithmic extension. In particular, a pricing certificate valid at one fixed pi is not a uniform certificate over a feasible family of pi values; moving pi can alter both coefficients and support. Additional higher-order outcome rows can also change the pricing energy and invalidate the graph-cut representation unless retained explicitly.

A useful next target is a globally valid outer bound over the complete allowed mediator-coupling family, combined with feasible independent-mechanism lower witnesses. It should consume the current exact fixed-slice oracle while proving the validity of any outer relaxation or branch envelope for every coupling in that branch. Alternating exact component optimizations alone cannot certify a joint global optimum. The newer bipartite-treewidth literature is a possible graph-subproblem backend, with its own decomposition and coverage obligations, rather than evidence that this causal outer problem has already been settled.
