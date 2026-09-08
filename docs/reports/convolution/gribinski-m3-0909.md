# CMP Conjecture 3.13, degree three attempt (2026-09-09)

skill: consensus-rnd:sshx
producer: one codex-cli implementation worker
independent_review: ASSUMED-UNVERIFIED

Scope: second-tier, fixed m=3 and every real alpha > -1, under #6494 / #6160.
The task does not assert the general-m conjecture, a solution of Conjecture
3.13, or worldwide priority. The orchestrator verified only the m=2 interface,
the earlier name-search absence, and the paper quotation/page. All new Lean
and search observations are this implementation worker's own measurements.

## Preregistered Attempt

First attempt: only pinned Mathlib instantiation, frozen projection, and
normalization, including square nonnegativity and `linarith only`. Stop and
report bind-only if that proves the main goal; do not create a content module.
The initial probe is temporary and is not a deposit candidate.

Proposed escape witness, only if the first attempt fails: a quantitative
nonnegative decomposition or bound for the cubic output discriminant over
the full six-root domain and alpha > -1. The exact candidate is
`S^2*T^2 - 4*T^3 - 4*S^3*U - 27*U^2 + 18*S*T*U >= 0`, where
`S = A1+B1`, `T = A2+B2+2*(alpha+2)/(3*(alpha+3))*A1*B1`, and
`U = A3+B3+(alpha+1)/(3*(alpha+3))*(A1*B2+A2*B1)`.
Here Aj and Bj are the elementary symmetric coefficients of the two input
root triples. Definitions and coefficient signs are expected bind-only.

The frozen consumer already found is
`D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.cubic_nonnegative_factorization`.
It requires exactly the three coefficient signs and this discriminant sign.
No reconstruction theorem will be reproved.

Stop criteria: a successful bind-only proof; all five requested steps checked;
or a documented mathematical/cost obstruction after splitting the failed
algebraic block. No heartbeat, recursion, constant, or toolchain changes.
Each completed part is committed and pushed. No PR is to be opened.

## Initial Evidence

Initial worktree: clean, branch `lane/math/gribinski-m3-0909` tracking
`origin/dev`. Lean v4.33.0; Mathlib
`db584cd6d46c92f209a44c0f1c829460d327499d`.
Frozen m=2 module state: `sha256:184c298cb6b3a6b32640e84511f41eede52d8d0d29ae2b24a68f14ef5722487e`.

Repository textual search receipts, before introducing this report:

| Command | Matching lines | Exit |
| --- | ---: | ---: |
| `rg -n '\bGribinskiDegreeThree\b' D5 Blueprint Golden` | 0 | 1 |
| `rg -n '\bg3_nonnegative_roots\b' D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean` | 3 | 0 |
| `rg -n -i '\b(gribinski\|boxplus\|rectangular.*convolution)\b' .lake/packages/mathlib/Mathlib --glob '*.lean'` (alternation uses unescaped pipes) | 0 | 1 |

The same word-boundary feature has a positive control: the pinned Pochhammer
file contains `descPochhammer`, including its evaluation positivity theorem.
These are textual search observations, not semantic completeness claims.

Loogle `Cubic.discr` returned 11 declarations; the available discriminant
root-product theorem assumes splitting and therefore cannot supply splitting
for this output. Literature recheck and complete verification receipts follow
with the implementation results.

## Bind-Only Probe Result

The first restricted attempt failed exactly at the discriminant obligation;
the frozen factorization theorem applied and all three sign obligations closed.
This is failure of this attempted proof, not proof that no bind-only proof exists.
Temporary source and full log are in the runner attempt directory as
`bind-only.lean` and `bind-only.log`. The temporary D5 probe was removed.

Raw Lean diagnostic:

```text
error: D5/GribinskiM3BindProbe.lean:30:4: linarith failed to find a contradiction
case hd
alpha a b c d e f : Real
halpha : -1 < alpha
ha : 0 <= a
hb : 0 <= b
hc : 0 <= c
hd : 0 <= d
he : 0 <= e
hf : 0 <= f
```

The remaining contradiction assumption is exactly the negative of the
preregistered cubic discriminant above; the complete pretty-printed goal is
retained verbatim in `bind-only.log`.

`/usr/bin/time -l make lean`: EXIT=2, last job denominator=12680,
39.22 real seconds, maximum resident set size=3513860096 bytes.
The probe itself was reported as 18s. Cache receipt: status=present,
method=none, project_olean_state=warm, mathlib_olean_state=warm.
The full command builds the requested tree and includes unrelated cached
diagnostics and incremental builds; RSS is not claimed to isolate the probe.

## Step 1

The degree-three definition layer and `definition_consistency` are checked.
`/usr/bin/time -l make lean`: EXIT=0, 12680 jobs, 19.41 seconds,
maximum resident set size=2978545664 bytes (`step1-fixed.log`).
Initial simplification left `-((-1)^3 * cc3) = cc3` unresolved
(`step1.log`: EXIT=2, 18.61s, RSS=2927116288); `norm_num` closed it.

| Declaration | proof_shape | escape_witness | admission_basis | utility |
| --- | --- | --- | --- | --- |
| elementaryCoeff | not-applicable(definition) | none | none | Symbolic degree-three coefficient convention; kind=none |
| weight | not-applicable(definition) | none | none | Product prefactor in Definition 3.10; kind=none |
| normalizedCoeff | not-applicable(definition) | none | none | Symbolic normalization; kind=none |
| convolutionCoeff | not-applicable(definition) | none | none | General coefficient convolution; kind=none |
| boxplus3 | not-applicable(definition) | none | none | Reconstruction of the four coefficients; kind=none |
| rootTriple | not-applicable(definition) | none | none | Three arbitrary real linear factors; kind=none |
| definition_consistency | bind-only | none | none | Definition 3.10 coefficient agreement for arbitrary inputs; kind=none |

`#print axioms definition_consistency`: `[propext, Classical.choice, Quot.sound]`.
Direct frozen dependencies of Step 1: none. No declaration is finite
enumeration, a certified numerical instance, a checker, or a numerical
reduction; all are symbolic definitions or identities. The module is unfrozen
and no deposit admission basis is claimed for this stage.
