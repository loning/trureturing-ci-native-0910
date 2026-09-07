/- GID: D5/S3/Factorization/JordanCototientRecordLimitZero
   generality: G
   mirror-B: D5/B/S3/Factorization/JordanCototientRecordLimitZero
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Small-parameter Jordan-cototient records are 1, 2, 4, and non-prime-powers. -/

import D5.S3.Factorization.JordanCototientRecordLimitInfinity
import Mathlib.Analysis.Calculus.DerivativeTest
import Mathlib.Analysis.SpecialFunctions.Pow.Deriv
import Mathlib.Data.Nat.Factorization.PrimePow

open Finset Filter Set SignType
open scoped Topology

namespace D5.S3.Factorization.JordanCototientRecordLimitZero

open D5.S3.Factorization.JordanCototientRecordLimitInfinity

private abbrev RHasDerivAt (f : ℝ → ℝ) (f' x : ℝ) : Prop :=
  @HasDerivAt ℝ _ ℝ Real.normedAddCommGroup.toAddCommGroup
    NormedField.toNormedSpace.toModule _ _ f f' x

private noncomputable def factor (p : ℕ) (k : ℝ) : ℝ :=
  1 - (p : ℝ) ^ (-k)

private lemma hasDerivAt_factor (p : ℕ) (hp : 0 < p) :
    RHasDerivAt (factor p) (Real.log p) 0 := by
  have hneg : RHasDerivAt (fun k : ℝ => -k) (-1) 0 := (hasDerivAt_id 0).neg
  have hpR : (0 : ℝ) < (p : ℝ) := by exact_mod_cast hp
  have hrpow : RHasDerivAt (fun k : ℝ => (p : ℝ) ^ (-k)) (-Real.log p) 0 := by
    simpa using hneg.const_rpow hpR
  unfold factor
  convert (hasDerivAt_const (x := (0 : ℝ)) (c := (1 : ℝ))).sub hrpow using 1
  · rfl
  · ring

private lemma hasDerivAt_primeFactorProduct_of_two_le_card (n : ℕ)
    (hcard : 2 ≤ n.primeFactors.card) :
    RHasDerivAt (fun k : ℝ => ∏ p ∈ n.primeFactors, factor p k) 0 0 := by
  have hnontrivial : n.primeFactors.Nontrivial := by
    rw [← Finset.one_lt_card_iff_nontrivial]
    omega
  obtain ⟨p, hp, q, hq, hpq⟩ := hnontrivial
  have hqerase : q ∈ n.primeFactors.erase p := Finset.mem_erase.mpr ⟨hpq.symm, hq⟩
  have hpderiv := hasDerivAt_factor p (Nat.Prime.pos (Nat.prime_of_mem_primeFactors hp))
  have hqderiv := hasDerivAt_factor q (Nat.Prime.pos (Nat.prime_of_mem_primeFactors hq))
  have hpair : RHasDerivAt (fun k : ℝ => factor p k * factor q k) 0 0 := by
    convert hpderiv.mul hqderiv using 1
    · rfl
    · simp [factor]
  have hrest : DifferentiableAt ℝ
      (fun k : ℝ => ∏ r ∈ (n.primeFactors.erase p).erase q, factor r k) 0 := by
    apply DifferentiableAt.fun_finsetProd
    intro r hr
    exact (hasDerivAt_factor r
      (Nat.Prime.pos (Nat.prime_of_mem_primeFactors (Finset.mem_of_mem_erase
        (Finset.mem_of_mem_erase hr))))).differentiableAt
  have hrewrite :
      (fun k : ℝ => ∏ r ∈ n.primeFactors, factor r k) =
        fun k => (factor p k * factor q k) *
          ∏ r ∈ (n.primeFactors.erase p).erase q, factor r k := by
    funext k
    rw [← Finset.mul_prod_erase n.primeFactors
      (fun r => factor r k) hp]
    rw [← Finset.mul_prod_erase (n.primeFactors.erase p)
      (fun r => factor r k) hqerase]
    ring
  rw [hrewrite]
  convert hpair.mul hrest.hasDerivAt using 1
  · rfl
  · simp [factor]

private lemma primeFactorProduct_zero_of_pos (n : ℕ) (hn : 0 < n) (hne : n ≠ 1) :
    (∏ p ∈ n.primeFactors, factor p 0) = 0 := by
  have hpf : n.primeFactors.Nonempty := by
    rw [Finset.nonempty_iff_ne_empty]
    intro hempty
    rcases Nat.primeFactors_eq_empty.mp hempty with hzero | hone
    · omega
    · exact hne hone
  obtain ⟨p, hp⟩ := hpf
  rw [Finset.prod_eq_zero_iff]
  exact ⟨p, hp, by simp [factor]⟩

/-- If `n` has at least two distinct prime factors, its cototient derivative at zero is `log n`. -/
theorem hasDerivAt_CoJ_of_two_le_card (n : ℕ)
    (hn : 1 ≤ n) (hcard : 2 ≤ n.primeFactors.card) :
    RHasDerivAt (fun k : ℝ => CoJ k n) (Real.log n) 0 := by
  have hnpos : (0 : ℝ) < n := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hn)
  have hn1 : n ≠ 1 := by
    intro h
    subst n
    simp at hcard
  have hpow : RHasDerivAt (fun k : ℝ => (n : ℝ) ^ k) (Real.log n) 0 := by
    convert (hasDerivAt_id (x := (0 : ℝ))).const_rpow hnpos using 1 <;> simp
  have hprod := hasDerivAt_primeFactorProduct_of_two_le_card n hcard
  have hJ : RHasDerivAt (fun k : ℝ => J k n) 0 0 := by
    unfold J
    convert hpow.mul hprod using 1
    · rfl
    · rw [primeFactorProduct_zero_of_pos n (by omega) hn1]
      simp
  unfold CoJ
  convert hpow.sub hJ using 1
  · rfl
  · ring

/-- If `n` has the single prime factor `p`, its cototient derivative at zero is
`log n - log p`. -/
theorem hasDerivAt_CoJ_of_primeFactors_eq_singleton (n p : ℕ)
    (hn : 1 ≤ n) (hpfs : n.primeFactors = {p}) :
    RHasDerivAt (fun k : ℝ => CoJ k n) (Real.log n - Real.log p) 0 := by
  have hnpos : (0 : ℝ) < n := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hn)
  have hpMem : p ∈ n.primeFactors := by simp [hpfs]
  have hpPrime : Nat.Prime p := Nat.prime_of_mem_primeFactors hpMem
  have hpow : RHasDerivAt (fun k : ℝ => (n : ℝ) ^ k) (Real.log n) 0 := by
    convert (hasDerivAt_id (x := (0 : ℝ))).const_rpow hnpos using 1 <;> simp
  have hfactor := hasDerivAt_factor p hpPrime.pos
  have hJ : RHasDerivAt (fun k : ℝ => J k n) (Real.log p) 0 := by
    simp only [J, hpfs, Finset.prod_singleton]
    convert hpow.mul hfactor using 1
    · rfl
    · simp [factor]
  unfold CoJ
  exact hpow.sub hJ

private lemma coJ_zero_of_one_lt (n : ℕ) (hn : 1 < n) : CoJ 0 n = 1 := by
  change (n : ℝ) ^ (0 : ℝ) -
    (n : ℝ) ^ (0 : ℝ) * ∏ p ∈ n.primeFactors, factor p 0 = 1
  rw [primeFactorProduct_zero_of_pos n (by omega) (by omega)]
  simp

private lemma eventually_pos_of_hasDerivAt_pos {f : ℝ → ℝ} {d : ℝ}
    (hf : RHasDerivAt f d 0) (hd : 0 < d) (h0 : f 0 = 0) :
    ∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → 0 < f k := by
  have hevent : ∀ᶠ k in 𝓝 (0 : ℝ), SignType.sign (f k) = SignType.sign (k - 0) :=
    eventually_nhdsWithin_sign_eq_of_deriv_pos (hf.deriv ▸ hd) h0
  rw [Metric.eventually_nhds_iff] at hevent
  obtain ⟨ε, hε, hevent⟩ := hevent
  refine ⟨ε, hε, ?_⟩
  intro k hk hkε
  have hdist : dist k 0 < ε := by simpa [Real.dist_eq, abs_of_pos hk] using hkε
  have hsign := hevent hdist
  rw [sub_zero, sign_pos hk] at hsign
  exact sign_eq_one_iff.mp hsign

private lemma eventually_CoJ_lt_of_deriv_lt {m n : ℕ}
    (hm : 1 < m) (hn : 1 < n) {dm dn : ℝ}
    (hdm : RHasDerivAt (fun k : ℝ => CoJ k m) dm 0)
    (hdn : RHasDerivAt (fun k : ℝ => CoJ k n) dn 0)
    (hlt : dm < dn) :
    ∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → CoJ k m < CoJ k n := by
  have hderiv : RHasDerivAt (fun k : ℝ => CoJ k n - CoJ k m) (dn - dm) 0 :=
    hdn.sub hdm
  have hzero : CoJ 0 n - CoJ 0 m = 0 := by
    rw [coJ_zero_of_one_lt n hn, coJ_zero_of_one_lt m hm]
    ring
  simpa [sub_pos] using eventually_pos_of_hasDerivAt_pos hderiv (sub_pos.mpr hlt) hzero

private lemma eventuallyWithin_CoJ_lt_of_deriv_lt {m n : ℕ}
    (hm : 1 < m) (hn : 1 < n) {dm dn : ℝ}
    (hdm : RHasDerivAt (fun k : ℝ => CoJ k m) dm 0)
    (hdn : RHasDerivAt (fun k : ℝ => CoJ k n) dn 0)
    (hlt : dm < dn) :
    ∀ᶠ k : ℝ in nhdsWithin 0 (Set.Ioi 0), CoJ k m < CoJ k n := by
  obtain ⟨ε, hε, hεlt⟩ := eventually_CoJ_lt_of_deriv_lt hm hn hdm hdn hlt
  change {k : ℝ | CoJ k m < CoJ k n} ∈ nhdsWithin 0 (Set.Ioi 0)
  rw [Metric.mem_nhdsWithin_iff]
  refine ⟨ε, hε, ?_⟩
  intro k hk
  have hkpos : 0 < k := hk.2
  exact hεlt k hkpos (by simpa [Real.dist_eq, abs_of_pos hkpos] using hk.1)

/-- An input with at least two distinct prime factors is a strict cototient record throughout
some punctured right neighborhood of zero. -/
theorem eventual_record_of_two_le_primeFactors_card
    (n : ℕ) (hn : 1 ≤ n) (hcard : 2 ≤ n.primeFactors.card) :
    ∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → StrictRecord k n := by
  have hn_ne_one : n ≠ 1 := by
    intro hn1
    subst n
    simp at hcard
  have hnlt : 1 < n := by omega
  have hdn := hasDerivAt_CoJ_of_two_le_card n hn hcard
  have hAll :
      ∀ᶠ k : ℝ in nhdsWithin 0 (Set.Ioi 0),
        ∀ m ∈ Finset.Ico 1 n, CoJ k m < CoJ k n := by
    rw [Finset.eventually_all]
    intro m hm
    rcases Finset.mem_Ico.mp hm with ⟨hm1, hmn⟩
    by_cases hmone : m = 1
    · subst m
      have hpos : ∀ᶠ k : ℝ in nhds 0, 0 < CoJ k n :=
        continuousAt_const.eventually_lt hdn.continuousAt (by
          simp [coJ_zero_of_one_lt n hnlt])
      exact (hpos.filter_mono inf_le_left).mono fun k hk => by
        simpa [coJ_one] using hk
    · have hmlt : 1 < m := lt_of_le_of_ne hm1 (Ne.symm hmone)
      have hmR : (0 : ℝ) < m := by exact_mod_cast (by omega : 0 < m)
      have hnR : (0 : ℝ) < n := by exact_mod_cast (by omega : 0 < n)
      have hmnR : (m : ℝ) < n := by exact_mod_cast hmn
      have hlogmn : Real.log m < Real.log n :=
        Real.strictMonoOn_log hmR hnR hmnR
      have hmPfNonempty : m.primeFactors.Nonempty := by
        rw [Finset.nonempty_iff_ne_empty]
        intro hempty
        rcases Nat.primeFactors_eq_empty.mp hempty with hmzero | hmone'
        · omega
        · exact hmone hmone'
      have hmCardPos : 0 < m.primeFactors.card := Finset.card_pos.mpr hmPfNonempty
      rcases (show m.primeFactors.card = 1 ∨ 2 ≤ m.primeFactors.card by omega) with
        hmCardOne | hmCardTwo
      · obtain ⟨p, hpfs⟩ := Finset.card_eq_one.mp hmCardOne
        have hpMem : p ∈ m.primeFactors := by simp [hpfs]
        have hpPrime : Nat.Prime p := Nat.prime_of_mem_primeFactors hpMem
        have hdm := hasDerivAt_CoJ_of_primeFactors_eq_singleton m p (by omega) hpfs
        exact eventuallyWithin_CoJ_lt_of_deriv_lt hmlt hnlt hdm hdn
          (lt_trans (sub_lt_self _ hpPrime.log_pos) hlogmn)
      · have hdm := hasDerivAt_CoJ_of_two_le_card m (by omega) hmCardTwo
        exact eventuallyWithin_CoJ_lt_of_deriv_lt hmlt hnlt hdm hdn hlogmn
  change {k : ℝ | ∀ m ∈ Finset.Ico 1 n, CoJ k m < CoJ k n} ∈
    nhdsWithin 0 (Set.Ioi 0) at hAll
  rw [Metric.mem_nhdsWithin_iff] at hAll
  obtain ⟨ε, hε, hsub⟩ := hAll
  refine ⟨ε, hε, ?_⟩
  intro k hkpos hkε m hm1 hmn
  apply hsub ⟨?_, hkpos⟩ m (Finset.mem_Ico.mpr ⟨hm1, hmn⟩)
  simpa [Real.dist_eq, abs_of_pos hkpos] using hkε

private lemma coJ_four (k : ℝ) : CoJ k 4 = (2 : ℝ) ^ k := by
  have hfour : (4 : ℕ).primeFactors = {2} := by
    rw [show (4 : ℕ) = 2 ^ 2 by norm_num,
      Nat.primeFactors_prime_pow (by norm_num) Nat.prime_two]
  have htwoR : (0 : ℝ) < 2 := by norm_num
  simp only [CoJ, J, hfour, Finset.prod_singleton]
  ring_nf
  rw [show (4 : ℝ) = 2 * 2 by norm_num, Real.mul_rpow (by positivity) (by positivity)]
  rw [mul_assoc, ← Real.rpow_add htwoR]
  simp

/-- One is an eventual strict record; its predecessor condition is empty. -/
theorem eventual_record_one :
    ∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → StrictRecord k 1 := by
  refine ⟨1, by norm_num, ?_⟩
  intro k hk hkε m hm hmlt
  omega

/-- Two is an eventual strict record because its cototient is one and that of one is zero. -/
theorem eventual_record_two :
    ∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → StrictRecord k 2 := by
  refine ⟨1, by norm_num, ?_⟩
  intro k hk hkε m hm hmlt
  have hm1 : m = 1 := by omega
  subst m
  rw [coJ_one, coJ_prime Nat.prime_two]
  norm_num

/-- Four is an eventual strict record because its cototient is `2^k`, while the preceding primes
have cototient one. -/
theorem eventual_record_four :
    ∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → StrictRecord k 4 := by
  refine ⟨1, by norm_num, ?_⟩
  intro k hk hkε m hm hmlt
  have hm_cases : m = 1 ∨ m = 2 ∨ m = 3 := by omega
  rcases hm_cases with rfl | rfl | rfl
  · rw [coJ_one, coJ_four]
    positivity
  · rw [coJ_prime Nat.prime_two, coJ_four]
    exact Real.one_lt_rpow (by norm_num) hk
  · rw [coJ_prime Nat.prime_three, coJ_four]
    exact Real.one_lt_rpow (by norm_num) hk

private lemma not_eventual_record_of_eventually_beaten {m n : ℕ}
    (hm : 1 ≤ m) (hmn : m < n)
    (hbeat : ∃ δ > 0, ∀ k : ℝ, 0 < k → k < δ → CoJ k n < CoJ k m) :
    ¬ ∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → StrictRecord k n := by
  rintro ⟨ε, hε, hrecord⟩
  obtain ⟨δ, hδ, hbeat⟩ := hbeat
  let k : ℝ := min ε δ / 2
  have hk : 0 < k := div_pos (lt_min hε hδ) (by norm_num)
  have hkε : k < ε := by
    dsimp [k]
    nlinarith [min_le_left ε δ]
  have hkδ : k < δ := by
    dsimp [k]
    nlinarith [min_le_right ε δ]
  exact (hrecord k hk hkε m hm hmn).asymm (hbeat k hk hkδ)

/-- No positive power of an odd prime is an eventual strict record near zero. -/
theorem not_eventual_record_odd_prime_pow (p a : ℕ) (hp : p.Prime)
    (hpodd : Odd p) (ha : 0 < a) :
    ¬ ∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → StrictRecord k (p ^ a) := by
  by_cases ha1 : a = 1
  · subst a
    rintro ⟨ε, hε, hrecord⟩
    have hp3 : 3 ≤ p := hp.odd_iff.mp hpodd
    let k : ℝ := ε / 2
    have hk : 0 < k := div_pos hε (by norm_num)
    have hkε : k < ε := by dsimp [k]; linarith
    have hlt : CoJ k 2 < CoJ k p := by
      simpa only [pow_one] using hrecord k hk hkε 2 (by omega)
        (by simpa using (show 2 < p by omega))
    rw [coJ_prime Nat.prime_two, coJ_prime hp] at hlt
    exact (lt_irrefl 1 hlt)
  · have ha2 : 2 ≤ a := by omega
    let m := 2 * p ^ (a - 1)
    have hpne : p ≠ 2 := by
      have hp3 : 3 ≤ p := hp.odd_iff.mp hpodd
      omega
    have hp2 : 2 < p := hp.two_le.lt_of_ne (Ne.symm hpne)
    have hexp : a - 1 ≠ 0 := by omega
    have hpow : p ^ a = p * p ^ (a - 1) := by
      rw [← pow_succ']
      congr 1
      omega
    have hpowpos : 0 < p ^ (a - 1) := Nat.pow_pos hp.pos
    have hmpos : 0 < m := by dsimp [m]; omega
    have hm1 : 1 < m := by omega
    have hmn : m < p ^ a := by
      rw [hpow]
      exact (Nat.mul_lt_mul_right hpowpos).2 hp2
    have hmcard : 2 ≤ m.primeFactors.card := by
      have hmpf : m.primeFactors = {2, p} := by
        dsimp [m]
        rw [Nat.primeFactors_mul (by norm_num) (pow_ne_zero _ hp.ne_zero),
          Nat.primeFactors_prime_pow hexp hp, Nat.prime_two.primeFactors]
        ext q
        simp
      rw [hmpf]
      have h2p : 2 ≠ p := Ne.symm hpne
      simp [h2p]
    have hncard : (p ^ a).primeFactors = {p} :=
      Nat.primeFactors_prime_pow ha.ne' hp
    have hdn := hasDerivAt_CoJ_of_primeFactors_eq_singleton (p ^ a) p
      (by omega) hncard
    have hdm := hasDerivAt_CoJ_of_two_le_card m hm1.le hmcard
    have hbase : p ^ (a - 1) < m := by
      dsimp [m]
      simpa only [one_mul] using
        (Nat.mul_lt_mul_right hpowpos).2 (by norm_num : 1 < 2)
    have hlog : Real.log (p ^ (a - 1) : ℕ) < Real.log m := by
      exact Real.strictMonoOn_log
        (show (0 : ℝ) < (p ^ (a - 1) : ℕ) by exact_mod_cast hpowpos)
        (show (0 : ℝ) < m by exact_mod_cast hmpos) (by exact_mod_cast hbase)
    have hderiv : Real.log (p ^ a : ℕ) - Real.log p < Real.log m := by
      rw [hpow, Nat.cast_mul, Real.log_mul (by exact_mod_cast hp.ne_zero)
        (by exact_mod_cast (Nat.ne_of_gt hpowpos))]
      linarith
    exact not_eventual_record_of_eventually_beaten hm1.le hmn
      (eventually_CoJ_lt_of_deriv_lt (by omega) hm1 hdn hdm hderiv)

/-- Every power `2^a` with `a ≥ 3` is eventually beaten near zero by `3 * 2^(a-2)`. -/
theorem not_eventual_record_two_pow (a : ℕ) (ha : 3 ≤ a) :
    ¬ ∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → StrictRecord k (2 ^ a) := by
  let m := 3 * 2 ^ (a - 2)
  have hexp : a - 2 ≠ 0 := by omega
  have hpowpos : 0 < 2 ^ (a - 2) := Nat.pow_pos (by norm_num)
  have hmpos : 0 < m := by dsimp [m]; omega
  have hm1 : 1 < m := by omega
  have hpow_one : 2 ^ a = 2 * 2 ^ (a - 1) := by
    rw [← pow_succ']
    congr 1
    omega
  have hpow_two : 2 ^ a = 4 * 2 ^ (a - 2) := by
    calc
      2 ^ a = 2 ^ (2 + (a - 2)) := by congr 1; omega
      _ = 4 * 2 ^ (a - 2) := by rw [pow_add]; norm_num
  have hmn : m < 2 ^ a := by
    rw [hpow_two]
    exact (Nat.mul_lt_mul_right hpowpos).2 (by norm_num)
  have hmcard : 2 ≤ m.primeFactors.card := by
    have hmpf : m.primeFactors = {3, 2} := by
      dsimp [m]
      rw [Nat.primeFactors_mul (by norm_num) (pow_ne_zero _ (by norm_num)),
        Nat.primeFactors_prime_pow hexp Nat.prime_two, Nat.prime_three.primeFactors]
      ext q
      simp
    rw [hmpf]
    norm_num
  have hncard : (2 ^ a).primeFactors = {2} :=
    Nat.primeFactors_prime_pow (by omega) Nat.prime_two
  have hdn := hasDerivAt_CoJ_of_primeFactors_eq_singleton (2 ^ a) 2
    (by omega) hncard
  have hdm := hasDerivAt_CoJ_of_two_le_card m hm1.le hmcard
  have hbase_split : 2 ^ (a - 1) = 2 * 2 ^ (a - 2) := by
    rw [← pow_succ']
    congr 1
    omega
  have hbase : 2 ^ (a - 1) < m := by
    rw [hbase_split]
    dsimp [m]
    exact (Nat.mul_lt_mul_right hpowpos).2 (by norm_num)
  have hlog : Real.log (2 ^ (a - 1) : ℕ) < Real.log m := by
    exact Real.strictMonoOn_log (show (0 : ℝ) < (2 ^ (a - 1) : ℕ) by positivity)
      (show (0 : ℝ) < m by exact_mod_cast hmpos) (by exact_mod_cast hbase)
  have hderiv : Real.log (2 ^ a : ℕ) - Real.log 2 < Real.log m := by
    calc
      Real.log (2 ^ a : ℕ) - Real.log 2 = Real.log (2 ^ (a - 1) : ℕ) := by
        rw [hpow_one, Nat.cast_mul, Real.log_mul (by norm_num) (by positivity)]
        ring
      _ < Real.log m := hlog
  exact not_eventual_record_of_eventually_beaten hm1.le hmn
    (eventually_CoJ_lt_of_deriv_lt (by omega) hm1 hdn hdm hderiv)

/-- For every positive natural input, eventual strict Jordan-cototient record status near zero is
equivalent to being `1`, `2`, `4`, or having at least two distinct prime factors. -/
theorem a387335_eventual_record_iff : ∀ n : ℕ, 1 ≤ n →
    ((∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → StrictRecord k n) ↔
      (n = 1 ∨ n = 2 ∨ n = 4 ∨ 2 ≤ n.primeFactors.card)) := by
  intro n hn
  constructor
  · intro hevent
    by_cases hn1 : n = 1
    · exact Or.inl hn1
    by_cases hn2 : n = 2
    · exact Or.inr (Or.inl hn2)
    by_cases hn4 : n = 4
    · exact Or.inr (Or.inr (Or.inl hn4))
    by_cases hcard : 2 ≤ n.primeFactors.card
    · exact Or.inr (Or.inr (Or.inr hcard))
    exfalso
    have hpfs : n.primeFactors.Nonempty := by
      rw [Finset.nonempty_iff_ne_empty]
      intro hempty
      rcases Nat.primeFactors_eq_empty.mp hempty with hn0 | hn1'
      · omega
      · exact hn1 hn1'
    have hcardpos : 0 < n.primeFactors.card := Finset.card_pos.mpr hpfs
    have hcardone : n.primeFactors.card = 1 := by omega
    have hnpp : IsPrimePow n := isPrimePow_iff_card_primeFactors_eq_one.mpr hcardone
    rcases (isPrimePow_nat_iff n).mp hnpp with ⟨p, a, hp, ha, hpow⟩
    subst n
    rcases hp.eq_two_or_odd' with hp2 | hpodd
    · subst p
      have ha1 : a ≠ 1 := by
        intro h
        subst a
        simp at hn2
      have ha2 : a ≠ 2 := by
        intro h
        subst a
        norm_num at hn4
      exact not_eventual_record_two_pow a (by omega) hevent
    · exact not_eventual_record_odd_prime_pow p a hp hpodd ha hevent
  · rintro (rfl | rfl | rfl | hcard)
    · exact eventual_record_one
    · exact eventual_record_two
    · exact eventual_record_four
    · exact eventual_record_of_two_le_primeFactors_card n hn hcard

example : 1 ≤ (6 : ℕ) := by norm_num
example : 2 ≤ (6 : ℕ).primeFactors.card := by
  have hpf : (6 : ℕ).primeFactors = {2, 3} := by
    rw [show (6 : ℕ) = 2 * 3 by norm_num,
      Nat.primeFactors_mul (by norm_num) (by norm_num),
      Nat.prime_two.primeFactors, Nat.prime_three.primeFactors]
    ext q
    simp
  rw [hpf]
  norm_num
example : ∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → StrictRecord k 6 := by
  apply eventual_record_of_two_le_primeFactors_card 6 (by norm_num)
  have hpf : (6 : ℕ).primeFactors = {2, 3} := by
    rw [show (6 : ℕ) = 2 * 3 by norm_num,
      Nat.primeFactors_mul (by norm_num) (by norm_num),
      Nat.prime_two.primeFactors, Nat.prime_three.primeFactors]
    ext q
    simp
  rw [hpf]
  norm_num
example :
    ((∃ ε > 0, ∀ k : ℝ, 0 < k → k < ε → StrictRecord k 8) ↔
      (8 = 1 ∨ 8 = 2 ∨ 8 = 4 ∨ 2 ≤ (8 : ℕ).primeFactors.card)) :=
  a387335_eventual_record_iff 8 (by norm_num)

end D5.S3.Factorization.JordanCototientRecordLimitZero
