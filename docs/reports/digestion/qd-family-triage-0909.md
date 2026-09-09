# q_d 家族剩余四条分诊（LANE #6160）

产地：runner thinking 席；无 skill，Codex 主循环直接检索、探针与单点自查。零独立评审席；不冒称共识或 orchestrator 亲验。

基准 `e34699c5198180cee56093ee6995eab47c4698fc`，分支 `lane/math/qd-family-triage-0909`。先全文读 tracked `tools/scripts/agent/probe-brief-note.txt`、`CLAUDE.md` 和 `agents/CONTEXT.md`。根目录 `family.json`、`candidates.json` 是既有未跟踪输入，不进入提交。

预登记：承认 B1 已判 bind-only；Q 固定采用 `(p.comp (C (-1) * X)).reflect d`，次数政策 `natDegree ≤ d`。全域多项式和非零点倒数公式分开。B1.1 预期仅剩顶项归一化与 FTC。B3 候选逃逸是简单临界点的留数符号与箭头特征多项式/严格正谱的等价；B4 候选是箭头二次迹或留数和到系数的恒等式；降阶推论候选是严格正根域保存（含重根），随后塔上归纳。以上全是待测预测，不是结论。

停止：四条全判即结束；不降低逐条证据门槛。brief 未给总时长数值，本席以开工后 60 分钟为工作窗口、30 分钟为中点检查（起点 2026-09-09 08:12:31 UTC）；未改仓内或 runner 预算常数。中点若不足两条即停并列出未判 atom。仅报告与临时探针；禁止生产模块、cover、deposit、PR。

第一批检索原始收据：[search-01.json](qd-family-triage-0909/search-01.json)。所有阴阳对照均使用相同的 `\b` 正则特性；未命中不是不存在性证明。

已实查：`NormalizedJensenDegreeLowering` 的冻结 state pin 为 `sha256:ee43a04a542df25237818cbfeeb29bb1abaed956f90db04822d08e8f413d50b4`；任意实系数序列、d≥2 的降阶恒等式可接。B1 先席已提交报告读取自 `c58ed1b7d24efea45d8e077197bd284aaa45a534:docs/reports/robin/jensen-b1-0909.md`；其已验部分仅作为当前新增探针的前置，不冒称冻结 API。

## conclusion（增量）

`screened=0`。四条尚未给判词。

- `1e414ffb45d7fcaa9536a956298c4e291f91a2e310f112d2cf8419518caefd1a`：待 B1.1 探针。
- `2bc63109d666c92a11aa641dbeae45bc08e3f4f939bc5ce4406a75e5d86d03b6`：待 B3 探针。
- `c0a72a217fb966246fd4a48a809795cdc539435d1e88d1a10d041a9bcd9ed98d`：待 B4 探针。
- `cd2ad7f9986ee06ef6a8ac86aa7834a19d836483eaa1475b57396f3ba7ae536a`：待降阶探针。

`nonclaims`：未落地；未 cover；未 deposit；未开 PR；未主张检索穷尽；“未命中”不是“Mathlib 里不存在”的证明；未证四条目标；未主张 RH 的任何蕴含。未打开的外部文献为 `ASSUMED-UNVERIFIED`，不承载本判词。


## B1.1 第一次片段实测（整次 make 尚待退出）

`B11Probe.lean` 已 elaborate 完整 `b11_source`：对 d≥2、全部 x:ℝ，复多项式 Q 在 x 的值等于指定相邻层积分加 `(-1)^d*d!/d^d*a_d`。`b11_constant` 直接用已冻结 `source_jensen_coeff_edges` 第四投影；`b11_source` 接前席 B1 系数运输和 Mathlib FTC。两者 axioms 都恰为标准三公理。日志 [b11-checkpoint.log](qd-family-triage-0909/b11-checkpoint.log) 尚无 EXIT，不据此提前把整次 make 记为通过；待命令返回后逐条结算。

[search-02.json](qd-family-triage-0909/search-02.json) 记录第二批实查：Lagrange.coeff_eq_sum（497 行）、Gauss–Lucas（97 行）、FTC、real restriction 与 Schur。前述箭头关键词无命中不能遮盖这些语义近邻。B4 新探针检验“余式最高系数等于临界值/节点差积之和”；这是 Lagrange 直接实例化的候选 bind 路线，尚未判定。


## 第一条结算：B1.1

`bind_only=yes`，`remaining_gap=none`，`escape_witness=null`。整次 make EXIT=0；534.14 秒，12767 jobs，标准三公理。源顶项的归一化已是冻结投影，不再作为缺口。

```json
{
  "atom_id": "1e414ffb45d7fcaa9536a956298c4e291f91a2e310f112d2cf8419518caefd1a",
  "title": "推论 B1.1：高阶延拓是一项带常数的积分问题",
  "bind_only": "yes",
  "proof_shape": "bind-only",
  "remaining_gap": "none：常数由已冻结 source_jensen_coeff_edges 第四投影 + coeff_reflect + ring；积分由已判 B1 与 FTC 直接实例化。",
  "probe_statement": "B1BindOnlyProbe.b11_source: ∀ d≥2, ∀ x:ℝ, (Q (sourceJensenPolynomial d) d).eval (x:ℂ) = (∫ u in 0..x, d*alpha(d)^(d-1)*(Q (sourceJensenPolynomial (d-1)) (d-1)).eval ((u:ℂ)/alpha(d))) + (-1)^d*d!/d^d*(sourceThetaCoefficient d:ℂ).",
  "probe_file": "docs/reports/digestion/qd-family-triage-0909/B11Probe.lean",
  "probe_run": "b11-01",
  "mathlib_hits": [
    {
      "declaration": "Polynomial.reflect",
      "file": ".lake/packages/mathlib/Mathlib/Algebra/Polynomial/Reverse.lean",
      "line": 88
    },
    {
      "declaration": "Polynomial.coeff_reflect",
      "file": ".lake/packages/mathlib/Mathlib/Algebra/Polynomial/Reverse.lean",
      "line": 96
    },
    {
      "declaration": "Polynomial.eval₂_reflect_mul_pow",
      "file": ".lake/packages/mathlib/Mathlib/Algebra/Polynomial/Reverse.lean",
      "line": 191
    },
    {
      "declaration": "Polynomial.hasDerivAt",
      "file": ".lake/packages/mathlib/Mathlib/Analysis/Calculus/Deriv/Polynomial.lean",
      "line": 67
    },
    {
      "declaration": "HasDerivAt.comp_ofReal",
      "file": ".lake/packages/mathlib/Mathlib/Analysis/Complex/RealDeriv.lean",
      "line": 97
    },
    {
      "declaration": "intervalIntegral.integral_eq_sub_of_hasDerivAt",
      "file": ".lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/FundThmCalculus.lean",
      "line": 1148
    }
  ],
  "frozen_interfaces": [
    {
      "gid": "D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering.normalizedJensen_degree_lowering",
      "statement_id": "sha256:f13a2fdd4121c7b170af20e397cf8d9c567ddfcfd4dd8e37d469c21f8603d6bf",
      "state_path": "Golden/Frozen/state/D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering.lean.json",
      "module_statement_id": "sha256:ee43a04a542df25237818cbfeeb29bb1abaed956f90db04822d08e8f413d50b4",
      "scope": "任意实系数序列，d≥2；复多项式降阶恒等式，无根或矩阵结论"
    },
    {
      "gid": "D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering.normalizedJensen_eq_fallingFactorial_sum",
      "statement_id": "sha256:8a2655f8cbb74a3d045256378f01d8c6468e59545dc09fc5446bd390f898c025",
      "state_path": "Golden/Frozen/state/D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering.lean.json",
      "module_statement_id": "sha256:ee43a04a542df25237818cbfeeb29bb1abaed956f90db04822d08e8f413d50b4",
      "scope": "任意实系数序列，d≥1；有限下降阶乘和"
    },
    {
      "gid": "D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering.sourceJensenPolynomial_eq_normalizedJensen",
      "statement_id": "sha256:0c96cec689edaf5a585802b79a9c52b976c6dcedbee0cd259b40d0a7d19ecfa9",
      "state_path": "Golden/Frozen/state/D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering.lean.json",
      "module_statement_id": "sha256:ee43a04a542df25237818cbfeeb29bb1abaed956f90db04822d08e8f413d50b4",
      "scope": "固定 theta 系数，d≥1；源对象到通用归一化对象"
    },
    {
      "gid": "D5/S3/Zeros/Jensen/SourceJensenPrincipalBlockObstruction.source_jensen_coeff_edges",
      "statement_id": "sha256:adde2bcfe9e6e59415236589839993c3faa03e7cabdaa4276c8a049fc9daae39",
      "state_path": "Golden/Frozen/state/D5/S3/Zeros/Jensen/SourceJensenPrincipalBlockObstruction.lean.json",
      "module_statement_id": "sha256:5e43098caa9fb48b4fccd8adc30e337ff93668044d5dcfc06acab33dc8970f3c",
      "scope": "固定 theta 系数，d≥1；四系数合取，第四项是顶项 d!/d^d*a_d"
    }
  ],
  "escape_witness": null,
  "admission_if_landed": {
    "admission_basis": "rule-11-upstream-wrapper",
    "reason": "条件性的落地依据：atom B6 明文要求源 Q 的指定积分表示；Mathlib.intervalIntegral.integral_eq_sub_of_hasDerivAt 是精确积分引擎，允许最薄诚实包装。常数单独只是冻结投影，无独立准入依据；本席不实施。"
  }
}
```

完整日志：[b11-01.log](qd-family-triage-0909/b11-01.log.gz)。B4 初试 [b4-01.log](qd-family-triage-0909/b4-01.log) 因 canonical cache writer guard busy 返回2，未到 Lean，不能据此判数学不闭合；待释放后重跑。第二批 Schur 的结尾 `\b` 不匹配下标字符，属于正则词界问题，已读到实际声明582行，不拿该0命中主张不存在。


## B4 中间片段与检索纠错

第二轮（第一轮真正进入 Lean）`b4-02.log` EXIT=2：`nodal_derivative` 与 `b4_cumulant` 标准三公理；`b4_residue_sum` 尚含错误恢复 sorryAx，不承载结论。报错是 `degree_lt_iff_coeff_zero` 需显式参数、`sum_neg_distrib` 改写方向反了。修复后连同实际源 Q 前三系数的规范化一起重跑，不把部分证明误报为整条通过。

B1.1 原始 stdout 61.14 MB（Mathlib/仓库历史警告回放）已在当前树改存无损 gzip；[摘录](qd-family-triage-0909/b11-01-excerpt.txt) 给可读的 command/EXIT/axioms。原始字节仍完整保留，未重写已推历史。


B4 第三轮 `make lean` EXIT=2（149.23秒）：错误集中在复数域 `n+2 ≠ 0` 未显式交给 `field_simp`，以及宽 `simp` 提前拆开 C 的乘积，导致系数引理无法命中。已改为先 `simp only [finsetSum_coeff, coeff_C_mul_X_pow]` 再规范化，补显式非零分母；仍不把这类语法/规范化失败称为数学 content。原始失败源码与日志已归档。


## 中点停止：仅一条完成

2026-09-09 08:43:16 UTC 检查，已超过预登记中点 08:42:31 UTC。`screened=1`、`bind_only_count=1`；B1.1 为 yes。依用户停止条件，停止新增数学检索、证明修补及探针。B3、B4、降阶推论均 **未判**，不填伪造的 no。

B4 第四轮 [b4-04.log](qd-family-triage-0909/b4-04.log) EXIT=2，217.170564375 秒。`b4_residue_sum`、`nodal_derivative`、`b4_cumulant`、`b4_source_cumulant` 仅标准三公理；`qSource_top_three` 仍有未闭合目标 `True ∨ sourceThetaCoefficient 2 = 0`，`b4_source` 依赖错误恢复 `sorryAx`。这不是数学逃逸见证，整条不得判为 bind-only 或 content。保持失败快照 [B4Probe-04.lean](qd-family-triage-0909/B4Probe-04.lean)，不再修补。

降阶探针仅准备、未调用 make；归档为 [DescentProbe-UNRUN.lean](qd-family-triage-0909/DescentProbe-UNRUN.lean)。B3 没有探针。完整结构化结算与推送收据随后仅做归档整理。
