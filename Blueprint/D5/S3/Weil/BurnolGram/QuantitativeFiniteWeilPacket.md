# Quantitative Packets from Certified Finite Zero Nodes

## Abstract

Actual multi-orbit Burnol packets are reconstructed with unit support, finite arithmetic interpolation jets and an explicit exceptional radius. The remaining infinite scalar zero-tail estimate is kept separate.

**Definition 1.1 (The existing sign quotient as a finite catalog).**

Lean statement: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.reflectionNodeSet`

*Formalization.* `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.reflectionNodeSet` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This is exactly the finite image used inside the existing reflection-compatible interpolation proof. Multiplicity copies do not become additional nodes.

**Theorem 1.2 (Finite zero data with explicit jets).**

Lean statement: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.quantitative_interpolation_on_finite_indices`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.quantitative_interpolation_on_finite_indices` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Descend values through the existing reflection representative, apply the constructed finite-box/Lagrange jet theorem, then transport evaluations back to the original zero indices. The source reuses gamma injectivity and reflectionRep_freq. All new assumptions are finite nodal enclosures or compatibility statements.

**Definition 1.3 (An explicit exceptional cutoff).**

Lean statement: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.quantitativePeakRadius`

*Formalization.* `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.quantitativePeakRadius` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

R is a bound for the selected target node norms. The remaining terms are finite arithmetic expressions from the interpolation jet theorem. The generous additive radius avoids an existential eventual-smallness threshold.

**Theorem 1.4 (Construct the peak and prove the tail bound).**

Lean statement: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.exists_quantitative_finite_unit_peak`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.exists_quantitative_finite_unit_peak` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use unit-valued finite interpolation. The already proved half-strip jet bound then implies the explicit cutoff inequality. No unspecified derivative norm or unknown exceptional radius is assumed.

**Theorem 1.5 (A complete actual finite packet from two finite catalogs).**

Lean statement: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.exists_quantitative_orbitBurnolPacket`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.exists_quantitative_orbitBurnolPacket` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

First construct the quantitative common peak. Its arithmetic H determines E=symmetricIndices(H). Then interpolate each signed orbit assignment on that same E, using the second certified gap tau. The assignments have magnitude at most one. The resulting packet satisfies the original target values, finite exception annihilation and paired tail bounds.

The gap tau is a finite zero-isolation certificate for the second catalog; it is not silently manufactured from floating-point samples. Likewise the finite catalog must represent the actual zero window completely. No numerical off-line zeta frame is asserted to exist.

**Theorem 1.6 (The exact remaining scalar arithmetic input).**

Lean statement: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.packet_majorant_of_uniform_jets`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.packet_majorant_of_uniform_jets` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This specializes the existing full mixed-majorant theorem and retains every cross term and one analytic multiplicity weight per zero. The quantitative packet constructor supplies the finite jets; the scalar infinite tail is still a number-theoretic input.

The relevant external theorem is Brent, Platt and Trudgian, Accurate estimation of sums over zeros of the Riemann zeta-function, Mathematics of Computation 90 (2021), 2923-2935, Theorem 1, equations (1)-(3), DOI 10.1090/mcom/3652. Specializing its test weight to t^(-4) gives an explicit scalar tail. That theorem is not introduced as an axiom here, and its full zeta-specific proof has not been ported by this source. All new Lean sources remain Candidate without a compiler observation.

## References

- Truth anchor: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.exists_quantitative_finite_unit_peak`
- Truth anchor: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.exists_quantitative_orbitBurnolPacket`
- Truth anchor: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.packet_majorant_of_uniform_jets`
- Truth anchor: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.quantitativePeakRadius`
- Truth anchor: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.quantitative_interpolation_on_finite_indices`
- Truth anchor: `D5/S3/Weil/BurnolGram/QuantitativeFiniteWeilPacket.reflectionNodeSet`
- Dependency: [D5/S3/Weil/BurnolGram/UnitSupportBurnolPacket](UnitSupportBurnolPacket.md)
- Dependency: [D5/S3/Weil/InterpolationJets/QuantitativeEvenInterpolationJets](../InterpolationJets/QuantitativeEvenInterpolationJets.md)
