import Mathlib

namespace Triage105

noncomputable def blaschke (p z : Complex) : Complex :=
  (z - p) / (z - starRingEnd Complex p)

noncomputable def kernel (S : Complex -> Complex) (z w : Complex) : Complex :=
  (1 - S z * starRingEnd Complex (S w)) / (-Complex.I * (z - starRingEnd Complex w))

theorem kernel_update (S : Complex -> Complex) (p z w : Complex)
    (hp : 0 < p.im) (hz : 0 < z.im) (hw : 0 < w.im) :
    kernel (fun a => blaschke p a * S a) z w =
      ((2 * p.im : Real) : Complex) /
        ((z - starRingEnd Complex p) * (starRingEnd Complex w - p)) +
      blaschke p z * starRingEnd Complex (blaschke p w) * kernel S z w := by
  have hzp : Ne (z - starRingEnd Complex p) 0 := by
    intro h
    have hi := congrArg Complex.im h
    simp at hi
    linarith only [hi, hp, hz]
  have hwp : Ne (starRingEnd Complex w - p) 0 := by
    intro h
    have hi := congrArg Complex.im h
    simp at hi
    linarith only [hi, hp, hw]
  have hzw : Ne (z - starRingEnd Complex w) 0 := by
    intro h
    have hi := congrArg Complex.im h
    simp at hi
    linarith only [hi, hz, hw]
  have hpi : ((2 * p.im : Real) : Complex) =
      (p - starRingEnd Complex p) / Complex.I := by
    simp [Complex.sub_conj]
  simp only [kernel, blaschke, map_mul, map_div₀, map_sub, Complex.conj_conj]
  rw [hpi]
  field_simp [hzp, hwp, hzw, Complex.I_ne_zero]
  <;> ring

#print axioms kernel_update

end Triage105
