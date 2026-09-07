- loning research #5892, actual source at `54f78c385cebdccb0b768b8a25b75dc04454b53e`; AlyciaBHZ #6029, actual source at `a2c2ccdc1fde62627deab56bbdea433c782621dc`; #5882 current PR description at `65339a3acbe99e661c6955dbb21728c4c62dfe76`.


---

## [PR #5602] TRUE_PROLATE_OPERATOR_RESIDUAL_AND_GAMMA_GRAPH_CONTROL

# 2026-09-07：真实 prolate 的完整算子残差、对数端点积分与图范数误差

Lean：`D5/S3/Weil/ZetaBridge/WeilGammaResidualEndpoint.lean`，配套同名 Scribe。
执行源：`research/weil_ground_mode/certify_prime3_prolate_operator_residual.py`。
主结果：`prime3_prolate_operator_residual_certificate.json`。
开发检查：`test_prolate_operator_residual.py` 与 `prolate_operator_residual_regression.json`。

本节从前一节已经认证的完整 Rayleigh 值，推进到同一个真实 prolate 模型的完整未加权 L2 算子残差。核心是先证明分段 C1 误差在实际 Gamma 算子图范数中受控，再认证平方残差积分中的全部对数端点。前者适用于任意有限窗口，后者有按精度收敛的解析构造；本次实际数值实例仍是 lambda=sqrt(3)。没有用有限 Fourier 残差代替完整残差，也没有仅凭 L2 误差声称无界算子作用连续。

## 1. 文献目标与双方新工作

Connes-Consani-Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1，Section 8，以及 Connes 的 arXiv:2602.04022v1，Sections 6.4-6.6，继续分别提出真实最低模态单纯偶性与充分精确的 prolate 逼近。模型的已知 Fourier 极限不能替代真实算子上的这一步。本轮重新读取两篇原始 HTML 与 DLMF 5.7 的 Gamma 展开，没有把任何数值拟合当作尺度定理。

读取 AlyciaBHZ #6029 的最新 `WeilArithmeticResidualPrecision.lean`，提交 `3037f47c69bf1f4065870413cc354c8995139258`。它已经把非零边界矩、系数/符号区间半径及混合项运输到完整离散残差尾，不能再把精确消矩当成唯一入口。#5895 新近实偶 Fourier 读出与 #5882 的全残差能量对偶消费者在 PR 范围上复核，本轮没有重复其通用变分或读出定理。它们的编译与实例未在此重新执行。

还读取 loning 研究链 #6044 的实际 `GribinskiDegreeTwo.lean`，提交 `ca166f8b2ae3ef27e210622303e8e94ce4ab98c3`。它先给出更正后的原始系数卷积，再证明输出系数与判别式一致，提醒本节必须独立核对原始算子与分段表达式。该有限卷积定理不是 Weil 算子的依赖，也不提供当前图范数或谱间隔。

本轮复核指定 single-compilation spec v4.3，仅保持实际对象、假设、证明和计算输入的一致性；没有新增信息评分、catalog、治理规则或伪造冻结声明。以下结果是具体 Gamma/prolate 计算，不作经典积分、Minkowski、Cauchy 或谱矩方法的优先权声明。

## 2. 任意有限窗口的 Gamma 图范数估计

保持 (GE1)-(GE3) 的实际 Gamma 乘子和

\[
K(v)=\frac{e^{-v/2}}{1-e^{-2v}},\qquad
D_\pm f=\int_0^\infty K(v)(f-\tau_{\pm v}f)\,dv.
\]

设 f 零延拓后支撑于长度 L 的区间，各光滑段满足 |f|<=D0、|f'|<=D1，有至多 J 个跳跃位置，包括外部端点。D0,D1 非负。跨越跳跃的 x 集合测度不超过 Jv，两份支撑并集测度不超过 2L。因此

\[
\|f-\tau_vf\|_2
\le\sqrt{2L}D_1v+2\sqrt J D_0\sqrt v\quad(0<v<1),
\qquad
\|f-\tau_vf\|_2\le2\sqrt L D_0\quad(v\ge1).
\tag{GR1}
\]

使用 K(v)<=3/v 于 (0,1)，K(v)<=2exp(-v/2) 于 [1,infinity)，直接积分范数上界，得到

\[
\int_0^\infty K(v)\|f-\tau_vf\|_2\,dv
\le3\sqrt{2L}D_1+12\sqrt J D_0+8\sqrt L D_0.
\tag{GR2}
\]

平移在 L2 中强连续，故被积函数强可测；(GR2) 证明其 Bochner 可积性。先在有限 v 截断上作 Fourier 变换，再由 L2 收敛和乘子逐点极限识别真正的 Gamma 乘子，得到实际未压缩像属于 L2。压回窗口不增范数。在 |gamma(0)|<7 下，

\[
\boxed{\|A_\Gamma f\|_2
\le6\sqrt{2L}D_1+(24\sqrt J+23\sqrt L)D_0.}
\tag{GR3}
\]

这同时提供当前分段 C1 函数属于真实 Gamma 乘子域、继而属于对应压缩 Friedrichs 实现算子域的纸面识别。关键是范数先积分，和仅控制 q_Gamma 的 (GE15) 不同。加入实际有界 prime/pole 块及实移位 mu，若其范数和为 W，则

\[
\boxed{\|(A_a-\mu)f\|_2
\le6\sqrt{2L}D_1+(24\sqrt J+23\sqrt L)D_0
+(W+|\mu|)\sqrt L D_0.}
\tag{GR4}
\]

(GR1)-(GR4) 是参数化纸面定理，允许复函数、非零端点和内部跳跃。Lean 本轮保存下节的实际奇性积分，不宣称已经形式化 Bochner/Fourier 算子域识别。沿尺度族使用时必须保留 L、J、W 的增长；固定窗口的 C1 收敛立即给出图范数收敛，任意扩大窗口的统一收敛还要检查 (GR4) 的右侧。

## 3. 对数奇性不再作为未核验的求积尾项

实际 Gamma 像的分段表达包含 log(1-exp(-d))。对 0<t<=1、d>=t，指数切线不等式给出

\[
t e^{-t}\le1-e^{-t}\le1-e^{-d},
\qquad
\boxed{|\log(1-e^{-d})|\le1-\log t.}
\tag{GR5}
\]

新 Lean `gamma_endpoint_log_bound` 从正性和对数单调性证明 (GR5)。没有在端点用一个任意有限值替代奇性。

对残差中一个端点 strip，先在同一空间合并所有指数系数与非奇对数项。若该部分模长不超过 S，奇对数项系数模长和不超过 B，则 |R(t)|<=A-B log(t)，其中 A=S+B。设 strip 宽度为 0<delta<=1、D=-log(delta)，有

\[
\boxed{\int_0^\delta(A-B\log t)^2dt
=\delta\{A^2+2AB(D+1)+B^2(D^2+2D+2)\}.}
\tag{GR6}
\]

Lean `exponential_affine_square_tail` 先证明 exp(-x)(A+Bx)^2 在 (T,infinity) 可积及其精确积分；显式原函数为 -exp(-x)[(A+Bx)^2+2B(A+Bx)+2B^2]，无穷端极限由已有多项式乘指数衰减给出。`gamma_logarithmic_endpoint_tail` 再把 (GR5) 代入实际复系数表达 f(x)+log(1-exp(-distance(x)))g(x)，证明完整平方尾的可积性与上界。其输入只是可测系数、独立系数界和 distance(x)>=exp(-x)，没有提供组装后残差界或积分存在性。

物理变量 t=exp(-x) 的变换给出 (GR6)，该变换在本节为纸面步骤。实际程序用符号二元组标记每个 anchor 为整数倍 a 与 log2，精确合并同一个 logarithm，不根据浮点端点相等分组。未能直接取正对数区间的项，必须通过 anchor 与方向 guard，确认其距离就是当前端点距离。全部 strip 的平方质量都有预算。

## 4. 完整算子作用的分段表示与认证积分

在 c=3 处，仍使用前节独立固定的 32 维 prolate 提案和同一零积分系数比。重放完整无限 prolate 谱与能量认证后，构造同一个有限多项式模型 e_tilde。设置精确有理移位

\[
\mu_* =5949113595/10^{17}.
\]

由 (GE9)-(GE10)，每个 Gamma 原子的窗口内和原子支撑外的像均显式计算；随后先形成

\[
R_*(x)=A_\Gamma\widetilde e(x)+A_{\rm pole}\widetilde e(x)
-S\widetilde e(x)-\mu_*\widetilde e(x).
\tag{GR7}
\]

所有项相加后才平方。模型和残差严格为实偶，正半轴分段是 [0,log2-a] 和 [log2-a,a]。有限分段表达属于

\[
R_*(x)=P_0(x)+xP_1(x)+\sum_\ell P_\ell(x)
\log(1-s_\ell e^{\sigma_\ell(x-b_\ell)}),
\tag{GR8}
\]

其中 P 是有限实指数和，s、sigma 为 +/-1；指数系数由同一实际算术模型给出。正半轴计算乘二来自该构造的反射恒等式，非抽样推测。

每段长度 w 的左右端各保留宽 w*2^-D 的 strip，其余按距端点 [w*2^(-j-1),w*2^-j]、1<=j<D 分割。因而覆盖无空隙、无重复内部区间，端点本身零测。当前 D=48，每个 Taylor 阶数 n=80，正半轴共 188 个内部 cell。

对 cell [c-h,c+h]，在复圆盘 |z-c|<=2h 上逐个验证 exp(sigma(c-b)+2h)<1。于是所有 logarithm 采用以零为中心幂级数的解析分支，原实区间值也被保留。指数和项使用 exp(alpha*c+|alpha|*2h) 上界，log 项使用 -log(1-exp(sigma(c-b)+2h))，得到完整 |R_*|<=M_c。Cauchy 系数估计给出 degree-n Taylor 截断的

\[
\sup_{[c-h,c+h]}|R_*-P_n|\le M_c2^{-n}=: \epsilon_c.
\]

Taylor 系数用定向区间递推计算。特别是 w(s)=1-q exp(sigma*h*s)、g=log(w) 的系数满足

\[
g_0=\log w_0,\qquad
g_j=\frac{w_j-\sum_{k=1}^{j-1}(k/j)g_kw_{j-k}}{w_0}.
\]

平方多项式在 [-1,1] 上的积分用有限系数精确计算；若 Pmax 是系数绝对值和，则其积分误差最多为

\[
\boxed{2h(2P_{\max}\epsilon_c+\epsilon_c^2).}
\tag{GR9}
\]

这是真实解析余项加区间舍入控制，不是一个未认证的求积器输出。对一个固定有限模型，M_c 沿 dyadic 层至多线性增长于 j，h=O(2^-j)，所以全部 (GR9) 误差为 O(2^-n)，常数独立于深度 D；(GR6) 的端点误差为 O(D^2*2^-D)。因而存在按阶数和深度收敛的完整残差积分层级。实际区间计算还必须逐次通过精度与解析圆盘 guard，不作统一复杂度或无界尺度残差衰减的主张。

## 5. 从多项式残差回到真正的 prolate 模型

前置 verifier 实际重放后独立检查

\[
D_0<7718/10^{24},\qquad D_1<1287/10^{20},\qquad J=4.
\]

(GR4) 使用 W=2log2/sqrt2+2(sinh(a)+a)，给出

\[
\|(A_a-\mu_*)(e-\widetilde e)\|_2<1.151\cdot10^{-16}=:G.
\tag{GR10}
\]

令 n=||e_tilde||、delta=sqrt(L)D0，I 为完整积分 ||R_*||^2。前节已认证的真实 Rayleigh 区间给出 |mu_true-mu_*|<=5*10^-17=:eta。于是

\[
\boxed{
\frac{\sqrt I-G}{n+\delta}-\eta
\le\frac{\|(A_a-\mu_{\rm true})e\|}{\|e\|}
\le\frac{\sqrt I+G}{n-\delta}+\eta.
}
\tag{GR11}
\]

n>delta 和最终正下界均由区间检查确认。G 是对未归一化模型作用差的上界，因此在 (GR11) 中需要除以相应范数；mu_recentering 则是归一化后的直接加性预算。

两次实际定向计算分别使用 100 和 120 位精度，均认证

\[
\boxed{\frac{9166619}{10^{11}}
<r_{\rm prolate}:=\frac{\|(A_a-\mu_{\rm true})e\|}{\|e\|}
<\frac{9166620}{10^{11}}.}
\tag{GR12}
\]

等价的较保守平方区间为

\[
\boxed{8.402690\cdot10^{-9}<r_{\rm prolate}^2<8.402692\cdot10^{-9}.}
\tag{GR13}
\]

100 位运行的多项式完整未归一化平方积分在 7.0761142676e-8 与 7.0761146822e-8 之间。全部 Taylor 积分误差半径小于 1.759e-15，全部遗漏 strip 的质量上界小于 6.281e-16。两者以及真实模型图范数误差均已包括在 (GR12) 中。没有任何未处理的高 Fourier 模式，因为这里直接积分的是真实窗口算子作用的完整解析表达。

## 6. 这个残差对开放问题意味着什么

原证书只给出 lambda_1>=T=3/250000。把 (GR12) 代入该阈值对应的普通 residual/spectral-distance 估计，其系数大于七，不能提供小模态误差。这里只评价当前认证阈值的充分估计；没有给实际间隔一个上界，也没有证明更强间隔估计不可能。

可以从实际谱矩进一步解释该现象。令 v=e/||e||、lambda_0 为真实最低特征值、E=mu_true-lambda_0>0。由自伴谱测度，

\[
E=\int(t-\lambda_0)d\nu_v(t),\qquad
r_{\rm prolate}^2+E^2=\int(t-\lambda_0)^2d\nu_v(t).
\]

因此按激发能量加权的平均谱距离为

\[
\mathfrak m=\frac{r_{\rm prolate}^2+E^2}{E}.
\tag{GR14}
\]

沿用此前完整 Weil 证书的 ell=2252813807/40960000000000000、lambda_0<U=560909/10^13，以及真实 prolate Rayleigh 区间，有 E 在 3.4002359e-9 与 4.490798916e-9 之间。精确有理数比较给出

\[
\boxed{1.87<\mathfrak m<2.48.}
\tag{GR15}
\]

(GR15) 继承旧完整 ground 证书的纸面/区间范围，该旧 LDL 程序未在本轮重放。这个能量加权平均不等于任何单个特征值，不证明某一个频带占全部残差，也不保证某个新对偶试探函数一定改进证书。它说明普通范数残差与一阶能量偏差读取不同谱矩，给当前转向实际能量对偶读出的研究选择提供了定量依据。

## 7. 验证范围与下一项

新 Lean 三个公开声明有三个匹配的 FromLean Scribe 条目。证明脚本保存实际 Gamma 对数因子、完整平方尾积分和可积性，未宣称已经保存整个物理算子图范数或 Taylor 求积器的内核证明。Lean/lake 不在当前运行环境，未执行 Lean、Scribe 或传递公理报告。没有新增 authored sorry、admit 或 axiom。

主 verifier 在载入前检查四个源文件 SHA-256，实际重新执行完整 prolate 谱和前节真实 Rayleigh/正形式误差认证。它没有调用 eigensolver、zeta 值或无误差账本的求积器。独立开发检查通过两个符号原函数、四个精确 dyadic 分割、12 个原子式/组装式残差值、12 个反射值、20 个有理解析模型平方误差和20个对数核诊断。非区间点值比较最大相对差约 2.449e-79；这些诊断由同一助手的第二份实现完成，不冒称独立作者审稿或内核验证。

Verifier SHA-256：`e53103da8d4270a6595bfb7301afbe37a7fbcb8f0a4bc1e8265de68eadfc8b27`。
100 位结果 SHA-256：`cbb028570c209f9ecf68e289494b229b802385de5e6c0d436dfbf80433356490`。
开发检查 SHA-256：`b6d8953e4ada7a225a8a56aa4b511c69009971e081435f18d6135e62f00d2041`。

本轮消除了同一真实 prolate 模型缺少完整 L2 算子残差和无界作用误差控制这一具体缺口。下一步应把实际残差与 #6029 的有限精度对偶试探尾及 #5882 的能量对偶消费者连接，在同一算子域中实证改进 Fourier 方向误差，并向无界尺度族运输。仍未证明该族的候选正交补强制性、所需条带速率或真实最低模态的 Xi 极限。单个固定窗口的完整残差认证不替代上述尺度定理。

参考：

- Connes, Consani, Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1, Sections 3, 4, 7, 8. https://arxiv.org/html/2511.22755v1
- Connes, *The Riemann Hypothesis: Past, Present and a Letter Through Time*, arXiv:2602.04022v1, Sections 6.4-6.6. https://arxiv.org/html/2602.04022v1
- NIST DLMF 5.7.6, same Gamma partial-fraction normalization. https://dlmf.nist.gov/5.7
- Mathlib pinned `db584cd6d46c92f209a44c0f1c829460d327499d`, ImproperIntegrals and IntegralEqImproper; the existing polynomial-times-exponential decay is reused.
- AlyciaBHZ #6029 actual `WeilArithmeticResidualPrecision.lean` at `3037f47c69bf1f4065870413cc354c8995139258`; #5882 and #5895 current PR descriptions; loning research #6044 actual `GribinskiDegreeTwo.lean` at `ca166f8b2ae3ef27e210622303e8e94ce4ab98c3`.
