using System.Text;
using StrataLint.Cli;
using StrataLint.Engine;
using TemporaryFileSystem = StrataLint.TestSupport.TemporaryFileSystem;

namespace StrataLint.Tests;

public sealed class CoverAtomLedgerPersistenceTests
{
    private const string AlphaGid = "D5/S0/Carrier/Alpha.alpha";
    private const string ZetaGid = "D5/S0/Carrier/Zeta.zeta";

    [Fact]
    public void CoverAtomWritesCoverageGidsInOrdinalByteOrderWithoutScribeReceipts()
    {
        var definition = DigestionFingerprint.Compute(
            Encoding.UTF8.GetBytes("scribe definition\n")).RawSha256;
        var emission = DigestionFingerprint.Compute(
            Encoding.UTF8.GetBytes("# emitted narrative\n")).RawSha256;
        var inputs = MaterializeSpec() with
        {
            InitialCoverage = [ZetaGid],
            InitialDefinitionSha256 = definition,
            InitialEmissionSha256 = emission,
            Migration = "absorbed",
            Truth = "closed",
            BaselineTargetIdentical = true,
        };
        var world = inputs.Materialize();
        using var repository = new TemporaryDirectory();
        var environment = Environment(repository, world, world.Document, world.Document);

        var result = environment.CoverAtom(
            ["--cover-atom", inputs.AtomId, "--gid", AlphaGid, "--base", "baseline"]);

        Assert.True(result.Success, result.Error);
        AssertCanonicalGidBytes(ReadAtomBytes(repository, inputs.AtomId));
    }

    private static CoverSpec MaterializeSpec() => new()
    {
        ModuleGid = "D5/S0/Carrier/Zeta",
        Declaration = "zeta",
        ReportDeclarations = ["zeta"],
        SecondaryTarget = ("D5/S0/Carrier/Alpha", "alpha"),
    };

    private static ProductionCliEnvironment Environment(
        TemporaryDirectory repository,
        CoverInputs world,
        BackfillInventoryDocument currentDocument,
        BackfillInventoryDocument baselineDocument)
    {
        var currentFiles = new Dictionary<string, string>(world.Files, StringComparer.Ordinal);
        var baselineFiles = new Dictionary<string, string>(world.Baseline, StringComparer.Ordinal);
        DirectoryLedgerTestSupport.ReplaceWithProjection(currentFiles, currentDocument);
        DirectoryLedgerTestSupport.ReplaceWithProjection(baselineFiles, baselineDocument);
        DirectoryLedgerTestSupport.Write(repository.Path, currentFiles);
        return new ProductionCliEnvironment(
            repository.Path,
            new FakeRepositoryGateway(
                RawChangeSet.Create(Array.Empty<string>()),
                CoverWorld.Raw(currentFiles),
                CoverWorld.Raw(baselineFiles)),
            new FakeLeanReportSource(world.Report),
            new FakeScribeEmissionVerifier(world.VerifiedEmissions),
            CoverWorld.TimeProvider);
    }

    private static byte[] ReadAtomBytes(TemporaryDirectory repository, string atomId)
    {
        var ledgerRoot = Path.Combine(
            repository.Path,
            BackfillInventoryLoader.RootPath.Replace('/', Path.DirectorySeparatorChar));
        var path = Assert.Single(Directory.EnumerateFiles(
            ledgerRoot,
            atomId + ".yaml",
            SearchOption.AllDirectories));
        return TemporaryFileSystem.File.ReadAllBytes(path);
    }

    private static void AssertCanonicalGidBytes(byte[] bytes)
    {
        var text = new UTF8Encoding(false, true).GetString(bytes);
        var receipts = text.IndexOf("receipts:\n", StringComparison.Ordinal);
        var alphaCoverage = text.IndexOf($"  - gid: {AlphaGid}\n", StringComparison.Ordinal);
        var zetaCoverage = text.IndexOf($"  - gid: {ZetaGid}\n", StringComparison.Ordinal);
        Assert.True(alphaCoverage >= 0 && alphaCoverage < zetaCoverage && zetaCoverage < receipts, text);
        Assert.DoesNotContain("scribe", text, StringComparison.Ordinal);
    }
}
