using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class FiniteReflectionCompatibleWeilInterpolationDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/ZetaBridge/FiniteReflectionCompatibleWeilInterpolation.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Reflection-compatible finite zero data admit exact even Weil interpolation within a fixed unit support window.",
        H("Reflection-Compatible Finite Interpolation"),
        Blocks(
            Describe.Lean(DescribeId.Create("reflection-representative-invariance"),
                DeclarationHandle.Create(Prefix + "reflectionRep_reflection"),
                H("Representative invariance"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The existing representative is the minimum of a reflection pair. Reflection exchanges the two entries."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("reflection-representative-value"),
                DeclarationHandle.Create(Prefix + "reflectionRep_value"),
                H("Compatible values descend"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Split according to which index is the representative and apply compatibility."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("reflection-compatible-unit-support-interpolation"),
                DeclarationHandle.Create(Prefix + "even_weil_interpolation_on_finite_indices_unit_support"),
                H("Actual finite interpolation in a unit window"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use the existing reflection representative image and its sign-separation theorem, then the support-controlled polynomial interpolation. Transfer the values back using gamma injectivity and evenness."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("reflection-compatible-finite-interpolation"),
                DeclarationHandle.Create(Prefix + "even_weil_interpolation_on_finite_indices"),
                H("Original finite interpolation interface"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Forget the support conjunct of the stronger theorem. The previous public statement remains unchanged."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("reflection-compatible-finite-unit-peak"),
                DeclarationHandle.Create(Prefix + "exists_even_weil_finite_unit_peak"),
                H("Simultaneous unit values"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Specialize the compatible assignment to the constant one function."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("reflection-compatible-finite-unit-peak-support"),
                DeclarationHandle.Create(Prefix + "exists_even_weil_finite_unit_peak_unit_support"),
                H("The peak has specified support"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Retain the support conjunct when specializing to constant values. No uniform bound on derivative norms is claimed."))), DescribeRole.Theorem)), []));
}
