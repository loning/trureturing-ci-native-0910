# Strict p-Stam at n=3, p=3/2: Bind-Only

Provenance: implementation worker dispatched under `consensus-rnd:sshx`.
This Codex CLI worker wrote and kernel-checked the temporary probe, with no
additional skill, subagent, or independent review seat. Source guidance was
supplied in the brief; this report records the worker's own source reads and
Lean build. It does not claim independent literature review or review consensus.

Base dev and initial HEAD: `2e315f45146cb6a05717b59f2b93546d1b28940b`.
The supplied worktree was already on `lane/math/pstam-strict-0908`, with a
clean tree and that exact base; the branch was reused.
Lean/Mathlib: v4.33.0; Mathlib revision
`db584cd6d46c92f209a44c0f1c829460d327499d`.

## Result

`verdict: bind-only`; `proof_shape: bind-only`;
`escape_witness: null`; `admission_basis: none (no deposit)`.

The exact strict target is proved by `PStam32StrictProbe.pstam32_strict`
in the verbatim appendix. The first `make lean` returned `EXIT=0`.
The worker then stopped mathematical work, as required by hard requirement 1.

The source attribution supplied in the brief is Baran Hashemi,
*Spectral Structure in Finite Free Information Inequalities and p-Stam Phase
Transitions*, arXiv:2604.11922v2, Conjecture 6.2.
Only centered monic cubics with three distinct real roots are covered.
The score is the frozen, unnormalized `phi32`, and the outer exponent is 2.
No factor `4/[n(n-1)^2]` is inserted, and the exponent is not changed to `2/p`.
No repeated-root extension is chosen or asserted. This is not a claim to cover
the conjecture's full wording about all monic real-rooted polynomials.

This is a report-only change. There is no persistent D5 module, Blueprint,
freeze state, deposit, or cover. The temporary
`D5/PStam32StrictProbe.lean` was needed because canonical `make lean`
builds the configured D5 glob; it was removed after the successful build.
The appendix preserves the checked bytes but is not an admitted library API.
CI on this Markdown report does not independently compile the appendix.

## Where Strictness Comes From

Write `G(f) = phi32(f)^(-4/3)` and `h = additiveConvolution 3 f g`.
The [non-strict report](pstam32-slice-0908.md) already provides the stronger
intermediate estimate `G(f) + G(g) <= G(h)`, by normalization, evenness,
and ordinary concavity. Its entire checked proof is reused in the appendix.

Frozen `chart_image`, `profile32_chart`, `chart_bounds`, and
`profileSum_pos`, followed by Mathlib positivity instances, give
`profile32(t) > 0` for `-1 < t < 1`.
Normalization then gives `A = G(f) > 0` and `B = G(g) > 0`.
The probe also proves `simple3_phi32_pos`, so the original Fisher quantity
cannot vanish on the input domain.

Two direct instances of Mathlib `Real.rpow_lt_rpow` give
`A^(1/2) < (A+B)^(1/2)` and `B^(1/2) < (A+B)^(1/2)`.
Multiplying by the positive numbers A and B, adding, and using
`Real.rpow_add` with `3/2 = 1/2 + 1` gives
`A^(3/2) + B^(3/2) < (A+B)^(3/2)`.
These are Mathlib instances and normalized ordered-ring operations, with
no new analytic lemma.

Consequently the complete chain is

```text
1/phi32(f)^2 + 1/phi32(g)^2
  = A^(3/2) + B^(3/2)
  < (A+B)^(3/2)
  <= G(h)^(3/2)
  = 1/phi32(h)^2.
```

The last equality uses exactly `(-4/3)*(3/2) = -2`.
The convolution remains in `Simple3` by the reused `output_simple` theorem.

## Equality Chain and Curvature

| Step | Equality accounting |
| --- | --- |
| Profile contraction `J(lambda*t) >= J(t)` | Kept non-strict. Equality is allowed, in particular at t=0. It need not be excluded individually. |
| Jensen for the contracted points | Kept non-strict. Equality is allowed when the points coincide; t=s=0 makes this and both contractions equalities simultaneously. |
| Power sum at exponent 3/2 | Always strict for A,B>0 by `strict_power_sum`. On nonnegative A,B the equality boundary is A=0 or B=0; the converse boundary identities follow from the zero-power rewrites. Both alternatives are excluded by `inverse_profile_pos`. Thus simultaneous equality in the full chain is impossible even when the first two steps are equalities. |

The first two steps must not be described as always strict. The symmetric
simple-root family t=s=0 is precisely why their equalities are harmless but
cannot be dismissed. It is not an equality family for the final deficit.

`ConcaveOn` was not upgraded to `StrictConcaveOn`; no such implication is
claimed or needed. Source inspection also corrects the proposed missing
curvature premise: the frozen modules already contain
`curvature_numerator_neg`, `profileSlope_deriv_neg`, and
`chart_strictMonoOn`.

The inspected algebraic certificate is
`N = -1296*(1-z)*signKernel/(z*(9-z^2)*(z^2+3)^3)` on 0<z<1.
Frozen `sign_kernel_pos` gets positivity through
`radical_margin >= 243` and `polynomial_margin >= 243`.
Frozen `profileSlope_deriv_neg` already transfers this sign through positive
`profileSum` and `chartFirst`.
Frozen `chartFirst_pos` proves
`27*(1-z^2)/(sqrt(3+z^2))^5 > 0` on -1<z<1.
These facts support the existing concavity proof; no additional curvature
estimate, strict slope theorem, or equality classification is used for the
strict upgrade in this attempt.

The exact evenness interface read from the frozen source is

```lean
theorem profile32_even (t : ℝ) (ht : t ∈ Ioo (-1) 1) :
    profile32 (-t) = profile32 t
```

## Declaration Shape and Admission

All theorem declarations in the appendix are bind-only after expanding helpers.
All have `escape_witness=null` and `admission_basis=none(no-deposit)`.
The 20 reused theorem declarations retain the individual classifications
recorded in the non-strict report; the namespace alone was changed.
The added declarations are classified as follows.

| Declaration | Expanded proof shape |
| --- | --- |
| `profile32_pos` | Frozen chart surjectivity, chart identity, bounds, and positive profile sum; Mathlib square, division, product, and rpow positivity instances. |
| `inverse_profile_pos` | Reused normalization and scaling followed by `mul_pos` and `sq_pos_of_pos`. |
| `simple3_phi32_pos` | Reused nonnegativity; positivity of the inverse profile excludes phi32=0 by Mathlib zero-rpow normalization. This diagnostic result is not required by the strict target's live proof. |
| `strict_power_sum` | Two `Real.rpow_lt_rpow` instances, two positive-multiplication instances, `add_lt_add`, and `Real.rpow_add` exponent normalization. The helper is not an escape witness. |
| `finish_strict` | The preceding bound, `Real.rpow_le_rpow`, exponent rewriting, and transitivity. |
| `pstam32_strict` | Normalization, projection of `normalized_convolution`, and `finish_strict`. |

No admission exception or computational utility classification is requested,
because no module is deposited. The independent question was preregistered
by the supplied implementation brief: the exact strict slice, not an invented
downstream consumer.

Direct frozen module pins were read, not recomputed:

| GID | statement_id |
| --- | --- |
| D5/S3/Analytic/SeriesInequalities/Profile32Concavity | sha256:94b1c48fd0b980e6f15e473d58ccd332b0ec91f74eb339c46c5da6e97ae2cbe2 |
| D5/S3/Analytic/SeriesInequalities/Profile32Calculus | sha256:7b367198b11f4c381f9b212cfd5d0751e97c49099a68acd0e2764c0e19964924 |
| D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients | sha256:58abac734b6a8969c6215223633e21fea7d3901df1967f9531622190c058d12c |

## Validation and Search Receipts

The build command was
`make lean > /var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/pstam-strict-0908/attempt-1/build-01.log 2>&1`,
`EXIT=0`. It reported `Build completed successfully (12554 jobs).`
That number is the total job count, not the number newly built.
The cache receipt records project and Mathlib warm, status present,
and zero missing Mathlib olean files. There were 14 whitespace warnings in
the temporary probe, including warnings inherited from the reused appendix.
They do not change the kernel result; the report preserves the checked source
without a second mathematical editing or build round.

Searches used `rg`. The exact-name search
`rg -n '\badd_rpow_lt_rpow_add\b' .lake/packages/mathlib/Mathlib/Analysis`
returned 0 matching lines, `EXIT=1`.
The positive control with the same word-boundary regex features,
`rg -n '\badd_rpow_le_rpow_add\b' .lake/packages/mathlib/Mathlib/Analysis`,
returned 7 matching lines, `EXIT=0`.
This only excludes that exact name in that scope; it does not assert that
Mathlib lacks an equivalent strict theorem.

The selected live APIs were read from pinned source and their instantiations
were checked by the build: `Real.rpow_lt_rpow`, `Real.rpow_add`,
`Real.rpow_le_rpow`, and the frozen profile/convolution interfaces.
Before editing, the D5 name search
`rg -n '\b(pstam32_slice|pstam32_strict|Simple3|profile32_pos|profileSlope_deriv_neg)\b' D5 -g '*.lean'`
returned 3 lines, all for the frozen `profileSlope_deriv_neg`, `EXIT=0`.
This is a bounded name search, not a claim of semantic or literature novelty.
Third-party ecosystem search and an independent check of the paper were not
performed after the ordered bind-only attempt succeeded.

The full command/exit inventory is in the runner attempt's `result.json`.
Some broad read outputs were truncated in the transcript; the mandatory
`CLAUDE.md` was then read completely in bounded ranges, and the non-strict
report and frozen source modules were read without truncation.
The raw build log is retained in the attempt directory.

Actual `#print axioms` output for the six added declarations and twelve
reused declarations:

```text
info: D5/PStam32StrictProbe.lean:344:0: 'PStam32StrictProbe.profile32_pos' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:345:0: 'PStam32StrictProbe.inverse_profile_pos' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:346:0: 'PStam32StrictProbe.simple3_phi32_pos' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:347:0: 'PStam32StrictProbe.strict_power_sum' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:348:0: 'PStam32StrictProbe.finish_strict' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:349:0: 'PStam32StrictProbe.pstam32_strict' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:351:0: 'PStam32StrictProbe.phi32_fin' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:352:0: 'PStam32StrictProbe.convolution_cubic' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:353:0: 'PStam32StrictProbe.simple3_discriminant' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:354:0: 'PStam32StrictProbe.profile_contract' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:355:0: 'PStam32StrictProbe.profile_jensen' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:356:0: 'PStam32StrictProbe.finish' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:357:0: 'PStam32StrictProbe.normalize_input' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:358:0: 'PStam32StrictProbe.normalized_scale' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:359:0: 'PStam32StrictProbe.normalized_simple' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:360:0: 'PStam32StrictProbe.normalized_convolution' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:361:0: 'PStam32StrictProbe.output_simple' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32StrictProbe.lean:362:0: 'PStam32StrictProbe.pstam32_slice' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No mathematical premise remains unverified. Independent review, literature
novelty, strict profile concavity, and any repeated-root extension are not
claimed. `stuck_at: null`.

## Verbatim Kernel-Checked Probe

```lean
import D5.S3.Analytic.SeriesInequalities.Profile32Calculus
import D5.S3.Zeros.Convolution.FiniteConvolutionCoefficients
import Mathlib.Analysis.MeanInequalitiesPow
import Mathlib.Algebra.CubicDiscriminant

set_option autoImplicit false
noncomputable section
open Polynomial Set
open scoped BigOperators
open D5.S3.Analytic.SeriesInequalities.Profile32Concavity
open D5.S3.Analytic.SeriesInequalities.Profile32Calculus
open D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
open D5.S3.Zeros.Convolution.FiniteConvolutionCoefficients

namespace PStam32StrictProbe

def Simple3 (f : ℝ[X]) : Prop :=
  ∃ r : Fin 3 → ℝ, Function.Injective r ∧ f = ∏ i, (X - C (r i))

theorem simple3_triple (f : ℝ[X]) (hf : Simple3 f) :
    ∃ u v w : ℝ, u ≠ v ∧ u ≠ w ∧ v ≠ w ∧
      f = (X - C u) * (X - C v) * (X - C w) := by
  obtain ⟨r, hr, hf⟩ := hf
  refine ⟨r 0, r 1, r 2, hr.ne (by decide), hr.ne (by decide), hr.ne (by decide), ?_⟩
  simpa [Fin.prod_univ_succ, mul_assoc] using hf

theorem phi32_fin (r : Fin 3 → ℝ) (hr : Function.Injective r) :
    phi32 (∏ i, (X - C (r i))) =
      ∑ i, Real.rpow |∑ j ∈ Finset.univ.erase i, (r i - r j)⁻¹| (3 / 2 : ℝ) := by
  classical
  have he (i : Fin 3) :
      ∑ j ∈ Finset.univ.erase i, (r i - r j)⁻¹ = ∑ j, (r i - r j)⁻¹ := by
    rw [Finset.sum_erase_eq_sub (by simp)]
    simp
  simp_rw [he]
  simpa [Fin.prod_univ_succ, Fin.sum_univ_succ, mul_assoc, add_assoc] using
    phi32_product (r 0) (r 1) (r 2)
      (hr.ne (by decide)) (hr.ne (by decide)) (hr.ne (by decide))

theorem convolution_cubic (a b c d : ℝ) :
    additiveConvolution 3 (cubic a b) (cubic c d) = cubic (a+c) (b+d) := by
  ext k
  by_cases hk : k ≤ 3
  · have h := coeff_additiveConvolution 3 (cubic a b) (cubic c d) (3-k) (by omega)
    rw [Nat.sub_sub_self hk] at h
    rw [h]
    interval_cases k <;>
      norm_num [cubic, coeff_X, Finset.sum_range_succ, Nat.descFactorial] <;> ring
  · rw [coeff_eq_zero_of_natDegree_lt
      (lt_of_le_of_lt (additive_natDegree_le 3 _ _) (by omega))]
    simp only [cubic, coeff_add, coeff_C_mul, coeff_X_pow, coeff_X, coeff_C]
    simp [show k ≠ 3 by omega, show 1 ≠ k by omega, show k ≠ 0 by omega]

theorem simple3_discriminant (a b : ℝ) (hf : Simple3 (cubic a b)) :
    a < 0 ∧ 0 < -4*a^3 - 27*b^2 := by
  obtain ⟨u, v, w, huv, huw, hvw, hf⟩ := simple3_triple _ hf
  have hp : (Cubic.toPoly ⟨1, 0, a, b⟩ : ℝ[X]) =
      Cubic.toPoly ⟨1, -(u+v+w), u*v+u*w+v*w, -(u*v*w)⟩ := by
    simpa [Cubic.toPoly, cubic] using hf.trans Cubic.prod_X_sub_C_eq
  have hs := Cubic.b_of_eq hp
  have ha := Cubic.c_of_eq hp
  have hb := Cubic.d_of_eq hp
  change (0:ℝ) = -(u+v+w) at hs
  change a = u*v+u*w+v*w at ha
  change b = -(u*v*w) at hb
  have hw : w = -u-v := by linarith only [hs]
  have hd : -4*a^3 - 27*b^2 = ((u-v)*(u-w)*(v-w))^2 := by
    rw [ha, hb, hw]
    ring
  refine ⟨?_, hd ▸ sq_pos_of_ne_zero (mul_ne_zero
    (mul_ne_zero (sub_ne_zero.mpr huv) (sub_ne_zero.mpr huw)) (sub_ne_zero.mpr hvw))⟩
  have huv2 := sq_pos_of_ne_zero (sub_ne_zero.mpr huv)
  rw [hw] at ha
  nlinarith only [ha, huv2, sq_nonneg (u+v)]

theorem profile_contract (t l : ℝ) (ht : t ∈ Ioo (-1) 1)
    (hl : 0 ≤ l) (hl1 : l ≤ 1) : profile32 t ≤ profile32 (l*t) := by
  have hn : -t ∈ Ioo (-1) 1 := ⟨by linarith only [ht.2], by linarith only [ht.1]⟩
  have h := profile32_concave.2 ht hn
    (show 0 ≤ (1+l)/2 by linarith only [hl])
    (show 0 ≤ (1-l)/2 by linarith only [hl1])
    (show (1+l)/2 + (1-l)/2 = (1:ℝ) by ring)
  rw [profile32_even t ht] at h
  simpa only [smul_eq_mul, show (1+l)/2*t + (1-l)/2*(-t) = l*t by ring,
    show (1+l)/2*profile32 t + (1-l)/2*profile32 t = profile32 t by ring] using h

theorem contract_mem (t l : ℝ) (ht : t ∈ Ioo (-1) 1)
    (hl : 0 ≤ l) (hl1 : l ≤ 1) : l*t ∈ Ioo (-1) 1 := by
  have habs : |l*t| = l*|t| := by rw [abs_mul, abs_of_nonneg hl]
  by_cases hl0 : l = 0
  · subst l; norm_num
  · have hh := mul_lt_mul_of_pos_left (abs_lt.mpr ht) (lt_of_le_of_ne hl (Ne.symm hl0))
    rw [mul_one, ← habs] at hh
    exact abs_lt.mp (hh.trans_le hl1)

theorem profile_jensen (t s w l m : ℝ) (ht : t ∈ Ioo (-1) 1)
    (hs : s ∈ Ioo (-1) 1) (hw : 0 ≤ w) (hw1 : w ≤ 1)
    (hl : 0 ≤ l) (hl1 : l ≤ 1) (hm : 0 ≤ m) (hm1 : m ≤ 1) :
    w * profile32 t + (1-w) * profile32 s ≤
      profile32 (w*(l*t) + (1-w)*(m*s)) := by
  have ht' := contract_mem t l ht hl hl1
  have hs' := contract_mem s m hs hm hm1
  have hc := profile32_concave.2 ht' hs' hw
    (show 0 ≤ 1-w by linarith only [hw1]) (show w+(1-w) = 1 by ring)
  have h1 := mul_le_mul_of_nonneg_left (profile_contract t l ht hl hl1) hw
  have h2 := mul_le_mul_of_nonneg_left (profile_contract s m hs hm hm1)
    (show 0 ≤ 1-w by linarith only [hw1])
  exact (add_le_add h1 h2).trans (by simpa only [smul_eq_mul] using hc)

theorem phi32_nonneg (f : ℝ[X]) : 0 ≤ phi32 f := by
  exact Finset.sum_nonneg fun x _ => Real.rpow_nonneg (abs_nonneg _) _

theorem inverse_power (x : ℝ) (hx : 0 ≤ x) :
    (x ^ (-(4/3 : ℝ))) ^ (3/2 : ℝ) = 1 / x^2 := by
  rw [← Real.rpow_mul hx]
  norm_num [Real.rpow_neg hx, Real.rpow_natCast, one_div]

theorem finish (f g h : ℝ[X])
    (hG : (phi32 f) ^ (-(4/3 : ℝ)) + (phi32 g) ^ (-(4/3 : ℝ)) ≤
      (phi32 h) ^ (-(4/3 : ℝ))) :
    1 / (phi32 f)^2 + 1 / (phi32 g)^2 ≤ 1 / (phi32 h)^2 := by
  have hf := Real.rpow_nonneg (phi32_nonneg f) (-(4/3 : ℝ))
  have hg := Real.rpow_nonneg (phi32_nonneg g) (-(4/3 : ℝ))
  have h1 := Real.add_rpow_le_rpow_add hf hg (by norm_num : (1:ℝ) ≤ 3/2)
  have h2 := Real.rpow_le_rpow (add_nonneg hf hg) hG (by norm_num : (0:ℝ) ≤ 3/2)
  simpa only [inverse_power _ (phi32_nonneg _)] using h1.trans h2

theorem normalize_input (a b : ℝ) (hf : Simple3 (cubic a b)) :
    ∃ k t : ℝ, 0 < k ∧ t ∈ Ioo (-1) 1 ∧
      cubic a b = cubic (-3*k^2) (2*k^3*t) := by
  obtain ⟨ha, hd⟩ := simple3_discriminant a b hf
  let k := Real.sqrt (-a/3)
  have hA : 0 < -a/3 := by linarith only [ha]
  have hk : 0 < k := Real.sqrt_pos.mpr hA
  have hk2 : k^2 = -a/3 := Real.sq_sqrt hA.le
  have ha' : a = -3*k^2 := by linarith only [hk2]
  have hd' : b^2 < (2*k^3)^2 := by rw [ha'] at hd; nlinarith only [hd]
  have hden : 0 < 2*k^3 := by positivity
  have hbabs : |b| < 2*k^3 :=
    (sq_lt_sq₀ (abs_nonneg b) hden.le).mp (by simpa only [sq_abs] using hd')
  refine ⟨k, b/(2*k^3), hk, ?_, ?_⟩
  · constructor
    · apply (lt_div_iff₀ hden).mpr
      linarith only [(abs_lt.mp hbabs).1]
    · apply (div_lt_iff₀ hden).mpr
      linarith only [(abs_lt.mp hbabs).2]
  · rw [ha']
    congr 1
    field_simp

theorem scaled_factor (k t u v w : ℝ) (hk : 0 < k)
    (hf : cubic (-3) (2*t) = (X-C u)*(X-C v)*(X-C w)) :
    cubic (-3*k^2) (2*k^3*t) = (X-C (k*u))*(X-C (k*v))*(X-C (k*w)) := by
  apply Polynomial.funext
  intro x
  have h := congrArg (Polynomial.eval (x/k)) hf
  simp only [cubic, eval_add, eval_pow, eval_mul, eval_sub, eval_X, eval_C] at h ⊢
  field_simp [hk.ne'] at h
  nlinarith only [h]

theorem phi32_scaled_product (k u v w : ℝ) (hk : 0 < k)
    (huv : u ≠ v) (huw : u ≠ w) (hvw : v ≠ w) :
    phi32 ((X-C (k*u))*(X-C (k*v))*(X-C (k*w))) =
      k ^ (-(3/2 : ℝ)) * phi32 ((X-C u)*(X-C v)*(X-C w)) := by
  have hkuv : k*u ≠ k*v := fun h => huv (mul_left_cancel₀ hk.ne' h)
  have hkuw : k*u ≠ k*w := fun h => huw (mul_left_cancel₀ hk.ne' h)
  have hkvw : k*v ≠ k*w := fun h => hvw (mul_left_cancel₀ hk.ne' h)
  rw [phi32_product _ _ _ hkuv hkuw hkvw, phi32_product _ _ _ huv huw hvw]
  simp only [Real.rpow_eq_pow]
  have hs (u v w : ℝ) :
      |(k*u-k*v)⁻¹ + (k*u-k*w)⁻¹| ^ (3/2 : ℝ) =
        k ^ (-(3/2 : ℝ)) * |(u-v)⁻¹ + (u-w)⁻¹| ^ (3/2 : ℝ) := by
    rw [← mul_sub, ← mul_sub, mul_inv, mul_inv, ← mul_add, abs_mul,
      Real.mul_rpow (abs_nonneg _) (abs_nonneg _), abs_inv, abs_of_pos hk,
      Real.inv_rpow hk.le, Real.rpow_neg hk.le]
  rw [hs, hs, hs]
  ring

theorem normalized_factor (t : ℝ) (ht : t ∈ Ioo (-1) 1) :
    ∃ u v w : ℝ, u ≠ v ∧ u ≠ w ∧ v ≠ w ∧
      cubic (-3) (2*t) = (X-C u)*(X-C v)*(X-C w) := by
  obtain ⟨z, hz, rfl⟩ := show t ∈ chart '' Ioo (-1) 1 from by
    rw [chart_image]; exact ht
  have ho := chart_root_order z hz
  exact ⟨leftRoot z, middleRoot z, rightRoot z, ho.1.ne, (ho.1.trans ho.2).ne,
    ho.2.ne, cubic_chart_factor z⟩

theorem normalized_scale (k t : ℝ) (hk : 0 < k) (ht : t ∈ Ioo (-1) 1) :
    (phi32 (cubic (-3*k^2) (2*k^3*t))) ^ (-(4/3 : ℝ)) = k^2 * profile32 t := by
  obtain ⟨u, v, w, huv, huw, hvw, hf⟩ := normalized_factor t ht
  have hp : phi32 (cubic (-3*k^2) (2*k^3*t)) =
      k ^ (-(3/2 : ℝ)) * phi32 (cubic (-3) (2*t)) := by
    rw [scaled_factor k t u v w hk hf, hf]
    exact phi32_scaled_product k u v w hk huv huw hvw
  rw [hp, Real.mul_rpow (Real.rpow_nonneg hk.le _) (phi32_nonneg _),
    ← Real.rpow_mul hk.le]
  norm_num [profile32]

theorem simple3_of_triple (u v w : ℝ) (huv : u ≠ v) (huw : u ≠ w) (hvw : v ≠ w) :
    Simple3 ((X-C u)*(X-C v)*(X-C w)) := by
  refine ⟨![u,v,w], ?_, ?_⟩
  · intro i j h
    fin_cases i <;> fin_cases j <;> simp_all
  · simp [Fin.prod_univ_succ, mul_assoc]

theorem normalized_simple (k t : ℝ) (hk : 0 < k) (ht : t ∈ Ioo (-1) 1) :
    Simple3 (cubic (-3*k^2) (2*k^3*t)) := by
  obtain ⟨u, v, w, huv, huw, hvw, hf⟩ := normalized_factor t ht
  rw [scaled_factor k t u v w hk hf]
  exact simple3_of_triple _ _ _
    (fun h => huv (mul_left_cancel₀ hk.ne' h))
    (fun h => huw (mul_left_cancel₀ hk.ne' h))
    (fun h => hvw (mul_left_cancel₀ hk.ne' h))

theorem normalized_convolution (k l t s : ℝ) (hk : 0 < k) (hl : 0 < l)
    (ht : t ∈ Ioo (-1) 1) (hs : s ∈ Ioo (-1) 1) :
    Simple3 (additiveConvolution 3 (cubic (-3*k^2) (2*k^3*t))
      (cubic (-3*l^2) (2*l^3*s))) ∧
    (phi32 (cubic (-3*k^2) (2*k^3*t))) ^ (-(4/3 : ℝ)) +
      (phi32 (cubic (-3*l^2) (2*l^3*s))) ^ (-(4/3 : ℝ)) ≤
      (phi32 (additiveConvolution 3 (cubic (-3*k^2) (2*k^3*t))
        (cubic (-3*l^2) (2*l^3*s)))) ^ (-(4/3 : ℝ)) := by
  let K := Real.sqrt (k^2+l^2)
  have hK : 0 < K := Real.sqrt_pos.mpr (by positivity)
  have hK2 : K^2 = k^2+l^2 := Real.sq_sqrt (by positivity)
  have hkK : k < K := (sq_lt_sq₀ hk.le hK.le).mp (by nlinarith only [hK2, sq_pos_of_pos hl])
  have hlK : l < K := (sq_lt_sq₀ hl.le hK.le).mp (by nlinarith only [hK2, sq_pos_of_pos hk])
  let w := k^2/K^2
  have hw : 0 ≤ w := div_nonneg (sq_nonneg _) (sq_nonneg _)
  have hw1 : w ≤ 1 := (div_le_one (sq_pos_of_pos hK)).mpr (by nlinarith only [hK2, sq_nonneg l])
  have hkw : 0 ≤ k/K := div_nonneg hk.le hK.le
  have hkw1 : k/K ≤ 1 := (div_le_one hK).mpr hkK.le
  have hlw : 0 ≤ l/K := div_nonneg hl.le hK.le
  have hlw1 : l/K ≤ 1 := (div_le_one hK).mpr hlK.le
  let z := w*((k/K)*t) + (1-w)*((l/K)*s)
  have hz : z ∈ Ioo (-1) 1 := by
    have hc := (convex_Ioo (-1:ℝ) 1)
      (contract_mem t (k/K) ht hkw hkw1) (contract_mem s (l/K) hs hlw hlw1)
      hw (show 0 ≤ 1-w by linarith only [hw1]) (show w+(1-w) = 1 by ring)
    simpa only [smul_eq_mul] using hc
  have hwK : K^2*w = k^2 := by dsimp [w]; field_simp
  have hmK : K^2*(1-w) = l^2 := by nlinarith only [hK2, hwK]
  have hzK : 2*K^3*z = 2*k^3*t + 2*l^3*s := by
    dsimp [z]
    calc
      _ = 2*(K^2*w)*(k*t) + 2*(K^2*(1-w))*(l*s) := by field_simp
      _ = _ := by rw [hwK, hmK]; ring
  have hconv : additiveConvolution 3 (cubic (-3*k^2) (2*k^3*t))
      (cubic (-3*l^2) (2*l^3*s)) = cubic (-3*K^2) (2*K^3*z) := by
    rw [convolution_cubic]
    congr 1
    · nlinarith only [hK2]
    · exact hzK.symm
  rw [hconv]
  refine ⟨normalized_simple K z hK hz, ?_⟩
  rw [normalized_scale k t hk ht, normalized_scale l s hl hs,
    normalized_scale K z hK hz]
  have hj := mul_le_mul_of_nonneg_left
    (profile_jensen t s w (k/K) (l/K) ht hs hw hw1 hkw hkw1 hlw hlw1)
    (sq_nonneg K)
  calc
    _ = K^2*(w*profile32 t + (1-w)*profile32 s) := by
      rw [mul_add, ← mul_assoc, hwK, ← mul_assoc, hmK]
    _ ≤ _ := hj

theorem output_simple (a b c d : ℝ) (hf : Simple3 (cubic a b))
    (hg : Simple3 (cubic c d)) :
    Simple3 (additiveConvolution 3 (cubic a b) (cubic c d)) := by
  obtain ⟨k, t, hk, ht, hf⟩ := normalize_input a b hf
  obtain ⟨l, s, hl, hs, hg⟩ := normalize_input c d hg
  rw [hf, hg]
  exact (normalized_convolution k l t s hk hl ht hs).1

theorem pstam32_slice (a b c d : ℝ) (hf : Simple3 (cubic a b))
    (hg : Simple3 (cubic c d)) :
    1 / phi32 (cubic a b)^2 + 1 / phi32 (cubic c d)^2 ≤
      1 / phi32 (additiveConvolution 3 (cubic a b) (cubic c d))^2 := by
  obtain ⟨k, t, hk, ht, hf⟩ := normalize_input a b hf
  obtain ⟨l, s, hl, hs, hg⟩ := normalize_input c d hg
  rw [hf, hg]
  exact finish _ _ _ (normalized_convolution k l t s hk hl ht hs).2

theorem profile32_pos (t : ℝ) (ht : t ∈ Ioo (-1) 1) : 0 < profile32 t := by
  obtain ⟨z, hz, rfl⟩ := show t ∈ chart '' Ioo (-1) 1 from by
    rw [chart_image]; exact ht
  rw [profile32_chart z hz]
  have hw : 0 < weight z := by
    unfold weight
    exact div_pos (mul_pos (by norm_num)
      (sq_pos_of_pos (sub_pos.mpr (chart_bounds z hz).1))) (by positivity)
  exact mul_pos hw (Real.rpow_pos_of_pos (profileSum_pos z hz) _)

theorem inverse_profile_pos (a b : ℝ) (hf : Simple3 (cubic a b)) :
    0 < (phi32 (cubic a b)) ^ (-(4/3 : ℝ)) := by
  obtain ⟨k, t, hk, ht, he⟩ := normalize_input a b hf
  rw [he, normalized_scale k t hk ht]
  exact mul_pos (sq_pos_of_pos hk) (profile32_pos t ht)

theorem simple3_phi32_pos (a b : ℝ) (hf : Simple3 (cubic a b)) :
    0 < phi32 (cubic a b) := by
  have h := inverse_profile_pos a b hf
  by_contra hn
  have h0 : phi32 (cubic a b) = 0 :=
    le_antisymm (not_lt.mp hn) (phi32_nonneg _)
  norm_num [h0] at h

theorem strict_power_sum (A B : ℝ) (hA : 0 < A) (hB : 0 < B) :
    A ^ (3/2 : ℝ) + B ^ (3/2 : ℝ) < (A+B) ^ (3/2 : ℝ) := by
  have h1 := mul_lt_mul_of_pos_right
    (Real.rpow_lt_rpow hA.le (lt_add_of_pos_right A hB)
      (by norm_num : (0:ℝ) < 1/2)) hA
  have h2 := mul_lt_mul_of_pos_right
    (Real.rpow_lt_rpow hB.le (lt_add_of_pos_left B hA)
      (by norm_num : (0:ℝ) < 1/2)) hB
  have hp (x : ℝ) (hx : 0 < x) :
      x ^ (3/2 : ℝ) = x ^ (1/2 : ℝ) * x := by
    rw [show (3/2 : ℝ) = 1/2 + 1 by norm_num, Real.rpow_add hx, Real.rpow_one]
  rw [hp A hA, hp B hB, hp (A+B) (add_pos hA hB), mul_add]
  exact add_lt_add h1 h2

theorem finish_strict (f g h : ℝ[X])
    (hf : 0 < (phi32 f) ^ (-(4/3 : ℝ)))
    (hg : 0 < (phi32 g) ^ (-(4/3 : ℝ)))
    (hG : (phi32 f) ^ (-(4/3 : ℝ)) + (phi32 g) ^ (-(4/3 : ℝ)) ≤
      (phi32 h) ^ (-(4/3 : ℝ))) :
    1 / (phi32 f)^2 + 1 / (phi32 g)^2 < 1 / (phi32 h)^2 := by
  have h1 := strict_power_sum _ _ hf hg
  have h2 := Real.rpow_le_rpow (add_nonneg hf.le hg.le) hG
    (by norm_num : (0:ℝ) ≤ 3/2)
  simpa only [inverse_power _ (phi32_nonneg _)] using h1.trans_le h2

theorem pstam32_strict (a b c d : ℝ) (hf : Simple3 (cubic a b))
    (hg : Simple3 (cubic c d)) :
    1 / phi32 (cubic a b)^2 + 1 / phi32 (cubic c d)^2 <
      1 / phi32 (additiveConvolution 3 (cubic a b) (cubic c d))^2 := by
  have hpf := inverse_profile_pos a b hf
  have hpg := inverse_profile_pos c d hg
  apply finish_strict _ _ _ hpf hpg
  obtain ⟨k, t, hk, ht, he⟩ := normalize_input a b hf
  obtain ⟨l, s, hl, hs, he'⟩ := normalize_input c d hg
  rw [he, he']
  exact (normalized_convolution k l t s hk hl ht hs).2

#print axioms profile32_pos
#print axioms inverse_profile_pos
#print axioms simple3_phi32_pos
#print axioms strict_power_sum
#print axioms finish_strict
#print axioms pstam32_strict

#print axioms phi32_fin
#print axioms convolution_cubic
#print axioms simple3_discriminant
#print axioms profile_contract
#print axioms profile_jensen
#print axioms finish
#print axioms normalize_input
#print axioms normalized_scale
#print axioms normalized_simple
#print axioms normalized_convolution
#print axioms output_simple
#print axioms pstam32_slice

end PStam32StrictProbe

```
