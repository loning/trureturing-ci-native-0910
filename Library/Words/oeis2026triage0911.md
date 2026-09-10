---
bibkey: oeis2026triage0911
authors: OEIS Foundation Inc.; Codex triage workers
year: 2026
title: Third OEIS conjecture window — proof and dispatch triage, 2026-09-11
doi: null
url: https://oeis.org/
claim: Source-based triage only; no new mathematical theorem or Lean module is claimed.
strata_touched: []
license: citation-only
triage: anchor
---

# 第三轮 OEIS 分诊：新窗，判据不放宽

**落盘纪律：每完成一批即 git commit + git push。** 本件分批发布；最终计数和证据索引在收尾补齐。

源码基线 `9d18c01262f7dfd97eddbd07fbe0931fe832ed9a`，分支 `lane/math/oeis-triage3-0910`；Mathlib 钉版 `db584cd6d46c92f209a44c0f1c829460d327499d`，Lean v4.33.0。只写分诊文献，不建 Lean 模块、不冻结。产地为 Codex 主席与三个同模型族 codex-cli 全条目阅读席；主席综合并复核承重映射，不冒充异模型独立共识。采用 lean4 skill 的只读声明检索，无 Lean 编译或内核重验。

第一档靶的判据是「该陈述在文献中有没有证明」，不是「有没有人写过」。沿用前两轮：1 为有明确短组合/算术逃逸的候选，2 为非常规有限计算前沿，3 为尚无短逃逸的深层问题，out 为已知、错误、纯定义或不派的渐近/分布目标。published 表示所选精确目标有公开证明或反驳（公开仓内证明另明示），不是仅出现过猜想；open 仅表示所读材料仍作猜想且未找到证明；unknown 表示证明身份或目标桥未核实。数值 yes 指可作有意义的有限检验；每段另报实际规模，不把数据当证明。bind-only 风险来自钉版具名声明比较，none 只是本次检索未找到，绝非全库不存在证明。伪签名均未编译。

## 采集与边界

排除集严格复原为 342 个唯一 A 号，并与前两轮 93+249 条核对相等。官方镜像钉版 `69b127f67c75990effad199e316d6e8a5183b64c`，本次远端 HEAD 仍为此版；该快照上界 A399693，没有 A400/A401 目录。因此从 A398000–A399693 的完整原文关键词窗中取得 52 个未排除命中，选 30 条实质分诊；其余 22 条未分诊，不能算 drop。关键词包括 Conjecture / It appears / permutation，查词仅用于发现，裁决读完整字段。

本次主要来源是官方 https://github.com/oeis/oeisdata 镜像的完整 `.seq`，不是 OEIS JSON 接口响应。公开定位形如 https://github.com/oeis/oeisdata/blob/69b127f67c75990effad199e316d6e8a5183b64c/seq/A399/A399084.seq 。接口尝试分列：精确 id:A399200 得 HTTP200；urllib 搜索得 HTTP403；curl 通配查询得 HTTP200/null，不据此断言无匹配；本轮未遇 HTTP429，不把上一轮的429冒充本轮读数。A399639 镜像404，精确 JSON HTTP200但仅为 allocated 占位，详见 A399381 段。

## 未主张栏

未主张检索穷尽；未主张 open 等于全球无人证明；未主张所有外链论文已全文审读；未主张 published 等于原猜想为真。凡未真正打开的外链页面一律 **ASSUMED-UNVERIFIED**，只有逐段点名打开的文献可承重。完整条目阅读与外链全文阅读分账；一跳 A 号预检含 comment/formula/xref 的全部直接引用，不递归无限追引。临时原文、脚本及日志住 runner attempt，非永久公共存档。

## 排序表

| A号 | 一句话陈述 | 档位(1/2/3/out) | 文献(open/published/unknown) | bind-only(low/med/high) | 数值可验(yes/no) | 建议(dispatch/note-only/drop) |
| --- | --- | --- | --- | --- | --- | --- |
| [A399084](https://oeis.org/A399084) | 贪心 floor-sqrt 序列的极大严格下降段长度是五个1后接 m,1,m,1（m≥2）。 | out | published | high | yes | drop |

## 逐条证据

### A399084

精确目标：对原条以历史未用性定义的 `seq`，极大下降段恰为初始五个单点，以及每个 m≥2 在 s=m²+m−1 的四段 `(s,m),(s+m,1),(s+m+1,m),(s+2m+1,1)`。文献裁决：完整读本条与一跳引用；虽 OEIS 原文仍写 Conjecture，基线已含公开冻结的 `D5.S1.Digit.GreedyFloorSqrtRunBlocks.maximal_decreasing_run_lengths`（`D5/S1/Digit/GreedyFloorSqrtRunBlocks.lean:765`），其 literal-history `seq`、`IsMaximalDecreasingRun`、`seq_eq_closedForm`/`seq_four_blocks` 与目标匹配；冻结 state 的 statement_id 为 `sha256:601488f603b60668052dfc38ee7ce71ae93d3834a0fea46d0fae74f178884908`，此处 published 指公开仓内证明，未重编译。bind-only 疑似声明：上述 exact iff 已覆盖全目标，high，不能再派桥接席。数值方案实际跑 hash-set 历史递推 100001 项，以一次线性扫描取完整下降段，1259 段全部吻合，68 项 DATA 全相等；末尾未完成段不作反例。便宜形态是在线集合+游程扫描，无需对每一步重扫全部历史。拟议逃逸：无新增目标，drop；停止条件已触发为精确冻结同题。同族合派：本轮仅此一条，零席；不得改名为闭式再派。xref 预检全部直接 A 号（完整读）：A000196、A020703、A038722；这些是背景平方根序列，决定性淘汰证据来自仓内 exact theorem。
