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
- Checkpoints: Q1 complete; Q2-Q6 pending. Overall verdict is pending until all six questions are reviewed.

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

## Pending checks and nonclaims

At this checkpoint Q2-Q6 have not been concluded. Own Make exits, canonical axiom closure, elaborated witness use, preregistration, classification, and mirrors remain pending, not inferred from implementation reports. No claim of general Robin, RH, novelty, search exhaustiveness, successful freeze, or remote CI/merge is made. No external literature page has been opened or used as evidence.
