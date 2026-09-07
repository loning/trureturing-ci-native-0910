using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Text;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed partial class LeanReportCacheTests
{
    [Fact]
    public void FailureDiagnosticIncludesStrippedFileModeAndCapturedStreams()
    {
        if (OperatingSystem.IsWindows()) return;
        using var temporary = new TemporaryDirectory();
        var bin = Path.Combine(temporary.Path, "bin");
        Directory.CreateDirectory(bin);
        var env = Path.Combine(bin, "env");
        var bash = Path.Combine(bin, "bash");
        var stripped = Path.Combine(temporary.Path, "stripped-fixture.sh");
        var bareShebang = Path.Combine(temporary.Path, "bare-shebang.sh");
        var executableShebang = Path.Combine(temporary.Path, "executable-shebang.sh");
        var noShebang = Path.Combine(temporary.Path, "no-shebang.sh");
        var diskFree = Path.Combine(bin, "df");
        var unrelatedMountPoint = Path.Combine(temporary.Path, "unrelated-mount-point");
        Directory.CreateDirectory(unrelatedMountPoint);
        File.WriteAllText(env, "fixture env\n");
        File.WriteAllText(bash, "fixture bash\n");
        File.WriteAllText(stripped, $"#!{env} bash\nprintf 'fixture'\n");
        File.WriteAllText(bareShebang, "#!bash\nprintf 'fixture'\n");
        File.WriteAllText(executableShebang, "#!/bin/sh\nprintf 'fixture'\n");
        File.WriteAllText(noShebang, "fixture without a shebang\n");
        File.WriteAllText(
            diskFree,
            "#!/bin/sh\nprintf '%s\\n' 'Filesystem 512-blocks Used Available Capacity Mounted on' "
                + $"'/dev/fixture 10 1 9 10% {temporary.Path}' "
                + $"'/dev/unrelated 10 1 9 10% {unrelatedMountPoint}'\n");
        foreach (var path in new[] { env, bash, stripped, bareShebang, executableShebang, noShebang })
        {
            File.SetUnixFileMode(
                path,
                UnixFileMode.UserRead | UnixFileMode.UserWrite);
        }
        File.SetUnixFileMode(
            diskFree,
            UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.UserExecute);
        var result = new ProcessOutput(
            126,
            Encoding.UTF8.GetBytes("complete stdout\n"),
            Encoding.UTF8.GetBytes("complete stderr\n"));

        var diagnostic = BuildProcessFailureDiagnostic(
            "env",
            ["FLAG=value with spaces", stripped],
            temporary.Path,
            result,
            [
                new ExecutableFixture("synthetic-stripped", stripped),
                new ExecutableFixture("bare-command", bareShebang),
                new ExecutableFixture("resolved-command", executableShebang),
                new ExecutableFixture("no-shebang", noShebang),
            ],
            bin,
            diskFreeCommand: diskFree);

        Assert.Contains("command_line=env 'FLAG=value with spaces'", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"working_directory={temporary.Path}", diagnostic, StringComparison.Ordinal);
        Assert.Contains("exit_code=126", diagnostic, StringComparison.Ordinal);
        Assert.Contains("stdout:\ncomplete stdout\n", diagnostic, StringComparison.Ordinal);
        Assert.Contains("stderr:\ncomplete stderr\n", diagnostic, StringComparison.Ordinal);
        Assert.Matches(
            "process_identity:\\n  real_uid=[0-9]+\\n  effective_uid=[0-9]+\\n"
                + "  real_gid=[0-9]+\\n  effective_gid=[0-9]+\\n",
            diagnostic);
        Assert.Contains(
            $"filesystem_capture_for_temp_root={temporary.Path}\n",
            diagnostic,
            StringComparison.Ordinal);
        Assert.Contains($"df_command={diskFree}\n", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"df_arguments=-P {temporary.Path}\n", diagnostic, StringComparison.Ordinal);
        Assert.Contains("df_exit_code=0\ndf_stdout:\n", diagnostic, StringComparison.Ordinal);
        Assert.DoesNotContain(unrelatedMountPoint, diagnostic, StringComparison.Ordinal);
        Assert.Contains("pre_launch_executable_snapshots:\n", diagnostic, StringComparison.Ordinal);
        Assert.Contains("post_exit_executable_snapshots:\n", diagnostic, StringComparison.Ordinal);
        Assert.Contains("[synthetic-stripped]", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"path={stripped}", diagnostic, StringComparison.Ordinal);
        Assert.Contains("exists=true", diagnostic, StringComparison.Ordinal);
        Assert.Contains("unix_mode=0600", diagnostic, StringComparison.Ordinal);
        var temporaryMode = Convert.ToString(
            (int)File.GetUnixFileMode(temporary.Path),
            8).PadLeft(3, '0');
        Assert.Contains(
            $"ancestor_directory_path={temporary.Path}\n"
                + $"    exists=true\n    unix_mode=0{temporaryMode}\n",
            diagnostic,
            StringComparison.Ordinal);
        Assert.Contains($"size={new FileInfo(stripped).Length}", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"first_line=#!{env} bash", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"shebang_interpreter={env}", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"shebang_interpreter_path={env}", diagnostic, StringComparison.Ordinal);
        Assert.Contains("shebang_interpreter_exists=true", diagnostic, StringComparison.Ordinal);
        Assert.Contains("shebang_interpreter_unix_mode=0600", diagnostic, StringComparison.Ordinal);
        Assert.Contains(
            "shebang_interpreter_effective_user_can_execute=false",
            diagnostic,
            StringComparison.Ordinal);
        Assert.Contains("shebang_env_target=bash", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"shebang_env_target_path={bash}", diagnostic, StringComparison.Ordinal);
        Assert.Contains("shebang_env_target_exists=true", diagnostic, StringComparison.Ordinal);
        Assert.Contains("shebang_env_target_unix_mode=0600", diagnostic, StringComparison.Ordinal);
        Assert.Contains(
            "shebang_env_target_effective_user_can_execute=false",
            diagnostic,
            StringComparison.Ordinal);
        Assert.Matches(
            "\\[synthetic-stripped\\][\\s\\S]*?"
                + "shebang_resolution_outcome=resolved-not-executable\\n",
            diagnostic);
        Assert.Contains(
            "shebang_resolution_alphabet="
                + "resolved-executable|resolved-not-executable|not-found|no-shebang",
            diagnostic,
            StringComparison.Ordinal);
        Assert.Contains(
            $"[bare-command]\n  path={bareShebang}",
            diagnostic,
            StringComparison.Ordinal);
        Assert.Matches(
            "\\[bare-command\\][\\s\\S]*?shebang_interpreter=bash\\n"
                + "  shebang_interpreter_path=<unresolved>\\n[\\s\\S]*?"
                + "shebang_resolution_outcome=not-found\\n",
            diagnostic);
        Assert.Matches(
            "\\[resolved-command\\][\\s\\S]*?shebang_interpreter=/bin/sh\\n"
                + "[\\s\\S]*?shebang_resolution_outcome=resolved-executable\\n",
            diagnostic);
        Assert.Matches(
            "\\[no-shebang\\][\\s\\S]*?shebang_interpreter=<none>\\n"
                + "[\\s\\S]*?shebang_resolution_outcome=no-shebang\\n",
            diagnostic);
        Assert.DoesNotContain("shebang_interpreter_resolves=", diagnostic, StringComparison.Ordinal);
        Assert.Contains("same_directory_exec_probes:\n", diagnostic, StringComparison.Ordinal);
        Assert.Contains("[synthetic-stripped]\n", diagnostic, StringComparison.Ordinal);
        Assert.Contains(
            $"  directory={temporary.Path}\n  write_succeeded=true\n"
                + "  chmod_succeeded=true\n  exit_code=0\n",
            diagnostic,
            StringComparison.Ordinal);

        var successfulRun = RunWithFailureDiagnostics(
            "/usr/bin/true",
            [],
            temporary.Path,
            [new ExecutableFixture("synthetic-stripped", stripped)],
            bin,
            temporary.Path);
        Assert.Equal(0, successfulRun.Result.ExitCode);
        Assert.Null(successfulRun.Diagnostic);
    }

    private static string BuildProcessFailureDiagnostic(
        string fileName,
        IReadOnlyList<string> arguments,
        string workingDirectory,
        ProcessOutput result,
        IReadOnlyList<ExecutableFixture> executables,
        string searchPath,
        IReadOnlyList<string>? preLaunchSnapshots = null,
        string? temporaryRoot = null,
        string? diskFreeCommand = null)
    {
        temporaryRoot ??= workingDirectory;
        preLaunchSnapshots ??= CaptureExecutableSnapshots(
            executables,
            temporaryRoot,
            workingDirectory,
            searchPath);
        var diagnostic = new StringBuilder();
        diagnostic.Append("command_line=").Append(QuoteCommandArgument(fileName));
        foreach (var argument in arguments)
        {
            diagnostic.Append(' ').Append(QuoteCommandArgument(argument));
        }

        diagnostic.AppendLine();
        diagnostic.Append("working_directory=").AppendLine(workingDirectory);
        diagnostic.Append("exit_code=").AppendLine(result.ExitCode.ToString());
        AppendCompleteStream(diagnostic, "stdout", result.StandardOutput);
        AppendCompleteStream(diagnostic, "stderr", result.StandardError);
        AppendProcessIdentity(diagnostic);
        AppendFilesystemCapture(diagnostic, temporaryRoot, workingDirectory, diskFreeCommand);
        diagnostic.AppendLine(
            "shebang_resolution_alphabet="
                + "resolved-executable|resolved-not-executable|not-found|no-shebang");
        AppendSnapshotSet(diagnostic, "pre_launch_executable_snapshots", preLaunchSnapshots);
        var postExitSnapshots = CaptureExecutableSnapshots(
            executables,
            temporaryRoot,
            workingDirectory,
            searchPath);
        AppendSnapshotSet(diagnostic, "post_exit_executable_snapshots", postExitSnapshots);
        AppendSameDirectoryExecProbes(diagnostic, executables);

        return diagnostic.ToString();
    }

    private static DiagnosticRun RunWithFailureDiagnostics(
        string fileName,
        IReadOnlyList<string> arguments,
        string workingDirectory,
        IReadOnlyList<ExecutableFixture> executables,
        string searchPath,
        string temporaryRoot)
    {
        var preLaunchSnapshots = CaptureExecutableSnapshots(
            executables,
            temporaryRoot,
            workingDirectory,
            searchPath);
        var result = TestProcessRunner.Run(
            fileName,
            arguments,
            workingDirectory,
            TestBudgets.WorkflowProcessHangGuard,
            int.MaxValue);
        var diagnostic = result.ExitCode == 0
            ? null
            : BuildProcessFailureDiagnostic(
                fileName,
                arguments,
                workingDirectory,
                result,
                executables,
                searchPath,
                preLaunchSnapshots,
                temporaryRoot);
        return new DiagnosticRun(result, diagnostic);
    }

    private static ExecutableFixture[] ExecutableFixtures(CacheWorld world) =>
    [
        new("pair-entrypoint", world.PairScript),
        new("stub-supervisor", world.Supervisor),
        new("stub-producer", world.Producer),
        new("cache-ensure-sidecar", world.CacheEnsureSidecar),
        new("copied-report-input", world.ReportInput),
        new("copied-lean-cache-input-library", world.LeanCacheInputLibrary),
        new("stub-copy-wrapper", world.CopyWrapper),
    ];

    private static void AppendCompleteStream(
        StringBuilder diagnostic,
        string name,
        byte[] bytes)
    {
        diagnostic.Append(name).AppendLine(":");
        var text = Encoding.UTF8.GetString(bytes);
        diagnostic.Append(text);
        if (!text.EndsWith('\n')) diagnostic.AppendLine();
    }

    private static IReadOnlyList<string> CaptureExecutableSnapshots(
        IReadOnlyList<ExecutableFixture> executables,
        string temporaryRoot,
        string workingDirectory,
        string searchPath)
    {
        var snapshots = new List<string>(executables.Count);
        foreach (var executable in executables)
        {
            var snapshot = new StringBuilder();
            AppendExecutableSnapshot(
                snapshot,
                executable,
                temporaryRoot,
                workingDirectory,
                searchPath);
            snapshots.Add(snapshot.ToString());
        }

        return snapshots;
    }

    private static void AppendSnapshotSet(
        StringBuilder diagnostic,
        string name,
        IReadOnlyList<string> snapshots)
    {
        diagnostic.Append(name).AppendLine(":");
        foreach (var snapshot in snapshots) diagnostic.Append(snapshot);
    }

    private static void AppendExecutableSnapshot(
        StringBuilder diagnostic,
        ExecutableFixture executable,
        string temporaryRoot,
        string workingDirectory,
        string searchPath)
    {
        diagnostic.Append('[').Append(executable.Name).AppendLine("]");
        diagnostic.Append("  path=").AppendLine(executable.Path);
        var exists = File.Exists(executable.Path);
        diagnostic.Append("  exists=").AppendLine(exists ? "true" : "false");

        string? firstLine = null;
        if (exists)
        {
            AppendUnixMode(diagnostic, executable.Path);
            diagnostic.Append("  effective_user_can_execute=")
                .AppendLine(EffectiveUserCanExecute(executable.Path));
            AppendFileSize(diagnostic, executable.Path);
            firstLine = ReadFirstLine(diagnostic, executable.Path);
        }
        else
        {
            diagnostic.AppendLine("  unix_mode=<unavailable: file missing>");
            diagnostic.AppendLine("  effective_user_can_execute=false");
            diagnostic.AppendLine("  size=<unavailable: file missing>");
            diagnostic.AppendLine("  first_line=<unavailable: file missing>");
        }

        AppendAncestorDirectories(diagnostic, temporaryRoot, executable.Path);
        AppendShebangResolution(
            diagnostic,
            firstLine,
            workingDirectory,
            searchPath);
    }

    private static void AppendUnixMode(StringBuilder diagnostic, string path)
    {
        diagnostic.Append("  unix_mode=").AppendLine(UnixMode(path));
    }

    private static void AppendFileSize(StringBuilder diagnostic, string path)
    {
        try
        {
            diagnostic.Append("  size=").AppendLine(new FileInfo(path).Length.ToString());
        }
        catch (Exception exception) when (IsSnapshotException(exception))
        {
            diagnostic.Append("  size=<error: ")
                .Append(EscapeLine(exception.Message))
                .AppendLine(">");
        }
    }

    private static string? ReadFirstLine(StringBuilder diagnostic, string path)
    {
        try
        {
            var firstLine = File.ReadLines(path).FirstOrDefault();
            diagnostic.Append("  first_line=")
                .AppendLine(firstLine is null ? "<empty>" : EscapeLine(firstLine));
            return firstLine;
        }
        catch (Exception exception) when (IsSnapshotException(exception))
        {
            diagnostic.Append("  first_line=<error: ")
                .Append(EscapeLine(exception.Message))
                .AppendLine(">");
            return null;
        }
    }

    private static void AppendShebangResolution(
        StringBuilder diagnostic,
        string? firstLine,
        string workingDirectory,
        string searchPath)
    {
        if (firstLine is null || !firstLine.StartsWith("#!", StringComparison.Ordinal))
        {
            diagnostic.AppendLine("  shebang_interpreter=<none>");
            diagnostic.AppendLine("  shebang_interpreter_path=<not-applicable>");
            diagnostic.AppendLine("  shebang_interpreter_exists=false");
            diagnostic.AppendLine("  shebang_interpreter_unix_mode=<not-applicable>");
            diagnostic.AppendLine(
                "  shebang_interpreter_effective_user_can_execute=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_path=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_exists=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_unix_mode=<not-applicable>");
            diagnostic.AppendLine(
                "  shebang_env_target_effective_user_can_execute=<not-applicable>");
            diagnostic.AppendLine("  shebang_resolution_outcome=no-shebang");
            return;
        }

        var tokens = firstLine[2..].Split(
            (char[]?)null,
            StringSplitOptions.RemoveEmptyEntries);
        if (tokens.Length == 0)
        {
            diagnostic.AppendLine("  shebang_interpreter=<missing>");
            diagnostic.AppendLine("  shebang_interpreter_path=<unresolved>");
            diagnostic.AppendLine("  shebang_interpreter_exists=false");
            diagnostic.AppendLine("  shebang_interpreter_unix_mode=<unavailable: not-found>");
            diagnostic.AppendLine("  shebang_interpreter_effective_user_can_execute=false");
            diagnostic.AppendLine("  shebang_env_target=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_path=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_exists=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_unix_mode=<not-applicable>");
            diagnostic.AppendLine(
                "  shebang_env_target_effective_user_can_execute=<not-applicable>");
            diagnostic.AppendLine("  shebang_resolution_outcome=not-found");
            return;
        }

        var interpreter = ResolveShebangInterpreter(tokens[0], workingDirectory, searchPath);
        AppendResolvedCommand(diagnostic, "shebang_interpreter", interpreter);

        if (interpreter.Path is null || !string.Equals(
                Path.GetFileName(interpreter.Path),
                "env",
                StringComparison.Ordinal))
        {
            diagnostic.AppendLine("  shebang_env_target=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_path=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_exists=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_unix_mode=<not-applicable>");
            diagnostic.AppendLine(
                "  shebang_env_target_effective_user_can_execute=<not-applicable>");
            diagnostic.Append("  shebang_resolution_outcome=")
                .AppendLine(ResolutionOutcome(interpreter));
            return;
        }

        var envTarget = FindEnvTarget(tokens);
        var resolvedEnvTarget = envTarget is null
            ? ResolvedCommand.NotFound("<missing>")
            : ResolveCommand(envTarget, workingDirectory, searchPath);
        AppendResolvedCommand(diagnostic, "shebang_env_target", resolvedEnvTarget);
        diagnostic.Append("  shebang_resolution_outcome=").AppendLine(
            ResolutionOutcome(interpreter, resolvedEnvTarget));
    }

    private static ResolvedCommand ResolveShebangInterpreter(
        string command,
        string workingDirectory,
        string searchPath)
    {
        if (!command.Contains(Path.DirectorySeparatorChar)
            && !command.Contains(Path.AltDirectorySeparatorChar))
        {
            // The kernel opens a shebang interpreter pathname literally; it does not
            // perform PATH search. Only an invoked env interpreter searches its target.
            return ResolvedCommand.NotFound(command);
        }

        return ResolveCommand(command, workingDirectory, searchPath);
    }

    private static string? FindEnvTarget(IReadOnlyList<string> tokens)
    {
        for (var index = 1; index < tokens.Count; index++)
        {
            var token = tokens[index];
            if (token is "-S" or "--split-string") continue;
            if (token.StartsWith('-')) continue;
            if (token.Contains('=')) continue;
            return token;
        }

        return null;
    }

    private static ResolvedCommand ResolveCommand(
        string command,
        string workingDirectory,
        string searchPath)
    {
        if (command.Contains(Path.DirectorySeparatorChar)
            || command.Contains(Path.AltDirectorySeparatorChar))
        {
            var candidate = Path.IsPathRooted(command)
                ? Path.GetFullPath(command)
                : Path.GetFullPath(command, workingDirectory);
            return ResolvedCommand.FromPath(command, candidate);
        }

        foreach (var directory in searchPath.Split(Path.PathSeparator))
        {
            var pathEntry = directory.Length == 0 ? workingDirectory : directory;
            var absoluteDirectory = Path.IsPathRooted(pathEntry)
                ? pathEntry
                : Path.GetFullPath(pathEntry, workingDirectory);
            var candidate = Path.GetFullPath(Path.Combine(absoluteDirectory, command));
            if (File.Exists(candidate)) return ResolvedCommand.FromPath(command, candidate);
        }

        return ResolvedCommand.NotFound(command);
    }

    private static void AppendResolvedCommand(
        StringBuilder diagnostic,
        string field,
        ResolvedCommand command)
    {
        diagnostic.Append("  ").Append(field).Append('=').AppendLine(command.Token);
        diagnostic.Append("  ").Append(field).Append("_path=")
            .AppendLine(command.Path ?? "<unresolved>");
        diagnostic.Append("  ").Append(field).Append("_exists=")
            .AppendLine(command.Exists ? "true" : "false");
        diagnostic.Append("  ").Append(field).Append("_unix_mode=")
            .AppendLine(command.Exists ? UnixMode(command.Path!) : "<unavailable: not-found>");
        diagnostic.Append("  ").Append(field).Append("_effective_user_can_execute=")
            .AppendLine(command.EffectiveExecuteAccess);
    }

    private static string ResolutionOutcome(params ResolvedCommand[] commands)
    {
        if (commands.Any(static command => !command.Exists)) return "not-found";
        return commands.All(static command => command.EffectiveExecuteAccess == "true")
            ? "resolved-executable"
            : "resolved-not-executable";
    }

    private static void AppendAncestorDirectories(
        StringBuilder diagnostic,
        string temporaryRoot,
        string executablePath)
    {
        diagnostic.AppendLine("  ancestor_directories:");
        var root = Path.GetFullPath(temporaryRoot);
        var parent = Path.GetDirectoryName(Path.GetFullPath(executablePath));
        if (parent is null)
        {
            diagnostic.AppendLine("    <unavailable: executable has no parent>");
            return;
        }

        var relative = Path.GetRelativePath(root, parent);
        if (IsOutsideRoot(relative))
        {
            diagnostic.Append("    <outside-temp-root: ").Append(parent).AppendLine(">");
            return;
        }

        AppendAncestorDirectory(diagnostic, root);
        if (relative == ".") return;
        var current = root;
        foreach (var component in relative.Split(
                     [Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar],
                     StringSplitOptions.RemoveEmptyEntries))
        {
            current = Path.Combine(current, component);
            AppendAncestorDirectory(diagnostic, current);
        }
    }

    private static void AppendAncestorDirectory(StringBuilder diagnostic, string path)
    {
        var exists = Directory.Exists(path);
        diagnostic.Append("    ancestor_directory_path=").AppendLine(path);
        diagnostic.Append("    exists=").AppendLine(exists ? "true" : "false");
        diagnostic.Append("    unix_mode=")
            .AppendLine(exists ? UnixMode(path) : "<unavailable: directory missing>");
    }

    private static bool IsOutsideRoot(string relative) =>
        relative == ".."
        || relative.StartsWith($"..{Path.DirectorySeparatorChar}", StringComparison.Ordinal)
        || relative.StartsWith($"..{Path.AltDirectorySeparatorChar}", StringComparison.Ordinal);

    private static string UnixMode(string path)
    {
        if (OperatingSystem.IsWindows()) return "<unsupported on Windows>";
        try
        {
            var mode = File.GetUnixFileMode(path);
            return "0" + Convert.ToString((int)mode, 8).PadLeft(3, '0');
        }
        catch (Exception exception) when (IsSnapshotException(exception))
        {
            return $"<error: {EscapeLine(exception.Message)}>";
        }
    }

    private static string EffectiveUserCanExecute(string path)
    {
        if (OperatingSystem.IsWindows()) return "<unsupported on Windows>";
        try
        {
            var directory = OperatingSystem.IsMacOS() ? DarwinAtCurrentWorkingDirectory : LinuxAtCurrentWorkingDirectory;
            var flags = OperatingSystem.IsMacOS() ? DarwinAtEffectiveAccess : LinuxAtEffectiveAccess;
            return FileAccessAt(directory, path, ExecuteAccess, flags) == 0 ? "true" : "false";
        }
        catch (Exception exception) when (exception is DllNotFoundException or EntryPointNotFoundException)
        {
            return $"<unavailable: {EscapeLine(exception.Message)}>";
        }
    }

    private static void AppendProcessIdentity(StringBuilder diagnostic)
    {
        diagnostic.AppendLine("process_identity:");
        if (OperatingSystem.IsWindows())
        {
            diagnostic.AppendLine("  real_uid=<unsupported on Windows>");
            diagnostic.AppendLine("  effective_uid=<unsupported on Windows>");
            diagnostic.AppendLine("  real_gid=<unsupported on Windows>");
            diagnostic.AppendLine("  effective_gid=<unsupported on Windows>");
            return;
        }

        diagnostic.Append("  real_uid=").AppendLine(GetRealUserId().ToString());
        diagnostic.Append("  effective_uid=").AppendLine(GetEffectiveUserId().ToString());
        diagnostic.Append("  real_gid=").AppendLine(GetRealGroupId().ToString());
        diagnostic.Append("  effective_gid=").AppendLine(GetEffectiveGroupId().ToString());
    }

    private static void AppendSameDirectoryExecProbes(
        StringBuilder diagnostic,
        IReadOnlyList<ExecutableFixture> executables)
    {
        diagnostic.AppendLine("same_directory_exec_probes:");
        foreach (var executable in executables)
        {
            AppendSameDirectoryExecProbe(diagnostic, executable);
        }
    }

    private static void AppendSameDirectoryExecProbe(
        StringBuilder diagnostic,
        ExecutableFixture executable)
    {
        diagnostic.Append('[').Append(executable.Name).AppendLine("]");
        var directory = Path.GetDirectoryName(executable.Path) ?? ".";
        diagnostic.Append("  directory=").AppendLine(directory);
        if (OperatingSystem.IsWindows())
        {
            diagnostic.AppendLine("  write_succeeded=<unsupported on Windows>");
            diagnostic.AppendLine("  chmod_succeeded=<unsupported on Windows>");
            diagnostic.AppendLine("  exit_code=<unsupported on Windows>");
            return;
        }

        var probePath = Path.Combine(directory, $".stratalint-exec-probe-{Guid.NewGuid():N}.sh");
        var writeSucceeded = false;
        var chmodSucceeded = false;
        ProcessOutput? result = null;
        string? error = null;
        var deleteSucceeded = false;
        try
        {
            File.WriteAllText(probePath, "#!/bin/sh\nexit 0\n", new UTF8Encoding(false));
            writeSucceeded = true;
            File.SetUnixFileMode(
                probePath,
                UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.UserExecute);
            chmodSucceeded = true;
            result = TestProcessRunner.Run(
                probePath,
                [],
                directory,
                TestBudgets.WorkflowProcessHangGuard,
                int.MaxValue);
        }
        catch (Exception exception) when (
            IsSnapshotException(exception) || IsDiagnosticProcessException(exception))
        {
            error = EscapeLine(exception.Message);
        }
        finally
        {
            try
            {
                File.Delete(probePath);
                deleteSucceeded = !File.Exists(probePath);
            }
            catch (Exception exception) when (IsSnapshotException(exception))
            {
                error = error is null
                    ? $"cleanup: {EscapeLine(exception.Message)}"
                    : $"{error}; cleanup: {EscapeLine(exception.Message)}";
            }
        }

        diagnostic.Append("  write_succeeded=").AppendLine(writeSucceeded ? "true" : "false");
        diagnostic.Append("  chmod_succeeded=").AppendLine(chmodSucceeded ? "true" : "false");
        diagnostic.Append("  exit_code=")
            .AppendLine(result?.ExitCode.ToString() ?? $"<not-run: {error ?? "unknown error"}>");
        diagnostic.Append("  probe_path=").AppendLine(probePath);
        diagnostic.Append("  delete_succeeded=").AppendLine(deleteSucceeded ? "true" : "false");
        AppendCompleteStream(diagnostic, "  stdout", result?.StandardOutput ?? []);
        AppendCompleteStream(diagnostic, "  stderr", result?.StandardError ?? []);
    }

    private static string QuoteCommandArgument(string argument)
    {
        if (argument.Length > 0 && argument.All(IsSafeCommandCharacter)) return argument;
        return "'" + argument.Replace("'", "'\"'\"'", StringComparison.Ordinal) + "'";
    }

    private static bool IsSafeCommandCharacter(char value) =>
        char.IsAsciiLetterOrDigit(value) || value is '_' or '@' or '%' or '+' or '='
            or ':' or ',' or '.' or '/' or '-';

    private static string EscapeLine(string value) => value
        .Replace("\\", "\\\\", StringComparison.Ordinal)
        .Replace("\r", "\\r", StringComparison.Ordinal)
        .Replace("\n", "\\n", StringComparison.Ordinal);

    private static bool IsSnapshotException(Exception exception) =>
        exception is IOException
            or UnauthorizedAccessException
            or ArgumentException
            or NotSupportedException;

    private static bool IsDiagnosticProcessException(Exception exception) =>
        exception is Win32Exception
            or InvalidOperationException
            or IOException
            or UnauthorizedAccessException
            or NotSupportedException
            or TimeoutException;

    private const int ExecuteAccess = 1;
    private const int LinuxAtCurrentWorkingDirectory = -100;
    private const int LinuxAtEffectiveAccess = 0x200;
    private const int DarwinAtCurrentWorkingDirectory = -2;
    private const int DarwinAtEffectiveAccess = 0x10;

    [DllImport("libc", EntryPoint = "getuid")]
    private static extern uint GetRealUserId();

    [DllImport("libc", EntryPoint = "geteuid")]
    private static extern uint GetEffectiveUserId();

    [DllImport("libc", EntryPoint = "getgid")]
    private static extern uint GetRealGroupId();

    [DllImport("libc", EntryPoint = "getegid")]
    private static extern uint GetEffectiveGroupId();

    [DllImport("libc", EntryPoint = "faccessat", SetLastError = true)]
    private static extern int FileAccessAt(
        int directoryFileDescriptor,
        [MarshalAs(UnmanagedType.LPUTF8Str)] string path,
        int mode,
        int flags);

    private readonly record struct ExecutableFixture(string Name, string Path);

    private readonly record struct DiagnosticRun(ProcessOutput Result, string? Diagnostic);

    private readonly record struct ResolvedCommand(
        string Token,
        string? Path,
        bool Exists,
        string EffectiveExecuteAccess)
    {
        internal static ResolvedCommand FromPath(string token, string path) =>
            File.Exists(path)
                ? new(token, path, true, LeanReportCacheTests.EffectiveUserCanExecute(path))
                : new(token, path, false, "false");

        internal static ResolvedCommand NotFound(string token) => new(token, null, false, "false");
    }
}
