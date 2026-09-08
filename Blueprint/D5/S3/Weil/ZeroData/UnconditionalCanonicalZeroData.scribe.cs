using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZeroData;

internal sealed class UnconditionalCanonicalZeroDataDocument : IScribeDocumentDefinition
{
    private const string Declaration = "D5/S3/Weil/ZeroData/UnconditionalCanonicalZeroData.zetaZeroData_closed_chain";

    public DocumentDefinition Create()
    {
        return DocumentDefinition.Create(ScribeNode.Create(
            "The unconditional Gamma and Riemann-von Mangoldt sources produce a fixed exhaustive zeta ZeroData presentation.",
            H("Unconditional Canonical Zeta ZeroData"),
            Blocks(Describe.Lean(
                DescribeId.Create("unconditionalcanonicalzerodata"),
                DeclarationHandle.Create(Declaration),
                H("Unconditional Canonical Zeta ZeroData"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The unconditional Gamma and Riemann-von Mangoldt sources produce a fixed exhaustive zeta ZeroData presentation."))),
                DescribeRole.Theorem))));
    }
}
