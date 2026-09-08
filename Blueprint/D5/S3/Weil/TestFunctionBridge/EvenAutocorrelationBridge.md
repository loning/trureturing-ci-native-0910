# Even Autocorrelation

## Abstract

The real part of a smooth compact autocorrelation is an even Weil test function.

Write W for the space of even smooth compactly supported complex functions on the real line. Write iota for the inclusion of the reals into the complexes. The autocorrelation input may be complex valued and need not be even.

**Definition 1.1 (Complex autocorrelation).**

$$A(f)(x) = \int_{\mathbb{R}} f(t) \cdot \overline{f(t-x)} \mathrm{d}t$$

*Formalization.* `D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge.autocorrelation` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For every function f from the reals to the complexes, A(f)(x) is the Lebesgue integral of f(t) times the conjugate of f(t-x).

**Theorem 1.2 (Reversing the lag conjugates the value).**

$$\forall f: \mathbb{R} \to \mathbb{C}, \forall x \in \mathbb{R}, A(f)(-x) = \overline{A(f)(x)}$$

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge.autocorrelation_conj_symm` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

Translation by minus x changes the integrand at lag minus x to f(t-x) times the conjugate of f(t). Conjugation of the integral and commutativity of complex multiplication give the identity. Mathlib's integral conventions make it valid for arbitrary f.

**Definition 1.3 (The even Weil test).**

$$f \in C_{c}^{\infty}(\mathbb{R}; \mathbb{C}) \Rightarrow E(f) = \iota \circ \Re \circ A(f) \in W$$

*Formalization.* `D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge.evenAutocorrelation` (`✓ std3`).

*Source.* Repository-derived.

*Commentary.*

For smooth compactly supported f, convolution with its conjugate reflection is smooth and compactly supported by mathlib's convolution theorems. Taking the real part and including it in the complexes preserves those properties. Conjugate symmetry supplies evenness.

**Theorem 1.4 (Evaluation of the even test).**

$$E(f)(x) = \iota(\Re(\int_{\mathbb{R}} f(t) \cdot \overline{f(t-x)} \mathrm{d}t))$$

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge.evenAutocorrelation_apply` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For every smooth compactly supported f and every real x, the bundled test evaluates to the complex inclusion of the real part of the integral.

**Theorem 1.5 (Agreement on even inputs).**

$$\forall g \in W, E(g) = \operatorname{convolutionSquare}(g)$$

*Proof.* Machine-checked in Lean as `D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge.evenAutocorrelation_eq_convolutionSquare` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For an even Weil test g, the existing convolution square equals A(g) and is even. Combined with conjugate symmetry, this makes A(g) real valued. Its real part therefore recovers the same function, and extensionality gives equality in W. This comparison asserts no sign for a Weil reading.

## References

- Truth anchor: `D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge.autocorrelation`
- Truth anchor: `D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge.autocorrelation_conj_symm`
- Truth anchor: `D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge.evenAutocorrelation`
- Truth anchor: `D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge.evenAutocorrelation_apply`
- Truth anchor: `D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge.evenAutocorrelation_eq_convolutionSquare`
