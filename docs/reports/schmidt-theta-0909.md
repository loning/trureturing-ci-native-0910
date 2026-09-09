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

## Current Claims And Limits

No target clause has yet been proved or refuted. No new D5 module or public
declaration exists, so `proof_shape`, `escape_witness`, `admission_basis`, and
per-declaration utility are not yet applicable. No hypotheses have been added.
Numerical witnesses and axiom checks remain pending. No completeness of the
search, provability of the target, or implication concerning RH is claimed.
Unopened external pages and unseen reviews are ASSUMED-UNVERIFIED.
