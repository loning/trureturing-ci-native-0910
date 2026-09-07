
参考：CCM `https://arxiv.org/html/2511.22755v1` §8；Suzuki `https://arxiv.org/html/2606.09096v1`；Dusson–Sigal–Stamm `https://arxiv.org/abs/2008.10871`；Mathlib `https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/InnerProductSpace/l2Space.html`，实际 API 以本节所列仓库钉版为准。

---

# 2026-09-07 增补：原算术边界符号与奇异 Gamma 核的积分识别

本节继续 PR 6029，新增 `WeilBoundaryKernelIntegral.lean` 及同名 Scribe。此前 `WeilArithmeticCouplingJet` 已证明原算术符号的 Gamma 级数绝对收敛及其包络，但将该级数识别为实际 Weil 核的积分仍列为纸面步骤。本节给出这条等式的候选 Lean 证明，并将它传递到原 `couplingColumn`。目标继续是 CCM §8 的真实最低模态与 prolate 模型比较；本节补的是其 §4 算术矩阵计算中的分析连接。

## A. 对象、奇异端点与统一支配

令 c≥2、L=log c、ω_n=2πn/L、a_j=2j+1/2。CCM §4.3 的核为
\[
\rho(t)=\frac{e^{t/2}}{e^t-e^{-t}}=\frac{e^{-t/2}}{1-e^{-2t}},\qquad t>0.
\]
原符号的 Gamma 部分是 ∑_{j≥0}ω_n(1−e^{-a_jL})/(a_j²+ω_n²)。证明从这个原对象出发，没有用积分重新定义一个替代符号。

对 0<t≤L，由 e^t≥1+t、e^{-t}≤1 以及 |sin(ωt)|≤|ω|t，得到
\[
\boxed{|\rho(t)\sin(\omega t)|\le |\omega|e^{L/2}.}
\]
`gamma_kernel_sine_integrable` 据此证明正弦加权核在 (0,L] 上可积。核本身在零附近的奇性没有被忽略，也没有删去一个小正区间。表达式在单点零处的全定义除法取值不影响该积分。这里使用可测性及支配来证明可积性，没有错误地声称未延拓的表达式在原点连续。

几何级数给出 ρ(t)=∑_{j≥0}exp(−a_jt)。其各项非负，所以每个有限部分和也不超过 ρ(t)。同一个常数 |ω|e^{L/2} 因此支配所有正弦加权部分和。这个上界用于固定窗口的支配收敛，并非物理尺度增长时的统一谱估计。

## B. 积分与完整 Gamma 级数相等

对 a²+ω²≠0，原函数
\[
F(t)=\frac{e^{-at}[-a\sin(\omega t)-\omega\cos(\omega t)]}{a^2+\omega^2}
\]
的导数为 exp(−at)sin(ωt)。源码实际构造其导数证明，然后应用微积分基本定理。在整数 Fourier 格点上，ω_nL=2πn，端点正弦为零、余弦为一，得到
\[
\int_0^L e^{-a_jt}\sin(\omega_nt)\,dt
=\frac{\omega_n(1-e^{-a_jL})}{a_j^2+\omega_n^2}.
\]
有限和先积分，再通过 A 节支配收敛取极限。原 `arithmetic_boundary_symbol_bound` 提供同一个 Gamma 级数的绝对收敛；两个极限的唯一性给出
\[
\boxed{\int_0^L\rho(t)\sin(\omega_nt)\,dt
=\sum_{j\ge0}\frac{\omega_n(1-e^{-a_jL})}{a_j^2+\omega_n^2}.}
\]
`gamma_boundary_integral` 没有要求调用者提供交换积分与无穷和的结论，也没有假定某个积分恒等式。它包含 n=0 与正负整数频率。脱离整数格点后，一般端点项不消失，不能沿用该简化公式。

## C. 全算术符号与原外部列

相同的原函数在 a=±1/2 处计算极点贡献，得到
\[
\int_0^L2\cosh(t/2)\sin(\omega_nt)\,dt
=-\frac{2\omega_n(\cosh(L/2)-1)}{\omega_n^2+1/4}.
\]
令 K(t)=2cosh(t/2)−ρ(t)。`arithmetic_boundary_symbol_integral` 证明组合被积函数可积，并识别原符号为
\[
\boxed{s_c(n)=\int_0^LK(t)\sin(\omega_nt)\,dt
-\sum_{j<c}\frac{\Lambda(j)}{\sqrt j}\sin(\omega_n\log j).}
\]
全部有限素数幂项与两个极点保持原符号定义的范围和符号。没有用 ζ 零点数据或额外的显式公式假设作为输入。

对于 m∉S，记 φ_{n,m}(t)=[sin(ω_nt)−sin(ω_mt)]/[π(m−n)]。由已证明的可积性、积分线性及有限和运算，`coupling_column_kernel_integral` 将原列识别为
\[
\boxed{A_v(m)=\sum_{n\in S}v_n\left[\int_0^LK(t)\phi_{n,m}(t)\,dt
-\sum_{j<c}\frac{\Lambda(j)}{\sqrt j}\phi_{n,m}(\log j)\right].}
\]
这个伴随定理消费上面的分析结论，输出仍是原 `couplingColumn`。m∉S 保证分母非零，并明确排除将差商的全定义对角值当作真实对角矩阵元。对角 Gamma 项包含单独的原点减项，仍需要其自己的计算。

## D. 对完整残差认证的作用

此前的有限求值、加速 Gamma 余项、零迹偶试探和完整 Hilbert 尾界均使用同一个 s_c。现在该标量符号已连接到论文中的奇异积分表达式，因此这些已有符号包围可传递给同一积分泛函，无须另加两种定义相等的假设。不同求值表示也可以对同一数学对象作交叉核验。

尚须分别完成：零延拓 Fourier 基函数的真实卷积与 φ_{n,m} 的识别、对角项、规范算子域及实际残差的全部坐标。对有限支撑试探，非对角列是所有外部模态的共同部分；本节并未据此把任意具有预定坐标的 Hilbert 向量宣称为规范算子作用，也未新增真实模态误差数字。

## E. 当前真源、文献与诊断

本轮回读 #5602 实际 HEAD `f577bfdff03d4e9e4aa5882272731932481e3c51` 的新增路径与原点归一化提交说明，未重跑其谱证书或重复该研究；另读 `WeilEvenDualStencil`、`WeilGammaLogarithmicSeed` 和 `WeilNeumannGammaBoundary`，它们分别处理有限 stencil、另一类多项式积分和有限 resolvent 边界分解，没有提供本节的积分换限证明。原 Gamma 绝对收敛所有者 blob 为 `2e0d7277d7f92278a4ac9938f0bc342e42cdf94b`。跨作者还回读 #5974 路线的 `HilbertSubspaceAction` 前 80 行，blob `8363575d0b745f2b2b4d00b2d831979a53263648`；其从有限作用量推导实际可积性的组织方式用于审查前提，但未作为本节依赖。

Mathlib 以仓库钉版 `db584cd6d46c92f209a44c0f1c829460d327499d` 的几何级数、导数、FTC 和支配收敛接口为准。CCM §4.3 的原核及 Proposition 4.2 为直接文献对应；§8 的真实模态问题仍为目标。Suzuki 的算子域区别继续适用，本节没有把零迹试探条件强加给真实最低模态。

独立本地诊断实际完成两条符号恒等式、105 个指数正弦积分、各 35 个 Gamma／极点／全算术符号积分比较，以及各 560 个几何部分和与支配界检查。参数为 c=2,3,5,11,17 和 n=0,±1,±3,±9。60 位非定向计算中最大积分差约 3.12×10⁻⁶¹；用于独立参考的 digamma 展开另减去 240 项指数修正，其遗漏部分的解析包络小于 1.07×10⁻¹⁴⁸。该参考包络没有把整个浮点计算变成有向区间证据。

另从真实存档候选 `prime3_certificate.json` 的坐标 0、1、2 构造精确零迹偶试探，使用原正交修正公式，在 m=±3,±7,±16 比较上述两种实际算术列。六项均通过，最大差约 4.87×10⁻⁶³。这个候选是存档有限候选，不能等同于未知真实最低模态；该诊断不宣称新的 prolate 误差改善。六个负控排除了 Gamma 号反转、极点号反转、删去指数端点因子、漏掉第零 Gamma 项、反转差商和脱离格点后误删端点项。

四个公开声明各有配套 FromLean Scribe。源码经过数学与钉版接口审查，尚未执行 Lean elaboration、内核公理闭包或 Scribe 发射，也没有独立证明审稿人。数值诊断未重跑 #5602 的完整谱验证器。全尺度最低模态逼近、新的全空间谱隙和 Xi 极限未在本节闭合。

参考：Connes–Consani–Moscovici, `https://arxiv.org/html/2511.22755v1`, §§2.2、4.3、8；Suzuki, `https://arxiv.org/abs/2606.09096`；NIST DLMF, `https://dlmf.nist.gov/5.7.E6`，后者仅用于独立数值参考。
