using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.GroundMode;

internal sealed class GenuineModelDualTransportDocument : IScribeDocumentDefinition
{
    private const string Owner = "D5/S3/Weil/GroundMode/GenuineModelDualTransport.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Candidate domain-level proofs; Lean elaboration and Scribe emission have not been run.",
        H("Genuine Model Dual Transport"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("genuine-model-candidate-overlap-floor"),
                DeclarationHandle.Create(Owner + "candidate_overlap_floor"),
                H("The actual overlap is bounded away from zero"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Cauchy-Schwarz against the unit candidate and the reverse triangle inequality give 1-epsilon<=|<k,e>|. This is the denominator used by the hyperplane elimination, not a sampled angle."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("genuine-model-near-candidate-complement-coercivity"),
                DeclarationHandle.Create(Owner + "near_candidate_complement_coercivity"),
                H("Transfer coercivity to the genuine model"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For f orthogonal to e, subtract beta e with beta=<k,f>/<k,e> to obtain a k-orthogonal domain vector. Retain the exact norm and energy identities and the full model residual r=Ae-mu e. The resulting threshold is T-2*rho*epsilon/(1-epsilon), derived without assuming coercivity on e-perp. The actual model belongs to the operator domain; L2 proximity alone is insufficient."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("genuine-model-recentered-trial-residual-identity"),
                DeclarationHandle.Create(Owner + "recentered_trial_residual_identity"),
                H("Retain the infinite-support correction"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The trial v-<e,v>e stays in the actual linear domain and is e-orthogonal. Its full projected residual equals P_e(g-Mv+<e,v>*(Me-nu e)). No finite-support tail theorem is applied to this generally infinite-support repaired trial."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("genuine-model-recentered-trial-residual-bound"),
                DeclarationHandle.Create(Owner + "recentered_trial_residual_bound"),
                H("A complete transported residual budget"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use contraction of the e-complement projection, the old complete projected residual, the old raw residual component along k, and the same full model residual. Every term produced by moving the candidate direction is paid for."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("genuine-model-recentered-trial-objective-bound"),
                DeclarationHandle.Create(Owner + "recentered_trial_objective_bound"),
                H("Preserve the signed variational objective"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Expand the actual symmetric domain energy after repair. Both complex mixed terms are retained. The signed objective is not reclassified as a norm, and the model residual controls its unbounded-action contribution."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("genuine-model-recentered-dual-coefficient-bound"),
                DeclarationHandle.Create(Owner + "recentered_dual_coefficient_bound"),
                H("Consume in the existing energy-dual theorem"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The left expression is exactly the coefficient already consumed by CoerciveDualCertificate and ProjectiveEnergyDual in PR #5882. Independently certified finite-trial caps and the full genuine-model residual give its explicit upper bound. The new real prolate consumer uses the same fixed-window model certified in #5602; the numerical transport is not a new eigenvalue enclosure or an all-scale rate."))),
                DescribeRole.Theorem))));
}
