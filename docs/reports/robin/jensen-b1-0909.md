# B1 精确微分兼容关系：bind-only，按判据 1 停止

**结论：`bind-only`。** 先用钉版 Mathlib、冻结件投影及规范化得到 B1 全部结论，停止模块实施。没有新建 D5 模块、Scribe、冻结状态片或 coverage 边；没有寻找准入例外，没有开 PR。报告和可复现探针留在本工作分支。

产地：runner 的 consensus-rnd/sshx implementation 席；本 worker 未调用 skill，Codex 主循环直接取证、写临时探针及单点自查。零独立评审席，无盲评或共识票，不冒称 orchestrator 亲验。

LANE [#6160](https://github.com/the-omega-institute/trureturing/issues/6160)；atom `087e3caa7c278b4ea58f06604daa8721ab5258f6c451a25ed8f2d0092d823ca0`，source_id `quantum-rh`。工作分支 `lane/math/jensen-b1-0909`，源码基准 `2ae36e58698ae84239445dda106082167b684438`。Lean v4.33.0；Mathlib `db584cd6d46c92f209a44c0f1c829460d327499d`。以下 A 指任务指定的 attempt 目录：

`/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/jensen-b1-0909/attempt-1`

第一条硬要求在本次全部尝试中保持第一条：先只用钉版 Mathlib 实例化、冻结件投影、定义展开和规范化改写；成功立即判 bind-only。未增加预算常数。`sq_nonneg` / `linarith only` 是允许的规范化工具，本题没有需补足的有序域不等式，未塞入无关平方非负事实。实际使用 `simp only`、`rw`、`omega`、`norm_num`、`field_simp`、`ring` 和对冻结系数等式的 `linear_combination`。

## 原文与忠实性

`make show-atom ATOM_ID=087e3caa7c278b4ea58f06604daa8721ab5258f6c451a25ed8f2d0092d823ca0` 退出 0，原始与规范化 SHA 均等于 atom id，coverage_gids 为空。原文标题为“## 定理 B1：精确微分兼容关系”，唯一结论是：令 α_d=(d−1)/d，对 d≥2，有 q_d′(x)=d α_d^(d−1) q_(d−1)(x/α_d)。brief 与该 atom 无差异。

同时连读 `QUANTUM-RH.md:1365–1545` 的对象定义和证明。源卷称 q 为反转多项式，并给出展开式；因此在 x=0 按多项式延拓解释，不能直接把 Lean 的 `(-1)/0=0` 用作定义。B1 并无额外的根、矩阵、迹或 Rolle 计数子句。

| 原文子句 / 对象 | Lean 对应 | 范围与保真 |
| --- | --- | --- |
| α_d=(d−1)/d | `alpha d := ((d - 1 : ℕ) : ℂ) / (d : ℂ)` | d≥2 下自然数减法与域减法相同；`alpha_ne_zero` 显式排除零分母/零缩放 |
| d≥2 | `hd : 2 ≤ d` | 原样保留，未换成固定 d 或条件性结论 |
| 源 P_d 的固定系数 | `sourceJensenPolynomial d` | 复用已冻结定义及 `sourceJensenPolynomial_eq_normalizedJensen`；无新 theta/RH 假设 |
| q_d 的反转绑定 | `Q p d := (p.comp (C (-1) * X)).reflect d` | `source_binding` 在 x≠0 证明 q_d(x)=x^d P_d(−1/x)；零点由系数规范化 |
| q_d′ | `deriv (fun x => (Q (sourceJensenPolynomial d) d).eval x) x` | `Polynomial.deriv` 直接将多项式形式导数连接到函数导数 |
| B5 等式，两侧全部 x | `b1_source (d) (hd) (x : ℂ)` | 对所有复数 x（包含 0）；实数 x 是其特例，无丢失零点的非零假设 |

对任意实系数序列 a 的 `b1_polynomial` 先闭合，固定源定理只作实例化。系数的正性、a₀=1、矩积分与 ξ 的解析解释均不需要作为 B1 的额外前件；这不声称已经证明它们。

## q_d 绑定与退化点

最终绑定为：若 `p.natDegree ≤ d` 且 `x ≠ 0`，则 `(Q p d).eval x = x^d * p.eval (-1/x)`；对任何 p、d，`(Q p d).eval 0 = p.coeff d * (-1)^d`。后一条是多项式规范化，不是倒数函数在 0 的值。

引用的上游公式是 `Polynomial.eval₂_reflect_mul_pow`（对 x⁻¹ 实例化，`Invertible (x⁻¹)` 由 x≠0 提供）。Mathlib 反转理论没有重证。选择 `reflect d` 而不是无条件使用 `reverse`：前者固定长度 d，后者使用实际 natDegree；当 P 的最高项消失时，两者可以差一个 X 因子。

**可见性：没有生产模块，因而没有生产 API 的 public/private 落点。** 绑定仅是临时诊断命名空间中的具名定理，便于 `#print axioms`；没有单独落地。也没有为它寻找 `admission_basis`。

| 点 / 退化 | 真实读数与处理 |
| --- | --- |
| x=0 | a=(1,2,6)，P₂=1+2v+3v²，q₂=x²−2x+3。q₂(0)=3，而 0²·P₂(−1/0)=0；B1 两侧在 x=0 都为 −2。非零限制只出现在倒数绑定，未加到 B1 上。 |
| d=0 | 原目标的 hd 排除。诊断中 P₀=q₀=1，导数为 0，Lean 总除法延伸出的 RHS 也为 0；这只是域外平凡值，不冒充 d≥2 的证据。 |
| P 的最高项系数为 0 | a=(1,2,0)，P₂=1+2v 的实际次数为 1；固定长度反转仍是 q₂=x²−2x。x=3 时 B1 两侧均为 4，未假设 natDegree=d。 |
| q 的首系数为 0 | a=(0,2,6)，q₂=−2x+3、q₁=−2；x=3 时两侧均为 −2。一般结果未假设首一或首系数非零。 |
| 零多项式 | Mathlib 的 `reflect_zero` / 导数零给 0=0；没有用它作为唯一非空见证。 |

## 两侧非空见证

正例取 d=2、a₀=1、a₁=2、a₂=6（更高系数设 0）。α=1/2，q₂=x²−2x+3，q₁=x−2。在 x=3，q₂′(3)=4，2(1/2)q₁(6)=4；倒数绑定两侧为 q₂(3)=6 与 9·P₂(−1/3)=6。更高项为零不影响这两个有限层；本例验证任意系数版本，不冒称是实际 ξ 系数的数值。

反例破坏“相邻层来自同一个系数序列”：保持 q₂，前一层改为 q₁*=x−3（a₁ 从 2 改成 3）。在 x=3，LHS=4，RHS=3，结论不成立。被破坏的冻结降阶输入也真算数值：v=1 时 P₂(1)−P₂′(1)/2=2，而 P₁*(1/2)=5/2。此例不是 B1 的反例，因为它明确违反系数一致性前件。

Lean 临时诊断验证正反输出与零点陷阱，另有独立 Python `Fraction` 运算留在 `A/numeric-witnesses.json`；均为精确有理数，非浮点近似。a₀=0 的 Q/P 对应式按系数直接算，Lean 同时验证所列 q 多项式的两侧数值；未另增加生产实例定理。

## 冻结输入、判形和用途

冻结模块：`D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering`。当前 state pin 为 `sha256:ee43a04a542df25237818cbfeeb29bb1abaed956f90db04822d08e8f413d50b4`。声明身份直接读已提交 `Golden/Frozen/accepted/afd9189dc663834087e112c1f91417f4f168ac2c96ec35c1fa10631a68a6ea32.json`，没有重算旧身份。

| 冻结声明 GID（均在上述模块后接点号） | declaration statement_id | 实际用途 / 作用域 |
| --- | --- | --- |
| `normalizedJensen_degree_lowering` | `sha256:f13a2fdd4121c7b170af20e397cf8d9c567ddfcfd4dd8e37d469c21f8603d6bf` | 实际数学输入：任意实 a，d≥2，复多项式等式；对其取系数 |
| `normalizedJensen_eq_fallingFactorial_sum` | `sha256:8a2655f8cbb74a3d045256378f01d8c6468e59545dc09fc5446bd390f898c025` | 实际输入：d≥1 的有限和绑定，用于次数上界与数值展开 |
| `sourceJensenPolynomial_eq_normalizedJensen` | `sha256:0c96cec689edaf5a585802b79a9c52b976c6dcedbee0cd259b40d0a7d19ecfa9` | 实际输入：d≥1 的固定源实例化 |
| `source_jensen_degree_lowering` | `sha256:5cc7d6726b507416f47892d7dba26050981908448772a4eb1bb35c465a785de7` | 已实查的固定源点态接口，d≥2；本探针选择同模块的多项式版本，没有声称同时调用此点态定理 |

依赖方向：`b1_source → b1_eval → b1_polynomial → reflect_transport → 冻结 normalizedJensen_degree_lowering 的系数等式`。`normalized_degree` 由冻结有限和及 Mathlib 次数界直接给出。`source_binding → reciprocal_binding → Mathlib.eval₂_reflect_mul_pow`。这些路径由成功 elaboration 与完整证明源码承担，不由关键词搜索冒充。

判形均为 bind-only：`reciprocal_binding`、`binding_at_zero`、`b1_polynomial`、`b1_eval`、`b1_source`、`source_binding`。`escape_witness=null`，`admission_basis=null`。

候选 helper 的四项审计：`reflect_transport` 位于 B1 的证明依赖闭包且在活推导路径上；但其内容仅是 `coeff_reflect` / `coeff_derivative` / `comp_C_mul_X_coeff` 的实例化，再对冻结系数等式作指标和交换域运算规范化，故不满足 (ii)“非规范化可得”。`normalized_degree` 同样由冻结有限和及上游次数界得到。`reciprocal_binding` 本身是上游求值公式的直接包装，并且 B1 的纯系数证明不依赖这个点态包装，不能把它作为 B1 的逃逸见证。没有满足四项的见证。

`utility_per_declaration`：生产声明集合为空。诊断中的六个一般性绑定/恒等式与三个一般性证明 helper 不属于有界枚举、检查器、数值归约或认证实例，若按数学内容描述则为 none；`alpha` / `Q` 仅诊断定义。`sample`、`sample_q1`、`sample_q2` 及匿名正反数值断言是验证载荷，不提交为计算性内容，也不声称 refutes、terminal 或 consumer 准入。`refutes` 没有被当作第四种依据。

## 检索和命令收据

仓库规范、tracked probe/deposit notes 与 `agents/CONTEXT.md` 已读。落点 `D5/S3/Zeros/Jensen/` 的现有五模块均全文读完。`git ls-tree origin/dev --name-only D5/S3/` 确认 Zeros 为已有域。按对象粗筛后未在已读模块发现 B5 的既有声明；不作全仓语义不存在性或检索穷尽声明。

同特性正则均使用 rg 的 `\b`：

| 命令 | 行数 / exit |
| --- | --- |
| `rg -n '\b(normalizedJensen|sourceJensenPolynomial|descFactorial|degree_lowering)\b' D5/S3/Zeros/Jensen --glob '*.lean'` | 36 / 0 |
| `rg -n '\bsource_jensen_degree_lowering\b' D5 --glob '*.lean'`（阳性） | 1 / 0 |
| `rg -n '\b(q_d|qd|reflect_transport|b1_source|reciprocal_binding)\b' D5 --glob '*.lean'`（名字阴性） | 0 / 1 |
| `rg -n '\b(reflect|reverse)\b' .lake/packages/mathlib/Mathlib/Algebra/Polynomial/Reverse.lean` | 61 / 0 |

原样 argv、退出码和读数在 `A/search-receipts.json`。名字阴性只作对照，不推导没有异名覆盖。查到并实际阅读/使用的主要 Mathlib 名：`reflect`、`reverse`、`coeff_reflect`、`revAt_le`、`revAt_eq_self_of_lt`、`reflect_C_mul_X_pow`、`reflect_monomial`、`reflect_add`、`reflect_C_mul`、`eval₂_reflect_mul_pow`、`natDegree_comp_le`、`natDegree_sum_le_of_forall_le`、`natDegree_C_mul_X_pow_le`、`coeff_eq_zero_of_natDegree_lt`、`coeff_derivative`、`coeff_X_mul`、`comp_C_mul_X_coeff`、`coeff_zero_eq_eval_zero`、`pow_sub₀`、`Polynomial.deriv`。没有重证命中的 Mathlib 结果。

初始 `make lean` 退出 0，12766 jobs，缓存 project/mathlib 均 warm。完整临时探针命令为：

```sh
make -f Makefile -f "$A/probe.mk" lean PROBE="$A/B1Probe.lean"
```

补充 makefile 只给原生 lean 目标加一个临时 prerequisite；该 prerequisite 经同一 canonical `lean-cache-run.sh` 执行探针，原生 `make lean` 配方保留。未运行裸 lake，未改 lakefile、工具链、预算或任何共享工具。

| 试次 | 总退出码 | 失败/成功位置 |
| --- | --- | --- |
| 01 | 2 | `pow_sub₀` 漏显式底数；乘积括号改写未命中 |
| 02 | 2 | 上游已是乘逆式，多余 `rw [div_eq_mul_inv]` 未命中 |
| 03 | 2 | B1 多项式与非零绑定已绿；零点缺显式系数改写，求值/样本宽 simp 达默认递归深度 |
| 04 | 2 | 六条一般性 B1/绑定均绿，触发停止判据 1；仅 sample_q2 缺反转基项化简 |
| 05 | 2 | 一般性结果保持绿，仅样本 `C (-1)` / `C 1` 待常量规范化 |
| 06 | **0** | 全部探针、数值/退化诊断和原生 lean target 通过，12766 jobs |

失败候选的源码与原始日志完整保留在 A；其中 `sorryAx` 来自 Lean 错误恢复，全部排除在最终证据之外。终版 `A/probe-06.log` 中八条受查声明（六条一般性定理、两个 sample helper）均仅含 `[propext, Classical.choice, Quot.sound]`。终版探针无 sorry、无私 axiom。保留必要性/风格 simp 警告，未关闭 linter。原生构建有既有 replay warning（两条文档字符串警告正文含 `error:`），实际进程退出 0，不按日志关键词误判。

两次探路路径 `tools/scripts/lean.sh` 与 Mathlib `Algebra/GroupWithZero/Power.lean` 不存在，已改查现役 wrapper 与 `Algebra/GroupWithZero/Units/Basic.lean`；这些命令错误不作“数学接口缺失”的证据。

`make lean-report` / `make emit` / `make deposit` / `make cover` / `make pr-open` 未运行：B1 整体 bind-only 的硬停止不进入模块、Scribe、冻结、cover 或 PR 流程。未触碰其它四条 atom，也未改初始已有的 untracked `tierA.json`。

## 边界与未主张

本 worker 验证的是临时 Lean 证明与报告；没有新增冻结定理，没有关闭 atom，没有入 dev，没有 PR，也未宣称多模型评审或 CI 三门通过。未主张检索穷尽、第三方生态穷尽、新数学、RH 或同族其它四条的任何推进。未验证实际 theta 矩的数值或 a₀=1，因为 B1 的纯代数恒等式不使用这些事实。独立评审、orchestrator 亲验及未打开的外部文献均为 `ASSUMED-UNVERIFIED`，不承载本判词。

下面保留最终成功探针全文，便于远端分支独立复核；它是报告内的诊断文本，不是新 D5 模块。其 SHA-256 为 `a91f8a295569d9df017e475abd06f373e226c297388ed8f4b9d72fc7d9f63e4f`。

```lean
import D5.S3.Zeros.Jensen.NormalizedJensenDegreeLowering
import Mathlib.Algebra.Polynomial.Reverse
import Mathlib.Analysis.Calculus.Deriv.Polynomial
import Mathlib.Tactic

set_option autoImplicit false
noncomputable section
open Polynomial
open D5.S3.Zeros.Jensen.NormalizedJensenDegreeLowering
namespace B1BindOnlyProbe

def alpha (d : ℕ) : ℂ := ((d - 1 : ℕ) : ℂ) / (d : ℂ)
def Q (p : ℂ[X]) (d : ℕ) : ℂ[X] := (p.comp (C (-1) * X)).reflect d

private theorem normalized_degree (a : ℕ → ℝ) (d : ℕ) (hd : 1 ≤ d) :
    (normalizedJensen a d).natDegree ≤ d := by
  rw [normalizedJensen_eq_fallingFactorial_sum a d hd]
  apply natDegree_sum_le_of_forall_le
  intro k hk
  exact (natDegree_C_mul_X_pow_le _ _).trans (by simpa using Finset.mem_range.mp hk)

private theorem alpha_ne_zero (d : ℕ) (hd : 2 ≤ d) : alpha d ≠ 0 := by
  apply div_ne_zero <;> exact_mod_cast (show _ ≠ 0 by omega)

private theorem reflect_transport (p r : ℂ[X]) (d : ℕ) (hd : 2 ≤ d)
    (hp : p.natDegree ≤ d) (hr : r.natDegree ≤ d - 1)
    (h : p - C ((d : ℂ)⁻¹) * X * p.derivative = r.comp (C (alpha d) * X)) :
    (Q p d).derivative =
      C ((d : ℂ) * alpha d ^ (d - 1)) * (Q r (d - 1)).comp (C ((alpha d)⁻¹) * X) := by
  have hd0 : (d : ℂ) ≠ 0 := by exact_mod_cast (show d ≠ 0 by omega)
  have ha0 := alpha_ne_zero d hd
  have hder (f : ℂ[X]) (n : ℕ) : (X * f.derivative).coeff n = f.coeff n * (n : ℂ) := by
    cases n <;> simp [coeff_X_mul, coeff_derivative]
  ext k
  by_cases hk : k < d
  · have hk1 : k + 1 ≤ d := by omega
    have hk2 : k ≤ d - 1 := by omega
    have hind : d - 1 - k = d - (k + 1) := by omega
    have hcoeff := congrArg (fun f : ℂ[X] => f.coeff (d - (k + 1))) h
    simp only [coeff_sub, mul_assoc, coeff_C_mul, hder, comp_C_mul_X_coeff] at hcoeff
    simp only [Q, coeff_derivative, coeff_reflect, revAt_le hk1, coeff_C_mul,
      comp_C_mul_X_coeff, revAt_le hk2, hind]
    have hcast : ((d - (k + 1) : ℕ) : ℂ) = (d : ℂ) - ((k : ℂ) + 1) := by
      rw [Nat.cast_sub hk1]
      push_cast
      rfl
    rw [hcast] at hcoeff
    have hpow : alpha d ^ (d - 1) * (alpha d)⁻¹ ^ k = alpha d ^ (d - (k + 1)) := by
      rw [← hind, pow_sub₀ (alpha d) ha0 hk2, inv_pow]
    calc
      _ = (d : ℂ) * (r.coeff (d - (k + 1)) * alpha d ^ (d - (k + 1))) *
          (-1 : ℂ) ^ (d - (k + 1)) := by
        field_simp at hcoeff
        linear_combination (-1 : ℂ) ^ (d - (k + 1)) * hcoeff
      _ = _ := by rw [← hpow]; ring
  · have hk1 : d < k + 1 := by omega
    have hk2 : d - 1 < k := by omega
    simp only [Q, coeff_derivative, coeff_reflect, revAt_eq_self_of_lt hk1,
      coeff_C_mul, comp_C_mul_X_coeff, revAt_eq_self_of_lt hk2]
    rw [coeff_eq_zero_of_natDegree_lt (hp.trans_lt hk1),
      coeff_eq_zero_of_natDegree_lt (hr.trans_lt hk2)]
    simp

-- B5 for every real coefficient sequence; the source is a direct specialization.
theorem b1_polynomial (a : ℕ → ℝ) (d : ℕ) (hd : 2 ≤ d) :
    (Q (normalizedJensen a d) d).derivative =
      C ((d : ℂ) * alpha d ^ (d - 1)) *
        (Q (normalizedJensen a (d - 1)) (d - 1)).comp (C ((alpha d)⁻¹) * X) := by
  exact reflect_transport _ _ d hd (normalized_degree a d (by omega))
    (normalized_degree a (d - 1) (by omega)) (normalizedJensen_degree_lowering a d hd)

-- The reciprocal identity is restricted to nonzero arguments.
theorem reciprocal_binding (p : ℂ[X]) (d : ℕ) (hp : p.natDegree ≤ d)
    (x : ℂ) (hx : x ≠ 0) : (Q p d).eval x = x ^ d * p.eval (-1 / x) := by
  have hneg : (p.comp (C (-1) * X)).natDegree ≤ d := by
    apply natDegree_comp_le.trans
    calc
      _ ≤ p.natDegree * 1 := Nat.mul_le_mul_left _ (by
        simpa using (natDegree_mul_le (p := C (-1 : ℂ)) (q := X)))
      _ ≤ d := by simpa using hp
  letI : Invertible (x⁻¹) := invertibleOfNonzero (inv_ne_zero hx)
  have h := eval₂_reflect_mul_pow (RingHom.id ℂ) (x⁻¹) d
    (p.comp (C (-1) * X)) hneg
  simp only [invOf_eq_inv, inv_inv, eval₂_id, eval_comp, eval_mul, eval_C,
    eval_X, neg_one_mul] at h
  change (Q p d).eval x * x⁻¹ ^ d = p.eval (-x⁻¹) at h
  calc
    _ = ((Q p d).eval x * x⁻¹ ^ d) * x ^ d := by simp [inv_pow, hx]
    _ = p.eval (-x⁻¹) * x ^ d := by rw [h]
    _ = _ := by simp [div_eq_mul_inv, mul_comm]

-- At zero, evaluate the reflected polynomial, never a totalized reciprocal.
theorem binding_at_zero (p : ℂ[X]) (d : ℕ) :
    (Q p d).eval 0 = p.coeff d * (-1) ^ d := by
  rw [← coeff_zero_eq_eval_zero]
  simp only [Q, coeff_reflect, revAt_zero, comp_C_mul_X_coeff]

theorem b1_eval (a : ℕ → ℝ) (d : ℕ) (hd : 2 ≤ d) (x : ℂ) :
    (Q (normalizedJensen a d) d).derivative.eval x =
      (d : ℂ) * alpha d ^ (d - 1) *
        (Q (normalizedJensen a (d - 1)) (d - 1)).eval (x / alpha d) := by
  rw [b1_polynomial a d hd]
  simp only [eval_mul, eval_C, eval_comp, eval_X, div_eq_mul_inv]
  rw [mul_comm ((alpha d)⁻¹) x]

theorem b1_source (d : ℕ) (hd : 2 ≤ d) (x : ℂ) :
    deriv (fun x => (Q (sourceJensenPolynomial d) d).eval x) x =
      (d : ℂ) * alpha d ^ (d - 1) *
        (Q (sourceJensenPolynomial (d - 1)) (d - 1)).eval (x / alpha d) := by
  rw [Polynomial.deriv, sourceJensenPolynomial_eq_normalizedJensen d (by omega),
    sourceJensenPolynomial_eq_normalizedJensen (d - 1) (by omega)]
  exact b1_eval sourceThetaCoefficient d hd x

theorem source_binding (d : ℕ) (hd : 1 ≤ d) (x : ℂ) (hx : x ≠ 0) :
    (Q (sourceJensenPolynomial d) d).eval x =
      x ^ d * (sourceJensenPolynomial d).eval (-1 / x) := by
  apply reciprocal_binding _ d _ x hx
  rw [sourceJensenPolynomial_eq_normalizedJensen d hd]
  exact normalized_degree sourceThetaCoefficient d hd

-- Concrete arithmetic checks are diagnostics, not admission witnesses.
def sample (k : ℕ) : ℝ := if k = 0 then 1 else if k = 1 then 2 else if k = 2 then 6 else 0

private theorem sample_q2 : Q (normalizedJensen sample 2) 2 =
    X ^ 2 - C 2 * X + C 3 := by
  rw [normalizedJensen_eq_fallingFactorial_sum sample 2 (by norm_num)]
  norm_num [sample, Finset.sum_range_succ, Nat.descFactorial]
  simp only [Q, add_comp, mul_comp, pow_comp, C_comp, X_comp, one_comp,
    mul_pow, ← C_pow, mul_assoc, ← C_mul, reflect_add, reflect_C_mul,
    reflect_monomial, reflect_one]
  rw [show reflect 2 (X : ℂ[X]) = X by
    simpa using (reflect_monomial 2 1 (R := ℂ))]
  norm_num only [revAt_le (by norm_num : 2 ≤ 2), Nat.sub_self, pow_zero, mul_one]
  norm_num
  ring

private theorem sample_q1 : Q (normalizedJensen sample 1) 1 = X - C 2 := by
  rw [normalizedJensen_eq_fallingFactorial_sum sample 1 (by norm_num)]
  norm_num [Q, sample, Finset.sum_range_succ, Nat.descFactorial, sum_comp,
    add_comp, mul_comp, pow_comp, C_comp, X_comp, mul_pow, ← C_pow,
    ← C_mul, reflect_add, reflect_C_mul_X_pow, reflect_C_mul, reflect_monomial, revAt]
  ring

example : (Q (normalizedJensen sample 2) 2).derivative.eval 3 = 4 ∧
    (2 : ℂ) * alpha 2 ^ (2 - 1) *
      (Q (normalizedJensen sample 1) 1).eval (3 / alpha 2) = 4 := by
  rw [sample_q2, sample_q1]
  norm_num [alpha, derivative_add, derivative_sub, derivative_mul, derivative_pow]

example : (Q (normalizedJensen sample 2) 2).eval 0 = 3 ∧
    (0 : ℂ) ^ 2 * (normalizedJensen sample 2).eval (-1 / 0) = 0 := by
  rw [sample_q2]
  norm_num

-- Break the common coefficient sequence: previous level uses a1 = 3 instead of 2.
example : (Q (normalizedJensen sample 2) 2).derivative.eval 3 = 4 ∧
    (2 : ℂ) * alpha 2 ^ (2 - 1) * (X - C 3 : ℂ[X]).eval (3 / alpha 2) = 3 ∧
    (Q (normalizedJensen sample 2) 2).derivative.eval 3 ≠
      (2 : ℂ) * alpha 2 ^ (2 - 1) * (X - C 3 : ℂ[X]).eval (3 / alpha 2) := by
  rw [sample_q2]
  norm_num [alpha, derivative_add, derivative_sub, derivative_mul, derivative_pow]

-- The source domain excludes d = 0. Its totalized extension is numerically vacuous.
example : Q (normalizedJensen sample 0) 0 = (1 : ℂ[X]) := by
  norm_num [Q, normalizedJensen,
    D5.S3.Zeros.Jensen.JensenPolynomialObstruction.jensenPolynomial, sample,
    Finset.sum_range_succ]

example : alpha 0 = 0 ∧ (0 : ℂ) * alpha 0 ^ (0 - 1) * 1 = 0 := by
  norm_num [alpha]

-- Leading coefficient of P vanishes: fixed length reflection keeps the extra X.
example : Q (1 + C 2 * X : ℂ[X]) 2 = X ^ 2 - C 2 * X := by
  simp only [Q, add_comp, mul_comp, C_comp, X_comp, one_comp,
    ← mul_assoc, ← C_mul, reflect_add, reflect_C_mul, reflect_one]
  rw [show reflect 2 (X : ℂ[X]) = X by
    simpa using (reflect_monomial 2 1 (R := ℂ))]
  norm_num
  ring

-- Leading coefficient of q vanishes as well when a0 = 0; no monicity premise is used.
example : (X * C (-2) + C 3 : ℂ[X]).derivative.eval 3 = -2 ∧
    (2 : ℂ) * alpha 2 ^ (2 - 1) * (C (-2) : ℂ[X]).eval (3 / alpha 2) = -2 := by
  norm_num [alpha, derivative_add, derivative_mul]

#print axioms sample_q2
#print axioms sample_q1
#print axioms reciprocal_binding
#print axioms binding_at_zero
#print axioms b1_polynomial
#print axioms b1_eval
#print axioms b1_source
#print axioms source_binding
end B1BindOnlyProbe
```
