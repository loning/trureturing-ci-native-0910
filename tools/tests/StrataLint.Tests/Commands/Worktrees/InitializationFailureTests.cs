using System.Text;
using System.Text.Json;
using StrataLint.Cli;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed partial class WorktreeCommandTests
{
    [Theory]
    [InlineData("add-timeout")]
    [InlineData("add-nonzero")]
    [InlineData("checkout-timeout")]
    [InlineData("checkout-nonzero")]
    [InlineData("checkout-index-lock")]
    public void InterruptedInitializationRemovesOwnedStateAndAllowsSameNameRetry(string failure)
    {
        using var repository = new TemporaryDirectory();
        InitializeRepository(repository.Path);
        var target = Path.Combine(repository.Path, "interrupted-init");
        var branch = $"{WorktreeCommand.CreationNamespace}/math/interrupted-init";
        var runner = new InitializationFailureRunner(target, failure);

        var result = WorktreeCommand.Run(repository.Path, InitializationArguments(target), runner);

        Assert.False(result.Success);
        Assert.Contains("simulated initialization", result.Error, StringComparison.Ordinal);
        using var receipt = JsonDocument.Parse(result.Error["WORKTREE_FAILED ".Length..]);
        Assert.Equal(JsonValueKind.Null, receipt.RootElement.GetProperty("cleanup_error").ValueKind);
        Assert.False(Directory.Exists(target));
        Assert.False(Directory.Exists(WorktreeMetadataPath(repository.Path, target)));
        Assert.Equal(1, GitExit(repository.Path, "show-ref", "--verify", "--quiet", $"refs/heads/{branch}"));

        var retry = WorktreeCommand.Run(repository.Path, InitializationArguments(target));

        Assert.True(retry.Success, retry.Error);
        AssertRegisteredAndUsable(repository.Path, target, branch);
        WorktreeFixtureFile.AssertContent(Path.Combine(target, "README.md"), "# worktree fixture\n");
        Assert.False(File.Exists(Path.Combine(WorktreeMetadataPath(repository.Path, target), "locked")));
    }

    [Fact]
    public void InitializationKeepsOwnershipLockDuringCheckoutAndReleasesItOnSuccess()
    {
        using var repository = new TemporaryDirectory();
        InitializeRepository(repository.Path);
        var target = Path.Combine(repository.Path, "interrupted-init");
        var runner = new InitializationFailureRunner(target, "none");

        var result = WorktreeCommand.Run(repository.Path, InitializationArguments(target), runner);

        Assert.True(result.Success, result.Error);
        Assert.True(runner.CheckoutSawLock);
        Assert.False(runner.CheckoutSawTrackedContent);
        WorktreeFixtureFile.AssertContent(Path.Combine(target, "README.md"), "# worktree fixture\n");
        Assert.False(File.Exists(Path.Combine(WorktreeMetadataPath(repository.Path, target), "locked")));
    }

    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void FailedInitializationPreservesConcurrentCreatorsState(bool foreignLock)
    {
        using var repository = new TemporaryDirectory();
        InitializeRepository(repository.Path);
        var target = Path.Combine(repository.Path, "interrupted-init");
        var runner = new InitializationFailureRunner(target, foreignLock ? "foreign-locked" : "foreign-unlocked");

        var result = WorktreeCommand.Run(repository.Path, InitializationArguments(target), runner);

        Assert.False(result.Success);
        Assert.Contains("simulated concurrent creator", result.Error, StringComparison.Ordinal);
        WorktreeFixtureFile.AssertContent(Path.Combine(target, "keep.txt"), "concurrent work\n");
        if (foreignLock)
            WorktreeFixtureFile.AssertContent(Path.Combine(WorktreeMetadataPath(repository.Path, target), "locked"),
                InitializationFailureRunner.ForeignLock + "\n");
        AssertRegisteredAndUsable(repository.Path, target, $"{WorktreeCommand.CreationNamespace}/math/interrupted-init");
        Assert.DoesNotContain(runner.Inner.Invocations, call =>
            call.FileName == "git" && call.Arguments.Take(2).SequenceEqual(["worktree", "remove"]));
    }

    [Fact]
    public void InitializationFailureReportsCleanupExceptionWithoutMaskingOriginalError()
    {
        using var repository = new TemporaryDirectory();
        InitializeRepository(repository.Path);
        var target = Path.Combine(repository.Path, "interrupted-init");
        var runner = new InitializationFailureRunner(target, "cleanup-timeout");

        var result = WorktreeCommand.Run(repository.Path, InitializationArguments(target), runner);

        Assert.False(result.Success);
        using var receipt = JsonDocument.Parse(result.Error["WORKTREE_FAILED ".Length..]);
        Assert.Contains("simulated initialization", receipt.RootElement.GetProperty("reason").GetString(), StringComparison.Ordinal);
        Assert.Contains("simulated cleanup timeout", receipt.RootElement.GetProperty("cleanup_error").GetString(), StringComparison.Ordinal);
        Assert.True(Directory.Exists(target));
    }

    private static string[] InitializationArguments(string target) =>
    [
        "--kind", "math", "--name", "interrupted-init",
        "--path", target, "--base", "HEAD", "--skip-restore",
    ];

    private sealed class InitializationFailureRunner(string target, string failure) : IWorktreeProcessRunner
    {
        internal const string ForeignLock = "worktree-init:ffffffffffffffffffffffffffffffff";
        internal RecordingWorktreeProcessRunner Inner { get; } = new();
        internal bool CheckoutSawLock { get; private set; }
        internal bool CheckoutSawTrackedContent { get; private set; }

        public ProcessOutput Run(string fileName, IReadOnlyList<string> arguments, string workingDirectory, TimeSpan timeout)
        {
            var add = fileName == "git" && arguments.Take(2).SequenceEqual(["worktree", "add"]);
            var checkout = fileName == "git" && arguments.FirstOrDefault() == "checkout";
            if (add && failure.StartsWith("foreign-", StringComparison.Ordinal))
            {
                var foreignArguments = arguments.ToList();
                var reasonIndex = foreignArguments.IndexOf("--reason");
                if (reasonIndex >= 0) foreignArguments[reasonIndex + 1] = ForeignLock;
                var foreign = Inner.Run(fileName, foreignArguments, workingDirectory, timeout);
                Assert.Equal(0, foreign.ExitCode);
                var metadata = GitWorktreeDirectory.Read(target)!;
                if (failure == "foreign-unlocked" && File.Exists(Path.Combine(metadata, "locked")))
                    ReviewRegressionTests.RunGit(workingDirectory, "worktree", "unlock", target);
                if (failure == "foreign-locked" && !File.Exists(Path.Combine(metadata, "locked")))
                    ReviewRegressionTests.RunGit(workingDirectory, "worktree", "lock", "--reason", ForeignLock, target);
                File.WriteAllText(Path.Combine(target, "keep.txt"), "concurrent work\n");
                throw new TimeoutException("simulated concurrent creator");
            }

            if (fileName == "git" && arguments.Take(2).SequenceEqual(["worktree", "remove"])
                && failure == "cleanup-timeout")
                throw new TimeoutException("simulated cleanup timeout");

            if (checkout)
            {
                var metadata = GitWorktreeDirectory.Read(target)!;
                CheckoutSawLock = File.Exists(Path.Combine(metadata, "locked"));
                CheckoutSawTrackedContent = File.Exists(Path.Combine(target, "README.md"));
                if (failure.StartsWith("checkout-", StringComparison.Ordinal))
                {
                    File.WriteAllText(Path.Combine(target, "README.md"), "partial checkout\n");
                    if (failure == "checkout-index-lock") File.WriteAllText(Path.Combine(metadata, "index.lock"), string.Empty);
                    return FailInitialization(failure);
                }
            }

            var result = Inner.Run(fileName, arguments, workingDirectory, timeout);
            if (add && result.ExitCode == 0
                && (failure.StartsWith("add-", StringComparison.Ordinal) || failure == "cleanup-timeout"))
                return FailInitialization(failure);
            return result;
        }

        private static ProcessOutput FailInitialization(string failure)
        {
            if (failure.EndsWith("nonzero", StringComparison.Ordinal))
                return new ProcessOutput(1, [], Encoding.UTF8.GetBytes("simulated initialization failure"));
            throw new TimeoutException("simulated initialization timeout");
        }
    }
}
