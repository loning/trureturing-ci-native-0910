中央开放边现在被压缩为：

\[
\boxed{
\texttt{FiniteFrequencyOrderedSimplexCoercivity}
\rightarrow
\texttt{HolonomyToFixedScaleWeilTransport}
\rightarrow
\texttt{XiRatioPickKernel}
\rightarrow
\texttt{OfflineZeroPickIndexLowerBound}.
}
\]

---

## [PR #6114] CIRCLE_PROBABILITY_COMPLETION_AND_LI_JUMP_BOUNDARY

日期：2026-09-07。固定源码参照：`05c05729c5cb073dbeb215d8148813db4470952d`。本节继续 GICT VI.3、PZG 27.278–27.279 与 OACC 261.1 的既有概率路线。四个新增 Lean 文件及其 Scribe 位于 `Weil/Probability/`，使用现有 `circleMoment`、`toeplitzMatrix`、`geometricPolynomial` 和 `reconstructedLi`，没有另设 zeta、Li 系数或 Fourier 约定。

本节的数学推导和证明脚本已完成；本轮没有执行 Lean elaboration、内核检查、传递公理报告或 Scribe emission。源码仍是候选形式化。精确有限诊断是第二实现检查，不能替代无限阶定理的内核验证。经典 Herglotz 表示、紧性和卷积 Fourier 公式不作数学优先权主张。

### 1. 实际复用与本轮消除的前提

`TruncatedCircleMomentBridge.truncated_circle_moment_of_posSemidef` 已从每阶 Toeplitz 正半定矩阵构造有限原子测度。`FourierModeDetermination.all_fourier_modes_determine_measure` 已证明完整圆周 Fourier 数据的测度唯一性。`LiCurvatureCriterion` 已证明 Gram 积分、几何多项式能量、二阶递推唯一性与条件性 Li 判据，但其最后一个公共前提仍要求给出一份实现全部阶数的 Herglotz 概率测度。

本轮以 Mathlib 钉版 `db584cd6d46c92f209a44c0f1c829460d327499d` 的概率测度弱拓扑和紧性，把有限见证完成为同一份测度。其后证明实际卷积半群、整列弱收敛及原 Li 型序列重建。旧定理没有显式的 `c(0)=1` 参数；新接口明确加入此归一化，不能声称在任意未归一化输入上删除了测度前提。

### 2. 全部有限矩阵产生同一个概率测度

保持原约定：

\[
\widehat\mu(n)=\int_{\mathbb T}z^{-n}\,d\mu(z),\qquad
T_N(c)_{jk}=c_{j-k},\quad 0\le j,k\le N.
\]

`CircleHerglotzCompletion.circle_herglotz_iff` 的结论是

\[
 c_0=1\quad\Longrightarrow\quad
 \bigl(\forall N,\ T_N(c)\succeq0\bigr)
 \iff \exists!\mu\in\mathcal P(\mathbb T),\ \forall n\in\mathbb Z,\ \widehat\mu(n)=c_n.
\]

共轭对称 `c(-n)=conj(c(n))` 由各阶矩阵的 Hermitian 条件导出。有限表示在零模式的质量因此为一。对每个 N 定义

\[
K_N=\{\mu\in\mathcal P(\mathbb T):\widehat\mu(n)=c_n\text{ for }|n|\le N\}.
\]

每个 K_N 非空、闭，且 K_(N+1) 包含于 K_N。圆周概率测度空间在弱拓扑中紧，因此交集非空。唯一性通过标准 Circle/AddCircle 同胚复用已有 Fourier 测度唯一性，过程中保留了负幂与模式反号。

完整矩剖面是从紧空间到 Hausdorff 乘积空间的连续单射，因而为拓扑嵌入。`continuous_iff_circleMoments` 和 `tendsto_iff_circleMoments` 据此刻画实际弱连续性和任意 filter 下的弱收敛。

`finite_moment_witnesses_tendsto` 进一步证明：若任意选择的概率见证 nu_N 匹配前 N 阶矩，则整列 nu_N 弱收敛到上述同一个 mu。固定模式 n 在 N>=|n| 后已恒等于 c_n；无需相邻见证相同或彼此存在耦合。这里既没有从单个有限 N 推出无限结论，也没有给出收敛速率。

### 3. Fourier 数据构造实际概率卷积演化

`CircleProbabilitySemigroup.circleMoment_mconv` 对 Mathlib 的实际乘法卷积证明

\[
\widehat{\mu\mathbin{*_m}\nu}(n)=\widehat\mu(n)\widehat\nu(n).
\]

卷积是乘积测度在圆周乘法下的推前，证明使用有限测度的可积性及 Fubini。

若 c_t(n) 在 t>=0 连续，满足 c_t(0)=1、c_0(n)=1、c_(s+t)(n)=c_s(n)c_t(n)，且每个 t 的全部 Toeplitz 矩阵正半定，那么 `circle_probability_semigroup_of_fourier` 构造唯一的实际概率族 mu_t，并同时证明

\[
\widehat\mu_t(n)=c_t(n),\qquad \mu_0=\delta_1,\qquad
\mu_{s+t}=\mu_s\mathbin{*_m}\mu_t,
\]

以及 mu_t 的弱连续性。唯一性甚至不要求竞争概率族先具有连续性。

对于任意实序列 psi，psi(0)=0，`exponential_toeplitz_iff_probability_semigroup` 得到全部指数矩阵正性与指定系数 exp(-t psi(n)) 的实际弱连续半群存在性的等价。这一部分没有调用或证明 Schoenberg 定理，指数矩阵的正性仍是前件。

逐项 psi(n)>=0 远弱于该正定条件。精确负对照取 psi(+-2)=1，其余整数为零，在 t=log(2) 时 c_0=c_(+-1)=1、c_(+-2)=1/2。向量 (1,-2,1) 在三阶 Toeplitz 矩阵上的二次型恰为 -1。另一方面，`exponential_probability_forces_nonnegative` 从实际概率矩的模长不超过一导出每个 psi(n)>=0，明确只证明必要方向。

### 4. 同一份测度重建全部原始 Li 型系数

令 L_0=0，a=L_1，且

\[
L_{n+1}-2L_n+L_{n-1}=2a\Re c_n\quad(n\ge1).
\]

`LiCurvatureProbabilityCompletion.normalized_curvature_reconstruction` 从 c_0=1 和全部 T_N(c)>=0 构造上述唯一 mu，再利用已有二阶递推唯一性证明

\[
L_n=a\int_{\mathbb T}\left|1+z+\cdots+z^{n-1}\right|^2d\mu(z)
\]

对每个 n 成立。a>=0 因而导出每个原系数非负。整个原序列同时重建，没有在各阶任意选择不同的概率律。

`li_curvature_criterion_without_herglotz` 将此构造代入原 `li_curvature_criterion`，消除外加的共同 Herglotz 测度前提。实际 derivative-defined Li 判据、原始递推及 RH-to-Fourier identification 仍然公开作为参数，不能把这个适配器写成无条件 RH 定理。

`time_one_li_probability_implies_rh` 还记录：在给定实际算术 Li 判据的情况下，仅一份具有全部 exp(-L_|n|) 矩的 time-one 概率律就足以给出反向蕴含。它没有构造该律；一般指数半群仍使用上一节的全部正性条件。

### 5. 不能丢掉圆周恒等点：精确 Gaussian 项与跳跃项

Herglotz 完成所得概率测度可以在 z=1 有原子。正尺度 Cayley 映射 (x+ib)/(x-ib) 在任何有限实数 x 上都不等于一；因此从任意圆周表示逆向解释为实谱之前，必须处理这个边界点。

`LiCurvatureLevyDecomposition` 从既有几何多项式直接证明

\[
\left|\sum_{j=0}^{n-1}z^j\right|^2=
\frac{2(1-\Re z^n)}{|z-1|^2}\quad(z\ne1),
\qquad
\left|\sum_{j=0}^{n-1}1\right|^2=n^2.
\]

对任意有限 mu 和实数 a，实际 `reconstructedLi` 因而满足

\[
L_n=a\,\mu(\{1\})n^2+
\int_{\mathbb T\setminus\{1\}}
\frac{2a(1-\Re z^n)}{|z-1|^2}\,d\mu(z).
\]

`reconstructed_li_levy_decomposition` 是此精确等式。`li_jump_integrable` 在未假设总跳跃权重可积的情况下证明补偿后的被积函数可积。证明始终保留 (1-Re z^n) 的抵消；不将它拆成两个可能发散的积分。

a>=0 时两个贡献非负。恒等点质量产生下界

\[
a\mu(\{1\})n^2\le L_n.
\]

因此 a>0 且 L_n/n^2->0 蕴含 mu({1})=0。`identity_atom_vanishes_of_subquadratic` 证明的是实际 Borel 测度的原子质量消失。`normalized_curvature_jump_representation` 将共同测度构造、原始递推和这一增长条件合并，从原始 c,L 输入得到同一个无恒等点原子的测度和全部系数的纯补偿跳跃表达；无原子性不是前提。

这解释了一个必须保留的边界：一般正定曲率可以重建 L_n=a n^2，例如 mu=delta_1。该模型不能直接当作实际 Riemann 零点测度。排除恒等点也不会自动证明剩余测度是离散的，或其原子位置、重数恰为实际 zeta 零点。

### 6. 已有概率判据与本轮位置

Nakamura–Suzuki, *On infinitely divisible distributions related to the Riemann hypothesis*, Statistics & Probability Letters 201 (2023), 109889, arXiv:2306.08317，讨论由实际 g_zeta 构造的 exp(g_zeta)。Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096，讨论实际 screw 核与 Weil 形式。当前 arXiv 摘要记录已核对；本轮没有重新独立证明这两篇论文的全部结果。

本轮构造的曲率测度 mu 与演化测度 mu_t 是不同对象；它们的矩分别是 c_n 与 exp(-t psi_n)。它们也没有被未经证明地等同于归一化 Xi 的概率分布或 Nakamura–Suzuki 的实轴概率律。

进一步的纸面连接可以直接从本轮真实能量出发。对整数 n，将有限几何和扩展成 b_n(z)，使 b_(m+n)=b_m+z^m b_n。则 |b_j-b_k|^2=|b_(j-k)|^2。对和为零的有限实系数 r_j，

\[
\sum_{j,k}r_jr_k L_{|n_j-n_k|}
=-2a\int\left|\sum_jr_jb_{n_j}(z)\right|^2d\mu(z)\le0.
\]

这给出标准条件负定证明的具体被积函数。复系数可按实部和虚部分开处理实对称核。把这一步与 Schoenberg 指数正定性接入本轮实际半群构造，是明确的下一形式化接口；本节未把这个纸面推导计入已写出的 Lean 公共声明。

### 7. 执行检查与尚未消除的算术义务

精确诊断采用 seed 20260907 和 Gaussian rational / Fraction 运算：64 个有限概率律，1600 个共轭矩检查，320 个 Gram 恒等式，768 个曲率递推，768 个有限系数重建，1088 个实际卷积矩恒等式，544 个两点族半群矩恒等式，以及各 768 个 Gaussian/jump 分解、原子二次下界和有限原子族极限界。四个负对照分别拒绝逐项非负冒充正定、错误 Fourier 符号、缺失质量归一化和误认不同有限见证相等。这些是作者的第二实现，非独立审稿或无限域验证。

实际 g_zeta 与 xi'/xi 的精确统一、canonical derivative-defined Li 判据、Li 全序列与实际零点测度识别、Schoenberg 的机器接口，以及真正的全局算术正性仍未由本轮消除。固定黄金周期的 Fourier 数据仍有尺度层数盲区；本轮完整圆周矩的唯一性不恢复被周期商映射删去的层数。次二次增长条件也尚未在此增量中从实际算术对象导出。

本轮没有改变旧 Lean、冻结记录、理论吸收状态或工程规范。四个新增 Lean 共 679 行，四个 Scribe 共 144 行，共 23 个公共声明与 23 个 `StatementSource.FromLean()` 绑定。基础理论的末尾原有一个未闭合的显示数学块，本次追加先补齐其闭合符号，再开始本节；既有文字与公式均保留。

参考入口：
- https://arxiv.org/abs/2306.08317
- https://arxiv.org/abs/2606.09096
- Mathlib pin: `Mathlib/MeasureTheory/Measure/Prokhorov.lean`, `ProbabilityMeasure.lean`, `Group/Convolution.lean`, `Integral/Prod.lean`。
