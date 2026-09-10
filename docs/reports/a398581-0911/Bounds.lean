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
    (_hd : 0 < d) (hle : d ≤ (5 * x - k) * y - k * x) :
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

private theorem far_bound {k x y z : ℤ} (h : Sol k x y z)
    (hfar : 2 * k ≤ 5 * x) : 25 * z ≤ 2 * k * (2 * k + 5) := by
  have hb := basic_bounds h
  have hx := h.1
  have hk := hb.1
  have hy := h.2.1
  let a := 5 * x - k
  let b := k * x
  have ha : 0 < a := by dsimp [a]; omega
  have hbpos : 0 < b := mul_pos hb.1 hx
  have hd : a ≤ (5 * x - k) * y - k * x := by
    have hp := mul_nonneg (show 0 ≤ 5 * x - 2 * k by omega) (le_of_lt hx)
    have hp' := mul_nonneg (le_of_lt ha) (show 0 ≤ y - x - 1 by omega)
    dsimp [a] at *
    nlinarith
  have bound : a * a * z ≤ b * (b + a) := residual_bound h ha hd
  have ht : 0 ≤ 2 * k * a - 5 * b := by
    have := mul_nonneg (le_of_lt hb.1) (show 0 ≤ 5 * x - 2 * k by omega)
    dsimp [a, b]
    nlinarith
  have hp := mul_nonneg ht
    (show 0 ≤ 2 * k * a + 5 * b + 5 * a by positivity)
  have ha2 : 0 < a * a := mul_pos ha ha
  nlinarith

private theorem near_bound {k x y z l d W : ℤ} (h : Sol k x y z)
    (hl : k < 5 * l) (hlx : l ≤ x) (hx : 5 * x ≤ 2 * k)
    (hd : 0 < d) (he : d ≤ (5 * x - k) * y - k * x)
    (hend : (k * l) * (k * l + d) ≤ d * (5 * l - k) * W) : z ≤ W := by
  have hb := basic_bounds h
  have hlpos : 0 < l := by omega
  have ax : 0 < 5 * x - k := by omega
  have al : 0 < 5 * l - k := by omega
  have hr := residual_bound h hd he
  have ht : 0 ≤ k * (x + l) - 5 * x * l + d := by
    have := mul_nonneg (show 0 ≤ 2 * k - 5 * x by omega) (le_of_lt hlpos)
    have := mul_nonneg (le_of_lt hb.1) (show 0 ≤ x - l by omega)
    nlinarith
  have hp := mul_nonneg (mul_nonneg (sq_nonneg k) (show 0 ≤ x - l by omega)) ht
  have hm := mul_le_mul_of_nonneg_right hend (le_of_lt ax)
  have hn := mul_le_mul_of_nonneg_right hr (le_of_lt al)
  have hc : 0 < d * (5 * l - k) * (5 * x - k) := by positivity
  have hc' : d * (5 * l - k) * (5 * x - k) * z ≤
      d * (5 * l - k) * (5 * x - k) * W := by
    nlinarith only [hp, hm, hn]
  exact (mul_le_mul_iff_of_pos_left hc).mp hc'

private theorem residual_eight_gap {k x y z : ℤ} (h : Sol k x y z)
    (ha : 5 * x - k = 8) : 2 ≤ (5 * x - k) * y - k * x := by
  have hd := (basic_bounds h).2.2.2
  by_contra hbad
  have he : (5 * x - k) * y - k * x = 1 := by omega
  have he' : k ^ 2 + 5 = 8 * (5 * y - k) := by nlinarith
  have hm : k ^ 2 % 8 = 3 := by omega
  have ht : k ^ 2 % 8 = ((k % 8) * (k % 8)) % 8 := by
    simpa [pow_two] using Int.mul_emod k k 8
  have hlo := Int.emod_nonneg k (show (8 : ℤ) ≠ 0 by norm_num)
  have hhi := Int.emod_lt_of_pos k (show (0 : ℤ) < 8 by norm_num)
  interval_cases hr : k % 8 <;> norm_num [hr, hm] at ht

private theorem later_zero {q x y z : ℤ} (hq : 1 ≤ q) (h : Sol (5 * q) x y z)
    (hl : q + 2 ≤ x) : z ≤ q * (q + 1) * (q * (q + 1) + 1) := by
  let W := q * (q + 1) * (q * (q + 1) + 1)
  have hf : 2 * (5 * q) * (2 * (5 * q) + 5) ≤ 25 * W := by
    dsimp [W]
    obtain ⟨t, ht, rfl⟩ : ∃ t : ℤ, 0 ≤ t ∧ q = t + 1 := ⟨q - 1, by omega, by ring⟩
    apply le_of_sub_nonneg
    ring_nf
    positivity
  by_cases hfar : 2 * (5 * q) ≤ 5 * x
  · have := far_bound h hfar
    dsimp [W] at hf
    omega
  · apply near_bound h (l := q + 2) (d := 5) (by omega) hl (by omega) (by norm_num)
    · have hd := (basic_bounds h).2.2.2
      have he : (5 * x - 5 * q) * y - 5 * q * x = 5 * ((x - q) * y - q * x) := by ring
      omega
    · obtain ⟨t, ht, rfl⟩ : ∃ t : ℤ, 0 ≤ t ∧ q = t + 1 := ⟨q - 1, by omega, by ring⟩
      apply le_of_sub_nonneg
      ring_nf
      positivity

private theorem later_three {q x y z W : ℤ} (hq : 2 ≤ q)
    (h : Sol (5 * q + 3) x y z) (hl : q + 2 ≤ x)
    (hW : ((5 * q + 3) * (q + 1)) * ((5 * q + 3) * (q + 1) + 2) ≤ 4 * W) : z ≤ W := by
  have hf : 8 * (5 * q + 3) * (2 * (5 * q + 3) + 5) ≤
      25 * (((5 * q + 3) * (q + 1)) * ((5 * q + 3) * (q + 1) + 2)) := by
    obtain ⟨t, ht, rfl⟩ : ∃ t : ℤ, 0 ≤ t ∧ q = t + 2 := ⟨q - 2, by omega, by ring⟩
    apply le_of_sub_nonneg
    ring_nf
    positivity
  by_cases hfar : 2 * (5 * q + 3) ≤ 5 * x
  · have := far_bound h hfar
    nlinarith
  · apply near_bound h (l := q + 2) (d := 1) (by omega) hl (by omega) (by norm_num)
    · have := (basic_bounds h).2.2.2; omega
    · have hend : 4 * (((5 * q + 3) * (q + 2)) * ((5 * q + 3) * (q + 2) + 1)) ≤
          7 * (((5 * q + 3) * (q + 1)) * ((5 * q + 3) * (q + 1) + 2)) := by
        obtain ⟨t, ht, rfl⟩ : ∃ t : ℤ, 0 ≤ t ∧ q = t + 2 := ⟨q - 2, by omega, by ring⟩
        apply le_of_sub_nonneg
        ring_nf
        positivity
      nlinarith only [hend, hW]

private theorem later_four {q x y z : ℤ} (hq : 0 ≤ q)
    (h : Sol (5 * q + 4) x y z) (hl : q + 2 ≤ x) :
    z ≤ ((5 * q + 4) * (q + 1)) * ((5 * q + 4) * (q + 1) + 1) := by
  have hf : 2 * (5 * q + 4) * (2 * (5 * q + 4) + 5) ≤
      25 * (((5 * q + 4) * (q + 1)) * ((5 * q + 4) * (q + 1) + 1)) := by
    apply le_of_sub_nonneg
    ring_nf
    positivity
  by_cases hfar : 2 * (5 * q + 4) ≤ 5 * x
  · have := far_bound h hfar
    nlinarith
  · apply near_bound h (l := q + 2) (d := 1) (by omega) hl (by omega) (by norm_num)
    · have := (basic_bounds h).2.2.2; omega
    · apply le_of_sub_nonneg
      ring_nf
      positivity

private theorem later_two_coprime {q x y z W : ℤ} (hq : 1 ≤ q)
    (h : Sol (5 * q + 2) x y z) (hl : q + 2 ≤ x)
    (hW : ((5 * q + 2) * (q + 1)) * ((5 * q + 2) * (q + 1) + 1) ≤ 3 * W) : z ≤ W := by
  have hf : 6 * (5 * q + 2) * (2 * (5 * q + 2) + 5) ≤
      25 * (((5 * q + 2) * (q + 1)) * ((5 * q + 2) * (q + 1) + 1)) := by
    obtain ⟨t, ht, rfl⟩ : ∃ t : ℤ, 0 ≤ t ∧ q = t + 1 := ⟨q - 1, by omega, by ring⟩
    apply le_of_sub_nonneg
    ring_nf
    positivity
  by_cases hfar : 2 * (5 * q + 2) ≤ 5 * x
  · have := far_bound h hfar
    nlinarith
  · apply near_bound h (l := q + 2) (d := 1) (by omega) hl (by omega) (by norm_num)
    · have := (basic_bounds h).2.2.2; omega
    · have hend : 3 * (((5 * q + 2) * (q + 2)) * ((5 * q + 2) * (q + 2) + 1)) ≤
          8 * (((5 * q + 2) * (q + 1)) * ((5 * q + 2) * (q + 1) + 1)) := by
        obtain ⟨t, ht, rfl⟩ : ∃ t : ℤ, 0 ≤ t ∧ q = t + 1 := ⟨q - 1, by omega, by ring⟩
        apply le_of_sub_nonneg
        ring_nf
        positivity
      nlinarith only [hend, hW]

private theorem later_two_divisible {q x y z W : ℤ} (hq : 11 ≤ q)
    (h : Sol (5 * q + 2) x y z) (hl : q + 2 ≤ x)
    (hW : ((5 * q + 2) * (q + 1)) * ((5 * q + 2) * (q + 1) + 3) ≤ 9 * W) : z ≤ W := by
  have hf : 18 * (5 * q + 2) * (2 * (5 * q + 2) + 5) ≤
      25 * (((5 * q + 2) * (q + 1)) * ((5 * q + 2) * (q + 1) + 3)) := by
    obtain ⟨t, ht, rfl⟩ : ∃ t : ℤ, 0 ≤ t ∧ q = t + 11 := ⟨q - 11, by omega, by ring⟩
    apply le_of_sub_nonneg
    ring_nf
    positivity
  by_cases hfar : 2 * (5 * q + 2) ≤ 5 * x
  · have := far_bound h hfar
    nlinarith
  · by_cases heq : x = q + 2
    · subst x
      have he := residual_eight_gap h (by ring)
      have hb := residual_bound h (by norm_num : (0 : ℤ) < 2) he
      have hend : 9 * (((5 * q + 2) * (q + 2)) * ((5 * q + 2) * (q + 2) + 2)) ≤
          16 * (((5 * q + 2) * (q + 1)) * ((5 * q + 2) * (q + 1) + 3)) := by
        obtain ⟨t, ht, rfl⟩ : ∃ t : ℤ, 0 ≤ t ∧ q = t + 11 := ⟨q - 11, by omega, by ring⟩
        apply le_of_sub_nonneg
        ring_nf
        positivity
      nlinarith only [hend, hW, hb]
    · apply near_bound h (l := q + 3) (d := 1) (by omega) (by omega) (by omega) (by norm_num)
      · have := (basic_bounds h).2.2.2; omega
      · have hend : 9 * (((5 * q + 2) * (q + 3)) * ((5 * q + 2) * (q + 3) + 1)) ≤
            13 * (((5 * q + 2) * (q + 1)) * ((5 * q + 2) * (q + 1) + 3)) := by
          obtain ⟨t, ht, rfl⟩ : ∃ t : ℤ, 0 ≤ t ∧ q = t + 11 := ⟨q - 11, by omega, by ring⟩
          apply le_of_sub_nonneg
          ring_nf
          positivity
        nlinarith only [hend, hW]

#print axioms later_zero
#print axioms later_three
#print axioms later_four
#print axioms later_two_coprime
#print axioms later_two_divisible

end A398581Probe
