# A398720 implementation — 2026-09-10

产地：`lean4` skill；Codex implementation worker 单点实施、自查，零独立评审席。
用户/分诊席的枚举与文献读数是转述，不冒作本席实测；外层 runner 的评审另计。

## 预登记

第一档。目标严格为用户的 `spcp_odd_top_weight`，矩阵类型为
`Fin n → Fin n → Bool`，每行每列的 1 数为偶，总重量为 `n*(n-1)`。
定义不得含阶乘或计数结论。拟议见证为：每行至少一个零，加上总重量条件，
迫使每行恰一个零；列同理，零位置构成置换，反向用置换的补集构造矩阵。
这仍待 Lean 核验。预计唯一公开定理 proof_shape=content，
admission_basis=escape-witness；直接冻结依赖与见证四项留待证明后核对。
utility=none：无界量化的组合双射，非有限枚举、checker、数值归约或认证实例。

停止条件照 brief：DATA 对不齐、发现同一全称命题的外文证明、或无额外假设双射
无法构造则退 note。三态：成=make lean EXIT=0、无 sorry/私 axiom、PR 开出；
翻=kernel 反例；blocked=实际 Lean goal/错误及最锐剩余子命题。
无 atom；使用现有 `make deposit-uncovered`（内部 ledger-align --add），不建理论卷，
不 ingest，不制造 coverage。n=1 必须涵盖。

## 开工与检索第 1 批

- 分段完整阅读 CLAUDE.md 779 行（工具截断处补读）、agents/CONTEXT.md、lean4 skill。
- 指定工作树初始干净，lane/math/a398720；固定 base=24279623ef5253194f6c64ee3b3b627e62e3df50。
- lean-toolchain=v4.33.0，manifest mathlib pin=db584cd6d46c92f209a44c0f1c829460d327499d。
- docs/reports 直属文件数 48，故本报告在 a398720 子桶。
- D5/Library/Blueprint 粗筛 A398720、A396317、EvenRowsCols、SPCP、single.parity、
  even.row、even.column：只有分诊 note 与非目标的 dyadic-row 结果，未见同目标定义/定理。
- 扩展检索 card_perm、sum_eq_sum_iff、card_eq_one、existsUnique、Equiv.Perm、
  rowSum/rowWeight；命中模块公开面还需逐项读取，不以题名排除一般引理。
- spec A5.1：utility: none 在 anchors 与 digest 之间；域由 Meta/domains.yaml 注册表选取。
- 已首先启动 make lean-cache-ensure；未运行冷树裸 lake。缓存结果尚待读取。

## 未主张

尚未主张证明、冻结、构建或 PR 已完成。未主张全球无已有证明或首创性。
尚未打开的外部页面均为 ASSUMED-UNVERIFIED；用户 1/3/5 枚举及分诊的 66068
自由赋值核对不是本席计算。不把有限核对称为一般定理的部分进展。
