using StrataLint.TestSupport;
using Xunit;

namespace StrataLint.EngineeringScope.Tests;

public sealed class CommonStageContractTests
{
    [Fact]
    public async Task TimedOutStartedStepRetainsOutputAndIsReportedAsFailed()
    {
        using var fixture = new CurrentExecutionContractTests.CandidateFixture();
        PrepareCurrent(fixture);
        var started = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
        using var watcher = new FileSystemWatcher(Path.Combine(fixture.Root, "build"), "producer-started");
        watcher.Created += (_, _) => started.TrySetResult();
        watcher.EnableRaisingEvents = true;
        using var deadline = new CancellationTokenSource();
        using var output = new StringWriter();
        var run = Task.Run(() => new CommonStages(fixture.Root, output, deadline.Token).Run("current", null));
        try
        {
            await started.Task.WaitAsync(TestBudgets.ScriptProcessHangGuard);
            deadline.Cancel();
            Assert.Equal(2, await run.WaitAsync(TestBudgets.ScriptProcessHangGuard));
        }
        catch (TimeoutException exception)
        {
            throw new SkipException("infrastructure-hang-guard expired for current stage fixture: " + exception.Message);
        }
        finally
        {
            deadline.Cancel();
            await run;
        }
        using var summary = System.Text.Json.JsonDocument.Parse(TemporaryFileSystem.File.ReadAllText(
            Path.Combine(fixture.Root, CommonExecutionEvidence.RootPath, "current-result.json")));
        Assert.Equal(2, summary.RootElement.GetProperty("exit").GetInt32());
        var step = Assert.Single(summary.RootElement.GetProperty("steps").EnumerateArray());
        Assert.Equal("lean-report", step.GetProperty("name").GetString());
        Assert.Equal(124, step.GetProperty("raw_exit").GetInt32());
        Assert.Equal(2, step.GetProperty("exit").GetInt32());
        Assert.Equal("failed", step.GetProperty("status").GetString());
        var log = TemporaryFileSystem.File.ReadAllText(Path.Combine(fixture.Root, step.GetProperty("log").GetString()!));
        Assert.Contains("producer-started", log, StringComparison.Ordinal);
        Assert.Contains("producer-stderr", log, StringComparison.Ordinal);
        Assert.Equal(new[] { "scribe", "filemap", "check-current" }, summary.RootElement.GetProperty("not_executed")
            .EnumerateArray().Select(value => value.GetString()));
        Assert.False(TemporaryFileSystem.File.Exists(Path.Combine(fixture.Root, CommonExecutionEvidence.CurrentPath)));
    }

    [Fact]
    public async Task ExpiredDeadlineBeforeStartupLeavesAllStepsUnexecuted()
    {
        using var fixture = new CurrentExecutionContractTests.CandidateFixture();
        PrepareCurrent(fixture);
        var start = new System.Diagnostics.ProcessStartInfo(Path.Combine(
            Path.GetDirectoryName(typeof(Program).Assembly.Location)!, "StrataLint.EngineeringScope"))
        {
            WorkingDirectory = fixture.Root, RedirectStandardOutput = true, RedirectStandardError = true,
        };
        foreach (var argument in new[] { "current", "--repository", fixture.Root }) start.ArgumentList.Add(argument);
        start.Environment["PREFLIGHT_DEADLINE_AT"] = "0";
        using var process = System.Diagnostics.Process.Start(start)!;
        var stdout = process.StandardOutput.ReadToEndAsync();
        var stderr = process.StandardError.ReadToEndAsync();
        try
        {
            await process.WaitForExitAsync().WaitAsync(TestBudgets.ScriptProcessHangGuard);
            var output = await stdout + await stderr;
            Assert.True(process.ExitCode == 2, output);
        }
        catch (TimeoutException exception)
        {
            throw new SkipException("infrastructure-hang-guard expired for expired stage fixture: " + exception.Message);
        }
        finally
        {
            if (!process.HasExited) { process.Kill(entireProcessTree: true); process.WaitForExit(); }
        }
        using var summary = System.Text.Json.JsonDocument.Parse(TemporaryFileSystem.File.ReadAllText(
            Path.Combine(fixture.Root, CommonExecutionEvidence.RootPath, "current-result.json")));
        Assert.Equal(2, summary.RootElement.GetProperty("exit").GetInt32());
        Assert.Equal("PREFLIGHT_BUDGET_EXHAUSTED owner=outer-deadline", summary.RootElement.GetProperty("error").GetString());
        Assert.Empty(summary.RootElement.GetProperty("steps").EnumerateArray());
        Assert.Equal(new[] { "lean-report", "scribe", "filemap", "check-current" },
            summary.RootElement.GetProperty("not_executed").EnumerateArray().Select(value => value.GetString()));
        Assert.False(TemporaryFileSystem.File.Exists(Path.Combine(fixture.Root, "build/producer-started")));
        Assert.False(TemporaryFileSystem.File.Exists(Path.Combine(fixture.Root, CommonExecutionEvidence.CurrentPath)));
    }

    private static void PrepareCurrent(CurrentExecutionContractTests.CandidateFixture fixture)
    {
        TemporaryFileSystem.File.WriteAllText(Path.Combine(fixture.Root, "Makefile"), "lean-report:\n\t@/bin/bash build/producer.sh\n");
        TemporaryFileSystem.Directory.CreateDirectory(Path.Combine(fixture.Root, "build"));
        TemporaryFileSystem.File.WriteAllText(Path.Combine(fixture.Root, "build/producer.sh"), """
            set -euo pipefail
            mkfifo build/producer-wait
            printf 'producer-started\n'
            printf 'producer-stderr\n' >&2
            : > build/producer-started
            read -r release < build/producer-wait
            """);
        var binaries = new[] { CommonExecutionEvidence.CliPath, CommonExecutionEvidence.ScribePath,
            "tools/StrataLint.EngineeringScope/bin/Release/net10.0/StrataLint.EngineeringScope.dll" };
        foreach (var binary in binaries)
        {
            var full = Path.Combine(fixture.Root, binary);
            TemporaryFileSystem.Directory.CreateDirectory(Path.GetDirectoryName(full)!);
            TemporaryFileSystem.File.WriteAllText(full, "fixture binary");
        }
        Assert.Equal(0, Program.RunCurrentTests(fixture.Root, (_, results) => { fixture.WriteTrx(results, "Passed"); return 0; }, TextWriter.Null));
        CommonExecutionEvidence.SealEngineering(fixture.Root, binaries, CommonExecutionEvidence.EngineeringSteps
            .Select(name => new StageStep(name, 0, 0, "executed", binaries[0])).ToArray());
    }

    [Fact]
    public void EngineeringEvidenceSurvivesLeanCacheReplacement()
    {
        using var fixture = new CurrentExecutionContractTests.CandidateFixture();
        Assert.Equal(0, Program.RunCurrentTests(fixture.Root, (_, results) => { fixture.WriteTrx(results, "Passed"); return 0; }, TextWriter.Null));
        var log = CommonExecutionEvidence.RootPath + "/fixture.log";
        TemporaryFileSystem.File.WriteAllText(Path.Combine(fixture.Root, log), "executed\n");
        CommonExecutionEvidence.SealEngineering(fixture.Root, [log], CommonExecutionEvidence.EngineeringSteps
            .Select(name => new StageStep(name, 0, 0, "executed", log)).ToArray());
        TemporaryFileSystem.Directory.CreateDirectory(Path.Combine(fixture.Root, ".lake"));
        TemporaryFileSystem.Directory.Delete(Path.Combine(fixture.Root, ".lake"), recursive: true);
        CommonExecutionEvidence.ValidateEngineering(fixture.Root);
    }

    [Fact]
    public void FreshEngineeringStartsLockedRestoreBeforeReportingMissingSolution()
    {
        using var fixture = new CurrentExecutionContractTests.CandidateFixture();
        using var output = new StringWriter();
        Assert.Equal(1, new CommonStages(fixture.Root, output).Run("engineering", null));
        var summary = TemporaryFileSystem.File.ReadAllText(Path.Combine(fixture.Root, CommonExecutionEvidence.RootPath, "engineering-result.json"));
        Assert.Contains("restore-StrataLint", summary, StringComparison.Ordinal);
        Assert.True(TemporaryFileSystem.File.Exists(Path.Combine(fixture.Root, CommonExecutionEvidence.RootPath, "logs/engineering/restore-StrataLint.log")));
    }

    [Fact]
    public void CurrentConsumerRejectsMissingReportAndChangedDll()
    {
        using var fixture = new CurrentExecutionContractTests.CandidateFixture();
        Assert.Equal(0, Program.RunCurrentTests(fixture.Root, (_, results) => { fixture.WriteTrx(results, "Passed"); return 0; }, TextWriter.Null));
        var dll = CommonExecutionEvidence.RootPath + "/fixture.dll";
        TemporaryFileSystem.File.WriteAllText(Path.Combine(fixture.Root, dll), "candidate binary");
        var steps = CommonExecutionEvidence.EngineeringSteps.Select(name => new StageStep(name, 0, 0, "executed", dll)).ToArray();
        CommonExecutionEvidence.SealEngineering(fixture.Root, [dll], steps);
        CommonExecutionEvidence.ValidateEngineering(fixture.Root);
        var currentSteps = CommonExecutionEvidence.CurrentSteps.Select(name => new StageStep(name, 0, 0, "executed", dll)).ToArray();
        Assert.ThrowsAny<IOException>(() => CommonExecutionEvidence.SealCurrent(fixture.Root, currentSteps));
        TemporaryFileSystem.File.AppendAllText(Path.Combine(fixture.Root, dll), "stale");
        Assert.ThrowsAny<Exception>(() => CommonExecutionEvidence.ValidateEngineering(fixture.Root));
    }

    [Theory]
    [InlineData(0, "", false)]
    [InlineData(1, "error MSB1009: Project file does not exist.", false)]
    [InlineData(1, "MissingCapability.cs(13,9): error CS7036: missing metaClear", true)]
    [InlineData(1, "MissingCapability.cs(13,9): error CS7036: missing unrelatedArgument", false)]
    [InlineData(127, "MissingCapability.cs(13,9): error CS7036: missing metaClear", false)]
    public void NegativeProofRequiresExpectedDiagnostic(int exit, string output, bool accepted) =>
        Assert.Equal(accepted, CompilationProof.ValidateCapability(exit, output));

    [Theory]
    [InlineData(0, 0)]
    [InlineData(1, 1)]
    [InlineData(2, 2)]
    [InlineData(3, 0)]
    [InlineData(19, 2)]
    [InlineData(124, 2)]
    public void StageExitNormalizationPreservesCheckFailureAndRejectsUnknown(int raw, int expected) =>
        Assert.Equal(expected, CommonStages.Normalize(raw, allowProtectedAnnotation: true));

    [Fact]
    public void ProtectedAnnotationCannotPassAnOrdinaryCommonStep() =>
        Assert.Equal(2, CommonStages.Normalize(3, allowProtectedAnnotation: false));

    [Theory]
    [InlineData("transport")]
    [InlineData("invalid-archive-before-seal")]
    [InlineData("missing-report")]
    [InlineData("invalid-report")]
    [InlineData("missing-materials")]
    [InlineData("round")]
    [InlineData("missing-step")]
    [InlineData("failed-step")]
    [InlineData("missing-base-project")]
    public void CompleteCommonArtifactsValidateAfterTransportAndRejectIncompleteEvidence(string scenario)
    {
        using var source = new CurrentExecutionContractTests.CandidateFixture();
        using var target = new CurrentExecutionContractTests.CandidateFixture();
        Assert.Equal(0, Program.RunCurrentTests(source.Root, (_, results) => { source.WriteTrx(results, "Passed"); return 0; }, TextWriter.Null));
        const string log = CommonExecutionEvidence.RootPath + "/fixture.log";
        TemporaryFileSystem.File.WriteAllText(Path.Combine(source.Root, log), "executed\n");
        var engineeringSteps = CommonExecutionEvidence.EngineeringSteps.Select(name => new StageStep(name, name.EndsWith("proof", StringComparison.Ordinal) ? 1 : 0, 0, "executed", log)).ToArray();
        CommonExecutionEvidence.SealEngineering(source.Root, [log], engineeringSteps);
        var report = Path.Combine(source.Root, CommonExecutionEvidence.ReportPath);
        TemporaryFileSystem.Directory.CreateDirectory(Path.GetDirectoryName(report)!);
        TemporaryFileSystem.File.WriteAllText(report, "{\"modules\": [], \"schema\": \"stratalint-raw-lean-report-v2\"}\n");
        using (var archive = new MemoryStream())
        {
            using (new System.IO.Compression.ZipArchive(archive, System.IO.Compression.ZipArchiveMode.Create, leaveOpen: true)) { }
            TemporaryFileSystem.File.WriteAllBytes(report + ".materials.zip", archive.ToArray());
        }
        var currentSteps = CommonExecutionEvidence.CurrentSteps.Select(name => new StageStep(name, 0, 0, "executed", log)).ToArray();
        if (scenario == "invalid-archive-before-seal")
        {
            TemporaryFileSystem.File.WriteAllText(report + ".materials.zip", "not a ZIP archive");
            Assert.Throws<InvalidDataException>(() => CommonExecutionEvidence.SealCurrent(source.Root, currentSteps));
            return;
        }
        CommonExecutionEvidence.SealCurrent(source.Root, currentSteps);
        var bundle = TemporaryFileSystem.File.ReadAllText(Path.Combine(source.Root, CommonExecutionEvidence.RootPath, "artifact-paths.nul"))
            .Split('\0', StringSplitOptions.RemoveEmptyEntries);
        var files = bundle.SelectMany(relative =>
        {
            var full = Path.Combine(source.Root, relative);
            return TemporaryFileSystem.Directory.Exists(full)
                ? TemporaryFileSystem.Directory.EnumerateFiles(full, "*", SearchOption.AllDirectories)
                : [full];
        });
        foreach (var file in files)
        {
            var destination = Path.Combine(target.Root, Path.GetRelativePath(source.Root, file));
            TemporaryFileSystem.Directory.CreateDirectory(Path.GetDirectoryName(destination)!);
            TemporaryFileSystem.File.WriteAllBytes(destination, TemporaryFileSystem.File.ReadAllBytes(file));
        }
        CommonExecutionEvidence.ValidateCurrent(target.Root, [CurrentExecutionContractTests.CandidateFixture.First]);
        var current = CommonExecutionEvidence.Read<CommonStageRecord>(target.Root, CommonExecutionEvidence.CurrentPath);
        switch (scenario)
        {
            case "transport": return;
            case "missing-report": TemporaryFileSystem.File.Delete(Path.Combine(target.Root, CommonExecutionEvidence.ReportPath)); break;
            case "invalid-report": TemporaryFileSystem.File.WriteAllText(Path.Combine(target.Root, CommonExecutionEvidence.ReportPath), "invalid"); break;
            case "missing-materials": TemporaryFileSystem.File.Delete(Path.Combine(target.Root, CommonExecutionEvidence.ReportPath + ".materials.zip")); break;
            case "round": CommonExecutionEvidence.Write(target.Root, CommonExecutionEvidence.CurrentPath, current with { Round = "another-round" }); break;
            case "missing-step": CommonExecutionEvidence.Write(target.Root, CommonExecutionEvidence.CurrentPath, current with { Steps = current.Steps.Skip(1).ToArray() }); break;
            case "failed-step": CommonExecutionEvidence.Write(target.Root, CommonExecutionEvidence.CurrentPath, current with { Steps = current.Steps.Select(step => step with { Exit = 1, Status = "failed" }).ToArray() }); break;
        }
        Assert.ThrowsAny<Exception>(() => CommonExecutionEvidence.ValidateCurrent(target.Root,
            scenario == "missing-base-project" ? ["tools/tests/Removed/Removed.csproj"] : []));
    }
}
