---
bibkey: wilde2017quantum
authors: Mark M. Wilde
year: 2017
title: Quantum Information Theory
doi: 10.1017/9781316809976
claim: The trace norm is nonnegative, homogeneous, and subadditive; for positive semidefinite matrices it equals the trace, and half the trace norm of a difference of density matrices lies in the unit interval.
strata_touched:
  - D5/S3/Quantum/Foundation/FiniteTraceDistance
license: citation-only
triage: anchor
---

# Quantum Information Theory

This note cites the second edition published by Cambridge University Press.
The citation year 2017 follows the DOI record's online publication date,
2017-02-16; the same record lists print publication on 2016-11-02.
The inspected text is Wilde's linked prepublication draft, *From Classical
to Quantum Shannon Theory*, arXiv:1106.1445v8, revised 2019-07-14 and dated
2019-07-16 on its title page. The locators below refer to that version's
printed pages, which equal its one-based PDF page indices. Final Cambridge
pagination has not been separately checked.

## Verified locator

- DOI: https://doi.org/10.1017/9781316809976
- DOI metadata: https://api.crossref.org/works/10.1017/9781316809976
- Version and DOI link: https://arxiv.org/abs/1106.1445v8
- Inspected text: https://arxiv.org/pdf/1106.1445v8
- Accessed 2026-09-08. The title, author, second-edition identity, DOI link,
  and the following pages were checked.

| Retained declaration | Mathematical locator in v8 | Scope of the attestation |
| --- | --- | --- |
| `traceNorm` | Definition 9.1.1, equation (9.1), p. 250 | Trace of the positive square root of the Gram operator; the real-part operation in Lean returns that real trace. |
| `traceNorm_neg` | Property 9.1.2, equation (9.12), p. 251 | Scalar homogeneity specialized to the scalar -1. |
| `traceNorm_nonneg` | Property 9.1.1, equation (9.10), p. 251 | Nonnegativity of the trace norm. |
| `traceNorm_add_le` | Property 9.1.3, equation (9.13), p. 251; Exercise 9.1.1, p. 252 | The property is stated for rectangular operators. The retained Lean theorem is square-complex; p. 252 gives the square-operator exercise and variational characterization, not a checked proof for every rectangular case. |
| `traceNorm_of_posSemidef` | Unnumbered Hermitian-eigenvalue paragraph after (9.9), p. 251; Definition 3.3.1 and (3.67), p. 83; positive semidefiniteness in (4.32), p. 124 | The nonnegative-eigenvalue specialization gives the PSD trace equality. No independently verified standalone numbered PSD theorem is attributed. |

Definition 9.1.2 and equations (9.21)--(9.23), p. 253, state the unnormalized
density-distance interval [0,2] and explicitly describe its half-normalized
interval [0,1]. The canonical density-state and channel adapters and their
repository proofs are separate derivations.

## Scalar And Empty-Type Scope

The inspected literature uses complex operators. Real matrices are the
real-entry specialization: conjugate transpose becomes transpose, and the
Gram operator, nonnegative spectral square root, and trace agree. The
retained source expresses the definition, negation, nonnegativity, and PSD
equality through Mathlib's `RCLike` interface for the real and complex cases.
Its PSD equality coerces the real trace norm into the scalar field before
equating it to the matrix trace. The retained triangle theorem is only for
square complex matrices; no broader Lean triangle theorem is claimed.

Those retained signatures assume finite index types without `Nonempty`.
For an empty row or column type the rectangular matrix has no entries and
its trace norm is zero; for an empty square type the PSD trace identity
equates two empty sums. This is the degenerate extension supplied by the
retained Lean statements and their proofs, not an explicit empty-type
discussion in the book. Canonical density states still require trace one.

## Retained Lean Source

The five statements retain Alex Meiburg's Physlib code at immutable revision
`6a09b2d1761a0d4430083045a247eb121d8da260`:

https://github.com/leanprover-community/physlib/blob/6a09b2d1761a0d4430083045a247eb121d8da260/QuantumInfo/ForMathlib/MatrixNorm/TraceNorm.lean

The declaration mapping is `Matrix.traceNorm`, `Matrix.traceNorm_neg`,
`Matrix.traceNorm_nonneg`, `Matrix.traceNorm_add_le`, and
`Matrix.PosSemidef.traceNorm_eq_trace`, respectively. The owner also retains
their necessary technical declarations from `Matrix.lean`, `Isometry.lean`,
and `HermitianMat/Unitary.lean`. Its copyright and full Apache-2.0 license
remain with the Lean source; the inspected immutable upstream tree contains
no NOTICE file. The selected declarations' checked axiom closures do not
certify the whole Physlib project. Retention ends when equivalent
declarations exist in this repository's own pinned Mathlib, at which point
direct imports replace the retained source.

This is an authored citation note. It incorporates no text or images from
the draft PDF. The draft identifies its Creative Commons
Attribution-NonCommercial-ShareAlike 3.0 license and personal-use restriction;
those terms are separate from the retained Lean code's Apache-2.0 license.
