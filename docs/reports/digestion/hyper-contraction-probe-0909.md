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
- Q2: 已答,3 个候选模块均有冻结状态片;均为有作用域限制的抽象端,实际测度识别未因此完成。
- Q3: 未进入。
- Q4: 未进入。

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

原始定义是 Schur 余量,并非从 inf 开始定义。[L50618](../../develop/theory/QUANTUM-RH.md?plain=1#L50618) 先假设 `T_n` 严格正定,取 `A_n=(r_{j-i})_{1<=i,j<=n}`、`u_n=(r_1,...,r_n)^T`,式 (11) 是 `h_n=1-u_n^T A_n^(-1)u_n`;紧随原文“这里 \(h_n>0\)。”[L50720 附近](../../develop/theory/QUANTUM-RH.md?plain=1#L50720) 另定 `h_0=1`。实际数据来自 [L50454](../../develop/theory/QUANTUM-RH.md?plain=1#L50454) 的 `r_n=c_n/c_0` 与 `T_N=(r_{j-i})_{0<=i,j<=N}`。

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

下列 `statement_id` 是 **模块 state pin**,不是本席重算的单声明 ID。声明全名为相应 Lean namespace 加表中短名;声明 GID 为模块 GID 加 `.<声明短名>`。状态身份直接读取 `Golden/Frozen/state/<模块 GID>.lean.json`,不重放冻结验证。

| 模块 GID / 声明 | state 中的 statement_id | 可用作用域与限制 |
| --- | --- | --- |
| `D5/S3/Weil/TestFunctions/LiCurvatureCriterion` / `toeplitz_quadratic_eq_integral` ([源码 L97](../../../D5/S3/Weil/TestFunctions/LiCurvatureCriterion.lean#L97)) | `sha256:6a1e756aa2727dd386a310293dc7ad58dab820b7fe82f2db9dd6f30ab6105a39` ([state](../../../Golden/Frozen/state/D5/S3/Weil/TestFunctions/LiCurvatureCriterion.lean.json)) | 对任意 `mu : Measure Circle`、`[IsFiniteMeasure mu]`、有限系数 `Fin (N+1) -> Complex`,给 Toeplitz 二次型等于多项式模方的复积分。**不构造实际零点测度,不证明其总质量,不识别实际 Li 系数,不提供变分最小值或严格正性。** `circleMoment mu n` 用 `z^(-n)`,源文用 `z^n`;需显式统一指标/共轭对称。 |
| `D5/S3/Observer/Hilbert/FiniteSynthesisGramDistance` / `finite_synthesis_gram_distance`, `finite_synthesis_gram_distance_inverse` ([源码 L69](../../../D5/S3/Observer/Hilbert/FiniteSynthesisGramDistance.lean#L69),[L118](../../../D5/S3/Observer/Hilbert/FiniteSynthesisGramDistance.lean#L118)) | `sha256:f253af735663b2bdb2434a2f716c7e707723d8f658a3acbc1adc9cd442b8ecda` ([state](../../../Golden/Frozen/state/D5/S3/Observer/Hilbert/FiniteSynthesisGramDistance.lean.json)) | `RCLike` 实/复域,有限维内积系数空间 E、完备 Hilbert 空间 H、`V : E ->L H`,给 `infDist x range(V)^2` 的 Moore-Penrose Gram 公式。普通逆版另给 `G : E ≃ₗ E` 与 `hG : G.toLinearMap = gram V`。**不要求 H 有限维;一般版不要求 Gram 可逆。** 要识别源 h_n,仍须把 H、V、x 实例化成实际 `L2(mu)`、低次幂合成与 z^n,核对 Gram/内积/范数及普通逆。**不提供实际测度、谱无限性、超几何极限。** |
| `D5/S3/Weil/TestFunctions/ToeplitzContactSupport` / `toeplitz_contact_support` ([源码 L80](../../../D5/S3/Weil/TestFunctions/ToeplitzContactSupport.lean#L80)) | `sha256:a4bba9f0782f9ada25b3fecf19631a21a6c7f13d714795d777647659296953b7` ([state](../../../Golden/Frozen/state/D5/S3/Weil/TestFunctions/ToeplitzContactSupport.lean.json)) | 假设 `completion = alpha • normalizedCircleHaar + residual`、系数向量单位化、Toeplitz 特征方程,才给 residual 支撑在 contactPolynomial 零点及有限原子展开,原子数不超过次数。**不是无前件的“任意零残差就严格正”;不证明实际谱无限。** 若用于严格正性反证,尚须提供 alpha=0 的实例、归一化与核向量。 |

补充边界: 第一模块的 `li_curvature_criterion` ([L359](../../../D5/S3/Weil/TestFunctions/LiCurvatureCriterion.lean#L359)) 把 `liCriterion`、曲率递推、`rhFourierRepresentation` 和全阶 `circleHerglotzRepresentation` 均列为**显式假设**。不能凭该模块已冻结,就移除它们或宣称已有实际 RH 测度。

因此 #6503 所称“端可接”的可核实含义是上述 **抽象矩积分/距离接口存在且冻结**。本轮已核出的“只给 RH 就输出式 (27)-(28) 的实际对象与识别”端为 `none`。已有端的实例化/投影自身均 `bind-only`;作用域限制是数学前件,不按代码行数命名为缺陷。

## 明确未主张

未证该定理;未主张可证;未主张检索穷尽;未主张与 RH 有任何蕴含关系。尚无 Lean 片段或构建结果。
