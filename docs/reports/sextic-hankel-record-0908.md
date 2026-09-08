# 六次矩 Hankel 矩阵:半正定与行列式恒等式(内核验证记录)

## 产地

skill=`consensus-rnd:sshx`;实施席 1 席 codex-cli(`sextic-hankel-0908`,2,803s),
**零独立评审席**。本文件由 orchestrator(claude 主循环)写入,内容为该席交回的
run-local 探针源码与读数;**orchestrator 未重跑其构建**,该席自报 `make lean EXIT=0`。

## 为什么留这份记录而不是模块

该席判词为 **`bind-only`**:三条目标全部由钉版 Mathlib 实例化 + 规范化改写得到
(`Matrix.posSemidef_conjTranspose_mul_self` 一族 + 定义展开 + `ring`),
**无逃逸见证**。按第 5⁴ 条,bind-only 陈述不得单独首次冻结,而本轮**没有内容宿主**可挂靠,
故按硬要求 #1 停手:不建模块、不 deposit、不 cover。

但这些事实是 **Mu–Welker 线被点名的下一个对象**:探针席 `muwelker-deg6-probe-0908` 证明了
仓内已冻结的 `(A,B,Z)` 标量面**结构上不够** —— 族 `f_N(t)=(1+Nt)⁶` 的每个成员都有
`A=B=Z=0`,而其 canonical decomposition 的 `g₁=6N−1` 无界。它给出的替代对象正是下面这个
Hankel 矩阵。**故把内核验证过的源码逐字留档,待出现内容宿主时可直接抬进模块。**

## 关键读数(该席自报,均在其 run-local 探针中内核验证)

- **① 与 ② 都不需要中心化**:对任意 `r : Fin 6 → ℝ` 成立。
- **③ 内核验证了上游探针给的 SymPy 表达式全部正确**(`changed: false`):
  12 项行列式与 2×2 主子式逐字无误。
- **三个校准点**:
  - `(X²−C(h²))³` ⟹ `det = 0`;
  - `(X²−C(h²))³ − C K·X` ⟹ `det = −150·h²·K²`,故 `h>0` 时 `det ≥ 0` 强制 `K=0`;
    `h=1, K=144` 时 `det = −3110400`;
  - `X⁶ − X` ⟹ `det = 0` 但 `P₄P₆−P₅² = −25` ⟹ **行列式非负 ≠ 完整 PSD 条件**。
- **不主张文献新颖性**:Gram 半正定与 Cauchy–Binet 是标准事实;本记录的价值是**仓内可用**。

## 内核验证过的源码(逐字)

```lean
import D5.S3.Zeros.CoefficientBounds.SexticEnvelope
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Algebra.Order.Star.Real
import Mathlib.Tactic

/- Run-local bind-only probe. This file is removed before delivery. -/
noncomputable section
open Matrix Polynomial
namespace SexticHankelProbe

def moment (r : Fin 6 → ℝ) (k : ℕ) : ℝ := ∑ i, (r i)^k

def hankel (r : Fin 6 → ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![moment r 2, moment r 3, moment r 4;
     moment r 3, moment r 4, moment r 5;
     moment r 4, moment r 5, moment r 6]

theorem hankel_posSemidef (r : Fin 6 → ℝ) : (hankel r).PosSemidef := by
  let M : Matrix (Fin 6) (Fin 3) ℝ := Matrix.of fun k i => (r k)^(i.val + 1)
  have h : hankel r = Mᴴ * M := by
    ext i j
    rw [Matrix.mul_apply]
    fin_cases i <;> fin_cases j <;>
      norm_num [hankel, moment, M, Matrix.conjTranspose_apply, Fin.sum_univ_succ,
        Matrix.cons_val_two] <;> ring
  rw [h]
  exact Matrix.posSemidef_conjTranspose_mul_self M

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
theorem hankel_det_roots (r : Fin 6 → ℝ) :
    (hankel r).det =
      ∑ i : Fin 6, ∑ j : Fin 6, ∑ k : Fin 6,
        if i < j ∧ j < k then
          (r i * r j * r k)^2 * (r i - r j)^2 *
            (r i - r k)^2 * (r j - r k)^2
        else 0 := by
  norm_num only [hankel, moment, Matrix.det_fin_three, Fin.sum_univ_succ,
    Fin.sum_univ_zero, Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons, Fin.lt_def, Fin.val_succ,
    Fin.val_zero, Fin.val_one, Fin.coe_ofNat_eq_mod, and_true, true_and, and_false,
    false_and, ite_true, ite_false, add_zero, zero_add]
  ring

def coefficientHankel (u v w q s : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![-2*u, -3*v, 2*u^2 - 4*w;
     -3*v, 2*u^2 - 4*w, -5*q + 5*u*v;
     2*u^2 - 4*w, -5*q + 5*u*v, -6*s - 2*u^3 + 6*u*w + 3*v^2]

theorem determinant_symbolic (u v w q s : ℝ) :
    (coefficientHankel u v w q s).det =
      50*q^2*u - 40*q*u^2*v - 120*q*v*w + 24*s*u^3 - 48*s*u*w + 54*s*v^2 +
      8*u^4*w - 4*u^3*v^2 - 48*u^2*w^2 + 90*u*v^2*w - 27*v^4 + 64*w^3 := by
  norm_num [coefficientHankel, Matrix.det_fin_three, Matrix.cons_val_two]
  ring

theorem principal_minor_symbolic (u v w q s : ℝ) :
    (2*u^2 - 4*w) * (-6*s - 2*u^3 + 6*u*w + 3*v^2) - (-5*q + 5*u*v)^2 =
      -25*q^2 + 50*q*u*v - 12*s*u^2 + 24*s*w - 4*u^5 + 20*u^3*w -
        19*u^2*v^2 - 24*u*w^2 - 12*v^2*w := by
  ring

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
theorem power_moments_of_coefficients (r : Fin 6 → ℝ) (hcenter : ∑ i, r i = 0) :
    let p : ℝ[X] := ∏ i, (X - C (r i))
    let u := p.coeff 4
    let v := p.coeff 3
    let w := p.coeff 2
    let q := p.coeff 1
    let s := p.coeff 0
    moment r 2 = -2*u ∧ moment r 3 = -3*v ∧ moment r 4 = 2*u^2 - 4*w ∧
      moment r 5 = -5*q + 5*u*v ∧ moment r 6 = -6*s - 2*u^3 + 6*u*w + 3*v^2 := by
  have hc : r 0 + r 1 + r 2 + r 3 + r 4 + r 5 = 0 := by
    simpa [Fin.sum_univ_succ, add_assoc] using hcenter
  have h5 : r (2 : Fin 3).succ.succ.succ =
      -(r 0 + r 1 + r 2 + r (2 : Fin 5).succ + r (2 : Fin 4).succ.succ) := by
    change r 5 = -(r 0 + r 1 + r 2 + r 3 + r 4)
    linarith only [hc]
  dsimp only
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;>
    norm_num [moment, Fin.sum_univ_succ, Fin.prod_univ_succ, coeff_mul,
      Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk, Finset.sum_range_succ,
      coeff_sub, coeff_X, coeff_C] <;> rw [h5] <;> ring

theorem hankel_coefficient_form (r : Fin 6 → ℝ) (hcenter : ∑ i, r i = 0) :
    let p : ℝ[X] := ∏ i, (X - C (r i))
    hankel r = coefficientHankel (p.coeff 4) (p.coeff 3) (p.coeff 2) (p.coeff 1)
      (p.coeff 0) := by
  dsimp only
  obtain ⟨h2, h3, h4, h5, h6⟩ := power_moments_of_coefficients r hcenter
  simp only [hankel, coefficientHankel, h2, h3, h4, h5, h6]

theorem coefficient_hankel_posSemidef (r : Fin 6 → ℝ) (hcenter : ∑ i, r i = 0) :
    let p : ℝ[X] := ∏ i, (X - C (r i))
    (coefficientHankel (p.coeff 4) (p.coeff 3) (p.coeff 2) (p.coeff 1)
      (p.coeff 0)).PosSemidef := by
  dsimp only
  rw [← hankel_coefficient_form r hcenter]
  exact hankel_posSemidef r

theorem balanced_calibration (h : ℝ) :
    (coefficientHankel (-3*h^2) 0 (3*h^4) 0 (-h^6)).det = 0 := by
  rw [determinant_symbolic]
  ring

theorem perturbation_calibration (h K : ℝ) :
    (coefficientHankel (-3*h^2) 0 (3*h^4) (-K) (-h^6)).det = -150*h^2*K^2 := by
  rw [determinant_symbolic]
  ring

theorem perturbation_numeric :
    (coefficientHankel (-3) 0 3 (-144) (-1)).det = -3110400 := by
  rw [determinant_symbolic]
  norm_num

theorem minor_counterexample_calibration :
    (coefficientHankel 0 0 0 (-1) 0).det = 0 ∧
      (2*(0:ℝ)^2 - 4*0) * (-6*0 - 2*0^3 + 6*0*0 + 3*0^2) -
        (-5*(-1) + 5*0*0)^2 = -25 := by
  rw [determinant_symbolic]
  norm_num

theorem perturbation_polynomial_coefficients (h K : ℝ) :
    let p : ℝ[X] := (X^2 - C (h^2))^3 - C K * X
    coefficientHankel (p.coeff 4) (p.coeff 3) (p.coeff 2) (p.coeff 1) (p.coeff 0) =
      coefficientHankel (-3*h^2) 0 (3*h^4) (-K) (-h^6) := by
  have hp : (X^2 - C (h^2) : ℝ[X])^3 - C K * X =
      X^6 - C (3*h^2)*X^4 + C (3*h^4)*X^2 - C (h^6) - C K * X^1 := by
    simp only [map_mul, map_ofNat, map_pow]
    ring
  dsimp only
  rw [hp]
  simp only [coeff_add, coeff_sub, coeff_C_mul_X_pow, coeff_X_pow, coeff_C]
  norm_num

theorem perturbation_forces_zero (h K : ℝ) (hh : 0 < h)
    (hdet : 0 ≤ (coefficientHankel (-3*h^2) 0 (3*h^4) (-K) (-h^6)).det) : K = 0 := by
  rw [perturbation_calibration] at hdet
  have hh2 : 0 < h^2 := sq_pos_of_pos hh
  have hK2 : K^2 = 0 := by nlinarith only [hdet, hh2, sq_nonneg K]
  nlinarith only [hK2, sq_nonneg K]

#print axioms hankel_posSemidef
#print axioms hankel_det_roots
#print axioms determinant_symbolic
#print axioms principal_minor_symbolic
#print axioms power_moments_of_coefficients
#print axioms hankel_coefficient_form
#print axioms coefficient_hankel_posSemidef
#print axioms balanced_calibration
#print axioms perturbation_calibration
#print axioms perturbation_numeric
#print axioms minor_counterexample_calibration
#print axioms perturbation_polynomial_coefficients
#print axioms perturbation_forces_zero
end SexticHankelProbe
```

## 未做

- 未建仓内模块、未 deposit、未 cover;上述定理**不在** `Golden/Frozen/**` 中,**不是**冻结真值。
- 无独立评审;判形(bind-only)与内核结果均由该实施席单点自报,orchestrator 未复跑。
