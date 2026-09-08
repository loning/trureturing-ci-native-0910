using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class TridiagonalChainInverseDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/GoldenResource/TridiagonalChainInverse.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The diagonal-four chain has a uniform positive quadratic bound and geometric denominators.",
        H("Tridiagonal Chain Inverse"),
        Blocks(
            Paragraph(Text("Let d(0)=1, d(1)=4, and d(n+2)=4d(n+1)-d(n). "
                + "The index n ranges over all natural numbers. H(m) is the real m by m matrix "
                + "with diagonal entries four, adjacent entries minus one, and all other entries zero. "
                + "Write E(n,x) for x transpose H(n+1)x, V(n,x) for the sum of all coordinate "
                + "squares, and A(n,x) for the sum of squared differences of adjacent coordinates. "
                + "The coordinates of x are indexed from zero through n.")),
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
                Blocks(Paragraph(Text("Iterate the factor-three bound from the initial value one."))),
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
                    + "When n is zero, the two endpoint terms coincide and the edge sum is empty."))),
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
                DescribeRole.Theorem))));

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);

    private static Formula Pow(Formula value, Formula exponent) => Seq(value, Caret, Grp(exponent));

    private static Formula Le(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);

    private static Formula Lt(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);

    private static Formula Eq(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);
}
