Primary literature: CCM, https://arxiv.org/html/2511.22755v1 , Sections 7-8;
Suzuki, https://arxiv.org/html/2606.09096v1 , the actual form-domain results;
Dusson, Sigal and Stamm, https://arxiv.org/abs/2008.10871 . Classical spectral
approximation is used as a method, with no claim to have proved its intended
unbounded-scale arithmetic instance or RH.

## [PR #5895] POSITIVE_SHIFTED_FORM_RECENTERING_AND_DIRECTIONAL_SCALE_CONTROL

### 1. Additional information already present in the spectral certificate

The preceding graph-residual argument is valid, but its sufficient condition
2*rho*epsilon/((1-epsilon)*kappa)<1 is not a necessary condition for the
actual lowest-Weil-mode/prolate comparison. This continuation uses additional
information: an independently established WHOLE-DOMAIN lower bound A>=ell.
Then M=A-ell is nonnegative. The shift ell may be negative and may depend on
the window; this is not an assumption of unshifted Weil positivity for every a.

The actual target remains CCM, Zeta Spectral Triples, Section 8 and Lemma 7.3:
compare the genuine lowest mode with the same correctly normalized prolate
family. Suzuki, arXiv:2606.09096v1, Sections 1.2 and 2.1, distinguishes the
localized lower-bounded form from its operator realization. Grubisic,
arXiv:math/0503328, studies nonnegative-operator Rayleigh-Ritz estimates and
form-domain test vectors. Its abstract and primary record were read as a
methodological reference; no numbered theorem from that paper is invoked
without checking its hypotheses. The positive-form algebra below is classical.

Current parallel readback: #6029 at 5c2898869032745b06ac30af97181b67243d5e44
now identifies the actual Gamma boundary series with the singular-kernel
integral and transports that identity to the existing exterior column. That
separate analytic bridge is not duplicated. Loning's merged #6044 was inspected
at PR-report scope for its exact hypothesis and coefficient checks; its finite
polynomial root theorem is not a spectral dependency. #5602 was read at
f577bfdff03d4e9e4aa5882272731932481e3c51. Its Neumann-weighted report still has
blob bee31b4b002be2c1cff78a53689232a5d87662b5 and the same global lower,
candidate upper and complement threshold used below. Their underlying
spectral/domain verification was not rerun in this increment.

### 2. Gap transfer with no model-action norm

Keep the actual complex-linear domain maps iota,M, their symmetry, and
q(f)=Re<iota(f),M(f)>. Assume q>=0 on the entire domain, ||iota(k)||=1,
q(k)<=delta, and q(v)>=kappa||iota(v)||^2 on k-perp. Let ||iota(e-k)||<=eps.
No norm bound on M(e) is needed. For f perpendicular to e set

    alpha=<iota(k),iota(f)>,       v=f-alpha*k.

Then v is perpendicular to k,

    ||iota(v)||^2=||iota(f)||^2-|alpha|^2,
    |alpha|^2<=eps^2||iota(f)||^2.

Positivity at t*f+alpha*k, for any t>0, gives the quadratic-form Young bound

    q(v)<=(1+t)q(f)+(1+1/t)|alpha|^2 q(k).

Combining the three statements proves

    q(f)>=kappa_t||iota(f)||^2,
    kappa_t=kappa*(1-eps^2)/(1+t)-delta*eps^2/t.           (PF1)

The sign of kappa_t is checked separately. This result is formalized in the
existing GenuineModelDualTransport owner, reusing its private projection and
energy identities. The previous residual-based theorems are unchanged and
remain useful when whole-domain shifted positivity is unavailable.

The additional positivity premise is essential. A symmetric matrix may
have a positive k-perpendicular compression and small q(k) but an arbitrarily
large mixed block; those two partial facts alone do not imply PF1.

### 3. Transport the directional inequality, without repairing a trial

Suppose the SAME readout g has the existing certified bound

    |<g,iota(v)>|^2<=C q(v),  v perpendicular to k,
    C>=0,                  |<g,iota(k)>|<=G.

For f perpendicular to e, retain both terms in

    <g,iota(f)>=<g,iota(v)>+alpha*<g,iota(k)>.

A second scalar Young parameter s>0 and PF1 give, when kappa_t>0,

    |<g,iota(f)>|^2<=C_(s,t) q(f),

    C_(s,t)=(1+s)(1+t)C
      +eps^2/kappa_t * [(1+s)(1+1/t)C*delta+(1+1/s)G^2].  (PF2)

This directly consumes an energy-dual inequality already justified by a full
residual certificate. It does not state that a new trial has been solved or
that its infinite-support correction vanishes. The old full-residual work
remains necessary to obtain C. The old candidate readout G cannot be dropped:
if g=k, its old perpendicular coefficient can be zero while its readout on
the new perpendicular space is nonzero.

### 4. A different sufficient criterion along unbounded scales

Set s=t=1. If

    eps^2*(kappa/2+delta)<=kappa/4,                        (PF3)

then the new complement has gap at least kappa/4 and the actual readout bound
simplifies to

    |<g,iota(f)>|^2 <= (8C+8eps^2*G^2/kappa) q(f).        (PF4)

Both conclusions of PF4, including the new gap, have proof bodies. The proof
retains the positive mixed-form constraint and uses no rho=||(A-mu)e||.

For the actual projective model error w_a=u_a/<e_a,u_a>-e_a, the existing
energy theorem supplies q(w_a)<=mu_a-ell_a after its eigenpair/normalization
hypotheses are checked. One sufficient spectral condition is
mu_a-ell_a<kappa_a/4, together with existence of the actual lowest eigenpair
and the inherited domain identifications. This places its Rayleigh value
below the transferred complement threshold; PF3 alone does not do so.
Let W_a=|s_a|^2(mu_a-ell_a). Uniformly on a target compact set K, under these
spectral hypotheses the following suffice for the normalized Fourier
error to vanish:

    PF3 eventually,
    W_a sup_(z in K) C_(a,z) -> 0,
    W_a eps_a^2 sup_(z in K) |F(k_a)(z)|^2/kappa_a -> 0.   (PF5)

Indeed the squared error is bounded by eight times each of the two displayed
terms. The ordinary limit/squeeze step is the same one already used by
EnergyDualPaperFT in #5882; it is not redeclared here. These actual arithmetic
rates are not proved by the present finite-window instance. PF3 follows,
for example, from eps_a^2*(1/2+delta_a/kappa_a)->0. The graph-residual product
rho_a*eps_a/kappa_a is absent from this sufficient route. This corrects any
reading of the earlier graph-budget condition as unavoidable for the problem.

### 5. Exact arithmetic with unchanged actual c=3 inputs

The old records give

    ell=2252813807/40960000000000000,
    delta=560909/10000000000000-ell,
    kappa=3/250000-ell,
    eps=113/100000,       C<103,       G<1/500.

The C input is the complete two-sided residual bound, and G is bounded by the
old finite candidate's Fourier modulus on the same closed box of half-width
1/100000 around 20+i/4. The unit genuine model's distance and Rayleigh upper
bound are unchanged. No eigenvalue, model or Fourier computation was refitted.

Choose t=1/100000, s=1/10000. Exact Fraction arithmetic and a Candidate
norm_num proof establish

    kappa_t/kappa > 99997/100000,
    C_(s,t) < 5151/50 = 103.02,
    (mu_upper-ell)*(5151/50) < (681/1000000)^2.             (PF6)

The exact computed coefficient is about 103.016807486639. The gap loss is
about 2.739551983079e-10; the previous graph-residual loss on the same inputs
is about 2.073999739706e-7. Their ratio is strictly between 757 and 758.
This is a comparison of sufficient estimates; the actual spectral gap was
not recomputed or claimed enlarged.

Using the inherited genuine-model Fourier floor 13/10000 on the same box,
PF2 and the existing projective energy estimate give

    |F(p_e)(z)-F(e)(z)|<681/1000000,
    |F(p_e)(z)|>619/1000000,        p_e=u/<e,u>.            (PF7)

PF7 retains the upstream global lower-bound, operator/Fourier, model and
projective-eigenpair premises. It is arithmetic transport of existing
certificates, not an independent replay of their analytic or interval
verification. No additional support window, actual zero count, Xi theorem
or unbounded-scale decay rate is asserted.

### 6. Sources and checks

Only the existing GenuineModelDualTransport.lean, its same-path Scribe, and
this existing theory volume are changed. Four new public statements have
four matching FromLean entries. The earlier six statements remain unchanged.
No new Fourier transform, energy-dual coefficient owner or trial data format
is introduced. Lean elaboration and Scribe emission have not been run; these
are logically reviewed Candidate proof scripts, not kernel-admitted facts.

Executed local exact diagnostics: 600 complex positive-form cases, 600
energy-Young checks, 600 gap checks, 600 transported dual checks and 600
uniform scale-cap checks. The old dual coefficient in these finite tests is
computed by exact Gaussian-rational elimination on the old positive block.
Three negative controls detect a missing whole-domain lower bound, a missing
candidate readout and a dropped candidate-energy term. Thirty-one synthetic
scale cases test the algebra with vanishing gaps; they are not new Weil
spectral certificates. The new fixed-window implications in PF6 were also
checked by exact rational arithmetic. No independent reviewer is claimed.

Primary references inspected:

- https://arxiv.org/html/2511.22755v1 , Sections 7-8.
- https://arxiv.org/html/2606.09096v1 , Sections 1.2 and 2.1.
- https://arxiv.org/abs/math/0503328 , primary abstract and methodological scope.
