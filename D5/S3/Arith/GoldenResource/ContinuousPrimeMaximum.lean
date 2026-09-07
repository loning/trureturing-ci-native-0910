/- GID: D5/S3/Arith/GoldenResource/ContinuousPrimeMaximum
   generality: G
   mirror-B: D5/B/S3/Arith/GoldenResource/ContinuousPrimeMaximum
   mirror-E: none(waiver:general-real-analysis)
   anchors: []
   utility: none
   digest: The continuous prime-direction objective has a unique maximum on the nonnegative ray. -/

import Mathlib.Analysis.SpecialFunctions.Pow.Deriv
import Mathlib.Analysis.SpecialFunctions.Log.Deriv
import Mathlib.Analysis.Calculus.Deriv.MeanValue
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/- Library-search audit trail (2026-09-07):
   1. D5 searches: continuous prime, log-ratio objectives, unique maxima, and
      log y / log p. Enumerated every public theorem/lemma/def in PrimeLogBudget,
      GoldenResourceOptimalLayerCount, GoldenResourceSupremum and their direct
      D5 imports with grep -nE '^(theorem|lemma|def|noncomputable def) '.
      The complete list and individual exclusions are in the implementation report.
      Integer-layer results quantify over natural exponents; the budget result
      determines y and gives no real-exponent tangent bound or derivative.
   2. Pinned Mathlib v4.33.0: strictConcaveOn_log_Ioi and general log bounds exist,
      but no matching composite-function maximum or equality condition was found.
      Reused HasDerivAt.const_rpow, HasDerivAt.log, rpow_lt_rpow_of_exponent_lt,
      strictMonoOn_of_deriv_pos and strictAntiOn_of_deriv_neg.
   3. Third-party Lean ecosystem: NyxID/Tavily query "Lean theorem prover
      formalization log (1 - p^(-x)) strictly concave unique maximum continuous
      prime exponent", request 31bb5ce4-de52-494a-8aae-74bb31ab1d1c.
      Returned Lean project pages, Lean-RH, Nagata factoriality and automated
      market-maker formalization; no matching declaration in the returned results.
   Preregistered witness unchanged: the public unique-maximum conclusion itself,
   produced by the named analytic construction below: derivative calculation,
   strict decrease, and interior/boundary cases. No frozen D5 imports.
   Computational content: none (general real analysis, no finite computation).
   Companion direction: continuous_prime_unique_maximum -> the derivative and
   strict-decrease theorems. Admission basis: escape-witness. -/

namespace D5.S3.Arith.GoldenResource.ContinuousPrimeMaximum

open Real Set

private theorem denominator_pos {p x : ℝ} (hp : 1 < p) (hx : 0 ≤ x) :
    0 < p ^ (x + 1) - 1 :=
  sub_pos.mpr (one_lt_rpow hp (by linarith))

/-- The real prime-direction benefit has the stated derivative on the nonnegative ray. -/
theorem continuous_prime_hasDerivAt {p x : ℝ} (hp : 1 < p) (hx : 0 ≤ x) :
    HasDerivAt
      (fun t : ℝ => log ((1 - p ^ (-(t + 1))) / (1 - p ^ (-1 : ℝ))))
      (log p / (p ^ (x + 1) - 1)) x := by
  have hp0 : 0 < p := by linarith
  have hpow : 1 < p ^ (x + 1) := by linarith [denominator_pos hp hx]
  have hn : 0 < 1 - p ^ (-(x + 1)) := by
    rw [rpow_neg hp0.le]
    exact sub_pos.mpr ((inv_lt_one₀ (by linarith)).mpr hpow)
  have hd : 0 < 1 - p ^ (-1 : ℝ) := by
    rw [rpow_neg_one]
    exact sub_pos.mpr ((inv_lt_one₀ hp0).mpr hp)
  have h := (((HasDerivAt.const_rpow hp0
    (((hasDerivAt_id x).add_const 1).neg)).const_sub 1).div_const
      (1 - p ^ (-1 : ℝ))).log (div_pos hn hd).ne'
  convert! h using 1
  dsimp only [Pi.neg_apply, id_eq]
  rw [rpow_neg hp0.le]
  field_simp [hd.ne', (denominator_pos hp hx).ne', (rpow_pos_of_pos hp0 (x + 1)).ne']

/-- The explicit derivative strictly decreases over all nonnegative real exponents. -/
theorem continuous_prime_slope_strictAntiOn {p : ℝ} (hp : 1 < p) :
    StrictAntiOn (fun x : ℝ => log p / (p ^ (x + 1) - 1)) (Ici 0) := by
  intro x hx z hz hxz
  exact div_lt_div_of_pos_left (log_pos hp) (denominator_pos hp hx)
    (sub_lt_sub_right (rpow_lt_rpow_of_exponent_lt hp (by linarith)) 1)

/-- The explicit nonnegative exponent maximizes the objective, with equality only there. -/
theorem continuous_prime_unique_maximum {p y x : ℝ}
    (hp : 1 < p) (hy : 2 < y) (hx : 0 ≤ x) :
    let a := max 0 (log y / log p - 1)
    let f := fun t : ℝ => log ((1 - p ^ (-(t + 1))) / (1 - p ^ (-1 : ℝ)))
    f x - x * log p / (y - 1) ≤ f a - a * log p / (y - 1) ∧
      (f x - x * log p / (y - 1) = f a - a * log p / (y - 1) ↔ x = a) := by
  let a := max 0 (log y / log p - 1)
  let F := fun t : ℝ =>
    log ((1 - p ^ (-(t + 1))) / (1 - p ^ (-1 : ℝ))) - t * log p / (y - 1)
  let q := fun t : ℝ => log p / (p ^ (t + 1) - 1)
  change F x ≤ F a ∧ (F x = F a ↔ x = a)
  have hp0 : 0 < p := by linarith
  have hy0 : 0 < y := by linarith
  have hlog : 0 < log p := log_pos hp
  have ha : 0 ≤ a := le_max_left _ _
  have hd (t : ℝ) (ht : 0 ≤ t) : HasDerivAt F (q t - log p / (y - 1)) t := by
    convert! (continuous_prime_hasDerivAt hp ht).sub
      (((hasDerivAt_id t).mul_const (log p)).div_const (y - 1)) using 1
    simp only [q, one_mul]
  have hc : ContinuousOn F (Ici 0) :=
    fun t ht => (hd t ht).continuousAt.continuousWithinAt
  have hq : StrictAntiOn q (Ici 0) := continuous_prime_slope_strictAntiOn hp
  have hstrict (t : ℝ) (ht : 0 ≤ t) (hne : t ≠ a) : F t < F a := by
    by_cases hpy : p < y
    · have hz : 0 < log y / log p - 1 := by
        have hratio := (one_lt_div hlog).mpr (log_lt_log hp0 hpy)
        linarith
      have haeq : a = log y / log p - 1 := max_eq_right hz.le
      have hpa : p ^ (a + 1) = y := by
        rw [haeq, sub_add_cancel, rpow_def_of_pos hp0]
        have he : log p * (log y / log p) = log y := by
          field_simp
        rw [he, exp_log hy0]
      have hqa : q a = log p / (y - 1) := by simp only [q, hpa]
      rcases lt_or_gt_of_ne hne with hta | hat
      · have hmono : StrictMonoOn F (Icc 0 a) := by
          apply strictMonoOn_of_deriv_pos (convex_Icc 0 a)
            (hc.mono (fun _ hu => hu.1))
          intro u hu
          rw [interior_Icc] at hu
          rw [(hd u hu.1.le).deriv, ← hqa]
          exact sub_pos.mpr (hq hu.1.le ha hu.2)
        exact hmono ⟨ht, hta.le⟩ ⟨ha, le_rfl⟩ hta
      · have hanti : StrictAntiOn F (Ici a) := by
          apply strictAntiOn_of_deriv_neg (convex_Ici a)
            (hc.mono (fun _ hu => ha.trans hu))
          intro u hu
          rw [interior_Ici] at hu
          rw [(hd u (ha.trans hu.le)).deriv, ← hqa]
          exact sub_neg.mpr (hq ha (ha.trans hu.le) hu)
        exact hanti (by change a ≤ a; exact le_rfl) (by exact hat.le) hat
    · have hyp : y ≤ p := le_of_not_gt hpy
      have hz : log y / log p - 1 ≤ 0 := by
        have hratio := (div_le_one hlog).mpr (log_le_log hy0 hyp)
        linarith
      have haeq : a = 0 := max_eq_left hz
      have hq0 : q 0 ≤ log p / (y - 1) := by
        simp only [q, zero_add, rpow_one]
        exact div_le_div_of_nonneg_left hlog.le (by linarith) (by linarith)
      have hanti : StrictAntiOn F (Ici 0) := by
        apply strictAntiOn_of_deriv_neg (convex_Ici 0) hc
        intro u hu
        rw [interior_Ici] at hu
        rw [(hd u hu.le).deriv]
        exact sub_neg.mpr ((hq (show (0 : ℝ) ∈ Ici 0 by simp)
          (by change 0 ≤ u; exact hu.le) hu).trans_le hq0)
      have htpos : 0 < t := lt_of_le_of_ne ht (by simpa [haeq] using Ne.symm hne)
      rw [haeq]
      exact hanti (by simp) ht htpos
  have hle : F x ≤ F a := by
    by_cases hxa : x = a
    · subst x; exact le_rfl
    · exact (hstrict x hx hxa).le
  refine ⟨hle, ?_⟩
  constructor
  · intro heq
    by_contra hne
    exact (hstrict x hx hne).ne heq
  · intro heq
    rw [heq]

#print axioms continuous_prime_hasDerivAt
#print axioms continuous_prime_slope_strictAntiOn
#print axioms continuous_prime_unique_maximum

end D5.S3.Arith.GoldenResource.ContinuousPrimeMaximum
