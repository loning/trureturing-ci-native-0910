# Tier 3 Mathlib triage, 2026-09-09

## Provenance and scope

LANE #6160. One Codex worker, no skill invoked, no delegated or independent
review seats. Sequential mathematical reading and local kernel probes; this is
not a multi-model consensus. The runner contract was supplied by the user.
The tracked `tools/scripts/agent/probe-brief-note.txt`, complete `CLAUDE.md`,
and `agents/CONTEXT.md` were read before edits.

Worktree: `/Users/auricstudio/trureturing-u1bridge-0909`.
Branch: `lane/math/tier3-mathlib-triage-0909`.
Baseline: `f8ecf5a3d846482c5445fb5180a628d1caa0de29`.
Input: user-supplied untracked `candidates.json`, a JSON array of 150 records.
The input is not a new coverage ledger and its previous `needs-lean` labels
only report bounded searches of frozen repository material.

## Preregistered criteria

The unit is one complete atom, read with `make show-atom ATOM_ID=<full id>`;
source context is read where symbols or hypotheses are supplied outside it.
Titles do not establish that a body contains an assertion. Multiple claims in
one body must all match before the atom can enter A.

| Tier | Criterion |
| --- | --- |
| A `mathlib-bind-only` | Complete assertion follows by instantiation, projection, and normalization, including `sq_nonneg` / `linarith only`. Every upstream declaration must be opened in the local pinned Mathlib tree and cited with file and line. At least five distinct A atoms must receive real temporary Lean probes. A failed full-claim probe downgrades the candidate. |
| B `mathlib-partial` | A specific, relevant mathematical part is available upstream; state that part and the remaining obligation. Generic algebra infrastructure alone does not earn B. |
| C `genuinely-new` | No full binding was found in the stated Mathlib and frozen-repository search scope; name the missing mathematical statement. This is a triage label for a concrete formalization gap, not a proof of global absence or research novelty. |
| D `not-an-assertion` | Body is only narrative, a definition, or a computation report without a separately asserted mathematical proposition; explain from the body. |
| E `unreadable` | Body or essential context cannot be recovered or its claim cannot be determined; state the reason. |

Use `rg` or `git grep -P`; never use `git grep -E` with word boundaries.
Record search commands, line-match counts, exits, and positive/negative controls
using the same regex features. A textual hit only locates source to inspect.
No exhaustion claim follows from a finite keyword search.

Start: `2026-09-09 04:42:04 UTC`. The brief gives no total duration. A 120-minute
working limit was proposed through the clarification channel; pending a user
override, the assumed halfway checkpoint is `2026-09-09 05:42:04 UTC` and the
limit is `2026-09-09 06:42:04 UTC`. At halfway, fewer than 75 screened atoms
requires stopping with the explicit remaining IDs. All 150 screened permits
normal closure. Crossing into production Lean, cover, or deposit requires stop.
Completed batches (normally 25 atoms) and each probe result are committed and
pushed immediately, including failures. Report-only delivery: no PR.

## Mathlib pin

- `lean-toolchain`: `leanprover/lean4:v4.33.0`.
- `lake-manifest.json`: mathlib input revision `v4.33.0`, resolved revision
  `db584cd6d46c92f209a44c0f1c829460d327499d`.
- `git -C .lake/packages/mathlib rev-parse HEAD` returned that exact revision.
- `git -C .lake/packages/mathlib status --short` returned no changed paths.

## conclusion

Screened: **150/150**. A=7, B=41, C=102, D=0, E=0.

Structured result: [conclusion.json](tier3-mathlib-triage-0909/conclusion.json).
Complete canonical atom reads (raw and normalized text, command, EXIT) are in `atoms-1.json` through `atoms-6.json` as collected. Reading ahead does not count as screening.

All Mathlib paths below are relative to `.lake/packages/mathlib/`. Every listed declaration was opened locally. Full per-atom claims and decisions are in `decisions-*.json`.

| # | atom_id | Title | Tier | Criterion / remaining mathematics | Local Mathlib declaration | Probe / EXIT | Searches |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `028cb6a153eaec67ee356ef9571a406a6d9460c0092fbc031df4abab42884a85` | 定理十一：有限多边形绕数证书 | C | 缺带二阶导数/顶点误差预算的轮廓同伦和零点计数证书；通用路径理论不提供这条带常数的接口。 | none claimed | not run | winding |
| 2 | `04174c1260762c6fb3fe24cd51b93eea78714592b4cd71e927db335d5edf8b77` | 定理 S2：实际 theta 条件读数存在负区 | C | 缺实际 theta 核的负点存在性及其非零概率窗口；Jacobi theta 定义与变换不推出此符号结论。 | none claimed | not run | theta-analytic |
| 3 | `062d6f5a910eed117ab7596a2e34f1a6a0728de5e8599136b47689b29d2870c9` | 定理二十：交互阶数具有离散因果锥 | C | 缺完整交互投影分解下的幂带宽传播定理；需证明非零块路径满足阶数三角界，正文 t 是离散自然数。 | none claimed | not run | bandwidth |
| 4 | `0715d2f9078c88ee013814d101b0c36bdb33c5cf5ce76d58239e51cc6485df25` | 定理四：Toeplitz 矩阵是历史态的时钟约化密度矩阵 | B | 已具备酉搬运消去共同时间步的内积恒等式；缺本源历史态的偏迹、归一化和 r(i-j)=r(j-i) 的完整类型化连接。未将 Gram 子结论当作全偏迹证明。 | `LinearIsometryEquiv.inner_map_map` (Mathlib/Analysis/InnerProductSpace/LinearMap.lean:120); `LinearIsometryEquiv.inner_map_eq_flip` (Mathlib/Analysis/InnerProductSpace/LinearMap.lean:124) | not run | partial-trace, first-bindings |
| 5 | `072eca25d260537060a5e1b2b7dada75dbf623eba8eebb4bad8c765d8ebe6749` | 定理 N1：有限负证书 | C | 缺伴随矩阵迹平方的 Hermite 型实根判据；Hermite 正交多项式是同名异题。 | none claimed | not run | special-polynomials |
| 6 | `0831062a074c8393d5e0d16a4caa4487d783311664ffa661ab52092973475c5b` | 定理一：\(P\) 是一个四棱锥 | C | 缺此指定五点占据凸包的半空间及极点计算；一般凸包 API 不能直接给出这五个顶点。 | none claimed | not run | convex-local |
| 7 | `083b7658fb28ffb6609e6c46923ebd4e8c9c27dc3813f06187a0aa23c398e7d4` | 定理一：规范加一的最坏局部深度至少与编码跨度成正比 | C | 缺把局部传播半径连接到极端 Fibonacci 编码的算法深度下界；已有局部进位构造不是所有算法的下界。 | none claimed | not run | convex-local, bandwidth |
| 8 | `087e3caa7c278b4ea58f06604daa8721ab5258f6c451a25ed8f2d0092d823ca0` | 定理 B1：精确微分兼容关系 | B | 后续按冻结文件路径实查找到 P_d 的 source_jensen_degree_lowering；Mathlib 供应逐系数求导。仍欠 P_d 到 q_d=x^d P_d(-1/x) 的倒数变量/零点处多项式规范化绑定，未声称需要新的降阶数学。 | `Polynomial.coeff_derivative` (Mathlib/Algebra/Polynomial/Derivative.lean:58) | not run | special-polynomials, polynomial-readback, fifth-reweighting, frozen-jensen-path |
| 9 | `0d2c6e9ed518bfcee93cc1f4b71877666e729b3db0f05d06a2b43bbf53e86984` | 定理 L3：逐阶系数判据 | C | 缺平方级数系数的全阶实根刻画及反向检测非实谱的增长论证。 | none claimed | not run | special-polynomials |
| 10 | `0e1a7beb490fc5aece3b6e13b10c6523ab64fac627efd6b825dc5c5551af5eab` | 定理 K2：实根的历史体积上限 | C | 缺历史 Gram 行列式的非负 Laplace 表示及任意阶导数符号；指数函数正性不能代替体积表示。 | none claimed | not run | special-polynomials, negative-spectrum-refined |
| 11 | `0e8d9e20c8a7ec0e0820053dc56a9dae075722a110b78a0ecee60b5cb202f2d8` | 推论：系数增长率直接给出谱缺陷 | C | 缺 b_q,k 的精确指数型/增长率定理，不只是复数平方的代数分解。 | none claimed | not run | special-polynomials |
| 12 | `1033c98f6c47c1c95ba84c013ed594e604e96b5061d49672f6a3333ff411cb3a` | 定理 R5：筛选能量的精确公式 | C | 缺实际筛选态导数、动能形式和 theta 归一化常数之间的恒等式。 | none claimed | not run | theta-analytic, gaussian-moments |
| 13 | `10f086b0306c55830d4a16268948883d503cc3e347c5ebb45d89be2a6927fe3a` | 定理 P5：形状前件推出全部标量高斯矩上界 | C | 缺由本源形状前件到矩比较递推的积分不等式；上游 subGaussian 以另一种 MGF 前件起步。 | none claimed | not run | gaussian-moments |
| 14 | `15eb12aed71ec186edbcd3e877571bdd32780f55e1539a8ff1211975db8f51c3` | 定理一：前三阶在全局绝对收敛域内无零 | C | 缺此 F_r 的实际因子分解和各因子的无零界；riemannZeta 的无零定理只覆盖 zeta 因子。 | none claimed | not run | theta-analytic, discrete-winding |
| 15 | `16ee2a6dfb3840e47529bdbd48187c9167a2230d63a5ac51826e62a979baf1ff` | 定理五：固定分离度需要足够长的时间 | B | 已具备逐项 1-cos(x)<=x^2/2；缺对归一复相位平均的模平方展开和精确 N(N+2)/12 求和绑定，故未直接升级整条。 | `Real.one_sub_sq_div_two_le_cos` (Mathlib/Analysis/SpecialFunctions/Trigonometric/Bounds.lean:123) | not run | gaussian-moments, first-bindings |
| 16 | `183d1842d5f7033b150a150210195c78562694a2c239a984aea1f5b7f86ec009` | 定理 P1：有限尺度变化保留负方向，但可以任意压低其数值 | C | 缺无限负子空间由有限支撑逼近的指标等式及迹理想不等式；上文收缩界用 0<q<1，正文单独的 q>0 不足以支持全部范数句。 | none claimed | not run | negative-spectrum, negative-spectrum-refined |
| 17 | `19d4c054e92739f02edd10bc8c8cade6a616e273f45552e1f9e1da08359a6462` | 定理四：实际正性会在解析性失效之前先碰到边界 | C | 缺实际算术符号在解析半径之前失正的严格阈值证明。 | none claimed | not run | toeplitz, theta-analytic |
| 18 | `1ad5bec02ef18c7e44f7099ba5b17703e14dbfd047be51ab11ee29d6d17dfa0e` | 定理六：ξ 历史态的统一有效维数界 | C | 缺实际谱权重平方和界与无限支撑推出每一有限 Gram 满秩的结合；不认证小数 28.7548583457。 | none claimed | not run | toeplitz, theta-analytic |
| 19 | `1ba55c6c1a84a3ff33ceebbcb3a7c7d52c48d18a1823c4354d954afe0d3aee38` | 定理十八：有限历史形成负证书的一个必要条件 | C | 缺有限 Fourier 投影的集中度上界与该符号二次型表示的结合；需保持严格必要条件和 Haar 概率归一化。 | none claimed | not run | toeplitz, negative-spectrum-refined |
| 20 | `1e414ffb45d7fcaa9536a956298c4e291f91a2e310f112d2cf8419518caefd1a` | 推论 B1.1：高阶延拓是一项带常数的积分问题 | B | FTC 已给积分=端点差，后续也核实冻结 P_d 降阶；仍欠倒数变量转为 q_d 导数与 q_d(0)=(-1)^d*d!/d^d*a_d 的完整规范化绑定。 | `intervalIntegral.integral_eq_sub_of_hasDerivAt` (Mathlib/MeasureTheory/Integral/IntervalIntegral/FundThmCalculus.lean:1148) | not run | special-polynomials, first-bindings, frozen-jensen-path |
| 21 | `1e9daffd76d1ac95768ad7e9737ce9069f71ca9d5406430f42768de16be0a86c` | 定理二：局部数据的受控整体拼接 | B | 高阶 Schwarz 引理直接给目标误差形状；仍缺源定义递推的全纯/映盘及前 N+1 阶 Taylor 匹配到 isLittleO 前提的绑定。 | `Complex.dist_le_mul_div_pow_of_mapsTo_ball_of_isLittleO` (Mathlib/Analysis/Complex/Schwarz.lean:146) | not run | toeplitz, first-bindings |
| 22 | `1eecc9129a67c60825a86b1efaa93284267df6701e12127565d8873086de3021` | 定理三：统一非退化界 | C | 缺特定算术系数 w(m)/D_m 的逐项估计及尾部常数 1/20；一般 zeta 求和不确定该常数。 | none claimed | not run | theta-analytic, discrete-winding |
| 23 | `207bdea6c00dc779749029d64849d7221c08cad532ac5d38069d8871e87b4d92` | 定理七：固定越界量下的负方向密度 | C | 缺该符号的 Szego 特征值分布与负半轴示性函数逼近，并须保留 N 后 delta 的极限次序。 | none claimed | not run | toeplitz, negative-spectrum-refined |
| 24 | `224b9dc2f29a8182291ff077025c0f1cf83c02aeb844e2893366013f04898914` | 定理 D2：正实现的最低读数失配 | C | 缺正谱回返到 Pick 核正性、采样误差到算子扰动范数的完整定量桥；通用谱理论不等于该读数界。 | none claimed | not run | negative-spectrum-refined, toeplitz |
| 25 | `23e85e40204222cb3bee95c5c9072bd75f3796b82d41f908f8629d8a201137b9` | 定理七：任意周期的离散绕行公式 | B | 多项式最高阶有限差分和超过次数归零已库有；缺 H_d 关于 prime-zeta 分支的多项式展开、最高系数 Theta_d W_d 及绕行步长的类型化识别。 | `Polynomial.fwdDiff_iter_degree_eq_factorial` (Mathlib/Algebra/Group/ForwardDiff.lean:266); `Polynomial.fwdDiff_iter_eq_zero_of_degree_lt` (Mathlib/Algebra/Group/ForwardDiff.lean:274) | not run | discrete-winding, first-bindings |
| 26 | `247c5740e6ce2838bb73fce435941602825eace40b67c44c62f23f45796e0b04` | 定理 S3：完整的算术展开 | C | 缺 theta 双核到带 D_k(t) 的 Bessel 变换及绝对收敛交换；本地 theta 定义不提供这条算术展开。 | none claimed | not run | theta-analytic |
| 27 | `24e7f65c67cec1074a6af47cd138dda33f014adcc2b6d569e14823c62aadc6ea` | 定理二：精确的历史奇偶筛选 | C | 缺 q-多项式在 -1 的零点消去与精确阶乘商；一般 involution 求和只覆盖相消情形。 | none claimed | not run | q-combinatorics |
| 28 | `2664266b147343a4836824aae0348abd88a5ef821e178a073f2b6e8b8fe91a0d` | 定理 E3：同样构造单调上界 | C | 缺本源 Stieltjes 表示、试探多项式最优化与嵌套子空间上界的连接；逆矩阵运算本身不是该单调界。 | none claimed | not run | schur, toeplitz |
| 29 | `27065ff2e7fd688eaed358a1953fc8fec5b4a98870cdeee7317e43e4c228d6e6` | 定理三：联合极限具有一条明确的过渡曲线 | C | 缺临界谱密度在该联合尺度下的极限及一致余项；连续分式传递只处理已知极限后的最后一步。 | none claimed | not run | toeplitz, real-calculus |
| 30 | `2bc63109d666c92a11aa641dbeae45bc08e3f4f939bc5ce4406a75e5d86d03b6` | 定理 B3：一步正延拓的精确判据 | B | 已有正主块下的 Schur 半正定等价；缺 q_d 与箭头矩阵特征多项式、留数符号和严格正根/正定条件的完整绑定。 | `Matrix.PosDef.fromBlocks₂₂` (Mathlib/LinearAlgebra/Matrix/PosDef.lean:582) | not run | schur, special-polynomials |
| 31 | `2bcdc03e5777fcc1c396e5b07b17101c3f52508fb80a62a55e3b96a0b66158f2` | 定理 T4：指数位移分解 | C | 缺本源 theta 密度的卷积/尾积分分解及概率归一化；通用指数分布不识别这些实际随机变量。 | none claimed | not run | theta-analytic, real-calculus |
| 32 | `2c37bff2d8f941ea92b5c037c21e6d179a2ab8fe3a67836b6ecb5b2e766793e7` | 定理二：首次越界具有一个明确的缩放形状 | C | 缺两参数 Taylor 余项的一致控制及负区端点定位；逐点 Taylor 公式不足以推出零点边界渐近。 | none claimed | not run | toeplitz, real-calculus |
| 33 | `2f9a49afd3fffe7f7744822c6adea7f922e808404a7654ca0c8fd4f80195d788` | 定理 P2：逐阶保真关系 | B | det_mul 提供有限合同的行列式分解；缺实际系数卷积恒等式、有限截断兼容、T_F 单位三角绑定及负惯性保持。 | `Matrix.det_mul` (Mathlib/LinearAlgebra/Matrix/Determinant/Basic.lean:138) | not run | schur, negative-spectrum-refined, second-bindings |
| 34 | `2fa59f238e0c5dfb86c347ac26b274ce1ed355e030ffbc580a98779ceef61e6a` | 推论：RH 等价于一个明确的二次抵消 | C | 缺实际素数响应能量的 RH 等价和对角主项计算；标题后的叙述不抹去正文明确的渐近等价断言。 | none claimed | not run | theta-analytic, discrete-winding |
| 35 | `2fbed82e07d243d1005a8a1c09923c3aaa3d8b0a414ff7a9210cd5c6f2ed26e2` | 定理五：解析接触边界上，Schur 余量仍有统一正下界 | C | 缺 Szego 预测误差/熵下界及有限阶零点的 log 可积连接；通用实积分不是该 Toeplitz 结论。 | none claimed | not run | toeplitz, schur |
| 36 | `3342849ebfebb0ba8cd5217fe1a75e542e800c394bc9e9478978e025363fa770` | 定理一：时间方向始终合法，另一切面可以经历秩临界 | B | cos²+sin²=1 与 S*=S,S²=I 可规范化得到酉性；缺重排后的奇异空间分解及 d²-1 重数，故整条不是 A。 | `Real.cos_sq_add_sin_sq` (Mathlib/Analysis/Complex/Trigonometric.lean:666) | not run | unitary-involution, second-bindings |
| 37 | `33bd332c5190b7fb8bf6b6fde4e8863e2cbc32878b35713e4e42abc4c4582e8b` | 推论：实际算术没有稳定的“二次能量中间态” | C | 缺实际算术能量的增长率/谱缺陷定理；形式上的渐近矛盾不能代替这两个前置数学结论。 | none claimed | not run | theta-analytic |
| 38 | `34f85f5ef0ec8521296d78b1a195aa9330397b316945d3dae5f77744c60587eb` | 定理 V2：对实际 \(A\)，全局收缩性与 RH 等价 | C | 缺实际 xi 响应的 Schur/Pick 表示与 RH 的双向桥；Schwarz 引理只在已有收缩前件下工作。 | none claimed | not run | toeplitz, theta-analytic |
| 39 | `352958cfd6f933764581834a39a2547c32c91c2871dfc88c0e6d915af186b804` | 定理 P4：任意半径的有限截断界 | C | 缺双指标解析系数的尾部平方求和与算子范数支配连接，特别是根号内 2R^-2N-R^-4N。 | none claimed | not run | negative-spectrum-refined, toeplitz |
| 40 | `3b96c202fb8567eb58151de0b72315414794aa9b0003e2aecba521121fa0a819` | 定理二：完整算术分解 | C | 缺本源历史权重按素数占据型分类的恒等式；一般 Dirichlet 级数 API 不给这些系数。 | none claimed | not run | discrete-winding, theta-analytic |
| 41 | `3cefd6e75bf3146ba90cf7614b16b286751f3a36029a22cbba8e97a49ba911d3` | 定理 T1：原函数是一个精确的尾积分 | B | 半无限 FTC 提供尾积分=无穷端点减有限端点；缺实际 g_+,Phi 的导数关系、可积性及无穷边界值。 | `MeasureTheory.integral_Ioi_of_hasDerivAt_of_tendsto` (Mathlib/MeasureTheory/Integral/IntegralEqImproper.lean:787) | not run | real-calculus, second-bindings, theta-analytic |
| 42 | `3ea6f6f717cf3b008eb7110a832936a14b2d2a332b6ee2abe42cb1146455f049` | 定理 I4：固定高斯历史协议的 RH 判据 | C | 缺实际有限多项式谱向 xi 零点的逼近，以及高斯残差与谱虚部的统一估计。 | none claimed | not run | special-polynomials, gaussian-moments |
| 43 | `409c425f66ec18a504f4d6304af1f43493cb5a92225344c4f79b342fd0f5eacd` | 定理 D4：三矩—端点兼容界 | B | Jensen 积分不等式支持 Stieltjes 下界步骤；缺实际测度与 M0,M1,M2 的绑定、重加权上界及全部分母正性。 | `ConvexOn.map_integral_le` (Mathlib/Analysis/Convex/Integral.lean:199) | not run | real-calculus, second-bindings |
| 44 | `4104d8727c10869ec5ae256646c45c0bc72bcb83febed83f36c94488bbd5a763` | 定理二：这条离散边界对应低温复零点 | C | 缺实际局部根分支的存在、指数余项以及该分支是完整配分函数零点的收敛域连接。 | none claimed | not run | theta-analytic, winding |
| 45 | `42a6721fabfa0a316cd60251fdff5e3997dec865d18964539f6241a7c2dba3f9` | 定理 O2：滤波器就是这个空间中的状态 | C | 缺实际 K 条目与 Q_infinity 的谱/系数表示恒等式；有限求和展开不能自行识别两个独立定义。 | none claimed | not run | negative-spectrum-refined, special-polynomials |
| 46 | `4ad8c850dca051f69ac5f8fc65592b377d32fca0fac5d5347fcc3c0ea2b7c153` | 定理 B2：删除一个均衡方向，得到低一阶的缩放模型 | C | 缺均衡谱压缩的导数特征多项式公式，以及本源 q_d 跨阶缩放兼容；一般子矩阵定理不足。 | none claimed | not run | schur, special-polynomials |
| 47 | `4bf0743f24ceefdab6eae275b611c01646e5bf795de46dc68456a1d7ed269bf6` | 定理 J3：严格平方下降律 | B | 导数非正推出单调不增已有标准接口；缺该实际能量导数的交换子平方恒等式及体积二阶导数关系。 | `antitoneOn_of_deriv_nonpos` (Mathlib/Analysis/Calculus/Deriv/MeanValue.lean:479) | not run | real-calculus, second-bindings, negative-spectrum-refined |
| 48 | `4dea51c9bf2a5ec929da7acfdeb7d4694ddb3effba5083d8d5e0519ebed7bfd6` | 定理十三：负方向数直接控制负总量的增长率 | C | 缺特定 Toeplitz 径向导数的负谱压缩不等式和奇异参数有限性；不能只用标量微分估计。 | none claimed | not run | toeplitz, negative-spectrum-refined |
| 49 | `4f1af385073cf374adf2837dcb61d6f03822ba385a3f589dacb3087c8b867246` | 推论：不再需要任意搜索观察度量 | C | 缺对非正规/不可对角化矩阵也成立的高斯残差定量逼近；一般谱半径公式不提供该固定构造。 | none claimed | not run | negative-spectrum-refined, gaussian-moments |
| 50 | `506ba2fa80720ba43ca7d89d6b8d9c39455747237809df8fd552367fc064f22c` | 推论：反例必能表现为某个有限条件读出的负值 | B | 有理数稠密已提供严格负邻域内选有理点的最后一步；缺非 RH 到有限 n 负读数的 Laguerre 等价及实际 R_n 连续性。 | `exists_rat_btwn` (Mathlib/Algebra/Order/Archimedean/Basic.lean:371) | not run | special-polynomials, theta-analytic, second-bindings |
| 51 | `51ecbc2e4c8976d219f4c2617007564164468c320acb88918b7ab6d848e61d79` | 定理 Q5：条件读出的统一误差界 | B | 概率测度的特征函数模 <=1 已库有；缺实际倾斜测度的内外截断混合恒等式、归一化和 supremum 绑定。 | `MeasureTheory.norm_charFun_le_one` (Mathlib/MeasureTheory/Measure/CharacteristicFunction/Basic.lean:175) | not run | third-bindings, theta-analytic |
| 52 | `528a07b72b26ab9b7df6f3645a60c76eedd91f4489b30838ea8ccb310c386c9b` | 定理二：模数进位—相消重数关系 | C | 缺 q-多项阶乘的分圆因子重数与占据进位公式；自然数 multinomial 或一般单位根理论未给完整接口。 | none claimed | not run | q-combinatorics, polynomial-readback |
| 53 | `578c45143001f9f9929455e22deef3c7cba964c4389ba0b9d79dd9371ed8f806` | 定理十二：恢复分辨率不会降低负本征值总量 | C | 缺把径向 Poisson 平滑接成保迹正映射并控制负谱迹的收缩定理。 | none claimed | not run | toeplitz, negative-spectrum-refined |
| 54 | `5918f6bd5a66f8b7eb15b4b1c505d54dfdf3b73d884b537a42b153c9270e3d4c` | 定理一：径向接触不可能无限平缓 | C | 缺边界 Poisson 生成元积分表示、触点处可积性与归一化常数下界。 | none claimed | not run | toeplitz, real-calculus |
| 55 | `594f93cbc27b15032549c9271c41b100f049b61736e5e5d1fdbb8c90fb3cdda4` | 推论：低频联合能量判据 | C | 缺实际素数读数的离散 Fourier 能量恒等式、统一高频截断及原能量 RH 等价。 | none claimed | not run | theta-analytic, discrete-winding |
| 56 | `59626bffd526d065fe29b4f63e40a4367886e380208787d0cf0fe4df9e169a9b` | 定理二：单次试除的精确指令数 | C | 缺此状态机完整运行轨迹与逐指令计数，不只是 M 除以 k 的商余关系。 | none claimed | not run | trial-division |
| 57 | `5a2c25fc480f079e01ab62c81849c0487bae747b3674423d9bdd62f45ba8ae2f` | 定理一：正配分函数的归一化边界恰好是 \(\lambda=T\) | C | 缺实际算术能量权重与 p-级数的双边比较，包括临界点发散；没有把泛用级数测试当作该模型结论。 | none claimed | not run | theta-analytic, real-calculus |
| 58 | `5f07081bda1ac55ca035fd26826575c18e003849d50ee64a715d99ee9c802999` | 定理 V4：固定实区间中的全阶拼接判据 | C | 缺区间采样正核的解析唯一延拓及实际零点位置的反向检测。 | none claimed | not run | toeplitz, theta-analytic, negative-spectrum-refined |
| 59 | `62ee996f8ec3b4c0ff8b4d9d182f2785eed2515aa9b326c2e160705c7abdef3f` | 定理 L2：投影概率 | B | 正交投影范数不增已库有；缺指定 Fock 相干态、酉群平均投影与 HCIZ 历史读数的完整相等式。 | `Submodule.norm_starProjection_apply_le` (Mathlib/Analysis/InnerProductSpace/Projection/Basic.lean:361) | not run | third-bindings, special-polynomials |
| 60 | `62f3d7a538f73aad17058c82235f1c1b82a07a089f54ad53aa27094677675f61` | 定理 N3：固定滤波器的定量稳定性 | C | 缺本源每阶矩的 Cauchy 型误差及有限滤波系数求和的明确常数；末端线性负余量传递不是完整证明。 | none claimed | not run | special-polynomials, negative-spectrum-refined |
| 61 | `63092dbf1c6ca5601c3853ad32183d153a5ba60589f537fa409f0581ade1df64` | 定理 Q3：实际两模态判据 | C | 缺广义 Laguerre 全阶实根判据与实际 theta 双模态读数的精确识别。 | none claimed | not run | special-polynomials, theta-analytic |
| 62 | `692393217ace683f2485ba9cf02961c2290a83cb594513880aed0c55acd62466` | 定理 M1：维数稀释界 | C | 缺 Schur 系数/分区和的维数依赖估计 L^(2k)/d升阶乘；几何求和不能供应该核心界。 | none claimed | not run | special-polynomials, q-combinatorics |
| 63 | `69ae4d23bd64324ec6c5efe11686945d726482b842c45097e2e0e9360599cdb1` | 定理 B5：重标定回返恒等式 | B | 块逆公式已给 11 角的 Schur 回返分母；缺实际均衡参考向量的迹平均、P_d 对数导数与该矩阵的匹配。 | `Matrix.invOf_fromBlocks₂₂_eq` (Mathlib/LinearAlgebra/Matrix/SchurComplement.lean:277) | not run | schur, special-polynomials |
| 64 | `72307ef5e33caa0d618146ecef4ad819f3ee4ebe2e55ebe5a6c226f5cd5a34e1` | 定理一：周期筛选公式 | C | 缺多重集 q-Lucas 在单位根处的精确阶乘商及分圆重数公式。 | none claimed | not run | q-combinatorics, polynomial-readback |
| 65 | `72f167014dbb653f2eec31560ed015c7e2c0d4140cb398121ad04c898e8b066f` | 定理 J2：体积—残差恒等式 | C | 缺高斯矩阵积分求导、log det 导数与反自伴残差的迹恒等式；Gram 正性不供应这条演化律。 | none claimed | not run | gaussian-moments, negative-spectrum-refined |
| 66 | `74c15d92cd745276176c9d4c66c4cdd5b7bf59fae5b937ae1e1a07186deca95b` | 定理一：交换对称保护的奇偶相消 | B | 有限和的无固定点反号 involution 相消已库有；缺实际词交换保持合法历史且反转逆序奇偶的类型化绑定，不能把上文式12当已冻结前件。 | `Finset.sum_involution (to_additive of prod_involution)` (Mathlib/Algebra/BigOperators/Group/Finset/Basic.lean:665) | not run | q-combinatorics, third-bindings |
| 67 | `7721167db127aee2407282ad63f0739c5d953cd1720752a4d67089f562f7f10b` | 定理 I3：高斯历史残差逼近真实谱虚部 | C | 缺允许 Jordan 块的固定历史度量误差界与明确维数常数，不是通常酉谱不变性。 | none claimed | not run | gaussian-moments, negative-spectrum-refined |
| 68 | `77c2008257f3b60bc946f7a241541d17e94ffbd08b19325833bb0612dc5b1af0` | 定理 K3：历史体积上限与实根性等价 | C | 缺 HCIZ/历史体积的大 r 指数率反向检测虚部，以及实根时的体积上界。 | none claimed | not run | special-polynomials, negative-spectrum-refined |
| 69 | `781219f95a1fdbea17a70a99cd34033d8dcc9569251b578580b4da952a19bbfd` | 定理六：每个接触点贡献的负区域与负总量 | C | 缺触点局部一致缩放后负区长度与积分极限的误差控制，尤其积分域随 delta 变化。 | none claimed | not run | toeplitz, real-calculus |
| 70 | `783d413d2f102a6149222de31f25d081389f7d601c08e27fec9e339cf2f22c4c` | 定理一：试除宏步骤 | C | 缺该具体状态机的循环不变式与终止轨迹；欧几里得商余定理本身不证明执行结果。 | none claimed | not run | trial-division |
| 71 | `78f6a2108eaba02cfbe8c76ca6e12034335c4c1e4129bde2a2affd123bf56568` | 定理四：有限历史的临界偏移具有同一个幂律 | C | 缺临界小特征值估计和径向横截性一致连接，需两侧常数同时有效。 | none claimed | not run | toeplitz, negative-spectrum-refined |
| 72 | `7a359a1aa118ffc5f3423e85e46ce5f615806e4b8c0a16998ec49691a0215817` | 定理三：实际正性形成一个完整区间 | C | 缺实际径向核的正性区间延续、端点闭性与 RH 双向识别。 | none claimed | not run | toeplitz, theta-analytic |
| 73 | `7afafe5a6e3e8435ddf051d6cf49c1c6ca223fa4c95dfe286f19c8f391ec33d5` | 定理 L5：低阶自动上界 | C | 缺分区/Schur 多项式的统一系数估计；后续阈值整理不能覆盖这一数学缺项。 | none claimed | not run | special-polynomials, q-combinatorics |
| 74 | `7bc4a56b9299f55e209695fa3689db283e8328893508c0a4473ed32dea18b33b` | 定理 E5：实际谱留数的整数约束 | B | Mathlib 已证明有限非零阶零点的 logDeriv 具有简单极点；缺留数系数 m、倒数坐标变换及实际 S 的定义绑定。 | `meromorphicOrderAt_logDeriv_eq_neg_one` (Mathlib/Analysis/Meromorphic/Order.lean:996) | not run | logderiv-residue, theta-analytic |
| 75 | `7d5d9c72f7ad9abb794dd61d99e68ff5adc1271970f00e4a009b9e334680a0d2` | 定理 M4：有限算术关系可以精确回读 | A | 展开实际定义后，coeff_monomial 提取权重系数，descFactorial_pos 供应 k<=n<=d 时分母非零，逐项 field_simp 即恢复 P_n；对任意实系数序列成立。 | `Polynomial.coeff_monomial` (Mathlib/Algebra/Polynomial/Basic.lean:581); `Nat.descFactorial_pos` (Mathlib/Data/Nat/Factorial/Basic.lean:374) | Readback75: 0 | polynomial-readback, third-bindings |
| 76 | `8062498ed2ea8f74ddd34c3c2dec295a44f3074797e0634b52cbd2630b51459e` | 定理 V1：零点转成了一个特定的相位接触 | B | logDeriv 在有限阶零点的简单极点阶数已有接口；缺 Cayley 分式的可去延拓值与一阶 jet 的精确系数。 | `meromorphicOrderAt_logDeriv_eq_neg_one` (Mathlib/Analysis/Meromorphic/Order.lean:996) | not run | logderiv-residue, toeplitz |
| 77 | `87852ef96970dd58409cceccafe2fa235ed951e6c39b41869e0fca5ecb677246` | 定理三：最大全局离线位移的距离公式 | C | 缺全部零点集合到最近极点距离的统一上下界与极限交换；有限点距离计算不供应全谱上确界。 | none claimed | not run | theta-analytic, negative-spectrum-refined |
| 78 | `88517388478e9834b20004960ece45e5026828dc5fbb0a58206c141a37529a4b` | 定理六：全部高周期共有的非退化界 | C | 缺实际算术权重的全 d Dirichlet 尾估计及明确组合常数；普通求和支配不识别 W_d。 | none claimed | not run | discrete-winding, theta-analytic |
| 79 | `887786649b4338a76547a05ce2a7b0347b65b5fbe737f69ec247188f3214a077` | 定理二：谱平滑对首次返回概率的作用是精确的指数折扣 | B | PowerSeries.coeff_rescale 直接供应重标系数乘 a^n；缺实际谱平滑到边界 Schur 函数复合的等式，及首次返回振幅的系数识别。 | `PowerSeries.coeff_rescale` (Mathlib/RingTheory/PowerSeries/Basic.lean:567) | not run | toeplitz, fourth-bindings |
| 80 | `88b85ee6e765d6cc5180d029dfdce4cb39fa51093abb321682813ff46a09f58c` | 定理三：混合方格的相容条件 | B | 酉算子的 star*U=1 支持局部回返等价；缺任意两条网格路径的相邻交换归约和周期边界的全局环路条件。 | `Unitary.star_mul_self_of_mem` (Mathlib/Algebra/Star/Unitary.lean:61) | not run | unitary-involution, fourth-bindings |
| 81 | `8a1900b281e35bf99c03af2be822b3b0f7a042c7b2a5f8d9ee837df2ca1de391` | 定理 N2：代数平方就是两条件态的相对振幅 | B | Mathlib 的矩阵内积实例提供 trace(B*M*A*) 配对；缺源文 (B tensor I)Omega 的向量化与两层平方根归一化的实际绑定。 | `Matrix.toMatrixInnerProductSpace` (Mathlib/Analysis/Matrix/Order.lean:336) | not run | finite-geometry, partial-trace |
| 82 | `8b768726d3b3963e9b9e1a11bc7f33a04a657642db42c63fbdaaff28bf0456b0` | 定理一：忠实切面的拼接公式 | C | 缺完整路径与前缀/切边/后缀三元组的保权双射，不能把一般有限和换序当作忠实切面定理。 | none claimed | not run | bandwidth, unitary-involution |
| 83 | `8c8a536d7244072e5e39acc9ab7d2fdf7d874b16349959336f6450a8aad7d74d` | 定理 T6：高阶矩的精确递推 | B | 尾积分 FTC 可处理分部积分端点步骤；缺 W 与 J 的双副本微分恒等式及实际核的快速衰减边界。 | `MeasureTheory.integral_Ioi_of_hasDerivAt_of_tendsto` (Mathlib/MeasureTheory/Integral/IntegralEqImproper.lean:787) | not run | real-calculus, theta-analytic |
| 84 | `8df09af617ce850c0ed67805688f8fc4f3a0073576a33701fa752ca4ea9ca08a` | 定理 E4：有限链精确保留前 \(2N\) 个回返矩 | C | 缺 Stieltjes 正交多项式/高斯求积的 2N-1 次精确性及实际 J_N 构造匹配。 | none claimed | not run | special-polynomials, toeplitz |
| 85 | `8f9277771081db94f2cbe4d55fe4075fdde7edc0a9ecf4e443ae45717b8c0dcb` | 定理三：整段历史的精确双端点读出 | B | 有限和 Cauchy-Schwarz 提供加权位移能量下界；缺整段酉坐标变换、给定端点约束的双射和最优内部历史构造。 | `Finset.sum_mul_sq_le_sq_mul_sq` (Mathlib/Algebra/Order/BigOperators/Ring/Finset.lean:159) | not run | fourth-bindings, unitary-involution |
| 86 | `8fa3ec47d77910a7c979444b92779fa3031a487901bebfcdf8f8e10d56ce54d4` | 定理 I1：它对任意有限矩阵都收敛且严格正定 | C | 缺矩阵指数增长与高斯尾的可积支配，以及每个非零方向积分严格正的证明；不能只读 >0 忽略收敛。 | none claimed | not run | gaussian-moments, negative-spectrum-refined |
| 87 | `90382ec6571adc1e9f8248f72b7b7a2bb916d5ade3bdbfc99e99b6477c208b34` | 推论：RH 强迫纯素数读出最终具有固定负余量 | C | 缺素数平方确定偏移、在线零点振荡常数与纯素数/素数幂读数差的实际解析估计。 | none claimed | not run | theta-analytic, discrete-winding |
| 88 | `92536bbe2b763233c6c90f6e32152612b3a4c8316395ce3895a27051104157cb` | 定理 P3：这个转换不会随阶数变得任意病态 | C | 缺实际解析乘子 F,1/F 的系数范数与 Toeplitz 乘子算子之间的统一界，特别是有限截断逆的兼容性。 | none claimed | not run | toeplitz, negative-spectrum-refined |
| 89 | `937abccd3570503c88aaac8b088e687e6f79db29ca9f67f887b72a028bd4f866` | 定理二：边界有效几何由 Schur 补唯一确定 | A | 直接实例化 schur_complement_eq₂₂，PosDef.isUnit 供应逆，PosSemidef 的二次型非负供应下界；代入 y=-C^-1 B*x 达到等号。探针验证 IsLeast，未只验证配方。 | `Matrix.schur_complement_eq₂₂` (Mathlib/LinearAlgebra/Matrix/Hermitian.lean:378); `Matrix.PosDef.isUnit` (Mathlib/LinearAlgebra/Matrix/PosDef.lean:507); `Matrix.PosSemidef.dotProduct_mulVec_nonneg` (Mathlib/LinearAlgebra/Matrix/PosDef.lean:305) | Schur89: 0 | finite-geometry, schur |
| 90 | `96902e5b1d0b9ac78c37f6c1f75fd1d5043bfd6c18f5e2451352b6fbc6977b46` | 定理十五：一个反射零点对的负贡献区域，恰好是一个圆盘 | A | 平方非负与零点排除给分母正性；field_simp/ring 通分，div_lt_iff₀ 与正乘子比较直接给圆盘等价。首版 EXIT=2 为接口误选，v2 换用 mul_lt_mul_iff_right₀ 后完整合取 EXIT=0；两版均归档。 | `sq_nonneg` (Mathlib/Algebra/Order/Ring/Unbundled/Basic.lean:606); `div_lt_iff₀` (Mathlib/Algebra/Order/GroupWithZero/Basic.lean:1146); `mul_lt_mul_iff_right₀` (Mathlib/Algebra/Order/GroupWithZero/Defs.lean:286) | Disk90: 2; Disk90-v2: 0 | finite-geometry |
| 91 | `983c804dbd8a847852de8910fac6e9702a31040ec86415def14516a225851762` | 引理：小历史宽度下，行列式不会比 \(\exp[-O(d^2\log d)]\) 更小 | C | 缺合流 Vandermonde/导数 Gram 的统一定量下界；普通行列式非零不控制这个维数尺度。 | none claimed | not run | special-polynomials, gaussian-moments |
| 92 | `9877043750157f00197144b87542162e34a7242d56d6533a857d4cb5822fd169` | 定理十六：负贡献圆盘的 Möbius 像 | B | 复倒数模平方公式已库有；仍需完整坐标配方、K>0 和模不等式双向转换的绑定，当前未用只验证中心公式替代整条。 | `Complex.normSq_inv` (Mathlib/Data/Complex/Basic.lean:750) | not run | finite-geometry, fourth-bindings |
| 93 | `9907b45db0455394c6e8a00a5cd8ff4254b92dddb711777a18a6ab48d070c176` | 定理十四：负部分的精确产生率 | C | 缺移动负域的可微性、Poisson 奇异核积分交换及正负区抵消；标量非负性不能供应等式。 | none claimed | not run | toeplitz, negative-spectrum-refined, real-calculus |
| 94 | `9a5d07eae55d326165113eae65bcedf131f3abfb57916fd7c08913609d7adbab` | 定理 O4：截断误差 | C | 缺该系数核的迹类分解和精确尾部求和估计；Mathlib 没有在已查范围供应所需迹范数接口。 | none claimed | not run | negative-spectrum-refined, toeplitz |
| 95 | `9a6bf4e79560e0d3df31fbe2a177f290ec07ec71218e71eb89e322dc2f039635` | 定理 S4：裸 Bessel 核的有限正值区间 | C | 缺此虚阶 Bessel 积分的符号定理；检索到的特殊函数/指数正性不足以处理振荡积分。 | none claimed | not run | theta-analytic |
| 96 | `a5b558f46722070fb3661959014acf45a036f4013ac27541c95454f998a44da2` | 定理 E2：下界是一个最佳多项式逼近问题 | B | Schur 配方提供有限二次优化的代数部分；缺实际矩矩阵与加权 L2 误差展开、严格可逆和嵌套多项式空间的匹配。 | `Matrix.schur_complement_eq₂₂` (Mathlib/LinearAlgebra/Matrix/Hermitian.lean:378) | not run | schur, special-polynomials |
| 97 | `a7dc27aa3ded303f19a0085dc10e7521c4f0e9984b5970c109e3a572b1c30f11` | 定理 D1：任意足够多的不同采样点，都保留全部负方向 | B | Vandermonde 行列式非零等价于采样互异已有接口；缺实际采样核合同公式、Bézout 惯性与非实根对计数定理。 | `Matrix.det_vandermonde_ne_zero_iff` (Mathlib/LinearAlgebra/Vandermonde.lean:232) | not run | fourth-bindings, negative-spectrum-refined, special-polynomials |
| 98 | `a7e88754e5bb8b4c30b89baee6fd1fe41153876af182d201b96a9086884d779f` | 推论：存在超几何速度的截断方案 | C | 缺实际 D,D',D'' 的统一增长上界与算子截断常数 M_R 的联动估计；Stirling 的存在不能直接认证该算子界。 | none claimed | not run | theta-analytic, negative-spectrum-refined |
| 99 | `a86360d87830d173c35426c12b589270e406c6a12dc8dfb241ccdbefb825d0e3` | 定理二：第四阶在绝对收敛域内的全部零点 | C | 缺完整 F4 因子分解、指定代数根 alpha 的唯一性及其他因子的无零性；不认证给出的小数。 | none claimed | not run | discrete-winding, theta-analytic, winding |
| 100 | `af4b3b2fa8cb484824d83794e63fc48816b6e05c9c0ad32f76e3a360c35e30eb` | 定理 D3：共同正回返表示 | C | 缺 xi 零点到正测度的完整表示与反向唯一性/极点支撑论证。 | none claimed | not run | theta-analytic, toeplitz, negative-spectrum-refined |
| 101 | `b407682500faaa6d8da43ce0ed7505d8350c1352ad449a548751bce1b62cd783` | 定理 U2：实际算术核的全局正性判据 | C | 缺实际 A 的正核表示、解析延拓及从全局正核反推全部零点在线的桥。 | none claimed | not run | theta-analytic, toeplitz |
| 102 | `b5821e42febe81b45815f8be9802ddafcf7daab5dc4c74e501b0e709ce3e6000` | 定理五：任意周期的解析分支次数 | C | 缺 prime-zeta 的 Möbius 延拓、实际占据分类系数 A_dj 的全纯性与路径继续的分支兼容。 | none claimed | not run | discrete-winding, theta-analytic |
| 103 | `b664d8929116da6563cafcdddb7f6e7dc3b66a6fe434e807422ba82db9b83ee4` | 定理 E1：在正表示下，这是另一份正谱测度 | B | 积分加法与常数除法支持分式恒等式积分化；缺实际 Delta=-S(-4) 的端点绑定、z=-4 的可去解释及全阶 Laurent 系数/积分交换。 | `MeasureTheory.integral_add` (Mathlib/MeasureTheory/Integral/Bochner/Basic.lean:237); `MeasureTheory.integral_div` (Mathlib/MeasureTheory/Integral/Bochner/Basic.lean:295) | not run | fifth-reweighting, theta-analytic |
| 104 | `b923baf16e3404ffc7143c8258cd778915ab93409a40512c8d156d065ed1f61a` | 定理：它们是否相容，由总指数奇偶决定 | A | ArithmeticFunction.cardFactors_mul 直接给 Omega(d)+Omega(N/d)=Omega(N)；pow_add 和 (-1)^2=1 规范化给算子在每个因数坐标的等式。探针量化任意 N,d&#124;N 及任意复波函数，没有枚举 5040。 | `ArithmeticFunction.cardFactors_mul` (Mathlib/NumberTheory/ArithmeticFunction/Misc.lean:290) | Parity104: 0 | fourth-bindings, fifth-reweighting |
| 105 | `bc9748938013e4b3c632bfa0e1257a59733df2e1682ed0a8a0d7a0dcc534ab2b` | 定理 V3：相位修补增加一个正秩一项 | A | 对 p,z,w 在上半平面，linarith only 从虚部正性排除全部分母零；Complex.sub_conj 把 2*Im(p) 化为共轭差，随后 field_simp/ring 验证完整核恒等式。无 S 的额外分析前件；不主张实边界对角延拓。 | `Complex.sub_conj` (Mathlib/Data/Complex/Basic.lean:668) | Pick105: 0 | finite-geometry, toeplitz |
| 106 | `bdbe4b53515757ce5b701ee375409970886fe1274ff51cca53692271e1f924bb` | 定理 Q4：实际 \(\mu_n\) 在正半轴严格递减 | C | 缺实际 theta 双模态积分的严格形状不等式与求导交换；普通 log-concavity API 未给该指定核结论。 | none claimed | not run | theta-analytic, gaussian-moments |
| 107 | `bdc556a362036fbf086d0f5882d47613103ee99fa42cd1bf20d16e264b0b274a` | 定理 O1：\(\mathsf K\) 是迹类自伴算子 | C | 缺实际核的可求和秩一展开及迹理想范数控制；本地 TraceClass logging 命中已排除。 | none claimed | not run | negative-spectrum-refined, theta-analytic |
| 108 | `be67399e40a50efabac4cb3841bc3a3b7bbb408e0954367e9f95efe2f390eede` | 定理 R2：实际两模态的局部高斯极限 | C | 缺双峰 Laplace 方法的统一尾控制、独立极限与矩一致可积性。 | none claimed | not run | gaussian-moments, theta-analytic |
| 109 | `c03c3d51c8caa76b112c4d2b77618edb95c424c724d03c1f4e1b0fe8887986d5` | 定理四：三周期读数的离散绕行公式 | B | Mathlib 多项式最高阶差分/超次数归零可直接处理二次分支；缺实际 H3 对 prime-zeta 分支的系数与绕行增量识别。 | `Polynomial.fwdDiff_iter_degree_eq_factorial` (Mathlib/Algebra/Group/ForwardDiff.lean:266); `Polynomial.fwdDiff_iter_eq_zero_of_degree_lt` (Mathlib/Algebra/Group/ForwardDiff.lean:274) | not run | discrete-winding, first-bindings |
| 110 | `c0a72a217fb966246fd4a48a809795cdc539435d1e88d1a10d041a9bcd9ed98d` | 定理 B4：新增耦合总预算 | B | trace 与特征多项式系数的接口已有；缺实际箭头矩阵二次迹/均衡方向到 eta 总和、q_d 前两系数和累积量的完整绑定。 | `Matrix.trace_eq_neg_charpoly_coeff` (Mathlib/LinearAlgebra/Matrix/Charpoly/Coeff.lean:139) | not run | fifth-bindings, special-polynomials |
| 111 | `c24e34de0c01213d2344c494115a947d88276005c94863a848567f7031e10009` | 引理：实际有限谱有统一界 | C | 缺正系数 D 与所有 P_d 在同一小圆盘的统一支配及倒数多项式的根传递；norm<1 推非零只供应末步。 | none claimed | not run | special-polynomials, theta-analytic |
| 112 | `c468d943aacd5d85352a7866613f53c2d6b6fd3e5a7c94cf9a5115a718abb0c9` | 定理 V5：实际全部两点矩阵正半定 | B | Schur 正性等价可以把两点矩阵降为标量行列式判据；缺实际 mu 正且递增、mu(b)/b 递减的 theta Turan/协方差分析。 | `Matrix.PosDef.fromBlocks₁₁` (Mathlib/LinearAlgebra/Matrix/PosDef.lean:563) | not run | schur, theta-analytic |
| 113 | `c600e6828d8eeb65e865c4c7c465be9aa00cb5a30100be45cfcb26542c868b4d` | 定理 K4：固定宽度序列判据 | C | 缺统一小历史行列式下界与离线谱虚部检测在 d^4 窗口内的定量结合。 | none claimed | not run | special-polynomials, gaussian-moments |
| 114 | `cd2ad7f9986ee06ef6a8ac86aa7834a19d836483eaa1475b57396f3ba7ae536a` | 推论：实根性向低阶传递 | B | 带重数的多项式 Rolle 计数已有，且冻结 P_d 降阶已核；仍缺 q_d 倒数缩放、正根域保存与塔上归纳/最小失败阶的完整绑定。 | `Polynomial.card_roots_le_derivative` (Mathlib/Analysis/Calculus/LocalExtr/Polynomial.lean:66) | not run | fifth-bindings, fifth-reweighting, frozen-jensen-path |
| 115 | `cf00b1802f9e0029835530f6cff45c04fc84ccaa1f13d1eadc540c1dc6259ba3` | 定理二：金字塔最大熵几何的曲率 | C | 缺该统计度量的 Levi-Civita/曲率计算及 warped-product 截面公式接口；不是把已知 f 的两个导数代入即可认证几何。 | none claimed | not run | fifth-bindings, convex-local |
| 116 | `d434181a00c8203a60054490e976fdfcfe0f1b1c1fc42b9a2d58797aa0341a9d` | 推论：整个历史过程到底消除了多少？ | B | 半无限 FTC 可把耗散导数积分成端点差；缺实际平方下降律、无穷残差极限和谱平方和识别。 | `MeasureTheory.integral_Ioi_of_hasDerivAt_of_tendsto` (Mathlib/MeasureTheory/Integral/IntegralEqImproper.lean:787) | not run | real-calculus, gaussian-moments |
| 117 | `d46f67d9701bbca5691908d2a1ff2d60f8cc946f10b5a1e91c784b83ad378bde` | 定理 M2：线性历史窗口的自动通过区域 | C | 缺实际 Schur 系数稀释界、S_d 到 S* 的定量控制及明确常数8；标量 exp 单调性不供应窗口。 | none claimed | not run | special-polynomials, gaussian-moments |
| 118 | `d5fddb4b2a8fa2c2afef4de9faac8e2192fa333bce05b160799f87fefa9c339f` | 定理八：联合尺度下的定量计数与负总量 | C | 缺随 delta 变化的 Toeplitz 负谱定量计数与迹估计，含 log(1/delta) 阈值及两个不同误差阶。 | none claimed | not run | toeplitz, negative-spectrum-refined |
| 119 | `d9aefe500d926d5c9ec8e40a4997df1371cfe837dc3a11f548b7a2cfcf99b6b7` | 定理 R1：方差控制低频干涉 | B | 逐点 cos 下界 1-u²/2 已库有；缺实际条件概率的归一化、二阶矩 v_n 与积分读出绑定，以及 v_n>0 的域条件。 | `Real.one_sub_sq_div_two_le_cos` (Mathlib/Analysis/SpecialFunctions/Trigonometric/Bounds.lean:123) | not run | first-bindings, gaussian-moments |
| 120 | `daba72e239c5a9bae6419c9ee7873c87de22293ae599a303dd3feeff596ed538` | 推论：全部标量矩受高斯基准控制 | C | 缺从实际全倾斜 Turan 不等式到全矩迭代、指数积分/级数交换及严格二次根域的整组绑定。 | none claimed | not run | gaussian-moments, special-polynomials |
| 121 | `dd585f94675a53aceed6592da3ad291d31505f93c47ec491c1b9bba0851ef5f7` | 定理五：一个显式的有限时长负证书 | C | 缺特定平滑试探向量的 Rayleigh 商与二阶符号余项的精确常数估计。 | none claimed | not run | toeplitz, negative-spectrum-refined |
| 122 | `deaf86853b1217a64e0283dae2f03f6aa847b19a5d16e68a95518b8caef0da80` | 定理九：最小修正维数与最小修正总量 | B | CFC 的正负部恒等式与非负性供应 K_- 可行修正；缺任意可行修正的秩和迹最优性两条下界，未把可行性当作最优性。 | `CFC.posPart_sub_negPart` (Mathlib/Analysis/SpecialFunctions/ContinuousFunctionalCalculus/PosPart/Basic.lean:77); `CFC.negPart_nonneg` (Mathlib/Analysis/SpecialFunctions/ContinuousFunctionalCalculus/PosPart/Basic.lean:147) | not run | fifth-bindings, negative-spectrum-refined |
| 123 | `df8445edb07e25e1e79b9efacc91d4900583fa229efe7706745af103ff1cb3f5` | 推论：线性尺度上的体积确实趋零 | C | 缺实际 HCIZ 双尺度局部一致极限及 S_d 收敛；指数/对数的极限运算不供应这些实际前置结论。 | none claimed | not run | special-polynomials, gaussian-moments |
| 124 | `e12105bf8ad122862f6fe04a1b4abe22b29365455992101560012d8a9cdf9f44` | 定理 T3：Gamma—整数分解 | C | 缺实际 theta 密度的换元、混合求和与概率密度识别；上游 Gamma 分布并不直接等于该指定模型。 | none claimed | not run | theta-analytic, gaussian-moments |
| 125 | `e17855c9db943466019087527afd9e178fa5c465197a1a9de44490e5fa8444b2` | 定理 J4：残差的精确极限 | C | 缺允许 Jordan 块的统一残差上界与实际高斯流单调性；一般谱定理不覆盖非正规矩阵的这个构造。 | none claimed | not run | negative-spectrum-refined, gaussian-moments |
| 126 | `e405a7f40fa7ee5313052263686a73c8b8578d18290d1f429cb1826603f82480` | 定理一：首次返回概率具有精确的逐步守恒账目 | A | 一维单位向量投影公式、正交投影勾股恒等式和 Finset.sum_range_sub' 直接给完整结论；探针实际定义 QU 的迭代，没有将所求递推式放入假设。sum_range_sub' 由所引行 prod_range_div' 的 to_additive 生成。 | `Submodule.starProjection_unit_singleton` (Mathlib/Analysis/InnerProductSpace/Projection/Basic.lean:417); `Submodule.norm_sq_eq_add_norm_sq_starProjection` (Mathlib/Analysis/InnerProductSpace/Projection/Basic.lean:557); `Submodule.starProjection_orthogonal` (Mathlib/Analysis/InnerProductSpace/Projection/Basic.lean:209); `Finset.sum_range_sub'` (Mathlib/Algebra/BigOperators/Group/Finset/Basic.lean:903) | Return126: 0 | sixth-projection-null, unitary-involution |
| 127 | `e44ad50e6f818d656b6b3b1318b466ef65b9d4fe363f0d70d2f988ffda11c865` | 定理二：RH 等价于这个实际边界函数的收缩性 | B | Schwarz 引理直接给 S(0)=0 后的加强模界；缺实际 S_xi 与 RH 的双向解析/收缩性桥，不能把任意 Schur 函数的结论当作该实际对象已属 Schur 类。 | `Complex.norm_le_norm_of_mapsTo_ball` (Mathlib/Analysis/Complex/Schwarz.lean:238) | not run | sixth-final-bindings, theta-analytic, toeplitz |
| 128 | `e5d2d285af1f22158b076150c40f53f7d8ce44d2a32dbf3093e84e39ae416c82` | 定理 M3：双尺度极限 | C | 缺实际谱幂和、Schur 展开与维数缩放相结合的可求和统一控制，及所给无限指数级数的双尺度极限。 | none claimed | not run | special-polynomials, gaussian-moments |
| 129 | `e608f6dc2b3e96087ebd63bf03573113e4862368d4ca9073b2e7e18b62f93d6a` | 定理十七：假设存在失稳时，有严格夹逼 | C | 缺实际 F_xi 失稳零点与正性首次触界之间的严格比较，特别是 a_geom<a_*<R0；普通连续性不供应这两个严格间隔。 | none claimed | not run | theta-analytic, toeplitz |
| 130 | `e6b6fecddb5eee0812a0243c4df590974799c2c4403225694671db7205f1e6a0` | 定理 L1：非负平方展开 | C | 缺酉群 HCIZ 积分的 Schur 字符展开、各阶系数平方表示与无限求和/积分交换。 | none claimed | not run | special-polynomials, gaussian-moments |
| 131 | `e9720c882324b7c79f984b3a679f76fadc56b24259982372cfb13ef034c4860a` | 定理 N4：离线根产生固定的负平方测试 | B | 有理数稠密性供应有限系数扰动的原料；缺隔离指定非实共轭对、消去其余大谱点并压低无限尾的负平方见证，以及该二次型对系数扰动的连续性绑定。 | `Rat.denseRange_cast` (Mathlib/Topology/Algebra/Order/Archimedean.lean:33) | not run | sixth-final-bindings, negative-spectrum-refined, special-polynomials |
| 132 | `ee425ea06616fd0f316f4ec675f08c194f1a322c66490006b88f876689118d41` | 定理 I2：有限观察空间的边界缺额 | C | 缺实际无界微分算子及其伴随的共同定义域、标量交换关系和不变子空间压缩恒等式；有限矩阵 Gram 正性不认证这个无限维历史残差等式。 | none claimed | not run | gaussian-moments, negative-spectrum-refined, sixth-final-bindings |
| 133 | `eeec54732cd5164f183f001e2f20aca1e7c3d82f7e60e2ae713bb6be62891335` | 定理 J1：历史方差演化 | C | 缺矩阵指数高斯积分的参数微分、分部积分与三项生成元的精确绑定。 | none claimed | not run | gaussian-moments, real-calculus |
| 134 | `ef6f54cb65d0244d86eb6429a06d130952605ede928d46583fdd5558ae1c0b90` | 定理 R4：相邻态严格正交 | B | 幺正反射保持内积，结合相反奇偶本征值即可给抽象正交；缺实际 L² 条件态、反射的等距实现及各 n 奇偶/归一化绑定，未核这组适配义务。 | `LinearIsometryEquiv.inner_map_map` (Mathlib/Analysis/InnerProductSpace/LinearMap.lean:120) | not run | sixth-final-bindings, unitary-involution |
| 135 | `efc75726d17ed8663b268d9d47e0616c4b92a0383da0261cb7c4c6c7f3b819d2` | 定理 L4：平方级数的精确指数率 | C | 缺 HCIZ/非负平方级数的精确大 r 指数率；最大项下界与全级数上界必须达到同一 Q_q。 | none claimed | not run | special-polynomials, gaussian-moments |
| 136 | `f19c5a47126f834bc6db65cd85562ee9c8c64fbe0f5db7868a89cc9f8713412b` | 定理八：历史绕行读数恢复实际对数导数的极点 | C | 缺该具体历史周期的分支校正、解析继续以及实际 zeta 对数导数全部极点的精确恢复。 | none claimed | not run | discrete-winding, logderiv-residue, theta-analytic |
| 137 | `f4f9b0a4df470ba2b4bf10beee83d880ad7f4b3f0386116c90457ebb5d0fe984` | 定理十：不使用 RH，也能排除两个实径向上的有限触界 | C | 缺实际 theta/ξ 比值在两条实径向上的无零点及正号证明，普通解析函数理论不识别这些实际符号。 | none claimed | not run | theta-analytic, toeplitz |
| 138 | `f62752ed0e3bef8ecf2a83bb81efd8d286d810248bbeb79696cb3710c0c3b1e5` | 定理 K1：这个历史读出是忠实的 | C | 缺该伴随矩阵与指定输出坐标的可观测性满秩，以及从矩阵指数全时读出为零提取前 d 阶导数的绑定。 | none claimed | not run | special-polynomials, sixth-topics |
| 139 | `f7638bdcf1e35350eda1b731d962c04911ac25c6a52343035a7db2a5bb04e456` | 定理三：临界处的有限历史间隙有双边幂律 | C | 缺符号有限阶零点与有限 Toeplitz Rayleigh 商间的双边定量谱估计，包括与 N 无关的正下界常数。 | none claimed | not run | toeplitz, negative-spectrum-refined |
| 140 | `f7ca82eaa0b6663d12c0bfd1a9ddf79bed9767d3db424fab41f9fc1bf4da0364` | 定理 R3：放大后的干涉极限 | C | 缺实际筛选密度的缩放高斯极限、指数矩统一尾界及从实紧集提升至复紧集的控制。 | none claimed | not run | gaussian-moments, theta-analytic |
| 141 | `f94e72b42f9e6da0084b96b95d047cefcf3467c62f9875897dd6b2e40f6d2e97` | 定理二：开放历史链的精确谱间隙 | C | 缺开放路径 Laplacian 的完整特征值/首正特征值计算，以及门序列的块对角酉规约；pathGraph 的组合定义不提供该谱公式。 | none claimed | not run | sixth-topics, negative-spectrum-refined |
| 142 | `fa8b4b6196fcba7e8ebb4dd83eb2eef163a13a0db12bf2d3c4701126f37ade22` | 定理 J5：该流全局存在、保谱，并与高斯历史等价 | B | 可逆矩阵共轭保持特征多项式已有；缺该微分流的全局解、准确耗散系数1/2、共轭路径构造与逐时刻高斯历史酉等价。 | `Matrix.charpoly_units_conj` (Mathlib/LinearAlgebra/Matrix/Charpoly/Basic.lean:285) | not run | sixth-topics, gaussian-moments |
| 143 | `fad0a54d7c08517061dd72156313f2d20793a832d69377d4b2c6ccafb4a15a71` | 定理 O3：负特征值的精确计数 | C | 缺无限算子负指标的双向精确计数：各共轭对负方向构造、独立性和不多于该对数的上界。 | none claimed | not run | negative-spectrum-refined, special-polynomials |
| 144 | `fb1c38b64efe553d45ac383d0721cd76c7b64279dcff96cd63865be615fbdfb5` | 引理：三角读出的单侧上界 | C | 缺该具体权重的 Mellin/Dirichlet 极点分析及从单侧界排除所有离线零点的 Tauber 型论证。 | none claimed | not run | theta-analytic, logderiv-residue |
| 145 | `fb59b24ac5caf7f843daafe640a109f5656d2c90a088f47e404bc07f5425aefc` | 定理 Q1：所有二次倾斜的 Turán 不等式 | C | 缺指定核对所有倾斜参数的严格矩比控制及精确系数 (2n-1)/(2n+1)；通用矩凸性不能给反向严格界。 | none claimed | not run | gaussian-moments, theta-analytic, special-polynomials |
| 146 | `fc7df336d8009cc2fb6b17b81726c35280f4a7c87df6b80aeb2ab2ed62148dc1` | 定理一：平滑后的所有有限阶矩阵具有统一正下界 | C | 缺实际 Fourier 系数的概率测度表示与 Poisson 核点态双边界传递至所有有限截面；一般 PSD 不供应严格统一下界。 | none claimed | not run | toeplitz, negative-spectrum-refined |
| 147 | `fe2435c31f17b225da1fc23447f6bc697da4eab605315d6d8611f1370db9369d` | 定理 T5：双副本补偿恒等式 | C | 缺实际 theta 种子补偿算子的双副本乘积恒等式及 Fourier 分部积分/微分交换，包括精确常数 pi²。 | none claimed | not run | theta-analytic, real-calculus |
| 148 | `fe32fa800185d6c61117be686cf2b1eca3bb051f168159cfafd23edb452fb19f` | 推论：细化读数几乎必然最终等于零 | B | 无原子测度下有限事件集测度为零已有；缺实际极限 Y_infty 的连续密度、嵌套窗口缩点及空窗口到 M_n=0 的绑定。正文使用有限 log p 集与极限点回避，不是 Borel-Cantelli 求和假设。 | `Set.Finite.measure_zero` (Mathlib/MeasureTheory/Measure/Typeclasses/NullSingletonClass.lean:79) | not run | sixth-projection-null, sixth-topics |
| 149 | `fed862d04754e331ffe1254aa2d4f4f01ae3fb08ffb349002952eee303bf8a3e` | 定理 S1：原来的 \(R_n(t)\) 是这些局部读数的特定加权平均 | B | Fubini 接口支持双副本积分次序交换；缺实际密度的可积性、Jacobian 为1的两模态换元、偶性折半及非零归一化分母的完整绑定。 | `MeasureTheory.integral_integral_swap` (Mathlib/MeasureTheory/Integral/Prod.lean:482) | not run | sixth-topics, theta-analytic |
| 150 | `ff41c11de3a485a3451a5788237056c9099133f734e8bf7b75a1240d6746dd85` | 定理四：闭环不相容的精确代价 | A | 取 a=U1*x,b=U2*x；Mathlib 范数平方展开后 field_simp/ring 配方，平方非负给全体 y 下界，加权中心取到。探针证明一般实内积空间的完整 IsLeast，复内积空间可限制标量至实数；初次失败和修复成功均归档。 | `norm_sub_sq_real` (Mathlib/Analysis/InnerProductSpace/Basic.lean:435); `norm_add_sq_real` (Mathlib/Analysis/InnerProductSpace/Basic.lean:409) | Endpoint150: 2; Endpoint150-v2: 0 | sixth-topics, sixth-projection-null, sixth-final-bindings |

## probe_runs

Logs ending in `.gz` are losslessly compressed complete stdout/stderr, including the command and final EXIT. The external Make prerequisite checks the temporary file through the canonical cache writer; the root `lean` recipe then runs unchanged.

- baseline: `make 'lean'`; EXIT=0; [log](tier3-mathlib-triage-0909/logs/baseline.log.gz); atoms .
- Readback75: `make '-f' 'Makefile' '-f' '/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/probe.mk' 'lean' 'PROBE=/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/Readback75.lean'`; EXIT=0; [log](tier3-mathlib-triage-0909/logs/Readback75.log.gz); atoms 7d5d9c72f7ad9abb794dd61d99e68ff5adc1271970f00e4a009b9e334680a0d2.
- Disk90: `make '-f' 'Makefile' '-f' '/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/probe.mk' 'lean' 'PROBE=/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/Disk90.lean'`; EXIT=2; [log](tier3-mathlib-triage-0909/logs/Disk90.log.gz); atoms 96902e5b1d0b9ac78c37f6c1f75fd1d5043bfd6c18f5e2451352b6fbc6977b46.
- Schur89: `make '-f' 'Makefile' '-f' '/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/probe.mk' 'lean' 'PROBE=/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/Schur89.lean'`; EXIT=0; [log](tier3-mathlib-triage-0909/logs/Schur89.log.gz); atoms 937abccd3570503c88aaac8b088e687e6f79db29ca9f67f887b72a028bd4f866.
- Disk90-v2: `make '-f' 'Makefile' '-f' '/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/probe.mk' 'lean' 'PROBE=/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/Disk90-v2.lean'`; EXIT=0; [log](tier3-mathlib-triage-0909/logs/Disk90-v2.log.gz); atoms 96902e5b1d0b9ac78c37f6c1f75fd1d5043bfd6c18f5e2451352b6fbc6977b46.
- Parity104: `make '-f' 'Makefile' '-f' '/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/probe.mk' 'lean' 'PROBE=/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/Parity104.lean'`; EXIT=0; [log](tier3-mathlib-triage-0909/logs/Parity104.log.gz); atoms b923baf16e3404ffc7143c8258cd778915ab93409a40512c8d156d065ed1f61a.
- Pick105: `make '-f' 'Makefile' '-f' '/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/probe.mk' 'lean' 'PROBE=/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/Pick105.lean'`; EXIT=0; [log](tier3-mathlib-triage-0909/logs/Pick105.log.gz); atoms bc9748938013e4b3c632bfa0e1257a59733df2e1682ed0a8a0d7a0dcc534ab2b.
- Endpoint150: `make '-f' 'Makefile' '-f' '/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/probe.mk' 'lean' 'PROBE=/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/Endpoint150.lean'`; EXIT=2; [log](tier3-mathlib-triage-0909/logs/Endpoint150.log.gz); atoms ff41c11de3a485a3451a5788237056c9099133f734e8bf7b75a1240d6746dd85.
- Endpoint150-v2: `make '-f' 'Makefile' '-f' '/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/probe.mk' 'lean' 'PROBE=/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/Endpoint150-v2.lean'`; EXIT=0; [log](tier3-mathlib-triage-0909/logs/Endpoint150-v2.log.gz); atoms ff41c11de3a485a3451a5788237056c9099133f734e8bf7b75a1240d6746dd85.
- Return126: `make '-f' 'Makefile' '-f' '/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/probe.mk' 'lean' 'PROBE=/private/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/tier3-mathlib-triage-0909/attempt-1/Return126.lean'`; EXIT=0; [log](tier3-mathlib-triage-0909/logs/Return126.log.gz); atoms e405a7f40fa7ee5313052263686a73c8b8578d18290d1f429cb1826603f82480.

## search_receipts

Full commands and untruncated hits: [search-receipts.json](tier3-mathlib-triage-0909/search-receipts.json). Counts are matching lines, including comments and imports, not distinct theorems.

| ID | Scope | Command | Matching lines | EXIT |
| --- | --- | --- | --- | --- |
| control-positive | D5 | `rg '-n' '-i' '-P' '\b(theorem|lemma)\s+(g2_discriminant_bound|sq_nonneg)\b' 'D5' '-g' '*.lean'` | 1 | 0 |
| control-positive | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '\b(theorem|lemma)\s+(g2_discriminant_bound|sq_nonneg)\b' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 1 | 0 |
| control-negative | D5 | `rg '-n' '-i' '-P' '\b(theorem|lemma)\s+(triage_absent_0909|triage_missing_0909)\b' 'D5' '-g' '*.lean'` | 0 | 1 |
| control-negative | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '\b(theorem|lemma)\s+(triage_absent_0909|triage_missing_0909)\b' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 0 | 1 |
| winding | D5 | `rg '-n' '-i' '-P' '(winding|argument.?principle|rouch)' 'D5' '-g' '*.lean'` | 293 | 0 |
| winding | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(winding|argument.?principle|rouch)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 0 | 1 |
| special-polynomials | D5 | `rg '-n' '-i' '-P' '(Jensen.polynomial|real.rooted|all.*roots.*real|Laguerre|Hermite|companion.*trace|trace.*companion)' 'D5' '-g' '*.lean'` | 270 | 0 |
| special-polynomials | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(Jensen.polynomial|real.rooted|all.*roots.*real|Laguerre|Hermite|companion.*trace|trace.*companion)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 89 | 0 |
| negative-spectrum | D5 | `rg '-n' '-i' '-P' '(negativeIndex|negative.index|negative.part.*trace|trace.*negative.part|trace.norm|TraceClass|Schatten|nuclear.norm)' 'D5' '-g' '*.lean'` | 94 | 0 |
| negative-spectrum | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(negativeIndex|negative.index|negative.part.*trace|trace.*negative.part|trace.norm|TraceClass|Schatten|nuclear.norm)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 53 | 0 |
| bandwidth | D5 | `rg '-n' '-i' '-P' '(bandwidth|banded|causal.cone|finite.propagation|interaction.order)' 'D5' '-g' '*.lean'` | 0 | 1 |
| bandwidth | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(bandwidth|banded|causal.cone|finite.propagation|interaction.order)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 0 | 1 |
| theta-analytic | D5 | `rg '-n' '-i' '-P' '(RiemannHypothesis|riemannXi|riemann.xi|Bessel|jacobiTheta|log.deriv.*zeta)' 'D5' '-g' '*.lean'` | 140 | 0 |
| theta-analytic | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(RiemannHypothesis|riemannXi|riemann.xi|Bessel|jacobiTheta|log.deriv.*zeta)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 321 | 0 |
| toeplitz | D5 | `rg '-n' '-i' '-P' '(Toeplitz|Szego|Szegő|trigonometric.polynomial|Fejer|Fejér|Carath[eé]odory|Schwarz.lemma)' 'D5' '-g' '*.lean'` | 588 | 0 |
| toeplitz | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(Toeplitz|Szego|Szegő|trigonometric.polynomial|Fejer|Fejér|Carath[eé]odory|Schwarz.lemma)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 273 | 0 |
| convex-local | D5 | `rg '-n' '-i' '-P' '(pyramid|four.pyramid|Zeckendorf.*(depth|local)|local.*(increment|successor)|convexHull.*(fin|insert))' 'D5' '-g' '*.lean'` | 17 | 0 |
| convex-local | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(pyramid|four.pyramid|Zeckendorf.*(depth|local)|local.*(increment|successor)|convexHull.*(fin|insert))' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 85 | 0 |
| partial-trace | D5 | `rg '-n' '-i' '-P' '(partialTrace|partial.trace|clock.*(density|reduced)|history.*(Gram|Toeplitz))' 'D5' '-g' '*.lean'` | 85 | 0 |
| partial-trace | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(partialTrace|partial.trace|clock.*(density|reduced)|history.*(Gram|Toeplitz))' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 0 | 1 |
| gaussian-moments | D5 | `rg '-n' '-i' '-P' '(gaussian.*moment|moment.*gaussian|subGaussian|moment_le|cos.*sq.*two|integral_eq_sub_of_hasDerivAt)' 'D5' '-g' '*.lean'` | 31 | 0 |
| gaussian-moments | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(gaussian.*moment|moment.*gaussian|subGaussian|moment_le|cos.*sq.*two|integral_eq_sub_of_hasDerivAt)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 221 | 0 |
| discrete-winding | D5 | `rg '-n' '-i' '-P' '(finite.difference|forwardDiff|iteratedFwdDiff|monodromy|cycle.*zeta|period.*winding)' 'D5' '-g' '*.lean'` | 111 | 0 |
| discrete-winding | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(finite.difference|forwardDiff|iteratedFwdDiff|monodromy|cycle.*zeta|period.*winding)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 102 | 0 |
| negative-spectrum-refined | D5 | `rg '-n' '-i' '-P' '(\bTraceClass\b|\bSchatten\b|negative.part.*trace|trace.*negative.part|traceNorm|trace_norm)' 'D5' '-g' '*.lean'` | 94 | 0 |
| negative-spectrum-refined | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(\bTraceClass\b|\bSchatten\b|negative.part.*trace|trace.*negative.part|traceNorm|trace_norm)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 0 | 1 |
| first-bindings | D5 | `rg '-n' '-i' '-P' '\b(theorem|lemma)\s+(inner_map_map|one_sub_sq_div_two_le_cos|integral_eq_sub_of_hasDerivAt|dist_le_mul_div_pow_of_mapsTo_ball_of_isLittleO|fwdDiff_iter_degree_eq_factorial|fwdDiff_iter_eq_zero_of_degree_lt)\b' 'D5' '-g' '*.lean'` | 0 | 1 |
| first-bindings | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '\b(theorem|lemma)\s+(inner_map_map|one_sub_sq_div_two_le_cos|integral_eq_sub_of_hasDerivAt|dist_le_mul_div_pow_of_mapsTo_ball_of_isLittleO|fwdDiff_iter_degree_eq_factorial|fwdDiff_iter_eq_zero_of_degree_lt)\b' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 5 | 0 |
| schur | D5 | `rg '-n' '-i' '-P' '(fromBlocks.*pos|pos.*fromBlocks|schur|det_fromBlocks|det_mul)' 'D5' '-g' '*.lean'` | 165 | 0 |
| schur | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(fromBlocks.*pos|pos.*fromBlocks|schur|det_fromBlocks|det_mul)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 213 | 0 |
| real-calculus | D5 | `rg '-n' '-i' '-P' '(integral_Ioi_of_hasDerivAt|integral.*inv.*jensen|map_integral_le|exists_rat|denseRange_ratCast)' 'D5' '-g' '*.lean'` | 22 | 0 |
| real-calculus | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(integral_Ioi_of_hasDerivAt|integral.*inv.*jensen|map_integral_le|exists_rat|denseRange_ratCast)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 143 | 0 |
| q-combinatorics | D5 | `rg '-n' '-i' '-P' '(q.multinomial|qMultinomial|GaussianBinomial|gaussianBinomial|q.binomial|cyclotomic.*multiplicity|sum_involution|sum.*involut)' 'D5' '-g' '*.lean'` | 20 | 0 |
| q-combinatorics | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(q.multinomial|qMultinomial|GaussianBinomial|gaussianBinomial|q.binomial|cyclotomic.*multiplicity|sum_involution|sum.*involut)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 18 | 0 |
| unitary-involution | D5 | `rg '-n' '-i' '-P' '(IsSelfAdjoint.*(exp|cos|sin)|exp.*(unitary|Unitary)|isUnitary.*(exp|cos|sin)|involuti.*unitary)' 'D5' '-g' '*.lean'` | 3 | 0 |
| unitary-involution | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(IsSelfAdjoint.*(exp|cos|sin)|exp.*(unitary|Unitary)|isUnitary.*(exp|cos|sin)|involuti.*unitary)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 95 | 0 |
| second-bindings | D5 | `rg '-n' '-i' '-P' '\b(theorem|lemma)\s+(cos_sq_add_sin_sq|det_mul|exists_rat_btwn|antitoneOn_of_deriv_nonpos|integral_Ioi_of_hasDerivAt_of_tendsto|ConvexOn\.map_integral_le)\b' 'D5' '-g' '*.lean'` | 0 | 1 |
| second-bindings | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '\b(theorem|lemma)\s+(cos_sq_add_sin_sq|det_mul|exists_rat_btwn|antitoneOn_of_deriv_nonpos|integral_Ioi_of_hasDerivAt_of_tendsto|ConvexOn\.map_integral_le)\b' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 9 | 0 |
| third-bindings | D5 | `rg '-n' '-i' '-P' '(norm_charFun_le_one|norm_starProjection_le|norm_orthogonalProjectionOnto_le|norm_sq_eq_add_norm_sq_starProjection|descFactorial_pos|coeff_monomial|sum_involution)' 'D5' '-g' '*.lean'` | 21 | 0 |
| third-bindings | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(norm_charFun_le_one|norm_starProjection_le|norm_orthogonalProjectionOnto_le|norm_sq_eq_add_norm_sq_starProjection|descFactorial_pos|coeff_monomial|sum_involution)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 197 | 0 |
| trial-division | D5 | `rg '-n' '-i' '-P' '(FRACTRAN|trial.division|trialDivision|divisor.*instruction|instruction.*divisor)' 'D5' '-g' '*.lean'` | 0 | 1 |
| trial-division | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(FRACTRAN|trial.division|trialDivision|divisor.*instruction|instruction.*divisor)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 0 | 1 |
| polynomial-readback | D5 | `rg '-n' '-i' '-P' '(readback|回读|Jensen.*coeff|coeff.*Jensen|falling.factorial|q.multinomial)' 'D5' '-g' '*.lean'` | 38 | 0 |
| polynomial-readback | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(readback|回读|Jensen.*coeff|coeff.*Jensen|falling.factorial|q.multinomial)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 3 | 0 |
| logderiv-residue | D5 | `rg '-n' '-i' '-P' '(residue.*logDeriv|logDeriv.*residue|logDeriv.*order|order.*logDeriv)' 'D5' '-g' '*.lean'` | 27 | 0 |
| logderiv-residue | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(residue.*logDeriv|logDeriv.*residue|logDeriv.*order|order.*logDeriv)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 6 | 0 |
| finite-geometry | D5 | `rg '-n' '-i' '-P' '(schur_complement_eq₂₂|div_neg_iff_of_pos_right|mul_neg_iff_of_pos_left|sub_conj|trace_conjTranspose_mul_self|trace_mul_self|inner.*trace|trace.*inner)' 'D5' '-g' '*.lean'` | 121 | 0 |
| finite-geometry | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(schur_complement_eq₂₂|div_neg_iff_of_pos_right|mul_neg_iff_of_pos_left|sub_conj|trace_conjTranspose_mul_self|trace_mul_self|inner.*trace|trace.*inner)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 21 | 0 |
| fourth-bindings | D5 | `rg '-n' '-i' '-P' '(coeff_rescale|rescale_coeff|det_vandermonde_ne_zero_iff|Unitary.star_mul_self|star_mul_self_of_mem|sum_mul_sq_le_sq_mul_sq|sum_mul_sq_le|cardFactors_mul|liouville_apply_mul|normSq_inv)' 'D5' '-g' '*.lean'` | 41 | 0 |
| fourth-bindings | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(coeff_rescale|rescale_coeff|det_vandermonde_ne_zero_iff|Unitary.star_mul_self|star_mul_self_of_mem|sum_mul_sq_le_sq_mul_sq|sum_mul_sq_le|cardFactors_mul|liouville_apply_mul|normSq_inv)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 47 | 0 |
| fifth-bindings | D5 | `rg '-n' '-i' '-P' '(sectionalCurvature|sectional.curvature|warped.product|WarpedProduct|exists_deriv_eq_zero|sum_roots.*sq|sum_roots_eq|coeff.*trace|trace.*coeff|posPart_sub_negPart|negPart_nonneg)' 'D5' '-g' '*.lean'` | 65 | 0 |
| fifth-bindings | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(sectionalCurvature|sectional.curvature|warped.product|WarpedProduct|exists_deriv_eq_zero|sum_roots.*sq|sum_roots_eq|coeff.*trace|trace.*coeff|posPart_sub_negPart|negPart_nonneg)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 66 | 0 |
| fifth-reweighting | D5 | `rg '-n' '-i' '-P' '(integral_div|card_roots_le_derivative|coeff_derivative|schur_complement_eq₂₂|cardFactors_mul)' 'D5' '-g' '*.lean'` | 46 | 0 |
| fifth-reweighting | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(integral_div|card_roots_le_derivative|coeff_derivative|schur_complement_eq₂₂|cardFactors_mul)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 121 | 0 |
| frozen-content-caveat | Golden/Frozen/state | `rg '-n' '-P' 'NormalizedJensenDegreeLowering' 'Golden/Frozen/state'` | 0 | 1 |
| frozen-path-positive | Golden/Frozen/state | `rg '--files' 'Golden/Frozen/state' '-g' '*MatrixTracePowerSum*'` | 1 | 0 |
| frozen-path-negative | Golden/Frozen/state | `rg '--files' 'Golden/Frozen/state' '-g' '*TriageMissing0909*'` | 0 | 1 |
| frozen-jensen-path | Golden/Frozen/state | `rg '--files' 'Golden/Frozen/state' '-g' '*NormalizedJensenDegreeLowering*'` | 1 | 0 |
| sixth-topics | D5 | `rg '-n' '-i' '-P' '(Borel.Cantelli|measure_limsup|ae_eventually|integral.*odd|Odd.*integral|path.*spectr|spectr.*path|laplacian.*path|path.*laplacian|charpoly.*conj|charpoly.*similar|integral_integral_swap|norm_sub_sq_real)' 'D5' '-g' '*.lean'` | 52 | 0 |
| sixth-topics | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '(Borel.Cantelli|measure_limsup|ae_eventually|integral.*odd|Odd.*integral|path.*spectr|spectr.*path|laplacian.*path|path.*laplacian|charpoly.*conj|charpoly.*similar|integral_integral_swap|norm_sub_sq_real)' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 120 | 0 |
| sixth-projection-null | D5 | `rg '-n' '-i' '-P' '\b(norm_sq_eq_add_norm_sq_starProjection|starProjection_unit_singleton|starProjection_orthogonal|prod_range_div|measure_zero|norm_sub_sq_real)\b' 'D5' '-g' '*.lean'` | 26 | 0 |
| sixth-projection-null | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '\b(norm_sq_eq_add_norm_sq_starProjection|starProjection_unit_singleton|starProjection_orthogonal|prod_range_div|measure_zero|norm_sub_sq_real)\b' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 61 | 0 |
| sixth-final-bindings | D5 | `rg '-n' '-i' '-P' '\b(Rat\.denseRange_cast|norm_le_norm_of_mapsTo_ball|inner_map_map|posSemidef_conjTranspose_mul_self|norm_add_sq_real|charpoly_units_conj)\b' 'D5' '-g' '*.lean'` | 27 | 0 |
| sixth-final-bindings | .lake/packages/mathlib/Mathlib | `rg '-n' '-i' '-P' '\b(Rat\.denseRange_cast|norm_le_norm_of_mapsTo_ball|inner_map_map|posSemidef_conjTranspose_mul_self|norm_add_sq_real|charpoly_units_conj)\b' '.lake/packages/mathlib/Mathlib' '-g' '*.lean'` | 61 | 0 |

The positive and negative controls share case-insensitivity, alternation, word boundaries and whitespace matching. The initial `negative-spectrum` query matched `registerTraceClass` (logging infrastructure); the refined word-boundary query excludes this false positive. Generic Caratheodory measure hits are not Toeplitz spectral theorems.

Frozen state JSON stores only `statement_id`; module names must be located through filenames. An initial content-only zero hit was invalid for that purpose. The corrected path search, controls and exact registry read are preserved.

## repository_leads

- `D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering`, `sha256:ee43a04a542df25237818cbfeeb29bb1abaed956f90db04822d08e8f413d50b4`: `D5.S3.Zeros.Jensen.NormalizedJensenDegreeLowering.source_jensen_degree_lowering`, D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering.lean:136. Frozen identity for the fixed theta-density P_d at d>=2 and arbitrary complex v. This is not a q_d reciprocal-coordinate derivative or a real-rootedness theorem. No probe imports this dependency.

## unscreened

[]

## pushed.commits

- `c8ba70a54e9b859185515602015f630d89019ae9`
- `6009dcbe96888c3ca23ad3e331da2efec04b9452`
- `dad8e18532ec0063093aad820e8bd4b4c8cf80dc`
- `e77cf4009e6801e994e5bfff59a6b124c61ae292`
- `fcbe1bf4be3d38a2324acb6d7b392c46919c280b`
- `134dc1f58721e6c7555355cc0d7c6e2f29100376`
- `0bce26792dcc213354e1d279a96e52e44b711c98`
- `43dc167e1f7ccfbb80f9edd18a5ca48bbc94a4d0`
- `f9334cdd41556baa415a2d3ccb369c7f248fee87`
- `047b934232c4af2ade19c4c4c2aeba52bf60edb2`
- `04be1e7a603eeca9c364c70bd8c17be0530256d6`
- `5408df1bd556f4426487cce03b82b5b239b82454`
- `d85d63b1763bbd197a317496845b18d5f5de7dab`

Every listed checkpoint was pushed successfully. The final runner envelope includes the commit containing this final report (a commit cannot contain its own hash).

## assumed_unverified

- No unprobed source assertion is kernel certified.
- No third-party online search or independent review was performed.
- C is bounded-search formalization-gap evidence, not proof of library-wide absence.
- The total duration was not supplied; 120 minutes is an explicitly disclosed working assumption.

## Nonclaims

- No production Lean module has been created or edited.
- No `make cover`, `make deposit`, digestion mutation, freeze, or PR is performed.
- No exhaustive repository, Mathlib, third-party, or literature search is claimed.
- A search miss is not proof that Mathlib contains no equivalent statement.
- No proof, provability, research novelty, or new implication to RH is claimed
  for unprobed atoms or for B/C candidates.
- Temporary probes only test the statements explicitly printed in their files;
  a passed subclaim cannot certify a larger source assertion.
