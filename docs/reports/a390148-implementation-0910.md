# A390148: primitive spherical radii, 3-adic orders

## Provenance and scope

Implementation by the Codex worker using the `lean4` skill, in the runner's
implementation stage. This is a single implementation source, not an independent
review or a multi-model consensus. The supplied orchestrator's enumeration is
reported input, not rerun evidence from this worker.

Branch: `lane/math/a390148`. Immutable starting base:
`462d0a4368ba5a890c5eab619c82437baa88966f` (`origin/dev` at start).
Tier: first tier, the 2025 OEIS conjecture, restricted to the 3-adic clause.

The target quantifies over all positive primitive natural radius quadruples
satisfying `(sum (1/r))^2 = 3 * sum ((1/r)^2)` over the rationals. The proposed
intermediate witness, preregistered in the implementation brief, is that primitive
integer curvatures satisfying `(sum b)^2 = 3 * sum (b^2)` have exactly three
coordinates not divisible by 3. The denominator bridge must establish its own
primitivity. No local valuation classification will be assumed.

Stop conditions: a failed primitive denominator bridge or a located existing
proof changes the delivery to a note. A failed Lean attempt must record the exact
remaining goal. Success requires the full theorem, no sorry/private axiom, the
required local build/content checks and an opened PR.

## Search receipts (ongoing)

1. Read `CLAUDE.md` completely, `agents/CONTEXT.md`, and specification A5/A5.1.
2. `rg -n -i '390148|sphereDescartes|gcd4|Descartes|soddy|gosset' D5`:
   no matches on the starting base.
3. `rg -n 'padicValNat|Finset.*lcm|Finset.*gcd' D5 --glob '*.lean'`:
   candidate modules include `FiniteCompatibleCrt`, `RationalValuationRecovery`,
   `DeeplyCompositeLcmRank`, `TotientNondivisorRecords`, and
   `SumTwoSquaresClassification`. Public interfaces are being inspected for
   general-purpose facts; absence of a same-named theorem is not a reuse verdict.
4. `make lean-cache-ensure` started before any Lake invocation. The worktree had
   no accessible mathlib checkout before this command; cache receipt pending.

External literature status: not yet assessed by this worker. Pages not opened
are `ASSUMED-UNVERIFIED`; the supplied triage is not substituted for inspection.

## Delivery accounting (pending proof)

For `primitive_sphere_radii_v3`, proposed `proof_shape: content`,
`admission_basis: escape-witness`; the intended witness is the primitive integer
curvature mod-3 classification above. These are preregistration, not a claim of
an elaborated proof. Direct frozen dependencies and statement IDs pending.

No new theory volume or atom will be created. The no-atom freeze uses the
repository's uncovered-deposit/`ledger-align --add` path. General infinite
quantification is intended; numerical samples are probes only.

## Unclaimed

No claim about primes congruent to 2 modulo 3, repetition formulas, arbitrary
chains, OEIS column sequences, or the coefficient-2 circle equation A390583.
No claim that the supplied enumeration proves an unbounded statement. No claim
of completed proof, library exhaustiveness, build success or freeze yet.
