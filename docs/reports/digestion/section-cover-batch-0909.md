# Section cover batch, 2026-09-09

## Provenance and scope

- Skill context: no skill invoked; the assigned implementation worker reads the
  tracked probe brief directly. The surrounding runner is supplied by the user.
- Carrier and roles: one Codex implementation worker performs the clause audit,
  writes this report, and invokes the canonical cover and PR commands. There are
  zero independent review seats in this worker's delivery.
- Mixing: sequential audit and self-check. The earlier screening report is an
  input, not an independent approval of these new coverage edges. The user's
  five PIN_MATCH readings are supplied evidence, not worker measurements.

Baseline HEAD and the initially resolved origin/dev are both
`1bb54f920527c303ebaec4e5388d48fcbee0df04`.
Branch: `lane/math/section-cover-batch-0909`.
The complete tracked probe brief, CLAUDE.md, agents/CONTEXT.md, and the screening
report have been read before content changes. The screening report is read from
commit `d43088b76be65982a2fc8270da3c2137ebbea94f`, path
`docs/reports/digestion/section-cover-screen-0909.md` (659 lines).
Its history was inspected with
`git log --oneline origin/dev..origin/lane/math/section-cover-screen-0909`.
The existing untracked `candidates.json` is a supplied input, outside this diff.

## Preregistered decision rule

Read each full atom with `make show-atom ATOM_ID=<64-character basename>`.
Read the nominated frozen declaration through its `:= by`, including definitions
and source context needed to fix the meaning of its symbols. Each boxed clause
and adjacent assertion receives `verbatim`, `equivalent`, or `not-covered`, with
explicit binders, hypotheses, conclusions, endpoint and quantifier checks.
Any unmatched A-group assertion means `verdict: partial` and no cover for that
atom. Only a full match permits a canonical `make cover` call. A successful
writer exit is not evidence of mathematical fidelity.

A group: audit and, only when all clauses match, cover G2, the 5040 open price
interval, and the ordered positive quadruple classification. B group: write
transport dossiers for U1 and dynamics descent; no cover call for either B atom,
regardless of the eventual recommendation. No Lean edits, deposits, or freezes.
Commit and push this report progressively, including after every atom. Open a
PR using `make pr-open`, without `AUTO_MERGE`; this delivery does not claim merge.

## Initial atom inventory

All five paths were located with the user-specified full-basename `find` query.
All have source_id `quantum-rh` and initial directory `residual-open`.

| Group | Atom ID | Initial state | Result |
| --- | --- | --- | --- |
| A1 | `66fd622e5d54c25826af9d416db18df1d8eecf9c71288d80ff0460237e3e95d2` | residual-open | full match; writer pending |
| A2 | `088d882f6a10249e981da5d77bc3bb5e53e75a5ee02313bdd7c879cb21e22413` | residual-open | pending audit |
| A3 | `5f5912050d91b5f8998e6799d12c40e766fa4d65798ff890b506a56c3bc0ed3c` | residual-open | pending audit |
| B1 | `c352d304105e02cbbcb0607e31a1e217adb85d4b344ba0d75c23ba4420dbf0e1` | residual-open | dossier pending; cover prohibited |
| B2 | `7b2657006891568aa395dfd9fa14bde9d9d23d2ade0c449b00f7cdf5c616baec` | residual-open | dossier pending; cover prohibited |

## A1: G2 discriminant

Atom: `66fd622e5d54c25826af9d416db18df1d8eecf9c71288d80ff0460237e3e95d2`.
`make show-atom` returned 0, the complete raw and normalized body, and empty
coverage. The body defines P=a+b, Q=c+d, and D as the discriminant of G1's
quadratic. Its single box contains an equality followed by a non-strict bound;
the adjoining sentence supplies the repeated-input equality case.

Frozen module: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo`.
The actually read state file is
`Golden/Frozen/state/D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean.json`;
its module pin is
`sha256:184c298cb6b3a6b32640e84511f41eede52d8d0d29ae2b24a68f14ef5722487e`.
The two intended declaration GIDs are:

- `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.g2_discriminant_bound`
- `D5/S3/Zeros/Convolution/GribinskiDegreeTwo.discriminant_eq_output`

Read with `git show origin/dev:D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean`:
definitions and both complete signatures through `:= by`, at lines 145-168.
All five binders are `Real`. `g2_discriminant_bound` has no hypotheses;
`discriminant_eq_output` has exactly `alpha != -1` and `alpha != -2`.
The latter are source restrictions, not new assumptions:
`QUANTUM-RH.md:60801-60821` excludes those two values for the entire G1-G4
addendum. This audit directly read that context and the appended correction at
`QUANTUM-RH.md:61194-61232`, which prescribes the product prefactor. `weight`,
`convolutionCoeff`, `boxplus`, `rootPair`, and `kappa` use that corrected meaning.

| Source clause | Lean binders | Lean hypotheses / conclusion | Label |
| --- | --- | --- | --- |
| For all a,b,c,d >= 0; real alpha != -1,-2 from the shared setting | `alpha a b c d : Real` | G2 is valid on all reals and may be specialized to nonnegative roots; the output bridge has precisely the two source exclusions | equivalent |
| P=a+b, Q=c+d, D is the discriminant of G1's output | same five reals | `discriminant_eq_output`: D equals `discrim` of the actual `boxplus` coefficients 2,1,0; `rootPair` is `(X-C a)*(X-C b)` | equivalent |
| Box: D=(P+Q)^2-4ab-4cd-4*kappa(alpha)*P*Q | same five reals | `g2_discriminant_bound ... .1`, expanding P,Q and reassociating addition; `kappa alpha=(alpha+1)/(2*(alpha+2))` | equivalent |
| Box: D >= 2*P*Q*(1-2*kappa(alpha)) | same five reals | `.2.1`: `2*(a+b)*(c+d)*(1-2*kappa alpha) <= discriminant alpha a b c d` | verbatim |
| Adjoining sentence: when a=b AND c=d, equality holds | same five reals | `.2.2`: `a=b -> c=d -> D=2*(a+b)*(c+d)*(1-2*kappa alpha)` | verbatim |

Quantifier and endpoint audit: universal parameters, no existential witness;
non-strict root inequalities include zero; the discriminant bound is non-strict;
alpha is not silently restricted to alpha>-1. The equality sentence is a
sufficient condition, not an iff. Both alpha singular endpoints remain excluded.
There is no extra hypothesis after specializing the stronger scalar theorem.
No assertion of the former ratio-prefactor definition is covered.

Fidelity verdict: full match. Proposed use `proof_shape: bind-only`,
`escape_witness: null`,
`admission_basis: not-applicable(cover of existing frozen declarations)`.
Direct frozen dependencies are the two GIDs above with the recorded module pin;
this does not audit or reclassify the original frozen proof's dependency closure.

Search receipt: `git grep -n -P
'\btheorem\s+(g1_explicit_coefficients|g2_discriminant_bound|discriminant_eq_output)\b'
origin/dev -- D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean` found exactly three
lines, one per declaration. `g1_explicit_coefficients` is the positive control
with the same word-boundary, whitespace and alternation features.
Writer and migration receipts will follow before processing A2.

## Nonclaims

- No claim that `make cover` judges fidelity.
- B-group atoms are not covered by this worker.
- No new theorem, proof, deposit, freeze, or implication to RH is claimed.
- No exhaustive repository or literature search is claimed.
- No independent review or multi-model consensus is claimed.
- Not yet measured at this checkpoint: writer outcomes and PR checks.
