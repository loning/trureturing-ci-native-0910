import Mathlib.Tactic

namespace A398581Probe

def Sol (k x y z : ℤ) : Prop :=
  0 < x ∧ x < y ∧ y < z ∧ 5 * x * y * z = k * (y * z + x * z + x * y)

private theorem basic_bounds {k x y z : ℤ} (h : Sol k x y z) :
    0 < k ∧ k < 5 * x ∧ 5 * x < 3 * k ∧
      0 < (5 * x - k) * y - k * x := by
  rcases h with ⟨hx, hxy, hyz, he⟩
  have hy : 0 < y := by omega
  have hz : 0 < z := by omega
  have hk : 0 < k := by
    by_contra hn
    have := mul_nonpos_of_nonpos_of_nonneg (show k ≤ 0 by omega)
      (show 0 ≤ y * z + x * z + x * y by positivity)
    have : 0 < 5 * x * y * z := by positivity
    nlinarith
  have he' : ((5 * x - k) * y - k * x) * z = k * x * y := by
    nlinarith [he]
  have hd : 0 < (5 * x - k) * y - k * x := by
    have hp : 0 < k * x * y := by positivity
    exact (mul_pos_iff_of_pos_right hz).mp (he' ▸ hp)
  have ha : k < 5 * x := by
    have : 0 < (5 * x - k) * y := by nlinarith [mul_pos hk hx]
    have := (mul_pos_iff_of_pos_right hy).mp this
    omega
  have h1 : x * z < y * z := mul_lt_mul_of_pos_right hxy hz
  have h2 : x * y < y * z := by nlinarith
  have h3 : k * (y * z + x * z + x * y) < k * (3 * (y * z)) :=
    mul_lt_mul_of_pos_left (by omega) hk
  have : 5 * x < 3 * k := by
    have : (5 * x) * (y * z) < (3 * k) * (y * z) := by nlinarith [he]
    exact (mul_lt_mul_iff_of_pos_right (mul_pos hy hz)).mp this
  exact ⟨hk, ha, this, hd⟩

private theorem residual_bound {k x y z d : ℤ} (h : Sol k x y z)
    (hd : 0 < d) (hle : d ≤ (5 * x - k) * y - k * x) :
    d * (5 * x - k) * z ≤ (k * x) * (k * x + d) := by
  have hb := basic_bounds h
  have hz : 0 < z := lt_trans h.1 (lt_trans h.2.1 h.2.2.1)
  have he : ((5 * x - k) * y - k * x) * z = k * x * y := by
    nlinarith [h.2.2.2]
  have hf : ((5 * x - k) * y - k * x) * ((5 * x - k) * z - k * x) =
      (k * x) ^ 2 := by
    linear_combination (5 * x - k) * he
  have hfpos : 0 < (5 * x - k) * z - k * x := by
    have hp : 0 < (k * x) ^ 2 := by have := h.1; have := hb.1; positivity
    exact (mul_pos_iff_of_pos_left hb.2.2.2).mp (hf ▸ hp)
  have := mul_le_mul_of_nonneg_right hle (le_of_lt hfpos)
  nlinarith [hf]

private theorem same_x_antitone {k x y z v w : ℤ}
    (h : Sol k x y z) (h' : Sol k x v w) (hy : y ≤ v) : w ≤ z := by
  have hb := basic_bounds h
  have hz : 0 < z := lt_trans h.1 (lt_trans h.2.1 h.2.2.1)
  have hw : 0 < w := by have := h'.1; have := h'.2.1; have := h'.2.2.1; omega
  have e : ((5 * x - k) * y - k * x) * z = k * x * y := by
    nlinarith [h.2.2.2]
  have e' : ((5 * x - k) * v - k * x) * w = k * x * v := by
    nlinarith [h'.2.2.2]
  have eq : ((5 * x - k) * y - k * x) * (z - w) =
      ((5 * x - k) * w - k * x) * (v - y) := by
    linear_combination e - e'
  have ha : 0 < (5 * x - k) * w - k * x := by
    have eb := (basic_bounds h').2.2.2
    nlinarith [mul_pos (show 0 < 5 * x - k by omega) (show 0 < w - v by have := h'.2.2.1; omega)]
  have : 0 ≤ ((5 * x - k) * y - k * x) * (z - w) := by
    rw [eq]
    exact mul_nonneg (le_of_lt ha) (by omega)
  have := (mul_nonneg_iff_of_pos_left hb.2.2.2).mp this
  omega

#print axioms basic_bounds
#print axioms residual_bound
#print axioms same_x_antitone

end A398581Probe
