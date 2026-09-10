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
