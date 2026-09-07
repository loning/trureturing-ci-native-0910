# Mixed Pairings on the Observable Range

## Abstract

Every reduced mixed pairing has actual Weil-test representatives and is independent of their choice.

**Theorem 1.1 (Realization of arbitrary reduced pairings).**

Lean statement: `D5/S3/Weil/ZetaBridge/FiniteWeilObservableMixedForm.every_reduced_mixed_pairing_is_realized`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/FiniteWeilObservableMixedForm.every_reduced_mixed_pairing_is_realized` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Apply the existing finite interpolation surjection separately to both vectors, then use the existing mixed convolution factorization. Multiplicity is included once in B_T.

**Theorem 1.2 (Independence of representatives).**

Lean statement: `D5/S3/Weil/ZetaBridge/FiniteWeilObservableMixedForm.truncated_mixed_pairing_independent_of_representatives`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/FiniteWeilObservableMixedForm.truncated_mixed_pairing_independent_of_representatives` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Factor both mixed sums through their observable vectors. The first slot remains linear and the second conjugate-linear.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/FiniteWeilObservableMixedForm.every_reduced_mixed_pairing_is_realized`
- Truth anchor: `D5/S3/Weil/ZetaBridge/FiniteWeilObservableMixedForm.truncated_mixed_pairing_independent_of_representatives`
- Dependency: [D5/S3/Weil/ZetaBridge/WeilEvaluationExactObservableRange](WeilEvaluationExactObservableRange.md)
