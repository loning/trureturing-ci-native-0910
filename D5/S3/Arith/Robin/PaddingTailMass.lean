/- GID: D5/S3/Arith/Robin/PaddingTailMass
   generality: G
   mirror-B: D5/B/S3/Arith/Robin/PaddingTailMass
   mirror-E: none(waiver:qualitative-asymptotic-estimate)
   anchors: []
   utility: none
   digest: Prime padding bounds tail mass and yields escape given finite-set mass escape. -/

import D5.S3.Arith.Robin.PaddingRatio
import Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics
import Mathlib.Topology.Algebra.InfiniteSum.Real

/- The finite-set escape assumption below is explicit. This module supplies no
implication from the Riemann hypothesis to that assumption or to summability. -/

open Filter
open scoped Topology

namespace D5.S3.Arith.Robin

noncomputable section

/-- The full-wave weight, restricted to integers strictly above 5040. -/
def waveWeight (r : ℝ) (n : ℕ) : ℝ :=
  if 5040 < n then (n : ℝ) ^ (-2 : ℝ) * robinRatio n ^ r else 0

/-- The full-wave partition function. -/
def wavePartition (r : ℝ) : ℝ := ∑' n, waveWeight r n

/-- The normalized mass of a set of integers. -/
def waveMass (r : ℝ) (s : Set ℕ) : ℝ := (∑' n : s, waveWeight r n) / wavePartition r

/-- Finite-set mass escape is a separate premise, restricted to the actual support. -/
def FiniteMassEscape : Prop :=
  ∀ F : Finset ℕ, (∀ n ∈ F, 5040 < n) →
    Tendsto (fun r : ℝ => waveMass r (F : Set ℕ)) atTop (𝓝 0)

private theorem weight_nonneg (r : ℝ) (n : ℕ) : 0 ≤ waveWeight r n := by
  unfold waveWeight
  split_ifs with hn
  · exact mul_nonneg (Real.rpow_nonneg (Nat.cast_nonneg _) _)
      (Real.rpow_nonneg (robinRatio_nonneg (by omega)) _)
  · exact le_rfl

private theorem weight_padding_le {p A n : ℕ} {r : ℝ}
    (hp : p.Prime) (hn : 5041 ≤ n) (hr : 0 ≤ r)
    (hgain : robinRatio n ≤ paddingQ p A * robinRatio (padding p A n)) :
    waveWeight r n ≤ (p : ℝ) ^ (2 * (A + 1)) * paddingQ p A ^ r *
      waveWeight r (padding p A n) := by
  have hpad := padding_bounds hp A n
  have hT : 5041 ≤ padding p A n := hn.trans hpad.1
  have hnR : 0 < (n : ℝ) := by exact_mod_cast (show 0 < n by omega)
  have hTR : 0 < (padding p A n : ℝ) := by exact_mod_cast (show 0 < padding p A n by omega)
  have hscale : (padding p A n : ℝ) ≤ (p : ℝ) ^ (A + 1) * n := by
    exact_mod_cast hpad.2
  have hscale2 : (padding p A n : ℝ) ^ 2 ≤ (p : ℝ) ^ (2 * (A + 1)) * (n : ℝ) ^ 2 := by
    simpa only [mul_pow, ← pow_mul, Nat.mul_comm (A + 1) 2] using
      pow_le_pow_left₀ hTR.le hscale 2
  have hbase : (n : ℝ) ^ (-2 : ℝ) ≤ (p : ℝ) ^ (2 * (A + 1)) *
      (padding p A n : ℝ) ^ (-2 : ℝ) := by
    simp only [Real.rpow_neg hnR.le, Real.rpow_neg hTR.le, Real.rpow_two]
    rw [← one_div, ← div_eq_mul_inv]
    exact (div_le_div_iff₀ (sq_pos_of_pos hnR) (sq_pos_of_pos hTR)).mpr (by simpa using hscale2)
  have hq := (padding_constants hp A).2.2.1
  have hpower : robinRatio n ^ r ≤ paddingQ p A ^ r * robinRatio (padding p A n) ^ r := by
    rw [← Real.mul_rpow hq.le (robinRatio_nonneg hT)]
    exact Real.rpow_le_rpow (robinRatio_nonneg hn) hgain hr
  rw [waveWeight, if_pos (by omega), waveWeight, if_pos (by omega)]
  calc
    _ ≤ ((p : ℝ) ^ (2 * (A + 1)) * (padding p A n : ℝ) ^ (-2 : ℝ)) *
        (paddingQ p A ^ r * robinRatio (padding p A n) ^ r) :=
      mul_le_mul hbase hpower (Real.rpow_nonneg (robinRatio_nonneg hn) _)
        (mul_nonneg (pow_nonneg (Nat.cast_nonneg _) _) (Real.rpow_nonneg hTR.le _))
    _ = _ := by ring

/-- The real-parameter tail estimate, with explicit multiplicity and scale costs. -/
theorem padding_tail_mass {p : ℕ} (hp : p.Prime) (A : ℕ)
    (hs : ∀ r : ℝ, 0 ≤ r → Summable (waveWeight r))
    (hQ : ∀ r : ℝ, 0 ≤ r → 0 < wavePartition r) :
    ∃ N ≥ 5041, ∀ r : ℝ, 0 ≤ r →
      waveMass r {n | N ≤ n ∧ n.factorization p ≤ A} ≤
        (A + 1 : ℝ) * (p : ℝ) ^ (2 * (A + 1)) * paddingQ p A ^ r := by
  classical
  obtain ⟨N, hN, hgain⟩ := padding_ratio hp A
  refine ⟨N, hN, ?_⟩
  intro r hr
  let S := {n : ℕ | N ≤ n ∧ n.factorization p ≤ A}
  let lift : S → Fin (A + 1) × ℕ := fun n =>
    (⟨n.val.factorization p, by omega⟩, padding p A n)
  have hinj : Function.Injective lift := by
    intro n m h
    have he : n.val.factorization p = m.val.factorization p :=
      congrArg (fun z : Fin (A + 1) × ℕ => z.1.val) h
    have ht : padding p A n = padding p A m := congrArg Prod.snd h
    apply Subtype.ext
    unfold padding at ht
    rw [he] at ht
    exact Nat.eq_of_mul_eq_mul_left (pow_pos hp.pos _) ht
  let f : Fin (A + 1) × ℕ → ℝ := fun z => waveWeight r z.2
  have hf0 : 0 ≤ f := fun z => weight_nonneg r z.2
  have hf : Summable f := (summable_prod_of_nonneg hf0).mpr
    ⟨fun _ => hs r hr, summable_fintype _⟩
  have hcomp := tsum_comp_le_tsum_of_inj hf hf0 hinj
  have htotal : (∑' z, f z) = (A + 1 : ℝ) * wavePartition r := by
    rw [hf.tsum_prod]
    simp [f, wavePartition, tsum_fintype]
  let c : ℝ := (p : ℝ) ^ (2 * (A + 1)) * paddingQ p A ^ r
  have hc : 0 ≤ c := mul_nonneg (pow_nonneg (Nat.cast_nonneg _) _)
    (Real.rpow_nonneg (padding_constants hp A).2.2.1.le _)
  have hpoint (n : S) : waveWeight r n ≤ c * f (lift n) :=
    weight_padding_le hp (hN.trans n.property.1) hr (hgain n n.property.1 n.property.2)
  have hsum : (∑' n : S, waveWeight r n) ≤
      c * ((A + 1 : ℝ) * wavePartition r) := by
    calc
      _ ≤ ∑' n : S, c * f (lift n) :=
        tsum_le_tsum hpoint ((hs r hr).subtype S) ((hf.comp_injective hinj).mul_left c)
      _ = c * ∑' n : S, f (lift n) := tsum_mul_left
      _ ≤ c * ∑' z, f z := mul_le_mul_of_nonneg_left hcomp hc
      _ = _ := by rw [htotal]
  apply (div_le_iff₀ (hQ r hr)).mpr
  calc
    _ ≤ c * ((A + 1 : ℝ) * wavePartition r) := hsum
    _ = _ := by dsimp [c]; ring

private theorem mass_split_bound {p A N : ℕ} {r : ℝ}
    (hs : Summable (waveWeight r)) (hQ : 0 < wavePartition r) :
    waveMass r {n | 5040 < n ∧ n.factorization p ≤ A} ≤
      waveMass r ((Finset.range N).filter (fun n => 5040 < n) : Set ℕ) +
        waveMass r {n | N ≤ n ∧ n.factorization p ≤ A} := by
  classical
  unfold waveMass
  rw [← add_div]
  apply div_le_div_of_nonneg_right _ hQ.le
  rw [tsum_subtype, tsum_subtype, tsum_subtype, ← (hs.indicator _).tsum_add (hs.indicator _)]
  apply tsum_le_tsum _ (hs.indicator _) ((hs.indicator _).add (hs.indicator _))
  intro n
  by_cases ht : N ≤ n
  · have hn : ¬n < N := by omega
    by_cases h0 : 5040 < n <;> by_cases hv : n.factorization p ≤ A <;>
      simp [Set.indicator_apply, h0, hv, ht, hn, weight_nonneg]
  · have hn : n < N := by omega
    by_cases h0 : 5040 < n <;> by_cases hv : n.factorization p ≤ A <;>
      simp [Set.indicator_apply, h0, hv, ht, hn, weight_nonneg]

/-- Every bounded prime-exponent window loses all mass, assuming summability,
positive partition functions, and the separate finite-set mass escape premise. -/
theorem bounded_exponent_mass_tendsto_zero {p : ℕ} (hp : p.Prime) (A : ℕ)
    (hs : ∀ r : ℝ, 0 ≤ r → Summable (waveWeight r))
    (hQ : ∀ r : ℝ, 0 ≤ r → 0 < wavePartition r)
    (hfinite : FiniteMassEscape) :
    Tendsto (fun r : ℝ => waveMass r {n | 5040 < n ∧ n.factorization p ≤ A})
      atTop (𝓝 0) := by
  obtain ⟨N, _, htail⟩ := padding_tail_mass hp A hs hQ
  let F := (Finset.range N).filter (fun n => 5040 < n)
  have hF : ∀ n ∈ F, 5040 < n := fun n hn => (Finset.mem_filter.mp hn).2
  have hq := padding_constants hp A
  have hdecay : Tendsto (fun r : ℝ =>
      (A + 1 : ℝ) * (p : ℝ) ^ (2 * (A + 1)) * paddingQ p A ^ r) atTop (𝓝 0) := by
    simpa using (Real.tendsto_rpow_atTop_of_base_lt_one (paddingQ p A)
      (by linarith [hq.2.2.1]) hq.2.2.2).const_mul
        ((A + 1 : ℝ) * (p : ℝ) ^ (2 * (A + 1)))
  have hupper := (hfinite F hF).add hdecay
  simp only [add_zero] at hupper
  apply squeeze_zero' _ _ hupper
  · filter_upwards [eventually_ge_atTop (0 : ℝ)] with r hr
    exact div_nonneg (tsum_nonneg fun n => weight_nonneg r n) (hQ r hr).le
  · filter_upwards [eventually_ge_atTop (0 : ℝ)] with r hr
    exact (mass_split_bound (p := p) (A := A) (N := N) (hs r hr) (hQ r hr)).trans
      (add_le_add_left (htail r hr) _)

#print axioms waveWeight
#print axioms wavePartition
#print axioms waveMass
#print axioms FiniteMassEscape
#print axioms padding_tail_mass
#print axioms bounded_exponent_mass_tendsto_zero

end
end D5.S3.Arith.Robin
