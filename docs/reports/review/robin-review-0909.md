# Independent review: robin_seven_smooth (2026-09-09)

## Provenance and scope

- Skill context: no skill invoked; this Codex worker performs the independent review directly.
- Carrier and division: one Codex review worker; implementation by a different seat, whose model family is not verified here. No delegated reviewers and no multi-model consensus claimed.
- Method: source inspection, independent offline exact arithmetic, and this worker's own canonical Make verification. Implementation-seat measurements are not evidence for this review.
- Reviewed baseline: `b9a54ed44830a206d1389a23fd5fc55472180d3c`; parent `9a90c5fda4` is the stated landing of #6563. The review concerns this fixed tree, not a moving dev tip.
- Branch: `lane/math/robin-review-0909`. The supplied clean worktree already had this branch checked out. Requested `git checkout -b lane/math/robin-review-0909` returned EXIT 128 (`already exists`); the supplied branch is retained without resetting or replacing it.
- Read first: tracked `tools/scripts/agent/probe-brief-note.txt`, then all of `CLAUDE.md` and `agents/CONTEXT.md`.
- Scope: review only; no edits to `D5/**` or `Blueprint/**`, no freeze/deposit/cover/merge action.
- Worker artifacts: `/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/robin-review-0909/attempt-1` (called `ATTEMPT` below).
- Checkpoints: Q1-Q4 complete; Q5-Q6 pending. Overall verdict is pending until all six questions are reviewed.

## Q1. Mathematical correctness

Result: all four mathematical checks pass. This is a statement for products of powers of exactly the permitted primes, subject to `n > 5040`.

### 1. Strict uniform bound

For `p > 1` and every natural exponent `e`, including zero,

```
sum(i=0..e, p^i) = (p^(e+1)-1)/(p-1) < p/(p-1) * p^e.
```

The strict gap is `1/(p-1) > 0`; zero exponents do not destroy strictness. Distinct prime powers are coprime, including powers equal to 1. Multiplicativity gives the product of these geometric sums. Multiplying positive bounds gives

```
sigma(n) < [2 * (3/2) * (5/4) * (7/6)] * n = (35/8) * n.
```

The Lean proof follows exactly this argument: `SevenSmooth.lean:24` proves `sigma_smooth`, `:40` proves `geometric_bound` using the exact geometric-sum identity, and `:49` proves `sigma_uniform_bound` by positive multiplication. All real divisions here have `p-1 > 0`.

At `(a,b,c,d)=(0,0,0,0)`, `n=1`, `sigma(1)=1`, so the auxiliary bound is the ordinary true inequality `1 < 35/8`, with no degenerate operation. It does not need `hn`. For the quotient in the public proof, `:178` explicitly derives `0 < (n : Real)` from `hn`; `:217` uses `div_lt_iff` with that positivity. The full Robin conclusion at `n=1` would be `1 < 0`, false; its hypothesis is false there.

### 2. Threshold direction and rational enclosure

Put `E = exp(gamma) > 0` and `T = exp(exp((35/8)/E))`. On `n > 1`, both logarithms are in their ordinary positive-input domains. Order preservation under division by `E` and two applications of exp gives

```
E * log(log n) >= 35/8  iff  log n >= exp((35/8)/E)  iff  n >= T.
```

Independently computed exact rational enclosure, using the certified gamma interval in `RobinRationalBasis.lean:466` (`5772155/10000000 < gamma < 5772161/10000000`):

```
116141 < 11614159546044687882313/100000000000000000
       <= T
       <= 116143591796281186684049/1000000000000000000
       < 116144 < 131072.
```

This is rational interval arithmetic, not a floating-point acceptance test. For positive rational `x`, the script uses the degree-100 exponential Taylor sum `S`, with the rigorous upper remainder `next_term/(1-x/102)`; every input satisfies `x < 102`. Results are rounded outward to denominator `10^18` after each exponential. Division reverses endpoint selection when bounding `(35/8)/E`. Thus the enclosure follows from the named certified gamma bracket and the elementary positive-series remainder bound.

Lean does not define `T` or depend on its reported enclosure. It proves the stronger convenient tail comparison directly: `loglog_tail` at `:150` gives `123/50 < log(log 131072)`; `exp_gamma_lower` at `:109` gives `89/50 < E`. Then `(89/50)*(123/50) = 10947/2500 > 35/8`, with exact gap `19/5000`. Lines 218-220 transfer this bound to every `n >= 131072`, including the endpoint.

### 3. Exhaustiveness and independent count

`exponent_bounds` (`SevenSmooth.lean:80`) uses positivity of the full product and divisibility to show each prime power is at most `n`. If an exponent leaves the stated box, then respectively

```
2^17 = 131072; 3^11 = 177147; 5^8 = 390625; 7^7 = 823543.
```

Each contradicts `n < 131072`. Hence `[0,16] x [0,10] x [0,7] x [0,6]` covers the entire finite segment; its size is 10472. The lemma does not need the lower bound `5040 < n`. `:180-181` constructs all four `Fin` values from these proved bounds and passes both numeric interval hypotheses to `small_values`.

Own count: **482**, not an adopted implementation measurement. The primary enumeration scans each integer `5041..131071`, repeatedly divides out `2,3,5,7`, and accepts exactly remainder 1. A separate traversal of the 10472 exponent tuples gives the same sorted list, with no duplicates. Observed maximum exponents are `(16,10,7,6)`. The implementation's Lean lemma proves a universal predicate over the box, not a theorem asserting cardinality 482.

### 4. All finite values and 18 sample recalculations

For every accepted integer, `sigma(n)` was computed by summing divisor pairs with `d <= isqrt(n)`, counting a square-root divisor once. This was also compared with the product of four geometric sums. Both sums agree for all 482 values. Integer cross multiplication checks every applicable bound:

| Integer interval | Count | First/last smooth n | Bound | Exact maximum ratio (where) | Violations |
| --- | ---: | --- | --- | --- | ---: |
| `5040 < n < 10000` | 71 | 5103 / 9800 | `381/100` | `80/21` (7560) | 0 |
| `10000 <= n < 20000` | 89 | 10000 / 19845 | `197/50` | `248/63` (15120) | 0 |
| `20000 <= n < 131072` | 322 | 20000 / 129654 | `407/100` | `3844/945` (75600) | 0 |

Samples include the first and last member of every interval, both internal cut points, and all three maximizing values. Slack is `bound.numerator*n - bound.denominator*sigma(n)` and is nonnegative in every case.

| n | (a,b,c,d) | sigma(n) | Reduced sigma(n)/n | Bound | Integer slack |
| ---: | --- | ---: | --- | --- | ---: |
| 5103 | (0,6,0,1) | 8744 | 8744/5103 | 381/100 | 1069843 |
| 5120 | (10,0,1,0) | 12282 | 6141/2560 | 381/100 | 722520 |
| 7168 | (10,0,0,1) | 16376 | 2047/896 | 381/100 | 1093408 |
| 7560 | (3,3,1,1) | 28800 | 80/21 | 381/100 | 360 |
| 9720 | (3,5,1,0) | 32760 | 91/27 | 381/100 | 427320 |
| 9800 | (3,0,2,2) | 26505 | 5301/1960 | 381/100 | 1083300 |
| 10000 | (4,0,4,0) | 24211 | 24211/10000 | 197/50 | 759450 |
| 10080 | (5,2,1,1) | 39312 | 39/10 | 197/50 | 20160 |
| 14336 | (11,0,0,1) | 32760 | 585/256 | 197/50 | 1186192 |
| 15120 | (4,3,1,1) | 59520 | 248/63 | 197/50 | 2640 |
| 19683 | (0,9,0,0) | 29524 | 29524/19683 | 197/50 | 2401351 |
| 19845 | (0,4,1,2) | 41382 | 4598/2205 | 197/50 | 1840365 |
| 20000 | (5,0,4,0) | 49203 | 49203/20000 | 407/100 | 3219700 |
| 20160 | (6,2,1,1) | 79248 | 1651/420 | 407/100 | 280320 |
| 56448 | (7,2,0,2) | 188955 | 20995/6272 | 407/100 | 4078836 |
| 75600 | (4,3,2,1) | 307520 | 3844/945 | 407/100 | 17200 |
| 129600 | (6,4,2,0) | 476377 | 476377/129600 | 407/100 | 5109500 |
| 129654 | (1,3,0,4) | 336120 | 56020/21609 | 407/100 | 19157178 |

Excluded boundary control: `sigma(5040)=19344`, ratio `403/105`; 5040 is excluded by a strict hypothesis. Tail boundary control: `sigma(131072)=262143`, ratio `262143/131072`; it belongs to the tail, not the finite table.

The finite ratio bounds are joined to strict RHS lower bounds with exact positive gaps:

| Endpoint | Lower bound on log(log endpoint) | `(89/50)*lower` | Gap above finite ratio bound |
| ---: | --- | --- | --- |
| 5040 | 1071/500 | 95319/25000 | 69/25000 |
| 10000 | 111/50 | 9879/2500 | 29/2500 |
| 20000 | 229/100 | 20381/5000 | 31/5000 |

All eight rational `log_lower` certificates in `:123-157` were independently checked, including `x=2^k*y`, `k>=1`, `1<=y<2`, and strict positive atanh-polynomial margins. The exponential degree-5 lower sum at `577/1000` is exactly `213675904927091657/120000000000000000 > 89/50`. Thus the finite-to-analytic comparisons have sufficient strict margins.

Reproduction: `python3 "$ATTEMPT/math_check.py"`, EXIT 0, output `math_check.json`. The script and full rational results are worker-owned artifacts. It uses only standard-library exact integers and `fractions.Fraction`; decimal displays are non-authoritative. Its integer-scan criterion is independent of the submitted exponent-box enumeration.

## Q2. Totalization and degenerate points

Result: pass, no blocking degenerate point in the quantified domain.

- Denominator: natural powers of 2, 3, 5 and 7 are strictly positive for every exponent. In the actual public proof, `SevenSmooth.lean:178` obtains real positivity from `hn` by `omega` and `exact_mod_cast`. Each quotient comparison uses that same proof (`:187`, `:199`, `:209`, `:217`). The denominator and sigma cast are real-valued; this is not natural-number truncating division.
- Inner logarithm: `n > 5040` ensures a positive input. The proof of `loglog_5040` actually establishes `341/40 < log 5040` at `:124-126`, a stronger lower bound than 1. At the other anchors it establishes `921/100`, `99/10`, and `589/50` as lower bounds on the inner logarithm, all greater than 1.
- Outer logarithm: `rhs_lower` at `:163-166` converts `1 < m` and `m <= n` to real inequalities, uses `Real.log_pos hmR` to supply positivity of `log m`, and uses two positive-domain `Real.log_le_log` applications. Its `hlogn` is explicitly `l < log(log n)`, and its input `hl` is `0 < l`. All four public branches instantiate positive `l` and proved anchor bounds. Thus `log(log n)>0` is on the Lean proof path. The public theorem has no separately named `1 < log n` local; this intermediate estimate is distributed across the anchor proof and monotonicity, not omitted mathematically.
- Auxiliary fractions: `geometric_bound` proves `p-1>0` at `:45`. The atanh parameter has `y+1>=2` because `hy:1<=y`; the imported analytic theorem is used within its `1<=y<2` domain. Fixed ratio denominators 100, 50, and 8 are nonzero.
- `sqrt` and `sInf`: absent from this module's statement and source proof; no such totalization is used to establish the submitted inequality. This is a source-level scope claim, not a claim that these constants never occur in all imported infrastructure.
- Boundary checks: `n=0` is unattainable by the product; `n=1` is attainable but excluded by `hn`, and the full conclusion there is false (`1<0`), not accidentally true. The ordinary true auxiliary bound `1<35/8` at `n=1` is harmless. `n=5040` is also excluded; the upper finite cut `131072` is included in the tail. No permitted exponent tuple produces an invalid logarithm input.

Correction to the brief's generic warning: this pinned Mathlib has `Real.log 0 = 0` and `Real.log 1 = 0` (`Mathlib/Analysis/SpecialFunctions/Log/Basic.lean:103,107`), but negative arguments are extended by `log(-x)=log x` (`:121`), not uniformly mapped to zero. The actual target excludes both zero and negative logarithm inputs, so this correction does not weaken the check.

Literal search receipt (counts are matching lines; these searches only support literal presence/absence, not semantic dependency claims):

```
rg -n '\b(sqrt|sInf)\b' D5/S3/Arith/Robin/SevenSmooth.lean
# EXIT 1, 0 matching lines
rg -n '\b(log|exp)\b' D5/S3/Arith/Robin/SevenSmooth.lean
# EXIT 0, 13 matching lines; positive control uses the same word-boundary and alternation features
```

Push receipt for Q1: `7766d95416`, successful creation of `origin/lane/math/robin-review-0909`, EXIT 0. Q2 is recorded in the next checkpoint commit.

## Q3. Independent proof shape and escape witness

Result: `proof_shape: content`; `admission_basis: escape-witness`; witness `small_values`. This is a semantic quality judgment, not a claim that SL-031 mechanically classifies proof shape.

### Frozen predecessor and restricted binding attempt

The sole direct D5 import is `D5/S3/Arith/GoldenResource/RobinRationalBasis`. Its frozen state exists with module `statement_id` `sha256:6dcafd483a23c78180a3518807013e46c0dccfcb211d2d5f442207eb1ee621c2`. The reviewed module itself has no state pin (`git ls-tree HEAD Golden/Frozen/state/D5/S3/Arith/Robin/SevenSmooth.lean.json`: EXIT 0, empty output).

After following the local helpers, the semantic D5 frontier contains these public predecessor declarations (prefix of each GID is `D5/S3/Arith/GoldenResource/RobinRationalBasis.`):

| Selector | Declaration statement_id | Scope / limitation |
| --- | --- | --- |
| `atanhPartial` | `sha256:6dde04c7f9c9c84a9e0d10d75e9709f0b78c512961eb7eb9144a9b41611c89ba` | Definition of a truncated series, not any finite Robin clearance |
| `log_pow_two_mul_bounds` | `sha256:396e0fccb254940f3d4c0dcd52b362909e7974c8de4516750fbc720d9f774066` | Requires `k>=1` and `1<=y<2`; supplies analytic bounds, not bounds on sigma |
| `eulerMascheroni_decimal_bounds` | `sha256:cfeea459eef282e115525208dc385f15423187fbddf8597482a6478ebabd2d42` | Bounds gamma only |

The raw compiler frontier also contains `atanhPartial._proof_1`, an internal auxiliary, `include_in_statement=false`, statement ID `sha256:139c88329085efe6909c3edaa366510de2da7e3f9172d956a745deaca4b194ac`. It is not an additional public theorem. Identities were read from the canonical JSON, whose basis source hash `3fbf5d63fd009f7ff61eccc54eb775c2176bc9340495097b4035998243024713` matches the reviewed source; Q5 refreshes the canonical report. Pinned Mathlib declarations are not frozen D5 predecessor GIDs.

Own restricted Lean attempts, in a worker-only example, were required to fail: direct `robin_delta_10080_pos`, `norm_num only`, and `linarith only [sq_nonneg ...]`. Each failed to close the arbitrary-exponent target, as asserted by `fail_if_success`; the test example then closes with the already submitted theorem so the probe introduces no admitted result. Reading `robinPositiveJudge_sound` shows why binding that checker also leaves a new obligation: its same-n certificate and same-n analytic brackets must be supplied. A theorem about 10080 has the wrong argument. Gronwall's epsilon envelopes and the fixed-prime-valuation eventual bounds do not give the explicit all-n threshold 5040.

Own candidate search receipts (matching lines, including documentation hits):

```
rg -n '\b(robin|Robin|robinDelta|RobinPositiveJudge)\w*\b|7.smooth' D5 --glob '*.lean'
# EXIT 0; 122 lines, including this module; candidates inspected in RobinRationalBasis,
# Robin/PaddingRatio, Weil/GronwallLowerEnvelope, and Weil/PrimeValuationGap
rg -n '\b(robin|Robin)\w*\b|7.smooth' .lake/packages/mathlib/Mathlib/NumberTheory --glob '*.lean'
# EXIT 1; 0 lines
rg -n '\b(sigma_one_apply_prime_pow|isMultiplicative_sigma)\b' .lake/packages/mathlib/Mathlib/NumberTheory/ArithmeticFunction
# EXIT 0; 8 lines; positive word-boundary/alternation control
```

This is `not-found-in-searched-scope`, not exhaustive nonexistence of another proof or third-party theorem. No external page from the implementation report is adopted as independently verified evidence.

### Four witness tests

1. **Elaborated closure: pass.** Own Lean compiler probe queries `Environment`/`ConstantInfo`, not source-name matching. Exact symbol: `_private.D5.S3.Arith.Robin.SevenSmooth.0.D5.S3.Arith.Robin.SevenSmooth.small_values`. `RAW_DIRECT_USE=true` in the public theorem's proof value, and membership is true in its transitive type/value constant-reference traversal (42239 names including the root). Direct use already proves the required closure membership.
2. **Not supplied by frozen binding/projection/normalization: pass.** The predecessor frontier supplies logarithm and gamma facts; it has no interval-wide divisor-sum inequalities at 381/100, 197/50, or 407/100. Multiplicativity supplies a formula but not these bounds. `fin_cases a; decide +kernel` establishes new finite arithmetic facts over the remaining exponents. Recomputing them by `decide` elsewhere would still establish new content under section 3.2, not normalize facts already provided by a predecessor.
3. **Not definitionally equal or an alias: pass.** The witness is a predicate over four finite exponent domains and three integer cross-product bounds. It has no log, exp, or gamma. The public conclusion quantifies unbounded natural exponents and asserts a real Robin inequality. Own `Meta.isDefEq` with full transparency returns false for their types.
4. **Live path and counterfactual: pass.** `SevenSmooth.lean:181` instantiates the witness; `:182-211` transports its output to the real ratio bound in each finite branch; `:193`, `:205`, `:215` consume that bound in the final strict transitivity step. The tail branch is independent of this witness. After exposing `And.left/right` wrappers and Lean beta/zeta/iota and reducible reductions, the witness remains a direct used constant. The control `(And.intro witness True.intro).2` has a raw dependency but none after reduction; `.1` retains it. Thus this check rejects the dead-projection example in section 3.2. Without the witness, the existing uniform cap `35/8` cannot close the lower finite intervals against RHS bounds near 3.81-4.08; the remaining frozen checker still needs fresh certificates. Another proof may replace the witness with new estimates, but that is not bind-only reuse.

Probe entry: `make -f "$ATTEMPT/Review.mk" semantic-probe`, delegating to the canonical cache-writer wrapper; no bare lake and no D5 edits. Final probe EXIT 0 in 6.156255833 s (`semantic-probe-final.log`). This is a bounded expression-reduction check plus inspection of the actual inference chain, not a general machine proof of the absence of all bind-only alternatives.

Probe failure recorded: initial basic semantic query passed (EXIT 0, 7.661873583 s). Adding the dead-projection control exposed that reducible transparency alone leaves `And.right` opaque (EXIT 2, 7.8885225 s, `live/dead projection controls failed`). The final query explicitly exposes those logical projections and passes both controls. This failure belonged to the review probe, not the submitted theorem; no target file was changed.

### Preregistration

`preregistration_verified: true` for the named v2 registration before implementation. Own `git show adb94f9668 --stat` returned EXIT 0:

```
adb94f9668d1d2da28de6fc96a440f807969193c
2026-09-09 10:29:48 +0800
docs: measure 482 smooth inputs and preregister private arithmetic witness
measure.py: 2 lines changed; progress.md: 35 lines added
2 files changed, 36 insertions(+), 1 deletion(-)
```

The patch explicitly names private `small_values` and all three final ratio bounds, says the generic uniform bound is not the witness, and commits to only the unrestricted final theorem being public. The first commit of `SevenSmooth.lean` is `ca3b0e95c3` at 10:41:18 +0800. `git merge-base --is-ancestor adb94f9668 ca3b0e95c3` returned EXIT 0. This verifies chronology from Git objects, not just a prose claim. The initial v1 (`b20c258620`, 10:20:37) already proposed private handling of the finite interval; v2 explicitly refines that proposal after the exploratory binding/measurement work. It is not represented here as preceding all exploration or as an unchanged v1 registration.

Push receipt for Q2: `9b7f11119f`, EXIT 0. Q3 is recorded in the next checkpoint commit.

## Q4. Utility classification and visibility

Result: `utility: none` is appropriate for the delivered public theorem, under the brief's explicit public/private distinction. No public positive bounded-enumeration or certified-instance declaration was found. This is not an assertion that no computation occurs in its private proof.

Own declaration count: **1 public theorem + 12 private theorems + 3 private definitions = 16 authored declarations**. There are no authored public definitions, instances, structures, opaque declarations, or axioms. Thus the supplied `1 + 12` count is correct for theorems only; total private authored declarations are **15**, not 12.

| Declaration(s) | Visibility | Delivered semantics / classification |
| --- | --- | --- |
| `robin_seven_smooth` (`:170`) | Public theorem | Unbounded natural exponents; actual Robin inequality, all numeric obligations discharged; `none` |
| `smooth`, `geometric`, `divisorSum` (`:16,18,21`) | Private definitions | Product/sum notation for the proof; no public checker API or certified-instance claim |
| `sigma_smooth`, `geometric_bound`, `sigma_uniform_bound` (`:24,40,49`) | Private theorems | General factorization and estimates with arbitrary exponents |
| `small_values` (`:70`) | Private theorem | Bounded enumeration inside the proof; not publicly delivered as a finite result |
| `exponent_bounds` (`:80`) | Private theorem | Coverage of the box from a bound on n; no exported enumeration result |
| `exp_gamma_lower`, `loglog_5040`, `loglog_10000`, `loglog_20000`, `loglog_tail` (`:109,123,132,141,150`) | Private theorems | Numeric proof ingredients for the single unbounded result |
| `log_lower`, `rhs_lower` (`:116,159`) | Private theorems | Analytic transfer helpers; their hypotheses are fulfilled at each call |

The public theorem is not a checker, not a finite instance, and not a numerical reduction awaiting an external certificate. The finite segment and an independently proved unbounded tail jointly prove all permitted inputs. Section 3.3's warning that bounded enumeration cannot prove an unbounded universal by itself is respected. Exposing the table as a public positive computational theorem would require verified `refutes` and would be blocking; that exposure does not occur. Compiler-generated `_proof_*` implementation details are accounted for separately in Q5; source-level public API and canonical `include_in_statement` are distinct concepts.

The A5.1 syntax at `SevenSmooth.lean:5-7` is exactly `anchors: []`, `utility: none`, `digest: ...`, in that order. `none` requires no `basis`, `consumer`, `instance`, `premises`, `result`, or `claim` keys. Those fields are `not-applicable(kind=none)` in this report, not extra header syntax. `generality: I` is orthogonal to utility. The numeric lower bounds in the final proof are discharged, not assumptions in the public signature. No downstream-consumer claim is being used to evade the ordinary-instance prohibition.

Own source inventory receipts (matching lines; all EXIT 0):

```
rg -n '^(private )?(noncomputable )?(theorem|lemma|def|opaque|axiom|abbrev|instance|structure|inductive)\b' D5/S3/Arith/Robin/SevenSmooth.lean
# 16; inspected all matched declarations and the complete module
rg -n '^private theorem\b' D5/S3/Arith/Robin/SevenSmooth.lean
# 12
rg -n '^theorem\b' D5/S3/Arith/Robin/SevenSmooth.lean
# 1; positive control for anchored word-boundary declaration matching
rg -n '^private def\b' D5/S3/Arith/Robin/SevenSmooth.lean
# 3
rg -n '^   (anchors|utility|digest):' D5/S3/Arith/Robin/SevenSmooth.lean
# 3, at lines 5, 6, 7
```

The private witness's generated Lean name was also confirmed through the compiler environment in Q3. The meaning of the classification is reviewed here; no claim is made that `UTILITY-OBSERVED` alone establishes it.

Push receipt for Q3: `c8bdef184b`, EXIT 0. Q4 is recorded in the next checkpoint commit.

## Pending checks and nonclaims

At this checkpoint Q5-Q6 have not been concluded. The canonical report/axiom audit and mirrors remain pending. `make lean` has independently returned EXIT 0 in 16.224060833 s; its scope and the report command are recorded under Q5 when that check completes. No claim of general Robin, RH, novelty, search exhaustiveness, successful freeze, or remote CI/merge is made. No external literature page has been opened or used as evidence.
