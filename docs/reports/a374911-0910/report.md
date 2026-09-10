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
