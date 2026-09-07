using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.GroundMode;

internal sealed class PaperFourierTransverseIntegralDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Actual Fourier analytic bridge. Candidate proof source; no compiler or admission result is asserted.",
        H("PaperFourierTransverseIntegral"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("paperfouriertransverseintegral-paperFT-neg-of-even"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseIntegral.paperFT_neg_of_even"),
                H("paperFT neg of even"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Real reflection preserves Lebesgue integration. Apply the actual input evenness and retain the pre-existing Zeta23.paperFT convention."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransverseintegral-paperFT-eq-cosine-integral"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseIntegral.paperFT_eq_cosine_integral"),
                H("paperFT eq cosine integral"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Prove integrability of both exponential twists from the finite support and L1 assumption. Their average is the cosine kernel; reflection identifies their integrals. No replacement Fourier definition is introduced."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransverseintegral-integrable-mul-transverseKernel"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseIntegral.integrable_mul_transverseKernel"),
                H("integrable mul transverseKernel"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Continuity makes the kernel measurable and its explicit finite-support bound gives an L1 majorant. Smoothness or a zero boundary trace is unnecessary."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransverseintegral-paperFT-im-eq-ordinate-mul-integral"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseIntegral.paperFT_im_eq_ordinate_mul_integral"),
                H("paperFT im eq ordinate mul integral"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Commute the imaginary-part continuous linear map with the proved integrable cosine integral. Expand the actual complex cosine and use the all-ordinate kernel identity. The statement includes y=0."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransverseintegral-paperFT-divided-im-eq-integral"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseIntegral.paperFT_divided_im_eq_integral"),
                H("paperFT divided im eq integral"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For y nonzero, divide the proved all-ordinate identity. The regularized integral was defined independently of this quotient."))),
                DescribeRole.Theorem))));
}
