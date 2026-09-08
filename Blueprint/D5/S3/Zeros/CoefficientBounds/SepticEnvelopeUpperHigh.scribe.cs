using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.CoefficientBounds;

internal sealed class SepticEnvelopeUpperHighDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The remaining five coefficients of the septic upper remainder are nonnegative.",
        H("Higher Powers of the First Gap"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("septic-upper-quadratic-coefficient"),
                DeclarationHandle.Create("D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperHigh.upper_coeff2_nonneg"),
                H("Quadratic Coefficient"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "In twelve times the septic joint upper remainder, the coefficients of powers "
                    + "two through six of the first gap have positive expansions with 489, 329, "
                    + "210, 117 and 60 monomials. Each coefficient is nonnegative for every "
                    + "nonnegative real five-tuple of the remaining gaps. The seven coefficient "
                    + "signs together yield the joint upper bound."))),
                DescribeRole.Theorem))));
}
