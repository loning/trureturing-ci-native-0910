namespace StrataLint.Engine.Tests;

public sealed class BoundedProcessRunnerTests
{
    [Fact]
    public void StreamingOutputDoesNotApplyStderrLimitToStdout()
    {
        if (OperatingSystem.IsWindows()) return;

        var result = BoundedProcessRunner.RunStreaming(
            "/usr/bin/head", ["-c", "4096", "/dev/zero"], Path.GetTempPath(),
            BoundedProcessRunner.HangDetectionBudget, 16,
            async (stream, cancellation) =>
            {
                var buffer = new byte[257];
                var total = 0;
                int count;
                while ((count = await stream.ReadAsync(buffer, cancellation)) != 0) total += count;
                return total;
            });

        Assert.Equal(0, result.ExitCode);
        Assert.Equal(4096, result.StandardOutput);
        Assert.Empty(result.StandardError);
    }

    [Fact]
    public void StreamingOutputPreservesChildExitAndStderr()
    {
        if (OperatingSystem.IsWindows()) return;

        var result = BoundedProcessRunner.RunStreaming(
            "/bin/sh", ["-c", "printf out; printf err >&2; exit 7"], Path.GetTempPath(),
            BoundedProcessRunner.HangDetectionBudget, 16,
            async (stream, cancellation) =>
            {
                using var reader = new StreamReader(stream);
                return await reader.ReadToEndAsync(cancellation);
            });

        Assert.Equal(7, result.ExitCode);
        Assert.Equal("out", result.StandardOutput);
        Assert.Equal("err", System.Text.Encoding.UTF8.GetString(result.StandardError));
    }

    [Fact]
    public void ChildExitIsNotMaskedByClosedStandardInputPipe()
    {
        if (OperatingSystem.IsWindows()) return;

        var result = BoundedProcessRunner.Run(
            "/usr/bin/true",
            [],
            Path.GetTempPath(),
            TimeSpan.FromSeconds(10),
            1024,
            new byte[4 * 1024 * 1024]);

        Assert.Equal(0, result.ExitCode);
        Assert.Empty(result.StandardOutput);
        Assert.Empty(result.StandardError);
    }
}
