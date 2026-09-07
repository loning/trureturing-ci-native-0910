using System.Security.Cryptography;
using System.Text;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed partial class LeanReportInputScriptTests
{
    [Theory]
    [InlineData("producer-paths")]
    [InlineData("scribe-producer-paths")]
    public void CacheFetcherClosureIncludesTransitiveInputsAndRejectsMissingInputs(string command)
    {
        using var fixture = new LeanReportInputFixture();
        const string dependency = "tools/scripts/worktree/fetch-input.sh";
        fixture.WriteSource(dependency, "#!/usr/bin/env bash\n");
        fixture.Append(CachePublishScriptPath, "\nsource \"$SCRIPT_DIR/fetch-input.sh\"\n");

        var complete = fixture.RunCommand(command);

        Assert.Equal(0, complete.ExitCode);
        Assert.Contains(CachePublishScriptPath, Lines(complete));
        Assert.Contains(dependency, Lines(complete));
        fixture.RemoveSource(dependency);
        var missingDependency = fixture.RunCommand(command);
        Assert.Equal(2, missingDependency.ExitCode);
        Assert.Empty(missingDependency.StandardOutput);
        Assert.Contains(dependency, Encoding.UTF8.GetString(missingDependency.StandardError));
        fixture.RemoveSource(CachePublishScriptPath);
        var missingFetcher = fixture.RunCommand(command);
        Assert.Equal(2, missingFetcher.ExitCode);
        Assert.Empty(missingFetcher.StandardOutput);
        Assert.Contains(CachePublishScriptPath, Encoding.UTF8.GetString(missingFetcher.StandardError));
    }

    [Fact]
    public void CacheFetcherBytesChangeProducerWithoutChangingLeanInputs()
    {
        using var fixture = new LeanReportInputFixture();
        var before = fixture.RunCommand("address");
        Assert.Equal(0, before.ExitCode);

        fixture.Append(CachePublishScriptPath, "# fetch acceptance changed\n");
        var after = fixture.RunCommand("address");

        Assert.Equal(0, after.ExitCode);
        Assert.NotEqual(Fields(before)[0], Fields(after)[0]);
        Assert.NotEqual(Fields(before)[1], Fields(after)[1]);
        Assert.Equal(Fields(before)[2..], Fields(after)[2..]);
    }

    [Theory]
    [InlineData(0)]
    [InlineData(29)]
    public void CacheFetcherDeltaSelectsScribeChecksAndPropagatesFailure(int childExit)
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportInputFixture();

        var (result, invocations) = fixture.RunScribeForFetcherDelta(childExit);

        Assert.Equal(childExit, result.ExitCode);
        Assert.Equal(
            childExit == 0 ? new[] { "projections", "describe-report" } : ["projections"],
            invocations);
    }

    [Fact]
    public void AddressIsIndependentOfCallerWorkingDirectorySdk()
    {
        using var fixture = new LeanReportInputFixture();
        var fromRepository = fixture.AddressFromRepository();

        var fromForeignSdk = fixture.AddressFromForeignSdkDirectory();

        Assert.Equal(0, fromRepository.ExitCode);
        Assert.Equal(fromRepository.ExitCode, fromForeignSdk.ExitCode);
        Assert.Equal(fromRepository.StandardOutput, fromForeignSdk.StandardOutput);
    }

    [Theory]
    [InlineData("msbuild")]
    [InlineData("sdk")]
    public void AddressFailurePreservesProjectAndRawDiagnostic(string failure)
    {
        using var fixture = new LeanReportInputFixture();
        if (failure == "msbuild") fixture.BreakProducerClosureEvaluation();
        else fixture.UseUnavailableRepositorySdk();
        var raw = fixture.EvaluateCliProject();
        Assert.NotEqual(0, raw.ExitCode);
        Assert.NotEmpty(raw.StandardOutput.Concat(raw.StandardError));

        var result = fixture.AddressFromRepository();

        Assert.Equal(2, result.ExitCode);
        Assert.Empty(result.StandardOutput);
        var diagnostic = Encoding.UTF8.GetString(result.StandardError);
        Assert.Contains(fixture.CliProject, diagnostic, StringComparison.Ordinal);
        foreach (var stream in new[] { raw.StandardOutput, raw.StandardError })
        {
            if (stream.Length > 0)
                Assert.Contains(Encoding.UTF8.GetString(stream), diagnostic, StringComparison.Ordinal);
        }
    }

    [Fact]
    public void AddressFromRepositoryMatchesIndependentPrechangeBytes()
    {
        using var fixture = new LeanReportInputFixture();

        var result = fixture.AddressFromRepository();

        Assert.Equal(0, result.ExitCode);
        var expected = fixture.ExpectedAddressBytes();
        if (!expected.SequenceEqual(result.StandardOutput))
            Assert.Fail($"Expected: {Encoding.UTF8.GetString(expected)}"
                + $"Actual: {Encoding.UTF8.GetString(result.StandardOutput)}"
                + $"Inputs: {Encoding.UTF8.GetString(fixture.RunCommand("producer-paths").StandardOutput)}");
        Assert.Empty(result.StandardError);
    }

    private sealed partial class LeanReportInputFixture
    {
        private const string UnavailableSdk =
            "{\"sdk\":{\"version\":\"99.0.100\",\"rollForward\":\"disable\"}}\n";

        internal string CliProject
        {
            get
            {
                var physicalPath = TestProcessRunner.Run(
                    "pwd", ["-P"], repository,
                    BoundedProcessRunner.HangDetectionBudget, 1024 * 1024);
                Assert.Equal(0, physicalPath.ExitCode);
                return Path.Combine(
                    Encoding.UTF8.GetString(physicalPath.StandardOutput).TrimEnd('\r', '\n'),
                    CliProjectPath);
            }
        }

        internal ProcessOutput AddressFromRepository() => Run("address", repository);

        internal void RemoveSource(string relativePath) => File.Delete(Path.Combine(repository, relativePath));

        [System.Runtime.Versioning.UnsupportedOSPlatform("windows")]
        internal (ProcessOutput Result, string[] Invocations) RunScribeForFetcherDelta(int childExit)
        {
            foreach (var path in new[] { InputHelperPath, ScribeContentChecksPath })
            {
                Write(path, File.ReadAllText(Path.Combine(TestRepositoryLayout.FindRoot(), path)));
                File.SetUnixFileMode(Path.Combine(repository, path),
                    UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.UserExecute);
            }
            var bin = Path.Combine(temporary.Path, "bin");
            var log = Path.Combine(temporary.Path, "scribe.log");
            Directory.CreateDirectory(bin);
            var dotnet = Path.Combine(bin, "dotnet");
            File.WriteAllText(dotnet, """
                #!/bin/bash
                if [[ "$1" == scribe-fixture ]]; then
                  printf '%s\n' "$2" >> "$SCRIBE_LOG"
                  exit "$SCRIBE_EXIT"
                fi
                PATH="$ORIGINAL_PATH" exec dotnet "$@"
                """ + "\n");
            File.SetUnixFileMode(dotnet,
                UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.UserExecute);
            InitializeGitRepository();
            var baseline = ReviewRegressionTests.RunGit(repository, "rev-parse", "HEAD").Trim();
            var unchanged = RunGate();
            Assert.Equal(0, unchanged.ExitCode);
            Assert.False(File.Exists(log));

            Append(CachePublishScriptPath, "# fetch acceptance changed\n");
            var result = RunGate();
            return (result, File.Exists(log) ? File.ReadAllLines(log) : []);

            ProcessOutput RunGate() => TestProcessRunner.Run(
                "/bin/bash",
                ["-c", "ORIGINAL_PATH=\"$PATH\" PATH=\"$1:$PATH\" SCRIBE_LOG=\"$2\" "
                    + "SCRIBE_EXIT=\"$3\" STRATALINT_SCRIBE_BASE=\"$6\" "
                    + "exec /bin/bash \"$4\" \"$5\" scribe-fixture",
                    "scribe-fetcher-delta", bin, log, childExit.ToString(System.Globalization.CultureInfo.InvariantCulture),
                    Path.Combine(repository, ScribeContentChecksPath), report, baseline],
                repository, BoundedProcessRunner.HangDetectionBudget, 1024 * 1024);
        }

        internal ProcessOutput AddressFromForeignSdkDirectory()
        {
            var directory = Path.Combine(temporary.Path, "foreign sdk");
            Directory.CreateDirectory(directory);
            File.WriteAllText(Path.Combine(directory, "global.json"), UnavailableSdk);
            return Run("address", directory);
        }

        internal void UseUnavailableRepositorySdk() => Write("global.json", UnavailableSdk);

        internal ProcessOutput EvaluateCliProject() => TestProcessRunner.Run(
            "dotnet",
            ["msbuild", CliProject, "-getItem:Compile", "-verbosity:quiet", "-nologo"],
            repository,
            BoundedProcessRunner.HangDetectionBudget,
            1024 * 1024);

        internal byte[] ExpectedAddressBytes()
        {
            // The synthetic fixture's inputs are independent of the helper's output.
            string[] producerPaths =
            [
                "tools/StrataLint.Cli/Commands/FixtureProbe.cs",
                RawReportPath, CanonicalWriterPath, LeanModelsPath,
                CliProjectPath, EngineProjectPath, TruthProjectPath,
                "Directory.Build.props", "Directory.Packages.props", "global.json",
                inspectorScriptPath, inspectorSourcePath, InputHelperPath,
                PairScriptPath, SupervisorScriptPath, CiBaselineScriptPath,
                CacheEnsureScriptPath, CachePublishScriptPath,
                "tools/scripts/worktree/lean-cache-input.sh",
                ResourceObservationLibraryPath, ToolchainInstallerPath,
                JudgeContentAddressPath, ScribeContentChecksPath, WorkflowPath,
                EngineLockPath, CliLockPath, TruthLockPath,
            ];
            var producerManifest = string.Concat(producerPaths.Select(path =>
                $"{Convert.ToHexStringLower(SHA256.HashData(File.ReadAllBytes(Path.Combine(repository, path))))}  {path}\n")
                .Order(StringComparer.Ordinal));
            var producer = Convert.ToHexStringLower(SHA256.HashData(Encoding.UTF8.GetBytes(producerManifest)));
            var sources = ManifestHash("Trureturing.lean", "D5/Probe.lean", inspectorSourcePath);
            var config = ManifestHash("lean-toolchain", "lake-manifest.json", "lakefile.toml");
            var preimage = "schema=stratalint-lean-report-repository-input-v1\n"
                + $"repository_inspector_sha256={producer}\n"
                + $"lean_sources_sha256={sources}\nlean_config_sha256={config}\n";
            var address = Convert.ToHexStringLower(SHA256.HashData(Encoding.UTF8.GetBytes(preimage)));
            return Encoding.UTF8.GetBytes($"{address} {producer} {sources} {config}\n");
        }
    }
}
