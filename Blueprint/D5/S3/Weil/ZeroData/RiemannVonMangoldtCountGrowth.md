# Riemann–von Mangoldt Zero-Count Growth

## Abstract

Riemann-von Mangoldt growth forces the multiplicity-weighted dyadic zero count to diverge.

**Theorem 1.1 (Dyadic zero counts tend to infinity).**

Lean statement: `D5/S3/Weil/ZetaBridge/RiemannVonMangoldtCountGrowth.dyadic_zero_count_tendsto_atTop`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ZetaBridge/RiemannVonMangoldtCountGrowth.dyadic_zero_count_tendsto_atTop` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The proof extracts the exact dyadic main term and logarithmic error from the repository's RiemannVonMangoldt structure, then proves the main term eventually dominates the error.

This is the quantitative source used to force infinitude of the canonical nontrivial-zeta-zero carrier.

## References

- Truth anchor: `D5/S3/Weil/ZetaBridge/RiemannVonMangoldtCountGrowth.dyadic_zero_count_tendsto_atTop`
