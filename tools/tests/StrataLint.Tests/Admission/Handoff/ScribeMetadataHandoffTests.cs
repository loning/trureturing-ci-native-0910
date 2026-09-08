using Microsoft.CodeAnalysis;
using StrataLint.Engine;
using StrataLint.EngineeringScope;
using StrataLint.TestSupport;
using File = StrataLint.TestSupport.TemporaryFileSystem.File;
using Directory = StrataLint.TestSupport.TemporaryFileSystem.Directory;

namespace StrataLint.Tests;

public sealed class ScribeMetadataHandoffTests
{
    [Theory]
    [InlineData("transport")]
    [InlineData("missing-manifest")]
    [InlineData("unbound-manifest")]
    [InlineData("missing-reference")]
    [InlineData("corrupt-reference")]
    [InlineData("unbound-reference")]
    public void TransportedClosureRunsRealAnalysisAndRejectsIncompleteEvidence(string scenario)
    {
        var producer = Directory.CreateTempSubdirectory("metadata-producer-").FullName;
        var recipient = Directory.CreateTempSubdirectory("metadata-recipient-").FullName;
        try
        {
            var snapshot = Snapshot(true);
            var paths = CommonCompileMetadata.Export(producer, snapshot);
            var materials = CommonExecutionEvidence.Materials(producer, paths);
            Assert.Contains(materials, item => item.Path.EndsWith("/xunit.core.dll", StringComparison.Ordinal));
            foreach (var material in materials)
            {
                var destination = Path.Combine(recipient, material.Path);
                Directory.CreateDirectory(Path.GetDirectoryName(destination)!);
                File.WriteAllBytes(destination, File.ReadAllBytes(Path.Combine(producer, material.Path)));
            }
            Directory.Delete(producer, recursive: true);
            Assert.False(Directory.Exists(Path.Combine(recipient, "obj")));
            Assert.False(Directory.Exists(Path.Combine(recipient, "bin")));
            Assert.False(Directory.Exists(Path.Combine(recipient, ".nuget")));
            var reference = materials.First(item => item.Path.EndsWith("/xunit.core.dll", StringComparison.Ordinal));
            switch (scenario)
            {
                case "missing-manifest": File.Delete(Path.Combine(recipient, CommonCompileMetadata.ManifestPath)); break;
                case "unbound-manifest": materials = materials.Where(item => item.Path != CommonCompileMetadata.ManifestPath).ToArray(); break;
                case "missing-reference": File.Delete(Path.Combine(recipient, reference.Path)); break;
                case "corrupt-reference": File.WriteAllText(Path.Combine(recipient, reference.Path), "corrupt metadata"); break;
                case "unbound-reference": materials = materials.Where(item => item != reference).ToArray(); break;
            }
            if (scenario != "transport")
            {
                if (scenario.StartsWith("missing-", StringComparison.Ordinal))
                    Assert.ThrowsAny<IOException>(() => CommonCompileMetadata.Load(recipient, materials));
                else
                    Assert.Throws<InvalidDataException>(() => CommonCompileMetadata.Load(recipient, materials));
                return;
            }
            var inputs = CommonCompileMetadata.Load(recipient, materials);
            var calls = new List<string>();
            ProcessOutput Evaluate(string host, IEnumerable<string> arguments, string root, TimeSpan timeout,
                int limit, ReadOnlyMemory<byte> stdin, IReadOnlyDictionary<string, string>? environment)
            {
                Assert.Equal("msbuild", arguments.First());
                Assert.Contains("-getItem:Compile", arguments);
                Assert.DoesNotContain(arguments, argument => argument.StartsWith("-target:", StringComparison.Ordinal));
                calls.Add(arguments.ElementAt(1));
                return TestProcessRunner.Classify(() => BoundedProcessRunner.Run(host, arguments, root, timeout,
                    limit, stdin, environment), host);
            }
            ScribeTestMap Derive(RepositorySnapshot source) => ScribeTestMapDeriver.DeriveSnapshot(source, inputs,
                data => ScribeTestMapDeriver.DeriveSnapshotUncached(data, Evaluate, inputs));
            var current = Derive(snapshot);
            var baseline = Derive(Snapshot(false));
            Assert.Equal(6, calls.Count);
            Assert.Empty(current.CompileQueryFindings);
            Assert.Empty(baseline.CompileQueryFindings);
            Assert.Equal(2, current.Methods.Count);
            Assert.Single(baseline.Methods);
            Assert.All(current.Methods, method => Assert.Empty(method.UnknownReasons));
            Assert.Empty(ScribeUnknownDebtPolicy.Evaluate(current, baseline));
            Assert.Throws<InvalidDataException>(() => Derive(Snapshot(true, "0.0.0-not-transported")));
        }
        finally
        {
            if (Directory.Exists(producer)) Directory.Delete(producer, recursive: true);
            Directory.Delete(recipient, recursive: true);
        }
    }

    [Fact]
    public void ProducerWithAbsentMetadataFailsExplicitly()
    {
        var root = Directory.CreateTempSubdirectory("metadata-absent-").FullName;
        try
        {
            var failure = Assert.Throws<InvalidDataException>(() => CommonCompileMetadata.Export(root,
                Snapshot(true), (id, version) => Path.Combine(root, "empty-packages", id, version)));
            Assert.Contains("compile metadata package is unavailable", failure.Message, StringComparison.Ordinal);
            Assert.False(File.Exists(Path.Combine(root, CommonCompileMetadata.ManifestPath)));
        }
        finally { Directory.Delete(root, recursive: true); }
    }

    [Fact]
    public void SuppliedMetadataIsUsedByActualSnapshotCompilation()
    {
        var snapshot = Snapshot(true, "0.0.0-unavailable-metadata-fixture");
        var map = ScribeTestMapDeriver.DeriveSnapshot(snapshot, _ => References());

        Assert.Empty(map.CompileQueryFindings);
        Assert.Equal(2, map.Methods.Count);
        Assert.All(map.Methods, method => Assert.Empty(method.UnknownReasons));
        Assert.Empty(ScribeUnknownDebtPolicy.Evaluate(map,
            ScribeTestMapDeriver.DeriveSnapshot(Snapshot(false, "0.0.0-unavailable-metadata-fixture"), _ => References())));
    }

    private static string[] References() => ScribeMetadataReferenceResolver.PlatformReferences()
        .Cast<PortableExecutableReference>().Select(reference => reference.FilePath!)
        .Concat(new[] { typeof(Xunit.FactAttribute).Assembly.Location, typeof(Xunit.Assert).Assembly.Location,
            typeof(Xunit.Abstractions.ITest).Assembly.Location }).ToArray();

    internal static RepositorySnapshot Snapshot(bool addition, string version = "2.9.3")
    {
        var files = new List<RawRepositoryEntry>
        {
            RawRepositoryEntry.FromText("tools/tests/Probe/Probe.csproj", """
                <Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><TargetFramework>net10.0</TargetFramework></PropertyGroup>
                <ItemGroup><PackageReference Include="xunit" /></ItemGroup></Project>
                """),
            RawRepositoryEntry.FromText("tools/tests/Probe/packages.lock.json", $$$$$"""
                {"dependencies":{"net10.0":{"xunit.extensibility.core":{"resolved":"{{{{{version}}}}}"},
                "xunit.assert":{"resolved":"{{{{{version}}}}}"},"xunit.abstractions":{"resolved":"2.0.3"}}}}
                """),
            RawRepositoryEntry.FromText("tools/tests/Probe/Existing.cs",
                "public class Existing { [Xunit.Fact] public void Runs() { Xunit.Assert.True(true); } }"),
        };
        foreach (var path in ScribeTestMapDeriver.CompileFailProofProjectExemptions)
            files.Add(RawRepositoryEntry.FromText(path, "<Project />"));
        if (addition) files.Add(RawRepositoryEntry.FromText("tools/tests/Probe/Added.cs",
            "public class Added { [Xunit.Fact] public void HarmlessAddition() { Xunit.Assert.True(true); } }"));
        return Assert.IsType<SnapshotDecodeOutcome.Decoded>(SnapshotDecoder.Decode(RawRepositorySnapshot.Create(files))).Snapshot;
    }
}
