# Finite-Data Negative Weil Certificates

## Abstract

Actual multi-orbit negative Weil certificates with the infinite scalar tail discharged analytically and all remaining budgets finite.

**Definition 1.1 (Fully specified rational error coefficient).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilFiniteDataNegativeCertificate.rationalComputedWeilBudget`

*Formalization.* `D5/S3/Weil/BurnolGram/WeilFiniteDataNegativeCertificate.rationalComputedWeilBudget` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Reuse the existing Cauchy coefficient and the newly proved rational tail. T>=5 and finite cutoff containment are certified in the soundness theorem; the function itself does not search for zeta zeros.

**Theorem 1.2 (Actual Gram certificate without a supplied infinite tail).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilFiniteDataNegativeCertificate.computed_packet_full_gram_margin`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilFiniteDataNegativeCertificate.computed_packet_full_gram_margin` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The new analytic theorem proves both summability and the scalar tail bound. The existing all-cross-term Cauchy estimate and exact integer depth theorem are then applied to the actual full Weil Gram. No arbitrary matrix replaces the zeta form.

**Theorem 1.3 (Construct the whole negative family from finite geometry).**

Lean statement: `D5/S3/Weil/BurnolGram/WeilFiniteDataNegativeCertificate.finite_data_sparse_negative_certificate`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/WeilFiniteDataNegativeCertificate.finite_data_sparse_negative_certificate` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Reuse sparse_packet_computed_support_margin_and_inertia, but discharge both of its infinite spectral premises using the actual rational count-to-tail theorem. The peak, killers and their finite jets are constructed by the existing sparse owner. Finite nodal data and actual frame validity remain inputs; no off-line zero is asserted to exist. The cutoff is never enlarged after constructing the packet. This closes an analytic certificate component, not arithmetic positivity, growing-scale Xi convergence or RH.

## References

- Truth anchor: `D5/S3/Weil/BurnolGram/WeilFiniteDataNegativeCertificate.computed_packet_full_gram_margin`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilFiniteDataNegativeCertificate.finite_data_sparse_negative_certificate`
- Truth anchor: `D5/S3/Weil/BurnolGram/WeilFiniteDataNegativeCertificate.rationalComputedWeilBudget`
- Dependency: [D5/S3/Weil/BurnolGram/ExplicitWeilFourthMomentTail](ExplicitWeilFourthMomentTail.md)
- Dependency: [D5/S3/Weil/BurnolGram/SparseBurnolPacketJets](SparseBurnolPacketJets.md)
