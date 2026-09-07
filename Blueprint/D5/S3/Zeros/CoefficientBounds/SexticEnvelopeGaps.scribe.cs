using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.CoefficientBounds;

internal sealed class SexticEnvelopeGapsDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The centered sextic envelope has exact positive-coefficient certificates in five nonnegative root gaps.",
        H("Sextic Envelope in Gap Coordinates"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("sextic-gap-envelope"),
                DeclarationHandle.Create("D5/S3/Zeros/CoefficientBounds/SexticEnvelopeGaps.gap_envelope"),
                H("Sextic Envelope in Gap Coordinates"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The five variables are one sixth of the successive gaps of sorted centered roots. "
                    + "The scalar formulas gapA, gapB and gapZ represent the three coefficient "
                    + "invariants. All six bounds hold for arbitrary nonnegative real gaps. The last two "
                    + "proof identities express four times the lower and upper residuals as 77760 and "
                    + "10077696 times polynomials with positive integer coefficients. Their expanded "
                    + "supports contain 185 and 922 monomials. Horner form keeps the exact certificates "
                    + "compact; ring checks the identities and positivity proves their signs. The "
                    + "consumer is SexticEnvelope.centered_real_sextic_envelope."))),
                DescribeRole.Theorem))));
}

