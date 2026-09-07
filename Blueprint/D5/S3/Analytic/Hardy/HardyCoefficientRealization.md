# Native Disk Hardy Coefficients

## Abstract

The full square-summable coefficient Hilbert space has convergent, bounded and injective disk evaluation; normalized radial means recover its exact norm.

Throughout, H2 is lp(N, C, 2), with its complete complex Hilbert space structure. Its vectors have arbitrary square-summable coefficients, not necessarily finite support. The open disk is |z| < 1.

**Definition 1.1 (The full coefficient carrier).**

$$H^{2} = \operatorname{lp}(\mathbb{N}, \mathbb{C}, 2)$$

*Formalization.* `D5/S3/Analytic/Hardy/HardyCoefficientRealization.H2` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The carrier inherits Mathlib's lp norm and Hilbert structure.

**Definition 1.2 (Coefficient evaluation).**

$$\forall f\in H^{2}, z\in \mathbb{C}, \operatorname{evaluate}(f, z) = \sum_{n\in \mathbb{N}} f_{n} z^{n}$$

*Formalization.* `D5/S3/Analytic/Hardy/HardyCoefficientRealization.evaluate` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The total tsum expression is used as a function on C. Convergence is proved on the open disk; no boundary value is asserted for an arbitrary Hardy vector.

**Theorem 1.3 (Interior convergence).**

$$\forall f\in H^{2}, z\in \mathbb{C}, |z|<1\Rightarrow \operatorname{Summable}(n\mapsto f_{n} z^{n})$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.summable_evaluate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The coefficient bound |f_n| <= ||f|| and a convergent geometric majorant give absolute convergence at each interior point.

**Theorem 1.4 (The actual series sum).**

$$\forall f\in H^{2}, z\in \mathbb{C}, |z|<1\Rightarrow \operatorname{HasSum}(n\mapsto f_{n} z^{n}, \operatorname{evaluate}(f, z))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.evaluate_hasSum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Evaluation equals the sum of the convergent coefficient series.

**Theorem 1.5 (Bounded evaluation).**

$$\forall f\in H^{2}, z\in \mathbb{C}, |z|<1\Rightarrow |\operatorname{evaluate}(f, z)| \le \frac{\Vert f \Vert}{1-|z|}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.norm_evaluate_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This geometric bound certifies continuity of evaluation; it is not claimed to be the sharp reproducing-kernel bound.

**Definition 1.6 (A bounded complex-linear functional).**

$$\forall z\in \mathbb{C}, |z|<1\Rightarrow \operatorname{eval}(z): H^{2}\to\mathbb{C}$$

*Formalization.* `D5/S3/Analytic/Hardy/HardyCoefficientRealization.eval` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The displayed map is continuous and complex-linear. Its Lean parameter also carries the proof that |z| < 1.

**Theorem 1.7 (Functional evaluation agrees with the series).**

$$\forall f\in H^{2}, z\in \mathbb{C}, |z|<1\Rightarrow \operatorname{eval}(z, f)=\operatorname{evaluate}(f, z)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.eval_apply` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The bounded functional has precisely the coefficient-series value.

**Theorem 1.8 (The radius includes the unit disk).**

$$\forall f\in H^{2}, 1\le\operatorname{radius}(\operatorname{ofScalars}(\mathbb{C}, f))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.series_radius` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is a lower bound for the extended nonnegative convergence radius.

**Theorem 1.9 (Analytic disk realization).**

$$\forall f\in H^{2}, \operatorname{AnalyticOnNhd}(\mathbb{C}, \operatorname{evaluate}(f), \operatorname{ball}(0, 1))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.analytic_evaluate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The series is complex analytic at every point of the open unit disk.

**Theorem 1.10 (Evaluation determines the coefficient vector).**

$$\forall f,g\in H^{2}, (\forall z\in \mathbb{C}, |z|<1\Rightarrow \operatorname{evaluate}(f, z)=\operatorname{evaluate}(g, z))\Rightarrow f=g$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.evaluate_injective` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Local uniqueness of scalar analytic power series determines every coefficient.

**Theorem 1.11 (The full coefficient norm).**

$$\forall f\in H^{2}, \sum_{n\in \mathbb{N}} |f_{n}|^{2}=\Vert f \Vert^{2}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.coefficient_norm_sq` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The sum ranges over every natural coefficient.

**Theorem 1.12 (Convergence of coefficient truncations).**

$$\forall f\in H^{2}, \operatorname{HasSum}(n\mapsto \operatorname{single}(2, n, f_{n}), f)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.coefficient_truncations` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Finite sums of the coefficient singletons converge in the H2 norm.

**Definition 1.13 (A continuous Fourier realization of each radial series).**

$$\operatorname{radialSeries}(f, r)=\sum_{n\in \mathbb{N}} f_{n}r^{n} \operatorname{fourier}(n)$$

*Formalization.* `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialSeries` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The continuous functions live on AddCircle(2 pi). Fourier mode n has value exp(i n t). Convergence is supplied under 0 <= r < 1.

**Theorem 1.14 (Uniform convergence on a radius).**

$$\forall f\in H^{2}, r\in \mathbb{R}, 0\le r<1\Rightarrow \operatorname{HasSum}(n\mapsto f_{n}r^{n} \operatorname{fourier}(n), \operatorname{radialSeries}(f, r))$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialSeries_hasSum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

HasSum holds in the continuous-function norm, hence uniformly on the circle.

**Theorem 1.15 (The radial L2 norm).**

$$\forall f\in H^{2}, r\in \mathbb{R}, 0\le r<1\Rightarrow \Vert \operatorname{toLp}(\operatorname{radialSeries}(f, r)) \Vert^{2}=\sum_{n\in \mathbb{N}} |f_{n}|^{2} r^{2n}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialSeries_norm_sq` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The L2 space uses normalized Haar measure of total mass one.

**Theorem 1.16 (The Fourier series is the disk evaluation).**

$$\forall f\in H^{2}, r\in \mathbb{R}, 0\le r<1\Rightarrow \forall t\in \mathbb{R}, \operatorname{radialSeries}(f, r, t)=\operatorname{evaluate}(f, re^{it})$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialSeries_evaluate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The circle coordinate is t modulo 2 pi; this equality identifies the Fourier construction with the original analytic evaluation.

**Definition 1.17 (Normalized radial mean square).**

$$\operatorname{R}(f, r)=\frac{1}{2\pi} \int_{0}^{2\pi} |\operatorname{evaluate}(f, re^{it})|^{2} dt$$

*Formalization.* `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialMean` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The normalization is exactly 1/(2 pi), and the integration interval is [0, 2 pi].

**Theorem 1.18 (Exact normalized radial identity).**

$$\forall f\in H^{2}, r\in \mathbb{R}, 0\le r<1\Rightarrow \frac{1}{2\pi} \int_{0}^{2\pi} |\operatorname{evaluate}(f, re^{it})|^{2} dt=\sum_{n\in \mathbb{N}} |f_{n}|^{2} r^{2n}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radial_mean_square` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Orthogonality of the Fourier modes gives the norm identity, and integration of the continuous representative converts it to the actual radial integral.

**Theorem 1.19 (Radial means are bounded by the coefficient norm).**

$$\forall f\in H^{2}, r\in \mathbb{R}, 0\le r<1\Rightarrow \operatorname{R}(f, r)\le\Vert f \Vert^{2}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialMean_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Each coefficient weight r^(2n) is at most one.

**Theorem 1.20 (Radial means converge to the full norm).**

$$\forall f\in H^{2}, \lim_{r\to1-} \operatorname{R}(f, r)=\Vert f \Vert^{2}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialMean_tendsto` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The limit is from below at r=1. Dominated convergence uses the summable squared coefficients as its bound.

**Theorem 1.21 (The exact Hardy norm).**

$$\forall f\in H^{2}, \operatorname{sup}_{0\le r<1}\operatorname{R}(f, r)=\Vert f \Vert^{2}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Hardy/HardyCoefficientRealization.hardy_norm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Taking the supremum over every real radius 0 <= r < 1 recovers the full coefficient Hilbert norm squared.

This module supplies the native disk Hardy realization. Finite Blaschke multiplier isometry, model-space dimension, all-phase normalized Clark kernels and the all-bounded-operator branch invariance remain separate obligations. The source's statement that Lambda_B is not Tao is an interpretive boundary, not a Lean proposition.

## References

- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.H2`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.analytic_evaluate`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.coefficient_norm_sq`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.coefficient_truncations`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.eval`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.eval_apply`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.evaluate`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.evaluate_hasSum`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.evaluate_injective`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.hardy_norm`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.norm_evaluate_le`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialMean`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialMean_le`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialMean_tendsto`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialSeries`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialSeries_evaluate`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialSeries_hasSum`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radialSeries_norm_sq`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.radial_mean_square`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.series_radius`
- Truth anchor: `D5/S3/Analytic/Hardy/HardyCoefficientRealization.summable_evaluate`
