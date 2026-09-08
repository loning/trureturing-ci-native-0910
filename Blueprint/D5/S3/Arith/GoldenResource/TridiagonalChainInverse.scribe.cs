using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class TridiagonalChainInverseDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/GoldenResource/TridiagonalChainInverse.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The diagonal-four chain has integral denominators with geometric growth.",
        H("Tridiagonal Chain Inverse"),
        Blocks(
            Paragraph(Text("Let d(0)=1, d(1)=4, and d(n+2)=4d(n+1)-d(n). "
                + "The index n ranges over all natural numbers.")),
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
                DescribeRole.Theorem))));

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);

    private static Formula Pow(Formula value, Formula exponent) => Seq(value, Caret, Grp(exponent));

    private static Formula Le(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);

    private static Formula Lt(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);
}
