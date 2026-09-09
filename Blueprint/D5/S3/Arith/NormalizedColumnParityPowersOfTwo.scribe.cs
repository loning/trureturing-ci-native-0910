using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith;

internal sealed class NormalizedColumnParityPowersOfTwoDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/NormalizedColumnParityPowersOfTwo.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The normalized A144637 equation has integral coefficients whose odd support is exactly "
            + "the set of positive powers of two.",
        H("A144637 Normalized Column Parity"),
        Blocks(
            Node(
                "a144637-normalized-solution-exists",
                "An integral normalized solution exists",
                "normalized_solution_exists",
                NormalizedSolutionExistsFormula(),
                "Choose the coefficient of z in degree n recursively as the degree-n "
                    + "coefficient of x^2-36z^3-3z^2-6xz formed from the strict prefix. "
                    + "The zero constant coefficient makes every nonlinear contribution in "
                    + "degree n depend only on lower coefficients. The resulting integer "
                    + "series satisfies the normalized cubic equation."),
            Node(
                "a144637-rational-solution-exists",
                "A rational normalized solution exists",
                "rational_solution_exists",
                RationalSolutionExistsFormula(),
                "Mapping the recursively constructed integer series coefficientwise into the "
                    + "rationals preserves its zero constant coefficient, products, powers, "
                    + "and the indeterminate. It therefore supplies a rational solution of the "
                    + "same normalized equation."),
            Node(
                "a144637-integral-reduction",
                "Integrality and reduction to the quadratic equation",
                "integral_reduction",
                IntegralReductionFormula(),
                "Two zero-constant rational solutions agree coefficient by coefficient. In "
                    + "degree n, the coefficient of y occurs with multiplier one, while all "
                    + "other occurrences involve lower degrees. Hence every rational solution "
                    + "is the rational image of the recursively constructed integer series. "
                    + "Reducing that same cubic equation modulo two removes the terms with "
                    + "coefficients 36 and 6 and replaces 3 by 1, giving z^2+z=x^2."),
            Node(
                "a144637-zero-constant-quadratic-support",
                "Support of the zero-constant quadratic root",
                "zero_constant_quadratic_support",
                ZeroConstantQuadraticSupportFormula(),
                "Let S be the constant-one Artin series. Its equation S^2+S=x gives "
                    + "T=S^2+1=x+S+1, whose coefficients are one exactly in degrees "
                    + "2,4,8,.... Squaring the equation for S shows T^2+T=x^2. The "
                    + "equal-constant root uniqueness theorem identifies every zero-constant "
                    + "root of this quadratic with T."),
            Node(
                "a144637-parity",
                "Odd coefficients occur exactly at positive powers of two",
                "a144637_parity",
                ParityFormula(),
                "Apply the integral reduction to a normalized rational solution. An integer "
                    + "coefficient is odd exactly when its image in ZMod(2) is one, and the "
                    + "quadratic support theorem identifies those indices precisely as "
                    + "2^k with k positive.")),
        [
            DocumentEdge.Dependency.Create(GidRef.Create(
                "D5/S3/Arith/ArtinSchreierQuadraticRootUniqueness")),
            DocumentEdge.Dependency.Create(GidRef.Create(
                "D5/S3/Arith/ArtinSchreierTracePowersOfTwo")),
        ]));

    private static DocumentBlock Node(
        string id, string title, string declaration, Formula formula, string prose) =>
        Describe.Lean(
            DescribeId.Create(id),
            DeclarationHandle.Create(Prefix + declaration),
            H(title),
            StatementSource.FromAuthor(formula),
            AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(prose))),
            DescribeRole.Theorem);

    private static Formula NormalizedSolutionExistsFormula() =>
        Disp(Exists("z", Series(Integers()),
            And(ZeroConstant(Z()), CubicEquation(Z()))));

    private static Formula RationalSolutionExistsFormula() =>
        Disp(Exists("y", Series(Rationals()),
            And(ZeroConstant(Y()), CubicEquation(Y()))));

    private static Formula IntegralReductionFormula()
    {
        Formula z = Z();
        Formula hypotheses = And(ZeroConstant(Y()), CubicEquation(Y()));
        Formula conclusion = Exists("z", Series(Integers()),
            And(Equal(Rationalize(z), Y()),
                And(ZeroConstant(z), Quadratic(Reduce(z)))));
        return Disp(ForAll("y", Series(Rationals()), Implies(hypotheses, conclusion)));
    }

    private static Formula ZeroConstantQuadraticSupportFormula()
    {
        Formula hypotheses = And(ZeroConstant(Root()), Quadratic(Root()));
        Formula conclusion = ForAll("n", Naturals(), Support(Root(), N()));
        return Disp(ForAll("F", Series(ModTwo()), Implies(hypotheses, conclusion)));
    }

    private static Formula ParityFormula()
    {
        Formula hypotheses = And(ZeroConstant(Y()), CubicEquation(Y()));
        Formula parity = ForAll("n", Naturals(),
            Iff(Call("Odd", Call("coeff", N(), Z())), PositivePower(N())));
        Formula conclusion = Exists("z", Series(Integers()),
            And(Equal(Rationalize(Z()), Y()), parity));
        return Disp(ForAll("y", Series(Rationals()), Implies(hypotheses, conclusion)));
    }

    private static Formula CubicEquation(Formula value)
    {
        Formula cubic = Product(Call("C", D(3, 6)), Power(value, D(3)));
        Formula square = Product(Call("C", D(3)), Power(value, D(2)));
        Formula linear = Product(
            Add(D(1), Product(Call("C", D(6)), X())), value);
        return Equal(Add(Add(cubic, square), linear), Power(X(), D(2)));
    }

    private static Formula Quadratic(Formula value) =>
        Equal(Add(Power(value, D(2)), value), Power(X(), D(2)));

    private static Formula Support(Formula series, Formula n) =>
        Iff(Equal(Call("coeff", n, series), D(1)), PositivePower(n));

    private static Formula PositivePower(Formula n) =>
        Exists("k", Naturals(),
            And(Less(D(0), F.Id("k")), Equal(n, Power(D(2), F.Id("k")))));

    private static Formula ZeroConstant(Formula value) =>
        Equal(Call("constantCoeff", value), D(0));

    private static Formula Reduce(Formula value) =>
        Call("map", Call("intCast", ModTwo()), value);

    private static Formula Rationalize(Formula value) =>
        Call("map", Call("intCast", Rationals()), value);

    private static Formula Z() => F.Id("z");
    private static Formula Y() => F.Id("y");
    private static Formula Root() => F.Id("F");
    private static Formula N() => F.Id("n");
    private static Formula X() => F.Id("X");
    private static Formula Integers() => Seq(Mathbb, Grp(F.Id("Z")));
    private static Formula Rationals() => Seq(Mathbb, Grp(F.Id("Q")));
    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));
    private static Formula ModTwo() => Call("ZMod", D(2));
    private static Formula Series(Formula ring) => Call("PowerSeries", ring);

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(Seq(Operatorname, Grp(F.Id(name))), [.. arguments]);

    private static Formula ForAll(string name, Formula domain, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.ForAll, [Bound(name, domain)], body);

    private static Formula Exists(string name, Formula domain, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.Exists, [Bound(name, domain)], body);

    private static Formula.BoundVariable Bound(string name, Formula domain) =>
        new(FormulaIdentifier.Create(name), domain);

    private static Formula Equal(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);

    private static Formula Less(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);

    private static Formula And(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.And, right);

    private static Formula Iff(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Iff, right);

    private static Formula Implies(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Implies, right);

    private static Formula Add(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Add, right);

    private static Formula Product(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);

    private static Formula Power(Formula value, Formula exponent) =>
        new Formula.Power(value, exponent);
}
