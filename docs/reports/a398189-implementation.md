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
