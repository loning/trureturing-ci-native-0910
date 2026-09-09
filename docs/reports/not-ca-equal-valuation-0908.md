# 等指数 2-3 传递:`v₂(n) = v₃(n) = a ≥ 3` 的 `n` 不是 colossally abundant

**判形**:`bind-only`。`escape_witness: none`;`admission_basis: none(no deposit)`。
按 CLAUDE.md 第 5⁴ 条,bind-only 陈述不得单独首次冻结,且本轮**没有内容宿主**可挂靠,故停手留档。

**产地**:`consensus-rnd:sshx`;实施席 1 席 codex-cli(`not-ca-2adic-0908`,1,287s),**零独立评审席**。
本文件由 orchestrator 写入,内容为该席交回的 run-local 探针源码与读数;
**orchestrator 未重跑其构建**,该席自报 Lean LSP `exit 0`、`error_diagnostics: 0`、标准三公理闭包。

## 为什么留档

源码只存在于临时目录,会随之消失 —— 而它是一条活研究线被点名的对象:

- 它是 **#6377 深度推理线 L4** 的**否定部分**:L4 主张存在序列 `N_j = P(2^j)^j` 使
  `Δ(N_j) → 0` 而**每项都不是 CA**,从而处决「近极值取到序列必然逐项属于 CA」这一推断。
  `N_j` 恰好满足 `v₂ = v₃ = j`,故本终点一旦成立,L4 的否定部分即闭合。
- 它与 **L3**(「任意固定素数的有界指数留下严格正的渐近 Robin 余量」)互补:
  两条合起来给出正确区分 —— **近极值强制局部素数层饱和,但不强制精确的全局价格最优**。
  L3 若做成内容模块,本条可作其**具名伴随声明**落地(第 5⁴ 条 (b) 出路)。

## 已证的陈述

```
n a : ℕ,  0 < n,  n.factorization 2 = a,  n.factorization 3 = a,  3 ≤ a
⟹ 令 m := 2 * n / 3,则
     0 < m,  m < n,  (σ₁ n : ℝ)/n < (σ₁ m : ℝ)/m,
     且 ∀ λ > 0,  goldenResourceObjective λ n < goldenResourceObjective λ m,
   从而 ¬ IsColossallyAbundant n。
```

**作用域**:全部满足该赋值条件的正整数 `n`;**不限制其它素因子**;**无序列极限断言**。

## 仓内 CA 定义(该席亲读,逐字)

```lean
-- D5/S3/Arith/GoldenResource/GoldenResourcePriceInterval.lean:96
def IsColossallyAbundant (n : ℕ) : Prop :=
  ∃ lambda : ℝ, 0 < lambda ∧ IsGoldenResourceOptimal lambda n

-- D5/S3/Arith/GoldenResource/GoldenResourceThresholdCriterion.lean:47
def IsGoldenResourceOptimal (lambda : ℝ) (n : ℕ) : Prop :=
  ∀ m : ℕ, 1 ≤ m → goldenResourceObjective lambda m ≤ goldenResourceObjective lambda n

-- D5/S3/Arith/GoldenResourceOptimalInteger.lean:22
noncomputable def goldenResourceObjective (lambda : ℝ) (n : ℕ) : ℝ :=
  Real.log (∑ d ∈ n.divisors, (d : ℝ)⁻¹) - lambda * Real.log n
```

⟹ CA 要求**在某个正价格 λ 下全局最大化** `log Z(n) − λ log n`,**不是**仅要求 `R(n)` 接近 1。
既然 `m < n` 且 `Z(m) > Z(n)`,则该目标在**每个** `λ > 0` 处都被 `m` 严格改进。

## 关键代数(orchestrator 与该席**各自独立**复算,结论一致)

`Z` 乘性,局部因子 `f_p(k) = σ(p^k)/p^k = (1 − p^{−(k+1)})/(1 − p^{−1})`。
`n → 2n/3` 只改 2 与 3 的指数(`a → a+1`,`a → a−1`),故

```
Z(2n/3)/Z(n) = R(a) = [f₂(a+1)/f₂(a)] · [f₃(a−1)/f₃(a)]
```

令 `u = 2^{a+1}`、`v = 3^{a+1}`,该席给出

```
R(a) − 1 = (v + 1 − 4u) / (2(u−1)(v−1)),   分母为正
⟹ R(a) > 1  ⟺  3^{a+1} + 1 > 4 · 2^{a+1}
```

**`a ≥ 3` 是锐条件**(orchestrator 精确有理复算,该席独立复核一致,`all_supplied_values_match: true`):

| a | `R(a) − 1` | |
|---:|---|---|
| 1 | **−1/8** | **不成立** |
| 2 | **−1/91** | **不成立** |
| 3 | +3/400 | 成立 |
| 4 | +29/3751 | 成立(最大) |
| 5 | +79/15288 | |
| 6 | +419/138811 | |
| 7 | +923/557600 | |
| 8 | +4409/5028751 | |
| 12 | +390389/6529545751 | |

`R(a) − 1 → 0`,故**不能靠数值或有限枚举**。该席明确 `used_as_proof: false` —— 上表只作核对,不进证明。

**收尾比预期简洁,不需要归纳**:令 `b = a − 3`,由 `2^b ≤ 3^b` 与 `0 < 2^b`,
所需表达式 `81·3^b + 1 − 64·2^b ≥ 17·2^b + 1 > 0`,`linarith only` 直接闭合。

## 消费的冻结件(该席读了状态片与 accepted 事件)

| GID | statement_id | 消费者 |
|---|---|---|
| `D5/S3/Arith/GoldenResourceObjectiveFactorization.golden_resource_objective_sum_on` | `sha256:a656df780668a8d8…` | `transfer_log_gain` |
| `D5/S3/Arith/GoldenResourceOptimalInteger.golden_resource_sigma_identity` | `sha256:cc1b03bcb9ef0de5…` | `bind_only_endpoint` |

## 撞题检查(带阳性对照)

```
git grep -n -P '¬\s*IsColossallyAbundant|\b(?:not_colossally\w*|not_ca|equal_valuations|equal_exponents|two_three_transfer)\b' -- D5/S3/Arith/GoldenResource
  ⟹ 0 命中 (exit 1)

阳性对照(同一 -P + \b 特性):
git grep -n -P '\bdef\s+IsColossallyAbundant\b' -- D5/S3/Arith/GoldenResource
  ⟹ 1 命中:GoldenResourcePriceInterval.lean:96 (exit 0)
```

## anchor atom:**没有**

该席按 CAS 搜了 5040 卷 **1611 条** backfill 条目,关键词命中 167 行 / 95 文件,
其中 17 行 / 15 个 CAS 文件为宽口径候选,**逐条读后均非本终点**
(它们讲的是其它非 CA 例子、邻接关系与层陈述)。`selected: null`,`coverage_action: none`。

⟹ **无 atom 可 cover** ⟹ 第 5⁴ 条的 (a) 出路不通;(b) 需内容宿主,本轮没有;
(c) 换 Γ 需连续两次 bind-only,本线这是第一次。**故留档。**

## 未做 / 边界

- **不新增任何 Lean 声明、不 deposit、不 cover、不触冻结面**;
- 下列源码**不在** `Golden/Frozen/**`,**不是**冻结真值,本文件不作此主张;
- **无独立评审**;判形与内核结果均由该实施席单点自报,orchestrator 只独立复算了代数与数值部分;
- L4 的**另一半**(显式序列 `N_j = P(2^j)^j` 使 `Δ(N_j) → 0`)**未证** ——
  该席明确它需要重建四条 `private` companion,是另一单。

## 逐字源码(run-local 探针,`Lean LSP exit 0`,`error_diagnostics: 0`)

```lean
import D5.S3.Arith.GoldenResource.GoldenResourcePriceInterval
import Mathlib.Tactic

open Finset
open D5.S3.Arith.GoldenResourceOptimalInteger
open D5.S3.Arith.GoldenLocalThreshold
open D5.S3.Arith.GoldenResourceObjectiveFactorization
open D5.S3.Arith.GoldenResource.GoldenResourceThresholdCriterion
open D5.S3.Arith.GoldenResource.GoldenResourcePriceInterval

-- Restricted probe: library instantiation and normalization, without induction.
theorem power_comparison (a : ℕ) (ha : 3 ≤ a) :
    4 * (2 : ℝ) ^ (a + 1) < 3 ^ (a + 1) + 1 := by
  have hle := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 2)
    (by norm_num : (2 : ℝ) ≤ 3) (a - 3)
  have hpos := pow_pos (by norm_num : (0 : ℝ) < 2) (a - 3)
  have he : a + 1 = (a - 3) + 4 := by omega
  rw [he, pow_add, pow_add]
  norm_num
  linarith only [hle, hpos]

noncomputable def localFactor (p k : ℕ) : ℝ :=
  (1 - (p : ℝ)⁻¹ ^ (k + 1)) / (1 - (p : ℝ)⁻¹)

theorem local_factor_pos (p k : ℕ) (hp : 1 < p) : 0 < localFactor p k := by
  have hpR : (1 : ℝ) < p := by exact_mod_cast hp
  have hi : (p : ℝ)⁻¹ < 1 := (inv_lt_one₀ (by linarith only [hpR])).mpr hpR
  exact div_pos (sub_pos.mpr (pow_lt_one₀ (by positivity) hi (by omega)))
    (sub_pos.mpr hi)

theorem local_gain (a : ℕ) (ha : 3 ≤ a) :
    localFactor 2 a * localFactor 3 a <
      localFactor 2 (a + 1) * localFactor 3 (a - 1) := by
  have hpow := power_comparison a ha
  have h2 : (2 : ℝ) ^ a ≠ 0 := pow_ne_zero _ (by norm_num)
  have h3 : (3 : ℝ) ^ a ≠ 0 := pow_ne_zero _ (by norm_num)
  have hdiff : localFactor 2 (a + 1) * localFactor 3 (a - 1) -
      localFactor 2 a * localFactor 3 a =
      (3 ^ (a + 1) + 1 - 4 * 2 ^ (a + 1)) / (4 * 2 ^ a * 3 ^ a) := by
    unfold localFactor
    rw [show a - 1 + 1 = a by omega]
    simp only [Nat.cast_ofNat, inv_pow, pow_succ]
    field_simp
    ring
  have hpos : (0 : ℝ) <
      (3 ^ (a + 1) + 1 - 4 * 2 ^ (a + 1)) / (4 * 2 ^ a * 3 ^ a) :=
    div_pos (sub_pos.mpr hpow) (by positivity)
  linarith only [hdiff, hpos]

theorem local_log_gain (a : ℕ) (ha : 3 ≤ a) :
    goldenPrimeLocalObjective 0 2 a + goldenPrimeLocalObjective 0 3 a <
      goldenPrimeLocalObjective 0 2 (a + 1) +
        goldenPrimeLocalObjective 0 3 (a - 1) := by
  have h2 := local_factor_pos 2 a (by decide)
  have h3 := local_factor_pos 3 a (by decide)
  have h2' := local_factor_pos 2 (a + 1) (by decide)
  have h3' := local_factor_pos 3 (a - 1) (by decide)
  have hlog := Real.log_lt_log (mul_pos h2 h3) (local_gain a ha)
  rw [Real.log_mul h2.ne' h3.ne', Real.log_mul h2'.ne' h3'.ne'] at hlog
  simpa only [goldenPrimeLocalObjective, zero_mul, sub_zero, localFactor] using hlog

theorem transfer_log_gain {n a : ℕ} (hn : 0 < n)
    (h2 : n.factorization 2 = a) (h3 : n.factorization 3 = a) (ha : 3 ≤ a) :
    let m := 2 * n / 3
    0 < m ∧ m < n ∧ goldenResourceObjective 0 n < goldenResourceObjective 0 m := by
  classical
  have hd : 3 ∣ n := Nat.dvd_of_factorization_pos (by omega)
  have hk : 0 < n / 3 := Nat.div_pos (Nat.le_of_dvd hn hd) (by decide)
  let m := 2 * (n / 3)
  have hm : 0 < m := mul_pos (by decide) hk
  have hmn : m < n := by
    have heq := Nat.div_mul_cancel hd
    dsimp [m]
    omega
  have hm2 : m.factorization 2 = a + 1 := by
    simp [m, Nat.factorization_mul (by decide : 2 ≠ 0) hk.ne',
      Nat.factorization_div hd, Nat.prime_two.factorization,
      Nat.prime_three.factorization, h2, Nat.add_comm]
  have hm3 : m.factorization 3 = a - 1 := by
    simp [m, Nat.factorization_mul (by decide : 2 ≠ 0) hk.ne',
      Nat.factorization_div hd, Nat.prime_two.factorization,
      Nat.prime_three.factorization, h3]
  have hother (p : ℕ) (hp2 : p ≠ 2) (hp3 : p ≠ 3) :
      m.factorization p = n.factorization p := by
    simp [m, Nat.factorization_mul (by decide : 2 ≠ 0) hk.ne',
      Nat.factorization_div hd, Nat.prime_two.factorization,
      Nat.prime_three.factorization, hp2, hp3, hp2.symm, hp3.symm]
  let s := insert 2 (insert 3 (n.primeFactors ∪ m.primeFactors))
  let f := fun p => goldenPrimeLocalObjective 0 p (m.factorization p) -
    goldenPrimeLocalObjective 0 p (n.factorization p)
  have hs2 : 2 ∈ s := by simp [s]
  have hs3 : 3 ∈ s.erase 2 := by simp [s]
  have hsN : n.primeFactors ⊆ s := by
    intro p hp
    simp [s, hp]
  have hsM : m.primeFactors ⊆ s := by
    intro p hp
    simp [s, hp]
  have htail : ∑ p ∈ (s.erase 2).erase 3, f p = 0 := by
    apply sum_eq_zero
    intro p hp
    have hp3 := (mem_erase.mp hp).1
    have hp2 := (mem_erase.mp (mem_erase.mp hp).2).1
    simp only [f, hother p hp2 hp3, sub_self]
  have hsum := sum_erase_add s f hs2
  have hsum3 := sum_erase_add (s.erase 2) f hs3
  have hdiff : goldenResourceObjective 0 m - goldenResourceObjective 0 n =
      goldenPrimeLocalObjective 0 2 (a + 1) + goldenPrimeLocalObjective 0 3 (a - 1) -
        (goldenPrimeLocalObjective 0 2 a + goldenPrimeLocalObjective 0 3 a) := by
    rw [golden_resource_objective_sum_on 0 hm s hsM,
      golden_resource_objective_sum_on 0 hn s hsN, ← sum_sub_distrib]
    change (∑ p ∈ s, f p) = _
    rw [← hsum, ← hsum3, htail]
    simp only [f, hm2, hm3, h2, h3]
    ring
  have hgain := local_log_gain a ha
  have heq : 2 * n / 3 = m := Nat.mul_div_assoc 2 hd
  change 0 < 2 * n / 3 ∧ 2 * n / 3 < n ∧ _
  rw [heq]
  exact ⟨hm, hmn, by linarith only [hdiff, hgain]⟩

theorem bind_only_endpoint {n a : ℕ} (hn : 0 < n)
    (h2 : n.factorization 2 = a) (h3 : n.factorization 3 = a) (ha : 3 ≤ a) :
    let m := 2 * n / 3
    0 < m ∧ m < n ∧
      (ArithmeticFunction.sigma 1 n : ℝ) / n <
        (ArithmeticFunction.sigma 1 m : ℝ) / m ∧
      (∀ lambda : ℝ, 0 < lambda →
        goldenResourceObjective lambda n < goldenResourceObjective lambda m) ∧
      ¬ IsColossallyAbundant n := by
  obtain ⟨hm, hmn, hgain⟩ := transfer_log_gain hn h2 h3 ha
  have hlogN : 0 < (ArithmeticFunction.sigma 1 n : ℝ) / n :=
    div_pos (by exact_mod_cast ArithmeticFunction.sigma_pos 1 n hn.ne')
      (by exact_mod_cast hn)
  have hlogM : 0 < (ArithmeticFunction.sigma 1 (2 * n / 3) : ℝ) / (2 * n / 3 : ℕ) :=
    div_pos (by exact_mod_cast ArithmeticFunction.sigma_pos 1 _ hm.ne')
      (by exact_mod_cast hm)
  have hz : (ArithmeticFunction.sigma 1 n : ℝ) / n <
      (ArithmeticFunction.sigma 1 (2 * n / 3) : ℝ) / (2 * n / 3 : ℕ) := by
    rw [golden_resource_sigma_identity 0 hn, golden_resource_sigma_identity 0 hm] at hgain
    simp only [zero_mul, sub_zero] at hgain
    exact (Real.log_lt_log_iff hlogN hlogM).mp hgain
  have hprices (lambda : ℝ) (hlambda : 0 < lambda) :
      goldenResourceObjective lambda n < goldenResourceObjective lambda (2 * n / 3) := by
    have hsize := Real.log_lt_log (by exact_mod_cast hm : (0 : ℝ) < (2 * n / 3 : ℕ))
      (by exact_mod_cast hmn : ((2 * n / 3 : ℕ) : ℝ) < n)
    have hcost := mul_lt_mul_of_pos_left hsize hlambda
    unfold goldenResourceObjective at hgain ⊢
    simp only [zero_mul, sub_zero] at hgain
    linarith only [hgain, hcost]
  refine ⟨hm, hmn, hz, hprices, ?_⟩
  rintro ⟨lambda, hlambda, hopt⟩
  exact (not_lt_of_ge (hopt (2 * n / 3) hm)) (hprices lambda hlambda)

#print axioms power_comparison
#print axioms local_gain
#print axioms transfer_log_gain
#print axioms bind_only_endpoint
#check bind_only_endpoint
```
