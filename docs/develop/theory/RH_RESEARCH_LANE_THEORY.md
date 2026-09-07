- #6029 actual `WeilBoundaryKernelIntegral.lean`, blob `dd8c742820f623257ed37aa15d868bb2db09301b`; #6171 actual `Mertens/Third.lean`, blob `435484ecbfc11097a057d6b435045728a6e41f01`.


---

## [PR #5602] UNIFORM_PRIME3_SCHUR_REVALIDATION_AND_EDGE_PROFILE

# 2026-09-07：跨素数 3 阈值的统一强制性、真实谱间隔与低频端点结构

新 Lean 为 `WeilPrimeActivationEdge.lean`，有同名 Scribe。新实际执行源为 `research/weil_ground_mode/certify_prime3_scale_schur.py`，结果为 `prime3_scale_schur_certificate.json`；第二表达诊断为 `test_prime3_scale_schur.py` 及其结果。源码与伴随先写回，再交付计算结果和本节增补。

本轮将前节的极小存在性邻域换成一个实际统一计算的闭区间。旧 `certify_prime3_refined.py` 只作为钉住哈希的算术运算库与明确候选来源复用；本轮不调用它的谱验证入口，不读取旧谱 JSON 作为下界假设。以下全空间结论仍承接原 Fourier 矩阵、闭形式域与无限尾的纸面识别，不冒称完整 Lean 内核证书。新 Lean 和 Scribe 未运行编译。

## 1. 统一参数结论及对象

令 a0=log3/2，取闭区间 I={a:|a-a0|<=10^-8}。在 H_a=L2([-a,a]) 上保持原来的实际 Weil 形式及 Friedrichs 实现。相位调整的正交基是 V_n^a(x)=(-1)^n exp(2*pi*i*n*x/(2a))/sqrt(2a)。明确候选 k_a 使用已固定的 129 个 dyadic 系数并逐尺度归一化；它等价于同一个向量在酉伸缩下的运输。它不是被重命名的真实最低模态，也不等于随参数重新求解的 prolate 模型。

新统一认证给出，对每一个 a∈I：

\[
\boxed{f\perp k_a\Longrightarrow q_a(f)\ge T\|f\|^2,
\quad T=1/200000,\quad f\in\operatorname{Dom}q_a,}
\tag{US1}
\]

\[
\boxed{q_a(k_a)<U=1/1000000<T.}
\tag{US2}
\]

所有参数同时进入一个长度区间 L=log3+[-2*10^-8,2*10^-8]，并进入有限块、无限耦合和余空间下界。没有以有限个采样点代替这两个全称结论。由同一算子的紧 resolvent、min-max 与反射对称性，实际最低特征值简单、隔离，最低线为偶，并有

\[
\boxed{\lambda_1(a)-\lambda_0(a)\ge T-U=1/250000=4\cdot10^{-6},\quad a\in I.}
\tag{US3}
\]

这不是全 Weil 正性。实际候选 Rayleigh 的统一粗区间包含负下端点；该区间既不能证明候选在某点能量为负，也不能证明最低值非负。本轮没有认证变化尺度 prolate 模型的逼近率或其原点分母。

## 2. 新素数作用在低频块中的真实形状

本节的物理激活比较取 0<h<1。前节已证明此时新素数的对称压缩平移 B=w(T_(2-h)+T_(2-h)^*) 的普通范数为 w。对固定的光滑低频向量，其作用仍可以很小。取共同区间 [-1,1] 的实偶基 phi_0=1/sqrt2、phi_n=(-1)^n cos(pi*n*x)，n>=1。令 b_0=1/sqrt2，b_n=1。由实际两端重叠区间积分，

\[
\langle\phi_m,B\phi_n\rangle
=2w b_m b_n\int_0^h\cos(\pi m t)\cos(\pi n(h-t))dt.
\]

新 Lean `cosine_prime_edge_remainder` 对任意实 u,v 和 h>=0 证明

\[
\boxed{\left|\int_0^h\cos(ut)\cos(v(h-t))dt-h\right|
\le (u^2+v^2)h^3/6.}
\tag{US4}
\]

证明使用实际 cos 缺陷、连续 integrand 和精确二次多项式积分。因此该素数在有限偶块中的首项是 2wh*bb^*，并有逐项三次误差；实际 Weil 素数项带负号。这个首项保留非零端点，不能在一般最低模态上删除。

对已经拥有的零 trace 偶 Fourier 模板，定义其具体边界表达 g(t)=sum_(n∈S)v_n(cos(pi*n*t)-1)，并令 K=sum |v_n|(pi*n)^2。其物理模板在共同区间的值是 sqrt2*g(t)。新 `even_stencil_edge_fifth_order` 推导可积性和

\[
\boxed{\int_0^h|g(t)|^2dt\le K^2h^5/20,\qquad
\left|\int_0^h\overline{g(t)}g(h-t)dt\right|\le K^2h^5/120.}
\tag{US5}
\]

全部复系数先在同一函数中相加；没有漏掉交叉项。由 |cos x-1|<=x^2/2 得到二阶端点消失，再积分 t^4 与 t^2(h-t)^2；后者的实际积分是 h^5/30。若将 sqrt2 因子计回物理函数，prime 二次型模长至多为 wK^2h^5/30，完整 prime 作用的范数平方至多为 w^2K^2h^5/5。因而，在另外具备独立正高块下界时，它的 Schur 修正具有相应的第五阶预算。

(US5) 只用于这种明确的零 trace 试探子空间。新数值证书中的原始候选没有被强行设置零端点；其全部边界矩保留。当前区间扩展的实际计算改进主要来自下一节的方向性 Gram 预算，并非把 (US5) 偷渡为真实候选的性质。

## 3. 一次计算覆盖激活阈值两侧

保留 |n|<=N，N=128，总共 257 个 Fourier 坐标。N 以外的空间无限维。在本参数区间，log2<L<log4，所以仅需原始 prime 2、3；3 在 L<=log3 时不可见，在右侧有真实作用。

一般正实 L 的边界符号仍由完整 Gamma、pole、prime 表达给出，omega_n=2*pi*n/L。非对角项是 (s_i(L)-s_j(L))/(pi*(j-i))。这一积分计算只用 omega_n*L=2*pi*n，不要求 exp(L) 为整数。新程序为 prime 3 的 sine 项取真实激活表达与零的区间包络；对角则保留重叠比例

\[
(1-\log3/L)_+.
\tag{US6}
\]

这在阈值恰为零，且右侧严格可见。不能把没有重叠因子的 cosine 项直接加到对角上。

Gamma 对角完整表达为

\[
\Re\psi(1/4+i\omega_n/2)-\log\pi
+\frac{\Re\psi'(1/4+i\omega_n/2)}{2L}
-\frac2L\sum_{j\ge0}e^{-b_jL}\Re(b_j-i\omega_n)^{-2}.
\]

最后一和的指数尾用正几何界控制；digamma/trigamma 使用原已钉住的余项算法。原 pole 对角和所有可见 prime 对角均加入。第二表达诊断直接计算完整 Gamma 核与原压缩平移积分，覆盖阈值两侧和阈值本身，但这些非定向诊断不作为区间证明前提。

## 4. 整个无限高块的独立下界

复用 `WeilInfiniteComplementLeakage` 的实际低频质量界 epsilon=4/(3*pi^2)：对 |n|>N 的全部 Fourier 组合，其 |xi|<=R=pi*N/(2L) 的连续 Fourier 质量至多为 epsilon。有限 Fourier 和与零延拓变换的识别仍按本卷原证明承接。Gamma 增量随 |xi| 单调，故

\[
q_\Gamma(f)\ge\left[\gamma_0+(1-\epsilon)
\sum_{j<2048}\frac{2R_-^2}{b_j(b_j^2+R_-^2)}\right]\|f\|^2,
\]

R_- 是整个参数区间 R 的下端点。Gamma 未求和的部分非负，故这是下界而非截断近似。两个 prime 位移在活跃时均大于半窗，其对称块范数各自至多 w_p=log(p)/sqrt(p)；pole 负特征值的模长为 2(sinh(a)-a)。统一减去这些实际最坏项，程序得到

\[
\boxed{q_a(f)\ge\beta\|f\|^2,\quad\beta>1.00907026>1,
\qquad f\in P_N^\perp\cap\operatorname{Dom}q_a.}
\tag{US7}
\]

为后续使用固定 beta_floor=1。这里没有继承旧 c=3 的第二特征值下界。所有 n、所有高空间向量和所有 a∈I 同时被覆盖。实际边界符号包络也重新验证为 B=4。

## 5. 保留方向的耦合 Gram 误差

对 N<|m|<=M=8192 的完整耦合矩阵 C_near(L)，取一个固定 dyadic 矩阵 D。其值由区间中点提出，但全部元素误差另有向外舍入包络。正频率矩阵与其反向矩阵共同覆盖正负两侧；每个误差平方的 binary64 上端点转为精确二进制有理数后求和，得到 e2>=||C_near-D||_F^2。

旧式将所有扰动压成线性标量 norm 误差会损失狭窄低能方向。本次在整个向量空间使用

\[
\boxed{C_{\rm near}^*C_{\rm near}
\preceq(1+\theta)D^*D+(1+\theta^{-1})e2\,I,\quad\theta=1/20.}
\tag{US8}
\]

这是 Young 不等式与 Frobenius 上界的具体应用，保留 D^*D 的方向信息。D 的 Gram 由带溢出检查的整数分块乘法精确计算。标量部分约为 5.5168725874e-7。

对 |m|>M，原始算术列的二阶展开保留四个矩 sum x_n、sum s_n x_n、sum n x_n、sum n s_n x_n。正负 m 配对后使用奇偶分解与 parallelogram，再估计平方，给出实际 Gram 上界的矩阵部分

\[
(G_{\rm far})_{ij}=
\frac8{\pi^2}\left[\frac{B^2+s_i s_j}{M}
+\frac{ij(B^2+s_i s_j)}{M^3}\right]+\eta_{\rm far}\delta_{ij},
\]

\[
\eta_{\rm far}=\frac{16B^2N^4(2N+1)}{\pi^2(1-N/M)^2M^5}
<5.006\cdot10^{-8}.
\tag{US9}
\]

这是原完整二阶尾证明在一般 L 的实例；两个方向先配对是常数 8 的依据，不能在独立取绝对值以后仍保留该常数。所有无限项由幂级数积分界覆盖，没有终端外部截止。令 G 为 (US8) 与 (US9) 的和，则整个低高耦合 C 满足 C^*C<=G。

## 6. 精确整数证实有限 Schur 形式

令 c 为嵌入 257 维空间的原始未归一化 dyadic 候选。程序检查整个区间的有限 Hermitian 矩阵

\[
\boxed{H_T(L)=A_N(L)-TI-G(L)/(1-T)+cc^*\succ0.}
\tag{US10}
\]

实际矩阵与反射交换，拆为 129 维偶块和 128 维奇块。浮点 `numpy.linalg.eigh` 只提出一个 dyadic 坐标变换 R；它的浮点特征值不作为正性证据。把每个 H 元素写成带严格验证半径的 dyadic 有理区间 Y+E 后，计算 R^T YR 与 |R|^T E|R|，全部使用 Python 精确整数。

每一行的对角下界减全部非对角绝对值上界均严格为正。两块在变换坐标中的最小 Gershgorin 下界分别约为 0.99724 和 0.87555；它们是合同变换后的验证裕量，不是原算子的物理谱间隔。这个正性也证明方阵 R 可逆，因此不需信任任何数值逆或浮点正交性。特意提供奇异 R 的负对照会被末次整数检验拒绝。

对任意 f=x+y∈Dom(q_a)，x∈P_N，y∈P_N^perp，先用 (US7) 完平方：

\[
q_a(f)-T\|f\|^2\ge
\langle x,(A_N-TI-C^*C/(1-T))x\rangle
+(1-T)\|y+(1-T)^{-1}Cx\|^2.
\]

若 f perpendicular k_a，则 <c,x>=0；结合 G>=C^*C 和 (US10) 得到 (US1)。同一次区间矩阵运算还证明 (US2)。标准 min-max 于是给出仅一个特征值在 T 以下，它由显式候选保证存在。其若为奇模态则必与偶候选正交，违反 (US1)。这完成 (US3)，量词覆盖整个区间及整个形式域。

## 7. 执行记录、失败对照与实际研究尺度

同一最终 verifier 在 90 和 120 位定向区间精度分别通过；最后再次重放 90 位，结果 SHA-256 与第一次相同。bulk 算术符号仍使用原来的向外舍入 binary64 包络，不能把工作精度当作每个输入的准确位数。新数值结论使用新的高块、耦合与有限 Schur 检验，未调用历史谱验证入口或引入其 JSON 为数值前提。

精确诊断包含三条多项式积分、160 个复有理向量的 Young/Gram 比较，以及真正整数正性判定器的正负对照。第二表达检查有 36 个 cosine 重叠、12 个复模板质量/配对、24 个完整 Gamma/pole 对角、12 个原边界核与 9 个 prime-3 原平移系数对照。后者用 65 位非定向积分，最大相对差约 1.372e-65，只作为公式诊断。正中点但含不定成员的矩阵区间、故意奇异的提案坐标、过低精度与未审查参数均被拒绝。

探索阶段普通标量 Gram 膨胀和较高阈值的部分验证失败，没有据此推出真实矩阵不正。最终通过的是这里固定的算法、区间、阈值和精度；没有无限次挑选后声称未改规格。

Verifier SHA-256：`c527fa349cc1b6e14afedaffae0a44eb453cfff68aea12709dac0379236fa7d6`。
90 位结果 SHA-256：`d02b04f9318ccea70a8a7bc5d239f18a59142823608157739f57f1ab6185a146`。
120 位结果 SHA-256：`9d9ad89760bcd2635bd569549810c74ddca582d9069d670bdb18e232a60064f0`。
诊断源 SHA-256：`c72ef6f90f7aaed5bbe2d7a77f480ed17c3887702bc541959aa6478c632b8cdf`。

三条公开 Lean 定义/定理具有三个对应 FromLean Scribe 条目。没有新 authored sorry、admit 或 axiom；Lean elaboration、Scribe 发射与传递公理报告未执行。计算机辅助结果依赖明确的 Fourier/core、无限尾纸面证明，以及 Python、NumPy、mpmath 的算术实现；没有独立作者审查。

1e-8 半宽比前节的 2^(-9259287090) 存在性半径大得多，并已经覆盖一个真正的素数激活点；它仍是很小的局部区间，距离连续覆盖到下一个素数阈值及无界尺度很远。这里认证的 k_a 是运输的旧明确 Fourier 候选，随尺度变化的真正 prolate 模型尚未重新比较。下一步需将低块方向信息、候选选择及对偶读出与尺度联动，以减少区间相关性损失，不能仅复制更多固定窗口数字。

## 8. 文献和跨作者对应

本轮重新读取 CCM *Zeta Spectral Triples*, arXiv:2511.22755v1，及 Dusson-Sigal-Stamm *The Feshbach-Schur map and perturbation theory*, arXiv:2105.02058。2026-06-01 的 Li-Shao *Asymptotic Recovery in Fourier Spectral Methods for the Schrodinger Equation with Point Singularities*, arXiv:2606.01718v1，Sections 1、5.2，具体展示保留低维有效算子与恢复高频结构的做法。其 Laplacian/Sobolev 假设不适用于当前 Gamma 算子，本节没有据此输入任何误差阶；这里只借鉴方法，实际 Weil 下界独立推导。经典 Young、Schur、Gershgorin 与端点积分均不作首创声明。

实际代码读取包括 #6029 `WeilBoundaryKernelIntegral.lean`（blob `dd8c742820f623257ed37aa15d868bb2db09301b`），它识别原边界符号与奇核积分，未被重复实现；以及 5040/Robin 线新 #6204 `GronwallUpperEnvelope.lean`（blob `75eb28885ee1250985d9dbd19b73fa76f3502d04`）。后者给出归一化 sigma 比值最终 <=1+epsilon 的上包络，不能转为全称严格 Robin 界或算子正性。本轮没有处理这些 PR 的 CI、冻结或工程门。

参考：

- Connes, Consani, Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1, Sections 4,8. https://arxiv.org/html/2511.22755v1
- Dusson, Sigal, Stamm, *The Feshbach-Schur map and perturbation theory*, arXiv:2105.02058. https://arxiv.org/abs/2105.02058
- Li, Shao, *Asymptotic Recovery in Fourier Spectral Methods for the Schrodinger Equation with Point Singularities*, arXiv:2606.01718v1. https://arxiv.org/html/2606.01718v1
- Existing owners: `WeilInfiniteComplementLeakage`, `WeilArithmeticCouplingJet`, `WeilEvenDualStencil`; actual #6029 and #6204 sources at the blobs above.
