using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.StatisticalMechanics.HardCore;

internal sealed class ControllerShadowDocument : IScribeDocumentDefinition
{
    private static ScribeNode Entry(string id, string declaration, string title, string text,
        DescribeRole role) => Describe.Lean(DescribeId.Create(id),
        DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/ControllerShadow." + declaration),
        H(title), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
        Blocks(Paragraph(Text(text))), role);

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Transport state-dependent geometric controllers by replaying their coarse history.",
        H("Constructed controller shadows"),
        Blocks(
            Entry("hc-controller-trace", "controllerTrace", "Coarse history replay",
                "The newest-first direction history determines a coarse mask by replaying actual memoryStep updates. The function is total on illegal histories; only legal branches contribute to path counts.",
                DescribeRole.Definition),
            Entry("hc-lifted-policy", "liftedPolicy", "A constructed history policy",
                "The fine controller reads the replayed coarse mask. It never substitutes the current fine mask's projection for forgotten coarse history.",
                DescribeRole.Definition),
            Entry("hc-lifted-controller-refines", "lifted_controller_refines", "All-depth refinement",
                "For nested initial blocker sets and increasing radius, the explicitly constructed history policy has no more fine-memory descendants than the original coarse state policy. MemoryRefinement owns the synchronized-history comparison and is reused.",
                DescribeRole.Theorem),
            Entry("hc-coarse-shadow-projection-failure", "coarse_shadow_is_not_current_projection",
                "An exact legal geometric diagnostic",
                "The chronological SRL walk straight, straight, right, right is legal in both radii. The point (2,-1) remains in the radius-four state after projection into the radius-three disk, but the actual radius-three process has already forgotten it. The finite proof script requests kernel reduction.",
                DescribeRole.Theorem),
            Paragraph(Text("This source is a logically reviewed candidate. Lean elaboration, executed axiom closure and Scribe emission have not been obtained in the authoring runtime.")))));
}
