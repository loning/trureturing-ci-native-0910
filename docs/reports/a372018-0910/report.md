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
