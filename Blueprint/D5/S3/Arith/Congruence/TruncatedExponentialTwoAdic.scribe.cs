using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.Congruence;

internal sealed class TruncatedExponentialTwoAdicDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/Congruence/TruncatedExponentialTwoAdic.";
    private const string SourceGid = "D5/L/ArithSums/luschny2026a398189";
    private static readonly LibraryNoteRef Source = LibraryNoteRef.Create(SourceGid);

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The odd-n, positive-k valuation formulas of OEIS A398189 hold outside its stated exception.",
        H("Binary Valuations of Truncated Schenker Sums"),
        Blocks(
            Paragraph(Text("All indices and factorial quotients are natural numbers. "
                + "The sum includes both endpoints, from zero through n-k. Odd n implies n is "
                + "positive. The theorem explicitly assumes 1 <= k <= n. The original k=0 "
                + "formula and the even-n branch are already proved background in "
                + "Amdeberhan, Callan and Moll (2013), Section 2.")),
            Describe.Lean(
                DescribeId.Create("truncated-schenker-sum"),
                DeclarationHandle.Create(Prefix + "S"),
                H("The truncated factorial sum"),
                StatementSource.FromLean(),
                AssessedProvenance.FromLiterature(Source),
                Blocks(Paragraph(Text("This is the defining integer sum of A398187. "
                    + "Its natural divisions are exact throughout the summation range, "
                    + "because j! divides (n-k)!."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("truncated-schenker-odd-positive-branches"),
                DeclarationHandle.Create(Prefix + "odd_positive_branches"),
                H("The two valuation branches for odd n and positive k"),
                StatementSource.FromLean(),
                AssessedProvenance.NovelAfterSearch(GidRef.Create(SourceGid), Source),
                Blocks(Paragraph(Text("For odd k the binary valuation is zero. "
                    + "For even k outside 14 modulo 16 it is the binary valuation of k+2. "
                    + "The proof first identifies the sum with H(0)=1 and "
                    + "H(m+1)=n^(m+1)+(m+1)H(m). Six recursive steps have a history "
                    + "coefficient divisible by 16. Odd powers have period four modulo 16, "
                    + "so this identity reduces every length at least six to residues. "
                    + "The shorter lengths are treated separately. The resulting residues "
                    + "are nonzero in the asserted range, so they determine the exact "
                    + "valuation. No formula is asserted for k congruent to 14 modulo 16."))),
                DescribeRole.Theorem))));
}
