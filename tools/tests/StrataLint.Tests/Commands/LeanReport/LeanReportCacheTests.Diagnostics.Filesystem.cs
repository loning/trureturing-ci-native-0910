using System.Text;

namespace StrataLint.Tests;

public sealed partial class LeanReportCacheTests
{
    private static void AppendFilesystemCapture(
        StringBuilder diagnostic,
        string temporaryRoot,
        string workingDirectory,
        string? diskFreeCommand)
    {
        diagnostic.Append("filesystem_capture_for_temp_root=").AppendLine(temporaryRoot);
        diskFreeCommand ??= new[] { "/bin/df", "/usr/bin/df" }.FirstOrDefault(File.Exists);
        diagnostic.Append("df_command=").AppendLine(diskFreeCommand ?? "<not-found>");
        diagnostic.Append("df_arguments=-P ").AppendLine(temporaryRoot);
        if (diskFreeCommand is null)
        {
            diagnostic.AppendLine("df_exit_code=<not-run>");
            diagnostic.AppendLine("df_stdout:");
            diagnostic.AppendLine("<unavailable: df command not found>");
            diagnostic.AppendLine("df_stderr:");
            diagnostic.AppendLine("<unavailable: df command not found>");
            return;
        }

        try
        {
            var result = TestProcessRunner.Run(
                diskFreeCommand,
                ["-P", temporaryRoot],
                workingDirectory,
                TestBudgets.WorkflowProcessHangGuard,
                int.MaxValue);
            diagnostic.Append("df_exit_code=").AppendLine(result.ExitCode.ToString());
            AppendCompleteStream(
                diagnostic,
                "df_stdout",
                NarrowPortableDfOutput(result.StandardOutput));
            AppendCompleteStream(diagnostic, "df_stderr", result.StandardError);
        }
        catch (Exception exception) when (IsDiagnosticProcessException(exception))
        {
            diagnostic.Append("df_exit_code=<error: ")
                .Append(EscapeLine(exception.Message)).AppendLine(">");
            diagnostic.AppendLine("df_stdout:");
            diagnostic.AppendLine("<unavailable>");
            diagnostic.AppendLine("df_stderr:");
            diagnostic.AppendLine("<unavailable>");
        }
    }

    private static byte[] NarrowPortableDfOutput(byte[] output)
    {
        var lines = Encoding.UTF8.GetString(output)
            .Split(['\r', '\n'], StringSplitOptions.RemoveEmptyEntries)
            .Take(2);
        return Encoding.UTF8.GetBytes(string.Join('\n', lines) + "\n");
    }
}
