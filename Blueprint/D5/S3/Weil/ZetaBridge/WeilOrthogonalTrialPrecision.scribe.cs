using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class WeilOrthogonalTrialPrecisionDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Exact finite orthogonal correction with propagated coefficient enclosures and complete arithmetic residual-tail acceptance.",
        H("Orthogonal Trial Precision"),
        Blocks(
            Describe.Lean(DescribeId.Create("orthogonal-1"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilOrthogonalTrialPrecision.trialCorrection"), H("Finite self-pairing quotient"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Uses conjugation and field arithmetic on the exact finite candidate and trial. The denominator is the actual self-pairing; no rounded normalization factor or square-root normalization is substituted."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("orthogonal-2"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilOrthogonalTrialPrecision.orthogonalTrial"), H("Standard projected finite trial"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Uses Mathlib starProjection on the candidate orthogonal complement in the finite Euclidean coefficient space and extends the result by zero."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("orthogonal-3"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilOrthogonalTrialPrecision.orthogonal_trial_apply"), H("Coordinate formula for the standard projection"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Identifies the standard projection with the explicit rank-one correction using the existing singleton projection formula. Includes the totalized zero-candidate identity without claiming a positive precision denominator there."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("orthogonal-4"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilOrthogonalTrialPrecision.orthogonal_trial_constraints"), H("Constructed support and exact orthogonality"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The corrected trial is zero off the prescribed support and its complete finite candidate pairing is exactly zero. No orthogonality of the raw input is required."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("orthogonal-5"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilOrthogonalTrialPrecision.orthogonal_trial_synthesis"), H("Finite Hilbert synthesis bridge"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Reuses Mathlib Orthonormal.inner_sum to transfer the exact coefficient pairing to actual finite syntheses in any supplied orthonormal family. The canonical Fourier-family identification remains separate."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("orthogonal-6"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilOrthogonalTrialPrecision.orthogonal_trial_moment"), H("Update every weighted moment"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Every finite weighted moment changes by the same scalar correction times the corresponding candidate moment. Prior boundary cancellations cannot be reused without this update."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("orthogonal-7"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilOrthogonalTrialPrecision.orthogonal_trial_mem_subfield"), H("Preserved conjugation-stable coefficient field"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For exact coefficients in a conjugation-stable complex subfield, the output remains in that same field. This is a membership theorem, not an executed Gaussian-rational solver or a new Gram-Schmidt construction."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("orthogonal-8"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilOrthogonalTrialPrecision.orthogonal_trial_enclosures"), H("Correction and coefficient enclosures"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("An absolute residual of the scalar pairing equation and a strictly positive lower bound for the exact candidate squared norm bound the correction error. That error is then included in every corrected coefficient radius."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("orthogonal-9"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilOrthogonalTrialPrecision.orthogonal_trial_residual_certificate"), H("Same-trial orthogonality and full tail acceptance"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Combines the constructed exact support and pairing, the updated coefficient centers and radii, actual arithmetic-symbol enclosures and the existing rational checker. The same projected trial has a certified complete two-sided residual tail. Interior residuals, canonical operator-domain identification and complement coercivity are not supplied by this theorem."))), DescribeRole.Theorem)),
        [DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision"))]));
}
