# FFC-6: the degree-six commutator theorem

## Target and provenance

Base dev: `33a8590118b2fe84d8c1d309ecd348a4ce4c1f86`.
Branch: `lane/math/ffc6-assembly-0908`.
Module: `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.lean`.

The target is Conjecture 5.3, specialized to degree six, of Campbell,
Morales, and Perales, *Even Hypergeometric Polynomials and Finite Free
Commutators*, arXiv:2502.00254v2, SIGMA 21 (2025), 108,
DOI `10.3842/SIGMA.2025.108`. The conjecture is on printed page 20.
Gribinski's conjecture in the same paper is Conjecture 3.13.

`RealRooted6 p` means that `p` equals a product of six real linear factors.
The theorem is universal over both such inputs, including all multiplicities
and zero roots. `square6` uses the existing degree-parameterized
`multiplicativeConvolution`, `symmetrize`, and `commutatorKernel` definitions
from `FiniteFreeCommutatorDegreeFour`.

`question_answered`: Does this exact operation preserve six real factors for
every pair of monic real-rooted sextics? The answer proved here is yes.
The implementation preregistration is the worker artifact
`ffc6-assembly-0908/attempt-1/preregistration.md`, written before the proof
attempt. It proposed the cubic root construction, the resultant-square
identity, and the separate zero-resultant case. The actual initial-root
existence step uses Mathlib's intermediate value theorem on `[0,infinity)`;
this supplies the root needed by that preregistered construction.

## Binding attempt and admission

The first proof attempt used only pinned Mathlib instantiation, the two
supplied frozen theorems, projections, and normalization. `make lean` exited
2 with the real-factorization goal unsolved. This is evidence that the
restricted attempt failed, not an impossibility theorem about all bindings.
The incomplete example was replaced before the first commit.

`proof_shape: content`.
`admission_basis: escape-witness`.
`escape_witness: cubic_nonnegative_factorization`.
`dominating_theorem_search: not-found-in-searched-scope`.

The witness proves that `Y^3-aY^2+bY-c` factors over three nonnegative reals
whenever `a,b,c` and its discriminant are nonnegative. The frozen inputs
only give coefficient inequalities; their normalization does not supply
the three roots. The proof constructs these roots using the intermediate
value theorem and a quadratic square root, and resolves a vanishing
resultant separately. This is neither a restatement of the sextic target
nor a direct instance of the inspected Mathlib cubic API.

The live dependency path is
`real_rooted -> centered_real_rooted -> cubic_nonnegative_factorization`.
`centered_real_rooted` consumes the roots, all three signs, and the actual
factorization returned by the witness to construct its `Fin 6` root map.
Those values remain necessary after unfolding helpers and reducing local
bindings; the witness is not a discarded conjunction component.

Let E and D denote the two frozen declarations listed below. For each
public theorem, the proof shape includes all private helpers:

| Public theorem | proof_shape | Direct frozen theorem use | Admission and directed companion edge |
| --- | --- | --- | --- |
| `centered_expansion` | bind-only | none; normalizes existing operation definitions | companion: `centered_real_rooted -> centered_expansion`, expansion obligation |
| `cubic_nonnegative_factorization` | content | none | escape witness; `centered_real_rooted -> cubic_nonnegative_factorization` |
| `centered_data` | bind-only | E and D | companion: `centered_real_rooted -> centered_data`, signs and discriminant obligation |
| `centered_real_rooted` | content | E and D through `centered_data` | uses the escape witness; `real_rooted -> centered_real_rooted` |
| `symmetrize_translation` | bind-only | none; normalizes the operation definition and translated coefficients | companion: `real_rooted -> centered_representative -> symmetrize_translation`, translation obligation |
| `real_rooted` | content | E and D through the centered proof | exact requested target, with the live cubic escape witness |

No atom was supplied and no coverage edge is created. The new module is
admitted on its escape content; the normalization companions are not
independent deposits. This report is the implementation worker's account,
not an independent review of itself.

## Exact expansion and invariant signs

Write the centered inputs as
`p=X^6+uX^4+vX^3+wX^2+tX+s` and its capital-letter counterpart `q`.
Set `Cp=2s+2uw/15-v^2/20` and `Cq=2S+2UW/15-V^2/20`.
The kernel-checked identities are

```text
Sym6(p) = X^6 + 2u X^4 + (2w+2u^2/5) X^2 + Cp
z6      = X^6 - (270/7) X^4 + (375/14) X^2 - 4/7
square6 p q = X^6 - a X^4 + b X^2 - c
a = 24uU/35
b = 2(u^2+5w)(U^2+5W)/105
c = 4CpCq/7
```

The proof unfolds the source definitions, evaluates the finite factorial
and descending-Pochhammer coefficients, proves coefficient equalities by
`ext`, and closes polynomial identities by `norm_num` and `ring`.
`multiplicative_even` is used twice. All three constants agree exactly with
the supplied probe; the probe's symbolic calculation is not a premise.

The degree-five coefficient of a six-factor product is minus its root sum.
For centered inputs Mathlib's `prod_X_sub_C_coeff_card_pred` therefore
provides the zero-sum hypotheses required by E and D. E is applied to each
root map separately. Its projections give

```text
A = -u >= 0, B = u^2+5w >= 0, Z = -Cp >= 0,
A' = -U >= 0, B' = U^2+5W >= 0, Z' = -Cq >= 0.
```

Products of these signs give `a=24AA'/35>=0`, `b=2BB'/105>=0`, and
`c=4ZZ'/7>=0`. Both pairs of minus signs cancel. D gives the cubic
discriminant in precisely these coordinates. The signs are established
independently of D. No unconditioned use of `FiniteSymbolCriterion` or
`FiniteAdditiveSymbol.additive_splits` occurs.

## Cubic factors, repeated roots, and translation

For `f(Y)=Y^3-aY^2+bY-c`, `f(0)=-c<=0` and its positive leading
coefficient imply a root `x>=0` by `intermediate_value_Ici`. Put
`d=a^2+2ax-3x^2-4b` and `R=3x^2-2ax+b`. The root equation yields
`Disc(f)=d*R^2`. If `R` is nonzero, cancel its positive square. If `R=0`,
the exact identity `d=(a-3x)^2` proves `d>=0`. This second branch includes
the repeated-root cases; no division by zero or distinctness assumption
is made. Define `y,z=(a-x +/- sqrt(d))/2` and check their factorization.
For any negative argument, the cubic term is strictly negative and the
remaining three terms are nonpositive, excluding negative roots.

Substitute `X^2` and exhibit the six roots
`sqrt(x),-sqrt(x),sqrt(y),-sqrt(y),sqrt(z),-sqrt(z)`.
The equality to a `Fin 6` product keeps multiplicities, including zero.

Every input has a monic sextic coefficient representation. Translation
`p(X+h)` sends its root map `r` to `r-h`. The three coefficients of its
symmetrization, before centering, are
`2u-5a^2/6`, `2w-av+2u^2/5`, and `2s-at/3+2uw/15-v^2/20`.
The explicit binomial translation formulas prove that all three are
unchanged. Choosing `h=-a/6` centers each input. Their symmetrizations,
and hence their commutator, stay equal to the original output. There is
no need to translate the six output roots.

## Frozen inputs

E: `D5/S3/Zeros/CoefficientBounds/SexticEnvelope.centered_real_sextic_envelope`

- Declaration `statement_id`: `sha256:e8ce24a4b47d97c700b1e34af9ceb9bfc05b3dabd7b7935c2e65234b112ae4d9`.
- Module state ID: `sha256:33cfc49345ee9794259badf034e9f1f7eb39c5f7aa2b1e5a8f5a0687adb2b763`.

D: `D5/S3/Zeros/CoefficientBounds/SexticDiscriminant.centered_real_sextic_discriminant`

- Declaration `statement_id`: `sha256:f78b47ced78a1df5bc51e0060fcacdcabeef71f3204d9c823602ff5f92b9e96b`.
- Module state ID: `sha256:965f0130d8e7df89d79c9e1b861fc553dc6292bed044099a9e26ca58b66a6a66`.

Neither frozen source module is edited.

## Utility, declaration by declaration

`utility: none` is a semantic classification of each declaration below.
The degree is fixed, while the polynomial and coefficient domains are
infinite. None performs bounded enumeration, implements a checker,
reduces an analytic claim to outstanding numerical computation, or
certifies a sampled polynomial pair. Rational arithmetic in the source
expansion is normalization of its defining formula. In particular the
fixed kernel identity is an internal definition-evaluation companion,
not an independently admitted computed instance.

| Declaration | Reason for `none` |
| --- | --- |
| `RealRooted6` | Predicate defining the full six-factor domain. |
| `square6` | The source operation on arbitrary polynomial pairs. |
| `centeredSextic` | Symbolic polynomial constructor with arbitrary real coefficients. |
| `sextic` | Symbolic polynomial constructor with arbitrary real coefficients. |
| `dilate_sextic` | Symbolic identity for every coefficient tuple. |
| `symmetrize_sextic` | Symbolic coefficient identity for every monic sextic. |
| `symmetrize_centered` | Specialization of that symbolic identity to zero root sum. |
| `multiplicative_even` | Bilinear coefficient identity for arbitrary even sextics. |
| `commutatorKernel_six` | Private normalization of the existing kernel's definition at degree six; no input-root certificate. |
| `centered_expansion` | Symbolic identity for all ten real input coefficients. |
| `cubic_root_nonneg` | Ordered-ring implication for arbitrary alternating cubic data and any root. |
| `cubic_nonnegative_factorization` | Analytic and algebraic existence theorem for all coefficient triples satisfying the hypotheses. |
| `root_sum_zero` | Coefficient-to-root-sum identity for every six-factor polynomial. |
| `centered_data` | Uniform implication from root hypotheses to coefficient signs and discriminant. |
| `centered_real_rooted` | Uniform real factorization of every centered input pair. |
| `exists_sextic` | Coefficient representation of every polynomial in the domain. |
| `sextic_translate` | Symbolic binomial identity for arbitrary coefficients and arbitrary real translations. |
| `real_rooted_translate` | Uniform transport of six real factors under any translation. |
| `symmetrize_translation` | Uniform translation invariance on the full input domain. |
| `centered_representative` | Existence of a centered representative for every input polynomial. |
| `real_rooted` | Universal preservation on the full sextic domain, with no finite list of input pairs. |

The other computational-utility fields are `not-applicable(kind=none)`.
SL-031 checks the structural declaration and its source-bound report;
the classification's mathematical justification remains a review judgment.

## Bounded literature and API recheck

The arXiv v2 HTML was fetched successfully and its displayed mathematical
alternate text was retained in the text projection. Notation 5.1,
Conjecture 5.3, Proposition 5.4, Remark 5.5, and the extra hypothesis of
Theorem 5.6 were read directly. Remark 5.5 explicitly says that the
reduced hypergeometric kernel lacks the requisite nonnegative real roots.

Crossref title query `finite free commutators`: the first 30 records were
read; the source paper is first. OpenAlex query `"finite free" AND
commutator`: 387 indexed matches, first 100 titles read. These include
the two source-paper records, Campbell's 2022 *Commutators in finite free
probability, I*, the 2023 infinitesimal-operator paper, and the 2026
*Multiplicative and Additive Finite Free Convolutions for q-Polynomials*.
The last three abstracts were read. They concern the expected
characteristic polynomial, infinitesimal distributions, and q-convolutions,
respectively. These title and abstract inspections are not full-text
exclusions. The source DOI's OpenAlex record reports zero indexed
citations, updated 2026-08-26; that count cannot establish priority.

The pinned Mathlib `Algebra/CubicDiscriminant.lean` was read. Its
`discr_ne_zero_iff_roots_nodup` and `card_roots_of_discr_ne_zero`
require a splitting hypothesis; they cannot close the missing implication.
Authenticated GitHub code search `multiplicativeConvolution language:Lean`
returned zero results; its language-filter control
`"finite free" language:Lean` returned 380, with the first 30 inspected. A search for
`"discr" "nonneg" "Cubic" language:Lean` returned 31. The inspected
MichaelStollBayreuth/EllipticCurves `Mathlib/Basic.lean` at commit
`449c7b936813254c8718db5c204aa71e9c3c44f6` concerns number-field
signatures rather than this commutator theorem.

Google returned a JavaScript challenge and Bing RSS returned irrelevant
results; neither is counted as an effective negative literature search.
An initial unquoted OpenAlex query also returned mostly unrelated results.
Within the inspected sources and APIs, a prior general degree-six proof
was not located. This is a bounded search result, not a priority assertion.

All text searches use `rg` or `git grep -P`. Reproducible controls:

| Scope | Negative regex and count | Same-feature positive regex and count |
| --- | --- | --- |
| Base SHA, `D5`, `git grep -n -P` | `(?:FiniteFreeCommutatorDegreeSix\|RealRooted6\|square6)`: 0, EXIT=1 | `(?:FiniteFreeCommutatorDegreeFive\|RealRooted5\|square5)`: 27, EXIT=0 |
| Pinned `CubicDiscriminant.lean`, `rg -n -P` | `(?=.*(?:discr\|discriminant))(?=.*(?:nonneg\|nonnegative\|[≤≥]))`: 0, EXIT=1 | `(?=.*(?:discr\|discriminant))(?=.*(?:ne_zero\|roots\|Splits))`: 10, EXIT=0 |
| Paper text, `rg -n -P` | `(?i)(?:sextic\|degree.?six\|n\s*=\s*6)`: 0, EXIT=1 | `(?i)(?:quadratic\|degree.?two\|n\s*=\s*2)`: 7, EXIT=0 |

The paper control matches seven `n=2m` occurrences; it verifies the regex
mechanics and text extraction, not seven degree-two theorems. Line-oriented
and name-based searches can miss differently phrased or multiline results.

## Verification receipts

Worker artifacts live in
`/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/ffc6-assembly-0908/attempt-1`.
The final structured envelope records every reading command and its exit
code, the canonical-report declaration IDs, and delivery check outcomes.

- Binding-only `make lean`: EXIT=2, `bind-only.log`.
- Source-expansion `make lean`: EXIT=0, `expansion.log`.
- Initial centered assembly `make lean`: EXIT=2, `centered.log`; a power-normalization direction was corrected.
- Complete theorem `make lean`: EXIT=0, `assembly.log`.
- Canonical `make lean-report`: EXIT=0, `lean-report.log`; Lean 4.33.0 and Mathlib `db584cd6d46c92f209a44c0f1c829460d327499d`.
- `make emit`: EXIT=0, `emit.log`; one new Blueprint document emitted.
- `deposit-header-check` against the recorded base: EXIT=0, `deposit-header-check.log`.
- Canonical `ledger-align --add` with the current Lean report: EXIT=0, `freeze.log`; 3672 modules considered, 1 added, 0 changed, 0 conflicts.
- `make -C tools selftest`: EXIT=0, `selftest.log`; all active and case-backed deferred rule IDs listed.

The new freeze records 21 authored declarations. Its module state ID is
`sha256:c432340052440ba09b56af8739b2dee5b23e520877aa3593410b92b1dbad9daf`;
the accepted event is
`sha256:07b22eef3e97f44d5239919946fe29c4fd7c178181c8c8931583f91c704c1d77`.
The target declaration ID is
`sha256:45f7393b076b05c516370c4b560b5ab1d48cc5f421c38f211a9f2dd34f195f28`.
The escape declaration ID is
`sha256:984112c0a61e8d34b039bb6d01a1e73d4e1f57b7fb36b42fbd569cc818100618`.
The freeze uses the canonical writer underlying `make deposit`, after its
header check and emission steps. Its atom-cover phase is omitted as required.

The actual `#print axioms` output for each of the six public theorems is
`[propext, Classical.choice, Quot.sound]`. For the target:

```text
'D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeSix.real_rooted' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```

There are no remaining unverified mathematical premises and no reported
counterexample. The all-degree conjecture is outside the proved statement.
