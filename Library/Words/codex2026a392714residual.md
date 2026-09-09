---
bibkey: codex2026a392714residual
authors: Codex implementation worker
year: 2026
title: A392714 round two — the residual signed sum S(a)
doi: null
url: https://github.com/the-omega-institute/trureturing
claim: A general Lean proof of the residual signed sum S(a); the original conjecture bridge is outside scope.
strata_touched:
  - D5/S1/Words/Compositions/ResidualPermutationSign
license: citation-only
triage: anchor
---

# S(a) 第二轮研究记录

产地：Codex 主循环，使用 lean4 skill；零独立评审席，单点自查。
用户给出的 m≤7 读数是输入，未冒充本席亲验。
起点及本地 origin/dev 均为 `25b883dcebf4305950c779111490338639eed3bc`；
分支 `lane/math/a392714r2`，Lean 4.33.0，
Mathlib pin `db584cd6d46c92f209a44c0f1c829460d327499d`。
已完整分段阅读 CLAUDE.md、agents/CONTEXT.md 及上一轮
`codex2026a392714probe`；不重做 Φ(n) 上的配对、文献核对或已有有限枚举。
Library/Words 容量：`find Library/Words -type f | wc -l` = 22（新增本文件前）。

## 预登记 v1

档位 1，新近小猜想研究线的独立组合子命题。
唯一目标：对 m≥1 及 {1,…,m} 的排列 a，A₀=0，Aᵢ=Σⱼ≤ᵢaⱼ，
L(a)={b排列 : 对所有 1≤i≤m，Aᵢ₋₁<Bᵢ≤Aᵢ}，证明
Σᵦ∈L(a)sign(b)=[a=id]。不加入从 Φ(n) 到 L(a) 的桥。

先按 D5 → 钉版 Mathlib → 第三方 Lean/数学文献顺序检索。
精确的已发表且带证明的等价陈述命中，即按用户要求
`bind-only + rule-11-upstream-wrapper` 报告并停止重证。
未命中时先分析带区间约束的交替路径和，优先最大值删除递推，
再分析行列式/外代数状态和及容斥；每条路线记录所需的精确一般引理。
拟议 escape_witness：区间约束交替路径和的一般消去递推，或等效的
行列式/组合构造。尚未构造，不把拟议见证报成已证。
如观察所得见证改变，先另记预登记版本再实施。

停止：成=S(a) 无 sorry/私 axiom 的 Lean 证明通过 make lean 且 PR 开出；
翻=实际反例及 kernel 见证；否则本轮以 blocked 端化。
路线停止条件：一个候选递推被反例击破后，只允许一次改变状态空间的修订；
同一缺口再次出现即登记障碍，转向下一路线。
本次交回前必须结算三态之一，不以 open/进行中冒充结算。
每批检索读数、路线结论和 Lean 验证后即时 commit + push。
有限正向枚举只作诊断，不冻结，不称未知范围进展。

## 声明与构建账（开工时）

公开定理：空；proof_shape / 直接冻结依赖(GID, statement_id) /
escape_witness / admission_basis 均暂无已交付条目。
拟议 S(a) 为 content、escape-witness，最终须以实际证明项重新逐条核对。
make lean：尚未运行；LEAN_CACHE：尚未取得。

## 未主张

未主张检索穷尽；未主张 A392714 原猜想已解决
（桥明确不在本轮范围）；未主张任何有限吻合构成证明。
未真正打开的外部页面均为 ASSUMED-UNVERIFIED，不能承载文献结论。

## 检索批次 1：D5

命令模板 `git grep -n -P '<pattern>' -- D5`，在上述起点源码上查询。
下列为匹配行数，不冒充声明数：

| pattern | 行数 | exit |
| --- | ---: | ---: |
| `\bsum_involution\b` | 3 | 0 |
| `\bsign\b` | 294 | 0 |
| `\bPerm\.sign\b` | 0 | 1 |
| `\bprefix\b` | 371 | 0 |
| `partial sum` | 41 | 0 |
| `Lindström\|Gessel\|Viennot\|LGV`（PCRE alternation） | 0 | 1 |
| `\btheorem\b`（相同词界特性阳性对照） | 25410 | 0 |

sum_involution 命中 ConvolutionRecurrenceOddPowersOfTwo 与
ReflectedSpectrum/ParityConditionedMoments，均需自供配对，不是 S(a)。
Perm.sign 与 LGV 零命中；sign/prefix 的宽筛含注释及不相关含义，
这些计数只证明搜索执行，不证明语义穷尽。
完整 stdout、命令及退出码保存在 runner attempt 的 `d5-search.json` 和对应 txt。

## 检索批次 2：钉版 Mathlib 与缓存

`make lean-cache-ensure` EXIT=0：status=seeded，method=clonefile，
clonefile_attempts=1，donor=/Users/chronoai/trureturing，stamp_miss=null，
mathlib_missing_olean_files=0，project_olean_state=warm，mathlib_olean_state=warm；
archive_status=not_attempted，archive_skip_reason=project olean state is warm。
未设置 LAKE_JOBS；warm 收据不代替 make lean。

命令模板 `rg -n '<pattern>' .lake/packages/mathlib/Mathlib`。
匹配行数（不是声明数）：`\bsum_involution\b` 7；
`\b(theorem|lemma) sign_[A-Za-z_]+` 115；`\bdet_apply\b` 53；
`\bsum_comm\b` 95；`Lindström|Lindstrom|Gessel|Viennot|\bLGV\b` 0；
`non.?intersecting|nonintersecting` 0；阳性对照 `\btheorem\b` 130789。
零命中 exit=1，其余 exit=0，全部 stderr 为空。
完整收据在 attempt 的 mathlib-search.json 与对应 txt。

精确接口位于 GroupTheory/Perm/Sign.lean 的 sign_mul、sign_one、sign_swap，
LinearAlgebra/Matrix/Determinant/Basic.lean 的 det_apply 与 det_apply'。
后者逐位乘积的展开本身不处理依赖整个前缀的约束。
sum_involution 由 to_additive 生成，文本计数不含它的生成声明头；
后续编译 #check 才核对 elaborated 类型。
此范围未命中目标；不主张整个数学文献中不存在等价定理。

## 检索批次 3：第三方与公开数学检索

实际出网方式为本地 authenticated gh 与 Python urllib（未用任何未开放的搜索工具）。
命令 `gh api -X GET search/code -f 'q="partial sums" "sign" language:Lean'`
返回 total_count=97，读取默认第一页；`"interlacing" "permutation" language:Lean`
返回 2（PerAlexandersson/RealRooted 的 Tactic/Targets.lean、
afflom/emporous 的 UorAtlas/Scales.lean）。查询是词面粗筛，未宣称全部 97 个文件已读。

已打开 arXiv API：`all:"permutations" AND all:"partial sums" AND all:"sign"`，
max_results=10，totalResults=2。摘要分别为 2608.16752v1（随机游走凸包吸收概率的
signed permutations，符号为步长正负选择）及 1703.08830v2（signed Young modules
和整除限制的 compositions）；摘要没有本题双排列交错区间的逐 a 奇偶差定理。
两篇全文目前 ASSUMED-UNVERIFIED，不从摘要推断全文没有等价结果。

OEIS 搜索 `"permutations" "partial sums" "sign"` 的 text 响应已打开，首批十项为
A316292、A316293、A214663、A316294、A282864、A282840、A282865、A130472、
A058884、A137501；未命中 S(a) 陈述。不重查上一轮已核对的原序列全文。
Reservoir `/packages?q=permutation` 返回普通 829 项目录及 No results found 混合页面，
未把它认作有效的精确包检索。
Google 的查询 `permutation "partial sums" "signed sum"` 返回重定向/challenge；
Bing 的查询 `permutation "interlacing" "partial sums" sign` 页面标题保留查询，
正文却全为 API design 结果（10 条），语义不相干，判无有效读数。
以上失败不当作零命中或检索穷尽。原始响应与解析文本均保存在 attempt。

### 第三方跟进与第一批状态探针

已下载并读相关命中上下文：TauCeti 的 Dominance.lean 是 James dominance lemma
（Young tabloids / column antisymmetrizer）；RealRooted 的 Targets.lean 是实根多项式
tactic 目标目录；UorAtlas/Scales.lean 的 interlacing 是 Cauchy 特征值交错。
它们均不是所查 S(a) 的精确陈述，未加入依赖。
arXiv 另查 `all:"permutation" AND all:"interlacing" AND all:"sum"` 得 4 摘要：
2602.04390v2、1505.08010v1、1312.0665v2、2505.05873v1；分别是彩色交错三角形、
Ramanujan 图、Hardy–Littlewood–Pólya 序列和 Baxter 多项式实根。
`all:"permutation" AND all:"partial sums" AND all:"cancellation"` 得 0。
四篇全文未读，ASSUMED-UNVERIFIED。以上是有限检索范围中的 not-found-in-searched-scope。

先定义子集状态，避免把前缀和相同但已用值不同的历史混在一起：
F₀(∅)=1，其余零；令 w(T)=Σₓ∈T x，则
Fᵢ(T)=[Aᵢ₋₁<w(T)≤Aᵢ] Σₓ∈T (−1)^{#{y∈T:y>x}} Fᵢ₋₁(T\{x})。
末态 Fₘ({1,…,m}) 是目标交替和；这一步的纸面理由是按末字母分组，
新增逆序恰为前缀中大于 x 的字母数，尚未声称 Lean 证明。

以该状态算法诊断更强的任意正权重版本：权重集 (1,2,3,4)、(1,2,4,8)、
(1,3,4,9)、(2,3,5,6) 各查全部 24 个 a，均仅递增 a 的末态为 1。
原目标 m=8 查 40320 个 a：一个 1、40319 个 0、反例零。
这批只用于检查状态表述及决定是否研究权重一般化；不是证明，也不报为未知范围进展。
首次脚本因本机 Python 不支持 int.bit_count 退出 1，改为 bin(...).count("1")
后退出 0；未隐去工具失败。完整代码和结果如下，另存 attempt/states.py 与 states-results.json。

```python
from itertools import permutations,combinations
from collections import defaultdict
import json
from pathlib import Path

def signed_states(weights,a):
 n=len(a); states={0:1}; layers=[]; low=0
 for y in a:
  high=low+y; nxt=defaultdict(int)
  for mask,v in states.items():
   h=sum(w for j,w in enumerate(weights) if mask>>j&1)
   for j,x in enumerate(weights):
    if not mask>>j&1 and low<h+x<=high:
     nxt[mask|1<<j]+=v*(-1 if bin(mask>>(j+1)).count("1")%2 else 1)
  states={k:v for k,v in nxt.items() if v};layers.append(states);low=high
 return states.get((1<<n)-1,0),layers

rows=[]
for weights in [(1,2,3,4),(1,2,4,8),(1,3,4,9),(2,3,5,6),(1,2,3,4,5,6,7,8)]:
 bad=None;count=0;hist=defaultdict(int)
 for a in permutations(weights):
  val,_=signed_states(weights,a);count+=1;hist[val]+=1
  if val!=int(a==weights):bad={'a':a,'sum':val};break
 row={'weights':weights,'checked':count,'bad':bad,'hist':dict(hist)};rows.append(row);print(json.dumps(row),flush=True)
Path(__file__).with_name('states-results.json').write_text(json.dumps(rows,indent=2)+'\n')
```

## 预登记 v2：有限多项式的行列式消去（待核验）

v1 的子集递推保留为探针；新的拟议逃逸见证改为以下**有限多项式恒等式**及
排列指数的唯一性引理。它不是幂级数，也不包含原猜想的桥。
本节在 Lean 实施和该恒等式的独立数值核验之前登记。

对固定 b，原条件等价于 Bᵢ≤Aᵢ<Bᵢ₊₁（1≤i<m），Aₘ=Bₘ=N。
故 dᵢ=Aᵢ−Bᵢ 独立满足 0≤dᵢ<bᵢ₊₁；d₀=dₘ=0；
aᵢ=bᵢ+dᵢ−dᵢ₋₁ 自动为正整数。
把所有正整数组合 a 的符号和作为系数，得到有限多项式

Pₘ(x)=Σᵦ sign(b) x₁^{b₁} ∏ᵢ₌₂ᵐ [xᵢ Σᵣ₌₀^{bᵢ−1} xᵢ^{bᵢ−1−r}xᵢ₋₁^r]。

这是逐位乘积的行列式。乘以相邻差 ∏ᵢ₌₂ᵐ(xᵢ−xᵢ₋₁)，
各行成为 xᵢ^{bᵢ}−xᵢ₋₁^{bᵢ}（首行不变），累加行还原普通幂矩阵。
Vandermonde 公式预期给出

Pₘ = x₁ (∏ᵢ₌₂ᵐ xᵢ²) ∏_{1≤i<j≤m, j−i≥2}(xⱼ−xᵢ)。

排列指数唯一性拟议证明：任一项的第 2…m 个指数至少 2；若指数是
1…m 的排列，则指数 1 必在第一位。取第一变量指数 1 强迫所有含 x₁ 的
差因子选 xⱼ；去掉第一变量并把其余指数各减 1 后归纳，唯一得到 (1,…,m)，
系数 +1。也可把每个差因子选项看作完全图定向，固定相邻边形成一条有向链；
入度为 0…m−1 的排列迫使定向传递且链决定次序。

状态仍未结算：上述恒等式及系数桥尚未 Lean 核验，不把纸面推导当作成功态。

## 预登记 v3：逐条删除下界的组合证明（待 Lean 核验）

v2 仍是一条纸面证明路线；现改用更短的纯组合证明，不需要形式化多项式系数桥。
新的拟议见证点名为 lower_cut_removal（符号和层面删去一个下界）与
upper_sum_vanish（上界集合由最小错位值给出的固定交换封闭）。在此登记后才写 Lean。

1. 总是保留 Bᵢ≤Aᵢ。按 i=1,2,…,m 的顺序删去下界 Aᵢ₋₁<Bᵢ。
   i=1 下界由正性自动成立；i≥2 的坏子集 Bᵢ≤Aᵢ₋₁ 用固定交换 (i−1,i)。
   它只改变 Bᵢ₋₁，而交换后 Bᵢ₋₁′<Bᵢ≤Aᵢ₋₁，故上界保持。
   早先的下界已经删除，剩余下界涉及 Bᵢ 或更后，均不变。
   坏子集反号且二次还原，因此删除该下界不改变总符号和。
   **不是**在 L(a) 上再选首个合法交换；这是不同集合之间逐条消去的恒等式。
2. 对只剩上界的集合，若 a=id，逐项最小未用值强制 b=id。
   否则令 k 为 a 的最小错位值（此前各位固定），令 j>k 为值 k 的位置。
   上界同样强制 b 的此前各位固定，所以位置 j−1,j 的值都至少 k。
   由 Bⱼ≤Aⱼ=Aⱼ₋₁+k，交换后 Bⱼ₋₁′≤Bⱼ−k≤Aⱼ₋₁；
   其它上界不变，固定交换 (j−1,j) 即给出整个上界集合的反号对合。

一基描述如上；Lean 将在 Fin m 里对数值加 1，全部边界按前缀长度定义。
拟议公开 S(a)：proof_shape=content，直接冻结依赖=[]（只用 Mathlib），
escape_witness=lower_cut_removal + upper_sum_vanish，admission_basis=escape-witness。
最终四项判据须对 elaborate 后的实际声明路径逐条作答。

## Lean 核验批次 1

热树增量 `lake env lean <attempt>/Residual.lean` 最终 EXIT=0。
已验证 prefixSum、Upper、LowerFrom、signInt 定义，及 prefixSum_zero /
prefixSum_step / prefixSum_mono / prefixSum_pos。首次 prefix 是 Lean 保留字，
且一个试查的 sum_filter_add_sum_filter_not_eq 名不存在；修正后无诊断。
实际 #check 命中 Equiv.sum_comp、Finset.sum_involution、
Finset.sum_filter_add_sum_filter_not、Equiv.Perm.mul_apply、swap_apply_def。
没有 S(a) 证明或冻结；当前完整编译源码保存在本报告末尾，随提交推送。
A5/A5.1 真源已查：utility 位于 anchors 与 digest 之间，无计算性内容时字面 none。
候选 D5/S1/Words 根递归计数 103、Blueprint 对应根 120，故不在根新增；
实际落点须另数一个现有子目录容量。


## Lean 核验批次 2

热树增量最终 EXIT=0，无诊断。已验证相邻交换只改变一个前缀长度、交换二次还原、
无不动点、signInt 反号，以及短前缀上界条件下 Upper 的保持。
首次 rw 误选到要保留的前缀，指定 k=v.val+1 后闭合；未改陈述。
落点候选 Compositions 子目录实际递归计数：D5 6，Blueprint 12，均小于 48。


## Lean 核验批次 3：关键下界删除

热树增量最终 EXIT=0；lower_cut_removal 与 rowSum_eq_upper 已通过 kernel。
它们直接证明每次下界删除的坏子集符号和为零，并迭代到 Upper 集合。
初次 Finset ext/simp 过度展开成员关系，改为显式 Finset.ext 与分步展开后闭合；
类型头需 Classical 的 DecidablePred 已显式提供。余一个不承重的 unused change 警告，
下批会删除该行。未引入 sorry 或 axiom；上界总和的最终消去仍待验证。


## Lean 核验批次 4：上界集合的消去

热树增量最终 EXIT=0，无诊断。upper_fixed_prefix、upper_identity、
exists_min_move、upper_sum_vanish 已通过 kernel。
非恒等 a 的固定交换取最小错位值所在位置及前一位置，与 b 无关，故稳定。
修正了 ext 继续下钻到 Fin.val 的类型错位、let 的替换方向和一次 rw 的匹配侧；
数学陈述未改。两个承重消去引理现在均已编译；最后需把原始 L(a) 的逐项条件接上，
再进入 D5/Scribe/构建门，尚未报“成”。


## Lean 核验批次 5：S(a) 全称证明

热树增量最终 EXIT=0。InResidual 逐项采用原题的严格下界与非严格上界；
inResidual_iff 接到 Upper ∧ LowerFrom 0；signed_residual_sum 无附加假设闭合。
首次 id 分支的 singleton 和未被 simp 自动求值，改用 sum_eq_single 后闭合。
最终 #print axioms 的现场原文为：

- Residual.signed_residual_sum: [propext, choice, Quot.sound]
- Residual.lower_cut_removal: [propext, choice, Quot.sound]
- Residual.upper_sum_vanish: [propext, choice, Quot.sound]

无 sorry、无私 axiom、无 native_decide。该定理还覆盖 n=0，但其 n≥1 特化恰为 S(a)。
这只是单文件 kernel 结果；“成”的其余门（make lean、正式落点、PR）仍须完成。

## 正式落点与摄入收据

S(a) 的唯一内容模块落在 D5/S1/Words/Compositions/ResidualPermutationSign.lean。
Words 已在 Meta/domains.yaml 注册于 S1；同域 Library/Words 与既有 G 模块可查。
头七行采用 A5.1 的 literal `utility: none`。实际新增前目录容量为 D5 6、
Blueprint 12、theory 43（direct files）；均未挤入已满父桶。
为本题独立摄入 docs/develop/theory/RESIDUAL_PERMUTATION_SIGN.md，
`make ingest BASE=25b883dcebf4305950c779111490338639eed3bc SOURCE=docs/develop/theory/RESIDUAL_PERMUTATION_SIGN.md`
EXIT=0：residual_open_added=1、cas_objects_written=1、coarse_fallbacks=0。
atom ID 为 `296127e0b63573701297f231e6beb2f0364309aca09386ea44485b4f1b6ea59a`；
内容只陈述 S(a)，没有原猜想或 Φ(n) 桥。首次 show-atom 错把 source 前缀加入 ID，
EXIT=2（absent from digestion ledger）；读取 loader 的 ID 规则后改用纯内容 hash。

## 正式构建批次 1

正式模块 `make lean` EXIT=0，墙钟 49.066614792 秒（本工作树、Apple ARM 宿主、
未设置 LAKE_JOBS，已有私有 warm 缓存）；构建日志 `attempt-1/make-lean.log`。
LEAN_CACHE：status=present、method=none、donor=null、stamp_miss=null、
mathlib_missing_olean_files=0、mathlib_olean_state=warm、project_olean_state=warm、
archive_status=not_attempted、archive_skip_reason=project olean state is warm；
pin_sha256=sha256:6c4c682ffba051b5744fe7a75ccc99d7f3b20227b3b026f392f3315be0adaa4e。
`make show-atom` 以纯 hash 重跑 EXIT=0，原文与规范化文本均与 S(a) 一致。
前面的“尚未运行/未证明”是各批次当时的历史记录，本节更新当前验证状态。

## 正式核验批次 2：声明报告与展开后的常量边

`make lean-report` EXIT=0，62.092479959 秒；raw report SHA-256 为
8ead6154f9db782a552e2727b4d9314edf838ac5828cb27941d99b2f41951fa0。
`DependencyAudit.lean` 对正式模块的环境常量读取 theorem/definition 的 proof body，
以 `getUsedConstants` 打印模块内部边，并打印三条公开定理的公理闭包；
EXIT=0，8.518048 秒。实际每条公理闭包均为 propext、Classical.choice、Quot.sound。
其代码与全部输出保存在 attempt；此读取不把依赖出现自动判作语义活用。
现场边确认 signed_residual_sum → rowSum_eq_upper → lower_cut_removal，
及 signed_residual_sum → upper_sum_vanish → upper_fixed_prefix / exists_min_move。
lower_cut_removal → upper_swap_of_short / swap_sum_zero。
语义活路径将在最终逐声明账中结合证明项的用途核对。

## 发射诊断批次

首轮 `make emit` EXIT=2，16.608403125 秒。具名错误是报告 frontmatter 的
`strata_touched: [S1]` 不被本仓专用 note parser 接受（要求 block list），
随后九个 Scribe 来源引用连带报 dangling-literature-reference。
已改为分行列表 `strata_touched` 加 `- S1`；数学源码及声明未改。
这不是 S(a) 的证明失败；不隐去门失败，修正后重跑同一发射门。

第二轮发射 EXIT=2，14.475987958 秒：列表元素 `S1` 不是 canonical GID。
停止猜字段值，读取 LibraryNoteCatalog.cs:218–226 与
DescribeRepositoryValidator.cs:85–98：元素由 GidRef.Create 解析并核对目标。
按现有 oeis2026a392707 实例改为完整
D5/S1/Words/Compositions/ResidualPermutationSign；这是同一元数据错误的精确修正，
没有换问题、改判官或放宽门。

<!-- lean-checkpoint -->
## 当前已编译源码快照

```lean
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.GroupTheory.Perm.Sign
import Mathlib.Tactic

open scoped BigOperators
open Classical
namespace Residual

def prefixSum {n : ℕ} (p : Equiv.Perm (Fin n)) (k : ℕ) : ℕ :=
  ∑ i : Fin n with i.val < k, ((p i).val + 1)

def Upper {n : ℕ} (a b : Equiv.Perm (Fin n)) : Prop :=
  ∀ k : ℕ, k ≤ n → prefixSum b k ≤ prefixSum a k

def LowerFrom {n : ℕ} (a b : Equiv.Perm (Fin n)) (r : ℕ) : Prop :=
  ∀ i : Fin n, r ≤ i.val → prefixSum a i.val < prefixSum b (i.val + 1)

def signInt {n : ℕ} (p : Equiv.Perm (Fin n)) : ℤ := (Equiv.Perm.sign p : ℤ)


@[simp] theorem prefixSum_zero {n} (p : Equiv.Perm (Fin n)) : prefixSum p 0 = 0 := by
  simp [prefixSum]

theorem prefixSum_step {n} (p : Equiv.Perm (Fin n)) (i : Fin n) :
    prefixSum p (i.val + 1) = prefixSum p i.val + (p i).val + 1 := by
  classical
  have hset : (Finset.univ.filter fun j : Fin n => j.val < i.val + 1) =
      insert i (Finset.univ.filter fun j : Fin n => j.val < i.val) := by
    ext j
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_insert]
    constructor
    · intro h
      by_cases hj : j = i
      · exact Or.inl hj
      · right; have : j.val ≠ i.val := fun e => hj (Fin.ext e); omega
    · rintro (rfl | h) <;> omega
  simp only [prefixSum, hset]
  rw [Finset.sum_insert (by simp)]
  omega

theorem prefixSum_mono {n} (p : Equiv.Perm (Fin n)) {k l : ℕ} (h : k ≤ l) :
    prefixSum p k ≤ prefixSum p l := by
  classical
  apply Finset.sum_le_sum_of_subset
  intro i hi
  simp only [Finset.mem_filter, Finset.mem_univ, true_and] at *
  omega

theorem prefixSum_pos {n} (p : Equiv.Perm (Fin n)) (i : Fin n) :
    0 < prefixSum p (i.val + 1) := by
  rw [prefixSum_step]
  omega


theorem prefixSum_swap {n} (p : Equiv.Perm (Fin n)) (u v : Fin n)
    (huv : v.val = u.val + 1) {k : ℕ} (hk : k ≠ v.val) :
    prefixSum (p * Equiv.swap u v) k = prefixSum p k := by
  classical
  have hm (i : Fin n) : (Equiv.swap u v i).val < k ↔ i.val < k := by
    by_cases hiu : i = u
    · subst i; simp only [Equiv.swap_apply_left]; omega
    · by_cases hiv : i = v
      · subst i; simp only [Equiv.swap_apply_right]; omega
      · simp [Equiv.swap_apply_of_ne_of_ne hiu hiv]
  simpa only [prefixSum, Finset.sum_filter, Equiv.Perm.mul_apply, hm] using
    (Equiv.sum_comp (Equiv.swap u v) fun i : Fin n =>
      if i.val < k then (p i).val + 1 else 0)

theorem swap_twice {n} (p : Equiv.Perm (Fin n)) (u v : Fin n) :
    (p * Equiv.swap u v) * Equiv.swap u v = p := by simp [mul_assoc]

theorem swap_ne {n} (p : Equiv.Perm (Fin n)) (u v : Fin n) (h : u ≠ v) :
    p * Equiv.swap u v ≠ p := by
  intro he
  have he' := congrArg (fun q : Equiv.Perm (Fin n) => q u) he
  simp only [Equiv.Perm.mul_apply, Equiv.swap_apply_left] at he'
  exact h (p.injective he').symm

theorem signInt_swap {n} (p : Equiv.Perm (Fin n)) (u v : Fin n) (h : u ≠ v) :
    signInt (p * Equiv.swap u v) = -signInt p := by
  simp [signInt, Equiv.Perm.sign_mul, Equiv.Perm.sign_swap h]

theorem upper_swap_of_short {n} (a b : Equiv.Perm (Fin n)) (u v : Fin n)
    (huv : v.val = u.val + 1) (hb : Upper a b)
    (hshort : prefixSum b (v.val + 1) ≤ prefixSum a v.val) :
    Upper a (b * Equiv.swap u v) := by
  intro k hk
  by_cases hkv : k = v.val
  · subst k
    have hmono := prefixSum_mono (b * Equiv.swap u v) (Nat.le_succ v.val)
    rw [prefixSum_swap b u v huv (k := v.val + 1) (by omega)] at hmono
    exact hmono.trans hshort
  · rw [prefixSum_swap b u v huv hkv]
    exact hb k hk


theorem swap_sum_zero {n} (s : Finset (Equiv.Perm (Fin n))) (u v : Fin n)
    (hne : u ≠ v) (hmem : ∀ b ∈ s, b * Equiv.swap u v ∈ s) :
    ∑ b ∈ s, signInt b = 0 := by
  classical
  apply Finset.sum_involution (fun b _ => b * Equiv.swap u v)
  · intro b hb; rw [signInt_swap b u v hne]; omega
  · intro b hb hsign; exact swap_ne b u v hne
  · exact hmem
  · intro b hb; exact swap_twice b u v

noncomputable def rowSum {n} (a : Equiv.Perm (Fin n)) (r : ℕ) : ℤ := by
  classical
  exact ∑ b : Equiv.Perm (Fin n) with Upper a b ∧ LowerFrom a b r, signInt b

theorem lower_cut_removal {n} (a : Equiv.Perm (Fin n)) (r : ℕ) :
    rowSum a r = rowSum a (r + 1) := by
  classical
  let s := Finset.univ.filter fun b : Equiv.Perm (Fin n) =>
    Upper a b ∧ LowerFrom a b (r + 1)
  let test := fun b : Equiv.Perm (Fin n) =>
    ∀ i : Fin n, i.val = r → prefixSum a r < prefixSum b (r + 1)
  have hgood : s.filter test = Finset.univ.filter
      (fun b : Equiv.Perm (Fin n) => Upper a b ∧ LowerFrom a b r) := by
    apply Finset.ext
    intro b
    dsimp only [s]
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    constructor
    · rintro ⟨⟨hu, hl⟩, ht⟩
      refine ⟨hu, fun i hi => ?_⟩
      by_cases he : i.val = r
      · simpa [he] using ht i he
      · exact hl i (by omega)
    · rintro ⟨hu, hl⟩
      exact ⟨⟨hu, fun i hi => hl i (by omega)⟩, fun i hi => by
        simpa [hi] using hl i (by omega)⟩
  have hbad : ∑ b ∈ s.filter (fun b => ¬test b), signInt b = 0 := by
    by_cases hr : r < n
    · by_cases hr0 : r = 0
      · subst r
        apply Finset.sum_eq_zero
        intro b hb
        have ht := (Finset.mem_filter.mp hb).2
        exact (ht (by intro i hi; simpa [hi] using prefixSum_pos b i)).elim
      · let u : Fin n := ⟨r - 1, by omega⟩
        let v : Fin n := ⟨r, hr⟩
        have huv : v.val = u.val + 1 := by dsimp [u, v]; omega
        apply swap_sum_zero _ u v (by intro he; have := congrArg Fin.val he; dsimp [u,v] at this; omega)
        intro b hb
        obtain ⟨hb, ht⟩ := Finset.mem_filter.mp hb
        obtain ⟨hu, hl⟩ := (Finset.mem_filter.mp hb).2
        have hshort : prefixSum b (r + 1) ≤ prefixSum a r := by
          by_contra h
          exact ht (by intro i hi; omega)
        have hshort' : prefixSum (b * Equiv.swap u v) (r + 1) ≤ prefixSum a r := by
          rw [prefixSum_swap b u v huv (by dsimp [v]; omega)]
          exact hshort
        apply Finset.mem_filter.mpr
        refine ⟨?_, ?_⟩
        · apply Finset.mem_filter.mpr
          refine ⟨Finset.mem_univ _, upper_swap_of_short a b u v huv hu hshort, ?_⟩
          intro i hi
          rw [prefixSum_swap b u v huv (by dsimp [v]; omega)]
          exact hl i hi
        · intro h
          have := h v rfl
          omega
    · apply Finset.sum_eq_zero
      intro b hb
      have ht := (Finset.mem_filter.mp hb).2
      exact (ht (by intro i hi; have := i.isLt; omega)).elim
  have he := Finset.sum_filter_add_sum_filter_not s test signInt
  rw [hgood, hbad, add_zero] at he
  exact he

theorem rowSum_eq_upper {n} (a : Equiv.Perm (Fin n)) :
    rowSum a 0 = ∑ b : Equiv.Perm (Fin n) with Upper a b, signInt b := by
  classical
  have hr : ∀ r, rowSum a 0 = rowSum a r := by
    intro r
    induction r with
    | zero => rfl
    | succ r ih => exact ih.trans (lower_cut_removal a r)
  rw [hr n]
  simp [rowSum, LowerFrom, show ∀ i : Fin n, ¬n ≤ i.val from fun i => by omega]


theorem value_ge_of_fixed {n} (p : Equiv.Perm (Fin n)) {r : ℕ}
    (hf : ∀ i : Fin n, i.val < r → p i = i) (i : Fin n) (hi : r ≤ i.val) :
    r ≤ (p i).val := by
  by_contra h
  have hp := hf (p i) (by omega)
  have he : p i = i := p.injective hp
  rw [he] at h
  omega

theorem prefixSum_congr {n} (a b : Equiv.Perm (Fin n)) (k : ℕ)
    (h : ∀ i : Fin n, i.val < k → a i = b i) : prefixSum a k = prefixSum b k := by
  apply Finset.sum_congr rfl
  intro i hi
  rw [h i (Finset.mem_filter.mp hi).2]

theorem upper_fixed_prefix {n} (a b : Equiv.Perm (Fin n)) (hu : Upper a b)
    {r : ℕ} (ha : ∀ i : Fin n, i.val < r → a i = i) :
    ∀ i : Fin n, i.val < r → b i = i := by
  have aux : ∀ k, k ≤ r → ∀ i : Fin n, i.val < k → b i = i := by
    intro k
    induction k with
    | zero => intro hk i hi; omega
    | succ k ih =>
      intro hk i hi
      have hf := ih (by omega)
      by_cases hik : i.val < k
      · exact hf i hik
      · have hik : i.val = k := by omega
        have hai := ha i (by omega)
        have hp : prefixSum b i.val = prefixSum a i.val := by
          apply prefixSum_congr
          intro j hj
          rw [hf j (by omega), ha j (by omega)]
        have hs := hu (i.val + 1) (by omega)
        rw [prefixSum_step, prefixSum_step, hp, hai] at hs
        have hg := value_ge_of_fixed b hf i (by omega)
        exact Fin.ext (by omega)
  exact aux r le_rfl

theorem upper_identity {n} (b : Equiv.Perm (Fin n)) : Upper 1 b ↔ b = 1 := by
  constructor
  · intro hu
    apply Equiv.ext
    intro i
    exact upper_fixed_prefix 1 b hu (r := n) (by simp) i i.isLt
  · rintro rfl; intro k hk; exact le_rfl

theorem exists_min_move {n} (a : Equiv.Perm (Fin n)) (ha : a ≠ 1) :
    ∃ k j : Fin n, k.val < j.val ∧ a j = k ∧
      ∀ i : Fin n, i.val < k.val → a i = i := by
  let s := Finset.univ.filter fun i : Fin n => a i ≠ i
  have hs : s.Nonempty := by
    by_contra h
    apply ha
    apply Equiv.ext
    intro i
    by_contra hi
    exact h ⟨i, Finset.mem_filter.mpr ⟨Finset.mem_univ _, by simpa using hi⟩⟩
  let k := s.min' hs
  have hk : a k ≠ k := (Finset.mem_filter.mp (Finset.min'_mem s hs)).2
  have hf : ∀ i : Fin n, i.val < k.val → a i = i := by
    intro i hi
    by_contra hai
    have hki := Finset.min'_le s i (by simp [s, hai])
    have : k.val ≤ i.val := hki
    omega
  let j := a.symm k
  have hj : a j = k := a.apply_symm_apply k
  have hkj : k.val < j.val := by
    by_contra h
    by_cases he : j = k
    · rw [he] at hj
      exact hk hj
    · have hlt : j.val < k.val := by
        have : j.val ≠ k.val := fun e => he (Fin.ext e)
        omega
      have := hf j hlt
      have : j = k := this.symm.trans hj
      exact he this
  exact ⟨k, j, hkj, hj, hf⟩

theorem upper_sum_vanish {n} (a : Equiv.Perm (Fin n)) (ha : a ≠ 1) :
    (∑ b : Equiv.Perm (Fin n) with Upper a b, signInt b) = 0 := by
  obtain ⟨k, v, hkv, hav, hfix⟩ := exists_min_move a ha
  let u : Fin n := ⟨v.val - 1, by omega⟩
  have huv : v.val = u.val + 1 := by dsimp [u]; omega
  apply swap_sum_zero _ u v (by intro he; have := congrArg Fin.val he; dsimp [u] at this; omega)
  intro b hb
  have hu := (Finset.mem_filter.mp hb).2
  apply Finset.mem_filter.mpr
  refine ⟨Finset.mem_univ _, ?_⟩
  intro l hl
  by_cases he : l = v.val
  · subst l
    have hfb := upper_fixed_prefix a b hu hfix
    have hbu := value_ge_of_fixed b hfb u (by dsimp [u]; omega)
    have hbv := hu (v.val + 1) (by omega)
    rw [prefixSum_step a v, hav] at hbv
    have hstep := prefixSum_step (b * Equiv.swap u v) v
    rw [prefixSum_swap b u v huv (k := v.val + 1) (by omega)] at hstep
    simp only [Equiv.Perm.mul_apply, Equiv.swap_apply_right] at hstep
    omega
  · rw [prefixSum_swap b u v huv he]
    exact hu l hl


/-- The one-based values are `a i + 1`; prefix arguments are lengths. -/
def InResidual {n : ℕ} (a b : Equiv.Perm (Fin n)) : Prop :=
  ∀ i : Fin n, prefixSum a i.val < prefixSum b (i.val + 1) ∧
    prefixSum b (i.val + 1) ≤ prefixSum a (i.val + 1)

theorem inResidual_iff {n} (a b : Equiv.Perm (Fin n)) :
    InResidual a b ↔ Upper a b ∧ LowerFrom a b 0 := by
  constructor
  · intro h
    refine ⟨?_, fun i _ => (h i).1⟩
    intro k hk
    by_cases hk0 : k = 0
    · simp [hk0]
    · let i : Fin n := ⟨k - 1, by omega⟩
      have hi : i.val + 1 = k := by dsimp [i]; omega
      simpa only [hi] using (h i).2
  · rintro ⟨hu, hl⟩ i
    exact ⟨hl i (by omega), hu (i.val + 1) (by omega)⟩

/-- S(a): the signed residual sum is one for the identity and zero otherwise. -/
theorem signed_residual_sum {n : ℕ} (a : Equiv.Perm (Fin n)) :
    (∑ b : Equiv.Perm (Fin n) with InResidual a b, signInt b) =
      if a = 1 then 1 else 0 := by
  have hrow : (∑ b : Equiv.Perm (Fin n) with InResidual a b, signInt b) =
      rowSum a 0 := by simp only [rowSum, inResidual_iff]
  rw [hrow, rowSum_eq_upper]
  by_cases ha : a = 1
  · subst a
    rw [if_pos rfl, Finset.sum_eq_single 1]
    · simp [signInt]
    · intro b hb hne
      exact (hne ((upper_identity b).mp (Finset.mem_filter.mp hb).2)).elim
    · intro h
      exact (h (Finset.mem_filter.mpr ⟨Finset.mem_univ _, fun k hk => le_rfl⟩)).elim
  · rw [if_neg ha]
    exact upper_sum_vanish a ha

#print axioms signed_residual_sum
#print axioms lower_cut_removal
#print axioms upper_sum_vanish

end Residual
```
