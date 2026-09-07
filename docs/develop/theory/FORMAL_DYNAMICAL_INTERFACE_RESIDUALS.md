
参考：CCM `https://arxiv.org/html/2511.22755v1`，§§2.1、2.2、4.3、8；Suzuki `https://arxiv.org/abs/2606.09096`；Mathlib 钉版 `Analysis/Convolution.lean`、`MeasureTheory/Group/Integral.lean`、`Analysis/SpecialFunctions/Integrals/Basic.lean`；NIST DLMF `https://dlmf.nist.gov/5.7.E6` 仅用于数值参考。

---

# 2026-09-07 增补：对角研究的类型区分与实际 Gamma 对角正则化

本节继续 PR 6029，回应仓内多条“对角线”路线与当前 Fourier 自相关的关系。新增 `WeilDiagonalGammaRegularization.lean` 及同名 Scribe，直接消费上一节的实际 `windowCorrelation`。本节补齐每个对角核在有限窗口原点附近的可积性，并将相对零模态的 Gamma 对角增量写成正能量，给出显式上界和端点条带预算。规范算子域、完整 Gamma 频域识别与实际全尺度模态比较仍分别保留。

## A. 已有对角研究的实际类型

本轮实际读取的源包括 `D5/S0/Diagonal/EscapeCount`、`Quantum/Tomography/ObserverDiagonalSeparation`、`Observer/Completion/ClosureNonimplicationTriple`、`Observer/Conditioning/UnreadStateOrthogonalProjection`、`Weil/Pick/DiagonalSignNegativeIndex`、`Weil/Budget/MultiscaleLoewnerConstraint` 与 `Weil/TestFunctions/ConvolutionSquarePositivity`。

| 原有研究 | 当前可用的关系 | 需要保留的区别 |
|---|---|---|
| 自指对角逃逸 | g(a,a) 与二元对象沿同一输入取值具有共同的对角限制形式 | 逃逸证明还需要固定点自由 twist 和列表覆盖条件；卷积自配对没有这些假设 |
| 量子读出与对角投影 | 固定基中的对角是部分读出，交叉项承载其他区别 | `ObserverDiagonalSeparation` 已明确把完备读出与独立自指逃逸分开，不能从自指定理推出谱误差 |
| Hermitian 对角惯性 | 完成矩阵后，可逆合同和真实对角符号计数可用于有限惯性认证 | Fourier 矩阵的原始对角元素一般不是特征值，正对角不保证矩阵半正定 |
| Loewner 差商 | 连续参数核的对角可由正确导数补齐 | 当前简化差商只对整数 Fourier 格点成立，不能先把格点公式任意连续化再求对角极限 |
| 卷积平方与谱正性 | 同一函数两次输入产生自相关，其 Fourier 变换是模平方 | 既有命名定理针对 `WeilTestFunction`；窗口函数在端点跳跃，不能不检验函数类就直接代入 |

最直接的数学联系是自相关与二次型。固定基的 Q(e_n) 只给出矩阵对角；知道全部向量的 Q(f) 时，标准复极化才可恢复混合项。只有某一组基向量的自配对数据，仍不足以恢复任意叠加态的能量。有限例 [[1,2],[2,1]] 的对角均为正，特征值却为 3 与 −1。

另一个直接联系来自读出核。对互异对角值的 D=diag(d_i)，[D,T]_{ij}=(d_i−d_j)T_{ij}。因此线性映射 T↦[D,T] 的核恰为全部对角矩阵，且 [D,T+diag(r)]=[D,T]。CCM §5 的低秩交换子结构可控制非对角耦合，却不提供任意缺失的对角能量。这个核计算是本文纸面代数推论，未作为新的独立 Lean 声明包装。

## B. 为什么当前对角不能照搬 Loewner 导数

已有 `MultiscaleLoewnerConstraint` 对连续的共同 resolvent 曲线构造真实导数，并证明其 Gram 核半正定。当前窗口卷积的非对角简式为
\[
q_{n,m}(t)=\frac{\sin(2\pi nt/L)-\sin(2\pi mt/L)}{\pi(m-n)},\qquad n\ne m\in\mathbb Z.
\]
若将这个已经使用整数端点周期性的简式任意延拓到实数 m，再令 m→n，会得到 −2(t/L)cos(2πnt/L)。真正的对角由原卷积积分计算，等于 2(1−t/L)cos(2πnt/L)。两者差为 2cos(2πnt/L)。在 t=0，错误延拓给零，真实偶自相关给二。正确方法是从原始卷积的连续参数版本保留完整端点项，或直接使用已有的独立对角分支。

这也说明“格点上已证明的两种表达相等”不授权随意选择格点之外的延拓。导数信息不能由离散样本的代数简式单独决定。

## C. 先在每个对角内完成原点减法

记实际对角偶自相关 q_n(t)=C_{n,n}(t)+C_{n,n}(−t)，则 q_n(0)=2，且 0≤t≤L 时 q_n(t)=2(1−t/L)cos(ω_nt)，ω_n=2πn/L。新定义只给原分布公式的被积项命名：
\[
R_{L,n}(t)=\frac{e^{t/2}\operatorname{Re}q_n(t)-\operatorname{Re}q_n(0)}{e^t-e^{-t}}.
\]
这是已有实际卷积的表达式。不能把分子拆成两个发散积分。`diagonal_gamma_origin_subtraction` 由原卷积定理验证原点值与完整简式；`diagonal_gamma_integrable` 证明 R 在整个 (0,L] 上可积。

证明的统一包络是
\[
\boxed{|R_{L,n}(t)|\le C_{L,n}:=e^{L/2}\left(1+\frac2L+\omega_n^2L\right),\qquad 0<t\le L.}
\]
使用 t≤e^t−e^{-t}、|e^{t/2}−1|≤(t/2)e^{L/2} 和 0≤1−cos(ωt)≤ω²t²/2，先控制零模态，再控制相对频率项。这个证明没有给最终被积函数的可积性设置输入前提，也没有删除零附近区间。

纸面 Taylor 展开进一步给出 R_{L,n}(t)→1/2−1/L，当 t↓0，极限与 n 无关。源码未把这个极限额外声明为 Lean 定理；全定义除法在单点 t=0 的值也没有被当作此极限。

## D. 以零模态校准，奇异对角差变成非负能量

两个完整正则化积分均已证明可积，才可以相减。新 `diagonal_gamma_relative_energy` 给出
\[
\boxed{E_L(n):=\int_0^L R_{L,0}(t)dt-\int_0^L R_{L,n}(t)dt
=2\int_0^L\rho(t)(1-t/L)(1-\cos(\omega_nt))dt\ge0,}
\]
其中 ρ(t)=e^{t/2}/(e^t−e^{-t})。同一证明提供
\[
\boxed{E_L(n)\le e^{L/2}\omega_n^2\frac{L^2}{6}.}
\]
先建立逐点界 2ρ(t)(1−t/L)(1−cos(ω_nt))≤e^{L/2}ω_n²t(1−t/L)，再精确积分 t(1−t/L)。正则化常数与窗口外的公共减项在两个对角之间相消，所以按 CCM 的符号约定 E_L(n) 正是 −W_R(n,n)+W_R(0,0) 的增量。此比较只涉及 Archimedean 部分相对零模态，不能推出完整 Weil 矩阵半正定、任意两非零频率单调或最低谱隙。

这个表示与“先做差以消除不可积公共基线，再读取非负能量”的既有思想一致。相同核还具有余弦负定型的结构，但本节没有据此另开概率半群或新 Herglotz 路线。

## E. 有限求值的原点条带预算

`diagonal_gamma_endpoint_error` 对每个 0≤δ≤L 证明
\[
\boxed{\left|\int_0^\delta R_{L,n}(t)dt\right|\le\delta C_{L,n}.}
\]
因此内区数值积分只计算 [δ,L] 时，必须把该条带预算加入完整误差；不能把小区间当作不存在。相对增量的更小条带误差可由前述逐点界在纸面得到 O(δ²)，本轮公开 Lean 终点只交付上述原对角条带预算及完整增量界。这里 L、n 与 δ 都在估计中保留，固定窗口的精度控制仍不等于物理尺度增长时的模态逼近率。

对实际最低模态比较，这一结果提供完整内区对角矩阵认证所需的原点可积性与可用预算。非对角列由上节负责；规范 Friedrichs 作用、频域 Gamma 与此分布表达的完整识别、全空间补空间强制性与同一 prolate 家族的有效尺度率仍需继续结算。

## F. 检查、归属与文献范围

本轮从 `ea72718420e85fe3772c23ed006543e919bb86c1` 继续。实际原对象来自 `WeilWindowFourierConvolution`；指数、三角不等式与积分使用钉版 Mathlib `db584cd6d46c92f209a44c0f1c829460d327499d`。自指、惯性、Loewner 和量子读出源码用于关系审查，没有被伪装成本节的解析依赖。特别地，源码只直接导入实际卷积所有者和 Mathlib 三角界模块。

本地 Sympy 检查了原点极限、三角权重积分、错误连续化与真对角的差三个恒等式。55 位 mpmath 诊断在 c=2,3,5,11 和 n=0,±1,±3,±8 上完成 28 组实际正则化核积分及相对能量等式、56 个端点条带界、140 组逐点包络检查，最大等式偏差约 8.16×10⁻⁵⁶。c=3,n=1 的相对 Gamma 增量数值约 1.69282955439；这是两个算术对角贡献的差，绝不是实际最低模态与 prolate 的距离。两个精确有限矩阵例分别排除“正对角推出半正定”及“交换子决定全部矩阵”。这些检查没有进行有向区间认证，也没有重跑 #5602 的谱验证器。

一个公开定义与四个公开定理配套 FromLean Scribe。运行环境无 Lean/lake；数学推导、依赖类型及有限诊断已经审查，Lean elaboration、内核公理闭包与 Scribe 发射未执行，没有独立证明审稿人。新的源码是候选证明，原依赖仍保留自己的验证状态。本轮没有宣称经典正则化恒等式的新颖性、实际模态误差改善或 RH 结论。

参考：CCM，Zeta Spectral Triples，`https://arxiv.org/html/2511.22755v1`，§§2.2、4.3（4.4 与 4.7）、5、8；Suzuki，`https://arxiv.org/abs/2606.09096`。本轮可读取的主记录及 CCM 正文为上述版本，Suzuki v2 的 HTML 获取失败，未据此断言其改动或不存在新版。
