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
