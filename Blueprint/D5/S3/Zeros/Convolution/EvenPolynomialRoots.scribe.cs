using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.Convolution;

internal sealed class EvenPolynomialRootsDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Zeros/Convolution/EvenPolynomialRoots.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Expansion by two connects real splitting with nonnegative real roots.",
        H("Roots Under Expansion by Two"),
        Blocks(
            Paragraph(Text(
                "Mathlib's expand with parameter two is substitution of X^2. These two "
                    + "root-geometry implications are used by the conditional arbitrary-degree "
                    + "rectangular convolution theorem. They include repeated and zero roots.")),
            Describe.Lean(
                DescribeId.Create("splitting-after-expansion"),
                DeclarationHandle.Create(Prefix + "splits_expand_two"),
                H("From Nonnegative Roots to Real Splitting"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For a real polynomial p that splits over the reals, if every real root "
                        + "of p is nonnegative, then p(X^2) splits over the reals. Each factor "
                        + "X^2-a is split using the real square root of a. The zero polynomial "
                        + "is handled separately; monicity and a degree bound are not required."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("nonnegative-roots-by-descent"),
                DeclarationHandle.Create(Prefix + "nonnegative_roots_of_splits_expand_two"),
                H("Descent to Nonnegative Real Roots"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For a nonzero real polynomial p, real splitting of p(X^2) implies both "
                        + "real splitting of p and nonnegativity of every real root of p. "
                        + "A complex root of p is lifted to a complex square root. Splitting "
                        + "of p(X^2) forces that lift to be real, so the original root is a "
                        + "real square. The nonzero hypothesis excludes the zero polynomial."))),
                DescribeRole.Theorem))));
}
