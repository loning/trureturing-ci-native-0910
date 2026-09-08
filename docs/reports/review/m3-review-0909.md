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

## Q2: Escape Witness Four Tests (In Progress)

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

## Q3-Q6

Q1 complete; Q2 in progress; Q3-Q6 pending. No final verdict at this checkpoint.

## Publication

Each completed question and validation is recorded and pushed immediately.
This initial checkpoint preserves the baseline, criteria, and search receipts.
The final result envelope will list the pushed commit SHAs.
