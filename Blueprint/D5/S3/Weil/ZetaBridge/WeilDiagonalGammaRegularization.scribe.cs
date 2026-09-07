using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class WeilDiagonalGammaRegularizationDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Regularize the actual diagonal window correlation before integration and control its relative Gamma energy and endpoint error.",
        H("Diagonal Gamma Regularization"),
        Blocks(
            Describe.Lean(DescribeId.Create("diagonalGammaIntegrand"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization.diagonalGammaIntegrand"),
                H("Original origin-subtracted diagonal integrand"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The numerator subtracts the actual even correlation at the origin, before singular division. The function is the already-owned windowCorrelation, not a new Weil operator. Its assigned value at the single endpoint is not its limiting value."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("diagonal_gamma_origin_subtraction"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization.diagonal_gamma_origin_subtraction"),
                H("Fix the actual diagonal subtraction"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The original even correlation is two at zero. Its triangular cosine formula identifies the precise regularized integrand on the whole retained interval. This is a companion application of the existing convolution theorem, not a new spectral claim."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("diagonal_gamma_integrable"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization.diagonal_gamma_integrable"),
                H("Integrability without an omitted endpoint"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The proof bounds the regularized baseline exponential remainder and the nonnegative cosine increment before taking integrals. It derives a finite explicit majorant depending on L and n and integrability on (0,L]. Raw singular terms are never integrated separately."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("diagonal_gamma_relative_energy"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization.diagonal_gamma_relative_energy"),
                H("Nonnegative relative Gamma energy"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Subtract the two integrable origin-regularized expressions for n and zero. The common subtraction cancels and yields the integral of 2*rho(t)*(1-t/L)*(1-cos(2*pi*n*t/L)). Its sign and the explicit upper bound exp(L/2)*(2*pi*n/L)^2*L^2/6 are proved. This is the increment of minus W_R relative to zero, not full Weil positivity, a spectral gap or monotonicity in arbitrary frequency pairs."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("diagonal_gamma_endpoint_error"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization.diagonal_gamma_endpoint_error"),
                H("Certified endpoint-strip budget"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For any delta in [0,L], the absolute integral over (0,delta] is bounded by delta times the explicit regularized majorant. This enables a justified finite evaluator to retain the singular endpoint contribution. It supplies neither an interior evaluator nor a new actual prolate error certificate."))), DescribeRole.Theorem)),
        [DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution"))]));
}
