using System.Security.Cryptography;
using System.Text;
using StrataLint.Engine;

namespace StrataLint.Tests;

// These execute the disposable script against controlled consumer responses.
// Real gate/engineering execution and workflow coverage are separate evidence.
public sealed class ReportCacheOmissionProbeTests
{
    private const string Probe = "tools/scripts/workflow/report-cache-corrupt-probe.sh";
    private const string Cli = "tools/StrataLint.Cli/bin/Release/net10.0/";
    private const string Project = "tools/tests/StrataLint.EngineeringScope.Tests/StrataLint.EngineeringScope.Tests.csproj";
    private const string TestDll = "tools/tests/StrataLint.EngineeringScope.Tests/bin/Release/net10.0/StrataLint.EngineeringScope.Tests.dll";

    [Fact]
    public void JudgeOmissionsRestoreOriginalBytesAndPreserveTheReport()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new Fixture();
        var result = fixture.Run();
        Assert.True(result.ExitCode == 0, Diagnostics(result));
        Assert.Equal(2, fixture.Calls.Length);
        Assert.All(fixture.Calls, line => Assert.Contains("--judge-dll", line));
        Assert.Contains("case=O1 restore=unchanged", Diagnostics(result));
        Assert.Contains("case=O2 restore=unchanged", Diagnostics(result));
        Assert.Contains("source=unchanged", Diagnostics(result));
        fixture.AssertRestored();
    }

    [Theory]
    [InlineData("entry-accepted")]
    [InlineData("entry-protected")]
    [InlineData("entry-unrelated")]
    [InlineData("entry-mixed")]
    [InlineData("runtime-accepted")]
    [InlineData("runtime-protected")]
    [InlineData("runtime-unrelated")]
    [InlineData("restore-failed")]
    public void WrongConsumerResultFailsAndRetainsDiagnostics(string scenario)
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new Fixture();
        var result = fixture.Run(scenario);
        Assert.True(result.ExitCode != 0, Diagnostics(result));
        Assert.Contains("coverage=failed", Diagnostics(result));
        Assert.Contains("consumer_exit=", Diagnostics(result));
        Assert.Contains("restore=unchanged", Diagnostics(result));
        Assert.NotEmpty(fixture.Calls);
        fixture.AssertRestored();
    }

    [Theory]
    [InlineData("runtime-linux")]
    [InlineData("runtime-noncanonical")]
    public void NativeHostPathAndExitAreRecordedWithoutDemandingMacOsExit131(string scenario)
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new Fixture();
        var result = fixture.Run(scenario);
        Assert.True(result.ExitCode == 0, Diagnostics(result));
        Assert.Contains("case=O2 consumer_exit=150", Diagnostics(result));
        fixture.AssertRestored();
    }

    [Fact]
    public void ReportMutationFailsEvenWithTheExpectedConsumerErrors()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new Fixture();
        var result = fixture.Run("seed-mutated");
        Assert.True(result.ExitCode != 0, Diagnostics(result));
        Assert.Contains("source=changed", Diagnostics(result));
        fixture.AssertRestored(checkSeed: false);
    }

    [Theory]
    [InlineData(Cli + "StrataLint.dll", false)]
    [InlineData(Cli + "StrataLint.runtimeconfig.json", false)]
    [InlineData(TestDll, true)]
    public void MissingInitialOutputCannotCountAsAnOmission(string missing, bool engineering)
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new Fixture();
        ScriptHarnessScratch.DeleteScratchFile(fixture.PathFor(missing));
        var result = fixture.Run(engineering: engineering);
        Assert.True(result.ExitCode != 0, Diagnostics(result));
        Assert.Contains("reason=missing-initial-output", Diagnostics(result));
        Assert.Empty(fixture.Calls);
    }

    [Fact]
    public void EngineeringRunsOnceAndRestoresOnlyTheOmittedDll()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new Fixture();
        var result = fixture.Run(engineering: true);
        Assert.True(result.ExitCode == 0, Diagnostics(result));
        Assert.Single(fixture.Calls);
        Assert.Contains("case=O3 restore=unchanged", Diagnostics(result));
        Assert.Contains("coverage=verified", Diagnostics(result));
        Assert.Equal("rebuilt dependency", ScriptHarnessScratch.ReadScratchText(fixture.PathFor("other-output")));
        fixture.AssertRestored();
    }

    [Theory]
    [InlineData("unselected")]
    [InlineData("repaired-before-consumer")]
    [InlineData("wrong-project")]
    [InlineData("zero-tests")]
    [InlineData("stale-evidence")]
    [InlineData("owner-failed")]
    public void EngineeringRequiresSelectedProjectRetryAndSubsequentNonemptyEvidence(string scenario)
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new Fixture();
        var result = fixture.Run(scenario, engineering: true);
        Assert.True(result.ExitCode != 0, Diagnostics(result));
        Assert.Single(fixture.Calls);
        Assert.Contains("case=O3 coverage=failed", Diagnostics(result));
        Assert.Contains("case=O3 consumer_exit=", Diagnostics(result));
        fixture.AssertRestored();
    }

    [Fact]
    public void InterruptedOwnerStillRestoresTheOriginalDll()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new Fixture();
        var result = fixture.Run("interrupted", engineering: true);
        Assert.Equal(143, result.ExitCode);
        Assert.Contains("owner-interrupted", Diagnostics(result));
        Assert.Contains("case=O3 restore=unchanged", Diagnostics(result));
        fixture.AssertRestored();
    }

    [Fact]
    public void SkippedBuildIsAFailedCoverageGap()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new Fixture();
        var result = fixture.Run("build-skipped", engineering: true);
        Assert.True(result.ExitCode != 0, Diagnostics(result));
        Assert.Contains("reason=fresh-build-unavailable", Diagnostics(result));
        Assert.Empty(fixture.Calls);
        fixture.AssertRestored();
    }

    private static string Diagnostics(ProcessOutput result) =>
        Encoding.UTF8.GetString(result.StandardOutput) + Encoding.UTF8.GetString(result.StandardError);

    [System.Runtime.Versioning.UnsupportedOSPlatform("windows")]
    private sealed class Fixture : IDisposable
    {
        private readonly TemporaryDirectory temporary = new();
        private readonly string repository;
        private readonly string evidence;
        private readonly string bin;
        private readonly string report;
        private readonly Dictionary<string, byte[]> original = new(StringComparer.Ordinal);

        internal Fixture()
        {
            repository = Path.Combine(temporary.Path, "candidate");
            evidence = Path.Combine(temporary.Path, "evidence");
            bin = Path.Combine(temporary.Path, "bin");
            report = Path.Combine(temporary.Path, "seed.json");
            foreach (var path in new[] { repository, evidence, bin }) ScriptHarnessScratch.EnsureDirectory(path);
            ScriptHarnessScratch.CopyScriptInto(Path.Combine(TestRepositoryLayout.FindRoot(), Probe), PathFor(Probe));
            foreach (var path in new[] { Cli + "StrataLint.dll", Cli + "StrataLint.runtimeconfig.json", Cli + "other.dll", TestDll })
            {
                Write(path, "original " + path);
                original.Add(PathFor(path), ScriptHarnessScratch.ReadScratchBytes(PathFor(path)));
            }
            foreach (var suffix in new[] { "", ".sha256", ".input.attestation", ".provenance.json", ".materials.zip" })
            {
                ScriptHarnessScratch.WriteScratchText(report + suffix, "seed " + suffix);
                original.Add(report + suffix, ScriptHarnessScratch.ReadScratchBytes(report + suffix));
            }
            Stub(Path.Combine(bin, "git"), "if [[ \"${@: -1}\" == HEAD^1 ]]; then printf '%040d\\n' 1; else printf '%040d\\n' 1 2 3; fi");
            Stub(PathFor("tools/scripts/report/lean-report-input.sh"), "exit 0");
            Stub(PathFor("tools/scripts/report/lean-report-ci-baseline.sh"), "exit 0");
            Stub(PathFor(".github/scripts/harness-gate.sh"), """
                printf '%s\n' "$*" >> "$CALLS"
                [[ "$1" == --candidate && "$3" == --base && "$5" == --candidate-lean-report && "$7" == --judge-dll ]]
                [[ "$4" == 0000000000000000000000000000000000000001 && "$6" == "$SEED" ]]
                judge="$8"; cli="$(dirname "$judge")"
                [[ "$cli" != "$CANDIDATE/tools/StrataLint.Cli/bin/Release/net10.0" ]]
                test -s "$cli/other.dll"
                if [[ ! -e "$judge" ]]; then
                  test -s "$cli/StrataLint.runtimeconfig.json"
                  case "$SCENARIO" in
                    entry-accepted) exit 0;;
                    entry-protected) exit 3;;
                    entry-unrelated) echo 'unrelated report failure'; exit 2;;
                    entry-mixed) echo 'unrelated report failure';;
                  esac
                  echo "harness-gate: external judge DLL '$judge' is absent"
                  exit 2
                fi
                test -s "$judge"
                test ! -e "$cli/StrataLint.runtimeconfig.json"
                case "$SCENARIO" in
                  runtime-accepted) exit 0;;
                  runtime-protected) exit 3;;
                  runtime-unrelated) echo 'unrelated report failure'; exit 2;;
                  restore-failed) echo 'NU1301: package restore failed'; exit 1;;
                  seed-mutated) printf 'changed' >> "$SEED";;
                esac
                cli="$(cd "$cli" && pwd -P)"
                echo '[gate] cached-judge     0s'
                echo "The library 'libhostpolicy.so' required to execute the application was not found."
                echo "The application was run as a self-contained app because '$cli/StrataLint.runtimeconfig.json' was not found."
                [[ "$SCENARIO" != runtime-linux && "$SCENARIO" != runtime-noncanonical ]] || exit 150
                exit 131
                """);
            Stub(PathFor("tools/scripts/workflow/engineering-test-execution-harness.sh"), """
                printf '%s\n' "$*" >> "$CALLS"
                [[ "$1" == "$CANDIDATE" ]]
                test ! -e "$TEST_DLL"
                [[ "$SCENARIO" != interrupted ]] || { echo 'owner-interrupted'; kill -TERM "$PPID"; exit 0; }
                project="$TEST_PROJECT"
                [[ "$SCENARIO" != wrong-project ]] || project='tools/tests/Other/Other.csproj'
                selected="ENGINEERING_TEST_PROJECT project=\"$project\""
                retry="ENGINEERING_TEST_RETRY project=\"$project\" reason=missing-build-output"
                executed="ENGINEERING_TEST_EXECUTED project=\"$project\" evidence=trx executed="
                [[ "$SCENARIO" != unselected ]] && echo "$selected"
                [[ "$SCENARIO" != stale-evidence ]] || echo "${executed}7"
                [[ "$SCENARIO" == repaired-before-consumer ]] || echo "$retry"
                printf 'rebuilt' > "$TEST_DLL"
                printf 'rebuilt dependency' > "$CANDIDATE/other-output"
                if [[ "$SCENARIO" == zero-tests ]]; then echo "${executed}0"
                elif [[ "$SCENARIO" != stale-evidence ]]; then echo "${executed}7"; fi
                [[ "$SCENARIO" != owner-failed ]] || { echo 'unrelated test failed'; exit 42; }
                """);
        }

        internal string PathFor(string relative) => Path.Combine(repository, relative);
        internal string[] Calls => ScriptHarnessScratch.ReadRecordedCalls(Path.Combine(temporary.Path, "calls"));

        internal ProcessOutput Run(string scenario = "healthy", bool engineering = false)
        {
            string[] args = engineering
                ? ["--engineering-output-omission", evidence]
                : ["--judge-output-omissions", report, evidence];
            return TestProcessRunner.Run("/usr/bin/env",
                [
                    $"PATH={bin}:{Environment.GetEnvironmentVariable("PATH")}",
                    $"TMPDIR={temporary.Path}",
                    $"RUNNER_TEMP={temporary.Path}{(scenario == "runtime-noncanonical" ? "/../" + Path.GetFileName(temporary.Path) : "")}",
                    $"CALLS={Path.Combine(temporary.Path, "calls")}", $"SCENARIO={scenario}",
                    $"CANDIDATE={repository}", $"SEED={report}",
                    $"TEST_DLL={PathFor(TestDll)}", $"TEST_PROJECT={Project}",
                    $"PROBE_BUILD_OUTCOME={(scenario == "build-skipped" ? "skipped" : "success")}",
                    "GITHUB_EVENT_NAME=local", "/bin/bash", PathFor(Probe), .. args,
                ], repository, TestBudgets.ScriptProcessHangGuard, 1024 * 1024);
        }

        internal void AssertRestored(bool checkSeed = true)
        {
            foreach (var (path, bytes) in original)
            {
                if (!checkSeed && path.StartsWith(report, StringComparison.Ordinal)) continue;
                Assert.Equal(bytes, ScriptHarnessScratch.ReadScratchBytes(path));
            }
            var receipts = ScriptHarnessScratch.ReadScratchText(temporary, "evidence/omissions.txt");
            foreach (var name in new[] { "StrataLint.dll", "StrataLint.runtimeconfig.json", "StrataLint.EngineeringScope.Tests.dll" })
            {
                var bytes = original.Single(pair => Path.GetFileName(pair.Key) == name).Value;
                if (receipts.Contains($"/{name} initial_size=", StringComparison.Ordinal))
                    Assert.Contains("restored_sha256=" + Convert.ToHexStringLower(SHA256.HashData(bytes)), receipts);
            }
        }

        private void Write(string relative, string content)
        {
            var path = PathFor(relative);
            ScriptHarnessScratch.EnsureDirectory(Path.GetDirectoryName(path)!);
            ScriptHarnessScratch.WriteScratchText(path, content);
        }

        private static void Stub(string path, string body)
        {
            ScriptHarnessScratch.EnsureDirectory(Path.GetDirectoryName(path)!);
            ScriptHarnessScratch.WriteExecutableStub(path, body);
            // The real shell owners have no UTF-8 BOM before their shebang.
            ScriptHarnessScratch.WriteScratchText(path, ScriptHarnessScratch.ReadScratchText(path));
        }

        public void Dispose() => temporary.Dispose();
    }
}
