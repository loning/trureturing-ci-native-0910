# A380392 implementation — 2026-09-10

产地：`lean4` skill；Codex implementation worker 单点实施、自查，独立评审席为 0。
用户转述分诊席检索与其本人 n=1..4 枚举；这些不是本席实测。外层 runner 的评审另计。

## 预登记

第一档；目标是用户 brief 中所有 n≥1 的二元矩阵全 1 东/南单调路径平均数公式。
pathCount 必须实际计数从 (0,0) 到 (n−1,n−1) 的路径，不得定义为目标右式。
拟议 escape_witness：固定路径访问恰 2n−1 个不同格，满足该路径的矩阵与其余格的任意 Bool 赋值双射。
交换有限求和后，各路径贡献 2^((n−1)^2)，路径数为 C(2n−2,n−1)。
该见证对应用户 brief 的 ASSUMED-UNVERIFIED 结构义务；最终须由 Lean 核验。
拟判主定理 proof_shape=content，admission_basis=escape-witness；预计直接冻结依赖为空，最终以语义报告核对。
utility=none：无界量化的一般组合定理，不以有限计算或认证实例为主要内容。

停止判据：成 = make lean EXIT=0、无 sorry/私 axiom、PR 开出；翻 = kernel 反例；
blocked = 写清路线、卡点与最锐剩余子命题。发现公开完整证明则按 brief 退 note。
n=0 不进入结论；禁止反向、重复或对角步，n=1 须符合单格路径。
无 atom 冻结使用既有 ledger-align --add，不建理论卷、不 ingest、不制造 coverage。

## 开工与检索收据

- 已分段完整阅读 CLAUDE.md（779 行，截断处补读）、agents/CONTEXT.md 和 Lean skill。
- 干净工作树，分支 lane/math/a380392；base=48e95107100e503cdc52aa44cc15165b65fc3213。
- lean-toolchain=leanprover/lean4:v4.33.0；manifest mathlib pin=db584cd6d46c92f209a44c0f1c829460d327499d。
- D5 粗筛：`rg -n -i 'A380392|monotone.*path|lattice.*path|path.*expect|random.*matrix' D5`。
  唯一命中 HeartsDraft 的无关历史注释；没有目标证明命中。此为字面粗筛，不冒称语义穷尽。
- 报告目录创建前直属文件 39 个，低于 48。
- 钉版 mathlib 与第三方/OEIS/arXiv：待本席检索。

## 当前未主张

尚未证明、构建、冻结、开 PR。尚未打开的外部页面全部 ASSUMED-UNVERIFIED。
不主张全球不存在公开证明，不主张发现优先权，不以用户枚举替代一般证明。
不主张独立模型共识或 CI 已绿。

## 检索第 2 批

- 本工作树尚无 .lake，首次本地 mathlib 粗筛报路径不存在，未冒称零命中。已先启动 make lean-cache-ensure。
- 改读主检出已有的 mathlib 源，git rev-parse HEAD 与指定 pin 完全相等。
  rg 搜 A380392 / monotone.?path / lattice.?path / bernoulli.*path，只命中 DyckWord 文档与无关范畴路径声明；未命中目标。
- 已实际读取 spec A5.1：utility: none 是合法完整字段，位于 anchors 与 digest 之间。
- Library/Words/oeis2026triage0910.md 第 302 行含用户分诊记录；不将其当本席外网核验。

## 外部检索与缓存结算

- OEIS search text 接口八次 HTTP 403，arXiv API HTTP 429；这些失败不计阴性证据。
  改用 curl 读取 OEIS internal，主条目与全部七个直接 xref 均 HTTP 200。
- A380392 主条目全文已读：revision 16，2025-02-22；John Tyler Rascoe 于 2025-02-21
  明写平均路径数猜想，未附证明。路径仅 South/East，相邻同排或同列，不含对角。
- 已读 A001790/A101926/A002416/A086266/A261242/A369285 的 N/C/F/H 字段；
  中心二项式分子、积分分母与其他矩阵计数均未给出目标期望的证明。
  A000984 仅下载，尚未细读；xref 的外链论文未打开，ASSUMED-UNVERIFIED。
- GitHub authenticated code search `A380392 language:Lean` total_count=0。
  不限语言搜索 total_count=358，首批 30 条只有本仓分诊记录相关，其余为哈希/字符串碰撞；
  不将未翻页的结果算作全部读完。
- arXiv 网页 search query=A380392, searchtype=all，HTTP 200，明确 produced no results。
  Bing HTTP 200 仅取页，尚未核对结果内容，不用于阴性断言。
- 在已读范围未找到完整证明（not-found-in-searched-scope），维持第一档。
- make lean-cache-ensure EXIT=0，21.071 秒；status=seeded, method=clonefile,
  donor=/Users/chronoai/trureturing, clonefile_attempts=1, stamp_miss=null,
  mathlib_olean_state=warm, project_olean_state=warm, archive_status=not_attempted。
- 已读 mathlib 的 Finset.card_powersetCard、card_inter_add_card_sdiff、card_sdiff_of_subset、
  Fintype.card_pi 等前置；将直接使用，不重证其一般陈述。
- 编码约定：对 (k+1)×(k+1) 矩阵，路径以 range(2*k) 的 k 元子集记录东步位置。
  时刻 t 的两个坐标为 range(t) 与该子集交集及差集的基数；坐标和=t，故各访问格互异。
  这是用户已预登记见证的具体实现，不改变数学目标。

## Lean 片段 1：访问格互异

- 新落点 D5/S3/Arith/Paths/MonotoneOnePaths.lean；Arith 父目录递归文件数 114，
  Blueprint 镜像父目录递归文件数 218、直属 54，故新增 Paths 子桶，首次真实工件入桶。
  新桶创建前不存在（0 文件），创建后 Lean 1 文件。
- 热树增量 lake env lean 该文件 EXIT=0；只有 unnecessarySimpa 风格警告。
- Path k 是 range(2*k) 的 k 元子集，pathCell 的两个坐标为前缀交/差集基数；
  Lean 已证坐标界、rank=t、pathCell_injective、pathCells_card=2*k+1。
  首次检查因 sdiff_subset_sdiff_left 的显式参数次序错误失败，读源码签名后修正。
- pathCount 实际过滤路径，要求每个访问格为 true；零维分支仅使定义总化，不在主定理范围内。
- 主均值定理尚未实现，此片段检查不等于完整构建。

## Lean 片段 2：一般均值公式

- 热树 lake env lean D5/S3/Arith/Paths/MonotoneOnePaths.lean EXIT=0。
  主定理 mean_monotone_one_paths 已按 brief 原式闭合；仅一个 unusedSimpArgs 风格警告待清理。
- freeCellsEquiv 将满足路径所需格全真的矩阵限制到补集，逆映射对所需格填 true；
  Lean 核验双侧逆，再由 Fintype.card_congr 求得 2^(总格数−所需格数)。
- fixed_path_count 消去重复格风险，给每条路径贡献 2^(k*k)；total_path_count
  交换有限求和并直接应用 card_powersetCard，最后在 ℚ 中消去非零的 2 的幂。
- 无 sorry、无自加 axiom、无 native_decide。完整 make lean 及公理闭包检查待执行。

## Lean 片段 3：端点与每步方向

- pathCell_endpoints 证明起点 (0,0)、终点 (k,k)；pathCell_step 证明第 t 步
  在编码子集中时恰东移 1，否则恰南移 1，另一坐标不动。两者为 private 语义引理。
- 删除总括 Mathlib.Tactic，改为具体 FieldSimp/NormNum/Ring imports。
  精简暴露 Nat.cast_sum 未导入；查其源码后显式导入 Algebra.BigOperators.Ring.Finset。
- 最终该文件增量检查 EXIT=0，无警告。主定理仍为 brief 原式。
