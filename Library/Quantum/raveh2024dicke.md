---
bibkey: raveh2024dicke
authors: David Raveh and Rafael I. Nepomechie
year: 2024
title: Dicke states as matrix product states
doi: 10.1103/PhysRevA.110.052438
claim: Fixed-occupation uniform qudit words have orthonormal occupation sectors across each cut, positive multinomial-ratio Schmidt weights, rank equal to the feasible-sector count, and exact sequential occupation-isometry preparation.
strata_touched:
  - D5/S3/Quantum/Entanglement/OccupancyWordSectors
  - D5/S3/Quantum/Entanglement/CoherentHistorySchmidt
  - D5/S3/Quantum/Entanglement/SequentialOccupationHistory
license: citation-only
triage: anchor
---

# Dicke states as matrix product states

## Verified locator

DOI 10.1103/PhysRevA.110.052438 resolves to the Physical Review A article,
volume 110, article 052438, published 26 November 2024. Both the DOI CSL
metadata and https://arxiv.org/html/2408.04729v2 were retrieved successfully
on 7 September 2026. Section 4 treats qudit Dicke states, defined by uniform
superposition of permutations of a multiset. It gives normalized sector
vectors, the product of prefix and suffix multinomial counts divided by
the full multinomial count, and the minimal MPS bond dimension.

## Delivered W foundation

The formal subset of this delivery is OccupancyWordSectors (W). It uses actual
words Fin n -> alphabet and multiset occupations. Multiplicity is the
cardinality of the actual word fiber; its multinomial and factorial formulas
are proved from actual word counting. The sector Gram identity proves
normalization and disjoint-support orthogonality. Boundary contains all
feasible submultisets of the specified cut length. A restriction of Mathlib's
existing Sym.equivNatSumOfFintype identifies these actual Boundary carriers
with the existing bounded TimeSlice coordinates and transports their counts.
This W layer supplies a reusable foundation, with no whole-atom coverage claim.

## C/S decomposition and sequential-chain mapping

CoherentHistorySchmidt (C) and SequentialOccupationHistory (S) extend the frozen
OccupancyWordSectors foundation. C proves the arbitrary-cut normalized
coefficient decomposition, positive binomial weights, and rank of the actual
word coefficient matrix. S constructs occupation transitions and contractions,
derives cut factorization for arbitrary finite algebraic chains, and proves
that the least achievable maximum bond is attained. The complete coherent-history
atom remains open because a pure-state circuit on one fixed physical register
has not been constructed.

C's cut coefficient matrix has the constant inverse-square-root amplitude
on legal concatenations and zero elsewhere. The actual sector cardinality is
identified with the factorial multinomial, and this bridge gives the product
of coordinate binomial coefficients divided by the binomial cut count as
the squared Schmidt coefficient. The actual 5040 rank sequence and
unique maximum 12 at cut 4 then reuse BoundedTimeSlice, without a new count table.

`schmidt_coefficient_sq_binomial` consumes the actual-cardinality theorem and
Mathlib's `Nat.choose_mul_factorial_mul_factorial` on every coordinate and cut.
`schmidt_coefficient_eq_sqrt_binomial` uses the positive coefficient to select
the nonnegative root. These algebraic consequences introduce no new model premise.

On the frozen W base, C's counting and two Gram formulas are companions of the
coefficient construction; they do not supply a new W-count/W-gram first-freeze
witness. Its support factorization remains live, and representative-word rows
and columns produce the lower-bound diagonal minor. S's Gram, word contraction
and arbitrary-chain cut induction are separate live constructions. The channel
consumes Gram but is not a premise of the exact occupation preparation or of
the attained-minimum theorem.

### Sequential construction mapping

Section 4 equations 4.7-4.10 were inspected in the retained HTML on 8 September
2026. Set paper l=t+1, total occupation k=a, prefix occupation a=b, and
emitted label m=i. Equation 4.9 supports exactly c=b+{i}; equation 4.10 gives
gamma squared as M(a-b-{i})/M(a-b), equal to the remaining count divided by
the remaining length. The positive square root gives `nextStep` on the actual
Boundary carriers. Its identity Gram proof uses unique extension support,
singleton cancellation, and the sum of remaining counts. A singleton Kraus
family reuses the repository's canonical quantum channel API.

Equation 4.8 is implemented by `contraction`, which recursively multiplies
step entries and sums over each intervening Boundary, with a terminal
occupation basis-vector cap. `contraction_eq_sector` proves the stronger
suffix equality by induction using `multiplicity_erase_mul`, the public
actual-word consequence of the already ported erasure recurrence.
`history_sequential_preparation` identifies the full contraction with the
uniform word state in equation 4.1. The actual FiniteChain contraction supplies
the factorization for every exact finite algebraic chain, with arbitrary
complex caps. Taking the finite maximum of actual cut-bond cardinalities
gives universal necessity. The occupationChain with occupationInitial attains
the target boundary maximum and prepares the state exactly; IsLeast of actual
achievable maximum-bond values records both claims together. Its concrete
5040 minimum is 12, by the general proof and the transported landed maximum.

The attaining construction has variable memory carriers and actual isometric
steps. This proves finite MPS and variable-bond sequential-isometry optimality.
Compatible embeddings and unitary extensions on a single fixed 12-dimensional
physical register remain unconstructed. No time-homogeneous memory claim or
identification with the separate 16-dimensional prediction model is made.

## Lean prerequisite provenance

The normalized finite-class indicator argument is adapted from QuAIR/Lean-QIT,
QIT/Symmetry/SymmetricSubspace.lean at immutable commit
c1d59b133b56e3d79efb11ee46a728d290f761f5, specifically
tensorPowerProfileUnitVector_trace_rankOne_eq_one and
tensorPowerProfileUnitVector_inner. Copyright (c) 2026 QuAIR; authors QuAIR
Team. The full Apache-2.0 license appears below. The upstream repository has
no NOTICE file anywhere in its complete recursive tree.
The adaptation changes recursive tensor words and realized-profile subtypes
to Fin-indexed words, multisets, and explicit length proofs.

The upstream pins Lean v4.30.0 and Mathlib
c5ea00351c28e24afc9f0f84379aa41082b1188f, incompatible with this repository's
v4.33.0 and db584cd6d46c92f209a44c0f1c829460d327499d. Retire the adapted
proofs when this repository's pinned Mathlib contains equivalent normalized
finite-fiber indicator declarations, replacing them with direct imports.
These are known results used as prerequisites, with no novelty claim.

The counting proof is a narrow A17.2 adaptation of the same immutable source:
`tensorPowerProfileClass_succ_card` becomes `multiplicity_succ`;
`tensorPowerProfile_tail_factorial_prod_mul` becomes `erase_factorial_prod_mul`;
`tensorPowerProfile_multinomial_tail_mul_length` becomes `multinomial_erase_mul`;
`tensorPowerProfile_multinomial_succ_recurrence` becomes `multinomial_succ`;
`tensorPowerProfileClass_card_eq_multinomial` becomes `sector_words_card_multinomial`.
These source declarations occupy lines 501-744. The proof keeps their induction
on word length, head/tail recurrence, and positive factorial cancellation.
The carrier adaptation replaces recursive tensor words with Fin-indexed words
(upstream QIT/Util/TensorPower.lean supplies precisely this Fin.cons equivalence),
and replaces realized profiles and tailAfterHead with multisets and erase.
Pinned Multiset count/card/erase lemmas discharge the profile infrastructure.
`multiplicity_eq_factorial` unfolds the resulting Mathlib multinomial.

Reverified immutable source SHA256:
72c5267dbd2cfebd6f68adec837ed8dc2ee1985926c053d34d1e06597cb47108.
LICENSE SHA256:
f3af7f9a7b5239d74bdc8bb43047820c1370caad7bd361777eda6ecca6bd874b.
The GitHub recursive tree query returned the same commit, truncated=false,
and no NOTICE paths. Copyright and license are retained below. Retire the
counting adaptation when this repository's pinned Mathlib provides equivalent
fixed-occupation actual-word cardinality declarations, replacing it by imports.

## Upstream Apache-2.0 license

```text
                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright 2026 QuAIR

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```
