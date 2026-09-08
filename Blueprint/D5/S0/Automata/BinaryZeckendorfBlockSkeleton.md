# Binary Zeckendorf First-Return Skeleton

## Abstract

Binary Zeckendorf words admit a first-return block code, and transient typed-DFAO states collapse to output-and-return signatures without increasing state count.

**Theorem 1.1 (The return-block code is uniquely decodable).**

Lean statement: `D5/S0/Automata/BinaryZeckendorfBlockSkeleton.compressLegalWord_expand`

*Proof.* Machine-checked in Lean as `D5/S0/Automata/BinaryZeckendorfBlockSkeleton.compressLegalWord_expand` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Every legal binary Zeckendorf word factors into the first-return blocks 0 and 10, followed by either no terminal symbol or one final 1. Expansion followed by legal-word compression recovers the original code.

**Theorem 1.2 (A transient signature determines every continuation).**

Lean statement: `D5/S0/Automata/BinaryZeckendorfBlockSkeleton.same_oneSignature_evalFromState`

*Proof.* Machine-checked in Lean as `D5/S0/Automata/BinaryZeckendorfBlockSkeleton.same_oneSignature_evalFromState` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

A state over the previous-one base state has no legal one transition. Its current output and optional zero-successor therefore determine its evaluation on every continuation, including undefined continuations.

**Theorem 1.3 (Canonical signature reconstruction preserves behaviour and does not add states).**

Lean statement: `D5/S0/Automata/BinaryZeckendorfBlockSkeleton.canonical_extract_behavior_and_cardinality`

*Proof.* Machine-checked in Lean as `D5/S0/Automata/BinaryZeckendorfBlockSkeleton.canonical_extract_behavior_and_cardinality` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The recurrent fiber is retained verbatim, while one canonical transient state is introduced for each distinct output-and-zero-successor signature used by a recurrent one transition.

The reconstructed typed partial DFAO agrees with the original machine on every legal block code. An explicit injection from canonical states into original states proves that canonicalization never increases finite cardinality.

## References

- Truth anchor: `D5/S0/Automata/BinaryZeckendorfBlockSkeleton.canonical_extract_behavior_and_cardinality`
- Truth anchor: `D5/S0/Automata/BinaryZeckendorfBlockSkeleton.compressLegalWord_expand`
- Truth anchor: `D5/S0/Automata/BinaryZeckendorfBlockSkeleton.same_oneSignature_evalFromState`
- Dependency: [D5/S0/Automata/TypedPartialDFAOOverBase](TypedPartialDFAOOverBase.md)
