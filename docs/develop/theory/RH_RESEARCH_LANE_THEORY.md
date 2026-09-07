[PR #5065] Pinned root observations 33969082693 and 33969495413 both failed. The first exposed obsolete finite-sum syntax and an unclosed mirror inverse simplification. The second verified the repaired mirror inverse with only standard axioms, then exposed a finite-window unfolding mismatch and a accidentally omitted second ZeroData binder introduced during the source repair. This revision explicitly unfolds `ZeroConfig.window` and restores that binder, without changing the intended theorem statements or admitting a placeholder. Compiler error recovery containing `sorryAx` is rejected as validation evidence. The new frozen source revision still requires its own observed successful root replay and independent required checks before any admission claim.

---

## [PR #6219] Canonical Li curvature and actual analytic zero-freeness

本节补入上一轮已经完成的数学追加。基准 dev 为 `55a96922002fdbf5644c47264702e325d0b475c9`，已有六份 Lean/Scribe 在本次补写前的远端提交为 `b14a5818d44baadbdb28367e97825548367babb5`。本轮复用已合并 #6172 的实际 `canonicalLiCoefficient`、`xiReading`、局部 Keiper–Li 展开和首系数正性。这里没有另造一份 Li 序列，也不主张经典生成函数方法的文献优先权。

### 1. 实际算术对象与局部关系

记仓内从实际 xiReading 高阶导数定义的系数为 λ_n，λ_0=0。令

\[
G(z)=\sum_{n\ge0}\lambda_{n+1}z^n,
\qquad F(z)=\xi\left(\frac1{1-z}\right).
\]

已合并来源给出零附近的实际局部展开

\[
G(z)=(1-z)^{-2}\frac{\xi'}{\xi}\left(\frac1{1-z}\right).
\]

由 ξ(1)=1/2 和连续性，先在零附近确认 F 非零，再由实际链式求导得到局部交叉相乘恒等式 F'=GF。没有在全盘预先引入 log F 或假定 ξ'/ξ 无极点。

### 2. 全索引增长控制与全域解析延拓

若实际系数满足对所有 n 的 |λ_n|≤Cn²，则对每个 0≤r<1，有

\[
\sum_{n\ge0}|\lambda_{n+1}|r^n
\le C\sum_{n\ge0}(n+1)^2r^n<\infty.
\]

候选真源 `AnalyticLogarithmicContinuation` 复用钉版 Mathlib 的标量 formal series 收敛半径 API，证明原系数之和在单位圆盘上全纯。实际 F 由 ξ 为整函数而全纯。F' 与 GF 都在全盘全纯，因此局部 F'=GF 经恒等定理延拓到整个连通圆盘。

注意延拓的对象是 F'−GF。即便正在排查 F 的零点，这个函数仍然全纯；不需要事先把 F'/F 延到全盘。

### 3. 解析零点阶数排除

假设 F 在盘内 z0 处为零。由于 F(0)=1/2，解析恒等定理排除了在 z0 无限阶为零。若其有限阶数为 k≥1，则 F' 的阶数为 k−1，而 G 全纯意味着 GF 的阶数至少为 k。全域等式 F'=GF 导致矛盾。

对于任意 Re(s)>1/2，取 z=1−1/s，有精确恒等式

\[
1-|z|^2=\frac{2\Re(s)-1}{|s|^2}>0,
\qquad (1-z)^{-1}=s.
\]

因此实际 xiReading 在 Re(s)>1/2 无零点。再复用既有 xi 与非平凡 zeta 零点的识别及右半条带反射归约，得到标准 Mathlib RiemannHypothesis。

`canonical_li_quadratic_growth_implies_rh` 保留全索引绝对二次界作为输入。它没有输入抽象 Li 判据、期望中的全局对数公式、RH 或无零点前提。该算术增长界本身尚未无条件证明。

### 4. 从实际 canonical 曲率矩阵导出所需界

定义 c_0=1，对于 n≠0 取

\[
c_n=\frac{\lambda_{|n|+1}-2\lambda_{|n|}+\lambda_{|n|-1}}{2\lambda_1}.
\]

这是实际 canonical 序列的实值偶延拓，λ_1>0 复用已有首系数定理。在原 Toeplitz 约定 T_N(c)_(jk)=c_(j-k) 下，从第 n 阶矩阵取索引 0、n 的主压缩，即

\[
\begin{pmatrix}1&c_n\\c_n&1\end{pmatrix}.
\]

若原矩阵正半定，向量 (1,1) 与 (1,−1) 给出 2+2c_n≥0 和 2−2c_n≥0。因此

\[
|\lambda_{n+1}-2\lambda_n+\lambda_{n-1}|\le2\lambda_1.
\]

对一般实序列 L，假设 L_0=0、|L_1|≤a，且全部二阶差分绝对值≤2a。第一次归纳得到 |L_(n+1)−L_n|≤a(2n+1)，第二次归纳得到 |L_n|≤an²。系数可以带符号。

由此得到候选端点 `canonical_curvature_posSemidef_implies_rh`：全部实际 canonical 曲率 Toeplitz 矩阵正半定蕴含标准 RH。共同 Herglotz 测度、抽象 Li 判据、期望中的递推和零点测度识别不再是该端点的额外输入。

这仍然没有证明全部实际矩阵正半定。单项 |c_n|≤1 对一般序列也不能反推全矩阵正性。本轮采用正性到二点界的方向，然后使用这一个实际 canonical 序列已有的解析展开。

### 5. 与概率支线及剩余任务

#6114 的 `normalized_curvature_quadratic_bound` 给出一般概率重建序列的二次包络。本轮 `canonical_li_probability_envelope_implies_rh` 消费这个包络在 L=canonicalLiCoefficient 时的特化。新分支从已含 #6172 的 dev 创建，没有复制未合并概率模块或处理旧分支冲突。

当前是 canonical 增长或全阶曲率正性到 RH 的前向解析连接。没有证明 RH 到完整 canonical 曲率正性的反向，也没有完成无条件全阶算术正性。失败 RH 的反证结论仅说明存在某个失败矩阵阶数或越过任何给定二次包络的系数，不提供统一检测截止阶数。

三个 Lean 模块有配套 Scribe 候选。没有执行 elaboration、内核接受、公理闭包检查或 Scribe emission。有限有理数检查检验代数、递推、Möbius 几何和零点阶数的有限 jet。它不验证全索引 canonical 算术前提，也不能替代无限域解析证明。

上一轮交付包内的标准库精确诊断现已重放：119 个多项式几何尾式、86 组带符号二阶差分序列、180 个有理复数 Möbius 往返、216 个复 Toeplitz Gram 恒等式及 96 个有限零阶障碍。重放是作者自检，不是独立复核或 Lean 内核证据。源码与该数学追加的远端身份另外通过 commit/blob 回读核对。
