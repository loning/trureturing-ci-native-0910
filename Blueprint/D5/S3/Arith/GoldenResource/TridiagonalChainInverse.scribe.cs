using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class TridiagonalChainInverseDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/GoldenResource/TridiagonalChainInverse.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The diagonal-four chain is uniformly positive with exponentially small endpoint transfer.",
        H("Tridiagonal Chain Inverse"),
        Blocks(
            Paragraph(Text("Let d(0)=1, d(1)=4, and d(n+2)=4d(n+1)-d(n). "
                + "The index n ranges over all natural numbers. H(m) is the real m by m matrix "
                + "with diagonal four, adjacent entries minus one, and all other entries zero. "
                + "In matrix entries, i and j range from zero through m-1. "
                + "Write E(n,x) for x transpose H(n+1)x, V(n,x) for the sum of all coordinate "
                + "squares, and A(n,x) for the sum of squared differences of adjacent coordinates. "
                + "The coordinates of x are indexed from zero through n. Let v(n) have coordinate "
                + "i equal to d(n-i), let e(0) be the first unit vector, and let w(n) be "
                + "H(n+1) inverse times e(0). Write w(n,i) for coordinate i, where zero is "
                + "less than or equal to i and i is less than or equal to n. "
                + "Square brackets around a proposition denote one when true and zero otherwise.")),
            Describe.Lean(
                DescribeId.Create("chain-matrix-entries"),
                DeclarationHandle.Create(Prefix + "chain_apply"),
                H("The tridiagonal entries"),
                StatementSource.FromAuthor(Disp(Eq(Call("H", F.Id("m"), F.Id("i"), F.Id("j")),
                    Seq(D(4), Cdot, Indicator(Eq(F.Id("i"), F.Id("j"))), Minus,
                        Indicator(Eq(Add(F.Id("i"), D(1)), F.Id("j"))), Minus,
                        Indicator(Eq(Add(F.Id("j"), D(1)), F.Id("i"))))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The diagonal has value four. Exactly one adjacent "
                    + "indicator is one for neighbours, and both are zero otherwise."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("chain-denominator-positive"),
                DeclarationHandle.Create(Prefix + "chainDet_pos"),
                H("Positive denominators"),
                StatementSource.FromAuthor(Disp(Lt(D(0), Call("d", F.Id("n"))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Simultaneous induction proves positivity and "
                    + "d(n+1) greater than or equal to three times d(n)."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("chain-denominator-geometric-growth"),
                DeclarationHandle.Create(Prefix + "chainDet_ge_three_pow"),
                H("Geometric growth"),
                StatementSource.FromAuthor(Disp(Le(Pow(D(3), F.Id("n")),
                    Call("d", F.Id("n"))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Iterate the factor-three bound from d(0)=1."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("chain-squared-denominator-growth"),
                DeclarationHandle.Create(Prefix + "chainDet_sq_ge_nine_pow"),
                H("Squared denominators"),
                StatementSource.FromAuthor(Disp(Le(Pow(D(9), F.Id("n")),
                    Pow(Call("d", F.Id("n")), D(2))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Both sides of the factor-three estimate are nonnegative. "
                    + "Squaring gives the factor-nine estimate."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("chain-energy-decomposition"),
                DeclarationHandle.Create(Prefix + "chain_energy"),
                H("The energy identity"),
                StatementSource.FromAuthor(Disp(Eq(Call("E", F.Id("n"), F.Id("x")),
                    Seq(D(2), Cdot, Call("V", F.Id("n"), F.Id("x")), Plus,
                        Pow(Call("x", D(0)), D(2)), Plus, Pow(Call("x", F.Id("n")), D(2)),
                        Plus, Call("A", F.Id("n"), F.Id("x")))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Expand each adjacent difference and sum. Each interior "
                    + "coordinate occurs twice among the edges, and each endpoint once. "
                    + "For n=0, the endpoint terms coincide and the edge sum is empty."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("chain-uniform-quadratic-bound"),
                DeclarationHandle.Create(Prefix + "chain_coercive"),
                H("A uniform lower bound"),
                StatementSource.FromAuthor(Disp(Le(
                    Seq(D(2), Cdot, Call("V", F.Id("n"), F.Id("x"))),
                    Call("E", F.Id("n"), F.Id("x"))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("All boundary and edge squares are nonnegative."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("chain-positive-definite"),
                DeclarationHandle.Create(Prefix + "chain_posDef"),
                H("Positive definiteness"),
                StatementSource.FromAuthor(Disp(Call("PosDef", Call("H", F.Id("m"))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The matrix is symmetric. For a nonzero vector, "
                    + "the sum of coordinate squares is strictly positive, so the uniform "
                    + "lower bound proves positive definiteness. The empty matrix also satisfies "
                    + "the definition."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("chain-reversed-recurrence-product"),
                DeclarationHandle.Create(Prefix + "chain_inv_column"),
                H("Multiplication by the reversed recurrence"),
                StatementSource.FromAuthor(Disp(Eq(
                    Seq(Call("H", Next()), Cdot, Call("v", F.Id("n"))),
                    Seq(Call("d", Next()), Cdot, Call("e", D(0)))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The first row gives d(n+1). Each interior row vanishes "
                    + "by the recurrence. The last row vanishes since four times d(0) equals d(1). "
                    + "For a single coordinate the product is simply four."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("chain-explicit-inverse-column"),
                DeclarationHandle.Create(Prefix + "chain_inverse_column"),
                H("The first inverse column"),
                StatementSource.FromAuthor(Disp(Eq(Call("w", F.Id("n"), F.Id("i")),
                    new Formula.Fraction(Call("d", Seq(F.Id("n"), Minus, F.Id("i"))),
                        Call("d", Next()))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Positive definiteness makes H invertible. Divide the "
                    + "multiplication identity by the positive denominator and apply the inverse."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("chain-endpoint-transfer"),
                DeclarationHandle.Create(Prefix + "chain_endpoint_transfer"),
                H("Endpoint transfer"),
                StatementSource.FromAuthor(Disp(Eq(Endpoint(),
                    new Formula.Fraction(D(1), Call("d", Next()))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The last coordinate has numerator d(0)=1."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("chain-endpoint-geometric-decay"),
                DeclarationHandle.Create(Prefix + "chain_endpoint_sq_le"),
                H("Exponential decay"),
                StatementSource.FromAuthor(Disp(Le(Pow(Endpoint(), D(2)),
                    new Formula.Fraction(D(1), Pow(D(9), Next()))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Taking reciprocals of the positive squared-denominator "
                    + "estimate gives the endpoint bound."))),
                DescribeRole.Theorem))));

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);

    private static Formula Pow(Formula value, Formula exponent) => Seq(value, Caret, Grp(exponent));

    private static Formula Add(Formula left, Formula right) => Seq(left, Plus, right);

    private static Formula Next() => Add(F.Id("n"), D(1));

    private static Formula Endpoint() => Call("w", F.Id("n"), F.Id("n"));

    private static Formula Indicator(Formula proposition) =>
        Seq(OpenBracket, proposition, CloseBracket);

    private static Formula Le(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);

    private static Formula Lt(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);

    private static Formula Eq(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);
}
