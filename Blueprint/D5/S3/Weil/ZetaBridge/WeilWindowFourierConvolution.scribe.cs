using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class WeilWindowFourierConvolutionDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The actual zero-extended Fourier convolution yields the original arithmetic divided-sine tests, with diagonal and support cases kept explicit.",
        H("Window Fourier Convolution and Arithmetic Columns"),
        Blocks(
            Describe.Lean(DescribeId.Create("windowFourierMode"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution.windowFourierMode"),
                H("Zero-extended normalized Fourier mode"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The actual function is exp(2*pi*i*n*x/L)/sqrt(L) on (0,L] and zero elsewhere. The half-open convention fixes a representative; its endpoint values are not Sobolev traces. No formula for its convolution is built into this definition."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("windowCorrelation"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution.windowCorrelation"),
                H("The existing convolution product"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Uses the original Zeta23.EF.weilTest with the arguments in U_n-star times U_m order. It introduces neither a new convolution operation nor a replacement Weil operator."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("window_correlation_integrable"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution.window_correlation_integrable"),
                H("Existence at every real displacement"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The true product is an indicator of (max(0,y),min(L,L+y)] times a continuous exponential expression. This derives integrability for every displacement, including empty intersections, rather than assuming the original convolution exists."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("window_correlation_overlap"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution.window_correlation_overlap"),
                H("Actual moving-support integral"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("On the positive half-window, intersecting the two original supports gives (y,L]. The exact normalized integrand and both endpoint cases are retained. The denominator L is derived from the product of the two square-root normalizations."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("window_correlation_reflection"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution.window_correlation_reflection"),
                H("Reflection of the actual convolution"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Haar translation and conjugation of the original integral prove that changing the sign of the displacement exchanges the two modes and conjugates the result. This supplies the negative-frequency-side formula without postulating symmetry."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("window_correlation_translate"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution.window_correlation_translate"),
                H("Common translation preserves the test"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Translating both zero-extended functions by the same real amount leaves the existing weilTest unchanged. Taking the shift L/2 places the functions on the centered physical window while preserving their exponential phases."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("window_even_correlation_formula"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution.window_even_correlation_formula"),
                H("Separate diagonal and divided-sine cases"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The original even correlation equals the divided sine for distinct modes and equals 2*(1-y/L)*cos(2*pi*n*y/L) on the diagonal, for every y in [0,L]. The proof evaluates the moving-overlap exponential integral using the existing Mathlib theorem, including the endpoint periodicity and conjugate reflection. A totalized zero divided by zero is never used for the diagonal."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("window_correlation_outside"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution.window_correlation_outside"),
                H("Exact convolution support"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Both original supports fail to overlap outside [-L,L], so the actual convolution is zero there. The support is proved from the functions rather than imposed on the closed formula."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("coupling_column_window_convolution"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution.coupling_column_window_convolution"),
                H("Original arithmetic column from actual convolutions"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Consumes the existing singular-kernel theorem and substitutes the proved actual even convolution into all pole, Gamma and finite von Mangoldt terms of couplingColumn. The test is proved real-valued before its real part is used, and arbitrary complex trial coefficients remain. Only exterior rows are covered here. The regularized diagonal Gamma evaluation, canonical operator domain and a new quantitative eigenmode comparison are not conclusions."))), DescribeRole.Theorem)),
        [DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilBoundaryKernelIntegral"))]));
}
