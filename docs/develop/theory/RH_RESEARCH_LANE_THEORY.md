- Parallel #5602 source at `4804c4020d7d9f165a2e2683c42b01e3d47a8be4`: `WeilPrimeActivationEdge.lean`, blob `5cd36bfeef88311e1f5e6c140fc11e52b16e8881`; `certify_prime3_scale_schur.py`, blob `496333f97d20a6898d47f848a2abd839249e9207`.


---

## [PR #5602] UNIFORM_TRUE_PROLATE_SCALE_TRANSPORT_AND_CENTERED_MELLIN_FLOW

# 2026-09-08：真实 prolate 尺度族与移动算术窗口的定量 Fourier 传递

本节补齐已在研究分支提交的 `WeilMellinScaleFlow.lean`、同名 Scribe 与 `certify_prime3_prolate_scale_transport.py` 的解析依据。处理的是同一个真正 prolate 模型随尺度的变化；前节提供的真实 Weil 最低模态谱分离是另一个结果。两者不能未经误差桥接就合并为同尺度 ground/prolate 逼近。

本次回读确认，前一轮未交付的六个 `WeilPrimeThresholdParity` / `prime3_scale_interval` 工作产物和原理论卷的 184 行追加已经位于远端，后续 `5d22480c06da2ae5716d804129153ba47e115f2a` 又包含本节六个 scale-flow 工作产物。旧 Lean 真源字节保持不变；Scribe 的过时半径改为 2e-8，Python 仅删去说明注释，结果源哈希同步更新。验证了现行源码，并实际重放 70、100 位的统一 Weil 区间程序和 110、130 位的真实 prolate 尺度程序。以下数学内容追加到原卷，不覆盖并行成果。

## 1. 保持同一个模型及原始 Fourier 约定

令 a0=log3/2，I=[a0-epsilon,a0+epsilon]，epsilon=1/50000000。相应 c=exp(2a) 跨过整数 3，但始终在 (2,4)。固定空间 [-1,1] 上的实际正规 prolate 算子为

\[
J(a)=-\partial_t((1-t^2)\partial_t)+(2\pi e^{2a})^2t^2.
\tag{MF1}
\]

其偶 Legendre 自伴实现、紧 resolvent 和有界乘法势沿用 (PM1)-(PM5)，全部尺度具有相同算子域。psi_(0,a)、psi_(4,a) 是编号 0、2 的真实偶模式，单位归一化并以零阶 Legendre 系数为正固定符号。定义

\[
H_a=\psi_{4,a}-\frac{(\psi_{4,a})_0}{(\psi_{0,a})_0}\psi_{0,a},
\qquad h_a(u)=H_a(e^{-a}u).
\]

实际算术函数为

\[
p_{a,H}(x)=1_{[-a,a]}(x)4e^{x/2}
\sum_{1\le m\le e^{a-x}}H(me^{x-a}),\qquad
p_a^+=(p_{a,H_a}(x)+p_{a,H_a}(-x))/2.
\tag{MF2}
\]

Fourier 仍为原 `Zeta23.paperFT`，即 integral f(x)exp(i*z*x)dx。定义待比较的明确归一化 P_a(z)=FT(p_a^+)(z)/FT(p_a^+)(0)，其分母在本节独立认证。没有将 H_a、p_a、前节 dyadic k_a 或未知 Weil 最低模态相互重新命名。

## 2. 全区间上的真实无限 prolate 谱认证

现行验证器读取原来的 32 维、分母 2^250 的固定提案 v_0、v_4。它们本身不被当作真实特征向量。J(a) 的偶 Legendre Jacobi 矩阵为 D0+q(a)^2 V，q(a)=2pi exp(2a)，V 是真实 t^2 乘法算子。V 对角和相邻项由标准 Legendre 递推给出。遗漏空间的完整形式下界仍为 2K(2K+1)=4160。

在两个固定 dyadic 中心 mu_i 的 mu_i-50 和 mu_i+50 处，对整个 a 区间同时检验有限矩阵与其完整尾修正矩阵的惯性。两种 Schur 端点计数分别为 (0,0;1,1) 和 (2,2;3,3)。所以每个区间有且仅有一个对应编号的真实简单特征值，其余全部无限谱到固定中心的距离至少为 50。不能把有限 Jacobi 矩阵的单独计数当作这一步。

保留参数差的相关性，完整残差满足

\[
\|(J(a)-\mu_i)v_i\|
\le\|(J(a_0)-\mu_i)v_i\|
+|q(a)^2-q(a_0)^2|\,\|t^2v_i\|.
\tag{MF3}
\]

两个范数都包括第 K 个遗漏坐标。谱分解和单位向量相位比较给出 eta_i=sqrt(2)*rhs/50 的模式误差。零阶坐标大于 eta_i 的检查固定同一符号。定向区间结果为 eta_0<3.646331e-8、eta_4<2.319807e-7；对应中心误差也从实际残差重新计算，没有读历史成功 JSON 作谱前提。

令 r=v_(4,0)/v_(0,0)，固定多项式 Htilde=v_4-rv_0。其零阶系数严格为零。真实系数比的误差满足

\[
\delta_r\le(\eta_4+|r|\eta_0)/(v_{0,0}-\eta_0),
\quad
\|H_a-\widetilde H\|\le\eta_4+(|r|+\delta_r)\eta_0+\delta_r.
\tag{MF4}
\]

验证器认证右侧小于 652/10^9；中心版本小于 3.142e-29。固定多项式的范数预算是 1+|r|，一致值预算是 sum_j |Htilde_j|sqrt((4j+1)/2)<7.61，来自真实 Legendre 系数。

## 3. 实际移动窗口的精确尺度流

先保持 H 为固定连续函数。设 s=1/2+iz。对每个整数 m 用 t=m exp(x-a) 代换，得到实际积分

\[
F_{a,H}(z)=4e^{as}\sum_{m\le e^{2a}}m^{-s}
\int_{me^{-2a}}^1 H(t)t^{s-1}\,dt.
\tag{MF5}
\]

在可见整数集合不变的尺度区间内，微分得到

\[
\boxed{\partial_a F_{a,H}(z)=sF_{a,H}(z)
+8e^{-as}\sum_{m\le e^{2a}}H(me^{-2a}).}
\tag{MF6}
\]

新整数刚进入时，其 (MF5) 中积分区间长度为零。因此 F 在激活点连续，左右导数可不同，(MF6) 在每个开区间成立；有限个激活点两侧的统一导数界可以积分相加，得到跨阈值的 Lipschitz 界。没有将 moving-cutoff 项删除，也没有从函数的 L2 支撑差粗略推断线性误差。

对固定偶多项式 H(t)=sum_(r<d) B_r t^(2r)，设 s_r=2r+s。复用原多项式 Fourier 定理，已提交的新 Lean 证明

\[
\boxed{e^{-as}F_{a,H}(z)=4\sum_{m=1}^M\sum_{r<d}
B_rm^{2r}\frac{e^{-s_r\log m}-e^{-2as_r}}{s_r}.}
\tag{MF7}
\]

条件是全部纳入的 m 满足 log m<=2a，Im z<1/2；原 integrand 的可积性由既有 owner 保证。`scaled_polynomial_centered_paperFT` 保存 (MF7)，`scaled_polynomial_paperFT_scale_difference` 将两尺度的上端项精确消去，留下下端指数差。后者要求两个尺度具有同一合法 M；跨激活点的连续拼接是 (MF5)-(MF6) 的纸面步骤，不能误称为该 Lean 声明直接覆盖变动索引集。偶化使用 F(z)、F(-z) 的平均，两个方向都保留。

## 4. 真正变动模式的统一运输

设 a_-、a_+ 为 I 的两端。单个整数项用 t=m exp(x) 代换，再合成并偶化，得到从固定 H 坐标到物理窗口的 L2 算子预算

\[
C=4e^{a_+/2}\sum_{m=1}^3m^{-1/2}.
\]

对 |Im z|<=b，记 W_b=sqrt(2a_+)exp(a_+b)C，W_0=sqrt(2a_+)C。在 D={|z-(20+i/4)|<=1/1000} 上取 b=251/1000，|s|<21。对固定 Htilde，(MF6) 给出导数上界

\[
L_b=21W_b(1+|r|)+24e^{-a_-(1/2-b)}\|\widetilde H\|_\infty,
\quad
L_0=\tfrac12W_0(1+|r|)+24e^{-a_-/2}\|\widetilde H\|_\infty.
\tag{MF8}
\]

这里 24=8*3 保留所有可能可见整数。令 E_I、E_0 为 (MF4) 的区间和中心种子误差。分解真实函数的变化为“当前真实模式减固定多项式”、“同一固定多项式的尺度流”、“固定中心多项式减中心真实模式”，得到

\[
\sup_{a\in I,z\in D}|\widehat p_a^+(z)-\widehat p_{a_0}^+(z)|
\le W_b(E_I+E_0)+\epsilon L_b=:d_b,
\]

\[
\sup_{a\in I}|\widehat p_a^+(0)-\widehat p_{a_0}^+(0)|
\le W_0(E_I+E_0)+\epsilon L_0=:d_0.
\tag{MF9}
\]

只对固定多项式求尺度导数，未假设未知真模式导数或其连续常数。实际 d_b<2.2230e-5、d_0<1.1190e-5。

原中心多项式的 Fourier 端点公式算出原点约为 2.336197886604782；减中心真模式误差得到 beta_0，再减 d_0 得到所有尺度的正下界 beta_I>23/10。这个正下界对应 (MF1)-(MF2) 的固定原始标度；原点归一化结果与非零整体标度无关。中心分子的圆盘上界 M_D 也包含真实模式误差和 Fourier 代表元导数，而非只用中心点值。精确商恒等式给出

\[
\sup_{a\in I,z\in D}|P_a(z)-P_{a_0}(z)|
\le\frac{d_b+M_Dd_0/\beta_0}{\beta_I}.
\tag{MF10}
\]

两种精度的实际验证均得到

\[
\boxed{\inf_{a\in I}|\widehat p_a^+(0)|>23/10,
\qquad \sup_{a\in I,z\in D}|P_a(z)-P_{a_0}(z)|<10^{-5}.}
\tag{MF11}
\]

充分上预算约为 9.54904664569e-6。令 r_(a,z)(y)=conjugate(cos(a z y)-P_a(z)) 于 [-1,1]，直接对指数核估计可再得

\[
\boxed{\sup_{a\in I,z\in D}\|r_{a,z}-r_{a_0,z}\|_{L^2[-1,1]}<15/10^6.}
\tag{MF12}
\]

其实际预算约为 1.41537868833e-5。复共轭不改变范数；r_(a,z) 是针对同一真模型中心化的 Fourier 代表元，尚未假定它在真实 ground 上的读出很小。

## 7. 研究意义、复验及尚缺的连接

前节已经在同一个 I 上认证实际 Weil ground 的简单偶性和大于 4.8e-6 的间隔。本节消除了模型端尚无统一尺度误差及原点分母控制的缺口。不能因此声称 ground/model 的同尺度差已经小：还需要实际 q_a 正交补上的能量对偶试探及完整 residual，或有效的低能谱投影传递。中心尺度已有的 0.00051 归一化 ground/model 圆盘界，也不能未经 ground 传递误差预算就扩展到整个 I。

本次重新核对 CCM arXiv:2511.22755 的官方版本页（取得的记录列出 v1）和正文 Sections 7-8；其模型极限与真实模式充分逼近保持分开。Connes 2026 综述 arXiv:2602.04022 为同一路线背景。实际读取 5040/Mertens 研究链 #6204 的 `GronwallUpperEnvelope.lean`，blob `75eb28885ee1250985d9dbd19b73fa76f3502d04`：该结论是 sigma(n)/(exp(gamma)*n*loglog n) 的渐近上包络，不是本节的算子间隔或 prolate 估计，不将标量渐近移作谱假设。原有 #5882 能量对偶、#5895 正移位形式和归一化消费者继续作为下游目标，未新建通用包装。

现行模型源 SHA-256：`fe1d574f38a13e0dbcc185649c0e6c32dfd9e1cb676ceebb73ad7c6c31218b4f`；固定提案 SHA-256：`242c9897bbd247ef0485039e6dcde819a351c5900ceac52fecc420934c1896db`。本次实际重放 110、130 位定向区间计算，全部惯性、完整残差、符号、原点和误差 guard 通过。110 位结果 Git blob 与远端 `45c149e61156ad85ce1c5cd0cbde1ba297ec790f` 完全一致；其 SHA-256 为 `bd57ff4bf4b7a388dc086519f708ee33b381f1202af25a11cba0d0bfc81f4d0a`。同时重放前节 70、100 位的全空间 Weil 区间证书通过。本轮的重放不等于独立作者审稿。

Lean 的三个公开声明与三个同名 Scribe handles 对应，完整谱实现、积分变换、跨激活拼接和归一化运输仍是上述纸面桥。Lean elaboration、Scribe emission、传递公理报告未执行，没有新增冻结或 CI 状态声明。经典谱残差、Leibniz 公式和商估计不作数学优先权主张。当前窄尺度区间和小复圆盘尚不能推出无界尺度族上的 Xi 极限或 RH。

参考：Connes-Consani-Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1, Sections 7-8；Connes, arXiv:2602.04022；既有 `WeilPolynomialMellinWindow`、`WeilMellinScaleFlow` 和本卷 prolate Jacobi 实现。
