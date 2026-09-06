using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class WeilBurnolFixedScaleTransportDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/ZetaBridge/WeilBurnolFixedScaleTransport.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "A constructed finite negative family fits in one common support window, and its uniform margin transfers to the existing completed Fourier multiplier with the exact pole correction.",
        H("Support-Controlled Negativity and Fixed-Scale Transport"),
        Blocks(
            Describe.Lean(DescribeId.Create("weil-fixed-scale-exact-pole-subtraction"),
                DeclarationHandle.Create(Prefix + "fixedScale_multiplier_re_eq_full_minus_pole"),
                H("Isolate the completed multiplier"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Take real parts of fixed_scale_weil_quadratic_form. The multiplier is exactly fixedScaleMultiplier from that owner. The nonnegative rank-one pole term is subtracted, with no new form or independent positivity assumption introduced."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("weil-common-support-full-negative-family"),
                DeclarationHandle.Create(Prefix + "exists_support_controlled_full_negative_family"),
                H("One support window for the entire negative family"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Construct the common Burnol packet, derive its support constants, and choose a common depth from the coefficient-uniform margin. Compact support is uniform over all coefficients at this chosen depth. Existence of an off-line frame is not asserted."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("weil-eventual-arithmetic-multiplier-margin"),
                DeclarationHandle.Create(Prefix + "eventually_burnol_fixedScale_multiplier_margin"),
                H("Transport the negative margin with its support cost"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The exact pole-subtraction identity transports the actual full-Gram bound. Both the support radius and the chosen threshold are uniform in coefficients. The ArchimedeanConvergent witness required by this branch's fixed-scale API remains explicit. This is an arithmetic negative certificate conditional on the given off-line frame, and supplies no proof of RH or prime-side positivity."))), DescribeRole.Theorem)), []));
}
