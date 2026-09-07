# Finite Even Weil Odd Interpolation

## Abstract

Finite sign-separated conjugate spectral pairs admit an explicit linear synthesis by scalar even Weil tests, with an exact multiplicity-weighted negative Gram matrix.

**Theorem 1.1 (Reduced odd evaluation has an explicit finite right inverse).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteEvenWeilOddInterpolation.finite_even_weil_odd_interpolation_spec`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteEvenWeilOddInterpolation.finite_even_weil_odd_interpolation_spec` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A frame records finitely many off-line nonreal orbit channels, a two-node presentation for each conjugate spectral pair, and the exact sign-separation hypothesis required by the frozen even Paley-Wiener interpolation theorem.

Chosen coordinate interpolants are combined by an explicit bundled finite linear-combination constructor. Fourier-Laplace linearity proves that this synthesis is a right inverse to the reduced odd readout, rather than merely a collection of unrelated existential witnesses.

**Theorem 1.2 (The observable odd Gram index equals the number of independent orbit channels).**

Lean statement: `D5/S3/Weil/BurnolGram/FiniteEvenWeilOddInterpolation.frameOddGram_negIndex`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/BurnolGram/FiniteEvenWeilOddInterpolation.frameOddGram_negIndex` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The basis Gram is exactly minus four times the positive analytic-multiplicity diagonal. Consequently its negative is positive definite and the repository spectral inertia owner computes one negative direction per independently interpolated orbit channel. Multiplicity changes the weight and strict margin, not the scalar observer dimension.

## References

- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteEvenWeilOddInterpolation.finite_even_weil_odd_interpolation_spec`
- Truth anchor: `D5/S3/Weil/BurnolGram/FiniteEvenWeilOddInterpolation.frameOddGram_negIndex`
- Dependency: [D5/S3/SpectralTopology/FiniteSpectralLocalizer](../../SpectralTopology/FiniteSpectralLocalizer.md)
- Dependency: [D5/S3/Weil/BurnolGram/FiniteMirrorReducedWeilFactorization](FiniteMirrorReducedWeilFactorization.md)
- Dependency: [D5/S3/Weil/TestFunctions/EvenTestFunctionFiniteInterpolation](../TestFunctions/EvenTestFunctionFiniteInterpolation.md)
