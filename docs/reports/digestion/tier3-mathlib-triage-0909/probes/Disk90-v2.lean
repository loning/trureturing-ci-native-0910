import Mathlib

namespace Triage90

theorem reflected_pair (m x delta u : Real) (hm : 0 < m) (hx : 0 < x)
    (hleft : Ne ((x - delta)^2 + u^2) 0)
    (hright : Ne ((x + delta)^2 + u^2) 0) :
    (m * ((x - delta) / ((x - delta)^2 + u^2) +
          (x + delta) / ((x + delta)^2 + u^2)) =
      2*m*x*(x^2 + u^2 - delta^2) /
        (((x - delta)^2 + u^2) * ((x + delta)^2 + u^2)))
    /\
    (m * ((x - delta) / ((x - delta)^2 + u^2) +
          (x + delta) / ((x + delta)^2 + u^2)) < 0
      <-> x^2 + u^2 < delta^2) := by
  have hl : 0 < (x - delta)^2 + u^2 :=
    lt_of_le_of_ne (add_nonneg (sq_nonneg _) (sq_nonneg _)) hleft.symm
  have hr : 0 < (x + delta)^2 + u^2 :=
    lt_of_le_of_ne (add_nonneg (sq_nonneg _) (sq_nonneg _)) hright.symm
  have heq : m * ((x - delta) / ((x - delta)^2 + u^2) +
          (x + delta) / ((x + delta)^2 + u^2)) =
      2*m*x*(x^2 + u^2 - delta^2) /
        (((x - delta)^2 + u^2) * ((x + delta)^2 + u^2)) := by
    field_simp
    ring
  refine And.intro heq ?_
  rw [heq, div_lt_iff₀ (mul_pos hl hr), zero_mul]
  have hf : 0 < 2*m*x := mul_pos (mul_pos (by norm_num) hm) hx
  simpa only [mul_zero, sub_neg] using
    (mul_lt_mul_iff_right₀ hf : 2*m*x*(x^2 + u^2 - delta^2) < 2*m*x*0
      <-> x^2 + u^2 - delta^2 < 0)

#print axioms reflected_pair

end Triage90
