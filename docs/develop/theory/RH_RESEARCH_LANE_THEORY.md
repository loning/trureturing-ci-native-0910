上一轮交付包内的标准库精确诊断现已重放：119 个多项式几何尾式、86 组带符号二阶差分序列、180 个有理复数 Möbius 往返、216 个复 Toeplitz Gram 恒等式及 96 个有限零阶障碍。重放是作者自检，不是独立复核或 Lean 内核证据。源码与该数学追加的远端身份另外通过 commit/blob 回读核对。

---

## [PR #6219 continuation] Canonical disk equivalence and radius-dependent coefficient obstruction

日期：2026-09-07。首先恢复上一轮缺失的理论追加：`b00b74c874b7fe6afbd975182d660e034ce1072a` 将已完成的 canonical 增长到实际 ξ 无零点推导补入本卷，87 行新增、零删除。六份既有 Lean/Scribe 的完整远端内容已重新回读。恢复并没有改变这些候选证明的编译状态。

本轮继续使用 merged #6172 的同一 canonicalLiCoefficient、liGenerator 和 generator_taylor_coefficient。新扫描 dev 为 `65457467c879007d1e91f71ef861a4d3f7d462c3`；canonical 来源 blob 仍为 `0fb04eb79f87389016b51af25cdf6078d5616b7c`，当前 v4.3 规范 blob 为 `473d684ffda13d291c7df78f0edd8d4922550be6`。跨作者的相关 PR 与默认分支检索未找到可直接替代本轮全盘反向端点的新实现；工程类命中未作为数学来源。未将空检索结果解释为全库不存在。

### 1. 从 RH 导出实际 canonical 全盘展开

令 λ_n 是既有导数定义的 canonical 系数，F(z)=xiReading((1-z)^(-1))，G 使用既有 liGenerator。本轮 `CanonicalLiDiskEquivalence` 先证明 |z|<1 蕴含 Re((1-z)^(-1))>1/2。标准 RH 与既有 xi/nontrivial-zero 识别给出 F 在全盘非零。因此此方向下，实际 G 在全盘全纯。

Mathlib 钉版 `db584cd6d46c92f209a44c0f1c829460d327499d` 的 Taylor 定理提供 G 的全盘展开，#6172 已证明的全阶系数恒等式将它识别为

\[
G(z)=\sum_{n\ge0}\lambda_{n+1}z^n,\qquad |z|<1.
\]

`rh_canonical_li_global_expansion` 保留实际 HasSum。复数是有限维实范数空间，钉版 `summable_norm_iff` 将其无条件可和性转成绝对可和性；这里没有把任意条件收敛级数误当成绝对收敛。

结合上一轮通过 F'=GF 和零点阶数排除得到的反向，`rh_iff_canonical_li_disk_summable` 证明

\[
\mathrm{RH}\iff
\forall r\in[0,1),\quad\sum_{n\ge0}|\lambda_{n+1}|r^n<\infty.
\]

`rh_iff_canonical_li_global_expansion` 同时将实际全盘 HasSum 等式与 RH 等价起来。这个反向不使用 RH，也没有外加抽象 Li 判据。本轮闭合的是全盘收敛判据的两向，并非 RH 与完整 canonical 曲率矩阵正性的两向。

### 2. 全半径加权包络也是精确等价条件

`CanonicalLiRadiusObstruction` 从 RH 下的绝对和构造每个半径的常数 C_R，证明

\[
\mathrm{RH}\iff
\forall R\in[0,1),\ \exists C_R\ge0,\ \forall n\ge0,
\quad |\lambda_{n+1}|R^n\le C_R.
\]

常数允许依赖 R。反向在任意 r<1 与 1 之间选择 R，保留精确恒等式

\[
|\lambda_{n+1}|r^n=(|\lambda_{n+1}|R^n)(r/R)^n
\le C_R(r/R)^n,
\]

再用几何级数得到所需绝对收敛。等价的指数表述是：对每个 q>1 存在有限 C_q，使全部 |λ_(n+1)|≤C_q q^n。Lean 公共端点采用上面的加权半径表述，没有另外新增一个同义指数谓词。

### 3. 指定实际零点导致每个尾段中的增长障碍

本轮还把上一轮的全索引增长条件局部化到任意正半径 R≤1。若从某一阶起有 |λ_(n+1)|R^n≤C，Mathlib 的 `le_radius_of_eventually_le` 仍然保证相同 scalar series 在 |z|<R 解析。有限个初始系数不会改变这个结论。将旧的局部交叉相乘等式限制到这个圆盘并延拓，得到实际 F 在该盘无零点。

因此对一个假设给定的实际 ξ 零点 ρ，记 z_ρ=1−1/ρ。若

\[
|z_\rho|<R\le1,
\]

则 `xi_zero_forces_weighted_tail_escape` 给出

\[
\forall N\in\mathbb N,\ \forall C\in\mathbb R,\ \exists n\ge N,
\qquad |\lambda_{n+1}|R^n>C.
\]

这是每个尾段无界，强于某个系数超过一个给定二次界。若 |z_ρ|<1，可以选 |z_ρ|<R<1，故系数在任意尾段都会超过任意给定倍数的 R^(-n)。没有证明每一项最终都大，也没有给出第一次越界的索引上界。零点的存在始终是条件，没有假定或声称已找到离线零点。

严格半径条件不可删除。有限诊断的模型 F(z)=(1-z/a)^m 有 G(z)=−m/(a-z)，其系数为 −m/a^(n+1)。在 R=|a| 时，加权模长恒等于 m/|a|，可以保持有界；零点此时在边界，不在 theorem 的开盘结论内。

### 4. 读出半径对应真实 s 平面的位置，而非只对应高度

令 ρ=β+iγ，有精确代数式

\[
|1-1/\rho|^2=1-\frac{2\beta-1}{\beta^2+\gamma^2}.
\]

因此控制 R 只排除满足 |1-1/s|<R 的零点。对于 0<R<1，这在原 s 平面等价于

\[
\left|s-\frac1{1-R^2}\right|<\frac{R}{1-R^2}.
\]

最后一个圆盘形状是本轮精确代数诊断和纸面解释，不是额外具名 Lean 定理。Lean 零点端点直接保留完整复数及其真实 Möbius 像。

这个关系解释了为什么仅有限阶或固定读出半径不能直接得到全局 RH：每个半径控制一个确定区域，而全盘判据需要任意接近一的半径及各自的全索引界。黄金固定周期读出导致的层数丢失也不会由这一解析等价自动消除。

### 5. 文献定位、实际复用与验证范围

Li 系数、增长与 Weil 形式的联系已有成熟文献，例如 Lagarias, *Li Coefficients for Automorphic L-Functions*, Annales de l'Institut Fourier 57 (2007), 1689–1740, arXiv:math/0404394v4。Suzuki, *Li coefficients as norms of functions in a model space*, arXiv:2301.05779v2 (2023)，研究具体范数表示与 RH 判据。当前主要记录及摘要已核对；本轮不冒领这些经典解析关系的优先权，也未宣称重新审定两篇论文的全部证明。贡献是沿已合并 canonical 定义完成可组合的实际函数证明端点和尾段障碍。

两份新 Lean 共 321 行、15 个公共定理，配套两个 Scribe 共 84 行，15 个 `StatementSource.FromLean()` 绑定全部匹配。四份代码通过字符串/注释感知的括号检查；新源码没有自定义 axiom、sorry、admit 或 native_decide。没有 Lean、Lake 或 dotnet 可执行程序，因此没有执行 elaboration、内核接受、传递公理报告或 Scribe emission。旧候选依赖也不因新增消费者而获得新的验证状态。

seed 20260907 的 Fraction/有理复数重放通过 90 个有限解析多项式模型、3240 项 F'=GF 有限 jet 恒等式、1080 项精确几何余项、6480 项加权半径比较、864 项指定尾段越界实例、240 项 Möbius 往返、720 项原 s 平面圆盘测试、21 项临界线边界以及 90 项边界零点有界包络。五个负对照保留严格半径、全索引而非有限前缀、正半径、非零初值及完整复数零点位置等条件。完整重跑与结果文件逐字节一致。诊断是作者的第二实现，未计算真实 zeta 零点或 canonical 全序列，也不是独立审稿或 Lean 抽取代码。

诊断源码 SHA-256：`1912d84a162e5328ac588487d17d0cc163265b26342d18dc4208aa27d1d48fad`；结果 SHA-256：`c197242b343bded46173e6286a745266d4fec049f769ecfdc0091481169f3662`。上一轮交付 ZIP 内的原诊断已另行重跑，JSON 与原包逐字节一致。研究产物保持在本 PR 的 Lean、配套 Scribe 和本卷追加；没有修改 CI 或冻结登记。
