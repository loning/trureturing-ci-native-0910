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

Screened: 30 / 164. frozen-covered: 1; frozen-partial: 1; needs-lean: 28; not-an-assertion: 0; unreadable: 0.

All screened source bodies were read in full. The theorem-like headings are not treated as evidence by themselves. Source IDs are quantum-rh. Atom links point to immutable CAS bodies. The input bytes field is retained as supplied and is not used as a classifier.

Scope: state pins identify the module statement; theorem selectors are listed separately, not presented as independently pinned statement IDs. proof_shape describes the proposed use (direct projection/instantiation), not a new audit of the existing theorem's original proof. No new public theorem was produced; admission_basis is not applicable.

## Sorted Candidates

| Input # | Atom / title | Tier | Frozen GID or none | Reason / missing scope | Searches |
| ---: | --- | --- | --- | --- | --- |
| 9 | [088d882f6a10249e981da5d77bc3bb5e53e75a5ee02313bdd7c879cb21e22413](../../../Meta/Digestion/atoms/sha256/088d882f6a10249e981da5d77bc3bb5e53e75a5ee02313bdd7c879cb21e22413) ## 定理：5040 的共同价格区间 | frozen-covered | `D5/S3/Arith/GoldenResource5040PriceInterval` | 开价格区间、全体正整数、全局最大值和取等唯一性均与冻结陈述相符。 | S09 |
| 10 | [0a350824194cd6312628fc5708116dfece7d0e63fec2a1e2f8c201549d63c707](../../../Meta/Digestion/atoms/sha256/0a350824194cd6312628fc5708116dfece7d0e63fec2a1e2f8c201549d63c707) ## 定理三：每一个连续时间切面的 Schmidt 系数都与 \(\theta\) 无关 | frozen-partial | `D5/S3/Quantum/Entanglement/CoherentHistorySchmidt` | 冻结件覆盖 theta=0 的分解、权重和中切 rank=12；未覆盖任意 theta 的相位历史。 | S10, S23 |
| 1 | [028cb6a153eaec67ee356ef9571a406a6d9460c0092fbc031df4abab42884a85](../../../Meta/Digestion/atoms/sha256/028cb6a153eaec67ee356ef9571a406a6d9460c0092fbc031df4abab42884a85) ## 定理十一：有限多边形绕数证书 | needs-lean | none | 若每段严格误差界成立则矩形零点数等于多边形绕数；RoucheZeroCount 只给两个解析函数的零数相等，缺线性插值误差 Bh^2/8 与多边形绕数桥。 | S01 |
| 2 | [04174c1260762c6fb3fe24cd51b93eea78714592b4cd71e927db335d5edf8b77](../../../Meta/Digestion/atoms/sha256/04174c1260762c6fb3fe24cd51b93eea78714592b4cd71e927db335d5edf8b77) ## 定理 S2：实际 theta 条件读数存在负区 | needs-lean | none | 断言实际 theta-Wigner 读数存在严格负点及非零成功概率窗口；命中的有限离散 Wigner 接口不涉及此连续核。 | S02, S22 |
| 3 | [062d6f5a910eed117ab7596a2e34f1a6a0728de5e8599136b47689b29d2870c9](../../../Meta/Digestion/atoms/sha256/062d6f5a910eed117ab7596a2e34f1a6a0728de5e8599136b47689b29d2870c9) ### 定理二十：交互阶数具有离散因果锥 | needs-lean | none | 对所有离散 t>=0 和 \|r-s\|>Jt 的投影传播恒零；未找到这一交互阶数分级或带宽幂传播断言。 | S03 |
| 4 | [0715d2f9078c88ee013814d101b0c36bdb33c5cf5ce76d58239e51cc6485df25](../../../Meta/Digestion/atoms/sha256/0715d2f9078c88ee013814d101b0c36bdb33c5cf5ce76d58239e51cc6485df25) ## 定理四：Toeplitz 矩阵是历史态的时钟约化密度矩阵 | needs-lean | none | 构造态后断言偏迹恰为 T_N/(N+1)；通用局部偏迹等价接口没有历史态、Toeplitz 元素及归一化等式。 | S04, S19 |
| 5 | [072eca25d260537060a5e1b2b7dada75dbf623eba8eebb4bad8c765d8ebe6749](../../../Meta/Digestion/atoms/sha256/072eca25d260537060a5e1b2b7dada75dbf623eba8eebb4bad8c765d8ebe6749) ## 定理 N1：有限负证书 | needs-lean | none | 任意实 q、任意实多项式 f 的伴随矩阵迹平方非负 iff 全部实根；已有有限根表 Newton-Hankel 判据，未找到整个 f(C_q)^2 陈述及任意 q 到根表的已冻桥。 | S05, S24-count |
| 6 | [0831062a074c8393d5e0d16a4caa4487d783311664ffa661ab52092973475c5b](../../../Meta/Digestion/atoms/sha256/0831062a074c8393d5e0d16a4caa4487d783311664ffa661ab52092973475c5b) ## 定理一：\(P\) 是一个四棱锥 | needs-lean | none | P 的精确凸集、底面与五个顶点是集合等式断言；未找到五个合法三位词凸包与所列不等式的同一声明。 | S06 |
| 7 | [083b7658fb28ffb6609e6c46923ebd4e8c9c27dc3813f06187a0aa23c398e7d4](../../../Meta/Digestion/atoms/sha256/083b7658fb28ffb6609e6c46923ebd4e8c9c27dc3813f06187a0aa23c398e7d4) ## 定理一：规范加一的最坏局部深度至少与编码跨度成正比 | needs-lean | none | 对所有满足源局部性条件的加一算法，R*tau>=L-1 且奇 L 时>=L；已有加一正确性与顺序制备容量不能代替该局部时间下界。 | S07, S03 |
| 8 | [087e3caa7c278b4ea58f06604daa8721ab5258f6c451a25ed8f2d0092d823ca0](../../../Meta/Digestion/atoms/sha256/087e3caa7c278b4ea58f06604daa8721ab5258f6c451a25ed8f2d0092d823ca0) ## 定理 B1：精确微分兼容关系 | needs-lean | none | 对每个 d>=2，q_d'=d*((d-1)/d)^(d-1)*q_(d-1)(x/alpha_d)；冻件是 J_d-v/d*J_d' 的降阶恒等式，未找到反转 q_d 后的导数声明。 | S08 |
| 11 | [0d2c6e9ed518bfcee93cc1f4b71877666e729b3db0f05d06a2b43bbf53e86984](../../../Meta/Digestion/atoms/sha256/0d2c6e9ed518bfcee93cc1f4b71877666e729b3db0f05d06a2b43bbf53e86984) ## 定理 L3：逐阶系数判据 | needs-lean | none | 全部实根 iff S_q>=0 且对每个 k>=1 有 b_(q,k)<=S_q^k/k!；Newton-Hankel 的有限二次型判据没有这条全阶系数界。 | S05, S11, S12 |
| 12 | [0e1a7beb490fc5aece3b6e13b10c6523ab64fac627efd6b825dc5c5551af5eab](../../../Meta/Digestion/atoms/sha256/0e1a7beb490fc5aece3b6e13b10c6523ab64fac627efd6b825dc5c5551af5eab) ## 定理 K2：实根的历史体积上限 | needs-lean | none | 实根前件下所有 r>0 的 0<Z_q(r)<=1 与每阶交替导数非负；未找到实际高斯历史体积及完全单调声明。 | S11, S14 |
| 13 | [0e8d9e20c8a7ec0e0820053dc56a9dae075722a110b78a0ecee60b5cb202f2d8](../../../Meta/Digestion/atoms/sha256/0e8d9e20c8a7ec0e0820053dc56a9dae075722a110b78a0ecee60b5cb202f2d8) ## 推论：系数增长率直接给出谱缺陷 | needs-lean | none | 系数 limsup 精确为 Q_q，并恢复所有虚部平方和；未找到 b_(q,k) 的指数率及两式相接的冻结件。 | S11, S12 |
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

Full count collection for streaming receipts: `rg -n ... | node` consumes stdout, splits into matching lines, and emits the count and distinct paths. Final result.json retains collection commands and returned paths. Controls: C+2=1, C+3=4, C-=0, C-2=0.

## Limitations And Nonclaims

- ASSUMED-UNVERIFIED: repository search is bounded; equivalent differently named theorems outside recorded hits may remain. Third-party pages and unlisted modules were not opened.
- ASSUMED-UNVERIFIED: no new Lean compilation, elaborated dependency audit, readiness run, or independent fidelity review. Existing frozen pins are read as recorded, not recomputed.
- Source mathematical truth is not newly proved; a needs-lean row means an assertion without a matching frozen declaration found, and may also require source correction.
- No cover, deposit, Lean edit, digestion-ledger edit, or PR.
- No claim that make cover checked fidelity.
- No claim that this screening or repository search is exhaustive.
- No proof/provability claim or implication to RH or a larger conjecture; no independent-review or multi-model consensus claim.
