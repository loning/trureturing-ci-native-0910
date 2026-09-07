using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class ContinuousPrimeMaximumDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/GoldenResource/ContinuousPrimeMaximum.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The continuous prime-direction objective has a unique maximum on the nonnegative ray.",
        H("Continuous Prime Maximum"),
        Blocks(
            Paragraph(Text("All parameters and exponents below are real. The base p is greater "
                + "than one; primality is not required. Write f_p(t) for the following benefit:")),
            Paragraph(Math(Disp(Seq(BenefitAt(F.Id("t")), Sp, Eq, Sp, Benefit(F.Id("t")))))),
            Describe.Lean(
                DescribeId.Create("continuous-prime-derivative"),
                DeclarationHandle.Create(Prefix + "continuous_prime_hasDerivAt"),
                H("Derivative on the nonnegative ray"),
                StatementSource.FromAuthor(Disp(Seq(
                    D(1), Sp, Lt, Sp, F.Id("p"), Sp, Land, Sp,
                    D(0), Sp, Le, Sp, F.Id("x"), Sp, Rightarrow, Sp,
                    Seq(F.Id("f"), Underscore, Grp(F.Id("p")), Apos, Open, F.Id("x"), Close),
                    Sp, Eq, Sp, Slope(F.Id("x"))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The proof differentiates the real power, the quotient "
                    + "and the logarithm. Positivity of both logarithm arguments is proved "
                    + "from p > 1 and x >= 0."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("continuous-prime-slope-decrease"),
                DeclarationHandle.Create(Prefix + "continuous_prime_slope_strictAntiOn"),
                H("Strict decrease of the slope"),
                StatementSource.FromAuthor(Disp(Seq(
                    D(1), Sp, Lt, Sp, F.Id("p"), Sp, Land, Sp,
                    D(0), Sp, Le, Sp, F.Id("u"), Sp, Lt, Sp, F.Id("v"),
                    Sp, Rightarrow, Sp, Slope(F.Id("v")), Sp, Lt, Sp, Slope(F.Id("u"))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The real power strictly increases with the exponent. "
                    + "Its positive shifted reciprocal therefore strictly decreases."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("continuous-prime-unique-maximum"),
                DeclarationHandle.Create(Prefix + "continuous_prime_unique_maximum"),
                H("The unique maximum"),
                StatementSource.FromAuthor(MaximumFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For p < y the critical exponent is positive, the "
                    + "objective strictly increases up to it and strictly decreases after it. "
                    + "For y <= p the maximum is the boundary exponent zero; strict decrease "
                    + "on the positive ray also covers p = y. These comparisons establish "
                    + "both the upper bound and its exact equality condition."))),
                DescribeRole.Theorem))));

    private static Formula MaximumFormula() => Disp(new Formula.Aligned([
        Seq(F.Id("p"), Sp, F.Id("y"), Sp, F.Id("x"), Sp, InMacro, Sp,
            Mathbb, Grp(F.Id("R")), Comma, Sp,
            D(1), Sp, Lt, Sp, F.Id("p"), Comma, Sp,
            D(2), Sp, Lt, Sp, F.Id("y"), Comma, Sp, D(0), Sp, Le, Sp, F.Id("x")),
        Seq(F.Id("a"), Sp, Eq, Sp, Call("max", D(0),
            Seq(new Formula.Fraction(Call("log", F.Id("y")), Call("log", F.Id("p"))),
                Sp, Minus, Sp, D(1)))),
        Seq(Objective(F.Id("x")), Sp, Le, Sp, Objective(F.Id("a"))),
        Seq(Open, Objective(F.Id("x")), Sp, Eq, Sp, Objective(F.Id("a")), Close,
            Sp, Iff, Sp, F.Id("x"), Sp, Eq, Sp, F.Id("a"))
    ]));

    private static Formula Benefit(Formula t) => Call("log", new Formula.Fraction(
        Seq(D(1), Sp, Minus, Sp, Pow(F.Id("p"), Seq(Minus, Open, t, Plus, D(1), Close))),
        Seq(D(1), Sp, Minus, Sp, Pow(F.Id("p"), Seq(Minus, D(1))))));

    private static Formula Slope(Formula t) => new Formula.Fraction(
        Call("log", F.Id("p")), Seq(Pow(F.Id("p"), Seq(t, Plus, D(1))), Minus, D(1)));

    private static Formula BenefitAt(Formula t) =>
        Seq(F.Id("f"), Underscore, Grp(F.Id("p")), Open, t, Close);

    private static Formula Objective(Formula t) => Seq(BenefitAt(t), Sp, Minus, Sp,
        new Formula.Fraction(Seq(t, Sp, Call("log", F.Id("p"))),
            Seq(F.Id("y"), Sp, Minus, Sp, D(1))));

    private static Formula Pow(Formula x, Formula n) => new Formula.Power(x, n);

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);
}
