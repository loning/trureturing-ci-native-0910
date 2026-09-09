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
