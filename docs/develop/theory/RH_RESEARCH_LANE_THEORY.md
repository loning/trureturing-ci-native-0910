- Existing owners: `WeilMellinPrimeIntertwining`, `HiddenArithmeticWeightFormula`, #6050 and #6131 at the pinned sources above. Arithmetic coverage, finite products and logarithmic derivatives are classical tools; no mathematical priority is claimed.


---

## [PR #5602] GAMMA_FORM_SCALE_CONTINUITY_AND_PRIME_ACTIVATION

# 2026-09-07：跨素数阈值的实际 Weil 闭形式连续性与局部谱传递

新 Lean：`D5/S3/Weil/ZetaBridge/WeilGammaScaleModulus.lean`，配套同名 Scribe。执行源与结果为 `research/weil_ground_mode/certify_weil_scale_modulus.py`、`weil_scale_modulus_certificate.json`；第二表达诊断为 `test_weil_scale_modulus.py`、`weil_scale_modulus_regression.json`。

本节完成参数化的实际 Gamma/素数形式模量，继而在纸面上证明同一 Friedrichs 实现经单位伸缩后的共同形式域、紧 resolvent 与范数 resolvent 连续性。它允许穿过素数幂激活点，并将已认证简单偶最低模态局部延拓。核心估计来自原 Gamma 的正部分分式；没有假设整个算子连续。普通算子范数在激活处确实存在跳变，并给出 Gamma 形式范数下仅对数速度的下界。新 Lean 保存有限正部分和、调和高频下界与实际余弦乘子估计；Plancherel、核心、形式表示和谱投影仍是下面的纸面证明，未报为内核结果。

## 1. 两条最新研究线与本节的不同义务

实际读取 #6029 在 `5c2898869032745b06ac30af97181b67243d5e44` 的 `WeilBoundaryKernelIntegral.lean`。它从 sine 因子和共同可积控制出发，识别原始 Gamma 边界级数与奇核积分；本节不重复该积分等式。其算子域与全部真实矩阵识别仍有各自义务，不能用一条标量边界等式代替。

5040 研究的新 #6171 已移入 Mertens 第三定理。实际读取 `D5/S3/Weil/Mertens/Third.lean`，blob `435484ecbfc11097a057d6b435045728a6e41f01`：`Mertens.E₃.bound''` 给出标量 prime product 与 exp(-gamma)/log x 的渐近等价。这个重要输入可以供 Robin/Gronwall 线使用，却不是 s=1/2 的压缩平移算子范数估计。本节没有复制移植，也没有重新运行其编译或宣称它提供当前谱间隔。

外部目标仍是 CCM arXiv:2511.22755v1 Section 8 的真实最低模态单纯偶性和充分准确的 prolate 逼近。DLMF 5.7.6 提供同一 digamma 部分分式。Mugnolo-Nittka-Post arXiv:1007.3932v2 的 abstract 是变空间范数 resolvent 收敛的经典方法背景；下面直接证明本算子的共同空间估计，未借用其几何特定假设。没有经典形式理论或数学优先权声明。

## 2. 统一到固定空间，保持所有算术项

令 a>0，并用酉伸缩 J_a:L2([-a,a])->H=L2([-1,1])，(J_a f)(y)=sqrt(a)f(ay)。记 Atilde_a=J_a A_a J_a^-1。全部 Fourier 积分对 H 中函数的零延拓进行，仍采用 paperFT 正号和 (2*pi)^-1 的 Plancherel 因子。

记 gamma(t)=Re psi(1/4+it/2)-log pi，gamma0=gamma(0)。在共同空间中，Gamma 乘子是 gamma(xi/a)，pole 积分核是 2a*cosh(a(x-y)/2)，无符号素数块是

\[
S_a=\sum_{2\le n\le P}w_n(T_{\log(n)/a}+T_{\log(n)/a}^*),
\quad w_n=\Lambda(n)/\sqrt n,
\quad T_s f(x)=1_{[-1,1]}(x)\widetilde f(x+s).
\tag{SC1}
\]

在固定参数区间 0<m<=a<=A 中，P=floor(exp(2A)) 足够。这个共同索引集合包括所有素数幂。若 log(n)/a>=2，对应压缩平移为零；等号只剩零测端点。因此在阈值两侧使用同一有限求和，不删除刚进入的项。实际形式是 qtilde_a=qGamma_a+qpole_a-qS_a。

## 3. 实际 Gamma 权重的高频下界及尺度导数

由 DLMF 5.7.6，令 b_j=2j+1/2，则

\[
W(\xi):=1+\gamma(\xi)-\gamma_0
=1+\sum_{j\ge0}\frac{2\xi^2}{b_j(b_j^2+\xi^2)}\ge1.
\tag{SC2}
\]

级数在有界频率上绝对且局部一致收敛。新 Lean 的 `gammaShiftPartial J xi` 是其前 J 项加一，未定义第二个 gamma 函数。当 |xi|>=2J 时，b_j<=|xi| 且 b_j<=2(j+1)，每个 summand >=1/[2(j+1)]，故

\[
\boxed{W(\xi)\ge W_J(\xi)\ge1+H_J/2\quad(|\xi|\ge2J).}
\tag{SC3}
\]

其中 H_J 是复用的标准 harmonic number。结合 |cos(s xi)-cos(t xi)|<=min(2,|s-t||xi|)，新主声明 `gamma_controlled_cosine_difference` 证明更强的有限和版本

\[
\boxed{|\cos(s\xi)-\cos(t\xi)|
\le\left(2J|s-t|+\frac2{1+H_J/2}\right)W_J(\xi).}
\tag{SC4}
\]

J=0、xi=0 和两个方向的实位移均包含。没有预先供应平移连续性或未知符号高频下界。

对 log-frequency 求导，非零 t 给出

\[
t\gamma'(t)=\sum_{j\ge0}\frac{4b_jt^2}{(b_j^2+t^2)^2}.
\]

初项 b_0=1/2 至多为 2，由 2(t^2+1/4)^2-2t^2=2(t^2-1/4)^2>=0。其余 b=2j+5/2 在 u∈[b-1,b] 上满足

\[
\frac{4bt^2}{(b^2+t^2)^2}\le\frac53\frac{4ut^2}{(u^2+t^2)^2}.
\]

这就是新 Lean `gamma_log_scale_derivative_term`。这些单位区间互不相交，右侧未乘 5/3 的函数在 (0,infinity) 上积分为 2，原函数为 -2t^2/(u^2+t^2)。因此整个和 <=2+10/3<6。微分级数在有界 t 区间以 O(b_j^-3) 局部一致收敛，逐项求导合法；t=0 单独为零。沿对数坐标积分得到

\[
\boxed{|\gamma(\xi/a)-\gamma(\xi/b)|\le6|\log(a/b)|\quad(a,b>0).}
\tag{SC5}
\]

该界不假定 digamma 整体单调，也不依赖数值拟合。它还给出 W(xi)=O(1+log(1+|xi|)) 的上界。

## 4. 共同闭形式域与实际 Friedrichs 实现

定义正参考形式

\[
\mathcal H(f)=\frac1{2\pi}\int_\mathbb R W(\xi)|\widehat f(\xi)|^2d\xi,
\qquad V=\{f\in H:\mathcal H(f)<\infty\}.
\tag{SC6}
\]

W>=1，所以 H 范数由该形式范数控制。加权 L2 的完备性与支撑子空间的闭性证明 V 完备。由 (SC5)，各 gamma(xi/a) 与 gamma(xi) 只差一个有界乘子；prime 与 pole 也是有界扰动，因此所有 qtilde_a 的闭形式域均为 V。

还须识别原先的核心。对任意 f∈V，先作空间收缩 f_r(x)=r^-1/2 f(x/r)，r<1。其支撑进入 [-r,r]，且在参考形式范数中趋于 f：在全线加权 Fourier 空间，伸缩在紧频率光滑函数上强连续，(SC5) 又给出 r 接近 1 时统一的算子范数界，故由稠密性推广到所有加权 L2 函数。随后用支撑半径小于 1-r 的光滑 mollifier 卷积，保持支撑在 (-1,1)；Fourier 乘子有统一界且逐点趋于 1，支配收敛给出参考形式范数逼近。于是 C_c^infinity(-1,1) 在 V 稠密，各形式正是原测试形式的 Friedrichs 闭包。未改选别的自伴延拓或周期边界。

(SC3) 还证明 V 到 H 紧嵌入：参考形式单位球的 |xi|>2J Fourier 质量至多为 1/(1+H_J/2)，而支撑窗口到固定有界频带的 Fourier 积分算子是 Hilbert-Schmidt。有限频带近似配合趋零尾部给出紧性。故每个实际闭形式的 resolvent 紧。

## 5. 跨所有阈值的显式形式模量

在 0<m<=a,b<=A，pole 核对 a 的导数绝对值 <=2(cosh A+A sinh A)。Schur 检验乘上窗口长度 2，给出 ||P_a-P_b||<=4(cosh A+A sinh A)|a-b|。由 (SC4) 对实际 symmetric prime quadratic form 逐项积分，得到

\[
\boxed{|\widetilde q_a(f)-\widetilde q_b(f)|\le\varepsilon_J(a,b)\mathcal H(f),\quad f\in V,}
\tag{SC7}
\]

\[
\begin{aligned}
\varepsilon_J(a,b)={}&6|\log(a/b)|+4(\cosh A+A\sinh A)|a-b|\\
&+2\sum_{n=2}^{P}w_n\left[2J\log n\,|a^{-1}-b^{-1}|+
\frac2{1+H_J/2}\right].
\end{aligned}
\tag{SC8}
\]

固定 J 后令 b->a 控制低频；先取 J 足够大控制高频，证明形式范数连续。在原 c=3 点，n=3 本来仅有零测端点，向右扩大后它也自动包含在同一个式子中。

为使模量完全显式，取 J=2^k、|a-b|<=4^-k。逐个 dyadic harmonic block 的质量至少为 1/2，故 H_(2^k)>=1+k/2。利用 |log(a/b)|<=|a-b|/m 和 |a^-1-b^-1|<=|a-b|/m^2，得

\[
\boxed{\varepsilon\le C_0 4^{-k}+C_1 2^{-k}+C_2/(k+6),}
\tag{SC9}
\]

其中 C0>=6/m+4(cosh A+A sinh A)，C1>=4 sum w_n log(n)/m^2，C2>=16 sum w_n。对于 k>=4，2^k>=k^2 还给出短有理预算 C0/k^4+C1/k^2+C2/(k+6)。此极限对每个正紧参数区间成立，常数不被视为在 a->infinity 时统一。

## 6. 直接得到范数 resolvent 控制和局部简单偶性

选共同实移位

\[
C\ge1-\gamma_0+6\max(|\log m|,|\log A|)+2\sum_{n=2}^{P}w_n+4A\cosh A.
\tag{SC10}
\]

则 b_a(f)=qtilde_a(f)+C||f||^2>=H(f)>=||f||^2。令 R_a=(Atilde_a+C)^-1。由 (SC7) 的 Hermitian polarization，差形式满足 |(b_a-b_b)(f,g)|<=epsilon sqrt(H(f)H(g))。具体可先选相位使交叉项为实，用 f+g、f-g 的对角界，再对两个向量作互反缩放，得到恰为 epsilon 的常数。

变分表示给出 H(R_a x)<=b_a(R_a x)=Re<x,R_a x><=||x||^2，因为 ||R_a||<=1。对 R_b x、R_a y 用差形式 resolvent identity，得到

\[
\boxed{\|R_a-R_b\|\le\varepsilon_J(a,b).}
\tag{SC11}
\]

这一步只用前面实际形式域和移位估计，没有假设未移位算子差在普通范数中趋零。由 (SC9)，a->R_a 在整个 (0,infinity) 上范数连续，包含全部素数幂阈值。

如果在 a0 已有真实简单最低值 lambda0<=U<T<=lambda1，则 R_a0 的最大特征值间隔至少为 g=1/(C+U)-1/(C+T)>0。当 (SC11) 的上界 eta<g/4 时，min-max 给出邻近 R_a 最大间隔 >=g-2eta；最大特征向量与旧向量的相位对齐距离 <=sqrt(2)eta/(g-eta)，由旧正交补上的谱投影估计得到。实际反射与所有算子交换，新简单特征向量具有确定奇偶性；它若为奇函数就与旧偶向量正交，和上述距离矛盾。因此简单偶最低线局部保持。

若原点 Fourier 值已认证非零，局部归一化也合法。在共同空间中其比值为 integral g_a(y)exp(i*a*z*y)dy / integral g_a(y)dy，sqrt(a) 消去。模态 L2 连续性和有限窗口上的指数核界给出复紧集上的局部一致连续性。这里没有把局部连续性变成 a->infinity 的 Xi 极限，也不排除更远尺度发生谱线碰撞。

## 7. 实际常数证书，以及不能夸大的步长

程序在 90、120 位定向区间精度分别执行，认证两组完整常数：

| 半宽参数区间 | 包含的全部 prime powers | C0,C1,C2 | 共同移位 C |
|---|---|---|---|
| [1/2,3/5] | 2,3 | 19,17,18 | 16 |
| [23/20,5/4] | 2,3,4,5,7,8,9,11 | 21,22,69 | 26 |

它们是 (SC9)-(SC11) 的系数证书，未计算新的最低值或间隔。读取旧 c=3 的 U=560909/10^13、T=3/250000，仅作继承条件下的演示，得到 g=29859772750000/640000482243637682727。程序以精确有理运算检查 k=4629643545 的上预算 <g/4，对应

\[
|a-\log3/2|\le2^{-9259287090}.
\tag{SC12}
\]

这个保守半径确实非零，但极小，不是有实用意义的尺度扫描结果。它说明当前全空间最坏情形模量与旧极小间隔组合非常低效。下一步必须保留低能子空间和高频 Schur 结构，不能把 (SC12) 的形式正确性当成有效的无界推进。旧完整谱/LDL 验证器本轮没有重跑，所有局部 ground 结论均明确继承它原来的证明范围。

## 8. 5040 的首缺失素数给出真实障碍和对数下界

沿用前节 divisor logarithmic derivative 的精确字典。a*=log11/2；当 a*<a<log13/2 时，完整素数作用与 5040 有限因数表示之差恰为 prime 11 项。伸缩到 H 后，其无符号对称差是

\[
B_{11,a}=w_{11}(T_s+T_s^*),\quad w_{11}=\log11/\sqrt{11},
\quad s=\log11/a\in(1,2).
\]

令 h=2-s>0。T_s 把右端长度 h 的区间等距搬到左端同长区间，两区间不交且 T_s^2=0。取两个端点条带上的同形单位函数，T_s+T_s^* 在其 span 中就是 [[0,1],[1,0]]；在其余部分范数也至多 1。因此

\[
\boxed{\|B_{11,a}\|=\log11/\sqrt{11}=0.722992627858\ldots,
\qquad B_{11,a_*}=0.}
\tag{SC13}
\]

它是当前 prime 缺失块的精确普通范数跳变。不能把“新相交区间很短”当作小的全 L2 算子范数。

但在 Gamma 形式范数下可以趋零，而且对数速度有真实下界。令 phi=1_[0,1]，则 ||phi-tau_v phi||^2=2min(v,1)。从此前的同一 Gamma kernel、K(v)<=3/v 于 (0,1)、K(v)<=2exp(-v/2) 于 [1,infinity)，得 H(phi)<=15。缩小到长度 h 的单位 packet phi_h，由 (SC5) 得 H(phi_h)<=15+6log(1/h)。把两个端点 packet 作偶组合 f_h=(phi_left+phi_right)/sqrt(2)，则 ||f_h||=1，<f_h,B11,a f_h>=w11，并由正形式 Cauchy-Schwarz 有 H(f_h)<=30+12log(1/h)。所以

\[
\boxed{\sup_{f\ne0}\frac{|\langle f,B_{11,a}f\rangle|}{\mathcal H(f)}
\ge\frac{w_{11}}{30+12\log(1/h)}.}
\tag{SC14}
\]

这些跳跃 packet 属于真实形式域，其可积性已经由同一个平移积分直接证明；不要求它们属于测试核心。上界则来自 (SC4)，把 T_s+T_s^* 与窗口内为零的 T_2+T_2^* 比较。取 J 约 h^-1/2，两侧给出这个 prime 缺失块在参考形式范数中的量级 1/log(1/h)。因此它不满足任何 O(|a-a*|^alpha)、alpha>0 的 Hölder 估计。这个 sharpness 断言针对该已分离的 prime 块，不宣称完整闭形式的最佳常数或所有谱投影的正则性。

## 9. 已执行验证与剩余目标

有限常数认证器不读 zeta 零点、不调用 eigensolver、也不把历史证书 JSON 当成新的谱证明。90 位最终重放的结果 SHA-256 与第一次相同：`29fa6b629121e64fb7e460147099b26d8dd49d408bafedfe1d6323722f01cbbc`。120 位重放得到同样的整数常数及严格 rational guards。常数源 SHA-256：`b9130322e9724800fb86f7f401ee82c915c26cb4f03994fc44333aea1ae88b6c`。

第二表达检查包含 600 个精确高频下界、600 个精确 Gamma 导数项比较、11 个 harmonic dyadic 界、997 个指数/多项式比较、29 个端点 packet、999 个独立素数幂分解，另有 126 个余弦、28 个原 digamma 缩放、5 个原 digamma 导数诊断。后者是非定向数值诊断，未当作证明；导数有限和的遗漏项另有正积分上界。最初一次符号测试使用结构相等比较两个等价多项式而失败，改为展开差为零后通过，未改数学结论。诊断源 SHA-256：`2cf557efe7833d5d5a6066f23a29f4a27e0624f989c743cb68e5fa010b224d38`。

新 Lean 的五个公开定义/定理有五个 matching FromLean Scribe 条目。Lean/lake/dotnet 在本执行环境不可用；未执行 elaboration、Scribe emission、传递公理报告或独立作者审查。没有新 authored sorry、admit 或 axiom。实际代码、纸面桥与数值常数的范围各自保留。

本节移除了把相邻窗口当成同一有界范数小扰动的错误捷径，提供同一实际 Gamma/算术族的可验证形式模量和局部谱传递机制。下一承重工作应将该模量分解到真实低能块与其 Schur 补，在跨阈值时保留那些低能向量的端点耦合，以获得可用步长。无界尺度的简单偶最低族、prolate 误差衰减和原点归一化 Xi 极限仍未建立。

参考：

- Connes, Consani, Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1, Sections 3-4, 8. https://arxiv.org/html/2511.22755v1
- NIST DLMF 5.7.6, the actual digamma partial fraction. https://dlmf.nist.gov/5.7.E6
- Mugnolo, Nittka, Post, *Convergence of sectorial operators on varying Hilbert space*, arXiv:1007.3932v2; abstract read for method context only. https://arxiv.org/abs/1007.3932
- #6029 actual `WeilBoundaryKernelIntegral.lean`, blob `dd8c742820f623257ed37aa15d868bb2db09301b`; #6171 actual `Mertens/Third.lean`, blob `435484ecbfc11097a057d6b435045728a6e41f01`.
