using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Analytic.SeriesInequalities;

internal sealed class Profile32ConcavityDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "An exact radical sign certificate and root coordinates for the cubic profile.",
        H("Cubic Profile Coordinates and Curvature Certificate"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("negative-curvature-numerator"),
                DeclarationHandle.Create(
                    "D5/S3/Analytic/SeriesInequalities/Profile32Concavity.curvature_numerator_neg"),
                H("The cleared curvature numerator is negative"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The proof factors the numerator into a negative rational factor and "
                    + "a strictly positive radical expression throughout the positive open "
                    + "unit interval. Its sign follows from a polynomial decomposition "
                    + "with nonnegative terms and a uniform remainder of 243. "
                    + "Profile32Calculus supplies the differential interpretation."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("original-profile-in-root-coordinates"),
                DeclarationHandle.Create(
                    "D5/S3/Analytic/SeriesInequalities/Profile32Concavity.profile32_chart"),
                H("Explicit coordinates preserve the original root-set profile"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The three distinct roots are constructed explicitly, their inverse-gap "
                    + "scores are evaluated, and their common positive scale is extracted. "
                    + "The weight comes from this change of coordinates; the original "
                    + "profile has exponent three halves inside the sum and negative four "
                    + "thirds outside, with no additional normalization."))),
                DescribeRole.Theorem))));
}
