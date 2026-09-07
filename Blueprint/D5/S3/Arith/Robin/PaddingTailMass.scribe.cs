using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.Robin;

internal sealed class PaddingTailMassDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/Robin/PaddingTailMass.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Prime padding bounds tail mass and yields escape given finite-set mass escape.",
        H("Padding Tail Mass"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("padding-tail-mass"),
                DeclarationHandle.Create(Prefix + "padding_tail_mass"),
                H("Uniform tail mass estimate"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "The weights are zero for n <= 5040 and otherwise equal "
                        + "n^(-2) times robinRatio(n)^r. The partition function is their "
                        + "infinite sum, and waveMass divides the sum on a set by this "
                        + "partition function. Summability and positivity are assumed "
                        + "for every real parameter r >= 0.")),
                    Paragraph(Text(
                        "For each fixed prime p and natural A, one threshold N >= 5041 "
                        + "works for every r >= 0. The mass of n >= N with exponent at "
                        + "most A is bounded by (A+1) p^(2(A+1)) q^r, where q is "
                        + "paddingQ(p,A) and lies strictly between zero and one. "
                        + "The map n to (factorization(n,p), padding(p,A,n)) is injective; "
                        + "its first coordinate has A+1 possible values. Mathlib's "
                        + "injective infinite-sum comparison gives the multiplicity cost."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("bounded-exponent-mass-escape"),
                DeclarationHandle.Create(Prefix + "bounded_exponent_mass_tendsto_zero"),
                H("Window escape with an explicit finite-set premise"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "FiniteMassEscape requires the mass of every finite set of "
                        + "integers above 5040 to tend to zero as the real parameter "
                        + "tends to positive infinity. Splitting a bounded-exponent "
                        + "window at N gives a finite initial part and the tail bounded "
                        + "by the preceding theorem. Both bounds tend to zero.")),
                    Paragraph(Text(
                        "The source consumer motivates this conditional result. "
                        + "No theorem in these modules derives FiniteMassEscape from "
                        + "the Riemann hypothesis. Summability, positive normalization, "
                        + "and that finite-set premise remain explicit hypotheses; "
                        + "the RH version of the source corollary is not claimed closed."))),
                DescribeRole.Theorem))));
}
