using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaPntBase;

internal sealed class ZetaConjDocument : IScribeDocumentDefinition
{
    private const string Declaration = "D5/S3/Weil/ZetaPntBase/ZetaConj.logDerivZeta_conj";

    public DocumentDefinition Create()
    {
        return DocumentDefinition.Create(ScribeNode.Create(
            "Complex conjugation commutes with the zeta logarithmic derivative.",
            H("Zeta Conjugation Identities"),
            Blocks(Describe.Lean(
                DescribeId.Create("zetaconj"),
                DeclarationHandle.Create(Declaration),
                H("Zeta Conjugation Identities"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Complex conjugation commutes with the zeta logarithmic derivative."))),
                DescribeRole.Theorem))));
    }
}
