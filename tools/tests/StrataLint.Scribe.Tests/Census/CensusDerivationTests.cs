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

    // The receipt census retired with `receipts.scribe` (#6349). Five of its six clauses were
    // tautologies once nothing could be receipt-bound; the sixth compared a set of document
    // GIDs against the document count, which is a uniqueness judgement and the only one in the
    // repository. It survives as `duplicate-document-gid`, and now names the collisions.
    [Fact]
    public void DistinctDocumentGidsProduceNoFinding()
    {
        var findings = ImmutableArray.CreateBuilder<DescribeRedFinding>();

        DescribeContentGovernance.ValidateDocumentGidUniqueness(
            [Document("D5/S0/Test/DistinctOne"), Document("D5/S0/Test/DistinctTwo")],
            findings);

        Assert.Empty(findings);
    }

    [Fact]
    public void RepeatedDocumentGidIsRejectedAndNamed()
    {
        const string repeated = "D5/S0/Test/Repeated";
        var findings = ImmutableArray.CreateBuilder<DescribeRedFinding>();

        DescribeContentGovernance.ValidateDocumentGidUniqueness(
            [Document(repeated), Document("D5/S0/Test/Other"), Document(repeated)],
            findings);

        var finding = Assert.Single(findings);
        Assert.Equal("duplicate-document-gid", finding.Code);
        Assert.Contains(repeated, finding.Message, StringComparison.Ordinal);
        Assert.DoesNotContain("D5/S0/Test/Other", finding.Message, StringComparison.Ordinal);
    }

    [Fact]
    public void EveryRepeatedGidIsNamedOnceInOrdinalOrder()
    {
        const string alpha = "D5/S0/Test/AlphaRepeat";
        const string zeta = "D5/S0/Test/ZetaRepeat";
        var findings = ImmutableArray.CreateBuilder<DescribeRedFinding>();

        DescribeContentGovernance.ValidateDocumentGidUniqueness(
            [Document(zeta), Document(alpha), Document(zeta), Document(alpha)],
            findings);

        var finding = Assert.Single(findings);
        Assert.EndsWith($"{alpha}, {zeta}", finding.Message, StringComparison.Ordinal);
    }

    private static ScribeDocument Document(string gid) =>
        ScribeDocument.Create(
            DefinitionDsl.Header(gid, "Document GID uniqueness fixture."),
            DefinitionDsl.H(gid),
            DefinitionDsl.Blocks(DefinitionDsl.Paragraph(DefinitionDsl.Text("fixture"))));
}
