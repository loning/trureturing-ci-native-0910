# A383093 implementation — 2026-09-10

产地：lean4 skill；Codex implementation worker 单点实施、自查，独立评审席为 0。
用户 brief 的两侧枚举及分诊结果为用户/分诊席报告，不冒充本席核验。

## 预登记

第一档。目标：独立定义 capablePartitionCount 与 constantEqualSumSystemCount，
证明对所有 n > 0 的 capable_divisor_sum。两侧定义均不得含目标除数和。
拟议逃逸见证沿用用户 brief：支撑 lcm L 为规范公共块和；系统公共和 D=tL，
重数除以 t 得到重量 n/t 的 capable 分拆；乘回 t 唯一恢复系统。
该路线当前为 ASSUMED-UNVERIFIED；需证明规范化可行、唯一与重量等式。
拟议 proof_shape=content，admission_basis=escape-witness，最终按实际证明核对。
无 atom 时使用 canonical deposit-uncovered（内部 ledger-align --add），不建理论卷、不 ingest。
停止：发现公开同一规范化双射即撤派；成须 make lean EXIT=0、无 sorry/私 axiom、PR 开出；
翻须 kernel 反例；blocked 须真实 Lean 尝试、具体 goal/错误、最锐剩余子命题。

## 开工与检索第 1 批

- 完整分段读 CLAUDE.md（779 行，截断处补读）、agents/CONTEXT.md、lean4 skill。
- 工作树初始干净；branch=lane/math/a383093；固定 base=462d0a4368ba5a890c5eab619c82437baa88966f。
- 报告目录新增前直属文件数为 46。
- D5 粗筛：rg -n -i 'capable|A383093|A323774|A381995|A381993|A383014|constant.{0,30}(equal|sum)|等和常值' D5。
  未命中目标 A 号；命中 ConstantBlocksDistinctRunSums 的组合模块，另有无关领域同词。
  下一步逐条读命中组合模块的公开声明，并扩大同族词汇检索。
- 尚未进行 Mathlib/第三方/OEIS 检索与 Lean 编译，不主张 search-complete。

## 未主张

未主张已证明、反驳、冻结、构建通过或开 PR。未主张全球不存在既有证明或首创性。
未打开的外部页面为 ASSUMED-UNVERIFIED；有限枚举不作为一般定理的部分进展。

## 检索第 2 批

- 完整读 ConstantBlocksDistinctRunSums.lean 的 383 行，包括全部公开面：
  HasConstantBlocks（正值正重数、块和单射的有限集合）、runSums、HasDistinctRunSums，
  constantBlocks_iff_distinctRunSums、card_constantBlocks_eq_distinctRunSums。
  两条定理提供块和互异/极大游程和互异的对应，不给本题等和块的规范化；
  私有引理的重平衡/排序构造亦不提供 lcm 重数缩放。
- 扩检 equal.?sum|constant.?block|capable.?partition 与五个 A 号，D5 无新增相关命中。
  Library/Words/oeis2026triage0910.md 记载用户同一预登记（308 行）；不是新的证明来源。
- make lean-cache-ensure 已启动；未运行裸 lake。首次报告提交 9dbcc5a3b3 已推远端。
