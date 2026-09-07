using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.Probability;

internal sealed class CanonicalLiDiskEquivalenceDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/Probability/CanonicalLiDiskEquivalence.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The actual canonical Li series has a full-disk convergence criterion equivalent to the standard Riemann hypothesis.",
        H("CanonicalLiDiskEquivalence"), Blocks(
            Describe.Lean(DescribeId.Create("disk-mobius-re-half"),
                DeclarationHandle.Create(Prefix + "disk_mobius_re_half"), H("Disk points map to the actual right half-plane"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The strict real-part inequality is derived from the original complex norm and the positive inverse denominator."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("rh-xi-disk-ne-zero"),
                DeclarationHandle.Create(Prefix + "rh_xi_disk_ne_zero"), H("RH supplies actual disk nonvanishing"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The existing xi/nontrivial-zero identity and the standard RiemannHypothesis predicate exclude a zero in the disk image."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("rh-li-generator-analytic"),
                DeclarationHandle.Create(Prefix + "rh_li_generator_analytic"), H("The existing generator is analytic on the disk"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("RH is used only in this forward direction to justify the actual logarithmic derivative everywhere in the disk."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("rh-canonical-li-global-expansion"),
                DeclarationHandle.Create(Prefix + "rh_canonical_li_global_expansion"), H("Globalize the proved canonical Taylor coefficients"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The merged all-order coefficient identification is inserted into the standard holomorphic Taylor theorem. No coefficients are redefined."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("rh-canonical-li-disk-summable"),
                DeclarationHandle.Create(Prefix + "rh_canonical_li_disk_summable"), H("Absolute convergence at every radius below one"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Finite-dimensional absolute summability converts the full complex Taylor series into the original weighted absolute coefficient sum."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("rh-iff-canonical-li-disk-summable"),
                DeclarationHandle.Create(Prefix + "rh_iff_canonical_li_disk_summable"), H("Close both directions of the canonical criterion"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The forward proof is combined with the prior analytic-order converse. Neither the arithmetic condition nor RH is asserted unconditionally."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("rh-iff-canonical-li-global-expansion"),
                DeclarationHandle.Create(Prefix + "rh_iff_canonical_li_global_expansion"), H("The actual full-disk expansion is equivalent to RH"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The conclusion concerns every point of the full disk, not a local germ or a finite coefficient prefix."))), DescribeRole.Theorem))));
}
