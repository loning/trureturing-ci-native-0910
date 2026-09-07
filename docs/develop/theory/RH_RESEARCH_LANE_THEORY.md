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
