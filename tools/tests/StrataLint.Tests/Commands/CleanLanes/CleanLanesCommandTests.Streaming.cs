using System.Text;
using StrataLint.Cli;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed partial class CleanLanesCommandTests
{
    [Fact]
    public void ProductionStreamingAdapterAcceptsOutputBeyondTheBufferedLimit()
    {
        if (OperatingSystem.IsWindows()) return;
        IWorktreeProcessRunner runner = new ProductionWorktreeProcessRunner();
        var result = runner.RunStreaming("/usr/bin/head", ["-c", "67108865", "/dev/zero"],
            Path.GetTempPath(), BoundedProcessRunner.HangDetectionBudget,
            async (stream, cancellation) =>
            {
                var total = 0L;
                var buffer = new byte[8192];
                int count;
                while ((count = await stream.ReadAsync(buffer, cancellation)) != 0) total += count;
                return total;
            });
        Assert.Equal(0, result.ExitCode);
        Assert.Equal(67108865L, result.StandardOutput);
        Assert.Empty(result.StandardError);
    }

    [Theory]
    [InlineData("truncated")]
    [InlineData("invalid-utf8")]
    [InlineData("oversized-field")]
    public void MalformedStreamsAreDrainedAndCannotAuthorizeRemoval(string scenario)
    {
        using var fixture = new CleanLanesFixture();
        const string branch = "harness/malformed-stream";
        var lane = fixture.AddLandedLane(branch);
        var idle = IdleLsofOutput().StandardOutput;
        Func<Stream> snapshot = scenario switch
        {
            "truncated" => () => new ShortReadStream([.. idle, .. Encoding.UTF8.GetBytes("\np456")]),
            "invalid-utf8" => () => new ShortReadStream([.. idle,
                .. Encoding.UTF8.GetBytes("\nf9\0tDIR\0n"), 0xc3, 0x28, 0,
                .. Encoding.UTF8.GetBytes("\np456\0\nf1\0tDIR\0n/tmp/outside\0\n")]),
            "oversized-field" => () => new RepeatedDescriptorStream(null, oversizedField: true),
            _ => throw new InvalidOperationException(scenario),
        };
        var runner = new StreamingLsofRunner(fixture.CreateRunner((fileName, _, _) =>
            fileName == "gh" ? SuccessfulPrOutput(branch, fixture.Head(lane)) : null), snapshot);

        var result = fixture.RunWithProductionProbes(runner, "--force");

        Assert.True(result.Success, result.Error);
        Assert.Equal("in_use_unknown", ReasonFor(result.Output, lane));
        CleanLanesFixture.AssertDirectoryExists(lane, true);
        Assert.Equal(1, runner.StreamedSnapshots);
        Assert.Equal(1, runner.DrainedSnapshots);
    }

    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void LargeProcessSnapshotPreservesFinalOccupancyCheck(bool busy)
    {
        using var fixture = new CleanLanesFixture();
        const string branch = "harness/large-process-snapshot";
        var lane = fixture.AddLandedLane(branch);
        var runner = new StreamingLsofRunner(fixture.CreateRunner((fileName, _, _) =>
            fileName == "gh" ? SuccessfulPrOutput(branch, fixture.Head(lane)) : null),
            () => new RepeatedDescriptorStream(busy ? lane : null));

        var result = fixture.RunWithProductionProbes(runner, "--force");

        Assert.True(result.Success, result.Error);
        Assert.Equal(busy ? "in_use" : "merged_clean", ReasonFor(result.Output, lane));
        CleanLanesFixture.AssertDirectoryExists(lane, busy);
        Assert.Equal(busy ? 1 : 2, runner.StreamedSnapshots);
    }

    [Fact]
    public void RemovalRefreshDoesNotResolveUnrelatedWorktreeMetadataAgain()
    {
        using var fixture = new CleanLanesFixture();
        var lane = fixture.AddLandedLane("harness/metadata-refresh");
        var runner = fixture.CreateRunner();

        var result = fixture.RunWith(runner, "--force");

        Assert.True(result.Success, result.Error);
        Assert.Equal("merged_clean", ReasonFor(result.Output, lane));
        CleanLanesFixture.AssertDirectoryExists(lane, false);
        Assert.Single(runner.Invocations, call =>
            call.WorkingDirectory == lane
            && call.Arguments.SequenceEqual(["rev-parse", "--absolute-git-dir"]));
    }

    private sealed class StreamingLsofRunner(IWorktreeProcessRunner inner, Func<Stream> snapshot)
        : IWorktreeProcessRunner
    {
        internal int StreamedSnapshots { get; private set; }
        internal int DrainedSnapshots { get; private set; }

        public ProcessOutput Run(string fileName, IReadOnlyList<string> arguments, string workingDirectory, TimeSpan timeout) =>
            fileName == "lsof"
                ? throw new InvalidOperationException("aggregate process output exceeded 67108864 bytes")
                : inner.Run(fileName, arguments, workingDirectory, timeout);

        public StreamedProcessOutput<T> RunStreaming<T>(string fileName, IReadOnlyList<string> arguments,
            string workingDirectory, TimeSpan timeout, Func<Stream, CancellationToken, Task<T>> readStandardOutput)
        {
            Assert.Equal("lsof", fileName);
            Assert.Equal(new[] { "-nP", "-F0pftn" }, arguments);
            StreamedSnapshots++;
            using var stream = snapshot();
            var result = readStandardOutput(stream, CancellationToken.None).GetAwaiter().GetResult();
            if (stream.Position == stream.Length) DrainedSnapshots++;
            return new StreamedProcessOutput<T>(0, result, []);
        }
    }

    private sealed class ShortReadStream(byte[] bytes) : MemoryStream(bytes, writable: false)
    {
        public override ValueTask<int> ReadAsync(Memory<byte> buffer, CancellationToken cancellationToken = default) =>
            base.ReadAsync(buffer[..Math.Min(2, buffer.Length)], cancellationToken);
    }

    private sealed class RepeatedDescriptorStream(string? busyPath, bool oversizedField = false) : Stream
    {
        private readonly byte[] header = Encoding.UTF8.GetBytes(oversizedField ? "p123\0\nf1\0tREG\0n" : "p123\0\n");
        private readonly byte[] record = Encoding.UTF8.GetBytes(oversizedField ? "x" : "f1\0tREG\0n/tmp/outside-lane-\u00e9\0\n");
        private const int PreviousSnapshotLimit = 64 * 1024 * 1024;
        private long RepeatedLength => (PreviousSnapshotLimit / record.Length + 1L) * record.Length;
        private readonly byte[] tail = oversizedField ? Encoding.UTF8.GetBytes("\0\nf2\0tDIR\0n/tmp/outside\0\n")
            : busyPath is null ? [] : Encoding.UTF8.GetBytes($"f2\0tDIR\0n{busyPath}\0\n");
        private long offset;

        public override bool CanRead => true;
        public override bool CanSeek => false;
        public override bool CanWrite => false;
        public override long Length => header.Length + RepeatedLength + tail.Length;
        public override long Position { get => offset; set => throw new NotSupportedException(); }

        public override int Read(byte[] buffer, int start, int count)
        {
            var endOfRecords = header.Length + RepeatedLength;
            var read = (int)Math.Min(count, endOfRecords + tail.Length - offset);
            for (var index = 0; index < read; index++, offset++)
            {
                buffer[start + index] = offset < header.Length ? header[offset]
                    : offset < endOfRecords ? record[(offset - header.Length) % record.Length]
                    : tail[offset - endOfRecords];
            }
            return read;
        }

        public override ValueTask<int> ReadAsync(Memory<byte> buffer, CancellationToken cancellationToken = default)
        {
            cancellationToken.ThrowIfCancellationRequested();
            var bytes = new byte[buffer.Length];
            var read = Read(bytes, 0, bytes.Length);
            bytes.AsMemory(0, read).CopyTo(buffer);
            return ValueTask.FromResult(read);
        }

        public override void Flush() => throw new NotSupportedException();
        public override long Seek(long offset, SeekOrigin origin) => throw new NotSupportedException();
        public override void SetLength(long value) => throw new NotSupportedException();
        public override void Write(byte[] buffer, int offset, int count) => throw new NotSupportedException();
    }
}
