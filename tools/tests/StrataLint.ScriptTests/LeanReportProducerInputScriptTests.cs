using System.Text;
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
        var sources = fixture.ProducerSourceImage();

        var result = fixture.Run("address");

        Assert.True(result.ExitCode == 0, Encoding.UTF8.GetString(result.StandardError));
        Assert.Equal(fixture.ExpectedAddressBytes(), result.StandardOutput);
        Assert.Empty(result.StandardError);
        Assert.Equal(sources, fixture.ProducerSourceImage());
    }

    private static string[] Lines(ProcessOutput output) =>
        Encoding.UTF8.GetString(output.StandardOutput).Split('\n', StringSplitOptions.RemoveEmptyEntries);
}
