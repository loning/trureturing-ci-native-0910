# A384309 implementation, 2026-09-10

Provenance: `lean4` skill; Codex implementation worker in the orchestrator's
implementation stage. The proof and local checks are produced by this worker.
No independent review is claimed. The 300,000-term data in the brief are user
observations, not worker observations.

## Target and preregistration

First tier. Base: `f838f20236e5a723d0c025ef53a80a07483008fa`.
Branch: `lane/math/a384309`. Lean 4.33.0; mathlib
`db584cd6d46c92f209a44c0f1c829460d327499d`.
The recurrence includes the current term before producing the next term.
The target counts only positions starting at 1 and asks for a finite set with
cardinality `9 + (if k = 1 then 1 else 0)` for every positive `k`.

Proposed escape witness, registered before proof probes: every leading-digit
counter is unbounded. Proposed route: some counter is unbounded by finite
pigeonhole; its successive emissions cover all positive integers; every
leading-digit fiber contains infinitely many positive integers, forcing all
nine counters to be unbounded. The occurrence at a successor position is
uniquely identified by its predecessor's digit and that counter's new value.
This gives exactly one occurrence per counter and one extra initial 1.

Success requires a complete kernel proof without `sorry` or private axioms,
the specified build and Scribe checks, freezing through the existing no-atom
writer, and an opened PR. Refutation requires a kernel counterexample.
Otherwise report `blocked`, with attempted routes and the sharp remaining lemma.

## Search receipts

1. Repository D5, at the base above:
   `rg -n -i 'a384309|a248034|leading.?digit|leading.?counter|首位|first.?digit' D5`.
   No matching recurrence or multiplicity theorem. Hits concerned positional
   numeration, admissible words, and a different digit-gas counting process.
2. Pinned mathlib: pending cache readiness and source inspection.
3. Third-party Lean ecosystem, arXiv, and OEIS: pending. The brief's claim that
   the 2025 paper states only a conjecture is currently `ASSUMED-UNVERIFIED`.

## Public theorem accounting

No public Lean theorem has yet been added. Final declaration-by-declaration
`proof_shape`, direct frozen dependencies (GID and `statement_id`),
`escape_witness`, and `admission_basis` will be recorded here.

## Build receipts

Not run yet. Cache, make exits, measured times, and log paths will be appended.

## Not claimed

No proof, counterexample, novelty beyond the searched scope, frozen node,
atom coverage, independent review, or PR is claimed at this checkpoint.
No theory volume or atom is being created for this task.

## Search batch 2

- Read all 779 lines of CLAUDE.md in chunks, including truncated intervals;
  read agents/CONTEXT.md and spec A5.1. `utility: none` is the exact grammar
  for this general, unbounded theorem (not a finite certified instance).
- This worktree initially had no `.lake`; started `make lean-cache-ensure`
  before any Lake invocation. Inspected the existing main checkout's mathlib
  sources read-only; `git rev-parse HEAD` there equals the requested pin.
- Pinned mathlib search `rg -n -i 'a384309|leading.?digit|leading.?counter'`
  over Mathlib: zero hits. Read `Data/Nat/Count.lean` and the Count section of
  `Data/Nat/Nth.lean`: reuse `Nat.count_injective`,
  `Nat.count_nth_succ_of_infinite`, and `Nat.nth_mem_of_infinite`.
  Located `Finite.exists_infinite_fiber` in Data/Fintype/Pigeonhole.
- `curl https://oeis.org/A384309/internal` succeeded and was read in full:
  revision 32, 2025-07-21; David James Sycamore, 2025-05-25. Its comment
  explicitly calls the exact multiplicity a conjecture. Its examples and
  Python generator include the current term before reading the counter.
  This page does not cite a research paper; no unidentified 2025 paper is claimed read.
- A later Python urllib attempt at the same OEIS page and its two xrefs got
  HTTP 403. These failures are not negative search evidence; curl fallback pending.
- arXiv web search, all fields, query `A384309`: HTTP 200, explicitly
  "produced no results". Saved page and extracted text in runner attempt directory.
- GitHub Lean code search is in flight. No globally exhaustive novelty claim.

## Search completion and cache

- GitHub authenticated code search `A384309 language:Lean`: total_count=0.
  Broader `"leading digit" "counter" language:Lean` returned one file,
  YijunYuan/TrustworthyKedlaya/Kedlaya/SabcOrderType.lean; source inspection
  concerns Hahn-series supports and ordinal order types, not this recurrence.
- curl fallback fetched all three OEIS internal pages successfully; complete
  extracted texts and HTML are in the runner attempt directory. A000030 gives
  only the initial digit definition. A248034 counts all digit occurrences and
  selects the last-digit counter; it is a different process. Its external
  SeqFan link and A000030's Cobham paper were not opened, ASSUMED-UNVERIFIED.
- No dominating theorem found in the searched D5, pinned mathlib, GitHub Lean,
  arXiv identifier, and OEIS scope; retain first-tier classification.
- make lean-cache-ensure EXIT=0, 19.529 seconds, macOS ARM: status=seeded,
  method=clonefile, donor=/Users/chronoai/trureturing, clonefile_attempts=1,
  stamp_miss=null, project_olean_state=warm, mathlib_olean_state=warm,
  archive_status=not_attempted. Full receipt: attempt-1/lean-cache-ensure.log.
- Capacity readings before Lean/Scribe/note creation: Arith has 33 immediate
  Lean files, its Blueprint mirror 56; choose a new CounterSequences subbucket
  (currently absent, 0 files). Library/Words recursively has 26 files.
  Report subbucket now contains 1 file (it was absent before creation).

## Lean fragment 1: all digit classes occur infinitely

- Canonical route returns D5/S3/Arith/CounterSequences/LeadingCounter.lean,
  S3, generality I. Initial route calls rejected absolute manifest paths,
  JSON nulls, missing required fields, and artifact="". After reading the
  loader and using repository-relative JSON with artifact="lean" and empty
  selector/tag, route EXIT=0. No routing rule was changed.
- leading10 is literally `(Nat.digits 10 n).getLastD 0`; its positive-input
  bounds come from Mathlib's last-digit and digit-bound theorems.
- The orbit state contains the current term and nine counters. The proved
  orbit_count identity identifies each counter with Nat.count over earlier
  terms. term_recurrence includes the current term.
- The planned all_digits_infinite argument is now checked by Lean: pigeonhole
  gives one infinite fiber; emit_nth gives every positive integer in the term
  range; powers 10^m*(d+1) supply infinitely many positive inputs per digit.
- Hot-tree `lake env lean D5/S3/Arith/CounterSequences/LeadingCounter.lean`
  EXIT=0. Initial errors were explicit argument order and negated-equality
  syntax; corrected against pinned source signatures. No sorry or new axiom.
  This file check is not the final project build or multiplicity proof.

## Lean fragment 2: exact finite multiplicity

- Hot-tree file check EXIT=0, no warnings. The target is now proved as
  `leading_counter_multiplicity (k : ℕ) (hk : 0 < k)` with both Set.Finite
  and ncard = 9 + (if k = 1 then 1 else 0).
- successor_bijOn sends a predecessor index to the leading-digit counter
  used there. Nat.count_injective proves injectivity; emit_nth and
  all_digits_infinite prove surjectivity onto Fin 9. This proves both
  finiteness and nine successor occurrences, without finite enumeration.
- The public a function has a 0 = 0, a 1 = 1. Translating predecessor n
  to sequence position n+2 isolates position 1, which contributes only for
  k=1; positive k excludes the unused position 0.
- a_recurrence verifies the actual one-based definition against counter,
  whose Nat.count predicate uses a(i+1) for i<t, precisely positions 1..t.
- Proof repair addressed dependent DecidablePred rewriting with simp,
  explicit beta reduction for index arithmetic, and equality orientation.
  No target was weakened. Full make lean and semantic axiom audit still pending.

## Full Lean build

- `make lean` EXIT=0, 46.477 seconds, 12828 jobs; the new LeadingCounter
  module was built in 3.9 seconds. Log: attempt-1/make-lean.log.
- LEAN_CACHE: status=present, method=none, stamp_miss=null,
  project_olean_state=warm, mathlib_olean_state=warm,
  archive_status=not_attempted. This is macOS ARM local timing, not CI timing.
- Source length 181 lines; no sorry, axiom declaration, or native_decide.
  Existing project warnings were replayed by Lake; the new module's file
  check has no warnings. Canonical Lean report and semantic audit are running.

## Canonical report and semantic audit

- `make lean-report` EXIT=0, 63.159 seconds. Report SHA256:
  297cbbf4190e4df0a08eb356a334c6b731cb3c135d47b2fbf951527b28812aea.
  Log: attempt-1/make-lean-report.log; canonical output:
  .lake/build/stratalint/raw-lean-report.json.
- Existing proof-edges.sh, using Lean Expr.getUsedConstants on elaborated
  values/types and expanding auxiliary constants, returned EDGES_OK,
  24 nonauxiliary constants, 9 nonprivate constants (including the generated
  orbit.eq_def equation). All external D5 dependencies are empty; all axiom
  sets are subsets of propext, Classical.choice, Quot.sound.
- The live chain is leading_counter_multiplicity -> successor_multiplicity
  -> successor_bijOn -> all_digits_infinite / emit_nth / term_recurrence.
  a_recurrence uses digit_eq_iff, term_pos, and term_recurrence -> orbit_count.
- The compiler eliminates the reflexive a_one use in the main proof; it is
  not claimed as a surviving constant edge. Its named companion purpose is
  the initial-condition API required by the brief. KernelAudit.recurrence_echo
  is the registered semantic consumer of a_one and a_recurrence, bundling
  the two source conditions. It is not an additional frozen result.
- KernelAudit initially timed out reducing the 21-entry private sequence
  echo at 200000 heartbeats. The general proof and axiom queries passed;
  replace that oversized smoke test with the first six actual terms, enough
  to distinguish the update order, plus leading10(1234)=1 and zero behavior.
- Library note includes Verified locator with literal url and doi lines.
  Source inspection found production Describe rejects suspected-novel nodes;
  the proved multiplicity is accurately marked repo-derived, with the OEIS
  conjecture acknowledged. No global novelty assertion is needed or made.
