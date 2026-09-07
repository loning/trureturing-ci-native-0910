namespace StrataLint.Tests;

public sealed class LeanReportInputScriptTests
{
    [Fact]
    public void ProducerClosureIncludesTheCompiledArchiveFetchEntrypoint()
    {
        if (OperatingSystem.IsWindows()) return;
        var root = TestRepositoryLayout.FindRoot();
        var result = TestProcessRunner.Run("/bin/bash",
            [Path.Combine(root, "tools/scripts/report/lean-report-input.sh"), "producer-paths", "--repository", root],
            root, TestBudgets.WorkflowProcessHangGuard, 1024 * 1024);
        Assert.Equal(0, result.ExitCode);
        var paths = System.Text.Encoding.UTF8.GetString(result.StandardOutput).Split('\n');
        Assert.Contains(Path.GetRelativePath(root, StrataLint.Cli.LeanArchiveFetch.ScriptPath(root)).Replace('\\', '/'), paths);
        Assert.Contains("tools/scripts/worktree/lean_cache_release.py", paths);
    }

    [Fact]
    public void ProducerClosureFollowsExecutableDependencies() =>
        LeanSeedProcessContract.Run("PairTests.test_input_follows_transitive_program_dependencies_without_workflow");

    [Fact]
    public void MetadataAndSemanticInputsHaveDistinctBehavior() =>
        LeanSeedProcessContract.Run("PairTests.test_metadata_keeps_attestation_but_semantic_and_source_drift_are_stale");
}
