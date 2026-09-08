using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.StatisticalMechanics.HardCore.Holomorphic;

internal sealed class LinearVolumeVarianceDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Uniform complex response bounds control actual discrete Gibbs fluctuations.",
        H("LinearVolumeVariance"),
        Blocks(
            Describe.Lean(DescribeId.Create("hc-variance-linearvolumevariance-complexMean"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/LinearVolumeVariance.complexMean"),
                H("complexMean"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Analytic continuation of the actual mean particle number. The denominator is the zeroth moment, already proved equal to the actual partition."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("hc-variance-linearvolumevariance-varianceConstant"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/LinearVolumeVariance.varianceConstant"),
                H("varianceConstant"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("One explicit sufficient variance coefficient, with no numerical sharpness claim. Its size comes from the inherited width epsilon = 10^-30."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("hc-variance-linearvolumevariance-complex-mean-differentiableAt"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/LinearVolumeVariance.complex_mean_differentiableAt"),
                H("complex mean differentiableAt"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The actual mean continuation is holomorphic on the inherited common tube. Polynomial moments and the already-proved actual nonzero denominator suffice."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-variance-linearvolumevariance-complex-mean-eq-log-response"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/LinearVolumeVariance.complex_mean_eq_log_response"),
                H("complex mean eq log response"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Connect the same analytic mean to the existing normalized logarithm; there is no division by activity and the origin remains included."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-variance-linearvolumevariance-complex-mean-norm-bound"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/LinearVolumeVariance.complex_mean_norm_bound"),
                H("complex mean norm bound"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The actual mean continuation has the inherited graph-size-linear norm bound."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-variance-linearvolumevariance-closed-cauchy-disk-subset"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/LinearVolumeVariance.closed_cauchy_disk_subset"),
                H("closed cauchy disk subset"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The closed Cauchy disk stays strictly inside the common activity tube, including disks centered at either endpoint of the real interval."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-variance-linearvolumevariance-complex-mean-deriv-bound"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/LinearVolumeVariance.complex_mean_deriv_bound"),
                H("complex mean deriv bound"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Apply Mathlib's Cauchy derivative estimate to the actual mean. The disk, its boundary bound, holomorphy and closed-disk continuity are all derived; no supplied Cauchy estimate or derivative bound is a theorem premise."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-variance-linearvolumevariance-variance-eq-scaled-complex-deriv"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/LinearVolumeVariance.variance_eq_scaled_complex_deriv"),
                H("variance eq scaled complex deriv"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The complex derivative yields the actual real Gibbs variance. This uses both fields' identical finite moments and the already-proved response identity; no unproved interchange of real and complex derivatives is used."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-variance-linearvolumevariance-grid-variance-linear-activity"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/LinearVolumeVariance.grid_variance_linear_activity"),
                H("grid variance linear activity"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The sharper intermediate bound retains the real activity factor. In particular it vanishes at zero without a separate division-by-lambda step."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-variance-linearvolumevariance-grid-variance-linear-volume"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/LinearVolumeVariance.grid_variance_linear_volume"),
                H("grid variance linear volume"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Actual finite-square-grid occupation variance grows at most linearly in volume, uniformly on the full closed interval [0,51/20]. The empty domain is included. The large explicit constant is sufficient, not sharp."))), DescribeRole.Theorem))));
}
