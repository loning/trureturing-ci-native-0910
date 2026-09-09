using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith;

internal sealed class ArtinSchreierQuadraticRootUniquenessDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "An equal constant coefficient selects at most one root of an Artin-Schreier quadratic.",
        H("Artin-Schreier Quadratic Root Uniqueness"),
        Blocks(Describe.Lean(
            DescribeId.Create("artin-schreier-quadratic-root-unique"),
            DeclarationHandle.Create(
                "D5/S3/Arith/ArtinSchreierQuadraticRootUniqueness.quadratic_root_unique"),
            H("Equal-constant roots coincide"),
            StatementSource.FromAuthor(Disp(Seq(
                Forall, Sp, F.Id("f"), Comma, Sp, F.Id("F"), Comma, Sp, F.Id("G"), Colon, Sp,
                Series(), Comma, Esc,
                Left, Open, new Formula.Power(F.Id("F"), D(2)), Plus, F.Id("F"), Eq, F.Id("f"),
                Sp, Land, Sp,
                new Formula.Power(F.Id("G"), D(2)), Plus, F.Id("G"), Eq, F.Id("f"),
                Sp, Land, Sp,
                Constant(F.Id("F")), Eq, Constant(F.Id("G")), Right, Close,
                Sp, Rightarrow, Sp, F.Id("F"), Eq, F.Id("G")))),
            AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(
                "Let D=F-G. Subtracting the two quadratic equations factors as "
                    + "D(F+G+1)=0. Equality of the constant coefficients makes D constant-free, "
                    + "so F+G+1 has constant coefficient one and is a unit. Cancelling that "
                    + "factor gives D=0 and hence F=G."))),
            DescribeRole.Theorem))));

    private static Formula Series() =>
        new Formula.Apply(Seq(Operatorname, Grp(F.Id("PowerSeries"))),
            [new Formula.Apply(Seq(Operatorname, Grp(F.Id("ZMod"))), [D(2)])]);

    private static Formula Constant(Formula value) =>
        new Formula.Apply(Seq(Operatorname, Grp(F.Id("constantCoeff"))), [value]);
}
