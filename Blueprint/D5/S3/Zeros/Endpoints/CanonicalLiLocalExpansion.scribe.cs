using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.Endpoints;

internal sealed class CanonicalLiLocalExpansionDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Canonical Li derivatives give the local xi logarithmic derivative series.",
        H("Canonical Li Local Expansion"),
        Blocks(
            Paragraph(Text(
                "The zeroth coefficient is zero. For n >= 0, lambda_(n+1) is the real part "
                + "of D^(n+1)[s^n log(xiReading(s))] at s=1, divided by n!. The principal "
                + "complex logarithm is analytic near that point because xiReading(1)=1/2. "
                + "This is the source Li derivative definition, not a definition by the "
                + "Taylor coefficients of the transformed generator.")),
            Describe.Lean(
                DescribeId.Create("canonical-li-derivatives"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonicalLiCoefficient"),
                H("Canonical coefficient sequence"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Successor indexing expresses the factorial normalization without a "
                    + "truncated subtraction at zero."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("li-generator"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.liGenerator"),
                H("Transformed logarithmic derivative"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "G(z)=(1-z)^(-2) logDeriv xiReading(1/(1-z)). "
                    + "The inverse-square presentation is algebraically the same as the "
                    + "integer power appearing in the final series theorem."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("all-order-li-coefficient-identity"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.generator_taylor_coefficient"),
                H("Every Taylor coefficient is the canonical Li coefficient"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The all-order Mobius derivative identity follows by induction from the "
                    + "higher product rule for multiplication by the coordinate. Conjugation "
                    + "of the entire xi reading makes the generator's derivatives at zero "
                    + "real, so each Taylor coefficient of the generator is the canonical Li "
                    + "coefficient of the next index."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("canonical-li-local-has-sum"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_local_expansion"),
                H("Local generating series"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Mathlib's complex Taylor convergence theorem applies on an analytic "
                    + "ball around zero. Replacing its coefficients by the preceding identity "
                    + "gives the canonical series without a Keiper-Li expansion hypothesis. "
                    + "The classical identity is not claimed as novel mathematics."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("canonical-li-zero"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_zero"),
                H("Zeroth coefficient"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The conventional initial value is zero."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("canonical-li-first-value"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_one"),
                H("Connection to the preceding first-coefficient layer"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The derivative definition gives exactly 1+gamma/2-log(2 sqrt(pi)), "
                    + "using first_li_coefficient_eq_log_deriv_re from "
                    + "FirstLiCoefficientPositivity. The preceding estimates are reused."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("canonical-li-first-positive"),
                DeclarationHandle.Create(
                    "D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion.canonical_li_one_pos"),
                H("Positive first coefficient"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The strict positivity of the first canonical Li coefficient transfers "
                    + "along the identity for its closed form. Together with the vanishing "
                    + "zeroth coefficient it supplies the initial values that the Li-Caratheodory "
                    + "identity takes as inputs."))),
                DescribeRole.Theorem)),
        []));
}
