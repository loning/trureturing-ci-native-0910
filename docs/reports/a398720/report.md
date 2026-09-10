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

## 检索第 2 批与缓存

- make lean-cache-ensure EXIT=0：status=seeded、method=clonefile、donor=/Users/chronoai/trureturing、
  clonefile_attempts=1、stamp_miss=null、project_olean_state=warm、mathlib_olean_state=warm，
  archive_status=not_attempted。分支首个提交 129ce69141 已成功推送。
- 钉版 Mathlib Data/Fintype/Perm.lean 全文已读，直接复用 Fintype.card_perm。
  Data/Finset/Card 的 card_filter_add_card_filter_not、card_eq_one_iff_existsUnique
  是拟用的零数分解与唯一性接口；Matrix/Permutation、Stochastic 公开面继续核对。
- D5 选中相关公开接口逐项读取：EscapeCount 的 diagonal_landing_fixed 与
  escaped_listing_card；FiniteSelfMapConjugacy 的两条一般共轭定理；MatchingEquiv 的
  fiberToFactors、单射/满射、matchingMonomialFiberEquiv 和三条计数/系数定理；
  DataProcessingEquality 的一般通道等号条件。均未提供本题的偶性/重量到零位置的桥。
  GoldenFactorSecondOrderBinomialRigidity 的公开定理约束 goldenWord 前缀，不直接适用，
  但其使用的 Mathlib sum_eq_sum_iff_of_le 可直接复用，继续定位上游。
- 实际 curl 成功打开 A398720/internal，已读全部字段：revision #66 (2026-08-20)；
  %C 明定 n×n、2k 个 1；%F 仍明确 Conjecture: T(n,n*(n-1)/2)=n! for n odd。
  %e 各行 n=0..6 唯一对齐，n=1/3/5 行尾为 1/6/120；%O=0,8。
  标题的 (n+1)^2 偏移不进入模型。原始页面存 runner attempt/oeis-internal.html。
- 本席未重新打开 11 个 xref 全文与 Thompson/Patel–Hong PDF；其既有检查见
  Library/Words/oeis2026triage0910.md 的 A398720 段，是上游转述的有界文献结论，
  对本席亲验口径标 ASSUMED-UNVERIFIED。不声称穷尽编码文献。

## 检索第 3 批：收口

- GitHub code 搜索 A398720 language:Lean 与 EvenRowsCols language:Lean 均返回 []。
  arXiv A398720 查询页明确 produced no results（原页存 runner attempt/arxiv-search.html）。
- GitHub parity/matrix/Lean 粗筛命中 FormalRV/QEC/LDPCMatrix.lean，已在
  c40ac65d72df7760a5e441ad7269e2ddedcc49c7 打开全文：List Bool 矩阵、xor、行组合、
  稀疏度布尔检查及小例，无本目标计数或双射。其余粗筛为群/模形式/微分形式等邻词命中，
  未逐页打开，标 ASSUMED-UNVERIFIED，不以该查询声称全生态无定理。
- 新命中的 D5 MonomialDiagonalPreserving 全文公开面已读，只从给定置换定义 monomial
  并证明保持对角矩阵；GraphPairingCriterion 全文给函数图的行列分离条件。
  二者不提供从行列偶性与总重量导出的唯一零位置，未发现可直接消费的冻结前置。
- Mathlib Stochastic 公开 API 为非负性、行列和、凸性、置换矩阵正向实例及转置/reindex；
  未见本目标或 Bool 计数反向构造。直接使用有限和/有限集及置换基数 API。
- dominating_theorem_search=not-found-in-searched-scope，维持第一档，有界检索不主张首创。
- 检索中一条自写 rg 正则有 unclosed character class，已改简单词首正则重跑；
  一个候选 Mathlib 路径不存在，已按实际源码路径读取，未把命令错误当零命中。
