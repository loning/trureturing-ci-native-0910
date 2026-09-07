# Explicit Large-Height Zero Count

## Abstract

A numerical large-height window bound for actual zeta zeros, derived from the existing explicit zeta-growth and Jensen theorems.

**Theorem 1.1 (Retain the actual constants in the Jensen disk proof).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitLargeHeightZeroCount.half_count_large_explicit`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ExplicitLargeHeightZeroCount.half_count_large_explicit` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Adapt the existing LocalCount disk argument with its actual growth bound C=20/3 and A=1. The disks retain radii 0.84 and 0.95; their logarithmic ratio is at least 11/95. Bound log(20) by 5. The proof uses actual analytic multiplicities and never obtains an unspecified growth constant or a small-height zero count. The geometric proof follows the Apache-2.0 Zeta23 port identified in the Lean source; no novelty or optimality is claimed for the coefficient 64.

**Theorem 1.2 (Count the actual full critical-strip window).**

Lean statement: `D5/S3/Weil/ZetaBridge/ExplicitLargeHeightZeroCount.zetaZeroConfig_large_count_explicit`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/ExplicitLargeHeightZeroCount.zetaZeroConfig_large_count_explicit` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Reuse the existing same-height reflection halving bound. Zeros on the critical line and their analytic multiplicities are treated by that owner. The interval convention is (t,t+1]. No RH hypothesis, numerical root certificate, or bound at small heights is required. This is a Candidate proof source; compilation and axiom closure are separate evidence.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitLargeHeightZeroCount.half_count_large_explicit`
- Truth anchor: `D5/S3/Weil/ZetaBridge/ExplicitLargeHeightZeroCount.zetaZeroConfig_large_count_explicit`
