# Fragment Truncation Through a Mass Mesh

## Abstract

Truncating small weighted fragments changes a floor readout only through a large deletion or a retained-mass boundary strip.

**Definition 1.1 (Retained fragment measure).**

Lean statement: `D5/S3/PrimeGaps/FragmentMeshTruncation.retainedFragments`

*Formalization.* `D5/S3/PrimeGaps/FragmentMeshTruncation.retainedFragments` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Restrict the actual finite fragment measure to the complement of the positive deletion interval. The entire retained measure remains the state used by the mass readout.

**Definition 1.2 (Deleted weighted mass).**

Lean statement: `D5/S3/PrimeGaps/FragmentMeshTruncation.deletedFragmentMass`

*Formalization.* `D5/S3/PrimeGaps/FragmentMeshTruncation.deletedFragmentMass` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

Read the finite mass in the deletion interval as a real number. Nonnegativity follows from the finite-measure value.

**Theorem 1.3 (Retained and deleted masses partition the original mass).**

Lean statement: `D5/S3/PrimeGaps/FragmentMeshTruncation.retained_deleted_mass`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentMeshTruncation.retained_deleted_mass` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The deletion interval and its complement are a measurable partition. Finite-measure coercions transport the measure identity to real masses.

**Theorem 1.4 (Tail bound for the real-valued deletion).**

Lean statement: `D5/S3/PrimeGaps/FragmentMeshTruncation.deletedFragmentMass_tail`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentMeshTruncation.deletedFragmentMass_tail` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The existing small-fragment tail theorem is reused after proving equality of the real threshold event and its extended-nonnegative-real formulation.

**Theorem 1.5 (A crossed mesh boundary yields an explicit alternative).**

Lean statement: `D5/S3/PrimeGaps/FragmentMeshTruncation.floor_mesh_crossing_alternative`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentMeshTruncation.floor_mesh_crossing_alternative` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A nonnegative increment makes the natural floor index monotone. If the index changes, the new mass reaches the next boundary. An increment smaller than the chosen threshold therefore requires the original mass to lie within that threshold of the boundary.

**Theorem 1.6 (The actual mesh error splits into a tail and a boundary probability).**

Lean statement: `D5/S3/PrimeGaps/FragmentMeshTruncation.fragment_mesh_change_probability`

*Proof.* Machine-checked in Lean as `D5/S3/PrimeGaps/FragmentMeshTruncation.fragment_mesh_change_probability` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Apply the deterministic alternative to the retained and deleted masses, then use event inclusion and the union bound. The boundary-strip probability stays explicitly in the conclusion. No density bound, anti-concentration estimate or numerical integral enclosure is assumed to have been proved.

## References

- Truth anchor: `D5/S3/PrimeGaps/FragmentMeshTruncation.deletedFragmentMass`
- Truth anchor: `D5/S3/PrimeGaps/FragmentMeshTruncation.deletedFragmentMass_tail`
- Truth anchor: `D5/S3/PrimeGaps/FragmentMeshTruncation.floor_mesh_crossing_alternative`
- Truth anchor: `D5/S3/PrimeGaps/FragmentMeshTruncation.fragment_mesh_change_probability`
- Truth anchor: `D5/S3/PrimeGaps/FragmentMeshTruncation.retainedFragments`
- Truth anchor: `D5/S3/PrimeGaps/FragmentMeshTruncation.retained_deleted_mass`
- Dependency: [D5/S3/PrimeGaps/FragmentLaw](FragmentLaw.md)
