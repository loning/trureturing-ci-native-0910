# RH research-lane theory notes (consolidated)

One volume accumulating the theory notes stripped from the research-lane
formalization PRs; each section names its source branch and the Lean
modules that carry its formal content. Reference input only: the Lean
modules are the sole truth source, and section numbering here is
narrative, not load-bearing.



---

## [PR #4158] GOLDEN_HOLONOMY_WEIL_BRIDGE

# 黄金 Holonomy 与 Weil 奇校正桥
## 素数顺序曲率、观察起源规范与离线零点奇偶能量

**文档地位。** 本文说明同一增量中的两个 Lean 真源，并登记后续开放桥。数学结论以对应 GID 和 Lean 声明为准。

本轮不证明 RH，也不声称全部 ζ 因子抽取已经构造完成。机器层完成两件事：

\[
\boxed{
\text{prime-side 顺序缺陷的规范不变量和零曲率判据}
}
\]

以及

\[
\boxed{
\text{zero-side 离线轨道的偶能量减奇能量分解}.
}
\]

---

# 1. Prime-side 真源

Lean GID：

`D5/S3/Observer/AgencyHolonomy/PrimeSwapCurvature`

主声明：

`D5.S3.Observer.AgencyHolonomy.PrimeSwapCurvature.prime_swap_curvature_spec`

将 Fibonacci 记忆投影到稳定通道。记稳定乘子、局部标量因子和局部记忆注入为

\[
a=-\varphi^{-1},
\qquad
\lambda_p=L_p^{\langle r\rangle}(s),
\qquad
b_p=b_{r,p}^{-}(s).
\]

抽象局部更新为

\[
U_p(x,z)=(ax+b_pz,\lambda_pz).
\]

两个更新顺序的标量坐标相同。记忆坐标之差为

\[
\boxed{
C_{p,q}z,
}
\]

其中

\[
\boxed{
C_{p,q}
=(a-\lambda_q)b_p-(a-\lambda_p)b_q.
}
\]

Lean 证明

\[
C_{q,p}=-C_{p,q}.
\]

改变共同记忆原点 \(c\) 时，局部注入按

\[
b_p\mapsto b_p+(a-\lambda_p)c
\]

变化，而 \(C_{p,q}\) 保持不变。因此单个 \(b_p\) 依赖观察坐标，交换曲率是规范不变量。

在非共振条件

\[
a-\lambda_p\ne0,
\qquad
a-\lambda_q\ne0
\]

下，定义局部观察起源估计

\[
c_p=\frac{b_p}{a-\lambda_p}.
\]

Lean 证明精确因子分解

\[
\boxed{
C_{p,q}
=(a-\lambda_p)(a-\lambda_q)(c_p-c_q),
}
\]

以及

\[
\boxed{
C_{p,q}=0
\iff
c_p=c_q.
}
\]

所以共同 archive 可以保留。若全部局部注入来自同一个 coboundary 原点

\[
b_p=(a-\lambda_p)c,
\]

则顺序 holonomy 已经消失。

---

# 2. Zero-side 真源

Lean GID：

`D5/S3/Weil/HolonomyBridge/OffLineOrbitParityDecomposition`

主声明：

`D5.S3.Weil.HolonomyBridge.OffLineOrbitParityDecomposition.off_line_orbit_parity_decomposition`

对 `ZeroData` 中一个非实、离线的零点索引 \(n\)，令

\[
z=\gamma_n,
\qquad
A=\widehat g(z),
\qquad
B=\widehat g(\overline z).
\]

定义偶、奇谱通道

\[
A_{\mathrm{even}}=\frac{A+B}{2},
\qquad
A_{\mathrm{odd}}=\frac{A-B}{2}.
\]

仓库已有复频率卷积平方因子分解和离线四点轨道实值公式。本轮 Lean 节点证明

\[
\operatorname{Re}(A\overline B)
=
|A_{\mathrm{even}}|^2-|A_{\mathrm{odd}}|^2.
\]

由此得到

\[
\boxed{
Q_{\operatorname{orb}(\rho)}(g)
=E_{\rho}^{\mathrm{even}}(g)
-E_{\rho}^{\mathrm{odd}}(g),
}
\]

其中

\[
E_{\rho}^{\mathrm{even}}(g)
=4m_\rho|A_{\mathrm{even}}|^2\ge0,
\]

\[
E_{\rho}^{\mathrm{odd}}(g)
=4m_\rho|A_{\mathrm{odd}}|^2\ge0.
\]

因此

\[
\boxed{
Q_{\operatorname{orb}(\rho)}(g)
+E_{\rho}^{\mathrm{odd}}(g)
=E_{\rho}^{\mathrm{even}}(g)
\ge0.
}
\]

离线轨道的符号风险被精确隔离在奇谱通道。该正校正由反对称复频率评价独立构造，没有通过目标正性倒推定义。

---

# 3. 两端的共同二阶对象

Prime side 的奇量是

\[
C_{p,q}
=(a-\lambda_p)(a-\lambda_q)(c_p-c_q).
\]

Zero side 的奇量是

\[
A_{\mathrm{odd}}
=
\frac{\widehat g(z)-\widehat g(\overline z)}{2}.
\]

二者在交换相应端点时变号。标量完成不能以一阶不变量读取该符号。第一个规范非负对象是 Hermitian 平方。

固定空间窗口 \(L\) 和有限测试深度 \(N\)，后续应构造有限正算子

\[
\boxed{
\mathcal V_{r,L,N}^{\mathrm{hol}}
=
\frac{1}{2W_{r,L}}
\sum_{p,q}
C_{r;p,q}^{*}\Gamma_\varphi C_{r;p,q}
}
\]

和有限离线奇算子

\[
\boxed{
\mathcal O_{L,N,T}^{\mathrm{off}}
=
\sum_{\rho\ \mathrm{off-line},\,|\gamma_\rho|\le T}
4m_\rho
|A_{\mathrm{odd},\rho}\rangle
\langle A_{\mathrm{odd},\rho}|.
}
\]

黄金稳定通道的自然 Lyapunov 权为

\[
\Gamma_\varphi
=
\sum_{j\ge0}\varphi^{-2j}
=
\varphi.
\]

这些有限算子尚未在本轮定义。上式登记其预期结构和归一化来源。

---

# 4. 中心开放桥

## 4.1 抽取平坦化

需要证明，对每个固定 \(L,N\)，

\[
\boxed{
\|\mathcal V_{r,L,N}^{\mathrm{hol}}\|_{\mathrm{op}}
\longrightarrow0
\quad(r\to\infty).
}
\]

观察起源因子分解显示，局部注入趋零本身不足以承担该结论。还需要控制共振条件数

\[
\chi_{r,L}
=
\max_{p\in\mathcal P_L}|a-\lambda_{r,p}|^{-1}.
\]

一个可操作的充分条件是

\[
\boxed{
\chi_{r,L}
\max_{p,q\in\mathcal P_L}|C_{r;p,q}|
\longrightarrow0.
}
\]

## 4.2 谱忠实支配

寻找有限常数和误差预算，使

\[
\boxed{
P_{L,N}\mathcal O_{L,T}^{\mathrm{off}}P_{L,N}
\preceq
C_{L,N,T}\mathcal V_{r,L,N}^{\mathrm{hol}}
+
\varepsilon_{r,L,N,T}I.
}
\]

要求在固定 \(L,N,T\) 下

\[
\varepsilon_{r,L,N,T}\to0.
\]

随后依次完成

\[
r\to\infty,
\qquad
T\to\infty,
\qquad
N\to\infty,
\qquad
L\to\infty.
\]

若支配和抽取平坦化均成立，则离线奇能量必须消失。若有限测试塔能够分离每个离线轨道，内部曲率随之为零。仓库已有 `InteriorCurvatureCriterion` 可将内部曲率消失运输到 RH。

---

# 5. 后续形式化顺序

1. `GoldenPrimeMemoryInstantiation`：把 \(a=-\varphi^{-1}\)、\(b_{r,p}^{-}\) 与 \(L_p^{\langle r\rangle}\) 接入当前抽象曲率；
2. `FiniteHolonomyEnergy`：在固定活动素数幂窗口上构造有限 holonomy Gram 算子；
3. `ExtractionCurvatureBound`：把 residual local-factor 上界运输到交换曲率；
4. `ResonanceConditionedFlattening`：加入统一非共振控制；
5. `FiniteOffLineOddEnergy`：对有限对称零点截断求和逐轨道奇校正；
6. `PrimeArchimedeanHolonomyDomination`：建立有限 Galerkin 支配；
7. `HolonomySqueezeToInteriorCurvature`：组合全部极限和误差预算。

第 6 项是当前新的 hard heart。前五项都应附带有限失败证书。

---

# 6. 严格边界

本轮不主张：

- 已经构造全部局部因子抽取塔；
- 交换曲率随抽取深度趋零；
- prime holonomy 已经支配离线奇能量；
- 当前偶测试类已经对全部离线轨道完备；
- canonical `ZeroData` inhabitant 已经构造；
- RH 已经证明。

本轮之后可以无条件使用两条机器事实：

\[
\boxed{
\text{共同 archive 是 coboundary；顺序曲率只检测观察起源不一致。}
}
\]

\[
\boxed{
\text{一个离线四点轨道的全部符号风险集中在非负奇谱能量。}
}
\]

因此未来桥需要比较的对象已经固定为

\[
\boxed{
\text{prime-side 规范约化交换曲率平方}
\quad\longleftrightarrow\quad
\text{zero-side 离线奇谱能量}.
}

---

## [PR #4192] STABLE_RESIDUAL_SWAP_CURVATURE_BOUND

# 稳定通道 residual 交换曲率界
## 从局部因子余项到 holonomy 小量的第一条定量桥

**文档地位。** 本文解释 Lean 节点

`D5/S3/Observer/AgencyHolonomy/StableResidualSwapCurvatureBound`

及其主声明

`D5.S3.Observer.AgencyHolonomy.StableResidualSwapCurvatureBound.stable_residual_swap_curvature_bound`。

机器结论以 Lean 声明为准。本文区分已经证明的有限代数事实、可以由该事实直接推出的纸面推论，以及仍需独立形式化的全局桥。

---

# 1. 来源问题

黄金记忆路线将一个 residual local factor 写成

\[
L_p^{\langle r\rangle}=1+a_{r,p},
\]

并将稳定记忆通道中的局部注入写成

\[
b_{r,p}=a_{r,p}v_p.
\]

此前的稳定通道相邻交换曲率具有形式

\[
C_{p,q}
=(s-\lambda_q)b_p-(s-\lambda_p)b_q,
\]

其中 \(s\) 是固定的稳定记忆乘子。代入

\[
\lambda_p=1+a_p,
\qquad
b_p=a_pv_p
\]

以后，问题变成：局部 residual \(a_p,a_q\) 小，是否足以强制交换曲率小。

本轮只处理一个稳定特征通道。矩阵或一般 Banach 空间上的完整算子提升仍是后续节点。

---

# 2. 机器定义

Lean 在任意 normed field \(K\) 上定义

\[
\boxed{
C^{\mathrm{st}}(s,a_p,a_q,v_p,v_q)
=
\bigl(s-(1+a_q)\bigr)a_pv_p
-
\bigl(s-(1+a_p)\bigr)a_qv_q.
}
\]

这个定义不包含极限、素数求和、零点数据或 RH 前提。它是两个 residual 局部更新在一维稳定记忆通道上的有限相邻交换缺陷。

---

# 3. 精确线性加二次分解

Lean 证明

\[
\boxed{
\begin{aligned}
C^{\mathrm{st}}
={}&
(s-1)(a_pv_p-a_qv_q)
\\
&+a_pa_q(v_q-v_p).
\end{aligned}
}
\]

第一项是一阶 residual 失配。第二项是两个 residual 同时存在时产生的双线性修正。

该恒等式说明曲率的首阶尺度由 \(s-1\) 控制。局部因子完成到 \(1\) 时，稳定记忆乘子与标量完成点之间的间隙决定 residual 被放大的常数。

---

# 4. 一般范数界

在

\[
\|v_p\|\le1,
\qquad
\|v_q\|\le1
\]

下，Lean 证明

\[
\boxed{
\begin{aligned}
\|C^{\mathrm{st}}\|
\le{}&
\|s-1\|
\bigl(\|a_p\|+\|a_q\|\bigr)
\\
&+2\|a_p\|\|a_q\|.
\end{aligned}
}
\]

证明只使用三角不等式、乘法范数和

\[
\|v_q-v_p\|\le\|v_q\|+\|v_p\|\le2.
\]

因此该界不依赖任何零点位置，也不依赖观察起源坐标中的除法。

---

# 5. 统一 residual envelope

若存在 \(\varepsilon\ge0\) 使

\[
\|a_p\|\le\varepsilon,
\qquad
\|a_q\|\le\varepsilon,
\]

Lean 进一步证明

\[
\boxed{
\|C^{\mathrm{st}}\|
\le
2\|s-1\|\varepsilon+2\varepsilon^2.
}
\]

这是后续完成深度论证应使用的统一货币。它把所有局部分析压缩成一个 residual envelope：

\[
\varepsilon_{r,L}
=
\max_{p\in\mathcal P_L}|a_{r,p}|.
\]

对固定有限活动窗口 \(\mathcal P_L\)，只要未来证明

\[
\varepsilon_{r,L}\longrightarrow0,
\]

纸面上立即得到

\[
\max_{p,q\in\mathcal P_L}
\|C^{\mathrm{st}}_{r;p,q}\|
\longrightarrow0.
\]

最后这一极限运输尚未包含在本轮 Lean 声明中。它应作为独立节点接收一个已形式化的 residual-envelope 收敛前提。

---

# 6. 对共振问题的修正

观察起源坐标写成

\[
c_p=\frac{b_p}{s-\lambda_p}.
\]

该坐标在 \(s=\lambda_p\) 附近带有条件数

\[
|s-\lambda_p|^{-1}.
\]

本轮机器界直接控制原始规范不变量 \(C_{p,q}\)，没有引入该分母。因此需要区分两个目标：

1. 若目标是证明局部观察起源 \(c_p\) 本身收敛，则必须控制共振分母。
2. 若目标是证明规范交换曲率趋零，则 residual envelope 界已经给出一条不经过观察起源除法的路径。

所以此前登记的 resonance-conditioned flattening 不是原始曲率消失的必要中间步骤。它只在需要恢复或比较观察起源坐标时承担作用。

对黄金稳定通道

\[
s=-\varphi^{-1},
\]

完成点是 \(1\)。纸面恒等式

\[
1+\varphi^{-1}=\varphi
\]

给出

\[
|s-1|=\varphi.
\]

于是预期的黄金特化界为

\[
\boxed{
\|C^{\mathrm{st}}_{r;p,q}\|
\le
2\varphi\varepsilon_{r,L}
+2\varepsilon_{r,L}^2.
}
\]

该黄金常数特化尚未在本轮 Lean 节点中连接。它可以由仓库已有的 golden-ratio 恒等式形成一个很薄的后续实例节点。

---

# 7. 当前允许的真源推理

本轮以后可以无条件使用：

\[
\boxed{
\text{稳定通道交换曲率对 residual 是一阶加二阶小量。}
}
\]

更精确地说，局部 residual 同时趋零时，不需要先证明观察起源收敛，也不需要排除观察起源坐标中的表观共振，原始交换曲率已经被统一压到零。

这改变了 prime-side 路线的任务排序。当前最短链条是

\[
\boxed{
\text{residual envelope decay}
\Longrightarrow
\text{pairwise curvature decay}
\Longrightarrow
\text{finite holonomy energy decay}.
}
\]

第三箭头仍需把逐对界聚合为有限正 Gram 能量界。

---

# 8. 下一真源

自然的下一节点应为 `FiniteStableHolonomyEnergyBound`。固定有限活动索引集 \(P\)，定义

\[
\mathcal V^{\mathrm{st}}_{r,P}
=
\frac{1}{2W_{r,P}}
\sum_{p,q\in P}
\|C^{\mathrm{st}}_{r;p,q}\|^2.
\]

需要机器证明：

\[
0\le\mathcal V^{\mathrm{st}}_{r,P},
\]

以及由本轮 envelope 界导出的有限聚合估计。若 \(|P|=M\)，未归一化版本应满足

\[
\sum_{p,q\in P}
\|C^{\mathrm{st}}_{r;p,q}\|^2
\le
M^2
\left(
2\|s-1\|\varepsilon+2\varepsilon^2
\right)^2.
\]

归一化版本还需要先固定 \(W_{r,P}\) 的定义和正性条件，避免把归一化选择隐藏在证明中。

完成该有限能量节点以后，prime-side 的剩余困难将集中到两处：

- 从实际 all-order local-factor extraction 得到统一 residual envelope decay；
- 将 finite holonomy energy 与 zero-side 离线奇谱能量建立忠实支配。

第二项仍是整条 RH 路线的 hard heart。

---

# 9. 严格非主张

本轮不主张：

- 已构造 all-order residual extraction；
- residual envelope 已随深度趋零；
- 已定义或控制无限素数 holonomy 能量；
- prime-side 曲率已经支配离线零点奇能量；
- 已得到任何零点位置结论；
- 已证明 RH。

本轮机器层只冻结有限、可复用且不含目标等价前提的定量桥：

\[
\boxed{
\text{residual local factors}
\longrightarrow
\text{stable adjacent-swap curvature bound}.
\]

---

## [PR #4199] FINITE_HOLONOMY_ENERGY_AND_PHASE_COHERENCE

# 有限 holonomy 能量、色散与相位相干
## 从波动直觉到 RH 路线中的可证明链条

**文档地位。** 本文解释 Lean 节点

`D5/S3/Observer/AgencyHolonomy/FiniteHolonomyEnergy`

及其主声明

`D5.S3.Observer.AgencyHolonomy.FiniteHolonomyEnergy.finite_stable_holonomy_energy_bound`。

机器事实以 Lean 声明为准。波、白光、色散、共振和圆在本文中承担结构类比。只有写成公式并接入 prime-zero 桥的部分才能成为 RH 论证。

---

# 1. 本轮冻结的有限能量

固定有限通道类型 \(P\)，对每一有序对 \((p,q)\) 给出稳定交换曲率

\[
C^{\mathrm{st}}_{p,q}.
\]

Lean 定义未归一化能量

\[
\boxed{
\mathcal E^{\mathrm{hol}}_P
=
\sum_{p\in P}\sum_{q\in P}
\left\|C^{\mathrm{st}}_{p,q}\right\|^2.
}
\]

它是一个有限正标量，具有四个机器性质。

第一，非负性：

\[
\boxed{0\le \mathcal E^{\mathrm{hol}}_P.}
\]

第二，若 \(|P|=M\)，所有 residual 满足 \(\|r_p\|\le\varepsilon\)，所有通道满足 \(\|v_p\|\le1\)，则

\[
\boxed{
\mathcal E^{\mathrm{hol}}_P
\le
M^2
\left(
2\|a-1\|\varepsilon+2\varepsilon^2
\right)^2.
}
\]

第三，能量的消失忠实记录逐对压平：

\[
\boxed{
\mathcal E^{\mathrm{hol}}_P=0
\iff
\forall p,q\in P,
\ C^{\mathrm{st}}_{p,q}=0.
}
\]

第四，\(\varepsilon=0\) 强制 \(\mathcal E^{\mathrm{hol}}_P=0\)。

这里使用有序对，所以粗略计数因子是 \(M^2\)。后续引入反对称性、去掉对角线或除以二以后，可以改成无序对计数。当前版本保留最少结构和最透明的上界。

---

# 2. 共振中存在两种不同能量

波动直觉中的“能量聚合”需要分成两个量。

## 2.1 缺陷能量

本轮 Lean 控制的是

\[
\mathcal E_{\mathrm{defect}}
=
\sum_{p,q}\|C_{p,q}\|^2.
\]

它衡量通道之间的相位、起源或更新次序失配。系统趋向共同模态时，这个量应当趋向零。

## 2.2 相干能量

若 \(z_p\in U(1)\) 是单位相位，\(w_p\ge0\) 是权重，令

\[
W=\sum_pw_p,
\qquad
A=\sum_pw_pz_p.
\]

\(|A|^2\) 衡量各相位相干叠加以后落在共同模态中的能量。完全同相时 \(|A|=W\)，相干能量达到最大。

波论中的精确守恒式是

\[
\boxed{
\sum_{p,q}w_pw_q|z_p-z_q|^2
=
2W^2-2\left|\sum_pw_pz_p\right|^2.
}
\]

左侧是色散或不同步能量，右侧是总可用能量减去共同模态能量。因此“共振聚合”可以严格翻译为：

\[
\boxed{
\text{缺陷能量下降}
\quad\Longleftrightarrow\quad
\text{共同模态相干能量上升}.
}
\]

这条相位守恒式尚未包含在本轮 Lean 文件中。它适合形成独立节点 `FinitePhaseCoherenceIdentity`，并在复相位或二维实内积空间上证明。

---

# 3. 白光与色散的数学翻译

“白光”可以理解为尚未分辨内部频率的整体标量读数。zeta 的 Euler 乘积在收敛半平面写成

\[
\zeta(s)=\prod_p(1-p^{-s})^{-1}.
\]

沿 \(s=\sigma+it\) 展开一个素数通道：

\[
\boxed{
p^{-s}=p^{-\sigma}e^{-it\log p}.}
\]

因此每个素数携带：

\[
\text{衰减幅度 }p^{-\sigma},
\qquad
\text{角频率 }\log p,
\qquad
\text{圆周相位 }e^{-it\log p}\in U(1).
\]

有限素数窗口的相位空间自然落在

\[
U(1)^P,
\]

也就是有限维环面。这里的“颜色”对应不同的 \(\log p\) 频率通道。拓扑来自圆群及其乘积空间，群结构来自相位乘法。

标量 Euler 因子彼此交换，所以只看最终乘积时，通道顺序被遗忘。记忆提升将每个局部因子放进上三角更新或半直积结构以后，通道顺序可以留下可观测痕迹。相邻交换曲率 \(C_{p,q}\) 正是这一顺序依赖的局部测量。

因此色散与破缺的对应关系可以写成：

\[
\boxed{
\text{整体读数被分解为 prime-frequency channels}
\longrightarrow
\text{通道差异显现}
\longrightarrow
\text{提升后的交换对称性可能破缺}.
}
\]

曲率为零表示局部交换闭合。曲率非零表示经过 \(p\) 再经过 \(q\) 与反向顺序留下不同记忆。

---

# 4. 观察起源、色散与共振条件

对局部标量因子 \(\lambda_p\) 和记忆注入 \(b_p\)，观察起源坐标为

\[
\boxed{
c_p=\frac{b_p}{a-\lambda_p}.}
\]

远离共振时，prime swap curvature 满足

\[
\boxed{
C_{p,q}
=(a-\lambda_p)(a-\lambda_q)(c_p-c_q).
}
\]

这条恒等式给出非常直接的色散解释：不同素数通道推断出不同观察起源时，\(c_p-c_q\) 形成起源色散；交换曲率是该色散经过两个共振间隙加权后的规范量。

若存在统一非共振下界

\[
|a-\lambda_p|\ge\eta>0,
\]

则纸面上有

\[
|c_p-c_q|^2
\le
\eta^{-4}|C_{p,q}|^2,
\]

进而

\[
\boxed{
\sum_{p,q}|c_p-c_q|^2
\le
\eta^{-4}\mathcal E^{\mathrm{hol}}_P.
}
\]

这才是严格意义上的“曲率能量压平推出观察起源共振到共同值”。本轮机器节点聚合了 \(C_{p,q}\) 的能量。上面的非共振运输应成为下一条 `ResonanceConditionedOriginDispersion` 真源。

当 \(a\) 接近某个 \(\lambda_p\) 时，权重 \((a-\lambda_p)(a-\lambda_q)\) 可以很小。原始曲率此时可能掩盖较大的起源差异。因此共振附近需要单独处理条件数、重标度或直接使用无除法的曲率变量。

---

# 5. 为什么会出现圆

圆有两条独立来源。

第一条来自相位群：

\[
e^{-it\log p}\in U(1).
\]

每个 prime-frequency channel 在单位圆上旋转。多个素数共同形成环面 \(U(1)^P\)。相干表示这些圆周相位在加权和中朝向共同方向。

第二条来自 zero-side 的 Cayley 紧化。令

\[
x=(t-\gamma)^2,
\qquad
a=\delta^2,
\qquad
u_a(x)=\frac{x-a}{x+a}.
\]

对一阶 Chebyshev slack，

\[
S_a(x)=1-u_a(x)^2
=
\frac{4ax}{(x+a)^2}.
\]

于是

\[
\boxed{u_a(x)^2+S_a(x)=1.}
\]

取非负振幅 \(\sqrt{S_a(x)}\) 后，

\[
\bigl(u_a(x),\sqrt{S_a(x)}\bigr)
\]

落在单位圆上。倒数变换 \(y=a^2/x\) 满足

\[
u_a(y)=-u_a(x),
\qquad
S_a(y)=S_a(x).
\]

它把同一强度的两个点放在圆上的相反相位。这正对应最新 RH 理论源中预登记的 `CurvatureSlackPhaseBridge`。该恒等式属于零点局部几何，尚未建立 prime holonomy energy 到 zero-side 圆能量的支配。

所以“回归圆”可以精确表述为相位归一化或 Cayley-slack 守恒。它不应被写成能量在物理空间中自动收缩成一个圆。

---

# 6. 这条路线为什么可能与 RH 有关

RH 讨论的是非平凡零点

\[
\rho=\frac12+\delta+i\gamma
\]

是否全部满足 \(\delta=0\)。函数方程将离线零点组织成反射轨道。\(\delta\ne0\) 会产生关于临界线的成对位移，并在仓库现有的 off-line curvature dipole、odd orbit decomposition 和 Chebyshev slack 中形成可检测的奇部分或离线能量。

素数侧与零点侧的关联来自 Euler product、对数导数和显式公式。波动语言中，素数提供频率 \(\log p\)，零点提供全局共振谱。要让本轮有限能量真正承担 RH 证明，需要建立如下类型的忠实支配：

\[
\boxed{
\mathcal E^{\mathrm{odd}}_{\mathrm{off}}(N,L)
\le
A_{N,L}\mathcal E^{\mathrm{hol}}_{r,L}
+
R_{r,N,L}.
}
\]

其中：

\[
\mathcal E^{\mathrm{odd}}_{\mathrm{off}}
\]

必须对每个离线零点轨道给出严格正贡献；

\[
\mathcal E^{\mathrm{hol}}_{r,L}
\]

是本轮开始构造的 prime-side 交换缺陷能量；

\[
R_{r,N,L}\to0
\]

负责有限素数窗口、有限深度和测试函数逼近误差。

若未来同时证明

\[
\varepsilon_{r,L}\to0,
\]

本轮机器上界给出

\[
\mathcal E^{\mathrm{hol}}_{r,L}\to0.
\]

再由忠实 prime-zero 支配得到

\[
\mathcal E^{\mathrm{odd}}_{\mathrm{off}}=0.
\]

若零点侧能量对所有 \(\delta\ne0\) 严格正，就能排除离线零点，从而把全部非平凡零点压到 \(\Re s=1/2\)。

因此当前严谨链条是

\[
\boxed{
\begin{aligned}
&\text{all-order residual envelope decay}
\\
&\Longrightarrow
\text{pairwise prime curvature decay}
\\
&\Longrightarrow
\text{finite holonomy defect energy decay}
\\
&\Longrightarrow
\boxed{\text{prime-zero faithful domination}}
\\
&\Longrightarrow
\text{off-line odd energy vanishes}
\\
&\Longrightarrow
\text{every nontrivial zero lies on the critical line}.
\end{aligned}
}
\]

方框中的 prime-zero faithful domination 仍是整条路线的核心缺口。圆结构、相位同步和有限能量压平为这条桥提供候选几何语言，它们单独不产生 RH 结论。

---

# 7. 对白光直觉的最终校准

可以保留下面这幅图景：

\[
\boxed{
\begin{aligned}
\text{白光}
&\sim \text{未分辨的整体 Euler 输出},
\\
\text{色散}
&\sim \text{分解为频率 }\log p\text{ 的素数通道},
\\
\text{颜色间的破缺}
&\sim \text{提升后的非交换曲率},
\\
\text{缺陷能量}
&\sim \sum_{p,q}\|C_{p,q}\|^2,
\\
\text{共振聚合}
&\sim \text{缺陷能量归零且共同模态能量最大},
\\
\text{圆}
&\sim U(1)\text{ 相位或 Cayley-slack 单位圆},
\\
\text{RH 桥}
&\sim \text{prime-side 压平忠实支配 zero-side 离线奇能量}.
\end{aligned}
}
\]

这套语言已经足够指导定义新节点。每一箭头仍需单独的类型、假设和误差账本。

---

# 8. 下一真源排序

本轮以后，最自然的相邻节点是：

1. `ResonanceConditionedOriginDispersion`。在统一间隙 \(\eta>0\) 下，把 holonomy energy 运输为观察起源的 pairwise dispersion energy。
2. `FinitePhaseCoherenceIdentity`。形式化单位相位的色散能量与共同模态能量守恒式。
3. `ResidualEnvelopeFiniteWindowConvergence`。从实际 extraction tower 得到 \(\varepsilon_{r,L}\to0\)。
4. `FiniteOffLineOddEnergy`。把每个反射零点轨道的奇部分平方聚合成忠实非负量。
5. `PrimeArchimedeanHolonomyDomination`。证明 prime-side 能量控制 zero-side 离线能量及全部截断误差。

第五条依然是 hard heart。第一和第二条可以先把“共振压平”和“波的能量聚合”完全变成机器可读的数学。

---

# 9. 严格非主张

本轮不主张：

- residual envelope 已经收敛；
- 无限素数能量已经定义；
- 共振分母已经统一受控；
- prime phases 已经同步；
- finite holonomy energy 已经支配零点能量；
- 圆恒等式已经推出临界线；
- RH 已经证明。

本轮冻结的机器真源是

\[
\boxed{
\text{pairwise stable residual curvature bounds}
\longrightarrow
\text{faithful finite nonnegative holonomy energy bound}.
\]

---

## [PR #4212] FORMAL_GOLDEN_PRIME_CIRCLE_CRITICAL_SPECTRUM

# 黄金素数圆、二元电荷层析与临界谱完成

**Formal Golden Prime Circle, Binary Charge Tomography, and Critical-Spectrum Completion**

**版本：v0.1，2026-08-30**

## 0. 文档地位

本文把黄金比例、素数分裂、观察者压缩、尺度圆与 Riemann 型临界反射组织成一条严格分层的理论链。Lean 文件是机器真源。本文负责解释对象、桥梁、适用范围和仍然开放的解析义务。

本文不宣称已经证明 RH、GRH、显式公式的新版本或 `L(1, chi_5)` 的解析特殊值。临界线到单位圆的变换是精确坐标重写。它的研究价值来自与黄金尺度、二元分裂电荷和 observer completion 的兼容性。

---

## 1. 三种压缩必须分开

### 1.1 阿贝尔化

素数是正有理数乘法群的自由生成元：

\[
\mathbb Q_{>0}^{\times}\cong\bigoplus_p\mathbb Z[p].
\]

从有序素数观察词进入该群会删除顺序，只保留素因子指数。

### 1.2 字符投影

普通 zeta 对应平凡字符通道。对黄金二次域，非平凡字符 `chi_5` 读取 split/inert 电荷。联合通道

\[
(\mathbf 1,\chi_5)
\]

是群 `C_2` 上的完整 Fourier 坐标。

### 1.3 反射偶化

completed reflection

\[
\mathcal R(s)=1-\overline{s}
\]

把法向偏差 `delta` 变为 `-delta`。对称标量观察会消去奇通道，同时保留乘积、平方和曲率等偶不变量。

---

## 2. 黄金尺度圆

定义黄金正定向周期

\[
L_\varphi=2\log\varphi.
\]

对正尺度 `x`，定义未取商坐标

\[
\eta_\varphi(x)=\frac{\log x}{L_\varphi}.
\]

机器定理证明

\[
\eta_\varphi(xy)=\eta_\varphi(x)+\eta_\varphi(y)
\]

以及

\[
\eta_\varphi(\varphi^2x)=\eta_\varphi(x)+1.
\]

因此取模 `Z` 后得到黄金尺度圆。当前 Lean owner 保留未取商实坐标，以避免把 circle quotient 的拓扑接口与本批代数定理混在一起。

其 Fourier 基频为

\[
\omega_\varphi=\frac{2\pi}{L_\varphi}=\frac{\pi}{\log\varphi}.
\]

机器闭合的精确桥为

\[
2\pi k\,\eta_\varphi(x)
=
(k\omega_\varphi)\log x.
\]

这解释了黄金圆的 Fourier 模式为什么对应 Mellin 变量的垂直平移。

---

## 3. 相同电荷与不同观察者

设壳层读出为

\[
q_r:X\to Y_r,
\]

并存在电荷投影

\[
c_r:Y_r\to C
\]

满足

\[
c_r\circ q_r=\chi.
\]

所有壳层读取同一个电荷 `chi`。它们仍可保留不同残余信息，因此 kernel 不必相同。机器反模型使用一个只读取 Boolean charge 的粗壳和一个同时保留 residual bit 的细壳，证明共同电荷不推出观察者相同。

---

## 4. 黄金 `C_2` 电荷层析

令 split 与 inert 信号为 `(S,I)`。定义

\[
N=S+I,
\qquad
C=S-I.
\]

反演为

\[
S=\frac{N+C}{2},
\qquad
I=\frac{N-C}{2}.
\]

这里 `N` 是中性通道，`C` 是二次电荷通道。该反演已经机器证明。

对单个未分歧素数，`chi_5(p)=+1` 给 split 指示器，`chi_5(p)=-1` 给 inert 指示器。`p=5` 是分歧通道，需要单独保留。

---

## 5. 黄金局部 Euler 三分律

令形式局部变量为 `X`，定义

\[
D_\chi(X)=(1-X)(1-\chi X).
\]

机器证明

\[
\begin{aligned}
D_{+1}(X)&=(1-X)^2,\\
D_{-1}(X)&=1-X^2,\\
D_0(X)&=1-X.
\end{aligned}
\]

它们分别对应 split、inert、ramified 三种黄金局部类型。仓库已有 prime classification 证明素数的黄金分裂类型由 `p mod 5` 决定。本批新增 residue-to-charge-to-Euler-denominator 的桥接 owner。

---

## 6. 黄金临界半径

对复变量 `s` 定义

\[
b(s)=\Re(s)-\frac12
\]

和黄金临界半径

\[
R_\varphi(s)=\exp(L_\varphi b(s)).
\]

机器证明

\[
R_\varphi(s)=1
\iff
\Re(s)=\frac12.
\]

临界反射满足

\[
b(\mathcal R s)=-b(s)
\]

以及

\[
R_\varphi(\mathcal R s)=R_\varphi(s)^{-1}.
\]

因此每一对反射伙伴都满足

\[
R_\varphi(s)R_\varphi(\mathcal R s)=1.
\]

这只是成对平衡。逐点中性要求

\[
R_\varphi(s)=1.
\]

所以函数方程型对称提供 pairwise balance，Riemann 型临界线命题要求 pointwise neutrality。Lean 中已经给出显式反例，说明乘积为一不能推出每个因子为一。

---

## 7. 与 RH 和 GRH 的精确边界

对任意候选零点集 `Z`，机器定理证明

\[
\forall s\in Z,\ \Re(s)=\frac12
\iff
\forall s\in Z,\ R_\varphi(s)=1.
\]

当 `Z` 被实例化为 completed zeta 或某个 completed `L`-函数的非平凡零点集时，这成为对应 RH 或 GRH 的等价坐标表达。该实例化本身需要仓库中严格定义的 completed function、zero predicate 和 trivial-zero exclusion。

本批不把坐标等价冒充为零点位置证明。

---

## 8. 后续解析桥

下列内容保留为后续形式化目标：

1. 在绝对收敛半平面中建立有限或无限黄金壳测度的 Fourier 系数与 `-L'/L` 竖直采样之间的定理；
2. 形式化 `L(1,chi_5)=2 log(phi)/sqrt(5)`，并连接黄金 Möbius Lyapunov 指数；
3. 将 explicit formula 实现为 prime-shell test space 与 zero-spectrum distribution 之间的连续线性泛函恒等式；
4. 构造足够完备的 golden Weil frame，并证明其正性是否等价于完整 Weil criterion；
5. 证明任何新增传递算子的酉性或自伴随性，不能从 determinant 的成对平衡直接推出。

---

## 9. 机器 owner

```text
D5/S3/Observer/GoldenPrimeCircle/
  GoldenScaleCircle.lean
  GoldenVerticalSampling.lean
  SharedChargeDifferentShells.lean

D5/S3/PrimeForms/GoldenEuler/
  GoldenChargeTomography.lean
  GoldenLocalEulerTrichotomy.lean
  GoldenResidueChargeBridge.lean

D5/S3/Weil/GoldenCriticalSpectrum/
  GoldenCriticalRadius.lean
  GoldenReflectionTransfer.lean
```

---

## [PR #4221] PRIME_FREQUENCY_PHASE_FLOW_AND_OBSERVER_TIME

# 素数频率相位流、傅立叶对偶与观察者时间
## 色散给出频率分解，记忆次序给出可观察的历时

**文档地位。** 本文解释 Lean 节点

`D5/S3/Observer/AgencyHolonomy/PrimeFrequencyPhaseFlow`

及其三个主定理：

- `fourier_phase_character_laws`；
- `ordered_phase_product_collapse`；
- `finite_fourier_synthesis_laws`。

机器事实以 Lean 声明为准。本文将“色散以后是不是通过傅立叶变换出现时间”拆成可证明的傅立叶角色、标量次序遗忘和记忆提升三个部分。

---

# 1. 本轮机器对象

Lean 定义傅立叶相位

\[
\boxed{
\chi_\omega(t)=e^{-it\omega}.
}
\]

这里 \(t,\omega\in\mathbb R\)，值位于复数单位圆。对自然数地址 \(n\)，进一步定义

\[
\boxed{
\chi_n^{\log}(t)
=
\chi_{\log n}(t)
=
e^{-it\log n}.
}
\]

当地址是素数 \(p\) 时，这正是

\[
p^{-\sigma-it}
=
p^{-\sigma}e^{-it\log p}
\]

中的振荡部分。

对有限通道类型 \(P\)，振幅 \(a_p\in\mathbb C\) 和频率 \(\omega_p\in\mathbb R\)，Lean 定义有限傅立叶合成

\[
\boxed{
S(t)=\sum_{p\in P}a_p e^{-it\omega_p}.
}
\]

这是一条有限谱线信号。本文未定义一般 \(L^1\) 或 \(L^2\) 傅立叶变换，也未使用傅立叶反演或 Plancherel 定理。

---

# 2. 时间作为频率的对偶参数

Lean 证明

\[
\boxed{
\chi_\omega(0)=1,
}
\]

以及

\[
\boxed{
\chi_\omega(t+u)
=
\chi_\omega(t)\chi_\omega(u).
}
\]

因此固定 \(\omega\) 后，映射

\[
t\longmapsto\chi_\omega(t)
\]

是加法群 \((\mathbb R,+)\) 到单位圆乘法群的角色。这里的 \(t\) 就是傅立叶对偶中的原变量。频率 \(\omega\) 标记该原变量上的角色。

同一个核也满足

\[
\boxed{
\chi_{\omega+\nu}(t)
=
\chi_\omega(t)\chi_\nu(t).
}
\]

所以固定 \(t\) 后，它对频率变量同样是加法角色。Lean 还证明

\[
\boxed{
\chi_\omega(t)=\chi_t(\omega),
}
\]

因为数值上只出现双线性配对 \(t\omega\)。这个对称性表示傅立叶核中的数值互易，不表示时间和频率在模型中具有相同语义。

因此最准确的回答是：

\[
\boxed{
\text{色散识别频率通道，傅立叶配对使这些通道随参数 }t\text{ 形成相位流。}
}
\]

时间不是由“把颜色排了一个顺序”自动制造出来。它来自一个已经存在的加法参数群及其傅立叶角色。如果只给出无序频率集合 \(\{\omega_p\}\)，还没有时间原点、时间方向或因果箭头。

---

# 3. 单位圆与环面

Lean 证明

\[
\boxed{
|\chi_\omega(t)|=1.
}
\]

所以单个通道沿 \(U(1)\) 运动。有限通道族

\[
\bigl(\chi_{\omega_p}(t)\bigr)_{p\in P}
\]

沿环面

\[
\boxed{U(1)^P}
\]

形成一参数轨道。

这给“白光色散为多种颜色”一个精确版本：整体信号被分解为多个频率角色，每个角色在自己的圆相位上旋转，联合状态位于相位环面。

当 \(\omega_p=\log p\) 时，轨道是

\[
\boxed{
t\longmapsto
\left(e^{-it\log p}\right)_{p\in P}.}
\]

其中 \(t\) 是 zeta 竖直方向的虚部坐标，也可以称为谱时间。它不是未经额外解释即可认定的物理时间。

---

# 4. 色散次序本身会不会产生时间

本轮最关键的边界定理考虑一个频率列表

\[
\Omega=[\omega_1,\ldots,\omega_m]
\]

和按列表书写的标量相位乘积

\[
\Pi_\Omega(t)
=
\prod_{j=1}^m e^{-it\omega_j}.
\]

Lean 证明

\[
\boxed{
\Pi_\Omega(t)
=
e^{-it\sum_j\omega_j}.
}
\]

右侧只依赖频率总和。因此在标量复数层：

\[
\boxed{
\text{先 }\omega_p\text{ 后 }\omega_q
=
\text{先 }\omega_q\text{ 后 }\omega_p.
}
\]

标量傅立叶相位能够表示时间演化，却无法记录通道经过的先后次序。换句话说：

\[
\boxed{
\text{傅立叶时间}
\neq
\text{序列历史}.
}
\]

这恰好解释了为什么前面的记忆提升是必要的。若更新仍在复数乘法中，所有局部相位交换，路径历史被压缩成频率总和。把局部因子提升为上三角更新、半直积或其他非交换作用以后，才可能出现

\[
U_qU_p-U_pU_q
\]

以及对应的 swap curvature。

所以存在两种“次序”：

1. **谱次序。** 按大小排列 \(\log p\) 或按索引列出频率。这是一种表示选择，标量傅立叶核不保存该排列。
2. **作用次序。** 观察器先接受通道 \(p\)，随后接受通道 \(q\)。若记忆更新不交换，该次序形成可观察的历时。

第二种次序才与 chronology、路径和 holonomy 直接有关。

---

# 5. 有限傅立叶合成中的时间平移

Lean 对

\[
S(t)=\sum_pa_p\chi_{\omega_p}(t)
\]

证明精确平移律

\[
\boxed{
S(t+u)
=
\sum_p
\bigl(a_p\chi_{\omega_p}(t)\bigr)
\chi_{\omega_p}(u).
}
\]

每个频率通道在时间平移 \(u\) 下乘以自己的相位因子。频率不同意味着平移以后积累的相位不同。这就是通常意义上的相位色散。

Lean 同时证明

\[
\boxed{
|S(t)|
\le
\sum_p|a_p|.
}
\]

因为所有相位因子模长为一，时间流只旋转每个通道，不改变单通道振幅。整体振幅的变化来自通道之间的相长和相消干涉。

---

# 6. 时间、历时与时间箭头

当前真源允许区分三层。

## 6.1 参数时间

\[
t\in\mathbb R
\]

给出一参数群。正负时间均存在，演化可逆。傅立叶角色属于这一层。

## 6.2 观察历时

一串更新

\[
U_{p_m}\cdots U_{p_2}U_{p_1}
\]

记录观察器依次吸收通道的历史。更新不交换时，改变顺序会改变最终记忆状态。这一层由 holonomy 和曲率测量。

## 6.3 时间箭头

时间箭头需要更强结构，例如：

- 只有正时间的半群；
- 不可逆压缩；
- 熵或缺陷能量的单调性；
- 信息丢失；
- 边界条件选择。

傅立叶角色和非交换次序本身都不自动证明时间箭头。它们分别提供可逆时间参数和可观察历时。

因此你的直觉可以校准为

\[
\boxed{
\text{色散}
\longrightarrow
\text{频率角色}
\longrightarrow
\text{可逆谱时间},
}
\]

以及

\[
\boxed{
\text{记忆提升}
+
\text{非交换作用次序}
\longrightarrow
\text{可观察历时}.
}
\]

将二者组合并再加入耗散或单调性，才可能形成时间箭头。

---

# 7. 与前两条 holonomy 真源的连接

上一条真源给出有限交换缺陷能量

\[
\mathcal E^{\mathrm{hol}}
=
\sum_{p,q}\|C_{p,q}\|^2.
\]

本轮给每个通道加入时间相位

\[
z_p(t)=e^{-it\omega_p}.
\]

下一条自然定义是相位扭曲的局部更新

\[
\boxed{
\widetilde U_p(t)
=
U_p\cdot z_p(t)
}
\]

或在记忆注入中写成

\[
\boxed{
b_p(t)=z_p(t)b_p.}
\]

随后定义时间依赖曲率

\[
\boxed{
C_{p,q}(t)
=
(a-\lambda_q)b_p(t)
-
(a-\lambda_p)b_q(t).
}
\]

它会同时测量：

- residual 幅度失配；
- prime-frequency 相位失配；
- 观察器更新次序失配。

由于 \(|z_p(t)|=1\)，单通道范数不变；曲率能量随 \(t\) 的变化来自通道之间的相对相位。相对频率是

\[
\omega_p-\omega_q.
\]

在素数特化下，它成为

\[
\boxed{
\log p-\log q
=
\log\frac pq.
}
\]

因此 pairwise holonomy 的时间振荡自然由素数比值的对数频率控制。

该相位扭曲曲率尚未在本轮 Lean 文件中定义。它应形成下一节点 `PhaseTwistedStableSwapCurvature`。

---

# 8. 与 RH 的关系

在 zeta 的 Euler 侧，素数通道携带频率 \(\log p\)。在显式公式和傅立叶分析中，测试函数在这些频率上取值，零点则出现在对应的全局谱表达中。

本轮冻结了最底层的动力结构：

\[
\boxed{
\log p
\longleftrightarrow
e^{-it\log p}.
}
\]

它解释了为什么虚部坐标 \(t\) 可以被视为 prime-frequency flow 的谱时间，也说明仅靠标量 Euler 相位无法留下素数通道次序。为了让次序参与 RH 路线，必须通过记忆提升将通道作用非交换化，再证明时间依赖 holonomy 能量与零点侧离线奇能量之间的忠实桥。

预期链条变成

\[
\boxed{
\begin{aligned}
&\text{prime log-frequency characters}
\\
&\Longrightarrow
\text{phase-twisted memory updates}
\\
&\Longrightarrow
\text{time-dependent holonomy energy}
\\
&\Longrightarrow
\boxed{\text{explicit-formula faithful domination}}
\\
&\Longrightarrow
\text{off-line odd zero energy}.
\end{aligned}
}
\]

其中方框仍是核心缺口。傅立叶角色本身不定位零点，也不把 \(t\) 自动解释为物理时间。

---

# 9. 下一真源排序

当前最自然的推进顺序是：

1. `PhaseTwistedStableSwapCurvature`。把 \(e^{-it\omega_p}\) 写入稳定 residual 注入，推导精确相位扭曲曲率分解和范数界。
2. `FinitePhaseCoherenceIdentity`。证明 pairwise 相位色散能量与共同模态相干能量的守恒恒等式。
3. `FourierPhaseGenerator`。形式化
   \[
   \frac{d}{dt}e^{-it\omega}=-i\omega e^{-it\omega},
   \]
   把频率识别为时间流生成元。
4. `ResonanceConditionedOriginDispersion`。将 holonomy 能量运输到观察起源色散。
5. `PrimeArchimedeanHolonomyDomination`。通过显式公式连接 prime-side 时间曲率与 zero-side 离线奇能量。

第一条把用户提出的“色散、次序、时间”直接接回已有 holonomy 路线。第三条会给出频率作为时间生成元的机器版本。

---

# 10. 严格非主张

本轮不主张：

- 已定义完整连续傅立叶变换；
- 已证明傅立叶反演或 Plancherel；
- 频率排列本身产生时间；
- 已得到时间方向或不可逆性；
- zeta 虚部已经等同于物理时间；
- 相位扭曲 holonomy 已经支配零点能量；
- 已定位任何 zeta 零点；
- 已证明 RH。

本轮机器真源是

\[
\boxed{
\text{Fourier character time flow}
+
\text{scalar order collapse}
+
\text{finite synthesis laws}.
}

---

## [PR #4222] PHASE_TWISTED_HOLONOMY_AND_RELATIVE_PRIME_TIME

# 相位扭曲 holonomy 与相对素数时间
## 把傅立叶谱时间写入记忆通道后的第一条定量真源

**文档地位。** 本文解释 Lean 节点

`D5/S3/Observer/AgencyHolonomy/PhaseTwistedStableSwapCurvature`

及其主要声明：

- `phase_twisted_channel_norm`；
- `relative_phase_reconstruction`；
- `relative_log_address_phase_reconstruction`；
- `phase_twisted_curvature_zero_time`；
- `phase_twisted_stable_swap_curvature_bound`；
- `phase_twisted_finite_holonomy_energy_bound`。

机器事实以 Lean 声明为准。本文说明傅立叶参数时间如何进入非交换观察历时，并区分已经证明的统一能量界与尚未证明的同步、耗散和 prime-zero 桥。

---

# 1. 从频率角色到时间依赖记忆注入

前一节点定义

\[
\chi_\omega(t)=e^{-it\omega}.
\]

现在给每个通道 \(p\) 配置频率 \(\omega_p\) 和记忆向量 \(v_p\)，定义相位扭曲通道

\[
\boxed{
\widetilde v_p(t)
=
\chi_{\omega_p}(t)v_p
=
e^{-it\omega_p}v_p.
}
\]

若 residual 为 \(r_p\)，相应记忆注入变成

\[
\boxed{
\widetilde b_p(t)
=
r_p\widetilde v_p(t)
=
r_pe^{-it\omega_p}v_p.
}
\]

稳定通道 swap curvature 因此成为

\[
\boxed{
\widetilde C_{p,q}(t)
=
\bigl(a-(1+r_q)\bigr)r_p e^{-it\omega_p}v_p
-
\bigl(a-(1+r_p)\bigr)r_q e^{-it\omega_q}v_q.
}
\]

这里的 \(t\) 是傅立叶角色的一参数群坐标。通道经过观察器的先后顺序仍由记忆更新的乘法次序表达。两个结构在该定义中第一次同时出现：

\[
\boxed{
\text{spectral time phase}
+
\text{memory-order curvature}.
}
\]

---

# 2. 单位相位不会放大局部通道

Lean 证明

\[
\boxed{
\|\widetilde v_p(t)\|
=
\|v_p\|.
}
\]

原因是

\[
|e^{-it\omega_p}|=1.
\]

所以傅立叶时间流在每个单通道上是酉旋转。它改变相位，不改变通道振幅。

这一点很重要。任何随时间发生的总能量变化只能来自：

- 通道之间的相对相位；
- 不同残差和通道向量的组合；
- 记忆更新的非交换结构；
- 后续另行加入的耗散或增益。

单个傅立叶相位自身不产生耗散。

---

# 3. 真正可观察的是相对频率

Lean 证明

\[
\boxed{
\chi_{\omega_p-\omega_q}(t)
\chi_{\omega_q}(t)
=
\chi_{\omega_p}(t).
}
\]

因此两通道之间的相对相位由

\[
\boxed{
\Delta\omega_{p,q}
=
\omega_p-\omega_q
}
\]

生成。

对自然数地址使用

\[
\omega_n=\log n,
\]

Lean 证明无除法版本

\[
\boxed{
e^{-it(\log p-\log q)}e^{-it\log q}
=
e^{-it\log p}.}
\]

若另外假设地址为正，则纸面上可以写成

\[
\log p-\log q
=
\log\frac pq.
\]

所以 prime pair 的相对频率是

\[
\boxed{
\Delta\omega_{p,q}
=
\log p-\log q.
}
\]

这比单独的 \(\log p\) 更接近 swap curvature 的自然变量，因为曲率本来就是一个两通道量。

因此“色散产生时间”的更精确版本是：

\[
\boxed{
\text{频率差异}
\Longrightarrow
\text{相对相位随 }t\text{ 累积}
\Longrightarrow
\text{两通道干涉随 }t\text{ 改变}.
}
\]

---

# 4. 零时间切片恢复原始观察器

Lean 证明

\[
\boxed{
\widetilde C_{p,q}(0)
=
C_{p,q}.
}
\]

因为所有通道在 \(t=0\) 时满足

\[
\chi_{\omega_p}(0)=1.
\]

这把原来的静态 holonomy 真源识别为时间依赖系统的零时间切片。静态曲率并未被抛弃，它现在成为一参数曲率族的基点。

---

# 5. 精确相位扭曲 residual 分解

Lean 证明

\[
\boxed{
\begin{aligned}
\widetilde C_{p,q}(t)
={}&
(a-1)
\left(
r_p\widetilde v_p(t)
-r_q\widetilde v_q(t)
\right)
\\
&+
r_pr_q
\left(
\widetilde v_q(t)
-
\widetilde v_p(t)
\right).
\end{aligned}
}
\]

第一项是一阶 residual 注入失配。第二项是双 residual 修正。时间只通过两个旋转通道进入。

这给后续分析两个分解方向：

1. 固定 residual 深度，研究 \(t\) 上的相位干涉；
2. 固定谱时间，研究 extraction 深度上 residual envelope 的衰减。

最终需要处理一个双参数极限或统一界：

\[
(r,t)
\longmapsto
\widetilde C^{\langle r\rangle}_{p,q}(t).
\]

---

# 6. pairwise 曲率界在时间上统一

若

\[
\|v_p\|\le1,
\qquad
\|v_q\|\le1,
\]

Lean 证明

\[
\boxed{
\|\widetilde C_{p,q}(t)\|
\le
\|a-1\|
\bigl(\|r_p\|+\|r_q\|\bigr)
+
2\|r_p\|\|r_q\|
}
\]

对每个 \(t\in\mathbb R\) 成立。

若

\[
\|r_p\|,\|r_q\|\le\varepsilon,
\]

则

\[
\boxed{
\|\widetilde C_{p,q}(t)\|
\le
2\|a-1\|\varepsilon
+2\varepsilon^2.
}
\]

右侧不含 \(t\)。因此 residual envelope 一旦收敛，就可以得到对整个谱时间轴统一的 pairwise 曲率控制，前提是通道向量的单位界本身统一成立。

这是本轮最重要的定量结果：

\[
\boxed{
\text{unitary spectral-time twisting does not consume residual control.}
}
\]

---

# 7. 有限 holonomy 能量的统一时间界

对有限通道集 \(P\)，Lean 定义

\[
\boxed{
\widetilde{\mathcal E}^{\mathrm{hol}}_P(t)
=
\sum_{p,q\in P}
\|\widetilde C_{p,q}(t)\|^2.
}
\]

若 \(|P|=M\)，所有通道单位有界，所有 residual 由同一 \(\varepsilon\ge0\) 控制，Lean 证明

\[
\boxed{
0
\le
\widetilde{\mathcal E}^{\mathrm{hol}}_P(t)
\le
M^2
\left(
2\|a-1\|\varepsilon+2\varepsilon^2
\right)^2
}
\]

对所有谱时间成立。

同时：

\[
\boxed{
\widetilde{\mathcal E}^{\mathrm{hol}}_P(t)=0
\iff
\forall p,q\in P,
\widetilde C_{p,q}(t)=0.
}
\]

所以该能量在每个时间切片上仍然是忠实的非负缺陷量。

需要注意，统一上界不表示能量对时间恒定。各项内部存在不同相位，\(\widetilde C_{p,q}(t)\) 的范数可以随时间变化。机器结论只说明它始终被同一个 residual envelope 控制。

---

# 8. 现在出现了哪一种时间

当前系统已有两个严格结构。

## 8.1 可逆谱时间

\[
t\mapsto e^{-it\omega_p}
\]

是加法群的一参数酉作用。它允许正时间和负时间，天然可逆。

## 8.2 可观察的作用历时

\[
U_q(t)U_p(t)
\quad\text{与}\quad
U_p(t)U_q(t)
\]

在记忆提升以后可以不同。swap curvature 记录这种路径差异。

二者结合得到“随谱时间演化的观察历时”。这里仍没有时间箭头，因为没有证明

\[
\frac{d}{dt}
\widetilde{\mathcal E}^{\mathrm{hol}}_P(t)
\le0
\]

或任何不可逆半群性质。

时间箭头需要再加入耗散、粗粒化、单调 Lyapunov 量、只允许正时间的边界条件，或其他选择机制。

---

# 9. 与共振压平的关系

相位扭曲以后，通道同步意味着相对相位

\[
e^{-it(\omega_p-\omega_q)}
\]

在有效观察窗口内接近一，同时 residual 注入和通道起源也需要兼容。

仅出现某个时刻的相位重合不足以给出全局压平。更强目标可能是：

\[
\boxed{
\int_I
\widetilde{\mathcal E}^{\mathrm{hol}}_P(t)w(t)\,dt
\longrightarrow0
}
\]

或

\[
\boxed{
\sup_{t\in I}
\widetilde{\mathcal E}^{\mathrm{hol}}_P(t)
\longrightarrow0.
}
\]

本轮统一 residual 界支持第二种路线，因为右侧与 \(t\) 无关。实际结论仍依赖 residual envelope decay。

下一条 `FinitePhaseCoherenceIdentity` 应负责把 pairwise 相位差能量与共同相干模态能量连接起来。随后可以研究该相干能量在时间平均、测试函数加权和显式公式下如何投影到零点侧。

---

# 10. 与 RH 路线的更新连接

当前 prime-side 链条已经变成

\[
\boxed{
\begin{aligned}
&\log p\text{ frequency channels}
\\
&\Longrightarrow
e^{-it\log p}\text{ spectral-time phases}
\\
&\Longrightarrow
\widetilde C_{p,q}(t)\text{ phase-twisted swap curvature}
\\
&\Longrightarrow
\widetilde{\mathcal E}^{\mathrm{hol}}_P(t)
\text{ finite defect energy}
\\
&\Longrightarrow
\boxed{\text{explicit-formula faithful domination}}
\\
&\Longrightarrow
\text{off-line odd zero energy}.
\end{aligned}
}
\]

方框仍是核心缺口。当前新内容提供一个适合被测试函数积分的时间依赖 prime-side 能量候选。它尚未证明该积分等于、支配或逼近任何 zero-side 量。

一个关键新观察是：显式公式中的测试函数本来就在对 \(t\) 或其傅立叶对偶进行加权。现在 holonomy 也成为 \(t\) 的函数，因此可以第一次提出类型正确的桥：

\[
\boxed{
\mathcal E_{\mathrm{off}}^{\mathrm{odd}}(g)
\le
A_g
\int_{\mathbb R}
\widetilde{\mathcal E}^{\mathrm{hol}}_P(t)
\,d\mu_g(t)
+R_{P,g}.
}
\]

其中 \(\mu_g\) 必须由允许的测试函数类产生，\(R_{P,g}\) 必须显式记账并可控。该不等式目前只是下一阶段的目标类型。

---

# 11. 下一真源

当前最自然的下一节点是：

1. `FinitePhaseCoherenceIdentity`。把
   \[
   \sum_{p,q}w_pw_q|z_p-z_q|^2
   \]
   写成最大总能量减共同模态能量。
2. `FourierPhaseGenerator`。证明频率是谱时间流的生成元。
3. `TimeAveragedPhaseHolonomyEnergy`。定义测试函数加权的时间积分能量并证明非负性和 residual 上界。
4. `ResonanceConditionedOriginDispersion`。把时间依赖曲率运输到观察起源色散。
5. `PrimeArchimedeanHolonomyDomination`。尝试建立显式公式忠实桥。

第三条会把当前有限点态界变为适合进入 explicit formula 的积分对象。

---

# 12. 严格非主张

本轮不主张：

- 相位已经同步；
- holonomy 能量随时间单调；
- 已构造时间箭头；
- residual envelope 已经衰减；
- 时间积分能量已经定义；
- prime-side 能量已经等于或支配 zero-side 能量；
- 已定位任何 zeta 零点；
- 已证明 RH。

本轮机器真源是

\[
\boxed{
\text{unitary prime-frequency phase twist}
\Longrightarrow
\text{time-dependent stable curvature}
\Longrightarrow
\text{time-uniform finite residual-energy bound}.
\]

## [PR #4233] NEGATIVITY_REFLECTION_TIME_THEORY

# 负性、负平方与负时间理论
## 反射分裂、观察锥与时间定向研究卷；不是 RH 证明声明

仓库取阅基线：`the-omega-institute/trureturing` 的 `dev` 提交 `23747a66fdb518fd82dbccc6ca5fca0126d6d33c`。本卷与同一 PR 中的 Lean 真源共同提交。

本卷把“负性”“负平方”“负时间”拆成可独立审计的数学角色。核心原则是：负号不自带统一含义。它总是相对于一个正锥、允许支撑、时间定向、谱稳定域或二次型而出现。

文中使用三种标签：

- `[formalized-here]`：由同一 PR 的 Lean 真源机器证明。
- `[repo-derived]`：由现有 `dev` 真源支持。
- `[research-target]`：由已闭合事实导出的下一条定义或定理目标，尚未冒充内核结论。

## 一、负性是相对于正锥的越界

设对象空间为 $X$，允许对象形成正锥 $C\subseteq X$。若存在对偶观察器 $\ell$ 满足

$$
\ell(c)\ge 0\qquad(c\in C),
$$

但对某个对象 $x$ 有

$$
\ell(x)<0,
$$

则 $\ell$ 是 $x$ 离开正锥的负性证书：

$$
\operatorname{NegativeWitness}_{C}(x)
\;:\Longleftrightarrow\;
\exists\ell\in C^{\vee},\ \ell(x)<0.
$$

以下对象必须保持强类型区分：

1. 负标量：$a<0$。
2. 负支撑：正质量位于禁止区域，例如 $x<0$。
3. 负质量：测度系数本身为负。
4. 负方向：存在 $v\ne0$ 使二次型 $Q(v)<0$。
5. 负指数：最大负定子空间的维数。
6. 负时间：相对于选定正向时间锥的反向参数或逆向完成。
7. 负频率：Fourier 相位的反向绕行，它不等于过去时间。

这些概念之间可以建立运输定理，不能直接互相替换。

## 二、负平方不是实数平方小于零

对实数 $\delta$，算术平方始终满足

$$
\delta^2\ge0.
$$

本路线所说的“负平方”是

$$
-\delta^2,
$$

即先形成反射不变量 $\delta^2$，再用负号记录该量进入了一个带符号的结构位置。

在 RH 的法向坐标中，令

$$
\delta=\Re\rho-\frac12.
$$

函数方程反射交换 $\delta$ 与 $-\delta$。反射商空间无法保留左右标签，只能保留偏移大小 $\delta^2$。若还需要记录轨道位于临界线外，则候选有符号法向坐标为

$$
\boxed{x_{\perp}=-\delta^2.}
$$

负号表达“离线扇区”或“禁止支撑扇区”，并不表示平方运算产生负数。

## 三、术语校正：负平方是行列式，不是标准多项式判别式

考虑反射生成率对

$$
+\delta,\qquad-\delta.
$$

一阶和完全抵消：

$$
\delta+(-\delta)=0.
$$

二阶乘积留下：

$$
\delta(-\delta)=-\delta^2.
$$

若把生成元写成

$$
A_{\delta}=\begin{pmatrix}\delta&0\\0&-\delta\end{pmatrix},
$$

则

$$
\operatorname{tr}A_{\delta}=0,
\qquad
\det A_{\delta}=-\delta^2,
\qquad
A_{\delta}^2=\delta^2I.
$$

对形式谱变量 $r$：

$$
(r-\delta)(r+\delta)=r^2-\delta^2.
$$

因此负量 $-\delta^2$ 是反射生成元的有符号行列式，也是特征多项式的常数项。本卷把它定义为

$$
\boxed{
\operatorname{ReflectionPairSignedDeterminant}(\delta)
=-\delta^2.
}
$$

标准二次多项式判别式必须单独计算。对

$$
r^2-\delta^2,
$$

其标准判别式为

$$
\boxed{
\Delta_{\mathrm{poly}}
=0^2-4\cdot1\cdot(-\delta^2)
=4\delta^2.
}
$$

[formalized-here] 同一 Lean 节点同时证明 $-\delta^2$ 的有符号行列式身份和 $4\delta^2$ 的标准判别式身份，防止术语混同。

## 四、增长与衰减是负平方的有向时间实现

定义一对指数分支

$$
g_{+}(t)=e^{\delta t},
\qquad
g_{-}(t)=e^{-\delta t}.
$$

[formalized-here] 它们满足

$$
g_{+}(-t)=g_{-}(t),
\qquad
g_{-}(-t)=g_{+}(t),
$$

以及

$$
g_{+}(t)g_{-}(t)=1.
$$

因此时间反演不会删除分裂。它交换扩张与收缩分支。

[formalized-here] 当 $\delta>0$ 且 $t>0$ 时：

$$
g_{+}(t)>1,
\qquad
g_{-}(t)<1.
$$

在负时间方向，两个角色交换。反射对整体没有预先选定唯一稳定箭头。稳定性依赖观察者声明的正向时间锥。

## 五、反射增长对位于正双曲线上

由乘积守恒：

$$
g_{+}(t)g_{-}(t)=1,
$$

反射增长对落在正双曲线

$$
xy=1,
\qquad x>0,\ y>0
$$

上。

定义偶、奇坐标

$$
E_{\delta}(t)
=\frac{g_{+}(t)+g_{-}(t)}{2},
$$

$$
O_{\delta}(t)
=\frac{g_{+}(t)-g_{-}(t)}{2}.
$$

则预期有

$$
E_{\delta}(t)=\cosh(\delta t),
\qquad
O_{\delta}(t)=\sinh(\delta t),
$$

以及

$$
\boxed{
E_{\delta}(t)^2-O_{\delta}(t)^2=1.
}
$$

时间反演保持偶坐标并翻转奇坐标：

$$
E_{\delta}(-t)=E_{\delta}(t),
$$

$$
O_{\delta}(-t)=-O_{\delta}(t).
$$

[research-target] 这组等式应形成 `ReflectedGrowthPairEvenOddDecomposition`。它将把“时间方向信息”精确定位到奇通道，而把“反射不变量”定位到偶通道和负平方行列式。

## 六、对称观察商丢失时间箭头

定义分支遗忘读出

$$
S_{\delta}(t)=g_{+}(t)+g_{-}(t).
$$

[formalized-here] 有

$$
S_{\delta}(-t)=S_{\delta}(t).
$$

因此该观察器无法区分 $t$ 与 $-t$。有向二分支状态仍保留时间方向，对称商只保留时间反演轨道

$$
\{t,-t\}.
$$

[research-target] 应进一步机器证明：当 $\delta\ne0$ 时，有向映射

$$
t\longmapsto(g_{+}(t),g_{-}(t))
$$

是单射，而对称读出在任意 $t\ne0$ 处都发生

$$
S_{\delta}(t)=S_{\delta}(-t),
\qquad
t\ne-t.
$$

这会给出一个最小的 observer theorem：

$$
\boxed{
\text{有向完成保留负时间，分支遗忘商丢失时间方向。}
}
$$

加入奇通道 $O_{\delta}$ 后，可以恢复方向。对 $\delta>0$，其符号预期与 $t$ 的符号一致。

## 七、负时间的五种角色

必须区分：

1. $t<0$：坐标位于选定原点之前。
2. $t\mapsto-t$：时间反演 involution。
3. $U(-t)=U(t)^{-1}$：可逆动力学的逆向演化。
4. $\omega<0$：负频率或反向相位绕行。
5. 度量中的 $-dt^2$：时间方向在不定二次型中的符号。

只有第三项要求演化构成群。耗散、投影、测量与粗粒化通常只给出 $t\ge0$ 的半群。此时负时间是过去完成问题。

若前向观察为

$$
q:X\to Y,
$$

则给定当前读数 $y$ 的全部可能过去为

$$
\operatorname{PastFiber}(y)=\{x\in X:q(x)=y\}.
$$

当 $q$ 非单射时，逆向时间是集合值 completion fiber。加入足够记忆后，提升映射

$$
\widetilde q:X\to Y\times M
$$

可能恢复单射，从而在完成后的状态空间中恢复双向时间。

[research-target] 对当前反射增长对，应定义逐坐标乘法并证明

$$
G_{\delta}(s+t)=G_{\delta}(s)\odot G_{\delta}(t),
$$

$$
G_{\delta}(0)=(1,1),
$$

$$
G_{\delta}(-t)=G_{\delta}(t)^{-1}.
$$

这会把负时间从直觉上的“另一侧”升级为有向完成群中的真实逆元。

## 八、负支撑、负方向与 negative square

对测度

$$
\nu=\sum_jm_j\delta_{x_j},
$$

“负质量”指 $m_j<0$。“负支撑”指 $m_j>0$ 但 $x_j<0$。当前 RH normal-resolvent 路线更自然地把异常放在支撑位置：

$$
m_{\rho}>0,
\qquad
x_{\rho}=-\delta^2<0.
$$

若测试函数 $p$ 在允许支撑 $[0,\infty)$ 上非负，而在 $-\delta^2$ 处为负，则

$$
\int p(x)\,d\nu(x)<0.
$$

这把负支撑运输成负矩，再运输成 Toeplitz、Pick 或 Weil 二次型的负方向。

对于 Hermitian 核 $K$，有限采样矩阵

$$
G_{jk}=K(z_j,z_k)
$$

若存在 $c\ne0$ 使

$$
c^{*}Gc<0,
$$

则出现一个 negative square。负平方指数是最大独立负子空间的维数。它记录系统拥有多少个彼此独立的向下方向。

## 九、负平方是二阶算子的负谱值

令

$$
L=-\frac{d^2}{dt^2}.
$$

对增长分支 $g_{\pm}(t)=e^{\pm\delta t}$，预期有

$$
\frac{d^2}{dt^2}g_{\pm}(t)
=\delta^2g_{\pm}(t),
$$

因此

$$
\boxed{
Lg_{\pm}=-\delta^2g_{\pm}.
}
$$

这给出负平方的谱解释：$-\delta^2$ 是前向增长和衰减模式在算子 $-d^2/dt^2$ 下的共同负谱值。

对振荡模式 $e^{\pm i\gamma t}$，同一算子产生正谱值 $+\gamma^2$。由此出现一个候选三分法：

$$
\begin{array}{c|c|c}
\text{生成元类型}&\text{有符号行列式}&\text{动力学}\
\hline
\text{双曲}&-\delta^2&\text{增长/衰减}\
\text{中性}&0&\text{无分裂}\
\text{椭圆}&+\gamma^2&\text{单位模振荡}
\end{array}
$$

[research-target] 先形式化 `ReflectedGrowthPairSecondOrderSpectrum`，再建立 `EllipticHyperbolicReflectionTrichotomy`。第二条需要复指数或实二维旋转生成元，不能由本轮标量定理直接宣称。

## 十、负平方与 Laplace 时间的桥

对适当的 $u$，有

$$
\frac1{u+x}=\int_0^{\infty}e^{-ut}e^{-xt}\,dt.
$$

若 $x>0$，则 $e^{-xt}$ 在正时间衰减。若 $x=-\delta^2<0$，则

$$
e^{-xt}=e^{\delta^2t}
$$

在正时间增长。总核只有在外加阻尼超过增长率时收敛：

$$
\boxed{
u>\delta^2.}
$$

在该区域：

$$
\boxed{
\int_0^{\infty}e^{-(u-\delta^2)t}\,dt
=\frac1{u-\delta^2}.
}
$$

由此可定义稳定化债务

$$
\boxed{
\operatorname{StabilizationDebt}(-\delta^2)=\delta^2.
}
$$

它是压过负支撑增长所需的最小附加阻尼阈值。

[research-target] `NegativeSquareLaplaceResolvent` 应证明积分值、可积条件和阈值处的极点。比只证明积分公式更重要的是完整刻画：

$$
\operatorname{Integrable}
\left(e^{-(u-\delta^2)t};\ t>0\right)
\quad\Longleftrightarrow\quad
u>\delta^2.
$$

## 十一、与离线零点曲率 dipole 的关系

[repo-derived] 对离线反射对，仓库已有曲率真源

$$
K_{\delta,\gamma}(t)
=2\frac{(t-\gamma)^2-\delta^2}
{((t-\gamma)^2+\delta^2)^2}.
$$

分子

$$
(t-\gamma)^2-\delta^2
$$

是一个不定二次型。区域 $|t-\gamma|<|\delta|$ 为负核心，外部为正翼，总质量为零。故离线缺陷是一种局部重分配。零频率或只读取总积分的观察器无法检测它。

将

$$
\tau=t-\gamma
$$

代入后，符号边界

$$
\tau^2-\delta^2=0
$$

形成两条特征线 $\tau=\pm\delta$。这与反射生成元的特征因子

$$
(r-\delta)(r+\delta)=r^2-\delta^2
$$

具有同一代数骨架。

[research-target] 应建立一个明确的 observer agreement：曲率 dipole 的负核心宽度、反射增长对的双曲率和 signed normal atom 的位置都由同一个参数 $\delta^2$ 控制。只有获得精确等式或带误差运输，这一结构相似性才能承担 RH 路径。

## 十二、本轮形式化边界

同一 PR 的 Lean 真源只冻结以下无条件事实：

1. 交换两个指数分支等于时间反演。
2. 两个分支的乘积恒为一。
3. 反射生成率对的迹为零。
4. 反射对有符号行列式精确等于 $-\delta^2$。
5. 标准二次多项式判别式精确等于 $4\delta^2$。
6. 特征因子为 $r^2-\delta^2$。
7. 在 $\delta>0,t>0$ 时，一支严格扩张，另一支严格收缩。
8. 对称分支和是时间偶函数。

本轮不声明：

- zeta ordinate 是物理时间；
- completed zeta 已经拥有该指数 realization；
- 任意离线零点已经被有限观察器隔离；
- 全局 signed normal spectral measure 已构造；
- 上述一般结构推出 RH。

## 十三、后续 theorem DAG

```text
ReflectedGrowthPairNegativeSquare
        |
        +--> ReflectedGrowthPairTimeGroup
        |          |
        |          v
        |    OrientedTimeRecoverySymmetricTimeLoss
        |
        +--> ReflectedGrowthPairEvenOddDecomposition
        |          |
        |          v
        |    EvenObserverFirstOrderBlindness
        |
        +--> ReflectedGrowthPairSecondOrderSpectrum
        |          |
        |          v
        |    EllipticHyperbolicReflectionTrichotomy
        |
        v
NegativeSquareLaplaceResolvent
        |
        v
SignedNormalSpectralAtom
        |
        v
ChebyshevNegativeSupportSeparator
        |
        v
FiniteMomentNegativeWitness
        |
        v
Toeplitz/Pick/Weil Negative Direction
```

## 十四、下一步优先级

### P0：`ReflectedGrowthPairSecondOrderSpectrum`

机器证明

$$
g_{\pm}''=\delta^2g_{\pm},
\qquad
- g_{\pm}''=-\delta^2g_{\pm},
$$

以及

$$
S_{\delta}'(0)=0,
\qquad
S_{\delta}''(0)=2\delta^2.
$$

该节点直接把有符号行列式接成真实负谱值，并证明对称观察器的一阶盲性与二阶可见性。

### P0：`OrientedTimeRecoverySymmetricTimeLoss`

机器证明有向 pair flow 的群律、负时间逆元、$\delta\ne0$ 时的单射性，以及对称读出的 $t/-t$ 碰撞。该节点把“负时间是 completion fiber”写成最小可复用观察者定理。

### P1：`NegativeSquareLaplaceResolvent`

证明稳定化阈值 $u>\delta^2$、积分 resolvent 和阈值极点。该节点把时间增长接入 signed support、Stieltjes 和 positive-real completion。

### P1：`EllipticHyperbolicReflectionTrichotomy`

引入振荡对与实二维旋转生成元，严格区分正行列式的椭圆振荡、零行列式的中性模式和负行列式的双曲增长/衰减。该节点将为临界线振子与离线径向分裂提供共同分类语言。

## [PR #4243] REFLECTED_ZERO_MODE_PHASE_FLATTENING_THEORY

# 反射零点模式与相位压平理论
## 从临界位移、频率与辅助时间中分离三个反向操作

仓库基线：`the-omega-institute/trureturing` 的 `dev` 分支，分支创建时提交为 `2deefdd8b7de08ef84311b00fed4f60516194fba`。

本卷承接负性、负平方与负时间理论。前一层指出，反射增长率对 `delta` 与 `-delta` 的一阶和为零，有符号行列式为 `-delta^2`。本层进一步把这一通用双曲结构接到仓库已经冻结的 zeta 零点生成元坐标，并严格区分函数方程反射、复共轭和辅助模式时间反演。

本卷不是 RH 证明声明。这里的 `time` 是指数模式参数，不被解释为物理时间。所有关于 completed zeta、Weil 正性和全局谱完成的结论仍需额外桥梁。

## 一、归一化零点生成元

对任意复点

$$
rho=sigma+i gamma,
$$

定义相对临界线的有符号横向位移

$$
delta(rho)=\operatorname{Re}rho-\frac12.
$$

仓库现有 `CriticalDampingGenerator` 在消去统一阻尼平移后留下的标量生成元为

$$
\boxed{
g(rho)=-delta(rho)+i\operatorname{Im}rho.
}
$$

于是定义辅助指数模式

$$
\boxed{
M_rho(t)=\exp(g(rho)t).
}
$$

生成元实部控制幅度变化，虚部控制相位旋转：

$$
\operatorname{Re}g(rho)=-delta(rho),
\qquad
\operatorname{Im}g(rho)=\operatorname{Im}rho.
$$

因此

$$
\overline{g(rho)}=-g(rho)
$$

当且仅当

$$
\operatorname{Re}rho=\frac12.
$$

这与现有零点族级别的 skew-adjoint 判据相容。本层把它提升为任意单点的明确坐标恒等式。

## 二、径向通道与相位通道

定义径向通道

$$
R_rho(t)=\exp(-delta(rho)t),
$$

以及公共相位通道

$$
P_rho(t)=\exp(i\operatorname{Im}(rho)t).
$$

则

$$
\boxed{
M_rho(t)=R_rho(t)P_rho(t).
}
$$

相位通道满足

$$
|P_rho(t)|=1.
$$

所以模式的模长完全由横向位移控制：

$$
|M_rho(t)|=\exp(-delta(rho)t).
$$

定义相位压平观察

$$
\operatorname{Flat}(rho,t)
=M_rho(t)\exp(-i\operatorname{Im}(rho)t).
$$

则精确得到

$$
\boxed{
\operatorname{Flat}(rho,t)=R_rho(t).
}
$$

相位压平没有近似误差，也不需要选择对数分支。它只利用整个函数 `exp` 的乘法恒等式。

## 三、三个容易混淆的反向操作

### 1. 函数方程反射

定义

$$
F(rho)=1-rho.
$$

若 `rho` 的坐标为 `(delta,gamma)`，则

$$
F:(delta,gamma)\mapsto(-delta,-gamma).
$$

生成元满足

$$
g(F(rho))=-g(rho).
$$

因此

$$
\boxed{
M_{F(rho)}(t)=M_rho(-t).
}
$$

函数方程反射在辅助模式层等同于完整生成元的时间反演。它同时翻转径向速率和频率。

### 2. 复共轭

定义

$$
C(rho)=\overline{rho}.
$$

其坐标作用为

$$
C:(delta,gamma)\mapsto(delta,-gamma).
$$

生成元满足

$$
g(C(rho))=\overline{g(rho)}.
$$

模式满足

$$
\boxed{
M_{C(rho)}(t)=\overline{M_rho(t)}.
}
$$

复共轭保留径向增长率，只反转相位绕行方向。它对应负频率，不等同于负时间。

### 3. 同高度临界线镜像

定义

$$
H(rho)=1-\overline{rho}.
$$

其坐标作用为

$$
H:(delta,gamma)\mapsto(-delta,gamma).
$$

它可以写成

$$
H=F\circ C=C\circ F.
$$

生成元满足

$$
g(H(rho))=-\overline{g(rho)}.
$$

相位压平后，`rho` 与 `H(rho)` 的两个径向模式互为倒数：

$$
\boxed{
\operatorname{Flat}(rho,t)\operatorname{Flat}(H(rho),t)=1.
}
$$

这正是离线反射对的增长和衰减双支结构。

## 四、对称方形

三个非平凡变换与恒等变换组成一个 Klein 四群：

$$
\{I,F,C,H\},
\qquad
F^2=C^2=H^2=I,
\qquad
FC=CF=H.
$$

其坐标表为：

| 变换 | 位移 `delta` | 频率 `gamma` | 模式作用 |
| --- | ---: | ---: | --- |
| `I` | `delta` | `gamma` | 原模式 |
| `F` | `-delta` | `-gamma` | 辅助时间反演 |
| `C` | `delta` | `-gamma` | 复共轭 |
| `H` | `-delta` | `gamma` | 同相位的径向互反 |

仓库的 `ZeroData` 已经分别保存 `reflection` 和 `conjugation` 两个零点索引置换。由于零点枚举无重复，两个复平面复合都落到同一个同高度镜像点，从而两个索引置换交换：

$$
\boxed{
R(C(n))=C(R(n)).
}
$$

这里的交换不是额外假设。它由两个零点图像相等和枚举单射性推出。

## 五、临界线的模式含义

当

$$
delta(rho)=0,
$$

径向通道退化为常数一：

$$
R_rho(t)=1.
$$

归一化模式成为纯单位模旋转：

$$
M_rho(t)=\exp(i\gamma t).
$$

因此临界线可以解释为归一化生成元没有径向增长或衰减。离线点则产生一对同相位的互反径向分支。

这个解释与负平方真源相连。若同高度镜像位移为 `delta` 和 `-delta`，对应径向生成率为 `-delta` 和 `delta`，则它们的有符号行列式为

$$
-delta^2.
$$

本层没有重复形式化该行列式，因为相应真源仍在独立 PR 中。本层只冻结从实际零点坐标到径向互反对的精确表示桥。

## 六、形式化边界

同一 PR 的 Lean 真源只建立以下无条件事实：

1. 仓库现有阻尼平移表达式精确化简为 `g(rho)`。
2. `g(rho)` 为 skew 当且仅当 `rho` 位于临界线。
3. `M_rho` 精确分解为径向通道与单位相位通道。
4. 相位压平精确恢复径向通道。
5. 函数方程反射在模式层等于辅助时间反演。
6. 共轭只反转相位频率。
7. 同高度临界线镜像在相位压平后给出互为倒数的径向分支。
8. `ZeroData` 的反射与共轭置换交换。

本层不声明：

- 指数模式参数等于物理时间；
- 所有 `ZeroData` 的构造已经无条件存在；
- completed zeta 是某个有限维动力系统的特征行列式；
- 相位压平本身产生 Weil 或 Pick 负证书；
- 任意离线零点已经被有限测试函数隔离；
- 上述表示桥推出 RH。

## 七、基于形式化真理的下一研究义务

### 1. 二阶谱节点

对径向模式应形式化

$$
\frac{d^2}{dt^2}R_rho(t)=delta(rho)^2R_rho(t),
$$

从而

$$
-\frac{d^2}{dt^2}R_rho(t)=-delta(rho)^2R_rho(t).
$$

这会把有符号行列式 `-delta^2` 升级为实际二阶算子的负谱值，并连接 normal jet。

### 2. 偶奇观察节点

定义

$$
E(t)=\frac{R(t)+R(-t)}2,
\qquad
O(t)=\frac{R(t)-R(-t)}2.
$$

应证明偶通道保存位移平方而丢失方向，奇通道在非零位移下恢复时间定向。

### 3. 负平方 Laplace resolvent

在明确条件 `u>delta^2` 下形式化

$$
\int_0^\infty e^{-(u-delta^2)t}\,dt
=\frac1{u-delta^2}.
$$

这会把负谱值连接到稳定化债务和 resolvent 极点。

### 4. 曲率互作用节点

需要把相位压平后的径向互反对与已有 `OffLineCurvatureDipole` 的法向二阶对数曲率精确连接。目标不是结构类比，而是一个可运输误差和符号的等式。

## 八、更新后的 theorem DAG

```text
CriticalDampingGenerator
        |
        v
ReflectedZeroModePhaseFlattening
        |
        +-----------------------------+
        |                             |
        v                             v
SecondOrderRadialSpectrum       EvenOddModeObserver
        |                             |
        +--------------+--------------+
                       |
                       v
          NegativeSquareLaplaceResolvent
                       |
                       v
          OffLineCurvatureModeIntertwiner
                       |
                       v
             SignedNormalSpectralAtom
                       |
                       v
       Chebyshev / Toeplitz / Pick / Weil witness
```

下一真源的最高优先级是 `ReflectedZeroModeSecondOrderSpectrum`。它将第一次把本层的表示分解变成一个真正的负谱陈述。

---

## [PR #4373] RH_RESEARCH_LANE_LEDGER — Time-Ordered Prime Memory Cocycle

> **统一理论卷规则(本节起生效)。** RH research lane 的新理论推理统一追加到本卷。后续形式化节点继续拥有各自的 Lean GID、Scribe 源和 Blueprint 镜像，但不再为每个节点新建独立 theory 文档。本卷 append-only：勘误以新追加的正文发表，不改动既有字节。

# RH Research Lane Theory
## 累积研究真源、约束账本与下一桥梁

> **统一理论卷规则。** 从本文件建立以后，RH research lane 的新理论推理统一追加到 `RH_RESEARCH_LANE_THEORY.md`。后续形式化节点继续拥有各自的 Lean GID、Scribe 源和 Blueprint 镜像，但不再为每个节点新建独立 theory 文档。
>
> 本文件在 `dev` 尚不存在同名卷时初始化。此前的 `GOLDEN_OBSERVER_RH_ROUTE.md`、`OBSERVER_ADELIC_COMPLETION_CONSTANT_THEORY.md` 以及已合并的节点级理论文件继续作为历史来源和 digestion 输入。本文件承担向前演化的单一研究账本，不在本轮删除历史文件，以免破坏已有引用和内容寻址记录。

---

# 0. 认识论状态与使用规则

本研究卷严格区分三种状态。

## 0.1 已冻结机器事实

只有已经进入对应 Lean GID，并通过仓库 admission 的声明，才可以作为后续推理的无条件前提。

当前与黄金素数记忆、色散和 RH 路线直接相关的已冻结节点包括：

- `D5/S3/Observer/AgencyHolonomy/PrimeSwapCurvature`
- `D5/S3/Observer/AgencyHolonomy/StableResidualSwapCurvatureBound`
- `D5/S3/Observer/AgencyHolonomy/FiniteHolonomyEnergy`
- `D5/S3/Observer/AgencyHolonomy/PrimeFrequencyPhaseFlow`
- `D5/S3/Observer/AgencyHolonomy/PhaseTwistedStableSwapCurvature`
- `D5/S3/Weil/HolonomyBridge/OffLineOrbitParityDecomposition`
- `D5/S3/Analytic/Boundary/InteriorCurvatureCriterion`

本轮候选节点为：

- `D5/S3/Observer/AgencyHolonomy/TimeOrderedPrimeMemoryCocycle`

在该候选通过 canonical Lean report 和 content-addressed admission 以前，本节新增结论仍应标为 candidate truth。

## 0.2 条件桥

条件桥是形式上足以连接 RH，但其关键前提尚未由 prime side 独立构造的定理。当前最重要的条件桥是：

\[
P_{L,N}\mathcal O^{\mathrm{off}}_{L,T}P_{L,N}
\preceq
C_{L,N,T}\mathcal V^{\mathrm{hol}}_{r,L,N}
+
\varepsilon_{r,L,N,T}I.
\]

这里 \(\mathcal V^{\mathrm{hol}}\) 是 prime-side 规范约化 holonomy 能量，\(\mathcal O^{\mathrm{off}}\) 是 zero-side 离线奇谱能量。该支配仍是路线的 hard heart。

## 0.3 解释性图景

白光、色散、共振、圆、观察者和时间可以指导定义。它们本身不构成证明。每个解释必须最终落到以下一种可审计对象：

\[
\text{定义},\quad
\text{恒等式},\quad
\text{不等式},\quad
\text{极限},\quad
\text{反例},\quad
\text{有限失败证书}.
\]

---

# 1. 当前主路线的机器骨架

带记忆的局部素数观察器可以写成上三角更新：

\[
\mathbf U_{r,p}(s)
=
\begin{pmatrix}
\mathbf F & \bigl(L_p^{\langle r\rangle}(s)-1\bigr)v_p\\
0 & L_p^{\langle r\rangle}(s)
\end{pmatrix}.
\]

将 Fibonacci 记忆投影到稳定特征通道后，记：

\[
a=-\varphi^{-1},
\qquad
\lambda_p=L_p^{\langle r\rangle}(s),
\qquad
b_p=b^-_{r,p}(s).
\]

一维稳定更新为：

\[
U_p(m,z)
=
\bigl(am+b_pz,\lambda_pz\bigr).
\]

## 1.1 标量完成与记忆历史

标量因子满足交换律：

\[
\lambda_p\lambda_q=\lambda_q\lambda_p.
\]

所以标量输出只能读取 prime multiset，无法读取观察词的次序。

记忆提升一般不交换。两事件交换曲率为：

\[
\boxed{
C_{p,q}
=
(a-\lambda_q)b_p-(a-\lambda_p)b_q.
}
\]

已冻结的 `PrimeSwapCurvature` 证明：

\[
C_{q,p}=-C_{p,q},
\]

并证明共同记忆原点变换

\[
b_p\mapsto b_p+(a-\lambda_p)c
\]

不改变 \(C_{p,q}\)。因此共同 archive 属于 coboundary，交换曲率只读取不同通道之间无法由同一观察起源解释的部分。

远离共振时，定义：

\[
c_p=\frac{b_p}{a-\lambda_p}.
\]

机器结论为：

\[
\boxed{
C_{p,q}
=(a-\lambda_p)(a-\lambda_q)(c_p-c_q),
}
\]

以及：

\[
\boxed{
C_{p,q}=0
\iff
c_p=c_q.
}
\]

## 1.2 residual 控制曲率

写：

\[
\lambda_p=1+r_p,
\qquad
b_p=r_pv_p.
\]

`StableResidualSwapCurvatureBound` 已证明：

\[
\boxed{
\begin{aligned}
C^{\mathrm{st}}_{p,q}
={}&
(a-1)(r_pv_p-r_qv_q)
\\
&+r_pr_q(v_q-v_p).
\end{aligned}
}
\]

在 \(\|v_p\|,\|v_q\|\le1\) 下：

\[
\boxed{
\|C^{\mathrm{st}}_{p,q}\|
\le
\|a-1\|\bigl(\|r_p\|+\|r_q\|\bigr)
+2\|r_p\|\|r_q\|.
}
\]

若 \(\|r_p\|,\|r_q\|\le\varepsilon\)，则：

\[
\boxed{
\|C^{\mathrm{st}}_{p,q}\|
\le
2\|a-1\|\varepsilon+2\varepsilon^2.
}
\]

## 1.3 有限 holonomy 能量

对有限活动通道集 \(P\)，定义：

\[
\mathcal E_P^{\mathrm{hol}}
=
\sum_{p\in P}\sum_{q\in P}
\|C_{p,q}\|^2.
\]

`FiniteHolonomyEnergy` 已证明：

\[
\mathcal E_P^{\mathrm{hol}}\ge0,
\]

\[
\mathcal E_P^{\mathrm{hol}}=0
\iff
C_{p,q}=0
\quad\forall p,q\in P,
\]

以及在 \(|P|=M\) 和共同 residual envelope 下：

\[
\boxed{
\mathcal E_P^{\mathrm{hol}}
\le
M^2
\left(
2\|a-1\|\varepsilon+2\varepsilon^2
\right)^2.
}
\]

这使 prime-side 最短链条成为：

\[
\boxed{
\text{uniform residual decay}
\Longrightarrow
\text{pairwise curvature decay}
\Longrightarrow
\text{finite holonomy energy decay}.
}
\]

---

# 2. Fourier 色散已经产生谱时间

`PrimeFrequencyPhaseFlow` 定义：

\[
\boxed{
\chi_\omega(t)=e^{-it\omega}.
}
\]

机器结论包括：

\[
\chi_\omega(0)=1,
\]

\[
\chi_\omega(t+u)
=
\chi_\omega(t)\chi_\omega(u),
\]

\[
\chi_{\omega+\nu}(t)
=
\chi_\omega(t)\chi_\nu(t),
\]

\[
|\chi_\omega(t)|=1.
\]

在 zeta prime channel 中：

\[
p^{-s}
=
p^{-\sigma}e^{-it\log p},
\qquad
s=\sigma+it.
\]

所以：

\[
\boxed{
\omega_p=\log p
}
\]

是素数的自然 Fourier 频率，\(t=\operatorname{Im}s\) 是其对偶参数。

有限通道相位空间为：

\[
U(1)^P.
\]

每个通道在单位圆上旋转。标量相位乘积满足：

\[
\prod_{j=1}^n\chi_{\omega_j}(t)
=
\chi_{\sum_j\omega_j}(t).
\]

因此标量 Fourier 层仍然遗忘列表次序。谱时间已经存在，操作 chronology 尚未被标量层读取。

`PhaseTwistedStableSwapCurvature` 将 Fourier 相位乘到记忆通道：

\[
v_p(t)=\chi_{\omega_p}(t)v_p.
\]

由于相位模长为一，已有 residual 曲率界和有限能量上界对 \(t\) 一致成立。

---

# 3. Append 001. Time-Ordered Prime Memory Cocycle

**候选 GID：**

`D5/S3/Observer/AgencyHolonomy/TimeOrderedPrimeMemoryCocycle`

本节是本统一理论卷的第一次正式增补。

## 3.1 两种时间必须分开

一个 timed event 记为：

\[
e=(\lambda_e,b_e,\omega_e,t_e).
\]

其中：

- \(t_e\) 是 Fourier phase 的实参数；
- \(\omega_e\) 是频率，prime specialization 为 \(\log p\)；
- 事件在列表中的位置是操作次序；
- 列表次序不由 \(t_e\) 的数值自动决定。

因此当前系统至少具有两个不同坐标：

\[
\boxed{
\begin{aligned}
t &: \text{连续谱时间},\\
k &: \text{离散操作次序}.
\end{aligned}
}
\]

本轮形式化将二者耦合，但不把它们识别为同一个时间，也不假设事件列表已经按实数时间单调排序。

## 3.2 Fourier-timed 有效注入

定义：

\[
\boxed{
\beta_e
=
\chi_{\omega_e}(t_e)b_e.
}
\]

事件更新为：

\[
\boxed{
U_e(m,z)
=
\bigl(am+\beta_ez,\lambda_ez\bigr).
}
\]

机器节点证明时间平移：

\[
\boxed{
\beta_e(t_e+u)
=
\beta_e(t_e)\chi_{\omega_e}(u).
}
\]

这说明 Fourier 时间平移作用于每个局部注入。该作用仍然可逆，不产生时间箭头。

对于自然数地址 \(n\)，构造频率：

\[
\omega_n=\log n.
\]

节点证明对应有效注入正好使用已有 `logAddressPhase`。当地址是素数 \(p\) 时，这就是 \(e^{-it\log p}\) 通道。

## 3.3 标量 cocycle 与记忆 cocycle

对 chronology word：

\[
w=e_1e_2\cdots e_n,
\]

定义标量摘要：

\[
\boxed{
\Lambda(w)
=
\prod_{j=1}^n\lambda_{e_j}.
}
\]

定义记忆摘要的递推：

\[
M_a(\varnothing)=0,
\]

\[
\boxed{
M_a(e_1w)
=
a^{|w|}\beta_{e_1}
+M_a(w)\lambda_{e_1}.
}
\]

将递推展开得到纸面闭式：

\[
\boxed{
M_a(w)
=
\sum_{j=1}^n
 a^{n-j}\beta_{e_j}
 \prod_{k<j}\lambda_{e_k}.
}
\]

该闭式解释两个方向的运输：

1. 事件 \(e_j\) 之前出现的 scalar factors 通过 \(\prod_{k<j}\lambda_{e_k}\) 改变它接收到的 scalar input；
2. 事件 \(e_j\) 之后还剩余的记忆步骤通过 \(a^{n-j}\) 运输其注入。

所以同一批事件采用不同次序时，标量乘积相同，记忆权重一般不同。

## 3.4 精确 affine word action

候选 Lean 定理证明：

\[
\boxed{
U_w(m,z)
=
\left(
 a^{|w|}m+M_a(w)z,
 \Lambda(w)z
\right).
}
\]

这一步把“记忆保存历史”从解释转化成一个精确有限公式。

初始记忆 \(m\) 只经过统一稳定乘子 \(a^{|w|}\)。事件历史全部压缩进 \(M_a(w)\)。标量世界全部压缩进 \(\Lambda(w)\)。

## 3.5 拼接律是真正的 cocycle 结构

设先执行 prefix \(u\)，再执行 suffix \(v\)。候选 Lean 定理证明：

\[
\boxed{
\Lambda(uv)
=
\Lambda(u)\Lambda(v),
}
\]

\[
\boxed{
M_a(uv)
=
a^{|v|}M_a(u)
+M_a(v)\Lambda(u).
}
\]

完整演化满足：

\[
\boxed{
U_{uv}
=
U_v\circ U_u.
}
\]

因此 summary triple

\[
\bigl(|w|,\Lambda(w),M_a(w)\bigr)
\]

带有半直积型合成：

\[
\boxed{
(n,\Lambda,M)\star(m,\Gamma,N)
=
\left(
 n+m,
 \Lambda\Gamma,
 a^mM+N\Lambda
\right).
}
\]

这里第一个 word 先执行，第二个 word 后执行。

这就是目前最精确的“时间产生 holonomy”表述：连续 Fourier 时间旋转局部注入，离散 chronology 通过扭曲 cocycle 决定这些注入如何积累。

## 3.6 两事件交换恢复 prime curvature

对两个 timed events \(p,q\)，候选 Lean 定理证明：

\[
\Lambda(pq)=\Lambda(qp),
\]

并证明任意初始状态上的记忆差为：

\[
\boxed{
\pi_1U_{pq}(m,z)
-
\pi_1U_{qp}(m,z)
=
C_{p,q}^{\mathrm{time}}z,
}
\]

其中：

\[
\boxed{
C_{p,q}^{\mathrm{time}}
=
(a-\lambda_q)\beta_p
-
(a-\lambda_p)\beta_q.
}
\]

在 cocycle 层：

\[
\boxed{
M_a(pq)-M_a(qp)
=
C_{p,q}^{\mathrm{time}}.
}
\]

所以原有 `PrimeSwapCurvature` 不再只是一个局部代数差。它现在被识别为两个 chronology words 的精确 memory holonomy。

## 3.7 residual 与 phase-twisted 曲率的连接

对 residual event：

\[
\lambda_p=1+r_p,
\qquad
b_p=r_pv_p.
\]

允许两个事件拥有不同 Fourier 时间：

\[
t_p,\qquad t_q.
\]

候选 Lean 定理证明：

\[
\boxed{
M_a(pq)-M_a(qp)
=
C^{\mathrm{st}}
\left(
 a,r_p,r_q,
 \chi_{\omega_p}(t_p)v_p,
 \chi_{\omega_q}(t_q)v_q
\right).
}
\]

当：

\[
t_p=t_q=t,
\]

节点恢复已经冻结的 common-time phase-twisted curvature：

\[
\boxed{
M_a(pq)-M_a(qp)
=
C^{\mathrm{phase}}_{p,q}(t).
}
\]

这证明新节点严格扩展已有真源，没有重新定义一个平行 curvature。

---

# 4. 对“色散的次序产生时间”的校准

现在可以将直觉写成三层。

## 4.1 色散给频率差

prime channels 的频率为：

\[
\omega_p=\log p.
\]

两个通道之间的自然频率差为：

\[
\boxed{
\Delta\omega_{p,q}
=
\log p-\log q
=
\log\frac pq.
}
\]

## 4.2 Fourier 变换给对偶时间

相位：

\[
\chi_{\omega_p}(t)
=
e^{-it\omega_p}
\]

把频率与连续参数 \(t\) 配对。该参数具有加法群结构：

\[
\chi_\omega(t+u)
=
\chi_\omega(t)\chi_\omega(u).
\]

所以 Fourier 对偶已经给出严格的谱时间。

## 4.3 记忆让次序可观测

标量 phase product 和 scalar Euler product 都遗忘事件排序。时间参数本身也不会自动产生 chronology。

列表提升以后：

\[
e_1e_2\cdots e_n
\]

决定 affine update 的操作次序。扭曲 cocycle \(M_a(w)\) 使这个次序可见。

因此最精确的句子是：

\[
\boxed{
\text{色散产生频率差，Fourier 对偶产生谱时间，记忆 cocycle 使操作次序可观测。}
}
\]

时间不是由排序凭空创造。当前系统中：

- \(t\) 来自 Fourier duality；
- \(k\) 来自 event chronology；
- \(r\) 来自 extraction depth；
- 后续需要研究三者是否组成兼容的多参数 cocycle。

---

# 5. 与波、共振和能量聚合的关系

对单位相位 \(z_p\in U(1)\) 和权重 \(w_p\ge0\)，定义：

\[
W=\sum_pw_p,
\qquad
A=\sum_pw_pz_p.
\]

相位色散能量满足纸面恒等式：

\[
\boxed{
\sum_{p,q}w_pw_q|z_p-z_q|^2
=
2W^2-2|A|^2.
}
\]

所以：

\[
\boxed{
\text{色散缺陷能量下降}
\iff
\text{共同模态相干能量上升}.
}
\]

time-ordered memory cocycle 增加了另一个层次。即使单时刻相位相干，历史注入仍可能因 local factors 和 chronology 的运输方式不同而产生非零 holonomy。

因此完整压平需要同时处理：

\[
\boxed{
\begin{aligned}
\text{phase dispersion} &\to0,\\
\text{memory swap curvature} &\to0,\\
\text{residual envelope} &\to0.
\end{aligned}
}
\]

这三者不能在定义上相互替代。

---

# 6. 与 RH 的关系

RH 要排除：

\[
\rho
=
\frac12+\delta+i\gamma,
\qquad
\delta\ne0.
\]

仓库 zero side 已经把一个离线四点轨道写成：

\[
\boxed{
Q_{\operatorname{orb}(\rho)}
=
E_\rho^{\mathrm{even}}
-
E_\rho^{\mathrm{odd}},
}
\]

其中：

\[
E_\rho^{\mathrm{even}}\ge0,
\qquad
E_\rho^{\mathrm{odd}}\ge0.
\]

全部符号风险集中在 odd spectral channel。

本轮 time-ordered cocycle 给 prime side 一个更具体的候选输入：

\[
C_{r;p,q}(t_p,t_q)
=
(a-\lambda_q)\chi_{\omega_p}(t_p)b_p
-
(a-\lambda_p)\chi_{\omega_q}(t_q)b_q.
\]

可以由它构造 finite time-frequency holonomy energy：

\[
\boxed{
\mathcal V_{r,P,T}^{\mathrm{time}}
=
\sum_{p,q\in P}
\int_{\Delta_T}
\left\|
K_{p,q}(t_1,t_2)
C_{r;p,q}
\right\|^2
\,dt_2dt_1,
}
\]

其中：

\[
\Delta_T
=
\{(t_1,t_2):0<t_2<t_1<T\}
\]

是有序时间单纯形，\(K_{p,q}\) 是下一节登记的 Fourier slot-swap kernel。

真正连接 RH 仍需证明：

\[
\boxed{
\mathcal E^{\mathrm{odd}}_{\mathrm{off}}(L,N,T)
\le
A_{L,N,T}
\mathcal V_{r,P,T}^{\mathrm{time}}
+
R_{r,L,N,T},
}
\]

且：

\[
R_{r,L,N,T}\to0.
\]

若 extraction tower 再给出：

\[
\mathcal V_{r,P,T}^{\mathrm{time}}\to0,
\]

则离线 odd energy 必须消失。通过已冻结的内部曲率判据，才可进入 RH。

当前节点本身没有建立这个支配。

---

# 7. 下一真源. SecondMagnusSwapCurvature

下一节点不应再次定义列表 cocycle。它应建立连续 time-ordering 的二阶核。

对两个 prime-frequency channels：

\[
\chi_p(t)=e^{-it\omega_p},
\qquad
\chi_q(t)=e^{-it\omega_q},
\]

定义 fixed-slot swap kernel：

\[
\boxed{
K_{p,q}(t_1,t_2)
=
\chi_p(t_1)\chi_q(t_2)
-
\chi_q(t_1)\chi_p(t_2).
}
\]

令：

\[
\bar t=\frac{t_1+t_2}{2},
\qquad
\Delta t=t_1-t_2,
\]

\[
\bar\omega=\frac{\omega_p+\omega_q}{2},
\qquad
\Delta\omega=\omega_p-\omega_q.
\]

目标精确分解为：

\[
\boxed{
K_{p,q}(t_1,t_2)
=
-2i
 e^{-2i\bar t\bar\omega}
 \sin\left(
 \frac{\Delta t\,\Delta\omega}{2}
 \right).
}
\]

因此：

\[
\boxed{
|K_{p,q}(t_1,t_2)|^2
=
4\sin^2\left(
\frac{\Delta t\,\Delta\omega}{2}
\right).
}
\]

在小尺度下：

\[
|K_{p,q}|^2
\sim
(\Delta t)^2(\Delta\omega)^2.
\]

prime specialization 给出：

\[
\boxed{
|K_{p,q}|^2
\sim
(t_1-t_2)^2
\log^2\frac pq.
}
\]

随后定义连续生成元：

\[
H(t)
=
\sum_pA_p\chi_p(t).
\]

二阶 Magnus 项为：

\[
\boxed{
\Omega_2(T)
=
\frac12
\int_{0<t_2<t_1<T}
[H(t_1),H(t_2)]
\,dt_2dt_1.
}
\]

展开以后，每个 \((p,q)\) 对应：

\[
K_{p,q}(t_1,t_2)[A_p,A_q].
\]

该结构同时要求：

\[
\Delta t\ne0,
\qquad
\Delta\omega\ne0,
\qquad
[A_p,A_q]\ne0.
\]

任一因子为零，二阶 order defect 消失。

下一 Lean 节点应先形式化有限两通道代数核和范数恒等式，不应立即承担积分收敛或 prime-zero domination。

---

# 8. 后续任务账本

## 8.1 已闭合或候选闭合

\[
\begin{aligned}
&\text{prime swap curvature and gauge invariance},\\
&\text{residual curvature bound},\\
&\text{finite holonomy energy},\\
&\text{prime-frequency Fourier flow},\\
&\text{phase-twisted residual curvature},\\
&\text{time-ordered finite memory cocycle}.\
\end{aligned}
\]

## 8.2 下一批有限节点

1. `SecondMagnusSwapCurvature`
2. `ResonanceConditionedOriginDispersion`
3. `FinitePhaseCoherenceIdentity`
4. `ResidualEnvelopeFiniteWindowConvergence`
5. `FiniteOffLineOddEnergy`

## 8.3 当前 hard heart

\[
\boxed{
\texttt{PrimeArchimedeanHolonomyDomination}
}
\]

目标是把 independently constructed prime-side time-ordered holonomy energy 运输到 zero-side off-line odd energy，并明确记录：

\[
\text{prime cutoff error},
\quad
\text{time cutoff error},
\quad
\text{Galerkin error},
\quad
\text{Archimedean error},
\quad
\text{zero-tail error}.
\]

---

# 9. 本轮严格非主张

本轮不主张：

- event list 已按实数时间排序；
- Fourier 时间具有不可逆方向；
- extraction depth 等于物理时间；
- time-ordered exponential 已经构造；
- Magnus expansion 已经形式化；
- residual envelope 已经随抽取深度趋零；
- 无限 prime holonomy energy 已经存在；
- prime-side cocycle 已经支配 zero-side odd energy；
- 离线零点已经被排除；
- RH 已经证明。

本轮候选机器增量精确到：

\[
\boxed{
\text{Fourier-timed local events}
\longrightarrow
\text{finite affine word action}
\longrightarrow
\text{twisted append cocycle}
\longrightarrow
\text{two-event prime swap curvature}.
}
\]

最凝练的理论结论是：

\[
\boxed{
\text{Fourier 对偶给出谱时间，事件列表给出操作 chronology，记忆 cocycle 将二者耦合并保存顺序。}
}
\]

---

# 10. Append 002. Second-Magnus Swap Curvature

**候选 GID：**

`D5/S3/Observer/AgencyHolonomy/SecondMagnusSwapCurvature`

本增补建立在修复后的 `TimeOrderedPrimeMemoryCocycle` 上。原文件中的 Lean 变量 `prefix`、`suffix` 分别统一改为 `earlierWord`、`laterWord`。该改名只修复 source-bound 解析，不改变 cocycle 的定义、定理陈述或依赖图。两个节点在 PR admission 完成以前都仍是 candidate truth。

## 10.1 二阶核是时间槽与频率槽的交替行列式

继续使用：

\[
\chi_\omega(t)=e^{-it\omega}.
\]

定义：

\[
\boxed{
K_{p,q}(t_1,t_2)
=
\chi_{\omega_p}(t_1)\chi_{\omega_q}(t_2)
-
\chi_{\omega_q}(t_1)\chi_{\omega_p}(t_2).
}
\]

它是两个 evaluation vectors 的二阶外积系数，也可写为一个 \(2\times2\) 行列式。因此机器节点证明：

\[
\boxed{K_{q,p}=-K_{p,q}},
\qquad
\boxed{K_{p,q}(t_2,t_1)=-K_{p,q}(t_1,t_2)},
\]

\[
\boxed{t_1=t_2\Longrightarrow K_{p,q}=0},
\qquad
\boxed{\omega_p=\omega_q\Longrightarrow K_{p,q}=0},
\]

以及：

\[
\boxed{|K_{p,q}|\le2}.
\]

频率标签与时间槽同时交换时，两个负号抵消。由此，\(K\) 保存的是二维 orientation，不是单个相位的大小。

## 10.2 中心变量与相对变量完全分离

令：

\[
\bar\omega=\frac{\omega_p+\omega_q}{2},
\qquad
\delta\omega=\frac{\omega_p-\omega_q}{2}.
\]

节点证明中心分解：

\[
\boxed{
K_{p,q}
=
\chi_{\bar\omega}(t_1+t_2)
\left[
\chi_{\delta\omega}(t_1-t_2)
-
\chi_{-\delta\omega}(t_1-t_2)
\right].
}
\]

其正弦形式为：

\[
\boxed{
K_{p,q}
=
-2i e^{-i(t_1+t_2)(\omega_p+\omega_q)/2}
\sin\left(
\frac{(t_1-t_2)(\omega_p-\omega_q)}2
\right).
}
\]

共同中心相位模长恒为一。全部可观测二阶强度只依赖 time-frequency area：

\[
\mathfrak a_{p,q}
=(t_1-t_2)(\omega_p-\omega_q).
\]

所以二阶破缺需要时间分离与频率分离同时存在。即使两者都非零，仍有共振消零：

\[
\boxed{
\mathfrak a_{p,q}\in2\pi\mathbb Z
\Longrightarrow K_{p,q}=0.
}
\]

这说明点态二阶核不是 holonomy 的 faithful 探针。

## 10.3 有限二阶 Magnus 能量

对有限通道集 \(P\) 与已有交换曲率 \(C_{p,q}\)，定义：

\[
\boxed{
\mathcal E^{(2)}_{P}(t_1,t_2)
=
\sum_{p,q\in P}
\left|K_{p,q}(t_1,t_2)C_{p,q}\right|^2.
}
\]

机器节点证明：

\[
\boxed{
0\le\mathcal E^{(2)}_{P}(t_1,t_2)
\le4\mathcal E^{\mathrm{hol}}_{P}.
}
\]

再与已冻结的 stable residual holonomy bound 组合，得到：

\[
\mathcal E^{(2)}_{P}(t_1,t_2)
\le
4|P|^2
\left(
2\lVert a-1\rVert\varepsilon+2\varepsilon^2
\right)^2,
\]

并证明 \(\varepsilon=0\) 时二阶能量为零。因此新增严格链为：

\[
\boxed{
\text{residual envelope decay}
\Longrightarrow
\text{finite holonomy energy decay}
\Longrightarrow
\text{finite second-Magnus energy decay}.
}
\]

该链严格单向。共振格可以使 \(K_{p,q}C_{p,q}=0\)，同时允许 \(C_{p,q}\ne0\)。因此当前节点不能从二阶能量小反推出 holonomy 小。

## 10.4 为什么它对应真正的二阶 Magnus 系数

令有限生成元为：

\[
H(t)=\sum_{p\in P}\chi_{\omega_p}(t)A_p.
\]

则交换子展开为：

\[
[H(t_1),H(t_2)]
=
\sum_{p,q\in P}
K_{p,q}(t_1,t_2)[A_p,A_q].
\]

所以 \(K_{p,q}\) 是连续 time-ordering 的纯 Fourier slot coefficient，\(C_{p,q}\) 是离散记忆更新的非交换系数。二者乘积把两种破缺分层记账：

\[
\boxed{
K_{p,q}:\text{time-frequency orientation defect},
\qquad
C_{p,q}:\text{memory-channel holonomy defect}.
}
\]

本节点只形式化有限代数核及其能量支配，尚未形式化 ordered-simplex integral、Magnus series 收敛或无限 prime 极限。

## 10.5 黄金、素数频率、色散与拓扑的精确关系

当前路线里有两个已冻结但尚未同一化的黄金位置。

第一，黄金记忆稳定特征值：

\[
a=-\varphi^{-1}.
\]

它进入 \(C_{p,q}\)，控制历史注入的收缩和运输。

第二，黄金尺度圆的基本频率：

\[
\Omega_\varphi=\frac{\pi}{\log\varphi},
\qquad
\omega_k=k\Omega_\varphi.
\]

将黄金 Fourier modes 代入新核可得：

\[
K_{k,\ell}(t_1,t_2)
=
-2i e^{-i(t_1+t_2)(k+\ell)\Omega_\varphi/2}
\sin\left(
\frac{(t_1-t_2)(k-\ell)\pi}{2\log\varphi}
\right).
\]

而 zeta 的 prime frequencies 是：

\[
\omega_p=\log p.
\]

仓库当前没有证明 \(\log p\in\Omega_\varphi\mathbb Z\)，该关系通常也不成立。黄金 Fourier lattice 与 prime log-frequency set 是两套坐标。后续需要明确的 sampling、projection、aliasing 或 Poisson 型运输定理，才能把它们接入同一 RH 桥梁。

拓扑层面，定义：

\[
v_{p,q}(t)=
\bigl(\chi_{\omega_p}(t),\chi_{\omega_q}(t)\bigr)\in\mathbb C^2.
\]

则：

\[
K_{p,q}(t_1,t_2)
=
v_{p,q}(t_1)\wedge v_{p,q}(t_2)
\in\Lambda^2\mathbb C^2.
\]

\(K=0\) 是 evaluation map 的 rank-drop locus，\(K\ne0\) 表示两个时间切片张成有向二维单元。当前只获得 exterior-algebra 与 rank-locus 结构。尚未构造 coboundary、cohomology class、Chern class 或全局 bundle invariant。

## 10.6 对 RH 路线的下一步校准

点态上界只能证明 residual 衰减足以压低二阶能量。要把二阶能量变成可识别的 holonomy 探针，下一真源应消除孤立共振零点。对 \(\Delta\omega\ne0\)，有序时间单纯形平均的纸面候选为：

\[
\mathcal A_T(\Delta\omega)
=
\int_{0<t_2<t_1<T}|K_{p,q}(t_1,t_2)|^2\,dt_2dt_1
=
T^2-
\frac{2\bigl(1-\cos(T\Delta\omega)\bigr)}{(\Delta\omega)^2}.
\]

对固定非零 \(\Delta\omega\)，其归一化满足：

\[
\frac{\mathcal A_T(\Delta\omega)}{T^2}\longrightarrow1.
\]

有限 prime cutoff 下，若最小 log-frequency gap 为正，便可寻求统一 frame lower bound。建议下一 GID 为：

`D5/S3/Observer/AgencyHolonomy/OrderedTimeSimplexSecondMagnusAverage`

它应先证明积分恒等式、非负性、非零频率差下的正性，以及依赖 finite gap 的加权下界。完成后，路线才可能从单向 domination 升级为 resonance-controlled observability。

## 10.7 严格非主张

本增补不主张：黄金 Fourier modes 已与 prime log frequencies 同一化；点态二阶能量 faithfully 恢复 holonomy；有序时间积分已经形式化；Magnus series 已收敛；二阶核已给出全局拓扑不变量；prime-side 能量已支配 zero-side odd energy；离线零点已排除；RH 已证明。

---

## [PR #4372] RH_RESEARCH_LANE_THEORY — Reflected Growth Pair Second-Order Spectrum

# RH_RESEARCH_LANE_THEORY

## 累积式 RH 研究真理卷

本文件是 `trureturing` 中 RH 研究路线唯一的累积理论文档。后续理论进展只在本文件中追加、修订和标注状态，不再为每个研究波次创建新的 `docs/develop/theory/*THEORY.md` 文档。每个独立 Lean 节点仍可保留仓库要求的 `Blueprint` Scribe 真源与确定性 Markdown 投影。

当前追加基线：`dev` 提交 `6aef3e41d2365d365fd3de24f44f4ba2a8779f96`。

本卷不是 RH 证明声明。它用于区分已经机器闭合的事实、定义性重写、候选桥梁、开放义务、误差预算和目标泄漏风险。

---

## 0. 状态语言

本卷统一使用以下状态：

- **Frozen**：已经存在于 `dev` 的 Lean proof term。
- **Candidate**：当前 PR 中已经给出 Lean 形式化，尚待仓库 admission 或合并。
- **Derived**：可以由 Frozen/Candidate 定理直接推出，但尚未拥有独立 Lean 名称。
- **Bridge target**：连接两个已经形式化对象所需的精确新定理。
- **Open**：当前没有证明，不得作为后续定理的无标注前提。
- **Consumer from RH**：以 RH 或 RH 等价性质为前提，只能用于后果分析，不能作为朝向 RH 的证明边。

RH 路线中的每一个承重命题都应记录：

1. 输入对象来自哪里；
2. 是否使用 RH 或已知等价命题；
3. 结论方向；
4. 有限证书及其严格裕量；
5. 截断、尾项和运输误差；
6. 第一条尚未闭合的边。

---

## 1. 研究主架构

当前 RH 研究被拆成三类彼此独立的桥。

### 1.1 反例检测桥

目标是证明：

\[
\neg\mathrm{RH}
\Longrightarrow
\exists\text{ finite certified negative witness}.
\]

候选观察图表包括：

- Cayley/Li 矩；
- Toeplitz 最小特征值；
- Pick negative square；
- normal jet；
- signed normal support；
- Chebyshev 负支撑分离器；
- Weil 紧支撑测试函数。

检测桥只说明离线零点最终可见。它不解释素数侧为何排除该离线零点。

### 1.2 算术强制桥

目标是从素数、Gamma、pole、边界项和窗口几何推出全部有限观察层非负。当前最精确的开放形式包括：

\[
\texttt{BalancedPrimePickInnovationLowerBound}
\]

和：

\[
\texttt{PrimeArchimedeanBlindSchurCoercivity}.
\]

这部分是目前最主要的 RH 承重开放边。

### 1.3 完成与全局化桥

目标是证明一致的有限正完成在统一预算和紧性条件下产生一个全局正谱对象。必须区分：

- 每个固定深度可行；
- 跨深度兼容；
- 统一 resolvent 预算；
- weighted weak-* 紧性；
- 全局正完成；
- 原子支撑与真实零点的进一步识别。

有限层逐层可行本身不足以推出全局对象。

---

## 2. 负性、负平方与负时间的强类型区分

“负”不是单一对象。它总是相对于某个正锥、允许支撑、二次型、稳定半平面或时间定向定义。

必须区分：

1. 负标量：\(a<0\)。
2. 负质量：signed measure 的某个权重为负。
3. 负支撑：正质量位于禁止区域，例如 \(x<0\)。
4. 负方向：存在 \(v\ne0\) 使 \(Q(v)<0\)。
5. negative square：有限 Hermitian Gram 矩阵拥有一个独立负方向。
6. 负指数：最大负定子空间的维数。
7. 负频率：Fourier 相位的反向绕行。
8. 负时间：相对于选定时间锥的反向参数、逆动力学或历史完成。

这些对象之间可以存在运输定理，不能直接互换。

### 2.1 正锥分离定义

设允许对象形成锥 \(C\)。如果对偶观察器 \(\ell\) 满足：

\[
\ell(c)\ge0\qquad(c\in C),
\]

而：

\[
\ell(x)<0,
\]

则 \(\ell\) 是对象 \(x\) 越过正锥边界的负性证书。

因此有限 RH 反例证书的最终形式应是：

\[
\boxed{
\ell\in C^\vee,
\qquad
\ell(X_\zeta)<-\eta,
\qquad
\eta>0.
}
\]

严格正裕量 \(\eta\) 用于吸收尾项和数值误差。

---

## 3. Frozen：反射增长对与负平方有符号行列式

当前 `dev` 的真源：

```text
D5/S3/Analytic/Adelic/ReflectedGrowthPairNegativeSquare.lean
```

定义反射增长对：

\[
G_\delta(t)
=
\left(e^{\delta t},e^{-\delta t}\right).
\]

已经机器证明：

\[
G_\delta(-t)=\operatorname{swap}G_\delta(t),
\]

\[
e^{\delta t}e^{-\delta t}=1,
\]

以及生成率对 \((\delta,-\delta)\) 满足：

\[
\operatorname{tr}=0,
\qquad
\det=-\delta^2.
\]

这里的 \(-\delta^2\) 是反射生成元的**有符号行列式**。它不是二次多项式的标准判别式。特征多项式为：

\[
(r-\delta)(r+\delta)=r^2-\delta^2,
\]

而标准判别式为：

\[
4\delta^2.
\]

所以：

\[
\boxed{
\text{signed determinant}=-\delta^2,
\qquad
\text{polynomial discriminant}=4\delta^2.
}
\]

函数方程型反射消除了线性方向标签，二阶平方大小仍然保留。

---

## 4. Candidate append 2026-08-31：反射增长对的二阶负谱

当前候选真源：

```text
D5/S3/Analytic/Adelic/ReflectedGrowthPairSecondOrderSpectrum.lean
```

该节点只依赖已经冻结的 `ReflectedGrowthPairNegativeSquare` 和 Mathlib 的实指数 iterated derivative 定理。

### 4.1 两条径向分支

定义：

\[
g_+(t)=e^{\delta t},
\qquad
g_-(t)=e^{-\delta t}.
\]

对任意 \(n\ge0\)：

\[
\frac{d^n}{dt^n}g_+(t)
=
\delta^n g_+(t),
\]

\[
\frac{d^n}{dt^n}g_-(t)
=
(-\delta)^n g_-(t).
\]

特别地：

\[
g_+''(t)=\delta^2g_+(t),
\qquad
g_-''(t)=\delta^2g_-(t).
\]

定义负二阶观察器：

\[
\mathcal L=-\frac{d^2}{dt^2}.
\]

于是：

\[
\boxed{
\mathcal Lg_+(t)=-\delta^2g_+(t),
\qquad
\mathcal Lg_-(t)=-\delta^2g_-(t).
}
\]

结合上一真源：

\[
\operatorname{reflectionPairSignedDeterminant}(\delta)
=-\delta^2,
\]

得到精确 observer agreement：

\[
\boxed{
\text{反射生成元的有符号行列式}
=
\text{负二阶算子的谱值}.
}
\]

这不是类比，而是同一个标量 \(-\delta^2\) 在有限生成元图表和微分算子图表中的完全相同读数。

### 4.2 分支遗忘后的对称读出

定义：

\[
S_\delta(t)
=
g_+(t)+g_-(t)
=
e^{\delta t}+e^{-\delta t}.
\]

该函数已经在前一真源中证明为偶函数。本轮进一步得到：

\[
S_\delta''(t)=\delta^2S_\delta(t),
\]

因此：

\[
\mathcal LS_\delta(t)
=-\delta^2S_\delta(t).
\]

对称观察没有删除负二阶谱值。它只删除了哪一支是增长、哪一支是衰减的方向标签。

### 4.3 一阶盲性与二阶可见性

在反射中心 \(t=0\)：

\[
S_\delta'(0)=0,
\]

而：

\[
\boxed{
S_\delta''(0)=2\delta^2.
}
\]

若 \(\delta\ne0\)，则：

\[
S_\delta''(0)>0.
\]

所以：

\[
\boxed{
\text{对称性压平一阶方向，二阶曲率仍严格检测分裂大小。}
}
\]

这个结论解释了为什么 normal observer 中奇数法向层容易因函数方程对称而消失，而偶数层仍然可能携带离线信息。

### 4.4 当前命题边界

本节点没有证明：

- 参数 \(t\) 是物理时间；
- completed zeta 已经实现为上述二分支系统；
- 任意离线零点已被有限测试函数隔离；
- 二阶局部信号能够压过其他零点、Gamma 因子或截断尾项；
- 负二阶谱值已经产生 Weil、Pick 或 Toeplitz 负方向；
- RH 或其否定。

它关闭的是一个纯表示桥：

\[
\boxed{
\text{reflected split}
\longrightarrow
\text{signed determinant }-\delta^2
\longrightarrow
\text{negative second-order spectral value}.
}
\]

---

## 5. 与 completed-xi normal jet 的关系

当前 `dev` 的 `NormalJetFormula` 已经从真实 completed-xi normal intensity：

\[
I(\delta,t)
=
\left|
\xi\left(\frac12+\delta+it\right)
\right|^2
\]

构造偶阶 Taylor 系数，并机器证明前若干 normal jet 的导数公式。

本轮二阶真源说明了一个局部模型：反射增长率 \(\pm\delta\) 的方向信息在对称和中消失，而平方大小 \(\delta^2\) 在二阶读出中出现。

仍缺少的精确桥是：

\[
\boxed{
\texttt{OffLineCurvatureModeIntertwiner}
}
\]

它应把 phase-flattened reflected zero mode 的二阶对数曲率与已有离线曲率 dipole：

\[
K_{\delta,\gamma}(t)
=
2\frac{(t-\gamma)^2-\delta^2}
{((t-\gamma)^2+\delta^2)^2}
\]

严格连接起来。

在该桥建立以前，以下关系只能标记为结构一致：

- 有符号行列式包含 \(-\delta^2\)；
- 负二阶谱值为 \(-\delta^2\)；
- curvature dipole 的负核心由 \((t-\gamma)^2-\delta^2<0\) 控制；
- signed normal support 候选位置为 \(-\delta^2\)。

---

## 6. 新的结构推论

### 6.1 双曲模式与圆周模式的分界

对二阶算子 \(-D^2\)：

- 振荡模式 \(e^{i\gamma t}\) 的谱值是 \(+\gamma^2\)；
- 反射增长模式 \(e^{\pm\delta t}\) 的谱值是 \(-\delta^2\)。

因此正平方和负平方分别对应：

\[
\boxed{
+\gamma^2
\leftrightarrow
\text{elliptic / oscillatory sector},
}
\]

\[
\boxed{
-\delta^2
\leftrightarrow
\text{hyperbolic / growth-decay sector}.
}
\]

在 RH 的局部模式语言中，临界线对应纯相位旋转。离线位移引入互反的增长与衰减分支。

### 6.2 二阶读出不恢复方向

\(S_\delta''(0)=2\delta^2\) 可以恢复分裂大小，但不能区分 \(\delta\) 和 \(-\delta\)。

因此观察语言分层为：

\[
(\delta,\gamma)
\longrightarrow
\delta
\longrightarrow
\delta^2.
\]

- 完整复模式保存径向方向和频率方向；
- 相位压平保存径向方向；
- 对称二阶观察只保存径向分裂大小。

若后续任务需要恢复时间定向或分支方向，必须增加奇通道，例如：

\[
O_\delta(t)
=
\frac{e^{\delta t}-e^{-\delta t}}2.
\]

### 6.3 负平方是稳定化债务

对候选负支撑位置：

\[
x=-\delta^2,
\]

Laplace 时间因子为：

\[
e^{-xt}=e^{\delta^2t}.
\]

要使：

\[
e^{-ut}e^{-xt}
=
e^{-(u-\delta^2)t}
\]

在正半轴可积，需要：

\[
\boxed{u>\delta^2.}
\]

因此可以定义候选稳定化债务：

\[
\operatorname{StabilizationDebt}(-\delta^2)=\delta^2.
\]

这一结论的积分、可积性当且仅当条件和 resolvent 极点仍需独立 Lean 真源。

---

## 7. 下一承重形式化方向

### P0. NegativeSquareLaplaceResolvent

在精确条件 \(u>\delta^2\) 下证明：

\[
\int_0^\infty e^{-(u-\delta^2)t}\,dt
=
\frac1{u-\delta^2}.
\]

并证明可积性阈值：

\[
\operatorname{IntegrableOn}
\left(e^{-(u-\delta^2)t},[0,\infty)\right)
\iff
u>\delta^2.
\]

该节点把负二阶谱值连接到前向增长、附加阻尼预算和 resolvent 极点。

### P1. ReflectedGrowthPairEvenOddObservation

定义偶通道和奇通道：

\[
E_\delta(t)
=
\frac{e^{\delta t}+e^{-\delta t}}2,
\qquad
O_\delta(t)
=
\frac{e^{\delta t}-e^{-\delta t}}2.
\]

目标：

\[
E_\delta(-t)=E_\delta(t),
\qquad
O_\delta(-t)=-O_\delta(t),
\]

\[
E_\delta(t)^2-O_\delta(t)^2=1.
\]

偶通道保存反射不变量。奇通道保存定向。

### P2. OffLineCurvatureModeIntertwiner

把反射模式的二阶对数曲率精确运输到离线 dipole 公式。该节点应明确：

- 目标轨道贡献；
- 其他零点污染；
- Gamma 与 pole 项；
- 正翼和负核心；
- 截断误差；
- 剩余严格负裕量。

### P3. SignedNormalSpectralAtom

构造一个真正的 signed-normal support chart，使临界线轨道落在允许支撑：

\[
[0,\infty),
\]

离线反射轨道产生正质量的负支撑位置：

\[
-\delta^2<0.
\]

随后用 Chebyshev 多项式或 rational separator 将负支撑运输成有限矩和 Gram 负方向。

---

## 8. 当前 theorem DAG

```text
ReflectedGrowthPairNegativeSquare                 Frozen
        |
        v
ReflectedGrowthPairSecondOrderSpectrum            Candidate
        |
        +-----------------------------+
        |                             |
        v                             v
Even/Odd Observation               NegativeSquareLaplaceResolvent
        |                             |
        v                             v
Orientation Recovery               Stabilization Debt / Resolvent Pole
        |                             |
        +---------------+-------------+
                        |
                        v
              OffLineCurvatureModeIntertwiner
                        |
                        v
                SignedNormalSpectralAtom
                        |
                        v
             Chebyshev Negative-Support Witness
                        |
                        v
             Toeplitz / Pick / Weil Negative Direction
```

并行的算术强制链仍为：

```text
Prime / Gamma / Pole data
        |
        v
Balanced finite observer innovation
        |
        v
Blind-sector Schur coercivity
        |
        v
All finite Gram layers nonnegative
        |
        v
Uniform positive completion
        |
        v
Weil positivity
        |
        v
RH
```

检测链和强制链最终需要在同一个有限 master observer 上相遇。

---

## 9. 当前第一开放边

就负平方与时间方向这一子路线而言，下一条最小且无条件的真源是：

\[
\boxed{
\texttt{NegativeSquareLaplaceResolvent}.
}
\]

就整个 RH 路线而言，第一承重开放边仍然不是上述表示恒等式，而是：

\[
\boxed{
\texttt{PrimeArchimedeanBlindSchurCoercivity}
}
\]

或等价的逐层素数侧创新下界。前者负责说明离线缺陷怎样产生有限负证书。后者负责说明真实算术数据为什么不允许该负证书存在。
---

## [PR #4441] GOLDEN_SECOND_MAGNUS_SAMPLING

# 黄金二阶 Magnus 采样、时间色散与壳层商拓扑

**候选 GID：**

`D5/S3/Observer/GoldenPrimeCircle/GoldenSecondMagnusSampling`

## 0. 本增补的地位

本增补把此前已经分别冻结的三层结构连接起来：

1. `GoldenScaleCircle` 给出黄金对数尺度与整壳平移；
2. `GoldenVerticalSampling` 给出黄金 Fourier 模式对应的 Mellin 竖直频率；
3. `SecondMagnusSwapCurvature` 给出时间槽与频率槽的交替二阶核。

本轮不重新定义 Fourier character，也不重新定义二阶 Magnus 核。新增节点只负责证明既有对象在黄金采样格上的兼容性，以及这些对象对完整黄金壳层平移的下降性质。

机器真源进入 admission 以前，本节全部标记为 candidate append。PR 通过 canonical Lean report、Scribe 一致性和 content-addressed admission 后，才可把相应陈述视为冻结真源。

---

## 1. 黄金对数周期与 Mellin 采样时间

已有黄金尺度周期为：

\[
\boxed{
L_\varphi=2\log\varphi.
}
\]

已有黄金基本角频率为：

\[
\boxed{
\Omega_\varphi
=\frac{\pi}{\log\varphi}
=\frac{2\pi}{L_\varphi}.
}
\]

本轮定义第 \(k\) 个整数黄金采样时间：

\[
\boxed{
t_k=k\Omega_\varphi,
\qquad k\in\mathbb Z.
}
\]

因此：

\[
\boxed{
t_kL_\varphi=2\pi k.}
\]

这个恒等式是壳层不可见性的核心。一个完整黄金壳层在对数尺度上前进 \(L_\varphi\)，整数采样模式只积累 \(2\pi k\) 的整圈相位。

这里的 \(t_k\) 是 Mellin 竖直参数的离散采样值，也就是 prime-frequency Fourier flow 的谱时间。它没有被解释为实验室物理时间。

---

## 2. 从正乘法群下降到黄金尺度圆

继续使用未取商坐标：

\[
\eta_\varphi(x)
=\frac{\log x}{L_\varphi}.
\]

对正数 \(x,y\)，已有：

\[
\eta_\varphi(xy)
=\eta_\varphi(x)+\eta_\varphi(y).
\]

本轮把它投影到单位加法圆：

\[
\boxed{
\vartheta_\varphi(x)
=\eta_\varphi(x)\pmod{\mathbb Z}
\in\mathbb R/\mathbb Z.
}
\]

机器证明：

\[
\boxed{
\vartheta_\varphi(xy)
=\vartheta_\varphi(x)+\vartheta_\varphi(y),
\qquad x,y>0.
}
\]

对任意 \(n\in\mathbb N\)，已有未取商平移律：

\[
\eta_\varphi\bigl((\varphi^2)^n x\bigr)
=\eta_\varphi(x)+n.
\]

因此机器证明：

\[
\boxed{
\vartheta_\varphi\bigl((\varphi^2)^n x\bigr)
=\vartheta_\varphi(x).
}
\]

这给出严格的商拓扑对象：

\[
\boxed{
\mathbb R_{>0}^{\times}/\varphi^{2\mathbb Z}
\longrightarrow
\mathbb R/\mathbb Z.
}
\]

本轮 Lean owner 使用自然数壳层平移，因为现有 `GoldenScaleCircle` 的公开迭代定理以 \(n\in\mathbb N\) 陈述。双向整数壳层作用和其商空间同胚仍可在后续节点中单独封装。

---

## 3. 黄金尺度 character 与既有 Fourier phase 是同一个对象

定义整数模式的黄金尺度 character：

\[
\boxed{
\Theta_k(x)
=
\exp\left(-2\pi i k\eta_\varphi(x)\right).
}
\]

它也可以理解为单位圆点 \(\vartheta_\varphi(x)\) 上的第 \(k\) 个 character。

本轮机器证明：

\[
\boxed{
\Theta_k(x)
=
\chi_{\log x}(t_k)
=
\exp(-it_k\log x).
}
\]

这条等式把两套已经存在的坐标精确识别：

\[
\boxed{
\text{黄金尺度圆的整数 Fourier mode}
=
\text{log-frequency flow 的黄金 Mellin 采样}.
}
\]

因此新增节点没有引入第二套相位语义。`goldenScaleFourierPhase` 是既有 `fourierPhase` 的黄金坐标表达。

机器同时证明：

\[
\boxed{|\Theta_k(x)|=1},
\]

以及对正数 \(x,y\)：

\[
\boxed{
\Theta_k(xy)=\Theta_k(x)\Theta_k(y).
}
\]

所以每个整数模式都是正乘法群到 \(U(1)\) 的酉 character。

---

## 4. 完整黄金壳层对整数模式不可见

由：

\[
\eta_\varphi\bigl((\varphi^2)^n x\bigr)
=\eta_\varphi(x)+n,
\]

得到：

\[
\Theta_k\bigl((\varphi^2)^n x\bigr)
=
\Theta_k(x)e^{-2\pi i kn}.
\]

因为 \(k\in\mathbb Z\) 且 \(n\in\mathbb N\)：

\[
e^{-2\pi i kn}=1.
\]

机器证明：

\[
\boxed{
\Theta_k\bigl((\varphi^2)^n x\bigr)
=
\Theta_k(x).
}
\]

这不是近似周期，也不是渐近自相似，而是精确下降关系。

因此整数黄金 Fourier family 只能看到壳层轨道：

\[
[x]
=
\left\{(\varphi^2)^n x:n\in\mathbb N\right\}.
\]

未取商尺度中的整壳编号被该观察器遗忘。这个遗忘正是 topology quotient 的含义，不应描述为信号在真实空间中消失。

---

## 5. 黄金采样把二阶 Magnus 核变成 character alternant

既有二阶核为：

\[
K_{x,y}(t_1,t_2)
=
\chi_{\log x}(t_1)\chi_{\log y}(t_2)
-
\chi_{\log y}(t_1)\chi_{\log x}(t_2).
\]

在两个黄金采样时间 \(t_{k_1},t_{k_2}\) 上，本轮机器证明：

\[
\boxed{
\begin{aligned}
K_{x,y}(t_{k_1},t_{k_2})
={}&
\Theta_{k_1}(x)\Theta_{k_2}(y)
\\
&-
\Theta_{k_1}(y)\Theta_{k_2}(x).
\end{aligned}
}
\]

所以该核是两个黄金 circle characters 的交替行列式：

\[
\boxed{
K_{x,y}(t_{k_1},t_{k_2})
=
\det
\begin{pmatrix}
\Theta_{k_1}(x)&\Theta_{k_1}(y)\\
\Theta_{k_2}(x)&\Theta_{k_2}(y)
\end{pmatrix}.
}
\]

这个表达把时间、色散和 topology 的职责分开：

- \(k_1,k_2\) 选择黄金尺度圆上的两个 character readouts；
- \(x,y\) 选择两个乘法尺度通道；
- 行列式读取两个 readout vectors 张成的有向面积；
- 交换通道或交换时间槽会翻转 orientation；
- 两行或两列退化时，二阶核归零。

该行列式解释沿用 `SecondMagnusSwapCurvature` 已经冻结的反对称结构。本轮只证明它在黄金采样格上的精确 realization。

---

## 6. 二阶核下降到壳层轨道

对任意自然姴壳层编号 \(n_x,n_y\)，本轮机器证明：

\[
\boxed{
\begin{aligned}
&K_{(\varphi^2)^{n_x}x,
      (\varphi^2)^{n_y}y}
  (t_{k_1},t_{k_2})
\\
&\qquad=
K_{x,y}(t_{k_1},t_{k_2}),
\qquad x,y>0.
\end{aligned}
}
\]

两个通道可以独立移动任意完整黄金壳层。相位矩阵的四个条目分别保持，因此 determinant 保持。

所以在黄金采样格上，二阶 Magnus 核通过以下商对象因子化：

\[
\boxed{
\left(
\mathbb R_{>0}^{\times}/\varphi^{2\mathbb Z}
\right)^2.
}
\]

这里形成的 topology 结论是 factorization through quotient。它不是 winding number、Chern class 或非平凡 line bundle 的存在定理。

---

## 7. 有限二阶 Magnus 能量也下降到壳层商

设有限通道类型为 \(P\)，每个通道具有正尺度 \(s_p\)、壳层编号 \(n_p\) 和既有曲率系数 \(C_{p,q}\)。定义黄金采样能量：

\[
\mathcal E^{(2),\varphi}_{P;k_1,k_2}(s,C)
=
\sum_{p,q\in P}
\left|
K_{s_p,s_q}(t_{k_1},t_{k_2})C_{p,q}
\right|^2.
\]

本轮机器证明：

\[
\boxed{
\mathcal E^{(2),\varphi}_{P;k_1,k_2}
\left(
\bigl((\varphi^2)^{n_p}s_p\bigr)_{p\in P},C
\right)
=
\mathcal E^{(2),\varphi}_{P;k_1,k_2}(s,C).
}
\]

因此该有限能量只依赖每个通道的黄金壳层轨道，不依赖所选代表元。

结合已经冻结的统一上界：

\[
0\le
\mathcal E^{(2)}_P(t_1,t_2)
\le
4\mathcal E^{\mathrm{hol}}_P,
\]

可以得到以下严格结构链：

\[
\boxed{
\begin{aligned}
&\text{residual envelope control}
\\
&\Longrightarrow
\text{finite holonomy energy control}
\\
&\Longrightarrow
\text{golden-sampled second-Magnus energy control}
\\
&\Longrightarrow
\text{the controlled observable descends through golden shell orbits}.
\end{aligned}
}
\]

最后一箭头描述观察空间的商结构，不增加新的衰减率。

---

## 8. 时间、色散、破缺与 topology 的当前严格关系

本轮以后，这五个概念可以按类型分层：

\[
\boxed{
\begin{array}{c|c}
\text{对象}&\text{机器中的角色}\\
\hline
L_\varphi&\text{黄金对数壳层周期}\\
t_k&\text{整数 Fourier mode 的 Mellin 谱时间}\\
\log x-\log y&\text{两个乘法通道的频率色散}\\
K&\text{时间槽与频率槽的反对称二阶响应}\\
\mathbb R_{>0}^{\times}/\varphi^{2\mathbb Z}
&\text{整数黄金模式可见的尺度商空间}
\end{array}
}
\]

色散本身是频率差：

\[
\Delta\omega_{x,y}
=\log x-\log y
=\log\frac{x}{y},
\qquad x,y>0.
\]

时间差与色散差共同进入已有正弦核：

\[
\left|K_{x,y}(t_{k_1},t_{k_2})\right|
=
2\left|
\sin\left(
\frac{(t_{k_1}-t_{k_2})(\log x-\log y)}2
\right)
\right|.
\]

因此反对称破缺的可见性需要：

1. 两个采样模式可区分；
2. 两个尺度通道可区分；
3. 对应 time-frequency area 不落在共振零点［
4. 被调制的曲率系数 \(C_{p,q}\) 本身非零。

本轮的壳层 invariance 说明，同一 quotient class 内的代表元变化不改变上述可见性。

---

## 9. 素数特化

取：

\[
x=p,
\qquad
y=q,
\]

其中 \(p,q\) 为素数。则：

\[
\Theta_k(p)
=
\exp\left(
-2\pi i k\frac{\log p}{2\log\varphi}
\right)
=
p^{-it_k}.
\]

黄金采样的素数对 kernel 为：

\[
\boxed{
K_{p,q}(t_{k_1},t_{k_2})
=
\Theta_{k_1}(p)\Theta_{k_2}(q)
-
\Theta_{k_1}(q)\Theta_{k_2}(p).
}
\]

它读取的相对尺度为：

\[
\frac{\log(p/q)}{2\log\varphi}.
\]

本轮没有证明该数对所有不同素数都无理，也没有证明黄金采样下的 kernel 对所有非平凡 mode pair 都非零。这些属于下一条非共振节点的义务。

---

## 10. 与 RH 的精确边界

零点侧已有黄金径向坐标和黄金周期 monodromy：

\[
M_\rho
=
\operatorname{diag}
\left(
\varphi^{2\delta},
\varphi^{-2\delta}
\right),
\qquad
\delta=\Re\rho-\frac12.
\]

prime side 的本轮对象位于 unitary angular layer：

\[
\Theta_k(p)\in U(1).
\]

zero side 的离线缺陷位于 radial hyperbolic layer：

\[
\delta\ne0
\Longrightarrow
M_\rho\text{ hyperbolic}.
\]

本轮建立的是 prime-side angular object 对黄金尺度商的拓扑下降。它没有提供 angular energy 到 radial hyperbolic discriminant 的 coercive transport。

RH 路线仍需要一条承重桥：

\[
\boxed{
\text{prime-side golden-sampled holonomy/Magnus data}
\Longrightarrow
\text{zero-side off-line radial or odd defect control}.
}
\]

这条桥可以走显式公式、Weil positivity、Schur coercivity或独立构造的 integral monodromy。当前节点没有选择其中任何一种作为已证事实。

---

## 11. 下一真源排序

本轮以后，最邻近的机器节点为：

1. `GoldenPrimeRatioNonresonance`。证明不同素数通道的相对黄金尺度不产生精确整数混叠，并精确列出证明所需的数论输入。
2. `FiniteGoldenMagnusCesaroRecovery`。在有限通道上证明黄金采样的 Cesàro 平均恢复非对角 holonomy energy。
3. `GoldenScaleSolenoidMemoryLift`。把完整壳层在可见圆上的闭合提升为 solenoid 隐藏 profinite fiber 中的非平凡记忆位移。
4. `CriticalStripIntegralMonodromyCollapse`。在明确的 integral-lattice realization 假设下，把临界带内的整数迹间隙运输为 \(\delta=0\)。
5. `PrimeArchimedeanBlindSchurCoercivity`。建立 prime-side 数据对 zero-side blind sector 的真正强制桥。

第一条和第二条继续完成黄金采样的可识别性。第三条负责 topology memory。第四条是条件性拓扑排除器。第五条仍是整个 RH 路线的解析 hard heart。

---

## 12. 严格非主张

本轮不主张：

- 黄金采样对不同素数频率具有统一正间隙；
- 所有不同素数对在所有非平凡 mode pair 上都具有非零 kernel；
- Cesàro 平均已经恢复 finite holonomy energy；
- 黄金尺度圆已经携带非零 winding、Chern class 或 Berry curvature；
- 自发对称破缺或物理时间箭头已经构造；
- 无限素数 second-Magnus energy 已经定义；
- prime-side 壳层商已经支配 zero-side radial defect；
- 离线零点已经排除；
- RH 已经证明。

本轮候选机器增量精确到：

\[
\boxed{
\begin{aligned}
&\text{golden logarithmic scale}
\\
&\Longrightarrow
\text{integral Mellin sample characters}
\\
&\Longrightarrow
\text{golden realization of the frozen second-Magnus alternant}
\\
&\Longrightarrow
\text{kernel and finite energy descend through whole-shell orbits}.
\end{aligned}
}
\]

---

## [PR #4443] ORDERED_MAGNUS_OBSERVABILITY — 二阶 Magnus 可观测性追加

# 2026-09-01 追加：二阶 Magnus 可观测性与标准 Weil/Pick 主干修订

## 1. 修订目标

本轮关闭二阶 Magnus 层内部的四个有限缺口，并校正 RH lane 的中央算术桥：

1. 将 alternating two-slot kernel 的范数上界提升为精确平方公式；
2. 将该 kernel 识别为有限 Fourier 代数生成元交换子的精确系数；
3. 给出逐频率对校准时钟下的精确反向可观测性；
4. 给出 ordered-time simplex 的闭式平均公式；
5. 直接复用已冻结的 `FixedScaleWeilQuadraticForm`，不再另建平行的有限 Weil 定义；
6. 将后续中央开放边拆为 holonomy-to-Weil transport、xi-ratio Pick kernel 与 negative-index detection。

本轮仍只维护这一统一理论卷，不创建节点级 theory 文档。

## 2. 精确 kernel 强度

沿用冻结对象：

\[
K_{p,q}(t_1,t_2)
=
\chi_{\omega_p}(t_1)\chi_{\omega_q}(t_2)
-
\chi_{\omega_q}(t_1)\chi_{\omega_p}(t_2),
\qquad
\chi_\omega(t)=e^{-it\omega}.
\]

令：

\[
A_{p,q}(t_1,t_2)
=(t_1-t_2)\frac{\omega_p-\omega_q}{2}.
\]

新真源 `SecondMagnusKernelNormSquare` 机器证明：

\[
\boxed{
|K_{p,q}(t_1,t_2)|^2
=4\sin^2 A_{p,q}(t_1,t_2).
}
\]

所以既有界 \(|K_{p,q}|\le2\) 是 sharp bound。若 \(\omega_p\ne\omega_q\)，取：

\[
t_1=\frac{\pi}{\omega_p-\omega_q},
\qquad t_2=0,
\]

则：

\[
\boxed{|K_{p,q}(t_1,0)|^2=4.}
\]

这给出 pairwise faithfulness。任意非零频差均存在显式最大响应时刻。它尚未给出所有频率对共享的单一时钟。

## 3. kernel 已进入真实交换子

设 \(A\) 为复结合代数，有限生成元族为 \(G_p\in A\)，定义：

\[
H_G(t)=\sum_p\chi_{\omega_p}(t)G_p.
\]

新真源 `FiniteFourierMagnusCommutator` 机器证明：

\[
\boxed{
[H_G(t_1),H_G(t_2)]
=
\sum_{p,q}K_{p,q}(t_1,t_2)G_pG_q.
}
\]

因此 `SecondMagnusSwapCurvature` 的 alternating kernel 已经成为有限 Fourier 生成元交换子中的精确系数。当前仍未构造 Banach 或 Hilbert 空间上的 time-ordered exponential、Bochner integral、Magnus 级数收敛或无限频率极限。

## 4. pair-calibrated 精确反向可观测性

对有限单射频率族 \(\omega:I\to\mathbb R\)，定义：

\[
T_{p,q}
=
\begin{cases}
0,&p=q,\\
\displaystyle\frac\pi{\omega_p-\omega_q},&p\ne q.
\end{cases}
\]

设 \(C_{p,q}\in\mathbb C\) 且 \(C_{p,p}=0\)。定义：

\[
E_{\mathrm{cal}}(\omega,C)
=
\sum_{p,q}|K_{p,q}(T_{p,q},0)C_{p,q}|^2.
\]

新真源 `PairCalibratedSecondMagnusObservability` 机器证明：

\[
\boxed{
E_{\mathrm{cal}}(\omega,C)
=4E_{\mathrm{hol}}(C),
}
\]

其中：

\[
E_{\mathrm{hol}}(C)=\sum_{p,q}|C_{p,q}|^2.
\]

并得到：

\[
E_{\mathrm{cal}}(\omega,C)=0
\iff
\forall p,q,\ C_{p,q}=0.
\]

这说明固定两时刻缺少反向界的原因是 resonance 与采样协议。允许 pair-adapted clocks 后，完整 off-diagonal curvature 可被精确恢复。

## 5. ordered-time simplex 的闭式响应

二阶 Magnus 项使用有序区域：

\[
0\le t_2\le t_1\le T.
\]

对仅依赖时间差 \(\tau=t_1-t_2\) 的标量响应，二重积分约化为三角权重的一重积分。定义：

\[
\mathcal A_g(T)
=
\int_0^T(T-\tau)
4\sin^2\left(\frac{g\tau}{2}\right)d\tau.
\]

新真源 `OrderedTimeSimplexSecondMagnusAverage` 对 \(g\ne0\) 机器证明：

\[
\boxed{
\mathcal A_g(T)
=T^2-\frac{2(1-\cos(gT))}{g^2}.
}
\]

同时：

\[
\mathcal A_0(T)=0,
\qquad
T\ge0\Longrightarrow\mathcal A_g(T)\ge0.
\]

由 \(0\le1-\cos(gT)\le2\) 可读出下一步下界：

\[
\mathcal A_g(T)\ge T^2-\frac4{g^2}.
\]

对有限单射频率族，令：

\[
\Delta_\omega=
\min_{p\ne q}|\omega_p-\omega_q|>0.
\]

则所有非对角频率对同时满足：

\[
\mathcal A_{\omega_p-\omega_q}(T)
\ge T^2-\frac4{\Delta_\omega^2}.
\]

当 \(T>2/\Delta_\omega\) 时，右侧严格为正。因此下一真源应为：

\[
\boxed{\texttt{FiniteFrequencyOrderedSimplexCoercivity}.}
\]

它应冻结统一窗口双边界：

\[
c_{\omega,T}E_{\mathrm{hol}}(C)
\le E_{\mathrm{simplex}}(\omega,C;T)
\le T^2E_{\mathrm{hol}}(C),
\qquad c_{\omega,T}>0.
\]

## 6. 三种可观测性分层

当前二阶 Magnus 层具有三个不同强度的结论：

1. pointwise boundedness：
   \[
   0\le E^{(2)}(t_1,t_2)\le4E_{\mathrm{hol}};
   \]
2. adaptive identifiability：
   \[
   E_{\mathrm{cal}}=4E_{\mathrm{hol}};
   \]
3. common-window observability coefficient：
   \[
   \mathcal A_g(T)=T^2-2(1-\cos(gT))/g^2.
   \]

后续不得把三者混写为同一类 Magnus positivity。固定采样可共振，pair-adapted sampling 精确，ordered window 将统一强制性归约为最小频差问题。

## 7. 中央算术桥的修订

仓库已经冻结：

\[
\boxed{\texttt{D5/S3/Weil/ZetaBridge/FixedScaleWeilQuadraticForm}.}
\]

该真源已经包含 convolution-square Weil test、von Mangoldt prime-power contribution、Archimedean multiplier、pole rank-one energy、zero-side sum 与 fixed-scale positivity equivalence。

因此不再建立第二套有限 Weil quadratic form。缺失对象是从 chronological holonomy 数据进入既有标准 Weil 对象的运输：

\[
\boxed{
\text{finite Fourier memory/holonomy}
\longrightarrow
\text{admissible Weil test function}
\longrightarrow
\texttt{FixedScaleWeilQuadraticForm}.
\]

下一开放边命名为：

\[
\boxed{\texttt{HolonomyToFixedScaleWeilTransport}.}
\]

它至少需要证明：

- finite coefficients 到 `WeilTestFunction` 的构造；
- support 半径记账；
- prime-power 权重与 \(\log n\) 频率匹配；
- Gamma 与 pole 项保留；
- truncation remainder；
- holonomy energy 与 fixed-scale Weil form 的等式、下界或带误差比较。

显式公式应成为 prime-side 与 zero-side 相遇的标准中介。当前自定义 holonomy energy 到自定义 off-line energy 的直接 domination 不再作为 primitive hard heart。

## 8. Pick/Pontryagin 负指标接口

仓库已经冻结抽象真源：

\[
\boxed{\texttt{HermitianKernelNegativeSquares}.}
\]

下一步需要输入一个来自 completed xi 的具体函数。标准候选为：

\[
\Theta_\omega(z)
=
\frac{\xi(\frac12-\omega-iz)}
{\xi(\frac12+\omega-iz)},
\qquad\omega>0.
\]

相应 half-plane Pick kernel 可规范化为：

\[
K_{\Theta_\omega}(z,w)
=
\frac{1-\Theta_\omega(z)\overline{\Theta_\omega(w)}}
{-i(z-\overline w)}.
\]

下一真源命名为：

\[
\boxed{\texttt{XiRatioPickKernel}.}
\]

它应证明定义域、极点排除、Hermitian symmetry、reflection compatibility、临界线假设下的 Schur/inner implication，以及有限 Gram 矩阵到 `HermitianKernelNegativeSquares` 的接口。

随后建立：

\[
\boxed{\texttt{OfflineZeroPickIndexLowerBound}.}
\]

第一阶段只要求一个被窗口与采样隔离的离线零点轨道产生至少一个有限负方向。精确计数：

\[
\kappa_{\omega,T}=N_{\mathrm{off}}(\omega,T)
\]

仍登记为后续 index theorem。

## 9. determinant 与极限层

冻结的 `HorizonEffectiveIndex` 给出有限严格收缩矩阵的 barrier：

\[
\operatorname{Ind}_{\mathrm{hor}}(H)
=
\det(I-H^*H)^{-1}
=
\prod_j(1-\sigma_j^2)^{-1}.
\]

当前核心结论对一般严格收缩矩阵成立。Hankel 假设尚未承担主证明。后续需要从具体 xi/Weil symbol 构造 Hankel operator，证明 finite-section、Hilbert-Schmidt 或 trace-class 条件、负指标稳定与 Fredholm determinant 极限。

候选真源为：

\[
\boxed{
\texttt{FiniteIndexLimitStability},
\qquad
\texttt{FredholmHorizonIndexLimit}.
}
\]

## 10. 黄金周期边界

离线 monodromy 的双曲判据：

\[
4\sinh^2(\delta T)>0
\iff\delta\ne0
\]

对任意 \(T>0\) 成立。因此 \(T_\varphi=2\log\varphi\) 目前是合法采样周期与规范化选择。它尚未获得 small-divisor、continued-fraction return、frame lower bound、condition number 或 Weil/Pick index 上的独立最优性。

应先冻结：

\[
\boxed{\texttt{OfflineZeroMonodromyPeriodIndependence}.}
\]

只有一般周期定理建立后，才适合定义 `GoldenPeriodOptimalityCriterion`。

## 11. 修订后的 theorem DAG

```text
PrimeFrequencyPhaseFlow                         Frozen
        |
        v
TimeOrderedPrimeMemoryCocycle                   Frozen
        |
        v
SecondMagnusSwapCurvature                       Frozen
        |
        +-----------------------------+
        |                             |
        v                             v
SecondMagnusKernelNormSquare       FiniteFourierMagnusCommutator
        |                             |
        v                             |
PairCalibratedSecondMagnusObservability          |
        |                             |
        +---------------+-------------+
                        |
                        v
OrderedTimeSimplexSecondMagnusAverage
                        |
                        v
FiniteFrequencyOrderedSimplexCoercivity         Open
                        |
                        v
HolonomyToFixedScaleWeilTransport               Open
                        |
                        v
FixedScaleWeilQuadraticForm                     Frozen
                        |
                        v
XiRatioPickKernel                               Open
                        |
                        v
HermitianKernelNegativeSquares                  Frozen
                        |
                        v
OfflineZeroPickIndexLowerBound                  Open
                        |
                        v
FiniteIndexLimitStability / Fredholm limit      Open
                        |
                        v
Uniform global Weil positivity                  Open
                        |
                        v
RH
```

## 12. 接下来的形式化顺序

### P0. `FiniteFrequencyOrderedSimplexCoercivity`

利用本轮闭式积分与有限最小频差，冻结统一时间窗口双边界。

### P1. `HolonomyToFixedScaleWeilTransport`

复用既有 fixed-scale Weil 真源，构造 finite Fourier/curvature coefficients 到合法 test function 的运输。

### P2. `XiRatioPickKernel`

定义 completed-xi ratio 的具体 half-plane kernel，并证明 Hermitian 与 reflection laws。

### P3. `OfflineZeroPickIndexLowerBound`

把被隔离的离线零点运输成有限 Gram 负方向。

### P4. `FiniteIndexLimitStability`

控制采样、窗口、prime-power cutoff 与 operator dimension 增长时的负指标逃逸。

### P5. `FredholmHorizonIndexLimit`

把有限 determinant barrier 提升到 trace-class Fredholm determinant。

## 13. 当前 claim boundary

本轮机器证明：

- alternating kernel 的精确 squared norm；
- 非零频差的显式最大响应采样；
- 有限 Fourier 代数生成元的精确 commutator expansion；
- pair-adapted clocks 下四倍 holonomy energy 的精确恢复；
- ordered-time simplex scalar response 的闭式公式；
- 零频差响应为零；
- 非负窗口上的响应非负。

本轮没有证明公共固定时刻的全频率可观测性、finite-family ordered-window coercivity、time-ordered exponential、Magnus 级数收敛、holonomy-to-Weil transport、xi-ratio Pick positivity、离线零点数与负平方数的等式、Fredholm 极限、全局 Weil 正性或 RH。

本轮关闭的有限链为：

\[
\boxed{
\text{Fourier chronology}
\longrightarrow
\text{algebra commutator}
\longrightarrow
\text{exact kernel strength}
\longrightarrow
\text{pairwise reverse observability}
\longrightarrow
\text{ordered-simplex response}.
}
\]

中央开放边现在被压缩为：

\[
\boxed{
\texttt{FiniteFrequencyOrderedSimplexCoercivity}
\rightarrow
\texttt{HolonomyToFixedScaleWeilTransport}
\rightarrow
\texttt{XiRatioPickKernel}
\rightarrow
\texttt{OfflineZeroPickIndexLowerBound}.
}
\]

---

## [PR #5602] WEIL_GROUND_MODE_SHIFT_BARRIER

# Weil 最低模态路线中的内部平移障碍与算术边界项

对应真源：`D5/S3/Weil/ZetaBridge/WeilGroundModeShiftBarrier.lean`。
配套 Scribe：`Blueprint/D5/S3/Weil/ZetaBridge/WeilGroundModeShiftBarrier.scribe.cs`。

本节补入前一轮已提交 Lean 的理论推导。有限平移恒等式、紧支撑非消失性和平方残差下界已有 Lean 证明脚本，尚未经本环境编译。尺度族推论及算术边界展开是纸面推导。没有证明完整算术强制性、最低模态单纯偶性或 RH。

## 1. 同一算术对象与平移探针

令

\[
C(f,g)(s)=\int_{\mathbb R}f(x)\overline{g(x-s)}\,dx,
\qquad W(f,g)=\operatorname{literatureRHS}(C(f,g)).
\]

直接使用 `Zeta23.EF.weilTest` 与 `Zeta23.EF.literatureRHS`，保留实际 von Mangoldt 素数幂系数、两个极点项和 `gammaBracket`。这里的原始相关函数载体允许一般复值函数。已有 `WeilTestFunction` 的偶性约束不能代替完整奇偶空间上的最低模态论证。

Fourier 约定为 `hat f(z)=integral f(x)*exp(i*z*x) dx`。固定 `t>0`，定义

\[
S_tf(x)=f(x-t)+f(x+t),\qquad B=S_t-\alpha I.
\]

对归一化候选 `k`，取实数 `alpha=<S_t k,k>`，则 `|alpha|<=2` 且 `Bk` 与 `k` 正交。相关函数满足精确恒等式

\[
C(Bf,g)=C(f,Bg),\qquad C(Bk,Bk)=C(k,B^2k).
\]

这些等式在作用整个 `literatureRHS` 之前成立，因此不会丢掉 prime、pole 和 Gamma 项之间的抵消。

## 2. 已提交的方向性残差障碍

当 `Bk` 和 `B^2k` 都是同一窗口算子的合法测试函数时，令

\[
\mu=\langle k,A_ak\rangle,\qquad R=(A_a-\mu)k,\qquad r=\|R\|_2.
\]

则

\[
q_a(Bk)-\mu\|Bk\|_2^2=\Re\langle R,B^2k\rangle.
\]

结合该方向的强制性与残差配对上界，Lean 证明脚本给出

\[
\boxed{\delta^2\|Bk\|_2^2\le3(2+\alpha^2)r^2.}
\]

它没有证明算术强制性本身。利用 `|alpha|<=2`，可读出

\[
\boxed{r/\delta\ge\|Bk\|_2/\sqrt{18}.}
\]

## 3. 固定内缩候选的尺度族障碍

设归一化候选满足

\[
\operatorname{supp}k_a\subset[-a+2t,a-2t],
\qquad k_a\longrightarrow k_\infty\ne0\text{ in }L^2(\mathbb R),
\]

其中 `t>0` 固定。内缩余量使一次、两次平移仍为原窗口合法测试函数。此时

\[
B_ak_a\longrightarrow(S_t-\alpha_\infty)k_\infty.
\]

右侧非零，因为 Fourier 乘子 `2*cos(t*xi)-alpha_infty` 的零集离散，非零 L2 函数不可能完全支撑于该零测集。因此，若余维一强制性成立，必有

\[
\boxed{\liminf_{a\to\infty}r_a/\delta_a>0.}
\]

这个障碍已经存在于偶子空间内部，因为对称平移保持偶性。

## 4. 对明确 Xi 核截断的应用

令

\[
\Phi(x)=\sum_{n=1}^\infty
\left(4\pi^2n^4e^{9x/2}-6\pi n^2e^{5x/2}\right)
\exp(-\pi n^2e^{2x}).
\]

此 theta 核为偶函数，满足上述 Fourier 约定下的 `hat Phi=Xi`，并具有双指数衰减。取具有固定内缩余量的偶光滑截断 `chi_a`，令

\[
k_a=\chi_a\Phi/\|\chi_a\Phi\|_2,
\qquad c_a=\|\chi_a\Phi\|_2.
\]

双指数衰减给出 `c_a*hat k_a=hat(chi_a*Phi)` 在复平面紧集上一致收敛到 Xi，并且 `c_a` 趋向非零常数。另一方面，第 3 节说明：若强制性成立，

\[
|c_a|\sqrt{2a}e^{ba}r_a/\delta_a\longrightarrow0
\]

甚至在 `b=0` 也不成立。因此固定内缩的 Xi 核截断不能同时实现该强制性与此充分收敛条件。本推导不排除触及边界的 prolate 候选，也不排除直接控制 Fourier 观察误差的较弱机制。

## 5. 保留边界后的精确缺陷

令 `P` 为窗口正交截断，`Q=I-P`，`Pk=k`，并记

\[
v=PBk,\quad h=QBk,\quad w=PBv,\quad e=QBv.
\]

在混合 Weil 配对合法的条件下，相关函数转移给出

\[
W(v,v)+W(h,v)=W(k,w)+W(k,e).
\]

由此

\[
q_a(v)-\mu\|v\|_2^2
=\Re\langle R,w\rangle+\mathcal B_a(k,t),
\]

\[
\mathcal B_a(k,t)=\Re\{W(k,e)-W(h,v)\}.
\]

因为 `v` 与 `k` 正交且 `||w||<=4||v||`，强制性要求

\[
\boxed{\mathcal B_a(k,t)\ge\delta\|v\|_2^2-4r\|v\|_2.}
\]

中心化系数 `alpha` 在这个边界泛函中抵消。因此该量由明确候选、窗口与平移步长独立决定。边界贡献需要支撑所需谱分离，不能仅以边界 L2 质量小为由忽略。

## 6. 有限素数幂表达与 Abel 变换

设

\[
d=C(k,e)-C(h,v),\qquad H(s)=\Re(d(s)+d(-s)),\qquad M=2a+t.
\]

对紧支撑、有限分段光滑的候选，相关函数具有所需正则性。窗口内外正交性及支撑端点给出 `H(0)=H(M)=0`。定义

\[
\mathfrak D_M(H)=
\sum_{2\le n\le e^M}\frac{\Lambda(n)}{\sqrt n}H(\log n)
-\int_0^Me^{s/2}H(s)\,ds.
\]

保留极点与连续主项的抵消，得到

\[
\boxed{
\mathcal B_a(k,t)=-\mathfrak D_M(H)
-\int_0^M\frac{e^{-5s/2}}{1-e^{-2s}}H(s)\,ds.
}
\]

令 `Psi(x)=sum_{n<=x} Lambda(n)`，`E(x)=Psi(x)-x+1`。Abel 分部积分给出

\[
\mathfrak D_M(H)=-\int_0^ME(e^s)e^{-s/2}
\left(H'(s)-\tfrac12H(s)\right)ds.
\]

因此明确候选必须通过的必要检验是

\[
\begin{aligned}
&\int_0^ME(e^s)e^{-s/2}\left(H'(s)-\tfrac12H(s)\right)ds\\
&\quad-\int_0^M\frac{e^{-5s/2}}{1-e^{-2s}}H(s)\,ds
\ge\delta\|v\|_2^2-4r\|v\|_2.
\end{aligned}
\]

该候选下界仍未证明，也不足以单独替代所有正交方向上的强制性。分段光滑定义域延拓、上述边界展开与 Abel 变换尚未全部形式化。

---

## [PR #5602] CANONICAL_GAMMA_TAIL_BOUNDARY_MOMENTS

# 2026-09-05：保留边界矩的 Gamma 尾项压缩与最低模态误差预算

对应 Lean：`D5/S3/Weil/ZetaBridge/WeilArchimedeanTailJet.lean`。
配套 Scribe：`Blueprint/D5/S3/Weil/ZetaBridge/WeilArchimedeanTailJet.scribe.cs`。

本增补接续内部平移障碍。目标是保留实际候选的边界行为，并量化有限计算省略的 Gamma 尾项。下面第 3 节的逐频率密度误差已有 Lean 证明脚本；脚本经过数学和源码审查，尚未在本环境编译。Fourier 识别、积分预算、正投影修正、奇扇区推广和残差推论是本轮纸面推导。有限频带上的全方向估计与整个窗口 Hilbert 空间上的余维一强制性必须分别证明。

## 1. 文献接口与本轮选择

Connes、Consani、Moscovici 的 *Zeta Spectral Triples*，arXiv:2511.22755v1，第 7 节尤其 Lemma 7.3，已经证明其明确 prolate 模型在相应归一化下具有条带内的 Xi 极限；第 8 节继续要求真实最低模态的单纯偶性及与模型之间足够精确的逼近。该模型极限不能替代真实最低模态识别。

Connes、van Suijlekom 的 *Quadratic Forms, Real Zeros and Echoes of the Spectral Action*，arXiv:2511.23257v1，提供规定分布与定义域条件下的实零点机制。Suzuki 的 *Weil's quadratic form via the screw function*，arXiv:2606.09096v1，给出实际 Weil 算子与 Friedrichs 扩张的另一种描述。使用这些结果需要保持同一算术形式及其定义域，不能将某个微分表达式的最小域直接等同于完成后的算子域。

Groskin 的 *A finite Guinand–Weil dictionary and archimedean tail order for the truncated Weil quadratic form*，arXiv:2607.02828v1，Theorem 3.2 给出有限 Galerkin Gamma 尾项的精确 Cauchy Gram 密度，Lemma 3.1 给出大频率 Gamma 包络。该文已经提供 cutoff-free 组装和区间 LDL 分解。因此本轮不宣称首次消除 Gamma 截断，也不宣称优于其现有算法。本轮从该具体核继续推导保留边界矩的有限秩修正及显式误差预算。投影与几何级数工具本身是经典工具；未作原创优先权声明。

参考地址：

- https://arxiv.org/html/2511.22755v1
- https://arxiv.org/html/2511.23257v1
- https://arxiv.org/html/2606.09096v1
- https://arxiv.org/html/2607.02828

## 2. 归一化与具体 Gamma 尾项

令窗口为 `[-L/2,L/2]`，`L=2a=log c>0`，有限素数幂 cutoff 为 `c=exp L`。定义

\[
\rho=\frac{2\pi}{L},\qquad b=\rho N,
\qquad \gamma(t)=\Re\psi_\Gamma(1/4+it/2)-\log\pi.
\]

这里 `gamma` 直接是仓库已有 `Zeta23.EF.gammaBracket`。Fourier 仍取

\[
\widehat f(t)=\int_{\mathbb R}f(x)e^{itx}\,dx.
\]

在零延拓的偶子空间上，取正交归一基

\[
\varphi_0=L^{-1/2}\mathbf1_I,\qquad
\varphi_k=(-1)^k\sqrt{2/L}\cos(\rho kx)\mathbf1_I\quad(k\ge1),
\qquad I=[-L/2,L/2].
\]

相位 `(-1)^k` 是坐标约定的一部分。删掉它会改变后面的 Cauchy 响应。令 `sigma_0=1`，`sigma_k=sqrt(2)` 对 `k>0`，并设

\[
f_v=\sum_{k=0}^Nv_k\varphi_k,\qquad
R_v(t)=\sum_{k=0}^N\frac{\sigma_kv_k}{1-(\rho k/t)^2}.
\]

逐项积分给出，对 `t>b`，

\[
\widehat f_v(t)=\frac2{\sqrt L}\frac{\sin(Lt/2)}tR_v(t).
\]

于是从 `|t|>T` 省略的真实 Gamma 能量矩阵为

\[
\boxed{v^*E_Tv=\int_T^\infty w_L(t)|R_v(t)|^2\,dt,}
\]

其中

\[
\boxed{w_L(t)=\frac{2\rho}{\pi^2}\gamma(t)\frac{\sin^2(Lt/2)}{t^2}.}
\]

这个公式也由上述 Cauchy Gram 密度经过等距偶嵌入得到。此处只处理 Gamma 积分尾项，prime 与 pole 块保持完整。真实 Weil 形式的其他部分没有被改成正核。

## 3. 已提交的逐频率全方向误差

固定任意自然数 `m`，允许 `m=0`。定义有限矩

\[
M_{2j}(v)=\sum_{k=0}^N\sigma_k(\rho k)^{2j}v_k,
\qquad
P_{m,v}(t)=\sum_{j=0}^{m-1}t^{-2j}M_{2j}(v).
\]

这些矩直接记录有限三角候选的边界偶阶导数：

\[
f_v^{(2j)}(L/2)=(-1)^jL^{-1/2}M_{2j}(v).
\]

保留矩允许候选具有非零边界值及导数。没有要求候选属于 moment-neutral 子空间。

设

\[
q(t)=(b/t)^2<1.
\]

精确有限几何余项为

\[
R_v(t)-P_{m,v}(t)
=\sum_{k=0}^N\sigma_kv_k
\frac{(\rho k/t)^{2m}}{1-(\rho k/t)^2}.
\]

因为

\[
\left(\sum_k\sigma_k|v_k|\right)^2
\le(2N+1)\sum_k|v_k|^2,
\]

有

\[
|R_v|,|P_{m,v}|
\le\frac{\sqrt{2N+1}}{1-q(t)}\|v\|_2,
\]

\[
|R_v-P_{m,v}|
\le\frac{\sqrt{2N+1}\,q(t)^m}{1-q(t)}\|v\|_2.
\]

相乘得到

\[
\boxed{
\bigl||R_v(t)|^2-|P_{m,v}(t)|^2\bigr|
\le\frac{2(2N+1)q(t)^m}{(1-q(t))^2}\|v\|_2^2.
}
\]

Lean 主声明 `even_archimedean_tail_density_jet_error` 证明将两边乘以 `|w_L(t)|` 后的精确密度不等式。量词覆盖任意 `N,m`、`L>0`、`t>rho*N` 和任意复系数向量。`N=0`、`m=0` 均包含在陈述内。该定理不假设 Gamma 的符号。

即使在 `w_L>=0` 的区域，两个 Gram 密度之差也不必正半定。因此该直接 Taylor jet 只提供双边误差，不能直接声称一个有序的正修正。

## 4. 直接 jet 的积分误差

以下使用外部 Lemma 3.1 的独立输入

\[
0<\gamma(t)\le\log t-\frac85\qquad(t\ge7).
\]

本轮没有重新运行该文用于检查 `gamma(7)>0` 的 Arb 区间程序，也没有把该输入写成新公理。它不属于本轮 Lean 主声明的前提或结论。

取 `T>=7`、`T>b`，记 `theta=b/T<1`。定义

\[
v^*E_T^{[m]}v=\int_T^\infty w_L(t)|P_{m,v}(t)|^2\,dt.
\]

逐频率界和

\[
\int_T^\infty t^{-p-2}\left(\log t-\frac85\right)dt
=T^{-p-1}\left(\frac{\log T-8/5}{p+1}+\frac1{(p+1)^2}\right)
\]

给出纸面结论

\[
\boxed{
\|E_T-E_T^{[m]}\|\le\varepsilon_m,
}
\]

\[
\varepsilon_m=
\frac{4\rho(2N+1)}{\pi^2}
\frac{\theta^{2m}}{(1-\theta^2)^2T}
\left(\frac{\log T-8/5}{2m+1}+\frac1{(2m+1)^2}\right).
\]

积分式与算子范数运输尚未写入本轮 Lean。

## 5. 正交投影给出有序的有限秩修正

为获得正半定余量，在加权 Hilbert 空间

\[
\mathcal H_T=L^2((T,\infty),w_L(t)dt)
\]

中定义

\[
h_k(t)=\frac{\sigma_k}{1-(\rho k/t)^2},
\qquad Vv=\sum_kv_kh_k.
\]

此时 `E_T=V^*V`。令 `Pi_m` 是到

\[
\operatorname{span}\{1,t^{-2},\ldots,t^{-2(m-1)}\}
\]

的正交投影，并定义

\[
\boxed{E^{\mathrm{opt}}_{T,m}=V^*\Pi_mV.}
\]

这个修正由 Gamma 核、有限带宽和明确矩空间独立构造，不使用未知最低模态。其矩阵可直接写为

\[
E^{\mathrm{opt}}_{T,m}=C^*M^{-1}C,
\]

\[
M_{ij}=\int_T^\infty w_L(t)t^{-2(i+j)}dt,
\qquad C_{ik}=\int_T^\infty w_L(t)t^{-2i}h_k(t)dt.
\]

对 `m>0`，`M` 正定：非零的 `t^{-2}` 多项式不可能在一个区间上恒零，而权密度在离散的正弦零点以外严格为正。对 `m=0` 直接令修正为零，无须求逆。

投影的最小二乘性质给出

\[
\|(1-\Pi_m)Vv\|_{\mathcal H_T}^2
\le\|R_v-P_{m,v}\|_{\mathcal H_T}^2.
\]

结合精确几何余项，得到本轮较强的纸面定理：

\[
\boxed{
0\preceq E_T-E^{\mathrm{opt}}_{T,m}
=V^*(1-\Pi_m)V\preceq\kappa_mI,
\qquad \operatorname{rank}E^{\mathrm{opt}}_{T,m}\le m,
}
\]

其中

\[
\boxed{
\kappa_m=
\frac{2\rho(2N+1)}{\pi^2}
\frac{\theta^{4m}}{(1-\theta^2)^2T}
\left(\frac{\log T-8/5}{4m+1}+\frac1{(4m+1)^2}\right).
}
\]

证明中先平方余项，使幂次从 `theta^(2m)` 改善到 `theta^(4m)`，再使用 `sin^2<=1` 和 Gamma 包络积分。正余量来自正交投影恒等式，绝不能从直接 Taylor Gram 近似擅自推断。

该定理是本轮纸面证明，尚未经 Lean 验证。实际数值实现还需对 `M`、`C` 的积分以及线性求解做区间控制。使用缩放基 `(T/t)^(2j)` 可以避免部分幂次尺度问题，但它不自动提供良好的矩矩阵条件数。

## 6. 奇扇区的相邻纸面结论

奇基可取 `(-1)^k*sqrt(2/L)*sin(rho*k*x)`，`1<=k<=N`。忽略共同的单位复相位后，其 Fourier 响应为

\[
R^-_v(t)=\sum_{k=1}^N\sqrt2v_k
\frac{\rho k/t}{1-(\rho k/t)^2}.
\]

将矩空间改为

\[
\operatorname{span}\{t^{-1},t^{-3},\ldots,t^{-(2m-1)}\}
\]

并重复平方余项证明，得到

\[
0\preceq E^-_T-E^{-,\mathrm{opt}}_{T,m}\preceq\kappa^-_mI,
\]

\[
\kappa^-_m=
\frac{2\rho(2N)}{\pi^2}
\frac{\theta^{4m+2}}{(1-\theta^2)^2T}
\left(\frac{\log T-8/5}{4m+3}+\frac1{(4m+3)^2}\right).
\]

`N=0` 时奇子空间为零空间。这个相邻结论尚未形式化。它提供奇偶两侧一致的尾项处理方式，没有证明最低模态位于偶扇区。

## 7. 对候选残差和谱分离的用途

这一节仍固定同一个有限 Galerkin 子空间。记

\[
Q_\infty^N=\widetilde Q^N+S,
\qquad \widetilde Q^N=Q_T^N+E^{\mathrm{opt}}_{T,m},
\qquad 0\preceq S\preceq\kappa_m I.
\]

对归一化明确候选 `k`，令

\[
\widetilde\mu=\langle k,\widetilde Q^Nk\rangle,
\quad\eta=\langle k,Sk\rangle\in[0,\kappa_m],
\quad\mu=\widetilde\mu+\eta.
\]

若修正矩阵已在 `k` 的正交补上具有间隔 `tilde_delta>kappa_m`，则完整 Gamma 尾项加入后，仍可取

\[
\delta\ge\widetilde\delta-\kappa_m>0.
\]

对残差，有更精确的中心化控制：由 `S^2<=kappa_m*S`，

\[
\|(S-\eta I)k\|^2
=\langle k,S^2k\rangle-\eta^2
\le\kappa_m\eta-\eta^2\le\kappa_m^2/4.
\]

因此

\[
\boxed{
r\le\widetilde r+\kappa_m/2,
\qquad
\frac r\delta\le
\frac{\widetilde r+\kappa_m/2}{\widetilde\delta-\kappa_m}.
}
\]

这里的 `r` 是完整 Gamma 积分下有限矩阵的残差。整个 Hilbert 空间上的残差还包括 Galerkin 正交补中的分量，整个空间的强制性也需要该正交补的独立下界与块间耦合控制。二者不能由以上有限矩阵估计省略。

## 8. 参数族与诊断量

若 `theta<=theta_0<1`，则

\[
\kappa_m\le A(L,N,T,\theta_0)\theta_0^{4m},
\]

\[
A=\frac{2\rho(2N+1)}{\pi^2}
\frac{\log T-8/5+1}{(1-\theta_0^2)^2T}.
\]

所以当 `0<theta_0<1` 时，选取

\[
m\ge\frac{\max\{0,\log(A/\epsilon)\}}{4\log(1/\theta_0)}
\]

足以使这个尾项预算不超过给定 `epsilon>0`。此处每个尺度的 `L,N,T` 仍显式保留，没有偷换为一个固定窗口定理。

在文献使用的 `c=100,N=200,T=800` 参数处，代入本轮公式得到

\[
\theta\approx0.34109408846,
\qquad \kappa_{32}\approx1.13078458\times10^{-62}.
\]

该数只是解析预算的高精度数值评价。没有实际组装 `Eopt`、没有认证 `M` 的条件数、没有得到新的最低特征值区间。75 组覆盖零阶、零带宽、复系数和接近带边的随机诊断均满足推导不等式；这些测试也不替代形式证明或区间证书。

## 9. 仍需消除的数学假设

本轮将具体 Gamma 尾项误差变成一个可按精度选择的有限矩预算。完整研究目标仍要求：

1. 对明确算术候选证明有限修正矩阵中的正交补下界，并控制 prime、pole 与边界贡献之间的抵消。
2. 对 Galerkin 子空间以外的全部方向给出强制性和耦合估计，将矩阵结论提升到同一 Friedrichs Weil 算子。
3. 沿无界尺度序列联合控制实际候选残差与谱间隔，使误差足以承受复频率权重，并接到文献已有 prolate 模型的 Xi 极限。

其中第 1、2 项仍然是算术承重问题。本轮没有证明新的全空间尺度实例，没有获得无界尺度的单纯偶性，也没有证明真实最低模态变换收敛到 Xi。

---

## [PR #5602] INFINITE_WEIL_COMPLEMENT_COERCIVITY

# 2026-09-06：无限 Galerkin 补空间的显式算术下界

对应 Lean：`D5/S3/Weil/ZetaBridge/WeilInfiniteComplementLeakage.lean`。
配套 Scribe：`Blueprint/D5/S3/Weil/ZetaBridge/WeilInfiniteComplementLeakage.scribe.cs`。

本节处理此前尚未控制的全部高模态方向。这里的截断参数 N 删除的是空间 Fourier 基的低阶模式；上一节的 T 截断的是组装 Gamma 积分时的连续频率变量。两种尾项不同，上一节的有限矩阵精度不能消除本节的无限维义务。

本节的无限 Cauchy 级数低频质量界已有 Lean 证明脚本。级数绝对收敛、连续性和积分可积性包含在证明内。真实 Fourier 展开识别、完整 Weil 补空间下界、含素数尺度实例和 Schur 运输是以下纸面证明，尚未全部连接成 Lean 中的算子定理。Lean 与 Scribe 编译未在本环境运行。

## 1. 文献接口与保留的对象

Connes–Consani–Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1，第 7 节和 Lemma 7.3 已给出明确 prolate 模型的 Xi 极限，第 8 节保留真实最低模态识别与单纯偶性。Connes–van Suijlekom, arXiv:2511.23257v1，提供精确分布与算子定义域条件下的实零点定理。

Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v1，Theorem 1.1 识别同一 Weil 形式的 Friedrichs 实现，并建立相关对数型形式域的紧嵌入。因此本节不将紧 resolvent 或抽象高谱发散登记为新发现。Groskin, *A finite Guinand–Weil dictionary and archimedean tail order for the truncated Weil quadratic form*, arXiv:2607.02828v1，Theorem 3.2 处理有限 Galerkin Gamma 尾项。本节使用同一 Fourier 约定，但补空间没有有限上截止。

仓库中直接可复用的 Gamma 真源为 `Zeta23.MuFields.mu_monotoneOn`、`mu_zero_le`、`neg_one_lt_mu_zero` 和 `Zeta23.mu_even`。本文 gamma=2*pi*mu，即既有 `Zeta23.EF.gammaBracket`。平移项和极点项仍来自 `literatureRHS(weilTest f f)`。未通过零点位置、RH 或目标正性构造输入。

参考：

- https://arxiv.org/html/2511.22755v1
- https://arxiv.org/html/2511.23257v1
- https://arxiv.org/html/2606.09096v1
- https://arxiv.org/html/2607.02828v1

本节矩阵元采用内积对第二变量线性的约定；相关函数与 Fourier 约定保持不变。

## 2. 全部无限 Fourier 尾部的低频泄漏界

固定 L=2a>0，I=[-L/2,L/2]，rho=2*pi/L。使用零延拓的正交归一基

\[
e_n(x)=(-1)^nL^{-1/2}e^{i\rho n x}\mathbf1_I(x),\qquad n\in\mathbb Z.
\]

令 P_N 是到 |n|<=N 的正交投影，N>=1。对任意 g 属于 P_N 的正交补，记其两侧系数为 u_j 和 v_j，对应 n=N+j+1 及 n=-(N+j+1)。Parseval 给出

\[
A=\sum_{j\ge0}|u_j|^2+\sum_{j\ge0}|v_j|^2=\|g\|_2^2.
\]

定义

\[
C(d,u)=\sum_{j\ge0}\frac{u_j}{d+j+1}.
\]

对 d>0，有逐项可求和的正上界

\[
\sum_{j=0}^{M-1}(d+j+1)^{-2}
\le d^{-1}-(d+M)^{-1}\le d^{-1}.
\]

由此和 Cauchy–Schwarz 得到绝对收敛，以及

\[
|C(d,u)|^2\le d^{-1}\sum_{j\ge0}|u_j|^2.
\]

在 |s|<=N/4 上，N+s 和 N-s 均至少为 3N/4。因此

\[
|C(N+s,u)-C(N-s,v)|^2\le\frac8{3N}A.
\]

对有限 Fourier 和逐项积分，再取 L2 极限，得到

\[
\boxed{
|\widehat g(\rho s)|^2
=\frac L{\pi^2}\sin^2(\pi s)
|C(N+s,u)-C(N-s,v)|^2.
}
\]

极限交换无需边界正则性：支撑固定在 I 时，L2 收敛蕴含 L1 收敛，且 Fourier 变换在实轴上以 sqrt(L) 倍的 L2 误差一致收敛。右侧 Cauchy 级数在该紧带上一致绝对收敛，故与同一 Fourier 极限一致。一般 L2 向量不必具有端点值。

使用 sin^2<=1 并积分，得到

\[
\boxed{
\frac1{2\pi}\int_{|t|\le R_N}|\widehat g(t)|^2dt
\le\epsilon_*\|g\|_2^2,
\quad R_N=\frac{\pi N}{2L},
\quad\epsilon_*=\frac4{3\pi^2}<\frac17.
}
\tag{IC1}
\]

Lean 主声明 `infinite_complement_low_frequency_mass` 证明 dimensionless 密度在 [-N/4,N/4] 上可积及其归一化积分界。输入是两条任意平方可和复序列，没有有限上截止、偶性、实值性、边界消失或谱间隔前提。Fourier 基展开与 Parseval 的上述识别仍为纸面桥，未冒充已形式化。

## 3. 对实际 Gamma、素数幂和极点的完整下界

记

\[
\gamma(t)=\Re\psi_\Gamma(1/4+it/2)-\log\pi.
\]

它在 |t| 上递增，且 gamma(t)>=gamma(0)>-2*pi。对完整 Friedrichs 形式域中的 g，式 (IC1) 和 Plancherel 给出

\[
q_\Gamma(g)\ge
\big[(1-\epsilon_*)\gamma(R_N)+\epsilon_*\gamma(0)\big]\|g\|_2^2.
\]

设

\[
P_a=2\sum_{2\le n\le e^{2a}}\frac{\Lambda(n)}{\sqrt n}.
\]

实际相关函数满足 |C(g,g)(s)|<=||g||_2^2，故素数项至少为 -P_a||g||_2^2。两个极点在完整奇偶空间上的精确贡献为

\[
2|\langle g,\cosh(x/2)\rangle|^2
-2|\langle g,\sinh(x/2)\rangle|^2.
\]

由于

\[
\int_{-a}^a\sinh^2(x/2)dx=\sinh a-a,
\]

极点项至少为 -2(sinh(a)-a)||g||_2^2。于是得到纸面定理：

\[
\boxed{
q_a(g)\ge\beta_{a,N}\|g\|_2^2
\quad\text{对所有 }g\in\operatorname{Dom}(q_a)\cap P_N^\perp,
}
\tag{IC2}
\]

\[
\boxed{
\beta_{a,N}=(1-\epsilon_*)\gamma\!\left(\frac{\pi N}{4a}\right)
+\epsilon_*\gamma(0)-P_a-2(\sinh a-a).
}
\]

量词覆盖无限补空间中的所有允许向量。Gamma 形式积分在其形式域中有定义；有限素数平移及极点项是 L2 上的有界形式。因此同一不等式适用于该 Friedrichs 实现，不额外假定每个向量在算子域中。对偶向量，极点的负 sinh 通道为零，可删除最后一项。

这个下界不假定补空间非负。所有常数由 a、N、Gamma 和不超过 e^(2a) 的素数幂独立给出。

## 4. 一个完全显式的模态截止族

以下初等 Gamma 下界避免在本节另用未经运行的区间 digamma 计算。令 z=alpha+ib，alpha,b>0，并设

\[
f(x)=\frac{x+\alpha}{(x+\alpha)^2+b^2}.
\]

实 digamma 部分分式级数及 H_M-log M 的极限给出

\[
\Re\psi_\Gamma(z)=\lim_{M\to\infty}
\left(\log M-\sum_{n=0}^{M-1}f(n)\right).
\]

每个单位区间上用导数积分控制左 Riemann 和误差，有

\[
\left|\sum_{n=0}^{M-1}f(n)-\int_0^Mf(x)dx\right|
\le\int_0^M|f'(x)|dx\le\frac1b.
\]

最后一个不等式来自 f 最多先增后减且最大值不超过 1/(2b)。其总变差在 alpha<=b 时等于 1/b-f(0)，在 alpha>b 时等于 f(0)，均不超过 1/b。计算积分并取极限，得到

\[
\Re\psi_\Gamma(\alpha+ib)\ge\log|\alpha+ib|-1/b\ge\log b-1/b.
\]

故对 t>0，

\[
\boxed{\gamma(t)\ge\log\frac t{2\pi}-\frac2t.}
\tag{IC3}
\]

本节的 Riemann 和、总变差及 digamma 极限论证是纸面证明，尚未写入 Lean。

令 D_a=2(sinh(a)-a)。对任意实阈值 tau，选自然数 N 满足

\[
N>\max\left\{1,\frac{8a}{\pi},
8a\exp\left(1+\frac{\tau+P_a+D_a+2\pi\epsilon_*}{1-\epsilon_*}\right)\right\}.
\tag{IC4}
\]

将 (IC3) 代入 (IC2)，直接得到 beta(a,N)>tau。因此每个尺度均有明确有限 cutoff，使其无限补空间高于指定阈值；也可沿任何无界尺度序列使用这一公式。固定 a 时 beta(a,N) 趋向正无穷。

代价必须保留：这里对素数项用了绝对值和，未利用算术抵消。该阈值可能非常大，不能据此声称已经获得可实际组装的低维全空间证书。

## 5. 含实际素数平移的具体尺度

取

\[
a=\tfrac12\log3,\qquad N=1024.
\]

素数 2 的平移距离 log2 严格小于窗口直径 log3，因此该窗口确实包含非零素数项。边界处 n=3 的相关函数贡献为零；下面仍把它计入 P_a，保持保守上界。

用 exp 的正项有限 Taylor 和可验证 log2<7/10、log3<11/10，并有 sqrt2>7/5、sqrt3>17/10。因而

\[
P_a<2\left(\tfrac12+\tfrac{11}{17}\right)=\frac{39}{17}.
\]

a<11/20，且 sinh 的正项级数给出

\[
2(\sinh a-a)
\le\frac{(11/20)^3}{3(1-(11/20)^2/20)}<\frac3{50}.
\]

pi>31/10 给出 epsilon_*<1/7。pi<22/7 给出 gamma(0)>-44/7。R_N>1024，而

\[
\gamma(1024)\ge\log(512/\pi)-1/512>4.
\]

最后一个严格界可由 e<3、sqrt3<7/4 核验：exp(9/2)<81*7/4<512/(22/7)，故 log(512/pi)>9/2。

于是

\[
\boxed{
\beta_{\log3/2,1024}>
\frac{24}{7}-\frac{44}{49}-\frac{39}{17}-\frac3{50}
=\frac{7351}{41650}>\frac16.
}
\tag{IC5}
\]

这给出含素数项窗口的整个无限高模态补空间严格正下界。没有据此断言整个 q_a>=1/6，也没有断言前 2049 个 Fourier 模态中的最低特征值单纯。该尺度结果的数学证明为本节的解析及有理数估计，不是浮点特征值实验，也尚未获得完整 Lean 算子证明。

## 6. 剩余有限问题必须保留完整耦合

若某个明确候选 k 已位于 P_NH 中，令 E=P_NH intersect k-perp，Q_N=I-P_N。对 tau=mu+delta<beta(a,N)，完整 (A) 的一个充分条件是

\[
\boxed{
\left.P_N(A_a-\tau)P_N\right|_E
-\frac1{\beta_{a,N}-\tau}
\left.P_NA_aQ_NA_aP_N\right|_E\succeq0.
}
\tag{IC6}
\]

证明是将 f=x+y 分解到 E 和 Q_NH，使用 (IC2) 后配方。只有 beta 由本节独立下界控制；上述有限矩阵不等式尚未对实际候选证明。不能把它当作已成立输入来宣布 (A) 完成。

对算子域中的有限基底，耦合 Gram 可由完整算子图像计算：

\[
G_{ij}=\langle A_ae_i,A_ae_j\rangle
-\sum_{|n|\le N}\langle A_ae_i,e_n\rangle
\langle e_n,A_ae_j\rangle.
\]

零延拓 Fourier 基属于本算子的形式域和算子域：其 Fourier 变换 O(1/|t|)，Gamma 乘子为 O(log(2+|t|))，故 Gamma 乘子作用后仍在 L2；有限平移与极点项有界。对应 Friedrichs 形式配对的表示向量是压回窗口后的这些完整算子项。该定义域识别仍是纸面桥。

同样，对有限候选，实际算子残差满足

\[
\boxed{
\|(A_a-\mu)k\|_2^2
=\|P_N(A_a-\mu)k\|_2^2+\|Q_NA_ak\|_2^2.
}
\tag{IC7}
\]

第二项不会因为有限矩阵的 Gamma 积分算得很准而消失。候选来自 prolate 模型时，还需把原模型与所选有限 Fourier 近似的误差计入，而非假设原模型已经属于 P_NH。

## 7. 本节消除的假设和下一承重边

纸面上，补空间的下界与某个阈值以上的 cutoff 存在性已被显式 (IC2)–(IC4) 替代，并有 (IC5) 的含素数实例。Lean 保存的是支撑此结论的无限序列低频质量估计，含绝对收敛与可积性；真实 Fourier/L2 接口、完整算术形式和阈值例证尚未全部形式化。

剩余承重边是对明确候选认证 (IC6) 中的有限算术块与完整耦合，并让 (IC7) 的全算子残差相对于所得谱间隔足够小。对素数项的粗绝对值处理会放大 N；下一步应保持 prime/pole/boundary 抵消，改进这两个有限矩阵量，而非继续添加抽象 Schur 包装。

未证明无界尺度的最低模态单纯偶性，未证明条件 (C)，未证明真实最低模态 Fourier 变换收敛到 Xi，未证明 RH。本节的投影和 Fourier 估计属于经典工具的具体应用，未作原创优先权声明。

---

## [PR #5602] ARITHMETIC_COUPLING_AND_PRIME3_GROUND_MODE

# 2026-09-06：具体算术耦合与一个含素数窗口的单纯偶最低模态证书

Lean：`D5/S3/Weil/ZetaBridge/WeilArithmeticCouplingJet.lean`。
Scribe：`Blueprint/D5/S3/Weil/ZetaBridge/WeilArithmeticCouplingJet.scribe.cs`。
可复验程序：`research/weil_ground_mode/certify_prime3.py`。
本次实际输出：`research/weil_ground_mode/prime3_certificate.json`。

本节将前面的无限高模态下界接到具体算术耦合，完成一个固定含素数窗口的计算机辅助余维一强制性证明。Lean 保存算术边界符号的绝对收敛、独立统一上界及逐外部模态的耦合余项。完整 Fourier/算子域识别、无限 Gram 尾项求和、区间计算的正确性及变分推论属于以下纸面与计算机辅助证明，尚未组成 Lean 内核定理。Lean 和 Scribe 编译没有在本环境运行。本文不将数值 LDL 的通过等同于 Lean 编译通过。

## 1. 同一 Weil 对象及文献接口

继续使用上一节的 L=2a、正交归一基 e_n 和 Fourier 约定。闭形式为

\[
q_a(f)=\frac1{2\pi}\int_{\mathbb R}\gamma(t)|\widehat f(t)|^2dt
+2\Re\{\widehat f(i/2)\overline{\widehat f(-i/2)}\}
-2\sum_{2\le j<e^L}\frac{\Lambda(j)}{\sqrt j}\Re C(f,f)(\log j).
\]

端点 j=e^L 若为整数，其相关函数值为零。Gamma 乘子仍是既有 gammaBracket，未改变素数、极点或边界归一化。先在紧支撑光滑核心比较 `literatureRHS(weilTest f f)`，随后取同一个闭形式的 Friedrichs 实现。有限基向量的 Fourier 变换为 O(1/|t|)，gamma(t)=O(log(2+|t|))，因此 gamma*hat(e_n) 属于 L2；有限素数平移和两个极点项有界。对应的压回窗口表示向量证明 e_n 属于该算子域。这里不要求 e_n 属于 A_a 的平方定义域。

Connes–Consani–Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1，Lemma 2.3、Proposition 3.2 和 Section 4 给出本节使用的 Fourier 矩阵计算。Suzuki, arXiv:2606.09096v1，Theorem 1.1 及形式域分析提供闭形式实现与紧 resolvent 的接口。Groskin, arXiv:2607.02828v1 已有有限矩阵的 cutoff-free 组装和区间 LDL 方法。本节保留该文献背景，新增任务是认证全部无限耦合后的余维一估计。

另检索到 Kim 等人的 arXiv:2607.24830，研究 Suzuki 算子的数值实现和第一个素数阈值。本节不把有限特征值数值稳定当作全空间证明，也不提出首创优先权声明。Connes–van Suijlekom 的实零点结论仍须承接它规定的分布、核心和算子条件；本文没有仅由自伴性直接推出实零点。

## 2. 具体算术边界符号与除差矩阵

以下令 c>=2 为整数，L=log c，omega_n=2*pi*n/L，beta_r=2r+1/2。定义

\[
\begin{aligned}
s_c(n)={}&-\frac{2\omega_n(\cosh(L/2)-1)}{\omega_n^2+1/4}\\
&-\sum_{r\ge0}\frac{\omega_n(1-e^{-\beta_rL})}{\beta_r^2+\omega_n^2}
-\sum_{2\le j<c}\frac{\Lambda(j)}{\sqrt j}\sin(\omega_n\log j).
\end{aligned}
\tag{AC1}
\]

这是一个由实际算术数据独立构造的实奇序列。它不使用未知最低特征函数或零点位置。设 K(t)=e^{-t/2}/(1-e^{-2t})。对 n!=m，相关函数偶化为

\[
C(e_n,e_m)(t)+C(e_n,e_m)(-t)
=\frac{\sin(\omega_nt)-\sin(\omega_mt)}{\pi(m-n)},\qquad 0\le t\le L.
\]

将其代入完整 Weil 形式，使用 K(t)=sum_r exp(-beta_r*t)，以及 exp(i*omega_n*L)=1，得到

\[
\boxed{A_{nm}=\frac{s_c(n)-s_c(m)}{\pi(m-n)},\qquad n\ne m.}
\tag{AC2}
\]

这一步保留 prime、pole 和 Gamma 的完整耦合。Gamma 逐项积分可由 |sin(omega*t)|<=|omega|*t 和 sum beta_r^-2<infinity 正当化。

对角元同样有精确公式。记 z_n=1/4+i*omega_n/2，psi_1 为 trigamma：

\[
\begin{aligned}
A_{nn}={}&\gamma(\omega_n)+\frac{\Re\psi_1(z_n)}{2L}
-\frac2L\sum_{r\ge0}e^{-\beta_rL}\Re(\beta_r-i\omega_n)^{-2}\\
&+\frac{4(\cosh(L/2)-1)}L\Re(1/2+i\omega_n)^{-2}\\
&-2\sum_{2\le j<c}\frac{\Lambda(j)}{\sqrt j}
\left(1-\frac{\log j}L\right)\cos(\omega_n\log j).
\end{aligned}
\tag{AC3}
\]

例如 Gamma 项可先写成

\[
\gamma(\omega_n)+\frac2L\int_0^LtK(t)\cos(\omega_nt)dt
+2\int_L^\infty K(t)\cos(\omega_nt)dt.
\]

延长第一个积分到正半轴后，剩余尾项是 -(2/L)*integral_L^infinity (t-L)K(t)cos(omega_n*t)dt，给出 (AC3)。因此对角公式中的 trigamma 系数和指数尾项符号都有直接检查。

## 3. 已提交 Lean：算术符号有独立统一界

令

\[
B_c=2\cosh(L/2)+\sum_{0\le j<c}\left|\Lambda(j)/\sqrt j\right|.
\]

则

\[
\boxed{|s_c(n)|\le B_c\quad(n\in\mathbb Z).}
\tag{AC4}
\]

Gamma 部分的证明没有假设这个上界。令 w>=0，d_j=w+2j+1/2，有

\[
\frac w{(2j+5/2)^2+w^2}
\le w\left(d_j^{-1}-(d_j+2)^{-1}\right).
\]

分母交叉相乘后，差由 (w-2j-3/2)^2 和非负余项控制。对所有有限部分和望远镜求和，再加第零项 w/(1/4+w^2)<=1，得到

\[
\sum_{r\ge0}\frac w{(2r+1/2)^2+w^2}\le2.
\]

这也给出绝对收敛。因 0<=1-exp(-beta_r*L)<=1，(AC1) 的 Gamma 级数被同一正级数支配。极点的绝对值最多为 2(cosh(L/2)-1)，有限素数项的绝对值最多为权重绝对值和。三者相加得到 (AC4)。

Lean 主声明 `arithmetic_boundary_symbol_bound` 同时保存实际 Gamma 级数的绝对收敛与 (AC4)。没有以 RH、Gamma 尾项正性、谱间隔或一个待证明的算子范数作为输入。

## 4. 已提交 Lean：保留两个边界矩的耦合余项

对支撑于 |n|<=N 的任意有限复向量 v，记

\[
a_0(v)=\sum v_n,\qquad b_0(v)=\sum s_c(n)v_n,
\qquad d_m(v)=\sum_{|n|\le N}A_{nm}v_n.
\]

每个 |m|>N 都满足

\[
\boxed{
d_m(v)=\frac{b_0(v)-s_c(m)a_0(v)}{\pi m}+R_m(v),
\quad
|R_m(v)|\le\frac{2B_cN}{\pi|m|(|m|-N)}\sum|v_n|.
}
\tag{AC5}
\]

其承重恒等式是

\[
\frac{s_n-s_m}{\pi(m-n)}-\frac{s_n-s_m}{\pi m}
=\frac{(s_n-s_m)n}{\pi m(m-n)}.
\]

Lean 主声明 `arithmetic_coupling_first_jet_error` 对任意有限整数索引集和复系数证明该误差。内部半径 N 可以是任意非负实数，外部没有有限上截止。两个边界矩没有被强行置零。

对整数 M>N，将 (AC5) 平方求和，保留边界矩，得到纸面结论

\[
\boxed{
\sum_{|m|>M}|d_m(v)|^2
\le\frac8{\pi^2M}\left(|b_0(v)|^2+B_c^2|a_0(v)|^2\right)
+\epsilon_{N,M}\|v\|^2,
}
\tag{AC6}
\]

\[
\boxed{
\epsilon_{N,M}=\frac{16B_c^2N^2(2N+1)}{\pi^2(1-N/M)^2M^3}.
}
\]

这里分别使用 |x+y|^2<=2|x|^2+2|y|^2、sum_{m>M}m^-2<=1/M，以及 sum_{m>M}m^-4<=M^-2*sum m^-2<=M^-3。没有使用更小的 1/(3M^3) 常数。有限 Cauchy–Schwarz 给出 (sum|v_n|)^2<=(2N+1)||v||^2。

因此，全部无限耦合的剩余 Gram 块有一个显式正的秩至多二修正和一个三次衰减的标量余量。它有参数 c,N,M，可以用于无界尺度族；本节并未证明所得全尺度有限矩阵均满足所需强制性。

## 5. c=3 的无限高模态块可在 N=64 处认证

取

\[
c=3,\quad L=\log3,\quad a=L/2,\quad N=64.
\]

只有素数 2 在内部真正起作用。令 h=log2，则 L<2h。压回 I 的平移 U_h 与 U_h^* 的输出支撑互不相交，输入所覆盖的两段也互不相交。因此

\[
\|(U_h+U_h^*)f\|^2=\|U_hf\|^2+\|U_h^*f\|^2\le\|f\|^2.
\]

所以实际素数项的下界改进为 -(log2/sqrt2)||f||^2。这里没有将有限素数矩阵的特征值当作整个平移算子的界。

令 eps=4/(3*pi^2)、R=pi*N/(4*a)。利用上一节无限 Fourier 补空间的低频质量界，全部高模态满足

\[
q_a(y)\ge\beta\|y\|^2,\qquad
\beta=(1-\mathrm{eps})\gamma(R)+\mathrm{eps}\gamma(0)
-\frac{\log2}{\sqrt2}-2(\sinh a-a).
\]

Gamma 的独立下界通过正级数构造：

\[
\gamma(0)=-\gamma_E-\pi/2-3\log2-\log\pi,
\]

\[
\gamma(R)\ge\gamma(0)+\sum_{j=0}^{511}
\frac{(R/2)^2}{(j+1/4)((j+1/4)^2+(R/2)^2)}.
\]

省略项全部非负。区间程序验证该下界给出的 beta>1.04126>1，同时 B_3<3。因此后续只使用精确保守常数 beta=1、B=3。与上一节 N=1024 的粗实例相比，这里真正利用了首个素数平移的支撑结构。

## 6. 实际运行的有限算术与无限耦合证书

固定 M=32768、tau=1/1000000。文件中的 CANDIDATE 是一个已固定、非零、偶的 129 维 dyadic 向量 v，分母为 2^40，索引按 -64,...,64 排列。令 k=v/||v||。候选由一次有限矩阵探索得到后被写成整数常量；认证程序不会调用特征向量求解器，也不会用未知真实最低模态替换候选。

程序以区间运算计算 (AC2)–(AC3)，并验证

\[
\mu=\langle k,A_ak\rangle
\in[5.6090783527\ldots,5.6090823856\ldots]\,10^{-8}
<10^{-7}.
\tag{AC7}
\]

上式的小数仅供显示；实际检查比较的是完整区间和精确有理阈值。程序还计算全部 64<|m|<=32768 的耦合行。每项区间被量化为分母 2^40 的 dyadic 数，逐项验证误差小于 2^-38。设量化矩阵为 C_q，其 Gram 矩阵 G_q=C_q^*C_q 以整数分块乘法精确求和，检查每一步均不会溢出。

设 e^2=2(M-N)(2N+1)*2^-76。精确有理数检查给出 ||C_q||_F<4，以及

\[
64e^2<(10^{-7}-e^2)^2,\quad e^2<10^{-7}.
\]

因此量化造成的 Gram 算子误差小于 eta=10^-7。全部 |m|>M 的尾部由 (AC6) 覆盖，其标量余项小于 1/4000000。令 s=(s_3(n))_{|n|<=64}、one=(1,...,1)，定义

\[
\overline G=G_q+\frac8{\pi^2M}(ss^*+9\,\mathrm{one}\,\mathrm{one}^*)
+\left(\frac1{10^7}+\frac1{4000000}\right)I.
\]

则完整耦合 C_N=Q_NA_a|_{P_NH} 满足 C_N^*C_N<=overline(G)。这里始终使用有界有限域映射 C_N 的 Gram，不要求 A_a^2 的定义域。

最终认证的矩阵为

\[
\boxed{
H=A_N-\tau I-\frac{\overline G}{1-\tau}+vv^*\succ0.
}
\tag{AC8}
\]

反射对称在精确算术上成立，G_q 的反射对称也由整数检查确认。程序在 e_0,e_j+e_-j 的 65 维偶块和 e_j-e_-j 的 64 维奇块分别作区间 LDL。两个块的全部主元严格为正；最小主元下端点的显示值分别约为 0.2649730942 和 0.03969194858。这些是 LDL 主元，不是矩阵特征值下界。

## 7. 区间与特殊函数误差的验证边界

有限矩阵及常数使用 mpmath.iv 的 45 位区间运算。大批耦合行只用 IEEE binary64 的基本四则运算，每一步用 nextafter 向外舍入。sin 与 arctan 使用明确区间多项式及余项，未假设系统 libm 的超越函数正确舍入。

arctan 约化后 |x|<0.501，保留 36 个奇次项，余量用 0.501^73/73<10^-23 控制。sin 约化后 |x|<3.15，保留至 49 次，余量用 3.15^50/50!<10^-38 控制。这些比较使用精确有理数核验。约化整数只用于选取等价公式，最终区间范围检查承担有效性。

digamma 和 trigamma 用 z->z+16 的精确递推以及至 B_20 的 Euler–Maclaurin 展开。对 Re Z=65/4，周期 Bernoulli 积分余项给出

\[
|R_\psi(Z)|\le\frac{|B_{20}|}{20(65/4)^{20}}<2\,10^{-23},
\qquad
|R_{\psi_1}(Z)|\le\frac{|B_{20}|}{(65/4)^{21}}.
\]

这些界来自 Hurwitz zeta 的 Euler–Maclaurin 余项在 s=1 的有限部分及其 z 导数；|periodic B_20|<=|B_20|，积分绝对值由实部控制。可对照 DLMF 25.11(iii)、5.11。c=3 时指数尾项按 9^-r 衰减，保留 32 项后显式控制省略部分。

大 Gram 的哈希是

`6f93db1396440d4cd436594dce755d341f135ce554adf89c001474a384655473`。

实际运行环境是 Python 3.13.5、NumPy 2.3.5、mpmath 1.3.0、SymPy 1.14.0。JSON 记录运行源文件 SHA-256、固定候选、预算和全部通过状态。可用 `python research/weil_ground_mode/certify_prime3.py` 复验；程序禁止 Python 的 -O 模式，以免跳过断言。

该证书依赖所列区间实现、IEEE 基本运算、整数运算和解释器。它尚未被 Lean 内核重放。本节不宣称区间软件已形式化，也没有运行 GitHub CI。

## 8. 从具体证书得到全形式域上的余维一强制性

对任意 f 属于 Dom(q_a) 且 f 与 k 正交，分解 f=x+y，其中 x=P_Nf、y=Q_Nf，则 x 与 v 正交。(AC8) 给出

\[
q_a(x)-\tau\|x\|^2\ge\frac{\|C_Nx\|^2}{1-\tau}.
\]

上一节已证明 q_a(y)>=||y||^2。因 x 属于算子域，完整混合配对是 <A_ax,y>，故配方得到

\[
\begin{aligned}
q_a(f)-\tau\|f\|^2
&\ge\frac{\|C_Nx\|^2}{1-\tau}+2\Re\langle C_Nx,y\rangle
+(1-\tau)\|y\|^2\\
&=(1-\tau)\left\|y+\frac{C_Nx}{1-\tau}\right\|^2\ge0.
\end{aligned}
\]

因此本轮纸面与区间认证共同给出固定尺度结论

\[
\boxed{
a=\tfrac12\log3,\quad f\perp k
\quad\Longrightarrow\quad
q_a(f)\ge10^{-6}\|f\|^2
\quad(f\in\operatorname{Dom}(q_a)).
}
\tag{AC9}
\]

结合 mu<10^-7，可取 delta=tau-mu>9*10^-7。紧 resolvent 与变分原理于是给出

\[
\lambda_0\le\mu<10^{-7},\qquad
\lambda_1\ge10^{-6},\qquad
\lambda_1-\lambda_0>9\,10^{-7}.
\]

最低特征值因此单纯、孤立。算子保反射，候选 k 为偶；若该唯一最低模态为奇，则它属于 k 的正交补，违背上述严格能量分离。因此最低模态为偶函数。这是完整算子的固定窗口结论，已经计入所有无限耦合方向。

## 9. 当前完成范围与剩余研究

本节在 c=3 处将单纯性、偶性和隔离从假设推进为纸面与计算机辅助证明。Lean 真源只覆盖 (AC4) 和 (AC5) 对应的实际算术收敛及余项，不包括 (AC9) 的完整内核验证。

本候选是独立固定的有限 Fourier 函数，尚未被识别为文献的 prolate 候选。没有证明它与真实最低模态的残差/间隔比达到条带极限所需尺度，也没有证明上述强制性沿 c->infinity 成立。完整最低特征值的非负性亦未由本证书推出，因为它只给出 lambda_0 的上界及其余方向的下界。

后续应利用 (AC1)–(AC6) 的参数化结构，保持算术抵消，推进无界尺度族与实际全算子残差；同时将 Fourier 识别、闭形式接口和区间有理证书接成可内核重放的证明。当前没有证明条件 (C)、真实最低模态 Fourier 变换的 Xi 极限或 RH。

参考：

- https://arxiv.org/html/2511.22755v1
- https://arxiv.org/html/2511.23257v1
- https://arxiv.org/html/2606.09096v1
- https://arxiv.org/html/2607.02828v1
- https://arxiv.org/abs/2607.24830
- https://dlmf.nist.gov/25.11
- https://dlmf.nist.gov/5.11

---

## [PR #5602] SECOND_JET_RAYLEIGH_ENCLOSURE_AND_REAL_ZEROS

# 2026-09-06：完整正下包络、射影模态误差与固定窗口的实零点极限

本节补齐上一轮 `WeilRayleighEnclosureModeCapture` 与 `WeilArithmeticCouplingSecondJet` 的理论说明，并记录本轮 `WeilArithmeticCouplingParityGram`、`certify_prime3_refined.py` 和实际输出 `prime3_refined_certificate.json`。三个 Lean owner 均有对应 Scribe。Lean elaboration、`#print axioms` 和 Scribe compiler 未在本环境执行；下面明确区分源码中的证明脚本、纸面推导和已执行的区间计算。

## 1. 三个认证数取代未量化的近基态断言

固定同一闭 Weil 形式及其自伴实现 A。设归一化候选 k 属于算子域，真实归一化最低模态 u 满足 Au=lambda*u。记 mu=q(k)。已证的变分关系为 lambda<=mu。若实际算术证书给出

\[
ell\le\lambda\le\mu\le U<T,\qquad
f\perp k\Longrightarrow q(f)\ge T\|f\|^2,
\tag{RE1}
\]

则可以直接用能量包络捕获最低模态。这里 ell 是完整算子的下界，不能用有限 Ritz 最低值充当 ell；T 的量词覆盖全部形式域中的正交方向。

令 alpha=<k,u>、v=u-alpha*k，内积对第二变量线性。由对称性及特征方程，

\[
\langle v,Ak\rangle=\overline\alpha(\lambda-\mu),\qquad
q(v)=\lambda\|v\|^2+|\alpha|^2(\mu-\lambda).
\tag{RE2}
\]

因 v 与 k 正交，得到

\[
(T-\lambda)\|v\|^2\le|\alpha|^2(\mu-\lambda).
\tag{RE3}
\]

此前 Lean owner `WeilRayleighEnclosureModeCapture` 在实不变线性算子域 D 上，以嵌入 iota:D->H 和作用 A:D->H 证明了较松的

\[
(T-U)\|v\|^2\le U-ell.
\]

该表示允许非有界算子；没有把真实 Weil 算子替换为处处有定义的有限矩阵。到实际复 Hilbert 空间的实不变域识别另需承接。本节的复数版 (RE2) 及以下射影加强为纸面证明。

若 alpha=0，则 v=u，(RE3) 与 T>lambda、||u||=1 矛盾。所以 alpha 非零。保留 (RE3) 中的重叠因子可直接得到

\[
\boxed{
\left\|\frac{u}{\alpha}-k\right\|^2
\le\frac{\mu-\lambda}{T-\lambda}
\le\frac{U-ell}{T-ell}<1.
}
\tag{RE4}
\]

第二个不等式先使用 mu<=U，再使用 x->(U-x)/(T-x) 在 x<T 上递减及 ell<=lambda。最后一个严格不等式直接来自 U<T。因此无需额外假设前一轮松预算 R=(U-ell)/(T-U)<1，也无需再将其放大为 R/(1-R)。归一化的改变只有非零标量，不改变 Fourier 变换的零点。

若某个独立模型族 k_a 已有 c_a*hat(k_a)->Xi 的条带紧集一致极限，则 (RE4) 与固定支撑 Fourier 估计给出新的充分条件

\[
\boxed{
|c_a|\sqrt{2a}\,e^{ba}
\sqrt{\frac{U_a-ell_a}{T_a-ell_a}}\longrightarrow0
\qquad(0\le b<1/2).
}
\tag{RE5}
\]

本节没有证明这条无界尺度极限。还需证明所选有限候选与文献 prolate 模型之间的相容性。

修正此前会话中的过强判断：换成 Rayleigh 包络并不证明已经绕过固定内缩平移障碍。它改变了可认证的误差量；该误差量能否在所需候选尺度族上衰减，仍是数学任务。尤其不能将另一个已知 Xi 极限的模型和本次有限候选默认为同一对象。

## 2. 已提交的二阶算术 jet 与实际反射奇性

沿用本卷 (AC1) 的真实算术符号 s_c(n)，以及

\[
A_{nm}=\frac{s_c(n)-s_c(m)}{\pi(m-n)}\quad(n\ne m),\qquad |s_c(n)|\le B_c.
\]

从

\[
\frac1{m-n}=\frac1m+\frac n{m^2}+\frac{n^2}{m^2(m-n)}
\]

得到已有 `WeilArithmeticCouplingSecondJet` 主定理：对任意复系数及 |m|>N，

\[
|d_m(v)-J_m(v)|\le
\frac{2B_cN^2}{\pi|m|^2(|m|-N)}\sum_{|n|\le N}|v_n|,
\tag{PJ1}
\]

其中

\[
J_m(v)=\frac{B_0-s_c(m)A_0}{\pi m}
+\frac{B_1-s_c(m)A_1}{\pi m^2},
\]

\[
A_0=\sum v_n,\quad B_0=\sum s_c(n)v_n,\quad
A_1=\sum nv_n,\quad B_1=\sum n s_c(n)v_n.
\]

没有将任何边界矩设为零。新增 `WeilArithmeticCouplingParityGram.arithmetic_boundary_symbol_neg` 从实际 pole、Gamma 级数和有限 von Mangoldt 正弦项逐项推出

\[
s_c(-m)=-s_c(m).
\tag{PJ2}
\]

在 c>=2 的算术范围，Gamma 级数的绝对收敛已由前置真源独立证明。

令

\[
X_m=-s_c(m)A_0+B_1/m,\qquad Y_m=B_0-s_c(m)A_1/m.
\]

则 J_m=(X_m+Y_m)/(pi*m)、J_-m=(X_m-Y_m)/(pi*m)。新增 Lean 主定理 `arithmetic_second_jet_pair_energy` 对任意复向量证明

\[
\boxed{
|J_m|^2+|J_{-m}|^2
=\frac2{\pi^2m^2}(|X_m|^2+|Y_m|^2).
}
\tag{PJ3}
\]

这是复内积空间 parallelogram identity 在既有真实算术 jet 上的应用。系数无需为偶或实，有限索引集无需反射闭合。

## 3. 两个正的矩 Gram 块及完整无限尾

(PJ3) 对正整数 m>M 求和，将 jet 能量分成两个 2x2 正半定矩块。对 (A0,B1) 的块为

\[
\frac2{\pi^2}\sum_{m>M}
\begin{pmatrix}
s_m^2/m^2&-s_m/m^3\\
-s_m/m^3&1/m^4
\end{pmatrix},
\]

对 (B0,A1) 的块为

\[
\frac2{\pi^2}\sum_{m>M}
\begin{pmatrix}
1/m^2&-s_m/m^3\\
-s_m/m^3&s_m^2/m^4
\end{pmatrix}.
\]

每项是一个实行向量的 Gram，因而正性不依赖符号猜测。|s_m|<=B 保证各项绝对可和。这里保留的交叉矩 sum s_m/m^3 可以在后续获得更锋利的证书。本次计算使用下述更保守且独立的四矩上界，并未声称实际计算了这两个精确无限块。

利用 |x+y|^2<=2|x|^2+2|y|^2、(PJ1)、(PJ3)、有限 Cauchy-Schwarz 和

\[
\sum_{m>M}m^{-2}\le M^{-1},\quad
\sum_{m>M}m^{-4}\le M^{-3},\quad
\sum_{m>M}m^{-6}\le M^{-5},
\]

得到纸面定理

\[
\boxed{
\begin{aligned}
\sum_{|m|>M}|d_m(v)|^2\le{}&
\frac8{\pi^2}\left[
\frac{B^2|A_0|^2+|B_0|^2}{M}
+\frac{B^2|A_1|^2+|B_1|^2}{M^3}\right]\\
&+\epsilon^{(2)}_{N,M}\|v\|^2,
\end{aligned}
}
\tag{PJ4}
\]

\[
\boxed{
\epsilon^{(2)}_{N,M}=
\frac{16B^2N^4(2N+1)}{\pi^2(1-N/M)^2M^5}.
}
\tag{PJ5}
\]

具体地，两个余项的平方和不超过
8*B^2*N^4*(sum|v_n|)^2/[pi^2*(1-N/M)^2*m^6]；再由 actual=jet+remainder 的二倍平方界得到 (PJ5) 中的 16。上述支配同时证明 square summability。完整无限求和仍是纸面桥，不能把 Lean 的逐模态等式标成整个 Gram 尾已内核验证。

## 4. 实际执行的 c=3 精化证书

保持 a=log3/2、N=64、M=32768 及前一节的同一 129 维 dyadic 偶候选 v，令 k=v/||v||。本轮不使用 zeta 零点或真实最低特征向量作为输入，认证程序中也没有特征向量求解器。

高模态正下界继续由实际 Gamma 正级数、prime-2 压缩平移的支撑几何及极点负通道给出。区间程序重新验证

\[
beta>1.04126433194457,\qquad B_3<3,
\]

因此在完整无限空间 Q_NH 上仍保守使用 q(y)>=||y||^2。数字 beta 只是显示，程序比较的是区间与精确常数 1。

本次不再把所有耦合条目误差统一替换为同一个最坏上界。正外部行的近似条目量化为 2^-44 的整数倍；每项的向外舍入误差半径再向上量化为 2^-60 的整数倍。令整数半径为 r_mn，则完整正负耦合误差满足

\[
\|E\|_F^2\le e^2=2\sum_{m,n}r_{mn}^2\,2^{-120}.
\]

求和采用整数运算，并在运算前核验 int64 不溢出。反射将负模态 Gram 精确识别为正模态 Gram 的逆序共轭。完整 Gram G_q 使用分块整数乘积精确构造。实际运行得到

\[
e^2=\frac{2249064940320895}
{664613997892457936451903530140172288}.
\]

设 eta=10^-10。程序以精确有理数验证

\[
e^2<eta,\qquad4\operatorname{tr}(G_q)e^2<(eta-e^2)^2.
\]

由 ||C_q||<=||C_q||_F 得到

\[
\|C^*C-G_q\|\le2\sqrt{\operatorname{tr}(G_q)}\sqrt{e^2}+e^2<eta.
\]

这把旧的 10^-7 Gram 量化预算压到 10^-10，且没有假定 BLAS 浮点矩阵乘积精确。

(PJ5) 在相同参数上的解析余项小于 9*10^-13。写 s=(s_3(n))、t=(n)、b=(n*s_3(n))、one=(1)，完整耦合 Gram 的认证上界为

\[
\overline G=G_q+
\frac8{\pi^2}\left[
\frac{ss^*+9\,one\,one^*}{M}
+\frac{bb^*+9tt^*}{M^3}\right]
+(10^{-10}+9\cdot10^{-13})I.
\tag{PC1}
\]

每个矩阵条目仍按实际 s 值取区间。PC1 控制的是 C_N^*C_N，其中 C_N=Q_NA|P_NH；没有对 A^2 的定义域作假设。

## 5. 完整算子首次在本 PR 得到双边正包络

定义精确有理常数

\[
ell=\frac{103}{2000000000},\qquad
U=\frac{560909}{10000000000000},\qquad
T=\frac1{200000}.
\tag{PC2}
\]

同一算术矩阵、同一完整耦合上界及同一固定候选通过了两个区间 LDL 检验：

\[
\boxed{A_N-ell I-\frac{\overline G}{1-ell}\succ0,}
\qquad
\boxed{A_N-TI-\frac{\overline G}{1-T}+vv^*\succ0.}
\tag{PC3}
\]

两者分别在 e0、ej+e-j 的偶块和 ej-e-j 的奇块上作非正交基的精确合同变换。最小 LDL 主元下端点的显示值分别为

| 检验 | 偶块 | 奇块 |
|---|---:|---:|
| 完整下界 | 0.0031531449201242043 | 0.03974454928419704 |
| 候选正交补 | 0.2649527465156704 | 0.03954403713951146 |

这些主元用于证明矩阵正定，不能当作矩阵的最小特征值界。

候选 Rayleigh 商仍由实际完整算术矩阵算出，其区间为

\[
mu\in[5.6090783527585\ldots,5.6090823855575\ldots]\cdot10^{-8}<U.
\]

对任意形式域向量 f=x+y，x=P_Nf、y=Q_Nf，使用 q(y)>=||y||^2，并对每个 shift=ell,T 配方。第一个矩阵检验给出所有 f 上的完整下界；第二个检验在 f 与 k 正交时消去 vv^* 项。由此得到

\[
\boxed{q(f)\ge ell\|f\|^2\quad\text{对全部 }f\in\operatorname{Dom}(q),}
\]

\[
\boxed{f\perp k\Longrightarrow q(f)\ge T\|f\|^2.}
\tag{PC4}
\]

这是纸面算子识别、无限尾估计和已执行区间证书共同给出的固定尺度结果。PC4 尚未成为 Lean 中完整算子定理。

紧 resolvent 和 min-max 原理于是给出

\[
5.15\cdot10^{-8}\le\lambda_0<5.60909\cdot10^{-8},
\qquad\lambda_1\ge5\cdot10^{-6},
\]

\[
\lambda_1-\lambda_0>4.943909\cdot10^{-6}.
\tag{PC5}
\]

唯一最低模态为偶：若其反射本征值为 -1，则该模态与偶候选 k 正交，与 lambda0<T 矛盾。实际算子还保复共轭，所以该单纯最低线可选取实偶归一化代表。

由 (RE4) 得到本次真正的模态捕获数字

\[
\boxed{
\left\|u/\langle k,u\rangle-k\right\|^2
\le\frac{U-ell}{T-ell}
=\frac{15303}{16495000}
<\left(\frac{61}{2000}\right)^2.
}
\tag{PC6}
\]

因而射影重归一化后的真实最低模态与明确候选的 L2 距离严格小于 0.0305。

## 6. 实际运行与可信计算边界

完整可复验源为 `research/weil_ground_mode/certify_prime3_refined.py`，SHA-256：

`8bb067fc5499b0f2e1e48836e7a82237a15504109f82a856c72478d1096d69d0`。

实际输出为 `research/weil_ground_mode/prime3_refined_certificate.json`，其中记录精确 Gram SHA-256：

`7f4e1049624807432efe96a68fe63babbc1c3bd37f2d40600a4cddadbddb85a9`。

运行使用 Python 3.13.5、NumPy 2.3.5、mpmath 1.3.0、SymPy 1.14.0。有限矩阵采用 55 位区间；向量化耦合使用每步 nextafter 向外舍入的 binary64 基本运算。正弦、反正切、digamma、trigamma 和指数尾项保留前一节已经说明的独立余项。量化、整数 Gram 及半径平方和均有运算前的精确溢出检查。认证以全部区间严格比较通过为准，JSON 中的十进制主元仅作显示。

程序已实际运行；没有把数值探索当成认证。该计算依赖所列区间实现、IEEE 基本运算、整数实现与 Python 解释器；这些实现未被 Lean 形式化。新 Lean 文件中没有 sorry、admit 或新公理声明，但 #print axioms 未执行，不能据此称整条证明链已内核闭合。

## 7. 固定窗口的真实最低模态 Fourier 变换只有实零点

本节补上一条纸面文献桥，使固定窗口结论真正到达实零点对象。它不直接把自伴性代入 Connes-van Suijlekom 的 Theorem 6.1。该定理的精确陈述要求规定的分布二次型及三角多项式域上的本质自伴性。以下使用他们的有限维 Theorem 5.6，并显式通过同一 Weil 形式的 form core 取极限。

令 P_JH 为 |n|<=J 的完整奇偶 Fourier 空间，J>=64，A_J 为真实 q 在其上的矩阵。由 PC4，任意 J>=64 都有

\[
\lambda_{0,J}\le mu<T,\qquad\lambda_{1,J}\ge T.
\]

因此其最低特征值单纯，且由同一偶候选排除奇性。矩阵

\[
Q_J=A_J-\lambda_{0,J}I
\]

正半定并有一维偶核。其对角值为偶序列，非对角值精确为

\[
(Q_J)_{nm}=\frac{b_n-b_m}{n-m},\qquad b_n=-s_c(n)/\pi,
\quad b_{-n}=-b_n.
\]

这正是 Connes-van Suijlekom (11) 的矩阵类；减去实标量对角不改变该结构。Theorem 5.6(ii) 应用于这个实际矩阵，给出对应三角函数的 Fourier 变换只有实零点。其 [0,1] 坐标经 y=x/L+1/2 变为本卷的 e_n=(-1)^n*L^-1/2*exp(2*pi*i*n*x/L)；平移只乘无零点指数，实尺度变换及 Fourier 正负号变换保持实零点性。

实际 Weil 形式的三角多项式 form-core 性由 Connes-Consani, Spectral triples and zeta-cycles, arXiv:2106.01715v1, Lemma 2.2 及 Proposition 2.3 给出；Suzuki, arXiv:2606.09096v1, Lemma 3.1 的证明及 Section 3.2 明确复述并用于同一个 Q_W^a。故 Rayleigh-Ritz 最低值满足

\[
\lambda_{0,J}\downarrow\lambda_0.
\]

设 u_J 为相位与 u 对齐的归一化有限最低模态，分解 u_J=alpha_J*u+w_J，w_J 与 u 正交。完整算子谱间隔给出

\[
\|w_J\|^2\le
\frac{\lambda_{0,J}-\lambda_0}{T-\lambda_0}\longrightarrow0,
\]

从而 u_J->u in L2。同一固定支撑 [-a,a] 上，

\[
\sup_{z\in K}|\widehat u_J(z)-\widehat u(z)|
\le\sqrt{2a}\,e^{a\sup_K|\Im z|}\|u_J-u\|_2\longrightarrow0
\]

对每个复紧集 K 成立。u 非零，Fourier 唯一性保证 hat(u) 非恒零。分别在上、下半平面应用 Hurwitz，得到

\[
\boxed{\widehat u(z)=0\Longrightarrow z\in\mathbb R
\quad\text{在本次 }a=\tfrac12\log3\text{ 的固定窗口}.}
\tag{RZ1}
\]

这里的无限极限是 J->infinity 且 a 固定；它没有证明 a->infinity 时 hat(u_a) 的归一化极限是 Xi。RZ1 是文献有限维定理、既有 form-core 性与本次完整算术证书的纸面推论，尚未接成 Lean 的解析零点定理。

## 8. 文献比较与下一条真正承重的误差

Connes-Consani-Moscovici, arXiv:2511.22755v1, Lemma 7.3 已给出明确 prolate 模型 k_lambda 的 Xi 极限。其 Section 8 仍要求实际最低模态的简单偶性及足够精确的模型逼近。本节在一个固定含素数窗口给出后验模态估计，不宣称证明该模型的无界尺度识别。

另检索并读取了 Marcus Chuk, arXiv:2608.24827 的原始摘要。摘要报告半宽 0.8 窗口上的全空间正性和 simple-even 最低模态；这比本节 log3/2 约 0.5493 的窗口更大。因此本轮成果的价值是与仓库真实符号和可复验后验误差的接合，不是刷新最大正性窗口。该摘要所述 Landau-Widom 曲线拟合不能当作已证尺度渐近律；本轮未取得该预印本全文并逐项复核其证明。

当前新的研究重点是误差分层。量化误差和未计算尾项已能任意指定预算；但在固定 P_N 和固定候选下，完整耦合导致的能量下降不会随算术精度提高自动消失。必须区分

\[
\text{数值/尾项包络宽度},\quad
\text{保守 Schur 估计的松弛},\quad
\text{候选与真实最低线的固有偏差}.
\]

下一步应让高模态按其实际能量进入候选适配的 Schur/Feshbach 下包络，或者构造带外部修正的明确候选，并证明其与 prolate 模型的对应。继续只提高 scalar jet 阶数不保证 (RE5)。最终承重任务仍是：沿明确 a_n->infinity 的序列，独立推出 (RE1) 和 (RE5)，并识别同一 k_a 的 Xi 极限。

参考：

- Connes, Consani, Moscovici, Zeta Spectral Triples, arXiv:2511.22755v1, Sections 3, 4, 7, 8.
- Connes, van Suijlekom, Quadratic Forms, Real Zeros and Echoes of the Spectral Action, arXiv:2511.23257v1, (11), Theorems 5.6 and 6.1. The matrix and theorem pages were inspected as PDF images.
- Suzuki, Weil's quadratic form via the screw function, arXiv:2606.09096v1, Lemma 3.1 and Sections 3.2, 4.1.
- Connes, Consani, Spectral triples and zeta-cycles, Enseign. Math. 69 (2023), 93-148; arXiv:2106.01715v1, Lemma 2.2 and Proposition 2.3. The arXiv text and the publisher bibliographic record were checked.
- Marcus Chuk, Weil positivity in compact windows: certified two-sided bounds and a Landau-Widom decay law, arXiv:2608.24827, original abstract only in this round.

---

## [PR #5602] NEUMANN_COMPLETION_CANONICAL_MODEL_AND_FOURIER_OBSERVATION

# 2026-09-06: arithmetic high-mode weights, a finite prolate candidate family, and complex observation error

This append supplies the previously unwritten theory for
`WeilArchimedeanHighModeBounds` and `WeilNeumannGammaBoundary`, records the
replayed combined certificate, and explains the new
`WeilEvenFourierObservationTail` Lean/Scribe pair. It keeps the same
`literatureRHS(weilTest f f)`, `gammaBracket`, operator realization, and
Fourier convention. The results below distinguish mathematical proofs,
executed interval computations, and Lean proof scripts. No Lean elaboration,
Scribe compilation, or `#print axioms` execution was performed in this round.

## 1. Cross-PR inputs and the actual open problem

The research target remains the two missing steps in Connes-Consani-Moscovici
(CCM), *Zeta Spectral Triples*, arXiv:2511.22755v1, Section 8: simple-even
lowest modes of the actual Weil operator and sufficiently accurate
approximation by their explicit prolate model along unbounded scales.
A fixed-window certificate does not close either unbounded-scale assertion.

The following actual sources were read, including both authors' work:

* loning, PR #5326, head `3beb435bf9ca8aa35aa6079ea4033a9c2e6c9007`,
  `RH_OFFLINE_ZERO_LEE_YANG_INSTANTANEOUS_PHASE_TRANSITION_THEORY.md`,
  Sections C14-C15: a Schur floor incurs a dimension-dependent determinant
  floor. Its canonical determinant identity and boundary approximation
  remain independent obligations. This motivates controlling the scalar
  Fourier output directly rather than introducing another determinant.
* AlyciaBHZ, PR #5580, head `e1699ed18ff0e8145870c2d44374193d83766851`,
  `OrderedStableBalancedTruncation.lean`: stability and an output error
  bound concern the same constructed reduced system. Its discrete Stein
  hypotheses are not hypotheses of the unbounded Weil operator; no direct
  application of that theorem is asserted here.
* AlyciaBHZ, PR #5562, branch `work/prime-weil-foundations-probe-20260905`,
  `ScaledComplexQuadraticRowBound.lean`, blob
  `1b94a72bebdf5128d020fe755b285099a35b70a1`: complex coefficients, individual
  energy weights, and absolute series budgets are already supported.
  Its scaled-row assumptions are not automatically true for our arithmetic
  matrix. No duplicate general row-bound owner is added.

Suzuki, arXiv:2606.09096v1, already studies the same closed Weil realization,
small-window ground modes, and an inverse Neumann Laplacian in Section 8.2.
His inverse on mean-zero functions differs from the massive resolvent
comparison below. Neumann ideas, Hilbert inequalities, projection estimates,
and Schur/Feshbach methods are classical. No priority claim is made for them.

## 2. Restore the all-parity logarithmic comparison

Let L=2a>0, omega_n=2*pi*n/L, b_j=2j+1/2. Extract the Gamma part of the
existing arithmetic boundary symbol:

\[
g_L(n)=\sum_{j\ge0}\frac{\omega_n(1-e^{-b_jL})}{b_j^2+\omega_n^2}.
\]

For w>0 the positive telescoping inequality

\[
\frac{w}{(2j+5/2)^2+w^2}
\le w\left(\frac1{w+2j+1/2}-\frac1{w+2j+5/2}\right)
\]

and the zeroth term give an absolutely convergent majorant with sum at most
1+1/w. The actual symbol therefore satisfies

\[
|g_L(n)|\le1+\frac{L}{2\pi|n|}\qquad(n\ne0).
\tag{CO1}
\]

The same-source Fourier diagonal is

\[
d_n^\Gamma=\gamma(\omega_n)+\frac2L\sum_{j\ge0}
(1-e^{-b_jL})\frac{b_j^2-\omega_n^2}{(b_j^2+\omega_n^2)^2}.
\]

The absolute correction series is bounded by the preceding majorant divided
by |omega_n|, because |b_j^2-omega_n^2|<=b_j^2+omega_n^2. Thus

\[
|d_n^\Gamma-\gamma(\omega_n)|
\le\frac1{\pi|n|}+\frac{L}{2\pi^2n^2}.
\tag{CO2}
\]

The existing `arithmetic_archimedean_high_mode_bounds` proof script proves
(CO1) for the actual extracted symbol, absolute summability of the correction,
and its bound. Identification of the series with the actual diagonal is the
Fourier calculation already recorded in (AC3), using the trigamma series.

On l2(Z), H_nm=1/(m-n) for m!=n and H_nn=0 has norm at most pi.
Indeed its circle Fourier multiplier is, up to the sign convention,
i*(pi-theta) on 0<theta<2*pi. Its coefficients follow by integration by parts;
Parseval proves the bound on finite sequences and then by density on l2.
Every coordinate compression has the same bound. On |n|>=n0>=1 the complete
Gamma off-diagonal block is [D_{-g},H]/pi, so (CO1) bounds its norm by
2+L/(pi*n0), including all cross-shell couplings.

Use the previously proved gamma(t)>=log(t/(2*pi))-2/t for t>0. Let P_L be
an independently justified norm budget for the actual finite prime block,
and D_L=2*(sinh(L/2)-L/2) its actual pole negative-channel budget. Then

\[
q_a(y)\ge\sum_{|n|\ge n_0}d_o(L,n;n_0)|y_n|^2,
\tag{CO3}
\]

\[
d_o(L,n;n_0)=\log\frac{|n|}{L}-2-
\frac{2L+1}{\pi n_0}-\frac{L}{2\pi^2n_0^2}-P_L-D_L.
\]

This is a simultaneous lower form, first proved on finite Fourier vectors.
For extension to the whole high form domain, subtract the finite low
projection from a trigonometric form-core approximation. That projection
is form-norm continuous since its finitely many basis vectors are in the
operator domain. Add a constant to make the displayed diagonal weights
nonnegative and use lower semicontinuity of the weighted coefficient sum.
This also proves finiteness of that sum for a vector in the original form
domain. The actual form core is the one of Connes-Consani,
arXiv:2106.01715v1, Lemma 2.2 and Proposition 2.3. The Hilbert, Fourier and
form-domain bridges here remain paper proofs, not declarations of CO1's owner.

For c=3, L=log3 and n0=65, use P_L=log2/sqrt2. The compressed prime-2
translations have disjoint input and output segments since L<2log2; hence
the norm of their sum is at most one. At n0, (CO3) gives a constant greater
than 1.5184518986360646, verified by directed interval arithmetic. It grows
as log(|n|/65). This supplies the previous logarithmic-weighted certificate
and the odd-sector weights in the combined certificate below.

## 3. Restore the exact Neumann Gamma completion

Set I=[-a,a]. For b>0 define independently the compressed free resolvent
and the Neumann resolvent of -d^2/dx^2+b^2 by their Green kernels:

\[
R_b^F(x,y)=\frac{e^{-b|x-y|}}{2b},\qquad
R_b^N(x,y)=
\frac{\cosh(b(\min(x,y)+a))\cosh(b(a-\max(x,y)))}{b\sinh(2ba)}.
\]

The latter has zero endpoint derivative and a derivative jump -1 at x=y.
A direct hyperbolic calculation, separately for x<=y and y<=x, gives

\[
2b(R_b^N-R_b^F)(x,y)=
\frac{2\cosh(bx)\cosh(by)}{e^{bL}-1}
+\frac{2\sinh(bx)\sinh(by)}{e^{bL}+1}.
\tag{CO4}
\]

Its integrated quadratic form is the sum of the corresponding two positive
squares of boundary moments. Every kernel is bounded on the fixed compact
square and L2(I) is included in L1(I); thus the complex-valued integrated
identity follows from Fubini, not from an assumed sign of the Weil form.

The digamma partial-fraction formula gives

\[
\gamma(t)-\gamma(0)=\sum_{r\ge0}\frac{2t^2}{b_r(b_r^2+t^2)},
\qquad b_r=2r+\tfrac12.
\tag{CO5}
\]

Each summand corresponds to (2/b_r)I-2b_r R^F_{b_r}. Replace the free
resolvent by the Neumann one and use (CO4). With the orthonormal Neumann
basis nu_0=L^(-1/2) and
nu_j=sqrt(2/L)*cos(pi*j*(x+a)/L), j>=1, one obtains

\[
\begin{aligned}
q_\Gamma(f)={}&\sum_{j\ge0}\gamma(\pi j/L)|\langle\nu_j,f\rangle|^2\\
&+2\sum_{r\ge0}\left[
\frac{|\langle\cosh(b_r\,\cdot),f\rangle|^2}{e^{b_rL}-1}
+\frac{|\langle\sinh(b_r\,\cdot),f\rangle|^2}{e^{b_rL}+1}\right].
\end{aligned}
\tag{CO6}
\]

To justify every infinite expression, first subtract gamma(0)*||f||^2.
All resolvent increments, Neumann frequency increments, and boundary
squares are then nonnegative. Prove the finite-mixture identity and use
Tonelli and monotone convergence. This is an equality of extended forms;
on the actual Gamma form domain the terms on the right are finite.
The original Weil realization is unchanged. Neumann conditions belong to
a comparison operator, not to a replacement for the original domain.

On the even sector use the canonical phase-adjusted cosine basis
phi_n=(-1)^n*sigma_n*cos(2*pi*n*x/L)/sqrt(L), with sigma_0=1 and
sigma_n=sqrt2 for n>=1. Write omega_n=2*pi*n/L and
M_b(v)=sum sigma_n*v_n/(b^2+omega_n^2). Direct integration gives

\[
\langle\cosh(b\,\cdot),f\rangle
=\frac{2b\sinh(bL/2)}{\sqrt L}M_b(v).
\]

Combining the b_0=1/2 boundary square with the actual even pole contribution
2*|<cosh(x/2),f>|^2 yields

\[
q_{\Gamma+\mathrm{pole}}(f)=\sum_{n\ge0}\gamma(\omega_n)|v_n|^2
+\frac2L\sum_{r\ge0}b_r^2\eta_r(L)|M_{b_r}(v)|^2,
\tag{CO7}
\]

where eta_0=e^(L/2)-1 and eta_r=1-e^(-b_r L) for r>=1. All eta_r are
positive. Consequently the whole even high form has the lower weight

\[
d_e(L,n)=\gamma(2\pi n/L)-P_L
\ge\log(n/L)-\frac{L}{\pi n}-P_L.
\tag{CO8}
\]

At c=3 and n>=65 this is greater than 7/2. For example use log3<11/10,
pi>3, log2/sqrt2<1/2 and log(65/log3)>401/100. The last comparison follows
from e<11/4, e^(1/100)<100/99 and (11/4)^4*(100/99)<650/11. Then
401/100-11/1950-1/2>7/2. These are direct rational comparisons.
The old `WeilNeumannGammaBoundary` scripts prove (CO4), its finite real
quadratic identity and finite canonical-mixture positivity. The complex
L2, infinite-mixture and operator-domain consequences are the paper proof
above. The even weight (CO8) is not assigned to the odd Fourier sector.

## 4. Replayed combined certificate with all exterior modes retained

The actual checker is
`research/weil_ground_mode/certify_prime3_neumann_weighted.py`, SHA-256
`d6c150268b3f041701a40b804499218bd164555dede6d9c2bd30e7a10a195a99`.
It verifies the pinned dependency `certify_prime3_refined.py` before import;
its SHA-256 remains
`8bb067fc5499b0f2e1e48836e7a82237a15504109f82a856c72478d1096d69d0`.

Keep the same 129-entry dyadic even candidate, N=64, M=32768, 44-bit
coefficient quantization and 60-bit directed error radii. The even block
uses (CO8); the odd block uses (CO3). For each shell a rational lower
energy is selected and verified strictly below its directed analytic
interval. All resolvent weights use T=3/250000. They therefore also bound
the correction at every shift ell<=T. The exact shell Gram and weighted
radius energies are accumulated with checked integer/rational arithmetic.
For each sector, if t is the weighted squared Frobenius norm of the
quantized matrix and e its weighted error energy, the checks

\[
e<\eta,\qquad4te<(\eta-e)^2
\]

prove a Gram norm error below eta. This follows by applying the ordinary
Gram perturbation identity to W^(1/2)C; it does not multiply an unweighted
matrix inequality by a noncommuting weight. The entire |m|>M tail uses
the prior second-jet four-moment positive majorant, with scalar budget
9e-13, divided by the relevant energy denominator at M+1.

The weighted Gram error budgets are 4/152587890625 (even) and
8/152587890625 (odd). The sum of the integer shell Grams has exactly the
previous hash `7f4e1049624807432efe96a68fe63babbc1c3bd37f2d40600a4cddadbddb85a9`.
No zero data or eigensolver is used. All final positive LDL tests were
executed; the entire final output was reproduced exactly in a second run.
A failed intermediate LDL search is not evidence of a negative eigenvalue.

Let k be this fixed candidate normalized in L2. The final rational bounds are

\[
\ell=\frac{2252813807}{40960000000000000},\quad
U=\frac{560909}{10000000000000},\quad T=\frac3{250000}.
\tag{CO9}
\]

The even full-lower test, even k-orthogonal test, and odd test are strictly
positive. Their displayed minimum LDL pivots are respectively
0.003202644247409436, 0.26802217563245934, and 0.040988013296152585.
These pivots prove positivity, not eigenvalue lower bounds. Weighted square
completion on the entire form domain gives

\[
q(f)\ge\ell\|f\|^2,\qquad f\perp k\Longrightarrow q(f)\ge T\|f\|^2.
\]

The odd lower bound T also exceeds ell, so the full lower bound covers both
parities. The actual Rayleigh interval is below U. Compact resolvent and
min-max give a simple isolated even lowest line, with

\[
5.50003370849609375\cdot10^{-8}\le\lambda_0<5.60909\cdot10^{-8},
\quad\lambda_1\ge1.2\cdot10^{-5}.
\]

The existing projective argument (RE4) consequently gives

\[
\left\|u/\langle k,u\rangle-k\right\|^2
\le\frac{44669457}{489267186193}<\frac1{10000}.
\tag{CO10}
\]

This improves the earlier 0.01475 bound to 0.01 for the same candidate and
window. The preceding Neumann-only replay had threshold 1/200000 and bound
0.02; it did not improve 0.01475. The successful improvement uses different
justified weights in the two parity sectors. The full operator theorem
remains a paper/computer-assisted result, not a Lean kernel-certified result.

## 5. The new Lean estimate controls the actual complex Fourier observable

For n>0 direct integration in the same basis gives

\[
\widehat\phi_n(z)=
\frac{2\sqrt{2/L}\,z\sin(Lz/2)}{z^2-(2\pi n/L)^2}.
\tag{CO11}
\]

The paired positive and negative modes cancel the leading inverse-frequency
term. Let y=sum_{n>N}v_n phi_n be any even L2 tail, N>=1. If L*|z|<=pi*N,
put w=L*z/(2*pi); then |n^2-w^2|>=3*n^2/4. The identity

\[
\frac1{3x^3}-\frac1{3(x+1)^3}-\frac1{(x+1)^4}
=\frac{6x^2+4x+1}{3x^3(x+1)^4}\ge0
\]

proves sum_{n>N}n^(-4)<=1/(3N^3), including convergence. Young's inequality
and this positive majorant prove absolute convergence of the Cauchy series
for every square-summable complex v. Finite Cauchy-Schwarz followed by its
sum limit proves

\[
\boxed{|\widehat y(z)|^2\le
\frac{8L^3}{27\pi^4N^3}|z\sin(Lz/2)|^2\|y\|_2^2.}
\tag{CO12}
\]

`WeilEvenFourierObservationTail.even_exterior_fourier_observation_bound`
proves absolute convergence and the precise normalized coefficient-series
inequality. There is no upper exterior cutoff or assumed boundary
cancellation. To identify that response with the actual L2 Fourier tail,
use Parseval and convergence of the finite cosine sums in L2(I), hence L1(I).
Their transforms converge at each complex z by Cauchy-Schwarz on the fixed
window. Equation (CO11) identifies the finite sums, and the proved absolute
series convergence identifies their limit. This last Fourier-space bridge
is a paper proof rather than a second hidden Lean assumption.

On |z|<=R, |Im z|<=b, use |sin(Lz/2)|<=exp(bL/2) to obtain

\[
|\widehat y(z)|\le\sqrt{\frac8{27\pi^4}}L^{3/2}R e^{ba}N^{-3/2}\|y\|_2.
\tag{CO13}
\]

When a certified high energy is at least beta*||y||^2, the squared
observation budget is divided by beta. This controls the entire exterior
observation. It does not assert that the low component of a ground-mode
error is small, or that exp(ba) has disappeared.

## 6. Fix the Mellin normalization before identifying Xi

Use the exact standard definition Xi(z)=xi(1/2+iz),
xi(s)=s*(s-1)*pi^(-s/2)*Gamma(s/2)*zeta(s)/2, and dx=du/u.
CCM (7.1)-(7.2) write

\[
h(u)=\frac\pi2u^2(2\pi u^2-3)e^{-\pi u^2},\qquad
\mathcal E h(u)=u^{1/2}\sum_{m\ge1}h(mu).
\]

For our chosen Haar and Fourier normalization, the exact scalar is checked
by a Mellin calculation, not inferred from a zero plot:

\[
\int_0^\infty h(t)t^{s-1}dt
=\frac{s(s-1)}8\pi^{-s/2}\Gamma(s/2).
\tag{CO14}
\]

For Re s>1 the absolute sum-integral interchange gives

\[
\int_0^\infty\mathcal E h(u)u^{s-1/2}\frac{du}{u}=\xi(s)/4.
\]

The written h is self-Fourier, has h(0)=0 and integral zero. Poisson
summation gives E h(u)=E h(1/u), and its Gaussian tail gives entire Mellin
continuation. Hence the inverse Fourier kernel for our Xi is

\[
\Phi(x)=4\mathcal E h(e^x),\qquad\widehat\Phi=\Xi.
\tag{CO15}
\]

This agrees with the theta kernel already written in this volume. The
factor 4 corrects a scalar mismatch when importing the literal h in CCM;
it does not alter zeros or invalidate a statement made only up to a scalar.
A numerical check at z=0 gave the ratio 1/4 for the unscaled transform;
that check is a diagnostic, while (CO14) supplies the proof.

## 7. An explicit finite dyadic prolate family with the correct strip limit

This construction is separate from the fixed 129-entry certificate vector.
Take lambda=e^a along the integers lambda>=2, so the arithmetic cutoff
c=lambda^2 is integral and tends to infinity. Use the canonical spheroidal
functions ps_n^0(x/lambda;(2*pi*lambda^2)^2) in the convention of CCM (7.10).
The explicit normalizations

\[
h_{0,\lambda}=2^{-1/2}\lambda^{-1/2}\operatorname{ps}_0^0,
\qquad h_{4,\lambda}=3\,2^{-1/2}\lambda^{-1/2}\operatorname{ps}_4^0
\]

have the Hermite limits in CCM (7.11)-(7.12). Set I_j(lambda)=integral of
h_{j,lambda} over [-lambda,lambda] and

\[
h_\lambda=\frac{\sqrt3}{2^{11/4}}
\left(h_{4,\lambda}-\frac{I_4(\lambda)}{I_0(\lambda)}h_{0,\lambda}\right).
\tag{CO16}
\]

The first prolate mode has positive integral, so the denominator is nonzero.
CCM Lemma 7.2 and its Fourier-eigenvalue argument give
I_j(lambda)=h_j(0)+O(lambda^-2). Thus (CO16) has integral zero and
sup_{[-lambda,lambda]}|h_lambda-h|<=C*lambda^-2 for a fixed finite C at
large lambda. This is the published prolate approximation input, not a
new Lean theorem and not a statement about the unknown Weil ground mode.

Define, with zero extension outside [-a,a],

\[
p_a(x)=4e^{x/2}\sum_{1\le m\le\lambda e^{-x}}h_\lambda(me^x),
\qquad p_a^+(x)=\frac{p_a(x)+p_a(-x)}2.
\tag{CO17}
\]

There are at most lambda^2 summands. Evenization is explicit: finite prolate
Fourier eigenvalues need not coincide, so reciprocal symmetry of this
finite model is not assumed.

Retain the omitted Gaussian terms when comparing (CO17) with (CO15).
For u in [lambda^-1,lambda], monotonicity of t^4*exp(-pi*t^2) on t>=1 and
integration by parts give

\[
|\mathcal E h_\lambda(u)-\mathcal E h(u)|
\le u^{-1/2}\bigl(C/\lambda+R_H(\lambda)\bigr),
\]

\[
R_H(\lambda)=\pi^2e^{-\pi\lambda^2}
\left(\lambda^5+\frac{\lambda^3}{2\pi}
+\frac{3\lambda}{4\pi^2}+\frac3{8\pi^3\lambda}\right).
\tag{CO18}
\]

For some explicit finite D, R_H(lambda)<=D/lambda for lambda>=1; each
polynomial-Gaussian factor has a bounded maximum. Consequently
|p_a(x)-Phi(x)|<=4(C+D)e^-a*e^(-x/2) inside the window. Its squared L2
error is at most 16(C+D)^2*e^-a. The exterior Phi tail is double-exponential.
In particular ||p_a^+|| is bounded by a constant B independent of large a.
For every b<1/2, weighted integration of the same bound gives

\[
\sup_{|\Im z|\le b}|\widehat{p_a^+}(z)-\Xi(z)|
\le C_b e^{-(1/2-b)a}.
\tag{CO19}
\]

The integrals on the negative and positive half-windows are respectively
(e^((1/2+b)a)-1)/(1/2+b) and (1-e^(-(1/2-b)a))/(1/2-b), multiplied by
4(C+D)e^-a. Evenization averages the bounds at z and -z. These formulas
justify the claimed strip rate without discarding a nonzero Gaussian tail.

Now project onto the actual canonical even Fourier space P_N. Its
coefficients are explicit finite integrals:

\[
b_{a,j}=4\sum_{m=1}^{\lambda^2}
\int_{-a}^{\log(\lambda/m)}e^{x/2}h_\lambda(me^x)\phi_j(x)\,dx.
\tag{CO20}
\]

Because phi_j is even these also equal the coefficients of p_a^+.
Set d_{a,j}=2^-p*floor(2^p*b_{a,j}+1/2), and define the finite dyadic model
p_tilde_a=sum_{j=0}^N d_{a,j} phi_j. Rounding gives an L2 error at most
sqrt(N+1)*2^-p. Applying (CO13) to the entire projection tail gives, on
|z|<=R and |Im z|<=b with LR<=pi*N,

\[
\begin{aligned}
|\widehat{\widetilde p_a}(z)-\Xi(z)|\le{}&
C_b e^{-(1/2-b)a}
+\sqrt{\frac8{27\pi^4}}L^{3/2}R e^{ba}N^{-3/2}B\\
&+\sqrt{L(N+1)}e^{ba}2^{-p}.
\end{aligned}
\tag{CO21}
\]

For example the explicit choices

\[
N_a=\lceil(a+1)e^{a/3}\rceil,\qquad
p_a^{\rm bits}=\left\lceil\frac{2a/3+2\log(a+1)}{\log2}\right\rceil
\tag{CO22}
\]

give, on every compact substrip rectangle,

\[
\boxed{\sup_{|z|\le R,|\Im z|\le b}
|\widehat{\widetilde p_a}(z)-\Xi(z)|
\le C_{R,b}e^{-(1/2-b)a}.}
\tag{CO23}
\]

Indeed N_a+1<=3(a+1)e^(a/3) for a>=log2. The projection term then has the
same exponential rate, and the rounding term is at most sqrt6 times that
rate. The pole-free band condition holds eventually for each fixed R.
Xi(0)>0, also seen from the positive Phi on x>=0, shows p_tilde_a is nonzero
eventually. With c_a=||p_tilde_a|| and k_a=p_tilde_a/c_a, (CO23) proves
c_a*hat(k_a)->Xi for this specified family.

(CO22) is a resolution sufficient for the function limit, not a sufficient
resolution for the arithmetic spectral certificate. One may choose any
larger N and choose p so that
sqrt(L*(N+1))*2^-p<=exp(-a/2); then the same rate is retained. Resolving an
exponentially small arithmetic gap may require vastly more precision.
No executable certified evaluator for all the prolate integrals in (CO20)
is asserted here. Their definition and analytic approximation are explicit;
their interval implementation remains a separate numerical obligation.
The old certified k at c=3 is not identified with (CO20).

## 8. A directional Schur estimate for the same Fourier observable

The following paper estimate specifies what the remaining arithmetic work
must control. It is not an assertion that its certificates hold at every
scale. Suppose the actual same candidate has been certified to satisfy
ell<=lambda<=mu<=U<T, q(f)>=T||f||^2 on k-perp, and the simple even ground
mode u has norm one. Set alpha=<k,u> and w=u/alpha-k. The earlier projective
argument proves alpha!=0, w perpendicular to k, and

\[
q(w)-\lambda\|w\|^2=\mu-\lambda,\quad
\|w\|^2\le\frac{\mu-\lambda}{T-\lambda}<1.
\]

It follows, retaining the actual energy instead of just the gap, that

\[
q(w)-\ell\|w\|^2\le U-\ell.
\tag{CO24}
\]

Assume k lies in P_NH. Put x=P_Nw, y=Q_Nw, C=Q_N A|P_NH, and let
D=diag(d_e(L,n)-ell), n>N, have a strictly positive lower bound. Suppose
an actual complete coupling majorant Gbar>=C^*D^-1 C has been certified,
and the finite matrix

\[
H=A_N-\ell I-\overline G+\rho kk^*,\qquad\rho>0,
\]

is positive definite. Since x is perpendicular to k, weighted completion
and (CO24) give

\[
\langle x,Hx\rangle+
\|D^{1/2}y+D^{-1/2}Cx\|^2\le U-\ell.
\tag{CO25}
\]

On the even space the actual complex Fourier functional has representer
g_z(t)=cos(conj(z)*t), since the inner product is linear in the second
argument. Let g_P and g_Q be its two components and set

\[
h_z=P_{k^\perp}(g_P-C^*D^{-1}g_Q),\qquad
\mathcal D_a(z)=\langle h_z,H^{-1}h_z\rangle
+\langle g_Q,D^{-1}g_Q\rangle.
\tag{CO26}
\]

Writing the Fourier output in the two coordinates of (CO25) and applying
Cauchy-Schwarz in their direct-sum energy norm proves

\[
\boxed{|\widehat w(z)|^2\le(U-\ell)\mathcal D_a(z).}
\tag{CO27}
\]

All high pairings are legitimate: the original form domain is included
in the D form domain, C has finite domain and l2 images, and D^-1 is
bounded. The second term of (CO26) has the explicit N^-3 observation
bound (CO12), divided by the lower bound of D. The first term is a
finite inverse quadratic form with an arithmetic high-mode correction.
That correction still requires an interval evaluation and an infinite-tail
bound; it is not assigned a numerical value in this round.

For the family (CO20), a sufficient remaining arithmetic target is

\[
c_a^2(U_a-\ell_a)\sup_{z\in K}\mathcal D_a(z)\longrightarrow0
\tag{CO28}
\]

for every compact K in |Im z|<1/2, together with the actual full-space
coercivity certificates used in (CO24)-(CO25). This is a directly observed
error budget, not a determinant floor raised to the realization dimension.
It can be used with the repository's rectangle Rouche machinery when
strict boundary lower bounds and errors are actually available. No such
all-rectangle certificate or ground-family limit is claimed here.

## 9. What has and has not been removed from the problem

The executed fixed-window estimate has genuinely improved. On paper, the
actual high-mode weights have an independent arithmetic proof, and an
explicit finite dyadic prolate family now has a calibrated Xi limit with
quantified projection and rounding errors. The new Lean increment proves
the infinite complex observation-tail bound with absolute convergence.

The first open research obligation is still to certify the *same* family
(CO20) against the actual Weil operator along an unbounded scale sequence,
and make (CO28), or the earlier weighted projective bound, tend to zero.
No finite matrix positivity assumption has been promoted to an arithmetic
theorem without its certificate. Neither the Neumann comparison nor the
new observable estimate is claimed to evade the earlier shift barrier.
The remaining low-mode error, prime cancellations, and prolate integral
certification require further work. No RH proof, universal simple-even
family theorem, or end-to-end Lean real-zero limit is asserted.

References used for this append:

* Connes, Consani, Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1,
  (7.1)-(7.12), Lemmas 7.2-7.3 and Section 8. The literal normalization was
  independently checked by (CO14), and the omitted Gaussian tail is retained.
* Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v1,
  Theorems 1.1-1.4 and Section 8.2. Results stated under RH are not used.
* Connes, Consani, *Spectral triples and zeta-cycles*, arXiv:2106.01715v1,
  Lemma 2.2 and Proposition 2.3, for the actual form core.
* Dusson, Sigal, Stamm, *Analysis of the Feshbach-Schur method for the Fourier
  spectral discretizations of Schrodinger operators*, arXiv:2008.10871v2.
  The elimination principle is classical; its Schrodinger regularity
  assumptions are not silently imported into the Weil problem.
* DLMF 5.7.6, digamma partial fractions, and the Gamma integral and recurrence,
  for the elementary resolvent and Mellin computations.


---

## [PR #5602] CERTIFIED_PROLATE_MODEL_AND_POLYNOMIAL_MELLIN_DICTIONARY

# 2026-09-06：真实 prolate 模型的可认证构造及其与算术最低模态的首次本线定量对接

本节的“首次”仅指本 PR 的交付顺序，不是数学优先权声明。此前已认证的 129 维 dyadic 候选记为 k。它与文献 prolate 模型是不同对象。本节给出后者的独立谱认证、有限多项式 Fourier 端点公式以及实际的 L2 比较，避免在这两个对象之间省略识别误差。

新增 Lean owner 为 `D5/S3/Weil/ZetaBridge/WeilPolynomialMellinWindow.lean`，有同名 Scribe。实际执行源为 `research/weil_ground_mode/certify_prime3_prolate_model.py`，输入 `prime3_prolate_proposal.json`，输出 `prime3_prolate_model_certificate.json`。Lean 保存实际 `Zeta23.paperFT` 的多项式算术窗口公式与可积性；prolate 自伴实现、无限 Legendre 尾、谱投影运输及完整数值结论仍属于下面的纸面与区间证明。Lean/Scribe 编译及传递公理审查未运行。

## 1. 开放问题与跨作者取阅

Connes、Consani、Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1，(7.5)-(7.6)、Lemma 7.3 和 Section 8，把真实最低 Weil 模态与明确 prolate 候选的足够精确比较列为剩余障碍。该文的模型极限不证明真实算术模态的极限。本节只处理一个含素数窗口的同模型校准，并提供任意有限尺度可复用的评价方法。

本轮读取 loning 的 #5296 的实际理论正文 B10.3-B10.4、B13.4：谱分离与边界读出非消失需要分别证明；所有振幅必须在同一空间组合后再平方。因此这里保持真实 Mellin 合成的全部混合项，在真实函数空间中算范数，不把独立矩阵的相似特征值当作模型识别。

同时检查了 AlyciaBHZ 的 #5882、#5895 最新 PR 说明，它们已在实现复数射影误差和 Rouché/readout 证书，故本节不再新建相同抽象定理。#5602 在 `6e95a93cffddabd62c06ebc1e50f57d6913c3c03` 已有 Neumann 比较、同一候选的 <0.01 射影包络和有限 dyadic prolate 族的纸面定义。本节消除的是“prolate 数据尚无严格可执行评价”的具体缺口。没有将那些未运行的 Lean 文件标作已冻结事实。

## 2. 固定文献中的实际 prolate 对象

令 lambda>1，c=lambda^2，a=log(lambda)。在 x=lambda*t 坐标下，文献的

\[
PW_\lambda=-\partial_x((\lambda^2-x^2)\partial_x)+(2\pi\lambda x)^2
\]

变为 [-1,1] 上的正规 prolate 实现

\[
J_q=-\partial_t((1-t^2)\partial_t)+q^2t^2,
\qquad q=2\pi c.
\tag{PM1}
\]

使用偶 Legendre 正交归一基

\[
e_r(t)=\sqrt{(4r+1)/2}\,P_{2r}(t),\qquad r\ge0.
\]

未扰动实现定义为此正交基上的自伴对角算子，特征值 (2r)(2r+1)，其多项式核心在图范数中稠密。q^2*t^2 是有界非负乘法算子，因此在同一个算子域上得到自伴 J_q，有限 Legendre 和保持为核心；resolvent 紧性也被有界扰动保留。这选定的是端点正规、无对数奇分支的 Legendre/prolate 实现。可以从 Legendre 方程与分部积分识别其微分形式，或直接由上述对角实现定义后加入实际乘法势。DLMF 30.2、30.3、30.8 给出相应正规 spheroidal 函数及三项递推。DLMF 的特征值参数与这里可能相差 q^2；特征函数不变，数值证书始终使用 (PM1)。

令

\[
\alpha_j=\frac{j+1}{\sqrt{(2j+1)(2j+3)}},\qquad\alpha_{-1}=0.
\]

由 t*P_j 的标准三项递推直接得到实际无限三对角矩阵

\[
A_{rr}=2r(2r+1)+q^2(\alpha_{2r}^2+\alpha_{2r-1}^2),\qquad
A_{r,r+1}=q^2\alpha_{2r}\alpha_{2r+1}.
\tag{PM2}
\]

本节需要偶谱中编号 0 和 2 的正规特征函数 psi_0、psi_4，它们分别对应文献的 h_(0,lambda)、h_(4,lambda)。选择单位 L2 范数并使零阶 Legendre 系数为正。定义

\[
H(t)=\psi_4(t)-\frac{(\psi_4)_0}{(\psi_0)_0}\psi_0(t),
\qquad h_\lambda(x)=H(x/\lambda).
\tag{PM3}
\]

因为 integral(e_0)=sqrt(2)，而其他 e_r 的积分为零，(PM3) 严格满足零积分。其直线是 span{h_(0,lambda),h_(4,lambda)} 中唯一的零积分直线。任何对两个非零模式的独立重归一化都会给出同一条直线。本文比较的是之后的单位函数，因此省略的整体非零系数不会改变比较对象；最终 Xi 极限的尺度系数仍须用此前已经校准的文献归一化，不能任意缩小。

## 3. 有限提案如何认证整个无限 prolate 谱

保留 r=0,...,K-1。遗漏空间的最小未扰动 Legendre 能量是

\[
H_K=2K(2K+1).
\]

非负势给出整个遗漏形式块 Q_K J_q Q_K >=H_K I。由于 (PM2) 三对角，跨低高空间仅有一条非零耦合，系数

\[
b_K=q^2\alpha_{2K-2}\alpha_{2K-1}.
\]

对 s<H_K，真实 Schur 形式介于两个实际有限矩阵之间：

\[
A_K-sI-\frac{b_K^2}{H_K-s}e_{K-1}e_{K-1}^*
\preceq S(s)\preceq A_K-sI.
\tag{PM4}
\]

这里两个端点矩阵都明确计算，并用区间 LDL 的符号统计其负惯性。当两者非奇异且负指标相同，单调性和上下夹逼保证 S(s) 非奇异且具有同一负指标，因而认证实际 J_q 在 s 以下的全部特征值数量。不能只用有限 A_K 的 Sturm 计数代替这个双端点检查。

本次 c=3、K=32、H_K=4160。提案来自一次不受信任的高精度有限 eigsy 计算，之后每个坐标和中心都固定为分母 2^250 的有理数。独立 verifier 不调用 eigensolver。它在两个中心 mu_j 的 mu_j-1、mu_j+1 处检查 (PM4) 的两个惯性：

\[
\begin{array}{c|c|c}
\text{目标偶谱编号}&\text{mu-1 两端点计数}&\text{mu+1 两端点计数}\\
0&(0,0)&(1,1)\\
2&(2,2)&(3,3)
\end{array}
\]

显示用中心约为 18.088872829041046 和 158.048541836992256。实际比较使用完整 dyadic 中心与定向区间，非显示小数。

对归一化的有限提案 v，完整无限算子残差为

\[
r^2=\|(A_K-\mu)v\|^2+b_K^2|v_{K-1}|^2.
\tag{PM5}
\]

最后一项严格保留。两次认证的残差平方上端点分别小于 1.384e-61 与 1.861e-55。除目标简单特征值以外，全部谱与 mu 的距离至少为 1；谱定理因此给出正交投影误差 <=r，选择真实单位特征函数的符号后有

\[
\|\psi_j-v_j\|\le\sqrt2r_j<10^{-25},\qquad j=0,4.
\tag{PM6}
\]

残差本身不足以识别第几条谱线；编号来自前面完整空间的惯性计数。正的零阶系数及 (PM6) 又固定了符号，并认证 (psi_0)_0 非零。

## 4. 同一零积分模型的误差运输

记 r=v_(4,0)/v_(0,0)，d=v_(0,0)>epsilon_0。若 (PM6) 的误差为 epsilon_j，则

\[
\left|\frac{(\psi_4)_0}{(\psi_0)_0}-r\right|
\le\Delta_r:=\frac{\epsilon_4+|r|\epsilon_0}{d-\epsilon_0}.
\]

故实际零积分组合与有限组合之差满足

\[
\|H-(v_4-rv_0)\|\le
\epsilon_4+(|r|+\Delta_r)\epsilon_0+\Delta_r.
\tag{PM7}
\]

不需要给积分误差、比值或基函数逼近设置未检查的输入字段。

对 h 支撑于 [-lambda,lambda]，定义实际算术窗口

\[
p_h(x)=4e^{x/2}\sum_{1\le m\le\lambda e^{-x}}h(me^x),
\qquad -a\le x\le a,
\]

并在窗口外置零。最后明确偶化 p_h^+(x)=(p_h(x)+p_h(-x))/2。有限 prolate 模式的 Fourier 特征值一般不同，不能预先假定未偶化的 p_h 已严格为偶。

单个 m 的误差用 t=m*exp(x) 代换，有

\[
\int_{-a}^{a-\log m} e^x|\delta h(me^x)|^2dx
=\frac1m\int_{m/\lambda}^{\lambda}|\delta h(t)|^2dt.
\]

所以对 c=lambda^2 为整数的任何有限尺度，

\[
\boxed{\|p_h^+-p_{\widetilde h}^+\|_2
\le4\sqrt\lambda\left(\sum_{m=1}^{c}m^{-1/2}\right)
\|H-\widetilde H\|_{L^2[-1,1]}.}
\tag{PM8}
\]

此处 h(x)=H(x/lambda)，因此 sqrt(lambda) 的缩放因子被保留。偶化是正交投影，范数不增。若 rhs=e<n=||p_tilde^+||，则真实模型非零，且

\[
\left\|\frac{p_h^+}{\|p_h^+\|}-
\frac{p_{\widetilde h}^+}{\|p_{\widetilde h}^+\|}\right\|
\le\frac{2e}{n}.
\tag{PM9}
\]

证明直接使用反三角不等式，分母 n 独立认证为正。误差链 (PM4)-(PM9) 对参数化有限尺度有效；本次程序只实例化 c=3，没有暗示已逐尺度认证全部 c。

## 5. 多项式算术窗口的完整有限 Fourier 公式

由 Legendre 提案可精确构造偶多项式

\[
\widetilde h(t)=\sum_{r=0}^{d-1}A_rt^{2r}.
\]

定义 s=1/2+iz、t_r=s+2r。每个算术单项的 Fourier 积分为

\[
4A_rm^{2r}\int_{-a}^{a-\log m}e^{t_rx}dx
=4A_rm^{2r}\frac{e^{t_r(a-\log m)}-e^{-at_r}}{t_r}.
\tag{PM10}
\]

对 Im(z)<1/2，Re(t_r)>0，所有分母均非零。有限求和给出

\[
\boxed{\widehat p(z)=4\sum_{m=1}^{M}\sum_{r<d}
A_rm^{2r}\frac{e^{t_r(a-\log m)}-e^{-at_r}}{t_r}.}
\tag{PM11}
\]

条件是全部包含的 m 满足 log(m)<=2a。主 Lean 声明 `polynomial_mellin_window_paperFT` 使用原始 `Zeta23.paperFT` 证明 (PM11)。`polynomial_mellin_fourier_integrable` 对全部复 z 先证明实际 integrand 可积；`mellin_monomial_polynomial_value` 证明指数坐标确实等于 exp(x/2)*(m*exp(x))^(2r)。这些结论无需任何未知谱、零点、积分精度或 Fourier 识别假设。

合并 m 项，还可把纸面公式写成一个有限 Dirichlet 字典：

\[
\widehat p(z)=4\sum_{r<d} A_r
\frac{e^{at_r}D_M(s)-e^{-at_r}S_M(2r)}{t_r},
\quad D_M(s)=\sum_{m=1}^Mm^{-s},\quad S_M(2r)=\sum_{m=1}^Mm^{2r}.
\tag{PM12}
\]

式 (PM12) 未另设 Lean 公共包装；实际 verifier 使用等价的 (PM11)。它不调用 zeta 值。表观 t_r=0 奇点可去；Lean 定理在所需半平面内直接排除了分母为零，不依赖 totalized division。

## 6. 保留完整混合项的函数范数与实际校准

在 c=3 处，m=3 只贡献一个端点，Lebesgue 积分为零。令 b=a-log2<0。实际 p_tilde^+ 的解析表达只在 -a、b、-b、a 处切换。每段是有限个 exp(plus-or-minus(2r+1/2)*x) 的线性组合。

平方后先合并所有指数及其完整系数，包括全部交叉项；对每个精确有理指数 t 使用

\[
\int_l^r e^{tx}dx=(e^{tr}-e^{tl})/t\quad(t\ne0),\qquad
\int_l^r1\,dx=r-l.
\]

这给出 ||p_tilde^+|| 的定向区间，无求积误差。固定候选 k 的余弦系数使用已有相位约定；其与 p_tilde^+ 的内积通过 (PM11) 的 65 个实际余弦频率值精确计算。所有有限和先在同一函数中形成，平方时没有舍弃混合项。

本次显示值为

\[
\|p_{\widetilde h}^+\|=2.90193861714445\ldots,
\qquad
\left\langle k,\frac{p_{\widetilde h}^+}{\|p_{\widetilde h}^+\|}\right\rangle
=-0.999999377793547947\ldots.
\]

这里的原始范数采用 (PM3) 的整体标度，不是此前文献校准常数下的范数。单位直线与该常数无关。实符号对齐后的多项式模型距离平方为

\[
2-2|\langle k,p_{\widetilde h}^+/\|p_{\widetilde h}^+\|\rangle|
\in[1.24441290410519742709\ldots,1.24441290410519742710\ldots]10^{-6}
< (112/100000)^2.
\]

(PM9) 的真实 prolate/多项式模型误差小于 3.376e-24。因此对真正的偶化 prolate 模型，执行器证明

\[
\boxed{\inf_{\sigma\in\{-1,1\}}
\left\|k-\sigma\frac{p_{h_\lambda}^+}{\|p_{h_\lambda}^+\|}\right\|
<\frac{113}{100000}=0.00113,
\qquad \lambda=\sqrt3.}
\tag{PM13}
\]

结合本卷已有、记录在组合 Neumann-even/log-weighted-odd 证书中的实际 Weil 结论 ||u/<k,u>-k||<1/100，三角不等式给出

\[
\boxed{\inf_{\sigma\in\{-1,1\}}
\left\|\frac{u}{\langle k,u\rangle}-
\sigma\frac{p_{h_\lambda}^+}{\|p_{h_\lambda}^+\|}\right\|
<\frac{1113}{100000}=0.01113.}
\tag{PM14}
\]

新程序独立运行的是 (PM13)；(PM14) 继承此前真实 Weil 形式及无限耦合证书的纸面/区间范围。这里未重新运行整个 Weil LDL 程序，也未把其域接口变为 Lean 公理。

## 7. 实际验证、研究价值和剩余承重问题

在 110 位和 130 位定向区间精度分别运行同一 verifier，全部八组有限惯性端点检查、两个含完整无限尾的残差检验、分母正性、函数范数和有理误差门均通过。提案生成可使用任意不受信任的数值方法；证书只依赖固定 dyadic 数据、标准区间四则/exp/log/sqrt 和明确的纸面算子界。它依赖 mpmath.iv、Python 与整数实现的正确性，未被 Lean 内核重放。

最终 verifier SHA-256：`42dceb5c81f9aabdc12b51a99d29f0929d81e712f815b49b13bbf9bb5ec56039`。
提案 SHA-256：`242c9897bbd247ef0485039e6dcde819a351c5900ceac52fecc420934c1896db`。
固定 Weil 候选依赖 SHA-256：`8bb067fc5499b0f2e1e48836e7a82237a15504109f82a856c72478d1096d69d0`。

本轮提供了实际文献模型的严格可执行评价，以及它与已认证算术候选的一条具体误差桥。此前任意 dyadic 候选与 prolate 模型的对应尚未量化；(PM13) 在一个含素数尺度消除了这一缺口。它没有证明该距离为零，也没有把这个固定小数外推成尺度衰减律。

研究主体接下来应对同一 p_(h_lambda)^+ 或其带认证误差的有限多项式版本，计算实际 Weil 形式、完整候选正交补以及目标 Fourier 灵敏度。需要沿明确 lambda_n->infinity 的序列证明真实 ground/model 差的条带紧集一致预算消失，而不能仅凭已知 prolate/Xi 模型极限完成拼接。所有整体归一化因子、偶化、低频候选误差、算术 Schur 松弛和高频尾都必须保持对应。Legendre/Galerkin/Schur/区间工具本身是经典方法，本节不作首次发现声明。

参考：

- Connes, Consani, Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1, (7.5)-(7.12), Lemma 7.3, Section 8. https://arxiv.org/html/2511.22755v1
- NIST DLMF 30.2, 30.3 and 30.8, regular spheroidal differential equation, eigenvalues and Ferrers/Legendre expansions. https://dlmf.nist.gov/30.2 ; https://dlmf.nist.gov/30.3 ; https://dlmf.nist.gov/30.8
- Mathlib pinned commit `db584cd6d46c92f209a44c0f1c829460d327499d`, `integral_exp_mul_complex` and interval integrability; existing repository `Zeta23.paperFT`.
- loning #5296, theory source at `9adc8b7e64469344089ce298cb3ab3478aebb21c`, B10.3-B10.4 and B13.4; AlyciaBHZ #5882 and #5895, PR-level scope audit for existing projective/readout formalizations.


---

## [PR #5602] PRIME_MELLIN_INTERTWINING_AND_PARITY_RESIDUAL

# 2026-09-06：真实素数作用的全尺度对数约化与偶化修正的定量保存

Lean：`D5/S3/Weil/ZetaBridge/WeilMellinPrimeIntertwining.lean`。
Scribe：`Blueprint/D5/S3/Weil/ZetaBridge/WeilMellinPrimeIntertwining.scribe.cs`。
独立执行源：`research/weil_ground_mode/certify_prime3_mellin_parity.py`。
精确回归：`research/weil_ground_mode/test_mellin_prime_intertwining.py`。

本节不继续提高固定窗口的最低特征值精度，而是消除明确模型上的一个实际算术作用计算：带原始 Lambda(n)/sqrt(n) 系数的整个单向素数幂平移，可以精确化为对数 seed 的 Mellin 合成。随后把这一结果运输到实际偶化模型，保留其完整奇部分修正。主恒等式对任意窗口尺度成立，未使用未知最低模态、谱间隔或 RH。其算术核心是已有的经典除数恒等式，不作数学首创声明。

## 1. 文献和当前库中的承重位置

Connes 的 2026 年综述 *The Riemann Hypothesis: Past, Present and a Letter Through Time*, arXiv:2602.04022，Sections 6.4-6.6，仍明确区分 prolate 模型的 Xi 极限与真实最低 Weil 模态的充分精确逼近。其 Section 6.4 解释 E 映射、Poisson 关系和近 radical 的来源。这与 Connes-Consani-Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1，Section 8 的两个缺口一致。因此本节研究实际算术作用与 E 的相容性，未将两种算子的自伴性或相似谱图当作模型识别。

本轮读取 loning 的 #5326 实际正文 C13.1-C13.3：固定矩形零点计数需要真实的边界逼近误差与非零下界，局部收敛不能由单个有限深度覆盖所有高度。还读取 AlyciaBHZ 的 #5895 新真源 `NormalizedReadoutDisk.lean`，固定在 `04eaf09b47c39f7688a8df498c4fe30e0663dcbd`：它已保留归一化分子、分母共享误差的协方差。因此本节不重复编写射影、误差球或 Rouché 包装，而补入这些消费者之前的实际 prime/model 算术。

Mathlib 固定版本 `db584cd6d46c92f209a44c0f1c829460d327499d` 已有 `ArithmeticFunction.vonMangoldt_sum`。新证明直接复用它，并复用 `WeilPolynomialMellinWindow.mellin_monomial_polynomial_value` 证明与原多项式模型的逐点一致性。

## 2. 同一窗口、原始系数与明确模型

令 a>=0、lambda=exp(a)，取自然数 M>=exp(2a)。通常采用整数 c=lambda^2=M。设 h: R->C 在 t>lambda 时为零。定义

\[
E_{a,M}h(x)=1_{[-a,a]}(x)\,4e^{x/2}
\sum_{m=1}^{M}h(me^x).
\tag{MP1}
\]

h 的上部支撑使所有不满足 me^x<=lambda 的项自动为零。任意更大的 M 给出同一个窗口模型。定义原始单向 prime block

\[
B_+f(x)=1_{[-a,a]}(x)
\sum_{n=1}^{M}\frac{\Lambda(n)}{\sqrt n}f(x+\log n).
\tag{MP2}
\]

对窗口内零延拓的函数，B_- = B_+^* 是反向平移，S=B_++B_- 是无符号素数块；实际 Weil 算子中的素数贡献是 -S。Lambda(1)=0，所以 n=1 不增加项。对窗口支撑的输入，n>exp(2a) 的平移为零；等于 exp(2a) 的项至多改变端点，L2 算子不变。这一支撑结论不用于任意未截断的输入函数。

为使反射逐点成立，这里使用闭区间。原 `polynomialMellinWindow` 使用左开右闭区间。新 Lean `polynomial_window_agreement` 对截断偶多项式 seed 证明两者在 x!=-a 处逐点相等，因此代表同一个 L2 函数。它不引入第二套 Fourier 定义。一般超额 M 的旧端点求积公式仍须先删除空支撑项；当 M=exp(2a) 为整数时，旧公式的全部 cutoff 条件直接满足。

## 3. 全尺度精确素数作用

新主声明 `prime_forward_mellin_identity` 证明

\[
\boxed{B_+E_{a,M}h=E_{a,M}((\log t)h)-X E_{a,M}h,\qquad Xf(x)=xf(x).}
\tag{MP3}
\]

该恒等式在全部实 x 上逐点成立。Lean 陈述甚至允许 a 为任意实数；负半宽时压缩区间为空。研究应用取 a>0。

证明先处理 x 在窗口内。正整数 n 的平移不会越过左端点；越过右端点时，seed 支撑使原始有限和为零。精确半密度抵消为

\[
\frac{\Lambda(n)}{\sqrt n}\,4e^{(x+\log n)/2}
=4e^{x/2}\Lambda(n).
\]

于是左侧等于

\[
4e^{x/2}\sum_{n,m=1}^{M}\Lambda(n)h(nme^x).
\]

若 nm>M，则 M>=exp(2a)、x>=-a 给出 nme^x>exp(a)，该项确实为零。按 k=nm 重新分组，得到

\[
4e^{x/2}\sum_{k=1}^{M}
\left(\sum_{n\mid k}\Lambda(n)\right)h(ke^x)
=4e^{x/2}\sum_{k=1}^{M}\log k\,h(ke^x).
\]

最后使用 log(k exp(x))=log(k)+x 得到 (MP3)。窗口外两端因同一压缩均为零。所有求和有限，复振幅保持到最后；没有对素数项先取绝对值，也没有遗漏 p^j、j>1 的素数幂。

该结果是原始 prime action 的计算恒等式，不是 prime positivity，也没有证明完整 Weil 形式小。其作用是使后续 Gamma/pole 抵消面对一个明确的 log-seed，而非一个待估计的重复素数双重求和。

## 4. 偶化以后的完整修正

记 Rf(x)=f(-x)、P_+=(I+R)/2、P_-=(I-R)/2，并设

\[
p=E_{a,M}h,\quad e=P_+p,\quad r=P_-p,\quad g=E_{a,M}((\log t)h).
\]

有限 prolate 模式的压缩 Fourier 特征值不必相同，所以一般 r!=0。源文件独立定义两个方向的素数平移，并证明

\[
\boxed{S e=(I+R)g-2Xr-(I+R)B_+r.}
\tag{MP4}
\]

这是 `prime_even_mellin_identity`。推导使用 R B_+ R=B_-、e=p-r 及 e 的偶性：

\[
S e=(I+R)B_+e=(I+R)(g-Xp-B_+r),
\]

而 (I+R)Xp=2Xr。最后一等式中的 x 因子随反射变号，不能漏掉。

定义完整偶化修正

\[
\mathcal C_h=2Xr+(I+R)B_+r.
\tag{MP5}
\]

在 L2([-a,a]) 上，每个压缩平移范数不超过一。若 V_a 是 B_+ 的独立范数上界，例如有限绝对权重和，则

\[
\boxed{\|\mathcal C_h\|_2\le2(a+V_a)\|r\|_2.}
\tag{MP6}
\]

这是 (MP4) 的纸面 L2 推论；本次 Lean 保存的是完整逐点恒等式。对实际 prolate seed 或有限多项式 seed，有限合成在窗口内分段光滑且有界，所以全部配对合法。更一般地，正半轴上的 L2 seed 也可由 t=m exp(x) 的变换逐项证明合成可积。

实际素数二次型因此满足

\[
\boxed{
q_{\rm prime}(e)
=-2\Re\langle e,g\rangle
+2\Re\langle e,Xr+B_+r\rangle.
}
\tag{MP7}
\]

当 e 非零时，省略奇部分造成的归一化能量误差最多为 2(a+V_a)||r||/||e||。这一上界不保证误差相对于真实最低能量或最低谱间隔足够小。

## 5. 真正 prolate 模型上的已执行检验

本次保留同一个 lambda=sqrt(3) 的零积分 prolate 直线，沿用前节 (PM1)-(PM9)，没有重新定义候选或调用未知 Weil ground vector。新 verifier 在载入前校验原 prolate verifier、其 dyadic proposal 和原算术源的 SHA-256，并实际重放整个 prolate 认证，包括遗漏 Legendre 块的惯性夹逼及完整残差。单位模式误差仍严格小于 10^-25。

由有限 Legendre 模型形成的 p_tilde 在 -a、b=a-log2、-b、a 上分段。每段 e_tilde 和 r_tilde 是有限个 exp(plus-or-minus(2j+1/2)x) 的和。g_tilde 的每项还带 x+log(m)。程序完整展开混合项后，使用 exp(tx) 和 x exp(tx) 的端点原函数计算范数、内积，没有数值求积。实际 prime energy 另从原平移积分

\[
-\frac{2\log2}{\sqrt2}\int_{-a}^{a-\log2}
\widetilde e(x)\widetilde e(x+\log2)\,dx
\]

独立算出，而非先设定为 (MP7) 的右侧。

从有限多项式回到真正 prolate 函数时，也控制了 log-seed 误差。全部被使用的 seed 参数 t 都在 [lambda^-1,lambda]，因此 |log(t)|<=a。若 prolate seed 在 [-1,1] 上的误差为 delta_H，令

\[
C=4\sqrt\lambda\sum_{m=1}^{3}m^{-1/2},\qquad \epsilon=C\delta_H.
\]

则 ||p-p_tilde||<=epsilon，||g-g_tilde||<=a epsilon，偶、奇投影各自也满足相同的 epsilon 预算。这个步骤只作用于有界的实际 prime/log-seed 配对，不把 L2 误差当作完整无界 Gamma 形式的误差。

令 n=||e_tilde||，并用 Q>=||g_tilde||，V=log2/sqrt2。程序选用独立的 Q=a C(1+|ratio|)。设

\[
Z=-\langle e,S e\rangle+2\Re\langle e,g\rangle,
\qquad\widetilde Z=-\langle\widetilde e,S\widetilde e\rangle
+2\Re\langle\widetilde e,\widetilde g\rangle.
\]

使用 ||S||<=2V，得到

\[
|Z-\widetilde Z|\le
[2V(2n+\epsilon)+2(an+Q+a\epsilon)]\epsilon=:\Delta_Z.
\]

且 |Z_tilde|<=2Vn^2+2nQ、| ||e||^2-n^2 |<=(2n+epsilon)epsilon。验证 n>epsilon 后，归一化误差预算为

\[
\boxed{
\left|\frac Z{\|e\|^2}-\frac{\widetilde Z}{n^2}\right|
\le\frac{\Delta_Z}{(n-\epsilon)^2}
+\frac{(2Vn^2+2nQ)(2n+\epsilon)\epsilon}{n^2(n-\epsilon)^2}.
}
\tag{MP8}
\]

实际算出的 (MP8) 上界小于 4.495e-23。它保留归一化分母变化，未把历史 norm JSON 当作新计算输入。

## 6. 认证的有理结论与能量尺度

对真正的 prolate 模型，定向区间验证给出

\[
\boxed{\frac{76}{10^6}<\frac{\|r\|_2}{\|e\|_2}<\frac{77}{10^6}.}
\tag{MP9}
\]

因此未偶化的算术模型确实具有非零奇部分。对实际归一化素数能量，

\[
\boxed{-\frac{18173952}{10^9}
<\frac{q_{\rm prime}(e)}{\|e\|^2}
<-\frac{18173950}{10^9}.}
\tag{MP10}
\]

更重要的是，对省略奇修正的实际能量差，有

\[
\boxed{-\frac{44}{10^8}
<\frac{q_{\rm prime}(e)+2\Re\langle e,g\rangle}{\|e\|^2}
<-\frac{43}{10^8}.}
\tag{MP11}
\]

显示用的多项式值约为 -4.3582252062e-7。前面的误差预算已经将该区间运输到真正 prolate 模型。其绝对值严格大于 7U，其中 U=560909/10^13 是此前真实 Weil 最低值的上界。这个比较仅说明该模型修正在现有研究所需的能量尺度上不能忽略；它没有给出模型完整 Rayleigh 商或新的最低特征值区间。

同时 (MP6) 给出可实际使用的算子作用预算

\[
\boxed{\|\mathcal C_h\|_2/\|e\|_2<159/10^6.}
\tag{MP12}
\]

(MP11) 是有符号实际配对的认证；(MP12) 是较粗的范数上界。两者不可互换。保留修正后，后续可以继续利用它与 Gamma/pole 项的抵消。

## 7. 形式化范围与复验

`prime_forward_mellin_identity` 对任意尺度、任意复 seed、完整有限 cutoff 和所有实 x 给出 (MP3) 的证明脚本。`prime_even_mellin_identity` 保存完整 (MP4)。`polynomial_window_agreement` 接回既有多项式模型。独立新定义只描述这次需要的实际 E 和平移作用；既有 von Mangoldt、Fourier 与 Weil 对象保持不变。

`test_mellin_prime_intertwining.py` 实际执行 258 组精确函数回归，每组同时检查两个恒等式。乘法坐标、支撑测试都用有理数；对数用素因子指数向量表示，系数是精确复有理根式，不使用浮点容差。测试覆盖整数及非整数 lambda、额外无效 cutoff、窗口内外和端点。错误半密度、删除高阶素数幂、删除奇修正和不足 cutoff 四个指定变体均有实际失败见证。这些回归是开发检查，不能替代 Lean 内核证明。

新定向区间 verifier 在 110 位和 130 位分别实际运行通过。没有运行 GitHub CI、Lean elaboration、Scribe emission 或传递公理报告。定向区间证书依赖 mpmath.iv、Python 和前节说明的 prolate 算子识别及谱估计。没有将它标为完整内核结果。

新 verifier SHA-256：`16e0de27325376e8c7627297d406bc4720b3708f5826c8f7cd7096e6c9d59961`。
精确回归源 SHA-256：`7101362a568224039fe339838d7a355c54beffba923ab7745d46652bc1919ade`。
原 prolate verifier SHA-256：`42dceb5c81f9aabdc12b51a99d29f0929d81e712f815b49b13bbf9bb5ec56039`。

## 8. 下一条实际残差等式及剩余开放问题

对当前分段光滑的实际模型，每个固定尺度有有限个断点，零延拓 Fourier 变换为 O(1/|t|)。Gamma 乘子为 O(log(2+|t|))，所以其乘积属于 L2。加上有限有界素数与 pole 项，可用同一 Friedrichs 配对识别其算子域。这是纸面定义域论证，未包含在本次 Lean 声明中。

于是对明确 e=P_+E h 和任意实 mu，完整残差可准确写成

\[
\boxed{
(A_a-\mu)e
=A_\Gamma e+A_{\rm pole}e-(I+R)E((\log t)h)
+\mathcal C_h-\mu e.
}
\tag{MP13}
\]

本节已把原始素数作用从该等式中的未知算术双重和，约化为显式 log-seed 与完全保留的奇修正。真正需要继续攻克的是 (MP13) 中 Gamma/pole/log-seed 的相消，以及其同候选正交补之间的定量关系。经典的全局 E-radical 或 Poisson 说法有自身的 Schwartz、零值、零积分与边界条件，不能直接作用于截断 prolate 函数并删除这些修正。

(MP3)-(MP4) 已具有参数族形式，(MP9)-(MP12) 目前只在 lambda=sqrt(3) 兑现数值认证。尚未证明无界尺度上的 small residual/gap、simple-even ground family 或真实 ground Fourier 的 Xi 极限。此次结果不会自动绕过前面的固定内缩平移障碍，也不表示素数范数预算本身已统一有界。

参考：

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


---

## [PR #5602] ORIGIN_NORMALIZATION_AND_DIVISOR_WINDOW_DICTIONARY

# 2026-09-07：原点归一化的真模态对应，以及 5040 因数数据的精确算子字典

本节有两个不同层次的交付。第一，实际重放完整算术对偶证书后，消去未知射影归一化，认证真实 ground 与真实 prolate 的原点归一化 Fourier 比较。第二，把 5040 研究中实际使用的有限因数载体提升为同一有限窗口上的算术作用，明确证明其对应条件和遗漏项。没有把 Robin 标量不等式当作 Weil 正性或谱间隔。

新 Lean 为 `WeilDivisorWindowCorrespondence.lean`，配套同名 Scribe，位于既有 `D5/S3/Weil/ZetaBridge` 路径。其六个公开声明使用原 `Nat.divisors`、`windowMellinSum` 和 `primeForward`。新程序为 `certify_prime3_origin_normalized.py`，另有 `test_divisor_window_correspondence.py` 及其实际结果。Lean elaboration、Scribe emission、传递公理审查均未执行；下面的算子 Euler 积与锐窗口边界是纸面证明，未混称为新 Lean 的结论。

## 1. 为什么改为原点归一化

保持上一节 c=3、a=log3/2、原实偶单位候选 k 和实际最低模态 u。记

\[
F(z)=\widehat u(z)/\alpha,\quad \alpha=\langle k,u\rangle\ne0,
\quad K(z)=\widehat k(z),\quad P(z)=\widehat v_P(z),
\]

其中 v_P=-p_h^+/||p_h^+|| 是此前同一个全局符号的真实单位 prolate 模型。原证书没有把 alpha 数值化。正确的下一步是证明 F(0)、P(0) 非零后，比较 F(z)/F(0) 和 P(z)/P(0)。两者分别严格等于

\[
\mathcal F(z)=\widehat u(z)/\widehat u(0),\qquad
\mathcal P(z)=\widehat p_h^+(z)/\widehat p_h^+(0).
\tag{ON1}
\]

全局相位、单位范数和 alpha 在同一函数的分子分母中代数消去。没有选择依赖 z 的归一化。若以后同一明确模型经正确尺度系数收敛到 Xi，且在原点也收敛到非零 Xi(0)，它的 (ON1) 就收敛到 Xi(z)/Xi(0)。这仅说明归一化的相容性，未在本节证明该尺度收敛。

## 2. 原点分母独立认证

原点代表元为窗口上的常数 1。令 Delta=U-ell、kappa=T-ell，沿用旧全空间强制性。零对偶试探给出

\[
|F(0)-K(0)|\le\delta_0:=
\sqrt{\Delta\{L-|K(0)|^2\}/\kappa}.
\tag{ON2}
\]

K(0)=sqrt(L)*s_0/sqrt(sum s_n^2)，其中 s_n 是固定候选整数坐标。保留实际负号，区间计算得到 K(0)=-0.8043944718...，delta_0=0.0064208260...，故

\[
\boxed{|F(0)|\ge|K(0)|-\delta_0>797/1000.}
\tag{ON3}
\]

实际 prolate 验证器重新执行完整模式隔离及无限尾。以原 Mellin 端点公式计算模型原点，并运输真实单位模型误差，得到 P(0)=-0.8050473131... 以及 |P(0)|>805/1000。只需要模长下界，无须假设任一人为选定方向在原点为正。

对任意 F0,K0 非零，有精确代数等式

\[
F(z)/F0-K(z)/K0=
\{F(z)-K(z)-(K(z)/K0)(F0-K0)\}/F0.
\tag{ON4}
\]

在上一节闭圆盘 D={|z-(20+i/4)|<=1/1000}，令 eps_D 为已重放的 ground/candidate 误差，d=H/1000 为同一代表元变化界。于是

\[
\sup_D|\mathcal F-K/K0|
\le\frac{\epsilon_D+(|K(z_0)|+d)\delta_0/|K0|}{|K0|-\delta_0}
<447/10^6.
\tag{ON5}
\]

真 prolate 原点误差同时进入 (ON4) 的第二次应用。中心模型差用精确 Mellin 端点积分计算；从中心到圆盘的运输作用在 k/K0-v_P/P0 上，使用

\[
\|k/K0-v_P/P0\|\le
\|k-v_P\|/|K0|+|K0-P0|/(|K0||P0|).
\]

得到 sup_D|K/K0-P/P0|<57/10^6。使用未粗化的两个区间相加，最终认证

\[
\boxed{\sup_{z\in D}|\mathcal F(z)-\mathcal P(z)|<51/100000,\qquad
\inf_{z\in D}|\mathcal F(z)|>43/100000.}
\tag{ON6}
\]

实际误差上预算约 0.00050309134556。它比先前单位模型/射影 ground 的数值更宽，且归一化不同；不把两者包装为直接精度改进。本节消除的是归一化中尚存的未知 alpha。旧完整 Weil Schur/LDL 下界未重跑；新程序实际重放能量对偶和真实 prolate 程序，再认证两处分母和全部归一化误差。

## 3. 从 5040 研究的同一因数载体出发

loning 研究的 `ZECKENDORF_EULER_5040.md` 定义 Z_N(s)=sum_(d|N)d^-s，且 Z_N(1)=sigma(N)/N。已读取实际 `GoldenCell5040Certificate.lean`：它构造六点 cell 的有理分析证书，5040 的 Robin 对数余量为负，其余五点的余量大于 1/100。还读取新 `PaddingRatio.lean`：补高一个有界素数指数取得相对 divisor-sum 增益；其概率质量逃逸消费者保留额外条件，未被本节当作 RH 定理。

在同一个窗口定义

\[
E_{a,N}^{\rm div}h(x)=1_{[-a,a]}(x)4e^{x/2}\sum_{d\mid N}h(de^x).
\]

取 N>0、整数 M>=exp(2a)，h(t)=0 于 t>exp(a)。令 R_(a,N,M)h 是同一公式中 1<=d<=M 且 d 不整除 N 的和。新 Lean 从实际支撑与因数集证明

\[
\boxed{E_{a,N}^{\rm div}h=E_{a,M}h-R_{a,N,M}h.}
\tag{DW1}
\]

证明不需要覆盖假设。窗口内 d>M 蕴含 d exp(x)>exp(a)，故较大因数项消失；其余实际因数恰为前缀中的整除 filter，和其补集一起分割原有限和。窗口外同一 indicator 使两边都为零。等式对任意复 seed 和全部实 x 成立，闭端点保持不变。

沿用原 `prime_forward_mellin_identity`，新 Lean 进一步证明

\[
\begin{aligned}
B_+E^{\rm div}h={}&E^{\rm div}((\log t)h)-XE^{\rm div}h\\
&+R((\log t)h)-XRh-B_+Rh.
\end{aligned}
\tag{DW2}
\]

因此，缺失项在原始函数及其实际 Lambda(n)/sqrt(n) 作用上都被完整保存。若每个 1<=d<=M 都整除 N，则 R 的实际索引集合为空，Lean 得到 Ediv=E；这个算术条件在 5040、2520 和 M=10 处由有限整除计算全部消去。

## 4. 精确的算子 Euler 积及 logarithmic derivative

以下为纸面算子证明。令 H_a=L2([-a,a])，对正整数 d 定义零延拓后压缩的前向平移 U_d f(x)=1_I(x)f(x+log d)。它们有范数<=1，并满足 U_d U_e=U_(de)：两个位移均非负，起点和终点在 I 内时，中间点也在 I 内。U_d=0 当 log d>=2a，等号仅剩一个零测端点。对 d>=2，U_d 因而是幂零算子。此处没有使用周期平移。

对复参数 s，令

\[
\mathcal D_{a,N}(s)=\sum_{d\mid N}d^{-s}U_d
=\prod_{p^e\Vert N}\sum_{j=0}^{e}(p^{-s}U_p)^j.
\tag{DW3}
\]

等式来自唯一素数分解和已证明的压缩平移乘法。所有局部因子为 I 加幂零算子，故对每个复 s 均可逆，其逆是有限多项式。于是负 logarithmic derivative 是合法的有界算子：

\[
\boxed{\mathcal L_{a,N}(s):=-\mathcal D'_{a,N}(s)\mathcal D_{a,N}(s)^{-1}
=\sum_{p^e\Vert N}\log p\sum_{j\ge1}
[1-(e+1)1_{(e+1)\mid j}]p^{-js}U_{p^j}.}
\tag{DW4}
\]

每个看似无穷的内和实际上在 p^j>=exp(2a) 后为零。证明对 Q=p^-s U_p 使用 G_e(Q)=(I-Q^(e+1))(I-Q)^-1，并计算 -G'_e G_e^-1=log p[Q/(I-Q)-(e+1)Q^(e+1)/(I-Q^(e+1))]。所有因子交换，乘积的 logarithmic derivative 可以相加。没有在标量零点处作除法，也没有假设标量 Z_N(s) 不为零。

取 f_h(x)=1_I(x)4exp(x/2)h(exp x)，则同一半密度精确给出

\[
\mathcal D_{a,N}(1/2)f_h=E_{a,N}^{\rm div}h.
\tag{DW5}
\]

若每个可见 p^j<exp(2a) 均整除 N，(DW4) 中的所有修正位移均不可见，得到

\[
\boxed{\mathcal L_{a,N}(1/2)=
\sum_{p^j<e^{2a}}\frac{\log p}{p^{j/2}}U_{p^j}=B_+.}
\tag{DW6}
\]

这是与原 Weil 素数作用的精确对应。Robin 标量在 s=1 取值，本式的 s=1/2 来自原 Weil 半密度，不能混用。Gamma 和 pole 部分不在 (DW6) 内。有限 Fourier 再压缩也不必保持 U_d U_e=U_de，因此先在原 H_a 上完成对应，再使用原来的完整耦合证书；不得把有限矩阵乘法自动视为同一个乘积。

## 5. 首个缺失素数幂给出锐的覆盖边界

对 N>0 令 q(N)=min{m>=2:m 不整除 N}。q(N) 必为素数幂：否则它的互素素数幂因子都更小，分别整除 N，合起来会使 q(N) 整除 N，矛盾。所有整数 d<exp(2a) 都整除 N，等价于 exp(2a)<=q(N)。因此 (DW6) 在

\[
\boxed{a\le\tfrac12\log q(N)}
\tag{DW7}
\]

精确成立。这个边界在算子意义下是锐的：超过它后，最小遗漏 p^(e+1) 的 (DW4)-B_+ 系数为 -(e+1)log(p)*p^(-(e+1)s)，且相应平移非零。有限个不同平移在窗口中线性独立，可用足够窄的支撑隔离最小非零项，故该差算子非零。e=0 包括完全缺失的素数。

若 N=p^e m、p 不整除 m，补高一步还给出具体差公式

\[
\boxed{\mathcal D_{a,pN}(s)-\mathcal D_{a,N}(s)
=p^{-(e+1)s}U_{p^{e+1}}\mathcal D_{a,m}(s).}
\tag{DW8}
\]

它说明补指数可以改变全局标量 divisor sum，同时在 exp(2a)<=p^(e+1) 的窗口中完全不可见。这是 PaddingRatio 所研究的同一指数操作在当前算术窗口中的对应，不能从相对标量增益直接推得算子下界。

## 6. 5040 的具体结论和限制

5040=2^4*3^2*5*7；2520=2^3*3^2*5*7。两者都包含 1 至 10 的全部因数，首个缺失整数均为 11。六点 golden cell 的六个整数也都如此。因此每个 carrier 的 (DW6) 都在 exp(2a)<=11 的 L2 窗口精确成立。新 Lean 的逐点实例采用稍强的 exp(2a)<=10，未把零测端点处理冒称为已形式化。

2520 与 5040 彼此的首个不同因数是 16，所以它们两套 divisor 算子相互相等的阈值可延伸到 exp(2a)<=16。这个“彼此相等”与“等于完整素数算子”的阈值 11 是两件事；11 以上它们可以共同遗漏原算术信息。

精确标量值 Z_2520(1)=26/7，Z_5040(1)=403/105，二者不同。六点 cell 的 Robin 余量也有不同符号，而在上述小窗口中它们给出相同的完整算术合成。因此小窗口等价不能恢复全部 Robin 余量，更不能把某一点的标量符号作为整个 Weil 形式的符号。

5040 在 Robin 判据中确实重要：RH 等价于所有 n>5040 满足 sigma(n)<exp(gamma)*n*loglog n。该等价判据可在 Banks-Hart-Moree-Nevans 的原始研究 arXiv:0710.2424 中核对。本节没有无条件宣称“5040 是全部自然数中的最后例外”，也没有证明该全称不等式。

可用于无界窗口的确定性 carrier 是 N_R=lcm(1,...,R)，或更冗余的 R!。每个 d<=R 均整除它，故任意固定窗口最终精确表示同一 B_+，并且 (DW1) 的缺失 seed 项最终为零。这个全尺度的算术表达不产生最低谱间隔或 uniform prolate 误差。若用大型 N_R 的标量范数粗界替代算子结构，仍可能丢失全部有用抵消。

## 7. 实际检查与研究边界

原点归一化 verifier 在 110、130 位定向区间精度均实际通过，重放前置实际算术对偶与真正 prolate 验证。原点初始方向未经假定；最终代码使用真实负原点值及其模长。工作精度不代表所有输入都有同等准确度，前置 bulk symbol 仍用其原来的向外舍入包络。没有新 eigensolver、zeta 值或零点数据。

精确诊断运行了 720 个有理乘法坐标/支撑/seed 例子，每例核对两条函数恒等式；960 个 Dirichlet logarithmic derivative 系数与独立 Euler 局部式逐项相等；另有两条符号复商恒等式、120 组有理商例子、300 个首缺失素数幂例子。5040 的 11 项缺失及 25 项负系数有明确失败对照：在 25 处有限 logarithmic derivative 的系数为 -log5，而原 B_+ 为 +log5。例子只是诊断，普遍性依赖上面的证明。

已读实际源码：loning 研究链 #6050 `GoldenCell5040Certificate.lean` at c5ea3ae9e24175119146686dac3b64d2aff9be4b；#6131 `PaddingRatio.lean` at bc79fbdf7e984037434eee40e852b5ef49abdb17；dev 的 `HiddenArithmeticWeightFormula.lean` 及 `ZECKENDORF_EULER_5040.md`。这些 PR 自报的编译状态未在本轮重放。主线保持 #5602 的实际算术定义，并按既有 #5882/#5895 的能量与归一化误差结构记账，没有新增通用 quotient 定理。

本节完成两个精确对应：有非零分母证据的原点归一化真模态比较，以及有限 divisor data 到原始 prime action 的函数级字典。仍未完成沿无界尺度的正交补强制性、对偶系数衰减、真实最低模态的 Xi 极限。Connes-Consani-Moscovici Sections 7-8 以及 Connes 2026 综述仍将模型极限与这些逼近要求分开，本节不把 carrier 的精确覆盖替代它们。

参考：

- Connes, Consani, Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1, Sections 3-4 and 7-8. https://arxiv.org/html/2511.22755v1
- Connes, *The Riemann Hypothesis: Past, Present and a Letter Through Time*, arXiv:2602.04022v1, Sections 6.4-6.6. https://arxiv.org/html/2602.04022v1
- Banks, Hart, Moree, Nevans, *The Nicolas and Robin inequalities with sums of two squares*, arXiv:0710.2424, Monatsh. Math. 157 (2009). https://arxiv.org/abs/0710.2424
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
诊断源 SHA-256：`fd24021b55526ae061f22ecf327030c929836dd343d699aa2a89e2252edc8aff`。

校核补记：第二表达诊断最初复用了一个已消耗的迭代器，导致有理复向量求和只检查实部。现已先物化系数列表，加入非零虚部控制，并重新执行全部诊断。主区间验证器、两个精度的谱结果和前述解析证明均未改变。

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


---

## [PR #5602] UNIFORM_SCHUR_CERTIFICATE_ACROSS_PRIME_THREE

# 2026-09-07：穿过素数 3 激活点的完整区间 Schur 证书与奇块三次抑制

本节的两个源码为 `D5/S3/Weil/ZetaBridge/WeilPrimeThresholdParity.lean` 及其同名 Scribe。数值源为 `research/weil_ground_mode/certify_prime3_scale_interval.py`，独立表达式诊断为 `test_prime3_scale_interval.py`。下面给出的有限区间数字已在 70、100 位定向区间精度执行；Lean elaboration、Scribe emission 和传递公理报告没有执行。完整 Fourier/闭形式实现、Neumann 比较和以下无穷 Schur 推导仍为纸面桥，不能视作端到端内核结果。

本次对一个非退化参数区间直接认证，而不从上节的最坏情形 resolvent 模量逐步传播：

\[
I_*=[a_*-2\cdot10^{-8},a_*+2\cdot10^{-8}],\qquad a_*=\tfrac12\log3.
\tag{PT1}
\]

在整个区间中，明确的同一 Fourier 系数候选族满足 q_a(k_a)<1.2e-6，整个候选正交形式域满足 q_a(f)>=6e-6||f||^2。因此真实最低模态简单、偶，并有统一间隔大于 4.8e-6。此数值证书不假设旧的数值谱间隔或最低值包络。区间仍很窄，尚未认证这里的真模态/prolate 误差，也未成为无界尺度证明。

## 1. 当前研究背景与实际复用

CCM, *Zeta Spectral Triples*, arXiv:2511.22755v1，Section 8 将真实最低模态的单纯偶性与充分精确的 prolate 比较分开。这里直接处理前者在一个含激活点的参数区间上的完整证书，不以增加孤立数值点代替它。

本轮读取 #5895 在 `83f2bd4c2059bbe555447a594abc492fb16f6452` 的实际 `GenuineModelDualTransport.lean`，特别是正移位形式的能量 Young 不等式及 `positive_form_complement_coercivity`。该工作处理同一形式中候选方向的改变；本节处理形式随 a 改变，因此不复制其通用论证，也不将未合并源码隐式导入。

读取 loning 研究链 #6171 的 `Mertens/Third.lean`，blob `435484ecbfc11097a057d6b435045728a6e41f01`。其标量 Mertens III 对 Robin/Gronwall 研究有用，未作为本节 s=1/2 平移作用的范数估计。上节 5040 的首缺失素数 11 提醒了普通范数跳变；当前区间同样跨过素数 3 的真实激活。

交付期间，同一研究分支并行推进到 `4804c4020d7d9f165a2e2683c42b01e3d47a8be4`。实际读取其 `WeilPrimeActivationEdge.lean` 和 `certify_prime3_scale_schur.py`：前者处理偶块 rank-one 主项和零 trace 偶模板的五次界，后者记录 N=128、半宽 1e-8 的证书。本节的奇轮廓三次界与其互补；数值部分借鉴保留 Gram 方向性的 Young 处理，但重新独立计算 N=64、半宽 2e-8 的全部加权 Schur 数据。没有把初步完成的半宽 1e-9 证书重复报告为最新前沿，也没有将并行结果文件作为当前证明输入。

Dusson-Sigal-Stamm, arXiv:2008.10871 的 Feshbach-Schur/Fourier 谱离散分析提供经典方法背景。本节所有 Gamma、prime、pole 和高补空间估计均按同一个 Weil 算子推导，不移植 Schrödinger 正则性假设。原 `certify_prime3_refined.py` 以 SHA-256 `8bb067fc5499b0f2e1e48836e7a82237a15504109f82a856c72478d1096d69d0` 固定，仅复用其算术区间例程和明确候选数据，不执行其旧谱结果作为输入。

## 2. 同一个实参数算术矩阵，激活项精确表示

令 L=2a，使用原基 V_n(x)=(-1)^n exp(2pi*i*n*x/L)/sqrt(L)，窗口外零延拓。经 J_a 酉伸缩，其基在 [-1,1] 上固定为 (-1)^n exp(i*pi*n*y)/sqrt(2)。固定候选整数系数除以其精确范数后定义 k_a；没有把未知 ground 当作 k_a。

在 (PT1) 上，log2<L<2log2，素数 4 及更大 prime powers 尚未进入。定义实际归一化交叠长度

\[
h_2=2-2\log2/L,\qquad h_3=\max(0,2-2\log3/L),\qquad
w_p=\log p/\sqrt p.
\tag{PT2}
\]

在边界符号和实际对角中，两个素数的贡献分别为

\[
s^{\rm prime}_L(n)=\sum_{p=2,3}w_p\sin(\pi n h_p),\qquad
A^{\rm prime}_{nn}=-\sum_{p=2,3}w_ph_p\cos(\pi n h_p).
\tag{PT3}
\]

这是原 -w_p sin(omega_n log p) 与 -2w_p(1-log p/L)cos(omega_n log p) 的精确格点相位改写；h_p=0 时两项均为零。端点等号是 L2 零测作用，(PT3) 跨阈值有效。程序对 L 的整个闭区间计算正部分包络，不将抽样或中心条件当作区间条件。

完整边界符号为原 pole、无限 Gamma 边界级数与 (PT3) 的和，omega_n=2pi n/L。完整对角使用同一 digamma、trigamma、指数修正、pole 及 (PT3)。Gamma 指数修正保留前 32 项并显式包住无限尾。新的 sine 例程在选择整数周期后先严格检查余量位于 (-4,4)，再以 63 次 Taylor 多项式和 4^64/64! 的明确尾界覆盖整个参数区间；浮点周期选择不提供正确性假设。有限工作精度与 bulk binary64 符号包络的准确度分开：每个 bulk 运算都向外舍入，最终各项误差继续进入矩阵证书。

## 3. 先做实际奇偶合并，再产生区间 Gram

对原 a_mn=(s_n-s_m)/(pi(m-n))，s_-n=-s_n。实际偶、奇配对列是

\[
C^+_{mn}=\frac{2(ns_n-ms_m)}{\pi(m^2-n^2)},\qquad
C^-_{mn}=\frac{2(ms_n-ns_m)}{\pi(m^2-n^2)}.
\tag{PT4}
\]

新 Lean `arithmetic_parity_pair_columns` 从原 `couplingColumn` 展开证明两式，使用已证明的原符号奇性，并先排除全部分母碰撞。Lean 的 c 参数仍按原 owner 为自然数；实 L 的算术表达及其奇性在本节独立按同一公式解释，没有把 c 自然数定理冒用成实尺度实现。

在正交归一 parity 基 E_0=V_0、E_n=(V_n+V_-n)/sqrt2、O_n=(V_n-V_-n)/sqrt2 中，正高编号之间的矩阵元素恰是 (PT4)，偶零列为 -sqrt2*s_m/(pi*m)。偶低块的 n>0 对角是 A_nn-s_n/(pi*n)，奇低块是 A_nn+s_n/(pi*n)。奇扇区乘整体 i 不改变矩阵或能量。

这些相消在区间量化之前完成。实际高空间的正负编号已合并为一个正交 parity 坐标，因此后续不得再重复乘二。程序对每个 parity 块分别形成全体 65<=m<=32768 的 Gram，并保留参数区间造成的系数半径。

## 4. 新 Lean 的另一个具体结果：奇低块的三次激活能量

在固定空间采用实奇基 (-1)^n sin(pi*n*y)，其范数为 1。对有限复系数 v_n，记 F(t)=sum v_n sin(pi*n*t)。当新平移 s=2-h、0<=h<=1，左、右条带的轮廓分别为 F(t) 和 -F(h-t)。所以实际 Weil 的负对称 prime 项恰为

\[
Q^-_{w,h}(v)=w\int_0^h
\{\overline{F(t)}F(h-t)+\overline{F(h-t)}F(t)\}\,dt.
\tag{PT5}
\]

新 `oddPrimeActivation` 先独立定义这个完整复积分。其 integrand 是连续函数，所有交叉项保留。由 |sin(pi*n*t)|<=pi*n*|t|，令 B=sum n|v_n|，则积分内模长至多 2pi^2 B^2 t(h-t)。有限 Cauchy-Schwarz 和精确多项式积分给出

\[
\boxed{\|Q^-_{w,h}(v)\|\le
\frac{w\pi^2h^3}{3}
\left(\sum n^2\right)\left(\sum|v_n|^2\right),\qquad w,h\ge0.}
\tag{PT6}
\]

`odd_prime_activation_cubic_bound` 保存 (PT6)，不接收边界值、组装后能量或积分值的假设。其积分表达对任意非负 h 都成立；与两个不交物理条带的识别使用 h<=1，正编号基下的系数平方和是实际 L2 范数。

(PT1) 内 h3<=7.281914e-8，取 S={1,...,64} 后，对实际 w3 的 (PT6) 右侧系数再作定向检查，得到低奇块的新增素数能量范数上界小于 1e-16。这里是该有限块的预算，完整 Schur 计算仍使用未粗化的矩阵。

(PT6) 的常数随有限频率集合增长。因此它与上一节全空间范数跳变、参考形式仅有对数模量完全相容。数值证书仍使用完整实际矩阵元素，没有用粗的 h^3 上界代替高低耦合计算。

## 5. 整个高补空间的统一下界

令 L_+=log3+4e-8、n0=65、w=w_2+w_3。整个参数区间内，每个可见非零 prime 平移在固定空间的位移大于 1，其对称块范数至多 1；故全高空间 prime 债保守使用完整 w，绝不以 h3 很小为理由省去 w3。

偶空间沿用原 Neumann Gamma resolvent 完成式及偶 pole 非负性。对所有高偶系数 y_n，得到 q_a(y)>=sum d^+_n |y_n|^2，其中

\[
d^+_n=\log(n/L_+)-L_+/(\pi n)-w.
\tag{PT7}
\]

奇空间的独立全高界可以从原 Γ 对角和离散 Hilbert 交换子直接核对。首先，digamma 调和极限与 t/(t^2+y^2) 的积分比较给出 Re psi(x+iy)>=log|y|-1/|y|，x>0、y!=0；误差由该函数总变差不超过 1/|y| 控制。因而 gamma(omega_n)>=log(n/L)-L/(pi*n)。

Gamma 对角相对乘子值的边界修正模长至多 L/(2pi^2*n^2)+1/(4n)。这是用 (2/L)sum 1/(b_j^2+omega_n^2) 包住完整边界级数，再将递减求和与积分比较得到。高空间 Gamma 边界符号满足 |sGamma_n|<=pi/4+1/|omega_n|；标准离散 Hilbert 核 1/[pi(m-n)] 的 l2 范数为 1，所以其交换子范数至多 pi/2+L_+/(pi*n0)<2。这个最后严格界在程序中执行检查。

奇 pole 的负范数为 2sinh(L/2)-L。合并并作安全的 n0 统一放宽，得到整个奇高空间下界

\[
d^-_n=\log(n/L_+)-2-\frac{2L_++1}{\pi n_0}
-\frac{L_+}{2\pi^2n_0^2}-w-\{2\sinh(L_+/2)-L_+\}.
\tag{PT8}
\]

这些是整个高子空间的形式不等式，不能只从逐对角值推出。有限高组合通过已有共同闭形式域的稠密性推广；没有遗漏 Gamma 非对角项。每个 dyadic shell 使用其首编号的经过检查的有理下界。n=65 的偶、奇下界分别为 `24750975/8388608` 与 `927117/1048576`，均远大于本次 tau=6e-6。

## 6. 全无限 Schur 上预算和严格区间合同检查

令 tau=6/10^6。对每个 parity，低高块为 C、高块为 H。由 (PT7)-(PT8)，H-tau>=diag(d_n-tau)>0，所以 Schur 扣除项满足

\[
C^*(H-\tau)^{-1}C\preceq C^*\operatorname{diag}((d_n-\tau)^{-1})C.
\tag{PT9}
\]

先对 65..32768 的实际区间 C 取 dyadic 中点 X，分母 2^44，逐项误差半径分母 2^60。每个 shell 的 X^*X 用有溢出 guard 的整数算法精确算出，误差半径平方和使用任意精度整数。设 D 是正的 shell 权重，e>=||D^(1/2)(C-X)||_F^2。取明确正有理数 theta=1/200，逐向量应用 Young 不等式得到 C^*DC<=(1+theta)X^*DX+(1+1/theta)e I。程序因此保留 201/200 倍的原 Gram 方向性，只增加 eta=201e 的单位阵预算；theta 的额外正代价也完整扣入 Schur 补。中点和误差都是从当前整个参数区间重新计算，不能省去任一项。

m>32768 的所有模式使用完整边界符号包络 B=4，其实际有限 prime、pole、Gamma 上界在程序中重查。原二阶耦合展开保留四个矩，配合正负 parity 给出秩至多四的正尾预算，另加 `2/10^12` 倍单位阵的余项。该余项逐次检查大于 16B^2 N^4(2N+1)/[pi^2(1-N/M)^2 M^5]。所有无穷平方级数由积分比较包住，没有更远的终端截断。

合并 shell 与无限尾后的矩阵 W_+、W_- 是 (PT9) 的上界。偶低块另加实际未归一化候选 vv^*，奇块不加。最终需要同时确认

\[
A^+_{\rm low}-W_+-\tau I+vv^*\succ0,\qquad
A^-_{\rm low}-W_--\tau I\succ0.
\tag{PT10}
\]

原坐标的 interval LDL 曾无法判定，不能由此推断负特征值。程序用浮点 Cholesky 仅提出坐标变换，再舍入成分母 2^32 的精确 dyadic 方阵 R。对完整区间矩阵直接计算 R^T A R，再作严格定向 LDL。正定 R^T A R 本身蕴含 R 单射，方阵即双射，所以无需相信浮点可逆性或中点 Cholesky 的判断。输出的 pivot 只是合同后计算诊断，不是原算子的特征值下界。

## 7. 一次认证覆盖整个参数区间

70 位和 100 位运行分别确认 (PT10)，并在同一个区间包络中确认明确归一化候选 k_a 的 Rayleigh 上界。结果为

\[
\boxed{q_a(k_a)<U=\frac6{5\cdot10^6},\qquad
f\perp k_a\Longrightarrow q_a(f)\ge\tau\|f\|^2,
\quad\tau=\frac6{10^6},\quad a\in I_*.}
\tag{PT11}
\]

实际候选 Rayleigh 的区间显示约为 [-9.5152736e-7,1.0637090e-6]，因此 U 留有裕量。偶加秩一证书在候选正交方向上严格消去该秩一项；奇扇区整体高于 tau。由已有同一 Friedrichs 实现的紧 resolvent 与 min-max，

\[
\boxed{\lambda_0(a)<U<\tau\le\lambda_1(a),\qquad
\lambda_1(a)-\lambda_0(a)>\frac3{625000}.}
\tag{PT12}
\]

最低特征值单纯；若最低向量为奇，则与奇扇区下界矛盾，故为偶；它与 k_a 的内积也不能为零。这是实际一族窗口的 simple-even/gap 证书，不是某个有限子矩阵的本征值图。此轮没有宣称 A_a 全空间非负，没有假设旧的数值 ell、U、T，也没有把新的 k_a 认作 prolate 模型。

旧的通用形式连续性半径是 2^-9259287090。本次直接区间证书覆盖半宽 2e-8，不需要沿那个极小半径做数十亿次传播。即便如此，当前新区间仍很窄，不能称为实用的无界尺度扫描。证明更大跨度和控制真实模态/prolate Fourier 误差仍然是下一项。

## 8. 复验、形式化范围和未解决部分

最终交付数值源 SHA-256：`0bbadda0977f11052c7c492d2d44f958f6318b89954587486edc4bc6db796688`。诊断源 SHA-256：`5467e6f5b50395ebcfb033e5d4f92949458f8a9ce953c784fca4814c03c19257`。本次补交只删除了若干 Python 注释，并纠正 Scribe 中过时的区间半径说明；程序执行逻辑未改，最终版本重新在 70、100 位精度运行通过，诊断也重新运行通过。结果 JSON 的排版不作为数值精度证据。

诊断通过三个符号恒等式、800 个精确 parity 列等式、120 个精确 Gram 半径例子、36 个独立原符号参考值、45 个原对角参考值和 72 个原 prime 相位比较。另有 20 个直接物理奇轮廓积分与 (PT5) 的对照。后面的点值与求积使用非定向高精度，仅为另一表达式的诊断，不是 (PT11) 的区间证明。其 Gamma 指数参考尾小于 3.28e-248。三个不定/奇异矩阵均被严格 LDL 拒绝。

Lean 的三个公开定义/定理有三个对应 FromLean Scribe 项。区间认证器复用原算术例程的固定源码，新的中点 Cholesky 只产生待验证坐标；它不运行 eigensolver、不使用 zeta 零点、不用旧的数值谱结论，也没有把 CI 或 Scribe 状态计为数学证据。不存在已执行的新 Lean 内核、传递公理或独立作者审稿声明。

本节推进的是：保留实际 parity 抵消、全高块下界和低高耦合后，可以跨过真实素数激活点直接得到一个连续参数族的完整余维一强制性。剩余任务是将该区间方法与真实 prolate 族和既有能量对偶读出联合，扩大跨度并控制归一化 Fourier 差。无界尺度上的 Xi 极限或 RH 未由本节建立。

参考：

- Connes, Consani, Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1, Sections 3-4 and 8. https://arxiv.org/html/2511.22755v1
- Dusson, Sigal, Stamm, *Analysis of the Feshbach-Schur method for the Fourier spectral discretizations of Schrödinger operators*, arXiv:2008.10871. https://arxiv.org/abs/2008.10871
- NIST DLMF 5.7.6, digamma partial fractions; mathematical constants and tail identities retain the pinned arithmetic source conventions. https://dlmf.nist.gov/5.7.E6
- Actual #5895 `GenuineModelDualTransport.lean` at `83f2bd4c2059bbe555447a594abc492fb16f6452`; loning research #6171 `Mertens/Third.lean`, blob `435484ecbfc11097a057d6b435045728a6e41f01`.
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
