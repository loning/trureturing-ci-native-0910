# A390871 implementation — 2026-09-10

产地：`lean4` skill；Codex implementation worker 单点实施、自查，独立评审席为 0。
用户 brief 的分诊、枚举与对账是用户/分诊席读数，不冒作本席实测；外层 runner 的评审另计。

## 预登记

第一档，目标严格为 brief 的 `mersenne_gap_exponent_bounds`，保留自然数加法等式
`k^2+1=r^2+2^m` 及全部假设。拟议 escape_witness：差 `d=k-r` 是至少 3 的奇数，
推出 `6*k ≤ 2^m+8`；再以二进对数双侧夹逼得到指数下界，上界用平方估计。
这是用户预登记因子构造不等式的无截断表述；不是把目标换成 `4 ∣ k`。
预计唯一公开定理 proof_shape=content、admission_basis=escape-witness、
直接冻结依赖为空；最终须按 elaborate 后语义依赖核实。
utility=none：无界量化的一般整数不等式证明，非有限枚举、检查器、数值归约或认证实例。

停止判据：成 = make lean EXIT=0、无 sorry/私 axiom、PR 开出；翻 = kernel 反例；
blocked = 实际 Lean 尝试的 goal/错误、路线与最锐剩余子命题。
小 m/r=0 推导失败、找到同目标已有证明或反例则按 brief 退 note。
无 atom，使用 canonical ledger-align --add 路径，不建理论卷、不 ingest、不制造 coverage。

## 开工与检索收据

- 已分段完整读 CLAUDE.md（779 行，截断处补读）、agents/CONTEXT.md、lean4 skill。
- 指定工作树干净，分支 lane/math/a390871；固定 base=3759149d0ea0884cb8a57fb950e3caddab007a38。
- 报告目录创建前直属文件数 42；spec A5.1 已读，`utility: none` 位于 anchors/digest 之间。
- D5 字面粗筛：`rg -n -i '390871|mersenne|pow_log_le_self|lt_pow_succ_log_self' D5`。
  未命中目标；命中 dyadic counting/decay 模块、NormOneLucasDouble 的文献注释、
  UnitReversionSquareParity 的 private Mersenne helper。公开面逐条检查继续中，
  不以“题名不同”推断无可复用引理。
- 本树尚无 .lake，已首先启动 make lean-cache-ensure；未运行冷树裸 lake。
- 钉版 Mathlib、第三方 Lean/OEIS/arXiv 检索与构建尚未完成。

## 未主张

未主张已证明、已冻结、已构建或已开 PR。未主张全球不存在同目标证明或首创性。
尚未打开的外部页面为 ASSUMED-UNVERIFIED；用户的 131/162/163 口径不是本席枚举。
不主张独立模型共识，不把有限核对作为一般定理的部分进展。

## 检索第 2 批与缓存

- make lean-cache-ensure EXIT=0：status=seeded, donor=/Users/chronoai/trureturing,
  method=clonefile, clonefile_attempts=1, stamp_miss=null, project_olean_state=warm,
  mathlib_olean_state=warm, archive_status=not_attempted；无冷树裸 lake。
- 实测 lean-toolchain v4.33.0，Mathlib HEAD=db584cd6d46c92f209a44c0f1c829460d327499d。
- 已检查命中 D5 模块公开面：一般的 trace/companion doubling、dyadic summability、
  protocol leaf/cardinality/log-depth 结果均需本题未提供的对象；生成级数唯一性与奇系数结果
  亦不提供平方差估计。未发现可直接消费的 D5 前置；不是按模块题名排除。
- Mathlib 检索 Mersenne/gap/A390871，未见目标。LucasLehmer 的一般 Mersenne 公开接口
  包括严格单调、正性、奇性和模 4/8 余数；目标不等式未提供。
  直接复用 Nat.pow_log_le_self、Nat.lt_pow_succ_log_self、Nat.le_log_of_pow_le、
  Nat.log_lt_iff_lt_pow、幂单调性；源码签名已读，不重证对数夹逼。
- curl 实际成功打开 OEIS A390871/internal，完整字段读过；revision 48 (2025-12-11)。
  指数界仍明确写 I conjecture；Israel 2025-12-01 两评注分别证明模 4 观察和因子构造，
  不是指数界。作者 Ctibor O. Zizka，2025-11-22。
- A000079/A000225/A000523 internal 均成功下载，提取字段保存在 runner attempt 中。
  A000079/A000225 的合并显示被截断，故不冒称本席一跳全文细读完成；全文关键词粗筛
  A390871、square/difference、exponent bound、log+3 未见目标，已读 A000523 全文。
  用户提供的一跳全文结论仍标用户核验；条目外链未读，ASSUMED-UNVERIFIED。
- gh search code 'A390871 language:Lean' 返回 []；目标定理名搜索仅返回本仓分诊 note。
  arXiv search query=A390871 成功打开，页面明确 produced no results。
- dominating_theorem_search=not-found-in-searched-scope，维持第一档；不声称全球无证明。

## Lean 片段 1：差至少为 3 与线性界

- canonical route 返回 D5/S3/Arith/Mersenne/GapExponentBounds.lean、S3、generality I。
  Arith 直属 Lean 文件 33，Blueprint 直属文件 56；因镜像容量压力新建 Mersenne 子桶，
  创建前 0 文件。route 初次误用绝对路径、继而误用 null 字段，两次 rc=2；
  按 ManifestLoader/RouteEngine 现行契约改为仓内相对路径及 artifact=lean、空 selector/tag 后 rc=0。
- 热树 lake env lean 该模块最终 EXIT=0，无警告。gap_at_least_three 排除 m=0，
  差 1 由等式推出 k=2^n，差 2 由模 2 矛盾排除；由此 r+3≤k。
  six_mul_le_pow_add_eight 比较 r² 与 (k−3)²，得到 6*k≤2^m+8。
- 首次编译失败在泛用 rw [pow_succ] 意外重写 k²；改为明确基数 2、指数 n。
  模 2 simp 留下余数矛盾，接 omega 关闭。此为实际 Lean goal 修复，不是数学路线失败。
- r=0 未被额外排除；m=0 的不可解性由平方严格递增得到。主指数界下一步完成。
- 当前 Makefile 已提供 make deposit-uncovered，内部调用同一 ledger-align --add 与
  deposit 预检。后续使用此 canonical 无 atom 门，取代手工复制配方。

## Lean 片段 2：双边指数界

- 原签名 mersenne_gap_exponent_bounds 已完整闭合，热树单文件检查 EXIT=0，无警告。
- 下界：2^t≤k 与 6k≤2^m+8、k>8 推出 4*2^t<2^m；幂严格单调性给 t+3≤m。
  因此无需另开 t≥3 的边界分支，仍是预登记的因子下界路线。
- 上界：k<2^(t+1) 给 (k+1)²≤(2^(t+1))²，再由 k>8 得
  k²+1<2^(2t+2)；原等式给 2^m≤k²+1，推出 m≤2t+1。
- 第一次主定理编译报 MulLeftStrictMono Nat：误选无零乘法单调性接口；
  查询源码后改为 Nat.pow_lt_pow_iff_right，未增公理、未改目标。
- hm:m≤k 原样保留，证明 clear hm：这些估计本身不需要该搜索限制。
  尚未执行全项目 make lean、语义依赖审计或冻结。

## 完整构建与叙事工件

- make lean EXIT=0，45.444 秒，12830 jobs；macOS ARM、donor 热树，非 CI 时长。
  完整日志为 runner attempt-1/make-lean.log。新模块成功构建；其它已有模块的风格警告不属本题。
- 上节“无警告”更正：最后一条单文件输出实际仍有 hm 未显式引用警告；clear hm 不算显式引用。
  为保留用户要求的逐字签名，在该定理局部关闭 unusedVariables 风格提示，未改任何数学门。
  随后上述 make lean 已验证这一最终源码；不添加无用前置或死项来掩盖未使用假设。
- Library/Arith 创建前已有 48 文件；Library/Words 为 27，故来源 note 置于 Words，新增后 28。
  zizka2025a390871 符合 bibkey 文法；Verified locator 正文含 canonical URL 与 doi:null 说明。
- Scribe 使用 FromAuthor 投影原签名的完整公式；FromRepo 标记本仓推导并引用 OEIS 猜想来源。
  未放治理判形词汇；未手改 Blueprint md。make lean-report 进行中，尚未 emit/deposit。

## Kernel 回声与逐条判形

- runner attempt-1/KernelAudit.lean 检查 EXIT=0；private statement_echo 精确复述用户目标，
  private positive_control 以 kernel decide 核对 (12,9,6) 的等式与下界等号；不单独冻结有限实例。
- #print axioms mersenne_gap_exponent_bounds 仅 [propext, Classical.choice, Quot.sound]。
  Lean ConstantInfo.type/value 的 getUsedConstants 遍历得到 3286 个传递常量，
  D5 常量全部在本模块，明确命中 gap_at_least_three 和 six_mul_le_pow_add_eight。
  这是 Lean 语义 API 读数，不把文本匹配当依赖证明。

唯一公开定理：D5/S3/Arith/Mersenne/GapExponentBounds.mersenne_gap_exponent_bounds。
proof_shape: content；direct_frozen_dependencies: []（无 GID/statement_id 对）；
escape_witness: six_mul_le_pow_add_eight（经 gap_at_least_three）；
admission_basis: escape-witness。

CLAUDE.md 3.2 四项对照：

1. 依赖闭包内：上列 elaborate 后语义遍历明确命中两条 private theorem。
2. 非投影可得：Mathlib 的对数夹逼并不提供该平方差的线性下界。
   本地排除差 1/2，再比较 r² 和 (k−3)²，首次建立 6k≤2^m+8；
   D5 冻结前置集合为空，不是某个已有指数界的实例化或投影。
3. 非定义等价：该见证是不含 log 的线性 k/2^m 关系；主结论是两个整指数界，
   两者不是定义展开、别名或重述。
4. 活推导路径：主定理下界分支以该线性界与 2^t≤k 推导 4*2^t<2^m，
   再用幂单调性。该 hlinear 由 omega 实际消费，未塞入被投影丢弃的合取分量；
   去掉它，对数夹逼与平方和上界无法仅经绑定操作提供指数下界。
   活路径判断为证明语义自查，不声称闭包遍历自动判定所有内容性质。

全部声明均为无界符号推导，computational_content.kind=none；
basis/consumer/instance/premises/result/claim 为 not-applicable(kind=none)。
question_answered：用户预登记的 A390871 非 2 幂项指数双边界是否成立。
未使用 sorry、自加 axiom 或 native_decide。

## Canonical report 与开 PR 前复查

- make lean-report EXIT=0，68.329 秒；delta changed=0, added=2, removed=0, recheck=2。
  这是 donor 报告到当前树的差量，不声称本席新增两个模块。
- 报告 SHA256=d77a4a8beadbd4005913fa3c86538fb9f9d1ddee4430cfdad3082ffcc54dff24。
  模块摘录保存于 runner attempt-1/module-report.json；included 声明三个，均仅标准三公理。
- 主定理 statement_id=sha256:e2f477804813efa1986b77545dfce253c28fa512326db58dbc3c97effb5e37d8。
- gap_at_least_three statement_id=sha256:ee69cafdd50c1d15563270ad0c89556b1063e1be62a7a45d82640a283c6e9271。
- six_mul_le_pow_add_eight statement_id=sha256:918cab237d7f4e9d24c44c11e977d63cdd79186aa5d56b96f6d22816fe73c5de。
- git fetch origin dev 成功；开 PR 前再次对 origin/dev 的 D5/Blueprint 搜
  A390871、目标名、Mersenne gap/exponent，未命中；无重复目标。

## Scribe 发射

- make emit EXIT=0，54.783 秒；仅新增本题 1 个 Blueprint 投影。
  已读输出公式，量词、非 2 幂条件、所有界与加法等式均忠实于 Lean 原签名。
- git merge-tree --write-tree HEAD origin/dev EXIT=0，输出树
  64a32609f7cca379183a75b03986b77c3705422d；不需追平无冲突的移动基线。
- 当前 scribe-content-checks 的 projection 子项仅在相关 projection/producer delta 时唤醒；
  本题无此 delta，故另显式执行 projections --check，随后运行用户要求的完整脚本。
