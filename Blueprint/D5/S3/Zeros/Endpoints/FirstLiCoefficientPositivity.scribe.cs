using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.Endpoints;

internal sealed class FirstLiCoefficientPositivityDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Public rational bounds certify strict positivity of the canonical first Li coefficient.",
        H("First Li Coefficient Positivity"),
        Blocks(
            Paragraph(Text(
                "These mathematical estimates already occur as local facts in the frozen "
                + "FirstLiCoefficientNormalization proof. The freezing rule prevents adding "
                + "public declarations to that module, so they are proved again here as "
                + "reusable public theorems. This contribution exposes an existing estimate; "
                + "it is not a new analytical theorem or a claim of literature novelty.")),
            Describe.Lean(
                DescribeId.Create("euler-mascheroni-lower-bound"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity."
                    + "eleven_twentieths_lt_eulerMascheroniConstant"),
                H("Euler-Mascheroni lower bound"),
                StatementSource.FromAuthor(Disp(new Formula.Relation(
                    new Formula.Fraction(Num(11), Num(20)), FormulaRelationOperator.LessThan,
                    Call("eulerMascheroniConstant")))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The twentieth lower approximant is bounded using the first fourteen "
                    + "terms of the exponential series at 3047/1000. This proves the "
                    + "preregistered strict lower bound and feeds the coefficient inequality."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("log-four-pi-upper-bound"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity."
                    + "log_four_pi_lt_fifty_one_twentieths"),
                H("Logarithmic upper bound"),
                StatementSource.FromAuthor(Disp(new Formula.Relation(
                    Call("log", Multiply(D(4), Pi)), FormulaRelationOperator.LessThan,
                    new Formula.Fraction(Num(51), Num(20))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The first ten terms of the exponential series at 51/20, together "
                    + "with the rational bound pi < 3.1416, prove the second preregistered "
                    + "estimate. Both numerical thresholds are unchanged."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("strict-first-li-positivity"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.first_li_coefficient_pos"),
                H("Strict positivity of the explicit coefficient"),
                StatementSource.FromAuthor(Disp(new Formula.Relation(
                    D(0), FormulaRelationOperator.LessThan, Coefficient()))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The two public rational estimates are consumed after rewriting the "
                    + "logarithm as half the logarithm of four pi. Their thresholds cancel "
                    + "exactly, and the strict inequalities give strict positivity. "
                    + "The argument does not infer a sign from nonvanishing."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("first-li-real-part-identification"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity."
                    + "first_li_coefficient_eq_log_deriv_re"),
                H("Identification with the canonical endpoint reading"),
                StatementSource.FromAuthor(Disp(Equal(Coefficient(), EndpointRealPart()))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Taking real parts of the first conjunct of the frozen normalization "
                    + "theorem gives this identity. It is a bind-only companion, consumed "
                    + "by the following strict endpoint inequality."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("positive-xi-endpoint-real-part"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/FirstLiCoefficientPositivity.xi_log_deriv_one_re_pos"),
                H("Positive real part at one"),
                StatementSource.FromAuthor(Disp(new Formula.Relation(
                    D(0), FormulaRelationOperator.LessThan, EndpointRealPart()))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The identity transports the explicit strict positivity to the "
                    + "canonical xi logarithmic derivative at one. The terminal use "
                    + "directly solves only the first Li coefficient positivity clause. "
                    + "It does not close an entire atom, prove the full Li criterion, "
                    + "or settle the Riemann hypothesis."))),
                DescribeRole.Theorem)),
        []));

    private static Formula Coefficient() => Subtract(
        Add(D(1), new Formula.Fraction(Call("eulerMascheroniConstant"), D(2))),
        Call("log", Multiply(D(2), Call("sqrt", Pi))));

    private static Formula EndpointRealPart() => Call("re", new Formula.Fraction(
        Call("deriv", F.Id("xiReading"), D(1)), Call("xiReading", D(1))));
}
