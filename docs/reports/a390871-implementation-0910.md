# A390871 implementation — 2026-09-10

产地：`lean4` skill；Codex implementation worker 单点实施、自查，独立评审席为 0。
用户 brief 的分诊、枚举与对账是用户/分诊席读数，不冒作本席实测；外层 runner 的评审另计。

## 预登记

第一档，目标严格为 brief 的 `mersenne_gap_exponent_bounds`，保留自然数加法等式
`k^2+1=r^2+2^m` 及全部假设。拟议 escape_witness：差 `d=k-r` 是至少 3 的奇数，
推出 `6*k ≤ 2^m+8`；再以二进对数双侧夹逼得到指数下界，上界用平方估计。
这是用户预登记因子构造不等式的无截断表述；不是把目标换成 `4 ∣ k`。
预计唯一公开定理 proof_shape=content、admission_basis=escape-witness、
直接冻结依赖为空；最终须按 elaborate 后语义依赖核实。
utility=none：无界量化的一般整数不等式证明，非有限枚举、检查器、数值归约或认证实例。

停止判据：成 = make lean EXIT=0、无 sorry/私 axiom、PR 开出；翻 = kernel 反例；
blocked = 实际 Lean 尝试的 goal/错误、路线与最锐剩余子命题。
小 m/r=0 推导失败、找到同目标已有证明或反例则按 brief 退 note。
无 atom，使用 canonical ledger-align --add 路径，不建理论卷、不 ingest、不制造 coverage。

## 开工与检索收据

- 已分段完整读 CLAUDE.md（779 行，截断处补读）、agents/CONTEXT.md、lean4 skill。
- 指定工作树干净，分支 lane/math/a390871；固定 base=3759149d0ea0884cb8a57fb950e3caddab007a38。
- 报告目录创建前直属文件数 42；spec A5.1 已读，`utility: none` 位于 anchors/digest 之间。
- D5 字面粗筛：`rg -n -i '390871|mersenne|pow_log_le_self|lt_pow_succ_log_self' D5`。
  未命中目标；命中 dyadic counting/decay 模块、NormOneLucasDouble 的文献注释、
  UnitReversionSquareParity 的 private Mersenne helper。公开面逐条检查继续中，
  不以“题名不同”推断无可复用引理。
- 本树尚无 .lake，已首先启动 make lean-cache-ensure；未运行冷树裸 lake。
- 钉版 Mathlib、第三方 Lean/OEIS/arXiv 检索与构建尚未完成。

## 未主张

未主张已证明、已冻结、已构建或已开 PR。未主张全球不存在同目标证明或首创性。
尚未打开的外部页面为 ASSUMED-UNVERIFIED；用户的 131/162/163 口径不是本席枚举。
不主张独立模型共识，不把有限核对作为一般定理的部分进展。
