using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Text.RegularExpressions;

namespace StrataLint.ArchitectureTests;

/// <summary>
/// 永久禁令(用户 2026-08-29、owner 2026-09-07 定,CLAUDE.md 器律⑦′):
/// **不得对 GitHub Actions workflow、仓库 shell 脚本或 make target 写测试。**
///
/// **为什么**:workflow 测试只能校验 workflow 文本**长什么样**,校验不了它**会不会执行**,
/// 故它给出的绿是假绿。本仓两条实测判例:
/// ① 给 `Strip checkout remote state` 加一行 `if: false`,四处覆盖 + 11 条契约 + YAML
///    结构派生的整套机器,**16 个测试全过**(`compile_errors=0`);
/// ② PR #2337 改 workflow,本地 `make preflight` 退出 0 被当成预证绿,合入后连挖五条缺陷,
///    其中 `filemap-conform` 依赖进程 CWD 那条**只能由真跑暴露**。
/// 唯一有效的 workflow、脚本与 make target 验证是让它在真实管线里跑一次
/// (CLAUDE.md 器律⑦),那是 CI 的活,不是单元测试的活。形状测试付的是每次改动的税,
/// 买到的是零信息。2026-09-07 同族测试一天内三次阻塞无关 PR:#4873
/// (`ResourceObservationLibraryTests`)、#5249 (`LeanReportCacheTests`)及 #5060/#5672
/// (`EngineeringScopeProgramTests`)。#5249 的测试面随本次删除消失,底层归因仍为 open。
///
/// **作用面**:`tools/tests/**` 下的 C# 源码不得读取真实 `.github/workflows` 路径;
/// 测试经 `tools/TestSupport/**` helper 可达的调用图也不得执行 `tools/scripts/**` 下的仓库
/// shell 脚本、仓库 `Makefile` 的副本或 make target。
///
/// **诚实边界(这是形状扫描,不是完备保证)**——反例集合两维:
/// ① 绕过检查:字符串拼接、变量路径、从文件或环境变量读路径、非 C# 载体(shell/python
///    测试脚本读 workflow)、相对路径 `../.github/workflows`;
/// ② 检查被跳过:本项目不编译或不跑、本 `[Fact]` 被删、扫描前缀写错导致零命中。
/// 故本条只作**早反馈**,不得声称「保证不存在 workflow 测试」。
/// </summary>
public sealed class WorkflowTestProhibitionTests
{
    // workflow 扫描面仍是 "tools/tests"。脚本/make 扫描面集中在
    // RepositoryScriptAndMakeSources,让执行门与枚举正控共用同一来源。

    /// <summary>
    /// 具名豁免,**removal-only**:新增一项必须先自行论证,不得靠扩充本集合让新的 workflow
    /// 测试通过。豁免的判据只有一条——**被测对象是消费 workflow 的生产逻辑,而不是 workflow
    /// 本身**;这类测试即使删掉 workflow 也仍有意义,故不属本禁令射程。
    /// </summary>
    private static readonly IReadOnlySet<string> ProductionConsumerExemptionCeiling =
        new HashSet<string>(StringComparer.Ordinal)
        {
            "tools/tests/StrataLint.Tests/Admission/ReviewRegressionTests.Helpers.cs",
        };

    private static readonly IReadOnlyDictionary<string, string> ProductionConsumerExemptions =
        new Dictionary<string, string>(StringComparer.Ordinal)
        {
            ["tools/tests/StrataLint.Tests/Admission/ReviewRegressionTests.Helpers.cs"] =
                "在夹具仓内合成一份 workflow 喂 AdmissionTopology;不读本仓真实 workflow。",
        };

    // Owner 2026-09-07 established no inherited script/make exemptions. Keeping the collection
    // explicit lets the scanner fail closed if an exemption is ever introduced without removing
    // this zero-growth guard.
    private static readonly IReadOnlySet<string> ScriptAndMakeConsumerExemptions =
        new HashSet<string>(StringComparer.Ordinal);

    private static readonly Regex WorkflowReference = new(
        @"\.github/workflows|""\.github""\s*,\s*""workflows""",
        RegexOptions.Compiled | RegexOptions.CultureInvariant);

    /// <summary>
    /// 窄谓词:**同一行**同时出现真实仓根 accessor 与 workflow 路径,即「读本仓真实 workflow」。
    /// 这才是器律⑦′ 的实质判据——该律禁的是断言**真实** workflow 的内容,不禁止在夹具仓里
    /// 合成一份 workflow 喂给被测的生产逻辑(后者正是既有豁免项的理由原文)。
    ///
    /// **为什么禁令不能用宽正则 <see cref="WorkflowReference"/>**:实测 dev 上 11 个测试源命中
    /// 宽正则,其中 9 个是合成夹具、Assert.DoesNotContain、或本判官自己的正则字面量(自指
    /// 假阳);拿宽正则立禁令会当场判红 9 处,即 CLAUDE.md 第 20 条所禁的反序。窄谓词的对照:
    /// dev 全树命中 **0**(阴性),对 issue #6104 记录的三个真违规文件各命中 **1**(阳性)。
    ///
    /// **反例集合(两维,写不出就不能用「保证」二字)**:①绕过——跨行(FindRoot 与读取分两行)、
    /// 变量中转、Path.Combine(root, ".github", "workflows", ...) 分段形、从文件或环境变量读
    /// 路径、非 C# 载体;②检查被跳过——本项目不编译或不跑、本 [Fact] 被删、EnumerateDeclared
    /// 前缀写错(由 TheScanSurfaceActuallyEnumeratesTheTestTree 钉住)。故本条是**早反馈**,
    /// 不得声称「树上不存在读真实 workflow 的测试」。
    /// </summary>
    private static readonly Regex RealWorkflowRead = new(
        @"(Test)?RepositoryLayout\.FindRoot\(\)[^;]*\.github/workflows",
        RegexOptions.Compiled | RegexOptions.CultureInvariant);

    /// <summary>
    /// 豁免不得腐烂:每项都必须仍然存在、且仍然确实含 workflow 引用。某项一旦不再需要豁免,
    /// 本测试即红,强制把它从集合里删掉——这就是 removal-only 的机器形。
    /// </summary>
    [Fact]
    public void EveryExemptionIsStillPresentAndStillNeedsIt()
    {
        var tracked = RepositoryScriptAndMakeSources()
            .Select(static source => source.Path)
            .ToArray();
        var referencing = ScanAll().Select(static hit => hit.Path).ToHashSet(StringComparer.Ordinal);

        Assert.All(
            ProductionConsumerExemptions.Keys,
            exemption => Assert.Contains(exemption, ProductionConsumerExemptionCeiling));

        Assert.All(ProductionConsumerExemptions, entry =>
        {
            Assert.Contains(entry.Key, tracked);
            Assert.True(
                referencing.Contains(entry.Key),
                $"该文件已不再引用 workflow,豁免是僵尸,请删除该项:{entry.Key}");
            Assert.False(string.IsNullOrWhiteSpace(entry.Value), $"豁免必须写明理由:{entry.Key}");
        });
    }

    [Fact]
    public void ScriptAndMakeExemptionSetCannotGrow() =>
        Assert.Empty(ScriptAndMakeConsumerExemptions);

    private static IReadOnlyList<ScriptAndMakeSource> RepositoryScriptAndMakeSources()
    {
        var root = RepositoryLayout.FindRoot();
        return new[] { "tools/tests", "tools/TestSupport" }
            .SelectMany(prefix => GitIndexRepositoryFiles.EnumerateDeclared(root, prefix))
            .Where(static file => file.RelativePath.EndsWith(".cs", StringComparison.Ordinal))
            .Select(file => new ScriptAndMakeSource(
                file.RelativePath,
                File.ReadAllText(file.FullPath)))
            .ToArray();
    }

    /// <summary>
    /// 主禁令(器律⑦′「永久禁止对 workflow 写测试」)。**这条此前不存在**:ScanAll() 的唯一
    /// 消费者是上面那条豁免反腐测试,它只问「豁免项是否仍需豁免」,从不问「非豁免项是否
    /// 违规」,于是该禁令长期零执法——机制在,检测不在(issue #6104;CLAUDE.md 第Ⅵ节
    /// 「检测是否存在,只能由变异判定」)。
    /// </summary>
    [Fact]
    public void NoTestSourceReadsTheRealWorkflow()
    {
        var hits = ScanRealWorkflowReads();

        Assert.True(
            hits.Count == 0,
            "器律⑦′:测试不得读本仓真实 workflow —— 它只校验 workflow「长什么样」,校验不了"
                + "它「会不会执行」,给出的绿是假绿。正确性由真跑判(器律⑦)。\n"
                + string.Join("\n", hits.Select(static hit => $"  {hit.Path}:{hit.Line}")));
    }

    /// <summary>
    /// Owner 2026-09-07:测试不得启动仓库 shell 脚本或 make target。扫描以 Roslyn 绑定
    /// Process/TestProcessRunner 的真实符号,从测试方法遍历 `tools/tests/**` 与
    /// `tools/TestSupport/**` 的方法/构造器调用图,把不同类型里的脚本路径引用与
    /// bash/sh/env 启动合并判定;运行时路径、反射调用与非 C# 测试载体仍是 fail-open 边界。
    /// </summary>
    [Fact]
    public void NoTestReachesRepositoryShellScriptThroughTestSupportHelperOrExecutesMakeTarget()
    {
        var hits = ScanRepositoryScriptAndMakeExecutions();

        Assert.True(
            hits.Count == 0,
            "器律⑦′:测试不得执行仓库 shell 脚本或 make target;正确性只由真实 CI 运行与评审守。\n"
                + string.Join("\n", hits.Select(static hit => $"  {hit.Path}:{hit.Line}")));
    }

    /// <summary>
    /// 放行侧钉子。第Ⅵ节:「一个『什么都拒绝』的坏门能通过一整套只测拒绝的用例」——把窄谓词
    /// 误写宽(退化回 WorkflowReference)会把这些**合法的合成夹具**一并判红,而只测拒绝的
    /// 用例结构上看不见这一点。
    /// </summary>
    [Fact]
    public void SyntheticWorkflowFixturesAreNotFlagged()
    {
        var flagged = ScanRealWorkflowReads()
            .Select(static hit => hit.Path)
            .ToHashSet(StringComparer.Ordinal);

        Assert.DoesNotContain(
            "tools/tests/StrataLint.Tests/Admission/ReviewRegressionTests.Helpers.cs",
            flagged);
        Assert.DoesNotContain(
            "tools/tests/StrataLint.Tests/Rules/JudgeSurfaceRevisionRuleTests.cs",
            flagged);
    }

    /// <summary>
    /// 放行侧钉子:只测试 C# 程序逻辑、但在合成输入里出现脚本路径的文件不得被扩大射程。
    /// </summary>
    [Fact]
    public void ProgramLogicFixturesThatMentionScriptsAreNotFlagged()
    {
        var flagged = ScanRepositoryScriptAndMakeExecutions()
            .Select(static hit => hit.Path)
            .ToHashSet(StringComparer.Ordinal);

        Assert.DoesNotContain(
            "tools/tests/StrataLint.Tests/Rules/JudgeSurfaceRevisionRuleTests.cs",
            flagged);
        Assert.DoesNotContain(
            "tools/tests/StrataLint.Tests/FrozenLedger/FrozenSurfaceRuleTests.cs",
            flagged);
        Assert.DoesNotContain(
            "tools/tests/StrataLint.Tests/Rules/Scoping/ActiveRuleScopeProbeTests.cs",
            flagged);
        Assert.DoesNotContain(
            "tools/tests/StrataLint.Scribe.Tests/Projection/RendererCorpusContractTests.cs",
            flagged);
        Assert.DoesNotContain(
            "tools/tests/StrataLint.ArchitectureTests/Determinism/BannedApiCoverageTests.cs",
            flagged);
        Assert.DoesNotContain(
            "tools/tests/StrataLint.Tests/Commands/CliVerbLinkageTests.cs",
            flagged);
        Assert.DoesNotContain(
            "tools/tests/StrataLint.Tests/Commands/Worktrees/ColdBuildGuardTests.cs",
            flagged);
        Assert.DoesNotContain(
            "tools/tests/StrataLint.ArchitectureTests/Runtime/ColdBuildBudgetReviewLineTests.cs",
            flagged);
    }

    [Fact]
    public void SyntheticTestSupportHelperIndirectionIsDetected()
    {
        var hits = ScanRepositoryScriptAndMakeExecutions(
        [
            new ScriptAndMakeSource(
                "tools/TestSupport/Synthetic/SyntheticScriptFixture.cs",
                "namespace Synthetic;\n\n" + """
                internal sealed class SyntheticScriptFixture
                {
                    private const string ScriptPath = "tools/scripts/workflow/synthetic.sh";

                    internal SyntheticScriptFixture()
                    {
                        System.IO.File.Copy(ScriptPath, "synthetic.sh");
                    }

                    internal void Run() => SyntheticLauncher.Run();
                }

                internal static class SyntheticLauncher
                {
                    internal static void Run() =>
                        System.Diagnostics.Process.Start("/usr/bin/env", "/bin/bash synthetic.sh");
                }
                """),
            new ScriptAndMakeSource(
                "tools/tests/Synthetic.Tests/SyntheticScriptTests.cs",
                "namespace Synthetic;\n\n" + """
                public sealed class SyntheticScriptTests
                {
                    [Xunit.Fact]
                    public void ExecutesRepositoryScriptThroughTestSupportFixture()
                    {
                        var fixture = new SyntheticScriptFixture();
                        fixture.Run();
                    }
                }
                """),
        ]);

        Assert.Contains(
            hits,
            static hit => hit.Path == "tools/tests/Synthetic.Tests/SyntheticScriptTests.cs");
    }

    /// <summary>
    /// 防「扫描前缀写错而恒绿」:本正控与执行门调用同一个枚举成员,并证明它同时选中测试树
    /// 与 TestSupport 树。任一前缀漂移都会在这里直接判红。
    /// </summary>
    [Fact]
    public void TheScanSurfaceActuallyEnumeratesTheTestTree()
    {
        var tracked = RepositoryScriptAndMakeSources()
            .Select(static source => source.Path)
            .ToArray();

        Assert.NotEmpty(tracked);
        Assert.Contains(
            "tools/tests/StrataLint.ArchitectureTests/RepositoryIo/WorkflowTestProhibitionTests.cs",
            tracked);
        Assert.Contains(
            "tools/TestSupport/StrataLint.TestSupport/TestScratchRoot.cs",
            tracked);
    }

    [Fact]
    public void ThePositiveControlCannotBeDeleted()
    {
        var root = RepositoryLayout.FindRoot();
        var source = File.ReadAllText(Path.Combine(
            root,
            "tools/tests/StrataLint.ArchitectureTests/RepositoryIo/WorkflowTestProhibitionTests.cs"));

        Assert.Matches(
            @"\[Fact\]\s+public void TheScanSurfaceActuallyEnumeratesTheTestTree\(\)",
            source);
    }

    private static IReadOnlyList<(string Path, int Line)> ScanRealWorkflowReads()
    {
        var root = RepositoryLayout.FindRoot();
        var hits = new List<(string, int)>();

        foreach (var file in GitIndexRepositoryFiles.EnumerateDeclared(root, "tools/tests"))
        {
            if (!file.RelativePath.EndsWith(".cs", StringComparison.Ordinal))
            {
                continue;
            }

            var lines = File.ReadAllLines(file.FullPath);
            for (var index = 0; index < lines.Length; index++)
            {
                if (RealWorkflowRead.IsMatch(lines[index]))
                {
                    hits.Add((file.RelativePath, index + 1));
                }
            }
        }

        return hits;
    }

    private static IReadOnlyList<(string Path, int Line)> ScanAll()
    {
        var root = RepositoryLayout.FindRoot();
        var hits = new List<(string, int)>();

        foreach (var file in GitIndexRepositoryFiles.EnumerateDeclared(root, "tools/tests"))
        {
            if (!file.RelativePath.EndsWith(".cs", StringComparison.Ordinal))
            {
                continue;
            }

            var lines = File.ReadAllLines(file.FullPath);
            for (var index = 0; index < lines.Length; index++)
            {
                if (WorkflowReference.IsMatch(lines[index]))
                {
                    hits.Add((file.RelativePath, index + 1));
                }
            }
        }

        return hits;
    }

    private static IReadOnlyList<(string Path, int Line)> ScanRepositoryScriptAndMakeExecutions()
        => ScanRepositoryScriptAndMakeExecutions(RepositoryScriptAndMakeSources());

    private static IReadOnlyList<(string Path, int Line)> ScanRepositoryScriptAndMakeExecutions(
        IReadOnlyList<ScriptAndMakeSource> scanSources)
    {
        var hits = new List<(string, int)>();
        var sources = scanSources
            .Where(source => !ScriptAndMakeConsumerExemptions.Contains(source.Path))
            .Select(source => (
                Source: source,
                Tree: CSharpSyntaxTree.ParseText(
                    source.Text,
                    CSharpParseOptions.Default.WithLanguageVersion(LanguageVersion.Preview),
                    source.Path)))
            .ToArray();
        var compilation = CSharpCompilation.Create(
            "ScriptAndMakeTestProhibitionAnalysis",
            sources.Select(static source => source.Tree),
            SemanticReferences(),
            new CSharpCompilationOptions(OutputKind.DynamicallyLinkedLibrary, allowUnsafe: true));
        var methods = new Dictionary<string, ScriptAndMakeMethod>(StringComparer.Ordinal);

        foreach (var source in sources)
        {
            var model = compilation.GetSemanticModel(source.Tree, ignoreAccessibility: true);
            var syntaxRoot = source.Tree.GetRoot();
            foreach (var declaration in syntaxRoot.DescendantNodes().OfType<BaseMethodDeclarationSyntax>())
            {
                if (model.GetDeclaredSymbol(declaration) is not IMethodSymbol symbol)
                {
                    continue;
                }

                var invocations = declaration.DescendantNodes()
                    .OfType<InvocationExpressionSyntax>()
                    .ToArray();
                var constants = declaration.DescendantNodes()
                    .OfType<ExpressionSyntax>()
                    .Select(expression => model.GetConstantValue(expression))
                    .Where(static value => value.HasValue && value.Value is string)
                    .Select(static value => (string)value.Value!)
                    .ToArray();
                var namesRepositoryScript = constants.Any(static value =>
                        value.Replace('\\', '/').Contains("tools/scripts/", StringComparison.Ordinal))
                    || invocations
                        .Any(candidate => IsToolsScriptsPathCombine(candidate, model));
                var processLaunches = invocations
                    .Where(invocation => IsProcessLaunch(model.GetSymbolInfo(invocation)))
                    .ToArray();
                var launchesMake = processLaunches.Any(invocation =>
                    InvocationStringConstants(invocation, model)
                        .Any(value => IsExecutable(value, "make")));
                var launchesShellOrEnv = processLaunches.Any(invocation =>
                    InvocationStringConstants(invocation, model).Any(value =>
                        IsExecutable(value, "bash")
                        || IsExecutable(value, "sh")
                        || IsExecutable(value, "env")));
                var calls = invocations
                    .SelectMany(invocation => MethodSymbols(model.GetSymbolInfo(invocation)))
                    .Concat(declaration.DescendantNodes()
                        .OfType<ObjectCreationExpressionSyntax>()
                        .SelectMany(creation => MethodSymbols(model.GetSymbolInfo(creation))))
                    .Select(MethodKey)
                    .Distinct(StringComparer.Ordinal)
                    .ToArray();
                var methodKey = MethodKey(symbol);
                methods[methodKey] = new ScriptAndMakeMethod(
                    methodKey,
                    source.Source.Path,
                    declaration.GetLocation().GetLineSpan().StartLinePosition.Line + 1,
                    IsTestMethod(declaration),
                    namesRepositoryScript,
                    launchesMake,
                    launchesShellOrEnv,
                    calls);
            }
        }

        foreach (var test in methods.Values.Where(static method => method.IsTest))
        {
            var reachable = ReachableMethods(test.Symbol, methods);
            var launchesMake = reachable.Any(static method => method.LaunchesMake);
            var launchesShellOrEnv = reachable.Any(static method => method.LaunchesShellOrEnv);
            var namesRepositoryScript = reachable.Any(static method => method.NamesRepositoryScript);
            if (launchesMake || launchesShellOrEnv && namesRepositoryScript)
            {
                hits.Add((test.Path, test.Line));
            }
        }

        return hits;
    }

    private static IReadOnlyList<ScriptAndMakeMethod> ReachableMethods(
        string root,
        IReadOnlyDictionary<string, ScriptAndMakeMethod> methods)
    {
        var reachable = new List<ScriptAndMakeMethod>();
        var pending = new Stack<string>();
        var visited = new HashSet<string>(StringComparer.Ordinal);
        pending.Push(root);
        while (pending.TryPop(out var symbol))
        {
            if (!visited.Add(symbol) || !methods.TryGetValue(symbol, out var method))
            {
                continue;
            }

            reachable.Add(method);
            foreach (var called in method.Calls)
            {
                pending.Push(called);
            }
        }

        return reachable;
    }

    private static string MethodKey(IMethodSymbol method) =>
        method.OriginalDefinition.ToDisplayString(SymbolDisplayFormat.CSharpErrorMessageFormat);

    private static IEnumerable<string> InvocationStringConstants(
        InvocationExpressionSyntax invocation,
        SemanticModel model) =>
        invocation.DescendantNodesAndSelf()
            .OfType<ExpressionSyntax>()
            .Select(expression => model.GetConstantValue(expression))
            .Where(static value => value.HasValue && value.Value is string)
            .Select(static value => (string)value.Value!);

    private static bool IsTestMethod(BaseMethodDeclarationSyntax declaration) =>
        declaration is MethodDeclarationSyntax
        && declaration.AttributeLists.SelectMany(static list => list.Attributes).Any(static attribute =>
        {
            var name = attribute.Name.ToString();
            return name.EndsWith("Fact", StringComparison.Ordinal)
                || name.EndsWith("FactAttribute", StringComparison.Ordinal)
                || name.EndsWith("Theory", StringComparison.Ordinal)
                || name.EndsWith("TheoryAttribute", StringComparison.Ordinal);
        });

    private sealed record ScriptAndMakeSource(string Path, string Text);

    private sealed record ScriptAndMakeMethod(
        string Symbol,
        string Path,
        int Line,
        bool IsTest,
        bool NamesRepositoryScript,
        bool LaunchesMake,
        bool LaunchesShellOrEnv,
        IReadOnlyList<string> Calls);

    private static bool IsProcessLaunch(SymbolInfo info) => MethodSymbols(info).Any(static method =>
        method.Name is "Run" or "Start"
        && method.ContainingType.ToDisplayString() is
            "StrataLint.TestSupport.TestProcessRunner"
            or "StrataLint.Engine.BoundedProcessRunner"
            or "System.Diagnostics.Process");

    private static IEnumerable<IMethodSymbol> MethodSymbols(SymbolInfo info)
    {
        if (info.Symbol is IMethodSymbol method)
        {
            yield return method;
        }

        foreach (var candidate in info.CandidateSymbols.OfType<IMethodSymbol>())
        {
            yield return candidate;
        }
    }

    private static bool IsToolsScriptsPathCombine(
        InvocationExpressionSyntax invocation,
        SemanticModel model)
    {
        if (!MethodSymbols(model.GetSymbolInfo(invocation)).Any(static method =>
            method.Name == "Combine" && method.ContainingType.ToDisplayString() == "System.IO.Path"))
        {
            return false;
        }

        var values = invocation.ArgumentList.Arguments
            .Select(argument => model.GetConstantValue(argument.Expression))
            .Where(static value => value.HasValue && value.Value is string)
            .Select(static value => (string)value.Value!)
            .ToArray();
        return values.Zip(values.Skip(1)).Any(static pair =>
            pair.First == "tools" && pair.Second == "scripts");
    }

    private static bool IsExecutable(string value, string executable) =>
        string.Equals(value, executable, StringComparison.Ordinal)
        || value.Replace('\\', '/').EndsWith('/' + executable, StringComparison.Ordinal);

    private static IEnumerable<MetadataReference> SemanticReferences()
    {
        var trustedPlatformAssemblies = AppContext.GetData("TRUSTED_PLATFORM_ASSEMBLIES") as string
            ?? throw new InvalidOperationException(
                "The runtime did not expose TRUSTED_PLATFORM_ASSEMBLIES for Roslyn analysis.");
        return trustedPlatformAssemblies
            .Split(Path.PathSeparator, StringSplitOptions.RemoveEmptyEntries)
            .Concat(AppDomain.CurrentDomain.GetAssemblies()
                .Where(static assembly => !assembly.IsDynamic && !string.IsNullOrEmpty(assembly.Location))
                .Select(static assembly => assembly.Location))
            .Distinct(StringComparer.Ordinal)
            .Select(static path => MetadataReference.CreateFromFile(path));
    }
}
