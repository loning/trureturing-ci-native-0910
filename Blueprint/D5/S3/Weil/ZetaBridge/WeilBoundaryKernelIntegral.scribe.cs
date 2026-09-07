using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class WeilBoundaryKernelIntegralDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The original arithmetic boundary symbol equals its singular Gamma/pole integral and finite prime sum, with the limit interchange justified.",
        H("Arithmetic Boundary Symbol and Singular Kernel"),
        Blocks(
            Describe.Lean(DescribeId.Create("gamma-kernel-sine-integrable"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundaryKernelIntegral.gamma_kernel_sine_integrable"),
                H("The sine test regularizes the Gamma endpoint"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For a positive finite window and any real frequency, the actual kernel exp(t/2)/(exp(t)-exp(-t)) times sin(w*t) is integrable on (0,L]. The proof derives the uniform bound abs(w)*exp(L/2) from t<=exp(t)-exp(-t) and abs(sin(w*t))<=abs(w)*t. It never assumes integrability of the singular kernel alone or removes a small interval."))),
                DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("gamma-boundary-integral"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundaryKernelIntegral.gamma_boundary_integral"),
                H("The complete Gamma series is the actual kernel integral"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The finite exponential sums converge pointwise to the kernel. The previous majorant dominates every sine-weighted partial sum, so standard dominated convergence applies. An explicitly differentiated primitive evaluates each term at the integer Fourier frequency. The existing arithmetic_boundary_symbol_bound supplies absolute convergence of the same original Gamma series. Uniqueness of limits proves equality without an integral-identity premise."))),
                DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("arithmetic-boundary-symbol-integral"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundaryKernelIntegral.arithmetic_boundary_symbol_integral"),
                H("Identify the original arithmetic symbol"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The two elementary exponential pole integrals combine to the negative of the existing poleSine term. Together with the full Gamma identity, this identifies arithmeticBoundarySymbol itself with the pole-minus-Gamma sine integral minus the unchanged finite von Mangoldt sum. Integrability of the combined integrand is a conclusion. No replacement arithmetic symbol is introduced."))),
                DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("coupling-column-kernel-integral"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundaryKernelIntegral.coupling_column_kernel_integral"),
                H("The existing exterior column has the integral representation"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For m outside the trial support, substitute the identified symbol into the original couplingColumn, use justified integral subtraction and constant division, and retain both the finite prime sum and the complex trial coefficients. This is a companion adapter of the analytic identity. The diagonal Fourier matrix elements, actual convolution of zero-extended basis functions and canonical operator-domain realization still require separate proofs; this theorem does not assert them or a new spectral error bound."))),
                DescribeRole.Theorem)),
        [DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticCouplingJet"))]));
}
