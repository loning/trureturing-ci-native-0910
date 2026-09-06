using static StrataLint.Scribe.DefinitionDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S1.Digit;

internal sealed class GreedyFloorSqrtRunBlocksDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S1/Digit/GreedyFloorSqrtRunBlocks.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The greedy floor-square-root sequence has exactly the conjectured decreasing runs.",
        H("Greedy Floor-Square-Root Run Blocks"),
        Blocks(
            Paragraph(Text(
                "OEIS A399084, submitted by Vasilios Mavroudis on 2026-08-18, gives the "
                    + "history-dependent sequence and records the run-length pattern as a "
                    + "conjecture. The definitions and proofs here were first derived in this "
                    + "repository; no external proof is claimed.")),
            Paragraph(Text(
                "Every displayed variable ranges over the natural numbers unless another "
                    + "domain is shown. Arithmetic is natural-number arithmetic: natSub is "
                    + "truncated subtraction, floorSqrt is the natural square root, and "
                    + "groupOf(n) abbreviates natDiv(floorSqrt(4n+5)-1,2). Thus natural "
                    + "division is integer division, never rational division.")),
            Describe.Lean(
                DescribeId.Create("literal-history-dependent-sequence"),
                DeclarationHandle.Create(Prefix + "seq"),
                H("Literal history-dependent sequence"),
                StatementSource.FromAuthor(F.Disp(SeqDefinition())),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The public sequence is the value field of a private prefix state. State "
                        + "zero is (0,{0}), state one is (1,{0,1}), and each later state tests "
                        + "value-1 against the accumulated finite set before either adding "
                        + "floorSqrt(value) or accepting that predecessor. The next value is "
                        + "inserted into the same history, so the definition implements the "
                        + "literal OEIS rule rather than a recurrence that assumes a closed form."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("sequence-value-at-zero"),
                DeclarationHandle.Create(Prefix + "seq_zero"),
                H("Sequence value at zero"),
                StatementSource.FromAuthor(F.Disp(Equal(At("seq", Num(0)), Num(0)))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The initial prefix state has value zero."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sequence-value-at-one"),
                DeclarationHandle.Create(Prefix + "seq_one"),
                H("Sequence value at one"),
                StatementSource.FromAuthor(F.Disp(Equal(At("seq", Num(1)), Num(1)))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The second prefix state has value one."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("literal-unused-predecessor-rule"),
                DeclarationHandle.Create(Prefix + "seq_succ_succ"),
                H("Literal unused-predecessor rule"),
                StatementSource.FromAuthor(F.Disp(ForAll("n", SequenceRule("seq",
                    Add(Id("n"), Num(2)), Add(Id("n"), Num(1)),
                    Add(Add(Id("n"), Num(1)), Num(1)))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "At index n+2 the candidate is seq(n+1)-1. Membership is tested in the "
                        + "image of seq on range((n+1)+1), exactly the indices already present. "
                        + "A seen candidate triggers the floor-square-root jump; an unseen one "
                        + "becomes the next value."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("four-block-group-start"),
                DeclarationHandle.Create(Prefix + "groupStart"),
                H("Four-block group start"),
                StatementSource.FromAuthor(F.Disp(ForAll("m", Equal(
                    At("groupStart", Id("m")), GroupStart(Id("m")))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For parameter m, the four consecutive blocks begin at s=m^2+m-1."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("explicit-four-block-closed-form"),
                DeclarationHandle.Create(Prefix + "closedForm"),
                H("Explicit four-block closed form"),
                StatementSource.FromAuthor(F.Disp(ClosedFormDefinition())),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For n below five the value is n. Otherwise m=groupOf(n), "
                        + "s=groupStart(m), and r=n-s. The four branches are respectively "
                        + "s+m-1-r, s+m, s+3m+1-r, and s+2m+1, with tests r<m, r=m, "
                        + "and r<=2m. This is the preregistered candidate without an "
                        + "equivalent replacement."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("square-interval-invariant"),
                DeclarationHandle.Create(Prefix + "interval_invariant"),
                H("Square interval invariant"),
                StatementSource.FromAuthor(F.Disp(IntervalInvariant())),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Writing s=groupStart(m), the ten displayed inequalities place s-1, s, "
                        + "s+m, and s+m+1 between m^2 and (m+1)^2, while s+2m+1 lies "
                        + "between (m+1)^2 and (m+2)^2. These bounds fix all five natural "
                        + "square roots used at the jump boundaries."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("closed-form-obeys-literal-rule"),
                DeclarationHandle.Create(Prefix + "closedForm_follows_rule"),
                H("Closed form obeys the literal rule"),
                StatementSource.FromAuthor(F.Disp(ForAll("N", Implies(
                    Le(Num(2), Id("N")),
                    SequenceRule("closedForm", Id("N"), NatSub(Id("N"), Num(1)), Id("N")))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Involutivity makes membership in the closed-form history equivalent to "
                        + "closedForm(x)<N. The square bounds then determine each jump, and an "
                        + "exhaustive split across the four offsets proves the exact recursive "
                        + "equation."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("recursive-sequence-equals-closed-form"),
                DeclarationHandle.Create(Prefix + "seq_eq_closedForm"),
                H("Recursive sequence equals the closed form"),
                StatementSource.FromAuthor(F.Disp(ForAll("n", Equal(
                    At("seq", Id("n")), At("closedForm", Id("n")))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Strong induction transports the literal history image from seq to the "
                        + "closed form and applies the preceding rule theorem at each index."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sequence-values-in-four-blocks"),
                DeclarationHandle.Create(Prefix + "seq_four_blocks"),
                H("Sequence values in four blocks"),
                StatementSource.FromAuthor(F.Disp(FourBlocks())),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every m at least two and s=groupStart(m), the first m values descend "
                        + "from s+m-1 to s, the next value is fixed, the following m values "
                        + "descend from s+2m to s+m+1, and the final value is fixed."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("maximal-decreasing-run-predicate"),
                DeclarationHandle.Create(Prefix + "IsMaximalDecreasingRun"),
                H("Maximal decreasing run predicate"),
                StatementSource.FromAuthor(F.Disp(MaximalRunDefinition())),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "A run has positive length, decreases at every internal adjacent pair, "
                        + "cannot be extended to the left unless it starts at zero, and cannot "
                        + "be extended to the right. The last condition compares indices "
                        + "start+len-1 and start+len."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("complete-maximal-run-classification"),
                DeclarationHandle.Create(Prefix + "maximal_decreasing_run_lengths"),
                H("Complete maximal-run classification"),
                StatementSource.FromAuthor(F.Disp(MaximalRunClassification())),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The maximal runs are exactly the five initial singleton runs and, for "
                        + "each m at least two, runs (s,m), (s+m,1), (s+m+1,m), and "
                        + "(s+2m+1,1), where s=groupStart(m). Consequently their lengths are "
                        + "1,1,1,1,1 followed by m,1,m,1 for m=2,3,4,... . Coverage of every "
                        + "index by one listed run and uniqueness of overlapping maximal runs "
                        + "make the classification exhaustive."))),
                DescribeRole.Theorem)),
        []));

    private static Formula Naturals() => F.Seq(F.Mathbb, F.Grp(F.Id("N")));
    private static Formula Id(string name) => DefinitionDsl.Id(name);
    private static Formula Num(long value) => DefinitionDsl.Num(value);
    private static Formula At(string name, params Formula[] values) => Call(name, values);
    private static Formula Apply(Formula function, params Formula[] values) =>
        new Formula.Apply(function, [.. values]);
    private static Formula Parenthesized(Formula value) => F.Seq(F.Open, value, F.Close);
    private static Formula Add(Formula left, Formula right) => DefinitionDsl.Add(left, right);
    private static Formula Mul(Formula left, Formula right) => DefinitionDsl.Multiply(left, right);
    private static Formula Pow(Formula value, Formula exponent) => new Formula.Power(value, exponent);
    private static Formula Equal(Formula left, Formula right) => DefinitionDsl.Equal(left, right);
    private static Formula Lt(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);
    private static Formula Le(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);
    private static Formula Member(Formula value, Formula set) =>
        new Formula.Relation(value, FormulaRelationOperator.MemberOf, set);
    private static Formula Not(Formula value) => new Formula.Not(value);
    private static Formula Implies(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Implies, right);
    private static Formula Iff(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Iff, right);
    private static Formula And(params Formula[] values) => Logic(FormulaLogicOperator.And, values);
    private static Formula Or(params Formula[] values) => Logic(FormulaLogicOperator.Or, values);

    private static Formula Logic(FormulaLogicOperator op, Formula[] values)
    {
        var result = Parenthesized(values[^1]);
        for (var index = values.Length - 2; index >= 0; index--)
            result = new Formula.Logic(Parenthesized(values[index]), op, result);
        return result;
    }

    private static Formula ForAll(string name, Formula body, Formula? domain = null) =>
        new Formula.Bind(FormulaQuantifier.ForAll, FormulaIdentifier.Create(name),
            domain ?? Naturals(), body);

    private static Formula Exists(string name, Formula body, Formula? domain = null) =>
        new Formula.Bind(FormulaQuantifier.Exists, FormulaIdentifier.Create(name),
            domain ?? Naturals(), body);

    private static Formula NatSub(Formula left, Formula right) => At("natSub", left, right);
    private static Formula NatDiv(Formula left, Formula right) => At("natDiv", left, right);
    private static Formula FloorSqrt(Formula value) => At("floorSqrt", value);
    private static Formula Range(Formula value) => At("range", value);
    private static Formula Image(string function, Formula set) => At("image", Id(function), set);
    private static Formula If(Formula condition, Formula yes, Formula no) =>
        At("if", condition, yes, no);

    private static Formula GroupStart(Formula m) => NatSub(Add(Mul(m, m), m), Num(1));

    private static Formula GroupOf(Formula n) => NatDiv(
        NatSub(FloorSqrt(Add(Mul(Num(4), n), Num(5))), Num(1)), Num(2));

    private static Formula SeqDefinition() => And(
        Equal(At("seq", Num(0)), Num(0)),
        Equal(At("seq", Num(1)), Num(1)),
        ForAll("n", SequenceRule("seq", Add(Id("n"), Num(2)),
            Add(Id("n"), Num(1)), Add(Id("n"), Num(2)))));

    private static Formula SequenceRule(
        string function, Formula currentIndex, Formula previousIndex, Formula historyLength)
    {
        var previous = At(function, previousIndex);
        var candidate = NatSub(previous, Num(1));
        var seen = Member(candidate, Image(function, Range(historyLength)));
        return Equal(At(function, currentIndex),
            If(seen, Add(previous, FloorSqrt(previous)), candidate));
    }

    private static Formula ClosedFormDefinition()
    {
        var n = Id("n");
        var m = GroupOf(n);
        var s = At("groupStart", m);
        var r = NatSub(n, s);
        var first = NatSub(NatSub(Add(s, m), Num(1)), r);
        var second = Add(s, m);
        var third = NatSub(Add(Add(s, Mul(Num(3), m)), Num(1)), r);
        var fourth = Add(Add(s, Mul(Num(2), m)), Num(1));
        var branches = If(Lt(r, m), first,
            If(Equal(r, m), second, If(Le(r, Mul(Num(2), m)), third, fourth)));
        return ForAll("n", Equal(At("closedForm", n),
            If(Lt(n, Num(5)), n, branches)));
    }

    private static Formula IntervalInvariant()
    {
        var m = Id("m");
        var s = At("groupStart", m);
        var square = Pow(m, Num(2));
        var nextSquare = Pow(Add(m, Num(1)), Num(2));
        var followingSquare = Pow(Add(m, Num(2)), Num(2));
        var sm = Add(s, m);
        var last = Add(Add(s, Mul(Num(2), m)), Num(1));
        return ForAll("m", Implies(Le(Num(2), m), And(
            Le(square, NatSub(s, Num(1))),
            Le(square, s),
            Le(square, sm),
            Le(square, Add(sm, Num(1))),
            Lt(NatSub(s, Num(1)), nextSquare),
            Lt(s, nextSquare),
            Lt(sm, nextSquare),
            Lt(Add(sm, Num(1)), nextSquare),
            Le(nextSquare, last),
            Lt(last, followingSquare))));
    }

    private static Formula FourBlocks()
    {
        var m = Id("m");
        var i = Id("i");
        var s = At("groupStart", m);
        var first = ForAll("i", Implies(Lt(i, m), Equal(
            At("seq", Add(s, i)), NatSub(NatSub(Add(s, m), Num(1)), i))));
        var singleton = Equal(At("seq", Add(s, m)), Add(s, m));
        var second = ForAll("i", Implies(Lt(i, m), Equal(
            At("seq", Add(Add(Add(s, m), Num(1)), i)),
            NatSub(Add(s, Mul(Num(2), m)), i))));
        var final = Equal(At("seq", Add(Add(s, Mul(Num(2), m)), Num(1))),
            Add(Add(s, Mul(Num(2), m)), Num(1)));
        return ForAll("m", Implies(Le(Num(2), m), And(first, singleton, second, final)));
    }

    private static Formula MaximalRunDefinition()
    {
        var a = Id("a");
        var start = Id("start");
        var len = Id("len");
        var j = Id("j");
        var internalDecrease = ForAll("j", Implies(Lt(Add(j, Num(1)), len), Lt(
            Apply(a, Add(Add(start, j), Num(1))), Apply(a, Add(start, j)))));
        var left = Or(Equal(start, Num(0)), Not(Parenthesized(Lt(
            Apply(a, start), Apply(a, NatSub(start, Num(1)))))));
        var right = Not(Parenthesized(Lt(Apply(a, Add(start, len)),
            Apply(a, NatSub(Add(start, len), Num(1))))));
        var definition = And(Lt(Num(0), len), internalDecrease, left, right);
        var quantified = ForAll("start", ForAll("len", Iff(
            At("IsMaximalDecreasingRun", a, start, len), definition)));
        return ForAll("a", quantified, new Formula.TypeArrow(Naturals(), Naturals()));
    }

    private static Formula MaximalRunClassification()
    {
        var start = Id("start");
        var len = Id("len");
        var m = Id("m");
        var s = At("groupStart", m);
        var initial = And(Lt(start, Num(5)), Equal(len, Num(1)));
        var fourCases = Or(
            And(Equal(start, s), Equal(len, m)),
            And(Equal(start, Add(s, m)), Equal(len, Num(1))),
            And(Equal(start, Add(Add(s, m), Num(1))), Equal(len, m)),
            And(Equal(start, Add(Add(s, Mul(Num(2), m)), Num(1))),
                Equal(len, Num(1))));
        var grouped = Exists("m", And(Le(Num(2), m), fourCases));
        var classification = Iff(At("IsMaximalDecreasingRun", Id("seq"), start, len),
            Or(initial, grouped));
        return ForAll("start", ForAll("len", classification));
    }
}
