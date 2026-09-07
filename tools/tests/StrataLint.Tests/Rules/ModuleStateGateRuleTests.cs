using System.Collections.Immutable;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed class ModuleStateGateRuleTests
{
    private const string Rule = "SL-034";
    private const string ClosedPath = "D5/S0/Carrier/NewClosed.lean";
    private const string FrontierPath = "D5/X_Frontier/SyntheticOpen.lean";
    private const string TailPath = "D5/X_Assumptions/SyntheticTail.lean";

    [Fact]
    public void AddedClosedModuleWithoutStateBlocksAndNamesModule()
    {
        var fixture = new RuleFixture();
        AddModule(fixture, ClosedPath, "def newClosed : Nat := 0", []);

        var diagnostic = Assert.Single(Evaluate(
            fixture,
            (ClosedPath, RawChangeKind.Added)));

        Assert.Equal(AdmissionEffect.Block, diagnostic.AdmissionEffect);
        Assert.Equal(ClosedPath, diagnostic.Path);
        Assert.Contains(ClosedPath, diagnostic.Message, StringComparison.Ordinal);
    }

    [Fact]
    public void AddedClosedModuleWithStateIsAllowed()
    {
        var fixture = new RuleFixture();
        AddModule(fixture, ClosedPath, "def newClosed : Nat := 0", []);
        AddState(fixture, ClosedPath);

        Assert.Empty(Evaluate(
            fixture,
            (ClosedPath, RawChangeKind.Added),
            (StatePath(ClosedPath), RawChangeKind.Added)));
    }

    [Fact]
    public void AddedFrontierModuleWithoutStateIsAllowed()
    {
        var fixture = new RuleFixture();
        AddModule(fixture, FrontierPath, "def syntheticOpen : Nat := 0", []);

        Assert.Empty(Evaluate(fixture, (FrontierPath, RawChangeKind.Added)));
    }

    [Fact]
    public void AddedNonClosedModuleWithoutStateIsAllowed()
    {
        var fixture = new RuleFixture();
        AddModule(fixture, TailPath, "axiom syntheticTail : True", [
            new LeanDeclaration(
                "syntheticTail",
                "axiom",
                "True",
                ImmutableArray<string>.Empty),
        ]);

        Assert.Empty(Evaluate(fixture, (TailPath, RawChangeKind.Added)));
    }

    [Fact]
    public void ExistingUnfrozenBaselineModuleIsIgnoredWhenCandidateDoesNotTouchIt()
    {
        var fixture = new RuleFixture();
        AddModule(fixture, ClosedPath, "def existingClosed : Nat := 0", []);
        fixture.Baseline[ClosedPath] = fixture.Files[ClosedPath];
        fixture.BaselineReports[ClosedPath] = fixture.Reports[ClosedPath];
        fixture.Files["docs/new-note.md"] = "fixture\n";

        var completed = Execute(fixture, ("docs/new-note.md", RawChangeKind.Added));

        Assert.DoesNotContain(completed.ExecutedRules, id => id.Value == Rule);
        Assert.Empty(Diagnostics(completed));
    }

    [Fact]
    [BaseFactScopeProbe(34)]
    public void Sl034ScopesCandidateWithoutD5Module()
    {
        var fixture = new RuleFixture();
        fixture.Files["docs/new-note.md"] = "fixture\n";

        var completed = Execute(fixture, ("docs/new-note.md", RawChangeKind.Added));

        Assert.DoesNotContain(completed.ExecutedRules, id => id.Value == Rule);
        Assert.Empty(Diagnostics(completed));
    }

    [Fact]
    public void ModuleStateGateIsRegisteredAsActiveAndBlocking()
    {
        var descriptor = Assert.Single(RuleCatalog.Default.Descriptors, item => item.Id.Value == Rule);
        Assert.Equal(AdmissionEffect.Block, descriptor.AdmissionEffect);
        Assert.Equal(RuleLifecycle.Active, descriptor.Lifecycle);
        Assert.Equal("Closed Lean modules require frozen state", descriptor.Title);
    }

    private static void AddModule(
        RuleFixture fixture,
        string path,
        string declaration,
        IEnumerable<LeanDeclaration> declarations)
    {
        var gid = path[..^".lean".Length];
        fixture.Files[path] = $"/- GID: {gid}\n"
            + "   generality: G\n"
            + "   mirror-B: none(waiver:test-fixture)\n"
            + "   mirror-E: none(waiver:test-fixture)\n"
            + "   anchors: []\n"
            + "   digest: StrataLint fixture. -/\n"
            + declaration + "\n";
        fixture.Reports[path] = new LeanFileReport(
            ImmutableArray<string>.Empty,
            declarations.ToImmutableArray());
    }

    private static void AddState(RuleFixture fixture, string modulePath)
    {
        var statePath = StatePath(modulePath);
        fixture.Files[statePath] = "{\"statement_id\":\"sha256:"
            + new string('0', 64)
            + "\"}\n";
    }

    private static string StatePath(string modulePath) =>
        "Golden/Frozen/state/" + modulePath + ".json";

    private static ImmutableArray<Diagnostic> Diagnostics(CompletedRuleSet completed) =>
        completed.Diagnostics
            .Where(diagnostic => diagnostic.RuleId.Value == Rule)
            .ToImmutableArray();

    private static ImmutableArray<Diagnostic> Evaluate(
        RuleFixture fixture,
        params (string Path, RawChangeKind Kind)[] changes) =>
        Diagnostics(Execute(fixture, changes));

    private static CompletedRuleSet Execute(
        RuleFixture fixture,
        params (string Path, RawChangeKind Kind)[] changes) =>
        Assert.IsType<RuleExecutionOutcome.Completed>(RuleCatalog.Default.Execute(
            fixture.Build(RawChangeSet.CreateWithKinds(changes)))).Capability;
}
