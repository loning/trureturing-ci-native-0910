using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.Probability;

internal sealed class AnalyticLogarithmicContinuationDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/Probability/AnalyticLogarithmicContinuation.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Classical analytic continuation preserves the actual scalar series and excludes zeros through analytic orders.",
        H("AnalyticLogarithmicContinuation"), Blocks(
            Describe.Lean(DescribeId.Create("quadratic-coefficients-summable"),
                DeclarationHandle.Create(Prefix + "quadratic_coefficients_summable"), H("All smaller radii have absolute convergence"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("A bound on every coefficient is compared with polynomial-weighted geometric series, including radius zero."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("scalar-series-analytic-unit-disk"),
                DeclarationHandle.Create(Prefix + "scalar_series_analytic_unit_disk"), H("Analyticity of the original scalar sum"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The existing formal scalar-series radius and analyticity theorems apply to the actual coefficient sum throughout the unit disk."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("analytic-linear-ode-zero-free"),
                DeclarationHandle.Create(Prefix + "analytic_linear_ode_zero_free"), H("A nonzero analytic solution stays nonzero"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("At a putative zero, differentiation lowers finite analytic order while multiplication by an analytic coefficient cannot. Connectedness and the nonzero initial value exclude infinite order."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("local-logarithmic-equation-zero-free"),
                DeclarationHandle.Create(Prefix + "local_logarithmic_equation_zero_free"), H("A local identity gives a global nonvanishing result"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The analytic identity theorem extends the original derivative equation from a germ. Neither a global logarithm nor an already zero-free domain is supplied."))), DescribeRole.Theorem))));
}
