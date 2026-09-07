using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.WeilObservables;

internal sealed class FiniteWeilObservableMixedFormDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/WeilObservables/FiniteWeilObservableMixedForm.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Every reduced mixed pairing has actual Weil-test representatives and is independent of their choice.",
        H("Mixed Pairings on the Observable Range"),
        Blocks(
            Describe.Lean(DescribeId.Create("reduced-mixed-pair-realization"),
                DeclarationHandle.Create(Prefix + "every_reduced_mixed_pairing_is_realized"),
                H("Realization of arbitrary reduced pairings"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Apply the existing finite interpolation surjection separately to both vectors, then use the existing mixed convolution factorization. Multiplicity is included once in B_T."))),
                DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("reduced-mixed-representative-independence"),
                DeclarationHandle.Create(Prefix + "truncated_mixed_pairing_independent_of_representatives"),
                H("Independence of representatives"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Factor both mixed sums through their observable vectors. The first slot remains linear and the second conjugate-linear."))),
                DescribeRole.Theorem)), []));
}
