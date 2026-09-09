---
bibkey: oeis-triage-20260909
authors: OEIS Foundation Inc.; Codex triage workers
year: 2026
title: 93 OEIS candidates — statement and proof triage, 2026-09-09
doi: null
url: https://oeis.org/
claim: Source-based dispatch screening; no new mathematical theorem or Lean module is claimed.
strata_touched: []
license: citation-only
triage: anchor
---

# 93 条 OEIS 候选的批量判形与文献分诊

源码基线固定为 `4546f231b3d416239a21d9494974ca3ccf684c7a`；Mathlib 钉版为 `db584cd6d46c92f209a44c0f1c829460d327499d`。本文件是文献与派席建议，不是数学证明、模块准入或冻结记录。产地：一席 Codex 主席、三个同模型族 codex-cli 文献分工席；主席复核候选与关键淘汰依据。使用 lean4 skill 的声明检索部分，未执行 Lean；没有异模型独立共识。

## 判据与排序

`precise` 表示定义和量词可明确编码，不表示容易证明；`vague` 表示原表述或序列成员资格尚依赖未固定语义。档位 1 是可考虑短组合/算术探针，2 是非普通有限实例的计算前沿，3 是需要研究方向的核心/深层目标；`out` 表示已知、错误、纯定义或本席排除的无界解析目标。即使离散全称陈述 precise，也可能属于 3。

`published` 只用于公开证明、完整论证或能明确推出目标的已知公式；它包括注明的公开反驳，不等同于“猜想为真”。`open` 只表示所查材料仍猜想且未找到证明；`unknown` 表示相关论证、公式证明或定义桥未核实。出现过同一句猜想不算证明。数值 `yes` 只表示几十行程序可核查有意义的小参数前缀，绝不表示全称可由有限实验确证；`no` 的条目另解释障碍。

`dispatch` 按拟议逃逸的明确程度、数值可验性和 open 证据排序；它是有停止条件的后续探针建议，**不是已经构造出逃逸见证**。同族依赖任务合并派，避免按 A 号重复实施。所有签名均为未编译的数学伪签名。bind 风险是源代码声明检索判断：列出的通用声明只说明最接近的候选；`none` 不是全库不存在定理的证明。

本检查点已分诊 **30/93** 条：dispatch 3，note-only 20，drop 7；文献 open 22，published 6，unknown 2。 尚未列出的条目仍在查证，不能视为已淘汰。

## Verified locator

源站 https://oeis.org/ 。2026-09-09 对每个输入以及其 comment / formula / xref 中的**全部直接 A 号**逐个请求 `https://oeis.org/search?q=id:<A号>&fmt=json`，保存完整原始 JSON，未截断字段。93 个源条目加 323 个额外引用共 **416** 个唯一条目，416/416 HTTP 成功、JSON 编号匹配；不是递归遍历所有引用的引用。每段末列出该源条目提取出的完整集合（包括源文自引）；空集合写 none。逐条结论区分“取到完整条目”和“已读链接中的证明”，未打开的链接不当证明。

关键实际打开定位：

- Shah–Kiselev, https://arxiv.org/html/2605.11137v1 ，§3、Claim 4.1、Remark 4：带权和结果与无权奇偶差猜想分开。
- Höft, *Theorems Relating to Conjectures by Omar E. Pol* (2026-03-21), https://oeis.org/A237270/a237270_4.pdf ，Theorems 1、3、4 及其证明；几何定义桥另逐条判断。
- A395171 公开反驳 https://mathoverflow.net/a/511088 ；存在性论证 https://mathoverflow.net/a/511242 ，已通过 StackExchange API 获取完整回答正文。

原始检索工件在本次 runner attempt 的 `oeis/`、`oeis-manifest.json`、`refs.json` 和分工日志；manifest 含 URL、时间、revision、字节数和 SHA-256。它们是本次机器上的审计工件，**未作为仓库附件发布，临时目录不承诺长期可用**。本文件中的公开 URL 和具名证明位置是持久查证入口。仓库交付保持单文件。

## 排序表

| A号 | 一句话陈述 | 档位(1/2/3/out) | 文献(open/published/unknown) | bind-only 风险(low/med/high) | 数值可验(yes/no) | 建议(dispatch / note-only / drop) |
| --- | --- | --- | --- | --- | --- | --- |
| [A392714](https://oeis.org/A392714) | 合格 Wronskian 贡献排列的偶排列数与奇排列数之差为 (−1)^(n+1)。 | 1 | open | low | yes | dispatch |
| [A397711](https://oeis.org/A397711) | 入度至多2的 n 点有标号 DAG 数，奇 n 模 n 为1，偶 n 模 n 为 n/2+1。 | 1 | open | med | yes | dispatch |
| [A388986](https://oeis.org/A388986) | 每个Euler形奇数N=p^(4a+1)r²（p≡1 mod4为素数，奇数r>1且gcd(p,r)=1）都满足unitarySigma(N)+sigma(rad(N))<2N。 | 1 | open | low | yes | dispatch |
| [A392197](https://oeis.org/A392197) | SRS(m)所有部分宽为1且中央两部分相遇，当且仅当奇因子数等于2-稠密因子块数且中央相邻因子满足d₊=2d₋+1。 | 1 | unknown | med | yes | note-only |
| [A389105](https://oeis.org/A389105) | gcd 驱动递推的每个正整数除数都有首次出现，且首次位置超过(6/5)^(n−1)。 | 3 | open | low | no | note-only |
| [A392498](https://oeis.org/A392498) | 所有完美数N都满足其介于1与最大真因子L=N/minFac(N)之间的因子之和严格小于L。 | 3 | open | low | yes | note-only |
| [A397155](https://oeis.org/A397155) | 每个 n≥2 的立方 n³ 都可写为三个素数的 p·q+r。 | 3 | open | low | yes | note-only |
| [A397258](https://oeis.org/A397258) | Buss B 序列的迟现素数位置等于全部未来的严格纪录低点位置。 | 3 | open | low | yes | note-only |
| [A397259](https://oeis.org/A397259) | Buss B 序列的迟现素数等于右向左严格纪录低点。 | 3 | open | low | yes | note-only |
| [A397260](https://oeis.org/A397260) | 若干十进制数族（如8·10^k−2）始终创下除数数字积和的新纪录。 | 3 | open | low | yes | note-only |
| [A397341](https://oeis.org/A397341) | 从1开始、每次拼接最小可用素数的素数递推永不停止。 | 3 | open | low | yes | note-only |
| [A397369](https://oeis.org/A397369) | level 2 对称立方超几何系数在 p≡1 mod4 时满足全层 p^(4r) 超同余。 | 3 | open | low | yes | note-only |
| [A397699](https://oeis.org/A397699) | 每个素数都在十进制插入算法中成为最大指数素因子的决胜底数。 | 3 | open | low | yes | note-only |
| [A397705](https://oeis.org/A397705) | 奇数 m>5 无表示 m=p+2q、p<q 的例外恰为 {7,11,23,35,83,167}。 | 3 | open | low | yes | note-only |
| [A397789](https://oeis.org/A397789) | 离素数 q 的 3/2 次幂最近的素数，平方后也离 q³ 最近。 | 3 | open | low | yes | note-only |
| [A397790](https://oeis.org/A397790) | 离素数 q 的 3/2 次幂最近的素数，平方后也离 q³ 最近。 | 3 | open | low | yes | note-only |
| [A399051](https://oeis.org/A399051) | 对第 n 个素数 p_n，奇 primorial 减去某个小于 p_n² 的正偶数是素数。 | 3 | open | low | yes | note-only |
| [A393833](https://oeis.org/A393833) | 对每个n≥1，存在恰有2n+2个正因子的k，其按升序排列的全部真因子模n后为回文。 | out | open | high | yes | note-only |
| [A394054](https://oeis.org/A394054) | 对每个n≥1、k≥1，n以内恰有k个最大连续2-稠密因子块的整数个数，等于其σ的对称表示恰有k个连通部分的整数个数。 | out | published | med | yes | note-only |
| [A394791](https://oeis.org/A394791) | 中心两部相接且有2n个 SRS 部分的最小整数，等于相同条件的2n稠密块最小整数。 | out | published | med | yes | note-only |
| [A395156](https://oeis.org/A395156) | 中心两部相接且有2k个 SRS 部分的第 n 个整数，等于满足中央因子关系的2k稠密块整数。 | out | published | med | yes | note-only |
| [A395171](https://oeis.org/A395171) | 最小合格 m 的 gcd(m^(p·k)−1,m!−1) 被猜想与正整数 k 无关。 | out | published | low | yes | note-only |
| [A399155](https://oeis.org/A399155) | 反复减最小素因子的步数不少于反复减最大素因子的步数。 | out | published | low | yes | note-only |
| [A390878](https://oeis.org/A390878) | 卷积Σₖ₌₁ⁿp(n−k)·SRS部分数(k)是否等于原文所指以各整数因子组成分拆的2-稠密因子块总数。 | out | unknown | high | yes | drop |
| [A396081](https://oeis.org/A396081) | 满足 A381466(2p)=p 的素数 p 有无穷多个。 | out | open | low | yes | drop |
| [A396696](https://oeis.org/A396696) | 存在实数 C，使所有 floor(C·(n!)²) 都是素数。 | out | open | low | yes | drop |
| [A396847](https://oeis.org/A396847) | 嵌套素数幂级数的收敛半径 r 满足 A(r)=1。 | out | open | low | no | drop |
| [A398129](https://oeis.org/A398129) | 最近对称素数对树在 6k+1 类中有唯一无限分支。 | out | open | low | no | drop |
| [A398130](https://oeis.org/A398130) | 最近对称素数对树在 6k−1 类中有唯一无限分支。 | out | open | low | no | drop |
| [A398812](https://oeis.org/A398812) | 除数矩形在 n×n 正方形中未覆盖面积 a(n) 满足 a(n)/n²→1。 | out | published | low | yes | drop |

## 逐条依据与实施边界

**A392714 — precise；dispatch。** 精确目标：用一基索引：Φ(n)={σ∈Perm({1,…,2n})：σ(1)=1 ∧ ∀1≤k<2n, Σ_{i=2n−k+1}^{2n}(σ(i)−1−n)≥0}，和在 ℤ 中计算。拟签名 `theorem parity_imbalance (n : ℕ) (hn : 1 ≤ n) : (∑ σ ∈ Φ n, signInt σ) = (-1 : ℤ)^(n+1)`。有限集合、signInt 和一基到 Fin(2*n) 的转换须在实施时定义；不是已编译签名。 逃逸：拟议逃逸是构造保持所有后缀预算非负的反号对合，并分类其唯一未配对排列。现有求和消去定理不提供这个组合构造；尚未找到/证明该对合。只派一次有停止条件的组合探针，不能把差为1本身当定义。 文献/卡点：Shah–Kiselev, arXiv:2605.11137v1 第3节定义 Φ_p，Remark 4 明确把奇偶差称 conjecture；Claim 4.1 的带权和并未证明这个无权差。A147681 是关联的 late-growing 排列计数，不能因其已出现就降为 published。 Mathlib：Finset.sum_involution（Algebra/BigOperators/Group/Finset/Basic.lean 的 to_additive 生成声明）：只负责已给定反号对合的消去，缺少本有限集上的对合及唯一余项。 数值方案：枚举固定首项为1的 {1,…,2n} 排列（n≤4），从右向左累加 σ(i)−1−n，任一负值即弃；算逆序数奇偶，比较差。应得 n=1..4 的 (偶,奇)=(1,0),(1,2),(18,17),(500,501)；此处只是验证方案与原论文表值，未实际运行。 全部直接 A 引用：A147681。

**A397711 — precise；dispatch。** 精确目标：定义 `dag2 n` 为顶点 Fin n 上无环、每点入度≤2的关系之有限集，令 a(n)=card(dag2 n)。拟签名 `∀ n : ℕ, 3 ≤ n → a n % n = (if Even n then n/2+1 else 1)`。必须从关系计数建模，不能以现成递推冒充组合定义。 逃逸：拟议逃逸是分析循环重标号下的固定 DAG：分类各素数幂长度轨道的入边限制，并计算偶数阶余项，最终组装模 n。仅有素数阶群作用模板不够。对合数部分未完成固定图分类，实施探针若只得已知素数情形即停止。 文献/卡点：源页已证明高度分层计数公式，并给素数阶循环重标号解释；那些子结论不作为新靶。未在完整直接引用条目找到所有合数 n 的同余证明。 Mathlib：IsPGroup.card_modEq_card_fixedPoints；MulAction.sum_card_fixedBy_eq_card_orbits_mul_card_group。前者只给模素数的固定点计数，后者是 Burnside 恒等式，均缺特定 DAG 的合数模数分析。 数值方案：独立枚举 n≤5 的无自环有向邻接位图，检查每点入度≤2并拓扑排序；计数取模。再用源页高度组成递推查 n≤100，仅作第二算法对照。 全部直接 A 引用：A000272、A003024、A243014、A308634、A361718。

**A388986 — precise；dispatch。** 精确目标：def U (N:ℕ) := ∑ d∈N.divisors.filter (fun d => Nat.Coprime d (N/d)), d; def S (N:ℕ) := ∑ d∈N.divisors.filter Squarefree, d; theorem euler_form_lt (p a r:ℕ) (hp:p.Prime) (hp4:p%4=1) (hr:Odd r) (hr1:1<r) (hpr:p.Coprime r) : U (p^(4*a+1)*r^2)+S (p^(4*a+1)*r^2)<2*(p^(4*a+1)*r^2). 逃逸：新有限乘积引理：对由≥b>1整数构成的有限集F，Πq∈F(1+1/q²)≤b/(b−1)，用1+1/q²≤q²/(q²−1)并在[b,M]伸缩证明；再按r是否含3以及是否还有其它素因子分三类，同时界住U/N与S/N，不能把U或S定义成所需上界。 文献/卡点：已完整读主源及15个引用，未见Euler形子序列问题的目标证明；open限于这些源。本席给出可实施推导路线（非已发表证明）：p≥5。若r不含3，U/N≤(6/5)(5/4)=3/2且S/N≤(6/5)(6/25)=36/125；若r仅含3，分别≤4/3与8/15，和28/15<2；若r含3及另一素因子≥5，分别≤5/3与(6/5)(4/9)(6/25)=16/125，仍和<2。指数增大只减小归一化因子。所需界全为有限积及有理不等式，不依赖无穷解析。原文2026另一个prime-factorization subset猜想在support解释下被240反例否定，在多重集解释下18与12也否定，故不派该旁支。 Mathlib：ArithmeticFunction.sigma_apply与sigma_eq_prod_primeFactors_sum_range_factorization_pow_mul，Mathlib/NumberTheory/ArithmeticFunction/Misc.lean:149、206，已读声明；NumberTheory内unitary检索仅Pell等无关代数概念，没有此不等式或单位因子和的现成绑定。 数值方案：几十行试除分解1≤N≤10^6，识别恰一个奇指数、该素数及指数均≡1 mod4、其余指数为偶数且r>1；独立枚举因子d用gcd(d,N/d)=1求U，用squarefree(d)求S，与素因子积Π(q^e+1)、Π(q+1)交叉核查并测试U+S<2N。另实测Browne的prime-support版本首个反例为240：U=408,S=72，而210<240且rad240=30∣210并新增素数7。 全部直接 A 引用：A013929、A034448、A048108、A048250、A228058、A325963、A325973、A325977、A360765、A386427、A388985、A389079、A389215、A389217、A389219。

**A392197 — precise；note-only。** 文献/卡点：已完整读主源及19个一跳引用。实际打开Höft 2026手稿：p.2 Theorem 1证中央相遇⇒d₊=2d₋+1；p.4 Corollary 3证全部宽1⇒奇因子数=块数；p.3 Corollary 1点名A392197，但不能将两个单向陈述冒充整个集合等价的双向证明。A174905有无保留的宽1等价描述，A298856有中央相遇的另一刻画及完整论证，但尚未打开足以闭合所选完整双向目标的几何证明，故unknown。有限奇核链引理看起来很小，文献桥未确认前不派。 Mathlib：none：钉版Mathlib/NumberTheory文本检索dense divisor、symmetric representation未找到SRS或2-稠密块声明；Nat.divisors只是基础设施。 数值方案：对1≤m≤2000直接枚举升序因子，在相邻比例>2处断开；分别数奇因子，取d₋=max{d∣m:d²≤m}, d₊=m/d₋。独立从Dyck边界构建SRS网格，检查各宽度及中央交点；先不要把待证因子条件用作几何端定义。 定位：https://oeis.org/A237270/a237270_4.pdf#page=2；https://oeis.org/A237270/a237270_4.pdf#page=4；https://oeis.org/A298856。 全部直接 A 引用：A001227、A014105、A033676、A033677、A071561、A162348、A174905、A191363、A237270、A237271、A237593、A250068、A262259、A262626、A264104、A280940、A298856、A384222、A384225。

**A389105 — precise；note-only。** 文献/卡点：选离散首次出现及下界目标，不选另附的“每个除数无限次出现”（该子句 out）。源报告扫描10^12步后仍未见除数20；只知55个命中到106。首次位置表有问号，不能按连续数列定义全函数后隐藏存在性。A381466 的短递推不构成全覆盖证明，需具名研究方向。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：维护 b(k) 与 gcd，并首次记录各值；可轻验前17项，但连 n=20 的正例都超已报10^12范围，故“有意义的小 n 完整验证”记 no；不能只对已找到项核对后称验证整条。 全部直接 A 引用：A381466。

**A392498 — precise；note-only。** 文献/卡点：完整阅读主条目和6个直接引用，以及真实打开Luschny的ComposableRigidSparse.ipynb全部说明性单元，未见目标证明。对完美数N，Σ_{1<d<L}d=N-1-L。若N偶，则L=N/2，和=L-1<L；若N奇，最小素因子p≥3且L≥p，N-1-L=(p-1)L-1≥L，所以绝不稀疏。完美数不是素数，故目标等价没有奇完美数，不是2026新近小猜想。A000396也明确奇完美数不存在是相信而非已证；未将欧几里得–欧拉偶数分类误用于全部完美数。open仅限此次核查。 Mathlib：Nat.Perfect、Nat.perfect_iff_sum_properDivisors、Nat.perfect_iff_sum_divisors_eq_two_mul，Mathlib/NumberTheory/Divisors.lean:395–403；仅提供完美数定义与σ(N)=2N，不解决奇完美数不存在。文本检索无sparse-perfect目标。 数值方案：约30行因子和筛对N≤10^6独立找Σproper=N，再按最小素因子确定L，试除求Σ_{1<d<L,d∣N}d并比较；可验6,28,496,8128。这只检查已知偶完美数，small N计算不推进未知奇完美数前沿。 全部直接 A 引用：A000396、A392440、A392493、A392494、A392499、A392500。

**A397155 — precise；note-only。** 文献/卡点：A398353 是更广的素数加半素数问题，未给立方子族的证明；这是受限制的加法素数表示目标，尚无明确初等逃逸内容，不自动派实施。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：对 n=2..100 筛至 n³，遍历素数 r<n³，试分解 n³−r 是否恰为两个素数的积（允许 p=q）。 全部直接 A 引用：A000040、A001358、A398353。

**A397258 — precise；note-only。** 文献/卡点：源 comment 明说“if B lists all and only primes”时等价；A067836 的开放前提没有解除。和 A397259 合并一个研究案，不能把索引换名作为逃逸。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：按 B 递推并维护未见最小素数，计算迟现位置；与有限后缀极小比较，只能作有限诊断。 全部直接 A 引用：A067836、A397259。

**A397259 — precise；note-only。** 文献/卡点：A067836 的 B 序列“所有素数最终出现”仍是核心前提；A397258 只是相同迟现事件的位置编码。这里要区分可计算的首次出现与依赖全部未来的右向左极小，不能把两个定义强行等同后宣称新定理。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：按 A067836 递推计算 B 的有限前缀，用 seen 集合求迟现素数及位置，并求截断后缀最小；截断后缀不能认证无限未来极小。 全部直接 A 引用：A067836、A397258。

**A397260 — precise；note-only。** 文献/卡点：S(n)=Σ_{d∣n} digitProduct(d)。例如目标 ∀k≥0 ∀1≤m<8·10^k−2, S(m)<S(8·10^k−2)；其他四族量词范围按源分别 k≥0、k≥1、k>4。A397261 的大项解释只给候选值的贡献下界，未给所有更小竞争数的上界；没有明确全局逃逸。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：用约30行除数筛累加 digitProduct(d) 到所有倍数，算 n≤10^6 的 S 与前缀严格最大值，再测试各数族落入的记录。 全部直接 A 引用：A007954、A093811、A397257、A397261。

**A397341 — precise；note-only。** 文献/卡点：源给 Bateman–Horn/Schinzel 启发式，MSE 回答5141377也明确是 heuristically，均无证明。源页称“对所有 F≥1 都存在可拼接素数”等价，但该句比仅对递推可达前缀 F 的存在性更强，不能无证明互换。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：逐步按素数从小到大试拼接 F·10^digits(p)+p；小前缀作确定性素性检查并设工作上限，达到上限只报未找到，不能报不存在。 全部直接 A 引用：A000945、A051670、A158191、A167604、A379354、A380010、A397342。

**A397369 — precise；note-only。** 文献/卡点：精确目标 a(mp^r)≡a(mp^(r−1)) mod p^(4r)，a_n=64^n[z^n]₂F₁(1/4,1/4;1;z)^3，m,r≥1。已打开 arXiv:2605.19773、2604.06238、2606.15462 的主定理，证明的参数分别为 (1/6,1/3) 或 (1/3,1/3)，不是本条 (1/4,1/4)。2110.06768 的一般 eta 算子工具也未给本目标。A393983/A395287 的 level3 证明不转移；属于深层模形式路线。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：以 Fraction 算超几何系数再三重卷积并乘64^n，或用源整数递推；对 p=5,13、m=1..3、r=1..2 且指标≤200 算模幂，交叉核对前缀。 全部直接 A 引用：A393983、A395287。

**A397699 — precise；note-only。** 文献/卡点：A356840/A397698 给精确算法；已读 Wechsler 的 SeqFan 回答（2026-07-04/05），原文明确说“certainly only a heuristic argument”。故不是 published。他从素数幂删一位再插回的想法未保证不存在更高指数竞争者，尚无全称覆盖证明。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：对每个 n 枚举所有不带前导零的一位插入结果 m，分解各 m；先最大化指数 k，再最大化素数 p，仍同分取最小 m，输出 p。枚举 n≤10000 并记录已出现素数；绝不能按 p^k 的数值大小排序。 定位：https://groups.google.com/g/seqfan/c/1z8o_QY0_AA/m/RRc5YZGiAwAJ。 全部直接 A 引用：A356840、A397698。

**A397705 — precise；note-only。** 文献/卡点：A046927/A194828 等 Lemoine 相关条目未给带 p<q 限制的全称证明。源页“若 Lemoine 猜想为真则列表完整”没有提供从任意表示到受限表示的推理，不能作 published。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：筛至 B=10^6，对每个奇数 m 枚举 m/3<q≤(m−2)/2 的素数，检查 m−2q 素性并收集例外；可改卷积加速。 全部直接 A 引用：A002091、A002092、A046927、A185091、A194828、A194829、A195353、A195354。

**A397789 — precise；note-only。** 文献/卡点：与 A397790 是同一目标，合并留一个研究任务。相邻素数 u<v 的反例等价于 4q³>(u+v)² 且 2q³<u²+v²。A397790 中的高斯整数论证只排除距离相等，不证明两种最近选择一致；A002821/A077118 的整数邻点公式也不覆盖素数邻点。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：筛 q 及 q^(3/2) 两侧相邻素数，全部以整数比较 4q³、(u+v)²、2q³、u²+v²；n≤1000 无须浮点。 全部直接 A 引用：A000040、A001248、A002821、A030078、A077118、A397790。

**A397790 — precise；note-only。** 文献/卡点：与 A397789 是同一目标，合并留一个研究任务。相邻素数 u<v 的反例等价于 4q³>(u+v)² 且 2q³<u²+v²。A397790 中的高斯整数论证只排除距离相等，不证明两种最近选择一致；A002821/A077118 的整数邻点公式也不覆盖素数邻点。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：筛 q 及 q^(3/2) 两侧相邻素数，全部以整数比较 4q³、(u+v)²、2q³、u²+v²；n≤1000 无须浮点。 全部直接 A 引用：A000040、A001248、A002821、A030078、A077118、A397789。

**A399051 — precise；note-only。** 文献/卡点：取 n≥3、N=∏_{j=2}^n p_j，目标 ∃偶数 c，0<c<p_n² 且 Prime(N−c)。A399052 仍称 conjecture；A005235 的 Fortune 类讨论不构成该单侧短区间的证明。未找到可供短实施的素数间隙逃逸引理。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：逐 n 建大整数 N，枚举偶数 c<p_n² 并作确定性试除/素性证书；先做 n≤10，避免把概率素性当精确结果。 全部直接 A 引用：A002110、A005235、A006794、A070826、A399020、A399052。

**A393833 — precise；note-only。** 文献/卡点：主条目、A000005和A032741全部所需字段未见目标证明；open仅限此检索范围。现有Mathlib已证明存在p≡1 mod n；配合素数幂因子公式给出完整本地推导：k的因子正是p^0..p^(2n+1)，共2n+2个；真因子余数全同，故回文。此为当前推导，不冒称目标已有发表证明；因直接绑定足够，排除新靶。主条目example末句a(9)=19^4*37^3与data的19026866不一致，不依赖该句。 Mathlib：Nat.exists_prime_gt_modEq_one，Mathlib/NumberTheory/PrimesCongruentOne.lean:28（∃p,Prime p∧B<p∧p≡1[MOD n]）；Nat.divisors_prime_pow、Nat.properDivisors_prime_pow，Mathlib/NumberTheory/Divisors.lean:420,506（分别为range(e+1)、range e上的幂映射）。已读声明和证明。 数值方案：30行Python对n=1..50搜索p=1+tn的首个素数（n=1取2），令k=p^(2n+1)，独立试除验证p素性，生成幂0..2n+1并检查约数数目及去末项余数串回文。最小项另用除数筛扫描k≤10^6核对可达条目；超界不声称已求最小。 全部直接 A 引用：A000005、A032741。

**A394054 — precise；note-only。** 文献/卡点：已完整阅读主条目和全部13个一跳引用。实际打开Höft《Theorems Relating to Conjectures by Omar E. Pol》(2026-03-21)4页全文：p.4 Theorem 4及Corollary 1(a)明确证明SRS(n)部分数等于2-稠密块数，依据p.2 Lemma 1(e)与p.3中心块唯一性；同时打开其依赖A384149的7页全文，Theorems 2–3及p.6 Theorem 4给非中心/中心部分与因子块的对应及面积公式。把点态等式代入m≤n的计数就是目标。另打开AlphaProof Nexus target_theorem_0；它预先用奇因子断口表述定义a，故单独不能证明到原始几何定义的忠实性。这里published指公开证明手稿，未声称同行评审。 Mathlib：none（检索NumberTheory的dense/divisor、symmetric representation、SRS未见目标；最终筛集基数相等仅需逐点等式改写，但SRS几何编码与块双射没有查到Mathlib声明）。 数值方案：约40行Python对m=1..2000试除取得升序因子，计1+相邻y>2x的断口数；另对i=1..r，r=floor((sqrt(8m+1)-1)/2)，算b_i=[m≥i(i+1)/2且i整除m-i(i+1)/2]、c_i=Σ_{h≤i}(-1)^(h+1)b_h，计c_i>0的连续段数R，以2R-[c_r>0]得到几何部分数。逐点比较后累计各k的直方图，不能用断口公式同时算两侧。 定位：https://oeis.org/A237270/a237270_4.pdf#page=4；https://oeis.org/A384149/a384149.pdf#page=4；https://raw.githubusercontent.com/google-deepmind/alphaproof-nexus-results/main/APNOutputs/OEIS/oeis_a237271_conjecture_2.lean。 全部直接 A 引用：A000027、A174973、A237270、A237271、A237593、A239663、A240062、A379288、A384149、A384222、A392987、A394052、A394053。

**A394791 — precise；note-only。** 文献/卡点：Höft 2026-03-21 Theorem4 及其证明给“部分数=最大2-稠密因子块数”；Theorem1(c,d)给中心相接时中央因子 d₂=2d₁+1 并识别 A298856。A298856 的 comment 已有中心相接的双向几何论证；d₂=2d₁+1 时 n=d₁(2d₁+1)、中央间隙无因子，对应该第二六角数判据。逐点条件一致后，第 n 个/最小值只是取同一有序集合；并非发现了新的枚举定理。所读2025-06-27 A384149 论文 Theorems2–4给稠密块与几何面积桥。这里不把 Höft 对 A191363 的单向推理外推成所有亏2数分类。 Mathlib：none：几何编码/稠密块桥未在钉版 Mathlib 找到；一旦输入该公开桥，第 n 个相等仅为集合改写，故中风险。 数值方案：试除取得因子排序、在 next>2·previous 处断块并检查两中央因子；另一侧用 A237593 两条 Dyck 路径的网格边界计部分、检测中央相接，扫描小整数直到所需列/最小项，不能两边都用断块公式。 定位：https://oeis.org/A237270/a237270_4.pdf；https://oeis.org/A384149/a384149.pdf；https://oeis.org/A298856。 全部直接 A 引用：A000203、A014105、A033676、A033677、A071561、A174973、A191363、A207375、A237270、A237271、A237593、A239929、A240062、A245092、A262259、A262626、A264104、A280107、A298856、A320511、A384222、A392197、A395156。

**A395156 — precise；note-only。** 文献/卡点：Höft 2026-03-21 Theorem4 及其证明给“部分数=最大2-稠密因子块数”；Theorem1(c,d)给中心相接时中央因子 d₂=2d₁+1 并识别 A298856。A298856 的 comment 已有中心相接的双向几何论证；d₂=2d₁+1 时 n=d₁(2d₁+1)、中央间隙无因子，对应该第二六角数判据。逐点条件一致后，第 n 个/最小值只是取同一有序集合；并非发现了新的枚举定理。所读2025-06-27 A384149 论文 Theorems2–4给稠密块与几何面积桥。这里不把 Höft 对 A191363 的单向推理外推成所有亏2数分类。 Mathlib：none：几何编码/稠密块桥未在钉版 Mathlib 找到；一旦输入该公开桥，第 n 个相等仅为集合改写，故中风险。 数值方案：试除取得因子排序、在 next>2·previous 处断块并检查两中央因子；另一侧用 A237593 两条 Dyck 路径的网格边界计部分、检测中央相接，扫描小整数直到所需列/最小项，不能两边都用断块公式。 定位：https://oeis.org/A237270/a237270_4.pdf；https://oeis.org/A384149/a384149.pdf；https://oeis.org/A298856。 全部直接 A 引用：A000203、A014105、A033676、A033677、A071561、A191363、A207375、A237270、A237271、A237593、A240062、A262259、A262626、A264104、A280107、A298856、A320511、A384222、A392197、A394791。

**A395171 — precise；note-only。** 文献/卡点：该猜想已被公开反驳：MathOverflow 回答511088（2026-06-14）以 p=3,m=2283 给不同 k 的 gcd；不能作为新反驳靶。Love 的回答511242另证合格 m 的存在，不证明 gcd 恒定。本席补查 p=5：m=2..8 在 k=1 时均 gcd=1，m=9 在 k=1 为121、k=1499为362879；121∣9^5−1 保证9对所有 k 合格，故确实对应最小项。published 在本行专指已有反驳与存在证明，不称原猜想被正面证明。 Mathlib：none；Nat.gcd_dvd_left、Nat.gcd_dvd_right 只供整除接口，不能独自决定本序列最小项。 数值方案：已实际用 Python factorial、gcd、pow(base,exponent,modulus) 复算上述 p=5 反例与最小性排除；不需构造9^7495的大整数。 定位：https://mathoverflow.net/a/511088；https://mathoverflow.net/a/511242。 全部直接 A 引用：A000978、A005384、A393224、A395115、A395286、A395944。

**A399155 — precise；note-only。** 文献/卡点：A175126 的已知公式 f(n)=(n−lpf(n))/2+1 与 A309892 的已知界 g(n)≤n/gpf(n) 已给出支配事实：写 n=l·r，l=lpf(n)，则 g≤n/gpf(n)≤r≤l(r−1)/2+1=f（n≥2）。published 指这两个公开公式及其直接代数推论，未找到单独发表比较定理的论文；条目另问纤维有限，不据此声称已解。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：试除取得最小/最大素因子，各自从 n 迭代到 0，计步，检查 n=2..10000；约30行。 全部直接 A 引用：A175126、A309892。

**A390878 — vague；drop。** 文献/卡点：主源及18个一跳引用所需字段已完整读，包括很长的A000041。A176206指定整数k出现p(n−k)次；但目标句未说明重复部分/因子组如何计数。实际打开Höft 2026 p.4 Theorem 4，证明SRS部分数=因子块数；这只解决点态权重。按上述澄清版本可直接有限双计数推导，不能据此声称含糊原句已有发表证明。范围上属于语义未固定或既有结论加权，无适当新目标。 Mathlib：Nat.Partition.partitionWithPartEquiv，Mathlib/Combinatorics/Enumerative/Partition/Basic.lean:236，删除一个指定部分的等价；已读声明及实现。没有SRS/因子块目标；若按A176206的p(n−k)多重性定义右端，则剩余为已知点态等式的加权。 数值方案：先明确右端多重性。可用递归枚举n≤15的整数分拆并记录每个不同部分k出现的分拆数，核查为p(n−k)；再独立枚举k因子块并求和，与分拆DP算p及几何SRS算出的卷积比较。若按所有部分出现次数计数则应是Σⱼp(n−jk)，这能检出语义差异。 定位：https://oeis.org/A237270/a237270_4.pdf#page=4。 全部直接 A 引用：A000041、A174973、A176206、A196020、A221529、A235791、A236104、A237270、A237271、A237591、A237593、A245092、A262626、A336811、A384222、A384931、A390877、A390880。

**A396081 — precise；drop。** 文献/卡点：源 conjecture 明确要求无限多素数；A381466 的已知递推界/局部整除性质不推出无限出现。按用户无穷性断言排除；不把递推易写当可派实施。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：从 b(0)=4 起，g=gcd(b(k−1),k)，g=1 则加 k，否则置 k/g；筛 p≤B 并检查 b(2p)=p，十几行可验前缀但不证无限性。 全部直接 A 引用：A381466、A394761。

**A396696 — precise；drop。** 文献/卡点：这是无界实分析及素数间隙存在断言。A051254 的 Mills 定理、A051501 的 Wright 构造及 A082282 使用其他增长尺度，不能替代本猜想；所检索条目未给本尺度的证明。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：以 nextprime 迭代有限前缀 a_n，精确检查 a_n<n²(a_(n−1)+1)，给有限区间交而非实数 C 的全称证书。 全部直接 A 引用：A051254、A051501、A082282。

**A396847 — precise；drop。** 文献/卡点：A119471 的相关实数/级数关系仍为猜想；所查条目未给边界收敛及等式证明。收敛半径与边界取值是本席排除的无界解析断言。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：可截断级数并用有理区间迭代估计根，但没有尾项误差证书就不能检验边界取值，故 no。 全部直接 A 引用：A119471。

**A398129 — vague；drop。** 文献/卡点：列表成员由猜想性的“唯一无限分支”决定；有限前缀不能无条件确定该序列。A398130 是同一树的另一同余类，A078611/A129758 的对称素数定义没有证明无限分支唯一。可以另写精确树谓词，但此无界分支目标不进入本席。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：筛到明确上限，对每个中点找最近对称素数对并建有限树，记录截断处活分支；这不能验证真正的分支成员资格，故 no。 全部直接 A 引用：A002476、A007528、A078611、A129758、A398130。

**A398130 — vague；drop。** 文献/卡点：列表成员由猜想性的“唯一无限分支”决定；有限前缀不能无条件确定该序列。A398129 是同一树的另一同余类，A078611/A129758 的对称素数定义没有证明无限分支唯一。可以另写精确树谓词，但此无界分支目标不进入本席。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：筛到明确上限，对每个中点找最近对称素数对并建有限树，记录截断处活分支；这不能验证真正的分支成员资格，故 no。 全部直接 A 引用：A002476、A007528、A078611、A129758、A398129。

**A398812 — precise；drop。** 文献/卡点：源 formula 已附 Chai Wah Wu（2026-08-20）的完整夹逼：覆盖面积 A138808(n)≤n·τ(n)，τ(n)≤2√n，故比例亏损≤2/√n→0；本身也属于本席排除的渐近断言。A398810 当前是 allocated 占位条目，无数学字段。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：对 n≤100 枚举整数格 (x,y)，覆盖当且仅当存在 d∣n 满足 x≤d 且 y≤n/d，计未覆盖面积；数值 yes 仅指前缀。 全部直接 A 引用：A138808、A283626、A398809、A398810、A398812。

## 未主张

未主张检索穷尽、open 等于全球无人证明、所有外链论文已全文审读、或 published 等于原猜想为真。未跑 Lean、未编译伪签名、未核验公理闭包、未建模块/原子/冻结记录。未证明任何 dispatch 目标，也未保证其符合最终逃逸准入；具体声明检索不等于真实 bind-only 探针。

除逐段明确写“已实际核验”及 A395171 的模幂反例检查外，数值栏均是**可执行的验证方案**，未声称已运行。文献中的表值和程序输出不冒充本席独立数值证据。A395171 的本席计算：p=5、m=9，k=1 时 gcd=121，k=1499 时 gcd=362879；m=2..8 在 k=1 时均为1。该结果只补充已公开的反驳，未主张新发现或形式化反驳。

未对第三档目标作自主研究承诺；未把有限前缀通过、概率素性、相邻已知公式、外部 Lean 文本或单向蕴含冒充所需的无界精确定理。
