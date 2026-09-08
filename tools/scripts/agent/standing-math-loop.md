# 常设数学形式化循环(5040 / 量子 RH)—— 跨会话、跨驱动机的接手书

**这份文件存在的理由**:该常设目标由 τ=0 owner 定为**长期**目标,而单个会话的定时器是
`session-only` 的 —— 会话一结束,循环就没有载体。**器住仓内**(第 8.9 条):
把循环协议、常设单登记表与已作出的裁决写进仓库,任何驱动机的任何会话都能据此**从当前状态续跑**,
不必重新发现、不必重判已判过的事。

**这不是新政策**,是既有 CLAUDE.md 条款与既有 issue 裁决的**索引**;冲突时以 CLAUDE.md 与 issue 判词为准。

---

## 一、固定循环(七步,owner 原文形态)

1. `git pull --ff-only origin dev` 同步主检出;`gh pr list --state open` 查**自己的**在飞 PR ——
   三门绿的合入、**红的读原始日志归因**(第 8.5 条硬门:**禁猜**)。
2. 读常设 LANE **#6160**,按「**探针先于实施**」派席。
3. 读 `Library/notes/pntplus2026mertens.md` 的 Gronwall 上包络 DAG,挑最靠近叶子的一条派实施。
4. **派席前先量**:`memory_pressure | grep -i 'free percentage'` 与 `pgrep -f 'codex exec' | wc -l`。
   **本机多驱共用,并发的分母是「可用」不是「总」容量**;内存 <50% 或别人已有 ≥6 席时,自己只派 1 席。
   `pgrep -lf 'codex exec'` 的 `-C <worktree>` 字段可直接分辨哪几席是自己的。
5. **每份实施 brief 的第 1 条硬要求恒为**:先尝试只用钉版 Mathlib 直接实例化 + 冻结件投影 +
   规范化改写(含 `sq_nonneg` + `linarith only`)重证目标,**成功即停手报 bind-only,不建模块**。
6. 仓内检索一律 `git grep -P` 或 `rg`(**`-E` 不支持 `\b`,静默零命中**),阳性对照必须带同样的正则特性。
7. **每轮结果追加到 #6160,不另开 issue。**

**没有可派的活时**:跑一轮 `make digestion-readiness`,读数追加到 **#5952**。
**若它报 `DIGEST_STATUS_INVALID Raw Lean report is missing modules`,那不是账坏**,是主检出的
raw Lean report 陈旧;正序是 `merge → make lean-report → 再判`(顺带就把 donor 热了)。

## 二、席位布局(owner 定)

**1 席 GPT PRO(nyxid-oracle / ChatGPT Pro),其余全 codex-cli;实施一律 codex-cli,可 3 并行。**

- **GPT PRO 席的默认去处是 #6494**(见下)。派法:`tools/scripts/agent/nyx.sh ask <brief> <out>`。
  **`ask` 返回 `NYX_TIMEOUT`(exit 3)不是失败** —— 任务仍在跑,用 `nyx.sh fetch <task-id> <out>` 续等;
  **重投会白占一张并发额度**。脚本按池排名遍历,坏 worker 脚本版本(如 `cdp-1.3`)会被跳过。
  **brief 必须带仓库地址**(第 5.11 条),它没有文件系统,只能靠公开 URL 独立核实。
- **codex 席**:`skills/sshx/scripts/run-codex-worker.sh --flight-id … --attempt … --stage … --work-target …`,
  brief 走 stdin 重定向。`--stage` 只收 `thinking|implementation|review|termination`。
- **探针 / 判形 / 筛选 / 地图席的 brief 一律粘 `tools/scripts/agent/probe-brief-note.txt`**;
  deposit 席粘 `tools/scripts/agent/deposit-brief-note.txt`。
- **判活看活动不看时长**:席位远端分支上是否在长出提交,比 `%CPU` 瞬时采样可靠得多 ——
  这正是「每完成一个部件就 commit+push」那条纪律的副产物。

## 三、常设单登记表(**接手先读这四张单,别重开**)

| 单 | 判什么 | 载体 | 状态 |
| --- | --- | --- | --- |
| **#6160** | 常设 LANE 主账:每轮结果只追加到这里 | orchestrator | 活 |
| **#6494** | **arXiv 开放问题搜寻**(owner 常设目标里独立的一条) | **1 席 GPT PRO** | 活;**GPT PRO 席的默认去处** |
| **#6377** | 深度推理(本仓已有资产能否往前推) | GPT PRO | **已降级为按需**;再入条件写在单里 |
| **#5952** | `make digestion-readiness` 读数 | orchestrator | 无活可派时的兜底 |

**#6494 的候选资格是五项**(精确定位含逐字原文 / 档位 / 未解决核对 / 仓内接口 / **`why_not_bind_only`**);
**空交付是合格交付,主动淘汰计入有效产出**;停止判据:**连续三轮空交付即降级为按需触发**。

## 四、已作出的裁决(**不要重判,直接引用**)

- **r14–r17**(Narayana n=31 / Archon-FirstProof / TotallyPositive / Laguerre–Pólya 逼近):
  **四条全部不可派**,逐条依据见 #6160 第 25 轮。r14 的产物是普通正向有限实例,
  按第 3.3 条 `certified-instance` 与 `bounded-enumeration` **只可走经验证的 `refutes`** ——
  **可跑 ≠ 可入账**。除非 #6361 的 τ=0 裁决改变政策,该方向为 `blocked-on-adjudication`。
- **Gronwall 上包络 DAG:无剩余叶子**。`Library/notes/pntplus2026mertens.md` 的那张表是计划,
  其六条 `self` 已由已冻结的 `D5/S3/Weil/GronwallUpperEnvelope.{small_prime_product_le,
  large_prime_count_le, large_prime_product_le, sigma_split, gronwall_upper_envelope}` 与
  `GronwallLowerEnvelope` 闭合;勘误段在该文件内(**用英文写的**,按中文关键词 grep 会漏)。
- **量子 RH 线:按第 7.11 条④停止投入**(2026-09-09)。两席探针共 4,504 s,双双
  `likely-bind-only` / `escape_witness: null`。根因:全线共享缺失前置「**实际测度 / 变分识别 / 严格正性**」,
  而它又卡在 **ξ 的 Hadamard 分解** —— 仓内没有,钉版 Mathlib 的 `ZetaZeros.lean` 那 6 条里也没有。
  **改判三条件预登记在 #6503**,满足任一即可重开。
- **5040 线**:筛选得 tier ① = 0、tier ② 4,且那 4 条**全部阻塞在同一个外部能力缺口(PNT / Landau 显式估计)**。

⟹ **两条被点名的线目前都撞在准入政策与上游能力这两堵墙上**;
产出来自**它们的邻接面**(有限自由卷积 / 匹配多项式 / Laguerre–Pólya),那才是当前的活工作面。

## 五、当前活工作面的状态(2026-09-09)

**CMP arXiv:2502.00254v2 Conjecture 3.13**:`m=2` 与 **`m=3` 均已冻结**
(`D5/S3/Zeros/Convolution/GribinskiDegreeTwo`、`GribinskiDegreeThree`、`GribinskiDegreeThreeDiscriminant`)。
`m=3` 来自 **#6494 第 1 轮 sweep 的唯一合格候选**,当日证出、落地、冻结(#6525 → #6532 → #6533)。
**下一个未认证的有限情形是 `m=4`**;成本标尺见 #6160 第 42 轮(`m=4` 双色匹配项 176,400)。

**同篇 Conjecture 5.3(degree-8 commutator)**:已裁决**只派有界成本 probe**,不派完整装配。

## 六、接手时的自查(照序问,答不出就先去量)

1. 主检出停在 `dev` 吗?donor 热吗(`make lean-cache-ensure` 的收据看 `project_olean_state`)?
2. **在飞 PR 里哪些是我的**?别人的只普查不动(第 5.10 条「自己的才回收」)。
3. 我要派的靶,**在第四节里被判过吗**?判过就引用,别重判。
4. 这个靶的**难点是什么**?答不出就别派 —— 按成本排序等于按「Mathlib 已备齐」排序,
   等于按 bind-only 排序(记忆 `easy-targets-have-no-escape-witness`)。
5. 同一症状**这是第几次**?第二次就停手去修根因(第 7.11 条),不要处理第三个实例。

## 七、这份文件的边界(不冒领)

- 它**不是**机器门:没有任何 lint 检查某个会话是否照它执行。它是**数据**,靠自觉与评审。
- 它**不替代** CLAUDE.md;凡与 CLAUDE.md 或 issue 判词冲突,**以后者为准**。
- 第四、五节的状态**会过期**:引用前先对当前 `origin/dev` 复核一次
  (第 2.8 条:记忆是被前一次判断筛过的,只有数据能纠正它)。
