# ZFC兼容算术

## 情境时空算术：保留档案的表示与精确算术投影

本文构造一种两层算术。丰富层中的对象是带时间、位置、因果偏序和来源的有限事件档案，以及这次参与计数的区域和选择；数值层只读取所选正事件数减去负事件数。丰富层可以区别“同样等于一、却发生在不同地点或来自不同来源”的对象。把数值相同的对象取商以后，指定的加、乘、负运算恰好给出整数算术；分数与全部有理 Cauchy 序列再给出有理数与实数。

“道”在这里是一个有类型的情境整体：先说明在哪个档案和区域内谈可能选择，才谈某个选择的相对补集。这是数学建模的名称，不是关于道、物理宇宙或哲学传统的同一性定理。补集投影为算术负号需要背景总电荷为零；这个条件既不能省略，也不是自然界的先验守恒律。

产地与证明状态：本稿由 `consensus-rnd:sshx` 流程的一个隔离 codex-cli 实施席按调用方批准的综合方案编写。实际 GPT PRO 思考输入及本稿采取的修正见第 12 节。本文给出 ZFC 内的普通数学证明及附录中的有限精确核验；**本稿没有新增 Lean 证明，不能称为 kernel-verified**。最终独立评审、仓库准入与 PR 生命周期由调用方接续，本文不预报其结果。

> **PR1 增补导航与阅读时序（2026-09-09）。** §1–13、命题 1–15 和附录的原运行记录保留为基线叙述；其中“本次”及 §12 的 PRO task 均指原稿那次工作。当前增补由 Codex 实施：[§14 观察同余](#pr1-observation)扩充 §9 的下降判据，[§15 精确空间读数](#pr1-spatial)将 §8 定义 12／命题 9 特化到共同位置，[§16 明确语言下的充分性](#pr1-languages)接通 §8/9，[§17 反例、来源与本轮核验](#pr1-boundaries)说明适用边界。附录仍只有一个 Python 核验块，已在其中追加 PR1 检查。本轮调用与评审状态单列于 §17，不沿用原稿 PRO 成功记录。

> **PR2 增补导航与显式勘界（2026-09-09）。** 本批在固定 PR1 候选上增补：[§18 分层律](#pr2-laws)、[§19 卷积整性与单位](#pr2-units)、[§20 时间摘要及最粗充分性](#pr2-theta)、[§21 整数时标规则](#pr2-time)、[§22 带参考点的空间运输](#pr2-reference)、[§23 来源与核验边界](#pr2-evidence)。§17 的“下一批”“本轮”保留为 PR1 当时的范围记录；§12 仍仅是原稿的旧 PRO 收据。本批不改变定义 6 的默认零参考点及 `max+1`，也不把空间商的环律提升为档案律。新增核验继续放在附录原有唯一 Python 块中。

## 1. 有限情境、整体与类型

固定空间维数 $d=3$。一般结论对任一预先固定的有限 $d\geq1$ 同样成立。令 $HF=V_\omega$ 为遗传有限集合的集合，自然数取有限 von Neumann 序数，有序对取 Kuratowski 编码，有限元组由有序对编码。为保证整数坐标也是有限编码，取 $\mathbb Z_{\rm code}=(\{0\}\times\mathbb N)\cup(\{1\}\times\mathbb N_{>0})$，其中 $(0,m)$ 表示 $m$，$(1,m)$ 表示 $-m$。它与通常整数显式双射，序和算术沿此双射运输；全文把这份实现简记为 $\mathbb Z$。不把通常整数的无限等价类表示直接塞入 $HF$。来源树集合 $T\subset HF$ 由下列有限构造生成：

$$
\operatorname{leaf}(n)\quad(n\in\mathbb N),\qquad
\operatorname{pair}(r,s)\quad(r,s\in T).
$$

叶与有序二叉节点使用不同标签。来源树中的重复叶表示重复引用同一来源；它既不创建新的随机变量，也不证明概率独立。事件出现标识 $e\in HF$ 与来源标识 $\rho(e)\in T$ 是不同数据，多个事件可以具有同一来源树。

**定义 1（情境与丰富整数表示）。** 情境是元组

$$
C=(E,\prec,t,x,\sigma,\rho,\Omega),
$$

其中 $E\subset HF$ 有限，称为档案；$\prec\subset E\times E$ 是严格偏序；$t:E\to\mathbb Z$、$x:E\to\mathbb Z^3$、$\sigma:E\to\{1,-1\}$、$\rho:E\to T$ 为全函数，且

$$
e\prec f\Longrightarrow t(e)<t(f),\qquad \Omega\subseteq E.
$$

$\Omega$ 是本次的**当前整体**，即候选贡献区域。丰富表示是 $X=(C,A)$，其中 $A\subseteq\Omega$ 是本次选中的贡献。档案中的 $E\setminus\Omega$ 不参与本次读数。空档案、空区域和空选择均允许。时间只是本模型的离散时标，偏序不是由距离推导出的光锥关系。

**定义 2（有类型的情境整体）。** 记

$$
\mathcal D_C=(C,\Omega,\mathcal P(\Omega)),\qquad
N_C(A)=\Omega\setminus A.
$$

这就是本文的类道整体。它同时指明语境、论域和该论域上的选择空间。$A$ 是 $\mathcal P(\Omega)$ 的一个元素；若 $K\subseteq\mathcal P(\Omega)$ 是一个可能选择族，则 $\mathcal P(\Omega)\setminus K$ 才是“排除这些可能选择”的另一层补集。后者不是 $N_C(A)$。第 10 节的世界域 $\Gamma$ 又是另一个有类型的集合。

不能把“当前选择”默认为已执行的因果过去。例如令 $E=\Omega=\{e,f\}$、$e\prec f$、$t(e)=0,t(f)=1$、符号分别为 $+1,-1$。$\{e\}$ 向下闭，而其补集 $\{f\}$ 不向下闭。因此在一般偏序中，“所有允许选择向下闭”与“任意选择允许取补”不能同时作为本算术载体的要求。需要执行语义的应用可另取允许历史族 $\operatorname{Adm}_C\subseteq\mathcal P(\Omega)$，但必须重新检查其运算闭包；本文算术核心使用全部子集。

档案的“历史”仅指所写入的事件、偏序、坐标、符号和来源树。它不记录未观测的物理事实，也不自动保存每个中间步骤的选择。下文的乘法保证旧事件结构嵌入结果档案，**不保证从结果恢复所有旧选择或旧当前区域**。

```text
丰富表示 (档案 E；当前区域 Omega；选择 A)
              | 保留事件结构，按指定规则运算
              v
        新档案 / 新区域 / 新选择
              | q = 所选正数 - 所选负数
              v
          整数读数及其算术商
```

## 2. 有符号读数与补集负号

**定义 3。** 对 $A\subseteq\Omega_C$ 定义

$$
q_C(A)=\sum_{e\in A}\sigma(e)
=|\{e\in A:\sigma(e)=1\}|-|\{e\in A:\sigma(e)=-1\}|,
\quad u(C)=q_C(\Omega_C),\quad q(X)=q_C(A).
$$

一般情境允许 $u(C)\ne0$。算术载体 $\mathcal B$ 是所有满足 $u(C)=0$ 的丰富表示的集合，称为平衡表示。对它定义 $N(X)=(C,N_C(A))$。平衡是当前整体相对于这个读数的条件，不要求整个档案平衡，也不要求每个地点或来源分别平衡。

**命题 1（补集恒等式及必要条件）。** 在每个有限情境中，对所有 $A\subseteq\Omega_C$，

$$
q_C(N_C(A))=u(C)-q_C(A),\qquad N_C(N_C(A))=A.
$$

并且 $u(C)=0$ 当且仅当对全部 $A\subseteq\Omega_C$ 都有 $q_C(N_C(A))=-q_C(A)$。

**证明。** $A$ 与 $\Omega_C\setminus A$ 不交且并为 $\Omega_C$，有限和的可加性给出第一式。第二式由 $A\subseteq\Omega_C$ 的逐点成员关系给出；这里完整情境保持不动。若 $u=0$，第一式即负号公式；反向取 $A=\varnothing$，得到 $u=0$。证毕。

下列各物不能互换：

| 操作或对象 | 类型与含义 |
| --- | --- |
| $N_C(A)=\Omega_C\setminus A$ | 另一个贡献子集，是点值运算 $\mathcal P(\Omega_C)\to\mathcal P(\Omega_C)$ |
| $N_C[K]=\{N_C(A):A\in K\}$ | 可能选择族的直接像，不是 $\mathcal P(\Omega_C)\setminus K$ |
| $q_C[K]=\{q_C(A):A\in K\}$ | 可能数值的集合；不能把互斥选择的读数相加当作一次实际读数 |
| $\operatorname{Opp}_C(A)=\{B\subseteq\Omega_C:q_C(B)=-q_C(A)\}$ | 反数值纤维，是子集组成的集合；平衡时包含 $N_C(A)$，通常不止一个元素 |
| $\Gamma\setminus W$，其中 $W\subseteq\Gamma$ | 世界层面的逻辑排除，不对每个世界的贡献逐项取补 |
| 全档案符号翻转 $\sigma\mapsto-\sigma$ | 改变情境、保持选择的另一种表示操作，在一般情境也投影为负号 |
| $-q(X)$ 与 $1/q(X)$ | 前者为加法逆，后者只在非零域上为乘法逆；例如 $-2\ne1/2$ |

例如平衡的非空 $\Omega$ 中，$\operatorname{Opp}_C(\varnothing)$ 至少包含 $\varnothing,\Omega$，故不能把它等同于唯一的补集。用满足 $q(s(n))=n$ 的选定代表函数 $s:\mathbb Z\to\mathcal B$ 定义 $L(X)=s(-q(X))$，虽然也投影为负号，但 $L^2(X)=s(-q(s(-q(X))))=s(q(X))$，一般不等于 $X$。相反，保留完整 $C$ 的 $N^2(X)=X$ 是精确等式；丢掉 $C,A$ 后再选代表不能恢复它们。

## 3. 并行加法、时间复合与档案乘法

所有标签采用固定的集合编码。对两个输入分别使用 $\iota_0(e)=(0,e)$、$\iota_1(f)=(1,f)$；生成事件使用第三个标签 $(2,(a,b))$，因此即使输入档案重合，结果中的出现也不碰撞。标签不会改写来源树中的叶编号。

**定义 4（并行加法）。** $X\boxplus Y$ 的档案、当前区域、选择分别为

$$
\iota_0[E_X]\sqcup\iota_1[E_Y],\quad
\iota_0[\Omega_X]\sqcup\iota_1[\Omega_Y],\quad
\iota_0[A_X]\sqcup\iota_1[A_Y].
$$

时间、位置、符号、来源照抄各自输入，只复制内部偏序，不增加跨输入的因果边。

**定义 5（有守卫的时间复合）。** $X\triangleright Y$ 使用同一带标签并集，但增加全部关系 $\iota_0(e)\prec\iota_1(f)$，其中 $e\in E_X,f\in E_Y$。它的定义域恰为

$$
\forall e\in E_X\ \forall f\in E_Y,\quad t_X(e)<t_Y(f).
\tag{T}
$$

这个条件检查整个档案，空输入时按空真解释。不暗中平移绝对时间。若使用显式时间平移 $T_k(C)$（把所有 $t(e)$ 换成 $t(e)+k$，$k\in\mathbb Z$），则表达式必须写为 $X\triangleright T_k(Y)$。非空有限档案总可选 $k>\max t_X-\min t_Y$ 使之合法，但这已是不同的坐标数据。

**命题 2（两种复合的闭包与读数）。** 并行加法总产生合法情境；时间复合在 $T$ 上产生合法情境；二者的读数均为 $q(X)+q(Y)$，背景电荷均为 $u(C_X)+u(C_Y)$，故均在各自定义域内保持平衡。

**证明。** 并行并集内部的传递性与严格性由输入继承，跨分量无边。时间复合中的跨边全部从左向右，内部边接跨边仍是已经加入的跨边，所以关系传递、无环；每条内部边时间递增，每条跨边由 $T$ 时间递增。有限和分别在两个不交分量上求和，得读数公式；用当前整体替换选择得到背景公式。证毕。

**定义 6（档案乘法）。** $P=X\boxtimes Y$ 的档案为

$$
E_P=\iota_0[E_X]\sqcup\iota_1[E_Y]\sqcup
\{p_{ab}=(2,(a,b)):a\in\Omega_X,b\in\Omega_Y\}.
$$

旧事件的四个属性照抄。每个新事件满足

$$
\begin{aligned}
t_P(p_{ab})&=\max(t_X(a),t_Y(b))+1,\\
x_P(p_{ab})&=x_X(a)+x_Y(b),\\
\sigma_P(p_{ab})&=\sigma_X(a)\sigma_Y(b),\\
\rho_P(p_{ab})&=\operatorname{pair}(\rho_X(a),\rho_Y(b)).
\end{aligned}
$$

保留两份旧偏序，加入 $\iota_0(a)\prec p_{ab}$ 与 $\iota_1(b)\prec p_{ab}$，然后取传递闭包。当前整体与选择是

$$
\Omega_P=\{p_{ab}:a\in\Omega_X,b\in\Omega_Y\},\qquad
A_P=\{p_{ab}:a\in A_X,b\in A_Y\}.
$$

旧事件只入档案、不重复计数。新当前整体使用所有候选对，不能用所选对替代它，否则补集的背景也被改了。

**命题 3（乘法合法、精确投影与档案保留）。** 档案乘法总产生合法有限情境，且

$$
q(X\boxtimes Y)=q(X)q(Y),\quad
u(C_P)=u(C_X)u(C_Y),\quad
|E_P|=|E_X|+|E_Y|+|\Omega_X||\Omega_Y|.
\tag{P}
$$

因此 $\mathcal B$ 对乘法封闭。每个输入档案通过带标签映射嵌入 $E_P$，其内部偏序被保持和反映，四个属性被原样保持；即使一因子的读数为零或当前区域为空，也保留两份输入档案。

**证明。** 生成关系的每条边都严格增加整数时间：旧边由假设保证，新增父边由 $\max+1$ 保证。沿任何非空路径，时间仍严格增加，因此传递闭包无自环且满足时标条件。它是有限集合 $E_P^2$ 的子集，可由长度至多 $|E_P|-1$ 的路径刻画，故存在且有限。新节点无出边，不能经它绕回任何旧档案；旧两分量之间也无路径，所以限制在任一旧分量上的关系正是原关系。三个标签互斥，立即给出基数公式。最后分配有限双重和：

$$
\sum_{a\in A_X}\sum_{b\in A_Y}\sigma_X(a)\sigma_Y(b)
=\left(\sum_{a\in A_X}\sigma_X(a)\right)
 \left(\sum_{b\in A_Y}\sigma_Y(b)\right).
$$

把 $A_X,A_Y$ 分别替换为 $\Omega_X,\Omega_Y$ 即得背景公式。空区域时新事件为空，但两个旧档案仍在并集中。证毕。

这里的嵌入是**档案嵌入**，不是第 8 节保持当前区域的情境嵌入：旧当前区域在乘法之后退入档案。尤其 $X\boxtimes 0_\varnothing$ 不编码 $A_X$，因为新选择总为空；不同旧选择可以产生同一个结果。保留已写入事件与恢复全部操作历史是不同保证。

## 4. 三种相等与整数商

**定义 7。** 区别以下三种关系。

1. **编码相等** $X=Y$：整个集合编码逐项相等，含事件标签。
2. **历史同构** $X\cong_hY$：存在双射 $h:E_X\to E_Y$，保持和反映偏序，逐事件保持 $t,x,\sigma,\rho$，并满足 $h[\Omega_X]=\Omega_Y$、$h[A_X]=A_Y$。本定义不把来源重命名或坐标变换自动当作相等。
3. **数值等价** $X\sim Y$：$q(X)=q(Y)$。

编码相等蕴含历史同构，历史同构由有限和重索引蕴含数值等价。反向均失败：重命名事件可改变编码却保留历史同构；第 5 节的并行与时间复合读数相同而因果边数不同。读数连同纤维中的具体点可以表述原对象，但读数本身不能选择原点。

**定义 8（固定整数代表）。** 对 $n\in\mathbb Z$，令 $m=|n|$，取

$$
E_n=\Omega_n=\{(i,s):0\le i<m,\ s\in\{+1,-1\}\}.
$$

偏序为空，所有时间和位置为零，符号为 $s$，来源为 $\operatorname{leaf}(i)$。若 $n>0$ 选全部正事件；若 $n<0$ 选全部负事件；若 $n=0$ 全部数据为空。所得表示记 $\mathbf i(n)$。它满足 $u=0,q=n$。记 $0_\varnothing=\mathbf i(0)$、$U=\mathbf i(1)$。固定代表是取商的截面，不是被忘历史的重建算法。

**命题 4（整数算术同构）。** $\sim$ 是 $\mathcal B$ 上的等价关系，并且是 $\boxplus,\boxtimes,N$ 的同余关系。商集 $\mathbb Z_{\rm st}=\mathcal B/{\sim}$ 在这些诱导运算下是与 $\mathbb Z$ 同构的环，唯一指定的同构为

$$
\bar q_{\mathbb Z}([X])=q(X).
$$

在 $q\ge0$ 的表示子集上，仅用加、乘、零、一取商，得到 $\mathbb N$ 的半环；负号不封闭于该子集。

**证明。** 等价关系来自整数相等。若输入读数相同，命题 1、2、3 表明操作后的读数也相同，故商上运算良定义。商映射由定义良定义且单射，由 $\mathbf i(n)$ 满射，且保加、乘、负、零、一。任一环恒等式两侧经它映到整数中的同一值；单射性把等式带回商上，包括结合、交换、分配、加法逆及乘法单位律。因此是环同构，而不是先假定丰富层已经是环。非负部分以同样方法对应自然数，得最后结论。证毕。

原始历史层的较强结论有具体反例。若 $X$ 的档案非空，则 $X\boxplus N(X)$ 有 $2|E_X|>0$ 个事件，不能与空档案同构，虽读数为零。任意与 $X$ 并行相加的表示都不能使档案变空，所以非空表示没有相对于空档案的原始加法逆。这**不推出消去律失败**：在固定标签的编码相等下，从 $X\boxplus Y=X\boxplus Z$ 取右标签分量并去标签，反而立即得到 $Y=Z$。

任一平衡的数值一表示 $V$ 至少有两个当前事件及两个档案事件；由 $P$，对所有 $X$，

$$
|E_{X\boxtimes V}|=|E_X|+|E_V|+|\Omega_X||\Omega_V|>|E_X|.
$$

所以它不是原始历史层的乘法单位。原始乘法甚至不必结合到历史同构：取 $X=Y=\mathbf i(1)$、$Z=\mathbf i(2)$，其 $(|E|,|\Omega|)$ 分别为 $(2,2),(2,2),(4,4)$，则

$$
|E_{(X\boxtimes Y)\boxtimes Z}|=8+4+4\cdot4=28,
\quad |E_{X\boxtimes(Y\boxtimes Z)}|=2+14+2\cdot8=32.
$$

两者读数都为 $2$。这些计数针对本稿保留档案的乘法，不是单纯 Cartesian 事件乘法的计数。

## 5. 一个完整的时空算例

以下位置只列第一坐标，另外两维为零。令 $E_X=\Omega_X=\{a,b,c,d\}$，选择 $A_X=\{a,b,c\}$；$E_Y=\Omega_Y=\{r,s\}$，选择 $A_Y=\{r\}$。

| 事件 | 时间 | 位置第一坐标 | 符号 | 来源 |
| --- | --- | --- | --- | --- |
| $a$ | 0 | 0 | $+1$ | leaf(7) |
| $b$ | 1 | 2 | $+1$ | leaf(7) |
| $c$ | 1 | 1 | $-1$ | leaf(8) |
| $d$ | 2 | 3 | $-1$ | leaf(8) |
| $r$ | 3 | 10 | $+1$ | leaf(7) |
| $s$ | 4 | 10 | $-1$ | leaf(9) |

$X$ 的偏序为 $a\prec b,c\prec d$，$Y$ 的偏序为 $r\prec s$。两个整体均平衡，$q(X)=q(Y)=1$，$N(X)$ 只选 $d$，读数为 $-1$。并行和与时间复合都合法、读数都是 $2$，都有六个档案事件；前者有三对严格可比事件，后者增加八个跨输入关系而有十一对，故不同历史。

乘积有六个旧档案事件和八个新候选事件，总计十四个；当前只计新事件。三个所选新事件为

| 事件 | 时间 | 位置第一坐标 | 符号 | 来源 |
| --- | --- | --- | --- | --- |
| $p_{ar}$ | 4 | 10 | $+1$ | pair(leaf(7), leaf(7)) |
| $p_{br}$ | 4 | 12 | $+1$ | pair(leaf(7), leaf(7)) |
| $p_{cr}$ | 4 | 11 | $-1$ | pair(leaf(8), leaf(7)) |

因此乘积读数 $1+1-1=1$，新背景有四正四负，仍平衡。传递闭包共有二十七对严格可比事件。重复的来源 7 仍是同一个叶标识；两次出现及两次引用由不同事件标签保留。

$X\boxtimes0_\varnothing$ 有四个旧档案事件、空当前整体和空选择，读数为零。若把 $Y$ 改为选择 $\{r,s\}$ 的数值零，乘积仍有十四个档案事件、八个当前事件、六个所选事件，读数也是零。普通数值零不意味着没有事件、没有来源或没有可供后续结构观察的记录。

## 6. 有理数表示与精确除法

**定义 9。** 令 $\mathcal Q^{\rm rich}=\{(X,Y)\in\mathcal B^2:q(Y)\ne0\}$，记 $v(X,Y)=q(X)/q(Y)\in\mathbb Q$，这里右端的 $\mathbb Q$ 是 ZFC 中标准整数分数构造。定义

$$
(X,Y)\sim_{\mathbb Q}(X',Y')
\quad\Longleftrightarrow\quad q(X)q(Y')=q(X')q(Y).
$$

对 $R=(X,Y),S=(Z,W)$，取以下丰富运算；每次出现的 $\boxplus,\boxtimes,N$ 均为前述档案运算：

$$
\begin{aligned}
R\boxplus_{\mathbb Q}S&=((X\boxtimes W)\boxplus(Z\boxtimes Y),\ Y\boxtimes W),\\
R\boxtimes_{\mathbb Q}S&=(X\boxtimes Z,\ Y\boxtimes W),\\
N_{\mathbb Q}(R)&=(N(X),Y),\\
R^{-1}_{\mathbb Q}&=(Y,X)\quad\text{仅当 }q(X)\ne0,\\
R\div_{\mathbb Q}S&=(X\boxtimes W,\ Y\boxtimes Z)
\quad\text{仅当 }q(Z)\ne0.
\end{aligned}
$$

**命题 5（有理数商与除法守卫）。** 这些运算在所写域上封闭，$\sim_{\mathbb Q}$ 是同余关系，$\mathcal Q^{\rm rich}/{\sim_{\mathbb Q}}$ 经 $[R]\mapsto v(R)$ 与标准有理数域同构；求逆与除法的定义域只由相应数值等价类决定。

**证明。** 非零整数分母 $b,d$ 的乘积 $bd\ne0$，故加、乘后的分母合法。求逆后的分母是原分子，除法后的分母是 $bc$，所以额外守卫恰是 $c\ne0$。在非零分母上，交叉相乘等价于标准分数相等，因而 $\sim_{\mathbb Q}$ 自反、对称、传递。也可直接验证传递性：由 $ad=cb$ 与 $cf=ed$ 得 $adf=bed$，消去非零的 $d$ 得 $af=be$。命题 1 至 3 把上述读数依次化为 $(ad+cb)/(bd)$、$ac/(bd)$、$-a/b$、$b/a$、$ad/(bc)$，正是有理运算。因此输入等价时输出等价，守卫也不随代表而变。商映射由等价的定义单射；任一 $a/b$ 由 $(\mathbf i(a),\mathbf i(b))$ 表示，故满射。域定律由双射和运算保持性传递。证毕。

以后固定截面 $s_{\mathbb Q}(a/b)=(\mathbf i(a),\mathbf i(b))$，其中取唯一既约形式 $b>0$，零写为 $0/1$；整数嵌入为 $X\mapsto(X,U)$。例如丰富公式给出的 $(1/2)+(-3/2)=-1$、$(1/2)(-3/2)=-3/4$、$(1/2)/(-3/2)=-1/3$ 都是精确等式的投影，不是浮点近似。

**整数域内的除法另有条件。** 若要求结果仍在 $\mathbb Z$，必须同时满足 $q(Y)\ne0$ 与 $q(Y)\mid q(X)$；商数 $k$ 是满足 $q(X)=kq(Y)$ 的唯一整数，可用 $\mathbf i(k)$ 选代表。这个额外选择不保存输入档案。若保留分数表示 $(X,Y)$，则它仍携带两份输入，且在可整除时代表同一个整数值。$1/2$ 不在整数精确除法的域内，但在有理除法的域内；截断除法、带余除法是另外的操作，不在此冒充域除法。

## 7. 全部实数、有限前缀与表达式兼容性

**定义 10（丰富实数表示）。** 令

$$
\mathcal R^{\rm rich}=
\{R:\mathbb N\to\mathcal Q^{\rm rich}:a_n=v(R_n)\text{ 在 }\mathbb Q\text{ 中为 Cauchy 序列}\}.
$$

“Cauchy”指对每个有理 $\varepsilon>0$，存在 $N$，使所有 $m,n\ge N$ 满足 $|a_m-a_n|<\varepsilon$。这里取的是**全部**满足条件的序列，不限于可计算序列或有限程序可命名的序列。定义 $R\sim_{\mathbb R}S$ 当且仅当 $v(R_n)-v(S_n)\to0$。序列指标 $n$ 表示近似精度，不是事件的物理时间；不把这些有限图说成具有已证明的连续时空极限。

加、乘、负逐项使用第 6 节的丰富公式。常数嵌入是有理表示的常值序列。按 ZFC 中的标准有理 Cauchy 完备化记 $\widehat{\mathbb Q}$；其元素是 Cauchy 序列模零序列差的等价类。暂记 $\ell(R)=[(v(R_n))]\in\widehat{\mathbb Q}$，不先假定每个实数已经有某个有限事件编码。

**命题 6（实数完备化与合法求逆）。** 上述逐项运算对 $\mathcal R^{\rm rich}$ 封闭，等价关系是同余关系；映射 $[R]\mapsto\ell(R)$ 是到标准实数域 $\widehat{\mathbb Q}\cong\mathbb R$ 的同构。对于一条 Cauchy 读数序列 $a_n$，以下条件等价：

$$
[(a_n)]\ne0
\quad\Longleftrightarrow\quad
\exists\delta\in\mathbb Q_{>0}\ \exists N\ \forall n\ge N,
\ |a_n|\ge\delta.
\tag{R}
$$

在这个定义域上，求逆可逐项**完整**定义为

$$
(\operatorname{Inv}R)_n=
\begin{cases}
(R_n)^{-1}_{\mathbb Q},&a_n\ne0,\\
R_n\boxplus_{\mathbb Q}N_{\mathbb Q}(R_n),&a_n=0.
\end{cases}
\tag{I}
$$

第二分支是合法的丰富有理零，不包含除以零；在 (R) 上，它只会在有限前缀被使用。实数除法定义为逐项乘以 (I)，只要求**除数实数类非零**。

**证明。** 先记录 Cauchy 序列的有界性：取误差 $1$ 的尾部阈值，尾部绝对值至多某个固定项绝对值加 $1$；有限前缀也有最大绝对值，合并即得统一有理界。和与负的 Cauchy 性来自三角不等式。对有界 Cauchy 序列 $a,b$，若 $|a_n|,|b_n|\le M$，可取 $M\ge1$，则

$$
|a_mb_m-a_nb_n|
\le M|b_m-b_n|+M|a_m-a_n|.
$$

各差取小于 $\varepsilon/(2M)$ 即证明乘法封闭。零差关系的传递性也由三角不等式给出；若 $a-a'\to0,b-b'\to0$，利用统一界和
$a_nb_n-a'_nb'_n=a_n(b_n-b'_n)+b'_n(a_n-a'_n)$，证明乘法与换代表相容。加法与负号同理。因此 $\ell$ 良定义，且由等价关系的定义在商上单射。任意有理 Cauchy 序列 $a$ 可逐项提升为 $s_{\mathbb Q}(a_n)$，故满射，且保运算。

这里用到的标准完备化结论有明确构造内容：常值有理序列嵌入，两个类之差非零时，下面证明的尾部下界与 Cauchy 性使其符号最终固定，据此定义严格序；正性对换代表不变并给出全序域。常值有理类在其中稠密，因为任一 Cauchy 序列的充分后项作为常数，与原类任意接近。若 $c_k$ 是这个商中的 Cauchy 类序列，逐个选有理数 $r_k$ 使 $|c_k-r_k|<2^{-k}$。三角不等式给出 $r_k$ 是有理 Cauchy 序列；其类 $c=[(r_k)]$ 满足 $|c-c_k|\le |c-r_k|+2^{-k}\to0$，其中首项趋零直接来自 $r$ 的 Cauchy 性。这证明序列完备。每个类由有界有理序列表示，故有整数界，域是阿基米德的。对任意非空有上界子集 $S$，选有理上界 $u_0$ 及小于某个成员的有理数 $l_0$；后者不是上界，不要求它是整个 $S$ 的下界。二分区间，每一步保持 $u_n$ 为上界、$l_n$ 不是上界，长度趋零。两端点是 Cauchy 序列并趋于同一个类 $c$。若某成员大于 $c$，充分后的 $u_n$ 就小于该成员，与上界矛盾；若 $b<c$，充分后的 $l_n>b$，而存在成员大于 $l_n$，故 $b$ 不是上界。于是 $c$ 是最小上界，得到标准 Dedekind 完备的阿基米德有序域，即 ZFC 中通常的实数构造。本文对其采用的是标准完备化，不增加连续性或完备性公理。

再证 (R)。若 $a$ 不是零序列，存在有理 $\varepsilon>0$，使每个尾部都有一项 $|a_j|\ge\varepsilon$。在 Cauchy 误差 $\varepsilon/2$ 的尾部中，给任一项 $a_n$ 选同尾部这样一个 $a_j$，得到 $|a_n|>\varepsilon/2$，可取 $\delta=\varepsilon/2$。反向，尾部下界显然排除趋零。尾部若还取两项差小于 $\delta$，它们不能异号，否则差至少 $2\delta$；这也证明前述符号最终固定。条件只由零差类决定：若 $a-b\to0$，$a$ 的下界 $\delta$ 在 $b$ 的充分后段给出 $\delta/2$ 下界。

在 (R) 上，(I) 的读数后段就是 $1/a_n$，并有

$$
\left|\frac1{a_m}-\frac1{a_n}\right|
\le\frac{|a_m-a_n|}{\delta^2}.
$$

故倒数读数为 Cauchy。若 $a\sim b$，分别取正下界 $\delta_a,\delta_b$，则后段

$$
\left|\frac1{a_n}-\frac1{b_n}\right|
\le\frac{|a_n-b_n|}{\delta_a\delta_b}\longrightarrow0.
$$

所以求逆不依赖代表；乘回原序列的后段恒为 $1$，有限前缀之差是零序列，故商上是乘法逆。有限前缀任意合法替换不改变类，是因为任一给定误差只需把阈值移到该前缀之后。由双射，全部有序域运算与完备性传递到丰富表示的商。证毕。

两个守卫测试不能混为一谈：$(0,1,1,\ldots)$ 表示非零实数 $1$，(I) 得到合法读数 $(0,1,1,\ldots)$，所以要求每项非零过强；$(1,1/2,1/3,\ldots)$ 每项非零，却表示零类，它的逐项倒数 $(1,2,3,\ldots)$ 非 Cauchy，因为任一尾部相邻项距离都是 $1$，所以要求每项非零又不足以保证实数求逆。这是对全序列的证明；附录只检查其有限前缀，不据有限数据判定任意实数是否非零。

没有声称存在可判定的非零实数谓词。(I) 在声明的域上是 ZFC 定义的函数；一般实数的域判定不因此成为可执行判定算法。若从标准实数 $r$ 出发，固定有理近似 $a_n=2^{-n}\lfloor2^nr\rfloor$ 满足 $0\le r-a_n<2^{-n}$，逐项取 $s_{\mathbb Q}(a_n)$ 给出一个丰富表示；所有实数都能这样表示，但并非都由有限字符串或可计算序列表示。

**命题 7（全部有限算术表达式的兼容性）。** 在整数、有理数、实数任一上述层级，取有限的带括号表达式，常数使用固定代表，变量赋以相应丰富表示，运算仅为该层指定的加、乘、负及合法的除法。若每个除法节点满足该层守卫，则丰富求值存在，并且

$$
\operatorname{readout}(\operatorname{Eval}_{\rm rich}(F))
=\operatorname{Eval}_{\rm usual}(F;\operatorname{readout}\text{ 各变量}).
$$

两个合法表达式的普通值相等，当且仅当其结果在该层的数值商中相等；这里不把历史相等解释成普通数相等。

**证明。** 对表达式树作结构归纳。变量和常数由定义成立。加、乘、负节点由子树归纳假设及命题 1 至 6 的相应保持公式成立。除法节点的定义域由读数决定，子树的读数一致故守卫一致；在该域上相应商数公式给出归纳步骤。整数精确除法还使用非零除数下商数的唯一性。相等结论由各层数值等价的定义或商映射单射性成立。证毕。

这一定理不把空间筛选、时间复合的可执行性或任意历史查询都说成旧标量的函数。它们的精确下降条件如下。

## 8. 情境扩张、粗观察与坐标运输

**定义 11（本稿采用的情境嵌入）。** $j:C\hookrightarrow D$ 是单射 $j:E_C\to E_D$，保持四个属性，满足
$e\prec_C f\iff j(e)\prec_D j(f)$，以及 $j[\Omega_C]=\Omega_D\cap j[E_C]$。最后一项既将旧当前整体嵌入新当前整体，也不把旧非当前事件暗中激活。选中部分运输为 $j[A]$。这是明确采用的一类结构保持扩张；更一般的激活或属性改写不自动属于此定义。

**命题 8（扩张的补集缺项）。** 记新增当前区域 $R=\Omega_D\setminus j[\Omega_C]$。则

$$
\begin{aligned}
q_D(j[A])&=q_C(A),\\
\Omega_D\setminus j[A]&=j[\Omega_C\setminus A]\sqcup R,\\
q_D(\Omega_D\setminus j[A])-q_C(\Omega_C\setminus A)&=\sum_{e\in R}\sigma_D(e).
\end{aligned}
$$

所以补集精确交换运输当且仅当 $R=\varnothing$；补集读数交换运输当且仅当新增区域电荷为零。如果 $C,D$ 都平衡，后一条件自动成立，但前一条件仍可能失败。

**证明。** 单射且保持符号，有限和重索引给出第一式。一个新整体中的未选点，要么在旧整体的像中而对应未选旧点，要么在 $R$ 中，且两类不交，给出第二式。对第二式求电荷得第三式。由于两类不交，新增类非空便破坏集合相等；标量相等则恰好要求其有限和为零。对全体旧当前点应用第一式，得 $u(D)=u(C)+q_D(R)$，从而得到平衡推论。证毕。

**递增地平线的具体例子。** 令 $E_n=\Omega_n=\{(i,s):i<n,s\in\{1,-1\}\}$，时间 $i$，位置 $(i,0,0)$，来源 leaf($i$)，符号 $s$，同符号链 $(i,s)\prec(j,s)\iff i<j$，异符号间无序。包含映射形成递增情境族，每次添一正一负而保持平衡。任一固定有限选择在足够大的地平线上可继续运输，补集集合随地平线扩大但其读数按命题 8 保持。其可数并当然是 ZFC 集合，却已不在有限载体中：正负项各无穷，本文没有给其整体定义 $\infty-\infty$。按每对先正后负枚举，部分和交替为 $1,0$，不收敛；按对分组得零是另一种额外求和约定，不能偷渡为无条件无穷总和。

**定义 12（带背景的粗观察）。** 取有限 bin 集合 $B$ 和映射 $f:\Omega_C\to B$，不要求满射。定义

$$
O_f(X)=(B,w,z),\quad
w(b)=\sum_{e\in\Omega_C,\ f(e)=b}\sigma(e),\quad
z(b)=\sum_{e\in A,\ f(e)=b}\sigma(e).
$$

这里 $w,z:B\to\mathbb Z$ 是电荷而不是布尔占据；bin 可承载 $2,-3,0$ 等整数，不必是一个符号为 $\pm1$ 的新事件。粗观察本身也没有自动携带新的合法因果偏序。

**命题 9（粗观察公式）。** 有 $q(X)=\sum_bz(b)$、$u(C)=\sum_bw(b)$，且补集的粗观察为 $(B,w,w-z)$。对有限集合 $D$ 和映射 $g:B\to D$ 定义 $(g_*z)(d)=\sum_{b:g(b)=d}z(b)$，则 $O_{g\circ f}=(D,g_*w,g_*z)$，连续粗化满足 $(h\circ g)_*=h_*g_*$。并行和可取带标签 bin 并集，分别复制两个 $w,z$；若两侧本来映到同一 bin 集合，再去掉 bin 标签，结果为 $(w_X+w_Y,z_X+z_Y)$。乘积的 bin 映射在**新当前事件**上定义为 $p_{ab}\mapsto(f_X(a),f_Y(b))$，满足

$$
w_P(b,c)=w_X(b)w_Y(c),\qquad z_P(b,c)=z_X(b)z_Y(c).
$$

再按 $h:B_X\times B_Y\to D$ 合 bin 时，分别对这些乘积作 $h_*$，而不是把旧档案再次计入。

**证明。** 各纤维是有限论域的不交分割，总和可分组；每个纤维内的“未选电荷”为背景减所选电荷。复合推送是把同一个有限和先分两次组或一次分组，两者逐项相同。并行公式是两份不交和的相加；乘积一个 bin 对上的选择恰为对应两个所选纤维的 Cartesian 积，有限双和分配即得公式。证毕。

例如一正一负分别落在两个 bin 时，整体 $u=0$，但 $w=(1,-1)\ne(0,0)$；选择正项有 $z=(1,0)$，补集为 $w-z=(0,-1)$，不是 $-z=(-1,0)$。因此标量平衡不足以推出每个空间 bin 或来源各自平衡。

**命题 10（直接像补集的精确边界）。** 若 $f:\Omega\twoheadrightarrow B$ 满射、$A\subseteq\Omega$，则

$$
f[\Omega\setminus A]=B\setminus f[A]
\quad\Longleftrightarrow\quad A=f^{-1}[f[A]].
$$

右端称为纤维饱和，即每个纤维全选或全不选。

**证明。** 饱和时，一个 bin 在 $f[A]$ 中即其全部原像都在 $A$，否则满射保证它有一个不在 $A$ 的原像，所以两侧互为补集。反向，若某个纤维既有选点又有未选点，其 bin 同时属于 $f[A]$ 和 $f[\Omega\setminus A]$，与等式右侧的不交性矛盾。证毕。

反例：$\Omega=\{a,b,c\}$，$f(a)=f(b)=0,f(c)=1,A=\{a\}$，则 $f[\Omega\setminus A]=\{0,1\}$，而 $\{0,1\}\setminus f[A]=\{1\}$。不满射时需把论域改为 $f[\Omega]$，否则未命中的 bin 也会破坏补集式。任意映射的**逆像**则总满足 $f^{-1}[V\setminus U]=f^{-1}[V]\setminus f^{-1}[U]$，由成员逻辑立即成立。

如果还要把粗观察实现成一个每点符号为 $\pm1$ 的新情境，对全部饱和选择保电荷的条件是每个纤维总电荷恰等于目标符号；充分性由分组求和得出，必要性取单一完整纤维。它不覆盖任意非饱和选择，且许多纤维电荷根本不是 $\pm1$。若强行把两个所选正事件合成一个正事件，读数就从 $2$ 变成 $1$。

因果运输另有障碍：原档案只有 $a\prec b,c\prec d$，时间分别 $0,1,0,1$。将 $a,d$ 合并为 $L$，$b,c$ 合并为 $R$，会得到 $L\prec R\prec L$。因此任意事件合并不能被称作合法情境商；时间与偏序的运输须另外证明。

**坐标运输的确切范围。** 给定整数矩阵 $M$，把所有位置换成 $Mx$ 仍是合法情境，且 $M(x+y)=Mx+My$ 保证它与档案乘法交换。非单射 $M$ 可以丢失空间信息；$M\in GL_3(\mathbb Z)$ 才给出可逆的这种坐标变换，而固定坐标定义下的历史同构仍要求坐标值相等。共同空间平移 $x\mapsto x+v$ 与乘法一般不交换：先平移两个输入，新事件位置为 $x+y+2v$；先乘再平移为 $x+y+v$。共同整数时间平移则满足 $\max(t+k,s+k)+1=\max(t,s)+1+k$，保持乘法及 (T)。任意严格递增时间重标虽保持输入偏序，却不一定保持 $\max+1$；例如乘以 $2$ 把生成时间的增量变为 $2$ 而非 $1$。来源运输也须保持叶的共享关系与 pair 构造。空间筛选要随坐标变换运输其区域，固定区域的读数一般会变。本文据此只声明所写结构的运输条件，不声明一般时空协变或物理对称性。

## 9. 结构运算与不能下降的精确原因

**定义 13（结构筛选）。** 对空间区域 $S\subseteq\mathbb Z^3$、来源树集合 $L\subseteq T$、档案子集 $D\subseteq E_C$，定义

$$
\begin{aligned}
F_S(C,A)&=(C,\{e\in A:x(e)\in S\}),\\
F_L(C,A)&=(C,\{e\in A:\rho(e)\in L\}),\\
F_{\downarrow D}(C,A)&=(C,\{e\in A:\exists d\in D\ (e=d\ \lor\ e\prec d)\}).
\end{aligned}
$$

这些操作只改选择，完整背景不变，故均保留平衡情境。也可按“来源树含某个叶”取 $L$，以观察复合来源。它们是 ZFC 定义的合法丰富运算，但通常不是旧读数的函数。

第 5 节在同一个 $C_X$ 中取 $A=\{a,b,c\}$、$A'=\{a\}$，二者读数都为 $1$。空间区域 $x_1\ge2$ 筛选后分别为 $1,0$；来源集合 $\{\operatorname{leaf}(7)\}$ 筛选后分别为 $2,1$；$D=\{b\}$ 的因果过去筛选后也是 $2,1$。因此同数值仍可在空间、来源和因果观测上有可计算的差别，时空不是附在数字上的无作用装饰。

**命题 11（总操作与部分操作的下降判据）。** 设 $q:\mathcal X\twoheadrightarrow Q$ 为满射，$U:\mathcal X\to\mathcal X$ 是确定性总操作。存在唯一 $\bar U:Q\to Q$ 使 $q\circ U=\bar U\circ q$，当且仅当

$$
q(X)=q(Y)\Longrightarrow q(U(X))=q(U(Y)).
\tag{D}
$$

对部分操作 $U:D\to\mathcal X$，若下降还须保留**恰好相同的定义域**，则另外且恰好要求 $D=q^{-1}[q[D]]$，并要求 (D) 对 $X,Y\in D$ 成立。多元版本把 $q$ 换成乘积读数，结论相同。

**证明。** 有下降时，等输入读数经同一函数必有等输出读数；部分版本的定义域必须是某个 $Q$ 子集的全逆像，故饱和。反之，总操作令 $\bar U(r)$ 为纤维 $q^{-1}(r)$ 中任一元素经 $U$ 后的读数，(D) 保证它是唯一值，满射保证存在，故其图定义一个唯一函数，无须把某个选点说成原历史。部分版本在 $q[D]$ 上用同一构造；饱和性使其拉回域恰等于 $D$。证毕。

时间复合说明部分域条件不可省。$X=Y=U$ 的时间全为零，所以 $(X,Y)$ 不满足 (T)；把第二个 $U$ 的时间显式平移到 $1$，两个输入的数值仍为 $(1,1)$，但此时可以时间复合。它的输出读数在合法域上总是和，却不能把“何时可复合”仅凭两个旧整数完整表达。

**定义 14（关系限制的乘积选择）。** 给定 $R\subseteq\Omega_X\times\Omega_Y$，使用定义 6 的**完整乘积情境**，只把选择改为 $\{p_{ab}:(a,b)\in(A_X\times A_Y)\cap R\}$，记 $X\boxtimes_RY$。例如 $R$ 可由空间距离、来源匹配或明定的跨情境关系给出。

**命题 12（遗漏对电荷与普适性障碍）。** 对固定输入情境与固定 $R$，

$$
q(X\boxtimes_RY)=q(X)q(Y)-
\sum_{(a,b)\in(A_X\times A_Y)\setminus R}\sigma_X(a)\sigma_Y(b).
$$

对所有选择都与普通乘法兼容，当且仅当 $R=\Omega_X\times\Omega_Y$。

**证明。** 将全部所选对分成保留对和遗漏对，有限和相减即第一式。全保留时修正项为空。若缺少任何一对 $(a,b)$，取单点选择 $A_X=\{a\},A_Y=\{b\}$，受限输出为零而原乘积为 $\sigma_X(a)\sigma_Y(b)\in\{1,-1\}$，所以全称断言失败。证毕。

在第 5 节取关系 $|x_1(a)-x_1(b)|\le9$，其中左、右自变量分别来自两个输入；它从所选三对中恰去掉 $(a,r)$。于是受限读数 $1-1=0$，遗漏电荷为 $1$，与完整乘积读数 $1$ 的差精确对应。不能只改配对规则，再继续无条件引用普通乘法公式。

## 10. 不确定历史与共同来源

**定义 15（同一世界上的语义）。** 取一个集合 $S$ 的来源变量名，每个变量 $s$ 有非空值域 $V_s$，选择一个**非空**联合赋值域

$$
\Gamma\subseteq\prod_{s\in S}V_s.
$$

不确定丰富状态是函数 $H:\Gamma\to\mathcal B$，或有理、实数层的相应函数。若固定情境，可写成 $H(\gamma)=(C,A(\gamma))$；允许情境随世界而变时，仍须逐世界满足全部类型与平衡条件。变量名可与来源树中的自然数叶对应；一个共同来源的多次引用必须使用同一个 $\gamma(s)$。

若声称 $H$ 只依赖 $S_0\subseteq S$，其精确定义是：任意 $\gamma,\eta\in\Gamma$ 在 $S_0$ 上相同，就有 $H(\gamma)=H(\eta)$。来源标签本身不证明这个性质，也不证明 $S_0$ 最小。多个满足此条件的函数经指定点态运算，至多依赖它们依赖域的并；是否还能缩小由函数本身决定。在数值层，$t-t$ 就是依赖可以完全消失的例子。

**联合约束不能从边缘读数推定。** 对 $\Gamma_i\subseteq\prod_{s\in S_i}V_s$，自然连接

$$
J=\{\gamma\in\prod_{s\in S_1\cup S_2}V_s:
\gamma|_{S_1}\in\Gamma_1,\ \gamma|_{S_2}\in\Gamma_2\}
$$

是兼容这两组局部条件的**最大**域。实际联合模型可为 $\Gamma=J\cap K$，其中 $K$ 保存所有额外联合约束。即使 $S_1\cap S_2=\varnothing$，仍不能从变量名不同推出 $K=J$。例如两个变量各取 $\{1,2\}$，实际域只允许 $(1,1),(2,2)$，它的两个边缘都是全值域，但两个交叉组合都不允许。若另外给了概率测度，概率独立要求联合测度的相应分解；provenance 或域为 Cartesian 积均不单独证明它。$\Gamma=\varnothing$ 表示约束不相容，不能冒充数值零；零值模型在非空域上给出像 $\{0\}$，不相容模型的像是空集。

**命题 13（共同世界上的点态算术）。** 对所有函数在同一非空 $\Gamma$ 上点态求值，命题 7 的兼容性逐世界成立；随后才取可能值像

$$
\operatorname{Poss}_\Gamma(F)
=\{\operatorname{Eval}_{\rm usual}(F; q(H_1(\gamma)),\ldots,q(H_k(\gamma))):\gamma\in\Gamma\}.
$$

其中 $q$ 在有理或实数层换为相应读数。不能用各函数边缘可能值的无条件 Cartesian 组合替代该像。

**证明。** 固定一个 $\gamma$，全部输入为合法确定性表示，命题 7 即给等式；对所有 $\gamma$ 作函数像得集合等式。边缘像遗忘哪些值能在同一 $\gamma$ 上同时出现，下面的例子严格证明这种遗忘可能改变结果。证毕。

令唯一来源 $t\in\{1,2\}$，在四事件平衡整体上取两个正贡献和两个负贡献，时间、位置为零，偏序为空，来源均为 leaf(7)。在世界 $t$ 中选前 $t$ 个正贡献，得到函数 $H$ 的读数恰为 $t$。于是

$$
\operatorname{Poss}(H\boxplus N(H))=\{0\},\qquad
\operatorname{Poss}(H\boxtimes H)=\{1,4\}.
$$

错误地将两次引用独立取值，会分别给出 $\{-1,0,1\}$ 与 $\{1,2,4\}$。乘积来源树 pair(leaf(7), leaf(7)) 表示同一个来源的两次引用；它不是两个独立随机来源。这里出现的集合都只是可能值像，既不等于贡献补集，也不等于一个实际总电荷。

点态除法还须在**每个世界**满足该层守卫。若某世界除数为零，则整个 $\Gamma$ 上的除法函数未定义；可以显式限制到 $\Gamma'=\{\gamma:\text{除法守卫成立}\}$ 后研究，但必须公布域已改变及 $\Gamma'\ne\varnothing$ 的条件。整数还逐世界检查整除性；实数检查每个世界的非零实数类，不要求所有世界共享一个尾部下界。以 $t\in\{0,1\}$ 为例，$t/t$ 不在全域定义，限制到 $\{1\}$ 才有可能值 $\{1\}$，不能把它说成原全域的无条件结果。

## 11. ZFC 构造与兼容性的准确强度

**命题 14（全部载体为 ZFC 集合）。** 本文的有限情境、丰富整数及有理表示、全部丰富 Cauchy 序列、它们的等价商及指定运算，均可在 ZFC 中构造；每个给定的联合来源模型也是集合结构。

**证明。** ZFC 以无穷公理构造 $\omega$，以递归、幂集和并集构造 $V_n$ 与 $HF=\bigcup_{n<\omega}V_n$。用 Kuratowski 有序对及不同自然数标签编码整数、元组、事件出现和来源树。树集合可取 $T_0=\{\operatorname{leaf}(n):n\in\omega\}$，$T_{k+1}=T_k\cup\{\operatorname{pair}(r,s):r,s\in T_k\}$，再作可数并。每棵树以及每份有限函数图都是遗传有限集合。

因此一份有限情境和选择的完整编码属于 $HF$，全部合法编码由 $HF$ 上的分离公理取出；不是对任意大集合的无界收集。有限性、严格偏序、函数图、时标约束、区域包含、符号计数和平衡都是一阶集合论可表达性质，故 $\mathcal B$ 是集合。定义中的有限并、积、传递闭包、函数像与有限和给出相应运算的定义图；命题 1 至 3 已证明所需域上的唯一输出及闭包。

任一集合 $X$ 上的等价关系，其商可写为 $\{[x]:x\in X\}\subseteq\mathcal P(X)$，由分离与替代构造。因此整数商存在，$\mathcal Q^{\rm rich}\subseteq\mathcal B^2$ 及有理商也存在。全序列空间是函数集 $(\mathcal Q^{\rm rich})^{\mathbb N}\subseteq\mathcal P(\mathbb N\times\mathcal Q^{\rm rich})$；以 Cauchy 条件分离出 $\mathcal R^{\rm rich}$，再取零差商。这个函数集不要求元素仍属 $HF$，所以没有把实数限制在可数的有限编码集合中。命题 6 的求逆图只对非零类成立，有限前缀分支以有理零判别给出唯一值；它在 ZFC 中存在，不需要算法判定任意实数类是否非零。

来源模型以给定的集合 $S$ 及值域族为参数；积、子集 $\Gamma$ 和函数 $H$ 都是集合。这里 $\Gamma\ne\varnothing$ 是该模型的显式条件，不是声称任意额外联合约束必相容。有限 bin 数据、情境嵌入、地平线族也分别由相应函数集与分离得到。证毕。

**命题 15（定义性保守扩展）。** 若新词汇仅由本文的 ZFC 公式定义，而本文命题以其证明加入，则对任一原集合论语言句子 $\varphi$，

$$
\mathrm{ZFC}+\mathrm{CSA\ definitions}\vdash\varphi
\quad\Longrightarrow\quad \mathrm{ZFC}\vdash\varphi.
$$

因而在通常元理论中有相对一致性蕴含
$\operatorname{Con}(\mathrm{ZFC})\Rightarrow\operatorname{Con}(\mathrm{ZFC}+\mathrm{CSA\ definitions})$；反向因后者包含前者也成立。这里没有从无条件前提证明任一一致性断言。

**证明。** 新谓词可逐次替换成其集合论定义；有类型的变量量化替换成相应载体上的受限量化。新函数可替换成其唯一输出的定义图；部分运算保留域谓词和图，或在域外统一返回指定的 $\varnothing$，只在合法域声明算术保持。命题 14 及各闭包、守卫证明保证这些定义图在声明域上存在唯一值，故消去定义不会增加一个未证明的存在公理。对扩展语言中的有限推导逐步消去定义，得到原语言的 ZFC 推导，证明保守性。若扩展导致矛盾，同一消去过程给出 ZFC 中矛盾，于是得到相对一致性结论。证毕。

特别地，没有断言外部已经存在一个 ZFC 的集合模型；对任一给定 $M\models\mathrm{ZFC}$ 的“可作定义扩张”只是条件陈述，并不构造这样的 $M$。也不声称 Lean 的依赖类型论基础与 ZFC 完全相同，或已有 Lean 文件内核验证了这整个新模型。

**普遍整体的障碍。** 本稿 $HF$ 中全部有限情境编码构成一个集合，但它不是一切集合的集合；$\mathcal D_C$ 的整体只属于指定情境。若设有含所有集合的集合 $U$，分离出 $R=\{x\in U:x\notin x\}$，由普遍性有 $R\in U$，从而 $R\in R\iff R\notin R$，矛盾。因此扩展到任意集合尺度的“所有情境”时，只可用可定义类的缩写，或先固定集合尺度再取商；不能直接对真类套用本文的集合商论证。整个构造不需要不可达基数，也不把“道包含一切”偷换成 ZFC 的普遍集合公理。

## 12. 来源、已有结果与 PRO 意见的处理

本文组合方案的归类是 `repo-derived`：在既有来源材料与批准方案上给出本稿的显式构造和证明。有限和、商代数、整数分数、有理 Cauchy 完备化、集合编码和定义性保守扩展是成熟数学，不主张为新发现，也不把新组合称为已经完成文献新颖性调查。

标准参考：Terence Tao, *Analysis I*（2022，整数、有理数与实数的标准构造），DOI [10.1007/978-981-19-7261-4](https://doi.org/10.1007/978-981-19-7261-4)；Thomas Jech, *Set Theory*（1997，ZFC、集合层级与通常集合构造），DOI [10.1007/978-3-662-22400-7](https://doi.org/10.1007/978-3-662-22400-7)。本次在线查询核对的是 Crossref 的作者、书名、年份和 DOI 元数据，未据元数据声称逐页核过书中证明。本文承重的具体命题与证明已写在正文。

仓库内直接相关的数学材料如下；链接为源码，声明名给出检索锚。本次读取了这些文件并核对各自冻结成员状态文件存在，未修改或重新证明它们。

| 已有源码 | 本稿采用的边界 |
| --- | --- |
| [RelativeComplement.lean](../../../D5/S3/ConceptDynamics/Negation/RelativeComplement.lean) | `relativeComplement_domain_extension` 的新增区域分解，`preimage_relativeComplement` 与 `image_complement_counterexample` 对逆像、直接像的区分 |
| [ComplementFiberLift.lean](../../../D5/S3/ConceptDynamics/Negation/ComplementFiberLift.lean) | `complementFiber` 与 `sectionLift_square` 区分反值纤维、选点提升及其平方；选代表只得到截面上的回缩 |
| [DaoConceptBoundarySpecialization.lean](../../../D5/S3/ConceptDynamics/Negation/DaoConceptBoundarySpecialization.lean) | 整体、概念与相对余域的集合表述；“所有表达都留余域”是显式前提，不是由“道”这个名称推出 |
| [InvolutionDescent.lean](../../../D5/S3/ConceptDynamics/ObservationTopology/InvolutionDescent.lean) | `kernelStable_iff_exists_descended` 的纤维稳定下降准则；本稿另写部分域必须饱和的扩充 |
| [ConceptFiberDecomposition.lean](../../../D5/S3/ConceptDynamics/ConceptFiberDecomposition.lean) | `concept_fiber_decomposition` 的读数加依赖纤维表述，不能把纤维中的点从数值自动重建 |

实际 GPT PRO 输入由调用方保留为 `/tmp/dao-spacetime-0909/pro-result.json` 的 `conclusion`；运输证据为 `/tmp/dao-spacetime-0909/pro-attempt-2-transport.json`。本次读取的字段为：`task_id=d42635b1-0943-40dd-8ca7-64654af999b0`，`model=chatgpt-5.5-pro`，`status=completed`，`completed_at=2026-09-08T16:50:07.221+00:00`，`conversation_id=conv_9b0c2d6553535653`，对话 [GPT PRO 建设输入](https://chatgpt.com/c/6aa03bfa-9294-83ec-ad89-bb2c9c0a2cd9)。这些标识证明所消费的输入来自保存的实际调用记录，不使其数学判断成为权威；临时路径的长期保存归调用方负责。调用方记录首次响应已有实质内容但 JSON 转义无效，未将其计作有效面板信封；本稿消费的是重试后的有效结果，未重新归因首次失败。实施载体与 PRO 都是 OpenAI 来源，不以两个载体冒充两个独立模型族。未打开或使用任何 `log_ref` 内容推理。

本稿保留 PRO 提出的有限有符号事件、商算术、局部平衡、共同赋值、相对 ZFC 解释及反例方向，并依批准综合方案作如下具体收紧：

| PRO 输入中的问题或较弱形态 | 本稿落点 |
| --- | --- |
| `Dao(C)=Adm` 与事件补集可能混层 | 定义 2 明确为 $(C,\Omega,\mathcal P(\Omega))$；历史族和世界域另外标型 |
| 单纯 Cartesian 事件乘法遇空因子丢掉输入事件 | 定义 6 保留两份档案再生成当前事件；命题 3 给出嵌入与基数证明 |
| 时间先后可通过平移实现，但易变成暗改绝对时间 | 定义 5 是部分运算，任何平移显式写在输入上 |
| 原始逆元不存在，被笼统写成 noncancellative | 第 4 节撤去该推断，并证明标签编码相等下的加法消去律 |
| 实数求逆早期项可能为零 | 命题 6 定义每个前缀项，证明非零类等价于尾部正下界，并给两个相反方向的守卫测试 |
| 不共享变量名容易被误当成无额外联合约束 | 第 10 节保留 $\Gamma=J\cap K$，不由变量名推出域积或概率独立 |
| 粗化可能丢符号和多重性 | 定义 12 使用双电荷 $w,z$，补集为 $w-z$；命题 10 单独处理直接像的饱和条件 |

这些是对本稿数学范围的实质修正，不把一次思考席响应或实施席自查称为最终独立审查通过。

## 13. 已反驳的更强断言与剩余研究范围

| 更强断言 | 反例或精确替代 |
| --- | --- |
| 任意背景下补集等于算术负号 | $u\ne0$ 时是 $u-q$；取空选择即可检出差异 |
| 因果过去对任意补集封闭 | 两事件链的 $\{e\}$ 与 $\{f\}$ |
| 非空表示加其负表示就是空历史 | 档案基数变为 $2\lvert E_X\rvert>0$ |
| 数值一在原始档案乘法下是单位 | 新档案至少增加两个旧事件；第 4 节基数式 |
| 原始乘法关联顺序不影响历史 | 同读数 $2$ 的两种括号分别有 $28,32$ 个事件 |
| 完整结构都能由一个旧标量更新 | 第 9 节三个同数异筛选反例；须满足命题 11 |
| 限制任一配对仍普遍投影为乘法 | 单点选择命中被删对，$\pm1$ 变成 $0$ |
| 平衡扩张保持补集集合不变 | 新增正负对电荷为零，但新增区域非空 |
| 总体平衡意味着每个 bin 的负号 | $w=(1,-1),z=(1,0)$，补集为 $(0,-1)$ |
| 满射总保直接像补集 | 一个纤维部分被选，像的两部分发生重叠 |
| 任意事件合并保持因果无环 | 两条链合并成 $L\prec R\prec L$ |
| 两输入共同空间平移与乘法交换 | 新点偏移 $2v$ 与 $v$ 不同 |
| 来源边缘集合足以算不确定结果 | 共享 $t-t$ 与 $t^2$ 的像不同于独立配对 |
| 实数逐项非零等价于可求逆 | 零前缀的常一类可逆，$1/n$ 类不可逆 |
| 无限平衡整体有无条件的 $\infty-\infty=0$ | 正负交替的有限部分和不收敛 |
| ZFC 解释证明 ZFC 绝对一致或给出普遍集合 | 定义消去只给相对结论；普遍集合被 Russell 分离反例否定 |

已证明的范围是：有限档案丰富层上的指定整数算术投影、带守卫的分数与全部 Cauchy 序列扩充、结构操作和运输的精确适用条件，以及 ZFC 内的定义解释。上述失败断言已由反例解决，不作为含混的“开放问题”保留。剩余可研究方向是对特定应用另外定义并验证允许历史、因果动力学、连续时空结构或概率模型；这些都不属于本稿已完成的算术兼容性证明。把本稿新模型进一步形式化是另一个工作单元，本次没有完成内核验证或最终独立评审。

## 附录 A. 精确有限核验

以下 Python 3 标准库检查器是本任务的临时核验，不是生产算术引擎。它只用整数、集合与 `fractions.Fraction`，有限遍历的范围是档案即当前区域、空偏序、事件数为 $0,2,4$ 的全部平衡符号配置及全部选择，共 105 个表示、11025 个输入对。另核验正文的非空因果偏序例子、档案保留、原始非结合性、分数、补集粗观察、空间运输、来源与除法反例。普遍命题及全部无限序列的结论由正文证明，不由这些有限运行替代。

在仓根直接执行文档中的唯一 Python 代码块，无需生成工具文件：

```sh
sed -n '/^```python$/,/^```$/p' docs/develop/theory/CONTEXTUAL_SPACETIME_ARITHMETIC.md | sed '1d;$d' | python3 -
```

检查器使用 Python 元组和字典作为有限编码的可读实现；正文的集合编码论证不依赖 Python 对象身份。

```python
from dataclasses import dataclass, replace
from fractions import Fraction
from itertools import product

@dataclass(frozen=True)
class Rich:
    e: dict
    o: frozenset
    w: frozenset
    a: frozenset

def closure(edges):
    out = set(edges)
    while True:
        more = {(a, d) for a, b in out for c, d in out if b == c}
        if more <= out:
            return frozenset(out)
        out |= more

def valid(x):
    assert x.a <= x.w <= x.e.keys()
    assert all(t == int(t) and len(p) == 3 and s in (-1, 1)
               for t, p, s, r in x.e.values())
    assert all(a in x.e and b in x.e and x.e[a][0] < x.e[b][0]
               for a, b in x.o)
    assert closure(x.o) == x.o
    return x

def charge(x, a):
    return sum(x.e[e][2] for e in a)

def q(x):
    return charge(x, x.a)

def neg(x):
    return replace(x, a=x.w - x.a)

def add(x, y):
    e = {(i, a): v for i, z in enumerate((x, y))
         for a, v in z.e.items()}
    o = frozenset(((i, a), (i, b)) for i, z in enumerate((x, y))
                  for a, b in z.o)
    w = frozenset((i, a) for i, z in enumerate((x, y)) for a in z.w)
    a = frozenset((i, a) for i, z in enumerate((x, y)) for a in z.a)
    return valid(Rich(e, o, w, a))

def temporal(x, y):
    if not all(x.e[a][0] < y.e[b][0] for a in x.e for b in y.e):
        raise ValueError("time guard")
    z = add(x, y)
    cross = {((0, a), (1, b)) for a in x.e for b in y.e}
    return valid(replace(z, o=closure(z.o | cross)))

def mul(x, y):
    z = add(x, y)
    e, o, w, chosen = dict(z.e), set(z.o), set(), set()
    for a in x.w:
        for b in y.w:
            key = (2, (a, b))
            ta, pa, sa, ra = x.e[a]
            tb, pb, sb, rb = y.e[b]
            e[key] = (max(ta, tb) + 1, tuple(u + v for u, v in zip(pa, pb)),
                      sa * sb, ("pair", ra, rb))
            o |= {((0, a), key), ((1, b), key)}
            w.add(key)
            if a in x.a and b in y.a:
                chosen.add(key)
    return valid(Rich(e, closure(o), frozenset(w), frozenset(chosen)))

def integer(n):
    e = {(i, s): (0, (0, 0, 0), s, ("leaf", i))
         for i in range(abs(n)) for s in (-1, 1)}
    a = frozenset(k for k in e if k[1] == (1 if n > 0 else -1))
    return valid(Rich(e, frozenset(), frozenset(e), a))

def time_shift(x, k):
    return valid(replace(x, e={a: (t + k, p, s, r)
                               for a, (t, p, s, r) in x.e.items()}))

def spatial(x, scale=1, offset=0):
    return valid(replace(x, e={a: (t, (scale*p[0] + offset,
                                       scale*p[1], scale*p[2]), s, r)
                               for a, (t, p, s, r) in x.e.items()}))

def filt(x, pred):
    return replace(x, a=frozenset(a for a in x.a if pred(a)))

def coarse(x, f):
    bins = {f(a) for a in x.w}
    w = {b: charge(x, {a for a in x.w if f(a) == b}) for b in bins}
    z = {b: charge(x, {a for a in x.a if f(a) == b}) for b in bins}
    return w, z

def rv(r):
    return Fraction(q(r[0]), q(r[1]))

def rat(a, b=1):
    if b == 0:
        raise ValueError("denominator guard")
    return integer(a), integer(b)

def radd(r, s):
    x, y = r
    z, w = s
    return add(mul(x, w), mul(z, y)), mul(y, w)

def rmul(r, s):
    return mul(r[0], s[0]), mul(r[1], s[1])

def rneg(r):
    return neg(r[0]), r[1]

def rdiv(r, s):
    if q(s[0]) == 0:
        raise ValueError("divisor guard")
    return mul(r[0], s[1]), mul(r[1], s[0])

def inverse_term(r):
    return (r[1], r[0]) if rv(r) != 0 else radd(r, rneg(r))

states = []
for n in (0, 2, 4):
    for signs in product((-1, 1), repeat=n):
        if sum(signs) != 0:
            continue
        e = {i: (i, (i, 0, 0), signs[i], ("leaf", i)) for i in range(n)}
        for bits in product((False, True), repeat=n):
            x = valid(Rich(e, frozenset(), frozenset(e),
                           frozenset(i for i in e if bits[i])))
            assert q(neg(x)) == -q(x) and neg(neg(x)) == x
            states.append(x)
pairs = 0
for x in states:
    for y in states:
        a, p = add(x, y), mul(x, y)
        assert q(a) == q(x) + q(y) and q(p) == q(x) * q(y)
        assert charge(a, a.w) == charge(p, p.w) == 0
        assert len(p.e) == len(x.e) + len(y.e) + len(x.w)*len(y.w)
        for i, old in enumerate((x, y)):
            assert all(p.e[(i, k)] == v for k, v in old.e.items())
            assert all((((i, a), (i, b)) in p.o) == ((a, b) in old.o)
                       for a in old.e for b in old.e)
        pairs += 1
assert (len(states), pairs) == (105, 11025)
print("balanced_states=105 pair_checks=11025")

xe = {"a": (0, (0,0,0), 1, ("leaf",7)),
      "b": (1, (2,0,0), 1, ("leaf",7)),
      "c": (1, (1,0,0), -1, ("leaf",8)),
      "d": (2, (3,0,0), -1, ("leaf",8))}
ye = {"r": (3, (10,0,0), 1, ("leaf",7)),
      "s": (4, (10,0,0), -1, ("leaf",9))}
x = valid(Rich(xe, frozenset({("a","b"), ("c","d")}),
               frozenset(xe), frozenset("abc")))
y = valid(Rich(ye, frozenset({("r","s")}), frozenset(ye), frozenset("r")))
p, a, t = mul(x, y), add(x, y), temporal(x, y)
assert (q(x), q(y), q(p), len(p.e), len(p.w), len(p.a), len(p.o)) == (1,1,1,14,8,3,27)
assert [(p.e[(2,(k,"r"))][0], p.e[(2,(k,"r"))][1][0],
         p.e[(2,(k,"r"))][2]) for k in "abc"] == [(4,10,1),(4,12,1),(4,11,-1)]
assert (len(a.o), len(t.o), q(a), q(t)) == (3,11,2,2)
print("worked_product: q=1 archive=14 whole=8 selected=3 causal_pairs=27")
print("parallel_pairs=3 temporal_pairs=11 both_q=2")
z0, z1 = mul(x, integer(0)), mul(x, replace(y, a=y.w))
assert (len(z0.e), len(z0.w), q(z0)) == (4,0,0)
assert (len(z1.e), len(z1.w), len(z1.a), q(z1)) == (14,8,6,0)
assert mul(x, integer(0)) == mul(neg(x), integer(0))
u, two = integer(1), integer(2)
left, right = mul(mul(u,u),two), mul(u,mul(u,two))
assert (len(left.e), len(right.e), q(left), q(right)) == (28,32,2,2)
assert len(add(u,neg(u)).e) == 4 and q(add(u,neg(u))) == 0
assert len(mul(u,u).e) == 8 and q(mul(u,u)) == 1
print("zero_products: (archive,whole,selected,q)=(4,0,0,0),(14,8,6,0)")
print("raw_laws: sum_with_negative_archive=4 unit_product_archive=8 associativity_archives=28,32")

xp = replace(x, a=frozenset("a"))
predicates = (lambda k: x.e[k][1][0] >= 2,
              lambda k: x.e[k][3] == ("leaf",7),
              lambda k: k == "b" or (k,"b") in x.o)
observed = [(q(filt(x,f)), q(filt(xp,f))) for f in predicates]
assert q(x) == q(xp) == 1 and observed == [(1,0),(2,1),(2,1)]
restricted = replace(p, a=frozenset(k for k in p.a
                     if abs(x.e[k[1][0]][1][0] - y.e[k[1][1]][1][0]) <= 9))
omitted = charge(p, p.a - restricted.a)
assert (q(restricted), omitted, q(p)) == (0,1,1)
single = mul(replace(x,a=frozenset("a")), y)
assert q(single) == 1 and q(replace(single,a=frozenset())) == 0
print("filters: spatial=(1,0) source=(2,1) causal=(2,1); restricted_q=0 omitted_charge=1")

expanded = replace(two, a=u.a)
extra = two.w - u.w
assert extra and charge(two,extra) == 0 and q(neg(expanded)) == q(neg(u)) == -1
unbalanced = valid(Rich({k:v for k,v in two.e.items() if k in u.w or k == (1,1)},
                        frozenset(), u.w | {(1,1)}, u.a))
assert q(neg(unbalanced)) == 0 and charge(unbalanced,unbalanced.w) == 1
w,z = coarse(u, lambda k: k[1])
wn,zn = coarse(neg(u), lambda k: k[1])
assert w == wn == {-1:-1,1:1} and z == {-1:0,1:1} and zn == {-1:-1,1:0}
assert all(zn[b] == w[b] - z[b] for b in w)
f = {"a":0,"b":0,"c":1}
assert {f[k] for k in {"b","c"}} == {0,1}
assert {0,1} - {f["a"]} == {1}
assert {("L","L"),("R","R")} <= closure({("L","R"),("R","L")})
print("transport: balanced_added_charge=0 unbalanced_defect=1; bin_complement=(0,-1); image_defect_and_cycle=confirmed")
assert mul(spatial(x,2),spatial(y,2)) == spatial(p,2)
assert mul(time_shift(x,5),time_shift(y,5)) == time_shift(p,5)
assert mul(spatial(x,offset=1),spatial(y,offset=1)) != spatial(p,offset=1)
try:
    temporal(u,u)
    raise AssertionError("unguarded temporal composition")
except ValueError:
    pass
assert q(temporal(u,time_shift(u,1))) == 2
print("coordinates: linear_and_time_translation_commute=True spatial_translation_commutes=False")

r,s = rat(1,2),rat(-3,2)
assert (rv(radd(r,s)),rv(rmul(r,s)),rv(rneg(r)),rv(rdiv(r,s))) == (
    Fraction(-1),Fraction(-3,4),Fraction(-1,2),Fraction(-1,3))
try:
    rdiv(r,rat(0))
    raise AssertionError("unguarded rational division")
except ValueError:
    pass
prefix = [rv(inverse_term(rat(k))) for k in (0,1,1,1)]
null_inverse_prefix = [rv(inverse_term(rat(1,k))) for k in (1,2,3,4)]
assert prefix == [0,1,1,1] and null_inverse_prefix == [1,2,3,4]
print("rationals: sum=-1 product=-3/4 negative=-1/2 division=-1/3 zero_divisor=rejected")
print("inverse_prefixes: (0,1,1,1)->(0,1,1,1); (1,1/2,1/3,1/4)->(1,2,3,4)")

shared = ({t-t for t in (1,2)}, {t*t for t in (1,2)})
independent = ({t-s for t in (1,2) for s in (1,2)},
               {t*s for t in (1,2) for s in (1,2)})
assert shared == ({0},{1,4}) and independent == ({-1,0,1},{1,2,4})
assert {(s,t) for s in (1,2) for t in (1,2) if s == t} == {(1,1),(2,2)}
assert {t for t in (0,1) if t != 0} == {1}
chain = {("e","f")}
assert all(b not in {"e"} or a in {"e"} for a,b in chain)
assert not all(b not in {"f"} or a in {"f"} for a,b in chain)
print("sources: shared_difference={0} shared_square={1,4}; independent_difference={-1,0,1} independent_product={1,2,4}")

# PR1: verification helpers only; Rich/add/mul/neg above remain the archive model.
# Rich.w is Omega (an event set), whereas the first read_pair component is w(p).
def sparse(c):
    return {p: a for p, a in c.items() if a}

def read_pair(x):
    return tuple(sparse(c) for c in coarse(x, lambda k: x.e[k][1]))

def plus_c(c, d):
    return sparse({p: c.get(p, 0) + d.get(p, 0) for p in c.keys() | d.keys()})

def minus_c(c):
    return {p: -a for p, a in c.items()}

def conv(c, d, keep=lambda p, q: True):
    out = {}
    for p, a in c.items():
        for q0, b in d.items():
            if keep(p, q0):
                r = tuple(i + j for i, j in zip(p, q0))
                out[r] = out.get(r, 0) + a*b
    return sparse(out)

def pair_add(x, y):
    return tuple(plus_c(c, d) for c, d in zip(x, y))

def pair_mul(x, y):
    return tuple(conv(c, d) for c, d in zip(x, y))

def flip_signs(x):
    return valid(replace(x, e={k: (t, p, -s, r)
                               for k, (t, p, s, r) in x.e.items()}))

def at(x, points):
    return filt(x, lambda k: x.e[k][1] in points)

def realize(w, z):
    assert sum(w.values()) == 0
    events, chosen = {}, set()
    for p in sorted(w.keys() | z.keys()):
        for selected, value in ((True, z.get(p, 0)),
                                (False, w.get(p, 0) - z.get(p, 0))):
            for i in range(abs(value)):
                k = (p, selected, i)
                events[k] = (0, p, 1 if value > 0 else -1, ("leaf", 0))
                if selected:
                    chosen.add(k)
    return valid(Rich(events, frozenset(), frozenset(events), frozenset(chosen)))

def restricted_mul(x, y, keep):
    full = mul(x, y)
    return replace(full, a=frozenset(k for k in full.a if keep(*k[1])))

origin, v, h = (0,0,0), (1,0,0), (0,1,-1)
delta = {origin: 1}
alpha = {origin: 1, v: -1}
recovery_checks = 0
for state in states:
    bg, selected = read_pair(state)
    for point in ((i,0,0) for i in range(4)):
        z_at = q(at(state, {point}))
        n_at = q(at(neg(state), {point}))
        assert z_at == selected.get(point, 0)
        assert z_at + n_at == bg.get(point, 0)
        assert read_pair(at(state, {point}))[0] == bg
        recovery_checks += 1
assert recovery_checks == 420
background_only = realize(alpha, {})
assert read_pair(background_only) == (alpha, {})
assert q(at(neg(background_only), {origin})) == 1
assert q(at(neg(integer(0)), {origin})) == 0
assert read_pair(at(background_only, set()))[0] == alpha
assert read_pair(neg(background_only)) == (alpha, alpha)
assert read_pair(flip_signs(background_only)) == (minus_c(alpha), {})
shifted_u = spatial(u, offset=1)
assert q(u) == q(shifted_u) == 1
assert (q(at(u, {origin})), q(at(shifted_u, {origin}))) == (1, 0)
print("pr1_recovery: singleton_checks=420 background_after_filter=preserved kernels_strict=True")

image_cases = 0
for a0, a1 in product((-1,0,1), repeat=2):
    bg = sparse(dict(zip((origin,v,h), (a0,a1,-a0-a1))))
    for zs in product((-1,0,1), repeat=3):
        selected = sparse(dict(zip((origin,v,h), zs)))
        state = realize(bg, selected)
        assert read_pair(state) == (bg, selected)
        bound = sum(abs(selected.get(p,0)) + abs(bg.get(p,0)-selected.get(p,0))
                    for p in bg.keys() | selected.keys())
        assert len(state.w) == len(state.e) == bound
        assert charge(state, state.w) == 0 and not state.o
        assert all(event[0] == 0 for event in state.e.values())
        image_cases += 1
assert image_cases == 243

capacity_cases, selection_cases = 0, 0
for pp0, pm0, pp1, pm1 in product(range(3), repeat=4):
    if pp0 + pp1 != pm0 + pm1:
        continue
    counts = {origin: (pp0,pm0), v: (pp1,pm1)}
    events = {(p,s,i): (0,p,s,("leaf",0)) for p, ns in counts.items()
              for s,n in zip((1,-1),ns) for i in range(n)}
    fixed = valid(Rich(events, frozenset(), frozenset(events), frozenset()))
    seen = set()
    for bits in product((False,True), repeat=len(events)):
        chosen = frozenset(k for k,yes in zip(events,bits) if yes)
        bg, selected = read_pair(replace(fixed, a=chosen))
        assert bg == sparse({origin:pp0-pm0, v:pp1-pm1})
        seen.add(tuple(selected.get(p,0) for p in (origin,v)))
        selection_cases += 1
    expected = set(product(range(-pm0,pp0+1), range(-pm1,pp1+1)))
    assert seen == expected
    capacity_cases += 1
assert (capacity_cases, selection_cases) == (19,673)
empty_u, empty_two = replace(u,a=frozenset()), replace(two,a=frozenset())
assert read_pair(empty_u) == read_pair(empty_two) == ({},{})
capacities = []
for fixed in (empty_u, empty_two):
    capacities.append({q(replace(fixed,a=frozenset(k for k,b in zip(fixed.w,bits) if b)))
                       for bits in product((False,True),repeat=len(fixed.w))})
assert capacities == [{-1,0,1},{-2,-1,0,1,2}]
print("pr1_image_capacity: image_cases=243 fixed_contexts=19 choices=673 capacities=[-1,1],[-2,2]")

# Explicit coefficients come from the delta expansions in section 17.3.
sx = realize(alpha, {origin:2, v:-1})
sy = realize({h:1, origin:-1}, {v:1, h:1})
vh, vv = (1,1,-1), (2,0,0)
expected_bg = {h:1, origin:-1, vh:-1, v:1}
expected_z = {v:2, h:2, vv:-1, vh:-1}
full = mul(sx, sy)
assert read_pair(full) == (expected_bg, expected_z)
assert (len(full.e), len(full.w), q(full)) == (24,16,2)
assert read_pair(neg(sx)) == (alpha, {origin:-1})
kept = restricted_mul(sx, sy, lambda a,b: sx.e[a][1] == sy.e[b][1])
assert read_pair(kept) == (expected_bg, {vv:-1})
assert q(kept) == -1 and q(full) == 2
assert conv(read_pair(sx)[1], read_pair(sy)[1], lambda p,q0:p == q0) == {vv:-1}
assert q(restricted_mul(u, shifted_u, lambda a,b:u.e[a][1] == shifted_u.e[b][1])) == 0
assert q(restricted_mul(u, u, lambda a,b:u.e[a][1] == u.e[b][1])) == 1

space_states = [realize(sparse({origin:c, v:-c}), z0)
                for c in (-1,0,1) for z0 in ({h:-1},{},{v:1,h:1})]
space_pairs = 0
for xx in space_states:
    bx,zx = read_pair(xx)
    assert read_pair(neg(xx)) == (bx,plus_c(bx,minus_c(zx)))
    assert read_pair(add(xx,flip_signs(xx))) == ({},{})
    for yy in space_states:
        px,py = read_pair(xx),read_pair(yy)
        assert read_pair(add(xx,yy)) == pair_add(px,py)
        assert read_pair(mul(xx,yy)) == pair_mul(px,py)
        assert sum(conv(px[0],py[0]).values()) == 0
        assert sum(conv(px[1],py[1]).values()) == q(xx)*q(yy)
        assert pair_mul(px,py) == pair_mul(py,px)
        space_pairs += 1
space_triples = 0
pair_samples = [read_pair(xx) for xx in space_states]
for px,py,pz in product(pair_samples, repeat=3):
    assert pair_mul(pair_mul(px,py),pz) == pair_mul(px,pair_mul(py,pz))
    assert pair_mul(px,pair_add(py,pz)) == pair_add(pair_mul(px,py),pair_mul(px,pz))
    space_triples += 1
assert (space_pairs,space_triples) == (81,729)
assert read_pair(left) == read_pair(right) == ({},{origin:2})
assert (len(left.e),len(right.e)) == (28,32)
print("pr1_convolution: sparse_states=9 rich_pairs=81 pair_triples=729 explicit_full_q=2 restricted_q=-1 archives=28,32")

FAIL = object()
def observe(ops, state, read):
    try:
        for operation in ops:
            state = operation(state)
    except (KeyError, ValueError):
        return FAIL
    return ("ok", read(state))

only_a = {"a":"a"}.__getitem__
rd0 = lambda _: 0
common_words = [(),(only_a,),(only_a,only_a)]
for word in common_words:
    oa,ob = observe(word,"a",rd0),observe(word,"b",rd0)
    assert oa is FAIL or ob is FAIL or oa == ob  # The wrong rule misses the defect.
assert observe((only_a,),"a",rd0) == ("ok",0)
assert observe((only_a,),"b",rd0) is FAIL
assert observe((only_a,),"b",rd0) != ("ok",0)
depth_cases = 0
for depth in range(5):
    advance = lambda x, k=depth: (x[0],min(x[1]+1,k+1))
    read = lambda x, k=depth: int(x == ("a",k+1))
    for j in range(depth+1):
        assert observe((advance,)*j,("a",0),read) == observe((advance,)*j,("b",0),read)
    assert (observe((advance,)*(depth+1),("a",0),read),
            observe((advance,)*(depth+1),("b",0),read)) == (("ok",1),("ok",0))
    assert observe((advance,)*depth,advance(("a",0)),read) != observe((advance,)*depth,advance(("b",0)),read)
    depth_cases += 1
f = lambda s,t: 2 if (s,t) == (1,2) else 0
read012 = lambda x: int(x == 2)
second_only = [lambda x,a=a:f(a,x) for a in (0,1,2)]
params01 = [lambda x,a=a:f(a,x) for a in (0,1)] + [lambda x,a=a:f(x,a) for a in (0,1)]
restricted_words = 0
for family in (second_only,params01):
    for depth in range(4):
        for word in product(family,repeat=depth):
            assert observe(word,0,read012) == observe(word,1,read012)
            restricted_words += 1
assert observe((lambda x:f(x,2),),0,read012) == ("ok",0)
assert observe((lambda x:f(x,2),),1,read012) == ("ok",1)
g = lambda x: 0 if x == 0 else 2
assert observe((),0,read012) == observe((),1,read012)
assert observe((g,),0,read012) != observe((g,),1,read012)
assert (depth_cases,restricted_words) == (5,125)
print("pr1_contexts: common_domain_miss=1 depth_counterexamples=5 restricted_word_checks=125 slot_parameter_and_extra_probe=distinguished")

source7 = valid(Rich({"a":(0,origin,1,("leaf",7)), "b":(0,origin,-1,("leaf",7))},
                    frozenset(),frozenset(("a","b")),frozenset(("a",))))
source8 = replace(source7,e={k:(t,p,s,("leaf",8)) for k,(t,p,s,r) in source7.e.items()})
assert read_pair(source7) == read_pair(source8) == ({},delta)
source_reads = tuple(q(filt(xx,lambda k,xx=xx:xx.e[k][3] == ("leaf",7)))
                     for xx in (source7,source8))
assert source_reads == (1,0)
source_products = tuple(q(restricted_mul(xx,source7,
                        lambda a,b,xx=xx:xx.e[a][3] == source7.e[b][3]))
                        for xx in (source7,source8))
assert source_products == (1,0)
ce = {k:(t,origin,s,("leaf",0)) for k,t,s in zip("abcd",(0,1,0,1),(1,1,-1,-1))}
causal = valid(Rich(ce,frozenset({("a","b")}),frozenset(ce),frozenset("ab")))
no_causal = valid(replace(causal,o=frozenset()))
def past(x, targets):
    if not targets <= x.e.keys():
        raise ValueError("dependent causal query domain")
    return filt(x,lambda e:any(e == d or (e,d) in x.o for d in targets))
assert read_pair(causal) == read_pair(no_causal) == ({},{origin:2})
assert (q(past(causal,{"b"})),q(past(no_causal,{"b"}))) == (2,1)
assert tuple(q(restricted_mul(xx,u,lambda a,b,xx=xx:a in past(xx,{"b"}).a))
             for xx in (causal,no_causal)) == (2,1)
old = valid(replace(u,e={**u.e,("old",0):(2,origin,1,("leaf",9))}))
assert read_pair(old) == read_pair(u) == ({},delta)
after = time_shift(u,1)
assert observe((lambda xx:temporal(xx,after),),u,q) == ("ok",2)
assert observe((lambda xx:temporal(xx,after),),old,q) is FAIL
renamed = valid(Rich({"a2":source7.e["a"],"b2":source7.e["b"]},frozenset(),
                    frozenset(("a2","b2")),frozenset(("a2",))))
assert read_pair(renamed) == read_pair(source7)
assert (q(filt(source7,lambda k:k == "a")),q(filt(renamed,lambda k:k == "a"))) == (1,0)
assert tuple(q(restricted_mul(xx,u,lambda a,b:a == "a")) for xx in (source7,renamed)) == (1,0)
assert observe((lambda xx:past(xx,{"a"}),),source7,q) == ("ok",1)
assert observe((lambda xx:past(xx,{"a"}),),renamed,q) is FAIL
print("pr1_boundaries: same_pair_source=1,0 causal=2,1 time_domain=defined,undefined identity=1,0 dependent_D=defined,undefined")

a0 = read_pair(background_only)
e0 = read_pair(u)
zero_pair = ({},{})
assert a0 != zero_pair and e0 != zero_pair
assert read_pair(mul(background_only,u)) == zero_pair
assert read_pair(mul(u,source7)) == read_pair(source7)
assert read_pair(neg(mul(u,u))) == ({},{origin:-1})
assert read_pair(mul(neg(u),neg(u))) == e0
assert read_pair(neg(u)) == read_pair(flip_signs(u))
for xx in space_states:
    bg,_ = read_pair(xx)
    assert (read_pair(neg(xx)) == read_pair(flip_signs(xx))) == (bg == {})
unit_candidates = 0
for coeffs in product(range(-2,3),repeat=3):
    if sum(coeffs) != 0:
        continue
    candidate_a = sparse(dict(zip((origin,v,h),coeffs)))
    # This detects finite examples of c(r-v) != c(r); the unbounded proof is prose.
    c = plus_c(candidate_a,{origin:-1})
    assert conv(c,{v:1,origin:-1}) != {}
    for b_coeffs in product((-1,0,1),repeat=3):
        candidate_b = sparse(dict(zip((origin,v,h),b_coeffs)))
        candidate = (candidate_a,candidate_b)
        if candidate_b != delta:
            assert pair_mul(candidate,e0) != e0
        else:
            assert pair_mul(candidate,a0) != a0
        unit_candidates += 1
assert unit_candidates == 513
print("pr1_rng: zero_divisors=confirmed N_not_J=confirmed N_not_multiplicative=confirmed P0_unit_only=True finite_unit_candidates_rejected=513")

# PR2: all finite data still use Rich and the original archive operations.
def history_map(x, y, mapping):
    assert set(mapping) == set(x.e) and set(mapping.values()) == set(y.e)
    assert len(set(mapping.values())) == len(mapping)
    assert all(x.e[e] == y.e[mapping[e]] for e in x.e)
    assert {(mapping[a],mapping[b]) for a,b in x.o} == set(y.o)
    assert {mapping[e] for e in x.w} == set(y.w)
    assert {mapping[e] for e in x.a} == set(y.a)
    return 1

def rebracket(x, y, z):
    return {**{(0,(0,e)):(0,e) for e in x.e},
            **{(0,(1,e)):(1,(0,e)) for e in y.e},
            **{(1,e):(1,(1,e)) for e in z.e}}

def unit_at(t):
    return time_shift(integer(1), t)

def guard(x, y):
    return all(x.e[e][0] < y.e[f][0] for e in x.e for f in y.e)

def attempt(operation):
    try:
        return operation()
    except ValueError:
        return FAIL

hist_left, hist_right = mul(u,add(u,u)), add(mul(u,u),mul(u,u))
assert (len(hist_left.e),len(hist_right.e),q(hist_left),q(hist_right)) == (14,16,2,2)
comm_left, comm_right = mul(source7,source8), mul(source8,source7)
new_sources = [{z.e[e][3] for e in z.e if z.e[e][0] == 1}
               for z in (comm_left,comm_right)]
assert new_sources == [{("pair",("leaf",7),("leaf",8))},
                       {("pair",("leaf",8),("leaf",7))}]
assert new_sources[0].isdisjoint(new_sources[1])
assert len(comm_left.w) == len(comm_right.w) == 4
empty = integer(0)
additive_isomorphisms = history_map(add(source7,source8),add(source8,source7),
                                  {(i,e):(1-i,e) for i,z in enumerate((source7,source8)) for e in z.e})
additive_isomorphisms += history_map(add(u,empty),u,{(0,e):e for e in u.e})
assert add(u,empty) != u and add(add(u,u),u) != add(u,add(u,u))
additive_isomorphisms += history_map(add(add(u,u),u),add(u,add(u,u)),rebracket(u,u,u))
assert q(add(u,neg(u))) == 0 and len(add(u,neg(u)).e) == 4
print(f"pr2_history: distributivity_archives={len(hist_left.e)},{len(hist_right.e)} ordered_source_new_events={len(comm_left.w)},{len(comm_right.w)} additive_isomorphisms={additive_isomorphisms}")

temporal_states = [empty] + [unit_at(t0) for t0 in (-1,0,1,2)]
current_empty = valid(replace(unit_at(4),w=frozenset(),a=frozenset()))
temporal_states.append(current_empty)
temporal_checks, temporal_defined = 0, 0
for xx,yy,zz in product(temporal_states,repeat=3):
    required = guard(xx,yy) and guard(xx,zz) and guard(yy,zz)
    tl = attempt(lambda: temporal(temporal(xx,yy),zz))
    tr = attempt(lambda: temporal(xx,temporal(yy,zz)))
    assert (tl is not FAIL) == (tr is not FAIL) == required
    if required:
        history_map(tl,tr,rebracket(xx,yy,zz))
        temporal_defined += 1
    temporal_checks += 1
assert guard(unit_at(2),empty) and guard(empty,unit_at(1))
assert not guard(unit_at(2),unit_at(1))
assert attempt(lambda:temporal(temporal(unit_at(2),empty),unit_at(1))) is FAIL
assert attempt(lambda:temporal(unit_at(2),temporal(empty,unit_at(1)))) is FAIL
legal = temporal(temporal(unit_at(0),unit_at(1)),unit_at(2))
assert (len(legal.e),len(legal.o)) == (6,12)
assert attempt(lambda:temporal(temporal(u,empty),unit_at(1))) is not FAIL
assert temporal_checks == 216
print(f"pr2_temporal: triples={temporal_checks} defined={temporal_defined} legal_archive={len(legal.e)} legal_edges={len(legal.o)} empty_middle_adjacent_guards_insufficient=True")

# None denotes +infinity in m and -infinity in M/s; no finite float times.
def theta(x):
    return (read_pair(x), min((v[0] for v in x.e.values()),default=None),
            max((v[0] for v in x.e.values()),default=None),
            max((x.e[e][0] for e in x.w),default=None))

def lo(*values):
    return min((v for v in values if v is not None),default=None)

def hi(*values):
    return max((v for v in values if v is not None),default=None)

def gamma(s, t):
    return None if s is None or t is None else max(s,t)+1

def theta_add(x, y):
    return pair_add(x[0],y[0]),lo(x[1],y[1]),hi(x[2],y[2]),hi(x[3],y[3])

def theta_mul(x, y):
    g0 = gamma(x[3],y[3])
    return pair_mul(x[0],y[0]),lo(x[1],y[1]),hi(x[2],y[2],g0),g0

def theta_guard(x, y):
    return x[2] is None or y[1] is None or x[2] < y[1]

def ceiling_state(s, selected_time=None, floor=0, ceiling=10):
    selected_time = s if selected_time is None else selected_time
    e = {"pos":(selected_time,origin,1,("leaf",0)),
         "neg":(s,origin,-1,("leaf",0)),
         "old_min":(floor,origin,1,("leaf",9)),
         "old_max":(ceiling,origin,1,("leaf",9))}
    return valid(Rich(e,frozenset(),frozenset(("pos","neg")),frozenset(("pos",))))

c0,c9 = ceiling_state(0),ceiling_state(9)
selected_low = ceiling_state(9,selected_time=0)
assert theta(c0) == (({},delta),0,10,0)
assert theta(c9) == (({},delta),0,10,9)
assert max(selected_low.e[e][0] for e in selected_low.a) == 0
assert theta(selected_low)[3] == 9
theta_states = [empty,unit_at(-1),u,unit_at(1),current_empty,c0,c9,selected_low]
theta_pairs,theta_unary,threshold_checks = 0,0,0
for xx in theta_states:
    tx = theta(xx)
    bg,zx = tx[0]
    assert theta(neg(xx)) == ((bg,plus_c(bg,minus_c(zx))),*tx[1:])
    theta_unary += 1
    for points in (set(),{origin},{v}):
        assert theta(at(xx,points)) == ((bg,{p:a for p,a in zx.items() if p in points}),*tx[1:])
        theta_unary += 1
    for k in (-3,0,4):
        assert theta(time_shift(xx,k)) == (tx[0],*(a+k if a is not None else None for a in tx[1:]))
        theta_unary += 1
    for t0 in range(-3,13):
        assert guard(xx,unit_at(t0)) == (tx[2] is None or tx[2] < t0)
        assert guard(unit_at(t0),xx) == (tx[1] is None or t0 < tx[1])
        threshold_checks += 2
    for yy in theta_states:
        ty = theta(yy)
        assert theta(add(xx,yy)) == theta_add(tx,ty)
        assert theta(mul(xx,yy)) == theta_mul(tx,ty)
        out = attempt(lambda: temporal(xx,yy))
        assert (out is not FAIL) == theta_guard(tx,ty)
        if out is not FAIL:
            assert theta(out) == theta_add(tx,ty)
        theta_pairs += 1
assert (theta_pairs,theta_unary,threshold_checks) == (64,56,256)
c0_twice,c9_twice = [mul(mul(xx,u),u) for xx in (c0,c9)]
maxima = theta(c0_twice)[2],theta(c9_twice)[2]
assert maxima == (10,11)
assert q(temporal(c0_twice,unit_at(11))) == 2
assert attempt(lambda:temporal(c9_twice,unit_at(11))) is FAIL
assert theta(mul(selected_low,u))[3] == 10  # Using max selected A would give 1.
same_theta_time = ceiling_state(9,selected_time=5)
assert theta(selected_low) == theta(same_theta_time)
time_filter_reads = tuple(q(filt(xx,lambda e,xx=xx:xx.e[e][0] == 0))
                          for xx in (selected_low,same_theta_time))
assert time_filter_reads == (1,0)
amplification_checks = 0
amp0,amp2 = [ceiling_state(s,floor=-1,ceiling=2) for s in (0,2)]
amp_empty = valid(replace(amp0,w=frozenset(),a=frozenset()))
for xx,yy in ((amp0,amp2),(amp_empty,replace(amp2,a=frozenset()))):
    tx,ty = theta(xx),theta(yy)
    assert tx[:3] == ty[:3] and tx[3] != ty[3]
    early = tx[1]
    n = tx[2] - (tx[3] if tx[3] is not None else ty[3]) + 1
    r0 = ty[3]+n
    for j in range(1,n+1):
        xx,yy = mul(xx,unit_at(early)),mul(yy,unit_at(early))
        for rich,old_t in ((xx,tx),(yy,ty)):
            s0 = old_t[3]
            expected_s = None if s0 is None else s0+j
            assert theta(rich)[2:] == (hi(old_t[2],expected_s),expected_s)
    assert theta(xx)[2] < r0 == theta(yy)[2]
    assert attempt(lambda:temporal(xx,unit_at(r0))) is not FAIL
    assert attempt(lambda:temporal(yy,unit_at(r0))) is FAIL
    amplification_checks += 1
print(f"pr2_theta: pairs={theta_pairs} unary={theta_unary} integer_thresholds={threshold_checks} amplification_cases={amplification_checks} archive_maxima={maxima[0]},{maxima[1]} following_U11=defined,failed time_filter={time_filter_reads[0]},{time_filter_reads[1]}")

theta_law_checks = 0
law_states = [empty,u,current_empty,c9]
for xx,yy,zz in product(law_states,repeat=3):
    assert theta(add(add(xx,yy),zz)) == theta(add(xx,add(yy,zz)))
    assert theta(mul(xx,add(yy,zz))) == theta(add(mul(xx,yy),mul(xx,zz)))
    assert theta(mul(add(xx,yy),zz)) == theta(add(mul(xx,zz),mul(yy,zz)))
    theta_law_checks += 1
for xx,yy in product(theta_states,repeat=2):
    assert theta(mul(xx,yy)) == theta(mul(yy,xx))
    assert theta(add(xx,yy)) == theta(add(yy,xx))
    assert theta(add(xx,empty)) == theta(xx)
    assert theta(mul(xx,u))[3] != 0
theta_left,theta_right = mul(mul(u,u),unit_at(1)),mul(u,mul(u,unit_at(1)))
assert theta(theta_left) == (({},delta),0,2,2)
assert theta(theta_right) == (({},delta),0,3,3)
assert theta(mul(u,empty)) == (({},{}),0,0,None) != theta(empty)
print(f"pr2_theta_laws: rich_triples={theta_law_checks} associativity_maxima={theta(theta_left)[2]},{theta(theta_right)[2]} zero_absorbing=False")

small = [sparse(dict(zip((origin,v,h),cs))) for cs in product((-1,0,1),repeat=3) if any(cs)]
extreme_checks,unit_product_checks = 0,0
for ca,cb in product(small,repeat=2):
    cc = conv(ca,cb)
    assert cc
    for extremum in (min,max):
        pa,pb = extremum(ca),extremum(cb)
        target = tuple(a+b for a,b in zip(pa,pb))
        assert extremum(cc) == target and cc[target] == ca[pa]*cb[pb]
        splits = [(p0,q0) for p0 in ca for q0 in cb
                  if tuple(a+b for a,b in zip(p0,q0)) == target]
        assert splits == [(pa,pb)]
    if cc == delta:
        assert len(ca) == len(cb) == 1
        assert next(iter(ca.values()))*next(iter(cb.values())) == 1
        unit_product_checks += 1
    extreme_checks += 1
unit_checks = 0
for point,sgn in product((origin,v,tuple(-a for a in v),h,tuple(-a for a in h)),(-1,1)):
    assert conv({point:sgn},{tuple(-a for a in point):sgn}) == delta
    unit_checks += 1
nonunit = {origin:2,v:-1}
assert sum(nonunit.values()) == 1 and len(nonunit) == 2
inverse_candidates = 0
for cs in product((-1,0,1),repeat=3):
    candidate = sparse(dict(zip((tuple(-a for a in v),origin,v),cs)))
    assert conv(nonunit,candidate) != delta
    inverse_candidates += 1
assert (len(small),extreme_checks,unit_checks,inverse_candidates) == (26,676,10,27)
print(f"pr2_extrema: nonzero_samples={len(small)} pairs={extreme_checks} products_delta0={unit_product_checks} signed_delta_inverses={unit_checks} nonunit_augmentation={sum(nonunit.values())} inverse_candidates_rejected={inverse_candidates}")

def tree_shapes(start, n):
    if n == 1:
        return [start]
    return [(left,right) for k in range(1,n) for left in tree_shapes(start,k)
            for right in tree_shapes(start+k,n-k)]

def tree_time(tree, times, delay=1):
    if isinstance(tree,int):
        return times[tree]
    return max(tree_time(tree[0],times,delay),tree_time(tree[1],times,delay))+delay

def leaf_depths(tree, depth=0):
    return [(tree,depth)] if isinstance(tree,int) else (
        leaf_depths(tree[0],depth+1)+leaf_depths(tree[1],depth+1))

def tree_rich(tree, times):
    return unit_at(times[tree]) if isinstance(tree,int) else mul(
        tree_rich(tree[0],times),tree_rich(tree[1],times))

tree_checks,rich_tree_checks = 0,0
for n in (3,4):
    for tree in tree_shapes(0,n):
        for times in product((-2,0,3),repeat=n):
            for delay in (1,2,3):
                assert tree_time(tree,times,delay) == max(times[i]+delay*d for i,d in leaf_depths(tree))
                tree_checks += 1
        times = tuple(range(n))
        rich = tree_rich(tree,times)
        expected = max(times[i]+d for i,d in leaf_depths(tree))
        assert theta(rich)[2:] == (expected,expected)
        rich_tree_checks += 1
translation_checks,delay_transport_checks = 0,0
for a,b,c in product(range(-3,4),range(-3,4),(-2,0,3)):
    assert max(a,b)+1+c == max(a+c,b+c)+1
    translation_checks += 1
for scale,b,delay,t0,t1 in product((1,2,3),(-2,0,3),(1,2,3),range(-2,3),range(-2,3)):
    assert scale*(max(t0,t1)+delay)+b == max(scale*t0+b,scale*t1+b)+scale*delay
    delay_transport_checks += 1
assert 2*(max(0,0)+1) != max(2*0,2*0)+1
assert (tree_checks,rich_tree_checks,translation_checks,delay_transport_checks) == (1377,7,147,675)
print(f"pr2_clock: depth_cases={tree_checks} rich_trees={rich_tree_checks} translations={translation_checks} scaled_delay_cases={delay_transport_checks} fixed_delay_scaling_rejected=True")

def mul_at(x, y, reference):
    z = mul(x,y)
    events = dict(z.e)
    for key in z.w:
        t0,p0,s0,r0 = events[key]
        events[key] = (t0,tuple(a-b for a,b in zip(p0,reference)),s0,r0)
    return valid(replace(z,e=events))

def affine_point(p, matrix, offset):
    return tuple(sum(a*b for a,b in zip(row,p))+v0 for row,v0 in zip(matrix,offset))

def affine_rich(x, matrix, offset):
    return valid(replace(x,e={key:(t0,affine_point(p0,matrix,offset),s0,r0)
                              for key,(t0,p0,s0,r0) in x.e.items()}))

def push_c(c, function):
    out = {}
    for p0,value in c.items():
        target = function(p0)
        out[target] = out.get(target,0)+value
    return sparse(out)

def conv_at(c, d, reference):
    return {tuple(a-b for a,b in zip(p0,reference)):value for p0,value in conv(c,d).items()}

matrices = [((1,0,0),(0,1,0),(0,0,1)),((2,0,0),(0,2,0),(0,0,2)),
            ((1,1,0),(0,1,0),(0,0,-1)),((0,0,0),(0,1,0),(0,0,1))]
references,offset = (origin,(1,2,-1)),(2,-1,3)
reference_states = [u,sx,sy,current_empty]
reference_checks,affine_checks,space_unit_checks = 0,0,0
for reference in references:
    for xx,yy in product(reference_states,repeat=2):
        result = mul_at(xx,yy,reference)
        standard = mul(xx,yy)
        assert result.e.keys() == standard.e.keys()
        assert (result.o,result.w,result.a) == (standard.o,standard.w,standard.a)
        assert all((v0[0],v0[2:]) == (standard.e[e][0],standard.e[e][2:]) for e,v0 in result.e.items())
        assert (q(result),charge(result,result.w),len(result.e)) == (
            q(xx)*q(yy),0,len(xx.e)+len(yy.e)+len(xx.w)*len(yy.w))
        assert read_pair(result) == tuple(conv_at(a,b,reference) for a,b in zip(read_pair(xx),read_pair(yy)))
        if reference == origin:
            assert result == standard
        reference_checks += 1
        for matrix in matrices:
            function = lambda p,matrix=matrix:affine_point(p,matrix,offset)
            transported = affine_rich(result,matrix,offset)
            assert transported == mul_at(affine_rich(xx,matrix,offset),affine_rich(yy,matrix,offset),function(reference))
            assert read_pair(transported) == tuple(push_c(c,function) for c in read_pair(result))
            for a,b in zip(read_pair(xx),read_pair(yy)):
                assert push_c(conv_at(a,b,reference),function) == conv_at(push_c(a,function),push_c(b,function),function(reference))
            affine_checks += 1
    for c in small:
        assert conv_at({reference:1},c,reference) == conv_at(c,{reference:1},reference) == c
        space_unit_checks += 1
assert mul_at(spatial(u,offset=1),spatial(u,offset=1),origin) != spatial(mul_at(u,u,origin),offset=1)
collapsed = realize({}, {origin:1,v:1})
matrix = matrices[-1]
function = lambda p:affine_point(p,matrix,origin)
transported = affine_rich(collapsed,matrix,origin)
assert transported.e.keys() == collapsed.e.keys() and len(transported.e) == 4
wrong_before = affine_rich(at(collapsed,{origin}),matrix,origin)
wrong_after = at(transported,{origin})
assert (q(wrong_before),q(wrong_after)) == (1,2)
pull_selected = filt(collapsed,lambda e:function(collapsed.e[e][1]) == origin)
assert affine_rich(pull_selected,matrix,origin) == wrong_after
assert push_c({origin:1},function) == {origin:1} != read_pair(wrong_after)[1]
assert push_c(read_pair(pull_selected)[1],function) == read_pair(wrong_after)[1] == {origin:2}
assert (reference_checks,affine_checks,space_unit_checks) == (32,128,52)
print(f"pr2_reference: rich_pairs={reference_checks} affine_transports={affine_checks} space_units={space_unit_checks} noninjective_events={len(transported.e)} direct_image_filter={q(wrong_before)},{q(wrong_after)} pullback_filter={q(wrong_after)}")

# PR3: finite checks only, using the original Rich archive operations.
import json as pr3_json
from random import Random as pr3_Random
from itertools import combinations as pr3_combinations

pr3_counts = {"source_updates": 0, "source_witnesses": 0,
              "causal_updates": 0, "product_antichains": 0,
              "bare_probes": 0, "legal_probes": 0,
              "mobius_profiles": 0, "mobius_coefficients": 0,
              "bounded_contexts": 0, "redundant_insertions": 0}

def pr3_bytes(value):
    def canonical(z):
        if isinstance(z, dict):
            return sorted([[canonical(k), canonical(v)] for k, v in z.items()],
                          key=lambda item: pr3_json.dumps(item, sort_keys=True))
        if isinstance(z, (set, frozenset)):
            return sorted([canonical(k) for k in z], key=pr3_json.dumps)
        if isinstance(z, (tuple, list)):
            return [canonical(k) for k in z]
        return z
    return pr3_json.dumps(canonical(value), separators=(",", ":")).encode("utf-8")

def pr3_equal(actual, expected, counter):
    assert pr3_bytes(actual) == pr3_bytes(expected), (counter, actual, expected)
    pr3_counts[counter] += 1

def pr3_rho_src(x):
    return tuple(sparse(c) for c in coarse(x, lambda e: (x.e[e][1], x.e[e][3])))

def pr3_pair_product(c, d):
    out = {}
    for (p, r), n in c.items():
        for (q0, s), m in d.items():
            key = (tuple(a+b for a, b in zip(p, q0)), ("pair", r, s))
            out[key] = out.get(key, 0) + n*m
    return sparse(out)

def pr3_alpha(x, e, timed=False):
    t0, p, sign, source = x.e[e]
    return (p, sign, source, t0) if timed else (p, sign, source)

def pr3_U(x, e, timed=False):
    return frozenset(pr3_alpha(x, d, timed) for d in x.w
                     if e == d or (e, d) in x.o)

def pr3_profile(x, timed=False):
    out = {}
    for e in x.w:
        key = (pr3_alpha(x, e, timed), int(e in x.a), pr3_U(x, e, timed))
        out[key] = out.get(key, 0) + x.e[e][2]
    return sparse(out)

def pr3_V(profile):
    return frozenset(a for a, b, upper in profile)

def pr3_causal_filter(x, Q, timed=False):
    # The target domain is Omega = Rich.w, including unselected targets.
    targets = frozenset(d for d in x.w if pr3_alpha(x, d, timed) in Q)
    assert targets <= x.w
    return filt(x, lambda e: any(e == d or (e, d) in x.o for d in targets))

def pr3_diamond(a, b):
    return (tuple(p+q0 for p, q0 in zip(a[0], b[0])), a[1]*b[1],
            ("pair", a[2], b[2]))

def pr3_profile_product(c, d):
    out = {}
    for (a, b, upper), n in c.items():
        for (aa, bb, uu), m in d.items():
            joined = pr3_diamond(a, aa)
            key = (joined, b*bb, frozenset((joined,)))
            out[key] = out.get(key, 0) + n*m
    return sparse(out)

def pr3_subsets(values):
    values = sorted(values, key=repr)
    return [frozenset(c) for n in range(len(values)+1)
            for c in pr3_combinations(values, n)]

pr3_U0 = integer(1)
assert charge(pr3_U0, pr3_U0.w) == 0 and q(pr3_U0) == 1
assert len(pr3_U0.w) == 2 and not pr3_U0.o

class pr3_SignTargets:
    # Membership in the fixed attribute set {a in Attr : sign(a) = eps}.
    def __init__(self, eps):
        assert eps in (-1, 1)
        self.eps = eps
    def __contains__(self, a):
        return a[1] == self.eps

def pr3_P_eps(z, eps):
    return pr3_causal_filter(mul(z, pr3_U0), pr3_SignTargets(eps))

def pr3_probe(x, Q, v0, eta):
    p, eps, tau = v0
    selected = x if eta == 1 else neg(x)
    H = pr3_causal_filter(filt(at(selected, {p}),
                              lambda e: selected.e[e][3] == tau), Q)
    target = (p, eps, ("pair", tau, ("leaf", 0)))
    return q(pr3_causal_filter(mul(H, pr3_U0), {target}))

pr3_rng = pr3_Random(20260910)
pr3_samples = []
for pr3_i in range(48):
    pr3_n = pr3_rng.choice((0, 2, 4))
    pr3_signs = [1]*(pr3_n//2) + [-1]*(pr3_n//2)
    pr3_rng.shuffle(pr3_signs)
    pr3_events = {}
    for pr3_j, pr3_sign in enumerate(pr3_signs):
        pr3_p = origin if pr3_i % 2 else pr3_rng.choice((origin, v, h))
        pr3_r = ("leaf", 0) if pr3_i % 2 else pr3_rng.choice(
            (("leaf", 0), ("leaf", 7), ("pair", ("leaf", 0), ("leaf", 7))))
        pr3_events[pr3_j] = (pr3_rng.randrange(-1, 3), pr3_p, pr3_sign, pr3_r)
    pr3_whole = frozenset(pr3_events)
    for pr3_j in range(pr3_rng.randrange(3)):
        pr3_events[("old", pr3_j)] = (pr3_rng.randrange(-2, 4), v, 1, ("leaf", 9))
    pr3_edges = {(a, b) for a in pr3_events for b in pr3_events
                 if pr3_events[a][0] < pr3_events[b][0] and pr3_rng.randrange(3) == 0}
    pr3_chosen = frozenset(e for e in sorted(pr3_whole) if pr3_rng.randrange(2))
    pr3_samples.append(valid(Rich(pr3_events, closure(pr3_edges), pr3_whole, pr3_chosen)))

for pr3_x in pr3_samples:
    pr3_y = pr3_rng.choice(pr3_samples)
    pr3_w, pr3_z = pr3_rho_src(pr3_x)
    pr3_wy, pr3_zy = pr3_rho_src(pr3_y)
    pr3_S, pr3_L = {origin, h}, {("leaf", 0), ("leaf", 7)}
    pr3_equal(pr3_rho_src(add(pr3_x, pr3_y)),
              (plus_c(pr3_w, pr3_wy), plus_c(pr3_z, pr3_zy)), "source_updates")
    pr3_mul = mul(pr3_x, pr3_y)
    pr3_equal(pr3_rho_src(pr3_mul),
              (pr3_pair_product(pr3_w, pr3_wy), pr3_pair_product(pr3_z, pr3_zy)),
              "source_updates")
    assert all(r[0] == "pair" for c in pr3_rho_src(pr3_mul) for p, r in c)
    pr3_equal(pr3_rho_src(neg(pr3_x)), (pr3_w, plus_c(pr3_w, minus_c(pr3_z))),
              "source_updates")
    pr3_equal(pr3_rho_src(at(pr3_x, pr3_S)),
              (pr3_w, {k: n for k, n in pr3_z.items() if k[0] in pr3_S}), "source_updates")
    pr3_source_filtered = filt(pr3_x, lambda e: pr3_x.e[e][3] in pr3_L)
    pr3_equal(pr3_rho_src(pr3_source_filtered),
              (pr3_w, {k: n for k, n in pr3_z.items() if k[1] in pr3_L}), "source_updates")
    assert not any(a in pr3_mul.w for a, b in pr3_mul.o)
    assert not any(a in pr3_mul.w and b in pr3_mul.w for a, b in pr3_mul.o)
    pr3_counts["product_antichains"] += 1
    pr3_g, pr3_gy = pr3_profile(pr3_x), pr3_profile(pr3_y)
    assert pr3_V(pr3_g) == {pr3_alpha(pr3_x, e) for e in pr3_x.w}
    assert all(pr3_alpha(pr3_x, e) in pr3_U(pr3_x, e) for e in pr3_x.w)
    pr3_equal(pr3_profile(add(pr3_x, pr3_y)), plus_c(pr3_g, pr3_gy), "causal_updates")
    pr3_equal(pr3_profile(neg(pr3_x)),
              push_c(pr3_g, lambda k: (k[0], 1-k[1], k[2])), "causal_updates")
    pr3_equal(pr3_profile(at(pr3_x, pr3_S)),
              push_c(pr3_g, lambda k: (k[0], k[1]*int(k[0][0] in pr3_S), k[2])),
              "causal_updates")
    pr3_equal(pr3_profile(pr3_source_filtered),
              push_c(pr3_g, lambda k: (k[0], k[1]*int(k[0][2] in pr3_L), k[2])),
              "causal_updates")
    for pr3_Q in pr3_subsets(pr3_V(pr3_g)):
        pr3_equal(pr3_profile(pr3_causal_filter(pr3_x, pr3_Q)),
                  push_c(pr3_g, lambda k: (k[0], k[1]*int(bool(k[2] & pr3_Q)), k[2])),
                  "causal_updates")
    pr3_equal(pr3_profile(pr3_mul), pr3_profile_product(pr3_g, pr3_gy), "causal_updates")
    pr3_equal(pr3_profile(time_shift(pr3_x, 3)), pr3_g, "causal_updates")
    # Exercise both success and failure, then force a legal nonempty timing if needed.
    assert guard(pr3_x, pr3_y) == theta_guard(theta(pr3_x), theta(pr3_y))
    pr3_late = time_shift(pr3_y, (theta(pr3_x)[2] or 0) - (theta(pr3_y)[1] or 0) + 1)
    assert guard(pr3_x, pr3_late)
    pr3_equal(pr3_profile(temporal(pr3_x, pr3_late)),
              plus_c(push_c(pr3_g, lambda k: (k[0], k[1], k[2] | pr3_V(pr3_gy))), pr3_gy),
              "causal_updates")

pr3_l0, pr3_l1 = ("leaf", 0), ("leaf", 1)
pr3_bracket_left, pr3_bracket_right = mul(mul(u, u), two), mul(u, mul(u, two))
pr3_expected_left = {(origin, ("pair", ("pair", pr3_l0, pr3_l0), r)): 1
                     for r in (pr3_l0, pr3_l1)}
pr3_expected_right = {(origin, ("pair", pr3_l0, ("pair", pr3_l0, r))): 1
                      for r in (pr3_l0, pr3_l1)}
for pr3_actual, pr3_expected in (
        (pr3_rho_src(pr3_bracket_left), ({}, pr3_expected_left)),
        (pr3_rho_src(pr3_bracket_right), ({}, pr3_expected_right)),
        (pr3_rho_src(source7), ({}, {(origin, ("leaf", 7)): 1})),
        (pr3_rho_src(source8), ({}, {(origin, ("leaf", 8)): 1})),
        (pr3_rho_src(comm_left), ({}, {(origin, ("pair", ("leaf", 7), ("leaf", 8))): 1})),
        (pr3_rho_src(comm_right), ({}, {(origin, ("pair", ("leaf", 8), ("leaf", 7))): 1}))):
    pr3_equal(pr3_actual, pr3_expected, "source_witnesses")
assert set(pr3_expected_left).isdisjoint(pr3_expected_right)
assert pr3_rho_src(comm_left) != pr3_rho_src(comm_right)
assert pr3_rho_src(source7)[1] != pr3_rho_src(source8)[1]

# D1: bare probes cancel, including equality after N, but the legal isolation separates.
pr3_d1e = {e: (t0, origin, sign, pr3_l0)
           for e, t0, sign in zip("abcd", (0, 1, 2, 2), (1, -1, 1, -1))}
pr3_d1x = valid(Rich(pr3_d1e, closure({("a", "b"), ("b", "c"), ("b", "d")}),
                     frozenset(pr3_d1e), frozenset("ab")))
pr3_d1y = replace(pr3_d1x, a=frozenset())
pr3_vp, pr3_vm = (origin, 1, pr3_l0), (origin, -1, pr3_l0)
assert pr3_U(pr3_d1x, "a") == pr3_U(pr3_d1x, "b") == {pr3_vp, pr3_vm}
for pr3_Q, pr3_S, pr3_L in product(pr3_subsets({pr3_vp, pr3_vm}),
                                   (set(), {origin}), (set(), {pr3_l0})):
    pr3_raw, pr3_complements = [], []
    for pr3_x in (pr3_d1x, pr3_d1y):
        for pr3_dest, pr3_z0 in ((pr3_raw, pr3_x), (pr3_complements, neg(pr3_x))):
            pr3_dest.append(q(pr3_causal_filter(filt(at(pr3_z0, pr3_S),
                                    lambda e: pr3_z0.e[e][3] in pr3_L), pr3_Q)))
    assert pr3_raw == [0, 0] and pr3_complements[0] == pr3_complements[1]
    pr3_counts["bare_probes"] += 1
pr3_isolated = tuple(q(pr3_P_eps(z, 1)) for z in (pr3_d1x, pr3_d1y))
assert pr3_isolated == (1, 0)
assert tuple(pr3_probe(z, {pr3_vp, pr3_vm}, pr3_vp, 1) for z in (pr3_d1x, pr3_d1y)) == (1, 0)
# Complemented bare readings are equal, NOT identically zero.
assert tuple(q(pr3_causal_filter(neg(z), {pr3_vp})) for z in (pr3_d1x, pr3_d1y)) == (1, 1)

# Targets outside Omega must have no effect, even when archived and reachable.
pr3_outside = valid(Rich({"a": (0, origin, 1, pr3_l0), "b": (0, origin, -1, pr3_l0),
                         "old": (1, origin, 1, ("leaf", 9))},
                        frozenset({("a", "old")}), frozenset("ab"), frozenset("a")))
assert set(pr3_outside.e) - pr3_outside.w == {"old"}
assert q(pr3_causal_filter(pr3_outside, {pr3_alpha(pr3_outside, "old")})) == 0
assert q(past(pr3_outside, {"old"})) == 1
assert pr3_U(pr3_outside, "a") == {pr3_vp}

# Full finite Boolean inversion through legal carrier-parameter contexts, both selection bits.
for pr3_x in pr3_samples + [pr3_d1x, pr3_d1y, pr3_outside]:
    pr3_D = frozenset(pr3_alpha(pr3_x, e) for e in pr3_x.w)
    pr3_powerset = pr3_subsets(pr3_D)
    pr3_restored = {}
    for pr3_v0, pr3_eta in product(sorted(pr3_D, key=repr), (0, 1)):
        pr3_f = {}
        for pr3_Q in pr3_powerset:
            pr3_f[pr3_Q] = pr3_probe(pr3_x, pr3_Q, pr3_v0, pr3_eta)
            pr3_expected = sum(pr3_x.e[e][2] for e in pr3_x.w
                               if pr3_alpha(pr3_x, e) == pr3_v0
                               and int(e in pr3_x.a) == pr3_eta and pr3_U(pr3_x, e) & pr3_Q)
            assert pr3_f[pr3_Q] == pr3_expected
            pr3_counts["legal_probes"] += 1
        pr3_h = {W: pr3_f[pr3_D] - pr3_f[pr3_D-W] for W in pr3_powerset}
        for pr3_upper in pr3_powerset:
            pr3_coeff = sum((-1)**(len(pr3_upper)-len(W))*pr3_h[W]
                            for W in pr3_subsets(pr3_upper))
            if pr3_coeff:
                pr3_restored[(pr3_v0, pr3_eta, pr3_upper)] = pr3_coeff
            pr3_counts["mobius_coefficients"] += 1
    pr3_equal(pr3_restored, pr3_profile(pr3_x), "mobius_profiles")

# B2: a bounded family of the actual signature; no new primitive is used.
assert pr3_profile(causal) == pr3_profile(no_causal) == {
    (pr3_vp, 1, frozenset((pr3_vp,))): 2,
    (pr3_vm, 0, frozenset((pr3_vm,))): -2}
pr3_ops = [neg, lambda z: at(z, {origin}), lambda z: at(z, {v}),
           lambda z: filt(z, lambda e: z.e[e][3] == pr3_l0),
           lambda z: add(z, u), lambda z: add(u, z),
           lambda z: mul(z, u), lambda z: mul(u, z),
           lambda z: temporal(z, unit_at(2)), lambda z: temporal(unit_at(-1), z),
           lambda z: time_shift(z, 1), lambda z: time_shift(z, -1)]
pr3_ops += [lambda z, Q=Q: pr3_causal_filter(z, Q)
            for Q in pr3_subsets({pr3_vp, pr3_vm})]
for pr3_depth in range(3):
    for pr3_word in product(pr3_ops, repeat=pr3_depth):
        assert observe(pr3_word, causal, q) == observe(pr3_word, no_causal, q)
        pr3_counts["bounded_contexts"] += 1
pr3_time_reads = tuple(q(pr3_causal_filter(z, {(origin, 1, pr3_l0, 1)}, timed=True))
                       for z in (causal, no_causal))
assert pr3_time_reads == (2, 1)
pr3_J_reads = tuple(q(filt(z, lambda e: any((e, d) in z.o for d in z.w)))
                    for z in (causal, no_causal))
assert pr3_J_reads == (1, 0)

# D2: inserting a same-attribute generating edge creates a cross-attribute closure edge.
pr3_d2e = {e: (t0, origin, sign, pr3_l0)
           for e, t0, sign in zip("abcd", (0, 1, 2, 0), (1, 1, -1, -1))}
pr3_d2x = valid(Rich(pr3_d2e, frozenset({("b", "c")}), frozenset(pr3_d2e), frozenset("a")))
pr3_d2y = valid(replace(pr3_d2x, o=closure(pr3_d2x.o | {("a", "b")})))
assert pr3_rho_src(pr3_d2x) == pr3_rho_src(pr3_d2y)
assert theta(pr3_d2x)[1:] == theta(pr3_d2y)[1:]
pr3_edge_reads = tuple(q(pr3_causal_filter(z, {pr3_vm})) for z in (pr3_d2x, pr3_d2y))
assert pr3_edge_reads == (0, 1)

# D3: all singleton hitting marginals agree, but a two-attribute query differs.
pr3_d3e = {"e1": (0, origin, 1, pr3_l0), "e2": (0, origin, 1, pr3_l0),
           "b": (1, origin, -1, ("leaf", 1)), "c": (1, origin, -1, ("leaf", 2))}
pr3_d3x = valid(Rich(pr3_d3e, frozenset({("e2", "b"), ("e2", "c")}),
                     frozenset(pr3_d3e), frozenset(("e1", "e2"))))
pr3_d3y = valid(replace(pr3_d3x, o=frozenset({("e1", "b"), ("e2", "c")})))
for pr3_attr in {pr3_alpha(pr3_d3x, e) for e in pr3_d3x.w}:
    assert q(pr3_causal_filter(pr3_d3x, {pr3_attr})) == q(pr3_causal_filter(pr3_d3y, {pr3_attr}))
pr3_bc = {pr3_alpha(pr3_d3x, e) for e in ("b", "c")}
pr3_marginal_reads = tuple(q(pr3_causal_filter(z, pr3_bc)) for z in (pr3_d3x, pr3_d3y))
assert pr3_marginal_reads == (1, 2)

# A lawful edge insertion with U(f) <= U(e) preserves every current upper set.
for pr3_x in pr3_samples:
    for pr3_e, pr3_f0 in product(sorted(pr3_x.w), repeat=2):
        if (pr3_x.e[pr3_e][0] < pr3_x.e[pr3_f0][0]
                and (pr3_e, pr3_f0) not in pr3_x.o
                and pr3_U(pr3_x, pr3_f0) <= pr3_U(pr3_x, pr3_e)):
            pr3_y = valid(replace(pr3_x, o=closure(pr3_x.o | {(pr3_e, pr3_f0)})))
            assert all(pr3_U(pr3_x, e) == pr3_U(pr3_y, e) for e in pr3_x.w)
            assert pr3_profile(pr3_x) == pr3_profile(pr3_y)
            pr3_counts["redundant_insertions"] += 1
assert pr3_counts["redundant_insertions"] > 0

# D5: even the time-attribute profile need not recover incidence or history isomorphism.
pr3_d5e = {e: (t0, origin, 1, pr3_l0)
           for e, t0 in zip(("a1", "a2", "b1", "b2"), (0, 0, 1, 1))}
pr3_d5e.update({("n", i): (0, origin, -1, pr3_l0) for i in range(4)})
pr3_d5x = valid(Rich(pr3_d5e, frozenset({("a1", "b1"), ("a2", "b2")}),
                     frozenset(pr3_d5e), frozenset(("a1", "a2", "b1", "b2"))))
pr3_d5y = valid(replace(pr3_d5x, o=frozenset({("a1", "b1"), ("a2", "b1")})))
assert pr3_profile(pr3_d5x, timed=True) == pr3_profile(pr3_d5y, timed=True)
pr3_indegrees = tuple(sorted(sum((a, b) in z.o for a in z.e) for b in ("b1", "b2"))
                      for z in (pr3_d5x, pr3_d5y))
assert pr3_indegrees == ([1, 1], [0, 2])
print(f"pr3_source: samples={len(pr3_samples)} updates={pr3_counts['source_updates']} witnesses={pr3_counts['source_witnesses']} brackets={len(pr3_bracket_left.e)},{len(pr3_bracket_right.e)} B1=distinct ordered_pair=distinct")
print(f"pr3_causal: updates={pr3_counts['causal_updates']} product_antichains={pr3_counts['product_antichains']} targets=Omega bare_probes={pr3_counts['bare_probes']} P_plus={pr3_isolated[0]},{pr3_isolated[1]} legal_probes={pr3_counts['legal_probes']} mobius_profiles={pr3_counts['mobius_profiles']} mobius_coefficients={pr3_counts['mobius_coefficients']} bounded_contexts={pr3_counts['bounded_contexts']} B2_time={pr3_time_reads[0]},{pr3_time_reads[1]} strict_successor={pr3_J_reads[0]},{pr3_J_reads[1]} edge={pr3_edge_reads[0]},{pr3_edge_reads[1]} marginals={pr3_marginal_reads[0]},{pr3_marginal_reads[1]} redundant_insertions={pr3_counts['redundant_insertions']} timed_nonisomorphism=True")
print("ALL_FINITE_CHECKS_PASSED")
```

**原基线收据说明（PR1 追加）。** 紧接的“本次运行”及其输出是原版本的历史记录；扩充后的实际重跑与新增计数见 §17 的 PR1 核验收据，不以这份旧输出代替本轮运行。

本次运行退出码为 `0`，实际标准输出如下：

```text
balanced_states=105 pair_checks=11025
worked_product: q=1 archive=14 whole=8 selected=3 causal_pairs=27
parallel_pairs=3 temporal_pairs=11 both_q=2
zero_products: (archive,whole,selected,q)=(4,0,0,0),(14,8,6,0)
raw_laws: sum_with_negative_archive=4 unit_product_archive=8 associativity_archives=28,32
filters: spatial=(1,0) source=(2,1) causal=(2,1); restricted_q=0 omitted_charge=1
transport: balanced_added_charge=0 unbalanced_defect=1; bin_complement=(0,-1); image_defect_and_cycle=confirmed
coordinates: linear_and_time_translation_commute=True spatial_translation_commutes=False
rationals: sum=-1 product=-3/4 negative=-1/2 division=-1/3 zero_divisor=rejected
inverse_prefixes: (0,1,1,1)->(0,1,1,1); (1,1/2,1/3,1/4)->(1,2,3,4)
sources: shared_difference={0} shared_square={1,4}; independent_difference={-1,0,1} independent_product={1,2,4}
ALL_FINITE_CHECKS_PASSED
```

核验解释：这些读数仅覆盖上述有限域及具名例子。它们不证明任意图、任意 Cauchy 序列或 ZFC 的一致性，也不是 Lean 内核检查。新文档之外未改动任何仓库文件；完整仓库准入检查、独立数学评审和 PR 交付是调用方的后续步骤。

<a id="pr1-observation"></a>

## 14. PR1 增补 A：严格观察与最大保域同余

本节为 §9 命题 11 增加“允许哪些后续操作”的参数。原命题 1–15 不改；一般结论不把档案历史压成数值，也不预设历史同构与任意新观察之间的包含关系。

**定义 16（部分签名与全部一孔上下文）。** 固定一个集合 $X$、一个集合签名 $\Sigma$。每个符号 $f\in\Sigma$ 指定一个有限元数 $n_f\in\mathbb N$ 和一个确定部分函数 $f:D_f\subseteq X^{n_f}\to X$。固定总读数 $q:X\to Q$，其中 $Q$ 是集合，**不要求 $q$ 满射**。上下文族 $\operatorname{Ctx}_\Sigma$ 恰由以下生成元及有限复合生成：恒等孔 $\square$；对每个 $n_f\ge1$、每个槽位 $1\le i\le n_f$ 和任意固定参数 $a_j\in X\ (j\ne i)$，基本一孔部分函数

$$
x\longmapsto f(a_1,\ldots,a_{i-1},x,a_{i+1},\ldots,a_{n_f}).
$$

复合 $C\circ B$ 仅在 $B(x)$ 有定义且 $C(B(x))$ 有定义时求值；失败严格传播，不把失败当作 $X$ 的元素供后续操作处理。零元符号没有可放孔的槽位，也不增加一孔生成元。这里的固定参数是**全部 $X$ 中的参数**，不限于常数符号可命名的值；上下文不含额外探针、不截断复合深度，不自动增加复制孔或检查语法编码的机制。每个上下文本身仍是有限的。因为签名、参数空间及有限字符串空间都是集合，这个上下文族也是集合。

观察值域取不交并 $Q_\bot=(\{1\}\times Q)\sqcup\{\bot\}$；即使 $Q$ 自己包含一个名为“失败”的值，它也不等于新标签 $\bot$。定义

$$
\operatorname{obs}_C(x)=
\begin{cases}(1,q(C(x))),&C(x)\text{ 有定义},\\ \bot,&C(x)\text{ 无定义},\end{cases}
\qquad
x\approx_\Sigma y\ \Longleftrightarrow\quad
\forall C\in\operatorname{Ctx}_\Sigma,\quad
\operatorname{obs}_C(x)=\operatorname{obs}_C(y).
$$

**定义 17（强保域同余）。** $\theta$ 是 $X$ 上的等价关系；对任意 $f\in\Sigma$ 及逐坐标 $x_j\mathrel\theta y_j$ 的两元组 $\boldsymbol x,\boldsymbol y\in X^{n_f}$，要求

$$
\boldsymbol x\in D_f\iff\boldsymbol y\in D_f,
\qquad
\boldsymbol x,\boldsymbol y\in D_f\Longrightarrow
f(\boldsymbol x)\mathrel\theta f(\boldsymbol y).
\tag{SC}
$$

第一项保留整个定义域，不能删成“共同有定义时比较”。零元情形只有同一个空元组，条件自动成立。记 $\ker q=\{(x,y):q(x)=q(y)\}$；关系按集合包含排序，“最大”指包含所有符合条件的关系。

**命题 16（观察等价的最大性，repo-derived）。** $\approx_\Sigma$ 是 $\ker q$ 内最大的强保域同余。

**证明。** 它是各总函数 $\operatorname{obs}_C:X\to Q_\bot$ 的核的交，故是等价关系；恒等孔使它包含于 $\ker q$。先只替换一个槽位，写基本上下文为 $B$。若 $x\approx_\Sigma y$，则 $\operatorname{obs}_B(x)=\operatorname{obs}_B(y)$。严格失败与所有正常值分离，故 $B(x),B(y)$ 同时有定义或同时无定义。若二者有定义，对任意 $C\in\operatorname{Ctx}_\Sigma$，$C\circ B$ 仍属该族，于是
$\operatorname{obs}_C(B(x))=\operatorname{obs}_C(B(y))$，即 $B(x)\approx_\Sigma B(y)$。

对逐坐标等价的 $n_f$ 元输入，从 $\boldsymbol x$ 到 $\boldsymbol y$ 每次只替换一个坐标，其余坐标取这一步实际的固定参数。上段使定义性沿有限链相同；有定义时输出也沿链等价，传递性给出 (SC)。这一步正是需要所有槽位与全部固定参数的地方。

反之，设 $\theta\subseteq\ker q$ 满足 (SC)。对上下文的生成作归纳：恒等孔保持 $\theta$；基本上下文由 (SC) 保域，并在域内保持 $\theta$。复合时，若内层失败，两侧均严格失败；否则内层输出相关，外层由归纳假设同域且在域内输出相关。最后用 $\theta\subseteq\ker q$，两侧正常读数也相同。因此 $x\mathrel\theta y$ 蕴含每个上下文的观察相同，即 $\theta\subseteq\approx_\Sigma$。全过程没有使用满射或挑选 $Q$ 中未被命中的值。证毕。

**命题 17（扩签名只能细化）。** 在同一 $X,q$ 上，若 $\Sigma\subseteq\Sigma'$ 且旧符号的函数和定义域保持原样，则 $\approx_{\Sigma'}\subseteq\approx_\Sigma$。

**证明。** 原基本上下文及其有限复合全在扩充族内。对较大族全部观察相等，当然对原族相等。只需此集合包含，不涉及计算能力的比较。证毕。

**反例 A1（只比较共同有定义的上下文）。** 取 $X=\{a,b\}$，$Q=\{0,1\}$，$q$ 恒为 $0$，$f$ 仅在 $a$ 有定义且 $f(a)=a$。如果忽略单侧失败，$a,b$ 在每个共同有效上下文中的读数都为 $0$，错误关系把它们识别；但 $f$ 的定义域 $\{a\}$ 不饱和。正确观察在 $f(\square)$ 上是 $(1,0)$ 与 $\bot$。这也同时示范非满射读数完全合法。若再将失败与正常的 $0$ 混同，这个区别又会消失。

**反例 A2（任何固定有限深度都可能不足）。** 给任意 $k\ge0$，取两条互异状态链 $a_0,\ldots,a_{k+1}$ 和 $b_0,\ldots,b_{k+1}$，一个总一元操作 $f$ 各自向下一项移动、在终点停留。令 $q(a_{k+1})=1$，其余读数为 $0$。深度至多 $k$ 的上下文恰为 $\square,f,\ldots,f^k$，均不能区别 $a_0,b_0$；$f^{k+1}$ 却给 $1,0$。而 $f(a_0),f(b_0)$ 已可被深度 $k$ 区别，所以截断关系还可能不保运算。无限量化的是任意有限深度，并非允许一个无限复合上下文。

**反例 A3（遗漏槽位、参数或偷加探针）。** 取 $X=\{0,1,2\}$，$q(0)=q(1)=0,q(2)=1$，总二元操作 $f(s,t)$ 仅在 $(s,t)=(1,2)$ 时取 $2$，其余取 $0$。若只允许孔在第二槽，$0,1$ 的任何非空复合第一步都输出 $0$，永远不可区分；合法的第一槽上下文 $f(\square,2)$ 却给 $0,2$，观察为 $0,1$。即使开放两个槽位，若只许固定参数 $0,1$，仍有同样漏判：首次作用于 $0,1$ 的结果均为 $0$，不能形成区分。另取同一 $X,q$ 但空签名，此时 $0\approx_\varnothing1$。额外操作 $g(0)=0,g(1)=g(2)=2$ 可用 $q\circ g$ 区别它们，却不是原签名上下文；把 $g$ **正式加入**才得到命题 17 的严格细化。这不是原语言充分性被反驳。

**历史同构与依赖参数的勘界。** §4 的“编码相等 $\Rightarrow$ 历史同构 $\Rightarrow\ker q$”仍成立；它不自动插入任意 $\approx_\Sigma$。例如把总操作 $H_e(C,A)=(C,A\cap\{e\})$ 加入签名，$e\in HF$ 是一个固定出现标识。将一份两事件平衡表示中的所选正事件 $e$ 重命名为新标识 $e'$，保持全部属性，则两份表示历史同构，$q\circ H_e$ 却分别为 $1,0$。对一个具体签名若要证明历史同构蕴含观察等价，须证明该关系满足 (SC)、读数保持，并核对固定参数的作用；将参数一起运输所得的自然性，不等于固定同一参数的观察不变性。§16 的空间语言会满足所需条件。

定义 13 的因果查询还有类型依赖：$D$ 原本满足 $D\subseteq E_C$。在全载体上谈同一个查询时，可固定有限 $D\subset HF$ 并把 $F_{\downarrow D}$ 视为域 $\{(C,A):D\subseteq E_C\}$ 上的部分操作；或明确只比较两档案都包含 $D$ 的输入。重命名时需运输 $D$ 为 $h[D]$，不能悄悄把不同查询当作同一个。§17 的因果反例使用两侧共同有效的原事件集 $D$。

<a id="pr1-spatial"></a>

## 15. PR1 增补 B：可实现的精确空间读数及其代数

### 15.1 共同位置、全局像与固定情境容量

沿用 $d=3$，以下证明对任一固定有限 $d\ge1$ 成立。令

$$
R=\mathbb Z^{(\mathbb Z^d)}
=\{c:\mathbb Z^d\to\mathbb Z:\operatorname{supp}(c)\text{ 有限}\},
\quad \varepsilon(c)=\sum_p c(p),\quad I=\ker\varepsilon.
$$

括号上标表示有限支撑，绝非全部函数的无穷求和。记 $\delta_p(r)=1$ 当 $r=p$，其余为零。位置始终使用原稿同一坐标系。

**定义 18（双空间读数）。** 对 $X=(C,A)\in\mathcal B$ 定义

$$
\pi(X)=(w_X,z_X),\qquad
w_X(p)=\sum_{e\in\Omega_C,\ x(e)=p}\sigma(e),\qquad
z_X(p)=\sum_{e\in A,\ x(e)=p}\sigma(e).
\tag{SP}
$$

这是定义 12／命题 9 的共同位置特化：先取含全部当前位置的有限 bin 集合，令 $f=x|_{\Omega_C}$，再将 $w,z$ 向全格点补零。增添空 bin 不改变这个有限支撑函数，比较两对象时可取两个有限 bin 集的并。因此不是另造一种符号计数。总有 $w_X\in I,z_X\in R$，且 $q(X)=\varepsilon(z_X)$；旧档案 $E_C\setminus\Omega_C$ 不计入任一分量。

**命题 18（全局像及最小当前事件数，repo-derived）。**

$$
\pi[\mathcal B]=P:=I\times R.
\qquad
\min_{X:\pi(X)=(w,z)}|\Omega_X|
=\sum_p\bigl(|z(p)|+|w(p)-z(p)|\bigr).
\tag{IMAGE}
$$

**证明。** 包含于 $P$ 已由平衡及有限性说明。反向给定 $(w,z)\in P$，只需处理 $\operatorname{supp}(w)\cup\operatorname{supp}(z)$ 中有限个点。在每点 $p$ 放 $|z(p)|$ 个**选中**事件，符号为 $z(p)$ 的符号；再放 $|w(p)-z(p)|$ 个**未选**事件，符号为 $w(p)-z(p)$ 的符号。某项为零便放零个，无须定义零的事件符号。出现标识用 $(p,\mathrm{selected},i)$ 与 $(p,\mathrm{unselected},i)$ 的不同有限编码，故彼此不同；来源可全部取 leaf(0)，时间全部为零，偏序为空，取 $E=\Omega$。于是这是合法有限情境，逐点所选电荷恰为 $z$、全部当前电荷恰为 $z+(w-z)=w$，总背景为 $\varepsilon w=0$。这证明满像并达到所写事件数。

对任何实现，点 $p$ 的选中事件数至少为 $|z(p)|$，因为每个符号绝对值是 $1$；未选事件电荷为 $w(p)-z(p)$，其数量至少为该数绝对值。这两类互不相交，逐点求和即得下界。构造达到下界，故最小值存在且等于该式。若同时最小化整个档案数，下界仍由 $|E|\ge|\Omega|$ 给出，并由上述 $E=\Omega$ 的构造达到。证毕。

**命题 19（固定 $C$ 的选择像）。** 固定合法平衡情境 $C$，记当前位置 $p$ 的正、负事件数为 $n_+(p),n_-(p)$，则 $w(p)=n_+(p)-n_-(p)$ 固定，而可选分布恰为

$$
\{z\in R:\ \forall p,\quad -n_-(p)\le z(p)\le n_+(p)\}.
\tag{CAP}
$$

区间指逐点**整数**区间，非实区间。**证明。** 任何选择给出 $z(p)=a_+(p)-a_-(p)$，其中 $0\le a_\pm(p)\le n_\pm(p)$，故有界。反向每个非负 $z(p)$ 选恰好 $z(p)$ 个正事件、不选负事件；每个负 $z(p)$ 选恰好 $-z(p)$ 个负事件、不选正事件。区间保证数量够，各位置的选择互不干扰；当前位置以外两容量均为零，必有 $z(p)=0$，故得到一个有限合法选择。证毕。

(IMAGE) 允许随 $(w,z)$ **更换情境**，(CAP) 则固定完整 $C$。例如原代表 $\mathbf i(1)$ 与 $\mathbf i(2)$ 都有 $w=0$，在零点的选择容量分别是 $[-1,1]$ 与 $[-2,2]$。两者若取空选择甚至同为 $\pi=(0,0)$；从第一个固定情境却选不出 $2\delta_0$。不能把全局像 $I\times R$ 当作每一个 $C$ 的选择像。

### 15.2 闭包、空间筛选与位置限制的配对

在 $R$ 上定义逐点加法及有限卷积

$$
(c*d)(r)=\sum_{p+q=r}c(p)d(q).
\tag{CONV}
$$

求和只含两个有限支撑的 Cartesian 积；支撑包含于 $\operatorname{supp}(c)+\operatorname{supp}(d)$，故仍有限。

**命题 20（精确更新式）。** 原稿的并行加法、档案乘法、补集和任意固定空间筛选均在 $\mathcal B$ 上总定义，且

$$
\begin{aligned}
\pi(X\boxplus Y)&=(w_X+w_Y,z_X+z_Y),\\
\pi(X\boxtimes Y)&=(w_X*w_Y,z_X*z_Y),\\
\pi(NX)&=(w_X,w_X-z_X),\\
\pi(F_SX)&=(w_X,\mathbf1_S z_X).
\end{aligned}
\tag{UP}
$$

此外 $\varepsilon(c+d)=\varepsilon c+\varepsilon d$，$\varepsilon(c*d)=(\varepsilon c)(\varepsilon d)$，所以 $I$ 对加法、负号封闭，且 $I*R\subseteq I$。

**证明。** 并行时同一位置的两份带标签电荷相加。乘法只数新当前事件 $p_{ab}$：其位置为 $x(a)+x(b)$，符号为 $\sigma(a)\sigma(b)$；对父位置 $p,q$ 分组，每组有限双和为 $w_X(p)w_Y(q)$，所选组同理为 $z_X(p)z_Y(q)$，再按 $p+q=r$ 合组即得卷积。旧档案仍保留，但不在当前区域，故没有额外线性项。补集逐点是未选电荷，即 $w-z$；筛选只从 $A$ 中删点，背景 $\Omega$ 不动，故必须保留完整 $w$，**不能同时筛掉 $w$**。对有限和换序得到

$$
\sum_r\sum_{p+q=r}c(p)d(q)
=\sum_p\sum_q c(p)d(q)
=\Bigl(\sum_pc(p)\Bigr)\Bigl(\sum_qd(q)\Bigr).
$$

加法和负号下的增广公式逐项成立。由此各式背景都仍属 $I$，也给出 §2/3 的标量读数公式。证毕。

**位置限制扩展的精确范围。** 固定一个谓词 $K\subseteq\mathbb Z^d\times\mathbb Z^d$；定义 14 中对每对输入取 $R_{X,Y}=\{(a,b):K(x_X(a),x_Y(b))\}$，记所得总操作为 $M_K$。仍使用完整乘积情境，因此

$$
w_{M_K(X,Y)}=w_X*w_Y,\qquad
z_{M_K(X,Y)}(r)=\sum_{p+q=r}\mathbf1_K(p,q)z_X(p)z_Y(q).
\tag{K}
$$

**证明。** 每个位置对 $(p,q)$ 中的事件对或者全部保留或者全部排除，故该组电荷为 $\mathbf1_K(p,q)z_X(p)z_Y(q)$；背景没有被限制，仍按 (UP)。有限分组即得式。证毕。这只依赖位置的前提不能换成任意来源、因果或出现身份关系；同位置组中的那些关系不必恒定。

(K) 不恢复已被命题 12 否定的标量乘法：取非零 $v$，输入 $\mathbf i(1)$ 及其空间平移 $v$，二者读数均为 $1$；若 $K(p,q)$ 为 $p=q$，所选对被排除，结果读数为 $0$，而完整乘积为 $1$。第二个输入若不平移，受限读数又为 $1$。任意 $K$ 也不自动继承卷积的交换、结合律；本批只证明所写更新式及 §16 的语言充分性。

### 15.3 带补集运算的交换无单位环

**定义 19。** 在 $P=I\times R$ 上以 (UP) 定义逐分量加法和卷积乘法，零元为 $(0,0)$；另记

$$
J(w,z)=(-w,-z),\qquad N(w,z)=(w,w-z).
$$

$J$ 由 §2 已列的**全档案符号翻转**实现：对每个 $e\in E$ 将 $\sigma(e)$ 换成 $-\sigma(e)$，其余数据及选择不动。时间约束、偏序和有限性仍合法，平衡仍为零；两个空间分量各自取负。这与保持情境、仅改选择的 $N$ 是不同操作。

**命题 21（$P$ 的完整本批类型）。** $P$ 是交换无单位环（rng），$J$ 是其加法逆；$N$ 是额外的加法群自同构及对合，通常不是加法逆、也不是乘法同态。对任一点 $(w,z)\in P$，

$$
N(w,z)=J(w,z)\iff w=0.
\tag{NJ}
$$

**证明（群与卷积定律）。** 逐点整数加法给出 $R$ 的阿贝尔群；$\varepsilon$ 保加，故 $I$ 是子群，$P$ 的逐分量加法也是阿贝尔群，逆为 $J$。卷积有限支撑保证其类型闭合，命题 20 保证 $I$ 分量闭合。对任意 $c,d,e\in R$ 和位置 $r$，

$$
((c*d)*e)(r)=\sum_{p+q+s=r}c(p)d(q)e(s)
=(c*(d*e))(r).
$$

这是同一个有限三重和按不同顺序分组；整数乘法结合且格点加法结合。交换变量 $p,q$ 并用整数乘法交换得 $c*d=d*c$。逐项用整数分配律得 $c*(d+e)=c*d+c*e$，另一边同理。因此这些定律逐分量传到 $P$，零乘积也逐点为零；这是 rng 所需的全部环定律，尚未假设单位存在。

**证明（没有乘法单位，独立于单位分类）。** 反设 $(a,b)\in P$ 对全部 $P$ 元素为单位。乘 $(0,\delta_0)$ 得 $(0,b)=(0,\delta_0)$，故 $b=\delta_0$。因 $d\ge1$，可取非零格点 $v$；$\delta_v-\delta_0\in I$。对 $(\delta_v-\delta_0,0)$ 的单位条件给出

$$
(a-\delta_0)*(\delta_v-\delta_0)=0.
$$

令 $c=a-\delta_0$，逐点评价为 $c(r-v)=c(r)$。若某点 $c(r_0)\ne0$，沿 $r_0+nv\ (n\in\mathbb Z)$ 值恒相同；非零整数向量无加法挠元，这些点两两不同，与有限支撑矛盾。因此 $c=0$，迫使 $a=\delta_0$；但 $\varepsilon(a)=0$ 而 $\varepsilon(\delta_0)=1$，矛盾。这个证明没有借用 $R$ 的整性或完整单位分类。$d\ge1$ 在此必要：$d=0$ 时格点群只有零点，$I=0$，$P\cong\mathbb Z$ 反而有单位。

**证明（$N$ 的角色）。** 直接展开得到 $N(x+y)=N(x)+N(y)$ 及 $N^2=\mathrm{id}$，故是加法群自同构。若 $N(w,z)=J(w,z)$，第一分量要求 $w=-w$，逐点整数无二挠元，故 $w=0$；反向 $w=0$ 时两式均为 $(0,-z)$。例如 $\alpha=\delta_0-\delta_v\ne0$，$N(\alpha,0)=(\alpha,\alpha)$ 而 $J(\alpha,0)=(-\alpha,0)$，所以不是一般负号。令 $e_0=(0,\delta_0)$，则

$$
N(e_0e_0)=(0,-\delta_0),\qquad
N(e_0)N(e_0)=(0,\delta_0),
$$

两者不同，故 $N$ 不是乘法同态。证毕。

**零因子与局部单位。** $a_0=(\alpha,0)$ 和 $e_0=(0,\delta_0)$ 都非零，$a_0e_0=(0,0)$，给出 $P$ 的零因子。子 rng $P_0=\{0\}\times R$ 有自己的单位 $e_0$，因为 $\delta_0*c=c$；它不是 $P$ 的单位，刚才的 $a_0e_0=0\ne a_0$ 已反驳。$P_0$ 上 $N=J$；一般 $z$ 空间层 $R$ 的抽象负号为 $z\mapsto-z$，可由全档案符号翻转诱导，不能与一般背景下的 $N$ 混同。以上类型论断只属于空间商；§4 的 $28/32$ 档案反例继续有效。

<a id="pr1-languages"></a>

## 16. PR1 增补 C：三种明确语言与最粗充分性

本节统一取 $X=\mathcal B$、终端观察 $q:\mathcal B\to\mathbb Z$，上下文严格按定义 16 取全槽位、全部固定丰富参数及任意有限复合。固定空间区域作为操作的名字，不因当前输入改规则。定义

$$
\begin{aligned}
\Sigma_{\rm arith}&=\{\boxplus,\boxtimes,N\},\\
\Sigma_z&=\{\boxplus,\boxtimes\}\cup\{F_S:S\subseteq\mathbb Z^d\},\\
\Sigma_{\rm sp}&=\Sigma_z\cup\{N\}.
\end{aligned}
$$

在 $\Sigma_z,\Sigma_{\rm sp}$ 中也可以只保留全部单点筛选 $F_p:=F_{\{p\}}$，以下同一结论仍成立。$\Sigma_{\rm arith}$ 与 $\Sigma_z$ 作为符号集合**互不包含**，不能从命题 17 直接比较这两个签名；各自都是 $\Sigma_{\rm sp}$ 的子签名。

**命题 22（语言决定观察核，repo-derived）。**

$$
\approx_{\Sigma_{\rm arith}}=\ker q,\qquad
\approx_{\Sigma_z}=\ker z,\qquad
\approx_{\Sigma_{\rm sp}}=\ker\pi.
\tag{LANG}
$$

**证明（充分性须对上下文归纳）。** 算术语言在 $q$ 上的更新分别为整数加、乘、负；空间语言在 $z$ 上的更新分别为加、卷积、$\mathbf1_Sz$；加入 $N$ 后在 $\pi$ 上的全部更新为 (UP)。三种情况下终端 $q$ 都由相应读数决定（空间两种为 $\varepsilon z$）。所有这些丰富操作均为总函数，故不会藏有未保存的部分域。

取一对相应读数相等的输入。恒等孔仍等；基本上下文的固定参数在两侧是同一对象，故上述更新式给出相等的输出读数；有限复合时对子上下文应用归纳假设，再用外层更新式。由此每个合法上下文的终端 $q$ 相同，得到相应核包含于观察等价。该归纳也可直接视为命题 16 的同余充分方向，不能用测试了有限几个上下文替代。

**证明（必要性）。** 算术语言有恒等孔，故观察等价必须在 $\ker q$ 内。空间语言含每个单点筛选，而

$$
q(F_pX)=z_X(p),\qquad
q(F_pNX)=w_X(p)-z_X(p).
\tag{REC}
$$

第一式使 $\Sigma_z$ 观察等价必有全部 $z$ 坐标相同。空间加补集语言中第二式也可观察；结合第一式，逐点相加恢复 $w_X(p)$。所以 $\Sigma_{\rm sp}$ 观察等价必有全部 $w,z$ 相同，即属于 $\ker\pi$。这与充分性合并证明 (LANG)，且只用了单点筛选。证毕。

这些核的严格关系可用具体对象验证。令 $v\ne0$，$U=\mathbf i(1)$，$U_v$ 为其空间平移 $v$；二者读数均为 $1$，但 $z_U=\delta_0,z_{U_v}=\delta_v$，单点筛选在零点给 $1,0$。另令 $B_\alpha$ 为命题 18 对 $(\alpha,0)$ 的实现，$\alpha=\delta_0-\delta_v$，即两个未选事件 $+@0,-@v$；空档案与它都有 $z=0$，而 $q(F_0N0_\varnothing)=0$、$q(F_0NB_\alpha)=1$。故
$\ker\pi\subsetneq\ker z\subsetneq\ker q$；这个关系由证明与见证给出，不来自前两个签名的包含。具体这些语言还满足历史同构 $\Rightarrow\ker\pi$（逐位置重索引即可），因此可以在此特定情形插入观察关系；不能把该结论外推到出现身份探针语言。

**命题 23（任意充分读数恢复 $\pi$）。** 设 $h:\mathcal B\to H$ 是任意总读数，且对 $\Sigma_{\rm sp}$ **充分**，即 $h(X)=h(Y)$ 蕴含所有该签名上下文的严格终端观察相同。则存在唯一函数

$$
\kappa:h[\mathcal B]\longrightarrow P,
\qquad \kappa(h(X))=\pi(X).
\tag{FACTOR}
$$

**证明。** 命题 22 的必要性给出 $\ker h\subseteq\ker\pi$。因此对每个实际出现的 $u\in h[\mathcal B]$，关系“存在 $X$ 使 $h(X)=u$ 且 $\pi(X)=p$”定义唯一的 $p$；存在性来自像的定义，唯一性来自核包含。该关系的图就是 $\kappa$，不必为每条纤维选代表。任意满足等式的函数在每个像点都被强制定值，故唯一。无需假设 $h$ 对整个 $H$ 满射，也不要求在未命中点定义恢复函数。命题 22 的充分方向则表明 $\pi$ 本身可用，故它在核包含意义下是最粗充分读数。证毕。

若先给 $h$ 上的每个操作更新式与保域条件，并给终端 $q$ 的恢复式，上下文归纳会推出命题 23 所用的充分性。这是信息可辨识性的精确结论，**不是字节数最优**、不是对任意观察的可计算性承诺，也不恢复档案历史。任意集合 $S,K$ 的数学定义不意味着其成员测试有算法。

可将任意预先固定的纯位置操作 $M_K$ 加入 $\Sigma_z$ 或 $\Sigma_{\rm sp}$：由 (K) 相应读数仍可更新，且原来的单点探针仍在，故 (LANG) 的这两项及 (FACTOR) 不变。**不能同样宣称 $\Sigma_{\rm arith}$ 加入任意 $M_K$ 后仍为 $\ker q$**；§15.2 的 $p=q$ 例子已给同输入数值、不同受限输出数值。完整卷积与位置受限配对须分清。

<a id="pr1-boundaries"></a>

## 17. PR1 的分离反例、来源边界与核验收据

### 17.1 同空间读数仍不能回答的查询

**反例 B1（同 $\pi$、异来源）。** 两份档案都取 $E=\Omega=\{a,b\}$，符号分别为 $+,-$，时间和位置为零，偏序为空，选择 $\{a\}$。第一份全部来源为 leaf(7)，第二份全部为 leaf(8)。两者 $\pi=(0,\delta_0)$，但来源筛选 $L=\{\operatorname{leaf}(7)\}$ 后 $q$ 分别为 $1,0$。因而来源查询不被 $\Sigma_{\rm sp}$ 覆盖。若定义 14 的关系改为“两父来源相等”，固定另一个所选正事件来源为 leaf(7) 的因子，两份输入的受限输出也分别为 $1,0$，虽空间输入对相同；这说明 (K) 的位置假设有实质内容。

**反例 B2（同 $\pi$、异因果，且 $D$ 共同有效）。** 取两份相同的 $E=\Omega=\{a,b,c,d\}$、零位置、来源 leaf(0)，符号按序为 $+,+,-,-$，时间为 $0,1,0,1$，选择 $\{a,b\}$。第一份唯一严格边为 $a\prec b$，第二份偏序为空，二者都合法，且 $\pi=(0,2\delta_0)$。固定原事件集 $D=\{b\}$，两档案确实都包含它。因果过去筛选在第一份选到 $a,b$、第二份仅选到 $b$，读数为 $2,1$。不以重命名后的无效 $D$ 伪造这个反例。若用“左父在左档案的 $\downarrow D$ 中”限制配对，与一个所选正贡献相乘，同样给 $2,1$；任意因果关系不由位置公式覆盖。

**反例 B3（同 $\pi$、异时间复合域）。** 取 $U=\mathbf i(1)$，再构造 $U^{\rm old}$：保留 $U$ 的当前区域、选择及全部当前属性，只向 $E\setminus\Omega$ 加一个新出现标识、时间为 $2$、位置为零、符号为正、来源 leaf(9) 的旧事件，仍取空偏序。二者皆平衡，$\pi=(0,\delta_0)$。固定 $Y=T_1(U)$，则 $U\triangleright Y$ 合法且读数为 $2$，$U^{\rm old}\triangleright Y$ 因 $2<1$ 为假而无定义。即使保留当前事件的全部时间也漏掉这个域差。PR1 的时间操作继续回到完整档案检查 (T)，不声称 $\pi$ 保存时间守卫；时间摘要属于下一独立批次。

**反例 B4（同 $w$、异固定情境容量）。** §15.1 的 $\mathbf i(1),\mathbf i(2)$ 是已给的见证：在零点分别只有一对与两对正负候选，$w=0$ 相同，空选择还给相同 $\pi$，但允许重选的区间为 $[-1,1]$ 与 $[-2,2]$。这个性质涉及固定 $C$ 中的可能选择族，不是当前选择的单次读数，命题 23 不承诺恢复它。

出现身份关系也越过 (K)：对历史同构但把所选事件 $a$ 换成 $a'$ 的 B1 型表示，固定关系“左父出现标识为 $a$”只在前者保留所选对，输出为 $1,0$。最后，§4 两种括号的档案数 $28,32$ 仍不同；它们的双空间读数却均为 $(0,2\delta_0)$，卷积结合律只识别这个商，不能向上推回历史同构。

### 17.2 成熟来源与本轮产地

本轮采用以下已实际核读的来源收据（调用方在派工中提供），无需把元数据检索冒称逐页证明核读。其适用边界分别为：

| 来源与可定位落点 | 已有内容与本稿使用边界 |
| --- | --- |
| Stanley Burris、H. P. Sankappanavar, *A Course in Universal Algebra*, 作者公开 2012 版，[II §5 定义 5.1 与 II §10](https://www.math.uwaterloo.ca/~snburris/htdocs/UALG/univ-algebra2012.pdf) | `literature-attested`：总代数同余及项运算保持同余。本文 (SC) 额外保留部分域，其最大性是命题 16 的自给证明，未声称原书给出同一部分操作定理。 |
| Andrew M. Pitts, “Operational Semantics and Program Equivalence”, *Applied Semantics*, LNCS 2395 (2002)，[§3 定义 3.1／备注 3.2](https://www.cl.cam.ac.uk/~amp12/papers/opespe/opespe-lncs.pdf) | `literature-attested`：用上下文及终止观察刻画程序等价的成熟方法。这里采用确定部分函数与带标签失败观察，未把程序语言语义或其定理无条件搬到本载体。 |
| Mathlib 在线文档 [Algebra.MonoidAlgebra.Defs 的 mul_def](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/MonoidAlgebra/Defs.html) | `literature-attested`：有限支撑系数的卷积乘法。这里只作成熟结构来源；在线文档不是本仓 pin 的核对，也不是本稿的 Lean 验证。 |

强保域最大性、双读数可实现像及最小事件数、固定情境容量、特定语言充分性和本稿 rng 的结论归为 `repo-derived`，证明已在 §14–16 给全。不主张首创；有限和、同余和群代数结构均有成熟背景。辅助 `/tmp/csa-upgrade-20260909/literature-intake.json` 仅消费其 `conclusion`：Milne 的群代数例子是域系数，Gallier 是实仿射空间，二者不作为本批整数系数结论或单位分类的证明。任何 `log_ref` 内容均未消费。

本轮实施是在 `consensus-rnd:sshx` 下由唯一 Codex 实施席完成，输入暴露为 `repo-prior-exposed`（完整派工 GoalArtifact、批准计划、CLAUDE.md、agents/CONTEXT.md、基线文稿及上述来源收据），不称先验独立。按本轮调用方派工记录，两次 NyxID 思考调用均失败，teleology 由 Codex 回退完成；company 默认池的连通性 probe 只返回模型标识 GPT-6 Astra，没有数学内容，**不计 S1 的实质 PRO 意见**。§12 的旧 task 属原稿历史，不算本轮成功调用。当前数学工件的真实网页数学评审、architecture/quality/tests 三席、仓库 required checks 及 PR 生命周期均由 caller 接续，尚不宣称通过或合入。PR2 的时间摘要、完整单位分类、律表和参考点族不属于本批完成主张。

### 17.3 PR1 定向精确核验的范围与预期

附录唯一 Python 块复用原有 `Rich/add/mul/neg`，新增函数仅服务本页的核验。预期值来自正文命题、展开式及反例，未用被检查输出反过来生成预期。一般命题的证明是 §14–16 的证明；脚本对如下明确有限窗口检查实现与这些结论是否一致。

背景恢复在原 105 个表示上逐个探测第一坐标 $0,1,2,3$，共预期 $420$ 次；另用 $(\alpha,0)$ 与空档案检出漏存背景的错误，并检查筛选之后背景仍在。像构造取 $p\in\{0,v,h\}$，$v=(1,0,0),h=(0,1,-1)$，$w$ 的系数为 $(a,b,-a-b)$、$a,b\in\{-1,0,1\}$，$z$ 三个系数各取 $\{-1,0,1\}$，预期 $9\cdot27=243$ 个实现都达到 (IMAGE) 的事件数。固定容量枚举两个位置各自的 $n_+,n_-\in\{0,1,2\}$ 且全局平衡，预期 $19$ 个固定情境、$673$ 个选择；其读数像与 (CAP) 的逐点整数区间逐一比较。

小量稀疏卷积另用显式例子

$$
\pi(X)=(\delta_0-\delta_v,2\delta_0-\delta_v),\qquad
\pi(Y)=(\delta_h-\delta_0,\delta_v+\delta_h).
$$

普通展开给出背景 $\delta_h-\delta_0-\delta_{v+h}+\delta_v$、选择 $2\delta_v+2\delta_h-\delta_{2v}-\delta_{v+h}$，读数为 $2$；$K(p,q)\equiv(p=q)$ 只留下选择 $-\delta_{2v}$，读数为 $-1$，背景不变。这两个最小实现各有四事件，完整乘积档案数 $4+4+4\cdot4=24$。另取 $w=c\alpha\ (c\in\{-1,0,1\})$ 与 $z\in\{-\delta_h,0,\delta_v+\delta_h\}$ 的 $9$ 个状态，检查 $81$ 个丰富输入对的更新式和 $729$ 个空间读数三元组的卷积结合、分配式；仍单独保留 $28/32$ 的丰富层非结合见证。

错误上下文族定向执行反例 A1、A2 的 $k=0,\ldots,4$、A3 的缺槽位与缺参数族（深度 $0$ 至 $3$ 分别 $40,85$ 个词），并区别额外非签名探针。来源、因果、时间域和出现身份使用 B1–B3 及共同有效 $D$ 的具名样本，预期读数分别为 $1/0$、$2/1$、有定义/无定义、$1/0$；另检查重命名后原 $D$ 的依赖域确实可能失效。

零因子、$N\ne J$、$N$ 非乘法同态和 $P_0$ 的自身单位各执行正文见证。有限无单位探针仅枚举 $a$ 支撑在 $\{0,v,h\}$、系数在 $[-2,2]$ 且总和零的 $19$ 种背景，与同支撑、系数在 $\{-1,0,1\}$ 的 $27$ 种 $b$，共 $513$ 个候选；对 $b\ne\delta_0$ 用 $e_0$，对 $b=\delta_0$ 用 $(\alpha,0)$ 检出不满足单位律。这个有限排除**不证明所有格点、所有系数上不存在单位**，后者只由命题 21 的有限支撑周期性证明承担；同样，有限上下文测试不证明全部上下文的最大性或充分性。

**本轮实际运行收据（2026-09-09）。** 在指定工作树、基线 `4ee990c9cb7eb3c8692f0c3f6e5be53cf28f9c85` 上，按附录原 `sed ... | sed ... | python3 -` 命令执行扩充后的唯一代码块，进程实际退出码为 `0`。原 $105/11025$ 检查也在这次执行中运行；本次增加的实际标准输出为：

```text
pr1_recovery: singleton_checks=420 background_after_filter=preserved kernels_strict=True
pr1_image_capacity: image_cases=243 fixed_contexts=19 choices=673 capacities=[-1,1],[-2,2]
pr1_convolution: sparse_states=9 rich_pairs=81 pair_triples=729 explicit_full_q=2 restricted_q=-1 archives=28,32
pr1_contexts: common_domain_miss=1 depth_counterexamples=5 restricted_word_checks=125 slot_parameter_and_extra_probe=distinguished
pr1_boundaries: same_pair_source=1,0 causal=2,1 time_domain=defined,undefined identity=1,0 dependent_D=defined,undefined
pr1_rng: zero_divisors=confirmed N_not_J=confirmed N_not_multiplicative=confirmed P0_unit_only=True finite_unit_candidates_rejected=513
ALL_FINITE_CHECKS_PASSED
```

输出中的 `confirmed/True` 仅报告上述有限例子的断言；一般结论由正文证明。原附录末句“新文档之外未改动任何仓库文件”只描述基线工作；本轮交付范围为本源正文及本源 canonical ingest 新产物，不新增 Lean 或生产算术模块。

<a id="pr2-laws"></a>

## 18. PR2 增补 D：分层律与强部分结合

本批沿用 $d=3$、定义 1–19，新增结论均为普通数学证明。等式必须说明所在层，不能省略取商步骤：

| 层 | 所识别的数据 | 可引用的律及边界 |
| --- | --- | --- |
| 严格标签相等 $=$ | 全部编码，包括每次并集的嵌套标签 | $N^2X=X$；带标签并集不作无条件结合、交换或单位等式 |
| 历史同构 $\cong_h$ | 可重命名出现标识，仍保存全部属性、偏序、当前区域和当前选择 | 并行加法为交换幺半群；档案乘法不结合、不交换、不分配、无单位 |
| $\pi$ 空间商 $P=I\times R$ | 双空间电荷，遗忘时间及历史 | §15 的交换 rng；加法逆是 $J$，$N$ 一般不是负号；$P_0$ 才有自己的单位 |
| $\Theta$ 时间摘要 | $\pi$ 及 §20 的三个端点 | §20 的闭合部分代数；并行加法为交换幺半群，乘法交换、分配但不结合、无单位 |
| 标量商 $\mathcal B/\ker q$ | 所选总电荷 | §4 的整数环；仅凭标量不能保留时间复合域 |

对本批指定语言，关系有 $=\ \subseteq\ \cong_h\ \subseteq\ker\Theta\subseteq\ker\pi\subseteq\ker q$：历史同构按位置及时间重索引，保持双电荷和三个端点；后两包含由忘掉端点及 $q=\varepsilon z$ 给出。反向均失败，分别见出现重命名、B1 的同时间异来源、B3 的旧档案时刻、§16 的同数异位置见证。此链不外推到带固定出现身份探针的任意签名。

**命题 24（历史层的律与反例）。** 历史同构是 $\boxplus,\boxtimes,N$ 的同余，也是 $\triangleright$ 的强保域同余。模历史同构的并行加法以空档案为单位，满足交换、结合；$N$ 是对合，但非空档案没有相对于空档案的加法逆。表中历史乘法的四项失败均成立。

**证明。** 给输入的历史同构 $h_X,h_Y$，在两份旧档案上使用 $(i,e)\mapsto(i,h_i(e))$，在乘法新点上使用 $p_{ab}\mapsto p_{h_X(a)h_Y(b)}$。这是双射，保持全部属性（来源仍为同序的 pair）、生成边及其传递闭包，也运输当前区域和选择。补集由双射运输。时间 guard 逐事件只检查被保持的时刻，故在两侧同真同假；有定义时同一双射还运输全部跨边。这证明同余及保域性。

并行加法的交换同构交换左右标签；结合同构按实际嵌套位置展平为三个分量，再按另一括号加标签。更明确地，左括号的 $(0,(0,e)),(0,(1,f)),(1,g)$ 分别对应右括号的 $(0,e),(1,(0,f)),(1,(1,g))$。两侧都只含原有内部边，所有属性与区域、选择对应，故为历史同构。空档案相加时去掉唯一非空分量的标签即得单位同构。对任一非空 $E_X$，$|E_{X\boxplus Y}|=|E_X|+|E_Y|>0$，所以任何 $Y$ 都不能把和变成空档案；特别 $N(X)$ 不是这种逆。$N^2X=X$ 已由命题 1 在严格层证明。标签展平是同构而非标签等式，例如非空 $X$ 与 $X\boxplus0_\varnothing$ 的有限事件标识整体被加了一层标签，不应写成严格单位等式。

非结合仍用 §4 的原见证 $X=Y=\mathbf i(1),Z=\mathbf i(2)$，两括号档案数为 $28,32$，旧反例完整保留。非分配取 $U=\mathbf i(1)$：

$$
|E_{U\boxtimes(U\boxplus U)}|=2+4+2\cdot4=14,
\qquad
|E_{(U\boxtimes U)\boxplus(U\boxtimes U)}|=8+8=16.
\tag{HD}
$$

二者 $q=2$，但基数阻止任何历史同构；另一侧分配也由 $(U\boxplus U)\boxtimes U$ 的同一计数失败。非交换取两个两事件的 $U$ 型表示，时间全为 $0$、位置全为零、各选正事件，第一份来源全为 leaf(7)，第二份全为 leaf(8)。$X\boxtimes Y$ 的四个新点全在时刻 $1$，来源全为 pair(leaf(7),leaf(8))；$Y\boxtimes X$ 的四个新点同在时刻 $1$，来源全为 pair(leaf(8),leaf(7))。有序 pair 的这些值不同，时刻 $1$ 的点也不能对应任何时刻 $0$ 的旧点，故不存在保属性的双射。

最后假定某 $V$ 是历史乘法单位。由 $0_\varnothing\boxtimes V\cong_h0_\varnothing$，档案基数公式迫使 $E_V=\varnothing$。但此时 $U\boxtimes V$ 的当前区域为空，不能同构于当前区域有两点的 $U$，矛盾。此证明排除任意 $V$，不只排除所选数值一代表。证毕。

**命题 25（时间复合的强部分结合）。** 写 $G(X,Y)$ 为定义 5 的全档案 guard。两表达式 $(X\triangleright Y)\triangleright Z$ 与 $X\triangleright(Y\triangleright Z)$ 都恰在

$$
G(X,Y)\ \land\ G(X,Z)\ \land\ G(Y,Z)
\tag{TA}
$$

上有定义；在该域上有命题 24 所述的重括号历史同构。

**证明。** 左括号先要求 $G(X,Y)$，再要求 $E_X\sqcup E_Y$ 中每点早于 $E_Z$ 每点；后一要求恰分成 $G(X,Z)\land G(Y,Z)$。右括号先要求 $G(Y,Z)$，再将其档案并集拆开得到 $G(X,Y)\land G(X,Z)$。这种全称量词对并集的分解在任一集合为空时仍成立，故两定义域完全相同。两侧最终都保留三个内部偏序并加入全部 $X\to Y,X\to Z,Y\to Z$ 跨边，标签展平逐边对应，也逐项对应全部属性、区域和选择，所以是历史同构，不是无条件严格标签结合式。证毕。

若 $E_Y\ne\varnothing$，相邻 guard 可经任一 $y\in E_Y$ 和整数序传递性推出 $G(X,Z)$；这个非空前提不能省。取 $X=T_2(U),Y=0_\varnothing,Z=T_1(U)$，$G(X,Y)$ 与 $G(Y,Z)$ 都空真，$G(X,Z)$ 却为假，两括号都失败。合法对照 $U,T_1(U),T_2(U)$ 满足全部三 guard，两括号都有六事件与十二条跨可比关系。空中间的合法对照 $U,0_\varnothing,T_1(U)$ 也满足 (TA)。

<a id="pr2-units"></a>

## 19. PR2 增补 E：有限空间卷积的整性、单位与方程

以下 $R=\mathbb Z^{(\mathbb Z^3)}$ 及 $*$ 完全沿用 §15；所有支撑有限。给 $\mathbb Z^3$ 选定字典全序 $\le_{\rm lex}$：按第一个不同坐标的整数序比较。共同加向量后首个不同坐标及该处差值不变，故它与加法相容，即 $p<q\Rightarrow p+r<q+r$。该序不须良序；这里只用非空有限支撑存在最大、最小元。

**命题 26（卷积极值与无零因子）。** 对非零 $a,b\in R$，记支撑极值为 $a_-,a_+,b_-,b_+$，则

$$
\min\operatorname{supp}(a*b)=a_-+b_-,\qquad
\max\operatorname{supp}(a*b)=a_++b_+.
\tag{EXT}
$$

两极值点分别只有这一种来自两支撑的拆分，系数分别为 $a(a_-)b(b_-)$ 与 $a(a_+)b(b_+)$，均非零。因此 $R$ 无零因子。

**证明。** 对支撑点 $p,q$ 有 $p\le a_+,q\le b_+$，所以 $p+q\le a_++b_+$。若 $p<a_+$，则 $p+q<a_++q\le a_++b_+$；若 $q<b_+$ 同理。因此等号迫使 $p=a_+,q=b_+$，反向这一对确实出现。该卷积系数只有一个非零乘积项，两个非零整数的乘积非零，不能被其他项抵消；它是支撑最大元。将不等号反向得到最小元及唯一拆分。乘积至少含极值点，故不为零。证毕。

**命题 27（全部自身单位）。** $R$ 的单位恰为 $\pm\delta_p\ (p\in\mathbb Z^3)$，相应逆为同号的 $\pm\delta_{-p}$。$P_0=\{0\}\times R$ 相对于其自身单位 $(0,\delta_0)$ 的单位恰为 $(0,\pm\delta_p)$。

**证明。** $\delta_0*a=a$ 由逐点有限和直接成立。若 $a*b=\delta_0$，两因子都非零，由 (EXT) 有 $a_++b_+=a_-+b_-=0$。定义在这个有序群中的宽度 $W(a)=a_+-a_-\ge0$，同理 $W(b)\ge0$；两式相减得 $W(a)+W(b)=0$。两个非负元之和为零迫使各自为零：若其一严格正，加另一非负元仍严格正。于是两个支撑分别只有一个点，写为 $a=A\delta_p,b=B\delta_q$。乘积等于 $\delta_0$ 迫使 $p+q=0,AB=1$；整数中只能 $A=B=1$ 或 $A=B=-1$。反向这些点质量确实乘为 $\delta_0$。$R\to P_0,c\mapsto(0,c)$ 保持全部运算和自身单位，故直接运输分类。证毕。

这里的宽度是字典有序群中的向量差，未引入欧氏长度。命题 26 不会使 $P$ 无零因子：§15.3 的 $(\alpha,0)(0,\delta_0)=0$ 仍是正确反例。$P$ 自身无单位，本节不在 $P$ 中偷用“乘法逆”。

**反例 C1（数值可逆不推出有限空间可逆）。** 任取 $v\ne0$，令 $f=2\delta_0-\delta_v$，则 $\varepsilon(f)=1$，但它有两个支撑点，不属命题 27 的单位族，所以没有有限支撑卷积逆。由命题 18 可实现 $\pi(X)=(0,f)$，其 $q(X)=1$ 在整数标量商已经可逆，在 $P_0$ 的空间商却不可逆。此处未改变 §6 的整数非零与整除守卫、有理非零分母守卫或 §7 的实数非零类守卫。

**命题 28（空间方程的准确条件）。** 在有单位环 $R$ 中，给定 $f,h$，方程 $f*g=h$ 有解当且仅当 $h\in fR$；这是主理想成员条件。若 $f\ne0$，有解时唯一。

**证明。** $fR=\{f*r:r\in R\}$ 含零、对差封闭，且 $(f*r)*s=f*(r*s)$，故为理想。其成员定义正是存在一个有限支撑解，未声称存在通用除法操作或给出算法。若 $f*g_1=f*g_2$，分配律给 $f*(g_1-g_2)=0$，命题 26 迫使 $g_1=g_2$。$f=0$ 时恰在 $h=0$ 有解，且每个 $g$ 都是解。证毕。

<a id="pr2-theta"></a>

## 20. PR2 增补 F：保域时间摘要与最粗充分性

### 20.1 端点类型、实际像及闭合更新

**定义 20（时间摘要及允许签名）。** 对 $X\in\mathcal B$ 记

$$
\Theta(X)=(\pi(X),m_X,M_X,s_X),\quad
m_X=\min t_X[E_X],\quad M_X=\max t_X[E_X],\quad
s_X=\max t_X[\Omega_X].
\tag{TH}
$$

端点类型为 $m_X\in\mathbb Z\cup\{+\infty\}$，$M_X,s_X\in\mathbb Z\cup\{-\infty\}$，统一在扩展整数全序中比较。约定空 $E$ 的 $m=+\infty,M=-\infty$，空 $\Omega$ 的 $s=-\infty$。实际载体是

$$
\mathcal T:=\Theta[\mathcal B]\subseteq
P\times(\mathbb Z\cup\{+\infty\})
\times(\mathbb Z\cup\{-\infty\})^2.
$$

不声称右边任意元组可实现。例如 $E\ne\varnothing$ 时 $m,M$ 都有限且 $m\le M$；$\Omega\ne\varnothing$ 时还须 $m\le s\le M$。$\pi=(0,0)$ 不判定 $\Omega$ 为空，因未选的同位置正负对也有此读数。$s$ 检查整个当前整体，绝非 $\max t[A]$；例如所选正点在 $0$、未选负点在 $9$ 时，$s=9$ 而所选最大时刻为 $0$。

指定

$$
\Sigma_{\rm st}=\{\boxplus,\boxtimes,N,\triangleright\}
\cup\{F_S:S\subseteq\mathbb Z^3\}
\cup\{T_k:k\in\mathbb Z\}.
\tag{ST}
$$

乘法仍为定义 6 的 `max+1` 档案乘法，平移每次带显式整数 $k$。终端观察仍是 $q$，上下文严格按定义 16 使用全槽位、任意固定丰富参数及有限复合，失败为独立的 $\bot$。本签名不含来源、因果、出现身份或时间筛选。

**命题 29（$\Theta$ 上的精确域与更新，repo-derived）。** 在 $\mathcal T$ 的实际像上，(ST) 的操作全部下降并恰好保域。并行加法与有定义的时间复合都更新为

$$
(\pi_X+\pi_Y,\ \min(m_X,m_Y),\ \max(M_X,M_Y),\ \max(s_X,s_Y)).
\tag{TH+}
$$

时间复合的域恰为 $M_X<m_Y$，包括空输入。令

$$
\gamma(s,t)=
\begin{cases}
-\infty,&s=-\infty\text{ 或 }t=-\infty,\\
\max(s,t)+1,&s,t\in\mathbb Z.
\end{cases}
$$

档案乘法写 $g=\gamma(s_X,s_Y)$，更新为

$$
(\pi_X\pi_Y,\ \min(m_X,m_Y),\ \max(M_X,M_Y,g),\ g),
\tag{TH*}
$$

其中 $\pi_X\pi_Y=(w_X*w_Y,z_X*z_Y)$。补集仅把 $\pi$ 换为 $(w,w-z)$，空间筛选仅换为 $(w,\mathbf1_Sz)$；两者三个端点均不变。$T_k$ 不改 $\pi$，对三个有限端点加 $k$，对无穷哨兵保持原值。

**证明。** 并集只复制两档案的时刻、两当前区域的时刻，故极值分别取 min/max，且命题 20 给出 $\pi$ 加法；时间复合只添边、不改这几组数据。若两档案非空，有限极值使全称 guard 等价于最大左时刻严格小于最小右时刻。若左为空，$-\infty<m_Y$ 对所有可能的 $m_Y$ 成立；若右为空，$M_X<+\infty$ 对所有可能的 $M_X$ 成立；两者空时也成立，正好对应空真。

乘法任一当前区域空时无新事件，旧档案并集给出 (TH*) 的 $g=-\infty$ 分支。否则两区域的最高时刻都达到；所有新时刻至多 $\max(s_X,s_Y)+1$，取最高时刻父点即可达到，故新整体最大值为 $g$。新事件比其两个父点都晚，而父点已在旧档案中，所以任何新点都不能降低旧档案并集的最小时刻。档案最大值则须同时计两份旧档案及新整体，恰为 $\max(M_X,M_Y,g)$。$\pi$ 乘法由命题 20 给出。补集与空间筛选不改变 $E,\Omega,t$，平移保极值和空性，得其余更新。每个实际像输入都可取丰富原像；上述公式等于该合法丰富运算的像，故输出仍在 $\mathcal T$，且同摘要的不同原像得到同输出、同域。这证明恰好下降，不依赖任意形式端点元组的可实现性。证毕。

可选地加入 §15.2 的纯位置 $M_K$：它使用完整乘积情境，三个端点仍按 (TH*)，只有 $z$ 改用 (K)，故以下充分性与必要性也不变。这个边界不许可任意来源、因果或时间关系配对。

### 20.2 必要性探针与恢复定理

**命题 30（$\Theta$ 恰为最粗充分读数，repo-derived）。** 对 (ST) 的严格 $q$ 观察，

$$
\approx_{\Sigma_{\rm st}}=\ker\Theta.
\tag{THEQ}
$$

因此任意对此语言充分的总读数 $h:\mathcal B\to H$ 都在其实际像上唯一恢复 $\Theta$：存在唯一 $\kappa:h[\mathcal B]\to\mathcal T$ 满足 $\kappa(h(X))=\Theta(X)$。

**证明（充分性）。** 命题 29 使 $\ker\Theta$ 对所有基本操作强保域，并在域内保持摘要；终端 $q=\varepsilon z$ 可由摘要恢复。对定义 16 的上下文归纳：基本步骤同步成功或失败，成功时摘要相同；复合传播失败或继续应用同一更新。因此同摘要时任意上下文的严格终端观察相同。

**证明（恢复 $\pi,m,M$）。** 反向，单点探针 $q(F_pX)$ 与 $q(F_pNX)$ 按 (REC) 恢复全部 $z,w$。现在记 $U_t=T_t(\mathbf i(1))$，即两个当前正负事件、均在零位置且时刻 $t$、只选正事件，$q(U_t)=1$。这里下标 $t$ 始终指时间；与 §16 的空间平移见证区分。任意 $U_t$ 都可作为固定参数，不需要它是签名里的常数符号。由命题 29，

$$
X\triangleright U_t\text{ 有定义}\iff M_X<t,
\qquad U_t\triangleright X\text{ 有定义}\iff t<m_X.
\tag{TP}
$$

两整数阈值族分别恢复 $M$ 和 $m$。具体地，若 $M_X<M_Y$，较大者 $M_Y$ 有限，取 $t=M_Y$ 区分；这也覆盖 $M_X=-\infty$。若 $m_X<m_Y$，较小者 $m_X$ 有限，取 $t=m_X$ 区分；这也覆盖 $m_Y=+\infty$。空档案的阈值族在所有整数上均成功，而任一有限端点都有一个失败阈值，所以哨兵也被区分。

**证明（恢复 $s$，显式迭代界）。** 只余 $\pi,m,M$ 相同而 $s$ 不同的情形。不失一般性 $s_X<s_Y$，故 $s_Y$ 有限，$E_Y$ 非空；共同的 $m,M$ 因而有限，两档案都非空。选任意整数 $t\le m$，它同时满足 $t\le M$ 及 $t\le s_i$（对所有有限的 $s_i$）。对两输入用同一个一孔上下文反复右乘：$X^{(0)}=X$，$X^{(n+1)}=X^{(n)}\boxtimes U_t$，$Y$ 同理。由 (TH*) 归纳，非空当前区域每步最高时刻加一，而空当前区域始终为空；对 $n\ge1$，

$$
\begin{array}{ll}
s_i\in\mathbb Z:&s_{i^{(n)}}=s_i+n,\quad M_{i^{(n)}}=\max(M,s_i+n),\\
s_i=-\infty:&s_{i^{(n)}}=-\infty,\quad M_{i^{(n)}}=M.
\end{array}
\tag{AMP}
$$

理由是新加入的每份 $U_t$ 不超过旧天花板 $M$，而 $s_i+n$ 严格递增；有限 $s_i$ 仍不低于 $t$，所以下一次 $\gamma$ 恰再加一。两侧的 $\pi$ 始终相同，因为每步都与同一 $\pi(U_t)$ 相乘。

若两 $s$ 有限，取 $n=M-s_X+1\ge1$、$r=s_Y+n$，则 $M<s_X+n<s_Y+n=r$，所以 $M_{X^{(n)}}<r=M_{Y^{(n)}}$。若 $s_X=-\infty$，取 $n=M-s_Y+1\ge1$、$r=s_Y+n=M+1$，则 $M_{X^{(n)}}=M<r=M_{Y^{(n)}}$。两种情况下再接 $\square\triangleright U_r$，左侧有定义而右侧失败。迭代数有限，整个探针属于定义 16 的有限上下文。因此 $s$ 不同必可区分，得到必要性。空 $E$ 与非空 $E$ 已由上一段区分，不会在此被错误当成共同有限天花板的输入。

合并两方向得 (THEQ)。充分读数 $h$ 有 $\ker h\subseteq\approx_{\Sigma_{\rm st}}=\ker\Theta$；对每个 $h$ 的像点，所有原像的 $\Theta$ 值相同，故其图定义唯一 $\kappa$，与命题 23 的像上恢复证明相同。没有在未命中的 $H$ 点上选值，也不声称恢复函数可计算或字节数最优。证毕。

**反例 C2（仅存 $\pi,\min E,\max E$ 不充分）。** 构造 $X_0,X_9$，每份当前整体是一正一负，位置全为零、来源 leaf(0)、只选正事件；两点时刻分别全为 $0$ 或全为 $9$。另各加两个不入 $\Omega$ 的档案事件，时刻 $0,10$、零位置、正符号、来源 leaf(9)，使用不同出现标识，偏序为空。两者 $\pi=(0,\delta_0),m=0,M=10$，但 $s=0,9$。两次右乘 $U_0$ 后分别 $s=2,11$，归档最大时刻为 $10,11$。随后接 $\triangleright U_{11}$，前者有定义且 $q=2$，后者因 $11<11$ 为假而失败。这是明确的三步上下文，不靠一般迭代界代替具体核算。

**摘要的消费边界。** $\Theta$ 仍丢来源与因果：B1 两对象都有 $(m,M,s)=(0,0,0)$，B2 两对象都有 $(0,1,1)$，其原查询反例仍成立。它也不回答任意时间筛选。例：一份当前正事件在 $0$、另一份在 $5$，两份当前负事件都在 $9$，只选正点；另都加不入当前区域的时刻 $0,10$ 旧事件，其他属性同 C2。二者 $\Theta=((0,\delta_0),0,10,9)$，按“时刻等于 $0$”筛选却得 $1,0$。该操作未在 (ST) 中；正式扩签名才会进一步细化观察核。

### 20.3 摘要层的运算律及非环边界

**命题 31（摘要层的精确律）。** $\mathcal T$ 的并行加法是交换幺半群，单位为 $\Theta(0_\varnothing)=((0,0),+\infty,-\infty,-\infty)$；乘法交换且双侧分配，但不结合、没有单位；并行零一般不吸收乘法。

**证明。** (TH+) 的 $\pi$ 加法交换结合，端点的 min/max 也交换结合，空哨兵分别是相应 min/max 的单位。这给出全部幺半群律。乘法的 $\pi$ 卷积交换，(TH*) 各端点式也对称，故摘要乘法交换；这不反驳历史层的来源反例。

证明分配时先核对包括空区域的恒等式

$$
\gamma(s,\max(t,u))=\max(\gamma(s,t),\gamma(s,u)).
\tag{GD}
$$

若 $s=-\infty$ 或 $t=u=-\infty$，两边都为 $-\infty$。其余情形 $s$ 有限且 $t,u$ 至少一个有限；忽略其中的空项，两边都是这些有限值与 $s$ 的最大值加一，故相等。现比较 $X(Y+Z)$ 与 $XY+XZ$：$\pi$ 分量由卷积分配律相同；最小端点两边都是 $\min(m_X,m_Y,m_Z)$（重复的 $m_X$ 由 min 的幂等性消去）；$s$ 分量由 (GD) 相同；$M$ 分量两边都是 $\max(M_X,M_Y,M_Z,\gamma(s_X,s_Y),\gamma(s_X,s_Z))$。因此分配成立，另一侧由交换性给出。此核对包含 $E$ 空及 $\Omega$ 空而 $E$ 非空的边界。

非结合取 $U_0,U_0,U_1$，其三个 $s$ 为 $0,0,1$。左括号的新根时刻为 $\max(1,1)+1=2$，旧事件最高仅 $1$，故 $M=s=2$；右括号先生成 $2$，再生成 $3$，归档 $M=s=3$。两侧 $m=0,\pi=(0,\delta_0)$，摘要仍不同。任何单位候选 $V$ 与 $U_t$ 相乘，若 $s_V=-\infty$，输出 $s=-\infty\ne t$；否则输出 $s=\max(s_V,t)+1>t$，同样不可能是 $U_t$。故没有乘法单位。最后 $U_0\boxtimes0_\varnothing$ 的摘要是 $((0,0),0,0,-\infty)$，不等于空档案的并行零。非空档案的加法逆也不可能存在，因为其有限 $M$ 与任意 $M'$ 取 max 后不能成为 $-\infty$。所以这里不是环，空间环律不能全部搬上来。证毕。

<a id="pr2-time"></a>

## 21. PR2 增补 G：整数时间规则的必然部分与约定部分

**命题 32（最早整数与全部交换重标）。** 对 $a,b\in\mathbb Z$，$\max(a,b)+1$ 是同时严格晚于二者的最早整数。一个任意函数 $h:\mathbb Z\to\mathbb Z$ 满足

$$
h(\max(a,b)+1)=\max(h(a),h(b))+1\quad(\forall a,b\in\mathbb Z)
\tag{CLOCK}
$$

当且仅当存在 $c\in\mathbb Z$ 使 $h(n)=n+c$ 对全部整数成立，不需先假设 $h$ 双射或单调。

**证明。** $\max(a,b)+1$ 严格大于二者；任一整数 $j>a,b$ 满足 $j>\max(a,b)$，整数离散性给 $j\ge\max(a,b)+1$。对 (CLOCK) 代入 $a=b=n$，得到 $h(n+1)=h(n)+1$。以 $c=h(0)$，向上归纳给全部非负整数的公式；以 $h(n)=h(n+1)-1$ 向下归纳给全部负整数的公式。反向，整数平移保 max，代入即得 (CLOCK)。证毕。

**命题 33（完整二叉构造树的根时刻）。** 给一棵有限完整二叉树（每个内部节点恰有两子节点），叶 $i$ 的输入时刻为 $t_i\in\mathbb Z$，每个内部节点按默认规则计算。以叶到根的边数为 $\operatorname{depth}_i$，则

$$
t_{\rm root}=\max_i(t_i+\operatorname{depth}_i).
\tag{TREE}
$$

**证明。** 单叶树深度为零，公式成立。内部根的两子树由归纳假设分别有根时刻 $\max_{i\in L}(t_i+d_i)$、$\max_{i\in R}(t_i+d_i)$；新根取二者 max 再加一，等于对所有叶取 $\max(t_i+d_i+1)$。每片叶在整树中的深度恰比其子树深度多一，得公式。证毕。该式描述所选生成事件的构造树；档案中不参与该树的旧事件还可有更大时刻，不能用 (TREE) 代替全档案 $M$。它准确暴露括号树形依赖，不是物理时间定律。

**明示边界族（不替换默认）。** 若预先选择正整数延迟 $\kappa$，把每个新时刻规定为 $\max(a,b)+\kappa$，它仍严格晚于两父点，所以命题 3 的合法性证明逐边照用；但仅 $\kappa=1$ 有命题 32 的“最早整数”性质。同一结构归纳给根时刻 $\max_i(t_i+\kappa\operatorname{depth}_i)$。对正整数 $a$ 及整数 $b$，$h(t)=at+b$ 满足

$$
h(\max(t,u)+\kappa)
=\max(h(t),h(u))+a\kappa.
$$

这是因为正缩放保 max 且 $h(v+\kappa)=h(v)+a\kappa$。因此缩放同时运输延迟为 $a\kappa$ 才交换；若固定 $\kappa>0$，取 $t=u$ 就迫使 $a\kappa=\kappa$，即 $a=1$。默认模型与 §20 主定理始终取 $\kappa=1$。

<a id="pr2-reference"></a>

## 22. PR2 增补 H：共同空间参考点与整数仿射运输

**定义 21（带参考点的情境纤维）。** 对每个 $o\in\mathbb Z^3$ 取一个带标记的载体 $\mathcal B_o=\{(o,X):X\in\mathcal B\}$。只在共同 $o$ 的纤维内定义乘法 $\boxtimes_o$：定义 6 唯一改变的是新事件位置

$$
x(p_{ab})=x_X(a)+x_Y(b)-o.
\tag{ORIGIN}
$$

档案、符号、来源、`max+1` 时间、偏序、当前区域与选择都沿旧规则。$o=0$ 时逐项回到原模型，绝不暗换默认。不同参考点的输入不在此二元操作的域内；需先显式运输到共同纤维。在本节省略对象上重复的 $o$ 标记，并以 $u(X)$ 简记 $u(C_X)$。

**命题 34（参考点卷积与空间单位）。** 此运算合法，$q(X\boxtimes_oY)=q(X)q(Y)$、$u(X\boxtimes_oY)=u(X)u(Y)$ 及命题 3 的档案基数均不变。空间乘法成为

$$
(c*_o d)(r)=\sum_{p+q-o=r}c(p)d(q),
\qquad \pi(X\boxtimes_oY)=(w_X*_ow_Y,z_X*_oz_Y).
\tag{OC}
$$

有单位空间环 $(R,+,*_o)$ 的自身单位为 $\delta_o$；$\{0\}\times R$ 的自身单位为 $(0,\delta_o)$。它们不是档案乘法单位，也不是 $P$ 的单位。

**证明。** 位置不参与时标偏序约束，故合法性证明不变；电荷与基数只用符号、标签及候选对数，故命题 3 的逐项证明不变。按两父位置分组有限和即得 (OC)。直接计算 $\delta_o*_oc=c=c*_o\delta_o$。令 $L_o(c)(r)=c(r+o)$，它是 $R$ 的加法双射；置 $p=p'+o,q=q'+o$，有 $p+q-o=r+o\iff p'+q'=r$，所以 $L_o(c*_od)=L_o(c)*L_o(d)$。于是该环经 $L_o$ 与原 $R$ 同构，$P$ 的背景条件也由总和不变保持，故它仍无单位，$P_0$ 的自身单位则如上。档案基数及当前区域的无单位反证完全与位置无关，命题 24 仍适用。证毕。

**命题 35（整数仿射正向与双向运输）。** 给任意整数矩阵 $M\in\operatorname{Mat}_{3\times3}(\mathbb Z)$、整数向量 $v$，令 $F(x)=Mx+v$。将全部事件位置经 $F$ 运输而保持事件身份及其他数据，参考点同时变为 $F(o)$，定义 $\mathcal F:\mathcal B_o\to\mathcal B_{F(o)}$。它对全部这种 $M$ 都是合法的正向运输，且

$$
F(x+y-o)=F(x)+F(y)-F(o),
\qquad
\mathcal F(X\boxtimes_oY)=\mathcal F(X)\boxtimes_{F(o)}\mathcal F(Y).
\tag{AFF}
$$

整数坐标上的双向运输恰在 $M\in GL_3(\mathbb Z)$ 时保证。

**证明。** 左式展开为 $Mx+My-Mo+v$，右式也为同一向量。档案标签不变，旧点的属性在两侧一样，新点的位置由此恒等式一样，其他生成属性及边按同一旧规则，故得到完整丰富表示的等式，而非仅电荷等式。任意整数矩阵都保持位置的整数类型，且位置无额外合法性约束，故正向结论不要求单射。若 $M$ 在整数格点上双射，标准基向量的逆像组成整数矩阵 $N$，有 $MN=I$；行列式给 $\det M\det N=1$，所以 $\det M=\pm1$。反向若 $\det M=\pm1$，伴随矩阵公式给整数逆 $M^{-1}$，仿射逆为 $x\mapsto M^{-1}(x-v)$，也将参考点运回 $o$。这证明等价。证毕。

固定 $o$ 的共同平移失配仍在：先把两个输入加 $v\ne0$ 却不动 $o$，新位置为 $x+y+2v-o$；先乘再平移为 $x+y+v-o$。 (AFF) 运输的是带参考点的整个族，要求同时 $o\mapsto o+v$，没有推翻 §8 的旧反例。

**命题 36（有限推送与筛选的逆像公式）。** 即使 $F$ 非单射，$\mathcal F$ 也不合并任何事件身份。空间电荷则用有限推送

$$
(F_*c)(r)=\sum_{p\in\operatorname{supp}(c),\ F(p)=r}c(p),
\qquad \pi(\mathcal F X)=(F_*w_X,F_*z_X)
$$

合并系数；对任意 $S\subseteq\mathbb Z^3$ 有

$$
F_*(\mathbf1_{F^{-1}(S)}z)=\mathbf1_SF_*z,
\qquad
\mathcal F(F_{F^{-1}(S)}X)=F_S(\mathcal F X).
\tag{PULL}
$$

还满足 $F_*(c*_od)=(F_*c)*_{F(o)}(F_*d)$ 及 $\varepsilon(F_*c)=\varepsilon(c)$。

**证明。** 事件集合未取商，只改其位置属性；按新位置归组自然得到 $F_*$，即使某纤维无限，参与的支撑仍有限。左边 (PULL) 在 $r$ 的系数为 $\sum_{F(p)=r}\mathbf1_S(F(p))z(p)=\mathbf1_S(r)\sum_{F(p)=r}z(p)$，得电荷式；事件式来自逐事件条件 $x(e)\in F^{-1}(S)\iff F(x(e))\in S$。推送卷积的两边都是有限双和，分别按 $F(p+q-o)=r$ 或 $F(p)+F(q)-F(o)=r$ 分组，(AFF) 使条件相同。对全部目标点求和则每个原支撑项恰计一次，得增广式。证毕。

**反例 C3（直接像区域不能替代逆像）。** 取非单射 $F(x_1,x_2,x_3)=(0,x_2,x_3)$，$e_1=(1,0,0)$，$z=\delta_0+\delta_{e_1}$，$D=\{0\}$。有 $F_*(\mathbf1_Dz)=\delta_0$，但 $\mathbf1_{F[D]}F_*z=2\delta_0$。可用两个位置各一正一负、只选正点的四事件平衡表示实现 $w=0,z$；运输后四个出现仍各自存在，两个所选正贡献只是同处零点。错误来自把非饱和 $D$ 直接换成 $F[D]$：其逆像还含 $e_1$。正确的 (PULL) 在 $S=\{0\}$ 使用整个逆像，两边均为 $2\delta_0$。

<a id="pr2-evidence"></a>

## 23. PR2 的来源、调用边界与定向核验

### 23.1 成熟框架与本仓推导的边界

分层代数、上下文等价、群代数与仿射空间采用成熟框架，不称新颖。§17.2 已核读收据中的 Burris/Sankappanavar、Pitts、Mathlib 在线有限支撑卷积仍分别支持这些背景概念；它们不直接承担本批的 CSA 特定摘要证明。另使用 caller 在批准计划中提供的核读结论：

| 来源 | 精确范围与使用边界 |
| --- | --- |
| J. S. Milne, *Algebraic Groups* (2017)，[§12b，pp. 230–231](https://www.jmilne.org/math/Books/iAG2017.pdf) | `literature-attested`：域系数的有限生成阿贝尔群代数背景；不是本文整数系数单位分类的证明。 |
| Jean Gallier，[geomcs-v2.pdf](https://www.cis.upenn.edu/~jean/gbooks/geomcs-v2.pdf)，作者 2025-10-09 版 §2.1，pp. 18–19 | `literature-attested`：实系数仿射空间与点/向量区分；不冒称该页直接证明整数 torsor 定理。 |

CSA 的实际像、分层反例、$\Theta$ 闭合更新及必要性、此处整数仿射运输归类为 `repo-derived`；卷积极值、整数单位与整数仿射结论的证明均在正文自给，不以外部引文或有限核验填补证明。没有新增 Lean、axiom、判官、schema 或生产引擎，也不宣称本稿已被 Lean 验证。

**本批产地与意见状态。** 本批由 `consensus-rnd:sshx` 的一个 Codex implementation_worker 在固定 PR1 已提交候选 `feec239217c30601cca92c53620492516bec915a` 上实施；输入包括用户批准数学计划、必读规范及本树文稿，属于 `repo-prior-exposed`。未读取另一工作树、同轮 architecture 工件或其他 review 输出，未调用其他 worker。按 caller 本批明确告知的事实，PR1 两次 architecture oracle 请求均因超过预定 `configuring_composer` 等待窗口而被 caller 取消，未返回数学内容；这两次不是已完成数学意见。§17.2 的思考失败和纯连通性探测也不计本轮 S1，§12 旧 PRO 任务只属原稿历史。用户所称 GPT PRO 即 nyxid oracle 通道，不另按型号名是否带 Pro 判定。当前没有可消费的本轮成功实质 Nyx 数学意见；S1 由后续实际 oracle 评审继续结算，实际意见的处置和独立三席评审由 caller 记录。本批不预报 PR2 最终评审通过、required checks 通过或合入。

### 23.2 定向有限核验的预期与界限

附录原有唯一 Python 块复用 `Rich/add/mul/neg/temporal`；新增辅助函数仅用于本页的精确样本核验。预期值由 §18–22 的公式和手算反例规定：历史分配档案为 $14/16$，来源交换在时刻 $1$ 处有四个不匹配的新点；时间复合包括六事件十二条跨边的合法三元组、空中间合法例及相邻 guard 空真而两括号失败的例子。另用含空档案、空当前区域、非空旧档案、未选高时刻点的样本逐对检查 (TH+)、(TH*) 及精确 guard，C2 两次右乘后 $\max E=10/11$，接 $U_{11}$ 恰一侧失败。

卷积测试在三个给定格点、系数 $\{-1,0,1\}$ 的非零小支撑样本中核对极值系数及唯一拆分，另检验 $2\delta_0-\delta_v$ 的增广为 $1$、不属单位族，并在明示有限候选中排除它的逆；无零因子和全部单位分类只由命题 26–27 证明。树公式比较不同括号、不同叶时刻及正整数延迟；参考点测试使用一般整数矩阵、非单射矩阵和仿射位移，同时检查全部事件数据与参考点的运输，并执行 C3 的 $1/2$ 筛选差异。stdout 中的新增计数均由实际执行累加或读取样本结果，有限运行不证明无限全称命题、全部上下文或所有整数仿射映射。


**有限窗口的具体取值。** 时间三元组取空档案、$U_{-1},U_0,U_1,U_2$ 及档案为时刻 $4$ 的正负对但当前区域为空的六个状态。$\Theta$ 的八个状态取空档案、$U_{-1},U_0,U_1$、上述空当前区域状态、C2 的两状态和正点时刻 $0$/负点时刻 $9$ 的状态；每个状态核验补集、三种空间筛选、三种平移，并在整数阈值 $[-3,12]$ 上探测左右 guard。卷积极值的三个格点为 $0,v,h$（沿用 §17.3）；逆候选仅取 $-v,0,v$ 上三系数在 $\{-1,0,1\}$ 的 $27$ 个函数。树枚举三叶和四叶的全部二叉括号，叶时刻各取 $\{-2,0,3\}$、延迟取 $1,2,3$；丰富树另每个括号取叶时刻 $(0,1,\ldots,n-1)$。参考点用 $0,(1,2,-1)$，矩阵用恒等、$2I$、$(x_1,x_2,x_3)\mapsto(x_1+x_2,x_2,-x_3)$ 和 C3 的投影，位移为 $(2,-1,3)$；输入取 $U_0$、§17.3 的 $X,Y$ 及空当前区域状态。

**本批实际运行收据（2026-09-09）。** 在固定候选 `feec239217c30601cca92c53620492516bec915a` 的指定工作树中，亲跑附录原 `sed ... | sed ... | python3 -` 提取命令；首次及将新增同构计数改为实际调用累加后的重跑均退出 `0`。最终执行包含原检查、PR1 检查及 PR2 新增检查，末行实得 `ALL_FINITE_CHECKS_PASSED`。下面仅列最终执行的 PR2 stdout，不把原历史输出当作本批收据：

```text
pr2_history: distributivity_archives=14,16 ordered_source_new_events=4,4 additive_isomorphisms=3
pr2_temporal: triples=216 defined=56 legal_archive=6 legal_edges=12 empty_middle_adjacent_guards_insufficient=True
pr2_theta: pairs=64 unary=56 integer_thresholds=256 amplification_cases=2 archive_maxima=10,11 following_U11=defined,failed time_filter=1,0
pr2_theta_laws: rich_triples=64 associativity_maxima=2,3 zero_absorbing=False
pr2_extrema: nonzero_samples=26 pairs=676 products_delta0=2 signed_delta_inverses=10 nonunit_augmentation=1 inverse_candidates_rejected=27
pr2_clock: depth_cases=1377 rich_trees=7 translations=147 scaled_delay_cases=675 fixed_delay_scaling_rejected=True
pr2_reference: rich_pairs=32 affine_transports=128 space_units=52 noninjective_events=4 direct_image_filter=1,2 pullback_filter=2
ALL_FINITE_CHECKS_PASSED
```

这些结果只判所列样本；完整一般证明位于命题 24–36。canonical ingest 与差分检查的实际命令、退出码、新增 atom/backfill 及 residual-open 计数由本 worker 的 runner 结果工件记录，独立评审与 git/GitHub 生命周期交由 caller 接续。

<a id="pr3-source"></a>

## 24. PR3 增补 I：来源语言与来源–位置双电荷

本节沿用定义 1 的来源树集合 $T$，将定义 12／命题 9 的联合分箱 $f(e)=(x(e),\rho(e))$ 向全域补零。记全局读数为 $\rho_{\rm src}$，与逐事件来源函数 $\rho(e)$ 区分：

$$
\rho_{\rm src}(X)=(w_X^\rho,z_X^\rho),\qquad
w_X^\rho(p,r)=\sum_{\substack{e\in\Omega_X\\x(e)=p,\ \rho(e)=r}}\sigma(e),\quad
z_X^\rho(p,r)=\sum_{\substack{e\in A_X\\x(e)=p,\ \rho(e)=r}}\sigma(e).
\tag{SRC}
$$

两分量都是 $\mathbb Z^3\times T\to\mathbb Z$ 的有限支撑函数；比较时可先取两对象所用联合 bin 的有限并。这是已有粗观察的特化，不另建来源本体。$q(X)=\sum_{p,r}z_X^\rho(p,r)$，$\sum_{p,r}w_X^\rho(p,r)=0$；对来源求和恢复 $\pi$。

在加法群 $R_T=\mathbb Z^{(\mathbb Z^3\times T)}$ 上定义魔群环乘法：

$$
\delta_{(p,r)}\star\delta_{(q,s)}
=\delta_{(p+q,\operatorname{pair}(r,s))},
\tag{SRC*}
$$

再作 $\mathbb Z$ 双线性延拓。于是
$(c\star d)(u,\operatorname{pair}(r,s))=\sum_{p+q=u}c(p,r)d(q,s)$，而每个叶来源处的乘积系数为零。pair 单射使每个 pair 结点的两个来源子树分解唯一；位置仍需对全部有限支撑拆分求和。这个乘法**非结合、非交换**：三叶的 $\operatorname{pair}(\operatorname{pair}(r,s),t)$ 与 $\operatorname{pair}(r,\operatorname{pair}(s,t))$ 不同；$r\ne s$ 时 $\operatorname{pair}(r,s)\ne\operatorname{pair}(s,r)$，相应基向量已见失败。双线性及有限支撑不授予结合律；§15 交换 rng 的结合证明、§19 的整性与单位分类不施于这个来源 pair 代数。

指定 $\Sigma_{\rm src}=\Sigma_{\rm sp}\cup\{F_L:L\subseteq T\}$，载体仍为 $\mathcal B$，观察与全槽位、全参数、任意有限深度上下文仍按定义 16。

**命题 37（来源双电荷的精确更新，repo-derived）。** 写 $w=w_X^\rho,z=z_X^\rho,w'=w_Y^\rho,z'=z_Y^\rho$，则

$$
\begin{aligned}
\rho_{\rm src}(X\boxplus Y)&=(w+w',z+z'),\\
\rho_{\rm src}(X\boxtimes Y)&=(w\star w',z\star z'),\\
\rho_{\rm src}(NX)&=(w,w-z),\\
\rho_{\rm src}(F_SX)&=(w,\mathbf1_{S\times T}z),\\
\rho_{\rm src}(F_LX)&=(w,\mathbf1_{\mathbb Z^3\times L}z).
\end{aligned}
\tag{SRC-UP}
$$

**证明。** 沿命题 20 的分组求和，在联合 bin 中并行两份电荷相加；新乘积事件的联合属性为 $(p+q,\operatorname{pair}(r,s))$，父 bin 对上的有限双和是系数之积，再向该联合属性推送即为 $\star$。旧档案不入当前区域，故不添线性项。补集在每个 bin 内取未选电荷；两种筛选只掩蔽所选电荷，背景不变。各操作在 $\mathcal B$ 上总定义；增广对 $\star$ 保乘由有限双和给出，所以背景总和仍为零。证毕。

**命题 38（来源语言的观察核，repo-derived）。**

$$
\approx_{\Sigma_{\rm src}}=\ker\rho_{\rm src}.
\tag{SRC-EQ}
$$

**证明。** 充分性按定义 16 归纳，与命题 22 同形：恒等孔保读数；任一基本上下文在两侧使用同一个固定丰富参数，(SRC-UP) 给同一输出读数；有限复合反复应用这些更新，最终 $q$ 由 $z^\rho$ 求和恢复。所有操作总定义，不遗漏部分域。必要性对每个 $p\in\mathbb Z^3,r\in T$ 用签名内的探针

$$
q(F_pF_{\{r\}}X)=z_X^\rho(p,r),\qquad
q(F_pF_{\{r\}}NX)=w_X^\rho(p,r)-z_X^\rho(p,r).
\tag{SRC-REC}
$$

这里 $F_p$ 按 §16 为位置单点筛选，$F_{\{r\}}$ 是来源单树筛选。第一式恢复 $z^\rho$，两式相加恢复 $w^\rho$；因此观察等价蕴含全部坐标相同。证毕。

**旧见证的新读数（repo-derived）。** 以下只给既有对象追加 (SRC) 读数，数值由定义 8、B1 和 (SRC-UP) 直接计算，附录 `pr3_source` 检查这些等式。记 $l_i=\operatorname{leaf}(i)$。B1 两对象分别有 $\rho_{\rm src}=(0,\delta_{(0,l_7)})$ 与 $(0,\delta_{(0,l_8)})$，故在 $(0,l_7)/(0,l_8)$ 处被分开。§4 的 $X=Y=\mathbf i(1),Z=\mathbf i(2)$ 两括号分别有

$$
\begin{aligned}
z_{(X\boxtimes Y)\boxtimes Z}^\rho
 &=\sum_{j=0}^1\delta_{(0,\operatorname{pair}(\operatorname{pair}(l_0,l_0),l_j))},\\
z_{X\boxtimes(Y\boxtimes Z)}^\rho
 &=\sum_{j=0}^1\delta_{(0,\operatorname{pair}(l_0,\operatorname{pair}(l_0,l_j)))}.
\end{aligned}
$$

两者 $w^\rho=0$，所列支撑不交，虽 $q=2$ 相同。§18 的来源交换例分别有 $z^\rho=\delta_{(0,\operatorname{pair}(l_7,l_8))}$ 与 $\delta_{(0,\operatorname{pair}(l_8,l_7))}$，同样 $w^\rho=0$。这些事实证明 $\rho_{\rm src}$ 能区分相应对象，**不证明它恢复档案基数**；§4 的 $28/32$ 仍是档案计数，(SRC) 只数当前区域。

**命题 39（来源与时间混合语言，repo-derived）。**

$$
\approx_{\Sigma_{\rm src}\cup\Sigma_{\rm st}}
=\ker(\rho_{\rm src},m,M,s).
\tag{SRC-ST}
$$

**证明。** 对两种并集复合，$\rho_{\rm src}$ 都逐分量相加；时间复合只添边，其精确守卫仍为命题 29 的 $M_X<m_Y$。乘法、补集、两种筛选按 (SRC-UP)，$T_k$ 不改联合电荷。端点对并集、乘法、补集、平移复用命题 29；来源筛选与空间筛选一样不改 $E,\Omega,t$，故不改端点。现在对**混合**上下文归纳：基本步骤用同一参数、同一守卫，两侧同步失败，或成功并得到同一四元摘要；复合严格传播失败，成功则继续归纳，终端由 $z^\rho$ 求和。故此核充分，证明没有把两条核定理取交当作混合闭包证明。反向，来源单点探针 (SRC-REC) 仍在；命题 30 的平衡 $U_t$、左右时间守卫与有限右乘放大探针也仍在，分别恢复 $m,M,s$。因此所有四个坐标必要。证毕。

本节的联合分箱沿用 §8，核证明沿用 §14–16 的上下文方法，CSA 专用公式与见证标 `repo-derived`；成熟框架与外部文献的范围在 §26、§28 逐项列明，不主张新颖性或完整来源代数分类。

<a id="pr3-causal"></a>

## 25. PR3 增补 J：去身份因果可观测性

### 25.1 属性、剖面与允许语言

**定义 22（去身份因果筛选与因果剖面）。** 令

$$
\mathrm{Attr}=\mathbb Z^3\times\{+1,-1\}\times T,\quad
\alpha(e)=(x(e),\sigma(e),\rho(e)),\quad
U_X(e)=\{\alpha(d):d\in\Omega_X,\ e=d\ \lor\ e\prec_Xd\}\quad(e\in\Omega_X).
\tag{CAU-U}
$$

简写 $e\preceq d$ 为 $e=d$ 或 $e\prec d$。总有 $\alpha(e)\in U_X(e)$，故 $U_X(e)$ 非空；这里是可达后继的**属性集**，不假定 $\mathrm{Attr}$ 自身带偏序，也不计相同属性后继的重数。对任意固定 $Q\subseteq\mathrm{Attr}$ 定义总操作

$$
F_{\downarrow Q}(C,A)
=(C,\{e\in A:\exists d\in\Omega_C\ (\alpha(d)\in Q\ \land\ e\preceq d)\}).
\tag{CAU-F}
$$

目标 $d$ 严格量化于 $\Omega_C$，**不是 $E_C$**，且不要求目标被选中。定义 13 的身份查询 $F_{\downarrow D}$ 及其依赖域原封保留；(CAU-F) 是新增的属性谓词语言，不替代那个操作。令 $b_X(e)=\mathbf1_{A_X}(e)$，定义有限支撑剖面

$$
\Gamma_c(X)(a,b,U)
=\sum_{\substack{e\in\Omega_X\\\alpha(e)=a,\ b_X(e)=b,\ U_X(e)=U}}\sigma(e),
\quad (a,b,U)\in\mathrm{Attr}\times\{0,1\}\times\mathcal P_{\rm fin}(\mathrm{Attr}).
\tag{CAU-P}
$$

未选事件进入 $b=0$ 行，不能只记 $b=1$；下标 $c$ 与 §10 的世界域 $\Gamma$ 区分。指定
$\Sigma_{\rm cau}=\Sigma_{\rm src}\cup\Sigma_{\rm st}\cup\{F_{\downarrow Q}:Q\subseteq\mathrm{Attr}\}$，仍按定义 16 观察严格终端 $q$。本文对本签名的全部量词只指这个明确的操作集合。

### 25.2 推送更新与充分性

**命题 40（剖面的推送更新与充分性，repo-derived）。** 以下操作把剖面系数沿所列映射推送；多个格合并时将系数相加：

| 操作 | 对剖面格 $(a,b,U)$ 的更新 |
| --- | --- |
| $X\boxplus Y$ | 两剖面逐格相加 |
| $NX$ | $(a,b,U)\mapsto(a,1-b,U)$ |
| $F_SX$，$a=(p,\epsilon,r)$ | $(a,b,U)\mapsto(a,b\mathbf1_S(p),U)$ |
| $F_LX$ | $(a,b,U)\mapsto(a,b\mathbf1_L(r),U)$ |
| $F_{\downarrow Q}X$ | $(a,b,U)\mapsto(a,b\mathbf1_{U\cap Q\ne\varnothing},U)$ |
| 有定义的 $X\triangleright Y$ | 左侧 $(a,b,U)\mapsto(a,b,U\cup V_Y)$，$V_Y=\alpha[\Omega_Y]$；右侧不变，再相加 |
| $X\boxtimes Y$ | 输入格对 $((a,b,U),(a',b',U'))\mapsto(a\diamond a',bb',\{a\diamond a'\})$，系数相乘后推送 |
| $T_kX$ | $\Gamma_c$ 不变 |

其中
$a\diamond a'=(p+p',\epsilon\epsilon',\operatorname{pair}(r,r'))$。端点 $(m,M,s)$ 的类型、空哨兵、更新与时间守卫 $M_X<m_Y$ 全部引用 §20 命题 29；三个筛选都不改端点。因此 $(\Gamma_c,m,M,s)$ 对 $\Sigma_{\rm cau}$ 充分。

**证明。** 并行不添跨边；补集及三个筛选只改选择位，不改 $U$。时间复合加入全部左档案到右档案的边，恰使每个左当前事件可达全部右当前属性，右侧没有新后继。乘法按定义 6 只用新事件作当前区域：**该次乘法结果的当前区域是由极大事件组成的反链，新事件无出边**，所以每个新当前事件的 $U$ 恰为自身属性的单点集；这不称整个档案为反链，也不声称之后串接仍无后继。新选择位是父选择位之积，新符号是父符号之积；在父剖面格上分组，有限双和即系数相乘。时移不改属性 $\alpha$ 或偏序，故不改剖面。

还须说明 $V$ 可由剖面本身恢复。$\sigma$ 已在 $a$ 中，同一格的所有贡献同号，非空格不会抵消为零。因此

$$
V_X=\{a:\exists b,U\ \Gamma_c(X)(a,b,U)\ne0\},\qquad
\ker(\Gamma_c,V,m,M,s)=\ker(\Gamma_c,m,M,s).
\tag{CAU-V}
$$

$V$ 不是独立坐标。对 $a=(p,\epsilon,r)$ 的格求和恢复 $w^\rho(p,r)=\sum_{\epsilon,b,U}\Gamma_c(a,b,U)$，只取 $b=1$ 恢复 $z^\rho$，再求和恢复 $q$。对定义 16 的混合上下文归纳：同剖面、同端点在每个基本步骤同步过守卫或失败；成功则按上表和命题 29 得同摘要。复合严格传播失败；成功到终端时 $q$ 相同。这是全部上下文的充分性证明，有限抽样只核对实现。证毕。

### 25.3 自身属性隔离引理

**引理 1（自身属性隔离，repo-derived）。** 固定平衡参数 $U_0=\mathbf i(1)$：当前区域恰有位置 $0$、时刻 $0$、来源 $l_0=\operatorname{leaf}(0)$ 的一正一负两事件，偏序空，只选正事件 $u_+$。对 $v=(p,\epsilon,\tau)$、$\eta\in\{0,1\}$，记 $J_1=\mathrm{id},J_0=N$，以及

$$
\begin{aligned}
H_{Q,v,\eta}(X)&=F_{\downarrow Q}(F_{\{p\}}(F_{\{\tau\}}(J_\eta X))),\\
v^*&=(p,\epsilon,\operatorname{pair}(\tau,l_0)),\\
f_{v,\eta}^X(Q)&=q\bigl(F_{\downarrow\{v^*\}}(H_{Q,v,\eta}(X)\boxtimes U_0)\bigr).
\end{aligned}
\tag{CAU-ISO}
$$

上式 $F_{\{p\}}$ 是位置筛选，$F_{\{\tau\}}$ 是来源筛选。则

$$
f_{v,\eta}^X(Q)
=\sum_{\substack{e\in\Omega_X:\alpha(e)=v,\ b_X(e)=\eta\\U_X(e)\cap Q\ne\varnothing}}\sigma(e).
\tag{CAU-HIT}
$$

**证明。** $J_\eta$ 先将原选择位为 $\eta$ 的事件变为所选；接着三个筛选分别检查位置、来源和原来的 $U\cap Q\ne\varnothing$，完整情境不变。$U_0$ 只选 $u_+$，所以新选中事件恰为 $(e,u_+)$，属性为 $(x(e),\sigma(e),\operatorname{pair}(\rho(e),l_0))$，符号仍为 $\sigma(e)$。乘积当前区域为反链，故最后一次因果筛选在这些当前事件上恰等于自身属性筛选。pair 单射与位置、符号坐标一起保证只有 $\alpha(e)=v$ 映到 $v^*$，得 (CAU-HIT)。每个筛选原已在签名内，右乘用的 $U_0\in\mathcal B$ 是定义 16 允许的固定载体参数；所有表达式只有一个孔，不新增原语。证毕。

附录的 $P_\epsilon(Z)$ 简写为 $F_{\downarrow Q_\epsilon}(Z\boxtimes U_0)$，其中固定谓词 $Q_\epsilon=\{(p,\epsilon,r):p\in\mathbb Z^3,r\in T\}$；在该乘积反链上它隔离原选择的符号。它是合法上下文的辅助名称，不是新增操作。不能改用“早时刻单事件参数”：其当前总电荷为 $\pm1$，不在定义 3 的平衡载体中，定义 16 不允许它作参数。

**反例 D1（裸探针抵消，repo-derived）。** 取 $E=\Omega=\{a,b,c,d\}$，位置全 $0$、来源全 $l_0$，符号 $+,-,+,-$，时刻 $0,1,2,2$，严格关系恰为
$a\prec b,a\prec c,a\prec d,b\prec c,b\prec d$。$X$ 选 $\{a,b\}$，$Y$ 选空集。记 $v_+=(0,+1,l_0),v_-=(0,-1,l_0)$，则 $U(a)=U(b)=\{v_+,v_-\}$。任意 $Q,S,L$ 对 $a,b$ 同取同舍，故
$q(F_{\downarrow Q}F_SF_LX)=q(F_{\downarrow Q}F_SF_LY)=0$。先取 $N$ 后两侧也相等：原来相差的 $a,b$ 仍抵消；**此时不恒为零**，例如 $Q=\{v_+\},S=\{0\},L=\{l_0\}$ 时两侧均为 $1$。引理 1 用 $v=v_+,\eta=1,Q=\{v_+,v_-\}$ 却分别给 $1,0$；$q(P_+(X)),q(P_+(Y))$ 也为 $1,0$。这些读数由所列四事件逐项求和，附录复核。缺的是裸探针证书的隔离步，**不是核等式被反驳**。

### 25.4 必要性与完整 iff

**命题 41（去身份因果语言的观察核，repo-derived）。**

$$
\approx_{\Sigma_{\rm cau}}=\ker(\Gamma_c,m,M,s).
\tag{CAU-EQ}
$$

**证明。** 充分性已由命题 40 的混合上下文归纳给出。必要性比较 $X,Y$ 时，固定共同有限集合 $D=V_X\cup V_Y$。所有 $U_X(e),U_Y(e)$ 均为 $D$ 的非空子集；$v\notin D$ 的行全零。在这对对象的证明中，$D$ 及下列 $Q$ 是**固定的谓词参数**，并非增加一个随输入变化的原语。对每个 $v\in D,\eta\in\{0,1\}$，引理 1 的全部合法上下文读数相等，所以两对象的全部 $f_{v,\eta}(Q)$ 相等。对 $W\subseteq D$，令

$$
h_{v,\eta}(W)=f_{v,\eta}(D)-f_{v,\eta}(D\setminus W)
=\sum_{U\subseteq W}\Gamma_c(v,\eta,U).
\tag{CAU-ZETA}
$$

第一项命中每个非空 $U$；第二项恰扣掉不包含于 $W$ 的那些行，故第二个等号逐事件成立。两次观察在证明外作整数相减，未把复制孔或减读数添加到上下文。有限布尔格上的 Möbius 反演给出

$$
\Gamma_c(v,\eta,U)
=\sum_{W\subseteq U}(-1)^{|U|-|W|}h_{v,\eta}(W).
\tag{CAU-MOB}
$$

反演框架为 `literature-attested`：G.-C. Rota, “On the foundations of combinatorial theory I. Theory of Möbius functions” (1964)，DOI [10.1007/BF00531932](https://doi.org/10.1007/BF00531932)。本式也可直接核对：代入 (CAU-ZETA) 后，每个 $U'\subseteq U$ 的系数为 $\sum_{U'\subseteq W\subseteq U}(-1)^{|U|-|W|}$，即 $U'=U$ 时为 $1$、否则为 $(1-1)^{|U\setminus U'|}=0$。于是两对象逐格剖面相同；空 $D$ 时两剖面直接为空。$V$ 已由 (CAU-V) 决定，不另设恢复 $V$ 的时间串接探针。端点的必要性直接复用 §20 命题 30：那里全是平衡 $U_t$ 参数，属于本签名，分别区分 $m,M,s$。两方向合并得 (CAU-EQ)。证毕。

这是普通 ZFC 内的完整 iff；一般必要性由隔离与有限反演的任意对象证明承担。附录的小样本逐字节恢复不替代这个证明，也不声称 Lean 已验证。

### 25.5 不可观察的精确范围与正面因果分离

在端点相同的前提下，保持 $\Gamma_c$ 的修改在 $\Sigma_{\rm cau}$ 下不可观察；该限定不能丢掉，因为本签名保留时间复合域。仅谈因果关系修改而固定其他数据时，端点自动相同。

**命题 42（同属性关系差的局部不可见性，repo-derived）。** 固定 $E,\Omega,t,x,\sigma,\rho,A$。若两个合法的**传递严格关系**之对称差只含 $\alpha(e)=\alpha(f)$ 的事件对 $(e,f)$，则每个当前事件的 $U$ 不变，故两表示在 $\Sigma_{\rm cau}$ 下不可区分。

**证明。** 对每个 $e\in\Omega$，改变的当前目标 $f$ 都与 $e$ 同属性；这个属性原已由 $e\preceq e$ 在 $U(e)$ 中，添删这些关系不改属性集。指向 $E\setminus\Omega$ 的关系不直接贡献任何当前目标。假设说的是两份完整传递关系，因而不存在另一个未入差集的闭包变化。剖面及端点相同，用命题 41。证毕。

一个可核查的充分插边条件是：对 $e,f\in\Omega$，插入 $e\prec f$ 前已有 $U(f)\subseteq U(e)$，且插入后取闭包仍满足严格时标。任何新增当前可达对的路径都经过这条新边；它从一个原来可达 $e$ 的当前点 $g$，到一个原来可由 $f$ 达到的当前点。目标属性已在 $U(f)\subseteq U(e)\subseteq U(g)$ 中，所以所有 $U$ 不变。这也允许闭包新增跨属性关系，只要没有新增属性可达性。相反，只知道一条**生成边**的端点同属性，不能推断取闭包后仍不可见。

**反例 D2（同属性生成边可造成正面因果分离，repo-derived）。** $E=\Omega=\{a,b,c,d\}$，位置全 $0$、来源 $l_0$，符号 $+,+,-,-$，时刻 $0,1,2,0$，选择 $\{a\}$。$X$ 只有 $b\prec c$；$Y$ 为 $a\prec b,b\prec c,a\prec c$。两者 $\rho_{\rm src}=(0,\delta_{(0,l_0)})$、$(m,M,s)=(0,2,2)$，但对 $Q=\{(0,-1,l_0)\}$ 有 $q(F_{\downarrow Q}X)=0,q(F_{\downarrow Q}Y)=1$。这些值逐事件计算并由附录 `edge=0,1` 复核，证明 $\Sigma_{\rm cau}$ 严格细化 $\Sigma_{\rm src}\cup\Sigma_{\rm st}$。新增生成边 $a\prec b$ 两端同属性，却在闭包中新增 $a\prec c$ 的跨属性关系，故也反驳“插入同属性生成边并取闭包必不可见”的全称断言。

**反例 D3（单点命中边缘不足，repo-derived）。** 取两个选中正事件 $e_1,e_2$，同属性 $a=(0,+1,l_0)$、时刻 $0$；两个未选负事件，分别有属性 $b=(0,-1,\operatorname{leaf}(1))$、$c=(0,-1,\operatorname{leaf}(2))$、时刻 $1$。取 $E=\Omega$ 为这四点。$X$ 中仅 $e_2$ 指向两个负事件；$Y$ 中 $e_1$ 指向属性 $b$ 的负事件、$e_2$ 指向属性 $c$ 的负事件。对所有单属性 $Q$，读数全同：$Q=\{a\}$ 为 $2$，$\{b\},\{c\}$ 各为 $1$，其余为 $0$；但 $Q=\{b,c\}$ 时分别为 $1,2$（逐点命中计数；附录 `marginals=1,2`）。所以 (CAU-MOB) 需要全部有限属性集合的命中信息，不能只存单点边缘。

### 25.6 B2 的签名边界

B2 两对象在本节的 $\Sigma_{\rm cau}$ 下仍同核。确切地，记 $a_+=(0,+1,l_0),a_-=(0,-1,l_0)$，所有正事件的 $U=\{a_+\}$，所有负事件的 $U=\{a_-\}$；二者剖面都只有 $(a_+,1,\{a_+\})\mapsto2$ 与 $(a_-,0,\{a_-\})\mapsto-2$，端点均为 $(0,1,1)$。由命题 41 得全部本签名上下文观察相同。若将时间纳入 $\alpha_t(e)=(x(e),\sigma(e),\rho(e),t(e))$，同样形式的属性查询用 $Q=\{(0,+1,l_0,1)\}$，便分别命中两正点与仅上层正点，读数为 $2,1$。这些 B2 读数来自所列事件与关系，附录另查有界本签名上下文及时间查询；本节不立时间属性因果核定理。

**反例 D4（去身份但不在 $\Sigma_{\rm cau}$ 的筛选，repo-derived）。** 定义
$J(C,A)=(C,\{e\in A:\exists d\in\Omega_C\ (e\prec d)\})$。该筛选不用事件身份、在重命名下不变，却问是否有**严格**后继。对 B2 两对象，$q(JX)=1,q(JY)=0$（前者只选到 $a$，后者没有严格边；附录 `strict_successor=1,0`）。故“任何去身份签名下 B2 同核”为假；$J$ 不在 $\Sigma_{\rm cau}$ 内，这不反驳命题 41。也不能把 $J$ 当作其已有上下文：若能表达，它就不能分开本签名同核的 B2。

### 25.7 时间属性剖面的历史边界

**反例 D5（时间属性仍不恢复历史，repo-derived）。** 四个选中正点 $a_1,a_2$ 在时刻 $0$，$b_1,b_2$ 在时刻 $1$；四点除时间外全同属性 $(0,+1,l_0)$。一图的严格关系为 $\{a_1\prec b_1,a_2\prec b_2\}$，另一图为 $\{a_1\prec b_1,a_2\prec b_1\}$。各加四个时刻 $0$、位置 $0$、来源 $l_0$ 的孤立未选负点，取 $E=\Omega$ 为全部八点，得到合法平衡表示。以 $\alpha_t$ 代替 $\alpha$ 所算 $\Gamma_t$ 相同：每个下层正点看见时刻 $0,1$ 两个正属性，每个上层正点只看见自己的时刻 $1$ 正属性，负点均只看见自身负属性。上层入度多重集却为 $\{1,1\}$ 与 $\{2,0\}$（由所列两条边计算；附录复核），任何保时间的历史同构都须保存该多重集，故历史不同构。此例只划定剖面遗忘重数与入射关联的边界，不新增关于时间属性签名的核定理。

<a id="pr3-comparisons"></a>

## 26. PR3 增补 K：与既有理论的对照

本节不新增数学，不作综述。表中外部文献的对象及结论标 `literature-attested`，与本卷的对应判断标 `repo-derived`；取回与核读强度在 §28 披露。对应只比较操作、观察和成立条件，不把名称相似当作定理。

| 既有对象或定理 | 确切对应 | 确切不对应 | 来源与标签 |
| --- | --- | --- | --- |
| Conway，*On Numbers and Games*（1976） | 生日记录递归构造层级，对应本卷的构造深度；数的最简代表与定义 8 的固定代表，都须区别于一个给定构造；游戏在“对一切 $X$”的加法测试中相等，对应定义 16 用测试上下文定义观察等价的做法 | 生日不是档案时刻 $t$；本卷固定截面不承担 Conway 的最简性定理；游戏采用加法测试，本卷量化全部指定的一孔上下文，包括筛选、乘法和部分域失败，不能直接搬用游戏相等判据 | [第二版 DOI 10.1201/9781439864159](https://doi.org/10.1201/9781439864159)，**不是 1976 原版 DOI**。外部对象 `literature-attested`；局部对照 `repo-derived` |
| Green–Ives–Tannen，*Reconcilable Differences*（2009） | $\mathbb Z$-关系以整数作元组重数，差允许负重数和消去；本卷在总背景平衡下得到 $q(NX)=-q(X)$，可在读数层比较有符号消去 | $N$ 是固定背景中的一元补选择，不等于二元关系差；该整数关系语义不提供本卷保留有序 pair 的非结合来源乘法 | DOI [10.1145/1514894.1514920](https://doi.org/10.1145/1514894.1514920)；整数差语义另见下列 TaPP 文 §4。文献陈述 `literature-attested`；对照 `repo-derived` |
| Geerts–Poggi，*On Database Query Languages for K-relations*（2010） | 以 $K$-关系考察查询语言及差运算扩展，要求说明注释域和查询操作；本卷也须先固定观察签名才能谈下降 | 本卷未建立同一查询语言或公理组，来源 pair 乘法也未满足交换半环契约，不能直接调用其查询等价结论 | DOI [10.1016/j.jal.2009.09.001](https://doi.org/10.1016/j.jal.2009.09.001)。文献陈述 `literature-attested`；对照 `repo-derived` |
| Amsterdamer–Deutch–Tannen，*On the Limitations of Provenance for Queries with Difference*（TaPP 2011） | 该文问能否**对每个注释交换半环**扩充关系差，使 Figure 1/2 的 A1–A13 同时成立；结论是否定这个普适要求。A1–A12 的 monus 扩展仍可在某些半环上违反 A13；§3 命题 3.4／推论 3.5 给出具体失败范围。本卷同样须按已声明的运算、公理及量词结算 | Figure 2 的 A10 是 $0-a=0$；§4 明说 $\mathbb Z$ 的差语义不满足 A10、A11。本卷 $N_C$ 是固定背景中的一元补选择，$u=0$ 只导出 $q(NX)=-q(X)$，没有建立 monus 或该文的二元差公理组。**两者是不同的语义任务**；本卷不构成克服、规避、反驳或满足该结果的实例 | [arXiv:1105.2255](https://arxiv.org/abs/1105.2255)，已核读全文及 Figure 2、§3–4。文献断言 `literature-attested`；不同语义任务的对照判断 `repo-derived` |
| Amsterdamer–Deutch–Tannen，*Provenance for Aggregate Queries*（PODS 2011） | 将来源标注扩展至元组内的聚合值，并通过聚合表达差；与本卷“必须说明读数如何沿操作传播”的要求有局部对应 | 这是聚合查询语义，不是上一行的差运算不可能性论文；本卷没有建立其聚合值注释域、嵌套聚合与查询语言契约 | [arXiv:1101.1110](https://arxiv.org/abs/1101.1110)，与 TaPP 文分列。文献陈述 `literature-attested`；对照 `repo-derived` |
| Köhler–Ludäscher–Zinn，*First-Order Provenance Games*（2013） | 用查询求值游戏解释来源，赢／输结构参与判定；与本卷用有结构的来源和明确观察解释读数的方向相接 | 本卷来源树不提供求值游戏、合法策略、赢输判据或 why-not 契约；一个 pair 结点不能替代一场求值游戏 | DOI [10.1007/978-3-642-41660-6_20](https://doi.org/10.1007/978-3-642-41660-6_20)；[arXiv:1309.2655](https://arxiv.org/abs/1309.2655)。文献陈述 `literature-attested`；对照 `repo-derived` |
| Winskel，*Event Structures*（1987） | 用事件出现及因果依赖描述过程，对应本卷 $(E,\prec)$ 的因果层 | 本卷没有冲突关系，允许任意选择 $A\subseteq\Omega$；这些选择不冒充事件结构的合法配置，§1 已给补集不保持向下闭的例子 | DOI [10.1007/3-540-17906-2_31](https://doi.org/10.1007/3-540-17906-2_31)。文献陈述 `literature-attested`；对照 `repo-derived` |
| Bombelli–Lee–Meyer–Sorkin，*Space-time as a Causal Set*（1987） | 因果偏序承载离散事件的先后结构，对应本卷 $(E,\prec,t)$ 中的有序事件层；本卷另给兼容该序的整数时标 | 仅有有限偏序和时标不提供连续几何重建、Lorentz 体积解释或动力学，不能把任意本卷情境认作已验证的物理时空 | DOI [10.1103/PhysRevLett.59.521](https://doi.org/10.1103/PhysRevLett.59.521)。文献陈述 `literature-attested`；对照 `repo-derived` |
| Bennett，*Logical Reversibility of Computation*（1973） | 可逆计算要求能够反演计算状态转移；本卷档案保留使部分输入事件仍可追索，是可比较的保存信息问题 | 留有旧事件不足以证明反演：§3 的 $X\boxtimes0_\varnothing$ 遗忘 $A_X$，不同旧选择产生相同输出。因此“留历史所以可逆”越界 | DOI [10.1147/rd.176.0525](https://doi.org/10.1147/rd.176.0525)。文献陈述 `literature-attested`；本卷失败见证与对照 `repo-derived` |
| Baez–Dolan，*Categorification*；Baez，*The Mysteries of Counting* | 结构到数值的压缩，以及在具备相应结构时推广计数，可与本卷从丰富表示取数值商、有符号读数的形式相比较 | 范畴化还需态射、函子和相干条件；Euler 示性数需相应拓扑或分次／链复形契约。本卷没有建立这些契约，不宣称已范畴化，也不把任意 $q$ 称为 Euler 示性数 | [arXiv:math/9802029](https://arxiv.org/abs/math/9802029)；Baez [讲座稳定入口](https://math.ucr.edu/home/baez/counting/)。文献陈述 `literature-attested`；对照 `repo-derived` |

本节全部对应为局部对应，不构成“这些理论共同导出本卷”的叙事。

<a id="pr3-quantum-boundaries"></a>

## 27. PR3 增补 L：与量子力学的差距

本节不新增数学；沿 §13 的反驳表，只结算“**这些结论未由本卷当前定义推出**”，不写成任何扩展都不可能。外部构造标 `literature-attested`，本卷欠缺何种结构的判断标 `repo-derived`。本卷的整数读数、来源树和共同世界域均未被定义为物理态或实验概率。

| 断言 | 精确替代 | 来源 |
| --- | --- | --- |
| “本算术可解释双缝” | 本卷没有振幅到概率的规则。普通复数算术中 $\lvert1+1\rvert^2=4\ne\lvert1\rvert^2+\lvert1\rvert^2=2$，表明相干相加与分开平方不同；把该交叉项解释为实验概率还需额外规则及归一化。本卷历史枚举也不等于满足一致历史或退相干条件的概率模型 | Feynman（1948），DOI [10.1103/RevModPhys.20.367](https://doi.org/10.1103/RevModPhys.20.367)，路径振幅；Griffiths（1984），DOI [10.1007/BF01015734](https://doi.org/10.1007/BF01015734)，一致历史条件；Gell-Mann–Hartle（1990），[2018 重发入口 arXiv:1803.04605](https://arxiv.org/abs/1803.04605)，退相干历史；Sorkin（1994），[arXiv:gr-qc/9401003](https://arxiv.org/abs/gr-qc/9401003)，量子测度加性层级。外部内容 `literature-attested`；缺项判断与所列算术核算 `repo-derived` |
| “反着即对偶” | 须逐一辨型：$N_C:\mathcal P(\Omega_C)\to\mathcal P(\Omega_C)$ 是固定背景补集；形式时间反向同时反转时标与序，物理时间反演还需指定态与动力学上的作用；有界 Hilbert 算子 $A:H\to K$ 的伴随 $A^*:K\to H$ 由内积定义；范畴对偶 $\mathcal C^{\rm op}$ 反转态射；Fourier 对应把群上的函数送到字符群上的函数。本卷没有将这些构造互相识别的映射与保律条件 | §2、§8 的操作类型与本行缺项判断 `repo-derived`；Baez–Dolan [arXiv:math/9802029](https://arxiv.org/abs/math/9802029) 提供范畴结构背景；[Encyclopedia of Mathematics：Pontryagin duality](https://encyclopediaofmath.org/wiki/Pontryagin_duality) 提供局部紧阿贝尔群与字符群的适用条件，`literature-attested` |
| “加复权重即得量子” | 换成复系数不提供态、正概率、测量及复合规则。本卷的一孔上下文等价不等于 Abramsky–Brandenburger 的 contextuality：后者有测量覆盖、覆盖上相容的概率／经验模型，及其全局截面扩张障碍；不能从本卷存在共同世界或有符号读数推出 Bell 型裁决。Litvinov–Maslov 的去量子化有具体代数和极限条件：非负实数经 $u\mapsto h\log u$ 运输运算（零用 $-\infty$），$h>0$，再取 $h\to0^+$ 得 max-plus；它不支持“改系数便得量子”的推断 | Abramsky–Brandenburger（2011），[arXiv:1102.0264](https://arxiv.org/abs/1102.0264)，摘要及 §2 的测量覆盖／分布；Litvinov–Maslov，*Correspondence Principle for Idempotent Calculus and Some Computer Applications*，[arXiv:math/0101021](https://arxiv.org/abs/math/0101021)，§2。文献陈述 `literature-attested`；本卷类型边界 `repo-derived` |
| “离散是差距” | 离散性本身不排除量子构造。Johnston 在离散因果集上对轨迹求和构造粒子传播子，并在所述 Minkowski 撒点条件下与 Klein–Gordon 延迟传播子比较；这不证明本卷已有同一传播子或其极限 | Johnston（2008），*Particle Propagators on Discrete Spacetime*，[arXiv:0806.3083](https://arxiv.org/abs/0806.3083)，`literature-attested`；本卷缺项判断 `repo-derived` |

只保留下列三项局部类比；它们不是量子理论的推导。

| 结构相似项 | 缺失的量子公理或结构 |
| --- | --- |
| 历史归并的组合结构：多个构造参与一个读数或来源表达 | 缺少振幅及概率解释，也没有一致历史／退相干条件；来源同上表 Feynman、Griffiths、Gell-Mann–Hartle、Sorkin，外部框架 `literature-attested`，本卷类比 `repo-derived` |
| $q$ 沿 $\boxplus$ 及有定义的 $\triangleright$ 相加，形式上类似可加作用量 | 缺少物理作用量的定义、单位与 $\hbar$，也没有由作用量到振幅的规则；§3 命题 2 与上述 Feynman 文给出比较两端，本卷类比 `repo-derived` |
| **仅对 §19 的 $\mathbb Z[\mathbb Z^3]$**，有限系数可经群字符作 Fourier 对应，$\widehat{\mathbb Z^3}\cong\mathbb T^3$（此处 $\mathbb T=\mathbb R/\mathbb Z$，不同于来源树集合 $T$） | 这是阿贝尔群卷积的标准字符对应，缺少 Born 规则与测量理论；不移植到 §24 非结合的来源 pair 代数。上述 Pontryagin duality 稳定入口支持群对偶框架（`literature-attested`）；与本卷空间代数的绑定及边界为 `repo-derived` |

表中的缺项来自对本卷现有定义域与运算的核对，未作物理实验；双缝、Born 规则、Bell 实验与量子动力学在本批均为“未测”，本批也没有提供这些实验或物理公理的实现。
