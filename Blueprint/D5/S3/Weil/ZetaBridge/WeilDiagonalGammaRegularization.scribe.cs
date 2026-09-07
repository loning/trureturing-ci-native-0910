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
                Blocks(Paragraph(Text("For any delta in [0,L], the absolute integral over (0,delta] is bounded by delta times the explicit regularized majorant. This enables a justified finite evaluator to retain the singular endpoint contribution. It supplies neither an interior evaluator nor a new actual prolate error certificate."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("diagonalGammaSeriesTerm"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization.diagonalGammaSeriesTerm"),
                H("Finite elementary relative-diagonal term"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The explicit term is the original positive Gamma resolvent contribution minus the finite-window correction. Its parameters are L, the integer Fourier index n, and the Gamma index j. It contains only real arithmetic and exp, without an infinite sum or integral. It is not an extracted, verified rational transcendental evaluator."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("diagonal_gamma_hasSum"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization.diagonal_gamma_hasSum"),
                H("Complete nonnegative diagonal series"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("An explicit triangular exponential-cosine primitive evaluates each term. The already-owned exponential kernel expansion, an integrable majorant and dominated convergence identify the entire sum with the difference of the two original regularized diagonal integrals. Nonnegative terms, absolute summability and all endpoint terms are derived."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("diagonal_gamma_series_error"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization.diagonal_gamma_series_error"),
                H("All omitted terms have an inverse-square budget"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Keeping Gamma indices zero through K inclusive yields a lower partial sum and an upper sum plus 2*(2*pi*n/L)^2/(4*K+3)^2. The positive inverse-cube term majorant is summed by an explicit telescope. The complete tail is retained, with K=0 and both signs of n allowed."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("diagonal_gamma_resolvent_window_bounds"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization.diagonal_gamma_resolvent_window_bounds"),
                H("Uniform finite-window correction"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The finite positive resolvent sum G obeys G-39/(4*L)<=E and E<=G+2*(2*pi*n/L)^2/(4*K+3)^2. The correction bound is uniform in the Fourier index. It follows from the explicit rational maximum 9/4 and the reciprocal-square prefix bound 13/3. This scalar diagonal fact does not imply full-matrix coercivity or control arbitrary cross terms."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("diagonal_gamma_finite_enclosure"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization.diagonal_gamma_finite_enclosure"),
                H("Finite rational certificate for the original diagonal difference"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Justified rational balls for the finite explicit terms and a rational absolute-frequency bound produce rational endpoints for the original integral difference. All term errors and all omitted Gamma terms enter the result. This is a small consumer of the analytic series theorem, not a new verified log, pi or exp implementation."))), DescribeRole.Theorem)),
        [DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution"))]));
}
