using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.CoefficientBounds;

internal sealed class SepticEnvelopeUpperLowDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The constant and linear coefficients of the septic upper remainder are nonnegative.",
        H("Lower Powers of the First Gap"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("septic-upper-constant-coefficient"),
                DeclarationHandle.Create("D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperLow.upper_coeff0_nonneg"),
                H("Constant Coefficient"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Write twelve times the septic joint upper remainder as a polynomial in the "
                    + "first root gap. Its constant and linear coefficients have positive expansions "
                    + "with 937 and 687 monomials in the other five gaps. Exact polynomial identities "
                    + "and nonnegativity of the gaps prove both signs for arbitrary real inputs."))),
                DescribeRole.Theorem))));
}
