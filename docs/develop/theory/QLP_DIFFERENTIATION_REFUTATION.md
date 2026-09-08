# Weak q-Laguerre-Polya differentiation refutation

Source: Dimitar K. Dimitrov and Boris Shapiro, *Weak and strong q-analogs
of the Laguerre-Polya class*, arXiv:2606.17864v1, 16 June 2026,
https://arxiv.org/pdf/2606.17864v1. Question 6.2 on page 12 asks whether
the weak class is closed under differentiation. Equation (1.6) and
Definition 1.1 on page 3 define the normalized transform and its inverse
image of the classical Laguerre-Polya class.

The assertion below is the proposed polynomial refutation, not a theorem
attributed to that paper. Every real polynomial is a real entire function.
For polynomials, classical Laguerre-Polya membership is equivalent to
splitting over the real numbers. Thus closure for the entire-function
class would imply the polynomial closure assertion negated below. That
analytic interpretation is not asserted as an additional Lean theorem.

## Theorem: Polynomial differentiation closure fails

For a real polynomial f with ordinary coefficients c_k, define the
normalized transform by the finite polynomial sum

\[
B_q f(z)=\sum_{k\geq 0}c_k k!\,
\frac{q^{k(k-1)/2}(1-q)^k}{\prod_{j=0}^{k-1}(1-q^{j+1})}\,z^k.
\]

The empty product is one. The factor k! converts ordinary coefficients
to the exponential coefficients of the source paper. Let Splits mean
splitting into linear factors over the real numbers, including zero
and constants. The following universally quantified assertion is false:
for every real q with 0<q<1 and every real polynomial f,

\[
\operatorname{Splits}(B_q f)\ \Longrightarrow\
\operatorname{Splits}(B_q(f')).
\]

Here the negation is of the whole universally quantified assertion;
no statement for every individually fixed q is included in this theorem.
