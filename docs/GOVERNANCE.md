# Governance

## Human Gates

Only four changes require explicit human approval:

1. Any change to `D5/X_Assumptions/`.
2. Any new axiom or change to the axiom-debt registry.
3. Signing or publishing a paper.
4. Any creation or modification of `Hearts.lean`.

Required-check configuration is also performed by a human operator; the repository records the permanent task but cannot claim that a hosting-platform setting is active.

## Meta-Layer Self-Modification

Changes to StrataLint, controlled vocabularies, agent charters, or the single repository specification require human approval and a dated Chronicle record. Chronicle history belongs to Git. The classifier does not classify its own authority: semantic classification and mathematical truth remain above the automated Gödel boundary.

## GROWTH-AUDIT: 性能候选队列

本节只登记增长与承载力候选,不定义 admission,不代表候选已获益。规范性性能账合同见 `docs/develop/spec/golden-ledger-repo-spec.md` A21。

P1 数据成熟阈统一为:目标 cohort × workload × kind × stage 至少有 30 个成功可比样本,覆盖至少 30 天,连续 14 天 observation/误报率均低于 5%,且最近窗口未发生 runner、workload 或 schema epoch 漂移。阈值未满足时,以下项目保持文档级候选,不得实施或声称收益。

| 候选 | 启动条件(P1 数据成熟后另须满足) | 待验证预测 | 收据边界 |
|---|---|---|---|
| 判官树缓存 | 2026-08-15 记录的 `ci.yml` judge-cache 已退役,其收益未按 A21 P2 结案。当前 `ci-push.yml` 的 engineering 构建候选 DLL,以绑定候选身份的工件交给 current 与 `ci-pr.yml` 的 delta;不再维护独立判官地址适配器。 | — | — |
| lake cache 持久化 | 2026-08-15 记录的配置/源码地址回退层级已退役,其收益未按 P2 结案。当前 dependency/project/report 共享 manifest 的 resolved mathlib revision 分区,二进制按 OS/arch 隔离;缓存只作增量种子,PR 只读,dev push 在生产成功后保存。 | — | — |
| corpus 并行评估 | 〔勘注 2026-08-15:启动条件不可满足——`conservative` 阶段随保守扩展重放机器于 2026-08-12 整体退役,gate 已无该栏;候选关闭(不进入实验)。〕 | — | — |

候选一次只允许启动一个。结案必须引用 A21 的 P2 内容寻址 before/after 收据;无收据时状态只能是“候选”或“实验”,不得改写为“已优化”。
