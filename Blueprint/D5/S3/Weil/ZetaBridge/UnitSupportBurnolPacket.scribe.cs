using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class UnitSupportBurnolPacketDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/ZetaBridge/UnitSupportBurnolPacket.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The actual packet can be reconstructed with B=K=1; localization support is N+2 and two peak seminorms give a numerical exceptional-radius test.",
        H("Unit Support and Explicit Peak Radius"),
        Blocks(
            Describe.Lean(DescribeId.Create("unitsupportburnolpacket-exists-unit-support-orbit-burnol-packet"),
                DeclarationHandle.Create(Prefix + "exists_unit_support_orbitBurnolPacket"),
                H("Construct both unit-support components"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Retain support from the stronger finite reflection-compatible interpolation theorem at both stages. All signed values, exception annihilation and tail properties are proved using the existing packet construction. No old arbitrary packet is claimed to have these radii."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("unitsupportburnolpacket-unit-support-burnol-radius"),
                DeclarationHandle.Create(Prefix + "unit_support_burnol_radius"),
                H("Specified final support radius"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Specialize the existing additive convolution support theorem to B=K=1. The radius is common to all coefficients."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("unitsupportburnolpacket-peak-tail-of-two-jet-budget"),
                DeclarationHandle.Create(Prefix + "peak_tail_of_two_jet_budget"),
                H("Explicit exceptional spectral radius"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use the derived two-jet closed-strip decay and the unconditional half-strip bound on gamma. The spectral-radius versus real-ordinate conversion is proved using the complex norm square. The finite target set must also be included when assembling a packet."))), DescribeRole.Theorem)), []));
}
