# CMP Conjecture 3.13 at m=3: independent review

Review date: 2026-09-09 (Asia/Singapore).
Audited source: `edcaa0364b401e2a13a4e28bb7bd51ff1dbb5c07`.
Review branch: `review/m3-0909`, created from that detached commit.
Skill context: enclosing runner says `consensus-rnd:sshx`; this reviewer invokes
no skill and works directly as one Codex review worker. No additional agents.
Implementation and Blueprint workers are separate; their observations are not
this reviewer's measurements. Model diversity and their runtime identities are
ASSUMED-UNVERIFIED. No source, Blueprint, freeze, or coverage edits are authorized.

The complete `CLAUDE.md` and `agents/CONTEXT.md` were read. The explicit review
brief governs the pinned checkout, independent revalidation, and report-only
delivery. No fetch, rebase, or implementation branch switch is performed.

Worker artifact directory (`$ATTEMPT` in commands below):
`/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/gribinski-m3-review-0909/attempt-1`.

## Q1: Restricted Proof Attempt

Predeclared criterion: a checked proof using only pinned Mathlib, frozen public
theorem instantiation/projection, and normalization overturns the content claim.
A failed tactic attempt alone does not prove impossibility of all such proofs.
First try the actual frozen cubic factorization API, discharge its coefficient
signs, and test the remaining discriminant with `sq_nonneg`, `linarith only`,
`nlinarith`, and `polyrith`. No new `.lean` file will be created: probe text will
be supplied on stdin through a worker-owned Makefile and the repository's
canonical cache wrapper.

Initial own readings:

| Command | Result |
| --- | --- |
| `git status --short --branch` | `## HEAD (no branch)`, no changes |
| `git rev-parse HEAD` | `edcaa0364b401e2a13a4e28bb7bd51ff1dbb5c07` |
| `git checkout -b review/m3-0909` | EXIT=0 |
| `rg -n -i '\b(gribinski|boxplus|rectangular.*convolution)\b' .lake/packages/mathlib/Mathlib --glob '*.lean'` | 0 matching lines, EXIT=1 |
| `rg -n '\b(polyrith|discr_nonneg|discriminant_nonneg|prod_X_sub_C_eq|descPochhammer_pos)\b' .lake/packages/mathlib/Mathlib/Algebra/CubicDiscriminant.lean .lake/packages/mathlib/Mathlib/Tactic .lake/packages/mathlib/Mathlib/RingTheory/Polynomial/Pochhammer.lean` | 12 matching lines, EXIT=0; includes the same word-boundary feature |

Positive hits include `Cubic.prod_X_sub_C_eq` at CubicDiscriminant.lean:79 and
`descPochhammer_pos` at Pochhammer.lean:471. These are candidate normalization
facts, not a Mathlib convolution-preservation theorem. The name search is not
a proof of semantic absence. Pinned `Mathlib/Tactic/Polyrith.lean:57` throws
an unavailable-tactic error; this will also be tested in Lean.

`FiniteFreeCommutatorDegreeSix.lean:129` explicitly requires
`0 <= a^2*b^2-4*b^3-4*a^3*c-27*c^2+18*a*b*c`. Its statement supplies roots only
after this premise and the three coefficient signs. This identifies the actual
obligation to attack; it does not settle Q1 by itself.

Read-path correction: `sed -n '1,200p' tools/scripts/lean.sh` returned EXIT=1
because that file does not exist. Reading Makefile:27-31 located the actual
wrapper `tools/scripts/worktree/lean-cache-run.sh`; no guessed build was run.

### Q1 Run 0: Import Failure, No Mathematical Result

Command: `/usr/bin/time -l make -f Makefile -f "$ATTEMPT/review.mk"
review-stdin PROBE="$ATTEMPT/q1-direct.txt" > "$ATTEMPT/q1-direct.log" 2>&1`.
EXIT=2, 6.46 real seconds, RSS=697122816 bytes. The wrapper reported project and
Mathlib `warm`, but Lean failed at stdin:1:0 because
`.lake/build/lib/lean/D5/S3/Zeros/Convolution/GribinskiDegreeThree.olean` does
not exist. No tactic ran; this says nothing about bind-only provability.
Next action: run the required `make lean` to build this pinned source, then
retry the independent proof. The build is a Q1 import prerequisite; its own
final-source measurement will also be reported under Q5 without duplicating it.

Additional searches: cubic Mathlib signature scan (`rg -n
'theorem.*(discr|root)|def.*discr|discr.*iff'
.lake/packages/mathlib/Mathlib/Algebra/CubicDiscriminant.lean`) yielded 19 lines,
EXIT=0. `Cubic.discr_eq_prod_three_roots` requires an already-known list of three
roots; `discr_ne_zero_iff_roots_nodup` assumes splitting. Neither directly
discharges the unknown output splitting premise. Repository convolution scan
(`rg -n '\b(cubic_nonnegative_factorization|boxplus|gribinski|rectangularConvolution)\b'
D5/S3/Zeros/Convolution --glob '*.lean'`) yielded 24 lines, EXIT=0, including
the frozen factorization API and the existing m=2 API.

### Q1 Prerequisite Build / Q5 Own Build Reading

`/usr/bin/time -l make lean > "$ATTEMPT/make-lean.log" 2>&1`:
**EXIT=0, 83.76 real seconds, 12681 jobs, RSS=7900758016 bytes**.
The source tree is still the pinned reviewed source. Cache receipt:
`status=present`, `method=none`, project=Mathlib=`warm`. This warm status did
not imply that the two newly reviewed modules were already compiled.
The log reports the discriminant module built in 74s and the main module in
2.5s; final line is `Build completed successfully (12681 jobs)`.
This is an independent local build, not CI or admission approval. Canonical
axiom-report verification remains pending Q5.

### Q1 Run 1: Actual Restricted Proof Results

Command: `/usr/bin/time -l make -f Makefile -f "$ATTEMPT/review.mk"
review-stdin PROBE="$ATTEMPT/q1-direct.txt" > "$ATTEMPT/q1-direct-1.log" 2>&1`.
**EXIT=2, 50.55 real seconds, RSS=2953363456 bytes.**

The independent `frozen_assembly` theorem CHECKED, with axiom closure exactly
`[propext, Classical.choice, Quot.sound]`. It rewrites by
`m3_explicit_coefficients` (a definition/field/ring normalization proved at
main source:86-120), proves the three signs by positivity, and directly applies
the frozen `cubic_nonnegative_factorization`. Its only extra hypothesis is
the exact output discriminant inequality. No candidate content theorem is used.
The subsequent three attempts have the actual `m3_nonnegative_roots` statement
and use this assembly with that one remaining premise to prove.

| Attempt | Own Lean result |
| --- | --- |
| `nlinarith` plus six pair-difference squares and the two input Vandermonde squares | stdin:29:0: `(deterministic) timeout at whnf, maximum number of heartbeats (200000) has been reached` |
| `linarith only [halpha, ha, hb, hc, hd, he, hf, ...same eight sq_nonneg facts...]` | stdin:49:2: `linarith failed to find a contradiction`; target is `False` under exactly `Delta < 0` |
| `polyrith` | stdin:62:2: `` `polyrith` is no longer available, as the external service it relied on has been shut down. `` |

Here `S=A1+B1`, `T=A2+B2+kappa alpha*A1*B1`,
`U=A3+B3+rho alpha*(A1*B2+A2*B1)`, and the remaining assumption printed by Lean is
`S^2*T^2-4*T^3-4*S^3*U-27*U^2+18*S*T*U < 0` with all six roots expanded.
The log retains that full expression and the probe retains the exact commands.
No heartbeat/recursion increase, admitted lemma, or source edit was used.

**Q1 reading:** no successful bind-only proof found. The demanded direct frozen
API plus `nlinarith`/`polyrith` attempt really ran and did not close. The
`linarith only` failure is an unresolved inequality; the nlinarith result is a
resource limit, not a mathematical non-derivability certificate; polyrith is
an unavailable capability, not evidence against the theorem. This finite
search does not prove that no other bind-only proof exists. Q2 must still
assess the claimed new certificate and its live use independently.

## Q2: Escape Witness Four Tests

Run 0 command: `/usr/bin/time -l make -f Makefile -f "$ATTEMPT/review.mk"
review-stdin PROBE="$ATTEMPT/q2-dependencies.txt" > "$ATTEMPT/q2-dependencies.log" 2>&1`.
EXIT=2, 52.59 real seconds. The compiler-semantic traversal completed and emitted
`REVIEW_DEPENDENCIES` from `ConstantInfo.value? (allowOpaque := true)` and
`Expr.getUsedConstants`, before/after `Meta.zetaReduce`, head beta reduction,
constructor projection, and `And.left`/`And.right` on `And.intro`.
The actual certificate and frozen-factorization references survived.
The subsequent synthetic dead-conjunct control failed with `missing control
value`: the review probe omitted `allowOpaque := true` in that control's
theorem-value lookup. This is a reviewer tooling error, not a source failure.
The control must be corrected and rerun before claiming the completed test.

Q2 Run 1 used the same make command with log `q2-dependencies-1.log` after
correcting only the review control. **EXIT=0, 51.74 real seconds,
RSS=3790225408 bytes.** It reports 155 local reachable constants, including
compiler-generated numeral proofs. The dead-conjunct control now reduces to
`fun p q h frozen => frozen`, eliminating `h` as required.
The actual path, both raw and reduced, is:

`m3_nonnegative_roots -> m3_discriminant_nonneg -> ordered_output_discriminant
-> ordered_numerator_nonneg -> ordered_coeffN_nonneg ->
{coeffN_identity, sosN_nonneg}` for **each N=0,1,2,3**.

The main proof also retains the frozen `cubic_nonnegative_factorization` call.
This is an actual path in elaborated theorem values, not an import or textual
name count. Scope: local reachable subgraph, with beta/zeta and constructor/
And projection reduction; it is not a general-purpose proof-shape decision
procedure or exhaustive search for alternative proofs.

Exact algebra audit Run 0: `python3 "$ATTEMPT/q2-certificate.py" >
"$ATTEMPT/q2-certificate.json"` returned EXIT=1 with
`ModuleNotFoundError: No module named 'sympy'`. No polynomial was evaluated.
The one-shot audit parses integer polynomial expressions into an AST and
checks identities/coefficient signs with SymPy; it is supplementary to Lean.
Next action is an isolated `uv run --with sympy==1.14.0 --no-project`, without
changing repository dependencies or claiming this failed run checked anything.

Exact algebra audit Run 1: `uv run --with sympy==1.14.0 --no-project python
"$ATTEMPT/q2-certificate.py" > "$ATTEMPT/q2-certificate-1.json"
2> "$ATTEMPT/q2-certificate-1.stderr"`: **EXIT=0**, stderr empty.
All four identities hold by independent exact integer polynomial arithmetic.
The coefficient support counts, with variables `(x,u,v,y,w,z)`, are:

| t-degree | Expanded monomials | Negative coefficients before decomposition | Weighted squares | Positive remainder monomials |
| --- | ---: | ---: | ---: | ---: |
| 0 | 310 | 0 | 0 | 310 |
| 1 | 257 | 0 | 0 | 257 |
| 2 | 168 | 12 | 12 | 156 |
| 3 | 52 | 8 | 8 | 44 |
| total | 787 | 20 | 20 | 767 |

All square weights and all remainder coefficients are positive integer
polynomials in the nonnegative gaps. This reproduces the worker's count from
the pinned source independently; SymPy is a cross-check, not a trusted axiom.

**Witness chosen for this review:** the nonnegative ordered parameter
coefficients `ordered_coeffN_nonneg`, especially N=2,3, established by the
specific weighted-square decompositions at Discriminant:243-357. A ring
identity alone, or the top-level discriminant inequality renamed as a witness,
would not be enough. The new step is the coefficient-sign construction;
`numerator_expansion` and denominator clearing are normalization.

| Claimed content theorem | (i) Elaborated closure | (ii) Not direct frozen/Mathlib binding | (iii) Not a restatement | (iv) Live use and deletion counterfactual |
| --- | --- | --- | --- | --- |
| `m3_nonnegative_roots` (main:237) | true: compiler path through both discriminant theorems to each coefficient-sign construction | true, semantic assessment: the frozen factorization demands Delta >= 0; Q1 supplied its other premises but no permitted direct attempt supplied this inequality | true: four coefficient inequalities in ordered gap coordinates differ from existence of three nonnegative roots | true: the reduced value retains `m3_discriminant_nonneg` and the frozen factorization call; deleting the sign construction leaves the hD goal in Q1 |
| `m3_discriminant_nonneg` (main:226) | true: reduced path through `ordered_output_discriminant` and `ordered_numerator_nonneg` reaches all four coefficients | true, semantic assessment: sorting and clearing the positive denominator leave new polynomial coefficient signs, including 20 negative expanded terms needing the constructed estimates | true: an individual t-coefficient sign is not the full alpha-dependent discriminant statement; the witness here is not merely `ordered_numerator_nonneg` | true: each sign enters the parameter polynomial and is transported by positive scaling; deleting that construction leaves the cleared numerator inequality |
| `ordered_numerator_nonneg` (Discriminant:360) | true: each `ordered_coeffN_nonneg`, `coeffN_identity`, and `sosN_nonneg` occurs in its compiled transitive value dependencies | true, semantic assessment: no frozen D5 prerequisite exists; the 12/8 weighted-square constructions establish previously unavailable coefficient inequalities | true: the individual coefficient inequalities are distinct from nonnegativity of their cubic polynomial in arbitrary t | true: source:377-382 and the reduced value use all four in nested `add_nonneg`/`mul_nonneg`; none is a discarded conjunction component |

Counterfactual limits apply to **all three** rows: the actual live-use readings
are compiler observations; the absence of an alternative bind-only proof is
a review judgment supported by Q1 and the inspected APIs, not an exhaustive
machine non-derivability theorem. In particular, nlinarith timeout is not used
as a standalone proof of novelty. Finding another direct proof would overturn
test (ii)/(iv) and this assessment.

**Independent proof shape:** the three claimed content results remain
`content` after inlining new prerequisites. Both modules have a supported
`escape-witness` basis under clause 3.2, subject to the independent utility
and fidelity questions still to follow. The six other public theorems remain
bind-only: `definition_consistency`, `convolution_coefficients`,
`m3_explicit_coefficients`, `weight_pos`, `m3_nonnegative_coefficients`,
`nonnegative_rootTriple_coordinates`. Their mechanisms respectively are
coefficient normalization, field/ring normalization, rewriting, direct
`descPochhammer_pos`, sign propagation, and order dichotomy plus gap arithmetic.
The latter constructs coordinates but introduces no new polynomial estimate.

Publication correction: two checkpoint pushes overlapped. The second push
(`0e8c81894f`) returned EXIT=1 with a remote expected-old-ref lock mismatch
after the first (`0ed2c563eb`) succeeded. A sequential ordinary
`git push origin review/m3-0909` returned EXIT=0 and published the descendant.
No force, fetch, rebase, or source change was used.

## Q3: Utility Classification

**Verdict: both `utility: none` classifications are valid.** The test is the
semantic deliverable, not the number of terms, finite proof length, filename,
presence of numerals, or tactic. Bounded enumeration would settle a problem by
exhausting a bounded set of input objects. Certified-instance would establish
the property of a specified concrete input. A checker would export a reusable
certificate-validation/soundness mechanism. Numeric-reduction would leave or
discharge specific numerical bounds as the substantive route to a conclusion.

Here the deliverable is preservation for **every** cubic in the domain and
every alpha > -1, and a universal ordered-gap polynomial inequality supporting
it. All input coefficients/roots remain real variables. The 4 t-coefficients
are the algebraic components of one universal identity; the 787 monomial
support and 20-square decomposition are finite syntax of that proof. There is
no enumeration of input polynomials, roots, alpha values, or bounded search
states, no acceptance predicate/checker API, and no unresolved numerical
threshold. In particular, checking four coefficients by `ring` is not a
coverage argument by sampling four parameter values. Fixed m=3 alone is not
`certified-instance`: G/I/E and computational utility are explicitly orthogonal
in clause 3.3 and spec A5.1:115. No ordinary positive finite instance is being
given a consumer/terminal exemption; no `refutes` claim is needed for `none`.

Per-source-declaration audit (M = `GribinskiDegreeThree`, D = its Discriminant
module; `p` denotes private). Each listed declaration is classified `none`:

| Declaration | Line | Reason |
| --- | ---: | --- |
| M.elementaryCoeff | 36 | coefficient convention for arbitrary polynomial |
| M.weight | 40 | symbolic falling-factorial weight |
| M.normalizedCoeff | 43 | symbolic coefficient ratio |
| M.convolutionCoeff | 47 | algebraic definition for arbitrary input polynomials |
| M.boxplus3 | 52 | polynomial operation, not a concrete output instance |
| M.rootTriple | 57 | three arbitrary real linear factors |
| M.definition_consistency | 60 | arbitrary-input coefficient identity; k=0..3 are coordinates, not enumerated inputs |
| M.kappa | 65 | rational function of arbitrary alpha |
| M.rho | 68 | rational function of arbitrary alpha |
| M.weight_values (p) | 70 | four symbolic product identities |
| M.rootTriple_coefficients (p) | 76 | universal Vieta identity |
| M.convolution_coefficients | 86 | universal rational coefficient formulas |
| M.m3_explicit_coefficients | 110 | symbolic polynomial equality |
| M.weight_pos | 123 | universal domain positivity |
| M.m3_nonnegative_coefficients | 130 | universal sign propagation |
| M.discriminant | 149 | symbolic discriminant definition |
| M.nonnegative_rootTriple_coordinates | 157 | order/coordinate theorem for arbitrary triples; six order cases do not enumerate root values |
| M.discriminant_numerator (p) | 189 | exact rational identity; no numerical premise |
| M.ordered_output_discriminant (p) | 201 | universal ordered-root discriminant inequality |
| M.m3_discriminant_nonneg | 226 | universal discriminant inequality |
| M.m3_nonnegative_roots | 237 | preservation over the whole cubic domain |
| D.numerator | 26 | symbolic polynomial in six variables |
| D.coeff0 (p) | 31 | symbolic parameter coefficient |
| D.coeff1 (p) | 35 | symbolic parameter coefficient |
| D.coeff2 (p) | 40 | symbolic parameter coefficient |
| D.coeff3 (p) | 45 | symbolic parameter coefficient |
| D.numerator_expansion (p) | 49 | universal identity in t and coefficients |
| D.sumRoots (p) | 55 | elementary symmetric expression |
| D.pairRoots (p) | 56 | elementary symmetric expression |
| D.prodRoots (p) | 58 | elementary symmetric expression |
| D.sos0 (p) | 60 | polynomial expression supporting universal inequality |
| D.sos0_nonneg (p) | 128 | sign closure for arbitrary nonnegative gaps |
| D.coeff0_identity (p) | 135 | exact universal polynomial identity |
| D.ordered_coeff0_nonneg (p) | 145 | universal parameter-coefficient inequality |
| D.sos1 (p) | 157 | polynomial expression supporting universal inequality |
| D.sos1_nonneg (p) | 214 | sign closure for arbitrary nonnegative gaps |
| D.coeff1_identity (p) | 221 | exact universal polynomial identity |
| D.ordered_coeff1_nonneg (p) | 231 | universal parameter-coefficient inequality |
| D.sos2 (p) | 243 | symbolic weighted-square construction |
| D.sos2_nonneg (p) | 285 | universal sign of weighted squares and remainder |
| D.coeff2_identity (p) | 292 | exact universal polynomial identity |
| D.ordered_coeff2_nonneg (p) | 302 | universal parameter-coefficient inequality |
| D.sos3 (p) | 314 | symbolic weighted-square construction |
| D.sos3_nonneg (p) | 330 | universal sign of weighted squares and remainder |
| D.coeff3_identity (p) | 337 | exact universal polynomial identity |
| D.ordered_coeff3_nonneg (p) | 347 | universal parameter-coefficient inequality |
| D.ordered_numerator_nonneg | 360 | universal polynomial inequality, not a verifier implementation |

Inventory command: `rg -n '^(private )?(def|theorem) ' <M.lean> <D.lean>`:
47 source declarations (21 definitions, 26 theorems), EXIT=0. This source
inventory is not assumed equal to the canonical inspector's included catalog;
the brief's count of 27 will be checked with the actual report in Q5.

Header check, EXIT=0 (Node reads only the initial Lean comment):

```javascript
const fs = require('fs');
for (const p of process.argv.slice(1)) {
  const lines = fs.readFileSync(p, 'utf8').split('\n');
  const header = lines.slice(0, lines.findIndex(l => l.includes('-/')) + 1);
  const a = header.findIndex(l => /^\s*anchors:/.test(l));
  const d = header.findIndex(l => /^\s*digest:/.test(l));
  const u = header.filter(l => /^\s*utility:/.test(l));
  const ok = d === a + 2 && u.length === 1 &&
    /^\s*utility: none\s*$/.test(header[a + 1]);
  console.log({path: p, anchors_line: a+1, utility_line: a+2,
    digest_line: d+1, utility_lines: u.length, valid: ok});
  if (!ok) process.exitCode = 1;
}
```

Command was `node -e '<above code>' <M.lean> <D.lean>`. Both results:
anchors_line=5, utility_line=6, digest_line=7, utility_lines=1, valid=true.
Spec was read at `docs/develop/spec/golden-ledger-repo-spec.md:111-121`.
This verifies the requested header grammar; it does not claim a full SL-031
or admission run. All extra utility fields are not-applicable(kind=none).

## Q4: Fidelity to CMP Conjecture 3.13 at m=3

**Verdict: (a) true, (b) true, (c) true.** The source was actually opened:

```text
curl --fail --location --max-time 60 --output "$ATTEMPT/cmp-v2.html" https://arxiv.org/html/2502.00254v2
curl --fail --location --max-time 60 --output "$ATTEMPT/cmp-v2.pdf" https://arxiv.org/pdf/2502.00254v2
```

Both EXIT=0. HTML section 2.1 (`S2.SS1.p1`, saved line 296) says:
"the set of monic polynomials (over the complex plane C) of degree n";
`P_n(K)` specifies that **all** roots belong to K. Notation 2.1 gives
`p(x)=sum_{k=0}^n x^(n-k)(-1)^k e_k(p)` and `e_0(p)=1`.
Definition 3.10 (`S3.ThmTheorem10`, saved lines 1233-1244) gives

`e_k(p boxplus_m^alpha q) = W_k * sum_{i+j=k} (e_i(p)/W_i)*(e_j(q)/W_j)`,
where `W_k=(m)_{falling k}*(m+alpha)_{falling k}`.

The PDF was also parsed, not merely downloaded:
`uv run --with pymupdf --no-project python -c
'import pymupdf,sys; doc=pymupdf.open(sys.argv[1]); print("PyMuPDF",pymupdf.VersionBind,"pages",len(doc)); print(doc[12].get_text())'
"$ATTEMPT/cmp-v2.pdf" > "$ATTEMPT/cmp-v2-page13.txt"`, EXIT=0.
PyMuPDF=1.28.2, pages=33. Printed page 13 contains exactly the quoted
Conjecture 3.13, including `alpha > -1` and `R_{>=0}`. Its neighboring result
3.14 addresses alpha=-1/2, not all m and alpha. `pdftotext` was unavailable
(`command -v pdftotext`, EXIT=1); PyMuPDF provided the actual page reading.

### (a) Operation

| Component | Frozen m=2 source | Reviewed m=3 source | Independent comparison |
| --- | --- | --- | --- |
| signed e_k | DegreeTwo:61-62 | main:36-37 | `(-1)^k * coeff(m-k)`, 2 replaced by 3 |
| W_k | DegreeTwo:65-66 | main:40-41 | product of the two falling factorials, same alpha shift |
| normalized coefficient | DegreeTwo:68-69 | main:43-44 | identical ratio |
| i+j=k sum | DegreeTwo:72-74 | main:47-49 | identical `range(k+1)`, j=k-i |
| polynomial reconstruction | DegreeTwo:77-79 | main:52-55 | alternating signs and degree 3, including k=0 and k=3 |

For m=3, W_0=1, W_1=3(alpha+3), W_2=6(alpha+3)(alpha+2),
W_3=6(alpha+3)(alpha+2)(alpha+1), all positive when alpha>-1.
Thus e_0=1, e_1=A1+B1,
e_2=A2+B2+[2(alpha+2)/(3(alpha+3))]A1B1, and
e_3=A3+B3+[(alpha+1)/(3(alpha+3))](A1B2+A2B1).
The two cross ratios are respectively W_2/W_1^2 and W_3/(W_1 W_2).
Every term and sign agrees with Definition 3.10; this is the same family.
The definition's extension to other polynomials or singular alpha is immaterial
to the asserted domain, where all denominators are nonzero.

### (b) All Inputs and (c) Output Membership

The product of three monic linear factors is monic of degree exactly three.
Repeated factors and a factor X (zero root) do not lower that degree. Conversely,
a monic degree-three split polynomial has a roots multiset of cardinality three,
and equals the product over that multiset. No `Nodup`/distinctness or strict
positivity assumption is needed. Although the paper starts over C, a monic
polynomial with all roots real has real coefficients by that same product
formula, so passage to `Real[X]` loses none of `P_3(R_{>=0})`.

Independent Lean check (`q4-fidelity.txt`, no `.lean` edit): define the review
predicate `P3 p := p.Monic /\ p.natDegree=3 /\ p.Splits /\
(forall r in p.roots, 0<=r)`. Pinned Mathlib
`Polynomial.Splits.natDegree_eq_card_roots`, `Multiset.card_eq_three`, and
`Polynomial.Splits.eq_prod_roots_of_monic` directly prove
`P3 p <-> exists a b c >= 0, p = rootTriple a b c`.
The reverse direction checks monicity, exact degree, splitting, and every
root's sign. Applying the reviewed theorem through this equivalence proves
`forall p q, P3 p -> P3 q -> P3 (boxplus3 alpha p q)` for alpha>-1.

Command: `/usr/bin/time -l make -f Makefile -f "$ATTEMPT/review.mk"
review-stdin PROBE="$ATTEMPT/q4-fidelity.txt" > "$ATTEMPT/q4-fidelity.log" 2>&1`.
**EXIT=0, 13.94 real seconds.** All four review theorems
`all_inputs_covered`, `factorization_is_membership`,
`membership_iff_rootTriple`, and `conjecture_at_three` have exactly
`[propext, Classical.choice, Quot.sound]`.
This checks the full Real-polynomial interface; the C-to-R identification above
is the mathematical fidelity argument, not a claimed additional Lean cast lemma.
It establishes exactly the m=3 slice, with every real alpha>-1.

## Q5: Independent Verification and Final Axiom Closures

| Command | Own EXIT | Own real seconds | Evidence |
| --- | ---: | ---: | --- |
| `/usr/bin/time -l make lean` | 0 | 83.76 | `make-lean.log`, built both final reviewed modules, 12681 jobs |
| `/usr/bin/time -l make lean-report` | 0 | 10.27 | `make-lean-report.log`, RSS=255688704 bytes |
| `node "$ATTEMPT/q5-canonical-reading.cjs" > "$ATTEMPT/q5-canonical-reading.json"` | 0 | not measured | full per-declaration own reading, source/hash/provenance checks |

The canonical command reported **`mode=cached`** for the current input address.
This is an own invocation and own reading of its final-source-bound report,
not a claim that this invocation reran the inspector from scratch. The preceding
own `make lean` compiled both reviewed modules and printed their final theorem
closures; no intermediate implementation log was used as an axiom verdict.
No naked `lake build` or `lake env lean` was invoked. Review stdin probes were
also run through make and `lean-cache-run.sh`.

Canonical path: `.lake/build/stratalint/raw-lean-report.json`.
SHA-256: `20b925ef0ef86b656f60079b914364b66292344a31b3ab47ea941c67d6735b09`.
Input address: `sha256:a20ab3bd7c3261e58c6f85f9c399e3b5a3f61e6b30d117bbc35fa45374ae880d`.
Adjacent `.provenance.json` says side=source_side=`candidate`, mode=`cached`.
Both recorded source hashes equal the source bytes read in this worktree:

| Module | Source SHA-256 | Raw declarations | Included | Included theorems | Included definitions |
| --- | --- | ---: | ---: | ---: | ---: |
| main | `f27173bbe2739f8fee728450cad1388f56750656d624610ce90c66f2345d12a6` | 33 | 21 | 12 | 9 |
| Discriminant | `bcbd16debca04f7147021418b09cc0c4cbd34fc33bfd6e02db505d13cbb341b6` | 131 | 26 | 14 | 12 |
| total | | 164 | 47 | 26 | 21 |

**Count correction:** the brief's "27 declarations" is not the declaration
count of these two final modules. The report contains **47 included
declarations**, exactly the 47 named individually in Q3, plus 117 excluded
compiler-generated internal theorems. Every one of the 47 included entries
has exactly `[Classical.choice, Quot.sound, propext]`; all 164 raw entries have
axioms contained in that set. **sorryAx_present=false, unexpected axioms=0.**
This covers all nine public theorems and all seventeen private theorems,
as well as all definitions. No prefix-based axiom assumption is used:
`q5-canonical-reading.json` retains each full name, kind, included flag,
statement_id, and its own axioms from the canonical report.
The implementation report's `added=27` is a retained inspector delta-plan
measurement, explicitly relative to its prior cache, and is not a claim about
the final two-module declaration total. Its old delta run was not rerun here.

Own frozen prerequisite reading:
GID `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.cubic_nonnegative_factorization`,
statement_id `sha256:984112c0a61e8d34b039bb6d01a1e73d4e1f57b7fb36b42fbd569cc818100618`.
Module state pin exists and is
`sha256:c432340052440ba09b56af8739b2dee5b23e520877aa3593410b92b1dbad9daf`;
these are different identities with different meanings.

Required lexical scan, including identical-feature positive control:

```text
git grep -n -P '\bsorry\b|\badmit\b|^axiom |\bnative_decide\b' -- D5/S3/Zeros/Convolution/GribinskiDegreeThree.lean D5/S3/Zeros/Convolution/GribinskiDegreeThreeDiscriminant.lean
git grep -n -P '\bsorry\b|\badmit\b|^axiom |\bnative_decide\b' -- D5/X_Frontier/Hearts.lean
```

Targets: **0 matching lines, EXIT=1**. Positive control: **1 matching line,
EXIT=0**, `D5/X_Frontier/Hearts.lean:76: sorry`. The same `\b` PCRE feature
is exercised. This is only lexical corroboration, not a substitute for the
canonical axiom closures. An initial control at the nonexistent path
`D5/X_Assumptions/Hearts.lean` returned EXIT=1, 0 hits; that was not accepted
as a control. `rg --files D5 -g '*Hearts.lean'` located the correct path above.

`git diff --name-only edcaa0364b401e2a13a4e28bb7bd51ff1dbb5c07` names only
`docs/reports/review/m3-review-0909.md`. Thus the final-source checks address
the pinned audited files, not an intermediate source state.

## Q6

Q1-Q5 complete; Q6 pending. No final verdict at this checkpoint.

## Publication

Each completed question and validation is recorded and pushed immediately.
This initial checkpoint preserves the baseline, criteria, and search receipts.
The final result envelope will list the pushed commit SHAs.
