using StrataLint.Engine;
using StrataLint.EngineeringScope;

namespace StrataLint.ArchitectureTests;

public sealed partial class ScriptTestGateClosureTests
{
    /// <summary>
    /// 判官在依赖偏序下方、引用不到测试程序集,故只能以**名字**指代这几个脚手架类型。
    /// 名字与类型之间因此是一条没有编译器把关的引用 —— PR #5324 正是踩在这里:
    /// 脚手架迁移到另一个程序集后,判官侧的字符串未同步,编译不红,dev 合入后才红。
    ///
    /// 这条断言就是那条引用的机器判据:`typeof` 使类型名成为**编译期**绑定,
    /// 改名或删除该类型即 CS0246;改动判官侧常量则断言红。两侧任一漂移都在 PR 期暴露。
    /// </summary>
    [Fact]
    public void JudgeNamedHelperTypesResolveToDeclaredTypes()
    {
        Assert.Equal(
            ScriptTestInputDeriver.RepositoryLayoutAssemblyName,
            typeof(StrataLint.TestSupport.TestRepositoryLayout).Assembly.GetName().Name);
        Assert.Equal(
            ScriptTestInputDeriver.RepositoryLayoutTypeName,
            typeof(StrataLint.TestSupport.TestRepositoryLayout).Name);
        Assert.Equal(
            ScriptTestInputDeriver.RepositoryRelativePathTypeName,
            typeof(StrataLint.TestSupport.RepositoryRelativePath).Name);
        Assert.Equal(
            ScriptTestInputDeriver.ScriptHarnessScratchTypeName,
            typeof(StrataLint.TestSupport.ScriptHarnessScratch).Name);
        Assert.Equal(
            ScriptTestInputDeriver.ProcessRunnerTypeName,
            typeof(StrataLint.TestSupport.TestProcessRunner).Name);
    }

    private const string ScriptTestsProject =
        "tools/tests/StrataLint.ScriptTests/StrataLint.ScriptTests.csproj";
    private const string PlaybookScript =
        "tools/scripts/workflow/playbook-workflows.sh";
    private const string ScriptTestsSource =
        "tools/tests/StrataLint.ScriptTests/PlaybookWorkflowScriptTests.cs";
    private const string RepositoryRootCall = "TestRepositoryLayout." + "FindRoot()";








    [Fact]
    public void TestSupportRepositoryLayoutFindRootResolvesRepositoryPath()
    {
        const string script = "tools/scripts/workflow/test-support-root-probe.sh";
        var snapshot = ReplaceText(
            CurrentSnapshot(),
            "tools/tests/StrataLint.Tests/TestProcessRunner.cs",
            text => text.Replace(
                "namespace StrataLint.Tests;",
                "namespace StrataLint.TestSupport;",
                StringComparison.Ordinal));
        snapshot = ReplaceText(
            snapshot,
            ScriptTestsSource,
            text => text.Replace(
                "using StrataLint.Engine;",
                "using StrataLint.Engine; using StrataLint.TestSupport;",
                StringComparison.Ordinal));
        snapshot = AppendTestMethod(
            snapshot,
            $$"""

                [Fact]
                public void TestSupportRootProbe()
                {
                    _ = File.ReadAllText(Path.Combine(
                        TestRepositoryLayout.FindRoot(),
                        "{{script}}"));
                }
            """,
            (script, "#!/usr/bin/env bash\nexit 0\n"));

        var closure = Derive(snapshot, []);

        Assert.Contains(script, closure.ExactPaths);
    }

    [Fact]
    public void InstanceTestRepositoryLayoutFindRootFailsClosedByMethodSymbol()
    {
        const string script = "tools/scripts/workflow/instance-root-lookalike.sh";
        var snapshot = AppendTestMethod(
            CurrentSnapshot(),
            $$"""

                [Fact]
                public void InstanceRootLookalikeProbe()
                {
                    _ = File.ReadAllText(Path.Combine(
                        new StrataLint.Lookalike.TestRepositoryLayout().FindRoot(),
                        "{{script}}"));
                }
            """,
            ("tools/tests/StrataLint.ScriptTests/LookalikeRepositoryLayout.cs",
                "namespace StrataLint.Lookalike; public sealed class TestRepositoryLayout "
                + "{ public string FindRoot() => string.Empty; }\n"),
            (script, "#!/usr/bin/env bash\nexit 0\n"));

        var error = Assert.ThrowsAny<Exception>(() => Derive(snapshot, []));

        Assert.Contains("InstanceRootLookalikeProbe", Flatten(error), StringComparison.Ordinal);
        Assert.Contains(
            "unresolved repository-rooted path expression",
            Flatten(error),
            StringComparison.Ordinal);
    }

    [Fact]
    public void ForeignAssemblyTestRepositoryLayoutFindRootFailsClosedByOwnerIdentity()
    {
        const string script = "tools/scripts/workflow/foreign-root-lookalike.sh";
        var snapshot = AppendTestMethod(
            CurrentSnapshot(),
            $$"""

                [Fact]
                public void ForeignRootLookalikeProbe()
                {
                    _ = File.ReadAllText(Path.Combine(
                        StrataLint.Lookalike.TestRepositoryLayout.FindRoot(),
                        "{{script}}"));
                }
            """,
            ("tools/tests/StrataLint.ScriptTests/LookalikeRepositoryLayout.cs",
                "namespace StrataLint.Lookalike; public static class TestRepositoryLayout "
                + "{ public static string FindRoot() => string.Empty; }\n"),
            (script, "#!/usr/bin/env bash\nexit 0\n"));

        var error = Assert.ThrowsAny<Exception>(() => Derive(snapshot, []));

        Assert.Contains("ForeignRootLookalikeProbe", Flatten(error), StringComparison.Ordinal);
        Assert.Contains(
            "unresolved repository-rooted path expression",
            Flatten(error),
            StringComparison.Ordinal);
    }


}
