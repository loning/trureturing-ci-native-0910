---
bibkey: wu2019abundant
authors: Xiaolong Wu
year: 2019
title: A New Type of Abundant Numbers
doi: 10.48550/arXiv.1906.05796
claim: Ordering the prime-layer denominators gives the largest abundancy at each fixed number of prime factors counted with multiplicity; the eighth maximizing integer is 180180.
strata_touched:
  - D5/S3/Arith/GoldenResource/EightStepAbundancy
license: citation-only
triage: anchor
---

# A New Type of Abundant Numbers

Theorem 1 proves maximality of the integers constructed from the first m
prime layers, ordered by the denominator p + ... + p^k. Table 1 lists the
first twenty such integers. Row eight is 180180, with abundancy printed as
4.0727; rows eight and nine have denominators 13 and 14. These are exactly
the construction and strict boundary gap used in the eight-step statement.

The Lean module certifies the rational value 224/55 and proves strict
uniqueness among all positive integers with eight prime factors counted
with multiplicity. It also certifies the comparison with 5040. The paper's
general theorem is stated non-strictly; this note does not attribute a
separately worded uniqueness theorem or the exact rational display to it.
The module makes no claim about the paper's later analytic results or the
Riemann hypothesis.

OEIS A137825 independently records the same optimization sequence, with
offset zero and eighth term 180180. The entry was created in 2008 and cites
Wu's Table 1. This formalization is therefore not a claim of mathematical
novelty or a newly resolved open problem.

## Verified locator

- https://arxiv.org/html/1906.05796, Theorem 1 and Table 1, read 2026-09-07.
- https://doi.org/10.48550/arXiv.1906.05796, HTTP 302 to the arXiv abstract,
  then HTTP 200, checked 2026-09-07.
- https://oeis.org/A137825, JSON entry and offset checked 2026-09-07.
