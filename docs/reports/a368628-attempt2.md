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

### 编译尝试 2

正式定义文件单文件编译 EXIT=0，提交 `55fbae1c3c` 已推送。配对探针实际应用 `convolution_pairing`，通过 `g=X*expand₂(f)` 把奇次平方系数变为 g 的偶次平方系数。第一次 EXIT=1，goal 为 `∑ x ∈ range (2*m), coeff x f * coeff (2*m-x) f + … = coeff m f ^ 2`，`sum_range_eq_add_Ico` 缺显式求和函数参数。修复传入该函数；不是数学障碍。完整 goal 在 attempt 工件的 Lean 日志中保存。

配对探针修复后 EXIT=0：`square_even_coeff` 实际应用既有 `convolution_pairing`；`square_odd_coeff` 经 `X*expand₂(f)` 降到 midpoint=0，不重证 involution。首次序列 cast 桥 EXIT=1：`simp only` 未把 `map(series^p)` 与 `(map series)^p` 对齐，具体两侧为 `Nat.castRingHom … (coeff … (series^p))` / `coeff … ((PowerSeries.map … series)^p)`；改为反向 `map_pow` 再 `coeff_map`。

**第一步完成**：`seq_even_index_zero (j : ℕ) : (seq (2*j+2) : ZMod 2)=0`，正式文件热树增量编译 EXIT=0；`#print axioms` 仅 `propext, Classical.choice, Quot.sound`。原卷积到自然数 cast 桥已闭合。全项目门与冻结待最终模块齐备后依序执行。

**第二步完成**：四次 Frobenius 探针 EXIT=0；正式 `seq_four_mul_add_three (j)` 编译 EXIT=0，标准三公理闭包。`square_expand` 直接用 Mathlib `map_frobenius_expand` 和 `ZMod.frobenius_zmod`；两次 expand 合成四次，再用 `coeff_expand_of_not_dvd`。认证 GitHub 代码搜索 `gh api search/code?q=A368628+language:Lean` 成功，total_count=0；替代此前401失败，检索边界仍限字面 A 号。

**第三步完成**：`seq_four_mul_add_one (j) : (seq (4*j+1) : ZMod 2) = (seq j : ZMod 2)`，正式文件增量编译 EXIT=0，标准三公理闭包。与第二步共用一般 `fourth_expand`，此步精确应用 `coeff_expand_mul`。三个无界模二递推均已闭合，下一步为指数双向强归纳。

### 强归纳尝试

首次编译只有零基例报错：`simp only` 已把 `1=1` 归约为 `True`，`iff_of_true rfl` 需要 `True` 而收到等式证明。改 `rfl` 为 `trivial`；非零所有分支（正偶、4j+3排除、4j+1指数前推/回推）均无编译错误。

本轮完整读取四个直接 xref 的 N/C/H/F/Y 字段（A368593/A368626/A368627/A368629，均 HTTP200），所查页无 A368628 奇偶证明。Israel 68阶递推文件 HTTP200，已下载；长多项式系数未逐项验证，ASSUMED-UNVERIFIED，不作为证明依赖。原目标 OEIS 页、arXiv 检索与源码检索收据仅支持所查范围未见证明。

无 atom 入口核实：`make deposit` 的 `require_transaction_arguments` 强制已有 ATOM_ID，不能用于本题；依用户明确指示使用它内部同一 writer `ledger-align --add`，另行运行相同 `deposit-header-check`。不会造 atom 满足接口。

**目标定理已通过单文件 Lean**：`a368628_odd_iff (n : ℕ) : Odd (seq n) ↔ ∃ k : ℕ, 3*n+1=4^k`。修复后 EXIT=0，六条公开定理的 `#print axioms` 均仅标准三项。尚未宣告最终“成”：全项目门、Scribe、冻结、PR 在后续完成。

### 语义回声与依赖读数

追加 private 的前四项回声，直接从自然数卷积递推计算，不使用奇偶定理。首次编译仅该 private echo 有两处 simp 未归约：`coeff 0 (mk seq ^ 4)`、`if Even 3 then … else …`；修复为显式 constantCoeff/map_pow 和奇偶分支。主定理仍闭合。编译期 `getUsedConstants` 已确认七条预登记直接依赖，包括 `square_even_coeff → ConvolutionRecurrenceOddPowersOfTwo.convolution_pairing`，复用不是闲置 import。
