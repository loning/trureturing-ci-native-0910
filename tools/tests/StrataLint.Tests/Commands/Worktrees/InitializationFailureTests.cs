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
    [InlineData("add-prepared")]
    [InlineData("checkout-timeout")]
    [InlineData("checkout-nonzero")]
    [InlineData("checkout-index-lock")]
    public void InterruptedInitializationRemovesOwnedStateAndAllowsSameNameRetry(string failure)
    {
        if (failure == "add-prepared" && OperatingSystem.IsWindows()) return;
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
        var inventory = WorktreeHookFixture.RunGit(repository.Path, "worktree", "list", "--porcelain");
        Assert.DoesNotContain($"worktree {LeanCacheGuard.PhysicalPath(target)}\n", inventory, StringComparison.Ordinal);
        Assert.DoesNotContain($"branch refs/heads/{branch}\n", inventory, StringComparison.Ordinal);
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
    public void PartialRegistrationWithAnotherInitializersTokenIsPreserved()
    {
        if (OperatingSystem.IsWindows()) return;
        using var repository = new TemporaryDirectory();
        InitializeRepository(repository.Path);
        var target = Path.Combine(repository.Path, "interrupted-init");
        var runner = new InitializationFailureRunner(target, "foreign-prepared");

        var result = WorktreeCommand.Run(repository.Path, InitializationArguments(target), runner);

        Assert.False(result.Success);
        Assert.Contains("simulated concurrent creator", result.Error, StringComparison.Ordinal);
        WorktreeFixtureFile.AssertContent(Path.Combine(target, "keep.txt"), "concurrent work\n");
        WorktreeFixtureFile.AssertContent(Path.Combine(WorktreeMetadataPath(repository.Path, target), "locked"),
            InitializationFailureRunner.ForeignLock + "\n");
        Assert.Contains($"worktree {LeanCacheGuard.PhysicalPath(target)}\n",
            WorktreeHookFixture.RunGit(repository.Path, "worktree", "list", "--porcelain"), StringComparison.Ordinal);
        Assert.Equal(0, GitExit(repository.Path, "show-ref", "--verify", "--quiet",
            $"refs/heads/{WorktreeCommand.CreationNamespace}/math/interrupted-init"));
        Assert.DoesNotContain(runner.Inner.Invocations, call => call.FileName == "git"
            && (call.Arguments.Take(2).SequenceEqual(["worktree", "remove"])
                || call.Arguments.Take(2).SequenceEqual(["branch", "-D"])));
    }

    [Theory]
    [InlineData("gitdir")]
    [InlineData("commondir")]
    public void InitializationTokenWithForeignMetadataLinksDoesNotAuthorizeCleanup(string link)
    {
        using var repository = new TemporaryDirectory();
        using var foreign = new TemporaryDirectory();
        InitializeRepository(repository.Path);
        InitializeRepository(foreign.Path);
        var target = Path.Combine(repository.Path, "interrupted-init");
        var runner = new InitializationFailureRunner(target, $"add-invalid-{link}", Path.Combine(foreign.Path, ".git"));

        var result = WorktreeCommand.Run(repository.Path, InitializationArguments(target), runner);

        Assert.False(result.Success);
        using var receipt = JsonDocument.Parse(result.Error["WORKTREE_FAILED ".Length..]);
        Assert.Contains("simulated initialization", receipt.RootElement.GetProperty("reason").GetString(), StringComparison.Ordinal);
        Assert.Contains("could not validate initialization metadata ownership",
            receipt.RootElement.GetProperty("cleanup_error").GetString(), StringComparison.Ordinal);
        Assert.True(Directory.Exists(target));
        Assert.True(Directory.Exists(WorktreeMetadataPath(repository.Path, target)));
        Assert.Equal(0, GitExit(repository.Path, "show-ref", "--verify", "--quiet",
            $"refs/heads/{WorktreeCommand.CreationNamespace}/math/interrupted-init"));
        WorktreeFixtureFile.AssertContent(Path.Combine(foreign.Path, "README.md"), "# worktree fixture\n");
        WorktreeFixtureFile.AssertContent(Path.Combine(foreign.Path, ".git", "HEAD"), "ref: refs/heads/dev\n");
    }

    [Theory]
    [InlineData("cleanup-timeout", "simulated cleanup timeout")]
    [InlineData("cleanup-ownership-changed", "initialization ownership changed")]
    public void InitializationFailureReportsCleanupExceptionWithoutMaskingOriginalError(string failure, string cleanupError)
    {
        using var repository = new TemporaryDirectory();
        InitializeRepository(repository.Path);
        var target = Path.Combine(repository.Path, "interrupted-init");
        var runner = new InitializationFailureRunner(target, failure);

        var result = WorktreeCommand.Run(repository.Path, InitializationArguments(target), runner);

        Assert.False(result.Success);
        using var receipt = JsonDocument.Parse(result.Error["WORKTREE_FAILED ".Length..]);
        Assert.Contains("simulated initialization", receipt.RootElement.GetProperty("reason").GetString(), StringComparison.Ordinal);
        Assert.Contains(cleanupError, receipt.RootElement.GetProperty("cleanup_error").GetString(), StringComparison.Ordinal);
        Assert.True(Directory.Exists(target));
        Assert.Equal(0, GitExit(repository.Path, "show-ref", "--verify", "--quiet",
            $"refs/heads/{WorktreeCommand.CreationNamespace}/math/interrupted-init"));
        if (failure == "cleanup-ownership-changed")
            WorktreeFixtureFile.AssertContent(Path.Combine(WorktreeMetadataPath(repository.Path, target), "locked"),
                InitializationFailureRunner.ForeignLock + "\n");
    }

    [Theory]
    [InlineData("sha1", 40, false)]
    [InlineData("sha256", 64, false)]
    [InlineData("sha1", 40, true)]
    [InlineData("sha256", 64, true)]
    public void InitializationRunsPostCheckoutOnceWithCreationArgumentsAndRollsBackHookFailure(
        string objectFormat, int oidLength, bool failHook)
    {
        using var repository = new TemporaryDirectory();
        WorktreeHookFixture.RunGit(repository.Path, "init", "--initial-branch=dev", $"--object-format={objectFormat}");
        InitializeRepository(repository.Path);
        var target = Path.Combine(repository.Path, "interrupted-init");
        var branch = $"{WorktreeCommand.CreationNamespace}/math/interrupted-init";
        var head = WorktreeHookFixture.RunGit(repository.Path, "rev-parse", "HEAD").Trim();
        var hook = WorktreeHookFixture.Install(repository.Path, "post-checkout", """
            common=$(git rev-parse --git-common-dir)
            printf '%s %s %s\n' "$1" "$2" "$3" >> "$common/post-checkout.log"
            test -f README.md || exit 97
            test -f "$(git rev-parse --git-path locked)" || exit 98
            """ + (failHook ? "\necho 'simulated initialization hook failure' >&2\nexit 1\n" : "\n"));
        WorktreeHookFixture.Install(repository.Path, "reference-transaction", """
            common=$(git rev-parse --git-common-dir)
            printf '%s\n' "$1" >> "$common/reference-transaction.log"
            """ + "\n");

        var result = WorktreeCommand.Run(repository.Path, InitializationArguments(target));

        Assert.Equal(oidLength, head.Length);
        WorktreeFixtureFile.AssertContent(Path.Combine(repository.Path, ".git", "post-checkout.log"),
            $"{new string('0', oidLength)} {head} 1\n");
        Assert.True(File.Exists(Path.Combine(repository.Path, ".git", "reference-transaction.log")));
        if (failHook)
        {
            Assert.False(result.Success);
            Assert.Contains("simulated initialization hook failure", result.Error, StringComparison.Ordinal);
            using var receipt = JsonDocument.Parse(result.Error["WORKTREE_FAILED ".Length..]);
            Assert.Equal(JsonValueKind.Null, receipt.RootElement.GetProperty("cleanup_error").ValueKind);
            Assert.False(Directory.Exists(target));
            Assert.False(Directory.Exists(WorktreeMetadataPath(repository.Path, target)));
            Assert.Equal(1, GitExit(repository.Path, "show-ref", "--verify", "--quiet", $"refs/heads/{branch}"));
            File.Delete(hook);
            result = WorktreeCommand.Run(repository.Path, InitializationArguments(target));
        }
        Assert.True(result.Success, result.Error);
        AssertRegisteredAndUsable(repository.Path, target, branch);
        Assert.False(File.Exists(Path.Combine(WorktreeMetadataPath(repository.Path, target), "locked")));
    }

    private static string[] InitializationArguments(string target) =>
    [
        "--kind", "math", "--name", "interrupted-init",
        "--path", target, "--base", "HEAD", "--skip-restore",
    ];

    private sealed class InitializationFailureRunner(string target, string failure, string? foreignPath = null) : IWorktreeProcessRunner
    {
        internal const string ForeignLock = "worktree-init:ffffffffffffffffffffffffffffffff";
        internal RecordingWorktreeProcessRunner Inner { get; } = new();
        internal bool CheckoutSawLock { get; private set; }
        internal bool CheckoutSawTrackedContent { get; private set; }

        public ProcessOutput Run(string fileName, IReadOnlyList<string> arguments, string workingDirectory, TimeSpan timeout)
        {
            var add = fileName == "git" && arguments.Take(2).SequenceEqual(["worktree", "add"]);
            var checkout = fileName == "git" && arguments.FirstOrDefault() is "checkout" or "reset";
            if (add && failure.EndsWith("prepared", StringComparison.Ordinal))
            {
                var partialArguments = arguments.ToList();
                var reasonIndex = partialArguments.IndexOf("--reason");
                if (failure == "foreign-prepared") partialArguments[reasonIndex + 1] = ForeignLock;
                var hook = WorktreeHookFixture.Install(workingDirectory, "reference-transaction", """
                    common=$(git rev-parse --git-common-dir)
                    if [ "$1" = prepared ] && [ -f "$common/worktrees/interrupted-init/commondir" ]; then
                        kill -KILL "$PPID"
                    fi
                    """ + "\n");
                try
                {
                    var partial = Inner.Run(fileName, partialArguments, workingDirectory, timeout);
                    Assert.NotEqual(0, partial.ExitCode);
                }
                finally
                {
                    File.Delete(hook);
                }
                var metadata = WorktreeMetadataPath(workingDirectory, target);
                Assert.False(File.Exists(Path.Combine(metadata, "HEAD")));
                var inventory = WorktreeHookFixture.RunGit(workingDirectory, "worktree", "list", "--porcelain", "-z");
                var fields = Assert.Single(inventory.Split("\0\0", StringSplitOptions.RemoveEmptyEntries)
                    .Select(record => record.Split('\0')),
                    record => record.Contains($"worktree {LeanCacheGuard.PhysicalPath(target)}", StringComparer.Ordinal));
                Assert.Contains($"locked {partialArguments[reasonIndex + 1]}", fields);
                Assert.DoesNotContain(fields, field => field.StartsWith("branch ", StringComparison.Ordinal));
                File.WriteAllText(Path.Combine(target, "keep.txt"), "concurrent work\n");
                throw new TimeoutException(failure == "foreign-prepared"
                    ? "simulated concurrent creator" : "simulated initialization timeout");
            }
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
            if (fileName == "git" && arguments.Take(2).SequenceEqual(["worktree", "remove"])
                && failure == "cleanup-ownership-changed")
            {
                File.WriteAllText(Path.Combine(GitWorktreeDirectory.Read(target)!, "locked"), ForeignLock + "\n");
                return new ProcessOutput(1, [], Encoding.UTF8.GetBytes("simulated git removal failure"));
            }

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
            if (add && result.ExitCode == 0 && failure.StartsWith("add-invalid-", StringComparison.Ordinal))
                File.WriteAllText(Path.Combine(GitWorktreeDirectory.Read(target)!, failure["add-invalid-".Length..]),
                    foreignPath + "\n");
            if (add && result.ExitCode == 0
                && (failure.StartsWith("add-", StringComparison.Ordinal) || failure.StartsWith("cleanup-", StringComparison.Ordinal)))
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
