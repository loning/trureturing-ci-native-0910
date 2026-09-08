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
`Polynomial.Monic.prod_multiset_X_sub_C`, `Polynomial.card_roots'`,
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

## Nonclaims

This probe has not proved m=4, does not claim m=4 is provable by the proposed
route, does not claim exhaustive search, and makes no implication claim about
RH or any larger conjecture. Unopened external pages will be marked
`ASSUMED-UNVERIFIED`.
