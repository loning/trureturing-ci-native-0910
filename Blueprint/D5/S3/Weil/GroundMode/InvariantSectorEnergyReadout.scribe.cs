using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.GroundMode;

internal sealed class InvariantSectorEnergyReadoutDocument : IScribeDocumentDefinition
{
    private const string Owner = "D5/S3/Weil/GroundMode/InvariantSectorEnergyReadout.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Candidate proofs. No Lean elaboration, transitive axiom audit or Scribe execution is asserted.",
        H("Invariant-Sector Energy Readouts"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("invariant-sector-energy-split"),
                DeclarationHandle.Create(Owner + "invariant_sector_energy_split"),
                H("Exact energy split on the actual domain"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The domain involution and its compatible Hilbert isometry commute with the actual action. The two half-sum components lie in the positive and negative symmetry sectors; their energies add exactly. No spectral gap, positivity, completeness or bounded extension of the action is used."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("invariant-sector-readout-lift"),
                DeclarationHandle.Create(Owner + "invariant_sector_readout_lift"),
                H("An invariant readout pays its own sector"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The fixed candidate and readout have the same pairings with the positive-sector component. Its certified energy-dual coefficient therefore applies on the entire candidate complement if the opposite sector has nonnegative shifted energy. No positive opposite-sector gap is divided by, and the full-space spectral gap is not enlarged. Exact opposite-sector nonnegativity remains essential."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("invariant-sector-readout-neighborhood"),
                DeclarationHandle.Create(Owner + "sector_readout_neighborhood"),
                H("Pay the complete frequency variation in the same sector"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The old centered readout coefficient and a genuine Riesz-vector norm variation produce the coefficient (1+s)C+(1+1/s)radius^2/kap. The same positive-sector coercivity pays the variation. This applies to the whole declared neighborhood once its norm variation is certified, not just to sampled frequencies."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("invariant-sector-centered-readout-variation"),
                DeclarationHandle.Create(Owner + "centered_readout_variation"),
                H("Retain the genuine-model ratio during variation"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For unit model e with nonzero origin readout, the centered Riesz difference is bounded by norm(g'-g)*(1+norm(g0)/abs(<g0,e>)). The changing model ratio is part of the exact vector identity. Its Fourier derivative specialization remains an explicit analytic input to the numerical disk consumer."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("invariant-sector-prime-three-budget"),
                DeclarationHandle.Create(Owner + "prime_three_invariant_sector_budget"),
                H("Exact arithmetic on the complete even-sector certificate"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The independently checked even threshold 1/1000 and complete centered residual imply coefficient below 49/20. A full disk variation of 8/5000 and Young parameter 1/30 give coefficient below 21/8. The inherited model-energy, global recentering and origin budgets imply normalized error below 7/50000. This theorem verifies rational implications only; the Schur/interval inputs are not kernel-attested by these numerals."))),
                DescribeRole.Theorem))));
}
