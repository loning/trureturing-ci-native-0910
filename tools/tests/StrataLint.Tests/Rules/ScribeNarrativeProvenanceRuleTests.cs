using System.Collections.Immutable;
using System.Text.RegularExpressions;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed class ScribeNarrativeProvenanceRuleTests
{
    private const string PathA = "Blueprint/Test/A.scribe.cs";
    private const string PathB = "Blueprint/Test/B.scribe.cs";
    private const string PathC = "Blueprint/Test/C.scribe.cs";

    [Theory]
    [InlineData("Pointwise equality is required only at nonzero atoms of the evaluated vector.")]
    [InlineData("Each finite index contributes equally weighted Dirac atoms at its address.")]
    [InlineData("The nonempty atoms of a finite observable-event algebra are exactly its effects.")]
    [InlineData("Let K be the type of permission atoms.")]
    [InlineData("the atom mass times the squared value")]
    [InlineData("For every finite set of source atoms, cofinality supplies a finite window containing it.")]
    [InlineData("A source atom of a transport measure has positive mass.")]
    [InlineData("The source coordinate is distinct from the atom's outcome.")]
    [InlineData("the same atom has positive mass")]
    [InlineData("the atom has exact radius one")]
    [InlineData("The atom mass and spectral gap are explicitly positive.")]
    [InlineData("Readouts compile to CUT atoms while points compile to ANCHOR atoms.")]
    [InlineData("At frequency zero and height zero, the atom has norm exactly one.")]
    [InlineData("Finite description codes have canonical PZG tables")]
    [InlineData("The cover has full coverage of the compact set.")]
    [InlineData("Rouch\u00e9 and Fej\u00e9r estimates")]
    [InlineData("\u03c6\u00b2 \u2264 \u03c8")]
    [InlineData("\u2264 \u2265 \u2014 \u2013 \u2026")]
    [InlineData("a verbatim literal containing the ASCII characters backslash u 4 E 2 D")]
    [InlineData("atom; the atom; that atom; same atom; source atom; coverage; receipt")]
    [InlineData("The source atom has mass one. The assertion follows.")]
    [InlineData("The source atom has mass one; the claim follows.")]
    [InlineData("The source atom has mass one: the claim follows.")]
    [InlineData("The source atom has mass one! The claim follows.")]
    [InlineData("The source atom has mass one? The claim follows.")]
    [InlineData("Search the spectrum. A duplicate eigenvalue is allowed.")]
    [InlineData("digestions backfilled subitemized myatom_id theory volumeset")]
    [InlineData("The atom carries positive mass.")]
    [InlineData("The atom covers the bottom element.")]
    [InlineData("The atom is a closed singleton.")]
    [InlineData("The atom lies in a closed set.")]
    [InlineData("The source atom carries positive mass.")]
    [InlineData("The same atom is closed under the operation.")]
    [InlineData("Each atom names a distinct coordinate.")]
    [InlineData("the atom's state is recorded by the register map")]
    [InlineData("the source atom's state is recorded by the register map")]
    [InlineData("The source atom has compact closure.")]
    [InlineData("The closure of each source atom is compact.")]
    [InlineData("The candidate atom lies in the closure of a measurable set.")]
    [InlineData("The atom does not cover the top element.")]
    [InlineData("The anchor atom supports a positive measure.")]
    [InlineData("Each source atom is closed and carries positive mass.")]
    [InlineData("The atom's mass is recorded in the table.")]
    [InlineData("The closure of the atom is a closed set.")]
    public void MathematicalProseIsAllowed(string prose) => Assert.Empty(Evaluate(Text(prose)));

    [Theory]
    [InlineData("The atom's proof skeleton establishes injectivity from coprimality and then obtains surjectivity by counting the two finite carriers.")]
    [InlineData("The atom does not specify the conditional probability law needed to derive the claimed exact expectation.")]
    [InlineData("It does not claim the later numerical extrapolation, decimal values, method assessment, or the registration statements in that atom.")]
    [InlineData("It does not claim that an odd word square is primitive, the balance formula, the trace divisibility statement, the census, or the zero-layer dimension bound stated elsewhere in the same atom.")]
    [InlineData("This theorem closes only the finite-decision clause of the source atom.")]
    public void DocumentaryAtomRelationsAreBlocked(string prose) =>
        AssertClass(Text(prose), "DigestionLedgerReference", "digestion ledger");

    [Theory]
    [InlineData("subitems of the source atom.")]
    [InlineData("itself close the multi-clause corollary atom.")]
    [InlineData("The source atom states an infinite product.")]
    [InlineData("stated elsewhere in that atom.")]
    [InlineData("The atom does not specify the conditional law.")]
    [InlineData("atom generic-residual-0123456789abcdef0123456789abcdef01234567")]
    [InlineData("atom_id: 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef")]
    [InlineData("coverage_gids: []; status: residual-open")]
    [InlineData("digestion backfill receipt")]
    [InlineData("qdo-v1 theorem/38.1")]
    [InlineData("This discharges obligation 57.2-D from definition-escape-completion-theory atom generic-residual-0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef")]
    [InlineData("Meta/Digestion")]
    [InlineData("chain_atoms cas_ref partial-closed absorbed-closed nonpropositional-inapplicable accepted-event unresolved_subitems")]
    [InlineData("atoms sha256:0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef")]
    [InlineData("atom 0123456789abcdef0123456789abcdef01234567")]
    [InlineData("The source atom carries no numerical certificate.")]
    [InlineData("THE SOURCE ATOM ASSERTS the result")]
    [InlineData("definition/1 lemma/2 corollary/3 remark/4 proposition/5 section/6 appendix/7")]
    public void DigestionNarrativeIsBlocked(string prose) =>
        AssertClass(Text(prose), "DigestionLedgerReference", "digestion ledger");

    [Theory]
    [InlineData("The atom ends at the threshold table header.")]
    [InlineData("The container atom carries a pre-committed receipt naming one carrier.")]
    [InlineData("The source atom explicitly reports an omitted hypothesis.")]
    [InlineData("The source atoms never claim the result.")]
    [InlineData("The candidate atom cannot specify the conditional law.")]
    [InlineData("This discharges the corollary atom.")]
    [InlineData("The proof covers only the finite-decision clause of the source atom.")]
    [InlineData("The source atom's numerical certificate is absent.")]
    [InlineData("The source atom's explicit diagonal property is preserved.")]
    [InlineData("The theorem excludes families in that atom.")]
    [InlineData("In that atom, further families remain unresolved.")]
    [InlineData("The postmortem in the same atom is omitted.")]
    public void StructuredDocumentaryAtomGrammarIsBlocked(string prose) =>
        AssertClass(Text(prose), "DigestionLedgerReference", "digestion ledger");

    [Theory]
    [InlineData(60, true)]
    [InlineData(61, false)]
    public void DocumentaryObjectGapIsBounded(int gap, bool blocked)
    {
        var findings = Evaluate(Text("formalizes" + new string(' ', gap) + "source atom"));
        Assert.Equal(blocked, findings.Any());
    }

    [Theory]
    [InlineData(".")]
    [InlineData(";")]
    [InlineData(":")]
    [InlineData("!")]
    [InlineData("?")]
    public void DocumentaryGrammarDoesNotCrossSentenceBoundaries(string boundary)
    {
        Assert.Empty(Evaluate(Text("formalizes" + boundary + " the source atom")));
        Assert.Empty(Evaluate(Text("in that atom" + boundary + " statements follow")));
        Assert.Empty(Evaluate(Text("statements follow" + boundary + " in that atom")));
    }

    [Theory]
    [InlineData("This closes OP4 from DECT part 55")]
    [InlineData("PZG Theorem 6.221")]
    [InlineData("GICT Remark 7.3")]
    [InlineData("docs/develop/theory/x.md")]
    [InlineData("the window remains recorded in the theory volume")]
    [InlineData("pzg-v170")]
    [InlineData("gict-v3.6")]
    [InlineData("cone-v1")]
    [InlineData("qdo-v1 theorem/38.1")]
    [InlineData("BEDC 12.3")]
    [InlineData("FPOD v12")]
    [InlineData("PZG source 3")]
    [InlineData("GICT line 4")]
    public void TheoryNarrativeIsBlocked(string prose) =>
        AssertClass(Text(prose), "TheoryVolumeReference", "theory volume");

    [Theory]
    [InlineData("issue #3066 tracks that gap")]
    [InlineData("correcting the panel brief")]
    [InlineData("Six-route duplicate search covered keyword variants")]
    [InlineData("proof_shape: bind-only. admission_basis: atom-required-bridge.")]
    [InlineData("issue 6057 tracks it")]
    [InlineData("Full-statement library and repository searches found no duplicate of this specialization.")]
    [InlineData("PR #7")]
    [InlineData("pull request")]
    [InlineData("dispatch brief orchestrator")]
    [InlineData("escape_witness escape-witness escape witness")]
    [InlineData("postmortem git-history accepted-event receipts")]
    public void GovernanceNarrativeIsBlocked(string prose) =>
        AssertClass(Text(prose), "GovernanceProcessReference", "governance process");

    [Theory]
    [InlineData("Text(\"\u589e\u8ba2\u5341\");")]
    [InlineData("H(\"A\uff0cB\");")]
    [InlineData("// \u6c49")]
    [InlineData("class C { int x\U00020000; }")]
    [InlineData("Text(\"\u6c49\");")]
    [InlineData("Text(\"\\u4E2D\");")]
    [InlineData("Text(\"\\U00020000\");")]
    [InlineData("Text(\"\\x4E2D\");")]
    [InlineData("Text($\"\\u4E2D {x}\");")]
    public void CjkIsBlockedInSourceAndDecodedLiterals(string source) =>
        Assert.Contains(Evaluate(source), f => f.Message.StartsWith("CjkSourceCharacter U+", StringComparison.Ordinal));

    [Theory]
    [InlineData(0x2E80, 0x2EFF)]
    [InlineData(0x2F00, 0x2FDF)]
    [InlineData(0x3000, 0x303F)]
    [InlineData(0x31C0, 0x31EF)]
    [InlineData(0x3200, 0x33FF)]
    [InlineData(0x3400, 0x4DBF)]
    [InlineData(0x4E00, 0x9FFF)]
    [InlineData(0xF900, 0xFAFF)]
    [InlineData(0xFE10, 0xFE1F)]
    [InlineData(0xFE30, 0xFE4F)]
    [InlineData(0xFE50, 0xFE6F)]
    [InlineData(0xFF00, 0xFFEF)]
    [InlineData(0x20000, 0x2FA1F)]
    [InlineData(0x30000, 0x323AF)]
    public void EveryPinnedCjkBlockIncludesBothEndpoints(int first, int last)
    {
        Assert.NotEmpty(Evaluate("// " + char.ConvertFromUtf32(first)));
        Assert.NotEmpty(Evaluate("// " + char.ConvertFromUtf32(last)));
    }

    [Theory]
    [InlineData("// source atom states a claim")]
    [InlineData("/* source atom states a claim */")]
    [InlineData("/// source atom states a claim\nclass C {}")]
    [InlineData("Text(@\"source atom states a claim\");")]
    [InlineData("Text(\"\"\"source atom states a claim\"\"\");")]
    [InlineData("Text($\"source atom states {x}\");")]
    [InlineData("Text($@\"source atom states {x}\");")]
    [InlineData("Text($\"\"\"source atom states {x}\"\"\");")]
    [InlineData("Text(\"source \" + \"atom states\");")]
    [InlineData("Text((\"source \" + (\"atom \" + \"states\")));")]
    [InlineData("Text(\"source \\u0061tom states\");")]
    [InlineData("Text(\"This closes atom generic-residual-1798510a7ffd337203122c\" + \"e61979bcb8bf790bba93f6b013f118ed868eb5a7c0\");")]
    public void TextCarriersAreDecodedAndConcatenated(string source) =>
        AssertClass(source, "DigestionLedgerReference", "digestion ledger");

    [Theory]
    [InlineData("class C { int finiteDescriptionPZGCode; }")]
    [InlineData("class C { int atom_id, coverage_gids, digestion, proof_shape, orchestrator; }")]
    [InlineData("Text(@\"\\u4E2D\");")]
    [InlineData("Text(\"\"\"\\u4E2D\"\"\");")]
    [InlineData("Text($\"mass {atom_id}\");")]
    [InlineData("Text(\"source \", \"atom states\");")]
    [InlineData("Text($\"source {x}atom states\");")]
    [InlineData("DescribeId.Create(\"candidate-square-tail-v60\")")]
    public void IdentifiersAndUnconnectedTextAreAllowed(string source) => Assert.Empty(Evaluate(source));

    [Fact]
    public void FindingsNameTheClassMatchAndSourceLine()
    {
        var finding = Assert.Single(Evaluate("// clean\nText(\"digestion\");"));
        Assert.Equal("DigestionLedgerReference 'digestion' (line 2): Scribe prose must derive from the Lean declaration, not from the digestion ledger", finding.Message);
        Assert.Equal(PathA, finding.Path);
        var cjk = Assert.Single(Evaluate("// clean\n// \U00020000"));
        Assert.Equal("CjkSourceCharacter U+20000 '\U00020000' (line 2): Blueprint Scribe source must not contain CJK characters", cjk.Message);
    }

    [Fact]
    public void CarriageReturnOnlyLinesDoNotDuplicateCjkFindings()
    {
        var finding = Assert.Single(Evaluate("// clean\r// \u4E2D"));
        Assert.Contains("(line 2)", finding.Message, StringComparison.Ordinal);
    }

    [Fact]
    public void ConcatenatedMatchUsesTheLineOfItsFirstCharacter()
    {
        var finding = Assert.Single(Evaluate("Text(\"clean \" +\n \"diges\" + \"tion\");"));
        Assert.Contains("'digestion' (line 2)", finding.Message, StringComparison.Ordinal);
    }

    [Fact]
    public void LongAsciiCommentStillFindsExactlyOneTrailingViolation()
    {
        var source = "// " + string.Concat(Enumerable.Repeat("a-", 32768)) + " digestion";
        var finding = Assert.Single(Evaluate(source));
        Assert.StartsWith("DigestionLedgerReference 'digestion'", finding.Message);
    }

    [Fact]
    public void NarrativePatternsUseTheNonBacktrackingEngine()
    {
        var classes = new[] { ScribeNarrativeScanner.DigestionLedgerReference,
            ScribeNarrativeScanner.TheoryVolumeReference, ScribeNarrativeScanner.GovernanceProcessReference };
        foreach (var rule in classes)
        foreach (var pattern in new[] { rule.Direct, rule.Subject, rule.Relation }.Concat(rule.Grammar ?? []))
            if (pattern is not null)
            {
                Assert.True(pattern.Options.HasFlag(RegexOptions.NonBacktracking));
                Assert.True(pattern.Options.HasFlag(RegexOptions.IgnoreCase));
            }
    }

    [Fact]
    public void UnchangedViolationOutsideChangesIsIgnored()
    {
        var fixture = Fixture((PathA, Text("digestion"), Text("digestion")));
        Assert.Empty(Diagnostics(fixture.BuildForRuleCompatibility(RawChangeSet.Create([]))));
    }

    [Fact]
    public void RuleImplementationChangeDoesNotJudgeStock()
    {
        var fixture = Fixture((PathA, "// \u6c49 digestion", "// \u6c49 digestion"));
        var context = fixture.BuildForRuleCompatibility(
            RawChangeSet.Create(["tools/StrataLint.Engine/Rules/RepositoryRules.cs"]));
        Assert.True(context.RuleImplementationChanged);
        Assert.Empty(Diagnostics(context));
    }

    [Fact] public void AddedViolationIsBlocked() => Assert.NotEmpty(Evaluate(Text("digestion")));
    [Fact] public void ModifiedBlobIsJudgedInFull() => Assert.NotEmpty(Evaluate(Fixture((PathA, "// digestion", "// digestion\n// clean"))));
    [Fact] public void RemovingViolationIsAllowed() => Assert.Empty(Evaluate(Fixture((PathA, "// digestion", "// clean"))));
    [Fact] public void DeletedViolationIsIgnored() => Assert.Empty(Evaluate(Fixture((PathA, "// digestion", null))));
    [Fact] public void ByteIdenticalMoveIsAllowed() => Assert.Empty(Evaluate(Fixture((PathA, "// digestion", null), (PathB, null, "// digestion"))));
    [Fact] public void MoveWithEditIsBlocked() => Assert.NotEmpty(Evaluate(Fixture((PathA, "// digestion", null), (PathB, null, "// digestion\n"))));

    [Theory]
    [InlineData("\uFEFF// digestion\n", false)]
    [InlineData("// digestion\r\n", false)]
    [InlineData("\uFEFF// digestion\n", true)]
    [InlineData("// digestion\r\n", true)]
    public void ByteDistinctMovesAreBlockedEvenWhenTextIsNormalized(string source, bool normalizeText)
    {
        const string baseline = "// digestion\n";
        var fixture = Fixture((PathA, baseline, null), (PathB, null, source));
        var changes = RawChangeSet.CreateWithKinds(
            [(PathA, RawChangeKind.Deleted), (PathB, RawChangeKind.Added)]);
        var context = fixture.BuildForRuleCompatibility(changes);
        if (normalizeText)
        {
            var path = context.Current.Files.Keys.Single(p => p.Value == PathB);
            var file = context.Current.Files[path];
            var current = RepositorySnapshot.Create(context.Current.Files.SetItem(path,
                new RepositoryFile(path, file.RawBytes, baseline)));
            context = RuleEvaluationContext.Create(current, context.Baseline, context.Policy,
                context.Lean, context.Changes, context.MetaEvaluation);
        }
        Assert.Single(Diagnostics(context));
    }

    [Fact]
    public void OneDeletionCannotExemptTwoAdditions()
    {
        var findings = Evaluate(Fixture((PathA, "// digestion", null), (PathB, null, "// digestion"), (PathC, null, "// digestion")));
        Assert.Equal(new[] { PathB, PathC }, findings.Select(f => f.Path).Order(StringComparer.Ordinal));
    }

    [Fact]
    public void UnchangedFileCannotExemptACopy()
    {
        var fixture = Fixture((PathA, "// digestion", "// digestion"), (PathB, null, "// digestion"));
        var changes = RawChangeSet.CreateWithKinds([(PathB, RawChangeKind.Copied)]);
        Assert.Single(Diagnostics(fixture.BuildForRuleCompatibility(changes)));
    }

    [Theory]
    [InlineData("Blueprint/Test/A.md")]
    [InlineData("Blueprint/Test/A.lean")]
    [InlineData("tools/Test/A.scribe.cs")]
    [InlineData("Papers/Test/A.scribe.cs")]
    public void OtherPathsAreIgnored(string path) => Assert.Empty(Evaluate(Fixture((path, null, "// \u6c49 digestion"))));

    [Fact]
    public void RuleIsAnActiveBlockingRepositoryRule()
    {
        var descriptor = Assert.Single(RuleCatalog.Default.Descriptors, d => d.Id == RuleId.CreateKnown(32));
        Assert.Equal(AdmissionEffect.Block, descriptor.AdmissionEffect);
        Assert.Equal(RuleLifecycle.Active, descriptor.Lifecycle);
        Assert.Equal("repository", descriptor.Category);
        Assert.Equal("Scribe narrative provenance", descriptor.Title);
    }

    private static string Text(string prose) => "Text(\"" + prose + "\");";

    private static void AssertClass(string source, string name, string layer) =>
        Assert.Contains(Evaluate(source), f => f.Message.StartsWith(name + " '", StringComparison.Ordinal)
            && f.Message.EndsWith("not from the " + layer, StringComparison.Ordinal));

    private static ImmutableArray<RuleFinding> Evaluate(string source) => Evaluate(Fixture((PathA, null, source)));

    private static ImmutableArray<RuleFinding> Evaluate(RuleFixture fixture)
    {
        var changes = RawChangeSet.CreateWithKinds(fixture.Changes.Select(path =>
            (path, !fixture.Files.ContainsKey(path) ? RawChangeKind.Deleted
                : fixture.Baseline.ContainsKey(path) ? RawChangeKind.Modified : RawChangeKind.Added)));
        return Diagnostics(fixture.BuildForRuleCompatibility(changes));
    }

    private static ImmutableArray<RuleFinding> Diagnostics(RuleEvaluationContext context) =>
        RuleCatalog.Default.EvaluateSingle(RuleId.CreateKnown(32), context).Diagnostics
            .Select(d => new RuleFinding(d.Path, d.Message)).ToImmutableArray();

    private static RuleFixture Fixture(params (string Path, string? Baseline, string? Current)[] files)
    {
        var fixture = new RuleFixture();
        fixture.Changes.Clear();
        foreach (var (path, baseline, current) in files)
        {
            fixture.Baseline.Remove(path);
            fixture.Files.Remove(path);
            if (baseline is not null) fixture.Baseline[path] = baseline;
            if (current is not null) fixture.Files[path] = current;
            fixture.Changes.Add(path);
        }
        return fixture;
    }
}
