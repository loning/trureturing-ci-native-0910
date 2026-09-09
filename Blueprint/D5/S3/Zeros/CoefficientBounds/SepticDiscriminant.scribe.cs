using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.CoefficientBounds;

internal sealed class SepticDiscriminantDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The cubic coefficient expression associated with two centered real septics has nonnegative discriminant.",
        H("Centered Septic Discriminant"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("centered-real-septic-discriminant"),
                DeclarationHandle.Create("D5/S3/Zeros/CoefficientBounds/SepticDiscriminant.centered_real_septic_discriminant"),
                H("Centered Real Septic Discriminant"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Both inputs are products of seven real linear factors, and each root list has zero sum. "
                    + "Write u, v, w and s for their coefficients of degrees five, four, three and one. "
                    + "Set A=-u, B=u^2+21w/5 and Z=-(2s+2uw/7-4v^2/35), with primed invariants for "
                    + "the second input. For a=7AA'/12, b=5BB'/294 and c=5ZZ'/32, the expression "
                    + "a^2b^2-4b^3-4a^3c-27c^2+18abc is nonnegative. The proof uses the frozen septic "
                    + "coefficient envelope, two Bernstein endpoint expansions, a product threshold of "
                    + "5/6 and a concavity identity. A vanishing A forces the sum of root squares, and "
                    + "hence every root, to vanish before normalization. Repeated and zero roots are included."))),
                DescribeRole.Theorem))));
}
