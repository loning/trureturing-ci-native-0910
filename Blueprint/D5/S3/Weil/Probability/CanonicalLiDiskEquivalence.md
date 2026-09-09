# CanonicalLiDiskEquivalence

## Abstract

The actual canonical Li series has a full-disk convergence criterion equivalent to the standard Riemann hypothesis.

**Theorem 1.1 (Disk points map to the actual right half-plane).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.disk_mobius_re_half`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.disk_mobius_re_half` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The strict real-part inequality is derived from the original complex norm and the positive inverse denominator.

**Theorem 1.2 (RH supplies actual disk nonvanishing).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_xi_disk_ne_zero`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_xi_disk_ne_zero` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The existing xi/nontrivial-zero identity and the standard RiemannHypothesis predicate exclude a zero in the disk image.

**Theorem 1.3 (The existing generator is analytic on the disk).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_li_generator_analytic`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_li_generator_analytic` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

RH is used only in this forward direction to justify the actual logarithmic derivative everywhere in the disk.

**Theorem 1.4 (Globalize the proved canonical Taylor coefficients).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_canonical_li_global_expansion`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_canonical_li_global_expansion` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The merged all-order coefficient identification is inserted into the standard holomorphic Taylor theorem. No coefficients are redefined.

**Theorem 1.5 (Absolute convergence at every radius below one).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_canonical_li_disk_summable`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_canonical_li_disk_summable` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Finite-dimensional absolute summability converts the full complex Taylor series into the original weighted absolute coefficient sum.

**Theorem 1.6 (Close both directions of the canonical criterion).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_iff_canonical_li_disk_summable`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_iff_canonical_li_disk_summable` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The forward proof is combined with the prior analytic-order converse. Neither the arithmetic condition nor RH is asserted unconditionally.

**Theorem 1.7 (The actual full-disk expansion is equivalent to RH).**

Lean statement: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_iff_canonical_li_global_expansion`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_iff_canonical_li_global_expansion` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The conclusion concerns every point of the full disk, not a local germ or a finite coefficient prefix.

## References

- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.disk_mobius_re_half`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_canonical_li_disk_summable`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_canonical_li_global_expansion`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_iff_canonical_li_disk_summable`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_iff_canonical_li_global_expansion`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_li_generator_analytic`
- Truth anchor: `D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.rh_xi_disk_ne_zero`
- Dependency: [D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree](CanonicalLiGrowthZeroFree.md)
