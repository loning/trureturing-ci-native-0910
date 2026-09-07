# 动力接口—余量演算
## ——商下降、carry、交换子流、预测闭包、记忆与因果查询的统一形式理论

**版本：v1.0，2026-08-22**

---

## 摘要

本文把仓库近期分别出现于概念动力学、量子观察者、有限记忆、Hilbert 残余塔、因果查询与负底黄金进制前沿中的结构，压缩为一个共同问题：

> 给定完整状态、观察接口与动力学，动力学何时能在观察者所见的商空间上良定义？若不能，缺失部分应如何分类、度量与修复？

核心对象是三元组

\[
\mathfrak I=(X,q,F),
\]

其中 \(X\) 是完整状态空间，\(q:X\to B\) 是观察接口，\(F:X\to X\) 是更新。本文证明：在有效像上，以下陈述等价：动力学沿 \(q\) 精确下降；\(q\) 的核关系被 \(F\) 保持；不存在 carry witness；一步未来读数由当前读数唯一决定。有限系统中，这还等价于读数函数代数对 Koopman 拉回闭合，以及有限未来词精化在当前深度稳定。

在线性与量子实例中，同一缺陷变成块矩阵的交叉项。若 \(P\) 是可见投影、\(Q=I-P\)，则

\[
[P,T]=PTQ-QTP.
\]

其中 \(PTQ\) 是隐藏方向对下一步可见读数的影响，正是线性化的一步 carry；\(QTP\) 是可见方向向隐藏余量的泄漏。对自伴生成元，两者互为伴随，因而一侧消失即两侧同时消失。对 Hamiltonian 流，投影事件概率的导数

\[
\frac{d}{dt}\operatorname{Tr}(\rho_tP)
=
\operatorname{Re}\!\left(i\operatorname{Tr}(\rho_t[H,P])\right)
\]

是接口缺陷的无穷小通量。

本文进一步建立：

1. 有限未来词塔是 carry 的规范最小修复；
2. 最小预测商是当前读数核中最大的前向不变等价关系；
3. 其对偶是包含当前读数代数的最小动力学不变可观测代数；
4. 随机系统中的对应条件是强 lumpability，TV 缺陷给出任何近似下降的不可突破误差下界；
5. 有限确定性预测核在线性化后分解为幂零暂态与可逆周期核；
6. 因果观察、干预与反事实是同一查询商理论中逐层收缩的 kernel；
7. 无限维或超限观察塔必须区分强完成与一致完成，残余维数本身不能作为完成进度；
8. 当前 negative-base-\(\varphi\) 三叉戟前沿的剩余问题可精确重写为一个相位接口上的两值 gap 因子化命题。

本文是单一 Markdown 理论稿。除明确列出的仓库 Lean 锚点外，新增统一定理均为本文给出的 paper-level 证明，不声称已经 Lean 闭合。

---

# 0. 真值层级、符号与非主张

## 0.1 真值层级

本文使用四种状态标签：

- **定义**：保守引入记号；
- **本文定理**：在本文中给出数学证明，但不声称仓库已有 Lean proof term；
- **Lean 锚点**：仓库已有机器证明，本文只抽取其结构含义；
- **条件命题／路线**：依赖尚未闭合的桥，不得当作已证结论。

## 0.2 基本符号

给定集合或类型 \(X,B\)：

\[
q:X\to B
\]

称为接口。其核关系为

\[
x\sim_q y
\iff
q(x)=q(y).
\]

为避免非满射接口在像外产生任意延拓，定义有效像：

\[
B_q:=\operatorname{Im}(q),
\qquad
\widehat q:X\twoheadrightarrow B_q.
\]

后文所有“唯一下降”均指向有效像上的唯一性。

## 0.3 非主张

本文不主张：

1. carry、交换子、因果混杂与量子退相干在物理本体上完全相同；本文只证明它们共享同一类**接口下降障碍**；
2. 任意非交换性都来自观察不完备；
3. 所有量子不可逆性都只是访问权缺陷；仓库现有定理给出的是一个显式有限维反模型；
4. 预测完成等于自描述完成；
5. 本文推进或证明黎曼假设；
6. 当前 negative-base-\(\varphi\) 主定理已经闭合；本文只重新定位其最后余量。

---

# 1. 接口不是状态压缩，而是目标相对的商

## 定义 1.1（接口核）

\[
K_q:=\{(x,y)\in X^2:q(x)=q(y)\}.
\]

接口保留的不是“多少字节”，而是哪些状态对仍可区分。两个不同编码只要具有相同核，便在纯确定性目标因子化意义下表达同一个观察能力。

## 定义 1.2（目标充分性）

对目标 \(T:X\to Y\)，称 \(q\) 对 \(T\) 充分，若存在

\[
\overline T:B_q\to\operatorname{Im}(T)
\]

满足

\[
T=\overline T\circ\widehat q.
\]

## 定理 1.1（核判据）

以下等价：

\[
T\text{ 沿 }q\text{ 因子化};
\]

\[
K_q\subseteq K_T;
\]

\[
q(x)=q(y)\Longrightarrow T(x)=T(y).
\]

### 证明

若 \(T=\overline T\circ\widehat q\)，则相同 \(q\)-值经同一 \(\overline T\) 得到相同 \(T\)-值。反向定义

\[
\overline T(\widehat q(x)):=T(x).
\]

核包含保证该定义与代表元无关；有效像满射保证唯一性。\(\square\)

## 推论 1.1（充分性只对目标成立）

一个接口可能对决策目标充分，却对完整 payoff profile 不充分；可能对单世界干预边缘充分，却对跨世界 joint 不充分；可能对每个固定有限时间窗充分，却对全部未来不充分。

因此“观察者完整”必须写出目标族，不能作为无下标形容词使用。

---

# 2. 精确动力学下降与 carry 的完全等价

给定更新

\[
F:X\to X.
\]

## 定义 2.1（精确下降）

称 \(F\) 沿接口 \(q\) 精确下降，若存在唯一

\[
\overline F:B_q\to B_q
\]

使交换方块成立：

\[
\boxed{
\widehat q\circ F
=
\overline F\circ\widehat q.
}
\]

## 定义 2.2（carry witness）

\[
\operatorname{Carry}(q,F)
:=
\{(x,y):q(x)=q(y),\ q(Fx)\neq q(Fy)\}.
\]

它表示当前接口把 \(x,y\) 合并，但下一步又要求区分它们。

## 定理 2.1（动力接口基本等价定理）

以下等价：

1. \(F\) 沿 \(q\) 精确下降；
2. \(K_q\) 对 \(F\) 前向不变：
   \[
   (x,y)\in K_q\Longrightarrow(Fx,Fy)\in K_q;
   \]
3. \(\operatorname{Carry}(q,F)=\varnothing\)；
4. 下一步读数 \(q\circ F\) 沿 \(q\) 因子化。

### 证明

(1) 推出 (2)：若 \(q(x)=q(y)\)，则

\[
q(Fx)=\overline F(qx)=\overline F(qy)=q(Fy).
\]

(2) 与 (3) 只是同一命题的否定形式。

(2) 推出 (1)：定义

\[
\overline F(\widehat q(x)):=\widehat q(Fx).
\]

前向不变性保证与代表元无关；满射给出唯一性。

(1) 与 (4) 的等价由定理 1.1 立即得到。\(\square\)

## Lean 锚点 2.1

仓库定理

`D5/S3/ConceptDynamics/Dialectics/ExactDescentNoCarry.exact_descent_has_no_carry`

已经机器证明“精确交换方块排除 carry witness”的方向。本文定理 2.1 补齐其有效像上的反向构造，并把它提升为统一核判据。

## 原理 2.1（carry 不是神秘额外量）

carry 不是附加到动力学上的新实体；它正是交换方块无法填写时留下的见证：

\[
\boxed{
\text{carry}
=
\text{failure of descent}.
}
\]

---

# 3. 有限未来词塔：carry 的规范最小修复

一次 carry 的直接修复不是猜测隐藏本体，而是把实际需要的下一步读数加入接口。

## 定义 3.1（有限未来词接口）

对 \(n\in\mathbb N\)，定义

\[
q^{[n]}(x)
:=
\bigl(q(x),q(Fx),\ldots,q(F^n x)\bigr).
\]

其核为

\[
K_n
:=
K_{q^{[n]}}
=
\bigcap_{j=0}^{n}(F^j\times F^j)^{-1}K_q.
\]

于是

\[
K_{n+1}\subseteq K_n.
\]

## 定理 3.1（一步修复的普适性质）

接口

\[
q^{[1]}=(q,q\circ F)
\]

是同时保留当前读数并决定下一步读数的最粗接口。

更精确地，若 \(r:X\to C\) 且存在 \(a,b\) 使

\[
q=a\circ r,
\qquad
q\circ F=b\circ r,
\]

则

\[
q^{[1]}=(a,b)\circ r.
\]

### 证明

逐点代入即可：

\[
q^{[1]}(x)
=(a(r(x)),b(r(x))).
\]

故任意完成这两个任务的接口都必须至少区分 \(q^{[1]}\) 所区分的状态。\(\square\)

## 定理 3.2（有限窗最小充分性）

\(q^{[n]}\) 是对目标族

\[
\{q,q\circ F,\ldots,q\circ F^n\}
\]

同时充分的最粗接口。

### 证明

将定理 3.1 的二元乘积替换为有限 dependent product。\(\square\)

## 定理 3.3（稳定即下降）

以下等价：

\[
K_n=K_{n+1};
\]

\[
K_n\text{ 对 }F\text{ 前向不变};
\]

\[
F\text{ 沿 }q^{[n]}\text{ 精确下降}.
\]

### 证明

\(K_n\) 已经记录第 \(0\) 至 \(n\) 步。要求 \(F\)-不变，只额外要求第 \(n+1\) 步相等，恰好是 \(K_{n+1}\) 不再严格细化。再应用定理 2.1。\(\square\)

## 定义 3.2（全未来核）

\[
K_\infty
:=
\bigcap_{n\ge0}K_n
=
\{(x,y):\forall n,\ q(F^nx)=q(F^ny)\}.
\]

## 定理 3.4（最小预测完成）

\(K_\infty\) 是包含于 \(K_q\) 的最大 \(F\)-不变等价关系。因此

\[
Z_q:=X/K_\infty
\]

是保留当前读数并使动力学下降的最粗精化。

### 证明

首先，若 \(xK_\infty y\)，则对所有 \(n\)，

\[
q(F^n(Fx))=q(F^{n+1}x)=q(F^{n+1}y)=q(F^n(Fy)),
\]

故 \(FxK_\infty Fy\)。

设 \(R\subseteq K_q\) 为任意 \(F\)-不变等价关系。若 \(xRy\)，反复使用不变性得 \(F^nx\,R\,F^ny\)；再由 \(R\subseteq K_q\) 得所有未来读数相等，因此 \(R\subseteq K_\infty\)。\(\square\)

## 定理 3.5（有限稳定界）

若 \(X\) 有限，则存在最小 \(m_*\) 使

\[
K_{m_*}=K_{m_*+1}=K_\infty,
\]

且

\[
\boxed{
 m_*
\le
|X/K_\infty|-|X/K_q|
\le
|X|-|\operatorname{Im}(q)|.
}
\]

### 证明

每次严格细化都使等价类数至少增加一，而类数从 \(|\operatorname{Im}(q)|\) 起步、至多达到 \(|X|\)。一旦不再严格细化，由定理 3.3 得前向不变，此后永久稳定。\(\square\)

---

# 4. 对偶表述：最小动力学不变可观测代数

本节令 \(X\) 为有限集合，\(\mathbb K\) 为至少含两个元素的域，通常取 \(\mathbb C\)。

## 定义 4.1（接口代数）

\[
\mathcal A_q
:=
\{f\circ q:f:B_q\to\mathbb K\}
\subseteq
\mathbb K^X.
\]

它恰由所有在 \(K_q\)-类上常值的函数组成。

定义 Koopman 拉回：

\[
F^*g:=g\circ F.
\]

## 定理 4.1（下降—代数闭合对偶）

以下等价：

1. \(F\) 沿 \(q\) 下降；
2. \(F^*\mathcal A_q\subseteq\mathcal A_q\)；
3. 每个当前可观测量的下一步值仍是当前接口的函数。

### 证明

若 \(qF=\overline Fq\)，则

\[
F^*(f\circ q)
=f\circ q\circ F
=f\circ\overline F\circ q\in\mathcal A_q.
\]

反向，取足以分离 \(B_q\) 中点的函数族。若 \(q(x)=q(y)\)，闭合性令所有函数在 \(q(Fx),q(Fy)\) 上取同值，故两点相等。应用定理 2.1。\(\square\)

## 定义 4.2（深度代数）

\[
\mathcal A_n
:=
\mathcal A_{q^{[n]}}.
\]

## 定理 4.2（代数递推）

\[
\boxed{
\mathcal A_{n+1}
=
\operatorname{Alg}\bigl(\mathcal A_0\cup F^*\mathcal A_n\bigr).
}
\]

这里右侧是在 \(\mathbb K^X\) 中生成的最小含幺函数代数。

### 证明

\(\mathcal A_0\) 区分当前读数，\(F^*\mathcal A_n\) 区分第 \(1\) 至 \(n+1\) 步读数。二者共同诱导的等价关系是

\[
K_q\cap(F\times F)^{-1}K_n=K_{n+1}.
\]

有限集合上，含幺函数代数由其点分离关系唯一决定。\(\square\)

## 推论 4.1（最小不变代数）

\[
\mathcal A_\infty
:=
\bigcup_n\mathcal A_n
\]

在有限系统中稳定为包含 \(\mathcal A_q\) 的最小 \(F^*\)-不变含幺代数，并与最小预测商满足

\[
\mathcal A_\infty\cong\mathbb K^{Z_q}.
\]

## Lean 锚点 4.1

仓库定理

`D5/S3/Quantum/Dynamics/LeastInvariantObservableAlgebra.least_invariant_observable_algebra`

已经在有限预测塔实例中机器证明最小稳定可观测代数。本文给出其集合商版本与核关系证明。

---

# 5. 线性接口：carry 变成交叉块

令 \(H\) 为 Hilbert 空间，\(P:H\to H\) 为正交投影，

\[
Q:=I-P,
\qquad
H=V\oplus R,
\quad
V=\operatorname{ran}P,
\quad
R=\operatorname{ran}Q.
\]

令 \(T:H\to H\) 为有界线性算子。

## 定理 5.1（四块分解）

\[
\boxed{
T=PTP+PTQ+QTP+QTQ.
}
\]

其中：

- \(PTP:V\to V\) 是可见内动力学；
- \(QTQ:R\to R\) 是余量内动力学；
- \(PTQ:R\to V\) 是隐藏对下一步可见量的影响；
- \(QTP:V\to R\) 是可见状态向余量的泄漏。

## 定理 5.2（线性下降判据）

把接口取为 \(q=P:H\to V\)。以下等价：

1. 存在线性 \(\overline T:V\to V\) 使
   \[
   PT=\overline TP;
   \]
2. \(PTQ=0\)；
3. \(PTx\) 只依赖于 \(Px\)。

此时唯一下降为

\[
\overline T=PT|_V.
\]

### 证明

若 \(PT=\overline TP\)，右乘 \(Q\) 得 \(PTQ=\overline TPQ=0\)。反向由

\[
PT=PT(P+Q)=PTP
\]

并取 \(\overline T=PT|_V\)。\(\square\)

## 定理 5.3（不变、余不变与 reducing）

\[
T(V)\subseteq V
\iff
QTP=0,
\]

\[
T(R)\subseteq R
\iff
PTQ=0,
\]

而

\[
V\text{ reducing for }T
\iff
PTQ=QTP=0.
\]

注意：**一步可见下降只要求 \(PTQ=0\)**；它不要求可见方向永不泄漏到隐藏方向。若泄漏随后反馈回来，多步预测仍可能失败，这正是未来词塔继续精化的原因。

## 定理 5.4（交换子就是双向交叉块）

\[
\boxed{
[P,T]=PTQ-QTP.
}
\]

因此

\[
[P,T]=0
\iff
PTQ=QTP=0.
\]

### 证明

\[
PT-TP
=PT(P+Q)-(P+Q)TP
=PTQ-QTP.
\]

两项的定义域和值域互换，故同时为零恰为 reducing。\(\square\)

## 定理 5.5（Hilbert–Schmidt 缺陷恒等式）

若 \(H\) 有限维，则

\[
\boxed{
\|[P,T]\|_{HS}^2
=
\|PTQ\|_{HS}^2+
\|QTP\|_{HS}^2.
}
\]

若 \(T=T^*\)，则

\[
PTQ=(QTP)^*,
\]

从而

\[
\boxed{
\|[P,T]\|_{HS}^2
=2\|PTQ\|_{HS}^2
=2\|QTP\|_{HS}^2.
}
\]

### 证明

\(PTQ\) 与 \(QTP\) 在 Hilbert–Schmidt 内积下正交，因为交叉项含 \(PQ=QP=0\)。自伴情形由取伴随直接得到。\(\square\)

## 最深解释 5.1

集合论 carry 与线性交换子不是比喻关系，而是以下精确对应：

\[
\boxed{
\begin{aligned}
q(x)=q(y),\ q(Tx)\neq q(Ty)
&\longleftrightarrow
PTQ\neq0,\\
\text{可见方向泄入余量}
&\longleftrightarrow
QTP\neq0,\\
\text{双向接口完全闭合}
&\longleftrightarrow
[P,T]=0.
\end{aligned}
}
\]

---

# 6. 未读测量：算子空间中的正交接口

令 \((P_i)_{i\in I}\) 为有限完备正交投影族，定义 pinching／未读测量通道

\[
\mathcal D(X):=\sum_iP_iXP_i.
\]

## Lean 锚点 6.1

仓库定理

`D5/S3/Observer/Conditioning/UnreadStateOrthogonalProjection.unread_state_orthogonal_projection`

已经机器证明：

\[
\mathcal D^2=\mathcal D,
\]

\[
\langle\mathcal D(X),Y\rangle_{HS}
=
\langle X,\mathcal D(Y)\rangle_{HS},
\]

\[
\operatorname{ran}\mathcal D
=
\{X:\forall i\neq j,\ P_iXP_j=0\},
\]

以及

\[
X=\mathcal D(X)+(I-\mathcal D)(X),
\]

\[
\|X\|_{HS}^2
=
\|\mathcal D(X)\|_{HS}^2
+
\|(I-\mathcal D)(X)\|_{HS}^2.
\]

因此 \(\mathcal D\) 不是“像投影”，而是在 Hilbert–Schmidt 算子空间中真正的正交投影。

## 定义 6.1（通道级 carry）

对线性演化生成元或一步超算子 \(\mathcal L\)，定义

\[
\mathcal C_{\mathrm{in}}
:=
\mathcal D\mathcal L(I-\mathcal D),
\]

\[
\mathcal C_{\mathrm{out}}
:=
(I-\mathcal D)\mathcal L\mathcal D.
\]

前者是未读相干余量对下一步可见块的影响，后者是可见块向相干余量的生成。

## 定理 6.1（通道交换子分解）

\[
\boxed{
[\mathcal D,\mathcal L]
=
\mathcal C_{\mathrm{in}}-
\mathcal C_{\mathrm{out}}.
}
\]

并且：

\[
\mathcal L\text{ 沿 }\mathcal D\text{ 一步下降}
\iff
\mathcal C_{\mathrm{in}}=0;
\]

\[
\operatorname{ran}\mathcal D\text{ 对 }\mathcal L\text{ 不变}
\iff
\mathcal C_{\mathrm{out}}=0;
\]

\[
[\mathcal D,\mathcal L]=0
\iff
\text{可见块与相干余量均被分别保持}.
\]

### 证明

将定理 5.2–5.4 应用于算子 Hilbert 空间中的投影 \(\mathcal D\)。\(\square\)

## 推论 6.1（记录丢弃与动力学不闭合是两个问题）

即使 \(\mathcal D\) 本身是完美正交投影，也不代表后续动力学在其像上闭合。测量接口的几何正确性与动力学自然性必须分开审计。

---

# 7. Hamiltonian 流：交换子是接口缺陷的无穷小通量

令

\[
U_t=e^{-itH},
\qquad
\rho_t=U_t\rho U_t^*,
\]

其中 \(H=H^*\)，令 \(P=P^2=P^*\) 为事件投影。

## Lean 锚点 7.1

仓库定理

`D5/S3/Quantum/Dynamics/ProjectionProbabilityFlow.projection_probability_flow`

已经机器证明：

\[
p_P(t):=\operatorname{Tr}(\rho_tP)
\]

满足

\[
\boxed{
\frac{d}{dt}p_P(t)
=
\operatorname{Re}\!\left(
 i\operatorname{Tr}(\rho_t(HP-PH))
\right).
}
\]

并且

\[
[H,P]=0
\Longrightarrow
p_P(t)=p_P(0)
\quad\forall t\in\mathbb R.
\]

## 定理 7.1（无穷小 reducing 判据）

在有限维中，以下等价：

\[
[H,P]=0;
\]

\[
[U_t,P]=0\quad\forall t;
\]

\[
P\text{ 与 }Q=I-P\text{ 的两块在整个 Hamiltonian 流下分别不变}.
\]

### 证明

\([H,P]=0\) 时指数函数与 \(P\) 交换。反向对 \([U_t,P]=0\) 在 \(t=0\) 求导，得到 \(-i[H,P]=0\)。\(\square\)

## 原理 7.1（单态零导数不等于接口闭合）

某个特定 \(\rho,t\) 上

\[
\operatorname{Tr}(\rho_t[H,P])=0
\]

只表示该状态在该时刻的净通量抵消；它不推出 \([H,P]=0\)。结构闭合要求对全部状态成立，等价于算子交换子本身为零。

## 统一句 7.1

\[
\boxed{
\text{deterministic carry}
\rightarrow
\text{linear cross block}
\rightarrow
\text{Hamiltonian commutator}
\rightarrow
\text{probability flux}.
}
\]

这是同一接口缺陷从离散到线性、再到无穷小动力学的逐级表示。

---

# 8. 随机动力学：强 lumpability 与定量 carry

令 \(K(x,\cdot)\) 为 \(X\) 上 Markov kernel，\(q:X\to B\)。记

\[
q_*K_x
\]

为从状态 \(x\) 出发一步后观察到的 \(B\)-分布。

## 定义 8.1（强 lumpability）

\[
q(x)=q(y)
\Longrightarrow
q_*K_x=q_*K_y.
\]

## 定理 8.1（随机下降定理）

以下等价：

1. 存在有效像上的 Markov kernel \(\overline K\) 满足
   \[
   q_*K_x=\overline K_{q(x)};
   \]
2. \(K\) 对 \(q\) 强 lumpable；
3. 一步观察 law 只依赖当前观察值。

### 证明

与定理 2.1 相同，只把确定性下一状态替换为概率测度，并按 fiber 定义 \(\overline K\)。\(\square\)

## 定义 8.2（TV carry 缺陷）

\[
\delta_q(K)
:=
\sup_{q(x)=q(y)}
\operatorname{TV}(q_*K_x,q_*K_y).
\]

于是

\[
\delta_q(K)=0
\iff
K\text{ 对 }q\text{ 强 lumpable}.
\]

## 定理 8.2（任何近似下降的误差下界）

定义最佳 Markov 下降误差

\[
\varepsilon_q^*(K)
:=
\inf_{\overline K}
\sup_x
\operatorname{TV}
\bigl(q_*K_x,\overline K_{q(x)}\bigr).
\]

则

\[
\boxed{
\frac12\delta_q(K)
\le
\varepsilon_q^*(K).
}
\]

若每个 fiber 选定代表元，则还有

\[
\varepsilon_q^*(K)
\le
\delta_q(K).
\]

### 证明

对同一 fiber 中任意 \(x,y\)，三角不等式给出

\[
\operatorname{TV}(q_*K_x,q_*K_y)
\le
e_x+e_y,
\]

故至少一个误差不小于该 pair 距离的一半。取上确界与下确界得到下界。上界取每个 fiber 的代表分布作为 \(\overline K\)。\(\square\)

## 定理 8.3（目标后处理收缩）

对任意可测后处理 \(r:B\to C\)，定义固定 source fiber 上的后处理缺陷：

\[
\delta_q^{r}(K)
:=
\sup_{q(x)=q(y)}
\operatorname{TV}
\bigl(r_*q_*K_x,r_*q_*K_y\bigr).
\]

则

\[
\boxed{
\delta_q^{r}(K)
\le
\delta_q(K).
}
\]

### 证明

全变差距离在 Markov 后处理下不增加。\(\square\)

## 警告 8.1（source coarsening 没有单调律）

把 source 接口从 \(q\) 改为 \(r\circ q\) 会同时扩大待比较 fiber、又压缩目标分布，两个效应方向相反。因此总体缺陷可能增大、减小或被完全掩盖。不得把数据处理不等式误用于 source coarsening。

---

# 9. 组合律、隐藏 carry 与规范修复

## 定理 9.1（下降的组合）

若

\[
qF=\overline Fq
\]

且

\[
r\overline F=\widetilde F r,
\]

则

\[
(rq)F=\widetilde F(rq).
\]

### 证明

交换方块复合。\(\square\)

## 反例 9.1（粗接口可以隐藏 carry）

取

\[
X=\{a,b,c\},
\]

\[
q(a)=q(b)=0,
\qquad
q(c)=1,
\]

以及

\[
F(a)=a,
\qquad
F(b)=c,
\qquad
F(c)=c.
\]

则 \((a,b)\) 是 \(q\) 的 carry witness，因为

\[
q(a)=q(b),
\qquad
q(Fa)=0\neq1=q(Fb).
\]

但若 \(r:\{0,1\}\to\{*\}\) 为常值映射，则 \(r\circ q\) 总能下降。

所以

\[
(rq)\text{ 可下降}
\not\Rightarrow
q\text{ 可下降}.
\]

粗接口的“闭合”可能只是把缺陷目标一起删除。

## 定义 9.1（隐藏 carry）

若 \(rq\) 可下降而 \(q\) 不可下降，则称 carry 被后处理 \(r\) 隐藏。

## 原理 9.1（修复三分）

面对 carry 有三种数学上不同的处理：

1. **源接口精化**：加入未来词、记忆或新传感器；
2. **目标压缩**：只保留能沿当前接口下降的后处理；
3. **动力学约束**：修改或控制 \(F\)，使其保持当前 kernel。

三者分别对应“看得更多”“要求更少”“让世界按接口闭合”。它们不能互相冒充。

---

# 10. 记忆不是历史副本，而是最小闭合状态

## 定义 10.1（预测记忆）

若接口 \(r:X\to M\) 满足：

1. 当前读数沿 \(r\) 因子化；
2. \(F\) 沿 \(r\) 下降；

则称 \(r\) 是一个精确预测记忆。

## 定理 10.1（最小记忆）

最小预测商

\[
\pi_\infty:X\to Z_q=X/K_\infty
\]

是所有精确预测记忆中的最粗者：对任意 \(r\)，存在唯一

\[
\theta:\operatorname{Im}(r)\to Z_q
\]

使

\[
\pi_\infty=\theta\circ r.
\]

### 证明

若 \(r(x)=r(y)\)，下降性给出 \(r(F^nx)=r(F^ny)\)；当前读数沿 \(r\) 因子化，故全部未来 \(q\)-读数相等，即 \(xK_\infty y\)。应用核判据。\(\square\)

## 推论 10.1（记忆下界）

对有限随机状态 \(X_0\)，任意精确预测记忆 \(M=r(X_0)\) 满足

\[
H(Z_q\mid q(X_0))
\le
H(M\mid q(X_0)).
\]

因此

\[
\boxed{
H(Z_q\mid q(X_0))
}
\]

是从当前读数升级到精确预测状态所需附加信息的规范下界。

## Lean 锚点 10.1

仓库已有有限预测完成、未来 congruence、最小可观测代数等定理。本文把它们统一解释为：

\[
\boxed{
\text{memory}
=
\text{the coarsest refinement that kills all future carry}.
}
\]

---

# 11. 信息分解：每一次精化支付多少新信息

令随机初态为 \(X_0\)，定义

\[
O_n:=q(F^nX_0),
\qquad
W_n:=(O_0,\ldots,O_n).
\]

## 定理 11.1（未来词信息链）

\[
\boxed{
H(W_n)
=H(O_0)
+
\sum_{j=1}^{n}
H(O_j\mid O_0,\ldots,O_{j-1}).
}
\]

### 证明

Shannon chain rule。\(\square\)

## 定义 11.1（第 \(j\) 层 carry 信息）

\[
\Delta_j
:=
H(O_j\mid O_0,\ldots,O_{j-1}).
\]

它不是“系统生成的新熵”的普遍物理断言，而是当前有限读数历史尚不能决定第 \(j\) 步读数时，需要补充的预测信息。

## 定理 11.2（稳定与零条件熵）

若

\[
K_n=K_{n+1},
\]

则对任意初态分布

\[
H(O_{n+1}\mid W_n)=0.
\]

反之，若初态分布在 \(X\) 上满支撑且该条件熵为零，则

\[
K_n=K_{n+1}.
\]

### 证明

稳定时 \(O_{n+1}\) 是 \(W_n\) 的确定函数。反向，有限满支撑下零条件熵意味着每个可达词值对应唯一下一输出，因此相同 \(W_n\) 的状态具有相同 \(O_{n+1}\)。\(\square\)

## Lean 锚点 11.1

仓库定理

`D5/S3/Entropy/Fusion/QuotientFiberDecomposition.quotient_fiber_entropy_decomposition`

机器证明有限 law 的 quotient–fiber 熵分解。本文的动态链把该静态余量沿未来词塔逐层展开。

---

# 12. 有限确定性闭环：幂零暂态与周期预测核

令有限状态更新为

\[
\tau:Y\to Y.
\]

在线性化空间 \(\mathbb C^{(Y)}\) 上定义 transfer operator

\[
T_\tau e_y=e_{\tau(y)}.
\]

## Lean 锚点 12.1

仓库定理

`D5/S3/ObserverMemory/FunctionalGraphs/FiniteFunctionalGraphFittingDecomposition.finite_functional_graph_fitting_decomposition`

已经机器证明：在稳定指数 \(N\) 处，

\[
\mathbb C^{(Y)}
=
\ker T_\tau^N
\oplus
\operatorname{ran}T_\tau^N,
\]

其中

\[
T_\tau|_{\ker T_\tau^N}
\]

幂零，而

\[
T_\tau|_{\operatorname{ran}T_\tau^N}
\]

双射，并在周期点基上表现为置换。

## 推论 12.1（预测完成后的双阶段动力学）

把上述定理应用于最小预测商 \(Z_q\) 上的下降动力学 \(\overline F\)，得到：

\[
\boxed{
\text{minimal predictive dynamics}
=
\text{nilpotent transient distinctions}
\oplus
\text{reversible periodic core}.
}
\]

被幂零部分消灭的不是完整世界状态，而是**在最小预测表示中的暂态坐标**。周期核保存长期可循环的预测差异。

## 原理 12.1（有限性不等于立即退化）

有限系统最终进入周期核，但：

- 周期可能极长；
- 暂态可能极长；
- 周期语义质量可高可低；
- “最终周期”不推出“短期重复”或“低复杂度”。

形式理论只给动力学形态，不替代质量函数。

---

# 13. 约化不可逆性：kernel、访问权与全局可逆性

## Lean 锚点 13.1

仓库定理

`D5/S3/Quantum/Decoherence/ReducedRecordAccessDefect.reduced_irreversibility_is_access_defect`

构造了一个显式 unitary record coupling，满足：

1. 两个输入具有相同对角读数、不同相干项；
2. 写入环境记录后的两个联合状态不同；
3. 对环境取 partial trace 后，两个约化系统状态相同；
4. 不存在只依赖约化状态的恢复函数同时恢复两个联合记录；
5. 对联合系统施加逆 unitary 可精确恢复两个输入。

## 定理 13.1（访问 kernel 解释）

上述不可恢复性完全由 partial trace 接口的非单射性给出：

\[
\rho_{SE}\neq\sigma_{SE},
\qquad
\operatorname{Tr}_E\rho_{SE}
=
\operatorname{Tr}_E\sigma_{SE}.
\]

因此任意只通过 \(\operatorname{Tr}_E\) 的恢复器都必须在这两个输入上给出同一输出。

### 证明

这是定理 1.1 的直接应用：联合状态目标不沿约化接口因子化。\(\square\)

## 边界 13.1

该结论证明“约化不可逆性可以纯粹是访问缺陷”，不证明所有宏观热力学不可逆性、所有开放系统耗散或所有实际测量不可逆性都能被同一有限模型消解。

---

# 14. 因果层级：查询商而不是“更多数据”

令 \(\mathcal M\) 为模型类。给定查询族

\[
\mathcal Q=(Q_i:\mathcal M\to Y_i)_{i\in I},
\]

定义查询画像

\[
E_\mathcal Q(M):=(Q_i(M))_{i\in I}.
\]

## 定义 14.1（查询 kernel）

\[
K_\mathcal Q
:=
\{(M,N):E_\mathcal Q(M)=E_\mathcal Q(N)\}.
\]

## 定理 14.1（识别即 kernel 包含）

目标 \(T:\mathcal M\to Z\) 由查询族 \(\mathcal Q\) 识别，当且仅当

\[
\boxed{
K_\mathcal Q\subseteq K_T.
}
\]

等价地，\(T\) 唯一因子化通过查询商

\[
\mathcal M/K_\mathcal Q.
\]

### 证明

定理 1.1，取状态空间为模型类。\(\square\)

## 定义 14.2（目标因果 residual）

\[
\operatorname{CRes}(\mathcal Q,T)
:=
\{(M,N):E_\mathcal Q(M)=E_\mathcal Q(N),\ T(M)\neq T(N)\}.
\]

于是

\[
T\text{ 可识别}
\iff
\operatorname{CRes}(\mathcal Q,T)=\varnothing.
\]

## 定理 14.2（观察—干预—反事实 kernel 链）

若干预查询族包含空干预的观察 law，反事实查询族包含所有单世界干预边缘，则

\[
\boxed{
K_{\mathrm{cf}}
\subseteq
K_{\mathrm{int}}
\subseteq
K_{\mathrm{obs}}.
}
\]

两个包含都可以严格。

### 证明

加入查询只会增加相等条件，因此 kernel 只能缩小。严格性由标准方向反转反模型与相同单世界边缘、不同 cross-world coupling 的反模型给出。\(\square\)

## 原理 14.1

\[
\boxed{
\text{association}
\neq
\text{intervention}
\neq
\text{counterfactual coupling}.
}
\]

它们可以使用同一种概率记号，但对应不同查询族与不同 kernel。

---

# 15. 有限干预设计就是目标 pair 的 set cover

假设模型类 \(\mathcal M\) 与候选实验集 \(\mathcal E\) 有限。当前证据接口为 \(E_0\)，目标为 \(T\)。

## 定义 15.1（未解决目标 pair）

\[
\mathcal P_T
:=
\{\{M,N\}:E_0(M)=E_0(N),\ T(M)\neq T(N)\}.
\]

每个实验 \(e\in\mathcal E\) 覆盖的 pair 集为

\[
S_e
:=
\{\{M,N\}\in\mathcal P_T:Q_e(M)\neq Q_e(N)\}.
\]

## 定理 15.1（有限实验 cover 判据）

实验子集 \(A\subseteq\mathcal E\) 足以识别 \(T\)，当且仅当

\[
\boxed{
\mathcal P_T
=
\bigcup_{e\in A}S_e.
}
\]

因此最小非自适应实验设计正是集合覆盖问题。

### 证明

加入 \(A\) 后仍未被任何实验分开的 pair，恰是新 evidence kernel 中仍违反 \(K_E\subseteq K_T\) 的 pair。\(\square\)

## 推论 15.1（实验价值是 kernel 缩减，不是数据量）

一个产生大量样本但不切开任何目标 residual pair 的实验，对目标识别价值为零；一个只产生一比特、却切开最后一个 residual pair 的实验具有决定性价值。

---

# 16. kernel、image、coupling、gauge 与 carry 必须分账

## 定义 16.1（五类余量）

对模型／状态到证据的接口，区分：

### 16.1.1 Kernel residual

\[
x\neq y,
\qquad
q(x)=q(y).
\]

它记录接口合并了哪些对象。

### 16.1.2 Carry residual

\[
q(x)=q(y),
\qquad
q(Fx)\neq q(Fy).
\]

它记录当前 kernel 不是动力学 congruence。

### 16.1.3 Image defect

给定形式证据值 \(b\)，问

\[
b\in\operatorname{Im}(q)?
\]

兼容坐标族不一定由真实对象实现。

### 16.1.4 Coupling residual

边缘族 \((\mu_i)\) 已知，但 joint coupling

\[
\Gamma((\mu_i)_i)
\]

不唯一。

### 16.1.5 Gauge residual

不同参数化、坐标或外生变量表示给出相同全部目标查询。它应取商，而不应被误报为经验不确定性。

## 原理 16.1（修复必须对症）

- kernel 太大：增加分离性查询；
- carry 非空：增加记忆、限制动力学或压缩目标；
- image 失败：修正模型类／实现约束；
- coupling 非唯一：加入 cross-world 结构、界或部分识别；
- gauge 非唯一：规范化或取商。

更多样本只改善固定接口上的估计误差，不自动修复上述任一结构缺陷。

---

# 17. Prime-indexed 接口：局部观察、乘积与 gluing

令每个素数 \(p\) 给出局部接口

\[
q_p:X\to B_p.
\]

对有限素数集 \(S\)，定义

\[
q_S=(q_p)_{p\in S},
\qquad
K_S=\bigcap_{p\in S}K_{q_p}.
\]

若 \(S\subseteq T\)，则

\[
K_T\subseteq K_S.
\]

## 定义 17.1（全素数核）

\[
K_{\mathbb P}
:=
\bigcap_pK_{q_p}.
\]

## 定理 17.1（有限局部塔的最小全局商）

全局 prime profile 商

\[
X/K_{\mathbb P}
\]

是所有有限局部接口的共同精化极限：任意能恢复每个 \(q_p\) 的接口都因子化到该商。

### 证明

核为全部局部核的交，应用定理 1.1。\(\square\)

## 警告 17.1（局部一致不等于全局实现）

有限投影族中的每组坐标都可实现，不推出整个无限兼容族位于全局 image。该缺陷属于 image／gluing，而不是 kernel。纯粹继续增加素数读数可能缩小 kernel，却不自动证明逆极限坐标来自一个真实全局对象。

## 原理 17.1（prime-time carry）

若动力学更新在每个有限 \(S\) 上可下降，但不存在与所有投影兼容的全局下降，则障碍位于下降映射族的 gluing，而不是任一局部 carry。需要分别审计：

\[
\text{local descent},
\qquad
\text{transition compatibility},
\qquad
\text{global realization}.
\]

---

# 18. 无限维与超限完成：强完成不等于一致完成

令 \((V_\alpha)\) 为递增闭子空间塔，\(P_\alpha\) 为正交投影，

\[
R_\alpha:=V_\alpha^\perp.
\]

## 定理 18.1（极限残余）

在极限阶段 \(\lambda\)，若

\[
V_\lambda
=
\overline{\bigcup_{\alpha<\lambda}V_\alpha},
\]

则

\[
\boxed{
R_\lambda
=
\bigcap_{\alpha<\lambda}R_\alpha.
}
\]

### 证明

正交补把闭线性生成的上确界变成交。\(\square\)

## Lean 锚点 18.1

仓库定理

`D5/S3/Quantum/Completion/TransfiniteBasisResidualTower.transfinite_basis_residual_tower`

已经机器证明初始良序 Hilbert 基的后继分裂、极限交、每个真初始段的同基数尾部，以及终端残余为零。

## 定理 18.2（强完成）

若

\[
\overline{\bigcup_\alpha V_\alpha}=H,
\]

则对每个固定 \(x\in H\)，

\[
P_\alpha x\to x.
\]

等价地，

\[
\|(I-P_\alpha)x\|\to0.
\]

## 定理 18.3（一致完成障碍）

若每个阶段 \(V_\alpha\neq H\)，则

\[
\boxed{
\|I-P_\alpha\|=1
}
\]

对所有 \(\alpha\) 成立。因此 \(P_\alpha\) 不可能在算子范数中收敛到 \(I\)。

### 证明

真闭子空间的非零正交补中取单位向量 \(r\)，则

\[
(I-P_\alpha)r=r,
\]

给出范数下界 1；正交投影余算子的范数至多 1。\(\square\)

## Lean 锚点 18.2

仓库定理

`D5/S3/Quantum/Completion/InfiniteDimensionalProjectionSeparation.infinite_dimensional_projection_separation`

已经机器证明上述“逐向量完成但算子范数恒距 1”的分离。

## 原理 18.1（维数不是完成进度）

无限维中可能出现

\[
\dim R_\alpha=\dim H
\]

对每个真阶段成立，而终端

\[
R_{\mathrm{terminal}}=0.
\]

因此必须使用：

- 固定目标向量的残余能量；
- 强／弱／范数拓扑；
- target-specific factorization；
- gluing 与 image 条件；

而不能仅凭残余维数判断观察者“还差多少”。

---

# 19. 当前 negative-base-\(\varphi\) 前沿的重新定位

仓库当前已经闭合以下结构：

1. admissible negative prefix 的 core 无限；
2. 可由严格枚举得到真实 core frontier；
3. 连续枚举值构成相邻 core pair；
4. 给定左端点，相邻右端点唯一；
5. phase-enriched trace 与 exact gap phase 等价。

对应 Lean 锚点包括：

- `D5/S1/Words/Expansions/BasePhiNegativePrefixTridentCore.core_infinite_proved`；
- `D5/X_Frontier/BasePhiNegativePrefixTrident.frontier_step_semantics_proved`；
- `D5/S1/Words/Expansions/BasePhiNegativePrefixTridentEdge.frontier_consecutive_core_adjacent`；
- `D5/S1/Words/Expansions/BasePhiNegativePrefixTridentEdge.adjacent_core_point_right_unique`；
- `D5/S1/Words/Expansions/BasePhiNegativePrefixTridentEdge.phase_enriched_core_trace_iff_gap_phase`。

## 定义 19.1（gap 目标）

对 frontier certificate \(c\)，定义

\[
g(n):=c(n+1)-c(n).
\]

定义相位接口

\[
s(n)
:=
\bigl(
\operatorname{phase}(c),
\operatorname{familyLetter}(c,n)
\bigr).
\]

## 条件命题 19.1（剩余核心的因子化形式）

当前两个剩余 provider 的共同核心可写成：存在二值函数

\[
\gamma(s)
=
\begin{cases}
a,&\text{selected letter}=1,\\
b,&\text{selected letter}=0,
\end{cases}
\]

使

\[
\boxed{
g=\gamma\circ s.}
\]

换言之，实际相邻 gap 必须沿“六态相位 + aperiodic Fibonacci 输入位”接口下降。

## 推理 19.1

此前困难可能被描述为：

- 是否存在下一 core 点；
- 下一点是否唯一；
- gap 是否属于 \(\{a,b\}\)；
- F/G/H itinerary 是否正确。

最新证明已经结算前两项。于是最后余量不再是“寻找相邻点”，而是：

\[
\boxed{
\text{证明唯一真实相邻边的长度，只依赖当前相位接口。}
}
\]

这正是定理 1.1／2.1 的目标因子化问题。`PhaseEnrichedCoreTrace` 不是附加装饰，而是该因子化的显式 witness 类型。

## 最小下一步 19.1

要闭合该前沿，最直接的证明目标不是继续证明唯一性，而是构造对每个 \(n\) 的实际相邻边 witness，并证明其 additive 字段：

\[
(c(n+1):\mathbb Z)
=
c(n)+
\begin{cases}
a,&\ell_n=1,\\b,&\ell_n=0.
\end{cases}
\]

一旦该式成立：

\[
\text{PhaseEnrichedCoreTrace}
\Longrightarrow
\text{source-index delta}
\Longrightarrow
\text{six-phase gap stream}
\Longrightarrow
\text{F/G/H sequence reconstruction}.
\]

因此当前主线已经从十五节点链压缩为一个**相位接口下降桥**。

## 边界 19.1

主定理 `negative_prefix_trident_classification` 仍有前沿占位；本文不把上述重新定位冒充最终证明。

---

# 20. 自描述边界：预测完成不推出对角完成

## 定理 20.1（固定状态域上的完全接口）

若 \(q:X\to B\) 单射，则对任意普通目标 \(T:X\to Y\)，\(T\) 沿 \(q\) 因子化。

### 证明

\(K_q\) 为对角关系，故 \(K_q\subseteq K_T\)。\(\square\)

## 原理 20.1（对角逃逸需要类型扩张）

若 \(q\) 已在固定 \(X\) 上单射，却仍声称存在“不可表达对象”，那么缺陷不再位于状态区分，而位于：

- 表示清单 \(g:B\to X\) 非满射；
- 目标语言／对象类型被扩张；
- 自应用产生了原类型之外的新对象；
- realizability 或 admission 拒绝某些形式坐标。

因此必须分开：

\[
\boxed{
\text{state faithfulness}
\neq
\text{representation surjectivity}
\neq
\text{dynamic closure}
\neq
\text{self-description closure}.
}
\]

## Lean 锚点 20.1

仓库定理

`D5/S3/ConceptDynamics/Contracts/FutureObligationIncompleteness.nonfaithful_interface_future_incomplete`

已经机器证明非单射接口必遗漏一个显式 Boolean collision obligation。本文补充：当接口已单射时，再谈 diagonal escape 必须明确发生了类型或表示宇宙扩张。

---

# 21. 统一表示定理

## 定理 21.1（有限确定性动力接口六重等价）

设 \(X\) 有限，\(q:X\to B\)，\(F:X\to X\)。以下等价：

1. 存在唯一有效下降 \(\overline F:B_q\to B_q\)；
2. \(K_q\) 是 \(F\)-congruence；
3. \(\operatorname{Carry}(q,F)=\varnothing\)；
4. \(q\circ F\) 沿 \(q\) 因子化；
5. \(F^*\mathcal A_q\subseteq\mathcal A_q\)；
6. \(K_0=K_1\)。

### 证明

(1)–(4) 为定理 2.1；(1) 与 (5) 为定理 4.1；(2) 与 (6) 由

\[
K_1=K_q\cap(F\times F)^{-1}K_q
\]

立即等价。\(\square\)

## 推论 21.1（线性实例）

若 \(q=P\) 为有限维 Hilbert 空间上的正交投影，\(F=T\) 为线性算子，则上述等价条件进一步等价于

\[
PTQ=0.
\]

若 \(T=T^*\)，则又等价于

\[
[P,T]=0.
\]

## 推论 21.2（随机实例）

把确定性 \(F\) 替换为 Markov kernel \(K\)，则对应零缺陷条件为

\[
\delta_q(K)=0,
\]

即强 lumpability。

## 统一原理 21.1

\[
\boxed{
\begin{array}{c|c}
\text{表示语言}&\text{同一结构障碍}\\
\hline
\text{集合商}&K_q\text{ 不被 }F\text{ 保持}\\
\text{确定性动力学}&\operatorname{Carry}(q,F)\neq\varnothing\\
\text{函数代数}&F^*\mathcal A_q\not\subseteq\mathcal A_q\\
\text{线性分解}&PTQ\neq0\\
\text{双向 reducing}&[P,T]\neq0\\
\text{随机过程}&\delta_q(K)>0\\
\text{因果查询}&K_\mathcal Q\not\subseteq K_T
\end{array}
}
\]

这些不是把不同学科强行改名，而是同一个因子化／自然性问题在不同范畴中的具体实现。

---

# 22. 新的研究推论

## 推论 22.1（观察者时间是 kernel 精化时间）

物理时间参数 \(n\) 与观察者完成深度 \(m\) 不同。\(n\) 描述系统运行多少步；\(m\) 描述需要看多长的未来词，才能让当前表示成为 Markov／闭合状态。

因此：

\[
\boxed{
\text{clock time}
\neq
\text{predictive refinement depth}.
}
\]

同一个系统可以运行很久而 \(m_*=0\)，也可以一步更新却需要很深的隐藏预测状态。

## 推论 22.2（交换子范数是双向接口活动，不是单一预测误差）

\[
\|[P,T]\|_{HS}^2
=
\|PTQ\|_{HS}^2+
\|QTP\|_{HS}^2.
\]

其中只有 \(PTQ\) 直接阻止一步可见下降；\(QTP\) 测量可见坐标向余量的泄漏。故单用交换子范数会把“隐藏影响可见”与“可见生成隐藏”合并。需要方向性审计时，应分别报告两个块。

## 推论 22.3（退相干强度与预测不闭合不是同一标量）

未读测量删除多少 Hilbert–Schmidt 相干余量，衡量的是静态投影损失；后续生成元是否把余量重新送回可见块，衡量的是 \(\mathcal D\mathcal L(I-\mathcal D)\)。前者大而后者可为零；前者小而后者可非零。

## 推论 22.4（因果实验价值是定向 kernel transversal）

一个实验的价值不是其 mutual information 的无条件大小，而是它是否横切当前目标 residual。若实验只区分 \(T\) 相同的模型，它可有高信息量而对目标识别无价值。

## 推论 22.5（局部闭合与全局闭合之间还有 gluing 层）

每个有限 prime 窗口、每个有限时间窗或每个局部图表都可下降，不推出存在一个兼容全局下降。局部定理闭合后仍需检查 transition maps、逆极限 image 与 cocycle obstruction。

## 推论 22.6（完成进度应以目标残余而非载体大小计量）

无限维残余可在每个真阶段保持与整体同维。合理的进度量是

\[
\|P_{R_\alpha}x\|,
\qquad
\sup_{x\in\mathcal T}\|P_{R_\alpha}x\|,
\qquad
K_{q_\alpha}\cap K_T,
\]

即固定目标／测试族上的残余，而不是裸维数。

---

# 23. 有限反模型册

## 23.1 当前读数相同、下一读数不同

反例 9.1 展示最小 carry。它同时证明：

- 当前接口非 Markov；
- 当前观察代数不 invariant；
- 一步未来词严格精化；
- 常值后处理可以掩盖缺陷。

## 23.2 单世界边缘相同、cross-world joint 不同

取二元 potential outcomes \((Y^0,Y^1)\)，固定两者边缘均为 Bernoulli\((1/2)\)。可选择：

\[
Y^0=Y^1
\]

或

\[
Y^0=1-Y^1.
\]

全部单世界边缘相同，但

\[
\Pr(Y^1>Y^0)
\]

不同。该缺陷是 coupling residual，不是更多单世界样本能修复的估计误差。

## 23.3 强收敛但不一致收敛

取 \(H=\ell^2(\mathbb N)\)，\(V_n\) 为前 \(n\) 个标准基向量张成空间。则

\[
P_nx\to x
\]

对每个 \(x\) 成立，但

\[
\|I-P_n\|=1
\]

恒成立。

## 23.4 约化状态相同、联合记录不同

仓库 `ReducedRecordAccessDefect` 给出机器验证实例。它同时反驳：

\[
\text{same reduced state}
\Longrightarrow
\text{same global record}.
\]

## 23.5 决策充分但完整预测不充分

仓库

`D5/S3/ConceptDynamics/DecisionValue/DecisionWithoutFullPrediction.decision_sufficiency_without_full_prediction`

给出常值概念决定最优动作、却不能决定完整 payoff profile 的机器验证反模型。

---

# 24. 与当前仓库 Lean 真值的对应表

以下条目是本文依赖的主要机器真值锚点；本文不修改它们：

| 结构 | Lean 锚点 | 本文中的角色 |
|---|---|---|
| 精确下降排除 carry | `D5/S3/ConceptDynamics/Dialectics/ExactDescentNoCarry.exact_descent_has_no_carry` | 定理 2.1 的已闭合方向 |
| 最小不变观察代数 | `D5/S3/Quantum/Dynamics/LeastInvariantObservableAlgebra.least_invariant_observable_algebra` | 第 4 节有限实例 |
| 未读测量正交投影 | `D5/S3/Observer/Conditioning/UnreadStateOrthogonalProjection.unread_state_orthogonal_projection` | 第 6 节 |
| 投影概率交换子流 | `D5/S3/Quantum/Dynamics/ProjectionProbabilityFlow.projection_probability_flow` | 第 7 节 |
| quotient–fiber 熵分解 | `D5/S3/Entropy/Fusion/QuotientFiberDecomposition.quotient_fiber_entropy_decomposition` | 第 11 节 |
| 有限 Fitting 分解 | `D5/S3/ObserverMemory/FunctionalGraphs/FiniteFunctionalGraphFittingDecomposition.finite_functional_graph_fitting_decomposition` | 第 12 节 |
| 约化访问缺陷 | `D5/S3/Quantum/Decoherence/ReducedRecordAccessDefect.reduced_irreversibility_is_access_defect` | 第 13 节 |
| 无限维强／一致分离 | `D5/S3/Quantum/Completion/InfiniteDimensionalProjectionSeparation.infinite_dimensional_projection_separation` | 第 18 节 |
| 超限基残余塔 | `D5/S3/Quantum/Completion/TransfiniteBasisResidualTower.transfinite_basis_residual_tower` | 第 18 节 |
| 多目标最小充分性 | `D5/S3/ConceptDynamics/Refinement/MultiTargetMinimalSufficiency.multi_target_minimal_sufficiency` | 第 1、15 节 |
| 非忠实接口遗漏未来义务 | `D5/S3/ConceptDynamics/Contracts/FutureObligationIncompleteness.nonfaithful_interface_future_incomplete` | 第 20 节 |
| 相邻 core 边唯一 | `D5/S1/Words/Expansions/BasePhiNegativePrefixTridentEdge.frontier_consecutive_core_adjacent` | 第 19 节 |
| 相位 trace 与 gap phase 等价 | `D5/S1/Words/Expansions/BasePhiNegativePrefixTridentEdge.phase_enriched_core_trace_iff_gap_phase` | 第 19 节 |

---

# 25. 建议的 Lean 形式化顺序

本文只给路线，不在本 PR 中添加 Lean 文件。

## 25.1 第一阶段：纯集合核

```text
D5/S3/Observer/Interfaces/
  EffectiveImageDescent.lean
  CarryEquivalence.lean
  FutureWordKernel.lean
  MinimalPredictiveCongruence.lean
```

优先闭合：

1. 有效像下降的双向等价；
2. \(K_{n+1}=K_q\cap F^{-1}K_n\)；
3. 稳定即前向不变；
4. \(K_\infty\) 最大不变子关系；
5. 有限稳定类数界。

## 25.2 第二阶段：函数代数对偶

```text
D5/S3/Observer/ObservableAlgebras/
  KernelFunctionAlgebra.lean
  PullbackDescentEquivalence.lean
  FutureWordAlgebraClosure.lean
```

目标是把 partition refinement 与现有 least invariant observable algebra 接成同一 theorem family。

## 25.3 第三阶段：线性方向性缺陷

```text
D5/S3/Observer/Residuals/
  ProjectionDescentBlocks.lean
  ProjectionCommutatorBlocks.lean
  HilbertSchmidtCarryIdentity.lean
```

必须分别命名 \(PTQ\) 与 \(QTP\)，避免只报一个无方向交换子范数。

## 25.4 第四阶段：随机 lumpability

```text
D5/S3/Observer/Stochastic/
  StrongLumpabilityDescent.lean
  TotalVariationCarry.lean
  ApproximateDescentBounds.lean
```

有限 PMF 版本足以先闭合 \(\delta/2\) 下界与代表元上界。

## 25.5 第五阶段：因果查询商

```text
D5/S3/Observer/Causal/Queries/
  QueryKernel.lean
  TargetIdentifiability.lean
  FiniteInterventionCover.lean
  CounterfactualCouplingResidual.lean
```

先做纯有限函数与显式反模型，不必一开始引入完整 DAG／do-calculus。

## 25.6 第六阶段：三叉戟最后桥

不再增加平行 provider 名称；直接围绕

```text
PhaseEnrichedCoreTrace
```

构造每一步实际相邻边的 additive witness。成功后沿已有链自动推出 delta、gap stream 与 sequence reconstruction。

---

# 26. 最终结论

## 结论 26.1

观察者不是一个附加于世界的实体，而是一张接口：

\[
q:X\to B.
\]

接口的静态余量由 \(K_q\) 给出；接口的动态失败由 \(K_q\) 是否被 \(F\) 保持给出。

## 结论 26.2

\[
\boxed{
\text{carry}
=
\text{current equivalence ceases to be valid after update}.
}
\]

## 结论 26.3

在线性空间中：

\[
\boxed{
\text{one-step carry}=PTQ,
\qquad
\text{outward leakage}=QTP,
\qquad
\text{two-way defect}=[P,T].
}
\]

## 结论 26.4

在量子连续时间中：

\[
\boxed{
[H,P]
}
\]

是事件接口的无穷小动力学缺陷，其状态期望给出概率通量；但单个状态上的零通量不等于结构交换。

## 结论 26.5

记忆的本质不是保存任意过去，而是构造最小精化

\[
X/K_\infty
\]

使未来更新在观察者状态上闭合。

## 结论 26.6

因果知识也不是单一分布，而是查询族诱导的商。观察、干预、反事实分别收缩不同 kernel；未识别目标就是该 kernel 中仍存在目标差异。

## 结论 26.7

无限完成必须带拓扑：

\[
P_\alpha x\to x
\]

不推出

\[
\|P_\alpha-I\|\to0.
\]

每个真阶段残余与整体同维，也不妨碍终端残余为零。

## 结论 26.8

当前 negative-base-\(\varphi\) 前沿已经不再缺“相邻边是否存在、是否唯一”；最后核心是证明真实 gap 沿 phase-enriched interface 因子化。换言之，剩余难点已经精确 collapse 为：

\[
\boxed{
\text{one finite-state interface must carry the exact aperiodic gap law}.
}
\]

## 最终统一式

\[
\boxed{
\begin{aligned}
\text{state distinction}
&\xrightarrow{q}
\text{observable quotient},\\
\text{future incompatibility}
&\xrightarrow{\operatorname{Carry}}
\text{predictive refinement},\\
\text{linearized incompatibility}
&\xrightarrow{PTQ,QTP}
\text{commutator defect},\\
\text{random incompatibility}
&\xrightarrow{\delta_{TV}}
\text{lumpability defect},\\
\text{causal incompatibility}
&\xrightarrow{K_\mathcal Q\not\subseteq K_T}
\text{identification residual},\\
\text{completion}
&=
\text{the least refinement on which the dynamics descends}.
\end{aligned}
}
\]

这条链给出一个统一但不混同层级的答案：所谓观察者缺失的信息，不是一个无类型的“隐藏量”；它是目标、动力学与接口共同决定的余量。只有把 kernel、carry、image、coupling、gauge 与 completion topology 分账，才能精确知道下一步究竟应增加读数、增加记忆、改变实验、约束动力学、补 gluing，还是承认目标在当前接口上根本不可识别。

---

# 2026-09-07 增补：边界矩消去与实际算术残差的完整双侧尾界

本节承接 PR 5882 的能量对偶误差估计，使用 PR 5602 在提交 `f7ca840051c8183062cb2cfb989e9f5686bd724a` 上的实际算术边界符号与 Fourier 尾界。目标是为实际 Weil 最低模态与 prolate 候选的比较提供可检查的全模态残差。新增真源为 `D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail.lean`；原 `WeilEvenFourierObservationTail` 仅增加两个公开伴随引理，复用其既有分母估计和望远镜求和证明。各公开声明配套 Scribe。

## A. 文献与已存在证明的分工

Connes、Consani、Moscovici 的 *Zeta spectral triples* 已作为 EMS Press 2026 年章节发表，DOI `10.4171/ELM/37/3`。其第 8 节所需的真实最低模态逼近仍是本路线的目标。Suzuki 于 2026 年 6 月 8 日公布的 *Weil’s quadratic form via the screw function*，arXiv:2606.09096v1，给出新的直接关联：Theorem 1.1 将规范算子表为定义域为 H0¹ 的对称算子的 Friedrichs 扩张；Theorem 1.4 在充分小的窗口得到最低特征值正、单且对应偶特征函数。其结论的窗口范围需要保留，不能替代无界增长尺度上的 simple-even 性质。

这一新文献特别说明了算子域的重要性：规范扩张的定义域严格大于原 H0¹ 域，包含常数。因此，在试探向量上设置边界条件可以服务残差认证，不能反过来要求真实最低模态也满足同一试探条件。下文只约束有限对偶试探。

仓库的分工同样明确。loning 路线最新的 `DyadicFourierInversion` 已证明其实际 dyadic 密度的 Fourier 反演与任意阶正则性，本节没有重证反演。PR 5602 的 `WeilMellinPrimeIntertwining` 已保留真实 prolate 算术合成的奇部修正。本节的试探矩消去不会删除该修正。`WeilArithmeticCouplingJet` 已证明实际 prime-pole-Gamma 符号的统一界与逐模态一阶余项；下文直接调用这两个公开定理。

## B. 先保留复矩，再消去首项

记现有实际边界符号和其已证明的包络为 s_c(n) 与 B_c，c≥2，故 |s_c(n)|≤B_c。对有限支撑集合 S⊂Z 和复系数 v_n，沿用原定义
\[
A_v(m)=\sum_{n\in S}\frac{s_c(n)-s_c(m)}{\pi(m-n)}v_n,
\qquad
J_v(m)=\sum_{n\in S}\frac{s_c(n)-s_c(m)}{\pi m}v_n.
\]
所有 pole、Gamma 与 von Mangoldt 项都仍在 s_c 中。首先证明精确代数恒等式
\[
\boxed{
J_v(m)=\frac{\sum_{n\in S}s_c(n)v_n-s_c(m)\sum_{n\in S}v_n}{\pi m}.
}
\]
于是两个复矩约束
\[
\sum_{n\in S}v_n=0,\qquad \sum_{n\in S}s_c(n)v_n=0
\]
同时消去整个首项。没有逐项取绝对值后再声称抵消，也没有要求每个 v_n 为实数。该代数式在 Lean 的全定义除法下也覆盖 m=0；实际余项定理单独排除零频与内外碰撞。

若 |n|≤N 对 n∈S 成立、N≥0、|m|>0 且 |m|≥2N，现有一阶余项界与 |m|−N≥|m|/2 给出
\[
\boxed{
\|A_v(m)\|\le\frac{4B_cN}{\pi |m|^2}\sum_{n\in S}\|v_n\|.
}
\]
这里的符号包络来自原定理的显式算术表达式，未新加未知算子的界作为前提。

## C. 完整双侧残差平方可和，并具有明确的立方尾界

设读出在外部模态上的系数为 η/(m²−w²)。对整数 M>0，假设 M≥2N、|w|≤M/2，定义 m_j=M+j+1 及实际合成系数
\[
r_j^+=\frac{\eta}{m_j^2-w^2}-A_v(m_j),\qquad
r_j^-=\frac{\eta}{m_j^2-w^2}-A_v(-m_j).
\]
先相减再取范数。原 Fourier 模块的分母证明给出 |m_j²−w²|≥3m_j²/4，因此
\[
\|r_j^\pm\|\le\frac{Q}{m_j^2},\qquad
Q=\frac43|\eta|+\frac{4B_cN}{\pi}\sum_{n\in S}|v_n|.
\]
复用原模块已经完成的逆四次幂求和证明，得到
\[
\sum_{j\ge0}m_j^{-4}\le\frac1{3M^3}.
\]
`arithmetic_residual_two_sided_tail_bound` 同时证明两侧残差模平方之和可求和，以及
\[
\boxed{
\sum_{j\ge0}\bigl(|r_j^+|^2+|r_j^-|^2\bigr)
\le\frac{2Q^2}{3M^3}.
}
\]
该式没有外部终止模态，也没有先假定残差属于 l2。正负两个方向各由一个完整自然数序列参数化，系数 2 保留。结论是平方尾质量的 M⁻³ 界，对应范数的 M⁻³ᐟ² 界；这两个衰减率不能混用。

与实际偶 Fourier 读出的纸面对应也需保留归一化。长度 L 的有符号正交基为 V_n(x)=(-1)^n exp(2πinx/L)/sqrt(L)。偶读出代表为 cos(conj(z)x)，其有符号外部系数对应
\[
w=\frac{L\overline z}{2\pi},\qquad
\eta=-\frac{L\sqrt L}{2\pi^2}\overline z\sin(L\overline z/2).
\]
单个有符号系数比原余弦基系数小 sqrt(2) 倍。上面的 Lean 定理对独立的 η、w 成立；这个积分字典、Parseval 及其与规范 Weil 算子作用的识别仍需连接，不能仅凭一致的公式名称宣布已完成。

## D. 两个矩与候选正交可以同时实现

对任意候选系数 k_n，再要求
\[
\sum_{n\in S}\overline{k_n}v_n=0.
\]
`exists_nonzero_arithmetic_moment_trial` 证明：只要 |S|>3，就存在支撑在 S 中的非零复系数函数 v，同时满足三条方程。证明实际构造从 C^S 到 C³ 的复线性映射；若其核只有零向量，就会产生从维数大于 3 的空间到 C³ 的单射，与标准维数定理矛盾。最后把核向量零延拓为 Z 上的有限支撑函数，并逐条验证三个有限求和等式。

`exists_nonzero_trial_with_cubic_tail` 将这个同一非零见证交给 C 节的全尾定理。约束行不需要线性无关，候选也不需要特殊相位。这个存在性排除了仅靠零试探满足条件的空洞情形，但不保证试探与精确对偶解接近，也不保证其预算优于零试探。算术系数涉及超越数；这里没有宣称已给出可执行、带舍入保证的精确约束求解器。

## E. 对能量对偶路线的用途与尚需完成的连接

PR 5882 已有系数 C_g(v)=2 Re〈g,v〉−q(v)+‖P_(k⊥)(g−Mv)‖²/κ 的完整证明。本节提供了其中一类全外部系数质量的显式上界。调用时还必须认证内区残差、候选投影、正交基识别和 M 对该试探的真实作用。如果候选和试探都在保留区中，投影及标量移位只改变内区系数，但这个支持条件仍须实际验证。

两个矩为精确条件。浮点试探的近零矩不能直接替代它们：非零矩会重新带来 1/m 首项，改变完整平方尾界。非零存在性也不能用来绕过这些数值认证。有限精度的矩缺陷控制、最优或近最优试探选择、真实算子域桥及对同一 prolate 家族的全尺度估计，是后续需要分别结算的任务。

本轮的有限精确代数检查覆盖三个约束、首项恒等式、双侧余项与删去任一矩的负控；实际 c=3、5、11 符号另作数值检查。这里的包络较保守，数值诊断未证明实际最低模态误差更小。新源码属于逻辑审查后的候选证明，尚未执行 Lean 内核和 Scribe 发射。没有据此宣称真实最低模态趋于 Xi、全尺度 simple-even 或 RH。

文献与真源：CCM, *Zeta spectral triples*, EMS Press (2026), DOI `10.4171/ELM/37/3`, §8；M. Suzuki, *Weil’s quadratic form via the screw function*, arXiv:2606.09096v1, Theorems 1.1、1.4 与 §8.5；`WeilArithmeticCouplingJet.arithmetic_coupling_first_jet_error`；`WeilEvenFourierObservationTail.exterior_inverse_fourth_bound`；`CoerciveDualCertificate.dual_energy_readout`。

---

# 2026-09-07 增补：非零矩缺陷、有限精度包围与严格尾界验收

本节继续 PR 6029，在原精确矩消去定理之上允许两个矩非零。新增 `WeilArithmeticResidualPrecision.lean` 及同名 Scribe，继续使用原 `arithmeticBoundarySymbol`、`couplingColumn`、`couplingFirstJet` 和 `arithmeticResidualTail`。本节规定的是数学输入的误差半径与结论的验收条件，没有把计算时设置的工作位数当作误差证明。

## A. 精度输入必须是对实际数学值的包围

对有限支撑 S，令 v_n、s_n 为实际系数与实际算术符号，令 v̂_n、ŝ_n 为精确解释的中心值。中心可取有理数或二进有理数；显示的小数需要按其准确语义解码。输入为绝对误差条件
\[
|v_n-\widehat v_n|\le e_{v,n},\qquad
|s_n-\widehat s_n|\le e_{s,n}\qquad(n\in S).
\]
复数矩形区间的实、虚误差半径为 a、b 时，可取复模半径 sqrt(a²+b²)，也可安全取有理上界 a+b。若已证明两个分量的绝对误差分别不超过 2⁻ᵇ，则 2¹⁻ᵇ 是复模半径的一个安全上界；这句话不把 b 位工作精度等同于该分量误差条件。如果选择的实际试探就是精确解码后的中心，便可取 e_v=0，无须虚构一个未知精确优化器。

所有包围必须覆盖算术符号的无穷级数余项、输入常数、函数求值与转换舍入。输出精度标签或区间包含零均不能提供精确零等式。FLINT 官方 *Using ball arithmetic* 文档以包含原则定义球算术，并明确区分工作精度、区间半径与零判断；本节使用的是该包含语义。引用：`https://flintlib.org/doc/using.html`。

## B. 两个矩与系数质量的误差传播

`finite_moment_enclosures` 从逐项包围推出
\[
\left|\sum_{n\in S}v_n\right|\le E_0:=\left|\sum_{n\in S}\widehat v_n\right|+\sum_{n\in S}e_{v,n},
\]
\[
\left|\sum_{n\in S}s_nv_n\right|\le E_1:=\left|\sum_{n\in S}\widehat s_n\widehat v_n\right|
+\sum_{n\in S}\left(|\widehat s_n|e_{v,n}+e_{s,n}|\widehat v_n|+e_{s,n}e_{v,n}\right),
\]
\[
\sum_{n\in S}|v_n|\le V:=\sum_{n\in S}(|\widehat v_n|+e_{v,n}).
\]
乘积误差 e_s e_v 被完整保留。中心矩没有被要求等于零，它们的实际模仍进入预算。可以再用向上包围的有理数替代 E0、E1、V。

若 d=|S|，各系数误差不超过 ε_v，各符号误差不超过 ε_s，则 E1 可用中心矩模加 ε_v∑|ŝ_n|+ε_s∑|v̂_n|+d ε_v ε_s 包围。这是上述有限和定理的直接应用。提高工作精度的目的，是得到能够通过后述验收不等式的这些半径，固定的十进制位数不作为普遍成功条件。

## C. 带非零矩的全部外部模态

取对原算术包络的上界 B≥B_c，以及严格正的下界 0<p≤π。令 H≥|η|、W≥|w|，支撑满足 |n|≤N。选择自然数 M，要求
\[
\boxed{M>0,\qquad M\ge2N,\qquad M\ge2W.}
\]
如果 η、w 也有中心与半径，使用 H≥|η̂|+e_η、W≥|ŵ|+e_w；不能只用中心频率决定分母是否远离零。定义
\[
D=\frac{E_1+BE_0}{p},\qquad Q=\frac43H+\frac{4BNV}{p}.
\]
由原首项恒等式得 |J_v(m)|≤D/|m|，由原一阶余项定理得 |A_v(m)−J_v(m)|≤4BNV/(p|m|²)。因此，对原定义的两侧完整残差，有
\[
|r_j^\pm|\le\frac{D}{m_j}+\frac{Q}{m_j^2},\qquad m_j=M+j+1.
\]
令 F(x)=D²/x+DQ/x²+Q²/(3x³)。新证明直接验证 F(x)−F(x+1)≥(D/(x+1)+Q/(x+1)²)²，随后对有限部分和望远镜累加，再用标准实级数定理得到平方可和性与
\[
\boxed{\sum_{j\ge0}(|r_j^+|^2+|r_j^-|^2)
\le\mathcal T(D,Q,M):=2\left(\frac{D^2}{M}+\frac{DQ}{M^2}+\frac{Q^2}{3M^3}\right).}
\]
`arithmetic_residual_defect_tail_bound` 证明这一全尾结论；`rounded_arithmetic_residual_tail_bound` 再消费 B 节以及 η、w 的输入包围。原残差定义没有改动，没有有限高频终止点，也没有输入残差已经平方可和的前提。交叉项 DQ/M² 不能删除。

## D. 验收条件、误差单位与可执行有理检验

τ 在本节表示平方尾质量预算。目标若是尾部范数不超过 ε，应使用 τ=ε²。对 M>0，`precision_tail_bound_iff` 给出精确等价
\[
\boxed{\mathcal T(D,Q,M)\le\tau\quad\Longleftrightarrow\quad
6D^2M^2+6DQM+2Q^2\le3\tau M^3.}
\]
`residualTailCheck` 在有理数上执行右侧不等式，同时检查 N、W、D、Q、τ 非负以及 C 节的全部分离条件。它只使用精确有理运算。`residual_tail_check_sound` 把返回 true 转换为实数意义的尾预算不等式；`rounded_residual_certificate_sound` 将其与明确的输入包围合成，推出原实际系数残差的全尾上界。

因此，true 的含义是所给预算通过数学验收。输入的超越数包围仍须证明，不能由这个布尔值替代。false 只表示当前证书未被接受，不证明真实尾部超标。误差上界允许等号；下游 Fourier 非零判据还必须要求总误差严格小于已认证的候选下界，不能把尾部验收的非严格不等式误用为严格非零裕量。

精确标量例子：M=1000、N=64、W=10、Q=1、τ=10⁻⁹ 时，D=10⁻⁶ 的尾预算为 1003003/1500000000000000，小于 τ，检查接受；D=10⁻² 的尾预算为 331/1500000000，大于 τ，检查拒绝。这两个例子只测试标量验收，未指定真实算术试探或宣称实际谱证书成功。源码另含零截断、支撑分离失败、频率分离失败的拒绝例子。

## E. 截断长度必须与精度预算联动

`precision_tail_bound_of_balance` 证明：D、Q、γ 非负且 DM≤γQ 时，
\[
\boxed{\mathcal T(D,Q,M)\le2(\gamma^2+\gamma+1/3)\,\frac{Q^2}{M^3}.}
\]
这明确规定了保持该立方平方尾预算的一个充分条件。对固定非零 D，所给包络含 M⁻¹ 项，不能继续标注统一的 M⁻³ 速度；但 D、Q 固定时完整包络仍趋零，不能误说存在不可消除的正误差地板。对变化的真实物理尺度，B、V、H、N、M 和矩缺陷都必须一起计入，单纯增加截断或工作位数不会自动证明所需尺度率。

现有能量对偶消费者还要求试探与候选精确正交。有限精度配对接近零不等于满足该条件。可先在有限精确系数上做候选投影，再对投影后的同一试探重新计算两个矩及全部预算；投影自身的舍入必须重新计入。此处没有新增投影构造定理，也没有以本轮尾部验收替代候选正交、真实算子定义域、基识别、内区残差和强制性条件。

## F. 验证范围

本轮九个公开声明有同一 Scribe 中的九个精确句柄。数学检查实际执行了一个混合望远镜恒等式、250 组精确误差包围、1145 组复数乘积恒等式、1920 个双侧残差点检查、各 250 组有理验收等价、有限尾和及精度平衡检查，并拒绝八个指定错误变体。残差点检查使用有界模型符号及分母常数 3，未冒充真实 prime-pole-Gamma 计算。没有运行新的实际 prolate、Weil 或区间函数求值认证。

这些精确有限诊断未调用 Lean。源码仍为数学与接口审查后的候选证明，Lean elaboration、内核公理闭包及 Scribe 发射尚未执行。本节给出有限精度误差传播与严格验收链，未完成规范 Weil 算子的全尺度模态逼近或 Xi 极限。

---

# 2026-09-07 增补：精确正交试探的构造与修正后残差认证

本节继续 PR 6029，补齐上一增补留下的候选正交条件。新增 `WeilOrthogonalTrialPrecision.lean` 及同名 Scribe。实际试探由 Mathlib 原有正交投影构造，其修正后系数半径进入既有 `rounded_residual_certificate_sound`。结论对同一个修正后试探同时给出精确支撑、精确正交和完整双侧算术尾界。

## A. 原有投影与系数域结果的复用

项目钉版 Mathlib `db584cd6d46c92f209a44c0f1c829460d327499d` 的 `Projection/Basic` 已有 `starProjection_singleton`、`starProjection_orthogonal_val` 和投影像的子空间成员定理；`PiL2` 提供有限欧氏系数空间及其内积；`Orthonormal.inner_sum` 提供实际有限正交合成的配对等式。本节直接使用这些对象，没有重新构造一套正交投影。

本轮实际读取了 loning 路线 PR 6013 在 `061a5616f6adc52ac545b6941cf23214fa8f442a` 的 `GramSchmidtCoefficientField.lean`。该源码在明确的 Hankel 内积条件下，通过良基归纳证明未归一化 Gram–Schmidt 坐标属于系数生成子域。本节不复制这一迭代结论；只对一个具体试探使用单向量投影，并证明修正系数的误差传播及算术尾界消费。PR 5602 当前 Gamma/prolate 能量增补与 PR 5895 的横向 Fourier 增补本轮仅核对说明，未重跑其算术验证器。

## B. 固定精确候选，不要求先归一化

令 S 为有限整数支撑，k_n 为固定的精确候选系数，v_n 为待修正系数。记
\[
\sigma=\sum_{n\in S}|k_n|^2,\qquad
\beta=\frac{\sum_{n\in S}\overline{k_n}v_n}{\sum_{n\in S}\overline{k_n}k_n}.
\]
在 Mathlib 的 `EuclideanSpace Complex S` 中投影到 k 的正交补，并在 S 外补零，得到 `orthogonalTrial`。原单向量投影公式给出
\[
\boxed{v_n^{\perp}=v_n-\beta k_n\quad(n\in S),\qquad v_n^{\perp}=0\quad(n\notin S).}
\]
`orthogonal_trial_constraints` 由实际投影的成员关系证明
\[
\boxed{\sum_{n\in S}\overline{k_n}v_n^{\perp}=0.}
\]
原始试探不需要预先满足任何正交等式。若候选为零，投影和全定义除法公式仍有一致语义；涉及精度分母的后续定理单独要求正下界，因此不会把零候选当作有效精度证书。

该公式只用四则运算与共轭，没有计算单位化因子 sqrt(σ)。`orthogonal_trial_mem_subfield` 证明：当 k、v 的有限系数属于共轭封闭的复数子域时，修正结果仍属于该域。这个结论是系数归属定理，未宣称已执行一个新的有理数求解器。

对任意实际给出的正交单位族 e_n，`orthogonal_trial_synthesis` 使用原有限合成内积定理，将系数正交转换为
\[
\left\langle\sum_{n\in S}k_ne_n,\sum_{n\in S}v_n^{\perp}e_n\right\rangle=0.
\]
这里不额外构造或假定某个规范 Fourier 族已经完成正交性识别。

## C. 用标量方程残差包围精确修正系数

假设 |v_n−v̂_n|≤e_{v,n}，且给出 0<σ_lo≤σ。令 b 是修正系数的任意精确中心，ε≥0。只需认证
\[
\boxed{\left|\sum_{n\in S}\overline{k_n}\widehat v_n-b\sigma\right|
+\sum_{n\in S}|k_n|e_{v,n}\le\varepsilon\sigma_{\rm lo}.}
\]
有限配对的误差界与 σ 的正下界推出 |β−b|≤ε。于是以
\[
\widehat v_n^{\perp}=\widehat v_n-bk_n,\qquad
e_{v,n}^{\perp}=e_{v,n}+\varepsilon|k_n|
\]
作为更新后的中心和半径，得到
\[
\boxed{|v_n^{\perp}-\widehat v_n^{\perp}|\le e_{v,n}^{\perp}.}
\]
`orthogonal_trial_enclosures` 同时证明这两个结论。它不把 b 当作精确 β，也不把接近零的候选配对解释成零。k 是固定精确数据；若调用者只有另一个未知候选的近似值，需要另外证明两者的关系，不能悄悄交换候选。

上述标量条件按包含式误差解释。FLINT 官方 *Using ball arithmetic* 文档明确区分输入球的包含保证、实际半径和工作精度：`https://flintlib.org/doc/using.html`。这只提供数值方法的语义参照，Lean 终点仍要求相应的不等式证明，不信任某个外部成功标记。

## D. 两个边界矩必须对修正后向量重新计算

`orthogonal_trial_moment` 对任意权重 a_n 证明
\[
\boxed{\sum_{n\in S}a_nv_n^{\perp}
=\sum_{n\in S}a_nv_n-\beta\sum_{n\in S}a_nk_n.}
\]
分别取 a_n=1 与 a_n=s_c(n)，得到更新后的两个算术边界矩。投影一般不保持原先的零矩条件。

一个精确有理数例子是 S={0,1,2,3}、k=(1,1,0,0)、v=(1,−2,1,0)，用权重 s=(0,1,2,3)。原来两个加权和均为零；β=−1/2，修正结果为 (3/2,−3/2,1,0)，其候选配对精确为零，但两个矩分别变成 1 与 1/2。这个例子只说明矩更新的代数必要性，不是实际算术符号实例。

因此最终 `orthogonal_trial_residual_certificate` 把 C 节的新中心及新半径传给上一增补的误差传播定理，重新形成 E0、E1、V，再用同一原 `residualTailCheck` 验收。它同时输出有限支撑、精确候选正交、原 `arithmeticResidualTail` 的平方可和性及对全部双侧外部模态的 τ 上界。原始试探的正交性和修正误差均不是输入假设。

## E. 对真实模态问题的作用与边界

本节消除了能量对偶应用中“数值试探已精确正交”的额外要求，并防止修正前后使用不同试探的预算。精确修正对象可以用中心与半径表示，后续数值代码不需要把它再次舍入后冒充同一个精确对象。若实际使用的向量经过再次舍入，其新误差必须另计。

修正后的试探可以为零，例如原始试探平行于候选。现有能量对偶证书允许零试探；本节没有把精确正交升级成非零、最优性或实际误差改善。即使正交投影在 Hilbert 范数中有良性性质，也不能无证明地控制一个无界算子的作用。只有在候选和试探都位于同一个线性算子域时，减去 βk 才自动留在该域。

Suzuki 的 *Weil’s quadratic form via the screw function*，arXiv:2606.09096v1，Theorem 1.1 给出规范算子的 Friedrichs 扩张描述；Theorem 1.4 的最低模态结论限制在充分小的窗口。本轮读取的是公开 v1 原文，不据此断言当前全部版本的最终研究状态。这个定义域与窗口范围提醒仍适用于本节：有限系数投影不能代替规范 Weil 算子的真实域、基识别、内区残差或增长尺度上的补空间强制性证明。

## F. 实际检查与未执行的验证

九个公开声明均有同名 Scribe 的 `StatementSource.FromLean()` 对应。独立于源码推导的本地精确有理数诊断实际检查了 180 组投影与范数关系、540 个矩恒等式、180 个修正系数包围、813 个修正后坐标包围、35 个有限 Hilbert 合成比较，以及 768 个残差点和 24 组有限尾预算。六个错误变体被拒绝，包括省略共轭、误当单位候选、沿用旧矩与遗漏修正系数误差。

残差诊断使用有界周期模型符号和分母常数 3，未冒充实际 prime-pole-Gamma 求值；有限尾和也不证明无穷级数结论。没有运行新的实际 Weil/prolate 数值证书，没有独立审稿人。Lean elaboration、内核公理闭包和 Scribe 发射尚未执行，本节是完成数学审查的候选证明源码。规范算子的全尺度最低模态逼近及 Xi 极限仍需实际算术分析。

---

# 2026-09-07 增补：有限有理复数试探的精确正交修正与同一输出的尾证书

本节补交此前已在本地完成的 PR 6029 精确有理实现。实际写回基线为 `150b85daf8f04a94447bfd2baff1d97203a57a90`，沿用其中已有的 `WeilOrthogonalTrialPrecision`。两个候选 Lean 模块为 `FiniteRationalTrialRepair` 与 `WeilRepairedTrialCertificate`，位于 `D5/S3/Weil/ZetaBridge/`，各有同名 Scribe。本节消除后续尾证书中独立给定的候选正交、两个矩上界和系数质量上界，代之以实际可执行修正及从其同一输出重新计算的有理预算。算术符号的真实包围、算子域和正交基识别仍分别保留。

## A. 复用标准投影，精确实现其有限有理坐标

本轮直接读取 loning 路线的 `GramSchmidtCoefficientField`，其当前源码通过 Mathlib `starProjection_singleton` 追踪未归一化 Gram–Schmidt 坐标的子域归属。它处理迹矩量和系数域，不提供本节的有限复数修正及尾界消费者。最新远端 `WeilOrthogonalTrialPrecision` 已给出标准投影构造、坐标公式、精确正交、加权矩传递以及带舍入包围的残差消费者。本节没有复制这些证明，直接导入该模块，以 `repair_eq_existing_trial` 证明可执行有理输出与原 `orthogonalTrial` 逐坐标相等。正交性消费原 `orthogonal_trial_constraints`，范数收缩继续消费 Mathlib 原结论。本节增量是精确有理实现及从输出实际计算 E0、E1、V 的消费者，超越数包围仍明确保留。

取有限整数支撑 S，候选与试探以两个有理坐标存储：k_n=a_n+ib_n、v_n=x_n+iy_n。只执行有理运算，定义
\[
q=\sum_{n\in S}(a_n^2+b_n^2),\quad
A=\sum_{n\in S}(a_nx_n+b_ny_n),\quad
B=\sum_{n\in S}(a_ny_n-b_nx_n),\quad
\beta=A/q+iB/q.
\]
`repairTrial` 在 q=0 时返回 `none`，否则输出
\[
\boxed{t_n=v_n-\beta k_n\quad(n\in S),\qquad t_n=0\quad(n\notin S).}
\]
`repair_defined_iff` 证明成功与 S 中存在非零候选坐标等价。空支撑与零候选明确被拒绝。候选不需要单位归一化，算法不计算平方根；有理输出一般不再是二进有理数，不能无误差地转回固定二进格。

`decode` 仅把有理坐标解释为既有复数，`decodedVector` 使用标准 `EuclideanSpace ℂ S`。成功输出先与已有 `orthogonalTrial` 等同，再由 `repair_eq_starProjection` 得到
\[
\operatorname{decodedVector}(t)=P_{\operatorname{span}(k)^\perp}\operatorname{decodedVector}(v).
\]
因此精确复配对为零，且欧氏范数不增加。配套的 `repair_isometric_orthogonality` 可通过任何已经建立的线性等距合成映射传递正交性。它不自行构造实际 Fourier 基，也不把 Pi 默认上确界范数当作欧氏范数。若原试探平行于候选，输出可以为零；此处没有非零输出或优于零试探的保证。

## B. 正交修正会改变边界矩，旧预算不能继承

对任意复权重 s_n，已有 `orthogonal_trial_moment` 与本轮输出一致性定理给出同一输出的精确恒等式
\[
\boxed{\sum_{n\in S}s_nt_n=\sum_{n\in S}s_nv_n-\beta\sum_{n\in S}s_nk_n.}
\]
它同时适用于常权重、实际算术边界符号和候选配对。例取 k=(1,2,0)、v=(1,-2,1)、s=(1,2,3)。原试探的无权矩和 s 加权矩都为零。修正得到 t=(8/5,-4/5,1)，满足 k 与 t 正交，但两矩分别变为 9/5 与 3。欧氏范数收缩不能推出矩上界保持，也不能无证明地推出系数 l1 质量收缩。

因此，先前精确两矩消去得到的立方尾界不能直接用于这个 t。本节改用既有非零矩精度定理，并从 t 的实际有理坐标重算全部输入。

## C. 修正后预算可用有理运算直接计算

令实际算术符号 s_c(n) 具有实有理中心 h_n 与半径 e_n，满足 |s_c(n)-h_n|≤e_n。把 t_n 写成 p_n+iq_n，`rationalMomentBudgets` 计算
\[
E_0=\left|\sum p_n\right|+\left|\sum q_n\right|,
\]
\[
E_1=\left|\sum h_np_n\right|+\left|\sum h_nq_n\right|+
\sum e_n(|p_n|+|q_n|),\qquad V=\sum(|p_n|+|q_n|).
\]
各求和均在 S 上。`rational_moment_budgets_sound` 通过 |p+iq|≤|p|+|q| 及上一节已证明的乘积误差传播，推出实际无权矩模不超过 E0、实际算术矩模不超过 E1、系数质量不超过 V。存储的有理输出本身被选作实际试探，所以没有引入未知优化器或虚构的系数舍入误差。符号中心与半径的真实有效性仍是明确输入；它们需要包含原 prime-pole-Gamma 表达式的全部误差。

## D. 同一修正输出进入完整残差验收

`repaired_arithmetic_residual_certificate` 消费一次成功的 `repairTrial`、上述逐项符号包围以及原有 `residualTailCheck` 的成功结果。对于 B_+≥B_c、0<p≤π、H≥|η|、W≥|w|，仍取
\[
D=(E_1+B_+E_0)/p,\qquad Q=4H/3+4B_+NV/p,
\]
并保留 M>0、M≥2N、M≥2W。其同一终点给出支撑、精确候选正交、两侧残差平方可和，以及
\[
\sum_{j\ge0}\bigl(|r_j^+(t)|^2+|r_j^-(t)|^2\bigr)\le\tau.
\]
这里 r(t) 正是既有 `arithmeticResidualTail` 作用于修正后的 t。证明中没有输入独立的 horth、E0/E1 的真实性或 V 的真实性；它们由构造和预算定理推出。原有有理验收器继续检查非负性、分离条件和 6D²M²+6DQM+2Q²≤3τM³，没有复制第二个验收器。

候选为精确有限向量时，其非零倍数与单位归一化具有相同正交补。真正接入规范 Weil 算子仍须给出该有限向量的正确等距合成、算子作用和定义域、内区残差及强制性。本节处理完整外部算术系数尾，不宣称仅凭这些系数等式已得到真实算子的完整残差范数。

## E. 实际数据检查、文献边界与验证状态

本轮读取原 `prime3_certificate.json`，固定于提交 `f7ca840051c8183062cb2cfb989e9f5686bd724a`，文件 blob 为 `3b26da5a8db885821969f13862b2761ccfd98a89`。它的 129 个整数分子和公分母 1099511627776 给出精确候选平方范数
\[
1208925819614761052253583/1208925819614629174706176.
\]
该值不等于一。本次写回重新读取此实际候选，对索引 0、1、62、64、66、128 的六个坐标种子运行 Fraction 精确修正，均得到零复配对与范数收缩，输出坐标的最大分母位长为 81。这个数字仅描述这六个实例，不是算法的统一复杂度界；本轮没有据此认证真实算术符号包围、优化对偶目标或改进谱误差。

本次另重新运行 240 组复有理修正、240 组符号误差预算、240 个加权矩恒等式及 240 个坐标置换一致性检查。每组检查精确正交、范数收缩与幂等性；零候选、空支撑、遗漏共轭、假定单位范数及继承旧矩均有边界或负控。它们是本地精确有限诊断，不是 Lean 或 Scribe 执行结果。

外部目标继续采用 CCM 的 *Zeta Spectral Triples* §8 中真实最低模态与 prolate 候选的逼近。Suzuki `arXiv:2606.09096v1` 的算子域及小窗口结果、Groskin `arXiv:2607.02828v1` 的有限字典和带预算判定规则用于校对对象与适用范围；本轮没有将这些结果直接扩为全尺度结论。此次可访问的 arXiv 主记录和 HTML 为上述版本，不据此断言不存在其他版本。FLINT 包含语义仍要求保留实际半径，固定工作位数不替代误差证书。

本节十四个公开声明均有对应的 FromLean Scribe。源码经过数学及钉版接口审查，未执行 Lean elaboration、内核公理闭包或 Scribe 发射，没有独立证明审稿人。本节不主张新的投影定理、形式化优先权、实际 prolate 优化结果、Xi 极限或 RH 结论。

参考：`WeilOrthogonalTrialPrecision` 于提交 `ea58c3d808f19f82792e3343aec9726ba2dafabe`，Lean blob `3a93d2bfff8b93c614320477ad4907f677f0a0e2`；Mathlib `db584cd6d46c92f209a44c0f1c829460d327499d`，`Analysis/InnerProductSpace/Projection/Basic.lean` 与 `PiL2.lean`；CCM，`https://arxiv.org/html/2511.22755v1`，§8；Suzuki，`https://arxiv.org/html/2606.09096v1`；Groskin，`https://arxiv.org/html/2607.02828v1`；FLINT，`https://flintlib.org/doc/using.html`。

---

# 2026-09-07 增补：实际算术符号的有限求值、立方加速余项与修正试探的直接消费

本节继续 PR 6029。新真源 `WeilBoundarySymbolEnclosure` 直接导入前节的有理试探实现及证书，保持 `WeilArithmeticCouplingJet.arithmeticBoundarySymbol` 为唯一目标符号。它把原先独立给定的无穷符号包围，降为有限表达式的包围，再在 Lean 候选源码中推出所有遗漏 Gamma 项的误差。八个公开声明配套同名 Scribe。

## A. 与 PR 5602 的当前分工

本轮核对 PR 5602 于 `c94c6abb6fcd9ad2d85c50666fa6abcfdbd8c2f5` 的更新说明、改动目录，以及其实际 `WeilArithmeticCouplingJet`、`WeilArithmeticCouplingParityGram` 和 `WeilArchimedeanTailJet` 源码。当前说明报告了同一 c=3 prolate 模型完整算子残差的区间证书，归一化残差介于 9166619/10¹¹ 与 9166620/10¹¹，保留 Gamma、素数、极点、奇部和图范数误差。其简单残差/历史间隙下界估计尚不足以闭合所需模态比较。这个事实只限制该估计，不证明真实模态距离大或真实间隙小。本轮没有重跑那个完整算子验证器。

本节不再求一遍 prolate 的 Gamma 作用；它为方向性对偶试探所需要的有限符号表提供可组合的余项证明。`WeilArithmeticCouplingJet` 已证明绝对收敛和全符号包络，但没有给任意求值截断处的精度；本节复用其收敛结论。`WeilArchimedeanTailJet` 处理连续频率积分的几何展开，`WeilArithmeticCouplingParityGram` 处理正负模态配对，均不同于本节 Gamma 求和索引的尾部。本轮没有重建这些所有者。

物理整数截止 c、残差的外部 Fourier 截断 M，以及符号内部 Gamma 求值截断 K，是三种不同参数。以下 K 的收敛不能直接解释为 c 趋于无穷时的真实最低模态收敛。

## B. 先保留原符号，再截取有限求值部分

记 L=log c、ω=2πn/L、a_j=2j+1/2，其中 c≥2、n∈Z。原符号的 Gamma 项为
\[
g_j=\frac{\omega(1-e^{-a_jL})}{a_j^2+\omega^2}.
\]
`boundarySymbolPartial c n K` 保留原式全部 pole 项、全部有限 von Mangoldt 项，以及 j=0,...,K 共 K+1 个 Gamma 项。原符号没有被替换成有限模型；这个有限表达式只是它的近似。

从 0≤1−exp(−a_jL)≤1 得 |g_j|≤|ω|/a_j²，再用正望远镜差得到
\[
\boxed{|s_c(n)-s_c^{[K]}(n)|\le\frac{|\omega|}{4K+1}.}
\]
`boundary_symbol_partial_error` 使用原始绝对收敛证明分割真正的无穷和，没有用某个终止高频代替它。K=0 仍然保留第零项；将 K+1 项误写成 K 项会破坏此界。

## C. 精确求和主尾项，留下立方与指数余项

仅依赖上式时，误差按 K⁻¹ 衰减。取可精确求和的有理尾项
\[
q_j=\frac{\omega}{a_j^2-1}
=\frac{\omega}{2}\left(\frac1{a_j-1}-\frac1{a_j+1}\right),\qquad j>K.
\]
因为相邻 a_j 的差为 2，有限和望远镜消去并取极限给出
\[
\sum_{j>K}q_j=\frac{\omega}{4K+3}.
\]
实际加速表达式为
\[
\boxed{s_c^{\mathrm{acc},K}(n)=s_c^{[K]}(n)-\frac{\omega}{4K+3}.}
\]
它只增加一次实数除法，没有改变原符号。对于每个 a=a_j>1，有精确恒等式
\[
g_j-q_j=-\frac{\omega(\omega^2+1)}{(a^2+\omega^2)(a^2-1)}
-\frac{\omega e^{-aL}}{a^2+\omega^2}.
\]
两个余项都保留。立方望远镜不等式
\[
\frac1{a^2(a^2-1)}\le\frac1{6(a-1)^3}-\frac1{6(a+1)^3}
\]
由其差的显式正表达式 (7a²−3)/(3a²(a−1)³(a+1)³) 得到。另一方面，对 j>K，exp(−a_jL)≤c^{−(2K+2)}，这个上界使用原来的 log c，最后可由整数有理幂计算。合并两类有限部分和、使用原 Gamma 收敛并令有理末项趋零，`boundary_symbol_accelerated_error` 推出
\[
\boxed{
|s_c(n)-s_c^{\mathrm{acc},K}(n)|\le
R(c,\omega,K):=
\frac{4|\omega|(\omega^2+1)}{3(4K+3)^3}
+\frac{|\omega|}{c^{2K+2}(4K+1)}.
}
\]
这对正、负和零频率均成立。K≥0 时所有新有理分母都严格非零。第二项不可在证明中凭数值小而删除。该式改善的是固定 c、n 的符号求值余项；它不是关于未知本征向量的残差大小或新的谱间隙定理。

## D. 有限包围变成实际符号表，并进入同一试探的尾证书

给出精确有理中心 ŝ_n、有限求值误差 ε_n、频率上界 F_n，要求
\[
|s_c^{\mathrm{acc},K_n}(n)-\widehat s_n|\le\varepsilon_n,
\qquad |2\pi n/\log c|\le F_n.
\]
`rationalSymbolRadii` 用精确有理运算生成
\[
e_n=\varepsilon_n+
\frac{4F_n(F_n^2+1)}{3(4K_n+3)^3}
+\frac{F_n}{c^{2K_n+2}(4K_n+1)}.
\]
`rational_symbol_radii_sound` 证明原来的无穷符号满足 |s_c(n)−ŝ_n|≤e_n。其证明包含 |ω|≤F 对两个余项的单调放大，未要求调用者另行证明无穷 Gamma 尾。

`repaired_trial_from_finite_symbols` 将该表直接传给 `rationalMomentBudgets` 和原 `residualTailCheck`。同一终点仍给出实际返回试探的精确有限支撑、精确候选正交、原双侧算术残差的平方可和性及 τ 上界。它消除了最终消费者的独立无穷符号包围前提；有限 log、exp、sin、cosh 表达式的包围、全局 B_c 包络、参数区间、基与算子域识别并未被消除。

这些有限表达式的中心误差必须覆盖所有基本运算及函数求值舍入。`rationalSymbolRadii` 本身不计算任何超越函数，也不信任某个区间 JSON 的成功标记。它可以消费已经证明的有限区间计算；本轮尚未提供完整的已验证超越函数求值器。对于给定半径预算，分别检查两个有理余项是否足够小即可调整 K；本节没有承诺一种固定工作精度或截断数必然使实际谱证书成功。

## E. 文献比较和验证范围

当前读取的 Suzuki `arXiv:2606.09096` 与 Groskin `arXiv:2607.02828` 主记录均显示 v1，分别发表于 2026 年 6 月 8 日与 7 月 2 日。前者以 screw function 研究有限窗口算子及其极限问题，后者明确区分带截断预算的有限认证和 cutoff-free 方法。本节没有把三种截断参数混同，也不提出首次消除截断或首次形式化的优先权主张。NIST DLMF 5.7.6 的 digamma 部分分式展开仅用于独立数值诊断；新 Lean 源码的证明由上述实数恒等式、非负余项和标准级数极限组成，不调用 digamma。

本轮精确代数诊断验证四个标量恒等式及 160 个有限逆平方尾和。实际算术符号另在 c=3、5、11，n=0、±1、±4、±16，K=0、1、8、32、128 上作 85 位非定向数值比较，共 105 组原尾界、105 组加速尾界，以及各自生成有理半径的检查。比较对象用 digamma 恒等式减去指数收敛修正得到，未采用 zeta 零点数据。这些数值比较不构成有向区间或 Lean 证据。

例 c=3、n=1、K=32，原尾半径约 0.04433489717，加速余项半径约 0.000114343003，缩小约 387.736 倍；数值观察到的加速后误差约 0.000113786009。这个实例说明符号求值预算的改进，并未证明完整对偶目标或实际模态误差改善。对非常小的精度目标，有限求和仍可能昂贵；更高阶或专门函数算法需另行认证。

本轮连同前节共交付三个 Lean 模块、三个 Scribe 和本卷追加内容。已检查公开句柄匹配与源码占位符；没有 Lean/lake 可执行程序，未运行 elaboration、内核公理闭包或 Scribe 发射。候选证明经过数学和接口审查，未经过独立证明审稿。规范 Weil 算子的全尺度最低模态比较、方向性证书的实际优化和 Xi 极限均未在本节闭合。

参考：NIST DLMF `https://dlmf.nist.gov/5.7.E6`；Suzuki `https://arxiv.org/abs/2606.09096`；Groskin `https://arxiv.org/abs/2607.02828`；FLINT `https://flintlib.org/doc/using.html`；PR 5602 `c94c6abb6fcd9ad2d85c50666fa6abcfdbd8c2f5`；原算术真源 blob `2e0d7277d7f92278a4ac9938f0bc342e42cdf94b`。

---

# 2026-09-07 增补：保持偶对称与零迹的精确有理修正

本节继续 PR 6029，采用 PR 5602 最新实际对偶试探的零迹偶系数结构。目标是消除一般候选正交修正会重新引入边界矩的问题。新增真源 `WeilEvenTraceRepair.lean` 及同名 Scribe，复用原 `repairTrial`、实际符号的奇性和已有完整双侧尾界。以下构造只处理系数与尾部认证，不替代规范算子定义域、Fourier 基识别或内区残差。

## A. 先核对实际进展

PR 5602 的实际 HEAD `6533227479d52ab09d39f39baa4f45720c1fc133` 已比其说明正文更新。其 `WeilEvenDualStencil` 给出零迹偶 stencil 的实际算术列，`prime3_energy_dual_certificate.json` 报告 c=3、z=20+i/4、半径 1/1000 圆盘上的完整能量对偶认证，中心平方预算上界 103、圆盘上界 107，相对零试探的平方预算改善超过 450 倍。该结果保留其历史强制性、算子域与区间软件条件。本轮读取源码和结果，没有重跑该验证器或将其改善归为本轮结果。

本轮也读取 loning 路线的 `ContinuousAverage.lean`，核对其从特征平均、Fourier 稠密性和一致有界性得到每个初相位连续观测平均的证明。该收敛结论不用于下面的算术尾界，不能把定性稠密性当作定量算子域误差。本节实际复用的是已有 `WeilArithmeticCouplingParityGram.arithmetic_boundary_symbol_neg`，无需引入 #5602 新文件或重复证明实际符号奇性。

## B. 零迹偶合成把三个约束化成一个有限配对

取有限正整数集合 S，并令 U={0}∪S∪(-S)。对复参数 u_n，定义有限系数合成
\[
(L_Su)_m=\sum_{n\in S}u_n(\delta_{m,n}+\delta_{m,-n}-2\delta_{m,0}).
\]
在源码中同一合成使用一般加法群，因而也直接作用于有理复数存储对。它没有构造新的 Fourier 变换。对任意权重 a_m，有限和换序给出
\[
\boxed{\sum_{m\in U}a_m(L_Su)_m
=\sum_{n\in S}(a_n+a_{-n}-2a_0)u_n.}
\]
取常权重，得到总系数和精确为零；取原实际算术符号 s_c，其已有奇性 s_c(-n)=-s_c(n) 及 s_c(0)=0 给出算术矩精确为零。这里不求值任何 s_c(n)，也不把近似抵消视为相等。

若固定精确候选 k 在 U 上为偶系数，则其配对恰为
\[
\boxed{\sum_{m\in U}\overline{k_m}(L_Su)_m
=2\sum_{n\in S}\overline{k_n-k_0}u_n.}
\]
因此只需对参数空间中的对照向量 d_n=k_n-k_0 做一次已有的精确有理正交修正。对照向量为零时约束冗余，保留原参数即可；此情形无需除以零或拒绝有效试探。

## C. 算法输出与不丢失已可行试探

`repairedEvenParameters` 调用已有 `repairTrial S d seed`，成功时使用其返回参数；返回 none 时保留 seed。由已有成功条件证明，后一分支只发生在 d 在 S 上全零时，故同样满足配对约束。`repairedEvenTrial` 再对该同一参数使用 L_S。

源码证明此总定义算法同时产生有限支撑、偶系数、零总系数、零实际算术矩及精确候选正交。任何已满足约束的参数都被逐坐标保留，因此所有已经可行的 L_S 试探都是不动点。特别地，本构造不需要改变 #5602 已通过认证的试探，若其精确系数和候选按相同约定输入。不动点定理没有重验那个谱证书。

当 S 是正频率集合，独立参数的读回为 (L_Su)_n=u_n，中心为 -2∑u_n。对照向量非零时参数空间只减去一条复线性约束；零对照时该约束冗余。这里的欧氏投影发生在参数空间，其范数不等于完整系数范数：
\[
\|L_Su\|_2^2=2\sum_{n\in S}|u_n|^2+4\left|\sum_{n\in S}u_n\right|^2.
\]
例如 d=(1,0)、seed=(1,-1) 投影后参数为 (0,-1)，完整系数平方范数由 4 增为 6。这排除了把参数范数收缩直接用于全系数误差的做法。本轮不声称完整系数范数收缩、最优对偶目标或算法输出必非零。正整数限制用于独立参数的解释；有限和恒等式与最终安全性对任意有限整数 S 仍成立。

## D. 无须符号精度输入的完整立方平方尾认证

由有限和三角不等式，完整系数质量不超过 4∑|u_n|。对精确有理复数 u_n=(p_n,q_n)，可计算有理上界
\[
V=4\sum_{n\in S}(|p_n|+|q_n|).
\]
令 B≥B_c、0<p≤π、H≥|η|、W≥|w|，支撑满足 |n|≤N，并令 Q=4H/3+4BNV/p。原 `residualTailCheck` 现以 D=0 调用。它验收 M>0、M≥2N、M≥2W 和
\[
\boxed{2Q^2\le3\tau M^3.}
\]
新的最终消费者对同一实际算法输出证明完整双侧残差平方可和，且其平方尾质量不超过 τ。输入不含原试探正交、两个矩为零、逐项算术符号中心或误差半径；这些矩约束由构造及原符号奇性导出。算术全局包络、读出参数界、支撑分离与验收仍为明确条件。这里 τ 是平方质量，范数目标 ε 应使用 τ=ε²。

一般试探仍应使用先前的非零矩界和有限符号求值模块。此次零符号精度输入的结论只适用于构造出的零迹偶族；内区残差仍需要实际算术矩阵数据。任意再次逐坐标舍入可能破坏精确总和与正交，必须重新执行修正并重新计算质量。

## E. 外部目标与证明范围

CCM 的 *Zeta Spectral Triples* §8 将真实最低模态与明确 prolate 模型的比较列为缺失步骤。本节直接服务其方向性对偶试探的构造。Suzuki 的 screw-function 框架区分原零边界域与 Friedrichs 扩张域，故零迹条件只用于本节试探，不强加于真实最低模态。Groskin 的有限截断预算同样提醒，有限认证不能替代尺度极限。本轮读取的 arXiv 主记录和 HTML 为 v1；搜索结果另提示更新版本，未成功取得其正文之前不据此断言最新版本的数学改动。

本轮实际执行 Fraction 精确有理诊断：320 组修正、320 个任意权重矩恒等式、320 个参数幂等／可行不动点检查、320 个质量界，以及正支撑实例中的 27 个全系数范数恒等式。覆盖空支撑、零生成元、重复反射生成元、零对照和复候选。六个负控分别省略中心因子 2、误用 k 代替 k−k0、省略共轭、省略反射坐标、修正后不认证地舍入，以及误报全系数范数收缩，均被拒绝。

另从已回读的 `prime3_certificate.json`（blob `3b26da5a8db885821969f13862b2761ccfd98a89`）读取固定 129 维实际候选。六个正频率种子 n=1、2、8、16、32、64，系数为 1+i/3，均产生非零、偶对称、零总和且精确候选正交的试探。六组最大分母位长均为 87，只描述这些实例，不给统一复杂度界。另有 3840 个双侧残差点和 48 个有限尾和检查，使用有界奇模型符号和分母常数 3，不冒充实际 prime-pole-Gamma 或规范 Weil 残差认证。

源码为数学与依赖接口审查后的候选证明。未运行 Lean elaboration、公理闭包或 Scribe 发射，也未重新认证实际 Weil 内区残差、谱间隙或全尺度极限。正支撑的读回与全系数范数公式在本节作纸面解释并作精确有限诊断，未额外作为本模块公开 Lean 定理提交。投影和奇偶抵消均为标准数学，本节的增量是把真实下游使用的三个约束由可执行构造同时保证，并将所得零矩用于完整尾界，未主张数学优先权。

参考：CCM `https://arxiv.org/html/2511.22755v1` §8；Suzuki `https://arxiv.org/html/2606.09096v1` Theorems 1.1、1.4；Groskin `https://arxiv.org/abs/2607.02828`；#5602 `6533227479d52ab09d39f39baa4f45720c1fc133`；既有奇性真源 blob `d74ec78771c2253d3e7a810df44d39b0bbacae40`；loning 路线 `ContinuousAverage` 读取 blob `24004407503e19a1d5eaa38a69b19856d423c399`。
