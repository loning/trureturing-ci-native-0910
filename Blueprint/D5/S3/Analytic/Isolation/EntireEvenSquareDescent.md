# Entire Even Square Descent

## Abstract

Entire even functions descend uniquely through squaring, including the centered xi reading.

**Theorem 1.1 (Unique entire descent).**

$$Entire\left(f\right)\land Even\left(f\right)\Rightarrow\exists!F:Entire\left(F\right)\land \forall b,F\left(b^{2}\right)=f\left(b\right)$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Isolation/EntireEvenSquareDescent.entire_even_square_descent` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

For an entire even function on the complex plane, choose the value at a square root of each argument. The two roots differ by sign, so evenness makes the choice irrelevant. Near each nonzero argument, the inverse function theorem supplies a differentiable local square root, and the candidate agrees with composition through that local inverse.

At zero the principal square root is continuous. The candidate is therefore continuous at zero and differentiable in its punctured neighborhood. The removable singularity theorem gives analyticity at zero. Every complex number is a square, which proves uniqueness even among factors without a regularity assumption.

**Theorem 1.2 (Centered xi descent and values).**

$$\exists!F:Entire\left(F\right)\land {\forall b,F\left(b^{2}\right)=xiReading\left(\frac{1}{2}+b\right)}\land F\left(0\right)=xiReading\left(\frac{1}{2}\right)\land F\left(\frac{1}{4}\right)=\frac{1}{2}$$

*Proof.* Machine-checked in Lean as `D5/S3/Analytic/Isolation/EntireEvenSquareDescent.xi_reading_square_descent` (`✓ std3`). ∎

*Source.* Repository-derived.

*Commentary.*

The frozen entire xi reading becomes even after translation by one half. Applying the general descent gives its unique entire factor. Substitution of zero gives the central value; substitution of one half and the frozen xi value at one give the value one half at one quarter.

The result does not establish positivity of the central value, division by that value, Taylor coefficient identification, a theta representation, probability or moment identities, or a Riemann hypothesis equivalence.

## References

- Truth anchor: `D5/S3/Analytic/Isolation/EntireEvenSquareDescent.entire_even_square_descent`
- Truth anchor: `D5/S3/Analytic/Isolation/EntireEvenSquareDescent.xi_reading_square_descent`
- Dependency: [D5/S3/Zeros/Endpoints/XiEndpointValues](../../Zeros/Endpoints/XiEndpointValues.md)
