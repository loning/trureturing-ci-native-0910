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
