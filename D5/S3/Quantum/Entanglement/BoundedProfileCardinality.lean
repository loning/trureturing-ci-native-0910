/- GID: D5/S3/Quantum/Entanglement/BoundedProfileCardinality
   generality: G
   mirror-B: D5/B/S3/Quantum/Entanglement/BoundedProfileCardinality
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: The finite bounded occupation-profile carrier has the product cardinality required by the stationary minimum formula. -/

import Mathlib.Data.Fintype.Pi
import Mathlib.Data.Fintype.BigOperators
import D5.S1.Ledger.BoundedTimeSlice

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
open scoped BigOperators

namespace D5.S3.Quantum.Entanglement.BoundedProfileCardinality

abbrev Profile {ι : Type*} (a : ι → ℕ) :=
  D5.S1.Ledger.BoundedTimeSlice.TailBox a

/- The source index R is represented by a dependent product of finite intervals.
   This bridge is consumed by the later Gram and rank argument. -/
theorem card_bounded_profiles {ι : Type*} [Fintype ι] [DecidableEq ι]
    (a : ι → ℕ) :
    Fintype.card (Profile a) = ∏ i : ι, (a i + 1) := by
  classical
  rw [Fintype.card_pi]
  simp

end D5.S3.Quantum.Entanglement.BoundedProfileCardinality
