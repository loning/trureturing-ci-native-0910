using System.Collections.Immutable;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed class NativeDecideSourceRuleTests
{
    private const string Rule = "SL-035";
    private const string Path = "D5/S0/Carrier/NativeProbe.lean";
    private const string Implementation = "tools/StrataLint.Engine/Rules/NativeDecideSourceRule.cs";

    [Theory]
    [InlineData("example : True := by native_decide", 1)]
    [InlineData("theorem named : True := by native_decide", 1)]
    [InlineData("example : True := by\n  first | native_decide | trivial", 2)]
    [InlineData("example : True := by\n  have h : True := by native_decide\n  exact h", 2)]
    [InlineData("def quoted := `(tactic| native_decide)", 1)]
    [InlineData("def text := s!\"value {(Fin.mk 1 (by native_decide) : Fin 2)}\"", 1)]
    [InlineData("def text := m!\"value {(Fin.mk 1 (by native_decide) : Fin 2)}\"", 1)]
    [InlineData("def text := f!\"value {(Fin.mk 1 (by native_decide) : Fin 2)}\"", 1)]
    [InlineData("def text := s!\"outer {s!\"inner {(Fin.mk 1 (by native_decide) : Fin 2)}\"}\"", 1)]
    [InlineData("def text := s!\"native_decide\n{(Fin.mk 1 (by\n  native_decide) : Fin 2)}\"", 3)]
    [InlineData("def c := ')'\nexample : True := by native_decide", 2)]
    [InlineData("def c := '\\''\nexample : True := by native_decide", 2)]
    [InlineData("def text := r##\"quotes \" native_decide\"##\nexample : True := by native_decide", 2)]
    [InlineData("/- outer /- native_decide -/ -/\r\nexample : True := by native_decide", 2)]
    public void RejectsBareCodeTokensWithSourceLine(string source, int line)
    {
        var fixture = Source(source);
        var diagnostic = Assert.Single(Evaluate(fixture, (Path, RawChangeKind.Added)));

        Assert.Equal(Path, diagnostic.Path);
        Assert.Equal(AdmissionEffect.Block, diagnostic.AdmissionEffect);
        Assert.Equal(DisplaySeverity.Error, diagnostic.DisplaySeverity);
        Assert.Equal($"NATIVE_DECIDE_SOURCE line={line}: bare native_decide token is forbidden in changed D5 Lean source", diagnostic.Message);
        Assert.Equal($"SL-035 {Path}: {diagnostic.Message}", diagnostic.Render());
    }

    [Theory]
    [InlineData("example : True := by decide")]
    [InlineData("-- native_decide\nexample : True := by decide")]
    [InlineData("/- native_decide /- nested native_decide -/ still inert -/\nexample : True := by decide")]
    [InlineData("def text := \"native_decide -- /- \\\" native_decide\"")]
    [InlineData("def text := r#\"quotes \" native_decide /- (\"#")]
    [InlineData("def text := r##\"quotes \"# native_decide -- )\"##")]
    [InlineData("def c := ')'")]
    [InlineData("def c := '\\''")]
    [InlineData("def name := `native_decide")]
    [InlineData("def name := ``native_decide")]
    [InlineData("def \u00abnative_decide\u00bb : Nat := 0")]
    [InlineData("def \u00ab/- native_decide )\u00bb : Nat := 0")]
    [InlineData("def native_decide! : Nat := 0\ndef native_decide? : Nat := 0")]
    [InlineData("def native_decide' : Nat := 0\ndef native_decide_extra : Nat := 0")]
    [InlineData("def native_decide\u2127 : Nat := 0")]
    [InlineData("def native_decide\U0001d49c : Nat := 0")]
    [InlineData("def \U0001d49c.native_decide : Nat := 0")]
    [InlineData("def other_native_decide : Nat := 0\ndef native_decide1 : Nat := 0")]
    [InlineData("def N.native_decide : Nat := 0\ndef native_decide.suffix : Nat := 0")]
    [InlineData("def text := s!\"native_decide {(Fin.mk 1 (by decide) : Fin 2)}\"")]
    [InlineData("def text := s!\"escaped \\{native_decide} {\"native_decide\"}\"")]
    [InlineData("def text := s!\"{(let c := '}'; \"native_decide\")}\"")]
    public void AcceptsInertSpellingsAndKernelDecide(string source)
    {
        Assert.Empty(Evaluate(Source(source), (Path, RawChangeKind.Added)));
    }

    [Theory]
    [InlineData("\n/- native_decide", 2)]
    [InlineData("\n\"native_decide", 2)]
    [InlineData("\nr#\"native_decide", 2)]
    [InlineData("\n\u00abnative_decide", 2)]
    [InlineData("\n'(", 2)]
    [InlineData("\ns!\"{(by native_decide : True)\"", 2)]
    [InlineData("\nexample : True := by (native_decide", 2)]
    public void MalformedLexicalInputBlocksWithLocation(string source, int line)
    {
        var diagnostic = Assert.Single(Evaluate(Source(source), (Path, RawChangeKind.Added)));
        Assert.Equal(Path, diagnostic.Path);
        Assert.Equal(AdmissionEffect.Block, diagnostic.AdmissionEffect);
        Assert.StartsWith($"NATIVE_DECIDE_LEXICAL_ERROR line={line}:", diagnostic.Message, StringComparison.Ordinal);
    }

    [Theory]
    [InlineData(RawChangeKind.Added)]
    [InlineData(RawChangeKind.Modified)]
    [InlineData(RawChangeKind.Copied)]
    public void NewDestinationIsScannedRegardlessOfChangeKind(RawChangeKind kind)
    {
        Assert.Single(Evaluate(Source("example : True := by native_decide"), (Path, kind)));
    }

    [Fact]
    public void RenameDestinationIsScannedWhenOriginalIsDeleted()
    {
        const string original = "D5/S0/Carrier/Original.lean";
        var fixture = Source("example : True := by native_decide");
        fixture.Baseline[original] = fixture.Files[Path];
        Assert.Single(Evaluate(fixture, (original, RawChangeKind.Deleted), (Path, RawChangeKind.Added)));
    }

    [Fact]
    public void ModifiedFrozenFileScansOldUseOutsideEditedHunk()
    {
        var fixture = Source("example : True := by native_decide\n", baseline: true);
        const string state = "Golden/Frozen/state/" + Path + ".json";
        fixture.Files[state] = fixture.Baseline[state] = "{\"statement_id\":\"sha256:" + new string('0', 64) + "\"}\n";
        fixture.Files[Path] += "-- only this comment was changed\n";
        var diagnostic = Assert.Single(Evaluate(fixture, (Path, RawChangeKind.Modified)));
        Assert.StartsWith("NATIVE_DECIDE_SOURCE line=1:", diagnostic.Message, StringComparison.Ordinal);
    }

    [Fact]
    public void LineEndingByteChangeIsInsideDelta()
    {
        var fixture = Source("example : True := by native_decide\r\n", baseline: true);
        fixture.Files[Path] = "example : True := by native_decide\n";
        Assert.Single(Evaluate(fixture, (Path, RawChangeKind.Modified)));
    }

    [Theory]
    [InlineData(RawChangeKind.Added)]
    [InlineData(RawChangeKind.Modified)]
    [InlineData(RawChangeKind.Copied)]
    public void IdenticalBytesAreOutsideDelta(RawChangeKind kind)
    {
        var fixture = Source("example : True := by native_decide", baseline: true);
        Assert.Empty(Evaluate(fixture, (Path, kind)));
        AssertSkipped(fixture, (Path, kind));
    }

    [Fact]
    public void DeletedFileIsOutsideDelta()
    {
        var fixture = Source("example : True := by native_decide", baseline: true);
        fixture.Files.Remove(Path);
        fixture.Reports.Remove(Path);
        Assert.Empty(Evaluate(fixture, (Path, RawChangeKind.Deleted)));
        AssertSkipped(fixture, (Path, RawChangeKind.Deleted));
    }

    [Theory]
    [InlineData("docs/new-note.md")]
    [InlineData("D5/S0/Carrier/Another.lean")]
    [InlineData(Implementation)]
    [InlineData("tools/StrataLint.Engine/Ledger/Admission/LeanSourceTokenizer.cs")]
    public void UnchangedHistoryIsIgnoredWhenOtherInputsChange(string changed)
    {
        var fixture = Source("example : True := by native_decide", baseline: true);
        fixture.Files[changed] = "-- candidate change\n";
        if (changed.EndsWith(".lean", StringComparison.Ordinal))
        {
            fixture.Reports[changed] = new LeanFileReport([], []);
        }

        Assert.Empty(Evaluate(fixture, (changed, RawChangeKind.Added)));
        var completed = Execute(fixture, (changed, RawChangeKind.Added));
        Assert.DoesNotContain(completed.Diagnostics, diagnostic => diagnostic.RuleId.Value == Rule);
        Assert.Equal(changed.EndsWith(".lean", StringComparison.Ordinal), completed.ExecutedRules.Any(id => id.Value == Rule));
    }

    [Theory]
    [InlineData("Trureturing.lean")]
    [InlineData("Other/Probe.lean")]
    [InlineData("D5/Probe.txt")]
    public void NonD5LeanPathsAreNotSelected(string path)
    {
        var fixture = new RuleFixture();
        fixture.Files[path] = "native_decide\n";
        if (path.EndsWith(".lean", StringComparison.Ordinal))
        {
            fixture.Reports[path] = new LeanFileReport([], []);
        }

        Assert.Empty(Evaluate(fixture, (path, RawChangeKind.Added)));
    }

    [Fact]
    public void AllSelectedPathsAndOccurrencesAreReportedOnce()
    {
        const string second = "D5/S0/Carrier/Second.lean";
        var fixture = Source("example : True := by native_decide\nexample : True := by native_decide");
        fixture.Files[second] = "example : True := by native_decide";
        fixture.Reports[second] = new LeanFileReport([], []);
        var diagnostics = Evaluate(fixture, (second, RawChangeKind.Added), (Path, RawChangeKind.Added));
        Assert.Equal(new[] { Path, Path, second }, diagnostics.Select(static item => item.Path));
        Assert.Equal(3, diagnostics.Length);
        Assert.Contains("line=2:", diagnostics[1].Message, StringComparison.Ordinal);
    }

    [Fact]
    [BaseFactScopeProbe(35)]
    public void Sl035ScopesHistoryAndDoesNotBroadenOnImplementationChange()
    {
        var fixture = Source("example : True := by native_decide", baseline: true);
        fixture.Files[Implementation] = "// judge delta\n";
        AssertSkipped(fixture, (Implementation, RawChangeKind.Modified));
        fixture.Files[Path] += "\n-- changed\n";
        var completed = Execute(fixture, (Implementation, RawChangeKind.Modified), (Path, RawChangeKind.Modified));
        Assert.Contains(completed.ExecutedRules, id => id.Value == Rule);
        Assert.Single(completed.Diagnostics, diagnostic => diagnostic.RuleId.Value == Rule);
    }

    [Fact]
    public void RegisteredAsActiveBlockingSourceRule()
    {
        var descriptor = Assert.Single(RuleCatalog.Default.Descriptors, item => item.Id.Value == Rule);
        Assert.Equal(AdmissionEffect.Block, descriptor.AdmissionEffect);
        Assert.Equal(RuleLifecycle.Active, descriptor.Lifecycle);
        Assert.Equal("Native decide source prohibition", descriptor.Title);
    }

    private static RuleFixture Source(string source, bool baseline = false)
    {
        var fixture = new RuleFixture();
        fixture.Files[Path] = source;
        fixture.Reports[Path] = new LeanFileReport([], []);
        if (baseline)
        {
            fixture.Baseline[Path] = source;
            fixture.BaselineReports[Path] = fixture.Reports[Path];
        }

        return fixture;
    }

    private static ImmutableArray<Diagnostic> Evaluate(RuleFixture fixture, params (string Path, RawChangeKind Kind)[] changes)
    {
        var descriptor = Assert.Single(RuleCatalog.Default.Descriptors, item => item.Id.Value == Rule);
        return RuleCatalog.Default.EvaluateSingle(descriptor.Id, fixture.Build(RawChangeSet.CreateWithKinds(changes))).Diagnostics;
    }

    private static CompletedRuleSet Execute(RuleFixture fixture, params (string Path, RawChangeKind Kind)[] changes) =>
        Assert.IsType<RuleExecutionOutcome.Completed>(RuleCatalog.Default.Execute(fixture.Build(RawChangeSet.CreateWithKinds(changes)))).Capability;

    private static void AssertSkipped(RuleFixture fixture, params (string Path, RawChangeKind Kind)[] changes)
    {
        var completed = Execute(fixture, changes);
        Assert.Contains(completed.SkippedRules, id => id.Value == Rule);
        Assert.DoesNotContain(completed.Diagnostics, diagnostic => diagnostic.RuleId.Value == Rule);
    }
}
