# Unit Support and Explicit Peak Radius

## Abstract

The actual packet can be reconstructed with B=K=1; localization support is N+2 and two peak seminorms give a numerical exceptional-radius test.

**Theorem 1.1 (Construct both unit-support components).**

Lean statement: `D5/S3/Weil/ZetaBridge/UnitSupportBurnolPacket.exists_unit_support_orbitBurnolPacket`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/UnitSupportBurnolPacket.exists_unit_support_orbitBurnolPacket` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Retain support from the stronger finite reflection-compatible interpolation theorem at both stages. All signed values, exception annihilation and tail properties are proved using the existing packet construction. No old arbitrary packet is claimed to have these radii.

**Theorem 1.2 (Specified final support radius).**

Lean statement: `D5/S3/Weil/ZetaBridge/UnitSupportBurnolPacket.unit_support_burnol_radius`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/UnitSupportBurnolPacket.unit_support_burnol_radius` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Specialize the existing additive convolution support theorem to B=K=1. The radius is common to all coefficients.

**Theorem 1.3 (Explicit exceptional spectral radius).**

Lean statement: `D5/S3/Weil/ZetaBridge/UnitSupportBurnolPacket.peak_tail_of_two_jet_budget`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/UnitSupportBurnolPacket.peak_tail_of_two_jet_budget` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the derived two-jet closed-strip decay and the unconditional half-strip bound on gamma. The spectral-radius versus real-ordinate conversion is proved using the complex norm square. The finite target set must also be included when assembling a packet.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/UnitSupportBurnolPacket.exists_unit_support_orbitBurnolPacket`
- Truth anchor: `D5/S3/Weil/ZetaBridge/UnitSupportBurnolPacket.peak_tail_of_two_jet_budget`
- Truth anchor: `D5/S3/Weil/ZetaBridge/UnitSupportBurnolPacket.unit_support_burnol_radius`
- Dependency: [D5/S3/Weil/ZetaBridge/WeilMixedHeadTailBudget](WeilMixedHeadTailBudget.md)
