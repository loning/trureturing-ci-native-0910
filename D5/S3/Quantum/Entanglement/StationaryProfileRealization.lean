/- GID: D5/S3/Quantum/Entanglement/StationaryProfileRealization
   generality: G
   mirror-B: D5/B/S3/Quantum/Entanglement/StationaryProfileRealization
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Every bounded tail profile with a legal head is realized by an occupation boundary. -/

import D5.S3.Quantum.Entanglement.OccupancyWordSectors

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Quantum.Entanglement.StationaryProfileRealization

noncomputable section

open D5.S1.Ledger.BoundedTimeSlice
open D5.S3.Quantum.Entanglement.OccupancyWordSectors

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- A bounded tail profile and a legal head determine a boundary with those counts. -/
theorem boundary_profile_realization (A : ℕ) (a : I → ℕ) (h : Fin (A + 1))
    (x : TailBox a) :
    ∃ b : Boundary (capacityOccupation A a)
        (h.val + tailSum x),
      b.val.count none = h.val ∧
        ∀ i, b.val.count (some i) = (x i).val := by
  let y : TimeSlice A a (h.val + tailSum x) := ⟨(h, x), rfl⟩
  refine ⟨(boundaryTimeSliceEquiv A a _).symm y, ?_⟩
  have hc := boundary_time_slice_coordinates A a _
    ((boundaryTimeSliceEquiv A a _).symm y)
  rw [Equiv.apply_symm_apply] at hc
  exact ⟨hc.1.symm, fun i => (hc.2 i).symm⟩

end
end D5.S3.Quantum.Entanglement.StationaryProfileRealization
