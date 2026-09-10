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

## 检索第 3 批与缓存

- make lean-cache-ensure EXIT=0：status=seeded, donor=/Users/chronoai/trureturing,
  method=clonefile, clonefile_attempts=1, stamp_miss=null, project_olean_state=warm,
  mathlib_olean_state=warm, archive_status=not_attempted。
- 实测 lean-toolchain=leanprover/lean4:v4.33.0；Mathlib HEAD=db584cd6d46c92f209a44c0f1c829460d327499d。
- Mathlib Combinatorics/NumberTheory 搜 capable|constant.?block|equal.?sum|383093|323774 无命中。
  已读 Nat.Partition 的结构、正性/重量/有穷性、计数编码 API，以及 Finset.lcm 的
  lcm_dvd_iff、dvd_lcm、lcm_ne_zero_iff 等签名；这些是可直接复用的基础设施，未见目标桥。
- 扩大 D5 公开面检查：FirstSumsPartitionCharacterization 全文，
  TrimmedAlternatingPartitions 两公开定理及定义，PowerfulDivisorTransform 全部公开面。
  前两者分别是相邻和重建及排序尾严格性；后者是 powerful 指示函数的卷积，
  其一般参数 f 不提供本题两种对象的计数等价。未发现可消费的规范化声明。
- 已打开 OEIS A383093/internal（HTTP 成功，13917 字节）；外部文献核查继续。
- spec A5.1 确认 utility: none 文法与七行头位置；Meta/domains.yaml 已读。

## 检索第 4 批

- OEIS 主条目 revision 13 (2025-05-04)：formula 仍为 Conjecture，
  Sum_{d|n} a(d)=A323774(n)。全部 42 个直接 xref 已下载成功，原 HTML 与提取字段在 runner attempt。
- 已逐字段读 A323774、A381995、A381993、A383014、A383309、A382203、A279789。
  A323774 给系统计数二项式和，A381995 按整数编码纤维求和，未给本题规范化双射。
  A382203 当前名称是 distinct sums；主条目一条 xref 把 equal 类型指到它，实为 A382204，
  此为来源交叉引用差异，不影响目标定义，未静默当成同一对象。
- gh search code 'A383093 language:Lean' 返回 []；'"constant blocks" language:Lean'
  返回两个 Kakeya Plank/Refinement 路径（非分拆库），尚未打开，ASSUMED-UNVERIFIED。
- arXiv A383093 检索页成功下载；下一批读其结果及全部 xref 的相关命中。
- 精确可复用 Mathlib 命中：Multiset.exists_smul_of_dvd_count，
  ∀a∈s, k∣count a s → ∃u, s=k•u。已读完整证明与签名；本题将直接应用，禁止重证。

## 检索第 5 批与 Lean 片段 1

- 42 xref 的全文提取字段检索 lcm|least common|normaliz|bijection|bijective|383093|moebius|möbius|mobius|common sum。
  逐条读相关命中并完整补读 A382204、A383096、A383098、A383100、A383110、A047966。
  A047966 是 uniform partitions 到 distinct partitions 的另一除数变换；未给本题 lcm 桥。
  arXiv 搜 A383093 明确 produced no results。未打开的 xref 外链、未逐字段细读的普通族条目
  仍标 ASSUMED-UNVERIFIED；不主张全球搜索穷尽。dominating_theorem_search=not-found-in-searched-scope。
- canonical route EXIT=0 返回 D5/S1/Words/Compositions/ConstantEqualSumDivisorIdentity.lean，S1/G。
  创建前该 Lean 桶 7 文件，Blueprint 桶 14 文件；utility: none（无界组合证明）。
- 热树 /tmp/A383093.lean 首试失败于缺 NormalizedGCDMonoid ℕ 实例与 nlinarith import。
  加 Mathlib.Algebra.GCDMonoid.Nat 与 tactics 后 EXIT=0，无 sorry/私 axiom。
- 已证私有 normalize：正整数多重集 m 在 D>0 可行，则存在 t>0、u，
  m=t•u、D=t*lcm(u)、u capable；使用 Mathlib.exists_smul_of_dvd_count，未重证它。
  lcm_smul/canonical/admits_smul 同批通过。这是无界构造，非有限枚举进展。
- 定义尚在组装：下一步为块多重集编码证明、重量与计数双射。主目标尚未证明。

## Lean 片段 2：重量与计数双射

- 当前模块热树 lake env lean EXIT=0。已构造从除数 d 上的 capable 分拆到
  (n/d) 倍重数、公共和 (n/d)*L 的系统编码的映射，并证明 injective/surjective。
- injective 使用支撑 lcm 不变先恢复缩放因子，再由重量恢复 d，最后取消非零 nsmul。
  surjective 使用 normalize 及 t*u.sum=n；没有把目标除数和写入计数定义。
- 私有 encoded_divisor_sum 已证明编码系统的 Nat.card 等于除数和；
  下一步将右侧改接独立的公共和/块值多重集定义，证明展开编码等价。
- 编译修复：omega 不处理交换次序的乘积，改用 mul_comm；依赖 subtype 的 sum 改显式
  Finset.sum_subtype；pair projection 的 rewrite 改精确使用已有等式。无数学目标削弱。
