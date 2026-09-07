- Mathlib at db584cd6d46c92f209a44c0f1c829460d327499d: Calculus/DSlope,
  Trigonometric/DerivHyp, Function/L2Space, Integrals/Basic and
  Complex/ExponentialBounds. These are actual reused proof APIs.

## [PR #5895] FULL_ARITHMETIC_RESIDUAL_TO_ENERGY_DUAL_READOUT

### 1. The specific gap addressed

This appendix continues the actual Weil/prolate approximation problem in
Connes, Consani and Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755,
Lemma 7.3 and Section 8. Connes's 2026 survey, arXiv:2602.04022, Sections
6.4–6.6, explicitly retains the actual lowest-mode approximation after the
explicit prolate-model transform limit. The objective remains the same
arithmetic operator, the same candidate family and a quantitative limit on
compact subsets of the target strip.

The source audit made three distinctions important to this continuation.

* PR #5882 at `65339a3acbe99e661c6955dbb21728c4c62dfe76` now owns
  `CoerciveDualCertificate`, `ProjectiveEnergyDual` and `EnergyDualPaperFT`.
  They derive a directional coefficient from an arbitrary trial and its FULL
  residual. Their generic variational theorem is reused here, not rebuilt.
* PR #5602 at `f7ca840051c8183062cb2cfb989e9f5686bd724a` retains the actual
  arithmetic coupling jets and weighted Fourier-dual tail. Its newer
  prime/Mellin intertwining includes a nonzero parity correction in the
  true prolate model. Neither that correction nor the Gamma/pole terms may
  be discarded when constructing a residual.
* Loning's #5892, whose actual Jacobi theorem was inspected at
  `54f78c385cebdccb0b768b8a25b75dc04454b53e`, proves its finite conclusion
  under an explicit `hSymmetric` premise. It does not independently certify
  the infinite Weil operator domain or its complement coercivity.

In particular, #5602's weighted dual pairing is not #5882's unweighted
squared residual norm. The former sums a product involving an energy
inverse and a Fourier coefficient. The latter must include every component
of g-(A-ell)v after candidate projection. The new arithmetic theorem supplies
this missing tail object directly from the existing actual symbol.

### 2. Complete two-sided arithmetic column tail

Use the existing `arithmeticBoundarySymbol`, its independently proved
uniform bound B=B_c, and the existing column

    d_m(v) = sum_(n in S) (s_c(n)-s_c(m))/(pi*(m-n)) v_n.

Here c>=2, S is a finite integer set, |n|<=N for n in S, N>=0 and the
integer cutoff M satisfies M>N. No reality or parity of v is assumed.
Write the actual finite moments

    A0=sum v_n,        B0=sum s_c(n) v_n,
    A1=sum n v_n,      B1=sum n s_c(n) v_n,
    L1=sum |v_n|.

The already-owned paired second-jet identity and pointwise remainder give

    J_m=(B0-s_c(m) A0)/(pi*m)+(B1-s_c(m) A1)/(pi*m^2),

    |J_m|^2+|J_-m|^2
      =2/(pi^2*m^2) [|-s_c(m) A0+B1/m|^2
                     +|B0-s_c(m) A1/m|^2],

    |d_m-J_m| <= 2 B N^2 L1 / (pi*|m|^2*(|m|-N)).

For |m|>=M, use

    1/(|m|-N) <= M/((M-N)|m|).

Define

    X=B^2|A0|^2+|B0|^2,
    Y=B^2|A1|^2+|B1|^2,
    Q=2 B N^2 M L1/(pi*(M-N)).

Then the paired column satisfies

    |d_m|^2+|d_-m|^2
      <= 8X/(pi^2*m^2)+8Y/(pi^2*m^4)+4Q^2/m^6.

The elementary reciprocal inequality

    1/(x+1)^2 <= 1/x-1/(x+1),   x>0,

telescopes. Multiplying by the bound m^(-k)<=M^(-k) gives a conservative
summable majorant for all higher powers. Thus, with every positive and
negative mode beyond M included,

    sum_(|m|>M) |d_m(v)|^2 <= T_M(v),                     (FR1)

    T_M(v)=8X/(pi^2*M)+8Y/(pi^2*M^3)+4Q^2/M^5.

The new Candidate theorem `arithmetic_column_full_tail` proves both
summability and (FR1). The four moments remain present. The existing
pointwise sources are not edited or relabeled as already proving this
infinite summation.

### 3. The actual Cauchy readout residual

For explicitly given complex p and omega with |omega|<=M/2, define

    r_m=p/(m^2-omega^2)-d_m(v).

The reverse triangle inequality gives

    |m^2-omega^2| >= 3m^2/4,
    |p/(m^2-omega^2)|^2 <= 16|p|^2/(9m^4).

Combining this with (FR1), for both signs, yields

    sum_(|m|>M) |r_m|^2
      <= 2 T_M(v)+64|p|^2/(9M^3).                        (FR2)

`arithmetic_full_residual_tail` supplies a Candidate proof of this
summability and bound. No desired tail estimate is passed as a hypothesis.
This coefficient theorem does not itself identify an unspecified operator
with the canonical Weil form. That physical identification is separate.

For the present translated Fourier basis on [-L/2,L/2], rho=2*pi/L,

    e_n(t)=(-1)^n exp(i*rho*n*t)/sqrt(L),

and the even Fourier Riesz vector has coefficients

    g_n(z)=conjugate(2 z sin(Lz/2)/(sqrt(L)*(z^2-rho^2*n^2))).

Thus (FR2) is applied with

    p=conjugate(-2 z sin(Lz/2)/(sqrt(L)*rho^2)),
    omega=conjugate(z/rho).

The even Riesz vector represents the actual Fourier readout on even modes.
Using it for an arbitrary non-even mode would be incorrect. Actual mode
reflection symmetry is retained among the analytic premises, together with
the Fourier-basis identity, Parseval and trial operator-domain inclusion.

### 4. Consume the already-owned energy-dual theorem

Let the shifted actual domain action be M_op=A-ell*iota and kappa=T-ell>0.
For an arbitrary candidate-orthogonal trial v define

    r_v=P_(k-perp)(g-M_op v),
    C_g(v)=2 Re<g,iota(v)>-q_M(v)+||r_v||^2/kappa.

#5882 proves its nonnegativity and

    |<g,iota(f)>|^2 <= C_g(v) q_M(f),    f perpendicular to k.

The same PR derives the shifted energy of the actual projective error
w=u/<k,u>-k, rather than assuming it:

    0 <= q_M(w) <= U-ell.

Therefore

    |F(p_ground)(z)-F(k)(z)|^2 <= (U-ell) C_g(v).           (FR3)

No exact inverse or exact dual solution is required. The finite trial can
be generated by any proposal mechanism. Its own pairing, energy and full
residual are checked afterward.

For a trial supported in |n|<=N, projection along k affects only the
retained head. The squared norm of r_v decomposes exactly into the finite
projected head plus all external coefficient squares. The implementation
computes modes N<|m|<=M for both signs independently and bounds the entire
remaining exterior by (FR2). It does not substitute the weighted dual series
for this norm and does not set any finite boundary moment to zero.

### 4a. Why square summability also matters for the operator domain

There is a further analytic use of FR1. Suppose the actual closed Weil form
has the stated trigonometric form core, and its mixed coefficients on that
core agree with the arithmetic matrix. For a finite trial v, let a_m=q(e_m,v).
The retained coefficients are finite in number and FR1 proves square
summability of the exterior. The orthonormal Fourier synthesis therefore
constructs h in H with these coefficients. On every finite trigonometric f,

    q(f,v)=<f,h>.

Both sides are continuous in the form norm: the left by form continuity,
the right by its continuous embedding into H. Form-core density extends the
identity to every form-domain f. This is exactly the defining criterion for
v to belong to the associated operator domain, with Av=h.

Thus the new square summability is useful for the actual trial-domain bridge
as well as its numeric norm budget. The actual form-core identification and
mixed-coefficient dictionary are still required. This paragraph is an
analytic derivation; the present Lean owner does not yet implement the
closed-form-domain extension.

### 5. An actual fixed-candidate consumer at the previous failure point

The previous real-norm-ball certificate at z=20+i/4 admits a cancelling
perturbation. That perturbation need not satisfy the actual shifted-energy
constraint. This continuation tests the stronger information without changing
the original 129-entry candidate or improving the spectral enclosure.

Use the exact recorded spectral premises

    ell=2252813807/40960000000000000,
    U=560909/10000000000000,
    T=3/250000.

The candidate integer energy is

    sum p_n^2=1208925819614761052253583.

A finite complex even trial is proposed in modes |n|<=64. Its positive
coordinates are dyadic rationals. The zero coordinate is set by the exact
rational elimination

    v_0=-2 sum_(n=1..64) p_n v_n / p_0.

Consequently <k,v>=0 holds exactly, without a tolerance. The finite proposal
was generated by a numerical linear solve aimed at the residual-based
objective, not by an eigensolver; no correctness of that solve is trusted.
The fixed trial JSON is the independently checkable certificate input.

With M=8192 the final verifier evaluates the ENTIRE closed rational box

    |Re(z)-20| <= 1/100000,
    |Im(z)-1/4| <= 1/100000.                              (FR4)

One fixed trial is used for every point of this box. Interval arithmetic,
not continuity guessed from point samples, covers the complex frequencies.
The full coefficient budget is enclosed approximately by

    102.16213195890978 <= C_bar <= 102.23374652938720 <103.

Here C_bar is an upper certificate for the true C_g(v). A lower endpoint of
an interval enclosing a tail UPPER expression is not a lower bound on the
unknown actual tail.

The executed rational guards are

    C_bar<103,
    (U-ell) C_bar < (7/20000)^2,
    |F(k)(z)|>27/20000.

Combined with (FR3), these certify, under the inherited actual spectral,
Fourier and domain premises,

    |F(p_ground)(z)-F(k)(z)|<7/20000,
    |F(p_ground)(z)|>1/1000                              (FR5)

throughout (FR4). This is a fixed-window nonvanishing certificate for the
projectively normalized ground transform. It is not a certificate about a
zero of Xi, a zero count, or a larger support window.

At the central point the computed budget is approximately 102.197924071.
The squared residual upper expression includes a projected head of about
1.128e-3, a directly evaluated two-sided exterior of about 7.779e-5, and a
nonzero uncomputed-tail budget of about 1.118e-6. Omitting that last part
would invalidate the intended full-residual interpretation.

The same fixed rational guards failed in exploratory boxes of half-width
1/1000 (coefficient guard) and 1/10000 (candidate floor guard). These are
limits of this specific interval certificate, not evidence of actual zeros.
They are recorded in the validation output; the claimed region is only FR4.

### 6. Evidence, provenance and exact completion boundary

New mathematical owner and canonical Scribe:

    D5/S3/Weil/ZetaBridge/WeilArithmeticFullResidualTail.lean
    Blueprint/D5/S3/Weil/ZetaBridge/WeilArithmeticFullResidualTail.scribe.cs

Its four public definitions/theorems have four matching source-owned handles.
The proof uses existing concrete arithmetic symbols, jets and paired energy.
There is no new zero predicate, Fourier definition, arena, scoring rule,
registry or governance change. The numerical test is not a kernel or
information-escape admission decision.

New research work products are the fixed trial, verifier, certificate,
regression script and its actual result under `research/weil_ground_mode/`.
The verifier uses the existing arithmetic primitive formulas. In this
runtime the inspected definitions were reconstructed as a local execution
excerpt, not a byte-identical full upstream file. All used primitive classes,
functions and arithmetic constants are AST-pinned. Only that inspected code
projection is executed under explicit standard-library globals. The recorded
input SHA identifies the precise local source bytes read; it is not presented
as full upstream-file attestation. The original full spectral LDL verifier was not rerun.

The local excerpt is kept only in the reproduction package, outside the
proposed repository tree. In a repository checkout the verifier defaults to
`certify_prime3_refined.py`; the same inspected primitive AST projection and
candidate literal must match. This distinction is explicit in the JSON.
Normal Python execution is required because the upstream implementation uses
assertions. Optimized `python -O` is rejected rather than claimed equivalent.

Actually executed finite checks: 120 Gaussian-rational moment cases,
1,920 exact paired-jet identities, 3,840 two-sided coefficient checks,
1,920 Cauchy inverse checks, 147 telescoping reciprocal steps and 120 finite
positive-tail comparisons. These do not prove an infinite summation theorem.
The retained-only residual counterexample from #5882 was also replayed.
Directed interval replays at 50 and 90 digits pass the same rational guards.
An arithmetic sign change, missing trial coordinate, insufficient cutoff,
insufficient precision and unsafe Fourier band are rejected.

Lean elaboration, transitive axiom reports and Scribe emission were not
executed. The Lean file is a logically reviewed Candidate proof script.
In particular the physical Fourier/domain/Parseval identifications and the
arithmetic interval engine have not become kernel-checked merely because
(FR1)–(FR2) have proof bodies. No independent proof reviewer was used.

The prior Candidate package was delivered in this continuation: Lean and
Scribe at c36b7905927a3705a6869734ffb6efd08e07f41d, and its five research
files at 5c260c4a04a73e62b297b1085c6d27c45d12fd51. The interval verifier
and regression were replayed. Compilation status remains as stated above.

### 7. What must now scale

The new tail bound tends to zero as M grows for fixed c,N and fixed trial.
That fact controls computational truncation error. It does not force the
true directional sensitivity, the prolate residual or the ground gap to
have the desired behavior as the arithmetic window grows.

For the SAME actual prolate-based candidate family, the outstanding rate is

    |c_a|^2 (U_a-ell_a) sup_(z in K) C_bar_(a,z)(v_(a,z)) -> 0,

with independent complete coercivity, the correct candidate normalization,
and actual domain-admissible trials. The exact prime/Mellin parity correction
now retained in #5602 must enter those trials' full residuals. This is where
the all-scale arithmetic cancellation remains essential.

The present result supplies a concrete, full-tail-certified consumer of the
new energy-dual method and resolves the previous norm-ball failure at one
specified region. It does not establish the unbounded-scale rate or RH.

### References

1. A. Connes, C. Consani, H. Moscovici, *Zeta Spectral Triples*,
   arXiv:2511.22755, Lemma 7.3 and Section 8. The current author-hosted PDF's
   printed page 32 was inspected for the stated remaining steps.
2. A. Connes, *The Riemann Hypothesis: Past, Present and a Letter Through
   Time*, arXiv:2602.04022 (2026), Sections 6.4–6.6.
3. G. Dusson, I. M. Sigal, B. Stamm, *The Feshbach-Schur map and perturbation
   theory*, arXiv:2105.02058; DOI 10.4171/ECR/18-1/5. Classical positive
   operator/residual methods are methodological references, not new claims.
4. G. Dusson, I. M. Sigal, B. Stamm, *Analysis of the Feshbach-Schur method
   for the Fourier spectral discretizations of Schrodinger operators*,
   Mathematics of Computation 92 (2023), 217–249, DOI 10.1090/mcom/3774;
   arXiv:2008.10871v2, Sections 2–3. Their Schrodinger assumptions are not
   asserted for the arithmetic Weil operator.

### Final parallel-source readback

Before packaging, the remote #5895 branch had advanced independently to
`cb9548a0b8e24eac9a712c35ee15447d9a200df5`. Its two new commits add the
`PaperFourierTransverseKernel`, `PaperFourierTransverseIntegral` and
`PaperFourierTransverseBound` Lean/Scribe pairs, with no other changed path.
The last owner's actual `prime_three_transverse_norm_lt` proof was read; it
proves the earlier 173/500 constant from Mathlib logarithm and exponential
facts. Those changes are not this continuation's work. They do not overlap
the new full-arithmetic-residual owner. The existing theory blob used by this
append is unchanged by those two commits. This package can therefore retain
that newer base without copying or overwriting the parallel contribution.


## [PR #5895] EFFECTIVE_MOVING_SCALE_FULL_RESIDUAL_CONTROL

### 1. The limit that is actually being addressed

The research target is the true lowest-Weil-mode versus the same prolate
candidate family in Connes, Consani and Moscovici, Zeta Spectral Triples,
arXiv:2511.22755v1, Lemma 7.3 and Section 8. Connes's February 2026 survey,
arXiv:2602.04022v1, Sections 6.4-6.6, still separates the explicit candidate
limit from the two genuine lowest-mode obligations. This continuation does
not turn successful fixed-window computations into a proof of that limit.

There are two different parameters. The arithmetic cutoff c corresponds to
window half-width a=(log c)/2. The Fourier cutoff M controls a numerical
exterior at that window. Proving a tail tends to zero in M at each fixed c
does not justify an arbitrary diagonal choice M=M(c). For example j/M tends
to zero in M at each fixed j, while its value at M=j is identically one.

The new owner constructs a diagonal schedule, including the energy-gap and
normalization weights that can amplify a small raw residual. It controls
one concrete analytic component of the scale limit: the complete omitted
Fourier residual of the already-defined arithmetic column.

### 2. All-cutoff bounds on the actual arithmetic symbol

The existing arithmeticBoundaryBudget is

    B_c=2 cosh((log c)/2)+sum_(0<=n<c) |Lambda(n)/sqrt(n)|.

For c>=2 it has the unconditional elementary bound

    B_c <= c^2+2c.                                         (MS1)

Indeed 2cosh((log c)/2)<=2cosh(log c)=c+1/c<=2c. For n>=1,
0<=Lambda(n)<=log n<=n and sqrt(n)>=1, hence each summand is at most c.
The n=0 term is zero under the existing von Mangoldt and division definitions.
The proof directly reuses Mathlib's vonMangoldt_nonneg and vonMangoldt_le_log.
No prime number theorem, prime-gap estimate or positivity of the full Weil
quadratic form is an assumption. MS1 is intentionally coarse.

For the same finite trial as in FR1-FR2, define

    X=B_c^2|A0|^2+|B0|^2,
    Y=B_c^2|A1|^2+|B1|^2,
    L1=sum_(n in S)|v_n|,
    Qstar=4 B_c N^2 L1/pi,
    Dmass=16X/pi^2+16Y/pi^2+8 Qstar^2+64|pref|^2/9.

This is a finite expression in the actual four boundary moments. For
M>=1, M>=2N and M>N, the old coefficient Q in FR1 satisfies Q<=Qstar.
The previously proved full residual tail therefore gives

    sum_(|m|>M)|r_m|^2 <= Dmass/M                           (MS2)

when |frequency|<=M/2. Both signs and all uncomputed modes occur. Its square
summability is a conclusion, not an additional input. The original sharper
M^-1, M^-3 and M^-5 bound remains available and unchanged.

If L1<=L and |pref|<=P, with L,P>=0, the four moment triangle inequalities
and MS1 yield a fully explicit polynomial cap

    Dmass <= H(c,N,L,P),
    H=32(c^2+2c)^2 L^2(1+N^2+4N^4)+64P^2.                 (MS3)

The last simplification only uses pi^2>=1 and 9>=1. Thus H is rational when
L,P,N are rational or integral. A finite Gaussian-rational coefficient list
can provide an l1 cap via sum(|Re v_n|+|Im v_n|). A physical prefactor cap is
still required for the chosen frequency set. The same finite trial on each
cell of a finite frequency cover gives common coefficient caps by a finite
maximum; an arbitrary unbounded family of trials has no automatic such cap.

MS3 sacrifices sharpness to establish an explicit all-c fallback. It is not
an asymptotically optimal symbol estimate or an efficient recommended cutoff.

### 3. Executable strict cutoff with a degenerating coercivity budget

Let Hbar and Gbar be nonnegative rational upper certificates, with Dmass<=Hbar.
Gbar is the actual amplification that must be paid by the omitted squared
residual. Let N,R be natural bounds on trial support and Fourier frequency.
For any positive rational tau define

    M=max(2N+1, 2R+1, ceil_nat(Gbar*Hbar/tau)+1).           (MS4)

The implementation is `rationalResidualCutoff`. Its proof gives

    Gbar*Hbar < tau*M,
    Gbar*sum_(|m|>M)|r_m|^2 < tau.                         (MS5)

The +1 makes the strict inequality valid at integer thresholds and Gbar=0.
It is a sufficient cutoff, not a least-cutoff claim. No floating logarithm,
unproved search termination or infinite-moment oracle is involved.

For energy-dual Fourier transport, a suitable amplification is a certified
upper bound on

    |s_a|^2 (U_a-ell_a)/(T_a-ell_a),                       (MS6)

where s_a is the fixed scalar normalization and T_a-ell_a>0 is independently
certified at that scale. There is no assumption that all these positive
gaps share a uniform positive lower bound. If a positive gap cannot be
certified at some scale, this numerical-tail theorem does not manufacture it.

### 4. A genuine moving-scale uniform statement

Let c_j, N_j, R_j and the finite trial v_(j,z) vary with j, and let K be the
target frequency set. Suppose the concrete support, prefactor/frequency and
finite-mass caps hold uniformly on K. The masses and gains may grow at any
rate. Set tau_j=4^(-(j+1)) in MS4, using one common cutoff M_j for all z in K.
Then

    sup_(z in K) Gbar_j sum_(|m|>M_j)|r_(j,z,m)|^2
        <= 4^(-(j+1)) -> 0.                              (MS7)

The Lean statement uses Mathlib TendstoUniformlyOn of the actual weighted
exterior sums. It is valid for arbitrary cutoff sequences c_j, and in
particular for c_j->infinity. Compactness is not asserted where it is not
needed: uniform finite caps on the chosen set are the precise inputs.

This theorem is stronger in quantifiers than fixed-scale tail convergence,
but its proof is a classical explicit diagonal construction. No priority
claim is made. Very large masses or very small gaps can produce enormous
M_j. The arithmetic tests include such cases and assert no practical run-time
bound or new large-window spectral certificate.

### 5. What this removes from the Fourier limit, and what it does not

The actual operator-domain energy-dual theorem and its uniform Fourier
consumer already belong to #5882. The actual source read was
`EnergyDualPaperFT.lean` at 65339a3acbe99e661c6955dbb21728c4c62dfe76.
This continuation does not redeclare its all-scale implication.

For a fixed trial, split its full dual coefficient as

    C_full(z)=C_retained,M(z)+E_tail,M(z)/kappa,
    kappa=T-ell>0.

Here C_retained,M includes the variational objective and the actually
computed projected residual coefficients. That truncated scalar can have a
sign; it must not be silently interpreted as a squared norm. The full dual
coefficient is nonnegative by its existing owner.

After multiplying by |s_j|^2(U_j-ell_j), MS5 gives the usable bound

    scaled Fourier error squared
      <= |s_j|^2(U_j-ell_j) C_retained,M_j(z)+4^(-(j+1)).   (MS8)

Consequently the omitted numerical exterior no longer requires an unknown
uniform convergence threshold: a finite certified schedule is explicit.
The retained expression, independently valid coercivity, actual operator
identification and convergence of the SAME normalized candidates remain.

For fixed scale and trial, increasing M adds nonnegative residual squares
to C_retained,M and tends to the same C_full. Thus computational refinement
alone cannot force the true sensitivity or the physical mode error to zero.
The new polynomial envelope likewise supplies no favorable prolate residual
rate. The essential arithmetic cancellation is still in the true prime,
Gamma, pole and nonzero parity contributions retained by #5602.

### 6. Current external perspective and precise remaining task

Suzuki, Weil's quadratic form via the screw function, arXiv:2606.09096v1
(June 2026), Theorem 1.1 and Corollary 1.2, gives a concrete Friedrichs/form-
core perspective. The remarks following Corollary 1.6 specifically warn that
fixed-a finiteness of the prime contribution does not provide the necessary
arithmetic control for an unbounded limit. Its Section 7 explicitly assumes
RH for its heuristic motivation; those statements are not used as unconditional
premises here. This supports retaining the spectral shift and its inverse
cost in MS6, rather than assuming a harmless uniform gap.

The independent Feshbach-Schur reference is Dusson, Sigal and Stamm,
arXiv:2008.10871, Sections 2-3: complete exterior errors must accompany Fourier
truncations. Its Schrodinger assumptions are not asserted for the Weil form.
Loning's #5326 similarly separates the actual boundary error from a finite
state representation and does not infer all-height control from one depth.

The next arithmetic goal remains: for the same prolate family, construct
admissible dual trials and full-space lower certificates so that the first
term in MS8 tends uniformly to zero on each target compact set, with the
correct normalization. This is a specific quantitative target, not a new
RH-equivalent criterion presented as an advance. No such unbounded sequence
of actual spectral certificates has been established by this continuation.

### 7. Delivered sources and checks

New owner and same-path Scribe:

    D5/S3/Weil/ZetaBridge/WeilMovingScaleResidual.lean
    Blueprint/D5/S3/Weil/ZetaBridge/WeilMovingScaleResidual.scribe.cs

Eight public definitions/theorems have matched FromLean handles. The code
contains actual proof bodies for MS1-MS7. Lean elaboration, transitive axiom
reports and Scribe compilation have not been run. This remains Candidate
source, not a claimed kernel or information-escape admission result.

The exact arithmetic consumer `residual_scale_schedule.py` and its actual
validation output exercise 1600 cutoff cases, 237 strict-integer/zero-gain
cases, 1000 sharp-to-mass reductions, 800 polynomial-cap comparisons and 24
synthetic degenerating-gap scale cases. Those synthetic scales are not Weil
experiments. Invalid rational-sign, zero-tolerance and floating inputs fail.

The previously undelivered full-residual Lean/Scribe and all five research
files were actually committed first. Their fixed-window interval verifier
and full regression were replayed in this continuation, retaining the
102.23374652938720<103 full-box coefficient and all original failure controls.
The source-level Fourier/form-domain and upstream spectral qualifications
are unchanged. No new actual spectral window or all-scale Xi result is claimed.

Primary sources inspected in this continuation:

- https://arxiv.org/html/2511.22755v1 , Lemma 7.3 and Section 8.
- https://arxiv.org/html/2602.04022v1 , Sections 6.4-6.6.
- https://arxiv.org/html/2606.09096v1 , Theorem 1.1, Corollary 1.2,
  remarks following Corollary 1.6, and the hypothesis at the start of Section 7.
- https://arxiv.org/abs/2008.10871 .
