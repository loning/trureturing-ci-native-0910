using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class GoldenDepthForcesPrimeSupportDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Two-adic depth in a colossally abundant integer forces prime divisibility "
            + "under an explicit logarithmic inequality.",
        H("Two-adic Depth Forces Prime Support"),
        Blocks(Describe.Lean(
            DescribeId.Create("two-adic-depth-forces-prime-support"),
            DeclarationHandle.Create("D5/S3/Arith/GoldenResource/"
                + "GoldenDepthForcesPrimeSupport.prime_dvd_of_two_adic_depth"),
            H("A sufficient condition for prime divisibility"),
            StatementSource.FromAuthor(Statement()),
            AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(
                "The integer N is positive and globally optimal at some positive resource "
                + "price. The displayed inequality already forces k to be at least one, "
                + "because its right side is zero at k equal to zero. The adopted layer "
                + "at two bounds the price above. Strict reciprocal logarithm estimates "
                + "place that price below the first-layer marginal at p, even when the "
                + "displayed inequality is an equality. The frozen threshold criterion "
                + "therefore excludes p from being an unadopted prime."))),
            DescribeRole.Theorem))));

    private static Formula Statement()
    {
        Formula n = F.Id("N");
        Formula p = F.Id("p");
        Formula k = F.Id("k");
        Formula scale = Sub(new Formula.Power(D(2), Add(k, D(1))), D(2));
        Formula assumptions = And(Le(D(1), n),
            And(Call("IsColossallyAbundant", n),
                And(Call("Prime", p), And(Le(k, Call("factorization", n, D(2))),
                    Le(Mul(Add(p, D(1)), Call("log", p)), Mul(scale, Call("log", D(2))))))));
        return Disp(new Formula.BindMany(FormulaQuantifier.ForAll,
            [Bound("N"), Bound("p"), Bound("k")],
            new Formula.Logic(assumptions, FormulaLogicOperator.Implies, Call("Dvd", p, n))));
    }

    private static Formula.BoundVariable Bound(string name) =>
        new(FormulaIdentifier.Create(name), Seq(Mathbb, Grp(F.Id("N"))));
    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);
    private static Formula Le(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);
    private static Formula And(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.And, right);
}
