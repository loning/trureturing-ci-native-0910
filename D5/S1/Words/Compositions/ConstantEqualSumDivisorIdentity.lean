/- GID: D5/S1/Words/Compositions/ConstantEqualSumDivisorIdentity
   generality: G
   mirror-B: D5/B/S1/Words/Compositions/ConstantEqualSumDivisorIdentity
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Equal-sum constant-block systems normalize uniquely by their support lcm. -/

import Mathlib.Combinatorics.Enumerative.Partition.Basic
import Mathlib.Algebra.GCDMonoid.Multiset
import Mathlib.Algebra.GCDMonoid.Nat
import Mathlib.Tactic
import Mathlib.NumberTheory.Divisors
import Mathlib.SetTheory.Cardinal.Finite

open scoped BigOperators
namespace D5.S1.Words.Compositions.ConstantEqualSumDivisorIdentity

/-- Every value divides the proposed block sum, and its total contribution is a multiple of it. -/
def Admits (m : Multiset ℕ) (D : ℕ) : Prop :=
  ∀ x ∈ m, x ∣ D ∧ D ∣ x * m.count x

def Capable (m : Multiset ℕ) : Prop := ∃ D, 0 < D ∧ Admits m D
noncomputable def capablePartitionCount (n : ℕ) : ℕ :=
  Nat.card {p : Nat.Partition n // Capable p.parts}

/-- A nonempty system is encoded by its flattened partition and common block sum.
For a value x there are count(x)/(D/x) identical blocks of D/x copies of x. -/
def System (n : ℕ) := {p : Nat.Partition n × ℕ // 0 < p.2 ∧ Admits p.1.parts p.2}
noncomputable def constantEqualSumSystemCount (n : ℕ) : ℕ :=
  if n = 0 then 1 else Nat.card (System n)

private theorem lcm_pos {m : Multiset ℕ} (hp : ∀ x ∈ m, 0 < x) : 0 < m.lcm := by
  apply Nat.pos_of_ne_zero
  exact (Multiset.lcm_ne_zero_iff m).mpr (fun h => (Nat.lt_irrefl 0) (hp 0 h))

private theorem lcm_smul (m : Multiset ℕ) {t : ℕ} (ht : 0 < t) :
    (t • m).lcm = m.lcm := by
  apply Nat.dvd_antisymm
  · exact Multiset.lcm_dvd.mpr (fun x hx => Multiset.dvd_lcm (Multiset.mem_of_mem_nsmul hx))
  · exact Multiset.lcm_dvd.mpr (fun x hx => Multiset.dvd_lcm
      ((Multiset.mem_nsmul_of_ne_zero ht.ne').mpr hx))

private theorem canonical {m : Multiset ℕ} (h : Capable m) : Admits m m.lcm := by
  obtain ⟨D, _, hD⟩ := h
  have hL : m.lcm ∣ D := Multiset.lcm_dvd.mpr (fun x hx => (hD x hx).1)
  exact fun x hx => ⟨Multiset.dvd_lcm hx, hL.trans (hD x hx).2⟩

private theorem admits_smul {m : Multiset ℕ} {D t : ℕ} (h : Admits m D) :
    Admits (t • m) (t * D) := by
  intro x hx
  have hxm := Multiset.mem_of_mem_nsmul hx
  refine ⟨(h x hxm).1.trans (dvd_mul_left D t), ?_⟩
  rw [Multiset.count_nsmul, ← mul_assoc, mul_comm x t, mul_assoc]
  exact Nat.mul_dvd_mul_left t (h x hxm).2

private theorem normalize {m : Multiset ℕ} {D : ℕ}
    (hp : ∀ x ∈ m, 0 < x) (hD : 0 < D) (h : Admits m D) :
    ∃ t u, 0 < t ∧ m = t • u ∧ D = t * u.lcm ∧ Capable u := by
  have hL : m.lcm ∣ D := Multiset.lcm_dvd.mpr (fun x hx => (h x hx).1)
  obtain ⟨t, he⟩ := hL
  have ht : 0 < t := by nlinarith
  have hc : ∀ x ∈ m, t ∣ m.count x := by
    intro x hx
    have hxL := Multiset.dvd_lcm hx
    obtain ⟨k, hk⟩ := hxL
    have hd := (h x hx).2
    rw [he, hk] at hd
    have hxt : x * t ∣ x * m.count x :=
      (show x * t ∣ x * k * t by use k; ring).trans hd
    exact (Nat.dvd_of_mul_dvd_mul_left (hp x hx) hxt)
  obtain ⟨u, hu⟩ := Multiset.exists_smul_of_dvd_count m hc
  have hul : u.lcm = m.lcm := by rw [hu, lcm_smul u ht]
  refine ⟨t, u, ht, hu, ?_, u.lcm, ?_, ?_⟩
  · rw [hul, he, mul_comm]
  · rw [hul]; exact lcm_pos hp
  · intro x hx
    have hxm : x ∈ m := by rw [hu]; exact (Multiset.mem_nsmul_of_ne_zero ht.ne').mpr hx
    refine ⟨Multiset.dvd_lcm hx, ?_⟩
    have hd := (h x hxm).2
    rw [hu, Multiset.count_nsmul, he, ← hul] at hd
    have hd' : t * u.lcm ∣ t * (x * u.count x) := by
      convert hd using 1 <;> ring
    exact Nat.dvd_of_mul_dvd_mul_left ht hd'

private def DivisorPartitions (n : ℕ) :=
  (d : {d : ℕ // d ∈ n.divisors}) × {p : Nat.Partition d.val // Capable p.parts}

private theorem quotient_pos {n d : ℕ} (hn : 0 < n) (hd : d ∈ n.divisors) :
    0 < n / d := Nat.div_pos (Nat.le_of_dvd hn (Nat.dvd_of_mem_divisors hd))
      (Nat.pos_of_mem_divisors hd)

private def liftPartition {n d : ℕ} (hd : d ∈ n.divisors) (p : Nat.Partition d) :
    Nat.Partition n where
  parts := (n / d) • p.parts
  parts_pos hx := p.parts_pos (Multiset.mem_of_mem_nsmul hx)
  parts_sum := by
    rw [Multiset.sum_nsmul, smul_eq_mul, p.parts_sum,
      Nat.div_mul_cancel (Nat.dvd_of_mem_divisors hd)]

private def liftSystem {n : ℕ} (hn : 0 < n) (a : DivisorPartitions n) : System n :=
  ⟨(liftPartition a.1.2 a.2.1, (n / a.1.1) * a.2.1.parts.lcm),
    Nat.mul_pos (quotient_pos hn a.1.2) (lcm_pos (fun _ hx => a.2.1.parts_pos hx)),
    admits_smul (canonical a.2.2)⟩

private theorem liftSystem_injective {n : ℕ} (hn : 0 < n) :
    Function.Injective (liftSystem hn) := by
  rintro ⟨⟨d, hd⟩, p⟩ ⟨⟨e, he⟩, q⟩ h
  have hm : (n/d) • p.1.parts = (n/e) • q.1.parts :=
    congrArg (fun s : System n => s.1.1.parts) h
  have hD : (n/d) * p.1.parts.lcm = (n/e) * q.1.parts.lcm :=
    congrArg (fun s : System n => s.1.2) h
  have hL : p.1.parts.lcm = q.1.parts.lcm := by
    simpa only [lcm_smul _ (quotient_pos hn hd), lcm_smul _ (quotient_pos hn he)]
      using congrArg Multiset.lcm hm
  rw [← hL] at hD
  have ht : n/d = n/e := Nat.eq_of_mul_eq_mul_right
    (lcm_pos (fun _ hx => p.1.parts_pos hx)) hD
  have hde : d = e := by
    apply Nat.eq_of_mul_eq_mul_left (quotient_pos hn hd)
    rw [Nat.div_mul_cancel (Nat.dvd_of_mem_divisors hd), ht,
      Nat.div_mul_cancel (Nat.dvd_of_mem_divisors he)]
  subst e
  have hpq : p = q := by
    apply Subtype.ext
    apply Nat.Partition.ext
    exact (nsmul_right_injective (quotient_pos hn hd).ne') hm
  cases hpq
  rfl

private theorem liftSystem_surjective {n : ℕ} (hn : 0 < n) :
    Function.Surjective (liftSystem hn) := by
  rintro ⟨⟨p, D⟩, hD, h⟩
  obtain ⟨t, u, ht, hm, hDu, hu⟩ := normalize (fun _ hx => p.parts_pos hx) hD h
  have hsum : t * u.sum = n := by
    simpa only [hm, Multiset.sum_nsmul, smul_eq_mul] using p.parts_sum
  have hud : u.sum ∈ n.divisors :=
    Nat.mem_divisors.mpr ⟨⟨t, by simpa [mul_comm] using hsum.symm⟩, hn.ne'⟩
  have hup : 0 < u.sum := by nlinarith
  have htq : n / u.sum = t := by rw [← hsum, Nat.mul_div_cancel _ hup]
  let q : Nat.Partition u.sum := ⟨u, fun hx => p.parts_pos
    (by rw [hm]; exact (Multiset.mem_nsmul_of_ne_zero ht.ne').mpr hx), rfl⟩
  refine ⟨⟨⟨u.sum, hud⟩, ⟨q, hu⟩⟩, ?_⟩
  apply Subtype.ext
  apply Prod.ext
  · apply Nat.Partition.ext
    exact (by change (n / u.sum) • u = p.parts; rw [htq, ← hm])
  · change n / u.sum * u.lcm = D
    rw [htq]
    exact hDu.symm

private theorem encoded_divisor_sum (n : ℕ) (hn : 0 < n) :
    (∑ d ∈ n.divisors, capablePartitionCount d) = Nat.card (System n) := by
  classical
  let e := Equiv.ofBijective (liftSystem hn)
    ⟨liftSystem_injective hn, liftSystem_surjective hn⟩
  have h := Nat.card_congr e
  change Nat.card (DivisorPartitions n) = _ at h
  rw [DivisorPartitions, Nat.card_sigma] at h
  exact (Finset.sum_subtype n.divisors (fun _ => Iff.rfl) capablePartitionCount).trans h

end D5.S1.Words.Compositions.ConstantEqualSumDivisorIdentity
