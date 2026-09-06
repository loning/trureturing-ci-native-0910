using YamlDotNet.RepresentationModel;
using FixtureFile = StrataLint.TestSupport.TemporaryFileSystem.File;

namespace StrataLint.Tests;

// Static YAML and condition contracts only; Actions runtime behavior needs a real run.
public sealed class ReportSingleFlightWorkflowTests
{
    private const string Restore = "Restore canonical Lean report by input address";
    private const string Wait = "Wait for an in-flight canonical Lean report";
    private const string Retry = "Retry the exact canonical Lean report address";
    private const string Reuse = "Serve candidate canonical Lean report from the cached address";

    [Fact]
    public void ReportCacheMissWaitIsStaticallyBounded()
    {
        var steps = Steps(Job(Workflow(), "lean-inspect"));
        var wait = Step(steps, Wait);
        Assert.Equal(steps.IndexOf(Step(steps, Restore)) + 1, steps.IndexOf(wait));
        Assert.Equal(steps.IndexOf(wait) + 1, steps.IndexOf(Step(steps, Retry)));
        Assert.Equal(steps.IndexOf(Step(steps, Retry)) + 1, steps.IndexOf(Step(steps, Reuse)));
        Assert.Equal("report-cache-wait", Scalar(wait, "id"));
        Assert.Equal("steps.lean-report-input.outputs.address != '' && steps.report-cache.outcome == 'success' && steps.report-cache.outputs.cache-hit != 'true'", Scalar(wait, "if"));
        Assert.Equal("sleep 300", Scalar(wait, "run"));
        Assert.Equal("6", Scalar(wait, "timeout-minutes"));
        Assert.Equal("true", Scalar(wait, "continue-on-error"));
    }

    [Fact]
    public void ReportCacheRetryUsesOnlyTheOriginalExactAddress()
    {
        var steps = Steps(Job(Workflow(), "lean-inspect"));
        var retry = Step(steps, Retry);
        var inputs = Mapping(retry, "with");
        Assert.Equal("report-cache-retry", Scalar(retry, "id"));
        Assert.Equal("steps.report-cache-wait.outcome == 'success'", Scalar(retry, "if"));
        Assert.Equal("actions/cache/restore@v4", Scalar(retry, "uses"));
        Assert.Equal("true", Scalar(retry, "continue-on-error"));
        Assert.Equal("2", Scalar(retry, "timeout-minutes"));
        Assert.Equal(".canonical-lean-report-cache", Scalar(inputs, "path"));
        Assert.Equal("stratalint-canonical-lean-report-v2-${{ steps.lean-report-input.outputs.address }}", Scalar(inputs, "key"));
        Assert.Equal(Scalar(Mapping(Step(steps, Restore), "with"), "key"), Scalar(inputs, "key"));
        Assert.False(inputs.Children.ContainsKey("restore-keys"));
    }

    [Fact]
    public void ReportCacheMissTimeoutOrFailureKeepsFullFallback()
    {
        var steps = Steps(Job(Workflow(), "lean-inspect"));
        var reuse = Step(steps, Reuse);
        Assert.Equal("report-reuse", Scalar(reuse, "id"));
        Assert.Equal("(steps.report-cache.outcome == 'success' && steps.report-cache.outputs.cache-hit == 'true') || (steps.report-cache-retry.outcome == 'success' && steps.report-cache-retry.outputs.cache-hit == 'true')", Scalar(reuse, "if"));
        Assert.Equal("true", Scalar(reuse, "continue-on-error"));
        Assert.Equal("2", Scalar(reuse, "timeout-minutes"));
        foreach (var name in new[]
        {
            "Restore elan and pinned Lean toolchains", "Install pinned Lean toolchains",
            "Restore candidate Lean dependency artifacts", "Restore candidate Lean project build artifacts",
            "Build candidate Lean project", "Produce source-bound canonical Lean reports",
        })
            Assert.Equal("steps.report-reuse.outcome != 'success'", Scalar(Step(steps, name), "if"));
        var produce = Step(steps, "Produce source-bound canonical Lean reports");
        Assert.False(produce.Children.ContainsKey("continue-on-error"));
        Assert.Contains("\"$pair_producer\" \\\n", Scalar(produce, "run"), StringComparison.Ordinal);
    }

    [Fact]
    public void ReportCacheReuseRevalidatesCompleteIdentityBeforeCopy()
    {
        var run = Scalar(Step(Steps(Job(Workflow(), "lean-inspect")), Reuse), "run");
        Assert.StartsWith("set -euo pipefail\n", run, StringComparison.Ordinal);
        Assert.Contains("for suffix in '' .sha256 .input.attestation .provenance.json .materials.zip; do\n", run, StringComparison.Ordinal);
        Assert.Contains("test -s \"${source}${suffix}\"", run, StringComparison.Ordinal);
        const string verify = "\"$helper\" verify --repository \"$GITHUB_WORKSPACE/candidate\" --report \"$source\"";
        Assert.Contains(verify, run, StringComparison.Ordinal);
        Assert.Contains("producer=\"$(awk -F= '$1 == \"producer_sha256\" {print $2}' \"${source}.input.attestation\")\"", run, StringComparison.Ordinal);
        Assert.Contains("sources=\"${{ steps.lean-input.outputs.sources_sha256 }}\"", run, StringComparison.Ordinal);
        Assert.Contains("config=\"${{ steps.lean-input.outputs.config_sha256 }}\"", run, StringComparison.Ordinal);
        Assert.Contains("printf 'schema=stratalint-lean-report-input-v1\\nproducer_sha256=%s\\nrepository_inspector_sha256=%s\\nlean_sources_sha256=%s\\nlean_config_sha256=%s\\n'", run, StringComparison.Ordinal);
        Assert.Contains("\"$producer\" \"$producer\" \"$sources\" \"$config\" | sha256sum | cut -d ' ' -f 1", run, StringComparison.Ordinal);
        Assert.Contains("""
            jq -e -s --arg producer "$producer" --arg sources "$sources" --arg config "$config" \
              --arg input "sha256:$input" --arg report "$(sha256sum "$source" | cut -d ' ' -f 1)" '
              length == 1 and (.[0] == {schema: "stratalint-lean-report-provenance-v1", side: "candidate",
                mode: .[0].mode, source_side: "candidate", input_address: $input,
                producer_sha256: $producer, repository_inspector_sha256: $producer,
                lean_sources_sha256: $sources, lean_config_sha256: $config, report_sha256: $report}
              and (.[0].mode == "produced" or .[0].mode == "cached"))' "${source}.provenance.json" > /dev/null
            """, run, StringComparison.Ordinal);
        var validation = run.IndexOf("jq -e ", StringComparison.Ordinal);
        Assert.True(run.IndexOf(verify, StringComparison.Ordinal) < validation);
        Assert.True(validation < run.IndexOf("cp \"${source}${suffix}\"", StringComparison.Ordinal));
    }

    [Fact]
    public void ReportCacheWaitKeepsIndependentContentChecksAndAdmission()
    {
        var workflow = Workflow();
        var lean = Job(workflow, "lean-inspect");
        var admission = Job(workflow, "baseline-admission");
        Assert.False(lean.Children.ContainsKey("continue-on-error"));
        Assert.False(admission.Children.ContainsKey("continue-on-error"));
        Assert.Equal("lean-inspect", Scalar(admission, "needs"));
        var content = Step(Steps(lean), "Run complete mathematical content checks");
        var gate = Step(Steps(admission), "Run the harness gate with the candidate's own judge");
        foreach (var step in new[] { content, gate })
        {
            Assert.False(step.Children.ContainsKey("if"));
            Assert.False(step.Children.ContainsKey("continue-on-error"));
        }
        Assert.Contains("scribe-content-checks.sh", Scalar(content, "run"), StringComparison.Ordinal);
        Assert.Contains("--candidate-lean-report \"$RUNNER_TEMP/raw-lean-reports/candidate-lean-report.json\"", Scalar(gate, "run"), StringComparison.Ordinal);
        Assert.Contains("sha256sum -c candidate-lean-report.json.sha256", Scalar(Step(Steps(admission), "Verify report content addresses"), "run"), StringComparison.Ordinal);
    }

    [Fact]
    public void ReportCacheWaitAddsNoConcurrencyOrCancellation()
    {
        var workflow = Workflow();
        // Preserve the inherited PR policy; each dev push remains in its own SHA group.
        var concurrency = Mapping(workflow, "concurrency");
        Assert.Equal("ci-${{ github.event.pull_request.number || github.sha }}", Scalar(concurrency, "group"));
        Assert.Equal("true", Scalar(concurrency, "cancel-in-progress"));
        foreach (var job in Mapping(workflow, "jobs").Children.Values)
        {
            var mapping = Assert.IsType<YamlMappingNode>(job);
            Assert.False(mapping.Children.ContainsKey("concurrency"));
            Assert.All(Steps(mapping), step =>
            {
                Assert.False(step.Children.ContainsKey("concurrency"));
                if (step.Children.TryGetValue("run", out var run))
                {
                    var script = Assert.IsType<YamlScalarNode>(run).Value!;
                    Assert.DoesNotContain("gh run cancel", script, StringComparison.Ordinal);
                    Assert.DoesNotContain("/cancel", script, StringComparison.Ordinal);
                }
            });
        }
    }

    private static YamlMappingNode Workflow()
    {
        using var temporary = new TemporaryDirectory();
        var path = Path.Combine(temporary.Path, "ci.yml");
        ScriptHarnessScratch.CopyScriptInto(
            Path.Combine(TestRepositoryLayout.FindRoot(), ".github/workflows/ci.yml"), path);
        using var reader = new StringReader(FixtureFile.ReadAllText(path));
        var yaml = new YamlStream();
        yaml.Load(reader);
        return Assert.IsType<YamlMappingNode>(Assert.Single(yaml.Documents).RootNode);
    }

    private static YamlMappingNode Mapping(YamlMappingNode node, string key) =>
        Assert.IsType<YamlMappingNode>(node.Children[key]);

    private static YamlMappingNode Job(YamlMappingNode workflow, string name) => Mapping(Mapping(workflow, "jobs"), name);

    private static List<YamlMappingNode> Steps(YamlMappingNode job) =>
        Assert.IsType<YamlSequenceNode>(job.Children["steps"]).Children.Select(node => Assert.IsType<YamlMappingNode>(node)).ToList();

    private static YamlMappingNode Step(IEnumerable<YamlMappingNode> steps, string name) =>
        Assert.Single(steps, step => Scalar(step, "name") == name);

    private static string Scalar(YamlMappingNode node, string key) => Assert.IsType<YamlScalarNode>(node.Children[key]).Value!;
}
