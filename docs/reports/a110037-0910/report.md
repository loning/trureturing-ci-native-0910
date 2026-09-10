# A110037 implementation — 2026-09-10

产地：lean4 skill；Codex implementation worker 单点实施、自查，独立评审席 0。
用户与分诊席读数不冒作本席实测；外层 runner 独立评审另计。

## 预登记

第一档。目标为用户给定 signed_nonsquashing_diff，n ≥ 2；左侧是互异且每部件
大于等于后缀和的直接分拆集合，右侧使用 A073089 独立分支定义。
拟议逃逸沿用户方案：正指标 f(r)=B(4r)%2 与 c(4r+1) 互补的强归纳，
再由 B 的已发表奇偶规则连接全部差分分支。该路线尚待实测，不预报成功。
禁止私有 axiom、sorry、native_decide、以一侧定义另一侧、造理论卷/atom。
无 atom 时走 make deposit-uncovered（现行内部为 ledger-align --add）。
先核 B(6)=4、B(10)=9；有限核对只是语义回声，不作正向实例冻结或部分进展。
停止判据照用户：规定范围内反例、分支数学不闭合或 0/1 边界冲突立即退回。
成须 make lean EXIT=0、无 sorry/私 axiom、PR 开出；否则报告真实 Lean goal 与最锐残题。

## 第一批检索与环境

- 已分段完整阅读 CLAUDE.md（780 行，工具截断处补读）、agents/CONTEXT.md、lean4 skill。
- 初始树干净，分支 lane/math/a110037；固定 base=82938786158c163b50350c14c948e63df61107a8。
- 仓内 rg -n -i 'nonsquash|non.?squash|paperfold|A110037|A073089|Sellers'
  D5 Library Blueprint，仅命中 Library/Words/oeis2026triage0910.md 的用户分诊记录；
  D5 无命中。该记录不是 Lean 定理。
- 已阅读 spec A5.1 的 utility 文法，none 为独立值。
- make lean-cache-ensure 已启动，未执行冷树裸 lake；Mathlib 与联网检索待续。

## 未主张

尚未证明、冻结、构建或开 PR；不主张文献全球完备或首创性。
尚未打开的页面均 ASSUMED-UNVERIFIED；用户列出的数值不算本席复验。
