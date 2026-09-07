using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.Robin;

internal sealed class PaddingRatioDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/Robin/PaddingRatio.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Raising a bounded prime exponent gives an eventual strict relative sigma gain.",
        H("Prime Padding Ratio"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("padding-abundancy"),
                DeclarationHandle.Create(Prefix + "padding_abundancy"),
                H("Local divisor sum comparison"),
                StatementSource.FromLean(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For a prime p and natural bound A, padding multiplies n by "
                    + "p to the power A + 1 - factorization(n,p). On the exponent window "
                    + "factorization(n,p) <= A, the result is p^(A+1) times the "
                    + "prime-free complementary factor. Sigma multiplicativity cancels "
                    + "that common factor. The remaining local ratio is at most rho, "
                    + "the reciprocal geometric sum through A divided by the sum through A+1."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("padding-ratio"),
                DeclarationHandle.Create(Prefix + "padding_ratio"),
                H("Eventual strict relative gain"),
                StatementSource.FromLean(),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "Here robinRatio(n) is sigma_1(n) divided by "
                        + "exp(EulerMascheroniConstant) times n times log(log(n)), "
                        + "and paddingQ(p,A) is (1+rho)/2. The threshold depends on p and A. "
                        + "The theorem quantifies over every natural n above that threshold "
                        + "whose p-adic exponent is at most A.")),
                    Paragraph(Text(
                        "Mathlib's logarithmic perturbation limit controls the distortion "
                        + "of log(log(n)) under the bounded multiplicative padding. The "
                        + "Euler constant cancels from the relative comparison. This proof "
                        + "uses neither an absolute Robin bound nor a Gronwall envelope. "
                        + "The tail-mass estimate consumes this relative comparison."))),
                DescribeRole.Theorem))));
}
