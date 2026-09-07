using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.Probability;

internal sealed class CanonicalLiRadiusObstructionDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/Probability/CanonicalLiRadiusObstruction.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "An actual xi disk zero obstructs every eventual canonical coefficient envelope beyond its radius.",
        H("CanonicalLiRadiusObstruction"), Blocks(
            Describe.Lean(DescribeId.Create("scalar-series-analytic-of-eventual-bound"),
                DeclarationHandle.Create(Prefix + "scalar_series_analytic_of_eventual_bound"), H("An eventual bound controls the analytic radius"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The pinned formal-series radius theorem uses the actual coefficients and permits an arbitrary finite initial segment."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("canonical-weighted-tail-bound-zero-free"),
                DeclarationHandle.Create(Prefix + "canonical_weighted_tail_bound_zero_free"), H("A tail envelope excludes actual disk zeros"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("At a positive radius at most one, the local actual-xi differential identity and the constructed analytic coefficient sum exclude every zero strictly inside that radius."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("disk-zero-forces-weighted-tail-escape"),
                DeclarationHandle.Create(Prefix + "disk_zero_forces_weighted_tail_escape"), H("Every tail exceeds every larger-radius envelope"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("A supplied actual disk zero forces unbounded weighted canonical coefficients in every tail. The radius is strictly larger than the zero modulus; no detection index bound is asserted."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("xi-zero-forces-weighted-tail-escape"),
                DeclarationHandle.Create(Prefix + "xi_zero_forces_weighted_tail_escape"), H("Retain the full actual xi zero coordinate"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The same conclusion is stated directly for xiReading and its exact Mobius image. The zero is never replaced by only its imaginary part."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("disk-zero-forces-exponential-escape"),
                DeclarationHandle.Create(Prefix + "disk_zero_forces_exponential_escape"), H("An interior zero gives a strict exponential rate"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Choose a radius strictly between the zero modulus and one. At that radius every constant envelope is exceeded arbitrarily far out. Existence of an actual interior zero is not asserted."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("rh-canonical-weighted-envelopes"),
                DeclarationHandle.Create(Prefix + "rh_canonical_weighted_envelopes"), H("RH supplies a bound at each smaller radius"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The complete absolute canonical coefficient sum provides a nonnegative bound on every weighted coefficient. The constant may depend on the radius."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("canonical-smaller-radius-summable"),
                DeclarationHandle.Create(Prefix + "canonical_smaller_radius_summable"), H("A larger-radius bound gives smaller-radius summability"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The proof retains the exact geometric factor (r/R) to compare the original absolute coefficient series with a convergent majorant."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("rh-iff-canonical-weighted-envelopes"),
                DeclarationHandle.Create(Prefix + "rh_iff_canonical_weighted_envelopes"), H("All-radius envelopes are equivalent to RH"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For every radius below one there must be a bound for all indices. No radius-independent constant, finite cutoff or unconditional arithmetic bound is supplied."))), DescribeRole.Theorem))));
}
