using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class WeilMovingScaleResidualDocument : IScribeDocumentDefinition
{
    private const string Owner = "D5/S3/Weil/ZetaBridge/WeilMovingScaleResidual.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Candidate mathematical source. No Lean or Scribe compiler execution is asserted.",
        H("Moving-Scale Arithmetic Residuals"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("weil-moving-scale-residualScaleMass"),
                DeclarationHandle.Create(Owner + "residualScaleMass"),
                H("Finite mass of the actual arithmetic residual"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Expand the same four boundary moments and physical Cauchy prefactor used in the existing full-tail owner. This cutoff-independent mass retains every contribution. Its finite numerical cap is a certificate input, not a tail oracle."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("weil-moving-scale-arithmetic-budget-le-quadratic"),
                DeclarationHandle.Create(Owner + "arithmetic_budget_le_quadratic"),
                H("All-prime-cutoff arithmetic envelope"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The actual arithmeticBoundaryBudget at every integer c>=2 is at most c^2+2c. Use the existing von Mangoldt nonnegativity and logarithmic bound, sqrt(j)>=1 for j>=1, and cosh(log(c)/2)<=cosh(log(c)). The zero index is handled separately. This elementary coarse envelope uses no prime number theorem or all-scale spectral assumption."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("weil-moving-scale-residual-scale-mass-polynomial"),
                DeclarationHandle.Create(Owner + "residual_scale_mass_polynomial"),
                H("Polynomial mass from finite coefficient certificates"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The finite l1 bound L, bandwidth N and physical prefactor bound P give mass<=32(c^2+2c)^2 L^2(1+N^2+4N^4)+64P^2. Bound all four actual moments before simplifying. This supplies the moving-scale mass input from ordinary finite data. It is conservative and is not intended to replace sharper numerical moment bounds."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("weil-moving-scale-full-residual-le-mass-div"),
                DeclarationHandle.Create(Owner + "full_residual_le_mass_div"),
                H("Actual full exterior bounded by mass divided by cutoff"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Reuse arithmetic_full_residual_tail, prove M/(M-N)<=2 for M>=2N, and bound the remaining inverse powers for M>=1. The conclusion includes full two-sided square summability. The original sharper three-power bound remains unchanged."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("weil-moving-scale-rationalResidualCutoff"),
                DeclarationHandle.Create(Owner + "rationalResidualCutoff"),
                H("Executable rational truncation schedule"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Take the maximum of the trial-bandwidth guard, Fourier-frequency guard and one plus the natural ceiling of gain*mass/tolerance. Only exact rational and natural arithmetic occurs. Total evaluation is distinct from the positive-tolerance semantic guarantee."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("weil-moving-scale-rationalResidualCutoff-sound"),
                DeclarationHandle.Create(Owner + "rationalResidualCutoff_sound"),
                H("Strict soundness including integer boundaries"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The cutoff dominates both structural guards. Natural-ceiling soundness plus one gives gain*mass<tolerance*M, including zero gain and an exactly integral ratio. No claim of the least or efficient cutoff is made."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("weil-moving-scale-weighted-residual-cutoff"),
                DeclarationHandle.Create(Owner + "weighted_residual_cutoff"),
                H("Apply the finite schedule to the actual omitted residual"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Consume the actual symbol, finite trial support, bounded physical frequency and certified finite mass. The schedule bounds gain times the complete omitted squared residual by tolerance. The gain may contain the reciprocal coercivity, so a uniform lower spectral-gap bound is not assumed."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("weil-moving-scale-moving-scale-exterior-tendstoUniformlyOn"),
                DeclarationHandle.Create(Owner + "moving_scale_exterior_tendstoUniformlyOn"),
                H("Uniform disappearance on a varying-scale family"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use the rational tolerance 4^(-(j+1)) and one common cutoff per target set. The certified mass and gain may grow arbitrarily fast. Standard Mathlib TendstoUniformlyOn records the uniform statement. This proves numerical-tail disappearance only; the retained energy-dual objective, retained residual and same-candidate prolate approximation remain independent obligations. The actual Fourier limit transfer already belongs to EnergyDualPaperFT in PR #5882."))),
                DescribeRole.Theorem))));
}
