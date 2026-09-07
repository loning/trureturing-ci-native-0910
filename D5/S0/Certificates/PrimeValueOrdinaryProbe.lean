/- GID: D5/S0/Certificates/PrimeValueOrdinaryProbe
   generality: I
   mirror-B: D5/B/S0/Certificates/PrimeValueOrdinaryProbe
   mirror-E: none(waiver:algebraically-proved)
   anchors: []
   utility: kind=certified-instance; basis=terminal=gid:D5/S0/Certificates/PrimeValueOrdinaryProbe.prime_at_zero
   digest: Synthetic ordinary-instance admission probe for the polynomial n + 2. -/
import Mathlib.Data.Nat.Prime.Basic

namespace D5.S0.Certificates.PrimeValueOrdinaryProbe

theorem prime_at_zero : Nat.Prime (0 + 2) := by
  simpa using Nat.prime_two

end D5.S0.Certificates.PrimeValueOrdinaryProbe
