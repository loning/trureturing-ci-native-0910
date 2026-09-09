# A372018 odd coefficient identity — implementation record

## Origin and scope

- Skill: `lean4`; implementation by the Codex worker in the supplied worktree. No independent review has been performed by this worker.
- User's orchestration context: consensus-rnd/sshx, implementation attempt 1. The user's exact rational checks for n=0..58 are reported by the user, not rerun or claimed as a proof here.
- Base: `d59adb46d4703e7fdc7ef7569c5c0919247cc87a`; branch `lane/math/a372018`.
- Tier 1. The missing argument in `A371364()` is approved as `A371364(n)` by the user.
- Target: independently defined rational formal power series satisfying the two supplied algebraic equations, and `[x^(2n+1)] A = 2 [t^n] B` for all n.
- No theory volume or atom will be created. The canonical `deposit-uncovered`/`ledger-align --add` route will be used if the proof succeeds.

## Preregistered proof route

Use u=A(x), v=-A(-x), s=u+v. Subtract the two cubic root equations and cancel u-v using its nonzero constant coefficient 2. Eliminate the product uv polynomially, without constructing Laurent series. The proposed live intermediate witness is the eliminated equation for the odd part, equivalent after removing powers of x and the factor 4 to C(1-4tC)^2=1-3tC. Identify C with the independently defined B by uniqueness. The elimination and uniqueness bridge are not yet verified.

Stop as blocked with a concrete Lean goal/error if root comparison requires false invertibility or the uniqueness bridge cannot be completed. No finite check will be described as progress on the unbounded theorem.

## Search receipts

- Read all of `CLAUDE.md` in chunks after the initial full-file tool output was truncated; read `agents/CONTEXT.md` and the Lean skill.
- D5 preliminary search: `rg -n 'A372018|A371364|PowerSeries|power.series|convolution_pairing' D5 --glob '*.lean'` found many power-series modules; output was too broad and was truncated. This is a discovery pass only, not a completed public-API audit. Targeted follow-up is pending.
- Pin files read: Lean 4.33.0; lakefile mathlib tag v4.33.0. Manifest commit verification pending.
- Spec A5.1 read: general mathematical results use the exact header `utility: none` when all declarations fall outside the four computational classes.
- External source pages: ASSUMED-UNVERIFIED until individually opened below.

## Declaration accounting

No public declarations or frozen dependencies yet. `proof_shape`, `escape_witness`, direct frozen GID/statement_id pairs, and `admission_basis` will be recorded per declaration as implemented.

## Validation

Not run yet. Required order: `make lean`, `make lean-report`, `make emit`, Scribe content checks, freeze, commit, push. No `native_decide`, no cold bare Lake, no `make preflight`.

## Not claimed

No formal proof, counterexample, literature novelty, independent review, successful build, freeze, or PR is claimed at this checkpoint. The user supplied Vieta sketch remains unverified here.

## Search and cache checkpoint

- Manifest confirms mathlib `db584cd6d46c92f209a44c0f1c829460d327499d`.
- `make lean-cache-ensure` EXIT=0: `status=seeded`, `method=clonefile`, donor `/Users/chronoai/trureturing`, `clonefile_attempts=1`, `stamp_miss=null`, project and mathlib both `warm`, missing mathlib oleans=0, archive skipped because project is warm.
- Targeted D5 lookup found no A372018/A371364. Read public signatures and relevant bodies in `CubicNinthPowerSubstitutionModThree`, `HalfScaledReflectionParity`, `ReflectedQuadraticQuarterParity`, `CompositionalIterateCongruence`, and `ConvolutionRecurrenceOddPowersOfTwo`. In particular `convolution_pairing` is general over f but explicitly in ZMod 2; it supplies a modular convolution identity, not the required rational equality. The public `fixed_unique` in CompositionalIterateCongruence is tied to that module's specific step. Generic coefficient agreement and polynomial contraction helpers in the inspected modules are private.
- Mathlib inspected Basic/Substitution/Expand and related API search: `coeff_succ_X_mul`, `X_pow_dvd_iff`, `rescale`, `coeff_rescale`, `rescale_neg_one_X`, `expand`, `coeff_expand_mul` are reusable. No target or generic algebraic fixed-point construction found in searched PowerSeries files. A guessed Rescale.lean path does not exist; actual definitions are in Basic.lean. This failed path is not counted as a search hit.
- External GitHub code searches `A372018 language:Lean` and `A371364 language:Lean` each returned `[]`; arXiv `all:A372018 OR all:A371364` returned totalResults=0. Network capability was actually exercised.
- Opened both OEIS `/internal` pages (HTTP success; raw HTML in attempt-1/sources). A372018 explicitly says “Conjecture: a(2n+1) = 2*A371364().” A371364 specifies the reversion in the brief and offset 0. These two pages contain no proof of the bisection. One-hop cross-references still pending; no global novelty claim.
- Capacity: Recurrence root has 24 Lean files and 48 Blueprint files; do not add at that root. A subdirectory must be selected before implementation.

Proof route refinement before coding: compare s=A(x)-A(-x) directly with 4xB(x²). The proposed elimination is `s(1-xs)^2 = 4x-3x²s`. Its difference factor has constant coefficient 1, so uniqueness can use domain cancellation. This is the same proposed Vieta elimination, with the rescaling bridge performed without constructing C or Laurent series. Define A independently via A=1+xH and the polynomial contraction H=2+x(3H-H²/2+3xH²/2+x²H³/2); define B independently via B=1+x(8B²-3B-16xB³). Neither definition uses the odd identity. These statements remain unverified until Lean checks them.

## Construction checkpoint

- Route returned `D5/S1/Recurrence/Algebraic/CubicOddBisection.lean`, S1/I. Both new Algebraic directories start empty; Recurrence root Blueprint is full and Invariants is already 50, so neither receives an additional file. Route initially rejected `artifact: null` and literal `tag: null`; corrected to `artifact: lean` and empty fields, then EXIT=0.
- Four one-hop sequence cross-references were fetched with curl and their complete internal entries read: A372019, A372020, A059231, A371365. They contain no proof of this bisection. Python urllib's 403 was a transport failure, recovered by curl. A059231's linked papers are second-hop references and remain ASSUMED-UNVERIFIED; they are not asserted to have been opened.
- Mathlib `Polynomial.sub_dvd_eval_sub` read and directly used for coefficient contraction. HenselianRing's inspected primitive requires a monic polynomial and a quotient simple-root lift; no direct ready-to-use statement for the present nonmonic series equations was found.
- First actual Lean attempt: `/tmp/a372018-construction.lean`. The generic coefficient agreement, contraction, stabilization and fixed-equation lemmas elaborated without errors. The two equation proofs failed because ring treated unfolded polynomial arguments and rational C constants as distinct atoms. Those errors are implementation goals, not mathematical obstructions.
- Preserve the verified construction lemmas in the module now. Before the next test, rescale A=1+2xH; the independent contraction becomes H=1+x(3H-H²+3xH²+2x²H³), removing rational constants. B's contraction is unchanged.

Both independent definitions and their exact equations now pass `lake env lean D5/S1/Recurrence/Algebraic/CubicOddBisection.lean`, EXIT=0 (warm tree). `A_equation` proves the constant 1 and original cubic; `B_equation` proves the constant 1 and original normalized reversion equation. No odd-index relation is present in either definition. The earlier ring failure is resolved by integer rescaling and separate polynomial evaluation lemmas. Uniqueness and elimination remain to implement.

## Unbounded identity verified

`lake env lean D5/S1/Recurrence/Algebraic/CubicOddBisection.lean` now EXIT=0. All five public theorems (`A_equation`, `B_equation`, `A_unique`, `B_unique`, `odd_coeff_identity`) have exactly the standard axiom set propext/Classical.choice/Quot.sound. The full natural-number quantified identity is proved, not inferred from a finite prefix.

The Vieta route is now kernel-verified without Laurent series: subtract the cubic equations, cancel u-v using constant coefficient 2, derive `uv(1-x(u+v))+1=0`, and eliminate uv. The difference factor for the resulting sum equation has constant coefficient 1; comparison with 4xB(x²) follows. No use of invertibility of x, of u+v, or of a zero-constant series occurs. A_unique cancels a factor of constant coefficient -2; B_unique cancels a factor of constant coefficient 1.

Two local proof errors were repaired before the successful check: an expansive `neg_pow` simp expression exceeded recursion depth (replaced by map simplification and ring-based linear combination), and a no-progress `simp` became `simp only [map_ofNat]`. These were elaboration errors; the final printed axiom sets have no sorryAx.

Project make gates, Scribe, freeze, and PR remain outstanding; this checkpoint does not claim them complete.
