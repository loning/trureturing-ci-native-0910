using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.CoefficientBounds;

internal sealed class SepticEnvelopeUpperHighDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Positive coefficient certificates establish the septic joint upper bound.",
        H("Septic Joint Upper Bound"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("septic-upper-quadratic-coefficient"),
                DeclarationHandle.Create("D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperHigh.upper_coeff2_nonneg"),
                H("Quadratic Coefficient"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "In twelve times the septic joint upper remainder, the coefficients of powers "
                    + "two through six of the first gap have positive expansions with 489, 329, "
                    + "210, 117 and 60 monomials. Each coefficient is nonnegative for every "
                    + "nonnegative real five-tuple of the remaining gaps. The seven coefficient "
                    + "signs together yield the joint upper bound."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("septic-gap-upper-bound"),
                DeclarationHandle.Create("D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpperHigh.gap_z_upper"),
                H("Joint Upper Bound"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For six nonnegative real gaps, 9Z(49A^2-5B)<=10AB^2. Twelve times the "
                    + "remainder is a degree-ten polynomial with 2829 positive-coefficient "
                    + "monomials and smallest coefficient 4842432840. As a polynomial in the first "
                    + "gap, its seven coefficients have respectively 937, 687, 489, 329, 210, 117 "
                    + "and 60 monomials. Their exact positive expansions are checked separately. "
                    + "A univariate identity combines these coefficients into the full remainder. "
                    + "Their nonnegativity proves the bound, including vanishing gaps."))),
                DescribeRole.Theorem))));
}
