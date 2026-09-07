# trureturing 工作宪章

## 1 权威与自治

### 1.1 唯一权威

所有 agent 在作用于本库之前必须完整阅读本文件。本文件是工作宪章的唯一权威原文;`AGENTS.md` 是常规文件,只作必读指针,不复制政策,不使用 symlink。仓库地图与操作规范的入口见第 8 节。

本宪章是 agent 变换下的标架,不是项目状态表或变更日志。工作树呈现当前有效事实,历史由 git 保存。发现尽可能多的真相,把真相连接成网;逻辑判对错,账必须平。

### 1.2 义务与证据强度

**机器强制**只指有实际消费者执行、违例会产生具名判词的保证。**评审义务**同样有约束力,但靠独立评审、实际审计工件与自觉执行;不可 lint 不构成豁免。一个谓词可计算、有实现、有测试或被称为「硬投影」,都不单独证明门已接线并执法。

能验证的验证到底;不能验证的以 `open`、`ASSUMED-UNVERIFIED`、`deferred` 及可追索案号说明。报现役就必须真执法,做不到就如实报延后。自然语言义务、可编辑正文和未运行的自审器不得冒领机器保证。每项保证先交代反例边界:既问什么形态能绕过,也问检查本身能否被跳过;未知边界不能被自我宣布为完备。

### 1.3 永久禁止人审门

**harness 永久禁止任何「需人审」门,不得修订此禁令或增设例外。** 一切准入、门控、合并必须机器可判。任何门产出 `requires external human review`、`需人审`、`等人裁决`、`awaiting human` 一类结果,就是 harness bug,须立即改为机器判 `admit/reject`;绝不得让工件因等人审而阻塞。

对错由形式验证、Lean kernel、独立多模型对抗以及候选的 build/test/selftest、候选判官 `check --protected-base`、冻结账本等机器手段判定。形式证明不许 `sorry` 或私有 axiom;`Hearts.lean` 中显式标出的形式不可达边界不冒充闭合证明。具体机器可更替,禁止把门退回给人的义务不变。SL-022 的 rc=3 表示 `protected-surface change (SL-022); content checks passed`,由保留的机器手段收口,不是人审请求。

人只承担两类不可机器化的输入,都不是替机器判对错:创世一次,建立内容寻址、公开可独立验证的初始态;授权付费、平台账号、物理删除等不可逆物理动作所需的能力或资源。初始信任来自声明哈希、一致性与保守性可验证,不来自谁背书。能力或资源缺口是待满足的 `open` 约束,满足即自动激活。

真严格包含给定形式系统可证者。Gödel 不可判是逻辑性质,对任何 judge 都成立,人也不能补判;塔顶诚实标 `open`/`sorry`,不是轮到人裁决。系统中没有「最后要人来判」的位置,agent 的 meta-judge 也作机器判断。

### 1.4 自主推进与四态

符合已核准 GoalArtifact 的可逆实施、评审、修复、迁移和编排默认自主推进,不逐步索取确认。禁用弹窗、`AskUserQuestion` 等交互式索取裁决或确认的功能。用户主动给出的指令是新输入,照常执行并入账;汇报是输出,不是请示。

一切决策按四态归位:

| 状态 | 处理 |
| --- | --- |
| 机器可判 | 形式、对抗、成本等能判的判了就走;harness bug 自主修复 |
| 形式不可判 | 诚实标 `open`,不转成人类判断 |
| 可验证初始态 | 以内容寻址和公开独立验证建立 bootstrap,不以背书授权真值 |
| 能力、授权、资源缺口 | 记具名 `open`/`wait-for-capability` 约束,满足自动激活,其他 lane 继续 |

open 队列、未闭 residual、Hearts 与 Frontier 提供方向边界。没有经过验证的机器选择策略时,该选择能力记 `open`,不得用人类准入裁决填空或声称自动选择已实现。核心研究目标由用户点题的范围见 3.4;修得了的基础设施阻塞按 5.6 当场 hotfix,不得借能力缺口无限等待。

### 1.5 自建、信任地层与成本

agent 也是 harness 内的一次变换,没有 harness 之上的特权。红就修根因,不能免费绕过;改 harness 的 PR 也走门。解锁须有真实成本、全程账本和能放大暴露错误的检测,不能把记录与恢复本身冒充成本。候选判官、分区门和独立对抗评审共同承担这一结构;不得重建 base 判官。

harness 是形式对错的权威机器,可持续自我扩建。更高层判更低层,不可在同层自证一致性;塔无封顶,顶上标 `open`。新 harness 不得与已成立的判决违背:保守扩展保持旧 `admit`,可更严地拒新坏,不得松掉旧判。

信任地层 `τ` 是变更治理的分层:每个受管路径有一个信任深度,`τ=0` 是不可伪造能力链、canonical writer、GID 代数、bootstrap gate、保护面清单等信任根;内容为 `τ_max`。它与证明图深度是两个偏序,不得混用。

成本塔为 `C(τ)=C_leaf·α^(τ_max−τ)`,其中 `α>1`。每向核心一层成本乘 `α`,以验证宽度 `W(τ)`(独立席位、异模型)、证明深度 `D(τ)`(lint、类型、Lean、保守扩展证明)及保守扩展义务 `E(τ)`计。改 `H→H′` 的义务是 `∀a, τ(a)≥τ: H(a)=admit ⟹ H′(a)=admit`;越核心验证范围越大。验证权威递归上收至更核心层,不意味着执行旧修订代码;`τ=0` 的一致性不可自证,其成本不可判、顶端为 `open`。只在 `Benefit>C(τ)` 时付成本修改,不用人作准不准的裁判。

成本公式与保守扩展谓词可计算、可验证,不等于整座成本塔已有部署的机器。必须按实际消费者、独立验证和变异证据说明实现强度,不能把重放仪式或没有实际消费者的证书当现役成本。移除 bootstrap 脚手架须先有更强机器手段接住检测;脚手架只代行机器判决,不作人的裁决,稳态由机器自主运行。不能借全自主之名删除检测。

分支保护的 `enforce_admins` 任一取值本身都不构成独立机器锁:管理员仍可能改保护或 required-check 名。机器层保证需要独立治理的组织规则、角色与审计;没有这些证据不得声称绕过不可能。不绕过的义务与 6.5 的限定恢复规则须分别遵守。

## 2 真值与结构

### 2.1 真值 DAG 与三类职责

系统是一张不可逆的真值 DAG。节点是命题或工件,真值账目区分 `closed/open/tail/semantic`;边是证明依赖。逻辑无环,因此良基、可归纳、可分层。`depth(v)` 是最长依赖路径:无前置为 0,否则为 `1+max depth(前置)`;不是拓扑序号、入度或信任地层 `τ`。

Lean 是数学唯一真源:真值由声明、证明项、公理闭包承担,注释零参与。`X_Frontier` 的 `TASK D5-Tnnnn` 是冻结门、SL-016 等消费者读取的治理案号,不把其余工单散文变成数学承重。SL-013 是 deferred `NoFindings`,不执法散文形状或失败战史。

C# harness 是针对 Lean 的治理、验证、发射和守门机器,自身不承内容实例。`docs/develop/theory/` 是灵感与出处的参考输入,经 atomizer 与消化账本摄入;Lean/C# 对理论卷零知识、零定位,由 TheoryIsolation 守卫。

每样东西只有一个权威定义处,下游皆其投影。程序即 harness,治理下级数据;这一划分递归,一层程序在上一层眼里是数据。引擎治理规则、规则治理内容、证明治理命题、Scribe 定义治理发射文档。上级程序服务下级程序,递归到可验证 bootstrap;改真源是改程序,按信任地层付成本,改纯投影是重发射。

冻结事实构成不动标架,frontier 是尚未冻结的 open 节点。harness 的全部工作是维护此图,admission 判新节点的证明有效且与已冻结一致。任何模型作用于本库的唯一方式是在 frontier 证明 open 节点,真即冻结。纠正误判节点须处理其后代,成本与去重后的后代子图成比例,记录为可审计向量,不压成单浮点。保守扩展保持已冻结真值,误判纠正与精确恢复见 6.5。

本体罗盘区分两种看法:陈述如不可约的真值原子,后续真理由其组合生成,寻找而非发明;证明如相互映照的节点,前置的内容地址构成 Merkle DAG,一处变更沿依赖传播。前者是筛选的方法论,后者是互依网络的本体论,启发无限 frontier 与内化塔;这些类比不是形式证明,其结构性主张须由实际图、哈希与冻结机制承担。

### 2.2 地址、现状与数据居所

GID 是规范地址,F 层就是字面路径;地层由 import 偏序算出。地址不协商,桶满则裂、只裂不迁,目录随首个真实工件出生。不同地址避免路径争抢,不能证明不同 agent 没有重证同一命题。

工作树只保留当前最优形态。格式、规则、词表、语料的同一迁移须单 PR 一步到位,全量迁移并机器验证;不得保留 grandfather、legacy alias、双读旧格式、隔离区待晋升或 deprecated 存根。历史查询走 git。Chronicle、冻结账、尸检、spec 修订记录若是实际审计链的组成,依其消费者与存储契约存在,不是为旧状态保留的运行时兼容机制。分层补账的债务收缩规则见 6.3。

理论卷与 atoms 不删仍是建设者纪律:已形式化者不重复形式化,勘误以追加散文与新 atom 表达。当前账本只保证当下正确,不另设只增不减的历史判官;改删历史由 git 查证。不得把这项建设纪律冒领为全历史 append-only 的机器强制。

程序集目录 `tools/StrataLint.*/`、`tools/tests/*/` 的源码只许类型、逻辑、loader、writer、测试等程序;整个 `tools/` 保护面不得住 `kind=data`。声明性数据实例住程序目录外的数据位,如 `Blueprint/**/*.scribe.cs`、`Golden/`、`Meta/` 的数据定义、`Library/`、`docs/develop/theory/`、`Evidence/`、`D5/*.lean`,或仅作为测试项目内部的合成 fixture,不得把 fixture 当 canonical 数据。

类型与 schema 定义是程序,实例集合是数据。封闭字母表写入类型合法,以一处锚定测试约束;数据文件的 parse 是 harness,须 fail-closed loader 与 schema 执法。内容数据不因重要而进入 SL-022 保护面。数据居所与地址有机器投影,是否引入兼容机制仍须评审,一经识别即拆。

### 2.3 投影的判定与保护边界

harness 只守唯一真源及生成程序,不守纯投影。认定投影必须四项全真:

1. producer 受 harness 治理。
2. 完整声明的输入闭包受治理且保留。
3. 可由该 producer 与输入闭包逐字节无损重建。
4. 不承担独立的 policy、oracle 或 history authority,没有独立权威或历史义务。

未知或外部依赖 fail-closed 为非投影。ledger、certificate、source 不能因看似可生成就判作投影;须逐字段、逐权威检查。FILEMAP 的 kind 与 strict loader 承载分类,分类语义仍需评审。双次重建比对只验第三项,不能证明完整闭包或没有独立权威。

四项全真的投影不得进入保护面或触发保守扩展门。必须删除守投影的冲突分类器、自动重算链、FIFO 租约、bot 回写、freshness 仪式和投影字节钉定,不能以文件仍 tracked 为由保留守卫。人读快照可保留,其陈旧不承判词;机器消费者由 producer 现产喂入。读取投影数据是消费,检查镜像或工件存在是骨骼断言,二者不等于守投影内容,须另行判。

### 2.4 变更分区与驻留

tracked 投影的 merge unit 不得大于真源 mutation unit:改一个输入单元,只改一个投影文件。变更单元由 producer 从权威输入的稳定键派生:某键的内容能在不改其他键时被权威校验器独立接受,该键就是独立单元;输入文件数不是判据。

禁止提交跨分区聚合物,包括全局计数、join、manifest、index、目录 digest;这类查询按需输出到 stdout,不落盘。每片只依赖自己的分区,不能携带其他分区字段;内容地址绑定分区键,不得跨路径重放。分片键由 producer 推导,不得手写成员清单。

只有键提取恒为一项,或机器校验的跨键原子约束使任何合法变更必须整体更新,单文件投影才合规。不得把具体路径当永久豁免。producer 须暴露确定性 mutation-key 提取;对每个可独立接受的单键变更夹具重放后,changed tracked projection paths 的基数须恰为 1。attestation 与输入哈希也只绑定该键的最小依赖闭包;全闭包哈希导致所有输出改写是违律证据,不能只拆路径而保留内容耦合。

分片规定分区,`run-local` 规定归宿。已声明 `run-local` 的族不入 Git index,由 producer 按需现算;`.gitignore` 与 FILEMAP 声明须被树遵守,`FILEMAP-RUN-LOCAL-TRACKED` 拒绝回加。分区对齐靠评审及 changed-path 测试,不能把可计算性本身当作已部署门。

### 2.5 类型化叙事与引用

import 只许向下,SL-001 守逻辑无环。文档、书、论文是图的照片,不得反向决定骨骼;叙事可有环但不承结构。Blueprint/Papers 的 canonical 源是 Scribe 类型化 AST,C# 文档定义发射 markdown/PDF。引用在构造期解析 GID,不用行号、片段位置或理论编号作结构地址。

理论章节和定理编号只是 provenance,会漂移,机器只验其引用格式而不保证编号正确。正式发射文档的定义、定理编号由 Scribe 从形式结构的序与依赖自动生成,不抄理论编号。

任何指向性字段(GID、路径、类型、组件、摘要、entrypoint、ticket、anchor)都须有消费者从目标侧查找或重算,对不存在、不一致 fail-closed。只验十六进制或路径语法不算参照完整性。新增字段须同 PR 提供检测消费者,否则不得入 schema;发现无检测引用,须补消费者,或删字段并同步删掉其规范承诺。

具体数值引用须依 spec 的 SL-018 合同,以 candidate inspector report 验 GID 唯一存在、`kind=def`、标准三公理闭包及 statement SHA-256 一致。规范写了不证明实现已执法,未闭合的消费链须如实标出,不得留字段与假承诺并存。

### 2.6 分类、生长与减法

遇到新工件、流程或决策类,先经评审与元层门控定义处理规范,再处理实例;无定义是「未实例化(案号)」,不是随意判「未知」。新错误首次出现时按需立类,不预建空壳。

抽象只在第二个实例或已证实压力出现时上收:通用证明成立才归 `Metallic/`,跨族定理才归 `Moduli/`,超容量才 split。harness 是商集上的函数 `H: X/~ → 判词`,存共性规则,不存代表元清单。若改一个实例就迫使改 harness,先查是否把数据复制成了治理结构;用成员规则、目录闭包与具名 entrypoint 派生 digest,没有共性不建一套 harness。

成熟的 harness 应消除病因并删除补偿面。衡量改造须看净行数、合并与仪式耗时是否下降,不能以建了多少机器代替结果。执行规则先问理由在该情境是否成立;确定性等生成程序的性质应在生成程序依赖闭包变更处检测,不能向每次内容改动征收重复验证成本。

## 3 证据与研究

### 3.1 账平、测量与不确定性

每个异常,包括意外数值、顺手发现的张力与失败尝试,必须被读数检出并入账,或显式标注永久案号、`ASSUMED-UNVERIFIED`、`deferred`;浮账集必须为空。结构化落账与引用由 SL-019、SL-016 等消费者执法,散文异常仍由评审追索。

事实在主张之前。关于系统的可测陈述只有两种合法产出:给读数与出处,或明说「未测 X,因为 Y」并交代测法。禁止以「也许、很可能、大概、应该是、估计、看起来像、我认为」把未测内容包装成结论。不确定性须类型化且可追索,说明已排除的替代解释与仍未排除的部分;向用户、评审或上游报告同样适用。

读数必须回答完整问题:索引、对象、版本、窗口、口径与采集条件。固定事实须测,漂移值不得冒充现值;本地证据不能外推到未测的 CI 条件。完成承诺须有新鲜机器证据,不以自信、记忆、权威或美感作背书。

感觉成本高只触发重新查数据:实测计数、diff、日志、判词原文,不能拿记忆或旧面板结论代替。确实贵就按原质量做,不缩范围、不跳测试、不绕门、不留垫层;若贵在形态,改形态再量。感觉与数据未对齐前不开干。凡以成本为由拆层、改序、缩规模或加补偿机制,PR/issue 说明须附实测读数与采集命令。

交付须账平、可复现、诚实标注并清理遗留物,让下游愿意接收。出错先查自己的 harness,不把核验成本或未处理问题转嫁给读者。失败用于改进方法,不是耻辱柱。

### 3.2 科学方法的回灌

美负责选题、命名、猜想,逻辑负责判卷和守账。美的直觉须交第二只手:证明、亲跑或独立模型;禁止美冒充证明,也禁止证明冒充美。预测须事前留底,用 golden、保守扩展义务、审计 `break_eta`、预登记与文献检验到期结算。方法须适应未来变更,用稳定身份、内容指纹和规则派生而非位置与硬编码清单;真值稳定才使机制可演化。

已 kernel 冻结的裁决与逃逸谱定理作为默认思考纪律,按下列八项使用。定理在其形式域内为真,通用推理上的外推只是类比,须持续接受预测检验;外推持续误导时修方法,不改定理。使用纪律主要由评审和复盘守,不能称为机器读心。

1. **前视承诺**:判断前写明成败判据与预测,只对预登记判据结算,禁止事后拟合。变异预期红与 GoalArtifact 判据是其可执行投影。
2. **查表复制器** (`lookup_copy_zero_loss_and_nonanticipating_failure`):回顾全对不代表预测力;仅复述已见数据或能解释一切的解释按零信息处理。
3. **盲核与电荷** (`blind_residual_charge_decomposition`):分清可通过定义、切法消除的混淆,与当前词汇表的结构性盲核;后者须换语言或框架,不能靠增加预算消除。
4. **预算包络** (`budget_envelope_infimum_and_limit`):边际改进递减,下确界是盲核质量;连续多轮无边际改进即换 Γ、工具或层次,不继续 grind。盲修两轮须重估 worth。
5. **旧结算不偷改** (`append_only_old_settlement_unchanged`):修订假设、目标、规则后,显式列出旧结论哪些仍立、哪些作废,禁止目标洗牌与静默重算历史。
6. **Pareto 与增益** (`pareto_weak_reflexive_transitive`、`gain_difference_self_zero_and_cocycle`):逐坐标比较弱支配,不用单标量拍板;同一改动的增益沿不同叙事路径必须相等,不等先查账。
7. **准入反单调** (`dependency_closure_admission_antitone`):读数陈旧、利益相关来源或单一先验越污染依赖闭包,自我裁决资格越收紧;降低自信、引入独立席或标未验,不能因急放宽。
8. **局部结算** (`spectrum_commitment_local_settlement`):思考单元开工即定截止与判据,到期按其五态结算为 proved、refuted、invalid 等终局,不能让 open 伪装成进行中越过截止。

### 3.3 先库后证与写作尽调

形式化前按唯一有序路径检索:本仓 D5 声明 → 已钉版 Mathlib → spec A17 可准入的第三方 Lean 生态 → 本地证明 → 仍无则登记 `AxiomDebt`/`open` 与 upstream issue。只有第三方生态检索与本地证明均失败,才可走最后一步。开工前与开 PR 前各查一次本仓声明,防止同命题异名重证。

精确命中必须直接 import 与应用,至多最薄诚实包装,绝不重证。检索收据写进实施 brief/PR,至少含查什么名、在哪查、命中或未命中。本仓派出的形式化 worker 默认可出网搜索,派发时仍须实测实际能力;缺能力记具名 `wait-for-capability`,不得声明 search-complete,恢复后完成第三方检索。不得为此修改宿主 `~/.codex` 全局配置。出网的是形式化与写作之手,判卷之门始终离线。

第三方精确成果只有依赖与移植两种准入形,重证禁止。按 spec A17/A17.2 比较上游与本仓 `lean-toolchain`、mathlib `rev`:不同则依赖不可行;相同且 public source、immutable rev、license compatibility 的机器谓词均具备,才可自动取依赖形。缺谓词记 `open`,不交人裁决。不兼容时只余移植或放弃;依赖适合协调演进点,移植适合固定修订的叶子成果。

移植须保留版权、许可全文与完整 NOTICE 链;入仓即按普通内容接受 GID、文件头、向下 import 与容量检查;axiom/sorry 闭包不得扩张,只含标准三公理;退役条件须对本仓自己的钉版可判,当本仓已钉 Mathlib 有等价声明就删移植并直接引用。不得以不受本仓控制的「上游被 Mathlib 接受」作到期条件。

写正式 Describe 或定理级叙事时当场检索文献并表态:有出处为 `literature-attested` 并带 L 平面 note(DOI/标题单一真源);本仓推导为 `repo-derived`;认真查过未见为 `suspected-novel` 并留可审计检索痕迹。没有 `unassessed` 或回头再说的合法值。表态及文献引用链有结构门,是否真已知仍靠尽调、评审和文献核查;DOI 在线解析只作 Observe,不得让离线硬门出网。

### 3.4 开放问题的三档选题

每个候选进管线前必须标明档位与文献核对结果。产出由选题函数决定,席位空闲不构成派题理由。

| 档位 | 候选与工作形态 |
| --- | --- |
| 新近小猜想 | 2024–2026 论文末尾的 conjecture/question、OEIS 评注猜想、Kourovka 未加星问题;文献中尚无证明且可望短证,实施前联网核对并预登记。以小时计,探针一席 → Stage A → 镜像核对 → Stage B → 三席评审 |
| 计算前沿 | 下一个未知情形是尚无人做过或认证过的有限计算;有限归约、穷举/SAT 与内核认证真正推进已知范围。以周计,按研究线推进 |
| 核心问题 | 由 τ=0 用户点题;GPT PRO deep research 给文献地图与障碍登记,codex 逐条移植已知引理并把死路机器化。产出是形式化地形图,不承诺席位灵感能可靠突破;机器不替用户选择第三档目标 |

搜题 brief 与预登记评注须写清「文献中无证明,核对了什么」或「计算未见于何处」,缺档位或核对结果评审打回。已知陈述只 `make cover`,或以 `FromLiterature` 落地为第一、二档目标必需的前置桥;不得为其单独派探针或实施席。

进展按解决哪个已发表问题、推进哪个已知范围报告,不按模块数、席位数、行数报告。有限证书只有排除原问题此前未排除的情形才可称部分进展。同一 lane 第三次因非数学缺陷重做即停;卷内事实错误用独立勘注修正,不为证书付第四次 deposit。

### 3.5 研究线与停止条件

第二、三档一个目标一个长期 worktree、一份逐条记录失败处与读数的障碍登记、一张已证/在证/阻塞三态子引理 DAG。地图与文献工作、子引理多路径可并行,每个子引理 deposit 仍走两阶段落地管线。

开线预登记什么算成、什么算翻、多久无边际改进换 Γ 或换目标;连续两周无边际改进即触底。到期按五态端化,不以进行中赖过截止。不能把第一档的小时节奏强加给长期研究线;停止无效形态不等于放弃目标或降低检测。

## 4 形式化、冻结与消化

### 4.1 单向产线与冻结成员

路径 → kind → producer → verifier 的唯一映射在 `Meta/FILEMAP.toml`,由 strict loader、`FileMapPolicy` 及 `FILEMAP-DATA-VERIFIER` 等检查消费;若本节的路径描述与映射冲突,以 FILEMAP 为准。

```text
docs/develop/theory/**  参考输入,当前正确,历史归 git
  make ingest
  -> Meta/Digestion/atoms/sha256/<atom_id>  不可变 CAS blob
  -> Meta/Digestion/backfill/<source_id>/<态>/<atom_id>.yaml  消化账目·四态见下
  形式化:手写 D5/<GID 路径>.lean,先库后证
  -> 手写 Blueprint/D5/<同一 GID 路径>.scribe.cs
  make emit -> Blueprint/D5/<同一 GID 路径>.md
  make deposit -> Golden/Frozen/state/<GID 路径>.lean.json
  make cover / cover-batch -> coverage 边与机器派生的消化态
```

Lean、Scribe、markdown 的 GID 路径逐段同形,错位是地址错。理论到 Lean 是链上不能由 make 代作证明的一环。禁止手改发射 markdown、改写已产 CAS atom 或在冻结 Lean 上原地补证明;分别改 canonical Scribe 后发射、追加勘误与新 atom、或弃错误分支重做合规 deposit。CAS 失败回滚只可删除本次调用新建且尚未入账的 blob,不能假定存在通用删除面。

`Golden/Frozen/state/<module>.lean.json` 存在即成员已冻结,payload 为 `{statement_id}`。冻结真值单调累积、永不解冻;当前态 SL-008 检查状态片 schema、路径对应 canonical Lean 模块、模块存在且 Closed、当前 report 存在与 pin 一致,`FROZEN_PIN_CHANGE` 是 pin 变化的 Observe。当前态一致性不是全历史只增不减的机器证明。

凡仍被消费的 `Golden/Frozen/accepted/**` Freeze 事件,新增或修改时必须有对应状态片且 pin 相同,缺失或不匹配 SL-008 红。事件的声明身份、descriptor selector 与 `prerequisite_frozen_node_ids` 仍各有消费语义,后者是 DAG 依赖边,不能当无意义元数据删除。状态片决定成员身份,事件不冒充另一套成员真源。「事件与状态片成对」有硬检查,「依赖闭包成组」须独立证明,不得冒领为同一道硬门。

三类改动形态的面集合封闭:deposit 是 Lean、Scribe 定义、发射镜像与冻结状态,并带其实际 writer/consumer 要求的 Freeze 事件;cover 为同 atom 的 coverage 边与机器派生状态迁移;ingest 为理论源、CAS atom 与 residual-open 账目。deposit 与 cover 可在同 PR、同一工作树顺序执行,不另记 formalization 动作收据。面集合能由 changed-path 计算,但没有对应检查证据就不能称已执法。

### 4.2 首冻判形与逃逸见证

首冻约束按 protected base 与 candidate 判:descriptor 路径在 base 无现役 Freeze、candidate 新增第一个 Freeze 即入域,不看文件创建时间或 deposit anchor。判该事件全部声明,不能只选 anchor 避开其余声明。`proof_shape`、`admission_basis`、计算用途 `utility` 是正交判定,不得互相代替。

对每条公开定理内联局部别名、私有 helper、tactic 展开与定义性等式后,若结论仅由冻结公开定理实例化、以冻结见证代入前提而去假设化、逻辑投影或重组、规范化改写获得,即 `bind-only`,否则 `content`。投影或重组含 `.1/.2/.mp/.mpr`、合取与 TFAE;最薄上游包装、直接实例化也按此判形,用途不改变判形。

规范化包括定义展开、仅用冻结或 Mathlib 改写引理的 `simp`,以及 `ring/linarith/omega/norm_num/decide` 在全部原子事实已由冻结前置或这些步骤提供时闭合目标。判定程序若建立前置未提供的新命题,该命题是候选见证,不能自动降为规范化。冻结前置以直接依赖的 GID 与 `statement_id` 识别;钉版 Mathlib 声明不计入冻结前置,但直接实例化 Mathlib 同样不构成逃逸。

独立中间命题作 escape witness 须同时满足:

1. 其证明声明在该公开定理已 elaborate 的传递常量依赖闭包内。
2. 不可由该定理冻结前置经实例化、投影或规范化直接得到。
3. 与公开结论不定义等价,也非别名或重述。
4. 在结论的活推导路径上:证明项 ζ/β/ι 归约、删死项及被投影丢弃分量后仍被使用;不用它而仅靠 bind-only 操作不能得到结论。

另一合法形态是公开结论本身由具名、非 bind-only 的计算或构造在活路径直接产出,且满足上述反事实,不必人为制造中间命题。无关新事实塞进闭包后又被投影丢弃不算见证;源码行数只是非承重读数。点不出合法见证即 bind-only。

### 4.3 准入依据与伴随声明

首冻模块须在报告与 PR 中给出三种依据之一:

| admission_basis | 完整条件 |
| --- | --- |
| `escape-witness` | 至少一条公开定理为 content,且见证满足 4.2 的语义、活路径与反事实要求 |
| `rule-11-upstream-wrapper` | 先库后证所需的最薄诚实包装;引用精确上游声明,以及使包装必要的 atom 子句或具体仓内 API/覆盖需求 |
| `atom-required-bridge` | atom 明文要求,连接此前无类型化边的两个独立概念,并有预登记的具名下游消费者;引用 atom 子句、新边与消费者 |

后两者只豁免准入,不改 bind-only 判形;报告如实列 `proof_shape: bind-only` 与依据。无依据不得 deposit。模块其余 bind-only 公开声明只可作具名伴随结果,每条记录 atom/义务与「消费者 → 前置」方向的两端:它是逃逸定理的前置、逃逸定理是它的前置,或有预登记具名用途。不得夹带无关声明。

bind-only 事实不能单独成为 deposit、增订义务或实施席的理由。探针可用于判形,一经证实 bind-only 且无例外就不得转独立实施/deposit。合法去向是:已被冻结定理逐字覆盖则 `make cover`,零 Lean;写成内容模块的具名伴随或私有引理;连续两次无例外的 bind-only 候选则停手换 Γ,转缺失分析引理、基础设施或研究线。

探针前预登记拟议逃逸见证,点名拟用的非冻结分析、组合或数值事实。观测见证不同则以新版本重新预登记,不得事后改标。探针和实施报告逐公开定理列 `proof_shape`、直接冻结依赖(GID + `statement_id`)、`escape_witness`、`admission_basis`。评审对无依据首冻 reject,这是质量判词,准入权威仍是机器门。

判形、见证、依据、伴随边与上述正文义务是 binding 评审义务,不是仅因可计算就已部署的门。要声称硬化,须由候选判官内受分区门保护的消费者读取不可变、绑定 HEAD 的结构化证据,并以缺字段/伪造分类使具名检查变红的变异证明支撑。

### 4.4 计算性内容的用途

用途是第三个合取,不修改判形、两种见证、三种准入依据或既有冻结。以有限计算或可核验实例为主要新内容者,按交付语义分 `bounded-enumeration`、`checker`、`numeric-reduction`、`certified-instance`,不能凭文件名、Certificate 字样或 tactic 分类。

探针前须预登记计算回答的独立问题,来自事前存在的 atom、TASK、断言或具体证明义务。用途依据三选一:

- `consumer`:声明级具名消费者,明确「消费者 → 前置」,在活推导路径真正使用所申报结论。仅 import、只用定义、重命名/转发、合取或子句打包、coverage 边均不算。
- `refutes`:处决具名断言。反例不因使用 `decide/norm_num/native_decide` 或一般定理实例化而失去用途,判形照常独立判断。
- `terminal_result`:直接解决该独立问题,不要求另造 importer。

有效 `refutes` 对四类均足以满足用途,优先于类特有附加条件,但仍须原有判形与三种准入依据,不构成第四种 admission basis。同一交付命中多类时按最严附加条件判,除非已满足 `refutes`。

已有一般定理不加强假设即可给同结论者,先复用或 cover,不单独冻。有界枚举不能建立无界量化的 ∀,有限域穷举除外;否则合法角色只剩探针与反驳。检查器须同 PR 带首个具体实例:具体输入、证书或检查成功证明、soundness 应用、所解问题缺一不可;接口再包装、留 refutation 在假设位、无关玩具实例不算。

数值归约须同批履行数值前提,同函数、同参数、同域、同向阈值,并有 `consumer` 或 `refutes`;`terminal_result` 不豁免。前提欠缺时可在探针、issue、进展报告如实报条件结果,不能据此取得用途准入或单独首冻。已认证实例的用途必须在结论上满足三选一,不能只消费同模块定义。源句若只是同一计算的报告,以一般定理覆盖或标计算实验不形式化,重做该计算只是查表复制。

逐声明判分类与用途:任一事件声明命中计算类,模块不得报 `none`,各计算声明分别给依据。只有全部声明不命中且评审确认,才可报 `none`,其余用途字段为 `not-applicable(kind=none)`;该模块仍受判形与 PR 分层约束,一般引理可先落地、消费者下一层再出现。

Lean 头部 `utility:` 承载 `kind`、`consumer|refutes|terminal`、`instance`、`premises`,文法为闭合的 `none` 或 `kind=…; basis=consumer|refutes|terminal …` 记录。SL-031 对首次冻结状态路径在 Changes 与 Current、而不在 protected Baseline 的模块作 delta 检查:缺行、文法错、GID/atom/TASK 悬空、consumer 无 import 可达路径、`refutes=atom` 无精确 coverage 边、checker 无 instance、归约无 premises、输入 unknown、已冻结模块改 utility 均 Block。deposit 头部预检同步要求字段存在与引用可解析。

机器的引用可达性不证明声明级真实使用。`none`、`terminal`、`refutes=task|gid` 的语义、一般定理支配、活路径由 Observe 与评审按本节判,每个首冻模块有 `UTILITY-OBSERVED` 观察行。自报 none 不等于已机器证明非计算性;缺 elaborate 常量闭包等判形证据时,须保留该边界,不能声称已拒绝所有无用内容。

PR 正文仍必填 `question_answered`(独立问题与预登记位置)、`dominating_theorem_search`(范围、方法、`found` 或 `not-found-in-searched-scope`)、`build_seconds`(可选实测加树/硬件/缓存口径,或 `null`,无阈值)。这些可编辑正文是软义务;不能冒充绑定 HEAD 的头部机器面。

### 4.5 Coverage 与正交状态

`coverage_gids` 是持久化键,每元素键集恰为 `{gid,target_statement_id}`,后者可为 `null`;candidate 与 protected-base loader 只收对象形。字符串元素、`receipts.coverage`、`source_sha256`、`statement_id_history`、`recorded_at_utc` 均 fail-closed,writer 只写对象。

`align-digestion-status` 由当前 report 与冻结账直接刷新 target,不保留旧值;任何 target 未解析都令 truth 为 `Open`。cover 写前门和 SL-016 验 GID 唯一存在、Closed 与当前 statement identity。冻结是二值真值成员状态,消化是账目四态,二者不互相冒充:定理冻结不推出 atom absorbed;atom absorbed 则其 coverage 所指声明已冻结。汇报混称即冒领。

### 4.6 消化四态与非命题结算

| 消化态 | 含义 |
| --- | --- |
| `residual-open` | 尚无 GID 覆盖 |
| `partial-closed` | 子项部分覆盖 |
| `absorbed-closed` | 覆盖 GID 与 coverage 数据齐备 |
| `nonpropositional-inapplicable` | 非命题、无需覆盖,由专用收据派生 |

第四态不能由 atom 字节或 kind 猜出。`receipts.nonpropositional` 必须有 `justification`、连读的 `previous_atom_id` 与 `next_atom_id`(边界为 `null`),由 `DigestionStatusEvaluator` 派生。收据与目录不对应,或与 coverage、quarantine、cover_disposition 共存,均 SL-016 红。

唯一写者 `settle-atom` 经 `make settle`/`make settle-clear` 调用;写前须 `make atom-context ATOM_ID=x` 连读前后 atom,writer 复算邻接不等即拒。clear 原路回 `residual-open`。chain_atoms 子项为 Absorbed 或 Nonpropositional 均视为链闭合,但非命题态对 Lean 真值零主张、不计可形式化分母,也不使 `Deletable` 为真。`section/*` 等非形式化 kind 仍是查询时的 `not-formalizable(kind)` 投影,不得推广成另一持久状态。

### 4.7 真值强度与环境升级

冻结强度是节点在特定 toolchain 与 pin 下从哪些公理证出。写入门验当下公理闭包落在许可集内,升级门用新环境重算冻结节点并与许可集比较,任一退化即红。许可集须唯一真源,测试钉住成员恰为该集合,变异加入一条公理须有具名测试红;任何放宽走 τ=0 贵路,写入不得有绕门入口。

升级不与存档旧闭包比较,不为取得旧闭包重建旧工具链。未来真正需要的原料才同存;旧环境闭包若仅用于重审旧判,不应永久存储。逐字段区分:不可从树重导、断言当时发生什么的真源须守;携带权威的加工值是地址,不能重算来验已存值;同值第二个名字的纯投影应消除。当前态一致性与新环境验许可集不属于历史重放。跨环境不退化的完成声明须有实际升级门运行证据,不能从写入门绿或存档存在推出。

## 5 协作与交付

### 5.1 工件通信与产地

协调经 PR、issue、工单块、卷宗、判词等可审计工件,禁止库外旁路信道;未见于工件的协调视同未发生。LLM PR 携转录或卷宗引用供审计复盘,不把溯源变成人审准入条件。

每个 PR/issue 正文顶部必载三项,使读者能复算独立来源数:

1. **skill 上下文**:实际调用名,或明写无 skill、主循环直接实施。
2. **载体与分工**:各承重产出由谁产生,实施、评审分别是谁及模型族关系。
3. **混合方式**:并发盲评或串行、approve/reject/abstain 数、分歧如何裁决,哪些结论由 orchestrator 亲验、哪些只是席位自报。

恒定 footer 是开 PR 载体的署名,不能代替产地。转述须标转述;载体故障、abstain、换手与 fallback 都是独立性变化,必须披露。单点实施是合法取值,留白不是;不写独立性就不能声称它存在。

理论 PR 另须说明实际形态(deposit/cover/deposit+cover/ingest)、链上 `source_id/atom_id → GID`、落地后的状态(deposit 的 `event_hash`,或 cover 的前后态)。判据是读者能在链上定位,不是关键词命中。

正文、评论在检查后仍可改删,check-time 存在性只证明那一刻有。commit message 不能替代提交后才形成的评审结论,也覆盖不了 issue。上述内容与时序是软义务;PR 可有非承重 advisory 提醒,不为此新建门。只有快照不可变地绑定 HEAD 且后续编辑使门失效,才可能称硬投影,不能凭 required check 或 strict 补这个缺口。

### 5.2 接手、失败与处置

issue 是调查的公共面。开始实施或派席前留接手、当前事实与处置方向;推翻既有读数或前提时优先及时改判;根因落定、路径选定(含否决理由)、触碰不可逆面之前、结案时都留痕。结案引用 PR 的 MERGED 状态与合入 SHA。每条评论须有新读数或新判决,禁止零信息进度播报;写完继续走,不等回复。

先翻旧 issue、卷宗、编年再探索或立新案。失败写入工单散文或实际审计工件,保存强度由其消费者与存储契约决定。终局失败、被拒或长期卡死工单关闭留判词,以新编号、新上下文重开;不得用运维复活陈旧标签、过期引用、耗尽重试的死状态。

发现问题时,立案只是账,不是解。默认随即开独立 worktree,用 sshx 或已授权的直接实施修好并走 PR。仅当对方已认领且有实测读数/在飞 PR,或真源明确归对方、自己动手会造第二真源,才让渡;仍须记录被堵面与恢复动作,对方停滞即留痕收回。处置计划须有对应 worktree/PR 或让渡依据,不能以已提 issue、等回复当完成。

### 5.3 Worktree 与完成定义

所有工作,不分大小、代码、文档或元层,一律经 `make worktree` 在独立分支与工作树实施。主检出常驻 `dev`,不建分支、不改文件、不 checkout 其他分支,只在开工前、派席前、合并后及时 `git pull --ff-only origin dev` 同步。主检出是移动基线,读数、改动和报告在钉住的 worktree 做。

`dev` 是集成主分支;`main` 是发布分支,dev 稳定后经 release PR 与 `tag E<n>` 推进,表示已发布且可复现。新分支 creation grammar 由 `WorktreeCommand` 唯一执行,namespace 与 kind 从其 `CreationNamespace` 和类型词表取得。创建约束与生命周期识别分离:`LifecycleNamespaces` 中任何非空子路径仍属受管生命周期,不能因创建词表变化缩小清理面;历史 namespace 不得当新建 alias,也不因此强清存量分支。

一个逻辑单元完成即 commit 并 push 留内容寻址锚,不积攒长期未提交改动,不依赖跨 worktree 共享的 stash。工具不要求先提交:`ledger-align` 默认 `repository.ReadCurrent()` 读当前未提交树,不按 delta 选择;`deposit`/`cover` 只改工作树、不自动提交。

交付流程为 push → `make pr-open [AUTO_MERGE=1]` → 三 required check → 显式 auto-merge 或后续明确合并动作 → 同步主检出 → 回收或复用 worktree。缺省不 arm auto-merge。只有 PR 状态 **MERGED** 才算交付完成,须引用合入 dev 的 SHA;开 PR、CI 绿或只差合并都仍未完成。CLOSED ≠ MERGED,须复查 dev 真实状态,不能据 CLOSED 推断已合或未修。

回收前须同时确认分支已 MERGED、树无未提交改动,缺任一项先处理提交与交付。及时清理或复用,不留僵尸 worktree;`make -C tools clean-lanes` 的实际器谱见 tools help。

### 5.4 PR 边界:冲突与判词

多步改造按有序层逐 PR 独立落地。每层开工前说清单一职责,能独立过三门且不靠后续 PR 才有意义,不留兼容名单;落地前 `git merge-tree` 试合当前 dev,核对所动文件是否已退役,退役的跟着删而非搬迁。先立 delta 门、分批补账与收缩到全树的条件见 6.3。

拆分依据是实际冲突面与判词可分性,不是文件数、目录、模块族、卷或其他结构代理。零冲突面须五项全真并在 PR 给读数:

1. 所有变更为 `RawChangeKind.Added`,无修改、删除。
2. 路径两两不相交,由内容地址或真源键派生,非共享可变文件。
3. 没有跨分区聚合物。
4. 全由一个 canonical producer 一次运行产出,同输入逐字节确定,非手写。
5. 该 PR 三门判据不依赖后续 PR。

五项全真时,文件数不构成拆分理由,不必附「不可再分」说明,评审不得只凭文件数打回。任一项不成立,按真实冲突与独立层边界拆分,不能把测得的仓库文件数分位数冻结为政策。

**判词可分性与冲突正交。** 动手拆前先测哪一维会使一部分红、另一部分绿,先按该维分区,再由依赖闭包约束不可切边界,同一连通分量不得跨 PR。零冲突仍可能需要拆以隔离失败;不拆须同时满足零冲突与全批判词一致。事件/状态片成对的硬检查不能冒充前置可解析性或分组硬门。

拆分成本也须与收益并列:每份 PR 的 required CI、worktree、缓存影响和正文成本。重复同一正文提示评审单元可能相同,仍须测判词分布,不能据重复本身宣布收益为零。上述冲突、分区与证据义务可复算但主要由评审守,不得称存在按文件数或五项合取自动阻断的门。

### 5.5 独立评审与 sshx 载体

提出问题的人不判自己的答案,对手官不作证师,实施与评审分离。正确性依赖机器绿与独立收敛,不依赖最聪明单点的自信;三席评审与可得异模型视角是质量层,不是另一个合并准入权威。同族共享先验,须如实披露,不冒称模型多样性。

本仓覆盖 `consensus-rnd:sshx` 默认席位布局:每个多席阶段恰好一席 `nyxid-oracle`,其余全为 `codex-cli`,不使用 `isolated-token-subagent`。skill 的载体失败回退规则仍适用;两种载体均不可用时阶段 `abstain`,不得退回 subagent。`tests` 席必须能在 `work_target` 真跑验证,只能是 codex-cli;oracle 涉及本地执行的结论须标 `ASSUMED-UNVERIFIED`。

如实记录实际载体、模型族、prior 暴露、输入隔离与失败回退;不能从多进程、布局计划或互不见同轮输出推出无既有先验。独立性强度以实际可核证输入为准。

给 oracle 具体 issue/PR/文件/check URL,让其独立取证,不要只转述 caller 结论。派发前实测可见性与可达性;未公开的分支或工作树不能假设它可读。授权允许时先推可评审内容,否则 brief 明示未公开,由能执行的载体或 caller 核实该部分。pool 名须从 `nyxid oracle pool list` 实测取得,不用记忆中的 slug。

codex prompt 必须由文件经 stdin 输入(`codex exec [flags] < promptfile`),不作位置参数,避免 shell 展开破坏。flight 在飞时工作树可能正在变异,caller 的瞬时读取不能当稳定实施证据;用派发前钉住的 diff,或取哈希并在交回后复读比对。两份读数冲突先查自己的采集条件,不得先据临时变异指控实施错误。

### 5.6 CI、判官改造与阻塞 hotfix

CI/权限/门控改动开 PR 前评审须归位,显式传 `AUTO_MERGE=1` 前完成独立评审。改 `.github/workflows/**`、其脚本、权限、job 拓扑或 required-check 名与判据,必须在真实事件中验证;本地 preflight 跑不到 workflow 的过滤、拓扑、权限、artifact 传递与目录布局。

多层 CI 改造在 `integration-ci-<主题>-tests` 同放 CI 改动与能实际命中触发条件的最小测试载荷,开 PR 让目标 workflow 真跑为绿;再只把 CI 改动 PR 到 dev,不带载荷,最后删测试分支。说明引用该 workflow 的实际绿色 run。

`pull_request_target` 文本始终来自 base,集成 PR 不能预先执行自己携带的新 workflow;能先验的只是候选侧脚本。workflow 与其脚本须同 PR 进 base,不建跨版本兼容垫层;携带新脚本的分支与旧调用者不匹配应 fail-closed。合入后立即观察首个真实触发 run,补链接入 PR,红则按 6.5 撤因。不能用旧 workflow 的绿冒称新拓扑、权限或传递已验。

多层判官改造适用于 Engine 规则/策略、准入判据、新测试程序集及拓扑、IO、容量、棘轮等面,按次序:

1. 每层 PR 到 `integration-<主题>`,三门绿后合入该分支。
2. 对同一 integration 再开触发 PR,带命中新判据的最小载荷:正例应有具名 finding,负例该 finding 应为零。三门在真实 `pull_request_target` 事件跑,读取实际 finding/Observe 输出;验完关闭不合,载荷不入任何分支。
3. 批次回 dev 前合入当时 dev 新增量,重跑三门;绿后才从 integration PR 到 dev。

判官自身层 PR 绿只证明对既有树无害,不证明新判据命中,两种测试不能互相代替。最终 PR 须引用层验证绿、触发 PR run 与具名判词(标正/负例)、合入 dev 新增量后的复测绿三份证据。integration 的 protected base 是 merge 第一父即 integration tip。被 revert 的改动须在新 lane 造 revert-of-revert 新提交,不直接重开原分支 PR,也不在 integration 上直接恢复;integration 保持干净 dev 起点加已验层。

**目标途中基础设施阻塞默认当场 hotfix。** 缓存、脚本、CI 拓扑、工具链不是 τ=0 内容语义裁决。最小单层 hotfix 在独立 worktree 直接 PR 到 dev,三门照跑,不用 admin、不改预算掩盖、不降任何检测。它不是多层 integration 改造;workflow hotfix 也直接 dev,合入后立即补首个真实 run。让目标继续的最小修与完整根因修是两个 PR。

仅内容语义输入(真值口径、冻结、axiom、spec 数学)待 owner 时可记 open,须写明具体语义,不以「等 owner」代替。基础设施阻塞的同单评论须给 hotfix worktree/PR,修复过程与读数留同单,修好回单结案。等待定时任务、换路绕开本 lane 或只立案,都不能冒称阻塞已解决。

dev 因 harness 层红而阻塞纯增加数据 lane 时,可并行改投 `integration-theory-<date>`。适用面封闭为 `D5/**/*.lean`、Blueprint Scribe 及 md、`Golden/Frozen/accepted/**`、`Meta/Digestion/**`;任何 tools、workflow、判官/准入改动不适用。先按判词判断红因层次:Lean、SL-008 或覆盖内容红须修自己的内容;harness 自身红才援引改投,PR 引其原判词,该引用是评审依据而非硬门字段。

从当时 dev 开新日期分支,已有他人建立且为绿则复用该绿分支。三门仍跑;dev 首次恢复绿即合入新增量复测、整体 PR 回 dev,不得跨过下一次 harness 红而滞留。合回立即删分支,下次阻塞用新日期新起点。内容 lane 改投与恢复 dev 同时推进,互不替代。

## 6 准入、检测与恢复

### 6.1 机械准入与不可变判词输入

人与 AI、维护者与陌生 fork 走同一道门,身份与准入无关。人审和 AI 审增加质量,不承准入权威。PR 到 dev 的三 required check 为:

| 检查 | 职责 |
| --- | --- |
| engineering | candidate build `--warnaserror`、工具测试、selftest 字节比对、能力链编译证明 |
| lean-inspect | 对受审并集树生产内容寻址的 Lean 报告 |
| admission | 候选自带判官运行 `check --protected-base <merge-first-parent>`;base 只作数据与 git 对象 diff |

baseline exit 0 表示内容全验过,1/2 表示违规/基础设施红,3 表示 SL-022 元层变更标注且须 candidate `lake build` 阻断地板。该地板是有界 bootstrap 手段,只有接替它的成本与保守性机器有效时才关闭,不得把 rc=3 短路成人审或假绿。实际 gate 由本层 make 入口执行。

CI 与测试对真实检出的 git 引用只许 `head=rev-parse HEAD` 与 `base=rev-parse HEAD^1`,同一不可变 merge 对象导出;禁止 `origin/*`、`refs/remotes/*`、本地分支、tag、`HEAD~n` 或其他修订。合成夹具仓不受这个真实仓限制;workflow 在判词前的 checkout 取树动作不在禁内,检出后不能再问别处。公开 PR 流程查询与基线同步不冒充测试判词输入。

PR CI 取 `refs/pull/N/merge`,push 取对应 SHA,delta 为 `HEAD^1..HEAD`,以 check-time 并集树判。**strict 永久禁止开启**,不能要求每个 PR 追平移动 base 反复 CI。被验树与落地树一致是要守的性质;check-time M1 后 dev 前进可产生 land-time M2,merge ref 缩小而未消除窗口,不得据此重开 strict。

并集风险由 touched-directory 准入并预留一格、全仓容量检测、共享聚合物消除/分片、PR merge-ref 与 dev push 检测接住;两条并发新增可落在全仓容量不变量内。更强保证只能考虑批量大于 1、构建并验证实际落地树的合并执行者,且须先实证 `merge_group` 的 workflow 取源仍属于 base。不能把文件路径不相交泛化为所有判词独立。

检出后移除 remote 与 `refs/remotes/*`,断言为空并烟测 HEAD/HEAD^1,只消除按名字解析远端,不等于对象或网络不可达。原始 OID 可访问已取到的对象,本地 donor 的显式 URL 或重新加 remote/fetch 也不被此保证排除;本地结果不证明 CI 私有 HTTPS 与 `persist-credentials: false` 下相同。缩 fetch 历史可能伤 diff、ingest 等消费者,不能为无实际事件的设想加防线。

`RemoteStateIndependencePolicy` 的 C# 测试源扫描只是早反馈,不证明无远端读取。边界包括 helper/反射/ProcessStartInfo 属性形、间接 executable/revision、外部脚本、MSBuild Exec;`github.event.before` 的直接形可匹配不代表完备。composite/JS action、source generator、P/Invoke、PowerShell/Python/Make、eval/bash-c、文件或环境 revision 未经实际验证不能称已覆盖。剥夺步骤和 workflow 权限/拓扑由真实 run 与评审验证,不得用已禁止的 workflow 形状测试冒称其会执行。

### 6.2 候选判官与扫描边界

**base 判官永久禁止。** 凡为判决候选而 checkout、restore、编译或执行 protected base 或任何非受审 HEAD 修订的代码,无论名为 derive、verify、classify、floor、兜底或防篡改,都违规。禁止非候选 `--judge-root/--judge-dll`、base worktree、取旧脚本再执行等机制。

读 base **数据**允许:第一父 SHA 用于对象 diff,`RevisionSnapshot` 或按修订读取 FILEMAP、账本、拓扑、workflow 哈希等字节,由候选判官作输入处理。分界是执行非 HEAD 代码还是读数据。`harness-gate.sh` 无 judge-dll 时从候选构建并拒绝逃出仓根的 TargetPath;workflow 传入的 dll 也须对应候选源码内容地址。

候选可能削弱自己的判官是明确接受的残余,由 SL-029 按 protected-base FILEMAP 分隔判官面与内容面 PR、SL-022 保护面标注、独立评审及 dev push 检测承担;不能再造 base 判官。workflow 文本取 base 是事件信任拓扑,不是执行 base 判官的许可。

SL-030 对候选 delta 中 `.github/**` 与 `tools/scripts/workflow/**` 的判官面早反馈。能物化修订文件的 `git show <rev>:<path>`、`cat-file -p/blob/--batch`、`archive`、`worktree add`、`checkout <rev>`、`restore --source`、`read-tree`、`checkout-index` 中,修订非字面 HEAD 或变量即红;workflow checkout ref 指 `base_ref`/`pull_request.base` 也红。数据读取应通过候选 snapshot 读者,不能因政策允许 base 数据就声称扫描器会放行一切物化语法。

扫描器支持的 shell 语法边界必须如实保留:

- 单/双引号;双引号内反斜杠只转义 `$`、反引号、双引号、反斜杠与换行。ANSI-C `$'…'` 解码 `\xHH`、八进制、C 转义、`\cX`(含控制反斜杠,操作数按反斜杠对消耗),首个 NUL 截断;另支持反斜杠转义与续行。
- `$(…)`、含转义嵌套的反引号、`<(…)` 替换;替换定界与词法共用注释/引号状态,未引用词首 `#` 只注释到行尾。
- 数字或 `{name}` 描述符前缀、`>|` 等重定向;操作符仅由未引用字符构成,引号内 `>` 是目标。支持 `| ; & && ||`、`( ) { }` 边界、if/while 等关键字、赋值、`!`、time、coproc 前缀。
- 动词位动态即 fail-closed;命令位动态且后随受管 git 动词则按 git 判,后随其他词不判。
- git 选项按显式元数表解析:flag、下一词或附着值、仅附着可选值,含 `--no-` 与唯一前缀缩写;未知或歧义 fail-closed。各动词表由 git help 派生;show 的整个 log/diff 选项空间由 git-log 文档派生,未知选项当 flag,可能多判但不据此少判。

`.github/**` YAML 整体由 YamlDotNet 解析,任何位置 run/ref 标量均纳入,块/流映射、引号/纯/块标量、标签、锚点/别名、合并键、多文档由解析器处理。解析失败或 run 非标量 fail-closed。

不支持即可能不判的形态包括 heredoc 体、算术展开、case 模式括号(可提前闭合命令替换)、`${X}`/`git${X}` 参数拼接、别名与函数、bash-c 拼接、eval、经 env/command/exec/sudo/xargs 等 wrapper 调 git、按 SHA curl 脚本、Python/JS 载体、面外脚本物化再被面内调用。C# 进程内作为候选读者的数据读取按定义允许,不在 shell 扫描保证内。漏路径的 `IsAffectedBy` 或同 PR 改弱判官还可跳过检查。

SL-030 因而不是「不存在 base 判官」的证明。复辟仍由评审按定义判,并由实际 run 暴露自锁;扫描不到不构成豁免。其合成 workflow 消费逻辑夹具是 7.2 允许的生产逻辑测试,不是对真实 workflow 字节写测试。

### 6.3 增量闭包与债务收缩

准入检测作用于本次变更的依赖闭包,不能以全仓派生兜底。基础一致且每次增量保持一致才构成归纳;漏破坏就补反向依赖与值变化,不能在实现变更时传 null 退化全量。全量读取建索引合法,全量重算作一次性对齐/迁移 producer 合法,全量不变量可在检测层观察,但不得把全量派生挂进准入门。

唤醒须对应被依赖值的变化,不能拿路径移动或前缀命中当语义变化。尤其 delta 门若依赖某个本该发生但被别处阻断的动作唤醒,就可能静默看不见对象;状态片未产生时不能声称首冻用途门已审了 Lean。闭包完备性不能由有一个 delta 入口证明,须靠评审、实际触发与遗漏后的修器。

系统持续合入时,先立只判新增项的 delta 门,再按独立层分批补存量,最后同一道门自动转全树。delta 是定义域限制,不许可双读、legacy alias 或永久 grandfather。合法存量债务必须是 protected-base 数据拥有的集合 `D`,且五项全具备:

1. candidate 新身份立刻拒绝。
2. `D_head ⊆ D_base`,按集合包含,不能等量换债。
3. 触及债务面的迁移步使 D 严格下降。
4. `D=∅` 同一道门自动判全树,无需第二次人工动作。
5. 删除收缩机制自身会红。

缺一即兼容垫层。blob ratchet 可用与 base 字节相同的旧源码携带诊断,新增或改动源码必须零诊断,免手维护身份表。债务只缩不换不保证某日归零,分批补账提供推进,不能冒称按期清零。这里的 base-owned 集合只是数据,不授权运行 base 代码。

### 6.4 检测分级与根因

不可逆动作、信任根、检测/门控机制自身须事前 fail-closed 硬门。可逆、低风险内容允许犯错,但须 conformance 巡检、canary、审计发现,案号追踪并快速勘正、允许判词申诉。**检测机制与不可逆动作的保护绝不降级;允许 open 不允许浮账,允许犯错不允许发现不了。**

自锁与真红须机器区分:门对 no-op/revert 也 fail、没有在区分好坏,才是自锁;能区分候选且只拒坏者是真红,越过即降级、严禁。解锁仍须成本、账本、独立对抗与检测放大,之后立即恢复门并用现役检查重判;这个区分不是免费绕过许可,也不能给 6.5 已定义的自动精确逆另加自锁条件。

防御机制必须能点名一次实际发生的本仓或有据外部事件,PR 说明引用案号/尸检,无案的想象防线应删。事故证成的防御与无实际攻击者的恶意假设不同,前者也必须承担自身成本。错误形态不能先验穷尽,不是每种想得到的错误都先建机器。

新错误实际出现即入账、定义处理类、能机器判的立即建检测并走保守扩展/元层门、按 6.3 清存量。每类只付一次学费,同类再现是 harness bug,最高优先修器。类划分不能窄到逐实例打地鼠,也不能宽到过度门控。

同类判据是**症状相同且处置动作相同**,不因实例的局部解释不同而重计新类。第二次就停处理实例,在答出「为什么有第二次」前不得处理第三个。权限内修根因;实际能力或语义授权缺口则停止同形投入,量化次数、单次成本和总量,查旧案并补记录,转不依赖该根因的工作。基础设施阻塞优先按 5.6 hotfix,不能借别人的战线当无限等待理由。

停的是无效投入,不是目标或检测。第三次同症状仍同形处置的 PR/issue 必须写前两次读数和未修根因的理由,无据则该轮投入无效;说明义务不构成继续违例的许可。

### 6.5 撤因、精确逆与恢复

发现「证明有洞、本不该冻结」须连同依赖后代按既有 revocation/errata 与判词可诉协议纠正;这是撤销误判为真,不是改变 kernel 已证的真。精确逆的恢复有单独边界,不得泛化为普通冻结删改许可。

dev push 三门由绿转红时先撤因再修器,但先作机器归因:钉住 last-green run/SHA、first-red run/SHA、failing dev 第一父与具名判词,沿 first-parent 找 transition。该 edge 只产生候选,不等于因果成立。须用最小复现或反事实固定其他输入,仅移除 candidate delta 后同一具名判词消失,并对齐 BaseSnapshot 与 candidate 输入版本、检查滞后一拍。不能闭合就记 `ASSUMED-UNVERIFIED` 继续诊断,不得为及时撤错无辜 PR。

归因成立后先开肇事 first-parent merge 的 exact inverse revert PR,不把无关 PR 排在恢复前。`git revert -m 1 <merge>` 撤该笔而保留后续无关提交,不要求整树等于某个 last-green 或祖先树。撤因与前向修器是两个动作、两个 PR;修器依 5.6 的单层 hotfix 或多层 integration 正门。

**受限管理恢复**只在机器归因的 dev 绿转红时,允许肇事 first-parent merge 的 exact inverse admin merge 不等该 PR 的 CI,并须全具备:只恢复可逆面,不触冻结/atom/内容不可逆面;PR 引原判词与肇事 SHA;合入后首个 dev push 三门真跑留结论;仍红即未恢复,继续定位,不得二次绕过。它不授权前向改动、不关闭检测,也不能把 merge 当恢复完成。

**规则自动识别精确逆**的准入判据恰有三项:

1. 逐 path 的旧/新 OID、mode、gitlink 四组信息反向相等:候选新等于目标旧,候选旧等于目标新;`--no-renames` path 集合完全相同,无额外 path。
2. 目标是 first-parent 链上的 merge,即一个 PR 的落地单位。
3. 该 revert 不触及逃生规则自身。

这类恢复不产生被撤部分的新状态,无需再判那部分内容;自动规则不另加自锁判据,不设 harness-only 或其他路径白名单。命中时三个 job 仍产 required check,可跳过重步骤成功后由 auto-merge 合入;其规则与执行只能位于候选判官,不能以 base 脚本或无条件 CI 捷径实现。可计算判据不证明自动放行已部署;没有实际规则与运行证据不得这样报告。规则有效后受限 admin 路径停用。

自动精确逆含冻结条目时,删除是恢复被撤销状态,不是解冻;PR 须列出被删冻结条目以供追账。任何非精确逆的冻结删改仍走正常门与 revocation/errata,不能援引此例外。不得混用路径不限的自动规则与只恢复可逆面的受限 admin 条件。

revert PR 必须 MERGED 才算落地,dev 恢复还须其后首个 push 三门全绿。恢复记录列 failing run、具名判词、已归因 merge SHA、revert PR、恢复后首个 run;正文引用本身是软义务。若机器消费恢复证据,须在候选判官内受分区门保护,证据不可变、SHA-bound,后续改动使门失效,并 fail-closed 验完整时序。无消费者不能称这些字段是硬门。恢复期间内容 lane 可按 5.6 改投,但改投不替代恢复。

## 7 工具、执行与资源

### 7.1 每层唯一入口

构建、发射、校验、开工走所属层的唯一 make 入口:根 `Makefile` 管内容层,`make test` 是数学门;`tools/Makefile` 管工具层,`make -C tools test` 是工具自测。各层 help 是活器谱,目标只委托 canonical 实现,跨层不复制配方,哪层坏就修哪层的器。

本地与 CI 使用同一 canonical 工具。`make preflight` 是 CI 三门的本地预证,含 engineering 步骤、反证编译、admission 与 CI 环境口径,但提交前不强制全量跑;按改动跑适当测试,CI 红再跑全量定位。本地只是早反馈,CI 三门才是准入权威,本地红不自动充当 CI 判词;本地绿而 CI 红仍须优先修器。提交即 push,随后跑本地,二者并行,不得等本地跑完才推。

新 worktree 经 `make worktree` 校验钉版,创建时不物化 Lean 缓存,也不 symlink。Lean 走 `make lean`/`make lean-report` 的 ensure;显式预热可用 `make lean-cache-ensure`。冷树不得裸 `lake build`/`lake env lean`:donor clonefile 只在 `.lake` 不存在时可播种,已有 `.lake` 但无 stamp 按 missing 不等于 stale 原地重产,不能改 fail-safe 强播种。只有 stamp 在位的热树可用裸 lake 做增量调试。派席 brief 写 make 构建步骤,不写冷裸 lake;ensure 的 `stamp_miss:missing` 与 `clonefile_attempts:0` 同现是违规诊断证据,不是声称已有完整拦截门。

`pr.sh` 为 `open`/`watch` 双动词,canonical 路径 `tools/scripts/pr.sh`。`make pr-open HEAD=b MESSAGE=file [AUTO_MERGE=1]` 的消息文件首行为标题、其余正文,调用方字节不跨 make/shell 展开;不要另传可展开的标题参数。它在同一有界进程内 create、App-token 隔离、按显式选项 arm、同步等待 required-CI 判词;缺省不 arm auto-merge。`make pr-watch PR=n` 复用同一能力,调用方用一个宿主作业调用,不外套轮询,不另建常驻进程、租约、重算链或冲突分类器。

make 只保真成功/失败,配方失败统一映为 2;要判具体原因读末行 `PR_WATCH_RESULT ... outcome=`。直调 canonical watch 才能区分 1 红、4 CLOSED 未合、69 查询不可用、124 超时;watch 绿不代替 5.3 的 MERGED 核验。完成声明只认真实退出码,不认等待时长。

### 7.2 测试与验证强度

陈述回声先于证明,防止证对错题。程序实现(类型、判决、解析、状态机,含新工件、包、工具、规则及既有修改)须先写完整的行为集成测试与单元测试,先覆盖失败态/fail-closed 边界再正例,用红 → 绿 → 重构实现契约,不多做、不镀金。新代码无行为覆盖或重证库有定理,评审打回;测试先行与尽调仍是评审纪律,不能冒领机器门。

只组合 canonical 程序、转发其退出码和哨兵的胶水脚本不写单元测试套件。它须开头 fail-fast 断言全部输入并有可辨退出码、真实哨兵、幂等或可安全重跑。脚本一旦自有结构解析、红绿判决或状态维护,就已是程序,须迁工具层走 TDD,不以脚本名字豁免;入仓也不使纯胶水欠单元测试债。

检测存在须用变异验证:打断生产机制后有具名测试红,不能只看代码或退出非零。有效红须 `compile_errors=0`、退出码非零、有具名 `[FAIL]` 三项同时成立;整块删除变异目标,不留不可达代码制造编译假红。审 diff 分别看删除和新增测试身份,净数相同不能证明覆盖守恒。拒绝侧之外,授权齐备应接受的放行侧必须单独覆盖。

变异完成证据是六元组:位置、具名红测试、compile_errors、退出码、逐字节还原、**跑前写下的预期红数量与名字**。预期值独立于被测函数计算,不能随实现一同变而恒真。实得少于预期逐条查漏覆盖或自指,多于预期查越界;不要求数量机械相等,要求所有差额归因并写入结论。changed-path 为判据的门,须在命中闭包与不命中闭包两种分支上下文分别运行留读数,不能只在修改自己的分支自证。

**永久禁止对 workflow 内容写测试**,包括直接/常量/helper 间接读取 `.github/workflows/**`,以及为此存在的 YAML 分析器和自测。唯一豁免类是被测对象本身为消费 workflow 的生产逻辑,使用自己的夹具验证该逻辑,不是钉真实 workflow。豁免集合 removal-only,不得扩名单放新 workflow 测试。workflow 正确性由 5.6 的实际事件 run 与评审承担,形状绿不能证明会执行。

`WorkflowTestProhibitionTests` 的 C# 源扫描有放行侧与豁免收缩测试,但只是早反馈。字符串拼接、常量/变量间接、环境/文件路径、相对路径、非 C# 测试可绕过;项目不编译/不跑、Fact 删除、扫描前缀错误可使检查缺席。不能称已证明树上不存在 workflow 测试,也不能以扫描未报作许可。

功能/架构测试判词只依赖被测输入和注入时间,不依赖挂钟或机器性能。时间须显式输入、fake clock/virtual time 或钉住的生产常量;真实等待仅为 `infrastructure-hang-guard`,永不承功能判词。性能实验分离,不得按 elapsed、重试次数、N 秒内完成或宿主负载判功能红绿。

编译期 `BannedSymbols.Determinism.txt` 在已接线 xUnit 判词项目以 RS0030 禁 `DateTime.Now/UtcNow`、`DateTimeOffset.Now/UtcNow`、`Environment.TickCount/TickCount64`、`System.Random`、`Thread.Sleep(Int32|TimeSpan)`、`System.Diagnostics.Stopwatch`,以及 Task.Delay 的 Int32、Int32+CancellationToken、TimeSpan、TimeSpan+CancellationToken、TimeSpan+TimeProvider、TimeSpan+TimeProvider+CancellationToken 六形。编译失败证明须逐 marker 对齐 RS0030。

`TestScratchRoot.cs` 只放行具名 `TestEnvironmentBridge`,架构测试按位置与每种能力钉住,是否误用能力作性能判词仍需评审。tracked `tools/tests/**/*.cs` 的时长集中于唯一 `TestBudgets.cs`,成员逐项标 `pinned-production-constant` 或 `infrastructure-hang-guard`;这是软约定,preflight 绿不证明来源完备。

已路由子进程 hang guard 以 `TestProcessRunner`/watchdog 行为测试钉为 SkipException;`make -C tools test` 与 candidate engineering executor 经 `TestResultEvidence.Load` 读 TRX,reason 以 `infrastructure-hang-guard expired` 开头时产 `INFRASTRUCTURE_UNRESOLVED` 且非零退出,不能把基础设施未决当业务通过。

时间检查的未覆盖边界包含别名、静态导入、显式/目标类型构造、常量派生、default(TimeSpan)、DateTime 相减、helper duration、dynamic/反射、source generator、P/Invoke、shell/Make/Python 时间源、未列 timed-wait API、误用具名 budget。接线可被 pragma/NoWarn/editorconfig、条件 PackageReference/AdditionalFiles、MSBuild 排除、未编译/未运行项目或新增未接线项目跳过。硬保证只限已列且已接线符号与 TRX 消费,不能用不完备文本或 AST 形状扫描宣称全部语义已知。

supervisor 的 lock/build deadline 可注入 `STRATALINT_SUPERVISOR_CLOCK`;夹具以持久化步进时钟及 FIFO/sentinel 推进,真实让步不判功能。disk free/fd soft limit 与 fd/RSS peak 只作 `RESOURCE_OBSERVATION`,采集失败不改业务退出码;不为这些读数另建决定功能红绿的性能账、elapsed comparator 或预算汇总机器。

### 7.3 作业生命周期、等待与日志

预期超出宿主前台预算或时长不可知的长任务,包括构建、全量测试、make 作业及 codex/sshx 席,须走宿主 harness 的作业机制(Claude Code 的 `run_in_background: true` 或宿主等价物)。调用本身覆盖任务完整生命周期,返回前收拢全部子进程,真实退出码落哨兵;不能用 launcher exit 0、口头完成或已用时间替代。

禁止用 `nohup … &`、`setsid … &` 或 shell `&` 甩脱宿主。脚本内部并发允许,但 `&` 与收拢全部子进程的 `wait` 必须在同一条命令中,不得事后补。写调用时核对被调程序实际行为:这条命令返回时任务是否结束,不能凭印象假定它 detach。

宿主会主动通知作业终局时,该通知就是唯一等待通道。不得再用 TaskOutput 或等价阻塞任务读等待,不得轮询日志/产物猜完成;收到通知后按其输出路径读一次是消费产物。宿主不会通知的外部事件,使用其同步原语,如 `gh pr checks --watch --fail-fast`、`gh run watch`、auto-merge、`wait`、make 目标本身,整体纳入宿主作业。

确实没有同步原语的外部状态才可轮询:间隔对齐事件真实节奏、有上限、每轮时间戳与关键读数,判据在开跑前写死。不能把宿主终局作业再包装成这种例外。依赖等待的完成声明引用原语或哨兵,不写等了多少分钟作为证据。

诊断看真实退出码,判活看 CPU 增量而非静默。信号误导首先修 producer:输出 scope 到实例/时间窗,一信号一义,唯一权威,失败显式。过载诊断读 CPU idle% 与 memory_pressure,不读混入阻塞线程的 loadavg;日志计数区分本次 boot 的 current/full/last,不能用全历史回答现在;exit 143 须对齐终止、同步或 watchdog 语境。不要把坏原材料的责任推给下游更警惕。

凡近因是 codex 运行失败、超时、无结果,或 sshx 异常退出/abstain,**先读原始日志再归因**。未读不得写尸检、提本仓或上游 issue、声明完成、选修法或推测题难。权威为实际 codex rollout(`~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl`);载体若实际记录了运行信封,一并读真实 prompt、stdout/stderr、退出码与终态,不能假设它一定存在。

逐动作与时间戳看相邻间隔、命令频次和结束方式。连续活动不等于 hung,CPU 0 不等于死,超时不等于难,空 stdout 不等于未工作。归因须引用实际存在的日志路径,缺失的结论无效、须撤回重做;路径存在性可判但有跨 CI 可移植边界,不能冒领为已部署 lint。

每次反思跑 `tools/scripts/agent/selfaudit.sh`。转录审计识别未 wait 的尾随 &、已知长任务前台、阻塞任务读取及 sleep 加宿主任务输出路径;命令匹配限命令位置,先剥 heredoc 体而非整条豁免。输出全部绿不证明生命周期合规。该器是自审而非 CI 门,非 sleep 延时、变量任务路径、非 Bash、宿主目录变化和无人运行均是反例边界。

### 7.4 缓存、查询与历史重放

Lean 构建过几分钟未完先查缓存,约十分钟以上先核缓存而不推断数学难。读该次 `LEAN_CACHE` 收据的 status(seeded/present/degraded)、method(clonefile/cache-get/none)、project/mathlib olean 的 warm/cold、archive_status 与 archive_skip_reason。project cold 是将全量重编内容层的事前信号。声称慢因数学须同时贴收据;冷编译成本必须绑定树、所含昂贵子图、硬件与缓存条件,不能挪用历史时长。

cache 不是真源。key 恰好覆盖能改变复用值或接受语义的输入,或在复用后有独立等价重证;少输入是假命中,整份加入不影响值的信息是假失效。不得以 commit SHA 作最小内容 key。全文文件入 key 须在 PR 说明哪些字段影响产物、哪些不影响,只有相关字段才入。

下游为 Lake/Bazel/dotnet 等权威增量系统时,cache 可以只给近似起点,差量由该系统自行判定补编,不追求命中即完全无需重建;不得用自写启发式代替有效性判定。改变缓存机制须同时给 cache 层命中/key 变化与下游增量重算规模两层读数,不能从 metadata-only 的无重编推论未测的 Lean options、依赖版本或 CI 时长。

已提交 git 的值按内容地址直接信任和读取,不得为证明它仍是旧值而重新推导、重放或重建。已入账的 statement_id、witness_id、frozen_node_id 不从 report 重算来核对;对象存在性/类型校验只对 base→candidate 增量,不重复验 base 已验对象。当前态 pin 与新环境许可集检查见 4.1、4.7,不能混称历史重审。

按结果去向区分两类重复计算:只与已存值比对以证明没变,是应删除的重放验证;结果被下游实际消费,是合法查询,若同输入反复算才按最小充分输入闭包内容寻址记忆化。每轮只需一次的查询没有重复收益,不要为它造缓存。账本结论按 head 内容地址复用、只处理增量事件;未来真正要用的原料须与派生值同存,缺存储修记录,不要求升级后 build 旧工具链拿历史字段,也不为重审而额外保存旧公理闭包。

### 7.5 静态资源派生

资源反事实域是语义不变、仅改进程 vCPU 或内存配额;公式须有类型、单位、合法域且可机械求值,容量变就重算,结果字节可不变。并发、槽、worker、驻留批量及 owner 明定的「有界工作量÷版本化吞吐」等待预算在域内。锁租约、协议活性、API/网络 deadline、正确性/安全上限、测试夹具、格式和 SL-003 目录容量在域外;不按 timeout/memory/batch 名字划域。

按产物三选一,不允许未报来源的第四形:

| 分类 | 合同 |
| --- | --- |
| `capacity-derived` | 产容量值,声明同单位静态 C_i、属主单任务 r_i 与输入约束,同输入同值 |
| `relation-derived` | 只证已分类端点的关系,不产生或赦免容量末值;依赖 DAG 无环,没有未分类端点或未具名裸叶 |
| `policy-override` | 明报「不是派生值」、决定日期、域、正反读数、永久案号、owner、退出条件或复审触发;非永久,无号须写 `open(案号待开)` |

常函数不能掏空分类。owner 可定任务画像、具名保留、超配系数与规则选择,不能把裁出的末值或平台上限伪装成推导。

静态计算为 `C_i=min_j U_{i,j}−R_i`,其中 U 是同单位适用上限,R 是该维具名静态保留;`q_i=floor(C_i/r_i)`,`N=min_i q_i`。CPU 与内存分维,不能混同一 min。CPU 上限包括在线 vCPU、cpuset/affinity、核数化 cgroup cpu.max、runner CPU allocatable/request/limit;内存上限包括宿主总量、cgroup/容器 memory.max、runner memory allocatable/request/limit。无上限不入 min,request 与 limit 必须在字段名区分。

r_i 来自属主具名强限(`-j K`/cgroup limit),或隔离、可复现、版本化峰值基准收据,只能按 workload 身份/版本选。按平台、runner、profile 等同时决定 U 的容量承载键选 r_i,就是 policy-override,须有案号、owner、退出条件。min/floor 是跨机结构,其余为数据;缺任何必要输入即 open/不可派生,不能用瞬时 RSS、漂移量或裸数补。

容量反事实只许 U 变化;r、R、工作量、吞吐收据、超配系数、舍入规则、合法域及所有遮蔽上限须定版且逐字节不变,不得反读 U/C/q/N/当前配额派生。固定这些叶后,在合法域每个未受其他资源瓶颈或遮蔽上限的相邻 q 商边界,检查受控参数**有效末值**按声明舍入变值,不能只看证据或元数据变化。

每个遮蔽上限,无论平台、workload-local 或 harness-local,须归入三型之一。正确性/安全上限给出域外依据;否则归 `policy-override` 并带案号、owner、退出条件,不得以「独立分类」自豁免。`N<1` 报容量不足,禁止 `max(1,…)` 隐藏不可行;batch/timeout 各声明量纲、公式、合法域与边界判据。

启动期前馈默认只读稳定的 vCPU、总内存、cgroup、cpuset、容器配额、runner 规格,两次同条件读应相等。禁止 loadavg、CPU idle/utilization、free/available memory、memory_pressure、cgroup 当前用量、运行队列、进程数、排队时长、近期耗时或吞吐流入默认计算;这些只作 observation、诊断或离线标定,不得 observation→取值或启动后回写。过载诊断仍按 7.3;有具名状态、稳定性契约与失败边界的动态反馈是另一机制,不以本条偷管。

验证须固定 C/r 扰动漂移量而输出逐字节不变,改变上限则重算,并检验固定非容量叶后的有效商边界。静态容量读者不得复刻成第二真源。上述公式、域和反事实是绑定义务,未经具名消费者与变异证据不能称自动资源门,preflight 绿不证明本条完整执行。

**有效 override:**[report-supervisor.sh](tools/scripts/report/report-supervisor.sh) 的 Lean 默认并发槽为 **5**,不是静态派生值。域为该 supervisor 默认槽数,永久案号 **#1910**,owner 为仓库 **τ=0 owner**。其作用是降低等待槽的延迟/失败,不是提高已吃满 CPU 的构建总吞吐;并发内存外推不是实测峰值或 C/r 收据。原始正反证据与决定记录由该 tracked 脚本的注释保存。**#1910 关闭或静态 C_i/r_i 收据齐备任一成立即复审,届时派生或撤销**,不得把 5 当永久容量常数或冒称已解决饥饿根因。

### 7.6 器的居所与语义工具

跨会话复用的器 tracked 于本仓:agent 器在 `tools/scripts/agent/`,harness 器走 `tools/`,不住 `agents/`、宿主目录或 scratchpad。被宪章、记忆或 skill 引用即属跨会话工具,引用必须指向仓内 tracked 文件。纯本会话一次性探针/搬运胶水例外;预计第三次重复就先铸器,铸完进所属层 make。

代码语义分析用编译器/语言服务器:C# 用 C# LSP,Lean 用 Lean LSP。定义、引用、可执行调用与模块依赖等承重结论须给工具、符号、位置与口径,不能拿文本匹配当语义。字面量、注释文档、粗筛后逐个语义确认,或 LSP 覆盖不到的 shell/Make/YAML 仍可文本检索。

能力缺失先安装/配置适合工具,但配置是宿主本地能力,不是仓库政策或可随仓分发的保证;Lean 的 `lean --server` 是内置能力,C# 可用相应 LSP。换宿主须实测能否配通,不得假定,也不能从方法义务推导未经授权的宿主配置改动。

## 8 权威入口

本文件集中工作决策,具体定义与命令到其既有唯一属主查证,不复制维护另一份政策。

| 入口 | 作用 |
| --- | --- |
| [agents/CONTEXT.md](agents/CONTEXT.md) | 必读有限上下文地图(≤2K token)、GID 文法与风格 |
| [golden-ledger-repo-spec.md](docs/develop/spec/golden-ledger-repo-spec.md) | 单一完整规范;第三方成果 A17/A17.2、超仪注册表 11.9、判词可诉 11.14、canary 11.19 等具体合同 |
| [Meta/FILEMAP.toml](Meta/FILEMAP.toml) | 路径、kind、producer、verifier 与驻留的映射真源 |
| [docs/develop/theory/](docs/develop/theory/) | 理论参考输入与 provenance,不作形式结构真源 |
| [agents/](agents/) | scout、prover、numericist、librarian、adversary、scribe、theorist、gate 八官职责 |
| [Makefile](Makefile)、[tools/Makefile](tools/Makefile) | 内容层与工具层活器谱,分别运行 help |
| `/sshx` (`consensus-rnd:sshx`) | 隔离载体的设计、实施、评审编排;本仓覆盖规则见 5.5 |
