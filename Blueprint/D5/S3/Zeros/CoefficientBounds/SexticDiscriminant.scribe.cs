using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.CoefficientBounds;

internal sealed class SexticDiscriminantDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The cubic coefficient expression associated with two centered real sextics has nonnegative discriminant.",
        H("Centered Sextic Discriminant"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("centered-real-sextic-discriminant"),
                DeclarationHandle.Create("D5/S3/Zeros/CoefficientBounds/SexticDiscriminant.centered_real_sextic_discriminant"),
                H("Centered Real Sextic Discriminant"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Both inputs are products of six real linear factors, and each root list has zero sum. "
                    + "Their invariants are A=-u, B=u^2+5w and Z=-(2s+2uw/15-v^2/20), with primed "
                    + "invariants for the second input. Set a=24AA'/35, b=2BB'/105 and c=4ZZ'/7. "
                    + "Then a^2b^2-4b^3-4a^3c-27c^2+18abc is nonnegative. The proof uses the frozen "
                    + "coefficient envelope, two positive Bernstein endpoint certificates and a concave "
                    + "quadratic identity. When A vanishes, the zero sum of root squares forces every "
                    + "root to vanish; the same argument applies to the second input. Arbitrary real "
                    + "roots and repeated roots are included."))),
                DescribeRole.Theorem))));
}
