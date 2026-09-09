---
bibkey: codex2026a392714residual
authors: Codex implementation worker
year: 2026
title: A392714 round two — the residual signed sum S(a)
doi: null
url: https://github.com/the-omega-institute/trureturing
claim: Investigation of the residual signed sum; no proof or refutation is yet claimed.
strata_touched: []
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

未主张检索穷尽；未主张 S(a) 已证或已反驳；未主张 A392714 原猜想已解决
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
