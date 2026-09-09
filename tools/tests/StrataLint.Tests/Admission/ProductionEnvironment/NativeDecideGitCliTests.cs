using System.Text;
using StrataLint.Cli;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed partial class ProductionEnvironmentTests
{
    [Theory]
    [InlineData("native_decide", 1)]
    [InlineData("decide", 0)]
    public void GitCliAnonymousEmptyReportDispatchesSourceRule(string tactic, int expected)
    {
        using var temporary = new TemporaryDirectory();
        var root = Path.Combine(temporary.Path, "repository");
        var fixture = TrustedFrozenFixture();
        fixture.Files["Meta/registry.yaml"] = TestRegistry.Canonical;
        fixture.Files["Meta/domains.yaml"] = TestRegistry.Domains;
        foreach (var file in Snapshot(fixture.Files).Entries)
        {
            var target = Path.Combine(root, file.Path);
            Directory.CreateDirectory(Path.GetDirectoryName(target)!);
            File.WriteAllBytes(target, file.Bytes.ToArray());
        }
        Git("init", "--quiet");
        Git("add", ".");
        Git("-c", "user.name=Source Context Fixture", "-c", "user.email=source-context@example.invalid",
            "commit", "--quiet", "--no-gpg-sign", "-m", "source fixture baseline");
        var baseline = Git("rev-parse", "HEAD").Trim();
        const string path = "D5/S0/Carrier/Anonymous.lean";
        File.WriteAllText(Path.Combine(root, path), "/- GID: D5/S0/Carrier/Anonymous\n"
            + "   generality: G\n   mirror-B: none(waiver:test-fixture)\n   mirror-E: none(waiver:test-fixture)\n"
            + "   anchors: []\n   utility: none\n   digest: Anonymous source admission fixture. -/\n"
            + $"example : True := by {tactic}\n", new UTF8Encoding(false));
        Git("add", path);
        var gateway = new GitRepositoryGateway(root);
        var snapshot = Decode(gateway.ReadCurrent());
        fixture.Reports[path] = new LeanFileReport([], []);
        var report = Path.Combine(temporary.Path, "report.json");
        RawLeanReportArtifact.WriteFile(report, snapshot, LeanAxiomReport.Create(fixture.Reports));
        Assert.Empty(RawLeanReportArtifact.ReadFile(report, snapshot).Files[RepoPath.CreateKnown(path)].Declarations);
        Assert.False(Directory.Exists(Path.Combine(root, ".lake")));
        var console = new BufferedConsole();
        var code = CliApplication.Run(["check", "--protected-base", baseline, "--candidate-lean-report", report],
            new ProductionCliEnvironment(root, gateway, new FakeLeanReportSource(null)), console);
        Assert.True(code == expected, console.Output + console.Error);
        if (expected == 1)
            Assert.Contains("NATIVE_DECIDE_SOURCE line=8", console.Output, StringComparison.Ordinal);
        else Assert.DoesNotContain("NATIVE_DECIDE_SOURCE", console.Output, StringComparison.Ordinal);

        string Git(params string[] arguments)
        {
            var result = TestProcessRunner.Run("git", arguments, root, BoundedProcessRunner.HangDetectionBudget, 1024 * 1024);
            Assert.True(result.ExitCode == 0, Encoding.UTF8.GetString(result.StandardError));
            return Encoding.UTF8.GetString(result.StandardOutput);
        }
    }
}
