using System.Text;
using StrataLint.Cli;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed partial class CleanLanesCommandTests
{
    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void LargeProcessSnapshotPreservesFinalOccupancyCheck(bool busy)
    {
        using var fixture = new CleanLanesFixture();
        const string branch = "harness/large-process-snapshot";
        var lane = fixture.AddLandedLane(branch);
        var runner = new StreamingLsofRunner(fixture.CreateRunner((fileName, _, _) =>
            fileName == "gh" ? SuccessfulPrOutput(branch, fixture.Head(lane)) : null), lane, busy);

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

    private sealed class StreamingLsofRunner(IWorktreeProcessRunner inner, string lane, bool busy)
        : IWorktreeProcessRunner
    {
        internal int StreamedSnapshots { get; private set; }

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
            using var stream = new RepeatedDescriptorStream(busy ? lane : null);
            return new StreamedProcessOutput<T>(0,
                readStandardOutput(stream, CancellationToken.None).GetAwaiter().GetResult(), []);
        }
    }

    private sealed class RepeatedDescriptorStream(string? busyPath) : Stream
    {
        private static readonly byte[] Header = Encoding.UTF8.GetBytes("p123\0\n");
        private static readonly byte[] Record = Encoding.UTF8.GetBytes("f1\0tREG\0n/tmp/outside-lane-\u00e9\0\n");
        private const int PreviousSnapshotLimit = 64 * 1024 * 1024;
        private static readonly long RepeatedLength = (PreviousSnapshotLimit / Record.Length + 1L) * Record.Length;
        private readonly byte[] tail = busyPath is null ? [] : Encoding.UTF8.GetBytes($"f2\0tDIR\0n{busyPath}\0\n");
        private long offset;

        public override bool CanRead => true;
        public override bool CanSeek => false;
        public override bool CanWrite => false;
        public override long Length => Header.Length + RepeatedLength + tail.Length;
        public override long Position { get => offset; set => throw new NotSupportedException(); }

        public override int Read(byte[] buffer, int start, int count)
        {
            var read = (int)Math.Min(count, Length - offset);
            for (var index = 0; index < read; index++, offset++)
            {
                buffer[start + index] = offset < Header.Length ? Header[offset]
                    : offset < Header.Length + RepeatedLength ? Record[(offset - Header.Length) % Record.Length]
                    : tail[offset - Header.Length - RepeatedLength];
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
