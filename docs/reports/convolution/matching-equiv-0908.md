# Matching Monomial Fiber Cardinality

skill: consensus-rnd:sshx
producer: one codex-cli implementation worker
independent_review: ASSUMED-UNVERIFIED (zero review seats)

Repository: https://github.com/the-omega-institute/trureturing
Branch: lane/math/matching-equiv-0908
Base: ceb8502be9e6ccabf98518284f0051b971e7104b
Lane: #6377. Predecessor: #6433.

The user brief preregisters the fiber equivalence as the proposed escape
witness. The orchestrator checked only the numerical readings listed in
that brief. All Lean results in this report are worker-run.

## Bind-only Probe

The pure cardinality target was tested again, independently of the previous
MatchingIdentity probe. The attempt rewrites the first factor with
card_partner_embeddings, specializes Fintype.card_embedding_eq, normalizes
finite-set cardinalities, and calls linarith only with that equality and
sq_nonneg of the rational cast of the fiber cardinality.

`/usr/bin/time -l make lean`: EXIT 2; 12591 jobs; 41.68 seconds;
maximum resident set size 5935546368 bytes. The cache receipt says both
project and Mathlib oleans are warm. The failure is at MatchingFiber.lean:597:

```text
linarith failed to find a contradiction
hEmbedding : Fintype.card (S ↪ (S ∪ T)ᶜ) =
  (n - (S.card + T.card)).descFactorial S.card
a : Fintype.card (MatchingMonomialFiber k S T) <
  Fintype.card (S ↪ (S ∪ T)ᶜ) *
    ((2 * (k - S.card)).factorial / ((k - S.card).factorial * 2 ^ (k - S.card)))
⊢ False
```

The exact source and raw log are bind-only-attempt.lean and
bind-only-make-lean.log in the attempt directory. The temporary example was
removed. This is a failed restricted attempt, not a semantic nonexistence claim.

## Search Decision

Pinned Mathlib provides Equiv.Perm.card_of_cycleType_mul_eq and
Equiv.Perm.card_of_cycleType. The type consisting of h transpositions is
Multiset.replicate h 2. We directly specialize that formula; no independent
proof of the perfect-matching recurrence and no third-party port is needed.

An earlier name search found TauCeti.card_perfectMatching at revision
f6f910c48c3b832f64090230c1d623c1a98a9b58, with Apache-2.0 LICENSE and no NOTICE
in its recursive Git tree. Its Lean v4.34.0-rc2 and Mathlib
e21ec05048292b3de86d4cf1987e2208171a5642 differ from this repository. A port
was considered, then superseded before implementation by the pinned-Mathlib
cycle-type hit. No TauCeti code is copied into the delivered source.

The primary count uses a multiplication equality in N. The denominator
h.factorial * 2^h is positive, so the natural-number quotient follows by
exact division. This also handles h=0 without a negative double factorial.

## Not Claimed

No H_0(R) positive semidefiniteness, complete parity identity, or all-order
omission of H_1 is asserted. Freeze, coverage, and independent review are
not claimed by local Lean compilation.

## Step 1

The two count theorems compile with `/usr/bin/time -l make lean`: EXIT 0;
12592 jobs; 25.53 seconds; maximum RSS 1746518016 bytes
(step-1d-make-lean.log). Both public theorem axiom prints and the private
cycle-type characterization print are [propext, Classical.choice, Quot.sound].

Both public theorems have proof_shape bind-only and no direct frozen
repository premises (GID/statement_id: none). Their admission_basis is
rule-11-upstream-wrapper, for the preregistered consumer
card_matchingMonomialFiber -> card_fixedPointFreeInvolution. The product
count directly specializes Equiv.Perm.card_of_cycleType_mul_eq; the quotient
count consumes the product count. escape_witness: none for both.

utility is none separately for FixedPointFreeInvolution, its finite instance,
the private involution_iff_cycleType, card_fixedPointFreeInvolution_mul, and
card_fixedPointFreeInvolution: each is a symbolic type, type-class instance,
or universally quantified theorem at arbitrary finite cardinality. None
enumerates bounded parameters, certifies a numerical instance, implements
a checker, or reduces a theorem to undischarged numerical premises.

Earlier step-1 builds failed on local API/normalization details:
step-1a EXIT 2 / 17.88 s / RSS 3054321664; step-1b EXIT 2 / 14.13 s /
RSS 1729609728; step-1c EXIT 2 / 13.12 s / RSS 1728692224. All report 12592
jobs. Errors concerned the explicit finite instance, cancellation of two,
Finset.eq_univ_of_card's explicit finset, the argument order of exact
division, and a List-only lemma name. No resource limit was raised.

Step 1 was pushed as `5b2086e96f`.

## Step 2

The exact requested `card_matchingMonomialFiber` is proved, together with
`card_matchingMonomialFiber_mul`. The explicit equivalence reconstructs the
square and cross edges, proves they are loop-free and pairwise disjoint,
counts their union, and assigns the unique local choice selected by S.
Disjoint edge supports give the required exponent sum and injectivity of
the decoration exponent. Both extracted partner maps are recovered by
uniqueness of the edge incident to a given vertex.

The equivalence needs hST, hS and hT; the requested hk hypothesis is retained
in the quotient theorem's signature, although it is unnecessary for counting
the possibly empty embedding type. No parameter restriction was weakened in
the requested theorem. The product form is the coefficient-field consumer's
interface, avoiding any cast of natural-number division.

`/usr/bin/time -l make lean`: EXIT 0; 12593 jobs; 22.04 seconds;
maximum RSS 3019046912 bytes (`step-2h-make-lean.log`). Every added theorem's
`#print axioms` has [propext, Classical.choice, Quot.sound]. The earlier
step-2c through step-2g failures concern dependent choice normalization,
explicit incidence vertices, and local API arguments; no bound was raised.

The added public theorems in MatchingFiber and MatchingEquiv have
proof_shape content after inlining their live local construction; no direct
frozen repository theorem is used (GID/statement_id: none). Their proposed
and observed escape is the brief's square-partner/cross-involution
decomposition, with the edge-incidence and exponent-locality lemmas as its
live intermediate obligations. admission_basis is escape-witness; each
auxiliary declaration is consumed by matchingMonomialFiberEquiv, which is
consumed by both cardinality theorems. Detailed per-declaration accounting
will accompany the final canonical report.

Every added definition, instance, private helper and public theorem has
utility none: it describes or proves a symbolic construction for arbitrary
n,k,S,T; it neither enumerates bounded parameters, certifies a numerical
instance, implements a checker, nor leaves a numerical reduction obligation.

Step 2 was pushed as `d7a78b89fe`.

## Step 3

`coeff_matchingSum_fiber` proves (C) over Q for all parameters in the brief.
Its denominator is the rational product `(n-2k)! * (k-|S|)!`; its numerator
is `(-1)^(k-|S|) * (n-2k+|S|)! * (2*(k-|S|))!`. This is the stated pair
of factorial ratios, combined into one field quotient. The proof casts the
division-free count, uses Nat.factorial_mul_descFactorial, and cancels
the powers of two. There is no natural-number quotient cast.

`/usr/bin/time -l make lean`: EXIT 0; 12593 jobs; 23.38 seconds;
maximum RSS 3035693056 bytes (`step-3a-make-lean.log`). Its `#print axioms`
is [propext, Classical.choice, Quot.sound]. proof_shape content, through
the live fiber equivalence; escape_witness matchingMonomialFiberEquiv;
admission_basis escape-witness; direct frozen GID/statement_id none.
utility none: this is an unbounded symbolic coefficient formula, missing
all four computational classes. Consumer edge: (star) ->
coeff_matchingSum_fiber -> card_matchingMonomialFiber_mul.

Step 3 was pushed as `cf625f5a04`.

## Step 4

`matchingSum_esymm_mul` and `matchingSum_esymm` prove (star) in the
multivariate polynomial ring over Q. The first uses a constant-polynomial
denominator on the left; the second multiplies the explicit
`matchingNumerator` by the constant polynomial of its rational reciprocal.

The arbitrary-exponent obligation is also discharged. Every decorated
matching exponent is at most two at each vertex and has sum 2k. The same
holds for every subset pair contributing to e_i e_(2k-i). Every such
exponent is reconstructed as a disjoint square/linear fiber; coefficients
outside this class vanish on both sides. The surviving sum is reindexed by
i = |S| + ell, and uses alternating_factorial_sum with
d = n-2k+|S| and h = k-|S|. No finite parameter testing is a premise.

`/usr/bin/time -l make lean`: EXIT 0; 12594 jobs; 19.58 seconds;
maximum RSS 3110420480 bytes (`step-4b-make-lean.log`). The preliminary
support proof build `step-4a-make-lean.log` also passed, 18.13 seconds,
RSS 2986377216 bytes, 12594 jobs. All 12 theorem axiom prints in the new
module are [propext, Classical.choice, Quot.sound].

Both public theorems have proof_shape content after live helper inlining,
escape_witness matchingMonomialFiberEquiv together with the exponent
classification and shifted sum assembly; admission_basis escape-witness.
Direct frozen GID/statement_id: none. utility none for each of the 14
declarations: each is a symbolic definition or an unbounded theorem,
outside the four computational classes. No freeze or independent review
is claimed.

Step 4 was pushed as `8637dd6e4f`.

## Step 5

`matching_identity : MatchingIdentity` is proved. Evaluation of (star) in R,
Mathlib's Multiset.prod_X_sub_C_coeff and
MvPolynomial.aeval_esymm_eq_multiset_esymm, followed by
symmetrize_coefficient, gives the all-degree identity. Descending factorials
are converted through Nat.factorial_mul_descFactorial; all factorial
denominators are proved nonzero. The final proof normalizes multiplication
inside the finite sum before applying the evaluated identity.

`/usr/bin/time -l make lean`: EXIT 0; 12594 jobs; 17.46 seconds;
maximum RSS 3137781760 bytes (`step-5c-make-lean.log`). The 18 theorem axiom
prints in MatchingPolynomial are [propext, Classical.choice, Quot.sound].
The first attempt failed because the local namespace parsed R[X] as an
index expression (step-5a: EXIT 2, 25.37 s, RSS 3081879552). The second
failed because linarith treated differently parenthesized sum terms as
different atoms (step-5b: EXIT 2, 11.65 s, RSS 3079405568). Both had 12594
jobs. Explicit Polynomial R and multiplication normalization fix these
without changing any resource bound.

proof_shape content; escape_witness matchingMonomialFiberEquiv on the live
coefficient-to-polynomial-to-evaluation path; admission_basis escape-witness.
utility none for the public theorem and each of its five private helpers:
all quantify over arbitrary degrees or root families and none falls into
the four computational classes. The only frozen theorem used along this
path is coeff_additiveConvolution through the predecessor's
symmetrize_coefficient; direct frozen definition identities are itemized in
the final declaration audit. No H_0 positivity, complete parity identity,
or all-order omission of H_1 follows as a claim of this delivery.
