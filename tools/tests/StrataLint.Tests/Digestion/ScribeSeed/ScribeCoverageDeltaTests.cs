using System.Text;
using StrataLint.Cli;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed class ScribeCoverageDeltaTests
{
    [Fact]
    public void AdmissionRuleAcceptsCandidateNewCoverageWithoutScribeReceipt()
    {
        var fixture = new ScribeSeedFixture();
        fixture.Baseline = ScribeSeedFixture.Map(fixture.Baseline, entry => entry with { Coverage = [] });
        fixture.Document = ScribeSeedFixture.Map(fixture.Document, entry => entry with
        {
            ProjectedStatus = new DigestionStatus(DigestionMigrationState.Absorbed, DigestionTruthState.Closed),
        });
        var context = AdmissionContext(fixture,
            RawChangeSet.CreateWithKinds([
                (ScribeSeedFixture.EntryPath(fixture.Baseline.RequireDigestionEntries()[0]), RawChangeKind.Deleted),
                (ScribeSeedFixture.EntryPath(fixture.First), RawChangeKind.Added),
            ]));

        var findings = BackfillInventoryRule.EvaluateCandidateDelta(context);

        Assert.Empty(findings);
    }

    [Fact]
    public void AdmissionRuleLeaves84UnchangedMissingScribeReceiptsNonBlocking()
    {
        var fixture = new ScribeSeedFixture(84);
        var context = AdmissionContext(fixture, RawChangeSet.Create(["notes/unrelated.txt"]));

        var findings = BackfillInventoryRule.EvaluateCandidateDelta(context);

        Assert.Empty(findings);
    }

    [Fact]
    public void ChangedCoverageStatementWithoutScribeReceiptIsAccepted()
    {
        var fixture = new ScribeSeedFixture();
        fixture.Baseline = ScribeSeedFixture.Map(fixture.Baseline, entry => entry with
        {
            Coverage = [entry.Coverage[0] with { TargetStatementId = null }],
        });
        fixture.Document = ScribeSeedFixture.Map(fixture.Document, entry => entry with
        {
            ProjectedStatus = new DigestionStatus(DigestionMigrationState.Absorbed, DigestionTruthState.Closed),
        });
        var repository = fixture.Gateway(RawChangeSet.Create([ScribeSeedFixture.EntryPath(fixture.First)]));

        var result = DigestStatusCommand.Run(repository, new FakeLeanReportSource(fixture.Inputs.Report),
            new FakeScribeEmissionVerifier(fixture.Verified), ["--base", "baseline"],
            FakeAtomHistorySource.ForPaths(fixture.Files.Keys), new DigestAgeClock());

        Assert.True(result.Success, result.Error);
        Assert.Contains("absorbed-closed", result.Output, StringComparison.Ordinal);
        Assert.DoesNotContain("scribe-", result.Output, StringComparison.Ordinal);
    }

    [Fact]
    public void FullScanAbsorbsCompleteCoverageWithoutScribeReceipts()
    {
        var fixture = new ScribeSeedFixture(84);
        var repository = fixture.Gateway(RawChangeSet.Create([]));

        var result = DigestStatusCommand.Run(repository, new FakeLeanReportSource(fixture.Inputs.Report),
            new FakeScribeEmissionVerifier(fixture.Verified), ["--base", "baseline"],
            FakeAtomHistorySource.ForPaths(fixture.Files.Keys), new DigestAgeClock());

        Assert.True(result.Success, result.Error);
        Assert.Equal(84, result.Output.Split('\n').Count(line =>
            line.StartsWith("ENTRY ", StringComparison.Ordinal)
                && line.Contains("absorbed-closed", StringComparison.Ordinal)));
        Assert.DoesNotContain("scribe-", result.Output, StringComparison.Ordinal);
    }

    [Fact]
    public void CandidateNewCoverageWithoutScribeReceiptIsAccepted()
    {
        var fixture = new ScribeSeedFixture();
        fixture.Baseline = ScribeSeedFixture.Map(fixture.Baseline, entry => entry with { Coverage = [] });
        fixture.Document = ScribeSeedFixture.Map(fixture.Document, entry => entry with
        {
            ProjectedStatus = new DigestionStatus(DigestionMigrationState.Absorbed, DigestionTruthState.Closed),
        });
        var repository = fixture.Gateway(RawChangeSet.Create([ScribeSeedFixture.EntryPath(fixture.First)]));

        var result = DigestStatusCommand.Run(repository, new FakeLeanReportSource(fixture.Inputs.Report),
            new FakeScribeEmissionVerifier(fixture.Verified), ["--base", "baseline"],
            FakeAtomHistorySource.ForPaths(fixture.Files.Keys), new DigestAgeClock());

        Assert.True(result.Success, result.Error);
        Assert.Contains("absorbed-closed", result.Output, StringComparison.Ordinal);
        Assert.DoesNotContain("scribe-", result.Output, StringComparison.Ordinal);
    }

    [Fact]
    public void UnrelatedDeltaRetainsPartialBaselineWithoutScribeGaps()
    {
        var fixture = new ScribeSeedFixture(84);
        var repository = fixture.Gateway(RawChangeSet.Create(["notes/unrelated.txt"]));

        var result = DigestStatusCommand.Run(repository, new FakeLeanReportSource(fixture.Inputs.Report),
            new FakeScribeEmissionVerifier(fixture.Verified), ["--base", "baseline"],
            FakeAtomHistorySource.ForPaths(fixture.Files.Keys), new DigestAgeClock());

        Assert.True(result.Success, result.Error);
        Assert.Equal(84, result.Output.Split('\n').Count(line =>
            line.StartsWith("ENTRY ", StringComparison.Ordinal)
                && line.Contains("partial-closed", StringComparison.Ordinal)));
        Assert.DoesNotContain("scribe-", result.Output, StringComparison.Ordinal);
    }

    private static RuleEvaluationContext AdmissionContext(ScribeSeedFixture fixture, RawChangeSet changes)
    {
        var repository = fixture.Gateway(changes);
        var current = Assert.IsType<SnapshotDecodeOutcome.Decoded>(
            SnapshotDecoder.Decode(repository.ReadCurrent())).Snapshot;
        var baseline = Assert.IsType<SnapshotDecodeOutcome.Decoded>(
            SnapshotDecoder.Decode(repository.ReadRevision("baseline"))).Snapshot;
        var policy = RegistryLoadAssert.Accepted(RegistryLoader.Load(
            Encoding.UTF8.GetBytes(TestRegistry.Canonical), Encoding.UTF8.GetBytes(TestRegistry.Domains))).Policy;
        var lean = Assert.IsType<LeanValidationOutcome.Accepted>(
            LeanClosureValidator.Validate(current, fixture.Inputs.Report)).Capability;
        var bootstrap = Assert.IsType<BootstrapOutcome.Clear>(BootstrapGate.Evaluate(changes));
        return RuleEvaluationContext.Create(current, baseline, policy, lean, changes,
            MetaEvaluationProfile.ForClear(bootstrap.Capability), fixture.Verified);
    }
}
