using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class IntegerFischerSelectorDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/GoldenResource/IntegerFischerSelector.";
    private static readonly LibraryNoteRef FischerSource =
        LibraryNoteRef.Create("D5/L/Arith/hornjohnson2012matrixanalysis");

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Fischer's determinant inequality gives a positive logarithmic loss independent of matrix dimension.",
        H("Integer Fischer Selector"),
        Blocks(
            Paragraph(Text("All index types are finite. Positive definiteness includes symmetry. "
                + "Integer matrices are included entrywise into real matrices. "
                + "The selected integer k is at least two, and the price p lies strictly between "
                + "log((k+1)/k) and log(k/(k-1)). Empty products equal one.")),
            Describe.Lean(
                DescribeId.Create("fischer-two-coordinate-block"),
                DeclarationHandle.Create(Prefix + "fischer_two_block"),
                H("A two-coordinate principal block"),
                StatementSource.FromLean(),
                AssessedProvenance.FromLiterature(FischerSource),
                Blocks(Paragraph(Text("For distinct indices i and j, retain their two by two "
                    + "principal determinant and multiply by the other diagonal entries. "
                    + "This bounds the full determinant from above. An elementary shear has "
                    + "determinant one and changes only one diagonal entry under congruence. "
                    + "Hadamard's inequality applied after this shear gives the stated bound."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("integer-fischer-multiplicative-gap"),
                DeclarationHandle.Create(Prefix + "integer_fischer_gap"),
                H("A nonzero integer entry forces a loss"),
                StatementSource.FromLean(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The square of a nonzero integer is at least one. "
                    + "Symmetry therefore lowers the two-coordinate determinant by at least one "
                    + "relative to its diagonal product. Multiplication by the positive "
                    + "diagonal entries yields the integer form of the bound."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("fischer-selector-gap-positive"),
                DeclarationHandle.Create(Prefix + "selectorGap_pos"),
                H("A positive margin depending on k and p"),
                StatementSource.FromLean(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The margin is the minimum of log(k/(k-1))-p, "
                    + "p-log((k+1)/k), and log(k squared)-log(k squared minus one). "
                    + "Each term is positive on the strict price interval. "
                    + "The definition contains no matrix dimension."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("integer-log-selector-uniform-gap"),
                DeclarationHandle.Create(Prefix + "integer_log_unique_maximum"),
                H("The scalar matrix is uniformly isolated"),
                StatementSource.FromLean(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The objective log(det(T))-p trace(T) is bounded above "
                    + "by the dimension times log(k)-p k. Every matrix distinct from k times "
                    + "the identity loses at least the positive margin. If a diagonal entry "
                    + "differs from k, sum the scalar selector inequalities and retain that "
                    + "entry's loss. If every diagonal entry equals k, a nonzero off-diagonal "
                    + "entry gives the two-coordinate Fischer loss. Taking logarithms cancels "
                    + "the remaining diagonal product, so this loss is independent of dimension."))),
                DescribeRole.Theorem))));
}
