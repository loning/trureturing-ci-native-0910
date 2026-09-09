# A373409 implementation, 2026-09-10

产地：Lean 技能；Codex 主循环单席实施、单点自查，尚无独立评审。
用户提供的 orchestrator 平方筛读数是上游输入，本席不冒领为亲验。

## 预登记与陈述回声

- 第一档：OEIS A373409 的无界 antirun 长度上界 9；文献状态待本席联网核对。
- `FullNonsquarefreeInterval l` 必须同时要求严格递增、逐项非平方自由，以及对任意
  `a ∈ l`、`b ∈ l`、`a ≤ n ≤ b`，若 `¬ Squarefree n` 则 `n ∈ l`。
  最后一项禁止稀疏抽选；空列表与单项列表也有明确语义。
- 拟议 escape_witness：4、9 的倍数给出的两族相邻障碍，及其间跨度 18 的
  十项装填必占同奇偶位置、与必含的 4 倍数冲突。原 brief 称“19 格”，
  这里区分格数 19 与端点差 18；完整论证仍为 ASSUMED-UNVERIFIED。
- 长度 9 的指定实例仅作 private 尖锐性引理，不作独立准入依据。
- 成：无界上界经 kernel 验证、make lean EXIT=0、零 sorry/私 axiom、PR 开出。
  翻：给出 kernel 反例。blocked：列路线、失败边界与最锐剩余子命题。
- 不新建理论卷、不 ingest、不自造 atom；冻结用既有 ledger-align --add 路径。

## 初始收据

- 工作树 `/Users/chronoai/trureturing-a373409`，分支 `lane/math/a373409`，初始干净。
- HEAD/base：`b1c34e4ffff0e67321c1ed9ec60b9eea741e239f`。
- 完整阅读 CLAUDE.md；读取 agents/CONTEXT.md、spec A5/A5.1 与 Meta/domains.yaml。
- Lean pin `v4.33.0`；lake-manifest mathlib rev
  `db584cd6d46c92f209a44c0f1c829460d327499d`。
- D5 检索：`rg -n -i 'A373409|A373573|A373574|A068781|antirun|nonsquarefree|non.squarefree' D5`。
  无目标精确命中；只命中 PrimeWordAntipodeParityStepBridge 的 Möbius 零值引理。
  另读 SquarefreeSquareDecomposition：讨论平方自由分解唯一性，与目标不重合。
- 初始 `.lake` 不存在；已启动 `make lean-cache-ensure`，未运行裸 lake。
- 报告目录初始直接文件数 37（`find docs/reports -maxdepth 1 -type f | wc -l`）。

## 未主张

尚未主张数学论证闭合、Lean 通过、第三方检索完成、冻结成功或 PR 已开。
尚未亲验的 OEIS 页面与外部文献均为 ASSUMED-UNVERIFIED。

## 有序库检索及缓存读数

1. D5：上述检索无目标精确命中。
2. 钉版 Mathlib：`rg -n -i 'antirun|A373409|A373573|A373574|A068781|nonsquarefree' .lake/packages/mathlib/Mathlib` 零命中。
   `Nat.squarefree_iff_prime_squarefree`、`List.pairwise_iff_getElem`、`List.isChain_iff_pairwise`
   可作基础引理；不是目标全称上界。源文件已打开。
3. 外部实取：OEIS 四个 `/internal` URL 均 HTTP 200；A373409 原文
   “Conjecture: The maximum is 9, and there is no antirun of more than 9 nonsquarefree numbers.”
   A373573/A373574 均问 “Are there only 9 terms?”。
   A068781 给 `36a+8`/`36a+9` 算术级数，没有九项装填证明。
   共同链接的 `https://oeis.org/A373403/a373403.txt` 已读，为序列对照表。
   arXiv Atom API `all:antirun` HTTP 200，totalResults=0。
   GitHub 仓库搜索 `antirun lean`：0；认证代码搜索 `A373409 language:Lean`、
   `antirun language:Lean`：各 0。`nonsquarefree language:Lean`：5 文件，进一步核对中；
   包括多项式分解代码和 LeanTriathlon 的 NonSquareFreeWeird 导入，不能把名称命中当作已有证明。
   leansearch.net 首页 HTTP 200，仅证明访问能力，不冒充已执行语义查询。
   所有原始下载保存在 runner attempt 目录。
4. 缓存：`make lean-cache-ensure` EXIT=0；`status=seeded, method=clonefile`，
   donor=/Users/chronoai/trureturing，clonefile_attempts=1，stamp_miss=null，
   mathlib_missing_olean_files=0，project_olean_state=warm，mathlib_olean_state=warm，
   archive_status=not_attempted，archive_skip_reason="project olean state is warm"。
5. 候选落点 Arith/Congruence：`find D5/S3/Arith/Congruence -type f | wc -l` = 19；
   registered domain Arith/S3，普通自然数的整除与模结构，generality=G。

数学路线细化（仍为预登记）：若取前十项 x0…x9，九个 gap 强制 x9≥x0+18。
令 q=x0/36：x0≤36q+8 时用 8/9 障碍；9≤余数≤27 时用 27/28 障碍；
28≤余数时用下一周期 44/45 障碍。只有中间情形允许跨度18，迫使
x0=36q+9、x1=36q+11；Full 强制 36q+12 在列表内，与 x1 相邻矛盾。
这沿用原拟议见证，仅明确端点，初段也由第一情形统一处理。

## 定义与障碍引理检查点

- `FullNonsquarefreeInterval` 已按三字段落盘：`increasing`、`nonsquarefree`、`full`。
  `full` 的量词覆盖任意两项之间的全部非平方自由自然数，无隐藏的上界假设。
- 热树 API 探针确认 v4.33 使用 `List.IsChain`，brief 的 `Chain'` 更新为该现役名。
  API 探针四个候选名字不存在，已改用编译器确认的
  `List.IsChain.pairwise`、`List.mem_iff_getElem`、`List.pairwise_iff_getElem`。
- `lake env lean D5/S3/Arith/Congruence/NonsquarefreeAntirun.lean` EXIT=0：
  Full 定义、no_neighbors、4/9 整除引理与 upper_of_pair 已验证。
  一条 letI 风格警告按建议改为 let；尚未声称项目 make lean 通过。
- GitHub 命中逐项收窄：打开 LeanTriathlon 的
  `LiveLeanTriathlonSorry/NonSquareFreeWeird/All.lean`（2aede420…），
  目标是 `weird_squarefree_infinite`，证明为 sorry，与本题不同。
  打开 hex-dev 的 EezTests（40585b8…）：命中为多项式分解测试。
  其余三个 hex 文件未打开，明确 ASSUMED-UNVERIFIED，不据文件名宣称完整核验。
- dominating_theorem_search：在已检索/已打开范围未找到本题的已有证明；
  这不是对全部文献的穷尽保证。Library/Arith 实测 48，不能向该桶新增笔记。

## 无界上界与尖锐性内核检查点

- 全称定理 `antirun_length_le_nine` 首次完整实现即编译成功；
  `#print axioms` 为 `[propext, Classical.choice, Quot.sound]`。
- 私有见证经历两次明确失败：`norm_num` 没有化简 Squarefree 常数；默认 `decide`
  卡在 `Nat.minSqFac` 展开。读取 Mathlib 定义后使用 `decide +kernel`（内核归约，
  不使用 native_decide），完整文件编译 EXIT=0。见证公理闭包同为标准三公理。
- `nine_term_witness` 同时验证 Full、全部相邻 gap 与长度=9；不是仅验证九项逐项非平方自由。
- 初段无需单独枚举：余数≤8 的相邻障碍已覆盖，包括自然数 0；
  这给出比正整数枚举略强的陈述，不改变题意中的正整数结论。
- 当前结果不再把障碍/装填论证标为 ASSUMED-UNVERIFIED：它已 kernel 验证。
  尚待 make lean、报告、发射、冻结与 PR；不提前主张项目门通过。
