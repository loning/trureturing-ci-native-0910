using System.Collections.Immutable;
using System.Text;
using StrataLint.Engine;
using Trureturing.Truth;

namespace StrataLint.Tests;

public sealed class FrozenPairRuleTests
{
    private const string Rule = "SL-033";
    private const string Selector = RuleFixture.RingPath;
    private const string OtherSelector = RuleFixture.ValuesBindingPath;
    private const string Implementation = "tools/StrataLint.Engine/Rules/FrozenPairRule.cs";

    [Fact]
    public void LastFreezeDeletionWithRetainedStateBlocksAndNamesSelectorAndHash()
    {
        var fixture = new RuleFixture();
        var removed = AddHistoricalPair(fixture, Selector);
        fixture.Files.Remove(removed.Path);

        var diagnostic = Assert.Single(Evaluate(fixture, (removed.Path, RawChangeKind.Deleted)));

        AssertMissingPair(diagnostic, Selector);
        Assert.Contains(removed.Hash, diagnostic.Message, StringComparison.Ordinal);
    }

    [Fact]
    public void NewStateWithoutAcceptedFreezeBlocksAndNamesSelector()
    {
        var fixture = new RuleFixture();
        AddState(fixture, Selector);

        var diagnostic = Assert.Single(Evaluate(fixture, (StatePath(Selector), RawChangeKind.Added)));

        AssertMissingPair(diagnostic, Selector);
    }

    [Fact]
    public void PairedEventAndStateDeletionIsAllowed()
    {
        var fixture = new RuleFixture();
        var removed = AddHistoricalPair(fixture, Selector);
        fixture.Files.Remove(removed.Path);
        fixture.Files.Remove(StatePath(Selector));

        Assert.Empty(Evaluate(fixture,
            (removed.Path, RawChangeKind.Deleted),
            (StatePath(Selector), RawChangeKind.Deleted)));
    }

    [Fact]
    public void SameSelectorReplacementWithNewEventHashIsAllowed()
    {
        var fixture = new RuleFixture();
        var removed = AddHistoricalPair(fixture, Selector);
        fixture.Files.Remove(removed.Path);
        var replacement = AddFreeze(fixture, Selector, prerequisite: 'a');
        Assert.NotEqual(removed.Hash, replacement.Hash);

        Assert.Empty(Evaluate(fixture,
            (removed.Path, RawChangeKind.Deleted),
            (replacement.Path, RawChangeKind.Added)));
    }

    [Fact]
    public void DeletingOneOfTwoFreezeEventsKeepsThePair()
    {
        var fixture = new RuleFixture();
        var removed = AddHistoricalPair(fixture, Selector);
        var remaining = AddFreeze(fixture, Selector, prerequisite: 'b');
        fixture.Baseline[remaining.Path] = fixture.Files[remaining.Path];
        fixture.Files.Remove(removed.Path);

        Assert.Empty(Evaluate(fixture, (removed.Path, RawChangeKind.Deleted)));
    }

    [Fact]
    public void UnrelatedDeltaDoesNotExecuteOrEmitFrozenPairFindings()
    {
        var fixture = new RuleFixture();
        AddState(fixture, Selector, historical: true);
        fixture.Files[Selector] += "-- unrelated comment\n";

        var completed = Execute(fixture, (Selector, RawChangeKind.Modified));

        Assert.DoesNotContain(completed.ExecutedRules, id => id.Value == Rule);
        Assert.Empty(PairDiagnostics(completed));
    }

    [Fact]
    public void UntouchedBaselineBreakIsIgnoredDuringAnotherSelectorsFreezeDelta()
    {
        var fixture = new RuleFixture();
        AddState(fixture, OtherSelector, historical: true);
        var added = AddFreeze(fixture, Selector, prerequisite: 'c');
        AddState(fixture, Selector);

        Assert.Empty(Evaluate(fixture,
            (added.Path, RawChangeKind.Added),
            (StatePath(Selector), RawChangeKind.Added)));
    }

    [Fact]
    public void PreviouslyBrokenStateIsNotANewBreakWhenItsPinChanges()
    {
        var fixture = new RuleFixture();
        AddState(fixture, Selector, historical: true);
        fixture.Files[StatePath(Selector)] =
            "{\"statement_id\":\"sha256:" + new string('f', 64) + "\"}\n";

        Assert.Empty(Evaluate(fixture, (StatePath(Selector), RawChangeKind.Modified)));
    }

    [Fact]
    public void NewStateCanUseAnUnchangedAcceptedFreeze()
    {
        var fixture = new RuleFixture();
        var existing = AddFreeze(fixture, Selector);
        fixture.Baseline[existing.Path] = fixture.Files[existing.Path];
        AddState(fixture, Selector);

        Assert.Empty(Evaluate(fixture, (StatePath(Selector), RawChangeKind.Added)));
    }

    [Fact]
    public void ReplacementForAnotherSelectorDoesNotRepairTheDeletedPair()
    {
        var fixture = new RuleFixture();
        var removed = AddHistoricalPair(fixture, Selector);
        fixture.Files.Remove(removed.Path);
        var other = AddFreeze(fixture, OtherSelector);
        AddState(fixture, OtherSelector);

        var diagnostic = Assert.Single(Evaluate(fixture,
            (removed.Path, RawChangeKind.Deleted),
            (other.Path, RawChangeKind.Added),
            (StatePath(OtherSelector), RawChangeKind.Added)));

        AssertMissingPair(diagnostic, Selector);
    }

    [Fact]
    public void MalformedChangedAcceptedEventFailsClosed()
    {
        var fixture = new RuleFixture();
        var removed = AddHistoricalPair(fixture, Selector);
        fixture.Files[removed.Path] = "{}\n";

        var diagnostics = Evaluate(fixture, (removed.Path, RawChangeKind.Modified));

        Assert.Contains(diagnostics, diagnostic => diagnostic.AdmissionEffect == AdmissionEffect.Block
            && diagnostic.Path == removed.Path
            && diagnostic.Message.Contains("FROZEN_PAIR_INPUT_INVALID", StringComparison.Ordinal));
    }

    [Fact]
    public void UnchangedMalformedAcceptedEventOutsideTheDeltaIsIgnored()
    {
        var fixture = new RuleFixture();
        var malformed = FrozenLedgerChangeClassifier.AcceptedPath("sha256:" + new string('d', 64));
        fixture.Files[malformed] = "{}\n";
        fixture.Baseline[malformed] = fixture.Files[malformed];
        var added = AddFreeze(fixture, Selector);
        AddState(fixture, Selector);

        Assert.Empty(Evaluate(fixture,
            (added.Path, RawChangeKind.Added),
            (StatePath(Selector), RawChangeKind.Added)));
    }

    [Fact]
    [BaseFactScopeProbe(33)]
    public void Sl033ScopesNewBreaksToDeltaEvenWhenRuleImplementationChanges()
    {
        var historical = new RuleFixture();
        AddState(historical, Selector, historical: true);
        historical.Files[Implementation] = "// changed judge\n";
        var context = historical.Build(RawChangeSet.Create([Implementation]));
        Assert.True(context.RuleImplementationChanged);
        var completed = Assert.IsType<RuleExecutionOutcome.Completed>(RuleCatalog.Default.Execute(context)).Capability;
        Assert.Empty(PairDiagnostics(completed));

        var broken = new RuleFixture();
        AddState(broken, OtherSelector, historical: true);
        var removed = AddHistoricalPair(broken, Selector);
        broken.Files.Remove(removed.Path);
        broken.Files[Implementation] = "// changed judge\n";
        AssertMissingPair(Assert.Single(Evaluate(broken,
            (Implementation, RawChangeKind.Added),
            (removed.Path, RawChangeKind.Deleted))), Selector);
    }

    [Fact]
    public void FrozenPairRuleIsRegisteredAsActiveAndBlocking()
    {
        var descriptor = Assert.Single(RuleCatalog.Default.Descriptors, item => item.Id.Value == Rule);
        Assert.Equal(AdmissionEffect.Block, descriptor.AdmissionEffect);
        Assert.Equal(RuleLifecycle.Active, descriptor.Lifecycle);
        Assert.Equal("Frozen state and accepted Freeze pairing", descriptor.Title);
    }

    private static void AssertMissingPair(Diagnostic diagnostic, string selector)
    {
        Assert.Equal(AdmissionEffect.Block, diagnostic.AdmissionEffect);
        Assert.Equal(StatePath(selector), diagnostic.Path);
        Assert.Contains("FROZEN_PAIR_MISSING", diagnostic.Message, StringComparison.Ordinal);
        Assert.Contains($"descriptor_selector={selector}", diagnostic.Message, StringComparison.Ordinal);
    }

    private static (string Path, string Hash) AddHistoricalPair(RuleFixture fixture, string selector)
    {
        var accepted = AddFreeze(fixture, selector);
        fixture.Baseline[accepted.Path] = fixture.Files[accepted.Path];
        AddState(fixture, selector, historical: true);
        return accepted;
    }

    private static (string Path, string Hash) AddFreeze(
        RuleFixture fixture,
        string selector,
        char? prerequisite = null)
    {
        var modulePath = RepoPath.CreateKnown(selector);
        var material = new FrozenNodeMaterial(
            modulePath,
            CanonicalStatementWriter.DeclarationStatementIds(modulePath, fixture.Reports[selector]),
            FrozenContentAddress.ComputeModuleStatementId(modulePath, fixture.Reports[selector]),
            FrozenNodeId.Create("sha256:" + new string('0', 64)),
            prerequisite is { } digit ? [FrozenNodeId.Create("sha256:" + new string(digit, 64))] : [],
            []);
        var encoded = FrozenLedgerCanonicalWriter.WriteDagEvent("Freeze",
            FrozenLedgerCanonicalWriter.FreezeElement(FrozenLedgerCanonicalWriter.FreezePayload(material)));
        var path = FrozenLedgerChangeClassifier.AcceptedPath(encoded.Hash);
        fixture.Files[path] = Encoding.UTF8.GetString(encoded.Bytes.AsSpan());
        return (path, encoded.Hash);
    }

    private static void AddState(RuleFixture fixture, string selector, bool historical = false)
    {
        var pin = FrozenContentAddress.ComputeModuleStatementId(
            RepoPath.CreateKnown(selector), fixture.Reports[selector]);
        fixture.Files[StatePath(selector)] = $"{{\"statement_id\":\"{pin.Value}\"}}\n";
        if (historical)
        {
            fixture.Baseline[StatePath(selector)] = fixture.Files[StatePath(selector)];
        }
    }

    private static string StatePath(string selector) =>
        FrozenStatePath.FromModulePath(RepoPath.CreateKnown(selector)).Value;

    private static ImmutableArray<Diagnostic> PairDiagnostics(CompletedRuleSet completed) =>
        completed.Diagnostics.Where(diagnostic => diagnostic.RuleId.Value == Rule).ToImmutableArray();

    private static ImmutableArray<Diagnostic> Evaluate(
        RuleFixture fixture,
        params (string Path, RawChangeKind Kind)[] changes) => PairDiagnostics(Execute(fixture, changes));

    private static CompletedRuleSet Execute(
        RuleFixture fixture,
        params (string Path, RawChangeKind Kind)[] changes) =>
        Assert.IsType<RuleExecutionOutcome.Completed>(RuleCatalog.Default.Execute(
            fixture.Build(RawChangeSet.CreateWithKinds(changes)))).Capability;
}
