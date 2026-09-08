using static StrataLint.Scribe.DefinitionDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S1.Phase;

internal sealed class CharacterAverageDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Every nonzero character of an irrational rotation has average zero at each initial phase.",
        H("Character Averages of Irrational Rotations"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("norm-character-sum-le"),
                DeclarationHandle.Create(
                    "D5/S1/Phase/CharacterAverage.norm_character_sum_le"),
                H("A bound independent of phase and sample size"),
                StatementSource.FromAuthor(BoundStatement()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "Let alpha be irrational, rho any real initial phase, m a nonzero integer, "
                        + "and N a natural number. The character sum has norm at most "
                        + "2 / |exp(2 pi i m alpha) - 1|, including when N is zero.")),
                    Paragraph(Text(
                        "If the rotation step were one, periodicity of the complex exponential "
                        + "would make m alpha an integer, contradicting irrationality. Each term "
                        + "factors into the initial phase, of norm one, and a power of this step. "
                        + "The finite geometric-sum identity and the triangle inequality give "
                        + "the stated bound."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("character-average-tendsto-zero"),
                DeclarationHandle.Create(
                    "D5/S1/Phase/CharacterAverage.character_average_tendsto_zero"),
                H("Vanishing average at every specified initial phase"),
                StatementSource.FromAuthor(LimitStatement()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "Divide the preceding bound by N. The resulting upper bound tends to "
                        + "zero, so the complex average tends to zero by the norm squeeze theorem. "
                        + "Lean's total division assigns value zero to the average at N = 0; "
                        + "this value does not affect the limit.")),
                    Paragraph(Text(
                        "This is the elementary character-average step of issue 6057. The "
                        + "formal derivation uses finite geometric sums and irrationality. "
                        + "The result is classical; repository provenance describes the formal "
                        + "derivation and makes no claim of mathematical novelty.")),
                    Paragraph(Text(
                        "Interval sampling limits, approximation of observables, and "
                        + "equidistribution are outside this statement. The zero character "
                        + "is excluded by the hypothesis on m."))),
                DescribeRole.Theorem))));

    private static Formula Character(Formula phase) =>
        F.Seq(F.Exp, F.Open, F.D(2), F.Pi, F.Sp, F.Id("I"), F.Sp,
            F.Id("m"), F.Sp, phase, F.Close);

    private static Formula CharacterSum() =>
        F.Seq(F.Sum, F.Underscore,
            F.Grp(F.D(0), F.Leq, F.Sp, F.Id("j"), F.Lt, F.Id("N")), F.Sp,
            Character(F.Seq(F.Open, F.Rho, F.Plus, F.Id("j"), F.Alpha, F.Close)));

    private static Formula Parameters() =>
        F.Seq(F.Forall, F.Sp, F.Alpha, F.InMacro,
            F.Mathbb, F.Grp(F.Id("R")), F.Setminus, F.Mathbb, F.Grp(F.Id("Q")),
            F.Comma, F.Sp, F.Rho, F.InMacro, F.Mathbb, F.Grp(F.Id("R")),
            F.Comma, F.Sp, F.Id("m"), F.InMacro, F.Mathbb, F.Grp(F.Id("Z")),
            F.Setminus, F.OpenBrace, F.D(0), F.CloseBrace, F.Comma, F.Sp);

    private static Formula BoundStatement() =>
        F.Disp(F.Seq(Parameters(), F.Forall, F.Sp, F.Id("N"), F.InMacro,
            F.Mathbb, F.Grp(F.Id("N")), F.Comma, F.Sp,
            new Formula.Norm(CharacterSum()), F.Leq,
            new Formula.Fraction(F.D(2),
                new Formula.Norm(F.Seq(Character(F.Alpha), F.Minus, F.D(1))))));

    private static Formula LimitStatement() =>
        F.Disp(F.Seq(Parameters(), F.Lim, F.Underscore,
            F.Grp(F.Id("N"), F.To, F.Infty), F.Sp,
            new Formula.Fraction(CharacterSum(), F.Id("N")), F.Eq, F.D(0)));
}
