### 进一步的主线缩减：只需覆盖能进入正交三元组的根

令 `U(T)` 是全部共同无偏射线。定义：

```math
U_\triangle(T)=\{v\in U(T):\exists w,z\in U(T),\ (v,w,z)\text{ pairwise orthogonal}\}.
```

完整 completion 中的每个向量都属于 `U_triangle(T)`。因此，除了全局覆盖 `U(T)` 之外，还有一个更窄的可接受覆盖目标：

```math
\boxed{U_\triangle(T)\subseteq C_{known}.}
```

该命题成立就足以证明 completion 唯一，不需要枚举不能进入任何正交三角形的孤立 roots 或二分 components。当前的六十射线诱导图为这个目标提供了严格的正控制，但尚未证明盒外的 triangle-bearing roots 被覆盖。

在 projector coordinates 中，三元组证书只需三个 Hermitian rank-one projectors `P0,P1,P2`，两两乘积为零、分别对两个固定基无偏。一个更弱的待证 inequality 是：

```math
\sum_{r=0}^2\sum_{k=0}^2\operatorname{Tr}(E_kP_r)^2\ge2.
```

若它对所有实际共同无偏正交三元组成立，则将任意六元 completion 分成两组三元组，得到总 collision 至少四，亦即 `alpha_S(C)>=1`。随后第 31 节排除两个 MUB completions 的预算等号。此三元组 inequality 当前仅是明确的下一项证书目标，不是本轮已经证明的下界。

主线继续避免逐行下界和已被反例否定的全局到逐模蕴含。真正下一步是：精确全局 root cover、triangle-bearing locus 的排除证书，或实际三元组/完整基的 projector-affinity certificate。

## 37. 2026-09-07：补入完整候选的幅度输运

本节补入此前已完成但未写回的数学内容。真源仍归 `HadamardResidualBarrier.lean` 所有；原有精确根和列扰动定理保持不变。新公开定理为 `near_unit_entry_families_admit_controlled_phase_replacement`，其配套说明追加在原 Scribe 中。实际交付提交为 `570c05455f7c55bc2350af113de407672f0cfb28`。

设任意索引族 `z_a in C^6` 满足：

```math
0\le\rho\le1/4,\qquad
\big||z_{a,i}|^2-1\big|\le\rho,\qquad
\big||(H^\dagger z_a)_j|^2-6\big|\le\rho.
```

若 `|H_ij|<=M` 且 `M>=0`，存在同一个单位元素族 `u_a` 满足：

```math
|u_{a,i}|=1,\qquad |z_{a,i}-u_{a,i}|\le\rho,
```

```math
\big||(H^\dagger u_a)_j|^2-6\big|
\le\rho+6M\rho(5+6M\rho).
```

令 `p(x,y)=(1/6) sum_i conjugate(x_i)y_i`，同一替换还满足：

```math
|p(u_a,u_b)-p(z_a,z_b)|\le3\rho,\qquad
\big||p(u_a,u_b)|^2-|p(z_a,z_b)|^2\big|\le15\rho.
```

原向量不必单位化，所以原始 `p(z_a,z_b)` 只是固定目标缩放下的代数量，不能预先解释成归一化量子态的 Born 概率。所有结论使用同一个构造族，不允许为不同约束分别选择相位替代。

### 37.1 证明与既有真源的连接

对非零坐标取 `u=z/|z|`，对零坐标取 `u=1`。由平方差恒等式：

```math
|z-u|=\big||z|-1\big|\le\big||z|^2-1\big|.
```

测量幅度改变不超过 `6M rho`，所以已有 private `squared_modulus_residual_transfer` 给出测量界。小坐标误差保证 `|z_ai|<=2`。再使用完整乘积差：

```math
\overline{u_{a,i}}u_{b,i}-\overline{z_{a,i}}z_{b,i}
=\overline{u_{a,i}-z_{a,i}}z_{b,i}
 +\overline{u_{a,i}}(u_{b,i}-z_{b,i}),
```

得到逐项 `3rho`，从而得到 `p` 的误差。最后 `|p(u_a,u_b)|<=1`、`|p(z_a,z_b)|<=4` 给出 squared-overlap 界 `15rho`。这些常数没有被宣称为最优；经典相位归一化本身也不是新的数学发现。

### 37.2 全幅度误差间隙的条件消费者

既有圆弧/单点扩展排除使用：

```math
\tau=1/256,\quad\epsilon=1/128,\quad\sigma=3/4096.
```

在 `max_ij |H_ij-(H0)_ij|<=1/8192` 的矩阵球中，`|H_ij|<=8193/8192`，列 l1 距离至多 `sigma`。取 `rho=1/8192`，有精确预算：

```math
\rho+6M\rho(5+6M\rho)
=\frac{4261715001353}{1125899906842624}<\frac1{256},
\qquad4\rho<\tau,\quad16\rho<\tau.
```

对任意复矩阵 U,V，定义：

```math
A(W)=\sum_{ij}(|W_{ij}|^2-1)^2,
```

```math
D_H(W)=\sum_{aj}(|(H^\dagger W)_{aj}|^2-6)^2,\qquad
O(W)=\frac1{36}\sum_{i<j}|(W^\dagger W)_{ij}|^2,
```

```math
B(U,V)=\sum_{ij}\left(\frac{|(U^\dagger V)_{ij}|^2}{36}-\frac16\right)^2.
```

若既有完整残差覆盖、圆弧包含与强不可扩展实例成立，则：

```math
A(U)+A(V)+D_H(U)+D_H(V)+O(U)+O(V)+B(U,V)\ge2^{-26}.
```

反设总误差小于 `rho^2`，逐项非负性给出各幅度误差、测量误差和 cross squared-overlap 偏差小于 rho，内部缩放内积模长也小于 rho。对十二个向量同时作相位替换，就进入原等模证书的预算，矛盾。

本节扩大候选 U,V 的量词域，没有扩大 H 的已排除半径。这个全幅度下界也不被描述为对原等模 `2^-16` 常数的数值改进。最终数值实例依赖外部完整覆盖，尚未在 Lean 内核实例化。

本次重新执行了 1200 个精确 Gaussian-rational 相位/成对误差实例、280 个近平方模六的测量扰动实例和具体有理预算核对。有限检查不替代普遍 Lean 证明。旧轮次中的较小范围试验、未完成的大阈值覆盖均不在本次作为新成果重复主张。

## 38. 2026-09-07：将强不可扩展性的有限前提化为六十份具体证书

### 38.1 精确定位尚缺的一环

已有 `RootTubeStrongUnextendibility.six_frame_has_cross_error_to_any_covered_point` 接受两个实际 overlap 的保守关系 O 和 B，以及一个全称的 `hNoPartner` 前提：任何 O 中的六元 clique 都没有与全体顶点保持 B 关系的共同伴随标签。

此前的计算程序通过枚举 2403 个第一组六元 clique 检查这个前提。本节交换两个全称量词。对每个可能的额外向量标签 l，令：

```math
V_l=\{i:B(i,l)\}.
```

只需为 `O[V_l]` 提供五着色。假如六元 clique 的全部标签都属于 `V_l`，着色就给出 `Fin 6` 到 `Fin 5` 的单射。由此得到 hNoPartner。

这个量词重排和着色原理是标准组合论。实质性新增量是为当前经过几何计算得到的全部六十个邻域提供具体整数证书，并把有限计算从公共定理的假设中移除。

### 38.2 数据与几何来源

固定种子、六十个 signed-Cayley 中心和标号与第 35、36 节一致。中心取自已经提交的 `docs/develop/certificates/real_x_two_relation/centers.txt`。普通管半径为 `1/16`，标签 5 使用原强不可扩展程序已处理的 `1/32` 细管。阈值为：

```math
\tau=1/256,\quad\eta=\tau^2,\quad\mu=3/4.
```

本次使用另一份同作者实现，重新计算全部 1830 对圆弧整管包含和 60 对标签 5 的不等半径包含。所有圆弧端点、支持函数对偶检验、平方根上界和取整均采用有理数。它不是独立作者审稿，也不替代圆弧包含的分析证明。

重算所得关系为：

```text
O: 372 undirected edges
B before refinement: 875 undirected edges
B after refinement: 859 undirected edges
removed B-neighbors of label 5:
14,15,19,23,24,27,31,32,42,45,46,48,49,52,56,59
```

O 仍保留未细化的大管上界，故允许比实际更多的边。B 的十六条删除必须由已有残差保持的标签 5 局部覆盖以及不等半径的真实包含支持。本次没有重跑该局部覆盖或数百万盒的完整全域遍历，不把旧报告的成功标记变成新执行。

### 38.3 一个具体 Lean 消费者

新增：

```text
D5/S3/Quantum/Tomography/RealXFinitePartnerCertificate.lean
Blueprint/D5/S3/Quantum/Tomography/RealXFinitePartnerCertificate.scribe.cs
```

O、B 各由六十个自然数 bit masks 定义。六十行颜色用 base-five 自然数无损存储；颜色解码是 `(code / 5^i) % 5`。没有采样状态、未列出顶点或外部搜索结果进入证明假设。

两个公开关系是 `realXOrthogonalityCandidate` 和 `realXUnbiasednessCandidate`。唯一公共结论是：

```text
realX_six_frame_has_cross_error_to_any_covered_point
```

内部 `partner_colors_separate` 使用 `decide +kernel` 对字面数据证明：

```math
\forall l,i,j,\quad
B(i,l)\land B(j,l)\land O(i,j)
\Longrightarrow\operatorname{color}_l(i)\ne\operatorname{color}_l(j).
```

该结果供应原 owner 所需的 hNoPartner。新的公共 theorem 不再要求用户提交颜色正确性、clique 枚举完整性或有限无伴随命题。

实际残差管覆盖、同管 overlap 下界、两个有限关系对真实 trace overlap 的一侧包含仍然显式保留。对于满足这些前提的实际六元组 C 和实际被覆盖矩阵 Q，结论是：

```math
\exists i,\quad
\left|\Re\operatorname{Tr}(C_iQ)-\frac16\right|\ge\frac1{256}.
```

实际用途是 normalized rank-one outer products。这是具体有限证书的实例化，没有重新定义矩阵、Hadamard、语境、interval 或 frame potential。

### 38.4 六十张二次 Boolean Positivstellensatz 证书

固定 l，把五个独立颜色类记为 `I_0,...,I_4`，为每个 `i in V_l` 引入 Boolean 选择变量 x_i。一个六元 clique 必须满足：

```math
x_i^2-x_i=0,\qquad
x_ix_j=0\quad(i\ne j\text{ 且 }\neg O(i,j)),\qquad
\sum_{i\in V_l}x_i-6=0.
```

令 `S_t=sum_(i in I_t) x_i`。有精确多项式恒等式：

```math
\boxed{
-1=\sum_{t=0}^{4}(1-S_t)^2
-\sum_{i\in V_l}(x_i^2-x_i)
-2\sum_{t=0}^{4}\sum_{i<j,\ i,j\in I_t}x_ix_j
+\left(\sum_{i\in V_l}x_i-6\right).
}
```

同颜色顶点不相邻，故每个二次项都有真实 nonedge 方程支持。该证书的最大次数为二，所有系数都是整数。它针对已通过连续几何包围的 Boolean 选择问题，不能据此声称普通 vector-coordinate degree-two SoS 已解决六维 MUB。

本次对六十份恒等式逐单项式核验，残差恒为常数 -1。合计涉及 1718 个邻域顶点出现和 4920 个 nonedge 乘子。这个计数只是具体证书的规模，没有被当作数学新颖性或准入分数。

### 38.5 有限审计与下一步不能继续压缩的部分

从实际 Lean 字面量重新读入并验证的结果：

```text
216000 ordered label/color cases checked
60 quadratic polynomial refutations checked coefficientwise
2403 first six-cliques in an independent diagnostic enumeration
0 first six-cliques with a common partner
```

活动边的颜色碰撞、截断行表、擅自添加邻域边三类损坏都被拒绝。打包为十进制自然数时曾有一个未挂到分支的 blob 出现数字转录错误，Git blob 与本地已核验字节的对照检出了它；修正后的 blob 才进入实际研究提交。

进一步用独立 maximal-clique 路径搜索，并逐边复核输出见证，发现：

```text
41 neighborhoods contain an explicit K5
18 have maximum clique size 4 in the diagnostic search
1 has maximum clique size 3 in the diagnostic search
```

每个邻域都有五着色，故其中 41 个的 chromatic number 确为五。这个有限上界图不能仅通过把五色证书改写成四色证书而得到更强排除。其余诊断中的最大值不作为 Lean theorem 导入。K5 是保守图中的候选，不代表五个真实向量可被同时实现。

这标定了后续有意义的方向：针对这些 K5 候选检查共享变量的联合测量/正交/无偏方程，或用更紧的实际管几何删去其中至少一条边；不要继续只优化同一张图的颜色记账。

### 38.6 文献和跨作者复用

Matolcsi、Matszangosz、Varga、Weiner，*Triplets of mutually unbiased bases*，Journal of Algebraic Combinatorics 63, 26 (2026)，DOI `10.1007/s10801-026-01506-x`，Conjecture 3 仍以整个 Szollosi X 家族为目标。本节既没有扩大已认证矩阵球，也没有完成全家族覆盖。

Gocht、McBride、McCreesh、Nordstrom、Prosser、Trimble，*Certifying Solvers for Clique and Maximum Common (Connected) Subgraph Problems*，CP 2020, pp.338-357，DOI `10.1007/978-3-030-58475-7_20`，说明 clique 求解可以输出由 pseudo-Boolean/cutting-planes 检查的证书。本节采用已有的“发现与验证分离”思想，并针对实际六十标签图给出可读的五色和二次恒等式。没有把着色证明或 proof logging 声称为新算法。2026 论文的猜想陈述及这篇方法文献的作者版摘要在本轮重新核对。

跨作者审查包含 loning 研究线 #5892 的实际 `CoefficientDrivenJacobiCharacteristicPolynomial` 公共 theorem：其 hSymmetric 显式保留，未被伪装成由其他假设推得。这里相应地保留真实区间到矩阵包含和全覆盖前提，只消去确实已经实例化的有限 no-partner 前提。

还读取了 AlyciaBHZ #5897 的 `RadiusFourCertificates.lean`：具体整数表先由内核归约验证，再交给既有一般消费者，几何闭包与路径计数输运分开。这里沿用同样的依赖方向，复用 RootTubeStrongUnextendibility 而非再抄一遍相同的图论消费者。两条外部研究线的定理都没有被当作 MUB 的数学假设。

### 38.7 准确的完成边界

本次实际完成的是先前幅度 Lean/Scribe 的远端交付、六十标签图及颜色的精确重建、二次 refutation 的逐系数核验，以及将有限 hNoPartner 消去的 Lean/Scribe 源码。没有运行 Lean/lake、Scribe emitter 或 transitive axiom report，所以 `decide +kernel` 仍是待实际 elaboration 的证明脚本，不是已执行的 kernel verdict。

完整解析覆盖和区间表达式可靠性仍需内核桥接；新参数区间的覆盖也仍未完成。颜色标签没有被证明与全部真实共同无偏投影一一对应；只能在显式的解析覆盖与 overlap 包含前提下使用。
