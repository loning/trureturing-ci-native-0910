参考入口：
- https://arxiv.org/abs/2306.08317
- https://arxiv.org/abs/2606.09096
- Mathlib pin: `Mathlib/MeasureTheory/Measure/Prokhorov.lean`, `ProbabilityMeasure.lean`, `Group/Convolution.lean`, `Integral/Prod.lean`。

---

## [PR #6114 continuation] INTEGER_LI_NEGATIVE_TYPE_AND_SCHOENBERG_EVOLUTION

日期：2026-09-07。本次从 `61d71eff45e0632bac5210e763a42f0d50bad02a` 继续上一节。新增三个 Lean 真源及三个对应 Scribe：`FiniteGaussianSchoenberg`、`GeometricLiNegativeType`、`LiCurvatureSchoenbergSemigroup`。上一节已经构造共同圆周测度和从指数正定性到实际半群的接口；本节从原 Li 几何能量证明所需指数正定性，消除这一独立前提。数学推导和候选证明源码已完成，本轮未执行 Lean 内核或 Scribe 编译。

### 1. 使用已有定义的整数 cocycle

原定义保持为 `geometricPolynomial n z = sum_(j<n) z^j` 及 `reconstructedLi sigma a n = a integral |geometricPolynomial n|^2 dsigma`。新增整数延拓

\[
b_n(z)=\begin{cases}n,&z=1,\\(z^n-1)/(z-1),&z\ne1,\end{cases}\qquad n\in\mathbb Z.
\]

`integerGeometric_nat` 证明自然数分支与原多项式逐点相等；没有引入另一套 Li 系数。`integerGeometric_add` 证明

\[
b_{m+n}(z)=b_m(z)+z^m b_n(z).
\]

由此得到负索引公式、恒等点处连续性，以及对所有整数 m,n 和全部圆周点的精确距离式

\[
|b_m(z)-b_n(z)|^2=|\mathrm{geometricPolynomial}_{|m-n|}(z)|^2.
\]

z=1 始终保留，此时距离正是 (m-n)^2。无需无原子性、跳跃总质量有限或次二次增长前提。有限原子诊断只用于重放这些代数等式，源码的陈述是全整数、全圆周。

### 2. 从原测度构造 Gram，推导条件负定性

对任意有限圆周 Borel 测度 sigma、非负 a，以及任意有限整数样本 n_i，定义实际积分矩阵

\[
G_{ij}=a\int\langle b_{n_i}(z),b_{n_j}(z)\rangle_{\mathbb R}\,d\sigma(z).
\]

这里复数被视作实内积空间。`geometricLiGram_quadratic` 通过有限和与积分换序证明

\[
x^T Gx=a\int\left|\sum_i x_i b_{n_i}(z)\right|^2d\sigma(z),
\]

从而 G 正半定。`geometricLiGram_distance` 再证明同一个矩阵满足

\[
G_{ii}+G_{jj}-2G_{ij}=L_{|n_i-n_j|},\qquad L_n=\mathrm{reconstructedLi}(\sigma,a,n).
\]

因此当实系数满足 sum_i x_i=0 时，`reconstructed_li_zero_sum_identity` 给出

\[
\sum_{i,j}x_i x_jL_{|n_i-n_j|}
=-2a\int\left|\sum_i x_i b_{n_i}(z)\right|^2d\sigma(z)\le0.
\]

条件负定性由这个具体积分得出，未作为输入。样本可以有负索引、重复索引或为空；测度可以不归一化甚至为零。零和条件在公共陈述中明确保留。复系数的指数正定性在下一步单独证明。

### 3. 本路线所需的 forward Schoenberg 已有证明源码

`FiniteGaussianSchoenberg` 只依赖 Mathlib。对任意有限实正半定矩阵 G，复系数意义下的矩阵

\[
\left[e^{-t(G_{ii}+G_{jj}-2G_{ij})}\right]_{ij}
\]

在每个 t>=0 都正半定。证明使用钉版 Mathlib 的 Schur product theorem：每个逐项幂 G^(Hadamard k) 都正半定，因此非负 factorial 权重的有限和保持正性。逐项标量指数级数收敛后，对每个有限二次型取极限，得到逐项 exp(2t G) 的正性。接着使用精确因式分解

\[
e^{-t(G_{ii}+G_{jj}-2G_{ij})}
=e^{-tG_{ii}}\,e^{2tG_{ij}}\,e^{-tG_{jj}}
\]

作对角合同变换。实到复的标量扩张通过实际 G=B^T B 分解完成，因此结论检测所有复系数向量，而非只检测实部。这里始终是逐项指数，不是谱意义的矩阵指数。

此结果是经典 Schoenberg 定理的有限 Gram 前向形式。经典结论及其 Hilbert Gaussian 背景可参照 J.C. Guella, *On Gaussian kernels on Hilbert spaces and kernels on hyperbolic spaces*, Journal of Approximation Theory 279 (2022), 105765, DOI 10.1016/j.jat.2022.105765。本轮没有主张新的 Gaussian 正性定理，也没有把一般条件负定核到 Hilbert 嵌入的逆构造计入完成范围。这里的 Li 核已经由上一节的实际 G 明确实现，因此不需要该一般逆构造。

`reconstructed_li_exponential_posSemidef` 把这个定理应用到同一个积分 G，得到 exp(-t L_|n_i-n_j|) 的全有限样本正性。它无需另外提供 Schoenberg、条件负定性、指数正性或 Hilbert 距离表示。

### 4. 原曲率输入构造实际概率演化和全部卷积根

主定理 `normalized_curvature_probability_evolution` 的输入只有：c(0)=1、全部原曲率 Toeplitz 矩阵正半定、L(0)=0、L(1)>=0，以及原始二阶递推

\[
L_{n+1}-2L_n+L_{n-1}=2L_1\Re c_n\quad(n\ge1).
\]

前一轮的 `normalized_curvature_reconstruction` 构造同一个曲率概率测度 sigma，重建全部原 L_n。本轮的实际 Gram 指数正性填入前一轮的半群构造，从而得到唯一的概率演化 rho_t，满足

\[
\widehat\rho_t(n)=e^{-tL_{|n|}},\qquad
\rho_0=\delta_1,\qquad \rho_{s+t}=\rho_s*_m\rho_t,
\]

且 t |-> rho_t 在实际概率测度弱拓扑中连续。没有给正定性换标签，旧接口中的独立指数正性参数在此最终定理中已由证明消除。曲率测度 sigma 与演化测度 rho_t 仍是两个不同对象。

`semigroup_probability_roots` 还给出每个正整数 k 的实际概率卷积根：取 nu=rho_(t/k)，证明从 delta_1 出发 k 次实际乘法卷积得到 rho_t。k=0 被明确排除，t=0 仍被覆盖。主定理同时返回这一结论，无穷可分性没有只作为自然语言标签。

本节无需上一轮用于排除 Cayley 边界质量的次二次增长条件。若 sigma=delta_1，L_n=a n^2，其 Gaussian 型指数同样得到合法概率半群。边界原子是否应在实际 zeta 的谱识别中排除，是另一个算术问题。

### 5. 新的跨账号 canonical Li 来源与仍需证明的算术连接

本轮检索发现 `fkst-loning-s-chrono-macbook-pro[bot]` 的 PR #6172，回读时 open、未合并，head `04104c13633054227c697d2b1234e133b377865d`。实际回读 `Zeros/Endpoints/CanonicalLiLocalExpansion.lean`，blob `0fb04eb79f87389016b51af25cdf6078d5616b7c`：它从实际 `xiReading` 的高阶导数定义 canonicalLiCoefficient，证明全部阶数的局部生成展开及首系数正性。其作者报告的编译不是本轮执行的验证。

因此，先前“canonical Li 定义尚无来源”的描述应按版本修订：当前已有这条在途候选真源。这里没有抄写该定义，也没有把未合并文件默默放进本分支的 import closure。它的局部解析展开仍未提供 RH 与全序列非负性的等价，或归一化实际曲率在全部阶数上的正性。

`normalized_curvature_quadratic_bound` 另从同一个概率表示证明全序列界

\[
0\le L_n\le L_1 n^2.
\]

证明只使用原几何和的模长不超过 n，再对质量为一的 sigma 积分。它不等于上一节用于排除恒等点的次二次渐近，因为 quadratic upper bound 允许非零 n^2 项。

这一界提示了与 #6172 的更直接解析接点，以下仍为纸面推导，未计入本轮 Lean 定理。若将 L 识别为该 canonical 序列，则 G(z)=sum_(n>=0) L_(n+1) z^n 由二次界在单位圆盘内正规收敛。设 F(z)=xiReading(1/(1-z))，它在同一圆盘全纯。#6172 的局部展开给出 F'=G F 在零附近成立；全纯恒等定理可把等式延到整个圆盘。F(0)=xiReading(1)=1/2 非零；全纯方程 F'=G F 不允许有限阶零点，因为导数使零点阶数减一，而右侧的阶数不会下降。因此这条路线可把 canonical 曲率的全部 Toeplitz 正性直接转成 Re(s)>1/2 的实际无零点结论，再用反射处理另一侧。

所需新 Lean 义务是正规收敛、实际复合函数的全域全纯性、局部识别的恒等延拓及零阶排除。这里尚未实现这些步骤，且 canonical 全阶曲率正性本身依然是未证明的算术条件；二次界没有自动证明它。该路线可以减少单独把完整 Li 判据作为外部假设的需要，而不是增加另一份同名的 canonical 系数定义。

Nakamura–Suzuki 的 arXiv:2306.08317 使用实际 g_zeta 的实线无穷可分分布判据；Suzuki 的 arXiv:2606.09096 继续研究实际 screw 核与 Weil 形式。本轮仅核对其主要记录和定位，没有把当前圆周 rho_t 等同于这些实线分布，也没有重新证明两篇论文的完整结果。下一项应使用共享 canonicalLiCoefficient 来源，把真实算术曲率、递推和零点测度识别接到本节已完成的概率分析链上。黄金周期观测丢失的尺度层数也不会被圆周半群自动恢复。

### 6. 执行证据和形式化状态

新增三个 Lean 共 579 行，三个 Scribe 共 144 行，27 个公共声明与 27 个 `StatementSource.FromLean()` 绑定。源码数学审查、注释/字符串感知括号检查和声明匹配已执行。当前运行环境没有 Lean、Lake 或 dotnet；本轮没有得到 elaboration、内核接受、传递公理报告或 Scribe emission。公共端点以及依赖的上一轮源码仍须由钉版工具链检查。未引入自定义 axiom、sorry、admit 或 native_decide。

seed 20260907 的 Fraction/有理复数诊断执行了：1575 项整数 cocycle、1575 项逐点距离、105 项绝对索引能量、48 个原始有限测度、711 项积分 Gram 距离、384 项积分 Gram 二次型、384 项精确零和负型恒等式、384 项复系数负型复核。60 个在 t=k log(2) 上具有精确有理指数值的 Gaussian 矩阵通过 684 个全部主子式检查及 180 个复系数二次型检查；48 个 Schur 级数部分和通过 312 个主子式检查。实际两点概率族通过 833 项卷积矩与 36 项卷积根检查。另有 416 项归一化全序列二次界和 624 项零尺度能量检查。空载体、零测度、零尺度、恒等点原子和重复索引均被覆盖。四个负对照区分逐项非负与正定、缺失零和约束、负尺度和负时间。

完整诊断已重跑且结果逐字节一致。诊断脚本 SHA-256：`c8f0b33e3a3b0a4c4f9a36ab56e4a64fc1e474d511860dcc48d32fac2edb1595`。这些是同一作者的第二实现检查，未执行任意实参数指数的数值证明，也不是内核证明、独立审稿或 RH 数值证据。原理论文字和旧 Lean 均保留；本节只是同一理论卷的追加。
