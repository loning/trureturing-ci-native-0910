using YamlDotNet.RepresentationModel;
using FixtureFile = StrataLint.TestSupport.TemporaryFileSystem.File;

namespace StrataLint.Tests;

// Static contracts only. Cache visibility and GitHub Actions execution require a real run.
public sealed class JudgeCacheSaveWorkflowTests
{
    private const string Build = "Build candidate with warnings as errors";
    private const string Stage = "Stage judge binaries for the shared cache (dev push only)";
    private const string Save = "Save judge binaries and candidate build outputs by content address (dev push only)";
    private const string Tests = "Run candidate engineering tests with resource observation";

    [Fact]
    public void JudgeCacheSaveImmediatelyFollowsCandidateBuild()
    {
        var steps = Steps(EngineeringJob());
        var build = steps.IndexOf(Step(steps, Build));
        var stage = steps.IndexOf(Step(steps, Stage));
        var save = steps.IndexOf(Step(steps, Save));
        var tests = steps.IndexOf(Step(steps, Tests));

        Assert.Equal(build + 1, stage);
        Assert.Equal(stage + 1, save);
        Assert.True(save < tests);
    }

    [Fact]
    public void JudgeCacheSaveRequiresSuccessfulBuildAndStageOnDevPush()
    {
        var steps = Steps(EngineeringJob());
        var build = Step(steps, Build);
        var stage = Step(steps, Stage);
        var save = Step(steps, Save);

        Assert.Equal("build-candidate", Scalar(build, "id"));
        Assert.Equal("stage-judge", Scalar(stage, "id"));
        Assert.Equal("github.event_name == 'push' && github.ref == 'refs/heads/dev'", Scalar(stage, "if"));
        // Exact preservation also retains Actions' implicit success() status guard.
        Assert.Equal(
            "steps.build-candidate.outcome == 'success' && steps.stage-judge.outcome == 'success' && github.event_name == 'push' && github.ref == 'refs/heads/dev'",
            Scalar(save, "if"));
        foreach (var step in new[] { build, stage, save })
            Assert.False(step.Children.ContainsKey("continue-on-error"));
    }

    [Fact]
    public void JudgeCacheSaveRetainsExactContentAddressAndPaths()
    {
        var save = Step(Steps(EngineeringJob()), Save);

        Assert.Equal("actions/cache/save@v4", Scalar(save, "uses"));
        var inputs = Assert.IsType<YamlMappingNode>(save.Children["with"]);
        Assert.Equal(
            ".judge-binaries\ncandidate/tools/**/bin\ncandidate/tools/**/obj\n",
            Scalar(inputs, "path"));
        Assert.Equal(
            "stratalint-judge-binaries-v2-${{ runner.os }}-${{ steps.judge-address.outputs.runtime }}-${{ steps.judge-address.outputs.address }}",
            Scalar(inputs, "key"));
        Assert.False(inputs.Children.ContainsKey("restore-keys"));
    }

    [Fact]
    public void JudgeCacheStagingPublishesBothOriginalPayloads()
    {
        var stage = Step(Steps(EngineeringJob()), Stage);

        Assert.Equal("bash", Scalar(stage, "shell"));
        Assert.Equal("""
            set -euo pipefail
            mkdir -p .judge-binaries/cli .judge-binaries/scribe
            dotnet publish candidate/tools/StrataLint.Cli/StrataLint.Cli.csproj \
              --configuration Release --output .judge-binaries/cli
            dotnet publish candidate/tools/StrataLint.Scribe.Documents/StrataLint.Scribe.Documents.csproj \
              --configuration Release --output .judge-binaries/scribe
            test -s .judge-binaries/cli/StrataLint.dll
            test -s .judge-binaries/scribe/StrataLint.Scribe.Documents.dll
            """ + "\n", Scalar(stage, "run"));
    }

    [Fact]
    public void JudgeCacheSaveKeepsSubsequentChecksBlocking()
    {
        var job = EngineeringJob();
        var steps = Steps(job);
        var names = new[]
        {
            Tests,
            "Run candidate selftest twice and compare bytes",
            "Audit repository capacity after merge",
            "Prove missing capability does not compile",
            "Prove banned deterministic APIs do not compile",
        };
        Assert.False(job.Children.ContainsKey("continue-on-error"));
        var previous = steps.IndexOf(Step(steps, Build));
        foreach (var name in names)
        {
            var step = Step(steps, name);
            var index = steps.IndexOf(step);
            Assert.True(previous < index);
            previous = index;
            Assert.False(step.Children.ContainsKey("continue-on-error"));
            Assert.Equal("bash", Scalar(step, "shell"));
            if (name == "Audit repository capacity after merge")
                Assert.Equal("github.event_name == 'push' && !cancelled()", Scalar(step, "if"));
            else
                Assert.False(step.Children.ContainsKey("if"));
        }

        Assert.Equal(
            "/bin/bash candidate/tools/scripts/workflow/engineering-test-execution-harness.sh \"$GITHUB_WORKSPACE/candidate\"",
            Scalar(Step(steps, Tests), "run"));
        Assert.Equal("make -C candidate/tools selftest", Scalar(Step(steps, names[1]), "run"));
        Assert.Equal(
            "make -C candidate/tools capacity-audit REPOSITORY=\"$GITHUB_WORKSPACE/candidate\"",
            Scalar(Step(steps, names[2]), "run"));
        var capability = Scalar(Step(steps, names[3]), "run");
        Assert.Contains("CompileFailProof/CompileFailProof.csproj --no-restore --configuration Release", capability, StringComparison.Ordinal);
        Assert.Contains("test \"$status\" -ne 0\n", capability, StringComparison.Ordinal);
        Assert.Contains("grep -F \"CS7036\" <<<\"$output\"\n", capability, StringComparison.Ordinal);
        Assert.Contains("grep -F \"MetaClear\" <<<\"$output\"\n", capability, StringComparison.Ordinal);
        var banned = Scalar(Step(steps, names[4]), "run");
        Assert.Contains("BannedApiCompileFailProof/BannedApiCompileFailProof.csproj --no-restore --configuration Release", banned, StringComparison.Ordinal);
        Assert.Contains("test \"$status\" -ne 0\n", banned, StringComparison.Ordinal);
        Assert.Contains("test \"${#expected_lines[@]}\" -gt 0\n", banned, StringComparison.Ordinal);
        Assert.Contains("test \"${#actual_lines[@]}\" -eq \"${#expected_lines[@]}\"\n", banned, StringComparison.Ordinal);
        Assert.Contains("test -z \"$(grep -F ': error ' <<<\"$output\" | grep -vF ': error RS0030:' || true)\"\n", banned, StringComparison.Ordinal);
        Assert.Contains("test \"${actual_lines[$index]}\" = \"$expected_line\"\n", banned, StringComparison.Ordinal);
    }

    private static YamlMappingNode EngineeringJob()
    {
        using var temporary = new TemporaryDirectory();
        var path = Path.Combine(temporary.Path, "ci.yml");
        ScriptHarnessScratch.CopyScriptInto(
            Path.Combine(TestRepositoryLayout.FindRoot(), ".github/workflows/ci.yml"), path);
        using var reader = new StringReader(FixtureFile.ReadAllText(path));
        var yaml = new YamlStream();
        yaml.Load(reader);
        var root = Assert.IsType<YamlMappingNode>(Assert.Single(yaml.Documents).RootNode);
        var jobs = Assert.IsType<YamlMappingNode>(root.Children["jobs"]);
        return Assert.IsType<YamlMappingNode>(jobs.Children["candidate-engineering"]);
    }

    private static List<YamlMappingNode> Steps(YamlMappingNode job) =>
        Assert.IsType<YamlSequenceNode>(job.Children["steps"]).Children
            .Select(node => Assert.IsType<YamlMappingNode>(node)).ToList();

    private static YamlMappingNode Step(IEnumerable<YamlMappingNode> steps, string name) =>
        Assert.Single(steps, step => Scalar(step, "name") == name);

    private static string Scalar(YamlMappingNode node, string key) =>
        Assert.IsType<YamlScalarNode>(node.Children[key]).Value!;
}
