/- GID: D5/S0/Certificates/PrimeValueRefutationProbe
   generality: I
   mirror-B: D5/B/S0/Certificates/PrimeValueRefutationProbe
   mirror-E: none(waiver:algebraically-proved)
   anchors: []
   utility: kind=certified-instance; basis=refutes=gid:D5/S0/Certificates/PrimeValueRefutationProbe.all_values_prime; result=D5/S0/Certificates/PrimeValueRefutationProbe.not_all_values_prime; claim=D5/S0/Certificates/PrimeValueRefutationProbe.all_values_prime
   digest: Synthetic refutation admission probe for the polynomial n + 2. -/
import Mathlib.Data.Nat.Prime.Basic

namespace D5.S0.Certificates.PrimeValueRefutationProbe

@[irreducible] def all_values_prime : Prop :=
  forall n : Nat, Nat.Prime (n + 2)

theorem not_all_values_prime : Not (forall n : Nat, Nat.Prime (n + 2)) := by
  intro h
  exact (by decide : Not (Nat.Prime (2 + 2))) (h 2)

end D5.S0.Certificates.PrimeValueRefutationProbe
