# Tier A admission-basis and fidelity triage, 2026-09-09

LANE: #6160. Repository: https://github.com/the-omega-institute/trureturing.
Worktree: `/Users/auricstudio/trureturing-robin7smooth-0909`.
Branch: `lane/math/tierA-basis-triage-0909`.
Pinned starting commit: `eb28454e6a3832d6301ade1a43ff6c5ae9dca069`.
Local Mathlib revision: `db584cd6d46c92f209a44c0f1c829460d327499d`.

Provenance: no locally invoked skill; one Codex worker performs this judgment.
The enclosing runner supplied a thinking-stage brief; no independent reviewer or
multi-model consensus is claimed by this report. User-supplied `tierA.json` is
an untracked input, read without modification. The tracked probe brief was read
first, followed by the complete `CLAUDE.md` and `agents/CONTEXT.md`.

## Preregistration (before atom judgments)

The orchestrator predicts that only a minority of the seven candidates qualify
as (b), and most are normalization-only statements with no admission basis.
This is a prediction, not a finding. It may be overturned only by individually
citing a locally checked upstream declaration and explaining thinness.

Inherited scope restriction, taken as a premise:

> Temporary probes only test the statements explicitly printed in their files;
> a passed subclaim cannot certify a larger source assertion.

Fidelity and admission are separate axes. Read each complete CAS atom with
`make show-atom ATOM_ID=<full-id>`. Compare every boxed clause and assertion
against the original probe, including quantifier direction, strictness,
parameter domains, extra hypotheses, and excluded degeneracies. Clause statuses
are `verbatim`, `equivalent`, or `not-covered`. A proper subset is `partial`.

The admission set is closed (`CLAUDE.md` 3.2): `escape-witness`,
`rule-11-upstream-wrapper`, `atom-required-bridge`. All seven supplied probes
are `bind-only`, so `escape-witness` is unavailable. An upstream elementary
rewrite that supplies an ingredient does not thereby carry the whole conclusion.
The bridge exception requires an explicit atom clause, a previously absent typed
edge between independent concepts, and a preregistered named downstream consumer.
`refutes` satisfies a utility conjunct only (3.3), never a fourth admission basis.

Reporting precedence: a missing source clause gives `partial-fidelity` even if
the tested subset has a wrapper basis; admission for that subset is recorded
separately. `wrap-and-cover-eligible` requires full fidelity plus an established
basis. `no-admission-basis` can coexist with explicitly reported fidelity gaps.
Unreadable/non-assertional text is recorded as `not-an-assertion` and explained.

Scope: judgment only. No production modules, cover, deposit, or PR. Each completed
atom judgment is committed and pushed before advancing to the next one.

## Progress

`screened: 2 / 7`. Completed: M4 readback, Schur minimum.

## Evidence Coordinates

Original probes and run receipts are read as data from immutable prior commit
`e12ff7dd3541336028fa60edc684ff8a4fbcd7b4` (prior lane). Below, `prior/` means
`docs/reports/digestion/tier3-mathlib-triage-0909/` at that commit, accessed by
`git show <commit>:<path>`. They are not present on this lane's starting tree.
Prior successful compilation is inherited evidence, not a new run in this seat.
`lake-manifest.json` pins Mathlib v4.33.0 to the local revision stated above.
Source coordinates below refer to this seat's pinned starting tree, not a live
remote branch. `QUANTUM-RH.md` abbreviates `docs/develop/theory/QUANTUM-RH.md`.

## Atom 75: M4 Readback

`atom_id: 7d5d9c72f7ad9abb794dd61d99e68ff5adc1271970f00e4a009b9e334680a0d2`

Complete raw body returned by `make show-atom` (exit 0, hash matches, no coverage):

```text
## 定理 M4：有限算术关系可以精确回读

$$
\boxed{
\mathcal R_{n\leftarrow d}[P_d]=P_n.
}
\tag{M25}
$$
```

| Source assertion | Original probe counterpart | Status | Domain and boundary check |
| --- | --- | --- | --- |
| M25 and the heading's exact-readback assertion | `Triage75.readback`: `recover n d (model a d) = model a n` | equivalent | Universal in `a : Nat -> Real`, `n d : Nat`; `0 < d`, `n <= d`. Source defines layers for `d >= 1` at lines 135-153 and readback for `n <= d` at 11029-11045. Positive `n` is included; probe also allows `n = 0`, so it does not exclude a source case. Equality is equality of polynomials, hence at every argument, with the actual weights `(d)_k/d^k`. |

`fidelity: full`. There is one boxed assertion and no additional assertion in
this atom. The subsequent error bound in the source is outside these CAS bytes.
The actual coefficient sequence is an instance of the arbitrary real sequence;
the probe assumes no extra regularity or positivity of that sequence. Denominators
are nonzero for every summand `k <= n <= d`, including `k = 0` and `k = d`.

`upstream_declaration: none` (none carries M25). Locally opened ingredients:
`Polynomial.coeff_monomial`,
`.lake/packages/mathlib/Mathlib/Algebra/Polynomial/Basic.lean:581`, states only
`coeff (monomial n a) m = if n = m then a else 0`;
`Nat.descFactorial_pos`,
`.lake/packages/mathlib/Mathlib/Data/Nat/Factorial/Basic.lean:374`, states only
`0 < n.descFactorial k <-> k <= n`.

`wrapper_thinness: not-applicable`. Neither ingredient states a readback
identity. The probe defines the weighted polynomial and coefficient multiplier,
extracts each coefficient, and closes by `field_simp`; this is normalization.
`necessity_citation`: M25 is a real coverage demand, quoted above, but it does
not make an ingredient into an upstream readback theorem. No explicit bridge
between independent concepts or preregistered named consumer is supplied.
`verdict: no-admission-basis`; `admission_basis: none`.
`proof_shape: bind-only`; `direct_frozen_dependencies: []`; `escape_witness: null`.
`why_not_escape_witness`: every coefficient equality follows by instantiating
the two ingredients and cancelling the same nonzero weight; no new live
intermediate proposition survives the bind-only reconstruction.

Search receipt R75: `rg -n '\b(readback|Readback|coeff_monomial|descFactorial_pos)\b' D5`
returned 11 lines, including unrelated causal-language readbacks and coefficient
rewrite uses; this is a lexical candidate search, not a semantic dependency census.
Positive control with the same `\b` and alternation features:
`rg -n '\b(coeff_monomial|descFactorial_pos)\b' .lake/packages/mathlib/Mathlib/Algebra/Polynomial/Basic.lean .lake/packages/mathlib/Mathlib/Data/Nat/Factorial/Basic.lean`
returned 10 lines, including both declarations. The declaration bodies and source
definition windows (125-160, 11010-11085) were opened, not inferred from titles.
Probe receipt: `prior/probes/Readback75.lean`, inherited `make lean` exit 0;
`prior/probe-runs.json` and decoded `prior/logs/Readback75.log.gz` were opened.

## Atom 89: Schur Minimum

`atom_id: 937abccd3570503c88aaac8b088e687e6f79db29ca9f67f887b72a028bd4f866`

Complete raw body returned by `make show-atom` (exit 0, hash matches, no coverage):

```text
## 定理二：边界有效几何由 Schur 补唯一确定

$$
\boxed{
\min_y
\begin{pmatrix}x\\y\end{pmatrix}^{\!*}
K
\begin{pmatrix}x\\y\end{pmatrix}
=
x^*Sx,
\qquad
S=A-BC^{-1}B^*.
}
\tag{8}
$$
```

| Source assertion | Original probe counterpart | Status | Domain and boundary check |
| --- | --- | --- | --- |
| Attained minimum over every internal vector `y` equals `x^* S x` | `Triage89.schur_minimum`: `IsLeast (Set.range ...) (qform (...) x)` | equivalent | Universal finite complex matrices, boundary vector `x`, and all internal vectors `y`. `C.PosDef` is precisely the source's strict `C > 0`. It supplies invertibility, so no extra inverse hypothesis is imposed. `IsLeast` includes both attainment and the universal lower bound. |
| `S = A - B C^{-1} B^*` | Exact matrix term `A - B * Inv.inv C * Matrix.conjTranspose B` in the conclusion | equivalent | Adjoint, product order, and the lower-right block inverse agree. No commutation or equal block-dimension assumption. |
| Heading: boundary effective geometry is uniquely determined by the Schur complement | The displayed minimum fixes the effective quadratic value for each `x`, using the explicit expression for `S` | equivalent | This is the determinacy expressed in (8), not a separate uniqueness-of-minimizer assertion. No second characterization of arbitrary matrices is printed in the atom. |

`fidelity: full`. Source context 55856-55906 specifies a Hermitian block matrix.
The probe even permits arbitrary `A`; restricting it to the source's Hermitian
`A` introduces no missing case. Its `ComplexOrder` comparison specializes to
real-valued Hermitian quadratic forms. It does not require nonempty index types,
positive `A`, or positive full `K`. Singular `C` is excluded by the source itself.

`upstream_declaration`: `Matrix.schur_complement_eq₂₂`,
`.lake/packages/mathlib/Mathlib/LinearAlgebra/Matrix/Hermitian.lean:378`.
The opened declaration already states the entire block quadratic form as the
sum of the translated `C` quadratic form and the precise Schur quadratic form.
Side-condition declarations, also opened locally: `Matrix.PosDef.isUnit`,
`.lake/packages/mathlib/Mathlib/LinearAlgebra/Matrix/PosDef.lean:507`, and
`Matrix.PosSemidef.dotProduct_mulVec_nonneg`, same file at line 305.

`wrapper_thinness`: instantiate the upstream coefficient field by `Complex`
and its lower-right block `D` by `C`; obtain the invertible instance from positive
definiteness. Rewrite once by the upstream equality. Nonnegativity of its first
summand gives the lower bound, and `y = -(C^{-1} B^*) x` makes that summand zero.
Thus the wrapper exposes an attained-minimum interface for the very Schur
identity supplied upstream; it performs no independent square completion.
`necessity_citation`: the atom's exact `\min_y ... = x^*Sx` clause above
requires an attained minimum, whereas upstream presents the decomposition.
This clause explains precisely the small `IsLeast` wrapper.
`verdict: wrap-and-cover-eligible`;
`admission_basis: rule-11-upstream-wrapper`.
The (c) bridge basis is not used: no preregistered named consumer is supplied.
`proof_shape: bind-only`; `direct_frozen_dependencies: []`; `escape_witness: null`.
`why_not_escape_witness`: the live argument is upstream Schur equality plus
upstream positive-form nonnegativity and substitution of its zero residual.

Search receipt R89:
`rg -n 'schur_complement_eq|schur_minimum|SchurComplement' D5 .lake/packages/mathlib/Mathlib/LinearAlgebra/Matrix/Hermitian.lean`
returned 12 lines (8 D5 leads, 4 Mathlib lines). The same alternation supplies its
positive control, including the exact declaration at 378. The full upstream
declaration window 350-411 and PosDef windows 297-313 and 496-516 were opened.
Probe receipt: `prior/probes/Schur89.lean`; inherited `make lean` exit 0, decoded
`prior/logs/Schur89.log.gz` ends with `EXIT: 0`. No new Lean run in this seat.

## Push Receipts

| Commit | Completed unit | Push result |
| --- | --- | --- |
| `6fca6dde2388835a42f0904463b50100e1aa6c36` | Preregistration | exit 0; remote lane created |
| `b11e3e695343125c81d378db2fe79f5f5677d823` | Atom 75 | exit 0 |

## Nonclaims

- No atom has been covered; no production theorem has been deposited or frozen.
- No `D5/` module has been created; no PR has been opened.
- `make cover` is not claimed to judge fidelity.
- No admission basis outside the closed three is claimed; `refutes` is not one.
- No larger source assertion is certified by an inherited successful subclaim.
- No new proof of these source assertions, proof of their future provability,
  exhaustive library search, or implication to RH is claimed.

The final structured `conclusion` and push receipts will be appended as the
seven judgments are completed. The runner envelope is a separate worker-owned
artifact, published atomically only after completion.
