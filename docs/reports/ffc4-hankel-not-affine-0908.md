# FFC 输出的 Newton–Hankel **不是**输入 Hankel 的分别仿射函数(degree 4 反例)

**判形**:`bind-only`。`escape_witness: none`。按 CLAUDE.md 第 5⁴ 条停手,不建模块、不 deposit。

**产地**:`consensus-rnd:sshx`;实施席 1 席 codex-cli(`ffc4-noaffine-0908`,1,883s),**零独立评审席**。
本文件由 orchestrator 写入;**orchestrator 未重跑其 Lean 构建**。
**orchestrator 独立亲验的部分**:输入侧中点恒等式(精确有理,k = 0..6)、
三个输出多项式的代入、`H(2,2)` 三个值、以及验收数 `−92/225`。
该席的 Lean 证明把中点恒等式**加强到 `∀ k : ℕ`(含 k = 0)**,超出我复算的范围。

## 已证的陈述

```lean
def AffineHankelTransfer : Prop := …   -- 见下方源码
theorem ffc4_hankel_not_affine : ¬ AffineHankelTransfer
```

**不存在**与输入无关、**对每个变量分别仿射**的映射 `T`,使
`newtonHankel (square₄ p q) = T (moments p) (moments q)`
对所有中心化实根四次 `p, q` 成立。

## 形式化的三个设计判断(该席自报,逐条照录)

| 面 | 取法 | 理由 |
|---|---|---|
| **输入空间** | **完整**归一化原始矩序列 `ℕ → ℝ` | **任意有限 Hankel 截断都是完整矩序列的固定线性投影** ⟹ 障碍不是「矩取少了」 |
| **分别仿射** | 固定第二输入后,`T` 的第一偏应用是 Mathlib `AffineMap`(反之亦然) | Schur 积、矩阵乘积、固定张量压缩之和**都是双线性的**,故每个偏应用线性 ⟹ 仿射;固定线性坐标映射与固定仿射修正保持分别仿射 |
| **输出面** | 保留 `(2,2)` 处的四阶矩 | 该席明写:**对丢弃该项的输出截断不作不可能性断言** |

## 反例(三个中心化输入,全部合法,含零根与重根)

```
p₀  = X⁴          根 0,0,0,0        μ₀  = δ₀
p₁  = (X²−1)²     根 1,1,−1,−1      μ₁  = ½(δ₋₁+δ₁)
p_½ = X²(X²−1)    根 0,0,1,−1       μ_½ = ½μ₀ + ½μ₁
q   = p₁
```

**输入侧中点恒等式**(该席 Lean 证到 `∀ k : ℕ`;orchestrator 另用精确有理独立复算 k = 0..6):

```
H(p_½) = ½·H(p₀) + ½·H(p₁)
归一化矩 k=0..6:  p₀ (1,0,0,0,0,0,0)   p₁ (1,0,1,0,1,0,1)   p_½ (1,0,½,0,½,0,½)
```

用冻结的 `FiniteFreeCommutatorDegreeFour.centered_expansion`
(`square₄ = X⁴ − (16uU/15)X² + (u²+12w)(U²+12W)/60`)算输出:

| | 输出 | `Σρ⁴ = 2a²−4b` | `H(2,2)`(仓内 `rootPowerMoment` 除以 `d = 4`) |
|---|---|---|---|
| `S₀` | `X⁴` | `0` | `0` |
| `S₁` | `X⁴ − (64/15)X² + 64/15` | `4352/225` | `1088/225` |
| `S_½` | `X⁴ − (32/15)X² + 4/15` | `1808/225` | `452/225` |

中点应为 `½(0 + 1088/225) = 544/225`,实际 `452/225`:

```
H(S_½)₂,₂ − ½H(S₀)₂,₂ − ½H(S₁)₂,₂  =  −92/225  ≠  0
```

固定 `q` 后,分别仿射性要求保留输入侧的中点;上式违反它,故 `T` 不存在。
**该结论不需要先假定 `T` 保正** —— 连分别仿射的精确表达式都不存在。

## 处决范围(**精确,不得夸大**)

**被排除**(及其经**固定**线性变换、**固定**仿射修正得到的形式):

```
H(p) ∘ H(q)                       Schur 积
H(p) · H(q)                       矩阵乘积
Σ_α C_α (H(p) ⊗ H(q)) C_αᵀ        固定张量压缩(C_α 不依赖 p, q)
```

**没有被排除**(该席逐条复述并确认其定理**未**声称排除它们):

1. 含 `s₂(p)²` 等**非线性坐标**的提升;
2. 先做 `symmetrize` 之后的矩阵对象;
3. **依赖输入的**压缩矩阵。

**「先中心化」不能作逃生口** —— 本例的三个输入已全部中心化。

## 结构解释

系数层的**对角乘积**结构不会自动变成矩层的 **Schur 乘积**结构,
因为 **Newton 变换会引入同一输入内部的非线性项**。

## 判形与用途(该席的分析,未落地)

`bind-only`;整条论证由钉版 Mathlib + 冻结的 `centered_expansion` / `rootPowerMoment` / `newtonHankel`
+ 规范化改写闭合,`escape_witness: none`。

该席分析了两种 utility 形态并给出**若要 deposit 时的**选择:
`kind=certified-instance; basis=refutes=gid:<AffineHankelTransfer>; claim=<AffineHankelTransfer>; result=<ffc4_hankel_not_affine>`
(一个闭合 `Prop` claim + 一个公开闭合定理,其类型恰为 `Not claim`)。
**但头部未创建** —— bind-only 的停手条件在任何永久模块之前触发。`pr: null`,零仓库改动。

## 未做 / 边界

- 下列源码**不在** `Golden/Frozen/**`,**不是**冻结真值;
- **无独立评审**;
- **不主张文献新颖性**;
- 本文件**不**声称排除上节「没有被排除」的三类路线。

## 逐字源码(run-local 探针)

```lean
import D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
import D5.S3.Constants.NewtonHankelRealRootCriterion
import Mathlib.LinearAlgebra.AffineSpace.Midpoint

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace FFC4BindOnlyProbe

open Polynomial
open scoped BigOperators
open D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
open D5.S3.Constants.NewtonHankelRealRootCriterion

abbrev Moments := Nat → ℝ
abbrev Hankel4 := Matrix (Fin 4) (Fin 4) ℝ

def moments (r : Fin 4 → ℝ) : Moments :=
  rootPowerMoment (fun i => (r i : ℂ))

def hankel (r : Fin 4 → ℝ) : Hankel4 :=
  newtonHankel (fun i => (r i : ℂ))

def AffineHankelTransfer : Prop :=
  ∃ T : Moments → Moments → Hankel4,
    (∀ y, ∃ A : Moments →ᵃ[ℝ] Hankel4, ∀ x, A x = T x y) ∧
    (∀ x, ∃ A : Moments →ᵃ[ℝ] Hankel4, ∀ y, A y = T x y) ∧
    ∀ (u v w U V W : ℝ) (r t s : Fin 4 → ℝ),
      centeredQuartic u v w = ∏ i, (X - C (r i)) →
      centeredQuartic U V W = ∏ i, (X - C (t i)) →
      square4 (centeredQuartic u v w) (centeredQuartic U V W) =
        ∏ i, (X - C (s i)) →
      hankel s = T (moments r) (moments t)

private theorem fourth_moment (u v w : ℝ) (r : Fin 4 → ℝ)
    (hr : centeredQuartic u v w = ∏ i, (X - C (r i))) :
    hankel r 2 2 = u^2 / 2 - w := by
  have hc := congrArg (fun p : ℝ[X] => p.coeff 3) hr
  have hu := congrArg (fun p : ℝ[X] => p.coeff 2) hr
  have hw := congrArg (fun p : ℝ[X] => p.coeff 0) hr
  norm_num [centeredQuartic, Fin.prod_univ_succ, coeff_mul,
    Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk, Finset.sum_range_succ,
    coeff_add, coeff_sub, coeff_X_pow, coeff_X, coeff_C, Fin.succ] at hc hu hw
  change 0 = -r 0 + (-r 1 + (-r 2 + -r 3)) at hc
  change u = -(r 0 * (-r 1 + (-r 2 + -r 3))) +
    (-(r 1 * (-r 2 + -r 3)) + r 2 * r 3) at hu
  change w = r 0 * (r 1 * (r 2 * r 3)) at hw
  have hc' : r 3 = -r 0 - r 1 - r 2 := by linarith only [hc]
  rw [hc'] at hu hw
  simp only [hankel, newtonHankel, rootPowerMoment]
  norm_num [Fin.sum_univ_succ, ← Complex.ofReal_pow, Complex.add_re, Fin.succ]
  change (r 0^4 + (r 1^4 + (r 2^4 + r 3^4)))/4 = u^2/2-w
  rw [hc', hu, hw]
  ring

private theorem input_midpoint :
    moments ![0, 0, 1, -1] =
      midpoint ℝ (moments ![0, 0, 0, 0]) (moments ![1, 1, -1, -1]) := by
  funext k
  simp only [midpoint_eq_smul_add, Pi.smul_apply, Pi.add_apply, smul_eq_mul]
  norm_num [moments, rootPowerMoment, Fin.sum_univ_succ, Complex.add_re,
    ← Complex.ofReal_pow, Fin.succ]
  ring

private theorem output_entry (u v w : ℝ) (r : Fin 4 → ℝ)
    (hr : centeredQuartic u v w = ∏ i, (X - C (r i))) :
    ∃ s : Fin 4 → ℝ,
      square4 (centeredQuartic u v w) (centeredQuartic (-2) 0 1) =
        ∏ i, (X - C (s i)) ∧
      hankel s 2 2 = (32*u/15)^2 / 2 - (u^2+12*w)*16/60 := by
  have hq : RealRooted4 (centeredQuartic (-2) 0 1) := by
    refine ⟨![1, 1, -1, -1], ?_⟩
    norm_num [centeredQuartic, Fin.prod_univ_succ, map_ofNat]
    ring
  obtain ⟨s, hs⟩ := centered_real_rooted u v w (-2) 0 1 ⟨r, hr⟩ hq
  refine ⟨s, hs, ?_⟩
  have hexp :
      square4 (centeredQuartic u v w) (centeredQuartic (-2) 0 1) =
        centeredQuartic (32*u/15) 0 ((u^2+12*w)*16/60) := by
    rw [centered_expansion]
    have hc : 16*u*(-2)/15 = -(32*u/15) := by ring
    rw [hc, map_neg, neg_mul, sub_neg_eq_add]
    norm_num [centeredQuartic]
  rw [hexp] at hs
  exact fourth_moment _ _ _ _ hs

theorem ffc4_hankel_not_affine : ¬ AffineHankelTransfer := by
  rintro ⟨T, hleft, -, hT⟩
  have hp0 : centeredQuartic 0 0 0 = ∏ i : Fin 4, (X - C (![0, 0, 0, 0] i)) := by
    norm_num [centeredQuartic, Fin.prod_univ_succ, map_ofNat]
    ring
  have hp1 : centeredQuartic (-2) 0 1 = ∏ i : Fin 4, (X - C (![1, 1, -1, -1] i)) := by
    norm_num [centeredQuartic, Fin.prod_univ_succ, map_ofNat]
    ring
  have hph : centeredQuartic (-1) 0 0 = ∏ i : Fin 4, (X - C (![0, 0, 1, -1] i)) := by
    norm_num [centeredQuartic, Fin.prod_univ_succ, map_ofNat]
    ring
  obtain ⟨s0, hs0, he0⟩ := output_entry 0 0 0 _ hp0
  obtain ⟨s1, hs1, he1⟩ := output_entry (-2) 0 1 _ hp1
  obtain ⟨sh, hsh, heh⟩ := output_entry (-1) 0 0 _ hph
  norm_num at he0 he1 heh
  have hdefect :
      hankel sh 2 2 - (hankel s0 2 2 + hankel s1 2 2)/2 = -(92/225 : ℝ) := by
    rw [he0, he1, heh]
    norm_num
  obtain ⟨A, hA⟩ := hleft (moments ![1, 1, -1, -1])
  have hmid := A.map_midpoint (moments ![0, 0, 0, 0]) (moments ![1, 1, -1, -1])
  rw [← input_midpoint, hA, hA, hA,
    ← hT _ _ _ _ _ _ _ _ _ hph hp1 hsh,
    ← hT _ _ _ _ _ _ _ _ _ hp0 hp1 hs0,
    ← hT _ _ _ _ _ _ _ _ _ hp1 hp1 hs1] at hmid
  have hentry := congrArg (fun H : Hankel4 => H 2 2) hmid
  norm_num [midpoint_eq_smul_add] at hentry
  linarith only [hentry, hdefect]

#print axioms fourth_moment
#print axioms input_midpoint
#print axioms output_entry
#print axioms ffc4_hankel_not_affine

end FFC4BindOnlyProbe
```
