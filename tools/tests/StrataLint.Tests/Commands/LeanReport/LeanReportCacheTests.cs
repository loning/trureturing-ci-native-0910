using System.Text;

namespace StrataLint.Tests;

public sealed class LeanReportCacheTests
{
    [Theory]
    [InlineData("test_exact_hit_always_enters_producer_and_rebinds_candidate")]
    [InlineData("test_real_producer_failure_cannot_be_masked_by_prior_report")]
    [InlineData("test_corrupt_seed_and_failed_save_do_not_override_production")]
    [InlineData("test_invalid_producer_outputs_never_replace_prior_bundle")]
    public void IncrementalSeedBehavior(string behavior) => LeanSeedProcessContract.Run("PairTests." + behavior);
}

internal static class LeanSeedProcessContract
{
    internal static void Run(string behavior, TimeSpan? hangGuard = null)
    {
        if (OperatingSystem.IsWindows()) return;
        var root = TestRepositoryLayout.FindRoot();
        var result = TestProcessRunner.Run("python3",
            [Path.Combine(root, "tools/tests/StrataLint.ScriptTests/Fixtures/lean_seed_contract.py"), behavior],
            root, hangGuard ?? TestBudgets.WorkflowProcessHangGuard, 1024 * 1024);
        Assert.True(result.ExitCode == 0,
            Encoding.UTF8.GetString(result.StandardOutput) + Encoding.UTF8.GetString(result.StandardError));
    }
}
