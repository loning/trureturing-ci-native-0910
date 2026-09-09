using System.Text.Json;
using FixtureFile = StrataLint.TestSupport.TemporaryFileSystem.File;
using FixtureDirectory = StrataLint.TestSupport.TemporaryFileSystem.Directory;

namespace StrataLint.Tests;

public sealed class LeanReportTransportTests
{
    [Theory]
    [InlineData("raw-lean-report.json")]
    [InlineData("candidate-lean-report.json")]
    public void RoundTripNormalizesAllFiveMembersAndImportsUnderPairAddress(string basename)
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        var bundle = fixture.Bundle(basename);
        fixture.Success(fixture.Publish(bundle));
        fixture.Success(fixture.Fetch());

        Assert.NotEqual(fixture.RepositoryAddress, fixture.PairAddress);
        var restored = fixture.CachedReport;
        foreach (var suffix in LeanReportTransportFixture.Suffixes.Where(value => value != ".sha256"))
            Assert.Equal(FixtureFile.ReadAllBytes(bundle + suffix), FixtureFile.ReadAllBytes(restored + suffix));
        Assert.Equal(LeanReportTransportFixture.Digest(FixtureFile.ReadAllBytes(bundle)) + "  raw-lean-report.json\n",
            FixtureFile.ReadAllText(restored + ".sha256"));
        Assert.False(FixtureDirectory.Exists(Path.Combine(fixture.CacheRoot, fixture.RepositoryAddress)));
        Assert.False(FixtureDirectory.Exists(restored + ".logs"));
        Assert.False(FixtureDirectory.Exists(Path.Combine(fixture.Repository, ".lake")));
        Assert.Equal(2, fixture.Assets.Length);
        Assert.All(fixture.ReleaseCalls, call => Assert.DoesNotContain("lean-cache-v1-", call, StringComparison.Ordinal));
    }

    [Fact]
    public void ExactRemoteHitRunsEnsureBeforeLakeStagingWithoutProducerOrSlot()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        fixture.Success(fixture.Publish(fixture.Bundle()));
        var result = fixture.MakeReport();
        fixture.Success(result);
        Assert.Contains("mode=cached", result.Text, StringComparison.Ordinal);
        Assert.Equal(["absent"], fixture.EnsureCalls);
        Assert.Empty(fixture.ProducerCalls);
        Assert.Empty(fixture.SlotCalls);
        Assert.Contains("mode=exact", result.Text, StringComparison.Ordinal);
    }

    [Fact]
    public void ExactLocalHitPerformsNoRemoteIoOrProducerSlotButStillEnsures()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        fixture.Success(fixture.Publish(fixture.Bundle()));
        fixture.Success(fixture.Fetch());
        var before = fixture.ReleaseCalls;
        fixture.Success(fixture.MakeReport("FIXTURE_GH_FAIL=1"));
        Assert.Equal(before, fixture.ReleaseCalls);
        Assert.Equal(["absent"], fixture.EnsureCalls);
        Assert.Empty(fixture.ProducerCalls);
        Assert.Empty(fixture.SlotCalls);
    }

    [Fact]
    public void EnsureFailureOnExactHitPreservesLiveBundleAndExit()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        fixture.Success(fixture.Pair(remote: false));
        var before = fixture.LiveSnapshot();
        var result = fixture.Pair(remote: true, "FIXTURE_ENSURE_EXIT=73");
        Assert.Equal(73, result.ExitCode);
        Assert.Equal(before, fixture.LiveSnapshot());
        Assert.Single(fixture.ProducerCalls);
        Assert.Empty(fixture.ReleaseCalls);
    }

    [Fact]
    public void CompatibleRemoteSeedFeedsAuthoritativeDeltaWithoutClaimingCurrentHit()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        var oldAddress = fixture.PairAddress;
        fixture.Success(fixture.Publish(fixture.Bundle()));
        fixture.WriteSource("D5/Probe.lean", "-- changed\n");
        var result = fixture.Fetch();
        fixture.Success(result);
        Assert.Contains("mode=seed", result.Text, StringComparison.Ordinal);
        Assert.False(FixtureDirectory.Exists(Path.Combine(fixture.CacheRoot, fixture.PairAddress)));
        Assert.True(FixtureDirectory.Exists(Path.Combine(fixture.CacheRoot, oldAddress)));
        using var plan = fixture.DeltaPlan();
        Assert.Equal("delta", plan.RootElement.GetProperty("status").GetString());
        Assert.Equal(["D5.Probe"], plan.RootElement.GetProperty("recheck").EnumerateArray().Select(value => value.GetString()));
        fixture.Success(fixture.Pair(remote: true));
        Assert.Single(fixture.ProducerCalls);
        Assert.Contains("\"mode\":\"produced\"", FixtureFile.ReadAllText(fixture.Output + ".provenance.json"), StringComparison.Ordinal);
    }

    [Fact]
    public void CompatibleLocalSeedAvoidsRemoteIo()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        fixture.Success(fixture.Pair(remote: false));
        fixture.WriteSource("D5/Probe.lean", "-- changed\n");
        fixture.Success(fixture.Pair(remote: true, "FIXTURE_GH_FAIL=1"));
        Assert.Empty(fixture.ReleaseCalls);
        Assert.Equal(2, fixture.ProducerCalls.Length);
    }

    [Theory]
    [InlineData("producer")]
    [InlineData("config")]
    public void IncompatibleProducerOrConfigurationIsNotImported(string input)
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        fixture.Success(fixture.Publish(fixture.Bundle()));
        fixture.ChangeCompatibility(input);
        Assert.NotEqual(0, fixture.Fetch().ExitCode);
        Assert.Empty(fixture.CacheEntries);
    }

    [Theory]
    [InlineData("archive-digest")]
    [InlineData("materials-digest")]
    [InlineData("materials-zip")]
    [InlineData("missing-materials")]
    [InlineData("missing-provenance")]
    [InlineData("pair-address")]
    [InlineData("repository-address")]
    [InlineData("basename")]
    [InlineData("producer")]
    [InlineData("config")]
    public void DamagedTransportIsAMissBeforeImport(string damage)
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        fixture.Success(fixture.Publish(fixture.Bundle()));
        fixture.DamageAsset(damage);
        var result = fixture.Fetch();
        Assert.NotEqual(0, result.ExitCode);
        Assert.Empty(fixture.CacheEntries);
        Assert.Contains("LEAN_REPORT_CACHE status=miss", result.Text, StringComparison.Ordinal);
    }

    [Theory]
    [InlineData("unavailable")]
    [InlineData("missing")]
    [InlineData("cache-write")]
    [InlineData("corrupt")]
    public void AcquisitionFailureFallsBackToRequiredProduction(string failure)
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        if (failure == "corrupt")
        {
            fixture.Success(fixture.Publish(fixture.Bundle()));
            fixture.DamageAsset("archive-digest");
        }
        if (failure == "cache-write") fixture.BlockCacheRoot();
        var result = fixture.MakeReport(failure == "unavailable" ? "FIXTURE_GH_FAIL=1" : "FIXTURE_GH_FAIL=0");
        fixture.Success(result);
        Assert.Single(fixture.ProducerCalls);
        Assert.Single(fixture.SlotCalls);
        Assert.Contains("mode=produced", result.Text, StringComparison.Ordinal);
        Assert.Contains("LEAN_REPORT_CACHE status=miss", result.Text, StringComparison.Ordinal);
        if (failure == "cache-write")
            Assert.Contains("reason=cache-write-failed", result.Text, StringComparison.Ordinal);
    }

    [Fact]
    public void FailedReplacementAfterRemoteMissKeepsEveryLiveBundleByte()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        fixture.Success(fixture.Pair(remote: false));
        var before = fixture.LiveSnapshot();
        fixture.ClearCache();
        var result = fixture.Pair(remote: true, "FIXTURE_GH_FAIL=1", "FIXTURE_PRODUCER_EXIT=69");
        Assert.Equal(69, result.ExitCode);
        Assert.Equal(before, fixture.LiveSnapshot());
    }

    [Theory]
    [InlineData("complete")]
    [InlineData("partial")]
    [InlineData("corrupt")]
    public void RepeatedPublicationVerifiesOrRepairsAllAssets(string state)
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        var bundle = fixture.Bundle();
        fixture.Success(fixture.Publish(bundle));
        if (state == "partial") fixture.RemoveDigestAsset();
        if (state == "corrupt") fixture.DamageAsset("archive-digest");
        var uploads = fixture.UploadCount;
        fixture.Success(fixture.Publish(bundle));
        Assert.Equal(state == "complete" ? uploads : uploads + 1, fixture.UploadCount);
        Assert.Equal(2, fixture.Assets.Length);
        fixture.Success(fixture.Fetch());
    }

    [Fact]
    public void PublicationRejectsStaleInputBeforeRemoteWrite()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        var bundle = fixture.Bundle();
        fixture.WriteSource("D5/Probe.lean", "-- changed\n");
        Assert.NotEqual(0, fixture.Publish(bundle).ExitCode);
        Assert.Empty(fixture.ReleaseCalls);
    }

    [Theory]
    [InlineData("complete")]
    [InlineData("partial")]
    [InlineData("corrupt")]
    public void ExactAssetPrecedesCompatibleSeedAndBadExactFallsBack(string state)
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        var oldAddress = fixture.PairAddress;
        fixture.Success(fixture.Publish(fixture.Bundle()));
        fixture.WriteSource("D5/Probe.lean", "-- new input\n");
        fixture.Success(fixture.Publish(fixture.Bundle()));
        if (state == "partial") fixture.RemoveDigestAsset();
        if (state == "corrupt") fixture.DamageAsset("archive-digest");
        var result = fixture.Fetch();
        fixture.Success(result);
        Assert.Contains(state == "complete" ? "mode=exact" : "mode=seed", result.Text, StringComparison.Ordinal);
        Assert.Single(fixture.CacheEntries);
        Assert.Contains(state == "complete" ? fixture.PairAddress : oldAddress, fixture.CacheEntries[0], StringComparison.Ordinal);
    }

    [Fact]
    public void TrailingCacheRootSeparatorStillRestoresExactBundle()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        fixture.Success(fixture.Publish(fixture.Bundle()));
        var result = fixture.MakeReport("STRATALINT_REPORT_CACHE_ROOT=" + fixture.CacheRoot + "/");
        fixture.Success(result);
        Assert.Empty(fixture.ProducerCalls);
        Assert.Contains("mode=cached", result.Text, StringComparison.Ordinal);
    }

    [Fact]
    public void FailedFetchPreservesAlreadyInstalledBundle()
    {
        if (OperatingSystem.IsWindows()) return;
        using var fixture = new LeanReportTransportFixture();
        fixture.Success(fixture.Publish(fixture.Bundle()));
        fixture.Success(fixture.Fetch());
        var before = fixture.CacheSnapshot();
        fixture.DamageAsset("archive-digest");
        Assert.NotEqual(0, fixture.Fetch().ExitCode);
        Assert.Equal(before, fixture.CacheSnapshot());
    }
}
