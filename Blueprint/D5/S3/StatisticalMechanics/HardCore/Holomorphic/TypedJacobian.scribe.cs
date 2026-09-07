using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.StatisticalMechanics.HardCore.Holomorphic;

internal sealed class TypedJacobianDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Explicit holomorphic hard-core coordinates and uniform complex neighborhoods.",
        H("TypedJacobian"),
        Blocks(
            Describe.Lean(DescribeId.Create("hc-holo-typedjacobian-messageProduct"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TypedJacobian.messageProduct"),
                H("messageProduct"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Product over precisely the retained children; an empty product is one."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("hc-holo-typedjacobian-logArgument"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TypedJacobian.logArgument"),
                H("logArgument"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The single log argument. It is positive on the real box and has no vanishing issue at activity zero, where it equals b0-a0."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("hc-holo-typedjacobian-rowMap"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TypedJacobian.rowMap"),
                H("rowMap"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Actual transformed hard-core map. There is no logarithm of the activity."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("hc-holo-typedjacobian-jacobianEntry"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TypedJacobian.jacobianEntry"),
                H("jacobianEntry"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Coefficients of the full differential in the child coordinates."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("hc-holo-typedjacobian-activityEntry"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TypedJacobian.activityEntry"),
                H("activityEntry"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Coefficient of activity variation in the same differential."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("hc-holo-typedjacobian-rowMap-hasDerivAt"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TypedJacobian.rowMap_hasDerivAt"),
                H("rowMap hasDerivAt"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The derivative along every differentiable complex input curve. Since both activity and all child tangent values are arbitrary, this identifies the full Jacobian, including mixed simultaneous input perturbations and all pruning sets."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-holo-typedjacobian-rowMap-differentiableAt"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TypedJacobian.rowMap_differentiableAt"),
                H("rowMap differentiableAt"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Joint holomorphy of the actual finite-dimensional map on its pole-free principal-log domain; it is not inferred just from a pointwise Jacobian fit."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-holo-typedjacobian-inverse-rowMap"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TypedJacobian.inverse_rowMap"),
                H("inverse rowMap"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Inverse coordinates return the actual vacancy recursion. Both possible rational poles are stated; the quantitative tube later excludes them uniformly."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("hc-holo-typedjacobian-jacobian-vacancy-identity"),
                DeclarationHandle.Create("D5/S3/StatisticalMechanics/HardCore/Holomorphic/TypedJacobian.jacobian_vacancy_identity"),
                H("jacobian vacancy identity"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The Jacobian entry is exactly the previously certified message ratio. This is a rational identity; no assumed derivative identification is used."))), DescribeRole.Theorem))));
}
