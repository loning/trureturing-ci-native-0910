- A. Connes, *The Riemann Hypothesis: Past, Present and a Letter Through Time*, arXiv:2602.04022, Sections 6.4-6.6. https://arxiv.org/html/2602.04022
- A. Connes, C. Consani, H. Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1, Lemma 7.3 and Section 8. https://arxiv.org/html/2511.22755v1
- Mathlib `ArithmeticFunction.vonMangoldt_sum`, pinned `db584cd6d46c92f209a44c0f1c829460d327499d`, `Mathlib/NumberTheory/ArithmeticFunction/VonMangoldt.lean`.
- loning #5326, `3beb435bf9ca8aa35aa6079ea4033a9c2e6c9007`, actual theory C13; AlyciaBHZ #5895, `04eaf09b47c39f7688a8df498c4fe30e0663dcbd`, actual `NormalizedReadoutDisk.lean`.


---

## [PR #5602] GAMMA_LOGARITHMIC_CANCELLATION_AND_TRUE_PROLATE_ENERGY

# 2026-09-07：Gamma 对数抵消、无界形式误差运输与真实 prolate 的完整 Weil 能量

Lean owner：`D5/S3/Weil/ZetaBridge/WeilGammaLogarithmicSeed.lean`，配套同名 Scribe。
执行源：`research/weil_ground_mode/certify_prime3_prolate_weil_energy.py`。
结果：`research/weil_ground_mode/prime3_prolate_weil_energy_certificate.json`。
开发检查：`test_gamma_logarithmic_seed.py` 及其结果 JSON。

本节将上节的实际素数作用接到 Gamma 作用，并计算同一个真正 prolate 模型的完整 Weil Rayleigh 值。关键新增步骤是从已认证的 Legendre L2 误差推出逐段 C1 与跳跃误差，再运输到无界 Gamma 形式。仅有 L2 逼近不能完成这一运输。新 Lean 保存实际截断多项式 seed 的奇积分可积性与有限端点公式；完整 Gamma/Fourier 识别、无限 Jacobi 尾比较及区间结果属于以下纸面与计算机辅助证明。Lean elaboration、Scribe emission 和传递公理审查未运行。

## 1. 文献与跨作者源的定位

继续以 Connes-Consani-Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1，Section 8 的真实最低模态/prolate 逼近为目标。Connes 的 2026 年综述 arXiv:2602.04022，Sections 6.4-6.6，仍将模型极限、最低模态单纯偶性和充分精确逼近分别处理。本轮复核 Suzuki arXiv:2606.09096 与 Groskin arXiv:2607.02828 的原始 arXiv 页面；取得的版本历史都列出 v1，没有把聚合站的更新标签当成已核验的新定理。Groskin 已有有限 Fourier 矩阵的 cutoff-free 算法，本节不宣称首次消除 Gamma 截断。

读取 loning 研究链 #5892 的实际 `CoefficientDrivenJacobiCharacteristicPolynomial.lean`，固定于 `54f78c385cebdccb0b768b8a25b75dc04454b53e`。该有限 Jacobi/特征多项式定理保留 hSymmetric 前提，不能替代实际无限 prolate 的自伴实现或域控制。读取 AlyciaBHZ #6029 的 `WeilArithmeticResidualTail.lean`，固定于 `a2c2ccdc1fde62627deab56bbdea433c782621dc`；其消矩条件施加在所选 dual trial 上，不应转移到真实 prolate 模型。#5882 的新 energy-dual 结果已提供完整残差消费者，本节不复制其抽象变分定理。

经典输入为 digamma 部分分式、Legendre 递推、正形式 Cauchy-Schwarz、几何级数及有限幂积分。这里的具体贡献是将这些工具接到已独立固定的算术模型及全部模型误差，不作优先权声明。

## 2. 同一 Gamma 乘子及其平移形式

保持 L=2a、正号 Fourier 核，以及实际

\[
\gamma(t)=\Re\psi(1/4+it/2)-\log\pi,
\qquad \gamma_0=\gamma(0).
\]

DLMF 5.7.6 的部分分式逐项相减给出

\[
\gamma(t)-\gamma_0=\sum_{j\ge0}\frac{2t^2}{b_j(b_j^2+t^2)},
\qquad b_j=2j+1/2.
\tag{GE1}
\]

每项非负。对零延拓的分段 C1 紧支撑函数，先用有限 j 的 resolvent 核，再由正形式单调收敛，得到

\[
A_\Gamma f=\gamma_0f+D_+f+D_-f,
\quad D_\pm f(x)=\int_0^\infty K(v)(f(x)-f(x\pm v))\,dv,
\quad K(v)=\frac{e^{-v/2}}{1-e^{-2v}}.
\tag{GE2}
\]

作用等式在非跳跃点成立，随后给出同一 L2 表示向量。对应的正形式为

\[
\boxed{\mathcal G(f):=q_\Gamma(f)-\gamma_0\|f\|^2
=\int_0^\infty K(v)\|f-\tau_vf\|_2^2\,dv\ge0.}
\tag{GE3}
\]

常数中没有遗漏 2*pi：q_Gamma 使用 (2*pi)^-1 的 Fourier 积分，而单个 exp(-b|x|) 的 Fourier 乘子是 2b/(b^2+t^2)。每个有限 resolvent 因而正好产生 (GE1) 的一项。

## 3. 实际 Gamma 与素数作用的全尺度抵消

沿用上节 E、B_+、p=Eh。令 lambda=exp(a)，对 0<u<lambda 定义

\[
J_\lambda h(u)=\int_u^\lambda\frac{t(h(t)-h(u))}{t^2-u^2}\,dt,
\quad
T_\lambda h(u)=-\frac12\log(1-u^2/\lambda^2)h(u)-J_\lambda h(u).
\tag{GE4}
\]

对在 [lambda^-1,lambda] 上 C1 的 seed，J 的下端奇性可去；T 的上端对数奇性局部可积。其端点值可任意指定，不改变 L2 合成。在有限算术断点以外，v>=0 的平移从不越过窗口左端，seed 支撑处理右端。令

\[
C_+=\pi/4+(3/2)\log2.
\]

使用 u=m*exp(x)、t=u*exp(v)，可直接算得

\[
D_+Eh=E\big((C_+-a+\log t)h+T_\lambda h\big).
\tag{GE5}
\]

其中 C_+ 来自半个 digamma 差 psi(1)-psi(1/4)。上端截断另产生 -log(lambda/u)-(1/2)log(1-u^2/lambda^2)，所以边界项没有被删除。

与已提交的 B_+Eh=E(log(t)h)-XEh 组合，得到

\[
\boxed{(D_+-B_+)p=(C_+-a)p+Xp+E(T_\lambda h).}
\tag{GE6}
\]

这是实际 Gamma 与 prime 的一次精确相消，适用于每个有限尺度。令 e=(p+Rp)/2、r=(p-Rp)/2。反射交换 D_+、D_- 和 B_+、B_-，因此

\[
\boxed{
(A_\Gamma-S)e=
-\big(\gamma_E+\log(\pi\lambda^2)\big)e
+(I+R)E(T_\lambda h)+2Xr
-(I+R)(D_+-B_+)r.
}
\tag{GE7}
\]

这里 S 是无符号素数块，完整 Weil 算子还需加实际 pole 算子。恒等式使用 gamma_0=-gamma_E-pi/2-3log2-logpi。全部奇部分修正仍然存在；(GE7) 不是小残差估计，也没有将 D_+ 视为有界算子。

## 4. 新 Lean：真正的奇积分被有限端点公式取代

对前置 owner 的同一个 `cutPolynomialSeed`，即 h(t)=sum_(r<d) A_r*t^(2r) 于 t<=exp(a)，新主声明 `gamma_logarithmic_seed_remainder` 同时证明 J 的可积性和

\[
\boxed{
J_{e^a}h(u)=\sum_{r<d}A_r\sum_{j<r}
 u^{2(r-1-j)}\frac{e^{a(2j+2)}-u^{2j+2}}{2j+2},
\qquad 0<u\le e^a.
}
\tag{GE8}
\]

证明先用标准差幂公式，将实际 integrand 在 (u,exp(a)] 上识别为连续多项式 sum_r A_r sum_(j<r) t^(2j+1)u^(2(r-1-j))。再通过几乎处处相等建立原 integrand 的可积性，使用固定 Mathlib 的有限积分线性与幂积分。t=u 处 totalized division 给出的值不能当作极限值；证明明确利用该点的零测性。d=0 和 u=exp(a) 均被覆盖。没有先假设目标积分相等，也没有强行设置边界矩为零。

## 5. Gamma 作用的有限端点实现，包括原子支撑以外

多项式算术模型是有限个 f(x)=C*exp(alpha*x)*1_[ell,b](x) 的和，其中 alpha=2r+1/2，r>=0，ell=-a，b=a-log(m)。对 ell<x<b，令 d_+=b-x、d_-=x-ell、c_0=-gamma_E-log(2*pi)。直接对 (GE2) 的几何核积分得到

\[
\begin{aligned}
A_\Gamma f(x)=C e^{\alpha x}\bigg[
&c_0-d_+-\tfrac12\log(1-e^{-2d_+})+\operatorname{atanh}(e^{-d_-})\\
&-\sum_{k=1}^{r}\frac{e^{2kd_+}-1}{2k}
+\sum_{j=1}^{r}\frac{1-e^{-(2j-1)d_-}}{2j-1}\bigg].
\end{aligned}
\tag{GE9}
\]

例如前向常数项为 C_+-d_+-(1/2)log(1-exp(-2d_+))；后向常数项为 pi/4+(1/2)log2+atanh(exp(-d_-))，两者与 gamma_0 相加给出 c_0。有限几何差分别产生偶次和奇次指数项。

对 x>b，虽然 f(x)=0，其 Gamma 像一般非零，必须保留

\[
\boxed{A_\Gamma f(x)=-Ce^{\alpha x}
\big[P_r(e^{b-x})-P_r(e^{\ell-x})\big],
\quad P_r(y)=\operatorname{atanh}y-\sum_{j=1}^{r}\frac{y^{2j-1}}{2j-1}.}
\tag{GE10}
\]

其证明是积分 exp(-(2r+1)v)/(1-exp(-2v))。原子公共左端为 -a，所以计算全窗口配对不需要 x<ell 的公式。Gamma 与反射交换，e=P_+p 给出 q_Gamma(e)=<e,A_Gamma p>，因此可以只计算未偶化 p 的原子再与真实 e 配对。

在 c=lambda^2 为整数时，令 x=log(lambda*q)。所有分段端点 q 都是 1/c、1/m 或 m/c，因而为有理数。乘上 e 后的指数次数为整数；全部积分归结为 exp(kx)、x exp(kx) 和 exp(kx)log(1-s exp(plus-or-minus(x-b)))，s=+/-1。交叉项在积分前全部合并。

置 y=exp(plus-or-minus(x-b))，需要 I_n^s(y)=integral y^(n-1)log(1-sy)dy。对 n>0，

\[
I_n^s(y)=\frac{y^n-s^n}{n}\log(1-sy)
-\frac{s^n}{n}\sum_{j=1}^{n}\frac{(sy)^j}{j}.
\]

对 n=-m<0，

\[
I_{-m}^s(y)=-\frac{y^{-m}-s^m}{m}\log(1-sy)
-\frac{s^m}{m}\log y+\frac1m\sum_{j=1}^{m-1}\frac{s^{m-j}y^{-j}}j.
\tag{GE11}
\]

n=0 时为 -Li_2(sy)。在 y=s=1 的端点，log 项的系数消失，使用其真实有限极限，不能直接求 log(0)。Li_2 的正有理自变量经反射降至 y<=1/2，再使用 420 项正级数与尾界 y^421/[421^2(1-y)]；负自变量由 Li_2(-y)=Li_2(y^2)/2-Li_2(y) 处理。认证器没有 Gamma 频率积分截止，也没有把系统求积误差视为零。

## 6. 从无限 prolate 谱到真正的 C1 模型误差

沿用 (PM1)-(PM6) 的正规自伴 prolate 实现和已认证单位模式，令 K=32、epsilon=10^-25。新程序先重新执行原谱认证。两个真实目标特征值均小于 160，q^2=(6*pi)^2<356，而所有尾对角未扰动能量至少为 4160。原有限提案的最后系数绝对值也由区间检查小于 epsilon。

实际 Jacobi 递推因此给出：真实模式的 K-1 系数最多为 2epsilon；对 r>=K，移去本征值后的对角至少为 4000，两个相邻系数均不超过 356。取 rho=1/4，则

\[
4000-356(\rho^{-1}+\rho)>0.
\]

对尾系数绝对值构造超解 w_j=2epsilon*rho^(j+1)。第一行满足 4000 w_0-356 w_1>=356*2epsilon，其余行由上式控制。更明确地，除以正对角后得到一个非负近邻算子 T，行和不超过 712/4000<1；迭代绝对值不等式时 T^n|psi_tail| 在 l-infinity 中趋零，因为真实 l2 系数有界。超解逐次支配每个部分和。因此

\[
\boxed{|(\psi_i)_{K+j}|\le2\epsilon\rho^{j+1},\quad j\ge0,\ i=0,4.}
\tag{GE12}
\]

这个论证控制全部无限尾，并不以有限截断稳定作为前提。一般尺度也可用同一机制：实际偶谱编号 0、2 的特征值由 min-max 上界 q^2+20 控制，尾对角为 2K(2K+1)，相邻系数<=q^2。选择 K 使 2K(2K+1)-(q^2+20)>q^2(rho+rho^-1)，就得到相同的条件明确的几何比较；数值效率和全尺度 Weil 谱间隔没有由此得到保证。

标准 Legendre 估计 |P_n|<=1 可由 Laplace 积分表示证明；P_n' 展开为奇偶相反的低阶 P_j、系数 2j+1，给出 |P_n'|<=n(n+1)/2。于是本卷归一化偶基满足

\[
\|e_r\|_\infty\le2(r+1),\qquad
\|e_r'\|_\infty\le4(r+1)^3.
\]

低系数误差逐个<=epsilon，结合 (GE12) 与收敛幂级数，得到

\[
\boxed{\|\psi_i-v_i\|_\infty<1200\epsilon,\quad
\|\psi_i'-v_i'\|_\infty<2000000\epsilon.}
\tag{GE13}
\]

具体低端常数为 K(K+1) 和 K^2(K+1)^2；尾端分别用 4 sum_(j>=0)(K+j+1)rho^(j+1) 和 8(K+1)^3 rho(1+4rho+rho^2)/(1-rho)^4。程序以精确有理数核验两条总常数。级数的一致收敛同时正当化逐项求导。

真实零积分系数比仍按 (PM7) 认证。把其误差乘以有限 v0 的值及导数上界后，记 seed 误差为 H0、H1。实际算术合成和偶化的逐段误差满足

\[
D_0=4\sqrt\lambda M H_0,\qquad
D_1=4\sqrt\lambda M(H_0/2+H_1),
\tag{GE14}
\]

因为每个被用到的 seed 参数 m exp(x)/lambda<=1。当前四个可能跳跃位置是 +/-a 和 +/-(a-log2)，不要求端点值消失。

## 7. 无界 Gamma 形式的实际误差运输

设 f 支撑于长度 L 的窗口，逐段 |f|<=D0、|f'|<=D1，有至多 J 个跳跃位置，包括外部端点。对 0<v<1，跨越某个跳跃的 x 的集合测度最多为 Jv；其余部分用均值估计，而两份支撑的并集测度最多为 2L。因此

\[
\|f-\tau_vf\|^2\le2LD_1^2v^2+4JD_0^2v.
\]

K(v)<=3/v 于 (0,1)，K(v)<=2exp(-v/2) 于 [1,infinity)。后一段使用 ||f-tau_vf||^2<=4LD0^2。在 (GE3) 中积分，得

\[
\mathcal G(f)\le3LD_1^2+(12J+16L)D_0^2.
\]

gamma_0 属于 (-7,0)，所以正形式 H_Gamma=q_Gamma+7||.||^2 满足

\[
\boxed{0\le H_\Gamma(f)\le B:=3LD_1^2+(12J+23L)D_0^2.}
\tag{GE15}
\]

这也证明该误差属于真实 Gamma 形式域。对真实模型 e 与多项式模型 e_tilde，令 delta=sqrt(L)D0、n=||e_tilde||。正形式 Cauchy-Schwarz 给出

\[
|q_\Gamma(e)-q_\Gamma(\widetilde e)|
\le2\sqrt{H_\Gamma(\widetilde e)B}+B+7(2n+\delta)\delta.
\tag{GE16}
\]

偶空间的 pole 算子范数为 2(sinh(a)+a)，素数块可保守用 2sum Lambda(m)/sqrt(m)；记二者之和为 W。完整能量差由 (GE16) 加 W(2n+delta)delta 控制，记为 E_q。验证 n>delta 后，

\[
\boxed{\left|\frac{q(e)}{\|e\|^2}-\frac{q(\widetilde e)}{n^2}\right|
\le\frac{E_q}{(n-\delta)^2}
+\frac{|q(\widetilde e)|(2n+\delta)\delta}{n^2(n-\delta)^2}.}
\tag{GE17}
\]

本次 D0<7.718e-21、D1<1.287e-17、B<5.456e-34；完整 (GE17) 小于 3.853e-17。这一步不使用错误的“L2 接近推出无界能量接近”。模型本身逐段 C1，Fourier 变换为 O(1/|t|)，Gamma 为 O(log(2+|t|))，因而还可识别对应算子域；该识别为纸面接口，未包含在新 Lean 中。

## 8. 真正模型的完整能量证书

多项式模型的归一化三项显示值为

\[
q_\Gamma/n^2=-1.2882854172391955064\ldots,
\quad q_{\rm pole}/n^2=1.3064594277789225852\ldots,
\quad q_{\rm prime}/n^2=-0.0181739510485911333\ldots.
\]

程序先在完整定向区间中相加，再归一化，得到多项式 Rayleigh 值约 5.94911359454920235e-8。加上 (GE17) 的真实模型误差，最终认证

\[
\boxed{\frac{594911359}{10^{16}}
<\frac{q_a(e)}{\|e\|^2}
<\frac{594911360}{10^{16}},\qquad a=\tfrac12\log3.}
\tag{GE18}
\]

这是实际零积分 prolate 直线经算术合成与偶化后的完整 Weil 能量，包含所有 Gamma 频率、pole、prime 和奇偶混合贡献。它不是只在有限 Fourier 矩阵上计算的 Rayleigh 商。

该区间高于原固定 dyadic 候选的已认证上界 U=560909/10^13。因此，在沿用旧候选证书的范围内，当前 prolate 模型并非这个固定窗口的精确最低向量。这个事实与文献要求“充分精确逼近”一致。没有得到更好的真实最低特征值上界或新的间隔，也不能由能量小直接推出全算子残差小。

## 9. 实际运行与剩余承重问题

同一完整 verifier 在 110 和 130 位定向区间精度均实际通过，并重新执行了前置无限 prolate 谱认证。无 eigensolver、zeta 零点输入或数值求积参与新能量证书。Dilogarithm 的所有未求和项以明确正尾界覆盖，端点奇性使用真实极限。信任基础仍包含 mpmath.iv、Python 和整数/超越函数区间实现，并未在 Lean 内核中重放。

独立开发检查包括 30 个精确多项式端点例子、32 个对数原函数符号导数，以及 20 个直接无限 Gamma 核数值积分对照。最后一组最大相对差约 3.229e-65；它是非区间的独立诊断，不是能量证书的一部分。删除原子外部 Gamma 作用、过强的 1/100 几何尾比都有失败控制。新 Lean 的主声明和唯一 Scribe handle 一致；没有 authored sorry、admit 或新 axiom，但未运行编译与公理报告。

Verifier SHA-256：`d48dd32752a76edff93331cee6825d12e6c67fe46aa811e48e11b05ab96f646b`。
开发检查 SHA-256：`105be445623262b52fa6d7f2d338723f8085404080f152750cbef92b7fedfc6a`。

(GE5)-(GE8)、(GE9)-(GE11) 的公式是参数化的；(GE12)-(GE18) 的严格数值在当前 c=3 实例兑现。本轮消除了真实 prolate 模型的完整 Gamma 能量尚无受控评价这一缺口。尚未证明沿无界尺度的候选正交补强制性、相对于间隔的小残差、足够的复 Fourier 读出率或真实模态的 Xi 极限。

下一数学任务应利用 (GE7) 的同一模型表达估计完整算子作用，或直接认证实际 energy-dual 读出，而非继续以单个 Rayleigh 数字替代模型逼近。尤其必须保留 E(T_lambda h)、D_+r、prime 奇修正与 pole 项之间的相消。#6029 的消矩尾界可用于独立选取的 dual trial，不能借它把本节真实 prolate 模型的非零边界矩设为零。

参考：

- Connes, Consani, Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1, Sections 7-8. https://arxiv.org/html/2511.22755v1
- Connes, *The Riemann Hypothesis: Past, Present and a Letter Through Time*, arXiv:2602.04022, Sections 6.4-6.6. https://arxiv.org/html/2602.04022
- Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v1. https://arxiv.org/abs/2606.09096
- Groskin, *A finite Guinand-Weil dictionary and archimedean tail order for the truncated Weil quadratic form*, arXiv:2607.02828v1. https://arxiv.org/abs/2607.02828
- NIST DLMF 5.7.6, 14.7, 14.10, 14.12 and 30.8, digamma and Legendre/spheroidal identities. https://dlmf.nist.gov/5.7 ; https://dlmf.nist.gov/14.7 ; https://dlmf.nist.gov/14.10 ; https://dlmf.nist.gov/14.12 ; https://dlmf.nist.gov/30.8
- loning research #5892, actual source at `54f78c385cebdccb0b768b8a25b75dc04454b53e`; AlyciaBHZ #6029, actual source at `a2c2ccdc1fde62627deab56bbdea433c782621dc`; #5882 current PR description at `65339a3acbe99e661c6955dbb21728c4c62dfe76`.
