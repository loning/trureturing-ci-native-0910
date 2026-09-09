import Mathlib

namespace Triage150

theorem endpoint_minimum {E : Type*} [NormedAddCommGroup E] [InnerProductSpace Real E]
    (a b : E) (r s : Real) (hr : 0 < r) (hs : 0 < s) :
    IsLeast (Set.range (fun y : E => norm (y - a)^2 / r + norm (y - b)^2 / s))
      (norm (a - b)^2 / (r + s)) := by
  let c : E := (s / (r + s)) • a + (r / (r + s)) • b
  have hdecomp (y : E) :
      norm (y - a)^2 / r + norm (y - b)^2 / s =
        norm (a - b)^2 / (r + s) + (1/r + 1/s) * norm (y - c)^2 := by
    dsimp [c]
    simp only [norm_sub_sq_real, norm_add_sq_real, inner_add_right,
      real_inner_smul_left, real_inner_smul_right, norm_smul,
      Real.norm_eq_abs, mul_pow, sq_abs]
    field_simp [hr.ne', hs.ne', (add_pos hr hs).ne']
    <;> ring
  constructor
  · refine ⟨c, ?_⟩
    simpa using hdecomp c
  · rintro _ ⟨y, rfl⟩
    change norm (a - b)^2 / (r + s) <= norm (y - a)^2 / r + norm (y - b)^2 / s
    rw [hdecomp y]
    exact le_add_of_nonneg_right (mul_nonneg
      (add_nonneg (one_div_nonneg.mpr hr.le) (one_div_nonneg.mpr hs.le))
      (sq_nonneg _))

#print axioms endpoint_minimum

end Triage150
