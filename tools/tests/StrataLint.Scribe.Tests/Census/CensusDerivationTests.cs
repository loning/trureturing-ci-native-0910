using System.Collections.Immutable;
using StrataLint.Engine;

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

    [Fact]
    public void SyntheticDirectoryLedgerDeterminesCensusDirection()
    {
        const string receiptBoundGid = "D5/S0/Test/ReceiptBound";
        const string receiptFreeGid = "D5/S0/Test/ReceiptFree";
        var repositoryRoot = Path.Combine(
            Path.GetTempPath(),
            "stratalint-census-" + Guid.NewGuid().ToString("N"));
        var sourceRoot = Path.Combine(
            repositoryRoot,
            "Meta", "Digestion", "backfill", "synthetic-source");
        TemporaryFileSystem.Directory.CreateDirectory(Path.Combine(sourceRoot, "absorbed-closed"));
        try
        {
            TemporaryFileSystem.File.WriteAllText(
                Path.Combine(sourceRoot, "source.toml"),
                """
                source_id = "synthetic-source"
                path = "docs/synthetic.md"
                atomizer = "synthetic-v1"
                genre_registry_check = "collected"
                unregistered_genres = []

                """.Replace("\r\n", "\n", StringComparison.Ordinal));
            TemporaryFileSystem.File.WriteAllText(
                Path.Combine(
                    sourceRoot,
                    "absorbed-closed",
                    "0000000000000000000000000000000000000000000000000000000000000000.yaml"),
                $$"""
                fingerprints:
                  raw_sha256: sha256:0000000000000000000000000000000000000000000000000000000000000000
                  normalized_sha256: sha256:0000000000000000000000000000000000000000000000000000000000000000
                cas_ref: sha256:0000000000000000000000000000000000000000000000000000000000000000
                coverage_gids: []
                receipts:
                  scribe:
                    - gid: {{receiptBoundGid}}.formalized
                      definition_sha256: sha256:1111111111111111111111111111111111111111111111111111111111111111
                      emission_sha256: sha256:2222222222222222222222222222222222222222222222222222222222222222
                  unresolved_subitems: []
                  chain_atoms: []
                  tail_authorization: null
                """);
            var census = ReceiptFreeDocumentCatalog.Load(
                repositoryRoot,
                [Document(receiptBoundGid), Document(receiptFreeGid)]);

            Assert.Equal([receiptBoundGid], census.ReceiptBoundDocumentGids);
            Assert.Equal([receiptFreeGid], census.ReceiptFreeDocumentGids);
        }
        finally
        {
            TemporaryFileSystem.Directory.Delete(repositoryRoot, recursive: true);
        }
    }

    // L2c 的终态:scribe 字节收据被全部剥离,故"有收据的文档集"为空。
    // 这**不是**异常 —— 剥离收据正是该迁移的目标(#6214 剥掉最后 881 条)。
    // 此前 ValidateCensus 有一条 `expectedBound.IsEmpty` 析取,使终态一落地
    // dev 就红在 receipt-census;空跑保护由 ReceiptFreeDocumentCatalog.Load
    // 承担(见上面那条 RejectsAnEmptyDocumentCorpus),不需要这条间接判据。
    [Fact]
    public void CensusAcceptsACorpusWhoseReceiptsHaveAllBeenStripped()
    {
        const string firstGid = "D5/S0/Test/StrippedOne";
        const string secondGid = "D5/S0/Test/StrippedTwo";
        var repositoryRoot = Path.Combine(
            Path.GetTempPath(),
            "stratalint-census-" + Guid.NewGuid().ToString("N"));
        var sourceRoot = Path.Combine(
            repositoryRoot,
            "Meta", "Digestion", "backfill", "synthetic-source");
        TemporaryFileSystem.Directory.CreateDirectory(Path.Combine(sourceRoot, "absorbed-closed"));
        try
        {
            TemporaryFileSystem.File.WriteAllText(
                Path.Combine(sourceRoot, "source.toml"),
                """
                source_id = "synthetic-source"
                path = "docs/synthetic.md"
                atomizer = "synthetic-v1"
                genre_registry_check = "collected"
                unregistered_genres = []

                """.Replace("\r\n", "\n", StringComparison.Ordinal));
            TemporaryFileSystem.File.WriteAllText(
                Path.Combine(
                    sourceRoot,
                    "absorbed-closed",
                    "0000000000000000000000000000000000000000000000000000000000000000.yaml"),
                """
                fingerprints:
                  raw_sha256: sha256:0000000000000000000000000000000000000000000000000000000000000000
                  normalized_sha256: sha256:0000000000000000000000000000000000000000000000000000000000000000
                cas_ref: sha256:0000000000000000000000000000000000000000000000000000000000000000
                coverage_gids: []
                receipts:
                  scribe: []
                  unresolved_subitems: []
                  chain_atoms: []
                  tail_authorization: null
                """);
            var findings = ImmutableArray.CreateBuilder<DescribeRedFinding>();

            DescribeContentGovernance.ValidateCensus(
                repositoryRoot,
                [Document(firstGid), Document(secondGid)],
                findings);

            Assert.DoesNotContain(findings, finding => finding.Code == "receipt-census");
        }
        finally
        {
            TemporaryFileSystem.Directory.Delete(repositoryRoot, recursive: true);
        }
    }

    [Fact]
    public void CensusRejectsOverlappingReceiptSets()
    {
        const string firstGid = "D5/S0/Test/OverlapOne";
        const string secondGid = "D5/S0/Test/OverlapTwo";

        var findings = ValidateClassification(
            documentGids: [firstGid, secondGid],
            receiptFreeGids: [firstGid, secondGid],
            receiptBoundGids: [secondGid],
            ledgerReceiptBoundGids: [secondGid]);

        Assert.Contains(findings, finding => finding.Code == "receipt-census");
    }

    [Fact]
    public void CensusAcceptsDisjointReceiptSetsThatMatchTheLedger()
    {
        const string receiptFreeGid = "D5/S0/Test/DisjointFree";
        const string receiptBoundGid = "D5/S0/Test/DisjointBound";

        var findings = ValidateClassification(
            documentGids: [receiptFreeGid, receiptBoundGid],
            receiptFreeGids: [receiptFreeGid],
            receiptBoundGids: [receiptBoundGid],
            ledgerReceiptBoundGids: [receiptBoundGid]);

        Assert.DoesNotContain(findings, finding => finding.Code == "receipt-census");
    }

    [Fact]
    public void CensusRejectsADocumentClassifiedInNeitherSet()
    {
        const string classifiedGid = "D5/S0/Test/Classified";
        const string omittedGid = "D5/S0/Test/Omitted";

        var findings = ValidateClassification(
            documentGids: [classifiedGid, omittedGid],
            receiptFreeGids: [classifiedGid],
            receiptBoundGids: [],
            ledgerReceiptBoundGids: []);

        Assert.Contains(findings, finding => finding.Code == "receipt-census");
    }

    [Fact]
    public void CensusRejectsAReceiptBoundSetThatDisagreesWithTheLedger()
    {
        const string ledgerBoundGid = "D5/S0/Test/LedgerBound";
        const string ledgerFreeGid = "D5/S0/Test/LedgerFree";

        var findings = ValidateClassification(
            documentGids: [ledgerBoundGid, ledgerFreeGid],
            receiptFreeGids: [ledgerBoundGid],
            receiptBoundGids: [ledgerFreeGid],
            ledgerReceiptBoundGids: [ledgerBoundGid]);

        Assert.Contains(findings, finding => finding.Code == "receipt-census");
    }

    private static ImmutableArray<DescribeRedFinding> ValidateClassification(
        string[] documentGids,
        string[] receiptFreeGids,
        string[] receiptBoundGids,
        string[] ledgerReceiptBoundGids)
    {
        var documents = Gids(documentGids);
        var ledgerBound = Gids(ledgerReceiptBoundGids);
        var findings = ImmutableArray.CreateBuilder<DescribeRedFinding>();
        DescribeContentGovernance.ValidateCensusClassification(
            documents,
            new ReceiptFreeDocumentCensus(Gids(receiptFreeGids), Gids(receiptBoundGids)),
            ledgerBound.Intersect(documents, StringComparer.Ordinal)
                .ToImmutableHashSet(StringComparer.Ordinal),
            documents.Except(ledgerBound, StringComparer.Ordinal)
                .ToImmutableHashSet(StringComparer.Ordinal),
            documentGids.Length,
            findings);
        return findings.ToImmutable();
    }

    private static ImmutableHashSet<string> Gids(params string[] gids) =>
        gids.ToImmutableHashSet(StringComparer.Ordinal);

    private static ScribeDocument Document(string gid) =>
        ScribeDocument.Create(
            DefinitionDsl.Header(gid, "Receipt census fixture."),
            DefinitionDsl.H(gid),
            DefinitionDsl.Blocks(DefinitionDsl.Paragraph(DefinitionDsl.Text("fixture"))));
}
