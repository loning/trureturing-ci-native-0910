# OEIS A374911 implementation record

## Origin and scope

2026-09-10. Skill: `lean4`; implementation by the Codex worker in the supplied
`consensus-rnd/sshx/a374911-impl-0910/attempt-1` context. One implementation
worker, no independent review performed by this worker. User-supplied numerical
checks and the triage route are attributed to the user, not independently verified here.

Branch: `lane/math/a374911`. Immutable starting base:
`24279623ef5253194f6c64ee3b3b627e62e3df50` (`origin/dev` at start).

Target: define `seq 0 = 1` and, only for positive `n`,
`seq n = seq (2^n % n) + seq (3^n % n)` by well-founded recursion;
prove `seq n = 4 ↔ n = 3 ∨ n = 9` for every natural `n`.

Tier: first tier, as explicitly assigned. The claim of no published proof is
user-supplied pending the worker's source inspection. No new theory volume,
ingestion, or atom will be created. Intended atom-free freeze: `ledger-align --add`.

## Preregistered route and stopping conditions

The proposed escape witness is the arithmetic exclusion of higher powers of
three: from `2^(3^k) % 3^k = 2^j < 3^k`, force `k ≤ 2` using multiplicative
order/LTE and growth. Its prerequisites are the recursive classifications of
values one, two, and three, and the smallest-prime-factor exclusion of
`n > 1 ∧ 2^n % n = 1`. This is the route supplied in the brief and is currently
`ASSUMED-UNVERIFIED`, not a proof claim. If either critical arithmetic step
resists a concrete Lean attempt, follow the user's stop condition and deliver
a note with the exact remaining goal.

## Search receipts

- Read the complete `CLAUDE.md` (779 lines) in chunks and `agents/CONTEXT.md`.
- D5 coarse search: `374911|pow.*mod.*eq_one|minFac|orderOf.*dvd|pow_sub_pow|pow_two_sub_one_ge`.
  No exact A374911 statement found. Hits include general order and smallest
  prime factor lemmas; their relevant public interfaces still need inspection.
- The attempted path `tools/scripts/lean.sh` does not exist. The canonical
  Lean command will be read from `Makefile`; no bare cold Lake command was run.

## Validation

No Lean attempt or build has yet run. No theorem is claimed proved or frozen.
`make lean` exit code, elapsed time, cache receipt, report/emit/deposit and
Scribe content-check results will be recorded as they are produced.

## Declaration accounting

No public declarations yet. For the target, pending proof:
`proof_shape: unassessed`; direct frozen dependencies: not yet determined;
`escape_witness`: proposed arithmetic exclusion above;
`admission_basis`: proposed `escape-witness`, not yet established.
The four conditions of CLAUDE 3.2 will be checked against the final proof.

## Not claimed

No all-natural classification, independent numerical verification, exhaustive
literature search, successful build, freeze, PR, or independent review is claimed.
Pages not actually opened are `ASSUMED-UNVERIFIED`. Finite checks will not be
reported as progress on the unrestricted theorem.

## Search and cache checkpoint

- `make lean-cache-ensure` EXIT=0, real 18.70 seconds. `LEAN_CACHE`:
  `status=seeded`, `method=clonefile`, donor `/Users/chronoai/trureturing`,
  `clonefile_attempts=1`, `stamp_miss=null`, both project and Mathlib warm,
  missing Mathlib oleans=0. Full log is in the attempt directory.
- Manifest confirms Mathlib commit `db584cd6d46c92f209a44c0f1c829460d327499d`.
- Read A091259's complete public API, the general affine-conjugacy and
  invariant-set order signatures in CyclicPlaneTwelveMultiplierObstruction,
  and all public theorem names in the minFac search hits. General lemmas there
  concern divisor pairs, Jordan cototients, or invariant finite sets; no exact
  primitive for this recurrence. Read GoldenCell5040Congruence in full: its
  order-to-congruence helper is private, and its public theorem is the six-element
  5040 cell. No reusable exact public hit was found in this searched scope.
- Mathlib search/read hits: `Nat.coprime_of_lt_minFac`, `Nat.dvd_prime_pow`,
  `ZMod.orderOf_dvd_card_sub_one`, `orderOf_dvd_iff_pow_eq_one`,
  `padicValNat.pow_sub_pow`, `padicValNat.pow_add_pow`,
  `padicValNat.pow_two_sub_one_ge`, `padicValNat_dvd_iff_le`,
  `Nat.ModEq.pow_totient`, `Nat.totient_prime_pow_succ`. These will be reused.
  The guessed Pseudoprime.lean path was absent; located and searched FermatPsp.lean.
- Authenticated GitHub code search `A374911 language:Lean`: total_count=0.
  arXiv API `all:A374911`: totalResults=0. This establishes network access and
  bounded non-hits, not global absence.
- Opened the full OEIS text entry A374911: it explicitly asks “Are 3 and 9 the
  only solutions to a(n) = 4?” The original recurrence and zero case match.
  Opened its three direct xrefs A000079, A015910, A066601. No target proof in
  those entries. The first broad A000079 display was truncated; the missing
  relevant links were read separately.
- Followed A015910 to A036236, which explicitly gives Max Alekseyev's
  smallest-prime-divisor proof of `2^n mod n ≠ 1` and Firoozbakht's formula
  `2^(3^k) = 3^k - 1 (mod 3^k)`. These are known prerequisites, not novelty claims.
- Opened Coons–Winning's “Powers of Two Modulo Powers of Three” landing page
  linked from A000079. Its abstract concerns finer mod-six structure and
  Stoneham normality. Full paper not yet read, `ASSUMED-UNVERIFIED`.
- Spec A5.1 gives `utility: none` for a noncomputational general classification.
  Arith is registered at S3; proposed Congruence bucket has 20 files before addition.

## Preregistered route revision 2 (before Lean proof)

The newly read A036236 formula shortens the proposed higher-power exclusion.
Use the odd-prime **addition** LTE (`padicValNat.pow_add_pow`) to obtain
`3^k ∣ 2^(3^k) + 1`, hence its remainder is `3^k - 1` for positive `k`.
Then classify `3^k - 1 = 2^j` by parity/mod-eight and factorization (or the
two-adic LTE already searched). This is a revision of the preregistered
arithmetic witness, recorded before trying it. The original subtraction-LTE
route remains unverified and is no longer the implementation plan. The user’s
stop condition at smallest-prime exclusion or LTE remains in force.

## Critical arithmetic checkpoint

The warm Lean check of `attempt-1/Critical.lean` exited 0. Both
`two_pow_self_mod_ne_one` and `three_pow_dvd_two_pow_add_one` were kernel
checked, with only propext, Classical.choice, Quot.sound. The smallest-prime
exclusion and addition-LTE step both succeeded; the stopping condition did
not trigger. They are saved as private helpers in the routed module. This
checkpoint does not yet prove the sequence classification.

The route command accepted Arith/Congruence/PowerResidueRecursionFour with
generality I. Its first call rejected an absolute manifest path; retry used
a repository-relative `.lake/a374911-route.json` and returned the canonical
GID and seven-line skeleton.

## Recursive classification checkpoint

The warm file check of the routed module exited 0 with no warnings. `seq` is
well-founded recursion on n, with both recursive calls guarded by n ≠ 0 and
termination established by `Nat.mod_lt`. The unbounded theorems `seq_eq_one`,
`seq_eq_two`, and `seq_eq_three` are proved; all three axiom outputs are exactly
propext, Classical.choice, Quot.sound. Values one/two use strong-induction
positivity and coprimality; value three uses the least-prime exclusion and
Euler's totient theorem for every positive power of two. This is symbolic
progress, not finite enumeration. Target value four is still outstanding.

A first value-three check had one local nested `by`/semicolon scoping error
at the k=0 contradiction (and therefore reported sorryAx on that failed
declaration); it was repaired with a separate proof block. The successful
second check has no sorryAx. Log: attempt-1/seq-three-check.log.

Route refinement within revision 2, before trying the last Diophantine step:
for even k, two-adic LTE gives j = 2 + v₂(k), hence 2^j ≤ 4k; compare with
3^k - 1 > 4k for k ≥ 3. For odd k, reduce modulo four to force j=1.
This supplies the stated parity/LTE alternative without factoring two
adjacent prime powers. No implementation of this final step has yet run.

Additional search: D5 arithmetic/Factorization and Mathlib NumberTheory
searches for mixed two/three powers found factorization identities and
polynomial Fermat–Catalan, not this integer exponential equation. Read the
Coons–Winning introduction and main proposition in its downloaded TeX; it
classifies bi-periodic subsets. The remainder of its proof and unrelated
second-hop references are not claimed read.
