# q_d 家族剩余四条分诊（LANE #6160）

产地：runner thinking 席；无 skill，Codex 主循环直接检索、探针与单点自查。零独立评审席；不冒称共识或 orchestrator 亲验。

基准 `e34699c5198180cee56093ee6995eab47c4698fc`，分支 `lane/math/qd-family-triage-0909`。先全文读 tracked `tools/scripts/agent/probe-brief-note.txt`、`CLAUDE.md` 和 `agents/CONTEXT.md`。根目录 `family.json`、`candidates.json` 是既有未跟踪输入，不进入提交。

预登记：承认 B1 已判 bind-only；Q 固定采用 `(p.comp (C (-1) * X)).reflect d`，次数政策 `natDegree ≤ d`。全域多项式和非零点倒数公式分开。B1.1 预期仅剩顶项归一化与 FTC。B3 候选逃逸是简单临界点的留数符号与箭头特征多项式/严格正谱的等价；B4 候选是箭头二次迹或留数和到系数的恒等式；降阶推论候选是严格正根域保存（含重根），随后塔上归纳。以上全是待测预测，不是结论。

停止：四条全判即结束；不降低逐条证据门槛。brief 未给总时长数值，本席以开工后 60 分钟为工作窗口、30 分钟为中点检查（起点 2026-09-09 08:12:31 UTC）；未改仓内或 runner 预算常数。中点若不足两条即停并列出未判 atom。仅报告与临时探针；禁止生产模块、cover、deposit、PR。

第一批检索原始收据：[search-01.json](qd-family-triage-0909/search-01.json)。所有阴阳对照均使用相同的 `\b` 正则特性；未命中不是不存在性证明。

已实查：`NormalizedJensenDegreeLowering` 的冻结 state pin 为 `sha256:ee43a04a542df25237818cbfeeb29bb1abaed956f90db04822d08e8f413d50b4`；任意实系数序列、d≥2 的降阶恒等式可接。B1 先席已提交报告读取自 `c58ed1b7d24efea45d8e077197bd284aaa45a534:docs/reports/robin/jensen-b1-0909.md`；其已验部分仅作为当前新增探针的前置，不冒称冻结 API。

## conclusion（增量）

`screened=0`。四条尚未给判词。

- `1e414ffb45d7fcaa9536a956298c4e291f91a2e310f112d2cf8419518caefd1a`：待 B1.1 探针。
- `2bc63109d666c92a11aa641dbeae45bc08e3f4f939bc5ce4406a75e5d86d03b6`：待 B3 探针。
- `c0a72a217fb966246fd4a48a809795cdc539435d1e88d1a10d041a9bcd9ed98d`：待 B4 探针。
- `cd2ad7f9986ee06ef6a8ac86aa7834a19d836483eaa1475b57396f3ba7ae536a`：待降阶探针。

`nonclaims`：未落地；未 cover；未 deposit；未开 PR；未主张检索穷尽；“未命中”不是“Mathlib 里不存在”的证明；未证四条目标；未主张 RH 的任何蕴含。未打开的外部文献为 `ASSUMED-UNVERIFIED`，不承载本判词。
