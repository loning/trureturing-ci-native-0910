- https://arxiv.org/abs/2607.23850 , primary abstract only; output-specific
  adjoint estimation as a methodological comparison, without its PDE premises.

## [PR #5895] INVARIANT_EVEN_SECTOR_AND_COMPLETE_CENTERED_DISK_BOUND

### 1. Verified prior delivery and the specific next target

The preceding centered-readout work was reread at remote commit
44a831a15abe4d00268d973976101e0d62d66fd2. Its Lean, Scribe and existing
RH theory blobs match the delivered archive. The present increment preserves
that content and continues the actual lowest-Weil-mode/prolate comparison in
Connes, Consani and Moscovici, Zeta Spectral Triples, arXiv:2511.22755v1,
Section 8. The explicit-model limit and actual-mode approximation remain
separate. The moving-scale rate has not been proved by the finite result below.

The same paper's Section 5.2, Lemma 5.2, identifies the matrix involution
V_n -> V_-n and its commutation with the truncated Weil matrix. The actual
domain-level reflection and form-core realization remain required when this
symmetry is used for the infinite operator. Suzuki, arXiv:2606.09096v1,
provides the localized form/Friedrichs-domain context. These are classical
invariant-sector and variational arguments; no priority claim is made.

The latest #5602 sources were read at
5b1c54e84706acdca64e2ec042b51a5d52c5fcea. Its new full-space scale certificate
covers |a-log(3)/2|<=1e-8 with candidate-complement floor 1/200000. Its
prime-activation, Gamma and complete Schur construction is the arithmetic
reference for the independent stronger EVEN-sector test here. Loning's
#5326 and #5296 were inspected at PR-description scope for the importance of
preserving channels and independently certifying boundary readouts. Their
theory descriptions are not used as arithmetic spectral hypotheses.

The preceding centered coefficient paid the old whole-space gap even though
the candidate, trial and centered Fourier readout are even. That can overpay
for a direction invisible to the observable. We therefore certify an actual
even candidate-complement floor and prove exactly when its readout estimate
can be used in the existing whole-space centered transport.

### 2. Exact invariant-sector energy and readout lifting

Let iota,M:D->H be complex-linear maps on an actual linear domain. Let J be
a linear involution on D and U a compatible complex-linear Hilbert isometry:

    J^2=I,  iota(Jf)=U(iota(f)),  M(Jf)=U(M(f)),
    <Ux,Uy>=<x,y>.

Write q(f)=Re<iota(f),M(f)> and

    f_+=(f+Jf)/2,       f_-=(f-Jf)/2.

Domain linearity and inner-product invariance prove

    Jf_+=f_+,  Jf_-=-f_-,  q(f)=q(f_+)+q(f_-).             (IS1)

The identity needs no positivity or gap. If Jk=k and Ug=g, then

    <iota(k),iota(f_+)>=<iota(k),iota(f)>,
    <g,iota(f_+)>=<g,iota(f)>.

Suppose an actual dual certificate on the invariant sector gives

    |<g,iota(v)>|^2<=C_+ q(v),
    Jv=v, v perpendicular to k, C_+>=0.

If q is nonnegative on the opposite sector, then for every f perpendicular
to k, IS1 implies

    |<g,iota(f)>|^2<=C_+ q(f).                            (IS2)

No positive opposite-sector gap appears in this lift. Its nonnegative
SHIFTED energy remains essential. The conclusion concerns the readout,
not a stronger full-space coercivity estimate. Dropping invariance of g,
commutation of the action, or opposite-sector nonnegativity invalidates the
argument; all three have explicit negative controls in the local diagnostics.

For the arithmetic application J is reflection, M=A-ell, and the existing
whole-space lower bound at a=log(3)/2 supplies shifted nonnegativity. The
centered even Riesz vector is invariant because both its Fourier component
and origin component are invariant. The original actual-mode evenness and
Fourier/kernel identification still have their existing analytic scope.

### 3. A complete uniform even Schur certificate

The new verifier independently constructs the actual matrix and exterior
couplings on the whole interval

    |a-log(3)/2|<=1/100000000,    L=2a.                    (IS3)

It uses N=128 retained positive/negative Fourier modes and explicitly sums
both exterior signs through M_cut=8192. The prime-3 term is absent on the
left of activation and present on the right. The diagonal overlap positive
part and the column sine hull retain both cases, including the vanishing
activation value. Gamma, pole, prime-2 and prime-3 contributions remain.
The length enters interval expressions, not a collection of sampled scales.

The original finite positive Gamma resolvent sum gives a uniform full
high-complement floor beta>1; its computed lower endpoint exceeds
1.009070267917372763. The near coupling is enclosed by a dyadic matrix and
an exact two-sided Frobenius error. Young's inequality with parameter 1/20
bounds its full Gram. The complete paired second-jet Gram and its nonzero
far remainder pay every mode beyond 8192. No weighted pairing is substituted
for this Gram or for an unweighted residual norm.

Let G_upper bound the entire low-to-high coupling Gram, and let c be the
same padded finite candidate coordinate vector. On the retained even basis,
the verifier certifies positive definiteness of

    A_low - T_+ I - G_upper/(1-T_+) + c c*,
    T_+=1/1000.                                         (IS4)

The basis is e_0 followed by e_n+e_-n, without an unrecorded unit rescaling.
The rank-one term vanishes on the candidate complement. The complete Schur
argument therefore gives, under the original Fourier/core and high-complement
identifications,

    q_a(f)>=||f||^2/1000
    for all even f perpendicular to the transported candidate,
    at EVERY a in IS3.                                  (IS5)

This is an even candidate-complement bound. The odd sector and the full
candidate complement are not assigned the threshold 1/1000. This increment
also does not prove the historical positive ell is a lower bound throughout
IS3. The normalized readout computation below uses that inherited ell only
at the central physical window a=log(3)/2.

Floating eigenvalues only propose congruence coordinates. Each matrix entry
is enclosed about a 44-bit dyadic center, a 32-bit dyadic congruence is
applied with exact integers, and an exact Gershgorin lower bound certifies
positivity. Its positive bound is

    322613388022726078131097863949363 /
      324518553658426726783156020576256.

This number belongs to the CONGRUENT matrix; it is not reported as the
original operator's gap. The signed radix-20 integer Gram calculation has
explicit overflow guards and was separately compared with object-integer
multiplication on 80 matrices. Both 90- and 120-digit sector runs passed.

### 4. Recompute the actual centered coefficient with the relevant gap

At a=log(3)/2 retain the exact historical ell and the SAME candidate, trial,
genuine model e, and centered readout h_(e,z) from the preceding appendix.
The original complete residual is replayed, including its covariance-corrected
finite head and every exterior mode. The model approximation and original
whole-space spectral records remain inherited analytic premises.

The even trial and even residual can use

    kappa_+=1/1000-ell >999/1000000.

The actual upper data are

    J<=1173667110482754901/10^18,
    R^2<=1273652293764969/10^18.

The new complete coefficient is

    C_+<=J+R^2/kappa_+
       <=100239558744515453640283630281893 /
           40957747186193000000000000000000
       <49/20.                                         (IS6)

It is about 2.4473894594062675. The same centered residual with the old
whole-space gap gave about 107.800065579058. This compares two sufficient
coefficients, not the unknown optimal coefficient or actual Fourier error.
The residual did not become smaller and no high mode was dropped.

The energy-dual theorem is applied on the invariant linear domain. IS2 then
lifts this readout inequality to the whole candidate complement. Crucially,
the OLD global model-recentering factor and origin certificate are retained.
We never substitute T_+ into a theorem requiring full-space coercivity.

### 5. Pay variation on the full complex disk

For a unit genuine model e, nonzero d_e=<g0,e> and any g,g', direct algebra
and Cauchy-Schwarz give

    ||(g'-conj(<g',e>/d_e)g0)-(g-conj(<g,e>/d_e)g0)||
       <=||g'-g||*(1+||g0||/|d_e|).                     (IS7)

The changing model ratio is retained. For supported Fourier kernels and
|Im z|<=251/1000, the full L2 derivative estimate is

    D_F=a*sqrt(2a)*exp(a*251/1000).

The inherited model origin is greater than 805/1000. Directed arithmetic
therefore gives the centered-kernel Lipschitz bound

    D_F*(1+sqrt(2a)/(805/1000))<8/5.

This elementary compact-support integral/derivative specialization remains
paper analysis; its generic centered-vector inequality is a new Lean proof.

On the entire disk |z-(20+i/4)|<=1/1000, the readout-vector variation from
its center is at most 8/5000. The same even-sector coercivity and a second
Young inequality give

    C_disk<=(31/30)*(49/20)+31*(8/5000)^2/(999/1000000)
          =521699/199800 <21/8.                          (IS8)

This is a full-disk statement from an independently bounded derivative,
not a sampled-frequency inference. Every centered readout on the disk stays
in the invariant sector and annihilates the SAME genuine model.

The preceding global model-centering factor is below 20001/20000 and its
derived projective origin lower bound is b=39/50. With the inherited model
energy width nu=929549/15625000000000-ell, exact arithmetic proves

    (20001/20000)*(21/8)*nu/(39/50)^2 <(7/50000)^2.

Consequently, under the recorded actual spectrum, domain and Fourier/model
identifications,

    |FT(u)(z)/FT(u)(0)-FT(e)(z)/FT(e)(0)| <7/50000
    for EVERY |z-(20+i/4)|<=1/1000.                      (IS9)

The genuine model, normalization, physical window and disk are the same as
#5602's earlier origin-normalized certificate with upper bound 51/100000.
IS9 improves that sufficient radius by the factor 51/14, greater than 3.6.
It does not measure the actual error, certify a new Xi zero, increase the
physical window, or improve the full-space ground spectral gap.

### 6. What this changes for the remaining scale problem

The previous single-rate theorem can now consume centered coefficients
certified in the invariant sector and lifted by IS2. The relevant rate is
still

    nu_a * C^circ_(+,a,K) / b_a^2 -> 0.

An opposite-sector small positive gap need not amplify C^circ_+. This is a
structural saving at every scale where the stated invariance, opposite-sector
shifted positivity and complete even-sector certificate hold. It does not
prove how the even threshold, model energy, origin floor or centered trial
quality behave along unbounded physical windows.

The older global spectral placement and positive-form/model-centering
conditions have not disappeared from the complete chain. In particular,
this continuation does not certify them throughout an unbounded family or
replace them by the stronger even bound. The new results consist of a
universal sector-lift proof, an actual full-exterior uniform interval test,
and a quantitatively improved actual same-model disk certificate.

### 7. Sources, executed checks and formalization scope

New Lean owner and paired Scribe:

    D5/S3/Weil/GroundMode/InvariantSectorEnergyReadout.lean
    Blueprint/D5/S3/Weil/GroundMode/InvariantSectorEnergyReadout.scribe.cs

Five public proof scripts cover the actual domain energy split, sector
readout lift, readout-neighborhood budget, model-centered vector variation
and exact rational implications. They introduce no replacement Fourier
transform, canonical zero data, full-space gap or energy-dual definition.
Lean elaboration, transitive axiom reports and Scribe emission were not run.
The operator/domain and interval identities are not automatically kernel
validated by these generic proof bodies.

Two new research programs and their actual outputs are committed under
research/weil_ground_mode/. The sector program is a fresh evaluation of
#5602's complete scale-Schur arithmetic with a different, sector-specific
threshold and its own exact Gram/congruence calculation. The normalized
consumer reuses and reruns this session's earlier centered-residual formulas
with explicit source, trial and model-directory arguments. It checks the
sector result's producer binding but does not rerun that producer internally;
the latter was separately executed in this continuation.

Final sector programs ran at 90 and 120 digits; final readout programs ran
at 100 and 120 digits. The rational sector/readout conclusions agree. Local
exact diagnostics cover 400 complex invariant splits, 400 sector lifts,
400 neighborhood estimates, 400 centered-vector variation checks and 80
signed integer Grams. Three mathematical negative controls test the missing
invariance, commutation and opposite-sector positivity; integer-overflow,
minimum-int64 and noninteger-array inputs are also rejected. Of the centered
phase tests, 369 detect omission of the conjugation. These are single-author
finite checks, not independent proof review or a synthetic Weil experiment.

The arithmetic loader executes only its already inspected AST projection;
complete local input bytes are identified separately and are not claimed
identical to the full remote arithmetic owner. True-prolate and original
global-spectrum verifiers were not rerun. Their selected mathematical fields,
full model-proposal hash and analytic obligations retain the prior scope.

Primary sources reread:

- https://arxiv.org/html/2511.22755v1 , Section 5.2, Lemma 5.2,
  and Section 8's genuine-mode approximation problem.
- https://arxiv.org/html/2606.09096v1 , localized lower-bounded forms
  and the distinction between form cores and operator domains.
- https://arxiv.org/abs/2008.10871 , complete-exterior spectral discretization
  methodology; its Schrodinger assumptions are not asserted for the Weil form.
