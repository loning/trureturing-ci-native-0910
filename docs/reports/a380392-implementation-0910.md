# A380392 implementation — 2026-09-10

产地：`lean4` skill；Codex implementation worker 单点实施、自查，独立评审席为 0。
用户转述分诊席检索与其本人 n=1..4 枚举；这些不是本席实测。外层 runner 的评审另计。

## 预登记

第一档；目标是用户 brief 中所有 n≥1 的二元矩阵全 1 东/南单调路径平均数公式。
pathCount 必须实际计数从 (0,0) 到 (n−1,n−1) 的路径，不得定义为目标右式。
拟议 escape_witness：固定路径访问恰 2n−1 个不同格，满足该路径的矩阵与其余格的任意 Bool 赋值双射。
交换有限求和后，各路径贡献 2^((n−1)^2)，路径数为 C(2n−2,n−1)。
该见证对应用户 brief 的 ASSUMED-UNVERIFIED 结构义务；最终须由 Lean 核验。
拟判主定理 proof_shape=content，admission_basis=escape-witness；预计直接冻结依赖为空，最终以语义报告核对。
utility=none：无界量化的一般组合定理，不以有限计算或认证实例为主要内容。

停止判据：成 = make lean EXIT=0、无 sorry/私 axiom、PR 开出；翻 = kernel 反例；
blocked = 写清路线、卡点与最锐剩余子命题。发现公开完整证明则按 brief 退 note。
n=0 不进入结论；禁止反向、重复或对角步，n=1 须符合单格路径。
无 atom 冻结使用既有 ledger-align --add，不建理论卷、不 ingest、不制造 coverage。

## 开工与检索收据

- 已分段完整阅读 CLAUDE.md（779 行，截断处补读）、agents/CONTEXT.md 和 Lean skill。
- 干净工作树，分支 lane/math/a380392；base=48e95107100e503cdc52aa44cc15165b65fc3213。
- lean-toolchain=leanprover/lean4:v4.33.0；manifest mathlib pin=db584cd6d46c92f209a44c0f1c829460d327499d。
- D5 粗筛：`rg -n -i 'A380392|monotone.*path|lattice.*path|path.*expect|random.*matrix' D5`。
  唯一命中 HeartsDraft 的无关历史注释；没有目标证明命中。此为字面粗筛，不冒称语义穷尽。
- 报告目录创建前直属文件 39 个，低于 48。
- 钉版 mathlib 与第三方/OEIS/arXiv：待本席检索。

## 当前未主张

尚未证明、构建、冻结、开 PR。尚未打开的外部页面全部 ASSUMED-UNVERIFIED。
不主张全球不存在公开证明，不主张发现优先权，不以用户枚举替代一般证明。
不主张独立模型共识或 CI 已绿。
