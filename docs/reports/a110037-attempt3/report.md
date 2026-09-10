# A110037 attempt 3 — implementation record

产地：lean4 skill；Codex 主 worker 单点实施与自查，独立评审席 0。
本轮用户 brief 是预登记与本地证明授权；attempt 2 的结果按原提交保留。

## 预登记

目标是具体有限集合计数的 SloaneSellersParity，继而实例化已验的
signed_diff_of_parity，得到 n≥2 的无条件 signed_nonsquashing_diff。
成功须含 kernel 证明、make lean EXIT=0、无 sorry/私 axiom/native_decide、PR。
反例须在 n≥2 给 kernel 见证；blocked 须有实际证明尝试和精确剩余 goal。

拟议新增见证：按最大部件分解直接定义的有限集合，证明 B 的累计和递推。
最大部件等于尾部和允许；仅尾部为同值单例时违反互异而排除。
之后由递推推八个奇偶子句，复用 attempt 2 的强归纳和差分桥。
该无界组合双射是一般数学内容，utility 拟为 none；准入拟为 escape-witness。
不新建理论卷、不 ingest、不造 atom；需要冻结时走 deposit-uncovered
（canonical ledger-align --add）。不修改冻结模块。

## 已有资产与检索收据

起点 dbc4935545b40832ed65edef048525d30d8a3dce，分支 lane/math/a110037，
初始树干净；沿用基线 82938786158c163b50350c14c948e63df61107a8。
完整分段阅读 CLAUDE.md（截断段已补读）、agents/CONTEXT.md、lean4 SKILL.md。
已读 attempt 2 的完整 Bridge.lean、report.md 和 Sloane–Sellers Library note。
八项结构与条件桥目前位于 docs/reports/a110037-attempt2/Bridge.lean，未冻结。

继承已完成的有序检索：D5、钉版 mathlib v4.33.0、第三方 GitHub Lean 检索
均未命中可直接引用的 B 奇偶定理；精确命令和公共面阅读收据见 attempt 2 报告。
本轮没有将该搜索重做或把“无同名结果”当数学失败。
本轮 rg 定位 SloaneSellersParity/signed_diff_of_parity，只命中 attempt 2 工件。
Mathlib Finset.Card 的 card_bij/card_bij' 以及 Max/Sigma API 已粗筛，
将直接使用其一般基数工具，不重证库有定理。

本轮授权明确撤销旧 brief 的“不重证公开 B 奇偶定理”禁令解释。
旧报告的授权阻塞理由只描述 attempt 2，当下不再有效；数学条件结果仍有效。

## 构建收据

make lean-cache-ensure EXIT=0：status=present, method=none, stamp_miss=null,
project_olean_state=warm, mathlib_olean_state=warm, clonefile_attempts=0,
mathlib_missing_olean_files=0。
pin_sha256=sha256:6c4c682ffba051b5744fe7a75ccc99d7f3b20227b3b026f392f3315be0adaa4e。
后续片段可用热树增量检查；正式门序仍用 make。

## 未主张

当前尚未证明八个具体计数子句或无条件主目标，尚未冻结、尚未开 PR。
没有主张有限核对是研究进展、全球检索完备、首创性或多模型共识。
未在本轮打开的外部页面为 ASSUMED-UNVERIFIED；先前阅读收据按历史引用。
公开新增 theorem 当前为 0；逐声明账目随实际证明补入。

## 最大部件分解：第一单元已验

已阅读历史 PDF 提取 pages 6–8 的原文；Theorem 2 (14) 正是拟议累计和双射，
等号边界仅排除尾部单例。Corollary 4 的 32 进展式将直接由递推证明，含 m=0。
Mathlib card_bij、card_biUnion、max'_mem、le_max'、sum_erase_add 公共接口已读。

Counting.lean 的 mem_parts、subset_parts、insert_parts、card_cumulative、
erase_max_parts 已经热树 kernel 检查，EXIT=0。后者证明任意 n>0 的原分拆可
删除最大部件，得到累计族 n/2 中尾部，再插入 n−尾部和重建原分拆。
日志：attempt-3/counting-helpers.log；#print axioms erase_max_parts 仅标准三条。
首两次编译错误是 id 的隐式函数推断、rfl 消去变量名与 sum_erase_add 的显式
参数问题，均已修复；未把错误恢复中的 sorryAx 当通过项。
此单元是无界组合构造，非有限核对；基数双射和原目标尚未闭合。
当前上述辅助 theorem 均 private，direct_frozen_dependencies=[]，不单独申请冻结。

## 递推到八项奇偶：第二单元已验

Parity.lean 已从 B(2)=1、正 m 的奇项增一和正偶项差分递推证明所有七条
偶指标进展式。新的核心归纳结论是 B(4m+2)%2=(m+1)%2；继而得
B(4m)%2=(m+B(2m))%2 (m>0)。由它们直接推出 8、16、32 进展式，
两个 32 进展式均包含 m=0。第八项 odd 是奇项增一等式取模。
这是真正尝试并完成递推之后的奇偶证明，尚待具体计数的递推双射闭合。
热树 EXIT=0；parity-checked.log 的公理输出仅 propext/Quot.sound。
首次错误为 proof-only section 参数未 include 和 0<m 的词法解析，已修复。
当前这些 theorem 均 private，冻结依赖为空，不单独申请条件结果冻结。

## 具体计数递推：第三单元已验

Counting.lean 的基数双射现已全闭合，热树 EXIT=0。
日志 counting-recurrence-checked.log：count_odd 与 count_even_step 的 axiom
闭包都仅 propext/Classical.choice/Quot.sound。

count_odd：任意 m>0，B(2m+1)=B(2m)+1。
count_even_step：任意 m>0，B(2(m+1))=B(2m)+B(m+1)。
具体计数始终是原 powerset/filter 定义，没有使用递推重定义 B。
odd_sum 与 even_sum 由 card_extension 活用插入/删除最大部件的双射得到；
even_exception 证明被排除族恰为单例尾部 {m}，并保留所有其余等号边界。
这补齐了 Parity.lean 的所有数学前提；下一步移入正式 D5 模块并实例化旧桥。
公开 count_odd/count_even_step 均 content，直接冻结依赖为空；共同见证
card_extension 在依赖闭包和活推导路径中，非已有投影、非递推结论的定义等价；
准入拟为 escape-witness，最终账目在正式路径的 report 产生后补身份。

## 正式落点与当场来源核对

落点容量实测：D5/S1/Recurrence 直接文件24，Blueprint 同级直接文件48。
新增两个模块需要四个镜像文件，会越 Blueprint 上限，故按同形地址新开
Recurrence/Partitions 子桶；旧地址不迁。两个模块分别为 NonsquashingCounting
与 NonsquashingPaperfold。正式代码复用 attempt 2 的证明项，未重新推导旧桥。

重新 GET A110037/internal 与 A073089/internal 均 EXIT=0，全部 comment/formula/
name/offset 字段已读。前者仍记录 Calderón 2025-08-19 的 n≥2 猜想，后者八分支
与原独立定义一致。新 note 的 Verified locator 逐字包含 frontmatter URL。
Library/Words 新 note 前直接文件31，不越48。未打开其他外链，ASSUMED-UNVERIFIED。

首次 make lean EXIT=2 / 34.967秒，仅新增主模块有一个多余 rfl（此前 rw 已闭合）;
主目标已产生标准三公理证明项，但不以错误退出报成功。移桶后格式化误拆 :=，
第二次 EXIT=2 / 28.519秒；已恢复词法，未更改任何数学陈述或证明路线。

## 无条件主目标已通过正式构建

make lean EXIT=0 / 18.032594秒 / 12842 jobs，macOS ARM 热树。
精确收据 make-lean-final-receipt.json，完整日志 make-lean-final.log。
LEAN_CACHE 仍为 present/none，stamp_miss=null，两层 warm，missing_olean=0。

sloane_sellers_parity 已无条件证明八个具体计数输入；signed_nonsquashing_diff
直接实例化原 signed_diff_of_parity，签名与用户 n≥2 目标一致。
两条 #print axioms 均仅 propext/Classical.choice/Quot.sound；新增四条
elaborated 依赖断言核出主定理→奇偶事实/旧条件桥，以及奇偶事实→两条计数递推。
printed_odd_rule_false 保留为 private；0/1 totalization 和 odd m>0 域不变。

本轮临时 Counting/Parity 报告代码已迁入 D5 正式模块（历史提交保留），
不保留第二份活证明真源。attempt 2 的 Bridge.lean 与报告原样保留。
尚待 canonical report、Scribe、冻结和 PR；不提前报本轮“成”。

Canonical make lean-report EXIT=0 / 78.220363秒；delta added=2/recheck=2，
raw report SHA256=a2d0bb7aa5f236535f2261ff8f52e3f4ede0ebb844a2c48a34fcf084aed2ce3b。
这次报告包含正式 D5 的两模块，已不再仅为 report 目录片段检查。
