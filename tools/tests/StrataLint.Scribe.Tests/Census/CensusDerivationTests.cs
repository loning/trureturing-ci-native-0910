using System.Collections.Immutable;

namespace StrataLint.Scribe.Tests;

public sealed class CensusDerivationTests
{
    [Fact]
    public void ReceiptClassificationRejectsAnEmptyDocumentCorpus()
    {
        var exception = Assert.Throws<InvalidOperationException>(() =>
            ReceiptFreeDocumentCatalog.Load("not-read-for-empty-corpus", []));

        Assert.Contains("document corpus must not be empty", exception.Message, StringComparison.Ordinal);
    }

    // The receipt census is gone with the field it classified (#6349). Its one non-constant
    // clause compared a set of document GIDs against the document count, which reads as a
    // uniqueness judgement — but a trigger PR showed that state is unreachable here: document
    // discovery throws first, and with a better message. This pins the judge that actually
    // fires, so the census can be deleted without losing the judgement.
    [Fact]
    public void DistinctEmissionTargetsAreAccepted()
    {
        var first = DocumentDefinition.Create(
            Document("D5/S0/Test/DistinctOne"), "Blueprint/D5/S0/Test/DistinctOne.scribe.cs");
        var second = DocumentDefinition.Create(
            Document("D5/S0/Test/DistinctTwo"), "Blueprint/D5/S0/Test/DistinctTwo.scribe.cs");

        Assert.Equal(2, DocumentDefinitions.RequireDistinctEmissionTargets([first, second]).Length);
    }

    [Fact]
    public void DocumentDiscoveryRejectsTwoDefinitionsTargetingOneEmission()
    {
        var definition = DocumentDefinition.Create(
            Document("D5/S0/Test/DiscoveryDuplicate"),
            "Blueprint/D5/S0/Test/DiscoveryDuplicate.scribe.cs");

        var exception = Assert.Throws<InvalidOperationException>(() =>
            DocumentDefinitions.RequireDistinctEmissionTargets([definition, definition]));

        Assert.Contains("Multiple Scribe definitions target", exception.Message, StringComparison.Ordinal);
        Assert.Contains("D5/S0/Test/DiscoveryDuplicate", exception.Message, StringComparison.Ordinal);
    }

    private static ScribeDocument Document(string gid) =>
        ScribeDocument.Create(
            DefinitionDsl.Header(gid, "Document discovery fixture."),
            DefinitionDsl.H(gid),
            DefinitionDsl.Blocks(DefinitionDsl.Paragraph(DefinitionDsl.Text("fixture"))));
}
