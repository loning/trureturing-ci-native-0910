using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.GroundMode;

internal sealed class PaperFourierTransverseKernelDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Actual Fourier analytic bridge. Candidate proof source; no compiler or admission result is asserted.",
        H("PaperFourierTransverseKernel"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("paperfouriertransversekernel-transverseKernel"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseKernel.transverseKernel"),
                H("transverseKernel"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use Mathlib dslope of sinh at zero. This defines the actual derivative-completed cosine Fourier kernel, including the real-axis value."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("paperfouriertransversekernel-transverseKernel-zero-ordinate"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseKernel.transverseKernel_zero_ordinate"),
                H("transverseKernel zero ordinate"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Evaluate dslope on its diagonal and use the derivative of sinh. The result is the actual kernel -t*sin(x*t)."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransversekernel-ordinate-mul-transverseKernel"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseKernel.ordinate_mul_transverseKernel"),
                H("ordinate mul transverseKernel"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Reuse sub_smul_dslope and sinh(0)=0. Regroup scalar products. The identity holds even when the ordinate or support coordinate is zero."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransversekernel-transverseKernel-eq-div"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseKernel.transverseKernel_eq_div"),
                H("transverseKernel eq div"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Cancel only the explicitly nonzero ordinate in the preceding all-ordinate identity."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransversekernel-continuous-transverseKernel"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseKernel.continuous_transverseKernel"),
                H("continuous transverseKernel"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Prove continuity of the existing dslope via differentiability at zero and ordinary continuity elsewhere, then compose with the actual coordinates. No puncture at zero remains."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransversekernel-transverseKernel-neg-ordinate"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseKernel.transverseKernel_neg_ordinate"),
                H("transverseKernel neg ordinate"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Oddness of sinh makes its derivative-completed slope even, so changing the sign of the ordinate preserves the kernel."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paperfouriertransversekernel-abs-transverseKernel-le"),
                DeclarationHandle.Create("D5/S3/Weil/GroundMode/PaperFourierTransverseKernel.abs_transverseKernel_le"),
                H("abs transverseKernel le"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The mean-value inequality bounds abs(sinh(v)) by abs(v)*cosh(v). Monotonicity in absolute argument and the support/ordinate bounds give abs(t)*cosh(a*b). The support coordinate is retained for exact moment integration."))),
                DescribeRole.Theorem))));
}
