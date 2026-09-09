using System.Diagnostics;
using StrataLint.TestSupport;
using Xunit;

namespace StrataLint.EngineeringScope.Tests;

public sealed class PreflightProcessContractTests
{
    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("configured")]
    public void PrCandidateRetainsSourceDonorInventoryAndExplicitSettings(string? donors)
    {
        using var fixture = new Fixture(File.ReadAllText(
            Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/preflight.sh")));
        fixture.Write(".gitignore", ".lake/\nbuild/\n");
        fixture.Write("tools/scripts/ci-stage.sh", """
            #!/bin/bash
            set -euo pipefail
            printf '%s\n' "$1" >> "$CONTRACT_CALLS"
            if [[ "$1" == engineering ]]; then
              git worktree list --porcelain -z > "$CONTRACT_INVENTORY"
              printf 'DONORS_SET=%s\nDONORS_VALUE=%s\n' "${STRATALINT_LEAN_CACHE_DONORS+x}" "${STRATALINT_LEAN_CACHE_DONORS-}"
            fi
            """);
        fixture.Commit();
        var donor = fixture.AddDonor();
        fixture.Write(".lake/marker", "source cache untouched");
        TemporaryFileSystem.Directory.CreateDirectory(Path.Combine(donor, ".lake"));
        TemporaryFileSystem.File.WriteAllText(Path.Combine(donor, ".lake/marker"), "donor cache untouched");
        var head = fixture.Git("rev-parse", "HEAD").Trim();
        var tree = fixture.Git("write-tree");
        var inventory = fixture.Git("worktree", "list", "--porcelain", "-z");
        var explicitDonors = donors == "configured" ? donor : donors;

        var result = fixture.Preflight("pr", head, donors: explicitDonors);

        Assert.True(result.Exit == 0, result.Text);
        Assert.Equal(new[] { "engineering", "current", "delta" }, fixture.Calls());
        Assert.Contains($"DONORS_SET={(explicitDonors is null ? "" : "x")}\nDONORS_VALUE={explicitDonors}\n",
            result.Text, StringComparison.Ordinal);
        AssertCandidateRemoved(result.Text);
        Assert.Equal(inventory, fixture.Git("worktree", "list", "--porcelain", "-z"));
        Assert.Equal(head, fixture.Git("rev-parse", "HEAD").Trim());
        Assert.Equal(tree, fixture.Git("write-tree"));
        Assert.Empty(fixture.Git("status", "--porcelain"));
        Assert.Equal("source cache untouched", TemporaryFileSystem.File.ReadAllText(Path.Combine(fixture.Root, ".lake/marker")));
        Assert.Equal("donor cache untouched", TemporaryFileSystem.File.ReadAllText(Path.Combine(donor, ".lake/marker")));
        var originalRoots = WorktreeRoots(inventory);
        var candidateRoots = WorktreeRoots(fixture.CandidateInventory());
        Assert.All(originalRoots, root => Assert.True(candidateRoots.Contains(root, StringComparer.Ordinal),
            $"Source donor root missing: {root}\nCandidate inventory:\n{string.Join("\n", candidateRoots)}"));
        Assert.Equal(originalRoots.Length + 1, candidateRoots.Length);
    }

    [Fact]
    public void FailedCurrentDiagnosticsSurvivePrCandidateCleanupWithoutSuccessfulEvidence()
    {
        using var fixture = new Fixture(File.ReadAllText(
            Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/preflight.sh")));
        fixture.Write(".gitignore", "build/\n");
        fixture.Write("tools/scripts/ci-stage.sh", """
            #!/bin/bash
            mkdir -p build/ci
            printf 'build/ci\0' > build/ci/artifact-paths.nul
            if [[ "$1" == current ]]; then
              mkdir -p build/ci/logs/current/lean-inspector
              printf 'raw cold build output\n' > build/ci/logs/current/lean-inspector/build.stdout.log
              printf '{"stage":"current","exit":2}\n' > build/ci/current-result.json
              exit 124
            fi
            """);
        fixture.Commit();
        var result = fixture.Preflight("pr", fixture.Git("rev-parse", "HEAD").Trim());
        Assert.Equal(2, result.Exit);
        var lines = result.Text.Split('\n');
        var candidate = lines.Single(line => line.StartsWith("PREFLIGHT_CANDIDATE path=", StringComparison.Ordinal))["PREFLIGHT_CANDIDATE path=".Length..];
        Assert.False(TemporaryFileSystem.Directory.Exists(candidate));
        var archive = lines.Single(line => line.StartsWith("PREFLIGHT_ARTIFACT bundle=", StringComparison.Ordinal))["PREFLIGHT_ARTIFACT bundle=".Length..];
        using var gzip = new System.IO.Compression.GZipStream(File.OpenRead(archive), System.IO.Compression.CompressionMode.Decompress);
        using var tar = new System.Formats.Tar.TarReader(gzip);
        var entries = new Dictionary<string, string>();
        while (tar.GetNextEntry() is { } entry)
            if (entry.DataStream is { } data)
                entries.Add(entry.Name, new StreamReader(data).ReadToEnd());
        Assert.Equal("raw cold build output\n", entries["build/ci/logs/current/lean-inspector/build.stdout.log"]);
        Assert.DoesNotContain("build/ci/current.json", entries.Keys);
        Assert.DoesNotContain(CommonExecutionEvidence.ReportPath, entries.Keys);
    }

    [Fact]
    public void DefaultPushRunsCommonStagesOnceWithoutParentOrRemote()
    {
        using var fixture = new Fixture(File.ReadAllText(
            Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/preflight.sh")));
        var result = fixture.Preflight("push", "");
        Assert.Equal(0, result.Exit);
        Assert.Equal(new[] { "engineering", "current" }, fixture.Calls());
    }

    [Fact]
    public void DivergentPrChecksSynthesizedTreeAndCleansCandidate()
    {
        using var fixture = new Fixture(File.ReadAllText(
            Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/preflight.sh")));
        var fork = fixture.Git("rev-parse", "HEAD").Trim();
        fixture.Write("base-only", "base data");
        fixture.Commit();
        var basis = fixture.Git("rev-parse", "HEAD").Trim();
        fixture.Git("checkout", "--detach", fork);
        fixture.Write("head-only", "candidate data");
        fixture.Commit();
        var inventory = fixture.Git("worktree", "list", "--porcelain", "-z");
        var result = fixture.Preflight("pr", basis);
        Assert.True(result.Exit == 0, result.Text);
        Assert.Equal(new[] { "engineering", "current", "delta" }, fixture.Calls());
        Assert.Contains("merged=yes", result.Text, StringComparison.Ordinal);
        Assert.False(TemporaryFileSystem.File.Exists(Path.Combine(fixture.Root, "base-only")));
        Assert.Empty(fixture.Git("status", "--porcelain"));
        AssertCandidateRemoved(result.Text);
        Assert.Equal(inventory, fixture.Git("worktree", "list", "--porcelain", "-z"));
    }

    [Theory]
    [InlineData("", false)]
    [InlineData("dev", false)]
    [InlineData("0000000000000000000000000000000000000000", false)]
    [InlineData("HEAD", true)]
    public void InvalidBaseOrUntrackedInputRejectsBeforeStages(string basis, bool dirty)
    {
        using var fixture = new Fixture(File.ReadAllText(
            Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/preflight.sh")));
        if (basis == "HEAD") basis = fixture.Git("rev-parse", "HEAD").Trim();
        if (dirty) fixture.Write("untracked", "dirty");
        Assert.Equal(2, fixture.Preflight("pr", basis).Exit);
        Assert.Empty(fixture.Calls());
    }

    [Theory]
    [InlineData(1)]
    [InlineData(128)]
    public void FailedCleanlinessObservationRejectsBeforeMergeAndStages(int statusExit)
    {
        using var fixture = new Fixture(File.ReadAllText(
            Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/preflight.sh")));
        var basis = fixture.Git("rev-parse", "HEAD").Trim();
        fixture.FailGit("status", statusExit);
        var result = fixture.Preflight("pr", basis);
        Assert.True(result.Exit == 2,
            $"{result.Text}\nGit calls: {string.Join(",", fixture.GitCalls())}; stages: {string.Join(",", fixture.Calls())}");
        Assert.Contains("status observation failed", result.Error, StringComparison.Ordinal);
        Assert.Contains("PREFLIGHT_RESULT mode=pr stage=input exit=2 raw_exit=2 reason=status-observation-failed",
            result.Text, StringComparison.Ordinal);
        Assert.Equal(new[] { "status" }, fixture.GitCalls());
        Assert.Empty(fixture.Calls());
    }

    [Fact]
    public void FailedCandidatePopulationUnregistersWorktreeBeforeAnyStage()
    {
        using var fixture = new Fixture(File.ReadAllText(
            Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/preflight.sh")));
        var basis = fixture.Git("rev-parse", "HEAD").Trim();
        var inventory = fixture.Git("worktree", "list", "--porcelain", "-z");
        fixture.FailGit("read-tree", 128);

        var result = fixture.Preflight("pr", basis);

        Assert.Equal(2, result.Exit);
        Assert.Contains("read-tree observation failed", result.Error, StringComparison.Ordinal);
        Assert.Contains("stage=merge-tree exit=2 raw_exit=128", result.Text, StringComparison.Ordinal);
        Assert.Equal(new[] { "status", "merge-tree", "read-tree" }, fixture.GitCalls());
        Assert.Empty(fixture.Calls());
        Assert.Empty(fixture.TemporaryCandidates());
        Assert.Equal(inventory, fixture.Git("worktree", "list", "--porcelain", "-z"));
        Assert.Empty(fixture.Git("status", "--porcelain"));
    }

    [Theory]
    [InlineData("engineering", "1", 1, 1)]
    [InlineData("current", "19", 2, 2)]
    [InlineData("delta", "3", 2, 3)]
    [InlineData("current", "HUP", 2, 2)]
    [InlineData("current", "INT", 2, 2)]
    [InlineData("current", "TERM", 2, 2)]
    public void PrFailureOrSignalUnregistersDirtyCandidate(string failedStage, string action, int expectedExit, int stageCount)
    {
        using var fixture = new Fixture(File.ReadAllText(
            Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/preflight.sh")));
        fixture.Write("tools/scripts/ci-stage.sh", $$"""
            #!/bin/bash
            set -euo pipefail
            printf '%s\n' "$1" >> "$CONTRACT_CALLS"
            mkdir -p .lake
            printf 'candidate output\n' > .lake/marker
            if [[ "$1" == {{failedStage}} ]]; then
              case "$CONTRACT_EXIT" in
                HUP|INT|TERM) kill -s "$CONTRACT_EXIT" "$PPID" ;;
                *) exit "$CONTRACT_EXIT" ;;
              esac
            fi
            """);
        fixture.Commit();
        var head = fixture.Git("rev-parse", "HEAD").Trim();
        var inventory = fixture.Git("worktree", "list", "--porcelain", "-z");

        var result = fixture.Preflight("pr", head, action);

        Assert.True(result.Exit == expectedExit, result.Text);
        Assert.Equal(new[] { "engineering", "current", "delta" }.Take(stageCount), fixture.Calls());
        var signal = action is "HUP" or "INT" or "TERM";
        Assert.Contains($"stage={failedStage} exit={expectedExit} raw_exit={(signal ? "2" : action)}",
            result.Text, StringComparison.Ordinal);
        if (signal) Assert.Contains("reason=interrupted", result.Text, StringComparison.Ordinal);
        AssertCandidateRemoved(result.Text);
        Assert.Equal(inventory, fixture.Git("worktree", "list", "--porcelain", "-z"));
        Assert.Equal(head, fixture.Git("rev-parse", "HEAD").Trim());
        Assert.Empty(fixture.Git("status", "--porcelain"));
        Assert.False(TemporaryFileSystem.Directory.Exists(Path.Combine(fixture.Root, ".lake")));
    }

    [Fact]
    public void ConflictStopsBeforeExecutingCandidate()
    {
        using var fixture = new Fixture(File.ReadAllText(
            Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/preflight.sh")));
        fixture.Write("conflict", "original"); fixture.Commit();
        var fork = fixture.Git("rev-parse", "HEAD").Trim();
        fixture.Write("conflict", "base"); fixture.Commit();
        var basis = fixture.Git("rev-parse", "HEAD").Trim();
        fixture.Git("checkout", "--detach", fork);
        fixture.Write("conflict", "head"); fixture.Commit();
        var result = fixture.Preflight("pr", basis);
        Assert.Equal(1, result.Exit);
        Assert.Empty(fixture.Calls());
    }

    [Theory]
    [InlineData("1", 1)]
    [InlineData("19", 2)]
    [InlineData("3", 2)]
    public void CommonFailureStopsLaterStagesAndNormalizesExit(string raw, int expected)
    {
        using var fixture = new Fixture(File.ReadAllText(
            Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/preflight.sh")));
        Assert.Equal(expected, fixture.Preflight("push", "", raw).Exit);
        Assert.Equal(new[] { "engineering" }, fixture.Calls());
    }

    private static string[] WorktreeRoots(string inventory) => inventory.Split('\0')
        .Where(field => field.StartsWith("worktree ", StringComparison.Ordinal))
        .Select(field => field["worktree ".Length..]).ToArray();

    private static void AssertCandidateRemoved(string output)
    {
        var candidate = output.Split('\n').Single(line => line.StartsWith("PREFLIGHT_CANDIDATE path=", StringComparison.Ordinal))
            ["PREFLIGHT_CANDIDATE path=".Length..];
        Assert.False(TemporaryFileSystem.Directory.Exists(candidate));
        Assert.False(TemporaryFileSystem.Directory.Exists(Path.GetDirectoryName(candidate)!));
    }

    private sealed class Fixture : IDisposable
    {
        private readonly string scratch = TemporaryFileSystem.Directory.CreateTempSubdirectory("preflight-contract-").FullName;
        internal string Root => Path.Combine(scratch, "repository");
        private string CallsPath => Path.Combine(scratch, "calls");
        private string GitCallsPath => Path.Combine(scratch, "git-calls");
        private string InventoryPath => Path.Combine(scratch, "candidate-inventory");
        private string? gitBin;
        private string? realGit;
        internal Fixture(string preflightScript)
        {
            TemporaryFileSystem.Directory.CreateDirectory(Root);
            Write("tools/scripts/preflight.sh", preflightScript);
            Write("tools/scripts/ci-stage.sh", """
                #!/bin/bash
                printf '%s\n' "$1" >> "$CONTRACT_CALLS"
                if [[ -f base-only && -f head-only ]]; then printf 'merged=yes\n'; fi
                exit "${CONTRACT_EXIT:-0}"
                """);
            Git("init", "-q"); Git("config", "user.name", "Fixture"); Git("config", "user.email", "fixture@example.invalid");
            Commit();
        }
        internal void Write(string path, string text)
        {
            var full = Path.Combine(Root, path);
            TemporaryFileSystem.Directory.CreateDirectory(Path.GetDirectoryName(full)!);
            TemporaryFileSystem.File.WriteAllText(full, text);
        }
        internal void Commit() { Git("add", "."); Git("commit", "-qm", "fixture"); }
        internal string AddDonor()
        {
            var donor = Path.Combine(scratch, "warm donor");
            Git("worktree", "add", "--quiet", "--detach", donor, "HEAD");
            return donor;
        }
        internal void FailGit(string command, int exit)
        {
            realGit = Run("/bin/bash", ["-c", "command -v git"]).Text.Trim();
            gitBin = Path.Combine(scratch, "bin");
            TemporaryFileSystem.Directory.CreateDirectory(gitBin);
            var shim = Path.Combine(gitBin, "git");
            TemporaryFileSystem.File.WriteAllText(shim, $$"""
                #!/bin/bash
                command="$1"
                if [[ "$command" == -C ]]; then command="$3"; fi
                case "$command" in
                  status|merge-tree|read-tree) printf '%s\n' "$command" >> "$CONTRACT_GIT_CALLS" ;;
                esac
                if [[ "$command" == {{command}} ]]; then
                  printf '%s observation failed\n' "$command" >&2
                  exit {{exit}}
                fi
                exec "$CONTRACT_REAL_GIT" "$@"
                """);
            if (!OperatingSystem.IsWindows())
                File.SetUnixFileMode(shim, UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.UserExecute);
        }
        internal string Git(params string[] args)
        {
            var result = Run("git", args);
            Assert.True(result.Exit == 0, result.Text);
            return result.Text;
        }
        internal (int Exit, string Text, string Error) Preflight(string mode, string basis, string raw = "0", string? donors = null)
        {
            var environment = new Dictionary<string, string>
            {
                ["MODE"] = mode, ["BASE"] = basis, ["CONTRACT_CALLS"] = CallsPath, ["CONTRACT_EXIT"] = raw,
                ["CONTRACT_INVENTORY"] = InventoryPath, ["TMPDIR"] = scratch,
            };
            if (donors is not null) environment["STRATALINT_LEAN_CACHE_DONORS"] = donors;
            if (gitBin is not null)
            {
                environment["PATH"] = gitBin + Path.PathSeparator + Environment.GetEnvironmentVariable("PATH");
                environment["CONTRACT_REAL_GIT"] = realGit!;
                environment["CONTRACT_GIT_CALLS"] = GitCallsPath;
            }
            return Run("/bin/bash", ["tools/scripts/preflight.sh"], environment);
        }
        internal string[] Calls() => TemporaryFileSystem.File.Exists(CallsPath) ? TemporaryFileSystem.File.ReadAllText(CallsPath).Split('\n', StringSplitOptions.RemoveEmptyEntries) : [];
        internal string[] GitCalls() => TemporaryFileSystem.File.Exists(GitCallsPath) ? TemporaryFileSystem.File.ReadAllText(GitCallsPath).Split('\n', StringSplitOptions.RemoveEmptyEntries) : [];
        internal string CandidateInventory() => TemporaryFileSystem.File.ReadAllText(InventoryPath);
        internal string[] TemporaryCandidates() => Directory.GetDirectories(scratch, "ci-preflight.*");
        private (int Exit, string Text, string Error) Run(string executable, string[] args, Dictionary<string, string>? environment = null)
        {
            var start = new ProcessStartInfo(executable) { WorkingDirectory = Root, RedirectStandardOutput = true, RedirectStandardError = true };
            start.Environment.Remove("STRATALINT_LEAN_CACHE_DONORS");
            foreach (var arg in args) start.ArgumentList.Add(arg);
            foreach (var pair in environment ?? []) start.Environment[pair.Key] = pair.Value;
            using var process = Process.Start(start)!;
            var stdout = process.StandardOutput.ReadToEndAsync(); var stderr = process.StandardError.ReadToEndAsync();
            Assert.True(process.WaitForExit(30_000), "process exceeded fixture timeout");
            var error = stderr.GetAwaiter().GetResult();
            return (process.ExitCode, stdout.GetAwaiter().GetResult() + error, error);
        }
        public void Dispose() => TemporaryFileSystem.Directory.Delete(scratch, recursive: true);
    }
}
