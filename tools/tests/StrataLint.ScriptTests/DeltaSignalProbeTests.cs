using System.Text;

namespace StrataLint.Tests;

// Temporary integration diagnostic tests; ScriptTests remains excluded from CI.
public sealed class DeltaSignalProbeTests
{
    [Theory]
    [InlineData("test_exit_and_sampler_cleanup")]
    [InlineData("test_signals_cleanup_sampler_and_reach_command")]
    public void ProbeOwnsItsSamplerAndPreservesTermination(string behavior)
    {
        if (OperatingSystem.IsWindows()) return;
        var root = TestRepositoryLayout.FindRoot();
        var result = TestProcessRunner.Run("python3",
            [Path.Combine(root, "tools/tests/StrataLint.ScriptTests/Fixtures/delta_signal_probe.py"), "ProbeTests." + behavior],
            root, TestBudgets.WorkflowProcessHangGuard, 1024 * 1024);
        Assert.True(result.ExitCode == 0,
            Encoding.UTF8.GetString(result.StandardOutput) + Encoding.UTF8.GetString(result.StandardError));
    }
}
