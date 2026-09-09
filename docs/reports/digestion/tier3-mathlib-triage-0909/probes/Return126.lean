import Mathlib

namespace Triage126

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace Complex E]

noncomputable def history (U : E ≃ₗᵢ[Complex] E) (v : E) (n : Nat) : E :=
  (fun w => U w - inner Complex v (U w) • v)^[n] v

theorem step_balance (U : E ≃ₗᵢ[Complex] E) (v : E) (hv : norm v = 1) (n : Nat) :
    norm (inner Complex v (U (history U v n)))^2 =
      norm (history U v n)^2 - norm (history U v (n+1))^2 := by
  have hp := Submodule.norm_sq_eq_add_norm_sq_starProjection
    (U (history U v n)) (Submodule.span Complex {v})
  rw [Submodule.starProjection_orthogonal] at hp
  simp only [ContinuousLinearMap.sub_apply, ContinuousLinearMap.id_apply,
    Submodule.starProjection_unit_singleton Complex hv, norm_smul,
    hv, mul_one, U.norm_map] at hp
  have hrec := Function.iterate_succ_apply'
    (fun w => U w - inner Complex v (U w) • v) n v
  change history U v (n+1) =
    U (history U v n) - inner Complex v (U (history U v n)) • v at hrec
  rw [← hrec] at hp
  linarith only [hp]

theorem conservation (U : E ≃ₗᵢ[Complex] E) (v : E) (hv : norm v = 1) (N : Nat) :
    (Finset.range N).sum (fun n => norm (inner Complex v (U (history U v n)))^2) +
      norm (history U v N)^2 = 1 := by
  simp_rw [step_balance U v hv]
  rw [Finset.sum_range_sub']
  simp [history, hv]

#print axioms step_balance
#print axioms conservation

end Triage126
