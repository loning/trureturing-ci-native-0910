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
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("genuine-model-positive-form-complement-coercivity"),
                DeclarationHandle.Create(Owner + "positive_form_complement_coercivity"),
                H("A positive shifted form controls the moving complement"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Use the independent whole-domain lower certificate for M=A-ell. Positivity at t*f+alpha*k derives the energy Young inequality. Orthogonal projection onto k-perp and the geometric distance to e give kappa*(1-epsilon^2)/(1+t)-delta*epsilon^2/t as a new coercivity bound. No norm of M(e), Rayleigh residual or graph-distance assumption occurs. The shifted positivity premise is additional to the earlier residual-based route and cannot be omitted."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("genuine-model-positive-form-readout-transport"),
                DeclarationHandle.Create(Owner + "positive_form_readout_transport"),
                H("Transport the existing directional inequality directly"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Consume the old full-residual energy-dual readout bound on k-perp. Decompose the same test vector into its old perpendicular and candidate components, retaining the old-candidate readout G. The positive-form comparison and derived new coercivity give an explicit coefficient on e-perp. This is inequality transport, not a claim that a repaired infinite-support trial has zero residual. The original full-residual certificate remains the input provider for C."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("genuine-model-positive-form-uniform-readout-bound"),
                DeclarationHandle.Create(Owner + "positive_form_uniform_readout_bound"),
                H("A quadratic relative-angle criterion for changing scales"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Choosing both balancing parameters equal to one proves a retained gap kappa/4 and coefficient 8*C+8*epsilon^2*G^2/kappa when epsilon^2*(kappa/2+delta)<=kappa/4. These uniform formulas contain no genuine-model graph residual. For a scale family, weighted C tending to zero and weighted epsilon^2*G^2/kappa tending to zero suffice for this readout bound to vanish, subject to the independently verified hypotheses. The actual arithmetic scale rates are not supplied by this theorem."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("genuine-model-prime-three-positive-form-budget"),
                DeclarationHandle.Create(Owner + "prime_three_positive_form_budget"),
                H("Exact arithmetic for the existing prime-three inputs"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("With the unchanged global lower bound, finite-candidate energy ceiling, genuine-model distance and old full-residual coefficient cap, the rational t=1/100000 and s=1/10000 retain more than 99997/100000 of the shifted gap and give coefficient below 5151/50. The stated true-model energy width then gives Fourier error below 681/1000000. This theorem checks implications between rational constants only. It does not regenerate or independently prove the inherited spectral, form-domain, Fourier or model certificates."))),
                DescribeRole.Theorem))));
}
