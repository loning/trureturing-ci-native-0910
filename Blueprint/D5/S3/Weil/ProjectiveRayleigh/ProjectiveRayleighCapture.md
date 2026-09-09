# Complex Projective Rayleigh Capture

## Abstract

An actual symmetric operator-domain equation yields a sharp complex projective eigenline enclosure and consumes the recorded prime-three scalar endpoints.

D is a complex linear operator domain; iota:D->H and A:D->H are linear. Only the candidate k has unit embedded norm. The embedded eigenvector u is nonzero and satisfies Au=lambda*iota(u), with real lambda below T. Write mu=Re<iota(k),Ak> and alpha=<iota(k),iota(u)>. The complement coercivity assumption concerns every domain vector orthogonal to iota(k). No bounded action on all of H or small operator residual is assumed.

**Theorem 1.1 (The sharp aligned eigenline estimate).**

$$\operatorname{SymmetricOnDomain}(iota, A)\land \operatorname{NormalizedCandidate}(iota, k)\land \operatorname{NonzeroEigenvector}(iota, A, u, lambda)\land ell\leq lambda< T\land mu\leq U< T\land \operatorname{ComplementCoercive}(iota, A, k, T)\Rightarrow \operatorname{Nonzero}(alpha)\land \operatorname{normSq}(\operatorname{alignedError}(iota, k, u))\leq \operatorname{ratio}(mu-lambda, T-lambda)\land \operatorname{normSq}(\operatorname{alignedError}(iota, k, u))\leq \operatorname{ratio}(U-ell, T-ell)\land \operatorname{normSq}(\operatorname{alignedError}(iota, k, u))< 1$$

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/ProjectiveRayleighCapture.projective_rayleigh_enclosure` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Shift the action to B=A-lambda*iota. It is symmetric on the same domain and annihilates u. Complement coercivity first proves alpha is nonzero. The vector f=alpha^{-1}u-k lies in the orthogonal complement, and symmetry gives <iota(f),Bf>=<iota(k),Bk>. Hence (T-lambda)||iota(f)||^2<=mu-lambda. Since mu<T, the error is below one. Using (lambda-ell)(1-||iota(f)||^2)>=0 yields the endpoint ratio with denominator T-ell. The proof does not assume its conclusion.

**Theorem 1.2 (Exact endpoint arithmetic).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/ProjectiveRayleighCapture.prime_three_projective_ratio`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/ProjectiveRayleighCapture.prime_three_projective_ratio` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The endpoints are ell=103/2000000000, U=560909/10000000000000 and T=1/200000, taken from the actual prime3_refined_certificate.json. Their ratio is 15303/16495000 and is strictly below (61/2000)^2. This arithmetic does not validate the upstream interval program or its operator bridge.

**Theorem 1.3 (The recorded endpoints imply a projective distance below 0.0305).**

Lean statement: `D5/S3/Weil/ProjectiveRayleigh/ProjectiveRayleighCapture.prime_three_projective_mode_capture`

*Proof.* Machine-checked in Lean as `D5/S3/Weil/ProjectiveRayleigh/ProjectiveRayleighCapture.prime_three_projective_mode_capture` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The general domain theorem and exact rational comparison supply the last variational implication for the prime-three certificate. Its symmetry, eigenpair, candidate upper energy and codimension-one coercivity remain explicit hypotheses. Their realization by the arithmetic Weil operator is a separate proof obligation. No asymptotic Xi convergence or new prime-gap record follows from this fixed-window conclusion alone.

This formalizes a concrete paper-level step of the ground-mode research. The method is classical variational analysis; no first-discovery claim is made. Source review and independent finite algebra checks are distinct from Lean elaboration, axiom inspection and Scribe emission.

## References

- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/ProjectiveRayleighCapture.prime_three_projective_mode_capture`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/ProjectiveRayleighCapture.prime_three_projective_ratio`
- Truth anchor: `D5/S3/Weil/ProjectiveRayleigh/ProjectiveRayleighCapture.projective_rayleigh_enclosure`
