  rw [← Finset.sum_div, Finset.sum_sub_distrib]
  field_simp [Real.pi_ne_zero, hd]
  <;> ring

/-- Public companion exposing the already-proved original exponential kernel
series. The diagonal evaluator uses the same series instead of duplicating
its geometric identity or postulating a kernel expansion. -/
theorem gamma_exponential_kernel_hasSum {t : ℝ} (ht : 0 < t) :
    HasSum (fun j : ℕ => Real.exp (-(2 * (j : ℝ) + 1 / 2) * t))
      (Real.exp (t / 2) / (Real.exp t - Real.exp (-t))) :=
  geometric_kernel ht

#print axioms gamma_exponential_kernel_hasSum

#print axioms gamma_boundary_integral
#print axioms arithmetic_boundary_symbol_integral
#print axioms coupling_column_kernel_integral

end D5.S3.Weil.ZetaBridge.WeilBoundaryKernelIntegral
