using YamlDotNet.RepresentationModel;

namespace StrataLint.Tests;

// Static contracts only. GitHub Actions execution and cache visibility require a real run.
public sealed class ReportCacheSaveWorkflowTests
{
    private const string Produce = "Produce source-bound canonical Lean reports";
    private const string Stage = "Stage candidate canonical Lean report cache";
    private const string Save = "Save candidate canonical Lean report (dev push only)";

    [Fact]
    public void ReportCacheSaveImmediatelyFollowsValidatedBundleProduction()
    {
        var steps = LeanSteps();
        var produce = steps.IndexOf(Step(steps, Produce));
        var stage = steps.IndexOf(Step(steps, Stage));
        var save = steps.IndexOf(Step(steps, Save));
        var content = steps.IndexOf(Step(steps, "Run complete mathematical content checks"));

        Assert.Equal(produce + 1, stage);
        Assert.Equal(stage + 1, save);
        Assert.Equal(save + 1, content);
    }

    [Fact]
    public void ReportCacheSaveRetainsKeyPathAndDevPushMissCondition()
    {
        var save = Step(LeanSteps(), Save);

        Assert.Equal("actions/cache/save@v4", Scalar(save, "uses"));
        Assert.Equal(
            "success() && steps.lean-report-input.outputs.address != '' && steps.report-reuse.outcome != 'success' && github.event_name == 'push' && github.ref == 'refs/heads/dev'",
            Scalar(save, "if"));
        var inputs = Assert.IsType<YamlMappingNode>(save.Children["with"]);
        Assert.Equal(".canonical-lean-report-cache", Scalar(inputs, "path"));
        Assert.Equal("stratalint-canonical-lean-report-v2-${{ steps.lean-report-input.outputs.address }}", Scalar(inputs, "key"));
    }

    [Fact]
    public void ReportProductionAndStagingFailuresBlockCacheSave()
    {
        var steps = LeanSteps();
        var produce = Step(steps, Produce);
        var stage = Step(steps, Stage);
        Assert.Equal("steps.report-reuse.outcome != 'success'", Scalar(produce, "if"));
        Assert.False(stage.Children.ContainsKey("if"));
        foreach (var step in new[] { produce, stage })
        {
            Assert.False(step.Children.ContainsKey("continue-on-error"));
            Assert.Equal("bash", Scalar(step, "shell"));
            Assert.StartsWith("set -euo pipefail\n", Scalar(step, "run"), StringComparison.Ordinal);
        }
        Assert.StartsWith("success() && ", Scalar(Step(steps, Save), "if"), StringComparison.Ordinal);
        Assert.Contains("\"$pair_producer\" \\\n", Scalar(produce, "run"), StringComparison.Ordinal);
    }

    [Fact]
    public void ReportStagingChecksCompleteBundleAndEndsWithInputVerification()
    {
        var run = Scalar(Step(LeanSteps(), Stage), "run");

        Assert.Contains("for suffix in '' .input.attestation .provenance.json .materials.zip; do\n", run, StringComparison.Ordinal);
        Assert.Contains("test -s \"${source}${suffix}\"", run, StringComparison.Ordinal);
        Assert.Contains("cp \"${source}${suffix}\" \"${target}${suffix}\"", run, StringComparison.Ordinal);
        Assert.Contains("read -r declaredSha256 declaredName < \"${source}.sha256\"", run, StringComparison.Ordinal);
        Assert.Contains("test \"$declaredSha256\" = \"$reportSha256\"", run, StringComparison.Ordinal);
        Assert.Contains("test \"$declaredName\" = \"$(basename \"$source\")\"", run, StringComparison.Ordinal);
        Assert.EndsWith("""
            "$GITHUB_WORKSPACE/candidate/tools/scripts/report/lean-report-input.sh" verify \
              --repository "$GITHUB_WORKSPACE/candidate" \
              --report "$target"
            """, run.TrimEnd(), StringComparison.Ordinal);
    }

    private static List<YamlMappingNode> LeanSteps()
    {
        var yaml = new YamlStream();
        using var reader = new StringReader(File.ReadAllText(
            Path.Combine(TestRepositoryLayout.FindRoot(), ".github/workflows/ci.yml")));
        yaml.Load(reader);
        var root = Assert.IsType<YamlMappingNode>(Assert.Single(yaml.Documents).RootNode);
        var jobs = Assert.IsType<YamlMappingNode>(root.Children["jobs"]);
        var job = Assert.IsType<YamlMappingNode>(jobs.Children["lean-inspect"]);
        return Assert.IsType<YamlSequenceNode>(job.Children["steps"]).Children
            .Select(node => Assert.IsType<YamlMappingNode>(node)).ToList();
    }

    private static YamlMappingNode Step(IEnumerable<YamlMappingNode> steps, string name) =>
        Assert.Single(steps, step => Scalar(step, "name") == name);

    private static string Scalar(YamlMappingNode node, string key) =>
        Assert.IsType<YamlScalarNode>(node.Children[key]).Value!;
}
