# CMP Conjecture 3.13, m = 4: feasibility probe

Repository: https://github.com/the-omega-institute/trureturing

Lane: #6160. arXiv standing issue: #6494. Stage: thinking, probe only.
Branch: `lane/math/gribinski-m4-probe-0909`.
Initial HEAD and observed origin/dev: `1a39ed9516aa510fbf8bf377e26c08c7146b3707`.

Provenance: no skill invoked; one Codex worker performed this probe. No
independent reviewer or multi-model consensus is claimed. The user's report of
the orchestrator's earlier checks is input, not this worker's measurement.

## Preregistration (before Q1 searches, Lean attempts, or symbolic expansion)

Read, in order: `tools/scripts/agent/probe-brief-note.txt`, sections IV and V of
`tools/scripts/agent/standing-math-loop.md` (also read the surrounding document),
then the complete `CLAUDE.md` and `agents/CONTEXT.md`. The existing decisions in
the standing loop are adopted, not reconsidered.

The stopping rules are fixed before running:

1. Q1 succeeds using only pinned Mathlib instantiation, frozen projections and
   normalization (including `sq_nonneg` and `linarith only`): stop, bind-only.
2. Q2 cannot supply a finite necessary-and-sufficient criterion for four
   nonnegative real roots: stop, `blocked-on-criterion`.
3. Q3 measures any one expanded inequality with more than 50,000 monomials:
   stop, `blocked-on-cost`. The m=3 certificate comparator is 20 weighted
   squares plus 767 positive monomials. Do not change the threshold afterwards.
4. Work starts becoming a complete proof: stop for exceeding probe scope.

Order: Q1, Q2, Q3, Q4. A triggered stop cancels subsequent investigation;
unreached questions and measurements will be marked as such in the final
report. Writing and publishing the report remains permitted after stopping.

Proposed escape candidate, not an established witness: an independent
coefficient/minor positivity identity for the m=4 convolution output, derived
from the eight input roots and alpha > -1, and used to discharge a real-root
criterion. Merely projecting `PSD <-> all roots real` does not provide that
identity. No elaborated proof or dependency closure exists at registration.

Scope: no complete m=4 proof, no production D5 module, no deposit, no freeze, no PR,
no `make cover`, no changes to `Meta/Digestion/**`, and no budget changes.
Build probes use `make lean`. Intermediate reports are committed and pushed.

## Initial environment receipt

- `git status --short --branch`: clean, branch as above, initially tracks
  `origin/dev`.
- `git rev-parse HEAD origin/dev`: both return the initial SHA above.
- `rg --files -g 'AGENTS.md' -g 'CLAUDE.md' -g '*Gribinski*'
  -g '*NewtonHankel*' -g 'Makefile' -g '*lean*.sh' -g '*loogle*'
  -g '*leansearch*'`: locates the three Gribinski modules, their frozen state
  paths, NewtonHankelRealRootCriterion and its state path, and the make wrappers.
  File-name discovery does not establish theorem applicability.
- `.lake` is absent before any Lean invocation; cache provisioning must precede
  compilation through the canonical make wrapper.

## Q1 search receipt, batch 1

The following four commands each returned exit 0, at the recorded origin/dev:

```text
git cat-file -e origin/dev:Golden/Frozen/state/D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean.json
git cat-file -e origin/dev:Golden/Frozen/state/D5/S3/Zeros/Convolution/GribinskiDegreeThree.lean.json
git cat-file -e origin/dev:Golden/Frozen/state/D5/S3/Zeros/Convolution/GribinskiDegreeThreeDiscriminant.lean.json
git cat-file -e origin/dev:Golden/Frozen/state/D5/S3/Constants/NewtonHankelRealRootCriterion.lean.json
```

Frozen module identities read directly from those state files (these are module
statement identities, not invented declaration hashes):

| Module GID | state.statement_id | Applicable scope |
| --- | --- | --- |
| D5/S3/Zeros/Convolution/GribinskiDegreeTwo | sha256:184c298cb6b3a6b32640e84511f41eede52d8d0d29ae2b24a68f14ef5722487e | m=2 only; not an m=4 theorem |
| D5/S3/Zeros/Convolution/GribinskiDegreeThree | sha256:c098e8105cd437ddf8df749c21cf1d4725ca6b74faa16e28a5a9f63fbb292c38 | m3_nonnegative_roots, degree 3, six nonnegative roots |
| D5/S3/Zeros/Convolution/GribinskiDegreeThreeDiscriminant | sha256:807caeaa011a567f358eeb34c99a6b586d4980176ef5f8d9a2d9352a1e5ada73 | cubic discriminant numerator on ordered triple coordinates |
| D5/S3/Constants/NewtonHankelRealRootCriterion | sha256:18b030426106ba093ef4ec58fbba090c162f365f32ed6b291aaa0eeba9a358a9 | newtonHankel_posSemidef_iff_roots_real, arbitrary finite conjugation-stable complex root list |

Read the complete GribinskiDegreeThree and NewtonHankelRealRootCriterion source.
The former uses the PRODUCT of falling factorials
`(3)_k (3+alpha)_k`, not their quotient. The latter's matrix is
`Re(sum_j roots[j]^(i+j))/d`, not a coefficient-defined matrix. Its iff assumes
conjugation stability of the support and retains repeated entries. Its
negative-root companion additionally requires strict positive coefficients and
nonzero reversed roots, so it does not directly cover zero roots in this task.

Coarse repository search:
`rg -n '\b(boxplus4|m4_nonnegative_roots|quartic_nonnegative_factorization|newtonHankel_posSemidef_iff_roots_real|m3_nonnegative_roots|GribinskiDegreeFour|Quartic)\b' D5 docs/reports/convolution`.
It locates the known m=3 and Hankel declarations; no proposed m=4 name is found
in that scope. This is a name search, not a semantic nonexistence result.

The m=3 report's lines 168-169 record 20 negative coefficients before repair and
a 20-square subtraction leaving 767 positive monomials. The certificate source
also states 767 positive monomials plus 20 squares. No old proof is rebuilt to
revalidate its frozen truth.

Pinned environment: Lean `leanprover/lean4:v4.33.0`; Mathlib revision
`db584cd6d46c92f209a44c0f1c829460d327499d` from lake-manifest.json.
`make lean-cache-ensure` was started before any Lean command.

External read: `gh issue view 6377 --repo the-omega-institute/trureturing
--json title,body,comments` with a Newton/Hankel/PSD/circularity filter. The
returned issue material records the circular PSD/square-root route and the
quartic counterexample to a single discriminant test. Adopted as existing
decisions; not reproved here. Output was truncated, so no claim is made to have
read every matching comment.

## Q1 search receipt, batch 2

Cache ensure returned exit 0: `status=seeded`, `method=clonefile`, donor
`/Users/auricstudio/trureturing`, one clonefile attempt, both project and
Mathlib olean states warm, no missing Mathlib oleans.

Collision controls, all searched with `rg -n` in `D5` before adding probe code:

| Regex | Matching lines | exit |
| --- | ---: | ---: |
| `\b(boxplus4\|m4_nonnegative_roots\|quartic_nonnegative_factorization\|GribinskiDegreeFour)\b` | 0 | 1 |
| `\b(newtonHankel_posSemidef_iff_roots_real\|m3_nonnegative_roots)\b` | 5 | 0 |
| `\b(GribinskiM4ProbeAbsentControl0909)\b` | 0 | 1 |

The table escapes pipes for Markdown; the executed regex uses ordinary `|`
alternation. Both controls exercise the same word-boundary feature as the
candidate search. These results assert only absence of the searched names.

Pinned searches used
`rg -n -i '\b(quartic|discrim|newton|hankel)\b|real.?root|PosSemidef.*minor|minor.*PosSemidef'`
over Mathlib/Algebra, Mathlib/LinearAlgebra, and Mathlib/RingTheory/Polynomial,
and `rg -n '\b(roots|splits|Splits|of_roots|eq_prod_roots)\b'` on
Algebra/Polynomial/Roots.lean, Analysis/Complex/Polynomial/Basic.lean and
LinearAlgebra/Matrix/PosDef.lean. Hits include quadratic `discrim`,
`Polynomial.prod_multiset_X_sub_C_of_monic_of_roots_card_eq`, `Polynomial.card_roots'`,
`Polynomial.roots_multiset_prod_X_sub_C`, and complex splitting infrastructure.
These do not supply four real roots: the factorization API requires the real
root count already equal the degree. Substring searches remain to be done.

Network capability is present: the LeanSearch homepage was opened, and Loogle
`GET /json?q=quartic` returned `unknown identifier 'quartic'` with suggestion
`"quartic"`. This is a query-syntax failure, not a no-hit receipt. The corrected
quoted query will be used. The CMP v2 PDF has been downloaded, but not yet read.

The exact m=3 raw expansion recorded in its existing report is 787 monomials,
split by t-degree as 310, 257, 168, 52, in sorted-gap variables. This is distinct
from its repaired certificate (20 squares plus 767 positive monomials).

## Q1 search receipt, batch 3

Full pinned Mathlib substring search:
`rg -n -i 'quartic|hankel|newton.*sum|principal.?minor|minor.*possemidef|possemidef.*minor|discrim.*nonneg|nonneg.*discrim' .lake/packages/mathlib/Mathlib -g '*.lean'`.
No quartic/Hankel package was found. The useful hits are Newton identities in
`RingTheory/MvPolynomial/Symmetric/NewtonIdentities.lean`, and characteristic
polynomial coefficients as sums of principal minors in
`LinearAlgebra/Matrix/Charpoly/Coeff.lean`. Subsequent source reads identify
`Matrix.PosSemidef.submatrix`, `Matrix.PosSemidef.det_nonneg`,
`Matrix.IsHermitian.posSemidef_iff_eigenvalues_nonneg`, and
`MvPolynomial.psum_eq_mul_esymm_sub_sum`. These supply identities and
conditional positivity APIs, not positivity of this convolution output.

Online Loogle calls used `curl -L --max-time 30 -sS --get --data-urlencode
'q=QUERY' https://loogle.lean-lang.org/json`. Results: quoted `"quartic"`: 0;
quoted `"Hankel"`: 0; quoted `"Newton"`: 8 (Newton iteration);
quoted `"discrim"`: 40; `Polynomial.roots`: 193. The latter two outputs were
truncated by the tool; only returned visible candidates are claimed as read.
Online indexes are not claimed to use the repository pin.

LeanSearch endpoint was discovered by reading `https://leansearch.net/main.js`.
`POST https://leansearch.net/search` with JSON `num_results: 5` and queries
`quartic polynomial has four nonnegative real roots criterion`,
`Newton Hankel positive semidefinite if and only if polynomial real roots`,
`Sylvester criterion positive semidefinite all principal minors nonnegative`
returned 5 results each. They include cubic root membership, root-count bounds,
Descartes' rule of signs, the definition of PSD and PSD projections. No result
in these 15 supplies the requested quartic or convolution theorem.

Repository substring search `rg -n -i 'gribinski|boxplus|rectangular' D5` also
found `RectangularHalfConvolution.preserves_nonnegative_roots`. Its source
requires `hBB : FiniteSymbolCriterion` and fixes alpha=-1/2. It does not
instantiate the all-real-alpha target.

Third-party search: GitHub tree of `PerAlexandersson/RealRooted`, observed SHA
`cfa0179b010d18d17b0d2eb04483170d96b9495c`, filtered for
Quartic/Hankel/Newton/Gribinski/Convolution/Sylvester. Opened the complete
`RealRooted/RectangularConvolution.lean` at that SHA. Its parameters m,n are
natural numbers; it proves coefficient symmetry/extraction and a degree
bound, not the requested preservation theorem. Other files in the returned
tree were not inspected and are `ASSUMED-UNVERIFIED`.

Opened CMP `https://arxiv.org/pdf/2502.00254v2` (33 pages); `pdftotext` was
unavailable (exit 127), so used installed `pypdf.PdfReader` to extract pages
12 and 13. Definition 3.10, Conjecture 3.13 and Corollary 3.14 were read.
The source at publication only lists nonnegative integer alpha and alpha=-1/2
as proved parameter cases. This is not a current literature-exhaustiveness
claim. Also read #6377 round 3 in full at
https://github.com/the-omega-institute/trureturing/issues/6377#issuecomment-5586693571 .

## Adopted degree-four definition (before symbolic measurements)

For arbitrary p,q in R[X], set

```text
e_k(p) = (-1)^k * coeff(p,4-k), 0 <= k <= 4
w_k(alpha) = (4)_k * (4+alpha)_k
c_k = w_k * sum_{i=0}^k [ e_i(p)/w_i * e_{k-i}(q)/w_{k-i} ]
boxplus4(alpha,p,q) = c_0 X^4 - c_1 X^3 + c_2 X^2 - c_3 X + c_4
(z)_k = product_{j=0}^{k-1}(z-j).
```

This replaces 3 by 4 in each of `elementaryCoeff`, `weight`,
`normalizedCoeff`, `convolutionCoeff`, and `boxplus3`, following the opened
Definition 3.10 exactly. On monic root products c_0=1. The target quantifies
alpha>-1, eight nonnegative input roots, and four nonnegative output roots,
with equality to the product of the four corresponding linear factors.

## Q1 Lean attempt 1: parsing failure, not a mathematical verdict

Temporary probe: `D5/GribinskiM4Probe.lean`, removed before handoff; no production
module or freeze is intended. Command: `/usr/bin/time -l make lean`, output
`attempt-1/q1-bind-only.log`. Exit 2, 16.55 real seconds, maximum RSS
3,185,885,184 bytes, job denominator 12,696. Both caches warm. These are full
make invocation measurements, not isolated Lean theorem costs.

The five `#check` commands above succeeded. The conditional theorem
`conditional_hankel_projection` also elaborated, with axioms exactly
`[propext, Classical.choice, Quot.sound]`. Its proof is just
`(newtonHankel_posSemidef_iff_roots_real roots hc).mp hpsd`: this confirms the
interface works at d=4 WHEN hpsd is supplied; it does not settle Q1.

The existential attempt stopped with `unexpected identifier; expected command`
on the continuation line of `fail_if_success exact ...`. Therefore its intended
`exact?` and `linarith only` attempts had not run. Correct that indentation and
rerun; do not count this parse error as bind-only failure.

Additional criterion source opened: Wikipedia, Sylvester's criterion,
https://en.wikipedia.org/wiki/Sylvester%27s_criterion . The downloaded page says:
"A Hermitian matrix M is positive-semidefinite if and only if all principal
minors of M are nonnegative." It explicitly warns that leading minors alone
are insufficient for semidefiniteness. The first piped read ended early with
curl 56; a subsequent complete download and local read reached this statement
(HTML line 768). Its cited book was not opened.

An attempted source path `D5/S3/Constants/CoefficientNewtonSums.lean` was wrong
(rg exit 2); discovery located `D5/S3/Constants/Moments/CoefficientNewtonSums.lean`.
The invalid-path query is not used as a no-hit receipt.

## Q1 answer: no bind-only success in the attempted scope

Corrected command: `/usr/bin/time -l make lean`, log
`attempt-1/q1-bind-only-fixed.log`, exit 2, 22.67 real seconds, maximum RSS
4,307,386,368 bytes, job denominator 12,696; probe job 14 seconds. Both caches
were warm. The only failing target was `D5.GribinskiM4Probe`.

Actual target and tactics are archived in
`gribinski-m4-probe-0909.lean.txt`. The exact m=3 application and `exact?` each
failed under `fail_if_success`; execution reached the final `linarith only`
with alpha>-1, all eight root signs and their `sq_nonneg` instances. It failed
with `linarith failed to find a contradiction`. The error context retained all
nine hypotheses and goal `False`; it supplied no factorization witnesses.
This is a failed concrete attempt, not a proof that every bind-only route is
impossible. No Q1 success is claimed, and stopping rule 1 has not fired.

The successful conditional Hankel fragment is bind-only, escape_witness=null,
admission_basis=none(probe-only). Its direct frozen dependency is
`D5/S3/Constants/NewtonHankelRealRootCriterion.newtonHankel_posSemidef_iff_roots_real`
under the module state identity recorded above. Five candidate Mathlib API
types were also checked by Lean. The failed existential is not a theorem.

Additional frozen source reads:
`D5/S3/Constants/Moments/CoefficientNewtonSums` has module statement_id
`sha256:2eaa9526bade862a1a821b87daf78426f82845dc681d9a7dc8f637cb255c66c6`;
it supplies `exists_root_enumeration`, Vieta and recursion uniqueness, but its
source explicitly leaves full recursion/root-sum identification open.
`D5/S3/Constants/Moments/CoefficientMultiplicationTraceMoments` has module
statement_id `sha256:387a1805ef12dd72827ef874d8590eacfb09080f13f450aa55ff7946e6b5a47a`;
its header and initial construction concern coefficient-matrix traces with a
complex split factorization, not positivity. These identities do not discharge
the missing output-PSD premise. Their state files were read, not newly written.

After archiving and removing the intentionally failing temporary module,
`/usr/bin/time -l make lean` completed successfully (exit 0, 12,695 jobs).
Log: `attempt-1/q1-cleanup-build.log`; real time 8.61 seconds, maximum RSS
1,173,929,984 bytes, both caches warm. No production Lean change remains.

## Q2 answer: a finite criterion, including repeated and zero roots

For `f(X)=X^4+aX^3+bX^2+cX+d`, define its coefficient Newton sums:

```text
s0 = 4
s1 = -a
s2 = a^2 - 2b
s3 = -a^3 + 3ab - 3c
s4 = a^4 - 4a^2 b + 2b^2 + 4ac - 4d
s5 = -a^5 + 5a^3 b - 5ab^2 - 5a^2 c + 5bc + 5ad
s6 = a^6 - 6a^4 b + 9a^2 b^2 - 2b^3 + 6a^3 c
     -12abc + 3c^2 - 6a^2 d + 6bd
H = [[4,s1,s2,s3], [s1,s2,s3,s4],
     [s2,s3,s4,s5], [s3,s4,s5,s6]].
```

**Iff:** all four roots, with multiplicity, are real and nonnegative exactly
when all 19 conditions below hold. There are 18 nonconstant conditions after
deleting H0. This deliberately redundant principal-minor criterion is not
claimed to minimize the number or expansion cost of conditions.

| ID | Polynomial required to be >= 0 |
| --- | --- |
| C1 | -a |
| C2 | b |
| C3 | -c |
| C4 | d |
| H0 | 4 |
| H1 | s2 |
| H2 | s4 |
| H3 | s6 |
| H01 | 4s2-s1^2 |
| H02 | 4s4-s2^2 |
| H03 | 4s6-s3^2 |
| H12 | s2*s4-s3^2 |
| H13 | s2*s6-s4^2 |
| H23 | s4*s6-s5^2 |
| H012 | 4s2*s4-4s3^2-s1^2*s4+2s1*s2*s3-s2^3 |
| H013 | 4s2*s6-4s4^2-s1^2*s6+2s1*s3*s4-s2*s3^2 |
| H023 | 4s4*s6-4s5^2-s2^2*s6+2s2*s3*s5-s4*s3^2 |
| H123 | s2*s4*s6-s2*s5^2-s3^2*s6+2s3*s4*s5-s4^3 |
| H0123 | det(H) |

`det(H)` is the monic quartic discriminant, explicitly

```text
256d^3-192acd^2-128b^2d^2+144bc^2d-27c^4+144a^2bd^2
-6a^2c^2d-80ab^2cd+18abc^3+16b^4d-4b^3c^2-27a^4d^2
+18a^3bcd-4a^3c^3-4a^2b^3d+a^2b^2c^2.
```

Sources: the opened Sylvester criterion supplies `H PSD iff all principal
minors >=0`; the frozen Hermite--Sylvester iff supplies `H PSD iff all roots
real`, after the Newton identities and scaling are identified. Newton sums
retain algebraic multiplicity, so singular H and repeated roots are included.
For the final sign step, if x<0 write x=-u with u>0. Then
`f(-u)=u^4+(-a)u^3+b*u^2+(-c)u+d>0` under C1-C4. Thus a real root cannot be
negative. Conversely Vieta gives C1-C4 from nonnegative roots. This elementary
sign argument is provided explicitly; no unopened reference is needed for it.

Exactly what the frozen iff covers: it covers the equivalence of the 15
principal-minor conditions AS A GROUP to real-rootedness, once the coefficient
H is connected to its root list. The repository uses `H/4`; a k-by-k minor is
therefore divided by `4^k`, preserving signs. It does not supply any of those
15 inequalities from the convolution inputs and it does not supply C1-C4.
The checked Mathlib submatrix/determinant APIs give the necessity of minors
from PSD, not their sufficiency from the input roots.

Noncircular proposed route: generate H from output coefficients alone; prove
its principal-minor inequalities independently on the eight INPUT roots and
t=alpha+1>0 (for example by an exact weighted-square identity); only THEN
apply the frozen forward direction. Never assume output real-rootedness to
obtain PSD, and never obtain a PSD square root before proving PSD. No such m=4
positivity certificate has been obtained here. The remaining mathematical
gap is the independent positivity implication, not a claimed lack of time.
Rule 2 has not fired.

## Q3 measurement protocol (fixed before running)

Count collected nonzero monomials of the reduced numerator in the polynomial
ring over Q, treating t as a variable; record numerator t-degree and the
positive denominator separately. All counts are exact symbolic counts, not
numerical samples or Lean proof costs. Cancel only denominator factors; do
not discard a factor involving input roots or divide by an expression that
may vanish on the domain.

Primary coordinates match the m=3 certificate's representation:
input roots `(x,x+u,x+u+v,x+u+v+w)` and `(y,y+r,y+r+s,y+r+s+z)`, with all eight
gap/base variables nonnegative and t>0. Every nonnegative quadruple can be
sorted into this form; symmetry of the defining coefficient sums makes this
a legitimate coordinate choice. Also measure the five output coefficients
in unsorted independent root variables, to expose coordinate dependence.

Order: first the m=3 raw discriminant calibration and all m=4 output
coefficients, then C1-C4 and H0,H1,H2,H3,H01,H02,H03,H12,H13,H23,H012,H013,H023,
H123,H0123 in exactly that order. After EACH inequality's complete reduced
expansion, test `monomials > 50000`; on the first hit, record it and exit before
expanding the next inequality. All unreached measurements remain null. The
chosen redundancy means a stop assesses this specified route/representation,
not every possible quartic criterion or compressed certificate.

Installed SymPy 1.14.0 and gmpy2 2.3.1 in a runner-local virtual environment
before calculation. Calculation itself uses offline rational polynomial
arithmetic. No Lean budget or repository budget constant is changed.

## Q3 exact readings

The script was archived as `gribinski-m4-probe-0909-cost.py.txt` in pushed
commit `b954e022df146483128c7ef6270cb211690a85c1` before execution. The command
was (with ATTEMPT denoting the runner directory stated at handoff):

```sh
"$ATTEMPT/sympy-env/bin/python" "$ATTEMPT/cost-probe.py" > "$ATTEMPT/costs.jsonl" 2> "$ATTEMPT/costs.stderr.log"
```

For `A_i=e_i(p)`, `B_i=e_i(q)` and `t=alpha+1>0`, the adopted definition gives:

```text
c0 = 1
c1 = A1+B1
c2 = A2+B2 + 3(t+2)/(4(t+3))*A1*B1
c3 = A3+B3 + (t+1)/(2(t+3))*(A1*B2+A2*B1)
c4 = A4+B4 + t/(4(t+3))*(A1*B3+A3*B1)
              + t(t+1)/(6(t+3)(t+2))*A2*B2
boxplus4 = X^4-c1*X^3+c2*X^2-c3*X+c4.
```

These are exact rational expressions from the falling-factorial definition.
The degrees below refer to the reduced numerator, since a rational function
does not itself have a polynomial t-degree. Numerator content is normalized
to be positive and primitive. Thus H0 is represented as 1/(1/4)=4; this
convention does not change signs or monomial counts.

| Output coefficient | Raw-root monomials | Ordered-gap monomials | Numerator t-degree | Positive denominator |
| --- | ---: | ---: | ---: | --- |
| c0 | 1 | 1 | 0 | 1 |
| c1 | 8 | 8 | 0 | 1 |
| c2 | 56 | 68 | 1 | 4(t+3) |
| c3 | 112 | 200 | 1 | 2(t+3) |
| c4 | 142 | 470 | 2 | 12(t+2)(t+3) |

All numerator coefficients in this table are positive; the polynomial itself
has alternating coefficient signs as displayed above. The raw variables are
`(x,u,v,w)` and `(y,r,s,z)`, each an independent nonnegative input root.

Inequality readings in the preregistered ordered-gap coordinates:

| ID | Monomials | Numerator t-degree | Negative coefficients | Positive denominator |
| --- | ---: | ---: | ---: | --- |
| C1 | 8 | 0 | 0 | 1 |
| C2 | 68 | 1 | 0 | 4(t+3) |
| C3 | 200 | 1 | 0 | 2(t+3) |
| C4 | 470 | 2 | 0 | 12(t+2)(t+3) |
| H0 | 1 | 0 | 0 | 1/4 |
| H1 | 72 | 1 | 0 | 2(t+3) |
| H2 | 1,320 | 3 | 0 | 24(t+2)(t+3)^2 |
| H3 | 8,580 | 4 | 0 | 32(t+2)(t+3)^3 |
| H01 | 40 | 1 | 0 | t+3 |
| H02 | 1,240 | 3 | 0 | 12(t+2)(t+3)^2 |
| H03 | 8,460 | 4 | 0 | 16(t+2)(t+3)^3 |
| H12 | 8,211 | 4 | 17 | 48(t+2)(t+3)^3 |
| H13 | 38,169 | 5 | 0 | 144(t+2)^2(t+3)^3 |
| H23 | pending at this receipt | pending | pending | pending |
| H012 | not yet reached | null | null | null |
| H013 | not yet reached | null | null | null |
| H023 | not yet reached | null | null | null |
| H123 | not yet reached | null | null | null |
| H0123 | not yet reached | null | null | null |

The same script independently reproduced the m=3 raw discriminant numerator:
787 monomials, 20 negative and 767 positive coefficients, t-degree 3, with
t-degree counts `(310,257,168,52)` and denominator `27(t+2)^3`.
The frozen m=3 certificate is **20 weighted squares + 767 positive monomials**.
Raw expanded monomials and certificate blocks are different measurements;
no m=4 certificate is measured here.

## Nonclaims

This probe has not proved m=4, does not claim m=4 is provable by the proposed
route, does not claim exhaustive search, and makes no implication claim about
RH or any larger conjecture. Unopened external pages will be marked
`ASSUMED-UNVERIFIED`.
