using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil;

internal sealed class GronwallLowerEnvelopeDocument : IScribeDocumentDefinition
{
    private static readonly LibraryNoteRef Gronwall =
        LibraryNoteRef.Create("D5/L/gronwall1913asymptotic");

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Powers of primorials attain the sharp lower Gronwall envelope, "
        + "and the logarithmic Robin margin has lower limit zero.",
        H("Gronwall Envelopes"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("gronwall-lower-envelope"),
                DeclarationHandle.Create(
                    "D5/S3/Weil/GronwallLowerEnvelope.gronwall_lower_envelope"),
                H("Arbitrarily Large Near-Maximal Divisor Sums"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromLiterature(Gronwall),
                Blocks(Paragraph(Text(
                    "For every positive epsilon and every natural threshold, a power of a "
                    + "primorial reaches the normalized level one minus epsilon above that "
                    + "threshold. A geometric factor controls the reciprocal prime-power "
                    + "error uniformly. The denominator uses the Chebyshev upper bound, "
                    + "and the leading constant comes from Mertens' third theorem."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("gronwall-two-envelopes"),
                DeclarationHandle.Create(
                    "D5/S3/Weil/GronwallLowerEnvelope.gronwall_envelopes"),
                H("The Two Sharp Envelopes"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromLiterature(Gronwall),
                Blocks(Paragraph(Text(
                    "The existing eventual upper envelope and the arbitrarily large "
                    + "lower witnesses are packaged with the same positive epsilon. "
                    + "These are the two epsilon conditions for the normalized Gronwall "
                    + "limsup to equal one."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("robin-log-margin-liminf"),
                DeclarationHandle.Create(
                    "D5/S3/Weil/GronwallLowerEnvelope.robin_log_margin_liminf"),
                H("The Logarithmic Robin Margin Has Lower Limit Zero"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The margin is gamma plus log log log n minus log(sigma(n)/n). "
                    + "For n at least 5041 it equals the negative logarithm of the "
                    + "normalized Robin ratio. The eventual upper Gronwall envelope "
                    + "gives lower limit at least zero; the arbitrarily late lower "
                    + "witnesses give lower limit at most zero. This companion "
                    + "corollary is unconditional and asserts no Robin criterion "
                    + "equivalent to the Riemann hypothesis."))),
                DescribeRole.Theorem)),
        []));
}
