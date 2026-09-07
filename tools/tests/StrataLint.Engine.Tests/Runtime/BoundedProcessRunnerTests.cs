namespace StrataLint.Engine.Tests;

public sealed class BoundedProcessRunnerTests
{
    [Theory]
    [InlineData(false, 16)]
    [InlineData(false, 17)]
    [InlineData(true, 16)]
    [InlineData(true, 17)]
    public void BufferedStdoutAndStreamingStderrKeepTheirBounds(bool stderr, int bytes)
    {
        if (OperatingSystem.IsWindows()) return;
        void RunAndAssert()
        {
            var count = bytes.ToString(System.Globalization.CultureInfo.InvariantCulture);
            if (stderr)
            {
                var result = BoundedProcessRunner.RunStreaming(
                    "/bin/sh", ["-c", "head -c \"$1\" /dev/zero >&2", "stderr-probe", count],
                    Path.GetTempPath(), BoundedProcessRunner.HangDetectionBudget, 16,
                    async (stream, cancellation) =>
                    {
                        using var reader = new StreamReader(stream);
                        return await reader.ReadToEndAsync(cancellation);
                    });
                Assert.Equal(0, result.ExitCode);
                Assert.Empty(result.StandardOutput);
                Assert.Equal(bytes, result.StandardError.Length);
            }
            else
            {
                var result = BoundedProcessRunner.Run(
                    "/usr/bin/head", ["-c", count, "/dev/zero"], Path.GetTempPath(),
                    BoundedProcessRunner.HangDetectionBudget, 16);
                Assert.Equal(0, result.ExitCode);
                Assert.Equal(bytes, result.StandardOutput.Length);
            }
        }
        if (bytes <= 16) RunAndAssert();
        else Assert.Contains("process output exceeded 16 bytes",
            Assert.Throws<InvalidOperationException>(RunAndAssert).Message, StringComparison.Ordinal);
    }

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
