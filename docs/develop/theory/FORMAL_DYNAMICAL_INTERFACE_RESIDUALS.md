
源码为数学与依赖接口审查后的候选证明。未运行 Lean elaboration、公理闭包或 Scribe 发射，也未重新认证实际 Weil 内区残差、谱间隙或全尺度极限。正支撑的读回与全系数范数公式在本节作纸面解释并作精确有限诊断，未额外作为本模块公开 Lean 定理提交。投影和奇偶抵消均为标准数学，本节的增量是把真实下游使用的三个约束由可执行构造同时保证，并将所得零矩用于完整尾界，未主张数学优先权。

参考：CCM `https://arxiv.org/html/2511.22755v1` §8；Suzuki `https://arxiv.org/html/2606.09096v1` Theorems 1.1、1.4；Groskin `https://arxiv.org/abs/2607.02828`；#5602 `6533227479d52ab09d39f39baa4f45720c1fc133`；既有奇性真源 blob `d74ec78771c2253d3e7a810df44d39b0bbacae40`；loning 路线 `ContinuousAverage` 读取 blob `24004407503e19a1d5eaa38a69b19856d423c399`。

---

# 2026-09-07 增补：有限系数包围、完整尾流与唯一 Hilbert 实现

本节继续 PR 6029，新增 `WeilResidualHilbertAssembly.lean` 及同名 Scribe。它直接调用上一节的 `even_repaired_residual_certificate`：从有限内区数据及原算术外部系数，先证明完整序列平方可和，再构造唯一 Hilbert 向量并给出其平方范数的上下界。完整算术尾不再停留在一个与 Hilbert 范数尚未连接的求和不等式。规范 Weil 算子与该系数向量的识别仍需单独证明。

## A. 有限与无限描述的三个不同命题

设 b 是完备正交单位基，a_m=〈b_m,x〉。若两个同一 Hilbert 空间的向量全部精确坐标相同，基表示的单射性推出两向量相同。若空间是 L2，这首先是函数的几乎处处等价类相同，不能直接推出每一点的函数值相同。有限投影只在保留的坐标上与 x 相同，其余坐标为零；除非真实尾部本来为零，该投影并不等于 x。

所有有限窗口相互兼容，只能先得到一个逐坐标函数，未必得到目标空间中的对象。例 a_m=1 的全部有限窗口兼容，但完整序列不属于 l2。存在性的平方可和条件与坐标唯一性应分别证明。

逐坐标收敛也不等于范数收敛。单位坐标向量 e_N 在每个固定坐标上最终为零，但范数恒为一。这里缺少的是对整个变化序列的统一尾质量控制。对于正交截断，有限误差与完整尾部满足精确分解
\[
\|x-y^{[M]}\|^2=
\sum_{|m|\le M}|a_m-y_m|^2+\sum_{|m|>M}|a_m|^2.
\]
因此，要用增长窗口得到整体误差趋零，需控制累计的内区误差及全部尾部，而不能只验证每个固定坐标。以上例子与分解解释本节的适用条件；本模块没有另建逐坐标收敛或统一紧性理论。

## B. 从原双侧外部编号构造完整序列

令 `signedWindowSum M f` 等于 f(0)+∑_{j=0}^{M-1}(f(j+1)+f(-j-1))。它精确计数 [-M,M]，零只出现一次。`spliceSignedCoefficients` 在 |m|≤M 时取给定内区 a_m；其余取原双侧尾流的符号和第 |m|−M−1 项。`splice_signed_coordinates` 同时验证内区和每个原 `exteriorMode M j sign` 的逐坐标恒等式，特别保留 M=0 与首个外部模态 ±(M+1)。

`signed_square_mass_assembly` 由配对尾流平方质量的可求和性推出完整整数序列的平方可和性，并证明
\[
\boxed{\sum_{m\in\mathbb Z}|a_m|^2=
|a_0|^2+\sum_{j=1}^{M}(|a_j|^2+|a_{-j}|^2)
+\sum_{j\ge0}(|a_{M+j+1}|^2+|a_{-M-j-1}|^2).}
\]
证明通过非负比较分开两侧，再使用 Mathlib 原有自然数移位和整数拆分求和定理。没有把不可求和时总定义 `tsum` 的默认值当作能量，也没有预先输入完整序列属于 l2。

`hilbert_realization_of_square_tail` 将这个已证明平方可和的函数装入标准 `lp`，直接应用 `HilbertBasis.repr.symm`，得到具有这些全部精确坐标的唯一 x，并把上式转为 ‖x‖²。等距性、坐标解释和单射性均来自钉版 Mathlib，未重证 Fourier、Parseval 或 Riesz–Fischer。

## C. 随求值精度收缩的有理平方质量区间

内区真实系数为 a_m，精确有理中心 z_m=x_m+i y_m，给定已证明的球半径 e_m，使 |a_m−z_m|≤e_m。定义
\[
s_m=x_m^2+y_m^2,\qquad
\delta_m=2(|x_m|+|y_m|)e_m+e_m^2.
\]
反三角不等式及平方差因子分解给出
\[
\bigl||a_m|^2-|z_m|^2\bigr|
=\bigl||a_m|-|z_m|\bigr|(|a_m|+|z_m|)
\le\delta_m.
\]
于是 `retainedMassInterval` 用精确有理数计算
\[
\boxed{L_M=\sum_{|m|\le M}\max(0,s_m-\delta_m),\qquad
U_M=\sum_{|m|\le M}(s_m+\delta_m).}
\]
`retained_mass_interval_sound` 证明 L_M≤∑_{|m|≤M}|a_m|²≤U_M。中心的平方模直接使用 x_m²+y_m²；若只把 max(|x_m|,|y_m|) 与 |x_m|+|y_m| 分别平方，即使 e_m=0 仍可能留下固定宽度。

`retained_mass_interval_exact` 进一步证明全部 e_m=0 时两个端点精确相等。例如单个中心 3+4i，零半径得到 [25,25]；半径 1/10 得到 [2359/100,2641/100]。从定义还可直接推得区间宽度不超过 2∑δ_m。该宽度估计在这里作纸面推论，未另作公开 Lean 声明。增长窗口的累计半径仍须受控，逐项精度提高不足以自动控制和。

## D. 同一个修正试探的完整 Hilbert 平方范数区间

`hilbert_splice_interval` 将上述内区包围与完整尾预算 τ 合并，得到
\[
\boxed{L_M\le\|x\|^2\le U_M+\tau.}
\]
唯一性由全部精确内区系数和全部精确外部流确定。有限球与 τ 本身通常允许许多个向量，不能被读成仅靠一个有限误差表就确定唯一无限对象。

`even_repaired_hilbert_certificate` 直接调用前节的实际偶零迹修正及 D=0 验收器。原 `arithmeticResidualTail` 的两侧可求和性与 τ 上界由该调用得到，未独立假定尾部正确或完整残差已有界。它对同一个返回试探同时保留精确候选正交，并给出其内区数据与原算术尾流的唯一 Hilbert 实现及上述完整区间。

`identified_residual_interval` 是短适配定理：若已证明某个实际残差 R 的全部基系数等于该完整序列，则由原基表示单射性将同一区间转给 R。对 R=g−A(v)，v∈Dom(A) 以及真实系数计算仍需先完成，不能通过构造一个具有预定坐标的向量来代替实际算子作用。

## E. 算子域与结构抵消超出了普通数值精度

取无界对角算子 A e_n=n e_n，则 x_N=e_N/N 在 l2 范数中趋零，但 ‖Ax_N‖=1。因此控制函数误差并不自动控制无界算子残差，需要相应图范数或实际作用估计。已有 #5602 的 Gamma 图误差分析与本节系数拼接是不同连接，不可互相替代。

同样，前节偶系数与实际奇符号相乘后的矩为零，是精确结构结论，独立于符号求值精度。一般试探的小非零矩仍保留 1/m 首项，其平方尾界与精确零矩的立方界不同。本节保留同一已修正试探，未把近零改写成零，也未用更高工作位数替代这些等式。

## F. 源码复用、文献和验证范围

本轮检索了仓内 HilbertBasis/residual 与 Parseval 所有者，回读 #5882 的完整残差对偶接口说明，并核对 #5602 实际 HEAD 仍为 `6533227479d52ab09d39f39baa4f45720c1fc133`。这些谱证书本轮没有重跑。另读取 loning 路线 #6131 的 `PaddingTailMass.lean`（`bc79fbdf7e984037434eee40e852b5ef49abdb17`，前 85 行），其明确把可求和性、正分母及 finite-set escape 分别列为条件。这提示有限集合上的信息与完整质量应分账；该算术结果没有被导入本节，也没有被当作 Weil 谱定理。

实际读取的钉版 Mathlib 为 `db584cd6d46c92f209a44c0f1c829460d327499d`，使用 `memℓp_gen`、`lp.norm_rpow_eq_tsum`、`HilbertBasis.repr_apply_apply` 及自然数/整数拆分求和接口。CCM《Zeta Spectral Triples》§8 的真实模态逼近仍是外部目标；Suzuki 的零边界域与 Friedrichs 扩张域区分及 Dusson–Sigal–Stamm 的 Fourier 谱离散化误差分析用于校对连接类型，没有把后者的 Schrödinger 假设套用到 Weil 算子。

本轮执行 400 组精确有理内区与双侧几何尾模型，验证 6540 个球误差平方界、30540 个拼接坐标、400 个完整质量区间、2000 个有限和加精确几何余项恒等式，以及各 6540 个零半径精确性和半径细化单调性检查。八个明确错误推断分别由零点重复计数、尾部偏移、遗漏负尾、遗漏 e²、把球当等式、矩形模长固定松弛、忽略高频质量及错误使用无界算子连续性反例排除。几何尾的总和由精确公式计算；这些诊断不是实际 Weil 求值或 Lean 证明。

十一条公开声明均配套 FromLean Scribe。运行环境无 Lean/lake，未执行 elaboration、内核公理闭包或 Scribe 发射；源码是数学与接口审查后的候选证明，没有独立审稿人。本轮给出可计算内区精度到完整 Hilbert 范数的连接，未完成规范 Weil 算子系数识别、内区求值器、实际新对偶改善、全尺度最低模态逼近或 Xi 极限。

参考：CCM `https://arxiv.org/html/2511.22755v1` §8；Suzuki `https://arxiv.org/html/2606.09096v1`；Dusson–Sigal–Stamm `https://arxiv.org/abs/2008.10871`；Mathlib `https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/InnerProductSpace/l2Space.html`，实际 API 以本节所列仓库钉版为准。
