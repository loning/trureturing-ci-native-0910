- Parallel #5602 source at `4804c4020d7d9f165a2e2683c42b01e3d47a8be4`: `WeilPrimeActivationEdge.lean`, blob `5cd36bfeef88311e1f5e6c140fc11e52b16e8881`; `certify_prime3_scale_schur.py`, blob `496333f97d20a6898d47f848a2abd839249e9207`.


---

## [PR #5602] SAME_PROLATE_SCALE_FLOW_AND_CENTERED_READOUT_TRANSPORT

# 2026-09-07：同一真实 prolate 族的尺度流与中心化读出运输

本节继续使用已认证的半宽区间 I={|a-a0|<=2e-8}，a0=log3/2。新结论处理随 a 变化的真正 prolate 模型，以及其原点归一化 Fourier 值和 model-centered 代表元。它不把中心尺度的种子固定后重新命名成真实尺度族，也不将模型的变化界当作新区间上真实 Weil ground 的误差界。

新 Lean 为 `WeilMellinScaleFlow.lean`，有同名 Scribe；主程序为 `certify_prime3_prolate_scale_transport.py`。其 110、130 位定向运行均通过。Lean elaboration、Scribe emission 与传递公理审查未运行。标准正规 prolate 实现、谱投影、积分变量代换与以下范数运输是纸面桥；新 Lean 保存原 `Zeta23.paperFT` 的有限多项式尺度对应。

## 1. 固定种子的精确尺度流，包含新整数进入的边界

对固定连续偶种子 H 于 [-1,1]，物理种子为 h_a(t)=H(t exp(-a))，于 t>exp(a) 置零。实际未偶化算术函数为

\[
p_{a,H}(x)=1_{[-a,a]}(x)\,4e^{x/2}\sum_{1\le m\le e^{a-x}}H(me^{x-a}).
\]

令 s=1/2+iz，Phi_(a,H)(z)=paperFT(p_(a,H))(z)。按每个 m 的实际支撑积分，作 t=m exp(x-a) 代换，得到

\[
\boxed{\Phi_{a,H}(z)=4e^{as}\sum_{m\le e^{2a}}m^{-s}
\int_{me^{-2a}}^1H(t)t^{s-1}\,dt.}
\tag{SF1}
\]

正 t 上的复幂均按实对数定义，有限窗口内无分支歧义。固定可见整数集合的开区间内，微分下端积分给出

\[
\boxed{(\partial_a-s)\Phi_{a,H}(z)=8e^{-as}\sum_{m\le e^{2a}}H(me^{-2a}).}
\tag{SF2}
\]

在 a_m=log(m)/2，新 m 项的上下积分限同为 1，其 Fourier 质量严格为零。因此 Phi 连续，可将两侧的导数上界相接。其该项的一阶导数右减左为 8 exp(-a_m s)H(1)，不应把整个尺度族无条件当成 C1。偶化值是 [Phi(z)+Phi(-z)]/2，两边均按同一公式处理。对真正变化的 H_a，本节不对其求导，而用下一节的独立谱误差分开运输。

当 H(t)=sum_(r<d)B_r*t^(2r)，物理多项式的系数是 B_r exp(-2ra)。新定义 `scaledPolynomialWindow` 直接把这些系数送入已有 `polynomialMellinWindow`。`scaled_polynomial_centered_paperFT` 证明

\[
\boxed{e^{-as}\Phi_{a,H}(z)=4\sum_{m=1}^M\sum_{r<d}
B_rm^{2r}\frac{e^{-(s+2r)\log m}-e^{-2(s+2r)a}}{s+2r}.}
\tag{SF3}
\]

假设是各纳入整数满足 log(m)<=2a 及 Im(z)<1/2。可积性及实际端点积分来自原 owner。`scaled_polynomial_paperFT_scale_difference` 进一步证明两尺度的 (SF3) 相减只留下后一个指数的差。代码不假设目标误差界或积分值，也未新定义 Fourier。一般固定连续 H 的 (SF1)-(SF2) 为纸面推导；有限多项式情形的代数导数由独立符号测试核对。

## 2. 对所有尺度重新认证实际 prolate 模式

在固定 [-1,1] 上，实际正规偶 prolate 算子为

\[
\mathcal L_a=-\partial_t((1-t^2)\partial_t)+q(a)^2t^2,
\qquad q(a)=2\pi e^{2a}.
\]

使用前文同一个正交归一偶 Legendre 基与正规自伴实现。J=32 个保留系数外的整个块仍有下界 2J(2J+1)=4160，因为乘法势 q(a)^2t^2 非负。跨块只有一项 b(a)。对每个实移位 eta<4160，真实 Schur 块夹在 A_J(a)-eta I 与 A_J(a)-eta I-b(a)^2/(4160-eta)*e_last e_last^* 之间。

程序直接将 q(a)^2 作为整个闭区间，分别对两条固定 dyadic 提案中心 mu_i 的 mu_i-50 和 mu_i+50 检查两个 Schur 端点的严格惯性。四个计数依次为 (0,0,1,1) 和 (2,2,3,3)，对所有 a∈I 成立。这识别了真实偶谱编号 0、2，也保证它们各自为单特征值；未信任有限本征求解器或旧结果 JSON。

为避免丢失尺度参数的相关性，残差使用精确算子关系

\[
(\mathcal L_a-\mu_i)v_i=(\mathcal L_{a0}-\mu_i)v_i
+[q(a)^2-q(a0)^2]t^2v_i.
\tag{SF4}
\]

两项的完整范数都包含第 J 个遗漏坐标。独立算出的 ||t^2 v_i|| 约为 0.04535432874 和 0.28854567727。由其余谱与 mu_i 距离至少 50，真实单位模式的符号对齐误差 <=sqrt(2)*r_i/50。两个零阶 Legendre 系数均以严格正下界固定符号。

设 rho=v_(4,0)/v_(0,0)，固定多项式组合 Htilde=v4-rho*v0。实际零积分组合为 H_a=psi_(4,a)-(psi_(4,a))_0/(psi_(0,a))_0*psi_(0,a)。两条单位模式误差 eps0、eps4 给出

\[
\Delta_\rho=(\epsilon_4+|\rho|\epsilon_0)/(v_{0,0}-\epsilon_0),\quad
\|H_a-\widetilde H\|_2\le\epsilon_4+(|\rho|+\Delta_\rho)\epsilon_0+\Delta_\rho.
\tag{SF5}
\]

分母被独立认证为正。本次整个区间的 (SF5) 小于 652/10^9；中心尺度独立计算的相同预算小于 3.142e-29。实际模式与固定多项式仅在这个明确误差内对应。

## 3. 实际窗口、种子误差和归一化一起运输

在本区间只有整数 1、2、3 可能出现。变量代换 t=m exp(x-a) 给出

\[
\|p_{a,H}-p_{a,G}\|_2\le C_a\|H-G\|_2,\qquad
C_a=4e^{a/2}\sum_{m=1}^3m^{-1/2}.
\tag{SF6}
\]

对 |Im(z)|<=b，Fourier 差再乘 sqrt(2a) exp(ab)。有限 Legendre 展开给出固定 Htilde 的 ||Htilde||_2<=1+|rho| 及 ||Htilde||_infinity<7.610。后者由 |P_n(t)|<=1 保留所有系数，不是假设真实 H_a 有该相同上界。

取复圆盘 D={|z-(20+i/4)|<=1/1000}，b=251/1000。令 a_-、a_+ 为尺度区间端点，B_b=sqrt(2a_+) exp(a_+b) C_(a_+)。由 (SF2) 与 |s|<21，固定种子整个尺度区间内的分段导数界为

\[
K_b=21B_b(1+|\rho|)+24e^{-a_-(1/2-b)}\|\widetilde H\|_\infty.
\tag{SF7}
\]

原点单独用 K_0=B_0(1+|rho|)/2+24 exp(-a_-/2)||Htilde||_infinity。将真实种子到多项式、固定种子的尺度流、多项式到中心真实种子三段相加，得到所有 a∈I、z∈D 的原始 Fourier 差 E_z<2.2230e-5，原点差 E_0<1.1189e-5。这些是参数区间和复圆盘的一致预算，没有抽样替代全称量词。

中心多项式原点由原 Mellin 端点公式计算为约 2.33619788660；加入中心种子误差以及 E0 后，对本节固定的零积分组合标度有

\[
\boxed{|\widehat p_{a,H_a}^{+}(0)|>23/10\quad(a\in I).}
\tag{SF8}
\]

令 P_a(z)=paperFT(p_(a,H_a)^+)(z)/paperFT(p_(a,H_a)^+)(0)。以中心原点模长下界 b0 和中心圆盘分子上界 M0 代入精确复商差式，

\[
|P_a(z)-P_{a0}(z)|\le(E_z+M_0E_0/b_0)/(b_0-E_0).
\]

计算所得上预算约 9.549046646e-6，严格证明

\[
\boxed{\sup_{a\in I,\ z\in D}|P_a(z)-P_{a0}(z)|<10^{-5}.}
\tag{SF9}
\]

(SF8) 的原始范数依赖本节固定标度；(SF9) 代数消去一切整体尺度和相位，与此前原点归一化模型完全相同。

## 4. 对接新的 model-centered 读出，而不冻结错误的中心系数

本轮实际读取 #5895 提交 `44a831a15abe4d00268d973976101e0d62d66fd2` 中 `GenuineModelDualTransport.lean` 的 `model_centered_readout_identity` 和 `annihilating_energy_dual_transport`。其系数必须是同一真实模型的比值，且其对偶预算必须另行认证。

在共同空间 L2([-1,1])，定义 g_(a,z)(y)=conjugate(cos(a z y))，g0=1，以及 h_(a,z)=g_(a,z)-conjugate(P_a(z))*g0。对真实模型的酉伸缩向量 e_a，严格有 <h_(a,z),e_a>=0，sqrt(a) 因子在原点比值中消去。由复指数核导数与 (SF9)，

\[
\|h_{a,z}-h_{a0,z}\|_2
\le\sqrt2\,|z|e^{a_+b}|a-a0|+\sqrt2\,|P_a(z)-P_{a0}(z)|.
\]

定向程序证明

\[
\boxed{\sup_{a\in I,\ z\in D}\|h_{a,z}-h_{a0,z}\|_2<15/10^6.}
\tag{SF10}
\]

这是实际中心化代表元的变化预算。它没有证明全对偶残差，因为还需要同一试探函数上的 (A_a-A_a0)v，以及正移位、候选/模型正交补和分母界的统一组合。不能将中心 z、a0 的旧 C 值无修改地用于整个参数区间。

## 5. 研究来源、实际执行和剩余承重义务

CCM, *Zeta Spectral Triples*, arXiv:2511.22755v1, Section 8 仍明确区分最低模态的单纯偶性与充分精确的真实模型对应。DLMF 30.3 的正规 spheroidal 模式和参数性质用于核对对象；此处数值隔离由实际无限 Jacobi 界独立认证，未由定性解析性代替误差率。Suzuki arXiv:2606.09096 的原始版本页此次返回 v1；未使用聚合站声称的未核验新版结果。

也读取 loning/5040 研究链 #6204 的实际 `GronwallUpperEnvelope.lean`，提交 `0805069c8c630f909f89b0573dbe672c98f275bc`。它复用 Mertens III 得到归一化 divisor sum 最终 <=1+epsilon。这个标量包络没有提供严格 Robin 全称界或当前算子谱间隔；本节不将它混作前提。其已合并状态已从 PR 元数据核对，作者自报的编译未在此复验。

新 verifier 以固定 proposal 的 SHA-256 为输入检查，并在 110、130 位定向精度分别运行通过；未读取旧数值谱结论、未用 eigensolver 或数值求积。种子比值、所有遗漏 Legendre 分量、激活边界、原点分母和中心化代表元变化均明确计入。独立表达式诊断核对了 24 条符号尺度/导数/激活等式、5 个错误 seed 缩放的失败对照，以及 12 次原物理窗口积分对照。后者为非定向 65 位诊断，最大相对差约 4.121e-66，不作为区间证明依据。

Verifier SHA-256：`fe1d574f38a13e0dbcc185649c0e6c32dfd9e1cb676ceebb73ad7c6c31218b4f`。Proposal SHA-256：`242c9897bbd247ef0485039e6dcde819a351c5900ceac52fecc420934c1896db`。三个新公开 Lean 定义/定理有三个 FromLean Scribe 项。Lean、Scribe 编译及公理闭包未执行，测试由同一助手完成，无独立作者审查或数学优先权声明。

本轮提供同一尺度区间中真正 prolate 族的 Fourier 和中心化读出变化率。此前的统一 simple-even/gap 证书已另行写回并重跑；它与 (SF9) 之间仍缺真实 Weil ground 的统一方向误差，不能据此宣称已得到区间 ground/prolate 的完整逼近或 Xi 极限。下一实际算术任务是联合验证变尺度对偶作用及其完整 Schur 补，保留本节已确定的同模型中心系数。

参考：

- Connes, Consani, Moscovici, arXiv:2511.22755v1, Sections 7-8. https://arxiv.org/html/2511.22755v1
- NIST DLMF 30.3, 30.8, regular spheroidal eigenvalues and Legendre expansions. https://dlmf.nist.gov/30.3 ; https://dlmf.nist.gov/30.8
- Suzuki, arXiv:2606.09096v1. https://arxiv.org/abs/2606.09096
- Actual #5895 `GenuineModelDualTransport.lean`, blob `d6940d2ee2cc91ebe1f6faed01b75b9adc8cd7e3`; #6204 `GronwallUpperEnvelope.lean`, blob `75eb28885ee1250985d9dbd19b73fa76f3502d04`.
