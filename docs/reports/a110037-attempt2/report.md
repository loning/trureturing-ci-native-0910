# A110037 attempt 2 — implementation record

产地：lean4 skill；Codex 主 worker 单点实施与自查；独立评审席 0。
Runner 的后续独立评审不计入本席。本次用户 brief 为预登记输入。

## 预登记与边界

目标仍为 n≥2 的 signed_nonsquashing_diff。第一档：OEIS 的已发表猜想。
拟议逃逸见证：对 r>0 的 B(4r)%2 + c(4r+1)=1，由强归纳产生，
四个差分分支活用该桥。准入拟为 escape-witness，非有限探针反例搭车。
定义域订正 n≥3 已获用户授权；attempt 1 的反例仍有效，但停止结算不沿用。
仅原目标反例、强归纳桥或差分分支真实不闭合可作数学停止理由。
不建理论卷，不 ingest，不造 atom；无 atom 的冻结入口为 deposit-uncovered
（内部 ledger-align --add）。不使用 sorry、私 axiom 或 native_decide。

## 第一批检索收据

- 已完整分段阅读 CLAUDE.md，截断处补读；已读 agents/CONTEXT.md 和 lean4 skill。
- 初始 HEAD=e9257083ef，基线沿用 82938786158c163b50350c14c948e63df61107a8；
  分支 lane/math/a110037，工作树干净。attempt 1 的报告、BoundaryProbe.lean、
  Sloane–Sellers PDF 提取 p6–8 均已打开阅读。
- D5/Library/Blueprint：rg 搜索 nonsquash、Sloane–Sellers、A110037、A073089、
  paperfold，仅命中 Library/Words/oeis2026triage0910.md；它是分诊散文，无 Lean 定理。
- 钉版 mathlib 全树：rg 搜索 non.?squash、paperfold、两个 A 号，零命中。
  attempt 1 已读 Partition.Basic/Glaisher/GenFun 公共面，报告可读且未重证。
- 本轮逐条读 ConvolutionRecurrenceOddPowersOfTwo 的公开面；convolution_pairing
  对任意 f:ℕ→ZMod 2 成立，但尚无本题分拆计数的卷积表示，不因此伪称可以引用。
- GitHub code search：`"non-squashing" language:Lean`、`"paperfold" language:Lean`，
  两次成功返回 []。D5/tools/lean-inspector/docs/reports 的 FromLiterature 三种拼写无命中。
- 已重新 GET OEIS 两个 internal 页面，HTTP 请求均 EXIT=0；逐字段读取在下批记录。
- 源论文 Corollary 4 (21) 收窄为 n≥3；Theorem 2 的奇项递推原有 m≥1。
  (22)/(23) 对 m≥0，(24) 的 printed m>0 将按原界使用，小边界另作私有核验。

## 待解决的前置输入

公开论文证明与已 elaborate 的 Lean 声明是不同工件。所搜范围内没有可直接 import 的
B 奇偶规则。用户同时禁止重证这部分和添加 axiom，故当前无法生成这一具体前置的
kernel 证明项；已异步请求具体 Lean 声明位置或允许移植已发表证明，继续独立完成桥。
此处不是目标反例，也不声称数学路线失败，不据此提前停止。

## 构建收据

make lean-cache-ensure EXIT=0：status=present，method=none，stamp_miss=null，
project_olean_state=warm，mathlib_olean_state=warm，clonefile_attempts=0，
mathlib_missing_olean_files=0；没有执行冷树裸 lake。
pin_sha256=sha256:6c4c682ffba051b5744fe7a75ccc99d7f3b20227b3b026f392f3315be0adaa4e。

## 未主张

尚未证明主目标、尚未冻结、尚未开 PR。未主张全球检索完备、首创性或独立多模型共识。
未打开的页面和第三方链接均 ASSUMED-UNVERIFIED；用户有限读数不冒作本席新实测。
公开 theorem 当前为 0；proof_shape/direct_frozen_dependencies/escape_witness/
admission_basis 待实际证明后逐条记录，不用提前写的标签替代核验。

## 第二批来源读数

OEIS A110037/internal 完整条目已读：revision 9，2025-08-24；目标仍标 Conjecture，
归属 Alan Michael Gómez Calderón，2025-08-19。A073089/internal 完整条目已读：
revision 47，2021-03-13，独立八分支与用户一致。未打开其余链接，ASSUMED-UNVERIFIED。
重新 GET arXiv abstract 成功，原页 metadata 核出题名 On Non-Squashing Partitions、
作者 N. J. A. Sloane / James A. Sellers、日期 2003-12-22、DOI。
Library/Words 落点创建前 find -type f | wc -l=30；新增 note 不触容量上限。
note 的 Verified locator 正文逐字含 doi 与 url 两行，收录 n=1 kernel 见证与 n≥3 订正。
D5/S1/Recurrence 递归计数为99（含子桶），如需落 Lean 须再按直接文件数选子桶。

强归纳与 c 的分支已编码于 Bridge.lean，首轮热树检查已启动，尚未取得退出判词。

首轮检查现已完成：`lake env lean docs/reports/a110037-attempt2/Bridge.lean` EXIT=0。
c_four/c_four_two/c_eight_three/c_eight_seven/c_sixteen_five/c_sixteen_thirteen/
c_halving 均通过；complement_of_halving 由 strong_induction_on 对所有 r>0 证明。
这是无界归纳的条件数学结果，不是有限核对；仍不冒称具体 B 已满足输入。
`#print axioms complement_of_halving` 仅 propext/Classical.choice/Quot.sound。
首轮日志：attempt-2/bridge-first.log；本轮未采墙钟耗时，不填估算值。
