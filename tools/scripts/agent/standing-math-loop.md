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

---

# 追加(2026-09-09 会话末)—— **第四、五节的更新与两条结构性发现**

按第七节,第四、五节会过期;本节是**追加**,不重写上文。冲突时以本节与 issue 判词为准。

## 八、第五节的更新:CMP 线的当前边界

- `m=2` / `m=3` **均已冻结**;`m=3` 由 #6525 落地、#6533 冻结、独立评审 `approve`;
- **`m=4` 已判 `blocked-on-cost`**(#6160 第 51 轮):`H23 = s4·s6 − s5²` 展开实测 **152,635** 项,
  对照 `m=3` 证书 **767** 项(**≈199×**),越过预登记阈值 50,000。
  **上文第五节写的「下一个未认证的有限情形是 m=4」已不再是可派的靶。**
  重开条件:出现**换过表述**的证书形态,须①根差坐标真实输入映射 ②可执行有限判别范围 ③失败含义明确。
- 该轮的**正面资产**:四次「四根全非负」的 **19 条充要条件**(4 条系数符号 + 15 条 Hankel 主子式,
  Newton 幂和 `s0…s6` 显式,出处 Sylvester 判据)—— **换 Γ 后仍可用**,不必重求。

## 九、发现一:**`make digestion-readiness` 的 `deposit` 队列不是「可覆盖工作」的全集**

**这条纠正了本单第一节兜底分支的默认读法。**

- 那 507 条 `deposit` 之外,还有 **18,175 条 `not-formalizable`**,其中 blocker 恰为
  `non-assertion-ast-kind:section` 的有 **10,906 条**。该 blocker 说的是 **atom 的 AST kind**,
  **不是「内容不可形式化 / 不可覆盖」**;
- 本会话产出的**全部** cover 与 `robin_seven_smooth`,**都来自那个桶,不来自 `deposit` 队列**;
- 两次预登记的预测钉住了这一点:第一次(以为 cover 会让 `quantum-rh` 60→57)**错**;
  按修正模型再赌一次(cover 三条 `:section` 应使 `not-formalizable` **恰减 3** 而 `deposit` 不动)**全中**
  —— 实测 `18,178 → 18,175`。
- **边界(实测,别推广)**:`:section` 里「标题即定理 ∧ 含 `\boxed`」的候选在 `quantum-rh` 有 **164** 条;
  **`zeckendorf-euler-5040` 的 537 条中只有 9 条(1%)标题含定理类词,两者皆有 0 条** ——
  **这条窄缝不延伸到 5040 卷。**

**⟹ 兜底跑 readiness 时,`deposit` 计数不动**不等于**没有可做的活**;要同时看 `:section` 桶。

## 十、发现二:**「该不该建模块」这一维,orchestrator 系统性偏乐观**

第 1 条硬要求(先试 bind-only)本会话**生效 6 次**,**其中 4 次是 orchestrator 判断该建、实测说不该建**:

| 靶 | 实测 |
| --- | --- |
| U1 正拼接的 Lean 桥 | `Matrix.…fromBlocks₁₁`(`PosDef.lean:563`)一步 |
| Schmidt 系数与 θ 无关 | bind-only,**且 orchestrator 给的理由被数值反例打掉**(一般对角酉**不**保持 Schmidt 系数) |
| Robin 任意有限素数集一般化 | `sigma` 积性 + `geom_sum_eq` + `Finset.prod_*`,`no_enumeration_confirmed: true` |
| Jensen 定理 B1 与推论 B1.1 | `q_d(x)=x^d P_d(-1/x)` **就是 `Polynomial.reflect`**;两条均 bind-only |

**批量分诊比逐个发现便宜一个数量级**:150 条 `needs-lean` 的 Mathlib 分诊一席 4,436 s 得
**A=7 / B=41 / C=102**;而单条发现每次约 2,000 s。**遇到同族多条时,先派分诊席,不要逐条派实施席。**

## 十一、两条可复用的落地形态

1. **`rule-11-upstream-wrapper` 是可用的准入路,但两半都要写**:命中的上游声明 + **使包装成为必要的 atom 子句**。
   本会话据此落了 3 条(#6591):`SchurMinimum` 66 行 / `DivisorParity` 71 行 / `MonitoredReturnConservation` 94 行,
   **各 1 条公开定理、0 `sorry`**,头部 `anchors: [mathlib/module/…]` 把上游引用做成机器可见字段。
   **判据**:atom 要的是「取到的最小值」而上游只给分解 ⟹ 需要 `IsLeast` 接口 —— 这类**差**才使包装必要。
2. **有限枚举必须私有**(第 3.3 条:正向有限实例禁止准入)。`robin_seven_smooth` 的落地形态是
   **1 条公开 ∀-定理 + 12 条 private**,482 个有限情形全在私有引理里。

## 十二、静默错误:一个会编译绿的假命题实例(照抄,别重犯)

`q_d(x) = x^d P_d(-1/x)` 若按字面用全函数化的 `-1/x`,**在 `x=0` 处给 `0`,而正确值是 `p.coeff d · (-1)^d`**。
**正解不是「排除 `x=0`」,而是用 `Polynomial.reflect` 定义**,让多项式恒等式全域成立、倒数公式只在 `x≠0` 成立;
`degree_policy` 用 `natDegree ≤ d`,**不假设次数相等或首系数非零**。

## 十三、容量:q=2 是实测,3 并行有一条**尚未测过**的路(预测写在跑之前)

**宿主的硬上限(2026-09-10 读数)**:`sysctl -n hw.memsize` = **16.0 GB**。这是 `U_内存`,不是感觉。

**已测**(第 10.1 条口径,`r_i` 取属主的实测峰值收据,不用代理量):

| 量 | 读数 | 采集条件 |
|---|---|---|
| 单席 `make lean` 峰值 RSS | **6.28 GB** | donor 在 dev tip |
| 单席 `make lean` 峰值 RSS | **17.34 GB** | donor 落后 144 提交 —— **同一条命令,差 2.8 倍** |
| 单席 `make lean` 峰值 RSS | **5.50 GB** | A392714 席自报(`5907873792` bytes),独立佐证 |
| 两席并发峰值 | **10.47 GB** | 463 次采样,两席均存活 ⟹ ≈5.2 GB/席 |
| `make lean-report` 峰值 | **4.18–4.43 GB** | **单个** `lean` 进程加载约 3962 个 olean |
| 单个最大 `lean` 进程 | **3.38 GB** | —— |

⟹ **q = floor(16 / 5.2) = 2**。三席实际被杀过一次,与该算式一致。

**donor 落后是最贵的一项,且它免费可修**:6.28 → 17.34 GB 只因 donor 落后 144 提交。
**开轮前必须先把主检出建到 dev tip**;`make worktree` 的 `donor_behind_base` 字段就是这个读数,
它 > 0 时那条 lane 会自己重建,内存与墙钟同时翻几倍。

### 预登记的预测(第 2.6 条留底;**写在测之前**,不许事后改标)

**假说**:单席峰值的主要成分是 **lake 的模块级并行**,不是单个最大模块 ——
依据是 3.38 GB(最大单进程)对 6.28 / 5.50 GB(整席),差额约 2.1–2.9 GB。

**预测**:把席位的 `make lean` 换成 `tools/scripts/agent/serial-lean.sh` 的逐模块串行后,
1. 单席 `make lean` 峰值 RSS **≤ 4.0 GB**;
2. 三席并发(各自串行构建、`lean-report` 跨席串行)峰值 **≤ 12 GB**,**三席全部存活**。

**判翻(任一成立即预测错)**:单席串行峰值 > 4.0 GB;或三席并发峰值 > 13 GB;或任一席被 OOM 杀死。

**成本判据(与正确性并列,不许只看内存)**:串行会拉长墙钟。
若单席 `make lean` 从 **63 s**(热 lane 实测)升到 **> 600 s**,则 3 并行的吞吐收益被串行成本抵消,
**应判为不值** —— 那时正解是加内存,不是串行。

**测法**:等一个 slot 空出来再测(两席在飞时起第三个 Lean 进程,正是三席 OOM 的形态)。
必须在一个 `donor_behind_base > 0` 的 lane 上测 —— 热 lane 的 `make lean` 是近似 no-op,量不出峰值。

**已知的、不可约的那一项**:`lean-report` 的 4.4 GB 是**一个** `lean` 进程加载整个环境,
串行化解决不了它。故即便上面的预测成立,**跨席的 `lean-report` 仍须串行**,
而当前**没有任何机制做这件事** —— 这是一条具名缺口,不是已解决项。

## 十四、结算纪律:两个我今天踩到的坑

**(a) 合入的 PR 不等于形式化落地 —— 开口前先 `gh pr view <n> --json files`。**
A392714 的 #6669 状态是 MERGED,我据此把它写进「dispatch 8 条全部落地」。
实际读数是**单文件** `Library/Words/codex2026a392714probe.md`:
**零 D5 模块、零冻结、零 coverage、零 `OpenProblemResolutionClaim`**,席位自己端化为 `blocked`。
正确记账是 **7 条冻结 + 1 条 blocked**。把探针笔记算作落地即第 2.4 条冒领。
**判据**:说「落地」之前,查 `Golden/Frozen/state/**` 下有没有那个模块的状态片;有才叫冻结。

**(b) 亲验要验席位写下的那套编码,不是验我自己的模型。**
派席前我用自己的 Python 模型复现过 OEIS 的 DATA,那只证明**我**没读错源句。
结算时要做的是另一件事:**把它落地的 Lean 定义逐字重写成可执行代码,再看它是否复现 OEIS 自己的 DATA**。
A382427 的做法:把 `HasConstantBlocks`(`Finset (ℕ×ℕ)` + `Set.InjOn (b.1*b.2)` + `∑ replicate b.2 b.1 = m`)
与 `runSums`(`splitBy (·==·)` 后求和)照抄成 Python,两侧各自独立命中 `1,1,2,3,4,7,11,14,19,28,39,50`。
**两侧各自命中**这一点很关键 —— 它排除了「定义读错了但两边一起错」这条替代解释。
这一次没查出问题,但它是「席位说忠实」与「我查过」之间的全部区别。

**(c) 复算不一致时,先确认两边说的是不是同一个对象。**
我曾复算不出席位报的 `1,1,3,15,121`,标了 `ASSUMED-UNVERIFIED`。
结清时发现:那是它某个**对合尝试的剩余项数**,不是合格集合的大小;
合格集合 `1,3,35,1001,53109` 与我的读数**逐项相同**。**双方都没算错,是我读错了对象。**
