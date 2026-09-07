# Conserved-residual certificate for a local six-dimensional MUB exclusion

This is a concrete certificate instance for the existing theory volume
`docs/develop/theory/MUB_SIX_FOURTH_BASIS_THEORY.md`, not a second theory volume.
The files were delivered to PR #5028 on 7 September 2026 after a fresh full
replay. The corresponding open-problem status is recorded in
`Problems/mub-six-fourth-basis.md`.

## Precise mathematical scope

Let

```math
b=(-3+4i)/5,\qquad e=(-2+i\sqrt{21})/5,
```

```math
H_0=\begin{pmatrix}
J_3+(b-1)I_3&J_3+(e-1)I_3\\
J_3+(\bar e-1)I_3&-J_3-(\bar b-1)I_3
\end{pmatrix}.
```

Exact arithmetic in `Q(i,sqrt(21))` checks unit entries and both Gram identities
`H0 H0*=H0* H0=6I`. For any actual order-six complex Hadamard H satisfying

```math
\sigma(H,H_0):=\max_a\sum_j|H_{ja}-(H_0)_{ja}|\le9/4096,
```

the computer-assisted argument excludes a literal `(6,6,6,1)` constellation
containing the fixed edge `(I,H/sqrt(6))`: after a complete third basis, even
one additional vector unbiased to all three bases cannot be added. In
particular a quartet cannot contain that edge. The ball contains the entire
entrywise neighborhood of radius `3/8192`.

This is a small local result in the space of actual Hadamard matrices. It is
not an exclusion of the entire Szollosi X family or all order-six classes.
The computation is not currently an end-to-end Lean-kernel theorem.

## The preserved relation

For a unit-entry vector u define all six actual residuals

```math
r_j(u)=|(H_0^*u)_j|^2-6.
```

The matrix identity implies, on the whole phase domain,

```math
\sum_jr_j=u^*H_0H_0^*u-36=0.
```

Thus a real readout c satisfies, for every real lambda,

```math
\sum_jc_jr_j=\sum_j(c_j-\lambda)r_j.
```

If `lo_j<=r_j<=hi_j`, endpoint multiplication gives lower and upper bounds
using sums of the corresponding minima and maxima. Trying the six coefficient
values as shifts and intersecting the resulting intervals remains sound. No
optimizer optimality assertion is trusted.

The Lean source `HadamardResidualConservation.lean` derives this conservation
from the actual matrix Gram equation, rather than taking zero residual sum as
an unexplained premise. Its second public theorem applies the already-owned
`preconditioned_sublevel_row_enclosure` to `f-f(x)`. The full mean-value
remainder is retained; the final residual readout uses the balanced interval.
The actual derivative and its directional enclosure remain explicit premises.

## Complete sublevel coverage and local refinement

The verified domain is

```math
\{u:u_0=1,\ |u_i|=1,\ \max_{0\le j<6}|r_j(u)|\le1/64\}.
```

All 32 compact signed-Cayley charts are traversed. A box can be discarded only
by a sound residual exclusion, a sublevel Newton exclusion, or membership in
a covering tube. Contraction retains all feasible points; splitting covers
the parent, including its boundary. A budget-exhausted run is INCOMPLETE.

The global tubes have Cayley radius `1/16`. On the SAME all-six residual domain,
the portion assigned label 5 is proved contained in radius `1/32`. This local
refinement is separately replayed before the tighter overlap bounds are used.

The fresh replay reproduced:

| Item | Result |
| --- | ---: |
| Completed charts | 32 |
| Global boxes | 4,900,318 |
| Pending / unresolved | 0 / 0 |
| Label-5 refinement boxes | 945 |
| Whole-tube overlap checks | 1,890 |
| Orthogonality candidate edges | 372 |
| Unbiasedness candidate edges | 859 |
| First six-cliques in the upper graph | 2,403 |
| Nonempty common-partner sets | 0 |

The 2,403 cliques are conservative label candidates, not actual bases. The
relations coincide with the 120 literal bit-mask rows in the existing
`RealXFinitePartnerCertificate.lean`; that owner is retained, not duplicated.
Each possible extra-vector label has a five-colorable orthogonality
neighborhood, excluding a complete six-clique of its unbiased partners.

The older first-five residual sublevel is a different nonzero-tolerance domain.
Node counts are therefore not a same-domain speed comparison. The previously
attempted larger `1/32` all-six sublevel remains unverified; no success is
inferred from an incomplete traversal.

## Transfer to nearby matrices and quantitative consequence

Use `tau=1/256`. The existing actual matrix residual-transport theorem gives

```math
\operatorname{res}_{H_0}(u)\le\tau+\sigma(5+\sigma),
\qquad
\tau+(9/4096)(5+9/4096)=249937/16777216<1/64.
```

Therefore every sufficiently unbiased vector for H enters the complete seed
cover. Same-tube squared normalized overlap is greater than `3/4`, so six
approximately orthogonal vectors use six different labels. The verified
finite no-partner property then excludes even one additional covered vector
whose overlaps with all six are within tau of `1/6`.

For unit-entry `U in C^(6x6)` and `v in C^6`, set

```math
D_H(W)=\sum_{a,j}(|(H^*W)_{aj}|^2-6)^2,
\quad O(U)=\frac1{36}\sum_{i<j}|(U^*U)_{ij}|^2,
```

```math
B(U,v)=\sum_i\left(\frac{|(U^*v)_i|^2}{36}-\frac16\right)^2.
```

The argument yields

```math
D_H(U)+D_H(v)+O(U)+B(U,v)\ge1/65536.
```

A smaller total would force every individual error below its corresponding
relation threshold and contradict the finite certificate. Arbitrary amplitude
noise is not included in this statement; its separate phase-replacement
transport is owned by `HadamardResidualBarrier.lean`.

## Reproduction

```sh
python3 scripts/research/check_real_x_balanced_cover.py \
  docs/develop/certificates/real_x_two_relation/centers.txt \
  --output /tmp/mub-balanced --full-cover --jobs 4
python3 scripts/research/test_real_x_balanced_sublevel.py \
  --output /tmp/mub-balanced-tests
```

The full run rebuilds the graph and runs all charts; it does not accept the
stored verification JSON as a proof. Finite-only mode is labeled separately.
The C++ extension reuses the pinned existing interval evaluator and chart
operations. Doubles only propose a rational preconditioner; accepting bounds
use outward integer intervals.

The delivered replay used the preceding standalone package. Its strong-
unextendibility dependency was a read-only excerpt containing the two unchanged
functions `asymmetric_relative_arc` and `overlap_bounds` from remote blob
`90c3d6a82cd970e3fec7dee3850caf69fe59919b`; both functions were read again at the
pinned PR head. The excerpt is not written over the full repository owner.
Its different whole-file SHA256 is explicitly retained in the output.

## Validation and formalization boundary

The full computation and dual tests were actually repeated in the delivery
turn. The new verification objects match the preceding objects exactly. The
LP-vertex oracle separately checked 1,203 rational boxes; 200 twenty-vertex
support cases and 100 exact seed-phase cases also passed. Missing balance,
reversed endpoints, overflow, incomplete charts, wrong residual domain and
wrong thresholds are rejected. These are same-author development and replay
checks, not independent-expert review.

The paired Lean and Scribe sources are logically reviewed proof candidates.
Lean/lake and Scribe execution were unavailable locally, and CI was neither
run nor modified. A successfully compiled conditional consumer alone will not
remove the remaining interval-expression, concrete derivative, complete cover-
tree and actual matrix-to-tube obligations. `lean_kernel_verified` is false.

The targeted published conjecture is Matolcsi, Matszangosz, Varga and Weiner,
*Triplets of mutually unbiased bases*, J. Algebraic Combinatorics 63, 26 (2026),
Conjecture 3, DOI `10.1007/s10801-026-01506-x`. The established Fourier-family
quartet exclusion is Jaming et al., arXiv:0902.0882. Neither result is silently
assumed as a certificate for the present ambient neighborhood. No claim of
first priority, a new global MUB upper bound, or complete X-family exclusion
is made.
