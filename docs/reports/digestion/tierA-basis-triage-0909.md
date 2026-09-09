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

`screened: 4 / 7`. Completed: M4 readback, Schur minimum, reflected-pair disk,
divisor parity.

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

## Atom 90: Reflected-Pair Disk

`atom_id: 96902e5b1d0b9ac78c37f6c1f75fd1d5043bfd6c18f5e2451352b6fbc6977b46`

Complete raw body returned by `make show-atom` (exit 0, hash matches, no coverage):

```text
### 定理十五：一个反射零点对的负贡献区域，恰好是一个圆盘

令 \(u=t-\gamma\)。该配对对 \(\Re L(s)\) 的贡献为

$$
\begin{aligned}
\mathcal P_{\delta,\gamma}(s)
&=
m\left[
\frac{x-\delta}{(x-\delta)^2+u^2}
+
\frac{x+\delta}{(x+\delta)^2+u^2}
\right]\\[1mm]
&=
\boxed{
\frac{
2mx(x^2+u^2-\delta^2)
}{
[(x-\delta)^2+u^2][(x+\delta)^2+u^2]
}.
}
\end{aligned}
\tag{87}
$$

因此，在排除零点本身后，

$$
\boxed{
\mathcal P_{\delta,\gamma}(s)<0
\iff
x^2+(t-\gamma)^2<\delta^2.
}
\tag{88}
$$
```

| Source assertion | Original probe counterpart | Status | Domain and boundary check |
| --- | --- | --- | --- |
| `u = t - gamma` coordinate substitution | Instantiate the universally quantified real `u` by `t - gamma` | equivalent | No restriction on `t` or `gamma`; real translation is bijective. |
| The displayed two-pole expression is this actual zero pair's contribution to `Re L(s)` | No `L`, xi, actual zeros, multiplicities-as-zero-data, or contribution map in the probe | not-covered | Source 67678-67729 identifies `L = xi'/xi` and uses its zero expansion (86). The probe does not supply that identification. This gap concerns the atom's introductory assertion, not a demand to reprove all of (86) as an additional atom. |
| Two rational terms equal the single boxed fraction (87) | First conjunct of `Triage90.reflected_pair` | equivalent | All real `delta,u`, positive real `m,x`; positive integral zero multiplicity is included. Source `0 < delta < 1/2` is a subset of the probe's domain. |
| Strict negativity iff the strict disk inequality (88), and the heading's geometric locus | Second conjunct, after `u := t - gamma`, for the algebraic two-pole expression | equivalent | Both directions of iff, both strict inequalities. Domain is the source's `x > 0` half-plane, with poles removed, not the full plane including `x = 0`. |

`fidelity: partial`. Both boxed algebraic subclaims are covered; the asserted
identification with actual `Re L(s)` is not printed in the probe. Treating the
display as a definition of a model `P` proves the model statement only. To claim
full fidelity, a later result must explicitly connect that model to the actual
source contribution; this seat has not verified such a typed connection.
The two denominator hypotheses exclude exactly `(x-delta,u)=(0,0)` and
`(x+delta,u)=(0,0)` over the reals, as the source requests. No disk boundary is
discarded: the strict-negativity equivalence is false on both sides there.

`upstream_declaration: none` (none carries the paired-pole/disk conclusion).
Opened local ingredients: `sq_nonneg`,
`.lake/packages/mathlib/Mathlib/Algebra/Order/Ring/Unbundled/Basic.lean:606`;
`div_lt_iff₀`,
`.lake/packages/mathlib/Mathlib/Algebra/Order/GroupWithZero/Basic.lean:1146`;
`mul_lt_mul_iff_right₀`,
`.lake/packages/mathlib/Mathlib/Algebra/Order/GroupWithZero/Defs.lean:286`.
They state square nonnegativity and preservation of a comparison under positive
division/multiplication, not a zero-pair theorem.
`wrapper_thinness: not-applicable`: `field_simp` and `ring` generate the paired
numerator; order rewrites then cancel the positive factors.
`necessity_citation`: (87), (88), and the exact introductory contribution claim
above are source demands, but none establishes an upstream-wrapper basis. No
atom-mandated new typed bridge with a preregistered named consumer is supplied.
`verdict: partial-fidelity`; independently `admission_basis: none` for this
normalization-only candidate, also listed in `no_basis`.
`proof_shape: bind-only`; `direct_frozen_dependencies: []`; `escape_witness: null`.
`why_not_escape_witness`: positive denominators come from squares and excluded
zeros, and the conclusion follows by common-denominator and sign normalization.

Search receipt R90: focused
`rg -n '\b(reflected_pair|pair_contribution|negative_disk|disk_criterion)\b' D5/S3/Weil D5/S3/Zeros`
returned 0 lines (exit 1). Same-feature positive control
`rg -n '\b(reflected_pair|pair_contribution|negative_disk|disk_criterion|sq_nonneg)\b' .lake/packages/mathlib/Mathlib/Algebra/Order/Ring/Unbundled/Basic.lean`
returned 4 lines (exit 0). A preceding broad `reflection|reflected|disk|Disk|circular|circle`
search returned truncated output and was not used for an absence conclusion.
The `\b` variant around Unicode-subscript names only returned `sq_nonneg` hits;
the literal declaration-prefix search was used to locate the other two names,
then all three bodies were opened. No absence of those declarations is claimed.
Probe receipt: `prior/probes/Disk90-v2.lean`, inherited `make lean` exit 0;
decoded `prior/logs/Disk90-v2.log.gz` confirms `EXIT: 0`. Earlier `Disk90` exit 2
is retained in the inherited run ledger and does not certify a statement.

## Atom 104: Divisor Parity

`atom_id: b923baf16e3404ffc7143c8258cd778915ab93409a40512c8d156d065ed1f61a`

Complete raw body returned by `make show-atom` (exit 0, hash matches, no coverage):

```text
## 定理：它们是否相容，由总指数奇偶决定

$$
\boxed{
\Gamma R
=
(-1)^{\Omega(N)}R\Gamma.
}
\tag{14}
$$
```

| Source assertion | Original probe counterpart | Status | Domain and boundary check |
| --- | --- | --- | --- |
| Operator commutation law (14) on the divisor space | `Triage104.complement_parity`: `Gamma (reflect N f) d = (-1)^cardFactors N * reflect N (Gamma f) d` for every `f` and `d` dividing `N` | equivalent | `N : Nat`, `N != 0` is the source's positive prime-factor product. All divisors and all complex wavefunctions are quantified, not just `N = 5040` or one basis state. `d != 0` and `N/d != 0` are derived, not added. `N = 1`, `d = 1`, `d = N`, and square-root divisors are included. |
| Heading: the sign is determined by total-exponent parity | The coefficient is exactly `(-1)^cardFactors N` | equivalent | Multiplicity count agrees with `sum_p v_p(N)`, not distinct-prime count and not integer parity of `N`. Even/odd sign is the usual value of this character. |

`fidelity: full`. Source definitions (37738-37775) are diagonal multiplication
by `(-1)^Omega(d)` and complementary-divisor permutation. Since the divisor
complement is an involution (`N = d*(N/d)` with nonzero factors), its action on
wavefunction coordinates is pullback by the same map. Every function on the
finite divisor subtype extends to `Nat` (arbitrary values off the divisors), so
the probe's equality for all `f,d` gives the operator identity by extensionality.
The source's earlier involution/adjoint assertions and later separate (15) are
outside these CAS bytes; this atom does not assert them as additional clauses.

`upstream_declaration`: `ArithmeticFunction.cardFactors_mul`,
`.lake/packages/mathlib/Mathlib/NumberTheory/ArithmeticFunction/Misc.lean:290`,
states `Omega (m*n) = Omega m + Omega n` for both factors nonzero.
The definition at 257 and the locally opened
`ArithmeticFunction.cardFactors_eq_sum_factorization` at 318 in the same file
identify the exact source notion of total exponent.
`wrapper_thinness`: instantiate the multiplication theorem at `d` and `N/d`,
rewrite their product to `N`, apply the parity character using `pow_add`, and
cancel its square `((-1)^k)^2 = 1`. Evaluating the two named operators produces
exactly these scalar factors and the same coordinate `f(N/d)`. The upstream
arithmetic theorem supplies the entire relation between distinct arguments;
the wrapper changes its presentation to the source's parity-operator interface.
`necessity_citation`: the exact boxed `\Gamma R = (-1)^{\Omega(N)}R\Gamma`
above requires the operator presentation, which is not the upstream arithmetic
function's native API. No new independent arithmetic lemma is needed.
`verdict: wrap-and-cover-eligible`;
`admission_basis: rule-11-upstream-wrapper`. No (c) bridge basis is asserted.
`proof_shape: bind-only`; `direct_frozen_dependencies: []`; `escape_witness: null`.
`why_not_escape_witness`: complementary-factor additivity is supplied directly
by Mathlib; parity normalization and coordinate extensionality add no witness.

Search receipt R104:
`rg -n '\b(cardFactors_mul|total_exponent|grading_reflection|parity_commutation)\b' D5 .lake/packages/mathlib/Mathlib/NumberTheory/ArithmeticFunction/Misc.lean`
returned 10 lines (7 D5 uses, 3 Mathlib lines); the same regex finds the positive
control declaration at 290. Full local windows 250-305 and 305-350 were read.
A supplemental `theorem div_div_self|lemma div_div_self|cardFactors.*sum|sum.*cardFactors`
search in Mathlib's `Data/Nat` and `NumberTheory/ArithmeticFunction` returned
2 lines for the sum-factorization identification; no declaration named
`div_div_self` was asserted from that limited search.
Probe receipt: `prior/probes/Parity104.lean`; inherited `make lean` exit 0;
decoded `prior/logs/Parity104.log.gz` ends in `EXIT: 0`.

## Push Receipts

| Commit | Completed unit | Push result |
| --- | --- | --- |
| `6fca6dde2388835a42f0904463b50100e1aa6c36` | Preregistration | exit 0; remote lane created |
| `b11e3e695343125c81d378db2fe79f5f5677d823` | Atom 75 | exit 0 |
| `5f6b525177589b4fe361303687ba4a99932e0595` | Atom 89 | exit 0 |
| `8a48ad8068a6e8abd3a237daf18e1542a7d3116b` | Atom 90 | exit 0 |

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
