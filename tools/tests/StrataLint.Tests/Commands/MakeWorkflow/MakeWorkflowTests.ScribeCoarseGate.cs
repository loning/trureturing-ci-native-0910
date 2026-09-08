using System.Text;
using System.Runtime.Versioning;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed partial class MakeWorkflowTests
{
    [Theory]
    [InlineData("")]
    [InlineData("Blueprint/D5/Probe.md")]
    [InlineData("docs/develop/notes.md")]
    [InlineData("Golden/values-kernels.toml")]
    [UnsupportedOSPlatform("windows")]
    public void CurrentScribeRunsEveryConsistencyCheckWithoutGitOrBase(string changedPath)
    {
        if (OperatingSystem.IsWindows()) return;
        using var temporary = new TemporaryDirectory();
        var root = temporary.Path;
        var script = Path.Combine(root, ScribeContentChecksScriptPath);
        Directory.CreateDirectory(Path.GetDirectoryName(script)!);
        File.Copy(Path.Combine(TestRepositoryLayout.FindRoot(), ScribeContentChecksScriptPath), script);
        if (changedPath.Length > 0)
        {
            var changed = Path.Combine(root, changedPath);
            Directory.CreateDirectory(Path.GetDirectoryName(changed)!);
            File.WriteAllText(changed, "candidate input\n");
        }
        var bin = Path.Combine(root, "bin");
        var log = Path.Combine(root, "calls");
        var report = Path.Combine(root, "report.json");
        var dll = Path.Combine(root, "scribe.dll");
        File.WriteAllText(report, "candidate report");
        File.WriteAllText(dll, "candidate binary");
        WriteExecutable(Path.Combine(bin, "git"), "#!/bin/bash\nexit 93\n");
        WriteExecutable(Path.Combine(bin, "dotnet"), "#!/bin/bash\nprintf '%s\\n' \"$*\" >> \"$SCRIBE_LOG\"\n");
        var result = TestProcessRunner.Run("/bin/bash",
            ["-c", "PATH=\"$1:/usr/bin:/bin\" SCRIBE_LOG=\"$2\" BASE=unavailable exec /bin/bash \"$3\" \"$4\" \"$5\"",
             "scribe", bin, log, script, report, dll], root, BoundedProcessRunner.HangDetectionBudget, 64 * 1024);
        Assert.True(result.ExitCode == 0, Encoding.UTF8.GetString(result.StandardError));
        Assert.Equal(new[]
        {
            $"{dll} projections --check --report {report}",
            $"{dll} describe-report --check",
            $"{dll} markdown-check --report {report}",
        }, File.ReadAllLines(log));
        var rejected = TestProcessRunner.Run("/bin/bash", [script, report, dll, new string('a', 40)],
            root, BoundedProcessRunner.HangDetectionBudget, 64 * 1024);
        Assert.Equal(2, rejected.ExitCode);
        Assert.Equal(3, File.ReadAllLines(log).Length);
    }
}
