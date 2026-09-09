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
