This increment solves the fair marginal-only unknown-coupling subclass at the mathematical/proof-source level and derives a paper uniform neighborhood bound. The general nonfair outer optimum, retained mixed data rows, certified subset-sum computation and joint global methods beyond this subclass remain research obligations on the same mediator program. The new result builds on known methods without treating their existence as a reason to leave the domain.

## 100. From the fair anchor to arbitrary outcome kernels, 2026-09-07

This continuation starts from PR #6033 at `b6dd5159977b62fc9bc1932fe0d0d8bcf6cf3c29`. It reread the actual finite conditional-table realization, product/pushforward expectation identities, full complete-mediation cut identity, original marginal predicate and unknown-coupling partition theorem. The v4.3 specification was reread at blob `bba1875f68c733b925582ffc81f1344cfce96931`. The current cross-author scan included loning's #5942/#5857/#3328 and AlyciaBHZ's updated #5602, at PR-description level. Those engineering, spectral and earlier theory results supply no causal theorem; no independent replay of them is claimed. A scoped search for an existing outcome-marginal perturbation owner returned no matching implementation.

The direct methodological reference is Eckstein and Nutz, *Quantitative Stability of Regularized Optimal Transport and Convergence of Sinkhorn's Algorithm*, SIAM Journal on Mathematical Analysis 54(6):5922-5948 (2022), DOI 10.1137/21M145505X, arXiv:2110.06798v3. Its shadow construction transfers a coupling to perturbed marginals and supports value-stability analysis. The present finite rational construction uses this established principle and elementary optimal Bernoulli mismatch. The entropic optimizer and Sinkhorn convergence results are not imported as theorems about a nonconvex causal family.

The current arXiv records checked for Arroyo et al., arXiv:2509.03548, and Xie and Li, arXiv:2602.14503, still list v1. Their multi-mechanism and tractable mediator-bound questions remain the scientific target. This increment completes the paper-only marginal transformation from Section 98 and improves its envelope. It supplies a feasible original model and a uniform bound over the entire unknown mediator-coupling family, not an exact formula for every nonfair optimum. No mathematical priority claim is made for shadows, coupling inequalities, or the specific causal improvement without further prior-art assessment.

## 101. Exact transport of an entire dependent Boolean response table

`BooleanOutcomeMarginalTransport.lean` starts from an arbitrary existing `FiniteResponseLaw (M -> Bool)`. Let its coordinate means be r_i, and let s_i be any rational target means in [0,1]. For one original bit b, define the conditional target-success rate

```text
r<=s: rate(false)=(s-r)/(1-r), rate(true)=1;
r>s:  rate(false)=0,           rate(true)=s/r.
```

The source proves rate bounds, exact target means, and exact coordinate mismatch abs(s-r). It includes r,s equal to zero or one. Division at r=s=1 occurs only in the unused original-zero branch; the expectation proof handles that case separately. No division at a positive-probability null event is treated as a conditional probability.

The existing `finite_conditional_table_realization` realizes all transition rows indexed by M times Bool in one auxiliary random table. Take its product with the entire original outcome law, then push forward to the pair of original and transformed tables. The theorem `exists_exact_marginal_transport` proves simultaneously:

```text
E_joint[f(old)] = E_original[f] for every rational whole-table query f,
E_joint[new_i] = s_i for every i,
P_joint(old_i != new_i) = abs(s_i-r_i) for every i.
```

The first equality preserves the complete old distribution, not only its marginal vector. Old coordinates may have arbitrary dependence. The transformed law can have different dependence, so extra cross-coordinate constraints are not automatically preserved. Independent auxiliary entries are one possible realization of the required transition marginals, not an independence assumption on potential outcomes. All auxiliary randomness belongs to the outcome disturbance and can remain independent of the mediator disturbance.

## 102. Sharper sensitivity weights exclude forced diagonal mass

Write alpha,beta for the two original mediator marginal laws, with coupling pi allowed to vary over all laws having those marginals. Self-pairs (i,i) contribute no cut change. The off-diagonal mass incident at i is the singleton cut `Cut_pi({i})`. The previously proved partition bound yields

```text
Cut_pi({i}) <= c_i,
c_i = 1-abs(alpha_i+beta_i-1)
    = min(alpha_i+beta_i, 2-alpha_i-beta_i).
```

This improves the earlier weight alpha_i+beta_i whenever their sum exceeds one. It is also valid for a one-state mediator, where c_i=0. `CompleteMediatorKernelStability.lean` compares old and new cut indicators pointwise: an off-diagonal edge can change only when at least one endpoint changes. Finite sum interchange and the exact mismatch probabilities then give a uniform cut-expectation difference bound with weights c_i.

Retain the exact directed mean drift

```text
D(r,s) = (1/2)*sum_i (beta_i-alpha_i)*(s_i-r_i),
R(r,s) = (1/2)*sum_i c_i*abs(s_i-r_i).
```

The existing complete-mediation identity is rewritten using the original marginal rows as `2J=E[Cut]+sum_i(beta_i-alpha_i)*r_i`. The main theorem `exists_uniform_kernel_transport` constructs one transformed outcome law nu_s before quantifying over all pi. It has the target means and satisfies

```text
abs(J(pi,nu_s)-J(pi,nu_r)-D(r,s)) <= R(r,s)
```

for every pi with the original alpha,beta. The transformation never changes pi. Thus the two source mechanisms remain independent in every compared model, without convexifying their joint law. The construction is uniform over the whole unknown-coupling family; it is not a certificate valid only at a tested slice.

`NonfairMediationEnclosure.transfer_kernel_upper_bound` transports any valid source-family upper bound into a bound on the target family. When actual greatest values for two kernel families are supplied, `attained_kernel_optima_stability` proves `abs(U(s)-U(r)-D(r,s))<=R(r,s)`. This corollary does not establish general nonfair optimizer existence. The principal enclosure in the next section does not require such a premise.

The source also proves 0<=c_i<=alpha_i+beta_i. Therefore a coordinatewise error abs(s_i-r_i)<=epsilon implies R(r,s)<=epsilon, since the combined mediator mass totals two. There is no factor equal to the number of mediator states.

## 103. A one-sided improvement over the previous symmetric envelope

Let F be the exact fair-kernel optimum from `unknown_coupling_fair_interval`:

```text
F = (1/2)*max_S [1-abs(alpha(S)+beta(S)-1)].
```

For every deterministic outcome table and every compatible mediator coupling, the cut is bounded by 2F. This statement itself does not require fair means. Hence every nonfair outcome law with means s satisfies

```text
J(pi,nu_s) <= F+D(1/2,s).
```

The full signed drift remains present, while no positive transport radius is added to this upper side. `partition_anchor_upper` proves this directly from the original expected-cut identity. In particular, the drift-centered optimum has a global maximum at the fair kernel, although the uncentered optimum can increase or decrease with s.

For the lower side, the earlier fair theorem supplies an actual maximizing partition, a mediator coupling pi_star with all original marginals, and a fair outcome law nu_star. Apply the new transport to nu_star while leaving pi_star fixed. The resulting nonfair model has all required means and value at least F+D-R. The main unconditional theorem `nonfair_kernel_global_enclosure` thus proves

```text
exists an actual feasible independent-mechanism pair with value J_witness >= F+D-R;
every feasible independent-mechanism pair has value <= F+D.
```

The witness itself also obeys the global upper bound. Consequently its certified optimality gap is at most R, rather than the former two-sided width 2R. Expressed in terms of an attained nonfair optimum when one is used, `0<=F+D-U(s)<=R`. The interval brackets the optimal upper endpoint. It is not asserted to be the complete identified range of the benefit query; smaller benefit values can also be feasible.

This closes the proof-source marginal-transport obligation and gives a quantitative approximation guarantee once the fair partition is computed. It does not replace general nonfair optimization, mixed observational/interventional constraints or additional response-support assumptions. The principal theorem obtains the fair optimum through finite existence; a kernel-verified efficient subset-sum producer remains separate.

## 104. Exact examples, coefficient sharpness and executed evidence

For alpha=(4/5,1/5), beta=(7/10,3/10), and target means s=(3/5,1/2), the fair optimum is F=1/4. The drift is -1/200. The new weights are (1/2,1/2), giving R=1/40; the previous combined-mass weights (3/2,1/2) give radius 3/40. The old symmetric envelope is [17/100,8/25]. The new envelope is [11/50,49/200]. An explicit original mediator law is pi=((1/2,3/10),(1/5,0)); outcome tables 01,10,11 receive masses 2/5,1/2,1/10. This has exactly the target means and benefit 11/50. Exact enumeration of all original polytope vertex pairs confirms that 11/50 is the true optimum in this example. The upper certificate remains 49/200; equality with that upper bound is not claimed.

There is a useful paper-level sharpness fact for each coordinate coefficient. Set all other outcome means to zero and vary only mean i from zero to t. Nonnegativity forces every other response coordinate to be zero almost surely. The optimal benefit is then `t*(beta_i-max(0,alpha_i+beta_i-1))`, attained by a mediator coupling minimizing its (i,i) cell. Subtracting drift `t*(beta_i-alpha_i)/2` gives exactly `t*c_i/2`. Therefore no uniformly smaller coefficient than c_i/2 works for arbitrary one-coordinate changes in this model family. This is an exact diagnostic and paper deduction, not another named Lean theorem or a claim that the multi-coordinate radius is always attained.

The final diagnostic uses integer seed 20260909. It passed 441 scalar transition cases, 80 joint table transports with full old-law checks, 240 coordinate identities, 240 fixed-coupling drift bounds, 760 singleton-weight/one-coordinate sharpness checks and 80 fair-anchor constructions. Forty-eight exact nonfair optima for one to three mediator states were computed by enumerating all vertices of both original polytopes and all 1502 resulting vertex pairs. The 24 pairs of these optima obeyed the drift-corrected stability bound. Nineteen anchor cases strictly improved the earlier radius. Four negative controls rejected invalid target probabilities, destruction of old-law dependence and an omitted-drift bound. These are synthetic finite checks by the authoring assistant, not independent-author review or a benchmark on observed scientific data.

An 80-state instance was solved without enumerating its 2^80 outcome columns. Its fair partition used combined-weight denominator 1596 and 1589 reachable totals. The original fair outcome support has two tables; a common-threshold realization of the target transition marginals uses 22 outcome tables. The constructed original mediator coupling has 3182 positive cells. Its nonfair witness value is 37627/79800, the global upper bound is 332/665, and the exact gap is 2213/79800, equal to its computed radius. The shared-threshold diagnostic and the proof's finite table realization satisfy the same transition-marginal contract; no extracted-code equivalence is claimed.

The diagnostic source SHA-256 is `11ab76e0347b5395ae96f49d454828f7b58ecfb407d1e6cb9185b98d2782db9b`. The final result SHA-256 is `37d9baf3d4acc4a2a08396663fbbce6e356cc80e6c44d5515dec9ce73170a752`. A final complete replay reproduced the first result byte for byte. It reads the previous exact vertex/coupling backend whose SHA-256 is `b7fb6555468aeeac02007c429286e35fb7d69c0e72dcf7aba45c117221550830`; no numerical LP solver is used. SymPy supplies exact rational basis inverses in the small full-polytope comparisons.

## 105. Source status and remaining same-domain work

The three new Lean modules have 629 lines and 18 named public declarations. Three matching Scribe sources use the pinned supported `StatementSource.FromLean()` interface, with all 18 handles bound to actual statements. Source and mathematical review, lexical delimiter checks and exact rational replays were performed. Lean, Lake and dotnet are absent in this runtime: no new elaboration, kernel acceptance, executed transitive axiom report or Scribe emission is claimed. No new axiom, sorry, admit or native_decide command is present. The scripts remain candidate formalizations pending the pinned compiler.

The mathematical next step is to use these uniform original-family bounds as certified envelopes for nonfair global search or to identify additional exact nonfair subclasses, while retaining every data constraint. A small radius has a precise optimality-gap meaning; it does not establish a solution for arbitrary kernels or permit replacing unknown mediator couplings by independent marginal products. Outcome restrictions that are not preserved by the transport require a different admissible construction. The new work remains on the same causal identification program and reuses classical coupling methods rather than presenting their existence as a reason to change domains.
