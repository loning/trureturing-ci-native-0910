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
