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
| [A398581](https://oeis.org/A398581) | 5/k 的严格三单位分数分解中，字典序首解不取得最大 z 时必有 k≡1 mod5。 | 1 | open | low | yes | dispatch |
| [A398307](https://oeis.org/A398307) | 数位和 Van Eck 变体的零点恰为列出的26个指标，最后一个为541。 | 3 | open | low | yes | note-only |
| [A398259](https://oeis.org/A398259) | 数位和 Van Eck 变体满足 c(n)/n→1；另有与 A398307 相同的26零点猜想。 | out | open | low | yes | note-only |
| [A398186](https://oeis.org/A398186) | U(r)=(4r)!/((2r)!r!²) 时，r+s+1 整除 U(r)U(s)，从而卷积除以 n 为整数。 | out | published | med | yes | drop |
| [A398383](https://oeis.org/A398383) | C6a=B(q)(5+22u+5u²)/(1−u)³ 的第n项系数被n²整除。 | out | published | low | yes | drop |
| [A398901](https://oeis.org/A398901) | C6b=B(q)(1−u)/(1+u)² 的第n项系数被n²整除。 | out | published | low | yes | drop |

## 逐条证据

### A399084

精确目标：对原条以历史未用性定义的 `seq`，极大下降段恰为初始五个单点，以及每个 m≥2 在 s=m²+m−1 的四段 `(s,m),(s+m,1),(s+m+1,m),(s+2m+1,1)`。文献裁决：完整读本条与一跳引用；虽 OEIS 原文仍写 Conjecture，基线已含公开冻结的 `D5.S1.Digit.GreedyFloorSqrtRunBlocks.maximal_decreasing_run_lengths`（`D5/S1/Digit/GreedyFloorSqrtRunBlocks.lean:765`），其 literal-history `seq`、`IsMaximalDecreasingRun`、`seq_eq_closedForm`/`seq_four_blocks` 与目标匹配；冻结 state 的 statement_id 为 `sha256:601488f603b60668052dfc38ee7ce71ae93d3834a0fea46d0fae74f178884908`，此处 published 指公开仓内证明，未重编译。bind-only 疑似声明：上述 exact iff 已覆盖全目标，high，不能再派桥接席。数值方案实际跑 hash-set 历史递推 100001 项，以一次线性扫描取完整下降段，1259 段全部吻合，68 项 DATA 全相等；末尾未完成段不作反例。便宜形态是在线集合+游程扫描，无需对每一步重扫全部历史。拟议逃逸：无新增目标，drop；停止条件已触发为精确冻结同题。同族合派：本轮仅此一条，零席；不得改名为闭式再派。xref 预检全部直接 A 号（完整读）：A000196、A020703、A038722；这些是背景平方根序列，决定性淘汰证据来自仓内 exact theorem。

### A398581

精确目标：S_k={(x,y,z)∈ℕ³:0<x<y<z 且 5xyz=k(yz+xz+xy)}；若 S_k 非空且其字典序最小解的 z 小于 max z，则 k≡1(mod5)，不主张逆命题或所有 k 可解。文献裁决：完整读本条与全部直引，原条仍为 Conjecture；k=5q+4,q≥1 的排除论证已给出，不能冒充所有非1剩余类证明。A257843 只是4/k类比；A075249–A075251 的首解即停代码不能承重“最大z”，k=11 的首解(3,9,99)和最大解(4,5,220)已分离。打开官方 b398581.txt，未发现全目标证明，open。bind-only 疑似声明：Mathlib 的 `div_eq_div_iff` 只消去非零分母；D5 按 Egyptian/unit-fraction 与本号检索未见目标声明（none 限此次），跨剩余类最优性尚非绑定。数值方案实际用约分 a/b=(5x−k)/(kx)，仅枚举 k/5<x<3k/5 及 `(ay−b)(az−b)=b²` 的正因子对，过滤 d<b、d≡−b(mod a)、互补因子同余和 x<y<z；同时维护 lex 与 max z，保留并列最大z语义。k=1..1500 共450000个x、685283个合法三元组；得到86项全为1mod5，57项DATA及完整86项b-file完全吻合，k=1,2无严格解，计算段7.78秒。拟议逃逸：用残差分子 a 的小值按0、2、3、4mod5比较首解与所有后续x的 z 上界，重点是尚未由原条证明的0/2/3类；不是再跑三重枚举。停止条件：一个非1类的严格首解/最大解差异即反驳；只重证4类、得到有限窗口或找到文献全证明均停止派新席。同族合派：本轮独立一席，与4/k类比不合为同一个命题。xref 预检全部直接 A 号（完整读）：A075248、A075249、A075250、A075251、A257839、A257843。

### A398307

精确目标：按 A398259 的严格历史递推 c，∀n≥1，c(n)=0 ↔ n∈{1,2,4,6,11,13,18,21,25,33,46,170,187,196,288,320,334,424,433,437,455,505,514,523,530,541}。文献裁决：完整读本条与全部直引，原条“conjectured this list is complete”仅附10^6窗口；A181391 的无限零点证明查询前项自身，本变体查询十进制数位和，不能套用。bind-only 疑似声明：Mathlib `Nat.ofDigits_digits` 仅重构数字，D5 按本号与 digit-sum/Van Eck 搜索未见此全称目标（none 限本次）；不是有限状态系统的现成周期定理。数值方案实际用实际项值→最后指标字典，先查询 digitSum(c(n−1)) 的历史 j<n−1，再插入前项；单遍1000000项恰出现这26个零点，26项DATA全吻合，n>541到10^6无新增。便宜形态是 O(N) 字典递推而不是逐次倒扫，数位和只花对数位数。拟议逃逸：证明未来全部查询键已被历史覆盖的无界归纳不变量；新键范围随n增长，不能凭窗口封闭成有限自动机。停止条件：n>541出现零点即反驳；只有有限运行不得报证成；尚无覆盖不变量故note-only。同族合派：与 A398259 的零点子猜想完全同题，若日后有逃逸只合一席；极限=1既不等价于最后零点541，也未在此证明。xref 预检全部直接 A 号（完整读）：A181391、A398259。

### A398259

精确目标：c(1)=0；n≥2 时令 s=digitSum₁₀(c(n−1))，若最近 j<n−1 满足 c(j)=s 则 c(n)=n−1−j，否则0；主目标 ∀ε>0,∃N,∀n≥N,|c(n)/n−1|<ε。文献裁决：完整读本条与全部直引，原条明列极限猜想；A398260 的数位积变体有不同长期行为，A181391 的原始 Van Eck 结论不覆盖本目标。out 是渐近目标不派，并非文献已证明；open 不降成 published。bind-only 疑似声明：Mathlib `Nat.ofDigits_digits` 与一般极限定理不提供最近历史索引 j=o(n)；D5 按本号及数位和历史递推检索未见具名全目标（none 限此次），风险low。数值方案实际以先查后写字典算1000000项，80项DATA全等；c(10^4)=9365、c(10^5)=99353、c(10^6)=999847与原条三个检查点全等，26零点同 A398307。便宜形态是流式字典；若扩大实验应另记区间内最大缺口 n−c(n)，不能只看10的幂端点。拟议逃逸：把极限转为被查询键最近出现指标的 o(n) 上界，目前未构造，note-only。停止条件：有限端点吻合不立极限；仅证最终无零不报本主目标完成；找到对应全称上界或已发表证明再改判。同族合派：有限零点子目标与 A398307 合一席、零个当前派席，极限为另一个更强长期问题，不能把两者计为两次零点成果。xref 预检全部直接 A 号（完整读）：A007953、A181391、A398260、A398307。

### A398186

精确目标：∀r,s≥0,(r+s+1)∣U(r)U(s)，蕴含 ∀n≥1,n∣Σ_{k<n}U(k)U(n−1−k)。文献裁决：完整读本条及直引，打开 Shvets https://arxiv.org/html/2607.19427v1 ，Lemma 3.2 正是逐项整除，证明以 Legendre 的每个素数幂层比较余数；主席亲读其证明及 Proposition 3.1/Corollary 3.3 的坐标映射，reader2另读全文。仅预印本证明公开，未核实同行评审。A143583 的整数组合公式与 Catalan 乘积还覆盖弱化的卷积整数性。bind-only 疑似声明：Mathlib `padicValNat_factorial`、`Nat.succ_mul_catalan_eq_centralBinom` 是邻近工具，未搜得此四倍二项式逐项整除的 exact theorem，med；论文已有证明即不派，不能拿未入mathlib当开放。数值方案实际构造整数二项式 U(r)=C(4r,2r)C(2r,r)，检查r,s≤100全部10201对余数，零反例；64项卷积中17项DATA全等。便宜形态为二项式数组+卷积和模运算，无须模形式库。拟议逃逸：当前目标无；停止条件是已读到全目标证明，不能把同论文已证加强版再派。同族合派：与 A398383/A398901 同一 K3 模形式包，若补文学桥共一组，当前零席。 xref 预检全部直接 A 号（完整读；占位另注）：A000108、A000897、A143583。

### A398383

精确目标：u=64q∏_{m≥1}(1+q^m)^24、B=Σ_{k≥1}k^5q^k/(1−q^(2k))；∀n≥1,n²∣[q^n]B(5+22u+5u²)/(1−u)³。文献裁决：本条及全部直引完整读，打开 Shvets https://arxiv.org/html/2607.19427v1 Theorem1.1式(1.5)、Theorem5.3、Corollary6.2及7.2、§8完整合并证明；主席核对目标与奇素数/2进制合并，reader2读承重全文。旧 Bönisch–Duhr–Maggio arXiv2404.04085 Appendix B.1 只猜磁性，不是降级原因；新预印本的分母恰为1证明才是原因。bind-only 疑似声明：`PowerSeries.coeff_mul` 给有限反对角卷积，未检得D5或Mathlib的此亚纯模形式整除定理，low；没有现成形式化不改变published。数值方案实际用整数截断级数至q^64；展开有理函数的第j项系数16j²+16j+5，64个n²整除及v₂(c(n))≥5v₂(n)全部通过，15项DATA全等。便宜形态与 A398901 共用u、B和幂数组，不数值求q或做浮点微分。拟议逃逸：原条的2-adic加强版也由§7覆盖，当前无；停止条件已触发为确切公开证明。同族合派：三条 K3 包只算一个文献依赖组、零当前席；换成正性或2³ʳ整除商不构成新增靶。 xref 预检全部直接 A 号（完整读；占位另注）：A096960、A398186。

### A398901

精确目标：以 A398383 段明定的u、B，∀n≥1,n²∣[q^n]B(1−u)/(1+u)²，系数允许负数；并辨明 n=2ʳm、m正奇数时v₂(c(n))≥5r的加强命题。文献裁决：本条与全部直引完整读，打开 Shvets https://arxiv.org/html/2607.19427v1 Theorem1.1、Theorem5.3的 F_{−4,2}=32C6b、Corollaries6.2/7.2与§8证明，后者初项q−40q²+1108q³确认商的归一化；reader2另读2404.04085与Löbrich–Schwagenscheidt2010.06297背景。主席亲核§8及加强版，分母统一有界不能冒充本目标分母1，降级凭新全文证明。bind-only 疑似声明：`PowerSeries.coeff_mul` 只提供系数卷积；D5/Mathlib按本号、magnetic及模形式关键词未见此exact目标，low。数值方案实际截断q^64，使用有理函数展开系数(−1)^j(2j+1)，64项n²整除和5r估值全通过，18项DATA全等；便宜形态共用 A398383 的整数级数，保留符号。拟议逃逸：2³ʳ∣a(n)已被同文覆盖，不再提作新靶；停止条件已满足为明确证明。相同模形式包三条合为一个依赖组、零派席，不能分三席搬论文。 xref 预检全部直接 A 号（完整读；占位另注）：A096960、A398186、A398383。
