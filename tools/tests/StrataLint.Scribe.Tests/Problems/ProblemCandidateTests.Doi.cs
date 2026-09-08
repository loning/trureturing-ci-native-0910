namespace StrataLint.Scribe.Tests;

public sealed partial class ProblemCandidateTests
{
    [Theory]
    [InlineData("null")]
    [InlineData("2305.08349")]
    [InlineData("arXiv:2305.08349")]
    [InlineData("2305.08349v1")]
    [InlineData("2305.083491")]
    [InlineData("")]
    [InlineData("https://doi.org/10.1006/eujc.1998.0211")]
    [InlineData("10.1006/")]
    [InlineData("10.1006/with space")]
    public void CatalogRejectsMalformedDoi(string doi) => WithCatalog(
        new Dictionary<string, string>(StringComparer.Ordinal)
        {
            ["sample-open-problem.md"] = DoiCandidate(doi),
        },
        root =>
        {
            var error = Assert.Throws<FormatException>(() => ProblemCandidateCatalog.Load(root));
            Assert.Contains("doi", error.Message, StringComparison.OrdinalIgnoreCase);
        });

    [Fact]
    public void CatalogRejectsBothSourceKeys() => WithCatalog(
        new Dictionary<string, string>(StringComparer.Ordinal)
        {
            ["sample-open-problem.md"] = Candidate("sample-open-problem")
                .Replace("triage: theorem", "arxiv_id: 2305.08349\ntriage: theorem",
                    StringComparison.Ordinal),
        },
        root =>
        {
            var error = Assert.Throws<FormatException>(() => ProblemCandidateCatalog.Load(root));
            Assert.Contains("missing or unknown metadata fields", error.Message, StringComparison.Ordinal);
        });

    [Theory]
    [InlineData("arxiv_id: 2305.08349")]
    [InlineData("doi: 10.48550/arXiv.2305.08349\narxiv_id: 2305.08349")]
    public void ValidatorRejectsArxivIdMetadata(string source) => WithRepository(
        Candidate("sample-open-problem")
            .Replace("doi: 10.48550/arXiv.2305.08349", source, StringComparison.Ordinal),
        Note("sos1957threegap", "10.48550/arXiv.2305.08349"),
        ["D5/S1/Phase/Basic"],
        root =>
        {
            var finding = Assert.Single(DescribeRepositoryValidator.Validate(root, []));
            Assert.Equal("invalid-problem-candidate", finding.Code);
            Assert.Equal("Problems/sample-open-problem.md", finding.Path);
            Assert.Contains("missing or unknown metadata fields", finding.Message, StringComparison.Ordinal);
        },
        ["D5/S1/Phase/Basic"]);

    [Fact]
    public void CatalogRejectsUnknownFieldInDoiForm() => WithCatalog(
        new Dictionary<string, string>(StringComparer.Ordinal)
        {
            ["sample-open-problem.md"] = DoiCandidate("10.1006/eujc.1998.0211")
                .Replace("triage: theorem", "status: resolved\ntriage: theorem", StringComparison.Ordinal),
        },
        root => Assert.Throws<FormatException>(() => ProblemCandidateCatalog.Load(root)));

    [Theory]
    [InlineData("10.1006/eujc.1998.0211")]
    [InlineData("10.4153/CMB-1986-050-0")]
    [InlineData("10.48550/arXiv.2305.08349")]
    [InlineData("10.46298/dmtcs.17199")]
    public void CatalogAcceptsCompleteDoiWithoutArxivId(string doi) => WithCatalog(
        new Dictionary<string, string>(StringComparer.Ordinal)
        {
            ["sample-open-problem.md"] = DoiCandidate(doi),
        },
        root =>
        {
            var candidate = Assert.Single(ProblemCandidateCatalog.Load(root).Candidates);
            Assert.Equal("sample-open-problem", candidate.Slug);
            Assert.Equal(doi, candidate.Doi.Value);
        });

    [Theory]
    [InlineData("10.1006/eujc.1998.0211")]
    [InlineData("10.48550/arXiv.2305.08349")]
    [InlineData("10.46298/dmtcs.17199")]
    public void ValidatorAcceptsExactDoiBinding(string doi) => WithDoiRepository(
        doi, doi, root =>
        {
            Assert.Equal(doi, Assert.Single(ProblemCandidateCatalog.Load(root).Candidates).Doi.Value);
            Assert.Empty(DescribeRepositoryValidator.Validate(root, []));
        });

    [Theory]
    [InlineData("10.4153/CMB-1986-050-0", "10.4153/cmb-1986-050-0")]
    [InlineData("10.48550/arXiv.2305.08349", "10.48550/arxiv.2305.08349")]
    public void ValidatorRejectsDoiBindingThatDiffersOnlyInCase(string doi, string noteDoi) => WithDoiRepository(
        doi, noteDoi,
        root => Assert.Equal("problem-source-mismatch",
            Assert.Single(DescribeRepositoryValidator.Validate(root, [])).Code));

    [Fact]
    public void ValidatorRejectsDoiBindingToDifferentWork() => WithDoiRepository(
        "10.1006/eujc.1998.0211", "10.1216/rmj-2013-43-5-1707",
        root => Assert.Equal("problem-source-mismatch",
            Assert.Single(DescribeRepositoryValidator.Validate(root, [])).Code));

    [Fact]
    public void ValidatorRejectsDoiBindingToNoteWithoutDoi() => WithDoiRepository(
        "10.1006/eujc.1998.0211", "null",
        root => Assert.Equal("problem-source-mismatch",
            Assert.Single(DescribeRepositoryValidator.Validate(root, [])).Code));

    [Fact]
    public void ValidatorRejectsDoiBindingToMalformedNoteDoi() => WithDoiRepository(
        "10.1006/eujc.1998.0211", "not-a-doi",
        root =>
        {
            var findings = DescribeRepositoryValidator.Validate(root, []);
            Assert.Contains(findings, finding => finding.Code == "invalid-doi");
            Assert.Contains(findings, finding => finding.Code == "dangling-problem-bibkey");
        });

    [Fact]
    public void ValidatorRejectsDoiBindingWithoutExternalNote() => WithRepository(
        DoiCandidate("10.1006/eujc.1998.0211"),
        Note("slater1967gaps", "10.1006/eujc.1998.0211"),
        ["D5/S1/Phase/Basic"],
        root => Assert.Equal("dangling-problem-bibkey",
            Assert.Single(DescribeRepositoryValidator.Validate(root, [])).Code),
        ["D5/S1/Phase/Basic"]);

    private static string DoiCandidate(string doi) => Candidate("sample-open-problem", doi: doi);

    private static void WithDoiRepository(string doi, string noteDoi, Action<string> assertion) =>
        WithRepository(DoiCandidate(doi), Note("sos1957threegap", noteDoi),
            ["D5/S1/Phase/Basic"], assertion, ["D5/S1/Phase/Basic"]);
}
