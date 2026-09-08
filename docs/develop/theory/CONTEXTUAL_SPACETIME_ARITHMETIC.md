# ZFC兼容算术

## 情境时空算术：保留档案的表示与精确算术投影

本文构造一种两层算术。丰富层中的对象是带时间、位置、因果偏序和来源的有限事件档案，以及这次参与计数的区域和选择；数值层只读取所选正事件数减去负事件数。丰富层可以区别“同样等于一、却发生在不同地点或来自不同来源”的对象。把数值相同的对象取商以后，指定的加、乘、负运算恰好给出整数算术；分数与全部有理 Cauchy 序列再给出有理数与实数。

“道”在这里是一个有类型的情境整体：先说明在哪个档案和区域内谈可能选择，才谈某个选择的相对补集。这是数学建模的名称，不是关于道、物理宇宙或哲学传统的同一性定理。补集投影为算术负号需要背景总电荷为零；这个条件既不能省略，也不是自然界的先验守恒律。

产地与证明状态：本稿由 `consensus-rnd:sshx` 流程的一个隔离 codex-cli 实施席按调用方批准的综合方案编写。实际 GPT PRO 思考输入及本稿采取的修正见第 12 节。本文给出 ZFC 内的普通数学证明及附录中的有限精确核验；**本稿没有新增 Lean 证明，不能称为 kernel-verified**。最终独立评审、仓库准入与 PR 生命周期由调用方接续，本文不预报其结果。

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
print("ALL_FINITE_CHECKS_PASSED")
```

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
