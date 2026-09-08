## [PR #5065] FINITE_OBSERVABLE_TO_FULL_FORM_LIMIT_AND_REPLAY_CORRECTIONS

[PR #5065] The full-Gram owner now includes `reducedMirrorForm_tendsto_fullMixedWeilForm`: for each actual pair of Weil tests, the multiplicity-weighted reduced mirror forms on growing symmetric windows converge to the actual complete mixed Weil form. The proof uses `truncatedZeroSum_tendsto` from the existing ZeroSum owner and the exact mixed factorization. This is a genuine finite-to-full mathematical dependency on the exact observable range layer.

[PR #5065] Pinned root observations 33969082693 and 33969495413 both failed. The first exposed obsolete finite-sum syntax and an unclosed mirror inverse simplification. The second verified the repaired mirror inverse with only standard axioms, then exposed a finite-window unfolding mismatch and a accidentally omitted second ZeroData binder introduced during the source repair. This revision explicitly unfolds `ZeroConfig.window` and restores that binder, without changing the intended theorem statements or admitting a placeholder. Compiler error recovery containing `sorryAx` is rejected as validation evidence. The new frozen source revision still requires its own observed successful root replay and independent required checks before any admission claim.


---

## RH_EQUIVALENCE_ATLAS_20260908

### RH 等价形式图谱：规范对象、跨领域证明与形式化路线

资料核查日期：2026-09-08。项目：`the-omega-institute/trureturing`。

本节在现有 RH 理论卷中建立一个可逐项实现的等价判据图谱。第一版包含 **18 个判据族、64 个规格节点**：A001 是标准 RH，另外 63 个是经典判据或有用的派生表达。这些节点共享若干重大解析定理，不能解释成 63 项彼此独立的新发现，也不声称穷尽文献中一切重参数化的 RH 表述。后续新增判据进入相应判据族，并保留其原始对象、量词和证明来源。

数学目标是同时获得两种成果：对每个具体命题证明 `RiemannHypothesis ↔ P`；对不同领域之间的转换，进一步构造实际函数、矩阵、测度、残差和失败见证。后者使图谱能够承担新的定量研究。

本节给出文献中的数学定理、项目现状、若干完整纸面推导和待实现的接口。**本次增补没有新增 Lean 证明，也没有执行 Lean 编译或核验传递公理闭包。** 表中的“经典”指数学文献中的等价定理，“派生”指从注明的桥梁得到的数学表达；两者都不自动表示对应 Lean 端点已经完成。

### 1. 当前 dev 与所有开放 PR 的接入位置

主要数学源读取固定在 dev `aee1eaff34f997e44f04147cee1010bb482c4c1b`。提交前再次捕获 dev `3a8854105ef7bc1a480c4473cdc50b16d6993146`，树为 `717a3fee18b949f40ce178b595cb7d109fb24981`；本卷 blob 仍为 `1e9316d22d780b370a70aa340009ab0a5604819d`，原文未变。下表的开放 PR head 已再次刷新；这些快照日期不表示执行了全库编译。下列路径均相对仓库根目录；固定版本可用 `https://github.com/the-omega-institute/trureturing/blob/<commit>/<path>` 读取。

#### 1.1 应复用的数学真源

| 现有真源 | 本次读到的数学内容 | 图谱中的使用方式 |
| --- | --- | --- |
| `D5/S3/Weil/ZeroData/UnconditionalCanonicalZeroData.lean` | 无外部解析参数的 `zetaZeroData`，实际非平凡零点的穷尽性、唯一索引、正解析重数、反射与共轭；blob `a5ef2be4da1c3a6cf361b911d447bacc22be622f` | 所有零点判据共用这一实际对象。旧文档中“尚无 ZeroData 实例”的说法不再适用。 |
| `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.lean` | 从 `xiReading` 导数定义的 Li 系数、全部阶数的 Taylor 系数恒等式、局部生成展开及第一系数正性；blob `0fb04eb79f87389016b51af25cdf6078d5616b7c` | 不另定义替代 Li 序列。局部展开与全单位圆盘展开分开登记。 |
| `D5/S3/Weil/Separator/ExplicitFormulaWeilCriterion.lean` | 实际零点和与 pole-minus-prime-plus-Archimedean 表达的运输；签名仍有每个卷积平方的 Archimedean 收敛输入 | 固定 canonical ZeroData 后，继续从相应解析真源构造收敛证明。不要删除该输入而不提供证明。 |
| `D5/S3/Weil/TestFunctions/LiCurvatureCriterion.lean` | 有限 Toeplitz Gram 恒等式、几何多项式能量、二阶差分重建；blob `b509cde8c62c3ed60756cfc9264b98cf357102d2` | 主等价定理目前仍接收 Li 判据、RH 下 Fourier 表示和无限 Herglotz 表示。第 6 节给出更短的反向证明。 |
| `D5/S3/Observer/Hilbert/NymanBeurlingFiniteGramDistance.lean` | 实际复数半直线 L² 载体、分数部分向量、目标指示函数、有限 Gram 与伪逆距离公式；blob `0bec9ac0ed53094607b7e34a7555aac7a3ebd6c8` | 在真实算术函数上完成 Nyman–Beurling 解析桥，直接消费已有有限距离。 |
| `D5/S3/Observer/Hilbert/NymanBeurlingTargetQuotientCriterion.lean` | 闭包成员、商类为零、正交残差为零和有限距离趋零的 Hilbert 等价；blob `a9518c6af492f2cae3dd8d4df58eeb7920a71581` | 当前 RH 连接仍作为 `nymanBeurling` 参数传入；它是待补的解析边。 |
| `D5/S3/Zeros/Jensen/JensenPolynomialObstruction.lean` | Jensen 多项式定义与有限失败见证的逻辑；blob `cb40a8e7c32caa84b36e1d86730fc2d45e903157` | 当前两个 Jensen–Pólya 桥仍是参数，且 RH 参数可为任意命题。最终端点必须使用实际 ξ 系数与标准 RH。 |
| `D5/S3/Constants/NewtonHankelRealRootCriterion.lean` | 共轭稳定有限根族的实根性与 Newton–Hankel 半正定双向证明；blob `1b30a277e90ec2fdca2e10712bdc543c37acc195` | 复用其插值负方向；为实际 Jensen 多项式构造根枚举或 companion-trace 适配器。 |

本卷已有 #5065 的共同 Burnol packet、多轨道完整 Weil 负子空间、实际 Gram 负指数和有限观察形式到完整混合形式的极限。图谱承接这些成果。新的任务是显式的支撑增长、插值条件数和误差运输，不能把已经写出的共同余项构造重新列为完全空白。

当前 `JensenPolynomialObstruction.PolynomialHyperbolic` 的实际定义要求每个复根为实，因此零多项式不满足它。注释中“包含零多项式”应在后续源维护中修正。本节使用严格正的规范系数，保证需要的 Jensen 多项式非零；次数零的正常数另行处理。

#### 1.2 开放 PR 全量筛选及相关源读取

本次使用无作者过滤的开放 PR 集合，第一页容量 100，第二页返回空集，得到以下 **14 个开放 PR**。全部读取了元数据和正文，并对与图谱直接有关的选定真源作进一步读取；这不是对所有历史 PR、所有文件或所有证明的完整重编译。已经合入的其他作者成果通过当前 dev 接入。表中记录实际 head，避免把正文中的旧 head 当成当前版本。

| PR | 捕获的实际 head | 与本图谱的关系 |
| --- | --- | --- |
| [#5236](https://github.com/the-omega-institute/trureturing/pull/5236) | `f65251d3d85ad5fe7f1e254291e3e56bc3b0ec1a` | PrimeGaps186。正文保留实际积分义务；不能用有限算术检查代替解析定理，不作为 RH 等价边。 |
| [#5284](https://github.com/the-omega-institute/trureturing/pull/5284) | `9adf54557f6ce3aecac3ae09c567e38379e8ca00` | 黄金自动机的有限样本运输。没有加入 RH 数学依赖。 |
| [#5405](https://github.com/the-omega-institute/trureturing/pull/5405) | `aaee9b75616627192369518e786fde83c06e4dc0` | 黄金四次幂状态下界。有限前缀与全指标结论的区别适用于本图谱，具体定理不构成 RH 判据。 |
| [#5602](https://github.com/the-omega-institute/trureturing/pull/5602) | `7d01130cfc3ce2d7c3d0c4d99a44843ce70c636f` | 实际 Weil/prolate 模型、完整余项与尺度运输。读取最新 `WeilGroundModeShiftBarrier.lean`，blob `2ab192cdf8db9f892a69606367b3bb986f34b846`；支撑边界及完整形式必须保留。 |
| [#5895](https://github.com/the-omega-institute/trureturing/pull/5895) | `023e6d1eccb223a563939590d301085a220b38f2` | 偶不变子空间的全尾界与归一化读数。偶扇区阈值不能自动替换全空间阈值。 |
| [#5897](https://github.com/the-omega-institute/trureturing/pull/5897) | `b6653823add96ea81c6f3c8cec3dd3db47029cd6` | 方格 hard-core 零点自由区域；未把其图递归定理转称 RH 定理。 |
| [#6029](https://github.com/the-omega-institute/trureturing/pull/6029) | `7e1a8c9b33d28d778d80392da5bb06bdcc966f7f` | 实际相对 Gamma 对角线的正项级数、完整尾界和频率一致窗口修正；对角线正性不足以控制混合项。 |
| [#6033](https://github.com/the-omega-institute/trureturing/pull/6033) | `d54250a5bd1ae4764dc15d876926e8a28b2a2881` | 因果耦合与最优界。没有加入 RH 数学依赖。 |
| [#6038](https://github.com/the-omega-institute/trureturing/pull/6038) | `608ebf0929b708832c268e9a5954f58bfb36574a` | 临时 MUB 文本拼接分支，不登记为数学结果。 |
| [#6114](https://github.com/the-omega-institute/trureturing/pull/6114) | `a65f9130d7f17c3bd6dcf7e450d1d53588ab92d2` | Li 曲率到 Herglotz、负型、Schoenberg 和实际圆周概率半群；读取 `LiCurvatureSchoenbergSemigroup.lean`，blob `d616bc1fc8a8f6176883f942809900136f92d577`。 |
| [#6143](https://github.com/the-omega-institute/trureturing/pull/6143) | `7abe3cf91cbf071d025c4dedef773e69dfbc6602` | MUB 区间证书与覆盖。没有加入 RH 数学依赖。 |
| [#6219](https://github.com/the-omega-institute/trureturing/pull/6219) | `8e3982e87642ba3987239f2a4623e6d7ef4b8e55` | 规范 Li 圆盘等价与零点半径增长障碍；读取 `CanonicalLiDiskEquivalence.lean`，blob `251c989b6312a577d24e87950a267cdefcdaae3f`。 |
| [#6221](https://github.com/the-omega-institute/trureturing/pull/6221) | `b1e737aa90c6a3d0f08e39fe481092b68a0d128a` | Scribe 的真实声明标识输出；有助于定位证明，不充当数学前提。 |
| [#6254](https://github.com/the-omega-institute/trureturing/pull/6254) | `34a2c0fe82403b5028456d02b99f9b2d3b11e320` | 临时 prolate 理论拼接分支，不重复计为独立成果。 |

#6114、#6219 及相关新谱源保留其候选、未执行编译的状态。#6219 已经使用规范导数系数，通过解析方程 `F'=GF` 的延拓与零点阶数排除，给出全圆盘判据的候选双向证明。它没有借用一个作为参数传入的 Li 判据。这是应保留的实质性进展。

### 2. 共同对象与变换约定

#### 2.1 ξ、Ξ、实际零点与 Möbius 圆盘

采用经典归一化

\[
\xi(s)=\frac12s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s),
\qquad \xi(0)=\xi(1)=\frac12,
\qquad \Xi(z)=\xi\!\left(\frac12+iz\right).
\]

在 Lean 中消费现有 `xiReading` 与其端点、整性、函数方程、共轭性质。记 \(\mathcal Z\) 为实际非平凡零点集合，\(m_\rho\) 为解析重数；枚举变化不改变带重数的规范和。

定义

\[
w_\rho=1-\rho^{-1},\qquad
D=\{z\in\mathbb C:|z|<1\},\qquad
F(z)=\xi((1-z)^{-1}),
\]

\[
G(z)=(1-z)^{-2}\frac{\xi'}{\xi}((1-z)^{-1}).
\]

\(G\) 的解析性是需要证明的性质，定义它时不能预先要求整个圆盘零点自由。Lean 对除法的全函数约定也不能把分母零点变成解析延拓证明。

直接代数给出

\[
|w_\rho|^2-1=\frac{1-2\Re\rho}{|\rho|^2},\qquad
w_{1-\rho}=w_\rho^{-1},\qquad
w_{\bar\rho}=\overline{w_\rho}.
\tag{E1}
\]

故临界线对应单位圆，右半临界带的零点对应圆盘内部。若使用 Suzuki 的谱坐标，本节固定 \(\gamma_\rho=i(\rho-\tfrac12)\)，即 \(\xi(\tfrac12-i\gamma_\rho)=0\)。它与惯用正虚部 ordinate 的符号差异必须通过现有坐标适配器处理。[L02, L03]

#### 2.2 规范 Li 系数、曲率及正定性的量词

\[
\lambda_0=0,\qquad
\lambda_n=\frac1{(n-1)!}
\left.\frac{d^n}{ds^n}\bigl(s^{n-1}\log\xi(s)\bigr)\right|_{s=1}
\quad(n\ge1).
\]

局部对数由 \(\xi(1)=1/2\) 选定，所得系数为实数。复用现有第一系数

\[
L=\lambda_1=1+\frac{\gamma_{\!E}}2-\log(2\sqrt\pi)>0.
\]

其中 \(\gamma_E\) 专指 Euler–Mascheroni 常数。定义规范实偶曲率

\[
c_0=1,\qquad
c_k=\frac{\lambda_{|k|+1}-2\lambda_{|k|}+\lambda_{|k|-1}}{2L}
\quad(k\ne0),\qquad \psi(k)=\lambda_{|k|}.
\]

\(T^{(n)}=(c_{j-k})_{0\le j,k<n}\)。仓库 `toeplitzMatrix c N` 的大小为 \(N+1\)，因此 \(n\ge1\) 时它对应参数 \(N=n-1\)。圆周 Fourier 约定沿用

\[
\widehat\sigma(k)=\int_{\mathbb T}z^{-k}\,d\sigma(z).
\]

正定函数 \(h\) 表示：任意有限索引组 \(x_i\) 和任意复系数 \(a_i\) 都满足
\(\sum_{i,j}\overline{a_i}a_jh(x_i-x_j)\ge0\)。条件负定的量词相同，但要求 \(\sum_i a_i=0\)，不等式反向。所有概率测度均为正测度且总质量为一。[L02–L04]

#### 2.3 Jensen 的正偶阶系数

定义

\[
a_n=\frac{n!}{(2n)!}\xi^{(2n)}\!\left(\frac12\right)>0,
\qquad
\xi\!\left(\frac12+z\right)=\sum_{n\ge0}\frac{a_n}{n!}z^{2n}.
\]

严格正性由实际 theta 积分的偶矩给出，应独立形式化。用级数定义整函数
\(\Psi(u)=\sum_{n\ge0}a_nu^n/n!\)，避免依赖平方根分支；有 \(\Psi(-z^2)=\Xi(z)\)。定义

\[
J_{d,m}(X)=\sum_{j=0}^d\binom dj a_{m+j}X^j.
\]

[L05] 的系数归一化为 \(\gamma_n=8a_n\)。这个共同正因子不改变多项式根，但必须先证明与本项目导数定义一致。不能直接拿 \(\Xi\) 的交错 Taylor 系数，或包含恒零奇阶项的序列，替代这里的 \(a_n\)。

#### 2.4 Nyman–Beurling 的两个真实载体

在 \(L^2(0,1)\) 中，令 \(B_0\) 为所有有限复线性组合

\[
\sum_{j=1}^r u_j\{\theta_j/x\},\qquad
0<\theta_j\le1,\qquad \sum_j u_j\theta_j=0.
\]

在 \(H=L^2((0,\infty),dx;\mathbb C)\) 中，定义

\[
\chi=\mathbf1_{(0,1)},\quad v_a(x)=\{1/(ax)\}\ (a\ge1),\quad
S_N=\operatorname{span}\{v_1,\ldots,v_N\},\quad d_N=\operatorname{dist}(\chi,S_N).
\]

\(G_N\) 和 \(b_N\) 分别是这些实际向量的 Gram 矩阵与目标内积列，\(G_N^\dagger\) 是 Moore–Penrose 伪逆。已有真源给出

\[
d_N^2=1-b_N^*G_N^\dagger b_N.
\tag{E2}
\]

Gram 矩阵的半正定性在这里无条件成立；RH 所要求的是完整逼近残差趋零。[L07]

#### 2.5 Weil 的完整形式与有限窗口算子

令 \(Q_W\) 为现有显式公式对应的完整 Weil 二次型，测试函数取复值 \(C_c^\infty(\mathbb R)\)。在与谱坐标匹配的 Fourier 约定下，它的零点侧为

\[
Q_W(f)=\Re\sum_{\rho\in\mathcal Z}m_\rho\,
\widehat f(\gamma_\rho)\overline{\widehat f(\overline{\gamma_\rho})}.
\]

测试函数的固定带衰减、零点计数与绝对可和性需来自真实解析真源。混合形式由同一对象极化；不能把交叉项改成逐零点的模平方。

在窗口 \((-a,a)\) 上，令

\[
\ell(a)=\inf_{0\ne f\in C_c^\infty(-a,a)}\frac{Q_W(f)}{\|f\|_2^2}.
\]

\(A_a\) 专指该实际下半有界形式的 Friedrichs 实现。使用谱判据前，必须构造闭形式、证明核心与算子对应，不能从任意自伴算子出发重新命名。仓库的偶测试函数版本、`Zeta23.EF.weilTest` 的非受限版本和 [L01] 的形式之间分别需要精确适配。记 \(E(g)\) 为现有 `poleTerm - primeTerm + archimedeanTerm` 在实际卷积平方上的实部。[L01, L03]

### 3. 64 个规格节点及其数学等价关系

标签：**R** 为标准根命题，**C** 为文献中的经典判据，**D** 为由本节指明桥梁得到的派生表达。每行都是未来具体端点的目标陈述；实现进度由第 1、10 节的真源与解析义务决定。

所有大 O 都在趋于无穷时使用，\(O_\varepsilon\) 明确表示
\(\forall\varepsilon>0\;\exists C_\varepsilon,X_\varepsilon\;\forall x\ge X_\varepsilon\)，常数允许依赖 \(\varepsilon\)。复数表达的非负性按实 Hermitian 二次型解释。

#### F01. 零点几何与圆盘（A001–A005）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A001 | R | 每个实际非平凡零点 \(\rho\) 满足 \(\Re\rho=1/2\)，使用 Mathlib 的标准 `RiemannHypothesis`。 |
| A002 | D | \(\Xi\) 的每个复零点均为实数。 |
| A003 | D | \(\xi(s)\ne0\) 对全部 \(\Re s>1/2\) 成立。 |
| A004 | D | 对每个实际非平凡零点，\(\vert 1-1/\rho\vert =1\)。 |
| A005 | D | \(F(z)\ne0\) 对全部 \(z\in D\) 成立。 |

依赖：端点填值、真实零点对应、函数方程与 (E1)。A003 的反向使用反射；省略反射只能排除半边零点。

#### F02. Li 系数与解析半径（A006–A013）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A006 | C | \(\lambda_n\ge0\) 对所有整数 \(n\ge1\)。 |
| A007 | D | \(\lambda_n>0\) 对所有整数 \(n\ge1\)。 |
| A008 | D | 实际 \(G\) 在整个 \(D\) 上解析。 |
| A009 | D | 对每个 \(z\in D\)，\(\sum_{n\ge0}\lambda_{n+1}z^n\) 收敛且和为实际 \(G(z)\)。 |
| A010 | D | 对每个 \(0\le r<1\)，\(\sum_{n\ge0}\vert \lambda_{n+1}\vert r^n<\infty\)。 |
| A011 | D | 对每个 \(0<R<1\)，存在 \(C_R\ge0\)，使所有 \(n\ge0\) 满足 \(\vert \lambda_{n+1}\vert R^n\le C_R\)。 |
| A012 | D | \(\limsup_{n\to\infty}\vert \lambda_{n+1}\vert ^{1/n}\le1\)，根指数从 \(n\ge1\) 起。 |
| A013 | D | 对全部 \(n\ge0\)，\(\vert \lambda_n\vert \le L n^2\)。 |

A006 用 Li 定理 [L02, L03]。A007 的严格性由 RH 下正零点贡献和无穷零点得到，\(n=0\) 不包含在严格式中。A008–A012 使用实际 Taylor 恒等式、Cauchy–Hadamard 与 `F'=GF` 的零点阶数论证；A013 的正向见第 6 节，反向通过 A010。#6219 已有其中若干候选端点，不应平行重写。

#### F03. 圆周测度、负型与概率演化（A014–A020）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A014 | D | 规范 \(c\) 的所有 \(T^{(n)}\) 半正定，\(n\ge1\)。 |
| A015 | D | 存在圆周概率测度 \(\sigma\)，使 \(\widehat\sigma(k)=c_k\) 对所有 \(k\in\mathbb Z\)。 |
| A016 | D | 存在圆周概率测度 \(\sigma\)，使 \(\lambda_n=L\int\vert \sum_{j<n}z^j\vert ^2d\sigma\) 对所有 \(n\ge0\)。 |
| A017 | D | 实际 \(\psi(k)=\lambda_{\vert k\vert }\) 在 \(\mathbb Z\) 上条件负定。 |
| A018 | D | 对每个实数 \(t\ge0\)，\(k\mapsto e^{-t\psi(k)}\) 在 \(\mathbb Z\) 上正定。 |
| A019 | D | 存在弱连续圆周概率卷积半群 \((\rho_t)_{t\ge0}\)，\(\rho_0=\delta_1\)，且全部 Fourier 系数为 \(e^{-t\psi(k)}\)。 |
| A020 | D | 存在实 Hilbert 空间、\(\mathbb Z\) 的正交表示 \(U\) 和 cocycle \(b(n+m)=b(n)+U(n)b(m)\)，满足 \(\Vert b(n)\Vert ^2=\psi(n)\)。 |

这里同时需要 Herglotz、Schoenberg 与 cocycle 表示的实际构造。A016 到 A015 可先将测度与共轭推前平均，以获得实偶 Fourier 矩，再应用二阶差分唯一性。A020 不能削弱成任意有指定范数的向量族。#6114 已提供通用构造的候选源；真正的 RH 连接仍要识别规范算术曲率。[L02–L04；第 6 节]

#### F04. Weil 正性、矩阵与实际窗口谱（A021–A026）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A021 | C | \(Q_W(f)\ge0\) 对每个复值 \(f\in C_c^\infty(\mathbb R)\)。 |
| A022 | D | 在现有偶 `WeilTestFunction` 载体上，固定 `zetaZeroData` 的每个完整卷积平方零点和的实部非负。 |
| A023 | D | 每个相同测试函数上的实际 \(E(g)\ge0\)，收敛项与显式公式齐备。 |
| A024 | D | 任意有限实际测试函数组的完整混合 Weil Gram 矩阵半正定。 |
| A025 | D | 对每个 \(a>0\)，\(\ell(a)\ge0\)。 |
| A026 | D | 对每个 \(a>0\)，实际 \(A_a\) 的谱包含于 \([0,\infty)\)。 |

A021–A024 需要两个测试函数载体的完整适配和现有 separator。A025 使用所有支撑窗口的穷尽；A026 使用闭形式与谱定理。有限截断矩阵的正性只有在全尾控制和核心证明完成后才能进入这些端点。[L01, L03]

#### F05. 整函数、Jensen 与 Newton–Hankel（A027–A032）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A027 | C | \(\Xi\) 属于 Laguerre–Pólya 类。 |
| A028 | D | 存在非零、仅有实根的实多项式序列，在每个复紧集上一致收敛到 \(\Xi\)。 |
| A029 | C | 每个 \(J_{d,0}\) 仅有实根，\(d\ge0\)。 |
| A030 | C | 每个 \(J_{d,m}\) 仅有实根，\(d,m\ge0\)。 |
| A031 | D | 对每个 \(d\ge1,m\ge0\)，实际反转多项式 \(x^dJ_{d,m}(-1/x)\) 的带重数根所构成的 Newton–Hankel 矩阵半正定。 |
| A032 | D | A031 中每一个有限矩阵的所有主子式均非负。 |

这里使用 \(\Psi(-z^2)=\Xi(z)\)、正系数和 Jensen–Pólya 定理，再消费现有有限根定理。[L05, L06] 的“固定次数、充分大 shift”结果只覆盖量词的一部分，不能取代 A030。

#### F06. Nyman–Beurling 与最佳逼近（A033–A040）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A033 | C | \(B_0\) 在 \(L^2(0,1)\) 中稠密。 |
| A034 | C | 常数函数 \(1\) 属于 \(\overline{B_0}\)。 |
| A035 | C | \(\chi\in\overline{\operatorname{span}\{v_a:a\in\mathbb R,a\ge1\}}\subset H\)。 |
| A036 | C | \(\chi\in\overline{\operatorname{span}\{v_n:n\in\mathbb N,n\ge1\}}\subset H\)。 |
| A037 | D | \(d_N\to0\)。 |
| A038 | D | \(b_N^*G_N^\dagger b_N\to1\)，按其已证明的实值理解。 |
| A039 | D | 每个 \(h\in H\) 若与全部整数 \(v_n\) 正交，则与 \(\chi\) 正交。 |
| A040 | D | \(\chi\) 在 \(H/\overline{\operatorname{span}\{v_n:n\ge1\}}\) 中的商类为零。 |

A036 的整数限制是 Báez-Duarte 的强化定理 [L07]，不能仅靠 Hilbert 抽象几何推出。A037–A040 的几何大部分已有真源。第 7 节给出实际离线零点在两个原始载体中的连续分离泛函。

#### F07. Möbius 抵消与素数分布误差（A041–A044）

记 \(M(x)=\sum_{n\le x}\mu(n)\)，\(\psi_{\rm vM}(x)=\sum_{n\le x}\Lambda(n)\)，\(\vartheta(x)=\sum_{p\le x}\log p\)，\(\operatorname{li}_2(x)=\int_2^xdt/\log t\)，\(x\ge2\)。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A041 | C | 对每个 \(\varepsilon>0\)，\(M(x)=O_\varepsilon(x^{1/2+\varepsilon})\)。 |
| A042 | C | \(\psi_{\rm vM}(x)-x=O(x^{1/2}\log^2x)\)。 |
| A043 | D | \(\vartheta(x)-x=O(x^{1/2}\log^2x)\)。 |
| A044 | C | \(\pi(x)-\operatorname{li}_2(x)=O(x^{1/2}\log x)\)。 |

依赖实际 Dirichlet 级数、Perron/显式公式、部分求和及 prime-power 余项。[L08]。无条件已有 Mertens 或 Gronwall 极限不能取代这里的 RH 级误差。

#### F08. Robin、Lagarias 与 Nicolas 的整数不等式（A045–A047）

记 \(\sigma(n)=\sum_{d\mid n}d\)，\(H_n=\sum_{j=1}^n1/j\)，\(P_k\) 为前 \(k\) 个素数的乘积，\(\varphi\) 为 Euler 函数。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A045 | C | 对每个整数 \(n\ge5041\)，\(\sigma(n)<e^{\gamma_E}n\log\log n\)。 |
| A046 | C | 对每个整数 \(n\ge1\)，\(\sigma(n)\le H_n+e^{H_n}\log H_n\)。 |
| A047 | C | 对每个整数 \(k\ge1\)，\(P_k/\varphi(P_k)>e^{\gamma_E}\log\log P_k\)。 |

A045 的阈值与严格号、A046 的 \(n=1\) 等号以及 A047 的 primorial 输入必须保留。[L09, L10]。项目已有 Robin 单元证书、素指数重排和 Gronwall 上下包络可复用；它们不自动提供以上全称等价定理。

#### F09. Riesz 与离散 Báez-Duarte 变换（A048–A049）

定义

\[
R(x)=x\sum_{j\ge0}\frac{(-1)^jx^j}{j!\zeta(2j+2)},\qquad
b_k=\sum_{j=0}^k(-1)^j\binom kj\frac1{\zeta(2j+2)}.
\]

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A048 | C | 对每个 \(\varepsilon>0\)，\(R(x)=O_\varepsilon(x^{1/4+\varepsilon})\)，\(x\to+\infty\)。 |
| A049 | C | 对每个 \(\varepsilon>0\)，\(b_k=O_\varepsilon(k^{-3/4+\varepsilon})\)，整数 \(k\to\infty\)。 |

这里 \(b_k\) 与 Li 曲率 \(c_k\) 是不同对象。不得把 \(\varepsilon=0\) 的更强界当作等价式。[L11]。第 8 节给出精确变换与误差义务。

#### F10. 导数零点（A050）

**A050，C，Speiser：** \(\zeta'(s)\) 在 \(0<\Re s<1/2\) 内没有零点。对象是实际解析导数；开带边界、平凡导数零点和极点需分别处理。[L12]

#### F11. Balazard–Saias–Yor 对数积分（A051）

**A051，C：**

\[
I_{\rm BSY}=\int_{\mathbb R}\frac{\log|\zeta(1/2+it)|}{1/4+t^2}\,dt=0.
\]

必须证明对数奇点与无穷尾的积分意义；孤立零点处的取值只能按已证明的几乎处处等价处理。[L13]。截断积分趋零是该积分结论的一个实现方式，有限截断的小值不构成等价定理。

#### F12. Farey 分数的偏差（A052–A053）

Farey 阶数为整数 \(N\)，列出分母不超过 \(N\) 的既约分数 \(0<r_1<\cdots<r_{m_N}=1\)，其中 \(m_N=\sum_{q=1}^N\varphi(q)\)。令 \(\delta_j=r_j-j/m_N\)。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A052 | C | 对每个 \(\varepsilon>0\)，\(\sum_{j=1}^{m_N}\delta_j^2=O_\varepsilon(N^{-1+\varepsilon})\)。 |
| A053 | C | 对每个 \(\varepsilon>0\)，\(\sum_{j=1}^{m_N}\vert \delta_j\vert =O_\varepsilon(N^{1/2+\varepsilon})\)。 |

规模变量为分母上界 \(N\)，不是项数 \(m_N\)。[L14] 的引言准确重述 Franel–Landau 判据；其新的同余类、k-free 分母问题含有更强 L-function/GRH 范围，不能自动纳入普通 RH。

#### F13. Redheffer 算术矩阵（A054）

令 \(A_N\) 的行列为 \(1,\ldots,N\)，当 \(j=1\) 或 \(i\mid j\) 时元素为一，其余为零。

**A054，C：** 对每个 \(\varepsilon>0\)，\(\vert \det A_N\vert =O_\varepsilon(N^{1/2+\varepsilon})\)。精确桥为 \(\det A_N=M(N)\)，见第 8 节。[L15, L16]

#### F14. de Bruijn–Newman 热形变（A055–A056）

定义

\[
\Phi(u)=\sum_{n\ge1}(2\pi^2n^4e^{9u}-3\pi n^2e^{5u})e^{-\pi n^2e^{4u}},
\qquad
H_t(z)=\int_0^\infty e^{tu^2}\Phi(u)\cos(zu)\,du.
\]

该约定满足 \(H_0(z)=\xi(1/2+iz/2)/8\)。令 \(\Lambda_{\rm dBN}\) 为“\(H_t\) 全部零点实当且仅当 \(t\ge\Lambda_{\rm dBN}\)”的实阈值。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A055 | C | \(\Lambda_{\rm dBN}\le0\)。 |
| A056 | D | \(\Lambda_{\rm dBN}=0\)。 |

A056 还消费 Rodgers–Tao 的无条件 \(\Lambda_{\rm dBN}\ge0\) 深定理。[L17]。阈值存在性、热积分与 ξ 的尺度恒等式和这条下界都要独立形式化。

#### F15. 全正函数与双边 Laplace 变换（A057–A058）

\(PF_\infty(k)\) 表示 \(k\) 是非零可积实函数，且对所有严格递增实数列 \(x_1<\cdots<x_r\)、\(y_1<\cdots<y_r\)，所有阶数 \(r\ge1\) 都有 \(\det[k(x_i-y_j)]\ge0\)。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A057 | C | 明确函数 \(K(x)=(2\pi)^{-1}\int_{\mathbb R}e^{-ix\tau}/\xi(1/2+\tau)\,d\tau\) 满足 \(PF_\infty(K)\)。 |
| A058 | D | 存在 \(PF_\infty(k)\) 和 \(a>0\)，使 \(\int_{\mathbb R}k(x)e^{-sx}dx=1/\Xi(s)\) 在整个 \(\vert \Re s\vert <a\) 内绝对收敛并成立。 |

这里 A057 分母使用 **实轴方向的 \(\xi(1/2+\tau)\)**。不能换成经过临界线零点的 \(\Xi(\tau)\)。全正性要求独立的两组有序节点，强于只检验相同节点的 Gram 主子式。A058 是 [L06] 的 Schoenberg 表示的局部条带版本；解析恒等与唯一性将它接回相同的 Ξ。

#### F16. 真实 zeta screw function 与实线概率（A059–A062）

为使对象独立于 RH，先用 [L04] 的原始算术公式定义 \(g_\zeta\)。对 \(t\ge0\)，

\[
\begin{aligned}
g_\zeta(t)={}&-4(e^{t/2}+e^{-t/2}-2)
+\sum_{n\le e^t}\frac{\Lambda(n)}{\sqrt n}(t-\log n)\\
&-\frac t2\left(\frac{\Gamma'}\Gamma(1/4)-\log\pi\right)\\
&+\frac14\left[e^{-t/2}\operatorname{LerchPhi}(e^{-2t},2,1/4)
-\operatorname{LerchPhi}(1,2,1/4)\right].
\end{aligned}
\]

向负数作偶延拓，\(g_\zeta(0)=0\)。完整无条件显式公式给出

\[
g_\zeta(t)=\sum_{\rho\in\mathcal Z}m_\rho
\frac{e^{-i\gamma_\rho t}-1}{\gamma_\rho^2}.
\tag{E3}
\]

须先证明实际算术公式、实值连续性及紧集上一致绝对收敛，不能在定义中假定 \(\gamma_\rho\) 都为实数。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A059 | C | \(K_g(t,u)=g_\zeta(t-u)-g_\zeta(t)-g_\zeta(-u)+g_\zeta(0)\) 的每个有限复 Gram 矩阵半正定。 |
| A060 | C | \(e^{g_\zeta}\) 是某个实线无穷可分概率分布的特征函数。 |
| A061 | D | 对每个 \(v\ge0\)，\(t\mapsto e^{v g_\zeta(t)}\) 在实加法群上正定。 |
| A062 | D | 存在弱连续实线概率卷积半群，其每个时刻 \(v\) 的特征函数恰为 \(e^{v g_\zeta(t)}\)。 |

这是 [L01, L04] 的实际 zeta 概率方向。它与 A019 的圆周概率半群具有相似结构，但载体、频率及 Lévy 测度不同，不能直接识别为同一个半群。

#### F17. 模型空间中的实际范数公式（A063）

取 \(s=1/2-it\)，用 [L03] Proposition 2.1 的实际零点级数定义

\[
G_n^{\rm Suz}(t)=\frac{\xi(s)}{\xi(s)+\xi'(s)}
\sum_{\rho\in\mathcal Z}m_\rho\frac{1-w_\rho^n}{s-\rho},\qquad n\ge1,
\]

并在可去奇点处取解析延拓值。该定义的级数收敛、连续性和实线 L² 性质，以及它与 [L03] 原始对数导数公式的相等，都是需要构造的无条件前置。

**A063，C：** 对每个 \(n\ge1\)，
\(\lambda_n=(2\pi)^{-1}\Vert G_n^{\rm Suz}\Vert _{L^2(\mathbb R)}^2\)。

必须使用这个固定的原始函数族。任意选择范数为 \(\sqrt{2\pi\lambda_n}\) 的向量，既没有定义负系数情形，也没有得到模型空间判据。

#### F18. Volchkov 的嵌套对数积分（A064）

**A064，C：**

\[
\int_0^\infty\frac{1-12t^2}{(1+4t^2)^3}
\left(\int_{1/2}^\infty\log|\zeta(\sigma+it)|\,d\sigma\right)dt
=\frac{\pi(3-\gamma_E)}{32}.
\]

采用 [L18] Eq. (2.1) 所列 Volchkov 表达，避免未规定路径的 `arg zeta`。对极点、零点的对数奇性和两层无穷积分分别证明合法性，不能只用截断数值代替等式。

### 4. 跨领域证明的共同骨架

在标准 RH 根之外，最重要的几条可复用解析链为

```text
actual xi / actual ZeroData / functional equation
  |-- Mobius disk -- canonical Li generator -- coefficient growth
  |                         |-- Li curvature -- circle moments
  |                         |                    |-- negative type / cocycle
  |                         |                    `-- probability semigroup
  |-- explicit formula -- full Weil form -- finite windows / actual spectrum
  |-- even xi coefficients -- Jensen / Laguerre-Polya -- Newton-Hankel
  |-- Mellin transform -- Nyman-Beurling -- original Gram distances
  |-- reciprocal zeta / Mobius sums -- Riesz / discrete transform / Redheffer
  |-- prime error terms -- divisor extrema / Farey discrepancy
  |-- logarithmic integrals -- BSY / Volchkov
  `-- heat deformation / total positivity / actual zeta probability
```

箭头代表要构造的数学映射及其定理，不保证所有箭头已经在仓库完成。已知两条 `RH ↔ P` 可以导出 `P ↔ Q`，但这类命题传递性不会自动产生误差界、矩阵大小、有效截断、测度对应或恢复算法。

同理，RH 等价命题之间的逻辑等价不表示项目中两个观察映射的不可区分核相同。后者必须固定同一原始状态空间并证明实际读出之间的恢复关系。不能凭 64 个闭命题构造新的信息逃逸分数或宣称全体读出有相同内核。

### 5. 当前文献对谱主线的具体修订

Suzuki 的 *Weil's quadratic form via the screw function* 已从 2026-06-08 的 v1 修订为 **2026-08-17 的 v2**。[L01] Theorem 1.1 提供实际 Friedrichs 实现，Theorem 1.3 研究最低谱值的连续性，Theorem 1.4 的正性、单性、偶性及渐近适用于充分小的窗口参数。其最终无穷窗口谱解释仍包含明确提出的猜想。

因此，A025–A026 的全部 \(a>0\) 量词不能由小窗口定理替代。对 #5602、#5895、#6029 的具体接入应保持同一个算术形式、同一个实际模型和完整混合余项。#5602 最新 shift barrier 消费的平移测试还要求物理支撑余量；两次平移使用 \(2t\) 余量，尖锐边界裁剪不自动满足这一条件。

[L19] 的 zeta spectral triples 与 [L20] 的 2026 综述为该路线提供背景。由明确模型得到的函数极限、由真实最低模态得到同一极限、以及将极限连到 RH 是不同定理。当前理论图谱没有将这些尚待完成的比较猜想计作已证明的 RH 等价判据。

Farey 工作 [L14] 已于 2026-09-02 修订到 v3；它与 2025 的 Redheffer 工作 [L16] 提供另外两条现代接口：前者要求区别普通 RH 和带同余类的 GRH，后者要求区别行列式中的 Möbius 抵消与最大奇异向量行为。跨领域联系保留被研究的实际量。

### 6. 完整纸面推导一：有限 Li–Toeplitz 重建

#### 6.1 双重望远镜求和

先不使用 RH。设实序列 \(u_0=0,u_1=L\ge0\)，Hermitian 序列 \(c\) 满足 \(c_0=1\)，并有

\[
u_{n+1}-2u_n+u_{n-1}=2L\Re c_n\quad(n\ge1).
\]

写 \(d_n=u_n-u_{n-1}\)，则 \(d_1=L\)，\(d_{n+1}-d_n=2L\Re c_n\)。先对差分求和，再对 \(d_n\) 求和，得到

\[
u_n=L\left[n+2\sum_{k=1}^{n-1}(n-k)\Re c_k\right].
\tag{E4}
\]

令 \(e_n=(1,\ldots,1)^T\in\mathbb C^n\)。按 Toeplitz 对角线逐条计数，距离 \(k\) 的两条对角线各含 \(n-k\) 项，因而

\[
e_n^*T^{(n)}e_n=nc_0+\sum_{k=1}^{n-1}(n-k)(c_k+c_{-k}).
\]

与 (E4) 比较可得精确恒等式

\[
\boxed{u_n=L\Re(e_n^*T^{(n)}e_n).}
\tag{E5}
\]

因此所有 Toeplitz 矩阵半正定立即推出所有 \(u_n\ge0\)，无需先构造一个无限 Herglotz 测度。删除原反向证明的 Herglotz 前提时，必须显式保留 \(c_0=1\)；旧概率表示曾隐含提供它。

#### 6.2 定量负方向与二次增长

若 \(L>0,u_n<0\)，由于 \(\Vert e_n\Vert ^2=n\)，Rayleigh 商给出

\[
\lambda_{\min}(T^{(n)})\le\frac{u_n}{nL}<0.
\tag{E6}
\]

这是指定矩阵大小和指定见证向量的运输。另一方面，所有两点主压缩半正定给出 \(\vert c_k\vert \le c_0=1\)。由 (E4)

\[
|u_n|\le L\left[n+2\sum_{k=1}^{n-1}(n-k)\right]=Ln^2.
\tag{E7}
\]

对规范 Li 系数，这给出

\[
\text{A014}\Longrightarrow\text{A013}\Longrightarrow\text{A010}
\Longrightarrow\text{A005}\Longrightarrow\mathrm{RH}.
\]

最后两步应复用 #6219 的实际解析延拓候选源，并完成所需编译检查。该反向路线不需要把 Li 判据本身作为参数传入。

#### 6.3 正向使用实际零点的概率测度

在 RH 下，对每个上半平面实际零点 \(\rho\)，写 \(w_\rho=e^{i\theta_\rho}\)。规范零点求和给出

\[
\lambda_n=2\sum_{\Im\rho>0}m_\rho(1-\cos n\theta_\rho).
\]

在 \(w_\rho\) 和 \(\bar w_\rho\) 各放置质量
\(m_\rho(1-\cos\theta_\rho)/L\)。总质量等于一；权重的完整可和性来自实际零点的平方倒数可和性。有限几何级数恒等式给出

\[
\lambda_n=L\int_{\mathbb T}\left|\sum_{j=0}^{n-1}z^j\right|^2d\sigma(z).
\tag{E8}
\]

由此得到规范曲率的圆周表示和 A014。解析重点是将导数定义的 \(\lambda_n\) 与带重数的实际零点和相等，并证明所有交换与尾界；任意抽象 Li-type 序列不够。

#6114 的几何 cocycle、Schoenberg 和概率半群可以在这个实际输入上接通。圆周恒等点处的原子与二次增长项应完整保留，直到针对规范测度给出排除证明。

### 7. 完整纸面推导二：同一离线零点的三种定量见证

设 \(\rho\) 是实际非平凡零点，\(\beta=\Re\rho>1/2\)，并记 \(r=\vert w_\rho\vert \in(0,1)\)。这些推导以存在这样的零点为条件，不断言其存在。

#### 7.1 原始 Nyman Mellin 恒等式

对 \(0<\theta\le1\)、\(0<\Re s<1\)，

\[
\int_0^1\{\theta/x\}x^{s-1}dx
=\frac\theta{s-1}-\frac{\theta^s\zeta(s)}s.
\tag{E9}
\]

可先在 \(\Re s>1\) 将 floor 写为指示函数和并逐项积分，再用左侧在 \(\Re s>0\) 的解析性作延拓，处理 \(s=1\) 的可去抵消。复幂使用正实数的实对数。

在 \(L^2(0,1)\) 上，\(\mathcal L_\rho f=\int_0^1f(x)x^{\rho-1}dx\) 的范数为 \((2\beta-1)^{-1/2}\)。由 (E9) 及 \(B_0\) 的约束，\(\mathcal L_\rho\) 消去整个 \(B_0\)，而 \(\mathcal L_\rho1=1/\rho\)。故

\[
\operatorname{dist}(1,\overline{B_0})\ge\frac{\sqrt{2\beta-1}}{|\rho|}.
\tag{E10}
\]

#### 7.2 直接作用于项目半直线载体的分离泛函

为避免把 (E10) 的范数常数未经证明转移到另一个载体，在原始 \(H=L^2(0,\infty)\) 上直接构造

\[
\mathcal J_\rho f=
\int_0^1f(x)x^{\rho-1}dx
-\frac1{\rho-1}\int_1^\infty\frac{f(x)}x\,dx.
\]

两项的 Riesz 向量支撑不交，故

\[
\|\mathcal J_\rho\|^2=\frac1{2\beta-1}+\frac1{|\rho-1|^2}.
\]

由于 \(v_a(x)=1/(ax)\) 在 \(x>1\) 上成立，(E9) 在 \(s=\rho\) 给出 \(\mathcal J_\rho v_a=0\) 对所有实 \(a\ge1\)；同时 \(\mathcal J_\rho\chi=1/\rho\)。因此对项目中的每个有限整数空间都有

\[
\begin{aligned}
d_N^2&\ge\frac{1}{|\rho|^2\left((2\beta-1)^{-1}+|\rho-1|^{-2}\right)}\\
&=\frac{(2\beta-1)|\rho-1|^2}{|\rho|^4}
=\boxed{r^2(1-r^2)}>0.
\end{aligned}
\tag{E11}
\]

同一界也适用于完整闭包的距离。这是实际半直线函数的连续分离证明，不依赖 Gram 矩阵可逆或有限数值条件数。它应复用仓库的实际 `target`、`sourceVector` 和 `distance` 定义。

#### 7.3 BSY 的同一半径读数

[L13] 的无条件恒等式为

\[
I_{\rm BSY}=2\pi\sum_{\Re\alpha>1/2}m_\alpha
\log\left|\frac\alpha{1-\alpha}\right|.
\]

右侧每项为正，因此给定零点 \(\rho\) 产生

\[
\boxed{I_{\rm BSY}\ge-2\pi m_\rho\log r>0.}
\tag{E12}
\]

这里按全部实际零点带重数计数，不再额外重复乘一个共轭对因子。

#### 7.4 Li 生成函数的同一半径障碍

该零点对应 \(F(w_\rho)=0\)。一旦在半径大于 \(r\) 的圆盘内有实际解析函数 \(G\) 满足 \(F'=GF\)，零点阶数比较就产生矛盾。#6219 的候选 `CanonicalLiRadiusObstruction` 将其量化为：对 \(r<R\le1\)，

\[
\forall N\;\forall C\;\exists n\ge N,
\qquad |\lambda_{n+1}|R^n>C.
\tag{E13}
\]

(E11)–(E13) 使用同一个实际 \(w_\rho\)：它在逼近论中给出正距离，在对数积分中给出正缺陷，在系数空间中排除每一个指定指数包络。由此可以研究转换中的显式常数，而非只依赖命题传递性。

这不提供最早失败指标，也不证明每个充分大的 Li 系数均超过包络。有限 Weil 负方向另由现有 separator 和共同 Burnol packet 构造；将其支撑半径与这里的 \(r\) 定量比较仍是新的研究任务。

### 8. 两条独立的算术变换桥

#### 8.1 Riesz 与二项式离散化

记 \(a_j^\zeta=1/\zeta(2j+2)\)，它与 Jensen 的 \(a_j\) 无关。对 \(x>0\)，完整指数生成关系为

\[
\frac{R(x)}x=e^{-x}\sum_{k\ge0}b_k\frac{x^k}{k!}.
\tag{E14}
\]

证明从有限二项式变换展开，交换绝对收敛级数，再求 \(\sum_{k\ge j}\binom kjx^k/k!=x^je^x/j!\)。实际 Möbius 展开进一步给出

\[
R(x)=x\sum_{n\ge1}\frac{\mu(n)}{n^2}e^{-x/n^2},\qquad
b_k=\sum_{n\ge1}\frac{\mu(n)}{n^2}(1-n^{-2})^k.
\tag{E15}
\]

[L11] 的完整误差比较 \(R(k)/k-b_k=O(k^{-3/2})\) 连同整数之间的控制，将两种增长界接通。形式化必须保留全部 \(n\) 尾部，证明从整数到实变量的运输；只验证有限项的二项式恒等式没有完成 A048–A049。

#### 8.2 Redheffer 行列式精确等于 Möbius 部分和

令 \(D_{ij}=1_{i\mid j}\)，\(1\le i,j\le N\)。它是单位上三角矩阵，且

\[
(D^{-1})_{ij}=\begin{cases}\mu(j/i),&i\mid j,\\0,&\text{其他}.\end{cases}
\]

令 \(u=(0,1,\ldots,1)^T\)，则 \(A_N=D+u e_1^T\)。矩阵行列式引理给出

\[
\boxed{\det A_N=\det D\,(1+e_1^TD^{-1}u)=\sum_{n=1}^N\mu(n)=M(N).}
\tag{E16}
\]

所需核心是除数卷积 \(\mu*1=\varepsilon\)，可以消费已有算术函数库。A054 的有限对象与 A041 的完整渐近完全一致。[L15, L16] 的奇异值研究不替代这一行列式身份。

### 9. Jensen、Weil 与正性的必要区分

对有限共轭稳定根族 \(z_1,\ldots,z_d\)，现有 Newton–Hankel 恒等式是

\[
a^THa=\frac1d\Re\sum_{j=1}^d q_a(z_j)^2.
\]

发现非实共轭根时，实系数插值可令 \(q_a(z)=i,q_a(\bar z)=-i\)，其余不同根取零，得到负方向。这个机制消费 **平方**；替换成 \(\vert q_a(z_j)\vert ^2\) 会使表达自动非负，从而失去检测能力。

Weil 的离线轨道同样通过交叉配对产生不定性，但把有限插值推广到完整零点和，还要控制全部其余零点。项目已有单轨道与多轨道 Burnol 机制负责这一分析层。Jensen 的有限矩阵结果也不能越过实际 ξ 系数与整函数极限。

[L06] 同时指出，某些倒数函数 Taylor 系数构成的矩 Hankel 正性只是 Laguerre–Pólya 的必要条件。它与本项目“给定有限多项式全部根的 Newton–Hankel 判据”是不同命题。不得凭 Hankel 同名把必要条件升级成 RH 等价。

另外，半正定判据要求所有主子式；只有全部顺序领先主子式的弱非负通常不足。严格正定的 Sylvester 判据、半正定判据和全正核的任意两组节点行列式，应各用其实际定理。

### 10. 按共享解析义务推进形式化

以下是实现单元，不是新建 64 个相互独立模块。最终每个公开端点必须以现有标准 `RiemannHypothesis` 和本节实际对象表达，且不接收一个同等困难的 `RH ↔ P` 作为未证明参数。通用引理仍可以参数化，只需与规范算术端点分开。

| 阶段 | 主要工作及复用点 | 完成时应得到的具体成果 |
| --- | --- | --- |
| P0：规范对象 | 复用 canonical ZeroData、xiReading、Li 导数；固定坐标、重数、Fourier 号和 Jensen 偶阶归一化 | A001–A005 的真实几何连接；每个定义与文献对象的对应定理。 |
| P1：Li 与概率 | 在现有曲率真源增加 (E4)–(E7)；接入 #6219 的圆盘分析和 #6114 的概率构造；证明实际导数系数等于规范零点和 | A006–A020 的共享解析闭环；显式有限负方向和指数包络障碍。 |
| P2：整函数与有限矩阵 | 证明实际偶阶系数严格正、Ψ 与 Ξ 的关系、Jensen–Pólya 定理；复用 NewtonHankelRealRootCriterion | A027–A032；实际多项式到矩阵与根失败见证的双向运输。 |
| P3：Nyman 解析桥 | 证明 (E9)、两个连续分离泛函、Beurling 稠密性与整数强化；复用实际 Gram、伪逆和闭包模块 | A033–A040，并得到 (E11) 的原始载体距离下界。 |
| P4：算术与误差 | 复用 Möbius、除数卷积、Mertens 和 prime-power 所有者；补 Perron、部分求和、极值整数及 Farey 运输；证明 (E14)–(E16) | A041–A049、A052–A054。每个 epsilon、阈值和尾部都有实际证明。 |
| P5：完整谱与函数空间 | 接合实际 Weil 载体及 Friedrichs 实现；证明全窗口/核心/谱对应；补 Speiser、BSY、Volchkov、Schoenberg PF、实际 zeta 概率、模型空间与热形变 | A021–A026、A050–A051、A055–A064；较重的共享分析定理可以再分解为有独立用途的子项目。 |

P1 与 P3 的有限恒等式和显式分离泛函可优先推进。P2 具有可直接消费的现有有限根定理。Rodgers–Tao 下界、Nyman 整数强化以及完整显式公式等大型前置按各自原定理实现，不以接口包装计作已解决。

每个最终端点的必要检查包括：两个方向均有证明；原函数和原序列没有被替代；实/复域与全部测试向量正确；重数与截断顺序正确；除法、对数和逆矩阵的定义域正确；无限和及积分换序合法；量词为全阶数、全尺度或全 epsilon；真源与 Scribe 指向同一声明。核验执行后再记录相应版本的编译与公理闭包，文档中的纸面推导不充当机器回执。

### 11. 可以进一步产生研究价值的定量问题

本图谱把“证明等价”与“利用等价”接在一起。近期可以提出以下直接面对原始对象的问题。

第一，给定实际离线零点位置、重数及一个有效邻域，将 (E11)、(E12) 与已有 Burnol 负测试统一为可检查的证书，显式控制测试支撑、次数、矩阵维度和尾误差。现有 (E13) 只保证每条指数包络在任意尾部失败；有效首次失败指标需要新的估计。

第二，将 Jensen 根分离裕量转成 Newton–Hankel 的负特征值裕量，再控制 ξ 系数的有限精度误差。插值条件数、根碰撞与矩阵大小会影响稳定性，不能把多项式根保持定理视为均匀鲁棒性结论。

第三，在 Nyman 原始 Gram 系统中同时控制计算误差和最佳逼近误差。伪逆公式容许奇异矩阵，却不会消除接近奇异时的数值敏感性。若使用正则化，应证明实际残差和正则化残差之间的定量关系。

第四，将 #5602/#5895/#6029 的完整算术余项与 [L01] 的实际形式域接合，研究随窗口无界增长的一致估计。固定窗口和固定扇区的进步保留其价值，但对 A025–A026 的全称命题还需要真正的尺度控制。

后续可扩展到广义 Li/Bombieri–Lagarias 参数族、完整广义 Laguerre 不等式塔、乘子序列、变差递减以及更细的算术极值判据。新条目必须先固定原定理、范围和量词。单个 Turán 不等式、弱 Mertens 加零点单性、某个有限样本成功、或尚未证明的 Hilbert–Pólya 模型，都不能直接加进已知 RH 等价清单。

### 12. 原始文献与精确定位

以下文献按本节用途引用。2026 新稿使用实际版本记录；引文支持指定数学陈述，不表示本次独立重证了每篇全文。经典结果的完整移植仍按第 10 节推进。

- **[L01]** Masatoshi Suzuki, *Weil's quadratic form via the screw function*, [arXiv:2606.09096v2](https://arxiv.org/abs/2606.09096v2), revised 2026-08-17. Theorems 1.1, 1.3, 1.4，形式核心与最终谱极限猜想。相关 PR 中 v1 引用应在实际采用新定理时更新。
- **[L02]** Jeffrey C. Lagarias, *Li Coefficients for Automorphic L-Functions*, [arXiv:math/0404394](https://arxiv.org/abs/math/0404394), Annales de l'Institut Fourier 57 (2007), 1689–1740. Li 导数、零点表达与增长判据的经典来源。
- **[L03]** Masatoshi Suzuki, *Li coefficients as norms of functions in a model space*, [arXiv:2301.05779v2](https://arxiv.org/html/2301.05779v2), 2023. Theorem 1.1；Propositions 2.1–2.2；Li–Weil 特殊测试函数恒等式。该特殊测试函数不属于原始光滑紧支撑类，使用时另证正则化和尾部运输。
- **[L04]** Takashi Nakamura and Masatoshi Suzuki, *On infinitely divisible distributions related to the Riemann hypothesis*, [arXiv:2306.08317v1](https://arxiv.org/html/2306.08317v1), 2023. Theorem 1.1、算术 screw function、实际零点展开及实线无穷可分分布。
- **[L05]** Michael Griffin, Ken Ono, Larry Rolen and Don Zagier, *Jensen polynomials for the Riemann zeta function and other sequences*, [arXiv:1902.07321v2](https://arxiv.org/html/1902.07321v2), 2019. 系数归一化、Jensen 实根塔及固定次数的大 shift 定理。
- **[L06]** Karlheinz Gröchenig, *Schoenberg's Theory of Totally Positive Functions and the Riemann Zeta Function*, [arXiv:2007.12889v1](https://arxiv.org/html/2007.12889v1), 2020. Theorems 1, 3, 4, 8；倒数矩 Hankel 必要条件与充分性的区别。
- **[L07]** Luis Báez-Duarte, *A strengthening of the Nyman-Beurling criterion for the Riemann hypothesis*, [arXiv:math/0202141](https://arxiv.org/abs/math/0202141), 2002. 实际半直线 L² 载体与整数 dilation 强化。
- **[L08]** J. Brian Conrey, *Riemann's Hypothesis*, [author-hosted text](https://aimath.org/~kaur/publications/90.pdf), 2019. 素数计数、Chebyshev 误差与 Möbius 部分和的等价表述；不采用其发表时的有限零点计算数量作为当前数据。
- **[L09]** Jeffrey C. Lagarias, *An Elementary Problem Equivalent to the Riemann Hypothesis*, [arXiv:math/0008177v2](https://arxiv.org/html/math/0008177v2). Main theorem；Robin 判据、Gronwall 与约数和极值背景。
- **[L10]** YoungJu Choie, Michel Planat and Patrick Solé, *On Nicolas criterion for the Riemann Hypothesis*, [arXiv:1012.3613v2](https://arxiv.org/abs/1012.3613v2). Primorial 输入与正反两种 RH 情况下的符号结论。
- **[L11]** Jan Cisło and Marek Wolf, *On the Riesz and Baez-Duarte criteria for the Riemann Hypothesis*, [arXiv:0807.2971v1](https://arxiv.org/abs/0807.2971v1), 2008. 指数生成恒等式、Möbius 表达、Lemma 3 与 Theorem 1 的完整误差运输。
- **[L12]** Farr and Pauli, *Zeros of the derivatives of the Riemann zeta function on the left half plane*, [author-hosted text](https://mat112.uncg.edu/pauli/publications/farr-pauli_zeta-deriv-left-half-plane.pdf). Theorem 1 重述 Speiser 等价；这里只使用该经典零点带判据。
- **[L13]** H. M. Bui, S. J. Lester and M. B. Milinovich, *On Balazard, Saias, and Yor's equivalence to the Riemann Hypothesis*, [arXiv:1306.0856v1](https://arxiv.org/html/1306.0856v1), 2013. Eqs. (1.1)–(1.2)；Theorem 1.2 给出带全部尾项的截断关系。其结果亦说明不能任意假定更强截断衰减率。
- **[L14]** Bittu Chahal, Tapas Chatterjee and Sneha Chaubey, *Distribution of Farey fractions with k-free denominators*, [arXiv:2507.00228v3](https://arxiv.org/html/2507.00228v3), revised 2026-09-02. 本节只消费引言准确列出的普通 Franel–Landau 判据；其带同余类推广不混作普通 RH。
- **[L15]** Herbert S. Wilf, *The Redheffer matrix of a partially ordered set*, [arXiv:math/0408263v1](https://arxiv.org/abs/math/0408263v1), 2004. 算术 incidence 结构与行列式。
- **[L16]** François Clément and Stefan Steinerberger, *On the largest singular vector of the Redheffer matrix*, [arXiv:2502.09489v1](https://arxiv.org/html/2502.09489v1), 2025. 原始矩阵定义、Möbius 行列式背景与独立的奇异向量问题。
- **[L17]** Brad Rodgers and Terence Tao, *The de Bruijn-Newman constant is non-negative*, [arXiv:1801.05914v5](https://arxiv.org/abs/1801.05914v5), revised 2021-07-03. 热核归一化、阈值与无条件下界。
- **[L18]** Yang-Hui He, Vishnu Jejjala and Djordje Minic, *From Veneziano to Riemann: A String Theory Statement of the Riemann Hypothesis*, [arXiv:1501.01975v2](https://arxiv.org/html/1501.01975v2), 2015. Eq. (2.1) 重述 Volchkov 的嵌套对数积分。本文不消费其中推测性的物理解释。
- **[L19]** Alain Connes, Caterina Consani and Henri Moscovici, *Zeta Spectral Triples*, [arXiv:2511.22755v1](https://arxiv.org/abs/2511.22755v1), 2025. 真实谱模型与极限研究背景。
- **[L20]** Alain Connes, *The Riemann Hypothesis*, [arXiv:2602.04022v1](https://arxiv.org/abs/2602.04022v1), 2026. 当前谱路线与算术结构的综述背景。

本图谱的下一步是逐条补齐真实解析边并消费已有真源。完成一个判据族的端到端证明，就将该族的规范对象、双向定理和见证运输接回这里的共同图谱，保留全部尚未完成的量词与分析义务。
