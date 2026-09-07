# First Li Coefficient Positivity

## Abstract

Public rational bounds certify strict positivity of the canonical first Li coefficient.

These mathematical estimates already occur as local facts in the frozen FirstLiCoefficientNormalization proof. The freezing rule prevents adding public declarations to that module, so they are proved again here as reusable public theorems. This contribution exposes an existing estimate; it is not a new analytical theorem or a claim of literature novelty.

**Lemma 1.1 (Euler-Mascheroni lower bound).**

$$\frac{11}{20} < \operatorname{eulerMascheroniConstant}\left(\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.eleven_twentieths_lt_eulerMascheroniConstant` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The twentieth lower approximant is bounded using the first fourteen terms of the exponential series at 3047/1000. This proves the preregistered strict lower bound and feeds the coefficient inequality.

**Lemma 1.2 (Logarithmic upper bound).**

$$\operatorname{log}\left(4 \cdot \pi\right) < \frac{51}{20}$$

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.log_four_pi_lt_fifty_one_twentieths` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The first ten terms of the exponential series at 51/20, together with the rational bound pi < 3.1416, prove the second preregistered estimate. Both numerical thresholds are unchanged.

**Theorem 1.3 (Strict positivity of the explicit coefficient).**

$$0 < 1 + \frac{\operatorname{eulerMascheroniConstant}\left(\right)}{2} - \operatorname{log}\left(2 \cdot \operatorname{sqrt}\left(\pi\right)\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.first_li_coefficient_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The two public rational estimates are consumed after rewriting the logarithm as half the logarithm of four pi. Their thresholds cancel exactly, and the strict inequalities give strict positivity. The argument does not infer a sign from nonvanishing.

**Theorem 1.4 (Identification with the canonical endpoint reading).**

$$1 + \frac{\operatorname{eulerMascheroniConstant}\left(\right)}{2} - \operatorname{log}\left(2 \cdot \operatorname{sqrt}\left(\pi\right)\right) = \operatorname{re}\left(\frac{\operatorname{deriv}\left(xiReading, 1\right)}{\operatorname{xiReading}\left(1\right)}\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.first_li_coefficient_eq_log_deriv_re` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Taking real parts of the first conjunct of the frozen normalization theorem gives this identity. It is a bind-only companion, consumed by the following strict endpoint inequality.

**Theorem 1.5 (Positive real part at one).**

$$0 < \operatorname{re}\left(\frac{\operatorname{deriv}\left(xiReading, 1\right)}{\operatorname{xiReading}\left(1\right)}\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.xi_log_deriv_one_re_pos` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The identity transports the explicit strict positivity to the canonical xi logarithmic derivative at one. The terminal use directly solves only the first Li coefficient positivity clause. It does not close an entire atom, prove the full Li criterion, or settle the Riemann hypothesis.

## References

- Truth anchor: `D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.eleven_twentieths_lt_eulerMascheroniConstant`
- Truth anchor: `D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.first_li_coefficient_eq_log_deriv_re`
- Truth anchor: `D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.first_li_coefficient_pos`
- Truth anchor: `D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.log_four_pi_lt_fifty_one_twentieths`
- Truth anchor: `D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.xi_log_deriv_one_re_pos`
- Dependency: [D5/S3/Zeros/Endpoints/FirstLiCoefficientNormalization](FirstLiCoefficientNormalization.md)
