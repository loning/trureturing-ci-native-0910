using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class DiscreteLogSelectorDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/GoldenResource/DiscreteLogSelector.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "A strict logarithmic price interval selects one positive integer layer and gives a uniform loss away from it.",
        H("Discrete Logarithmic Selector"),
        Blocks(
            Paragraph(Text("For a positive integer n, write g_p(n) for log(n) minus p times n.")),
            Describe.Lean(
                DescribeId.Create("discrete-log-unique-maximum"),
                DeclarationHandle.Create(Prefix + "discrete_log_unique_maximum"),
                H("Unique integer maximizer with an explicit gap"),
                StatementSource.FromAuthor(SelectorFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The adjacent difference is log((n+1)/n) minus p. These margins decrease with n; induction in both directions telescopes the adjacent inequalities over the entire positive integer ray. The endpoint inequalities are strict, so the stated minimum of the two endpoint margins is positive."))),
                DescribeRole.Theorem))));

    private static Formula SelectorFormula()
    {
        Formula k = F.Id("k");
        Formula p = F.Id("p");
        Formula n = F.Id("n");
        Formula g = F.Id("g");
        Formula ratioNext = Call("log", new Formula.Fraction(Seq(k, Plus, D(1)), k));
        Formula ratioPrev = Call("log", new Formula.Fraction(k, Seq(k, Minus, D(1))));
        Formula objectiveN = Objective(p, n);
        Formula objectiveK = Objective(p, k);
        Formula body = Implies(And(Le(D(2), k), And(Lt(ratioNext, p), Lt(p, ratioPrev))),
            new Formula.BindMany(FormulaQuantifier.ForAll, [Bound("n", Naturals())],
                Implies(Lt(D(0), n),
                    And(Le(objectiveN, objectiveK),
                        Implies(NotEqual(n, k),
                            Le(Min(Sub(ratioPrev, p), Sub(p, ratioNext)),
                                Sub(objectiveK, objectiveN)))))));
        return Disp(new Formula.BindMany(FormulaQuantifier.ForAll,
            [Bound("k", Naturals()), Bound("p", Reals())], body));
    }

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);

    private static Formula Min(Formula left, Formula right) =>
        Call("min", left, right);

    private static Formula Sub(Formula left, Formula right) =>
        Seq(left, Sp, Minus, Sp, right);

    private static Formula Le(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);

    private static Formula Lt(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);

    private static Formula And(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.And, right);

    private static Formula Implies(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Implies, right);

    private static Formula NotEqual(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.NotEqual, right);

    private static Formula Objective(Formula p, Formula n) =>
        Call("g", p, n);

    private static Formula.BoundVariable Bound(string name, Formula domain) =>
        new(FormulaIdentifier.Create(name), domain);

    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));

    private static Formula Reals() => Seq(Mathbb, Grp(F.Id("R")));
}
