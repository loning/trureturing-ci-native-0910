using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed class NativeDecideAdmissionTests
{
    private const string Path = "D5/S0/Carrier/Anonymous.lean";

    [Fact]
    public void ProductionAdmissionRejectsAnonymousNativeDecideWithEmptyReport()
    {
        var context = Candidate("native_decide");
        var completed = Assert.IsType<RuleExecutionOutcome.Completed>(RuleCatalog.Default.Execute(context)).Capability;
        Assert.Contains(completed.ExecutedRules, id => id.Value == "SL-035");
        var diagnostic = Assert.Single(completed.Diagnostics, item => item.AdmissionEffect == AdmissionEffect.Block);
        Assert.Equal("SL-035", diagnostic.RuleId.Value);
        Assert.Equal(Path, diagnostic.Path);
        Assert.Equal("NATIVE_DECIDE_SOURCE line=8: bare native_decide token is forbidden in changed D5 Lean source", diagnostic.Message);
        var rejected = Assert.IsType<AdmissionOutcome.RuleRejected>(Admit(context));
        Assert.Contains(diagnostic, rejected.Diagnostics);
    }

    [Fact]
    public void ProductionAdmissionAcceptsPairedKernelDecideWithEmptyReport()
    {
        var context = Candidate("decide");
        var completed = Assert.IsType<RuleExecutionOutcome.Completed>(RuleCatalog.Default.Execute(context)).Capability;
        Assert.Contains(completed.ExecutedRules, id => id.Value == "SL-035");
        Assert.DoesNotContain(completed.Diagnostics, item => item.AdmissionEffect == AdmissionEffect.Block);
        Assert.IsType<AdmissionOutcome.Admitted>(Admit(context));
    }

    [Theory]
    [InlineData("\u2211'", false)]
    [InlineData("\u220f'", false)]
    [InlineData("\u2211'", true)]
    [InlineData("\u220f'", true)]
    public void ProductionAdmissionAcceptsPrimeNotationInSelectedOrUnchangedSource(string notation, bool historical)
    {
        var source = "import Mathlib.Topology.Algebra.InfiniteSum.Defs\n"
            + $"example (f : Nat -> Nat) : ({notation} n, f n) = ({notation} n, f n) := rfl\n";
        var context = Candidate("decide", historical ? string.Empty : source, historical ? source : null);
        var completed = Assert.IsType<RuleExecutionOutcome.Completed>(RuleCatalog.Default.Execute(context)).Capability;

        Assert.Contains(completed.ExecutedRules, id => id.Value == "SL-008");
        Assert.Contains(completed.ExecutedRules, id => id.Value == "SL-035");
        Assert.DoesNotContain(completed.Diagnostics, item => item.AdmissionEffect == AdmissionEffect.Block);
        Assert.IsType<AdmissionOutcome.Admitted>(Admit(context));
    }

    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public void ProductionAdmissionAcceptsImageNotationInSelectedOrUnchangedSource(bool historical)
    {
        const string source = "import Mathlib.Data.Set.Image\n"
            + "example (f : Nat -> Nat) (s : Set Nat) : f '' s = f '' s := rfl\n";
        var context = Candidate("decide", historical ? string.Empty : source, historical ? source : null,
            sourceImport: "Mathlib.Data.Set.Image");
        var completed = Assert.IsType<RuleExecutionOutcome.Completed>(RuleCatalog.Default.Execute(context)).Capability;

        Assert.Contains(completed.ExecutedRules, id => id.Value == "SL-008");
        Assert.Contains(completed.ExecutedRules, id => id.Value == "SL-035");
        Assert.DoesNotContain(completed.Diagnostics, item => item.AdmissionEffect == AdmissionEffect.Block);
        Assert.IsType<AdmissionOutcome.Admitted>(Admit(context));
    }

    [Fact]
    public void ProductionAdmissionRejectsNativeDecideFollowingImageNotation()
    {
        const string source = "import Mathlib.Data.Set.Image\n"
            + "example (f : Nat -> Nat) (s : Set Nat) : f '' s = f '' s := rfl\n";
        var context = Candidate("native_decide", source, sourceImport: "Mathlib.Data.Set.Image");
        var completed = Assert.IsType<RuleExecutionOutcome.Completed>(RuleCatalog.Default.Execute(context)).Capability;
        Assert.Contains(completed.ExecutedRules, id => id.Value == "SL-035");
        var diagnostic = Assert.Single(completed.Diagnostics, item => item.AdmissionEffect == AdmissionEffect.Block);
        Assert.Equal("SL-035", diagnostic.RuleId.Value);
        Assert.Equal(Path, diagnostic.Path);
        Assert.Equal("NATIVE_DECIDE_SOURCE line=10: bare native_decide token is forbidden in changed D5 Lean source", diagnostic.Message);
        var rejected = Assert.IsType<AdmissionOutcome.RuleRejected>(Admit(context));
        Assert.Contains(diagnostic, rejected.Diagnostics);
    }

    private static RuleEvaluationContext Candidate(string tactic, string prefix = "", string? historicalSource = null,
        string sourceImport = "Mathlib.Topology.Algebra.InfiniteSum.Defs")
    {
        var fixture = new RuleFixture();
        fixture.AddBackfillTargets();
        fixture.Files[Path] = "/- GID: D5/S0/Carrier/Anonymous\n"
            + "   generality: G\n"
            + "   mirror-B: none(waiver:test-fixture)\n"
            + "   mirror-E: none(waiver:test-fixture)\n"
            + "   anchors: []\n"
            + "   utility: none\n"
            + "   digest: Anonymous source admission fixture. -/\n"
            + prefix
            + $"example : True := by {tactic}\n";
        fixture.Reports[Path] = new LeanFileReport(
            prefix.Length == 0 ? [] : [sourceImport], []);
        if (historicalSource is not null)
        {
            fixture.Files[RuleFixture.RingPath] = historicalSource + fixture.Files[RuleFixture.RingPath];
            fixture.Baseline[RuleFixture.RingPath] = fixture.Files[RuleFixture.RingPath];
            fixture.Reports[RuleFixture.RingPath] = fixture.Reports[RuleFixture.RingPath] with
            {
                Imports = [sourceImport],
            };
            fixture.BaselineReports[RuleFixture.RingPath] = fixture.Reports[RuleFixture.RingPath];
        }
        Assert.Empty(fixture.Reports[Path].Declarations);
        return fixture.Build(RawChangeSet.CreateWithKinds([(Path, RawChangeKind.Added)]));
    }

    private static AdmissionOutcome Admit(RuleEvaluationContext context) => AdmissionPipeline.Evaluate(
        context.Current, context.Baseline, context.Policy, context.Lean, context.Changes,
        Assert.IsType<BootstrapOutcome.Clear>(BootstrapGate.Evaluate(context.Changes)).Capability);
}
