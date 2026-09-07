# Simultaneous Orbit Burnol Packet

## Abstract

A finite separated nonreal off-line orbit frame admits one common unit peak and simultaneous finite-exception killers.

**Theorem 1.1 (Frame node separation forbids orbit overlap).**

Lean statement: `D5/S3/Weil/ZetaBridge/FiniteOrbitBurnolPacket.frame_orbits_pairwise_disjoint`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/FiniteOrbitBurnolPacket.frame_orbits_pairwise_disjoint` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Injectivity of the node equivalence excludes coincident selected frequencies, while sign separation excludes their negatives. The four symmetry images are checked explicitly, so disjointness is derived rather than an extra packet premise.

**Theorem 1.2 (The localization packet is constructed).**

Lean statement: `D5/S3/Weil/ZetaBridge/FiniteOrbitBurnolPacket.exists_orbitBurnolPacket`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/FiniteOrbitBurnolPacket.exists_orbitBurnolPacket` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A common peak is interpolated to one on the actual target union. Closed-strip decay supplies a finite exceptional spectral ball. Each killer is then interpolated on that same ball to signed Kronecker data on the selected orbits and to zero on the rest. All packet fields are proved from existing analysis.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/FiniteOrbitBurnolPacket.exists_orbitBurnolPacket`
- Truth anchor: `D5/S3/Weil/ZetaBridge/FiniteOrbitBurnolPacket.frame_orbits_pairwise_disjoint`
- Dependency: [D5/S3/Weil/ZetaBridge/FiniteEvenWeilOddInterpolation](FiniteEvenWeilOddInterpolation.md)
- Dependency: [D5/S3/Weil/ZetaBridge/FiniteReflectionCompatibleWeilInterpolation](FiniteReflectionCompatibleWeilInterpolation.md)
