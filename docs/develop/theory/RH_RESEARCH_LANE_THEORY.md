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
&\sim \text{提升更新的非交换曲率},
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

1. 在绝对收敛半平面中建立有限或无限黄金壳测度的 Fourier 系数与 `-L'/L` 垂直采样之间的定理；
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
2\|a-1\|\varepsilon
+2\varepsilon^2
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
\frac{e^{\delta t}-e^{-\delta t}}{2}.
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
}
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

---

## [PR #5065] CANONICAL_ZERO_DATA_NONVACUITY

# Canonical `ZeroData` inhabitant 与全称命题非空洞性

**候选 GID：**

- `D5/S3/Weil/ZetaBridge/RiemannVonMangoldtCountGrowth`
- `D5/S3/Weil/ZetaBridge/CanonicalZeroDataFromRiemannVonMangoldt`
- `D5/S3/Weil/ZetaBridge/ZeroDataSemanticNonvacuity`
- `D5/S3/Weil/ZetaBridge/CanonicalZeroDataProvider`
- `D5/S3/Weil/ZetaBridge/CanonicalZeroDataNonvacuityAssembly`

## 1. 语义空洞位于 `ZeroData` 的外层类型

仓库的 `ZeroData` 使用固定索引类型 `ℕ`。一旦存在一个值

```lean
Z : ZeroData
```

则 `Z.zero 0` 已经是由结构字段证明的非平凡 zeta 零点。因此本路线中的语义空洞风险不来自单个 `ZeroData` 的索引集为空，而来自类型 `ZeroData` 本身可能没有 inhabitant。

此时一个命题

\[
\forall Z:\operatorname{ZeroData},\;P(Z)
\]

可以在没有任何零点枚举被实例化时成立。

新节点定义：

\[
\boxed{
\operatorname{RealizedZeroDataClaim}(P)
\iff
\exists Z:\operatorname{ZeroData},\;P(Z).
}
\]

并形式化两条逻辑边：

\[
\neg\operatorname{Nonempty}(\operatorname{ZeroData})
\Longrightarrow
\forall Z:\operatorname{ZeroData},\;P(Z),
\]

\[
\operatorname{Nonempty}(\operatorname{ZeroData})
\land
\bigl(\forall Z:\operatorname{ZeroData},\;P(Z)\bigr)
\Longrightarrow
\exists Z:\operatorname{ZeroData},\;P(Z).
\]

所以后续审计必须区分“全称条件定理已经证明”和“该定理已经在真实 zeta 零点枚举上实现”。

## 2. Riemann–von Mangoldt 关闭非空洞链

`RiemannVonMangoldtCountGrowth` 从仓库已有结构字段中抽取：

\[
N_Z(T,2T)
=
\frac{T}{2\pi}\ell_1(T)+O(\log T),
\]

并证明：

\[
\boxed{
N_Z(T,2T)\longrightarrow+\infty.
}
\]

将其应用于 set-level canonical source `Zeta23.zetaZeroConfig`，得到：

\[
\boxed{
\begin{aligned}
&\operatorname{RiemannVonMangoldt}
  (\operatorname{zetaZeroConfig})
\\
&\Longrightarrow
N(T,2T)\to\infty
\\
&\Longrightarrow
\operatorname{zetaZeroConfig.carrier}\text{ infinite}
\\
&\Longrightarrow
\{\rho:\operatorname{IsNontrivialZero}(\rho)\}\text{ infinite}
\\
&\Longrightarrow
\operatorname{Nonempty}(\operatorname{ZeroData}).
\end{aligned}
}
\]

最后一箭头直接复用仓库已有的精确定理：

\[
\operatorname{Nonempty}(\operatorname{ZeroData})
\iff
\{\rho:\operatorname{IsNontrivialZero}(\rho)\}\text{ infinite}.
\]

因此新节点没有再次构造可数性、枚举、解析重数、反射、共轭或局部有限性证明。

## 3. Canonical provider 的含义

定义：

```lean
structure CanonicalZeroDataSource : Prop where
  riemannVonMangoldt :
    Zeta23.RiemannVonMangoldt Zeta23.zetaZeroConfig
```

由该 source 选择：

\[
\operatorname{canonicalZeroData}(S)
:
\operatorname{ZeroData}.
\]

该值满足：

1. 每个枚举项都是真实非平凡 zeta 零点；
2. 每个真实非平凡 zeta 零点恰有一个自然数索引；
3. 存储的解析重数严格为正；
4. `ρ ↦ 1 - ρ` 的函数方程反射在索引上忠实实现并保持重数；
5. 复共轭在索引上忠实实现并保持重数；
6. 每个对称谱半径截断是有限集。

“canonical”在此表示 canonical zeta-zero object 及其不依赖枚举的观察量。自然数排序由 classical choice 选出，不声称是可计算或唯一的顺序。

仓库已有枚举不变性定理被直接复用。对任何另一份 `Z : ZeroData`：

\[
\operatorname{truncatedZeroSum}
(\operatorname{canonicalZeroData}(S),g,T)
=
\operatorname{truncatedZeroSum}(Z,g,T),
\]

对应的 `SymmetricConvergent` 命题等价，收敛后的 `zeroSum` 值相等。

## 4. 最终 certificate 与闭合主定理

`CanonicalZeroDataCertificate` 将下游消费者所需义务显式打包：

```text
actual ZeroData value
exact representation
unique exhaustive index
positive analytic multiplicity
reflection fidelity
conjugation fidelity
finite symmetric cutoffs
```

其精确表示定理为：

\[
\boxed{
\operatorname{IsNontrivialZero}(\rho)
\iff
\exists!n\in\mathbb N,\ C.data.zero(n)=\rho.
}
\]

主装配定理：

```lean
canonical_zeroData_closed_chain
```

证明：

\[
\boxed{
\operatorname{RvM}(\mathcal Z_\zeta)
\Longrightarrow
\left[
\mathcal Z_\zeta\text{ infinite}
\land
\operatorname{Nonempty}(\operatorname{ZeroData})
\land
\exists C:\operatorname{CanonicalZeroDataCertificate}
\right].
}
\]

扩展定理 `exists_faithful_zeroData_of_riemannVonMangoldt` 直接返回一个实际 `ZeroData`，以及全部表示、重数、对称和局部有限保证。

## 5. 全称命题的语义实现

对任意谓词：

```lean
P : ZeroData → Prop
```

如果已经证明：

```lean
h : ∀ Z : ZeroData, P Z
```

则 canonical source 给出：

\[
\boxed{
\exists C:\operatorname{CanonicalZeroDataCertificate},
\quad
P(C.data)
\land
\exists\rho:\mathbb C,
\operatorname{IsNontrivialZero}(\rho).
}
\]

因此围绕 `ZeroData` 的全称定理可以被实例化到一个真实、穷尽、重数忠实的 zeta 零点枚举上。外层类型为空导致的语义空洞由该 certificate 消除。

## 6. 当前 claim boundary

本 PR 关闭的是以下完整逻辑链：

\[
\boxed{
\begin{aligned}
\operatorname{RiemannVonMangoldt}
  (\operatorname{zetaZeroConfig})
&\Longrightarrow
N(T,2T)\to\infty
\\
&\Longrightarrow
\text{nontrivial-zero set infinite}
\\
&\Longrightarrow
\operatorname{Nonempty}(\operatorname{ZeroData})
\\
&\Longrightarrow
\text{actual exhaustive multiplicity-aware enumeration}
\\
&\Longrightarrow
\text{canonical provider and certificate}
\\
&\Longrightarrow
\text{universal ZeroData claims are realized}.
\end{aligned}
}
\]

`RiemannVonMangoldt zetaZeroConfig` 在本 PR 中仍作为显式 source。把 provider 进一步升级为 hypothesis-free 常量，需要将仓库中的 global Riemann–von Mangoldt assembly 独立接入该 source。该剩余步骤属于解析数论 owner 的实例化，不再是 `ZeroData` 的枚举、重数、对称或语义逻辑缺口。

本节不声明 RH，不使用 RH，也不把尚未经过 admission 的 Candidate 描述为 Frozen。

---

## [PR #5065] UNCONDITIONAL_CANONICAL_ZERO_DATA_CLOSURE

# 无参数 `zetaZeroData` 与解析来源闭合

本增补恢复本 PR 误删的历史理论段，并把此前显式接收 `RiemannVonMangoldt zetaZeroConfig` 的条件链升级为无参数机器构造。

新增 proof-complete 路径为：

\[
\boxed{
\begin{aligned}
\texttt{GammaStirlingVert.mu\_stirling}
&\Longrightarrow \texttt{GammaFacts},\\
\texttt{GammaFacts}
&\Longrightarrow \texttt{RiemannVonMangoldt(zetaZeroConfig)},\\
\texttt{RiemannVonMangoldt}
&\Longrightarrow N(T,2T)\to\infty,\\
&\Longrightarrow \mathcal Z_\zeta\text{ infinite},\\
&\Longrightarrow \operatorname{Nonempty}(\texttt{ZeroData}),\\
&\Longrightarrow \texttt{zetaZeroData : ZeroData}.
\end{aligned}
}
\]

机器 owner 为：

```text
D5/S3/Weil/ZetaGamma/GammaIntMu.lean
D5/S3/Weil/ZetaGamma/GammaFactsComplete.lean
D5/S3/Weil/ZetaPntBase/ZetaConj.lean
D5/S3/Weil/ZetaRvm/Defs.lean
D5/S3/Weil/ZetaRvm/NcountWindow.lean
D5/S3/Weil/ZetaRvm/GammaSide.lean
D5/S3/Weil/ZetaRvm/BacklundDefs.lean
D5/S3/Weil/ZetaRvm/ReZeroCount.lean
D5/S3/Weil/ZetaRvm/Backlund.lean
D5/S3/Weil/ZetaRvm/Fold.lean
D5/S3/Weil/ZetaRvm/MainTerm.lean
D5/S3/Weil/ZetaRvm/Statement.lean
D5/S3/Weil/ZetaBridge/UnconditionalCanonicalZeroData.lean
```

`zetaZeroData` 是一个固定的自然数索引 presentation。其顺序由 `Classical.choice` 选出。canonical 内容位于它穷尽表示的真实非平凡零点集合、解析重数、反射与共轭作用，以及已经证明为枚举不变的零点观察量。

无参数接口闭合以下事实：

1. `ZeroData` 确实有 inhabitant；
2. 每个 `zetaZeroData.zero n` 都是真实非平凡 zeta 零点；
3. 每个真实非平凡零点恰有一个索引；
4. 存储重数是严格正的解析零点阶；
5. 函数方程反射与复共轭由索引置换忠实实现，并保持重数；
6. 每个对称谱半径截断有限；
7. 枚举上的全称命题与真实非平凡零点上的全称命题等价；
8. 围绕 `ZeroData` 的任意全称结构定理都可以直接实例化到 `zetaZeroData`。

本增补没有为自然数编号赋予高度排序、可计算性或内在意义，也没有使用 RH。它关闭的是实际零点对象进入既有 `ZeroData` consumer DAG 的语义入口。


---

## [PR #5065] MIRROR_KREIN_OPERATOR_GEOMETRY

# 无参数 zeta 零点的镜像 Krein 算子几何

**候选 GID：**

```text
D5/S3/Weil/ZetaBridge/ZeroDataPresentationEquiv
D5/S3/Midline/Cayley/CanonicalZetaMirrorFundamentalSymmetry
D5/S3/Midline/Cayley/CanonicalZetaCayleyJUnitary
D5/S3/Midline/Cayley/FiniteMirrorKreinIndex
```

本节建立在同一 PR 的无参数对象 `zetaZeroData : ZeroData` 之上。全部陈述在 admission 完成以前属于 Candidate，Lean 声明承担唯一承重角色。

### 1. presentation 选择与 canonical 内容

任意两个 `ZeroData` 值之间存在唯一的零点保持重标号：

\[
e_{Z,Z'}:\mathbb N\simeq\mathbb N,
\qquad
Z'.\operatorname{zero}(e_{Z,Z'}n)=Z.\operatorname{zero}(n).
\]

该等价同时保持解析重数、谱参数、函数方程反射、复共轭和同高度镜像，并满足恒等、逆与复合律。因此自然数编号仍是 choice-based presentation，零点、重数、对称作用以及沿唯一重标号运输的观察量具有 presentation-independent 内容。

### 2. 同高度镜像与固定点

定义 \(M_Z=C_Z\circ R_Z\)，其中 \(R_Z\) 是函数方程反射，\(C_Z\) 是复共轭。机器节点证明：

\[
Z.\operatorname{zero}(M_Zn)=1-\overline{Z.\operatorname{zero}(n)},
\]

\[
M_Z^2=I,
\qquad
m_{M_Zn}=m_n,
\qquad
\gamma_{M_Zn}=\overline{\gamma_n},
\]

以及：

\[
\boxed{M_Zn=n\iff\operatorname{Re}\rho_n=\frac12.}
\]

所以临界线是由函数方程与实结构预先确定的 involution 固定集。

### 3. fundamental symmetry 与严格负方向

镜像通过解析重数提升到：

\[
\mathcal I_Z=\sum_{n:\mathbb N}\operatorname{Fin}(m_n),
\]

并在 \(\mathcal H_Z=\ell^2(\mathcal I_Z)\) 上给出 involutive linear isometry \(J_Z\)。机器节点证明：

\[
J_Z^2=I,
\qquad
\langle J_Z\psi,\phi\rangle=\langle\psi,J_Z\phi\rangle.
\]

定义：

\[
[\psi,\phi]_{J_Z}=\langle\psi,J_Z\phi\rangle.
\]

每个被镜像移动的坐标 \(v\) 给出奇向量 \(v_-=e_v-J_Ze_v\)，并满足：

\[
J_Zv_-=-v_-,
\qquad
[v_-,v_-]_{J_Z}=-\|v_-\|^2<0.
\]

### 4. Cayley 算子无条件 J-unitary

对 \(c(\rho)=(\rho-1)/\rho\)，镜像坐标满足：

\[
c(1-\overline\rho)=\overline{c(\rho)}^{-1}.
\]

因此 multiplicity-expanded 对角 Cayley 算子 \(U_Z\) 满足：

\[
\boxed{U_Z^*J_ZU_Z=J_Z.}
\]

该结论只使用函数方程与复共轭对称，不使用 RH。普通 Hilbert 酉性是更强的临界线条件。

### 5. 有限镜像 Krein 指数

在有限对称谱窗口 \(S_T\) 中，从每个非固定二元镜像轨道选一个代表，并按解析重数展开。定义：

\[
\kappa_T=\sum_{\substack{n\in S_T\\n<M_Zn}}m_n.
\]

机器节点证明有限奇坐标空间的基数为 \(\kappa_T\)，其标准负型在每个非零向量上严格为负，并且：

\[
\boxed{\kappa_T=0\iff\forall n\in S_T,\ \operatorname{Re}\rho_n=\frac12.}
\]

---

## [PR #5065] MIRROR_KREIN_SECOND_LAYER_CLOSURE

# 换枚举不变性、正交偶奇分解、Krein 逆与真实 Gram 惯性

**候选 GID：**

```text
D5/S3/Midline/Cayley/ZeroDataHilbertPresentationTransport
D5/S3/Midline/Cayley/CanonicalZetaMirrorEvenOddDecomposition
D5/S3/Midline/Cayley/CanonicalZetaCayleyKreinInverse
D5/S3/Midline/Cayley/FiniteMirrorKreinGramInertia
```

### 1. 整个 Hilbert 算子系统与 presentation 无关

唯一零点保持重标号提升为 unitary：

\[
T_{Z,Z'}:\mathcal H_Z\simeq_u\mathcal H_{Z'}.
\]

它同时满足：

\[
TJ_Z=J_{Z'}T,
\qquad
TU_Z=U_{Z'}T,
\qquad
[T\psi,T\phi]_{J_{Z'}}=[\psi,\phi]_{J_Z}.
\]

因此镜像、Cayley 动力学和不定内积不依赖 choice-based 自然数编号。

### 2. 规范化偶奇投影

定义：

\[
P_+=\frac{I+J}{2},
\qquad
P_-=\frac{I-J}{2}.
\]

机器节点证明幂等性、互相湮灭、精确重建、\(\pm1\) 镜像本征律和 Hilbert 正交性。Krein 能量精确分解为：

\[
\boxed{\operatorname{Re}[\psi,\psi]_J=\|P_+\psi\|^2-\|P_-\psi\|^2.}
\]

所以负扇区是实际 mirror-odd spectral range。

### 3. 显式有界 Krein 逆

镜像互反使倒数 Cayley 系数可以由已有有界系数经镜像置换和共轭获得。由此构造有界双侧逆，并证明：

\[
\boxed{U^{-1}=JU^*J,}
\qquad
UJU^*=J.
\]

这一步不需要普通酉性或 RH。

### 4. 真实有限奇向量 Gram 惯性

对每个有限镜像轨道代表和每个重数副本，取实际 Hilbert 奇向量 \(v_i^-=e_i-Je_i\)。机器节点计算：

\[
[v_i^-,v_j^-]_J=-2\delta_{ij}.
\]

因此实际 Gram 矩阵是 \(G_T^-=-2I\)，并由仓库统一惯性接口证明：

\[
\boxed{\operatorname{negIndex}(G_T^-)=\kappa_T.}
\]

该定理确认零点目标几何本身拥有 \(\kappa_T\) 维负空间。它不意味着指定的标量 Weil 观察器能覆盖该完整 multiplicity-expanded 空间。

---

## [PR #5065] REDUCED_WEIL_OBSERVER_AND_MULTI_ORBIT_NEGATIVITY

# 标量偶 Weil 观察器的可达空间、约化因子分解与多轨道负证书

**候选 GID：**

```text
D5/S3/Weil/ZetaBridge/WeilEvaluationObservableSubspace
D5/S3/Weil/ZetaBridge/FiniteMirrorReducedWeilFactorization
D5/S3/Weil/ZetaBridge/FiniteEvenWeilOddInterpolation
D5/S3/Weil/ZetaBridge/QuantitativeMultiOrbitWeilNegativeCertificate
```

本增补修正“标量偶 Weil 测试满秩覆盖完整 multiplicity-expanded mirror-odd 空间”的过强目标。真实观察器只访问一个约化空间。所有新陈述在 admission 完成以前属于 Candidate。

### 1. 两个真实秩障碍

对有限窗口 \(I_T\)，标量评价为：

\[
E_T(g)(n)=\widehat g(\gamma_n),
\qquad
\widetilde E_T(g)(n,k)=\widehat g(\gamma_n).
\]

所以评价在每个解析重数纤维上常值，不能区分同一零点的不同副本。

同时，`WeilTestFunction` 的偶性给出 \(\widehat g(-z)=\widehat g(z)\)，而 \(\gamma_{R(n)}=-\gamma_n\)。因此：

\[
E_T(g)(R(n))=E_T(g)(n).
\]

新节点构造显式目标向量并证明：

\[
m_n\ge2\Longrightarrow\widetilde E_T\text{ 不满射},
\]

以及窗口中存在移动的反射对时：

\[
E_T\text{ 不满射到全部 distinct-zero vectors}.
\]

这说明 ambient Krein 负空间和 observer-reachable 负空间必须分开计算。

### 2. 约化有限镜像形式

定义 `FiniteReflectionEvenVector Z T` 为满足反射偶约束的 distinct-zero 向量。解析重数作为形式中的正权重保留，不再被重复解释为独立标量观察坐标。

对 \(v_g(n)=\widehat g(\gamma_n)\)，定义：

\[
B_T(v,w)=\sum_{n\in I_T}m_n v(n)\overline{w(M(n))}.
\]

机器节点证明实际有限卷积平方零点和满足：

\[
\boxed{\operatorname{truncatedZeroSum}(Z,\operatorname{convolutionSquare}(g),T)=B_T(v_g,v_g).}
\]

对任意有限选择的非实离线四点轨道块，已有单轨道公式被聚合为：

\[
\boxed{Q_{\mathrm{block}}=E_{\mathrm{even}}-E_{\mathrm{odd}},\qquad E_{\mathrm{even}},E_{\mathrm{odd}}\ge0.}
\]

### 3. 约化奇空间上的显式线性插值

`FiniteEvenWeilOrbitFrame` 记录有限个离线非实轨道通道及其两组节点 \(\gamma_i,\overline{\gamma_i}\)，并显式携带仓库有限偶插值定理所需的 sign-separation 条件。

对任意 \(a:\iota\to\mathbb C\)，机器节点构造偶 Weil 测试函数，使：

\[
\widehat g(\gamma_i)=a_i,
\qquad
\widehat g(\overline{\gamma_i})=-a_i.
\]

约化奇读数：

\[
O_i(g)=\frac{\widehat g(\gamma_i)-\widehat g(\overline{\gamma_i})}{2}
\]

于是满足 \(O_i(g)=a_i\)。节点进一步选择坐标测试函数 \(g_i\)，定义显式有限线性合成：

\[
S(a)=\sum_i a_i g_i,
\]

并证明：

\[
\boxed{O_j(S(a))=a_j.}
\]

因此 \(S\) 是约化奇读数的右逆，并且是单射。

### 4. 可观察奇 Gram 的精确负指数

定义约化奇形式：

\[
B^-(g,h)=-4\sum_i m_i\overline{O_i(g)}O_i(h).
\]

坐标插值基满足 \(B^-(g_i,g_j)=-4m_i\delta_{ij}\)。所以真实可观察奇 Gram 为：

\[
\boxed{G_{\mathrm{obs}}^-=-4\operatorname{diag}(m_i).}
\]

解析重数严格为正，因此：

\[
\boxed{\operatorname{negIndex}(G_{\mathrm{obs}}^-)=|\iota|.}
\]

每个 independently interpolated orbit channel 贡献一个负方向。重数决定权重与稳定裕量，不增加标量观察器维数。

### 5. 整个负子空间的定量稳定性

对一般有限权重 \(w_i\ge m>0\)，定义 \(Q_0(a)=-\sum_iw_i|a_i|^2\)。若完整形式满足：

\[
Q(a)=Q_0(a)+R(a),
\]

并且存在统一二次余项界：

\[
|R(a)|\le\varepsilon\sum_i|a_i|^2\quad\text{对所有 }a,
\]

且 \(\varepsilon<m\)，则新通用定理证明：

\[
\boxed{a\ne0\Longrightarrow Q(a)<0.}
\]

这是整个有限维负子空间的稳定性结论。仅逐基向量控制余项不足，因为交叉项仍可能破坏线性组合上的负定性。

在 Weil 特化中：

\[
Q_{\mathrm{target}}(a)=-4\sum_i m_i|a_i|^2,
\]

\[
Q_{\mathrm{full}}(a)=\operatorname{Re}\operatorname{zeroSum}\left(Z,S(a)*\widetilde{S(a)}\right),
\]

并精确定义 \(R(a)=Q_{\mathrm{full}}(a)-Q_{\mathrm{target}}(a)\)。`QuantitativeMultiOrbitCertificate` 只要求一个正重数下界 \(m_*\)、统一余项界和 \(\varepsilon<4m_*\)。随后得到：

\[
\boxed{a\ne0\Longrightarrow Q_{\mathrm{full}}(a)<0,}
\]

且合成映射 \(S\) 单射。这给出一整个有限维、彼此独立的严格负完整 Weil 测试族。

### 6. 与现有单轨道 separator 的关系

仓库已有 `OffLineNonrealZeroNegativeWeilSquare` 使用 finite even interpolation、closed-strip Fourier–Laplace decay、convolution-power amplification 和 absolute zero summability，将一个指定离线轨道的负贡献压过其余零点尾项。

新多轨道链没有重复该单轨道构造。它抽取了多维推广所需的正确接口：

\[
\boxed{\text{统一余项的 operator-norm 型二次界}}
\]

而不是每个坐标单独的标量尾界。

下一解析节点应从已有 Burnol powering 与 closed-strip decay 中构造 `HasUniformMultiOrbitRemainderBound F epsilon`，并证明其 \(\varepsilon\) 可低于 \(4m_*\)。

### 7. 当前严格边界

本轮已经形式化：

1. scalar even Weil evaluation 的 multiplicity-fiber constancy；
2. functional-equation reflection evenness；
3. 对 ambient expanded space 和 unrestricted distinct-zero space 的显式非满射证书；
4. 有限实际卷积平方零点和的约化镜像因子分解；
5. 有限 orbit block 的 even-minus-odd 聚合；
6. sign-separated 多轨道约化奇读数的同时插值；
7. 显式有限线性 right inverse；
8. 可观察奇 Gram \( -4\operatorname{diag}(m_i) \)；
9. 其负指数等于独立可观察轨道数；
10. 统一二次余项小于最小负裕量时，整个有限维负子空间保持严格负定；
11. 对真实 `zeroSum` 的条件性多轨道负测试族。

本轮没有证明任意未经筛选的有限轨道集合自动满足 frame 的 sign-separation，也没有从 zeta 尾项具体构造 uniform multi-orbit remainder bound。它没有把 observer negative index 与完整 multiplicity-expanded ambient Krein index混同，也没有证明无限维负指数稳定、prime-side coercivity 或 RH。

### 8. 下一承重方向

下一条分析真源应为：

```text
MultiOrbitBurnolUniformRemainder
```

目标是从已有 closed-strip decay、convolution power 和绝对零点可和性，给有限 frame 构造共同 peak packet 与共同 exception killer，并证明：

\[
|R_N(a)|\le\varepsilon_N\|a\|_2^2,
\qquad
\varepsilon_N\to0.
\]

关键义务包括全部选定轨道上的目标读数同时保持、其余有限异常零点同时消去、远端零点统一几何衰减、交叉项按 Gram/operator norm 共同控制，以及常数随 frame 大小与最小节点分离显式记账。


---

## [PR #5065] UNIFORM_MULTI_ORBIT_BURNOL_REMAINDER

Candidate formalization, 2026-09-05. No successful Lean compilation or axiom audit is claimed by this source-write operation. The reviewed development baseline was `a2412c6c5cbfdcf38145b6386ac54a3cdc536408`; the existing candidate frame APIs were read at `fcfc744126d37ede7750dbecc4b840b5a8923bd7`. This increment stays on the existing draft PR, without merge or rebase.

### Correction and library-first reuse

Scalar even Weil tests remain constant on multiplicity copies and under functional-equation reflection. The result concerns independently observable four-point orbit channels. Multiplicity sets a weight and margin, not extra scalar rank.

The earlier basis constructor chose a witness after forgetting its full signed values. It is now selected from `exists_even_weil_frame_interpolant`. The public `frameOddBasisTest_target_values` and `frameOddSynthesis_target_values` retain the exact +a/-a values and hence zero target even channel.

Eight previously private helper declarations in the existing single-orbit Burnol owner are made public with unchanged proof bodies. These supply the reflection quotient, gamma injectivity, sign separation, actual zero summability, geometric-depth choice, and equality of the symmetric zero sum with its ordinary tsum. They are reused rather than independently redefined.

### Closed finite-frame chain

The four owners below construct a common peak, a common finite exceptional ball, simultaneous signed killers, an absolutely summable majorant for ALL mixed terms, and finally a single common power depth at which every nonzero coefficient vector gives a negative FULL Weil zero sum.

For E(a)=sum_i |a_i|^2, the actual target union contributes -4 sum_i m_i |a_i|^2. The actual complement satisfies

`|R_N(a)| <= (1/4)^(N+1) C_basis E(a)`.

C_basis is the sum of the absolute mixed-convolution majorants. Its finiteness is proved from existing zeta summability. It depends on the fixed finite basis, but not on a or N. The power factor tends to zero. Since each analytic multiplicity is at least one, one common finite N suffices for strict negativity on the whole nonzero coefficient space.

This constructs a jointly localized basis. It does not assert that the older arbitrarily chosen fixed synthesis already had the full remainder estimate.

### Source-level details

#### `FiniteReflectionCompatibleWeilInterpolation`

Status: Candidate source and author projection. Kernel and Scribe reconciliation remain separate checks.

For actual zero data Z, a finite set E of indices, and complex values a satisfying a(R j)=a(j), the module constructs a compact smooth even Weil test g with FT(g)(gamma_j)=a(j) for every j in E.

The construction reuses the reflection representative and frequency-injectivity lemmas from the existing single-orbit separator. It invokes `even_weilTestFunction_finite_interpolation` on the sign quotient. It does not reconstruct the Fourier-Laplace interpolation theorem.

The constant assignment gives a simultaneous unit peak on any finite union of zero orbits.

Main declarations:

- `even_weil_interpolation_on_finite_indices`
- `exists_even_weil_finite_unit_peak`

#### `FiniteOrbitBurnolPacket`

Status: Candidate source and author projection.

For a valid `FiniteEvenWeilOrbitFrame`, the module first proves that the actual four-point zero orbits are pairwise disjoint. It then constructs one peak b, a finite exceptional spectral ball E, and tests k_i satisfying:

1. FT(b)=1 at both selected conjugate spectral nodes of every channel.
2. FT(k_i)(gamma_j)=delta_ij and FT(k_i)(conj gamma_j)=-delta_ij.
3. Every k_i vanishes at all exceptional zero indices outside the target union.
4. Outside E, both conjugate evaluations of b have norm at most 1/2.

Existence follows from finite compatible interpolation and the existing closed-strip decay estimate. The simultaneous exceptional set is essential: multiplying separately chosen single-orbit packets would not automatically preserve the other target values.

Main declarations: `frame_orbits_pairwise_disjoint`, `exists_common_exceptional_ball`, `exists_orbitBurnolPacket`.

#### `FiniteMixedWeilMajorant`

Status: Candidate source and author projection.

For a finite basis k_i define the actual mixed terms

`M_ij(n) = zeroSummand Z (convolve (k_i) (involution (k_j))) n`.

Every M_ij is absolutely summable by the existing zeta summability theorem. The complete coefficient expansion is

`s_n(a) = sum_ij a_i conjugate(a_j) M_ij(n)`.

With `E(a)=sum_i |a_i|^2` and `B(n)=sum_ij |M_ij(n)|`, the module proves

`|s_n(a)| <= E(a) B(n)` and `sum_n |s_n(a)| <= E(a) C`, where `C=sum_n B(n)`.

B is proved summable. C depends on the fixed basis and includes every mixed term. It is not postulated as an operator-norm hypothesis.

Main declarations: `mixedWeilSummand_summable`, `zeroSummand_finite_synthesis_expansion`, `finiteMixedMajorant_summable`, `finite_synthesis_absolute_sum_le`.

#### `MultiOrbitBurnolUniformRemainder`

Status: Candidate source and author projection. No successful Lean compilation is claimed by this document.

The actual synthesized tests are

`f_N,a = sum_i a_i (b^{*(N+1)} * k_i)`.

Both target signs are preserved at every N. In particular the selected even channels vanish. The exact selected-orbit union contributes

`-4 sum_i m_i |a_i|^2`.

Writing the complete, absolutely convergent Weil zero sum as that contribution plus R_N(a), the module derives

`|R_N(a)| <= (1/4)^(N+1) C_basis sum_i |a_i|^2`.

The factor tends to zero independently of a. Positive integral analytic multiplicities give the target margin 4, so one finite common N makes the full form strictly negative on every nonzero coefficient vector. Reduced odd evaluation remains a right inverse, proving synthesis injective.

This closes the finite-frame remainder obligation that was previously an input to `QuantitativeMultiOrbitWeilNegativeCertificate`. It does not instantiate that older certificate for its arbitrary fixed basis; it constructs a new, jointly localized basis with proved estimates.

The valid frame is the only orbit assumption. Neither existence of off-line zeros nor a uniform estimate over all moving frames is asserted. Empty frames give the zero-dimensional case; a nonempty frame is required to extract an actual negative test.

Main declarations: `burnolSynthesis_target_union_value`, `multiOrbitBurnol_uniform_remainder`, `multiOrbitBurnol_error_tendsto_zero`, `exists_common_depth_strictly_negative`, `finite_multiOrbit_full_weil_negative_family`.

### Boundaries and next quantitative problems

A valid finite frame of nonreal off-line orbits is an input; existence of an off-line zero is never asserted. An empty frame is zero-dimensional. A nonempty frame is required for an actual negative test.

The constant and selected depth are classical and frame dependent. No computable estimate in minimum node separation, frame size, support radius, or height is established. Convolution depth may enlarge support. No uniform support window over all frames, infinite negative-index stability, prime-side coercivity, RH, or stronger zero-density theorem is claimed.

Next load-bearing goals are to package the actual full mixed Gram as a Hermitian matrix and identify its negative inertia with the realized test dimension, then derive explicit interpolation-conditioning and support-growth bounds and independently verifiable prime/Archimedean margins.


## [PR #5065] EXACT_OBSERVABLE_RANGE_AND_FULL_WEIL_GRAM_INERTIA

[PR #5065] Status: Candidate formalization. This section records the mathematical source increment, not an admission verdict. A source-write workflow, a targeted Lean replay, transitive axiom auditing and the repository required checks are different pieces of evidence. No merge or ready transition is authorized by this appendix.

### [PR #5065] Exact image of the original scalar even observer

[PR #5065] For a fixed ZeroData presentation Z and symmetric finite window T, write I_T for its distinct-zero indices and C_T for the dependent sum of the actual multiplicity copies. The original state space remains all WeilTestFunction values. The new owner `WeilEvaluationExactObservableRange` proves that an index vector v is a genuine Fourier-Laplace evaluation of an actual compact smooth even test if and only if v is invariant under the existing reflection permutation. The proof extends v by zero outside the window and reuses `even_weil_interpolation_on_finite_indices`. Symmetric-window closure proves that the extension remains compatible.

[PR #5065] At the expanded-coordinate level the exact characterization is: w is reachable if and only if w is constant on each multiplicity fiber and its collapsed index vector is reflection even. Every actual analytic multiplicity is positive, so collapse can read its zeroth genuine copy. Expansion and collapse are inverse on the fiber-constant subspace. The previously defined `finiteWeilReducedEvaluation` is consequently surjective onto its specified reduced codomain. These statements supply the converse missing from the earlier necessary-constraint package.

### [PR #5065] Intrinsic-information interpretation on the unchanged arena

[PR #5065] The same new owner proves, for arbitrary original test states g and h, that equality of multiplicity-expanded readouts is equivalent to equality of distinct-zero readouts. Adding the expanded readout as a joint observer also leaves the kernel unchanged. Therefore no pair of original states can witness strict fiber separation by multiplicity replication. This is a semantic zero-gain theorem. Multiplicity still changes the quadratic weight and negative margin, while repeated copies contribute no additional scalar information.

[PR #5065] This interpretation follows `docs/develop/spec/lean_single_compile_intrinsic_information_escape_theory_and_spec.md`: no truth-conditioned State subtype, certificate label or compilation status is used as an observable. The arena is infinite and complex-valued, so this increment does not apply finite pair-count probabilities to it, invent a normalized measure, or claim a new PrimLawSpec/admission. The observable subtype is a codomain characterization, never a restricted state arena. Host-side source delivery and diagnostics supply no Lean theorem assumptions.

### [PR #5065] Mixed finite factorization on the exact range

[PR #5065] `truncatedZeroSum_mixed_eq_reducedMirrorForm` extends the earlier convolution-square identity to arbitrary actual tests g and h. The finite zero sum of convolve(g, involution(h)) is exactly the existing mirror sesquilinear form evaluated on their reduced readouts. This identifies all off-diagonal finite Gram entries and preserves one analytic multiplicity weight per distinct zero. It reuses the existing mirror permutation and form instead of rebuilding them.

### [PR #5065] The actual complete Gram matrix

[PR #5065] The new owner `WeilFullGramInertia` defines W(g,h) as the complete absolutely convergent sum of the actual mixed summands, and sets G_ij = W(b_j,b_i). The index order gives the standard conjugate-linear row convention. Mirror reindexing preserves multiplicity and conjugates the spectral parameter, proving conjugate(W(g,h)) = W(h,g), hence G is Hermitian. Mixed absolute summability permits both finite coefficient sums to commute with the complete zero sum. The resulting exact identity is

```math
a^*G a = Z\!\left(\left(\sum_i a_i b_i\right)*
  \left(\sum_i a_i b_i\right)^*\right).
```

[PR #5065] Here Z denotes the actual full Weil zero functional, not a finite target-only replacement. Every infinite-tail cross term remains in G. In particular this appendix does not assert that the full Gram equals the finite target diagonal -4 diag(m_i).

### [PR #5065] Exact spectral inertia of the realized family

[PR #5065] The existing `finite_multiOrbit_full_weil_negative_family` constructs an injective finite linear synthesis whose complete Weil square has strictly negative real part on every nonzero complex coefficient vector. The new Gram identity transports this result to Matrix.PosDef(-G). Hermitian reality justifies passing from the real-part inequality to the complex star order. The existing RHLinalg negative-index implementation and the standard positive-definite eigenvalue theorem then give

```math
\boxed{\operatorname{negIndex}(G)=\#\{\text{independent observable orbit channels}\}.}
```

[PR #5065] The final declaration is `exists_actual_full_weil_gram_with_exact_negative_index`. Its matrix is built from actual tests and the complete zero sum. No assumed uniform remainder remains beyond the already constructed common Burnol packet. The theorem retains a valid finite separated nonreal off-line orbit frame as input; it does not assert existence of an off-line zero. Empty frames give dimension zero. It does not equate this observable index with the multiplicity-expanded ambient index, prove RH or prime-side coercivity, or supply computable support and conditioning bounds uniform over moving frames.

### [PR #5065] Source interfaces and next quantitative obligation

[PR #5065] Both owners have Scribe sources, author Markdown projections and explicit #print axioms requests for their main declarations. The full-Gram module imports the exact-range owner and the existing common Burnol owner, so it is a single dependency-closure replay root for this increment. Matrix interfaces were checked against the repository-pinned Mathlib v4.33.0 source, including `Matrix.PosDef.of_dotProduct_mulVec_pos`, `Matrix.IsHermitian.im_star_dotProduct_mulVec_self` and `Complex.pos_iff`. The eigenvalue-to-index step reuses the repository pattern in `FiniteMirrorKreinGramInertia`. Provenance of the integration is repo-derived; no independent novelty claim for classical interpolation or spectral inertia is made.

[PR #5065] The next quantitative work is to bound interpolation conditioning and convolution support growth for specified frames, then transport an explicit remaining negative margin through the prime/Archimedean explicit-formula interface. A finite full negative-index realization alone supplies no prime-side positive coercivity and no contradiction to a hypothesized off-line frame.


## [PR #5065] FINITE_OBSERVABLE_TO_FULL_FORM_LIMIT_AND_REPLAY_CORRECTIONS

[PR #5065] The full-Gram owner now includes `reducedMirrorForm_tendsto_fullMixedWeilForm`: for each actual pair of Weil tests, the multiplicity-weighted reduced mirror forms on growing symmetric windows converge to the actual complete mixed Weil form. The proof uses `truncatedZeroSum_tendsto` from the existing ZeroSum owner and the exact mixed factorization. This is a genuine finite-to-full mathematical dependency on the exact observable range layer.

[PR #5065] Pinned root observations 33969082693 and 33969495413 both failed. The first exposed obsolete finite-sum syntax and an unclosed mirror inverse simplification. The second verified the repaired mirror inverse with only standard axioms, then exposed a finite-window unfolding mismatch and a accidentally omitted second ZeroData binder introduced during the source repair. This revision explicitly unfolds `ZeroConfig.window` and restores that binder, without changing the intended theorem statements or admitting a placeholder. Compiler error recovery containing `sorryAx` is rejected as validation evidence. The new frozen source revision still requires its own observed successful root replay and independent required checks before any admission claim.


---

## RH_EQUIVALENCE_ATLAS_20260908

### RH 等价形式图谱：规范对象、跨领域证明与形式化路线

资料核查日期：2026-09-08。项目：`the-omega-institute/trureturing`。

本节在现有 RH 理论卷中建立一个可逐项实现的等价判据图谱。第一版包含 **18 个判据族、64 个规格节点**：A001 是标准 RH，另外 63 个是经典判据或有用的派生表达。这些节点共享若干重大解析定理，不能解释成 63 项彼此独立的新发现，也不声称穷尽文献中一切重参数化的 RH 表述。后续新增判据进入相应判据族，并保留其原始对象、量词和证明来源。

数学目标是同时获得两种成果：对每个具体命题证明 `RiemannHypothesis ↔ P`；对不同领域之间的转换，进一步构造实际函数、矩阵、测度、残差和失败见证。后者使图谱能够承担新的定量研究。

本节给出文献中的数学定理、项目现状、若干完整纸面推导和待实现的接口。**本次增补没有新增 Lean 证明，也没有执行 Lean 编译或核验传递公理闭包。** 表中的“经典”指数学文献中的等价定理，“派生”指从注明的桥梁得到的数学表达；两者都不自动表示对应 Lean 端点已经完成。

### 1. 当前 dev 与所有开放 PR 的接入位置

主要数学源读取固定在 dev `aee1eaff34f997e44f04147cee1010bb482c4c1b`。提交前再次捕获 dev `3a8854105ef7bc1a480c4473cdc50b16d6993146`，树为 `717a3fee18b949f40ce178b595cb7d109fb24981`；本卷 blob 仍为 `1e9316d22d780b370a70aa340009ab0a5604819d`，原文未变。下表的开放 PR head 已再次刷新；这些快照日期不表示执行了全库编译。下列路径均相对仓库根目录；固定版本可用 `https://github.com/the-omega-institute/trureturing/blob/<commit>/<path>` 读取。

#### 1.1 应复用的数学真源

| 现有真源 | 本次读到的数学内容 | 图谱中的使用方式 |
| --- | --- | --- |
| `D5/S3/Weil/ZeroData/UnconditionalCanonicalZeroData.lean` | 无外部解析参数的 `zetaZeroData`，实际非平凡零点的穷尽性、唯一索引、正解析重数、反射与共轭；blob `a5ef2be4da1c3a6cf361b911d447bacc22be622f` | 所有零点判据共用这一实际对象。旧文档中“尚无 ZeroData 实例”的说法不再适用。 |
| `D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.lean` | 从 `xiReading` 导数定义的 Li 系数、全部阶数的 Taylor 系数恒等式、局部生成展开及第一系数正性；blob `0fb04eb79f87389016b51af25cdf6078d5616b7c` | 不另定义替代 Li 序列。局部展开与全单位圆盘展开分开登记。 |
| `D5/S3/Weil/Separator/ExplicitFormulaWeilCriterion.lean` | 实际零点和与 pole-minus-prime-plus-Archimedean 表达的运输；签名仍有每个卷积平方的 Archimedean 收敛输入 | 固定 canonical ZeroData 后，继续从相应解析真源构造收敛证明。不要删除该输入而不提供证明。 |
| `D5/S3/Weil/TestFunctions/LiCurvatureCriterion.lean` | 有限 Toeplitz Gram 恒等式、几何多项式能量、二阶差分重建；blob `b509cde8c62c3ed60756cfc9264b98cf357102d2` | 主等价定理目前仍接收 Li 判据、RH 下 Fourier 表示和无限 Herglotz 表示。第 6 节给出更短的反向证明。 |
| `D5/S3/Observer/Hilbert/NymanBeurlingFiniteGramDistance.lean` | 实际复数半直线 L² 载体、分数部分向量、目标指示函数、有限 Gram 与伪逆距离公式；blob `0bec9ac0ed53094607b7e34a7555aac7a3ebd6c8` | 在真实算术函数上完成 Nyman–Beurling 解析桥，直接消费已有有限距离。 |
| `D5/S3/Observer/Hilbert/NymanBeurlingTargetQuotientCriterion.lean` | 闭包成员、商类为零、正交残差为零和有限距离趋零的 Hilbert 等价；blob `a9518c6af492f2cae3dd8d4df58eeb7920a71581` | 当前 RH 连接仍作为 `nymanBeurling` 参数传入；它是待补的解析边。 |
| `D5/S3/Zeros/Jensen/JensenPolynomialObstruction.lean` | Jensen 多项式定义与有限失败见证的逻辑；blob `cb40a8e7c32caa84b36e1d86730fc2d45e903157` | 当前两个 Jensen–Pólya 桥仍是参数，且 RH 参数可为任意命题。最终端点必须使用实际 ξ 系数与标准 RH。 |
| `D5/S3/Constants/NewtonHankelRealRootCriterion.lean` | 共轭稳定有限根族的实根性与 Newton–Hankel 半正定双向证明；blob `1b30a277e90ec2fdca2e10712bdc543c37acc195` | 复用其插值负方向；为实际 Jensen 多项式构造根枚举或 companion-trace 适配器。 |

本卷已有 #5065 的共同 Burnol packet、多轨道完整 Weil 负子空间、实际 Gram 负指数和有限观察形式到完整混合形式的极限。图谱承接这些成果。新的任务是显式的支撑增长、插值条件数和误差运输，不能把已经写出的共同余项构造重新列为完全空白。

当前 `JensenPolynomialObstruction.PolynomialHyperbolic` 的实际定义要求每个复根为实，因此零多项式不满足它。注释中“包含零多项式”应在后续源维护中修正。本节使用严格正的规范系数，保证需要的 Jensen 多项式非零；次数零的正常数另行处理。

#### 1.2 开放 PR 全量筛选及相关源读取

本次使用无作者过滤的开放 PR 集合，第一页容量 100，第二页返回空集，得到以下 **14 个开放 PR**。全部读取了元数据和正文，并对与图谱直接有关的选定真源作进一步读取；这不是对所有历史 PR、所有文件或所有证明的完整重编译。已经合入的其他作者成果通过当前 dev 接入。表中记录实际 head，避免把正文中的旧 head 当成当前版本。

| PR | 捕获的实际 head | 与本图谱的关系 |
| --- | --- | --- |
| [#5236](https://github.com/the-omega-institute/trureturing/pull/5236) | `f65251d3d85ad5fe7f1e254291e3e56bc3b0ec1a` | PrimeGaps186。正文保留实际积分义务；不能用有限算术检查代替解析定理，不作为 RH 等价边。 |
| [#5284](https://github.com/the-omega-institute/trureturing/pull/5284) | `9adf54557f6ce3aecac3ae09c567e38379e8ca00` | 黄金自动机的有限样本运输。没有加入 RH 数学依赖。 |
| [#5405](https://github.com/the-omega-institute/trureturing/pull/5405) | `aaee9b75616627192369518e786fde83c06e4dc0` | 黄金四次幂状态下界。有限前缀与全指标结论的区别适用于本图谱，具体定理不构成 RH 判据。 |
| [#5602](https://github.com/the-omega-institute/trureturing/pull/5602) | `7d01130cfc3ce2d7c3d0c4d99a44843ce70c636f` | 实际 Weil/prolate 模型、完整余项与尺度运输。读取最新 `WeilGroundModeShiftBarrier.lean`，blob `2ab192cdf8db9f892a69606367b3bb986f34b846`；支撑边界及完整形式必须保留。 |
| [#5895](https://github.com/the-omega-institute/trureturing/pull/5895) | `023e6d1eccb223a563939590d301085a220b38f2` | 偶不变子空间的全尾界与归一化读数。偶扇区阈值不能自动替换全空间阈值。 |
| [#5897](https://github.com/the-omega-institute/trureturing/pull/5897) | `b6653823add96ea81c6f3c8cec3dd3db47029cd6` | 方格 hard-core 零点自由区域；未把其图递归定理转称 RH 定理。 |
| [#6029](https://github.com/the-omega-institute/trureturing/pull/6029) | `7e1a8c9b33d28d778d80392da5bb06bdcc966f7f` | 实际相对 Gamma 对角线的正项级数、完整尾界和频率一致窗口修正；对角线正性不足以控制混合项。 |
| [#6033](https://github.com/the-omega-institute/trureturing/pull/6033) | `d54250a5bd1ae4764dc15d876926e8a28b2a2881` | 因果耦合与最优界。没有加入 RH 数学依赖。 |
| [#6038](https://github.com/the-omega-institute/trureturing/pull/6038) | `608ebf0929b708832c268e9a5954f58bfb36574a` | 临时 MUB 文本拼接分支，不登记为数学结果。 |
| [#6114](https://github.com/the-omega-institute/trureturing/pull/6114) | `a65f9130d7f17c3bd6dcf7e450d1d53588ab92d2` | Li 曲率到 Herglotz、负型、Schoenberg 和实际圆周概率半群；读取 `LiCurvatureSchoenbergSemigroup.lean`，blob `d616bc1fc8a8f6176883f942809900136f92d577`。 |
| [#6143](https://github.com/the-omega-institute/trureturing/pull/6143) | `7abe3cf91cbf071d025c4dedef773e69dfbc6602` | MUB 区间证书与覆盖。没有加入 RH 数学依赖。 |
| [#6219](https://github.com/the-omega-institute/trureturing/pull/6219) | `8e3982e87642ba3987239f2a4623e6d7ef4b8e55` | 规范 Li 圆盘等价与零点半径增长障碍；读取 `CanonicalLiDiskEquivalence.lean`，blob `251c989b6312a577d24e87950a267cdefcdaae3f`。 |
| [#6221](https://github.com/the-omega-institute/trureturing/pull/6221) | `b1e737aa90c6a3d0f08e39fe481092b68a0d128a` | Scribe 的真实声明标识输出；有助于定位证明，不充当数学前提。 |
| [#6254](https://github.com/the-omega-institute/trureturing/pull/6254) | `34a2c0fe82403b5028456d02b99f9b2d3b11e320` | 临时 prolate 理论拼接分支，不重复计为独立成果。 |

#6114、#6219 及相关新谱源保留其候选、未执行编译的状态。#6219 已经使用规范导数系数，通过解析方程 `F'=GF` 的延拓与零点阶数排除，给出全圆盘判据的候选双向证明。它没有借用一个作为参数传入的 Li 判据。这是应保留的实质性进展。

### 2. 共同对象与变换约定

#### 2.1 ξ、Ξ、实际零点与 Möbius 圆盘

采用经典归一化

\[
\xi(s)=\frac12s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s),
\qquad \xi(0)=\xi(1)=\frac12,
\qquad \Xi(z)=\xi\!\left(\frac12+iz\right).
\]

在 Lean 中消费现有 `xiReading` 与其端点、整性、函数方程、共轭性质。记 \(\mathcal Z\) 为实际非平凡零点集合，\(m_\rho\) 为解析重数；枚举变化不改变带重数的规范和。

定义

\[
w_\rho=1-\rho^{-1},\qquad
D=\{z\in\mathbb C:|z|<1\},\qquad
F(z)=\xi((1-z)^{-1}),
\]

\[
G(z)=(1-z)^{-2}\frac{\xi'}{\xi}((1-z)^{-1}).
\]

\(G\) 的解析性是需要证明的性质，定义它时不能预先要求整个圆盘零点自由。Lean 对除法的全函数约定也不能把分母零点变成解析延拓证明。

直接代数给出

\[
|w_\rho|^2-1=\frac{1-2\Re\rho}{|\rho|^2},\qquad
w_{1-\rho}=w_\rho^{-1},\qquad
w_{\bar\rho}=\overline{w_\rho}.
\tag{E1}
\]

故临界线对应单位圆，右半临界带的零点对应圆盘内部。若使用 Suzuki 的谱坐标，本节固定 \(\gamma_\rho=i(\rho-\tfrac12)\)，即 \(\xi(\tfrac12-i\gamma_\rho)=0\)。它与惯用正虚部 ordinate 的符号差异必须通过现有坐标适配器处理。[L02, L03]

#### 2.2 规范 Li 系数、曲率及正定性的量词

\[
\lambda_0=0,\qquad
\lambda_n=\frac1{(n-1)!}
\left.\frac{d^n}{ds^n}\bigl(s^{n-1}\log\xi(s)\bigr)\right|_{s=1}
\quad(n\ge1).
\]

局部对数由 \(\xi(1)=1/2\) 选定，所得系数为实数。复用现有第一系数

\[
L=\lambda_1=1+\frac{\gamma_{\!E}}2-\log(2\sqrt\pi)>0.
\]

其中 \(\gamma_E\) 专指 Euler–Mascheroni 常数。定义规范实偶曲率

\[
c_0=1,\qquad
c_k=\frac{\lambda_{|k|+1}-2\lambda_{|k|}+\lambda_{|k|-1}}{2L}
\quad(k\ne0),\qquad \psi(k)=\lambda_{|k|}.
\]

\(T^{(n)}=(c_{j-k})_{0\le j,k<n}\)。仓库 `toeplitzMatrix c N` 的大小为 \(N+1\)，因此 \(n\ge1\) 时它对应参数 \(N=n-1\)。圆周 Fourier 约定沿用

\[
\widehat\sigma(k)=\int_{\mathbb T}z^{-k}\,d\sigma(z).
\]

正定函数 \(h\) 表示：任意有限索引组 \(x_i\) 和任意复系数 \(a_i\) 都满足
\(\sum_{i,j}\overline{a_i}a_jh(x_i-x_j)\ge0\)。条件负定的量词相同，但要求 \(\sum_i a_i=0\)，不等式反向。所有概率测度均为正测度且总质量为一。[L02–L04]

#### 2.3 Jensen 的正偶阶系数

定义

\[
a_n=\frac{n!}{(2n)!}\xi^{(2n)}\!\left(\frac12\right)>0,
\qquad
\xi\!\left(\frac12+z\right)=\sum_{n\ge0}\frac{a_n}{n!}z^{2n}.
\]

严格正性由实际 theta 积分的偶矩给出，应独立形式化。用级数定义整函数
\(\Psi(u)=\sum_{n\ge0}a_nu^n/n!\)，避免依赖平方根分支；有 \(\Psi(-z^2)=\Xi(z)\)。定义

\[
J_{d,m}(X)=\sum_{j=0}^d\binom dj a_{m+j}X^j.
\]

[L05] 的系数归一化为 \(\gamma_n=8a_n\)。这个共同正因子不改变多项式根，但必须先证明与本项目导数定义一致。不能直接拿 \(\Xi\) 的交错 Taylor 系数，或包含恒零奇阶项的序列，替代这里的 \(a_n\)。

#### 2.4 Nyman–Beurling 的两个真实载体

在 \(L^2(0,1)\) 中，令 \(B_0\) 为所有有限复线性组合

\[
\sum_{j=1}^r u_j\{\theta_j/x\},\qquad
0<\theta_j\le1,\qquad \sum_j u_j\theta_j=0.
\]

在 \(H=L^2((0,\infty),dx;\mathbb C)\) 中，定义

\[
\chi=\mathbf1_{(0,1)},\quad v_a(x)=\{1/(ax)\}\ (a\ge1),\quad
S_N=\operatorname{span}\{v_1,\ldots,v_N\},\quad d_N=\operatorname{dist}(\chi,S_N).
\]

\(G_N\) 和 \(b_N\) 分别是这些实际向量的 Gram 矩阵与目标内积列，\(G_N^\dagger\) 是 Moore–Penrose 伪逆。已有真源给出

\[
d_N^2=1-b_N^*G_N^\dagger b_N.
\tag{E2}
\]

Gram 矩阵的半正定性在这里无条件成立；RH 所要求的是完整逼近残差趋零。[L07]

#### 2.5 Weil 的完整形式与有限窗口算子

令 \(Q_W\) 为现有显式公式对应的完整 Weil 二次型，测试函数取复值 \(C_c^\infty(\mathbb R)\)。在与谱坐标匹配的 Fourier 约定下，它的零点侧为

\[
Q_W(f)=\Re\sum_{\rho\in\mathcal Z}m_\rho\,
\widehat f(\gamma_\rho)\overline{\widehat f(\overline{\gamma_\rho})}.
\]

测试函数的固定带衰减、零点计数与绝对可和性需来自真实解析真源。混合形式由同一对象极化；不能把交叉项改成逐零点的模平方。

在窗口 \((-a,a)\) 上，令

\[
\ell(a)=\inf_{0\ne f\in C_c^\infty(-a,a)}\frac{Q_W(f)}{\|f\|_2^2}.
\]

\(A_a\) 专指该实际下半有界形式的 Friedrichs 实现。使用谱判据前，必须构造闭形式、证明核心与算子对应，不能从任意自伴算子出发重新命名。仓库的偶测试函数版本、`Zeta23.EF.weilTest` 的非受限版本和 [L01] 的形式之间分别需要精确适配。记 \(E(g)\) 为现有 `poleTerm - primeTerm + archimedeanTerm` 在实际卷积平方上的实部。[L01, L03]

### 3. 64 个规格节点及其数学等价关系

标签：**R** 为标准根命题，**C** 为文献中的经典判据，**D** 为由本节指明桥梁得到的派生表达。每行都是未来具体端点的目标陈述；实现进度由第 1、10 节的真源与解析义务决定。

所有大 O 都在趋于无穷时使用，\(O_\varepsilon\) 明确表示
\(\forall\varepsilon>0\;\exists C_\varepsilon,X_\varepsilon\;\forall x\ge X_\varepsilon\)，常数允许依赖 \(\varepsilon\)。复数表达的非负性按实 Hermitian 二次型解释。

#### F01. 零点几何与圆盘（A001–A005）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A001 | R | 每个实际非平凡零点 \(\rho\) 满足 \(\Re\rho=1/2\)，使用 Mathlib 的标准 `RiemannHypothesis`。 |
| A002 | D | \(\Xi\) 的每个复零点均为实数。 |
| A003 | D | \(\xi(s)\ne0\) 对全部 \(\Re s>1/2\) 成立。 |
| A004 | D | 对每个实际非平凡零点，\(\vert 1-1/\rho\vert =1\)。 |
| A005 | D | \(F(z)\ne0\) 对全部 \(z\in D\) 成立。 |

依赖：端点填值、真实零点对应、函数方程与 (E1)。A003 的反向使用反射；省略反射只能排除半边零点。

#### F02. Li 系数与解析半径（A006–A013）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A006 | C | \(\lambda_n\ge0\) 对所有整数 \(n\ge1\)。 |
| A007 | D | \(\lambda_n>0\) 对所有整数 \(n\ge1\)。 |
| A008 | D | 实际 \(G\) 在整个 \(D\) 上解析。 |
| A009 | D | 对每个 \(z\in D\)，\(\sum_{n\ge0}\lambda_{n+1}z^n\) 收敛且和为实际 \(G(z)\)。 |
| A010 | D | 对每个 \(0\le r<1\)，\(\sum_{n\ge0}\vert \lambda_{n+1}\vert r^n<\infty\)。 |
| A011 | D | 对每个 \(0<R<1\)，存在 \(C_R\ge0\)，使所有 \(n\ge0\) 满足 \(\vert \lambda_{n+1}\vert R^n\le C_R\)。 |
| A012 | D | \(\limsup_{n\to\infty}\vert \lambda_{n+1}\vert ^{1/n}\le1\)，根指数从 \(n\ge1\) 起。 |
| A013 | D | 对全部 \(n\ge0\)，\(\vert \lambda_n\vert \le L n^2\)。 |

A006 用 Li 定理 [L02, L03]。A007 的严格性由 RH 下正零点贡献和无穷零点得到，\(n=0\) 不包含在严格式中。A008–A012 使用实际 Taylor 恒等式、Cauchy–Hadamard 与 `F'=GF` 的零点阶数论证；A013 的正向见第 6 节，反向通过 A010。#6219 已有其中若干候选端点，不应平行重写。

#### F03. 圆周测度、负型与概率演化（A014–A020）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A014 | D | 规范 \(c\) 的所有 \(T^{(n)}\) 半正定，\(n\ge1\)。 |
| A015 | D | 存在圆周概率测度 \(\sigma\)，使 \(\widehat\sigma(k)=c_k\) 对所有 \(k\in\mathbb Z\)。 |
| A016 | D | 存在圆周概率测度 \(\sigma\)，使 \(\lambda_n=L\int\vert \sum_{j<n}z^j\vert ^2d\sigma\) 对所有 \(n\ge0\)。 |
| A017 | D | 实际 \(\psi(k)=\lambda_{\vert k\vert }\) 在 \(\mathbb Z\) 上条件负定。 |
| A018 | D | 对每个实数 \(t\ge0\)，\(k\mapsto e^{-t\psi(k)}\) 在 \(\mathbb Z\) 上正定。 |
| A019 | D | 存在弱连续圆周概率卷积半群 \((\rho_t)_{t\ge0}\)，\(\rho_0=\delta_1\)，且全部 Fourier 系数为 \(e^{-t\psi(k)}\)。 |
| A020 | D | 存在实 Hilbert 空间、\(\mathbb Z\) 的正交表示 \(U\) 和 cocycle \(b(n+m)=b(n)+U(n)b(m)\)，满足 \(\Vert b(n)\Vert ^2=\psi(n)\)。 |

这里同时需要 Herglotz、Schoenberg 与 cocycle 表示的实际构造。A016 到 A015 可先将测度与共轭推前平均，以获得实偶 Fourier 矩，再应用二阶差分唯一性。A020 不能削弱成任意有指定范数的向量族。#6114 已提供通用构造的候选源；真正的 RH 连接仍要识别规范算术曲率。[L02–L04；第 6 节]

#### F04. Weil 正性、矩阵与实际窗口谱（A021–A026）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A021 | C | \(Q_W(f)\ge0\) 对每个复值 \(f\in C_c^\infty(\mathbb R)\)。 |
| A022 | D | 在现有偶 `WeilTestFunction` 载体上，固定 `zetaZeroData` 的每个完整卷积平方零点和的实部非负。 |
| A023 | D | 每个相同测试函数上的实际 \(E(g)\ge0\)，收敛项与显式公式齐备。 |
| A024 | D | 任意有限实际测试函数组的完整混合 Weil Gram 矩阵半正定。 |
| A025 | D | 对每个 \(a>0\)，\(\ell(a)\ge0\)。 |
| A026 | D | 对每个 \(a>0\)，实际 \(A_a\) 的谱包含于 \([0,\infty)\)。 |

A021–A024 需要两个测试函数载体的完整适配和现有 separator。A025 使用所有支撑窗口的穷尽；A026 使用闭形式与谱定理。有限截断矩阵的正性只有在全尾控制和核心证明完成后才能进入这些端点。[L01, L03]

#### F05. 整函数、Jensen 与 Newton–Hankel（A027–A032）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A027 | C | \(\Xi\) 属于 Laguerre–Pólya 类。 |
| A028 | D | 存在非零、仅有实根的实多项式序列，在每个复紧集上一致收敛到 \(\Xi\)。 |
| A029 | C | 每个 \(J_{d,0}\) 仅有实根，\(d\ge0\)。 |
| A030 | C | 每个 \(J_{d,m}\) 仅有实根，\(d,m\ge0\)。 |
| A031 | D | 对每个 \(d\ge1,m\ge0\)，实际反转多项式 \(x^dJ_{d,m}(-1/x)\) 的带重数根所构成的 Newton–Hankel 矩阵半正定。 |
| A032 | D | A031 中每一个有限矩阵的所有主子式均非负。 |

这里使用 \(\Psi(-z^2)=\Xi(z)\)、正系数和 Jensen–Pólya 定理，再消费现有有限根定理。[L05, L06] 的“固定次数、充分大 shift”结果只覆盖量词的一部分，不能取代 A030。

#### F06. Nyman–Beurling 与最佳逼近（A033–A040）

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A033 | C | \(B_0\) 在 \(L^2(0,1)\) 中稠密。 |
| A034 | C | 常数函数 \(1\) 属于 \(\overline{B_0}\)。 |
| A035 | C | \(\chi\in\overline{\operatorname{span}\{v_a:a\in\mathbb R,a\ge1\}}\subset H\)。 |
| A036 | C | \(\chi\in\overline{\operatorname{span}\{v_n:n\in\mathbb N,n\ge1\}}\subset H\)。 |
| A037 | D | \(d_N\to0\)。 |
| A038 | D | \(b_N^*G_N^\dagger b_N\to1\)，按其已证明的实值理解。 |
| A039 | D | 每个 \(h\in H\) 若与全部整数 \(v_n\) 正交，则与 \(\chi\) 正交。 |
| A040 | D | \(\chi\) 在 \(H/\overline{\operatorname{span}\{v_n:n\ge1\}}\) 中的商类为零。 |

A036 的整数限制是 Báez-Duarte 的强化定理 [L07]，不能仅靠 Hilbert 抽象几何推出。A037–A040 的几何大部分已有真源。第 7 节给出实际离线零点在两个原始载体中的连续分离泛函。

#### F07. Möbius 抵消与素数分布误差（A041–A044）

记 \(M(x)=\sum_{n\le x}\mu(n)\)，\(\psi_{\rm vM}(x)=\sum_{n\le x}\Lambda(n)\)，\(\vartheta(x)=\sum_{p\le x}\log p\)，\(\operatorname{li}_2(x)=\int_2^xdt/\log t\)，\(x\ge2\)。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A041 | C | 对每个 \(\varepsilon>0\)，\(M(x)=O_\varepsilon(x^{1/2+\varepsilon})\)。 |
| A042 | C | \(\psi_{\rm vM}(x)-x=O(x^{1/2}\log^2x)\)。 |
| A043 | D | \(\vartheta(x)-x=O(x^{1/2}\log^2x)\)。 |
| A044 | C | \(\pi(x)-\operatorname{li}_2(x)=O(x^{1/2}\log x)\)。 |

依赖实际 Dirichlet 级数、Perron/显式公式、部分求和及 prime-power 余项。[L08]。无条件已有 Mertens 或 Gronwall 极限不能取代这里的 RH 级误差。

#### F08. Robin、Lagarias 与 Nicolas 的整数不等式（A045–A047）

记 \(\sigma(n)=\sum_{d\mid n}d\)，\(H_n=\sum_{j=1}^n1/j\)，\(P_k\) 为前 \(k\) 个素数的乘积，\(\varphi\) 为 Euler 函数。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A045 | C | 对每个整数 \(n\ge5041\)，\(\sigma(n)<e^{\gamma_E}n\log\log n\)。 |
| A046 | C | 对每个整数 \(n\ge1\)，\(\sigma(n)\le H_n+e^{H_n}\log H_n\)。 |
| A047 | C | 对每个整数 \(k\ge1\)，\(P_k/\varphi(P_k)>e^{\gamma_E}\log\log P_k\)。 |

A045 的阈值与严格号、A046 的 \(n=1\) 等号以及 A047 的 primorial 输入必须保留。[L09, L10]。项目已有 Robin 单元证书、素指数重排和 Gronwall 上下包络可复用；它们不自动提供以上全称等价定理。

#### F09. Riesz 与离散 Báez-Duarte 变换（A048–A049）

定义

\[
R(x)=x\sum_{j\ge0}\frac{(-1)^jx^j}{j!\zeta(2j+2)},\qquad
b_k=\sum_{j=0}^k(-1)^j\binom kj\frac1{\zeta(2j+2)}.
\]

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A048 | C | 对每个 \(\varepsilon>0\)，\(R(x)=O_\varepsilon(x^{1/4+\varepsilon})\)，\(x\to+\infty\)。 |
| A049 | C | 对每个 \(\varepsilon>0\)，\(b_k=O_\varepsilon(k^{-3/4+\varepsilon})\)，整数 \(k\to\infty\)。 |

这里 \(b_k\) 与 Li 曲率 \(c_k\) 是不同对象。不得把 \(\varepsilon=0\) 的更强界当作等价式。[L11]。第 8 节给出精确变换与误差义务。

#### F10. 导数零点（A050）

**A050，C，Speiser：** \(\zeta'(s)\) 在 \(0<\Re s<1/2\) 内没有零点。对象是实际解析导数；开带边界、平凡导数零点和极点需分别处理。[L12]

#### F11. Balazard–Saias–Yor 对数积分（A051）

**A051，C：**

\[
I_{\rm BSY}=\int_{\mathbb R}\frac{\log|\zeta(1/2+it)|}{1/4+t^2}\,dt=0.
\]

必须证明对数奇点与无穷尾的积分意义；孤立零点处的取值只能按已证明的几乎处处等价处理。[L13]。截断积分趋零是该积分结论的一个实现方式，有限截断的小值不构成等价定理。

#### F12. Farey 分数的偏差（A052–A053）

Farey 阶数为整数 \(N\)，列出分母不超过 \(N\) 的既约分数 \(0<r_1<\cdots<r_{m_N}=1\)，其中 \(m_N=\sum_{q=1}^N\varphi(q)\)。令 \(\delta_j=r_j-j/m_N\)。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A052 | C | 对每个 \(\varepsilon>0\)，\(\sum_{j=1}^{m_N}\delta_j^2=O_\varepsilon(N^{-1+\varepsilon})\)。 |
| A053 | C | 对每个 \(\varepsilon>0\)，\(\sum_{j=1}^{m_N}\vert \delta_j\vert =O_\varepsilon(N^{1/2+\varepsilon})\)。 |

规模变量为分母上界 \(N\)，不是项数 \(m_N\)。[L14] 的引言准确重述 Franel–Landau 判据；其新的同余类、k-free 分母问题含有更强 L-function/GRH 范围，不能自动纳入普通 RH。

#### F13. Redheffer 算术矩阵（A054）

令 \(A_N\) 的行列为 \(1,\ldots,N\)，当 \(j=1\) 或 \(i\mid j\) 时元素为一，其余为零。

**A054，C：** 对每个 \(\varepsilon>0\)，\(\vert \det A_N\vert =O_\varepsilon(N^{1/2+\varepsilon})\)。精确桥为 \(\det A_N=M(N)\)，见第 8 节。[L15, L16]

#### F14. de Bruijn–Newman 热形变（A055–A056）

定义

\[
\Phi(u)=\sum_{n\ge1}(2\pi^2n^4e^{9u}-3\pi n^2e^{5u})e^{-\pi n^2e^{4u}},
\qquad
H_t(z)=\int_0^\infty e^{tu^2}\Phi(u)\cos(zu)\,du.
\]

该约定满足 \(H_0(z)=\xi(1/2+iz/2)/8\)。令 \(\Lambda_{\rm dBN}\) 为“\(H_t\) 全部零点实当且仅当 \(t\ge\Lambda_{\rm dBN}\)”的实阈值。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A055 | C | \(\Lambda_{\rm dBN}\le0\)。 |
| A056 | D | \(\Lambda_{\rm dBN}=0\)。 |

A056 还消费 Rodgers–Tao 的无条件 \(\Lambda_{\rm dBN}\ge0\) 深定理。[L17]。阈值存在性、热积分与 ξ 的尺度恒等式和这条下界都要独立形式化。

#### F15. 全正函数与双边 Laplace 变换（A057–A058）

\(PF_\infty(k)\) 表示 \(k\) 是非零可积实函数，且对所有严格递增实数列 \(x_1<\cdots<x_r\)、\(y_1<\cdots<y_r\)，所有阶数 \(r\ge1\) 都有 \(\det[k(x_i-y_j)]\ge0\)。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A057 | C | 明确函数 \(K(x)=(2\pi)^{-1}\int_{\mathbb R}e^{-ix\tau}/\xi(1/2+\tau)\,d\tau\) 满足 \(PF_\infty(K)\)。 |
| A058 | D | 存在 \(PF_\infty(k)\) 和 \(a>0\)，使 \(\int_{\mathbb R}k(x)e^{-sx}dx=1/\Xi(s)\) 在整个 \(\vert \Re s\vert <a\) 内绝对收敛并成立。 |

这里 A057 分母使用 **实轴方向的 \(\xi(1/2+\tau)\)**。不能换成经过临界线零点的 \(\Xi(\tau)\)。全正性要求独立的两组有序节点，强于只检验相同节点的 Gram 主子式。A058 是 [L06] 的 Schoenberg 表示的局部条带版本；解析恒等与唯一性将它接回相同的 Ξ。

#### F16. 真实 zeta screw function 与实线概率（A059–A062）

为使对象独立于 RH，先用 [L04] 的原始算术公式定义 \(g_\zeta\)。对 \(t\ge0\)，

\[
\begin{aligned}
g_\zeta(t)={}&-4(e^{t/2}+e^{-t/2}-2)
+\sum_{n\le e^t}\frac{\Lambda(n)}{\sqrt n}(t-\log n)\\
&-\frac t2\left(\frac{\Gamma'}\Gamma(1/4)-\log\pi\right)\\
&+\frac14\left[e^{-t/2}\operatorname{LerchPhi}(e^{-2t},2,1/4)
-\operatorname{LerchPhi}(1,2,1/4)\right].
\end{aligned}
\]

向负数作偶延拓，\(g_\zeta(0)=0\)。完整无条件显式公式给出

\[
g_\zeta(t)=\sum_{\rho\in\mathcal Z}m_\rho
\frac{e^{-i\gamma_\rho t}-1}{\gamma_\rho^2}.
\tag{E3}
\]

须先证明实际算术公式、实值连续性及紧集上一致绝对收敛，不能在定义中假定 \(\gamma_\rho\) 都为实数。

| ID | 类别 | 精确目标 |
| --- | --- | --- |
| A059 | C | \(K_g(t,u)=g_\zeta(t-u)-g_\zeta(t)-g_\zeta(-u)+g_\zeta(0)\) 的每个有限复 Gram 矩阵半正定。 |
| A060 | C | \(e^{g_\zeta}\) 是某个实线无穷可分概率分布的特征函数。 |
| A061 | D | 对每个 \(v\ge0\)，\(t\mapsto e^{v g_\zeta(t)}\) 在实加法群上正定。 |
| A062 | D | 存在弱连续实线概率卷积半群，其每个时刻 \(v\) 的特征函数恰为 \(e^{v g_\zeta(t)}\)。 |

这是 [L01, L04] 的实际 zeta 概率方向。它与 A019 的圆周概率半群具有相似结构，但载体、频率及 Lévy 测度不同，不能直接识别为同一个半群。

#### F17. 模型空间中的实际范数公式（A063）

取 \(s=1/2-it\)，用 [L03] Proposition 2.1 的实际零点级数定义

\[
G_n^{\rm Suz}(t)=\frac{\xi(s)}{\xi(s)+\xi'(s)}
\sum_{\rho\in\mathcal Z}m_\rho\frac{1-w_\rho^n}{s-\rho},\qquad n\ge1,
\]

并在可去奇点处取解析延拓值。该定义的级数收敛、连续性和实线 L² 性质，以及它与 [L03] 原始对数导数公式的相等，都是需要构造的无条件前置。

**A063，C：** 对每个 \(n\ge1\)，
\(\lambda_n=(2\pi)^{-1}\Vert G_n^{\rm Suz}\Vert _{L^2(\mathbb R)}^2\)。

必须使用这个固定的原始函数族。任意选择范数为 \(\sqrt{2\pi\lambda_n}\) 的向量，既没有定义负系数情形，也没有得到模型空间判据。

#### F18. Volchkov 的嵌套对数积分（A064）

**A064，C：**

\[
\int_0^\infty\frac{1-12t^2}{(1+4t^2)^3}
\left(\int_{1/2}^\infty\log|\zeta(\sigma+it)|\,d\sigma\right)dt
=\frac{\pi(3-\gamma_E)}{32}.
\]

采用 [L18] Eq. (2.1) 所列 Volchkov 表达，避免未规定路径的 `arg zeta`。对极点、零点的对数奇性和两层无穷积分分别证明合法性，不能只用截断数值代替等式。

### 4. 跨领域证明的共同骨架

在标准 RH 根之外，最重要的几条可复用解析链为

```text
actual xi / actual ZeroData / functional equation
  |-- Mobius disk -- canonical Li generator -- coefficient growth
  |                         |-- Li curvature -- circle moments
  |                         |                    |-- negative type / cocycle
  |                         |                    `-- probability semigroup
  |-- explicit formula -- full Weil form -- finite windows / actual spectrum
  |-- even xi coefficients -- Jensen / Laguerre-Polya -- Newton-Hankel
  |-- Mellin transform -- Nyman-Beurling -- original Gram distances
  |-- reciprocal zeta / Mobius sums -- Riesz / discrete transform / Redheffer
  |-- prime error terms -- divisor extrema / Farey discrepancy
  |-- logarithmic integrals -- BSY / Volchkov
  `-- heat deformation / total positivity / actual zeta probability
```

箭头代表要构造的数学映射及其定理，不保证所有箭头已经在仓库完成。已知两条 `RH ↔ P` 可以导出 `P ↔ Q`，但这类命题传递性不会自动产生误差界、矩阵大小、有效截断、测度对应或恢复算法。

同理，RH 等价命题之间的逻辑等价不表示项目中两个观察映射的不可区分核相同。后者必须固定同一原始状态空间并证明实际读出之间的恢复关系。不能凭 64 个闭命题构造新的信息逃逸分数或宣称全体读出有相同内核。

### 5. 当前文献对谱主线的具体修订

Suzuki 的 *Weil's quadratic form via the screw function* 已从 2026-06-08 的 v1 修订为 **2026-08-17 的 v2**。[L01] Theorem 1.1 提供实际 Friedrichs 实现，Theorem 1.3 研究最低谱值的连续性，Theorem 1.4 的正性、单性、偶性及渐近适用于充分小的窗口参数。其最终无穷窗口谱解释仍包含明确提出的猜想。

因此，A025–A026 的全部 \(a>0\) 量词不能由小窗口定理替代。对 #5602、#5895、#6029 的具体接入应保持同一个算术形式、同一个实际模型和完整混合余项。#5602 最新 shift barrier 消费的平移测试还要求物理支撑余量；两次平移使用 \(2t\) 余量，尖锐边界裁剪不自动满足这一条件。

[L19] 的 zeta spectral triples 与 [L20] 的 2026 综述为该路线提供背景。由明确模型得到的函数极限、由真实最低模态得到同一极限、以及将极限连到 RH 是不同定理。当前理论图谱没有将这些尚待完成的比较猜想计作已证明的 RH 等价判据。

Farey 工作 [L14] 已于 2026-09-02 修订到 v3；它与 2025 的 Redheffer 工作 [L16] 提供另外两条现代接口：前者要求区别普通 RH 和带同余类的 GRH，后者要求区别行列式中的 Möbius 抵消与最大奇异向量行为。跨领域联系保留被研究的实际量。

### 6. 完整纸面推导一：有限 Li–Toeplitz 重建

#### 6.1 双重望远镜求和

先不使用 RH。设实序列 \(u_0=0,u_1=L\ge0\)，Hermitian 序列 \(c\) 满足 \(c_0=1\)，并有

\[
u_{n+1}-2u_n+u_{n-1}=2L\Re c_n\quad(n\ge1).
\]

写 \(d_n=u_n-u_{n-1}\)，则 \(d_1=L\)，\(d_{n+1}-d_n=2L\Re c_n\)。先对差分求和，再对 \(d_n\) 求和，得到

\[
u_n=L\left[n+2\sum_{k=1}^{n-1}(n-k)\Re c_k\right].
\tag{E4}
\]

令 \(e_n=(1,\ldots,1)^T\in\mathbb C^n\)。按 Toeplitz 对角线逐条计数，距离 \(k\) 的两条对角线各含 \(n-k\) 项，因而

\[
e_n^*T^{(n)}e_n=nc_0+\sum_{k=1}^{n-1}(n-k)(c_k+c_{-k}).
\]

与 (E4) 比较可得精确恒等式

\[
\boxed{u_n=L\Re(e_n^*T^{(n)}e_n).}
\tag{E5}
\]

因此所有 Toeplitz 矩阵半正定立即推出所有 \(u_n\ge0\)，无需先构造一个无限 Herglotz 测度。删除原反向证明的 Herglotz 前提时，必须显式保留 \(c_0=1\)；旧概率表示曾隐含提供它。

#### 6.2 定量负方向与二次增长

若 \(L>0,u_n<0\)，由于 \(\Vert e_n\Vert ^2=n\)，Rayleigh 商给出

\[
\lambda_{\min}(T^{(n)})\le\frac{u_n}{nL}<0.
\tag{E6}
\]

这是指定矩阵大小和指定见证向量的运输。另一方面，所有两点主压缩半正定给出 \(\vert c_k\vert \le c_0=1\)。由 (E4)

\[
|u_n|\le L\left[n+2\sum_{k=1}^{n-1}(n-k)\right]=Ln^2.
\tag{E7}
\]

对规范 Li 系数，这给出

\[
\text{A014}\Longrightarrow\text{A013}\Longrightarrow\text{A010}
\Longrightarrow\text{A005}\Longrightarrow\mathrm{RH}.
\]

最后两步应复用 #6219 的实际解析延拓候选源，并完成所需编译检查。该反向路线不需要把 Li 判据本身作为参数传入。

#### 6.3 正向使用实际零点的概率测度

在 RH 下，对每个上半平面实际零点 \(\rho\)，写 \(w_\rho=e^{i\theta_\rho}\)。规范零点求和给出

\[
\lambda_n=2\sum_{\Im\rho>0}m_\rho(1-\cos n\theta_\rho).
\]

在 \(w_\rho\) 和 \(\bar w_\rho\) 各放置质量
\(m_\rho(1-\cos\theta_\rho)/L\)。总质量等于一；权重的完整可和性来自实际零点的平方倒数可和性。有限几何级数恒等式给出

\[
\lambda_n=L\int_{\mathbb T}\left|\sum_{j=0}^{n-1}z^j\right|^2d\sigma(z).
\tag{E8}
\]

由此得到规范曲率的圆周表示和 A014。解析重点是将导数定义的 \(\lambda_n\) 与带重数的实际零点和相等，并证明所有交换与尾界；任意抽象 Li-type 序列不够。

#6114 的几何 cocycle、Schoenberg 和概率半群可以在这个实际输入上接通。圆周恒等点处的原子与二次增长项应完整保留，直到针对规范测度给出排除证明。

### 7. 完整纸面推导二：同一离线零点的三种定量见证

设 \(\rho\) 是实际非平凡零点，\(\beta=\Re\rho>1/2\)，并记 \(r=\vert w_\rho\vert \in(0,1)\)。这些推导以存在这样的零点为条件，不断言其存在。

#### 7.1 原始 Nyman Mellin 恒等式

对 \(0<\theta\le1\)、\(0<\Re s<1\)，

\[
\int_0^1\{\theta/x\}x^{s-1}dx
=\frac\theta{s-1}-\frac{\theta^s\zeta(s)}s.
\tag{E9}
\]

可先在 \(\Re s>1\) 将 floor 写为指示函数和并逐项积分，再用左侧在 \(\Re s>0\) 的解析性作延拓，处理 \(s=1\) 的可去抵消。复幂使用正实数的实对数。

在 \(L^2(0,1)\) 上，\(\mathcal L_\rho f=\int_0^1f(x)x^{\rho-1}dx\) 的范数为 \((2\beta-1)^{-1/2}\)。由 (E9) 及 \(B_0\) 的约束，\(\mathcal L_\rho\) 消去整个 \(B_0\)，而 \(\mathcal L_\rho1=1/\rho\)。故

\[
\operatorname{dist}(1,\overline{B_0})\ge\frac{\sqrt{2\beta-1}}{|\rho|}.
\tag{E10}
\]

#### 7.2 直接作用于项目半直线载体的分离泛函

为避免把 (E10) 的范数常数未经证明转移到另一个载体，在原始 \(H=L^2(0,\infty)\) 上直接构造

\[
\mathcal J_\rho f=
\int_0^1f(x)x^{\rho-1}dx
-\frac1{\rho-1}\int_1^\infty\frac{f(x)}x\,dx.
\]

两项的 Riesz 向量支撑不交，故

\[
\|\mathcal J_\rho\|^2=\frac1{2\beta-1}+\frac1{|\rho-1|^2}.
\]

由于 \(v_a(x)=1/(ax)\) 在 \(x>1\) 上成立，(E9) 在 \(s=\rho\) 给出 \(\mathcal J_\rho v_a=0\) 对所有实 \(a\ge1\)；同时 \(\mathcal J_\rho\chi=1/\rho\)。因此对项目中的每个有限整数空间都有

\[
\begin{aligned}
d_N^2&\ge\frac{1}{|\rho|^2\left((2\beta-1)^{-1}+|\rho-1|^{-2}\right)}\\
&=\frac{(2\beta-1)|\rho-1|^2}{|\rho|^4}
=\boxed{r^2(1-r^2)}>0.
\end{aligned}
\tag{E11}
\]

同一界也适用于完整闭包的距离。这是实际半直线函数的连续分离证明，不依赖 Gram 矩阵可逆或有限数值条件数。它应复用仓库的实际 `target`、`sourceVector` 和 `distance` 定义。

#### 7.3 BSY 的同一半径读数

[L13] 的无条件恒等式为

\[
I_{\rm BSY}=2\pi\sum_{\Re\alpha>1/2}m_\alpha
\log\left|\frac\alpha{1-\alpha}\right|.
\]

右侧每项为正，因此给定零点 \(\rho\) 产生

\[
\boxed{I_{\rm BSY}\ge-2\pi m_\rho\log r>0.}
\tag{E12}
\]

这里按全部实际零点带重数计数，不再额外重复乘一个共轭对因子。

#### 7.4 Li 生成函数的同一半径障碍

该零点对应 \(F(w_\rho)=0\)。一旦在半径大于 \(r\) 的圆盘内有实际解析函数 \(G\) 满足 \(F'=GF\)，零点阶数比较就产生矛盾。#6219 的候选 `CanonicalLiRadiusObstruction` 将其量化为：对 \(r<R\le1\)，

\[
\forall N\;\forall C\;\exists n\ge N,
\qquad |\lambda_{n+1}|R^n>C.
\tag{E13}
\]

(E11)–(E13) 使用同一个实际 \(w_\rho\)：它在逼近论中给出正距离，在对数积分中给出正缺陷，在系数空间中排除每一个指定指数包络。由此可以研究转换中的显式常数，而非只依赖命题传递性。

这不提供最早失败指标，也不证明每个充分大的 Li 系数均超过包络。有限 Weil 负方向另由现有 separator 和共同 Burnol packet 构造；将其支撑半径与这里的 \(r\) 定量比较仍是新的研究任务。

### 8. 两条独立的算术变换桥

#### 8.1 Riesz 与二项式离散化

记 \(a_j^\zeta=1/\zeta(2j+2)\)，它与 Jensen 的 \(a_j\) 无关。对 \(x>0\)，完整指数生成关系为

\[
\frac{R(x)}x=e^{-x}\sum_{k\ge0}b_k\frac{x^k}{k!}.
\tag{E14}
\]

证明从有限二项式变换展开，交换绝对收敛级数，再求 \(\sum_{k\ge j}\binom kjx^k/k!=x^je^x/j!\)。实际 Möbius 展开进一步给出

\[
R(x)=x\sum_{n\ge1}\frac{\mu(n)}{n^2}e^{-x/n^2},\qquad
b_k=\sum_{n\ge1}\frac{\mu(n)}{n^2}(1-n^{-2})^k.
\tag{E15}
\]

[L11] 的完整误差比较 \(R(k)/k-b_k=O(k^{-3/2})\) 连同整数之间的控制，将两种增长界接通。形式化必须保留全部 \(n\) 尾部，证明从整数到实变量的运输；只验证有限项的二项式恒等式没有完成 A048–A049。

#### 8.2 Redheffer 行列式精确等于 Möbius 部分和

令 \(D_{ij}=1_{i\mid j}\)，\(1\le i,j\le N\)。它是单位上三角矩阵，且

\[
(D^{-1})_{ij}=\begin{cases}\mu(j/i),&i\mid j,\\0,&\text{其他}.\end{cases}
\]

令 \(u=(0,1,\ldots,1)^T\)，则 \(A_N=D+u e_1^T\)。矩阵行列式引理给出

\[
\boxed{\det A_N=\det D\,(1+e_1^TD^{-1}u)=\sum_{n=1}^N\mu(n)=M(N).}
\tag{E16}
\]

所需核心是除数卷积 \(\mu*1=\varepsilon\)，可以消费已有算术函数库。A054 的有限对象与 A041 的完整渐近完全一致。[L15, L16] 的奇异值研究不替代这一行列式身份。

### 9. Jensen、Weil 与正性的必要区分

对有限共轭稳定根族 \(z_1,\ldots,z_d\)，现有 Newton–Hankel 恒等式是

\[
a^THa=\frac1d\Re\sum_{j=1}^d q_a(z_j)^2.
\]

发现非实共轭根时，实系数插值可令 \(q_a(z)=i,q_a(\bar z)=-i\)，其余不同根取零，得到负方向。这个机制消费 **平方**；替换成 \(\vert q_a(z_j)\vert ^2\) 会使表达自动非负，从而失去检测能力。

Weil 的离线轨道同样通过交叉配对产生不定性，但把有限插值推广到完整零点和，还要控制全部其余零点。项目已有单轨道与多轨道 Burnol 机制负责这一分析层。Jensen 的有限矩阵结果也不能越过实际 ξ 系数与整函数极限。

[L06] 同时指出，某些倒数函数 Taylor 系数构成的矩 Hankel 正性只是 Laguerre–Pólya 的必要条件。它与本项目“给定有限多项式全部根的 Newton–Hankel 判据”是不同命题。不得凭 Hankel 同名把必要条件升级成 RH 等价。

另外，半正定判据要求所有主子式；只有全部顺序领先主子式的弱非负通常不足。严格正定的 Sylvester 判据、半正定判据和全正核的任意两组节点行列式，应各用其实际定理。

### 10. 按共享解析义务推进形式化

以下是实现单元，不是新建 64 个相互独立模块。最终每个公开端点必须以现有标准 `RiemannHypothesis` 和本节实际对象表达，且不接收一个同等困难的 `RH ↔ P` 作为未证明参数。通用引理仍可以参数化，只需与规范算术端点分开。

| 阶段 | 主要工作及复用点 | 完成时应得到的具体成果 |
| --- | --- | --- |
| P0：规范对象 | 复用 canonical ZeroData、xiReading、Li 导数；固定坐标、重数、Fourier 号和 Jensen 偶阶归一化 | A001–A005 的真实几何连接；每个定义与文献对象的对应定理。 |
| P1：Li 与概率 | 在现有曲率真源增加 (E4)–(E7)；接入 #6219 的圆盘分析和 #6114 的概率构造；证明实际导数系数等于规范零点和 | A006–A020 的共享解析闭环；显式有限负方向和指数包络障碍。 |
| P2：整函数与有限矩阵 | 证明实际偶阶系数严格正、Ψ 与 Ξ 的关系、Jensen–Pólya 定理；复用 NewtonHankelRealRootCriterion | A027–A032；实际多项式到矩阵与根失败见证的双向运输。 |
| P3：Nyman 解析桥 | 证明 (E9)、两个连续分离泛函、Beurling 稠密性与整数强化；复用实际 Gram、伪逆和闭包模块 | A033–A040，并得到 (E11) 的原始载体距离下界。 |
| P4：算术与误差 | 复用 Möbius、除数卷积、Mertens 和 prime-power 所有者；补 Perron、部分求和、极值整数及 Farey 运输；证明 (E14)–(E16) | A041–A049、A052–A054。每个 epsilon、阈值和尾部都有实际证明。 |
| P5：完整谱与函数空间 | 接合实际 Weil 载体及 Friedrichs 实现；证明全窗口/核心/谱对应；补 Speiser、BSY、Volchkov、Schoenberg PF、实际 zeta 概率、模型空间与热形变 | A021–A026、A050–A051、A055–A064；较重的共享分析定理可以再分解为有独立用途的子项目。 |

P1 与 P3 的有限恒等式和显式分离泛函可优先推进。P2 具有可直接消费的现有有限根定理。Rodgers–Tao 下界、Nyman 整数强化以及完整显式公式等大型前置按各自原定理实现，不以接口包装计作已解决。

每个最终端点的必要检查包括：两个方向均有证明；原函数和原序列没有被替代；实/复域与全部测试向量正确；重数与截断顺序正确；除法、对数和逆矩阵的定义域正确；无限和及积分换序合法；量词为全阶数、全尺度或全 epsilon；真源与 Scribe 指向同一声明。核验执行后再记录相应版本的编译与公理闭包，文档中的纸面推导不充当机器回执。

### 11. 可以进一步产生研究价值的定量问题

本图谱把“证明等价”与“利用等价”接在一起。近期可以提出以下直接面对原始对象的问题。

第一，给定实际离线零点位置、重数及一个有效邻域，将 (E11)、(E12) 与已有 Burnol 负测试统一为可检查的证书，显式控制测试支撑、次数、矩阵维度和尾误差。现有 (E13) 只保证每条指数包络在任意尾部失败；有效首次失败指标需要新的估计。

第二，将 Jensen 根分离裕量转成 Newton–Hankel 的负特征值裕量，再控制 ξ 系数的有限精度误差。插值条件数、根碰撞与矩阵大小会影响稳定性，不能把多项式根保持定理视为均匀鲁棒性结论。

第三，在 Nyman 原始 Gram 系统中同时控制计算误差和最佳逼近误差。伪逆公式容许奇异矩阵，却不会消除接近奇异时的数值敏感性。若使用正则化，应证明实际残差和正则化残差之间的定量关系。

第四，将 #5602/#5895/#6029 的完整算术余项与 [L01] 的实际形式域接合，研究随窗口无界增长的一致估计。固定窗口和固定扇区的进步保留其价值，但对 A025–A026 的全称命题还需要真正的尺度控制。

后续可扩展到广义 Li/Bombieri–Lagarias 参数族、完整广义 Laguerre 不等式塔、乘子序列、变差递减以及更细的算术极值判据。新条目必须先固定原定理、范围和量词。单个 Turán 不等式、弱 Mertens 加零点单性、某个有限样本成功、或尚未证明的 Hilbert–Pólya 模型，都不能直接加进已知 RH 等价清单。

### 12. 原始文献与精确定位

以下文献按本节用途引用。2026 新稿使用实际版本记录；引文支持指定数学陈述，不表示本次独立重证了每篇全文。经典结果的完整移植仍按第 10 节推进。

- **[L01]** Masatoshi Suzuki, *Weil's quadratic form via the screw function*, [arXiv:2606.09096v2](https://arxiv.org/abs/2606.09096v2), revised 2026-08-17. Theorems 1.1, 1.3, 1.4，形式核心与最终谱极限猜想。相关 PR 中 v1 引用应在实际采用新定理时更新。
- **[L02]** Jeffrey C. Lagarias, *Li Coefficients for Automorphic L-Functions*, [arXiv:math/0404394](https://arxiv.org/abs/math/0404394), Annales de l'Institut Fourier 57 (2007), 1689–1740. Li 导数、零点表达与增长判据的经典来源。
- **[L03]** Masatoshi Suzuki, *Li coefficients as norms of functions in a model space*, [arXiv:2301.05779v2](https://arxiv.org/html/2301.05779v2), 2023. Theorem 1.1；Propositions 2.1–2.2；Li–Weil 特殊测试函数恒等式。该特殊测试函数不属于原始光滑紧支撑类，使用时另证正则化和尾部运输。
- **[L04]** Takashi Nakamura and Masatoshi Suzuki, *On infinitely divisible distributions related to the Riemann hypothesis*, [arXiv:2306.08317v1](https://arxiv.org/html/2306.08317v1), 2023. Theorem 1.1、算术 screw function、实际零点展开及实线无穷可分分布。
- **[L05]** Michael Griffin, Ken Ono, Larry Rolen and Don Zagier, *Jensen polynomials for the Riemann zeta function and other sequences*, [arXiv:1902.07321v2](https://arxiv.org/html/1902.07321v2), 2019. 系数归一化、Jensen 实根塔及固定次数的大 shift 定理。
- **[L06]** Karlheinz Gröchenig, *Schoenberg's Theory of Totally Positive Functions and the Riemann Zeta Function*, [arXiv:2007.12889v1](https://arxiv.org/html/2007.12889v1), 2020. Theorems 1, 3, 4, 8；倒数矩 Hankel 必要条件与充分性的区别。
- **[L07]** Luis Báez-Duarte, *A strengthening of the Nyman-Beurling criterion for the Riemann hypothesis*, [arXiv:math/0202141](https://arxiv.org/abs/math/0202141), 2002. 实际半直线 L² 载体与整数 dilation 强化。
- **[L08]** J. Brian Conrey, *Riemann's Hypothesis*, [author-hosted text](https://aimath.org/~kaur/publications/90.pdf), 2019. 素数计数、Chebyshev 误差与 Möbius 部分和的等价表述；不采用其发表时的有限零点计算数量作为当前数据。
- **[L09]** Jeffrey C. Lagarias, *An Elementary Problem Equivalent to the Riemann Hypothesis*, [arXiv:math/0008177v2](https://arxiv.org/html/math/0008177v2). Main theorem；Robin 判据、Gronwall 与约数和极值背景。
- **[L10]** YoungJu Choie, Michel Planat and Patrick Solé, *On Nicolas criterion for the Riemann Hypothesis*, [arXiv:1012.3613v2](https://arxiv.org/abs/1012.3613v2). Primorial 输入与正反两种 RH 情况下的符号结论。
- **[L11]** Jan Cisło and Marek Wolf, *On the Riesz and Baez-Duarte criteria for the Riemann Hypothesis*, [arXiv:0807.2971v1](https://arxiv.org/abs/0807.2971v1), 2008. 指数生成恒等式、Möbius 表达、Lemma 3 与 Theorem 1 的完整误差运输。
- **[L12]** Farr and Pauli, *Zeros of the derivatives of the Riemann zeta function on the left half plane*, [author-hosted text](https://mat112.uncg.edu/pauli/publications/farr-pauli_zeta-deriv-left-half-plane.pdf). Theorem 1 重述 Speiser 等价；这里只使用该经典零点带判据。
- **[L13]** H. M. Bui, S. J. Lester and M. B. Milinovich, *On Balazard, Saias, and Yor's equivalence to the Riemann Hypothesis*, [arXiv:1306.0856v1](https://arxiv.org/html/1306.0856v1), 2013. Eqs. (1.1)–(1.2)；Theorem 1.2 给出带全部尾项的截断关系。其结果亦说明不能任意假定更强截断衰减率。
- **[L14]** Bittu Chahal, Tapas Chatterjee and Sneha Chaubey, *Distribution of Farey fractions with k-free denominators*, [arXiv:2507.00228v3](https://arxiv.org/html/2507.00228v3), revised 2026-09-02. 本节只消费引言准确列出的普通 Franel–Landau 判据；其带同余类推广不混作普通 RH。
- **[L15]** Herbert S. Wilf, *The Redheffer matrix of a partially ordered set*, [arXiv:math/0408263v1](https://arxiv.org/abs/math/0408263v1), 2004. 算术 incidence 结构与行列式。
- **[L16]** François Clément and Stefan Steinerberger, *On the largest singular vector of the Redheffer matrix*, [arXiv:2502.09489v1](https://arxiv.org/html/2502.09489v1), 2025. 原始矩阵定义、Möbius 行列式背景与独立的奇异向量问题。
- **[L17]** Brad Rodgers and Terence Tao, *The de Bruijn-Newman constant is non-negative*, [arXiv:1801.05914v5](https://arxiv.org/abs/1801.05914v5), revised 2021-07-03. 热核归一化、阈值与无条件下界。
- **[L18]** Yang-Hui He, Vishnu Jejjala and Djordje Minic, *From Veneziano to Riemann: A String Theory Statement of the Riemann Hypothesis*, [arXiv:1501.01975v2](https://arxiv.org/html/1501.01975v2), 2015. Eq. (2.1) 重述 Volchkov 的嵌套对数积分。本文不消费其中推测性的物理解释。
- **[L19]** Alain Connes, Caterina Consani and Henri Moscovici, *Zeta Spectral Triples*, [arXiv:2511.22755v1](https://arxiv.org/abs/2511.22755v1), 2025. 真实谱模型与极限研究背景。
- **[L20]** Alain Connes, *The Riemann Hypothesis*, [arXiv:2602.04022v1](https://arxiv.org/abs/2602.04022v1), 2026. 当前谱路线与算术结构的综述背景。

本图谱的下一步是逐条补齐真实解析边并消费已有真源。完成一个判据族的端到端证明，就将该族的规范对象、双向定理和见证运输接回这里的共同图谱，保留全部尚未完成的量词与分析义务。


---

## RH_PUBLIC_COVERAGE_AUDIT_20260908

### 13. 公开覆盖目标与本轮计数

第一版是 18 个判据族、64 个规格节点，其中 A001 为标准 RH，其余 63 个为替代或派生表述。**这一范围没有覆盖全部公开判据。** 本次新增 A065–A093 共 29 条规格，累计 **93 个节点、92 个替代表述规格、21 个判据族**。三个新增族为 F19 自逼近、F20 Salem 积分方程、F21 置换最大阶；其他条目扩展已有族。这里的条目数包含参数族和派生表达，不能解释为 92 项独立数学发现或 92 项已完成的 Lean 定理。

目标是公开文献逐项覆盖，不以 40、50、64 或 93 为上限。完整参数定理只建一个参数化规格，不把每个数值代入另算一个发现。已发表定理、公开预印本、仅有单向证明和需要额外假设的命题分别标注。

审查入口是 Broughan 三卷、AIM 专家纲要及原始论文，同时补检 2024–2026 年文献。**这几个来源集合的逐定理核对尚未完成，故本次仍不宣称全部公开等价形式已经覆盖。** Q01–Q10 明列剩余缺口，未计入新增规格。原始 PR 起点为 `8265370d41979f8659b97f6249f9a9e3530f57f4`，完整理论 blob 为 `5899285d185d0b5b288e84b400f3523d8bed99d7`；前文 dev/PR 审查保留其原有时间和提交范围。

### 14. 自逼近、Hardy 空间和 Salem 方程

#### F19：自逼近

令 \(S=\{s:1/2<\Re s<1\}\)。对补集连通的非空紧集 \(K\subset S\)，定义

\[
d_{K,\epsilon}(T)=T^{-1}\operatorname{meas}\{\tau\in[0,T]:
\sup_{s\in K}|\zeta(s+i\tau)-\zeta(s)|<\epsilon\}.
\]

**A065，Bagchi：** 对所有上述 \(K\) 及所有 \(\epsilon>0\)，\(\liminf_{T\to\infty}d_{K,\epsilon}(T)>0\)。[E01, Theorem 2]

**A066，Laurinčikas：** 对每个上述 \(K\)，存在至多可数 \(E_K\subset(0,\infty)\)，使每个正数 \(\epsilon\notin E_K\) 对应的 \(\lim_{T\to\infty}d_{K,\epsilon}(T)\) 存在且严格为正。[E01, Theorem 4]

两条分别与 RH 等价。可数例外集合、密度归一化和全部紧集的量词必须保留；其他平移比例的自逼近可能无条件成立。

#### 扩展 F06：两个实际 Hardy 载体

半平面空间采用
\(\|f\|^2=\sup_{x>1/2}(2\pi)^{-1}\int_{\mathbb R}|f(x+it)|^2dt\)。

**A067，Bagchi：** \(E(s)=1/s\) 属于 \(G_k(s)=(k^{-s}-k^{-1})\zeta(s)/s\)、\(k\ge2\) 在 \(H^2(\Re s>1/2)\) 中的闭复线性包。\(s=1\) 处构造可去延拓。[E02, Theorem 2.2]

**A068，Noor：** 在标准单位圆盘 \(H^2\) 中，常数 \(1\) 属于下列函数的闭复线性包：

\[
h_k(z)=\frac1{1-z}\log\left(\frac{1+z+\cdots+z^{k-1}}k\right),\quad k\ge2.
\]

对数在原点取 \(-\log k\) 的解析分支。[E02, Theorem 2.1] 两条分别等价于 RH。闭包存在性不指定自然 Möbius 部分和。2026 年 [E02] 的较右半平面收敛和数值实验不能替代临界 Hardy 空间的结论。

#### F20：Salem 积分方程

**A069，Salem：** 对每个 \(1/2<\delta<1\)，每个有界可测复函数 \(f\)，若

\[
\int_0^\infty\frac{t^{\delta-1}f(t)}{e^{xt}+1}dt=0\quad\text{对所有 }x>0,
\]

则 \(f=0\) 几乎处处。所有 \(\delta\) 的合取与 RH 等价。[E03]

**A070，显式 Mellin 表达：** 对所有 \(1/2<\delta<1\)、\(\gamma\in\mathbb R\)，
\(\int_0^\infty t^{\delta-1+i\gamma}/(e^t+1)dt\ne0\)。

直接桥梁为

\[
\int_0^\infty\frac{t^{s-1}}{e^{xt}+1}dt
=x^{-s}\Gamma(s)(1-2^{1-s})\zeta(s),\quad x>0,\ \Re s>0.
\tag{E17}
\]

\(s=1\) 按可去抵消解释。目标开带上 Gamma 与 \(1-2^{1-s}\) 不为零，故 A070 与 RH 等价。[E03] 任意有界函数的 Salem 唯一性仍需自己的分析证明；显式幂函数读法不替代它。2026 预印本的发表状态与经典 Mellin 恒等式分开，不主张新的数学优先权。

### 15. 广义 Li、完整实根判据与横向单调性

#### 扩展 F02：完整实参数族

固定 \(a\in\mathbb R\setminus\{1/2\}\)，使用实际非平凡零点及解析重数定义

\[
S_n(a)=\lim_{T\to\infty}\sum_{|\Im\rho|\le T}m_\rho
\left[1-\left(\frac{\rho-a}{\rho+a-1}\right)^n\right],\quad
D_n(a)=\left.\frac1{(n-1)!}\frac{d^n}{ds^n}
\bigl((s-a)^{n-1}\log\xi(s)\bigr)\right|_{s=1-a}.
\]

对称极限、实值性和局部对数先证明合法。每个固定许可参数下，以下三条各自与 RH 等价。[E04, Theorems 1、2、5]

| ID | 精确陈述 |
| --- | --- |
| A071 | 对所有 \(n\ge1\)，\(S_n(a)\ge0\)。 |
| A072 | 对所有 \(n\ge1\)，\((1-2a)D_n(a)\ge0\)，保留左右参数区域的相反符号。 |
| A073 | 对每个 \(\epsilon>0\)，存在 \(C_{a,\epsilon}\ge0\)，使所有 \(n\ge1\) 满足 \(S_n(a)\ge-C_{a,\epsilon}e^{\epsilon n}\)。 |

原 Li 系数的特例身份要与已有导数定义证明一致。一个固定指数下界或有限前缀不能代替 A073 的全部 epsilon。

#### 扩展 F05、F15：完整不等式塔与全正性

对实际 \(\Xi\) 定义

\[
L_k[\Xi](x)=\sum_{j=0}^{2k}\frac{(-1)^{j+k}}{(2k)!}\binom{2k}{j}
\Xi^{(j)}(x)\Xi^{(2k-j)}(x).
\]

**A074，经典广义 Laguerre 判据：** 对全部 \(k\ge0,x\in\mathbb R\)，\(L_k[\Xi](x)\ge0\)。完整阶数塔等价于 RH；单个 Turán/Laguerre 不等式只提供必要条件。[E05, Section 2]

复用前文 \(a_n=n!\xi^{(2n)}(1/2)/(2n)!>0\)。

**A075，Pólya–Schur 特化：** 对每个实根实多项式 \(\sum p_jX^j\)，系数乘子输出 \(\sum a_jp_jX^j\) 仍实根，零多项式按通用乘子定义允许。[E05] 通过 \(\Psi(u)=\sum a_nu^n/n!\) 的 Laguerre–Pólya I 类性质连接 RH。

令 \(b_n=a_n/n!\) 对 \(n\ge0\)，\(b_n=0\) 对 \(n<0\)。

**A076，离散 PF∞：** 对全部阶数 \(r\ge1\)，全部严格递增非负整数行索引 \(i_p\) 和列索引 \(j_q\)，\(\det[b_{j_q-i_p}]_{p,q=1}^r\ge0\)。[E06] 使用实际 \(\Psi\) 的亏格零性质与 Aissen–Schoenberg–Whitney–Edrei 表示；不能把亏格零误写成增长阶为零。该全正性等价于 RH，所有两组索引不能缩为主子式。2026 年的巨大 shift 区域结果不完成全称判据。

#### 扩展 F01：实际 ξ 的横向性质

**A077：** 对每个 \(t\in\mathbb R\)，\(\sigma\mapsto|\xi(\sigma+it)|\) 在 \((1/2,\infty)\) 严格递增。[E07, Corollary 1] 左半平面严格递减版本由函数方程归入同族。

**A078：** 对全部 \(\Re s>1/2\)，\(\Re(\xi'(s)\overline{\xi(s)})>0\)。[E07, E15.C5c] 这是对数导数正性的无除法表达；零点处左侧为零，反向不会偷用未证明的非零分母。两条各自等价于 RH，但一般函数的严格单调不等同于导数处处严格正。

### 16. 极值整数、置换群和算术平滑

#### 扩展 F08：极丰数及超丰数子集

定义 \(F(n)=\sigma(n)/(n\log\log n)\)，

\[
XA=\{10080\}\cup\{n>10080:\ \forall\,10080\le m<n,\ F(m)<F(n)\}.
\]

**A079：** \(XA\) 无限。这与 RH 等价，保留起点 10080 及严格纪录条件。[E08, Theorem 2.4]

**A080，预印本规格，待独立核验：** 对全部 superabundant 正整数 \(n\)，\(\sigma(n)\le H_n+e^{H_n}\log H_n\)。superabundant 指每个 \(1\le m<n\) 都满足 \(\sigma(m)/m<\sigma(n)/n\)。[E09, Theorem 3.1] 声称最小 Lagarias 反例必为 superabundant；其有限初始区间与阈值单调性尚待独立复核。本条进入公开规格数量，但不能与独立核验完毕的经典定理或机器证明合并统计。

#### F21：Landau 最大置换阶

\(g(n)\) 为对称群 \(S_n\) 中元素的最大阶。使用 \(\operatorname{li}(x)=\operatorname{Ei}(\log x)\) 的主值归一化及其在 \(x>1\) 上的反函数，不能换成前文相差常数的 \(\int_2^xdt/\log t\)。设

\[
q_n=\frac{\sqrt{\operatorname{li}^{-1}(n)}-\log g(n)}{(n\log n)^{1/4}},\ n\ge2,
\quad d=\frac{2-\sqrt2}{3},\quad c=\sum_{\rho\in\mathcal Z}\frac{m_\rho}{|\rho(\rho+1)|}.
\]

\(c\) 使用实际全体零点与完整可和性。以下各条分别等价于 RH。[E10, Theorem 1.1、Corollary 1.3]

| ID | 精确陈述 |
| --- | --- |
| A081 | 所有 \(n\ge1\) 满足 \(\log g(n)<\sqrt{\operatorname{li}^{-1}(n)}\)。 |
| A082 | 存在 \(N\ge1\)，使 A081 的不等式对所有 \(n\ge N\) 成立。 |
| A083 | 所有 \(n\ge2\) 满足 \(q_n\ge d-c-\tfrac{43}{100}\tfrac{\log\log n}{\log n}>0\)。 |
| A084 | 所有 \(n\ge19425\) 满足 \(q_n\le d+c+\tfrac{51}{50}\tfrac{\log\log n}{\log n}\)。 |
| A085 | 所有 \(n\ge2\) 满足 \(\tfrac{694}{6250}<q_n\le q_2\)，其中有理下界等于 0.11104。 |
| A086 | \(d-c\le\liminf q_n\le\limsup q_n\le d+c\)。上下极限用扩展实数定义。 |
| A087 | 存在最终有界实序列 \(u_n,v_n\)，使所有充分大 \(n\) 满足 \((d-c)(1+\tfrac{\log\log n+u_n}{4\log n})\le q_n\le(d+c)(1+\tfrac{\log\log n+v_n}{4\log n})\)。 |

A087 显式保留两项 \(O(1)\)。原论文的有限计算和阈值证书未在本轮执行。群论的最大阶与 prime-power 优化必须证明是同一个对象。相近的 squarefree 优化 \(h(n)\) 或 \(\omega(g(n))\) 结论另需核对，不能据外形相同推定。

#### Nicolas 2024：全部整数上的 totient 阈值

\(p_j\) 为第 \(j\) 个素数，\(P_k=\prod_{j\le k}p_j\)，\(k=120568\)。定义

\[
A=P_k\frac{p_{k+1}p_{k+2}}{p_kp_{k-10}},\qquad
\delta=e^{\gamma_E}(4+\gamma_E-\log(4\pi)),
\]

\[
C_\varphi(n)=\left(\frac n{\varphi(n)}-e^{\gamma_E}\log\log n\right)\sqrt{\log n},\quad n\ge2.
\]

| ID | 与 RH 等价的陈述 |
| --- | --- |
| A088 | 对所有整数 \(n>A\)，\(C_\varphi(n)<\delta\)。 |
| A089 | \(\limsup_{n\to\infty}C_\varphi(n)=\delta\)。 |
| A090 | 存在实数 \(B\) 与整数 \(N\ge2\)，使全部 \(n\ge N\) 满足 \(C_\varphi(n)\le B\)。 |

[E11, Theorem 1.1、Eqs. (1.5)–(1.12)] 给出 RH 下的阈值及 limsup，非 RH 下 limsup 为正无穷。原文 \(C_\varphi(A)>\delta\)，所以输入必须是 \(n>A\)。这些全部整数的精细误差不能由原 primorial 判据 A047 直接替换。

#### 扩展 F09：完整平滑参数族

**A091，Hardy–Littlewood：** 定义整函数 \(H(x)=\sum_{j\ge1}(-x)^j/(j!\zeta(2j+1))\)。对每个 \(\epsilon>0\)，\(H(x)=O_\epsilon(x^{-1/4+\epsilon})\) 当 \(x\to+\infty\)，当且仅当 RH。[E12, Introduction] 它对应 \(\sum\mu(n)e^{-x/n^2}/n\) 的自然部分和极限；也可用绝对收敛的 \(\sum\mu(n)(e^{-x/n^2}-1)/n\) 定义，再消费无条件 \(\sum\mu(n)/n=0\)。

**A092：** 对每个固定 \(k\ge1,\ell>0\)，令 \(P_{k,\ell}(x)=\sum_{n\ge1}\mu(n)n^{-k}e^{-x/n^\ell}\)。RH 等价于

\[
\forall\epsilon>0,\quad P_{k,\ell}(x)=O_{k,\ell,\epsilon}(x^{-k/\ell+1/(2\ell)+\epsilon}).
\]

[E12, Theorem 3.10 的 zeta 特化] 每个许可参数对各自给出等价定理；\(k=1\) 的自然部分和极限不能误称绝对收敛。

**A093：** 固定整数 \(r\ge0\)、实数 \(k\ge r+1,\ell>0\)。令 \(\sigma_r(n)=\sum_{d\mid n}d^r\)，其 Dirichlet 卷积逆为 \(\sigma_r^{-1}=\mu*(n\mapsto n^r\mu(n))\)。RH 等价于

\[
\forall\epsilon>0,\quad
\sum_{n\ge1}\sigma_r^{-1}(n)n^{-k}e^{-x/n^\ell}
=O_{k,r,\ell,\epsilon}(x^{-k/\ell+(1+2r)/(2\ell)+\epsilon}).
\]

[E12, Theorem 3.13] 卷积逆不等于逐点倒数。边界参数的级数收敛须单独证明；相邻公式为使用 \(1/\zeta'(\rho)\) 所加的单零点假设不能未经核对混入此端点。一般 L-function 的版本另记为 GRH 范围。

### 17. 来源覆盖账与尚未编号的缺口

每项分别登记：来源已定位、精确陈述已提取、双向数学证明已审查、原对象上的 Lean 定理已核验。当前新增条目主要完成前两阶段。公开来源中的定理并不因此自动成为本项目的机器真值。

| 来源集合 | 已接入 | 尚未完成 |
| --- | --- | --- |
| Broughan I（2017） | 原算术族及本次极丰数、Landau、totient | 极值整数、纪录型和误差变体仍须逐定理对照。 |
| Broughan II（2017） | 原 Li/Weil/Nyman；本次 Hardy、Salem、完整实根和全正性 | 正交多项式、分圆、积分方程、离散测度、Hermitian forms、smooth numbers 未完成逐条核对。 |
| Broughan III（2023） | 原 dBN/Jensen；本次自逼近入口 | prime-counting、divisor-count、zero-gap、Dobner、Gonek–Bagchi、可判定性尚未逐定理区分附加假设。 |
| AIM 纲要 Section C | 大部分已列经典入口 | 空标题和未提取公式不能算已经覆盖；下面 Q 表保留原始论文义务。 |
| 现代论文 [E01]–[E12] | A065–A093 的明确规格 | 原始证明、精度证书及参数边界按每条来源继续核验；A080 明确保留预印本状态。 |

| 登记号 | 已找到的方向 | 尚待精确提取或核对 |
| --- | --- | --- |
| Q01 | Amoroso（1995）的分圆多项式乘积高度，AIM C3a | \(F_N=\prod_{n\le N}\Phi_n\) 的 \((2\pi)^{-1}\int_{-\pi}^{\pi}\log^+\vert F_N(e^{it})\vert dt=O_\epsilon(N^{1/2+\epsilon})\) 已见专家纲要；原始全文和全部条件未核完。 |
| Q02 | Broughan II Chapter 6；Romik 的 Hermite、Meixner–Pollaczek、continuous Hahn 展开 | 仅存在正交展开不构成 RH 等价；需要原始系数、零点或完备性判据。 |
| Q03 | Weingartner 的加权余数向量投影，[E02] 文献链 | 固定 \(r_k(j)=j\bmod k\) 的权重、索引及投影系数趋向 \(-\mu(k)/k\) 的完整量词。 |
| Q04 | Lapidus–Maier（1995）的分形弦逆谱问题 | Minkowski 维数、计数渐近、可测性以及逐维无零点与全部非中线维数的区别。 |
| Q05 | Nicolas 的 \(\pi(x)\) 与 divisor-count 判据，Broughan III Chapters 1–2 | 约数个数 \(d(n)\) 与约数和 \(\sigma(n)\) 不同，原 Robin 不能代替。 |
| Q06 | \(\omega(g(n))\) 与 squarefree 最大乘积 \(h(n)\) | 各自反向结论及精确阈值，不能从 A081 外推。 |
| Q07 | Mikolás、Pólya/Newman 积分、Grommer inequalities | AIM 部分标题没有完整命题；需追溯原函数、参数和全部阶数。 |
| Q08 | Broughan II 的离散测度、Hermitian forms、smooth numbers | 具体算术对象与必要充分性；通用 Gram 正性不够。 |
| Q09 | Mazet–Saias、Laurinčikas、Gonek–Bagchi 的离散/短区间自逼近 | 步长、例外集、区间长度及密度归一化，不能仅用 A065 代替全部变体。 |
| Q10 | Dobner、zero-gap、可判定性 | 普通 RH、GRH、RH 加单零点和逻辑附加假设逐条分类。 |

Q01–Q10 没有算入 A001–A093。它们表明目前覆盖审查尚未完成，不能通过增加同义节点宣称全公开覆盖。固定来源集合的每个实际等价定理应映射到一个 ID，或注明参数特化、同义表达、范围不同、仅单向等理由；新增公开来源继续追加。

### 18. 形式化接入与证据边界

保留 P0–P5。广义 Li 和整函数条目复用 canonical Li、实际 ξ、Jensen 与 Newton–Hankel；Hardy/Nyman 共用 Mellin 与有界变换；Salem 使用实际 ζ 的 Mellin 核和独立唯一性；极值整数复用算术函数、primorial、Gronwall/Robin；Landau 构造实际有限群与 prime-power 优化的对应；平滑参数族复用 Möbius 卷积与完整可和性。每个新 Lean 真源配套 Scribe，理论继续追加本卷。

本轮没有新增 Lean、运行编译或核验传递公理闭包。93 个节点是文献与数学规格，不能包装成接收 92 个未知等价式参数的结构后宣称形式化完成。完整终点仍是每个原始命题与 `RiemannHypothesis` 的两个方向。

### 19. 新增参考文献

- **[E01]** A. Laurinčikas, *Remarks on the Connection of the Riemann Hypothesis to Self-Approximation*, Computation 12(8), 164 (2024), [DOI:10.3390/computation12080164](https://www.mdpi.com/2079-3197/12/8/164). Theorems 2、4。
- **[E02]** J. Manzur, W. Noor, G. Quintero, *A Hardy space approximation supporting zero-free half-planes for the ζ-function*, [arXiv:2606.16097v1](https://arxiv.org/html/2606.16097v1). Theorems 2.1–2.2 重述原始 Noor、Bagchi 判据；不采用数值实验作证明。
- **[E03]** González, Negrín, *A new equivalence to the Riemann Hypothesis by means of the Salem integral equation*, [arXiv:2604.15396v1](https://arxiv.org/html/2604.15396v1). 经典 Salem 与显式幂函数读法；预印本。
- **[E04]** S. K. Sekatskii, *Generalized Bombieri–Lagarias’ theorem and generalized Li’s criterion*, [arXiv:1304.7895v3](https://arxiv.org/abs/1304.7895v3). Theorems 1、2、5。
- **[E05]** I. Wagner, *On a new class of Laguerre–Pólya type functions with applications in number theory*, [arXiv:2108.01827v2](https://arxiv.org/abs/2108.01827v2). 经典 Pólya–Schur 与广义 Laguerre 引用链；不将 shifted 类结果升级为 RH。
- **[E06]** W. Michałowski, *An explicit uniform cubic wedge for consecutive Toeplitz minors of the Riemann ξ-coefficients*, [arXiv:2607.16795v1](https://arxiv.org/html/2607.16795v1). 使用引言的经典 PF∞ 对应，巨大 shift 结果没有在本轮独立核验。
- **[E07]** J. Sondow, C. Dumitrescu, *A monotonicity property of Riemann’s xi function and a reformulation of the Riemann Hypothesis*, [arXiv:1005.1104](https://arxiv.org/abs/1005.1104). Corollary 1。
- **[E08]** S. Nazardonyavi, S. Yakubovich, *Extremely abundant numbers and the Riemann hypothesis*, [arXiv:1211.2147](https://arxiv.org/abs/1211.2147). Theorem 2.4。
- **[E09]** A. MacArevey, *On the Lagarias Inequality and Superabundant Numbers*, [arXiv:2602.15905v2](https://arxiv.org/html/2602.15905v2). Theorem 3.1；A080 待独立核验。
- **[E10]** M. Deléglise, J.-L. Nicolas, *The Landau function and the Riemann hypothesis*, [arXiv:1907.07664](https://arxiv.org/abs/1907.07664). Theorem 1.1、Corollary 1.3、Section 2.2。
- **[E11]** J.-L. Nicolas, *A Robin inequality for n/phi(n)*, New Zealand Journal of Mathematics 55 (2024), 1–9, [DOI:10.53733/324](https://nzjmath.org/index.php/NZJMATH/article/view/324). Theorem 1.1 与 Eqs. (1.5)–(1.12)。
- **[E12]** Garg, Maji, *Equivalent criteria for the Riemann hypothesis for a general class of L-functions*, [arXiv:2409.17708v2](https://arxiv.org/html/2409.17708v2). Introduction、Theorems 3.10、3.13；这里只收普通 ζ 范围。
- **[E13]** K. Broughan, *Equivalents of the Riemann Hypothesis*, Volume I (2017), [DOI:10.1017/9781108178228](https://doi.org/10.1017/9781108178228); Volume II (2017), [DOI:10.1017/9781108178266](https://doi.org/10.1017/9781108178266). 已核目录与部分对应原文，未完成全书逐定理核对。
- **[E14]** K. Broughan, Volume III (2023), [DOI:10.1017/9781009384780](https://doi.org/10.1017/9781009384780). 逐定理覆盖审查仍开放。
- **[E15]** American Institute of Mathematics, [RH expert workshop outline](https://www.aimath.org/WWN/rh/rh.pdf), Section C。第一方专家目录与原文追溯入口，空标题不充当完整定理。

**当前状态：93 个节点、92 个替代表述规格、21 个判据族；公开文献全覆盖仍未完成，Q01–Q10 是明确未决项。**

\]

---

## [PR #6114] CIRCLE_PROBABILITY_COMPLETION_AND_LI_JUMP_BOUNDARY

日期：2026-09-07。固定源码参照：`05c05729c5cb073dbeb215d8148813db4470952d`。本节继续 GICT VI.3、PZG 27.278–27.279 与 OACC 261.1 的既有概率路线。四个新增 Lean 文件及其 Scribe 位于 `Weil/Probability/`，使用现有 `circleMoment`、`toeplitzMatrix`、`geometricPolynomial` 和 `reconstructedLi`，没有另设 zeta、Li 系数或 Fourier 约定。

本节的数学推导和证明脚本已完成；本轮没有执行 Lean elaboration、内核检查、传递公理报告或 Scribe emission。源码仍是候选形式化。精确有限诊断是第二实现检查，不能替代无限阶定理的内核验证。经典 Herglotz 表示、紧性和卷积 Fourier 公式不作数学优先权主张。

### 1. 实际复用与本轮消除的前提

`TruncatedCircleMomentBridge.truncated_circle_moment_of_posSemidef` 已从每阶 Toeplitz 正半定矩阵构造有限原子测度。`FourierModeDetermination.all_fourier_modes_determine_measure` 已证明完整圆周 Fourier 数据的测度唯一性。`LiCurvatureCriterion` 已证明 Gram 积分、几何多项式能量、二阶递推唯一性与条件性 Li 判据，但其最后一个公共前提仍要求给出一份实现全部阶数的 Herglotz 概率测度。

本轮以 Mathlib 钉版 `db584cd6d46c92f209a44c0f1c829460d327499d` 的概率测度弱拓扑和紧性，把有限见证完成为同一份测度。其后证明实际卷积半群、整列弱收敛及原 Li 型序列重建。旧定理没有显式的 `c(0)=1` 参数；新接口明确加入此归一化，不能声称在任意未归一化输入上删除了测度前提。

### 2. 全部有限矩阵产生同一个概率测度

保持原约定：

\[
\widehat\mu(n)=\int_{\mathbb T}z^{-n}\,d\mu(z),\qquad
T_N(c)_{jk}=c_{j-k},\quad 0\le j,k\le N.
\]

`CircleHerglotzCompletion.circle_herglotz_iff` 的结论是

\[
 c_0=1\quad\Longrightarrow\quad
 \bigl(\forall N,\ T_N(c)\succeq0\bigr)
 \iff \exists!\mu\in\mathcal P(\mathbb T),\ \forall n\in\mathbb Z,\ \widehat\mu(n)=c_n.
\]

共轭对称 `c(-n)=conj(c(n))` 由各阶矩阵的 Hermitian 条件导出。有限表示在零模式的质量因此为一。对每个 N 定义

\[
K_N=\{\mu\in\mathcal P(\mathbb T):\widehat\mu(n)=c_n\text{ for }|n|\le N\}.
\]

每个 K_N 非空、闭，且 K_(N+1) 包含于 K_N。圆周概率测度空间在弱拓扑中紧，因此交集非空。唯一性通过标准 Circle/AddCircle 同胚复用已有 Fourier 测度唯一性，过程中保留了负幂与模式反号。

完整矩剖面是从紧空间到 Hausdorff 乘积空间的连续单射，因而为拓扑嵌入。`continuous_iff_circleMoments` 和 `tendsto_iff_circleMoments` 据此刻画实际弱连续性和任意 filter 下的弱收敛。

`finite_moment_witnesses_tendsto` 进一步证明：若任意选择的概率见证 nu_N 匹配前 N 阶矩，则整列 nu_N 弱收敛到上述同一个 mu。固定模式 n 在 N>=|n| 后已恒等于 c_n；无需相邻见证相同或彼此存在耦合。这里既没有从单个有限 N 推出无限结论，也没有给出收敛速率。

### 3. Fourier 数据构造实际概率卷积演化

`CircleProbabilitySemigroup.circleMoment_mconv` 对 Mathlib 的实际乘法卷积证明

\[
\widehat{\mu\mathbin{*_m}\nu}(n)=\widehat\mu(n)\widehat\nu(n).
\]

卷积是乘积测度在圆周乘法下的推前，证明使用有限测度的可积性及 Fubini。

若 c_t(n) 在 t>=0 连续，满足 c_t(0)=1、c_0(n)=1、c_(s+t)(n)=c_s(n)c_t(n)，且每个 t 的全部 Toeplitz 矩阵正半定，那么 `circle_probability_semigroup_of_fourier` 构造唯一的实际概率族 mu_t，并同时证明

\[
\widehat\mu_t(n)=c_t(n),\qquad \mu_0=\delta_1,\qquad
\mu_{s+t}=\mu_s\mathbin{*_m}\mu_t,
\]

以及 mu_t 的弱连续性。唯一性甚至不要求竞争概率族先具有连续性。

对于任意实序列 psi，psi(0)=0，`exponential_toeplitz_iff_probability_semigroup` 得到全部指数矩阵正性与指定系数 exp(-t psi(n)) 的实际弱连续半群存在性的等价。这一部分没有调用或证明 Schoenberg 定理，指数矩阵的正性仍是前件。

逐项 psi(n)>=0 远弱于该正定条件。精确负对照取 psi(+-2)=1，其余整数为零，在 t=log(2) 时 c_0=c_(+-1)=1、c_(+-2)=1/2。向量 (1,-2,1) 在三阶 Toeplitz 矩阵上的二次型恰为 -1。另一方面，`exponential_probability_forces_nonnegative` 从实际概率矩的模长不超过一导出每个 psi(n)>=0，明确只证明必要方向。

### 4. 同一份测度重建全部原始 Li 型系数

令 L_0=0，a=L_1，且

\[
L_{n+1}-2L_n+L_{n-1}=2a\Re c_n\quad(n\ge1).
\]

`LiCurvatureProbabilityCompletion.normalized_curvature_reconstruction` 从 c_0=1 和全部 T_N(c)>=0 构造上述唯一 mu，再利用已有二阶递推唯一性证明

\[
L_n=a\int_{\mathbb T}\left|1+z+\cdots+z^{n-1}\right|^2d\mu(z)
\]

对每个 n 成立。a>=0 因而导出每个原系数非负。整个原序列同时重建，没有在各阶任意选择不同的概率律。

`li_curvature_criterion_without_herglotz` 将此构造代入原 `li_curvature_criterion`，消除外加的共同 Herglotz 测度前提。实际 derivative-defined Li 判据、原始递推及 RH-to-Fourier identification 仍然公开作为参数，不能把这个适配器写成无条件 RH 定理。

`time_one_li_probability_implies_rh` 还记录：在给定实际算术 Li 判据的情况下，仅一份具有全部 exp(-L_|n|) 矩的 time-one 概率律就足以给出反向蕴含。它没有构造该律；一般指数半群仍使用上一节的全部正性条件。

### 5. 不能丢掉圆周恒等点：精确 Gaussian 项与跳跃项

Herglotz 完成所得概率测度可以在 z=1 有原子。正尺度 Cayley 映射 (x+ib)/(x-ib) 在任何有限实数 x 上都不等于一；因此从任意圆周表示逆向解释为实谱之前，必须处理这个边界点。

`LiCurvatureLevyDecomposition` 从既有几何多项式直接证明

\[
\left|\sum_{j=0}^{n-1}z^j\right|^2=
\frac{2(1-\Re z^n)}{|z-1|^2}\quad(z\ne1),
\qquad
\left|\sum_{j=0}^{n-1}1\right|^2=n^2.
\]

对任意有限 mu 和实数 a，实际 `reconstructedLi` 因而满足

\[
L_n=a\,\mu(\{1\})n^2+
\int_{\mathbb T\setminus\{1\}}
\frac{2a(1-\Re z^n)}{|z-1|^2}\,d\mu(z).
\]

`reconstructed_li_levy_decomposition` 是此精确等式。`li_jump_integrable` 在未假设总跳跃权重可积的情况下证明补偿后的被积函数可积。证明始终保留 (1-Re z^n) 的抵消；不将它拆成两个可能发散的积分。

a>=0 时两个贡献非负。恒等点质量产生下界

\[
a\mu(\{1\})n^2\le L_n.
\]

因此 a>0 且 L_n/n^2->0 蕴含 mu({1})=0。`identity_atom_vanishes_of_subquadratic` 证明的是实际 Borel 测度的原子质量消失。`normalized_curvature_jump_representation` 将共同测度构造、原始递推和这一增长条件合并，从原始 c,L 输入得到同一个无恒等点原子的测度和全部系数的纯补偿跳跃表达；无原子性不是前提。

这解释了一个必须保留的边界：一般正定曲率可以重建 L_n=a n^2，例如 mu=delta_1。该模型不能直接当作实际 Riemann 零点测度。排除恒等点也不会自动证明剩余测度是离散的，或其原子位置、重数恰为实际 zeta 零点。

### 6. 已有概率判据与本轮位置

Nakamura–Suzuki, *On infinitely divisible distributions related to the Riemann hypothesis*, Statistics & Probability Letters 201 (2023), 109889, arXiv:2306.08317，讨论由实际 g_zeta 构造的 exp(g_zeta)。Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096，讨论实际 screw 核与 Weil 形式。当前 arXiv 摘要记录已核对；本轮没有重新独立证明这两篇论文的全部结果。

本轮构造的曲率测度 mu 与演化测度 mu_t 是不同对象；它们的矩分别是 c_n 与 exp(-t psi_n)。它们也没有被未经证明地等同于归一化 Xi 的概率分布或 Nakamura–Suzuki 的实轴概率律。

进一步的纸面连接可以直接从本轮真实能量出发。对整数 n，将有限几何和扩展成 b_n(z)，使 b_(m+n)=b_m+z^m b_n。则 |b_j-b_k|^2=|b_(j-k)|^2。对和为零的有限实系数 r_j，

\[
\sum_{j,k}r_jr_k L_{|n_j-n_k|}
=-2a\int\left|\sum_jr_jb_{n_j}(z)\right|^2d\mu(z)\le0.
\]

这给出标准条件负定证明的具体被积函数。复系数可按实部和虚部分开处理实对称核。把这一步与 Schoenberg 指数正定性接入本轮实际半群构造，是明确的下一形式化接口；本节未把这个纸面推导计入已写出的 Lean 公共声明。

### 7. 执行检查与尚未消除的算术义务

精确诊断采用 seed 20260907 和 Gaussian rational / Fraction 运算：64 个有限概率律，1600 个共轭矩检查，320 个 Gram 恒等式，768 个曲率递推，768 个有限系数重建，1088 个实际卷积矩恒等式，544 个两点族半群矩恒等式，以及各 768 个 Gaussian/jump 分解、原子二次下界和有限原子族极限界。四个负对照分别拒绝逐项非负冒充正定、错误 Fourier 符号、缺失质量归一化和误认不同有限见证相等。这些是作者的第二实现，非独立审稿或无限域验证。

实际 g_zeta 与 xi'/xi 的精确统一、canonical derivative-defined Li 判据、Li 全序列与实际零点测度识别、Schoenberg 的机器接口，以及真正的全局算术正性仍未由本轮消除。固定黄金周期的 Fourier 数据仍有尺度层数盲区；本轮完整圆周矩的唯一性不恢复被周期商映射删去的层数。次二次增长条件也尚未在此增量中从实际算术对象导出。

本轮没有改变旧 Lean、冻结记录、理论吸收状态或工程规范。四个新增 Lean 共 679 行，四个 Scribe 共 144 行，共 23 个公共声明与 23 个 `StatementSource.FromLean()` 绑定。基础理论的末尾原有一个未闭合的显示数学块，本次追加先补齐其闭合符号，再开始本节；既有文字与公式均保留。

参考入口：
- https://arxiv.org/abs/2306.08317
- https://arxiv.org/abs/2606.09096
- Mathlib pin: `Mathlib/MeasureTheory/Measure/Prokhorov.lean`, `ProbabilityMeasure.lean`, `Group/Convolution.lean`, `Integral/Prod.lean`。

---

## [PR #6114 continuation] INTEGER_LI_NEGATIVE_TYPE_AND_SCHOENBERG_EVOLUTION

日期：2026-09-07。本次从 `61d71eff45e0632bac5210e763a42f0d50bad02a` 继续上一节。新增三个 Lean 真源及三个对应 Scribe：`FiniteGaussianSchoenberg`、`GeometricLiNegativeType`、`LiCurvatureSchoenbergSemigroup`。上一节已经构造共同圆周测度和从指数正定性到实际半群的接口；本节从原 Li 几何能量证明所需指数正定性，消除这一独立前提。数学推导和候选证明源码已完成，本轮未执行 Lean 内核或 Scribe 编译。

### 1. 使用已有定义的整数 cocycle

原定义保持为 `geometricPolynomial n z = sum_(j<n) z^j` 及 `reconstructedLi sigma a n = a integral |geometricPolynomial n|^2 dsigma`。新增整数延拓

\[
b_n(z)=\begin{cases}n,&z=1,\\(z^n-1)/(z-1),&z\ne1,\end{cases}\qquad n\in\mathbb Z.
\]

`integerGeometric_nat` 证明自然数分支与原多项式逐点相等；没有引入另一套 Li 系数。`integerGeometric_add` 证明

\[
b_{m+n}(z)=b_m(z)+z^m b_n(z).
\]

由此得到负索引公式、恒等点处连续性，以及对所有整数 m,n 和全部圆周点的精确距离式

\[
|b_m(z)-b_n(z)|^2=|\mathrm{geometricPolynomial}_{|m-n|}(z)|^2.
\]

z=1 始终保留，此时距离正是 (m-n)^2。无需无原子性、跳跃总质量有限或次二次增长前提。有限原子诊断只用于重放这些代数等式，源码的陈述是全整数、全圆周。

### 2. 从原测度构造 Gram，推导条件负定性

对任意有限圆周 Borel 测度 sigma、非负 a，以及任意有限整数样本 n_i，定义实际积分矩阵

\[
G_{ij}=a\int\langle b_{n_i}(z),b_{n_j}(z)\rangle_{\mathbb R}\,d\sigma(z).
\]

这里复数被视作实内积空间。`geometricLiGram_quadratic` 通过有限和与积分换序证明

\[
x^T Gx=a\int\left|\sum_i x_i b_{n_i}(z)\right|^2d\sigma(z),
\]

从而 G 正半定。`geometricLiGram_distance` 再证明同一个矩阵满足

\[
G_{ii}+G_{jj}-2G_{ij}=L_{|n_i-n_j|},\qquad L_n=\mathrm{reconstructedLi}(\sigma,a,n).
\]

因此当实系数满足 sum_i x_i=0 时，`reconstructed_li_zero_sum_identity` 给出

\[
\sum_{i,j}x_i x_jL_{|n_i-n_j|}
=-2a\int\left|\sum_i x_i b_{n_i}(z)\right|^2d\sigma(z)\le0.
\]

条件负定性由这个具体积分得出，未作为输入。样本可以有负索引、重复索引或为空；测度可以不归一化甚至为零。零和条件在公共陈述中明确保留。复系数的指数正定性在下一步单独证明。

### 3. 本路线所需的 forward Schoenberg 已有证明源码

`FiniteGaussianSchoenberg` 只依赖 Mathlib。对任意有限实正半定矩阵 G，复系数意义下的矩阵

\[
\left[e^{-t(G_{ii}+G_{jj}-2G_{ij})}\right]_{ij}
\]

在每个 t>=0 都正半定。证明使用钉版 Mathlib 的 Schur product theorem：每个逐项幂 G^(Hadamard k) 都正半定，因此非负 factorial 权重的有限和保持正性。逐项标量指数级数收敛后，对每个有限二次型取极限，得到逐项 exp(2t G) 的正性。接着使用精确因式分解

\[
e^{-t(G_{ii}+G_{jj}-2G_{ij})}
=e^{-tG_{ii}}\,e^{2tG_{ij}}\,e^{-tG_{jj}}
\]

作对角合同变换。实到复的标量扩张通过实际 G=B^T B 分解完成，因此结论检测所有复系数向量，而非只检测实部。这里始终是逐项指数，不是谱意义的矩阵指数。

此结果是经典 Schoenberg 定理的有限 Gram 前向形式。经典结论及其 Hilbert Gaussian 背景可参照 J.C. Guella, *On Gaussian kernels on Hilbert spaces and kernels on hyperbolic spaces*, Journal of Approximation Theory 279 (2022), 105765, DOI 10.1016/j.jat.2022.105765。本轮没有主张新的 Gaussian 正性定理，也没有把一般条件负定核到 Hilbert 嵌入的逆构造计入完成范围。这里的 Li 核已经由上一节的实际 G 明确实现，因此不需要该一般逆构造。

`reconstructed_li_exponential_posSemidef` 把这个定理应用到同一个积分 G，得到 exp(-t L_|n_i-n_j|) 的全有限样本正性。它无需另外提供 Schoenberg、条件负定性、指数正性或 Hilbert 距离表示。

### 4. 原曲率输入构造实际概率演化和全部卷积根

主定理 `normalized_curvature_probability_evolution` 的输入只有：c(0)=1、全部原曲率 Toeplitz 矩阵正半定、L(0)=0、L(1)>=0，以及原始二阶递推

\[
L_{n+1}-2L_n+L_{n-1}=2L_1\Re c_n\quad(n\ge1).
\]

前一轮的 `normalized_curvature_reconstruction` 构造同一个曲率概率测度 sigma，重建全部原 L_n。本轮的实际 Gram 指数正性填入前一轮的半群构造，从而得到唯一的概率演化 rho_t，满足

\[
\widehat\rho_t(n)=e^{-tL_{|n|}},\qquad
\rho_0=\delta_1,\qquad \rho_{s+t}=\rho_s*_m\rho_t,
\]

且 t |-> rho_t 在实际概率测度弱拓扑中连续。没有给正定性换标签，旧接口中的独立指数正性参数在此最终定理中已由证明消除。曲率测度 sigma 与演化测度 rho_t 仍是两个不同对象。

`semigroup_probability_roots` 还给出每个正整数 k 的实际概率卷积根：取 nu=rho_(t/k)，证明从 delta_1 出发 k 次实际乘法卷积得到 rho_t。k=0 被明确排除，t=0 仍被覆盖。主定理同时返回这一结论，无穷可分性没有只作为自然语言标签。

本节无需上一轮用于排除 Cayley 边界质量的次二次增长条件。若 sigma=delta_1，L_n=a n^2，其 Gaussian 型指数同样得到合法概率半群。边界原子是否应在实际 zeta 的谱识别中排除，是另一个算术问题。

### 5. 新的跨账号 canonical Li 来源与仍需证明的算术连接

本轮检索发现 `fkst-loning-s-chrono-macbook-pro[bot]` 的 PR #6172，回读时 open、未合并，head `04104c13633054227c697d2b1234e133b377865d`。实际回读 `Zeros/Endpoints/CanonicalLiLocalExpansion.lean`，blob `0fb04eb79f87389016b51af25cdf6078d5616b7c`：它从实际 `xiReading` 的高阶导数定义 canonicalLiCoefficient，证明全部阶数的局部生成展开及首系数正性。其作者报告的编译不是本轮执行的验证。

因此，先前“canonical Li 定义尚无来源”的描述应按版本修订：当前已有这条在途候选真源。这里没有抄写该定义，也没有把未合并文件默默放进本分支的 import closure。它的局部解析展开仍未提供 RH 与全序列非负性的等价，或归一化实际曲率在全部阶数上的正性。

`normalized_curvature_quadratic_bound` 另从同一个概率表示证明全序列界

\[
0\le L_n\le L_1 n^2.
\]

证明只使用原几何和的模长不超过 n，再对质量为一的 sigma 积分。它不等于上一节用于排除恒等点的次二次渐近，因为 quadratic upper bound 允许非零 n^2 项。

这一界提示了与 #6172 的更直接解析接点，以下仍为纸面推导，未计入本轮 Lean 定理。若将 L 识别为该 canonical 序列，则 G(z)=sum_(n>=0) L_(n+1) z^n 由二次界在单位圆盘内正规收敛。设 F(z)=xiReading(1/(1-z))，它在同一圆盘全纯。#6172 的局部展开给出 F'=G F 在零附近成立；全纯恒等定理可把等式延到整个圆盘。F(0)=xiReading(1)=1/2 非零；全纯方程 F'=G F 不允许有限阶零点，因为导数使零点阶数减一，而右侧的阶数不会下降。因此这条路线可把 canonical 曲率的全部 Toeplitz 正性直接转成 Re(s)>1/2 的实际无零点结论，再用反射处理另一侧。

所需新 Lean 义务是正规收敛、实际复合函数的全域全纯性、局部识别的恒等延拓及零阶排除。这里尚未实现这些步骤，且 canonical 全阶曲率正性本身依然是未证明的算术条件；二次界没有自动证明它。该路线可以减少单独把完整 Li 判据作为外部假设的需要，而不是增加另一份同名的 canonical 系数定义。

Nakamura–Suzuki 的 arXiv:2306.08317 使用实际 g_zeta 的实线无穷可分分布判据；Suzuki 的 arXiv:2606.09096 继续研究实际 screw 核与 Weil 形式。本轮仅核对其主要记录和定位，没有把当前圆周 rho_t 等同于这些实线分布，也没有重新证明两篇论文的完整结果。下一项应使用共享 canonicalLiCoefficient 来源，把真实算术曲率、递推和零点测度识别接到本节已完成的概率分析链上。黄金周期观测丢失的尺度层数也不会被圆周半群自动恢复。

### 6. 执行证据和形式化状态

新增三个 Lean 共 579 行，三个 Scribe 共 144 行，27 个公共声明与 27 个 `StatementSource.FromLean()` 绑定。源码数学审查、注释/字符串感知括号检查和声明匹配已执行。当前运行环境没有 Lean、Lake 或 dotnet；本轮没有得到 elaboration、内核接受、传递公理报告或 Scribe emission。公共端点以及依赖的上一轮源码仍须由钉版工具链检查。未引入自定义 axiom、sorry、admit 或 native_decide。

seed 20260907 的 Fraction/有理复数诊断执行了：1575 项整数 cocycle、1575 项逐点距离、105 项绝对索引能量、48 个原始有限测度、711 项积分 Gram 距离、384 项积分 Gram 二次型、384 项精确零和负型恒等式、384 项复系数负型复核。60 个在 t=k log(2) 上具有精确有理指数值的 Gaussian 矩阵通过 684 个全部主子式检查及 180 个复系数二次型检查；48 个 Schur 级数部分和通过 312 个主子式检查。实际两点概率族通过 833 项卷积矩与 36 项卷积根检查。另有 416 项归一化全序列二次界和 624 项零尺度能量检查。空载体、零测度、零尺度、恒等点原子和重复索引均被覆盖。四个负对照区分逐项非负与正定、缺失零和约束、负尺度和负时间。

完整诊断已重跑且结果逐字节一致。诊断脚本 SHA-256：`c8f0b33e3a3b0a4c4f9a36ab56e4a64fc1e474d511860dcc48d32fac2edb1595`。这些是同一作者的第二实现检查，未执行任意实参数指数的数值证明，也不是内核证明、独立审稿或 RH 数值证据。原理论文字和旧 Lean 均保留；本节只是同一理论卷的追加。
