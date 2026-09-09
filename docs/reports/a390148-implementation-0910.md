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

## Search batch 2 and cache receipt

- `make lean-cache-ensure` EXIT=0: status=seeded, method=clonefile,
  donor=/Users/chronoai/trureturing, clonefile_attempts=1, stamp_miss=null,
  project_olean_state=warm, mathlib_olean_state=warm, missing mathlib oleans=0.
  Toolchain is v4.33.0; mathlib HEAD is
  db584cd6d46c92f209a44c0f1c829460d327499d.
- Read the public statements of the five candidate D5 modules above: finite CRT
  gluing, rational recovery from all valuations, deeply-composite rank bounds,
  totient LCM jumps and two-squares classification do not supply the primitive
  reciprocal-denominator identity or the coefficient-3 congruence. Their general
  public results were inspected, not excluded by topic name.
- Mathlib search for Descartes/Soddy/Gosset found only the polynomial rule of signs.
  Read the full public Finset gcd/lcm API, including lcm_dvd, dvd_lcm, gcd_dvd,
  dvd_gcd, lcm_ne_zero_iff, extract_gcd and gcd_div_eq_one. Read padicValNat.mul,
  div_of_dvd, pow, and divisibility/valuation equivalences. Also found binary
  Nat.div_lcm_eq_div_gcd; it is the opposite quotient identity and does not
  directly establish primitivity of L/r. We will use the general divisibility API.
- Opened https://oeis.org/A390148/internal, revision 23 (2025-11-17), and read all
  fields. The coefficient-3 equation matches exactly. The main comment still
  states the 3-adic clause as observed for 1000 rows and conjectured for infinity.
  Author Charles L. Hohn, 2025-10-26. Its listed links/columns are data or the
  other excluded clauses; their full inspection remains supplied triage evidence,
  not claimed as this worker's independent reading.
- GitHub code search `A390148 language:Lean` and `Descartes sphere language:Lean`
  both returned []. Broader `Descartes language:Lean` returned polynomial rule of
  signs and Apollonian circle-packing files, not the sphere theorem. No third-party
  file is imported or claimed verified on the basis of search snippets.
- Opened https://arxiv.org/search/?query=A390148&searchtype=all : explicitly
  produced no results. Google HTML queries returned only a JavaScript redirect
  page; Bing RSS returned unrelated results and is discarded as search evidence.
  Search capability is available via GitHub, arXiv and direct OEIS inspection;
  generic web-engine searches are not claimed complete.
- dominating_theorem_search: not-found-in-searched-scope. No direct existing
  proof found in these inspected sources; retain first tier, without claiming
  global priority or exhaustive absence.
- Directory counts before Lean creation: D5/S3/Arith has 34 direct files,
  Blueprint/D5/S3/Arith has 58 including projections. Use a new Descartes child
  bucket (0 prior files). docs/reports has 47 direct files including this report.
  No lower AGENTS.md/CLAUDE.md was found under the edited content directories.
