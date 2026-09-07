- AlyciaBHZ #6029 actual `WeilArithmeticResidualPrecision.lean` at `3037f47c69bf1f4065870413cc354c8995139258`; #5882 and #5895 current PR descriptions; loning research #6044 actual `GribinskiDegreeTwo.lean` at `ca166f8b2ae3ef27e210622303e8e94ce4ab98c3`.


---

## [PR #5602] ACTUAL_ARITHMETIC_ENERGY_DUAL_FOURIER_CERTIFICATE

# 2026-09-07：实际算术对偶试探、完整无限尾与真模态/prolate 的复圆盘误差

Lean：`D5/S3/Weil/ZetaBridge/WeilEvenDualStencil.lean`，配套同名 Scribe。
执行源：`research/weil_ground_mode/certify_prime3_energy_dual.py`，固定输入 `prime3_energy_dual_trial.json`，输出 `prime3_energy_dual_certificate.json`。
独立公式诊断：`test_even_dual_stencil.py` 与 `even_dual_stencil_regression.json`。其中“独立”仅指另一份组装表达；作者仍为同一助手。

本节将 #5882 已有的全残差能量对偶原理实例化到实际 prime/pole/Gamma 算子。中心 20+i/4 的平方读出预算较同一偶代表元的零试探预算改善超过 450 倍；同一个精确试探函数控制半径 1/1000 的整个复圆盘，并接到真正 prolate 模型的同相位比较。旧完整谱/强制性证书被明确继承，没有在本轮重新运行。新数值证书重放真正 prolate 模型认证，重新计算实际矩阵、试探函数、完整残差和 Fourier 值。Lean/Scribe 编译及传递公理审查未运行。

## 1. 同一算子上的已有变分消费者

取 L=log3、a=L/2，仍用 V_n(x)=(-1)^n exp(2*pi*i*n*x/L)/sqrt(L)。k 是此前固定的归一化实偶 129 系数 dyadic 候选；u 是同一 Weil 实现的真实最低模态。继承本卷完整 Neumann-even/log-weighted-odd 证书的

\[
\ell=2252813807/40960000000000000,\quad
U=560909/10^{13},\quad T=3/250000.
\]

它提供 lambda_0>=ell、q(k)<=U 和整个候选正交形式域上的 q(f)>=T||f||^2，并得到简单偶最低线及非零 alpha=<k,u>。本轮只重新检查固定 k 的 Rayleigh 上界；全空间 Schur/LDL 下界及其域桥保持原有纸面/区间范围。令 M=A_a-ell、kappa=T-ell>0、Delta=U-ell。

直接复用 #5882 的 `CoerciveDualCertificate.dual_energy_readout` 和 `ProjectiveEnergyDual`，不复制一般变分证明。其实际误差 w=u/alpha-k 满足

\[
w\perp k,\qquad 0\le q_M(w)\le\Delta.
\tag{AD1}
\]

对复偶向量 g 和同一算子域中的任意 v perpendicular k，记

\[
r_g=P_{k^\perp}(g-Mv),\qquad
C_g(v)=2\Re\langle g,v\rangle-q_M(v)+\|r_g\|^2/\kappa.
\]

该既有定理证明 C_g(v)>=0，且

\[
\boxed{|\langle g,w\rangle|^2\le\Delta C_g(v).}
\tag{AD2}
\]

M 不需要成为全空间有界算子；Mv 必须真实属于 L2。r_g 的范数必须包含所有遗漏模式。下面的任务是认证一个具体非零 v 的 C，而非假定最佳对偶解或先提供目标方向不等式。

## 2. 精确试探函数同时保留两个约束

在原始带正负编号的 Fourier 坐标中令 v_-n=v_n=t_n。自由系数 t_2,...,t_64 是分母 2^44 的固定 Gaussian 有理数，载于 JSON。它们来自不受信任的有限最小残差提案；优化器不属于认证器输入结论，也不证明最优。

设 k 的未归一化整数坐标为 s_n=s_-n，S=sum_(n=2..64)t_n，W=sum_(n=2..64)s_n*t_n。验证 s_1!=s_0 后，以精确有理运算重构

\[
t_1=(s_0 S-W)/(s_1-s_0),\qquad t_0=-2(S+t_1).
\tag{AD3}
\]

所以在最终同一组系数上严格有

\[
t_0+2\sum_{n=1}^{64}t_n=0,\qquad
s_0t_0+2\sum_{n=1}^{64}s_nt_n=0.
\tag{AD4}
\]

前者是两端 trace 为零，后者是 v perpendicular k，归一化 k 的平方根完全消去。两条等式都对实部、虚部作精确有理数检查。若重构后再次舍入 pivot，必须重新认证；本次未作这种舍入。该有限偶 Fourier 函数的端点导数也为零，零延拓为 C1 分段光滑函数；它属于本卷已识别的实际 Gamma/Weil 算子域。

等价地，v=sum_(n=1..64)t_n(V_n+V_-n-2V_0)。这是一个实际可用的边界零值子空间，未声称覆盖所有对偶函数。只需要一个合法试探就能使用 (AD2)。#6029 的标准正交投影可以处理一般试探；它本身不保持额外的 trace 条件，所以这里一次解两条约束，之后重算所有预算。

## 3. 新 Lean 给出实际零 trace 偶模板的全尺度算术尾

用既有 `arithmeticBoundarySymbol c n` 记 s^(c)_n。新源从其完整 finite-prime、pole 和 infinite-Gamma 定义证明

\[
s^{(c)}_{-n}=-s^{(c)}_n,\qquad s^{(c)}_0=0.
\]

Gamma 级数的绝对收敛及原始 B_c 包络沿用 `WeilArithmeticCouplingJet`。私有 real-frequency 写法只是该表达式的 definitional presentation，没有第二个公开算术 owner。

独立定义 `zeroTraceColumn` 为原 `couplingColumn` 在 {n,-n,0} 上、系数 1,1,-2 的作用。对整数 n>0、|m|>n，展开原矩阵列并检查分母，证明

\[
\boxed{a_{mn}+a_{m,-n}-2a_{m0}
=\frac{2n(ms^{(c)}_n-ns^{(c)}_m)}{\pi m(m^2-n^2)}.}
\tag{AD5}
\]

这里 a_mn=(s_n-s_m)/(pi*(m-n)) 是原 Weil Fourier 非对角项，符号和所有 prime powers 不变。由已证明的 |s_j|<=B_c，当 |m|>=2n 时，

\[
\boxed{|a_{mn}+a_{m,-n}-2a_{m0}|
\le\frac{4B_c n}{\pi |m|^2}.}
\tag{AD6}
\]

证明先把分子界为 2n B_c(|m|+n)，与 m^2-n^2=(|m|-n)(|m|+n) 中的正因子抵消，再用 |m|-n>=|m|/2。两个方向的 m 均被覆盖。有限复合成得

\[
\boxed{|(Av)_m|\le\frac{4B_c}{\pi |m|^2}
\sum_{n=1}^{N}n|t_n|,\qquad |m|\ge2N.}
\tag{AD7}
\]

新 Lean 保存 (AD5)-(AD7)，没有接收“两个边界矩恰为零”的额外假设。正负模板与 trace 的实际系数组合已经消去了第一阶项。无限平方尾的求和及物理 Fourier 识别继续由下面的纸面桥承接。六个公开定义/定理有六个 matching FromLean Scribe handles，未声称已编译。

## 4. 原始 Fourier 代表元及完整残差

在偶扇区使用 g_z(x)=conjugate(cos(zx))，仍有 <g_z,f>=Zeta23.paperFT(f,z)，因为 f 为偶函数。直接积分、保留 V_n 的相位，得到

\[
(g_z)_n=\overline{\frac{2z\sin(az)}{\sqrt L\{z^2-(2\pi n/L)^2\}}}.
\tag{AD8}
\]

在本次非实圆盘中分母均非零；一般实共振点须按可去极限处理，未用 totalized division 改变 Fourier 值。取 w_z=L conjugate(z)/(2*pi)、eta_z=-L^(3/2)conjugate(z sin(az))/(2*pi^2)，则该系数为 eta_z/(n^2-w_z^2)。

对 m>M>=max(2N,2|w_z|)，(AD7) 给出完整对偶残差的

\[
|(g_z-Av)_m|\le Q/m^2,\quad
Q=4|\eta_z|/3+(4B_c/\pi)\sum n|t_n|.
\]

k 和 v 在 |m|>N 都没有系数，所以候选投影和 ell 移位在这些模式不增加项。因此

\[
\boxed{\sum_{|m|>M}|(r_{g_z})_m|^2\le2Q^2/(3M^3).}
\tag{AD9}
\]

此处 sum_(m>M)m^-4<=integral_M^infinity x^-4 dx=1/(3M^3)，没有终端外部截止。实际 B_3=4/sqrt3+log2/sqrt2<3，由定向区间重新验证。

中心 z0=20+i/4 采用 M=32768。内部完整矩阵保留原 Gamma、pole、prime 对角及非对角。投影使用 s*(sum s_j d_j)/(sum s_j^2)，不把近零配对当作零。所有 65<=|m|<=M 的实际符号和残差以向外舍入区间逐项计算；末次和把每个 binary64 上端点解码为精确二进制有理数后相加，未使用无误差预算的浮点求和。结果的数值显示为：

\[
\|P_{|n|\le64}r\|^2\approx0.0011552183026,\qquad
\sum_{65\le|n|\le M}|r_n|^2\le0.000053760121725,
\]

\[
\sum_{|n|>M}|r_n|^2<7.00\cdot10^{-11},\qquad
2\Re\langle g_{z0},v\rangle-q_M(v)\approx1.14338908925.
\]

第二、第三项是上预算，不能从其正值推出真实尾质量的正下界。程序中 `center_dual_budget_upper_enclosure` 是一个充分上预算表达式的区间，不冒充精确 C 的双侧包络。

## 5. 一个真正兑现的方向改进

对本次精确试探，全部尾项进入 (AD2) 后，定向程序认证

\[
\boxed{C_{g_{z0}}(v)<103.}
\tag{AD10}
\]

同一个偶代表元和同一个 k 的零试探系数为

\[
C_{g_{z0}}(0)=\frac{\|g_{z0}\|^2-|\widehat k(z0)|^2}{\kappa}
\approx46606.0312896>46600.
\]

这里 ||g_(x+iy)||^2=sinh(2ay)/(2y)+sin(2ax)/(2x)，由原窗口积分计算。因此零试探平方误差预算除以新上预算大于 450。这个倍数比较的是两条严格充分误差预算，不是已知真实误差之比，也不宣称 v 最优。

中心实际 \(\widehat k(z0)\approx0.00129085884882-0.00041814144000i\)。新上预算约 102.35548858，来自真实算术数据而非任意正定模型。有限矩阵中的近似优化只提出系数，不提供证书结论。

## 6. 同一个试探控制整个复圆盘

令 D={z:|z-z0|<=rho}，rho=1/1000，b=1/4+rho。对整个线段积分 cos 的复导数，

\[
\|g_z-g_{z0}\|\le H\rho=:d,
\qquad H=a\sqrt L e^{ab}.
\]

候选投影收缩，故若 R^2 是中心完整残差的上界，同一 v 在 D 上满足

\[
\boxed{C_{g_z}(v)\le C_{g_{z0}}(v)+2d\|v\|
+(2Rd+d^2)/\kappa.}
\tag{AD11}
\]

无需对每个 z 重新求解或选择独立相位。程序认证右侧小于 107，进而

\[
\boxed{\sup_{z\in D}\left|\widehat u(z)/\langle k,u\rangle-\widehat k(z)\right|
<342/10^6.}
\tag{AD12}
\]

同时由 |khat(z)|>=|khat(z0)|-d，得到

\[
\boxed{\inf_{z\in D}|\widehat u(z)/\langle k,u\rangle|>3/10000.}
\tag{AD13}
\]

这一非零下界是带数值裕量的读出认证。此前若已经承接实际 ground Fourier 的实零点定理，离实轴非零的定性事实本来已知；本节不把 (AD13) 包装为新的定性零点区域或 RH 进展。新的数学用途是 (AD12) 的实际定量方向误差。

## 7. 接回真正 prolate 模型，而非任意候选

重放 `certify_prime3_prolate_model.py`，包括完整 Legendre 尾与谱隔离，得到前节的真实单位模型与 k 的 L2 比较。由于多项式模型与 k 的内积严格为负，固定全局符号

\[
v_P=-p_h^+/\|p_h^+\|,\qquad \|k-v_P\|<113/100000.
\]

真实 prolate 是此前同一零积分正规模式组合，不等同于 k 或 v。用既有多项式 Mellin 端点 Fourier 公式计算中心值，并用已认证真实模型误差运输，得

\[
|\widehat k(z0)-\widehat v_P(z0)|<43/10^6.
\tag{AD14}
\]

其区间上预算约 0.000042965393621。对于整个 D，在差函数 k-v_P 上使用代表元的 Lipschitz 估计，而非分别粗估两个单位函数，故 (AD12) 加 (AD14) 给出

\[
\boxed{\sup_{z\in D}|\widehat u(z)/\langle k,u\rangle-\widehat v_P(z)|
<387/10^6.}
\tag{AD15}
\]

保守上预算的实际区间约为 0.00038410895419。归一化在整个圆盘固定，没有用频率依赖的任意因子缩小误差。最终通向 Xi 的文献归一化仍需沿无界尺度单独保持；本节单位模型比较不会替代它。

## 8. 研究来源、复验与剩余问题

本轮读取 #5882 提交 `65339a3acbe99e661c6955dbb21728c4c62dfe76` 的实际 `CoerciveDualCertificate.lean`，而非仅沿用 PR 名称。后续查阅 #6029 当前 `a00b579d8202bc839cb780ee1159b2a49b0592e4` 的 `WeilOrthogonalTrialPrecision.lean`：一般正交投影之后必须更新所有边界矩，不能沿用投影前的精确消矩。该源码和本节两个约束的同时有理解一致，但没有被复制为第二套投影理论。

读取 loning #5326 的实际理论 C13.3（提交 `3beb435bf9ca8aa35aa6079ea4033a9c2e6c9007`）：固定复边界的非零裕量和逼近误差必须同时兑现，且一个有限深度不能覆盖所有高度。这对应本节明确的有限圆盘与剩余尺度条件。新近 author:loning 的工程 PR 只作范围辨识，没有修改或用作数学依赖。

原始文献仍为 CCM *Zeta Spectral Triples*, arXiv:2511.22755v1, Sections 4,7,8，和 Connes arXiv:2602.04022v1, Sections 6.4-6.6。Cancès 等 arXiv:2008.04140 的保证型后验谱估计说明能量/对偶残差与谱分离需要同时处理；其 elliptic/FEM 特定假设未移植到 Weil 算子。另查阅外部 `monksealseal/rh-spectral` 的研究记录：其部分比较使用已知 zeta 零点，且明确撤回若干简单性推理；这些非正式记录不提供本节定理，当前验证器也不读取 zeta 值或零点。

新 verifier 在 110 和 130 位定向区间精度分别实际通过，最后又重放 110 位版本。内部 bulk 符号使用原向外舍入 binary64 包络，较高工作精度不被误称为每个输入有 110 位准确度。精确回归包括一个符号模板恒等式、1000 个有理系数界、18 个有符号实际符号诊断和 6 个原列/模板列对照；后两组是非定向高精度独立表达诊断，不能替代区间证明。改变输入字节、启用 -O、低于允许精度均被实际拒绝。pivot 再舍入破坏等式也有精确失败见证。

源 SHA-256：`55de99a16e2b4b3259cfc9a21667ece08821bbaf4507f805e5466ae339b538ff`。
试探数据 SHA-256：`60dafe7f77bdf6dec4da8c3f525c090c5a42efe8b4a4459a047768df4b405d78`。
诊断源 SHA-256：`bf057d6179372f3e08dbe6ea4ca4fb1771e68ca6e17506b4a9059d8f0af841dd`。

本节的算术模板定理已是全尺度陈述，新的完整能量对偶数值与真模型 Fourier 比较在一个固定复圆盘兑现。下一承重问题是保持同一 prolate 归一化，在明确无界尺度序列上同时控制真实候选能量宽度、完整正交补和对偶系数，使 |c_a|^2 (U_a-ell_a) sup_K C_(a,z)(v_(a,z)) 趋零。扩大已认证圆盘、优化多个共享试探或证明参数化模板条件是可检验的中间步骤；本节未证明这条尺度极限、Xi 零点结论或 RH，也未声称新的数学优先权。

参考：

- Connes, Consani, Moscovici, arXiv:2511.22755v1. https://arxiv.org/html/2511.22755v1
- Connes, arXiv:2602.04022v1. https://arxiv.org/html/2602.04022v1
- Cancès et al., *Guaranteed a posteriori bounds for eigenvalues and eigenvectors: multiplicities and clusters*, arXiv:2008.04140. https://arxiv.org/abs/2008.04140
- PR #5882 actual `CoerciveDualCertificate.lean` at `65339a3acbe99e661c6955dbb21728c4c62dfe76`; #6029 actual `WeilOrthogonalTrialPrecision.lean` at `a00b579d8202bc839cb780ee1159b2a49b0592e4`; loning #5326 actual theory at `3beb435bf9ca8aa35aa6079ea4033a9c2e6c9007`.
