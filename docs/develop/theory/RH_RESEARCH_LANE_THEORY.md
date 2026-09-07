- PR #5882 actual `CoerciveDualCertificate.lean` at `65339a3acbe99e661c6955dbb21728c4c62dfe76`; #6029 actual `WeilOrthogonalTrialPrecision.lean` at `a00b579d8202bc839cb780ee1159b2a49b0592e4`; loning #5326 actual theory at `3beb435bf9ca8aa35aa6079ea4033a9c2e6c9007`.


---

## [PR #5602] ORIGIN_NORMALIZATION_AND_DIVISOR_WINDOW_DICTIONARY

# 2026-09-07：原点归一化的真模态对应，以及 5040 因数数据的精确算子字典

本节有两个不同层次的交付。第一，实际重放完整算术对偶证书后，消去未知射影归一化，认证真实 ground 与真实 prolate 的原点归一化 Fourier 比较。第二，把 5040 研究中实际使用的有限因数载体提升为同一有限窗口上的算术作用，明确证明其对应条件和遗漏项。没有把 Robin 标量不等式当作 Weil 正性或谱间隔。

新 Lean 为 `WeilDivisorWindowCorrespondence.lean`，配套同名 Scribe，位于既有 `D5/S3/Weil/ZetaBridge` 路径。其六个公开声明使用原 `Nat.divisors`、`windowMellinSum` 和 `primeForward`。新程序为 `certify_prime3_origin_normalized.py`，另有 `test_divisor_window_correspondence.py` 及其实际结果。Lean elaboration、Scribe emission、传递公理审查均未执行；下面的算子 Euler 积与锐窗口边界是纸面证明，未混称为新 Lean 的结论。

## 1. 为什么改为原点归一化

保持上一节 c=3、a=log3/2、原实偶单位候选 k 和实际最低模态 u。记

\[
F(z)=\widehat u(z)/\alpha,\quad \alpha=\langle k,u\rangle\ne0,
\quad K(z)=\widehat k(z),\quad P(z)=\widehat v_P(z),
\]

其中 v_P=-p_h^+/||p_h^+|| 是此前同一个全局符号的真实单位 prolate 模型。原证书没有把 alpha 数值化。正确的下一步是证明 F(0)、P(0) 非零后，比较 F(z)/F(0) 和 P(z)/P(0)。两者分别严格等于

\[
\mathcal F(z)=\widehat u(z)/\widehat u(0),\qquad
\mathcal P(z)=\widehat p_h^+(z)/\widehat p_h^+(0).
\tag{ON1}
\]

全局相位、单位范数和 alpha 在同一函数的分子分母中代数消去。没有选择依赖 z 的归一化。若以后同一明确模型经正确尺度系数收敛到 Xi，且在原点也收敛到非零 Xi(0)，它的 (ON1) 就收敛到 Xi(z)/Xi(0)。这仅说明归一化的相容性，未在本节证明该尺度收敛。

## 2. 原点分母独立认证

原点代表元为窗口上的常数 1。令 Delta=U-ell、kappa=T-ell，沿用旧全空间强制性。零对偶试探给出

\[
|F(0)-K(0)|\le\delta_0:=
\sqrt{\Delta\{L-|K(0)|^2\}/\kappa}.
\tag{ON2}
\]

K(0)=sqrt(L)*s_0/sqrt(sum s_n^2)，其中 s_n 是固定候选整数坐标。保留实际负号，区间计算得到 K(0)=-0.8043944718...，delta_0=0.0064208260...，故

\[
\boxed{|F(0)|\ge|K(0)|-\delta_0>797/1000.}
\tag{ON3}
\]

实际 prolate 验证器重新执行完整模式隔离及无限尾。以原 Mellin 端点公式计算模型原点，并运输真实单位模型误差，得到 P(0)=-0.8050473131... 以及 |P(0)|>805/1000。只需要模长下界，无须假设任一人为选定方向在原点为正。

对任意 F0,K0 非零，有精确代数等式

\[
F(z)/F0-K(z)/K0=
\{F(z)-K(z)-(K(z)/K0)(F0-K0)\}/F0.
\tag{ON4}
\]

在上一节闭圆盘 D={|z-(20+i/4)|<=1/1000}，令 eps_D 为已重放的 ground/candidate 误差，d=H/1000 为同一代表元变化界。于是

\[
\sup_D|\mathcal F-K/K0|
\le\frac{\epsilon_D+(|K(z_0)|+d)\delta_0/|K0|}{|K0|-\delta_0}
<447/10^6.
\tag{ON5}
\]

真 prolate 原点误差同时进入 (ON4) 的第二次应用。中心模型差用精确 Mellin 端点积分计算；从中心到圆盘的运输作用在 k/K0-v_P/P0 上，使用

\[
\|k/K0-v_P/P0\|\le
\|k-v_P\|/|K0|+|K0-P0|/(|K0||P0|).
\]

得到 sup_D|K/K0-P/P0|<57/10^6。使用未粗化的两个区间相加，最终认证

\[
\boxed{\sup_{z\in D}|\mathcal F(z)-\mathcal P(z)|<51/100000,\qquad
\inf_{z\in D}|\mathcal F(z)|>43/100000.}
\tag{ON6}
\]

实际误差上预算约 0.00050309134556。它比先前单位模型/射影 ground 的数值更宽，且归一化不同；不把两者包装为直接精度改进。本节消除的是归一化中尚存的未知 alpha。旧完整 Weil Schur/LDL 下界未重跑；新程序实际重放能量对偶和真实 prolate 程序，再认证两处分母和全部归一化误差。

## 3. 从 5040 研究的同一因数载体出发

loning 研究的 `ZECKENDORF_EULER_5040.md` 定义 Z_N(s)=sum_(d|N)d^-s，且 Z_N(1)=sigma(N)/N。已读取实际 `GoldenCell5040Certificate.lean`：它构造六点 cell 的有理分析证书，5040 的 Robin 对数余量为负，其余五点的余量大于 1/100。还读取新 `PaddingRatio.lean`：补高一个有界素数指数取得相对 divisor-sum 增益；其概率质量逃逸消费者保留额外条件，未被本节当作 RH 定理。

在同一个窗口定义

\[
E_{a,N}^{\rm div}h(x)=1_{[-a,a]}(x)4e^{x/2}\sum_{d\mid N}h(de^x).
\]

取 N>0、整数 M>=exp(2a)，h(t)=0 于 t>exp(a)。令 R_(a,N,M)h 是同一公式中 1<=d<=M 且 d 不整除 N 的和。新 Lean 从实际支撑与因数集证明

\[
\boxed{E_{a,N}^{\rm div}h=E_{a,M}h-R_{a,N,M}h.}
\tag{DW1}
\]

证明不需要覆盖假设。窗口内 d>M 蕴含 d exp(x)>exp(a)，故较大因数项消失；其余实际因数恰为前缀中的整除 filter，和其补集一起分割原有限和。窗口外同一 indicator 使两边都为零。等式对任意复 seed 和全部实 x 成立，闭端点保持不变。

沿用原 `prime_forward_mellin_identity`，新 Lean 进一步证明

\[
\begin{aligned}
B_+E^{\rm div}h={}&E^{\rm div}((\log t)h)-XE^{\rm div}h\\
&+R((\log t)h)-XRh-B_+Rh.
\end{aligned}
\tag{DW2}
\]

因此，缺失项在原始函数及其实际 Lambda(n)/sqrt(n) 作用上都被完整保存。若每个 1<=d<=M 都整除 N，则 R 的实际索引集合为空，Lean 得到 Ediv=E；这个算术条件在 5040、2520 和 M=10 处由有限整除计算全部消去。

## 4. 精确的算子 Euler 积及 logarithmic derivative

以下为纸面算子证明。令 H_a=L2([-a,a])，对正整数 d 定义零延拓后压缩的前向平移 U_d f(x)=1_I(x)f(x+log d)。它们有范数<=1，并满足 U_d U_e=U_(de)：两个位移均非负，起点和终点在 I 内时，中间点也在 I 内。U_d=0 当 log d>=2a，等号仅剩一个零测端点。对 d>=2，U_d 因而是幂零算子。此处没有使用周期平移。

对复参数 s，令

\[
\mathcal D_{a,N}(s)=\sum_{d\mid N}d^{-s}U_d
=\prod_{p^e\Vert N}\sum_{j=0}^{e}(p^{-s}U_p)^j.
\tag{DW3}
\]

等式来自唯一素数分解和已证明的压缩平移乘法。所有局部因子为 I 加幂零算子，故对每个复 s 均可逆，其逆是有限多项式。于是负 logarithmic derivative 是合法的有界算子：

\[
\boxed{\mathcal L_{a,N}(s):=-\mathcal D'_{a,N}(s)\mathcal D_{a,N}(s)^{-1}
=\sum_{p^e\Vert N}\log p\sum_{j\ge1}
[1-(e+1)1_{(e+1)\mid j}]p^{-js}U_{p^j}.}
\tag{DW4}
\]

每个看似无穷的内和实际上在 p^j>=exp(2a) 后为零。证明对 Q=p^-s U_p 使用 G_e(Q)=(I-Q^(e+1))(I-Q)^-1，并计算 -G'_e G_e^-1=log p[Q/(I-Q)-(e+1)Q^(e+1)/(I-Q^(e+1))]。所有因子交换，乘积的 logarithmic derivative 可以相加。没有在标量零点处作除法，也没有假设标量 Z_N(s) 不为零。

取 f_h(x)=1_I(x)4exp(x/2)h(exp x)，则同一半密度精确给出

\[
\mathcal D_{a,N}(1/2)f_h=E_{a,N}^{\rm div}h.
\tag{DW5}
\]

若每个可见 p^j<exp(2a) 均整除 N，(DW4) 中的所有修正位移均不可见，得到

\[
\boxed{\mathcal L_{a,N}(1/2)=
\sum_{p^j<e^{2a}}\frac{\log p}{p^{j/2}}U_{p^j}=B_+.}
\tag{DW6}
\]

这是与原 Weil 素数作用的精确对应。Robin 标量在 s=1 取值，本式的 s=1/2 来自原 Weil 半密度，不能混用。Gamma 和 pole 部分不在 (DW6) 内。有限 Fourier 再压缩也不必保持 U_d U_e=U_de，因此先在原 H_a 上完成对应，再使用原来的完整耦合证书；不得把有限矩阵乘法自动视为同一个乘积。

## 5. 首个缺失素数幂给出锐的覆盖边界

对 N>0 令 q(N)=min{m>=2:m 不整除 N}。q(N) 必为素数幂：否则它的互素素数幂因子都更小，分别整除 N，合起来会使 q(N) 整除 N，矛盾。所有整数 d<exp(2a) 都整除 N，等价于 exp(2a)<=q(N)。因此 (DW6) 在

\[
\boxed{a\le\tfrac12\log q(N)}
\tag{DW7}
\]

精确成立。这个边界在算子意义下是锐的：超过它后，最小遗漏 p^(e+1) 的 (DW4)-B_+ 系数为 -(e+1)log(p)*p^(-(e+1)s)，且相应平移非零。有限个不同平移在窗口中线性独立，可用足够窄的支撑隔离最小非零项，故该差算子非零。e=0 包括完全缺失的素数。

若 N=p^e m、p 不整除 m，补高一步还给出具体差公式

\[
\boxed{\mathcal D_{a,pN}(s)-\mathcal D_{a,N}(s)
=p^{-(e+1)s}U_{p^{e+1}}\mathcal D_{a,m}(s).}
\tag{DW8}
\]

它说明补指数可以改变全局标量 divisor sum，同时在 exp(2a)<=p^(e+1) 的窗口中完全不可见。这是 PaddingRatio 所研究的同一指数操作在当前算术窗口中的对应，不能从相对标量增益直接推得算子下界。

## 6. 5040 的具体结论和限制

5040=2^4*3^2*5*7；2520=2^3*3^2*5*7。两者都包含 1 至 10 的全部因数，首个缺失整数均为 11。六点 golden cell 的六个整数也都如此。因此每个 carrier 的 (DW6) 都在 exp(2a)<=11 的 L2 窗口精确成立。新 Lean 的逐点实例采用稍强的 exp(2a)<=10，未把零测端点处理冒称为已形式化。

2520 与 5040 彼此的首个不同因数是 16，所以它们两套 divisor 算子相互相等的阈值可延伸到 exp(2a)<=16。这个“彼此相等”与“等于完整素数算子”的阈值 11 是两件事；11 以上它们可以共同遗漏原算术信息。

精确标量值 Z_2520(1)=26/7，Z_5040(1)=403/105，二者不同。六点 cell 的 Robin 余量也有不同符号，而在上述小窗口中它们给出相同的完整算术合成。因此小窗口等价不能恢复全部 Robin 余量，更不能把某一点的标量符号作为整个 Weil 形式的符号。

5040 在 Robin 判据中确实重要：RH 等价于所有 n>5040 满足 sigma(n)<exp(gamma)*n*loglog n。该等价判据可在 Banks-Hart-Moree-Nevans 的原始研究 arXiv:0710.2424 中核对。本节没有无条件宣称“5040 是全部自然数中的最后例外”，也没有证明该全称不等式。

可用于无界窗口的确定性 carrier 是 N_R=lcm(1,...,R)，或更冗余的 R!。每个 d<=R 均整除它，故任意固定窗口最终精确表示同一 B_+，并且 (DW1) 的缺失 seed 项最终为零。这个全尺度的算术表达不产生最低谱间隔或 uniform prolate 误差。若用大型 N_R 的标量范数粗界替代算子结构，仍可能丢失全部有用抵消。

## 7. 实际检查与研究边界

原点归一化 verifier 在 110、130 位定向区间精度均实际通过，重放前置实际算术对偶与真正 prolate 验证。原点初始方向未经假定；最终代码使用真实负原点值及其模长。工作精度不代表所有输入都有同等准确度，前置 bulk symbol 仍用其原来的向外舍入包络。没有新 eigensolver、zeta 值或零点数据。

精确诊断运行了 720 个有理乘法坐标/支撑/seed 例子，每例核对两条函数恒等式；960 个 Dirichlet logarithmic derivative 系数与独立 Euler 局部式逐项相等；另有两条符号复商恒等式、120 组有理商例子、300 个首缺失素数幂例子。5040 的 11 项缺失及 25 项负系数有明确失败对照：在 25 处有限 logarithmic derivative 的系数为 -log5，而原 B_+ 为 +log5。例子只是诊断，普遍性依赖上面的证明。

已读实际源码：loning 研究链 #6050 `GoldenCell5040Certificate.lean` at c5ea3ae9e24175119146686dac3b64d2aff9be4b；#6131 `PaddingRatio.lean` at bc79fbdf7e984037434eee40e852b5ef49abdb17；dev 的 `HiddenArithmeticWeightFormula.lean` 及 `ZECKENDORF_EULER_5040.md`。这些 PR 自报的编译状态未在本轮重放。主线保持 #5602 的实际算术定义，并按既有 #5882/#5895 的能量与归一化误差结构记账，没有新增通用 quotient 定理。

本节完成两个精确对应：有非零分母证据的原点归一化真模态比较，以及有限 divisor data 到原始 prime action 的函数级字典。仍未完成沿无界尺度的正交补强制性、对偶系数衰减、真实最低模态的 Xi 极限。Connes-Consani-Moscovici Sections 7-8 以及 Connes 2026 综述仍将模型极限与这些逼近要求分开，本节不把 carrier 的精确覆盖替代它们。

参考：

- Connes, Consani, Moscovici, *Zeta Spectral Triples*, arXiv:2511.22755v1, Sections 3-4 and 7-8. https://arxiv.org/html/2511.22755v1
- Connes, *The Riemann Hypothesis: Past, Present and a Letter Through Time*, arXiv:2602.04022v1, Sections 6.4-6.6. https://arxiv.org/html/2602.04022v1
- Banks, Hart, Moree, Nevans, *The Nicolas and Robin inequalities with sums of two squares*, arXiv:0710.2424, Monatsh. Math. 157 (2009). https://arxiv.org/abs/0710.2424
- Existing owners: `WeilMellinPrimeIntertwining`, `HiddenArithmeticWeightFormula`, #6050 and #6131 at the pinned sources above. Arithmetic coverage, finite products and logarithmic derivatives are classical tools; no mathematical priority is claimed.
