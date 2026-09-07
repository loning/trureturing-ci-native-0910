# Continuous Prime Maximum

## Abstract

The continuous prime-direction objective has a unique maximum on the nonnegative ray.

All parameters and exponents below are real. The base p is greater than one; primality is not required. Write f_p(t) for the following benefit:

$f_{p}(t) = log\left(\frac{1 - p^{-(t+1)}}{1 - p^{-1}}\right)$

**Theorem 1.1 (Derivative on the nonnegative ray).**

$$1 < p \land 0 \le x \Rightarrow f_{p}'(x) = \frac{log\left(p\right)}{p^{x+1}-1}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/ContinuousPrimeMaximum.continuous_prime_hasDerivAt` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The proof differentiates the real power, the quotient and the logarithm. Positivity of both logarithm arguments is proved from p > 1 and x >= 0.

**Theorem 1.2 (Strict decrease of the slope).**

$$1 < p \land 0 \le u < v \Rightarrow \frac{log\left(p\right)}{p^{v+1}-1} < \frac{log\left(p\right)}{p^{u+1}-1}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/ContinuousPrimeMaximum.continuous_prime_slope_strictAntiOn` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The real power strictly increases with the exponent. Its positive shifted reciprocal therefore strictly decreases.

**Theorem 1.3 (The unique maximum).**

$$\begin{aligned}p y x \in \mathbb{R}, 1 < p, 2 < y, 0 \le x\\a = max\left(0, \frac{log\left(y\right)}{log\left(p\right)} - 1\right)\\f_{p}(x) - \frac{x log\left(p\right)}{y - 1} \le f_{p}(a) - \frac{a log\left(p\right)}{y - 1}\\(f_{p}(x) - \frac{x log\left(p\right)}{y - 1} = f_{p}(a) - \frac{a log\left(p\right)}{y - 1}) \iff x = a\end{aligned}$$

*Proof.* Machine-checked in Lean as `D5/S3/Arith/GoldenResource/ContinuousPrimeMaximum.continuous_prime_unique_maximum` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For p < y the critical exponent is positive, the objective strictly increases up to it and strictly decreases after it. For y <= p the maximum is the boundary exponent zero; strict decrease on the positive ray also covers p = y. These comparisons establish both the upper bound and its exact equality condition.

## References

- Truth anchor: `D5/S3/Arith/GoldenResource/ContinuousPrimeMaximum.continuous_prime_hasDerivAt`
- Truth anchor: `D5/S3/Arith/GoldenResource/ContinuousPrimeMaximum.continuous_prime_slope_strictAntiOn`
- Truth anchor: `D5/S3/Arith/GoldenResource/ContinuousPrimeMaximum.continuous_prime_unique_maximum`
