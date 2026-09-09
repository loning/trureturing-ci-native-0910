using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.Probability;

internal sealed class CanonicalLiGrowthZeroFreeDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/Probability/CanonicalLiGrowthZeroFree.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Use the merged derivative-defined canonical Li sequence to prove actual xi zero-freeness from an all-index growth condition.",
        H("CanonicalLiGrowthZeroFree"), Blocks(
            Describe.Lean(DescribeId.Create("canonical-li-series"),
                DeclarationHandle.Create(Prefix + "canonicalLiSeries"), H("The actual canonical coefficient sum"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The coefficients are imported from CanonicalLiLocalExpansion. Their definition and indexing are unchanged."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("canonical-xi-disk"),
                DeclarationHandle.Create(Prefix + "canonicalXiDisk"), H("The actual xi function in disk coordinates"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("This is precisely xiReading composed with the standard inverse Mobius coordinate."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("canonical-xi-disk-analytic"),
                DeclarationHandle.Create(Prefix + "canonical_xi_disk_analytic"), H("Disk analyticity without a zero-location premise"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The entire original xiReading and the nonvanishing coordinate denominator prove analyticity on the entire unit disk."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("canonical-xi-disk-local-equation"),
                DeclarationHandle.Create(Prefix + "canonical_xi_disk_local_equation"), H("Consume the existing canonical local expansion"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The actual derivative chain rule and the merged all-order local series give F'=GF near zero, using only xi(1)=1/2 to justify local cancellation."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("canonical-li-summable-disk-zero-free"),
                DeclarationHandle.Create(Prefix + "canonical_li_summable_disk_zero_free"), H("Global disk equation and no zeros"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Absolute convergence at every smaller radius makes the same scalar sum analytic. The local equation extends and analytic orders exclude every disk zero."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("canonical-li-summable-right-half-plane"),
                DeclarationHandle.Create(Prefix + "canonical_li_summable_right_half_plane"), H("Actual open right-half-plane nonvanishing"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The inverse Mobius point lies in the unit disk precisely in the direction needed. Its round trip recovers the original complex argument."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("canonical-li-disk-summability-implies-rh"),
                DeclarationHandle.Create(Prefix + "canonical_li_disk_summability_implies_rh"), H("The standard RiemannHypothesis conclusion"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Existing actual xi-zero identification and right-half-strip reduction connect the no-zero result to Mathlib RiemannHypothesis. No supplied Li criterion is used."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("canonical-li-quadratic-growth-implies-rh"),
                DeclarationHandle.Create(Prefix + "canonical_li_quadratic_growth_implies_rh"), H("An explicit all-index growth condition suffices"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("An absolute quadratic bound on every actual canonical coefficient supplies the required disk convergence. The arithmetic bound itself is not proved here."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("canonical-li-probability-envelope-implies-rh"),
                DeclarationHandle.Create(Prefix + "canonical_li_probability_envelope_implies_rh"), H("Consumer for the prior probability envelope"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The input is the earlier probability route's exact output shape with its sequence identified as canonicalLiCoefficient. No candidate probability modules are copied into this branch."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("not-rh-forces-quadratic-escape"),
                DeclarationHandle.Create(Prefix + "not_rh_forces_quadratic_escape"), H("Every quadratic bound must fail under a failed RH"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The contrapositive produces an index exceeding any proposed absolute quadratic bound. It gives no finite cutoff for finding such an index."))), DescribeRole.Theorem))));
}
