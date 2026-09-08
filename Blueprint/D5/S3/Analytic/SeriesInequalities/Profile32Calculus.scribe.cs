using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Analytic.SeriesInequalities;

internal sealed class Profile32CalculusDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The unnormalized cubic three-halves profile is concave on the full open unit interval.",
        H("Concavity of the Cubic Three-Halves Profile"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("profile32-concave"),
                DeclarationHandle.Create(
                    "D5/S3/Analytic/SeriesInequalities/Profile32Calculus.profile32_concave"),
                H("The cubic profile is concave"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "For the cubic x^3 - 3x + 2t, sum the three-halves powers of the "
                        + "absolute inverse-gap scores over its distinct real roots, and "
                        + "raise this sum to negative four thirds. This function of t is "
                        + "concave for every -1 < t < 1.")),
                    Paragraph(Text(
                        "An increasing explicit chart maps the whole open unit interval "
                        + "onto itself. On its positive half, the exact radical certificate "
                        + "makes the derivative of the profile slope strictly negative.")),
                    Paragraph(Text(
                        "The chart profile is continuously differentiable at zero. "
                        + "Continuity extends the slope comparison to zero, and evenness "
                        + "of the profile makes its slope odd, giving antitonicity across "
                        + "both halves. Cauchy's mean value theorem then compares adjacent "
                        + "secant slopes, which implies concavity.")),
                    Paragraph(Text(
                        "The proof assumes no second derivative at the zero score and "
                        + "imposes no minimum root gap. It concerns only this explicit "
                        + "one-parameter cubic family."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("profile32-even"),
                DeclarationHandle.Create(
                    "D5/S3/Analytic/SeriesInequalities/Profile32Calculus.profile32_even"),
                H("The profile is even on its domain"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The chart is odd and the transformed profile is even, so reflection "
                    + "preserves the original profile throughout the open unit interval."))),
                DescribeRole.Theorem))));
}
