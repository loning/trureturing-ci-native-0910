# A368628 attempt 2

产地：lean4 skill；Codex 主线程实施，用户给出分步路线；零独立评审席，单点核验。基线 `f838f20236e5a723d0c025ef53a80a07483008fa`，分支 `lane/math/a368628`。

## 预登记

问题：原分段平方/四次卷积定义的自然数序列是否满足 `Odd (seq n) ↔ ∃ k, 3*n+1=4^k`。本轮不新建理论卷，不 ingest，不造 atom；无 atom 冻结使用 `ledger-align --add`。

拟议 escape_witness：由原卷积推导的模二递推（三个剩余类），随后强归纳产生指数存在性。该递推不是定义的一部分。一般无界定理，`utility: none`；非有限枚举、检查器、数值归约或已认证有限实例。

停止：成须 Lean 全构建成功、无 sorry/私 axiom、开 PR；翻须 kernel 反例；blocked 须具体 Lean goal/error 与各路线读数。有限核对不计证明进展。

## 检索收据

- D5：`rg '368628|a368628' D5 Library Blueprint docs/develop`：仅既有 OEIS 分诊，未命中本题定理。
- 完整读取 `ConvolutionRecurrenceOddPowersOfTwo.lean`：公开一般 `convolution_pairing` 命中，计划 import 并实际应用。
- 完整读取 `CatalanDoubleCompositionPowersOfFour.lean`：private `quartic_support` 属不同方程；仅借强归纳证明形状，不引用其结论。
- 官方 OEIS `https://oeis.org/A368628/internal`，本轮 HTTP 200，原文仍标 Conjecture；公式 (1) 与用户的分段卷积一致。Israel 的多项式/68阶递推不声称奇偶证明。档位1；仅在已查资料范围未见证明。
- GitHub 未认证代码搜索 `A368628 language:Lean` HTTP 401，不能声称全生态搜索完成。未打开的第三方页均为 ASSUMED-UNVERIFIED。

## 构建与容量

首次 `make lean-cache-ensure` EXIT=0：status=seeded，method=clonefile，donor=/Users/chronoai/trureturing，clonefile_attempts=1，mathlib/project 均 warm，missing olean=0。未跑冷树裸 lake。

容量：`find D5/S1/Recurrence -maxdepth 1 -type f | wc -l` 为23；Invariants 递归计数25。域 Recurrence 注册 S1；选择直接目录，generality I。

## Lean 尝试

正在建立原卷积定义与第一个一般模二系数引理；尚未声明证明成功。

## 未主张

未主张全世界无已有证明、未主张不同 Hanna 序列相同、未主张数值探针等于证明、未主张独立评审或 CI 已通过。

### 编译尝试 1

热树 `lake env lean /tmp/a368628-probe.lean`：原卷积 well-founded 定义、`seq_zero`、`seq_recurrence`、一般 `pow_coeff_congr` 均成功 elaborate。退出1仅因探索用 `#check` 三个不存在的 interval 引理；具体 `Unknown identifier sum_Icc_succ_bot / sum_Icc_eq_sum_range / Finset.sum_Ico_zero_bot`。这些查询已从正式文件移除。序列不包含模二支撑规律。

钉版 Mathlib 检索命中 `PowerSeries.coeff_mul`、`coeff_expand_mul`、`coeff_expand_of_not_dvd`、`MvPowerSeries.map_frobenius_expand`；直接复用。arXiv API `all:A368628` HTTP 200，totalResults=0。
