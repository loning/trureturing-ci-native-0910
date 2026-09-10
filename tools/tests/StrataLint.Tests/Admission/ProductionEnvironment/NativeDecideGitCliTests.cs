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
        => CheckAnonymousSource(tactic, expected);

    [Theory]
    [InlineData(false, false, false)]
    [InlineData(false, true, false)]
    [InlineData(true, false, false)]
    [InlineData(true, true, false)]
    [InlineData(false, false, true)]
    [InlineData(false, true, true)]
    [InlineData(true, false, true)]
    [InlineData(true, true, true)]
    public void GitCliAttributeCharCompilesPreparesAndAdmitsWithEmptyReport(
        bool localTheorem, bool attribute, bool modified)
    {
        var prefix = "import Init\n"
            + (localTheorem ? "theorem attr_control : True := by trivial\n" : "")
            + (attribute ? $"attribute [simp] {(localTheorem ? "attr_control" : "Nat.add_zero")}\n" : "")
            + "example : ')' =')' := by decide\n";
        CheckAnonymousSource("decide", 0, prefix, modified, prepareContext: true);
    }

    private static void CheckAnonymousSource(string tactic, int expected, string prefix = "",
        bool modified = false, bool prepareContext = false)
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
        const string path = "D5/S0/Carrier/Anonymous.lean";
        const string header = "/- GID: D5/S0/Carrier/Anonymous\n"
            + "   generality: G\n   mirror-B: none(waiver:test-fixture)\n   mirror-E: none(waiver:test-fixture)\n"
            + "   anchors: []\n   utility: none\n   digest: Anonymous source admission fixture. -/\n";
        if (modified)
            File.WriteAllText(Path.Combine(root, path), header + "example : True := by decide\n", new UTF8Encoding(false));
        if (prepareContext)
        {
            foreach (var relative in new[] { "lakefile.toml", "lean-toolchain", "lake-manifest.json",
                "tools/lean-inspector/SourceContext.lean", "tools/lean-inspector/SourceOptions.lean",
                "tools/lean-inspector/source-context.py", "tools/lean-inspector/source-context.sh",
                "tools/StrataLint.Cli/Commands/LeanSourceInputCommand.cs",
                "tools/StrataLint.Engine/Ledger/Admission/LeanSourceHeader.cs" })
            {
                var target = Path.Combine(root, relative);
                Directory.CreateDirectory(Path.GetDirectoryName(target)!);
                File.Copy(Path.Combine(TestRepositoryLayout.FindRoot(), relative), target);
            }
            File.WriteAllText(Path.Combine(root, ".gitignore"), ".lake/\n");
        }
        Git("init", "--quiet");
        Git("add", ".");
        Git("-c", "user.name=Source Context Fixture", "-c", "user.email=source-context@example.invalid",
            "commit", "--quiet", "--no-gpg-sign", "-m", "source fixture baseline");
        var baseline = Git("rev-parse", "HEAD").Trim();
        File.WriteAllText(Path.Combine(root, path), header + prefix + $"example : True := by {tactic}\n", new UTF8Encoding(false));
        Git("add", path);
        var gateway = new GitRepositoryGateway(root);
        var snapshot = Decode(gateway.ReadCurrent());
        fixture.Reports[path] = new LeanFileReport(prefix.Length == 0 ? [] : ["Init"], []);
        var report = Path.Combine(temporary.Path, "report.json");
        RawLeanReportArtifact.WriteFile(report, snapshot, LeanAxiomReport.Create(fixture.Reports));
        Assert.Empty(RawLeanReportArtifact.ReadFile(report, snapshot).Files[RepoPath.CreateKnown(path)].Declarations);
        Assert.False(Directory.Exists(Path.Combine(root, ".lake")));
        if (prepareContext)
        {
            QualifiedSourceContextFixture.EnsureCompilerCache();
            RunPreparation("compile", path);
            RunPreparation("first");
            var context = LeanSourceContextInput.Load(File.ReadAllBytes(report + ".source-context.json"),
                snapshot, Decode(gateway.ReadRevision(baseline)));
            var parsed = context.GetFile(snapshot, RepoPath.CreateKnown(path), "current");
            Assert.False(parsed.InitialEquality);
            Assert.All(parsed.Commands, command => Assert.False(command.Equality));
            Assert.Empty(context.MalformedRows);
        }
        var console = new BufferedConsole();
        var code = CliApplication.Run(["check", "--protected-base", baseline, "--candidate-lean-report", report],
            new ProductionCliEnvironment(root, gateway, new FakeLeanReportSource(null)), console);
        Assert.True(code == expected, console.Output + console.Error);
        if (expected == 1)
            Assert.Contains("NATIVE_DECIDE_SOURCE line=8", console.Output, StringComparison.Ordinal);
        else Assert.DoesNotContain("NATIVE_DECIDE_SOURCE", console.Output, StringComparison.Ordinal);

        void RunPreparation(params string[] arguments)
        {
            var run = TestProcessRunner.Run("python3", ["-c", QualifiedSourceContextScripts.Preparation,
                TestRepositoryLayout.FindRoot(), root, report, baseline, .. arguments], TestRepositoryLayout.FindRoot(),
                BoundedProcessRunner.HangDetectionBudget, 4 * 1024 * 1024);
            Assert.True(run.ExitCode == 0, $"{arguments[0]}: " + Encoding.UTF8.GetString(run.StandardOutput)
                + Encoding.UTF8.GetString(run.StandardError));
        }

        string Git(params string[] arguments)
        {
            var result = TestProcessRunner.Run("git", arguments, root, BoundedProcessRunner.HangDetectionBudget, 1024 * 1024);
            Assert.True(result.ExitCode == 0, Encoding.UTF8.GetString(result.StandardError));
            return Encoding.UTF8.GetString(result.StandardOutput);
        }
    }
}
