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
        File.WriteAllText(env, "fixture env\n");
        File.WriteAllText(bash, "fixture bash\n");
        File.WriteAllText(stripped, $"#!{env} bash\nprintf 'fixture'\n");
        File.SetUnixFileMode(
            stripped,
            UnixFileMode.UserRead | UnixFileMode.UserWrite);
        var result = new ProcessOutput(
            126,
            Encoding.UTF8.GetBytes("complete stdout\n"),
            Encoding.UTF8.GetBytes("complete stderr\n"));

        var diagnostic = BuildProcessFailureDiagnostic(
            "env",
            ["FLAG=value with spaces", stripped],
            temporary.Path,
            result,
            [new ExecutableFixture("synthetic-stripped", stripped)],
            bin);

        Assert.Contains("command_line=env 'FLAG=value with spaces'", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"working_directory={temporary.Path}", diagnostic, StringComparison.Ordinal);
        Assert.Contains("exit_code=126", diagnostic, StringComparison.Ordinal);
        Assert.Contains("stdout:\ncomplete stdout\n", diagnostic, StringComparison.Ordinal);
        Assert.Contains("stderr:\ncomplete stderr\n", diagnostic, StringComparison.Ordinal);
        Assert.Contains("[synthetic-stripped]", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"path={stripped}", diagnostic, StringComparison.Ordinal);
        Assert.Contains("exists=true", diagnostic, StringComparison.Ordinal);
        Assert.Contains("unix_mode=0600", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"size={new FileInfo(stripped).Length}", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"first_line=#!{env} bash", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"shebang_interpreter={env}", diagnostic, StringComparison.Ordinal);
        Assert.Contains("shebang_interpreter_exists=true", diagnostic, StringComparison.Ordinal);
        Assert.Contains("shebang_env_target=bash", diagnostic, StringComparison.Ordinal);
        Assert.Contains($"shebang_env_target_path={bash}", diagnostic, StringComparison.Ordinal);
        Assert.Contains("shebang_interpreter_resolves=true", diagnostic, StringComparison.Ordinal);
    }

    private static string BuildProcessFailureDiagnostic(
        string fileName,
        IReadOnlyList<string> arguments,
        string workingDirectory,
        ProcessOutput result,
        IReadOnlyList<ExecutableFixture> executables,
        string searchPath)
    {
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
        diagnostic.AppendLine("executable_snapshots:");
        foreach (var executable in executables)
        {
            AppendExecutableSnapshot(diagnostic, executable, workingDirectory, searchPath);
        }

        return diagnostic.ToString();
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

    private static void AppendExecutableSnapshot(
        StringBuilder diagnostic,
        ExecutableFixture executable,
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
            AppendFileSize(diagnostic, executable.Path);
            firstLine = ReadFirstLine(diagnostic, executable.Path);
        }
        else
        {
            diagnostic.AppendLine("  unix_mode=<unavailable: file missing>");
            diagnostic.AppendLine("  size=<unavailable: file missing>");
            diagnostic.AppendLine("  first_line=<unavailable: file missing>");
        }

        AppendShebangResolution(
            diagnostic,
            firstLine,
            workingDirectory,
            searchPath);
    }

    private static void AppendUnixMode(StringBuilder diagnostic, string path)
    {
        if (OperatingSystem.IsWindows())
        {
            diagnostic.AppendLine("  unix_mode=<unsupported on Windows>");
            return;
        }

        try
        {
            var mode = File.GetUnixFileMode(path);
            var octal = Convert.ToString((int)mode, 8).PadLeft(3, '0');
            diagnostic.Append("  unix_mode=0").AppendLine(octal);
        }
        catch (Exception exception) when (IsSnapshotException(exception))
        {
            diagnostic.Append("  unix_mode=<error: ")
                .Append(EscapeLine(exception.Message))
                .AppendLine(">");
        }
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
            diagnostic.AppendLine("  shebang_interpreter_exists=false");
            diagnostic.AppendLine("  shebang_env_target=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_path=<not-applicable>");
            diagnostic.AppendLine("  shebang_interpreter_resolves=false");
            return;
        }

        var tokens = firstLine[2..].Split(
            (char[]?)null,
            StringSplitOptions.RemoveEmptyEntries);
        if (tokens.Length == 0)
        {
            diagnostic.AppendLine("  shebang_interpreter=<missing>");
            diagnostic.AppendLine("  shebang_interpreter_exists=false");
            diagnostic.AppendLine("  shebang_env_target=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_path=<not-applicable>");
            diagnostic.AppendLine("  shebang_interpreter_resolves=false");
            return;
        }

        var interpreter = tokens[0];
        var interpreterExists = File.Exists(interpreter);
        diagnostic.Append("  shebang_interpreter=").AppendLine(interpreter);
        diagnostic.Append("  shebang_interpreter_exists=")
            .AppendLine(interpreterExists ? "true" : "false");

        if (!string.Equals(Path.GetFileName(interpreter), "env", StringComparison.Ordinal))
        {
            diagnostic.AppendLine("  shebang_env_target=<not-applicable>");
            diagnostic.AppendLine("  shebang_env_target_path=<not-applicable>");
            diagnostic.Append("  shebang_interpreter_resolves=")
                .AppendLine(interpreterExists ? "true" : "false");
            return;
        }

        var envTarget = FindEnvTarget(tokens);
        var envTargetPath = envTarget is null
            ? null
            : ResolveEnvTarget(envTarget, workingDirectory, searchPath);
        diagnostic.Append("  shebang_env_target=")
            .AppendLine(envTarget ?? "<missing>");
        diagnostic.Append("  shebang_env_target_path=")
            .AppendLine(envTargetPath ?? "<unresolved>");
        diagnostic.Append("  shebang_interpreter_resolves=")
            .AppendLine(interpreterExists && envTargetPath is not null ? "true" : "false");
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

    private static string? ResolveEnvTarget(
        string target,
        string workingDirectory,
        string searchPath)
    {
        if (target.Contains(Path.DirectorySeparatorChar)
            || target.Contains(Path.AltDirectorySeparatorChar))
        {
            var candidate = Path.IsPathRooted(target)
                ? target
                : Path.GetFullPath(target, workingDirectory);
            return File.Exists(candidate) ? candidate : null;
        }

        foreach (var directory in searchPath.Split(Path.PathSeparator))
        {
            if (directory.Length == 0) continue;
            var candidate = Path.Combine(directory, target);
            if (File.Exists(candidate)) return candidate;
        }

        return null;
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

    private readonly record struct ExecutableFixture(string Name, string Path);
}
