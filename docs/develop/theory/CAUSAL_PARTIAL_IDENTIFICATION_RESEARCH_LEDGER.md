## 93. Scientific scope and remaining global optimization

The new modules contain 384 Lean lines and 18 named public declarations, with two corresponding Scribe sources. Source/logic review, declaration-handle matching, lexical delimiter checks and exact rational diagnostics were performed. Lean/Lake and dotnet are unavailable in this runtime, so no new elaboration, kernel acceptance, executed axiom closure or Scribe emission is claimed. The earlier #5029 merge record reports its own successful builds and repairs; those are not new verification receipts for this continuation. No new axiom, sorry, admit or native_decide command is present.

This increment closes the paper-only separator conditioning and coverage obligation in Section 86 at the proof-source level. It does not solve the general multiple-unknown-mechanism open algorithmic extension. In particular, a pricing certificate valid at one fixed pi is not a uniform certificate over a feasible family of pi values; moving pi can alter both coefficients and support. Additional higher-order outcome rows can also change the pricing energy and invalidate the graph-cut representation unless retained explicitly.

A useful next target is a globally valid outer bound over the complete allowed mediator-coupling family, combined with feasible independent-mechanism lower witnesses. It should consume the current exact fixed-slice oracle while proving the validity of any outer relaxation or branch envelope for every coupling in that branch. Alternating exact component optimizations alone cannot certify a joint global optimum. The newer bipartite-treewidth literature is a possible graph-subproblem backend, with its own decomposition and coverage obligations, rather than evidence that this causal outer problem has already been settled.

## 94. Continue on existing owners: the unknown mediator coupling, 2026-09-07

The continuation reread PR #6033 at `64a5f1891495542612b0b406f0c570ad901f8664`, the merged fixed-coupling fair-cut and interval theorems, the original mediator-marginal predicate, the Boolean Frechet law, and the finite pushforward expectation owner. The cross-author update scan included loning's #5968/#5990 and AlyciaBHZ's #5895/#5602. No conclusion from their engineering or spectral objects is imported into the causal model. The single-compilation specification remains v4.3 at blob `bba1875f68c733b925582ffc81f1344cfce96931`; no finite information score or admission claim is attached to the tests.

The current increment continues the same causal problem after identifying known graph algorithms. It removes the fixed-coupling premise for one substantive subclass: complete mediation, all outcome-response coordinates of success probability one half, and only the two mediator intervention marginals fixed. Both independent disturbance laws are optimized. The prior separator pricing remains applicable to fixed slices, including nonfair slices; the new theorem solves a different outer optimization on the same causal carrier.

Arroyo et al., arXiv:2509.03548v1, already gives multilinear formulations and discusses multiple-intervention and graph-based extensions beyond its single-component column-generation development. Xie and Li, arXiv:2602.14503v1, motivates tractable mediator parameterizations. Choe et al., UAI 2026, PMLR 337:1302-1326, retains objective and data functionals under canonical reduction. Dawid, Humphreys and Musio, Sociological Methods & Research 53(1):28-56 (2024), studies binary complete-mediator chains. The theorem below neither supersedes those broader results nor claims a general nonfair multi-component solution. Targeted searches did not establish priority for this exact finite causal formula; the disaggregation, Frechet, cut and subset-sum ingredients are established mathematics.

## 95. Exact lifting of a coarse coupling to the original probability laws

`FiniteCouplingPushforwardLift.lean` supplies the original-carrier attainment obligation. Let alpha on X and beta on Y be normalized rational laws, let f:X->A and g:Y->B be finite readouts, and let gamma on A times B have the actual pushforward marginals a=f_*alpha and b=g_*beta. Define

```text
pi(x,y) = gamma(f(x),g(y)) * alpha(x)/a(f(x)) * beta(y)/b(g(y)).
```

The source proves normalization, nonnegativity, every original X and Y marginal, and equality of expectations for every function of (f(x),g(y)) with its expectation under gamma. The output uses the existing FiniteResponseLaw and linearObjective, not a parallel coupling semantics.

No positive-fiber premise is imposed. If a fiber has zero mass, finite nonnegativity forces every original atom there to have zero mass; compatibility forces every incident coarse coupling cell to vanish. The proof treats these cases before cancelling denominators. Total rational division at zero is therefore harmless here, rather than being mistaken for a conditional probability at a null event.

The same lift is chosen before the paired-readout query. It preserves all such queries, including every coarse cell. It does not preserve arbitrary original cross-coordinate restrictions that were not represented by the coarse plan. For the new mediation theorem all mediator-pair couplings with the given original marginals are allowed, so this explicit lift is admissible.

## 96. Full identified interval when the fair outcome law and mediator coupling are both unknown

Retain the original equations `M=f_M(A,U_M)`, `Y=f_Y(M,U_Y)` and independent U_M,U_Y. Let alpha and beta be the fixed rational laws of M_0 and M_1. The full coupling pi of (M_0,M_1) is unknown. The outcome disturbance carries one complete table y:M->Bool, also with unknown law nu, subject to P_nu(Y_m=1)=1/2 for every original mediator value. Fairness here denotes that probability, not an algorithmic fairness criterion.

For a Boolean partition y, write

```text
W(y) = sum_(m:y_m=1) [alpha(m)+beta(m)],
S(y) = 1-abs(W(y)-1).
```

`UnknownCouplingFairMediation.lean` proves the exact rational identified image

```text
{J(pi,nu) : pi has marginals alpha,beta; nu has every coordinate fair}
  = [0, (max_y S(y))/2] intersect Q.
```

Both independent mechanism laws range in the existential statement. A finite maximizing partition is constructed using the existing Finite.exists_max; no optimal plan, fixed coupling or optimal table is supplied as a theorem premise. The query is the existing completeMediatorBenefit, with its previously proved actual response-cell interpretation and no-direct-effect embedding.

For a fixed partition set S, put a=alpha(S) and b=beta(S). Every compatible mediator coupling obeys

```text
Cut_pi(S) <= min(a+b,2-a-b) = 1-abs(a+b-1).
```

The first two bounds follow from the pointwise inequalities `1[y_i!=y_j]<=y_i+y_j` and `1[y_i!=y_j]<=2-y_i-y_j`, then the actual original marginals. This is uniform over the whole unknown-coupling family. The existing fair-cut identity `2J=E_nu[Cut_pi(Y)]` then gives the same global upper bound for every outcome law.

Attainment uses a coarse two-by-two mediator plan. With t=max(0,a+b-1), its cells in order 00,01,10,11 are

```text
(1-a-b+t, b-t, a-t, t).
```

The existing Boolean Frechet construction supplies this maximal-crossing law. The new lift distributes its four masses back to every original mediator state without changing alpha or beta. A fair mixture of the optimizing partition table and its complement supplies the outcome mechanism. The two disturbances are independent by the existing product law. One constructed mediator coupling already realizes every intermediate rational target by the prior fixed-coupling outcome-mixture theorem.

`unknown_coupling_half_iff_partition` further proves

```text
J=1/2 is attainable iff some subset S has alpha(S)+beta(S)=1.
```

This exact criterion concerns only the marginal-only fair model. Additional pair support, rank preservation, outcome-table restrictions, or mixed data constraints can invalidate the constructed lift and must remain explicit in any extension.

## 97. Reuse subset-sum algorithms instead of rebuilding an exponential causal search

The upper endpoint can be written

```text
U = 1/2 - (1/2)*min_S abs(sum_(i in S)(alpha_i+beta_i)-1).
```

Choose a positive common denominator D for the combined weights, so alpha_i+beta_i=a_i/D with nonnegative integers a_i and sum a_i=2D. Complement symmetry reduces closest-to-D to the largest reachable subset total s*<=D. Then U=s*/(2D). Ordinary Bellman reachability computes these totals and a subset witness in O(nD) basic state updates with an appropriate implementation. This is pseudopolynomial: D can be large relative to the bit length of the rational input. Neither a new subset-sum algorithm nor a Lean complexity theorem is asserted.

Bringmann's SODA 2017 work, Koiliaris and Xu's TALG 15(3), Article 40 (2019), and the more recent Sajith preprint *Subset Sum in Near-Linear Pseudopolynomial Time and Polynomial Space*, arXiv:2508.04726 (2025), provide more sophisticated algorithmic owners. Their implementations and complexity proofs are not reproduced here. The executed local program uses ordinary exact integer reachability, then constructs the original coupling and outcome witnesses. Upgrading that backend can preserve the causal result through this exact mathematical interface.

There is also a precise paper-level complexity encoding: given nonnegative integer partition weights a_i with positive total A, set alpha_i=beta_i=a_i/A. The causal ceiling 1/2 is attainable exactly when some subset sums to A/2. The input encoding has polynomial size. This shows why a small-support causal witness does not by itself imply an easy general discovery procedure; no Lean NP-hardness reduction is included.

For alpha=beta uniform on three states, the sharp interval is [0,1/3], even though pi is no longer fixed to the earlier directed cycle. On five uniform states the upper endpoint is 2/5. At n uniform states the paper formula gives 1/2 for even n and (n-1)/(2n) for odd n. For alpha=(4/5,1/5), beta=(7/10,3/10), the upper value is 1/4, attained by pi=((1/2,3/10),(1/5,0)) and the fair outcome mixture of 01 and 10. These are exact instances, not effects estimated from real data.

## 98. Paper continuation: a uniform nonfair-kernel envelope

The following extension is a paper derivation with exact finite diagnostics, not an additional Lean theorem in this increment. Write U(r) for the upper benefit optimum with the same mediator marginals alpha,beta and arbitrary prescribed outcome means r_i in [0,1]. Put w_i=alpha_i+beta_i and d_i=beta_i-alpha_i. For any two prescribed mean vectors r,s,

```text
abs(U(s)-U(r) - (1/2)*sum_i d_i*(s_i-r_i))
  <= (1/2)*sum_i w_i*abs(s_i-r_i).
```

To prove this, transform any complete outcome law with means r into one with means s by local monotone bit flips. When s_i>r_i, flip a zero to one with probability (s_i-r_i)/(1-r_i); when s_i<r_i, keep an existing one with probability s_i/r_i. Equal means require no change. The impossible denominator-zero cases never occur in the corresponding strict branches. The construction uses extra randomness inside the outcome disturbance, independent of the mediator disturbance. It preserves arbitrary original table dependence except where the chosen local channels modify it, and each coordinate changes with probability exactly abs(s_i-r_i).

For any fixed compatible pi, a cut edge can change only when at least one endpoint changes. Consequently the absolute expected-cut change is at most sum_i w_i*abs(s_i-r_i). The existing full cut identity retains the exact mean-drift change sum_i d_i*(s_i-r_i). Dividing by two gives the displayed bound for the two constructed models. Applying the construction in both directions and maximizing over all original couplings yields the optimum bound. Finite rational bilinear optima exist at pairs of rational polytope vertices; no numerical limiting argument is needed for this paper derivation.

Taking r_i=1/2 gives a globally valid upper envelope around the new exact endpoint, and transforming its attaining outcome law gives a feasible lower witness for U(s). If every abs(s_i-1/2)<=epsilon, the error radius is at most epsilon because sum_i w_i=2. The exact drift term must be retained. This is a deterministic model-family sensitivity bound, not a confidence interval or an exact solution for every nonfair kernel. Extra outcome restrictions may be destroyed by local flips, so the construction is restricted to the stated marginal-only family.

## 99. Executed checks and formalization status

The two new Lean sources contain 442 lines and ten named public declarations. Their two Scribe sources cover all ten declarations and the explicit formulas. Source/logic review and lexical checks were performed. No Lean/Lake or dotnet executable is available, so new elaboration, kernel acceptance, transitive axiom reports and Scribe compilation were not obtained. No new axiom, sorry, admit or native_decide was introduced. These source checks do not substitute for a compiler result.

The seed-20260907 exact diagnostic passed 120 coarse-coupling lifts, 480 arbitrary paired-readout query comparisons, 2032 original-law partition witnesses, 56 whole-partition maxima, 280 interior target constructions and 224 additional global-bound comparisons. For 24 cases of one to three mediator states, it enumerated all vertices of both original polytopes and checked all 646 vertex pairs of the actual bilinear objective. Their global extrema agreed with the new formula. The two probability factors remain separate in that check; a convexified joint latent law was not substituted. Two incompatible coarse plans were rejected. Null fibers and zero-probability original states were included.

An 80-state rational example with combined-weight denominator D=2029 used integer reachable totals, not its 2^80 canonical outcome columns. It found an exact half partition and constructed an attaining coupling with 3198 positive cells and an outcome law supported on two complementary tables. The reachable-state count was 2018. These are seeded synthetic correctness results, not a published-data benchmark or speedup claim. No numeric LP or eigensolver is used in this diagnostic; SymPy only computes exact rational basis inverses for the small full-polytope comparisons.

A separate seed-20260908 diagnostic for Section 98 passed 80 explicit marginal transformations, 240 coordinate mismatch equalities, 80 drift-corrected objective bounds and 80 constructed nonfair-witness/uniform-upper comparisons, including zero and one target means. That paper continuation has no new Lean acceptance status. Both diagnostic programs are second implementations by the same authoring assistant, not independent-author review or extracted Lean. Main source SHA-256: `b7fb6555468aeeac02007c429286e35fb7d69c0e72dcf7aba45c117221550830`; sensitivity diagnostic SHA-256: `b1e78ae103da198bfbcf5c4231dd2e22d3ee7a46d7e82f110240457eb14f7862`.

This increment solves the fair marginal-only unknown-coupling subclass at the mathematical/proof-source level and derives a paper uniform neighborhood bound. The general nonfair outer optimum, retained mixed data rows, certified subset-sum computation and joint global methods beyond this subclass remain research obligations on the same mediator program. The new result builds on known methods without treating their existence as a reason to leave the domain.
