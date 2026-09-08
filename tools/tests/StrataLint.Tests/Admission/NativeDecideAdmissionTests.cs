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

    private static RuleEvaluationContext Candidate(string tactic)
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
            + $"example : True := by {tactic}\n";
        fixture.Reports[Path] = new LeanFileReport([], []);
        Assert.Empty(fixture.Reports[Path].Declarations);
        return fixture.Build(RawChangeSet.CreateWithKinds([(Path, RawChangeKind.Added)]));
    }

    private static AdmissionOutcome Admit(RuleEvaluationContext context) => AdmissionPipeline.Evaluate(
        context.Current, context.Baseline, context.Policy, context.Lean, context.Changes,
        Assert.IsType<BootstrapOutcome.Clear>(BootstrapGate.Evaluate(context.Changes)).Capability);
}
