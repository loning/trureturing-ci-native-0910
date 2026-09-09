---
slug: oeis-a394454-central-binomial-prime-divisors
bibkey: oeis2026a394454
doi: null
url: https://oeis.org/A394454
triage: theorem
motivation_gids: []
---

# Prime divisors of central binomial coefficients

## Problem

OEIS A394454, "Sum of distinct prime divisors of C(2*n, n)", records:
"Conjecture: for every prime p, the set {n >= 1 : p divides C(2*n, n)} is infinite."
The target is exactly `{n : Nat | 0 < n and p divides Nat.choose (2*n) n}.Infinite`
under the sole hypothesis that `p` is prime.

## Motivation

The implementation brief of September 9, 2026 nominates this as a first-tier
OEIS comment conjecture. Its mathematical novelty is not claimed: the proposed
argument is a direct corollary of Kummer's carry criterion.

## Gap

The first required test is bind-only reconstruction from pinned Mathlib and
frozen projections. A successful reconstruction ends this lane without a new
Lean module or freeze. This reconstruction succeeded through Catalan
integrality. The exact target was checked in an external probe; no D5 module
or frozen node is being deposited.

## Route

The proposed family is `n = (p-1)*p^k`. The preregistered candidate escape
witness is its remainder at `p^(k+1)` together with the non-strict carry bound.
This proposed escape witness is unnecessary: the target has a bind-only proof
through a different infinite family.

The alternate bind path is now explicit: `Nat.frequently_modEq hp.ne_zero
(p-1)` supplies an infinite residue class; `Nat.eventually_pos` removes zero;
`Nat.ModEq.add_right` and `Nat.sub_add_cancel hp.one_le` give `p` dividing
`n+1`; divisibility transitivity with `Nat.succ_dvd_centralBinom n` gives
the requested conclusion. `Nat.frequently_atTop_iff_infinite` converts to
the exact `Set.Infinite` form. No novel intermediate proposition is proposed
for this path.

## Falsifier

A prime for which the displayed set is finite would refute the target.
The requested sanity checks are `C(4,2)=6` divisible by three and `C(2,1)=2`
not divisible by three. Both conjunctions were checked by Lean's `decide`.
Additional kernel checks gave `C(0,0)=1` not divisible by three and
`C(2,1)=2` divisible by two. The prime-two specialization of the infinite-set
theorem and the stronger `2`-divisibility statement for every positive index
were checked separately.

## Evidence

Source baseline: `d527e3081957dbd440ca634d821e98b868abf534`, verified by
`git rev-parse HEAD`. The worktree was initially clean. `CLAUDE.md`, both
agent brief notes, and `agents/CONTEXT.md` were read. The three named nearby
Lean templates and PR 6575's complete file list and body were read.

Initial repository search:
`rg -n -i 'central.?binom|A394454|factorization_choose|emultiplicity_choose'
D5 Meta/Digestion Library Problems --glob '*.lean' --glob '*.md' --glob '*.yaml'`
returned two lines, both in `ShankarQStieltjesRefutation.lean`; these use
Catalan identities and do not state prime-divisor infinitude. Broader `lucas`
searches mostly matched Fibonacci-Lucas material and do not establish coverage.
The existing `Factorization` domain was confirmed with
`git ls-tree origin/dev --name-only D5/S3/`.

Environment discrepancy: the brief says cache ensure was done, but the worker
observed no `.lake` directory. `make lean-cache-ensure` was started before any
Lean command. The toolchain is Lean 4.33.0; Mathlib is pinned to
`db584cd6d46c92f209a44c0f1c829460d327499d`.

Cache ensure completed with exit zero: `status=seeded`, `method=clonefile`,
`clonefile_attempts=1`, both project and Mathlib olean states warm, zero missing
Mathlib oleans. The actual Mathlib checkout SHA matches the manifest.

The worker opened the OEIS JSON endpoint
`https://oeis.org/search?q=id:A394454&fmt=json`; it returned both quoted
comments verbatim, revision 29, author Vincenzo Librandi, March 21, 2026.
Authenticated GitHub code searches for `"A394454" language:Lean` and
`"centralBinom" "Infinite" language:Lean` returned empty result arrays.
These are bounded searches, not an exhaustive literature survey.

The public signatures in pinned `Data/Nat/Multiplicity.lean`,
`Data/Nat/Choose/Lucas.lean`, and `Data/Nat/Choose/Factorization.lean` were
read. The brief's Kummer location/name is inaccurate at this pin:
the declaration is `Nat.factorization_choose` in `Choose/Factorization.lean`,
not `Nat.Prime.factorization_choose` in `Multiplicity.lean`.
`Nat.Prime.emultiplicity_choose` is in `Multiplicity.lean`.
`Nat.Prime.dvd_iff_one_le_factorization` requires the binomial coefficient
to be nonzero. The carry predicate is non-strict, as the brief states.

The decisive additional hit is `Nat.succ_dvd_centralBinom` in
`Data/Nat/Choose/Central.lean`. Searches for `dvd_centralBinom` and
`centralBinom.*dvd` in all pinned Mathlib also found the two-divisibility
specializations and their uses in the Catalan file. The `frequently_modEq`
and `frequently_atTop_iff_infinite` declarations were located in
`Order/Filter/AtTopBot/ModEq.lean` and `Order/Filter/Cofinite.lean`.

Word-boundary control: `rg -n '\bA394454\b' D5 Meta/Digestion Library
--glob '*.lean' --glob '*.md' --glob '*.yaml'` returned zero lines before
this report's Library note was added; `rg -n '\bA091259\b'
D5/S3/Factorization/A091259.lean` returned eight lines using the same regex
feature. These are literal-name controls, not a semantic noncoverage proof.
The broader binomial searches above address alternate spellings and objects.

The complete main proof in the successful probe is:

```lean
import Mathlib.Data.Nat.Choose.Central
import Mathlib.Data.Nat.Prime.Defs
import Mathlib.Order.Filter.AtTopBot.ModEq
import Mathlib.Order.Filter.Cofinite

open Filter

theorem infinite_dvd_centralBinom (p : ℕ) (hp : p.Prime) :
    {n : ℕ | 0 < n ∧ p ∣ Nat.choose (2 * n) n}.Infinite := by
  apply Nat.frequently_atTop_iff_infinite.mp
  apply ((Nat.frequently_modEq hp.ne_zero (p - 1)).and_eventually Nat.eventually_pos).mono
  intro n hn
  refine ⟨hn.2, ?_⟩
  have h : Nat.ModEq p (n + 1) p := by
    simpa only [Nat.sub_add_cancel hp.one_le] using hn.1.add_right 1
  exact (Nat.modEq_zero_iff_dvd.mp (h.trans Nat.modulus_modEq_zero)).trans
    (Nat.succ_dvd_centralBinom n)
```

Validation: `lake env lean <attempt-1>/BindOnly.lean`, run only after the
canonical cache ensure reported warm, exited zero. It checked the exact
theorem and all six anonymous boundary/numerical checks. The printed axiom
closure is `[propext, Classical.choice, Quot.sound]`; no `sorry` or private
axiom occurs. The attempt directory is
`/var/folders/wv/ht3wzsj138b4sxl3q4t0xdr40000gn/T/consensus-rnd/sshx/a394454-impl-0909/attempt-1`.
The probe and runner stdout retain the executable proof and compiler output.

## Triage

For the sole named public theorem, `infinite_dvd_centralBinom`:

- `proof_shape: bind-only`.
- `direct_frozen_dependencies: none` (GID and `statement_id`: none).
  The probe imports only pinned Mathlib, which is not a D5 frozen prerequisite.
- `escape_witness: null`.
- `admission_basis: none`; the user expressly requires stopping on bind-only,
  so no upstream-wrapper exception is invoked.
- `added_hypotheses: []`; all quantifiers and the positive-index condition
  match the source exactly.

The local congruence `h` is an instance of `Nat.ModEq.add_right` followed by
the library rewrite `Nat.sub_add_cancel`; it fails escape condition (ii).
The proposed carry calculation is absent from the elaborated proof's
dependencies, so fails (i), and is not on its live path, so fails (iv).
Although a carry statement differs from the target as required by (iii),
that alone cannot make it an escape witness. Infinitude itself comes from
the existing residue-class theorem and filter combinators. There is no new
estimate, induction, construction, or decision-procedure arithmetic in the
main proof. The anonymous numerical checks are probe controls, not deposits.

No atom ID was supplied, so `show-atom` and atom coverage are not applicable
to this explicit OEIS target. No Scribe, generated Blueprint, or frozen ledger
file was created. The implementation gate sequence (`make lean` with
`LAKE_JOBS=3`, report, ledger, emit, PR) was not entered because the first
hard requirement terminates implementation on the successful bind-only test.
Only this report and its Library source note are committed and pushed;
no PR or merged-deposit claim is made.

Provenance: Codex implementation worker in the runner's `consensus-rnd:sshx`
implementation stage, using the `lean4` skill. One worker performs the reads,
proof checking, and report writing; no independent review or model diversity
is claimed. The orchestrator's numerical readings are supplied evidence and
are not reported as this worker's measurements.

## ASSUMED-UNVERIFIED

The OEIS page was independently opened; a targeted published-literature survey
has not been completed. First-publication priority, absence of a published proof,
and novelty are not claimed. This conclusion is a direct corollary of Kummer's
carry criterion; the actual checked proof uses the even more direct library
Catalan-divisibility result. The source still labels the assertion a conjecture,
but no update was submitted to OEIS. Neither the consequent about the sequence's
limsup nor any relationship to a larger open problem is formalized here.
The proposed exponential family and its carry calculation were not formalized,
because the successful bind-only proof made that implementation unnecessary.
