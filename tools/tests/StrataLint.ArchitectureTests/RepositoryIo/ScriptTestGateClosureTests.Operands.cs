using StrataLint.Engine;

namespace StrataLint.ArchitectureTests;

// ScriptTestGateClosureTests 的后半:operand / closure 判定一族。
// 分出来的直接理由是余量:宿主原 795 行,离 SL-003 的 800 行硬线只剩 5 行。
// 该类本就是 partial(同族已有 .Fixture.cs),故切分不动类声明。
//
// 切点用「缩进 4 的真方法收尾」判定,不是文本搜 `public void` ——
// 本文件大量 `public void XxxProbe()` 住在 const string source = """…""" 的**样本源码**里
// (缩进 16),按文本找边界会切进字符串字面量。

public sealed partial class ScriptTestGateClosureTests
{

    [Fact]
    public void MutableConstructorFieldAssignmentFailsClosed()
    {
        const string script = "tools/scripts/constructor-field-input.sh";
        var snapshot = AppendTestMethod(
            CurrentSnapshot(),
            $$"""

                [Fact]
                public void ConstructorFieldProbe() => new ConstructorPathFixture().Run();

                private sealed class ConstructorPathFixture
                {
                    private const string ScriptPath = "{{script}}";
                    private string candidateLeaf;

                    internal ConstructorPathFixture()
                    {
                        candidateLeaf = Path.Combine({{RepositoryRootCall}}, ScriptPath);
                    }

                    internal void Run() => TestProcessRunner.Run(
                        "/bin/bash", [candidateLeaf], TestScratchRoot.Current.Path,
                        TestBudgets.ScriptProcessHangGuard, 1024);
                }
            """,
            (script, "#!/usr/bin/env bash\nexit 0\n"));

        var error = Assert.ThrowsAny<Exception>(() => Derive(snapshot, []));

        Assert.Contains("ConstructorFieldProbe", Flatten(error), StringComparison.Ordinal);
        Assert.Contains("unrecognised-sink operation value", Flatten(error), StringComparison.Ordinal);
    }

    [Fact]
    public void ReadonlyConstructorRepositoryRootFieldFailsClosed()
    {
        const string script = "tools/scripts/constructor-field-input.sh";
        var snapshot = AppendTestMethod(
            CurrentSnapshot(),
            $$"""

                [Fact]
                public void ConstructorRootFieldProbe() => new ConstructorRootFixture().Run();

                private sealed class ConstructorRootFixture
                {
                    private readonly string repositoryRoot;

                    internal ConstructorRootFixture()
                    {
                        repositoryRoot = {{RepositoryRootCall}};
                    }

                    internal void Run() => TestProcessRunner.Run(
                        "/bin/bash", [Path.Combine(repositoryRoot, "{{script}}")],
                        TestScratchRoot.Current.Path, TestBudgets.ScriptProcessHangGuard, 1024);
                }
            """,
            (script, "#!/usr/bin/env bash\nexit 0\n"));

        var error = Assert.ThrowsAny<Exception>(() => Derive(snapshot, []));

        Assert.Contains("ConstructorRootFieldProbe", Flatten(error), StringComparison.Ordinal);
        Assert.Contains("unrecognised-sink operation value", Flatten(error), StringComparison.Ordinal);
    }

    // A test deriving over the real tree would be the direct evidence that the
    // recognition below recovers lean-cache-input.sh from the actual
    // StrataLint.ScriptTests project. It cannot exist here: reading the tree needs
    // a production loader called on FindRoot(), which the deriver classifies
    // IndirectViaProductionLoader by design, and SL-003 blocks a newly introduced
    // unknown identity outright. Measured, not inferred: the probe reported
    // UNKNOWN_COUNT=1 for exactly that shape. A prior layer deleted such a test
    // for the same reason. The end-to-end evidence is a content-plane PR going
    // green, since only those reach this derivation at all (issue #5340).

    [Fact]
    public void ControllerRuntimeInputMustBeTracked()
    {
        var snapshot = CurrentSnapshot();

        var error = Assert.ThrowsAny<Exception>(() =>
            Derive(snapshot, ["tools/scripts/controller-input-missing.sh"]));

        Assert.Contains("controller-input-missing.sh", Flatten(error), StringComparison.Ordinal);
        Assert.Contains("absent", Flatten(error), StringComparison.Ordinal);
    }

    [Fact]
    public void ClosureDerivesReferencesPrefixesLocksBuildInputsAndControllerInputs()
    {
        const string controllerInput = "tools/scripts/controller-gate-probe.sh";
        const string syntheticProject = "tools/ScriptGateProbe/ScriptGateProbe.csproj";
        var snapshot = WithFiles(
            ReplaceText(
                CurrentSnapshot(),
                ScriptTestsProject,
                text => text.Replace(
                    "<ProjectReference Include=\"../../StrataLint.Engine/StrataLint.Engine.csproj\" />",
                    "<ProjectReference Include=\"../../StrataLint.Engine/StrataLint.Engine.csproj\" />\n"
                    + "    <ProjectReference Include=\"../../ScriptGateProbe/ScriptGateProbe.csproj\" />",
                    StringComparison.Ordinal)),
            (syntheticProject, "<Project Sdk=\"Microsoft.NET.Sdk\" />\n"),
            ("tools/ScriptGateProbe/Probe.cs", "namespace ScriptGateProbe; internal sealed class Probe { }\n"),
            ("tools/ScriptGateProbe/packages.lock.json", "{\"version\":1,\"dependencies\":{}}\n"),
            (controllerInput, "#!/usr/bin/env bash\nexit 0\n"));

        var closure = Derive(snapshot, [controllerInput]);

        Assert.Contains(ScriptTestsProject, closure.ExactPaths);
        Assert.Contains(syntheticProject, closure.ExactPaths);
        Assert.Contains("tools/ScriptGateProbe/packages.lock.json", closure.ExactPaths);
        Assert.Contains("tools/ScriptGateProbe", closure.DirectoryPrefixes);
        Assert.Contains("Directory.Build.props", closure.ExactPaths);
        Assert.Contains("global.json", closure.ExactPaths);
        Assert.Contains(controllerInput, closure.ExactPaths);
        Assert.DoesNotContain(
            closure.DirectoryPrefixes,
            static prefix => prefix.StartsWith("Blueprint", StringComparison.Ordinal));
        Assert.DoesNotContain(
            closure.ExactPaths,
            static path => path.EndsWith(".scribe.cs", StringComparison.Ordinal));
    }

    private static GateClosureView Derive(
        RepositorySnapshot snapshot,
        IReadOnlyCollection<string> controllerInputs)
    {
        var result = ScriptTestGateClosurePolicy.Derive(snapshot, controllerInputs);
        return new GateClosureView(result.ExactPaths, result.DirectoryPrefixes);
    }

    private static RepositorySnapshot AppendTestMethod(
        RepositorySnapshot snapshot,
        string method,
        params (string Path, string Content)[] addedFiles)
    {
        var updated = ReplaceText(
            snapshot,
            ScriptTestsSource,
            text => text[..text.LastIndexOf('}')] + method + "\n}\n");
        return WithFiles(updated, addedFiles);
    }

    private static RepositorySnapshot ReplaceText(
        RepositorySnapshot snapshot,
        string path,
        Func<string, string> replace)
    {
        var file = snapshot.Files.Values.Single(item => item.Path.Value == path);
        return WithFiles(snapshot, (path, replace(file.Text)));
    }

    private static RepositorySnapshot WithFiles(
        RepositorySnapshot snapshot,
        params (string Path, string Content)[] replacements)
    {
        var replacementByPath = replacements.ToDictionary(static item => item.Path, StringComparer.Ordinal);
        var entries = snapshot.Files.Values
            .Where(file => !replacementByPath.ContainsKey(file.Path.Value))
            .Select(file => new RawRepositoryEntry(file.Path.Value, file.RawBytes, file.GitBlobOid))
            .Concat(replacements.Select(static item => RawRepositoryEntry.FromText(item.Path, item.Content)));
        return Decode(RawRepositorySnapshot.Create(entries));
    }

    private static RepositorySnapshot Decode(RawRepositorySnapshot raw) =>
        SnapshotDecoder.Decode(raw) switch
        {
            SnapshotDecodeOutcome.Decoded decoded => decoded.Snapshot,
            SnapshotDecodeOutcome.InfrastructureFailure failure =>
                throw new InvalidDataException(failure.Message),
        };

    private static string Flatten(Exception exception) =>
        string.Join(" | ", ExceptionChain(exception).Select(static item => item.Message));

    private static IEnumerable<Exception> ExceptionChain(Exception exception)
    {
        for (var current = exception; current is not null; current = current.InnerException)
            yield return current;
    }

    private sealed record GateClosureView(
        IReadOnlyList<string> ExactPaths,
        IReadOnlyList<string> DirectoryPrefixes);
}
