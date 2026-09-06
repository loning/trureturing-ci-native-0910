using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class BurnolRationalDepthBudgetDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/ZetaBridge/BurnolRationalDepthBudget.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Exact integer depth selection and rational support budgets for the existing full multi-orbit Weil family.",
        H("Rational Burnol Depth Budget"),
        Blocks(
            Describe.Lean(DescribeId.Create("burnol-rational-rationalquarterdepth"),
                DeclarationHandle.Create(Prefix + "rationalQuarterDepth"),
                H("Exact integer depth"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("This total function uses only natural arithmetic. Soundness requires d,p,q>0; no claim is made for zero denominators."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("burnol-rational-rationalburnolradius"),
                DeclarationHandle.Create(Prefix + "rationalBurnolRadius"),
                H("Rational support ledger"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("This computes the existing additive convolution support budget without selecting a new radius by compactness."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("burnol-rational-rationalquarterdepth-integer-sound"),
                DeclarationHandle.Create(Prefix + "rationalQuarterDepth_integer_sound"),
                H("Strict integer certificate"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use the strict next-power bound for the floor logarithm, and natural division with remainder. The strict inequality handles exact powers of four correctly."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("burnol-rational-rationalquarterdepth-real-sound"),
                DeclarationHandle.Create(Prefix + "rationalQuarterDepth_real_sound"),
                H("Certified geometric decay"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Cross multiplication is performed only after denominator positivity. This replaces a classical eventual-smallness threshold with an executable integer formula."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("burnol-rational-rationalquarterdepth-full-gram-margin"),
                DeclarationHandle.Create(Prefix + "rationalQuarterDepth_full_gram_margin"),
                H("The actual full Gram at the computed depth"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Apply the existing coefficient-uniform remainder, retaining all cross terms, and the analytic multiplicity floor one. A strictly negative conclusion additionally needs p/q<4 and a nonzero coefficient vector."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("burnol-rational-rationalburnol-support-and-margin"),
                DeclarationHandle.Create(Prefix + "rationalBurnol_support_and_margin"),
                H("One computable support and error budget"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The support certificates refer to the actual peak and killer functions. The analytic majorant upper bound remains explicit here and must be derived by the analytic budget owner; it is never replaced by an unverified numerical estimate."))), DescribeRole.Theorem)), []));
}
