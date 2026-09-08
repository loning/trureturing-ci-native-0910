# Projective Rayleigh Enclosure and Rectangle Zero Counts

## Abstract

A proved projective Rayleigh error passes through actual bounded linear readouts and supplies the error term of the existing rectangle Rouche theorem.

**Theorem 1.1 (Propagate a squared Hilbert-space error).**

Lean statement: `D5/S3/Weil/ZetaAnalytic/ProjectiveRayleighRouche.bounded_linear_readout_error_sq`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaAnalytic/ProjectiveRayleighRouche.bounded_linear_readout_error_sq` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For a bounded complex linear functional L, the existing operator-norm inequality bounds ||Lx-Ly|| by ||L|| ||x-y||. Squaring preserves the inequality because both sides are nonnegative. Thus an actual squared state-error bound r gives ||Lx-Ly||^2<=||L||^2 r. This is a companion transport lemma, with no claim of an independent analytical discovery.

**Theorem 1.2 (A separately certified boundary margin makes the comparison strict).**

Lean statement: `D5/S3/Weil/ZetaAnalytic/ProjectiveRayleighRouche.bounded_linear_readout_rouche_bound`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaAnalytic/ProjectiveRayleighRouche.bounded_linear_readout_rouche_bound` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The explicit inequality ||L||^2 r < ||Ly||^2 supplies strictness. The result is precisely ||Lx-Ly||<||Ly||, the pointwise hypothesis consumed by the rectangle zero-count owner. A small state error alone does not imply that Ly is nonzero or provide this boundary margin.

**Theorem 1.3 (Consume the derived projective estimate in the existing zero count).**

Lean statement: `D5/S3/Weil/ZetaAnalytic/ProjectiveRayleighRouche.projective_rayleigh_rectangle_zero_count`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaAnalytic/ProjectiveRayleighRouche.projective_rayleigh_rectangle_zero_count` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The operator-domain hypotheses are passed directly to projective_rayleigh_enclosure; no projective error bound is assumed. The proved overlap is nonzero. At each rectangle boundary point the bounded readout transfers the derived ratio (U-ell)/(T-ell) to a strict Rouche inequality. The existing rectangle_zero_count_eq_of_norm_sub_lt then identifies the two sums of analytic multiplicities. Both functions' analyticity, their exact finite zero lists and the candidate boundary margin remain explicit.

The intended arithmetic application uses Fourier evaluation on an actual fixed-support L2 space. Realizing that bounded functional, its norm bound and its analytic dependence is still separate work. This source does not identify an arbitrary readout with Xi, certify a zero-free rectangle, or prove uniform convergence as the support radius grows.

This is a named downstream consumer of the new variational theorem and of the existing RoucheZeroCount module. The latter remains the sole owner of rectangle zero-count stability; no second zero predicate or multiplicity definition is introduced. The companion assembly is not counted as a separate solution of an open problem.

## References

- Truth anchor: `D5/S3/Weil/ZetaAnalytic/ProjectiveRayleighRouche.bounded_linear_readout_error_sq`
- Truth anchor: `D5/S3/Weil/ZetaAnalytic/ProjectiveRayleighRouche.bounded_linear_readout_rouche_bound`
- Truth anchor: `D5/S3/Weil/ZetaAnalytic/ProjectiveRayleighRouche.projective_rayleigh_rectangle_zero_count`
- Dependency: [D5/S3/Weil/ZetaAnalytic/RoucheZeroCount](RoucheZeroCount.md)
- Dependency: [D5/S3/Weil/ZetaLinear/ProjectiveRayleighCapture](../ZetaLinear/ProjectiveRayleighCapture.md)
