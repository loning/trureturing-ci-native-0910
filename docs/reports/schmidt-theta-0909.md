# All-theta coherent-history Schmidt attempt (2026-09-09)

Provenance: no skill invoked by this worker; Codex implementation worker,
one source of judgment, no independent review or consensus claimed. The caller
uses the consensus-rnd/sshx attempt contract. LANE #6160. User-authorized scope:
attempt bind-only first, stop on success or a false source clause, publish a
report and PR without auto-merge. No deposit, cover, or freeze.

## Registered Question And Stop Rules

Question: does atom
`0a350824194cd6312628fc5708116dfece7d0e63fec2a1e2f8c201549d63c707`
follow using only pinned Mathlib instantiation, frozen projections, and
normalization (including `sq_nonneg` and `linarith only`)?

The three obligations are tracked separately:

1. Equation (27), for every real theta, including orthogonality of both
   families of phased occupation-sector states.
2. Theta-independent Schmidt coefficients at every chronological prefix cut;
   equation (29) asserts rank 12 specifically at the 4|4 cut.
3. Orthogonality of the states at theta = 0 and theta = pi/4, separately from
   equality of their cut spectra and entropies.

Stop immediately if bind-only succeeds, a source clause is false, or making
the proof compile would require silently weakening the statement. A local
unitary theorem alone does not prove orthogonality of two different states.

## Baseline And First Readings

- HEAD: `a8809894ea0f1dac06913ed56e09db6223d7ddfa`.
- Branch: `lane/math/schmidt-theta-0909`, initially clean, tracking origin/dev.
- Read `tools/scripts/agent/probe-brief-note.txt`, all of `CLAUDE.md` in
  untruncated segments, and `agents/CONTEXT.md` before acting on the repo.
- Pinned Lean: `leanprover/lean4:v4.33.0`.
- Pinned Mathlib: `db584cd6d46c92f209a44c0f1c829460d327499d`.
- Read the CAS atom bytes. The source defines a cut after beat k into the
  first k and last 8-k registers; it does not quantify over arbitrary real
  cut positions or arbitrary noncontiguous partitions.
- `make show-atom ATOM_ID=<full id>`: exit 2, CLI executable missing in the
  fresh worktree. `make lean-cache-ensure` started through the canonical
  entry point. The show-atom command must be retried after CLI preparation.
- Initial file discovery mentioning `.lake` returned exit 2 because `.lake`
  was absent. This is not a negative Mathlib search result.

## Frozen Interface

GID: `D5/S3/Quantum/Entanglement/CoherentHistorySchmidt`.
State: `Golden/Frozen/state/D5/S3/Quantum/Entanglement/CoherentHistorySchmidt.lean.json`.
statement_id:
`sha256:12fe938e662c8edbaeefb12298e5fc281e7f17595aafd457281a98bd63db1ca1`.

Read the complete Lean source. Its scope is a finite alphabet, an occupation
multiset with `a.card = t + s`, and an unphased uniform word state.
`normalized_coefficient_factorization` and `cut_sector_gram` require that
cardinality equation. `schmidt_coefficient_sq` alone has no such hypothesis;
using it alone would not establish nonzero normalization or positive weights.
`schmidt_coefficient_pos` supplies positivity under the cardinality hypothesis.
`occupation5040` has counts (4,2,1,1) and cardinality 8.
`history_5040_max_schmidt_rank` supplies the maximum and the 4|4 rank, both
for the unphased matrix. No theta quantifier is present in that matrix.

## Repository Search Receipt

Both commands below ran successfully. These are textual candidate searches,
not semantic dependency counts. Both use the same word-boundary, alternation,
noncapturing-group, and wildcard features. The positive control finds the
known coefficient declarations in the frozen source.

```sh
rg -n -i -P '\b(?:\w*schmidt\w*|\w*coherenthistory\w*|\w*singularvalues\w*)\b' D5/S3/Quantum
rg -n -i -P '\b(?:\w*coefficientMatrix\w*|\w*schmidt_coefficient_sq\w*)\b' D5/S3/Quantum
```

The source of `CoherentHistorySchmidt` is an exact unphased hit. Other textual
hits include `SequentialOccupationHistory` and `OccupationPhysicalPreparation`;
their relevance to theta is not yet verified. The full Mathlib search and
bind-only elaboration remain pending at this checkpoint.

## Pinned Mathlib Search Checkpoint

The retry of `make show-atom ATOM_ID=<full id>` exited 0. It printed the
registered raw and normalized SHA-256, identical to the target ID, and
`coverage_gids=[]`. The cache preparation exited 0 with `status=seeded`,
`method=clonefile`, one clone attempt, and both project and Mathlib warm.

Read the source context around equations (20)--(26). The actual phase is
the inversion statistic A of a chronological word, with
`B(u,v) = sum_{i>j} u_i v_j`. The state is normalized by sqrt(840), not
sqrt(5040); 5040 labels the integer with prime exponents (4,2,1,1).

The initial matrix-directory search for
`\b(?:\w*singularValues\w*|\w*singular_values\w*|\w*svd\w*)\b`
returned no matches (exit 1). Discovery located and full reading confirmed
`Mathlib/Analysis/InnerProductSpace/SingularValues.lean`: the interface is
`LinearMap.singularValues`. It defines singular values through the eigenvalues
of the adjoint Gram operator, with nonnegativity and support/rank theorems;
it contains no direct unitary-composition invariance declaration.

Exact usable candidates, read at the pinned version:

| Declaration | Mathlib path | Use at this checkpoint |
| --- | --- | --- |
| `Matrix.IsHermitian.eigenvalues_eq_eigenvalues_iff` | `Analysis/Matrix/Spectrum.lean` | Planned: preserve eigenvalues with multiplicity by charpoly equality |
| `Matrix.charpoly_units_conj` | `LinearAlgebra/Matrix/Charpoly/Basic.lean` | Planned: direct similarity invariance |
| `Unitary.spectrum_star_right_conjugate` | `Algebra/Star/Unitary.lean` | Read; set-valued spectrum alone does not preserve multiplicity |
| `Matrix.rank_mul_eq_left_of_isUnit_det` | `LinearAlgebra/Matrix/Rank.lean` | Planned: preserve rank under a right phase factor |
| `Matrix.rank_mul_eq_right_of_isUnit_det` | `LinearAlgebra/Matrix/Rank.lean` | Planned: preserve rank under a left phase factor |
| `Complex.norm_exp_ofReal_mul_I` | `Analysis/Complex/Trigonometric.lean` | Planned: modulus one for real theta |
| `LinearMap.singularValues` | `Analysis/InnerProductSpace/SingularValues.lean` | Read; no direct use yet |

Positive-control search with the same `-n -i -P`, word boundaries,
noncapturing group, alternation and wildcards found 398 matching lines for
`\b(?:\w*conjTranspose\w*|\w*unitary\w*)\b` in the same two matrix
directories. The narrow singular-value search is not an exhaustive library
search. A first lookup at `LinearAlgebra/Matrix/Spectrum.lean` exited 2;
the discovered and read correct path is `Analysis/Matrix/Spectrum.lean`.
Two early repository searches named nonexistent `D5/S2`, `D5/S3/Ledger`, or
`D5/S3/Algebra`; their exit 2 is recorded and is not evidence of absence.
Subsequent whole-D5 filename and identifier searches found no inversion-word
or q-multinomial interface under the searched names. No absence proof is claimed.

The required actual-history connection is still outstanding: a globally
diagonal unitary need not preserve bipartite Schmidt coefficients. Here the
fixed occupation permits the cross term to be absorbed into a left factor,
but the equality with the source's inversion statistic must itself be checked.

## Probe Run 01 And Numerical Cross-Check

`make lean` exited 2. Log: `lean-bind-01.log` in the runner attempt directory.
The temporary probe used the existing D5 glob solely for elaboration, with no
production header or registration. `phase_star_mul` passed with only
`propext`, `Classical.choice`, and `Quot.sound`. The other statements failed
on matrix notation scope, applying an iff before its parameters, namespace
resolution for `det_isUnit`, and finite-sum normalization. Error-recovery
`sorryAx` in those failed elaborations is not accepted proof evidence.
The statements are retained at their original strength while fixing the script.

An independent Node integer enumeration of the 840 legal words computed the
inversion polynomial coefficients as
`[1,3,7,13,22,33,46,59,71,80,85,85,80,71,59,46,33,22,13,7,3,1]`.
Counts modulo 8 are `[105,105,105,105,105,105,105,105]`.
The remainder modulo `q^4+1` is `[0,0,0,0]`, so evaluation at
`q=exp(i*pi/4)` is exactly zero. This is an integer-computation cross-check,
not a Lean proof of clause 3. No false source clause has been detected.

At k=4, the 12 positive probability numerators over denominator 840 are
`[12,96,48,48,72,144,144,72,48,48,96,12]`; their sum is 840.
The boundary-count sequence is `[1,4,8,11,12,11,8,4,1]`.

## Current Claims And Limits

Run 02 (`make lean`) exited 2. `unitary_rank` now passes with the standard
three axioms. Remaining script errors concern the diagonal entry's
`starRingEnd` spelling, a missing matrix coercion, and normalization of
`Fin.castAdd` order comparisons. The first standalone Node script run exited 1
because a closing `});` was omitted; this syntax error does not supersede the
successful one-shot enumeration above and is being repaired before acceptance.

No target clause has yet been proved or refuted. No new D5 module or public
declaration exists, so `proof_shape`, `escape_witness`, `admission_basis`, and
per-declaration utility are not yet applicable. No hypotheses have been added.
Numerical witnesses and axiom checks remain pending. No completeness of the
search, provability of the target, or implication concerning RH is claimed.
Unopened external pages and unseen reviews are ASSUMED-UNVERIFIED.

## Probe Run 03

`make lean` exited 2 (`lean-bind-03.log`). With the original all-real-theta
statements retained, equation (27), both phased sector Gram identities,
inversion concatenation, and normalization positivity passed with exactly
`propext`, `Classical.choice`, and `Quot.sound`. The matrix factorization and
spectral/rank consumers still failed: overly broad simplification hit recursion
depth; matrix inverse coercion hit the unchanged heartbeat limit; a negative
support branch needed `occupation_append`; the concrete Option alphabet needs
the source order `none < some 0 < some 1 < some 2`. No budgets were changed.

The repaired Node diagnostic exited 0 (`numerical-witnesses.json`). The positive
two-letter witness has occupation (1,1), cut 1|1, two legal words, spectrum
(1/2,1/2), rank 2, and entropy log(2) = 0.6931471805599453 at theta 0 and pi.
The negative witness has occupation (1,0), cut 1|1, no legal words, and
cardinality 1 != 2: totalized matrix rank 0 differs from boundary count 1.
No division or logarithm is evaluated at invalid normalization in the diagnostic.

Additional API readings: `Matrix.charpoly_units_conj'` uses the matrix inverse
of the unit's value, so direct elaboration is not definitional at the adjoint.
The next attempt uses `Matrix.charpoly_mul_comm` and the existing unitary
cancellation instead. `Matrix.toEuclideanLin_eq_toLin_orthonormal`,
`Matrix.toLin_mul`, and `Matrix.toEuclideanLin_conjTranspose_eq_adjoint` give
the matrix-to-operator route to actual `LinearMap.singularValues`.
Two incidental searches exited 2 (a malformed Makefile regexp and a quoted
WithBot wildcard); corrected searches returned the actual definitions above.
Neither error is treated as a negative search result.
