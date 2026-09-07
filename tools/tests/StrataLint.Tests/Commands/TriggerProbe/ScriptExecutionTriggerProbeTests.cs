using System.Diagnostics;

namespace StrataLint.Tests;

/// <summary>
/// ①′ 触发载荷(器律⑦″,用户 2026-09-07 定)。**本文件不进任何分支**:它存在的唯一目的,
/// 是让 <c>NoTestReachesRepositoryShellScriptThroughTestSupportHelperOrExecutesMakeTarget</c>
/// 在真实 pull_request_target 事件上**判红**,以证明该禁令确实执法,而不只是"长得像执法"。
/// 验完即关闭不合。
/// </summary>
public sealed class ScriptExecutionTriggerProbeTests
{
    [Fact]
    public void ExecutesARepositoryShellScript()
    {
        var startInfo = new ProcessStartInfo("/bin/bash")
        {
            RedirectStandardOutput = true,
        };
        startInfo.ArgumentList.Add("tools/scripts/workflow/playbook-workflows.sh");
        startInfo.ArgumentList.Add("--help");
        using var process = Process.Start(startInfo);
        Assert.NotNull(process);
    }
}
