using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S0.Certificates;

internal sealed class MinkowskiNullConeRigidityDocument : IScribeDocumentDefinition
{
    private const string Module = "D5/S0/Certificates/MinkowskiNullConeRigidity.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Vanishing on the Minkowski null cone determines a real quadratic form up to a scalar.",
        H("Minkowski Null Cone Rigidity"),
        Blocks(
            Paragraph(DefinitionDsl.Text(
                "Let d be any natural number, let V be the product of the real line and "
                + "Euclidean d-space, and let S be any real quadratic form on V.")),
            Paragraph(Math(In(Seq(
                Subscript(F.Id("V"), F.Id("d")), Sp, Eq, Sp, Mathbb, Grp(F.Id("R")),
                Sp, Times, Sp, Mathbb, Grp(F.Id("R")), Caret, Grp(F.Id("d")), Comma, Sp,
                Subscript(F.Id("g"), F.Id("d")), Open, F.Id("t"), Comma, Sp,
                F.Id("w"), Close, Sp, Eq, Sp, Square(F.Id("t")), Sp, Minus, Sp,
                NormSquare(F.Id("w")), Comma, Sp,
                F.Id("e"), Sp, Eq, Sp, Pair(D(1), D(0)), Comma, Sp,
                F.Id("p"), Underscore, Grp(F.Id("S")), Open, F.Id("x"), Comma, Sp,
                F.Id("y"), Close, Sp, Eq, Sp,
                Apply(F.Id("S"), Seq(F.Id("x"), Plus, F.Id("y"))), Sp, Minus, Sp,
                Apply(F.Id("S"), F.Id("x")), Sp, Minus, Sp,
                Apply(F.Id("S"), F.Id("y")))))),
            Describe.Lean(
                DescribeId.Create("spatial-rigidity"),
                DeclarationHandle.Create(Module + "null_cone_spatial_rigidity"),
                H("Spatial restriction and mixed term"),
                StatementSource.FromAuthor(Disp(Seq(
                    Quantifiers(), NullCondition(F.Id("d")), Sp, Rightarrow, Sp,
                    Forall, Sp, F.Id("w"), Sp, InMacro, Sp,
                    Seq(Mathbb, Grp(F.Id("R")), Caret, Grp(F.Id("d"))), Comma, Sp,
                    Apply(F.Id("S"), Pair(D(0), F.Id("w"))), Sp, Eq, Sp,
                    Minus, Apply(F.Id("S"), F.Id("e")), NormSquare(F.Id("w")),
                    Sp, Land, Sp,
                    Apply(Subscript(F.Id("p"), F.Id("S")),
                        Seq(F.Id("e"), Comma, Sp, Pair(D(0), F.Id("w")))),
                    Sp, Eq, Sp, D(0)))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(DefinitionDsl.Text(
                    "Evaluate at the two null vectors with spatial coordinate w and time "
                    + "coordinates equal to plus and minus the norm of w. Adding the resulting "
                    + "equations fixes the spatial restriction. Subtracting them kills the mixed "
                    + "term when w is nonzero; the zero case follows from bilinearity."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("exact-scalar"),
                DeclarationHandle.Create(Module + "eq_smul_minkowski_of_null"),
                H("The time-axis value determines the scalar"),
                StatementSource.FromAuthor(Disp(Seq(
                    Quantifiers(), NullCondition(F.Id("d")), Sp, Rightarrow, Sp,
                    F.Id("S"), Sp, Eq, Sp, Apply(F.Id("S"), F.Id("e")), Sp,
                    Cdot, Sp, Subscript(F.Id("g"), F.Id("d"))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(DefinitionDsl.Text(
                    "Expand at a time-axis vector plus a spatial vector and substitute both "
                    + "spatial identities. The equality holds as an equality of quadratic forms."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("scalar-exists"),
                DeclarationHandle.Create(Module + "exists_smul_minkowski_of_null"),
                H("Proportionality on every dimension"),
                StatementSource.FromAuthor(Disp(Seq(
                    Quantifiers(), NullCondition(F.Id("d")), Sp, Rightarrow, Sp,
                    Exists, Sp, F.Id("f"), Sp, InMacro, Sp, Mathbb, Grp(F.Id("R")), Comma, Sp,
                    F.Id("S"), Sp, Eq, Sp, F.Id("f"), Sp, Cdot, Sp,
                    Subscript(F.Id("g"), F.Id("d"))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(DefinitionDsl.Text(
                    "The scalar is allowed to vanish. No lower bound on d is required."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("one-space-dimension"),
                DeclarationHandle.Create(Module + "no_one_space_dimension_counterexample"),
                H("One spatial dimension is already rigid"),
                StatementSource.FromAuthor(Disp(Seq(
                    Neg, Sp, Exists, Sp, F.Id("S"), Colon, Sp,
                    Forms(D(1)), Comma, Sp, Open,
                    NullCondition(D(1)), Sp, Land, Sp, Open,
                    Forall, Sp, F.Id("f"), Sp, InMacro, Sp, Mathbb, Grp(F.Id("R")), Comma, Sp,
                    F.Id("S"), Sp, Neq, Sp, F.Id("f"), Sp, Cdot, Sp,
                    Subscript(F.Id("g"), D(1)), Close, Close))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(DefinitionDsl.Text(
                    "The two null lines suffice in dimension two. A binary quadratic form "
                    + "vanishing on both has zero mixed coefficient and opposite diagonal "
                    + "coefficients. Thus no nonproportional example exists in one spatial dimension."))),
                DescribeRole.Theorem))));

    private static Formula Apply(Formula name, Formula argument) => Seq(name, Open, argument, Close);
    private static Formula Pair(Formula x, Formula y) => Seq(Open, x, Comma, Sp, y, Close);
    private static Formula Subscript(Formula name, Formula index) => Seq(name, Underscore, Grp(index));
    private static Formula Square(Formula x) => Seq(x, Caret, Grp(D(2)));
    private static Formula NormSquare(Formula x) => Square(Seq(Vert, Sp, x, Vert));

    private static Formula Forms(Formula d) => Seq(
        Operatorname, Grp(F.Id("QuadraticForm")), Open, Mathbb, Grp(F.Id("R")),
        Comma, Sp, Subscript(F.Id("V"), d), Close);

    private static Formula Quantifiers() => Seq(
        Forall, Sp, F.Id("d"), Sp, InMacro, Sp, Mathbb, Grp(F.Id("N")), Comma, Sp,
        Forall, Sp, F.Id("S"), Colon, Sp, Forms(F.Id("d")), Comma, Sp);

    private static Formula NullCondition(Formula d) => Seq(
        Open, Forall, Sp, F.Id("v"), Sp, InMacro, Sp, Subscript(F.Id("V"), d), Comma, Sp,
        Apply(Subscript(F.Id("g"), d), F.Id("v")), Sp, Eq, Sp, D(0), Sp, Rightarrow, Sp,
        Apply(F.Id("S"), F.Id("v")), Sp, Eq, Sp, D(0), Close);
}
