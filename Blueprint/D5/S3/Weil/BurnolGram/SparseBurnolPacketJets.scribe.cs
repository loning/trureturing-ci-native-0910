using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.BurnolGram;

internal sealed class SparseBurnolPacketJetsDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/BurnolGram/SparseBurnolPacketJets.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Quantitative bounds for actual multi-orbit Weil tests, with explicit finite geometry and scalar spectral-tail premises.",
        H("SparseBurnolPacketJets"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("sparseburnolpacketjets-sparse-packet-exceptions"),
                DeclarationHandle.Create(Prefix + "sparsePacketExceptions"),
                H("Actual exception-only indices"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The existing quantitativePeakRadius is reused. The exceptional window is fixed after constructing the peak; it is independent of the later killer smoothing order."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("sparseburnolpacketjets-exists-sparse-burnol-packet-with-jets"),
                DeclarationHandle.Create(Prefix + "exists_sparse_burnol_packet_with_jets"),
                H("Construct the actual packet from finite geometry"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The existing dense target theorem constructs the unit peak. Its two jet budgets imply the existing explicit cutoff. Apply SparseEvenInterpolationJets to each signed target assignment and to the actual exception-only indices. Repeated exception nodes are allowed. No supplied packet, bump derivative, peak tail or existence-of-threshold premise is used. The finite geometric inequalities still require certified data."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sparseburnolpacketjets-sparse-packet-computed-support-margin-and-inertia"),
                DeclarationHandle.Create(Prefix + "sparse_packet_computed_support_margin_and_inertia"),
                H("Computed support, full margin and exact inertia"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use the packet constructor to discharge all support and jet premises of the direct Cauchy remainder theorem. The exact integer selector supplies the error budget at every later depth. Reuse the actual full Gram and its spectral inertia theorem. The positive scalar zero-tail estimate and its summability are explicit analytic premises; a literature citation is not substituted for their proofs. No off-line zero or RH is asserted."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sparseburnolpacketjets-rational-sparse-packet-cutoff"),
                DeclarationHandle.Create(Prefix + "rationalSparsePacketCutoff"),
                H("Rational cutoff evaluation"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("This arithmetic uses only rational operations and natural powers. It evaluates the existing real cutoff rather than defining another analytic cutoff."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("sparseburnolpacketjets-rational-sparse-packet-cutoff-cast"),
                DeclarationHandle.Create(Prefix + "rationalSparsePacketCutoff_cast"),
                H("Exact cutoff semantics"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use the existing rational interpolation-jet cast lemma; no numerical approximation or real logarithm enters."))),
                DescribeRole.Theorem)), []));
}
