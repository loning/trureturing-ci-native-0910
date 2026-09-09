using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaRvm;

internal sealed class NcountWindowDocument : IScribeDocumentDefinition
{
    private const string Declaration = "D5/S3/Weil/ZetaRvm/NcountWindow.Ncount_add";

    public DocumentDefinition Create()
    {
        return DocumentDefinition.Create(ScribeNode.Create(
            "Multiplicity-weighted zero counts are additive across adjacent windows.",
            H("Zero-Count Window Arithmetic"),
            Blocks(Describe.Lean(
                DescribeId.Create("ncountwindow"),
                DeclarationHandle.Create(Declaration),
                H("Zero-Count Window Arithmetic"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Multiplicity-weighted zero counts are additive across adjacent windows."))),
                DescribeRole.Theorem))));
    }
}
