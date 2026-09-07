using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S1.Recurrence;

internal sealed class MultiplicativeExclusionResidueClassDocument : IScribeDocumentDefinition
{
    private const string Prefix =
        "D5/S1/Recurrence/MultiplicativeExclusionResidueClass.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The candidate-inclusive multiplicative-exclusion sequence is uniquely defined and "
            + "equals 1, 3, then the arithmetic progression 3n-5.",
        H("Multiplicative-Exclusion Residue Class"),
        Blocks(
            Paragraph(Text(
                "OEIS A026488, contributed by Clark Kimberling and corrected on 2019-10-12, "
                    + "states this formula as a conjecture. Sean A. Irvine reported verification "
                    + "through n=1300. The repository proof below is symbolic and unbounded.")),
            Paragraph(Text(
                "The source writes a(i)a(j)-a(k) as an integer expression. We formalize its "
                    + "forbidden equality without natural-number truncation: x equals "
                    + "a'(i)a'(j)-a'(k) means x+a'(k)=a'(i)a'(j). At prospective index n, "
                    + "a'(r) is x when r=n and is the prior sequence value a(r) otherwise. "
                    + "Thus k=n, including the self-witness 2+2=2*2, is retained literally.")),
            Describe.Lean(
                DescribeId.Create("multiplicative-exclusion-literal-rule"),
                DeclarationHandle.Create(Prefix + "SatisfiesLiteralRule"),
                H("Literal candidate-inclusive least-value rule"),
                StatementSource.FromAuthor(LiteralRuleFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The sequence is totalized by a(0)=0 and starts at a(1)=1. For every n at "
                        + "least two, a(n) is the least positive x above a(n-1) for which every "
                        + "ordered index triple 1<=i<=j<=k<=n passes the displayed inequality."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("multiplicative-exclusion-residue-protection"),
                DeclarationHandle.Create(Prefix + "residue_protection"),
                H("The protected residue class cannot be excluded"),
                StatementSource.FromAuthor(ResidueProtectionFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Let S={3} union {z in N | z mod 3=1}. If x>=4 and x,u,v,w lie in S "
                        + "with u<=v<=w, then x+w differs from uv. The exceptional element 3 is "
                        + "discharged by the order bound; all remaining cases are protected "
                        + "modulo three."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("multiplicative-exclusion-five-witness-families"),
                DeclarationHandle.Create(Prefix + "witness_of_not_memS"),
                H("Five ordered witness families cover the complement"),
                StatementSource.FromAuthor(WitnessFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "Every y>=7 outside S has ordered u<=v<=w in S, with w<y and y+w=uv.")),
                    Paragraph(Text(
                        "For t>=1 the proof uses exactly the preregistered families: "
                            + "9t+3t+4=4(3t+1), (9t+3)+(3t+1)=4(3t+1), "
                            + "(9t+6)+(3t+10)=4(3t+4), "
                            + "(6t+2)+(3t+1)=3(3t+1), and "
                            + "(6t+5)+(3t+7)=3(3t+4)."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("multiplicative-exclusion-recursive-sequence"),
                DeclarationHandle.Create(Prefix + "sequence"),
                H("Well-founded Nat.find realization"),
                StatementSource.FromAuthor(SequenceDefinitionFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "At n+2, h_n is the recursively available prefix, zero outside that prefix. "
                        + "The definition applies Nat.find to the set of literal admissible values "
                        + "when it is inhabited and otherwise returns zero. Strong induction "
                        + "proves the fallback unreachable; the recursive call is on r<n+2."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("multiplicative-exclusion-sequence-existence"),
                DeclarationHandle.Create(Prefix + "sequence_satisfies_literal_rule"),
                H("The recursive sequence satisfies the literal rule"),
                StatementSource.FromAuthor(SequenceSatisfiesFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Residue protection makes every target term admissible. The prefix witnesses "
                        + "2+2=2*2, 5+4=3*3, and 6+3=3*3, followed by the five general "
                        + "families, exclude every intervening value and prove leastness."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("multiplicative-exclusion-sequence-one"),
                DeclarationHandle.Create(Prefix + "sequence_one"),
                H("The initial term is one"),
                StatementSource.FromAuthor(SequenceValueFormula(D(1), D(1))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("This is the initial value required by the OEIS name line."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("multiplicative-exclusion-sequence-two"),
                DeclarationHandle.Create(Prefix + "sequence_two"),
                H("The second term is three"),
                StatementSource.FromAuthor(SequenceValueFormula(D(2), D(3))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The value two is excluded by the prospective self-witness at i=j=k=n=2, "
                        + "while three is admissible."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("multiplicative-exclusion-sequence-recurrence"),
                DeclarationHandle.Create(Prefix + "sequence_recurrence"),
                H("Every later term is the least literal admissible value"),
                StatementSource.FromAuthor(SequenceRecurrenceFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This exposes the recurrence clause of SatisfiesLiteralRule directly for the "
                        + "constructed sequence, including the prospective substitution at n."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("multiplicative-exclusion-literal-rule-uniqueness"),
                DeclarationHandle.Create(Prefix + "literal_rule_unique"),
                H("The literal-rule sequence exists uniquely"),
                StatementSource.FromAuthor(UniquenessFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Agreement on all earlier positive indices preserves the exclusion predicate. "
                        + "Strong induction then identifies the least values at every index."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("multiplicative-exclusion-sequence-formula"),
                DeclarationHandle.Create(Prefix + "sequence_formula"),
                H("OEIS A026488 has the exact formula 1, 3, then 3n-5"),
                StatementSource.FromAuthor(SequenceFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This single theorem carries both numerical clauses of candidate theorem "
                        + "4.115: a(2)=3 and a(n)=3n-5 for every one-based n>=3. The guarded "
                        + "natural subtraction in 3n-5 is therefore nontruncating."))),
                DescribeRole.Theorem))));

    private static Formula LiteralRuleFormula()
    {
        Formula a = F.Id("a");
        Formula n = F.Id("n");
        Formula x = F.Id("x");
        Formula r = F.Id("r");
        Formula updateDefinition = Equal(
            Updated(a, n, x, r),
            IfThenElse(Equal(r, n), x, At(a, r)));
        Formula leastClause = ForAll(n,
            Implies(LessOrEqual(D(2), n),
                Call("IsLeast", CandidateSet(a, n), At(a, n))));
        Formula body = Conjunction(
            Equal(At(a, D(0)), D(0)),
            Equal(At(a, D(1)), D(1)),
            leastClause);

        return Disp(new Formula.Aligned([
            Seq(Forall, Sp, a, Colon, Sp, FunctionType(Naturals(), Naturals()),
                Comma, Sp, n, Comma, Sp, x, Comma, Sp, r,
                Sp, InMacro, Sp, Naturals(), Comma),
            Seq(updateDefinition, Comma),
            Seq(Call("SatisfiesLiteralRule", a), Sp, Iff, Sp, Parenthesized(body), Dot),
        ]));
    }

    private static Formula ResidueProtectionFormula()
    {
        Formula x = F.Id("x");
        Formula u = F.Id("u");
        Formula v = F.Id("v");
        Formula w = F.Id("w");
        Formula assumptions = Conjunction(
            LessOrEqual(D(4), x),
            Parenthesized(Protected(x)), Parenthesized(Protected(u)),
            Parenthesized(Protected(v)), Parenthesized(Protected(w)),
            LessOrEqual(u, v), LessOrEqual(v, w));

        return Disp(new Formula.Aligned([
            Seq(Forall, Sp, x, Comma, Sp, u, Comma, Sp, v, Comma, Sp, w,
                Sp, InMacro, Sp, Naturals(), Comma),
            Seq(Parenthesized(assumptions), Sp, Rightarrow),
            Seq(NotEqual(Add(x, w), Multiply(u, v)), Dot),
        ]));
    }

    private static Formula WitnessFormula()
    {
        Formula y = F.Id("y");
        Formula u = F.Id("u");
        Formula v = F.Id("v");
        Formula w = F.Id("w");
        Formula witnessBody = Conjunction(
            Parenthesized(Protected(u)), Parenthesized(Protected(v)),
            Parenthesized(Protected(w)),
            LessOrEqual(u, v), LessOrEqual(v, w), Less(w, y),
            Equal(Add(y, w), Multiply(u, v)));
        Formula witness = ExistsMany([u, v, w], witnessBody);

        return Disp(new Formula.Aligned([
            Seq(Forall, Sp, y, Sp, InMacro, Sp, Naturals(), Comma),
            Seq(Parenthesized(LessOrEqual(D(7), y)), Sp, Rightarrow),
            Seq(Parenthesized(Not(Protected(y))), Sp, Rightarrow),
            Seq(witness, Dot),
        ]));
    }

    private static Formula SequenceDefinitionFormula()
    {
        Formula n = F.Id("n");
        Formula r = F.Id("r");
        Formula x = F.Id("x");
        Formula history = Sub(F.Id("h"), n);
        Formula next = Add(n, D(2));
        Formula exists = ExistsOne(x, Admissible(history, next, x));
        Formula hex = F.Id("hex");
        Formula historyDefinition = Seq(
            history, Sp, Colon, Sp, FunctionType(Naturals(), Naturals()), Sp, Colon, Eq, Sp,
            Parenthesized(Seq(r, Sp, Mapsto, Sp,
                IfThenElse(Less(r, next), At(F.Id("sequence"), r), D(0)))));

        return Disp(new Formula.Aligned([
            Seq(F.Id("sequence"), Sp, Colon, Sp, FunctionType(Naturals(), Naturals()), Comma),
            Seq(Equal(At(F.Id("sequence"), D(0)), D(0)), Comma, Sp,
                Equal(At(F.Id("sequence"), D(1)), D(1)), Comma),
            Seq(Forall, Sp, n, Sp, InMacro, Sp, Naturals(), Comma),
            Seq(historyDefinition, Comma),
            Seq(Equal(At(F.Id("sequence"), next),
                IfThenElse(Seq(hex, Sp, Colon, Sp, exists),
                    Seq(Operatorname, Grp(F.Id("Nat"), Dot, F.Id("find")), Parenthesized(hex)),
                    D(0))), Dot),
        ]));
    }

    private static Formula SequenceSatisfiesFormula() =>
        Disp(Seq(Call("SatisfiesLiteralRule", F.Id("sequence")), Dot));

    private static Formula SequenceValueFormula(Formula index, Formula value) =>
        Disp(Seq(Equal(At(F.Id("sequence"), index), value), Dot));

    private static Formula SequenceRecurrenceFormula()
    {
        Formula n = F.Id("n");
        return Disp(new Formula.Aligned([
            Seq(Forall, Sp, n, Sp, InMacro, Sp, Naturals(), Comma),
            Seq(Parenthesized(LessOrEqual(D(2), n)), Sp, Rightarrow),
            Seq(Call("IsLeast", CandidateSet(F.Id("sequence"), n),
                At(F.Id("sequence"), n)), Dot),
        ]));
    }

    private static Formula UniquenessFormula()
    {
        Formula a = F.Id("a");
        return Disp(Seq(
            Exists, Bang, Sp, a, Colon, Sp, FunctionType(Naturals(), Naturals()), Comma, Sp,
            Call("SatisfiesLiteralRule", a), Dot));
    }

    private static Formula SequenceFormula()
    {
        Formula n = F.Id("n");
        Formula first = Parenthesized(Equal(At(F.Id("sequence"), D(2)), D(3)));
        Formula tail = Parenthesized(ForAll(n,
            Implies(LessOrEqual(D(3), n),
                Equal(At(F.Id("sequence"), n), Subtract(Multiply(D(3), n), D(5))))));
        return Disp(new Formula.Aligned([
            first,
            Seq(Land, Sp, tail, Dot),
        ]));
    }

    private static Formula CandidateSet(Formula a, Formula n)
    {
        Formula x = F.Id("x");
        return new Formula.SetBuilder(Admissible(a, n, x), x, Naturals());
    }

    private static Formula Admissible(Formula a, Formula n, Formula x)
    {
        Formula i = F.Id("i");
        Formula j = F.Id("j");
        Formula k = F.Id("k");
        Formula ordered = Conjunction(
            LessOrEqual(D(1), i), LessOrEqual(i, j), LessOrEqual(j, k), LessOrEqual(k, n));
        Formula exclusion = NotEqual(
            Add(x, Updated(a, n, x, k)),
            Multiply(Updated(a, n, x, i), Updated(a, n, x, j)));
        Formula universal = ForAllMany([i, j, k], Implies(ordered, exclusion));
        return Conjunction(
            Less(D(0), x),
            Less(At(a, Subtract(n, D(1))), x),
            universal);
    }

    private static Formula Protected(Formula z) =>
        Disjunction(
            Equal(z, D(3)),
            Equal(new Formula.Modulo(z, D(3)), D(1)));

    private static Formula Updated(Formula a, Formula n, Formula x, Formula r) =>
        new Formula.Subscript(
            new Formula.Power(a, Seq(OpenBracket, n, Colon, Eq, x, CloseBracket)), r);

    private static Formula At(Formula sequence, Formula index) =>
        new Formula.Subscript(sequence, index);

    private static Formula Sub(Formula value, Formula index) =>
        new Formula.Subscript(value, index);

    private static Formula Add(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Add, right);

    private static Formula Subtract(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Subtract, right);

    private static Formula Multiply(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);

    private static Formula Equal(Formula left, Formula right) =>
        Seq(left, Sp, Eq, Sp, right);

    private static Formula NotEqual(Formula left, Formula right) =>
        Seq(left, Sp, Neq, Sp, right);

    private static Formula Less(Formula left, Formula right) =>
        Seq(left, Sp, Lt, Sp, right);

    private static Formula LessOrEqual(Formula left, Formula right) =>
        Seq(left, Sp, Leq, Sp, right);

    private static Formula Implies(Formula premise, Formula conclusion) =>
        Seq(Parenthesized(premise), Sp, Rightarrow, Sp, conclusion);

    private static Formula Not(Formula value) => Seq(Neg, Sp, Parenthesized(value));

    private static Formula Conjunction(Formula first, params Formula[] rest) =>
        Joined([first, .. rest], Land);

    private static Formula Disjunction(Formula first, params Formula[] rest) =>
        Joined([first, .. rest], Lor);

    private static Formula ForAll(Formula variable, Formula body) =>
        Seq(Forall, Sp, variable, Sp, InMacro, Sp, Naturals(), Comma, Sp, body);

    private static Formula ForAllMany(Formula[] variables, Formula body) =>
        Seq(Forall, Sp, Joined(variables, Comma), Sp, InMacro, Sp, Naturals(), Comma, Sp, body);

    private static Formula ExistsOne(Formula variable, Formula body) =>
        Seq(Exists, Sp, variable, Sp, InMacro, Sp, Naturals(), Comma, Sp, body);

    private static Formula ExistsMany(Formula[] variables, Formula body) =>
        Seq(Exists, Sp, Joined(variables, Comma), Sp, InMacro, Sp, Naturals(), Comma, Sp,
            Parenthesized(body));

    private static Formula IfThenElse(Formula condition, Formula yes, Formula no) =>
        Call("if", condition, yes, no);

    private static Formula FunctionType(Formula domain, Formula codomain) =>
        Seq(domain, Sp, To, Sp, codomain);

    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));

    private static Formula Parenthesized(Formula value) => Seq(Open, value, Close);

    private static Formula Joined(Formula[] values, Formula separator)
    {
        List<Formula> items = [];
        for (var index = 0; index < values.Length; index++)
        {
            if (index > 0) items.AddRange([Sp, separator, Sp]);
            items.Add(values[index]);
        }
        return Seq([.. items]);
    }

    private static Formula Call(string name, params Formula[] arguments) =>
        Seq(Operatorname, Grp(F.Id(name)), Parenthesized(Joined(arguments, Comma)));
}
