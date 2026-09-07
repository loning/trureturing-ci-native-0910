# Paired holomorphic Cayley residuals and a common complex domain

This is the analytic continuation interface for the existing MUB-six coverage lane and its theory volume `docs/develop/theory/MUB_SIX_FOURTH_BASIS_THEORY.md`.

## 1. The actual complexification

Fix a matrix H of order d and fixed unit prefactors s. Write

```math
u_k(z)=s_k(1+iz_k)/(1-iz_k),\qquad
v_k(z)=\overline{s_k}(1-iz_k)/(1+iz_k),
```

```math
A_a=\sum_k\overline{H_{ka}}u_k,\qquad
B_a=\sum_k H_{ka}v_k,\qquad
F_a=A_aB_a-d.
```

On real coordinates, v is the conjugate of u and F is exactly the actual squared-modulus residual. On complex coordinates the two factors are rational holomorphic functions; `normSq` is not applied to a varying complex argument to define the extension.

The exact complex Jacobian is

```math
J_{ak}=\overline{H_{ka}}\frac{2is_k}{(1-iz_k)^2}B_a
-H_{ka}\frac{2i\overline{s_k}}{(1+iz_k)^2}A_a.
```

The source proves a full complex Frechet derivative, not just a derivative along a real path. It also constructs the actual five-variable system: fix s_0=1 and z_0=0, and retain outcomes 0 through 4. Its Jacobian is the corresponding five-by-five submatrix. The redundant six-by-six system is not asserted invertible.

If HH*=dI and |s_k|=1, then u_k v_k=1 and

```math
\sum_a F_a=v^T HH^*u-d^2=0.
```

Consequently every Jacobian column sums to zero. The source proves complex residual conservation directly by matrix algebra. The Jacobian-column consequence is also checked in the exact diagnostic but does not have a separate public theorem in this increment.

Deletion of an outcome is harmless for exact zeros. At a nonzero tolerance gamma, the all-six band additionally requires

```math
\left|\sum_{a=0}^{4} F_a\right|\le\gamma.
```

A five-outcome gamma band alone only bounds the sixth residual by 5 gamma. These two feasible domains must not be identified by a pruning certificate.

All holomorphy statements keep H fixed. If matrix parameters are complexified, their conjugated coefficients require a separately holomorphic companion agreeing on the real slice. Pointwise conjugation of H(p) is not a holomorphic parameterization.

## 2. One domain for signs, chart changes and restrictions

Use the explicit domain

```math
D=\{z\in\mathbb C:10|\Im z|<3(1+|z|^2)\}.
```

It is the inverse image of the annulus 1/2<|w|<2 under w=(1+iz)/(1-iz). It is open, contains the real axis, and contains the closed strip |Im z|<=1/4. The latter follows from 10|Im z|<=5/2<3<=3(1+|z|^2).

For every z in D,

```math
|1-iz|^2>2/5,\qquad |1+iz|^2>2/5.
```

For every unit s,

```math
1/4<|u_s(z)|^2<4,\qquad |u_s'(z)|\le5.
```

The identities D=-D=conjugate(D) and

```math
z\ne0\Longrightarrow(z\in D\iff-1/z\in D),\qquad
u_s(-1/z)=u_{-s}(z)
```

give exact signed-Cayley chart compatibility. Inversion at zero is never used. Permuting coordinates preserves the product domain. Sign and quarter-turn prefactors do not change any norm bound.

Every certified child region inside D^d inherits holomorphy. The family of child regions can be arbitrary, so there is no subdivision-depth-dependent analytic radius. This does not claim that Boolean comparisons, `min`, `max`, or the entire branching algorithm are holomorphic maps. They retain their real set-theoretic and interval semantics.

Nor does this assert invariance under arbitrary projective reanchoring. A product annulus can widen when all phases are divided by a new anchor. Such an additional gauge operation needs a pairwise-ratio projective domain or its own domain proof.

If every coefficient has modulus at most M, then |A_a|,|B_a|<=2dM, giving the explicit source theorem

```math
|J_{ak}|\le20dM^2.
```

In order six with unit entries this is 120 per entry and hence 600 for the induced infinity norm of the dephased five-by-five matrix. The latter row-sum consequence is mathematical bookkeeping, not a new independently claimed certificate.

## 3. Invariance of actual Newton maps needs a separate budget

For a node nu, put N_nu,e(z)=z-C_nu(f_nu(z)-e), with C_nu fixed. On a closed complex ball B(m_nu,r), suppose

```math
\|I-C_\nu Df_\nu(z)\|\le q,\quad
\|C_\nu f_\nu(m_\nu)\|\le b,\quad
\|C_\nu\|\le\kappa,\quad \|e\|\le\gamma.
```

The actual mean-value inequality on the convex ball gives

```math
\|N_{\nu,e}(z)-m_\nu\|\le qr+b+\kappa\gamma.
```

Therefore

```math
b+\kappa\gamma+qr\le r
```

makes the ball invariant, uniformly over all node choices for which these bounds hold. The source quantifies over the entire family of nodes. It does not silently assert the bounds for every historical cover node. If a ball is centered at a real point and r<=1/4, it lies in the product pole-free domain above.

Self-invariance does not follow from holomorphy alone. For example f(z)=-3z and C=1 give N(z)=4z, which sends i/4 in D to the excluded pole i. The q/b/forcing budget prevents this invalid inference. A nonconstant C(z) would need its derivative; only fixed node preconditioners are covered here.

Exclusion and split nodes need containment/retention proofs, not Newton self-maps. The global coverage target remains a statement about every actual real candidate, including the closed boundaries of every split.

## 4. Formal sources and actual verification

The three paired Lean/Scribe modules are:

```text
HolomorphicCayleyHadamard
CayleyInvariantComplexNeighborhood
HolomorphicSublevelInvariance
```

They reuse Mathlib complex differentiation, continuous linear maps, matrix products and the convex-set mean-value inequality. They leave existing real residual, interval-expression and finite-cover owners unchanged.

`check_cayley_holomorphic.py` was actually run. It checks four symbolic rational scalar identities; 360 exact Gaussian-rational domain cases; 36 coordinate cases on one independently checked order-six unit-entry seed; and 900 dephased Jacobian entries by an independent dual-number implementation. It additionally checks real-slice binding and complex conservation. Six false variants were rejected. The output is `verification.json`.

These finite diagnostics do not prove the general Lean statements. No Lean/lake elaboration or Scribe rendering was executed in this authoring runtime. No complete covering forest was re-run or kernel-certified, no new Hadamard parameter region was excluded, and no information score or seal is asserted.

## 5. Research connection and remaining obligation

The parameter-Krawczyk work of Duff and Lee, *Certified homotopy tracking using the Krawczyk method*, arXiv:2402.07053, supplies method context for checked local analytic neighborhoods. Lee, *A priori bounds for certified Krawczyk homotopy tracking*, arXiv:2512.01355, supplies context for explicit step budgets. Neither work supplies our concrete whole-space MUB coverage or implies it from path tracking alone.

The remaining concrete task is to bind these formulas to the rational interval-expression evaluator and check the complex derivative/retention bounds at every required contraction and chart transition of the actual covering forest. Uniform pole separation removes a common analytic-domain obligation, but does not discharge those numerical local proofs. The four-MUB problem and the complete strict-X branch exclusion are not solved by this increment.

## 6. Projective reanchoring without accumulated complex-domain loss

The prior domain handles signed Cayley transitions and restrictions. It does
not preserve a fixed independent annulus under division by a new anchor. For
example, the phase values 3/2 and 2/3 are individually in (1/2,2), but their
ratio is 9/4. This does not invalidate the earlier fixed-anchor theorem. It
identifies a missing hypothesis for unrestricted reanchoring.

For R>1, use the open set of nonzero phase vectors

```math
\Omega_R=\{w\in\mathbb C^6:|w_i|<R|w_j|\text{ for every }i,j\}.
```

The strict self-pair inequality rules out zero coordinates. Every vector of
unit phases is in this set. Common nonzero scaling, coordinate permutation,
fixed unit coordinate prefactors and conjugation preserve the domain. Hence,
for every anchor a,

```math
w'_i=w_i/w_a,\qquad
w'\in\Omega_R,\qquad w'_a=1,\qquad 1/R<|w'_i|<R.
```

Successive anchor changes use the same R. Restricting a candidate set during
certified pruning also does not widen Omega_R. These statements do not make a
Boolean pruning operation holomorphic, and do not make an arbitrary Newton
map a self-map.

### Actual residual preservation

On nonzero phases define the Laurent readout

```math
A_a(w)=\sum_i\overline{H_{ia}}w_i,\qquad
B_a(w)=\sum_i H_{ia}/w_i,\qquad
F_a(w)=A_a(w)B_a(w)-6.
```

This is a coordinate representation of the existing paired residual. Its
fixed-matrix identity is

```math
F(cw)=F(w)\quad(c\ne0).
```

Indeed A(cw)=cA(w) and B(cw)=c^{-1}B(w). Reanchoring therefore preserves every
residual exactly, including every nonzero residual tolerance band. On the
real unit-phase torus this complex scaling action restricts to the usual
common U(1) phase freedom.

For the existing Cayley prefactors, with |s_i|=1 and both poles excluded,

```math
F_H\bigl((s_i(1+iz_i)/(1-iz_i))_i\bigr)
=\operatorname{pairedCayleyResidual}(H,s,z).
```

This equality is a public theorem in the new source, so the new coordinates
do not replace the original problem with an unrelated holomorphic function.
H stays fixed. Independent coordinate phase changes preserve Omega_R, but
generally change F_H unless H is also transformed by the appropriate row
gauge. That distinction is included in both the theorem statements and a
negative diagnostic.

### Scale-independent Jacobian envelope

The ordinary complex derivative has entries

```math
J_{ak}(w)=\overline{H_{ka}}B_a(w)-H_{ka}A_a(w)/w_k^2.
```

The entries w_k J_ak are invariant under common scaling. Expand them before
taking norms:

```math
w_kJ_{ak}
=\sum_{j\ne k}\left(
\overline{H_{ka}}H_{ja}\frac{w_k}{w_j}
-\overline{H_{ja}}H_{ka}\frac{w_j}{w_k}\right).
```

If every |H_ia|<=M and w is in Omega_R, all ratios have modulus less than R.
There are only five nonzero-index pairs in each sum, so

```math
\boxed{|w_kJ_{ak}|\le10RM^2.}
```

For R=2 and M=1, the bound is 20 per Euler-scaled entry. It is NOT a direct
replacement for the earlier bound on the Cayley Jacobian. The coordinates and
input vector norms differ, so a numerical preconditioner must be transported
using the actual chain rule. No lower singular-value bound follows from this
upper envelope. The full six-variable derivative also retains the common-scale
null direction; an invertible Newton system still requires a gauge choice.

The local logarithmic chart w_i=s_i exp(i theta_i) has Jacobian i w_k J_ak.
Its natural complex domain is the convex imaginary-oscillation strip

```math
\max_i\Im\theta_i-\min_j\Im\theta_j<\log R.
```

This describes a useful future route to scale-independent Taylor bounds. No
exponential interval checker or new Newton contraction instance is delivered
in this increment.

### Delivered proof sources and executed checks

New owner, with matching Scribe:

```text
D5/S3/Quantum/Tomography/ProjectiveHadamardNeighborhood.lean
Blueprint/D5/S3/Quantum/Tomography/ProjectiveHadamardNeighborhood.scribe.cs
```

The four public theorems establish reanchoring with residual preservation,
open-domain/gauge properties, the actual complex derivative with its scaled
bound, and equality with the existing paired Cayley residual. They reuse the
existing phase and residual owner, Matrix.mulVec/vecMul, continuous linear
projections and complex derivative rules. No interval, Hadamard, basis or
rank-one-context definition is duplicated.

`check_projective_hadamard_neighborhood.py` was run with exact Gaussian-rational
arithmetic. It checked 64 matrix/phase families, 384 anchor changes, 2304
Jacobian entries via independently coded dual arithmetic, 2304 scaled-entry
bounds, 64 paired-coordinate bindings and 128 domain covariance checks.
It rejects the independent-annulus reanchoring mistake, a zero phase, inverse
at zero, the wrong reciprocal derivative sign and spurious fixed-H independent
phase invariance. The test seed lies on a seam; it calibrates a theorem valid
for any fixed bounded matrix and is not a new strict-X exclusion.

The result is in `projective_verification.json`. These are finite diagnostics,
not a universal proof or an independent expert review. Lean/lake elaboration
and Scribe rendering were not executed. No full cover was re-run, no additional
Hadamard parameter region was excluded, and no kernel-admission or information
seal is claimed. The analytic domain can now follow anchor changes without
width loss; numerical contraction/retention bounds for the actual forest are
still separate obligations.
