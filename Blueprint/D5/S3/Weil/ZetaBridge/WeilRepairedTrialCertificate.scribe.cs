using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class WeilRepairedTrialCertificateDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Exact trial repair and recomputed rational moment budgets feed the existing complete arithmetic residual-tail checker.",
        H("Repaired Arithmetic Trial Certificate"),
        Blocks(
            Describe.Lean(DescribeId.Create("repair-1"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilRepairedTrialCertificate.rationalMomentBudgets"), H("Recomputed rational moments and mass"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Computes the unweighted moment bound, symbol-weighted moment bound with all symbol radii, and coefficient l1 upper bound from the stored output. Rectangular absolute sums enclose complex moduli."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("repair-2"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilRepairedTrialCertificate.rational_moment_budgets_sound"), H("Actual-symbol validity of computed budgets"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Proves all three computed bounds for the actual arithmetic boundary symbol from its per-index enclosures. No independent moment or coefficient-mass premise is requested."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("repair-4"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilRepairedTrialCertificate.repaired_arithmetic_residual_certificate"), H("Same-output complete tail certificate"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("A successful rational repair gives support and exact candidate orthogonality. The recomputed rational budgets, actual symbol and parameter enclosures, and the existing successful tail check imply square summability and the entire two-sided exterior bound for that same repaired trial. No actual arithmetic spectral instance or operator-domain realization is asserted."))), DescribeRole.Theorem)),
        [DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/FiniteRationalTrialRepair")),
         DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision"))]));
}
