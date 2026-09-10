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

## 第二批检索与停止触发

- make lean-cache-ensure EXIT=0：status=seeded, donor=/Users/chronoai/trureturing,
  method=clonefile, clonefile_attempts=1, stamp_miss=null，project/mathlib 均 warm。
  Lean 4.33.0；Mathlib HEAD=db584cd6d46c92f209a44c0f1c829460d327499d。
- 钉版 Mathlib 全树 rg 上述 non-squashing / paperfold / A 号，零命中。
  已读 Partition.Basic 的公开定义/接口、Partition.Glaisher 全部公开面、
  Partition.GenFun 的全部公开签名及 genFun 定义。
  Euler/Glaisher 的 restricted/countRestricted 基于每种部件的 multiplicity；
  本题谓词比较一个部件与全部更小部件之和，不能直接代入该 API。
  partitionWithPartEquiv 只删去指定部件，不提供保持 non-squashing 的限制双射或本题递推。
- GitHub code search：'"non-squashing" language:Lean' 与 '"paperfold" language:Lean'
  均返回 []。这只是所搜范围无命中，不作全生态不存在的断言。
- 已实际打开 OEIS A110037/internal（revision 9, 2025-08-24），
  其 2025-08-19 差分式仍标 Conjecture；A073089/internal（revision 47, 2021-03-13）
  的分支与用户提供的一致。完整字段已读；未打开其余外链，ASSUMED-UNVERIFIED。
- 已实际下载并阅读 Sloane–Sellers arXiv:math/0312418 PDF p6–8，
  以及 Barry arXiv:2107.00442 PDF p2–4。二者所读段落未给目标差分证明。
  pdftotext 本机不存在（EXIT=127），已用 uv 的临时 pypdf/fonttools 环境提取并读取，
  不将工具缺失当文献缺失。
- **触发用户的 0/1 边界停止条件**：Corollary 4 (21) 原文为
  “if n is odd, b(n) ≡ b(n−1)+1”，未排除 n=1；同论文 Theorem 2 明给 b(0)=b(1)=1。
  故该原文在 n=1 变成 1≡0 (mod 2)，不成立。
  Theorem 2 的奇项递推 b(2m+1)=b(2m)+1 则明确限制 m≥1，没有这处问题。
  p7 Corollary 3 (i) 的 “adding 1” 也与 (14) 的减 1 文字相冲突，未作任何承重应用。
- **不是目标反例**：用户目标明确 n≥2。拟议桥若只用 n≥3 的奇项规则，
  此边界错误本身不否定该桥；但用户明令“任何 n=0/1 边界冲突，立即退回”，
  因而本席停止一般推导，只补 kernel 见证与交付收据，不自行解除该停止条件。

## 当前 Lean 检查

直接集合使用正整数区间的 powerset，部件天然互异；对每个 p 检查所有 q<p 的和 ≤p。
这就是按降序排列时的后缀和条件，允许等号。它不以 B 的递推或目标等式定义计数。
右侧独立照 A073089 分支递归；n=0 仅为域外总化，未用于目标或冲突证明。
BoundaryProbe.lean 已开始热树编译，先以 decide 检查 B(6)、B(10)，随后检查源句的 n=1 反例。
所有有限定理为 private，且只住报告目录，不新建 D5 模块、不冻结任何正向实例。
