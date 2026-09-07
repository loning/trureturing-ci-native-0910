using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.StatisticalMechanics.HardCore.Holomorphic;

internal sealed class TubeEstimatesDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Explicit holomorphic hard-core coordinates and uniform complex neighborhoods.",
        H("TubeEstimates"),
        Blocks(
            Describe.Lean(DescribeId.Create("hc-holo-tubeestimates-delta"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TubeEstimates.delta"),
                H("delta"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("One width for every message type. It is deliberately conservative."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("hc-holo-tubeestimates-epsilon"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TubeEstimates.epsilon"),
                H("epsilon"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("One activity width for every finite domain and every pruning pattern."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("hc-holo-tubeestimates-width-arithmetic"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TubeEstimates.width_arithmetic"),
                H("width arithmetic"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The exact numerical margins used below."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-holo-tubeestimates-normalized-inverse-bound"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TubeEstimates.normalized_inverse_bound"),
                H("normalized inverse bound"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("A pole-free normalized Mobius increment controls the inverse coordinate."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-holo-tubeestimates-inverse-tube"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TubeEstimates.inverse_tube"),
                H("inverse tube"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Every inverse chart is pole-free and stays close to its real interval. All three coefficient bounds are concrete numerical requirements, later checked on the actual Lean-owned coefficient table."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-holo-tubeestimates-product-four-bound"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TubeEstimates.product_four_bound"),
                H("product four bound"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("One finite-product estimate covers three-child rows and the four-child root."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-holo-tubeestimates-quotient-difference"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TubeEstimates.quotient_difference"),
                H("quotient difference"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Stable division, with the two concrete denominator floors used for the log argument."))), DescribeRole.Theorem))));
}
