- https://arxiv.org/html/2511.22755v1 , Sections 7-8.
- https://arxiv.org/html/2606.09096v1 , Sections 1.2 and 2.1.
- https://arxiv.org/abs/math/0503328 , primary abstract and methodological scope.

## [PR #5895] MODEL_CENTERED_ENERGY_READOUT_AND_NORMALIZED_SINGLE_RATE

### 1. Target and the additional exact information

The target remains the actual lowest-Weil-mode comparison with the SAME
prolate family in Connes, Consani and Moscovici, arXiv:2511.22755v1,
Section 8, distinct from the explicit-model limit in Lemma 7.3. This increment
addresses the normalized observable F(u)(z)/F(u)(0). The normalization removes
global phase and amplitude, but its denominator still needs a certificate.

The current #5602 source at 4b56b742eb5d3bc67e0e1bba3de8457224b4abc9 already
has an origin-normalized fixed-window certificate, with error <51/100000 on
a disk of radius 1/1000 around 20+i/4. It also adds Gamma form-scale moduli.
Those computations and scale results are not repeated or claimed here. The
new result retains an exact annihilation identity in the positive-form
transport and derives a single normalized directional-rate condition.
The actual EnergyDualPaperFT source on #5882 was reread. Its original
unnormalized full-residual limit transport is not redefined.

Loning's #5326 was inspected at PR-description scope for its distinction
between finite boundary evidence and actual limiting functions. The 2026
paper Wu and Zhang, arXiv:2607.23850, was read at primary-abstract scope for
output-specific adjoint error estimation. Its PDE assumptions and error
representation are not imported as Weil theorems. Suzuki, arXiv:2606.09096v1,
retains the localized form-domain/lower-bound distinction used here. The
centered linear functional, positive-form Young estimate and quotient
identity are classical algebraic tools; no priority is claimed.

### 2. Center against the actual model before bounding

Let g0,g_z be the actual Riesz vectors for the origin and target readouts.
The inner product is conjugate-linear in its first entry. For the genuine
unit model e, assume d_e=<g0,e> is nonzero and set

    r_e(z)=<g_z,e>/<g0,e>,
    h_(e,z)=g_z-conj(r_e(z))*g0.

The SAME model appears on both sides of the exact identities

    <h_(e,z),e>=0,
    <g_z,p>/<g0,p>-r_e(z)=<h_(e,z),p>/<g0,p>.             (CE1)

The second identity applies when the actual denominator is nonzero. The
source derives that nonvanishing in the eigenmode consumer below. The complex
conjugation in h is essential. The old complete dual coefficient for g_z is
not automatically a coefficient for h_(e,z); it must be recomputed for this
centered readout, retaining its correlation with g0.

### 3. Multiplicative energy transport with no independent G term

Use the existing actual complex-linear domain maps iota,M and
q(f)=Re<iota(f),M(f)>. Assume symmetry and whole-domain shifted positivity,
unit k, ||e-k||<=eps<1 and q(e)<=nu. Suppose the already-justified new
complement satisfies q(f)>=kap||f||^2 on e-perp, kap>0. Suppose an old
FULL-residual certificate gives

    |<h,f>|^2<=C q(f) on k-perp, C>=0, and <h,e>=0.

For f perpendicular to e, choose

    beta=<k,f>/<k,e>,      v=f-beta e.

The candidate-overlap floor gives |beta|<=eps||f||/(1-eps); v is
k-orthogonal. Crucially <h,v>=<h,f> exactly. The previously proved positive
energy Young inequality gives, for any t>0,

    q(v)<=(1+t)q(f)+(1+1/t)|beta|^2 q(e).

Consequently

    |<h,f>|^2 <= A_t*C*q(f),
    A_t=(1+t)+(1+1/t)*(eps/(1-eps))^2*nu/kap.             (CE2)

This is purely multiplicative. It neither ignores the candidate readout nor
claims it is small: annihilation preserves the entire readout in the change
of hyperplane. No repaired trial's infinite action, model graph norm or new
exact inverse is invoked by this argument.

The original positive-form angle condition

    eps^2*(kappa/2+delta)<=kappa/4,   q(k)<=delta,

already derives kap=kappa/4 from the k-complement gap. With additionally
0<=eps<=1/2 and nu<=kappa/4, t=1 gives A_t<=4. Thus the source proves both

    q(f)>=(kappa/4)||f||^2,
    |<h,f>|^2<=4C q(f),    f perpendicular to e.           (CE3)

Whole-domain shifted positivity is essential. No unshifted all-window Weil
positivity is assumed. The older uncentered readout theorem remains valid;
one cannot delete its G term without changing and certifying the readout.

### 4. Derive the actual eigenmode anchor and normalized error

Let M u=lambda*u with u nonzero, 0<=lambda<kap and q(e)<=nu<kap, where e is
unit. The existing projective Rayleigh theorem and energy identity yield

    p_e=u/<e,u>=e+w,    w perpendicular to e,
    0<=q(w)<=nu,       kap||w||^2<=nu.

For b>0 assume the independently checkable squared origin margin

    b<=|<g0,e>|,
    ||g0||^2*nu<=kap*(|<g0,e>|-b)^2.                     (CE4)

Cauchy-Schwarz then gives |<g0,p_e>|>=b, so <g0,u> is nonzero as well.
Combining this conclusion with CE1-CE2 proves for the actual eigenvector

    |<g_z,u>/<g0,u>-<g_z,e>/<g0,e>|^2
       <= A_t*C*nu/b^2.                                 (CE5)

The raw eigenvector may have any nonzero complex phase and scale. Both
cancel algebraically. The hypotheses supply its eigenpair and spectral
placement; the theorem does not create the eigenvector.

The new moving-domain theorem uses CE3 and proves standard Mathlib
TendstoUniformlyOn for the ACTUAL ratio difference when, on the target set K,

    nu_j*Cbar_j/b_j^2 -> 0.                              (CE6)

The centered coefficient, actual gap/energy and squared origin margins
remain explicit. All Hilbert spaces and operator domains may vary with j.
There is no additional W*eps^2*|F(k)|^2/kappa rate in this bound. This reduces
the sufficient estimate to one correctly centered observable. It does not
prove CE6 for the unbounded arithmetic Weil/prolate family, and a bound on
the old uncentered C does not prove it either. Convergence of the SAME
normalized model functions to Xi(z)/Xi(0) is a separate final input.

### 5. New actual centered full-residual computation

The local interval consumer replays the archived complete-residual verifier
at c=3 on the unchanged finite candidate k and trial v. It uses the same
true aligned prolate model and inherited <1e-23 polynomial model-error cap.
It encloses the true ratio r_e(z) on the complete closed box of half-width
1/100000 around 20+i/4, using the inherited compact-support derivative bound.
All model and spectral premises retain their earlier paper/interval scope.

In the translated Fourier basis the origin representer is g0=sqrt(L)*e0,
L=log(3). Thus centering changes only the finite residual head. Every
nonzero exterior coefficient and the complete uncomputed tail stay exactly
the same, rather than being dropped or refitted.

For R=P_k(g_z-Mv), k real unit, and q=conj(r_e(z))*sqrt(L), the exact head
update is

    ||R-q*(e0-k0*k)||^2
       =||R||^2+|q|^2*(1-k0^2)-2 Re(q*conj(R0)).          (CE7)

The objective changes by -2 Re(r_e(z)*sqrt(L)*v0). Both the direct finite
sum and covariance formula were evaluated and compared. All omitted positive
and negative modes remain in the inherited exterior budget. The resulting
centered coefficient has upper endpoint about 107.800065579058, hence

    C_centered<108.                                      (CE8)

For the archived exact energy numbers use the positive-form gap parameter
s=1/100000 and CE2 parameter t=1/50000. Exact Fraction arithmetic gives
A_t<20001/20000. The true origin floor exceeds 805/1000. With b=39/50,
log(3)<11/10 and CE4, the derived p_e anchor is at least 39/50. The exact
rational guards give

    A_t*108*nu/(39/50)^2 < (9/10000)^2.                   (CE9)

Thus, conditional on the recorded actual domain/spectral/model identities,
the normalized true-mode to SAME prolate-model error is <9/10000 everywhere
on this box. This is a validation of the new centered-energy consumer. It
does not improve #5602's tighter 51/100000 result on a larger disk, produce
a new eigenvalue enclosure, or certify a physical unbounded-scale rate.

### 6. Formal source and validation boundaries

The existing GenuineModelDualTransport Lean/Scribe pair is extended by six
public theorems: model_centered_readout_identity,
annihilating_energy_dual_transport, positive_form_centered_readout_bound,
model_centered_projective_ratio_bound, model_centered_normalized_uniform_limit,
and prime_three_centered_budget. The prior ten declarations remain unchanged.
The new import uses the existing projective Rayleigh proof rather than
reproving the eigenmode identity. The last theorem checks only the exact
rational arithmetic in CE9 and the anchor budget, not its interval premises.

The generic readout theorem can consume the already-identified Fourier Riesz
vector from #5882. This extension does not redefine Fourier transforms or
copy its different unnormalized uniform-limit owner. The concrete analytic
identification, upstream spectrum and model records have not been reverified
by the new interval consumer. The actual unbounded-scale estimate remains CE6.

Executed local diagnostics: 600 exact complex centered positive-form cases,
600 elimination/readout identities, 600 multiplicative bounds, 600 four-C
bounds and 600 full-head covariance checks; 300 exact eigenpair ratio cases
and 900 complex phase/scale checks. All 600 missing-conjugation mutations
were detected. Negative controls retain the need for exact model annihilation,
a coefficient for the CENTERED readout, and an actual denominator margin.
The new full-residual centered consumer was replayed at 100 and 120 decimal
digits with the same rational conclusions. These are single-author checks.

Lean elaboration, kernel acceptance, transitive axiom reports and Scribe
emission have not been executed. The six statements remain logically reviewed
Candidate proof scripts. Exact and interval diagnostics are retained in the
reproduction package; the repository changes only the existing Lean, its
Scribe, and this theory volume. No synthetic scale sequence is presented as
an actual Weil experiment. No all-scale prolate rate or RH conclusion is claimed.

Primary references read in this continuation:

- https://arxiv.org/html/2511.22755v1 , Lemma 7.3 and Section 8.
- https://arxiv.org/html/2606.09096v1 , localized forms and domain distinctions.
- https://arxiv.org/abs/2607.23850 , primary abstract only; output-specific
  adjoint estimation as a methodological comparison, without its PDE premises.
