# A375007 implementation — 2026-09-10

产地：`lean4` skill；Codex implementation worker 单点实施与自查，未派独立评审席。用户提供的两支构造源自分诊席；用户自报亲验的代数与 t<3000 扫描是输入，本报告不冒称由 worker 执行。外层 runner 的评审不在本席已知证据内。

## 预登记与范围

第一档。目标为所有自然数 t>24，纯商余条件
`P t := ∀ k, 1 ≤ k → k ≤ t → (t % k = ((t-k)/k) % k → k=1 ∨ k=t)`
蕴含 `Nat.Prime (t+1)`。P 不含素性，所有减法、商、余数均为 Nat 标准运算。
预登记位置：用户实施 brief 与 `Library/Words/oeis2026triage0910.md` 的 A375007 条目。

拟议 escape_witness：由合数分解 t+1=ab、2≤a≤b 构造严格内部见证。
若 a<b，k=b−1，商余分解 t=a*k+(a−1)；若 a=b=u，k=u−2，分解 t=(u+2)*k+3，阈值给 u≥6。
公开主定理拟判 `proof_shape: content`，`admission_basis: escape-witness`。
预计直接 D5 冻结依赖为空；最终以 Lean 语义报告核对。
`utility: none`：目标是无界量化的一般算术定理，不是有限枚举、检查器、数值归约或认证实例。

停止判据依 brief：成 = make lean EXIT=0、无 sorry/私 axiom、PR 已开；翻 = kernel 反例；blocked = 记录路线与最锐剩余子命题。
交付只开 PR，不声明已合入。冻结走无 atom 的 `ledger-align --add`；不建理论卷、不 ingest、不制造 coverage。

## 先库后证收据（随实测追加）

1. 已完整阅读 `CLAUDE.md`（779 行，分段读，截断处补读）、`agents/CONTEXT.md`、Lean skill。
2. 本仓执行 `rg -n 'A375007|a375007|isolated.*(quotient|remainder)|孤立.*商余' D5 Blueprint Library docs/develop`。
   命中仅 `Library/Words/oeis2026triage0910.md` 的分诊记录；D5/Blueprint 未命中目标证明。
   这是字面粗筛，不声称覆盖所有同义表述。
3. `lean-toolchain` 为 `leanprover/lean4:v4.33.0`，manifest mathlib rev 为 `db584cd6d46c92f209a44c0f1c829460d327499d`。
4. 已读 spec A5.1：七行头的第六行为 `utility: none`，在 anchors 与 digest 之间。
   `Meta/domains.yaml` 已注册 `Arith`，地层 S3。报告根目录当前直属文件 37 个。
5. mathlib 声明和外部文献：待本席实查，不采用分诊记录替代检索。

## 未主张

- 尚未跑 Lean、尚未证明目标、尚未冻结、尚未开 PR。
- 尚未打开 OEIS/arXiv/第三方检索页；关于那些页面的输入均为 `ASSUMED-UNVERIFIED`。
- 未主张世界文献不存在证明，未主张另一条 Fortunate 型猜想，未主张序号枚举接口的形式化。
- 尚无独立模型评审或 CI 判词。
