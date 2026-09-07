using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class WeilArithmeticResidualTailDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Exact trial moment cancellation yields a complete cubic squared-tail estimate for the actual arithmetic divided-difference column and an even readout.",
        H("Arithmetic Residual Tail"),
        Blocks(
            Describe.Lean(DescribeId.Create("item-1"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail.first_jet_moment_identity"), H("First jet and both complex moments"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Retains both finite complex moment sums before division by pi*m. Exterior estimates separately exclude zero and colliding frequencies."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("item-2"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail.first_jet_eq_zero_of_moments"), H("Exact boundary-moment cancellation"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The two trial moment equations annihilate the complete first jet. These equations are not imposed on the unknown eigenmode."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("item-3"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail.cancelled_arithmetic_column_bound"), H("All-mode inverse-square arithmetic bound"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Consumes the original arithmetic first-jet theorem and its independently proved prime-pole-Gamma envelope. The bound holds for every integer with absolute value at least twice the interior radius."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("item-4"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail.exteriorMode"), H("Signed exterior indices"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Parameterizes the positive indices M+j+1 and their negatives."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("item-5"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail.arithmeticResidualTail"), H("Combined residual coefficient"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The readout coefficient and actual arithmetic column are subtracted before the norm is taken. The theorem excludes all denominator poles. The physical operator-domain and basis identification remain separate."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("item-6"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail.residualTailBudget"), H("Explicit residual amplitude"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Uses the actual arithmetic budget, trial coefficient norms, support radius and complex readout numerator. There is no assumed residual bound in this expression."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("item-7"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail.arithmetic_residual_half_tail_bound"), H("Summable complete residual half-tail"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Proves square summability and the bound Q squared divided by 3*M cubed by reusing the existing inverse-fourth sum estimate. No terminal high-mode cutoff is introduced."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("item-8"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail.arithmetic_residual_two_sided_tail_bound"), H("Complete two-sided residual certificate"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Combines both infinite signs and proves the squared coefficient mass is at most 2*Q squared divided by 3*M cubed. This is an arithmetic coefficient statement; the canonical operator realization is not supplied by a finite numerical check."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("item-9"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail.exists_nonzero_arithmetic_moment_trial"), H("Nonzero finite trial satisfying all three constraints"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For any support with at least four indices and any candidate coefficients, constructs a finite nonzero function satisfying the boundary sum, the actual symbol moment and the candidate pairing. The finite-dimensional kernel argument permits dependent constraint rows. This is exact existence, not an executable transcendental solve or a quality guarantee."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("item-10"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail.exists_nonzero_trial_with_cubic_tail"), H("Nonzero feasible trial with full tail certificate"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Consumes the finite support construction in the actual two-sided residual estimate. Feasibility does not imply an optimal trial or the all-scale Weil/prolate approximation."))), DescribeRole.Theorem)),
        [DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticCouplingJet")),
         DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilEvenFourierObservationTail"))]));
}
