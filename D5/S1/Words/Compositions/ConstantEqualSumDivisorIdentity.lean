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
end D5.S1.Words.Compositions.ConstantEqualSumDivisorIdentity
