using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S1.Digit;

internal sealed class PrimeDigitBaseClassificationDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Prime-digit bases exist exactly outside zero, one, four, six, and nine.",
        H("Prime-Digit Bases: OEIS A390088"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("prime-digit-base"),
                DeclarationHandle.Create("D5/S1/Digit/PrimeDigitBaseClassification.HasPrimeDigitBase"),
                H("Existence of a prime-digit base"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "A nonzero natural number has a prime-digit base when some integer base "
                    + "greater than one gives only prime digits. Zero is explicitly excluded "
                    + "because its Lean digit list is empty."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("uniform-certificates"),
                DeclarationHandle.Create(
                    "D5/S1/Digit/PrimeDigitBaseClassification.prime_digit_base_certificate"),
                H("Two uniform certificates"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every n at least ten, parity gives an explicit base: "
                    + "(n - 2) / 2 for even n and (n - 3) / 2 for odd n. "
                    + "The corresponding little-endian digit lists are [2, 2] and [3, 2]. "
                    + "The proof establishes the base and digit bounds for arbitrary n."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("zero-set-classification"),
                DeclarationHandle.Create("D5/S1/Digit/PrimeDigitBaseClassification.a390088"),
                H("The five exceptions"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This proves the existence form of Felix Huber's October 29, 2025 "
                    + "conjecture in OEIS A390088: exactly 0, 1, 4, 6, and 9 have no such "
                    + "base. The uniform certificates cover every n at least ten. "
                    + "Below ten, 2, 3, 5, and 7 use one prime digit, while 8 uses base 3. "
                    + "For the nonzero exceptions, bases above n give the nonprime "
                    + "singleton [n], and the remaining bases are checked finitely. "
                    + "No least-base assertion is made."))),
                DescribeRole.Theorem))));
}
