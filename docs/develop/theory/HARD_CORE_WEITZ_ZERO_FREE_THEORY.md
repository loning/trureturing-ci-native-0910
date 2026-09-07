# Hard-core Weitz trees: geometric memory and certified ordering

## 1. Target and current result

The research target is a uniform complex zero-free neighborhood for the
independence polynomials of all finite induced square-grid subgraphs, extending
the interval currently obtained from the Weitz-tree connective-constant bound
2.429. Chen, Shao and Shi [1, Appendix A.6] give the threshold 2.538 and explicitly
identify improved Weitz growth bounds as a possible improvement mechanism.

This first result resolves a smaller, precise optimization question within that
route: how much can adaptive neighbor ordering improve the spatial radius-three
blocked-memory upper approximation? With the model defined below, let C_n^pi be
its root descendant count under a controller pi, allowed to depend on the entire
path history. Put

\[
 g(pi)=\limsup_{n\to\infty}(C_n^{pi})^{1/n},\qquad
 g_3^*=\inf_{pi}g(pi).
\]

The exact certificate and the induction below establish, at the mathematical
and independently replayed integer-certificate level,

\[
 \boxed{2.5205\le g_3^*\le2.5206,\qquad g(\mathrm{SRL})\ge2.5209.}
\]

In particular, an explicit adaptive policy strictly improves fixed SRL in this
same memory model, while **every** ordering on this model is still above 2.429.
The certificate therefore both supplies a constructive improvement and identifies
which resource must change before this route can improve the global threshold.
No improved global zero-free constant is asserted.

The four accompanying Lean modules contain proof scripts for the finite
certificates, the all-depth integer inequalities, and a genuine finite-domain
simulation. They have been logically reviewed but not compiled in the authoring
runtime. The asymptotic rate notation in this section is a paper consequence of
the all-depth inequalities, not a separately elaborated Lean limsup theorem.

This is the first dedicated square-grid hard-core research volume. Earlier
repository hard-core transfer discussions concern one-dimensional forbidden
adjacency and RH-related constructions; their determinant theorems do not
supply the two-dimensional deletion-tree estimates needed here.

## 2. Literature interface and provenance

Sinclair, Srivastava, Stefankovic and Yin [2, Appendix A] allow an ordering that
depends on the complete root-to-current path. Their straight-right-left ordering
and finite-cycle-memory construction give 2.433 at cycle cutoff 26 and 2.429 at
cycle cutoff 30. The PDF appendix and its boundary-condition convention were
visually checked. Adaptive ordering itself is therefore prior art.

The radius used here is a Manhattan **spatial radius** for retained deleted
vertices. It is not the paper's cycle-length cutoff. Comparing the two numerical
bounds without distinguishing these state semantics would be misleading.

The positive-vector certificate method is also standard. The proposed research
increment is the concrete, fully specified radius-three ordering separation,
the narrow all-controller bracket, and its actual geometric simulation. No
first-formalization priority or literature-wide novelty claim has been established.

The 2026 zero-free theorem uses a family-uniform finite-depth growth quantity,
including counts up to depth k and a supremum over roots and finite domains.
A root-only spectral fit with a domain-dependent uncontrolled prefactor would
not supply that input. Our finite-domain upper count keeps a fixed explicit
prefactor. Its formal connection to partition functions and the complex block
contraction theorem remains to be proved.

Repository source audit began at dev cdf5cd4f86a59704197979f49cc40c5e0664ecae;
the delivery branch starts from refreshed dev
b89d56d0c9a433f9b714821d2bb1779066c59ede. Searches for Weitz and
independencePolynomial found no existing owner in the searched repository/code
index. The existing RationalFarkas owner was read; it proves rational linear
infeasibility, not the controlled branching or geometric simulation statements.

Cross-author audit included loning's merged PR #5326: behavioral Hankel
minimality is distinct from determinant preservation. Here, likewise, a smaller
linear realization cannot replace a geometric path-counting automaton without
an exact semantic transport. PR #5562 supplies symmetric complex quadratic row
bounds, whose symmetry assumptions do not apply to directed branching. PR #5405
reinforces the distinction between finite sample success and all-input coverage.
The present modules therefore use an explicit all-depth induction and full
geometric closure, rather than an unproved compression or sampled coverage premise.

## 3. Actual ordered deletion and the memory approximation

Coordinates are relative to an east-facing incoming edge. The parent vertex
(-1,0) has already been removed. The three possible next directions are

\[
 S=(1,0),\qquad R=(0,-1),\qquad L=(0,1).
\]

An action a is one of the six permutations SRL, SLR, RSL, RLS, LSR, LRS.
For a chosen direction d, let E(a,d) be the directions preceding d in that
permutation, and put

\[
 K(a,d)=\{(0,0)\}\cup E(a,d).
\]

The coordinate normalization is

\[
 T_S(x,y)=(x-1,y),\quad T_R(x,y)=(-y-1,x),\quad
 T_L(x,y)=(y-1,-x).
\]

Each map is injective and sends the old origin to the new parent (-1,0).
For an actual finite available vertex set V, taking child d is allowed exactly
when d belongs to V, and the new available set is

\[
 V'=T_d(V\setminus K(a,d)).
\]

This is the ordered vertex-deletion expansion used in the hard-core ratio
recursion. The source's orderedCount counts its three-direction paths. It
requires no claimed relation between a supplied count and a grid: availability
is tested against the actual finite set of integer vertices.

For a retained blocked set F and radius r define

\[
 M_r(F,a,d)=T_d(F\cup K(a,d))\cap
 \{(x,y):|x|+|y|\le r\}.
\]

A memory child is allowed whenever d is absent from F. Blockers forgotten by
truncation do not reappear unless generated again by subsequent deletions.
This creates an upper approximation, including some geometrically impossible
long paths.

### Geometric simulation lemma

If V and F are disjoint, then V' and M_r(F,a,d) are disjoint.
Indeed, a point in both sets would have preimages u in V minus K and v in F
union K. Injectivity gives u=v. Membership in F contradicts initial disjointness;
membership in K contradicts u being outside K. Truncation only removes blockers.

Consequently, every child available in V is allowed by F. Induction over depth
gives actual ordered-domain count no greater than memory count, provided the
finite representation has all required geometric successors. The radius-three
closure theorem checks exactly that obligation.

## 4. Finite presentation and reproducible construction

Start at F0={(-1,0)}. Close under every allowed move and all six orderings at
radius three. The set-based replay finds 483 distinct reachable masks, verifies
all 8694 state-order-direction cases, and checks that each unblocked successor
has exactly its prescribed geometric mask. Every stored state is reachable when
all actions are available. The selected policy reaches 70 states; fixed SRL
reaches 75. These reachability counts were externally replayed, not separately
asserted as Lean theorem conclusions.

Coordinates are ordered lexicographically within the punctured Manhattan disk,
followed by the origin. The initial code is 64. The data use a lossless packing:
low 19 bits encode the mask; the remaining quotient modulo six encodes the
ordering; its quotient by six indexes one of 55 repeated weight triples.
The expanded radiusThreeRows is the sole owner of masks, three weights and policy.
No transition table, approximate eigenvalue or solver success flag is a premise.
The Lean transition function computes the geometric update and exact lookup.

Candidate discovery used finite-set exploration and numerical nonlinear power
iteration for the Bellman operator

\[
 (Tv)_i=\min_a\sum_{d:\,i\overset{a,d}{\longrightarrow}j}v_j.
\]

The resulting float vector was only a proposal. Lower weights were rounded down,
upper weights rounded up with a floor of one, at scale 10^9. A separate fixed-SRL
vector supplied the third witness. Acceptance uses the exact integer inequalities
below. Numerical convergence or eigenvalue approximation is unnecessary for
certificate validity.

## 5. Integer certificate and proof of the rate bracket

Write w_-(i), w_+(i), w_S(i) for the three integer weights and pi_*(i) for the
selected ordering. Missing children contribute zero, and multiple directions
to the same state retain their multiplicities. The finite certificate checks

\[
\begin{aligned}
0&\le w_-(i)\le10^9, &1&\le w_+(i), &0&\le w_S(i)\le10^9,\\
5041w_-(i)&\le2000\sum_{i\overset{a,d}{\longrightarrow}j}w_-(j)
 &&\text{for every }i,a,\\
5000\sum_{i\overset{\pi_*(i),d}{\longrightarrow}j}w_+(j)&\le12603w_+(i)
 &&\text{for every }i,\\
25209w_S(i)&\le10000\sum_{i\overset{\mathrm{SRL},d}{\longrightarrow}j}w_S(j)
 &&\text{for every }i.
\end{aligned}
\]

All three initial weights are exactly 10^9. These are 2898 all-order lower rows,
483 selected upper rows and 483 fixed lower rows, totaling 3864 row checks.

For a controller pi, count descendants recursively: C_0=1 and C_(n+1) is the
sum of the depth-n child counts. The controller can choose differently at every
history. The lower row holds for whichever action it chooses. Induction gives

\[
 5041^n w_-(i)\le10^9 2000^n C_n^{pi}(i).
\]

At the initial state the cap cancels. The upper row for pi_* similarly gives

\[
 5000^n C_n^{pi_*}(i)\le12603^n w_+(i).
\]

The fixed-order sub-potential gives the third inequality. At the initial state:

\[
\boxed{
(5041/2000)^n\le C_n^{pi},\quad
C_n^{pi_*}\le10^9(12603/5000)^n,\quad
(25209/10000)^n\le C_n^{\mathrm{SRL}}.
}
\]

Taking nth roots and limsup proves the bracket in Section 1. In particular,
no history-dependent ordering on this radius-three approximation has exponential
rate below 2.5205. This is stronger than testing finitely many stationary policies.
It is not an exact formula for g_3^*, and it does not prove that every optimal
policy is stationary.

### Actual finite-domain consequence

For every finite V with (-1,0) absent, let P_n(V) be orderedCount under pi_*.
The geometric simulation and the actual certificate give

\[
 \boxed{5000^nP_n(V)\le10^9 12603^n.}
\]

No matrix-growth or path-coverage hypothesis remains in this concrete endpoint.
Finite holes and irregular boundaries are allowed. A full four-neighbor root
can be handled by summing its at most four parent-deleted child expansions;
this root wrapper and the partition-polynomial identity are not included in the
current Lean endpoint.

**Do not reverse this simulation.** Lower bounds on the relaxed memory tree do
not give lower bounds on the actual square-grid Weitz tree. The memory barrier
restricts this chosen approximation strategy, not the physical critical point.

## 6. What this changes in the next research step

Ordering-only optimization within radius three has at most 0.0001 of room left
below the selected upper certificate. The gap from its certified floor 2.5205
to the published 2.429 target is 0.0915. More solver precision, more policy
iterations or a richer dependence on history cannot close that gap while the
same relaxed branching model is retained.

The next mathematical target is therefore **retained-geometry refinement**.
For r<=R and F contained in G, under the same action and direction,

\[
 M_r(F,a,d)\subseteq M_R(G,a,d).
\]

This follows by monotonicity of union, injective image and nested disks. Coupling
the two explorations under the same history-dependent sequence of actions then
shows that the larger-memory tree has no more paths. This is the next proposed
formal lemma. For independently chosen state policies the actions need not
agree, so monotonicity cannot be asserted without a controller transport.

A scalable implementation should retain deleted vertices associated with
potential loop closures, and seek an exact simulation or action-respecting
bisimulation before merging states. Equality of an approximate Perron weight
is not sufficient for a quotient. The complete all-order state union may be
much larger than the states reachable under a proposed policy, so upper and
lower certificates should use their appropriate, explicitly proved coverage.

Exploratory, unvalidated power iterations for fixed SRL at radii 4,5,6 returned
approximately 2.48260, 2.46329, 2.45139. They motivate retaining more geometry but
are not exact certificates or new global results. They cannot be extrapolated
into a claim that some particular radius must achieve 2.42.

After obtaining a genuine geometry-certified growth bound below 2.429, the next
analytic tasks are the exact partition-function/deletion-tree bridge and the
family-uniform complex block contraction. The sufficient proposed target
mu<=121/50 would imply lambda_c(mu)>51/20 through the standard threshold formula,
but the premise mu<=121/50 is unproved here. No 2.55 zero-free theorem is claimed.

## 7. Formal source map and verification

- BranchingPotential: weighted child sums, history-dependent counts, upper and
  lower all-depth integer induction.
- OrderedGridMemory: actual integer-grid maps, arbitrary-radius disjointness,
  finite-domain path definition and simulation.
- RadiusThreeData: lossless exact certificate data.
- RadiusThreeCertificates: full geometric closure, integer row checks, concrete
  upper, all-controller lower, fixed lower and finite-domain upper endpoints.

All 28 public declarations have paired canonical Scribe source handles using
StatementSource.FromLean. No authored formula replaces a Lean statement.
No information score, sampled analysis arena, catalog admission or sealing
claim is attached to these results. The finite presentation is checked against
the actual geometric blocked-set object. The referenced single-compilation
specification was read at version 4.3, blob
bba1875f68c733b925582ffc81f1344cfce96931.

Reproduce the independent exact research replay from the repository root:

```sh
python research/hard_core_weitz/verify_radius_three.py
```

The verifier reads the Lean-owned integer payload, reconstructs transitions
with integer-coordinate sets, checks all geometry and rows, replays 243 depth
regressions and 81 finite-domain regressions, and rejects six deliberately
corrupted certificates. It uses no discovery cache, NumPy, eigenvalue solver or
stored success JSON. The emitted validation JSON is a recorded output only.
This replay is a separate implementation by the same authoring assistant; it
is not independent-author review and does not check Lean proof terms.

Lean compilation, executed axiom closure and Scribe emission were unavailable
in the authoring runtime. The finite source proofs use decide +kernel, with no
native_decide or external verdict axiom. Those proof scripts have not yet been
executed. Thus the current delivery is a mathematically reviewed and exactly
replayed candidate formalization, not a kernel-admitted truth release.

## References

[1] Yuan Chen, Shuai Shao and Ke Shi. *Zero-Freeness of the Hard-Core Model with
Bounded Connective Constant*. arXiv:2604.02746v1 (2026), especially Definition 1.1,
Theorem 1.2 and Appendix A.6.
https://arxiv.org/html/2604.02746v1

[2] Alistair Sinclair, Piyush Srivastava, Daniel Stefankovic and Yitong Yin.
*Spatial mixing and the connective constant: Optimal bounds*.
arXiv:1410.2595, Appendix A, printed pages 27-28.
https://arxiv.org/abs/1410.2595

[3] Ricardo Restrepo, Jinwoo Shin, Prasad Tetali, Eric Vigoda and Linji Yang.
*Improved mixing condition on the grid for counting and sampling independent
sets*. The connective-constant paper [2] discusses this preceding multi-type
branching-matrix approach. It is prior art for geometry-sensitive tree bounds.

[4] Juan C. Vera, Eric Vigoda and Linji Yang. *Improved Bounds on the Phase
Transition for the Hard-Core Model in 2-Dimensions*. arXiv:1306.0431.
Its limitations on strong spatial mixing of full Weitz trees must be respected
when considering how far ordering-based refinements can ultimately go.
https://arxiv.org/abs/1306.0431


## 8. Retained geometry and explicit controller transport

The continuation starts from the preceding radius-three delivery. The latest
read of dev is b89d56d0c9a433f9b714821d2bb1779066c59ede. The original sources
remain unchanged. MemoryRefinement now proves the radius/blocker inclusion
statement proposed in Section 6 and its all-depth counting consequences.

There is an important distinction between inclusion and projection. Running
radius three and radius four from the same parent mask, with fixed SRL ordering
and direction history S,S,R,R, gives a point (2,-1) present in the fine memory
but absent from the coarse memory. That point is inside the radius-three disk:
it had previously left the coarse disk and been forgotten. The independent
integer-set replay checks the four steps and both memberships. Thus the fine
state cannot simply be intersected with the coarse disk to recover the actual
coarse controller state. This example is a replayed diagnostic, not a separately
elaborated Lean theorem.

For a policy depending only on the complete direction history, both models
choose the same action automatically. The theorem history_count_antitone proves
that r<=R and F contained in G imply C_R(n,G)<=C_r(n,F) for every depth and history.
For a policy depending on its coarse state as well, coupledStep retains the pair
(F,G), reads the policy at F, decides availability at G, and updates both with
the same action. The theorem coupled_count_le_coarse proves the same domination
for every such controller. No state-reconstruction hypothesis is used.

The exact fixed_presentation_count theorem separately transfers a finite table
to actual geometric sets by direction-preserving transition equality. Only the
selected order requires closure. This avoids creating states for unused actions
when a single-policy upper certificate is sufficient. Direction multiplicities
are preserved even when two directions have equal successor states.

## 9. Finite propagation and exact complete prefixes

Let rho(p)=|p_x|+|p_y|. The actual recentering maps satisfy

\[
 \rho(p)\le\rho(T_d p)+1.
\]

Consequently, if two blocker sets agree inside radius n+1, their updates agree
inside radius n when both retention radii are at least n. A point outside that
larger disk cannot enter the smaller disk in one step. This is the local
agreement theorem memoryStep_agreeWithin in MemoryLightCone.

Define completeStep using the same deletion/recentering operation without the
radius filter. For a common history-based ordering, finite_horizon_exact proves

\[
 \boxed{r\ge n,\quad F\cap B_n=G\cap B_n
 \quad\Longrightarrow\quad C_r(n,F)=C_\infty(n,G).}
\]

There is no upper bound on the complete initial blocker set's size. At each
induction step, availability agrees because the three candidate directions have
radius one, and child blockers agree on the remaining smaller light cone.
This result alone is a finite-depth statement. Uniform control over unbounded
depth is supplied by the next theorem, rather than assumed by exchanging limits.

## 10. Uniform block bounds and completeness of fixed-order memory

Fix one relative ordering a. Write P={(-1,0)}, c_k=C_infinity(k,P), and
c_n^(r)=C_r(n,P). Every allowed update retains the parent for r>=1. Any descendant
blocker set therefore contains P, and its continuation count is bounded above
by the count after resetting to P under the same fixed relative ordering.
This reset domination would require an additional controller argument for a
state-dependent policy; the theorem in this section fixes a.

MemoryBlockBounds.fixed_order_block_bound proves, for every r>=1, k<=r,
q,s>=0, every starting history and every finite F containing P,

\[
 \boxed{ C_r(qk+s,F)\le c_k^{\,q}\,3^s. }
\]

Proof: at depth k, reset domination followed by finite_horizon_exact bounds the
number of descendants by the actual complete prefix c_k. Every child at depth k
again contains P. Induct on the number q of full blocks; the remaining s steps
have at most 3^s descendants. This is an all-depth inequality with a uniform
coefficient for all eligible initial blocker sets, not an assumed spectral bound.
The companion complete_count_le_memory proves c_n<=c_n^(r) for every n and r.

### Paper consequence: the hierarchy reaches the complete growth rate

Define mu_infinity=limsup c_n^(1/n) and mu_r=limsup (c_n^(r))^(1/n).
For each fixed ordering, the following follows from the formal-source integer
inequalities by ordinary real limit arguments:

\[
 \boxed{
 \mu_\infty\le\mu_R\le\mu_r\quad(1\le r\le R),\qquad
 \inf_{r\ge1}\mu_r=\mu_\infty=\inf_{k\ge1}c_k^{1/k}.
 }
\]

Here are the quantifiers and proof. For a fixed k>=1 and any r>=k, write
n=qk+s with 0<=s<k. The block inequality gives
mu_r<=c_k^(1/k), since the factor 3^s is uniformly bounded as n grows.
Complete domination gives mu_infinity<=mu_r. Hence
mu_infinity<=inf_k c_k^(1/k). The reverse inequality follows because the infimum
of a sequence is at most its limsup. For every epsilon>0 choose one k with
c_k^(1/k)<mu_infinity+epsilon; then every r>=k satisfies
mu_infinity<=mu_r<mu_infinity+epsilon. Monotonicity comes from the common-order
refinement theorem. The complete all-straight path ensures c_k>=1, and all
counts are bounded by 3^k, so no infinite or zero-root pathology is used.

Thus larger fixed-order geometric memories converge in growth rate to the
complete ordered-deletion process. This establishes mathematical completeness
of this approximation hierarchy. It supplies neither a convergence rate nor a
particular finite radius attaining 2.429 or 2.42. It also makes no assertion that
optimizing over arbitrary controllers commutes with either limit. The limsup,
infimum and epsilon argument are proved here on paper; no separate Lean limit
declaration is claimed.

### Paper consequence: strict targets admit finite rational potentials

Suppose alpha is positive rational and c_k<alpha^k. For r>=k and r>=1, let
B_r act by summing a function over the selected-order children, and define

\[
 W(F)=\sum_{j=0}^{k-1}\alpha^{k-1-j}C_r(j,F).
\]

For every eligible F containing P, W(F)>0 and telescoping gives

\[
 B_rW(F)-\alpha W(F)=C_r(k,F)-\alpha^k
 \le c_k-\alpha^k<0.
\]

The radius-r universe of blocker sets is finite and closed under allowed steps.
All these potential values are rational, so a common denominator gives a finite
integer certificate. The hierarchy result guarantees such a k for each strict
rational target alpha>mu_infinity. This is a paper existence construction; it
is not a new executed large-radius certificate or a polynomial-time algorithm.
The potentially very large prefix and state enumeration costs remain real.

## 11. A concrete radius-four certificate and universal finite separation

The fixed-SRL radius-four closure has 851 distinct geometric states, verified
reachable from P by an independent set-based traversal. RadiusFourData contains
the exact masks and a positive integer weight w with

\[
 1\le w_i\le20000,\qquad w_0=20000,\qquad
 10000\sum_{i\longrightarrow j}w_j\le24827w_i.
\]

There are 307 distinct weight values. The data share these values losslessly;
no geometric states are identified. The 41 mask bits refer to lexicographically
ordered points of the punctured Manhattan disk followed by the origin. All
2553 state-direction cases reconstruct their successors from memoryStep itself,
and all 851 row inequalities pass exact integer replay. Minimum row slack is
zero, which is permitted for this non-strict upper certificate.

Candidate weights came from a numerical proposal, rescaling and monotone
integer ceiling updates until every row passed. Only the final integer rows
and geometric closure are mathematical evidence. No eigensolver output is
assumed in the theorem. Unused actions are outside the finite table's coverage;
the raw geometric transition remains defined for all six actions.

The existing super-potential induction and exact presentation transport give

\[
 \boxed{10000^n c_n^{(4)}\le20000\,24827^n,\qquad
 \mu_4(\mathrm{SRL})\le2.4827.}
\]

The same bound holds for the actual ordered deletion count of every finite
integer-grid domain with its parent absent. That endpoint uses raw geometry and
real domain membership; it never discards a real child because a lookup failed.
The theorem radiusFour_finite_domain_upper has no supplied growth or finite-table
coverage hypothesis.

A stronger finite comparison consumes the previous radius-three lower theorem.
The exact integer comparison

\[
 20000\,24827^{700}<25205^{700}
\]

combines with 5041^n<=2000^n C_n^pi to prove

\[
 \boxed{c_{700}^{(4,\mathrm{SRL})}<C_{700}^{(3,\pi)}
 \quad\text{for every history-dependent radius-three controller }\pi.}
\]

This is the public theorem radiusFour_beats_every_radiusThree_controller.
The depth 700 is a sufficient choice, not a minimality assertion. The conclusion
compares the two actual relaxed geometric models. It does not transfer their
lower bound to the physical grid. The new upper rate remains above the published
2.429, so no global zero-free improvement is claimed.

## 12. Literature-guided continuation beyond scalar growth

The checked version of Chen, Shao and Shi [1] remains v1 of 3 April 2026.
Its family-uniform fixed-depth definition counts all depths up to k and takes
suprema over roots and finite domains. Our complete-process and finite-domain
count theorems still require a partition-polynomial/deletion-tree identification,
the four-neighbor root wrapper, and this uniform analytic interface before any
complex zero-free conclusion can be claimed.

Vera, Vigoda and Yang [4, Section 5, version 2] already use type-dependent
piecewise-linear message functions and linear programming to prove stronger
spatial-mixing conditions than scalar branching estimates alone. Their
criterion motivates the next certificate target on our actual geometric types:

\[
 x_i=(1+\lambda\prod_jx_j)^{-1},\qquad
 (1-x_i)\sum_j\Psi_{t_j}(x_j)<\Psi_i(x_i).
\]

For positive decreasing affine pieces Psi_i(x)=b_i-a_i*x on intervals [X_i,Y_i],
a sufficient row is

\[
 (1-X_i)\sum_j(b_{t_j}-a_{t_j}X_{t_j})
 < b_i-a_iY_i.
\]

Only interval tuples consistent with the actual parent recursion are relevant.
Every required child-pruning/boundary configuration must be included, and strict
positivity of all message pieces must be checked. A fitted derivative at one
fixed point does not certify strong spatial mixing. The piecewise-affine method
and this sufficient inequality are prior art from [4], not a new method claimed
by this repository.

For the zero-free target, real contraction must additionally be extended to a
common complex neighborhood under valid regularity and denominator conditions.
Piecewise real messages do not themselves provide a holomorphic coordinate
change. One must either construct a suitable smooth/analytic approximation with
a retained strict margin or apply an independently proved complex-extension
theorem with all of its hypotheses discharged. No such nonlinear message
certificate or complex extension has been constructed in this increment.

The next substantive target is therefore a geometry-specific rational
contraction certificate at a parameter strictly above 2.538, or a stronger
certified geometric growth bound below 2.429. Larger memory is now justified by
a complete fixed-order hierarchy, while the type-dependent route can use the
full geometry rather than reducing all types to a single growth constant.
Neither target is promised by the present radius-four certificate.

Cross-author comparison informed this separation. Loning's #5326 distinguishes
behavioral compression from preservation of the mathematical quantity consumed
downstream. The newer #5882 supplies an explicit determinant-loss family even
under small balanced behavior error. Our shared-weight packing accordingly
preserves every mask and direction; it is not a behavioral quotient. The recent
#5602 actual prolate-model comparison likewise emphasizes deriving the relation
between concrete objects before transporting estimates. These PRs were read as
research context, not imported as proofs of hard-core facts.

## 13. Source and verification status of this continuation

The five new Lean owners are MemoryRefinement, MemoryLightCone,
MemoryBlockBounds, RadiusFourData and RadiusFourCertificates. They have 24
explicitly named public declarations with 24 matching canonical Scribe handles.
The prior 28 declarations are unchanged. The general induction and geometry
proofs reuse the preceding owners; no parallel pathCount or memoryStep is created.

The final independent replay reads the actual Lean-owned radius-four payload.
It checks 2553 geometric transitions, 851 integer rows, all 851 states through
101 depths (85951 inequalities), 1875 finite-propagation cases, 1080 memory
inclusions, 120 controller comparisons, 126 light-cone equalities, 558 block
bounds and 90 actual-domain cases. It also checks the depth-700 integer
comparison. Four malformed certificates are rejected; removing the necessary
radius-versus-depth guard is witnessed by a depth-three mismatch. The S,S,R,R
projection diagnostic is replayed explicitly.

```sh
python research/hard_core_weitz/verify_radius_four.py
```

Data SHA-256:
539f060617047d4334ac6e638b0e92d4f37369c174a89a4f092b6948d5eff36d.
Verifier SHA-256:
32ff8ab35c6087ebec88c5eddf3dc2dc17b197ca5ddb78e29f18f623f429eb2b.

The replay uses arbitrary-precision integers and finite coordinate sets, no
floating-point eigensolver or saved success flag. It was executed again after
final source assembly and reproduced the result JSON byte for byte. It is a
separate implementation by the same authoring assistant, not independent-author
review. Its finite regressions do not certify universal Lean proof terms.

Logical source review and exact replay have been performed. Lean/lake is absent
from the authoring environment, so elaboration, kernel checking, executed axiom
closures and Scribe emission have not been performed. The new finite proofs
request decide +kernel; this records their intended checking method, not an
executed acceptance result. The original-problem zero-free improvement remains
open. No first-formalization priority or literature-wide mathematical novelty
has been established.

Additional precise locator for [4]:
https://arxiv.org/html/1306.0431v2#S5


## 14. Adaptive radius four and the change from counting to messages

Continuation dated 7 September 2026. Sections 1-13 are retained as historical
increments. The fixed-SRL radius-four construction in Section 11 remains a
separate, unchanged result. The recovered adaptive construction is now stored
under AdaptiveRadiusFourData and AdaptiveRadiusFourCertificates, so it does not
overwrite the concurrently developed fixed-order modules.

The adaptive controller has 881 distinct reachable geometric masks and the
exact integer potential

\[
 1\le w_i\le100000,\quad w_0=100000,\qquad
 2500\sum_{i\to j}w_j\le6202w_i.
\]

Its scalar growth upper bound is 2.4808. The all-domain endpoint has prefactor
100000, and an explicit four-direction root wrapper has prefactor 400000.
The 41 coordinates here are the full lexicographic Manhattan disk, with the
origin in its lexicographic position. This differs from the fixed-SRL payload's
coordinate enumeration. Masks and message assignments must not be exchanged
between these two presentations.

Storage was losslessly changed to increasing masks. Each increment literal
stores 1116 times the mask increment plus six times its weight index plus the
selected order. Geometric successors are recomputed, never taken from a saved
edge list. The selected-action version of the existing finite-domain simulation
is factored out of OrderedGridMemory; the original public all-action statement
is preserved. ControllerShadow also constructs the history-only lift of a
coarse state policy and certifies the Section 8 projection diagnostic.

The 2.4808 count bound remains above 2.429. The next construction therefore
retains the actual child types in the nonlinear vacancy recursion instead of
reducing all of them to one scalar growth constant. This direction was already
identified in Section 12 from Vera, Vigoda and Yang [4]. Affine messages and LP
search are established methods; the proposed new increment is the exact
whole-box certificate at activity 51/20 on this concrete geometric controller.

## 15. An exact affine contraction certificate through activity 51/20

Set

\[
 \Lambda=51/20,
 \quad L=(1+\Lambda)^{-1}=20/71,
 \quad\gamma=999/1000,
 \quad\eta=3/1000.
\]

For each actual geometric type i, the data supply nonnegative rational a_i and
rational b_i, with denominator one million, and

\[
 \Psi_i(x)=b_i-a_ix,
 \qquad b_i-a_i\ge10577/1000000>0.
\]

There are 332 distinct coefficient pairs, shared only for storage. Every one
of the 881 geometric rows is checked using its own actual successor types.
No behavioral quotient theorem or sampled state-space restriction is assumed.
An absent direction has child coefficients a=b=0.

For all lambda in [0,Lambda] and all three child values x_d in [L,1], put

\[
 y=\frac1{1+\lambda\prod_dx_d}.
\]

The exact certificate proves

\[
 \boxed{(1-y)\sum_d\Psi_{j_d}(x_d)<\gamma\Psi_i(y).}
\tag{15.1}
\]

Zero coefficients are used for absent geometric children. In addition,
y belongs to [L,1], and every actual message is bounded below by the same
positive constant. The statement holds on the full probability box, not only
at the recursion's fixed point or sampled tuples.

### Exact global separation of the affine product

For a parent pair (a_p,b_p) and its three child pairs, write

\[
 C=\sum_db_d-\gamma b_p,
 \qquad s_0=\gamma(b_p-a_p).
\]

Multiplication by the positive denominator gives the exact identity

\[
\begin{split}
 &(1+\lambda\prod_dx_d)
   \left[\gamma\Psi_p(y)-(1-y)\sum_d\Psi_d(x_d)\right]\\
 &\hspace{12mm}=s_0-\lambda(\prod_dx_d)(C-\sum_da_dx_d).
\end{split}
\tag{15.2}
\]

Each row has one of two exact certificates. When C<=L*sum(a_d), the product's
residual is nonpositive throughout the box, so it suffices that s_0>=eta.
Otherwise the certificate supplies t>0 and reference values r_d in [L,1] with

\[
 C=t+\sum_da_dr_d,
\]

and, for every direction, at least one of

\[
 r_d=L,\ t\le a_dr_d;
 \qquad r_d=1,\ a_dr_d\le t;
 \qquad a_dr_d=t.
\]

These finite rational conditions imply the global inequality

\[
 (\prod_dx_d)(C-\sum_da_dx_d)\le t\prod_dr_d.
\tag{15.3}
\]

Here is a proof that does not trust numerical global optimization. If the
residual S=C-sum(a_d*x_d) is nonpositive, (15.3) is immediate. Otherwise consider
the four nonnegative numbers S/t and x_d/r_d. Exact balance gives

\[
 S/t+\sum_dx_d/r_d
 =4+\sum_d(x_d-r_d)(1/r_d-a_d/t)\le4.
\]

Each summand is nonpositive by its clamping condition. Four-term AM-GM bounds
the product of the four numbers by one. Multiplication by t*prod(r_d) proves
(15.3). Mathlib's existing AM-GM theorem is reused in AffineProductCertificate;
no new abstract AM-GM result is claimed.

The final finite check is

\[
 s_0-\Lambda t\prod_dr_d\ge\eta.
\]

It implies (15.2)>=eta for every smaller nonnegative lambda as well. The
reference point and level are reconstructed from three base-three pattern
digits using the balance equation. All divisions, interval bounds and sign
conditions are then checked exactly. Among the 881 rows, 704 use a clamped
certificate and 177 use the nonpositive-residual case.

The minimum exact certified row margin is

\[
 \frac{15933066155943166674084141574726553949}
 {4676403243490598502400000000000000000000}
 >\frac3{1000}.
\]

Its decimal rendering is approximately 0.003407119815452501. The rational
fraction, rather than this decimal, is the recorded evidence.

### Deleting children preserves the same inequality

For any subset of actual children, set missing coordinates to one. The parent
recursion is unchanged. The complete row includes the omitted terms Psi_j(1),
which are nonnegative; removing them decreases the left side of (15.1), since
1-y>=0. Thus the same contraction constant holds for every subtree-pruning
pattern, including a leaf. The formal endpoint affine_pruned_row_contraction
quantifies over every subset. This check is essential: stability of the full
branching tree alone would not justify the finite-grid application.

### Discovery and acceptance are distinct

A sampled linear program and successive continuous separation searches proposed
coefficients. Its sampled optimum, approximate fixed-point derivative and
optimizer convergence are not evidence for (15.1). Coefficients were rounded
to denominator one million, then all clamping and margin conditions were
reconstructed and accepted by exact rational arithmetic. The independent
verifier uses no optimizer, precomputed edges or saved success verdict.

## 16. Paper transfer to a common complex zero-free neighborhood

The following analytic and graph argument is a candidate computer-assisted
proof of a uniform zero-free neighborhood of [0,51/20]. Its finite premises
have been exactly replayed. The analytic continuation and graph induction in
this section have been mathematically reviewed, but have not been formalized
or independently reviewed. Consequently this is not an end-to-end Lean theorem,
a kernel-admitted release or a literature-priority claim.

The real-to-complex contraction principle is established prior art, especially
Shao and Sun [5]. Their general theorem is not silently instantiated with
unproved type-dependent hypotheses. The finite-type version needed here is
spelled out below, including analytic coordinates, pruning and the four-child
root. The interval endpoint 2.55 exceeds the 2.538 sufficient endpoint in
[1, Appendix A.6]. The larger conjectural analyticity interval near 3.796
remains open; the scalar 2.429 connective-constant question is not settled.

### 16.1 Analytic coordinates and the actual Jacobian

For each type, use the real coordinate

\[
 \phi_i(x)=\frac{\log x-\log(b_i-a_ix)}{b_i},
 \qquad \phi_i'(x)=\frac1{x\Psi_i(x)}.
\]

Both x and Psi_i(x) are strictly positive on [L,1], and b_i>0. The inverse is
explicit:

\[
 \phi_i^{-1}(m)=\frac{b_i e^{b_i m}}{1+a_i e^{b_i m}}.
\]

These formulas remain valid when a_i=0. They define holomorphic functions near
the corresponding compact real intervals, using the logarithm branches that
agree with the real logarithms. Positive lower bounds and finitely many types
provide a common sufficiently small neighborhood with no denominator or log
argument vanishing. Write I_i=phi_i([L,1]); it is a compact real interval.

For a parent type i and an allowed subset S of its actual children, transform
the vacancy recursion to g_(i,S,lambda) in these coordinates. Direct
differentiation gives, for every retained child j,

\[
 \frac{\partial g_{i,S,\lambda}}{\partial m_j}
 =-\frac{(1-y)\Psi_j(x_j)}{\Psi_i(y)}.
\]

Thus (15.1) and the pruning result bound the absolute Jacobian row sum by
gamma throughout every real product of the child intervals and for all
lambda in [0,Lambda]. This derivative identification is a paper calculation;
the current Lean endpoint proves the displayed algebraic row inequality.

### 16.2 Uniform complex invariant neighborhoods

Choose gamma' strictly between gamma and one, for example 1999/2000. There
are finitely many parent types and child subsets. Holomorphy and compactness
therefore provide positive radii delta_0 and epsilon_0 such that all transformed
maps are defined and their complex Jacobian row sums are at most gamma' when
the messages are delta_0-close to their real intervals and the activity is
epsilon_0-close to [0,Lambda]. Their activity derivatives have a common finite
bound M on a smaller closed neighborhood.

Choose 0<delta<delta_0 and then 0<epsilon<epsilon_0 with
M*epsilon<(1-gamma')*delta, with the harmless M=0 case treated separately.
Let Omega_i be the open delta-neighborhood of I_i. Each Omega_i is convex.
For z within epsilon of [0,Lambda] and each m_j in Omega_j, choose nearest
real points m_j^0 in I_j and lambda in [0,Lambda]. Integrating the derivatives
along the straight segments gives

\[
 \left|g_{i,S,z}(m)-g_{i,S,\lambda}(m^0)\right|
 \le\gamma'\max_j|m_j-m_j^0|+M|z-\lambda|<\delta.
\]

The real output lies in I_i by the vacancy interval theorem. Hence the complex
output lies in Omega_i. The empty-child case is included in the same argument.
This provides one invariant collection of neighborhoods and one activity
neighborhood, independent of the tree's depth or the graph's size.

At the unconditioned root there can be four children. No root contraction
estimate is required. Its denominator 1+lambda*prod(x_j) is at least one on
the compact real set. Shrinking delta and epsilon further, while keeping the
invariance inequality, makes all these root denominators nonzero as well.
All root branches may be initialized at the parent-only geometric type; the
extra actual deletions only prune the represented tree.

### 16.3 Exact graph recursion and its geometric typing

For a finite induced grid graph H and vertex v, separate independent sets
according to whether v is occupied:

\[
 Z_H(z)=Z_{H-v}(z)+zZ_{H-N[v]}(z).
\tag{16.1}
\]

Order the available neighbors u_1,...,u_k as prescribed by the current geometric
type, and let H_j=H-v-\{u_1,...,u_{j-1}\}. Wherever the smaller partition
functions are nonzero, telescoping gives

\[
 \frac{Z_{H-N[v]}(z)}{Z_{H-v}(z)}
 =\prod_{j=1}^k\frac{Z_{H_j-u_j}(z)}{Z_{H_j}(z)}.
\tag{16.2}
\]

These are finite exact identities. No assumption of independence between
neighbors in the original graph is used. Orders may depend on the entire
recursion history, since (16.2) holds at each finite subproblem separately.
The translation and quarter-turns preserve square-grid adjacency. The proved
blocker disjointness guarantees that every actual available child is represented,
and the geometric closure assigns its correct successor type. Missing actual
vertices simply remove children, which Section 15 already covers.

Induct on the finite number of available vertices, simultaneously carrying
the nonroot typed vacancy values in the invariant message neighborhoods.
The empty partition function is one. At each step all smaller denominators in
(16.2) are nonzero by induction, so (16.1) expresses Z_H as the nonzero smaller
partition function times the certified nonzero local recursion denominator.
Nonroot outputs remain in their typed neighborhoods by Section 16.2; the full
root uses its separate four-child nonvanishing bound. Every finite induced
subgraph, including disconnected graphs and irregular boundaries, is covered.

This yields the paper/computer-assisted conclusion

\[
 \boxed{\exists\epsilon>0\ \forall H\subseteq_{\mathrm{fin,ind}}\mathbb Z^2\
 \forall z\in\mathbb C:\
 \operatorname{dist}(z,[0,51/20])<\epsilon\ \Longrightarrow\ Z_H(z)\ne0.}
\tag{16.3}
\]

The argument gives existence, not a numerical value of epsilon. It concerns
unconditioned finite induced partition functions. An occupied pinned vertex
can contribute a factor z, so no claim of nonvanishing at zero for arbitrary
pinned partition functions is made. Infinite-volume free-energy analyticity
and an implemented approximation algorithm are not separately established here.

## 17. Formal endpoints, replay and the next research step

New formal-source endpoints include clipped_product_bound, checked_row_sound,
affine_message_certificate, affine_message_positive, affine_polynomial_margin,
vacancy_mem, affine_full_row_contraction and affine_pruned_row_contraction.
The finite data, real inequality proofs and geometry all have paired canonical
Scribe declarations. The historical fixed-order and block-memory modules remain
unchanged. No artificial finite arena, information score or sealing claim is
attached to the certificate; the type assignments refer to actual grid masks.

The independent pure-Python verifier reads the current Lean-owned literals,
reconstructs all successors with integer-coordinate sets, and performs:

- 2643 geometric transition checks and 881 integer growth rows;
- 881 exact whole-box affine row checks, including 704 clamped cases and
  177 nonpositive-residual cases;
- 21144 exact rational recursion/pruning regressions across all child subsets;
- six corruption tests, all rejected, including message/type misalignment,
  a wrong clamp pattern, omitted root deletion, loss of message positivity,
  a missing state and an unsupported increase of the activity to three.

```sh
python research/hard_core_weitz/verify_adaptive_affine.py
```

The final replay was executed twice and produced byte-identical output. It is
a separate implementation by the same authoring assistant, not independent
researcher review. Finite regressions supplement the universal clamped-product
proof; they do not replace it. Source transcription errors were detected by
exact remote/local blob comparison and corrected before final delivery.

The authoring runtime has no Lean/lake executable. No source elaboration,
executed axiom closure, Scribe emission or kernel admission is asserted.
The finite scripts request decide +kernel and contain no new axioms or admits.
Sections 16.1-16.3 remain a paper transfer requiring independent scrutiny and
future end-to-end formalization, even if the current real certificate compiles.

The next priority is to formalize the actual finite independent-set identities
(16.1)-(16.2), the typed holomorphic coordinate/Jacobian calculation and the
uniform complex-neighborhood induction. This turns the proposed 2.55 conclusion
into a complete machine-checkable graph theorem. A quantitative epsilon would
also be useful, but is distinct from proving its existence. Larger activity
certificates or larger geometric memories should be pursued only after the
current actual-graph transfer is independently checked. Improving a scalar
connective-constant bound is no longer a prerequisite for this message route.

[5] Shuai Shao and Yuxin Sun. *Contraction: A Unified Perspective of Correlation
Decay and Zero-Freeness of 2-Spin Systems*. Journal of Statistical Physics 185,
12 (2021); arXiv:1909.04244v3. The real-to-complex extension is prior art; the
specific finite-type coordinate argument and numerical certificate above are
spelled out rather than attributed as an already instantiated theorem.
https://arxiv.org/abs/1909.04244
https://doi.org/10.1007/s10955-021-02831-0


## 18. Actual independent-set partitions and noncircular elimination

This continuation begins at ceb6e285c889669fd4090da55ae26e38f28a60ef and reads
dev at 76d7b4a789e9c44f49b4800fc93e569f68a48b51. The previously delivered
IndependentPartitionDeletion, OrderedPartitionRecursion and RealPartitionMessages
sources are present on the research branch. Their missing cumulative mathematical
summary is supplied here, before the new grid correspondence.

For a simple graph G, a finite vertex domain V and activities w in a commutative
semiring, the existing partition is the actual independent-configuration sum

\[
 Z_G(V;w)=\sum_{S\subseteq V,\;S\text{ independent}}\prod_{u\in S}w(u).
\]

The configuration predicate is Mathlib's SimpleGraph.IsIndepSet. The ambient
graph may be infinite. Splitting configurations by the occupancy of v in V
and inserting v into configurations on C=(V\{v})\N_G(v) gives

\[
 Z_G(V;w)=Z_G(V\setminus\{v\};w)+w(v)Z_G(C;w).
\]

No nonzero assumption is used. The identity holds as a polynomial identity
and at complex activities where intermediate partitions vanish.

For an ordered list of neighbors, let W0=V\{v}, Wj=W(j-1)\{uj}, and define
N=prod_j Z_G(Wj;w), D=prod_j Z_G(W(j-1);w). Exact cross multiplication gives

\[
 Z_G(V;w)D=Z_G(W_0;w)(D+w(v)N).
\]

If every partition on a subset of W0 is nonzero, this becomes

\[
 Z_G(V;w)=Z_G(W_0;w)\left(1+w(v)\prod_j
 \frac{Z_G(W_j;w)}{Z_G(W_{j-1};w)}\right).
\]

The target Z_G(V;w) is not assumed nonzero. This is the noncircular induction
step needed for the later complex result.

For nonnegative real activities, the empty configuration contributes one and
all other terms are nonnegative. Configuration inclusion gives domain
monotonicity. If the root activity is at most Lambda, then

\[
 Z_G(W_0;w)\le Z_G(V;w)\le(1+\Lambda)Z_G(W_0;w),
 \qquad \frac1{1+\Lambda}\le\frac{Z_G(W_0;w)}{Z_G(V;w)}\le1.
\]

Thus constant activity in [0,51/20] places every actual real vacancy in
[20/71,1]. These classical facts are now source dependencies rather than
unproved graph-message interpretations.

## 19. Exact configuration transport for the square-grid frames

PartitionRelabeling constructs the image and inverse-image correspondence
between complete independent-configuration families. For a vertex equivalence
e from G to H that preserves and reflects adjacency, it proves

\[
 \mathcal I_H(e(V))=\{e(S):S\in\mathcal I_G(V)\},\qquad
 Z_H(e(V);w)=Z_G(V;w\circ e).
\]

Weights are pulled back explicitly. The result is over every commutative
semiring; it therefore preserves entire independence polynomials and all their
complex evaluations. Injectivity also proves e(V\{v})=e(V)\{e(v)}, so the
marked numerator is transported together with the denominator.

SquareGridCoordinates defines the nearest-neighbor grid on the already-owned
integer-pair type. It proves directly that translation to an arbitrary root and
the existing recenter maps preserve and reflect each grid edge. Explicit inverse
maps witness bijectivity. No graph-isomorphism premise remains in the concrete
coordinate theorems.

For the existing recenter map T_d, constant activity z and every finite V,

\[
 Z_{\rm grid}(T_dV;z)=Z_{\rm grid}(V;z),\qquad
 \alpha(T_dV,T_dv;z)=\alpha(V,v;z).
\]

Here alpha is the ratio of two actual independent-set sums. Equality of total
field expressions at zero denominators does not assert holomorphic regularity;
all recursive cancellation still requires proper-domain nonvanishing.

## 20. Exact child types, actual contraction and the four-child root

Fix one of the six existing orders a. Before child d, let
B_d=V\K(a,d), using the original deleted definition, and V_d=T_d(B_d), using
the original advance definition. The new exact correspondence is

\[
 \boxed{\alpha(V_d,0;z)=\frac{Z(B_d\setminus\{d\};z)}{Z(B_d;z)}.}
\]

The selected neighbor becomes the origin. The finite order check proves that
B_d is precisely the successive domain occurring in ordered elimination,
including earlier absent vertices. The child factors are neither independent
marginals of the original graph nor an unconditioned computation-tree surrogate.
Their product is the exact ordered graph product.

For a present origin and an absent parent, proper-domain nonvanishing yields

\[
 Z(V;z)=Z(V\setminus\{0\};z)
        \left(1+z\prod_{d\in\{S,R,L\}}\alpha(V_d,0;z)\right).
\tag{20.1}
\]

On the real nonnegative interval all denominator conditions follow from the
empty configuration. If an actual neighbor is absent, its two partitions are
identical and positive, so its child value is exactly one.

For an actual domain V disjoint from the certified mask F_i, every present
child d has a successor j in the existing 881-state table. The theorem
typed_child_context derives simultaneously

\[
 0\in V_d,\qquad V_d\cap F_j=\varnothing,\qquad |V_d|<|V|.
\]

It consumes the existing full geometric closure and blocker-disjointness
proofs. No separate table-coverage or child-type assumption is supplied by a
caller. Strict size decrease supplies the well-founded measure for induction.

Let S(V) be the set of actual present nonparent directions. The new endpoint
actual_grid_affine_contraction applies the existing affine certificate to the
actual graph parent and child ratios:

\[
 \boxed{
 \frac{(1-\alpha(V,0;\lambda))
       \sum_{d\in S(V)}\Psi_{j_d}(\alpha(V_d,0;\lambda))}
      {\Psi_i(\alpha(V,0;\lambda))}<\frac{999}{1000},
 \quad 0\le\lambda\le\frac{51}{20}.
 }
\tag{20.2}
\]

The original childMessage accessor is used, with its zero value for absent
geometric directions. Actual presence implies a genuine successor, as proved
above. The proof derives the input interval, recursion identity and neutral
absent-child values before invoking affine_pruned_row_contraction. No floating
approximation or graph-message equality hypothesis is used.

The unconditioned root is treated separately. SquareGridRootMessages proves
that the four existing rootDomain objects are exactly the successive root
neighbor domains under their actual coordinate equivalences. Consequently,

\[
 Z(V;z)=Z(V\setminus\{0\};z)
   \left(1+z\prod_{e=0}^3\alpha(\operatorname{rootDomain}(V,e),0;z)\right).
\tag{20.3}
\]

Only proper pre-recentered subsets are required nonzero. Every present first
child is smaller, contains its new origin, and is disjoint from the existing
type-zero mask {(-1,0)}. Extra earlier-neighbor deletions stay in the actual
vertex domain. No three-child contraction is applied to the four-child root.
An arbitrary marked root is handled by the proved translation equivalence.

## 21. What the 5040 research contributes to this lane

The 5040 research line was read in the current dev source, including
ZECKENDORF_EULER_5040.md, GoldenResourceObjectiveFactorization,
GoldenResource5040PriceInterval, and GoldenResource/EightStepAbundancy.
The recent padding-mass PR 6131 was also read at its discussion level. These
are cross-line mathematical inputs to the research strategy, not Lean imports
or a claim that the grid and arithmetic state spaces are the same object.

### A stable optimum depends on the specified resource

The exact objective in the price-interval theorem is

\[
 F_\theta(n)=\log(\sigma(n)/n)-\theta\log n.
\]

Prime factorization separates it into local exponent contributions. For
5040=2^4 3^2 5\,7, the existing theorem establishes unique optimality over all
positive integers throughout the open price interval

\[
 \boxed{\frac{\log(12/11)}{\log11}<\theta<
        \frac{\log(31/30)}{\log2}.}
\]

The approximate endpoints are 0.03628656 and 0.04730571. Price 1/25 lies
strictly inside. The prime-layer marginal is

\[
 m_p(a)=\frac{\log((1-p^{-(a+1)})/(1-p^{-a}))}{\log p}.
\]

The boundary layers are the last selected (p,a)=(2,4) and first unselected
(p,a)=(11,1). Strict local margins imply a stable global optimizer through an
exact sum decomposition. This is the useful certificate pattern here.

The same dev contains an explicit distinction: with the different constraint
Omega(n)=8, the unique maximum of sigma(n)/n is attained at 180180, with

\[
 \frac{\sigma(180180)}{180180}=\frac{224}{55}>
 \frac{403}{105}=\frac{\sigma(5040)}{5040},
 \qquad \Omega(180180)=\Omega(5040)=8.
\]

Thus 5040 does not optimize every resource formulation. For the square grid,
the actual parent-child relation and the complete message box define the
problem; replacing them by a more convenient scalar cost changes the claim.

### Exact local accounting is the transferable structure

For nonnegative activities, list all vertices and successively delete them.
The existing ordered telescoping theorem gives

\[
 \prod_{j=1}^{|V|}\alpha(W_{j-1},v_j;w)=\frac1{Z_G(V;w)},
 \qquad \log Z_G(V;w)=-\sum_{j=1}^{|V|}\log\alpha(W_{j-1},v_j;w).
\]

This paper consequence identifies an exact local accounting of the graph's
target observable. The arithmetic lane obtains its local sum from independent
prime factors; the graph lane obtains its sum from successive conditional
deletions, preserving the original correlations. The logarithmic formula is
not a separate new Lean declaration in this increment.

PR 6131's exponent-tagged padding injection illustrates a second safeguard:
a many-to-one map must retain a fiber tag or multiplicity bound when comparing
weighted sums. The grid transport proved here is a bijection, so each
configuration has multiplicity exactly one and no loss of the existing margin
is introduced by a coordinate change. PR 6131 explicitly retains its finite-set
mass-escape hypothesis; it is not read as an RH proof or a source of grid bounds.

Robin's classical criterion has the specific cutoff n>5040. A recent analogue
[6] uses a different divisor statistic and cutoff 2162160. Together with the
two distinct repository optimization problems, this reinforces that the number
5040 is important in specified arithmetic statements. No grid automorphism,
message dimension, contraction constant or complex-neighborhood width has been
shown here to equal or be controlled by 5040. There is no numerical 5040 premise
in the new grid Lean sources.

## 22. Verification and the remaining analytic step

Four new Lean owners have four canonical Scribe companions and 34 explicitly
named public declarations: PartitionRelabeling, SquareGridCoordinates,
SquareGridMessages and SquareGridRootMessages. Existing partition, geometric,
affine-message and root-domain owners are reused without replacement.

The independent exact replay enumerates every independent subset of all 512
subdomains of the 3-by-3 square. It checks 2048 complete configuration bijections,
2048 weighted equalities, 17368 marked-ratio equalities, 3328 child matches,
5120 denominator-cleared recursions, 4134 valid division recursions, 986 cases
with a zero intermediate factor, and 13056 real input-box checks. A separate
bounded exploration of 652 radius-four masks supplies 67152 compatible-child
regressions; it is not a second full check of the 881-state certificate.
Seven malformed transports are rejected. Their changes include loss of
adjacency, injectivity, weight transport, marked-root transport, correct ordered
deletion, the fourth root direction, and the root nonvanishing obligation.

```sh
python research/hard_core_weitz/verify_grid_correspondence.py
```

This verifier computes reference values directly from independent subsets,
not from the deletion identity it tests. It uses exact rational and
Gaussian-rational arithmetic. The logarithmic endpoint decimals are illustrative
only. The upstream affine certificate is reused by the Lean source and has not
been rerun in this continuation. The separate implementation is by the same
authoring assistant, not an independent researcher.

The new sources have been mathematically reviewed and regression-tested.
Lean elaboration, kernel checking, executed axiom closure and Scribe emission
remain unperformed. The finite proof scripts request decide +kernel. No
kernel-admitted or independent-review status is inferred from that request.

The exact graph/type correspondence in Section 20 removes the semantic
premises from the current real certificate. The remaining work is to formalize
the actual holomorphic coordinates and their Jacobian, build one invariant
complex neighborhood for all types and pruning subsets, and combine it with
the strict-cardinality induction and the separate four-child root denominator.
These analytic obligations are not replaced by real positivity or the 5040
analogy. No new zero-free endpoint or RH conclusion is asserted in this increment.

[6] Steve Fan, Mits Kobayashi and Grant Molnar. *A family of analogues to the
Robin criterion*. arXiv:2511.02106 (2025). The statistic and the explicit cutoff
change together in their Robin-type equivalence.
https://arxiv.org/abs/2511.02106
