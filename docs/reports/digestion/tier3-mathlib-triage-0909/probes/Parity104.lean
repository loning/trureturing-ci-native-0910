import Mathlib

namespace Triage104

open ArithmeticFunction

noncomputable def Gamma (f : Nat -> Complex) (d : Nat) : Complex :=
  (-1 : Complex) ^ cardFactors d * f d

def reflect (N : Nat) (f : Nat -> Complex) (d : Nat) : Complex := f (N / d)

theorem complement_parity (N d : Nat) (hN : Ne N 0) (hd : d ∣ N)
    (f : Nat -> Complex) :
    Gamma (reflect N f) d = (-1 : Complex) ^ cardFactors N * reflect N (Gamma f) d := by
  have hprod : d * (N / d) = N := Nat.mul_div_cancel' hd
  have hd0 : Ne d 0 := by
    intro h
    apply hN
    rw [← hprod, h, zero_mul]
  have hq0 : Ne (N / d) 0 := by
    intro h
    apply hN
    rw [← hprod, h, mul_zero]
  have hOmega := cardFactors_mul hd0 hq0
  rw [hprod] at hOmega
  dsimp [Gamma, reflect]
  rw [hOmega, pow_add]
  have hsq : (-1 : Complex) ^ cardFactors (N / d) *
      (-1 : Complex) ^ cardFactors (N / d) = 1 := by
    rw [← pow_add, ← two_mul, pow_mul]
    norm_num
  calc
    (-1 : Complex) ^ cardFactors d * f (N / d) =
        ((-1 : Complex) ^ cardFactors d *
          ((-1 : Complex) ^ cardFactors (N / d) * (-1 : Complex) ^ cardFactors (N / d))) *
            f (N / d) := by rw [hsq, mul_one]
    _ = _ := by ring

#print axioms complement_parity

end Triage104
