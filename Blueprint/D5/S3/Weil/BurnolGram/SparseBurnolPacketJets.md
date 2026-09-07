# SparseBurnolPacketJets

## Abstract

Quantitative bounds for actual multi-orbit Weil tests, with explicit finite geometry and scalar spectral-tail premises.

**Definition 1.1 (Actual exception-only indices).**

Lean statement: `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.sparsePacketExceptions`

*Formalization.* `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.sparsePacketExceptions` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

The existing quantitativePeakRadius is reused. The exceptional window is fixed after constructing the peak; it is independent of the later killer smoothing order.

**Theorem 1.2 (Construct the actual packet from finite geometry).**

Lean statement: `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.exists_sparse_burnol_packet_with_jets`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.exists_sparse_burnol_packet_with_jets` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The existing dense target theorem constructs the unit peak. Its two jet budgets imply the existing explicit cutoff. Apply SparseEvenInterpolationJets to each signed target assignment and to the actual exception-only indices. Repeated exception nodes are allowed. No supplied packet, bump derivative, peak tail or existence-of-threshold premise is used. The finite geometric inequalities still require certified data.

**Theorem 1.3 (Computed support, full margin and exact inertia).**

Lean statement: `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.sparse_packet_computed_support_margin_and_inertia`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.sparse_packet_computed_support_margin_and_inertia` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the packet constructor to discharge all support and jet premises of the direct Cauchy remainder theorem. The exact integer selector supplies the error budget at every later depth. Reuse the actual full Gram and its spectral inertia theorem. The positive scalar zero-tail estimate and its summability are explicit analytic premises; a literature citation is not substituted for their proofs. No off-line zero or RH is asserted.

**Definition 1.4 (Rational cutoff evaluation).**

Lean statement: `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.rationalSparsePacketCutoff`

*Formalization.* `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.rationalSparsePacketCutoff` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

This arithmetic uses only rational operations and natural powers. It evaluates the existing real cutoff rather than defining another analytic cutoff.

**Theorem 1.5 (Exact cutoff semantics).**

Lean statement: `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.rationalSparsePacketCutoff_cast`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.rationalSparsePacketCutoff_cast` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Use the existing rational interpolation-jet cast lemma; no numerical approximation or real logarithm enters.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.exists_sparse_burnol_packet_with_jets`
- Truth anchor: `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.rationalSparsePacketCutoff`
- Truth anchor: `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.rationalSparsePacketCutoff_cast`
- Truth anchor: `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.sparsePacketExceptions`
- Truth anchor: `D5/S3/Weil/ZetaBridge/SparseBurnolPacketJets.sparse_packet_computed_support_margin_and_inertia`
- Dependency: [D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets](../TestFunctions/SparseEvenInterpolationJets.md)
- Dependency: [D5/S3/Weil/ZetaBridge/QuantitativeFiniteWeilPacket](QuantitativeFiniteWeilPacket.md)
- Dependency: [D5/S3/Weil/ZetaBridge/WeilBurnolCauchyTailBudget](WeilBurnolCauchyTailBudget.md)
