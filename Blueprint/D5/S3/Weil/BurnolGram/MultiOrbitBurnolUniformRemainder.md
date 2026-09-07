# Uniform Multi-Orbit Burnol Remainder

## Abstract

A constructed common Burnol packet has a coefficient-uniform geometric remainder and realizes a whole finite family of negative full Weil squares.

**Theorem 1.1 (Uniform remainder derived from actual zeta summability).**

Lean statement: `D5/S3/Weil/ZetaBridge/MultiOrbitBurnolUniformRemainder.multiOrbitBurnol_uniform_remainder`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/MultiOrbitBurnolUniformRemainder.multiOrbitBurnol_uniform_remainder` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The target union has the exact value minus four times the multiplicity-weighted coefficient energy. The finite exceptional complement vanishes, and the outside peak contributes the quarter-power factor. The summable mixed majorant controls every cross term uniformly in a.

**Theorem 1.2 (A genuine injective negative family for the complete zero sum).**

Lean statement: `D5/S3/Weil/ZetaBridge/MultiOrbitBurnolUniformRemainder.finite_multiOrbit_full_weil_negative_family`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/MultiOrbitBurnolUniformRemainder.finite_multiOrbit_full_weil_negative_family` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A common finite power depth is chosen using the geometric decay and the analytic multiplicity floor one. The packet itself is constructed from the supplied valid finite orbit frame, so no remainder estimate or interpolation-full-rank axiom is an extra premise.

The result assumes a finite separated family of nonreal off-line orbits; it does not assert that such an orbit exists. Constants are frame dependent. No RH, prime-side coercivity, computable depth, or infinite-index conclusion is claimed.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/MultiOrbitBurnolUniformRemainder.finite_multiOrbit_full_weil_negative_family`
- Truth anchor: `D5/S3/Weil/ZetaBridge/MultiOrbitBurnolUniformRemainder.multiOrbitBurnol_uniform_remainder`
- Dependency: [D5/S3/Weil/ZetaBridge/FiniteMixedWeilMajorant](FiniteMixedWeilMajorant.md)
- Dependency: [D5/S3/Weil/ZetaBridge/FiniteOrbitBurnolPacket](FiniteOrbitBurnolPacket.md)
