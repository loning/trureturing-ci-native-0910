using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class GoldenFixedPointDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/GoldenResource/GoldenFixedPoint.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Golden integers are the fixed points of integer observation, and the observation of an integer is its greatest golden divisor.",
        H("Golden Fixed Points"),
        Blocks(
            Paragraph(Text("Write F_L for the Fibonacci number of index L, b for the layering map "
                + "on exponents, a_p(n) for the exponent of the prime p in n, and G(n) for the "
                + "observation of a positive integer n, whose exponent at each prime p is b(a_p(n)). "
                + "A positive integer g is called golden when every exponent a_p(g) is one less "
                + "than a Fibonacci number of index at least two.")),
            Describe.Lean(
                DescribeId.Create("layering-fixed-points"),
                DeclarationHandle.Create(Prefix + "b_fixed_iff"),
                H("Fixed exponents are Fibonacci endpoints"),
                StatementSource.FromAuthor(FixedPointFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The layering map sends a to the largest Fibonacci number "
                    + "not exceeding a plus one, minus one. It therefore fixes a exactly when "
                    + "a plus one is itself a Fibonacci number, and the index bound records that "
                    + "the smallest admissible window endpoint is one."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("golden-iff-observation-fixed"),
                DeclarationHandle.Create(Prefix + "isGolden_iff_Gobs_fixed"),
                H("Golden integers are the fixed points of observation"),
                StatementSource.FromAuthor(GoldenFixedFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Two positive integers agree exactly when their prime "
                    + "exponents agree. The exponent of the observation at p is the layering of "
                    + "the exponent at p, so the observation fixes g exactly when the layering "
                    + "fixes every exponent, which is the golden condition."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("observation-is-golden"),
                DeclarationHandle.Create(Prefix + "Gobs_isGolden"),
                H("Every observation is golden"),
                StatementSource.FromAuthor(ObservationGoldenFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Observation is idempotent, so its value is a fixed point "
                    + "and hence golden."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("observation-preserves-divisibility"),
                DeclarationHandle.Create(Prefix + "Gobs_dvd_of_dvd"),
                H("Observation preserves divisibility"),
                StatementSource.FromAuthor(MonotoneFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Divisibility of positive integers is the pointwise order "
                    + "on prime exponents, and the layering map is monotone, so the observed "
                    + "exponents stay in the same order."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("greatest-golden-divisor"),
                DeclarationHandle.Create(Prefix + "Gobs_greatest_golden_divisor"),
                H("The observation is the greatest golden divisor"),
                StatementSource.FromAuthor(GreatestFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The observation divides its argument and is golden. "
                    + "If a golden g divides n then observation of g divides observation of n, "
                    + "and observation fixes g, so g itself divides the observation of n. "
                    + "This identifies an exponentwise construction with an order-theoretic "
                    + "maximum in the divisibility order."))),
                DescribeRole.Theorem))));

    private static Formula FixedPointFormula() =>
        Disp(new Formula.BindMany(FormulaQuantifier.ForAll, [Bound("a", Naturals())],
            Iff(Equal(Call("b", F.Id("a")), F.Id("a")), FibonacciEndpoint(F.Id("a")))));

    private static Formula GoldenFixedFormula() =>
        Disp(new Formula.BindMany(FormulaQuantifier.ForAll, [Bound("g", Positives())],
            Iff(Golden(F.Id("g")), Equal(Call("G", F.Id("g")), F.Id("g")))));

    private static Formula ObservationGoldenFormula() =>
        Disp(new Formula.BindMany(FormulaQuantifier.ForAll, [Bound("n", Positives())],
            Golden(Call("G", F.Id("n")))));

    private static Formula MonotoneFormula() =>
        Disp(new Formula.BindMany(FormulaQuantifier.ForAll,
            [Bound("n", Positives()), Bound("m", Positives())],
            Implies(Divides(F.Id("n"), F.Id("m")),
                Divides(Call("G", F.Id("n")), Call("G", F.Id("m"))))));

    private static Formula GreatestFormula()
    {
        Formula maximality = new Formula.BindMany(FormulaQuantifier.ForAll,
            [Bound("g", Positives())],
            Implies(And(Golden(F.Id("g")), Divides(F.Id("g"), F.Id("n"))),
                Divides(F.Id("g"), Call("G", F.Id("n")))));
        return Disp(new Formula.BindMany(FormulaQuantifier.ForAll, [Bound("n", Positives())],
            And(Divides(Call("G", F.Id("n")), F.Id("n")),
                And(Golden(Call("G", F.Id("n"))), maximality))));
    }

    private static Formula Golden(Formula argument) => Call("Golden", argument);

    private static Formula FibonacciEndpoint(Formula exponent) =>
        new Formula.BindMany(FormulaQuantifier.Exists, [Bound("L", Naturals())],
            And(Le(D(2), F.Id("L")),
                Equal(Seq(exponent, Sp, Plus, Sp, D(1)), Fibonacci())));

    private static Formula Fibonacci() => Seq(F.Id("F"), Underscore, F.Id("L"));

    private static Formula Divides(Formula left, Formula right) =>
        Seq(left, Sp, Mid, Sp, right);

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);

    private static Formula Le(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);

    private static Formula Equal(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);

    private static Formula And(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.And, right);

    private static Formula Iff(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Iff, right);

    private static Formula Implies(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Implies, right);

    private static Formula.BoundVariable Bound(string name, Formula domain) =>
        new(FormulaIdentifier.Create(name), domain);

    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));

    private static Formula Positives() =>
        Seq(Mathbb, Grp(F.Id("N")), Underscore, Grp(Gt, D(0)));
}
