# Section cover screen, 2026-09-09

Lane: #6160. Digestion accounting: #5952. Stage: thinking, screening only.

Provenance: no skill invoked; one Codex worker, no independent review seats.
The orchestrator's Gribinski precedent and population counts are supplied inputs,
not new measurements by this worker. This report is a candidate assessment,
not a coverage edge or a proof of fidelity.

## Preregistration

Registered before candidate body inspection and mathematical searches at
2026-09-09T00:37:45Z. Repository baseline:
`b9994986f3ccd57821b99c2dfc8990333bb0b452`.
Branch: `lane/math/section-cover-screen-0909`.
`candidates.json` contains 164 entries and is a supplied, untracked input.

Stopping rules:

1. All 164 entries assigned exactly one tier: normal completion.
2. An explicit time budget exceeded while fewer than 82 entries are screened:
   stop and publish the completed subset plus every unscreened atom ID.
   The supplied task and tracked probe brief specify no numerical time budget;
   `budget_seconds = null`. No arbitrary budget is invented to shorten the task.
3. Any Lean edit, `make cover`, or `make deposit`: scope breach; stop immediately.

Tier criteria and ordering:

1. `frozen-covered`: every boxed assertion matches an actually read frozen
   declaration verbatim or by an explicit equivalence; no strengthened domain
   restrictions, added assumptions, lost quantifiers, or weakened conclusion.
2. `frozen-partial`: a read frozen declaration covers a named proper subset;
   explicitly list the remaining clauses or domain/quantifier mismatch.
3. `needs-lean`: an assertion with no matching frozen statement found in the
   recorded title and mathematical-content searches. This is bounded search
   evidence, not proof that no equivalent statement exists anywhere.
4. `not-an-assertion`: the actual atom body contains only narration, definitions,
   or a calculation report, with no truth-valued assertion. A theorem-like title
   or a boxed delimiter alone does not establish an assertion.
5. `unreadable`: missing/truncated body or insufficient context prevents judgment;
   state the precise reason. This does not mean mathematically unformalizable.

Within each tier, sort by atom ID; prioritize full matches for review, then partial
matches. Read atom bytes and, when necessary, source adjacency; title searches
are only discovery. Use `rg` or `git grep -P`, including positive and negative
controls with the same regex features, and record commands and matching-line
counts. Frozen membership requires the actual `Golden/Frozen/state/` JSON pin;
record GID, pin `statement_id`, and binder/domain restrictions, otherwise `none`.
For tier 1, record every boxed clause against Lean binders, assumptions, and
conclusions with `verbatim | equivalent | not-covered` labels; any not-covered
clause excludes tier 1. For covered projections record `proof_shape: bind-only`,
`escape_witness: null`, direct frozen dependencies, and screening-only admission
basis. No source recompilation or independent theorem is required for screening.

## Progress

Screened: 164 / 164. frozen-covered: 8; frozen-partial: 6; needs-lean: 150; not-an-assertion: 0; unreadable: 0.

All screened source bodies were read in full. The theorem-like headings are not treated as evidence by themselves. Source IDs are quantum-rh. Atom links point to immutable CAS bodies. The input bytes field is retained as supplied and is not used as a classifier.

Scope: state pins identify the module statement; theorem selectors are listed separately, not presented as independently pinned statement IDs. proof_shape describes the proposed use (direct projection/instantiation), not a new audit of the existing theorem's original proof. No new public theorem was produced; admission_basis is not applicable.

## Sorted Candidates

| Input # | Atom / title | Tier | Frozen GID or none | Reason / missing scope | Searches |
| ---: | --- | --- | --- | --- | --- |
| 9 | [088d882f6a10249e981da5d77bc3bb5e53e75a5ee02313bdd7c879cb21e22413](../../../Meta/Digestion/atoms/sha256/088d882f6a10249e981da5d77bc3bb5e53e75a5ee02313bdd7c879cb21e22413) ## 定理：5040 的共同价格区间 | frozen-covered | `D5/S3/Arith/GoldenResource5040PriceInterval` | 开价格区间、全体正整数、全局最大值和取等唯一性均与冻结陈述相符。 | S09 |
| 62 | [5f5912050d91b5f8998e6799d12c40e766fa4d65798ff890b506a56c3bc0ed3c](../../../Meta/Digestion/atoms/sha256/5f5912050d91b5f8998e6799d12c40e766fa4d65798ff890b506a56c3bc0ed3c) ### 定理十九：\((4,2,1,1)\) 是唯一的正整数四元组，使“局部自由度总和 = 完全联合自由度” | frozen-covered | `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance` | 冻结件给出完全相同的有序正整数四元组分类；加法等式反向及 0<d 与 1<=d 的转换不改变域。 | S43 |
| 66 | [66fd622e5d54c25826af9d416db18df1d8eecf9c71288d80ff0460237e3e95d2](../../../Meta/Digestion/atoms/sha256/66fd622e5d54c25826af9d416db18df1d8eecf9c71288d80ff0460237e3e95d2) ## 定理 G2　判别式的下界及其取等情形 | frozen-covered | `D5/S3/Zeros/Convolution/GribinskiDegreeTwo` | 冻结 G2 给出判别式恒等式、非严格下界和双重根输入的取等；输出判别式桥在源文相同 alpha 定义域成立。 | C+3, S48 |
| 77 | [7901adf784a2db15b73b33751c521fc703f8bbe431efb0304c449cfa3b049907](../../../Meta/Digestion/atoms/sha256/7901adf784a2db15b73b33751c521fc703f8bbe431efb0304c449cfa3b049907) ## 定理 G1　二次矩形卷积的显式系数 | frozen-covered | `D5/S3/Zeros/Convolution/GribinskiDegreeTwo` | G1 的全部二次系数和实参数排除条件与冻结声明一致；卷积含义采用已追加的乘积前因子勘误。 | C+2, C+3, S48 |
| 80 | [7b2657006891568aa395dfd9fa14bde9d9d23d2ade0c449b00f7cdf5c616baec](../../../Meta/Digestion/atoms/sha256/7b2657006891568aa395dfd9fa14bde9d9d23d2ade0c449b00f7cdf5c616baec) ## 定理二：什么时候投影后的几何能够独立执行？ | frozen-covered | `D5/S0/Rewriting/Quotients/DynamicsDescent` | 将观察的余域限制到 pi(X) 后映射自动满射；冻结的存在唯一下降 iff 保持纤维与源文存在下降 iff 保持纤维等价。 | S44 |
| 92 | [8ef6b9257471235dae81e95cd49a82d8589c77b60cfb90cd4d4355ed0ae75092](../../../Meta/Digestion/atoms/sha256/8ef6b9257471235dae81e95cd49a82d8589c77b60cfb90cd4d4355ed0ae75092) ## 定理 G3　Gribinski 猜想在 \(m=2\) 处成立 | frozen-covered | `D5/S3/Zeros/Convolution/GribinskiDegreeTwo` | 冻结 G3 的五个全称实参数、严格 alpha>-1 和两个存在非负实根与 boxed 断言一致。 | C+3, S48 |
| 121 | [c352d304105e02cbbcb0607e31a1e217adb85d4b344ba0d75c23ba4420dbf0e1](../../../Meta/Digestion/atoms/sha256/c352d304105e02cbbcb0607e31a1e217adb85d4b344ba0d75c23ba4420dbf0e1) ## 定理 U1：正拼接的必要充分条件 | frozen-covered | `D5/S3/Weil/ZetaLinear/ExactStickyReduction` | 冻结 Schur 能量正性等价式经复空间的实内积表达、交换块顺序和一维剩余能量 delta_N*\|z\|^2，恰为源 U1。 | S18, S32, S82 |
| 164 | [ff5edc2fa518d7aad2e434878eaed431d77462514fb23ba7bdbc47c5183d425e](../../../Meta/Digestion/atoms/sha256/ff5edc2fa518d7aad2e434878eaed431d77462514fb23ba7bdbc47c5183d425e) ## 定理 G4　参数范围 \(\alpha>-1\) 是锐的 | frozen-covered | `D5/S3/Zeros/Convolution/GribinskiDegreeTwo` | 两族反例的严格参数区间、指定输入、负常数项/负判别式及完整保非负根 iff alpha>-1 均有冻结声明。 | C+3, S48 |
| 10 | [0a350824194cd6312628fc5708116dfece7d0e63fec2a1e2f8c201549d63c707](../../../Meta/Digestion/atoms/sha256/0a350824194cd6312628fc5708116dfece7d0e63fec2a1e2f8c201549d63c707) ## 定理三：每一个连续时间切面的 Schmidt 系数都与 \(\theta\) 无关 | frozen-partial | `D5/S3/Quantum/Entanglement/CoherentHistorySchmidt` | 冻结件覆盖 theta=0 的分解、权重和中切 rank=12；未覆盖任意 theta 的相位历史。 | S10, S23 |
| 45 | [3f70bb4b78d38951e5b98029e96abb9e4d697c94e858de86ce861782dfe79bb9](../../../Meta/Digestion/atoms/sha256/3f70bb4b78d38951e5b98029e96abb9e4d697c94e858de86ce861782dfe79bb9) ### 定理十一：消去正的内部块，不丢失任何负方向 | frozen-partial | `D5/S3/Weil/ZetaLinear/ExactStickyReduction` | 实内积空间的 Schur 能量负指数相等已冻；源文复 Hermitian 惯性计数所需域桥未核实。 | S32, S18, S17 |
| 120 | [c3316916b643d8cf28de3e1b451f7f3ba61d1337f85a87b7eb42cc1568f9621f](../../../Meta/Digestion/atoms/sha256/c3316916b643d8cf28de3e1b451f7f3ba61d1337f85a87b7eb42cc1568f9621f) ## 定理：只使用 \(2,3,5,7\)，在 5040 之后不会产生 Robin 反例 | frozen-partial | `D5/S3/Arith/GoldenResource/RobinRationalBasis` | 只找到 n=10080=2^5*3^2*5*7>5040 的无条件严格 Robin 特例；无对所有非负指数的全族声明。 | S09, S72 |
| 129 | [d7dadd8de7fc5350a23612b4039fb0d44648a89b5231db1d0178b194dc965484](../../../Meta/Digestion/atoms/sha256/d7dadd8de7fc5350a23612b4039fb0d44648a89b5231db1d0178b194dc965484) ## 定理 T2：原函数的实际 Mellin 读数 | frozen-partial | `D5/S3/Analytic/CompletedZetaMellinReconstruction`; `D5/S3/Zeros/CompletedZeta` | 冻结 completed-zeta 的 Gamma 乘积式覆盖 boxed 链的右侧 xi/Gamma/zeta 等式；原函数积分 Z_+ 的识别未接上。 | S35, S88 |
| 144 | [eea26f8bf5160ec1c324b734ab436c6779a03fdf52687c5a6556c2d8a1878785](../../../Meta/Digestion/atoms/sha256/eea26f8bf5160ec1c324b734ab436c6779a03fdf52687c5a6556c2d8a1878785) ## 定理五：消去历史以后，还会产生一个新的边界度量 | frozen-partial | `D5/S3/Arith/GoldenResource/ChainSchurResponse` | 实矩阵且 z 实数时，冻结 inverse_first_order 经 E=-zI 规范化覆盖 Schur 一阶代数展开；未覆盖一般复域、M_eff 严格正定、指定 Delta 范数界及从谱隙到逆存在的连接。 | S18, S64, S75, S102 |
| 148 | [f00571cdc2a69c25cf050185dd4d2b3cb366d39dc5372f8921d94c26744775e1](../../../Meta/Digestion/atoms/sha256/f00571cdc2a69c25cf050185dd4d2b3cb366d39dc5372f8921d94c26744775e1) ## 定理一：三个合并切片的必要充分条件 | frozen-partial | `D5/S3/Weil/ZetaLinear/ExactStickyReduction` | ExactStickyReduction 可对源文显式 3x3 矩阵给出 iff 曲率平方界，并等价改写为绝对值界；尚缺实际导数 Gram J2 等于该显式矩阵的微分识别。 | S18, S32, S82, S97 |
| 1 | [028cb6a153eaec67ee356ef9571a406a6d9460c0092fbc031df4abab42884a85](../../../Meta/Digestion/atoms/sha256/028cb6a153eaec67ee356ef9571a406a6d9460c0092fbc031df4abab42884a85) ## 定理十一：有限多边形绕数证书 | needs-lean | none | 若每段严格误差界成立则矩形零点数等于多边形绕数；RoucheZeroCount 只给两个解析函数的零数相等，缺线性插值误差 Bh^2/8 与多边形绕数桥。 | S01 |
| 2 | [04174c1260762c6fb3fe24cd51b93eea78714592b4cd71e927db335d5edf8b77](../../../Meta/Digestion/atoms/sha256/04174c1260762c6fb3fe24cd51b93eea78714592b4cd71e927db335d5edf8b77) ## 定理 S2：实际 theta 条件读数存在负区 | needs-lean | none | 断言实际 theta-Wigner 读数存在严格负点及非零成功概率窗口；命中的有限离散 Wigner 接口不涉及此连续核。 | S02, S22 |
| 3 | [062d6f5a910eed117ab7596a2e34f1a6a0728de5e8599136b47689b29d2870c9](../../../Meta/Digestion/atoms/sha256/062d6f5a910eed117ab7596a2e34f1a6a0728de5e8599136b47689b29d2870c9) ### 定理二十：交互阶数具有离散因果锥 | needs-lean | none | 对所有离散 t>=0 和 \|r-s\|>Jt 的投影传播恒零；未找到这一交互阶数分级或带宽幂传播断言。 | S03, S25 |
| 4 | [0715d2f9078c88ee013814d101b0c36bdb33c5cf5ce76d58239e51cc6485df25](../../../Meta/Digestion/atoms/sha256/0715d2f9078c88ee013814d101b0c36bdb33c5cf5ce76d58239e51cc6485df25) ## 定理四：Toeplitz 矩阵是历史态的时钟约化密度矩阵 | needs-lean | none | 构造态后断言偏迹恰为 T_N/(N+1)；通用局部偏迹等价接口没有历史态、Toeplitz 元素及归一化等式。 | S04, S19 |
| 5 | [072eca25d260537060a5e1b2b7dada75dbf623eba8eebb4bad8c765d8ebe6749](../../../Meta/Digestion/atoms/sha256/072eca25d260537060a5e1b2b7dada75dbf623eba8eebb4bad8c765d8ebe6749) ## 定理 N1：有限负证书 | needs-lean | none | 任意实 q、任意实多项式 f 的伴随矩阵迹平方非负 iff 全部实根；已有有限根表 Newton-Hankel 判据，未找到整个 f(C_q)^2 陈述及任意 q 到根表的已冻桥。 | S05, S24-count |
| 6 | [0831062a074c8393d5e0d16a4caa4487d783311664ffa661ab52092973475c5b](../../../Meta/Digestion/atoms/sha256/0831062a074c8393d5e0d16a4caa4487d783311664ffa661ab52092973475c5b) ## 定理一：\(P\) 是一个四棱锥 | needs-lean | none | P 的精确凸集、底面与五个顶点是集合等式断言；未找到五个合法三位词凸包与所列不等式的同一声明。 | S06, S26 |
| 7 | [083b7658fb28ffb6609e6c46923ebd4e8c9c27dc3813f06187a0aa23c398e7d4](../../../Meta/Digestion/atoms/sha256/083b7658fb28ffb6609e6c46923ebd4e8c9c27dc3813f06187a0aa23c398e7d4) ## 定理一：规范加一的最坏局部深度至少与编码跨度成正比 | needs-lean | none | 对所有满足源局部性条件的加一算法，R*tau>=L-1 且奇 L 时>=L；已有加一正确性与顺序制备容量不能代替该局部时间下界。 | S07, S03, S25 |
| 8 | [087e3caa7c278b4ea58f06604daa8721ab5258f6c451a25ed8f2d0092d823ca0](../../../Meta/Digestion/atoms/sha256/087e3caa7c278b4ea58f06604daa8721ab5258f6c451a25ed8f2d0092d823ca0) ## 定理 B1：精确微分兼容关系 | needs-lean | none | 对每个 d>=2，q_d'=d*((d-1)/d)^(d-1)*q_(d-1)(x/alpha_d)；冻件是 J_d-v/d*J_d' 的降阶恒等式，未找到反转 q_d 后的导数声明。 | S08 |
| 11 | [0d2c6e9ed518bfcee93cc1f4b71877666e729b3db0f05d06a2b43bbf53e86984](../../../Meta/Digestion/atoms/sha256/0d2c6e9ed518bfcee93cc1f4b71877666e729b3db0f05d06a2b43bbf53e86984) ## 定理 L3：逐阶系数判据 | needs-lean | none | 全部实根 iff S_q>=0 且对每个 k>=1 有 b_(q,k)<=S_q^k/k!；Newton-Hankel 的有限二次型判据没有这条全阶系数界。 | S05, S11, S12, S27 |
| 12 | [0e1a7beb490fc5aece3b6e13b10c6523ab64fac627efd6b825dc5c5551af5eab](../../../Meta/Digestion/atoms/sha256/0e1a7beb490fc5aece3b6e13b10c6523ab64fac627efd6b825dc5c5551af5eab) ## 定理 K2：实根的历史体积上限 | needs-lean | none | 实根前件下所有 r>0 的 0<Z_q(r)<=1 与每阶交替导数非负；未找到实际高斯历史体积及完全单调声明。 | S11, S14, S27 |
| 13 | [0e8d9e20c8a7ec0e0820053dc56a9dae075722a110b78a0ecee60b5cb202f2d8](../../../Meta/Digestion/atoms/sha256/0e8d9e20c8a7ec0e0820053dc56a9dae075722a110b78a0ecee60b5cb202f2d8) ## 推论：系数增长率直接给出谱缺陷 | needs-lean | none | 系数 limsup 精确为 Q_q，并恢复所有虚部平方和；未找到 b_(q,k) 的指数率及两式相接的冻结件。 | S11, S12, S27 |
| 14 | [1033c98f6c47c1c95ba84c013ed594e604e96b5061d49672f6a3333ff411cb3a](../../../Meta/Digestion/atoms/sha256/1033c98f6c47c1c95ba84c013ed594e604e96b5061d49672f6a3333ff411cb3a) ## 定理 R5：筛选能量的精确公式 | needs-lean | none | 每个 n>=1 的精确能量 E_* n^2 Z_(n-1)/Z_n；命中无该筛选态和算子 K_0 的恒等式。 | S13, S14 |
| 15 | [10f086b0306c55830d4a16268948883d503cc3e347c5ebb45d89be2a6927fe3a](../../../Meta/Digestion/atoms/sha256/10f086b0306c55830d4a16268948883d503cc3e347c5ebb45d89be2a6927fe3a) ## 定理 P5：形状前件推出全部标量高斯矩上界 | needs-lean | none | 在形状前件 S 下递推矩界、双阶乘界及 chi4<=0 都是断言；SourceThetaMomentBounds 的 Gaussian majorant 不给以实际 m2 归一化的这些不等式。 | S14, S08 |
| 16 | [15eb12aed71ec186edbcd3e877571bdd32780f55e1539a8ff1211975db8f51c3](../../../Meta/Digestion/atoms/sha256/15eb12aed71ec186edbcd3e877571bdd32780f55e1539a8ff1211975db8f51c3) ## 定理一：前三阶在全局绝对收敛域内无零 | needs-lean | none | r=1,2,3 且 Re(s)>1 时 F_r(s)!=0；未找到这三个历史 Dirichlet 级数的无零声明。 | S15, S20 |
| 17 | [16ee2a6dfb3840e47529bdbd48187c9167a2230d63a5ac51826e62a979baf1ff](../../../Meta/Digestion/atoms/sha256/16ee2a6dfb3840e47529bdbd48187c9167a2230d63a5ac51826e62a979baf1ff) ## 定理五：固定分离度需要足够长的时间 | needs-lean | none | 所有 N、delta 的精确 N(N+2)/12 重叠界及 eta<1 的必要时间界；有限通道 fidelity 结果没有该等幅时钟族和常数。 | S16, S04 |
| 18 | [183d1842d5f7033b150a150210195c78562694a2c239a984aea1f5b7f86ec009](../../../Meta/Digestion/atoms/sha256/183d1842d5f7033b150a150210195c78562694a2c239a984aea1f5b7f86ec009) ## 定理 P1：有限尺度变化保留负方向，但可以任意压低其数值 | needs-lean | none | 所有 q>0 的负惯性相等、迹范数及负迹 q^2 上界；未找到此无限阶尺度变换的三个算子结论，有限 Sylvester 惯性不能覆盖整个断言。 | S17 |
| 19 | [19d4c054e92739f02edd10bc8c8cade6a616e273f45552e1f9e1da08359a6462](../../../Meta/Digestion/atoms/sha256/19d4c054e92739f02edd10bc8c8cade6a616e273f45552e1f9e1da08359a6462) ## 定理四：实际正性会在解析性失效之前先碰到边界 | needs-lean | none | 实际阈值严格链 0<a_*<R0<1；未找到定义这些实际阈值并证明严格先后次序的冻结声明。 | S18, S19 |
| 20 | [1ad5bec02ef18c7e44f7099ba5b17703e14dbfd047be51ab11ee29d6d17dfa0e](../../../Meta/Digestion/atoms/sha256/1ad5bec02ef18c7e44f7099ba5b17703e14dbfd047be51ab11ee29d6d17dfa0e) ## 定理六：ξ 历史态的统一有效维数界 | needs-lean | none | RH 下所有 N>=0 的 c0^2/[2(c0-c1)] 有效维数界和 rank(T_N)=N+1；未找到实际 xi 系数版本，两者均未接上。 | S16, S19 |
| 21 | [1ba55c6c1a84a3ff33ceebbcb3a7c7d52c48d18a1823c4354d954afe0d3aee38](../../../Meta/Digestion/atoms/sha256/1ba55c6c1a84a3ff33ceebbcb3a7c7d52c48d18a1823c4354d954afe0d3aee38) ### 定理十八：有限历史形成负证书的一个必要条件 | needs-lean | none | 正背景 b>0、负底 -M、负方向前件推出严格 (N+1)nu(E)>b/(b+M)；有限秩 concentration 定理的谱阈值计数前件不是此 Toeplitz 断言。 | S19, S17 |
| 22 | [1e414ffb45d7fcaa9536a956298c4e291f91a2e310f112d2cf8419518caefd1a](../../../Meta/Digestion/atoms/sha256/1e414ffb45d7fcaa9536a956298c4e291f91a2e310f112d2cf8419518caefd1a) ## 推论 B1.1：高阶延拓是一项带常数的积分问题 | needs-lean | none | 不是纯定义：q_d=积分 R_d+明确 beta_d 为断言；现有 normalized Jensen 降阶式未给反转多项式的积分常数公式。 | S08 |
| 23 | [1e9daffd76d1ac95768ad7e9737ce9069f71ca9d5406430f42768de16be0a86c](../../../Meta/Digestion/atoms/sha256/1e9daffd76d1ac95768ad7e9737ce9069f71ca9d5406430f42768de16be0a86c) ## 定理二：局部数据的受控整体拼接 | needs-lean | none | 所有 M>N 与 \|z\|<=r<1 的一致 2r^(N+1) 拼接界；未找到 Schur 迭代 g^[N] 的同一误差声明。 | S18 |
| 24 | [1eecc9129a67c60825a86b1efaa93284267df6701e12127565d8873086de3021](../../../Meta/Digestion/atoms/sha256/1eecc9129a67c60825a86b1efaa93284267df6701e12127565d8873086de3021) ## 定理三：统一非退化界 | needs-lean | none | Re(s)>1/2 时两项严格 2/5 下界，加 M>=1、sigma>1/3 的尾界；无匹配 W3 的系数、域及常数声明。 | S15, S20 |
| 25 | [207bdea6c00dc779749029d64849d7221c08cad532ac5d38069d8871e87b4d92](../../../Meta/Digestion/atoms/sha256/207bdea6c00dc779749029d64849d7221c08cad532ac5d38069d8871e87b4d92) ### 定理七：固定越界量下的负方向密度 | needs-lean | none | 固定小 delta 的两个 N->infinity 极限及再令 delta->0 的渐近式；CanonicalTransfer 仅为有限 SU(1,1) 传递矩阵，非 Szego 谱分布极限。 | S19 |
| 26 | [224b9dc2f29a8182291ff077025c0f1cf83c02aeb844e2893366013f04898914](../../../Meta/Digestion/atoms/sha256/224b9dc2f29a8182291ff077025c0f1cf83c02aeb844e2893366013f04898914) ## 定理 D2：正实现的最低读数失配 | needs-lean | none | m=d-1 个采样、Im(z_j)>=h>0、lambda_min=-nu<0 推出 epsilon>=h*nu/m；未找到实际采样误差与负谱的定量桥。 | S21 |
| 27 | [23e85e40204222cb3bee95c5c9072bd75f3796b82d41f908f8629d8a201137b9](../../../Meta/Digestion/atoms/sha256/23e85e40204222cb3bee95c5c9072bd75f3796b82d41f908f8629d8a201137b9) ## 定理七：任意周期的离散绕行公式 | needs-lean | none | 对任意周期 d 的 (d-1) 阶精确绕行差分及 d 阶湮灭；已有零点几何 monodromy 未识别 H_d、W_d 与全部阶数。 | S20 |
| 28 | [247c5740e6ce2838bb73fce435941602825eace40b67c44c62f23f45796e0b04](../../../Meta/Digestion/atoms/sha256/247c5740e6ce2838bb73fce435941602825eace40b67c44c62f23f45796e0b04) ## 定理 S3：完整的算术展开 | needs-lean | none | 所有 x>=0、实 t 的 theta-Wigner Bessel 算术展开且绝对收敛；唯一 Bessel 字面命中是无关 Hilbert 路径，内容检索也无该展开。 | S02, S22 |
| 29 | [24e7f65c67cec1074a6af47cd138dda33f014adcc2b6d569e14823c62aadc6ea](../../../Meta/Digestion/atoms/sha256/24e7f65c67cec1074a6af47cd138dda33f014adcc2b6d569e14823c62aadc6ea) ## 定理二：精确的历史奇偶筛选 | needs-lean | none | 对任意占据数族按奇数分量数分两支给出 Q_a(-1)；普通 multinomial 计数未覆盖 q=-1 的相消恒等式。 | S23 |
| 30 | [2664266b147343a4836824aae0348abd88a5ef821e178a073f2b6e8b8fe91a0d](../../../Meta/Digestion/atoms/sha256/2664266b147343a4836824aae0348abd88a5ef821e178a073f2b6e8b8fe91a0d) ## 定理 E3：同样构造单调上界 | needs-lean | none | 定义 U_N 后断言 Delta<=U_(N+1)<=U_N；未找到该 4H^(1)+H^(2) 逆矩阵构造及单调上界。 | S24-count |
| 31 | [27065ff2e7fd688eaed358a1953fc8fec5b4a98870cdeee7317e43e4c228d6e6](../../../Meta/Digestion/atoms/sha256/27065ff2e7fd688eaed358a1953fc8fec5b4a98870cdeee7317e43e4c228d6e6) ## 定理三：联合极限具有一条明确的过渡曲线 | needs-lean | none | 两项联合极限的精确常数 2*kappa/c0 与 (2*kappa-c0)/(2*kappa+c0)；未找到 F_G、S_G 的该双尺度极限声明。 | S27, S31, S34 |
| 32 | [2bc63109d666c92a11aa641dbeae45bc08e3f4f939bc5ce4406a75e5d86d03b6](../../../Meta/Digestion/atoms/sha256/2bc63109d666c92a11aa641dbeae45bc08e3f4f939bc5ce4406a75e5d86d03b6) ## 定理 B3：一步正延拓的精确判据 | needs-lean | none | 在有限前件下正实根 iff 全部 eta>=0，并构造正定箭头矩阵且特征多项式=q_d；未找到该 eta 残数条件与箭头实现。 | S28, S05, S08 |
| 33 | [2bcdc03e5777fcc1c396e5b07b17101c3f52508fb80a62a55e3b96a0b66158f2](../../../Meta/Digestion/atoms/sha256/2bcdc03e5777fcc1c396e5b07b17101c3f52508fb80a62a55e3b96a0b66158f2) ## 定理 T4：指数位移分解 | needs-lean | none | sigma>1、独立指数变量 E_(sigma-1) 下 X_sigma 与 Y_sigma-E 同分布；未找到该实际 Mellin 随机变量的卷积分解。 | S29, S35 |
| 34 | [2c37bff2d8f941ea92b5c037c21e6d179a2ab8fe3a67836b6ecb5b2e766793e7](../../../Meta/Digestion/atoms/sha256/2c37bff2d8f941ea92b5c037c21e6d179a2ab8fe3a67836b6ecb5b2e766793e7) ## 定理二：首次越界具有一个明确的缩放形状 | needs-lean | none | delta->0 时有界 y 上一致收敛到 -A+B*y^(2m)，并给负区半宽渐近常数；已有接触支持结论不含此局部缩放定理。 | S31, S19 |
| 35 | [2f9a49afd3fffe7f7744822c6adea7f922e808404a7654ca0c8fd4f80195d788](../../../Meta/Digestion/atoms/sha256/2f9a49afd3fffe7f7744822c6adea7f922e808404a7654ca0c8fd4f80195d788) ## 定理 P2：逐阶保真关系 | needs-lean | none | 无限算子及每阶截断的共轭等式、负惯性与行列式相等；未找到实际 T_F 与 B/H 两种核的接线，通用惯性不补这个等式。 | S17, S18 |
| 36 | [2fa59f238e0c5dfb86c347ac26b274ce1ed355e030ffbc580a98779ceef61e6a](../../../Meta/Digestion/atoms/sha256/2fa59f238e0c5dfb86c347ac26b274ce1ed355e030ffbc580a98779ceef61e6a) ## 推论：RH 等价于一个明确的二次抵消 | needs-lean | none | 任意固定 h>0 的 RH iff 特定负二次交叉项抵消，并给 h=log4 的 19/6 常数；未找到这条能量渐近等价。 | S30, S39 |
| 37 | [2fbed82e07d243d1005a8a1c09923c3aaa3d8b0a414ff7a9210cd5c6f2ed26e2](../../../Meta/Digestion/atoms/sha256/2fbed82e07d243d1005a8a1c09923c3aaa3d8b0a414ff7a9210cd5c6f2ed26e2) ## 定理五：解析接触边界上，Schur 余量仍有统一正下界 | needs-lean | none | 有限阶接触零点时全部 N 的 Schur 余量>=exp(积分 log f_*)>0；现有 SzegoTransfer 证明有限矩阵 J-unitary，不给该预测误差下界。 | S19, S18 |
| 38 | [3342849ebfebb0ba8cd5217fe1a75e542e800c394bc9e9478978e025363fa770](../../../Meta/Digestion/atoms/sha256/3342849ebfebb0ba8cd5217fe1a75e542e800c394bc9e9478978e025363fa770) ## 定理一：时间方向始终合法，另一切面可以经历秩临界 | needs-lean | none | 所有实 theta 的 swap 连续幺正性与重排奇异值两种精确重数；未找到此 U_theta 家族，swap 名称命中不是奇异值定理。 | S33, S10 |
| 39 | [33bd332c5190b7fb8bf6b6fde4e8863e2cbc32878b35713e4e42abc4c4582e8b](../../../Meta/Digestion/atoms/sha256/33bd332c5190b7fb8bf6b6fde4e8863e2cbc32878b35713e4e42abc4c4582e8b) ## 推论：实际算术没有稳定的“二次能量中间态” | needs-lean | none | 排除 c>0 的 E_h~cL^2，并区分 RH 下 O(L) 与非 RH 时沿序列正指数增长；未找到实际素数能量的全称排除和 limsup 断言。 | S30, S39 |
| 40 | [34f85f5ef0ec8521296d78b1a195aa9330397b316945d3dae5f77744c60587eb](../../../Meta/Digestion/atoms/sha256/34f85f5ef0ec8521296d78b1a195aa9330397b316945d3dae5f77744c60587eb) ## 定理 V2：对实际 \(A\)，全局收缩性与 RH 等价 | needs-lean | none | 每个固定 h>0 的 RH iff 实际 S_h 在上半平面全纯且模<=1；有限 Cayley 幺正与 Li 因果性声明不识别此 S_h。 | S34 |
| 41 | [352958cfd6f933764581834a39a2547c32c91c2871dfc88c0e6d915af186b804](../../../Meta/Digestion/atoms/sha256/352958cfd6f933764581834a39a2547c32c91c2871dfc88c0e6d915af186b804) ## 定理 P4：任意半径的有限截断界 | needs-lean | none | 零延拓 B_N 的算子范数尾界，含 M_R/(1-R^-2) 与 sqrt(2R^-2N-R^-4N)；未找到该无限矩阵半径截断结论。 | S17, S24-count |
| 42 | [3b96c202fb8567eb58151de0b72315414794aa9b0003e2aecba521121fa0a819](../../../Meta/Digestion/atoms/sha256/3b96c202fb8567eb58151de0b72315414794aa9b0003e2aecba521121fa0a819) ## 定理二：完整算术分解 | needs-lean | none | H3 的完整 C0+C1*P+W3*(eta/2*P^2+(2-eta/2)*P(2s)) 等式；未找到这组历史系数与素数 zeta 的接线。 | S20, S15 |
| 43 | [3cefd6e75bf3146ba90cf7614b16b286751f3a36029a22cbba8e97a49ba911d3](../../../Meta/Digestion/atoms/sha256/3cefd6e75bf3146ba90cf7614b16b286751f3a36029a22cbba8e97a49ba911d3) ## 定理 T1：原函数是一个精确的尾积分 | needs-lean | none | g_+(x) 的 e^-x/2 加权 Phi 尾积分等式；未找到此实际原函数的积分表示，其他 primitive 命中无此核。 | S35, S29, S02 |
| 44 | [3ea6f6f717cf3b008eb7110a832936a14b2d2a332b6ee2abe42cb1146455f049](../../../Meta/Digestion/atoms/sha256/3ea6f6f717cf3b008eb7110a832936a14b2d2a332b6ee2abe42cb1146455f049) ## 定理 I4：固定高斯历史协议的 RH 判据 | needs-lean | none | RH iff 固定 Gaussian-history 残差序列 s_d->0；未找到该协议矩阵、残差定义和全阶极限的已冻桥。 | S27, S34 |
| 46 | [409c425f66ec18a504f4d6304af1f43493cb5a92225344c4f79b342fd0f5eacd](../../../Meta/Digestion/atoms/sha256/409c425f66ec18a504f4d6304af1f43493cb5a92225344c4f79b342fd0f5eacd) ## 定理 D4：三矩—端点兼容界 | needs-lean | none | 正谱前件下 a1-c 的两个三矩有理端点；未找到 M0^2/(4M0+M1) 与另一侧精确余量的不等式。 | S42, S24-count |
| 47 | [4104d8727c10869ec5ae256646c45c0bc72bcb83febed83f36c94488bbd5a763](../../../Meta/Digestion/atoms/sha256/4104d8727c10869ec5ae256646c45c0bc72bcb83febed83f36c94488bbd5a763) ## 定理二：这条离散边界对应低温复零点 | needs-lean | none | 充分小的所有 T>0 存在复零点，虚部精确为 +/-pi*T/log11，实部有负指数修正且属于完整配分函数；无该低温零点冻结定理。 | S36 |
| 48 | [42a6721fabfa0a316cd60251fdff5e3997dec865d18964539f6241a7c2dba3f9](../../../Meta/Digestion/atoms/sha256/42a6721fabfa0a316cd60251fdff5e3997dec865d18964539f6241a7c2dba3f9) ## 定理 O2：滤波器就是这个空间中的状态 | needs-lean | none | 不是纯定义：有限实 c 的二次型 <c,Kc>=Q_infinity(f_c) 是断言；未找到此迹类 K 与全谱多项式测试的精确接线。 | S05, S17 |
| 49 | [4ad8c850dca051f69ac5f8fc65592b377d32fca0fac5d5347fcc3c0ea2b7c153](../../../Meta/Digestion/atoms/sha256/4ad8c850dca051f69ac5f8fc65592b377d32fca0fac5d5347fcc3c0ea2b7c153) ## 定理 B2：删除一个均衡方向，得到低一阶的缩放模型 | needs-lean | none | 正定 K_d 与均衡参考向量前件下压缩特征式=q_d'/d，再缩放成 q_(d-1)；未找到该特定压缩/导数桥。 | S28, S08 |
| 50 | [4bf0743f24ceefdab6eae275b611c01646e5bf795de46dc68456a1d7ed269bf6](../../../Meta/Digestion/atoms/sha256/4bf0743f24ceefdab6eae275b611c01646e5bf795de46dc68456a1d7ed269bf6) ## 定理 J3：严格平方下降律 | needs-lean | none | E_C'=-1/4 commutator HS-square、单调性与 V_C''=-1/2 square<=0；未找到此矩阵流、所有 r 的导数恒等式。 | S37, S27 |
| 51 | [4dea51c9bf2a5ec929da7acfdeb7d4694ddb3effba5083d8d5e0519ebed7bfd6](../../../Meta/Digestion/atoms/sha256/4dea51c9bf2a5ec929da7acfdeb7d4694ddb3effba5083d8d5e0519ebed7bfd6) ### 定理十三：负方向数直接控制负总量的增长率 | needs-lean | none | 无零本征值参数处的严格方向导数下界及有限奇异参数的积分版；未找到该径向 Toeplitz 负迹演化率。 | S41, S19 |
| 52 | [4f1af385073cf374adf2837dcb61d6f03822ba385a3f589dacb3087c8b867246](../../../Meta/Digestion/atoms/sha256/4f1af385073cf374adf2837dcb61d6f03822ba385a3f589dacb3087c8b867246) ## 推论：不再需要任意搜索观察度量 | needs-lean | none | 固定 C 的 sigma_T->beta，并以指定 W_T 达到度量下确界；不是单纯叙述，缺该 Gaussian 度量逼近极限。 | S27, S37 |
| 53 | [506ba2fa80720ba43ca7d89d6b8d9c39455747237809df8fd552367fc064f22c](../../../Meta/Digestion/atoms/sha256/506ba2fa80720ba43ca7d89d6b8d9c39455747237809df8fd552367fc064f22c) ## 推论：反例必能表现为某个有限条件读出的负值 | needs-lean | none | 非 RH 推出存在有限 n、实 t 及邻近有理 t 的 R_n(t)<0；未找到该条件读出族与 RH 反例的等价/连续性桥。 | S14, S02, S34 |
| 54 | [51ecbc2e4c8976d219f4c2617007564164468c320acb88918b7ab6d848e61d79](../../../Meta/Digestion/atoms/sha256/51ecbc2e4c8976d219f4c2617007564164468c320acb88918b7ab6d848e61d79) ## 定理 Q5：条件读出的统一误差界 | needs-lean | none | 对全体实 t 的一致误差上界 2*tau_n(L)/Z_n；未找到指定 R_n 截断的常数和 sup 断言。 | S14, S17 |
| 55 | [528a07b72b26ab9b7df6f3645a60c76eedd91f4489b30838ea8ccb310c386c9b](../../../Meta/Digestion/atoms/sha256/528a07b72b26ab9b7df6f3645a60c76eedd91f4489b30838ea8ccb310c386c9b) ## 定理二：模数进位—相消重数关系 | needs-lean | none | 每个本原 d 次单位根处 Q_a 的零阶数等于余数进位 c_d；未找到 q-multinomial 的分圆零点重数，普通词数不足。 | S38, S23 |
| 56 | [578c45143001f9f9929455e22deef3c7cba964c4389ba0b9d79dd9371ed8f806](../../../Meta/Digestion/atoms/sha256/578c45143001f9f9929455e22deef3c7cba964c4389ba0b9d79dd9371ed8f806) ### 定理十二：恢复分辨率不会降低负本征值总量 | needs-lean | none | 所有 0<a<b 的 Toeplitz 负本征值总量单调性；已有 finite inverse Poisson 正定性判据不涉及这条负迹不等式。 | S41, S19 |
| 57 | [5918f6bd5a66f8b7eb15b4b1c505d54dfdf3b73d884b537a42b153c9270e3d4c](../../../Meta/Digestion/atoms/sha256/5918f6bd5a66f8b7eb15b4b1c505d54dfdf3b73d884b537a42b153c9270e3d4c) ## 定理一：径向接触不可能无限平缓 | needs-lean | none | Gamma 积分有限、接触径向导数=-Gamma/a_c、Gamma>=1/2 及严格负导数；未找到三个含常数结论。 | S31, S19 |
| 58 | [594f93cbc27b15032549c9271c41b100f049b61736e5e5d1fdbb8c90fb3cdda4](../../../Meta/Digestion/atoms/sha256/594f93cbc27b15032549c9271c41b100f049b61736e5e5d1fdbb8c90fb3cdda4) ## 推论：低频联合能量判据 | needs-lean | none | RH iff 所有 dyadic X=2^j,j>=1 的归一化低频平方和有界；未找到该 eta_r 与 R_X 截断的特定等价。 | S39, S30 |
| 59 | [59626bffd526d065fe29b4f63e40a4367886e380208787d0cf0fe4df9e169a9b](../../../Meta/Digestion/atoms/sha256/59626bffd526d065fe29b4f63e40a4367886e380208787d0cf0fe4df9e169a9b) ## 定理二：单次试除的精确指令数 | needs-lean | none | 按整除与不整除分支精确 4M+2Q+2、6M+2Q+2 指令计数；未找到源试除状态机的冻结步数声明。 | S40 |
| 60 | [5a2c25fc480f079e01ab62c81849c0487bae747b3674423d9bdd62f45ba8ae2f](../../../Meta/Digestion/atoms/sha256/5a2c25fc480f079e01ab62c81849c0487bae747b3674423d9bdd62f45ba8ae2f) ## 定理一：正配分函数的归一化边界恰好是 \(\lambda=T\) | needs-lean | none | 实 lambda 的配分函数有限 iff lambda>T（源 T>0）；相关 zeta 收敛与单缺陷热力学没有此完整乘积族的同一边界。 | S36 |
| 61 | [5f07081bda1ac55ca035fd26826575c18e003849d50ee64a715d99ee9c802999](../../../Meta/Digestion/atoms/sha256/5f07081bda1ac55ca035fd26826575c18e003849d50ee64a715d99ee9c802999) ## 定理 V4：固定实区间中的全阶拼接判据 | needs-lean | none | 在任意固定 0<b_-<b_+ 内对所有有限阶、所有采样点的 G>=0 与 RH 等价；已读 Pick/RH 邻件未提供固定实区间限制后反向推出 RH 的插值与解析唯一性桥。 | S21, S34, S51 |
| 63 | [62ee996f8ec3b4c0ff8b4d9d182f2785eed2515aa9b326c2e160705c7abdef3f](../../../Meta/Digestion/atoms/sha256/62ee996f8ec3b4c0ff8b4d9d182f2785eed2515aa9b326c2e160705c7abdef3f) ## 定理 L2：投影概率 | needs-lean | none | 断言 r 参数下不变 Fock 投影的范数平方恰等于 exp(-r*N_q)*H_q(r) 且<=1；投影概率流邻件不包含此相干态及酉群积分归一化。 | S11, S18, S48, S52 |
| 64 | [62f3d7a538f73aad17058c82235f1c1b82a07a089f54ad53aa27094677675f61](../../../Meta/Digestion/atoms/sha256/62f3d7a538f73aad17058c82235f1c1b82a07a089f54ad53aa27094677675f61) ## 定理 N3：固定滤波器的定量稳定性 | needs-lean | none | 固定多项式滤波器具有 E_R(f)/d 的定量误差界，eta>0 时 d>=2E_R/eta 推出 Q_d<=-eta/2；未找到实际 Jensen 幂迹的该速率及常数。 | S08, S13, S56, S63 |
| 65 | [63092dbf1c6ca5601c3853ad32183d153a5ba60589f537fa409f0581ade1df64](../../../Meta/Digestion/atoms/sha256/63092dbf1c6ca5601c3853ad32183d153a5ba60589f537fa409f0581ade1df64) ## 定理 Q3：实际两模态判据 | needs-lean | none | 断言所有 n>=0、所有实 t 的实际两模态 R_n(t)>=0 与 RH 等价；有限 Chebyshev slack 正性不等于这套广义 Laguerre 全阶判据。 | S02, S22, S53 |
| 67 | [692393217ace683f2485ba9cf02961c2290a83cb594513880aed0c55acd62466](../../../Meta/Digestion/atoms/sha256/692393217ace683f2485ba9cf02961c2290a83cb594513880aed0c55acd62466) ## 定理 M1：维数稀释界 | needs-lean | none | 在统一根绝对值总和界 M5 下，对全部 k>=0 给 rising-factorial 上界，并在 0<=r<d/L^2 给几何级数界；未找到所需 Haar 矩和 H_d 的声明。 | S11, S18, S48 |
| 68 | [69ae4d23bd64324ec6c5efe11686945d726482b842c45097e2e0e9360599cdb1](../../../Meta/Digestion/atoms/sha256/69ae4d23bd64324ec6c5efe11686945d726482b842c45097e2e0e9360599cdb1) ## 定理 B5：重标定回返恒等式 | needs-lean | none | 实际伴随压缩 C_d 的重标定回返含精确分式 f_d/(1-v*f_d/d)；ChainSchurResponse 只处理实三对角链的二阶逆矩阵展开，未识别该 Jensen 响应。 | S18, S28, S42, S49 |
| 69 | [72307ef5e33caa0d618146ecef4ad819f3ee4ebe2e55ebe5a6c226f5cd5a34e1](../../../Meta/Digestion/atoms/sha256/72307ef5e33caa0d618146ecef4ad819f3ee4ebe2e55ebe5a6c226f5cd5a34e1) ## 定理一：周期筛选公式 | needs-lean | none | 根单位处 q-多项式的分段精确值及零点重数 floor(R/d) 是两个断言；检索到的普通多项式/多项式系数接口无该 q-multinomial 根单位特化及精确重数。 | S23, S38 |
| 70 | [72f167014dbb653f2eec31560ed015c7e2c0d4140cb398121ad04c898e8b066f](../../../Meta/Digestion/atoms/sha256/72f167014dbb653f2eec31560ed015c7e2c0d4140cb398121ad04c898e8b066f) ## 定理 J2：体积—残差恒等式 | needs-lean | none | 对高斯历史 W_C 的 log(det) 导数断言 V'_C=2 Tr(Y_C^2)>=0；未找到这一实际高斯度量演化与残差的恒等式。 | S11, S27, S37 |
| 71 | [74c15d92cd745276176c9d4c66c4cdd5b7bf59fae5b937ae1e1a07186deca95b](../../../Meta/Digestion/atoms/sha256/74c15d92cd745276176c9d4c66c4cdd5b7bf59fae5b937ae1e1a07186deca95b) ## 定理一：交换对称保护的奇偶相消 | needs-lean | none | 概率调度对交换 S 不变时 A_P(pi)=0；InversionAntisymmetricSum 只适用于有限群反演及整数值函数，不覆盖一般历史交换和实/复概率权重。 | S23, S59 |
| 72 | [7721167db127aee2407282ad63f0739c5d953cd1720752a4d67089f562f7f10b](../../../Meta/Digestion/atoms/sha256/7721167db127aee2407282ad63f0739c5d953cd1720752a4d67089f562f7f10b) ## 定理 I3：高斯历史残差逼近真实谱虚部 | needs-lean | none | 对可能不可对角化的 d 维 C，T>0 时 beta<=sigma_T<=beta+sqrt(d(d-1))/(2T)；未找到高斯历史残差到谱虚部的双侧界。 | S12, S27, S61 |
| 73 | [77c2008257f3b60bc946f7a241541d17e94ffbd08b19325833bb0612dc5b1af0](../../../Meta/Digestion/atoms/sha256/77c2008257f3b60bc946f7a241541d17e94ffbd08b19325833bb0612dc5b1af0) ## 定理 K3：历史体积上限与实根性等价 | needs-lean | none | 任意实首一 q 全实根 iff 对所有 r>0 历史体积 Z_q(r)<=1；检索中无此酉群积分体积判据。 | S05, S11, S27 |
| 74 | [781219f95a1fdbea17a70a99cd34033d8dcc9569251b578580b4da952a19bbfd](../../../Meta/Digestion/atoms/sha256/781219f95a1fdbea17a70a99cd34033d8dcc9569251b578580b4da952a19bbfd) ### 定理六：每个接触点贡献的负区域与负总量 | needs-lean | none | 每个接触点在 delta趋零时负区域和负总量各有指定常数与 1/(2m_j)、1+1/(2m_j) 幂律；有限 Toeplitz 支撑正性不能给出这些渐近等价。 | S17, S19, S31, S54 |
| 75 | [783d413d2f102a6149222de31f25d081389f7d601c08e27fec9e339cf2f22c4c](../../../Meta/Digestion/atoms/sha256/783d413d2f102a6149222de31f25d081389f7d601c08e27fec9e339cf2f22c4c) ## 定理一：试除宏步骤 | needs-lean | none | 在 0<=r<k 的除法分解下，指定程序从 X(M,k) 达到 S(M,r,0,k-r;13)，包括 r=0 的最后重置；未找到该程序语义或对应到达定理。 | S07, S40 |
| 76 | [78f6a2108eaba02cfbe8c76ca6e12034335c4c1e4129bde2a2affd123bf56568](../../../Meta/Digestion/atoms/sha256/78f6a2108eaba02cfbe8c76ca6e12034335c4c1e4129bde2a2affd123bf56568) ## 定理四：有限历史的临界偏移具有同一个幂律 | needs-lean | none | 存在正 c1,c2，使所有充分大 N 的临界位移被同一 (N+1)^(-2m_*) 双侧夹住；未找到临界 Toeplitz 特征值的该渐近律。 | S19, S31, S54 |
| 78 | [7a359a1aa118ffc5f3423e85e46ce5f615806e4b8c0a16998ec49691a0215817](../../../Meta/Digestion/atoms/sha256/7a359a1aa118ffc5f3423e85e46ce5f615806e4b8c0a16998ec49691a0215817) ## 定理三：实际正性形成一个完整区间 | needs-lean | none | 合法实际正性参数恰为非退化闭区间 [0,a_*] 且 RH iff a_*=1；有限谱共同下界邻件未定义该实际 Schur 正性阈值或给出 RH 桥。 | S18, S19, S34, S54 |
| 79 | [7afafe5a6e3e8435ddf051d6cf49c1c6ca223fa4c95dfe286f19c8f391ec33d5](../../../Meta/Digestion/atoms/sha256/7afafe5a6e3e8435ddf051d6cf49c1c6ca223fa4c95dfe286f19c8f391ec33d5) ## 定理 L5：低阶自动上界 | needs-lean | none | 源文邻域限定 1<=k<=d、sum\|z_j\|<=L，并对 S_q>0 给两项非严格低阶上界；未找到 Schur 分拆系数 b_q,k 或比例 R_q,k 的该估计。 | S18, S48 |
| 81 | [7bc4a56b9299f55e209695fa3689db283e8328893508c0a4473ed32dea18b33b](../../../Meta/Digestion/atoms/sha256/7bc4a56b9299f55e209695fa3689db283e8328893508c0a4473ed32dea18b33b) ## 定理 E5：实际谱留数的整数约束 | needs-lean | none | 实际响应在 z=u0 的留数是 m*u0^2，来自 D 在 -1/u0 的 m 重零点；log-derivative 邻件未包含倒数坐标变换和该响应的精确权重。 | S50 |
| 82 | [7d5d9c72f7ad9abb794dd61d99e68ff5adc1271970f00e4a009b9e334680a0d2](../../../Meta/Digestion/atoms/sha256/7d5d9c72f7ad9abb794dd61d99e68ff5adc1271970f00e4a009b9e334680a0d2) ## 定理 M4：有限算术关系可以精确回读 | needs-lean | none | 对 n<=d 的实际 Jensen 多项式给系数比重回读 R_{n<-d}[P_d]=P_n；冻结降阶恒等式只处理相邻 d,d-1 的微分缩放，未陈述任意 n 的该系数回读算子。 | S08, S56 |
| 83 | [8062498ed2ea8f74ddd34c3c2dec295a44f3074797e0634b52cbd2630b51459e](../../../Meta/Digestion/atoms/sha256/8062498ed2ea8f74ddd34c3c2dec295a44f3074797e0634b52cbd2630b51459e) ## 定理 V1：零点转成了一个特定的相位接触 | needs-lean | none | A 的 m 重零点经可去延拓后 S_h(a)=-1 且导数=-2i/(h*m)；Cayley/Pick 核代数邻件无零点重数对应的接触导数。 | S34, S50 |
| 84 | [87852ef96970dd58409cceccafe2fa235ed951e6c39b41869e0fca5ecb677246](../../../Meta/Digestion/atoms/sha256/87852ef96970dd58409cceccafe2fa235ed951e6c39b41869e0fca5ecb677246) ## 定理三：最大全局离线位移的距离公式 | needs-lean | none | 断言 b趋正无穷时 b-R(b) 的极限等于全局离线位移 delta_*；已找到的半径/零点邻件未提供同一距离函数及该极限。 | S12, S34, S54, S61 |
| 85 | [88517388478e9834b20004960ece45e5026828dc5fbb0a58206c141a37529a4b](../../../Meta/Digestion/atoms/sha256/88517388478e9834b20004960ece45e5026828dc5fbb0a58206c141a37529a4b) ## 定理六：全部高周期共有的非退化界 | needs-lean | none | 对源文高周期范围和 Re(s)>1/2，给 W_hat 的严格模长界及严格正实部；未找到该由素因数余数构成的 Dirichlet 系数或统一 binomial 界。 | S15, S23, S38, S63 |
| 86 | [887786649b4338a76547a05ce2a7b0347b65b5fbe737f69ec247188f3214a077](../../../Meta/Digestion/atoms/sha256/887786649b4338a76547a05ce2a7b0347b65b5fbe737f69ec247188f3214a077) ## 定理二：谱平滑对首次返回概率的作用是精确的指数折扣 | needs-lean | none | 谱平滑使 Schur 响应 S_a(z)=S(a*z)，从而每个首次返回振幅/概率分别乘 a^n/a^(2n)；命中的首次返回是旋转词或实链响应，不是该谱测度的 Schur 系数。 | S18, S19, S49 |
| 87 | [88b85ee6e765d6cc5180d029dfdce4cb39fa51093abb321682813ff46a09f58c](../../../Meta/Digestion/atoms/sha256/88b85ee6e765d6cc5180d029dfdce4cb39fa51093abb321682813ff46a09f58c) ## 定理三：混合方格的相容条件 | needs-lean | none | 混合方格给全状态相容 iff 算子相等、幺正时 iff W=I，以及指定态固定子空间/网格拼接；可见记忆回返和有限干预交换只给不同对象的合成式，未覆盖这组幺正方格判据。 | S45, S57 |
| 88 | [8a1900b281e35bf99c03af2be822b3b0f7a042c7b2a5f8d9ee837df2ca1de391](../../../Meta/Digestion/atoms/sha256/8a1900b281e35bf99c03af2be822b3b0f7a042c7b2a5f8d9ee837df2ca1de391) ## 定理 N2：代数平方就是两条件态的相对振幅 | needs-lean | none | B!=0 的两种规范化纠缠条件态内积等于 Tr(B^2)/Tr(B*B)；GNSMatrix 和 MatrixSelfPairing 是同态自配对范数式，未包含该双态振幅、最大纠缠向量和分母。 | S47, S55, S60 |
| 89 | [8b768726d3b3963e9b9e1a11bc7f33a04a657642db42c63fbdaaff28bf0456b0](../../../Meta/Digestion/atoms/sha256/8b768726d3b3963e9b9e1a11bc7f33a04a657642db42c63fbdaaff28bf0456b0) ## 定理一：忠实切面的拼接公式 | needs-lean | none | 每条完整历史恰交一次的边切面给路径配分函数分解；检索到的禁邻路径独立集配分和依赖割只是不同行为，未找到任意忠实边切的乘权求和等式。 | S46, S58 |
| 90 | [8c8a536d7244072e5e39acc9ab7d2fdf7d874b16349959336f6450a8aad7d74d](../../../Meta/Digestion/atoms/sha256/8c8a536d7244072e5e39acc9ab7d2fdf7d874b16349959336f6450a8aad7d74d) ## 定理 T6：高阶矩的精确递推 | needs-lean | none | n>=1 时半直线 Wigner 矩由 J 的相邻三矩按明确 pi^2 系数递推；theta 原始偶矩正性和有限 Prony 递推均不是此带边界分部积分恒等式。 | S02, S14, S22, S35, S62 |
| 91 | [8df09af617ce850c0ed67805688f8fc4f3a0073576a33701fa752ca4ea9ca08a](../../../Meta/Digestion/atoms/sha256/8df09af617ce850c0ed67805688f8fc4f3a0073576a33701fa752ca4ea9ca08a) ## 定理 E4：有限链精确保留前 \(2N\) 个回返矩 | needs-lean | none | 断言 N 阶 Jacobi 截断精确保留 k=0,...,2N-1 的回返矩；有限 Stieltjes 对角实现和 Hankel 行列式比不是该截断 Jacobi 矩匹配定理。 | S24-count, S42, S66 |
| 93 | [8f9277771081db94f2cbe4d55fe4075fdde7edc0a9ecf4e443ae45717b8c0dcb](../../../Meta/Digestion/atoms/sha256/8f9277771081db94f2cbe4d55fe4075fdde7edc0a9ecf4e443ae45717b8c0dcb) ## 定理三：整段历史的精确双端点读出 | needs-lean | none | 正时间权重、幺正传播的整链在固定双端点时有精确最小能量 norm(y-Ux)^2/sum(tau)；检索未找到该最小值与达到构造的冻结声明。 | S64, S75 |
| 94 | [8fa3ec47d77910a7c979444b92779fa3031a487901bebfcdf8f8e10d56ce54d4](../../../Meta/Digestion/atoms/sha256/8fa3ec47d77910a7c979444b92779fa3031a487901bebfcdf8f8e10d56ce54d4) ## 定理 I1：它对任意有限矩阵都收敛且严格正定 | needs-lean | none | 对任意有限矩阵 C，高斯历史 W_T(C) 收敛且严格正定是实际断言；已检索的高斯/Gram 邻件不构造这一矩阵积分。 | S11, S27, S61 |
| 95 | [90382ec6571adc1e9f8248f72b7b7a2bb916d5ade3bdbfc99e99b6477c208b34](../../../Meta/Digestion/atoms/sha256/90382ec6571adc1e9f8248f72b7b7a2bb916d5ade3bdbfc99e99b6477c208b34) ## 推论：RH 强迫纯素数读出最终具有固定负余量 | needs-lean | none | RH 前件下给纯素数读出的 limsup 严格负界、liminf 下界和最终 X^(3/2) 负余量；PrimeOnlyNoGap 是非负 Fourier 跳跃能量的零下确界，目标不同。 | S30, S67 |
| 96 | [92536bbe2b763233c6c90f6e32152612b3a4c8316395ce3895a27051104157cb](../../../Meta/Digestion/atoms/sha256/92536bbe2b763233c6c90f6e32152612b3a4c8316395ce3895a27051104157cb) ## 定理 P3：这个转换不会随阶数变得任意病态 | needs-lean | none | 在 D(ell)<2 下对无限 T_F 和所有有限截断同时给范数<=D(ell)、逆范数<=1/(2-D(ell))；未找到同一实际系数 Toeplitz 乘子的统一可逆界。 | S19, S68 |
| 97 | [937abccd3570503c88aaac8b088e687e6f79db29ca9f67f887b72a028bd4f866](../../../Meta/Digestion/atoms/sha256/937abccd3570503c88aaac8b088e687e6f79db29ca9f67f887b72a028bd4f866) ## 定理二：边界有效几何由 Schur 补唯一确定 | needs-lean | none | 复 Hermitian 块且 C严格正定时，对所有边界 x 的内部最小值为 x*(A-BC^-1B*)x；ExactStickyReduction 的公开结论只有正性/负惯性等价，没有这个最小化等式。 | S18, S32, S64, S75 |
| 98 | [96902e5b1d0b9ac78c37f6c1f75fd1d5043bfd6c18f5e2451352b6fbc6977b46](../../../Meta/Digestion/atoms/sha256/96902e5b1d0b9ac78c37f6c1f75fd1d5043bfd6c18f5e2451352b6fbc6977b46) ### 定理十五：一个反射零点对的负贡献区域，恰好是一个圆盘 | needs-lean | none | 源文 x>0、0<delta<1/2、正重数 m，排除零点后配对 Poisson 有理式严格负 iff 位于开圆盘；反射增长模态和 inverse-Poisson 邻件无该配对实部公式。 | S34, S65 |
| 99 | [983c804dbd8a847852de8910fac6e9702a31040ec86415def14516a225851762](../../../Meta/Digestion/atoms/sha256/983c804dbd8a847852de8910fac6e9702a31040ec86415def14516a225851762) ## 引理：小历史宽度下，行列式不会比 \(\exp[-O(d^2\log d)]\) 更小 | needs-lean | none | 对所有根模<=M 的实首一多项式给统一 r0,d~d^-2 和 logdet 下界 -C_M*d^2*log(d+1)；未找到实际历史 Gram 的这一定量小宽度下界。 | S11, S27, S80 |
| 100 | [9877043750157f00197144b87542162e34a7242d56d6533a857d4cb5822fd169](../../../Meta/Digestion/atoms/sha256/9877043750157f00197144b87542162e34a7242d56d6533a857d4cb5822fd169) ### 定理十六：负贡献圆盘的 Möbius 像 | needs-lean | none | 在 z=1-1/s 与源文指定 Z、R 下，负圆盘等价式及 \|Z\|^2=1+R^2 都是真断言；命中的 GoldenSamplingDiskAtom 处理不同采样圆盘，未找到该 Mobius 像。 | S34, S65 |
| 101 | [9907b45db0455394c6e8a00a5cd8ff4254b92dddb711777a18a6ab48d070c176](../../../Meta/Digestion/atoms/sha256/9907b45db0455394c6e8a00a5cd8ff4254b92dddb711777a18a6ab48d070c176) ### 定理十四：负部分的精确产生率 | needs-lean | none | 对负部分的 a 导数给跨正负集合双积分恒等式及 a*e_-' >=(d_-+e_-)/2；离散负惯性/负部分估计未覆盖该连续 Poisson 演化产生率。 | S17, S31, S41 |
| 102 | [9a5d07eae55d326165113eae65bcedf131f3abfb57916fd7c08913609d7adbab](../../../Meta/Digestion/atoms/sha256/9a5d07eae55d326165113eae65bcedf131f3abfb57916fd7c08913609d7adbab) ## 定理 O4：截断误差 | needs-lean | none | 实际无限 K 的截断同时有明确迹范数和算子范数两项几何误差界；有限系统 balanced truncation 的输入输出能量界不涉及 K、B0 或这些常数。 | S24-count, S68, S80 |
| 103 | [9a6bf4e79560e0d3df31fbe2a177f290ec07ec71218e71eb89e322dc2f039635](../../../Meta/Digestion/atoms/sha256/9a6bf4e79560e0d3df31fbe2a177f290ec07ec71218e71eb89e322dc2f039635) ## 定理 S4：裸 Bessel 核的有限正值区间 | needs-lean | none | 对 a>0、\|t\|<=a 断言虚阶修正 Bessel K_it(a) 严格正；本库 Bessel 命中未给这一含边界的有限区间正性。 | S22 |
| 104 | [a5b558f46722070fb3661959014acf45a036f4013ac27541c95454f998a44da2](../../../Meta/Digestion/atoms/sha256/a5b558f46722070fb3661959014acf45a036f4013ac27541c95454f998a44da2) ## 定理 E2：下界是一个最佳多项式逼近问题 | needs-lean | none | 在 H_+ 正表示前件下，Delta-L_N 等于 degree<N 的带权多项式最佳逼近并给随 N 单调下界；有限 Stieltjes Hankel 正性不陈述该特定最优化或嵌套性。 | S24-count, S42, S66 |
| 105 | [a7dc27aa3ded303f19a0085dc10e7521c4f0e9984b5970c109e3a572b1c30f11](../../../Meta/Digestion/atoms/sha256/a7dc27aa3ded303f19a0085dc10e7521c4f0e9984b5970c109e3a572b1c30f11) ## 定理 D1：任意足够多的不同采样点，都保留全部负方向 | needs-lean | none | m=d-1 个任意互异上半平面合法采样点保留全部 Bezout 负惯性，且等于互异非实共轭根对数；有限 Cauchy Gram 因子分解未声明满秩/惯性，NewtonHankel 只给另一矩阵的实根判据。 | S05, S21, S69, S70 |
| 106 | [a7e88754e5bb8b4c30b89baee6fd1fe41153876af182d201b96a9086884d779f](../../../Meta/Digestion/atoms/sha256/a7e88754e5bb8b4c30b89baee6fd1fe41153876af182d201b96a9086884d779f) ## 推论：存在超几何速度的截断方案 | needs-lean | none | 实际 D 增长及 R_N=(N/log N)^2 给特定 B 截断误差 exp(-2N log N+2N loglog N+O(N))；已有有限或几何截断界没有此超几何速率及实际对象识别。 | S08, S68, S80 |
| 107 | [a86360d87830d173c35426c12b589270e406c6a12dc8dfb241ccdbefb825d0e3](../../../Meta/Digestion/atoms/sha256/a86360d87830d173c35426c12b589270e406c6a12dc8dfb241ccdbefb825d0e3) ## 定理二：第四阶在绝对收敛域内的全部零点 | needs-lean | none | Re(s)>1 内 F4 的全部零点、精确竖直等差族与简单性是真断言；未找到该历史 Dirichlet F4 的 Euler 因子和全部零点分类。 | S15, S38, S71 |
| 108 | [af4b3b2fa8cb484824d83794e63fc48816b6e05c9c0ad32f76e3a360c35e30eb](../../../Meta/Digestion/atoms/sha256/af4b3b2fa8cb484824d83794e63fc48816b6e05c9c0ad32f76e3a360c35e30eb) ## 定理 D3：共同正回返表示 | needs-lean | none | 对实际 D，RH iff 在全部非实域存在一份有限正测度的 Stieltjes 表示；已读有限原子实现明确不声称实际 xi 平方折叠表示或 RH 等价。 | S24-count, S42, S70 |
| 109 | [b407682500faaa6d8da43ce0ed7505d8350c1352ad449a548751bce1b62cd783](../../../Meta/Digestion/atoms/sha256/b407682500faaa6d8da43ce0ed7505d8350c1352ad449a548751bce1b62cd783) ## 定理 U2：实际算术核的全局正性判据 | needs-lean | none | 实际 A 的整个交叉核正半定 iff RH；OffLinePickWitness 是带额外非零假设的有限差分一点见证，Cayley 核合同只传递两套 Gram 正性，都未给此实际核等价。 | S34, S70 |
| 110 | [b5821e42febe81b45815f8be9802ddafcf7daab5dc4c74e501b0e709ce3e6000](../../../Meta/Digestion/atoms/sha256/b5821e42febe81b45815f8be9802ddafcf7daab5dc4c74e501b0e709ce3e6000) ## 定理五：任意周期的解析分支次数 | needs-lean | none | 每个周期 d 的 H_d 是 log(zeta) 的 degree<=d-1 多项式且系数在 Re(s)>1/2 全纯；Euler 对数关系本身不包含此历史读数分解和解析延拓域。 | S15, S20, S23, S38 |
| 111 | [b664d8929116da6563cafcdddb7f6e7dc3b66a6fe434e807422ba82db9b83ee4](../../../Meta/Digestion/atoms/sha256/b664d8929116da6563cafcdddb7f6e7dc3b66a6fe434e807422ba82db9b83ee4) ## 定理 E1：在正表示下，这是另一份正谱测度 | needs-lean | none | 在 H_+ 下，实际 T 的 Stieltjes 测度精确为 dω/(4+u)，且每个 ell_n 是对应矩；有限 support-localization 乘 u 的邻件不是该除以 4+u 的实际响应恒等式。 | S24-count, S42, S70 |
| 112 | [b923baf16e3404ffc7143c8258cd778915ab93409a40512c8d156d065ed1f61a](../../../Meta/Digestion/atoms/sha256/b923baf16e3404ffc7143c8258cd778915ab93409a40512c8d156d065ed1f61a) ## 定理：它们是否相容，由总指数奇偶决定 | needs-lean | none | 因数空间上的总素因子重数 Gamma 与互补因数 R 满足 Omega(N) 控制的对易符号；有限 gap 反射奇偶及素数指数分布未给该两个算子恒等式。 | S73, S79 |
| 113 | [bc9748938013e4b3c632bfa0e1257a59733df2e1682ed0a8a0d7a0dcc534ab2b](../../../Meta/Digestion/atoms/sha256/bc9748938013e4b3c632bfa0e1257a59733df2e1682ed0a8a0d7a0dcc534ab2b) ## 定理 V3：相位修补增加一个正秩一项 | needs-lean | none | 任意响应 S 乘上半平面 Blaschke 因子时 Pick 核增加精确 2Im(p)/((z-conj(p))(conj(w)-p)) 项；已读圆盘 Clark 核与 Cayley 合同公式不是此乘积修补恒等式。 | S34, S70, S74, S78 |
| 114 | [bdbe4b53515757ce5b701ee375409970886fe1274ff51cca53692271e1f924bb](../../../Meta/Digestion/atoms/sha256/bdbe4b53515757ce5b701ee375409970886fe1274ff51cca53692271e1f924bb) ## 定理 Q4：实际 \(\mu_n\) 在正半轴严格递减 | needs-lean | none | 对每个 n>=0，实际两模态 mu_n 在所有 s>0 的导数严格负；theta 核偶矩正性或一般倾斜凸性没有这套实际筛选密度的严格单调结论。 | S02, S53, S62, S76 |
| 115 | [bdc556a362036fbf086d0f5882d47613103ee99fa42cd1bf20d16e264b0b274a](../../../Meta/Digestion/atoms/sha256/bdc556a362036fbf086d0f5882d47613103ee99fa42cd1bf20d16e264b0b274a) ## 定理 O1：\(\mathsf K\) 是迹类自伴算子 | needs-lean | none | 断言实际无限 K 自伴且迹类并满足迹范数<=B0；命中的其他 Fredholm/热态迹类对象和有限 Hankel 系统没有构造该 K 或给出 B0。 | S24-count, S68, S80 |
| 116 | [be67399e40a50efabac4cb3841bc3a3b7bbb408e0954367e9f95efe2f390eede](../../../Meta/Digestion/atoms/sha256/be67399e40a50efabac4cb3841bc3a3b7bbb408e0954367e9f95efe2f390eede) ## 定理 R2：实际两模态的局部高斯极限 | needs-lean | none | 筛选概率下二维归一化变量联合趋于独立标准高斯，全部固定多项式矩收敛且 v_n~W0(n/pi)/(4n)；Lambert 热核的 Mellin 变换不是这个 Lambert-W 鞍点极限。 | S14, S29, S76 |
| 117 | [c03c3d51c8caa76b112c4d2b77618edb95c424c724d03c1f4e1b0fe8887986d5](../../../Meta/Digestion/atoms/sha256/c03c3d51c8caa76b112c4d2b77618edb95c424c724d03c1f4e1b0fe8887986d5) ## 定理四：三周期读数的离散绕行公式 | needs-lean | none | 三周期解析延拓的二阶离散差分等于指定系数乘绕数平方，三阶为零；现有绕数/monodromy 邻件未连接同一 H3 和 W3。 | S15, S20, S38 |
| 118 | [c0a72a217fb966246fd4a48a809795cdc539435d1e88d1a10d041a9bcd9ed98d](../../../Meta/Digestion/atoms/sha256/c0a72a217fb966246fd4a48a809795cdc539435d1e88d1a10d041a9bcd9ed98d) ## 定理 B4：新增耦合总预算 | needs-lean | none | B3 设置下所有新增耦合 eta 之和有 (d-1)/d^2*(a1^2-2a2) 和 chi4 两个精确表达；冻结 Jensen 降阶未定义这些耦合或四阶累积量桥。 | S08, S28, S56, S62 |
| 119 | [c24e34de0c01213d2344c494115a947d88276005c94863a848567f7031e10009](../../../Meta/Digestion/atoms/sha256/c24e34de0c01213d2344c494115a947d88276005c94863a848567f7031e10009) ## 引理：实际有限谱有统一界 | needs-lean | none | 存在与 d无关的 M，使所有实际有限 q_d 的根模<=M，源文用 D(rho*)<2 的统一无零圆盘；SourceJensen 的已读系数/正主块障碍不含这个全阶无零估计。 | S08, S56, S77 |
| 122 | [c468d943aacd5d85352a7866613f53c2d6b6fd3e5a7c94cf9a5115a718abb0c9](../../../Meta/Digestion/atoms/sha256/c468d943aacd5d85352a7866613f53c2d6b6fd3e5a7c94cf9a5115a718abb0c9) ## 定理 V5：实际全部两点矩阵正半定 | needs-lean | none | 对所有 b,c>0 的实际 mu 两点矩阵正半定；已检索接口未给实际 theta 矩 Turan 到 mu(b)/b 单调性的桥，通用 2x2 判据不能替代它。 | S14, S70, S81, S90 |
| 123 | [c600e6828d8eeb65e865c4c7c465be9aa00cb5a30100be45cfcb26542c868b4d](../../../Meta/Digestion/atoms/sha256/c600e6828d8eeb65e865c4c7c465be9aa00cb5a30100be45cfcb26542c868b4d) ## 定理 K4：固定宽度序列判据 | needs-lean | none | RH iff 存在无界次数列使指定宽度 d_j^4 的实际历史体积<=1；未找到该宽度序列、统一小宽度行列式下界与反向检测桥。 | S08, S11, S27, S77 |
| 124 | [cd2ad7f9986ee06ef6a8ac86aa7834a19d836483eaa1475b57396f3ba7ae536a](../../../Meta/Digestion/atoms/sha256/cd2ad7f9986ee06ef6a8ac86aa7834a19d836483eaa1475b57396f3ba7ae536a) ## 推论：实根性向低阶传递 | needs-lean | none | 包括反转 q 的精确导数、负实根向低阶传播和非实根失败向所有高阶传播；已读 Jensen 微分降阶仅给 P 的关系，未建立 reciprocal q、全负根性及失败传递的同一声明。 | S08, S56, S84, S89 |
| 125 | [cf00b1802f9e0029835530f6cff45c04fc84ccaa1f13d1eadc540c1dc6259ba3](../../../Meta/Digestion/atoms/sha256/cf00b1802f9e0029835530f6cff45c04fc84ccaa1f13d1eadc540c1dc6259ba3) ## 定理二：金字塔最大熵几何的曲率 | needs-lean | none | 在源最大熵金字塔流形上，竖向曲率1/4、水平曲率-rho/(4(1-rho)) 为真断言；按几何对象及 warped-product/曲率内容检索均无对应冻结件。 | S06, S26, S85 |
| 126 | [d434181a00c8203a60054490e976fdfcfe0f1b1c1fc42b9a2d58797aa0341a9d](../../../Meta/Digestion/atoms/sha256/d434181a00c8203a60054490e976fdfcfe0f1b1c1fc42b9a2d58797aa0341a9d) ## 推论：整个历史过程到底消除了多少？ | needs-lean | none | 高斯历史的无穷积分耗散量恰等于初始残差减谱残差，并等于两倍非正规性；未找到该实际矩阵流、可积性和精确端点极限。 | S11, S27, S37, S61 |
| 127 | [d46f67d9701bbca5691908d2a1ff2d60f8cc946f10b5a1e91c784b83ad378bde](../../../Meta/Digestion/atoms/sha256/d46f67d9701bbca5691908d2a1ff2d60f8cc946f10b5a1e91c784b83ad378bde) ## 定理 M2：线性历史窗口的自动通过区域 | needs-lean | none | 在给定 d下界与 0<r<=d/(2L^2) 下有 Z_d(r)<=exp(-r*S_*/4)<1；未找到该实际酉平均体积的统一参数估计。 | S11, S48 |
| 128 | [d5fddb4b2a8fa2c2afef4de9faac8e2192fa333bce05b160799f87fefa9c339f](../../../Meta/Digestion/atoms/sha256/d5fddb4b2a8fa2c2afef4de9faac8e2192fa333bce05b160799f87fefa9c339f) ### 定理八：联合尺度下的定量计数与负总量 | needs-lean | none | 对联合 N、delta 区域给负方向计数和负总量两个显式误差式，常数独立于两尺度；现有 Toeplitz 有限地板与惯性稳定性未陈述这套接触点渐近。 | S17, S19, S31, S41 |
| 130 | [d9aefe500d926d5c9ec8e40a4997df1371cfe837dc3a11f548b7a2cfcf99b6b7](../../../Meta/Digestion/atoms/sha256/d9aefe500d926d5c9ec8e40a4997df1371cfe837dc3a11f548b7a2cfcf99b6b7) ## 定理 R1：方差控制低频干涉 | needs-lean | none | 全部实 t 满足 1-t^2*v_n<=R_n(t)<=1，且严格低频窗口正；未找到实际两模态筛选分布的此方差-余弦界。 | S02, S14, S39, S87, S91 |
| 131 | [daba72e239c5a9bae6419c9ee7873c87de22293ae599a303dd3feeff596ed538](../../../Meta/Digestion/atoms/sha256/daba72e239c5a9bae6419c9ee7873c87de22293ae599a303dd3feeff596ed538) ## 推论：全部标量矩受高斯基准控制 | needs-lean | none | boxed 同时断言全部偶矩高斯界、所有实 b 的 MGF 界和严格相邻 alpha 对数凹性；theta 偶矩正性或 Karp 二次截断 Turan 不是这套实际全阶/全倾斜结果。 | S14, S53, S88, S90 |
| 132 | [dd585f94675a53aceed6592da3ad291d31505f93c47ec491c1b9bba0851ef5f7](../../../Meta/Digestion/atoms/sha256/dd585f94675a53aceed6592da3ad291d31505f93c47ec491c1b9bba0851ef5f7) ## 定理五：一个显式的有限时长负证书 | needs-lean | none | 负符号谷深 eta 给 Toeplitz 最小特征值的明确 pi^4*M_a/(8(N+2)^2) 上界和严格时长阈值；未找到该局部负点的定量有限证书。 | S19, S31, S54 |
| 133 | [deaf86853b1217a64e0283dae2f03f6aa847b19a5d16e68a95518b8caef0da80](../../../Meta/Digestion/atoms/sha256/deaf86853b1217a64e0283dae2f03f6aa847b19a5d16e68a95518b8caef0da80) ### 定理九：最小修正维数与最小修正总量 | needs-lean | none | 任意有限 Hermitian K 的最小修正秩、最小迹及共同达到者 K_-；MinimalPositiveRepair 只给特定实2x2 Fibonacci 矩阵的算子范数最优，未给这两个普遍最小值。 | S17, S41, S83 |
| 134 | [df8445edb07e25e1e79b9efacc91d4900583fa229efe7706745af103ff1cb3f5](../../../Meta/Digestion/atoms/sha256/df8445edb07e25e1e79b9efacc91d4900583fa229efe7706745af103ff1cb3f5) ## 推论：线性尺度上的体积确实趋零 | needs-lean | none | S_*>0、0<theta<L^-2 时给重标定体积正极限、体积趋零和归一化 log 极限；未找到同一实际 Jensen/Haar 体积的三个极限。 | S11, S12, S48 |
| 135 | [e12105bf8ad122862f6fe04a1b4abe22b29365455992101560012d8a9cdf9f44](../../../Meta/Digestion/atoms/sha256/e12105bf8ad122862f6fe04a1b4abe22b29365455992101560012d8a9cdf9f44) ## 定理 T3：Gamma—整数分解 | needs-lean | none | sigma>1 下实际密度 r_sigma 等于独立 Gamma 随机变量和 zeta 整数变量的对数差分布；Mellin/Gamma 乘积关系未给概率分布相等或独立乘积构造。 | S29, S35, S88 |
| 136 | [e17855c9db943466019087527afd9e178fa5c465197a1a9de44490e5fa8444b2](../../../Meta/Digestion/atoms/sha256/e17855c9db943466019087527afd9e178fa5c465197a1a9de44490e5fa8444b2) ## 定理 J4：残差的精确极限 | needs-lean | none | 全部 r>0 给残差超谱量的 d(d-1)/(4r) 上界及单调下降极限，允许不可对角化和重根；未找到高斯历史的这一强结论。 | S12, S27, S37, S61 |
| 137 | [e405a7f40fa7ee5313052263686a73c8b8578d18290d1f429cb1826603f82480](../../../Meta/Digestion/atoms/sha256/e405a7f40fa7ee5313052263686a73c8b8578d18290d1f429cb1826603f82480) ## 定理一：首次返回概率具有精确的逐步守恒账目 | needs-lean | none | 首次返回每一步有 p_n=s_(n-1)-s_n，所有有限 N 概率守恒；首次返回检索仅旋转词/实链邻件，未发现反复 QU 的幺正监测概率恒等式。 | S49, S52, S86, S91 |
| 138 | [e44ad50e6f818d656b6b3b1318b466ef65b9d4fe363f0d70d2f988ffda11c865](../../../Meta/Digestion/atoms/sha256/e44ad50e6f818d656b6b3b1318b466ef65b9d4fe363f0d70d2f988ffda11c865) ## 定理二：RH 等价于这个实际边界函数的收缩性 | needs-lean | none | 实际 S_xi 在全单位圆盘解析收缩 iff RH，且合法时 \|S_xi(z)\|<=\|z\|；通用 Cayley/Herglotz 变换没有连接该实际函数和 RH，未找到相应冻件。 | S18, S19, S34, S70, S87 |
| 139 | [e5d2d285af1f22158b076150c40f53f7d8ce44d2a32dbf3093e84e39ae416c82](../../../Meta/Digestion/atoms/sha256/e5d2d285af1f22158b076150c40f53f7d8ce44d2a32dbf3093e84e39ae416c82) ## 定理 M3：双尺度极限 | needs-lean | none | \|theta\|L^2<1 的复域上 H_d(d*theta) 局部一致趋于指定指数级数 F_xi；未找到统一 Haar 积分极限及实际 rho_m 的对应式。 | S11, S12, S48 |
| 140 | [e608f6dc2b3e96087ebd63bf03573113e4862368d4ca9073b2e7e18b62f93d6a](../../../Meta/Digestion/atoms/sha256/e608f6dc2b3e96087ebd63bf03573113e4862368d4ca9073b2e7e18b62f93d6a) ### 定理十七：假设存在失稳时，有严格夹逼 | needs-lean | none | 假设失稳时四个不同阈值满足严格链 0<a_geom<a_*<R0<1；实际负圆盘几何、正性阈值和解析半径的严格分离未找到冻结声明。 | S18, S34, S54, S65 |
| 141 | [e6b6fecddb5eee0812a0243c4df590974799c2c4403225694671db7205f1e6a0](../../../Meta/Digestion/atoms/sha256/e6b6fecddb5eee0812a0243c4df590974799c2c4403225694671db7205f1e6a0) ## 定理 L1：非负平方展开 | needs-lean | none | 实系数有限多项式 q 的实际 H_q(r) 与全部分区平方系数 b_(q,k) 的无限级数等式及 b>=0；检索到的 Karp 二次截断不是此 Schur 分区展开。 | S11, S12, S23, S48, S107 |
| 142 | [e9720c882324b7c79f984b3a679f76fadc56b24259982372cfb13ef034c4860a](../../../Meta/Digestion/atoms/sha256/e9720c882324b7c79f984b3a679f76fadc56b24259982372cfb13ef034c4860a) ## 定理 N4：离线根产生固定的负平方测试 | needs-lean | none | 实际 xi 离线根须给一个固定且 f(0)=0 的实多项式，并可取有理系数，使无限 Q_infty<0；有限 Newton-Hankel 插值负向量没有无限尾控制及有理化桥。 | S05, S69, S98, S104 |
| 143 | [ee425ea06616fd0f316f4ec675f08c194f1a322c66490006b88f876689118d41](../../../Meta/Digestion/atoms/sha256/ee425ea06616fd0f316f4ec675f08c194f1a322c66490006b88f876689118d41) ## 定理 I2：有限观察空间的边界缺额 | needs-lean | none | 实际高斯历史压缩须同时满足 R*T R_T=T^-2 I-[A_T,A_T*]、Loewner 上界和 HS 平方=d/T^2；读出更新的置换交换子因式分解不覆盖这些对象或常数。 | S27, S37, S105, S106 |
| 145 | [eeec54732cd5164f183f001e2f20aca1e7c3d82f7e60e2ae713bb6be62891335](../../../Meta/Digestion/atoms/sha256/eeec54732cd5164f183f001e2f20aca1e7c3d82f7e60e2ae713bb6be62891335) ## 定理 J1：历史方差演化 | needs-lean | none | 实际 W_C(r) 的高斯方差导数等于三个指定矩阵乘积，系数为 1,-1/2,-1/2；一般解析流/等谱检索未找到此历史 Gram 微分方程。 | S27, S37, S106 |
| 146 | [ef6f54cb65d0244d86eb6429a06d130952605ede928d46583fdd5558ae1c0b90](../../../Meta/Digestion/atoms/sha256/ef6f54cb65d0244d86eb6429a06d130952605ede928d46583fdd5558ae1c0b90) ## 定理 R4：相邻态严格正交 | needs-lean | none | 两模条件态 chi_n 对所有 n 与 chi_(n+1) 正交；冻结镜像偶奇分解的 carrier 是零点 Hilbert 空间，未找到该实际 L2 条件态的奇偶性及映射。 | S99, S100 |
| 147 | [efc75726d17ed8663b268d9d47e0616c4b92a0383da0261cb7c4c6c7f3b819d2](../../../Meta/Digestion/atoms/sha256/efc75726d17ed8663b268d9d47e0616c4b92a0383da0261cb7c4c6c7f3b819d2) ## 定理 L4：平方级数的精确指数率 | needs-lean | none | r 趋于正无穷时实际 log H_q/r=Q_q 和 log Z_q/r=2 sum(Im lambda_j)^2 两个极限，未找到冻结的高斯历史指数率声明。 | S11, S12, S27, S61 |
| 149 | [f19c5a47126f834bc6db65cd85562ee9c8c64fbe0f5db7868a89cc9f8713412b](../../../Meta/Digestion/atoms/sha256/f19c5a47126f834bc6db65cd85562ee9c8c64fbe0f5db7868a89cc9f8713412b) ## 定理八：历史绕行读数恢复实际对数导数的极点 | needs-lean | none | d>=3、闭路绕数非零时实际 L_(d,C) 的导数分解为 zeta'/zeta 加全纯背景导数；对数导数留数定理不识别该归一化历史有限差分。 | S01, S20, S50, S108 |
| 150 | [f4f9b0a4df470ba2b4bf10beee83d880ad7f4b3f0386116c90457ebb5d0fe984](../../../Meta/Digestion/atoms/sha256/f4f9b0a4df470ba2b4bf10beee83d880ad7f4b3f0386116c90457ebb5d0fe984) ### 定理十：不使用 RH，也能排除两个实径向上的有限触界 | needs-lean | none | 全部实 -1<x<1 上实际 F_xi(x)>0；theta 核/原始矩正性和首个 Li 系数不提供 xi 在整个 s>1/2 实轴的导数严格正性桥。 | S34, S51, S81, S90 |
| 151 | [f62752ed0e3bef8ecf2a83bb81efd8d286d810248bbeb79696cb3710c0c3b1e5](../../../Meta/Digestion/atoms/sha256/f62752ed0e3bef8ecf2a83bb81efd8d286d810248bbeb79696cb3710c0c3b1e5) ## 定理 K1：这个历史读出是忠实的 | needs-lean | none | 转置伴随矩阵的连续读出 y_v(t)=ell exp(-itC)v 对全部实 t 为零 iff v=0；有限离散可观测性准则缺该伴随矩阵满秩及连续指数桥。 | S93, S101 |
| 152 | [f7638bdcf1e35350eda1b731d962c04911ac25c6a52343035a7db2a5bb04e456](../../../Meta/Digestion/atoms/sha256/f7638bdcf1e35350eda1b731d962c04911ac25c6a52343035a7db2a5bb04e456) ## 定理三：临界处的有限历史间隙有双边幂律 | needs-lean | none | 临界 Toeplitz 最小特征值须存在 c,C>0 并对所有充分大 N 有指定 -2m_* 双边幂律；精确有限谱底定理没有临界符号零点阶数渐近。 | S19, S68, S109 |
| 153 | [f7ca82eaa0b6663d12c0bfd1a9ddf79bed9767d3db424fab41f9fc1bf4da0364](../../../Meta/Digestion/atoms/sha256/f7ca82eaa0b6663d12c0bfd1a9ddf79bed9767d3db424fab41f9fc1bf4da0364) ## 定理 R3：放大后的干涉极限 | needs-lean | none | 实际 rescaled R_n(Omega_n t) 趋于 exp(-t^2)，实紧集和复紧集均局部一致；未找到条件双模分布的尺度极限与复指数矩控制冻件。 | S02, S76, S87, S111 |
| 154 | [f94e72b42f9e6da0084b96b95d047cefcf3467c62f9875897dd6b2e40f6d2e97](../../../Meta/Digestion/atoms/sha256/f94e72b42f9e6da0084b96b95d047cefcf3467c62f9875897dd6b2e40f6d2e97) ## 定理二：开放历史链的精确谱间隙 | needs-lean | none | 单位边权开放历史链的 gap=2-2cos(pi/(T+1)) 及 pi^2/(T+1)^2 渐近，且与具体幺正门无关；未找到路径 Laplacian 精确谱的匹配冻件。 | S04, S25, S92 |
| 155 | [fa8b4b6196fcba7e8ebb4dd83eb2eef163a13a0db12bf2d3c4701126f37ade22](../../../Meta/Digestion/atoms/sha256/fa8b4b6196fcba7e8ebb4dd83eb2eef163a13a0db12bf2d3c4701126f37ade22) ## 定理 J5：该流全局存在、保谱，并与高斯历史等价 | needs-lean | none | 实际非线性流全局存在、每个有限 r 保特征多项式、HS 耗散率精确为 -1/2 交换子平方，且与高斯历史代表酉等价；一般等谱流不覆盖此四项。 | S27, S37, S106 |
| 156 | [fad0a54d7c08517061dd72156313f2d20793a832d69377d4b2c6ccafb4a15a71](../../../Meta/Digestion/atoms/sha256/fad0a54d7c08517061dd72156313f2d20793a832d69377d4b2c6ccafb4a15a71) ## 定理 O3：负特征值的精确计数 | needs-lean | none | 实际无限 K 的负指标等于不同非实共轭对数，允许无穷；已读有限镜像 Krein 指标按解析重数计数，carrier 与计数口径均不匹配。 | S17, S69, S80, S104 |
| 157 | [fb1c38b64efe553d45ac383d0721cd76c7b64279dcff96cd63865be615fbdfb5](../../../Meta/Digestion/atoms/sha256/fb1c38b64efe553d45ac383d0721cd76c7b64279dcff96cd63865be615fbdfb5) ## 引理：三角读出的单侧上界 | needs-lean | none | 三角 Mangoldt 读数对充分大整数 N 有统一单侧上界就推出 RH；局部 Landau 对数导数界不是该实际算术读数的 RH 判据。 | S30, S39, S67, S96 |
| 158 | [fb59b24ac5caf7f843daafe640a109f5656d2c90a088f47e404bc07f5425aefc](../../../Meta/Digestion/atoms/sha256/fb59b24ac5caf7f843daafe640a109f5656d2c90a088f47e404bc07f5425aefc) ## 定理 Q1：所有二次倾斜的 Turán 不等式 | needs-lean | none | 全部 n>=1、lambda:Real 的实际二次倾斜 theta 矩满足系数 (2n-1)/(2n+1) 的严格 Turan 不等式；Karp 二次截断和原始矩正性均不覆盖。 | S14, S53, S62, S90, S107 |
| 159 | [fc7df336d8009cc2fb6b17b81726c35280f4a7c87df6b80aeb2ab2ed62148dc1](../../../Meta/Digestion/atoms/sha256/fc7df336d8009cc2fb6b17b81726c35280f4a7c87df6b80aeb2ab2ed62148dc1) ## 定理一：平滑后的所有有限阶矩阵具有统一正下界 | needs-lean | none | 0<a<1 的概率矩 Poisson 平滑 Toeplitz 矩阵对全部 N 有两侧指定常数和条件数平方上界；通用谱底与 Poisson 传输尾界不提供这些统一常数。 | S19, S95, S103 |
| 160 | [fe2435c31f17b225da1fc23447f6bc697da4eab605315d6d8611f1370db9369d](../../../Meta/Digestion/atoms/sha256/fe2435c31f17b225da1fc23447f6bc697da4eab605315d6d8611f1370db9369d) ## 定理 T5：双副本补偿恒等式 | needs-lean | none | 实际双副本 Wigner W 与原函数 J 的 (d_x+1)^2+4t^2 微分补偿恒等式，未找到该连续 theta 核；离散 ququint Wigner 是不同对象。 | S02, S35, S111 |
| 161 | [fe32fa800185d6c61117be686cf2b1eca3bb051f168159cfafd23edb452fb19f](../../../Meta/Digestion/atoms/sha256/fe32fa800185d6c61117be686cf2b1eca3bb051f168159cfafd23edb452fb19f) ## 推论：细化读数几乎必然最终等于零 | needs-lean | none | 固定 T,H 的嵌套随机细窗读数 M_n 几乎处处最终恰为 0；未找到实际窗口过程、有限 prime-log 障碍集及连续极限分布的连接。 | S30, S39, S94 |
| 162 | [fed862d04754e331ffe1254aa2d4f4f01ae3fb08ffb349002952eee303bf8a3e](../../../Meta/Digestion/atoms/sha256/fed862d04754e331ffe1254aa2d4f4f01ae3fb08ffb349002952eee303bf8a3e) ## 定理 S1：原来的 \(R_n(t)\) 是这些局部读数的特定加权平均 | needs-lean | none | 实际 R_n(t) 等于 x^(2n) 加权的连续 Wigner 半轴积分比，未找到源文条件期望与 W(x,t) 的换元/积分识别冻件。 | S02, S29, S35, S111 |
| 163 | [ff41c11de3a485a3451a5788237056c9099133f734e8bf7b75a1240d6746dd85](../../../Meta/Digestion/atoms/sha256/ff41c11de3a485a3451a5788237056c9099133f734e8bf7b75a1240d6746dd85) ## 定理四：闭环不相容的精确代价 | needs-lean | none | 两路径正时长的能量最小值须等于 \|\|(U1-U2)x\|\|^2/(tau1+tau2)；通用最小二乘投影仅给抽象正交残差，未找到该加权对角子空间的显式投影与代价声明。 | S45, S64, S75, S110 |

## frozen-covered: 088d882f6a10249e981da5d77bc3bb5e53e75a5ee02313bdd7c879cb21e22413

定理：5040 的共同价格区间

- GID: `D5/S3/Arith/GoldenResource5040PriceInterval`; statement_id: `sha256:5ff6c71eede645e4240967fc93b7f3e64324a924d1ed5ba9b002a637e96a3e69`; [state pin](../../../Golden/Frozen/state/D5/S3/Arith/GoldenResource5040PriceInterval.lean.json); [Lean source](../../../D5/S3/Arith/GoldenResource5040PriceInterval.lean).
- Declarations: `golden_resource_5040_unique_maximum_of_price_interval`.
- Scope: lambda : Real; log(12/11)/log(11)<lambda<log(31/30)/log(2); n : Nat, 1<=n; no RH premise.

Quantifiers/domain: Source objective read at QUANTUM-RH.md:38236-38250: log(sum_{d|N}1/d)-lambda log N; Lean definition GoldenResourceOptimalInteger.lean:22 matches. Arbitrary lambda in the same strict interval, arbitrary positive n. Decimal approximations are not additional boxed assertions and were not numerically certified.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; direct projection of frozen statement)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

| Atom clause | Lean binders | Lean assumptions | Lean conclusion | Label |
| --- | --- | --- | --- | --- |
| (31) log(12/11)/log11 < lambda | {lambda : R} | hlower : Real.log (12 / 11) / Real.log 11 < lambda | hypothesis preserved | verbatim |
| (31) lambda < log(31/30)/log2 | {lambda : R} | hupper : lambda < Real.log (31 / 30) / Real.log 2 | hypothesis preserved; neither endpoint admitted | verbatim |
| boxed 5040 + adjoining predicate: global maximum over all positive integers | {n : Nat} (hn : 1 <= n) | hlower, hupper | goldenResourceObjective lambda n <= goldenResourceObjective lambda 5040 | equivalent |
| boxed 5040 + adjoining predicate: unique maximum | for every n : Nat with 1 <= n | same open interval | objective lambda n = objective lambda 5040 <-> n = 5040 | verbatim |

## frozen-covered: 5f5912050d91b5f8998e6799d12c40e766fa4d65798ff890b506a56c3bc0ed3c

定理十九：\((4,2,1,1)\) 是唯一的正整数四元组，使“局部自由度总和 = 完全联合自由度”

- GID: `D5/S3/Arith/GoldenResource/FourFactorSumProductBalance`; statement_id: `sha256:1c446108a1b0a50141da4dc8d497c3e770561cfddf55c2d59193e24ee4fe2ea6`; [state pin](../../../Golden/Frozen/state/D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.lean.json); [Lean source](../../../D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.lean).
- Declarations: `sorted_positive_sum_product_classification`.
- Scope: a b c d : Nat; 0<d, d<=c<=b<=a; sum=product.

Quantifiers/domain: Source positive integers, decreasing order a>=b>=c>=d>=1. Lean naturals with 0<d are exactly this domain; no zero coordinate admitted. Statement is forall quadruples satisfying the displayed equation, not an unrestricted real classification.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; direct projection/instantiation of frozen statement)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

| Atom clause | Lean binders | Lean assumptions | Lean conclusion | Label |
| --- | --- | --- | --- | --- |
| a>=b>=c>=d>=1 | a b c d : Nat | hd : 0<d; hdc : d<=c; hcb : c<=b; hba : b<=a | same ordered positive integer domain | equivalent |
| (111) abcd=a+b+c+d | a b c d : Nat | h : a+b+c+d=a*b*c*d | source equality is h.symm | equivalent |
| (a,b,c,d)=(4,2,1,1) | same universal quadruple | hd,hdc,hcb,hba,h | a=4 /\ b=2 /\ c=1 /\ d=1; tuple extensionality | equivalent |

## frozen-covered: 66fd622e5d54c25826af9d416db18df1d8eecf9c71288d80ff0460237e3e95d2

定理 G2　判别式的下界及其取等情形

- GID: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo`; statement_id: `sha256:184c298cb6b3a6b32640e84511f41eede52d8d0d29ae2b24a68f14ef5722487e`; [state pin](../../../Golden/Frozen/state/D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean.json); [Lean source](../../../D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean).
- Declarations: `g2_discriminant_bound`, `discriminant_eq_output`.
- Scope: alpha,a,b,c,d : Real; G2 scalar identity/bound unrestricted; actual boxplus discriminant identification requires alpha!=-1 and alpha!=-2; specialize a,b,c,d>=0.

Quantifiers/domain: QUANTUM-RH.md:60801-60821 explicitly restricts all G1-G4 to alpha in R\{-1,-2}. g2_discriminant_bound is stronger on a,b,c,d (all reals), safely restricted to nonnegative values. The lower bound uses <=, equality is sufficient when a=b AND c=d, not an iff. The operation uses the corrected PRODUCT prefactor at QUANTUM-RH.md:61194; the obsolete ratio definition is not covered.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; direct projection/instantiation of frozen statement)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

| Atom clause | Lean binders | Lean assumptions | Lean conclusion | Label |
| --- | --- | --- | --- | --- |
| D is the discriminant of G1 output; P=a+b,Q=c+d | alpha a b c d : Real | alpha!=-1; alpha!=-2 | discriminant_eq_output identifies discriminant with discrim of boxplus coefficients 2,1,0 | equivalent |
| D=(P+Q)^2-4ab-4cd-4*kappa(alpha)*P*Q | same; kappa=(alpha+1)/(2*(alpha+2)) | no extra assumption; specialize source domain | (g2_discriminant_bound ...).1 gives identical expression after P,Q expansion | equivalent |
| D>=2*P*Q*(1-2*kappa(alpha)) | same | a,b,c,d>=0 allowed but unnecessary | (g2_discriminant_bound ...).2.1 : 2*(a+b)*(c+d)*(1-2*kappa alpha)<=D | verbatim |
| if a=b and c=d equality holds (unboxed adjoining clause) | same | a=b; c=d | (g2_discriminant_bound ...).2.2 : a=b -> c=d -> D=2*(a+b)*(c+d)*(1-2*kappa alpha) | verbatim |

## frozen-covered: 7901adf784a2db15b73b33751c521fc703f8bbe431efb0304c449cfa3b049907

定理 G1　二次矩形卷积的显式系数

- GID: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo`; statement_id: `sha256:184c298cb6b3a6b32640e84511f41eede52d8d0d29ae2b24a68f14ef5722487e`; [state pin](../../../Golden/Frozen/state/D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean.json); [Lean source](../../../D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean).
- Declarations: `g1_explicit_coefficients`, `definition_consistency`, `normalized_coefficient_convolution`.
- Scope: alpha,a,b,c,d : Real; alpha!=-1 and alpha!=-2; arbitrary real roots; degree exactly 2; corrected product-prefactor coefficient convolution.

Quantifiers/domain: All five parameters are real; only alpha=-1,-2 are excluded. No nonnegative-root or alpha>-1 restriction is added to G1. rootPair matches (X-a)(X-b), kappa matches source. Source erratum QUANTUM-RH.md:61194-61232 explicitly corrects Definition 3.10 to the PRODUCT used by weight/convolutionCoeff. The old ratio-prefactor paragraph is not a covered assertion.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; direct projection/instantiation of frozen statement)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

| Atom clause | Lean binders | Lean assumptions | Lean conclusion | Label |
| --- | --- | --- | --- | --- |
| alpha in R\{-1,-2}; a,b,c,d in R; p=(X-a)(X-b),q=(X-c)(X-d) | alpha a b c d : Real | h1 : alpha!=-1; h2 : alpha!=-2 | rootPair a b=(X-C a)*(X-C b); no further binder restrictions | verbatim |
| p boxplus_2^alpha q = X^2-(a+b+c+d)X+[ab+cd+kappa(alpha)(a+b)(c+d)] | same; p,q specialized rootPair | h1,h2; corrected product-prefactor definition | g1_explicit_coefficients gives polynomial equality with identical leading, linear and constant coefficients | verbatim |
| meaning of boxplus (context obligation) | k : Nat, k<=2; p q : Real[X] | alpha!=-1,-2 for normalized coefficients | definition_consistency and normalized_coefficient_convolution identify the operation with corrected Definition 3.10 | equivalent |

## frozen-covered: 7b2657006891568aa395dfd9fa14bde9d9d23d2ade0c449b00f7cdf5c616baec

定理二：什么时候投影后的几何能够独立执行？

- GID: `D5/S0/Rewriting/Quotients/DynamicsDescent`; statement_id: `sha256:9b68af3f9f0957494c5bd40f72876714752f0082c0d8ebdd1123463365fc025e`; [state pin](../../../Golden/Frozen/state/D5/S0/Rewriting/Quotients/DynamicsDescent.lean.json); [Lean source](../../../D5/S0/Rewriting/Quotients/DynamicsDescent.lean).
- Declarations: `dynamics_descends_iff`.
- Scope: arbitrary types X,B; quotientMap:X->B surjective; update:X->X; instantiate B=Set.range pi and quotientMap x=<pi x,range witness>.

Quantifiers/domain: Source pi:X->Y need not be onto Y; source descended map acts on pi(X). Restrict codomain to B=range pi, giving surjectivity by definition, and take update=T. Equality of subtype values iff equality in Y. ExistsUnique implies Exists; conversely any commuting map through an onto map is unique by evaluating at a preimage, so no source condition is strengthened. Empty X/range also allowed.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; direct projection/instantiation of frozen statement)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

| Atom clause | Lean binders | Lean assumptions | Lean conclusion | Label |
| --- | --- | --- | --- | --- |
| (10) exists Tbar:pi(X)->pi(X), pi o T=Tbar o pi | {X B : Type*}; B=range pi; quotientMap=range restriction of pi; update=T | hSurjective follows from membership in range | left side: ExistsUnique descended, quotientMap o update=descended o quotientMap; uniqueness is automatic on the image | equivalent |
| (11) for all x,y, pi(x)=pi(y) -> pi(Tx)=pi(Ty) | forall x y : X | equality in range reduces to equality of values in Y | right side: forall x y, quotientMap x=quotientMap y -> quotientMap(update x)=quotientMap(update y) | verbatim |
| exists descent iff fiber preservation | same | hSurjective on range; no surjectivity onto original Y assumed | dynamics_descends_iff is the two-way implication; existence/unique-existence equivalence explained above | equivalent |

## frozen-covered: 8ef6b9257471235dae81e95cd49a82d8589c77b60cfb90cd4d4355ed0ae75092

定理 G3　Gribinski 猜想在 \(m=2\) 处成立

- GID: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo`; statement_id: `sha256:184c298cb6b3a6b32640e84511f41eede52d8d0d29ae2b24a68f14ef5722487e`; [state pin](../../../Golden/Frozen/state/D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean.json); [Lean source](../../../D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean).
- Declarations: `g3_nonnegative_roots`.
- Scope: alpha a b c d : Real; -1<alpha; 0<=a,b,c,d; exists r,s:Real with 0<=r,s; degree two and corrected product-prefactor boxplus.

Quantifiers/domain: Source QUANTUM-RH.md:60866 and definition at 60821 identify P_2(R>=0) with nonnegative rootPair. Alpha is any real >-1, including (-1,0), not merely natural or >=0; alpha=-1 excluded. Zero and repeated input/output roots allowed. Universal parameters precede existential r,s; no common witness independent of inputs asserted. Operation follows the appended product-prefactor erratum at 61194; old ratio-prefactor transcription excluded.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; direct projection of frozen statement)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

| Atom clause | Lean binders | Lean assumptions | Lean conclusion | Label |
| --- | --- | --- | --- | --- |
| forall alpha>-1, forall a,b,c,d>=0 | alpha a b c d : Real | halpha : -1<alpha; ha,hb,hc,hd : 0<=a,b,c,d | same universal domain; alpha!=-1,-2 follow without added restrictions | verbatim |
| exists r,s>=0 | r s : Real (existential in conclusion) | halpha,ha,hb,hc,hd | exists r s : Real, 0<=r /\ 0<=s /\ ... | verbatim |
| p boxplus_2^alpha q=(X-r)(X-s) | p=rootPair a b; q=rootPair c d | same source hypotheses and corrected definition | boxplus alpha (rootPair a b) (rootPair c d)=rootPair r s | verbatim |

## frozen-covered: c352d304105e02cbbcb0607e31a1e217adb85d4b344ba0d75c23ba4420dbf0e1

定理 U1：正拼接的必要充分条件

- GID: `D5/S3/Weil/ZetaLinear/ExactStickyReduction`; statement_id: `sha256:311ed2863e85f005429c5613aacc27d7980b6ceba46355745055ba29b96d7984`; [state pin](../../../Golden/Frozen/state/D5/S3/Weil/ZetaLinear/ExactStickyReduction.lean.json); [Lean source](../../../D5/S3/Weil/ZetaLinear/ExactStickyReduction.lean).
- Declarations: `exact_sticky_reduction (first conjunct only)`.
- Scope: real inner-product spaces and real-linear blocks with nonnegative symmetric AQQ and right inverse; instantiate HP=Complex as real space, HQ=Complex^N as real space, APP=d, AQP(z)=b*z, AQQ=G_N, AQQInv=G_N^-1.

Quantifiers/domain: Source context QUANTUM-RH.md:29588-29625 assumes G_N>0 and Hermitian extension [G_N,b;b*,d], so d is real. Take the underlying real spaces, with inner_R(u,v)=Re(inner_C(u,v)); G_N remains symmetric/nonnegative and its complex inverse is also a real-linear right inverse. All complex vectors remain in the carrier, so no real-only restriction is imposed. The theorem's positivity conjunct involves no dimension or inertia count; that second conjunct is not used. Delta is real. Quantification over z in C of delta*|z|^2>=0 is equivalent to delta>=0 by z=1 and norm-square nonnegativity.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; frozen projection with explicit carrier/normalization equivalence)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

| Atom clause | Lean binders | Lean assumptions | Lean conclusion | Label |
| --- | --- | --- | --- | --- |
| context G_N>0; G_(N+1)=[G_N,b;b*,d] | HP=C and HQ=C^N as real inner-product spaces; APP(z)=d*z; AQP(z)=b*z; AQQ(x)=G_N*x; AQQInv(x)=G_N^-1*x | hQQNonneg and hQQSymm from G_N>0; hQQInv from its inverse | hypotheses are satisfied with no extra restrictions; ordering is (z,x) instead of (x,z) | equivalent |
| G_(N+1) positive semidefinite | forall z:C, x:C^N | source Hermitian block and G_N>0 | forall w, 0<=blockEnergy APP AQP AQQ w; energy = d\|z\|^2+2Re(conj(z)*b* x)+x*G_N x | equivalent |
| delta_N:=d-b*G_N^-1*b >=0 | forall z:C in the reduced space | same; r=G_N^-1*(b*z) | schurEnergy(z)=d\|z\|^2-Re(r*G_N r)=(d-b*G_N^-1*b)\|z\|^2; all z nonnegative iff delta_N>=0 | equivalent |
| (U13) both directions of iff | same blocks and all source vectors | hQQNonneg,hQQSymm,hQQInv already discharged by source G_N>0 | (exact_sticky_reduction ...).1 : (forall full vectors, energy>=0) iff (forall reduced vectors, energy>=0) | equivalent |

## frozen-covered: ff5edc2fa518d7aad2e434878eaed431d77462514fb23ba7bdbc47c5183d425e

定理 G4　参数范围 \(\alpha>-1\) 是锐的

- GID: `D5/S3/Zeros/Convolution/GribinskiDegreeTwo`; statement_id: `sha256:184c298cb6b3a6b32640e84511f41eede52d8d0d29ae2b24a68f14ef5722487e`; [state pin](../../../Golden/Frozen/state/D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean.json); [Lean source](../../../D5/S3/Zeros/Convolution/GribinskiDegreeTwo.lean).
- Declarations: `g4_negative_product`, `g4_negative_discriminant`, `g4_parameter_range_sharp`, `preservation_iff`, `g1_explicit_coefficients`.
- Scope: alpha:Real excluding -1,-2; family (1,0,1,0) only -2<alpha<-1; family (1,1,1,1) only alpha<-2; exact preservation iff -1<alpha for degree two corrected product-prefactor convolution.

Quantifiers/domain: No alpha=-1 or alpha=-2 endpoint is admitted. Both open subintervals together exhaust admissible alpha<-1. Each alpha has the specified nonnegative inputs; negation of existence of nonnegative output factorization matches failure of P_2(R>=0). preservation_iff quantifies all nonnegative real a,b,c,d, not just the two examples, and uses G3 for the forward range. In the first family the monic quadratic's constant coefficient equals the product of its two roots by Vieta; it is not an arbitrary coefficient of a nonmonic polynomial. Corrected source operation is the appended product-prefactor definition at QUANTUM-RH.md:61194.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; direct frozen projection and monic Vieta normalization)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

| Atom clause | Lean binders | Lean assumptions | Lean conclusion | Label |
| --- | --- | --- | --- | --- |
| for every admissible alpha<-1 there exist nonnegative inputs whose output fails P_2(R>=0) | alpha : Real; exists a b c d : Real | alpha!=-1; alpha!=-2; alpha<-1 | g4_parameter_range_sharp: 0<=a,b,c,d and not exists r s>=0 with output=rootPair r s | verbatim |
| -2<alpha<-1; (a,b,c,d)=(1,0,1,0); product of roots=kappa(alpha)<0 | alpha : Real; fixed rootPair 1 0 twice | hlo : -2<alpha; hhi : alpha<-1 | g4_negative_product: output.coeff 0=kappa alpha and kappa alpha<0; g1 supplies monicity, so coeff0 is root product; also explicitly no nonnegative factorization | equivalent |
| alpha<-2; (a,b,c,d)=(1,1,1,1); D=8(1-2*kappa(alpha))<0 | alpha : Real; four fixed entries 1 | halpha : alpha<-2 | g4_negative_discriminant: discriminant alpha 1 1 1 1=8*(1-2*kappa alpha), discriminant<0 and all real x output.eval x!=0 | verbatim |
| on R\{-1,-2}, [forall p,q in P_2(R>=0), output in P_2(R>=0)] iff alpha>-1 | alpha : Real; preservesNonnegativeRoots expands forall a b c d : Real ... exists r s : Real ... | h1 : alpha!=-1; h2 : alpha!=-2 | preservation_iff : preservesNonnegativeRoots alpha <-> -1<alpha | verbatim |

## frozen-partial: 0a350824194cd6312628fc5708116dfece7d0e63fec2a1e2f8c201549d63c707

定理三：每一个连续时间切面的 Schmidt 系数都与 \(\theta\) 无关

- GID: `D5/S3/Quantum/Entanglement/CoherentHistorySchmidt`; statement_id: `sha256:12fe938e662c8edbaeefb12298e5fc281e7f17595aafd457281a98bd63db1ca1`; [state pin](../../../Golden/Frozen/state/D5/S3/Quantum/Entanglement/CoherentHistorySchmidt.lean.json); [Lean source](../../../D5/S3/Quantum/Entanglement/CoherentHistorySchmidt.lean).
- Declarations: `normalized_coefficient_factorization`, `schmidt_coefficient_sq`, `cut_sector_gram`, `history_5040_max_schmidt_rank`.
- Scope: finite alphabet; occupation multiset a.card=t+s; coefficientMatrix is the unphased uniform word state; occupation5040=(4,2,1,1), t=s=4.

Quantifiers/domain: Generic multiset cardinality t+s matches cut lengths; specializing to theta=0 is a strict restriction of the source's all-theta quantifier, hence tier 2 only.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; restricted frozen projection)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

Covered:

- (27) theta=0 的均匀合法词态分解（normalized_coefficient_factorization）
- (28) 无相位词态权重 multiplicity(t,b)*multiplicity(s,a-b)/multiplicity(t+s,a)；multiplicity_factorial_spec 给出 h 比值
- (29) theta=0、5040 占据数的中切 rank=12（history_5040_max_schmidt_rank.2）

Missing:

- (27) 对任意实 theta 的 e^(i theta B) 分解及带 theta 子态的正交性
- 对所有连续时间切面、任意 theta 的 Schmidt 系数不变与 (29) 任意 theta 的 rank=12
- 正文所述 Psi_0 与 Psi_(pi/4) 正交及纠缠谱/熵相等

## frozen-partial: 3f70bb4b78d38951e5b98029e96abb9e4d697c94e858de86ce861782dfe79bb9

定理十一：消去正的内部块，不丢失任何负方向

- GID: `D5/S3/Weil/ZetaLinear/ExactStickyReduction`; statement_id: `sha256:311ed2863e85f005429c5613aacc27d7980b6ceba46355745055ba29b96d7984`; [state pin](../../../Golden/Frozen/state/D5/S3/Weil/ZetaLinear/ExactStickyReduction.lean.json); [Lean source](../../../D5/S3/Weil/ZetaLinear/ExactStickyReduction.lean).
- Declarations: `exact_sticky_reduction`.
- Scope: HP,HQ real inner-product spaces; real linear APP,AQP,AQQ,AQQInv; AQQ nonnegative symmetric and AQQ.comp AQQInv=id; negativeIndex : WithTop Nat via injective negative subspaces.

Quantifiers/domain: Read source context 66915-67048: C>0, S=A-BC^-1B*. Real specialization preserves all signs and inverse premises; arbitrary complex blocks are outside the checked scope. No complex equivalence claimed.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; real restricted projection)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

Covered:

- (64) 实对称特例下以负子空间维数定义的惯性相等：exact_sticky_reduction.2；APP=A、AQP=B^T、AQQ=C、AQQInv=C^-1

Missing:

- 源 QUANTUM-RH.md:67004 的复 Hermitian 块 K=[A B;B* C] 与复负本征值个数；冻件 binders 只有 Real，未查得保持计数的复域接线
- 不能直接把复空间限制到实数：负维数会翻倍，须证明两个指标与源 nu_- 的关系

## frozen-partial: c3316916b643d8cf28de3e1b451f7f3ba61d1337f85a87b7eb42cc1568f9621f

定理：只使用 \(2,3,5,7\)，在 5040 之后不会产生 Robin 反例

- GID: `D5/S3/Arith/GoldenResource/RobinRationalBasis`; statement_id: `sha256:6dcafd483a23c78180a3518807013e46c0dccfcb211d2d5f442207eb1ee621c2`; [state pin](../../../Golden/Frozen/state/D5/S3/Arith/GoldenResource/RobinRationalBasis.lean.json); [Lean source](../../../D5/S3/Arith/GoldenResource/RobinRationalBasis.lean).
- Declarations: `robin_delta_10080_pos`.
- Scope: single integer n=10080; robinDelta n=exp(gamma)*n*log(log n)-sigma(1,n); strict positive gap; no RH assumption.

Quantifiers/domain: Strict n>5040 and strict Robin < are preserved at n=10080. Source permits unbounded nonnegative integer exponents; finite verification or the 8-step abundancy bound is not substituted for that universal domain.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; projection and scalar normalization of a frozen special case)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

Covered:

- At exponents (a,b,c,d)=(5,2,1,1), n=10080>5040. robin_delta_10080_pos proves exp(gamma)*10080*log(log10080)-sigma(10080)>0; dividing by positive 10080 gives the source strict inequality.

Missing:

- The universal quantifier over all a,b,c,d in Nat with 2^a*3^b*5^c*7^d>5040, beyond the single point (5,2,1,1), remains uncovered.
- robinPositiveJudge_sound is conditional on an individual rational certificate and does not supply certificates for the entire infinite family.

## frozen-partial: d7dadd8de7fc5350a23612b4039fb0d44648a89b5231db1d0178b194dc965484

定理 T2：原函数的实际 Mellin 读数

- GID: `D5/S3/Analytic/CompletedZetaMellinReconstruction`; statement_id: `sha256:556642d5e8e85422b0991454c2978840a07d8294c7f6ecd9bb37d8826d94e992`; [state pin](../../../Golden/Frozen/state/D5/S3/Analytic/CompletedZetaMellinReconstruction.lean.json); [Lean source](../../../D5/S3/Analytic/CompletedZetaMellinReconstruction.lean).
- Declarations: `completed_zeta_mellin_reconstruction (first conjunct)`.
- Scope: s:Complex, Re(s)>1; completedZetaReading s=pi^(-s/2)*Gamma(s/2)*classicalZeta s; specialize s=sigma:Real>1.
- GID: `D5/S3/Zeros/CompletedZeta`; statement_id: `sha256:afb6048255268029776bca0ff66c9e659d5a2a22c3a4a42c454cac48761d8971`; [state pin](../../../Golden/Frozen/state/D5/S3/Zeros/CompletedZeta.lean.json); [Lean source](../../../D5/S3/Zeros/CompletedZeta.lean).
- Declarations: `xi_reading_eq_completed_zeta`.
- Scope: s:Complex, s!=0 and s!=1; xiReading s=(1/2)*s*(s-1)*completedZetaReading s.

Quantifiers/domain: Source T6 context QUANTUM-RH.md:26503 requires real sigma>1, matching the frozen Re(s)>1 domain. It implies sigma!=0,1 and sigma/2!=0; no pole or endpoint cancellation is assumed at sigma=1. Real/complex embedding and positive pi powers preserve the displayed normalization.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; frozen projection with explicit carrier/normalization equivalence)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

Covered:

- For real sigma>1, xi(sigma)/(2*pi*(sigma-1))=(1/2)*pi^(-1-sigma/2)*Gamma(1+sigma/2)*zeta(sigma). Project the first Mellin reconstruction conjunct, rewrite xi_reading_eq_completed_zeta, cancel sigma-1, and use Complex.Gamma_add_one at sigma/2 (Mathlib/Analysis/SpecialFunctions/Gamma/Basic.lean:312).

Missing:

- Z_+(sigma)=xi(sigma)/(2*pi*(sigma-1)): the full-real-axis integral of g_+ at source T6 is not the frozen symmetric theta-tail integral over t>1. Its change of variables, termwise integration and primitive-kernel bridge remain missing.

## frozen-partial: eea26f8bf5160ec1c324b734ab436c6779a03fdf52687c5a6556c2d8a1878785

定理五：消去历史以后，还会产生一个新的边界度量

- GID: `D5/S3/Arith/GoldenResource/ChainSchurResponse`; statement_id: `sha256:3c508c9eb6dbbb13fbb6b9b1041e2ff69f133f22cd1a504c4eabb577b0999885`; [state pin](../../../Golden/Frozen/state/D5/S3/Arith/GoldenResource/ChainSchurResponse.lean.json); [Lean source](../../../D5/S3/Arith/GoldenResource/ChainSchurResponse.lean).
- Declarations: `inverse_first_order`.
- Scope: finite square Real matrices A,E; requires IsUnit A and IsUnit(A+E). Instantiate A=C,E=-z*I, z:Real; left/right multiply by compatible real B and transpose. Does not quantify complex z or arbitrary complex blocks..

Quantifiers/domain: Source assumes Hermitian C>=Delta I, Delta>0 and all complex |z|<Delta. The read theorem supports the finite real-block, real-z algebraic subcase after C and C-zI invertibility is supplied. This is an explicitly restricted partial match, not the full disk statement. Source definition S(z)=A-zI-B(C-zI)^-1 B* is at QUANTUM-RH.md:56172.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; partial frozen projection with explicit missing bridges)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

Covered:

- For real blocks and real z with IsUnit C and IsUnit(C-zI), inverse_first_order gives (C-zI)^-1=C^-1+z C^-2+z^2 C^-2(C-zI)^-1. Substitution into S gives boxed (19), with M_eff=I+B C^-2 B^T and R=-z^2 B C^-2(C-zI)^-1 B^T. This is scalar-matrix normalization and multiplication of a read identity.

Missing:

- Full complex spectral disk |z|<Delta and complex Hermitian block scope.
- The strict positive-definiteness M_eff>0 in boxed (20).
- The exact operator-norm upper bound ||B||^2 |z|^2/[Delta^2(Delta-|z|)] in boxed (21).
- The source spectral gap must supply the two IsUnit hypotheses; this analytic/spectral connection is not asserted to be a frozen projection.

## frozen-partial: f00571cdc2a69c25cf050185dd4d2b3cb366d39dc5372f8921d94c26744775e1

定理一：三个合并切片的必要充分条件

- GID: `D5/S3/Weil/ZetaLinear/ExactStickyReduction`; statement_id: `sha256:311ed2863e85f005429c5613aacc27d7980b6ceba46355745055ba29b96d7984`; [state pin](../../../Golden/Frozen/state/D5/S3/Weil/ZetaLinear/ExactStickyReduction.lean.json); [Lean source](../../../D5/S3/Weil/ZetaLinear/ExactStickyReduction.lean).
- Declarations: `exact_sticky_reduction (first conjunct)`.
- Scope: real inner-product spaces HP=Real, HQ=Real^2; APP=p↦d*p, AQP=p↦(-w*p/4,-eta*kappa*p/4), AQQ=diag(1,w/4), AQQInv=diag(1,4/w), where w=1-eta^2>0, d=[w(4+w)-4*kappa^2]/16. Applies to the explicit matrix energy; no derivatives of the actual kernel..

Quantifiers/domain: eta,kappa:Real with 0<eta<1; w>0 makes the diagonal block positive and its stated inverse valid. schurEnergy(p)=(w^2-kappa^2)/(4w)*p^2, hence nonnegative for all p iff kappa^2<=w^2 iff |kappa|<=w. Actual definitions eta=phi'(tau0), kappa=phi''(tau0) are source substitutions, but identification of J2 with formula (8) requires a separate derivative calculation.

proof_shape: `bind-only`; escape_witness: `null`; admission_basis: `not-applicable(screening-only; partial frozen projection with explicit missing bridges)`. Direct frozen dependencies are exactly the interfaces listed above. No content claim or escape witness is made.

Covered:

- Conditional on the explicit matrix equality (8) in QUANTUM-RH.md:35170-35260, boxed (9)'s matrix-algebra part follows from the first conjunct of exact_sticky_reduction. The permutation placing the third coordinate in HP leaves positivity unchanged.
- For w=1-eta^2>0, the same scalar condition is equivalent to |kappa|<=1-eta^2, the algebraic content of boxed (10).

Missing:

- The defined J2 is the matrix of mixed derivatives of the actual kernel cosh((phi(tau)-phi(sigma))/2)/cosh((tau-sigma)/2). No frozen statement found proving its equality to source formula (8).
- Accordingly, neither boxed claim is marked fully covered for the actual derivative Gram carrier; the frozen match is only the explicit finite-matrix subclaim.

## Search Receipts

Counts are matching lines including comments in baseline D5 Lean files, unless another path is explicit. File names and matching lines were used for discovery and the cited declaration signatures were then read. C+ initially failed because actual theorem names start with g1/g2; C+2 validates word boundaries, alternation and whitespace. C+3/C-2 validate case-insensitive word boundaries. The first S24 output was truncated; its invalid count was discarded and S24-count counts the complete stream. No zero count from an invalid/truncated run supports a classification.

| ID | Command | Matching lines |
| --- | --- | ---: |
| C+ | `rg -n --glob '*.lean' '\b(theorem\|lemma)\s+gribinski' D5` | 0 |
| C- | `rg -n --glob '*.lean' '\b(theorem\|lemma)\s+section_screen_absent_0909' D5` | 0 |
| S01 | `rg -n --glob '*.lean' '(?i)polygon\|winding\|argument.?principle\|rouch' D5` | 293 |
| S02 | `rg -n --glob '*.lean' '(?i)wigner\|hudson\|conditional.*theta\|theta.*negative' D5` | 91 |
| S03 | `rg -n --glob '*.lean' '(?i)causal.?cone\|bandwidth\|interaction.?degree\|finite.?propagation' D5` | 0 |
| S04 | `rg -n --glob '*.lean' '(?i)clock\|history.?state\|partial.?trace' D5` | 393 |
| S05 | `rg -n --glob '*.lean' '(?i)hermite\|real.?root.*trace\|trace.*real.?root\|companion.*square' D5` | 33 |
| S06 | `rg -n --glob '*.lean' '(?i)pyramid\|four.?pyramid\|fibonacci.?polytope\|independen.*polytope' D5` | 0 |
| S07 | `rg -n --glob '*.lean' '(?i)successor.*local\|local.*successor\|add.?one.*depth\|depth.*local' D5` | 10 |
| S08 | `rg -n --glob '*.lean' '(?i)jensen\|scaled.?derivative\|derivative.*scal' D5` | 208 |
| S09 | `rg -n --glob '*.lean' '(?i)5040\|colossal\|common.?price' D5` | 403 |
| S10 | `rg -n --glob '*.lean' '(?i)schmidt\|occupation.*phase' D5` | 308 |
| S11 | `rg -n --glob '*.lean' '(?i)gaussian.*volume\|history.*volume\|volume.*real.?root\|completely.?monoton' D5` | 1 |
| S12 | `rg -n --glob '*.lean' '(?i)spectral.?defect\|imaginary.*square\|coeff.*growth\|coefficient.*rate' D5` | 11 |
| S13 | `rg -n --glob '*.lean' '(?i)filter.*energy\|energy.*filter\|screen.*energy' D5` | 4 |
| S14 | `rg -n --glob '*.lean' '(?i)double.?factorial\|gaussian.*moment\|moment.*gaussian\|turan' D5` | 22 |
| S15 | `rg -n --glob '*.lean' '(?i)dirichlet.*nonzero\|nonzero.*dirichlet\|history.*dirichlet\|cycle.*dirichlet' D5` | 0 |
| S16 | `rg -n --glob '*.lean' '(?i)fidelity\|effective.?dimension\|clock.*overlap\|phase.*separation' D5` | 126 |
| S17 | `rg -n --glob '*.lean' '(?i)schatten\|negative.?part\|negative.*trace\|scale.*inertia' D5` | 156 |
| S18 | `rg -n --glob '*.lean' '(?i)schur\|positive.*threshold\|positivity.*radius' D5` | 159 |
| S19 | `rg -n --glob '*.lean' '(?i)toeplitz\|szego' D5` | 369 |
| S20 | `rg -n --glob '*.lean' '(?i)winding.*coefficient\|monodromy\|periodic.*winding' D5` | 100 |
| S21 | `rg -n --glob '*.lean' '(?i)pick.*mismatch\|spectral.*mismatch\|sampling.*negative\|negative.*sampl' D5` | 13 |
| S22 | `rg -n --glob '*.lean' '(?i)bessel' D5` | 1 |
| S23 | `rg -n --glob '*.lean' '(?i)multinomial\|qbinomial\|q.?binomial\|parity.*histor' D5` | 37 |
| C+2 | `rg -n --glob '*.lean' '\b(theorem\|lemma)\s+g1_explicit_coefficients' D5` | 1 |
| C+3 | `rg -n --glob '*.lean' '(?i)\bGRIBINSKIDEGREETWO\b' D5` | 4 |
| C-2 | `rg -n --glob '*.lean' '(?i)\bsection_screen_absent_0909\b' D5` | 0 |
| S24-count | `rg -n --glob '*.lean' '(?i)hankel\|quadrature\|stieltjes' D5` | 812 |
| S25 | `rg -n --glob '*.lean' '(?i)banded\|band.?matrix\|locality\|propagation.*pow\|pow.*propagation' D5` | 46 |
| S26 | `rg -n --glob '*.lean' '(?i)convex.?hull\|legal.*triple\|admissible.*triple\|fibonacci.*convex' D5` | 40 |
| S27 | `rg -n --glob '*.lean' '(?i)history.*(gram\|gauss\|determinant)\|gauss.*(metric\|histor)\|spectral.?abscissa' D5` | 1 |
| S28 | `rg -n --glob '*.lean' '(?i)arrowhead\|differentiator\|principal.*derivative\|characteristic.*derivative' D5` | 0 |
| S29 | `rg -n --glob '*.lean' '(?i)gamma.*(random\|independen\|decompos)\|exponential.*(shift\|decompos)\|mellin.*(probab\|primitive)' D5` | 17 |
| S30 | `rg -n --glob '*.lean' '(?i)prime.*energy\|energy.*prime\|quadratic.*cancellation\|energy.*trichotomy' D5` | 94 |
| S31 | `rg -n --glob '*.lean' '(?i)contact.*(radial\|scal\|negative)\|radial.*(contact\|negative)\|first.*crossing' D5` | 13 |
| S32 | `rg -n --glob '*.lean' '(?i)schur.*inertia\|inertia.*schur\|schur.*negative\|negative.*schur' D5` | 3 |
| S33 | `rg -n --glob '*.lean' '(?i)swap.*(realign\|unitary\|sin)\|realign\|reshuffl' D5` | 21 |
| S34 | `rg -n --glob '*.lean' '(?i)phase.*repair\|contractiv\|schur.?function\|cayley.*(zero\|rh)' D5` | 265 |
| S35 | `rg -n --glob '*.lean' '(?i)primitive\|tail.?integral' D5` | 1272 |
| S36 | `rg -n --glob '*.lean' '(?i)low.?temperature\|fisher.?zero\|partition.*(converg\|summab)\|normaliz.*boundary' D5` | 15 |
| S37 | `rg -n --glob '*.lean' '(?i)commutator.*(flow\|gradient)\|double.?bracket\|isospectral\|gauss.*residu' D5` | 5 |
| S38 | `rg -n --glob '*.lean' '(?i)cyclotomic.*(multiplicity\|order)\|q.?multinomial\|inversion.*polynomial\|major.?index' D5` | 2 |
| S39 | `rg -n --glob '*.lean' '(?i)low.?frequenc\|frequency.*trunc\|dyadic.*energy' D5` | 8 |
| S40 | `rg -n --glob '*.lean' '(?i)trial.?divis\|instruction.*count\|counter.?machine' D5` | 0 |
| S41 | `rg -n --glob '*.lean' '(?i)negative.*(monoton\|rate)\|negativePart\|negTrace' D5` | 157 |
| S42 | `rg -n --glob '*.lean' '(?i)retur.*(moment\|measure)\|moment.*endpoint\|resolvent.*(upper\|lower)' D5` | 5 |
| S43 | `rg -n --glob '*.lean' '(?i)product.*sum.*(quad\|four)\|quad.*(product\|sum)\|four.*(product\|sum)\|4211' D5` | 230 |
| S44 | `rg -n --glob '*.lean' '(?i)descen.*(dynam\|fiber\|fibre)\|dynam.*(quotient\|descen)\|semiconjug\|fiber.*(preserv\|stable)' D5` | 370 |
| S45 | `rg -n --glob '*.lean' '(?i)plaquette\|flat.?connection\|holonomy\|path.?independ' D5` | 437 |
| S46 | `rg -n --glob '*.lean' '(?i)cut.*(path\|histor)\|path.*(cut\|partition)\|faithful.*cut\|separator.*sum' D5` | 84 |
| S47 | `rg -n --glob '*.lean' '(?i)vectoriz\|choi.*(trace\|inner)\|trace.*square\|relative.?amplitude' D5` | 32 |
| S48 | `rg -n --glob '*.lean' '(?i)rising.?factorial\|ascFactorial\|pochhammer\|low.?order.*bound' D5` | 145 |
| S49 | `rg -n --glob '*.lean' '(?i)first.?return\|return.?probability\|return.*discount\|schur.*coeff' D5` | 216 |
| S50 | `rg -n --glob '*.lean' '(?i)log.*deriv.*residu\|residu.*log.*deriv\|multiple.?zero\|multiplicity.*resid' D5` | 15 |
| S51 | `rg -n --glob '*.lean' '(?i)fixed.*interval\|real.*interval.*positive\|local.*pick\|pick.*interval' D5` | 3 |
| S52 | `rg -n --glob '*.lean' '(?i)normSq.*(filter\|projection)\|projection.*probability\|invariant.*fock' D5` | 42 |
| S53 | `rg -n --glob '*.lean' '(?i)laguerre.*(criter\|positiv)\|generalized.*laguerre\|laguerre.*inequal' D5` | 7 |
| S54 | `rg -n --glob '*.lean' '(?i)f.?star\|positivity.*interval\|critical.*radius\|contact.*threshold' D5` | 92 |
| S55 | `rg -n --glob '*.lean' '(?i)vectori[sz]\|choi.*(trace\|inner)\|trace.*(pairing\|square)\|schmidt.*(norm\|trace)' D5/S3/Quantum` | 26 |
| S56 | `rg -n --glob '*.lean' '(?i)jensen.*(recover\|reconstruct\|coeff\|compat)\|coeff.*(jensen\|trunc)\|degree.*(dilut\|suppress)' D5` | 54 |
| S57 | `rg -n --glob '*.lean' '(?i)(square\|grid).*commut\|commut.*square\|unitary.*(path\|transport)\|transport.*unitary' D5` | 40 |
| S58 | `rg -n --glob '*.lean' '(?i)path.*weight\|weight.*path\|partition.*(gluing\|splice\|factor)\|sum.*(cutset\|cut.?set)' D5` | 32 |
| S59 | `rg -n --glob '*.lean' '(?i)swap.*(cancel\|parity)\|antisym.*(sum\|probab)\|involution.*(cancel\|sum)' D5` | 13 |
| S60 | `rg -n --glob '*.lean' '(?i)trace.*(kronecker\|entangled)\|entangled.*trace\|amplitude.*trace\|hilbert.?schmidt.*inner' D5` | 63 |
| S61 | `rg -n --glob '*.lean' '(?i)defect.*(approx\|limit)\|imaginary.*spectr\|spectrum.*imaginary\|spectral.*radius.*limit' D5` | 1 |
| S62 | `rg -n --glob '*.lean' '(?i)moment.*(recurrence\|recursion)\|recurr.*moment\|theta.*moment' D5` | 27 |
| S63 | `rg -n --glob '*.lean' '(?i)fixed.*filter\|filter.*stability\|binomial.*(bound\|zeta)\|period.*nonvanish' D5` | 8 |
| S64 | `rg -n --glob '*.lean' '(?i)schur.*(minimiz\|minimum\|variational)\|minimiz.*(schur\|quadratic)\|endpoint.*energy\|energy.*endpoint' D5` | 1 |
| S65 | `rg -n --glob '*.lean' '(?i)reflect.*(disk\|disc\|poisson)\|poisson.*pair\|negative.*(disk\|disc)\|mobius.*(circle\|disk)' D5` | 29 |
| S66 | `rg -n --glob '*.lean' '(?i)gauss.*quadrature\|jacobi.*moment\|moment.*jacobi\|quadrature.*exact' D5` | 19 |
| S67 | `rg -n --glob '*.lean' '(?i)prime.?only\|pure.?prime\|prime.*limsup\|triangular.*(prime\|zero)\|prime.*square.*(offset\|bias)' D5` | 19 |
| S68 | `rg -n --glob '*.lean' '(?i)trace.?class.*(trunc\|tail)\|trunc.*trace.?class\|toeplitz.*invert\|hankel.*tail\|supergeometric' D5` | 12 |
| S69 | `rg -n --glob '*.lean' '(?i)bezout\|be[zé]zout\|negative.*(root\|pair)\|hermite.*inertia' D5` | 93 |
| S70 | `rg -n --glob '*.lean' '(?i)nevanlinna\|pick.*positive\|kernel.*(rh\|riemann)\|herglotz' D5` | 108 |
| S71 | `rg -n --glob '*.lean' '(?i)dirichlet.*four\|fourth.*(euler\|dirichlet)\|1\.5125\|log.*alpha.*log' D5` | 35 |
| S72 | `rg -n --glob '*.lean' '(?i)robin\|7.?smooth\|seven.?smooth\|2357' D5` | 139 |
| S73 | `rg -n --glob '*.lean' '(?i)parity.*(complement\|reflection)\|complement.*parity\|divisor.*(gamma\|reflect)\|omega.*commut' D5` | 3 |
| S74 | `rg -n --glob '*.lean' '(?i)blaschke.*(kernel\|rank)\|kernel.*blaschke' D5` | 9 |
| S75 | `rg -n --glob '*.lean' '(?i)series.*(energy\|resistance)\|weighted.*(path\|chain).*energy\|dirichlet.*(boundary\|schur)\|schur.*(form\|square)' D5` | 8 |
| S76 | `rg -n --glob '*.lean' '(?i)lambert\|two.?mode.*gauss\|saddle.?point\|tilted.*decreas' D5` | 18 |
| S77 | `rg -n --glob '*.lean' '(?i)jensen.*(bound\|zero.?free)\|zero.?free.*jensen\|uniform.*root.*bound\|root.*uniform.*bound' D5` | 20 |
| S78 | `rg -n --glob '*.lean' '(?i)(defect\|de.?branges\|pick).*product\|product.*(defect\|de.?branges)\|rank.?one.*kernel' D5` | 19 |
| S79 | `rg -n --glob '*.lean' '(?i)divisor.*(complement\|operator\|parity)\|total.?exponent.*parity\|factorization.*even' D5/S3` | 7 |
| S80 | `rg -n --glob '*.lean' '(?i)trace.?class\|traceClass\|nuclear.*operator\|summable.*matrix' D5/S3` | 17 |
| S81 | `rg -n --glob '*.lean' '(?i)two.?point.*(pos\|xi)\|xi.*(monoton\|positive\|inequal)\|log.?deriv.*(monoton\|quotient)' D5` | 278 |
| S82 | `rg -n --glob '*.lean' '(?i)schur.*pos\|pos.*schur' D5` | 11 |
| S83 | `rg -n --glob '*.lean' '(?i)minimal.*(repair\|trace)\|repair.*(rank\|trace)\|negative.*(minimal\|correction)' D5` | 68 |
| S84 | `rg -n --glob '*.lean' '(?i)jensen.*(real.?root\|hyperbol\|lower)\|rolle\|positive.*roots.*deriv' D5` | 883 |
| S85 | `rg -n --glob '*.lean' '(?i)warped\|sectional.*curvature\|pyramid\|fisher.*curvature' D5` | 0 |
| S86 | `rg -n --glob '*.lean' '(?i)survival.*(prob\|norm)\|prob.*survival\|return.*conserv\|telescop.*probab\|monitor.*unitary' D5` | 0 |
| S87 | `rg -n --glob '*.lean' '(?i)variance.*(cos\|characteristic\|interference)\|cos.*variance\|schwarz.?lemma' D5` | 6 |
| S88 | `rg -n --glob '*.lean' '(?i)gamma.*(integer\|zeta\|random)\|mellin.*(primitive\|xi)\|subgaussian\|sub.?gaussian' D5` | 38 |
| S89 | `rg -n --glob '*.lean' '(?i)jensen.*(real.?root\|hyperbol\|lower)\|\brolle\b\|positive.*roots.*deriv' D5` | 15 |
| S90 | `rg -n --glob '*.lean' '(?i)\bxi\w*.*(monoton\|positive\|inequal)\|two.?point.*pos\|turan\|log.?concav.*moment' D5` | 27 |
| S91 | `rg -n --glob '*.lean' '(?i)cos.*(integral\|expect)\|characteristic.*quadratic\|norm.*projection.*sum\|projection.*pythag' D5` | 16 |
| S92 | `rg -n --glob '*.lean' '(?i)history.*gap\|propagation.*gap\|path.*laplacian\|laplacian.*path\|feynman.?kitaev\|open.*chain.*spectr' D5` | 0 |
| S93 | `rg -n --glob '*.lean' '(?i)companion.*observ\|observ.*companion\|output.*zero.*iff\|faithful.*histor\|histor.*faithful' D5` | 3 |
| S94 | `rg -n --glob '*.lean' '(?i)eventually.*zero\|eventual.*vanish\|martingale\|borel.?cantelli' D5` | 73 |
| S95 | `rg -n --glob '*.lean' '(?i)poisson.*(toeplitz\|bound\|floor)\|toeplitz.*(smooth\|poisson\|condition)\|smoothing.*(positive\|floor)' D5` | 1 |
| S96 | `rg -n --glob '*.lean' '(?i)von.?mangoldt.*(bound\|triang)\|triang.*(read\|zeta)\|riesz.*mean\|landau.*(singular\|rh\|bound)' D5` | 16 |
| S97 | `rg -n --glob '*.lean' '(?i)confluent.*(pick\|gram)\|jet.*curvature\|curvature.*slack\|phase.*second.*deriv' D5` | 11 |
| S98 | `rg -n --glob '*.lean' '(?i)negative.*polynomial.*test\|polynomial.*negative.*witness\|rational.*negative.*(square\|test)\|reflected.*moment' D5` | 7 |
| S99 | `rg -n --glob '*.lean' '(?i)adjacent.*orthogon\|neighbou?r.*orthogon\|two.?mode\|double.*copy.*kernel' D5` | 21 |
| S100 | `rg -n --glob '*.lean' '(?i)(even\|odd\|parity\|involution).*orthogon\|orthogon.*(parity\|involution)\|self.?adjoint.*eigen' D5` | 6 |
| S101 | `rg -n --glob '*.lean' '(?i)observability.*(kernel\|full\|rank)\|observ.*(exponential\|krylov)\|krylov.*(observ\|basis)' D5` | 110 |
| S102 | `rg -n --glob '*.lean' '(?i)norm.*resolvent\|resolvent.*norm\|schur.*remainder\|effective.*mass' D5` | 16 |
| S103 | `rg -n --glob '*.lean' '(?i)poissonKernel\|poisson_kernel\|smooth.*toeplitz' D5/S3/Weil` | 9 |
| S104 | `rg -n --glob '*.lean' '(?i)negative.*index.*(pair\|mirror)\|nonreal.*pair\|negative.*square.*interpol' D5` | 3 |
| S105 | `rg -n --glob '*.lean' '(?i)(compress\|residual\|defect).*(commutator\|hilbert.?schmidt)\|commutator.*(compress\|trace\|bound)' D5` | 9 |
| S106 | `rg -n --glob '*.lean' '(?i)gauss.*(flow\|gram\|differential)\|double.?bracket\|isospectral\|lax.*flow' D5` | 3 |
| S107 | `rg -n --glob '*.lean' '(?i)(power.?series\|expansion).*nonnegative\|nonnegative.*(coeff\|expansion)\|sum.*square.*exp' D5` | 60 |
| S108 | `rg -n --glob '*.lean' '(?i)history.*log\|log.*history\|winding.*(zeta\|deriv)\|zeta.*winding' D5` | 34 |
| S109 | `rg -n --glob '*.lean' '(?i)critical.*(toeplitz\|eigenvalue)\|toeplitz.*(asymptot\|power)\|symbol.*zero.*order' D5` | 1 |
| S110 | `rg -n --glob '*.lean' '(?i)(weighted\|two.?point).*squared.*(min\|distance)\|minim.*(energy\|squared)\|parallel.*(resist\|energy)' D5` | 8 |
| S111 | `rg -n --glob '*.lean' '(?i)wigner\|double.?copy\|two.?copy\|interference.*(gauss\|limit)' D5` | 86 |

Full count collection for streaming receipts: `rg -n ... | node` consumes stdout, splits into matching lines, and emits the count and distinct paths. Final result.json retains collection commands and returned paths. Controls: C+2=1, C+3=4, C-=0, C-2=0.

## Limitations And Nonclaims

- ASSUMED-UNVERIFIED: repository search is bounded; equivalent differently named theorems outside recorded hits may remain. Third-party pages and unlisted modules were not opened.
- ASSUMED-UNVERIFIED: no new Lean compilation, elaborated dependency audit, readiness run, or independent fidelity review. Existing frozen pins are read as recorded, not recomputed.
- Source mathematical truth is not newly proved; a needs-lean row means an assertion without a matching frozen declaration found, and may also require source correction.
- No cover, deposit, Lean edit, digestion-ledger edit, or PR.
- No claim that make cover checked fidelity.
- No claim that this screening or repository search is exhaustive.
- No proof/provability claim or implication to RH or a larger conjecture; no independent-review or multi-model consensus claim.
