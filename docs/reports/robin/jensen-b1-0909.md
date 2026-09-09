# B1 精确微分兼容关系：绑定优先检验

第一条硬要求：只用钉版 Mathlib 实例化、冻结件投影与规范化改写尝试 B1；成功即记 `bind-only` 停手，不建 D5 模块、不寻找准入例外。

产地：runner 的 consensus-rnd/sshx implementation 席；本 worker 未调用 skill，Codex 主循环直接取证、实施临时探针及单点自查。零独立评审席，无共识票，不冒称 orchestrator 亲验。

LANE #6160；atom `087e3caa7c278b4ea58f06604daa8721ab5258f6c451a25ed8f2d0092d823ca0`，source_id `quantum-rh`。源码基准 `2ae36e58698ae84239445dda106082167b684438`；工作分支 `lane/math/jensen-b1-0909`。Lean v4.33.0，Mathlib `db584cd6d46c92f209a44c0f1c829460d327499d`。

`make show-atom` 退出 0，coverage 为空。原文唯一结论：设 α_d=(d−1)/d，对 d≥2，q_d′(x)=d α_d^(d−1) q_(d−1)(x/α_d)。未发现 brief 与该 atom 字节的差异。

已完成的接口检索：

- `D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering.lean` 全文已读，含任意实系数的 `normalizedJensen_degree_lowering` 和固定源系数的 `source_jensen_degree_lowering`。
- 当前冻结状态片 `Golden/Frozen/state/D5/S3/Zeros/Jensen/NormalizedJensenDegreeLowering.lean.json` 的模块 statement_id 为 `sha256:ee43a04a542df25237818cbfeeb29bb1abaed956f90db04822d08e8f413d50b4`。
- Mathlib `Algebra/Polynomial/Reverse.lean` 已查到 `coeff_reflect`、`revAt_le`、`reflect_C_mul_X_pow`、`eval₂_reflect_mul_pow`。引用已有公式；不重证反转理论。暂定 q 为 `(P.comp (-X)).reflect d`，固定反转长度避免最高项系数消失时错误改用实际次数。
- `git ls-tree origin/dev --name-only D5/S3/` 确认 `Zeros` 为已有域。

预登记停止条件：bind-only 成功；B1 除该绑定外还缺别的数学；源句错误；弱化陈述或捏造依据。任一触发即停实施并提交完整报告。

当前尚未编译临时探针、尚未作最终判形。退化点 x=0、d=0、首系数为零及正反数值见证待检。未主张已证 B1、未主张可证、未主张搜索穷尽、未主张 RH 或其它四条同族 atom 有任何推进。

第二批读数：B1 周围定义 B1/B2 与证明全文已读，q 明文为多项式；原文倒数表达式的零点须由多项式规范化解释。落点 `D5/S3/Zeros/Jensen/` 现有五模块已全文读完，未找到 B5 的已有声明。相关文本检索只作候选筛选，不作依赖闭包的语义证明。首个临时探针已写在 attempt 目录，先取冻结降阶恒等式的系数，再引用 Mathlib `coeff_reflect` 与求导/线性换元系数公式，最后作自然数指标与域运算规范化。尚未取得编译结论。

第一批推送已成功：`db143f851f`。本机 `make lean` 已启动。误探路径 `tools/scripts/lean.sh`、Mathlib `Algebra/GroupWithZero/Power.lean` 不存在，均记录为命令路径错误，不解释为数学库缺口。

第一次探针编译 `make -f Makefile -f A/probe.mk lean PROBE=A/B1Probe.lean` 退出 2（`A` 为任务指定 attempt 目录）。失败点是 `pow_sub₀` 的显式底数参数漏传，以及交换环乘积的括号重写未命中；系数范围两分支及次数界未报错。保留 `A/probe-01.log` 与 `A/B1Probe-01.lean`。失败版本的 `#print axioms` 含错误恢复用 `sorryAx`，不计为证明。初始原生 `make lean` 退出 0，12766 jobs，project/mathlib 均 warm。

第二次探针退出 2（`A/probe-02.log`）：`pow_sub₀` 的实际结论已经是乘逆式，后续多余 `rw [div_eq_mul_inv]` 无目标可改写；删去该步即可继续。冻结系数等式到目标的代数闭合未另报错。补入非零点倒数求值绑定、零点系数取值、固定源 B1 与两侧数值检查，仍只用库引理和规范化；没有改变目标或加入数学假设。

第三次探针总退出 2（`A/probe-03.log`），但 `b1_polynomial`、`reciprocal_binding`、`source_binding` 均已通过，闭包仅 `[propext, Classical.choice, Quot.sound]`。剩余失败在零点求值缺显式 `coeff_zero_eq_eval_zero` 改写、求值包装与 sample_q2 的宽 `simp` 达默认递归深度；不提高预算，改为指定公式分步规范化。尚未把总失败报为整体验证通过。

第四次探针总退出 2（`A/probe-04.log`），B1 的全部一般性声明 `b1_polynomial`、`b1_eval`、固定源 `b1_source` 与两种绑定均已通过，六条公理闭包全部只有标准三公理。唯一剩余报错是具体 sample_q2 的 `reflect 2 X` 与 `revAt 2 2` 化简遗漏。**停止判据 1 已触发：B1 整体判 `bind-only`，停止模块实施，不创建 D5 模块、不 deposit、不寻准入依据。** 后续仅完成 brief 必需的数值/退化诊断与报告交付。
