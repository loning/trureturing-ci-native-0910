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

`screened: 7 / 7`. All seven atom judgments completed. The six-field judgments
are in the seven sections below; aggregate conclusion follows them.

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

## Atom 105: Pick Update

`atom_id: bc9748938013e4b3c632bfa0e1257a59733df2e1682ed0a8a0d7a0dcc534ab2b`

Complete raw body returned by `make show-atom` (exit 0, hash matches, no coverage):

```text
## 定理 V3：相位修补增加一个正秩一项

对：

$$
\mathcal P_S(z,w)
=
\frac{1-S(z)\overline{S(w)}}{-i(z-\overline w)},
$$

有：

$$
\boxed{
\mathcal P_{B_pS}(z,w)
=
\frac{
2\Im p
}{
(z-\overline p)(\overline w-p)
}
+
B_p(z)\overline{B_p(w)}\mathcal P_S(z,w).
}
\tag{V15}
$$

```

| Source assertion | Original probe counterpart | Status | Domain and boundary check |
| --- | --- | --- | --- |
| Definition of `P_S`, using the displayed denominator `-i(z-conj w)` | `Triage105.kernel` | equivalent | Same sign, conjugation direction and response values. No analyticity or Schur-contraction hypothesis on `S` is added. |
| V15 on upper-half-plane `p,z,w` | `Triage105.kernel_update` | equivalent | All three imaginary parts are strictly positive. `z = w` in the open half-plane and `z = p` are included. Denominators are proved nonzero, not postulated. |
| V15 without the probe's extra positive-imaginary-part restrictions on `z,w` | Not stated | not-covered | The atom and immediate definition 33183-33218 specify upper-half-plane `p` only. For example, distinct real `z,w` have regular denominators but are excluded by `hz,hw`. If an upper-half-plane-only convention is intended, it needs an explicit source-domain justification; it cannot be inferred from this successful probe. |
| Heading: the added term is positive | No positive-semidefinite kernel/Gram statement | not-covered | A scalar complex equality does not explicitly assert the quadratic-form inequality for every finite sampling and every coefficient vector. |
| Heading: the added term has rank one | No rank or feature-map statement | not-covered | Must distinguish nonzero rank-one kernel/nonempty Gram sampling from empty sampling (rank zero). No such quantifier or degeneracy contract is printed in the probe. |

`fidelity: partial`. The open-half-plane formula is checked, but the positive
rank-one assertion is absent even under that restricted domain. The source's
following proof supplies a proposed feature function
`g_p(z) = sqrt(2 Im p)/(z-conj p)` outside these CAS bytes; it is not a theorem
in the probe. The present judgment does not claim the rank assertion is false.
Real diagonal extension, or cancellation at a pole of a meromorphic `S`, has
not been checked. Lean's total division and a total `Complex -> Complex`
function must not be presented as those analytic extensions.

`upstream_declaration: none` (none carries V15 or positive rank one).
The locally opened `Complex.sub_conj`,
`.lake/packages/mathlib/Mathlib/Data/Complex/Basic.lean:668`, states only
`z - conj z = (2*z.im : Real) * I`. It changes the numerator's notation.
`wrapper_thinness: not-applicable`: after elementary imaginary-part inequalities
exclude the denominators, the probe unfolds `blaschke` and `kernel`, then
`field_simp`/`ring` establish V15. No upstream kernel-update theorem is invoked.
`necessity_citation`: the complete V15 and the exact heading
`相位修补增加一个正秩一项` above; a real source demand alone does not supply (b),
and no preregistered named consumer or new typed edge establishes (c).
`verdict: partial-fidelity`; independently `admission_basis: none` for the
tested normalization-only update, also listed in `no_basis`.
`proof_shape: bind-only`; `direct_frozen_dependencies: []`; `escape_witness: null`.
`why_not_escape_witness`: every live step is conjugation rewriting, linear
sign arithmetic, or rational normalization of the supplied definitions.

Search receipt R105:
`rg -n '\b(blaschke|Blaschke|sub_conj)\b' D5/S3/Weil/Pick .lake/packages/mathlib/Mathlib/Data/Complex/Basic.lean`
returned 2 Mathlib lines and 0 D5 lines in that scope. The declaration at 668 is
the same-feature positive control; its complete body was opened (655-679).
Source windows 32750-32985 and 33150-33290 were read to distinguish boundary
claims from the formula's explicit domain. No global absence claim is made.
Probe receipt: `prior/probes/Pick105.lean`; inherited `make lean` exit 0;
decoded `prior/logs/Pick105.log.gz` ends in `EXIT: 0`.

## Atom 126: First-Return Conservation

`atom_id: e405a7f40fa7ee5313052263686a73c8b8578d18290d1f429cb1826603f82480`

Complete raw body returned by `make show-atom` (exit 0, hash matches, no coverage):

```text
## 定理一：首次返回概率具有精确的逐步守恒账目

定义第 \(n\) 步后仍未返回的概率

$$
s_n=\|(QU)^nv\|^2,\qquad s_0=1.
$$

则

$$
\boxed{
p_n=s_{n-1}-s_n,
}
\tag{3}
$$

所以

$$
\boxed{
\sum_{n=1}^{N}p_n+s_N=1.
}
\tag{4}
$$

```

| Source assertion | Original probe counterpart | Status | Domain and boundary check |
| --- | --- | --- | --- |
| `s_n = norm((QU)^n v)^2` | `history U v n := (fun w => U w - inner v (U w) * v)^[n] v`, with scalar action in Lean | equivalent | Actual iterated `Q U`, with `P w = inner v w` times `v` and `Q = I-P`. Not an arbitrary sequence satisfying a postulated balance law. |
| `s_0 = 1` | `conservation ... 0`, or unfolding `history` at zero and `hv` | equivalent | Norm-one hypothesis is exactly the source's unit-vector hypothesis; zero vector excluded by both. |
| `p_n = s_(n-1) - s_n`, for first-return index `n >= 1` | `Triage126.step_balance` indexed by `k : Nat`, with source `n = k+1` | equivalent | Both sides use the source amplitude `inner v (U ((QU)^k v))`; every positive return index occurs. No inference about undefined `p_0`. |
| Finite law (4), including the heading's stepwise-conservation assertion | `Triage126.conservation` over `Finset.range N` of `p_(k+1)` | equivalent | Reindexing `k=0,...,N-1` to `n=1,...,N`; all finite `N`, including the empty `N=0` case. Equality, not just a probability upper bound. |

`fidelity: full`. Source context 58295-58385 assumes a unitary operator on a
complex Hilbert space; the probe uses a complex linear isometric equivalence.
It works in any complex inner-product space, so lack of a completeness
hypothesis broadens the domain rather than excluding the Hilbert-space case.
All unitary `U` and unit vectors `v` are quantified. Infinite eventual-return
probability and average return time are outside this atom and are not claimed.

`upstream_declaration` (one for each nondefinitional clause):
`Submodule.norm_sq_eq_add_norm_sq_starProjection`,
`.lake/packages/mathlib/Mathlib/Analysis/InnerProductSpace/Projection/Basic.lean:557`,
carries (3); `Finset.sum_range_sub'`, generated by `@[to_additive]` on
`prod_range_div'` at
`.lake/packages/mathlib/Mathlib/Algebra/BigOperators/Group/Finset/Basic.lean:903`,
carries the telescoping in (4). Opened side-condition/notation declarations:
`Submodule.starProjection_unit_singleton` at Projection/Basic.lean:417 and
`Submodule.starProjection_orthogonal` at 209.
`wrapper_thinness`: apply Pythagoras to `U (history n)` and `span {v}`.
The two upstream projection formulas identify its summands with exactly
`p_(n+1)` and `s_(n+1)`; isometry replaces the left norm by `s_n`. Rearranging
that single equality gives (3). For (4), specialize the upstream telescoping
theorem to `f n = norm(history n)^2`, use (3), and reduce `s_0=1`.
There is no new estimate or independent induction/construction beyond the
source's defined history. Both source clauses have identified upstream carriers.
`necessity_citation`: the exact (3) and (4) above require return amplitudes and
monitored histories in the result; upstream's APIs are projection vectors and
an arbitrary additive sequence. These substitutions give the required thin
source interface. No (c) bridge with a preregistered consumer is asserted.
`verdict: wrap-and-cover-eligible`;
`admission_basis: rule-11-upstream-wrapper`.
`proof_shape: bind-only`; `direct_frozen_dependencies: []`; `escape_witness: null`.
`why_not_escape_witness`: the live argument is an instance of projection
Pythagoras followed by an instance of telescoping, with definition rewrites.

R126 candidate search:
`rg -n '\b(step_balance|first_return|starProjection_unit_singleton|norm_sq_eq_add_norm_sq_starProjection|sum_range_sub)\b' D5/S3 .lake/packages/mathlib/Mathlib/Analysis/InnerProductSpace/Projection/Basic.lean`
returned 27 lines (21 D5 leads, 6 Mathlib lines), with the same-regex positive
controls at 417 and 557. Inherited `Return126` log ends in `EXIT: 0`.
Two D5 candidate bodies were opened: `FiniteObservabilityEnergyBalance.lean`
requires an abstract operator-conservation hypothesis, and
`ComplementaryContextProbabilityPythagoras.lean` concerns trace purity with
coordinate hypotheses. Neither states the monitored-history atom directly;
neither is claimed as a frozen dependency or a verified ready-to-cover API.

Preregistered new inspection: an attempt-local `UpstreamSignatures.lean` imports
Mathlib and `#check`s `Finset.sum_range_sub'` plus the three projection declarations,
and prints the telescoping theorem's axioms. Expected result: exit 0 and the
reversed telescoping signature `sum (f i - f (i+1)) = f 0 - f n`.
Run through `make -f Makefile -f <attempt>/probe.mk lean PROBE=<attempt>/UpstreamSignatures.lean`.
Observed result: `make lean` exit 0, `Build completed successfully (12753 jobs)`;
the emitted `Finset.sum_range_sub'` signature is exactly the preregistered one,
with `[AddCommGroup G]`. Its printed axioms are `propext`, `Classical.choice`,
`Quot.sound`. This adds symbol evidence for a generated declaration; it does not
replay the seven archived probes or create a production module. Temporary files
stay outside the repo. Log:
`/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tierA-basis-triage-0909/attempt-1/UpstreamSignatures.log`.
The cache receipt reports `status=present`, project and Mathlib both `warm`.

## Atom 150: Endpoint Minimum

`atom_id: ff41c11de3a485a3451a5788237056c9099133f734e8bf7b75a1240d6746dd85`

Complete raw body returned by `make show-atom` (exit 0, hash matches, no coverage):

```text
## 定理四：闭环不相容的精确代价

$$
\boxed{
\min_y\mathcal E
=
\frac{\|(\mathcal U_1-\mathcal U_2)x\|^2}
{\tau_1+\tau_2}.
}
\tag{13}
$$

```

| Source assertion | Original probe counterpart | Status | Domain and boundary check |
| --- | --- | --- | --- |
| Attained minimum (13), including the heading's exact incompatibility cost | `Triage150.endpoint_minimum`, with `a := U1 x`, `b := U2 x`, `r := tau1`, `s := tau2` | equivalent | For every pair of endpoints in a real inner-product space and positive real `r,s`, `IsLeast` asserts attainment and a lower bound for every `y`. The norm and subtraction match `(U1-U2)x` by evaluation. It includes `a=b`, `x=0`, `U1=U2`, and the zero-dimensional space. |
| The source's complex-space interpretation of the same norm expression | Instantiate the real-space theorem using `InnerProductSpace.complexToReal` | equivalent | Restriction changes the scalar/inner-product structure, not the carrier, norm, or the set of possible `y`. A minimization over all complex vectors remains over those same vectors, not just real coordinates. |

`fidelity: full`. Source 56043-56058 explicitly defines the reduced energy as
`norm(y-U1 x)^2/tau1 + norm(y-U2 x)^2/tau2`; 55924-55946 supplies positive time
costs. Arbitrary `a,b` are more general than propagated endpoints, so unitarity
is not an added assumption. Zero/negative durations are outside the positive-time
problem; equal durations are included. The witness is exactly
`c = (s/(r+s)) a + (r/(r+s)) b`, not the reversed weighting. Earlier elimination
of path interiors and later relative-holonomy formulae are outside this atom.

`upstream_declaration: none` (none carries this weighted minimum).
Opened ingredients: `norm_add_sq_real`,
`.lake/packages/mathlib/Mathlib/Analysis/InnerProductSpace/Basic.lean:409`, and
`norm_sub_sq_real`, same file at 435. Both are elementary norm-square expansions,
not weighted minimization statements. The scalar restriction used for fidelity
was opened in the same file: `InnerProductSpace.rclikeToReal` at 944 and
`InnerProductSpace.complexToReal` at 971, preserving the original normed group.
`wrapper_thinness: not-applicable`: the probe introduces the weighted center,
expands every square using those ingredients, and uses `field_simp`/`ring` to
establish the entire weighted square completion. Square nonnegativity then
supplies the lower bound and substitution supplies attainment. Unlike atom 89,
no upstream square-completion or minimization theorem supplies that identity.
`necessity_citation`: the exact (13) above is a source demand, but not a reason
to label normalization an upstream wrapper. No (c) bridge with an explicit
new typed edge and preregistered named consumer is supplied.
`verdict: no-admission-basis`; `admission_basis: none`.
`proof_shape: bind-only`; `direct_frozen_dependencies: []`; `escape_witness: null`.
`why_not_escape_witness`: after the upstream norm expansions all atoms are
available; the weighted identity and its nonnegative remainder normalize closed.

Search receipt R150:
`rg -n '\b(weighted_endpoint|endpoint_minimum|norm_sub_sq_real|norm_add_sq_real)\b' D5/S3/Observer D5/S3/Quantum .lake/packages/mathlib/Mathlib/Analysis/InnerProductSpace/Basic.lean`
returned 7 lines (3 D5 uses, 4 Mathlib lines); the same regex supplies declaration
controls at 409 and 435. The full window 399-449 was opened. A supplemental
`complexToReal|rclikeToReal|restrictScalars|restrictScalar` search located the
restriction in the same local Mathlib file, followed by opening 928-976.
Probe receipt: `prior/probes/Endpoint150-v2.lean`; inherited `make lean` exit 0;
decoded `prior/logs/Endpoint150-v2.log.gz` ends in `EXIT: 0`. Earlier
`Endpoint150` exit 2 remains in the inherited run ledger, not erased.

## Conclusion

`verdict: propose`; `screened: 7`; `not-an-assertion: 0`.
All seven have truth-evaluable assertions. This is a proposed judgment for the
thinking stage, not authorization to execute a production workflow.

`by_verdict`:

| Verdict | Count |
| --- | ---: |
| wrap-and-cover-eligible | 3 |
| no-admission-basis | 2 |
| partial-fidelity | 2 |
| needs-more-work | 0 |

`by_fidelity: {full: 5, partial: 2, mismatch: 0}`.
`by_admission_basis: {rule-11-upstream-wrapper: 3, none: 4}`.
The primary verdict uses `partial-fidelity` for atoms 90 and 105; both also lack
a basis for the tested candidate. Thus the four entries in `no_basis` must not
be counted as four additional primary verdicts. This preserves the two axes.
The preregistered majority-normalization prediction is supported (4/7), while
three genuine upstream wrappers were identified and justified individually.

`per_atom`: the seven complete records above, each containing `fidelity` and its
clause table, `upstream_declaration`, `wrapper_thinness`, `necessity_citation`,
`verdict`, and `why_not_escape_witness`. Their structured counterparts, including
every clause row, are in the worker-owned `result.json`.

`eligible_for_wrap`:

- `937abccd3570503c88aaac8b088e687e6f79db29ca9f67f887b72a028bd4f866`: Schur minimum.
- `b923baf16e3404ffc7143c8258cd778915ab93409a40512c8d156d065ed1f61a`: divisor parity.
- `e405a7f40fa7ee5313052263686a73c8b8578d18290d1f429cb1826603f82480`: first-return laws.

`no_basis` (current candidates, not a claim that no future reformulation can qualify):

- `7d5d9c72f7ad9abb794dd61d99e68ff5adc1271970f00e4a009b9e334680a0d2`: coefficient extraction followed by cancellation, no upstream readback theorem carrying M25.
- `96902e5b1d0b9ac78c37f6c1f75fd1d5043bfd6c18f5e2451352b6fbc6977b46`: rational numerator and sign normalization; no upstream pair-contribution/disk theorem carrying the conclusion.
- `bc9748938013e4b3c632bfa0e1257a59733df2e1682ed0a8a0d7a0dcc534ab2b`: conjugation and rational normalization; `sub_conj` does not carry V15 or positive rank one.
- `ff41c11de3a485a3451a5788237056c9099133f734e8bf7b75a1240d6746dd85`: norm expansions followed by locally completed weighted square; no upstream extremal identity in this proof.

`fidelity_gaps`:

- Atom 90: actual-zero-pair contribution to `Re(xi'/xi)` is not connected to the tested rational model. Both boxed algebraic subclaims are covered.
- Atom 105: positivity and rank one are absent; the probe only handles open-upper-half-plane `z,w`. A broader regular-point interpretation of V15 and all analytic extension questions remain uncertified.

`probe_runs`: prior `Readback75`, `Schur89`, `Disk90-v2`, `Parity104`, `Pick105`,
`Return126`, `Endpoint150-v2` each have inherited exit 0. Prior failed attempts
`Disk90` and `Endpoint150` each have exit 2; the prior baseline has exit 0. All
ten entries are recorded in the opened immutable `prior/probe-runs.json`.
This seat ran one new `UpstreamSignatures` inspection via `make lean`, exit 0,
with its command, printed signature, cache state, and actual log above.
There were seven fresh `make show-atom` calls, each exit 0; these are source
reads, not Lean proofs. No failed exploratory run is promoted to proof evidence.

`search_receipts`: R75, R89, R90, R104, R105, R126, R150 above record the actual
commands, scopes, counts, positive controls, and opened local source windows.
The Unicode-boundary and truncated exploratory output limitations are explicitly
recorded in R90. All cited Mathlib source belongs to the manifest-pinned local
revision, whose worktree was checked clean at final audit.

`assumed_unverified`:

- The connection from atom 90's rational model to actual xi zero data is unverified; no such connection is assumed true by this verdict.
- The intended full `z,w` domain in V15 is not made explicit by the atom or its immediate definition; no successful upper-half-plane probe resolves that omission.
- Meromorphic cancellation and real-diagonal analytic extension in V3 have not been verified.
- External DLMF/arXiv references printed in the source were not opened for this local pinned-library audit; no claim of literature verification is made.
- Search is bounded to the stated scopes. No exhaustive ecosystem search or independent second-reviewer confirmation is claimed.
- No production wrapper, mirror, admission run, or coverage workflow was evaluated; eligibility is the fidelity-and-basis judgment requested here.

`nonclaims`: the section below is part of this conclusion. The (a) basis is
unavailable for all seven bind-only probes; (c) has no supplied atom-mandated
independent typed edge plus preregistered named consumer in any of the seven.
No `refutes` label or source demand alone substitutes for those requirements.

## Push Receipts

| Commit | Completed unit | Push result |
| --- | --- | --- |
| `6fca6dde2388835a42f0904463b50100e1aa6c36` | Preregistration | exit 0; remote lane created |
| `b11e3e695343125c81d378db2fe79f5f5677d823` | Atom 75 | exit 0 |
| `5f6b525177589b4fe361303687ba4a99932e0595` | Atom 89 | exit 0 |
| `8a48ad8068a6e8abd3a237daf18e1542a7d3116b` | Atom 90 | exit 0 |
| `3b0ea401d33d72def4731520c7ef7171b5670287` | Atom 104 | exit 0 |
| `20666941dd35dbc37d825d01a0c431502b61383a` | Atom 105 | exit 0 |
| `4f3fe9a29754aaf301064b32a03b9d6cd3dad2e0` | Atom 126 source/inspection preregistration checkpoint | exit 0 |
| `820e77f51e162c4a58c31c506fb012ab4d3eb08d` | Atom 126 | exit 0 |
| `9b899c7b94b0d8ccbacb9023d64224c2c38d96ae` | Atom 150 | exit 0 |

These are `conclusion.pushed.commits` for the preregistration, checkpoint, and
all seven per-atom judgments, each observed pushed before proceeding. The
runner envelope additionally records the final report-consolidation commit
after its push succeeds; a commit does not attempt to contain its own hash.

## Nonclaims

- No atom has been covered; no production theorem has been deposited or frozen.
- No `D5/` module has been created; no PR has been opened.
- `make cover` is not claimed to judge fidelity.
- No admission basis outside the closed three is claimed; `refutes` is not one.
- No larger source assertion is certified by an inherited successful subclaim.
- No new proof of these source assertions, proof of their future provability,
  exhaustive library search, or implication to RH is claimed.

Final audit: the only changed tracked path relative to the pinned start is this
report. The supplied untracked `tierA.json` remains untouched. The seven raw
quotation blocks were compared against CAS bytes; their sole display difference
was one omitted terminal newline each, restored in the final consolidation.
`git diff --check` passes. The worker publishes `result.json.tmp` by atomic
rename to `result.json`, then publishes `completion.sentinel.tmp` by atomic
rename to `completion.sentinel`, in the prescribed attempt directory.
