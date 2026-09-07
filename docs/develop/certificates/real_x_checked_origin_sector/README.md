# Checked real-X origin-sector traversal

This is a concrete numeric instance for the interval/cover proof layer of
`docs/develop/theory/MUB_SIX_FOURTH_BASIS_THEORY.md`. It is not a second theory
volume, a new Hadamard parameter-neighborhood exclusion, or the full 32-chart
certificate.

## Exact statement

Let `b=(-3+4i)/5`, `e=(-2+i sqrt(21))/5`, and use the existing seed matrix

```math
H_0=\begin{pmatrix}
J_3+(b-1)I_3 & J_3+(e-1)I_3\\
J_3+(\bar e-1)I_3 & -J_3-(\bar b-1)I_3
\end{pmatrix}.
```

Set `u_0=1` and `u_(j+1)=(1-t_j^2+2it_j)/(1+t_j^2)`. The concrete proof
source states that every `t` in `[-1/5,1/5]^5` violates at least one band

```math
\left| |(H_0^\dagger u)_a|^2-6\right|\le1/64,
\qquad a=0,\ldots,5.
```

The domain is a proper subregion of the all-positive signed-Cayley chart.
There is no target tube in this instance: all leaves are residual exclusions.
The irrational constant is enclosed by the proved rational interval

```text
5038595261767/1099511627776 <= sqrt(21)
                           <= 629824407721/137438953472.
```

## Proof layers delivered

1. `RationalIntervalExpression.lean` evaluates annotated arithmetic expressions
   over arbitrary real inputs. `checked_expression_encloses` derives real
   bounds from the Boolean rational checker. Multiplication checks all four
   corners; inverse nodes require strict separation from zero.
2. `CheckedRationalBoxCover.lean` checks target inclusion, expression exclusion
   and complete closed binary splits. Endpoint annotations are erased before
   comparing each leaf with the prescribed residual expression. Child indices
   must be strictly earlier. Its main theorem constructs the local proofs
   consumed by the existing `FiniteSublevelCover` owner.
3. `RealXCheckedOriginSector.lean` contains literal paths and instruction codes,
   a rational annotation proposal, and an actual matrix-semantics identity. The
   forest has 237 nodes, consisting of 119 exclusions and 118 splits. The final
   theorem has no numerical enclosure or global-cover premise.

The annotation producer is not trusted: the interval checker independently
checks the resulting bounds. The code requests `decide +kernel` for the literal
forest. Writing that command is not equivalent to having executed it.

The pending `RealXCheckedExclusionLeaf.lean` and its Scribe were also delivered
in this continuation. That smaller file remains a single-column, radius
`1/1024` integration example, not an additional global exclusion claim.

## Checks actually executed on 2026-09-07

The standalone audit re-parses the expression DAG, paths and instruction codes
from the delivered Lean text. With the documented fixed domain and decoding,
it checks every rational bound and both closed split halves using
`fractions.Fraction`. It reports:

```text
237 proof nodes
285 shared raw expression nodes
119 exclusion leaves
118 binary splits
720 exact Gaussian-rational direct-matrix comparison instances
7 rejected malformed-certificate controls
```

The seven rejected controls are a missing final branch, a cyclic child, reuse
of the left child for both halves, changing the outcome without its expression,
using bounds from the wrong box, an incomplete root domain, and a forged
exclusion bound.

Separately, all six expression-versus-actual-matrix residual identities were
checked as exact rational-function identities in symbols `s,t0,...,t4` using
SymPy cancellation. This supplements the finite sample check but remains an
external computer-algebra check. The Lean proof script supplies its own
`norm_num`/`ring` identity, which must still elaborate.

The source audited and read back from GitHub has Git blob
`3c4e9894b625e13e2c15b1918670d247adc2fb29` and SHA256
`3618ffc6662f9ae2229a44e7a13ba158dfb76a55b4bb20065b894f814a3f2d2e`.
The audit implementation was also read back and matched to local bytes, blob
`bfa5dbf66665200eda7958ee2a60f956bcb4f529`.
Hashes identify these runs; they are not mathematical proof premises.

## Reproduction

```sh
python3 scripts/research/check_real_x_checked_origin_sector.py \
  --source D5/S3/Quantum/Tomography/RealXCheckedOriginSector.lean \
  --output /tmp/real-x-checked-sector-replay.json
```

The audit uses only the Python standard library. It does not compile Lean,
prove the universal soundness theorem, or read a stored PASS as evidence.

## Remaining obligations

No Lean/lake execution was available in the authoring runtime. A preceding
remote run on an intermediate head failed at canonical Lean-report production;
no successful current-head kernel report is claimed. The source must be
compiled against the repository pin before describing these theorems as
kernel accepted. Scribe rendering has likewise not been executed locally.

The full previous MUB traversal contains Krawczyk contractions, balanced
readouts, tube leaves and chart changes. `CheckedRationalBoxCover` currently
accepts only cover/exclude/split instructions. It does not silently accept or
ignore unsupported contractor records. The numeric derivative enclosures,
contractor retention proofs, coordinate transport and the complete 32-chart
literal instance remain necessary before the local strong-unextendibility
result becomes a complete kernel-certified theorem.

No local Hadamard radius, full-X exclusion, global four-MUB upper bound,
root-count theorem, intrinsic-information score, or seal is added by this
sector integration result.
