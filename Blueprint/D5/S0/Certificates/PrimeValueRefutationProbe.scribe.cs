using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S0.Certificates;

internal sealed class PrimeValueRefutationProbeDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Synthetic refutation admission fixture; no research novelty is claimed.",
        H("Prime Value Refutation Probe"),
        Blocks(Describe.Remark(
            DescribeId.Create("refuted-prime-value-claim"),
            DeclarationHandle.Create("D5/S0/Certificates/PrimeValueRefutationProbe.not_all_values_prime"),
            H("A composite value refutes the universal claim"),
            AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(
                "The closed definition all_values_prime states that n + 2 is prime for every natural n. The local theorem refutes exactly that claim: at n = 2 the value is 4, which is composite. Its expanded negation is definitionally equal to Not all_values_prime even though the definition is marked irreducible. No unrelated ordinary result is included.")))))));
}
