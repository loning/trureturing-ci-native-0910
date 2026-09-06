using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class ExplicitWeilFourthMomentTailDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/ZetaBridge/ExplicitWeilFourthMomentTail.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "An unconditional rational scalar tail for actual zeta zeros, with derived summability, analytic multiplicities and explicit endpoint conventions.",
        H("Explicit Fourth-Moment Tail of Actual Zeta Zeros"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("explicit-fourth-tail-fourth-tail-log-ceiling"),
                DeclarationHandle.Create(Prefix + "fourthTailLogCeiling"),
                H("Integer logarithm enclosure"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("This is a total natural arithmetic function. Its real-logarithm upper-bound theorem is proved below."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("explicit-fourth-tail-rational-fourth-moment-tail"),
                DeclarationHandle.Create(Prefix + "rationalFourthMomentTail"),
                H("Rational two-sided spectral tail"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("This computes a rational upper bound for the actual two-sided fourth moment when T>=5 and the excluded set contains the complex spectral ball T+1. It supplies no individual zero-location claim."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("explicit-fourth-tail-fourth-tail-budget"),
                DeclarationHandle.Create(Prefix + "fourthTailBudget"),
                H("Real finite-window budget"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("L encloses log(T+4), and A bounds actual local counts. The specialization uses the proved numerical coefficient 128."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("explicit-fourth-tail-zero-data-gamma-re"),
                DeclarationHandle.Create(Prefix + "zeroData_gamma_re"),
                H("Identify the actual ordinate"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Unfold the existing spectral parameter. No critical-line hypothesis is needed."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("explicit-fourth-tail-zero-data-large-window-count"),
                DeclarationHandle.Create(Prefix + "zeroData_large_window_count"),
                H("Transfer the numerical count without losing multiplicities"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Map indices injectively to actual zeta zeros, identify analytic multiplicities through ClassicExplicitFormula, and apply ExplicitLargeHeightZeroCount. Reindexing does not replicate zeros."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("explicit-fourth-tail-finite-inverse-fourth-tail-le"),
                DeclarationHandle.Create(Prefix + "finite_inverse_fourth_tail_le"),
                H("Local counts control every finite fourth-power tail"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use ceil(gamma)-1 on the positive side and floor(-gamma) on the negative side. Empty unit windows need no count hypothesis. Reuse the existing finite cubic telescoping bound, then use 1/|gamma|<=1/T. Each endpoint receives ordinary full weight exactly once."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("explicit-fourth-tail-ordinate-large-outside-spectral-ball"),
                DeclarationHandle.Create(Prefix + "ordinate_large_outside_spectral_ball"),
                H("Reconcile the complex and real cutoffs"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use the genuine critical strip bound |Im(gamma_n)|<=1/2 and the complex norm triangle bound. No real-zero assumption is introduced."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("explicit-fourth-tail-zero-data-fourth-moment-tail"),
                DeclarationHandle.Create(Prefix + "zeroData_fourth_moment_tail"),
                H("Derive both summability and the actual tail bound"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("All finite subsums are bounded by the proved numerical local count. Nonnegativity then gives summability and the same total bound. The theorem does not assume either of those conclusions."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("explicit-fourth-tail-fourth-tail-log-ceiling-sound"),
                DeclarationHandle.Create(Prefix + "fourthTailLogCeiling_sound"),
                H("Certify the integer enclosure"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Nat.log bounds T+4 by the next power of two. Apply log monotonicity and log(2)<=1. There is no floating-point logarithm."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("explicit-fourth-tail-rational-fourth-moment-tail-cast"),
                DeclarationHandle.Create(Prefix + "rationalFourthMomentTail_cast"),
                H("Exact rational-to-real semantics"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Rational casts commute with finite field arithmetic; the numerical factors agree exactly."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("explicit-fourth-tail-zero-data-fourth-moment-tail-rational"),
                DeclarationHandle.Create(Prefix + "zeroData_fourth_moment_tail_rational"),
                H("Close the scalar analytic tail premise"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Combine the actual count-to-tail theorem with the integer logarithm enclosure. This is a conservative proof from Jensen and finite telescoping, independent of externally asserted Lehman or BPT numerical bounds. Candidate source review is distinct from Lean kernel verification."))),
                DescribeRole.Theorem))));
}
