using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S0.Certificates;

internal sealed class PrimeValueOrdinaryProbeDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Synthetic ordinary-instance admission fixture; no research novelty is claimed.",
        H("Prime Value Ordinary Probe"),
        Blocks(Describe.Remark(
            DescribeId.Create("ordinary-prime-value"),
            DeclarationHandle.Create("D5/S0/Certificates/PrimeValueOrdinaryProbe.prime_at_zero"),
            H("One prime-valued input"),
            AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(
                "The polynomial n + 2 takes the prime value 2 at n = 0. The formal theorem reuses Mathlib's prime_two. This is a positive finite instance, with its own theorem declared as the terminal target. It does not refute a claim or establish that all polynomial values are prime.")))))));
}
