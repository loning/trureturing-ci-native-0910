# CMP Conjecture 5.3 在 **degree 7**:内核验证通过,判 `bind-only`

**判形**:`bind-only`。`escape_witness: none`;`admission_basis: none(no deposit)`。
按 CLAUDE.md 第 5⁴ 条,bind-only 陈述不得单独首次冻结;三条出路逐条不通(见下),故留档。

**产地**:`consensus-rnd:sshx`;实施席 1 席 codex-cli(`septic-assembly-0908`,1,382s),**零独立评审席**。
本文件由 orchestrator 写入;**orchestrator 未重跑其 Lean 构建**。该席自报 `make lean` `EXIT=0`。

---

## 已证的陈述

```lean
theorem real_rooted (p q : ℝ[X]) (hp : RealRooted7 p) (hq : RealRooted7 q) :
    RealRooted7 (square7 p q)
```

`RealRooted7 p := ∃ r : Fin 7 → ℝ, p = ∏ i, (X - C (r i))` —— **允许重根与零根,无 distinctness、无非零根要求**。

即 **Campbell–Morales–Perales, arXiv:2502.00254v2, SIGMA 21 (2025) 108, Conjecture 5.3
在 degree 7 对全部实根输入对成立**。
原文 **Theorem 5.6 只覆盖偶数度 `2m` 且带 `Q_m(Sym(q))` 的分解假设**;
**degree 7 是奇数度,不在其射程内**;原文 Remark 3.2 只说奇数度「多一个零根」,那不是对该猜想的证明。

## 为什么是 bind-only —— 以及这**不是**坏消息

该席第一次尝试就用「钉版 Mathlib + 冻结源定义 + 冻结的包络/判别式/三次分解见证 +
逻辑投影 + 有限系数归一化 + `sq_nonneg` + `linarith only`」闭合了整条目标,
**没有引入任何新的中间内容**,故 `escape_witness: none`。

**三个冻结前提**(该席读了各自的 state pin):

| GID | module_statement_id |
|---|---|
| `D5/S3/Zeros/CoefficientBounds/SepticEnvelope.centered_real_septic_envelope` | `sha256:a6597fd6b4006f57…` |
| `D5/S3/Zeros/CoefficientBounds/SepticDiscriminant.centered_real_septic_discriminant` | `sha256:9ea90348eb23f7e8…` |
| `D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.cubic_nonnegative_factorization` | `sha256:c4323…` |

⟹ **degree 7 的真值已经隐含在这三条已冻结的定理里**;装配层只是把它们接起来。
按第 5⁴ 条的设计意图,这类结论**不需要单独冻结,因为它随时可从冻结件重新导出**。

**三条出路逐条查过**:(a) 消化 —— 无对应 atom(该模块形式化的是 arXiv 方向,非本仓理论卷句子);
(b) 引理 —— 需内容宿主,而第一、二层**均已冻结**,改它们会撞 SL-008;
(c) 换 Γ —— 本线首次 bind-only,不触发。**故留档。**

## 内核验证的展开(`coefficients_match_brief: true`)

```
commutatorKernel 7 = X⁷ − (1029/16)·X⁵ + (735/8)·X³ − (245/32)·X

square₇(p,q) = X⁷ − C(7uU/12)·X⁵ + C(5(u²+21w/5)(U²+21W/5)/294)·X³
                  − C(5(2s+2uw/7−4v²/35)(2S+2UW/7−4V²/35)/32)·X
             = X · ( Y³ − a·Y² + b·Y − c ) |_{Y = X²}
   a = 7·A·A'/12,   b = 5·B·B'/294,   c = 5·Z·Z'/32
```

**奇偶性也被证明**:6、4、2、0 次系数**全为零**,7 次以上亦然。
这条展开此前由**两条互不可见的独立来源**交叉验证(codex 探针读仓内定义 + SymPy + Lean;
nyxid 席读源文 Notation 5.1 与 Definition 2.9),**系数逐项等价**;本轮再由 Lean **kernel 验证**。

## 两个退化情形的处理(照第一、二层同一形态)

**`A = 0` 或 `A' = 0`**:`centered_zero` 由 Mathlib 系数恒等式取 `∑ r = 0`,
用 `2u = (∑r)² − ∑r²` 与 `linarith only` 得 `∑ r² = 0`,
再由 `sq_nonneg` + `Finset.sum_eq_zero_iff_of_nonneg` 得**每个 `rᵢ = 0`**;
系数投影给出 `square₇ = X⁷`,根映射取常零。**全程无除以 `A` 或 `A'`。**

**零根 / 重根**:根映射取

```
![0, √x, −√x, √y, −√y, √z', −√z']
```

`Real.sq_sqrt` 只需 `0 ≤ x, y, z'`(**含等于**);环归一化直接证七因子恒等式,
**无消去、无 distinctness 要求、不除以任何根**;`√0 = 0` **保留重数**。

## 它明确**没有**用的东西(`remark_5_5` 字段照录)

> 活证明展开源运算、使用冻结的包络与三次判别式、并取出冻结的非负三次根。
> 它**既不调用奇数度的乘法保持定理,也不用 CMP Theorem 5.6,也不用 `additive_splits`**。
> **degree 5 模块未被导入。**

(degree 5 模块在 dev 上**未冻结** —— 见 #6361 的 utility 误标与降级棘轮 —— 故本层也不能引用它。)

## 公理闭包

全部声明为标准三公理 `[propext, Classical.choice, Quot.sound]`,含
`commutatorKernel_seven`、`centered_expansion`、`centered_data`、`centered_real_rooted`、
以及两条 private(`coefficient_second_moment`、`centered_zero`)。**无 sorry、无私 axiom。**

## 构建成本

`/usr/bin/time -l make lean`,Darwin arm64,Lean `v4.33.0`:
最终 **27.21 s / 峰值 RSS 3,126,427,648 B(≈3.13 GB)**,**不拆分**,一个临时源文件用 `Elab.async false`。
**没有调高 `maxHeartbeats` / `maxRecDepth`,没有改动任何常数。**
(该席另记:某次运行的 5.91 GB 读数含重建变动的 dev 依赖与 CLI,**不归本探针**。)

## 未做 / 边界(该席自报,照录)

- **无独立评审、未跑 CI/admission** —— bind-only 的停手条件要求不 deposit、不开 PR;
- **不主张文献新颖性**;该席**未独立取回** arXiv v2 原文,源忠实性依据用户 brief 与冻结的运算定义;
- 首次 MSBuild 子节点退出的原因**未查明**(其报告的临时诊断目录读取时已不存在);
  记录在案的重试在**未改源码、未改预算**的情况下成功;
- 最终探针有两条 style 警告(空白、`unnecessarySeqFocus`),**无 error,未禁用任何 linter**;
- 下列源码**不在** `Golden/Frozen/**`,**不是**冻结真值。

## 逐字源码(run-local 探针,`make lean EXIT=0`)

```lean
/- GID: D5/SepticAssemblyBindProbe
   generality: I
   mirror-B: D5/B/SepticAssemblyBindProbe
   mirror-E: none(waiver:run-local-bind-only-probe)
   anchors: []
   utility: none
   digest: Temporary bind-only attempt for the degree-seven commutator. -/

import D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeSix
import D5.S3.Zeros.CoefficientBounds.SepticDiscriminant

/-!
Run-local attempt, not a proposed deposit. All helpers are to be inlined when
classifying the proof. Only frozen premises and pinned Mathlib are imported.
The degree-five implementation is a syntax reference and is not imported.

utility: none, declaration by declaration:
* RealRooted7: a predicate for arbitrary products, with multiplicity.
* square7: the source operation on arbitrary real polynomials.
* centeredSeptic, septic: symbolic polynomials with arbitrary real coefficients.
* dilate_septic: normalization of the frozen dilation definition.
* symmetrize_septic, symmetrize_centered: symbolic convolution identities.
* multiplicative_odd: coefficientwise normalization for arbitrary real inputs.
* commutatorKernel_seven: normalization of the frozen kernel definition.
* centered_expansion: symbolic identity for all twelve real coefficients.
* root_sum_zero: an instance of Mathlib's next-coefficient identity.
* centered_data: projections of the frozen envelope and discriminant.
* coefficient_second_moment: symbolic identity for every real root map.
* centered_zero: sum-of-squares normalization with Mathlib nonnegativity.
* centered_real_rooted: frozen cubic witnesses, Mathlib square roots, and ring
  normalization, including the required vanishing-moment branches.
* exists_septic: Mathlib monicity, degree, and coefficient reconstruction.
* septic_translate: the binomial identity with arbitrary real parameters.
* real_rooted_translate: Mathlib product composition, translating each root.
* symmetrize_translation: rewriting and polynomial normalization.
* centered_representative: translation by minus one seventh of the next
  coefficient and projection of the preceding identities.
* real_rooted: assembly from these normalized identities and frozen witnesses.
The final tactic macro abbreviates this last proof and has no mathematical
assertion. Its negative diagnostic guard checks that the bind attempt succeeds.
None enumerates bounded input values, implements a mathematical checker,
leaves a numerical premise to be verified, or certifies a finite input instance.

proof_shape: bind-only (subject to successful compilation of the complete file)
escape_witness: none
admission_basis: none(no deposit)
No Theorem 5.6 / Remark 5.5 shortcut or additive_splits is used.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option Elab.async false

noncomputable section

namespace SepticAssemblyBindProbe

open Polynomial D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
open scoped BigOperators

def RealRooted7 (p : ℝ[X]) : Prop :=
  ∃ r : Fin 7 → ℝ, p = ∏ i, (X - C (r i))

def square7 (p q : ℝ[X]) : ℝ[X] :=
  multiplicativeConvolution 7
    (multiplicativeConvolution 7 (symmetrize 7 p) (symmetrize 7 q))
    (commutatorKernel 7)

def centeredSeptic (u v w t s z : ℝ) : ℝ[X] :=
  X^7 + C u * X^5 + C v * X^4 + C w * X^3 + C t * X^2 + C s * X + C z

private def septic (a u v w t s z : ℝ) : ℝ[X] :=
  X^7 + C a * X^6 + C u * X^5 + C v * X^4 + C w * X^3 + C t * X^2 + C s * X + C z

private theorem dilate_septic (a u v w t s z : ℝ) :
    dilate 7 (-1) (septic a u v w t s z) = septic (-a) u (-v) w (-t) s (-z) := by
  simp [dilate, septic]
  ring

private theorem symmetrize_septic (a u v w t s z : ℝ) :
    symmetrize 7 (septic a u v w t s z) =
      centeredSeptic (2*u-6*a^2/7) 0 (2*w-8*a*v/7+10*u^2/21) 0
        (2*s-4*a*t/7+2*u*w/7-4*v^2/35) 0 := by
  rw [symmetrize, dilate_septic]
  change (∑ k ∈ Finset.range (7+1),
    C ((-1)^k * ((descPochhammer ℝ k).eval 7 *
      ∑ i ∈ Finset.range (k+1),
        elementaryCoeff 7 (septic a u v w t s z) i *
          elementaryCoeff 7 (septic (-a) u (-v) w (-t) s (-z)) (k-i) /
          ((descPochhammer ℝ i).eval 7 * (descPochhammer ℝ (k-i)).eval 7))) *
      X^(7-k)) = _
  ext j
  norm_num only [Finset.sum_range_succ, Finset.sum_range_zero,
    Nat.reduceAdd, Nat.reduceSub, Nat.reduceMul, elementaryCoeff, septic,
    centeredSeptic, coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X,
    coeff_X, coeff_X_pow, coeff_C, coeff_sum,
    descPochhammer_succ_eval, descPochhammer_zero, eval_one,
    map_zero, map_one, zero_add, add_zero, one_mul, mul_one, mul_zero, zero_mul,
    pow_zero, pow_one, ite_true, ite_false]
  split_ifs <;> first | contradiction | omega | ring

private theorem symmetrize_centered (u v w t s z : ℝ) :
    symmetrize 7 (centeredSeptic u v w t s z) =
      centeredSeptic (2*u) 0 (2*w+10*u^2/21) 0 (2*s+2*u*w/7-4*v^2/35) 0 := by
  simpa [septic, centeredSeptic] using symmetrize_septic 0 u v w t s z

private theorem multiplicative_odd (u w s U W S : ℝ) :
    multiplicativeConvolution 7 (centeredSeptic u 0 w 0 s 0)
      (centeredSeptic U 0 W 0 S 0) =
        centeredSeptic (u*U/21) 0 (w*W/35) 0 (s*S/7) 0 := by
  change (∑ k ∈ Finset.range (7+1), C ((-1)^k *
    (elementaryCoeff 7 (centeredSeptic u 0 w 0 s 0) k *
      elementaryCoeff 7 (centeredSeptic U 0 W 0 S 0) k / (Nat.choose 7 k : ℝ))) *
    X^(7-k)) = _
  ext j
  norm_num [Finset.sum_range_succ, elementaryCoeff, centeredSeptic,
    coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X, coeff_X, coeff_X_pow,
    coeff_C, coeff_sum, Nat.choose]

theorem commutatorKernel_seven :
    commutatorKernel 7 = centeredSeptic (-(1029/16)) 0 (735/8) 0 (-(245/32)) 0 := by
  ext j
  norm_num only [commutatorKernel, Finset.sum_range_succ, Finset.sum_range_zero,
    Nat.reduceAdd, Nat.reduceSub, Nat.reduceMul, Nat.reduceDiv, centeredSeptic,
    descPochhammer_succ_eval, descPochhammer_zero, eval_one, Nat.choose,
    coeff_sum, coeff_add, coeff_C_mul_X_pow, coeff_C_mul_X, coeff_X_pow,
    coeff_C, coeff_neg, map_zero, zero_add, add_zero, one_mul, mul_one,
    mul_zero, zero_mul, pow_zero, pow_one, coeff_zero]

theorem centered_expansion (u v w t s z U V W T S Z : ℝ) :
    square7 (centeredSeptic u v w t s z) (centeredSeptic U V W T S Z) =
      X^7 - C (7*u*U/12) * X^5 + C (5*(u^2+21*w/5)*(U^2+21*W/5)/294) * X^3 -
        C (5*(2*s+2*u*w/7-4*v^2/35)*(2*S+2*U*W/7-4*V^2/35)/32) * X := by
  rw [square7, symmetrize_centered, symmetrize_centered, commutatorKernel_seven,
    multiplicative_odd, multiplicative_odd]
  ext j
  norm_num only [centeredSeptic, coeff_add, coeff_sub, coeff_C_mul_X_pow,
    coeff_C_mul_X, coeff_X_pow, coeff_C, map_zero, zero_mul, add_zero, coeff_zero]
  split_ifs <;> first | omega | ring

private theorem root_sum_zero (p : ℝ[X]) (r : Fin 7 → ℝ)
    (hp : p = ∏ i, (X-C (r i))) (hcoeff : p.coeff 6 = 0) : ∑ i, r i = 0 := by
  have h := prod_X_sub_C_coeff_card_pred (Finset.univ : Finset (Fin 7)) r (by decide)
  norm_num only [Finset.card_univ, Fintype.card_fin, Nat.reduceSub] at h
  rw [← hp, hcoeff] at h
  exact neg_eq_zero.mp h.symm

theorem centered_data (u v w t s z U V W T S Z : ℝ)
    (hp : RealRooted7 (centeredSeptic u v w t s z))
    (hq : RealRooted7 (centeredSeptic U V W T S Z)) :
    let a := 7*u*U/12
    let b := 5*(u^2+21*w/5)*(U^2+21*W/5)/294
    let c := 5*(2*s+2*u*w/7-4*v^2/35)*(2*S+2*U*W/7-4*V^2/35)/32
    0 ≤ a ∧ 0 ≤ b ∧ 0 ≤ c ∧
      0 ≤ a^2*b^2-4*b^3-4*a^3*c-27*c^2+18*a*b*c := by
  obtain ⟨r, hr⟩ := hp
  obtain ⟨r', hr'⟩ := hq
  have hc := root_sum_zero _ r hr (by simp [centeredSeptic])
  have hc' := root_sum_zero _ r' hr' (by simp [centeredSeptic])
  have he := D5.S3.Zeros.CoefficientBounds.SepticEnvelope.centered_real_septic_envelope r hc
  have he' := D5.S3.Zeros.CoefficientBounds.SepticEnvelope.centered_real_septic_envelope r' hc'
  have hd := D5.S3.Zeros.CoefficientBounds.SepticDiscriminant.centered_real_septic_discriminant
    r r' hc hc'
  dsimp only at he he' hd
  rw [← hr] at he
  rw [← hr'] at he'
  rw [← hr, ← hr'] at hd
  have hA : 0 ≤ -u := by simpa [centeredSeptic] using he.1
  have hA' : 0 ≤ -U := by simpa [centeredSeptic] using he'.1
  have hB : 0 ≤ u^2+21*w/5 := by simpa [centeredSeptic] using he.2.1
  have hB' : 0 ≤ U^2+21*W/5 := by simpa [centeredSeptic] using he'.2.1
  have hZ : 0 ≤ -(2*s+2*u*w/7-4*v^2/35) := by
    simpa [centeredSeptic] using he.2.2.2.1
  have hZ' : 0 ≤ -(2*S+2*U*W/7-4*V^2/35) := by
    simpa [centeredSeptic] using he'.2.2.2.1
  have hAA : 0 ≤ u*U := by simpa only [neg_mul_neg] using mul_nonneg hA hA'
  have hZZ : 0 ≤ (2*s+2*u*w/7-4*v^2/35)*(2*S+2*U*W/7-4*V^2/35) := by
    simpa only [neg_mul_neg] using mul_nonneg hZ hZ'
  dsimp only
  refine ⟨?_, ?_, ?_, ?_⟩
  · simpa only [mul_assoc] using
      div_nonneg (mul_nonneg (by norm_num : (0 : ℝ) ≤ 7) hAA) (by norm_num : (0 : ℝ) ≤ 12)
  · exact div_nonneg (mul_nonneg (mul_nonneg (by norm_num) hB) hB') (by norm_num)
  · simpa only [mul_assoc] using
      div_nonneg (mul_nonneg (by norm_num : (0 : ℝ) ≤ 5) hZZ) (by norm_num : (0 : ℝ) ≤ 32)
  · norm_num [centeredSeptic] at hd
    convert hd using 1 <;> ring

private theorem coefficient_second_moment (r : Fin 7 → ℝ) :
    2 * (∏ i, (X - C (r i)) : ℝ[X]).coeff 5 =
      (∑ i, r i)^2 - ∑ i, (r i)^2 := by
  simp only [Fin.prod_univ_succ, Fin.sum_univ_succ, Fin.prod_univ_zero,
    Fin.sum_univ_zero, mul_one, add_zero]
  norm_num only [coeff_X_sub_C_mul, mul_coeff_zero, coeff_sub, coeff_X,
    coeff_C, ite_true, ite_false, zero_mul, mul_zero, one_mul, mul_one,
    zero_add, add_zero, sub_zero, zero_sub]
  ring

private theorem centered_zero (u v w t s z : ℝ)
    (hp : RealRooted7 (centeredSeptic u v w t s z)) (hu : u = 0) :
    centeredSeptic u v w t s z = X^7 := by
  obtain ⟨r, hr⟩ := hp
  have hc := root_sum_zero _ r hr (by simp [centeredSeptic])
  have hm := coefficient_second_moment r
  rw [← hr, hc] at hm
  have hsq : ∑ i, (r i)^2 = 0 := by
    norm_num [centeredSeptic, hu] at hm
    linarith only [hm]
  have heach := (Finset.sum_eq_zero_iff_of_nonneg (fun i _ => sq_nonneg (r i))).mp hsq
  have hz : ∀ i, r i = 0 := fun i => sq_eq_zero_iff.mp (heach i (Finset.mem_univ i))
  rw [hr]
  simp [hz]

theorem centered_real_rooted (u v w t s z U V W T S Z : ℝ)
    (hp : RealRooted7 (centeredSeptic u v w t s z))
    (hq : RealRooted7 (centeredSeptic U V W T S Z)) :
    RealRooted7 (square7 (centeredSeptic u v w t s z) (centeredSeptic U V W T S Z)) := by
  by_cases hu : u = 0
  · have hpzero := centered_zero u v w t s z hp hu
    have hv := congrArg (fun p : ℝ[X] => p.coeff 4) hpzero
    have hw := congrArg (fun p : ℝ[X] => p.coeff 3) hpzero
    have hs := congrArg (fun p : ℝ[X] => p.coeff 1) hpzero
    norm_num [centeredSeptic] at hv hw hs
    refine ⟨fun _ => 0, ?_⟩
    rw [centered_expansion]
    simp [hu, hv, hw, hs]
  by_cases hU : U = 0
  · have hqzero := centered_zero U V W T S Z hq hU
    have hV := congrArg (fun p : ℝ[X] => p.coeff 4) hqzero
    have hW := congrArg (fun p : ℝ[X] => p.coeff 3) hqzero
    have hS := congrArg (fun p : ℝ[X] => p.coeff 1) hqzero
    norm_num [centeredSeptic] at hV hW hS
    refine ⟨fun _ => 0, ?_⟩
    rw [centered_expansion]
    simp [hU, hV, hW, hS]
  obtain ⟨ha, hb, hc, hd⟩ := centered_data u v w t s z U V W T S Z hp hq
  obtain ⟨x, y, z', hx, hy, hz, hf⟩ :=
    D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeSix.cubic_nonnegative_factorization
      _ _ _ ha hb hc hd
  have heven := congrArg (fun p : ℝ[X] => p.comp (X^2)) hf
  simp only [sub_comp, add_comp, mul_comp, pow_comp, X_comp, C_comp,
    ← pow_mul, Nat.reduceMul] at heven
  refine ⟨![0, Real.sqrt x, -Real.sqrt x, Real.sqrt y, -Real.sqrt y,
    Real.sqrt z', -Real.sqrt z'], ?_⟩
  rw [centered_expansion]
  have hxC : (C (Real.sqrt x) : ℝ[X])^2 = C x := by rw [← map_pow, Real.sq_sqrt hx]
  have hyC : (C (Real.sqrt y) : ℝ[X])^2 = C y := by rw [← map_pow, Real.sq_sqrt hy]
  have hzC : (C (Real.sqrt z') : ℝ[X])^2 = C z' := by rw [← map_pow, Real.sq_sqrt hz]
  calc
    _ = X * (X^6-C (7*u*U/12)*X^4+
        C (5*(u^2+21*w/5)*(U^2+21*W/5)/294)*X^2-
        C (5*(2*s+2*u*w/7-4*v^2/35)*(2*S+2*U*W/7-4*V^2/35)/32)) := by ring
    _ = X * ((X^2-C x)*(X^2-C y)*(X^2-C z')) := by rw [heven]
    _ = X * ((X^2-(C (Real.sqrt x))^2)*(X^2-(C (Real.sqrt y))^2)*
        (X^2-(C (Real.sqrt z'))^2)) := by rw [hxC, hyC, hzC]
    _ = _ := by simp [Fin.prod_univ_succ]; ring

private theorem exists_septic (p : ℝ[X]) (hp : RealRooted7 p) :
    ∃ a u v w t s z : ℝ, p = septic a u v w t s z := by
  obtain ⟨r, hr⟩ := hp
  have hm : p.Monic := hr ▸ monic_prod_X_sub_C r Finset.univ
  have hn : p.natDegree = 7 := by
    rw [hr, natDegree_prod_of_monic _ _ (fun i _ => monic_X_sub_C (r i))]
    simp
  have hc : p.coeff 7 = 1 := by rw [← hn]; exact hm.coeff_natDegree
  refine ⟨p.coeff 6, p.coeff 5, p.coeff 4, p.coeff 3, p.coeff 2, p.coeff 1, p.coeff 0, ?_⟩
  calc
    p = ∑ i ∈ Finset.range (7+1), C (p.coeff i)*X^i :=
      p.as_sum_range_C_mul_X_pow' (by omega)
    _ = _ := by norm_num [Finset.sum_range_succ, hc, septic]; ring

private theorem septic_translate (a u v w t s z h : ℝ) :
    (septic a u v w t s z).comp (X+C h) =
      septic (a+7*h) (u+6*a*h+21*h^2) (v+5*u*h+15*a*h^2+35*h^3)
        (w+4*v*h+10*u*h^2+20*a*h^3+35*h^4)
        (t+3*w*h+6*v*h^2+10*u*h^3+15*a*h^4+21*h^5)
        (s+2*t*h+3*w*h^2+4*v*h^3+5*u*h^4+6*a*h^5+7*h^6)
        (z+s*h+t*h^2+w*h^3+v*h^4+u*h^5+a*h^6+h^7) := by
  simp [septic, map_add, map_mul, map_pow, map_ofNat]
  ring

private theorem real_rooted_translate (p : ℝ[X]) (hp : RealRooted7 p) (h : ℝ) :
    RealRooted7 (p.comp (X+C h)) := by
  obtain ⟨r, hr⟩ := hp
  refine ⟨fun i => r i-h, ?_⟩
  rw [hr, Polynomial.prod_comp]
  apply Finset.prod_congr rfl
  intro i _
  simp [map_sub]
  ring

theorem symmetrize_translation (p : ℝ[X]) (hp : RealRooted7 p) (h : ℝ) :
    symmetrize 7 (p.comp (X+C h)) = symmetrize 7 p := by
  obtain ⟨a, u, v, w, t, s, z, rfl⟩ := exists_septic p hp
  rw [septic_translate, symmetrize_septic, symmetrize_septic]
  congr 1 <;> ring

private theorem centered_representative (p : ℝ[X]) (hp : RealRooted7 p) :
    ∃ u v w t s z : ℝ, RealRooted7 (centeredSeptic u v w t s z) ∧
      symmetrize 7 (centeredSeptic u v w t s z) = symmetrize 7 p := by
  obtain ⟨a, u, v, w, t, s, z, rfl⟩ := exists_septic p hp
  have hr := real_rooted_translate _ hp (-a/7)
  have hs := symmetrize_translation _ hp (-a/7)
  rw [septic_translate] at hr hs
  have ha : a+7*(-a/7) = 0 := by ring
  rw [ha] at hr hs
  simp only [septic, C_0, zero_mul, add_zero] at hr hs
  exact ⟨_, _, _, _, _, _, hr, hs⟩

macro "septic_bind_finish " p:term:max q:term:max hp:term:max hq:term:max : tactic =>
  `(tactic| (
    obtain ⟨u, v, w, t, s, z, hp', hsp⟩ := centered_representative $p $hp
    obtain ⟨U, V, W, T, S, Z, hq', hsq⟩ := centered_representative $q $hq
    have h := centered_real_rooted u v w t s z U V W T S Z hp' hq'
    simpa only [square7, hsp, hsq] using h))

/-- CMP Conjecture 5.3 at degree seven, including zero and repeated roots. -/
theorem real_rooted (p q : ℝ[X]) (hp : RealRooted7 p) (hq : RealRooted7 q) :
    RealRooted7 (square7 p q) := by
  septic_bind_finish p q hp hq

/--
error: The tactic provided to `fail_if_success` succeeded but was expected to fail:
  septic_bind_finish p q hp hq
-/
#guard_msgs (error) in
example (p q : ℝ[X]) (hp : RealRooted7 p) (hq : RealRooted7 q) :
    RealRooted7 (square7 p q) := by
  fail_if_success septic_bind_finish p q hp hq

#print axioms commutatorKernel_seven
#print axioms centered_expansion
#print axioms centered_data
#print axioms coefficient_second_moment
#print axioms centered_zero
#print axioms centered_real_rooted
#print axioms symmetrize_translation
#print axioms centered_representative
#print axioms real_rooted
#check real_rooted

end SepticAssemblyBindProbe
```
