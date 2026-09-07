using System.Diagnostics;
using System.Text.Json;
using StrataLint.Engine;

namespace StrataLint.EngineeringScope;

internal sealed class CommonStages(string root, TextWriter output)
{
    private readonly List<StageStep> steps = [];
    private string stage = "input";
    private string? candidate;

    internal static int Normalize(int raw, bool allowProtectedAnnotation = false) => raw switch
    {
        0 => 0,
        1 => 1,
        3 when allowProtectedAnnotation => 0,
        _ => 2,
    };

    internal int Run(string name, string? baseSha)
    {
        stage = name;
        var exit = 2;
        string? failure = null;
        try
        {
            candidate = CommonExecutionEvidence.Candidate(root);
            switch (name)
            {
                case "engineering": Engineering(); break;
                case "current": Current(); break;
                case "delta": Delta(baseSha); break;
                default: throw new ArgumentException("stage must be engineering, current, or delta");
            }
            if (candidate != CommonExecutionEvidence.Candidate(root)) throw new InvalidDataException("candidate changed during stage");
            exit = 0;
        }
        catch (StageFailure exception) { exit = exception.Exit; failure = exception.Message; }
        catch (Exception exception) { failure = exception.Message; }
        finally
        {
            var planned = stage switch
            {
                "engineering" => CommonExecutionEvidence.EngineeringSteps,
                "current" => CommonExecutionEvidence.CurrentSteps,
                "delta" => ["check-delta"],
                _ => [],
            };
            object Summary() => new { stage, candidate, base_sha = baseSha, exit, error = failure, steps,
                not_executed = planned.Where(name => !steps.Any(step => step.Name == name)),
                test_evidence = CommonExecutionEvidence.TestsPath, engineering_evidence = CommonExecutionEvidence.EngineeringPath,
                current_evidence = CommonExecutionEvidence.CurrentPath, report = CommonExecutionEvidence.ReportPath };
            try { CommonExecutionEvidence.Write(root, CommonExecutionEvidence.RootPath + "/" + stage + "-result.json", Summary()); }
            catch (Exception exception) { exit = 2; failure = $"{failure}; summary write failed: {exception.Message}"; }
            output.WriteLine(JsonSerializer.Serialize(Summary()));
        }
        return exit;
    }

    private void Engineering()
    {
        Directory.CreateDirectory(Path.Combine(root, CommonExecutionEvidence.RootPath));
        File.Delete(Path.Combine(root, CommonExecutionEvidence.EngineeringPath));
        File.Delete(Path.Combine(root, CommonExecutionEvidence.CurrentPath));
        File.Delete(Path.Combine(root, CommonExecutionEvidence.TestsPath));
        foreach (var project in new[] { "tools/StrataLint.sln", "tools/tests/CompileFailProof/CompileFailProof.csproj", "tools/tests/BannedApiCompileFailProof/BannedApiCompileFailProof.csproj" })
            Step("restore-" + Path.GetFileNameWithoutExtension(project), "dotnet", ["restore", project, "--locked-mode"]);
        Step("build", "dotnet", ["build", "tools/StrataLint.sln", "--configuration", "Release", "--no-restore", "--warnaserror"]);
        Step("tests", "dotnet", ["tools/StrataLint.EngineeringScope/bin/Release/net10.0/StrataLint.EngineeringScope.dll", "--repository", root]);
        var first = Step("selftest-first", "dotnet", [CommonExecutionEvidence.CliPath, "selftest"]);
        var second = Step("selftest-second", "dotnet", [CommonExecutionEvidence.CliPath, "selftest"]);
        if (first != second) throw new StageFailure(1, "selftest outputs differ");
        Step("capability-proof", "dotnet", ["build", "tools/tests/CompileFailProof/CompileFailProof.csproj", "--no-restore", "--configuration", "Release"], CompilationProof.ValidateCapability);
        Step("banned-api-proof", "dotnet", ["build", "tools/tests/BannedApiCompileFailProof/BannedApiCompileFailProof.csproj", "--no-restore", "--configuration", "Release"],
            (raw, text) => CompilationProof.ValidateBannedApi(raw, text, File.ReadAllText(Path.Combine(root, "tools/tests/BannedApiCompileFailProof/BannedApiViolations.cs"))));
        if (candidate != CommonExecutionEvidence.Candidate(root)) throw new InvalidDataException("candidate changed during engineering");
        var directories = new[] { CommonExecutionEvidence.CliPath, CommonExecutionEvidence.ScribePath,
            "tools/StrataLint.EngineeringScope/bin/Release/net10.0/StrataLint.EngineeringScope.dll" }.Select(path => Path.GetDirectoryName(Path.Combine(root, path))!);
        var binaries = directories.SelectMany(directory => Directory.GetFiles(directory, "*", SearchOption.AllDirectories))
            .Select(path => Path.GetRelativePath(root, path).Replace('\\', '/'));
        CommonExecutionEvidence.SealEngineering(root, binaries, steps.ToArray());
    }

    private void Current()
    {
        var engineering = CommonExecutionEvidence.ValidateEngineering(root);
        RequireBinary(engineering, CommonExecutionEvidence.CliPath);
        RequireBinary(engineering, CommonExecutionEvidence.ScribePath);
        RequireBinary(engineering, "tools/StrataLint.EngineeringScope/bin/Release/net10.0/StrataLint.EngineeringScope.dll");
        File.Delete(Path.Combine(root, CommonExecutionEvidence.CurrentPath));
        Step("lean-report", "make", ["lean-report"]);
        _ = RawLeanReportArtifact.ReadFile(Path.Combine(root, CommonExecutionEvidence.ReportPath), CommonExecutionEvidence.Snapshot(root), validateMaterials: true);
        Step("scribe", "/bin/bash", ["tools/scripts/workflow/scribe-content-checks.sh", CommonExecutionEvidence.ReportPath, CommonExecutionEvidence.ScribePath]);
        Step("filemap", "dotnet", [CommonExecutionEvidence.CliPath, "filemap-conform"]);
        Step("check-current", "dotnet", [CommonExecutionEvidence.CliPath, "check-current", "--candidate-lean-report", CommonExecutionEvidence.ReportPath]);
        CommonExecutionEvidence.SealCurrent(root, steps.ToArray());
    }

    private void Delta(string? baseSha)
    {
        if (baseSha is null || baseSha.Length != 40 || !baseSha.All(char.IsAsciiHexDigit))
            throw new ArgumentException("delta requires an explicit 40-hex base commit SHA");
        var type = Capture("git", ["cat-file", "-t", baseSha]);
        if (type.Exit != 0 || type.Text.Trim() != "commit") throw new ArgumentException("base must be an available commit object");
        CommonExecutionEvidence.ValidateCurrent(root);
        RequireBinary(CommonExecutionEvidence.ValidateEngineering(root), CommonExecutionEvidence.CliPath);
        Step("check-delta", "dotnet", [CommonExecutionEvidence.CliPath, "check-delta", "--protected-base", baseSha,
            "--candidate-lean-report", CommonExecutionEvidence.ReportPath], allowAnnotation: true);
    }

    private static void RequireBinary(CommonStageRecord record, string path)
    {
        if (!record.Materials.Any(material => material.Path == path)) throw new InvalidDataException("unbound candidate binary: " + path);
    }

    private string Step(string name, string executable, string[] arguments, Func<int, string, bool>? proof = null, bool allowAnnotation = false)
    {
        var result = Capture(executable, arguments);
        var log = $"{CommonExecutionEvidence.RootPath}/logs/{stage}/{name}.log";
        var full = Path.Combine(root, log);
        Directory.CreateDirectory(Path.GetDirectoryName(full)!);
        File.WriteAllText(full, result.Text);
        var exit = proof is null ? Normalize(result.Exit, allowAnnotation) : proof(result.Exit, result.Text) ? 0 : 1;
        steps.Add(new(name, result.Exit, exit, exit == 0 ? "executed" : "failed", log));
        output.WriteLine(result.Text);
        if (exit != 0) throw new StageFailure(exit, $"{name} failed: raw_exit={result.Exit}; log={log}");
        return result.Text;
    }

    private (int Exit, string Text) Capture(string executable, string[] arguments)
    {
        var timeout = TimeSpan.FromHours(2);
        var deadline = Environment.GetEnvironmentVariable("PREFLIGHT_DEADLINE_AT");
        if (deadline is not null)
        {
            if (!long.TryParse(deadline, out var seconds)) throw new ArgumentException("invalid PREFLIGHT_DEADLINE_AT");
            timeout = DateTimeOffset.FromUnixTimeSeconds(seconds) - TimeProvider.System.GetUtcNow();
            if (timeout <= TimeSpan.Zero) throw new TimeoutException("PREFLIGHT_BUDGET_EXHAUSTED owner=outer-deadline");
        }
        var start = new ProcessStartInfo(executable) { WorkingDirectory = root, RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false };
        start.Environment["DOTNET_CLI_UI_LANGUAGE"] = "en-US";
        foreach (var arg in arguments) start.ArgumentList.Add(arg);
        using var process = Process.Start(start) ?? throw new IOException("cannot start " + executable);
        var stdout = process.StandardOutput.ReadToEndAsync();
        var stderr = process.StandardError.ReadToEndAsync();
        using var cancellation = new CancellationTokenSource(timeout);
        try { process.WaitForExitAsync(cancellation.Token).GetAwaiter().GetResult(); }
        catch (OperationCanceledException)
        {
            process.Kill(entireProcessTree: true);
            process.WaitForExit();
            return (124, stdout.GetAwaiter().GetResult() + stderr.GetAwaiter().GetResult()
                + "\nstage deadline exceeded: " + executable + "\n");
        }
        return (process.ExitCode, stdout.GetAwaiter().GetResult() + stderr.GetAwaiter().GetResult());
    }

    private sealed class StageFailure(int exit, string message) : Exception(message)
    {
        internal int Exit { get; } = exit;
    }
}
