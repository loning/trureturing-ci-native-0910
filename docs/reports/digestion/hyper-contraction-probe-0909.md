# RH 下的超几何收缩: 判形探针 (2026-09-09)

**第一硬要求:** 对目标及每个子命题,先尝试仅由钉版 Mathlib 实例化、冻结件投影及规范化改写(含 `sq_nonneg` + `linarith only`)得到;成功即记 `bind-only` 并停止该部件的证明工作。无法给出 `why_not_bind_only` 的部件记 `likely-bind-only`。

产地(第 5.2 条): 无额外 skill,单席 codex-cli 探针直接检索与自查;零实施席、零评审席,无多席共识,无 orchestrator 独立亲验。用户 brief 的猜测仅为输入,不算本席读数。runner 阶段为 `thinking`。

## 范围与预登记

- 工作树: `/Users/auricstudio/trureturing-hyper-contraction-probe-0909`。
- 分支: `lane/math/hyper-contraction-probe-0909`;起点与当时本地 `origin/dev` 均为 `5a29f572a2b0f4dc207528a819efe8552500d86e`。
- LANE: #6160;相关留档: [#6503](https://github.com/the-omega-institute/trureturing/pull/6503)(已通过 GitHub API 读取正文)。
- source_id: `quantum-rh`;目标 atom: `bb2f81213482f52a1bbf2bbfed1f7fe097d2d9f4949ebb55dc0da2e94d4f1f45`。
- Lean: `leanprover/lean4:v4.33.0`;Mathlib: `db584cd6d46c92f209a44c0f1c829460d327499d` (`lake-manifest.json`,inputRev `v4.33.0`)。
- 按 Q1 -> Q2 -> Q3 -> Q4 顺序;无法回答即如实停在该问。探针不实施完整证明、不 deposit、不冻结、不开 PR、不改消化账。
- 拟议而未确认的逃逸位置: 用户猜测的首一消失多项式构造及任意 `r` 的估计/极限。必须先尝试绑定消去;当前 `escape_witness = null`,不预判 content。
- 目标始终是 **RH 条件下** 的结论;本席不作无条件结论,不声称推进 RH。

## 进度

- 规则读取完成: `CLAUDE.md` 全 764 行已分段读完(首次整文件输出截断,随后补读),`agents/CONTEXT.md` 已读。
- Q1: 目标 atom 已全文读取;源卷定位中。
- Q2: 未进入。
- Q3: 未进入。
- Q4: 未进入。

## 检索留痕

计数口径: 下列命令读取本工作树;词法检索只作定位,零命中不等于语义不存在。后续正则对照统一用 `rg` 或 `git grep -P`,不用 `-E`。

| 批次 | 命令 | 读数 | 边界 |
| --- | --- | --- | --- |
| 0 | `git status --short --branch` | 0 个改动,分支跟踪 `origin/dev` | 开工读数 |
| 0 | `git rev-parse HEAD origin/dev` | 两者均为上列起点 | 尚未 fetch,不代表远端此刻 tip |
| 0 | `rg --files -g AGENTS.md -g CLAUDE.md -g '*quantum*' -g '*6503*' -g '*probe*' docs agents` | 4 路径,均为 `docs/reports/convolution/` 既有探针 | 文件名筛选,未命中 quantum 文件名不等于无源卷 |
| 0 | `cat lean-toolchain lake-manifest.json` | 上列 Lean/Mathlib pin | 只读 pin,未构建 |
| 1 | `rg -n '超几何收缩\|量子.*黎曼\|quantum-rh' docs/develop/theory Meta/Digestion/sources*` | shell exit 1: `no matches found: Meta/Digestion/sources*` | `rg` 未执行,不是零命中;后续去掉臆造路径 |
| 1 | `cat Meta/Digestion/atoms/sha256/bb2f81213482f52a1bbf2bbfed1f7fe097d2d9f4949ebb55dc0da2e94d4f1f45` | 1 atom 全文,目标与 brief 一致 | 原子确未定义 `mu` 与 `h_n`,且证明段未论证严格正性 |
| 1 | `rg -n '^lean:\|LEAN_ARGS\|atom-context\|^help:' Makefile` | 6 匹配行 | 只定位 make 入口 |
| 1 | `gh issue view 6503 --repo the-omega-institute/trureturing --json number,title,body,url` | 1 正文;URL 实为 PR #6503 | 正文转述筛选席:第 1 名欠实际测度、变分识别、严格正性;未在该正文点名矩/Gram 接口 |

持久化: 初始化提交 `7db305209a` 已推送,远端本探针分支已建立。后续各批同样提交并推送,最终完整 SHA 清单写入 runner `result.json`。

## 明确未主张

未证该定理;未主张可证;未主张检索穷尽;未主张与 RH 有任何蕴含关系。尚无 Lean 片段或构建结果。
