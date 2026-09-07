# Actual Full Weil Gram Inertia

## Abstract

The actual full mixed Weil Gram is Hermitian and represents synthesized full zero sums; a constructed common Burnol family has exact spectral negative index equal to its observable orbit dimension.

**Theorem 1.1 (Full form as the limit of exact finite observable forms).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilFullGramInertia.reducedMirrorForm_tendsto_fullMixedWeilForm`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilFullGramInertia.reducedMirrorForm_tendsto_fullMixedWeilForm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The mixed finite factorization transports the existing symmetric-cutoff convergence theorem. The exact-range owner is used in this proof, rather than imported only to force a replay.

**Theorem 1.2 (Hermitian symmetry by actual zero reindexing).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilFullGramInertia.fullWeilGram_isHermitian`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilFullGramInertia.fullWeilGram_isHermitian` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The entries are absolutely convergent mixed zero sums. Conjugation swaps the tests after the existing multiplicity-preserving mirror permutation. The row convention is conjugate-linear.

**Theorem 1.3 (Exact full form, including every cross term).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilFullGramInertia.fullWeilGram_quadratic`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilFullGramInertia.fullWeilGram_quadratic` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Mixed summability justifies moving finite coefficient sums through the complete zero sum. This identifies a concrete full Gram, with no substituted scalar matrix or discarded tail.

**Theorem 1.4 (Full spectral inertia of the realized observable family).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilFullGramInertia.exists_actual_full_weil_gram_with_exact_negative_index`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilFullGramInertia.exists_actual_full_weil_gram_with_exact_negative_index` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The existing common Burnol construction supplies the basis and coefficient-uniform full negativity. Standard positive-definite matrix spectral facts then compute the repository negative index.

A valid finite separated nonreal off-line orbit frame remains an input. No existence of off-line zeros, RH, equality with ambient multiplicity-expanded index, or global fixed support bound is asserted. Source completion remains Candidate until pinned replay and axiom/admission checks.

## References

- Truth anchor: `D5/S3/Weil/BurnolGram/WeilFullGramInertia.exists_actual_full_weil_gram_with_exact_negative_index`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilFullGramInertia.fullWeilGram_isHermitian`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilFullGramInertia.fullWeilGram_quadratic`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilFullGramInertia.reducedMirrorForm_tendsto_fullMixedWeilForm`
- Dependency: [D5/S3/SpectralTopology/FiniteSpectralLocalizer](../../SpectralTopology/FiniteSpectralLocalizer.md)
- Dependency: [D5/S3/Weil/BurnolGram/MultiOrbitBurnolUniformRemainder](MultiOrbitBurnolUniformRemainder.md)
- Dependency: [D5/S3/Weil/WeilObservables/WeilEvaluationExactObservableRange](../WeilObservables/WeilEvaluationExactObservableRange.md)
