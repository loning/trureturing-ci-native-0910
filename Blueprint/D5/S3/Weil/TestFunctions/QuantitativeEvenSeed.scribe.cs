using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.TestFunctions;

internal sealed class QuantitativeEvenSeedDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/TestFunctions/QuantitativeEvenSeed.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "A normalized positive bump with radius h=1/(4(R+1)) has Fourier-Laplace norm at least one half at every node of norm at most R.",
        H("Explicit Nonvanishing Seed Radius"),
        Blocks(
            Describe.Lean(DescribeId.Create("quantitativeevenseed-radius-bump"),
                DeclarationHandle.Create(Prefix + "radiusBump"), H("Specified support radius"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The support radius is specified explicitly rather than selected from continuity of a transform."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("quantitativeevenseed-normalized-even-seed"),
                DeclarationHandle.Create(Prefix + "normalizedEvenSeed"), H("An actual admissible even seed"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Reuse the Mathlib normalized bump and the existing WeilTestFunction bundle. Smoothness, compactness and evenness are proved fields. Numerical evaluation still needs certified real-function computation."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("quantitativeevenseed-normalized-even-seed-integral"),
                DeclarationHandle.Create(Prefix + "normalizedEvenSeed_integral"), H("Unit complex mass"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Transport the existing normed-bump integral theorem through the real-to-complex map."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("quantitativeevenseed-normalized-even-seed-norm-integral"),
                DeclarationHandle.Create(Prefix + "normalizedEvenSeed_norm_integral"), H("Unit absolute mass"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The underlying bump is nonnegative, so its absolute integral equals its mass."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("quantitativeevenseed-normalized-even-seed-tsupport"),
                DeclarationHandle.Create(Prefix + "normalizedEvenSeed_tsupport"), H("Topological support is controlled"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use the exact bump support and take closure in the closed interval. Boundary points are included."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("quantitativeevenseed-fourier-laplace-sub-one-norm-le"),
                DeclarationHandle.Create(Prefix + "fourierLaplace_sub_one_norm_le"), H("A quantitative nonvanishing neighborhood"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Integrate the pointwise bound |exp(w)-1|<=2|w| for |w|<=1. The support certificate supplies |x|<=h. No unknown continuity radius is chosen."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("quantitativeevenseed-quantitative-seed-radius"),
                DeclarationHandle.Create(Prefix + "quantitativeSeedRadius"), H("An explicit arithmetic radius"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("A rational bound R produces a rational radius."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("quantitativeevenseed-quantitative-seed-radius-pos"),
                DeclarationHandle.Create(Prefix + "quantitativeSeedRadius_pos"), H("Radius positivity"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("All denominator signs are proved."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("quantitativeevenseed-quantitative-even-seed-transform-lower"),
                DeclarationHandle.Create(Prefix + "quantitativeEvenSeed_transform_lower"), H("Uniform normalization denominator"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The transform differs from one by at most one half, and the reverse triangle inequality gives the denominator lower bound. Higher derivative seminorms are separate quantitative inputs."))), DescribeRole.Theorem)), []));
}
