using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.CoefficientBounds;

internal sealed class SepticEnvelopeGapsDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Centered septic invariants admit exact sign and lower-bound certificates in six root gaps.",
        H("Septic Envelope in Gap Coordinates"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("septic-gap-lower-bound"),
                DeclarationHandle.Create("D5/S3/Zeros/CoefficientBounds/SepticEnvelopeGaps.gap_z_lower"),
                H("Joint Lower Bound"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The six variables are one seventh of consecutive differences between sorted "
                    + "centered roots. The formulas gapA, gapB and gapZ have respectively 21, 114 "
                    + "and 321 positive-coefficient monomials. Their nonnegativity gives the three "
                    + "sign inequalities. The remainder 49A^2/20-B is (2401/40)(a^2-f^2)^2 plus "
                    + "a positive polynomial with 101 monomials. The joint lower remainder "
                    + "270Z-120AB+245A^3 has 438 positive-coefficient monomials, with smallest "
                    + "coefficient 420175. Horner expressions retain exact rational coefficients; "
                    + "ring checks the identities and positivity proves the signs for every "
                    + "nonnegative real gap tuple."))),
                DescribeRole.Theorem))));
}
