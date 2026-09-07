- https://arxiv.org/html/2606.09096v1 , Theorem 1.1, Corollary 1.2,
  remarks following Corollary 1.6, and the hypothesis at the start of Section 7.
- https://arxiv.org/abs/2008.10871 .

## [PR #5895] GENUINE_PROLATE_RECENTERING_WITH_FULL_GRAPH_COST

### 1. The precise next step

The preceding moving-scale theorem removes numerical exterior error for a
finite candidate/trial pair. The physical open problem still concerns the
SAME genuine prolate model in Connes, Consani and Moscovici, Zeta Spectral
Triples, arXiv:2511.22755v1, Lemma 7.3 and Section 8. Replacing a finite
candidate by that model changes its orthogonal complement and makes an
exactly repaired trial have infinite Fourier support. The finite-tail theorem
cannot be applied to the repaired trial as though it were still finite.

The present continuation transfers both coercivity and the complete dual
certificate to this genuine model, charging its full Rayleigh residual.
It then executes a fixed-window consumer of the actual model records in
#5602. It does not establish an unbounded-scale rate or a new eigenvalue.

The source audit read #5602 at 6533227479d52ab09d39f39baa4f45720c1fc133,
#6029 at b799d9b9d83663d1ba4b0ec60162c1d94635677d and the actual
CoerciveDualCertificate source from #5882 at
65339a3acbe99e661c6955dbb21728c4c62dfe76. The latest #6029 repair preserves
finite even zero-trace trials and is not duplicated. The new repair below
uses a genuine infinite-support model. Loning's #5326/#5296 descriptions
were read for the distinction between a spectral gap and the boundary or
normalization conditions; they are not imported as spectral hypotheses.

Suzuki, arXiv:2606.09096v1, Theorem 1.1 and Corollary 1.2, supplies the
relevant form-domain/Friedrichs context; mere L2 approximation is insufficient
for an unbounded action. The full-exterior method is also compared with
Dusson, Sigal and Stamm, arXiv:2008.10871. Their Schrodinger hypotheses and
algorithmic conclusions are not asserted for the Weil operator. These
primary versions were retrieved. No claim about uninspected revisions or
priority for classical hyperplane elimination is made.

### 2. Transfer the complement, without postulating a new gap

Let iota,A:D->H be complex-linear maps on an actual linear operator domain,
with symmetry <iota(f),A(g)>=<A(f),iota(g)>. Suppress iota in this discussion.
Let k,e be unit domain vectors, ||e-k||<=epsilon<1, and

    q_A(f)>=T||f||^2 for f perpendicular to k,
    mu=q_A(e)<=T,    r_e=Ae-mu e,    ||r_e||<=rho.

There is no bounded extension of A, global positivity or prior simplicity
assumption. Cauchy-Schwarz gives |<k,e>|>=1-epsilon. For f perpendicular to e,
put beta=<k,f>/<k,e> and h=f-beta e. Then h is perpendicular to k and

    |beta|<=epsilon||f||/(1-epsilon),
    ||h||^2=||f||^2+|beta|^2,
    q_A(h)=q_A(f)+mu|beta|^2-2 Re(beta<f,r_e>).

Applying the old complement bound to h and retaining the nonnegative
(T-mu)|beta|^2 term proves

    q_A(f)>=T_e||f||^2,
    T_e=T-2rho*epsilon/(1-epsilon).                       (GM1)

Thus positivity of the new shifted complement is an explicit checked
consequence when T_e>ell. The new threshold is not a supplied oracle.
For the same selected ground eigenpair, the old candidate enclosure gives
lambda<=q_A(k). The actual data below satisfy q_A(k)<T_e, so the existing
projective enclosure can be applied with e as its candidate.

### 3. Repair the trial and retain its entire infinite action

Write M=A-ell*iota, nu=mu-ell; then Me-nu e=r_e. Let the finite trial v
satisfy <k,v>=0, and put

    beta=<e,v>,     v_e=v-beta e.

It is a domain vector, is exactly e-orthogonal, and usually has infinite
Fourier support. Let P_e(x)=x-<e,x>e, and raw=g-Mv. Direct domain linearity
and unit normalization give the exact identity

    P_e(g-Mv_e)=P_e(raw+beta r_e).                        (GM2)

The nu*beta*e contribution cancels only AFTER the full projection. No
component of r_e may be discarded. Since |beta|<=epsilon||v|| and
||P_e k||<=epsilon, (GM2) gives

    ||P_e(g-Mv_e)|| <= R+epsilon*A0+epsilon*V*rho,          (GM3)

where R>=||P_k raw||, A0>=|<k,raw>| and V>=||v||. R already includes every
omitted Fourier mode, through the previous complete residual certificate.
Only the old raw component A0 is a finite head computation, because k is
finitely supported. This is not an assumption about the support of e.

For J(v)=2 Re<g,v>-q_M(v), symmetry gives the exact signed expansion

    J(v_e)=J(v)-2 Re(beta<g,e>)+nu|beta|^2
                 +2 Re(beta<v,r_e>).

Hence, for J>=J(v) and G>=|<g,e>|, the existing dual coefficient has upper
bound

    C_e(v_e) <= J+P+(R+D)^2/kappa_e,                      (GM4)
    P=2epsilon*V*G+|nu|(epsilon*V)^2+2epsilon*V^2*rho,
    D=epsilon*A0+epsilon*V*rho,
    kappa_e=T_e-ell>0.

The source does not redefine dualBudget. Its final left-hand expression
is precisely the already-owned coefficient. Its consumer is the existing
CoerciveDualCertificate/ProjectiveEnergyDual theorem on #5882. This sibling
module is not copied into the present branch and no missing import is added.

### 4. Consume the SAME true prolate model at c=3

The immutable #5602 records provide the aligned unit genuine evenized
zero-integral model e with

    epsilon=113/100000,
    rho<=458331/5000000000,
    594911359/10^16<=mu<=929549/15625000000000.

The model's full operator residual includes Gamma, pole, prime and parity
terms; it is not a retained Fourier residual. Those input inequalities,
the infinite-prolate identification and actual domain realization retain
their upstream paper/interval scope and are not reverified by JSON parsing.

Using the existing old threshold T=3/250000, exact Fraction arithmetic gives

    T_e=2944818597/249717500000000
       >1179/100000000>mu.

We use the smaller rational threshold 1179/100000000. The old complete
residual verifier is rerun on the unchanged candidate and trial for the full
box |Re(z)-20|<=1/100000, |Im(z)-1/4|<=1/100000. Its results imply

    V<7, R<87/2500, J<6/5.

The newly computed complete candidate pairing on its finite support gives
A0<1/100 on that same box. It is about 0.001359 or less, not an unmeasured
normalization cost. The model readout bound below gives G<1/500, while
|nu|<1/10^8. Equation (GM4) is therefore bounded by the exact rational

    50215304403347426619711856303873 /
      480665586193000000000000000000 <105.                 (GM5)

The weaker constants are deliberate common bounds for the entire box.
No eigensolver or numerical proposal quality is trusted in this transport.

### 5. Actual model Fourier evaluation and uniform box coverage

The program reconstructs the finite polynomial prolate approximant from the
same dyadic proposal, whose full SHA-256 is
242c9897bbd247ef0485039e6dcde819a351c5900ceac52fecc420934c1896db.
It sums the complete piecewise Mellin norm, including all mixed pieces,
and integrates every exponential atom in closed form. At complex frequency,
evenization is (F(z)+F(-z))/2; taking the real part would be incorrect.
The negative alignment sign and unit normalization match the old candidate.

The true normalized model differs from this polynomial approximant by less
than 1/10^23, as a conservative rational cap on the inherited model record.
At z0=20+i/4 the newly computed polynomial transform is approximately

    0.00124940159701578645 - 0.00040685776497538800 i.

For any unit L2 function supported on [-a,a], a=log(3)/2, direct
Cauchy-Schwarz gives on this box

    |F'(z)|<=a*sqrt(2a)*exp(a*25001/100000)<2/3.

This compact-support derivative inequality follows by differentiation under
a bounded exponential integral. Its specialization is paper analysis here;
it is not silently reported as an executed Lean theorem. A box point is
within (3/2)/100000 of z0. Paying this entire variation and the true-model
approximation error proves the uniform genuine-model bound

    13/10000 < |F(e)(z)| < 1/500.                          (GM6)

The directed lower enclosure is greater than 0.001304070128285594.
The same selected eigenmode can now be aligned against e:

    p_e=u/<e,u>.

The existing projective energy theorem, with candidate e and its transferred
threshold, gives error energy <=mu-ell. Combining (GM5) with its dual
readout theorem and exact arithmetic gives throughout the entire box

    |F(p_e)(z)-F(e)(z)| <7/10000,
    |F(p_e)(z)| >3/5000.                                 (GM7)

This directly compares the actual aligned mode to the genuine model. It
has a different normalization from the earlier p_k=u/<k,u> statement.
The constants are not presented as an improvement over its 1/1000 modulus
floor, a larger zero-free region, a new eigenvalue enclosure or a Xi result.

### 6. What now has to scale

For varying windows let kappa=T-ell and d=2rho*epsilon/(1-epsilon). Then
kappa_e=kappa-d. A dimensionless condition d/kappa<1 is now sufficient for
the moved complement. Merely epsilon->0 is not enough if rho/kappa grows.
All six new proof statements allow arbitrary domains, operators and scales;
no favorable asymptotic dependence is inserted into them.

The exact scalar comparison of the sufficient coefficients is

    J+P+(R+D)^2/(kappa-d)
      = (J+R^2/kappa)+P+(2RD+D^2)/(kappa-d)
          +R^2*d/(kappa*(kappa-d)).                       (GM8)

Thus the additional model cost is displayed separately from the old finite
trial coefficient. To transfer a candidate-centered directional rate to
the genuine family one must control the normalization-weighted energy width
times the extra terms in (GM8), and retain positivity of kappa-d. The prior
moving-scale schedule controls the numerical part of R, not the genuine
rho or epsilon. The present c=3 success supplies no proof that these physical
quantities have the required behavior on an unbounded scale sequence.

### 7. Source and computation status

New owner: D5/S3/Weil/GroundMode/GenuineModelDualTransport.lean, with six
public theorem statements and matching FromLean Scribe handles. The content
is domain-level elimination, projection and complete-residual control. It
has actual proof bodies, not a supplied new-complement or repaired-residual
bound. Lean elaboration, transitive axiom reports and Scribe emission were
not run. No independent proof reviewer or machine-admission verdict is claimed.

The executed consumer and regression are

    research/weil_ground_mode/certify_prime3_genuine_model_dual.py
    research/weil_ground_mode/test_genuine_model_transport.py

with their two JSON outputs. The prior full-residual transport is replayed;
the original upstream spectral/prolate/graph verifiers are not. The three
model inputs were used as selected mathematical-field projections transcribed
from the cited remote records. Their semantic hash is reported. They are not
claimed to be full upstream file bytes. The prolate proposal itself matches
the complete upstream SHA. The local execution excerpt and input projections
are retained only in the reproduction archive, not installed as shadow owners.

800 exact Gaussian-rational Hermitian cases checked coercivity transfer,
full residual identities, signed objectives and complete coefficient bounds.
799 wrong-conjugation mutations were detected. Four explicit controls show
that omitting the model action can return a zero residual where the actual
repaired residual is nonzero. The 100- and 120-digit interval replays pass
identical rational margins. Changed distance, alignment, full model action,
proposal, owned verifier and insufficient precision are rejected. Python -O
was separately checked and rejected before consuming upstream assertions.
These finite checks do not replace the universal Lean proofs or the inherited
analytic premises.

For reproduction, pass --model-dir pointing to the #5602 research directory
at the immutable commit above, containing the proposal and the model, full
energy and full operator-residual certificate JSONs. The existing full-tail
verifier, arithmetic source and trial can be supplied explicitly by their
CLI options. No extra canonical copy of another session's work is created.

Primary literature: CCM, https://arxiv.org/html/2511.22755v1 , Sections 7-8;
Suzuki, https://arxiv.org/html/2606.09096v1 , the actual form-domain results;
Dusson, Sigal and Stamm, https://arxiv.org/abs/2008.10871 . Classical spectral
approximation is used as a method, with no claim to have proved its intended
unbounded-scale arithmetic instance or RH.
