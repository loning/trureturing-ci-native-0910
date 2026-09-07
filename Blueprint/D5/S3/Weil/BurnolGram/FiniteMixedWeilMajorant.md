# Finite Mixed Weil Majorant

## Abstract

All mixed convolution terms of a finite Weil basis are absolutely summable and yield one majorant uniform over the whole coefficient space.

**Theorem 1.1 (The square includes every coefficient cross term).**

Lean statement: `D5/S3/Weil/ZetaBridge/FiniteMixedWeilMajorant.zeroSummand_finite_synthesis_expansion`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/FiniteMixedWeilMajorant.zeroSummand_finite_synthesis_expansion` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The mixed summand is the actual zero summand of convolve(g_i,involution(g_j)), so its absolute summability comes from the existing zeta explicit formula. No diagonal-only estimate is substituted for a bound on the full family.

**Theorem 1.2 (One fixed majorant controls every coefficient vector).**

Lean statement: `D5/S3/Weil/ZetaBridge/FiniteMixedWeilMajorant.finite_synthesis_absolute_sum_le`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/FiniteMixedWeilMajorant.finite_synthesis_absolute_sum_le` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Each coefficient product has norm at most the complete coefficient energy. Summing all mixed absolute terms gives a finite constant independent of the coefficient vector and of later convolution-power depth.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/FiniteMixedWeilMajorant.finite_synthesis_absolute_sum_le`
- Truth anchor: `D5/S3/Weil/ZetaBridge/FiniteMixedWeilMajorant.zeroSummand_finite_synthesis_expansion`
- Dependency: [D5/S3/Weil/ZetaBridge/OffLineNonrealZeroNegativeWeilSquare](OffLineNonrealZeroNegativeWeilSquare.md)
- Dependency: [D5/S3/Weil/ZetaBridge/QuantitativeMultiOrbitWeilNegativeCertificate](QuantitativeMultiOrbitWeilNegativeCertificate.md)
- Dependency: [D5/S3/Weil/ZetaBridge/WeilEvaluationObservableSubspace](WeilEvaluationObservableSubspace.md)
