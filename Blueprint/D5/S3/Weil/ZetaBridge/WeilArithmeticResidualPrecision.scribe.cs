using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class WeilArithmeticResidualPrecisionDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Absolute input enclosures and an exact rational acceptance test control the complete arithmetic residual tail with nonzero boundary moments.",
        H("Arithmetic Residual Precision"),
        Blocks(
            Describe.Lean(DescribeId.Create("precision-1"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision.finite_moment_enclosures"), H("Moment enclosures with product errors"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The actual coefficient sum, symbol-weighted sum and coefficient mass are bounded from exact centers and absolute error radii. The product of coefficient and symbol radii is retained."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("precision-2"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision.precisionTailBound"), H("Mixed full-tail budget"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The squared two-sided budget is 2*(D squared/M + D*Q/M squared + Q squared/(3*M cubed)). The first and mixed terms account for nonzero moments."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("precision-3"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision.arithmetic_residual_defect_tail_bound"), H("Complete arithmetic tail with nonzero moments"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Uses the existing actual arithmetic column and first jet. A positive lower bound for pi, an upper arithmetic envelope, moment bounds and support/frequency separation imply square summability and the full two-sided tail bound. Neither exact moment cancellation nor the desired residual bound is assumed."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("precision-4"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision.rounded_arithmetic_residual_tail_bound"), H("Full propagation from finite-precision inputs"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Consumes coefficient and symbol enclosures, readout numerator and frequency enclosures, plus support bounds. The output is the unchanged arithmeticResidualTail on both infinite exterior signs. The source enclosures are explicit analytic obligations."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("precision-5"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision.precision_tail_bound_iff"), H("Exact acceptance boundary"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For positive cutoff, the budget inequality is equivalent to a polynomial inequality after clearing the positive denominator. The tolerance is a squared-tail budget; nonvanishing applications require an additional strict margin."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("precision-6"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision.precision_tail_bound_of_balance"), H("Precision and cutoff balance"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("D*M at most gamma*Q suffices for the stated cubic squared-tail budget. Fixed nonzero D cannot silently be assigned a uniform cubic rate as the cutoff grows."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("precision-7"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision.residualTailCheck"), H("Executable rational budget test"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Uses exact rational arithmetic to check nonnegative budgets, positive cutoff, support and frequency separation, and the polynomial acceptance inequality. A rejected envelope is not a disproof of the actual mathematical bound."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("precision-8"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision.residual_tail_check_sound"), H("Real-arithmetic soundness of the rational test"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("A true rational test gives the real cutoff conditions and tail-envelope inequality. It does not certify transcendental enclosures or an operator realization."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("precision-9"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision.rounded_residual_certificate_sound"), H("Actual residual certificate from enclosures and exact acceptance"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Combines the explicit analytic source enclosures with the rational test to bound all actual exterior residual coefficients. The successful test is not substituted for any source enclosure, interior residual or operator-domain proof."))), DescribeRole.Theorem)),
        [DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail"))]));
}
