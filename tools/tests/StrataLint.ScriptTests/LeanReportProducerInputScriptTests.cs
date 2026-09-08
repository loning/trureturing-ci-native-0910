using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed class LeanReportProducerInputScriptTests
{
    [Theory]
    [InlineData("producer-paths")]
    [InlineData("scribe-producer-paths")]
    public void CacheFetcherClosureIncludesTransitiveInputsAndRejectsMissingInputs(string command)
    {
        using var fixture = new ProducerInputFixture();
        const string dependency = "tools/scripts/worktree/fetch-input.sh";
        fixture.Write(dependency, "#!/usr/bin/env bash\n");
        fixture.Append(ProducerInputFixture.FetcherPath, "\nsource \"$SCRIPT_DIR/fetch-input.sh\"\n");

        var complete = fixture.Run(command);

        Assert.True(complete.ExitCode == 0, Encoding.UTF8.GetString(complete.StandardError));
        Assert.Contains(ProducerInputFixture.FetcherPath, Lines(complete));
        Assert.Contains(dependency, Lines(complete));
        fixture.Remove(dependency);
        var missingDependency = fixture.Run(command);
        Assert.Equal(2, missingDependency.ExitCode);
        Assert.Empty(missingDependency.StandardOutput);
        Assert.Contains(dependency, Encoding.UTF8.GetString(missingDependency.StandardError));
        fixture.Remove(ProducerInputFixture.FetcherPath);
        var missingFetcher = fixture.Run(command);
        Assert.Equal(2, missingFetcher.ExitCode);
        Assert.Empty(missingFetcher.StandardOutput);
        Assert.Contains(ProducerInputFixture.FetcherPath, Encoding.UTF8.GetString(missingFetcher.StandardError));
    }

    [Fact]
    public void CacheFetcherBytesChangeProducerWithoutChangingLeanInputs()
    {
        using var fixture = new ProducerInputFixture();
        var before = fixture.Address();

        fixture.Append(ProducerInputFixture.FetcherPath, "# fetch acceptance changed\n");
        var after = fixture.Address();

        Assert.NotEqual(before[0], after[0]);
        Assert.NotEqual(before[1], after[1]);
        Assert.Equal(before[2..], after[2..]);
    }

    [Fact]
    public void AddressIsIndependentOfCallerWorkingDirectorySdk()
    {
        using var fixture = new ProducerInputFixture();
        var fromRepository = fixture.Run("address");

        var fromForeignSdk = fixture.AddressFromForeignSdkDirectory();

        Assert.Equal(0, fromRepository.ExitCode);
        Assert.Equal(fromRepository.ExitCode, fromForeignSdk.ExitCode);
        Assert.Equal(fromRepository.StandardOutput, fromForeignSdk.StandardOutput);
    }

    [Theory]
    [InlineData("msbuild")]
    [InlineData("sdk")]
    public void AddressFailurePreservesProjectAndRawDiagnostic(string failure)
    {
        using var fixture = new ProducerInputFixture();
        if (failure == "msbuild") fixture.Append(ProducerInputFixture.CliProjectPath, "<");
        else fixture.Write("global.json", ProducerInputFixture.UnavailableSdk);
        var raw = fixture.EvaluateCliProject();
        Assert.NotEqual(0, raw.ExitCode);
        Assert.NotEmpty(raw.StandardOutput.Concat(raw.StandardError));

        var result = fixture.Run("address");

        Assert.Equal(2, result.ExitCode);
        Assert.Empty(result.StandardOutput);
        var diagnostic = Encoding.UTF8.GetString(result.StandardError);
        Assert.Contains(fixture.CliProject, diagnostic, StringComparison.Ordinal);
        foreach (var stream in new[] { raw.StandardOutput, raw.StandardError })
        {
            if (stream.Length > 0)
                Assert.Contains(Encoding.UTF8.GetString(stream), diagnostic, StringComparison.Ordinal);
        }
    }

    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void AddressMatchesIndependentFixturePreimage(bool prebuilt)
    {
        using var fixture = new ProducerInputFixture();
        if (prebuilt) fixture.UsePrebuiltEntrypoint();

        var result = fixture.Run("address");

        Assert.True(result.ExitCode == 0, Encoding.UTF8.GetString(result.StandardError));
        Assert.Equal(fixture.ExpectedAddressBytes(), result.StandardOutput);
        Assert.Empty(result.StandardError);
    }

    private static string[] Lines(ProcessOutput output) =>
        Encoding.UTF8.GetString(output.StandardOutput).Split('\n', StringSplitOptions.RemoveEmptyEntries);

    private sealed class ProducerInputFixture : IDisposable
    {
        internal const string FetcherPath = "tools/scripts/worktree/lean-cache-publish.sh";
        internal const string CliProjectPath = "tools/StrataLint.Cli/StrataLint.Cli.csproj";
        internal const string UnavailableSdk =
            "{\"sdk\":{\"version\":\"99.0.100\",\"rollForward\":\"disable\"}}\n";
        private const string InputHelperPath = "tools/scripts/report/lean-report-input.sh";
        private const string Revision = "0123456789abcdef0123456789abcdef01234567";
        private readonly TemporaryDirectory temporary = new();
        private readonly string repository;
        private readonly Dictionary<string, string> properties = new(StringComparer.Ordinal)
        {
            ["NETCoreSdkVersion"] = "fixture-sdk",
            ["TargetFramework"] = "net10.0",
            ["RuntimeIdentifier"] = "",
            ["DefineConstants"] = "REPORT_FIXTURE",
            ["LangVersion"] = "latest",
            ["Nullable"] = "enable",
            ["ImplicitUsings"] = "enable",
            ["Optimize"] = "true",
            ["AllowUnsafeBlocks"] = "false",
            ["CheckForOverflowUnderflow"] = "false",
            ["PlatformTarget"] = "AnyCPU",
            ["RestorePackagesWithLockFile"] = "false",
            ["NuGetLockFilePath"] = "",
        };

        internal ProducerInputFixture()
        {
            repository = Path.Combine(temporary.Path, "repository");
            ScriptHarnessScratch.EnsureDirectory(repository);
            var physical = TestProcessRunner.Run("pwd", ["-P"], repository,
                TestBudgets.ScriptProcessHangGuard, 4096);
            Assert.Equal(0, physical.ExitCode);
            repository = Encoding.UTF8.GetString(physical.StandardOutput).Trim();
            ScriptHarnessScratch.CopyScriptInto(
                Path.Combine(TestRepositoryLayout.FindRoot(), InputHelperPath), Path.Combine(repository, InputHelperPath));
            ScriptHarnessScratch.CopyScriptInto(
                Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/report/producer_paths.py"),
                Path.Combine(repository, "tools/scripts/report/producer_paths.py"));
            ScriptHarnessScratch.CopyScriptInto(
                Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/report/dotnet_producer.py"),
                Path.Combine(repository, "tools/scripts/report/dotnet_producer.py"));
            ScriptHarnessScratch.CopyScriptInto(
                Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/worktree/lean-cache-input.sh"),
                Path.Combine(repository, "tools/scripts/worktree/lean-cache-input.sh"));
            ScriptHarnessScratch.CopyScriptInto(
                Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/worktree/lean_cache.py"),
                Path.Combine(repository, "tools/scripts/worktree/lean_cache.py"));
            Write("tools/lean-inspector/inspect.sh",
                "#!/bin/bash\ndotnet run --project \"$ROOT/tools/StrataLint.Cli/StrataLint.Cli.csproj\" --configuration Release --\n");
            Write("tools/lean-inspector/Inspector.lean", "def inspector := 1\n");
            foreach (var module in new[] { "delta", "materials", "report_cache", "runtime_identity" })
                Write($"tools/lean-inspector/{module}.py", "# synthetic dependency\n");
            Write("tools/scripts/lean-report-pair.sh", "#!/bin/bash\n");
            Write("tools/scripts/workflow/scribe-content-checks.sh", "#!/bin/bash\n");
            Write(FetcherPath, "#!/bin/bash\n");
            Write("global.json", "{}\n");
            var props = new System.Xml.Linq.XDocument(new System.Xml.Linq.XElement("Project",
                new System.Xml.Linq.XElement("PropertyGroup", properties.Select(pair =>
                    new System.Xml.Linq.XElement(pair.Key, pair.Value)))));
            Write("producer.props", props.ToString());
            foreach (var project in new[]
                     { "StrataLint.Cli", "StrataLint.Engine", "StrataLint.Scribe", "StrataLint.Scribe.Documents", "Trureturing.Truth" })
            {
                // No SDK imports: this fixture's semantic preimage is fully explicit.
                Write($"tools/{project}/{project}.csproj",
                    "<Project><Import Project=\"../../producer.props\" /><ItemGroup>"
                    + "<Compile Include=\"Fixture.cs\" /></ItemGroup></Project>\n");
                Write($"tools/{project}/Fixture.cs", "internal class Fixture { }\n");
                Write($"tools/{project}/packages.lock.json", "{}\n");
            }
            Write("Trureturing.lean", "import D5.Probe\n");
            Write("D5/Probe.lean", "def probe := 1\n");
            Write("lean-toolchain", "leanprover/lean4:v4.33.0\n");
            Write("lakefile.toml", "name = \"fixture\"\n");
            Write("lake-manifest.json", "{\"packages\":[{\"name\":\"mathlib\",\"rev\":\"" + Revision + "\"}]}\n");
        }

        internal string CliProject => Path.Combine(repository, CliProjectPath);

        internal void UsePrebuiltEntrypoint() => Write("tools/lean-inspector/inspect.sh",
            "#!/bin/bash\ndotnet \"$ROOT/tools/StrataLint.Cli/bin/Release/net10.0/StrataLint.dll\" worktree with-cache-writer --\n");

        internal ProcessOutput Run(string command, string? workingDirectory = null) => TestProcessRunner.Run(
            "/bin/bash", [Path.Combine(repository, InputHelperPath), command, "--repository", repository],
            workingDirectory ?? repository, TestBudgets.WorkflowProcessHangGuard, 1024 * 1024);

        internal string[] Address()
        {
            var result = Run("address");
            Assert.True(result.ExitCode == 0, Encoding.UTF8.GetString(result.StandardError));
            return Encoding.UTF8.GetString(result.StandardOutput).Trim().Split(' ');
        }

        internal ProcessOutput AddressFromForeignSdkDirectory()
        {
            var directory = Path.Combine(temporary.Path, "foreign sdk");
            ScriptHarnessScratch.EnsureDirectory(directory);
            ScriptHarnessScratch.WriteScratchText(Path.Combine(directory, "global.json"), UnavailableSdk);
            return Run("address", directory);
        }

        internal ProcessOutput EvaluateCliProject() => TestProcessRunner.Run("dotnet",
            ["msbuild", CliProject, "-nologo", "-noAutoResponse", "-nodeReuse:false", "-verbosity:quiet",
                "-property:Configuration=Release", "-getItem:Compile"],
            repository, TestBudgets.ScriptProcessHangGuard, 1024 * 1024);

        internal void Write(string relativePath, string contents)
        {
            var path = Path.Combine(repository, relativePath);
            ScriptHarnessScratch.EnsureDirectory(Path.GetDirectoryName(path)!);
            ScriptHarnessScratch.WriteScratchText(path, contents);
        }

        internal void Append(string path, string contents) =>
            ScriptHarnessScratch.AppendScratchText(Path.Combine(repository, path), contents);

        internal void Remove(string path) => ScriptHarnessScratch.DeleteScratchFile(Path.Combine(repository, path));

        internal byte[] ExpectedAddressBytes()
        {
            string[] producerPaths =
            [
                CliProjectPath, "tools/StrataLint.Cli/Fixture.cs", "producer.props", "global.json",
                "tools/lean-inspector/inspect.sh", "tools/lean-inspector/Inspector.lean",
                "tools/lean-inspector/delta.py", "tools/lean-inspector/materials.py",
                "tools/lean-inspector/report_cache.py", "tools/lean-inspector/runtime_identity.py",
                InputHelperPath, "tools/scripts/report/producer_paths.py", "tools/scripts/report/dotnet_producer.py",
                "tools/scripts/lean-report-pair.sh", FetcherPath,
                "tools/scripts/worktree/lean-cache-input.sh", "tools/scripts/worktree/lean_cache.py",
            ];
            var semantics = JsonSerializer.Serialize(properties.OrderBy(pair => pair.Key, StringComparer.Ordinal)
                .Select(pair => new[] { CliProjectPath + ":" + pair.Key, pair.Value }));
            var manifest = producerPaths.Select(path => HashFile(path) + "  " + path + "\n")
                .Append(Hash(semantics) + "  @msbuild-semantics\n").Order(StringComparer.Ordinal);
            var producer = Hash(string.Concat(manifest));
            var sources = Hash(string.Concat(new[]
                { "Trureturing.lean", "D5/Probe.lean", "tools/lean-inspector/Inspector.lean" }
                .Select(path => HashFile(path) + "  " + path + "\n")));
            var config = Hash("{\"lean\":{\"libraries\":[]},\"packages\":[{\"name\":\"mathlib\",\"rev\":\"" + Revision
                + "\"}],\"schema\":\"lean-semantic-config-v1\",\"toolchain\":\"leanprover/lean4:v4.33.0\"}\n");
            var address = Hash("schema=stratalint-lean-report-repository-input-v1\n"
                + $"repository_inspector_sha256={producer}\nlean_sources_sha256={sources}\nlean_config_sha256={config}\n");
            return Encoding.UTF8.GetBytes($"{address} {producer} {sources} {config}\n");
        }

        private string HashFile(string path) =>
            Convert.ToHexStringLower(SHA256.HashData(
                ScriptHarnessScratch.ReadScratchBytes(temporary, Path.Combine("repository", path))));

        private static string Hash(string value) => Convert.ToHexStringLower(SHA256.HashData(Encoding.UTF8.GetBytes(value)));

        public void Dispose() => temporary.Dispose();
    }
}
