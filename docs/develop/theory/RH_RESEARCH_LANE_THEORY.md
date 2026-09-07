- Gnazzo, Guglielmi, Poloni, Sicilia, Structured distance to singularity as a
  nonlinear system of equations, https://arxiv.org/html/2603.05419v1 ;
  Section 2.2, equations (12)-(14), and the stated rank-drop caveat.

## [PR #5895] ACTUAL_PAPER_FOURIER_TRANSVERSE_ANALYTIC_BRIDGE

### 1. The open target and the precise gap closed here

This continuation was prepared on 2026-09-07. The target remains the genuine
lowest-Weil-mode/prolate comparison in Connes, Consani and Moscovici,
*Zeta Spectral Triples*, arXiv:2511.22755v1, Section 8. Lemma 7.3 concerns
the explicit model's limit. Alain Connes' 2026 survey, *The Riemann Hypothesis:
Past, Present and a Letter Through Time*, arXiv:2602.04022v1, Section 6.6,
again separates simple-even lowest modes from sufficiently accurate model
approximation. Both primary texts were read for this continuation.

The preceding real-structure certificate supplied generic L2 readout theorems
and a full-box computation, but retained the concrete Fourier/kernel identity
and the full kernel norm estimate as paper inputs. This increment supplies
proof bodies for those actual analytic steps. It does not improve a spectral
enclosure or enlarge the previously certified frequency tube.

The source review included loning's #5326 and #5296 boundary-transversality
and signed-coupling distinctions, and the current #5602 arithmetic work.
In #5602 at f7ca840051c8183062cb2cfb989e9f5686bd724a, the actual
`WeilMellinPrimeIntertwining.prime_even_mellin_identity` retains

    (B_+ + B_-) e = (I+R) E((log t)h) - 2 X r - (I+R) B_+ r,

where e and r are the even and odd parts of the same Mellin synthesis.
The present source does not duplicate that arithmetic identity. In a later
application its nonzero odd correction must remain in the residual budget.
A real-even Fourier observer does not license deleting a pre-evenization
arithmetic error. The parallel fixed-scale model/prime calculations were
read as others' work; they were not rerun or produced by this increment.

### 2. Keep the existing Fourier transform and the actual function class

Every transform statement uses the pre-existing `Zeta23.paperFT`:

    paperFT(f,z) = integral_R f(t) exp(i z t) dt.

No second transform or alternative normalization is introduced. For an even
L1 function supported in [-a,a], both exponential twists are integrable by
the existing exponential-envelope lemma. Real reflection preserves their
integrals. Averaging the two twists therefore proves

    paperFT(f,z) = integral_R f(t) cos(z t) dt.              (PT1)

The source permits discontinuous zero extensions and nonzero endpoint traces.
It does not restrict the input to smooth WeilTestFunction values. The support
and evenness assumptions in these statements are pointwise assumptions on
a chosen measurable representative; the final application to equivalence
classes must choose or identify such a representative in the actual domain.

### 3. A derivative-completed kernel without a puncture at zero

Use the existing Mathlib `dslope` operation, which fills a difference quotient
at its base point with the derivative. Define only the domain-specific kernel

    K(x,y,t) = -t sin(x t) dslope(sinh,0,y t).

Mathlib's differentiability and slope identities give

    K(x,0,t) = -t sin(x t),
    y K(x,y,t) = -sin(x t) sinh(y t)                       (PT2)

for every x,y,t, including y=0 and t=0. The kernel is jointly continuous and
even in y. For y nonzero it agrees with the usual divided-imaginary kernel
`-sin(x t)sinh(y t)/y`.

The mean-value inequality, applied on [0,|v|], gives

    |sinh(v)| <= |v| cosh(v),
    |dslope(sinh,0,v)| <= cosh(v).

Consequently, for a,b>=0, |t|<=a and |y|<=b,

    |K(x,y,t)| <= |t| cosh(a b).                           (PT3)

This bound is independent of x and has no factor 1/|y|. It is an explicit
uniform bound, not a claim of the optimal Fourier observer norm.

### 4. Derive the actual imaginary integral identity

For real even supported L1 f, use (PT1), commute the imaginary-part continuous
linear map with the proved integrable cosine integral, and expand the complex
cosine. Together with (PT2) this proves

    Im paperFT(f,x+i y) = y integral_R f(t) K(x,y,t) dt.    (PT4)

The identity includes y=0. The source also proves integrability of f*K from
(PT3), then identifies the quotient for y nonzero. No supplied Fourier/Riesz
identity occurs in this theorem's hypotheses.

The kernel value at y=0 is proved. Differentiating paperFT with respect to x,
or proving a joint parameterized dominated-convergence theorem for the
integral, is a separate possible consumer. This increment does not silently
identify a proved kernel continuity statement with a completed proof of
Fourier derivative convergence.

### 5. Integrate the exact support moment in the full L2 space

The square of (PT3) is integrated on the actual interval:

    integral_[-a,a] K(x,y,t)^2 dt <= cosh(a b)^2 (2a^3/3).  (PT5)

Mathlib's power-integral theorem computes the moment 2a^3/3, including a=0.
The proof then forms actual `MemLp.toLp` representatives and invokes the
existing L2 Cauchy-Schwarz inequality. If w belongs to L2(R), is supported
in [-a,a], and integral w^2 <= rho^2 with rho>=0, the result is

    |integral_R w(t)K(x,y,t)dt|
        <= rho cosh(a b) sqrt(2a^3/3).                    (PT6)

The full real-line error is retained. Only the kernel is multiplied by the
support indicator. No Fourier-coordinate cutoff or finite-dimensional error
hypothesis is introduced. Supported L2 membership also proves L1 integrability
internally by pairing with the interval indicator in L2.

For a real even integrable candidate k and a real even error w as above, a
candidate floor

    m <= integral_R k(t)K(x,y,t)dt

and the strict scalar comparison

    rho cosh(a b) sqrt(2a^3/3) < m

now give the actual transform conclusion

    |Im paperFT(k+w,x+i y)|
       >= |y| [m-rho cosh(a b)sqrt(2a^3/3)] > 0            (PT7)

when y is nonzero. The final theorem derives (PT4)-(PT6) rather than receiving
`hidentity` and `hkernel` as independent assumptions. The candidate floor and
the true error budget still require their own independent certificates.

### 6. The previous 173/500 norm budget is now a proof-level constant

At a=log(3)/2 and b=1/2, put r=exp(log(3)/4). Exact exponential algebra gives

    r^4=3,
    cosh(log(3)/4)^2 = 1/2 + 1/r^2.

The positive root satisfies r^2>173/100. Mathlib's proved logarithm enclosure
implies log(3)/2<11/20. Therefore the square of the support norm is bounded by

    (1/2+100/173) * 2(11/20)^3/3
       = 496463/4152000 < (173/500)^2.                    (PT8)

The new `prime_three_transverse_norm_lt` proof uses those facts and rational
arithmetic only. It accepts no external decimal or JSON premise. Combining
(PT8) with the previously certified candidate floor and error radius recovers

    43/5000 - (173/500)(1/100) = 257/50000 > 1/200.

This does not certify the old candidate floor again. The 64-box transcendental
interval computation and the upstream spectral/form-domain enclosure remain
separate from the newly supplied analytic proof bodies.

### 7. Source and validation scope

New paired owners under `D5/S3/Weil/GroundMode/` and the matching Blueprint path:

    PaperFourierTransverseKernel
    PaperFourierTransverseIntegral
    PaperFourierTransverseBound

They use 17 public definition/theorem declarations, all described with
`StatementSource.FromLean()`. The number of declarations is a coverage fact,
not a novelty measure. The mathematics of these analytic estimates is
classical; the contribution is closing concrete dependencies in the existing
actual-transform certificate rather than introducing a new abstract observer.

Lean elaboration, transitive axiom reports and Scribe compilation have not
been executed. The sources remain logically reviewed Candidate proofs.
No external estimate has been installed as a Lean axiom. The local diagnostic
run tested 600 scalar cases, six supported polynomial integral identities
with nonzero endpoint traces, six real-axis checks and three exact rational
budget identities. The numerical integral checks used nondirected high-
precision quadrature and are diagnostics only, not certified integration or
kernel evidence. No upstream spectral verifier was rerun and no new spectral
or zero data were produced.

For the scale problem, the explicit analytic factor is now

    Q(a,b)=cosh(a b)sqrt(2a^3/3).

Regularizing the ordinate removes the factor 1/|y|, but costs a derivative
moment: Q(a,b) grows on the order of a^(3/2)*exp(a*b) for fixed b>0. Thus this
is not a free improvement of the all-scale approximation rate. Its concrete
gain is a finite transverse bound uniform down to the real axis.

A candidate family with a floor m_a on its chosen region requires control of
`rho_a Q(a,b)/m_a`. Nothing here proves that ratio tends to zero as a grows.
The actual prime correction above, Gamma and pole terms, and the independently
certified model residual must all enter rho_a or a sharper directional
certificate. A fixed-window theorem is not an all-scale Weil/prolate limit.

Primary references:

- Connes, Consani, Moscovici, Zeta Spectral Triples,
  https://arxiv.org/html/2511.22755v1 , Lemma 7.3 and Section 8.
- Alain Connes, The Riemann Hypothesis: Past, Present and a Letter Through Time,
  https://arxiv.org/html/2602.04022v1 , Sections 6.5-6.6.
- Mathlib at db584cd6d46c92f209a44c0f1c829460d327499d: Calculus/DSlope,
  Trigonometric/DerivHyp, Function/L2Space, Integrals/Basic and
  Complex/ExponentialBounds. These are actual reused proof APIs.
