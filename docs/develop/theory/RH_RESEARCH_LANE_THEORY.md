- https://arxiv.org/abs/2008.10871 , complete-exterior spectral discretization
  methodology; its Schrodinger assumptions are not asserted for the Weil form.

## [PR #5895] SIGNED_MODEL_RESIDUAL_PAIRING_AND_GOAL_CORRECTION

### 1. The open problem and the role of the old sufficient rate

The target is still the actual lowest-Weil-mode comparison with the same
correctly normalized prolate family in Connes, Consani and Moscovici,
Zeta Spectral Triples, arXiv:2511.22755v1, Section 8. The explicit-model
transform limit of Lemma 7.3 is a separate step. This increment preserves the
signed complex primal/dual pairing before estimating the remaining error.
It does not establish that pairing's decay along unbounded physical windows.

The preceding condition nu*C_centered/b^2 -> 0 is sufficient. It is not a
necessary condition for the actual normalized readout error to vanish.
Directional residual cancellation may be lost when the full model error is
bounded first by a single energy budget. The following exact identity is a
complementary certificate; all earlier inequalities remain valid.

The primary methodological reference is Wu and Zhang, Goal-Oriented Error
Estimation for Least-Squares Finite Element Methods via Physically Meaningful
Adjoint PDEs, arXiv:2607.23850v1 (26 July 2026), Section 4, especially the
corrected-output and product-remainder statements. That paper explicitly
retains the classical Giles--Suli lineage. Its elliptic PDE assumptions and
least-squares estimates are not used as hypotheses for the Weil operator.
The domain-level identity here needs neither a Galerkin solution nor an exact
dual inverse. No priority for residual correction is claimed.

Cross-session readback: #6029 at 99b3e1ca03e88f42a9b7c6ccadecc545e8c64a97
identifies actual zero-extended Fourier convolutions with the exterior
arithmetic column; it still separates the diagonal regularization and actual
operator-domain realization. #5602 at 5b1c54e84706acdca64e2ec042b51a5d52c5fcea
retains the complete genuine prolate model residual and newer scale work.
Those results are not reimplemented or counted as this continuation's work.
The numerical inputs below are the previously pinned c=3 records, not
unverified values inferred from a more recent PR title or description.

The final concurrent readback found #5895 advanced to
e6a7b1837783c6b9b4eb00d90240ae53e4543045, adding only the separate
InvariantSectorEnergyReadout Lean/Scribe pair. Its actual first 100 source
lines were read: the invariant-sector split keeps opposite-sector shifted
positivity separate from a positive gap. This contribution is not ours.
No numerical sector improvement is substituted into SG7-SG9. The three
paths proposed here were unchanged by that concurrent commit. This payload
was subsequently delivered on top of 023e6d1eccb223a563939590d301085a220b38f2,
preserving the completed parallel sector computation and theory appendix.

### 2. Signed identity with the actual eigenvalue uncertainty

Let iota,M:E->H be complex-linear maps on an actual operator domain, symmetric
there. Inner products are conjugate-linear in their first argument. Suppress
iota in the equations. Let e be a unit model and p an aligned eigenvector,

    Mp=lambda p,       <e,p>=1,       w=p-e perpendicular to e.

For g0 and g the actual origin and target readouts, put

    h=g-conj(<g,e>/<g0,e>)*g0,       <h,e>=0.

Choose a domain trial v perpendicular to e and ANY real spectral center sigma.
Define the complete quantities

    r_sigma=Me-sigma e,
    s_sigma=P_(e-perp)(h-(Mv-sigma v)),
    D=<v,r_sigma>.

Symmetry and the actual eigenvalue equation give the exact complex identity

    <h,p> + D = <s_sigma,w> + (lambda-sigma)<v,w>.          (SG1)

The correction is -D. Dropping lambda-sigma is invalid unless it is zero
or has been separately budgeted. Dropping the exterior of s_sigma is also
invalid. No scalar norm inequality or approximation theorem is assumed to
produce SG1.

For certified bounds ||s_sigma||<=S, |lambda-sigma|<=eta, ||v||<=V and
||w||<=R, Cauchy--Schwarz yields

    |<h,p> + D| <= (S+eta V)R.                             (SG2)

The right side is a product of the actual mode-error radius and the full
dual-residual/shift uncertainty. A small signed pairing does not by itself
make this remainder small, nor does it determine the actual output sign.

### 3. The model-origin correction and the actual denominator

Write d_e=<g0,e> and d_p=<g0,p>. From ||g0||<=G0 and the actual error bound,

    |d_p-d_e|<=G0 R.

If b,b0>0 and b+G0 R<=b0<=|d_e|, then |d_p|>=b. The existing centered-readout
identity supplies the quotient difference. Normalizing the computable
correction by the MODEL origin gives

    |<g,p>/<g0,p> - <g,e>/<g0,e> + D/d_e|
      <= (S+eta V)R/b + |D| G0 R/(b0 b).                 (SG3)

The second term is the cost of replacing d_p by d_e. It remains even if the
unscaled dual remainder vanishes. It is derived from the exact identity

    H/d_p + D/d_e = (H+D)/d_p + D(d_p-d_e)/(d_e d_p),
    H=<h,p>.

The public projective consumer constructs p=u/<e,u> using the existing
Rayleigh enclosure, derives the error radius from nu<=kap*R^2, and obtains
SG3 for the ACTUAL raw eigenvector ratios. Arbitrary complex phase and scale
cancel. The old eigenpair, spectral placement, domain and unit-model
conditions are retained; the theorem does not manufacture an eigenvector.

A scale limit to the ORIGINAL prolate model requires the normalized correction
D_a/d_(e,a) to tend uniformly to zero, as well as the product remainder in
SG3. Convergence to a newly corrected model alone does not establish the
original Xi/Xi(0) limit. The model has not been silently redefined here.

### 4. Why the finite trial can compute the genuine signed defect

Let mu=Re<e,Me>. Symmetry makes this diagonal pairing real, so the actual
Rayleigh residual r_mu=Me-mu e obeys <e,r_mu>=0. Therefore subtracting ANY
multiple of e from a domain trial leaves its pairing with r_mu unchanged:

    <v-beta e,r_mu>=<Mv,e>-mu<v,e>.                       (SG4)

In particular let v_e=v-<e,v>e be the repaired trial used in SG1. Since
v_e is e-orthogonal, its pairing with r_sigma also equals its pairing with
r_mu. Thus its signed correction is exactly <(M-mu)v,e>, computed from the
ORIGINAL finite v. The full action (M-mu)v is still generally infinite.
SG4 does not assert finite support of that action or of the repaired trial.

Split that action into finite a_head and exterior a_tail. A complete pairing
budget can use a known finite candidate k with <a_tail,k>=0:

    |<a_head+a_tail,e>-<a_head,e_approx>|
      <= ||a_tail|| ||e-k|| + ||a_head|| ||e-e_approx||.    (SG5)

For a sharper tail budget, unit normalization and orthogonal Fourier
projection give

    ||e_tail||^2 = 1-||e_head||^2
      <= 1-(||e_approx,head||-gamma)^2,                  (SG6)

provided ||e_head-e_approx,head||<=gamma<=||e_approx,head||.
Subtract the approximation error before squaring. The near cancellation in
one minus captured energy must use outward rounding. SG5 and SG6 have new
Candidate Lean proof bodies; the actual Fourier/Parseval identification and
model-approximation record are still the same separate analytic inputs.

### 5. Executed signed pairing for the same genuine c=3 model

The same archived 129-coordinate finite complex trial and aligned UNIT
true prolate model are used. No eigensolver, zero-location table or numerical
quadrature enters the new scalar consumer. The full arithmetic primitive
projection and model proposal are pinned to the previous delivery.

The actual pairing is

    D=<v,(A-mu)e>=<(A-mu)v,e>.

Both positive and negative column coefficients are evaluated independently.
Fourier model coefficients are explicitly evaluated through |n|<=P=512.
Action squares in the remaining finite exterior are evaluated through
M=8192. The full analytic column tail beyond M retains all four boundary
moments. The model tail is paid separately using SG6; no high coefficient
is assigned zero.

Two directed-interval executions, at 110 and 120 decimal digits, give the
same outward rational enclosures. Convenient rounded statements are

    -5.300e-6 < Re D < -5.288e-6,
     1.209e-6 < Im D <  1.222e-6,
    |D| < 5.44e-6.                                      (SG7)

The actual interval endpoints and exact input hashes are in the local
reproduction result. The all-tail radius is below 5.634e-9. A fixed rational
complex approximation is

    Dapprox=-10588081114283/2000000000000000000
                 + i*(1215543485777/1000000000000000000),
    |D-Dapprox| < 6/10^9.                                (SG8)

The captured model energy gives a full model-tail norm below approximately
5.065e-6. Combined with the complete column-tail energy, this is much tighter
than using the old model/candidate distance 0.00113 for this scalar pairing.
The basic product bound ||v||*rho<7*9.16662e-5 is over 117 times the new
upper bound on |D|. This comparison concerns sufficient SCALAR-PAIRING budgets,
not a 117-fold improvement of the actual mode or the final Fourier error.

A P=128 calculation also completed. An exploratory P=1024 call hit the
execution time limit and is not counted as a completed certificate. There
is no claim of an optimal P, a converged unknown infinite-mode value, or
an unbounded physical scale experiment.

### 6. Complete corrected-output budget on the prior small box

Use the same closed box of half-width 1/100000 around 20+i/4, the prior
whole-domain lower bound ell, old candidate energy width delta and genuine
model width nu. The previous centered full-residual verifier was replayed
at 100 digits in this continuation. Its two-sided exterior is unchanged.

Choose sigma=eta=delta/2, since the inherited eigenvalue enclosure gives
0<=lambda<=delta for M=A-ell. The old complete centered residual radius is
less than 357/10000. Recentring it with the full model residual and retaining
the spectral-center shift yields

    ||s_sigma|| < 3572/100000,
    ||w|| < 194/10000,
    ||v_e|| < 7,
    ||g0|| < 21/20,
    |d_e| > 805/1000,       |d_p| > 784/1000.

The raw centered candidate component is below 13/1000, obtained from the
prior uncentered component, the actual model ratio and the origin-kernel
norm. Its contribution is not discarded. The original model graph residual
is used here only to transport the full dual residual; it is not substituted
for the signed scalar pairing in SG7.

Exact Fraction arithmetic and a Candidate norm_num theorem give

    |ratio(u)-ratio(e)+Dapprox/d_e| < 885/1000000,
    |ratio(u)-ratio(e)| < 891/1000000.                    (SG9)

These inherit the recorded canonical operator/domain, full spectrum, genuine
model and Fourier identities. They are weaker than #5602's previously
reported normalized bound 51/100000 on a larger disk. The useful new output
is the signed defect and the product-remainder route, not a superior
fixed-window zero-free region. The remainder is currently much larger than
the signed defect, so no sign of the ACTUAL Fourier error is inferred.

### 7. A control showing the preceding single rate is not necessary

For a synthetic three-dimensional family let t=1/j, j>=10,

    c=(1-t^2)/(1+t^2),   s=2t/(1+t^2),
    M=diag(0,8s^2,1),   k=e=(c,0,s),   u=(1,0,0),
    h=(0,1,0),   g0=(1,0,0),   v=(0,1/(8s^2),0).

The old complement gap kappa=8s^2, model energy nu=s^2, eps=0 and anchor
b=1/4 satisfy the old centered theorem's conditions. The sharp old coefficient
is C=1/(8s^2), so nu*C/b^2=2 for every j. Nevertheless the actual normalized
readout error is identically zero, as are D and the complete dual residual
at sigma=lambda=0. The closed-form algebra proves the example; 101 exact
instances were also replayed. This is not an arithmetic Weil family and is
not evidence for its asymptotic cancellation.

It demonstrates a precise methodological point: failure to prove the old
single sufficient rate does not itself obstruct the original open problem.
The signed product estimate can see output cancellation hidden by that rate.
Conversely, a fixed-window nonzero D says nothing about whether D_a/d_(e,a)
will decay in the physical scale limit. Both questions remain separate.

### 8. Candidate sources and execution boundary

This continuation adds eight public theorem scripts to the existing
GenuineModelDualTransport.lean and eight matching canonical Scribe handles.
All original source text is preserved except the syntactic closing delimiter
needed to append Scribe entries. No new Fourier or dualBudget definition is
introduced. This theory text is now appended to the existing volume.
No Lean elaboration, transitive axiom audit or Scribe emitter was executed.

Executed checks include 600 exact Hermitian eigenpair cases and signed
identities, 600 product and ratio bounds, 600 repaired arbitrary-shift
pairings, 480 captured-head model-tail checks, 1800 raw phase/scale checks,
and negative controls for omitted eigenvalue uncertainty and omitted
actual-denominator correction. Wrong signs and complex-conjugation mutations
are detected. These are single-author finite diagnostics, not independent
proof review or a universal kernel verdict.

The previous exact centered diagnostics and 100-digit interval transport
were rerun in the original computation. The 512-mode scalar calculation was
run at 110 and 120 digits. At delivery the exact diagnostics, source/patch
checks and rational budget assembly were rerun. The original full spectral,
genuine-prolate and graph-norm verifiers were not rerun. Their input scope
remains explicit. The local input projections are not misrepresented as
complete upstream-file attestations.

Primary references read in the original computation:

- https://arxiv.org/html/2511.22755v1 , Lemma 7.3 and Section 8.
- https://arxiv.org/html/2607.23850v1 , Section 4 and the abstract's
  no-Galerkin/product-error qualifications, 26 July 2026.
- https://arxiv.org/html/2606.09096v1 , localized forms and operator domains.
