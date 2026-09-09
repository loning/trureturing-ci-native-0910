# AnalyticLogarithmicContinuation

## Abstract

Classical analytic continuation preserves the actual scalar series and excludes zeros through analytic orders.

**Theorem 1.1 (All smaller radii have absolute convergence).**

Lean statement: `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.quadratic_coefficients_summable`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.quadratic_coefficients_summable` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A bound on every coefficient is compared with polynomial-weighted geometric series, including radius zero.

**Theorem 1.2 (Analyticity of the original scalar sum).**

Lean statement: `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.scalar_series_analytic_unit_disk`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.scalar_series_analytic_unit_disk` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The existing formal scalar-series radius and analyticity theorems apply to the actual coefficient sum throughout the unit disk.

**Theorem 1.3 (A nonzero analytic solution stays nonzero).**

Lean statement: `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.analytic_linear_ode_zero_free`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.analytic_linear_ode_zero_free` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

At a putative zero, differentiation lowers finite analytic order while multiplication by an analytic coefficient cannot. Connectedness and the nonzero initial value exclude infinite order.

**Theorem 1.4 (A local identity gives a global nonvanishing result).**

Lean statement: `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.local_logarithmic_equation_zero_free`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.local_logarithmic_equation_zero_free` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The analytic identity theorem extends the original derivative equation from a germ. Neither a global logarithm nor an already zero-free domain is supplied.

## References

- Truth anchor: `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.analytic_linear_ode_zero_free`
- Truth anchor: `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.local_logarithmic_equation_zero_free`
- Truth anchor: `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.quadratic_coefficients_summable`
- Truth anchor: `D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.scalar_series_analytic_unit_disk`
