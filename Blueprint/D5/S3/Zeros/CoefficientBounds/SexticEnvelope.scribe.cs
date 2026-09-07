using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.CoefficientBounds;

internal sealed class SexticEnvelopeDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Every centered monic sextic with six real roots satisfies six sharp coefficient inequalities.",
        H("Centered Real Sextic Envelope"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("centered-real-sextic-envelope"),
                DeclarationHandle.Create("D5/S3/Zeros/CoefficientBounds/SexticEnvelope.centered_real_sextic_envelope"),
                H("Centered Real Sextic Envelope"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For the product of X minus each of six real roots with zero sum, let u, v, w and s "
                    + "be the coefficients of degrees four, three, two and zero. The invariants are A=-u, "
                    + "B=u^2+5w, and Z=-(2s+2uw/15-v^2/20). They satisfy A>=0, B>=0, B<=8A^2/3, Z>=0, "
                    + "64AB-144A^3<=225Z, and 45Z(8A^2-B)<=4AB^2. The enumeration is arbitrary and "
                    + "repeated roots are allowed. Mathlib sorting preserves the root sum and product; "
                    + "exact coefficient identities then apply the gap certificates. The Lean equality "
                    + "check proves that (X^2-h^2)^3 attains both joint bounds for every real h."))),
                DescribeRole.Theorem))));
}
