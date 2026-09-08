# p-Stam n=3, p=3/2: Bind-Only Derivation

Provenance: implementation worker dispatched under `consensus-rnd:sshx`.
Codex CLI wrote and kernel-checked the probe; no additional skill or subagent
was used by this worker. There are no independent review votes in this report.
The r20 guidance came from the supplied brief and was checked as described below.

Base: `6ae299d5f47da853ded675f57a9da7d7792f2afe` (dev and initial HEAD).
Branch: `lane/math/pstam32-slice-0908`.
Pinned Mathlib: v4.33.0, revision `db584cd6d46c92f209a44c0f1c829460d327499d`.

## Result and Admission

`verdict: bind-only`; `proof_shape: bind-only`;
`escape_witness: none`;
`admission_basis: none (no deposit)`.

The complete supplied statement is proved by `PStam32BindProbe.pstam32_slice`
in the verbatim probe below, with the exact existential `Simple3` predicate,
the unnormalized `phi32`, and outer exponent 2. There is no extra factor
`4/[n(n-1)^2]` and no change to exponent `2/p`.
The source attribution in the brief is Baran Hashemi, arXiv:2604.11922v2,
equation (7). This report makes no independent literature novelty claim.

After local helpers are expanded, the proof consists of frozen theorem
instances/projections, finite-index normalization, polynomial coefficient/evaluation
rewrites, field and ring normalization, square inequalities, and Mathlib rpow
instances. No intermediate statement supplies an escape witness under CLAUDE
5⁗. The finite root witnesses are either projections of frozen chart surjectivity
and factorization or the definitional three-entry vector for `Simple3`.

The first error-free `make lean` ended the mathematical work. This PR contains
only this report: no persistent D5 module, Blueprint, freeze state, deposit,
or coverage change. No atom requires this statement, and no admission exception
is claimed. The probe was temporarily placed at `D5/PStam32BindProbe.lean`
because the canonical `make lean` target builds the configured D5 glob, then
removed. The appendix is evidence, not a newly admitted library API.
CI on this report does not independently compile the fenced appendix.

## Verified Reduction

| Step | Kernel evidence and exact scope |
| --- | --- |
| 1 | `simple3_discriminant` derives `a < 0` and positive discriminant from the original `Simple3`. `normalize_input` sets `k = sqrt(-a/3)`, `t = b/(2*k^3)`, and proves `0 < k`, `-1 < t < 1` and the normalized cubic equality. The scale coordinate is `A = k^2`. |
| 2 | `phi32_scaled_product` proves the score scaling `phi32 = k^(-3/2) * phi32(q_t)`. `normalized_scale` proves `G = k^2 * profile32 t` using `Real.mul_rpow` and `Real.rpow_mul`. |
| 3 | `convolution_cubic` applies `coeff_additiveConvolution` at degrees 0 through 3 and `additive_natDegree_le` above degree 3. The result is exactly `cubic (a+c) (b+d)`. `normalized_convolution` verifies the output coefficients with `K^2 = k^2+l^2` and `z = w*((k/K)*t)+(1-w)*((l/K)*s)`, where `w=k^2/K^2`. |
| 4 | `contract_mem` places the contracted points in the open interval; its convexity places `z` there. `normalized_simple` obtains three distinct roots from frozen `chart_image`, `chart_root_order`, and `cubic_chart_factor`. `output_simple` proves the exact convolution has `Simple3`, with no `additive_splits` or `FiniteSymbolCriterion` assumption. |
| 5 | `profile_contract` applies frozen concavity to `t,-t` with weights `(1+l)/2,(1-l)/2`, then rewrites by `profile32_even`. |
| 6 | `profile_jensen` applies frozen concavity to the contracted points; `normalized_convolution` multiplies by `K^2` and verifies the two scale coefficients to obtain `G(h) >= G(f)+G(g)`. |
| 7 | `finish` uses `Real.add_rpow_le_rpow_add` and `Real.rpow_le_rpow`. `inverse_power` rewrites `G^(3/2)` to `1/phi32^2`, including Lean's totalized zero case. |

The implementation uses positive square-root coordinates throughout. The literal
`A^(3/2)`/`w^(3/2)` notation, the brief's longer strict absolute-value-sum
chain, and the separate discriminant factorization `108(A+B)^3(1-z^2)` were
not separately elaborated. The required domain and output `Simple3` conclusions
were kernel-verified by the equivalent route above; none of those unevaluated
display formulas is a premise of the proof.

## Reindexing and Declaration Shape

`phi32_fin` is the explicit `roots.toFinset` to `Fin 3` sum bridge.
It applies frozen `phi32_product` to `r 0,r 1,r 2`, using injectivity for
pairwise distinction; `Fin.prod_univ_succ` and `Fin.sum_univ_succ` normalize
the three-entry enumeration. The erased inner sum equals the full sum because
the self term is zero. This is a proof, not `rfl`.
The target's live route uses `simple3_triple` and frozen `phi32_product`
directly; `phi32_fin` records the requested full indexed formulation.

Every theorem in the probe has `proof_shape=bind-only`,
`escape_witness=null`, and `admission_basis=none(no-deposit)`:

| Declarations | Reason after helper expansion |
| --- | --- |
| `simple3_triple`, `simple3_of_triple` | Three-entry product normalization and logical witness recoding. |
| `phi32_fin` | Frozen `phi32_product` plus finite-sum normalization. |
| `convolution_cubic` | Frozen coefficient and degree projections plus numeric/ring rewrites. |
| `simple3_discriminant`, `normalize_input` | Mathlib cubic coefficient projections, square facts, square-root identities and normalization. |
| `profile_contract`, `profile_jensen` | Frozen evenness and concavity instances plus ordered-ring operations. |
| `contract_mem` | Mathlib absolute-value and multiplication inequalities. |
| `phi32_nonneg`, `inverse_power`, `finish` | Mathlib finite-sum/rpow instances and exponent normalization. |
| `scaled_factor`, `phi32_scaled_product` | Polynomial evaluation, field normalization, frozen score expansion and rpow product rewrites. |
| `normalized_factor`, `normalized_simple` | Frozen chart witnesses, root order and factorization. |
| `normalized_scale` | The preceding frozen instances and rpow normalization. |
| `normalized_convolution`, `output_simple`, `pstam32_slice` | Composition of the preceding steps and logical projection. |

Frozen prerequisites are identified by their current module state pins (read,
not recomputed). These are module identities, not per-declaration hashes:

| GID | statement_id |
| --- | --- |
| `D5/S3/Analytic/SeriesInequalities/Profile32Concavity` | `sha256:94b1c48fd0b980e6f15e473d58ccd332b0ec91f74eb339c46c5da6e97ae2cbe2` |
| `D5/S3/Analytic/SeriesInequalities/Profile32Calculus` | `sha256:7b367198b11f4c381f9b212cfd5d0751e97c49099a68acd0e2764c0e19964924` |
| `D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients` | `sha256:58abac734b6a8969c6215223633e21fea7d3901df1967f9531622190c058d12c` |

Live frozen theorem interfaces used after local helper expansion:
`phi32_product`, `cubic_chart_factor`, `chart_root_order`,
`chart_image`, `profile32_even`, `profile32_concave`,
`coeff_additiveConvolution`, `additive_natDegree_le`.
The imported definitions `cubic`, `phi32`, `profile32`, and
`additiveConvolution` are reused unchanged.

## Validation and Search Receipts

The local successful command was `make lean` with stdout/stderr redirected to
the runner-owned attempt directory's `build-04.log`; `EXIT=0`.
Cache receipt: project and Mathlib warm, status present, no missing Mathlib
olean files. The complete build reports 12525 jobs; this is not a count of
newly compiled modules.

Attempts 1-3 exited 2. The diagnosed probe errors were: unresolved polynomial
coefficients and an absolute-value rewrite (1); reversed coefficient-index
inequality and `Real.rpow_eq_pow` presentation (2); a redundant `ring`
after `field_simp` had closed the goal (3). All were resolved in attempt 4.
The runner directory retains build logs 2-4; attempt 1's tool output was
truncated, so it is not presented as a complete raw log.

`question_answered`: the exact universal slice in the supplied implementation
brief, preregistered at dispatch before the probe.
`dominating_theorem_search`: the supplied r20 no-match receipt for
`\b(stam|fisher|pStam|p_fisher|pFisher)\b` in D5 and pinned Mathlib is
reused without claiming a fresh global absence search. The worker searched and
read the frozen profile interfaces, convolution interfaces, Mathlib cubic
coefficient API, finite products/sums, and real-power inequalities.
Result: the frozen/Mathlib composition proves the target. Third-party ecosystem
and independent literature searches were not needed for the explicitly ordered
bind-only attempt and are not claimed complete.

Representative fresh commands, all `EXIT=0`:

- `rg -n 'Simple3|coeff_additiveConvolution|additive_natDegree_le|cubic.*discr|discr.*cubic' D5`
- `rg --files .lake/packages/mathlib/Mathlib -g '*Cubic*'`
- `rg -n '^(theorem|lemma|def)|discr.*pos|pos.*discr' .lake/packages/mathlib/Mathlib/Algebra/CubicDiscriminant.lean`
- `rg -n '\b(add_rpow_le_rpow_add|rpow_add_le_add_rpow|sqrt_le_one|sqrt_lt_one|sq_lt_sq₀)\b' .lake/packages/mathlib/Mathlib/Analysis`
- Positive control: `rg -n '\brpow_add_le_add_rpow\b' .lake/packages/mathlib/Mathlib/Analysis` returns 6 lines in this narrower Analysis scope.
- Before preparing the PR, `rg -n '\b(pstam32_slice|output_simple|phi32_fin)\b' D5 -g '*.lean'` hits only this worker's temporary probe. This is a name search, not a proof of semantic novelty.

The complete command/exit inventory and scope limitations are in the worker's
`result.json` at the attempt path supplied by the runner.

Actual Lean output from the successful build:

```text
info: D5/PStam32BindProbe.lean:283:0: 'PStam32BindProbe.phi32_fin' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32BindProbe.lean:284:0: 'PStam32BindProbe.convolution_cubic' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32BindProbe.lean:285:0: 'PStam32BindProbe.simple3_discriminant' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32BindProbe.lean:286:0: 'PStam32BindProbe.profile_contract' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32BindProbe.lean:287:0: 'PStam32BindProbe.profile_jensen' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32BindProbe.lean:288:0: 'PStam32BindProbe.finish' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32BindProbe.lean:289:0: 'PStam32BindProbe.normalize_input' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32BindProbe.lean:290:0: 'PStam32BindProbe.normalized_scale' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32BindProbe.lean:291:0: 'PStam32BindProbe.normalized_simple' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32BindProbe.lean:292:0: 'PStam32BindProbe.normalized_convolution' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32BindProbe.lean:293:0: 'PStam32BindProbe.output_simple' depends on axioms: [propext, Classical.choice, Quot.sound]
info: D5/PStam32BindProbe.lean:294:0: 'PStam32BindProbe.pstam32_slice' depends on axioms: [propext, Classical.choice, Quot.sound]
Build completed successfully (12525 jobs).
```

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

namespace PStam32BindProbe

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

end PStam32BindProbe
```
