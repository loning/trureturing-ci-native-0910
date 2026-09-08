using System.Text;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed partial class MakeWorkflowTests
{
    private const string GateForkSha = "0000000000000000000000000000000000000001";
    private const string GateCandidateSha = "0000000000000000000000000000000000000002";

    [Fact]
    public void ScribeContentChecksUseTheExplicitNonEmptyReport()
    {
        if (OperatingSystem.IsWindows()) return;

        var root = TestRepositoryLayout.FindRoot();
        using var fixture = new TemporaryDirectory();
        var binDirectory = Path.Combine(fixture.Path, "bin");
        var explicitReport = Path.Combine(fixture.Path, "explicit-report.json");
        var ambientReport = Path.Combine(fixture.Path, "ambient-report.json");
        var scribe = Path.Combine(fixture.Path, "StrataLint.Scribe.dll");
        var log = Path.Combine(fixture.Path, "scribe.log");
        Directory.CreateDirectory(binDirectory);
        File.WriteAllText(explicitReport, "explicit\n");
        File.WriteAllText(ambientReport, "ambient\n");
        File.WriteAllText(scribe, "fixture\n");
        WriteExecutable(
            Path.Combine(binDirectory, "dotnet"),
            "#!/usr/bin/env bash\nprintf '%s|%s\\n' \"$STRATALINT_LEAN_REPORT\" \"$*\" >> \"$SCRIBE_LOG\"");
        var headResult = TestProcessRunner.Run(
            "git",
            ["rev-parse", "HEAD"],
            root,
            BoundedProcessRunner.HangDetectionBudget,
            64 * 1024);
        Assert.Equal(0, headResult.ExitCode);
        var baseRevision = Encoding.UTF8.GetString(headResult.StandardOutput).Trim();
        WriteExecutable(
            Path.Combine(binDirectory, "git"),
            $$"""
            #!/usr/bin/env bash
            if [[ "${1:-}" == -C ]]; then shift 2; fi
            case "$*" in
              "cat-file -e {{baseRevision}}^{commit}"|"ls-files --others --exclude-standard -z") exit 0 ;;
              "diff --name-only --no-renames -z {{baseRevision}} --") printf 'Blueprint/D5/Probe.scribe.cs\0' ;;
              *) echo "unexpected git invocation: $*" >&2; exit 90 ;;
            esac
            """);

        var result = TestProcessRunner.Run(
            "/bin/bash",
            [
                "-c",
                "PATH=\"$1:/usr/bin:/bin\" STRATALINT_LEAN_REPORT=\"$2\" SCRIBE_LOG=\"$3\" "
                    + "exec /bin/bash \"$4\" \"$5\" \"$6\"",
                "scribe-content-checks",
                binDirectory,
                ambientReport,
                log,
                Path.Combine(root, ScribeContentChecksScriptPath),
                explicitReport,
                scribe,
                baseRevision,
            ],
            root,
            BoundedProcessRunner.HangDetectionBudget,
            64 * 1024);

        Assert.True(
            result.ExitCode == 0,
            $"expected exit 0, actual {result.ExitCode}\nstdout:\n{Encoding.UTF8.GetString(result.StandardOutput)}\nstderr:\n{Encoding.UTF8.GetString(result.StandardError)}");
        var invocations = File.ReadAllLines(log);
        Assert.Equal(3, invocations.Length);
        Assert.All(invocations, line => Assert.StartsWith(explicitReport + "|", line, StringComparison.Ordinal));
        Assert.DoesNotContain(invocations, line => line.Contains(ambientReport, StringComparison.Ordinal));
        Assert.Contains(
            invocations,
            static line => line.EndsWith(" describe-report --check", StringComparison.Ordinal));
        Assert.Contains(
            invocations,
            line => line.EndsWith(
                $" markdown-check --report {explicitReport}",
                StringComparison.Ordinal));
    }

    [Fact]
    public void ScribeContentChecksRejectMissingAndEmptyReportsBeforeRunningScribe()
    {
        if (OperatingSystem.IsWindows()) return;

        var root = TestRepositoryLayout.FindRoot();
        using var fixture = new TemporaryDirectory();
        var binDirectory = Path.Combine(fixture.Path, "bin");
        var emptyReport = Path.Combine(fixture.Path, "empty-report.json");
        var missingReport = Path.Combine(fixture.Path, "missing-report.json");
        var scribe = Path.Combine(fixture.Path, "StrataLint.Scribe.dll");
        Directory.CreateDirectory(binDirectory);
        File.WriteAllText(emptyReport, string.Empty);
        File.WriteAllText(scribe, "fixture\n");
        WriteExecutable(Path.Combine(binDirectory, "dotnet"), "#!/usr/bin/env bash\nexit 0");

        foreach (var report in new[] { emptyReport, missingReport })
        {
            var result = TestProcessRunner.Run(
                "/bin/bash",
                [
                    "-c",
                    "PATH=\"$1:/usr/bin:/bin\" exec /bin/bash \"$2\" \"$3\" \"$4\"",
                    "scribe-content-checks-invalid-report",
                    binDirectory,
                    Path.Combine(root, ScribeContentChecksScriptPath),
                    report,
                    scribe,
                ],
                root,
                BoundedProcessRunner.HangDetectionBudget,
                64 * 1024);

            Assert.NotEqual(0, result.ExitCode);
        }
    }

    [Fact]
    public void HarnessGateUsesExternalJudgeWithSolutionRestoreButWithoutBuild()
    {
        if (OperatingSystem.IsWindows()) return;

        var root = TestRepositoryLayout.FindRoot();
        using var fixture = new TemporaryDirectory();
        var candidateRoot = Path.Combine(fixture.Path, "candidate");
        var binDirectory = Path.Combine(fixture.Path, "bin");
        var report = Path.Combine(fixture.Path, "candidate-lean-report.json");
        var judge = Path.Combine(fixture.Path, "judge", "StrataLint.dll");
        var log = Path.Combine(fixture.Path, "dotnet.log");
        Directory.CreateDirectory(candidateRoot);
        Directory.CreateDirectory(binDirectory);
        Directory.CreateDirectory(Path.GetDirectoryName(judge)!);
        File.WriteAllText(report, "{}\n");
        File.WriteAllText(judge, string.Empty);
        WriteExecutable(
            Path.Combine(binDirectory, "dotnet"),
            """
            #!/usr/bin/env bash
            printf '%s\n' "$*" >> "$DOTNET_LOG"
            case "${1:-}" in
              restore) exit 0 ;;
            esac
            case "${2:-}" in
              check|filemap-conform) exit 0 ;;
            esac
            exit 91
            """);

        var result = TestProcessRunner.Run(
            "/bin/bash",
            [
                "-c",
                "PATH=\"$1:/usr/bin:/bin\" DOTNET_LOG=\"$2\" exec /bin/bash \"$3\" "
                + "--candidate \"$4\" --base base --candidate-lean-report \"$5\" --judge-dll \"$6\"",
                "external-judge",
                binDirectory,
                log,
                Path.Combine(root, ".github", "scripts", "harness-gate.sh"),
                candidateRoot,
                report,
                judge,
            ],
            candidateRoot,
            BoundedProcessRunner.HangDetectionBudget,
            64 * 1024);

        Assert.Equal(0, result.ExitCode);
        var invocations = File.ReadAllLines(log);
        Assert.Equal(3, invocations.Length);
        Assert.DoesNotContain(invocations, line => line.Contains(" selftest", StringComparison.Ordinal));
        Assert.Single(invocations, line => line.Contains(" check --protected-base base", StringComparison.Ordinal));
        Assert.Single(invocations, line => line.EndsWith(" filemap-conform", StringComparison.Ordinal));

        // 判官用 Roslyn 分析候选树,故解决方案的 compile assets 必须就位 —— gate 因此无条件 restore
        // (`.github/scripts/harness-gate.sh`,为修 #4513;只在 judge cache-miss 时 restore 会让
        // ScribeTestMapDeriver 绑不上 xUnit 符号,把 conservative unknown 从 <=281 抬到 673)。
        // 外部 judge 模式仍然不 build judge、也不用 msbuild 解析 TargetPath。
        Assert.Single(invocations, line => line.StartsWith("restore ", StringComparison.Ordinal));
        Assert.DoesNotContain(invocations, line =>
            line.StartsWith("build ", StringComparison.Ordinal)
            || line.StartsWith("msbuild ", StringComparison.Ordinal));
    }

    [System.Runtime.Versioning.UnsupportedOSPlatform("windows")]
    private static void WriteExecutable(string path, string content)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path)!);
        File.WriteAllText(path, content, new UTF8Encoding(false));
        File.SetUnixFileMode(path, UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.UserExecute);
    }
}
