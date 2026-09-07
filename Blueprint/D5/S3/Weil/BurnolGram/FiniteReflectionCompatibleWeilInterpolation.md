# Reflection-Compatible Finite Interpolation

## Abstract

Reflection-compatible finite zero data admit exact even Weil interpolation within a fixed unit support window.

**Theorem 1.1 (Representative invariance).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.reflectionRep_reflection`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.reflectionRep_reflection` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The existing representative is the minimum of a reflection pair. Reflection exchanges the two entries.

**Theorem 1.2 (Compatible values descend).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.reflectionRep_value`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.reflectionRep_value` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Split according to which index is the representative and apply compatibility.

**Theorem 1.3 (Actual finite interpolation in a unit window).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.even_weil_interpolation_on_finite_indices_unit_support`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.even_weil_interpolation_on_finite_indices_unit_support` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the existing reflection representative image and its sign-separation theorem, then the support-controlled polynomial interpolation. Transfer the values back using gamma injectivity and evenness.

**Theorem 1.4 (Original finite interpolation interface).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.even_weil_interpolation_on_finite_indices`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.even_weil_interpolation_on_finite_indices` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Forget the support conjunct of the stronger theorem. The previous public statement remains unchanged.

**Theorem 1.5 (Simultaneous unit values).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.exists_even_weil_finite_unit_peak`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.exists_even_weil_finite_unit_peak` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Specialize the compatible assignment to the constant one function.

**Theorem 1.6 (The peak has specified support).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.exists_even_weil_finite_unit_peak_unit_support`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.exists_even_weil_finite_unit_peak_unit_support` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Retain the support conjunct when specializing to constant values. No uniform bound on derivative norms is claimed.

## References

- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.even_weil_interpolation_on_finite_indices`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.even_weil_interpolation_on_finite_indices_unit_support`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.exists_even_weil_finite_unit_peak`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.exists_even_weil_finite_unit_peak_unit_support`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.reflectionRep_reflection`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteReflectionCompatibleWeilInterpolation.reflectionRep_value`
- Dependency: [D5/S3/Weil/ZetaBridge/OffLineNonrealZeroNegativeWeilSquare](../ZetaBridge/OffLineNonrealZeroNegativeWeilSquare.md)
