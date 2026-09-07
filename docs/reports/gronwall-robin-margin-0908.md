# Gronwall's Logarithmic Robin Margin

Provenance: runner-owned consensus-rnd implementation brief
`gronwall-margin-0908/attempt-2`; one Codex implementation worker, no additional
skill or review seats. The worker read the source atoms and ran the commands
reported here. Independent review and orchestrator verification are not claimed.

Base: `809b94047831081e39cb208190827842c473aec7`.
Branch: `lane/math/gronwall-margin-0908`.
Shape: deposit plus cover in the existing, previously unfrozen
`D5/S3/Weil/GronwallLowerEnvelope` module.

## Source Fidelity

The following commands all returned `EXIT=0`:

- `make show-atom ATOM_ID=28dffefe4ff3c5e2ea3248926b810e5fa6f97828564cd867e158fbaeeddcd136`
- `make show-atom ATOM_ID=193ec8a973b0f1935699fc5db6f27c6141d90c97fa50b13f00185acab6bb8de5`
- `make show-atom ATOM_ID=323b49574bd9fe6f6b3f82fadaae9d41d51e0993810992f09b4e9e06da2d9b2a`
- `make show-atom ATOM_ID=38e6c042a4cdad4b5619f7ca7267edd44e5ef10090edfd71aeef5d221c98b9ec`
- `make show-atom ATOM_ID=ddb4f6fb76c318def9a52083b7e6ec453a0a2d09275271d1f568671179949b74`
- `make show-atom ATOM_ID=4d06ca9f0aca18cea5d9407cb858d339c341818436ed1aa1f2e2ede6d8e8777a`

These 64-character strings are the actual complete CAS basenames in this base;
`show-atom` resolved and verified each one as printed. No prefix was guessed.
The source defines `Z(n) = sigma(n)/n`, `W(n) = ln Z(n)`, `E(n) = ln n`,
`h(E) = gamma + ln ln E`, and `Delta(n) = h(E(n)) - W(n)`.
The proof atom `28dffefe...` explicitly identifies `Delta(n) = -ln u_n`.

`robinLogMargin` therefore uses the additive logarithmic formula. The theorem
`robin_log_margin_eq_neg_log` identifies it with the negative log of the existing
`PaddingRatio.robinRatio` for every `n >= 5041`. The liminf theorem is over
natural numbers at infinity; no small-input convention or log-zero value is
used to establish its eventual or frequent bounds.

The two leaf targets `38e6c042...` and `ddb4f6fb...` have exactly the requested
boxed conclusion and no chain children. The parent `323b4957...` has children
`38e6c042...` and `4d06ca9f...`; the latter asserts a further joint trend about
favorable layers and omitted error. That assertion is not proved here, so the
parent is skipped, with no new direct coverage edge. The compound Robin/RH atom
`bd31a947afd7...` is outside this task.

## Restricted Reproof and Admission

`question_answered`: does the logarithmic Robin margin have liminf zero,
unconditionally? This was preregistered in the runner brief, including the
existing content witness `prime_power_error`, before this worker's proof probe.

`dominating_theorem_search`: repository searches for Gronwall, Robin, and liminf
found the two existing envelopes and `PaddingRatio.robinRatio`. The pinned
Mathlib NumberTheory search `rg -n -i '\bgronwall\b|\brobin\b'` had zero hits
(`EXIT=1`); the same word-boundary search with `\bsigma_pos\b` had two hits
(`EXIT=0`). This is only a result in the searched scope. Mathlib's general
`log_le_iff_le_exp`, `log_le_log`, `liminf_le_iff'`, `le_liminf_iff'`, and
`IsCoboundedUnder.of_frequently_le` directly supply the needed analytic APIs.
Pin: Mathlib v4.33.0, commit `db584cd6d46c92f209a44c0f1c829460d327499d`.

The first restricted implementation passed `make lean`, `EXIT=0`, without a
failed proof iteration. It uses the two envelope projections, the frozen
denominator positivity lemma, direct Mathlib instantiations, and normalization
(`simp only`, `ring`, `omega`, `norm_num`, `linarith only`). For a test level
`b < 0`, choose epsilon `exp(-b)-1` in the upper envelope. For `b > 0`, choose
epsilon `1-exp(-b)` in the lower envelope. Log/exp order equivalences give the
two required margin bounds; Mathlib's liminf characterizations finish the proof.
The boundedness and coboundedness hypotheses are supplied explicitly.

Public theorem assessments:

| Declaration | proof_shape | Basis |
| --- | --- | --- |
| `gronwall_lower_envelope` | content | Existing live witness `prime_power_error` |
| `gronwall_envelopes` | bind-only | Named companion, conjunction of the two envelopes |
| `robin_log_margin_eq_neg_log` | bind-only | Named companion, log normalization |
| `robin_log_margin_liminf` | bind-only | Named companion, both envelopes plus Mathlib order APIs |

Module `admission_basis`: `escape-witness`. The inherited private theorem
`prime_power_error` bounds the prime-power product uniformly in its prime cutoff
by a geometric factor times the reciprocal-square series. It lies on the live
path `gronwall_lower_envelope -> habund -> prime_power_error`: the product lower
estimate is consumed in the final normalized ratio bound. It is neither the
lower-envelope conclusion nor an alias of it. Removing it leaves the uniform
numerator-loss estimate unavailable from the existing Mertens limit alone.
The Robin corollary adds no independent escape witness or new deposit module.

Companion edges below use declaration names in
`D5/S3/Weil/GronwallLowerEnvelope`; every arrow is **consumer -> prerequisite**:

| Consumer | Prerequisite | Source atom or obligation |
| --- | --- | --- |
| `gronwall_envelopes` | `gronwall_lower_envelope` | `28dffefe4ff3c5e2ea3248926b810e5fa6f97828564cd867e158fbaeeddcd136` |
| `robin_log_margin_liminf` | `gronwall_envelopes` | `ddb4f6fb76c318def9a52083b7e6ec453a0a2d09275271d1f568671179949b74` and `38e6c042a4cdad4b5619f7ca7267edd44e5ef10090edfd71aeef5d221c98b9ec` |
| `robin_log_margin_liminf` | `robin_log_margin_eq_neg_log` | The same two liminf atoms, using the `28dffefe...` proof bridge |
| `robin_log_margin_eq_neg_log` | `robinLogMargin` | Definition in `193ec8a973b0f1935699fc5db6f27c6141d90c97fa50b13f00185acab6bb8de5` and bridge in `28dffefe...` |

Existing frozen owners used by this proof family include
`D5/S3/Arith/Robin/PaddingRatio`
(`statement_id=sha256:92138fa88d4573276b734bc41395655a40474f1f33bcf5024772ef228b01fab7`)
and `D5/S3/Weil/Mertens/Third`
(`statement_id=sha256:673a069e2ca56dd5e4c756b4a45f46ca48585ce34e89bba9a8cfc0e7e50ec2e9`).
The existing Gronwall envelope API is being reused inside its original proof
family; the base does not have a GronwallUpperEnvelope state shard.

## Utility Assessment

Header retained: `utility: none`. This is a declaration-level assessment:

| Declaration | Reason none of the four computational classes applies |
| --- | --- |
| `one_sub_sum_le_product` | Uniform finite-set inequality by induction, no bounded enumeration or instance |
| `prime_power_error` | Uniform analytic series estimate for all exponents and cutoffs |
| `sigma_primorial_power` | Symbolic factorization identity at arbitrary parameters |
| `normalized_mertens` | Asymptotic limit obtained from the frozen Mertens theorem |
| `loglog_primorial_power_le` | General logarithmic denominator estimate |
| `gronwall_lower_envelope` | Unbounded existence theorem, with no computed certificate or numeric premise |
| `gronwall_envelopes` | Logical packaging of two analytic estimates |
| `robinLogMargin` | Noncomputable real-valued definition |
| `robin_log_margin_eq_neg_log` | Symbolic identity on the Robin domain |
| `robin_log_margin_liminf` | Unconditional asymptotic equality |

Small arithmetic normalizations in these proofs are not their delivered
content. None is a bounded enumeration, checker, numerical reduction, or
certified concrete instance. Other utility fields are
`not-applicable(kind=none)`. The public declarations' actual `#print axioms`
outputs all report `[propext, Classical.choice, Quot.sound]`.

The frozen-membership probe
`rg --files -uuu Golden/Frozen/state/D5/S3/Weil | rg '\bGronwallLowerEnvelope(/|\.lean\.json$)'`
returned zero hits (`EXIT=1`). The identical expression with `Budget` in place
of `GronwallLowerEnvelope` returned 23 hits (`EXIT=0`); Budget is a directory,
not a module called Budget. An earlier `.lean.json`-only Budget probe missed
that distinction and is not used as positive evidence.

No Library note is created or changed. The existing Gronwall note retains its
verified bibliographic and secondary-source locator scope; the new Scribe
corollary is attributed to the repository derivation from the classical theorem.

## Prerequisite Freeze

The first canonical deposit returned `EXIT=2` before creating any Freeze:
`module D5/S3/Weil/GronwallLowerEnvelope.lean dependency
D5/S3/Weil/GronwallUpperEnvelope.lean has no accepted Freeze`.
The upper module's missing membership has the same word-boundary positive
control as the lower module: 0 upper hits against 23 Budget hits.

The necessary prerequisite is the unchanged upper module from merged
[PR #6204](https://github.com/the-omega-institute/trureturing/pull/6204).
Its five public theorems retain `proof_shape: bind-only` and
`admission_basis: rule-11-upstream-wrapper`, as recorded before this task.
The concrete API obligation is the Gronwall consumer preregistered by the
Mertens III port in [PR #6171](https://github.com/the-omega-institute/trureturing/pull/6171).
The upstream declaration `Mertens.E₃.bound''` is used at `hmertens`, then
`hbound`, then the final upper inequality. Its declaration identity is
`sha256:d4c36eb2836729fdc7d27b8d61849d723fcc7cce45f668568c6fad517f95b817`;
its direct frozen owner is `D5/S3/Weil/Mertens/Third` with the module identity
recorded above. There is no new escape-witness claim for the upper module.

The existing upper companions discharge the named small-prime padding,
large-prime count/product, and divisor-sum split obligations. Their directed
edges, all consumer -> prerequisite, are:
`sigma_split -> small_prime_product_le`,
`large_prime_product_le -> large_prime_count_le`,
`sigma_split -> large_prime_product_le`, and
`gronwall_upper_envelope -> sigma_split`.
The full endpoints are in `D5.S3.Weil.GronwallUpperEnvelope`.
The finite companions have no direct D5 theorem dependency.

The upper header also retains `utility: none`. All six declarations in its
canonical statement set were assessed:

| Declaration | Reason none of the four computational classes applies |
| --- | --- |
| `small_prime_product_le` | Uniform symbolic product comparison at arbitrary cutoffs |
| `largePrimes` | Noncomputable finite-set definition depending on an arbitrary real cutoff |
| `large_prime_count_le` | General analytic bound, with no evaluated finite instance |
| `large_prime_product_le` | General logarithmic/exponential estimate |
| `sigma_split` | General arithmetic factorization bound, with no numeric premise |
| `gronwall_upper_envelope` | Eventual asymptotic bound over unbounded natural inputs |

The canonical report gives only `[Classical.choice, Quot.sound, propext]`
for each of these six declarations. Prerequisite freezing uses the same
canonical `ledger-align --add` writer as deposit, with this task's successful
`make lean-report` artifact. It does not attach the upper theorem to an atom
whose full conclusion is stronger than the upper envelope.

The upper header precheck and canonical writer both returned `EXIT=0`.
Writer receipt: `selectors_considered=3655 changed=0 added=1 unchanged=3654
conflicts=0`. It added only the upper state shard and accepted event
`2f5adf076e66565f8231e8f57e0973540395ef4a2817fa550f3acc35129ef596.json`.
The module pin is
`sha256:5649f49b7a510331194224220fb89ddf3339817611eac068d46a8679c5424e27`.

## Deposit Receipt

After the prerequisite repair, this canonical command returned `EXIT=0`:

```sh
make deposit ATOM_ID=ddb4f6fb76c318def9a52083b7e6ec453a0a2d09275271d1f568671179949b74 GID=D5/S3/Weil/GronwallLowerEnvelope.robin_log_margin_liminf BASE=809b94047831081e39cb208190827842c473aec7
```

The workflow requires a declaration selector in GID; the bare module address
in the brief is therefore resolved to the exact liminf theorem above.
The lower writer receipt is `selectors_considered=3656 changed=0 added=1
unchanged=3655 conflicts=0`. The new state shard is
`Golden/Frozen/state/D5/S3/Weil/GronwallLowerEnvelope.lean.json`, with module pin
`sha256:c60de55af3115013bec6914e8646e38d066c81c25fded53f1dc362ec12766da0`.
Its accepted event is
`Golden/Frozen/accepted/c96dca6ca8759722b55d4763a3244f50cb191eefa742d548f34953a014b0e227.json`.
It freezes all ten declarations and records the upper and PaddingRatio events
as prerequisites. No previously accepted event or previously frozen source
was edited.

The anchor moved from `residual-open` to `absorbed-closed`, with
`target_statement_id=sha256:c87d805981b4faae9762314dd5e88987c8aff0aed2a46bde06299be0ac7495bb`.
The report producer reused the validated warm-cache input
`sha256:1cf48422bf9b77f028924692050ca07e6087cb2562b2b6b7a7e1525c2443c59a`;
the raw report SHA-256 is
`80a722a8eeac2169f844a4bf3be55a760e44a8ed147a53297e70e9ebaf2c2183`.
The initial failed deposit and the successful retry are both retained in the
attempt directory as `deposit.log` and `deposit-retry.log`.

## Coverage and Scope

`make cover-batch ATOMS=<attempt-2>/cover.tsv
BASE=809b94047831081e39cb208190827842c473aec7` returned `EXIT=0`.
The TSV contains one row for `38e6c042...`, using the same liminf declaration
and statement identity as the deposit anchor. The final states are:

| Full atom basename | Action | Final state |
| --- | --- | --- |
| `ddb4f6fb76c318def9a52083b7e6ec453a0a2d09275271d1f568671179949b74` | Covered by deposit | `absorbed-closed` |
| `38e6c042a4cdad4b5619f7ca7267edd44e5ef10090edfd71aeef5d221c98b9ec` | Covered by cover-batch | `absorbed-closed` |
| `323b49574bd9fe6f6b3f82fadaae9d41d51e0993810992f09b4e9e06da2d9b2a` | Skipped: unproved chain child `4d06ca9f...` | `residual-open`, unchanged |

The parent's ledger bytes and empty direct coverage list remain unchanged;
it was not relabeled as closed or partial-closed. The excluded compound
Robin/RH atom was not touched.

The inherited implementation's `gronwall-lower-0907/attempt-1/proof-dependencies.log`
was also read. Its elaborated `PROOF_VALUE_CONSTANTS` lists `prime_power_error`
directly under `gronwall_lower_envelope`, and `one_sub_sum_le_product` under
that witness. This task's source diff leaves those existing proofs unchanged.
The live-path assessment above is a proof/source assessment supported by that
compiled dependency audit; no new automatic liveness decision or independent
review is claimed.

Before opening, fetched dev was
`34f741cf3707f25a5b4875167f874e664a82171b`.
`git grep -n -P '\b(robinLogMargin|robin_log_margin_liminf)\b' origin/dev -- D5`
returned `EXIT=1`, zero hits. The same command with
`\b(gronwall_lower_envelope|gronwall_envelopes)\b` returned `EXIT=0`, five hits.
This is a scoped collision check. The dev deletion set since the recorded
base is empty.

The complete change is 12 paths when both sides of each ledger migration are
counted separately (`git diff --name-status --no-renames <base>`), or 10 files
with rename detection. This is within the 13-path budget; no rule 16-double-prime
exception is invoked. The four Frozen paths are all additions.
