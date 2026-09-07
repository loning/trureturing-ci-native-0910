# Finite mirror Krein Gram inertia

## Abstract

The actual mirror-Krein Gram matrix of the finite odd basis is minus two times identity and has exact negative index kappa_T.

**Theorem 1.1 (The actual odd Gram matrix is -2 I).**

Lean statement: `D5/S3/Midline/Cayley/FiniteMirrorKreinGramInertia.finiteMirrorOddKreinGram_eq`

*Proof.* Machine-checked in Lean as `D5/S3/Midline/Cayley/FiniteMirrorKreinGramInertia.finiteMirrorOddKreinGram_eq` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The matrix entries are computed from genuine odd vectors inside the multiplicity-expanded zero Hilbert space and the actual mirror Krein form.

**Theorem 1.2 (The actual Gram negative index equals the mirror-orbit multiplicity count).**

Lean statement: `D5/S3/Midline/Cayley/FiniteMirrorKreinGramInertia.finiteMirrorOddKreinGram_negIndex`

*Proof.* Machine-checked in Lean as `D5/S3/Midline/Cayley/FiniteMirrorKreinGramInertia.finiteMirrorOddKreinGram_negIndex` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

This is a spectral inertia theorem for a concrete Hermitian Gram matrix, not a definition of an abstract negative dimension.

## References

- Truth anchor: `D5/S3/Midline/Cayley/FiniteMirrorKreinGramInertia.finiteMirrorOddKreinGram_eq`
- Truth anchor: `D5/S3/Midline/Cayley/FiniteMirrorKreinGramInertia.finiteMirrorOddKreinGram_negIndex`
- Dependency: [D5/S3/Midline/Cayley/CanonicalZetaMirrorEvenOddDecomposition](CanonicalZetaMirrorEvenOddDecomposition.md)
- Dependency: [D5/S3/Midline/Cayley/FiniteMirrorKreinIndex](FiniteMirrorKreinIndex.md)
- Dependency: [D5/S3/SpectralTopology/FiniteSpectralLocalizer](../../SpectralTopology/FiniteSpectralLocalizer.md)
