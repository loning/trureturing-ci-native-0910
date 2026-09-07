参考：CCM，Zeta Spectral Triples，`https://arxiv.org/html/2511.22755v1`，§§2.2、4.3（4.4 与 4.7）、5、8；Suzuki，`https://arxiv.org/abs/2606.09096`。本轮可读取的主记录及 CCM 正文为上述版本，Suzuki v2 的 HTML 获取失败，未据此断言其改动或不存在新版。

---

# 2026-09-07 增补：有限窗口 Gamma 对角的正项级数与全频率边界修正

本节继续 PR 6029。先回读 `99b3e1ca03e88f42a9b7c6ccadecc545e8c64a97`，确认上一节 Lean、Scribe 与本卷分别为 blob `13095f4742a370f37801a747de80f9e85d766d34`、`468bfe86329d8bb537dfd7e15cb73a385b53e96e`、`82911f81d26aa33e6bd567971a9cc541f931a003`，与实际交付包一致。本轮在原 `WeilDiagonalGammaRegularization` 内增补证明，原 `WeilBoundaryKernelIntegral` 只公开一个复用既有私有证明的几何核伴随。没有新建算子、理论卷或重复证明 Fourier 完备性。

## A. 原积分的显式正项展开

沿用实际卷积正则化定义，令 L>0、n∈Z、w=2πn/L，记
\[
E_L(n)=\int_0^L R_{L,0}(t)dt-\int_0^L R_{L,n}(t)dt.
\]
上一节已证明它等于 2∫ρ(t)(1−t/L)(1−cos(wt))dt。本轮令 a_j=2j+1/2，并定义可有限求值的项
\[
g_j(w)=\frac{2w^2}{a_j(a_j^2+w^2)},\qquad
b_j(L,w)=\frac{2w^2(3a_j^2+w^2)(1-e^{-a_jL})}{L a_j^2(a_j^2+w^2)^2},\qquad
T_j=g_j-b_j.
\]
`diagonalGammaSeriesTerm` 给 T_j 命名。它只含四则运算、平方与指数，未用一个无限积分或未求值的特殊函数定义有限项；它仍是 Lean 实数表达式，并非已验证的有理超越函数求值器。

`diagonal_gamma_hasSum` 证明每项非负且
\[
\boxed{E_L(n)=\sum_{j=0}^{\infty}T_j(L,n).}
\]
证明先实际微分三角权重的指数余弦原函数，得到
\[
\int_0^L e^{-at}(1-t/L)\cos(wt)dt
=\frac{a}{a^2+w^2}-\frac{(a^2-w^2)(1-e^{-aL})}{L(a^2+w^2)^2}.
\]
该简式保留整数频率条件 wL=2πn。再将零频率与频率 w 相减，得到 T_j 的实际积分表示及其非负性。指数端点项和三角窗均未丢弃。

随后直接复用原几何核展开，以上一节已证明可积的非负能量被积函数支配所有有限部分和，使用标准支配收敛。级数的可求和性另由下述正项尾界建立。没有独立输入期望的积分等式、最终级数收敛或待证尾半径。

## B. 全部遗漏项的显式预算

每个项满足 0≤T_j≤g_j≤2w²/a_j³。对 a>1，正望远镜差给出
\[
\frac2{a^3}\le\frac1{2(a-1)^2}-\frac1{2(a+1)^2}.
\]
保留 j=0,...,K 共 K+1 项后，`diagonal_gamma_series_error` 证明
\[
\boxed{0\le E_L(n)-\sum_{j=0}^{K}T_j\le\frac{2w^2}{(4K+3)^2}.}
\]
K=0、n=0 与两种频率符号均包括在内。此处是对角能量本身的求值误差，速率为 K⁻²；它不能与外部残差平方尾的 M⁻³ 速率混用。物理窗口 L、残差 Fourier 截断 M 和内部 Gamma 求值指标 K 仍为不同参数。

`diagonal_gamma_finite_enclosure` 进一步消费有限项的有理球 |T_j-c_j|≤r_j，以及有理 F≥|w|，得到完全有理的两端
\[
\boxed{\sum_{j=0}^{K}(c_j-r_j)\le E_L(n)\le
\sum_{j=0}^{K}(c_j+r_j)+\frac{2F^2}{(4K+3)^2}.}
\]
有限球必须覆盖 L、π、指数及四则运算的实际误差。这个消费者将它们传递到原无限积分，不认证那些基本函数的实现。

## C. 对所有频率统一的窗口修正

本轮实际读取 #5602 新 HEAD `5b1c54e84706acdca64e2ec042b51a5d52c5fcea` 的 `WeilGammaScaleModulus`。它使用原 Gamma 因子的正 resolvent 部分和 1+∑g_j，证明有限高频下界并用于尺度变化控制。本节的 g_j 与其表达式完全一致，但有限窗口对角还有 b_j，故不可将二者直接相等。

有理恒等式
\[
\frac94-\frac{2w^2(3a^2+w^2)}{(a^2+w^2)^2}
=\frac{(w^2-3a^2)^2}{4(a^2+w^2)^2}\ge0
\]
和 0≤1−e^{-aL}≤1 给出 b_j≤9/(4La_j²)。同时一个独立正望远镜估计证明所有有限前缀 ∑_{j=0}^{K}a_j⁻²≤13/3。因此
\[
\boxed{\sum_{j=0}^{K}b_j\le\frac{39}{4L}}
\]
对整数 n 和截断 K 统一成立。`diagonal_gamma_resolvent_window_bounds` 最终给出
\[
\boxed{G_K(w)-\frac{39}{4L}\le E_L(n)\le G_K(w)+\frac{2w^2}{(4K+3)^2},\quad G_K=\sum_{j=0}^{K}g_j.}
\]
这不是基于名称匹配的接口包装：窗口修正被具体计算，并从其实际标量式推导出不随频率增长的界。

与 #5602 的已读取高频部分和定理结合，可在纸面直接得到：当 2(K+1)≤|w| 时，E_L(n)≥H_{K+1}/2−39/(4L)。H 为谐和数。该跨分支高频推论本轮未新增 Lean 声明，也没有把对方未合并模块复制进本分支。它提示固定 L 下的对角高频增长可以由真实正项估计控制；任意叠加态还含混合项，不能据此直接推出完整 Weil 补空间强制性。

## D. 同一模型中的公共标量与谱比较

对同一窗口，完整 Archimedean 对角的公共常数在相对零模态值中消去。若将一个已识别的同域算子 A 改为 A+aI，并将同一候选的 Rayleigh 中心 μ 改为 μ+a，则
\[
((A+aI)-(\mu+a)I)v=(A-\mu I)v.
\]
这条纸面恒等式说明，相对对角数据可以服务于居中的残差比较，而无需在每次求差时分别计算公共基线。它未代替绝对本征值认证所需的常数，也未证明当前系数矩阵已经是规范 Friedrichs 算子的完整作用。原点正则化、真实混合项、算子域与共同坐标识别仍保留在各自的证明任务中。

## E. 检索、复用与实际检查

除 #5602 新增尺度模块外，本轮检索了非 AlyciaBHZ 的近期谱／对角 PR，并实际读取 `MasslessTangentConeLimit.lean` 前 105 行（blob `1b1bc045341a1b0f7367d1c9e273c6b8a2d94a33`）。其正项塔、和积分比较与有限 Fourier 带的声明帮助核对“标量渐近”和“完整算子结论”的区别，未被当成本节的 Weil 域证明。指定 v4.3 规范已读取；没有运行内生信息分析或由声明数推断准入。几何核恒等式继续由原 `WeilBoundaryKernelIntegral` 所有，新 `gamma_exponential_kernel_hasSum` 只是公开该既有证明的伴随。其余接口使用 Mathlib 钉版 `db584cd6d46c92f209a44c0f1c829460d327499d`。

本轮执行四个 Sympy 恒等式、1301 个精确有理标量／望远镜检查，以及 65 位非定向诊断：49 个实际正能量积分、147 个有限项积分、各 245 个完整尾包围和窗口修正包围、6272 个项符号检查。最大项积分差约 5.935×10⁻⁶⁶。这些有限诊断不构成 Lean 证明或真实本征模态距离。

另用 mpmath 1.3.0 的 iv 在 80、100 位分别求值 L=log 3、n=1 的 4096 个有限项。输入只用精确整数／有理数；二进区间端点被精确读成 Fraction，再向外转成有理中心和半径。两次给出相同的外包区间：
\[
\boxed{1.6928293107\le E_{\log3}(1)\le1.6928295545.}
\]
对应 K=4095，全解析遗漏尾预算约 2.43733×10⁻⁷。结果依赖 iv 基本运算的包含语义；官方文档将该支持标为 experimental，故这里如实记录为外部区间运算检查，未据此宣称有限球已获得 Lean 证明、独立验证器复核或新谱认证。此前直接求积的约 1.6928295543939 位于该区间内，但它不参与区间构造，也不被当作证明输入。

本轮修改两个已有 Lean 与对应两个 Scribe，在本卷追加本节。一个有限项定义、四个对角声明和一个几何核公开伴随均有 FromLean 条目。先前公开声明和证明正文保持不变。Lean/lake 未安装，未运行 elaboration、内核公理闭包或 Scribe 发射；源码为完成数学与接口审查后的候选证明，没有独立证明审稿人。未重跑 #5602 的完整谱验证器，未宣称全尺度 prolate 逼近、实际新谱隙、Xi 极限或经典公式的优先权。

参考：CCM，《Zeta Spectral Triples》，`https://arxiv.org/html/2511.22755v1`，§§4.3、8；Suzuki，`https://arxiv.org/abs/2606.09096`，本轮返回的主记录显示 v1；mpmath 1.3.0，`https://mpmath.org/doc/current/contexts.html`，Arbitrary-precision interval arithmetic；#5602 `WeilGammaScaleModulus.lean`，blob `37cdd818e426159e6211491306681a7f4f686a08`。
