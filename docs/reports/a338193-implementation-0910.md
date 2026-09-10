# A338193 implementation, 2026-09-10

## Provenance and scope

Skill: `lean4`; implementation by the single Codex worker in the runner's
`a338193-impl-0910/attempt-1`. No independent review is claimed. The user's
EGF coefficient and quadratic-bridge observations are supplied evidence, not
worker-recomputed evidence. This report is updated during implementation.

Base: `82938786158c163b50350c14c948e63df61107a8` (`origin/dev` at start).
Branch: `lane/math/a338193`. Initial tree was clean. `CLAUDE.md` was read in full.

Question answered: for the independently defined integral-differential EGF A
and Kurkov's natural-valued two-index recurrence f, prove
`n! * coeff n A = f 0 (n-1)` for every `n >= 1`.
Tier: first tier, as assigned. The user's main-entry and six-neighbor reading
found no proof of this equality; worker literature checks are recorded below.

## Preregistered proof route

Use the user's proposed witness: degree-first, row-index-second induction
establishing `F_j = F_0 R^j` for the independently constructed recurrence,
where `R = 1 + x*R + x*R^2`. Then derive the boundary differential equation,
set `B = F_0*(1-x*R)`, and prove `B' = F_0`. The quadratic equation for the
logarithmic derivative must imply the original equation. Prove coefficient
uniqueness before identifying B with A. None of these bridges is a hypothesis
of the target or a definition of either side.

Stop as a note if the formal equation equivalence, infinite-row factorization,
or unit/uniqueness bridge cannot be completed. A blocked report must contain a
real Lean attempt and the remaining goal. No finite positive test is a result.
No theory volume or atom will be created for this task.

## Search receipts

1. D5, `rg -n -i 'schr[oö]der|schroeder|A338193|Kurkov' D5`:
   no Schroeder/Schröder or A338193 match. Kurkov matches occur only in
   `D5/S1/Recurrence/Parity/DyadicPowerRowClosedForm.lean`; its public interface
   still needs reading before ruling out reusable general lemmas.
2. D5 filename and `PowerSeries` searches found recurrence modules including
   `IntegralEGFComposition`, `QuarticEGFFixedPoint`, and
   `PiecewiseConvolutionPowersOfFour`; their general interfaces will be read.
3. The initial worktree has no `.lake`. `make lean-cache-ensure` was launched
   before any Lake invocation. Receipt is in the runner attempt directory,
   `lean-cache.log`.

## Declaration accounting

No new public theorem yet. For each eventual theorem, record `proof_shape`,
direct frozen prerequisites (GID and statement_id), `escape_witness`, and
`admission_basis`. The proposed module classification is `utility: none`:
the intended theorem is quantified over all natural indices, with an algebraic
and inductive proof, and is not a finite computation or a certified instance.

## Unclaimed

No proof, counterexample, integrality theorem, freeze, coverage, successful
build, or PR is claimed at this checkpoint. Pages not opened by this worker
are `ASSUMED-UNVERIFIED` as worker observations. The full target remains open.

## Search checkpoint: exact reusable interfaces

- Cache ensure EXIT=0: `status=seeded`, donor `/Users/chronoai/trureturing`,
  `method=clonefile`, `clonefile_attempts=1`, `stamp_miss=null`,
  `mathlib_olean_state=warm`, `project_olean_state=warm`.
- Pinned Mathlib search for `schr[oö]der|schroeder|A338193` found
  `Mathlib/RingTheory/PowerSeries/Schroder.lean` and
  `Mathlib/Combinatorics/Enumerative/Schroder.lean`. Both files were read fully.
  Exact reuse:
  `PowerSeries.largeSchroderSeries` and
  `PowerSeries.largeSchroderSeries_eq_one_add_X_mul_largeSchroderSeries_add_X_mul_largeSchroderSeries_sq`,
  transported from naturals to rationals by the existing series map.
  The header advertises a small series, but that file's body has no such
  definition. `Nat.smallSchroder` exists with a shifted indexing convention;
  the proof will use the exact large-series interface.
- Read the full public surfaces of `IntegralEGFComposition`,
  `QuarticEGFFixedPoint`, `PiecewiseConvolutionPowersOfFour`, and
  `DyadicPowerRowClosedForm`. General reusable results are `eCoeff_derivative`,
  `eCoeff_mul`, `eCoeff_X_mul`, `encode`, `eCoeff_encode`, `eCoeff_ext`.
  The latter two modules have no applicable public general result for this
  characteristic-zero differential/row problem; their private helper lemmas
  were inspected too.
- Third-party Lean ecosystem, authenticated GitHub code search:
  `gh search code A338193 --language Lean --limit 25` returned `[]`.
  `Schroder` returned Mathlib and copies plus unrelated Schroeder-Bernstein
  uses. No independent A338193 formalization was found in this search scope.
- Fetched and read `https://oeis.org/A338193/internal`. The entry states the
  original integral equation and all three Kurkov recurrences exactly as in
  the brief, and still labels the equality `Conjecture`, dated Oct 26 2024.
  The Kotesovec one-dimensional recurrence is a separate formula.
  Raw response: runner artifact `oeis-internal.html`.
- Capacity: `find D5/S1/Recurrence/Residue -type f | wc -l` returned 11.
  Spec A5.1 confirms the literal header syntax `utility: none`.

## Lean checkpoint: the infinite-row bridge is proved

Warm-tree `lake env lean /tmp/A338193.lean` exited 0. The exact successful
source is saved as `docs/reports/a338193-0910-snippets.lean` at this checkpoint.
This is a symbolic proof for every degree and every row, not finite checking.
It constructs `f` by well-founded recursion on `(m,j)` using exactly the
three OEIS recurrences, encodes each row using the frozen EGF interface,
proves the row series equation, and proves `row_factor` by degree-first and
row-second induction. It then proves `B_derivative : derivative B = F 0`.
No factorization assumption, target-based definition, sorry, or axiom is used.
The original equation equivalence and uniqueness remain to be proved.

Initial Lean attempts exposed two concrete interface errors: scalar
multiplication had to be distributed without expanding the inner `X * (...)`,
and the rational mapped constant coefficient needed `coeff_map` at degree 0.
Both were repaired; the resulting compiler output is empty and exit is 0.

Additional search: arXiv API `search_query=all:A338193` returned totalResults 0.
GitHub's non-Mathlib `rwst/lean-code/unsorted/gf.lean` hit concerns OGFs of
combinatorial classes, not this EGF or the row recurrence. Its full body was
not read: no statement from that file is used (`ASSUMED-UNVERIFIED` beyond the
read interface). D5's two linear ODE uniqueness hits are private, so cannot
be imported as public API. Their public results concern distinct implicit
exponential equations and congruences.

Route command diagnostics were input errors, not mathematical blockers:
absolute manifest paths are rejected, every field must be a string, and
`artifact=lean` is required on plane F. The manifest is now corrected.

## Lean checkpoint: original integral equation and unit bridge

`lake env lean /tmp/A338193.lean` EXIT=0 for the expanded source. Four linter
warnings (redundant change/simp arguments) will be removed before the final
build. The following are now kernel-checked:

- `Original` states the literal formal integral equation using the primitive
  with zero constant term and the two inverse series from the source.
- `original_iff_cleared` proves the integral/differential equivalence, including
  the nonzero constant coefficient of its denominator derivative.
- `original_iff_algebraic` proves equivalence to
  `(1+X)*S*S' - 2*X*(S')^2 - S^2 = 0`, clearing denominators using proved
  `S*S⁻¹=1` and cancellation by the nonzero series `S^3`.
- `B_algebraic` proves B satisfies that polynomial equation.
- `algebraic_iff_linear` identifies the constant-one branch with `D*S'=S`,
  where `D=1-X*R`. The other factor has constant coefficient -1, so cannot
  vanish. This is the unit/branch argument, not a branch assumption.

The all-degree coefficient uniqueness proof and the final choice of A by
`Original` alone are next. Route output is
`D5/S1/Recurrence/Algebraic/SchroderIntegralEGF.lean`; its directory currently
contains one file, below capacity. No canonical D5 file has been created yet.
