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
