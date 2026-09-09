# q_d 家族分诊：中点停止，完成 1 / 4

`conclusion.verdict=abstain`，`screened=1`，`bind_only_count=1`。**B1.1 判为 bind-only；B3、B4、降阶推论未判。** 未把未完成的探针或检索零命中判成 `no`。完整结构化字段见 [conclusion.json](qd-family-triage-0909/conclusion.json)。

用户停止条件 2 已触发：开工 `2026-09-09 08:12:31 UTC`，预登记中点 `08:42:31 UTC`，`08:43:16 UTC` 检查时仅一条判完。brief 未给数值总时长，本席在首个提交中登记 60 分钟窗口；这是本席的预登记解释，未改仓内或 runner 预算常数。此后只整理证据、提交推送与发布工件，不再修补证明或跑新探针。

产地：单 Codex worker 直接检索、探针和自查；未使用 skill、未派独立评审席，不冒称共识或 orchestrator 亲验。已全文读 tracked `tools/scripts/agent/probe-brief-note.txt`、`CLAUDE.md`、`agents/CONTEXT.md`。

基准 `e34699c5198180cee56093ee6995eab47c4698fc`；分支 `lane/math/qd-family-triage-0909`；LANE #6160。Mathlib 本地钉版 `db584cd6d46c92f209a44c0f1c829460d327499d`，`leanprover/lean4:v4.33.0`。既有未跟踪输入 `family.json`、`candidates.json` 不进入提交。

预登记预测保留：B1.1 仅余归一化；B3/B4/推论至少一条可能有 content。这一预测尚未完成检验，不能从本次部分结果支持或推翻。

Q 固定为 `(p.comp (C (-1) * X)).reflect d`。`degree_policy` 为 `p.natDegree ≤ d`，不假设次数相等或首系数非零；Q 是全域多项式，倒数表达式仅在 `x ≠ 0` 处使用。零点值是 `p.coeff d * (-1)^d`，不能用朴素全函数化倒数公式代替。

## conclusion.per_atom

| atom_id | 判定 | 探针结算 |
| --- | --- | --- |
| `1e414ffb45d7fcaa9536a956298c4e291f91a2e310f112d2cf8419518caefd1a` | B1.1：yes | b11-01，EXIT=0，标准三公理 |
| `2bc63109d666c92a11aa641dbeae45bc08e3f4f939bc5ce4406a75e5d86d03b6` | B3：未判 | 未跑探针 |
| `c0a72a217fb966246fd4a48a809795cdc539435d1e88d1a10d041a9bcd9ed98d` | B4：未判 | b4-04，EXIT=2，源系数绑定未闭合 |
| `cd2ad7f9986ee06ef6a8ac86aa7834a19d836483eaa1475b57396f3ba7ae536a` | 降阶推论：未判 | 源码仅准备，未跑探针 |

未判条目的 JSON `bind_only`、`proof_shape` 均为 `null`，不伪填 yes/no；`screened` 只计完整判词。

### B1.1：yes

`bind_only=yes`；`proof_shape=bind-only`；`remaining_gap=none`；`escape_witness=null`。

常数归一化已是冻结 `source_jensen_coeff_edges` 第四投影，接 `coeff_reflect` 与 `ring` 即得；积分接 B1 导数恒等式和 Mathlib FTC。B1 探针前置来自已提交 `c58ed1b7d24efea45d8e077197bd284aaa45a534:docs/reports/robin/jensen-b1-0909.md`，并在本次探针内重验；它本身不冒称新冻结 API。

实际通过陈述（`alpha d=((d-1:ℕ):ℂ)/(d:ℂ)`；全部实数 x，包括零）：

```lean
theorem b11_constant (d : ℕ) (hd : 1 ≤ d) :
    (Q (sourceJensenPolynomial d) d).eval 0 =
      (-1 : ℂ)^d * (d.factorial : ℂ) / (d : ℂ)^d * (sourceThetaCoefficient d : ℂ)

theorem b11_source (d : ℕ) (hd : 2 ≤ d) (x : ℝ) :
    (Q (sourceJensenPolynomial d) d).eval (x : ℂ) =
      (∫ u in (0 : ℝ)..x, (d : ℂ) * alpha d ^ (d - 1) *
        (Q (sourceJensenPolynomial (d - 1)) (d - 1)).eval ((u : ℂ) / alpha d)) +
      (-1 : ℂ)^d * (d.factorial : ℂ) / (d : ℂ)^d * (sourceThetaCoefficient d : ℂ)

```

[探针源码](qd-family-triage-0909/B11Probe.lean)；[运行摘录](qd-family-triage-0909/b11-01-excerpt.txt)；[完整无损日志](qd-family-triage-0909/b11-01.log.gz)。`make lean` 整次 EXIT=0，534.139564708 秒，12767 jobs；`b11_constant` 与 `b11_source` 都仅 `[propext, Classical.choice, Quot.sound]`。

`mathlib_hits`：

- `Polynomial.reflect` — `.lake/packages/mathlib/Mathlib/Algebra/Polynomial/Reverse.lean:88`。
- `Polynomial.coeff_reflect` — `.lake/packages/mathlib/Mathlib/Algebra/Polynomial/Reverse.lean:96`。
- `Polynomial.eval₂_reflect_mul_pow` — `.lake/packages/mathlib/Mathlib/Algebra/Polynomial/Reverse.lean:191`。
- `Polynomial.hasDerivAt` — `.lake/packages/mathlib/Mathlib/Analysis/Calculus/Deriv/Polynomial.lean:66`。
- `HasDerivAt.comp_ofReal` — `.lake/packages/mathlib/Mathlib/Analysis/Complex/RealDeriv.lean:97`。
- `intervalIntegral.integral_eq_sub_of_hasDerivAt` — `.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/FundThmCalculus.lean:1148`。

`frozen_interfaces`：F1、F2、F3、F4，精确 GID、模块与声明身份及作用域见后文身份条目。

`admission_if_landed.admission_basis=rule-11-upstream-wrapper`，条件性依据是 Mathlib `intervalIntegral.integral_eq_sub_of_hasDerivAt` 与 atom B6 明文要求的该积分表示（`docs/develop/theory/QUANTUM-RH.md:1542`，`CLAUDE.md:117`）。常数投影单独没有独立准入依据。此次不实施。

### 定理 B3：一步正延拓的精确判据：未判

`bind_only=null`；`proof_shape=null`；`escape_witness=null`。`remaining_gap`：undetermined：去掉 Q 后待验证的是 ηᵢ=-d*q(tᵢ)/q″(tᵢ) 的留数符号与严格正根、箭头矩阵 charpoly=q 及正定条件之间的精确等价。未跑探针，不能断言这些是不可由绑定得到的数学缺陷。

`卡点/边界`：No B3 Lean probe was run before the midpoint stop; keyword misses are not a no verdict.

`mathlib_hits`（已读近邻的作用域，不等于整条可直接接上）：

- `Matrix.PosDef.fromBlocks₂₂` — `.lake/packages/mathlib/Mathlib/LinearAlgebra/Matrix/PosDef.lean:582`。下右块正定假设下的 Schur 半正定等价；结论是 PosSemidef，不能直接冒充整条严格正定/留数准则。
- `Matrix.det_fromBlocks₁₁` — `.lake/packages/mathlib/Mathlib/LinearAlgebra/Matrix/SchurComplement.lean:370`。给定可逆块的行列式分解；尚未绑定构造的箭头矩阵与 q。
- `Matrix.det_fromBlocks₂₂` — `.lake/packages/mathlib/Mathlib/LinearAlgebra/Matrix/SchurComplement.lean:384`。给定可逆块的行列式分解。
- `Matrix.IsHermitian.posDef_iff_eigenvalues_pos` — `.lake/packages/mathlib/Mathlib/Analysis/Matrix/PosDef.lean:71`。给定 Hermitian 矩阵：严格正谱 ↔ 正定；未构造目标矩阵或证明 charpoly=q。
- `Matrix.IsHermitian.posSemidef_iff_eigenvalues_nonneg` — `.lake/packages/mathlib/Mathlib/Analysis/Matrix/PosDef.lean:34`。给定 Hermitian 矩阵：非负谱 ↔ 半正定。

`frozen_interfaces`：F1、F4，仅可接背景；未验证完整 atom 绑定。B3 不把已假设行列式实现的接口当作该实现的构造。

`admission_if_landed.admission_basis=none`：没有完整探针或满足四项的逃逸见证，也未为完整 atom 核准薄包装/具名消费者的 bridge 准入。

### 定理 B4：新增耦合总预算：未判

`bind_only=null`；`proof_shape=null`；`escape_witness=null`。`remaining_gap`：undetermined：留数总和与前两系数的通用恒等式、实际 source 系数表达式到四阶累积量的算术已 elaborate 且仅标准三公理；qSource_top_three 的实际源二次项归一化仍有未闭合目标。未验证整个 atom，尚未认定任何真实数学缺陷。箭头二次迹不是本次已验证为必要的缺口。

`卡点/边界`：qSource_top_three（B4Probe-04.lean:129）的二次项归一化留下 True ∨ sourceThetaCoefficient 2 = 0；b4_source 因错误恢复依赖 sorryAx。此处没有数学逃逸见证。

`mathlib_hits`（已读近邻的作用域，不等于整条可直接接上）：

- `Polynomial.eq_of_degree_le_of_eval_index_eq` — `.lake/packages/mathlib/Mathlib/LinearAlgebra/Lagrange.lean:117`。由次数界、首项及节点值识别导数多项式。
- `Lagrange.coeff_eq_sum` — `.lake/packages/mathlib/Mathlib/LinearAlgebra/Lagrange.lean:495`。低于节点数次数的多项式：指定系数等于节点值除节点差积的和。
- `Lagrange.eval_nodal_derivative_eval_node_eq` — `.lake/packages/mathlib/Mathlib/LinearAlgebra/Lagrange.lean:605`。nodal 导数在节点处的值等于去掉该节点的 nodal 值。
- `Polynomial.coeff_reflect` — `.lake/packages/mathlib/Mathlib/Algebra/Polynomial/Reverse.lean:96`。Q 系数的定义绑定。

`frozen_interfaces`：F4，仅可接背景；未验证完整 atom 绑定。

`admission_if_landed.admission_basis=none`：整个源 Q 绑定未验证完成；通过的子引理不能独立为整条提供准入依据。

[失败快照](qd-family-triage-0909/B4Probe-04.lean) 与 [完整日志](qd-family-triage-0909/b4-04.log)。可保留的部分读数：`nodal_derivative`、`b4_residue_sum`、`b4_cumulant`、`b4_source_cumulant` 都仅标准三公理；整次 EXIT=2。

其中通用留数恒等式为：`d=n+2`，`q.coeff d=1`、`q.coeff(d-1)=-a₁`、`q.coeff(d-2)=(d-1)/d*a₂`、次数不超过 d、d−1 个互异临界点下，`Σᵢ -d*q(tᵢ)/q″(tᵢ)=(d-1)/d²*(a₁²-2*a₂)`。它以 Lagrange 插值的系数和公式为引擎，提供了已验的局部路线；没有验证整条 B4 或判其 proof_shape。

源版本还显式假设 `sourceThetaCoefficient 0 = 1`，未在本席消除此分析前提；这不是 `P.natDegree=d` 假设。前项根到临界节点及原文所有侧条件的整条接口也未完成核验。

### 推论：实根性向低阶传递：未判

`bind_only=null`；`proof_shape=null`；`escape_witness=null`。`remaining_gap`：undetermined：倒数缩放在含零点/次数不足时的根域运输、导数根域保存、塔上归纳及最小失败阶仍未实测。Gauss–Lucas、凸集与 Nat.find 已命中；没有依据把这些步骤直接判作 content。

`卡点/边界`：Source prepared only, never passed to make lean. Negative-root transfer and fixed-source RH-to-failure assertions were not completed.

`mathlib_hits`（已读近邻的作用域，不等于整条可直接接上）：

- `Polynomial.rootSet_derivative_subset_convexHull_rootSet` — `.lake/packages/mathlib/Mathlib/Analysis/Complex/Polynomial/GaussLucas.lean:97`。正次数复多项式的导数根属于原根集凸包。
- `convex_halfSpace_re_gt` — `.lake/packages/mathlib/Mathlib/Analysis/Complex/Convex.lean:57`。严格正实部半空间的凸性。
- `convex_halfSpace_im_le` — `.lake/packages/mathlib/Mathlib/Analysis/Complex/Convex.lean:63`。虚部 ≤ r 的闭半空间凸性。
- `convex_halfSpace_im_ge` — `.lake/packages/mathlib/Mathlib/Analysis/Complex/Convex.lean:67`。虚部 ≥ r 的闭半空间凸性。
- `antitone_nat_of_succ_le` — `.lake/packages/mathlib/Mathlib/Order/Monotone/Basic.lean:552`。相邻层关系推广为 Nat 上反单调。
- `Nat.find_spec` — `.lake/packages/mathlib/Mathlib/Data/Nat/Find.lean:75`。在已给定失败存在见证后取最小失败。
- `Nat.find_min` — `.lake/packages/mathlib/Mathlib/Data/Nat/Find.lean:80`。比 Nat.find 更小的阶不满足失败谓词。

`frozen_interfaces`：F1、F2、F3，仅可接背景；未验证完整 atom 绑定。

`admission_if_landed.admission_basis=none`：探针未跑，未判整条，未建立逃逸见证或完整薄包装/具名下游消费者依据。

[DescentProbe-UNRUN.lean](qd-family-triage-0909/DescentProbe-UNRUN.lean) 只作未跑草稿归档。未证明负根传递式 (28)，未证明 RH 假到固定 n=0 Jensen 塔失败的蕴含。次数不足产生的 Q 零根不能靠添加次数相等假设掩盖。

## frozen_interfaces：身份与作用域

GID 是模块 GID；模块 `statement_id` 从当前 Frozen/state 读取，声明 `statement_id` 从同一已接受 Freeze 事件读取，两者不混写。[逐项读取收据](qd-family-triage-0909/frozen-interface-receipts.json)。

- **F1** GID `D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering`；模块 `statement_id=sha256:ee43a04a542df25237818cbfeeb29bb1abaed956f90db04822d08e8f413d50b4`。声明 `D5.S3.Zeros.Jensen.NormalizedJensenDegreeLowering.normalizedJensen_degree_lowering`；声明 `statement_id=sha256:f13a2fdd4121c7b170af20e397cf8d9c567ddfcfd4dd8e37d469c21f8603d6bf`。作用域：任意实系数序列，d≥2；复多项式降阶恒等式，无根或矩阵结论。

- **F2** GID `D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering`；模块 `statement_id=sha256:ee43a04a542df25237818cbfeeb29bb1abaed956f90db04822d08e8f413d50b4`。声明 `D5.S3.Zeros.Jensen.NormalizedJensenDegreeLowering.normalizedJensen_eq_fallingFactorial_sum`；声明 `statement_id=sha256:8a2655f8cbb74a3d045256378f01d8c6468e59545dc09fc5446bd390f898c025`。作用域：任意实系数序列，d≥1；有限下降阶乘和。

- **F3** GID `D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering`；模块 `statement_id=sha256:ee43a04a542df25237818cbfeeb29bb1abaed956f90db04822d08e8f413d50b4`。声明 `D5.S3.Zeros.Jensen.NormalizedJensenDegreeLowering.sourceJensenPolynomial_eq_normalizedJensen`；声明 `statement_id=sha256:0c96cec689edaf5a585802b79a9c52b976c6dcedbee0cd259b40d0a7d19ecfa9`。作用域：固定 theta 系数，d≥1；源对象到通用归一化对象。

- **F4** GID `D5/S3/Zeros/Jensen/SourceJensenPrincipalBlockObstruction`；模块 `statement_id=sha256:5e43098caa9fb48b4fccd8adc30e337ff93668044d5dcfc06acab33dc8970f3c`。声明 `D5.S3.Zeros.Jensen.SourceJensenPrincipalBlockObstruction.source_jensen_coeff_edges`；声明 `statement_id=sha256:adde2bcfe9e6e59415236589839993c3faa03e7cabdaa4276c8a049fc9daae39`。作用域：固定 theta 系数，d≥1；四系数合取，第四项是顶项 d!/d^d*a_d。

## probe_runs

每次实际命令如下，原始 Makefile 的 lean recipe 保留，临时 makefile 只添加探针 prerequisite，通过仓库 canonical cache wrapper 调用 Lean。无裸 lake、cover 或 deposit 调用。

| run | EXIT | 秒 | 日志 / 源码 |
| --- | ---: | ---: | --- |
| b11-01 | 0 | 534.139564708 | [b11-01.log.gz](qd-family-triage-0909/b11-01.log.gz) / [B11Probe.lean](qd-family-triage-0909/B11Probe.lean) |
| b4-01 | 2 | 30.860718708 | [b4-01.log](qd-family-triage-0909/b4-01.log) / [B4Probe-01.lean](qd-family-triage-0909/B4Probe-01.lean) |
| b4-02 | 2 | 71.597924042 | [b4-02.log](qd-family-triage-0909/b4-02.log) / [B4Probe-02.lean](qd-family-triage-0909/B4Probe-02.lean) |
| b4-03 | 2 | 149.225800333 | [b4-03.log](qd-family-triage-0909/b4-03.log) / [B4Probe-03.lean](qd-family-triage-0909/B4Probe-03.lean) |
| b4-04 | 2 | 217.170564375 | [b4-04.log](qd-family-triage-0909/b4-04.log) / [B4Probe-04.lean](qd-family-triage-0909/B4Probe-04.lean) |

```sh
# b11-01: EXIT=0
make -f Makefile -f /var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-1/probe.mk lean PROBE=/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-1/B11Probe.lean
# b4-01: EXIT=2
make -f Makefile -f /var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-1/probe.mk lean PROBE=/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-1/B4Probe.lean
# b4-02: EXIT=2
make -f Makefile -f /var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-1/probe.mk lean PROBE=/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-1/B4Probe.lean
# b4-03: EXIT=2
make -f Makefile -f /var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-1/probe.mk lean PROBE=/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-1/B4Probe.lean
# b4-04: EXIT=2
make -f Makefile -f /var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-1/probe.mk lean PROBE=/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-1/B4Probe.lean
```

B4-01 因缓存 writer busy，未进入 Lean；02 为 API 参数与改写方向错误；03 为系数与非零分母规范化错误；04 的整条源绑定仍失败。失败运行均不产生 no 判词。B1.1 原始日志 64,110,530 字节，当前树存无损 gzip，字节一致性已核对；未重写早先包含原始日志的已推历史。

## search_receipts

[search-01.json](qd-family-triage-0909/search-01.json)、[search-02.json](qd-family-triage-0909/search-02.json)、[search-03.json](qd-family-triage-0909/search-03.json) 保存实际 argv、EXIT、命中行数、stdout/stderr。[citation-audit.json](qd-family-triage-0909/citation-audit.json) 只复核已用引用，不是中点后新增数学筛选。

| 对照 | 命令特征 | 命中行数 | EXIT |
| --- | --- | ---: | ---: |
| 仓内阳性 | `rg -n '\bsource_jensen_degree_lowering\b' D5 --glob '*.lean'` | 1 | 0 |
| 仓内阴性 | 同域 `\bqd_triage_nonexistent_control_0909\b` | 0 | 1 |
| Mathlib 阳性 | Reverse.lean 中 `\bcoeff_reflect\b` | 5 | 0 |
| Mathlib 阴性 | Mathlib 中 `\bqd_triage_nonexistent_control_0909\b` | 0 | 1 |
| Schur 阳性 | `\btheorem fromBlocks(₁₁|₂₂)` | 2 | 0 |
| Schur 阴性 | `\btheorem qd_nonexistent(₁₁|₂₂)` | 0 | 1 |

所选 Mathlib 子目录的 arrowhead/interlacing 关键词为 0 行、EXIT=1；不是不存在性证明。原 Schur 模式在下标后加 `\b` 得假阴性，已用同正则特性的阴阳对照修复，完整保留错误收据。引用复核中的 spectral `theorem` 字面匹配也已记录为 `lemma` 关键字不符，不能当作定理缺失。初始两个不存在路径的读取只算导航错误。

## pushed.commits

逐批提交推送；以下为本报告提交前已推送快照。runner `result.json` 在报告最终提交推送后补入最终 commit 与远端 HEAD 收据。

- `1a06c7e2cc6a3a9a8d1e47ae0d4893e8bfaa1a95`
- `c8fda1425c4c1e66de37d448b9c0e0f9369e4773`
- `5def57c0bf57a4b39437f77d5026e46e1bcd157b`
- `38bd4fc9e649c4a1a8b2eb93dea8b0e58d5bcfb9`
- `bd27cc888919607b4f1f7f13f24e8aaa0a979598`
- `561983d0bf36c9250a74d411888853e763f23647`

## assumed_unverified 与 nonclaims

`content_candidates=[]` 只表示没有认证的 content 候选；三条未判的候选义务见各条 `remaining_gap`，不是断言其无 content。

- ASSUMED-UNVERIFIED / 未测：External papers/pages were not opened and carry no conclusion.
- ASSUMED-UNVERIFIED / 未测：B3 has no make lean probe.
- ASSUMED-UNVERIFIED / 未测：B4 full source binding is unverified: EXIT=2 and error-recovery sorryAx.
- ASSUMED-UNVERIFIED / 未测：DescentProbe-UNRUN.lean was not run; negative-root descent and fixed-source RH implication are unverified.
- ASSUMED-UNVERIFIED / 未测：B4 sourceThetaCoefficient 0 = 1 remains an explicit assumption; its source analytic justification was not tested.
- ASSUMED-UNVERIFIED / 未测：No independent reviewer or orchestrator re-verification was performed.

`nonclaims`：未落地；未建 D5/ 生产模块；未 cover；未 deposit；未开 PR；未主张检索穷尽；“未命中”不是“Mathlib 里不存在”的证明；未判 B3、B4、降阶推论为 yes 或 no；未证明三条未判 atom，未主张其可证或含 content；未主张 RH 的任何蕴含；未将 refutes 当作第四种 admission_basis；未把 q_d 倒数变量绑定重新算作缺口；未假设 P 的次数等于 d 或首系数非零。

runner 工件目录：`/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-1`。最终 `result.json` 严格只含 `conclusion` 对象和非空 `log_ref`；先写临时文件后原子改名，再以同样方式发布 `completion.sentinel`。

## Attempt 2：预登记与接续（2026-09-09）

产地：单 Codex worker，无 skill、无子席、单点自查；交付仅为判词。基底 `18f70e6ee6b809110f9bef3214a4cd51688b6c57`；分支 `lane/math/qd-family-triage2-0909`。B1、B1.1 与 Q/reflect 的既判结果直接继承，不重新判形。

开工 `09:25:30 UTC`。brief 未给数值总时长，沿用上一席的 60 分钟审理窗口解释：中点 `09:55:30 UTC`，截止 `10:25:30 UTC`；中点若三条中仍无一条明确 yes/no 即停止数学筛选。此为席位预登记，不改仓内或 runner 预算。只有用户给的非方向性期望：至少一条可明确判定；不续下注至少一条 content。

全文已读本树 `CLAUDE.md`、`probe-brief-note.txt`、上一席报告及 `agents/CONTEXT.md`。本树 standing 文件止于七节；八至十二节已从本地 `origin/dev` 对象 `7547debb97761296d4d934b9c87ada4b90729cea` 读取，[原文收据](qd-family-triage-0909/attempt-2/standing-sections-8-12.txt)。不把较新 dev 状态搬入基底。

顺序：B4 → B3 → 推论。B4 复用上一席 Lagrange 留数恒等式，首先闭合原文目标 `⊢ True ∨ sourceThetaCoefficient 2 = 0`；该目标有左支 `True`，是证明收尾工作量，零数学缺陷证据。B3 拟探针检验箭头行列式识别、留数符号及严格正性等价；若确有新中间构造，候选见证限定为一般箭头多项式重建及其活路径，不先判 content。推论拟检验零点/次数不足运输、导数根域保存和最小失败阶；RH 到固定源塔失败的源识别与 Jensen–Pólya 桥单列检验，不用条件版本冒充无条件结果。

[B4 检索收据及同正则阴阳对照](qd-family-triage-0909/attempt-2/search-01.json)。源上下文明列 `a₀=1`，有限假设列互异正根，B1 给其缩放为全部临界点；探针的这些前提须逐一对齐，不把任意加强的前提当绑定。

`candidates.json`、`family.json` 为本席开工前已有未跟踪文件，不纳入提交。仅定向 add；每批读数和探针边做边推。

### Attempt 2 / B4：bind-only = yes

`atom_id=c0a72a217fb966246fd4a48a809795cdc539435d1e88d1a10d041a9bcd9ed98d`；`proof_shape=bind-only`；`escape_witness=null`；`remaining_gap=none`（原文有限设置内）。

[完整探针](qd-family-triage-0909/attempt-2/b4-01.lean) 已把 B18 两段等式合成 `b4_source_full`。`make lean` 整次 **EXIT=0**，248.4600485 秒；该定理及所用留数恒等式均只依赖 `[propext, Classical.choice, Quot.sound]`。[运行摘录](qd-family-triage-0909/attempt-2/b4-01-excerpt.txt)；[完整日志的无损 ASCII 归档](qd-family-triage-0909/attempt-2/b4-01.log.gz.b64)。解码为 base64 后解 gzip 即原始日志；原始日志也保存在 runner attempt-2 中。

判形依据：内联 `R=q−d⁻¹Xq′+(a₁/d²)q′` 后，次数界、节点值、最高系数全是系数改写及域归一化；`q′=d·nodal` 直接应用上游多项式唯一性；留数和就是 `Lagrange.coeff_eq_sum` 的实例。源二次项来自有限和定义，`χ₄` 换元来自 `a₁=m₂/2`、`a₂=m₄/24`，以 `ring` 收尾。没有满足逃逸见证四项的新中间命题。

上一席的 `⊢ True ∨ sourceThetaCoefficient 2 = 0` 改用 `ring_nf` 后 `simp` 闭合；新目标没有增加前提。B3 设置的 `d≥2` 写成 `d=n+2`，`a₀=1` 为源卷明文固定规范，`t` 的互异性来自有限假设，临界性由既判 B1 提供；不额外假设 `P_d.natDegree=d`。这不证明实际 theta 密度与 ξ 的归一化分析桥，该共同背景仍按原文假设使用。

`mathlib_hits`（本地钉版实读）：`Polynomial.eq_of_degree_le_of_eval_index_eq` — `.lake/packages/mathlib/Mathlib/LinearAlgebra/Lagrange.lean:117`；`Lagrange.coeff_eq_sum` — 同文件 `:495`；`Lagrange.eval_nodal_derivative_eval_node_eq` — 同文件 `:605`；`Polynomial.coeff_reflect` — `.lake/packages/mathlib/Mathlib/Algebra/Polynomial/Reverse.lean:96`。

`frozen_interfaces`：F4，GID `D5/S3/Zeros/Jensen/SourceJensenPrincipalBlockObstruction`；模块 `statement_id=sha256:5e43098caa9fb48b4fccd8adc30e337ff93668044d5dcfc06acab33dc8970f3c`；直接声明 `source_jensen_coeff_edges`，声明 `statement_id=sha256:adde2bcfe9e6e59415236589839993c3faa03e7cabdaa4276c8a049fc9daae39`。作用域：固定源、d≥1、四系数合取；仅投影其常数与线性系数。F1 的既判 B1 接口负责将前层根变成当前临界点，不冒称 B1 已有独立冻结模块。

`admission_if_landed=rule-11-upstream-wrapper`：命中 `Lagrange.coeff_eq_sum`；必要性是 atom B18 明文要求实际 η 与 θ 系数/χ₄ 的预算式，上游仅给节点插值的系数和，需此忠实专门化。不据可证性单独授予准入；本席不落地。

实际命令：

```sh
make -f Makefile -f /var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-2/probe.mk lean PROBE=/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/qd-family-triage-0909/attempt-2/B4Probe.lean
# EXIT=0
```

读 atom 的工具异常另记：三条首轮 `make show-atom` 均 EXIT=2，原文为 `SHOW_ATOM_INVALID Repository file must be strict UTF-8: docs/reports/digestion/qd-family-triage-0909/b11-01.log.gz.`，无 Lean 未闭合目标。临时把继承的二进制归档移出当前树重读，完成后原样恢复；本席新日志用 ASCII 无损归档，避免重复此触发。该异常不支持任何数学 no/content 判词。
