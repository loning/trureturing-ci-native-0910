/- GID: D5/S3/QuantumBounds/ReferenceFrame/FiniteShiftAutocorrelation
   generality: G
   mirror-B: D5/B/S3/QuantumBounds/ReferenceFrame/FiniteShiftAutocorrelation
   mirror-E: none(waiver:exact-symbolic-bound)
   anchors: []
   utility: none
   digest: Sharp finite integer-shift autocorrelation and attaining sine sequences. -/

import D5.S3.QuantumBounds.ReferenceFrame.TopEigenspace
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Algebra.Order.Floor.Ring
import Mathlib.Analysis.Complex.Basic

namespace D5.S3.QuantumBounds.ReferenceFrame.FiniteShiftAutocorrelation

open scoped BigOperators
open D5.S3.QuantumBounds.ReferenceFrame.TopEigenspace
open D5.S3.QuantumBounds.ReferenceFrameTax

private theorem cosine_nonneg (k : Nat) :
    0 <= Real.cos (Real.pi / ((k : Real) + 2)) := by
  apply Real.cos_nonneg_of_mem_Icc
  constructor
  · have : 0 <= Real.pi / ((k : Real) + 2) := by positivity
    linarith [Real.pi_pos]
  · apply (div_le_div_iff₀ (by positivity) (by norm_num : (0 : Real) < 2)).2
    nlinarith [Real.pi_pos, Nat.cast_nonneg (α := Real) k]

private theorem path_dot_eq_edges (k : Nat) (x : Fin (k + 1) -> Real) :
    (∑ i, x i * nearestNeighborAverage x i) =
      ∑ j : Fin k, x j.succ * x j.castSucc := by
  have hl : (∑ i : Fin (k+1), x i *
      (if h : 0 < i.val then x ⟨i.val-1, by omega⟩ else 0)) =
      ∑ j : Fin k, x j.succ * x j.castSucc := by
    rw [Fin.sum_univ_succ]
    simp
    rfl
  have hr : (∑ i : Fin (k+1), x i *
      (if h : i.val+1 < k+1 then x ⟨i.val+1, h⟩ else 0)) =
      ∑ j : Fin k, x j.succ * x j.castSucc := by
    rw [Fin.sum_univ_castSucc]
    simp only [Fin.val_last, lt_self_iff_false, dite_false, mul_zero, add_zero]
    apply Finset.sum_congr rfl
    intro j _
    simp only [Fin.val_castSucc, show j.val + 1 < k+1 by omega, dite_true]
    exact mul_comm _ _
  simp only [nearestNeighborAverage, mul_div, mul_add]
  rw [← Finset.sum_div, Finset.sum_add_distrib, hl, hr]
  ring

private theorem path_edges_bound (k : Nat) (x : Fin (k + 1) -> Real) :
    (∑ j : Fin k, x j.succ * x j.castSucc) <=
      Real.cos (Real.pi / ((k : Real)+2)) * ∑ i, x i ^ 2 := by
  rw [← path_dot_eq_edges]
  have hcs := Finset.sum_mul_sq_le_sq_mul_sq Finset.univ x
    (nearestNeighborAverage x)
  have hop := nearestNeighborQuadratic_le_cos_sq (k+1) x
  rw [nearest_neighbor_quadratic_eq_average_norm_sq] at hop
  have hm : 0 <= ∑ i, x i ^ 2 := Finset.sum_nonneg (fun _ _ => sq_nonneg _)
  have hc := cosine_nonneg k
  have heq : ((k+1 : Nat) : Real) + 1 = (k : Real)+2 := by push_cast; ring
  rw [heq] at hop
  have hmul := mul_le_mul_of_nonneg_left hop hm
  nlinarith [mul_nonneg hc hm]

private def residueIndex (L q : Nat) (p : Fin L × Fin (q + 1)) : Int :=
  ((p.1.val + p.2.val * L : Nat) : Int)

private theorem residue_index_injective (L q : Nat) (hL : 0 < L) :
    Function.Injective (residueIndex L q) := by
  intro a b hab
  have hn : a.1.val + a.2.val * L = b.1.val + b.2.val * L := by
    unfold residueIndex at hab
    exact_mod_cast hab
  have hr := congrArg (fun n : Nat => n % L) hn
  simp only [Nat.add_mul_mod_self_right, Nat.mod_eq_of_lt a.1.isLt,
    Nat.mod_eq_of_lt b.1.isLt] at hr
  have hj := congrArg (fun n : Nat => n / L) hn
  simp only [Nat.add_mul_div_right _ _ hL, Nat.div_eq_of_lt a.1.isLt,
    Nat.div_eq_of_lt b.1.isLt, zero_add] at hj
  exact Prod.ext (Fin.ext hr) (Fin.ext hj)

private theorem tsum_residues {A : Type*} [AddCommMonoid A] [TopologicalSpace A]
    (N L : Nat) (hL : 0 < L) (f : Int -> A)
    (hf : forall n : Int, n < 0 ∨ (N : Int) < n -> f n = 0) :
    (∑' n : Int, f n) =
      ∑ r : Fin L, ∑ j : Fin (N/L+1), f (residueIndex L (N/L) (r,j)) := by
  have hs : Function.support f ⊆ Set.range (residueIndex L (N/L)) := by
    intro n hn
    have hne : f n ≠ 0 := hn
    have hn0 : 0 <= n := by by_contra h; exact hne (hf n (Or.inl (by omega)))
    have hnN : n <= (N : Int) := by by_contra h; exact hne (hf n (Or.inr (by omega)))
    have hnat : n.toNat <= N := by omega
    refine ⟨(⟨n.toNat % L, Nat.mod_lt _ hL⟩,
      ⟨n.toNat / L, Nat.lt_succ_of_le (Nat.div_le_div_right hnat)⟩), ?_⟩
    change ((n.toNat % L + n.toNat / L * L : Nat) : Int) = n
    rw [Nat.mod_add_div', Int.toNat_of_nonneg hn0]
  have h := (residue_index_injective L (N/L) hL).tsum_eq hs
  simpa only [tsum_fintype, Fintype.sum_prod_type] using h.symm

private theorem gamma_residues (N L : Nat) (hL : 0 < L) (c : Int -> Complex)
    (hs : forall n : Int, n < 0 ∨ (N : Int) < n -> c n = 0) :
    (∑' n : Int, c (n + (L : Int)) * star (c n)) =
      ∑ r : Fin L, ∑ j : Fin (N/L),
        c (residueIndex L (N/L) (r,j.succ)) *
          star (c (residueIndex L (N/L) (r,j.castSucc))) := by
  rw [tsum_residues N L hL _ (fun n hn => by rw [hs n hn, star_zero, mul_zero])]
  apply Finset.sum_congr rfl
  intro r _
  rw [Fin.sum_univ_castSucc]
  have htop : c (residueIndex L (N/L) (r,Fin.last (N/L)) + (L : Int)) = 0 := by
    apply hs _ (Or.inr ?_)
    have hd := Nat.mod_lt N hL
    have he := Nat.mod_add_div N L
    rw [Nat.mul_comm L] at he
    dsimp [residueIndex]
    exact_mod_cast (show N < r.val + N/L*L + L by omega)
  rw [htop, zero_mul, add_zero]
  apply Finset.sum_congr rfl
  intro j _
  congr 2
  simp only [residueIndex, Fin.val_castSucc, Fin.val_succ]
  push_cast
  ring

/-- The exact sharp cosine upper bound for the original complex autocorrelation. -/
theorem finite_support_autocorrelation_bound (N : Nat) (ell : Int) (hEll : 1 <= ell)
    (c : Int -> Complex)
    (hsupport : forall n : Int, Or (n < 0) ((N : Int) < n) -> c n = 0)
    (hnorm : tsum (fun n : Int => norm (c n) ^ 2) = 1) :
    norm (tsum (fun n : Int => c (n + ell) * star (c n))) <=
      Real.cos (Real.pi / (((N / ell.toNat : Nat) : Real) + 2)) := by
  have hL : 0 < ell.toNat := by omega
  have he : (ell.toNat : Int) = ell := Int.toNat_of_nonneg (by omega)
  have hm := tsum_residues N ell.toNat hL (fun n => norm (c n)^2)
    (fun n hn => by rw [hsupport n hn, norm_zero, zero_pow (by decide)])
  rw [hnorm] at hm
  conv_lhs => rw [← he]
  rw [gamma_residues N ell.toNat hL c hsupport]
  calc
    _ <= ∑ r : Fin ell.toNat, ∑ j : Fin (N/ell.toNat),
        norm (c (residueIndex ell.toNat (N/ell.toNat) (r,j.succ))) *
          norm (c (residueIndex ell.toNat (N/ell.toNat) (r,j.castSucc))) := by
      refine (norm_sum_le _ _).trans (Finset.sum_le_sum (fun r _ => ?_))
      simpa only [norm_mul, norm_star] using
        (norm_sum_le (Finset.univ) (fun j : Fin (N/ell.toNat) =>
          c (residueIndex ell.toNat (N/ell.toNat) (r,j.succ)) *
          star (c (residueIndex ell.toNat (N/ell.toNat) (r,j.castSucc)))))
    _ <= ∑ r : Fin ell.toNat, Real.cos (Real.pi / ((N/ell.toNat : Nat)+2 : Real)) *
        ∑ j : Fin (N/ell.toNat+1), norm (c (residueIndex ell.toNat (N/ell.toNat) (r,j)))^2 :=
      Finset.sum_le_sum (fun r _ => path_edges_bound (N/ell.toNat)
        (fun j => norm (c (residueIndex ell.toNat (N/ell.toNat) (r,j)))))
    _ = _ := by rw [← Finset.mul_sum, ← hm, mul_one]

private theorem normalized_low_mode (q : Nat) :
    ∃ x : Fin (q+1) -> Real, (∑ j, x j^2) = 1 ∧
      (∑ j : Fin q, x j.succ * x j.castSucc) =
        Real.cos (Real.pi / ((q : Real)+2)) := by
  let s := lowMode (q+1)
  let S := ∑ j, s j^2
  have hs0 : 0 < s 0 := by
    simp only [s, lowMode, sineMode, modeAngle, Fin.val_zero, Nat.cast_zero,
      zero_add, Nat.cast_one, one_mul]
    apply Real.sin_pos_of_pos_of_lt_pi (by positivity)
    apply (div_lt_iff₀ (by positivity)).2
    have hq : (0 : Real) <= q := Nat.cast_nonneg q
    push_cast
    nlinarith [Real.pi_pos]
  have hS : 0 < S := lt_of_lt_of_le (sq_pos_of_pos hs0)
    (Finset.single_le_sum (fun j _ => sq_nonneg (s j)) (Finset.mem_univ 0))
  let a := (Real.sqrt S)⁻¹
  let x := a • s
  have hxmass : (∑ j, x j^2) = 1 := by
    simp only [x, Pi.smul_apply, smul_eq_mul, mul_pow, ← Finset.mul_sum]
    change (Real.sqrt S)⁻¹ ^ 2 * S = 1
    rw [inv_pow, Real.sq_sqrt hS.le, inv_mul_cancel₀ hS.ne']
  refine ⟨x, hxmass, ?_⟩
  rw [← path_dot_eq_edges]
  have hx (i : Fin (q+1)) : nearestNeighborAverage x i =
      Real.cos (Real.pi / ((q : Real)+2)) * x i := by
    change nearestNeighborAverage (a • lowMode (q+1)) i = _
    rw [nearest_neighbor_average_smul, low_mode_eigenvector]
    simp only [Pi.smul_apply, smul_eq_mul]
    have he : ((q+1 : Nat) : Real)+1 = (q : Real)+2 := by push_cast; ring
    rw [he]
    change a * (_ * s i) = _ * (a * s i)
    ring
  simp_rw [hx, show ∀ i, x i * (Real.cos (Real.pi / ((q : Real)+2)) * x i) =
    Real.cos (Real.pi / ((q : Real)+2)) * x i^2 by intro i; ring]
  rw [← Finset.mul_sum, hxmass, mul_one]

private def progressionIndex (L q : Nat) (j : Fin (q + 1)) : Int := (j.val * L : Nat)

private theorem progression_index_injective (L q : Nat) (hL : 0 < L) :
    Function.Injective (progressionIndex L q) := by
  intro i j hij
  have h : i.val * L = j.val * L := by
    unfold progressionIndex at hij
    exact_mod_cast hij
  exact Fin.ext (Nat.eq_of_mul_eq_mul_right hL h)

private noncomputable def progression (L q : Nat) (x : Fin (q + 1) -> Real) :
    Int -> Complex :=
  Function.extend (progressionIndex L q) (fun j => (x j : Complex)) (fun _ => 0)

private theorem progression_support (N L : Nat) (x : Fin (N / L + 1) -> Real)
    (n : Int) (hn : n < 0 ∨ (N : Int) < n) : progression L (N/L) x n = 0 := by
  apply Function.extend_apply'
  rintro ⟨j, rfl⟩
  have hj : j.val * L <= N :=
    (Nat.mul_le_mul_right L (Nat.le_of_lt_succ j.isLt)).trans (Nat.div_mul_le_self N L)
  have hj0 : (0 : Int) <= progressionIndex L (N/L) j := Int.natCast_nonneg _
  have hjN : progressionIndex L (N/L) j <= (N : Int) := by
    unfold progressionIndex
    exact_mod_cast hj
  omega

private theorem progression_on_residue (L q : Nat) (hL : 0 < L)
    (x : Fin (q + 1) -> Real) (r : Fin L) (j : Fin (q + 1)) :
    progression L q x (residueIndex L q (r,j)) = if r.val = 0 then (x j : Complex) else 0 := by
  classical
  by_cases hr : r.val = 0
  · rw [if_pos hr]
    have hi : residueIndex L q (r,j) = progressionIndex L q j := by
      simp [residueIndex, progressionIndex, hr]
    rw [hi]
    exact (progression_index_injective L q hL).extend_apply _ _ _
  · rw [if_neg hr]
    apply Function.extend_apply'
    rintro ⟨i, hi⟩
    have he : residueIndex L q (⟨0,hL⟩,i) = residueIndex L q (r,j) := by
      simpa only [residueIndex, progressionIndex, zero_add] using hi
    have hp := (residue_index_injective L q hL) he
    exact hr (congrArg (fun p : Fin L × Fin (q+1) => p.1.val) hp).symm

/-- A normalized sine progression attains the bound for every natural N and positive shift. -/
theorem finite_support_autocorrelation_attained (N : Nat) (ell : Int) (hEll : 1 <= ell) :
    Exists (fun c : Int -> Complex =>
      And (forall n : Int, Or (n < 0) ((N : Int) < n) -> c n = 0)
        (And (tsum (fun n : Int => norm (c n) ^ 2) = 1)
          (norm (tsum (fun n : Int => c (n + ell) * star (c n))) =
            Real.cos (Real.pi / (((N / ell.toNat : Nat) : Real) + 2))))) := by
  classical
  have hL : 0 < ell.toNat := by omega
  have he : (ell.toNat : Int) = ell := Int.toNat_of_nonneg (by omega)
  obtain ⟨x,hxm,hxe⟩ := normalized_low_mode (N/ell.toNat)
  let c := progression ell.toNat (N/ell.toNat) x
  have hs : ∀ n : Int, n < 0 ∨ (N : Int) < n -> c n = 0 :=
    progression_support N ell.toNat x
  have hm : (∑' n : Int, norm (c n)^2) = 1 := by
    rw [tsum_residues N ell.toNat hL _ (fun n hn => by rw [hs n hn]; simp)]
    change (∑ r : Fin ell.toNat, ∑ j, norm (progression ell.toNat (N/ell.toNat) x
      (residueIndex ell.toNat (N/ell.toNat) (r,j)))^2) = 1
    rw [Finset.sum_eq_single (⟨0,hL⟩ : Fin ell.toNat)]
    · simpa [progression_on_residue _ _ hL, Complex.norm_real, Real.norm_eq_abs] using hxm
    · intro r _ hr
      have hr0 : r.val ≠ 0 := fun h => hr (Fin.ext h)
      simp [progression_on_residue _ _ hL, hr0]
    · simp
  have hg : (∑' n : Int, c (n+ell) * star (c n)) =
      (Real.cos (Real.pi / ((N/ell.toNat : Nat)+2 : Real)) : Complex) := by
    conv_lhs => rw [← he]
    rw [gamma_residues N ell.toNat hL c hs]
    change (∑ r : Fin ell.toNat, ∑ j : Fin (N/ell.toNat),
      progression ell.toNat (N/ell.toNat) x (residueIndex ell.toNat (N/ell.toNat) (r,j.succ)) *
        star (progression ell.toNat (N/ell.toNat) x
          (residueIndex ell.toNat (N/ell.toNat) (r,j.castSucc)))) = _
    rw [Finset.sum_eq_single (⟨0,hL⟩ : Fin ell.toNat)]
    · simpa [progression_on_residue _ _ hL] using
        congrArg (fun t : Real => (t : Complex)) hxe
    · intro r _ hr
      have hr0 : r.val ≠ 0 := fun h => hr (Fin.ext h)
      simp [progression_on_residue _ _ hL, hr0]
    · simp
  refine ⟨c,hs,hm,?_⟩
  rw [hg, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (cosine_nonneg _)]

/-- The integer floor in the source equals the exact natural quotient. -/
theorem floor_shift_quotient (N : Nat) (ell : Int) (hEll : 1 <= ell) :
    Int.floor ((N : Real) / (ell : Real)) = ((N / ell.toNat : Nat) : Int) := by
  have he : (ell.toNat : Int) = ell := Int.toNat_of_nonneg (by omega)
  conv_lhs => rw [← he, Int.cast_natCast]
  rw [Int.floor_div_natCast, Int.floor_natCast, Int.natCast_div]

end D5.S3.QuantumBounds.ReferenceFrame.FiniteShiftAutocorrelation
