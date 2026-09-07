
参考：Connes–Consani–Moscovici, `https://arxiv.org/html/2511.22755v1`, §§2.2、4.3、8；Suzuki, `https://arxiv.org/abs/2606.09096`；NIST DLMF, `https://dlmf.nist.gov/5.7.E6`，后者仅用于独立数值参考。

---

# 2026-09-07 增补：零延拓 Fourier 函数的实际卷积与算术列识别

本节继续 PR 6029，新增 `WeilWindowFourierConvolution.lean` 及同名 Scribe。上一节已经把原算术边界符号识别为奇异核积分。本节从实际零延拓函数出发，计算原 `Zeta23.EF.weilTest` 的卷积，并把所得测试函数送入已有 `couplingColumn`。它补齐 CCM §2.2 到 §4 非对角矩阵计算之间的函数识别；规范算子域与完整对角 Gamma 正则化仍分别保留。

## A. 从函数与支撑出发

对 L>0、n∈Z，定义 U_n(x)=exp(2πinx/L)/sqrt(L) 于 (0,L]，在其余实数点为零。半开区间只选择了一个具体代表，与论文 [0,L] 代表的卷积积分相同。单个端点的全定义值不等于 Sobolev 边界迹，不能把 U_n(0)=0 解释为零边界条件。

`windowCorrelation L n m` 直接使用已有 `Zeta23.EF.weilTest U_m U_n`，其实际积分为
\[
C_{n,m}(y)=\int_{\mathbb R}\overline{U_n(x-y)}U_m(x)\,dx.
\]
这里的指标顺序对应 U_n* 与 U_m 的卷积。没有将所需差商公式放进新定义。两因子同时非零的区域恰为
\[
(0,L]\cap(y,L+y]=(\max(0,y),\min(L,L+y)].
\]
源码逐点证明乘积等于这个区间的指示函数乘连续指数表达式，因而推出每个实位移下原积分的可积性。负位移、空交集和端点均在同一个支撑计算中处理。

## B. 移动交叠区间与两种频率分支

当 0≤y≤L，记 e_n(x)=exp(2πinx/L)。共轭与归一化给出
\[
\boxed{C_{n,m}(y)=\frac{e_n(y)}{L}\int_y^L e_{m-n}(x)\,dx.}
\]
分母 L 来自两个 sqrt(L) 的乘积，未预设单位候选或额外归一化因子。对 m≠n，直接应用 Mathlib 原有的复指数积分定理，并使用 e_{m-n}(L)=1，得到
\[
C_{n,m}(y)=\frac{e_n(y)-e_m(y)}{2\pi i(m-n)}.
\]
对于 m=n，原积分是常数积分，另行得到 C_{n,n}(y)=(1−y/L)e_n(y)。这里不能用全定义除法把对角表达式写成零。

Haar 平移与原积分的共轭给出 C_{n,m}(−y)=conj(C_{m,n}(y))。合并后，`window_even_correlation_formula` 证明
\[
\boxed{C_{n,m}(y)+C_{n,m}(-y)=
\begin{cases}
2(1-y/L)\cos(2\pi ny/L),&n=m,\\
[\sin(2\pi ny/L)-\sin(2\pi my/L)]/[\pi(m-n)],&n\ne m.
\end{cases}}
\]
这是关于原复卷积的等式，右侧嵌入复数。因此其偶部为实值也由公式推出，后续取实部不会默默删掉虚部。y=0 时对角偶部为 2、非对角为零；y=L 时两支都为零。零频率和正负整数频率均保留。脱离整数 Fourier 格点后，指数积分的上端点一般不等于一，不能沿用这一简化。

## C. 支撑外部与物理窗口平移

`window_correlation_outside` 从原支撑推出 |y|>L 时 C_{n,m}(y)=0。结论没有靠把闭式公式截断成零来定义。`window_correlation_translate` 对任意共同平移 a 证明
\[
\operatorname{weilTest}(U_m(\cdot+a),U_n(\cdot+a))
=\operatorname{weilTest}(U_m,U_n).
\]
取 a=L/2 就把函数放在居中的物理窗口。指数中 x+L/2 的相位保持原样，这与只移动支撑而丢掉相位不同。本定理没有重新证明整套 Fourier 基的完备性；它直接连接这些具体函数的卷积。

## D. 原算术列现在使用实际卷积测试

令 L=log c、K(t)=2cosh(t/2)−exp(t/2)/(exp(t)−exp(−t))，并记 q_{n,m}(t)=C_{n,m}(t)+C_{n,m}(−t)。对 m∉S，新的最终消费者给出
\[
\boxed{A_v(m)=\sum_{n\in S}v_n\left[
\int_0^L K(t)\operatorname{Re}q_{n,m}(t)\,dt
-\sum_{j<c}\frac{\Lambda(j)}{\sqrt j}\operatorname{Re}q_{n,m}(\log j)
\right].}
\]
A_v 正是既有 `couplingColumn`。证明直接消费上一节 `coupling_column_kernel_integral`，在完整积分区间和每个有限素数项处代入 B 节的实际卷积公式。log(j) 属于所需窗口的事实也被核对，j=0 的全定义 log 值单独处理。复试探系数 v_n 保留在最后的复线性合成中。

因此，先前关于同一 s_c 和 A_v 的精度包围、零迹偶修正及完整外部尾界，现在有了到实际窗口卷积测试的连接。没有新增“该卷积等于差商”的输入假设，也没有把另一套矩阵定义冒充原算术列。

本节虽已计算对角卷积，最终算术消费者仍只处理外部行。对角 q_{n,n}(0)=2，Gamma 分布的原点减项不能省略；完整对角矩阵元需要将这个三角窗表达式带入正确的正则化公式并证明可积性。规范 Friedrichs 算子域、有限试探合成的实际作用及全尺度强制性也未由本节代替。没有新增实际最低模态距离或 prolate 误差改善数字。

## E. 已有库、当前研究与验证

本轮核对 #6029 的起点 `5c2898869032745b06ac30af97181b67243d5e44` 与 #5602 的实际 HEAD `f577bfdff03d4e9e4aa5882272731932481e3c51`。仓内检索覆盖 Fourier/convolution、zeroExtended、windowMode 等名称，并回读既有 `WeilEvenFourierObservationTail` 的对象说明。搜索未命中不作为全库不存在等价定理的证明。原卷积、共轭积分、Haar 平移、复指数积分与平方根恒等式都使用既有接口，Mathlib 钉版为 `db584cd6d46c92f209a44c0f1c829460d327499d`。

跨作者检索包括 #6153、#5981 与 #5256。本轮实际读取 #6153 `RectangularHalfConvolution.lean` 前 74 行，HEAD `ffbe77eb7bd5470ff4e756baf4c4b0d21efe30a5`、blob `eecefa6af2773a8d65ab37daa42f66201cc38d5e`。其中先证明原多项式操作的系数恒等式再作性质转移，提供了有用的对象审查对照；它的多项式卷积与显式 BB 条件不属于本节的实线卷积定理，未被导入或误认为解析结论。#5981 的 Fourier 反演与正则性也未重复建设。

直接文献对应是 CCM《Zeta Spectral Triples》§2.1 的卷积与共同平移、§2.2 Lemma 2.3 的两分支公式，以及 §4.3 的算术核。§8 的实际最低模态与 prolate 比较仍是研究目标。Suzuki 的主记录在本轮返回 v1；其算子域区别继续提醒，有限 Fourier 函数的可积性与规范算子域是不同条件。本轮未基于未读取版本宣称最新定理的变动。

本地 45 位非定向诊断完成 84 项原零延拓函数的卷积积分、84 项共轭反射、84 项偶部两分支公式、24 项共同平移、24 项支撑外部检查与 12 项归一化检查。直接积分按原函数支撑确定交叠区域；其与闭式公式的最大差约 4.114×10⁻⁴⁶，偶部最大差约 7.445×10⁻⁴⁶。另在 c=2,3,5 和四组正负频率对上比较实际核卷积积分与原算术符号差商，共 12 项，最大差约 4.380×10⁻⁴⁷。独立参考使用 digamma 表达式及 160 项指数修正，未使用 ζ 零点数据，也没有认证浮点或特殊函数求值的区间包围。

八个指定错误变体分别反转差商、将对角置零、重复计算中心、删除三角因子、省去共轭、省去 L 归一化、提前截断支撑及错误删除非格点端点项，均未通过对应诊断。较大的初始诊断运行达到执行时限，未记作成功；缩小测试矩阵后的完整运行才产生上述报告。这些检查由同一实现者完成，不是独立作者审稿、Lean 检查或新谱证书。

九个公开声明配套同名 Scribe。源码经过数学与所用接口审查，运行环境没有 Lean/lake，未执行 elaboration、公理闭包或 Scribe 发射。此次交付的增量是实际卷积到原非对角算术列的连接；不主张经典积分公式的新颖性、全尺度最低模态逼近或 Xi 极限。

参考：CCM `https://arxiv.org/html/2511.22755v1`，§§2.1、2.2、4.3、8；Suzuki `https://arxiv.org/abs/2606.09096`；Mathlib 钉版 `Analysis/Convolution.lean`、`MeasureTheory/Group/Integral.lean`、`Analysis/SpecialFunctions/Integrals/Basic.lean`；NIST DLMF `https://dlmf.nist.gov/5.7.E6` 仅用于数值参考。
