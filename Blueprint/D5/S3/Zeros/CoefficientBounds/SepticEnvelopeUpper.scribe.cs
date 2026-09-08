using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.CoefficientBounds;

internal sealed class SepticEnvelopeUpperDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The joint upper bound for centered septic invariants has a positive degree-ten gap certificate.",
        H("Septic Joint Upper Bound"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("septic-gap-upper-bound"),
                DeclarationHandle.Create("D5/S3/Zeros/CoefficientBounds/SepticEnvelopeUpper.gap_z_upper"),
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
