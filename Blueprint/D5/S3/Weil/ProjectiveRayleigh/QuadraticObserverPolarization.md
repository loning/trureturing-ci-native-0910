# Binary Quadratic Probes and Their Kernels

## Abstract

Three actual evaluations reconstruct every binary real quadratic form, and deleting any evaluation strictly enlarges the joint kernel.

**Definition 1.1 (The full Mathlib quadratic-form space).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.BinaryQuadratic`

*Formalization.* `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.BinaryQuadratic` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The state space contains every real quadratic form on two real coordinates. It is infinite and is not a chosen finite testing sample.

**Definition 1.2 (Standard coordinate vectors).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.axis`

*Formalization.* `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.axis` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The same two coordinate vectors are used by every probe.

**Definition 1.3 (Diagonal evaluations).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.diagonalProbe`

*Formalization.* `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.diagonalProbe` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Evaluate a quadratic form at one standard coordinate vector.

**Definition 1.4 (The evaluation containing the mixed coefficient).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.mixedProbe`

*Formalization.* `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.mixedProbe` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Evaluation at the sum of the two coordinate vectors records the cross coefficient together with the diagonal coefficients.

**Definition 1.5 (The two-evaluation language).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.diagonalLanguage`

*Formalization.* `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.diagonalLanguage` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The diagonal language is the range of the already-defined diagonal probes.

**Definition 1.6 (The fixed three-probe family).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.quadraticProbe`

*Formalization.* `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.quadraticProbe` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The two diagonal evaluations and the mixed evaluation form one indexed family on the unchanged state space.

**Theorem 1.7 (Reconstruct every vector evaluation).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.binary_quadratic_polarization`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.binary_quadratic_polarization` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Mathlib polarization and homogeneity express the quadratic value at an arbitrary vector through the three probes. The mixed coefficient is the third probe minus the first two.

**Theorem 1.8 (The three-probe readout is injective).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_readout_injective`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_readout_injective` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Equality of all three probe values implies equality at every vector, hence equality of quadratic forms.

**Theorem 1.9 (The mixed probe strictly refines the diagonal language).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.mixed_probe_strict_kernel_refinement`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.mixed_probe_strict_kernel_refinement` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Zero and the coordinate product agree on both axes and differ at their sum. The existing semantic-closure criterion converts that pair into strict joint-kernel inclusion.

**Theorem 1.10 (Each probe has its own separating pair).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_leave_one_out_witness`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_leave_one_out_witness` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Compare zero with x squared minus xy, y squared minus xy, or xy. Each chosen form changes exactly its designated probe and agrees on the other two.

**Theorem 1.11 (Every deletion strictly enlarges the joint kernel).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_kernel_irredundant`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_kernel_irredundant` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The leave-one-out pairs certify strict inclusion for each of the three deletions, using the repository's existing jointKernel definition.

**Theorem 1.12 (The complete kernel is equality).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_full_kernel_eq_diagonal`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_full_kernel_eq_diagonal` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The full three-probe joint kernel is exactly the diagonal relation on quadratic forms.

These statements certify this specified mathematical family on an infinite arena. They supply no finite escape-rate score and no seal of the system's maximal canonical catalog. The classical polarization identity and its existing source remain the only reconstruction owner.

## References

- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.BinaryQuadratic`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.axis`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.binary_quadratic_polarization`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.diagonalLanguage`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.diagonalProbe`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.mixedProbe`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.mixed_probe_strict_kernel_refinement`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.quadraticProbe`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_full_kernel_eq_diagonal`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_kernel_irredundant`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_leave_one_out_witness`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/QuadraticObserverPolarization.three_probe_readout_injective`
- Dependency: [D5/S3/ConceptDynamics/DefinitionEscapeLaws/StrictKernelNoveltyCriterion](../../ConceptDynamics/DefinitionEscapeLaws/StrictKernelNoveltyCriterion.md)
