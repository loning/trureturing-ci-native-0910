using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.GroundMode;

internal sealed class PaperFourierTransverseBoundDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Actual Fourier analytic bridge. Candidate proof source; no compiler or admission result is asserted.",
        H("PaperFourierTransverseBound"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("paperfouriertransversebound-transverseKernel-square-integral-le"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseBound.transverseKernel_square_integral_le"),
                H("transverseKernel square integral le"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Square the pointwise kernel bound and integrate on the actual interval. Mathlib computes the second support moment exactly as 2*a^3/3, including a=0."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransversebound-transverse-integral-square-le"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseBound.transverse_integral_square_le"),
                H("transverse integral square le"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use actual MemLp.toLp representatives and the existing L2 Cauchy-Schwarz inequality. An indicator truncates the kernel, while the arbitrary error remains a full real-line L2 function. Pointwise support identifies the integrals."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransversebound-abs-transverse-integral-le"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseBound.abs_transverse_integral_le"),
                H("abs transverse integral le"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Transport the L2 squared-energy bound through the proved nonnegative support moment and take square roots with all signs justified."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransversebound-paperFT-ne-zero-of-transverse-margin"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseBound.paperFT_ne_zero_of_transverse_margin"),
                H("paperFT ne zero of transverse margin"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Derive L1 integrability of the supported L2 error internally. Combine the actual paperFT imaginary identity, integral linearity and the exact support-moment bound. Only the candidate transverse floor and genuine error budget remain inputs; no independent kernel identity or norm oracle is assumed."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransversebound-prime-three-transverse-norm-lt"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseBound.prime_three_transverse_norm_lt"),
                H("prime three transverse norm lt"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Prove exp(log(3)/4)^4=3, hence cosh(log(3)/4)^2=1/2+1/exp(log(3)/2). Bound the latter denominator below by 173/100 and log(3)/2 above by 11/20 using Mathlib logarithm inequalities. Exact rational arithmetic then gives the earlier 173/500 norm budget without a numerical certificate."))),
                DescribeRole.Theorem))));
}
