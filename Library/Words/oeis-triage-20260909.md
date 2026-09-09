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

本检查点已分诊 **57/93** 条：dispatch 7，note-only 36，drop 14；文献 open 36，published 8，unknown 13。 尚未列出的条目仍在查证，不能视为已淘汰。

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
| [A397346](https://oeis.org/A397346) | 猜想从 n=2 起 a(n) 模8按 4、2、0、2 周期重复。 | 1 | open | low | yes | dispatch |
| [A397348](https://oeis.org/A397348) | 猜想该隐式普通生成函数的整数系数 a(n) 为奇数，当且仅当 n+1 是 2 的非负整数次幂。 | 1 | open | low | yes | dispatch |
| [A397242](https://oeis.org/A397242) | 猜想该 q=1 隐式普通生成函数系数 a(n) 为奇数当且仅当 n+1是2的幂；另有正指标模3的三进制分类猜想。 | 1 | open | low | yes | dispatch |
| [A388986](https://oeis.org/A388986) | 每个Euler形奇数N=p^(4a+1)r²（p≡1 mod4为素数，奇数r>1且gcd(p,r)=1）都满足unitarySigma(N)+sigma(rad(N))<2N。 | 1 | open | low | yes | dispatch |
| [A396804](https://oeis.org/A396804) | 对满足 A(x)=x exp(A∘A∘A∘A(x)) 的唯一形式幂级数 A=Σa(n)x^n/n!，猜想 a(n)≡n (mod 4)，n≥1。 | 1 | open | low | yes | dispatch |
| [A392714](https://oeis.org/A392714) | 合格 Wronskian 贡献排列的偶排列数与奇排列数之差为 (−1)^(n+1)。 | 1 | open | low | yes | dispatch |
| [A397711](https://oeis.org/A397711) | 入度至多2的 n 点有标号 DAG 数，奇 n 模 n 为1，偶 n 模 n 为 n/2+1。 | 1 | open | med | yes | dispatch |
| [A382590](https://oeis.org/A382590) | 固定初值 a₀=b₀=b₁=1、a₁=2 的耦合递推中，∣aₙ∣ 的第 k 个不同质因数（不足时记1）对每个 k>1 最终周期。 | 1 | published | low | yes | note-only |
| [A392197](https://oeis.org/A392197) | SRS(m)所有部分宽为1且中央两部分相遇，当且仅当奇因子数等于2-稠密因子块数且中央相邻因子满足d₊=2d₋+1。 | 1 | unknown | med | yes | note-only |
| [A397245](https://oeis.org/A397245) | 猜想 a(n) 模3为1当且仅当 n+2=3^r 或2·3^r，为2当且仅当 n+2是两个不同3次幂之和。 | 1 | open | med | yes | note-only |
| [A352656](https://oeis.org/A352656) | 令 a(n) 为 n×n×2n 盒内平面分拆数，猜想所有素数 p 及 n,r≥1 满足 a(np^r)≡a(np^(r−1))^p (mod p^(4r))。 | 3 | unknown | low | yes | note-only |
| [A387421](https://oeis.org/A387421) | 对每个正整数n，σ(n)不等于其powerful部分的两倍。 | 3 | open | low | yes | note-only |
| [A388012](https://oeis.org/A388012) | 不存在正整数n满足3σ(n)=5n；原文另一个密度猜测属于范围外。 | 3 | unknown | low | yes | note-only |
| [A388268](https://oeis.org/A388268) | 若n>1且τ(n)≥σ(n)/gcd(n,σ(n))，则σ(n)≥2n。 | 3 | unknown | low | yes | note-only |
| [A389105](https://oeis.org/A389105) | gcd 驱动递推的每个正整数除数都有首次出现，且首次位置超过(6/5)^(n−1)。 | 3 | open | low | no | note-only |
| [A392498](https://oeis.org/A392498) | 所有完美数N都满足其介于1与最大真因子L=N/minFac(N)之间的因子之和严格小于L。 | 3 | open | low | yes | note-only |
| [A392667](https://oeis.org/A392667) | 猜想区分τ(k)(τ(k)−1)、1≤k≤n的最小正模数对所有n存在，且非素值恰在n=1和37。 | 3 | unknown | low | yes | note-only |
| [A392732](https://oeis.org/A392732) | 令D(n)为区分2^(k(k−1)/2)、1≤k≤n的最小正模数，猜想非素值恰在n=1与n=3。 | 3 | open | low | yes | note-only |
| [A392775](https://oeis.org/A392775) | 令m(n)为区分2·3^(k(k−1)/2)、1≤k≤n的最小正模数，猜想n>1时m(n)总是素数。 | 3 | open | low | yes | note-only |
| [A393928](https://oeis.org/A393928) | 猜想每个素数p都有一段p−1个连续素数，其模p余数恰为全部非零余数。 | 3 | unknown | low | yes | note-only |
| [A394410](https://oeis.org/A394410) | Ordowski猜想：若二次递推 a(1)=1、a(2)=3、2a(n+2)=a(n+1)²+a(n)²的某项p为素数，则(p^p+1)/(p+1)也为素数。 | 3 | unknown | low | yes | note-only |
| [A394432](https://oeis.org/A394432) | 令r_e为使2^e模r乘法阶至少e²的最小正模数，猜想对e>1该阶实际严格大于e²。 | 3 | open | low | yes | note-only |
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
| [A381005](https://oeis.org/A381005) | 猜想 n≥1 时显式三角形 (2^(4n)−2^(4n−2)−2^(2n)−1, 2^(4n)+2^(2n+1), 2^(4n)+2^(4n−2)+2^(2n)+1) 均为本原勾股三角形。 | out | published | high | yes | note-only |
| [A381006](https://oeis.org/A381006) | 猜想 n≥1 时显式三角形 (2^(4n)−2^(4n−2)−2^(2n)−1, 2^(4n)+2^(2n+1), 2^(4n)+2^(4n−2)+2^(2n)+1) 均为本原勾股三角形。 | out | published | high | yes | note-only |
| [A381007](https://oeis.org/A381007) | 猜想 n≥1 时显式三角形 (2^(4n)−2^(4n−2)−2^(2n)−1, 2^(4n)+2^(2n+1), 2^(4n)+2^(4n−2)+2^(2n)+1) 均为本原勾股三角形。 | out | published | high | yes | note-only |
| [A390228](https://oeis.org/A390228) | 条目猜想其最小可区分模数在n>4时总为素数，但名称区分j系数c(k)，程序和数据区分c(k)(c(k)−1)，对象冲突。 | out | unknown | low | yes | note-only |
| [A393833](https://oeis.org/A393833) | 对每个n≥1，存在恰有2n+2个正因子的k，其按升序排列的全部真因子模n后为回文。 | out | open | high | yes | note-only |
| [A394054](https://oeis.org/A394054) | 对每个n≥1、k≥1，n以内恰有k个最大连续2-稠密因子块的整数个数，等于其σ的对称表示恰有k个连通部分的整数个数。 | out | published | med | yes | note-only |
| [A394791](https://oeis.org/A394791) | 中心两部相接且有2n个 SRS 部分的最小整数，等于相同条件的2n稠密块最小整数。 | out | unknown | med | yes | note-only |
| [A395156](https://oeis.org/A395156) | 中心两部相接且有2k个 SRS 部分的第 n 个整数，等于满足中央因子关系的2k稠密块整数。 | out | unknown | med | yes | note-only |
| [A395171](https://oeis.org/A395171) | 最小合格 m 的 gcd(m^(p·k)−1,m!−1) 被猜想与正整数 k 无关。 | out | published | low | yes | note-only |
| [A399155](https://oeis.org/A399155) | 反复减最小素因子的步数不少于反复减最大素因子的步数。 | out | published | low | yes | note-only |
| [A389650](https://oeis.org/A389650) | 猜想对任意 c>C=limsup a(n)/p_n，充分大n时以s=c·p_n代入Golomb–Keller公式会正确取整得到下一素数。 | out | open | med | yes | drop |
| [A390878](https://oeis.org/A390878) | 卷积Σₖ₌₁ⁿp(n−k)·SRS部分数(k)是否等于原文所指以各整数因子组成分拆的2-稠密因子块总数。 | out | unknown | high | yes | drop |
| [A392059](https://oeis.org/A392059) | 原文猜想由高斯整数中分歧或惰性素数幂组成的乘积是移位二项式模1+i的最小正虚向周期，但通常解释下n=1已不成立。 | out | open | low | yes | drop |
| [A394059](https://oeis.org/A394059) | 猜想素数模6的余数序列中，每个正长度都有无穷多个连续回文块。 | out | unknown | low | yes | drop |
| [A395520](https://oeis.org/A395520) | 猜想按首次出现记录的 even-sopfr 间隙中的素数值最终按素数大小顺序出现，仅有有限次逆序。 | out | unknown | low | yes | drop |
| [A396081](https://oeis.org/A396081) | 满足 A381466(2p)=p 的素数 p 有无穷多个。 | out | open | low | yes | drop |
| [A396696](https://oeis.org/A396696) | 存在实数 C，使所有 floor(C·(n!)²) 都是素数。 | out | open | low | yes | drop |
| [A396785](https://oeis.org/A396785) | 猜想有无穷多个素数 p 从未作为 gcd 加除递推 A381466 的除法步输出。 | out | open | low | yes | drop |
| [A396847](https://oeis.org/A396847) | 嵌套素数幂级数的收敛半径 r 满足 A(r)=1。 | out | open | low | no | drop |
| [A396915](https://oeis.org/A396915) | 猜想复合无平方因子整数 k 中满足算术导数 D(k)+2k 为平方者有无穷多个；同页还猜测其计数约为√X/4。 | out | open | low | yes | drop |
| [A398129](https://oeis.org/A398129) | 最近对称素数对树在 6k+1 类中有唯一无限分支。 | out | open | low | no | drop |
| [A398130](https://oeis.org/A398130) | 最近对称素数对树在 6k−1 类中有唯一无限分支。 | out | open | low | no | drop |
| [A398367](https://oeis.org/A398367) | 踩踏转盘过程的相邻1阶段长度比猜想趋于1+x，其中 x>0满足指定级数方程，且大于1阶段的均值趋于1/x²。 | out | open | low | yes | drop |
| [A398812](https://oeis.org/A398812) | 除数矩形在 n×n 正方形中未覆盖面积 a(n) 满足 a(n)/n²→1。 | out | published | low | yes | drop |

## 逐条依据与实施边界

**A397346 — precise；dispatch。** 精确目标：定义整数 b_q(1)=1，n≥2 时 b_q(n)=q(n−1)b_q(n−1)+∑_{j=2}^{n−1}(qj²−1)(n−j)b_q(j)b_q(n−j)，定义 a_q(0)=1、a_q(n)=n b_q(n)（n>0）；由主条目递推令 b_q(n)=a_q(n)/n 可得，须补证与原形式幂级数定义的唯一性对应。 Lean 伪签名：theorem residues_q2 (n : ℕ) (hn : 2≤n) : a_q 2 n % 8 = (![4,2,0,2] : Fin 4 → ℤ) ⟨(n−2)%4, by arithmetic⟩。 逃逸：拟证更强的商序列不变量：n≥2 时 b_2(n)≡6(mod8) 若 n≡3(mod4)，否则 b_2(n)≡2(mod8)。将卷积内两端 j=n−1 单列，内部两项都偶而积含4，再按指标奇偶配对计算模8；乘回 n 得原目标。该不变量已在2..120核查，归纳证明待实施。 文献/卡点：主条目和四个一跳引用的要求字段均已读；A397347 的模4陈述也仍是猜想，不能用作既知前提。未见目标证明，故仅按已查范围 open。公式(6)的 n*A397347(n)/(n²−1) 应对照 A397347(3)改为2n*A397347(n)/(2n²−1)，不照抄。渐近常数猜想 out。 Mathlib：PowerSeries.coeff_exp：coeff n (exp A)=algebraMap ℚ A (1/n!)；.lake/packages/mathlib/Mathlib/RingTheory/PowerSeries/Exp.lean:55。已读声明；只给指数级数基本系数，未命中本猜想。检索 odd/catalan/coeff_exp/valuation factorial，不把无命中说成全库无定理。 数值方案：约30行 Python 计算 b_2(n)、a_2(n)=n*b_2(n)，核对 data 后检查 a(n)%8=[4,2,0,2][(n−2)%4]。已实际算 n=0..120，n=2..120 无反例；并发现 b_2(n) 模8 在 n≥2 时为 n≡3(mod4) 取6、其余取2。 全部直接 A 引用：A397242、A397245、A397347、A397348。

**A397348 — precise；dispatch。** 精确目标：定义整数 b_q(1)=1，n≥2 时 b_q(n)=q(n−1)b_q(n−1)+∑_{j=2}^{n−1}(qj²−1)(n−j)b_q(j)b_q(n−j)，定义 a_q(0)=1、a_q(n)=n b_q(n)（n>0）；由主条目递推令 b_q(n)=a_q(n)/n 可得，须补证与原形式幂级数定义的唯一性对应。 Lean 伪签名：theorem parity_q3 (n : ℕ) : Odd (a_q 3 n) ↔ ∃ r : ℕ, n+1=2^r。 逃逸：拟证从整数递推导出的模2折半律：对 m>0，a_3(2m)≡0；对 m≥0，a_3(2m+1)≡a_3(m) (mod2)。关键是配对卷积并消去交叉项，不是套用 Catalan 奇偶定理；该折半律是拟议、尚未证明的活路径中间命题。 文献/卡点：2026-06 Hanna 主条目及五个一跳引用均已读要求字段；相关条目仍把奇偶性标 Conjecture，未提供目标证明或论文。数值由去除分母后的整数递推独立重算。公式(6) n*A397349(n)/(n²−1) 与 A397349 的公式(3)冲突：正确换算应是 3n*A397349(n)/(3n²−1)，例如 n=2 原式不产6；本分诊不采用该错误式。有关 a(n)/(3^n n!²) 的极限直接 out。 Mathlib：PowerSeries.coeff_exp：coeff n (exp A)=algebraMap ℚ A (1/n!)；.lake/packages/mathlib/Mathlib/RingTheory/PowerSeries/Exp.lean:55。已读声明；只给指数级数基本系数，未命中本猜想。检索 odd/catalan/coeff_exp/valuation factorial，不把无命中说成全库无定理。 数值方案：约30行 Python 按上述 b_3 整数递推计算 a_3，逐项与主条目 data 核对，检验 a(n)%2 == ((n+1)&n==0)。已实际核验 n=0..120 无反例；可扩大至1000，不能据此证全称。 全部直接 A 引用：A397242、A397245、A397345、A397347、A397349。

**A397242 — precise；dispatch。** 精确目标：设 b : ℕ→ℤ，b(0)=0，b(1)=1，n≥2时 b(n)=(n−1)b(n−1)+∑j∈Icc 2 (n−1),(j²−1)(n−j)b(j)b(n−j)，a(0)=1，a(n)=n*b(n)；theorem q1_parity (n : ℕ) : Odd (a n) ↔ ∃ r : ℕ, n+1=2^r。另记 n>0 时 (a n%3=1 ↔ ∃r,n+2=3^r∨n+2=2*3^r) ∧ (a n%3=2 ↔ ∃r<s,n+2=3^r+3^s)。 逃逸：与A397348共用一个候选结构引理：奇数q的整数卷积序列在F₂中满足 A=1+x*A²；先从原递推导出此式，再读系数得折半律。其证明非指数定义或Catalan定理的绑定；建议合并同族探针，不把q=1、q=3重复作两个独立成果。 文献/卡点：主条目全部字段以及A038464、A397241、A397243要求字段已读；A397241仍把奇偶及模3规律列为猜想，A397243只给对数导数关系，未见奇偶目标证明。模3是同页另一个候选，不作为本次小靶的已证前提。Kotesovec给极限常数数值而未给目标证明；一切极限子问题out。 Mathlib：PowerSeries.coeff_exp，.lake/packages/mathlib/Mathlib/RingTheory/PowerSeries/Exp.lean:55，已读，仅指数级数基础；本地 odd/catalan/coeff_exp 检索未命中该递推的奇偶判别。 数值方案：约30行：b(1)=1；b(n)=(n−1)b(n−1)+sum((j²−1)(n−j)b(j)b(n−j),j=2..n−1)；a(0)=1，a(n)=n*b(n)。取n≤120，整数运算后查 a(n)%2 与 (n+1)&n 是否为0；模3部分对n>0用n+2三进制数位判别。方案可执行，本条未另运行。 全部直接 A 引用：A038464、A397241、A397243。

**A388986 — precise；dispatch。** 精确目标：def U (N:ℕ) := ∑ d∈N.divisors.filter (fun d => Nat.Coprime d (N/d)), d; def S (N:ℕ) := ∑ d∈N.divisors.filter Squarefree, d; theorem euler_form_lt (p a r:ℕ) (hp:p.Prime) (hp4:p%4=1) (hr:Odd r) (hr1:1<r) (hpr:p.Coprime r) : U (p^(4*a+1)*r^2)+S (p^(4*a+1)*r^2)<2*(p^(4*a+1)*r^2). 逃逸：新有限乘积引理：对由≥b>1整数构成的有限集F，Πq∈F(1+1/q²)≤b/(b−1)，用1+1/q²≤q²/(q²−1)并在[b,M]伸缩证明；再按r是否含3以及是否还有其它素因子分三类，同时界住U/N与S/N，不能把U或S定义成所需上界。 文献/卡点：已完整读主源及15个引用，未见Euler形子序列问题的目标证明；open限于这些源。本席给出可实施推导路线（非已发表证明）：p≥5。若r不含3，U/N≤(6/5)(5/4)=3/2且S/N≤(6/5)(6/25)=36/125；若r仅含3，分别≤4/3与8/15，和28/15<2；若r含3及另一素因子≥5，分别≤5/3与(6/5)(4/9)(6/25)=16/125，仍和<2。指数增大只减小归一化因子。所需界全为有限积及有理不等式，不依赖无穷解析。原文2026另一个prime-factorization subset猜想在support解释下被240反例否定，在多重集解释下18与12也否定，故不派该旁支。 Mathlib：ArithmeticFunction.sigma_apply与sigma_eq_prod_primeFactors_sum_range_factorization_pow_mul，Mathlib/NumberTheory/ArithmeticFunction/Misc.lean:149、206，已读声明；NumberTheory内unitary检索仅Pell等无关代数概念，没有此不等式或单位因子和的现成绑定。 数值方案：几十行试除分解1≤N≤10^6，识别恰一个奇指数、该素数及指数均≡1 mod4、其余指数为偶数且r>1；独立枚举因子d用gcd(d,N/d)=1求U，用squarefree(d)求S，与素因子积Π(q^e+1)、Π(q+1)交叉核查并测试U+S<2N。另实测Browne的prime-support版本首个反例为240：U=408,S=72，而210<240且rad240=30∣210并新增素数7。 全部直接 A 引用：A013929、A034448、A048108、A048250、A228058、A325963、A325973、A325977、A360765、A386427、A388985、A389079、A389215、A389217、A389219。

**A396804 — precise；dispatch。** 精确目标：令 A:PowerSeries ℚ 为 constantCoeff A=0 且 A=X*(PowerSeries.exp ℚ).subst(iterateComp A 4) 的唯一解；iterateComp A 0=X，iterateComp A (k+1)=A.subst(iterateComp A k)。令 a(n):ℕ 满足 (a(n):ℚ)=n! * coeff n A（须独立建立整数性）。theorem mod_four (n:ℕ) (hn:1≤n) : Nat.ModEq 4 (a n) n. 逃逸：拟议新中间命题：对 B=A∘A∘A∘A，所有 n≥2 的整EGF系数 n![x^n]B 都被4整除；用复合的偏Bell多项式递推同时归纳A与B的系数。随后整数Bell多项式的模4相容性给 exp(B)≡exp(x)，乘x导出目标。该中间命题需先探针确认，不能以主猜想为假设。 文献/卡点：主条目与7个直接引用的全部指定字段均读。旧模3模式[1,2,0]已明确在n=5被反驳；真打开a396804.txt的完整纠错说明和代码，它明确将六周期替代仍标 conjecture，有限核查不是证明。这里选原条目独立的模4猜想，未选已被反驳版本。引用的同族EGF条目只有递推与同类猜想，A000169的Cayley公式属于一次迭代，不能直接覆盖四次迭代。open仅表示这些源和refs未见本模4证明。 Mathlib：PowerSeries.coeff_exp（Mathlib/RingTheory/PowerSeries/Exp.lean）与 PowerSeries.coeff_subst'（Mathlib/RingTheory/PowerSeries/Substitution.lean）已读：给 exp 及复合系数公式，均不直接给EGF整数系数模4周期；Nat.modEq_iff_dvd可作终点接口。 数值方案：约50行Python Fraction截断多项式：实现卷积mul、Horner复合compose和由E′=B′E得到exp系数；从A=x反复作A←x exp(A∘A∘A∘A)，截断到x^41，每轮确定至少一个新系数；做41轮，提取n!*[x^n]A，断言为整数并对n=1..40检查模4。可同时复核原模3在n=5失败。完全独立于下载表。 全部直接 A 引用：A000169、A140054、A396799、A396800、A396803、A396805、A396806。

**A392714 — precise；dispatch。** 精确目标：用一基索引：Φ(n)={σ∈Perm({1,…,2n})：σ(1)=1 ∧ ∀1≤k<2n, Σ_{i=2n−k+1}^{2n}(σ(i)−1−n)≥0}，和在 ℤ 中计算。拟签名 `theorem parity_imbalance (n : ℕ) (hn : 1 ≤ n) : (∑ σ ∈ Φ n, signInt σ) = (-1 : ℤ)^(n+1)`。有限集合、signInt 和一基到 Fin(2*n) 的转换须在实施时定义；不是已编译签名。 逃逸：拟议逃逸是构造保持所有后缀预算非负的反号对合，并分类其唯一未配对排列。现有求和消去定理不提供这个组合构造；尚未找到/证明该对合。只派一次有停止条件的组合探针，不能把差为1本身当定义。 文献/卡点：Shah–Kiselev, arXiv:2605.11137v1 第3节定义 Φ_p，Remark 4 明确把奇偶差称 conjecture；Claim 4.1 的带权和并未证明这个无权差。A147681 是关联的 late-growing 排列计数，不能因其已出现就降为 published。 Mathlib：Finset.sum_involution（Algebra/BigOperators/Group/Finset/Basic.lean 的 to_additive 生成声明）：只负责已给定反号对合的消去，缺少本有限集上的对合及唯一余项。 数值方案：枚举固定首项为1的 {1,…,2n} 排列（n≤4），从右向左累加 σ(i)−1−n，任一负值即弃；算逆序数奇偶，比较差。应得 n=1..4 的 (偶,奇)=(1,0),(1,2),(18,17),(500,501)；此处只是验证方案与原论文表值，未实际运行。 全部直接 A 引用：A147681。

**A397711 — precise；dispatch。** 精确目标：定义 `dag2 n` 为顶点 Fin n 上无环、每点入度≤2的关系之有限集，令 a(n)=card(dag2 n)。拟签名 `∀ n : ℕ, 3 ≤ n → a n % n = (if Even n then n/2+1 else 1)`。必须从关系计数建模，不能以现成递推冒充组合定义。 逃逸：拟议逃逸是分析循环重标号下的固定 DAG：分类各素数幂长度轨道的入边限制，并计算偶数阶余项，最终组装模 n。仅有素数阶群作用模板不够。对合数部分未完成固定图分类，实施探针若只得已知素数情形即停止。 文献/卡点：源页已证明高度分层计数公式，并给素数阶循环重标号解释；那些子结论不作为新靶。未在完整直接引用条目找到所有合数 n 的同余证明。 Mathlib：IsPGroup.card_modEq_card_fixedPoints；MulAction.sum_card_fixedBy_eq_card_orbits_mul_card_group。前者只给模素数的固定点计数，后者是 Burnside 恒等式，均缺特定 DAG 的合数模数分析。 数值方案：独立枚举 n≤5 的无自环有向邻接位图，检查每点入度≤2并拓扑排序；计数取模。再用源页高度组成递推查 n≤100，仅作第二算法对照。 全部直接 A 引用：A000272、A003024、A243014、A308634、A361718。

**A382590 — precise；note-only。** 文献/卡点：完整打开 StackExchange API 返回的原问题及全部答案。原问题列 k=2,N=2 的周期(3,5,7)，明确使用不同质因数；Terry Tao 答案490348逐步模aₙ计算出aₙ₊₃≡0，Somos答案490382还给整式因子分解。该整除论证与递增集合/自然数下降链停止即给周期3。初值2非零性可由模5、7有限轨道完整检查：n≢0 mod3 时模5非零；n≡0 mod3 时模7非零（有限初段亦非零），此次已实算循环。打开的 arXiv:2608.11941 附录A A382590 把因子按重数计并证明最终恒2，属于另一口径，不能替代原MO目标。 Mathlib：Nat.mem_primeFactorsList_iff_dvd（.lake/packages/mathlib/Mathlib/Data/Nat/Factors.lean:143）：n≠0、p素时 p∈primeFactorsList n ↔ p∣n，已读声明。还检索 Dynamics/PeriodicPts/Lemmas.lean 的有限轨道声明；均不直接含三步整除和排序后稳定结论。 数值方案：约35行 Python 用四整数状态生成前25项，以试除/可靠因式分解取去重排序质因数并记录 k=2,3,4；大项增长极快，扩展时改为对有限小素数同时迭代模p状态，但必须把“未找到第k个”标为未知。已独立枚举模5、7完整状态轨道：前周期3、7，周期12、24，检查所有过渡及 aₙ 模5或7至少一者非零；可用几十个小整数作非零证书。 定位：https://mathoverflow.net/a/490348 （全文通过 https://api.stackexchange.com/2.3/questions/490330/answers?site=mathoverflow&filter=withbody 打开；三步整除计算）；https://mathoverflow.net/a/490382 （同一API全文；显式因式分解）；https://arxiv.org/html/2608.11941 （附录A A382590：按重数版本及模5/7非零论证，口径差异已注明）。 全部直接 A 引用：none。

**A392197 — precise；note-only。** 文献/卡点：已完整读主源及19个一跳引用。实际打开Höft 2026手稿：p.2 Theorem 1证中央相遇⇒d₊=2d₋+1；p.4 Corollary 3证全部宽1⇒奇因子数=块数；p.3 Corollary 1点名A392197，但不能将两个单向陈述冒充整个集合等价的双向证明。A174905有无保留的宽1等价描述，A298856有中央相遇的另一刻画及完整论证，但尚未打开足以闭合所选完整双向目标的几何证明，故unknown。有限奇核链引理看起来很小，文献桥未确认前不派。 Mathlib：none：钉版Mathlib/NumberTheory文本检索dense divisor、symmetric representation未找到SRS或2-稠密块声明；Nat.divisors只是基础设施。 数值方案：对1≤m≤2000直接枚举升序因子，在相邻比例>2处断开；分别数奇因子，取d₋=max{d∣m:d²≤m}, d₊=m/d₋。独立从Dyck边界构建SRS网格，检查各宽度及中央交点；先不要把待证因子条件用作几何端定义。 定位：https://oeis.org/A237270/a237270_4.pdf#page=2；https://oeis.org/A237270/a237270_4.pdf#page=4；https://oeis.org/A298856。 全部直接 A 引用：A001227、A014105、A033676、A033677、A071561、A162348、A174905、A191363、A237270、A237271、A237593、A250068、A262259、A262626、A264104、A280940、A298856、A384222、A384225。

**A397245 — precise；note-only。** 文献/卡点：A038464只定义不同3次幂之和；A396846仍称模3规律为猜想；A397242、A397244给系列变换而无目标证明，全部要求字段已读。OEIS无保留递推可用于生成项，不能据其出现就判 published。主条目公式(5)的换算分母 n²−1 与同页 example 的 (4n²−1)/(4n) 关系不一致，正确逆式为4n*A396846(n)/(4n²−1)；example 把 B 系列一处叫 A397241、另一处叫 A397244，暂不采用该混名桥。无界渐近部分 out。 Mathlib：PowerSeries.coeff_exp：coeff n (exp A)=algebraMap ℚ A (1/n!)；.lake/packages/mathlib/Mathlib/RingTheory/PowerSeries/Exp.lean:55。已读声明；只给指数级数基本系数，未命中本猜想。检索 odd/catalan/coeff_exp/valuation factorial，不把无命中说成全库无定理。 数值方案：用 b_4 整数递推计算0..120；把n+2转三进制：恰一个1或恰一个2时应为1，恰两个1时应为2，其他应为0。已独立核查并匹配 data，未见反例；代码用 divmod 实现三进制，不读取OEIS判定结果。 全部直接 A 引用：A038464、A396846、A397242、A397244。

**A352656 — precise；note-only。** 文献/卡点：主条目 Conjecture 3 无歧义；Conjecture 1 写 p^(4*k) 而 k 未绑定，不能静默改作 r。所有7个直接引用字段已读。真打开 Amdeberhan–Moll 2011 全文6页：定理1.1比较 TSPP 与 ASM 的2进赋值，定理2.1是 SPP=TSSCPP×TSPP；均不能映射到 n×n×2n 的全素数超同余。相关 Wolstenholme/超阶乘论文未完整打开核验，故文献状态 unknown，不凭 MacMahon 计数公式或相邻条目重复猜想拔高 published。强超同余需研究线。 Mathlib：Nat.superFactorial、Nat.prod_range_succ_factorial、Nat.superFactorial_four_mul（Mathlib/Data/Nat/Factorial/SuperFactorial.lean）；Nat.modEq_iff_dvd（Mathlib/Data/Nat/ModEq.lean）。已读声明，只有乘积重写与同余接口，无本目标超同余。 数值方案：约30行 Python：用 factorial 和 Fraction 计算 ∏_{i,j=1..m}(2m+i+j−1)/(i+j−1)，断言分母1；枚举 p∈{2,3,5,7},n=1..4,r=1..3 且 np^r≤120，以大整数模幂检查差。另以超阶乘比复核小 m≤12；普通通过只作探针。 全部直接 A 引用：A000178、A000984、A005809、A008793、A074962、A342972、A352657。

**A387421 — precise；note-only。** 文献/卡点：主源和8个一跳引用全部字段已读，未见目标证明，open仅指这些源。上述分解说明问题真正剩下powerful完美数；A386428明确说明其奇Euler形特殊素数指数≥5正是Descartes–Frénicle–Sorli猜想排除的一类。A387719仅给必要包含关系，没有证明不存在。因而本条不是普通sigma符号改写的小猜想。 Mathlib：Nat.perfect_iff_sum_divisors_eq_two_mul，Mathlib/NumberTheory/Divisors.lean:401；ArithmeticFunction.isMultiplicative_sigma及sigma素因子积公式，NumberTheory/ArithmeticFunction/Misc.lean:202、206。已读；检索powerful没有目标声明。 数值方案：最小素因子筛到10^6，分解n=Πp^e，计算B=Π_{e≥2}p^e，并独立约数筛计算σ；记录σ=2B的n。还可生成p^(4a+1)r²且a≥1的powerful Euler候选，用因子积交叉检验。小范围无解不是新有限前沿。 全部直接 A 引用：A000203、A057521、A085971、A363169、A378859、A386428、A387420、A387719。

**A388012 — precise；note-only。** 文献/卡点：已完整读主源及7个直接引用。主源及A388016明确将5/3问题接到Weiner Theorem 3；已打开Holdener 2020页面，但只有摘要，未读其全文或Weiner原文，故unknown而不冒称published。本席可解释条件链：等式给3∣n；若2∣n则6∣n使丰度≥2；奇数n的σ为奇数要求所有素指数偶；若还5∣n则225∣n且丰度≥403/225>5/3；因此5∤n，乘法性给σ(5n)=6σ(n)=10n，即奇完美数。排除此类仍是研究线。另有0.419…密度陈述按用户规则直接out，不派。 Mathlib：Nat.abundancyIndex_le_of_dvd，Mathlib/NumberTheory/FactorisationProperties.lean:204；Nat.perfect_iff_sum_divisors_eq_two_mul，NumberTheory/Divisors.lean:401；ArithmeticFunction.isMultiplicative_sigma，NumberTheory/ArithmeticFunction/Misc.lean:202，已读相应声明。均不能证明5/3不取值。 数值方案：约数筛到10^6，整数比较3*σ[n]与5*n；加强检验只枚举n=r²、r为奇数、3∣r、5∤r并用试除积求σ，可查r≤10^5。两种枚举小范围交叉验证；有限失败不排除大奇完美数。 全部直接 A 引用：A000203、A353537、A388011、A388013、A388014、A388016、A388017。

**A388268 — precise；note-only。** 文献/卡点：主源及13个一跳引用字段齐读。主源明确conjectured，A388269、A001599等把它接到Ore数/多重完美数；这些关系不提供目标证明。简单gcd≤最大真因子不能完成，因为主源也指出σ>τ·最大真因子并非总真。A009194所引Pollack的gcd论文及Ore相关全文尚未打开核验，因此保留unknown，不凭论文题目判published或作穷尽open结论。全局gcd消去缺少小目标闭合路线，按必须研究线保留。 Mathlib：Nat.abundant_iff_sum_divisors、Nat.abundancyIndex_le_of_dvd，Mathlib/NumberTheory/FactorisationProperties.lean:195、204，已读；ArithmeticFunction.sigma_apply及sigma素因子积公式在NumberTheory/ArithmeticFunction/Misc.lean。未检出控制gcd(n,σn)与τn的目标声明。 数值方案：双循环约数筛到10^6同时累加τ和σ，每n>1算g=gcd(n,σ[n])并测试τ[n]*g≥σ[n]且σ[n]<2n是否发生；找到反例再试除分解并直接列因子复核。整数交叉乘法避免有理数误差；不能把已有b表当独立枚举。 全部直接 A 引用：A000005、A000203、A000396、A001599、A005100、A005820、A007691、A009194、A017665、A023196、A032742、A388269、A388270。

**A389105 — precise；note-only。** 文献/卡点：选离散首次出现及下界目标，不选另附的“每个除数无限次出现”（该子句 out）。源报告扫描10^12步后仍未见除数20；只知55个命中到106。首次位置表有问号，不能按连续数列定义全函数后隐藏存在性。A381466 的短递推不构成全覆盖证明，需具名研究方向。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：维护 b(k) 与 gcd，并首次记录各值；可轻验前17项，但连 n=20 的正例都超已报10^12范围，故“有意义的小 n 完整验证”记 no；不能只对已找到项核对后称验证整条。 全部直接 A 引用：A381466。

**A392498 — precise；note-only。** 文献/卡点：完整阅读主条目和6个直接引用，以及真实打开Luschny的ComposableRigidSparse.ipynb全部说明性单元，未见目标证明。对完美数N，Σ_{1<d<L}d=N-1-L。若N偶，则L=N/2，和=L-1<L；若N奇，最小素因子p≥3且L≥p，N-1-L=(p-1)L-1≥L，所以绝不稀疏。完美数不是素数，故目标等价没有奇完美数，不是2026新近小猜想。A000396也明确奇完美数不存在是相信而非已证；未将欧几里得–欧拉偶数分类误用于全部完美数。open仅限此次核查。 Mathlib：Nat.Perfect、Nat.perfect_iff_sum_properDivisors、Nat.perfect_iff_sum_divisors_eq_two_mul，Mathlib/NumberTheory/Divisors.lean:395–403；仅提供完美数定义与σ(N)=2N，不解决奇完美数不存在。文本检索无sparse-perfect目标。 数值方案：约30行因子和筛对N≤10^6独立找Σproper=N，再按最小素因子确定L，试除求Σ_{1<d<L,d∣N}d并比较；可验6,28,496,8128。这只检查已知偶完美数，small N计算不推进未知奇完美数前沿。 全部直接 A 引用：A000396、A392440、A392493、A392494、A392499、A392500。

**A392667 — precise；note-only。** 文献/卡点：主全部字段与A000040、A000594、A390228指定字段全读。已读Sun2013论文的多项式discriminator定理及证明，它没有τ系数目标；A000594明确将Lehmer非消失及绝对值互异仍列为猜想。其模形式论文和专著未全文核验到本目标，记unknown，不能把τ的已知递推/Deligne界当最小模数证明。因总性已牵涉核心非消失问题，tier3。 Mathlib：none；钉版Mathlib全文检索ramanujanTau、ramanujan.*tau以及discriminator未命中目标声明，τ需从Δ的形式乘积定义并建立接口。 数值方案：约45行Python截断整多项式乘积q∏_{j=1..N}(1−q^j)^24得到τ(1..N)，每因子用binomial(24,t)(−1)^t卷积。对n≤100从m=n逐增，用整数集合查τ(k)(τ(k)−1)模m碰撞，首个成功m试除判素性；先检查整数值是否重复，若重复立即证明该n无任何可区分模数。 全部直接 A 引用：A000040、A000594、A390228。

**A392732 — precise；note-only。** 文献/卡点：主全部字段及5个直接ref全部指定字段已读。Sun2013的21页论文已打开读完；其中Theorem1.2(i)证明区分k(k−1)/2的最小模数为2^ceil(log2 n)，不是区分2^(k(k−1)/2)；第5节指数discriminator涉及原根的命题被作者明确列为猜想。故所选E(2)精确例外分类未见证明，open仅在所查源范围。原条目极限与无穷多个2幂两部分均out，未拿它们派发。 Mathlib：orderOf_pow'（Mathlib/GroupTheory/OrderOfElement.lean:415）是已读的阶幂公式；钉版discriminator、目标A号检索无最小模数素性分类。 数值方案：约30行Python对n=1..300从m=n递增，计算pow(2,k*(k-1)//2,m)并用集合查重，首个成功模数试除判素性；核查非素n集合是否为{1,3}。设候选m≤10^6，超限为未决；以逐个m完整排除证明每个算出值的最小性。 全部直接 A 引用：A000040、A000079、A000217、A208643、A392775。

**A392775 — precise；note-only。** 文献/卡点：主全部字段与5个直接ref全部指定字段已读（A000217等长条分段补齐）。Sun2013论文arXiv:1202.6589已打开并分段读完21页；定理1.1及第3节证明的是2k(k−1)及k(k−1)的discriminator，定理1.2处理三角数本身，不能把指数中的三角数当作原多项式。第5节关于指数序列的结论仍是猜想，未见本目标证明；open限这些已查源。另一个m(n)/n→4直接out，未选它。 Mathlib：orderOf_pow'（Mathlib/GroupTheory/OrderOfElement.lean:415）已读，可处理单位群中的指数碰撞；钉版discriminator及目标A号检索无对应最小模数素性定理。 数值方案：约30行Python对n=1..300从m=n递增，以{2*pow(3,k*(k-1)//2,m)%m:k=1..n}的基数判可区分，首个成功m试除至isqrt(m)判素性；不使用表值。设m≤10^6搜索上限，超限记未决。可将3换成c∈{−13,−11,−5,−3,3,5,11,13}检查n≥abs(c)。 全部直接 A 引用：A000040、A000217、A000244、A208643、A392732。

**A393928 — precise；note-only。** 文献/卡点：主条目与A000040所有要求字段已读。主引用列Dirichlet1837、Hardy–Littlewood1923、Maynard2015，但这些全文未打开并核对到目标；不凭题名或熟悉的一般结论判published，记unknown。这是精确的离散全称存在命题，按素数分布的核心研究目标保留第三档；未选成短实施靶。 Mathlib：none；钉版Mathlib按目标A号及consecutive primes、complete residue相关文本检索未得此定理；常规Nat.Prime接口不证明连续素数余数模式。 数值方案：约35行Python用埃氏筛生成≤10^7所有素数；对p≤19滑动长度p−1窗口，比较余数集合是否等于set(range(1,p))，首个成功窗口给q及最小性。扫描不够则明确记未找到；更大p所需q可达10^11，不能据有限失败否定存在性。 全部直接 A 引用：A000040。

**A394410 — precise；note-only。** 文献/卡点：已读五个直接引用的全部要求字段。A056826明确记2013年猜想，2026年更新只是对候选p的计算排除与Aurifeuillean必要条件，非二次递推素数保真的证明。Everest等2003书、Guy A3、De Koninck p51未打开原文，文献状态保守unknown。主条目无保留“连续三项和仅n=1,2为平方”是另一个陈述，不能拿来冒充该质数猜想；不把odd/模8/两平方和等简单性质重证当新小猜想。 Mathlib：Polynomial.cyclotomic_prime，.lake/packages/mathlib/Mathlib/RingTheory/Polynomial/Cyclotomic/Basic.lean:367，已读：素数指标圆分多项式等于几何和；不推出整数代入值为素数。本地 cyclotomic/irreducible 检索未见本递推的质数保真定理。 数值方案：20行生成前10项并用试除或可靠素性库检测较小a(n)；对p=3,5,17,157可构造整数商并用确定性素性证书复核。对后项仅枚举小素数ℓ并算pow(p,p,ℓ)，在ℓ∤p+1时若等于−1可给合数反例。p=a(10)已有62位，p^p存储不可行，不能声称可直接完整核验几十项。 全部直接 A 引用：A000290、A001333、A001481、A002315、A056826。

**A394432 — precise；note-only。** 文献/卡点：读完主条目所有字段，直接引用A号为空；真打开全部Further notes。附件仅在“此前没有更小n使a(n)=q”等条件下给奇素数幂q首次出现的判据，并列数据，未证明所选严格性猜想。另一个“总为奇素数幂”按字面有a(2)=1例外，未静默修正。open只表示主源及附件未见目标证明；最小性排除仍是研究任务。 Mathlib：orderOf_pow'（Mathlib/GroupTheory/OrderOfElement.lean:415）及orderOf_pow（同文件:996）已读：阶(x^e)=阶(x)/gcd(阶(x),e)，只重写源中的等式，未给最小模数处的严格不等式。 数值方案：约35行Python对e=2..50从r=e²+1起逐个枚举奇数，用x=pow(2,e,r)再反复乘x直到回1求精确阶；首个阶≥e²的r即候选，测试是否等于e²，并保存此前每个r的阶。可预设r≤10^6，未找到记未决；不使用浮点log。 全部直接 A 引用：none。

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

**A381005 — precise；note-only。** 文献/卡点：主条目完整comment中 Chai Wah Wu（2025-02-13）已直接给完整短证明：令m=2^(2n)、t=2^(2n−1)+1，m为2幂且t奇，故互素异奇偶；三边分别是m²−t²、2mt、m²+t²，因此本原。已打开并读该段（主席成功curl的JSON），并读Mathlib精确分类定理验证映射。Cook博客亦实际打开，但它只给恒等式与二进制性质，未拿它冒充本原证明；Uhler论文未打开，不借其标题判定。因已公开且主要是分类定理代换，档out保留文献。 Mathlib：PythagoreanTriple.coprime_classification（.lake/packages/mathlib/Mathlib/NumberTheory/PythagoreanTriples.lean:524）：整数本原勾股三元组 iff 来自互素且异奇偶的欧几里得参数；已读完整声明和证明。代入 x=2^(2n)、y=2^(2n−1)+1，只有幂式整理和互素性，bind-only风险高。 数值方案：约15行 Python 对 n=1..1000 算三个整数 S,L,H，检查 S*S+L*L==H*H 及 gcd(S,L)==1；直接平方/欧几里得gcd独立于OEIS数据，也可逐项比对主data。n=1给(7,24,25)；有限正向证书不作为档2前沿。 定位：https://oeis.org/A381005 （完整JSON comment，Chai Wah Wu 2025-02-13 欧几里得参数证明，已读）。 全部直接 A 引用：A020884、A381006、A381007、A381008、A381009。

**A381006 — precise；note-only。** 文献/卡点：主条目完整comment中 Chai Wah Wu（2025-02-13）已直接给完整短证明：令m=2^(2n)、t=2^(2n−1)+1，m为2幂且t奇，故互素异奇偶；三边分别是m²−t²、2mt、m²+t²，因此本原。已打开并读该段（主席成功curl的JSON），并读Mathlib精确分类定理验证映射。Cook博客亦实际打开，但它只给恒等式与二进制性质，未拿它冒充本原证明；Uhler论文未打开，不借其标题判定。因已公开且主要是分类定理代换，档out保留文献。 Mathlib：PythagoreanTriple.coprime_classification（.lake/packages/mathlib/Mathlib/NumberTheory/PythagoreanTriples.lean:524）：整数本原勾股三元组 iff 来自互素且异奇偶的欧几里得参数；已读完整声明和证明。代入 x=2^(2n)、y=2^(2n−1)+1，只有幂式整理和互素性，bind-only风险高。 数值方案：约15行 Python 对 n=1..1000 算三个整数 S,L,H，检查 S*S+L*L==H*H 及 gcd(S,L)==1；直接平方/欧几里得gcd独立于OEIS数据，也可逐项比对主data。n=1给(7,24,25)；有限正向证书不作为档2前沿。 定位：https://oeis.org/A381006 （已读本地完整JSON comment，Chai Wah Wu 2025-02-13 欧几里得参数证明）。 全部直接 A 引用：A020883、A381005、A381007、A381008、A381009。

**A381007 — precise；note-only。** 文献/卡点：主条目完整comment中 Chai Wah Wu（2025-02-13）已直接给完整短证明：令m=2^(2n)、t=2^(2n−1)+1，m为2幂且t奇，故互素异奇偶；三边分别是m²−t²、2mt、m²+t²，因此本原。已打开并读该段（主席成功curl的JSON），并读Mathlib精确分类定理验证映射。Cook博客亦实际打开，但它只给恒等式与二进制性质，未拿它冒充本原证明；Uhler论文未打开，不借其标题判定。因已公开且主要是分类定理代换，档out保留文献。 Mathlib：PythagoreanTriple.coprime_classification（.lake/packages/mathlib/Mathlib/NumberTheory/PythagoreanTriples.lean:524）：整数本原勾股三元组 iff 来自互素且异奇偶的欧几里得参数；已读完整声明和证明。代入 x=2^(2n)、y=2^(2n−1)+1，只有幂式整理和互素性，bind-only风险高。 数值方案：约15行 Python 对 n=1..1000 算三个整数 S,L,H，检查 S*S+L*L==H*H 及 gcd(S,L)==1；直接平方/欧几里得gcd独立于OEIS数据，也可逐项比对主data。n=1给(7,24,25)；有限正向证书不作为档2前沿。 定位：https://oeis.org/A381007 （已读本地完整JSON comment，Chai Wah Wu 2025-02-13 欧几里得参数证明）。 全部直接 A 引用：A020882、A381005、A381006、A381008、A381009。

**A390228 — vague；note-only。** 文献/卡点：主所有字段及3个直接ref全部指定字段已读。源name写c(0),...,c(n−1)，example和Mathematica却用c(k)(c(k)−1)，独立n=4计算确认二者确实不同。Sun2013全文虽证明其他多项式discriminator，却不覆盖j系数；A000521的模形式论文未打开证明本素性目标，故unknown。out源于对象冲突而非否认能计算，note-only保留待订正信息。 Mathlib：none；钉版Mathlib检索Klein.*invariant、jInvariant、j_invariant、目标A号及discriminator无本目标声明。 数值方案：约50行Python用E4(q)=1+240∑σ3(k)q^k及D(q)=∏(1−q^k)^24，做整数卷积和常数项1的级数除法，提取j=q^(-1)E4^3/D的c(0..99)。对原系数和F=c(c−1)分别从m=n起扫描并试除判素性。已用前7个精确系数独立试扫：n=4原系数最小13、二次变换最小16（表为16）；n=6分别19和23。 全部直接 A 引用：A000040、A000521、A392667。

**A393833 — precise；note-only。** 文献/卡点：主条目、A000005和A032741全部所需字段未见目标证明；open仅限此检索范围。现有Mathlib已证明存在p≡1 mod n；配合素数幂因子公式给出完整本地推导：k的因子正是p^0..p^(2n+1)，共2n+2个；真因子余数全同，故回文。此为当前推导，不冒称目标已有发表证明；因直接绑定足够，排除新靶。主条目example末句a(9)=19^4*37^3与data的19026866不一致，不依赖该句。 Mathlib：Nat.exists_prime_gt_modEq_one，Mathlib/NumberTheory/PrimesCongruentOne.lean:28（∃p,Prime p∧B<p∧p≡1[MOD n]）；Nat.divisors_prime_pow、Nat.properDivisors_prime_pow，Mathlib/NumberTheory/Divisors.lean:420,506（分别为range(e+1)、range e上的幂映射）。已读声明和证明。 数值方案：30行Python对n=1..50搜索p=1+tn的首个素数（n=1取2），令k=p^(2n+1)，独立试除验证p素性，生成幂0..2n+1并检查约数数目及去末项余数串回文。最小项另用除数筛扫描k≤10^6核对可达条目；超界不声称已求最小。 全部直接 A 引用：A000005、A032741。

**A394054 — precise；note-only。** 文献/卡点：已完整阅读主条目和全部13个一跳引用。实际打开Höft《Theorems Relating to Conjectures by Omar E. Pol》(2026-03-21)4页全文：p.4 Theorem 4及Corollary 1(a)明确证明SRS(n)部分数等于2-稠密块数，依据p.2 Lemma 1(e)与p.3中心块唯一性；同时打开其依赖A384149的7页全文，Theorems 2–3及p.6 Theorem 4给非中心/中心部分与因子块的对应及面积公式。把点态等式代入m≤n的计数就是目标。另打开AlphaProof Nexus target_theorem_0；它预先用奇因子断口表述定义a，故单独不能证明到原始几何定义的忠实性。这里published指公开证明手稿，未声称同行评审。 Mathlib：none（检索NumberTheory的dense/divisor、symmetric representation、SRS未见目标；最终筛集基数相等仅需逐点等式改写，但SRS几何编码与块双射没有查到Mathlib声明）。 数值方案：约40行Python对m=1..2000试除取得升序因子，计1+相邻y>2x的断口数；另对i=1..r，r=floor((sqrt(8m+1)-1)/2)，算b_i=[m≥i(i+1)/2且i整除m-i(i+1)/2]、c_i=Σ_{h≤i}(-1)^(h+1)b_h，计c_i>0的连续段数R，以2R-[c_r>0]得到几何部分数。逐点比较后累计各k的直方图，不能用断口公式同时算两侧。 定位：https://oeis.org/A237270/a237270_4.pdf#page=4；https://oeis.org/A384149/a384149.pdf#page=4；https://raw.githubusercontent.com/google-deepmind/alphaproof-nexus-results/main/APNOutputs/OEIS/oeis_a237271_conjecture_2.lean。 全部直接 A 引用：A000027、A174973、A237270、A237271、A237593、A239663、A240062、A379288、A384149、A384222、A392987、A394052、A394053。

**A394791 — precise；note-only。** 文献/卡点：Höft 2026-03-21 Theorem4 的完整证明已解“部分数=最大2-稠密因子块数”，Theorem1(c,d) 证明中心相接⇒中央因子 d₂=2d₁+1 并点名 A298856；A298856 另有其 Dyck 路径刻画的完整双向论证。但将 d₂=2d₁+1 反向推出中心相接的桥，所读证明未明确单独闭合，不能把这些单向结果合称整个枚举猜想已证。故全目标 unknown，先补文献/几何桥，不直接派实施。A384149 的2025-06-27七页手稿 Theorems2–4也已读，仅用其已证部分。 Mathlib：none：几何编码/稠密块桥未在钉版 Mathlib 找到；一旦输入该公开桥，第 n 个相等仅为集合改写，故中风险。 数值方案：试除取得因子排序、在 next>2·previous 处断块并检查两中央因子；另一侧用 A237593 两条 Dyck 路径的网格边界计部分、检测中央相接，扫描小整数直到所需列/最小项，不能两边都用断块公式。 定位：https://oeis.org/A237270/a237270_4.pdf；https://oeis.org/A384149/a384149.pdf；https://oeis.org/A298856。 全部直接 A 引用：A000203、A014105、A033676、A033677、A071561、A174973、A191363、A207375、A237270、A237271、A237593、A239929、A240062、A245092、A262259、A262626、A264104、A280107、A298856、A320511、A384222、A392197、A395156。

**A395156 — precise；note-only。** 文献/卡点：Höft 2026-03-21 Theorem4 的完整证明已解“部分数=最大2-稠密因子块数”，Theorem1(c,d) 证明中心相接⇒中央因子 d₂=2d₁+1 并点名 A298856；A298856 另有其 Dyck 路径刻画的完整双向论证。但将 d₂=2d₁+1 反向推出中心相接的桥，所读证明未明确单独闭合，不能把这些单向结果合称整个枚举猜想已证。故全目标 unknown，先补文献/几何桥，不直接派实施。A384149 的2025-06-27七页手稿 Theorems2–4也已读，仅用其已证部分。 Mathlib：none：几何编码/稠密块桥未在钉版 Mathlib 找到；一旦输入该公开桥，第 n 个相等仅为集合改写，故中风险。 数值方案：试除取得因子排序、在 next>2·previous 处断块并检查两中央因子；另一侧用 A237593 两条 Dyck 路径的网格边界计部分、检测中央相接，扫描小整数直到所需列/最小项，不能两边都用断块公式。 定位：https://oeis.org/A237270/a237270_4.pdf；https://oeis.org/A384149/a384149.pdf；https://oeis.org/A298856。 全部直接 A 引用：A000203、A014105、A033676、A033677、A071561、A191363、A207375、A237270、A237271、A237593、A240062、A262259、A262626、A264104、A280107、A298856、A320511、A384222、A392197、A394791。

**A395171 — precise；note-only。** 文献/卡点：该猜想已被公开反驳：MathOverflow 回答511088（2026-06-14）以 p=3,m=2283 给不同 k 的 gcd；不能作为新反驳靶。Love 的回答511242另证合格 m 的存在，不证明 gcd 恒定。本席补查 p=5：m=2..8 在 k=1 时均 gcd=1，m=9 在 k=1 为121、k=1499为362879；121∣9^5−1 保证9对所有 k 合格，故确实对应最小项。published 在本行专指已有反驳与存在证明，不称原猜想被正面证明。 Mathlib：none；Nat.gcd_dvd_left、Nat.gcd_dvd_right 只供整除接口，不能独自决定本序列最小项。 数值方案：已实际用 Python factorial、gcd、pow(base,exponent,modulus) 复算上述 p=5 反例与最小性排除；不需构造9^7495的大整数。 定位：https://mathoverflow.net/a/511088；https://mathoverflow.net/a/511242。 全部直接 A 引用：A000978、A005384、A393224、A395115、A395286、A395944。

**A399155 — precise；note-only。** 文献/卡点：A175126 的已知公式 f(n)=(n−lpf(n))/2+1 与 A309892 的已知界 g(n)≤n/gpf(n) 已给出支配事实：写 n=l·r，l=lpf(n)，则 g≤n/gpf(n)≤r≤l(r−1)/2+1=f（n≥2）。published 指这两个公开公式及其直接代数推论，未找到单独发表比较定理的论文；条目另问纤维有限，不据此声称已解。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：试除取得最小/最大素因子，各自从 n 迭代到 0，计步，检查 n=2..10000；约30行。 全部直接 A 引用：A175126、A309892。

**A389650 — precise；drop。** 文献/卡点：已实际打开Cloitre arXiv:2508.02690v2 HTML，读Theorem18及其证明、Conjecture19原文。定理18只证c>c0≈0.5956；同文Conjecture19仍明确列c>C，不能把定理18当更强目标的证明。五个直接引用的comment/formula/xref/reference/link已全读。主源把C定义为limsup后其“a(n)≤c p_n最终成立”字面版本有定义性风险；保留论文实际h(n,c p_n)陈述以避免偷换，仍属无界解析，直接out。 Mathlib：zeta_nat_eq_tsum_of_gt_one，.lake/packages/mathlib/Mathlib/NumberTheory/LSeries/RiemannZeta.lean:223，已读，只给整数参数zeta的Dirichlet级数。检索Golomb/Keller/Nagura/Westzynthius无目标命中。 数值方案：几十行筛前201个素数；对n≤200逐个s=2..p_n，用高精度区间算zeta(s)∏_{j≤n}(1−p_j^(−s))−1，判断其是否小于(p_(n+1)−1)^(−s)，找最小s；可用∑_{m≤M,gcd(m,p_n#)=1,m>1}m^(−s)加积分尾界 M^(1−s)/(s−1)独立包围，跨阈值才增精度。有限实验不能验证“充分大”。 全部直接 A 引用：A000040、A001223、A002110、A002386、A092526。

**A390878 — vague；drop。** 文献/卡点：主源及18个一跳引用所需字段已完整读，包括很长的A000041。A176206指定整数k出现p(n−k)次；但目标句未说明重复部分/因子组如何计数。实际打开Höft 2026 p.4 Theorem 4，证明SRS部分数=因子块数；这只解决点态权重。按上述澄清版本可直接有限双计数推导，不能据此声称含糊原句已有发表证明。范围上属于语义未固定或既有结论加权，无适当新目标。 Mathlib：Nat.Partition.partitionWithPartEquiv，Mathlib/Combinatorics/Enumerative/Partition/Basic.lean:236，删除一个指定部分的等价；已读声明及实现。没有SRS/因子块目标；若按A176206的p(n−k)多重性定义右端，则剩余为已知点态等式的加权。 数值方案：先明确右端多重性。可用递归枚举n≤15的整数分拆并记录每个不同部分k出现的分拆数，核查为p(n−k)；再独立枚举k因子块并求和，与分拆DP算p及几何SRS算出的卷积比较。若按所有部分出现次数计数则应是Σⱼp(n−jk)，这能检出语义差异。 定位：https://oeis.org/A237270/a237270_4.pdf#page=4。 全部直接 A 引用：A000041、A174973、A176206、A196020、A221529、A235791、A236104、A237270、A237271、A237591、A237593、A245092、A262626、A336811、A384222、A384931、A390877、A390880。

**A392059 — vague；drop。** 文献/卡点：读完主条目及A387569、A392055全部指定字段；没有引用目标证明。open仅指所查源未見证明；这里另有完整初等反例：高斯整数z=x+yi被1+i整除 iff x+y偶数，n=1、k=P(1)=1时差为i不整除。对整数a或高斯整数a都已失败。范围out是源表述/同余对象问题；未把定义乘积等同于猜想。 Mathlib：none；钉版Mathlib检索Gaussian.*binomial及binomial.*Gaussian无该周期定理；普通高斯整数环或二项式接口不决定分母与模同余约定。 数值方案：n=1无需长程序：a(1)=空积=1，取实部a=0，binom(i,1)−binom(0,1)=i，其实虚部之和为1，故1+i不整除i。约35行Python用Fraction对高斯数对逐项乘(a+ki−j)/n!，测试是否落在Z[i]及差的实虚部和是否偶数；枚举n≤8、a=0..100、k≤2·所给乘积，区分整数性和同余，分母非整数记未定义。 全部直接 A 引用：A387569、A392055。

**A394059 — precise；drop。** 文献/卡点：主条目及A039704、A393703所有指定字段已读。打开Freiberg arXiv:1005.4703全文PDF的引言与定理1.1：其自身定理只给连续素数对，不能覆盖任意长度；引言提到Shiu的任意长度扩展。又打开Shiu2000 Cambridge出版页，摘要明确声称任意长strings，元数据定位359–373页、DOI 10.1112/S0024610799007863；但Wiley及Cambridge全文请求未取得可读PDF，故按“未打开目标完整证明”要求仍unknown，不以转述判published。无穷多个为无界解析，直接out。 Mathlib：none；钉版Mathlib检索Shiu、palindrom.*prime、consecutive primes未得连续同余素数块定理。 数值方案：约35行Python用埃氏筛列出≤10^7素数并取模6，对n=1..30滑动窗口，比较w==w[::-1]，记录最小起点和总出现次数；或中心扩展同时统计各长度。有限次数不能证明无穷多。 全部直接 A 引用：A039704、A393703。

**A395520 — precise；drop。** 文献/卡点：主条目全部字段及A001414、A036349指定字段已读。通过StackExchange API打开MathOverflow 510477完整问题与answers（空数组、has_more=false）。其有界债务定义与例示存在起点口径张力，故未选该vague版本，选首现最终排序。所列Alladi–Erdős、Tenenbaum、Weingartner全文未打开，不能由书目或sopfr模2均匀分布推定目标证明，记unknown。该目标为无界算术间隙分布，按范围out。 Mathlib：none；在钉版 Mathlib 检索 sopfr、primeFactorsList.*sum、目标A号，没有此间隙首现顺序定理。 数值方案：约40行Python用最小素因子筛计算s(1)=0、s(n)=s(n/spf(n))+spf(n)，取1≤n≤10^6中s(n)偶数者的相邻差；用素数筛识别差值并记录first[p]。检查已出现素数对p<q的first[p]>first[q]。未出现值记missing，不能当永不出现；增大界只作实验。 全部直接 A 引用：A001414、A036349。

**A396081 — precise；drop。** 文献/卡点：源 conjecture 明确要求无限多素数；A381466 的已知递推界/局部整除性质不推出无限出现。按用户无穷性断言排除；不把递推易写当可派实施。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：从 b(0)=4 起，g=gcd(b(k−1),k)，g=1 则加 k，否则置 k/g；筛 p≤B 并检查 b(2p)=p，十几行可验前缀但不证无限性。 全部直接 A 引用：A381466、A394761。

**A396696 — precise；drop。** 文献/卡点：这是无界实分析及素数间隙存在断言。A051254 的 Mills 定理、A051501 的 Wright 构造及 A082282 使用其他增长尺度，不能替代本猜想；所检索条目未给本尺度的证明。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：以 nextprime 迭代有限前缀 a_n，精确检查 a_n<n²(a_(n−1)+1)，给有限区间交而非实数 C 的全称证书。 全部直接 A 引用：A051254、A051501、A082282。

**A396785 — precise；drop。** 文献/卡点：主条目及A381466/A381501全部要求字段已读，来源无目标证明链接；A381466给出平方根下界等无保留断言，能解释每个p的有限检索窗口，却不证明有无穷多个p遗漏。A381501线性增长也是经验语句。主目标明确infinitely many，按范围out，不能降格为验证几个遗漏素数的普通有限证书。 Mathlib：Nat.gcd_greatest（.lake/packages/mathlib/Mathlib/Data/Nat/GCD/Basic.lean:35）给gcd的最大公因子刻画，已读声明；全库检索 Rowland、A381466 未见本递推的素数遗漏无穷定理，none（目标层面）。 数值方案：约30行 Python 从 u=4 对 n=1..P*(6*P−2) 顺序迭代 g=gcd(u,n)，g=1则u+=n，否则u=n//g并记录除法步素数输出；筛 p≤P 去掉记录者。P=200即可重现首个17、103等；P=1000约600万步。有限截止依赖OEIS无保留给出的全局值下界/出现位置上界，独立重证前只能将结果标条件性完整；直接记录出现则无此依赖。 全部直接 A 引用：A381466、A381501。

**A396847 — precise；drop。** 文献/卡点：A119471 的相关实数/级数关系仍为猜想；所查条目未给边界收敛及等式证明。收敛半径与边界取值是本席排除的无界解析断言。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：可截断级数并用有理区间迭代估计根，但没有尾项误差证书就不能检验边界取值，故 no。 全部直接 A 引用：A119471。

**A396915 — precise；drop。** 文献/卡点：已读主条目和A003415/A005117/A120944所有要求字段。主条目明确只以Bunyakovsky猜想支持无穷性，计数为经验启发。实际打开 erdosproblems.com/307，页面仍标Open且Proof expositions(0)，该题要求两个素数倒数和乘积为1，与本条仅加号平方条件不同，不能把二者等同。无界infinitely many/asymptotic按用户范围直接out；open仅表示所查来源无目标证明。 Mathlib：Nat.squarefree_iff_nodup_primeFactorsList（.lake/packages/mathlib/Mathlib/Data/Nat/Squarefree.lean:34）：n≠0时无平方因子等价于素因数列表无重复；已读声明。全库文本检索 arithmeticDeriv/arithmetic derivative/Bunyakovsky 未命中目标，无直接素值多项式无穷性声明。 数值方案：约30行筛最小素因子至 X=10^6，分解每个k，只保留至少2个不同素因子且指数全1，算 D(k)=Σ_{p∣k}k//p，再以 isqrt(D(k)+2*k)^2==D(k)+2*k 判入列；核对 data 和计数比值。可另筛 s≤10^4、s≡±4 mod11，检验 q=(s²−5)/11 为素数，得到子族5q。仅有限样本，不能验证无穷或渐近。 全部直接 A 引用：A003415、A005117、A120944。

**A398129 — vague；drop。** 文献/卡点：列表成员由猜想性的“唯一无限分支”决定；有限前缀不能无条件确定该序列。A398130 是同一树的另一同余类，A078611/A129758 的对称素数定义没有证明无限分支唯一。可以另写精确树谓词，但此无界分支目标不进入本席。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：筛到明确上限，对每个中点找最近对称素数对并建有限树，记录截断处活分支；这不能验证真正的分支成员资格，故 no。 全部直接 A 引用：A002476、A007528、A078611、A129758、A398130。

**A398130 — vague；drop。** 文献/卡点：列表成员由猜想性的“唯一无限分支”决定；有限前缀不能无条件确定该序列。A398129 是同一树的另一同余类，A078611/A129758 的对称素数定义没有证明无限分支唯一。可以另写精确树谓词，但此无界分支目标不进入本席。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：筛到明确上限，对每个中点找最近对称素数对并建有限树，记录截断处活分支；这不能验证真正的分支成员资格，故 no。 全部直接 A 引用：A002476、A007528、A078611、A129758、A398129。

**A398367 — precise；drop。** 文献/卡点：读完主条目全部字段及唯一直接引用A398382的全部指定字段。主条目对无界性另有鸽巢论证，但明确写 The convergence to this solution is still conjectural；相位长度恒等式及x方程的theta改写不证明收敛。未见目标证明（open仅在这些源与refs的已查范围内）；两个目标均为无界解析极限，按用户范围直接out。 Mathlib：none；在钉版Mathlib及D5检索 trampled、carousel、A398367 无目标命中；此处没有现成过程极限定理。 数值方案：约40行Python用列表cells=[0]、位置p=0，每步append(0)、cells[p]+=1、记录值并令p=(p−cells[p])%len(cells)；扫描前10^6步切分极大连续1段与>1段，计算L(k+1)/L(k)及均值。方程右侧截到m=30，二分x∈[0.6,0.7]，尾项用几何级数界；有限数据只能比较，不能证极限。 全部直接 A 引用：A398382。

**A398812 — precise；drop。** 文献/卡点：源 formula 已附 Chai Wah Wu（2026-08-20）的完整夹逼：覆盖面积 A138808(n)≤n·τ(n)，τ(n)≤2√n，故比例亏损≤2/√n→0；本身也属于本席排除的渐近断言。A398810 当前是 allocated 占位条目，无数学字段。 Mathlib：none（在已检索的 Mathlib 范围未找到目标声明） 数值方案：对 n≤100 枚举整数格 (x,y)，覆盖当且仅当存在 d∣n 满足 x≤d 且 y≤n/d，计未覆盖面积；数值 yes 仅指前缀。 全部直接 A 引用：A138808、A283626、A398809、A398810、A398812。

## 未主张

未主张检索穷尽、open 等于全球无人证明、所有外链论文已全文审读、或 published 等于原猜想为真。未跑 Lean、未编译伪签名、未核验公理闭包、未建模块/原子/冻结记录。未证明任何 dispatch 目标，也未保证其符合最终逃逸准入；具体声明检索不等于真实 bind-only 探针。

除逐段明确写“已实际核验”及 A395171 的模幂反例检查外，数值栏均是**可执行的验证方案**，未声称已运行。文献中的表值和程序输出不冒充本席独立数值证据。A395171 的本席计算：p=5、m=9，k=1 时 gcd=121，k=1499 时 gcd=362879；m=2..8 在 k=1 时均为1。该结果只补充已公开的反驳，未主张新发现或形式化反驳。

未对第三档目标作自主研究承诺；未把有限前缀通过、概率素性、相邻已知公式、外部 Lean 文本或单向蕴含冒充所需的无界精确定理。
