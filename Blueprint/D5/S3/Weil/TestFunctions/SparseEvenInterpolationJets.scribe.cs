using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.TestFunctions;

internal sealed class SparseEvenInterpolationJetsDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Weil/TestFunctions/SparseEvenInterpolationJets.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Actual smooth sparse interpolation with explicit finite jet budgets and repeated exceptional nodes.",
        H("Sparse Even Interpolation and Quantitative Jets"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("sparse-even-squared-exception-polynomial"),
                DeclarationHandle.Create(Prefix + "squaredExceptionPolynomial"),
                H("Indexed exceptional annihilator"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The indexing type is finite. The node map may repeat values; no injectivity assumption is present."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("sparse-even-sparse-even-polynomial"),
                DeclarationHandle.Create(Prefix + "sparseEvenPolynomial"),
                H("Target-only normalized solve"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The denominator is evaluated only at targets. Exceptional-to-exceptional distances never occur."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("sparse-even-sparse-coefficient-budget"),
                DeclarationHandle.Create(Prefix + "sparseCoefficientBudget"),
                H("Finite coefficient budget"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("R bounds targets, Y bounds exceptions, sigma separates distinct squared targets, and tau separates each squared target from each squared exception."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("sparse-even-sparse-jet-budget"),
                DeclarationHandle.Create(Prefix + "sparseJetBudget"),
                H("Explicit derivative budget"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The derivative order includes the annihilator degree. Removing unnecessary gap assumptions does not remove the cost of enforcing exceptional zeros."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("sparse-even-squared-exception-polynomial-zero"),
                DeclarationHandle.Create(Prefix + "squaredExceptionPolynomial_zero"),
                H("Repeated exceptions are annihilated"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("One factor in the finite product vanishes. Repeated exception values are permitted."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sparse-even-squared-exception-polynomial-lower"),
                DeclarationHandle.Create(Prefix + "squaredExceptionPolynomial_lower"),
                H("Target denominator lower bound"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Multiply the certified nonnegative factor lower bounds. No separation between two exceptions is needed."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sparse-even-squared-exception-polynomial-unit-disk"),
                DeclarationHandle.Create(Prefix + "squaredExceptionPolynomial_unit_disk"),
                H("Annihilator disk bound"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Apply the triangle inequality to each factor and multiply. This is an estimate for the actual exception polynomial."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sparse-even-sparse-even-polynomial-target-value"),
                DeclarationHandle.Create(Prefix + "sparseEvenPolynomial_target_value"),
                H("Exact target interpolation"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The existing Mathlib Lagrange theorem returns the normalized target value; cancellation restores the prescribed value."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sparse-even-sparse-even-polynomial-exception-value"),
                DeclarationHandle.Create(Prefix + "sparseEvenPolynomial_exception_value"),
                H("Exact exceptional zeros"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The annihilator remains a factor of the final polynomial."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sparse-even-sparse-even-polynomial-coeff-bound"),
                DeclarationHandle.Create(Prefix + "sparseEvenPolynomial_coeff_bound"),
                H("Gautschi-type sparse coefficient control"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use the existing Lagrange disk product bound, the exception denominator lower bound and the unit-disk coefficient theorem. Gautschi (1962), Section 2 (2.1), and Section 3, Theorem 1 (3.1), supply the classical product mechanism."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sparse-even-sparse-even-polynomial-nat-degree-le"),
                DeclarationHandle.Create(Prefix + "sparseEvenPolynomial_natDegree_le"),
                H("Count the exceptional derivative cost"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The product degree is bounded by the sum of the exception count and the target interpolation degree. Zero target data and empty types are included."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sparse-even-exists-sparse-even-interpolant-with-explicit-jets"),
                DeclarationHandle.Create(Prefix + "exists_sparse_even_interpolant_with_explicit_jets"),
                H("Actual smooth sparse interpolation"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Construct the actual finite-box seed using q=2(d+e)+2 averages and apply the existing polynomial differential realization. The finiteBoxSeed budget proves all needed derivative estimates without any unknown bump seminorm. Vergne (2011), Section 1, records the classical box-spline derivative/finite-difference identity used by that owner. The result imposes no mutual exceptional separation. It assumes certified target and target-exception geometry and does not assert any off-line zeta zero exists."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sparse-even-rational-sparse-jet-budget"),
                DeclarationHandle.Create(Prefix + "rationalSparseJetBudget"),
                H("Rational execution"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The arithmetic is total. Its use as a bound requires the signs and actual geometric inequalities in the semantic theorem."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("sparse-even-rational-sparse-jet-budget-cast"),
                DeclarationHandle.Create(Prefix + "rationalSparseJetBudget_cast"),
                H("Exact real semantics of rational arithmetic"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The proof uses only rational cast homomorphisms. No floating-point rounding or external numerical oracle enters."))),
                DescribeRole.Theorem)), []));
}
