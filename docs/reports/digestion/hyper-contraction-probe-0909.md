# RH 下的超几何收缩: 判形探针 (2026-09-09)

**第一硬要求:** 对目标及每个子命题,先尝试仅由钉版 Mathlib 实例化、冻结件投影及规范化改写(含 `sq_nonneg` + `linarith only`)得到;成功即记 `bind-only` 并停止该部件的证明工作。无法给出 `why_not_bind_only` 的部件记 `likely-bind-only`。

产地(第 5.2 条): 无额外 skill,单席 codex-cli 探针直接检索与自查;零实施席、零评审席,无多席共识,无 orchestrator 独立亲验。用户 brief 的猜测仅为输入,不算本席读数。runner 阶段为 `thinking`。

## 范围与预登记

- 工作树: `/Users/auricstudio/trureturing-hyper-contraction-probe-0909`。
- 分支: `lane/math/hyper-contraction-probe-0909`;起点与当时本地 `origin/dev` 均为 `5a29f572a2b0f4dc207528a819efe8552500d86e`。
- LANE: #6160;相关留档: [#6503](https://github.com/the-omega-institute/trureturing/pull/6503)(已通过 GitHub API 读取正文)。
- source_id: `quantum-rh`;目标 atom: `bb2f81213482f52a1bbf2bbfed1f7fe097d2d9f4949ebb55dc0da2e94d4f1f45`。
- Lean: `leanprover/lean4:v4.33.0`;Mathlib: `db584cd6d46c92f209a44c0f1c829460d327499d` (`lake-manifest.json`,inputRev `v4.33.0`)。
- 按 Q1 -> Q2 -> Q3 -> Q4 顺序;无法回答即如实停在该问。探针不实施完整证明、不 deposit、不冻结、不开 PR、不改消化账。
- 拟议而未确认的逃逸位置: 用户猜测的首一消失多项式构造及任意 `r` 的估计/极限。必须先尝试绑定消去;当前 `escape_witness = null`,不预判 content。
- 目标始终是 **RH 条件下** 的结论;本席不作无条件结论,不声称推进 RH。

## 进度

- 规则读取完成: `CLAUDE.md` 全 764 行已分段读完(首次整文件输出截断,随后补读),`agents/CONTEXT.md` 已读。
- Q1: 已答,三个前置在源卷中均找到;散文论证不冒充 Lean 证明。
- Q2: 已答,3 个矩/距离候选模块均有冻结状态片;批次 8 另核 3 个实际零点前置模块。实际测度识别未因此完成。
- Q3: 已答,②与以式 (28) 为前件的③为 `bind-only`;①④⑤完整部件为 `likely-bind-only`,其中若干绑定片段已通过。无 content 见证,停止证明扩展。
- Q4: 已答,建议修订短名单的 content 预判;`verdict=revise`,`escape_witness=null`,不进入实施。

当前结论: **前置在源卷找到,抽象矩/Gram 端确有冻结 pin,但没有查实仅凭 RH 即输出实际式 (27)-(28) 的冻结端。②③已被绑定消去,整体 `likely-bind-only`;没有可点名的逃逸见证。** 这是否定本席将其升级为 content 实施候选的依据,不是反驳源定理。

## 检索留痕

计数口径: 下列命令读取本工作树;词法检索只作定位,零命中不等于语义不存在。后续正则对照统一用 `rg` 或 `git grep -P`,不用 `-E`。

| 批次 | 命令 | 读数 | 边界 |
| --- | --- | --- | --- |
| 0 | `git status --short --branch` | 0 个改动,分支跟踪 `origin/dev` | 开工读数 |
| 0 | `git rev-parse HEAD origin/dev` | 两者均为上列起点 | 尚未 fetch,不代表远端此刻 tip |
| 0 | `rg --files -g AGENTS.md -g CLAUDE.md -g '*quantum*' -g '*6503*' -g '*probe*' docs agents` | 4 路径,均为 `docs/reports/convolution/` 既有探针 | 文件名筛选,未命中 quantum 文件名不等于无源卷 |
| 0 | `cat lean-toolchain lake-manifest.json` | 上列 Lean/Mathlib pin | 只读 pin,未构建 |
| 1 | `rg -n '超几何收缩\|量子.*黎曼\|quantum-rh' docs/develop/theory Meta/Digestion/sources*` | shell exit 1: `no matches found: Meta/Digestion/sources*` | `rg` 未执行,不是零命中;后续去掉臆造路径 |
| 1 | `cat Meta/Digestion/atoms/sha256/bb2f81213482f52a1bbf2bbfed1f7fe097d2d9f4949ebb55dc0da2e94d4f1f45` | 1 atom 全文,目标与 brief 一致 | 原子确未定义 `mu` 与 `h_n`,且证明段未论证严格正性 |
| 1 | `rg -n '^lean:\|LEAN_ARGS\|atom-context\|^help:' Makefile` | 6 匹配行 | 只定位 make 入口 |
| 1 | `gh issue view 6503 --repo the-omega-institute/trureturing --json number,title,body,url` | 1 正文;URL 实为 PR #6503 | 正文转述筛选席:第 1 名欠实际测度、变分识别、严格正性;未在该正文点名矩/Gram 接口 |
| 2 | `rg -n '超几何收缩\|量子.*黎曼\|quantum-rh' docs/develop/theory` | 4 匹配行,目标在 `QUANTUM-RH.md:51129` | 修正批次 1 的 shell 路径错误 |
| 2 | `rg --files docs/reports/digestion` | 3 路径 | 找到 `qrh-deposit-screen-0909.md` |
| 2 | `make atom-context ATOM_ID=bb2f81213482f52a1bbf2bbfed1f7fe097d2d9f4949ebb55dc0da2e94d4f1f45` | make exit 2,CLI 可执行文件不存在 | 未取得该工具的邻接输出;依用户允许的另一方式直接连读源卷,未构建无关 harness |
| 2 | `sed -n '50600,51270p' docs/develop/theory/QUANTUM-RH.md` | 连读含 Schur 定义、式 (27)-(29) 与后续段 | Q1 主证据 |
| 2 | `nl -ba docs/develop/theory/QUANTUM-RH.md \| sed -n '49820,50090p'` | 连读式 (23)-(32) | 实际 Li 识别、绝对收敛与质量恒等式 |
| 2 | 同上,区间 `'50410,50490p'` 与 `'51088,51129p'` | 2 段 | `c0>0`、`r_n`、`T_N` 与前置逐字出处 |
| 2 | `cat Meta/Digestion/atoms/sha256/bf0eaca15d701e4f6b37eb3490e3c36857ce5415da5101830c0bc36b3c8aa12d` | 1 atom 全文 | 与源卷紧邻目标的第八节前置段一致 |
| 2 | `rg -n 'bb2f8121\|Gram\|矩积分\|statement_id' docs/reports/digestion/qrh-deposit-screen-0909.md` | 命中目标行 113 及 F7/F10/F11 的导航 | 此时只作定位,不把报告转述当新冻结证据 |
| 2/3 | `rg -n -P '\b(?:Monic\|HyperContraction\|supergeometric\|hypercontraction)\b' D5` | 32 匹配行,均为 Monic;另三词 0 | 同特性阴性见下一行;批次 3 由工具输出逐行计数 |
| 2 | `rg -n -P '\b(?:MonicProbeNegative0909\|HyperContractionProbeNegative0909)\b' D5` | 0 匹配行,rg exit 1 | 同用 PCRE `\b` 与非捕获分组;阳性对照有命中 |
| 3 | `rg --files Golden/Frozen/state \| rg -P '(?:LiCurvatureCriterion\|ToeplitzContactSupport\|FiniteSynthesisGramDistance)\.lean\.json$'` | 3 路径 | 3 份 state 与对应 Lean 源码均以 `cat` 全文读取 |
| 3 | `rg --files Golden/Frozen/state \| rg -P '(?:WeakQlpDifferentiation)\.lean\.json$'` | 0 路径,exit 1 | 未冻结阴性 |
| 3 | `rg --files Golden/Frozen/state \| rg -P '(?:MatchingPolynomial)\.lean\.json$'` | 1 路径 | 同 PCRE 特性的已冻结阳性 |
| 3 | `rg --files D5 \| rg -P '(?:WeakQlpDifferentiation)\.lean$'` | 1 路径 | 本树继承 dev 的代码存在,但没有冻结片;不是本靶前置 |
| 3 | `rg -n '^theorem (toeplitz_quadratic_eq_integral\|li_curvature_criterion\|toeplitz_contact_support\|finite_synthesis_gram_distance\|finite_synthesis_gram_projection)' D5/S3/Weil/TestFunctions/LiCurvatureCriterion.lean D5/S3/Weil/TestFunctions/ToeplitzContactSupport.lean D5/S3/Observer/Hilbert/FiniteSynthesisGramDistance.lean` | 6 声明行 | 定位后据完整类型分析,未用名字代替类型 |
| 3 | `ls -ld .lake .lake/packages/mathlib .lake/lean-cache-stamp.json` | 三路径皆不存在,exit 1 | 本树冷,后续如需编译只走 `make lean` |

持久化: 初始化提交 `7db305209a` 已推送,远端本探针分支已建立。后续各批同样提交并推送,最终完整 SHA 清单写入 runner `result.json`。

## Q1: 三个缺失前置

结论: **三个都找到**。缺的是目标 atom 的自足性及实际对象的形式化前置,不是源卷没有定义。以下出处均绑定上述起点,行号只作 provenance。

### 概率测度及总质量

[源卷 L51094](../../develop/theory/QUANTUM-RH.md?plain=1#L51094),亦即前置 [atom bf0eaca1](../../../Meta/Digestion/atoms/sha256/bf0eaca15d701e4f6b37eb3490e3c36857ce5415da5101830c0bc36b3c8aa12d),逐字:

```text
在 RH 前件下，定义概率测度

$$
\boxed{
\mu=
\frac1{c_0}
\sum_\rho
\frac1{|\rho|^2}\delta_{w_\rho}.
}
\tag{27}
$$

求和按重数进行。
```

这里 `rho` 是非平凡零点,`w_rho = 1 - 1/rho`([L49844](../../develop/theory/QUANTUM-RH.md?plain=1#L49844));RH 下其模为 1([L49853](../../develop/theory/QUANTUM-RH.md?plain=1#L49853))。质量依据不是数值近似:前文 [L49988](../../develop/theory/QUANTUM-RH.md?plain=1#L49988)逐字为“其中原和按对称方式理解；取二阶差分后，相关级数绝对收敛。”随后“在 RH 下，\(|w_\rho|=1\)，计算得到”,式 (32) 逐字:

```text
$$
\boxed{
c_n
=
\sum_\rho
\frac{w_\rho^n}{|\rho|^2},
\qquad
\sum_\rho\frac1{|\rho|^2}=c_0.
}
\tag{32}
$$
```

[L50447](../../develop/theory/QUANTUM-RH.md?plain=1#L50447) 明写 `c_0=2+\gamma_{\mathrm E}-\log(4\pi)>0`。故归一化的质量是 `c0^(-1) * c0 = 1`。这是对源卷所给求和恒等式的规范化投影,`bind-only` 形;没有在本席证明实际零点级数恒等式或构造 Lean 测度。

### h_n 的定义与变分识别

原始定义是 Schur 余量,并非从 inf 开始定义。[L50618](../../develop/theory/QUANTUM-RH.md?plain=1#L50618) 先假设 `T_n` 严格正定,取 `A_n=(r_{j-i})_{1<=i,j<=n}`、`u_n=(r_1,...,r_n)^T`,式 (11) 是 `h_n=1-u_n^T A_n^(-1)u_n`;紧随原文“这里 \(h_n>0\)。”[L50735](../../develop/theory/QUANTUM-RH.md?plain=1#L50735) 另定 `h_0=1`。实际数据来自 [L50454](../../develop/theory/QUANTUM-RH.md?plain=1#L50454) 的 `r_n=c_n/c_0` 与 `T_N=(r_{j-i})_{0<=i,j<=N}`。

[L51116](../../develop/theory/QUANTUM-RH.md?plain=1#L51116) 的变分识别及解释逐字:

```text
同时，

$$
\boxed{
h_n=
\min_{\deg q<n}
\int|z^n-q(z)|^2\,d\mu(z).
}
\tag{28}
$$

也就是说，\(h_n\) 是用旧读出 \(1,z,\ldots,z^{n-1}\) 逼近新读出 \(z^n\) 时的最小残差平方。这是单位圆正交多项式的基本变分描述。([arXiv][4])
```

所以答案是 **是,且源文写了达到的最小值 `min`**:换元 `P=X^n-q` 把 `deg q<n` 与首一、恰 n 次的 P 对应起来,最小值当然等于下确界。须保留“达到”或有限维距离的闭性论证;不能仅从每个积分都正推出 inf 严格正。式 (28) 是源卷援引标准变分描述的识别,未附独立推导。源句没有在此行明确写系数域,标准圆测度解释用复系数;若坚持此前实矩坐标,还须利用共轭对称作实/复识别。n=0 应直接用 `h_0=1`,不在 Lean 中误用自然数 `natDegree 0 < 0`。

### 严格正性是证明还是假设

[L51114](../../develop/theory/QUANTUM-RH.md?plain=1#L51114) 逐字:

```text
由于有无限多个不同零点，而一个非零多项式只能有有限多个根，所有有限 \(T_N\) 都严格正定。零点的无限性及对称性是经典结论。([DLMF][2])
```

源卷对于 **一般递推阶段** 先假设 `T_n` 严格正定;对于 **实际 RH 测度** 则给上述散文论证,不是额外假设 `h_n>0`。配合严格正的原子权重、Schur 余量定义或达到的变分最小值,得到每阶 h_n 正。源卷援引零点无限性等经典事实,未在该段重证;本席只确认论证存在,不把这句话冒充 kernel 证明。前置齐全使 Q2 可继续。

外部出处状态: 源卷 `[DLMF][2]`、`[arXiv][4]` 等只是已读取的源文引注;本席尚未打开这些外链,一律 `ASSUMED-UNVERIFIED`。

## Q2: 具名冻结端的实查

下列 GID 与 `statement_id` 均为 **模块 state pin**,不是本席重算的单声明 ID。声明全名为相应 Lean namespace 加表中短名,不另造声明级 pin。状态身份直接读取 `Golden/Frozen/state/<模块 GID>.lean.json`,不重放冻结验证。

| 模块 GID / 声明 | state 中的 statement_id | 可用作用域与限制 |
| --- | --- | --- |
| `D5/S3/Weil/TestFunctions/LiCurvatureCriterion` / `toeplitz_quadratic_eq_integral` ([源码 L97](../../../D5/S3/Weil/TestFunctions/LiCurvatureCriterion.lean#L97)) | `sha256:6a1e756aa2727dd386a310293dc7ad58dab820b7fe82f2db9dd6f30ab6105a39` ([state](../../../Golden/Frozen/state/D5/S3/Weil/TestFunctions/LiCurvatureCriterion.lean.json)) | 对任意 `mu : Measure Circle`、`[IsFiniteMeasure mu]`、有限系数 `Fin (N+1) -> Complex`,给 Toeplitz 二次型等于多项式模方的复积分。**不构造实际零点测度,不证明其总质量,不识别实际 Li 系数,不提供变分最小值或严格正性。** `circleMoment mu n` 用 `z^(-n)`,源文用 `z^n`;需显式统一指标/共轭对称。 |
| `D5/S3/Observer/Hilbert/FiniteSynthesisGramDistance` / `finite_synthesis_gram_distance`, `finite_synthesis_gram_distance_inverse` ([源码 L69](../../../D5/S3/Observer/Hilbert/FiniteSynthesisGramDistance.lean#L69),[L118](../../../D5/S3/Observer/Hilbert/FiniteSynthesisGramDistance.lean#L118)) | `sha256:f253af735663b2bdb2434a2f716c7e707723d8f658a3acbc1adc9cd442b8ecda` ([state](../../../Golden/Frozen/state/D5/S3/Observer/Hilbert/FiniteSynthesisGramDistance.lean.json)) | `RCLike` 实/复域,有限维内积系数空间 E、完备 Hilbert 空间 H、`V : E ->L H`,给 `infDist x range(V)^2` 的 Moore-Penrose Gram 公式。普通逆版另给 `G : E ≃ₗ E` 与 `hG : G.toLinearMap = gram V`。**不要求 H 有限维;一般版不要求 Gram 可逆。** 要识别源 h_n,仍须把 H、V、x 实例化成实际 `L2(mu)`、低次幂合成与 z^n,核对 Gram/内积/范数及普通逆。**不提供实际测度、谱无限性、超几何极限。** |
| `D5/S3/Weil/TestFunctions/ToeplitzContactSupport` / `toeplitz_contact_support` ([源码 L80](../../../D5/S3/Weil/TestFunctions/ToeplitzContactSupport.lean#L80)) | `sha256:a4bba9f0782f9ada25b3fecf19631a21a6c7f13d714795d777647659296953b7` ([state](../../../Golden/Frozen/state/D5/S3/Weil/TestFunctions/ToeplitzContactSupport.lean.json)) | 假设 `completion = alpha • normalizedCircleHaar + residual`、系数向量单位化、Toeplitz 特征方程,才给 residual 支撑在 contactPolynomial 零点及有限原子展开,原子数不超过次数。**不是无前件的“任意零残差就严格正”;不证明实际谱无限。** 若用于严格正性反证,尚须提供 alpha=0 的实例、归一化与核向量。 |

补充边界: 第一模块的 `li_curvature_criterion` ([L359](../../../D5/S3/Weil/TestFunctions/LiCurvatureCriterion.lean#L359)) 把 `liCriterion`、曲率递推、`rhFourierRepresentation` 和全阶 `circleHerglotzRepresentation` 均列为**显式假设**。不能凭该模块已冻结,就移除它们或宣称已有实际 RH 测度。

因此 #6503 所称“端可接”的可核实含义是上述 **抽象矩积分/距离接口存在且冻结**。本轮已核出的“只给 RH 就输出式 (27)-(28) 的实际对象与识别”端为 `none`。已有端的实例化/投影自身均 `bind-only`;作用域限制是数学前件,不按代码行数命名为缺陷。

## Q3 检索与构建记录

批次 4: `cat tools/scripts/worktree/lean-cache-run.sh lakefile.toml` 确认根 `make lean` 会 ensure 私有缓存,默认 glob 包含 `D5.+`。既有 `docs/reports/convolution/image-cone-probe-0909.md:414` 记录可先临时放 D5 编译、再将片段移至报告目录的探针形态。未改构建参数或常数。本树首次 `make lean` 已启动,尚未以退出码结算。

本仓先搜: `rg -n -i 'hyper.?contract|super.?geometric|contraction|rpow|monic|orthogonal polynomial|infinite.*support' D5/S3/Weil/TestFunctions D5/S3/Observer/Hilbert D5/S3/Analytic/GoldenTomography` 定位到 `FinitePronyAnnihilatorUniqueness` 的首一有限根积及 `LiCurvatureFourierRepresentation` 的抽象 Fourier 表示;这是候选定位,尚未把它们当实际零点接口。

出网实测: 2026-09-09,Loogle `https://loogle.lean-lang.org/json`。命令模板(每个 q 分别调用):

```sh
set -o pipefail
curl -fsS --max-time 25 --get 'https://loogle.lean-lang.org/json' --data-urlencode 'q=<下表查询>' | jq '{count,error,header,hits:[.hits[:4][]? | {name,module,type}]}'
```

| q 原文 | 服务返回 count | 已打开的读数与界限 |
| --- | ---: | --- |
| `"integral"` | 4101 | 能力烟测,服务只给前 200;首次原始输出被截断,不作为全量结果 |
| `MeasureTheory.Measure, "sum"` | 366 | 返回 measure preimage 的 sum/tsum 等;服务只给前 200,本席打印前 4 |
| `MeasureTheory.integral_mono_ae` | 1 | 完整类型: 两函数 Integrable + a.e. 序关系推出积分序关系 |
| `"limsup"` | 222 | `Filter.limsup`、`blimsup`、常值公式等;服务只给前 200 |
| `Polynomial.Monic, "prod"` | 29 | `Polynomial.monic_prod_of_monic` 等一般首一乘积声明 |
| `"gram"` | 589 | 前 4 为 metaprogramming/histogram 噪声;不得冒充 Gram 矩阵命中,下一批收窄 |
| `"orthogonal", "polynomial"` | 0 | 同一声明名同时含两词的检索无命中;不排除别名或不同表述 |
| `"moment"` | 14 | `ProbabilityTheory.moment/centralMoment` 等;非完整单位圆矩问题 |
| `"tendsto_rpow"` | 19 | `Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics` 中若干幂极限 |

以上是 **在线索引读数,不是本仓 pin 的声明保证**;任何用于探针的命中仍须在钉版源码中核对,再经 `make lean`。未主张第三方生态检索穷尽,也未登记新的 AxiomDebt。

### 批次 5: 钉版库命中与构建供给

`git -C .lake/packages/mathlib rev-parse HEAD` 实得 `db584cd6d46c92f209a44c0f1c829460d327499d`,与本仓 pin 一致。首次 `make lean` **exit 0**,末行 `Build completed successfully (12685 jobs).`;`LEAN_CACHE` 为 `status=seeded, method=clonefile, clonefile_attempts=1, project_olean_state=warm, mathlib_olean_state=warm, mathlib_missing_olean_files=0`,donor 为 `/Users/auricstudio/trureturing`。该次用于取得本树编译环境;没有新探针定理,输出含既有模块 warning,不称零警告。长输出被工具截断,不统计未完整取得的 Built/Replay 行数。

本批已打开以下**钉版源码类型**,将优先直接实例化:

| 部件 | Mathlib 命中 | 所给事实与尚需输入 |
| --- | --- | --- |
| ② | `Polynomial.monic_prod_X_sub_C` (`Algebra/Polynomial/Roots.lean:784`),`Polynomial.Monic.mul/pow`,`Polynomial.natDegree_prod_of_monic` (`BigOperators.lean:217`),`Polynomial.eval_prod` (`Eval/Defs.lean:675`) | 给定有限根集即可得到首一根积、次数与逐点评值;不是本仓新构造原语 |
| ② | `Finset.norm_prod_le` (`Analysis/Normed/Ring/Basic.lean:383`),`norm_prod` (L769),`Finset.prod_le_prod`,`pow_le_pow_left₀` | 距离界、有限乘积界与幂单调性;注意不要误用乘法范数群的同名“和界” |
| ③ | `Submodule.starProjection_minimal` (`Analysis/InnerProductSpace/Projection/Basic.lean:220`),`IsLeast` 的下界投影 | 最小残差不超过任意试验残差;实际 h_n 的识别仍来自 Q1 前置 |
| ④ | `Filter.Tendsto.rpow` (`Analysis/SpecialFunctions/Pow/Continuity.lean:237`),`tendsto_one_div_atTop_nhds_zero_nat` (`Analysis/SpecificLimits/Basic.lean:56`) | 正常数的 n 次根趋于 1;配合幂代数处理固定 K 的估计 |
| ④ | `Filter.tendsto_of_le_liminf_of_limsup_le` (`Topology/Order/LiminfLimsup.lean:306`),`tendsto_order` | 下/上极限夹逼;实数 limsup 需最终有界前件,不可省略 |
| ⑤ | `Polynomial.finite_setOfPred_isRoot` (`Algebra/Polynomial/Roots.lean:140`),`eq_zero_of_infinite_isRoot` | 非零多项式根集有限;不提供实际非平凡零点的无限性 |
| ⑤ | `MeasureTheory.integral_eq_zero_iff_of_nonneg`,`integral_pos_iff_support_of_nonneg` (`Integral/Bochner/Basic.lean:735,753`) | 非负可积函数的零积分/正积分判据;需要正质量或 a.e. 非零,不是单个支撑点的随意代入 |
| ⑤ | `IsClosed.notMem_iff_infDist_pos` (`Topology/MetricSpace/HausdorffDistance.lean:701`),`Matrix.posDef_gram_iff_linearIndependent` (`Analysis/InnerProductSpace/GramMatrix.lean`) | 闭子空间外距离严格正、Gram 严格正定与线性无关等价;有限维闭性和实际独立性仍需识别 |

检索命令与原始匹配行数(路径前缀 `M=.lake/packages/mathlib/Mathlib`,这里只是书面缩写):

| rg 模式 / 范围 | 匹配行数 |
| --- | ---: |
| `rg -n 'monic_prod_X_sub_C\|natDegree_prod_X_sub_C\|eval_prod_X_sub_C\|monic_X_sub_C\|natDegree_mul_monic\|natDegree_pow' M/Algebra/Polynomial` | 55 |
| `rg -n 'tendsto.*rpow.*(one\|zero)\|tendsto.*(root\|nth)\|rpow.*(limsup\|tendsto)\|tendsto_zero.*eventually' M/Analysis/SpecialFunctions/Pow M/Topology/Order` | 31 |
| `rg -n 'infinite.*(zero\|root)\|finite.*(zero\|root)\|tendsto.*(zero\|one)\|summable' M/NumberTheory/LSeries/RiemannZeta*` | 3,均非“非平凡零点无限”声明 |
| `rg --files M \| rg -i '(Orthogonal\|Gram\|Moment\|Liminf\|Limsup)'` | 35 路径,含 grammar/diagram 噪声 |
| `rg -n 'theorem (natDegree_prod\|eval_prod)\|lemma (natDegree_prod\|eval_prod)' M/Algebra/Polynomial` | 5 |
| `rg -n 'theorem tendsto_one_div_atTop_nhds_zero_nat\|lemma tendsto_one_div_atTop_nhds_zero_nat\|theorem inv_tendsto_atTop\|theorem pow_le_pow_left₀\|theorem sq_le_sq₀' M` | 2 |
| `rg -n 'finite.*(eq\|zero)\|finite_zeros\|zero.*finite\|finite_preimage' M/Analysis/Analytic/IsolatedZeros.lean M/Analysis/Analytic/Order.lean` | 3,仅定位解析阶数候选 |

`LiCurvatureFourierRepresentation.lean:38` 的公开类型也已打开:输入是**任意已给的实概率测度** rho,定义 Cayley 推前混合与积分形式的 `normalizedLi`,不输入或输出实际 zeta 零点族。不能把其名中的 Li 当作实际系数识别证据。本席暂不将它新增为 Q2 承重冻结依赖。

### 批次 6: 首次小片段实测

临时片段 `D5/S3/Weil/TestFunctions/HyperContractionProbe0909.lean` 经默认 glob 进入 `make lean`;它只含显式前件的绑定测试,最终将移入本报告目录。调用 `set -o pipefail; make lean 2>&1 | tee <attempt>/lean-probe-1.log | tail -n 65`(shell 中换行,未用裸 lake)。**exit 2,失败**;原始日志为 runner attempt 下 `lean-probe-1.log`。

两条错误均已定位,不作数学反例:

1. L24 `rw` 在 `X-C (id a)` 与 `X-C a` 的乘积之间未命中;需显式 lambda/定义展开。
2. L100 `simpa only` 未展开 `Function.comp`,复合函数与 lambda 未统一。

本次 `trial_bound` 与 `normalized_bound_limit` 已产生 `#print axioms` 读数,均为 `[propext, Classical.choice, Quot.sound]`;仍不把局部成功称整文件通过。原式常数 4、指数 2、K 与 n 未改。下一步只做规范化修正。

收窄的 Loogle 查询(与批次 4 相同 endpoint/结构化解析,打印前 3):`Matrix.gram` 18 命中;`Polynomial.Monic, MeasureTheory.Measure` 0 命中;`"orthogonal", Polynomial` 0 命中;`riemannZeta, "infinite"` 0 命中;`"supergeometric"` 0 命中。零命中只对这些类型/名字查询成立。额外本地查询 `rg -n 'theorem prod_eq_zero\|lemma prod_eq_zero\|tendsto.*inv₀\|tendsto_inv₀\|limsup_le_of_tendsto' M/Algebra/BigOperators/GroupWithZero/Finset.lean M/Topology/Algebra/GroupWithZero M/Topology/Order/LiminfLimsup.lean` 返回 2 条 `Finset.prod_eq_zero` 候选,但因中间目录不存在而 exit 2;这是**部分检索失败**,不得记完整零命中。

第二次片段 `make lean` **exit 2**,日志 `lean-probe-2.log`。上一轮两个规范化点已消除;剩余 L26 参数类型错误和其遗留目标: `natDegree_prod_of_monic` 的 finite-set 与 polynomial-family 为显式参数,本席漏传了它们。该失败仍是调用签名错误,不作为数学缺陷;不加证明预算、不改估计常数。`spectral_distance_tendsto` 在本轮已无错误。

### 批次 7: 片段通过与碰撞读数

第三次 `make lean` **exit 0**,日志为 runner attempt 下 `lean-probe-3.log`;命令为 `set -o pipefail` 后换行执行 `make lean 2>&1 | tee <attempt>/lean-probe-3.log | tail -n 30`。结果包含 `Built D5.S3.Weil.TestFunctions.HyperContractionProbe0909 (11s)` 与 `Build completed successfully (12686 jobs).`。唯一修正是补齐 `natDegree_prod_of_monic` 的显式参数。`trial_bound` 与 `normalized_bound_limit` 的公理读数均仅为 `[propext, Classical.choice, Quot.sound]`。这是抽象前件下的片段通过,不是目标定理通过。

以下计数由完整工具输出逐行计数;`M` 仍为钉版 `.lake/packages/mathlib/Mathlib`。碰撞检查排除本席临时片段,不把自己的新声明算上游命中。

| 命令 | 匹配行数 / exit | 解释 |
| --- | --- | --- |
| `rg -n 'norm_prod_le\|prod_le_pow_card\|prod_le_prod\|norm_prod' M/Analysis/Normed/Group/Basic.lean M/Analysis/Normed/Ring M/Algebra/Order/BigOperators` | 99 / 0 | 乘积界通用工具;此前截断展示的 84 不是总数 |
| `rg -n 'one_div.*atTop.*zero_nat\|inv.*atTop.*zero.*nat\|limsup_le_of_le\|tendsto_of_le_liminf\|limsup_le_iff\|tendsto_order' M/Topology M/Analysis/SpecialFunctions/Pow` | 45 / 0 | 极限与 limsup 工具 |
| `rg -n 'integral.*(pos\|zero_iff\|le_const)\|infDist.*pos\|starProjection_minimal\|finite_setOf_isRoot' M/MeasureTheory/Integral/Bochner/Basic.lean M/Topology/MetricSpace/HausdorffDistance.lean M/Analysis/InnerProductSpace/Projection M/Algebra/Polynomial/Roots.lean` | 43 / 0 | 正性与闭子空间距离工具 |
| `rg -n -i 'hyper.?contract\|super.?geometric\|contraction\|rpow\|monic\|orthogonal polynomial\|infinite.*support' D5/S3/Weil/TestFunctions D5/S3/Observer/Hilbert D5/S3/Analytic/GoldenTomography -g '!HyperContractionProbe0909.lean'` | 20 / 0 | 局部名字候选,不等于语义排除 |
| `rg -n -i 'bb2f81213482f52a1bbf2bbfed1f7fe097d2d9f4949ebb55dc0da2e94d4f1f45\|hyper.?contraction\|super.?geometric\|超几何收缩' D5 Golden/Frozen/state -g '!HyperContractionProbe0909.lean'` | 0 / 1 | 目标名字/atom 阴性 |
| `rg -n -i 'toeplitz_quadratic_eq_integral\|finite_synthesis_gram_distance_inverse' D5 Golden/Frozen/state -g '!HyperContractionProbe0909.lean'` | 6 / 0 | 同范围、同 alternation 特性的阳性;更完整 PCRE 对照见批次 2/3 |
| `rg -n -i 'infinite.{0,50}(riemann\|zeta\|nontrivial)\|(?:riemann\|zeta\|nontrivial).{0,50}infinite' D5 M/NumberTheory` | 62 / 0 | 新发现实际零点无穷性候选,待核类型及冻结片 |

最后一项定位到 `D5/S3/Weil/ZeroInfinitude/ExplicitFormulaObstruction.lean:194` 的 `isNontrivialZero_infinite`,以及 `ZeroData` 相关模块。Loogle 的零命中不能覆盖仓内声明;在核查前不把实际零点无穷性记作缺失或未冻结。

### 批次 8: 实际零点前置的纠正

读取 `ExplicitFormulaObstruction.lean` 的公开类型及其 state 后确认:实际非平凡零点无限性**已有冻结定理**,不能因批次 5 的窄 Mathlib 检索无命中就列作缺失。下列仍是模块 state pin,不是新造的声明 ID。

| 来源 | statement_id | 已核作用域 |
| --- | --- | --- |
| 冻结 GID `D5/S3/Weil/ZeroInfinitude/ExplicitFormulaObstruction`,声明 `isNontrivialZero_infinite` [L194](../../../D5/S3/Weil/ZeroInfinitude/ExplicitFormulaObstruction.lean#L194)、`nonempty_zeroData` L203 | `sha256:9a0cd0b0899d03fb4847cb680718e6e80b6bbde5f8314c960e2b6d9d38608530` | 前者公开类型无额外假设,断言 `{rho : Complex \| IsNontrivialZero rho}.Infinite`;后者给 `Nonempty ZeroData`。不证明本靶的实际权重可和、Li 矩识别或变分式;无穷性本身不推出 RH。 |
| 冻结 GID `D5/S3/Weil/ZetaBridge/ZeroDataNonemptyIffInfinite`,声明 `nonempty_zeroData_iff_infinite` L237 | `sha256:b229afb240722c611063bf4bf3aaae465c7cdd06c7997e298b15bee5c2874945` | 仅给 `Nonempty ZeroData` 与实际非平凡零点无限性的 iff;上行已可供给其右端。该模块关于谱半径有界集有限的内部引理是 private,不冒充公开投影端。 |
| 冻结 GID `D5/S3/Weil/ZeroSum`,结构 `ZeroData` [L72](../../../D5/S3/Weil/ZeroSum.lean#L72) 与 `ZeroData.multiplicity_pos` L89 | `sha256:154bf5eb20dafaf731874c5a333f66d46013e89637103c8b19f9b773f0bceace` | 给定 Z 时可投影不重复且穷尽的零点枚举、准确重数及 `locallyFinite`。结构本身不声明 inhabitant,须由上行的存在端取出。未给式 (27) 的概率测度。 |

以上三份 state 均直接 `cat Golden/Frozen/state/<GID>.lean.json` 实读。另全文打开钉版 `Mathlib/NumberTheory/LSeries/ZetaZeros.lean`:`IsCompact.inter_riemannZetaZeros_finite` L66 给任意紧集与实际 zeta 零点集之交有限;`tendsto_riemannZeta_cofinite_cocompact` L72 给零点子类型的余有限滤子逃离紧集。**谱点外集有限已有更直接的 Mathlib 绑定起点**:对 `r>0`,外点满足 `norm rho < 1/r`,限制于 `closedBall 0 (1/r)` 后取有限子集与像。`rho != 0` 来自非平凡零点实部正。映射 `rho -> 1-rho^(-1)` 在非零零点上单射,是取逆与平移的规范化消去;本批不增加完整证明。

| 命令 | 匹配行数 / exit | 边界 |
| --- | --- | --- |
| `rg -n 'structure ZeroData\|finite\|norm\|height\|tendsto' D5/S3/Weil/ZeroSum.lean` | 14 / 0 | 候选定位,随后读取结构及正重数类型;按保存的完整输出复数纠正前一提交的 12 |
| `rg --files Golden/Frozen/state \| rg -P '(?:ExplicitFormulaObstruction\|ZeroDataNonemptyIffInfinite\|ZeroSum)\.lean\.json$'` | 3 / 0 | 冻结路径存在,另实读 pin |
| `rg -n -P '\b(?:inter_riemannZetaZeros_finite\|tendsto_riemannZeta_cofinite_cocompact)\b' M/NumberTheory/LSeries/ZetaZeros.lean` | 3 / 0 | 1 文档行 + 2 声明行,不是 3 个定理 |
| `rg -n -P '\b(?:inter_riemannZetaZeros_probeNegative0909\|tendsto_riemannZeta_probeNegative0909)\b' M/NumberTheory/LSeries/ZetaZeros.lean` | 0 / 1 | 同 PCRE 词界与分组的阴性对照 |
| `rg -n -F 'h_0=1' docs/develop/theory/QUANTUM-RH.md` | 2 / 0 | L8993 属别处;本段准确出处 L50735,已修正 Q1 的近似行号 |

## Q3: 五部件判形

**整体 `proof_shape: likely-bind-only`, `escape_witness: null`。** 以下区分“已编译的抽象绑定”与“未编译的实际对象连接”;后者没有因此取得 content 身份。所有结论仍在 Q1 的 **RH 条件式**内。片段成功后即停,未继续实现全目标。

### ① 谱点趋于 1 与外点有限

第一尝试是改写 `norm ((1-rho^(-1))-1) = (norm rho)^(-1)`。`spectral_distance_tendsto` 已经 `make lean` 通过:从范数趋于无穷直接复合 `tendsto_inv_atTop_zero`;得到距离趋零,复数点趋于 1 的距离刻画属标准改写。原文的高度趋无穷应理解为绝对高度,或选定向上的零点族;不对任意随意重复的枚举假定趋无穷。

外点有限的直接绑定路径是: `r>0` 且 `norm(w_rho-1)>r` 给 `norm rho<1/r`;钉版 `IsCompact.inter_riemannZetaZeros_finite` 实例化到 `closedBall 0 (1/r)`,再取有限子集与 `rho -> 1-rho^(-1)` 的像。此步不需要新零点计数估计。也可从冻结的 `Nonempty ZeroData` 取 Z 后投影 `locallyFinite`,但没有必要重证该字段。这里只用不同谱点作为有限集,重数留在测度权重。

- `judgment`: **likely-bind-only**(距离极限片段 `bind-only`;实际外集的完整 Lean 语句未编译)。
- `why_not_bind_only`: **未能给出**。已经找到紧集零点有限的一般定理;取逆、有限子集和有限像未提供非绑定中间事实。
- `gap`: 不能只从一条序列的极限推所有谱点外集有限;必须使用全部实际零点的局部有限性。现有 Mathlib 类型已供给该事实,未发现此处源文数学缺陷。

### ② 首一消失多项式与显式界

以有限异常点集 `s`、`K=s.card` 定义 `trial s n = (prod a in s, X-C a)*(X-C 1)^(n-K)`。首一性、`n>=K` 时次数为 n、异常点处为零,分别直接用 `monic_prod_X_sub_C`、首一乘积/幂次数、`eval_prod` 与 `Finset.prod_eq_zero`。对其余谱点,单位圆条件给每因子范数不超过 2,再用 `Finset.prod_le_prod`、幂单调性及幂规范化得到原式 **`4^K*r^(2*(n-K))`**。K=0 与 n=K 未排除,常数和指数未放宽。

- `judgment`: **bind-only**,`trial_monic`、`trial_degree`、`trial_zero`、`trial_bound` 全部通过。异常点零值与其余点上界分别成立;把它们组合成实际测度 a.e. 界还须测度集中于这些谱点。
- `why_not_bind_only`: **无,已被绑定消去**。显式写出 P 只选定库多项式乘积的参数,其全部所需性质由现有通用定理实例化及规范化取得。未观察到第 3.2 条形态 (2) 所需的非绑定构造事实。
- `gap`: 点态界不自动成为任意测度的 a.e. 界。式 (27) 的原子测度提供支撑条件;该实际测度尚未在本席定义。估计链本身未发现数学缺陷。

### ③ h_n 不超过试验积分

对 Q1 的式 (28),把首一 n 次多项式改写为 `X^n-q`,以 `IsLeast (Set.range F) h` 表示达到的最小值,`minimum_le_trial` 只是 `hmin.2` 的投影,已通过。概率积分的下一步也单独通过:`probability_integral_bound` 直接实例化 `integral_mono_ae`,保留 Integrable 与 a.e. 上界前件,由概率质量把常数积分化为常数。

- `judgment`: **bind-only,以变分识别为前件**。没有把 Q1 的散文式 (28) 伪装成已冻结 Lean 等式。
- `why_not_bind_only`: **无,已被最小值下界投影消去**。另行证明此比较不产生数学新事实。
- `gap`: 单有抽象矩积分公式尚不识别原来的 Schur 余量。必须识别实际 L2(mu)、低次幂合成 V、x=z^n、Gram 与普通逆;Q2 的距离定理可提供抽象等式,但这些实际对象等式未在本席完成。若只有下确界表述,应用 `csInf_le` 还须非空与下有界;源文的 min 和非负积分能提供这些前件。

### ④ n 次方根、固定 r 极限、r 趋于 0

`constant_nth_root` 与 `normalized_bound_limit` 已通过,直接复合 `Filter.Tendsto.rpow`、`1/n -> 0` 与常数除 n 的极限。固定 `0<r<1` 和 K 时,上界的归一化形式趋于 `r^2`:

```text
(4^K)^(1/n) * r^(2 - 2K/n) -> r^2.
```

从原不等式到此式须在最终 `n>=max K 1` 下用非负实幂单调性、`Real.mul_rpow` 和实/自然指数改写;这段完整等式未编译。最后对每个固定 r 得最终上界,再给任意 epsilon 选 `0<r<1` 且 `r^2<epsilon`,用序拓扑夹逼即可。若沿原文走 limsup,须先用一个固定 r 的估计提供最终有界,再调用库的 limsup 比较和夹逼。**K 可以依赖 r;既不需要 K 对 r 一致,也不交换 n 与 r 两个极限。** n=0 不参与最终根极限。

- `judgment`: **likely-bind-only**(固定 r 的归一化极限核心为已编译 `bind-only`)。
- `why_not_bind_only`: **未能给出**。幂连续性、序极限与任意小上界均有库接口;“对任意 r”自身不是非绑定的“一致估计”见证。本席没有建立新的渐近定理。
- `gap`: 漏掉非负底数、n>0 或 limsup 的最终有界前件会使调用失效;本靶可由前述残差非负和固定 r 上界供给。未发现须新增数学假设的源文缺陷,也未以未编译的极限收束主张全定理已证。

### ⑤ h_n 严格正

先用冻结 `isNontrivialZero_infinite` 消去实际零点无限性前件,再用 `rho -> 1-rho^(-1)` 的单射性得到不同谱点无限。正重数与 `c0>0` 给每个谱点正质量。对非零多项式,`Polynomial.finite_setOfPred_isRoot` 给有限根集,因而可取有正质量且不为根的谱点,再用非负积分正性接口。源文的最小值达到后,`minimum_pos_of_attained` 直接取达到点并投影正性,已通过。另一端 `positive_distance` 直接实例化闭集外 `infDist>0`,已通过;用于有限维低次幂空间时仍须实际线性无关性识别。n=0 单独取 `h_0=1`。

- `judgment`: **likely-bind-only**(达到的正最小值、闭集外正距离两个抽象片段为 `bind-only`)。
- `why_not_bind_only`: **未能给出**。实际零点无限性已冻结,有限根集和正积分判据已在库中;本席未发现非绑定正性见证。
- `gap`: “每个试验积分正”本身不蕴含“下确界正”,例如正数列 `1/(k+1)` 的下确界为 0。必须保留 min 的达到性或有限维闭性,且非根点必须有正质量。源卷式 (27)-(28) 及严格正定论证包含所需数学结构;实际 L2 识别和完整正性证明未编译。

### 片段的逐声明账

本席共 11 个公开探针 theorem,均只依赖 Mathlib,**直接冻结依赖为空 `[]`**。下表每个声明的 `proof_shape` 均为 `bind-only`,`escape_witness=null`,`admission_basis=none(probe-only)`;Q2 的冻结件是已读候选,不是这份片段的虚构 import/依赖边。

| 声明短名(namespace `HyperContractionProbe0909`) | 对应义务及实际绑定 |
| --- | --- |
| `trial_monic` | ②:首一根积与首一幂的乘积 |
| `trial_degree` | ②:首一乘积次数、有限和、`n-K+K=n` |
| `trial_zero` | ②:求值乘积中有零因子 |
| `trial_bound` | ②:三角不等式、有限乘积序、幂单调及规范化 |
| `minimum_le_trial` | ③:最小值的下界投影 |
| `minimum_pos_of_attained` | ⑤:取达到点后代入正性 |
| `probability_integral_bound` | ③/②:积分单调与概率常数积分 |
| `constant_nth_root` | ④:实幂连续性与 `1/n -> 0` |
| `normalized_bound_limit` | ④:乘积/差极限与实幂连续性 |
| `positive_distance` | ⑤:闭集外距离严格正的 iff 投影 |
| `spectral_distance_tendsto` | ①:取逆范数与倒数趋零的复合 |

`sq_nonneg` 加 `linarith only` 也是本席允许的绑定尝试;此处所需非负性已有 `norm_nonneg`/`pow_nonneg`,无须为使用某个 tactic 再造声明。没有因 tactic 名、行数或构造语法把任一片段判为 content。

## Q4: 六栏与逃逸见证

`verdict: revise` 表示修订“最像内容、应进入实施”的候选判断;**不表示定理为假**。`proof_shape: likely-bind-only`,`escape_witness: null`,`admission_basis: none(probe-only)`。②的显式构造与④的固定 r 极限均未通过非绑定性条件,本席不认可其为第 3.2 条形态 (2) 的逃逸见证。完整目标没有 elaborate 的证明项,故也没有可供认证的活依赖路径。

来源分栏: **冻结件**为 Q2 三模块和批次 8 三模块,全部给了实际 state pin;**钉版 Mathlib**为批次 5/8 的已打开类型及已编译调用;**dev 上未冻结件**没有被本席作为本靶承重前置。`WeakQlpDifferentiation` 只用作“代码存在但无 state”的阴性对照,与本靶无数学依赖关系。`LiCurvatureFourierRepresentation` 只读了候选类型,本席未核其 state,不擅自归入未冻结栏或承重冻结栏。

六栏中的 gap 只谈数学前件与逻辑缺口。**未发现源卷此段的确定数学错误;尚未打通某条 Lean 等式不等于发现数学缺陷。** 缺失的实际测度、矩与变分识别指本席已核接口的作用域,不主张全库没有这些端。

| from | steps | gap | escapes | payoff | cost_shape |
| --- | --- | --- | --- | --- | --- |
| 全靶:源卷 RH + 式 (27)-(28);冻结矩/Gram 与实际零点前置;钉版 Mathlib;dev 未冻结承重项 none | 实例化测度/最小残差,选择有限根积,积分比较,固定 r 后取极限 | 抽象接口不能省去实际权重总和、Li 矩、Schur 残差与 L2 距离的同对象识别;源卷提供散文前件,本席未形式化该连接 | null,整体 likely-bind-only | 将短名单第 1 名降为未有 content 依据的探针结论;只处理 RH 条件结论,不推进 RH | 定义与接口实例化占主导;无支持新分析内容的读数,不给小时估算 |
| ①:Mathlib `ZetaZeros`/倒数极限;冻结 `ZeroData` 路径可替代 | 倒数范数趋零;紧球零点有限后取子集与像 | 单条序列极限不足覆盖全谱,须实际零点局部有限;库已给 | 未能给出,likely-bind-only | 不需另做零点计数或重证离散性 | 集合/滤子与 Cayley 坐标改写 |
| ②:Mathlib 多项式、范数、有限乘积、幂 | 构造 P,首一/次数/零值,逐因子界,平方规范化 | a.e. 积分界要实际测度集中在谱点;点态估计自身无已识别缺陷 | none,bind-only | 实测消去首要拟议构造见证 | 4 个多项式片段已通过;停止该部件证明 |
| ③:式 (28);Mathlib `IsLeast`/积分序;冻结 Gram 识别候选 | 取 min 下界,代入 P,概率常数积分 | 不得把抽象矩二次型直接称作原 Schur h_n;须前述同对象识别 | none,bind-only under variational premise | 比较本身无独立内容 | 最小值投影及可积性/a.e. 前件核对 |
| ④:Mathlib rpow 连续性、常数除 n 极限、序极限 | 固定 r 与 K(r),根上界趋 r^2,再取任意小 r | 根比较需非负底数与最终 n>0;limsup 路径需最终有界,不需要 K 对 r 一致 | 未能给出,likely-bind-only;固定 r 核心 bind-only | 未测出新的“一致估计”内容 | 实/自然指数改写与滤子组合;未编译完整收束 |
| ⑤:冻结实际零点无限与正重数;Mathlib 有限根集、正积分、闭集距离 | 正质量非根点使残差正;达到最小值或有限维闭性使 h_n 正 | 正积分逐点成立不足推出 inf 正;必须达到或闭性,且谱点正质量 | 未能给出,likely-bind-only | 排除重复实现零点无限性,保留真正需要的正性前件 | 实际 L2 独立性/Gram 识别;只编译抽象正性端 |

### 碰撞检查与停止点

批次 7 的全 D5 + Frozen/state 目标 atom/标题/英文近名为 **0 行,exit 1**,同范围已有矩/Gram 声明阳性为 **6 行,exit 0**;批次 2/3 和 8 的 PCRE 词界/分组阴阳对照也通过。该结果只排除所搜名字与 atom 标记的碰撞。**语义前置碰撞已实际命中**:矩积分、Gram 距离、实际零点无限、紧集零点有限以及乘积/极限通用工具;不能把目标名字零命中解释为新数学。未执行内容指纹同一性、全库语义等价或 Lean 传递闭包穷尽检查。

停止于用户授权的探针范围:Q1-Q4 已回答,无可辩护的 `why_not_bind_only` 见证,不增加完整目标定理、不申请准入例外。未执行 `make cover`、`make deposit`、冻结或 PR 操作,`Meta/Digestion/**` 只读。

### 最终片段与验证边界

片段位于 [hyper-contraction-probe-0909-snippets.lean](hyper-contraction-probe-0909-snippets.lean)。已通过 `make lean` 的临时 D5 源码共 106 行,原样移至此处;编译时的 SHA-256 为 `ac641497349d9862a70b82af70d6f30eed9cc1c86e3b7c1dcc62979164cb1b25`。报告目录不在 D5 的常规 glob 中,本席不声称它移入文档目录后会自动进入生产构建。重放时可将同一字节临时置于记录的 D5 路径并执行 `make lean`。

验证读数:首次环境构建通过;两次片段调用失败如批次 6 记账;第三次片段构建 exit 0、12686 jobs。只查看了两个关键声明的显式 `#print axioms` 输出,不把这两个列表冒充所有声明的逐个公理审计。未运行无关 harness/治理全检,未调整 `maxHeartbeats`、`maxRecDepth` 或估计常数。

`ASSUMED-UNVERIFIED`:源卷 DLMF/arXiv 外链未打开;第三方索引与本仓 pin 的全量一致性未验证(实际使用的命中已本地核对);实际式 (27)-(28)、全目标、完整 nth-root 收束和正性连接未编译;未重放冻结 pin 完整性验证、未做穷尽碰撞/依赖闭包检查。在线 Loogle API 与 #6503 正文实际已打开,不列作未打开页面。

报告与片段随每批提交推送;runner `result.json` 的 `pushed.commits` 保存完整 SHA 列表,避免在报告内写入自身提交哈希产生递归。

最终交付核验批次(检查树 `27a1894a2df65f0344a5159af07c2712ebcce32e`,本次追加仅记录读数):

- `git diff --check 5a29f572a2b0f4dc207528a819efe8552500d86e HEAD`:exit 0,无输出。
- `git diff --name-status 5a29f572a2b0f4dc207528a819efe8552500d86e HEAD`:恰 2 条 A,即本报告与相邻片段;无生产 D5、冻结片或消化账净改动。
- `git status --short --branch`:工作树干净,跟踪本探针远端分支。`git ls-remote --heads origin refs/heads/lane/math/hyper-contraction-probe-0909`:远端确为上述检查树。
- `shasum -a 256 docs/reports/digestion/hyper-contraction-probe-0909-snippets.lean`:与编译时 SHA-256 完全一致,片段保持 106 行。
- Node 使用 `fs.readFileSync` 与 `source.includes(block)` 核验本报告前 4 个 `text` 块:测度原文、质量等式、变分式、严格正定论证 **4/4 逐字匹配源卷**;使用 `path.resolve` 与 `fs.existsSync` 检查 Markdown 本地链接,坏链接 **0**。这是文本出处检查,不是新的数学证明或 Lean 构建。

上述核验批次亦独立提交推送。最终提交完整 SHA、远端 tip 复核及 runner 工件路径记录于 `result.json`;`result.json.tmp` 和 `completion.sentinel.tmp` 均先写好再分别原子重命名发布。判形依据来自本地钉版源码与本地编译,联网检索仅用于定位上游候选。

## 明确未主张

未证该定理;未主张可证;未主张检索穷尽;未主张与 RH 有任何蕴含关系。片段只核验显式抽象前件下的绑定,不定义实际 zeta 测度,不构成全目标证明。
