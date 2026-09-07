using static StrataLint.Scribe.DefinitionDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.QuantumBounds.ReferenceFrame;

internal sealed class FiniteShiftAutocorrelationDocument : IScribeDocumentDefinition
{
    private const string Owner = "D5/S3/QuantumBounds/ReferenceFrame/FiniteShiftAutocorrelation.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Finite integer-supported complex coefficients have an exact sharp cosine autocorrelation bound.",
        H("Sharp Finite Shift Autocorrelation"),
        Blocks(
            Paragraph(Text(
                "QUANTUM-REALITY theorem75.1 concerns the original coefficient autocorrelation "
                + "from definition74.1. The sums below range over all integers, with coefficients "
                + "zero outside the interval from zero to N. N may be zero, and the positive "
                + "integer shift may exceed N. Complex coefficients may have arbitrary phases.")),
            Describe.Lean(
                DescribeId.Create("finite-support-autocorrelation-bound"),
                DeclarationHandle.Create(Owner + "finite_support_autocorrelation_bound"),
                H("Universal upper bound"),
                StatementSource.FromAuthor(Endpoint(false)),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Set L to the positive shift and q to the natural quotient N/L. Euclidean "
                    + "division transports the squared mass and the actual complex forward "
                    + "products to L residue paths, each padded to q+1 nodes. Support makes "
                    + "the top forward product vanish. Triangle inequality reduces each path "
                    + "to coefficient absolute values. The frozen path-averaging squared bound "
                    + "and finite Cauchy-Schwarz give the homogeneous adjacent-product bound; "
                    + "summing the masses gives the displayed constant."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("finite-support-autocorrelation-attained"),
                DeclarationHandle.Create(Owner + "finite_support_autocorrelation_attained"),
                H("Attainment for every support length and positive shift"),
                StatementSource.FromAuthor(Endpoint(true)),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "The witness takes the public low sine mode on q+1 nodes, divides by "
                        + "the square root of its positive squared mass, and places the entries "
                        + "at integer indices jL for j from zero to q. All other coefficients "
                        + "are zero. The signed path eigenvector recurrence proves that the "
                        + "actual complex autocorrelation equals the nonnegative real cosine. "
                        + "Taking its norm then gives equality. For q=0 the witness is delta at zero.")),
                    Paragraph(Text(
                        "This scalar extremum adds no Hamiltonian, recovery-channel, or other "
                        + "resource-model claim. It does not cover theorem75.2 or corollary75.1."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("floor-shift-quotient"),
                DeclarationHandle.Create(Owner + "floor_shift_quotient"),
                H("Exact source floor and natural quotient"),
                StatementSource.FromAuthor(FloorBridge()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The floor is the integer floor of the real quotient. The right side is "
                    + "natural-number division by the positive integer shift converted to Nat, "
                    + "then cast to Int. Thus the source denominator floor(N/ell)+2 equals the "
                    + "Lean endpoint denominator exactly, including N=0 and ell>N."))),
                DescribeRole.Theorem))));

    private static Formula.BoundVariable Bound(string name, Formula type) =>
        new(FormulaIdentifier.Create(name), type);
    private static Formula All(Formula.BoundVariable[] vars, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.ForAll, [.. vars], body);
    private static Formula Rel(Formula a, FormulaRelationOperator op, Formula b) =>
        new Formula.Relation(a, op, b);
    private static Formula Eqn(Formula a, Formula b) => Rel(a, FormulaRelationOperator.Equal, b);
    private static Formula Logic(Formula a, FormulaLogicOperator op, Formula b) =>
        new Formula.Logic(a, op, b);
    private static Formula Both(params Formula[] terms) => terms.Aggregate(
        (a, b) => Logic(a, FormulaLogicOperator.And, b));
    private static Formula Apply(Formula f, Formula a) => new Formula.Apply(f, [a]);
    private static Formula Call(string name, params Formula[] args) =>
        new Formula.FunctionCall(FormulaIdentifier.Create(name), [.. args]);
    private static Formula Add(Formula a, Formula b) =>
        new Formula.Binary(a, FormulaBinaryOperator.Add, b);
    private static Formula NumberSet(string name) => F.Seq(F.Mathbb, F.Grp(F.Id(name)));
    private static Formula Norm(Formula a) => F.Seq(F.Lvert, F.Grp(a), F.Rvert);
    private static Formula Sum(Formula body) => F.Seq(F.Sum, F.Underscore,
        F.Grp(F.Id("n"), F.Sp, F.InMacro, F.Sp, NumberSet("Z")), F.Sp, F.Grp(body));
    private static Formula FloorRatio() => F.Seq(F.Lfloor,
        F.Frac, F.Grp(F.Id("N")), F.Grp(F.Id("l")), F.Rfloor);
    private static Formula Constant() => F.Seq(F.Operatorname, F.Grp(F.Id("cos")), F.Open,
        F.Frac, F.Grp(F.Pi), F.Grp(FloorRatio(), F.Plus, F.D(2)), F.Close);
    private static Formula PositiveShift() => Rel(F.Id("l"), FormulaRelationOperator.GreaterThanOrEqual, Num(1));

    private static Formula Endpoint(bool attained)
    {
        Formula n = F.Id("n"), c = F.Id("c"), nmax = F.Id("N");
        Formula integer = NumberSet("Z"), complex = NumberSet("C");
        Formula coefficient = Apply(c, n);
        Formula support = All([Bound("n", integer)], Logic(
            Logic(Rel(n, FormulaRelationOperator.LessThan, Num(0)), FormulaLogicOperator.Or,
                Rel(nmax, FormulaRelationOperator.LessThan, n)), FormulaLogicOperator.Implies,
            Eqn(coefficient, Num(0))));
        Formula mass = Eqn(Sum(F.Seq(Norm(coefficient), F.Caret, F.Grp(F.D(2)))), Num(1));
        Formula gamma = Sum(new Formula.Binary(Apply(c, Add(n, F.Id("l"))),
            FormulaBinaryOperator.Multiply, F.Seq(F.Overline, F.Grp(coefficient))));
        Formula extremum = Rel(Norm(gamma), attained ? FormulaRelationOperator.Equal
            : FormulaRelationOperator.LessThanOrEqual, Constant());
        Formula ctype = new Formula.TypeArrow(integer, complex);
        Formula statement = attained
            ? All([Bound("N", NumberSet("N")), Bound("l", integer)],
                Logic(PositiveShift(), FormulaLogicOperator.Implies,
                    new Formula.BindMany(FormulaQuantifier.Exists, [Bound("c", ctype)],
                        Both(support, mass, extremum))))
            : All([Bound("N", NumberSet("N")), Bound("l", integer), Bound("c", ctype)],
                Logic(Both(PositiveShift(), support, mass), FormulaLogicOperator.Implies, extremum));
        return F.Disp(statement);
    }

    private static Formula FloorBridge() => F.Disp(All(
        [Bound("N", NumberSet("N")), Bound("l", NumberSet("Z"))],
        Logic(PositiveShift(), FormulaLogicOperator.Implies,
            Eqn(FloorRatio(), Call("NatDiv", F.Id("N"), Call("toNat", F.Id("l")))))));
}
