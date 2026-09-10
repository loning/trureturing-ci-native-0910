# OEIS A398189 implementation record

产地：`lean4` skill；Codex 主循环单席实施、单点自查，尚无独立评审。
用户转述的 orchestrator/分诊席读数不冒充本席亲验。
工作树 `/Users/chronoai/trureturing-a398189`，分支 `lane/math/a398189`。
初始 base：`343718ed191002a4708ccf381081f9b0c7a58e1a` (`origin/dev`)。

## 预登记与边界

第一档。目标是定义中的自然数截断和
`S(n,k) = ∑ j ∈ range (n-k+1), (n-k)! / j! * n^j`，
奇 `n ≥ 1`、`1 ≤ k ≤ n` 时：奇 k 的二进估值为零；
偶 k 且 `k % 16 ≠ 14` 时估值为 `padicValNat 2 (k+2)`。
不把 `k=0` 或偶 n 已证背景当成剩余目标。

拟议见证沿用 brief：递推 `H₀=1`、`Hₘ=n^m+m Hₘ₋₁` 六步展开，
连续六个整数的乘积模16消失，奇数幂的模16周期，以及向全部参数的提升。
该见证尚未 Lean 编译；56/45 个格子的上游结构探针为 ASSUMED-UNVERIFIED。
有限枚举只作私有余数引理或探针，不能单独冻结。
停止条件：目标范围的精确反例、找到剩余公式的已有证明、或只剩已证背景。
无 atom；不新造理论卷、不 ingest。使用现役无 atom 冻结入口。

## 检索收据（持续追加）

1. 本仓 D5/Library/Blueprint/docs：`rg -n -i 'A398189|A063170|Schenker|Amdeberhan|truncated.*(factorial|exponential)'`。
   未命中目标；命中的是其它截断指数估计与文献分诊条目。
   按文件名筛出 factorial/valuation 模块，公开面阅读待完成。
2. 钉版 mathlib、第三方 Lean 生态与文献：待完成，不作 search-complete 主张。
3. 已下载 OEIS A398189 internal HTML；论文下载中，尚不主张已读。

## 声明与门收据

尚无新增公开定理；`proof_shape`、直接冻结依赖（GID/statement_id）、
`escape_witness`、`admission_basis` 待真实证明后逐条填写。
尚未跑 Lean；无构建成功主张。最终须记录 `LEAN_CACHE`、make lean 退出码/耗时、
lean-report、emit、Scribe 内容检查及 freeze 收据。

## 未主张

未主张 `k ≡ 14 mod 16` 例外公式；未主张有限核对证明全称；
未主张 A063170 的已证性解决剩余目标；未主张已解决、已冻结、已开 PR 或已合并。
所有未真正打开的外部页均为 ASSUMED-UNVERIFIED。

## 第二批亲读收据

- 已完整读 A398189 及其全部直接序列引用 A398187、A063170、A000120 的 internal 条目；主条目唯一论文链接的摘要入口亦打开。
- Amdeberhan–Callan–Moll，Integers 13 (2013) A21，16 页全文已逐页提取阅读，另亲看第5页原图。§2 pp4–5 证明 k=0：奇 n 估值1；偶 n 估值 n-s₂(n)。Lemma 2.2 的式(2.11)–(2.14) 给正 j 项相对零项的严格估值差 s₂(j)+j v₂(n/2)>0；截到 n-k 并缩放后仍给所有偶 n 背景。§3–4 讨论 k=0 的奇素数估值，§5 为 Abel/树组合恒等式。未见奇 n、正 k 的目标公式证明。
- 文献裁决（按 brief 原边界）：k=0 已证、所有偶 n 分支为已证背景；未因 A063170 已证而降低剩余目标档位。未打开直接引用条目所进一步引用的二级文献，均 ASSUMED-UNVERIFIED，不作为判据。
- 本仓候选模块公开面：FactorialQuotientRecurrence 的 positivity/triple-product/Mathar recurrence 针对另一递推；FactorialProductSumCatalanParity 的一般系数消失、唯一性、模2函数方程与 Catalan support 不提供本截断和递推或估值。未发现可直接复用的目标/抵消引理。
- 钉版 Mathlib `rg -i 'schenker|truncated.*exponential|A398189|A063170' Mathlib` 零命中；`PadicVal/Basic.lean` 提供 `padicValNat.eq_zero_of_not_dvd`、`padicValNat_dvd_iff_le` 等通用估值接口，不提供抵消。Lean pin 已对齐。
- GitHub code search 实测可用：`Schenker language:Lean`、`A398189 language:Lean`、`"truncated exponential" language:Lean` 均 total_count=0。搜索范围无命中并不阻塞本地证明。
- `make lean-cache-ensure`：`status=seeded, method=clonefile, clonefile_attempts=1, stamp_miss=null, mathlib_olean_state=warm, project_olean_state=warm`；原始收据 `/tmp/a398189-cache.log`。
- 首次报告目录计数为48；已把本题报告放入独立任务子目录，未向已满的平桶继续添加文件。

## 首个 Lean 单元

热树 `lake env lean /tmp/A398189.lean`，修正 `Nat.div_self` 要求正数（而非非零）后 EXIT=0。
已验证全称 `h_sum`（任意 n,m 的定义求和/递推等价）、`six_zero`（模16连续六因子为零）与 `six`（任意 n,m 的六步截断恒等式）。
尚未得到目标估值公式；这不是把有限核对算作目标进展。
检索更正：英文 `"truncated exponential" language:Lean` 实际 total_count=1，前段写0是并行结果到达前的记录错误。
命中 `kim-em/hex-dev/HexTruncatedSeriesMathlib/Newton.lean` 的 `ofPowerSeries_exp`，已读声明及上下文；
它陈述形式幂级数截断与可执行 exponential 的交换，不是整数截断和抵消/估值公式。

第二个已编译单元：`val_mod`、`odd_four`、`odd_pow`、`large_table` 全部 EXIT=0。
`odd_pow` 直接使用 Mathlib `pow_eq_pow_mod`，未重建已有周期接口。
`large_table` 为私有有限环引理，`decide +kernel` 经 kernel 归约，不用 native_decide；尚须全称提升。
当前 Lean 源同步保留这些单元；无首次冻结，最终目标仍待完成。
