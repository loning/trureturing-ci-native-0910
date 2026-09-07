using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Analytic.Isolation;

internal sealed class EntireEvenSquareDescentDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Entire even functions descend uniquely through squaring, including the centered xi reading.",
        H("Entire Even Square Descent"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("entire-even-square-descent"),
                DeclarationHandle.Create(
                    "D5/S3/Analytic/Isolation/EntireEvenSquareDescent.entire_even_square_descent"),
                H("Unique entire descent"),
                StatementSource.FromAuthor(Disp(Seq(
                    Call(F.Id("Entire"), F.Id("f")), Land, Sp,
                    Call(F.Id("Even"), F.Id("f")), Rightarrow,
                    Exists, Bang, F.Id("F"), Colon,
                    Call(F.Id("Entire"), F.Id("F")), Land, Sp,
                    Forall, Sp, F.Id("b"), Comma,
                    Call(F.Id("F"), Seq(F.Id("b"), Caret, Grp(D(2)))), Eq,
                    Call(F.Id("f"), F.Id("b"))))),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "For an entire even function on the complex plane, choose the value at a "
                        + "square root of each argument. The two roots differ by sign, so evenness "
                        + "makes the choice irrelevant. Near each nonzero argument, the inverse "
                        + "function theorem supplies a differentiable local square root, and the "
                        + "candidate agrees with composition through that local inverse.")),
                    Paragraph(Text(
                        "At zero the principal square root is continuous. The candidate is therefore "
                        + "continuous at zero and differentiable in its punctured neighborhood. "
                        + "The removable singularity theorem gives analyticity at zero. Every complex "
                        + "number is a square, which proves uniqueness even among factors without a "
                        + "regularity assumption."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("xi-reading-square-descent"),
                DeclarationHandle.Create(
                    "D5/S3/Analytic/Isolation/EntireEvenSquareDescent.xi_reading_square_descent"),
                H("Centered xi descent and values"),
                StatementSource.FromAuthor(Disp(Seq(
                    Exists, Bang, F.Id("F"), Colon,
                    Call(F.Id("Entire"), F.Id("F")), Land, Sp,
                    Grp(Forall, Sp, F.Id("b"), Comma,
                        Call(F.Id("F"), Seq(F.Id("b"), Caret, Grp(D(2)))), Eq,
                        Call(F.Id("xiReading"), Seq(Half(), Plus, F.Id("b")))), Land, Sp,
                    Call(F.Id("F"), D(0)), Eq, Call(F.Id("xiReading"), Half()), Land, Sp,
                    Call(F.Id("F"), Seq(Frac, Grp(D(1)), Grp(D(4)))), Eq, Half()))),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "The frozen entire xi reading becomes even after translation by one half. "
                        + "Applying the general descent gives its unique entire factor. Substitution "
                        + "of zero gives the central value; substitution of one half and the frozen "
                        + "xi value at one give the value one half at one quarter.")),
                    Paragraph(Text(
                        "The result does not establish positivity of the central value, division by "
                        + "that value, Taylor coefficient identification, a theta representation, "
                        + "probability or moment identities, or a Riemann hypothesis equivalence."))),
                DescribeRole.Theorem))));

    private static Formula Half() => Seq(Frac, Grp(D(1)), Grp(D(2)));

    private static Formula Call(Formula function, params Formula[] arguments) =>
        new Formula.Apply(function, [.. arguments]);
}
