import Mathlib
namespace A110037Parity
variable (B : ℕ → ℕ)
variable (b2 : B 2 = 1)
variable (odd : ∀ m, 0 < m → B (2*m+1) = B (2*m) + 1)
variable (step : ∀ m, 0 < m → B (2*(m+1)) = B (2*m) + B (m+1))

include b2 odd step

private theorem four_two : ∀ m, B (4*m+2) % 2 = (m+1) % 2 := by
  intro m
  induction m with
  | zero => simpa using congrArg (fun x => x % 2) b2
  | succ m ih =>
    have h1 := step (2*m+1) (by omega)
    have h2 := step (2*m+2) (by omega)
    have ho := odd (m+1) (by omega)
    have e1 : 2*(2*m+1) = 4*m+2 := by omega
    have e2 : 2*((2*m+1)+1) = 4*m+4 := by omega
    have e3 : 2*(2*m+2) = 4*m+4 := by omega
    have e4 : 2*((2*m+2)+1) = 4*(m+1)+2 := by omega
    have e5 : 2*m+1+1 = 2*(m+1) := by omega
    have e6 : 2*m+2+1 = 2*(m+1)+1 := by omega
    rw [e1, e2, e5] at h1
    rw [e3, e4, e6] at h2
    omega

private theorem four (m : ℕ) (hm : 0 < m) :
    B (4*m) % 2 = (m + B (2*m)) % 2 := by
  have h := step (2*m-1) (by omega)
  have ht := four_two B b2 odd step (m-1)
  rw [show 2*(2*m-1+1) = 4*m by omega,
    show 2*(2*m-1) = 4*(m-1)+2 by omega,
    show 2*m-1+1 = 2*m by omega] at h
  omega

private theorem eight_two (m : ℕ) : B (8*m+2)%2=1 := by
  have h := four_two B b2 odd step (2*m)
  rw [show 4*(2*m)+2=8*m+2 by omega] at h
  omega

private theorem eight_six (m : ℕ) : B (8*m+6)%2=0 := by
  have h := four_two B b2 odd step (2*m+1)
  rw [show 4*(2*m+1)+2=8*m+6 by omega] at h
  omega

private theorem sixteen_four (m : ℕ) : B (16*m+4)%2=0 := by
  have h := four B b2 odd step (4*m+1) (by omega)
  have h2 := eight_two B b2 odd step m
  rw [show 4*(4*m+1)=16*m+4 by omega,
    show 2*(4*m+1)=8*m+2 by omega] at h
  omega

private theorem sixteen_twelve (m : ℕ) : B (16*m+12)%2=1 := by
  have h := four B b2 odd step (4*m+3) (by omega)
  have h2 := eight_six B b2 odd step m
  rw [show 4*(4*m+3)=16*m+12 by omega,
    show 2*(4*m+3)=8*m+6 by omega] at h
  omega

private theorem sixteen_zero (m : ℕ) (hm : 0 < m) : B (16*m)%2=B (8*m)%2 := by
  have h := four B b2 odd step (4*m) (by omega)
  rw [show 4*(4*m)=16*m by omega, show 2*(4*m)=8*m by omega] at h
  omega

private theorem thirtytwo_eight (m : ℕ) : B (32*m+8)%2=0 := by
  have h := four B b2 odd step (8*m+2) (by omega)
  have h2 := sixteen_four B b2 odd step m
  rw [show 4*(8*m+2)=32*m+8 by omega,
    show 2*(8*m+2)=16*m+4 by omega] at h
  omega

private theorem thirtytwo_twentyfour (m : ℕ) : B (32*m+24)%2=1 := by
  have h := four B b2 odd step (8*m+6) (by omega)
  have h2 := sixteen_twelve B b2 odd step m
  rw [show 4*(8*m+6)=32*m+24 by omega,
    show 2*(8*m+6)=16*m+12 by omega] at h
  omega
#print axioms thirtytwo_twentyfour
end A110037Parity
