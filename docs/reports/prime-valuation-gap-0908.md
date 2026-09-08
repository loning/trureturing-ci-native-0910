# Fixed Prime Valuation Gap: Implementation Record

Provenance: this is the Codex implementation seat of the runner-owned
`prime-val-gap-0908/attempt-1` task. No local skill was invoked. The user supplied
the mathematical argument and preregistered the escape obligation in section IV.1
of the brief for [issue #6377](https://github.com/the-omega-institute/trureturing/issues/6377),
L3. One implementation seat produced the Lean proof, Scribe, numerical recheck,
and this self-audit. Independent review votes: none in this seat. Runner review,
orchestrator verification of the final implementation, and cross-model consensus
are `ASSUMED-UNVERIFIED`; the earlier numerical readings in the brief are user
reports, independently recomputed here as specified below.

`verdict: success` describes the implemented and locally kernel-checked theorem.
It does not assert that the PR is merged or independently approved.

## Question Answered

`question_answered`: for every fixed prime `p`, natural `A`, and real `epsilon > 0`,
there is `N >= 5041` such that every `n >= N` with `n.factorization p <= A` satisfies
`-log(1-p^(-(A+1)))-epsilon <= robinLogMargin n`. The preregistration is the user
brief, sections I and IV.1, and source atom `222eec7c...a9f6`, theorem 6.1.
`prime_valuation_gap_pos` proves strict positivity of this parameter-dependent
constant. No RH premise or explicit numerical threshold occurs in these statements.
Steps 5 and 6, including conclusions about sequences or profinite integers, are
outside this change. `Trureturing.lean` is unchanged.

The formal owner is `D5/S3/Weil/PrimeValuationGap.lean`. The source SHA-256 is
`bf91fd006f1da48326e5f1bd0d654d887f26098fbbf0912232781bcb63325616`.
The pinned environment is Lean `v4.33.0` and Mathlib
`db584cd6d46c92f209a44c0f1c829460d327499d`.

## Collision Check and Bind-Only Attempt

`collision_check`: the following commands were run with
`BASE=ca5b380483ff2ff9e7e2c9570463cdfddce1aeaa`. Counts are matching lines, except
the explicitly identified file count. The positive controls use the same PCRE
word-boundary feature as the searches reporting zero.

```sh
git grep -n -P '\b(bounded_prime_valuation_robin_margin_gap|prime_valuation_gap|prime_power_abundancy_ratio|robin_margin_gap)\b' "$BASE" -- D5 docs/reports
git grep -n -P '\b(padding_ratio|padding_abundancy|robin_log_margin_eq_neg_log|gronwall_upper_envelope)\b' "$BASE" -- D5/S3/Arith/Robin/PaddingRatio.lean D5/S3/Weil/GronwallLowerEnvelope.lean D5/S3/Weil/GronwallUpperEnvelope.lean
git grep -l -P '(?i)(robin|gronwall|sigma.*factorization|factorization.*sigma)' "$BASE" -- D5
git -C .lake/packages/mathlib grep -n -P '(?i)\b(robin|gronwall)\b|abundan.*(valuation|exponent)|sigma.*(valuation|exponent)' -- Mathlib/NumberTheory
git -C .lake/packages/mathlib grep -n -P '\b(sigma_one_apply_prime_pow|isMultiplicative_sigma)\b' -- Mathlib/NumberTheory/ArithmeticFunction/Misc.lean
```

Results, in command order: **0 lines / 13 control lines / 19 candidate files /
0 Mathlib lines / 8 Mathlib control lines**. The first two commands were repeated
against freshly fetched dev `2f09ee80b795ec4d624b122f55295b713b2381cd`, again
**0 / 13**. The newly added `SymmetricSigmaRepeatedPatternAbundancy` on that dev
has a different, conditional divisor-pair hypothesis and fixed sigma interval;
it does not supply this unrestricted bounded-valuation asymptotic estimate.

`dominating_theorem_search: not-found-in-searched-scope`. Candidate statements
in `PaddingRatio`, `PaddingTailMass`, and the Gronwall envelopes were inspected.
`padding_ratio` supplies a coarser `paddingQ` contraction, and `padding_abundancy`
is a one-layer estimate; neither directly gives the sharp constant required here.
Mathlib supplies sigma multiplicativity and prime-power evaluation, and these
are used rather than reproved. The search answers the brief's
`ASSUMED-UNVERIFIED` collision question with a bounded, negative search result,
not a claim of exhaustive semantic absence throughout the Lean ecosystem.

External searches actually attempted: Loogle `"robinRatio"` returned no result;
GitHub code searches `"gronwall_upper_envelope" language:Lean` and
`"sigma" "p ^ b" "factorization" language:Lean` returned no result. A GitHub
sigma-API positive control returned one file. Broad searches also returned
unrelated ODE/Robinson results. Google returned a challenge and is not counted
as a completed search. External completeness remains `ASSUMED-UNVERIFIED`.

`bind_only_attempt`: before creating the new module, the complete target was
probed using `padding_ratio`, `padding_constants`, `padding_bounds`, the public
Gronwall upper envelope, `robin_log_margin_eq_neg_log`, normalization, and
`sq_nonneg`, ending in `linarith only`. `make lean` exited **2**, specifically
`linarith failed` at the target. The complete probe is archived as
`bind-only.lean`, with `bind-only.make.log`, in the attempt directory below.
That temporary probe was removed from the project. Failure of this probe is an
observed failure, not a formal impossibility proof for all possible bindings.

## Limit Order and Escape Witness

Write `d = 1-p^(-(A+1))` and `k_b = d/(1-p^(-(A+b+1)))`.

`limit_order`: `fixed_boost_envelope hp A b q hq` has `b` as an input binder and
assumes `k_b < q`. It proves an `n`-threshold for that fixed `b`. It sets
`eta = (q/k_b-1)/2`, so `k_b*(1+eta) = (k_b+q)/2 < q`, and combines the frozen
Gronwall threshold with the limit of `loglog(p^b*n)/loglog(n)` at fixed `p,b`.
The final threshold is `max 5041 (max N1 N2)`.

Only after that general lemma is available does
`bounded_prime_valuation_robin_ratio` use geometric decay to choose one `b >= 1`
with `k_b < d+epsilon`. It then calls the lemma to obtain `N`. The binder order
is `p,A,epsilon -> b -> N -> n`; no layer count depends on `n`. In the final
margin theorem the ratio tolerance is `d*(exp(epsilon)-1)>0`, giving
`R(n) <= exp(log(d)+epsilon)`, then the frozen logarithmic identity applies.

`escape_witness`: the new quantitative intermediate proposition
`fixed_boost_envelope`, combining a local sigma estimate, a fixed-scale
logarithmic limit, and two independently chosen eventual thresholds. Its
statement is neither the final sharp envelope nor a renaming of it. The
preregistered escape in IV.1 was the local formula plus quantitative error
combination; the observed escape is that same combination. The local formula
alone is conservatively classified as a Mathlib normalization companion.

The elaborated dependency audit used Lean `--server`, an in-memory import of the
compiled module, and `ConstantInfo` type/value `Expr.getUsedConstants` at line 3
of `.sshx-prime-gap-audit.lean`. The one-shot client and full diagnostics are
`dependency-audit.mjs` and `dependencies.lsp.log`; the extracted unique records
are `dependencies.json`. The audit exited **0** with a completion diagnostic.
Two broken-pipe messages followed server shutdown, after all records arrived.

The compiler reports the edges (consumer -> prerequisite)
`bounded_prime_valuation_robin_margin_gap -> bounded_prime_valuation_robin_ratio
-> fixed_boost_envelope -> prime_power_abundancy_gain -> prime_power_abundancy_ratio`.
In the source proof, the fixed-boost inequality is the result returned by the
ratio theorem, the ratio inequality is passed to logarithmic monotonicity, and
the gain is used to derive `hsig` in the bound's calculation. None of these
edges is an unused local fact or a discarded conjunction component. This live
use analysis and the assertion that frozen bindings alone do not close the
target are the implementation seat's semantic assessment. Constant dependency
collection by itself does not mechanically prove the escape criterion.

`admission_basis: escape-witness`. `proof_shape: content` for the module after
inlining its new helpers. No separate deposit is claimed for a companion.

## Per-Declaration Classification

All short theorem names below belong to `D5/S3/Weil/PrimeValuationGap`.
Frozen dependencies in this table are direct constant references, as read by
Lean, not import reachability. Definitions are explicitly included. The
identities for F1-F5 follow the table.

| Public theorem | proof_shape | Direct frozen dependencies | escape_witness | admission_basis and companion edge |
| --- | --- | --- | --- | --- |
| `prime_power_abundancy_ratio` | bind-only | none | none; sigma normalization | escape-witness module, step-2 companion: `prime_power_abundancy_gain -> prime_power_abundancy_ratio` |
| `prime_power_abundancy_gain` | bind-only | none | none; power monotonicity and polynomial normalization | escape-witness module, step-2 companion: `fixed_boost_envelope -> prime_power_abundancy_gain` |
| `prime_valuation_gap_pos` | bind-only | none | none; logarithm sign | escape-witness module, named preregistered use `#6377/L3/section-I/strict-positive-c -> prime_valuation_gap_pos`; this use is a user proof obligation, not a claimed Lean dependency |
| `bounded_prime_valuation_robin_ratio` | content | F1 | `fixed_boost_envelope` | escape-witness |
| `bounded_prime_valuation_robin_margin_gap` | content | F1, F2, F4, F5 | `fixed_boost_envelope` on the active path through the ratio theorem | escape-witness |

The direct frozen boundary of `fixed_boost_envelope` is F1, F2, F3. Inlining
new helpers consequently adds F2/F3 to the ratio theorem's frozen boundary;
it does not add the lower-envelope or liminf theorems. No private theorem from
`GronwallLowerEnvelope` is referenced as an imported API.

| ID | Frozen GID | statement_id |
| --- | --- | --- |
| F1 | `D5/S3/Arith/Robin/PaddingRatio.robinRatio` (definition) | `sha256:37e65d572a4b0e282ea101a0af55d0b5055bf9987d16e1fb0b8b37b4613714d3` |
| F2 | `D5/S3/Arith/Robin/PaddingRatio.loglog_pos` | `sha256:cfa4b5af401876aad229b586b3e6fb2152a4a91bd69388096928f6013d765374` |
| F3 | `D5/S3/Weil/GronwallUpperEnvelope.gronwall_upper_envelope` | `sha256:71f76fd493dfb17f14987235c7aac9a41138daed463de4ab53eeb5d12a51051e` |
| F4 | `D5/S3/Weil/GronwallLowerEnvelope.robinLogMargin` (definition) | `sha256:ec876ef521e4a8e0a1287d40a86023cf72c28946728beacd5a6e990d3814c8cb` |
| F5 | `D5/S3/Weil/GronwallLowerEnvelope.robin_log_margin_eq_neg_log` | `sha256:e312c38cff0ca4957e770c02da32283ec8fcb33e34bf136fda65e1c3a9db83dc` |

`utility: none` was present at the module's first creation and was not
reclassified. For every row below, all four classes are absent:
`bounded-enumeration`, `checker`, `numeric-reduction`, `certified-instance`.
The classification is about the declaration's statement and role; using
`norm_num`, `omega`, or a finite geometric-sum API does not certify a finite
numerical instance. `basis`, `instance`, `premises`, `consumer`, `refutes`,
`claim`, and `result`: `not-applicable(kind=none)`.

| Declaration | Reason none of the four utility classes applies |
| --- | --- |
| `reciprocal_prime_bounds` (private) | Sign bounds for an arbitrary prime; no bounded population, certificate evaluator, numerical premise, or fixed instance. |
| `retention_pos` (private) | Positivity for arbitrary prime and natural exponent; no finite search or certificate/reduction interface. |
| `abundancy_pos` (private) | Positivity for arbitrary nonzero natural input; no enumeration, checker, numeric reduction, or concrete instance. |
| `normalized_sigma_prime_pow` (private) | Symbolic identity at arbitrary prime and exponent; the geometric sum has an unbounded parameter and is not an enumerated instance. |
| `normalized_sigma_pow_mul` (private) | General multiplicative identity with a coprimality assumption; it does not validate a computation or reduce a claim to numerical premises. |
| `prime_power_abundancy_ratio` | Exact formula for arbitrary nonzero n, prime p, and b; no finite domain, evaluator, numerical premise, or certified input. |
| `prime_power_abundancy_gain` | Inequality for arbitrary n,p,A,b; no finite enumeration or certificate, and the exponent bound is symbolic. |
| `prime_valuation_gap_pos` | Sign of an analytic expression for arbitrary p,A; not a decimal computation, checker, reduction, or concrete instance. |
| `tendsto_loglog_scale` (private) | Analytic convergence for arbitrary positive real scale and unbounded n; no numerical threshold calculation or certificate input. |
| `fixed_boost_envelope` (private) | General existential eventual bound with arbitrary p,A,b,q; thresholds are chosen analytically, with no finite checking or numerical premises. |
| `bounded_prime_valuation_robin_ratio` | Quantified asymptotic estimate for every prime and exponent bound; no enumeration, checker, numerical reduction, or fixed instance. |
| `bounded_prime_valuation_robin_margin_gap` | Quantified logarithmic asymptotic estimate with arbitrary tolerance; no finite certificate or numerical reduction. |
| `termZ` (generated private syntax definition) | Syntax parser for the local notation; it asserts no numerical mathematical result and implements no mathematical certificate checker. |
| `_aux_..._termZ_1` (generated private macro definition) | Expansion of that notation to sigma/n; syntax infrastructure, not an enumerator, certificate checker, numeric reduction, or certified mathematical instance. |

The raw report has **42** declarations: these **14** included declarations and
**28** generated auxiliary proof declarations excluded from statement identity.
Each excluded declaration is a compiler-generated subproof of the corresponding
general theorem; none introduces a numerical input family, checker, numerical
reduction, or separately certified finite instance. Their exact names, types'
hashes, and axiom closures are preserved in `prime-gap-report.json`.

## Independent Rechecks and Validation

`step2_recheck`: Python `Fraction` independently verified **64** displayed
identity cases, **90** exponent-window monotonicity cases, and **2048** actual
sigma-ratio cases. Failures: **0**. These include all parameter grids specified
in section III of the user brief.

`step3_recheck`: **64** cases at **80** Decimal digits checked
`R(n)=R(p^b*n)*(Z(n)/Z(p^b*n))*(loglog(p^b*n)/loglog(n))` and the corresponding
logarithmic difference identity. Maximum absolute errors were **5e-80** and
**1.4e-79**, respectively. A fixed positive normalization factor cancels in the
identity; the decimal approximation to gamma supplies no proof premise.

The five independently recomputed positive constants, rounded here, were
`0.69314718`, `0.06453852`, `0.11778304`, `0.00803217`, `0.0004884005` for
`(p,A)=(2,0),(2,3),(3,1),(5,2),(2,10)`. These values support no uniform positive
lower bound over all p,A. `recheck.py` and `recheck.json` are retained as
experiments and are not imported by Lean.

`axioms`: all five public theorems have exactly
`[propext, Classical.choice, Quot.sound]`; no `sorryAx`, `native_decide`, new
axiom, or RH assumption is in the checked closure.
`local_make_lean_EXIT: 0` (`asymptotic-3.make.log`).
`make lean-report` EXIT **0** (`lean-report.log`), report SHA-256
`750c7b50c423341ceb1cf61b19d551a487a4ca15d8d1fc04f8593a68feeb74c6`.
`make emit` EXIT **0** (`emit.log`).

Failure accounting: the local-factor proof required elaboration corrections,
then `local-factors-3.make.log` passed. The first two asymptotic builds failed
at the function quotient in `hquot`; adding `Pi.div_apply` did not resolve its
type inference. A complete `Tendsto` type annotation resolved it in the third
build. The fixed-b input threshold lemma passed on the first asymptotic build.
These two failures concerned elaboration of the single b-limit, not interchange
of the b and n limits. There were **0** failures of the limit-order design.

## Deposit and Delivery

Form: `deposit+cover`. Source `zeckendorf-euler-5040`, atom
`222eec7c9a85c2ba925666cf6caeaa68ac58522890a814b0f202cd788793a9f6`, theorem 6.1,
is covered by `D5/S3/Weil/PrimeValuationGap.bounded_prime_valuation_robin_ratio`.
The CAS statement is the same sharp upper-envelope claim in limsup notation;
the Lean statement supplies the requested epsilon/threshold form. The brief's
stronger requested output in logarithmic notation is also proved. No adjacent
source atom about sequences or divisibility is covered.

`frozen_output`: v5 Freeze event
`sha256:775991cd67490e115770633d5214790d0857dddb12b2c65bf2cb513c6a622d0c`,
module statement ID
`sha256:132c5eb1be40b0b38be20da4d6aa994f25ab2dae2e64f79ca2c261846f520e3d`.
Anchor transition: `residual-open -> absorbed-closed`. The atom existed with
`coverage_gids: []`, so this is not the `frozen, uncovered` fallback.

The first `make deposit` exited **2** because the new Blueprint Markdown mirror
had not yet been emitted; no freeze had occurred on that attempt. After
`make lean-report` and `make emit`, the second deposit generated the event and
coverage above and exited **0** (`deposit-2.log`).

`pushed`: the completed local-factor component `320d965f4a3616a7e0164b82e1c995973112fea1`
and asymptotic component `205a63f379f8d01668a10f71f8f59590d15e602d` were each
committed and pushed. The deposit and audit component is committed separately.
`pr`: delivery uses `make pr-open`; its URL, terminal exit, and actual
remote state are recorded in `result.json`. This document makes no merge claim.

Pre-PR collision recheck used dev `2f09ee80b795ec4d624b122f55295b713b2381cd`.
The preliminary `git merge-tree --write-tree HEAD <dev-sha>` at implementation
commit `205a63f379` exited **0**, tree `c7382366ab8c95ef15a130d4af9dc5b46bb38da5`.
The final committed deposit is checked again before opening the PR. Source and
frozen predecessors were not modified. Unrelated old Blueprint regeneration
changes are excluded from the commit.

`assumed_unverified`: independent semantic review of escape/admission/utility,
external-search completeness, any future CI state, and any unobserved merge.
No unresolved mathematical premise is admitted into the theorem.

Attempt artifacts reside at
`/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/prime-val-gap-0908/attempt-1`.
`result.json` is the complete structured conclusion and `worker.stdout.log` is
the runner-visible execution log. The worker publishes the envelope atomically
before its completion sentinel.
