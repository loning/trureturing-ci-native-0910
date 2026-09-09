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
